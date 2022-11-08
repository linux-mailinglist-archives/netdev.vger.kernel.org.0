Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43661621F17
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKHWWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiKHWVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:21:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326E665866
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NF61F85DwvGydNIJILyr6fL2H22hAofSfJYUIRC4l58=;
        b=Fjviegw76OPyLEVIp0+ifU8Q+VCtBI7G6Wil8YVRow4PPsiIheE5yGqBpkD5zS3IPmGGUN
        sOZKHYX1M+rJEOOE9BkMs1irTs87AHtJ/b/j9ZRgIISeABeYeuftjC6RkuH4Gi5OJrl0hl
        o6N/XzsviuwwzFYsJZIDcA5PgSlih0w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-ukVERUefMGOlFe96hMwDWw-1; Tue, 08 Nov 2022 17:19:43 -0500
X-MC-Unique: ukVERUefMGOlFe96hMwDWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 775DB299E74F;
        Tue,  8 Nov 2022 22:19:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB89B10197;
        Tue,  8 Nov 2022 22:19:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/26] rxrpc: Clean up ACK handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:41 +0000
Message-ID: <166794598114.2389296.12875972474009409883.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the rxrpc_propose_ACK() function.  If deferred PING ACK proposal
is split out, it's only really needed for deferred DELAY ACKs.  All other
ACKs, bar terminal IDLE ACK are sent immediately.  The deferred IDLE ACK
submission can be handled by conversion of a DELAY ACK into an IDLE ACK if
there's nothing to be SACK'd.

Also, because there's a delay between an ACK being generated and being
transmitted, it's possible that other ACKs of the same type will be
generated during that interval.  Apart from the ACK time and the serial
number responded to, most of the ACK body, including window and SACK
parameters, are not filled out till the point of transmission - so we can
avoid generating a new ACK if there's one pending that will cover the SACK
data we need to convey.

Therefore, don't propose a new DELAY or IDLE ACK for a call if there's one
already pending.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   52 ++++++++++++++++-------
 net/rxrpc/ar-internal.h      |   10 ++--
 net/rxrpc/call_event.c       |   95 +++++++++++-------------------------------
 net/rxrpc/call_object.c      |    2 -
 net/rxrpc/input.c            |    8 ++--
 net/rxrpc/misc.c             |   18 --------
 net/rxrpc/output.c           |    7 +++
 net/rxrpc/protocol.h         |    7 ---
 net/rxrpc/recvmsg.c          |   14 +++---
 net/rxrpc/sendmsg.c          |    2 -
 net/rxrpc/sysctl.c           |    9 ----
 11 files changed, 86 insertions(+), 138 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 1597ff7ad97e..d32e9858c682 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -158,6 +158,7 @@
 #define rxrpc_propose_ack_traces \
 	EM(rxrpc_propose_ack_client_tx_end,	"ClTxEnd") \
 	EM(rxrpc_propose_ack_input_data,	"DataIn ") \
+	EM(rxrpc_propose_ack_input_data_hole,	"DataInH") \
 	EM(rxrpc_propose_ack_ping_for_check_life, "ChkLife") \
 	EM(rxrpc_propose_ack_ping_for_keepalive, "KeepAlv") \
 	EM(rxrpc_propose_ack_ping_for_lost_ack,	"LostAck") \
@@ -170,11 +171,6 @@
 	EM(rxrpc_propose_ack_rotate_rx,		"RxAck  ") \
 	E_(rxrpc_propose_ack_terminal_ack,	"ClTerm ")
 
-#define rxrpc_propose_ack_outcomes \
-	EM(rxrpc_propose_ack_subsume,		" Subsume") \
-	EM(rxrpc_propose_ack_update,		" Update") \
-	E_(rxrpc_propose_ack_use,		" New")
-
 #define rxrpc_congest_modes \
 	EM(RXRPC_CALL_CONGEST_AVOIDANCE,	"CongAvoid") \
 	EM(RXRPC_CALL_FAST_RETRANSMIT,		"FastReTx ") \
@@ -313,7 +309,6 @@ rxrpc_congest_changes;
 rxrpc_congest_modes;
 rxrpc_conn_traces;
 rxrpc_local_traces;
