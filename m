Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54679635A08
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiKWKcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237539AbiKWKcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:32:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3F665B1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyXidabxT3OIiV+FtZPe4v64tDLSJ4XmYuKIvdTbq5s=;
        b=LK3AXHfEpOAwZEfXb98OShr/5DELDUgkNYEQWzNb8DPEKc8z+i6kCKA505drdXlOlDXB1d
        HNN5AY7UMol1AjjSPpTdIFkBoR8rsAM8KrE4JnELZ6pR6ixS4lRfXXjkvU7JW0IR0SFE9G
        2c564bZuMa4TLtHkBpvn21VFWu14CnU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-nF3LbcD-PuuA6vXPP4HVKQ-1; Wed, 23 Nov 2022 05:15:34 -0500
X-MC-Unique: nF3LbcD-PuuA6vXPP4HVKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91B56862FDF;
        Wed, 23 Nov 2022 10:15:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B951A40C83BB;
        Wed, 23 Nov 2022 10:15:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 08/17] rxrpc: Remove the _bh annotation from all the
 spinlocks
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:15:30 +0000
Message-ID: <166919853013.1258552.9747092687433448194.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of the spinlocks in rxrpc need a _bh annotation now as the RCU
callback routines no longer take spinlocks and the bulk of the packet
wrangling code is now run in the I/O thread, not softirq context.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c     |    4 ++--
 net/rxrpc/call_accept.c  |    8 ++++----
 net/rxrpc/call_event.c   |    8 ++++----
 net/rxrpc/call_object.c  |   22 ++++++++++++----------
 net/rxrpc/conn_client.c  |    4 ++--
 net/rxrpc/conn_event.c   |   16 ++++++++--------
 net/rxrpc/conn_object.c  |    4 ++--
 net/rxrpc/conn_service.c |   10 +++++-----
 net/rxrpc/input.c        |    4 ++--
 net/rxrpc/output.c       |   12 ++++++------
 net/rxrpc/peer_event.c   |   16 ++++++++--------
 net/rxrpc/peer_object.c  |    8 ++++----
 net/rxrpc/recvmsg.c      |   36 ++++++++++++++++++------------------
 net/rxrpc/sendmsg.c      |   12 ++++++------
 14 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 8ad4d85acb0b..7ea576f6ba4b 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -359,9 +359,9 @@ void rxrpc_kernel_end_call(struct socket *sock, struct rxrpc_call *call)
 
 	/* Make sure we're not going to call back into a kernel service */
 	if (call->notify_rx) {
-		spin_lock_bh(&call->notify_lock);
+		spin_lock(&call->notify_lock);
 		call->notify_rx = rxrpc_dummy_notify_rx;
-		spin_unlock_bh(&call->notify_lock);
+		spin_unlock(&call->notify_lock);
 	}
 
 	mutex_unlock(&call->user_mutex);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index dd4ca4bee77f..46cd52f50ec4 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -137,9 +137,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	spin_lock_bh(&rxnet->call_lock);
+	spin_lock(&rxnet->call_lock);
 	list_add_tail_rcu(&call->link, &rxnet->calls);
-	spin_unlock_bh(&rxnet->call_lock);
+	spin_unlock(&rxnet->call_lock);
 
 	b->call_backlog[call_head] = call;
 	smp_store_release(&b->call_backlog_head, (call_head + 1) & (size - 1));
@@ -187,8 +187,8 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	/* Make sure that there aren't any incoming calls in progress before we
 	 * clear the preallocation buffers.
 	 */
-	spin_lock_bh(&rx->incoming_lock);
-	spin_unlock_bh(&rx->incoming_lock);
+	spin_lock(&rx->incoming_lock);
+	spin_unlock(&rx->incoming_lock);
 
 	head = b->peer_backlog_head;
 	tail = b->peer_backlog_tail;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index cabb1852a492..618f0ba3163a 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -106,9 +106,9 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 		return;
 	}
 
-	spin_lock_bh(&local->ack_tx_lock);
+	spin_lock(&local->ack_tx_lock);
 	list_add_tail(&txb->tx_link, &local->ack_tx_queue);
