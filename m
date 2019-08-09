Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED487EEA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437048AbfHIQGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436882AbfHIQGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 12:06:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80D81308FEC1;
        Fri,  9 Aug 2019 16:06:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4525B5D9D3;
        Fri,  9 Aug 2019 16:06:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/2] rxrpc: Don't bother generating maxSkew in the ACK
 packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 09 Aug 2019 17:06:00 +0100
Message-ID: <156536676047.17478.4311933006996701836.stgit@warthog.procyon.org.uk>
In-Reply-To: <156536674651.17478.15139844428920800280.stgit@warthog.procyon.org.uk>
References: <156536674651.17478.15139844428920800280.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 09 Aug 2019 16:06:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother generating maxSkew in the ACK packet as it has been obsolete
since AFS 3.1.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
---

 net/rxrpc/af_rxrpc.c    |    2 +-
 net/rxrpc/ar-internal.h |    3 +--
 net/rxrpc/call_event.c  |   15 ++++++---------
 net/rxrpc/input.c       |   43 ++++++++++++++++---------------------------
 net/rxrpc/output.c      |    3 +--
 net/rxrpc/recvmsg.c     |    6 +++---
 6 files changed, 28 insertions(+), 44 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 8c9bd3ae9edf..0dbbfd1b6487 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -402,7 +402,7 @@ EXPORT_SYMBOL(rxrpc_kernel_check_life);
  */
 void rxrpc_kernel_probe_life(struct socket *sock, struct rxrpc_call *call)
 {
-	rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, 0, true, false,
+	rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
 			  rxrpc_propose_ack_ping_for_check_life);
 	rxrpc_send_ack_packet(call, true, NULL);
 }
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 9796c45d2f6a..145335611af6 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -650,7 +650,6 @@ struct rxrpc_call {
 
 	/* receive-phase ACK management */
 	u8			ackr_reason;	/* reason to ACK */
-	u16			ackr_skew;	/* skew on packet being ACK'd */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_serial_t		ackr_first_seq;	/* first sequence number received */
 	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
@@ -744,7 +743,7 @@ int rxrpc_reject_call(struct rxrpc_sock *);
 /*
  * call_event.c
  */
-void rxrpc_propose_ACK(struct rxrpc_call *, u8, u16, u32, bool, bool,
+void rxrpc_propose_ACK(struct rxrpc_call *, u8, u32, bool, bool,
 		       enum rxrpc_propose_ack_trace);
 void rxrpc_process_call(struct work_struct *);
 
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index bc2adeb3acb9..c767679bfa5d 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -43,8 +43,7 @@ static void rxrpc_propose_ping(struct rxrpc_call *call,
  * propose an ACK be sent
  */
 static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
-				u16 skew, u32 serial, bool immediate,
-				bool background,
+				u32 serial, bool immediate, bool background,
 				enum rxrpc_propose_ack_trace why)
 {
 	enum rxrpc_propose_ack_outcome outcome = rxrpc_propose_ack_use;
@@ -69,14 +68,12 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 		if (RXRPC_ACK_UPDATEABLE & (1 << ack_reason)) {
 			outcome = rxrpc_propose_ack_update;
 			call->ackr_serial = serial;
-			call->ackr_skew = skew;
 		}
 		if (!immediate)
 			goto trace;
 	} else if (prior > rxrpc_ack_priority[call->ackr_reason]) {
 		call->ackr_reason = ack_reason;
 		call->ackr_serial = serial;
-		call->ackr_skew = skew;
 	} else {
 		outcome = rxrpc_propose_ack_subsume;
 	}
@@ -137,11 +134,11 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
  * propose an ACK be sent, locking the call structure
  */
 void rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
-		       u16 skew, u32 serial, bool immediate, bool background,
+		       u32 serial, bool immediate, bool background,
 		       enum rxrpc_propose_ack_trace why)
 {
 	spin_lock_bh(&call->lock);
-	__rxrpc_propose_ACK(call, ack_reason, skew, serial,
+	__rxrpc_propose_ACK(call, ack_reason, serial,
 			    immediate, background, why);
 	spin_unlock_bh(&call->lock);
 }
@@ -239,7 +236,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		ack_ts = ktime_sub(now, call->acks_latest_ts);
 		if (ktime_to_ns(ack_ts) < call->peer->rtt)
 			goto out;
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, 0, true, false,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
 				  rxrpc_propose_ack_ping_for_lost_ack);
 		rxrpc_send_ack_packet(call, true, NULL);
 		goto out;
@@ -372,7 +369,7 @@ void rxrpc_process_call(struct work_struct *work)
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_keepalive, now);
 		cmpxchg(&call->keepalive_at, t, now + MAX_JIFFY_OFFSET);
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, 0, true, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, true,
 				  rxrpc_propose_ack_ping_for_keepalive);
 		set_bit(RXRPC_CALL_EV_PING, &call->events);
 	}
@@ -407,7 +404,7 @@ void rxrpc_process_call(struct work_struct *work)
 	send_ack = NULL;
 	if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events)) {
 		call->acks_lost_top = call->tx_top;
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, 0, true, false,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
 				  rxrpc_propose_ack_ping_for_lost_ack);
 		send_ack = &call->acks_lost_ping;
 	}
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index ee95d1cd1cdf..dd47d465d1d3 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -196,15 +196,14 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
  * Ping the other end to fill our RTT cache and to retrieve the rwind
  * and MTU parameters.
  */
-static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb,
-			    int skew)
+static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	ktime_t now = skb->tstamp;
 
 	if (call->peer->rtt_usage < 3 ||
 	    ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), now))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, skew, sp->hdr.serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
 				  true, true,
 				  rxrpc_propose_ack_ping_for_params);
 }
