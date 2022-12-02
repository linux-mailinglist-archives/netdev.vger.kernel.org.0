Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D8963FCBC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiLBASe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiLBARw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:17:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17BFCF7BD
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0n8Vbrv97z4SNIRzk58nGPmQUujEQPXlRC+fxQTL5XE=;
        b=iL0iL0CLU/05Yfn+mlEbfjxBmNvvN5MvmzfE+7WxMmSs77y5E+cigwffa1U5Ma0fTuGrcf
        ZsoRseyTRn9go1+okOklnizPYXiD+16LPy4hzBKI8p1AZqyLy3xxhpWFMTqNbUXB6y0Vyj
        pNM2z4v3Xg3Ezebt8Iu7ewNDxmQRph0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-bQNZoBheMGSQU8cWtAp-xg-1; Thu, 01 Dec 2022 19:16:39 -0500
X-MC-Unique: bQNZoBheMGSQU8cWtAp-xg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60EB5800B23;
        Fri,  2 Dec 2022 00:16:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 864BD111E3FA;
        Fri,  2 Dec 2022 00:16:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/36] rxrpc: trace: Don't use
 __builtin_return_address for rxrpc_peer tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:16:35 +0000
Message-ID: <166994019574.1732290.17398431845997866728.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rxrpc tracing, use enums to generate lists of points of interest rather
than __builtin_return_address() for the rxrpc_peer tracepoint

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   43 +++++++++++++++++++++++++-----------------
 net/rxrpc/af_rxrpc.c         |    2 +-
 net/rxrpc/ar-internal.h      |   11 ++++++-----
 net/rxrpc/call_accept.c      |    8 +++++---
 net/rxrpc/call_object.c      |    2 +-
 net/rxrpc/conn_client.c      |    8 ++++----
 net/rxrpc/conn_object.c      |    2 +-
 net/rxrpc/peer_event.c       |    8 ++++----
 net/rxrpc/peer_object.c      |   34 ++++++++++++++++-----------------
 net/rxrpc/sendmsg.c          |    2 +-
 10 files changed, 65 insertions(+), 55 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 015569845b1d..1c74143a51c1 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -63,10 +63,23 @@
 	E_(rxrpc_local_use_work,		"USE work    ")
 
 #define rxrpc_peer_traces \
-	EM(rxrpc_peer_got,			"GOT") \
-	EM(rxrpc_peer_new,			"NEW") \
-	EM(rxrpc_peer_processing,		"PRO") \
-	E_(rxrpc_peer_put,			"PUT")
+	EM(rxrpc_peer_free,			"FREE        ") \
+	EM(rxrpc_peer_get_accept,		"GET accept  ") \
+	EM(rxrpc_peer_get_activate_call,	"GET act-call") \
+	EM(rxrpc_peer_get_bundle,		"GET bundle  ") \
+	EM(rxrpc_peer_get_client_conn,		"GET cln-conn") \
+	EM(rxrpc_peer_get_input_error,		"GET inpt-err") \
+	EM(rxrpc_peer_get_keepalive,		"GET keepaliv") \
+	EM(rxrpc_peer_get_lookup_client,	"GET look-cln") \
+	EM(rxrpc_peer_get_service_conn,		"GET srv-conn") \
+	EM(rxrpc_peer_new_client,		"NEW client  ") \
+	EM(rxrpc_peer_new_prealloc,		"NEW prealloc") \
+	EM(rxrpc_peer_put_bundle,		"PUT bundle  ") \
+	EM(rxrpc_peer_put_call,			"PUT call    ") \
+	EM(rxrpc_peer_put_conn,			"PUT conn    ") \
+	EM(rxrpc_peer_put_discard_tmp,		"PUT disc-tmp") \
+	EM(rxrpc_peer_put_input_error,		"PUT inpt-err") \
+	E_(rxrpc_peer_put_keepalive,		"PUT keepaliv")
 
 #define rxrpc_conn_traces \
 	EM(rxrpc_conn_got,			"GOT") \
