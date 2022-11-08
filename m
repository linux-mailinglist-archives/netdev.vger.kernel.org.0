Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7F621F2D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKHWXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKHWWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E232B657D5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tTa/wrJ2f7bAuolCFusAqUkRhxvhBlTPUAJBjYvrUig=;
        b=HggPC/7oQzlsf7AM/KA5lDLV2v+rth3ptXxFay4ZDCuPT5rA5SzyMzRXg0SHX9zQXmY4ey
        JtFcLbccHPtszDqn56GDUhKY56KrEfRIBmNJsauFktSdycU60Cn3OOPrvWW3rPXPuW1Xg1
        w74JBktgo0AelkTfIczdwMaX9ATUL4A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-MYTH7UGjNcybd1crTcpuVw-1; Tue, 08 Nov 2022 17:20:22 -0500
X-MC-Unique: MYTH7UGjNcybd1crTcpuVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5C5C3C0F229;
        Tue,  8 Nov 2022 22:20:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34CB740C947B;
        Tue,  8 Nov 2022 22:20:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 23/26] rxrpc: Save last ACK's SACK table rather than
 marking txbufs
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:20 +0000
Message-ID: <166794602053.2389296.7729651391779687173.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the tracking of which packets need to be transmitted by saving the
last ACK packet that we receive that has a populated soft-ACK table rather
than marking packets.  Then we can step through the soft-ACK table and look
at the packets we've transmitted beyond that to determine which packets we
might want to retransmit.

We also look at the highest serial number that has been acked to try and
guess which packets we've transmitted the peer is likely to have seen.  If
necessary, we send a ping to retrieve that number.

One downside that might be a problem is that we can't then compare the
previous acked/unacked state so easily in rxrpc_input_soft_acks() - which
is a potential problem for the slow-start algorithm.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    7 +-
 net/core/skbuff.c            |    1 
 net/rxrpc/ar-internal.h      |   12 +--
 net/rxrpc/call_event.c       |  117 +++++++++++++++++++++++++-----
 net/rxrpc/call_object.c      |    2 +
 net/rxrpc/input.c            |  164 +++++++++++++++++++-----------------------
 net/rxrpc/sendmsg.c          |    1 
 7 files changed, 185 insertions(+), 119 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 71ca74e40ec8..a11de55c3c14 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -17,6 +17,7 @@
  * Declare tracing information enums and their string mappings for display.
  */
 #define rxrpc_skb_traces \
+	EM(rxrpc_skb_ack,			"ACK") \
 	EM(rxrpc_skb_cleaned,			"CLN") \
 	EM(rxrpc_skb_cloned_jumbo,		"CLJ") \
 	EM(rxrpc_skb_freed,			"FRE") \
@@ -1257,7 +1258,7 @@ TRACE_EVENT(rxrpc_congest,
 		    memcpy(&__entry->sum, summary, sizeof(__entry->sum));
 			   ),
 
