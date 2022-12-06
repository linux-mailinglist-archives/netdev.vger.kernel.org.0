Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED096448CA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiLFQI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiLFQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:08:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FAA32BB0
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdlW53yOUlzvoothoGeRCf1DNdUdd2Eq8nHnqri3HZg=;
        b=aED6hqD9MXCKNFsNGnR8sQFwRaaMfBYi6ix8Q7+x8HCIZWgPkK0k4ZBOlAdEjUDi9Yz3LK
        xfq8vHuNTdBu8VhFRwAQEONlWvu6LI4DFZ7uKAaO/ekjRIs8jYwc2CjOpARuXbwUvrGrlB
        F3ZLLBt86MhcP618h6FTtOOQjjF3vV4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-MDBIRgpRPPa_WTF0I_8tBQ-1; Tue, 06 Dec 2022 11:03:00 -0500
X-MC-Unique: MDBIRgpRPPa_WTF0I_8tBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD06A1C08984;
        Tue,  6 Dec 2022 16:02:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5D1C40C6EC4;
        Tue,  6 Dec 2022 16:02:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 31/32] rxrpc: Move client call connection to the I/O
 thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:02:56 +0000
Message-ID: <167034257623.1105287.13324829635106861385.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the connection setup of client calls to the I/O thread so that a whole
load of locking and barrierage can be eliminated.  This necessitates the
app thread waiting for connection to complete before it can begin
encrypting data.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    5 
 net/rxrpc/ar-internal.h      |   22 +-
 net/rxrpc/call_object.c      |   58 ++++-
 net/rxrpc/call_state.c       |    2 
 net/rxrpc/conn_client.c      |  525 ++++++++++--------------------------------
 net/rxrpc/conn_event.c       |   50 +---
 net/rxrpc/conn_object.c      |   19 +-
 net/rxrpc/conn_service.c     |    1 
 net/rxrpc/io_thread.c        |   13 +
 net/rxrpc/local_object.c     |    6 
 net/rxrpc/proc.c             |    1 
 net/rxrpc/rxkad.c            |   21 +-
 net/rxrpc/security.c         |   34 +--
 net/rxrpc/sendmsg.c          |   64 +++++
 14 files changed, 295 insertions(+), 526 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a4c5bc481cfc..3e228aa2d2b1 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -225,7 +225,6 @@
 	EM(rxrpc_conn_put_call,			"PUT call    ") \
 	EM(rxrpc_conn_put_call_input,		"PUT inp-call") \
 	EM(rxrpc_conn_put_conn_input,		"PUT inp-conn") \
-	EM(rxrpc_conn_put_discard,		"PUT discard ") \
 	EM(rxrpc_conn_put_discard_idle,		"PUT disc-idl") \
 	EM(rxrpc_conn_put_local_dead,		"PUT loc-dead") \
 	EM(rxrpc_conn_put_noreuse,		"PUT noreuse ") \
@@ -247,12 +246,11 @@
 	EM(rxrpc_client_chan_activate,		"ChActv") \
 	EM(rxrpc_client_chan_disconnect,	"ChDisc") \
 	EM(rxrpc_client_chan_pass,		"ChPass") \
-	EM(rxrpc_client_chan_wait_failed,	"ChWtFl") \
 	EM(rxrpc_client_cleanup,		"Clean ") \
 	EM(rxrpc_client_discard,		"Discar") \
-	EM(rxrpc_client_duplicate,		"Duplic") \
 	EM(rxrpc_client_exposed,		"Expose") \
 	EM(rxrpc_client_replace,		"Replac") \
+	EM(rxrpc_client_queue_new_call,		"Q-Call") \
 	EM(rxrpc_client_to_active,		"->Actv") \
 	E_(rxrpc_client_to_idle,		"->Idle")
 
@@ -280,6 +278,7 @@
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
 	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
