Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA826F3E3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgIRDKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgIRCCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3CD235F7;
        Fri, 18 Sep 2020 02:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394566;
        bh=0x3+CDD+td9StTCEH6pNHswN9oNQ0to/bCujROd3J54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgmJnpU+o+5ChCfDRIPMYSA99M67TPWCPm9CfCLHqL9FEcFEtoa0eXHxmXMZdQFhv
         M3NWFMFThDRcw7f6verTMFM6mB+Xf2RrcGHxUZU38H45ht6BWeCWiizKV2DveTz9HY
         DRD3QfswMnFE8tdoNMfRIZjnYmuwVO9wr2aoe3eU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuong Lien <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 078/330] tipc: fix link overflow issue at socket shutdown
Date:   Thu, 17 Sep 2020 21:56:58 -0400
Message-Id: <20200918020110.2063155-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 49afb806cb650dd1f06f191994f3aa657d264009 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 53 ++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 5318bb6611abc..592c6b19aca72 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -260,12 +260,12 @@ static void tipc_sk_respond(struct sock *sk, struct sk_buff *skb, int err)
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
@@ -515,34 +515,45 @@ static void __tipc_shutdown(struct socket *sock, int error)
 	/* Remove any pending SYN message */
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
 
@@ -2564,7 +2575,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 	 * Reject any stray messages received by new socket
 	 * before the socket lock was taken (very, very unlikely)
 	 */
-	tsk_rej_rx_queue(new_sk);
+	tsk_rej_rx_queue(new_sk, TIPC_ERR_NO_PORT);
 
 	/* Connect new socket to it's peer */
 	tipc_sk_finish_conn(new_tsock, msg_origport(msg), msg_orignode(msg));
-- 
2.25.1

