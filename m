Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95452F0FF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351889AbiETQqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351897AbiETQqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:46:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEFC258E7E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653065174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46AguslCAL/HefTbr0wiqtSycD5W6suuhvDNbGLCfNk=;
        b=Fwl8gPHqQeN7J8Uoc1ExPeuGrfKB7lZyDbmzvPrVnG456xH/4qWCaP9pgUIAYgdvvirJXB
        vaFJWZXBfCjmmIsaYqQhxWkbQTEWZNU8WUbNUULkhDNCCbFzMwVAooJDuJsURjSilG2y1H
        lwYt6wlCrKd6o7WWTtsK+dGfcA1qt6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-Sc_fwc80OcG7SxPT7AjShg-1; Fri, 20 May 2022 12:46:09 -0400
X-MC-Unique: Sc_fwc80OcG7SxPT7AjShg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C67D8810BCF;
        Fri, 20 May 2022 16:46:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D813CC53360;
        Fri, 20 May 2022 16:46:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 2/7] rxrpc: Use refcount_t rather than atomic_t
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:46:07 +0100
Message-ID: <165306516720.34989.14136161479875421426.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
References: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move to using refcount_t rather than atomic_t for refcounts in rxrpc.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 +-
 net/rxrpc/af_rxrpc.c         |    2 +-
 net/rxrpc/ar-internal.h      |   18 ++++-----------
 net/rxrpc/call_accept.c      |    4 ++-
 net/rxrpc/call_object.c      |   44 ++++++++++++++++++++------------------
 net/rxrpc/conn_client.c      |   30 ++++++++++++++------------
 net/rxrpc/conn_object.c      |   49 +++++++++++++++++++++---------------------
 net/rxrpc/conn_service.c     |    8 +++----
 net/rxrpc/input.c            |    4 +--
 net/rxrpc/local_object.c     |   31 ++++++++++++++-------------
 net/rxrpc/peer_object.c      |   40 ++++++++++++++++++----------------
 net/rxrpc/proc.c             |    8 +++----
 net/rxrpc/skbuff.c           |    1 -
 13 files changed, 119 insertions(+), 122 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4a3ab0ed6e06..cdb28976641b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -583,7 +583,7 @@ TRACE_EVENT(rxrpc_client,
 	    TP_fast_assign(
 		    __entry->conn = conn ? conn->debug_id : 0;
 		    __entry->channel = channel;
-		    __entry->usage = conn ? atomic_read(&conn->usage) : -2;
+		    __entry->usage = conn ? refcount_read(&conn->ref) : -2;
 		    __entry->op = op;
 		    __entry->cid = conn ? conn->proto.cid : 0;
 			   ),
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 2b5f89713e36..ceba28e9dce6 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -351,7 +351,7 @@ static void rxrpc_dummy_notify_rx(struct sock *sk, struct rxrpc_call *rxcall,
  */
 void rxrpc_kernel_end_call(struct socket *sock, struct rxrpc_call *call)
 {
-	_enter("%d{%d}", call->debug_id, atomic_read(&call->usage));
+	_enter("%d{%d}", call->debug_id, refcount_read(&call->ref));
 
 	mutex_lock(&call->user_mutex);
 	rxrpc_release_call(rxrpc_sk(sock->sk), call);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ac1f88a0e120..52a23d03d694 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -15,14 +15,6 @@
 #include <keys/rxrpc-type.h>
 #include "protocol.h"
 
-#if 0
-#define CHECK_SLAB_OKAY(X)				     \
-	BUG_ON(atomic_read((X)) >> (sizeof(atomic_t) - 2) == \
-	       (POISON_FREE << 8 | POISON_FREE))
-#else
-#define CHECK_SLAB_OKAY(X) do {} while (0)
-#endif
-
 #define FCRYPT_BSIZE 8
 struct rxrpc_crypt {
 	union {
@@ -279,7 +271,7 @@ struct rxrpc_security {
 struct rxrpc_local {
 	struct rcu_head		rcu;
 	atomic_t		active_users;	/* Number of users of the local endpoint */
-	atomic_t		usage;		/* Number of references to the structure */
+	refcount_t		ref;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
@@ -304,7 +296,7 @@ struct rxrpc_local {
  */
 struct rxrpc_peer {
 	struct rcu_head		rcu;		/* This must be first */
-	atomic_t		usage;
+	refcount_t		ref;
 	unsigned long		hash_key;
 	struct hlist_node	hash_link;
 	struct rxrpc_local	*local;
@@ -406,7 +398,7 @@ enum rxrpc_conn_proto_state {
  */
 struct rxrpc_bundle {
 	struct rxrpc_conn_parameters params;
-	atomic_t		usage;
+	refcount_t		ref;
 	unsigned int		debug_id;
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
@@ -427,7 +419,7 @@ struct rxrpc_connection {
 	struct rxrpc_conn_proto	proto;
 	struct rxrpc_conn_parameters params;
 
-	atomic_t		usage;
+	refcount_t		ref;
 	struct rcu_head		rcu;
 	struct list_head	cache_link;
 
@@ -609,7 +601,7 @@ struct rxrpc_call {
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
-	atomic_t		usage;
+	refcount_t		ref;
 	u16			service_id;	/* service ID */
 	u8			security_ix;	/* Security type */
 	enum rxrpc_interruptibility interruptibility; /* At what point call may be interrupted */
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 1ae90fb97936..8ae59edc2551 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -91,7 +91,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 				  (head + 1) & (size - 1));
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 atomic_read(&conn->usage), here);
+				 refcount_read(&conn->ref), here);
 	}
 
 	/* Now it gets complicated, because calls get registered with the
@@ -104,7 +104,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	call->state = RXRPC_CALL_SERVER_PREALLOC;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)user_call_ID);
 
 	write_lock(&rx->call_lock);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 043508fd8d8a..8764a4f19c03 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -112,7 +112,7 @@ struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *rx,
 found_extant_call:
 	rxrpc_get_call(call, rxrpc_call_got);
 	read_unlock(&rx->call_lock);
-	_leave(" = %p [%d]", call, atomic_read(&call->usage));
+	_leave(" = %p [%d]", call, refcount_read(&call->ref));
 	return call;
 }
 
@@ -160,7 +160,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->input_lock);
 	rwlock_init(&call->state_lock);
-	atomic_set(&call->usage, 1);
+	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
 	call->tx_total_len = -1;
 	call->next_rx_timo = 20 * HZ;
@@ -299,7 +299,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	call->interruptibility = p->interruptibility;
 	call->tx_total_len = p->tx_total_len;
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)p->user_call_ID);
 	if (p->kernel)
 		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
@@ -352,7 +352,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 		goto error_attached_to_socket;
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
-			 atomic_read(&call->usage), here, NULL);
+			 refcount_read(&call->ref), here, NULL);
 
 	rxrpc_start_call_timer(call);
 
@@ -372,7 +372,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, -EEXIST);
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(-EEXIST));
+			 refcount_read(&call->ref), here, ERR_PTR(-EEXIST));
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
@@ -386,7 +386,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	 */
 error_attached_to_socket:
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 atomic_read(&call->usage), here, ERR_PTR(ret));
+			 refcount_read(&call->ref), here, ERR_PTR(ret));
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, ret);
@@ -442,8 +442,9 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 bool rxrpc_queue_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
-	if (n == 0)
+	int n;
+
+	if (!__refcount_inc_not_zero(&call->ref, &n))
 		return false;
 	if (rxrpc_queue_work(&call->processor))
 		trace_rxrpc_call(call->debug_id, rxrpc_call_queued, n + 1,
@@ -459,7 +460,7 @@ bool rxrpc_queue_call(struct rxrpc_call *call)
 bool __rxrpc_queue_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_read(&call->usage);
+	int n = refcount_read(&call->ref);
 	ASSERTCMP(n, >=, 1);
 	if (rxrpc_queue_work(&call->processor))
 		trace_rxrpc_call(call->debug_id, rxrpc_call_queued_ref, n,
@@ -476,7 +477,7 @@ void rxrpc_see_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
 	if (call) {
-		int n = atomic_read(&call->usage);
+		int n = refcount_read(&call->ref);
 
 		trace_rxrpc_call(call->debug_id, rxrpc_call_seen, n,
 				 here, NULL);
@@ -486,11 +487,11 @@ void rxrpc_see_call(struct rxrpc_call *call)
 bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
+	int n;
 
-	if (n == 0)
+	if (!__refcount_inc_not_zero(&call->ref, &n))
 		return false;
-	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
 	return true;
 }
 
@@ -500,9 +501,10 @@ bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(&call->usage);
+	int n;
 
-	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	__refcount_inc(&call->ref, &n);
+	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
 }
 
 /*
@@ -527,10 +529,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	struct rxrpc_connection *conn = call->conn;
 	bool put = false;
 
-	_enter("{%d,%d}", call->debug_id, atomic_read(&call->usage));
+	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
 	trace_rxrpc_call(call->debug_id, rxrpc_call_release,
-			 atomic_read(&call->usage),
+			 refcount_read(&call->ref),
 			 here, (const void *)call->flags);
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
@@ -619,14 +621,14 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 	struct rxrpc_net *rxnet = call->rxnet;
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = call->debug_id;
+	bool dead;
 	int n;
 
 	ASSERT(call != NULL);
 
-	n = atomic_dec_return(&call->usage);
+	dead = __refcount_dec_and_test(&call->ref, &n);
 	trace_rxrpc_call(debug_id, op, n, here, NULL);
-	ASSERTCMP(n, >=, 0);
-	if (n == 0) {
+	if (dead) {
 		_debug("call %d dead", call->debug_id);
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
@@ -716,7 +718,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			list_del_init(&call->link);
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
-			       call, atomic_read(&call->usage),
+			       call, refcount_read(&call->ref),
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 8120138dac01..3c9eeb5b750c 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -102,7 +102,7 @@ void rxrpc_destroy_client_conn_ids(void)
 	if (!idr_is_empty(&rxrpc_client_conn_ids)) {
 		idr_for_each_entry(&rxrpc_client_conn_ids, conn, id) {
 			pr_err("AF_RXRPC: Leaked client conn %p {%d}\n",
-			       conn, atomic_read(&conn->usage));
+			       conn, refcount_read(&conn->ref));
 		}
 		BUG();
 	}
@@ -122,7 +122,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 	if (bundle) {
 		bundle->params = *cp;
 		rxrpc_get_peer(bundle->params.peer);
-		atomic_set(&bundle->usage, 1);
+		refcount_set(&bundle->ref, 1);
 		spin_lock_init(&bundle->channel_lock);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
 	}
@@ -131,7 +131,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 
 struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
 {
-	atomic_inc(&bundle->usage);
+	refcount_inc(&bundle->ref);
 	return bundle;
 }
 
@@ -144,10 +144,13 @@ static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
 {
 	unsigned int d = bundle->debug_id;
-	unsigned int u = atomic_dec_return(&bundle->usage);
+	bool dead;
+	int r;
 
-	_debug("PUT B=%x %u", d, u);
-	if (u == 0)
+	dead = __refcount_dec_and_test(&bundle->ref, &r);
+
+	_debug("PUT B=%x %d", d, r);
+	if (dead)
 		rxrpc_free_bundle(bundle);
 }
 
@@ -169,7 +172,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_set(&conn->usage, 1);
+	refcount_set(&conn->ref, 1);
 	conn->bundle		= bundle;
 	conn->params		= bundle->params;
 	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
@@ -195,7 +198,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	key_get(conn->params.key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
-			 atomic_read(&conn->usage),
+			 refcount_read(&conn->ref),
 			 __builtin_return_address(0));
 
 	atomic_inc(&rxnet->nr_client_conns);
@@ -966,14 +969,13 @@ void rxrpc_put_client_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
-	int n;
+	bool dead;
+	int r;
 
-	n = atomic_dec_return(&conn->usage);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, n, here);
-	if (n <= 0) {
-		ASSERTCMP(n, >=, 0);
+	dead = __refcount_dec_and_test(&conn->ref, &r);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, r - 1, here);
+	if (dead)
 		rxrpc_kill_client_conn(conn);
-	}
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index b2159dbf5412..03c7f2269151 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -104,7 +104,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 			goto not_found;
 		*_peer = peer;
 		conn = rxrpc_find_service_conn_rcu(peer, skb);
-		if (!conn || atomic_read(&conn->usage) == 0)
+		if (!conn || refcount_read(&conn->ref) == 0)
 			goto not_found;
 		_leave(" = %p", conn);
 		return conn;
@@ -114,7 +114,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		 */
 		conn = idr_find(&rxrpc_client_conn_ids,
 				sp->hdr.cid >> RXRPC_CIDSHIFT);
-		if (!conn || atomic_read(&conn->usage) == 0) {
+		if (!conn || refcount_read(&conn->ref) == 0) {
 			_debug("no conn");
 			goto not_found;
 		}
@@ -263,11 +263,12 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
 bool rxrpc_queue_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_fetch_add_unless(&conn->usage, 1, 0);
-	if (n == 0)
+	int r;
+
+	if (!__refcount_inc_not_zero(&conn->ref, &r))
 		return false;
 	if (rxrpc_queue_work(&conn->processor))
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, n + 1, here);
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, r + 1, here);
 	else
 		rxrpc_put_connection(conn);
 	return true;
@@ -280,7 +281,7 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	if (conn) {
-		int n = atomic_read(&conn->usage);
+		int n = refcount_read(&conn->ref);
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_seen, n, here);
 	}
@@ -292,9 +293,10 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
-	int n = atomic_inc_return(&conn->usage);
+	int r;
 
-	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n, here);
+	__refcount_inc(&conn->ref, &r);
+	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r, here);
 	return conn;
 }
 
@@ -305,11 +307,11 @@ struct rxrpc_connection *
 rxrpc_get_connection_maybe(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (conn) {
-		int n = atomic_fetch_add_unless(&conn->usage, 1, 0);
-		if (n > 0)
-			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n + 1, here);
+		if (__refcount_inc_not_zero(&conn->ref, &r))
+			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r + 1, here);
 		else
 			conn = NULL;
 	}
@@ -333,12 +335,11 @@ void rxrpc_put_service_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
-	int n;
+	int r;
 
-	n = atomic_dec_return(&conn->usage);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, n, here);
-	ASSERTCMP(n, >=, 0);
-	if (n == 1)
+	__refcount_dec(&conn->ref, &r);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, r - 1, here);
+	if (r - 1 == 1)
 		rxrpc_set_service_reap_timer(conn->params.local->rxnet,
 					     jiffies + rxrpc_connection_expiry);
 }