+	EM(rxrpc_call_put_userid,		"PUT user-id ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e79263927a6d..04f6253ae169 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -293,7 +293,6 @@ struct rxrpc_local {
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
 	bool			kill_all_client_conns;
-	spinlock_t		client_conn_cache_lock; /* Lock for ->*_client_conns */
 	struct list_head	idle_client_conns;
 	struct timer_list	client_conn_reap_timer;
 	unsigned long		client_conn_flags;
@@ -305,7 +304,8 @@ struct rxrpc_local {
 	bool			dead;
 	bool			service_closed;	/* Service socket closed */
 	struct idr		conn_ids;	/* List of connection IDs */
-	spinlock_t		conn_lock;	/* Lock for client connection pool */
+	struct list_head	new_client_calls; /* Newly created client calls need connection */
+	spinlock_t		client_call_lock; /* Lock for ->new_client_calls */
 	struct sockaddr_rxrpc	srx;		/* local address */
 };
 
@@ -386,7 +386,6 @@ enum rxrpc_call_completion {
  * Bits in the connection flags.
  */
 enum rxrpc_conn_flag {
-	RXRPC_CONN_HAS_IDR,		/* Has a client conn ID assigned */
 	RXRPC_CONN_IN_SERVICE_CONNS,	/* Conn is in peer->service_conns */
 	RXRPC_CONN_DONT_REUSE,		/* Don't reuse this connection */
 	RXRPC_CONN_PROBING_FOR_UPGRADE,	/* Probing for service upgrade */
@@ -414,6 +413,7 @@ enum rxrpc_conn_event {
  */
 enum rxrpc_conn_proto_state {
 	RXRPC_CONN_UNUSED,		/* Connection not yet attempted */
+	RXRPC_CONN_CLIENT_UNSECURED,	/* Client connection needs security init */
 	RXRPC_CONN_CLIENT,		/* Client connection */
 	RXRPC_CONN_SERVICE_PREALLOC,	/* Service connection preallocation */
 	RXRPC_CONN_SERVICE_UNSECURED,	/* Service unsecured connection */
@@ -437,11 +437,9 @@ struct rxrpc_bundle {
 	u32			security_level;	/* Security level selected */
 	u16			service_id;	/* Service ID for this connection */
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
-	bool			alloc_conn;	/* True if someone's getting a conn */
 	bool			exclusive;	/* T if conn is exclusive */
 	bool			upgrade;	/* T if service ID can be upgraded */
-	short			alloc_error;	/* Error from last conn allocation */
-	spinlock_t		channel_lock;
+	unsigned short		alloc_error;	/* Error from last conn allocation */
 	struct rb_node		local_node;	/* Node in local->client_conns */
 	struct list_head	waiting_calls;	/* Calls waiting for channels */
 	unsigned long		avail_chans;	/* Mask of available channels */
@@ -469,7 +467,7 @@ struct rxrpc_connection {
 	unsigned char		act_chans;	/* Mask of active channels */
 	struct rxrpc_channel {
 		unsigned long		final_ack_at;	/* Time at which to issue final ACK */
-		struct rxrpc_call __rcu	*call;		/* Active call */
+		struct rxrpc_call	*call;		/* Active call */
 		unsigned int		call_debug_id;	/* call->debug_id */
 		u32			call_id;	/* ID of current call */
 		u32			call_counter;	/* Call ID counter */
@@ -490,6 +488,7 @@ struct rxrpc_connection {
 	struct list_head	link;		/* link in master connection list */
 	struct sk_buff_head	rx_queue;	/* received conn-level packets */
 
+	struct mutex		security_lock;	/* Lock for security management */
 	const struct rxrpc_security *security;	/* applied security module */
 	union {
 		struct {
@@ -620,7 +619,7 @@ struct rxrpc_call {
 	struct work_struct	destroyer;	/* In-process-context destroyer */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
 	struct list_head	link;		/* link in master call list */
-	struct list_head	chan_wait_link;	/* Link in conn->bundle->waiting_calls */
+	struct list_head	wait_link;	/* Link in local->new_client_calls */
 	struct hlist_node	error_link;	/* link in error distribution list */
 	struct list_head	accept_link;	/* Link in rx->acceptq */
 	struct list_head	recvmsg_link;	/* Link in rx->recvmsg_q */
@@ -867,6 +866,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *,
 					 struct sockaddr_rxrpc *,
 					 struct rxrpc_call_params *, gfp_t,
 					 unsigned int);
+void rxrpc_start_call_timer(struct rxrpc_call *);
 void rxrpc_incoming_call(struct rxrpc_sock *, struct rxrpc_call *,
 			 struct sk_buff *);
 void rxrpc_release_call(struct rxrpc_sock *, struct rxrpc_call *);
@@ -901,6 +901,7 @@ static inline void rxrpc_set_call_state(struct rxrpc_call *call,
 {
 	/* Order write of completion info before write of ->state. */
 	smp_store_release(&call->_state, state);
+	wake_up(&call->waitq);
 }
 
 static inline enum rxrpc_call_state __rxrpc_call_state(const struct rxrpc_call *call)
@@ -936,10 +937,11 @@ extern unsigned int rxrpc_reap_client_connections;
 extern unsigned long rxrpc_conn_idle_client_expiry;
 extern unsigned long rxrpc_conn_idle_client_fast_expiry;
 
-void rxrpc_destroy_client_conn_ids(struct rxrpc_local *);
+void rxrpc_purge_client_connections(struct rxrpc_local *);
 struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
 void rxrpc_put_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
-int rxrpc_connect_call(struct rxrpc_call *, gfp_t);
+int rxrpc_look_up_bundle(struct rxrpc_call *, gfp_t);
+void rxrpc_connect_client_calls(struct rxrpc_local *);
 void rxrpc_expose_client_call(struct rxrpc_call *);
 void rxrpc_disconnect_client_call(struct rxrpc_bundle *, struct rxrpc_call *);
 void rxrpc_deactivate_bundle(struct rxrpc_bundle *);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 88b9c4f5b122..6fed91fa848f 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -150,7 +150,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	timer_setup(&call->timer, rxrpc_call_timer_expired, 0);
 	INIT_WORK(&call->destroyer, rxrpc_destroy_call);
 	INIT_LIST_HEAD(&call->link);
-	INIT_LIST_HEAD(&call->chan_wait_link);
+	INIT_LIST_HEAD(&call->wait_link);
 	INIT_LIST_HEAD(&call->accept_link);
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
@@ -243,7 +243,7 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 /*
  * Initiate the call ack/resend/expiry timer.
  */
-static void rxrpc_start_call_timer(struct rxrpc_call *call)
+void rxrpc_start_call_timer(struct rxrpc_call *call)
 {
 	unsigned long now = jiffies;
 	unsigned long j = now + MAX_JIFFY_OFFSET;
@@ -287,6 +287,39 @@ static void rxrpc_put_call_slot(struct rxrpc_call *call)
 	up(limiter);
 }
 
+/*
+ * Start the process of connecting a call.  We obtain a peer and a connection
+ * bundle, but the actual association of a call with a connection is offloaded
+ * to the I/O thread to simplify locking.
+ */
+static int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
+{
+	struct rxrpc_local *local = call->local;
+	int ret = 0;
+
+	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
+
+	call->peer = rxrpc_lookup_peer(local, &call->dest_srx, gfp);
+	if (!call->peer)
+		goto error;
+
+	ret = rxrpc_look_up_bundle(call, gfp);
+	if (ret < 0)
+		goto error;
+
+	trace_rxrpc_client(NULL, -1, rxrpc_client_queue_new_call);
+	rxrpc_get_call(call, rxrpc_call_get_io_thread);
+	spin_lock(&local->client_call_lock);
+	list_add_tail(&call->wait_link, &local->new_client_calls);
+	spin_unlock(&local->client_call_lock);
+	rxrpc_wake_up_io_thread(local);
+	return 0;
+
+error:
+	__set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+	return ret;
+}
+
 /*
  * Set up a call for the given parameters.
  * - Called with the socket lock held, which it must release.
@@ -370,10 +403,6 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	if (ret < 0)
 		goto error_attached_to_socket;
 
-	rxrpc_see_call(call, rxrpc_call_see_connected);
-
-	rxrpc_start_call_timer(call);
-
 	_leave(" = %p [new]", call);
 	return call;
 
@@ -388,22 +417,20 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, -EEXIST);
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), 0,
 			 rxrpc_call_see_userid_exists);
-	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put_userid_exists);
 	_leave(" = -EEXIST");
 	return ERR_PTR(-EEXIST);
 
 	/* We got an error, but the call is attached to the socket and is in
-	 * need of release.  However, we might now race with recvmsg() when
-	 * completing the call queues it.  Return 0 from sys_sendmsg() and
+	 * need of release.  However, we might now race with recvmsg() when it
+	 * completion notifies the socket.  Return 0 from sys_sendmsg() and
 	 * leave the error to recvmsg() to deal with.
 	 */
 error_attached_to_socket:
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), ret,
 			 rxrpc_call_see_connect_failed);
-	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
-	rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, ret);
+	rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
 	_leave(" = c=%08x [err]", call->debug_id);
 	return call;
 }
@@ -458,7 +485,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	chan = sp->hdr.cid & RXRPC_CHANNELMASK;
 	conn->channels[chan].call_counter = call->call_id;
 	conn->channels[chan].call_id = call->call_id;
-	rcu_assign_pointer(conn->channels[chan].call, call);
+	conn->channels[chan].call = call;
 	spin_unlock(&conn->state_lock);
 
 	spin_lock(&conn->peer->lock);
@@ -518,7 +545,7 @@ static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 {
 	struct rxrpc_connection *conn = call->conn;
-	bool put = false;
+	bool put = false, putu = false;
 
 	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
@@ -553,7 +580,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	if (test_and_clear_bit(RXRPC_CALL_HAS_USERID, &call->flags)) {
 		rb_erase(&call->sock_node, &rx->calls);
 		memset(&call->sock_node, 0xdd, sizeof(call->sock_node));
-		rxrpc_put_call(call, rxrpc_call_put_userid_exists);
+		putu = true;
 	}
 
 	list_del(&call->sock_link);
@@ -561,6 +588,9 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
+	if (putu)
+		rxrpc_put_call(call, rxrpc_call_put_userid);
+
 	_leave("");
 }
 
diff --git a/net/rxrpc/call_state.c b/net/rxrpc/call_state.c
index c1f131618ac4..59a5588805ac 100644
--- a/net/rxrpc/call_state.c
+++ b/net/rxrpc/call_state.c
@@ -65,5 +65,5 @@ void rxrpc_prefail_call(struct rxrpc_call *call, enum rxrpc_call_completion comp
 	call->completion	= compl;
 	call->_state		= RXRPC_CALL_COMPLETE;
 	trace_rxrpc_call_complete(call);
-	__set_bit(RXRPC_CALL_RELEASED, &call->flags);
+	WARN_ON_ONCE(__test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags));
 }
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 6b6b2f72c0ed..6268e9bb9649 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -39,61 +39,19 @@ static void rxrpc_activate_bundle(struct rxrpc_bundle *bundle)
 	atomic_inc(&bundle->active);
 }
 
-/*
- * Get a connection ID and epoch for a client connection from the global pool.
- * The connection struct pointer is then recorded in the idr radix tree.  The
- * epoch doesn't change until the client is rebooted (or, at least, unless the
- * module is unloaded).
- */
-static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
-					  gfp_t gfp)
-{
-	struct rxrpc_local *local = conn->local;
-	int id;
-
-	_enter("");
-
-	idr_preload(gfp);
-	spin_lock(&local->conn_lock);
-
-	id = idr_alloc_cyclic(&local->conn_ids, conn,
-			      1, 0x40000000, GFP_NOWAIT);
-	if (id < 0)
-		goto error;
-
-	spin_unlock(&local->conn_lock);
-	idr_preload_end();
-
-	conn->proto.epoch = local->rxnet->epoch;
-	conn->proto.cid = id << RXRPC_CIDSHIFT;
-	set_bit(RXRPC_CONN_HAS_IDR, &conn->flags);
-	_leave(" [CID %x]", conn->proto.cid);
-	return 0;
-
-error:
-	spin_unlock(&local->conn_lock);
-	idr_preload_end();
-	_leave(" = %d", id);
-	return id;
-}
-
 /*
  * Release a connection ID for a client connection.
  */
 static void rxrpc_put_client_connection_id(struct rxrpc_local *local,
 					   struct rxrpc_connection *conn)
 {
-	if (test_bit(RXRPC_CONN_HAS_IDR, &conn->flags)) {
-		spin_lock(&local->conn_lock);
-		idr_remove(&local->conn_ids, conn->proto.cid >> RXRPC_CIDSHIFT);
-		spin_unlock(&local->conn_lock);
-	}
+	idr_remove(&local->conn_ids, conn->proto.cid >> RXRPC_CIDSHIFT);
 }
 
 /*
  * Destroy the client connection ID tree.
  */
-void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local)
+static void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local)
 {
 	struct rxrpc_connection *conn;
 	int id;
@@ -129,7 +87,6 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_call *call,
 		bundle->security_level	= call->security_level;
 		refcount_set(&bundle->ref, 1);
 		atomic_set(&bundle->active, 1);
-		spin_lock_init(&bundle->channel_lock);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
 		trace_rxrpc_bundle(bundle->debug_id, 1, rxrpc_bundle_new);
 	}
@@ -169,69 +126,68 @@ void rxrpc_put_bundle(struct rxrpc_bundle *bundle, enum rxrpc_bundle_trace why)
 	}
 }
 
+/*
+ * Get rid of outstanding client connection preallocations when a local
+ * endpoint is destroyed.
+ */
+void rxrpc_purge_client_connections(struct rxrpc_local *local)
+{
+	rxrpc_destroy_client_conn_ids(local);
+}
+
 /*
  * Allocate a client connection.
  */
 static struct rxrpc_connection *
-rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
+rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_net *rxnet = bundle->local->rxnet;
-	int ret;
+	struct rxrpc_local *local = bundle->local;
+	struct rxrpc_net *rxnet = local->rxnet;
+	int id;
 
 	_enter("");
 
-	conn = rxrpc_alloc_connection(rxnet, gfp);
-	if (!conn) {
-		_leave(" = -ENOMEM");
+	conn = rxrpc_alloc_connection(rxnet, GFP_ATOMIC | __GFP_NOWARN);
+	if (!conn)
 		return ERR_PTR(-ENOMEM);
+
+	id = idr_alloc_cyclic(&local->conn_ids, conn, 1, 0x40000000,
+			      GFP_ATOMIC | __GFP_NOWARN);
+	if (id < 0) {
+		kfree(conn);
+		return ERR_PTR(id);
 	}
 
 	refcount_set(&conn->ref, 1);
-	conn->bundle		= bundle;
-	conn->local		= bundle->local;
-	conn->peer		= bundle->peer;
-	conn->key		= bundle->key;
+	conn->proto.cid		= id << RXRPC_CIDSHIFT;
+	conn->proto.epoch	= local->rxnet->epoch;
+	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
+	conn->bundle		= rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_conn);
+	conn->local		= rxrpc_get_local(bundle->local, rxrpc_local_get_client_conn);
+	conn->peer		= rxrpc_get_peer(bundle->peer, rxrpc_peer_get_client_conn);
+	conn->key		= key_get(bundle->key);
+	conn->security		= bundle->security;
 	conn->exclusive		= bundle->exclusive;
 	conn->upgrade		= bundle->upgrade;
 	conn->orig_service_id	= bundle->service_id;
 	conn->security_level	= bundle->security_level;
-	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
-	conn->state		= RXRPC_CONN_CLIENT;
+	conn->state		= RXRPC_CONN_CLIENT_UNSECURED;
 	conn->service_id	= conn->orig_service_id;
 
-	ret = rxrpc_get_client_connection_id(conn, gfp);
-	if (ret < 0)
-		goto error_0;
-
-	ret = rxrpc_init_client_conn_security(conn);
-	if (ret < 0)
-		goto error_1;
+	if (conn->security == &rxrpc_no_security)
+		conn->state	= RXRPC_CONN_CLIENT;
 
 	atomic_inc(&rxnet->nr_conns);
 	write_lock(&rxnet->conn_lock);
 	list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
 	write_unlock(&rxnet->conn_lock);
 
-	rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_conn);
-	rxrpc_get_peer(conn->peer, rxrpc_peer_get_client_conn);
-	rxrpc_get_local(conn->local, rxrpc_local_get_client_conn);
-	key_get(conn->key);
-
-	trace_rxrpc_conn(conn->debug_id, refcount_read(&conn->ref),
-			 rxrpc_conn_new_client);
+	rxrpc_see_connection(conn, rxrpc_conn_new_client);
 
 	atomic_inc(&rxnet->nr_client_conns);
 	trace_rxrpc_client(conn, -1, rxrpc_client_alloc);
