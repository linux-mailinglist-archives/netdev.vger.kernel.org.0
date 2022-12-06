Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED3644894
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiLFQBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiLFQBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D192ED61
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ud0BR5lK0w68f4Q4/GF3xMbOf+RWUyGnWV6DsI8fweI=;
        b=QDmDB0zZedivU6xUxWcG3d6lzM4DK1leEDVYeRzlnr8OKz0/lpel6wkn8siIeYtlcboM4h
        2DmnYnJ9vHRiX915jfCV1Fb3Yp8WBpLjgl2SyJcOHbRrVbZfRQUj/hTKqU5UOP3u1vQlaG
        YNVTwWY5KMir9sNRQVRLvtUL7W9qytw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-eOSbI8JXPceWiek0wSXd4A-1; Tue, 06 Dec 2022 11:00:20 -0500
X-MC-Unique: eOSbI8JXPceWiek0wSXd4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76A93101E148;
        Tue,  6 Dec 2022 16:00:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B1D40C6E16;
        Tue,  6 Dec 2022 16:00:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 12/32] rxrpc: Simplify ACK handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:00:17 +0000
Message-ID: <167034241714.1105287.4231275547126287090.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that general ACK transmission is done from the same thread as incoming
DATA packet wrangling, there's no possibility that the SACK table will be
being updated by the latter whilst the former is trying to copy it to an
ACK.

This means that we can safely rotate the SACK table whilst updating it
without having to take a lock, rather than keeping all the bits inside it
in fixed place and copying and then rotating it in the transmitter.

Therefore, simplify SACK handing by keeping track of starting point in the
ring and rotate slots down as we consume them.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   36 +++++++++++++++++++++++++++++++++
 net/rxrpc/ar-internal.h      |    1 +
 net/rxrpc/input.c            |   46 +++++++++++++++++++++---------------------
 net/rxrpc/output.c           |   46 ++++++++++++------------------------------
 4 files changed, 73 insertions(+), 56 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 0b69a10bde38..61b4dbe9f4a8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -16,6 +16,13 @@
 /*
  * Declare tracing information enums and their string mappings for display.
  */
+#define rxrpc_sack_traces \
+	EM(rxrpc_sack_advance,			"ADV")	\
+	EM(rxrpc_sack_fill,			"FIL")	\
+	EM(rxrpc_sack_nack,			"NAK")	\
+	EM(rxrpc_sack_none,			"---")	\
+	E_(rxrpc_sack_oos,			"OOS")
+
 #define rxrpc_call_poke_traces \
 	EM(rxrpc_call_poke_abort,		"Abort")	\
 	EM(rxrpc_call_poke_complete,		"Compl")	\
@@ -394,6 +401,7 @@ enum rxrpc_recvmsg_trace	{ rxrpc_recvmsg_traces } __mode(byte);
 enum rxrpc_req_ack_trace	{ rxrpc_req_ack_traces } __mode(byte);
 enum rxrpc_rtt_rx_trace		{ rxrpc_rtt_rx_traces } __mode(byte);
 enum rxrpc_rtt_tx_trace		{ rxrpc_rtt_tx_traces } __mode(byte);
+enum rxrpc_sack_trace		{ rxrpc_sack_traces } __mode(byte);
 enum rxrpc_skb_trace		{ rxrpc_skb_traces } __mode(byte);
 enum rxrpc_timer_trace		{ rxrpc_timer_traces } __mode(byte);
 enum rxrpc_tx_point		{ rxrpc_tx_points } __mode(byte);
@@ -424,6 +432,7 @@ rxrpc_recvmsg_traces;
 rxrpc_req_ack_traces;
 rxrpc_rtt_rx_traces;
 rxrpc_rtt_tx_traces;
+rxrpc_sack_traces;
 rxrpc_skb_traces;
 rxrpc_timer_traces;
 rxrpc_tx_points;
@@ -1845,6 +1854,33 @@ TRACE_EVENT(rxrpc_call_poked,
 		      __entry->call_debug_id)
 	    );
 