-	spin_unlock_bh(&local->ack_tx_lock);
+	spin_unlock(&local->ack_tx_lock);
 	trace_rxrpc_send_ack(call, why, ack_reason, serial);
 
 	if (!rcu_read_lock_held()) {
@@ -150,13 +150,13 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 	/* See if there's an ACK saved with a soft-ACK table in it. */
 	if (call->acks_soft_tbl) {
-		spin_lock_bh(&call->acks_ack_lock);
+		spin_lock(&call->acks_ack_lock);
 		ack_skb = call->acks_soft_tbl;
 		if (ack_skb) {
 			rxrpc_get_skb(ack_skb, rxrpc_skb_get_ack);
 			ack = (void *)ack_skb->data + sizeof(struct rxrpc_wire_header);
 		}
-		spin_unlock_bh(&call->acks_ack_lock);
+		spin_unlock(&call->acks_ack_lock);
 	}
 
 	if (list_empty(&call->tx_buffer))
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index d77b65bf3273..8abb6a785697 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -327,9 +327,9 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	spin_lock_bh(&rxnet->call_lock);
+	spin_lock(&rxnet->call_lock);
 	list_add_tail_rcu(&call->link, &rxnet->calls);
-	spin_unlock_bh(&rxnet->call_lock);
+	spin_unlock(&rxnet->call_lock);
 
 	/* From this point on, the call is protected by its own lock. */
 	release_sock(&rx->sk);
@@ -516,7 +516,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	rxrpc_delete_call_timer(call);
 
 	/* Make sure we don't get any more notifications */
-	write_lock_bh(&rx->recvmsg_lock);
+	write_lock(&rx->recvmsg_lock);
 
 	if (!list_empty(&call->recvmsg_link)) {
 		_debug("unlinking once-pending call %p { e=%lx f=%lx }",
@@ -529,7 +529,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	call->recvmsg_link.next = NULL;
 	call->recvmsg_link.prev = NULL;
 
-	write_unlock_bh(&rx->recvmsg_lock);
+	write_unlock(&rx->recvmsg_lock);
 	if (put)
 		rxrpc_put_call(call, rxrpc_call_put_unnotify);
 
@@ -601,9 +601,9 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
-			spin_lock_bh(&rxnet->call_lock);
+			spin_lock(&rxnet->call_lock);
 			list_del_init(&call->link);
-			spin_unlock_bh(&rxnet->call_lock);
+			spin_unlock(&rxnet->call_lock);
 		}
 
 		rxrpc_cleanup_call(call);
@@ -635,6 +635,8 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 
+	rxrpc_delete_call_timer(call);
+
 	rxrpc_cleanup_ring(call);
 	while ((txb = list_first_entry_or_null(&call->tx_buffer,
 					       struct rxrpc_txbuf, call_link))) {
@@ -663,7 +665,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		spin_lock_bh(&rxnet->call_lock);
+		spin_lock(&rxnet->call_lock);
 
 		while (!list_empty(&rxnet->calls)) {
 			call = list_entry(rxnet->calls.next,
@@ -678,12 +680,12 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
-			spin_unlock_bh(&rxnet->call_lock);
+			spin_unlock(&rxnet->call_lock);
 			cond_resched();
-			spin_lock_bh(&rxnet->call_lock);
+			spin_lock(&rxnet->call_lock);
 		}
 
-		spin_unlock_bh(&rxnet->call_lock);
+		spin_unlock(&rxnet->call_lock);
 	}
 
 	atomic_dec(&rxnet->nr_calls);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 34ff6fa85c32..b369eaed52ef 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -557,9 +557,9 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	trace_rxrpc_connect_call(call);
 
-	write_lock_bh(&call->state_lock);
+	write_lock(&call->state_lock);
 	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
-	write_unlock_bh(&call->state_lock);
+	write_unlock(&call->state_lock);
 
 	/* Paired with the read barrier in rxrpc_connect_call().  This orders
 	 * cid and epoch in the connection wrt to call_id without the need to
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 49d885f73fa5..281ede2ccce1 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -198,9 +198,9 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	_enter("%d,,%u,%u", conn->debug_id, error, abort_code);
 
 	/* generate a connection-level abort */
-	spin_lock_bh(&conn->state_lock);
+	spin_lock(&conn->state_lock);
 	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
-		spin_unlock_bh(&conn->state_lock);
+		spin_unlock(&conn->state_lock);
 		_leave(" = 0 [already dead]");
 		return 0;
 	}
@@ -209,7 +209,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	conn->abort_code = abort_code;
 	conn->state = RXRPC_CONN_LOCALLY_ABORTED;
 	set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-	spin_unlock_bh(&conn->state_lock);
+	spin_unlock(&conn->state_lock);
 
 	msg.msg_name	= &conn->peer->srx.transport;
 	msg.msg_namelen	= conn->peer->srx.transport_len;
@@ -265,12 +265,12 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
 {
 	_enter("%p", call);
 	if (call) {
-		write_lock_bh(&call->state_lock);
+		write_lock(&call->state_lock);
 		if (call->state == RXRPC_CALL_SERVER_SECURING) {
 			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
 			rxrpc_notify_socket(call);
 		}
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 	}
 }
 
@@ -325,18 +325,18 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return ret;
 
 		spin_lock(&conn->bundle->channel_lock);
-		spin_lock_bh(&conn->state_lock);
+		spin_lock(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
 			conn->state = RXRPC_CONN_SERVICE;
-			spin_unlock_bh(&conn->state_lock);
+			spin_unlock(&conn->state_lock);
 			for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
 				rxrpc_call_is_secure(
 					rcu_dereference_protected(
 						conn->channels[loop].call,
 						lockdep_is_held(&conn->bundle->channel_lock)));
 		} else {
-			spin_unlock_bh(&conn->state_lock);
+			spin_unlock(&conn->state_lock);
 		}
 
 		spin_unlock(&conn->bundle->channel_lock);
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 54821c2f6d89..891cbbb1926d 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -210,9 +210,9 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	call->peer->cong_ssthresh = call->cong_ssthresh;
 
 	if (!hlist_unhashed(&call->error_link)) {
-		spin_lock_bh(&call->peer->lock);
+		spin_lock(&call->peer->lock);
 		hlist_del_rcu(&call->error_link);
-		spin_unlock_bh(&call->peer->lock);
+		spin_unlock(&call->peer->lock);
 	}
 
 	if (rxrpc_is_client_call(call))
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 2c44d67b43dc..8f6dc7b60fc7 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -73,7 +73,7 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer *peer,
 	struct rxrpc_conn_proto k = conn->proto;
 	struct rb_node **pp, *parent;
 
-	write_seqlock_bh(&peer->service_conn_lock);
+	write_seqlock(&peer->service_conn_lock);
 
 	pp = &peer->service_conns.rb_node;
 	parent = NULL;
@@ -94,14 +94,14 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer *peer,
 	rb_insert_color(&conn->service_node, &peer->service_conns);
 conn_published:
 	set_bit(RXRPC_CONN_IN_SERVICE_CONNS, &conn->flags);
-	write_sequnlock_bh(&peer->service_conn_lock);
+	write_sequnlock(&peer->service_conn_lock);
 	_leave(" = %d [new]", conn->debug_id);
 	return;
 
 found_extant_conn:
 	if (refcount_read(&cursor->ref) == 0)
 		goto replace_old_connection;
-	write_sequnlock_bh(&peer->service_conn_lock);
+	write_sequnlock(&peer->service_conn_lock);
 	/* We should not be able to get here.  rxrpc_incoming_connection() is
 	 * called in a non-reentrant context, so there can't be a race to
 	 * insert a new connection.
@@ -193,8 +193,8 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_peer *peer = conn->peer;
 
-	write_seqlock_bh(&peer->service_conn_lock);
+	write_seqlock(&peer->service_conn_lock);
 	if (test_and_clear_bit(RXRPC_CONN_IN_SERVICE_CONNS, &conn->flags))
 		rb_erase(&conn->service_node, &peer->service_conns);
-	write_sequnlock_bh(&peer->service_conn_lock);
+	write_sequnlock(&peer->service_conn_lock);
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 13c52145a926..1b9da9078315 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -717,10 +717,10 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 
 	peer = call->peer;
 	if (mtu < peer->maxdata) {
-		spin_lock_bh(&peer->lock);
+		spin_lock(&peer->lock);
 		peer->maxdata = mtu;
 		peer->mtu = mtu + peer->hdrsize;
-		spin_unlock_bh(&peer->lock);
+		spin_unlock(&peer->lock);
 	}
 
 	if (wake)
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 131c7a76fb06..68511069873a 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -293,9 +293,9 @@ void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
 	if (list_empty(&local->ack_tx_queue))
 		return;
 
-	spin_lock_bh(&local->ack_tx_lock);
+	spin_lock(&local->ack_tx_lock);
 	list_splice_tail_init(&local->ack_tx_queue, &queue);
-	spin_unlock_bh(&local->ack_tx_lock);
+	spin_unlock(&local->ack_tx_lock);
 
 	while (!list_empty(&queue)) {
 		struct rxrpc_txbuf *txb =
@@ -303,9 +303,9 @@ void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
 
 		ret = rxrpc_send_ack_packet(local, txb);
 		if (ret < 0 && ret != -ECONNRESET) {
-			spin_lock_bh(&local->ack_tx_lock);
+			spin_lock(&local->ack_tx_lock);
 			list_splice_init(&queue, &local->ack_tx_queue);
-			spin_unlock_bh(&local->ack_tx_lock);
+			spin_unlock(&local->ack_tx_lock);
 			break;
 		}
 
@@ -395,9 +395,9 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	_enter("%x,{%d}", txb->seq, txb->len);
 
 	if (hlist_unhashed(&call->error_link)) {
-		spin_lock_bh(&call->peer->lock);
+		spin_lock(&call->peer->lock);
 		hlist_add_head_rcu(&call->error_link, &call->peer->error_targets);
-		spin_unlock_bh(&call->peer->lock);
+		spin_unlock(&call->peer->lock);
 	}
 
 	/* Each transmission of a Tx packet needs a new serial number */
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 94f63fb1bd67..e902895e67b0 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -121,10 +121,10 @@ static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 	}
 
 	if (mtu < peer->mtu) {
-		spin_lock_bh(&peer->lock);
+		spin_lock(&peer->lock);
 		peer->mtu = mtu;
 		peer->maxdata = peer->mtu - peer->hdrsize;
-		spin_unlock_bh(&peer->lock);
+		spin_unlock(&peer->lock);
 	}
 }
 
