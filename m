Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF072417
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfGXB4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:56:30 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:41106 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725837AbfGXB43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:56:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 764EB4657A;
        Wed, 24 Jul 2019 11:56:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1563933385; bh=g2qd9u/pjQDSatn9091GvvbU/momkDMHi+U4Y4Zs2H8=; b=n
        JVdojsOp7nno8RGiDKLoLeL7cjUw8IMXGno1Q9ZObcftEiel+hZoEyjxqWmS07Lk
        ky8vmScolgeBMs/NVwlqYp65IRR4bbG0cJLn3BdcIiUGQDpf7dsw4zjo6MrByVyl
        nM4sADh0/Zu1ErP328rf05iGgDiuF/wexzhGObpITo=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kQwaqqpODY8F; Wed, 24 Jul 2019 11:56:25 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 5B54446579;
        Wed, 24 Jul 2019 11:56:25 +1000 (AEST)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 977134657A;
        Wed, 24 Jul 2019 11:56:23 +1000 (AEST)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 1/2] tipc: optimize link synching mechanism
Date:   Wed, 24 Jul 2019 08:56:11 +0700
Message-Id: <20190724015612.2518-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190724015612.2518-1-tuong.t.lien@dektech.com.au>
References: <20190724015612.2518-1-tuong.t.lien@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit along with the next one are to resolve the issues with the
link changeover mechanism. See that commit for details.

Basically, for the link synching, from now on, we will send only one
single ("dummy") SYNCH message to peer. The SYNCH message does not
contain any data, just a header conveying the synch point to the peer.

A new node capability flag ("TIPC_TUNNEL_ENHANCED") is introduced for
backward compatible!

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Suggested-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 26 ++++++++++++++++++++++++++
 net/tipc/msg.h  | 10 ++++++++++
 net/tipc/node.c |  6 ++++--
 net/tipc/node.h |  6 ++++--
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 66d3a07bc571..e215b4ba6a4b 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1665,6 +1665,7 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 	struct sk_buff_head *queue = &l->transmq;
 	struct sk_buff_head tmpxq, tnlq;
 	u16 pktlen, pktcnt, seqno = l->snd_nxt;
+	u16 syncpt;
 
 	if (!tnl)
 		return;
@@ -1684,6 +1685,31 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 	tipc_link_xmit(l, &tnlq, &tmpxq);
 	__skb_queue_purge(&tmpxq);
 
+	/* Link Synching:
+	 * From now on, send only one single ("dummy") SYNCH message
+	 * to peer. The SYNCH message does not contain any data, just
+	 * a header conveying the synch point to the peer.
+	 */
+	if (mtyp == SYNCH_MSG && (tnl->peer_caps & TIPC_TUNNEL_ENHANCED)) {
+		tnlskb = tipc_msg_create(TUNNEL_PROTOCOL, SYNCH_MSG,
+					 INT_H_SIZE, 0, l->addr,
+					 tipc_own_addr(l->net),
+					 0, 0, 0);
+		if (!tnlskb) {
+			pr_warn("%sunable to create dummy SYNCH_MSG\n",
+				link_co_err);
+			return;
+		}
+
+		hdr = buf_msg(tnlskb);
+		syncpt = l->snd_nxt + skb_queue_len(&l->backlogq) - 1;
+		msg_set_syncpt(hdr, syncpt);
+		msg_set_bearer_id(hdr, l->peer_bearer_id);
+		__skb_queue_tail(&tnlq, tnlskb);
+		tipc_link_xmit(tnl, &tnlq, xmitq);
+		return;
+	}
+
 	/* Initialize reusable tunnel packet header */
 	tipc_msg_init(tipc_own_addr(l->net), &tnlhdr, TUNNEL_PROTOCOL,
 		      mtyp, INT_H_SIZE, l->addr);
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index da509f0eb9ca..fca042cdff88 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -877,6 +877,16 @@ static inline void msg_set_msgcnt(struct tipc_msg *m, u16 n)
 	msg_set_bits(m, 9, 16, 0xffff, n);
 }
 
+static inline u16 msg_syncpt(struct tipc_msg *m)
+{
+	return msg_bits(m, 9, 16, 0xffff);
+}
+
+static inline void msg_set_syncpt(struct tipc_msg *m, u16 n)
+{
+	msg_set_bits(m, 9, 16, 0xffff, n);
+}
+
 static inline u32 msg_conn_ack(struct tipc_msg *m)
 {
 	return msg_bits(m, 9, 16, 0xffff);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 324a1f91b394..5d8b48051bb9 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1649,7 +1649,6 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 	int usr = msg_user(hdr);
 	int mtyp = msg_type(hdr);
 	u16 oseqno = msg_seqno(hdr);
-	u16 iseqno = msg_seqno(msg_inner_hdr(hdr));
 	u16 exp_pkts = msg_msgcnt(hdr);
 	u16 rcv_nxt, syncpt, dlv_nxt, inputq_len;
 	int state = n->state;
@@ -1748,7 +1747,10 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 
 	/* Initiate synch mode if applicable */
 	if ((usr == TUNNEL_PROTOCOL) && (mtyp == SYNCH_MSG) && (oseqno == 1)) {
-		syncpt = iseqno + exp_pkts - 1;
+		if (n->capabilities & TIPC_TUNNEL_ENHANCED)
+			syncpt = msg_syncpt(hdr);
+		else
+			syncpt = msg_seqno(msg_inner_hdr(hdr)) + exp_pkts - 1;
 		if (!tipc_link_is_up(l))
 			__tipc_node_link_up(n, bearer_id, xmitq);
 		if (n->state == SELF_UP_PEER_UP) {
diff --git a/net/tipc/node.h b/net/tipc/node.h
index c0bf49ea3de4..291d0ecd4101 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -53,7 +53,8 @@ enum {
 	TIPC_NODE_ID128       = (1 << 5),
 	TIPC_LINK_PROTO_SEQNO = (1 << 6),
 	TIPC_MCAST_RBCTL      = (1 << 7),
-	TIPC_GAP_ACK_BLOCK    = (1 << 8)
+	TIPC_GAP_ACK_BLOCK    = (1 << 8),
+	TIPC_TUNNEL_ENHANCED  = (1 << 9)
 };
 
 #define TIPC_NODE_CAPABILITIES (TIPC_SYN_BIT           |  \
@@ -64,7 +65,8 @@ enum {
 				TIPC_NODE_ID128        |   \
 				TIPC_LINK_PROTO_SEQNO  |   \
 				TIPC_MCAST_RBCTL       |   \
-				TIPC_GAP_ACK_BLOCK)
+				TIPC_GAP_ACK_BLOCK     |   \
+				TIPC_TUNNEL_ENHANCED)
 #define INVALID_BEARER_ID -1
 
 void tipc_node_stop(struct net *net);
-- 
2.13.7

