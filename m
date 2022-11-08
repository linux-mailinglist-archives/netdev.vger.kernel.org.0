Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9A621F18
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiKHWWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKHWVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:21:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D62A657C9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2VguMKzjVRk9bqHfoL09kMUurSmivwFZ9iBQEP68bA=;
        b=hwR06dJ1OcgrspQbrcCj/HXKK68R8W/8nln7HIs4Hs90XSQJa5kwf2yfhVdHjyZsoYRVMj
        s8GHU5Xmr7TKO8I+VLrjSWLpvvRuXjw2w8wfH4PdO9WPT751WgFzuKKf8e3r9j3jFW+f6o
        hlReUdkrZmAuP8CYTnvutHtx5R5HUpI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-3jztseYbMC-sFRa_lKPPAw-1; Tue, 08 Nov 2022 17:19:36 -0500
X-MC-Unique: 3jztseYbMC-sFRa_lKPPAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 029BF85A583;
        Tue,  8 Nov 2022 22:19:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E36C112132E;
        Tue,  8 Nov 2022 22:19:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/26] rxrpc: Allocate ACK records at proposal and
 queue for transmission
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:34 +0000
Message-ID: <166794597459.2389296.17348209007747930732.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate rxrpc_txbuf records for ACKs and put onto a queue for the
transmitter thread to dispatch.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   47 ++++++++--
 net/rxrpc/ar-internal.h      |   21 +++--
 net/rxrpc/call_accept.c      |    5 -
 net/rxrpc/call_event.c       |  189 +++++++++++++++++++++++-------------------
 net/rxrpc/input.c            |   89 ++++++++------------
 net/rxrpc/local_object.c     |    7 ++
 net/rxrpc/output.c           |  157 ++++++++++++++++-------------------
 net/rxrpc/recvmsg.c          |   33 ++-----
 net/rxrpc/sendmsg.c          |    4 -
 net/rxrpc/txbuf.c            |    1 
 10 files changed, 285 insertions(+), 268 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 47b157b1d32b..1597ff7ad97e 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -34,7 +34,8 @@
 	EM(rxrpc_local_new,			"NEW") \
 	EM(rxrpc_local_processing,		"PRO") \
 	EM(rxrpc_local_put,			"PUT") \
-	E_(rxrpc_local_queued,			"QUE")
+	EM(rxrpc_local_queued,			"QUE") \
+	E_(rxrpc_local_tx_ack,			"TAK")
 
 #define rxrpc_peer_traces \
 	EM(rxrpc_peer_got,			"GOT") \
@@ -258,7 +259,9 @@
 	EM(rxrpc_txbuf_free,			"FREE       ")	\
 	EM(rxrpc_txbuf_get_trans,		"GET TRANS  ")	\
 	EM(rxrpc_txbuf_get_retrans,		"GET RETRANS")	\
+	EM(rxrpc_txbuf_put_ack_tx,		"PUT ACK TX ")	\
 	EM(rxrpc_txbuf_put_cleaned,		"PUT CLEANED")	\
+	EM(rxrpc_txbuf_put_nomem,		"PUT NOMEM  ")	\
 	EM(rxrpc_txbuf_put_rotated,		"PUT ROTATED")	\
 	EM(rxrpc_txbuf_put_send_aborted,	"PUT SEND-X ")	\
 	EM(rxrpc_txbuf_see_send_more,		"SEE SEND+  ")	\
@@ -1095,19 +1098,16 @@ TRACE_EVENT(rxrpc_rx_lose,
 
 TRACE_EVENT(rxrpc_propose_ack,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_propose_ack_trace why,
-		     u8 ack_reason, rxrpc_serial_t serial, bool immediate,
-		     bool background, enum rxrpc_propose_ack_outcome outcome),
+		     u8 ack_reason, rxrpc_serial_t serial,
+		     enum rxrpc_propose_ack_outcome outcome),
 
-	    TP_ARGS(call, why, ack_reason, serial, immediate, background,
-		    outcome),
+	    TP_ARGS(call, why, ack_reason, serial, outcome),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,			call		)
 		    __field(enum rxrpc_propose_ack_trace,	why		)
 		    __field(rxrpc_serial_t,			serial		)
 		    __field(u8,					ack_reason	)
-		    __field(bool,				immediate	)
-		    __field(bool,				background	)
 		    __field(enum rxrpc_propose_ack_outcome,	outcome		)
 			     ),
 
@@ -1116,21 +1116,44 @@ TRACE_EVENT(rxrpc_propose_ack,
 		    __entry->why	= why;
 		    __entry->serial	= serial;
 		    __entry->ack_reason	= ack_reason;
-		    __entry->immediate	= immediate;
-		    __entry->background	= background;
 		    __entry->outcome	= outcome;
 			   ),
 
-	    TP_printk("c=%08x %s %s r=%08x i=%u b=%u%s",
+	    TP_printk("c=%08x %s %s r=%08x%s",
 		      __entry->call,
 		      __print_symbolic(__entry->why, rxrpc_propose_ack_traces),
 		      __print_symbolic(__entry->ack_reason, rxrpc_ack_names),
 		      __entry->serial,
-		      __entry->immediate,
-		      __entry->background,
 		      __print_symbolic(__entry->outcome, rxrpc_propose_ack_outcomes))
 	    );
 