@@ -227,7 +227,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 	time64_t keepalive_at;
 	int slot;
 
-	spin_lock_bh(&rxnet->peer_hash_lock);
+	spin_lock(&rxnet->peer_hash_lock);
 
 	while (!list_empty(collector)) {
 		peer = list_entry(collector->next,
@@ -238,7 +238,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 			continue;
 
 		if (__rxrpc_use_local(peer->local, rxrpc_local_use_peer_keepalive)) {
-			spin_unlock_bh(&rxnet->peer_hash_lock);
+			spin_unlock(&rxnet->peer_hash_lock);
 
 			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
 			slot = keepalive_at - base;
@@ -257,7 +257,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 			 */
 			slot += cursor;
 			slot &= mask;
-			spin_lock_bh(&rxnet->peer_hash_lock);
+			spin_lock(&rxnet->peer_hash_lock);
 			list_add_tail(&peer->keepalive_link,
 				      &rxnet->peer_keepalive[slot & mask]);
 			rxrpc_unuse_local(peer->local, rxrpc_local_unuse_peer_keepalive);
@@ -265,7 +265,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 		rxrpc_put_peer_locked(peer, rxrpc_peer_put_keepalive);
 	}
 
-	spin_unlock_bh(&rxnet->peer_hash_lock);
+	spin_unlock(&rxnet->peer_hash_lock);
 }
 
 /*
@@ -295,7 +295,7 @@ void rxrpc_peer_keepalive_worker(struct work_struct *work)
 	 * second; the bucket at cursor + 1 goes at now + 1s and so
 	 * on...
 	 */
-	spin_lock_bh(&rxnet->peer_hash_lock);
+	spin_lock(&rxnet->peer_hash_lock);
 	list_splice_init(&rxnet->peer_keepalive_new, &collector);
 
 	stop = cursor + ARRAY_SIZE(rxnet->peer_keepalive);
@@ -307,7 +307,7 @@ void rxrpc_peer_keepalive_worker(struct work_struct *work)
 	}
 
 	base = now;
