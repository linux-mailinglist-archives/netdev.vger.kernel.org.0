Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16A7621F29
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiKHWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiKHWWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A7066CAA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLDhDuzvLaQWiTxsae5WXqeUEYn97hwH5Sq0E1VeTDI=;
        b=g8yU5VzeGlmBWV1pm5XABo+IU5nv42EcTBYO4F/vGvHZP8ge+IydN2AY9T4T2z+VvHfrN9
        pf2a8fboLhaCdCJXiJq/tM3XuAtkR2C0tQpeEYv2yXTUDd5S5Zz7ChsxTJdu9ZQS6esR+w
        oTbkIA591Ef4DinXL9R9WM7CebzZiRY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-dpePnMI1MiypdzSn4VaZfA-1; Tue, 08 Nov 2022 17:20:02 -0500
X-MC-Unique: dpePnMI1MiypdzSn4VaZfA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3576C299E746;
        Tue,  8 Nov 2022 22:20:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60CE7C15BB5;
        Tue,  8 Nov 2022 22:20:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 20/26] rxrpc: Get rid of the Rx ring
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:00 +0000
Message-ID: <166794600071.2389296.2261410775182295313.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of the Rx ring and replace it with a pair of queues instead.  One
queue gets the packets that are in-sequence and are ready for processing by
recvmsg(); the other queue gets the out-of-sequence packets for addition to
the first queue as the holes get filled.

The annotation ring is removed and replaced with a SACK table.  The SACK
table has the bits set that correspond exactly to the sequence number of
the packet being acked.  The SACK ring is copied when an ACK packet is
being assembled and rotated so that the first ACK is in byte 0.

Flow control handling is altered so that packets that are moved to the
in-sequence queue are hard-ACK'd even before they're consumed - and then
the Rx window size in the ACK packet (rsize) is shrunk down to compensate
(even going to 0 if the window is full).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   19 ++--
 net/rxrpc/ar-internal.h      |   29 ++++--
 net/rxrpc/call_object.c      |    7 +
 net/rxrpc/conn_object.c      |    2 
 net/rxrpc/input.c            |  213 ++++++++++++++++++++++++++----------------
 net/rxrpc/misc.c             |    5 -
 net/rxrpc/output.c           |   95 +++++++++++--------
 net/rxrpc/proc.c             |    7 +
 net/rxrpc/recvmsg.c          |  117 ++++++++++++-----------
 net/rxrpc/rxkad.c            |    1 
 net/rxrpc/sysctl.c           |    2 
 11 files changed, 290 insertions(+), 207 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 03a984e661bc..284a1560b0a8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -104,7 +104,12 @@
 	EM(rxrpc_receive_incoming,		"INC") \
 	EM(rxrpc_receive_queue,			"QUE") \
 	EM(rxrpc_receive_queue_last,		"QLS") \
-	E_(rxrpc_receive_rotate,		"ROT")
+	EM(rxrpc_receive_queue_oos,		"QUO") \
+	EM(rxrpc_receive_queue_oos_last,	"QOL") \
+	EM(rxrpc_receive_oos,			"OOS") \
+	EM(rxrpc_receive_oos_last,		"OSL") \
+	EM(rxrpc_receive_rotate,		"ROT") \
+	E_(rxrpc_receive_rotate_last,		"RLS")
 
 #define rxrpc_recvmsg_traces \
 	EM(rxrpc_recvmsg_cont,			"CONT") \