+TRACE_EVENT(rxrpc_send_ack,
+	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_propose_ack_trace why,
+		     u8 ack_reason, rxrpc_serial_t serial),
+
+	    TP_ARGS(call, why, ack_reason, serial),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,			call		)
+		    __field(enum rxrpc_propose_ack_trace,	why		)
+		    __field(rxrpc_serial_t,			serial		)
+		    __field(u8,					ack_reason	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call	= call->debug_id;
+		    __entry->why	= why;
+		    __entry->serial	= serial;
+		    __entry->ack_reason	= ack_reason;
+			   ),
+
+	    TP_printk("c=%08x %s %s r=%08x",
+		      __entry->call,
+		      __print_symbolic(__entry->why, rxrpc_propose_ack_traces),
+		      __print_symbolic(__entry->ack_reason, rxrpc_ack_names),
+		      __entry->serial)
+	    );
+
 TRACE_EVENT(rxrpc_retransmit,
 	    TP_PROTO(struct rxrpc_call *call, rxrpc_seq_t seq, u8 annotation,
 		     s64 expiry),
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 49e90614d5e5..802a8f372af2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -292,6 +292,8 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
+	struct list_head	ack_tx_queue;	/* List of ACKs that need sending */
+	spinlock_t		ack_tx_lock;	/* ACK list lock */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
@@ -520,10 +522,8 @@ enum rxrpc_call_flag {
  * Events that can be raised on a call.
  */
 enum rxrpc_call_event {
-	RXRPC_CALL_EV_ACK,		/* need to generate ACK */
 	RXRPC_CALL_EV_ABORT,		/* need to generate abort */
 	RXRPC_CALL_EV_RESEND,		/* Tx resend required */
-	RXRPC_CALL_EV_PING,		/* Ping send required */
 	RXRPC_CALL_EV_EXPIRED,		/* Expiry occurred */
 	RXRPC_CALL_EV_ACK_LOST,		/* ACK may be lost, send ping */
 };
@@ -782,13 +782,20 @@ struct rxrpc_txbuf {
 #define RXRPC_TXBUF_LAST	2		/* Set if last packet in Tx phase */
 #define RXRPC_TXBUF_RESENT	3		/* Set if has been resent */
 #define RXRPC_TXBUF_RETRANS	4		/* Set if should be retransmitted */
+	u8 /*enum rxrpc_propose_ack_trace*/ ack_why;	/* If ack, why */
 	struct {
 		/* The packet for encrypting and DMA'ing.  We align it such
 		 * that data[] aligns correctly for any crypto blocksize.
 		 */
 		u8		pad[64 - sizeof(struct rxrpc_wire_header)];
 		struct rxrpc_wire_header wire;	/* Network-ready header */
-		u8		data[RXRPC_JUMBO_DATALEN]; /* Data packet */
+		union {
+			u8	data[RXRPC_JUMBO_DATALEN]; /* Data packet */
+			struct {
+				struct rxrpc_ackpacket ack;
+				u8 acks[0];
+			};
+		};
 	} __aligned(64);
 };
 
@@ -824,8 +831,10 @@ int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 /*
  * call_event.c
  */
-void rxrpc_propose_ACK(struct rxrpc_call *, u8, u32, bool, bool,
-		       enum rxrpc_propose_ack_trace);
+void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
+			enum rxrpc_propose_ack_trace why);
+void rxrpc_send_ACK(struct rxrpc_call *, u8, rxrpc_serial_t, enum rxrpc_propose_ack_trace);
+void rxrpc_propose_ACK(struct rxrpc_call *, u8, u32, enum rxrpc_propose_ack_trace);
 void rxrpc_process_call(struct work_struct *);
 
 void rxrpc_reduce_call_timer(struct rxrpc_call *call,
@@ -1030,7 +1039,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
 /*
  * output.c
  */
-int rxrpc_send_ack_packet(struct rxrpc_call *, bool, rxrpc_serial_t *);
+void rxrpc_transmit_ack_packets(struct rxrpc_local *);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct sk_buff *, bool);
 void rxrpc_reject_packets(struct rxrpc_local *);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 99e10eea3732..d8db277d5ebe 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -248,9 +248,8 @@ static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb)
 
 	if (call->peer->rtt_count < 3 ||
 	    ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), now))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
-				  true, true,
-				  rxrpc_propose_ack_ping_for_params);
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
+			       rxrpc_propose_ack_ping_for_params);
 }
 
 /*
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 70f70a0393f7..67b54ad914a1 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -20,46 +20,39 @@
 /*
  * Propose a PING ACK be sent.
  */
