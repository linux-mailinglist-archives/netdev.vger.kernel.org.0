Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49FD635A2E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiKWKc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiKWKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:31:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE64B87C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9mJ16F1LXHE7/A7g+bp3rBTMz8mJ+OYg0I7SG7qAddk=;
        b=WJZyDW7cRbxXCxPu2rBL91fcMUIOOSHhNWXnwiufxu/EKXFFmNQhl9Womo5B9YHlkj3wAr
        3uwjVenpezhK62RRcUWWoILGvF1ge5JWiHtfxQuJWdae87p/lgjRoDtomliKLCZE8F4WdT
        GpXlP0xoe7OTYr0mVeXSgyOMM6GbvP4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-W26ogKzQO5qkw0dwl9Y1Rw-1; Wed, 23 Nov 2022 05:14:53 -0500
X-MC-Unique: W26ogKzQO5qkw0dwl9Y1Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 460C5101A588;
        Wed, 23 Nov 2022 10:14:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87CD540C83BB;
        Wed, 23 Nov 2022 10:14:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 03/17] rxrpc: Move packet reception processing into
 I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:14:49 +0000
Message-ID: <166919848997.1258552.4296758486396315780.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the packet input handler to make the softirq side just dump the
received packet into the local endpoint receive queue and then call the
remainder of the input function from the I/O thread.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |    3 ++
 net/rxrpc/call_event.c   |    4 ++-
 net/rxrpc/call_object.c  |    2 +-
 net/rxrpc/io_thread.c    |   61 +++++++++++++++++++++++++++++++---------------
 net/rxrpc/local_object.c |    2 +-
 5 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c6bf41b811b0..46bf98b9ef22 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -36,6 +36,7 @@ struct rxrpc_txbuf;
  * to pass supplementary information.
  */
 enum rxrpc_skb_mark {
+	RXRPC_SKB_MARK_PACKET,		/* Received packet */
 	RXRPC_SKB_MARK_REJECT_BUSY,	/* Reject with BUSY */
 	RXRPC_SKB_MARK_REJECT_ABORT,	/* Reject with ABORT (code in skb->priority) */
 };
@@ -968,7 +969,7 @@ void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection
 /*
  * io_thread.c
  */
-int rxrpc_input_packet(struct sock *, struct sk_buff *);
+int rxrpc_encap_rcv(struct sock *, struct sk_buff *);
 int rxrpc_io_thread(void *data);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 8021b9230c1e..cabb1852a492 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -83,7 +83,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
 
 	txb = rxrpc_alloc_txbuf(call, RXRPC_PACKET_TYPE_ACK,
-				in_softirq() ? GFP_ATOMIC | __GFP_NOWARN : GFP_NOFS);
+				rcu_read_lock_held() ? GFP_ATOMIC | __GFP_NOWARN : GFP_NOFS);
 	if (!txb) {
 		kleave(" = -ENOMEM");
 		return;
@@ -111,7 +111,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	spin_unlock_bh(&local->ack_tx_lock);
 	trace_rxrpc_send_ack(call, why, ack_reason, serial);
 
-	if (in_task()) {
+	if (!rcu_read_lock_held()) {
 		rxrpc_transmit_ack_packets(call->peer->local);
 	} else {
 		rxrpc_get_local(local, rxrpc_local_get_queue);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 815209673115..b098e72563a7 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -635,7 +635,7 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
 {
 	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
 
-	if (in_softirq()) {
+	if (rcu_read_lock_held()) {
 		INIT_WORK(&call->processor, rxrpc_destroy_call);
 		if (!rxrpc_queue_work(&call->processor))
 			BUG();
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 0b3e096e3d50..ee2e36c46ae2 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -9,6 +9,34 @@
 
 #include "ar-internal.h"
 
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
+int rxrpc_encap_rcv(struct sock *udp_sk, struct sk_buff *skb)
+{
+	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
+
+	if (unlikely(!local)) {
+		kfree_skb(skb);
+		return 0;
+	}
+	if (skb->tstamp == 0)
+		skb->tstamp = ktime_get_real();
+
+	skb->mark = RXRPC_SKB_MARK_PACKET;
+	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
+	skb_queue_tail(&local->rx_queue, skb);
+	rxrpc_wake_up_io_thread(local);
+	return 0;
+}
+
 /*
  * post connection-level events to the connection
  * - this includes challenges, responses, some aborts and call terminal packet
@@ -98,18 +126,10 @@ static bool rxrpc_extract_abort(struct sk_buff *skb)
 }
 
 /*
- * handle data received on the local endpoint
- * - may be called in interrupt context
- *
- * [!] Note that as this is called from the encap_rcv hook, the socket is not
- * held locked by the caller and nothing prevents sk_user_data on the UDP from
- * being cleared in the middle of processing this function.
- *
- * Called with the RCU read lock held from the IP layer via UDP.
+ * Process packets received on the local endpoint
  */
-int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
+static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
 	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan;
 	struct rxrpc_call *call = NULL;
@@ -118,17 +138,9 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	struct rxrpc_sock *rx = NULL;
 	unsigned int channel;
 
-	_enter("%p", udp_sk);
-
-	if (unlikely(!local)) {
-		kfree_skb(skb);
-		return 0;
-	}
 	if (skb->tstamp == 0)
 		skb->tstamp = ktime_get_real();
 
-	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
-
 	skb_pull(skb, sizeof(struct udphdr));
 
 	/* The UDP protocol already released all skb resources;
@@ -387,8 +399,17 @@ int rxrpc_io_thread(void *data)
 
 		/* Process received packets and errors. */
 		if ((skb = __skb_dequeue(&rx_queue))) {
-			// TODO: Input packet
-			rxrpc_free_skb(skb, rxrpc_skb_put_input);
+			switch (skb->mark) {
+			case RXRPC_SKB_MARK_PACKET:
+				rcu_read_lock();
+				rxrpc_input_packet(local, skb);
+				rcu_read_unlock();
+				break;
+			default:
+				WARN_ON_ONCE(1);
+				rxrpc_free_skb(skb, rxrpc_skb_put_unknown);
+				break;
+			}
 			continue;
 		}
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 7c61349984e3..6b4d77219f36 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -154,7 +154,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	}
 
 	tuncfg.encap_type = UDP_ENCAP_RXRPC;
-	tuncfg.encap_rcv = rxrpc_input_packet;
+	tuncfg.encap_rcv = rxrpc_encap_rcv;
 	tuncfg.encap_err_rcv = rxrpc_encap_err_rcv;
 	tuncfg.sk_user_data = local;
 	setup_udp_tunnel_sock(net, local->socket, &tuncfg);