@@ -860,8 +865,7 @@ TRACE_EVENT(rxrpc_receive,
 		    __field(enum rxrpc_receive_trace,	why		)
 		    __field(rxrpc_serial_t,		serial		)
 		    __field(rxrpc_seq_t,		seq		)
-		    __field(rxrpc_seq_t,		hard_ack	)
-		    __field(rxrpc_seq_t,		top		)
+		    __field(u64,			window		)
 			     ),
 
 	    TP_fast_assign(
@@ -869,8 +873,7 @@ TRACE_EVENT(rxrpc_receive,
 		    __entry->why = why;
 		    __entry->serial = serial;
 		    __entry->seq = seq;
-		    __entry->hard_ack = call->rx_hard_ack;
-		    __entry->top = call->rx_top;
+		    __entry->window = atomic64_read(&call->ackr_window);
 			   ),
 
 	    TP_printk("c=%08x %s r=%08x q=%08x w=%08x-%08x",
@@ -878,8 +881,8 @@ TRACE_EVENT(rxrpc_receive,
 		      __print_symbolic(__entry->why, rxrpc_receive_traces),
 		      __entry->serial,
 		      __entry->seq,
-		      __entry->hard_ack,
-		      __entry->top)
+		      lower_32_bits(__entry->window),
+		      upper_32_bits(__entry->window))
 	    );
 
 TRACE_EVENT(rxrpc_recvmsg,
@@ -1459,7 +1462,7 @@ TRACE_EVENT(rxrpc_call_reset,
 		    __entry->call_serial = call->rx_serial;
 		    __entry->conn_serial = call->conn->hi_serial;
 		    __entry->tx_seq = call->tx_hard_ack;
-		    __entry->rx_seq = call->rx_hard_ack;
+		    __entry->rx_seq = call->rx_highest_seq;
 			   ),
 
 	    TP_printk("c=%08x %08x:%08x r=%08x/%08x tx=%08x rx=%08x",
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e93ed18816b1..c6c5bb3d3688 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -198,7 +198,6 @@ struct rxrpc_skb_priv {
 	u16		remain;
 	u16		offset;		/* Offset of data */
 	u16		len;		/* Length of data */
-	u8		rx_flags;	/* Received packet flags */
 	u8		flags;
 #define RXRPC_RX_VERIFIED	0x01
 
@@ -644,8 +643,20 @@ struct rxrpc_call {
 	rxrpc_seq_t		tx_hard_ack;	/* Dead slot in buffer; the first transmitted but
 						 * not hard-ACK'd packet follows this.
 						 */
+
+	/* Transmitted data tracking. */
 	rxrpc_seq_t		tx_top;		/* Highest Tx slot allocated. */
 	u16			tx_backoff;	/* Delay to insert due to Tx failure */
+	u8			tx_winsize;	/* Maximum size of Tx window */
+
+	/* Received data tracking */
+	struct sk_buff_head	recvmsg_queue;	/* Queue of packets ready for recvmsg() */
+	struct sk_buff_head	rx_oos_queue;	/* Queue of out of sequence packets */
+
+	rxrpc_seq_t		rx_highest_seq;	/* Higest sequence number received */
+	rxrpc_seq_t		rx_consumed;	/* Highest packet consumed */
+	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
+	u8			rx_winsize;	/* Size of Rx window */
 
 	/* TCP-style slow-start congestion control [RFC5681].  Since the SMSS
 	 * is fixed, we keep these numbers in terms of segments (ie. DATA
@@ -660,23 +671,19 @@ struct rxrpc_call {
 	u8			cong_cumul_acks; /* Cumulative ACK count */
 	ktime_t			cong_tstamp;	/* Last time cwnd was changed */
 
-	rxrpc_seq_t		rx_hard_ack;	/* Dead slot in buffer; the first received but not
-						 * consumed packet follows this.
-						 */
-	rxrpc_seq_t		rx_top;		/* Highest Rx slot allocated. */
-	rxrpc_seq_t		rx_expect_next;	/* Expected next packet sequence number */
-	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
-	u8			rx_winsize;	/* Size of Rx window */
-	u8			tx_winsize;	/* Maximum size of Tx window */
-
 	spinlock_t		input_lock;	/* Lock for packet input to this call */
 
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
+	atomic64_t		ackr_window;	/* Base (in LSW) and top (in MSW) of SACK window */
 	atomic_t		ackr_nr_unacked; /* Number of unacked packets */
 	atomic_t		ackr_nr_consumed; /* Number of packets needing hard ACK */
+	struct {
+#define RXRPC_SACK_SIZE 256
+		 /* SACK table for soft-acked packets */
+		u8		ackr_sack_table[RXRPC_SACK_SIZE];
+	} __aligned(8);
 
 	/* RTT management */
 	rxrpc_serial_t		rtt_serial[4];	/* Serial number of DATA or PING sent */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 8f9e88897197..4d8601c6a32d 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -155,6 +155,8 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_LIST_HEAD(&call->accept_link);
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
+	skb_queue_head_init(&call->recvmsg_queue);
+	skb_queue_head_init(&call->rx_oos_queue);
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->lock);
 	spin_lock_init(&call->notify_lock);
@@ -165,13 +167,12 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->tx_total_len = -1;
 	call->next_rx_timo = 20 * HZ;
 	call->next_req_timo = 1 * HZ;
+	atomic64_set(&call->ackr_window, 0x100000001ULL);
 
 	memset(&call->sock_node, 0xed, sizeof(call->sock_node));
 
-	/* Leave space in the ring to handle a maxed-out jumbo packet */
 	call->rx_winsize = rxrpc_rx_window_size;
 	call->tx_winsize = 16;
-	call->rx_expect_next = 1;
 
 	call->cong_cwnd = 2;
 	call->cong_ssthresh = RXRPC_RXTX_BUFF_SIZE - 1;
@@ -519,6 +520,8 @@ static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 		rxrpc_free_skb(call->rxtx_buffer[i], rxrpc_skb_cleaned);
 		call->rxtx_buffer[i] = NULL;
 	}
+	skb_queue_purge(&call->recvmsg_queue);
+	skb_queue_purge(&call->rx_oos_queue);
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 22089e37e97f..f7ea71ae6159 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -175,7 +175,7 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 		trace_rxrpc_disconnect_call(call);
 		switch (call->completion) {
 		case RXRPC_CALL_SUCCEEDED:
-			chan->last_seq = call->rx_hard_ack;
+			chan->last_seq = call->rx_highest_seq;
 			chan->last_type = RXRPC_PACKET_TYPE_ACK;
 			break;
 		case RXRPC_CALL_LOCALLY_ABORTED:
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 0e7545ed0128..947e7196e2be 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -312,18 +312,43 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 	return rxrpc_end_tx_phase(call, true, "ETD");
 }
 
+static void rxrpc_input_update_ack_window(struct rxrpc_call *call,
+					  rxrpc_seq_t window, rxrpc_seq_t wtop)
+{
+	atomic64_set_release(&call->ackr_window, ((u64)wtop) << 32 | window);
+}
+
 /*
- * Process a DATA packet, adding the packet to the Rx ring.  The caller's
- * packet ref must be passed on or discarded.
+ * Push a DATA packet onto the Rx queue.
+ */
+static void rxrpc_input_queue_data(struct rxrpc_call *call, struct sk_buff *skb,
+				   rxrpc_seq_t window, rxrpc_seq_t wtop,
+				   enum rxrpc_receive_trace why)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	bool last = sp->hdr.flags & RXRPC_LAST_PACKET;
+
+	__skb_queue_tail(&call->recvmsg_queue, skb);
+	rxrpc_input_update_ack_window(call, window, wtop);
+
+	trace_rxrpc_receive(call, last ? why + 1 : why, sp->hdr.serial, sp->hdr.seq);
+}
+
+/*
+ * Process a DATA packet.
  */
 static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct sk_buff *oos;
 	rxrpc_serial_t serial = sp->hdr.serial;
-	rxrpc_seq_t seq = sp->hdr.seq, hard_ack;
-	unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
+	u64 win = atomic64_read(&call->ackr_window);
+	rxrpc_seq_t window = lower_32_bits(win);
+	rxrpc_seq_t wtop = upper_32_bits(win);
+	rxrpc_seq_t wlimit = window + call->rx_winsize - 1;
+	rxrpc_seq_t seq = sp->hdr.seq;
 	bool last = sp->hdr.flags & RXRPC_LAST_PACKET;
-	bool acked = false;
+	int ack_reason = -1;
 
 	rxrpc_inc_stat(call->rxnet, stat_rx_data);
 	if (sp->hdr.flags & RXRPC_REQUEST_ACK)
@@ -331,112 +356,135 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 	if (sp->hdr.flags & RXRPC_JUMBO_PACKET)
 		rxrpc_inc_stat(call->rxnet, stat_rx_data_jumbo);
 
-	hard_ack = READ_ONCE(call->rx_hard_ack);
-
-	_proto("Rx DATA %%%u { #%x l=%u }", serial, seq, last);
-
 	if (last) {
-		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-		    seq != call->rx_top) {
+		if (test_and_set_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
+		    seq + 1 != wtop) {
 			rxrpc_proto_abort("LSN", call, seq);
-			goto out;
+			goto err_free;
 		}
 	} else {
 		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-		    after_eq(seq, call->rx_top)) {
+		    after_eq(seq, wtop)) {
+			pr_warn("Packet beyond last: c=%x q=%x window=%x-%x wlimit=%x\n",
+				call->debug_id, seq, window, wtop, wlimit);
 			rxrpc_proto_abort("LSA", call, seq);
-			goto out;
+			goto err_free;
 		}
 	}
 
