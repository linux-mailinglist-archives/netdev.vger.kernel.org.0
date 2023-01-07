Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAD660D84
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjAGJza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjAGJy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:54:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D487DE2F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3nhNLphD7Bpb038w13oGld4hGzbEziD74mm7nhLywfs=;
        b=FX/y1Vr109LOgKRTCYya4o7TrvfjHFfknIoEKkk5mfBZeqyq4t+SJuUPEtsmNqWE5DUyli
        MsSynqUGXwyUKFISRLYqIHkgGqaqvlWhd8DJfeeZhfxDkulh3d2nqw3xvGIGtNkfptSOis
        MGXeQnnntZ3VF5CQgfXe08AgLgBlrA0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-LayxH_CWP2W5EtXroNb0SQ-1; Sat, 07 Jan 2023 04:54:07 -0500
X-MC-Unique: LayxH_CWP2W5EtXroNb0SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03CB4101A521;
        Sat,  7 Jan 2023 09:54:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33C1942203;
        Sat,  7 Jan 2023 09:54:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 11/19] rxrpc: Set up a connection bundle from a call,
 not rxrpc_conn_parameters
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:54:05 +0000
Message-ID: <167308524545.1538866.6498246820275477417.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the information now stored in struct rxrpc_call to configure the
connection bundle and thence the connection, rather than using the
rxrpc_conn_parameters struct.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    3 -
 net/rxrpc/af_rxrpc.c         |    1 
 net/rxrpc/ar-internal.h      |    8 +--
 net/rxrpc/call_object.c      |    4 +
 net/rxrpc/conn_client.c      |  132 +++++++++++++++++++++---------------------
 net/rxrpc/conn_object.c      |    2 -
 net/rxrpc/sendmsg.c          |    1 
 7 files changed, 76 insertions(+), 75 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 85671f4a77de..e2f6b79d5517 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -178,7 +178,6 @@
 #define rxrpc_peer_traces \
 	EM(rxrpc_peer_free,			"FREE        ") \
 	EM(rxrpc_peer_get_accept,		"GET accept  ") \
-	EM(rxrpc_peer_get_activate_call,	"GET act-call") \
 	EM(rxrpc_peer_get_bundle,		"GET bundle  ") \
 	EM(rxrpc_peer_get_client_conn,		"GET cln-conn") \
 	EM(rxrpc_peer_get_input,		"GET input   ") \
@@ -191,7 +190,6 @@
 	EM(rxrpc_peer_put_bundle,		"PUT bundle  ") \
 	EM(rxrpc_peer_put_call,			"PUT call    ") \
 	EM(rxrpc_peer_put_conn,			"PUT conn    ") \
-	EM(rxrpc_peer_put_discard_tmp,		"PUT disc-tmp") \
 	EM(rxrpc_peer_put_input,		"PUT input   ") \
 	EM(rxrpc_peer_put_input_error,		"PUT inpt-err") \
 	E_(rxrpc_peer_put_keepalive,		"PUT keepaliv")
@@ -201,6 +199,7 @@
 	EM(rxrpc_bundle_get_client_call,	"GET clt-call") \
 	EM(rxrpc_bundle_get_client_conn,	"GET clt-conn") \
 	EM(rxrpc_bundle_get_service_conn,	"GET svc-conn") \
+	EM(rxrpc_bundle_put_call,		"PUT call    ") \
 	EM(rxrpc_bundle_put_conn,		"PUT conn    ") \
 	EM(rxrpc_bundle_put_discard,		"PUT discard ") \
 	E_(rxrpc_bundle_new,			"NEW         ")
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 6f6a6b77ee84..f4e1ffff2ba4 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -328,7 +328,6 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 		mutex_unlock(&call->user_mutex);
 	}
 