-	_leave(" = %p", conn);
 	return conn;
-
-error_1:
-	rxrpc_put_client_connection_id(bundle->local, conn);
-error_0:
-	kfree(conn);
-	_leave(" = %d", ret);
-	return ERR_PTR(ret);
 }
 
 /*
@@ -249,7 +205,8 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	if (test_bit(RXRPC_CONN_DONT_REUSE, &conn->flags))
 		goto dont_reuse;
 
-	if (conn->state != RXRPC_CONN_CLIENT ||
+	if ((conn->state != RXRPC_CONN_CLIENT_UNSECURED &&
+	     conn->state != RXRPC_CONN_CLIENT) ||
 	    conn->proto.epoch != rxnet->epoch)
 		goto mark_dont_reuse;
 
@@ -280,7 +237,7 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
  * Look up the conn bundle that matches the connection parameters, adding it if
  * it doesn't yet exist.
  */
-static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t gfp)
+int rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t gfp)
 {
 	static atomic_t rxrpc_bundle_id;
 	struct rxrpc_bundle *bundle, *candidate;
@@ -295,7 +252,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t
 
 	if (test_bit(RXRPC_CALL_EXCLUSIVE, &call->flags)) {
 		call->bundle = rxrpc_alloc_bundle(call, gfp);
-		return call->bundle;
+		return call->bundle ? 0 : -ENOMEM;
 	}
 
 	/* First, see if the bundle is already there. */
@@ -324,7 +281,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t
 	/* It wasn't.  We need to add one. */
 	candidate = rxrpc_alloc_bundle(call, gfp);
 	if (!candidate)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	_debug("search 2");
 	spin_lock(&local->client_bundles_lock);
@@ -355,7 +312,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t
 	call->bundle = rxrpc_get_bundle(candidate, rxrpc_bundle_get_client_call);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = B=%u [new]", call->bundle->debug_id);
-	return call->bundle;
+	return 0;
 
 found_bundle_free:
 	rxrpc_free_bundle(candidate);
@@ -364,160 +321,77 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t
 	rxrpc_activate_bundle(bundle);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = B=%u [found]", call->bundle->debug_id);
-	return call->bundle;
-}
-
-/*
- * Create or find a client bundle to use for a call.
- *
- * If we return with a connection, the call will be on its waiting list.  It's
- * left to the caller to assign a channel and wake up the call.
- */
-static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_call *call, gfp_t gfp)
-{
-	struct rxrpc_bundle *bundle;
-
-	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
-
-	call->peer = rxrpc_lookup_peer(call->local, &call->dest_srx, gfp);
-	if (!call->peer)
-		goto error;
-
-	call->tx_last_sent = ktime_get_real();
-	call->cong_ssthresh = call->peer->cong_ssthresh;
-	if (call->cong_cwnd >= call->cong_ssthresh)
-		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
-	else
-		call->cong_mode = RXRPC_CALL_SLOW_START;
-
-	/* Find the client connection bundle. */
-	bundle = rxrpc_look_up_bundle(call, gfp);
-	if (!bundle)
-		goto error;
-
-	/* Get this call queued.  Someone else may activate it whilst we're
-	 * lining up a new connection, but that's fine.
-	 */
-	spin_lock(&bundle->channel_lock);
-	list_add_tail(&call->chan_wait_link, &bundle->waiting_calls);
-	spin_unlock(&bundle->channel_lock);
-
-	_leave(" = [B=%x]", bundle->debug_id);
-	return bundle;
-
-error:
-	_leave(" = -ENOMEM");
-	return ERR_PTR(-ENOMEM);
+	return 0;
 }
 
 /*
  * Allocate a new connection and add it into a bundle.
  */
