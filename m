Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1460FA1AD7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH2NGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbfH2NGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:06:42 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 399938AC6FE;
        Thu, 29 Aug 2019 13:06:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F94A5C3F8;
        Thu, 29 Aug 2019 13:06:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/5] rxrpc: Use the tx-phase skb flag to simplify tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 29 Aug 2019 14:06:40 +0100
Message-ID: <156708400040.25861.16873381239802847142.stgit@warthog.procyon.org.uk>
In-Reply-To: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
References: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 29 Aug 2019 13:06:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the previously-added transmit-phase skbuff private flag to simplify the
socket buffer tracing a bit.  Which phase the skbuff comes from can now be
divined from the skb rather than having to be guessed from the call state.

We can also reduce the number of rxrpc_skb_trace values by eliminating the
difference between Tx and Rx in the symbols.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   51 ++++++++++++++++++------------------------
 net/rxrpc/ar-internal.h      |    1 +
 net/rxrpc/call_event.c       |    8 +++----
 net/rxrpc/call_object.c      |    6 ++---
 net/rxrpc/conn_event.c       |    6 ++---
 net/rxrpc/input.c            |   22 +++++++++---------
 net/rxrpc/local_event.c      |    4 ++-
 net/rxrpc/output.c           |    6 ++---
 net/rxrpc/peer_event.c       |   10 ++++----
 net/rxrpc/recvmsg.c          |    6 ++---
 net/rxrpc/sendmsg.c          |   10 ++++----
 net/rxrpc/skbuff.c           |   15 +++++++-----
 12 files changed, 69 insertions(+), 76 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index fa06b528c73c..e2356c51883b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -23,20 +23,15 @@
 #define __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY
 
 enum rxrpc_skb_trace {
-	rxrpc_skb_rx_cleaned,
-	rxrpc_skb_rx_freed,
-	rxrpc_skb_rx_got,
-	rxrpc_skb_rx_lost,
-	rxrpc_skb_rx_purged,
-	rxrpc_skb_rx_received,
-	rxrpc_skb_rx_rotated,
-	rxrpc_skb_rx_seen,
-	rxrpc_skb_tx_cleaned,
-	rxrpc_skb_tx_freed,
-	rxrpc_skb_tx_got,
-	rxrpc_skb_tx_new,
-	rxrpc_skb_tx_rotated,
-	rxrpc_skb_tx_seen,
+	rxrpc_skb_cleaned,
+	rxrpc_skb_freed,
+	rxrpc_skb_got,
+	rxrpc_skb_lost,
+	rxrpc_skb_new,
+	rxrpc_skb_purged,
+	rxrpc_skb_received,
+	rxrpc_skb_rotated,
+	rxrpc_skb_seen,
 };
 
 enum rxrpc_local_trace {
@@ -228,20 +223,15 @@ enum rxrpc_tx_point {
  * Declare tracing information enums and their string mappings for display.
  */
 #define rxrpc_skb_traces \
-	EM(rxrpc_skb_rx_cleaned,		"Rx CLN") \
-	EM(rxrpc_skb_rx_freed,			"Rx FRE") \
-	EM(rxrpc_skb_rx_got,			"Rx GOT") \
-	EM(rxrpc_skb_rx_lost,			"Rx *L*") \
-	EM(rxrpc_skb_rx_purged,			"Rx PUR") \
-	EM(rxrpc_skb_rx_received,		"Rx RCV") \
-	EM(rxrpc_skb_rx_rotated,		"Rx ROT") \
-	EM(rxrpc_skb_rx_seen,			"Rx SEE") \
-	EM(rxrpc_skb_tx_cleaned,		"Tx CLN") \
-	EM(rxrpc_skb_tx_freed,			"Tx FRE") \
-	EM(rxrpc_skb_tx_got,			"Tx GOT") \
-	EM(rxrpc_skb_tx_new,			"Tx NEW") \
-	EM(rxrpc_skb_tx_rotated,		"Tx ROT") \
-	E_(rxrpc_skb_tx_seen,			"Tx SEE")
+	EM(rxrpc_skb_cleaned,			"CLN") \
+	EM(rxrpc_skb_freed,			"FRE") \
+	EM(rxrpc_skb_got,			"GOT") \
+	EM(rxrpc_skb_lost,			"*L*") \
+	EM(rxrpc_skb_new,			"NEW") \
+	EM(rxrpc_skb_purged,			"PUR") \
+	EM(rxrpc_skb_received,			"RCV") \
+	EM(rxrpc_skb_rotated,			"ROT") \
+	E_(rxrpc_skb_seen,			"SEE")
 
 #define rxrpc_local_traces \
 	EM(rxrpc_local_got,			"GOT") \
@@ -650,6 +640,7 @@ TRACE_EVENT(rxrpc_skb,
 	    TP_STRUCT__entry(
 		    __field(struct sk_buff *,		skb		)
 		    __field(enum rxrpc_skb_trace,	op		)
+		    __field(u8,				flags		)
 		    __field(int,			usage		)
 		    __field(int,			mod_count	)
 		    __field(const void *,		where		)
@@ -657,14 +648,16 @@ TRACE_EVENT(rxrpc_skb,
 
 	    TP_fast_assign(
 		    __entry->skb = skb;
+		    __entry->flags = rxrpc_skb(skb)->rx_flags;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->mod_count = mod_count;
 		    __entry->where = where;
 			   ),
 
-	    TP_printk("s=%p %s u=%d m=%d p=%pSR",
+	    TP_printk("s=%p %cx %s u=%d m=%d p=%pSR",
 		      __entry->skb,
+		      __entry->flags & RXRPC_SKB_TX_BUFFER ? 'T' : 'R',
 		      __print_symbolic(__entry->op, rxrpc_skb_traces),
 		      __entry->usage,
 		      __entry->mod_count,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 63d3a91ce5e9..2d5294f3e62f 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -185,6 +185,7 @@ struct rxrpc_host_header {
  * - max 48 bytes (struct sk_buff::cb)
  */
 struct rxrpc_skb_priv {
+	atomic_t	nr_ring_pins;		/* Number of rxtx ring pins */
 	u8		nr_subpackets;		/* Number of subpackets */
 	u8		rx_flags;		/* Received packet flags */
 #define RXRPC_SKB_INCL_LAST	0x01		/* - Includes last packet */
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index c767679bfa5d..cedbbb3a7c2e 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -199,7 +199,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 			continue;
 
 		skb = call->rxtx_buffer[ix];
-		rxrpc_see_skb(skb, rxrpc_skb_tx_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_seen);
 
 		if (anno_type == RXRPC_TX_ANNO_UNACK) {
 			if (ktime_after(skb->tstamp, max_age)) {
@@ -255,18 +255,18 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 			continue;
 
 		skb = call->rxtx_buffer[ix];
-		rxrpc_get_skb(skb, rxrpc_skb_tx_got);
+		rxrpc_get_skb(skb, rxrpc_skb_got);
 		spin_unlock_bh(&call->lock);
 
 		if (rxrpc_send_data_packet(call, skb, true) < 0) {
-			rxrpc_free_skb(skb, rxrpc_skb_tx_freed);
+			rxrpc_free_skb(skb, rxrpc_skb_freed);
 			return;
 		}
 
 		if (rxrpc_is_client_call(call))
 			rxrpc_expose_client_call(call);
 
-		rxrpc_free_skb(skb, rxrpc_skb_tx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		spin_lock_bh(&call->lock);
 
 		/* We need to clear the retransmit state, but there are two
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index c9ab2da957fe..014548c259ce 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -429,9 +429,7 @@ static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 	int i;
 
 	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
-		rxrpc_free_skb(call->rxtx_buffer[i],
-			       (call->tx_phase ? rxrpc_skb_tx_cleaned :
-				rxrpc_skb_rx_cleaned));
+		rxrpc_free_skb(call->rxtx_buffer[i], rxrpc_skb_cleaned);
 		call->rxtx_buffer[i] = NULL;
 	}
 }
@@ -587,7 +585,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERTCMP(call->conn, ==, NULL);
 
 	rxrpc_cleanup_ring(call);
-	rxrpc_free_skb(call->tx_pending, rxrpc_skb_tx_cleaned);
+	rxrpc_free_skb(call->tx_pending, rxrpc_skb_cleaned);
 
 	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
 }
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index df6624c140be..a1ceef4f5cd0 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -472,7 +472,7 @@ void rxrpc_process_connection(struct work_struct *work)
 	/* go through the conn-level event packets, releasing the ref on this
 	 * connection that each one has when we've finished with it */
 	while ((skb = skb_dequeue(&conn->rx_queue))) {
-		rxrpc_see_skb(skb, rxrpc_skb_rx_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		ret = rxrpc_process_event(conn, skb, &abort_code);
 		switch (ret) {
 		case -EPROTO:
@@ -484,7 +484,7 @@ void rxrpc_process_connection(struct work_struct *work)
 			goto requeue_and_leave;
 		case -ECONNABORTED:
 		default:
-			rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+			rxrpc_free_skb(skb, rxrpc_skb_freed);
 			break;
 		}
 	}
@@ -501,6 +501,6 @@ void rxrpc_process_connection(struct work_struct *work)
 protocol_error:
 	if (rxrpc_abort_connection(conn, ret, abort_code) < 0)
 		goto requeue_and_leave;
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	goto out;
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 140cede77655..31090bdf1fae 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -233,7 +233,7 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 		ix = call->tx_hard_ack & RXRPC_RXTX_BUFF_MASK;
 		skb = call->rxtx_buffer[ix];
 		annotation = call->rxtx_annotations[ix];
-		rxrpc_see_skb(skb, rxrpc_skb_tx_rotated);
+		rxrpc_see_skb(skb, rxrpc_skb_rotated);
 		call->rxtx_buffer[ix] = NULL;
 		call->rxtx_annotations[ix] = 0;
 		skb->next = list;
@@ -258,7 +258,7 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 		skb = list;
 		list = skb->next;
 		skb_mark_not_on_list(skb);
-		rxrpc_free_skb(skb, rxrpc_skb_tx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 	}
 
 	return rot_last;
@@ -443,7 +443,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE) {
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		return;
 	}
 
@@ -559,7 +559,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		 * and also rxrpc_fill_out_ack().
 		 */
 		if (!terminal)
-			rxrpc_get_skb(skb, rxrpc_skb_rx_got);
+			rxrpc_get_skb(skb, rxrpc_skb_got);
 		call->rxtx_annotations[ix] = annotation;
 		smp_wmb();
 		call->rxtx_buffer[ix] = skb;
@@ -620,7 +620,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 
 unlock:
 	spin_unlock(&call->input_lock);
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	_leave(" [queued]");
 }
 
@@ -1056,7 +1056,7 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 		break;
 	}
 
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 no_free:
 	_leave("");
 }
@@ -1119,7 +1119,7 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 		skb_queue_tail(&local->event_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 	}
 }
 
@@ -1134,7 +1134,7 @@ static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 	}
 }
 
@@ -1198,7 +1198,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	if (skb->tstamp == 0)
 		skb->tstamp = ktime_get_real();
 
-	rxrpc_new_skb(skb, rxrpc_skb_rx_received);
+	rxrpc_new_skb(skb, rxrpc_skb_received);
 
 	skb_pull(skb, sizeof(struct udphdr));
 
@@ -1215,7 +1215,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			trace_rxrpc_rx_lose(sp);
-			rxrpc_free_skb(skb, rxrpc_skb_rx_lost);
+			rxrpc_free_skb(skb, rxrpc_skb_lost);
 			return 0;
 		}
 	}
@@ -1389,7 +1389,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	goto out;
 
 discard:
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 out:
 	trace_rxrpc_rx_done(0, 0);
 	return 0;
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index e93a78f7c05e..3ce6d628cd75 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -90,7 +90,7 @@ void rxrpc_process_local_events(struct rxrpc_local *local)
 	if (skb) {
 		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
-		rxrpc_see_skb(skb, rxrpc_skb_rx_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		_debug("{%d},{%u}", local->debug_id, sp->hdr.type);
 
 		switch (sp->hdr.type) {
@@ -108,7 +108,7 @@ void rxrpc_process_local_events(struct rxrpc_local *local)
 			break;
 		}
 
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 	}
 
 	_leave("");
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 369e516c4bdf..935bb60fff56 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -565,7 +565,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 	memset(&whdr, 0, sizeof(whdr));
 
 	while ((skb = skb_dequeue(&local->reject_queue))) {
-		rxrpc_see_skb(skb, rxrpc_skb_rx_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		sp = rxrpc_skb(skb);
 
 		switch (skb->mark) {
@@ -581,7 +581,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 			ioc = 2;
 			break;
 		default:
-			rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+			rxrpc_free_skb(skb, rxrpc_skb_freed);
 			continue;
 		}
 
@@ -606,7 +606,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 						      rxrpc_tx_point_reject);
 		}
 
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 	}
 
 	_leave("");
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 7666ec72d37e..c97ebdc043e4 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -163,11 +163,11 @@ void rxrpc_error_report(struct sock *sk)
 		_leave("UDP socket errqueue empty");
 		return;
 	}
-	rxrpc_new_skb(skb, rxrpc_skb_rx_received);
+	rxrpc_new_skb(skb, rxrpc_skb_received);
 	serr = SKB_EXT_ERR(skb);
 	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
 		_leave("UDP empty message");
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		return;
 	}
 
@@ -177,7 +177,7 @@ void rxrpc_error_report(struct sock *sk)
 		peer = NULL;
 	if (!peer) {
 		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		_leave(" [no peer]");
 		return;
 	}
@@ -189,7 +189,7 @@ void rxrpc_error_report(struct sock *sk)
 	     serr->ee.ee_code == ICMP_FRAG_NEEDED)) {
 		rxrpc_adjust_mtu(peer, serr);
 		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		rxrpc_put_peer(peer);
 		_leave(" [MTU update]");
 		return;
@@ -197,7 +197,7 @@ void rxrpc_error_report(struct sock *sk)
 
 	rxrpc_store_error(peer, serr);
 	rcu_read_unlock();
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	rxrpc_put_peer(peer);
 
 	_leave("");
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index e49eacfaf4d6..3b0becb12041 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -190,7 +190,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	hard_ack++;
 	ix = hard_ack & RXRPC_RXTX_BUFF_MASK;
 	skb = call->rxtx_buffer[ix];
-	rxrpc_see_skb(skb, rxrpc_skb_rx_rotated);
+	rxrpc_see_skb(skb, rxrpc_skb_rotated);
 	sp = rxrpc_skb(skb);
 
 	subpacket = call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
@@ -205,7 +205,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	/* Barrier against rxrpc_input_data(). */
 	smp_store_release(&call->rx_hard_ack, hard_ack);
 
-	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 
 	trace_rxrpc_receive(call, rxrpc_receive_rotate, serial, hard_ack);
 	if (last) {
@@ -340,7 +340,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			break;
 		}
 		smp_rmb();
-		rxrpc_see_skb(skb, rxrpc_skb_rx_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		sp = rxrpc_skb(skb);
 
 		if (!(flags & MSG_PEEK)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 472dc3b7d91f..6a1547b270fe 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -176,7 +176,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	skb->tstamp = ktime_get_real();
 
 	ix = seq & RXRPC_RXTX_BUFF_MASK;
-	rxrpc_get_skb(skb, rxrpc_skb_tx_got);
+	rxrpc_get_skb(skb, rxrpc_skb_got);
 	call->rxtx_annotations[ix] = annotation;
 	smp_wmb();
 	call->rxtx_buffer[ix] = skb;
@@ -248,7 +248,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	}
 
 out:
-	rxrpc_free_skb(skb, rxrpc_skb_tx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	_leave(" = %d", ret);
 	return ret;
 }
@@ -289,7 +289,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	skb = call->tx_pending;
 	call->tx_pending = NULL;
-	rxrpc_see_skb(skb, rxrpc_skb_tx_seen);
+	rxrpc_see_skb(skb, rxrpc_skb_seen);
 
 	copied = 0;
 	do {
@@ -338,7 +338,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			sp = rxrpc_skb(skb);
 			sp->rx_flags |= RXRPC_SKB_TX_BUFFER;
-			rxrpc_new_skb(skb, rxrpc_skb_tx_new);
+			rxrpc_new_skb(skb, rxrpc_skb_new);
 
 			_debug("ALLOC SEND %p", skb);
 
@@ -440,7 +440,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	return ret;
 
 call_terminated:
-	rxrpc_free_skb(skb, rxrpc_skb_tx_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	_leave(" = %d", call->error);
 	return call->error;
 
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 9ad5045b7c2f..8e6f45f84b9b 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -14,7 +14,8 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
-#define select_skb_count(op) (op >= rxrpc_skb_tx_cleaned ? &rxrpc_n_tx_skbs : &rxrpc_n_rx_skbs)
+#define is_tx_skb(skb) (rxrpc_skb(skb)->rx_flags & RXRPC_SKB_TX_BUFFER)
+#define select_skb_count(skb) (is_tx_skb(skb) ? &rxrpc_n_tx_skbs : &rxrpc_n_rx_skbs)
 
 /*
  * Note the allocation or reception of a socket buffer.
@@ -22,7 +23,7 @@
 void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(select_skb_count(op));
+	int n = atomic_inc_return(select_skb_count(skb));
 	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 }
 
@@ -33,7 +34,7 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	if (skb) {
-		int n = atomic_read(select_skb_count(op));
+		int n = atomic_read(select_skb_count(skb));
 		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	}
 }
@@ -44,7 +45,7 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(select_skb_count(op));
+	int n = atomic_inc_return(select_skb_count(skb));
 	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	skb_get(skb);
 }
@@ -58,7 +59,7 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	if (skb) {
 		int n;
 		CHECK_SLAB_OKAY(&skb->users);
-		n = atomic_dec_return(select_skb_count(op));
+		n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
@@ -72,8 +73,8 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 	const void *here = __builtin_return_address(0);
 	struct sk_buff *skb;
 	while ((skb = skb_dequeue((list))) != NULL) {
-		int n = atomic_dec_return(select_skb_count(rxrpc_skb_rx_purged));
-		trace_rxrpc_skb(skb, rxrpc_skb_rx_purged,
+		int n = atomic_dec_return(select_skb_count(skb));
+		trace_rxrpc_skb(skb, rxrpc_skb_purged,
 				refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}