-rxrpc_propose_ack_outcomes;
 rxrpc_propose_ack_traces;
 rxrpc_receive_traces;
 rxrpc_recvmsg_traces;
@@ -1012,7 +1007,7 @@ TRACE_EVENT(rxrpc_timer,
 		    __entry->call		= call->debug_id;
 		    __entry->why		= why;
 		    __entry->now		= now;
-		    __entry->ack_at		= call->ack_at;
+		    __entry->ack_at		= call->delay_ack_at;
 		    __entry->ack_lost_at	= call->ack_lost_at;
 		    __entry->resend_at		= call->resend_at;
 		    __entry->expect_rx_by	= call->expect_rx_by;
@@ -1054,7 +1049,7 @@ TRACE_EVENT(rxrpc_timer_expired,
 	    TP_fast_assign(
 		    __entry->call		= call->debug_id;
 		    __entry->now		= now;
-		    __entry->ack_at		= call->ack_at;
+		    __entry->ack_at		= call->delay_ack_at;
 		    __entry->ack_lost_at	= call->ack_lost_at;
 		    __entry->resend_at		= call->resend_at;
 		    __entry->expect_rx_by	= call->expect_rx_by;
@@ -1098,17 +1093,15 @@ TRACE_EVENT(rxrpc_rx_lose,
 
 TRACE_EVENT(rxrpc_propose_ack,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_propose_ack_trace why,
-		     u8 ack_reason, rxrpc_serial_t serial,
-		     enum rxrpc_propose_ack_outcome outcome),
+		     u8 ack_reason, rxrpc_serial_t serial),
 
-	    TP_ARGS(call, why, ack_reason, serial, outcome),
+	    TP_ARGS(call, why, ack_reason, serial),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,			call		)
 		    __field(enum rxrpc_propose_ack_trace,	why		)
 		    __field(rxrpc_serial_t,			serial		)
 		    __field(u8,					ack_reason	)
-		    __field(enum rxrpc_propose_ack_outcome,	outcome		)
 			     ),
 
 	    TP_fast_assign(
@@ -1116,15 +1109,13 @@ TRACE_EVENT(rxrpc_propose_ack,
 		    __entry->why	= why;
 		    __entry->serial	= serial;
 		    __entry->ack_reason	= ack_reason;
-		    __entry->outcome	= outcome;
 			   ),
 
-	    TP_printk("c=%08x %s %s r=%08x%s",
+	    TP_printk("c=%08x %s %s r=%08x",
 		      __entry->call,
 		      __print_symbolic(__entry->why, rxrpc_propose_ack_traces),
 		      __print_symbolic(__entry->ack_reason, rxrpc_ack_names),
-		      __entry->serial,
-		      __print_symbolic(__entry->outcome, rxrpc_propose_ack_outcomes))
+		      __entry->serial)
 	    );
 
 TRACE_EVENT(rxrpc_send_ack,
@@ -1154,6 +1145,35 @@ TRACE_EVENT(rxrpc_send_ack,
 		      __entry->serial)
 	    );
 
+TRACE_EVENT(rxrpc_drop_ack,
+	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_propose_ack_trace why,
+		     u8 ack_reason, rxrpc_serial_t serial, bool nobuf),
+
+	    TP_ARGS(call, why, ack_reason, serial, nobuf),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,			call		)
+		    __field(enum rxrpc_propose_ack_trace,	why		)
+		    __field(rxrpc_serial_t,			serial		)
+		    __field(u8,					ack_reason	)
+		    __field(bool,				nobuf		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call	= call->debug_id;
+		    __entry->why	= why;
+		    __entry->serial	= serial;
+		    __entry->ack_reason	= ack_reason;
+		    __entry->nobuf	= nobuf;
+			   ),
+
+	    TP_printk("c=%08x %s %s r=%08x nbf=%u",
+		      __entry->call,
+		      __print_symbolic(__entry->why, rxrpc_propose_ack_traces),
+		      __print_symbolic(__entry->ack_reason, rxrpc_ack_names),
+		      __entry->serial, __entry->nobuf)
+	    );
+
 TRACE_EVENT(rxrpc_retransmit,
 	    TP_PROTO(struct rxrpc_call *call, rxrpc_seq_t seq, u8 annotation,
 		     s64 expiry),
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 802a8f372af2..5a81545a58d5 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -516,6 +516,8 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
 	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
+	RXRPC_CALL_DELAY_ACK_PENDING,	/* DELAY ACK generation is pending */
+	RXRPC_CALL_IDLE_ACK_PENDING,	/* IDLE ACK generation is pending */
 };
 
 /*
@@ -582,7 +584,7 @@ struct rxrpc_call {
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
 	const struct rxrpc_security *security;	/* applied security module */
 	struct mutex		user_mutex;	/* User access mutex */
