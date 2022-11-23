Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67DB635A0F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiKWKcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiKWKcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:32:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DA774CDC
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGu50IfOP3uDpsakvUjFOBzb1krbEknOtWGgn5noUQc=;
        b=CwBvNOAMX5kY+G9HRFOs2xBmboLdhZc6Gi0ULKeR3uc2kvKqMonsRoAAPgkwyzm907OPsQ
        jZlM6IpOTLT0rNFoQGoUt1sQhc/nD+EbEhFJMg4AF2AaG1xoC7BvrVWPkNDJdjnhNr45JQ
        LmKM1kG2+IJ10xrgVup/3uTh3989WMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-fiB68FoeN0ewS0Gqfh0A0Q-1; Wed, 23 Nov 2022 05:15:49 -0500
X-MC-Unique: fiB68FoeN0ewS0Gqfh0A0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC4B7185A78B;
        Wed, 23 Nov 2022 10:15:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D466C1731B;
        Wed, 23 Nov 2022 10:15:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 10/17] rxrpc: Move DATA transmission into call
 processor work item
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:15:45 +0000
Message-ID: <166919854525.1258552.15607680997413621299.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move DATA transmission into the call processor work item.  In a future
patch, this will be called from the I/O thread rather than being itsown
work item.

This will allow DATA transmission to be driven directly by incoming ACKs,
pokes and timers as those are processed.

The Tx queue is also split: The queue of packets prepared by sendmsg is now
places in call->tx_sendmsg and the packet dispatcher decants the packets
into call->tx_buffer as space becomes available in the transmission
window.  This allows sendmsg to run ahead of the available space to try and
prevent an underflow in transmission.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    6 +++
 net/rxrpc/ar-internal.h      |    5 ++-
 net/rxrpc/call_event.c       |   76 +++++++++++++++++++++++++++++++++++---
 net/rxrpc/call_object.c      |    6 +++
 net/rxrpc/output.c           |   48 ++++++++++++++++++++++++
 net/rxrpc/sendmsg.c          |   83 +++++++-----------------------------------
 net/rxrpc/txbuf.c            |    2 +
 7 files changed, 147 insertions(+), 79 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4cab522da17b..8dbd17ebea7f 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -187,6 +187,7 @@
 	EM(rxrpc_call_queue_requeue,		"QUE requeue ") \
 	EM(rxrpc_call_queue_resend,		"QUE resend  ") \
 	EM(rxrpc_call_queue_timer,		"QUE timer   ") \
