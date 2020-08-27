Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA880254864
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgH0PGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:06:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727906AbgH0PEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwydB0kKI8iiCdqmmmYj/mdWQ0IVrqGYHFLlJXbObnw=;
        b=f7g8JhCicrI3XFjmXbJg9CnZgKOAK0j2Zdx7tdmOtCojwSrOHLS6JPk8PIDo3vkFyWnDa/
        vk0wqRAKJOoa6nY4UBhnS7htJyApuY6UU0dBmKzlZWkcmf9YuKHR3aXCfZzyfBOecglAC9
        bvcJDxyM+1fsArp6kAd9+1JKNYx3Ktc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-uXfkobjrPve1Du6bVSYBUA-1; Thu, 27 Aug 2020 11:04:14 -0400
X-MC-Unique: uXfkobjrPve1Du6bVSYBUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4366B1092811;
        Thu, 27 Aug 2020 15:03:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC365DE4A;
        Thu, 27 Aug 2020 15:03:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/7] rxrpc: Fix loss of RTT samples due to interposed ACK
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Aug 2020 16:03:47 +0100
Message-ID: <159854062729.1382667.3439722279619331347.stgit@warthog.procyon.org.uk>
In-Reply-To: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
References: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rx protocol has a mechanism to help generate RTT samples that works by
a client transmitting a REQUESTED-type ACK when it receives a DATA packet
that has the REQUEST_ACK flag set.

The peer, however, may interpose other ACKs before transmitting the
REQUESTED-ACK, as can be seen in the following trace excerpt:

 rxrpc_tx_data: c=00000044 DATA d0b5ece8:00000001 00000001 q=00000001 fl=07
 rxrpc_rx_ack: c=00000044 00000001 PNG r=00000000 f=00000002 p=00000000 n=0
 rxrpc_rx_ack: c=00000044 00000002 REQ r=00000001 f=00000002 p=00000001 n=0
 ...

DATA packet 1 (q=xx) has REQUEST_ACK set (bit 1 of fl=xx).  The incoming
ping (labelled PNG) hard-acks the request DATA packet (f=xx exceeds the
sequence number of the DATA packet), causing it to be discarded from the Tx
ring.  The ACK that was requested (labelled REQ, r=xx references the serial
of the DATA packet) comes after the ping, but the sk_buff holding the
timestamp has gone and the RTT sample is lost.

This is particularly noticeable on RPC calls used to probe the service
offered by the peer.  A lot of peers end up with an unknown RTT because we
only ever sent a single RPC.  This confuses the server rotation algorithm.

Fix this by caching the information about the outgoing packet in RTT
calculations in the rxrpc_call struct rather than looking in the Tx ring.

A four-deep buffer is maintained and both REQUEST_ACK-flagged DATA and
PING-ACK transmissions are recorded in there.  When the appropriate
response ACK is received, the buffer is checked for a match and, if found,
an RTT sample is recorded.

If a received ACK refers to a packet with a later serial number than an
entry in the cache, that entry is presumed lost and the entry is made
available to record a new transmission.

ACKs types other than REQUESTED-type and PING-type cause any matching
sample to be cancelled as they don't necessarily represent a useful
measurement.

If there's no space in the buffer on ping/data transmission, the sample
base is discarded.

Fixes: 50235c4b5a2f ("rxrpc: Obtain RTT data by requesting ACKs on DATA packets")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   27 +++++++++--
 net/rxrpc/ar-internal.h      |   13 +++--
 net/rxrpc/call_object.c      |    1 
 net/rxrpc/input.c            |  104 ++++++++++++++++++++++++------------------
 net/rxrpc/output.c           |   82 +++++++++++++++++++++++++--------
 net/rxrpc/rtt.c              |    3 +
 6 files changed, 154 insertions(+), 76 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 059b6e45a028..c33079b986e8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -138,11 +138,16 @@ enum rxrpc_recvmsg_trace {
 };
 
 enum rxrpc_rtt_tx_trace {
+	rxrpc_rtt_tx_cancel,
 	rxrpc_rtt_tx_data,
+	rxrpc_rtt_tx_no_slot,
 	rxrpc_rtt_tx_ping,
 };
 
 enum rxrpc_rtt_rx_trace {
+	rxrpc_rtt_rx_cancel,
+	rxrpc_rtt_rx_lost,
+	rxrpc_rtt_rx_obsolete,
 	rxrpc_rtt_rx_ping_response,
 	rxrpc_rtt_rx_requested_ack,
 };