-	unsigned long		ack_at;		/* When deferred ACK needs to happen */
+	unsigned long		delay_ack_at;	/* When DELAY ACK needs to happen */
 	unsigned long		ack_lost_at;	/* When ACK is figured as lost */
 	unsigned long		resend_at;	/* When next resend needs to happen */
 	unsigned long		ping_at;	/* When next to send a ping */
@@ -834,7 +836,8 @@ int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
 			enum rxrpc_propose_ack_trace why);
 void rxrpc_send_ACK(struct rxrpc_call *, u8, rxrpc_serial_t, enum rxrpc_propose_ack_trace);
-void rxrpc_propose_ACK(struct rxrpc_call *, u8, u32, enum rxrpc_propose_ack_trace);
+void rxrpc_propose_delay_ACK(struct rxrpc_call *, rxrpc_serial_t,
+			     enum rxrpc_propose_ack_trace);
 void rxrpc_process_call(struct work_struct *);
 
 void rxrpc_reduce_call_timer(struct rxrpc_call *call,
@@ -1016,15 +1019,12 @@ static inline bool __rxrpc_use_local(struct rxrpc_local *local)
  * misc.c
  */
 extern unsigned int rxrpc_max_backlog __read_mostly;
-extern unsigned long rxrpc_requested_ack_delay;
 extern unsigned long rxrpc_soft_ack_delay;
 extern unsigned long rxrpc_idle_ack_delay;
 extern unsigned int rxrpc_rx_window_size;
 extern unsigned int rxrpc_rx_mtu;
 extern unsigned int rxrpc_rx_jumbo_max;
 
-extern const s8 rxrpc_ack_priority[];
-
 /*
  * net_ns.c
  */
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 67b54ad914a1..36f60ac1d95d 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -29,70 +29,29 @@ void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
 	spin_lock_bh(&call->lock);
 
 	if (time_before(ping_at, call->ping_at)) {
-		rxrpc_inc_stat(call->rxnet, stat_tx_acks[RXRPC_ACK_PING]);
 		WRITE_ONCE(call->ping_at, ping_at);
 		rxrpc_reduce_call_timer(call, ping_at, now,
 					rxrpc_timer_set_for_ping);
-		trace_rxrpc_propose_ack(call, why, RXRPC_ACK_PING, serial,
-					rxrpc_propose_ack_use);
+		trace_rxrpc_propose_ack(call, why, RXRPC_ACK_PING, serial);
 	}
 
 	spin_unlock_bh(&call->lock);
 }
 
 /*
- * propose an ACK be sent
+ * Propose a DELAY ACK be sent in the future.
  */