-static void rxrpc_propose_ping(struct rxrpc_call *call,
-			       bool immediate, bool background)
+void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
+			enum rxrpc_propose_ack_trace why)
 {
-	if (immediate) {
-		if (background &&
-		    !test_and_set_bit(RXRPC_CALL_EV_PING, &call->events))
-			rxrpc_queue_call(call);
-	} else {
-		unsigned long now = jiffies;
-		unsigned long ping_at = now + rxrpc_idle_ack_delay;
+	unsigned long now = jiffies;
+	unsigned long ping_at = now + rxrpc_idle_ack_delay;
 
-		if (time_before(ping_at, call->ping_at)) {
-			WRITE_ONCE(call->ping_at, ping_at);
-			rxrpc_reduce_call_timer(call, ping_at, now,
-						rxrpc_timer_set_for_ping);
-		}
+	spin_lock_bh(&call->lock);
+
+	if (time_before(ping_at, call->ping_at)) {
+		rxrpc_inc_stat(call->rxnet, stat_tx_acks[RXRPC_ACK_PING]);
+		WRITE_ONCE(call->ping_at, ping_at);
+		rxrpc_reduce_call_timer(call, ping_at, now,
+					rxrpc_timer_set_for_ping);
+		trace_rxrpc_propose_ack(call, why, RXRPC_ACK_PING, serial,
+					rxrpc_propose_ack_use);
 	}
+
+	spin_unlock_bh(&call->lock);
 }
 
 /*
  * propose an ACK be sent
  */
 static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
-				u32 serial, bool immediate, bool background,
-				enum rxrpc_propose_ack_trace why)
+				u32 serial, enum rxrpc_propose_ack_trace why)
 {
 	enum rxrpc_propose_ack_outcome outcome = rxrpc_propose_ack_use;
 	unsigned long expiry = rxrpc_soft_ack_delay;
+	unsigned long now = jiffies, ack_at;
 	s8 prior = rxrpc_ack_priority[ack_reason];
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
 
-	/* Pings are handled specially because we don't want to accidentally
-	 * lose a ping response by subsuming it into a ping.
-	 */
-	if (ack_reason == RXRPC_ACK_PING) {
-		rxrpc_propose_ping(call, immediate, background);
-		goto trace;
-	}
-
 	/* Update DELAY, IDLE, REQUESTED and PING_RESPONSE ACK serial
 	 * numbers, but we don't alter the timeout.
 	 */
@@ -71,8 +64,6 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 			outcome = rxrpc_propose_ack_update;
 			call->ackr_serial = serial;
 		}
-		if (!immediate)
-			goto trace;
 	} else if (prior > rxrpc_ack_priority[call->ackr_reason]) {
 		call->ackr_reason = ack_reason;
 		call->ackr_serial = serial;
@@ -84,8 +75,6 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 	case RXRPC_ACK_REQUESTED:
 		if (rxrpc_requested_ack_delay < expiry)
 			expiry = rxrpc_requested_ack_delay;
-		if (serial == 1)
-			immediate = false;
 		break;
 
 	case RXRPC_ACK_DELAY:
@@ -99,52 +88,89 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 		break;
 
 	default:
-		immediate = true;
-		break;
+		WARN_ON(1);
+		return;
 	}
 
-	if (test_bit(RXRPC_CALL_EV_ACK, &call->events)) {
-		_debug("already scheduled");
-	} else if (immediate || expiry == 0) {
-		_debug("immediate ACK %lx", call->events);
-		if (!test_and_set_bit(RXRPC_CALL_EV_ACK, &call->events) &&
-		    background)
-			rxrpc_queue_call(call);
-	} else {
-		unsigned long now = jiffies, ack_at;
-
-		if (call->peer->srtt_us != 0)
-			ack_at = usecs_to_jiffies(call->peer->srtt_us >> 3);
-		else
-			ack_at = expiry;
-
-		ack_at += READ_ONCE(call->tx_backoff);
-		ack_at += now;
-		if (time_before(ack_at, call->ack_at)) {
-			WRITE_ONCE(call->ack_at, ack_at);
-			rxrpc_reduce_call_timer(call, ack_at, now,
-						rxrpc_timer_set_for_ack);
-		}
+
+	if (call->peer->srtt_us != 0)
+		ack_at = usecs_to_jiffies(call->peer->srtt_us >> 3);
+	else
+		ack_at = expiry;
+
+	ack_at += READ_ONCE(call->tx_backoff);
+	ack_at += now;
+	if (time_before(ack_at, call->ack_at)) {
+		WRITE_ONCE(call->ack_at, ack_at);
+		rxrpc_reduce_call_timer(call, ack_at, now,
+					rxrpc_timer_set_for_ack);
 	}
 
-trace:
-	trace_rxrpc_propose_ack(call, why, ack_reason, serial, immediate,
-				background, outcome);
+	trace_rxrpc_propose_ack(call, why, ack_reason, serial, outcome);
 }
 
 /*
  * propose an ACK be sent, locking the call structure
  */
-void rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
-		       u32 serial, bool immediate, bool background,
+void rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason, u32 serial,
 		       enum rxrpc_propose_ack_trace why)
 {
 	spin_lock_bh(&call->lock);
-	__rxrpc_propose_ACK(call, ack_reason, serial,
-			    immediate, background, why);
+	__rxrpc_propose_ACK(call, ack_reason, serial, why);
 	spin_unlock_bh(&call->lock);
 }
 