-static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
-	__releases(bundle->channel_lock)
+static bool rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle,
+				     unsigned int slot)
 {
-	struct rxrpc_connection *candidate = NULL, *old = NULL;
-	bool conflict;
-	int i;
-
-	_enter("");
-
-	conflict = bundle->alloc_conn;
-	if (!conflict)
-		bundle->alloc_conn = true;
-	spin_unlock(&bundle->channel_lock);
-	if (conflict) {
-		_leave(" [conf]");
-		return;
-	}
-
-	candidate = rxrpc_alloc_client_connection(bundle, gfp);
-
-	spin_lock(&bundle->channel_lock);
-	bundle->alloc_conn = false;
-
-	if (IS_ERR(candidate)) {
-		bundle->alloc_error = PTR_ERR(candidate);
-		spin_unlock(&bundle->channel_lock);
-		_leave(" [err %ld]", PTR_ERR(candidate));
-		return;
-	}
-
-	bundle->alloc_error = 0;
+	struct rxrpc_connection *conn, *old;
+	unsigned int shift = slot * RXRPC_MAXCALLS;
+	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(bundle->conns); i++) {
-		unsigned int shift = i * RXRPC_MAXCALLS;
-		int j;
-
-		old = bundle->conns[i];
-		if (!rxrpc_may_reuse_conn(old)) {
-			if (old)
-				trace_rxrpc_client(old, -1, rxrpc_client_replace);
-			candidate->bundle_shift = shift;
-			rxrpc_activate_bundle(bundle);
-			bundle->conns[i] = candidate;
-			for (j = 0; j < RXRPC_MAXCALLS; j++)
-				set_bit(shift + j, &bundle->avail_chans);
-			candidate = NULL;
-			break;
-		}
-
-		old = NULL;
+	old = bundle->conns[slot];
+	if (old) {
+		bundle->conns[slot] = NULL;
+		trace_rxrpc_client(old, -1, rxrpc_client_replace);
+		rxrpc_put_connection(old, rxrpc_conn_put_noreuse);
 	}
 
-	spin_unlock(&bundle->channel_lock);
-
-	if (candidate) {
-		_debug("discard C=%x", candidate->debug_id);
-		trace_rxrpc_client(candidate, -1, rxrpc_client_duplicate);
-		rxrpc_put_connection(candidate, rxrpc_conn_put_discard);
+	conn = rxrpc_alloc_client_connection(bundle);
+	if (IS_ERR(conn)) {
+		bundle->alloc_error = PTR_ERR(conn);
+		return false;
 	}
 
-	rxrpc_put_connection(old, rxrpc_conn_put_noreuse);
-	_leave("");
+	rxrpc_activate_bundle(bundle);
+	conn->bundle_shift = shift;
+	bundle->conns[slot] = conn;
+	for (i = 0; i < RXRPC_MAXCALLS; i++)
+		set_bit(shift + i, &bundle->avail_chans);
+	return true;
 }
 
 /*
  * Add a connection to a bundle if there are no usable connections or we have
  * connections waiting for extra capacity.
  */
-static void rxrpc_maybe_add_conn(struct rxrpc_bundle *bundle, gfp_t gfp)
+static bool rxrpc_bundle_has_space(struct rxrpc_bundle *bundle)
 {
-	struct rxrpc_call *call;
-	int i, usable;
+	int slot = -1, i, usable;
 
 	_enter("");
 
-	spin_lock(&bundle->channel_lock);
+	bundle->alloc_error = 0;
 
 	/* See if there are any usable connections. */
 	usable = 0;
-	for (i = 0; i < ARRAY_SIZE(bundle->conns); i++)
+	for (i = 0; i < ARRAY_SIZE(bundle->conns); i++) {
 		if (rxrpc_may_reuse_conn(bundle->conns[i]))
 			usable++;
-
-	if (!usable && !list_empty(&bundle->waiting_calls)) {
-		call = list_first_entry(&bundle->waiting_calls,
-					struct rxrpc_call, chan_wait_link);
-		if (test_bit(RXRPC_CALL_UPGRADE, &call->flags))
-			bundle->try_upgrade = true;
+		else if (slot == -1)
+			slot = i;
 	}
 
+	if (!usable && bundle->upgrade)
+		bundle->try_upgrade = true;
+
 	if (!usable)
 		goto alloc_conn;
 
 	if (!bundle->avail_chans &&
 	    !bundle->try_upgrade &&
-	    !list_empty(&bundle->waiting_calls) &&
 	    usable < ARRAY_SIZE(bundle->conns))
 		goto alloc_conn;
 
-	spin_unlock(&bundle->channel_lock);
 	_leave("");
-	return;
+	return usable;
 
 alloc_conn:
-	return rxrpc_add_conn_to_bundle(bundle, gfp);
+	return slot >= 0 ? rxrpc_add_conn_to_bundle(bundle, slot) : false;
 }
 
 /*
@@ -531,11 +405,13 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	struct rxrpc_channel *chan = &conn->channels[channel];
 	struct rxrpc_bundle *bundle = conn->bundle;
 	struct rxrpc_call *call = list_entry(bundle->waiting_calls.next,
-					     struct rxrpc_call, chan_wait_link);
+					     struct rxrpc_call, wait_link);
 	u32 call_id = chan->call_counter + 1;
 
 	_enter("C=%x,%u", conn->debug_id, channel);
 
+	list_del_init(&call->wait_link);
+
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_activate);
 
 	/* Cancel the final ACK on the previous call if it hasn't been sent yet
@@ -545,65 +421,50 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	clear_bit(conn->bundle_shift + channel, &bundle->avail_chans);
 
 	rxrpc_see_call(call, rxrpc_call_see_activate_client);
-	list_del_init(&call->chan_wait_link);
 	call->conn	= rxrpc_get_connection(conn, rxrpc_conn_get_activate_call);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
 	call->dest_srx.srx_service = conn->service_id;
-
-	trace_rxrpc_connect_call(call);
-
-	rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_SEND_REQUEST);
-
-	/* Paired with the read barrier in rxrpc_connect_call().  This orders
-	 * cid and epoch in the connection wrt to call_id without the need to
-	 * take the channel_lock.
-	 *
-	 * We provisionally assign a callNumber at this point, but we don't
-	 * confirm it until the call is about to be exposed.
-	 *
-	 * TODO: Pair with a barrier in the data_ready handler when that looks
-	 * at the call ID through a connection channel.
-	 */
-	smp_wmb();
+	call->cong_ssthresh = call->peer->cong_ssthresh;
+	if (call->cong_cwnd >= call->cong_ssthresh)
+		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
+	else
+		call->cong_mode = RXRPC_CALL_SLOW_START;
 
 	chan->call_id		= call_id;
 	chan->call_debug_id	= call->debug_id;
-	rcu_assign_pointer(chan->call, call);
+	chan->call		= call;
+
+	rxrpc_see_call(call, rxrpc_call_see_connected);
+	trace_rxrpc_connect_call(call);
+	call->tx_last_sent = ktime_get_real();
+	rxrpc_start_call_timer(call);
+	rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_SEND_REQUEST);
 	wake_up(&call->waitq);
 }
 
 /*
  * Remove a connection from the idle list if it's on it.
  */
