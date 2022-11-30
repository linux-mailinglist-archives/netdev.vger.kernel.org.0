Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B336163DB5C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiK3RCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiK3RCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:02:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE848DBD6
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8gv5FwlfBLk2h9FYCfGchxbHxe+R+fxfyI8Nu42mz8=;
        b=eWOY49mhCjPemKsSTobxmW2HN9iy/V2U7P4UVHDzV2DjlGRdCPBRc00o2/ALaZ/fiMZk03
        owssrqPy/u+T9APQ1tt/AyXH/+QVVFEZl2hxnDp5LCuYVq8ewmyd4xx7CTzEdOXJm9EPR9
        9kzAHUo7wif8tViggvtrVjJsG3dCxDE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-TBpe4EGtM2KSG1lg2_cddg-1; Wed, 30 Nov 2022 11:58:15 -0500
X-MC-Unique: TBpe4EGtM2KSG1lg2_cddg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 288AC101E14C;
        Wed, 30 Nov 2022 16:58:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5099540C6EC4;
        Wed, 30 Nov 2022 16:58:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 27/35] rxrpc: Simplify skbuff accounting in receive
 path
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:58:11 +0000
Message-ID: <166982749155.621383.2075555283515135651.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
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

A received skbuff needs a ref when it gets put on a call data queue or conn
packet queue, and rxrpc_input_packet() and co. jump through a lot of hoops
to avoid double-dropping the skbuff ref so that we can avoid getting a ref
when we queue the packet.

Change this so that the skbuff ref is unconditionally dropped by the caller
of rxrpc_input_packet().  An additional ref is then taken on the packet if
it is pushed onto a queue.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    3 +-
 net/rxrpc/input.c            |   45 +++++++++++++--------------
 net/rxrpc/io_thread.c        |   70 +++++++++++++++++++-----------------------
 3 files changed, 56 insertions(+), 62 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index c3043fbea0e6..82b1327c2ba6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -28,6 +28,8 @@
 	EM(rxrpc_skb_eaten_by_unshare_nomem,	"ETN unshar-nm") \
 	EM(rxrpc_skb_get_ack,			"GET ack      ") \
 	EM(rxrpc_skb_get_conn_work,		"GET conn-work") \
+	EM(rxrpc_skb_get_local_work,		"GET locl-work") \
+	EM(rxrpc_skb_get_reject_work,		"GET rej-work ") \
 	EM(rxrpc_skb_get_to_recvmsg,		"GET to-recv  ") \
 	EM(rxrpc_skb_get_to_recvmsg_oos,	"GET to-recv-o") \
 	EM(rxrpc_skb_new_encap_rcv,		"NEW encap-rcv") \
@@ -39,7 +41,6 @@
 	EM(rxrpc_skb_put_error_report,		"PUT error-rep") \
 	EM(rxrpc_skb_put_input,			"PUT input    ") \
 	EM(rxrpc_skb_put_jumbo_subpacket,	"PUT jumbo-sub") \
-	EM(rxrpc_skb_put_lose,			"PUT lose     ") \
 	EM(rxrpc_skb_put_purge,			"PUT purge    ") \
 	EM(rxrpc_skb_put_rotate,		"PUT rotate   ") \
 	EM(rxrpc_skb_put_unknown,		"PUT unknown  ") \
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 036f02371051..42addbcf59f9 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -338,7 +338,8 @@ static void rxrpc_input_queue_data(struct rxrpc_call *call, struct sk_buff *skb,
 /*
  * Process a DATA packet.
  */
-static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
+static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
+				 bool *_notify)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct sk_buff *oos;
@@ -361,7 +362,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 		if (test_and_set_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
 		    seq + 1 != wtop) {
 			rxrpc_proto_abort("LSN", call, seq);
-			goto err_free;
+			return;
 		}
 	} else {
 		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
@@ -369,7 +370,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 			pr_warn("Packet beyond last: c=%x q=%x window=%x-%x wlimit=%x\n",
 				call->debug_id, seq, window, wtop, wlimit);
 			rxrpc_proto_abort("LSA", call, seq);
-			goto err_free;
+			return;
 		}
 	}
 
@@ -402,9 +403,11 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 		if (after(window, wtop))
 			wtop = window;
 
+		rxrpc_get_skb(skb, rxrpc_skb_get_to_recvmsg);
+
 		spin_lock(&call->recvmsg_queue.lock);
 		rxrpc_input_queue_data(call, skb, window, wtop, rxrpc_receive_queue);
-		skb = NULL;
+		*_notify = true;
 
 		while ((oos = skb_peek(&call->rx_oos_queue))) {
 			struct rxrpc_skb_priv *osp = rxrpc_skb(oos);
@@ -456,16 +459,17 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 			struct rxrpc_skb_priv *osp = rxrpc_skb(oos);
 
 			if (after(osp->hdr.seq, seq)) {
+				rxrpc_get_skb(skb, rxrpc_skb_get_to_recvmsg_oos);
 				__skb_queue_before(&call->rx_oos_queue, oos, skb);
 				goto oos_queued;
 			}
 		}
 
