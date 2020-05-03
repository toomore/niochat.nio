import SwiftUI

struct ExDivider: View {
    let color: Color = .accentColor
    let width: CGFloat = 3
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct MessageComposerView: View {
    @Environment (\.colorScheme) var colorScheme
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    @Environment(\.sizeCategory) var sizeCategory

    @Binding var message: String
    @Binding var showAttachmentPicker: Bool

    var onCommit: () -> Void

    var highlightMessage: String?
    var onCancel: () -> Void

    var textColor: Color {
        .primaryText(for: colorScheme, with: colorSchemeContrast)
    }

    var backgroundColor: Color {
        colorScheme == .light ? Color(#colorLiteral(red: 0.9332506061, green: 0.937307477, blue: 0.9410644174, alpha: 1)) : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    }

    var gradient: LinearGradient {
        let color: Color = backgroundColor
        let colors: [Color]
        if colorScheme == .dark {
            colors = [color.opacity(1.0), color.opacity(0.85)]
        } else {
            colors = [color.opacity(0.85), color.opacity(1.0)]
        }
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var background: some View {
        RoundedRectangle(cornerRadius: 15.0 * sizeCategory.scalingFactor)
            .fill(gradient).opacity(0.9)
    }

    var body: some View {
        VStack {
            if self.highlightMessage != nil {
                Divider()
                HStack {
                    ExDivider()
                        .background(Color.accentColor)
                    VStack {
                        HStack {
                            Text(L10n.Composer.editMessage)
                                .frame(alignment: .leading)
                                .padding(.leading, 10)
                                .foregroundColor(.accentColor)
                            Spacer()
                            Button(action: {
                                self.onCancel()
                            }, label: {
                                Image(systemName: "multiply")
                                    .font(.system(size: 20))
                                    .accessibility(label: Text(L10n.Composer.AccessibilityLabel.cancelEdit))
                            })
                        }
                        Text(highlightMessage!)
                            .lineLimit(2)
                            .padding([.horizontal, .bottom], 10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: Alignment.leading)
                    }
                }.fixedSize(horizontal: false, vertical: true)
            }
            HStack {
                Button(action: {
                    self.showAttachmentPicker.toggle()
                }, label: {
                    Image(Asset.Icon.paperclip.name)
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .accessibility(label: Text(L10n.Composer.AccessibilityLabel.sendFile))
                })

                ZStack {
                    if message.isEmpty {
                        Text(L10n.Composer.newMessage)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, -2)
                    }
                    MultilineTextField("", text: $message, onCommit: nil)
                        .padding(.horizontal)
                        .background(background)
                    }
                Button(action: {
                    self.onCommit()
                }, label: {
                    Image(Asset.Icon.paperplane.name)
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .accessibility(label: Text(L10n.Composer.AccessibilityLabel.send))
                })
                .disabled(message.isEmpty)
            }
        }
    }
}

struct MessageComposerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageComposerView(message: .constant(""),
                                showAttachmentPicker: .constant(false),
                                onCommit: {}, onCancel: {})
                .padding()
                .environment(\.colorScheme, .light)
            ZStack {
                MessageComposerView(message: .constant("Message to edit"),
                                    showAttachmentPicker: .constant(true),
                                    onCommit: {},
                                    highlightMessage: "Message to edit",
                                    onCancel: {})
                    .padding()
                    .environment(\.colorScheme, .light)
            }
            ZStack {
                Color.black.frame(height: 80)
                MessageComposerView(message: .constant(""),
                                    showAttachmentPicker: .constant(false),
                                    onCommit: {}, onCancel: {})
                    .padding()
                    .environment(\.colorScheme, .dark)
            }
            ZStack {
                Color.black.frame(height: 152)
                MessageComposerView(message: .constant("Message to edit"),
                                    showAttachmentPicker: .constant(true),
                                    onCommit: {},
                                    highlightMessage: "Message to edit",
                                    onCancel: {})
                    .padding()
                    .environment(\.colorScheme, .dark)
            }
        }
        .accentColor(.purple)
        .previewLayout(.sizeThatFits)
    }
}