@@ -351,9 +352,9 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	struct rxrpc_connection *conn =
 		container_of(rcu, struct rxrpc_connection, rcu);
 
-	_enter("{%d,u=%d}", conn->debug_id, atomic_read(&conn->usage));
+	_enter("{%d,u=%d}", conn->debug_id, refcount_read(&conn->ref));
 
-	ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
 	_net("DESTROY CONN %d", conn->debug_id);
 
@@ -392,8 +393,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
-		ASSERTCMP(atomic_read(&conn->usage), >, 0);
-		if (likely(atomic_read(&conn->usage) > 1))
+		ASSERTCMP(refcount_read(&conn->ref), >, 0);
+		if (likely(refcount_read(&conn->ref) > 1))
 			continue;
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
@@ -405,7 +406,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				expire_at = idle_timestamp + rxrpc_closed_conn_expiry * HZ;
 
 			_debug("reap CONN %d { u=%d,t=%ld }",
-			       conn->debug_id, atomic_read(&conn->usage),
+			       conn->debug_id, refcount_read(&conn->ref),
 			       (long)expire_at - (long)now);
 
 			if (time_before(now, expire_at)) {
@@ -418,7 +419,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		/* The usage count sits at 1 whilst the object is unused on the
 		 * list; we reduce that to 0 to make the object unavailable.
 		 */
-		if (atomic_cmpxchg(&conn->usage, 1, 0) != 1)
+		if (!refcount_dec_if_one(&conn->ref))
 			continue;
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_reap_service, 0, NULL);
 