+	if (after(seq, call->rx_highest_seq))
+		call->rx_highest_seq = seq;
+
 	trace_rxrpc_rx_data(call->debug_id, seq, serial, sp->hdr.flags);
 
-	if (before_eq(seq, hard_ack)) {
-		rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
-			       rxrpc_propose_ack_input_data);
-		goto out;
+	if (before(seq, window)) {
+		ack_reason = RXRPC_ACK_DUPLICATE;
+		goto send_ack;
 	}
-
-	if (call->rxtx_buffer[ix]) {
-		rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
-			       rxrpc_propose_ack_input_data);
-		goto out;
+	if (after(seq, wlimit)) {
+		ack_reason = RXRPC_ACK_EXCEEDS_WINDOW;
+		goto send_ack;
 	}
 
-	if (after(seq, hard_ack + call->rx_winsize)) {
-		rxrpc_send_ACK(call, RXRPC_ACK_EXCEEDS_WINDOW, serial,
-			       rxrpc_propose_ack_input_data);
-		goto out;
-	}
+	/* Queue the packet. */
+	if (seq == window) {
+		rxrpc_seq_t reset_from;
+		bool reset_sack = false;
 
-	if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
-		rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, serial,
-			       rxrpc_propose_ack_input_data);
-		acked = true;
-	}
+		if (sp->hdr.flags & RXRPC_REQUEST_ACK)
+			ack_reason = RXRPC_ACK_REQUESTED;
+		/* Send an immediate ACK if we fill in a hole */
+		else if (!skb_queue_empty(&call->rx_oos_queue))
+			ack_reason = RXRPC_ACK_DELAY;
 
