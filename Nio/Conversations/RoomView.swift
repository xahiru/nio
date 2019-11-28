import SwiftUI
import Combine
import KeyboardObserving
import SwiftMatrixSDK

struct RoomContainerView: View {
    @EnvironmentObject var store: MatrixStore<AppState, AppAction>

    @ObservedObject var room: NIORoom

    var body: some View {
        RoomView(
            events: room.events(),
            isDirect: room.isDirect,
            onCommit: { message in
                self.room.send(text: message)
            }
        )
        .navigationBarTitle(Text(room.summary.displayname ?? ""), displayMode: .inline)
        .keyboardObserving()
        .onAppear { self.room.markAllAsRead() }
    }
}

struct RoomView: View {
    var events: [MXEvent]
    var isDirect: Bool

    var onCommit: (String) -> Void

    @State private var message = ""

    var body: some View {
        VStack {
            ReverseList(events) { event in
                EventContainerView(event: event, isDirect: self.isDirect)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }

            MessageComposerView(message: $message,
                                onCommit: send)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
    }

    private func send() {
        onCommit(message)
        message = ""
    }
}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ConversationView()
//                .accentColor(.purple)
//                .navigationBarTitle("Morpheus", displayMode: .inline)
//        }
//    }
//}