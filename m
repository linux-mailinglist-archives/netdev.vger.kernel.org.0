Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22F013390F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 03:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgAHCS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 21:18:27 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33064 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgAHCS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 21:18:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id CD6734B0F0;
        Wed,  8 Jan 2020 13:18:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1578449902; bh=ylYWD
        7Xe9I/ZsgntS9btA6lHucRMs8iv+U0vz4kbnH4=; b=jklnSTePe6AYdjdEV/4lu
        V3qmTB051UPwAE2DhSF2XQ02u/MGpzCG0y+L723u0Oa20y66jkQGNSWiMR2lRlfR
        UzEY5fIJWiR3e0UIaWsGrdqtzcq0EM2/y2CK+h3M5hOsOEkmJNARt7u6bHnNLw4z
        egIcJjyomLUfnCLKUOXBTw=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5M3J2wBIwRKi; Wed,  8 Jan 2020 13:18:22 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 09B834B0F1;
        Wed,  8 Jan 2020 13:18:21 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 9080F4B0F0;
        Wed,  8 Jan 2020 13:18:20 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix link overflow issue at socket shutdown
Date:   Wed,  8 Jan 2020 09:18:15 +0700
Message-Id: <20200108021815.24713-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a socket is suddenly shutdown or released, it will reject all the
unreceived messages in its receive queue. This applies to a connected
socket too, whereas there is only one 'FIN' message required to be sent
back to its peer in this case.

In case there are many messages in the queue and/or some connections
with such messages are shutdown at the same time, the link layer will
easily get overflowed at the 'TIPC_SYSTEM_IMPORTANCE' backlog level
because of the message rejections. As a result, the link will be taken
down. Moreover, immediately when the link is re-established, the socket
layer can continue to reject the messages and the same issue happens...

The commit refactors the '__tipc_shutdown()' function to only send one
'FIN' in the situation mentioned above. For the connectionless case, it
is unavoidable but usually there is no rejections for such socket
messages because they are 'dest-droppable' by default.

In addition, the new code makes the other socket states clear
(e.g.'TIPC_LISTEN') and treats as a separate case to avoid misbehaving.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/socket.c | 53 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 6552f986774c..6ebd809ef207 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -287,12 +287,12 @@ static void tipc_sk_respond(struct sock *sk, struct sk_buff *skb, int err)
  *
  * Caller must hold socket lock
  */
-static void tsk_rej_rx_queue(struct sock *sk)
+static void tsk_rej_rx_queue(struct sock *sk, int error)
 {
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&sk->sk_receive_queue)))
-		tipc_sk_respond(sk, skb, TIPC_ERR_NO_PORT);
+		tipc_sk_respond(sk, skb, error);
 }
 
 static bool tipc_sk_connected(struct sock *sk)
@@ -545,34 +545,45 @@ static void __tipc_shutdown(struct socket *sock, int error)
 	/* Remove pending SYN */
 	__skb_queue_purge(&sk->sk_write_queue);
 
-	/* Reject all unreceived messages, except on an active connection
-	 * (which disconnects locally & sends a 'FIN+' to peer).
-	 */
-	while ((skb = __skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		if (TIPC_SKB_CB(skb)->bytes_read) {
-			kfree_skb(skb);
-			continue;
-		}
-		if (!tipc_sk_type_connectionless(sk) &&
-		    sk->sk_state != TIPC_DISCONNECTING) {
-			tipc_set_sk_state(sk, TIPC_DISCONNECTING);
-			tipc_node_remove_conn(net, dnode, tsk->portid);
-		}
-		tipc_sk_respond(sk, skb, error);
+	/* Remove partially received buffer if any */
+	skb = skb_peek(&sk->sk_receive_queue);
+	if (skb && TIPC_SKB_CB(skb)->bytes_read) {
+		__skb_unlink(skb, &sk->sk_receive_queue);
+		kfree_skb(skb);
 	}
 
-	if (tipc_sk_type_connectionless(sk))
+	/* Reject all unreceived messages if connectionless */
+	if (tipc_sk_type_connectionless(sk)) {
+		tsk_rej_rx_queue(sk, error);
 		return;
+	}
 
-	if (sk->sk_state != TIPC_DISCONNECTING) {
+	switch (sk->sk_state) {
+	case TIPC_CONNECTING:
+	case TIPC_ESTABLISHED:
+		tipc_set_sk_state(sk, TIPC_DISCONNECTING);
+		tipc_node_remove_conn(net, dnode, tsk->portid);
+		/* Send a FIN+/- to its peer */
+		skb = __skb_dequeue(&sk->sk_receive_queue);
+		if (skb) {
+			__skb_queue_purge(&sk->sk_receive_queue);
+			tipc_sk_respond(sk, skb, error);
+			break;
+		}
 		skb = tipc_msg_create(TIPC_CRITICAL_IMPORTANCE,
 				      TIPC_CONN_MSG, SHORT_H_SIZE, 0, dnode,
 				      tsk_own_node(tsk), tsk_peer_port(tsk),
 				      tsk->portid, error);
 		if (skb)
 			tipc_node_xmit_skb(net, skb, dnode, tsk->portid);
-		tipc_node_remove_conn(net, dnode, tsk->portid);
-		tipc_set_sk_state(sk, TIPC_DISCONNECTING);
+		break;
+	case TIPC_LISTEN:
+		/* Reject all SYN messages */
+		tsk_rej_rx_queue(sk, error);
+		break;
+	default:
+		__skb_queue_purge(&sk->sk_receive_queue);
+		break;
 	}
 }
 
@@ -2643,7 +2654,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 	 * Reject any stray messages received by new socket
 	 * before the socket lock was taken (very, very unlikely)
 	 */
-	tsk_rej_rx_queue(new_sk);
+	tsk_rej_rx_queue(new_sk, TIPC_ERR_NO_PORT);
 
 	/* Connect new socket to it's peer */
 	tipc_sk_finish_conn(new_tsock, msg_origport(msg), msg_orignode(msg));
-- 
2.13.7