-	if (after(seq, call->ackr_highest_seq))
-		call->ackr_highest_seq = seq;
+		window++;
+		if (after(window, wtop))
+			wtop = window;
 
-	/* Queue the packet.  We use a couple of memory barriers here as need
-	 * to make sure that rx_top is perceived to be set after the buffer
-	 * pointer and that the buffer pointer is set after the annotation and
-	 * the skb data.
-	 *
-	 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
-	 * and also rxrpc_fill_out_ack().
-	 */
-	call->rxtx_annotations[ix] = 1;
-	smp_wmb();
-	call->rxtx_buffer[ix] = skb;
-	if (after(seq, call->rx_top)) {
-		smp_store_release(&call->rx_top, seq);
-	} else if (before(seq, call->rx_top)) {
-		/* Send an immediate ACK if we fill in a hole */
-		if (!acked) {
-			rxrpc_send_ACK(call, RXRPC_ACK_DELAY, serial,
-				       rxrpc_propose_ack_input_data_hole);
-			acked = true;
+		spin_lock(&call->recvmsg_queue.lock);
+		rxrpc_input_queue_data(call, skb, window, wtop, rxrpc_receive_queue);
+		skb = NULL;
+
+		while ((oos = skb_peek(&call->rx_oos_queue))) {
+			struct rxrpc_skb_priv *osp = rxrpc_skb(oos);
+
+			if (after(osp->hdr.seq, window))
+				break;
+
+			__skb_unlink(oos, &call->rx_oos_queue);
+			last = osp->hdr.flags & RXRPC_LAST_PACKET;
+			seq = osp->hdr.seq;
+			if (!reset_sack) {
+				reset_from = seq;
+				reset_sack = true;
+			}
+
+			window++;
+			rxrpc_input_queue_data(call, oos, window, wtop,
+						 rxrpc_receive_queue_oos);
 		}
-	}
 
-	/* From this point on, we're not allowed to touch the packet any longer
-	 * as its ref now belongs to the Rx ring.
-	 */
-	skb = NULL;
-	sp = NULL;
+		spin_unlock(&call->recvmsg_queue.lock);
 
-	if (last) {
-		set_bit(RXRPC_CALL_RX_LAST, &call->flags);
-		trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
+		if (reset_sack) {
+			do {
+				call->ackr_sack_table[reset_from % RXRPC_SACK_SIZE] = 0;
+			} while (reset_from++, before(reset_from, window));
+		}
 	} else {
-		trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
-	}
+		bool keep = false;
+
+		ack_reason = RXRPC_ACK_OUT_OF_SEQUENCE;
+
+		if (!call->ackr_sack_table[seq % RXRPC_SACK_SIZE]) {
+			call->ackr_sack_table[seq % RXRPC_SACK_SIZE] = 1;
+			keep = 1;
+		}
+
+		if (after(seq + 1, wtop)) {
+			wtop = seq + 1;
+			rxrpc_input_update_ack_window(call, window, wtop);
+		}
+
+		if (!keep) {
+			ack_reason = RXRPC_ACK_DUPLICATE;
+			goto send_ack;
+		}
+
+		skb_queue_walk(&call->rx_oos_queue, oos) {
+			struct rxrpc_skb_priv *osp = rxrpc_skb(oos);
 
-	if (after_eq(seq, call->rx_expect_next)) {
-		if (after(seq, call->rx_expect_next)) {
-			_net("OOS %u > %u", seq, call->rx_expect_next);
-			rxrpc_send_ACK(call, RXRPC_ACK_OUT_OF_SEQUENCE, serial,
-				       rxrpc_propose_ack_input_data);
-			acked = true;
+			if (after(osp->hdr.seq, seq)) {
+				__skb_queue_before(&call->rx_oos_queue, oos, skb);
+				goto oos_queued;
+			}
 		}
-		call->rx_expect_next = seq + 1;
+
+		__skb_queue_tail(&call->rx_oos_queue, skb);
+	oos_queued:
+		trace_rxrpc_receive(call, last ? rxrpc_receive_oos_last : rxrpc_receive_oos,
+				    sp->hdr.serial, sp->hdr.seq);
+		skb = NULL;
 	}
 
-out:
-	if (!acked &&
-	    atomic_inc_return(&call->ackr_nr_unacked) > 2)
-		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
+send_ack:
+	if (ack_reason < 0 &&
+	    atomic_inc_return(&call->ackr_nr_unacked) > 2 &&
+	    test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
+		ack_reason = RXRPC_ACK_IDLE;
+	} else if (ack_reason >= 0) {
+		set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
+	}
+
+	if (ack_reason >= 0)
+		rxrpc_send_ACK(call, ack_reason, serial,
 			       rxrpc_propose_ack_input_data);
 	else
 		rxrpc_propose_delay_ACK(call, serial,
 					rxrpc_propose_ack_input_data);
 
-	trace_rxrpc_notify_socket(call->debug_id, serial);
-	rxrpc_notify_socket(call);
-
+err_free:
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
-	_leave(" [queued]");
 }
 
 /*
@@ -498,8 +546,9 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	rxrpc_serial_t serial = sp->hdr.serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq;
 
-	_enter("{%u,%u},{%u,%u}",
-	       call->rx_hard_ack, call->rx_top, skb->len, seq0);
+	_enter("{%llx,%x},{%u,%x}",
+	       atomic64_read(&call->ackr_window), call->rx_highest_seq,
+	       skb->len, seq0);
 
 	_proto("Rx DATA %%%u { #%u f=%02x }",
 	       sp->hdr.serial, seq0, sp->hdr.flags);
diff --git a/net/rxrpc/misc.c b/net/rxrpc/misc.c
index f5f03f27bd6c..056c428d8bf3 100644
--- a/net/rxrpc/misc.c
+++ b/net/rxrpc/misc.c
@@ -40,10 +40,7 @@ unsigned long rxrpc_idle_ack_delay = HZ / 2;
  * limit is hit, we should generate an EXCEEDS_WINDOW ACK and discard further
  * packets.
  */
-unsigned int rxrpc_rx_window_size = RXRPC_INIT_RX_WINDOW_SIZE;
-#if (RXRPC_RXTX_BUFF_SIZE - 1) < RXRPC_INIT_RX_WINDOW_SIZE
-#error Need to reduce RXRPC_INIT_RX_WINDOW_SIZE
-#endif
+unsigned int rxrpc_rx_window_size = 255;
 
 /*
  * Maximum Rx MTU size.  This indicates to the sender the size of jumbo packet
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index f7bb792c8aa1..0a4f37d7b6b5 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -74,47 +74,64 @@ static void rxrpc_set_keepalive(struct rxrpc_call *call)
  */
 static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 struct rxrpc_call *call,
-				 struct rxrpc_txbuf *txb,
-				 rxrpc_seq_t *_hard_ack,
-				 rxrpc_seq_t *_top)
+				 struct rxrpc_txbuf *txb)
 {
 	struct rxrpc_ackinfo ackinfo;
-	unsigned int tmp;
-	rxrpc_seq_t hard_ack, top, seq;
-	int ix;
+	unsigned int qsize;
+	rxrpc_seq_t window, wtop, wrap_point, ix, first;
+	int rsize;
+	u64 wtmp;
 	u32 mtu, jmax;
 	u8 *ackp = txb->acks;
+	u8 sack_buffer[sizeof(call->ackr_sack_table)] __aligned(8);
 
-	tmp = atomic_xchg(&call->ackr_nr_unacked, 0);
-	tmp |= atomic_xchg(&call->ackr_nr_consumed, 0);
-	if (!tmp && (txb->ack.reason == RXRPC_ACK_DELAY ||
-		     txb->ack.reason == RXRPC_ACK_IDLE)) {
-		rxrpc_inc_stat(call->rxnet, stat_tx_ack_skip);
-		return 0;
-	}
-
+	atomic_set(&call->ackr_nr_unacked, 0);
+	atomic_set(&call->ackr_nr_consumed, 0);
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_fill);
 
 	/* Barrier against rxrpc_input_data(). */
