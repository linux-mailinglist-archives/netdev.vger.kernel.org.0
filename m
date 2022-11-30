Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5945763DB77
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiK3RFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiK3REg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:04:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B34B93A4B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2y2eQYmgW93Oe8z+N6AtyddIxcUSht93G9L7qmS2NKY=;
        b=NkbhvjC1pMnRrr1STof8Plfy+fbJx9VdRGeV1395bRGSCCJypenAl335AcWnQGg3C/zxgi
        44OECyfXepiUDHNj8Epfc/oGq8+rmirrVlwkfFFDYQTvfop4asMG+HKBTv6vkROyY7BKbQ
        h/TiLhu/5o2x3+XFTPx+Ae7qTeqsS+w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-9mhrbNkgN3mnfUeguO8gKA-1; Wed, 30 Nov 2022 11:59:24 -0500
X-MC-Unique: 9mhrbNkgN3mnfUeguO8gKA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0939B38173CC;
        Wed, 30 Nov 2022 16:59:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ADBB492B04;
        Wed, 30 Nov 2022 16:59:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 35/35] rxrpc: Transmit ACKs at the point of
 generation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:59:20 +0000
Message-ID: <166982756095.621383.1390522561920223769.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ACKs generated inside the I/O thread, transmit the ACK at the point of
generation.  Where the ACK is generated outside of the I/O thread, it's
offloaded to the I/O thread to transmit it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    3 ---
 net/rxrpc/ar-internal.h      |    5 +----
 net/rxrpc/call_event.c       |   17 ++---------------
 net/rxrpc/io_thread.c        |    5 -----
 net/rxrpc/local_object.c     |    2 --
 net/rxrpc/output.c           |   42 ++----------------------------------------
 net/rxrpc/recvmsg.c          |    3 ---
 net/rxrpc/sendmsg.c          |    2 --
 net/rxrpc/txbuf.c            |    1 -
 9 files changed, 5 insertions(+), 75 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index b41e913ae78a..049b52e7aa6a 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -63,7 +63,6 @@
 	EM(rxrpc_local_put_peer,		"PUT peer    ") \
 	EM(rxrpc_local_put_prealloc_conn,	"PUT conn-pre") \
 	EM(rxrpc_local_put_release_sock,	"PUT rel-sock") \
-	EM(rxrpc_local_see_tx_ack,		"SEE tx-ack  ") \
 	EM(rxrpc_local_stop,			"STOP        ") \
 	EM(rxrpc_local_stopped,			"STOPPED     ") \
 	EM(rxrpc_local_unuse_bind,		"UNU bind    ") \
@@ -156,7 +155,6 @@
 	EM(rxrpc_call_get_recvmsg,		"GET recvmsg ") \
 	EM(rxrpc_call_get_release_sock,		"GET rel-sock") \
 	EM(rxrpc_call_get_sendmsg,		"GET sendmsg ") \
-	EM(rxrpc_call_get_send_ack,		"GET send-ack") \
 	EM(rxrpc_call_get_userid,		"GET user-id ") \
 	EM(rxrpc_call_new_client,		"NEW client  ") \
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
@@ -168,7 +166,6 @@
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
-	EM(rxrpc_call_put_send_ack,		"PUT send-ack") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
 	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 2a4928249a64..e7dccab7b741 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -287,8 +287,6 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
-	struct list_head	ack_tx_queue;	/* List of ACKs that need sending */
-	spinlock_t		ack_tx_lock;	/* ACK list lock */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
@@ -762,7 +760,6 @@ struct rxrpc_txbuf {
 	struct rcu_head		rcu;
 	struct list_head	call_link;	/* Link in call->tx_sendmsg/tx_buffer */
 	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
-	struct rxrpc_call	*call;		/* Call to which belongs */
 	ktime_t			last_sent;	/* Time at which last transmitted */
 	refcount_t		ref;
 	rxrpc_seq_t		seq;		/* Sequence number of this packet */
@@ -1047,7 +1044,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
 /*
  * output.c
  */
-void rxrpc_transmit_ack_packets(struct rxrpc_local *);
+int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
 void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index fd122e3726bd..b2cf448fb02c 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -69,7 +69,6 @@ void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t serial,
 void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 		    rxrpc_serial_t serial, enum rxrpc_propose_ack_trace why)
 {
-	struct rxrpc_local *local = call->conn->local;
 	struct rxrpc_txbuf *txb;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
@@ -96,17 +95,9 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	txb->ack.reason		= ack_reason;
 	txb->ack.nAcks		= 0;
 
-	if (!rxrpc_try_get_call(call, rxrpc_call_get_send_ack)) {
-		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_nomem);
-		return;
-	}
-
-	spin_lock(&local->ack_tx_lock);
-	list_add_tail(&txb->tx_link, &local->ack_tx_queue);
-	spin_unlock(&local->ack_tx_lock);
 	trace_rxrpc_send_ack(call, why, ack_reason, serial);