@@ -339,10 +344,15 @@ enum rxrpc_tx_point {
 	E_(rxrpc_recvmsg_wait,			"WAIT")
 
 #define rxrpc_rtt_tx_traces \
+	EM(rxrpc_rtt_tx_cancel,			"CNCE") \
 	EM(rxrpc_rtt_tx_data,			"DATA") \
+	EM(rxrpc_rtt_tx_no_slot,		"FULL") \
 	E_(rxrpc_rtt_tx_ping,			"PING")
 
 #define rxrpc_rtt_rx_traces \
+	EM(rxrpc_rtt_rx_cancel,			"CNCL") \
+	EM(rxrpc_rtt_rx_obsolete,		"OBSL") \
+	EM(rxrpc_rtt_rx_lost,			"LOST") \
 	EM(rxrpc_rtt_rx_ping_response,		"PONG") \
 	E_(rxrpc_rtt_rx_requested_ack,		"RACK")
 
@@ -1087,38 +1097,43 @@ TRACE_EVENT(rxrpc_recvmsg,
 
 TRACE_EVENT(rxrpc_rtt_tx,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_rtt_tx_trace why,
-		     rxrpc_serial_t send_serial),
+		     int slot, rxrpc_serial_t send_serial),
 
-	    TP_ARGS(call, why, send_serial),
+	    TP_ARGS(call, why, slot, send_serial),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(enum rxrpc_rtt_tx_trace,	why		)
+		    __field(int,			slot		)
 		    __field(rxrpc_serial_t,		send_serial	)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->call = call->debug_id;
 		    __entry->why = why;
+		    __entry->slot = slot;
 		    __entry->send_serial = send_serial;
 			   ),
 
-	    TP_printk("c=%08x %s sr=%08x",
+	    TP_printk("c=%08x [%d] %s sr=%08x",
 		      __entry->call,
+		      __entry->slot,
 		      __print_symbolic(__entry->why, rxrpc_rtt_tx_traces),
 		      __entry->send_serial)
 	    );
 
 TRACE_EVENT(rxrpc_rtt_rx,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
+		     int slot,
 		     rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
 		     u32 rtt, u32 rto),
 
-	    TP_ARGS(call, why, send_serial, resp_serial, rtt, rto),
+	    TP_ARGS(call, why, slot, send_serial, resp_serial, rtt, rto),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(enum rxrpc_rtt_rx_trace,	why		)
+		    __field(int,			slot		)
 		    __field(rxrpc_serial_t,		send_serial	)
 		    __field(rxrpc_serial_t,		resp_serial	)
 		    __field(u32,			rtt		)