-	hard_ack = READ_ONCE(call->rx_hard_ack);
-	top = smp_load_acquire(&call->rx_top);
-	*_hard_ack = hard_ack;
-	*_top = top;
-
-	txb->ack.firstPacket	= htonl(hard_ack + 1);
-	txb->ack.previousPacket	= htonl(call->ackr_highest_seq);
-	txb->ack.nAcks		= top - hard_ack;
-
-	if (txb->ack.nAcks) {
-		seq = hard_ack + 1;
-		do {
-			ix = seq & RXRPC_RXTX_BUFF_MASK;
-			if (call->rxtx_buffer[ix])
-				*ackp++ = RXRPC_ACK_TYPE_ACK;
-			else
-				*ackp++ = RXRPC_ACK_TYPE_NACK;
-			seq++;
-		} while (before_eq(seq, top));
+retry:
+	wtmp   = atomic64_read_acquire(&call->ackr_window);
+	window = lower_32_bits(wtmp);
+	wtop   = upper_32_bits(wtmp);
+	txb->ack.firstPacket = htonl(window);
+	txb->ack.nAcks = 0;
+
+	if (after(wtop, window)) {
+		/* Try to copy the SACK ring locklessly.  We can use the copy,
+		 * only if the now-current top of the window didn't go past the
+		 * previously read base - otherwise we can't know whether we
+		 * have old data or new data.
+		 */
+		memcpy(sack_buffer, call->ackr_sack_table, sizeof(sack_buffer));
+		wrap_point = window + RXRPC_SACK_SIZE - 1;
+		wtmp   = atomic64_read_acquire(&call->ackr_window);
+		window = lower_32_bits(wtmp);
+		wtop   = upper_32_bits(wtmp);
+		if (after(wtop, wrap_point)) {
+			cond_resched();
+			goto retry;
+		}
+
+		/* The buffer is maintained as a ring with an invariant mapping
+		 * between bit position and sequence number, so we'll probably
+		 * need to rotate it.
+		 */
+		txb->ack.nAcks = wtop - window;
+		ix = window % RXRPC_SACK_SIZE;
+		first = sizeof(sack_buffer) - ix;
+
+		if (ix + txb->ack.nAcks <= RXRPC_SACK_SIZE) {
+			memcpy(txb->acks, sack_buffer + ix, txb->ack.nAcks);
+		} else {
+			memcpy(txb->acks, sack_buffer + ix, first);
+			memcpy(txb->acks + first, sack_buffer,
+			       txb->ack.nAcks - first);
+		}
+
+		ackp += txb->ack.nAcks;
+	} else if (before(wtop, window)) {
+		pr_warn("ack window backward %x %x", window, wtop);
 	} else if (txb->ack.reason == RXRPC_ACK_DELAY) {
 		txb->ack.reason = RXRPC_ACK_IDLE;
 	}
@@ -122,16 +139,18 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	mtu = conn->params.peer->if_mtu;
 	mtu -= conn->params.peer->hdrsize;
 	jmax = rxrpc_rx_jumbo_max;
+	qsize = (window - 1) - call->rx_consumed;
+	rsize = max_t(int, call->rx_winsize - qsize, 0);
 	ackinfo.rxMTU		= htonl(rxrpc_rx_mtu);
 	ackinfo.maxMTU		= htonl(mtu);
-	ackinfo.rwind		= htonl(call->rx_winsize);
+	ackinfo.rwind		= htonl(rsize);
 	ackinfo.jumbo_max	= htonl(jmax);
 
 	*ackp++ = 0;
 	*ackp++ = 0;
 	*ackp++ = 0;
 	memcpy(ackp, &ackinfo, sizeof(ackinfo));
-	return top - hard_ack + 3 + sizeof(ackinfo);
+	return txb->ack.nAcks + 3 + sizeof(ackinfo);
 }
 
 /*
@@ -188,7 +207,6 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	struct msghdr msg;
 	struct kvec iov[1];
 	rxrpc_serial_t serial;
-	rxrpc_seq_t hard_ack, top;
 	size_t len, n;
 	int ret, rtt_slot = -1;
 
@@ -212,7 +230,7 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 		clear_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
 
 	spin_lock_bh(&call->lock);
-	n = rxrpc_fill_out_ack(conn, call, txb, &hard_ack, &top);
+	n = rxrpc_fill_out_ack(conn, call, txb);
 	spin_unlock_bh(&call->lock);
 	if (n == 0) {
 		kfree(pkt);
@@ -236,6 +254,9 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_send);
 
+	/* Grab the highest received seq as late as possible */
+	txb->ack.previousPacket	= htonl(call->rx_highest_seq);
+
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
 	call->peer->last_tx_at = ktime_get_seconds();
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 3877afd23598..d48af0178866 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -54,8 +54,9 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_call *call;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	unsigned long timeout = 0;
-	rxrpc_seq_t tx_hard_ack, rx_hard_ack;
+	rxrpc_seq_t tx_hard_ack;
 	char lbuff[50], rbuff[50];