+TRACE_EVENT(rxrpc_sack,
+	    TP_PROTO(struct rxrpc_call *call, rxrpc_seq_t seq,
+		     unsigned int sack, enum rxrpc_sack_trace what),
+
+	    TP_ARGS(call, seq, sack, what),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		call_debug_id	)
+		    __field(rxrpc_seq_t,		seq	)
+		    __field(unsigned int,		sack	)
+		    __field(enum rxrpc_sack_trace,	what	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call_debug_id = call->debug_id;
+		    __entry->seq = seq;
+		    __entry->sack = sack;
+		    __entry->what = what;
+			   ),
+
+	    TP_printk("c=%08x q=%08x %s k=%x",
+		      __entry->call_debug_id,
+		      __entry->seq,
+		      __print_symbolic(__entry->what, rxrpc_sack_traces),
+		      __entry->sack)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_RXRPC_H */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index fbfee05f0558..092413e2b12a 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -681,6 +681,7 @@ struct rxrpc_call {
 
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
+	u16			ackr_sack_base;	/* Starting slot in SACK table ring */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_seq_t		ackr_window;	/* Base of SACK window */
 	rxrpc_seq_t		ackr_wtop;	/* Base of SACK window */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index c7a9c5c931de..423b1839c06d 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -350,6 +350,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct sk_buff *oos;
 	rxrpc_serial_t serial = sp->hdr.serial;
+	unsigned int sack = call->ackr_sack_base;
 	rxrpc_seq_t window = call->ackr_window;
 	rxrpc_seq_t wtop = call->ackr_wtop;
 	rxrpc_seq_t wlimit = window + call->rx_winsize - 1;
@@ -395,9 +396,6 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 
 	/* Queue the packet. */
 	if (seq == window) {
-		rxrpc_seq_t reset_from;
-		bool reset_sack = false;
-
 		if (sp->hdr.flags & RXRPC_REQUEST_ACK)
 			ack_reason = RXRPC_ACK_REQUESTED;
 		/* Send an immediate ACK if we fill in a hole */
@@ -407,8 +405,14 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 			call->ackr_nr_unacked++;
 
 		window++;
-		if (after(window, wtop))
+		if (after(window, wtop)) {
+			trace_rxrpc_sack(call, seq, sack, rxrpc_sack_none);
 			wtop = window;
+		} else {
+			trace_rxrpc_sack(call, seq, sack, rxrpc_sack_advance);
+			sack = (sack + 1) % RXRPC_SACK_SIZE;
+		}
+
 
 		rxrpc_get_skb(skb, rxrpc_skb_get_to_recvmsg);
 
@@ -425,43 +429,39 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 			__skb_unlink(oos, &call->rx_oos_queue);
 			last = osp->hdr.flags & RXRPC_LAST_PACKET;
 			seq = osp->hdr.seq;
-			if (!reset_sack) {
-				reset_from = seq;
-				reset_sack = true;
-			}
+			call->ackr_sack_table[sack] = 0;
+			trace_rxrpc_sack(call, seq, sack, rxrpc_sack_fill);
+			sack = (sack + 1) % RXRPC_SACK_SIZE;
 
 			window++;
 			rxrpc_input_queue_data(call, oos, window, wtop,
-						 rxrpc_receive_queue_oos);
+					       rxrpc_receive_queue_oos);
 		}
 
 		spin_unlock(&call->recvmsg_queue.lock);
 
