Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38524D318
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgHUKsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:18 -0400
Received: from mail.katalix.com ([3.9.82.81]:45444 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHUKr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 06:47:57 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BEEF486BE9;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006863; bh=4xOycABwvJh2p+QHCl5A9LJQgIBmui1sOuEHqkzkBRY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=206/9]=20l2tp:=20add=20tracepoin
         ts=20to=20l2tp_core.c|Date:=20Fri,=2021=20Aug=202020=2011:47:25=20
         +0100|Message-Id:=20<20200821104728.23530-7-tparkin@katalix.com>|I
         n-Reply-To:=20<20200821104728.23530-1-tparkin@katalix.com>|Referen
         ces:=20<20200821104728.23530-1-tparkin@katalix.com>;
        b=FoUP7qZh6rJlWBWvTH3BF5hhjlK9fHd/EDQPuRrQziAmEyBcuLGNVHzOhqQaAjrRT
         1JTHSaZaz/HLqlK4wyolF1yGWQJIDbfqbyUgtxtfNb3FmsoXyhlq4w+4otcPe3lMgQ
         YzXtpWOUqkeZ0MJxp7DEgwOPuUvnTCj8JFlnabIyb2QJtaIW50d6IAEl89UIpAFVxE
         8VJAQBL2ml6iUI0xiDn8CCYA9ncQJkfVyR73wxBN/c/jV+dZU6/y1GL1w9Y+7aZ+5u
         ssIB8T9DdOX9WfeU7DKnOLNHgYLwXnrJXyG48+iSPWDjYs5xOxa41xdyeLJtJYMvwP
         ob+KZpP/aZ0RQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 6/9] l2tp: add tracepoints to l2tp_core.c
Date:   Fri, 21 Aug 2020 11:47:25 +0100
Message-Id: <20200821104728.23530-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add lifetime event tracing for tunnel and session instances, tracking
tunnel and session registration, deletion, and eventual freeing.

Port the data path sequence number debug logging to use trace points
rather than custom debug macros.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 83 +++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 52 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a9825724e2f4..651c08dc9bcf 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -61,6 +61,7 @@
 #include <linux/atomic.h>
 
 #include "l2tp_core.h"
+#include "trace.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -154,6 +155,7 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
 
 static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
 {
+	trace_free_tunnel(tunnel);
 	sock_put(tunnel->sock);
 	/* the tunnel is freed in the socket destructor */
 }