-static void rxrpc_unidle_conn(struct rxrpc_bundle *bundle, struct rxrpc_connection *conn)
+static void rxrpc_unidle_conn(struct rxrpc_connection *conn)
 {
-	struct rxrpc_local *local = bundle->local;
-	bool drop_ref;
-
 	if (!list_empty(&conn->cache_link)) {
-		drop_ref = false;
-		spin_lock(&local->client_conn_cache_lock);
-		if (!list_empty(&conn->cache_link)) {
-			list_del_init(&conn->cache_link);
-			drop_ref = true;
-		}
-		spin_unlock(&local->client_conn_cache_lock);
-		if (drop_ref)
-			rxrpc_put_connection(conn, rxrpc_conn_put_unidle);
+		list_del_init(&conn->cache_link);
+		rxrpc_put_connection(conn, rxrpc_conn_put_unidle);
 	}
 }
 
 /*
- * Assign channels and callNumbers to waiting calls with channel_lock
- * held by caller.
+ * Assign channels and callNumbers to waiting calls.
  */
-static void rxrpc_activate_channels_locked(struct rxrpc_bundle *bundle)
+static void rxrpc_activate_channels(struct rxrpc_bundle *bundle)
 {
 	struct rxrpc_connection *conn;
 	unsigned long avail, mask;
 	unsigned int channel, slot;
 
+	trace_rxrpc_client(NULL, -1, rxrpc_client_activate_chans);
+
 	if (bundle->try_upgrade)
 		mask = 1;
 	else
@@ -623,7 +484,7 @@ static void rxrpc_activate_channels_locked(struct rxrpc_bundle *bundle)
 
 		if (bundle->try_upgrade)
 			set_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags);
-		rxrpc_unidle_conn(bundle, conn);
+		rxrpc_unidle_conn(conn);
 
 		channel &= (RXRPC_MAXCALLS - 1);
 		conn->act_chans	|= 1 << channel;
@@ -632,125 +493,24 @@ static void rxrpc_activate_channels_locked(struct rxrpc_bundle *bundle)
 }
 
 /*
- * Assign channels and callNumbers to waiting calls.
+ * Connect waiting channels (called from the I/O thread).
  */
-static void rxrpc_activate_channels(struct rxrpc_bundle *bundle)
-{
-	_enter("B=%x", bundle->debug_id);
-
-	trace_rxrpc_client(NULL, -1, rxrpc_client_activate_chans);
-
-	if (!bundle->avail_chans)
-		return;
-
-	spin_lock(&bundle->channel_lock);
-	rxrpc_activate_channels_locked(bundle);
-	spin_unlock(&bundle->channel_lock);
-	_leave("");
-}
-
-/*
- * Wait for a callNumber and a channel to be granted to a call.
- */
-static int rxrpc_wait_for_channel(struct rxrpc_bundle *bundle,
-				  struct rxrpc_call *call, gfp_t gfp)
+void rxrpc_connect_client_calls(struct rxrpc_local *local)
 {
-	DECLARE_WAITQUEUE(myself, current);
-	int ret = 0;
-
-	_enter("%d", call->debug_id);
-
-	if (!gfpflags_allow_blocking(gfp)) {
-		rxrpc_maybe_add_conn(bundle, gfp);
-		rxrpc_activate_channels(bundle);
-		ret = bundle->alloc_error ?: -EAGAIN;
-		goto out;
-	}
-
-	add_wait_queue_exclusive(&call->waitq, &myself);
-	for (;;) {
-		rxrpc_maybe_add_conn(bundle, gfp);
-		rxrpc_activate_channels(bundle);
-		ret = bundle->alloc_error;
-		if (ret < 0)
-			break;
-
-		switch (call->interruptibility) {
-		case RXRPC_INTERRUPTIBLE:
-		case RXRPC_PREINTERRUPTIBLE:
-			set_current_state(TASK_INTERRUPTIBLE);
-			break;
-		case RXRPC_UNINTERRUPTIBLE:
-		default:
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			break;
-		}
-		if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN)
-			break;
-		if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
-		     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
-		    signal_pending(current)) {
-			ret = -ERESTARTSYS;
-			break;
-		}
-		schedule();
-	}
-	remove_wait_queue(&call->waitq, &myself);
-	__set_current_state(TASK_RUNNING);
-
-out:
-	_leave(" = %d", ret);
-	return ret;
-}
-
-/*
- * find a connection for a call
- * - called in process context with IRQs enabled
- */
-int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
-{
-	struct rxrpc_bundle *bundle;
-	int ret = 0;
-
-	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
-
-	rxrpc_get_call(call, rxrpc_call_get_io_thread);
-
-	bundle = rxrpc_prep_call(call, gfp);
-	if (IS_ERR(bundle)) {
-		rxrpc_put_call(call, rxrpc_call_get_io_thread);
-		ret = PTR_ERR(bundle);
-		goto out;
-	}
-
-	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_AWAIT_CONN) {
-		ret = rxrpc_wait_for_channel(bundle, call, gfp);
-		if (ret < 0)
-			goto wait_failed;
-	}
-
-granted_channel:
-	/* Paired with the write barrier in rxrpc_activate_one_channel(). */
-	smp_rmb();
+	struct rxrpc_call *call;
 