+/*
+ * Queue an ACK for immediate transmission.
+ */
+void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
+		    rxrpc_serial_t serial, enum rxrpc_propose_ack_trace why)
+{
+	struct rxrpc_local *local = call->conn->params.local;
+	struct rxrpc_txbuf *txb;
+
+	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
+		return;
+
+	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
+
+	txb = rxrpc_alloc_txbuf(call, RXRPC_PACKET_TYPE_ACK,
+				in_softirq() ? GFP_ATOMIC | __GFP_NOWARN : GFP_NOFS);
+	if (!txb) {
+		kleave(" = -ENOMEM");
+		return;
+	}
+
+	txb->ack_why		= why;
+	txb->wire.seq		= 0;
+	txb->wire.type		= RXRPC_PACKET_TYPE_ACK;
+	txb->wire.flags		|= RXRPC_SLOW_START_OK;
+	txb->ack.bufferSpace	= 0;
+	txb->ack.maxSkew	= 0;
+	txb->ack.firstPacket	= 0;
+	txb->ack.previousPacket	= 0;
+	txb->ack.serial		= htonl(serial);
+	txb->ack.reason		= ack_reason;
+	txb->ack.nAcks		= 0;
+
+	if (!rxrpc_try_get_call(call, rxrpc_call_got)) {
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_nomem);
+		return;
+	}
+
+	spin_lock_bh(&local->ack_tx_lock);
+	list_add_tail(&txb->tx_link, &local->ack_tx_queue);
+	spin_unlock_bh(&local->ack_tx_lock);
+	trace_rxrpc_send_ack(call, why, ack_reason, serial);
+
+	if (in_task()) {
+		rxrpc_transmit_ack_packets(call->peer->local);
+	} else {
+		rxrpc_get_local(local);
+		rxrpc_queue_local(local);
+	}
+}
+
 /*
  * Handle congestion being detected by the retransmit timeout.
  */
@@ -230,9 +256,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		ack_ts = ktime_sub(now, call->acks_latest_ts);
 		if (ktime_to_us(ack_ts) < (call->peer->srtt_us >> 3))
 			goto out;
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
-				  rxrpc_propose_ack_ping_for_lost_ack);
-		rxrpc_send_ack_packet(call, true, NULL);
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+			       rxrpc_propose_ack_ping_for_lost_ack);
 		goto out;
 	}
 
@@ -291,9 +316,10 @@ void rxrpc_process_call(struct work_struct *work)
 {
 	struct rxrpc_call *call =
 		container_of(work, struct rxrpc_call, processor);
-	rxrpc_serial_t *send_ack;
 	unsigned long now, next, t;
 	unsigned int iterations = 0;
+	rxrpc_serial_t ackr_serial;
+	u8 ackr_reason;
 
 	rxrpc_see_call(call);
 
@@ -342,7 +368,15 @@ void rxrpc_process_call(struct work_struct *work)
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_ack, now);
 		cmpxchg(&call->ack_at, t, now + MAX_JIFFY_OFFSET);
-		set_bit(RXRPC_CALL_EV_ACK, &call->events);
+		spin_lock_bh(&call->lock);
+		ackr_reason = call->ackr_reason;
+		ackr_serial = call->ackr_serial;
+		call->ackr_reason = 0;
+		call->ackr_serial = 0;
+		spin_unlock_bh(&call->lock);
+		if (ackr_reason)
+			rxrpc_send_ACK(call, ackr_reason, ackr_serial,
+				       rxrpc_propose_ack_ping_for_lost_ack);
 	}
 
 	t = READ_ONCE(call->ack_lost_at);
@@ -356,16 +390,16 @@ void rxrpc_process_call(struct work_struct *work)
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_keepalive, now);
 		cmpxchg(&call->keepalive_at, t, now + MAX_JIFFY_OFFSET);
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, true,
-				  rxrpc_propose_ack_ping_for_keepalive);
-		set_bit(RXRPC_CALL_EV_PING, &call->events);
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+			       rxrpc_propose_ack_ping_for_keepalive);
 	}
 
 	t = READ_ONCE(call->ping_at);
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_ping, now);
 		cmpxchg(&call->ping_at, t, now + MAX_JIFFY_OFFSET);
-		set_bit(RXRPC_CALL_EV_PING, &call->events);
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+			       rxrpc_propose_ack_ping_for_keepalive);
 	}
 
 	t = READ_ONCE(call->resend_at);
@@ -388,25 +422,10 @@ void rxrpc_process_call(struct work_struct *work)
 		goto recheck_state;
 	}
 
-	send_ack = NULL;
 	if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events)) {
 		call->acks_lost_top = call->tx_top;
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
-				  rxrpc_propose_ack_ping_for_lost_ack);
-		send_ack = &call->acks_lost_ping;
-	}
-
-	if (test_and_clear_bit(RXRPC_CALL_EV_ACK, &call->events) ||
-	    send_ack) {
-		if (call->ackr_reason) {
-			rxrpc_send_ack_packet(call, false, send_ack);
-			goto recheck_state;
-		}
-	}
-
-	if (test_and_clear_bit(RXRPC_CALL_EV_PING, &call->events)) {
-		rxrpc_send_ack_packet(call, true, NULL);
-		goto recheck_state;
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+			       rxrpc_propose_ack_ping_for_lost_ack);
 	}
 
 	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events) &&
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 0cb23ba79e3b..e23f66ef8c06 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -398,8 +398,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	unsigned int j, nr_subpackets, nr_unacked = 0;
 	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