@@ -442,7 +443,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				  link);
 		list_del_init(&conn->link);
 
-		ASSERTCMP(atomic_read(&conn->usage), ==, 0);
+		ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 		rxrpc_kill_connection(conn);
 	}
 
@@ -470,7 +471,7 @@ void rxrpc_destroy_all_connections(struct rxrpc_net *rxnet)
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
 		pr_err("AF_RXRPC: Leaked conn %p {%d}\n",
-		       conn, atomic_read(&conn->usage));
+		       conn, refcount_read(&conn->ref));
 		leak = true;
 	}
 	write_unlock(&rxnet->conn_lock);
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index e1966dfc9152..6e6aa02c6f9e 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -9,7 +9,7 @@
 #include "ar-internal.h"
 
 static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
-	.usage		= ATOMIC_INIT(1),
+	.ref		= REFCOUNT_INIT(1),
 	.debug_id	= UINT_MAX,
 	.channel_lock	= __SPIN_LOCK_UNLOCKED(&rxrpc_service_dummy_bundle.channel_lock),
 };
@@ -99,7 +99,7 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer *peer,
 	return;
 
 found_extant_conn:
-	if (atomic_read(&cursor->usage) == 0)
+	if (refcount_read(&cursor->ref) == 0)
 		goto replace_old_connection;
 	write_sequnlock_bh(&peer->service_conn_lock);
 	/* We should not be able to get here.  rxrpc_incoming_connection() is
@@ -132,7 +132,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 * the rxrpc_connections list.
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
-		atomic_set(&conn->usage, 2);
+		refcount_set(&conn->ref, 2);
 		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle);
 
 		atomic_inc(&rxnet->nr_conns);
@@ -142,7 +142,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		write_unlock(&rxnet->conn_lock);
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 atomic_read(&conn->usage),
+				 refcount_read(&conn->ref),
 				 __builtin_return_address(0));
 	}
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dc201363f2c4..853b869b026a 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1154,8 +1154,6 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
  */
 static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	CHECK_SLAB_OKAY(&local->usage);