-	spin_unlock_bh(&rxnet->peer_hash_lock);
+	spin_unlock(&rxnet->peer_hash_lock);
 
 	rxnet->peer_keepalive_base = base;
 	rxnet->peer_keepalive_cursor = cursor;
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 9e682a60a800..608946dcc505 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -349,7 +349,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 			return NULL;
 		}
 
-		spin_lock_bh(&rxnet->peer_hash_lock);
+		spin_lock(&rxnet->peer_hash_lock);
 
 		/* Need to check that we aren't racing with someone else */
 		peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
@@ -362,7 +362,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 				      &rxnet->peer_keepalive_new);
 		}
 
-		spin_unlock_bh(&rxnet->peer_hash_lock);
+		spin_unlock(&rxnet->peer_hash_lock);
 
 		if (peer)
 			rxrpc_free_peer(candidate);
@@ -412,10 +412,10 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 
 	ASSERT(hlist_empty(&peer->error_targets));
 
-	spin_lock_bh(&rxnet->peer_hash_lock);
+	spin_lock(&rxnet->peer_hash_lock);
 	hash_del_rcu(&peer->hash_link);
 	list_del_init(&peer->keepalive_link);
-	spin_unlock_bh(&rxnet->peer_hash_lock);
+	spin_unlock(&rxnet->peer_hash_lock);
 
 	rxrpc_free_peer(peer);
 }
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index bfac9e09347e..2cb73bb8abca 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -36,16 +36,16 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 	sk = &rx->sk;
 	if (rx && sk->sk_state < RXRPC_CLOSE) {
 		if (call->notify_rx) {
-			spin_lock_bh(&call->notify_lock);
+			spin_lock(&call->notify_lock);
 			call->notify_rx(sk, call, call->user_call_ID);
-			spin_unlock_bh(&call->notify_lock);
+			spin_unlock(&call->notify_lock);
 		} else {
-			write_lock_bh(&rx->recvmsg_lock);
+			write_lock(&rx->recvmsg_lock);
 			if (list_empty(&call->recvmsg_link)) {
 				rxrpc_get_call(call, rxrpc_call_get_notify_socket);
 				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
 			}
-			write_unlock_bh(&rx->recvmsg_lock);
+			write_unlock(&rx->recvmsg_lock);
 
 			if (!sock_flag(sk, SOCK_DEAD)) {
 				_debug("call %ps", sk->sk_data_ready);
@@ -87,9 +87,9 @@ bool rxrpc_set_call_completion(struct rxrpc_call *call,
 	bool ret = false;
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock_bh(&call->state_lock);
+		write_lock(&call->state_lock);
 		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 	}
 	return ret;
 }
@@ -107,9 +107,9 @@ bool rxrpc_call_completed(struct rxrpc_call *call)
 	bool ret = false;
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock_bh(&call->state_lock);
+		write_lock(&call->state_lock);
 		ret = __rxrpc_call_completed(call);
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 	}
 	return ret;
 }