@@ -1128,14 +1143,16 @@ TRACE_EVENT(rxrpc_rtt_rx,
 	    TP_fast_assign(
 		    __entry->call = call->debug_id;
 		    __entry->why = why;
+		    __entry->slot = slot;
 		    __entry->send_serial = send_serial;
 		    __entry->resp_serial = resp_serial;
 		    __entry->rtt = rtt;
 		    __entry->rto = rto;
 			   ),
 
-	    TP_printk("c=%08x %s sr=%08x rr=%08x rtt=%u rto=%u",
+	    TP_printk("c=%08x [%d] %s sr=%08x rr=%08x rtt=%u rto=%u",
 		      __entry->call,
+		      __entry->slot,
 		      __print_symbolic(__entry->why, rxrpc_rtt_rx_traces),
 		      __entry->send_serial,
 		      __entry->resp_serial,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6d29a3603a3e..884cff7bb169 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -488,7 +488,6 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RX_LAST,		/* Received the last packet (at rxtx_top) */
 	RXRPC_CALL_TX_LAST,		/* Last packet in Tx buffer (at rxtx_top) */
 	RXRPC_CALL_SEND_PING,		/* A ping will need to be sent */
-	RXRPC_CALL_PINGING,		/* Ping in process */
 	RXRPC_CALL_RETRANS_TIMEOUT,	/* Retransmission due to timeout occurred */
 	RXRPC_CALL_BEGAN_RX_TIMER,	/* We began the expect_rx_by timer */
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
@@ -673,9 +672,13 @@ struct rxrpc_call {
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
 
-	/* ping management */
-	rxrpc_serial_t		ping_serial;	/* Last ping sent */
-	ktime_t			ping_time;	/* Time last ping sent */
+	/* RTT management */
+	rxrpc_serial_t		rtt_serial[4];	/* Serial number of DATA or PING sent */
+	ktime_t			rtt_sent_at[4];	/* Time packet sent */
+	unsigned long		rtt_avail;	/* Mask of available slots in bits 0-3,
+						 * Mask of pending samples in 8-11 */
+#define RXRPC_CALL_RTT_AVAIL_MASK	0xf
+#define RXRPC_CALL_RTT_PEND_SHIFT	8
 
 	/* transmission-phase ACK management */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
@@ -1037,7 +1040,7 @@ static inline bool __rxrpc_abort_eproto(struct rxrpc_call *call,
 /*
  * rtt.c
  */
-void rxrpc_peer_add_rtt(struct rxrpc_call *, enum rxrpc_rtt_rx_trace,
+void rxrpc_peer_add_rtt(struct rxrpc_call *, enum rxrpc_rtt_rx_trace, int,
 			rxrpc_serial_t, rxrpc_serial_t, ktime_t, ktime_t);
 unsigned long rxrpc_get_rto_backoff(struct rxrpc_peer *, bool);
 void rxrpc_peer_init_rtt(struct rxrpc_peer *);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 38a46167523f..a40fae013942 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -153,6 +153,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->cong_ssthresh = RXRPC_RXTX_BUFF_SIZE - 1;
 
 	call->rxnet = rxnet;
+	call->rtt_avail = RXRPC_CALL_RTT_AVAIL_MASK;
 	atomic_inc(&rxnet->nr_calls);
 	return call;
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index a7699e56eac8..19ddfc9807e8 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -608,36 +608,57 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 }
 
 /*
- * Process a requested ACK.
+ * See if there's a cached RTT probe to complete.
  */
-static void rxrpc_input_requested_ack(struct rxrpc_call *call,
-				      ktime_t resp_time,
-				      rxrpc_serial_t orig_serial,
-				      rxrpc_serial_t ack_serial)
+static void rxrpc_complete_rtt_probe(struct rxrpc_call *call,
+				     ktime_t resp_time,
+				     rxrpc_serial_t acked_serial,
+				     rxrpc_serial_t ack_serial,
+				     enum rxrpc_rtt_rx_trace type)
 {
-	struct rxrpc_skb_priv *sp;
-	struct sk_buff *skb;
+	rxrpc_serial_t orig_serial;
+	unsigned long avail;
 	ktime_t sent_at;
-	int ix;
+	bool matched = false;
+	int i;
 
-	for (ix = 0; ix < RXRPC_RXTX_BUFF_SIZE; ix++) {
-		skb = call->rxtx_buffer[ix];
-		if (!skb)
-			continue;
+	avail = READ_ONCE(call->rtt_avail);
+	smp_rmb(); /* Read avail bits before accessing data. */
 
-		sent_at = skb->tstamp;
-		smp_rmb(); /* Read timestamp before serial. */
-		sp = rxrpc_skb(skb);
-		if (sp->hdr.serial != orig_serial)
+	for (i = 0; i < ARRAY_SIZE(call->rtt_serial); i++) {
+		if (!test_bit(i + RXRPC_CALL_RTT_PEND_SHIFT, &avail))
 			continue;
-		goto found;
-	}
 
-	return;
+		sent_at = call->rtt_sent_at[i];
+		orig_serial = call->rtt_serial[i];
+
+		if (orig_serial == acked_serial) {
+			clear_bit(i + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
+			smp_mb(); /* Read data before setting avail bit */
+			set_bit(i, &call->rtt_avail);
+			if (type != rxrpc_rtt_rx_cancel)
+				rxrpc_peer_add_rtt(call, type, i, acked_serial, ack_serial,
+						   sent_at, resp_time);
+			else
+				trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_cancel, i,
+						   orig_serial, acked_serial, 0, 0);
+			matched = true;
+		}
+
+		/* If a later serial is being acked, then mark this slot as
+		 * being available.
+		 */
+		if (after(acked_serial, orig_serial)) {
+			trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_obsolete, i,
+					   orig_serial, acked_serial, 0, 0);
+			clear_bit(i + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
+			smp_wmb();
+			set_bit(i, &call->rtt_avail);
+		}
+	}
 
-found:
-	rxrpc_peer_add_rtt(call, rxrpc_rtt_rx_requested_ack,
-			   orig_serial, ack_serial, sent_at, resp_time);
+	if (!matched)
+		trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_lost, 9, 0, acked_serial, 0, 0);
 }
 
 /*
@@ -682,27 +703,11 @@ static void rxrpc_input_check_for_lost_ack(struct rxrpc_call *call)
  */
 static void rxrpc_input_ping_response(struct rxrpc_call *call,
 				      ktime_t resp_time,
-				      rxrpc_serial_t orig_serial,
+				      rxrpc_serial_t acked_serial,
 				      rxrpc_serial_t ack_serial)
 {
-	rxrpc_serial_t ping_serial;
-	ktime_t ping_time;
-
-	ping_time = call->ping_time;
-	smp_rmb();
-	ping_serial = READ_ONCE(call->ping_serial);
-
-	if (orig_serial == call->acks_lost_ping)
+	if (acked_serial == call->acks_lost_ping)
 		rxrpc_input_check_for_lost_ack(call);
-
-	if (before(orig_serial, ping_serial) ||
-	    !test_and_clear_bit(RXRPC_CALL_PINGING, &call->flags))
-		return;
-	if (after(orig_serial, ping_serial))
-		return;
-
-	rxrpc_peer_add_rtt(call, rxrpc_rtt_rx_ping_response,
-			   orig_serial, ack_serial, ping_time, resp_time);
 }
 
 /*
@@ -869,12 +874,23 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 
-	if (buf.ack.reason == RXRPC_ACK_PING_RESPONSE)
+	switch (buf.ack.reason) {
+	case RXRPC_ACK_PING_RESPONSE:
 		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
 					  ack_serial);
-	if (buf.ack.reason == RXRPC_ACK_REQUESTED)
-		rxrpc_input_requested_ack(call, skb->tstamp, acked_serial,
-					  ack_serial);
+		rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
+					 rxrpc_rtt_rx_ping_response);
+		break;
+	case RXRPC_ACK_REQUESTED:
+		rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
+					 rxrpc_rtt_rx_requested_ack);
+		break;
+	default:
+		if (acked_serial != 0)
+			rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
+						 rxrpc_rtt_rx_cancel);
+		break;
+	}
 
 	if (buf.ack.reason == RXRPC_ACK_PING) {
 		_proto("Rx ACK %%%u PING Request", ack_serial);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 1ba43c3df4ad..3cfff7922ba8 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -123,6 +123,49 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	return top - hard_ack + 3;
 }
 
+/*
+ * Record the beginning of an RTT probe.
+ */
+static int rxrpc_begin_rtt_probe(struct rxrpc_call *call, rxrpc_serial_t serial,
+				 enum rxrpc_rtt_tx_trace why)
+{
+	unsigned long avail = call->rtt_avail;
+	int rtt_slot = 9;
+
+	if (!(avail & RXRPC_CALL_RTT_AVAIL_MASK))
+		goto no_slot;
+
+	rtt_slot = __ffs(avail & RXRPC_CALL_RTT_AVAIL_MASK);
+	if (!test_and_clear_bit(rtt_slot, &call->rtt_avail))
+		goto no_slot;
+
+	call->rtt_serial[rtt_slot] = serial;
+	call->rtt_sent_at[rtt_slot] = ktime_get_real();
+	smp_wmb(); /* Write data before avail bit */
+	set_bit(rtt_slot + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
+
+	trace_rxrpc_rtt_tx(call, why, rtt_slot, serial);
+	return rtt_slot;
+
+no_slot:
+	trace_rxrpc_rtt_tx(call, rxrpc_rtt_tx_no_slot, rtt_slot, serial);
+	return -1;
+}
+
+/*
+ * Cancel an RTT probe.
+ */
+static void rxrpc_cancel_rtt_probe(struct rxrpc_call *call,
+				   rxrpc_serial_t serial, int rtt_slot)
+{
+	if (rtt_slot != -1) {
+		clear_bit(rtt_slot + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
+		smp_wmb(); /* Clear pending bit before setting slot */
+		set_bit(rtt_slot, &call->rtt_avail);
+		trace_rxrpc_rtt_tx(call, rxrpc_rtt_tx_cancel, rtt_slot, serial);
+	}
+}
+
 /*
  * Send an ACK call packet.
  */
@@ -136,7 +179,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top;
 	size_t len, n;
-	int ret;
+	int ret, rtt_slot = -1;
 	u8 reason;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
@@ -196,18 +239,8 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	if (_serial)
 		*_serial = serial;
 
-	if (ping) {
-		call->ping_serial = serial;
-		smp_wmb();
-		/* We need to stick a time in before we send the packet in case
-		 * the reply gets back before kernel_sendmsg() completes - but
-		 * asking UDP to send the packet can take a relatively long
-		 * time.
-		 */
-		call->ping_time = ktime_get_real();
-		set_bit(RXRPC_CALL_PINGING, &call->flags);
-		trace_rxrpc_rtt_tx(call, rxrpc_rtt_tx_ping, serial);
-	}
+	if (ping)
+		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);
 
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
 	conn->params.peer->last_tx_at = ktime_get_seconds();
@@ -221,8 +254,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		if (ret < 0) {
-			if (ping)
-				clear_bit(RXRPC_CALL_PINGING, &call->flags);
+			rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 			rxrpc_propose_ACK(call, pkt->ack.reason,
 					  ntohl(pkt->ack.serial),
 					  false, true,
@@ -321,7 +353,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	struct kvec iov[2];
 	rxrpc_serial_t serial;
 	size_t len;
-	int ret;
+	int ret, rtt_slot = -1;
 
 	_enter(",{%d}", skb->len);
 
@@ -397,6 +429,8 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	sp->hdr.serial = serial;
 	smp_wmb(); /* Set serial before timestamp */
 	skb->tstamp = ktime_get_real();
+	if (whdr.flags & RXRPC_REQUEST_ACK)
+		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
 
 	/* send the packet by UDP
 	 * - returns -EMSGSIZE if UDP would have to fragment the packet
@@ -408,12 +442,15 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 
 	up_read(&conn->params.local->defrag_sem);
-	if (ret < 0)
+	if (ret < 0) {
+		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_nofrag);
-	else
+	} else {
 		trace_rxrpc_tx_packet(call->debug_id, &whdr,
 				      rxrpc_tx_point_call_data_nofrag);
+	}
+
 	rxrpc_tx_backoff(call, ret);
 	if (ret == -EMSGSIZE)
 		goto send_fragmentable;
@@ -422,7 +459,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	if (ret >= 0) {
 		if (whdr.flags & RXRPC_REQUEST_ACK) {
 			call->peer->rtt_last_req = skb->tstamp;
-			trace_rxrpc_rtt_tx(call, rxrpc_rtt_tx_data, serial);
 			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
@@ -469,6 +505,8 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	sp->hdr.serial = serial;
 	smp_wmb(); /* Set serial before timestamp */
 	skb->tstamp = ktime_get_real();
+	if (whdr.flags & RXRPC_REQUEST_ACK)
+		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
 
 	switch (conn->params.local->srx.transport.family) {
 	case AF_INET6:
@@ -487,12 +525,14 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		BUG();
 	}
 
-	if (ret < 0)
+	if (ret < 0) {
+		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_frag);
-	else
+	} else {
 		trace_rxrpc_tx_packet(call->debug_id, &whdr,
 				      rxrpc_tx_point_call_data_frag);
+	}
 	rxrpc_tx_backoff(call, ret);
 
 	up_write(&conn->params.local->defrag_sem);
diff --git a/net/rxrpc/rtt.c b/net/rxrpc/rtt.c
index 928d8b34a3ee..1221b0637a7e 100644
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -146,6 +146,7 @@ static void rxrpc_ack_update_rtt(struct rxrpc_peer *peer, long rtt_us)
  * exclusive access to the peer RTT data.
  */
 void rxrpc_peer_add_rtt(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
+			int rtt_slot,
 			rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
 			ktime_t send_time, ktime_t resp_time)
 {
@@ -162,7 +163,7 @@ void rxrpc_peer_add_rtt(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
 		peer->rtt_count++;
 	spin_unlock(&peer->rtt_input_lock);
 
-	trace_rxrpc_rtt_rx(call, why, send_serial, resp_serial,
+	trace_rxrpc_rtt_rx(call, why, rtt_slot, send_serial, resp_serial,
 			   peer->srtt_us >> 3, peer->rto_j);
 }
 