-out:
-	_leave(" = %d", ret);
-	return ret;
+	while ((call = list_first_entry_or_null(&local->new_client_calls,
+						struct rxrpc_call, wait_link))
+	       ) {
+		struct rxrpc_bundle *bundle = call->bundle;
 
-wait_failed:
-	spin_lock(&bundle->channel_lock);
-	list_del_init(&call->chan_wait_link);
-	spin_unlock(&bundle->channel_lock);
+		spin_lock(&local->client_call_lock);
+		list_move_tail(&call->wait_link, &bundle->waiting_calls);
+		spin_unlock(&local->client_call_lock);
 
-	if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN) {
-		ret = 0;
-		goto granted_channel;
+		if (rxrpc_bundle_has_space(bundle))
+			rxrpc_activate_channels(bundle);
 	}
-
-	trace_rxrpc_client(call->conn, ret, rxrpc_client_chan_wait_failed);
-	rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
-	rxrpc_disconnect_client_call(bundle, call);
-	goto out;
 }
 
 /*
@@ -808,7 +568,6 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 
 	_enter("c=%x", call->debug_id);
 
-	spin_lock(&bundle->channel_lock);
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	/* Calls that have never actually been assigned a channel can simply be
@@ -819,7 +578,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 		_debug("call is waiting");
 		ASSERTCMP(call->call_id, ==, 0);
 		ASSERT(!test_bit(RXRPC_CALL_EXPOSED, &call->flags));
-		list_del_init(&call->chan_wait_link);
+		list_del_init(&call->wait_link);
 		goto out;
 	}
 
@@ -828,10 +587,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 	chan = &conn->channels[channel];
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
 
-	if (rcu_access_pointer(chan->call) != call) {
-		spin_unlock(&bundle->channel_lock);
-		BUG();
-	}
+	BUG_ON(chan->call != call);
 
 	may_reuse = rxrpc_may_reuse_conn(conn);
 
@@ -852,9 +608,8 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 			trace_rxrpc_client(conn, channel, rxrpc_client_to_active);
 			bundle->try_upgrade = false;
 			if (may_reuse)
-				rxrpc_activate_channels_locked(bundle);
+				rxrpc_activate_channels(bundle);
 		}
-
 	}
 
 	/* See if we can pass the channel directly to another call. */
@@ -879,7 +634,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 	}
 
 	/* Deactivate the channel. */
-	rcu_assign_pointer(chan->call, NULL);
+	chan->call = NULL;
 	set_bit(conn->bundle_shift + channel, &conn->bundle->avail_chans);
 	conn->act_chans	&= ~(1 << channel);
 
@@ -892,15 +647,12 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 		conn->idle_timestamp = jiffies;
 
 		rxrpc_get_connection(conn, rxrpc_conn_get_idle);
-		spin_lock(&local->client_conn_cache_lock);
 		list_move_tail(&conn->cache_link, &local->idle_client_conns);
-		spin_unlock(&local->client_conn_cache_lock);
 
 		rxrpc_set_client_reap_timer(local);
 	}
 
 out:
-	spin_unlock(&bundle->channel_lock);
 	rxrpc_put_call(call, rxrpc_call_put_io_thread);
 	_leave("");
 	return;
@@ -913,7 +665,6 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_bundle *bundle = conn->bundle;
 	unsigned int bindex;
-	bool need_drop = false;
 	int i;
 
 	_enter("C=%x", conn->debug_id);
@@ -921,18 +672,13 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
 		rxrpc_process_delayed_final_acks(conn, true);
 
-	spin_lock(&bundle->channel_lock);
 	bindex = conn->bundle_shift / RXRPC_MAXCALLS;
 	if (bundle->conns[bindex] == conn) {
 		_debug("clear slot %u", bindex);
 		bundle->conns[bindex] = NULL;
 		for (i = 0; i < RXRPC_MAXCALLS; i++)
 			clear_bit(conn->bundle_shift + i, &bundle->avail_chans);
-		need_drop = true;
-	}
-	spin_unlock(&bundle->channel_lock);
-
-	if (need_drop) {
+		rxrpc_put_client_connection_id(bundle->local, conn);
 		rxrpc_deactivate_bundle(bundle);
 		rxrpc_put_connection(conn, rxrpc_conn_put_unbundle);
 	}
@@ -994,24 +740,16 @@ void rxrpc_discard_expired_client_conns(struct rxrpc_local *local)
 
 	_enter("");
 
-	if (list_empty(&local->idle_client_conns)) {
-		_leave(" [empty]");
-		return;
-	}
-
 	/* We keep an estimate of what the number of conns ought to be after
 	 * we've discarded some so that we don't overdo the discarding.
 	 */
 	nr_conns = atomic_read(&local->rxnet->nr_client_conns);
 
 next:
-	spin_lock(&local->client_conn_cache_lock);
-
-	if (list_empty(&local->idle_client_conns))
-		goto out;
-
-	conn = list_entry(local->idle_client_conns.next,
-			  struct rxrpc_connection, cache_link);
+	conn = list_first_entry_or_null(&local->idle_client_conns,
+					struct rxrpc_connection, cache_link);
+	if (!conn)
+		return;
 
 	if (!local->kill_all_client_conns) {
 		/* If the number of connections is over the reap limit, we
@@ -1036,8 +774,6 @@ void rxrpc_discard_expired_client_conns(struct rxrpc_local *local)
 	trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 	list_del_init(&conn->cache_link);
 
-	spin_unlock(&local->client_conn_cache_lock);
-
 	rxrpc_unbundle_conn(conn);
 	/* Drop the ->cache_link ref */
 	rxrpc_put_connection(conn, rxrpc_conn_put_discard_idle);
@@ -1057,8 +793,6 @@ void rxrpc_discard_expired_client_conns(struct rxrpc_local *local)
 	if (!local->kill_all_client_conns)
 		timer_reduce(&local->client_conn_reap_timer, conn_expires_at);
 
-out:
-	spin_unlock(&local->client_conn_cache_lock);
 	_leave("");
 }
 