-		if (reset_sack) {
-			do {
-				call->ackr_sack_table[reset_from % RXRPC_SACK_SIZE] = 0;
-			} while (reset_from++, before(reset_from, window));
-		}
+		call->ackr_sack_base = sack;
 	} else {
-		bool keep = false;
+		unsigned int slot;
 
 		ack_reason = RXRPC_ACK_OUT_OF_SEQUENCE;
 
-		if (!call->ackr_sack_table[seq % RXRPC_SACK_SIZE]) {
-			call->ackr_sack_table[seq % RXRPC_SACK_SIZE] = 1;
-			keep = 1;
+		slot = seq - window;
+		sack = (sack + slot) % RXRPC_SACK_SIZE;
+
+		if (call->ackr_sack_table[sack % RXRPC_SACK_SIZE]) {
+			ack_reason = RXRPC_ACK_DUPLICATE;
+			goto send_ack;
 		}
 
+		call->ackr_sack_table[sack % RXRPC_SACK_SIZE] |= 1;
+		trace_rxrpc_sack(call, seq, sack, rxrpc_sack_oos);
+
 		if (after(seq + 1, wtop)) {
 			wtop = seq + 1;
 			rxrpc_input_update_ack_window(call, window, wtop);
 		}
 
-		if (!keep) {
-			ack_reason = RXRPC_ACK_DUPLICATE;
-			goto send_ack;
-		}
-
 		skb_queue_walk(&call->rx_oos_queue, oos) {
 			struct rxrpc_skb_priv *osp = rxrpc_skb(oos);
 
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 3e132d9371ee..86dafa41236a 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -83,56 +83,36 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 struct rxrpc_txbuf *txb)
 {
 	struct rxrpc_ackinfo ackinfo;
-	unsigned int qsize;
-	rxrpc_seq_t window, wtop, wrap_point, ix, first;
+	unsigned int qsize, sack, wrap, to;
+	rxrpc_seq_t window, wtop;
 	int rsize;
 	u32 mtu, jmax;
 	u8 *ackp = txb->acks;
-	u8 sack_buffer[sizeof(call->ackr_sack_table)] __aligned(8);
 
 	call->ackr_nr_unacked = 0;
 	atomic_set(&call->ackr_nr_consumed, 0);
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_fill);
+	clear_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags);
 
-	/* Barrier against rxrpc_input_data(). */
-retry:
 	window = call->ackr_window;
 	wtop   = call->ackr_wtop;
+	sack   = call->ackr_sack_base % RXRPC_SACK_SIZE;
 	txb->ack.firstPacket = htonl(window);
-	txb->ack.nAcks = 0;
+	txb->ack.nAcks = wtop - window;
 
 	if (after(wtop, window)) {
-		/* Try to copy the SACK ring locklessly.  We can use the copy,
-		 * only if the now-current top of the window didn't go past the
-		 * previously read base - otherwise we can't know whether we
-		 * have old data or new data.
-		 */
-		memcpy(sack_buffer, call->ackr_sack_table, sizeof(sack_buffer));
-		wrap_point = window + RXRPC_SACK_SIZE - 1;
-		window = call->ackr_window;
-		wtop   = call->ackr_wtop;
-		if (after(wtop, wrap_point)) {
-			cond_resched();
-			goto retry;
-		}
-
-		/* The buffer is maintained as a ring with an invariant mapping
-		 * between bit position and sequence number, so we'll probably
-		 * need to rotate it.
-		 */
-		txb->ack.nAcks = wtop - window;
-		ix = window % RXRPC_SACK_SIZE;
-		first = sizeof(sack_buffer) - ix;
+		wrap = RXRPC_SACK_SIZE - sack;
+		to = min_t(unsigned int, txb->ack.nAcks, RXRPC_SACK_SIZE);
 
-		if (ix + txb->ack.nAcks <= RXRPC_SACK_SIZE) {
-			memcpy(txb->acks, sack_buffer + ix, txb->ack.nAcks);
+		if (sack + txb->ack.nAcks <= RXRPC_SACK_SIZE) {
+			memcpy(txb->acks, call->ackr_sack_table + sack, txb->ack.nAcks);
 		} else {
-			memcpy(txb->acks, sack_buffer + ix, first);
-			memcpy(txb->acks + first, sack_buffer,
-			       txb->ack.nAcks - first);
+			memcpy(txb->acks, call->ackr_sack_table + sack, wrap);
+			memcpy(txb->acks + wrap, call->ackr_sack_table,
+			       to - wrap);
 		}
 
-		ackp += txb->ack.nAcks;
+		ackp += to;
 	} else if (before(wtop, window)) {
 		pr_warn("ack window backward %x %x", window, wtop);
 	} else if (txb->ack.reason == RXRPC_ACK_DELAY) {