@@ -394,30 +407,26 @@ TRACE_EVENT(rxrpc_local,
 	    );
 
 TRACE_EVENT(rxrpc_peer,
-	    TP_PROTO(unsigned int peer_debug_id, enum rxrpc_peer_trace op,
-		     int usage, const void *where),
+	    TP_PROTO(unsigned int peer_debug_id, int ref, enum rxrpc_peer_trace why),
 
-	    TP_ARGS(peer_debug_id, op, usage, where),
+	    TP_ARGS(peer_debug_id, ref, why),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	peer		)
-		    __field(int,		op		)
-		    __field(int,		usage		)
-		    __field(const void *,	where		)
+		    __field(int,		ref		)
+		    __field(int,		why		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->peer = peer_debug_id;
-		    __entry->op = op;
-		    __entry->usage = usage;
-		    __entry->where = where;
+		    __entry->ref = ref;
+		    __entry->why = why;
 			   ),
 
-	    TP_printk("P=%08x %s u=%d sp=%pSR",
+	    TP_printk("P=%08x %s r=%d",
 		      __entry->peer,
-		      __print_symbolic(__entry->op, rxrpc_peer_traces),
-		      __entry->usage,
-		      __entry->where)
+		      __print_symbolic(__entry->why, rxrpc_peer_traces),
+		      __entry->ref)
 	    );
 
 TRACE_EVENT(rxrpc_conn,
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 989ebca899f3..7a0dc01741e7 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -328,7 +328,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 		mutex_unlock(&call->user_mutex);
 	}
 
-	rxrpc_put_peer(cp.peer);
+	rxrpc_put_peer(cp.peer, rxrpc_peer_put_discard_tmp);
 	_leave(" = %p", call);
 	return call;
 }
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index dde9ce21ef48..6cb111e9761c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1063,14 +1063,15 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *,
 					 const struct sockaddr_rxrpc *);
 struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *, struct rxrpc_local *,
 				     struct sockaddr_rxrpc *, gfp_t);
-struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t);
+struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t,
+				    enum rxrpc_peer_trace);
 void rxrpc_new_incoming_peer(struct rxrpc_sock *, struct rxrpc_local *,
 			     struct rxrpc_peer *);
 void rxrpc_destroy_all_peers(struct rxrpc_net *);
-struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *);
-struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *);
-void rxrpc_put_peer(struct rxrpc_peer *);
-void rxrpc_put_peer_locked(struct rxrpc_peer *);
+struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *, enum rxrpc_peer_trace);
+struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *, enum rxrpc_peer_trace);
+void rxrpc_put_peer(struct rxrpc_peer *, enum rxrpc_peer_trace);
+void rxrpc_put_peer_locked(struct rxrpc_peer *, enum rxrpc_peer_trace);
 
 /*
  * proc.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 1b12d4e28373..f6bc3b07c3e5 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -70,7 +70,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	head = b->peer_backlog_head;
 	tail = READ_ONCE(b->peer_backlog_tail);
 	if (CIRC_CNT(head, tail, size) < max) {
-		struct rxrpc_peer *peer = rxrpc_alloc_peer(rx->local, gfp);
+		struct rxrpc_peer *peer;
+
+		peer = rxrpc_alloc_peer(rx->local, gfp, rxrpc_peer_new_prealloc);
 		if (!peer)
 			return -ENOMEM;
 		b->peer_backlog[head] = peer;
@@ -286,7 +288,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		return NULL;
 
 	if (!conn) {
-		if (peer && !rxrpc_get_peer_maybe(peer))
+		if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_service_conn))
 			peer = NULL;
 		if (!peer) {
 			peer = b->peer_backlog[peer_tail];
@@ -323,7 +325,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	call->conn = conn;
 	call->security = conn->security;
 	call->security_ix = conn->security_ix;
-	call->peer = rxrpc_get_peer(conn->peer);
+	call->peer = rxrpc_get_peer(conn->peer, rxrpc_peer_get_accept);
 	call->cong_ssthresh = call->peer->cong_ssthresh;
 	call->tx_last_sent = ktime_get_real();
 	return call;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 59928f0a8fe1..1b725afd6e2c 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -636,7 +636,7 @@ static void rxrpc_destroy_call(struct work_struct *work)
 	rxrpc_delete_call_timer(call);
 
 	rxrpc_put_connection(call->conn);
-	rxrpc_put_peer(call->peer);
+	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	kmem_cache_free(rxrpc_call_jar, call);
 	if (atomic_dec_and_test(&rxnet->nr_calls))
 		wake_up_var(&rxnet->nr_calls);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 9a69b4c1b182..9444da235a48 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -123,7 +123,7 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 	bundle = kzalloc(sizeof(*bundle), gfp);
 	if (bundle) {
 		bundle->local		= cp->local;
-		bundle->peer		= rxrpc_get_peer(cp->peer);
+		bundle->peer		= rxrpc_get_peer(cp->peer, rxrpc_peer_get_bundle);
 		bundle->key		= cp->key;
 		bundle->exclusive	= cp->exclusive;
 		bundle->upgrade		= cp->upgrade;
@@ -145,7 +145,7 @@ struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
 
 static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 {
-	rxrpc_put_peer(bundle->peer);
+	rxrpc_put_peer(bundle->peer, rxrpc_peer_put_bundle);
 	kfree(bundle);
 }
 
@@ -207,7 +207,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	write_unlock(&rxnet->conn_lock);
 
 	rxrpc_get_bundle(bundle);
-	rxrpc_get_peer(conn->peer);
+	rxrpc_get_peer(conn->peer, rxrpc_peer_get_client_conn);
 	rxrpc_get_local(conn->local, rxrpc_local_get_client_conn);
 	key_get(conn->key);
 
@@ -543,7 +543,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	rxrpc_see_call(call);
 	list_del_init(&call->chan_wait_link);
-	call->peer	= rxrpc_get_peer(conn->peer);
+	call->peer	= rxrpc_get_peer(conn->peer, rxrpc_peer_get_activate_call);
 	call->conn	= rxrpc_get_connection(conn);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 725359afeac0..554ee5dd3325 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -362,7 +362,7 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	conn->security->clear(conn);
 	key_put(conn->key);
 	rxrpc_put_bundle(conn->bundle);
-	rxrpc_put_peer(conn->peer);
+	rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
 
 	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
 		wake_up_var(&conn->local->rxnet->nr_conns);
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 3f8d104ecaa7..5e97d321ac38 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -168,7 +168,7 @@ void rxrpc_error_report(struct sock *sk)
 	}
 
 	peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
-	if (peer && !rxrpc_get_peer_maybe(peer))
+	if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input_error))
 		peer = NULL;
 	if (!peer) {
 		rcu_read_unlock();
@@ -190,7 +190,7 @@ void rxrpc_error_report(struct sock *sk)
 out:
 	rcu_read_unlock();
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
-	rxrpc_put_peer(peer);
+	rxrpc_put_peer(peer, rxrpc_peer_put_input_error);
 
 	_leave("");
 }
@@ -263,7 +263,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 				  struct rxrpc_peer, keepalive_link);
 
 		list_del_init(&peer->keepalive_link);
-		if (!rxrpc_get_peer_maybe(peer))
+		if (!rxrpc_get_peer_maybe(peer, rxrpc_peer_get_keepalive))
 			continue;
 
 		if (__rxrpc_use_local(peer->local, rxrpc_local_use_peer_keepalive)) {
@@ -291,7 +291,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 				      &rxnet->peer_keepalive[slot & mask]);
 			rxrpc_unuse_local(peer->local, rxrpc_local_unuse_peer_keepalive);
 		}
-		rxrpc_put_peer_locked(peer);
+		rxrpc_put_peer_locked(peer, rxrpc_peer_put_keepalive);
 	}
 
 	spin_unlock_bh(&rxnet->peer_hash_lock);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index bcef897560e7..9e682a60a800 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -205,9 +205,9 @@ static void rxrpc_assess_MTU_size(struct rxrpc_sock *rx,
 /*
  * Allocate a peer.
  */
-struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
+struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp,
+				    enum rxrpc_peer_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	struct rxrpc_peer *peer;
 
 	_enter("");