@@ -131,9 +131,9 @@ bool rxrpc_abort_call(const char *why, struct rxrpc_call *call,
 {
 	bool ret;
 
-	write_lock_bh(&call->state_lock);
+	write_lock(&call->state_lock);
 	ret = __rxrpc_abort_call(why, call, seq, abort_code, error);
-	write_unlock_bh(&call->state_lock);
+	write_unlock(&call->state_lock);
 	return ret;
 }
 
@@ -193,23 +193,23 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY)
 		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
 
-	write_lock_bh(&call->state_lock);
+	write_lock(&call->state_lock);
 
 	switch (call->state) {
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 		__rxrpc_call_completed(call);
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 		rxrpc_propose_delay_ACK(call, serial,
 					rxrpc_propose_ack_processing_op);
 		break;
 	default:
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 		break;
 	}
 }
@@ -445,14 +445,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	/* Find the next call and dequeue it if we're not just peeking.  If we
 	 * do dequeue it, that comes with a ref that we will need to release.
 	 */
-	write_lock_bh(&rx->recvmsg_lock);
+	write_lock(&rx->recvmsg_lock);
 	l = rx->recvmsg_q.next;
 	call = list_entry(l, struct rxrpc_call, recvmsg_link);
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
 		rxrpc_get_call(call, rxrpc_call_get_recvmsg);
-	write_unlock_bh(&rx->recvmsg_lock);
+	write_unlock(&rx->recvmsg_lock);
 
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0);
 
@@ -543,9 +543,9 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
-		write_lock_bh(&rx->recvmsg_lock);
+		write_lock(&rx->recvmsg_lock);
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		write_unlock_bh(&rx->recvmsg_lock);
+		write_unlock(&rx->recvmsg_lock);
 		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 76b1e2e89c1e..7183c7f76f46 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -232,7 +232,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 
 	if (last || call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
 		_debug("________awaiting reply/ACK__________");
-		write_lock_bh(&call->state_lock);
+		write_lock(&call->state_lock);
 		switch (call->state) {
 		case RXRPC_CALL_CLIENT_SEND_REQUEST:
 			call->state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
@@ -255,7 +255,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		default:
 			break;
 		}
-		write_unlock_bh(&call->state_lock);
+		write_unlock(&call->state_lock);
 	}
 
 	if (seq == 1 && rxrpc_is_client_call(call))
@@ -416,10 +416,10 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 success:
 	ret = copied;
 	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
-		read_lock_bh(&call->state_lock);
+		read_lock(&call->state_lock);
 		if (call->error < 0)
 			ret = call->error;
-		read_unlock_bh(&call->state_lock);
+		read_unlock(&call->state_lock);
 	}
 out:
 	call->tx_pending = txb;
@@ -784,9 +784,9 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 				      notify_end_tx, &dropped_lock);
 		break;
 	case RXRPC_CALL_COMPLETE:
-		read_lock_bh(&call->state_lock);
+		read_lock(&call->state_lock);
 		ret = call->error;
-		read_unlock_bh(&call->state_lock);
+		read_unlock(&call->state_lock);
 		break;
 	default:
 		/* Request phase complete for this client call */