-	bool immediate_ack = false, jumbo_bad = false;
-	u8 ack = 0;
+	bool jumbo_bad = false;
 
 	_enter("{%u,%u},{%u,%u}",
 	       call->rx_hard_ack, call->rx_top, skb->len, seq0);
@@ -447,9 +446,9 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	nr_subpackets = sp->nr_subpackets;
 	if (nr_subpackets > 1) {
 		if (call->nr_jumbo_bad > 3) {
-			ack = RXRPC_ACK_NOSPACE;
-			ack_serial = serial;
-			goto ack;
+			rxrpc_send_ACK(call, RXRPC_ACK_NOSPACE, serial,
+				       rxrpc_propose_ack_input_data);
+			goto unlock;
 		}
 	}
 
@@ -459,6 +458,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
 		bool terminal = (j == nr_subpackets - 1);
 		bool last = terminal && (sp->rx_flags & RXRPC_SKB_INCL_LAST);
+		bool acked = false;
 		u8 flags, annotation = j;
 
 		_proto("Rx DATA+%u %%%u { #%x t=%u l=%u }",
@@ -488,25 +488,22 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		trace_rxrpc_rx_data(call->debug_id, seq, serial, flags, annotation);
 
 		if (before_eq(seq, hard_ack)) {
-			ack = RXRPC_ACK_DUPLICATE;
-			ack_serial = serial;
+			rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
+				       rxrpc_propose_ack_input_data);
 			continue;
 		}
 
 		if (call->rxtx_buffer[ix]) {
 			rxrpc_input_dup_data(call, seq, nr_subpackets > 1,
 					     &jumbo_bad);
-			if (ack != RXRPC_ACK_DUPLICATE) {
-				ack = RXRPC_ACK_DUPLICATE;
-				ack_serial = serial;
-			}
-			immediate_ack = true;
+			rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
+				       rxrpc_propose_ack_input_data);
 			continue;
 		}
 
 		if (after(seq, hard_ack + call->rx_winsize)) {
-			ack = RXRPC_ACK_EXCEEDS_WINDOW;
-			ack_serial = serial;
+			rxrpc_send_ACK(call, RXRPC_ACK_EXCEEDS_WINDOW, serial,
+				       rxrpc_propose_ack_input_data);
 			if (flags & RXRPC_JUMBO_PACKET) {
 				if (!jumbo_bad) {
 					call->nr_jumbo_bad++;
@@ -514,12 +511,13 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 				}
 			}
 
-			goto ack;
+			goto unlock;
 		}
 
-		if (flags & RXRPC_REQUEST_ACK && !ack) {
-			ack = RXRPC_ACK_REQUESTED;
-			ack_serial = serial;
+		if (flags & RXRPC_REQUEST_ACK) {
+			rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, serial,
+				       rxrpc_propose_ack_input_data);
+			acked = true;
 		}
 
 		if (after(seq0, call->ackr_highest_seq))
@@ -542,11 +540,11 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			smp_store_release(&call->rx_top, seq);
 		} else if (before(seq, call->rx_top)) {
 			/* Send an immediate ACK if we fill in a hole */
-			if (!ack) {
-				ack = RXRPC_ACK_DELAY;
-				ack_serial = serial;
+			if (!acked) {
+				rxrpc_send_ACK(call, RXRPC_ACK_DELAY, serial,
+					       rxrpc_propose_ack_input_data);
+				acked = true;
 			}
-			immediate_ack = true;
 		}
 
 		if (terminal) {
@@ -558,14 +556,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			sp = NULL;
 		}
 
-		nr_unacked++;
-
 		if (last) {
 			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
-			if (!ack) {
-				ack = RXRPC_ACK_DELAY;
-				ack_serial = serial;
-			}
 			trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
 		} else {
 			trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
@@ -574,32 +566,30 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		if (after_eq(seq, call->rx_expect_next)) {
 			if (after(seq, call->rx_expect_next)) {
 				_net("OOS %u > %u", seq, call->rx_expect_next);
-				ack = RXRPC_ACK_OUT_OF_SEQUENCE;
-				ack_serial = serial;
+				rxrpc_send_ACK(call, RXRPC_ACK_OUT_OF_SEQUENCE, serial,
+					       rxrpc_propose_ack_input_data);
+				acked = true;
 			}
 			call->rx_expect_next = seq + 1;
 		}
-		if (!ack)
+
+		if (!acked) {
+			nr_unacked++;
 			ack_serial = serial;
+		}
 	}
 
-ack:
-	if (atomic_add_return(nr_unacked, &call->ackr_nr_unacked) > 2 && !ack)
-		ack = RXRPC_ACK_IDLE;
-
-	if (ack)
-		rxrpc_propose_ACK(call, ack, ack_serial,
-				  immediate_ack, true,
-				  rxrpc_propose_ack_input_data);
+unlock:
+	if (atomic_add_return(nr_unacked, &call->ackr_nr_unacked) > 2)
+		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, ack_serial,
+			       rxrpc_propose_ack_input_data);
 	else
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
-				  false, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, ack_serial,
 				  rxrpc_propose_ack_input_data);
 
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
 
