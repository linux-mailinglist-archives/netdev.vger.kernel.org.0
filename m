Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37940635A02
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbiKWKfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237424AbiKWKdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:33:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E981E931F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jujokCm9ZCdUrsabhCBwrV7pKAC580GzONpRlqVFKSc=;
        b=JAATqUBKl1ZIw10gJpwb2rmajrqmOXa6SaSUezpDp0sRudYpy3Q/keUVl3s9fmP58J9aZb
        PN4f8Mv+fVGKF4KuQ4PnPuAZ4umL7FPEEC1IC/9OlTjZ1Wkyw7eEKIrBnDEs7DotDdJH0M
        CZbFvENY9s44tSG5O5DFobHMqtrN1Gs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-p6pJfQinMGKNIa4aXh1H9g-1; Wed, 23 Nov 2022 05:16:44 -0500
X-MC-Unique: p6pJfQinMGKNIa4aXh1H9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66627101A52A;
        Wed, 23 Nov 2022 10:16:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F9461415114;
        Wed, 23 Nov 2022 10:16:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/17] rxrpc: Simplify skbuff accounting in receive
 path
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:16:41 +0000
Message-ID: <166919860100.1258552.15729597701045182558.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

 include/trace/events/rxrpc.h |    1 -
 net/rxrpc/conn_event.c       |    5 +----
 net/rxrpc/input.c            |   38 +++++++++++++++++++-------------------
 net/rxrpc/io_thread.c        |   40 ++++++++++++++++------------------------
 net/rxrpc/output.c           |    6 +-----
 5 files changed, 37 insertions(+), 53 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 3ecacc12fe90..33fb8d2a4de6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -37,7 +37,6 @@
 	EM(rxrpc_skb_put_error_report,		"PUT error-rep") \
 	EM(rxrpc_skb_put_input,			"PUT input    ") \
 	EM(rxrpc_skb_put_jumbo_subpacket,	"PUT jumbo-sub") \
-	EM(rxrpc_skb_put_lose,			"PUT lose     ") \
 	EM(rxrpc_skb_put_purge,			"PUT purge    ") \
 	EM(rxrpc_skb_put_rotate,		"PUT rotate   ") \
 	EM(rxrpc_skb_put_unknown,		"PUT unknown  ") \
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 6f376e4e94bc..78f91303a4a8 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -494,6 +494,7 @@ static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
 {
 	_enter("%p,%p", conn, skb);
 
+	rxrpc_get_skb(skb, rxrpc_skb_get_conn_work);
 	skb_queue_tail(&conn->rx_queue, skb);
 	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
 }
@@ -517,12 +518,10 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 	case RXRPC_PACKET_TYPE_ACK:
 		rxrpc_conn_retransmit_call(conn, skb,
 					   sp->hdr.cid & RXRPC_CHANNELMASK);
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 		return 0;
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets for now. */
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 		return 0;
 
 	case RXRPC_PACKET_TYPE_ABORT:
@@ -531,7 +530,6 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
 		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 		return -ECONNABORTED;
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
@@ -542,7 +540,6 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 	default:
 		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
 				      tracepoint_string("bad_conn_pkt"));
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 		return -EPROTO;
 	}
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index f5a3b1e4f284..70f54976c820 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -344,7 +344,8 @@ static void rxrpc_input_queue_data(struct rxrpc_call *call, struct sk_buff *skb,
 /*
  * Process a DATA packet.
  */
-static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
+static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
+				 bool *_notify)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct sk_buff *oos;
@@ -367,7 +368,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 		if (test_and_set_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
 		    seq + 1 != wtop) {
 			rxrpc_proto_abort("LSN", call, seq);
-			goto err_free;
+			return;
 		}
 	} else {
 		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
@@ -375,7 +376,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 			pr_warn("Packet beyond last: c=%x q=%x window=%x-%x wlimit=%x\n",
 				call->debug_id, seq, window, wtop, wlimit);
 			rxrpc_proto_abort("LSA", call, seq);
-			goto err_free;
+			return;
 		}
 	}
 