@@ -162,6 +164,8 @@ static void l2tp_session_free(struct l2tp_session *session)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
+	trace_free_session(session);
+
 	if (tunnel) {
 		if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
 			goto out;
@@ -384,6 +388,8 @@ int l2tp_session_register(struct l2tp_session *session,
 	hlist_add_head(&session->hlist, head);
 	write_unlock_bh(&tunnel->hlist_lock);
 
+	trace_register_session(session);
+
 	return 0;
 
 err_tlock_pnlock:
@@ -412,10 +418,6 @@ static void l2tp_recv_queue_skb(struct l2tp_session *session, struct sk_buff *sk
 	skb_queue_walk_safe(&session->reorder_q, skbp, tmp) {
 		if (L2TP_SKB_CB(skbp)->ns > ns) {
 			__skb_queue_before(&session->reorder_q, skbp, skb);
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: pkt %hu, inserted before %hu, reorder_q len=%d\n",
-				 session->name, ns, L2TP_SKB_CB(skbp)->ns,
-				 skb_queue_len(&session->reorder_q));
 			atomic_long_inc(&session->stats.rx_oos_packets);
 			goto out;
 		}
@@ -448,9 +450,7 @@ static void l2tp_recv_dequeue_skb(struct l2tp_session *session, struct sk_buff *
 		/* Bump our Nr */
 		session->nr++;
 		session->nr &= session->nr_max;
-
-		l2tp_dbg(session, L2TP_MSG_SEQ, "%s: updated nr to %hu\n",
-			 session->name, session->nr);
+		trace_session_seqnum_update(session);
 	}
 
 	/* call private receive handler */
@@ -475,37 +475,27 @@ static void l2tp_recv_dequeue(struct l2tp_session *session)
 start:
 	spin_lock_bh(&session->reorder_q.lock);
 	skb_queue_walk_safe(&session->reorder_q, skb, tmp) {
-		if (time_after(jiffies, L2TP_SKB_CB(skb)->expires)) {
+		struct l2tp_skb_cb *cb = L2TP_SKB_CB(skb);
+
+		/* If the packet has been pending on the queue for too long, discard it */
+		if (time_after(jiffies, cb->expires)) {
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			atomic_long_inc(&session->stats.rx_errors);
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: oos pkt %u len %d discarded (too old), waiting for %u, reorder_q_len=%d\n",
-				 session->name, L2TP_SKB_CB(skb)->ns,
-				 L2TP_SKB_CB(skb)->length, session->nr,
-				 skb_queue_len(&session->reorder_q));
+			trace_session_pkt_expired(session, cb->ns);
 			session->reorder_skip = 1;
 			__skb_unlink(skb, &session->reorder_q);
 			kfree_skb(skb);
 			continue;
 		}
 
-		if (L2TP_SKB_CB(skb)->has_seq) {
+		if (cb->has_seq) {
 			if (session->reorder_skip) {
-				l2tp_dbg(session, L2TP_MSG_SEQ,
-					 "%s: advancing nr to next pkt: %u -> %u",
-					 session->name, session->nr,
-					 L2TP_SKB_CB(skb)->ns);
 				session->reorder_skip = 0;
-				session->nr = L2TP_SKB_CB(skb)->ns;
+				session->nr = cb->ns;
+				trace_session_seqnum_reset(session);
 			}
-			if (L2TP_SKB_CB(skb)->ns != session->nr) {
-				l2tp_dbg(session, L2TP_MSG_SEQ,
-					 "%s: holding oos pkt %u len %d, waiting for %u, reorder_q_len=%d\n",
-					 session->name, L2TP_SKB_CB(skb)->ns,
-					 L2TP_SKB_CB(skb)->length, session->nr,
-					 skb_queue_len(&session->reorder_q));
+			if (cb->ns != session->nr)
 				goto out;
-			}
 		}
 		__skb_unlink(skb, &session->reorder_q);
 
@@ -538,14 +528,13 @@ static int l2tp_seq_check_rx_window(struct l2tp_session *session, u32 nr)
  */
 static int l2tp_recv_data_seq(struct l2tp_session *session, struct sk_buff *skb)
 {
-	if (!l2tp_seq_check_rx_window(session, L2TP_SKB_CB(skb)->ns)) {
+	struct l2tp_skb_cb *cb = L2TP_SKB_CB(skb);
+
+	if (!l2tp_seq_check_rx_window(session, cb->ns)) {
 		/* Packet sequence number is outside allowed window.
 		 * Discard it.
 		 */
-		l2tp_dbg(session, L2TP_MSG_SEQ,
-			 "%s: pkt %u len %d discarded, outside window, nr=%u\n",
-			 session->name, L2TP_SKB_CB(skb)->ns,
-			 L2TP_SKB_CB(skb)->length, session->nr);
+		trace_session_pkt_outside_rx_window(session, cb->ns);
 		goto discard;
 	}
 
@@ -562,10 +551,10 @@ static int l2tp_recv_data_seq(struct l2tp_session *session, struct sk_buff *skb)
 	 * is seen. After nr_oos_count_max in-sequence packets, reset the
 	 * sequence number to re-enable packet reception.
 	 */
-	if (L2TP_SKB_CB(skb)->ns == session->nr) {
+	if (cb->ns == session->nr) {
 		skb_queue_tail(&session->reorder_q, skb);
 	} else {
-		u32 nr_oos = L2TP_SKB_CB(skb)->ns;
+		u32 nr_oos = cb->ns;
 		u32 nr_next = (session->nr_oos + 1) & session->nr_max;
 
 		if (nr_oos == nr_next)
@@ -576,17 +565,10 @@ static int l2tp_recv_data_seq(struct l2tp_session *session, struct sk_buff *skb)
 		session->nr_oos = nr_oos;
 		if (session->nr_oos_count > session->nr_oos_count_max) {
 			session->reorder_skip = 1;
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: %d oos packets received. Resetting sequence numbers\n",
-				 session->name, session->nr_oos_count);
 		}
 		if (!session->reorder_skip) {
 			atomic_long_inc(&session->stats.rx_seq_discards);
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: oos pkt %u len %d discarded, waiting for %u, reorder_q_len=%d\n",
-				 session->name, L2TP_SKB_CB(skb)->ns,
-				 L2TP_SKB_CB(skb)->length, session->nr,
-				 skb_queue_len(&session->reorder_q));
+			trace_session_pkt_oos(session, cb->ns);
 			goto discard;
 		}
 		skb_queue_tail(&session->reorder_q, skb);
@@ -716,9 +698,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * configure it so.
 		 */
 		if (!session->lns_mode && !session->send_seq) {
-			l2tp_info(session, L2TP_MSG_SEQ,
-				  "%s: requested to enable seq numbers by LNS\n",
-				  session->name);
+			trace_session_seqnum_lns_enable(session);
 			session->send_seq = 1;
 			l2tp_session_set_header_len(session, tunnel->version);
 		}
@@ -739,9 +719,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * LAC is broken. Discard the frame.
 		 */
 		if (!session->lns_mode && session->send_seq) {
-			l2tp_info(session, L2TP_MSG_SEQ,
-				  "%s: requested to disable seq numbers by LNS\n",
-				  session->name);
+			trace_session_seqnum_lns_disable(session);
 			session->send_seq = 0;
 			l2tp_session_set_header_len(session, tunnel->version);
 		} else if (session->send_seq) {
@@ -965,8 +943,7 @@ static int l2tp_build_l2tpv2_header(struct l2tp_session *session, void *buf)
 		*bufp++ = 0;
 		session->ns++;
 		session->ns &= 0xffff;
-		l2tp_dbg(session, L2TP_MSG_SEQ, "%s: updated ns to %u\n",
-			 session->name, session->ns);
+		trace_session_seqnum_update(session);
 	}
 
 	return bufp - optr;
@@ -1002,9 +979,7 @@ static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
 			l2h = 0x40000000 | session->ns;
 			session->ns++;
 			session->ns &= 0xffffff;
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: updated ns to %u\n",
-				 session->name, session->ns);
+			trace_session_seqnum_update(session);
 		}
 
 		*((__be32 *)bufp) = htonl(l2h);
@@ -1544,6 +1519,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 				   "l2tp_sock");
 	sk->sk_allocation = GFP_ATOMIC;
 
+	trace_register_tunnel(tunnel);
+
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
@@ -1564,6 +1541,7 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_register);
 void l2tp_tunnel_delete(struct l2tp_tunnel *tunnel)
 {
 	if (!test_and_set_bit(0, &tunnel->dead)) {
+		trace_delete_tunnel(tunnel);
 		l2tp_tunnel_inc_refcount(tunnel);
 		queue_work(l2tp_wq, &tunnel->del_work);
 	}
@@ -1575,6 +1553,7 @@ void l2tp_session_delete(struct l2tp_session *session)
 	if (test_and_set_bit(0, &session->dead))
 		return;
 
+	trace_delete_session(session);
 	l2tp_session_unhash(session);
 	l2tp_session_queue_purge(session);
 	if (session->session_close)
-- 
2.17.1