-unlock:
 	spin_unlock(&call->input_lock);
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	_leave(" [queued]");
@@ -893,13 +883,11 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	if (buf.ack.reason == RXRPC_ACK_PING) {
 		_proto("Rx ACK %%%u PING Request", ack_serial);
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING_RESPONSE,
-				  ack_serial, true, true,
-				  rxrpc_propose_ack_respond_to_ping);
+		rxrpc_send_ACK(call, RXRPC_ACK_PING_RESPONSE, ack_serial,
+			       rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
-		rxrpc_propose_ACK(call, RXRPC_ACK_REQUESTED,
-				  ack_serial, true, true,
-				  rxrpc_propose_ack_respond_to_ack);
+		rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, ack_serial,
+			       rxrpc_propose_ack_respond_to_ack);
 	}
 
 	/* If we get an EXCEEDS_WINDOW ACK from the server, it probably
@@ -1011,9 +999,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    RXRPC_TX_ANNO_LAST &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, ack_serial,
-				  false, true,
-				  rxrpc_propose_ack_ping_for_lost_reply);
+		rxrpc_propose_ping(call, ack_serial,
+				   rxrpc_propose_ack_ping_for_lost_reply);
 
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
 out:
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index e95e75e785fb..a178f71e5082 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -97,6 +97,8 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
+		INIT_LIST_HEAD(&local->ack_tx_queue);
+		spin_lock_init(&local->ack_tx_lock);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
 		skb_queue_head_init(&local->event_queue);
@@ -432,6 +434,11 @@ static void rxrpc_local_processor(struct work_struct *work)
 			break;
 		}
 
+		if (!list_empty(&local->ack_tx_queue)) {
+			rxrpc_transmit_ack_packets(local);
+			again = true;
+		}
+
 		if (!skb_queue_empty(&local->reject_queue)) {
 			rxrpc_reject_packets(local);
 			again = true;
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 71885d741987..1edbc678e8be 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -16,14 +16,6 @@
 #include <net/udp.h>
 #include "ar-internal.h"
 
-struct rxrpc_ack_buffer {
-	struct rxrpc_wire_header whdr;
-	struct rxrpc_ackpacket ack;
-	u8 acks[255];
-	u8 pad[3];
-	struct rxrpc_ackinfo ackinfo;
-};
-
 extern int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
 
 static ssize_t do_udp_sendmsg(struct socket *sk, struct msghdr *msg, size_t len)
@@ -82,22 +74,21 @@ static void rxrpc_set_keepalive(struct rxrpc_call *call)
  */
 static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 struct rxrpc_call *call,
-				 struct rxrpc_ack_buffer *pkt,
+				 struct rxrpc_txbuf *txb,
 				 rxrpc_seq_t *_hard_ack,
