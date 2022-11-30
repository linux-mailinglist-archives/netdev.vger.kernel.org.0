Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B41863DB58
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiK3RCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiK3RBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD2281D90
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WI7RptmKeFtmISMnYlXKv5559f524IZhWCh9BQvF10Q=;
        b=HlENKELEO6dTVvnjjFDOoUVY7iyJ0nfpAzvrjnDXieM4amwsHfJQTc00gWZJLRRZRuhCTd
        9yH3KJi38B0ZI/oaeODro9n4MNrXUlCpndWsViY6zt3AibNoEiCjmlHSPTd17k3fYW16B/
        GR64jGHOQcuX4wKeieLdBFW8QOJofTc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-8_fWySZ2Nm6KRNYwRAxwYQ-1; Wed, 30 Nov 2022 11:57:58 -0500
X-MC-Unique: 8_fWySZ2Nm6KRNYwRAxwYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B99A11C08961;
        Wed, 30 Nov 2022 16:57:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF1D32166B26;
        Wed, 30 Nov 2022 16:57:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 25/35] rxrpc: Move DATA transmission into call
 processor work item
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:57:54 +0000
Message-ID: <166982747419.621383.2996927769382062225.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
 net/rxrpc/call_event.c       |   83 +++++++++++++++++++++++++++++++++++++++---
 net/rxrpc/call_object.c      |    6 +++
 net/rxrpc/output.c           |   48 ++++++++++++++++++++++++
 net/rxrpc/sendmsg.c          |   83 +++++++-----------------------------------
 net/rxrpc/txbuf.c            |   10 ++++-
 7 files changed, 161 insertions(+), 80 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 8bd48358f757..c3043fbea0e6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -183,6 +183,7 @@
 	EM(rxrpc_call_queue_requeue,		"QUE requeue ") \
 	EM(rxrpc_call_queue_resend,		"QUE resend  ") \
 	EM(rxrpc_call_queue_timer,		"QUE timer   ") \
+	EM(rxrpc_call_queue_tx_data,		"QUE tx-data ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
@@ -738,6 +739,7 @@ TRACE_EVENT(rxrpc_txqueue,
 		    __field(rxrpc_seq_t,		acks_hard_ack	)
 		    __field(rxrpc_seq_t,		tx_bottom	)
 		    __field(rxrpc_seq_t,		tx_top		)
+		    __field(rxrpc_seq_t,		tx_prepared	)
 		    __field(int,			tx_winsize	)
 			     ),
 
@@ -747,16 +749,18 @@ TRACE_EVENT(rxrpc_txqueue,
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
index 3bd6a5eb2fb7..6af7298af39b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -646,9 +646,11 @@ struct rxrpc_call {
 
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
@@ -766,7 +768,7 @@ struct rxrpc_send_params {
  */
 struct rxrpc_txbuf {
 	struct rcu_head		rcu;
-	struct list_head	call_link;	/* Link in call->tx_queue */
+	struct list_head	call_link;	/* Link in call->tx_sendmsg/tx_buffer */
 	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
 	struct rxrpc_call	*call;		/* Call to which belongs */
 	ktime_t			last_sent;	/* Time at which last transmitted */
@@ -1067,6 +1069,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
 void rxrpc_reject_packets(struct rxrpc_local *);
 void rxrpc_send_keepalive(struct rxrpc_peer *);
+void rxrpc_transmit_one(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 
 /*
  * peer_event.c
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 3925b55e2064..c9f835292f7b 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -291,6 +291,72 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	_leave("");
 }
 
+static bool rxrpc_tx_window_has_space(struct rxrpc_call *call)
+{
+	unsigned int winsize = min_t(unsigned int, call->tx_winsize,
+				     call->cong_cwnd + call->cong_extra);
+	rxrpc_seq_t window = call->acks_hard_ack, wtop = window + winsize;
+	rxrpc_seq_t tx_top = call->tx_top;
+	int space;
+
+	space = wtop - tx_top;
+	return space > 0;
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
+		// TODO: Drain the transmission buffers.  Do this somewhere better
+		if (after(call->acks_hard_ack, call->tx_bottom + 16))
+			rxrpc_shrink_call_tx_buffer(call);
+
+		if (!rxrpc_tx_window_has_space(call))
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
+		if (!rxrpc_tx_window_has_space(call))
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
@@ -309,19 +375,22 @@ void rxrpc_process_call(struct work_struct *work)
 	       call->debug_id, rxrpc_call_states[call->state], call->events);
 
 recheck_state:
+	if (call->acks_hard_ack != call->tx_bottom)
+		rxrpc_shrink_call_tx_buffer(call);
+
 	/* Limit the number of times we do this before returning to the manager */
-	iterations++;
-	if (iterations > 5)
-		goto requeue;
+	if (!rxrpc_tx_window_has_space(call) ||
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
 		del_timer_sync(&call->timer);
 		goto out;
@@ -387,6 +456,8 @@ void rxrpc_process_call(struct work_struct *work)
 		set_bit(RXRPC_CALL_EV_RESEND, &call->events);
 	}
 
+	rxrpc_transmit_some_data(call);
+
 	/* Process events */
 	if (test_and_clear_bit(RXRPC_CALL_EV_EXPIRED, &call->events)) {
 		if (test_bit(RXRPC_CALL_RX_HEARD, &call->flags) &&
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 2622d06bb0d6..96a7edd3a842 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -156,6 +156,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
 	INIT_LIST_HEAD(&call->attend_link);
+	INIT_LIST_HEAD(&call->tx_sendmsg);
 	INIT_LIST_HEAD(&call->tx_buffer);
 	skb_queue_head_init(&call->recvmsg_queue);
 	skb_queue_head_init(&call->rx_oos_queue);
@@ -641,6 +642,11 @@ static void rxrpc_destroy_call(struct work_struct *work)
 	del_timer_sync(&call->timer);
 
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
index e2ce7dadbb7a..c8147e50060b 100644
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
index 76b1e2e89c1e..11af37275d5b 100644
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
 		write_lock_bh(&call->state_lock);
@@ -258,30 +220,11 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		write_unlock_bh(&call->state_lock);
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
index 90ff00c340cd..a5054389dfbb 100644
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
@@ -107,6 +107,7 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 {
 	struct rxrpc_txbuf *txb;
 	rxrpc_seq_t hard_ack = smp_load_acquire(&call->acks_hard_ack);
+	bool wake = false;
 
 	_enter("%x/%x/%x", call->tx_bottom, call->acks_hard_ack, call->tx_top);
 
@@ -123,7 +124,7 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 		if (txb->seq != call->tx_bottom + 1)
 			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_out_of_step);
 		ASSERTCMP(txb->seq, ==, call->tx_bottom + 1);
-		call->tx_bottom++;
+		smp_store_release(&call->tx_bottom, call->tx_bottom + 1);
 		list_del_rcu(&txb->call_link);
 
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_dequeue);
@@ -131,7 +132,12 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 		spin_unlock(&call->tx_lock);
 
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_rotated);
+		if (after(call->acks_hard_ack, call->tx_bottom + 128))
+			wake = true;
 	}
 
 	spin_unlock(&call->tx_lock);
+
+	if (wake)
+		wake_up(&call->waitq);
 }