-
 	if (rxrpc_get_local_maybe(local)) {
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
@@ -1413,7 +1411,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		}
 	}
 
-	if (!call || atomic_read(&call->usage) == 0) {
+	if (!call || refcount_read(&call->ref) == 0) {
 		if (rxrpc_to_client(sp) ||
 		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 			goto bad_message;
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ea6f338bd131..96ecb7356c0f 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -79,7 +79,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
-		atomic_set(&local->usage, 1);
+		refcount_set(&local->ref, 1);
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
@@ -265,10 +265,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	n = atomic_inc_return(&local->usage);
-	trace_rxrpc_local(local->debug_id, rxrpc_local_got, n, here);
+	__refcount_inc(&local->ref, &r);
+	trace_rxrpc_local(local->debug_id, rxrpc_local_got, r + 1, here);
 	return local;
 }
 
@@ -278,12 +278,12 @@ struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
 struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (local) {
-		int n = atomic_fetch_add_unless(&local->usage, 1, 0);
-		if (n > 0)
+		if (__refcount_inc_not_zero(&local->ref, &r))
 			trace_rxrpc_local(local->debug_id, rxrpc_local_got,
-					  n + 1, here);
+					  r + 1, here);
 		else
 			local = NULL;
 	}
@@ -297,10 +297,10 @@ void rxrpc_queue_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = local->debug_id;
-	int n = atomic_read(&local->usage);
+	int r = refcount_read(&local->ref);
 
 	if (rxrpc_queue_work(&local->processor))
-		trace_rxrpc_local(debug_id, rxrpc_local_queued, n, here);
+		trace_rxrpc_local(debug_id, rxrpc_local_queued, r + 1, here);
 	else
 		rxrpc_put_local(local);
 }
