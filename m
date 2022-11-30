Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3163DB47
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiK3Q73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiK3Q6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:58:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F28FD64
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Da23v2ofVBsJvoOGg99bX5bNrH38dJvu85qEAwPJJD0=;
        b=JUHtpvCn0dCwexe0VAmmkn7iD3v+V/yyJWq6b/8DpYDnvul0OfvW7E4JSYSXdT5i/siw1a
        M4U4KJ7M5VseyKg3EjqRjS6JTHV3Hyyv7/6GEPVDNk5lFhgmvUE+0ENxFzApvbMJQLKutk
        DlVj+HCWwKn/66JPT0Rean480qbSrW8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-Hs7kBDP9MqCm7F8ZdJ2DCg-1; Wed, 30 Nov 2022 11:56:49 -0500
X-MC-Unique: Hs7kBDP9MqCm7F8ZdJ2DCg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E7D1185A79C;
        Wed, 30 Nov 2022 16:56:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 633B2470360;
        Wed, 30 Nov 2022 16:56:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/35] rxrpc: Split the receive code
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:56:45 +0000
Message-ID: <166982740561.621383.12448358095690926130.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the code that handles packet reception in softirq mode as a prelude
to moving all the packet processing beyond routing to the appropriate call
and setting up of a new call out into process context.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/Makefile      |    1 
 net/rxrpc/ar-internal.h |    7 +
 net/rxrpc/input.c       |  372 +----------------------------------------------
 net/rxrpc/io_thread.c   |  370 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 384 insertions(+), 366 deletions(-)
 create mode 100644 net/rxrpc/io_thread.c

diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index 79687477d93c..e76d3459d78e 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -16,6 +16,7 @@ rxrpc-y := \
 	conn_service.o \
 	input.o \
 	insecure.o \
+	io_thread.o \
 	key.o \
 	local_event.o \
 	local_object.o \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 41a57c145f2b..523cc9c5ab12 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -946,6 +946,13 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 /*
  * input.c
  */
+void rxrpc_input_call_packet(struct rxrpc_call *, struct sk_buff *);
+void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection *,
+				   struct rxrpc_call *);
+
+/*
+ * io_thread.c
+ */
 int rxrpc_input_packet(struct sock *, struct sk_buff *);
 
 /*
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index ab8b7a1be935..f4f6f3c62d03 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* RxRPC packet reception
+/* Processing of received RxRPC packets
  *
- * Copyright (C) 2007, 2016 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  */
 
@@ -1029,7 +1029,7 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 /*
  * Process an incoming call packet.
  */
-static void rxrpc_input_call_packet(struct rxrpc_call *call,
+void rxrpc_input_call_packet(struct rxrpc_call *call,
 				    struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -1086,9 +1086,9 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
  *
  * TODO: If callNumber > call_id + 1, renegotiate security.
  */
-static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
-					  struct rxrpc_connection *conn,
-					  struct rxrpc_call *call)
+void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
+				   struct rxrpc_connection *conn,
+				   struct rxrpc_call *call)
 {
 	switch (READ_ONCE(call->state)) {
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
@@ -1109,363 +1109,3 @@ static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&rx->incoming_lock);
 }