-				 rxrpc_seq_t *_top,
-				 u8 reason)
+				 rxrpc_seq_t *_top)
 {
-	rxrpc_serial_t serial;
+	struct rxrpc_ackinfo ackinfo;
 	unsigned int tmp;
 	rxrpc_seq_t hard_ack, top, seq;
 	int ix;
 	u32 mtu, jmax;
-	u8 *ackp = pkt->acks;
+	u8 *ackp = txb->acks;
 
 	tmp = atomic_xchg(&call->ackr_nr_unacked, 0);
 	tmp |= atomic_xchg(&call->ackr_nr_consumed, 0);
-	if (!tmp && (reason == RXRPC_ACK_DELAY ||
-		     reason == RXRPC_ACK_IDLE)) {
+	if (!tmp && (txb->ack.reason == RXRPC_ACK_DELAY ||
+		     txb->ack.reason == RXRPC_ACK_IDLE)) {
 		rxrpc_inc_stat(call->rxnet, stat_tx_ack_skip);
 		return 0;
 	}
@@ -105,24 +96,16 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_fill);
 
 	/* Barrier against rxrpc_input_data(). */
-	serial = call->ackr_serial;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 	top = smp_load_acquire(&call->rx_top);
 	*_hard_ack = hard_ack;
 	*_top = top;
 
-	pkt->ack.bufferSpace	= htons(0);
-	pkt->ack.maxSkew	= htons(0);
-	pkt->ack.firstPacket	= htonl(hard_ack + 1);
-	pkt->ack.previousPacket	= htonl(call->ackr_highest_seq);
-	pkt->ack.serial		= htonl(serial);
-	pkt->ack.reason		= reason;
-	pkt->ack.nAcks		= top - hard_ack;
-
-	if (reason == RXRPC_ACK_PING)
-		pkt->whdr.flags |= RXRPC_REQUEST_ACK;
+	txb->ack.firstPacket	= htonl(hard_ack + 1);
+	txb->ack.previousPacket	= htonl(call->ackr_highest_seq);
+	txb->ack.nAcks		= top - hard_ack;
 
-	if (after(top, hard_ack)) {
+	if (txb->ack.nAcks) {
 		seq = hard_ack + 1;
 		do {
 			ix = seq & RXRPC_RXTX_BUFF_MASK;
@@ -137,15 +120,16 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	mtu = conn->params.peer->if_mtu;
 	mtu -= conn->params.peer->hdrsize;
 	jmax = (call->nr_jumbo_bad > 3) ? 1 : rxrpc_rx_jumbo_max;
-	pkt->ackinfo.rxMTU	= htonl(rxrpc_rx_mtu);
-	pkt->ackinfo.maxMTU	= htonl(mtu);
-	pkt->ackinfo.rwind	= htonl(call->rx_winsize);
-	pkt->ackinfo.jumbo_max	= htonl(jmax);
+	ackinfo.rxMTU		= htonl(rxrpc_rx_mtu);
+	ackinfo.maxMTU		= htonl(mtu);
+	ackinfo.rwind		= htonl(call->rx_winsize);
+	ackinfo.jumbo_max	= htonl(jmax);
 
 	*ackp++ = 0;
 	*ackp++ = 0;
 	*ackp++ = 0;
-	return top - hard_ack + 3;
+	memcpy(ackp, &ackinfo, sizeof(ackinfo));
+	return top - hard_ack + 3 + sizeof(ackinfo);
 }
 
 /*
@@ -194,26 +178,21 @@ static void rxrpc_cancel_rtt_probe(struct rxrpc_call *call,
 /*
  * Send an ACK call packet.
  */
-int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
-			  rxrpc_serial_t *_serial)
+static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *txb)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_ack_buffer *pkt;
+	struct rxrpc_call *call = txb->call;
 	struct msghdr msg;
-	struct kvec iov[2];
+	struct kvec iov[1];
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top;
 	size_t len, n;
 	int ret, rtt_slot = -1;
-	u8 reason;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
 
-	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-	if (!pkt)
-		return -ENOMEM;
-
 	conn = call->conn;
 
 	msg.msg_name	= &call->peer->srx.transport;
@@ -222,85 +201,93 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	msg.msg_controllen = 0;
 	msg.msg_flags	= 0;
 
-	pkt->whdr.epoch		= htonl(conn->proto.epoch);
-	pkt->whdr.cid		= htonl(call->cid);
-	pkt->whdr.callNumber	= htonl(call->call_id);
-	pkt->whdr.seq		= 0;
-	pkt->whdr.type		= RXRPC_PACKET_TYPE_ACK;
-	pkt->whdr.flags		= RXRPC_SLOW_START_OK | conn->out_clientflag;
-	pkt->whdr.userStatus	= 0;
-	pkt->whdr.securityIndex	= call->security_ix;
-	pkt->whdr._rsvd		= 0;
-	pkt->whdr.serviceId	= htons(call->service_id);
+	if (txb->ack.reason == RXRPC_ACK_PING)
+		txb->wire.flags |= RXRPC_REQUEST_ACK;
 
 	spin_lock_bh(&call->lock);
-	if (ping) {
-		reason = RXRPC_ACK_PING;
-	} else {
-		reason = call->ackr_reason;
-		if (!call->ackr_reason) {
-			spin_unlock_bh(&call->lock);
-			ret = 0;
-			goto out;
-		}
-		call->ackr_reason = 0;
-	}
-	n = rxrpc_fill_out_ack(conn, call, pkt, &hard_ack, &top, reason);
-
+	n = rxrpc_fill_out_ack(conn, call, txb, &hard_ack, &top);
 	spin_unlock_bh(&call->lock);
 	if (n == 0) {
 		kfree(pkt);
 		return 0;
 	}
 
-	iov[0].iov_base	= pkt;
-	iov[0].iov_len	= sizeof(pkt->whdr) + sizeof(pkt->ack) + n;
-	iov[1].iov_base = &pkt->ackinfo;
-	iov[1].iov_len	= sizeof(pkt->ackinfo);
-	len = iov[0].iov_len + iov[1].iov_len;
+	iov[0].iov_base	= &txb->wire;
+	iov[0].iov_len	= sizeof(txb->wire) + sizeof(txb->ack) + n;
+	len = iov[0].iov_len;
 
 	serial = atomic_inc_return(&conn->serial);
-	pkt->whdr.serial = htonl(serial);
+	txb->wire.serial = htonl(serial);
 	trace_rxrpc_tx_ack(call->debug_id, serial,
-			   ntohl(pkt->ack.firstPacket),
-			   ntohl(pkt->ack.serial),
-			   pkt->ack.reason, pkt->ack.nAcks);
-	if (_serial)
-		*_serial = serial;
+			   ntohl(txb->ack.firstPacket),
+			   ntohl(txb->ack.serial), txb->ack.reason, txb->ack.nAcks);
+	if (txb->ack_why == rxrpc_propose_ack_ping_for_lost_ack)
+		call->acks_lost_ping = serial;
 
-	if (ping)
+	if (txb->ack.reason == RXRPC_ACK_PING)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_send);
 
-	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
 	call->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_ack);
 	else
-		trace_rxrpc_tx_packet(call->debug_id, &pkt->whdr,
+		trace_rxrpc_tx_packet(call->debug_id, &txb->wire,
 				      rxrpc_tx_point_call_ack);
 	rxrpc_tx_backoff(call, ret);
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		if (ret < 0) {
+		if (ret < 0)
 			rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
-			rxrpc_propose_ACK(call, pkt->ack.reason,
-					  ntohl(pkt->ack.serial),
-					  false, true,
-					  rxrpc_propose_ack_retry_tx);
-		}
-
 		rxrpc_set_keepalive(call);
 	}
 
-out:
 	kfree(pkt);
 	return ret;
 }
 