+		rxrpc_get_skb(skb, rxrpc_skb_get_to_recvmsg_oos);
 		__skb_queue_tail(&call->rx_oos_queue, skb);
 	oos_queued:
 		trace_rxrpc_receive(call, last ? rxrpc_receive_oos_last : rxrpc_receive_oos,
 				    sp->hdr.serial, sp->hdr.seq);
-		skb = NULL;
 	}
 
 send_ack:
@@ -483,9 +487,6 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 	else
 		rxrpc_propose_delay_ACK(call, serial,
 					rxrpc_propose_ack_input_data);
-
-err_free:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 }
 
 /*
@@ -498,6 +499,7 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 	struct sk_buff *jskb;
 	unsigned int offset = sizeof(struct rxrpc_wire_header);
 	unsigned int len = skb->len - offset;
+	bool notify = false;
 
 	while (sp->hdr.flags & RXRPC_JUMBO_PACKET) {
 		if (len < RXRPC_JUMBO_SUBPKTLEN)
@@ -517,7 +519,8 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 		jsp = rxrpc_skb(jskb);
 		jsp->offset = offset;
 		jsp->len = RXRPC_JUMBO_DATALEN;
-		rxrpc_input_data_one(call, jskb);
+		rxrpc_input_data_one(call, jskb, &notify);
+		rxrpc_free_skb(jskb, rxrpc_skb_put_jumbo_subpacket);
 
 		sp->hdr.flags = jhdr.flags;
 		sp->hdr._rsvd = ntohs(jhdr._rsvd);
@@ -529,7 +532,11 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 
 	sp->offset = offset;
 	sp->len    = len;
-	rxrpc_input_data_one(call, skb);
+	rxrpc_input_data_one(call, skb, &notify);
+	if (notify) {
+		trace_rxrpc_notify_socket(call->debug_id, sp->hdr.serial);
+		rxrpc_notify_socket(call);
+	}
 	return true;
 
 protocol_error:
@@ -552,10 +559,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	       skb->len, seq0);
 
 	state = READ_ONCE(call->state);
-	if (state >= RXRPC_CALL_COMPLETE) {
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
+	if (state >= RXRPC_CALL_COMPLETE)
 		return;
-	}
 
 	/* Unshare the packet so that it can be modified for in-place
 	 * decryption.
@@ -605,7 +610,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 out:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	_leave(" [queued]");
 }
 
@@ -797,7 +801,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	struct rxrpc_ackpacket ack;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_ackinfo info;
-	struct sk_buff *skb_old = NULL, *skb_put = skb;
+	struct sk_buff *skb_old = NULL;
 	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
@@ -963,6 +967,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 			goto out;
 		}
 
+		rxrpc_get_skb(skb, rxrpc_skb_get_ack);
 		spin_lock(&call->acks_ack_lock);
 		skb_old = call->acks_soft_tbl;
 		call->acks_soft_tbl = skb;
@@ -970,7 +975,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 		rxrpc_input_soft_acks(call, skb->data + offset, first_soft_ack,
 				      nr_acks, &summary);
-		skb_put = NULL;
 	} else if (call->acks_soft_tbl) {
 		spin_lock(&call->acks_ack_lock);
 		skb_old = call->acks_soft_tbl;
@@ -986,7 +990,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
 out:
-	rxrpc_free_skb(skb_put, rxrpc_skb_put_input);
 	rxrpc_free_skb(skb_old, rxrpc_skb_put_ack);
 }
 
@@ -1037,11 +1040,11 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_DATA:
 		rxrpc_input_data(call, skb);
-		goto no_free;
+		break;
 
 	case RXRPC_PACKET_TYPE_ACK:
 		rxrpc_input_ack(call, skb);
-		goto no_free;
+		break;
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets from the server; the retry and
@@ -1061,10 +1064,6 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	default:
 		break;
 	}
-
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-no_free:
-	_leave("");
 }
 
 /*
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 2119941b6d6c..91b8ba5b90db 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -72,6 +72,7 @@ static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
 {
 	_enter("%p,%p", conn, skb);
 
+	rxrpc_get_skb(skb, rxrpc_skb_get_conn_work);
 	skb_queue_tail(&conn->rx_queue, skb);
 	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
 }
@@ -86,10 +87,9 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 	_enter("%p,%p", local, skb);
 
 	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
+		rxrpc_get_skb(skb, rxrpc_skb_get_local_work);
 		skb_queue_tail(&local->event_queue, skb);
 		rxrpc_queue_local(local);
-	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 }
 
@@ -99,10 +99,9 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
 	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
+		rxrpc_get_skb(skb, rxrpc_skb_get_reject_work);
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
-	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 }
 
@@ -153,7 +152,7 @@ static bool rxrpc_extract_abort(struct sk_buff *skb)
 /*
  * Process packets received on the local endpoint
  */
-static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
+static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan;
@@ -161,6 +160,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_peer *peer = NULL;
 	struct rxrpc_sock *rx = NULL;
+	struct sk_buff *skb = *_skb;
 	unsigned int channel;
 
 	if (skb->tstamp == 0)