-
-	rxrpc_wake_up_io_thread(local);
+	rxrpc_send_ack_packet(call, txb);
+	rxrpc_put_txbuf(txb, rxrpc_txbuf_put_ack_tx);
 }
 
 /*
@@ -294,10 +285,6 @@ static void rxrpc_decant_prepared_tx(struct rxrpc_call *call)
 
 		rxrpc_transmit_one(call, txb);
 
-		// TODO: Drain the transmission buffers.  Do this somewhere better
-		if (after(call->acks_hard_ack, call->tx_bottom + 16))
-			rxrpc_shrink_call_tx_buffer(call);
-
 		if (!rxrpc_tx_window_has_space(call))
 			break;
 	}
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 19aa315eddf5..d83ae3193032 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -447,11 +447,6 @@ int rxrpc_io_thread(void *data)
 			continue;
 		}
 
-		if (!list_empty(&local->ack_tx_queue)) {
-			rxrpc_transmit_ack_packets(local);
-			continue;
-		}
-
 		/* Process received packets and errors. */
 		if ((skb = __skb_dequeue(&rx_queue))) {
 			switch (skb->mark) {
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 1e994a83db2b..44222923c0d1 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -96,8 +96,6 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
-		INIT_LIST_HEAD(&local->ack_tx_queue);
-		spin_lock_init(&local->ack_tx_lock);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->call_attend_q);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 8147a47d1702..3d8c9f830ee0 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -203,12 +203,11 @@ static void rxrpc_cancel_rtt_probe(struct rxrpc_call *call,
 }
 
 /*
- * Send an ACK call packet.
+ * Transmit an ACK packet.
  */
-static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *txb)
+int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_call *call = txb->call;
 	struct msghdr msg;
 	struct kvec iov[1];
 	rxrpc_serial_t serial;
@@ -271,43 +270,6 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	return ret;
 }
 
-/*
- * ACK transmitter for a local endpoint.  The UDP socket locks around each
- * transmission, so we can only transmit one packet at a time, ACK, DATA or
- * otherwise.
- */
-void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
-{
-	LIST_HEAD(queue);
-	int ret;
-
-	rxrpc_see_local(local, rxrpc_local_see_tx_ack);
-
-	if (list_empty(&local->ack_tx_queue))
-		return;
-
-	spin_lock(&local->ack_tx_lock);
-	list_splice_tail_init(&local->ack_tx_queue, &queue);
-	spin_unlock(&local->ack_tx_lock);
-
-	while (!list_empty(&queue)) {
-		struct rxrpc_txbuf *txb =
-			list_entry(queue.next, struct rxrpc_txbuf, tx_link);
-
-		ret = rxrpc_send_ack_packet(local, txb);
-		if (ret < 0 && ret != -ECONNRESET) {
-			spin_lock(&local->ack_tx_lock);
-			list_splice_init(&queue, &local->ack_tx_queue);
-			spin_unlock(&local->ack_tx_lock);
-			break;
-		}
-
-		list_del_init(&txb->tx_link);
-		rxrpc_put_call(txb->call, rxrpc_call_put_send_ack);
-		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_ack_tx);
-	}
-}
-
 /*
  * Send an ABORT call packet.
  */
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 3a8576e9daf3..36b25d003cf0 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -320,7 +320,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 				ret = ret2;
 				goto out;
 			}
-			rxrpc_transmit_ack_packets(call->peer->local);
 		} else {
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_cont, seq,
 					     rx_pkt_offset, rx_pkt_len, 0);
@@ -502,7 +501,6 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (ret == -EAGAIN)
 			ret = 0;
 
-		rxrpc_transmit_ack_packets(call->peer->local);
 		if (!skb_queue_empty(&call->recvmsg_queue))
 			rxrpc_notify_socket(call);
 		break;
@@ -632,7 +630,6 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 read_phase_complete:
 	ret = 1;
 out:
-	rxrpc_transmit_ack_packets(call->peer->local);
 	if (_service)
 		*_service = call->dest_srx.srx_service;
 	mutex_unlock(&call->user_mutex);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 2c861c55ed70..9fa7e37f7155 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -276,8 +276,6 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
 
 	do {
-		rxrpc_transmit_ack_packets(call->peer->local);
-
 		if (!txb) {
 			size_t remain, bufsize, chunk, offset;
 
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index a5054389dfbb..d2cf2aac3adb 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -26,7 +26,6 @@ struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
 		INIT_LIST_HEAD(&txb->call_link);
 		INIT_LIST_HEAD(&txb->tx_link);
 		refcount_set(&txb->ref, 1);
-		txb->call		= call;
 		txb->call_debug_id	= call->debug_id;
 		txb->debug_id		= atomic_inc_return(&rxrpc_txbuf_debug_ids);
 		txb->space		= sizeof(txb->data);