-static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
-				u32 serial, enum rxrpc_propose_ack_trace why)
+static void __rxrpc_propose_delay_ACK(struct rxrpc_call *call,
+				      rxrpc_serial_t serial,
+				      enum rxrpc_propose_ack_trace why)
 {
-	enum rxrpc_propose_ack_outcome outcome = rxrpc_propose_ack_use;
 	unsigned long expiry = rxrpc_soft_ack_delay;
 	unsigned long now = jiffies, ack_at;
-	s8 prior = rxrpc_ack_priority[ack_reason];
-
-	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
-
-	/* Update DELAY, IDLE, REQUESTED and PING_RESPONSE ACK serial
-	 * numbers, but we don't alter the timeout.
-	 */
-	_debug("prior %u %u vs %u %u",
-	       ack_reason, prior,
-	       call->ackr_reason, rxrpc_ack_priority[call->ackr_reason]);
-	if (ack_reason == call->ackr_reason) {
-		if (RXRPC_ACK_UPDATEABLE & (1 << ack_reason)) {
-			outcome = rxrpc_propose_ack_update;
-			call->ackr_serial = serial;
-		}
-	} else if (prior > rxrpc_ack_priority[call->ackr_reason]) {
-		call->ackr_reason = ack_reason;
-		call->ackr_serial = serial;
-	} else {
-		outcome = rxrpc_propose_ack_subsume;
-	}
-
-	switch (ack_reason) {
-	case RXRPC_ACK_REQUESTED:
-		if (rxrpc_requested_ack_delay < expiry)
-			expiry = rxrpc_requested_ack_delay;
-		break;
-
-	case RXRPC_ACK_DELAY:
-		if (rxrpc_soft_ack_delay < expiry)
-			expiry = rxrpc_soft_ack_delay;
-		break;
-
-	case RXRPC_ACK_IDLE:
-		if (rxrpc_idle_ack_delay < expiry)
-			expiry = rxrpc_idle_ack_delay;
-		break;
-
-	default:
-		WARN_ON(1);
-		return;
-	}
 
+	call->ackr_serial = serial;
 
+	if (rxrpc_soft_ack_delay < expiry)
+		expiry = rxrpc_soft_ack_delay;
 	if (call->peer->srtt_us != 0)
 		ack_at = usecs_to_jiffies(call->peer->srtt_us >> 3);
 	else
@@ -100,23 +59,23 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 
 	ack_at += READ_ONCE(call->tx_backoff);
 	ack_at += now;
-	if (time_before(ack_at, call->ack_at)) {
-		WRITE_ONCE(call->ack_at, ack_at);
+	if (time_before(ack_at, call->delay_ack_at)) {
+		WRITE_ONCE(call->delay_ack_at, ack_at);
 		rxrpc_reduce_call_timer(call, ack_at, now,
 					rxrpc_timer_set_for_ack);
 	}
 
-	trace_rxrpc_propose_ack(call, why, ack_reason, serial, outcome);
+	trace_rxrpc_propose_ack(call, why, RXRPC_ACK_DELAY, serial);
 }
 
 /*
- * propose an ACK be sent, locking the call structure
+ * Propose a DELAY ACK be sent, locking the call structure
  */
-void rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason, u32 serial,
-		       enum rxrpc_propose_ack_trace why)
+void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t  serial,
+			     enum rxrpc_propose_ack_trace why)
 {
 	spin_lock_bh(&call->lock);
-	__rxrpc_propose_ACK(call, ack_reason, serial, why);
+	__rxrpc_propose_delay_ACK(call, serial, why);
 	spin_unlock_bh(&call->lock);
 }
 
@@ -131,6 +90,11 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return;
+	if (ack_reason == RXRPC_ACK_DELAY &&
+	    test_and_set_bit(RXRPC_CALL_DELAY_ACK_PENDING, &call->flags)) {
+		trace_rxrpc_drop_ack(call, why, ack_reason, serial, false);
+		return;
+	}
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
 
@@ -319,7 +283,6 @@ void rxrpc_process_call(struct work_struct *work)
 	unsigned long now, next, t;
 	unsigned int iterations = 0;
 	rxrpc_serial_t ackr_serial;
-	u8 ackr_reason;
 
 	rxrpc_see_call(call);
 
@@ -364,19 +327,13 @@ void rxrpc_process_call(struct work_struct *work)
 		set_bit(RXRPC_CALL_EV_EXPIRED, &call->events);
 	}
 
-	t = READ_ONCE(call->ack_at);
+	t = READ_ONCE(call->delay_ack_at);
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_ack, now);
-		cmpxchg(&call->ack_at, t, now + MAX_JIFFY_OFFSET);
-		spin_lock_bh(&call->lock);
-		ackr_reason = call->ackr_reason;
-		ackr_serial = call->ackr_serial;
-		call->ackr_reason = 0;
-		call->ackr_serial = 0;
-		spin_unlock_bh(&call->lock);
-		if (ackr_reason)
-			rxrpc_send_ACK(call, ackr_reason, ackr_serial,
-				       rxrpc_propose_ack_ping_for_lost_ack);
+		cmpxchg(&call->delay_ack_at, t, now + MAX_JIFFY_OFFSET);
+		ackr_serial = xchg(&call->ackr_serial, 0);
+		rxrpc_send_ACK(call, RXRPC_ACK_DELAY, ackr_serial,
+			       rxrpc_propose_ack_ping_for_lost_ack);
 	}
 
 	t = READ_ONCE(call->ack_lost_at);