@@ -410,9 +411,11 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
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
@@ -464,16 +467,17 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
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
@@ -553,7 +560,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE)
-		goto out;
+		return;
 
 	/* Unshare the packet so that it can be modified for in-place
 	 * decryption.
@@ -603,9 +610,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 out_notify:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
-out:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-	_leave(" [queued]");
 }
 
 /*
@@ -975,7 +979,7 @@ void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_DATA:
 		rxrpc_input_data(call, skb);
-		goto no_free;
+		break;
 
 	case RXRPC_PACKET_TYPE_ACK:
 		rxrpc_input_ack(call, skb);
@@ -999,10 +1003,6 @@ void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
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
index fbb809967bf1..1ea39ff33841 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -77,8 +77,6 @@ static void rxrpc_input_version(struct rxrpc_local *local, struct sk_buff *skb)
 		if (v == 0)
 			rxrpc_send_version_request(local, &sp->hdr, skb);
 	}
-
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 }
 
 /*
@@ -150,7 +148,6 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			trace_rxrpc_rx_lose(sp);
-			rxrpc_free_skb(skb, rxrpc_skb_put_lose);
 			return 0;
 		}
 	}
@@ -160,13 +157,13 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_VERSION:
 		if (rxrpc_to_client(sp))
-			goto discard;
+			return 0;
 		rxrpc_input_version(local, skb);
-		goto out;
+		return 0;
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		if (rxrpc_to_server(sp))
-			goto discard;
+			return 0;
 		fallthrough;
 	case RXRPC_PACKET_TYPE_ACK:
 	case RXRPC_PACKET_TYPE_ACKALL:
@@ -186,18 +183,18 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 
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
@@ -217,7 +214,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
 			    sp->hdr.seq == 1)
 				goto unsupported_service;
-			goto discard;
+			return 0;
 		}
 	}
 
@@ -243,7 +240,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 			/* Connection-level packet */
 			_debug("CONN %p {%d}", conn, conn->debug_id);
 			rxrpc_input_conn_packet(conn, skb);
-			goto out;
+			return 0;
 		}
 
 		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
@@ -255,19 +252,19 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 
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
@@ -278,7 +275,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 						    sp->hdr.serial,
 						    sp->hdr.flags);
 			rxrpc_input_conn_packet(conn, skb);
-			goto out;
+			return 0;
 		}
 
 		call = rcu_dereference(chan->call);
@@ -299,7 +296,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 			goto bad_message;
 		if (sp->hdr.seq != 1)
-			goto discard;
+			return 0;
 		call = rxrpc_new_incoming_call(local, rx, skb);
 		if (!call)
 			goto reject_packet;
@@ -313,12 +310,6 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	rcu_read_unlock();
 	rxrpc_input_call_event(call, skb);
 	rcu_read_lock();
-	goto out;
-
-discard:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-out:
-	trace_rxrpc_rx_done(0, 0);
 	return 0;
 
 wrong_security:
@@ -346,9 +337,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 post_abort:
 	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
 reject_packet:
-	trace_rxrpc_rx_done(skb->mark, skb->priority);
 	rxrpc_reject_packet(local, skb);
-	_leave(" [badmsg]");
 	return 0;
 }
 
@@ -387,9 +376,12 @@ int rxrpc_io_thread(void *data)
 		if ((skb = __skb_dequeue(&rx_queue))) {
 			switch (skb->mark) {
 			case RXRPC_SKB_MARK_PACKET:
+				skb->priority = 0;
 				rcu_read_lock();
 				rxrpc_input_packet(local, skb);
 				rcu_read_unlock();
+				trace_rxrpc_rx_done(skb->mark, skb->priority);
+				rxrpc_free_skb(skb, rxrpc_skb_put_input);
 				break;
 			case RXRPC_SKB_MARK_ERROR:
 				rxrpc_input_error(local, skb);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 9eb877f90433..0b5159dff995 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -585,7 +585,7 @@ void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		ioc = 2;
 		break;
 	default:
-		goto out;
+		return;
 	}
 
 	if (rxrpc_extract_addr_from_skb(&srx, skb) == 0) {
@@ -608,10 +608,6 @@ void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 			trace_rxrpc_tx_packet(local->debug_id, &whdr,
 					      rxrpc_tx_point_reject);
 	}
-
-out:
-	rxrpc_free_skb(skb, rxrpc_skb_put_input);
-	_leave("");
 }
 
 /*