+/*
+ * ACK transmitter for a local endpoint.  The UDP socket locks around each
+ * transmission, so we can only transmit one packet at a time, ACK, DATA or
+ * otherwise.
+ */
+void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
+{
+	LIST_HEAD(queue);
+	int ret;
+
+	trace_rxrpc_local(local->debug_id, rxrpc_local_tx_ack,
+			  refcount_read(&local->ref), NULL);
+
+	if (list_empty(&local->ack_tx_queue))
+		return;
+
+	spin_lock_bh(&local->ack_tx_lock);
+	list_splice_tail_init(&local->ack_tx_queue, &queue);
+	spin_unlock_bh(&local->ack_tx_lock);
+
+	while (!list_empty(&queue)) {
+		struct rxrpc_txbuf *txb =
+			list_entry(queue.next, struct rxrpc_txbuf, tx_link);
+
+		ret = rxrpc_send_ack_packet(local, txb);
+		if (ret < 0 && ret != -ECONNRESET) {
+			spin_lock_bh(&local->ack_tx_lock);
+			list_splice_init(&queue, &local->ack_tx_queue);
+			spin_unlock_bh(&local->ack_tx_lock);
+			break;
+		}
+
+		list_del_init(&txb->tx_link);
+		rxrpc_put_call(txb->call, rxrpc_call_put);
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_ack_tx);
+	}
+}
+
 /*
  * Send an ABORT call packet.
  */
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index a378e7a672a8..104dd4a29f05 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -189,7 +189,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	ASSERTCMP(call->rx_hard_ack, ==, call->rx_top);
 
 	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY) {
-		rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial, false, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial,
 				  rxrpc_propose_ack_terminal_ack);
 		//rxrpc_send_ack_packet(call, false, NULL);
 	}
@@ -206,7 +206,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
 		write_unlock_bh(&call->state_lock);
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial, false, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
 				  rxrpc_propose_ack_processing_op);
 		break;
 	default:
@@ -259,12 +259,11 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		rxrpc_end_rx_phase(call, serial);
 	} else {
 		/* Check to see if there's an ACK that needs sending. */
-		if (atomic_inc_return(&call->ackr_nr_consumed) > 2)
-			rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial,
-					  true, false,
-					  rxrpc_propose_ack_rotate_rx);
-		if (call->ackr_reason && call->ackr_reason != RXRPC_ACK_DELAY)
-			rxrpc_send_ack_packet(call, false, NULL);
+		if (atomic_inc_return(&call->ackr_nr_consumed) > 2) {
+			rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
+				       rxrpc_propose_ack_rotate_rx);
+			rxrpc_transmit_ack_packets(call->peer->local);
+		}
 	}
 }
 
@@ -363,10 +362,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	unsigned int rx_pkt_offset, rx_pkt_len;
 	int ix, copy, ret = -EAGAIN, ret2;
 
-	if (test_and_clear_bit(RXRPC_CALL_RX_UNDERRUN, &call->flags) &&
-	    call->ackr_reason)
-		rxrpc_send_ack_packet(call, false, NULL);
-
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
 	rx_pkt_last = call->rx_pkt_last;
@@ -389,6 +384,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		if (!skb) {
 			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_hole, seq,
 					    rx_pkt_offset, rx_pkt_len, 0);
+			rxrpc_transmit_ack_packets(call->peer->local);
 			break;
 		}
 		smp_rmb();
@@ -604,6 +600,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (ret == -EAGAIN)
 			ret = 0;
 
+		rxrpc_transmit_ack_packets(call->peer->local);
 		if (after(call->rx_top, call->rx_hard_ack) &&
 		    call->rxtx_buffer[(call->rx_hard_ack + 1) & RXRPC_RXTX_BUFF_MASK])
 			rxrpc_notify_socket(call);
@@ -734,17 +731,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 read_phase_complete:
 	ret = 1;
 out:
-	switch (call->ackr_reason) {
-	case RXRPC_ACK_IDLE:
-		break;
-	case RXRPC_ACK_DELAY:
-		if (ret != -EAGAIN)
-			break;
-		fallthrough;
-	default:
-		rxrpc_send_ack_packet(call, false, NULL);
-	}
-
+	rxrpc_transmit_ack_packets(call->peer->local);
 	if (_service)
 		*_service = call->service_id;
 	mutex_unlock(&call->user_mutex);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index b2d28aa12e10..ef4949259020 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -332,9 +332,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	rxrpc_see_skb(skb, rxrpc_skb_seen);
 
 	do {
-		/* Check to see if there's a ping ACK to reply to. */
-		if (call->ackr_reason == RXRPC_ACK_PING_RESPONSE)
-			rxrpc_send_ack_packet(call, false, NULL);
+		rxrpc_transmit_ack_packets(call->peer->local);
 
 		if (!skb) {
 			size_t remain, bufsize, chunk, offset;
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index 66d922ad65d0..45a7b48a5e10 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -33,6 +33,7 @@ struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
 		txb->len		= 0;
 		txb->offset		= 0;
 		txb->flags		= 0;
+		txb->ack_why		= 0;
 		txb->seq		= call->tx_top + 1;
 		txb->wire.epoch		= htonl(call->conn->proto.epoch);
 		txb->wire.cid		= htonl(call->cid);