-	rxrpc_put_peer(cp.peer, rxrpc_peer_put_discard_tmp);
 	_leave(" = %p", call);
 	return call;
 }
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e508ec221b75..2740c6333114 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -360,7 +360,6 @@ struct rxrpc_conn_proto {
 
 struct rxrpc_conn_parameters {
 	struct rxrpc_local	*local;		/* Representation of local endpoint */
-	struct rxrpc_peer	*peer;		/* Remote endpoint */
 	struct key		*key;		/* Security details */
 	bool			exclusive;	/* T if conn is exclusive */
 	bool			upgrade;	/* T if service ID can be upgraded */
@@ -428,6 +427,7 @@ struct rxrpc_bundle {
 	struct rxrpc_local	*local;		/* Representation of local endpoint */
 	struct rxrpc_peer	*peer;		/* Remote endpoint */
 	struct key		*key;		/* Security details */
+	const struct rxrpc_security *security;	/* applied security module */
 	refcount_t		ref;
 	atomic_t		active;		/* Number of active users */
 	unsigned int		debug_id;
@@ -593,6 +593,7 @@ enum rxrpc_congest_mode {
 struct rxrpc_call {
 	struct rcu_head		rcu;
 	struct rxrpc_connection	*conn;		/* connection carrying call */
+	struct rxrpc_bundle	*bundle;	/* Connection bundle to use */
 	struct rxrpc_peer	*peer;		/* Peer record for remote address */
 	struct rxrpc_local	*local;		/* Representation of local endpoint */
 	struct rxrpc_sock __rcu	*socket;	/* socket responsible */
@@ -894,11 +895,10 @@ extern unsigned long rxrpc_conn_idle_client_fast_expiry;
 void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local);
 struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
 void rxrpc_put_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
-int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
-		       struct rxrpc_conn_parameters *, struct sockaddr_rxrpc *,
-		       gfp_t);
+int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp);
 void rxrpc_expose_client_call(struct rxrpc_call *);
 void rxrpc_disconnect_client_call(struct rxrpc_bundle *, struct rxrpc_call *);
+void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 void rxrpc_put_client_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
 void rxrpc_discard_expired_client_conns(struct work_struct *);
 void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 705f6e26cc75..835e9781afc6 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -365,7 +365,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	/* Set up or get a connection record and set the protocol parameters,
 	 * including channel number and call ID.
 	 */
-	ret = rxrpc_connect_call(rx, call, cp, srx, gfp);
+	ret = rxrpc_connect_call(call, gfp);
 	if (ret < 0)
 		goto error_attached_to_socket;
 
@@ -663,6 +663,8 @@ static void rxrpc_destroy_call(struct work_struct *work)
 
 	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
 	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
+	rxrpc_deactivate_bundle(call->bundle);
+	rxrpc_put_bundle(call->bundle, rxrpc_bundle_put_call);
 	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	rxrpc_put_local(call->local, rxrpc_local_put_call);
 	call_rcu(&call->rcu, rxrpc_rcu_free_call);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 59ce5c08cf57..c0db7722571e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -34,7 +34,10 @@ __read_mostly unsigned int rxrpc_reap_client_connections = 900;
 __read_mostly unsigned long rxrpc_conn_idle_client_expiry = 2 * 60 * HZ;
 __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 
-static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
+static void rxrpc_activate_bundle(struct rxrpc_bundle *bundle)
+{
+	atomic_inc(&bundle->active);
+}
 
 /*
  * Get a connection ID and epoch for a client connection from the global pool.
@@ -109,20 +112,21 @@ void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local)
 /*
  * Allocate a connection bundle.
  */
-static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
+static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_call *call,
 					       gfp_t gfp)
 {
 	struct rxrpc_bundle *bundle;
 
 	bundle = kzalloc(sizeof(*bundle), gfp);
 	if (bundle) {
-		bundle->local		= cp->local;
-		bundle->peer		= rxrpc_get_peer(cp->peer, rxrpc_peer_get_bundle);
-		bundle->key		= cp->key;
-		bundle->exclusive	= cp->exclusive;
-		bundle->upgrade		= cp->upgrade;
-		bundle->service_id	= cp->service_id;
-		bundle->security_level	= cp->security_level;
+		bundle->local		= call->local;
+		bundle->peer		= rxrpc_get_peer(call->peer, rxrpc_peer_get_bundle);
+		bundle->key		= key_get(call->key);
+		bundle->security	= call->security;
+		bundle->exclusive	= test_bit(RXRPC_CALL_EXCLUSIVE, &call->flags);
+		bundle->upgrade		= test_bit(RXRPC_CALL_UPGRADE, &call->flags);
+		bundle->service_id	= call->dest_srx.srx_service;
+		bundle->security_level	= call->security_level;
 		refcount_set(&bundle->ref, 1);
 		atomic_set(&bundle->active, 1);
 		spin_lock_init(&bundle->channel_lock);
@@ -146,19 +150,23 @@ static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 {
 	trace_rxrpc_bundle(bundle->debug_id, 1, rxrpc_bundle_free);
 	rxrpc_put_peer(bundle->peer, rxrpc_peer_put_bundle);
+	key_put(bundle->key);
 	kfree(bundle);
 }
 
 void rxrpc_put_bundle(struct rxrpc_bundle *bundle, enum rxrpc_bundle_trace why)
 {
-	unsigned int id = bundle->debug_id;
+	unsigned int id;
 	bool dead;
 	int r;
 
-	dead = __refcount_dec_and_test(&bundle->ref, &r);
-	trace_rxrpc_bundle(id, r - 1, why);
-	if (dead)
-		rxrpc_free_bundle(bundle);
+	if (bundle) {
+		id = bundle->debug_id;
+		dead = __refcount_dec_and_test(&bundle->ref, &r);
+		trace_rxrpc_bundle(id, r - 1, why);
+		if (dead)
+			rxrpc_free_bundle(bundle);
+	}
 }
 
 /*
@@ -272,20 +280,23 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
  * Look up the conn bundle that matches the connection parameters, adding it if
  * it doesn't yet exist.
  */
-static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *cp,
-						 gfp_t gfp)
+static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_call *call, gfp_t gfp)
 {
 	static atomic_t rxrpc_bundle_id;
 	struct rxrpc_bundle *bundle, *candidate;
-	struct rxrpc_local *local = cp->local;
+	struct rxrpc_local *local = call->local;
 	struct rb_node *p, **pp, *parent;
 	long diff;
+	bool upgrade = test_bit(RXRPC_CALL_UPGRADE, &call->flags);
 
 	_enter("{%px,%x,%u,%u}",
-	       cp->peer, key_serial(cp->key), cp->security_level, cp->upgrade);
+	       call->peer, key_serial(call->key), call->security_level,
+	       upgrade);
 
-	if (cp->exclusive)
-		return rxrpc_alloc_bundle(cp, gfp);
+	if (test_bit(RXRPC_CALL_EXCLUSIVE, &call->flags)) {
+		call->bundle = rxrpc_alloc_bundle(call, gfp);
+		return call->bundle;
+	}
 
 	/* First, see if the bundle is already there. */
 	_debug("search 1");
@@ -294,11 +305,11 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	while (p) {
 		bundle = rb_entry(p, struct rxrpc_bundle, local_node);
 
-#define cmp(X) ((long)bundle->X - (long)cp->X)
-		diff = (cmp(peer) ?:
-			cmp(key) ?:
-			cmp(security_level) ?:
-			cmp(upgrade));
+#define cmp(X, Y) ((long)(X) - (long)(Y))
+		diff = (cmp(bundle->peer, call->peer) ?:
+			cmp(bundle->key, call->key) ?:
+			cmp(bundle->security_level, call->security_level) ?:
+			cmp(bundle->upgrade, upgrade));
 #undef cmp
 		if (diff < 0)
 			p = p->rb_left;
@@ -311,9 +322,9 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	_debug("not found");
 
 	/* It wasn't.  We need to add one. */
-	candidate = rxrpc_alloc_bundle(cp, gfp);
+	candidate = rxrpc_alloc_bundle(call, gfp);
 	if (!candidate)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	_debug("search 2");
 	spin_lock(&local->client_bundles_lock);
@@ -323,11 +334,11 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 		parent = *pp;
 		bundle = rb_entry(parent, struct rxrpc_bundle, local_node);
 
-#define cmp(X) ((long)bundle->X - (long)cp->X)
-		diff = (cmp(peer) ?:
-			cmp(key) ?:
-			cmp(security_level) ?:
-			cmp(upgrade));
+#define cmp(X, Y) ((long)(X) - (long)(Y))
+		diff = (cmp(bundle->peer, call->peer) ?:
+			cmp(bundle->key, call->key) ?:
+			cmp(bundle->security_level, call->security_level) ?:
+			cmp(bundle->upgrade, upgrade));
 #undef cmp
 		if (diff < 0)
 			pp = &(*pp)->rb_left;
@@ -341,19 +352,19 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	candidate->debug_id = atomic_inc_return(&rxrpc_bundle_id);
 	rb_link_node(&candidate->local_node, parent, pp);
 	rb_insert_color(&candidate->local_node, &local->client_bundles);
-	rxrpc_get_bundle(candidate, rxrpc_bundle_get_client_call);
+	call->bundle = rxrpc_get_bundle(candidate, rxrpc_bundle_get_client_call);
 	spin_unlock(&local->client_bundles_lock);
-	_leave(" = %u [new]", candidate->debug_id);
-	return candidate;
+	_leave(" = B=%u [new]", call->bundle->debug_id);
+	return call->bundle;
 
 found_bundle_free:
 	rxrpc_free_bundle(candidate);
 found_bundle:
-	rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_call);
-	atomic_inc(&bundle->active);
+	call->bundle = rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_call);
+	rxrpc_activate_bundle(bundle);
 	spin_unlock(&local->client_bundles_lock);