@@ -1067,34 +801,19 @@ void rxrpc_discard_expired_client_conns(struct rxrpc_local *local)
  */
 void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 {
-	struct rxrpc_connection *conn, *tmp;
-	LIST_HEAD(graveyard);
+	struct rxrpc_connection *conn;
 
 	_enter("");
 
-	spin_lock(&local->client_conn_cache_lock);
 	local->kill_all_client_conns = true;
-	spin_unlock(&local->client_conn_cache_lock);
 
 	del_timer_sync(&local->client_conn_reap_timer);
 
-	spin_lock(&local->client_conn_cache_lock);
-
-	list_for_each_entry_safe(conn, tmp, &local->idle_client_conns,
-				 cache_link) {
-		if (conn->local == local) {
-			atomic_dec(&conn->active);
-			trace_rxrpc_client(conn, -1, rxrpc_client_discard);
-			list_move(&conn->cache_link, &graveyard);
-		}
-	}
-
-	spin_unlock(&local->client_conn_cache_lock);
-
-	while (!list_empty(&graveyard)) {
-		conn = list_entry(graveyard.next,
-				  struct rxrpc_connection, cache_link);
+	while ((conn = list_first_entry_or_null(&local->idle_client_conns,
+						struct rxrpc_connection, cache_link))) {
 		list_del_init(&conn->cache_link);
+		atomic_dec(&conn->active);
+		trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 		rxrpc_unbundle_conn(conn);
 		rxrpc_put_connection(conn, rxrpc_conn_put_local_dead);
 	}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 8009d7e62ae6..c8e7e1081020 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -100,9 +100,7 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 	/* If the last call got moved on whilst we were waiting to run, just
 	 * ignore this packet.
 	 */
-	call_id = READ_ONCE(chan->last_call);
-	/* Sync with __rxrpc_disconnect_call() */
-	smp_rmb();
+	call_id = chan->last_call;
 	if (skb && call_id != sp->hdr.callNumber)
 		return;
 
@@ -119,9 +117,12 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 	iov[2].iov_base	= &ack_info;
 	iov[2].iov_len	= sizeof(ack_info);
 
+	serial = atomic_inc_return(&conn->serial);
+
 	pkt.whdr.epoch		= htonl(conn->proto.epoch);
 	pkt.whdr.cid		= htonl(conn->proto.cid | channel);
 	pkt.whdr.callNumber	= htonl(call_id);
+	pkt.whdr.serial		= htonl(serial);
 	pkt.whdr.seq		= 0;
 	pkt.whdr.type		= chan->last_type;
 	pkt.whdr.flags		= conn->out_clientflag;
@@ -158,31 +159,15 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 		iov[0].iov_len += sizeof(pkt.ack);
 		len += sizeof(pkt.ack) + 3 + sizeof(ack_info);
 		ioc = 3;
-		break;
-
-	default:
-		return;
-	}
-
-	/* Resync with __rxrpc_disconnect_call() and check that the last call
-	 * didn't get advanced whilst we were filling out the packets.
-	 */
-	smp_rmb();
-	if (READ_ONCE(chan->last_call) != call_id)
-		return;
-
-	serial = atomic_inc_return(&conn->serial);
-	pkt.whdr.serial = htonl(serial);
 
-	switch (chan->last_type) {
-	case RXRPC_PACKET_TYPE_ABORT:
-		break;
-	case RXRPC_PACKET_TYPE_ACK:
 		trace_rxrpc_tx_ack(chan->call_debug_id, serial,
 				   ntohl(pkt.ack.firstPacket),
 				   ntohl(pkt.ack.serial),
 				   pkt.ack.reason, 0);
 		break;
+
+	default:
+		return;
 	}
 
 	ret = kernel_sendmsg(conn->local->socket, &msg, iov, ioc, len);
@@ -207,20 +192,14 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn)
 
 	_enter("{%d},%x", conn->debug_id, conn->abort_code);
 
-	spin_lock(&conn->bundle->channel_lock);
-
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
-		call = rcu_dereference_protected(
-			conn->channels[i].call,
-			lockdep_is_held(&conn->bundle->channel_lock));
-		if (call)
+		if ((call = conn->channels[i].call))
 			rxrpc_set_call_completion(call,
 						  conn->completion,
 						  conn->abort_code,
 						  conn->error);
 	}
 
-	spin_unlock(&conn->bundle->channel_lock);
 	_leave("");
 }
 
@@ -316,9 +295,7 @@ void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn, bool force)
 		if (!test_bit(RXRPC_CONN_FINAL_ACK_0 + channel, &conn->flags))
 			continue;
 
-		smp_rmb(); /* vs rxrpc_disconnect_client_call */
-		ack_at = READ_ONCE(chan->final_ack_at);
-
+		ack_at = chan->final_ack_at;
 		if (time_before(j, ack_at) && !force) {
 			if (time_before(ack_at, next_j)) {
 				next_j = ack_at;
@@ -446,15 +423,8 @@ void rxrpc_input_conn_event(struct rxrpc_connection *conn, struct sk_buff *skb)
 		if (conn->state != RXRPC_CONN_SERVICE)
 			break;
 
-		spin_lock(&conn->bundle->channel_lock);
-
 		for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
-			rxrpc_call_is_secure(
-				rcu_dereference_protected(
-					conn->channels[loop].call,
-					lockdep_is_held(&conn->bundle->channel_lock)));
-
-		spin_unlock(&conn->bundle->channel_lock);
+			rxrpc_call_is_secure(conn->channels[loop].call);
 		break;
 	}
 
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index ed591a1f82c2..c420a5e0cdd6 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -67,6 +67,7 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
 		INIT_WORK(&conn->destructor, rxrpc_clean_up_connection);
 		INIT_LIST_HEAD(&conn->proc_link);
 		INIT_LIST_HEAD(&conn->link);
+		mutex_init(&conn->security_lock);
 		skb_queue_head_init(&conn->rx_queue);
 		conn->rxnet = rxnet;
 		conn->security = &rxrpc_no_security;
@@ -157,7 +158,7 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 
 	_enter("%d,%x", conn->debug_id, call->cid);
 
-	if (rcu_access_pointer(chan->call) == call) {
+	if (chan->call == call) {
 		/* Save the result of the call so that we can repeat it if necessary
 		 * through the channel, whilst disposing of the actual call record.
 		 */
@@ -177,12 +178,9 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 			break;
 		}
 
-		/* Sync with rxrpc_conn_retransmit(). */
-		smp_wmb();
 		chan->last_call = chan->call_id;
 		chan->call_id = chan->call_counter;
-
-		rcu_assign_pointer(chan->call, NULL);
+		chan->call = NULL;
 	}
 
 	_leave("");
@@ -207,10 +205,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	if (rxrpc_is_client_call(call))
 		return rxrpc_disconnect_client_call(conn->bundle, call);
 
-	spin_lock(&conn->bundle->channel_lock);
 	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&conn->bundle->channel_lock);
-
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	conn->idle_timestamp = jiffies;
 	if (atomic_dec_and_test(&conn->active))
@@ -311,10 +306,10 @@ static void rxrpc_clean_up_connection(struct work_struct *work)
 		container_of(work, struct rxrpc_connection, destructor);
 	struct rxrpc_net *rxnet = conn->rxnet;
 
-	ASSERT(!rcu_access_pointer(conn->channels[0].call) &&
-	       !rcu_access_pointer(conn->channels[1].call) &&
-	       !rcu_access_pointer(conn->channels[2].call) &&
-	       !rcu_access_pointer(conn->channels[3].call));
+	ASSERT(!conn->channels[0].call &&
+	       !conn->channels[1].call &&
+	       !conn->channels[2].call &&
+	       !conn->channels[3].call);
 	ASSERT(list_empty(&conn->cache_link));
 
 	del_timer_sync(&conn->timer);
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 2a55a88b2a5b..f30323de82bd 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -11,7 +11,6 @@
 static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
 	.ref		= REFCOUNT_INIT(1),
 	.debug_id	= UINT_MAX,