@@ -441,7 +398,7 @@ void rxrpc_process_call(struct work_struct *work)
 
 	set(call->expect_req_by);
 	set(call->expect_term_by);
-	set(call->ack_at);
+	set(call->delay_ack_at);
 	set(call->ack_lost_at);
 	set(call->resend_at);
 	set(call->keepalive_at);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 8290d94e9233..8f9e88897197 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -222,7 +222,7 @@ static void rxrpc_start_call_timer(struct rxrpc_call *call)
 	unsigned long now = jiffies;
 	unsigned long j = now + MAX_JIFFY_OFFSET;
 
-	call->ack_at = j;
+	call->delay_ack_at = j;
 	call->ack_lost_at = j;
 	call->resend_at = j;
 	call->ping_at = j;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e23f66ef8c06..4df1bdc4de6c 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -299,7 +299,7 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 		now = jiffies;
 		timo = now + MAX_JIFFY_OFFSET;
 		WRITE_ONCE(call->resend_at, timo);
-		WRITE_ONCE(call->ack_at, timo);
+		WRITE_ONCE(call->delay_ack_at, timo);
 		trace_rxrpc_timer(call, rxrpc_timer_init_for_reply, now);
 	}
 
@@ -542,7 +542,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			/* Send an immediate ACK if we fill in a hole */
 			if (!acked) {
 				rxrpc_send_ACK(call, RXRPC_ACK_DELAY, serial,
-					       rxrpc_propose_ack_input_data);
+					       rxrpc_propose_ack_input_data_hole);
 				acked = true;
 			}
 		}
@@ -584,8 +584,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, ack_serial,
 			       rxrpc_propose_ack_input_data);
 	else
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, ack_serial,
-				  rxrpc_propose_ack_input_data);
+		rxrpc_propose_delay_ACK(call, ack_serial,
+					rxrpc_propose_ack_input_data);
 
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
diff --git a/net/rxrpc/misc.c b/net/rxrpc/misc.c
index d4144fd86f84..f5f03f27bd6c 100644
--- a/net/rxrpc/misc.c
+++ b/net/rxrpc/misc.c
@@ -16,12 +16,6 @@
  */
 unsigned int rxrpc_max_backlog __read_mostly = 10;
 
-/*
- * How long to wait before scheduling ACK generation after seeing a
- * packet with RXRPC_REQUEST_ACK set (in jiffies).
- */
-unsigned long rxrpc_requested_ack_delay = 1;
-
 /*
  * How long to wait before scheduling an ACK with subtype DELAY (in jiffies).
  *
@@ -62,15 +56,3 @@ unsigned int rxrpc_rx_mtu = 5692;
  * sender that we're willing to handle.
  */
 unsigned int rxrpc_rx_jumbo_max = 4;
-
-const s8 rxrpc_ack_priority[] = {
-	[0]				= 0,
-	[RXRPC_ACK_DELAY]		= 1,
-	[RXRPC_ACK_REQUESTED]		= 2,
-	[RXRPC_ACK_IDLE]		= 3,
-	[RXRPC_ACK_DUPLICATE]		= 4,
-	[RXRPC_ACK_OUT_OF_SEQUENCE]	= 5,
-	[RXRPC_ACK_EXCEEDS_WINDOW]	= 6,
-	[RXRPC_ACK_NOSPACE]		= 7,
-	[RXRPC_ACK_PING_RESPONSE]	= 8,
-};
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 1edbc678e8be..d35657b659ad 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -115,6 +115,8 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				*ackp++ = RXRPC_ACK_TYPE_NACK;
 			seq++;
 		} while (before_eq(seq, top));
