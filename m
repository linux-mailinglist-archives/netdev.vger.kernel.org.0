Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8278F63FCD1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiLBAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiLBAVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:21:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66278BD0C4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IITIpng4+2y93iZ20I7Kz1tWXCOyAVbwMwu5YEVC3zM=;
        b=dV052FmxQeGSQWicJf/wZ54KR4pz2ayCeSEX+ABrA+74bMymsw3ikoexfA1RLFWWutwK+W
        lOqtSxod+ikXCp/YpO4x7RH+rc5UySq4QPGvefcxcZBQ20ZNRPG7BgAUVC+4omQsnDu9Q7
        vyG7AF+lepLpddKIAjGp6D3KbUkDfIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-Q51kRvgxMx6eTwUyg_sCBA-1; Thu, 01 Dec 2022 19:17:56 -0500
X-MC-Unique: Q51kRvgxMx6eTwUyg_sCBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7996B101A528;
        Fri,  2 Dec 2022 00:17:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD7451401C31;
        Fri,  2 Dec 2022 00:17:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 20/36] rxrpc: Move packet reception processing into
 I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:17:53 +0000
Message-ID: <166994027315.1732290.3016573765287552450.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
index de82c25956a6..044815ba2b49 100644
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
@@ -957,7 +958,7 @@ void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection
 /*
  * io_thread.c
  */
-int rxrpc_input_packet(struct sock *, struct sk_buff *);
+int rxrpc_encap_rcv(struct sock *, struct sk_buff *);
 int rxrpc_io_thread(void *data);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 049b92b1c040..3925b55e2064 100644
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
index 9cd7e0190ef4..57c8d4cc900a 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -632,7 +632,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	del_timer_sync(&call->timer);
 	cancel_work(&call->processor);
 
-	if (in_softirq() || work_busy(&call->processor))
+	if (rcu_read_lock_held() || work_busy(&call->processor))
 		/* Can't use the rxrpc workqueue as we need to cancel/flush
 		 * something that may be running/waiting there.
 		 */
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