@@ -312,15 +312,16 @@ void rxrpc_put_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
-	int n;
+	bool dead;
+	int r;
 
 	if (local) {
 		debug_id = local->debug_id;
 
-		n = atomic_dec_return(&local->usage);
-		trace_rxrpc_local(debug_id, rxrpc_local_put, n, here);
+		dead = __refcount_dec_and_test(&local->ref, &r);
+		trace_rxrpc_local(debug_id, rxrpc_local_put, r, here);
 
-		if (n == 0)
+		if (dead)
 			call_rcu(&local->rcu, rxrpc_local_rcu);
 	}
 }
@@ -405,7 +406,7 @@ static void rxrpc_local_processor(struct work_struct *work)
 	bool again;
 
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
-			  atomic_read(&local->usage), NULL);
+			  refcount_read(&local->ref), NULL);
 
 	do {
 		again = false;
@@ -461,7 +462,7 @@ void rxrpc_destroy_all_locals(struct rxrpc_net *rxnet)
 		mutex_lock(&rxnet->local_mutex);
 		hlist_for_each_entry(local, &rxnet->local_endpoints, link) {
 			pr_err("AF_RXRPC: Leaked local %p {%d}\n",
-			       local, atomic_read(&local->usage));
+			       local, refcount_read(&local->ref));
 		}
 		mutex_unlock(&rxnet->local_mutex);
 		BUG();
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 0298fe2ad6d3..26d2ae9baaf2 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -121,7 +121,7 @@ static struct rxrpc_peer *__rxrpc_lookup_peer_rcu(
 
 	hash_for_each_possible_rcu(rxnet->peer_hash, peer, hash_link, hash_key) {
 		if (rxrpc_peer_cmp_key(peer, local, srx, hash_key) == 0 &&
-		    atomic_read(&peer->usage) > 0)
+		    refcount_read(&peer->ref) > 0)
 			return peer;
 	}
 