-	.channel_lock	= __SPIN_LOCK_UNLOCKED(&rxrpc_service_dummy_bundle.channel_lock),
 };
 
 /*
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 6153ea162153..4990ab410b4d 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -376,10 +376,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 		return just_discard;
 	}
 
-	rcu_read_lock();
-	call = rxrpc_try_get_call(rcu_dereference(chan->call),
-				  rxrpc_call_get_input);
-	rcu_read_unlock();
+	call = rxrpc_try_get_call(chan->call, rxrpc_call_get_input);
 
 	if (sp->hdr.callNumber > chan->call_id) {
 		if (rxrpc_to_client(sp))
@@ -443,6 +440,9 @@ int rxrpc_io_thread(void *data)
 				       &local->client_conn_flags))
 			rxrpc_discard_expired_client_conns(local);
 
+		if (!list_empty(&local->new_client_calls))
+			rxrpc_connect_client_calls(local);
+
 		/* Deal with calls that want immediate attention. */
 		if ((call = list_first_entry_or_null(&local->call_attend_q,
 						     struct rxrpc_call,
@@ -506,7 +506,10 @@ int rxrpc_io_thread(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!skb_queue_empty(&local->rx_queue) ||
 		    !list_empty(&local->call_attend_q) ||
-		    !list_empty(&local->conn_attend_q)) {
+		    !list_empty(&local->conn_attend_q) ||
+		    !list_empty(&local->new_client_calls) ||
+		    test_bit(RXRPC_CLIENT_CONN_REAP_TIMER,
+			     &local->client_conn_flags)) {
 			__set_current_state(TASK_RUNNING);
 			continue;
 		}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 6a463e90cd8b..ca3e89684d8b 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -118,7 +118,6 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);
 		local->kill_all_client_conns = false;
-		spin_lock_init(&local->client_conn_cache_lock);
 		INIT_LIST_HEAD(&local->idle_client_conns);
 		timer_setup(&local->client_conn_reap_timer,
 			    rxrpc_client_conn_reap_timeout, 0);
@@ -134,7 +133,8 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		if (tmp == 0)
 			tmp = 1;
 		idr_set_cursor(&local->conn_ids, tmp);
-		spin_lock_init(&local->conn_lock);
+		INIT_LIST_HEAD(&local->new_client_calls);
+		spin_lock_init(&local->client_call_lock);
 
 		trace_rxrpc_local(local->debug_id, rxrpc_local_new, 1, 1);
 	}
@@ -437,7 +437,7 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	rxrpc_purge_queue(&local->rx_delay_queue);
 #endif
 	rxrpc_purge_queue(&local->rx_queue);
-	rxrpc_destroy_client_conn_ids(local);
+	rxrpc_purge_client_connections(local);
 }
 
 /*
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index e5cbe88daaa5..fdb0e11a583e 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -12,6 +12,7 @@
 
 static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
 	[RXRPC_CONN_UNUSED]			= "Unused  ",
+	[RXRPC_CONN_CLIENT_UNSECURED]		= "ClUnsec ",
 	[RXRPC_CONN_CLIENT]			= "Client  ",
 	[RXRPC_CONN_SERVICE_PREALLOC]		= "SvPrealc",
 	[RXRPC_CONN_SERVICE_UNSECURED]		= "SvUnsec ",
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 9abf6bb56b65..82fee7c47481 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1122,36 +1122,31 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 		goto protocol_error_free;
 	}
 
-	spin_lock(&conn->bundle->channel_lock);
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
-		struct rxrpc_call *call;
 		u32 call_id = ntohl(response->encrypted.call_id[i]);
+		u32 counter = READ_ONCE(conn->channels[i].call_counter);
 
 		if (call_id > INT_MAX) {
 			rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
 					 rxkad_abort_resp_bad_callid);
-			goto protocol_error_unlock;
+			goto protocol_error_free;
 		}
 
-		if (call_id < conn->channels[i].call_counter) {
+		if (call_id < counter) {
 			rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
 					 rxkad_abort_resp_call_ctr);
-			goto protocol_error_unlock;
+			goto protocol_error_free;
 		}
 
-		if (call_id > conn->channels[i].call_counter) {
-			call = rcu_dereference_protected(
-				conn->channels[i].call,
-				lockdep_is_held(&conn->bundle->channel_lock));
-			if (call && !__rxrpc_call_is_complete(call)) {
+		if (call_id > counter) {
+			if (conn->channels[i].call) {
 				rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
 						 rxkad_abort_resp_call_state);
-				goto protocol_error_unlock;
+				goto protocol_error_free;
 			}
 			conn->channels[i].call_counter = call_id;
 		}
 	}
-	spin_unlock(&conn->bundle->channel_lock);
 
 	if (ntohl(response->encrypted.inc_nonce) != conn->rxkad.nonce + 1) {
 		rxrpc_abort_conn(conn, skb, RXKADOUTOFSEQUENCE, -EPROTO,
@@ -1179,8 +1174,6 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	_leave(" = 0");
 	return 0;
 
-protocol_error_unlock:
-	spin_unlock(&conn->bundle->channel_lock);
 protocol_error_free:
 	kfree(ticket);
 protocol_error:
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 78af14694618..fcb0846406c0 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -97,38 +97,32 @@ int rxrpc_init_client_call_security(struct rxrpc_call *call)
  */
 int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 {
-	const struct rxrpc_security *sec;
 	struct rxrpc_key_token *token;
 	struct key *key = conn->key;
-	int ret;
+	int ret = 0;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(key));
 
-	if (!key)
-		return 0;
-
-	ret = key_validate(key);
-	if (ret < 0)
-		return ret;
-
 	for (token = key->payload.data[0]; token; token = token->next) {
-		sec = rxrpc_security_lookup(token->security_index);
-		if (sec)
+		if (token->security_index == conn->security->security_index)
 			goto found;
 	}
 	return -EKEYREJECTED;
 
 found:
-	conn->security = sec;
-
-	ret = conn->security->init_connection_security(conn, token);
-	if (ret < 0) {
-		conn->security = &rxrpc_no_security;
-		return ret;
+	mutex_lock(&conn->security_lock);
+	if (conn->state == RXRPC_CONN_CLIENT_UNSECURED) {
+		ret = conn->security->init_connection_security(conn, token);
+		if (ret == 0) {
+			spin_lock(&conn->state_lock);
+			if (conn->state == RXRPC_CONN_CLIENT_UNSECURED)
+				smp_store_release(&conn->state,
+						  RXRPC_CONN_CLIENT);
+			spin_unlock(&conn->state_lock);
+		}
 	}
-
-	_leave(" = 0");
-	return 0;
+	mutex_unlock(&conn->security_lock);
+	return ret;
 }
 
 /*
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index b0182de63226..7c24e681b9bf 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -37,6 +37,60 @@ bool rxrpc_propose_abort(struct rxrpc_call *call, s32 abort_code, int error,
 	return false;
 }
 
+/*
+ * Wait for a call to become connected.  Interruption here doesn't cause the
+ * call to be aborted.
+ */
+static int rxrpc_wait_to_be_connected(struct rxrpc_call *call, long *timeo)
+{
+	DECLARE_WAITQUEUE(myself, current);
+	int ret = 0;
+
+	_enter("%d", call->debug_id);
+
+	if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN)
+		return call->error;
+
+	add_wait_queue_exclusive(&call->waitq, &myself);
+
+	for (;;) {
+		ret = call->error;
+		if (ret < 0)
+			break;
+
+		switch (call->interruptibility) {
+		case RXRPC_INTERRUPTIBLE:
+		case RXRPC_PREINTERRUPTIBLE:
+			set_current_state(TASK_INTERRUPTIBLE);
+			break;
+		case RXRPC_UNINTERRUPTIBLE:
+		default:
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			break;
+		}
+		if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN) {
+			ret = call->error;
+			break;
+		}
+		if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
+		     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
+		    signal_pending(current)) {
+			ret = sock_intr_errno(*timeo);
+			break;
+		}
+		*timeo = schedule_timeout(*timeo);
+	}
+
+	remove_wait_queue(&call->waitq, &myself);
+	__set_current_state(TASK_RUNNING);
+
+	if (ret == 0 && rxrpc_call_is_complete(call))
+		ret = call->error;
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
 /*
  * Return true if there's sufficient Tx queue space.
  */
@@ -238,6 +292,16 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
+	ret = rxrpc_wait_to_be_connected(call, &timeo);
+	if (ret < 0)
+		return ret;
+
+	if (call->conn->state == RXRPC_CONN_CLIENT_UNSECURED) {
+		ret = rxrpc_init_client_conn_security(call->conn);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 