+	EM(rxrpc_call_queue_tx_data,		"QUE tx-data ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
@@ -741,6 +742,7 @@ TRACE_EVENT(rxrpc_txqueue,
 		    __field(rxrpc_seq_t,		acks_hard_ack	)
 		    __field(rxrpc_seq_t,		tx_bottom	)
 		    __field(rxrpc_seq_t,		tx_top		)
+		    __field(rxrpc_seq_t,		tx_prepared	)
 		    __field(int,			tx_winsize	)
 			     ),
 
@@ -750,16 +752,18 @@ TRACE_EVENT(rxrpc_txqueue,
 		    __entry->acks_hard_ack = call->acks_hard_ack;
 		    __entry->tx_bottom = call->tx_bottom;
 		    __entry->tx_top = call->tx_top;
+		    __entry->tx_prepared = call->tx_prepared;
 		    __entry->tx_winsize = call->tx_winsize;
 			   ),
 
-	    TP_printk("c=%08x %s f=%08x h=%08x n=%u/%u/%u",
+	    TP_printk("c=%08x %s f=%08x h=%08x n=%u/%u/%u/%u",
 		      __entry->call,
 		      __print_symbolic(__entry->why, rxrpc_txqueue_traces),
 		      __entry->tx_bottom,
 		      __entry->acks_hard_ack,
 		      __entry->tx_top - __entry->tx_bottom,
 		      __entry->tx_top - __entry->acks_hard_ack,
+		      __entry->tx_prepared - __entry->tx_bottom,
 		      __entry->tx_winsize)
 	    );
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 8bf8651a69b5..7f67be01fd12 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -638,9 +638,11 @@ struct rxrpc_call {
 
 	/* Transmitted data tracking. */
 	spinlock_t		tx_lock;	/* Transmit queue lock */
+	struct list_head	tx_sendmsg;	/* Sendmsg prepared packets */
 	struct list_head	tx_buffer;	/* Buffer of transmissible packets */
 	rxrpc_seq_t		tx_bottom;	/* First packet in buffer */
 	rxrpc_seq_t		tx_transmitted;	/* Highest packet transmitted */
+	rxrpc_seq_t		tx_prepared;	/* Highest Tx slot prepared. */
 	rxrpc_seq_t		tx_top;		/* Highest Tx slot allocated. */
 	u16			tx_backoff;	/* Delay to insert due to Tx failure */
 	u8			tx_winsize;	/* Maximum size of Tx window */
@@ -758,7 +760,7 @@ struct rxrpc_send_params {
  */
 struct rxrpc_txbuf {
 	struct rcu_head		rcu;
-	struct list_head	call_link;	/* Link in call->tx_queue */
+	struct list_head	call_link;	/* Link in call->tx_sendmsg/tx_buffer */
 	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
 	struct rxrpc_call	*call;		/* Call to which belongs */
 	ktime_t			last_sent;	/* Time at which last transmitted */
@@ -1074,6 +1076,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
 void rxrpc_reject_packets(struct rxrpc_local *);
 void rxrpc_send_keepalive(struct rxrpc_peer *);
+void rxrpc_transmit_one(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 
 /*
  * peer_event.c
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 618f0ba3163a..c6c6b805f3b1 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -292,6 +292,65 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	_leave("");
 }
 
+static unsigned int rxrpc_tx_window_space(struct rxrpc_call *call)
+{
+	unsigned int winsize = min_t(unsigned int, call->tx_winsize,
+				     call->cong_cwnd + call->cong_extra);
+	rxrpc_seq_t wtop = call->acks_hard_ack + winsize;
+
+	return after_eq(call->tx_top, wtop) ? 0 : wtop - call->tx_top;
+}
+
+/*
+ * Decant some if the sendmsg prepared queue into the transmission buffer.
+ */
+static void rxrpc_decant_prepared_tx(struct rxrpc_call *call)
+{
+	struct rxrpc_txbuf *txb;
+
+	if (rxrpc_is_client_call(call) &&
+	    !test_bit(RXRPC_CALL_EXPOSED, &call->flags))
+		rxrpc_expose_client_call(call);
+
+	while ((txb = list_first_entry_or_null(&call->tx_sendmsg,
+					       struct rxrpc_txbuf, call_link))) {
+		spin_lock(&call->tx_lock);
+		list_del(&txb->call_link);
+		spin_unlock(&call->tx_lock);
+
+		call->tx_top = txb->seq;
+		list_add_tail(&txb->call_link, &call->tx_buffer);
+
+		rxrpc_transmit_one(call, txb);
+
+		if (rxrpc_tx_window_space(call) == 0)
+			break;
+	}
+}
+
+static void rxrpc_transmit_some_data(struct rxrpc_call *call)
+{
+	switch (call->state) {
+	case RXRPC_CALL_SERVER_ACK_REQUEST:
+		if (list_empty(&call->tx_sendmsg))
+			return;
+		fallthrough;
+
+	case RXRPC_CALL_SERVER_SEND_REPLY:
+	case RXRPC_CALL_SERVER_AWAIT_ACK:
+	case RXRPC_CALL_CLIENT_SEND_REQUEST:
+	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
+		if (rxrpc_tx_window_space(call) == 0)
+			return;
+		if (list_empty(&call->tx_sendmsg))
+			return;
+		rxrpc_decant_prepared_tx(call);
+		break;
+	default:
+		return;
+	}
+}
+
 /*
  * Handle retransmission and deferred ACK/abort generation.
  */
@@ -310,19 +369,22 @@ void rxrpc_process_call(struct work_struct *work)
 	       call->debug_id, rxrpc_call_states[call->state], call->events);
 
 recheck_state:
+	if (call->acks_hard_ack != call->tx_bottom)
+		rxrpc_shrink_call_tx_buffer(call);
+
 	/* Limit the number of times we do this before returning to the manager */
-	iterations++;
-	if (iterations > 5)
-		goto requeue;
+	if (rxrpc_tx_window_space(call) == 0 ||
+	    list_empty(&call->tx_sendmsg)) {
+		iterations++;
+		if (iterations > 5)
+			goto requeue;
+	}
 
 	if (test_and_clear_bit(RXRPC_CALL_EV_ABORT, &call->events)) {
 		rxrpc_send_abort_packet(call);
 		goto recheck_state;
 	}
 
-	if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom)
-		rxrpc_shrink_call_tx_buffer(call);
-
 	if (call->state == RXRPC_CALL_COMPLETE) {
 		rxrpc_delete_call_timer(call);
 		goto out_put;
@@ -388,6 +450,8 @@ void rxrpc_process_call(struct work_struct *work)
 		set_bit(RXRPC_CALL_EV_RESEND, &call->events);
 	}
 
+	rxrpc_transmit_some_data(call);
+
 	/* Process events */
 	if (test_and_clear_bit(RXRPC_CALL_EV_EXPIRED, &call->events)) {
 		if (test_bit(RXRPC_CALL_RX_HEARD, &call->flags) &&
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index aa44e7a9a3f8..f1071f9ed115 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -169,6 +169,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
 	INIT_LIST_HEAD(&call->attend_link);
+	INIT_LIST_HEAD(&call->tx_sendmsg);
 	INIT_LIST_HEAD(&call->tx_buffer);
 	skb_queue_head_init(&call->recvmsg_queue);
 	skb_queue_head_init(&call->rx_oos_queue);
@@ -662,6 +663,11 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	rxrpc_delete_call_timer(call);
 
 	rxrpc_cleanup_ring(call);
+	while ((txb = list_first_entry_or_null(&call->tx_sendmsg,
+					       struct rxrpc_txbuf, call_link))) {
+		list_del(&txb->call_link);
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
+	}
 	while ((txb = list_first_entry_or_null(&call->tx_buffer,
 					       struct rxrpc_txbuf, call_link))) {
 		list_del(&txb->call_link);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 68511069873a..e2880e01624e 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -465,6 +465,14 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 	trace_rxrpc_tx_data(call, txb->seq, serial, txb->wire.flags,
 			    test_bit(RXRPC_TXBUF_RESENT, &txb->flags), false);
+
+	/* Track what we've attempted to transmit at least once so that the
+	 * retransmission algorithm doesn't try to resend what we haven't sent
+	 * yet.  However, this can race as we can receive an ACK before we get
+	 * to this point.  But, OTOH, if we won't get an ACK mentioning this
+	 * packet unless the far side received it (though it could have
+	 * discarded it anyway and NAK'd it).
+	 */
 	cmpxchg(&call->tx_transmitted, txb->seq - 1, txb->seq);
 
 	/* send the packet with the don't fragment bit set if we currently
@@ -712,3 +720,43 @@ void rxrpc_send_keepalive(struct rxrpc_peer *peer)
 	peer->last_tx_at = ktime_get_seconds();
 	_leave("");
 }
+
+/*
+ * Schedule an instant Tx resend.
+ */
+static inline void rxrpc_instant_resend(struct rxrpc_call *call,
+					struct rxrpc_txbuf *txb)
+{
+	if (call->state < RXRPC_CALL_COMPLETE)
+		kdebug("resend");
+}
+
+/*
+ * Transmit one packet.
+ */
+void rxrpc_transmit_one(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
+{
+	int ret;
+
+	ret = rxrpc_send_data_packet(call, txb);
+	if (ret < 0) {
+		switch (ret) {
+		case -ENETUNREACH:
+		case -EHOSTUNREACH:
+		case -ECONNREFUSED:
+			rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
+						  0, ret);
+			break;
+		default:
+			_debug("need instant resend %d", ret);
+			rxrpc_instant_resend(call, txb);
+		}
+	} else {
+		unsigned long now = jiffies;
+		unsigned long resend_at = now + call->peer->rto_j;
+
+		WRITE_ONCE(call->resend_at, resend_at);
+		rxrpc_reduce_call_timer(call, resend_at, now,
+					rxrpc_timer_set_for_send);
+	}
+}
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 7183c7f76f46..ee202e49e8a0 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -22,30 +22,9 @@
  */
 static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
 {
-	unsigned int win_size;
-	rxrpc_seq_t tx_win = smp_load_acquire(&call->acks_hard_ack);
-
-	/* If we haven't transmitted anything for >1RTT, we should reset the
-	 * congestion management state.
-	 */
-	if (ktime_before(ktime_add_us(call->tx_last_sent,
-				      call->peer->srtt_us >> 3),
-			 ktime_get_real())) {
-		if (RXRPC_TX_SMSS > 2190)
-			win_size = 2;
-		else if (RXRPC_TX_SMSS > 1095)
-			win_size = 3;
-		else
-			win_size = 4;
-		win_size += call->cong_extra;
-	} else {
-		win_size = min_t(unsigned int, call->tx_winsize,
-				 call->cong_cwnd + call->cong_extra);
-	}
-
 	if (_tx_win)
-		*_tx_win = tx_win;
-	return call->tx_top - tx_win < win_size;
+		*_tx_win = call->tx_bottom;
+	return call->tx_prepared - call->tx_bottom < 256;
 }
 
 /*
@@ -66,11 +45,6 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 		if (signal_pending(current))
 			return sock_intr_errno(*timeo);
 
-		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
-			rxrpc_shrink_call_tx_buffer(call);
-			continue;
-		}
-
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
 		*timeo = schedule_timeout(*timeo);
 	}
@@ -107,11 +81,6 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 		    tx_win == tx_start && signal_pending(current))
 			return -EINTR;
 
-		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
-			rxrpc_shrink_call_tx_buffer(call);
-			continue;
-		}
-
 		if (tx_win != tx_start) {
 			timeout = rtt;
 			tx_start = tx_win;
@@ -137,11 +106,6 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		if (call->state >= RXRPC_CALL_COMPLETE)
 			return call->error;
 
-		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
-			rxrpc_shrink_call_tx_buffer(call);
-			continue;
-		}
-
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
 		*timeo = schedule_timeout(*timeo);
 	}
@@ -207,29 +171,27 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	unsigned long now;
 	rxrpc_seq_t seq = txb->seq;
 	bool last = test_bit(RXRPC_TXBUF_LAST, &txb->flags);
-	int ret;
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_data);
 
-	ASSERTCMP(seq, ==, call->tx_top + 1);
+	ASSERTCMP(txb->seq, ==, call->tx_prepared + 1);
 
 	/* We have to set the timestamp before queueing as the retransmit
 	 * algorithm can see the packet as soon as we queue it.
 	 */
 	txb->last_sent = ktime_get_real();
 
-	/* Add the packet to the call's output buffer */
-	rxrpc_get_txbuf(txb, rxrpc_txbuf_get_buffer);
-	spin_lock(&call->tx_lock);
-	list_add_tail(&txb->call_link, &call->tx_buffer);
-	call->tx_top = seq;
-	spin_unlock(&call->tx_lock);
-
 	if (last)
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_queue_last);
 	else
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_queue);
 
+	/* Add the packet to the call's output buffer */
+	spin_lock(&call->tx_lock);
+	list_add_tail(&txb->call_link, &call->tx_sendmsg);
+	call->tx_prepared = seq;
+	spin_unlock(&call->tx_lock);
+
 	if (last || call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
 		_debug("________awaiting reply/ACK__________");
 		write_lock(&call->state_lock);
@@ -258,30 +220,11 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		write_unlock(&call->state_lock);
 	}
 
-	if (seq == 1 && rxrpc_is_client_call(call))
-		rxrpc_expose_client_call(call);
-
-	ret = rxrpc_send_data_packet(call, txb);
-	if (ret < 0) {
-		switch (ret) {
-		case -ENETUNREACH:
-		case -EHOSTUNREACH:
-		case -ECONNREFUSED:
-			rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
-						  0, ret);
-			goto out;
-		}
-	} else {
-		unsigned long now = jiffies;
-		unsigned long resend_at = now + call->peer->rto_j;
 
-		WRITE_ONCE(call->resend_at, resend_at);
-		rxrpc_reduce_call_timer(call, resend_at, now,
-					rxrpc_timer_set_for_send);
-	}
-
-out:
-	rxrpc_put_txbuf(txb, rxrpc_txbuf_put_trans);
+	/* Stick the packet on the crypto queue or the transmission queue as
+	 * appropriate.
+	 */
+	rxrpc_queue_call(call, rxrpc_call_queue_tx_data);
 }
 
 /*
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index 96bfee89927b..6721c64c3d1a 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -34,7 +34,7 @@ struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
 		txb->offset		= 0;
 		txb->flags		= 0;
 		txb->ack_why		= 0;
-		txb->seq		= call->tx_top + 1;
+		txb->seq		= call->tx_prepared + 1;
 		txb->wire.epoch		= htonl(call->conn->proto.epoch);
 		txb->wire.cid		= htonl(call->cid);
 		txb->wire.callNumber	= htonl(call->call_id);