-	    TP_printk("c=%08x r=%08x %s q=%08x %s cw=%u ss=%u nA=%u,%u+%u,%u r=%u b=%u u=%u d=%u l=%x%s%s%s",
+	    TP_printk("c=%08x r=%08x %s q=%08x %s cw=%u ss=%u nA=%u,%u+%u r=%u b=%u u=%u d=%u l=%x%s%s%s",
 		      __entry->call,
 		      __entry->ack_serial,
 		      __print_symbolic(__entry->sum.ack_reason, rxrpc_ack_names),
@@ -1265,8 +1266,8 @@ TRACE_EVENT(rxrpc_congest,
 		      __print_symbolic(__entry->sum.mode, rxrpc_congest_modes),
 		      __entry->sum.cwnd,
 		      __entry->sum.ssthresh,
-		      __entry->sum.nr_acks, __entry->sum.nr_nacks,
-		      __entry->sum.nr_new_acks, __entry->sum.nr_new_nacks,
+		      __entry->sum.nr_acks, __entry->sum.saw_nacks,
+		      __entry->sum.nr_new_acks,
 		      __entry->sum.nr_rot_new_acks,
 		      __entry->top - __entry->hard_ack,
 		      __entry->sum.cumulative_acks,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d84a17eada5..2143244e8ec3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6431,6 +6431,7 @@ void skb_condense(struct sk_buff *skb)
 	 */
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 }
+EXPORT_SYMBOL(skb_condense);
 
 #ifdef CONFIG_SKB_EXTENSIONS
 static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5ec30e84360b..168d03b56ada 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -694,6 +694,8 @@ struct rxrpc_call {
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
 	rxrpc_serial_t		acks_highest_serial; /* Highest serial number ACK'd */
+	struct sk_buff		*acks_soft_tbl;	/* The last ACK packet with NAKs in it */
+	spinlock_t		acks_ack_lock;	/* Access to ->acks_last_ack */
 };
 
 /*
@@ -702,10 +704,9 @@ struct rxrpc_call {
 struct rxrpc_ack_summary {
 	u8			ack_reason;
 	u8			nr_acks;		/* Number of ACKs in packet */
-	u8			nr_nacks;		/* Number of NACKs in packet */
 	u8			nr_new_acks;		/* Number of new ACKs in packet */
-	u8			nr_new_nacks;		/* Number of new NACKs in packet */
 	u8			nr_rot_new_acks;	/* Number of rotated new ACKs */
+	bool			saw_nacks;		/* Saw NACKs in packet */
 	bool			new_low_nack;		/* T if new low NACK found */
 	bool			retrans_timeo;		/* T if reTx due to timeout happened */
 	u8			flight_size;		/* Number of unreceived transmissions */
@@ -765,11 +766,8 @@ struct rxrpc_txbuf {
 	unsigned int		space;		/* Remaining data space */
 	unsigned int		offset;		/* Offset of fill point */
 	unsigned long		flags;
-#define RXRPC_TXBUF_ACKED	0		/* Set if ACK'd */
-#define RXRPC_TXBUF_NACKED	1		/* Set if NAK'd */
-#define RXRPC_TXBUF_LAST	2		/* Set if last packet in Tx phase */
-#define RXRPC_TXBUF_RESENT	3		/* Set if has been resent */
-#define RXRPC_TXBUF_RETRANS	4		/* Set if should be retransmitted */
+#define RXRPC_TXBUF_LAST	0		/* Set if last packet in Tx phase */
+#define RXRPC_TXBUF_RESENT	1		/* Set if has been resent */
 	u8 /*enum rxrpc_propose_ack_trace*/ ack_why;	/* If ack, why */
 	struct {
 		/* The packet for encrypting and DMA'ing.  We align it such
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index dbfaf8170929..1e21a708390e 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -132,48 +132,127 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
  */
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
+	struct rxrpc_ackpacket *ack = NULL;
 	struct rxrpc_txbuf *txb;
+	struct sk_buff *ack_skb = NULL;
 	unsigned long resend_at;
 	rxrpc_seq_t transmitted = READ_ONCE(call->tx_transmitted);
 	ktime_t now, max_age, oldest, ack_ts;
 	bool unacked = false;
+	unsigned int i;
 	LIST_HEAD(retrans_queue);
 
 	_enter("{%d,%d}", call->acks_hard_ack, call->tx_top);
 
 	now = ktime_get_real();
 	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
+	oldest = now;
+
+	/* See if there's an ACK saved with a soft-ACK table in it. */
+	if (call->acks_soft_tbl) {
+		spin_lock_bh(&call->acks_ack_lock);
+		ack_skb = call->acks_soft_tbl;
+		if (ack_skb) {
+			rxrpc_get_skb(ack_skb, rxrpc_skb_ack);
+			ack = (void *)ack_skb->data + sizeof(struct rxrpc_wire_header);
+		}
+		spin_unlock_bh(&call->acks_ack_lock);
+	}
+
+	if (list_empty(&call->tx_buffer))
+		goto no_resend;
 
 	spin_lock(&call->tx_lock);
 
-	/* Scan the packet list without dropping the lock and decide which of
-	 * the packets in the Tx buffer we're going to resend and what the new
-	 * resend timeout will be.
-	 */
+	if (list_empty(&call->tx_buffer))
+		goto no_further_resend;
+
 	trace_rxrpc_resend(call);
-	oldest = now;
-	list_for_each_entry(txb, &call->tx_buffer, call_link) {
-		if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
-			continue;
-		if (after(txb->seq, transmitted))
-			break;
+	txb = list_first_entry(&call->tx_buffer, struct rxrpc_txbuf, call_link);
 
-		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_unacked);
+	/* Scan the soft ACK table without dropping the lock and resend any
+	 * explicitly NAK'd packets.
+	 */
+	if (ack) {
+		for (i = 0; i < ack->nAcks; i++) {
+			rxrpc_seq_t seq;
 
-		if (test_bit(RXRPC_TXBUF_RESENT, &txb->flags)) {
-			if (ktime_after(txb->last_sent, max_age)) {
-				if (ktime_before(txb->last_sent, oldest))
-					oldest = txb->last_sent;
+			if (ack->acks[i] & 1)
 				continue;
+			seq = ntohl(ack->firstPacket) + i;
+			if (after(txb->seq, transmitted))
+				break;
+			if (after(txb->seq, seq))
+				continue; /* A new hard ACK probably came in */
+			list_for_each_entry_from(txb, &call->tx_buffer, call_link) {
+				if (txb->seq == seq)
+					goto found_txb;
+			}
+			goto no_further_resend;
+
+		found_txb:
+			if (after(ntohl(txb->wire.serial), call->acks_highest_serial))
+				continue; /* Ack point not yet reached */
+
+			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_unacked);
+
+			if (list_empty(&txb->tx_link)) {
+				rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
+				rxrpc_get_call(call, rxrpc_call_got_tx);
+				list_add_tail(&txb->tx_link, &retrans_queue);
+				set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 			}
-			unacked = true;
+
+			trace_rxrpc_retransmit(call, txb->seq,
+					       ktime_to_ns(ktime_sub(txb->last_sent,
+								     max_age)));
+
+			if (list_is_last(&txb->call_link, &call->tx_buffer))
+				goto no_further_resend;
+			txb = list_next_entry(txb, call_link);
 		}
+	}
 
-		rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
-		list_move_tail(&txb->tx_link, &retrans_queue);
+	/* Fast-forward through the Tx queue to the point the peer says it has
+	 * seen.  Anything between the soft-ACK table and that point will get
+	 * ACK'd or NACK'd in due course, so don't worry about it here; here we
+	 * need to consider retransmitting anything beyond that point.
+	 *
+	 * Note that ACK for a packet can beat the update of tx_transmitted.
+	 */
+	if (after_eq(READ_ONCE(call->acks_prev_seq), READ_ONCE(call->tx_transmitted)))
+		goto no_further_resend;
+
+	list_for_each_entry_from(txb, &call->tx_buffer, call_link) {
+		if (before_eq(txb->seq, READ_ONCE(call->acks_prev_seq)))
+			continue;
+		if (after(txb->seq, READ_ONCE(call->tx_transmitted)))
+			break; /* Not transmitted yet */
+
+		if (ack && ack->reason == RXRPC_ACK_PING_RESPONSE &&
+		    before(ntohl(txb->wire.serial), ntohl(ack->serial)))
+			goto do_resend; /* Wasn't accounted for by a more recent ping. */
+
+		if (ktime_after(txb->last_sent, max_age)) {
+			if (ktime_before(txb->last_sent, oldest))
+				oldest = txb->last_sent;
+			continue;
+		}
+
+	do_resend:
+		unacked = true;
+		if (list_empty(&txb->tx_link)) {
+			rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
+			list_add_tail(&txb->tx_link, &retrans_queue);
+			set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
+			rxrpc_inc_stat(call->rxnet, stat_tx_data_retrans);
+		}
 	}
 
+no_further_resend:
 	spin_unlock(&call->tx_lock);
+no_resend:
+	rxrpc_free_skb(ack_skb, rxrpc_skb_freed);
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
 	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer,
@@ -201,8 +280,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	while ((txb = list_first_entry_or_null(&retrans_queue,
 					       struct rxrpc_txbuf, tx_link))) {
 		list_del_init(&txb->tx_link);
-		set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
-		rxrpc_inc_stat(call->rxnet, stat_tx_data_retrans);
 		rxrpc_send_data_packet(call, txb);
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_trans);
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index a3ae2ab45f9e..91771031ad3c 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -162,6 +162,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
 	spin_lock_init(&call->input_lock);
+	spin_lock_init(&call->acks_ack_lock);
 	rwlock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
@@ -701,6 +702,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
 	}
 	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
+	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_cleaned);
 
 	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e6e1267915de..5c17fed4b60f 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -60,7 +60,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 
 	switch (call->cong_mode) {
 	case RXRPC_CALL_SLOW_START:
-		if (summary->nr_nacks > 0)
+		if (summary->saw_nacks)
 			goto packet_loss_detected;
 		if (summary->cumulative_acks > 0)
 			cwnd += 1;
@@ -71,7 +71,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 		goto out;
 
 	case RXRPC_CALL_CONGEST_AVOIDANCE:
-		if (summary->nr_nacks > 0)
+		if (summary->saw_nacks)
 			goto packet_loss_detected;
 
 		/* We analyse the number of packets that get ACK'd per RTT
@@ -90,7 +90,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 		goto out;
 
 	case RXRPC_CALL_PACKET_LOSS:
-		if (summary->nr_nacks == 0)
+		if (!summary->saw_nacks)
 			goto resume_normality;
 
 		if (summary->new_low_nack) {
@@ -128,7 +128,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 		} else {
 			change = rxrpc_cong_progress;
 			cwnd = call->cong_ssthresh;
-			if (summary->nr_nacks == 0)
+			if (!summary->saw_nacks)
 				goto resume_normality;
 		}
 		goto out;
@@ -189,8 +189,7 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 	list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
 		if (before_eq(txb->seq, call->acks_hard_ack))
 			continue;
-		if (!test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
-			summary->nr_rot_new_acks++;
+		summary->nr_rot_new_acks++;
 		if (test_bit(RXRPC_TXBUF_LAST, &txb->flags)) {
 			set_bit(RXRPC_CALL_TX_LAST, &call->flags);
 			rot_last = true;
@@ -661,22 +660,8 @@ static void rxrpc_complete_rtt_probe(struct rxrpc_call *call,
  */
 static void rxrpc_input_check_for_lost_ack(struct rxrpc_call *call)
 {
-	struct rxrpc_txbuf *txb;
-	rxrpc_seq_t top, bottom;
-	bool resend = false;
-
-	bottom = READ_ONCE(call->acks_hard_ack) + 1;
-	top = READ_ONCE(call->acks_lost_top);
-	if (before(bottom, top)) {
-		list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
-			if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
-				continue;
-			set_bit(RXRPC_TXBUF_RETRANS, &txb->flags);
-			resend = true;
-		}
-	}
-
-	if (resend && !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
+	if (after(call->acks_lost_top, call->acks_prev_seq) &&
+	    !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
 		rxrpc_queue_call(call);
 }
 
@@ -749,41 +734,19 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 				  rxrpc_seq_t seq, int nr_acks,
 				  struct rxrpc_ack_summary *summary)
 {
-	struct rxrpc_txbuf *txb;
+	unsigned int i;
 
-	list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
-		if (before(txb->seq, seq))
-			continue;
-		if (after_eq(txb->seq, seq + nr_acks))
-			break;
-		switch (acks[txb->seq - seq]) {
-		case RXRPC_ACK_TYPE_ACK:
+	for (i = 0; i < nr_acks; i++) {
+		if (acks[i] == RXRPC_ACK_TYPE_ACK) {
 			summary->nr_acks++;
-			if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
-				continue;
-			/* A lot of the time the packet is going to
-			 * have been ACK.'d already.
-			 */
-			clear_bit(RXRPC_TXBUF_NACKED, &txb->flags);
-			set_bit(RXRPC_TXBUF_ACKED, &txb->flags);
 			summary->nr_new_acks++;
-			break;
-		case RXRPC_ACK_TYPE_NACK:
-			if (!summary->nr_nacks &&
-			    call->acks_lowest_nak != seq) {
-				call->acks_lowest_nak = seq;
+		} else {
+			if (!summary->saw_nacks &&
+			    call->acks_lowest_nak != seq + i) {
+				call->acks_lowest_nak = seq + i;
 				summary->new_low_nack = true;
 			}
-			summary->nr_nacks++;
-			if (test_bit(RXRPC_TXBUF_NACKED, &txb->flags))
-				continue;
-			summary->nr_new_nacks++;
-			clear_bit(RXRPC_TXBUF_ACKED, &txb->flags);
-			set_bit(RXRPC_TXBUF_NACKED, &txb->flags);
-			set_bit(RXRPC_TXBUF_RETRANS, &txb->flags);
-			break;
-		default:
-			return rxrpc_proto_abort("SFT", call, 0);
+			summary->saw_nacks = true;
 		}
 	}
 }
@@ -825,12 +788,10 @@ static bool rxrpc_is_ack_valid(struct rxrpc_call *call,
 static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_ack_summary summary = { 0 };
+	struct rxrpc_ackpacket ack;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	union {
-		struct rxrpc_ackpacket ack;
-		struct rxrpc_ackinfo info;
-		u8 acks[RXRPC_MAXACKS];
-	} buf;
+	struct rxrpc_ackinfo info;
+	struct sk_buff *skb_old = NULL, *skb_put = skb;
 	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
@@ -838,30 +799,28 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	_enter("");
 
 	offset = sizeof(struct rxrpc_wire_header);
-	if (skb_copy_bits(skb, offset, &buf.ack, sizeof(buf.ack)) < 0) {
-		_debug("extraction failure");
-		return rxrpc_proto_abort("XAK", call, 0);
+	if (skb_copy_bits(skb, offset, &ack, sizeof(ack)) < 0) {
+		rxrpc_proto_abort("XAK", call, 0);
+		goto out_not_locked;
 	}
-	offset += sizeof(buf.ack);
+	offset += sizeof(ack);
 
 	ack_serial = sp->hdr.serial;
-	acked_serial = ntohl(buf.ack.serial);
-	first_soft_ack = ntohl(buf.ack.firstPacket);
-	prev_pkt = ntohl(buf.ack.previousPacket);
+	acked_serial = ntohl(ack.serial);
+	first_soft_ack = ntohl(ack.firstPacket);
+	prev_pkt = ntohl(ack.previousPacket);
 	hard_ack = first_soft_ack - 1;
-	nr_acks = buf.ack.nAcks;
-	summary.ack_reason = (buf.ack.reason < RXRPC_ACK__INVALID ?
-			      buf.ack.reason : RXRPC_ACK__INVALID);
+	nr_acks = ack.nAcks;
+	summary.ack_reason = (ack.reason < RXRPC_ACK__INVALID ?
+			      ack.reason : RXRPC_ACK__INVALID);
 
 	trace_rxrpc_rx_ack(call, ack_serial, acked_serial,
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
-	rxrpc_inc_stat(call->rxnet, stat_rx_acks[buf.ack.reason]);
+	rxrpc_inc_stat(call->rxnet, stat_rx_acks[ack.reason]);
 
-	switch (buf.ack.reason) {
+	switch (ack.reason) {
 	case RXRPC_ACK_PING_RESPONSE:
-		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
-					  ack_serial);
 		rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
 					 rxrpc_rtt_rx_ping_response);
 		break;
@@ -876,7 +835,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		break;
 	}
 
-	if (buf.ack.reason == RXRPC_ACK_PING) {
+	if (ack.reason == RXRPC_ACK_PING) {
 		_proto("Rx ACK %%%u PING Request", ack_serial);
 		rxrpc_send_ACK(call, RXRPC_ACK_PING_RESPONSE, ack_serial,
 			       rxrpc_propose_ack_respond_to_ping);
@@ -889,7 +848,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	 * indicates that the client address changed due to NAT.  The server
 	 * lost the call because it switched to a different peer.
 	 */
-	if (unlikely(buf.ack.reason == RXRPC_ACK_EXCEEDS_WINDOW) &&
+	if (unlikely(ack.reason == RXRPC_ACK_EXCEEDS_WINDOW) &&
 	    first_soft_ack == 1 &&
 	    prev_pkt == 0 &&
 	    rxrpc_is_client_call(call)) {
@@ -902,7 +861,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	 * indicate a change of address.  However, we can retransmit the call
 	 * if we still have it buffered to the beginning.
 	 */
-	if (unlikely(buf.ack.reason == RXRPC_ACK_OUT_OF_SEQUENCE) &&
+	if (unlikely(ack.reason == RXRPC_ACK_OUT_OF_SEQUENCE) &&
 	    first_soft_ack == 1 &&
 	    prev_pkt == 0 &&
 	    call->acks_hard_ack == 0 &&
@@ -917,14 +876,19 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->acks_first_seq,
 					   prev_pkt, call->acks_prev_seq);
-		return;
+		goto out_not_locked;
 	}
 
-	buf.info.rxMTU = 0;
+	info.rxMTU = 0;
 	ioffset = offset + nr_acks + 3;
-	if (skb->len >= ioffset + sizeof(buf.info) &&
-	    skb_copy_bits(skb, ioffset, &buf.info, sizeof(buf.info)) < 0)
-		return rxrpc_proto_abort("XAI", call, 0);
+	if (skb->len >= ioffset + sizeof(info) &&
+	    skb_copy_bits(skb, ioffset, &info, sizeof(info)) < 0) {
+		rxrpc_proto_abort("XAI", call, 0);
+		goto out_not_locked;
+	}
+
+	if (nr_acks > 0)
+		skb_condense(skb);
 
 	spin_lock(&call->input_lock);
 
@@ -940,13 +904,22 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	call->acks_first_seq = first_soft_ack;
 	call->acks_prev_seq = prev_pkt;
 
-	if (buf.ack.reason != RXRPC_ACK_PING &&
-	    after(acked_serial, call->acks_highest_serial))
-		call->acks_highest_serial = acked_serial;
+	switch (ack.reason) {
+	case RXRPC_ACK_PING:
+		break;
+	case RXRPC_ACK_PING_RESPONSE:
+		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
+					  ack_serial);
+		fallthrough;
+	default:
+		if (after(acked_serial, call->acks_highest_serial))
+			call->acks_highest_serial = acked_serial;
+		break;
+	}
 
 	/* Parse rwind and mtu sizes if provided. */
-	if (buf.info.rxMTU)
-		rxrpc_input_ackinfo(call, skb, &buf.info);
+	if (info.rxMTU)
+		rxrpc_input_ackinfo(call, skb, &info);
 
 	if (first_soft_ack == 0) {
 		rxrpc_proto_abort("AK0", call, 0);
@@ -982,12 +955,24 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	if (nr_acks > 0) {
-		if (skb_copy_bits(skb, offset, buf.acks, nr_acks) < 0) {
+		if (offset > (int)skb->len - nr_acks) {
 			rxrpc_proto_abort("XSA", call, 0);
 			goto out;
 		}
-		rxrpc_input_soft_acks(call, buf.acks, first_soft_ack, nr_acks,
-				      &summary);
+
+		spin_lock(&call->acks_ack_lock);
+		skb_old = call->acks_soft_tbl;
+		call->acks_soft_tbl = skb;
+		spin_unlock(&call->acks_ack_lock);
+
+		rxrpc_input_soft_acks(call, skb->data + offset, first_soft_ack,
+				      nr_acks, &summary);
+		skb_put = NULL;
+	} else if (call->acks_soft_tbl) {
+		spin_lock(&call->acks_ack_lock);
+		skb_old = call->acks_soft_tbl;
+		call->acks_soft_tbl = NULL;
+		spin_unlock(&call->acks_ack_lock);
 	}
 
 	if (test_bit(RXRPC_CALL_TX_LAST, &call->flags) &&
@@ -999,6 +984,9 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
 out:
 	spin_unlock(&call->input_lock);
+out_not_locked:
+	rxrpc_free_skb(skb_put, rxrpc_skb_freed);
+	rxrpc_free_skb(skb_old, rxrpc_skb_freed);
 }
 
 /*
@@ -1071,7 +1059,7 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 
 	case RXRPC_PACKET_TYPE_ACK:
 		rxrpc_input_ack(call, skb);
-		break;
+		goto no_free;
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		_proto("Rx BUSY %%%u", sp->hdr.serial);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index a96ae7f58148..9b567aff3e84 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -600,7 +600,6 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
  */
 int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	__releases(&rx->sk.sk_lock.slock)
-	__releases(&call->user_mutex)
 {
 	enum rxrpc_call_state state;
 	struct rxrpc_call *call;