-
-/*
- * post connection-level events to the connection
- * - this includes challenges, responses, some aborts and call terminal packet
- *   retransmission.
- */
-static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
-				      struct sk_buff *skb)
-{
-	_enter("%p,%p", conn, skb);
-
-	skb_queue_tail(&conn->rx_queue, skb);
-	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
-}
-
-/*
- * post endpoint-level events to the local endpoint
- * - this includes debug and version messages
- */
-static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
-				       struct sk_buff *skb)
-{
-	_enter("%p,%p", local, skb);
-
-	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
-		skb_queue_tail(&local->event_queue, skb);
-		rxrpc_queue_local(local);
-	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
-	}
-}
-
-/*
- * put a packet up for transport-level abort
- */
-static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
-{
-	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
-		skb_queue_tail(&local->reject_queue, skb);
-		rxrpc_queue_local(local);
-	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
-	}
-}
-
-/*
- * Extract the wire header from a packet and translate the byte order.
- */
-static noinline
-int rxrpc_extract_header(struct rxrpc_skb_priv *sp, struct sk_buff *skb)
-{
-	struct rxrpc_wire_header whdr;
-
-	/* dig out the RxRPC connection details */
-	if (skb_copy_bits(skb, 0, &whdr, sizeof(whdr)) < 0) {
-		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-				      tracepoint_string("bad_hdr"));
-		return -EBADMSG;
-	}
-
-	memset(sp, 0, sizeof(*sp));
-	sp->hdr.epoch		= ntohl(whdr.epoch);
-	sp->hdr.cid		= ntohl(whdr.cid);
-	sp->hdr.callNumber	= ntohl(whdr.callNumber);
-	sp->hdr.seq		= ntohl(whdr.seq);
-	sp->hdr.serial		= ntohl(whdr.serial);
-	sp->hdr.flags		= whdr.flags;
-	sp->hdr.type		= whdr.type;
-	sp->hdr.userStatus	= whdr.userStatus;
-	sp->hdr.securityIndex	= whdr.securityIndex;
-	sp->hdr._rsvd		= ntohs(whdr._rsvd);
-	sp->hdr.serviceId	= ntohs(whdr.serviceId);
-	return 0;
-}
-
-/*
- * Extract the abort code from an ABORT packet and stash it in skb->priority.
- */
-static bool rxrpc_extract_abort(struct sk_buff *skb)
-{
-	__be32 wtmp;
-
-	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
-			  &wtmp, sizeof(wtmp)) < 0)
-		return false;
-	skb->priority = ntohl(wtmp);
-	return true;
-}
-
-/*
- * handle data received on the local endpoint
- * - may be called in interrupt context
- *
- * [!] Note that as this is called from the encap_rcv hook, the socket is not
- * held locked by the caller and nothing prevents sk_user_data on the UDP from
- * being cleared in the middle of processing this function.
- *
- * Called with the RCU read lock held from the IP layer via UDP.
- */
-int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
-{
-	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
-	struct rxrpc_connection *conn;
-	struct rxrpc_channel *chan;
-	struct rxrpc_call *call = NULL;
-	struct rxrpc_skb_priv *sp;
-	struct rxrpc_peer *peer = NULL;
-	struct rxrpc_sock *rx = NULL;
-	unsigned int channel;
-
-	_enter("%p", udp_sk);
-
-	if (unlikely(!local)) {
-		kfree_skb(skb);
-		return 0;
-	}
-	if (skb->tstamp == 0)
-		skb->tstamp = ktime_get_real();
-
-	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
-
-	skb_pull(skb, sizeof(struct udphdr));
-
-	/* The UDP protocol already released all skb resources;
-	 * we are free to add our own data there.
-	 */
-	sp = rxrpc_skb(skb);
-
-	/* dig out the RxRPC connection details */
-	if (rxrpc_extract_header(sp, skb) < 0)
-		goto bad_message;
-
-	if (IS_ENABLED(CONFIG_AF_RXRPC_INJECT_LOSS)) {
-		static int lose;
-		if ((lose++ & 7) == 7) {
-			trace_rxrpc_rx_lose(sp);
-			rxrpc_free_skb(skb, rxrpc_skb_put_lose);
-			return 0;
-		}
-	}
-
-	if (skb->tstamp == 0)
-		skb->tstamp = ktime_get_real();
-	trace_rxrpc_rx_packet(sp);
-
-	switch (sp->hdr.type) {
-	case RXRPC_PACKET_TYPE_VERSION:
-		if (rxrpc_to_client(sp))
-			goto discard;
-		rxrpc_post_packet_to_local(local, skb);
-		goto out;
-
-	case RXRPC_PACKET_TYPE_BUSY:
-		if (rxrpc_to_server(sp))
-			goto discard;
-		fallthrough;
-	case RXRPC_PACKET_TYPE_ACK:
-	case RXRPC_PACKET_TYPE_ACKALL:
-		if (sp->hdr.callNumber == 0)
-			goto bad_message;
-		break;
-	case RXRPC_PACKET_TYPE_ABORT:
-		if (!rxrpc_extract_abort(skb))
-			return true; /* Just discard if malformed */
-		break;
-
-	case RXRPC_PACKET_TYPE_DATA:
-		if (sp->hdr.callNumber == 0 ||
-		    sp->hdr.seq == 0)
-			goto bad_message;
-
-		/* Unshare the packet so that it can be modified for in-place
-		 * decryption.
-		 */
-		if (sp->hdr.securityIndex != 0) {
-			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
-			if (!nskb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
-				goto out;
-			}
-
-			if (nskb != skb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
-				skb = nskb;
-				rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
-				sp = rxrpc_skb(skb);
-			}
-		}
-		break;
-
-	case RXRPC_PACKET_TYPE_CHALLENGE:
-		if (rxrpc_to_server(sp))
-			goto discard;
-		break;
-	case RXRPC_PACKET_TYPE_RESPONSE:
-		if (rxrpc_to_client(sp))
-			goto discard;
-		break;
-
-		/* Packet types 9-11 should just be ignored. */
-	case RXRPC_PACKET_TYPE_PARAMS:
-	case RXRPC_PACKET_TYPE_10:
-	case RXRPC_PACKET_TYPE_11:
-		goto discard;
-
-	default:
-		goto bad_message;
-	}
-
-	if (sp->hdr.serviceId == 0)
-		goto bad_message;
-
-	if (rxrpc_to_server(sp)) {
-		/* Weed out packets to services we're not offering.  Packets
-		 * that would begin a call are explicitly rejected and the rest
-		 * are just discarded.
-		 */
-		rx = rcu_dereference(local->service);
-		if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
-			    sp->hdr.serviceId != rx->second_service)) {
-			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
-			    sp->hdr.seq == 1)
-				goto unsupported_service;
-			goto discard;
-		}
-	}
-
-	conn = rxrpc_find_connection_rcu(local, skb, &peer);
-	if (conn) {
-		if (sp->hdr.securityIndex != conn->security_ix)
-			goto wrong_security;
-
-		if (sp->hdr.serviceId != conn->service_id) {
-			int old_id;
-
-			if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
-				goto reupgrade;
-			old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
-					 sp->hdr.serviceId);
-
-			if (old_id != conn->orig_service_id &&
-			    old_id != sp->hdr.serviceId)
-				goto reupgrade;
-		}
-
-		if (sp->hdr.callNumber == 0) {
-			/* Connection-level packet */
-			_debug("CONN %p {%d}", conn, conn->debug_id);
-			rxrpc_post_packet_to_conn(conn, skb);
-			goto out;
-		}
-
-		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
-			conn->hi_serial = sp->hdr.serial;
-
-		/* Call-bound packets are routed by connection channel. */
-		channel = sp->hdr.cid & RXRPC_CHANNELMASK;
-		chan = &conn->channels[channel];
-
-		/* Ignore really old calls */
-		if (sp->hdr.callNumber < chan->last_call)
-			goto discard;
-
-		if (sp->hdr.callNumber == chan->last_call) {
-			if (chan->call ||
-			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
-				goto discard;
-
-			/* For the previous service call, if completed
-			 * successfully, we discard all further packets.
-			 */
-			if (rxrpc_conn_is_service(conn) &&
-			    chan->last_type == RXRPC_PACKET_TYPE_ACK)
-				goto discard;
-
-			/* But otherwise we need to retransmit the final packet
-			 * from data cached in the connection record.
-			 */
-			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA)
-				trace_rxrpc_rx_data(chan->call_debug_id,
-						    sp->hdr.seq,
-						    sp->hdr.serial,
-						    sp->hdr.flags);
-			rxrpc_post_packet_to_conn(conn, skb);
-			goto out;
-		}
-
-		call = rcu_dereference(chan->call);
-
-		if (sp->hdr.callNumber > chan->call_id) {
-			if (rxrpc_to_client(sp))
-				goto reject_packet;
-			if (call)
-				rxrpc_input_implicit_end_call(rx, conn, call);
-			call = NULL;
-		}
-
-		if (call) {
-			if (sp->hdr.serviceId != call->service_id)
-				call->service_id = sp->hdr.serviceId;
-			if ((int)sp->hdr.serial - (int)call->rx_serial > 0)
-				call->rx_serial = sp->hdr.serial;
-			if (!test_bit(RXRPC_CALL_RX_HEARD, &call->flags))
-				set_bit(RXRPC_CALL_RX_HEARD, &call->flags);
-		}
-	}
-
-	if (!call || refcount_read(&call->ref) == 0) {
-		if (rxrpc_to_client(sp) ||
-		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
-			goto bad_message;
-		if (sp->hdr.seq != 1)
-			goto discard;
-		call = rxrpc_new_incoming_call(local, rx, skb);
-		if (!call)
-			goto reject_packet;
-	}
-
-	/* Process a call packet; this either discards or passes on the ref
-	 * elsewhere.
-	 */
-	rxrpc_input_call_packet(call, skb);
-	goto out;
-
-discard:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-out:
-	trace_rxrpc_rx_done(0, 0);
-	return 0;
-
-wrong_security:
-	trace_rxrpc_abort(0, "SEC", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RXKADINCONSISTENCY, EBADMSG);
-	skb->priority = RXKADINCONSISTENCY;
-	goto post_abort;
-
-unsupported_service:
-	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_INVALID_OPERATION, EOPNOTSUPP);
-	skb->priority = RX_INVALID_OPERATION;
-	goto post_abort;
-
-reupgrade:
-	trace_rxrpc_abort(0, "UPG", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_PROTOCOL_ERROR, EBADMSG);
-	goto protocol_error;
-
-bad_message:
-	trace_rxrpc_abort(0, "BAD", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_PROTOCOL_ERROR, EBADMSG);
-protocol_error:
-	skb->priority = RX_PROTOCOL_ERROR;
-post_abort:
-	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-reject_packet:
-	trace_rxrpc_rx_done(skb->mark, skb->priority);
-	rxrpc_reject_packet(local, skb);
-	_leave(" [badmsg]");
-	return 0;
-}
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
new file mode 100644
index 000000000000..d2aaad5afa1d
--- /dev/null
+++ b/net/rxrpc/io_thread.c
@@ -0,0 +1,370 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxRPC packet reception
+ *
+ * Copyright (C) 2007, 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "ar-internal.h"
+
+/*
+ * post connection-level events to the connection
+ * - this includes challenges, responses, some aborts and call terminal packet
+ *   retransmission.
+ */
+static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
+				      struct sk_buff *skb)
+{
+	_enter("%p,%p", conn, skb);
+
+	skb_queue_tail(&conn->rx_queue, skb);
+	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
+}
+
+/*
+ * post endpoint-level events to the local endpoint
+ * - this includes debug and version messages
+ */
+static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
+				       struct sk_buff *skb)
+{
+	_enter("%p,%p", local, skb);
+
+	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
+		skb_queue_tail(&local->event_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
+	}
+}
+
+/*
+ * put a packet up for transport-level abort
+ */
+static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
+{
+	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
+		skb_queue_tail(&local->reject_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
+	}
+}
+
+/*
+ * Extract the wire header from a packet and translate the byte order.
+ */
+static noinline
+int rxrpc_extract_header(struct rxrpc_skb_priv *sp, struct sk_buff *skb)
+{
+	struct rxrpc_wire_header whdr;
+
+	/* dig out the RxRPC connection details */
+	if (skb_copy_bits(skb, 0, &whdr, sizeof(whdr)) < 0) {
+		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
+				      tracepoint_string("bad_hdr"));
+		return -EBADMSG;
+	}
+
+	memset(sp, 0, sizeof(*sp));
+	sp->hdr.epoch		= ntohl(whdr.epoch);
+	sp->hdr.cid		= ntohl(whdr.cid);
+	sp->hdr.callNumber	= ntohl(whdr.callNumber);
+	sp->hdr.seq		= ntohl(whdr.seq);
+	sp->hdr.serial		= ntohl(whdr.serial);
+	sp->hdr.flags		= whdr.flags;
+	sp->hdr.type		= whdr.type;
+	sp->hdr.userStatus	= whdr.userStatus;
+	sp->hdr.securityIndex	= whdr.securityIndex;
+	sp->hdr._rsvd		= ntohs(whdr._rsvd);
+	sp->hdr.serviceId	= ntohs(whdr.serviceId);
+	return 0;
+}
+
+/*
+ * Extract the abort code from an ABORT packet and stash it in skb->priority.
+ */
+static bool rxrpc_extract_abort(struct sk_buff *skb)
+{
+	__be32 wtmp;
+
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
+			  &wtmp, sizeof(wtmp)) < 0)
+		return false;
+	skb->priority = ntohl(wtmp);
+	return true;
+}
+
+/*
+ * handle data received on the local endpoint
+ * - may be called in interrupt context
+ *
+ * [!] Note that as this is called from the encap_rcv hook, the socket is not
+ * held locked by the caller and nothing prevents sk_user_data on the UDP from
+ * being cleared in the middle of processing this function.
+ *
+ * Called with the RCU read lock held from the IP layer via UDP.
+ */
+int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
+{
+	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
+	struct rxrpc_connection *conn;
+	struct rxrpc_channel *chan;
+	struct rxrpc_call *call = NULL;
+	struct rxrpc_skb_priv *sp;
+	struct rxrpc_peer *peer = NULL;
+	struct rxrpc_sock *rx = NULL;
+	unsigned int channel;
+
+	_enter("%p", udp_sk);
+
+	if (unlikely(!local)) {
+		kfree_skb(skb);
+		return 0;
+	}
+	if (skb->tstamp == 0)
+		skb->tstamp = ktime_get_real();
+
+	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
+
+	skb_pull(skb, sizeof(struct udphdr));
+
+	/* The UDP protocol already released all skb resources;
+	 * we are free to add our own data there.
+	 */
+	sp = rxrpc_skb(skb);
+
+	/* dig out the RxRPC connection details */
+	if (rxrpc_extract_header(sp, skb) < 0)
+		goto bad_message;
+
+	if (IS_ENABLED(CONFIG_AF_RXRPC_INJECT_LOSS)) {
+		static int lose;
+		if ((lose++ & 7) == 7) {
+			trace_rxrpc_rx_lose(sp);
+			rxrpc_free_skb(skb, rxrpc_skb_put_lose);
+			return 0;
+		}
+	}
+
+	if (skb->tstamp == 0)
+		skb->tstamp = ktime_get_real();
+	trace_rxrpc_rx_packet(sp);
+
+	switch (sp->hdr.type) {
+	case RXRPC_PACKET_TYPE_VERSION:
+		if (rxrpc_to_client(sp))
+			goto discard;
+		rxrpc_post_packet_to_local(local, skb);
+		goto out;
+
+	case RXRPC_PACKET_TYPE_BUSY:
+		if (rxrpc_to_server(sp))
+			goto discard;
+		fallthrough;
+	case RXRPC_PACKET_TYPE_ACK:
+	case RXRPC_PACKET_TYPE_ACKALL:
+		if (sp->hdr.callNumber == 0)
+			goto bad_message;
+		break;
+	case RXRPC_PACKET_TYPE_ABORT:
+		if (!rxrpc_extract_abort(skb))
+			return true; /* Just discard if malformed */
+		break;
+
+	case RXRPC_PACKET_TYPE_DATA:
+		if (sp->hdr.callNumber == 0 ||
+		    sp->hdr.seq == 0)
+			goto bad_message;
+
+		/* Unshare the packet so that it can be modified for in-place
+		 * decryption.
+		 */
+		if (sp->hdr.securityIndex != 0) {
+			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
+			if (!nskb) {
+				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
+				goto out;
+			}
+
+			if (nskb != skb) {
+				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
+				skb = nskb;
+				rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
+				sp = rxrpc_skb(skb);
+			}
+		}
+		break;
+
+	case RXRPC_PACKET_TYPE_CHALLENGE:
+		if (rxrpc_to_server(sp))
+			goto discard;
+		break;
+	case RXRPC_PACKET_TYPE_RESPONSE:
+		if (rxrpc_to_client(sp))
+			goto discard;
+		break;
+
+		/* Packet types 9-11 should just be ignored. */
+	case RXRPC_PACKET_TYPE_PARAMS:
+	case RXRPC_PACKET_TYPE_10:
+	case RXRPC_PACKET_TYPE_11:
+		goto discard;
+
+	default:
+		goto bad_message;
+	}
+
+	if (sp->hdr.serviceId == 0)
+		goto bad_message;
+
+	if (rxrpc_to_server(sp)) {
+		/* Weed out packets to services we're not offering.  Packets
+		 * that would begin a call are explicitly rejected and the rest
+		 * are just discarded.
+		 */
+		rx = rcu_dereference(local->service);
+		if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
+			    sp->hdr.serviceId != rx->second_service)) {
+			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
+			    sp->hdr.seq == 1)
+				goto unsupported_service;
+			goto discard;
+		}
+	}
+
+	conn = rxrpc_find_connection_rcu(local, skb, &peer);
+	if (conn) {
+		if (sp->hdr.securityIndex != conn->security_ix)
+			goto wrong_security;
+
+		if (sp->hdr.serviceId != conn->service_id) {
+			int old_id;
+
+			if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
+				goto reupgrade;
+			old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
+					 sp->hdr.serviceId);
+
+			if (old_id != conn->orig_service_id &&
+			    old_id != sp->hdr.serviceId)
+				goto reupgrade;
+		}
+
+		if (sp->hdr.callNumber == 0) {
+			/* Connection-level packet */
+			_debug("CONN %p {%d}", conn, conn->debug_id);
+			rxrpc_post_packet_to_conn(conn, skb);
+			goto out;
+		}
+
+		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
+			conn->hi_serial = sp->hdr.serial;
+
+		/* Call-bound packets are routed by connection channel. */
+		channel = sp->hdr.cid & RXRPC_CHANNELMASK;
+		chan = &conn->channels[channel];
+
+		/* Ignore really old calls */
+		if (sp->hdr.callNumber < chan->last_call)
+			goto discard;
+
+		if (sp->hdr.callNumber == chan->last_call) {
+			if (chan->call ||
+			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
+				goto discard;
+
+			/* For the previous service call, if completed
+			 * successfully, we discard all further packets.
+			 */
+			if (rxrpc_conn_is_service(conn) &&
+			    chan->last_type == RXRPC_PACKET_TYPE_ACK)
+				goto discard;
+
+			/* But otherwise we need to retransmit the final packet
+			 * from data cached in the connection record.
+			 */
+			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA)
+				trace_rxrpc_rx_data(chan->call_debug_id,
+						    sp->hdr.seq,
+						    sp->hdr.serial,
+						    sp->hdr.flags);
+			rxrpc_post_packet_to_conn(conn, skb);
+			goto out;
+		}
+
+		call = rcu_dereference(chan->call);
+
+		if (sp->hdr.callNumber > chan->call_id) {
+			if (rxrpc_to_client(sp))
+				goto reject_packet;
+			if (call)
+				rxrpc_input_implicit_end_call(rx, conn, call);
+			call = NULL;
+		}
+
+		if (call) {
+			if (sp->hdr.serviceId != call->service_id)
+				call->service_id = sp->hdr.serviceId;
+			if ((int)sp->hdr.serial - (int)call->rx_serial > 0)
+				call->rx_serial = sp->hdr.serial;
+			if (!test_bit(RXRPC_CALL_RX_HEARD, &call->flags))
+				set_bit(RXRPC_CALL_RX_HEARD, &call->flags);
+		}
+	}
+
+	if (!call || refcount_read(&call->ref) == 0) {
+		if (rxrpc_to_client(sp) ||
+		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
+			goto bad_message;
+		if (sp->hdr.seq != 1)
+			goto discard;
+		call = rxrpc_new_incoming_call(local, rx, skb);
+		if (!call)
+			goto reject_packet;
+	}
+
+	/* Process a call packet; this either discards or passes on the ref
+	 * elsewhere.
+	 */
+	rxrpc_input_call_packet(call, skb);
+	goto out;
+
+discard:
+	rxrpc_free_skb(skb, rxrpc_skb_put_input);
+out:
+	trace_rxrpc_rx_done(0, 0);
+	return 0;
+
+wrong_security:
+	trace_rxrpc_abort(0, "SEC", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RXKADINCONSISTENCY, EBADMSG);
+	skb->priority = RXKADINCONSISTENCY;
+	goto post_abort;
+
+unsupported_service:
+	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RX_INVALID_OPERATION, EOPNOTSUPP);
+	skb->priority = RX_INVALID_OPERATION;
+	goto post_abort;
+
+reupgrade:
+	trace_rxrpc_abort(0, "UPG", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RX_PROTOCOL_ERROR, EBADMSG);
+	goto protocol_error;
+
+bad_message:
+	trace_rxrpc_abort(0, "BAD", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RX_PROTOCOL_ERROR, EBADMSG);
+protocol_error:
+	skb->priority = RX_PROTOCOL_ERROR;
+post_abort:
+	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+reject_packet:
+	trace_rxrpc_rx_done(skb->mark, skb->priority);
+	rxrpc_reject_packet(local, skb);
+	_leave(" [badmsg]");
+	return 0;
+}