@@ -140,7 +140,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
 	peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
 	if (peer) {
 		_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
-		_leave(" = %p {u=%d}", peer, atomic_read(&peer->usage));
+		_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
 	}
 	return peer;
 }
@@ -216,7 +216,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
-		atomic_set(&peer->usage, 1);
+		refcount_set(&peer->ref, 1);
 		peer->local = rxrpc_get_local(local);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
@@ -378,7 +378,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 
 	_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
 
-	_leave(" = %p {u=%d}", peer, atomic_read(&peer->usage));
+	_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
 	return peer;
 }
 
@@ -388,10 +388,10 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	n = atomic_inc_return(&peer->usage);
-	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n, here);
+	__refcount_inc(&peer->ref, &r);
+	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
 	return peer;
 }
 
@@ -401,11 +401,11 @@ struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
+	int r;
 
 	if (peer) {
-		int n = atomic_fetch_add_unless(&peer->usage, 1, 0);
-		if (n > 0)
-			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, n + 1, here);
+		if (__refcount_inc_not_zero(&peer->ref, &r))
+			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
 		else
 			peer = NULL;
 	}
@@ -436,13 +436,14 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
-	int n;
+	bool dead;
+	int r;
 
 	if (peer) {
 		debug_id = peer->debug_id;
-		n = atomic_dec_return(&peer->usage);
-		trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
-		if (n == 0)
+		dead = __refcount_dec_and_test(&peer->ref, &r);
+		trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+		if (dead)
 			__rxrpc_put_peer(peer);
 	}
 }
@@ -455,11 +456,12 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 {
 	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = peer->debug_id;
-	int n;
+	bool dead;
+	int r;
 
-	n = atomic_dec_return(&peer->usage);
-	trace_rxrpc_peer(debug_id, rxrpc_peer_put, n, here);
-	if (n == 0) {
+	dead = __refcount_dec_and_test(&peer->ref, &r);
+	trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+	if (dead) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
 		rxrpc_free_peer(peer);
@@ -481,7 +483,7 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
 		hlist_for_each_entry(peer, &rxnet->peer_hash[i], hash_link) {
 			pr_err("Leaked peer %u {%u} %pISp\n",
 			       peer->debug_id,
-			       atomic_read(&peer->usage),
+			       refcount_read(&peer->ref),
 			       &peer->srx.transport);
 		}
 	}
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 8a8f776f91ae..8967201fd8e5 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -107,7 +107,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->cid,
 		   call->call_id,
 		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
-		   atomic_read(&call->usage),
+		   refcount_read(&call->ref),
 		   rxrpc_call_states[call->state],
 		   call->abort_code,
 		   call->debug_id,
@@ -189,7 +189,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   conn->service_id,
 		   conn->proto.cid,
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
-		   atomic_read(&conn->usage),
+		   refcount_read(&conn->ref),
 		   rxrpc_conn_states[conn->state],
 		   key_serial(conn->params.key),
 		   atomic_read(&conn->serial),
@@ -239,7 +239,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		   " %3u %5u %6llus %8u %8u\n",
 		   lbuff,
 		   rbuff,
-		   atomic_read(&peer->usage),
+		   refcount_read(&peer->ref),
 		   peer->cong_cwnd,
 		   peer->mtu,
 		   now - peer->last_tx_at,
@@ -357,7 +357,7 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq,
 		   "UDP   %-47.47s %3u %3u\n",
 		   lbuff,
-		   atomic_read(&local->usage),
+		   refcount_read(&local->ref),
 		   atomic_read(&local->active_users));
 
 	return 0;
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 0348d2bf6f7d..580a5acffee7 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -71,7 +71,6 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n;
-		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
 				rxrpc_skb(skb)->rx_flags, here);