@@ -226,7 +226,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 		rxrpc_peer_init_rtt(peer);
 
 		peer->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
-		trace_rxrpc_peer(peer->debug_id, rxrpc_peer_new, 1, here);
+		trace_rxrpc_peer(peer->debug_id, why, 1);
 	}
 
 	_leave(" = %p", peer);
@@ -282,7 +282,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 
 	_enter("");
 
-	peer = rxrpc_alloc_peer(local, gfp);
+	peer = rxrpc_alloc_peer(local, gfp, rxrpc_peer_new_client);
 	if (peer) {
 		memcpy(&peer->srx, srx, sizeof(*srx));
 		rxrpc_init_peer(rx, peer, hash_key);
@@ -294,6 +294,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 
 static void rxrpc_free_peer(struct rxrpc_peer *peer)
 {
+	trace_rxrpc_peer(peer->debug_id, 0, rxrpc_peer_free);
 	rxrpc_put_local(peer->local, rxrpc_local_put_peer);
 	kfree_rcu(peer, rcu);
 }
@@ -334,7 +335,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 	/* search the peer list first */
 	rcu_read_lock();
 	peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
-	if (peer && !rxrpc_get_peer_maybe(peer))
+	if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_lookup_client))
 		peer = NULL;
 	rcu_read_unlock();
 
@@ -352,7 +353,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 
 		/* Need to check that we aren't racing with someone else */
 		peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
-		if (peer && !rxrpc_get_peer_maybe(peer))
+		if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_lookup_client))
 			peer = NULL;
 		if (!peer) {
 			hash_add_rcu(rxnet->peer_hash,
@@ -376,27 +377,26 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 /*
  * Get a ref on a peer record.
  */
-struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer)
+struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *peer, enum rxrpc_peer_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int r;
 
 	__refcount_inc(&peer->ref, &r);
-	trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
+	trace_rxrpc_peer(peer->debug_id, why, r + 1);
 	return peer;
 }
 
 /*
  * Get a ref on a peer record unless its usage has already reached 0.
  */
-struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *peer)
+struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *peer,
+					enum rxrpc_peer_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int r;
 
 	if (peer) {
 		if (__refcount_inc_not_zero(&peer->ref, &r))
-			trace_rxrpc_peer(peer->debug_id, rxrpc_peer_got, r + 1, here);
+			trace_rxrpc_peer(peer->debug_id, r + 1, why);
 		else
 			peer = NULL;
 	}
@@ -423,9 +423,8 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 /*
  * Drop a ref on a peer record.
  */
-void rxrpc_put_peer(struct rxrpc_peer *peer)
+void rxrpc_put_peer(struct rxrpc_peer *peer, enum rxrpc_peer_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
 	bool dead;
 	int r;
@@ -433,7 +432,7 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
 	if (peer) {
 		debug_id = peer->debug_id;
 		dead = __refcount_dec_and_test(&peer->ref, &r);
-		trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+		trace_rxrpc_peer(debug_id, r - 1, why);
 		if (dead)
 			__rxrpc_put_peer(peer);
 	}
@@ -443,15 +442,14 @@ void rxrpc_put_peer(struct rxrpc_peer *peer)
  * Drop a ref on a peer record where the caller already holds the
  * peer_hash_lock.
  */
-void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
+void rxrpc_put_peer_locked(struct rxrpc_peer *peer, enum rxrpc_peer_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = peer->debug_id;
 	bool dead;
 	int r;
 
 	dead = __refcount_dec_and_test(&peer->ref, &r);
-	trace_rxrpc_peer(debug_id, rxrpc_peer_put, r - 1, here);
+	trace_rxrpc_peer(debug_id, r - 1, why);
 	if (dead) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index e5fd8a95bf71..cfe0badba0b3 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -604,7 +604,7 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 				     atomic_inc_return(&rxrpc_debug_id));
 	/* The socket is now unlocked */
 
-	rxrpc_put_peer(cp.peer);
+	rxrpc_put_peer(cp.peer, rxrpc_peer_put_discard_tmp);
 	_leave(" = %p\n", call);
 	return call;
 }