@@ -181,7 +181,6 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			trace_rxrpc_rx_lose(sp);
-			rxrpc_free_skb(skb, rxrpc_skb_put_lose);
 			return 0;
 		}
 	}
@@ -193,13 +192,13 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_VERSION:
 		if (rxrpc_to_client(sp))
-			goto discard;
+			return 0;
 		rxrpc_post_packet_to_local(local, skb);
-		goto out;
+		return 0;
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		if (rxrpc_to_server(sp))
-			goto discard;
+			return 0;
 		fallthrough;
 	case RXRPC_PACKET_TYPE_ACK:
 	case RXRPC_PACKET_TYPE_ACKALL:
@@ -208,7 +207,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		break;
 	case RXRPC_PACKET_TYPE_ABORT:
 		if (!rxrpc_extract_abort(skb))
-			return true; /* Just discard if malformed */
+			return 0; /* Just discard if malformed */
 		break;
 
 	case RXRPC_PACKET_TYPE_DATA:
@@ -220,15 +219,16 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		 * decryption.
 		 */
 		if (sp->hdr.securityIndex != 0) {
-			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
-			if (!nskb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
-				goto out;
+			skb = skb_unshare(skb, GFP_ATOMIC);
+			if (!skb) {
+				rxrpc_eaten_skb(*_skb, rxrpc_skb_eaten_by_unshare_nomem);
+				*_skb = NULL;
+				return 0;
 			}
 
-			if (nskb != skb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
-				skb = nskb;
+			if (skb != *_skb) {
+				rxrpc_eaten_skb(*_skb, rxrpc_skb_eaten_by_unshare);
+				*_skb = skb;
 				rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
 				sp = rxrpc_skb(skb);
 			}
@@ -237,18 +237,18 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
 		if (rxrpc_to_server(sp))
-			goto discard;
+			return 0;
 		break;
 	case RXRPC_PACKET_TYPE_RESPONSE:
 		if (rxrpc_to_client(sp))
-			goto discard;
+			return 0;
 		break;
 
 		/* Packet types 9-11 should just be ignored. */
 	case RXRPC_PACKET_TYPE_PARAMS:
 	case RXRPC_PACKET_TYPE_10:
 	case RXRPC_PACKET_TYPE_11:
-		goto discard;
+		return 0;
 
 	default:
 		goto bad_message;
@@ -268,7 +268,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
 			    sp->hdr.seq == 1)
 				goto unsupported_service;
-			goto discard;
+			return 0;
 		}
 	}
 
@@ -294,7 +294,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 			/* Connection-level packet */
 			_debug("CONN %p {%d}", conn, conn->debug_id);
 			rxrpc_post_packet_to_conn(conn, skb);
-			goto out;
+			return 0;
 		}
 
 		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
@@ -306,19 +306,19 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 
 		/* Ignore really old calls */
 		if (sp->hdr.callNumber < chan->last_call)
-			goto discard;
+			return 0;
 
 		if (sp->hdr.callNumber == chan->last_call) {
 			if (chan->call ||
 			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
-				goto discard;
+				return 0;
 
 			/* For the previous service call, if completed
 			 * successfully, we discard all further packets.
 			 */
 			if (rxrpc_conn_is_service(conn) &&
 			    chan->last_type == RXRPC_PACKET_TYPE_ACK)
-				goto discard;
+				return 0;
 
 			/* But otherwise we need to retransmit the final packet
 			 * from data cached in the connection record.
@@ -329,7 +329,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 						    sp->hdr.serial,
 						    sp->hdr.flags);
 			rxrpc_post_packet_to_conn(conn, skb);
-			goto out;
+			return 0;
 		}
 
 		call = rcu_dereference(chan->call);
@@ -357,21 +357,14 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 			goto bad_message;
 		if (sp->hdr.seq != 1)
-			goto discard;
+			return 0;
 		call = rxrpc_new_incoming_call(local, rx, skb);
 		if (!call)
 			goto reject_packet;
 	}
 
-	/* Process a call packet; this either discards or passes on the ref
-	 * elsewhere.
-	 */
+	/* Process a call packet. */
 	rxrpc_input_call_event(call, skb);
-	goto out;
-
-discard:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-out:
 	trace_rxrpc_rx_done(0, 0);
 	return 0;
 
@@ -400,9 +393,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 post_abort:
 	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
 reject_packet:
-	trace_rxrpc_rx_done(skb->mark, skb->priority);
 	rxrpc_reject_packet(local, skb);
-	_leave(" [badmsg]");
 	return 0;
 }
 
@@ -441,9 +432,12 @@ int rxrpc_io_thread(void *data)
 		if ((skb = __skb_dequeue(&rx_queue))) {
 			switch (skb->mark) {
 			case RXRPC_SKB_MARK_PACKET:
+				skb->priority = 0;
 				rcu_read_lock();
-				rxrpc_input_packet(local, skb);
+				rxrpc_input_packet(local, &skb);
 				rcu_read_unlock();
+				trace_rxrpc_rx_done(skb->mark, skb->priority);
+				rxrpc_free_skb(skb, rxrpc_skb_put_input);
 				break;
 			case RXRPC_SKB_MARK_ERROR:
 				rxrpc_input_error(local, skb);