+	u64 wtmp;
 
 	if (v == &rxnet->calls) {
 		seq_puts(seq,
@@ -91,7 +92,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	}
 
 	tx_hard_ack = READ_ONCE(call->tx_hard_ack);
-	rx_hard_ack = READ_ONCE(call->rx_hard_ack);
+	wtmp   = atomic64_read_acquire(&call->ackr_window);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
 		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %06lx\n",
@@ -106,7 +107,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->abort_code,
 		   call->debug_id,
 		   tx_hard_ack, READ_ONCE(call->tx_top) - tx_hard_ack,
-		   rx_hard_ack, READ_ONCE(call->rx_top) - rx_hard_ack,
+		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
 		   call->rx_serial,
 		   timeout);
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 401aae687830..efb85f983657 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -173,7 +173,8 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 		break;
 	}
 
-	trace_rxrpc_recvdata(call, rxrpc_recvmsg_terminal, call->rx_hard_ack,
+	trace_rxrpc_recvdata(call, rxrpc_recvmsg_terminal,
+			     lower_32_bits(atomic64_read(&call->ackr_window)) - 1,
 			     call->rx_pkt_offset, call->rx_pkt_len, ret);
 	return ret;
 }
@@ -183,10 +184,11 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
  */
 static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 {
+	rxrpc_seq_t whigh = READ_ONCE(call->rx_highest_seq);
+
 	_enter("%d,%s", call->debug_id, rxrpc_call_states[call->state]);
 
-	trace_rxrpc_receive(call, rxrpc_receive_end, 0, call->rx_top);
-	ASSERTCMP(call->rx_hard_ack, ==, call->rx_top);
+	trace_rxrpc_receive(call, rxrpc_receive_end, 0, whigh);
 
 	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY)
 		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
