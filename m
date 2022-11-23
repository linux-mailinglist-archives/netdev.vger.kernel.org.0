Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9F635A13
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiKWKfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbiKWKdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:33:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28597E9312
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uz59yWDgPVj7uKZ0mD2wVGqMPgDSOeinyShQgQoaq+4=;
        b=bqRHA61yaJtwYw5brmzl+D2RJrsw0uhzE3xaK+EH6oQXEM+QzGoQrppsUMuDvdoscXfdh3
        RmYTgqvYfGun5D+3Op0SxEcu1wz9pBztBBou855d/VedQAdGk4juaR7qAgI4D6uiiyyuLo
        X/VNLRLnn4b0B2b97674vzQkR/xc8oE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-Pu7_rt0zMAeGDfg3x2wrPA-1; Wed, 23 Nov 2022 05:16:36 -0500
X-MC-Unique: Pu7_rt0zMAeGDfg3x2wrPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2712185A794;
        Wed, 23 Nov 2022 10:16:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD6D2024CBE;
        Wed, 23 Nov 2022 10:16:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/17] rxrpc: Transmit ACKs at the point of
 generation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:16:32 +0000
Message-ID: <166919859251.1258552.10554889743040887751.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
 net/rxrpc/call_event.c       |   13 ++-----------
 net/rxrpc/io_thread.c        |    5 -----
 net/rxrpc/local_object.c     |    2 --
 net/rxrpc/output.c           |   42 ++----------------------------------------
 net/rxrpc/recvmsg.c          |    3 ---
 net/rxrpc/sendmsg.c          |    2 --
 net/rxrpc/txbuf.c            |    1 -
 9 files changed, 5 insertions(+), 71 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 27a002a66ea6..3ecacc12fe90 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -60,7 +60,6 @@
 	EM(rxrpc_local_put_peer,		"PUT peer    ") \
 	EM(rxrpc_local_put_prealloc_conn,	"PUT conn-pre") \
 	EM(rxrpc_local_put_release_sock,	"PUT rel-sock") \
-	EM(rxrpc_local_see_tx_ack,		"SEE tx-ack  ") \
 	EM(rxrpc_local_stop,			"STOP        ") \
 	EM(rxrpc_local_stopped,			"STOPPED     ") \
 	EM(rxrpc_local_unuse_bind,		"UNU bind    ") \
@@ -152,7 +151,6 @@
 	EM(rxrpc_call_get_recvmsg,		"GET recvmsg ") \
 	EM(rxrpc_call_get_release_sock,		"GET rel-sock") \
 	EM(rxrpc_call_get_sendmsg,		"GET sendmsg ") \
-	EM(rxrpc_call_get_send_ack,		"GET send-ack") \
 	EM(rxrpc_call_get_userid,		"GET user-id ") \
 	EM(rxrpc_call_new_client,		"NEW client  ") \
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
@@ -163,7 +161,6 @@
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
-	EM(rxrpc_call_put_send_ack,		"PUT send-ack") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
 	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index aaa57bc7817b..713f90f275db 100644
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
@@ -754,7 +752,6 @@ struct rxrpc_txbuf {
 	struct rcu_head		rcu;
 	struct list_head	call_link;	/* Link in call->tx_sendmsg/tx_buffer */
 	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
-	struct rxrpc_call	*call;
 	ktime_t			last_sent;	/* Time at which last transmitted */
 	refcount_t		ref;
 	rxrpc_seq_t		seq;		/* Sequence number of this packet */
@@ -1052,7 +1049,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
 /*
  * output.c
  */
-void rxrpc_transmit_ack_packets(struct rxrpc_local *);
+int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
 void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 2e08a8e3a8f8..a5c516e5aed8 100644
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
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index f07525ab5578..fbb809967bf1 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -383,11 +383,6 @@ int rxrpc_io_thread(void *data)
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
index d1c361c35ef9..9eb877f90433 100644
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
index 16b796e5dc8a..cff919132c58 100644
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
@@ -504,7 +503,6 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (ret == -EAGAIN)
 			ret = 0;
 
-		rxrpc_transmit_ack_packets(call->peer->local);
 		if (!skb_queue_empty(&call->recvmsg_queue))
 			rxrpc_notify_socket(call);
 		break;
@@ -634,7 +632,6 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 read_phase_complete:
 	ret = 1;
 out:
-	rxrpc_transmit_ack_packets(call->peer->local);
 	if (_service)
 		*_service = call->service_id;
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
index 6721c64c3d1a..2e9504a3b07e 100644
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