@@ -419,8 +418,7 @@ static void rxrpc_input_dup_data(struct rxrpc_call *call, rxrpc_seq_t seq,
 /*
  * Process a DATA packet, adding the packet to the Rx ring.
  */
-static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb,
-			     u16 skew)
+static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
@@ -600,11 +598,11 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb,
 
 ack:
 	if (ack)
-		rxrpc_propose_ACK(call, ack, skew, ack_serial,
+		rxrpc_propose_ACK(call, ack, ack_serial,
 				  immediate_ack, true,
 				  rxrpc_propose_ack_input_data);
 	else
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, skew, serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
 				  false, true,
 				  rxrpc_propose_ack_input_data);
 
@@ -822,8 +820,7 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
  * soft-ACK means that the packet may be discarded and retransmission
  * requested.  A phase is complete when all packets are hard-ACK'd.
  */
-static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
-			    u16 skew)
+static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_ack_summary summary = { 0 };
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -867,11 +864,11 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 	if (buf.ack.reason == RXRPC_ACK_PING) {
 		_proto("Rx ACK %%%u PING Request", sp->hdr.serial);
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING_RESPONSE,
-				  skew, sp->hdr.serial, true, true,
+				  sp->hdr.serial, true, true,
 				  rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
 		rxrpc_propose_ACK(call, RXRPC_ACK_REQUESTED,
-				  skew, sp->hdr.serial, true, true,
+				  sp->hdr.serial, true, true,
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
@@ -948,7 +945,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 	    RXRPC_TX_ANNO_LAST &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, skew, sp->hdr.serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
 				  false, true,
 				  rxrpc_propose_ack_ping_for_lost_reply);
 
@@ -1004,7 +1001,7 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
  * Process an incoming call packet.
  */
 static void rxrpc_input_call_packet(struct rxrpc_call *call,
-				    struct sk_buff *skb, u16 skew)
+				    struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned long timo;
@@ -1023,11 +1020,11 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_DATA:
-		rxrpc_input_data(call, skb, skew);
+		rxrpc_input_data(call, skb);
 		break;
 
 	case RXRPC_PACKET_TYPE_ACK:
-		rxrpc_input_ack(call, skb, skew);
+		rxrpc_input_ack(call, skb);
 		break;
 
 	case RXRPC_PACKET_TYPE_BUSY:
@@ -1181,7 +1178,6 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	struct rxrpc_peer *peer = NULL;
 	struct rxrpc_sock *rx = NULL;
 	unsigned int channel;
-	int skew = 0;
 
 	_enter("%p", udp_sk);
 
@@ -1309,15 +1305,8 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 			goto out;
 		}
 
-		/* Note the serial number skew here */
-		skew = (int)sp->hdr.serial - (int)conn->hi_serial;
-		if (skew >= 0) {
-			if (skew > 0)
-				conn->hi_serial = sp->hdr.serial;
-		} else {
-			skew = -skew;
-			skew = min(skew, 65535);
-		}
+		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
+			conn->hi_serial = sp->hdr.serial;
 
 		/* Call-bound packets are routed by connection channel. */
 		channel = sp->hdr.cid & RXRPC_CHANNELMASK;
@@ -1380,11 +1369,11 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		call = rxrpc_new_incoming_call(local, rx, skb);
 		if (!call)
 			goto reject_packet;
-		rxrpc_send_ping(call, skb, skew);
+		rxrpc_send_ping(call, skb);
 		mutex_unlock(&call->user_mutex);
 	}
 
-	rxrpc_input_call_packet(call, skb, skew);
+	rxrpc_input_call_packet(call, skb);
 	goto discard;
 
 discard:
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 948e3fe249ec..369e516c4bdf 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -87,7 +87,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	*_top = top;
 
 	pkt->ack.bufferSpace	= htons(8);
-	pkt->ack.maxSkew	= htons(call->ackr_skew);
+	pkt->ack.maxSkew	= htons(0);
 	pkt->ack.firstPacket	= htonl(hard_ack + 1);
 	pkt->ack.previousPacket	= htonl(call->ackr_prev_seq);
 	pkt->ack.serial		= htonl(serial);
@@ -228,7 +228,6 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 			if (ping)
 				clear_bit(RXRPC_CALL_PINGING, &call->flags);
 			rxrpc_propose_ACK(call, pkt->ack.reason,
-					  ntohs(pkt->ack.maxSkew),
 					  ntohl(pkt->ack.serial),
 					  false, true,
 					  rxrpc_propose_ack_retry_tx);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 5abf46cf9e6c..9a7e1bc9791d 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -141,7 +141,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	ASSERTCMP(call->rx_hard_ack, ==, call->rx_top);
 
 	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY) {
-		rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, 0, serial, false, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial, false, true,
 				  rxrpc_propose_ack_terminal_ack);
 		//rxrpc_send_ack_packet(call, false, NULL);
 	}
@@ -159,7 +159,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
 		write_unlock_bh(&call->state_lock);
-		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, 0, serial, false, true,
+		rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial, false, true,
 				  rxrpc_propose_ack_processing_op);
 		break;
 	default:
@@ -212,7 +212,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		if (after_eq(hard_ack, call->ackr_consumed + 2) ||
 		    after_eq(top, call->ackr_seen + 2) ||
 		    (hard_ack == top && after(hard_ack, call->ackr_consumed)))
-			rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, 0, serial,
+			rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
 					  true, true,
 					  rxrpc_propose_ack_rotate_rx);
 		if (call->ackr_reason && call->ackr_reason != RXRPC_ACK_DELAY)