@@ -220,45 +222,53 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
 	rxrpc_serial_t serial;
-	rxrpc_seq_t hard_ack, top;
-	bool last = false;
-	int ix;
+	rxrpc_seq_t old_consumed = call->rx_consumed, tseq;
+	bool last;
+	int acked;
 
 	_enter("%d", call->debug_id);
 
-	hard_ack = call->rx_hard_ack;
-	top = smp_load_acquire(&call->rx_top);
-	ASSERT(before(hard_ack, top));
-
-	hard_ack++;
-	ix = hard_ack & RXRPC_RXTX_BUFF_MASK;
-	skb = call->rxtx_buffer[ix];
+further_rotation:
+	skb = skb_dequeue(&call->recvmsg_queue);
 	rxrpc_see_skb(skb, rxrpc_skb_rotated);
-	sp = rxrpc_skb(skb);
 
+	sp = rxrpc_skb(skb);
+	tseq   = sp->hdr.seq;
 	serial = sp->hdr.serial;
+	last   = sp->hdr.flags & RXRPC_LAST_PACKET;
 
-	if (sp->hdr.flags & RXRPC_LAST_PACKET)
-		last = true;
-
-	call->rxtx_buffer[ix] = NULL;
-	call->rxtx_annotations[ix] = 0;
 	/* Barrier against rxrpc_input_data(). */
-	smp_store_release(&call->rx_hard_ack, hard_ack);
+	if (after(tseq, call->rx_consumed))
+		smp_store_release(&call->rx_consumed, tseq);
 
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 
-	trace_rxrpc_receive(call, rxrpc_receive_rotate, serial, hard_ack);
+	trace_rxrpc_receive(call, last ? rxrpc_receive_rotate_last : rxrpc_receive_rotate,
+			    serial, call->rx_consumed);
 	if (last) {
 		rxrpc_end_rx_phase(call, serial);
-	} else {
-		/* Check to see if there's an ACK that needs sending. */
-		if (atomic_inc_return(&call->ackr_nr_consumed) > 2 &&
-		    !test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
-			rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
-				       rxrpc_propose_ack_rotate_rx);
-			rxrpc_transmit_ack_packets(call->peer->local);
-		}
+		return;
+	}
+
+	/* The next packet on the queue might entirely overlap with the one we
+	 * just consumed; if so, rotate that away also.
+	 */
+	skb = skb_peek(&call->recvmsg_queue);
+	if (skb) {
+		sp = rxrpc_skb(skb);
+		if (sp->hdr.seq != call->rx_consumed &&
+		    after_eq(call->rx_consumed, sp->hdr.seq))
+			goto further_rotation;
+	}
+
+	/* Check to see if there's an ACK that needs sending. */
+	acked = atomic_add_return(call->rx_consumed - old_consumed,
+				  &call->ackr_nr_consumed);
+	if (acked > 2 &&
+	    !test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
+		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
+			       rxrpc_propose_ack_rotate_rx);
+		rxrpc_transmit_ack_packets(call->peer->local);
 	}
 }
 