-	_leave(" = %u [found]", bundle->debug_id);
-	return bundle;
+	_leave(" = B=%u [found]", call->bundle->debug_id);
+	return call->bundle;
 }
 
 /*
@@ -362,31 +373,25 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
  * If we return with a connection, the call will be on its waiting list.  It's
  * left to the caller to assign a channel and wake up the call.
  */
-static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_sock *rx,
-					    struct rxrpc_call *call,
-					    struct rxrpc_conn_parameters *cp,
-					    struct sockaddr_rxrpc *srx,
-					    gfp_t gfp)
+static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_call *call, gfp_t gfp)
 {
 	struct rxrpc_bundle *bundle;
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
-	cp->peer = rxrpc_lookup_peer(cp->local, srx, gfp);
-	if (!cp->peer)
+	call->peer = rxrpc_lookup_peer(call->local, &call->dest_srx, gfp);
+	if (!call->peer)
 		goto error;
 
 	call->tx_last_sent = ktime_get_real();
-	call->cong_ssthresh = cp->peer->cong_ssthresh;
+	call->cong_ssthresh = call->peer->cong_ssthresh;
 	if (call->cong_cwnd >= call->cong_ssthresh)
 		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
 	else
 		call->cong_mode = RXRPC_CALL_SLOW_START;
-	if (cp->upgrade)
-		__set_bit(RXRPC_CALL_UPGRADE, &call->flags);
 
 	/* Find the client connection bundle. */
-	bundle = rxrpc_look_up_bundle(cp, gfp);
+	bundle = rxrpc_look_up_bundle(call, gfp);
 	if (!bundle)
 		goto error;
 
@@ -449,7 +454,7 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 			if (old)
 				trace_rxrpc_client(old, -1, rxrpc_client_replace);
 			candidate->bundle_shift = shift;
-			atomic_inc(&bundle->active);
+			rxrpc_activate_bundle(bundle);
 			bundle->conns[i] = candidate;
 			for (j = 0; j < RXRPC_MAXCALLS; j++)
 				set_bit(shift + j, &bundle->avail_chans);
@@ -541,7 +546,6 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	rxrpc_see_call(call, rxrpc_call_see_activate_client);
 	list_del_init(&call->chan_wait_link);
-	call->peer	= rxrpc_get_peer(conn->peer, rxrpc_peer_get_activate_call);
 	call->conn	= rxrpc_get_connection(conn, rxrpc_conn_get_activate_call);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
@@ -705,14 +709,11 @@ static int rxrpc_wait_for_channel(struct rxrpc_bundle *bundle,
  * find a connection for a call
  * - called in process context with IRQs enabled
  */
-int rxrpc_connect_call(struct rxrpc_sock *rx,
-		       struct rxrpc_call *call,
-		       struct rxrpc_conn_parameters *cp,
-		       struct sockaddr_rxrpc *srx,
-		       gfp_t gfp)
+int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 {
 	struct rxrpc_bundle *bundle;
-	struct rxrpc_net *rxnet = cp->local->rxnet;
+	struct rxrpc_local *local = call->local;
+	struct rxrpc_net *rxnet = local->rxnet;
 	int ret = 0;
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
@@ -721,7 +722,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 
 	rxrpc_get_call(call, rxrpc_call_get_io_thread);
 
-	bundle = rxrpc_prep_call(rx, call, cp, srx, gfp);
+	bundle = rxrpc_prep_call(call, gfp);
 	if (IS_ERR(bundle)) {
 		rxrpc_put_call(call, rxrpc_call_get_io_thread);
 		ret = PTR_ERR(bundle);
@@ -738,9 +739,6 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	/* Paired with the write barrier in rxrpc_activate_one_channel(). */
 	smp_rmb();
 
-out_put_bundle:
-	rxrpc_deactivate_bundle(bundle);
-	rxrpc_put_bundle(bundle, rxrpc_bundle_get_client_call);
 out:
 	_leave(" = %d", ret);
 	return ret;
@@ -758,7 +756,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 	trace_rxrpc_client(call->conn, ret, rxrpc_client_chan_wait_failed);
 	rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
 	rxrpc_disconnect_client_call(bundle, call);
-	goto out_put_bundle;
+	goto out;
 }
 
 /*
@@ -945,11 +943,15 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 /*
  * Drop the active count on a bundle.
  */
-static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
+void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
 {
-	struct rxrpc_local *local = bundle->local;
+	struct rxrpc_local *local;
 	bool need_put = false;
 
+	if (!bundle)
+		return;
+
+	local = bundle->local;
 	if (atomic_dec_and_lock(&bundle->active, &local->client_bundles_lock)) {
 		if (!bundle->exclusive) {
 			_debug("erase bundle");
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 2e3f0a222e1b..2a7d5378300c 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -208,7 +208,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	}
 
 	if (rxrpc_is_client_call(call)) {
-		rxrpc_disconnect_client_call(conn->bundle, call);
+		rxrpc_disconnect_client_call(call->bundle, call);
 	} else {
 		spin_lock(&conn->bundle->channel_lock);
 		__rxrpc_disconnect_call(conn, call);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index d67808b659f1..2a003c3a9897 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -564,7 +564,6 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 				     atomic_inc_return(&rxrpc_debug_id));
 	/* The socket is now unlocked */
 
-	rxrpc_put_peer(cp.peer, rxrpc_peer_put_discard_tmp);
 	_leave(" = %p\n", call);
 	return call;
 }