+	} else if (txb->ack.reason == RXRPC_ACK_DELAY) {
+		txb->ack.reason = RXRPC_ACK_IDLE;
 	}
 
 	mtu = conn->params.peer->if_mtu;
@@ -204,6 +206,11 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	if (txb->ack.reason == RXRPC_ACK_PING)
 		txb->wire.flags |= RXRPC_REQUEST_ACK;
 
+	if (txb->ack.reason == RXRPC_ACK_DELAY)
+		clear_bit(RXRPC_CALL_DELAY_ACK_PENDING, &call->flags);
+	if (txb->ack.reason == RXRPC_ACK_IDLE)
+		clear_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
+
 	spin_lock_bh(&call->lock);
 	n = rxrpc_fill_out_ack(conn, call, txb, &hard_ack, &top);
 	spin_unlock_bh(&call->lock);
diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
index d2cf8e1d218f..f3d4e2700901 100644
--- a/net/rxrpc/protocol.h
+++ b/net/rxrpc/protocol.h
@@ -132,13 +132,6 @@ struct rxrpc_ackpacket {
 
 } __packed;
 
-/* Some ACKs refer to specific packets and some are general and can be updated. */
-#define RXRPC_ACK_UPDATEABLE ((1 << RXRPC_ACK_REQUESTED)	|	\
-			      (1 << RXRPC_ACK_PING_RESPONSE)	|	\
-			      (1 << RXRPC_ACK_DELAY)		|	\
-			      (1 << RXRPC_ACK_IDLE))
-
-
 /*
  * ACK packets can have a further piece of information tagged on the end
  */
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 104dd4a29f05..46e784edc0f4 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -188,11 +188,8 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	trace_rxrpc_receive(call, rxrpc_receive_end, 0, call->rx_top);
 	ASSERTCMP(call->rx_hard_ack, ==, call->rx_top);
 
-	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY) {
-		rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial,
-				  rxrpc_propose_ack_terminal_ack);
-		//rxrpc_send_ack_packet(call, false, NULL);
-	}
+	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY)
+		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
 
 	write_lock_bh(&call->state_lock);
 
@@ -206,8 +203,8 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
 		write_unlock_bh(&call->state_lock);
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
-				  rxrpc_propose_ack_processing_op);
+		rxrpc_propose_delay_ACK(call, serial,
+					rxrpc_propose_ack_processing_op);
 		break;
 	default:
 		write_unlock_bh(&call->state_lock);
@@ -259,7 +256,8 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		rxrpc_end_rx_phase(call, serial);
 	} else {
 		/* Check to see if there's an ACK that needs sending. */
-		if (atomic_inc_return(&call->ackr_nr_consumed) > 2) {
+		if (atomic_inc_return(&call->ackr_nr_consumed) > 2 &&
+		    !test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
 			rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
 				       rxrpc_propose_ack_rotate_rx);
 			rxrpc_transmit_ack_packets(call->peer->local);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index ef4949259020..e32805a49324 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -234,7 +234,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		case RXRPC_CALL_SERVER_ACK_REQUEST:
 			call->state = RXRPC_CALL_SERVER_SEND_REPLY;
 			now = jiffies;
-			WRITE_ONCE(call->ack_at, now + MAX_JIFFY_OFFSET);
+			WRITE_ONCE(call->delay_ack_at, now + MAX_JIFFY_OFFSET);
 			if (call->ackr_reason == RXRPC_ACK_DELAY)
 				call->ackr_reason = 0;
 			trace_rxrpc_timer(call, rxrpc_timer_init_for_send_reply, now);
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 555e0910786b..2bd987364e44 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -26,15 +26,6 @@ static const unsigned long max_jiffies = MAX_JIFFY_OFFSET;
  */
 static struct ctl_table rxrpc_sysctl_table[] = {
 	/* Values measured in milliseconds but used in jiffies */
-	{
-		.procname	= "req_ack_delay",
-		.data		= &rxrpc_requested_ack_delay,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
-		.extra1		= (void *)&one_jiffy,
-		.extra2		= (void *)&max_jiffies,
-	},
 	{
 		.procname	= "soft_ack_delay",
 		.data		= &rxrpc_soft_ack_delay,