@@ -285,46 +295,38 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
-	rxrpc_serial_t serial;
-	rxrpc_seq_t hard_ack, top, seq;
+	rxrpc_seq_t seq = 0;
 	size_t remain;
 	unsigned int rx_pkt_offset, rx_pkt_len;
-	int ix, copy, ret = -EAGAIN, ret2;
+	int copy, ret = -EAGAIN, ret2;
 
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
 
 	if (call->state >= RXRPC_CALL_SERVER_ACK_REQUEST) {
-		seq = call->rx_hard_ack;
+		seq = lower_32_bits(atomic64_read(&call->ackr_window)) - 1;
 		ret = 1;
 		goto done;
 	}
 
-	/* Barriers against rxrpc_input_data(). */
-	hard_ack = call->rx_hard_ack;
-	seq = hard_ack + 1;
-
-	while (top = smp_load_acquire(&call->rx_top),
-	       before_eq(seq, top)
-	       ) {
-		ix = seq & RXRPC_RXTX_BUFF_MASK;
-		skb = call->rxtx_buffer[ix];
-		if (!skb) {
-			trace_rxrpc_recvdata(call, rxrpc_recvmsg_hole, seq,
-					     rx_pkt_offset, rx_pkt_len, 0);
-			rxrpc_transmit_ack_packets(call->peer->local);
-			break;
-		}
-		smp_rmb();
+	/* No one else can be removing stuff from the queue, so we shouldn't
+	 * need the Rx lock to walk it.
+	 */
+	skb = skb_peek(&call->recvmsg_queue);
+	while (skb) {
 		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		sp = rxrpc_skb(skb);
+		seq = sp->hdr.seq;
 
-		if (!(flags & MSG_PEEK)) {
-			serial = sp->hdr.serial;
-			trace_rxrpc_receive(call, rxrpc_receive_front,
-					    serial, seq);
+		if (after_eq(call->rx_consumed, seq)) {
+			kdebug("obsolete %x %x", call->rx_consumed, seq);
+			goto skip_obsolete;
 		}
 
+		if (!(flags & MSG_PEEK))
+			trace_rxrpc_receive(call, rxrpc_receive_front,
+					    sp->hdr.serial, seq);
+
 		if (msg)
 			sock_recv_timestamp(msg, sock->sk, skb);
 
@@ -338,6 +340,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 				ret = ret2;
 				goto out;
 			}
+			rxrpc_transmit_ack_packets(call->peer->local);
 		} else {
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_cont, seq,
 					     rx_pkt_offset, rx_pkt_len, 0);
@@ -370,16 +373,17 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			break;
 		}
 
+	skip_obsolete:
 		/* The whole packet has been transferred. */
 		if (sp->hdr.flags & RXRPC_LAST_PACKET)
 			ret = 1;
 		rx_pkt_offset = 0;
 		rx_pkt_len = 0;
 
+		skb = skb_peek_next(skb, &call->recvmsg_queue);
+
 		if (!(flags & MSG_PEEK))
 			rxrpc_rotate_rx_window(call);
-
-		seq++;
 	}
 
 out:
@@ -522,8 +526,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			ret = 0;
 
 		rxrpc_transmit_ack_packets(call->peer->local);
-		if (after(call->rx_top, call->rx_hard_ack) &&
-		    call->rxtx_buffer[(call->rx_hard_ack + 1) & RXRPC_RXTX_BUFF_MASK])
+		if (!skb_queue_empty(&call->recvmsg_queue))
 			rxrpc_notify_socket(call);
 		break;
 	default:
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index b19937776aa9..d87c99b36e01 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1191,7 +1191,6 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	abort_code = RXKADPACKETSHORT;
 	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
 			  ticket, ticket_len) < 0)
-		goto protocol_error_free;
 
 	ret = rxkad_decrypt_ticket(conn, server_key, skb, ticket, ticket_len,
 				   &session_key, &expiry, _abort_code);
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 2bd987364e44..cde3224a5cd2 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -14,7 +14,7 @@ static struct ctl_table_header *rxrpc_sysctl_reg_table;
 static const unsigned int four = 4;
 static const unsigned int max_backlog = RXRPC_BACKLOG_MAX - 1;
 static const unsigned int n_65535 = 65535;
-static const unsigned int n_max_acks = RXRPC_RXTX_BUFF_SIZE - 1;
+static const unsigned int n_max_acks = 255;
 static const unsigned long one_jiffy = 1;
 static const unsigned long max_jiffies = MAX_JIFFY_OFFSET;
 


