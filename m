Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A03D660D92
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbjAGJ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbjAGJzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:55:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7F97CBE4
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZJN4WAArgazJF4i9r/Ez2rgI/KT8oZdT33Oz91/YcQ=;
        b=BgMggw1uPa3KZ/PbRd6f73suk+t0N8Cg9CdQ6F+zXjy9EwZ/p37fttN4MOrrtsKmImT230
        gAaPh9dSWK+ue87cZ8MR4OfOdKgUmV7GoEFVrjRncRIJEMtg8LeQjNTmqGj+XjoSWhmk3F
        oOaYdj9YAM7mlSlcFnzCJonlmCsncDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-1TISVZDcMsaQryjeoVFzcw-1; Sat, 07 Jan 2023 04:54:47 -0500
X-MC-Unique: 1TISVZDcMsaQryjeoVFzcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3F90101A55E;
        Sat,  7 Jan 2023 09:54:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F35022166B30;
        Sat,  7 Jan 2023 09:54:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 17/19] rxrpc: Move the client conn cache management to the
 I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:54:45 +0000
Message-ID: <167308528524.1538866.10203354006832556960.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the management of the client connection cache to the I/O thread rather
than managing it from the namespace as an aggregate across all the local
endpoints within the namespace.

This will allow a load of locking to be got rid of in a future patch as
only the I/O thread will be looking at the this.

The downside is that the total number of cached connections on the system
can get higher because the limit is now per-local rather than per-netns.
We can, however, keep the number of client conns in use across the entire
netfs and use that to reduce the expiration time of idle connection.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |   17 +++++----
 net/rxrpc/conn_client.c  |   92 ++++++++++++++++------------------------------
 net/rxrpc/conn_object.c  |    1 -
 net/rxrpc/io_thread.c    |    4 ++
 net/rxrpc/local_object.c |   17 +++++++++
 net/rxrpc/net_ns.c       |   17 ---------
 6 files changed, 62 insertions(+), 86 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 751b1903fd6e..de84061a5447 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -76,13 +76,7 @@ struct rxrpc_net {
 
 	bool			live;
 
-	bool			kill_all_client_conns;
 	atomic_t		nr_client_conns;
-	spinlock_t		client_conn_cache_lock; /* Lock for ->*_client_conns */
-	struct mutex		client_conn_discard_lock; /* Prevent multiple discarders */
-	struct list_head	idle_client_conns;
-	struct work_struct	client_conn_reaper;
-	struct timer_list	client_conn_reap_timer;
 
 	struct hlist_head	local_endpoints;
 	struct mutex		local_mutex;	/* Lock for ->local_endpoints */
@@ -294,8 +288,16 @@ struct rxrpc_local {
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	conn_attend_q;	/* Conns requiring immediate attention */
 	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
+
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
+	bool			kill_all_client_conns;
+	spinlock_t		client_conn_cache_lock; /* Lock for ->*_client_conns */
+	struct list_head	idle_client_conns;
+	struct timer_list	client_conn_reap_timer;
+	unsigned long		client_conn_flags;
+#define RXRPC_CLIENT_CONN_REAP_TIMER	0	/* The client conn reap timer expired */
+
 	spinlock_t		lock;		/* access lock */
 	rwlock_t		services_lock;	/* lock for services list */
 	int			debug_id;	/* debug ID for printks */
@@ -946,8 +948,7 @@ void rxrpc_expose_client_call(struct rxrpc_call *);
 void rxrpc_disconnect_client_call(struct rxrpc_bundle *, struct rxrpc_call *);
 void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 void rxrpc_put_client_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
-void rxrpc_discard_expired_client_conns(struct work_struct *);
-void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
+void rxrpc_discard_expired_client_conns(struct rxrpc_local *local);
 void rxrpc_clean_up_local_conns(struct rxrpc_local *);
 
 /*
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 8b5ea68dc47e..ebb43f65ebc5 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -578,17 +578,17 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
  */
 static void rxrpc_unidle_conn(struct rxrpc_bundle *bundle, struct rxrpc_connection *conn)
 {
-	struct rxrpc_net *rxnet = bundle->local->rxnet;
+	struct rxrpc_local *local = bundle->local;
 	bool drop_ref;
 
 	if (!list_empty(&conn->cache_link)) {
 		drop_ref = false;
-		spin_lock(&rxnet->client_conn_cache_lock);
+		spin_lock(&local->client_conn_cache_lock);
 		if (!list_empty(&conn->cache_link)) {
 			list_del_init(&conn->cache_link);
 			drop_ref = true;
 		}
-		spin_unlock(&rxnet->client_conn_cache_lock);
+		spin_unlock(&local->client_conn_cache_lock);
 		if (drop_ref)
 			rxrpc_put_connection(conn, rxrpc_conn_put_unidle);
 	}
@@ -710,14 +710,10 @@ static int rxrpc_wait_for_channel(struct rxrpc_bundle *bundle,
 int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 {
 	struct rxrpc_bundle *bundle;
-	struct rxrpc_local *local = call->local;
-	struct rxrpc_net *rxnet = local->rxnet;
 	int ret = 0;
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
-	rxrpc_discard_expired_client_conns(&rxnet->client_conn_reaper);
-
 	rxrpc_get_call(call, rxrpc_call_get_io_thread);
 
 	bundle = rxrpc_prep_call(call, gfp);
@@ -787,14 +783,14 @@ void rxrpc_expose_client_call(struct rxrpc_call *call)
 /*
  * Set the reap timer.
  */
-static void rxrpc_set_client_reap_timer(struct rxrpc_net *rxnet)
+static void rxrpc_set_client_reap_timer(struct rxrpc_local *local)
 {
-	if (!rxnet->kill_all_client_conns) {
+	if (!local->kill_all_client_conns) {
 		unsigned long now = jiffies;
 		unsigned long reap_at = now + rxrpc_conn_idle_client_expiry;
 
-		if (rxnet->live)
-			timer_reduce(&rxnet->client_conn_reap_timer, reap_at);
+		if (local->rxnet->live)
+			timer_reduce(&local->client_conn_reap_timer, reap_at);
 	}
 }
 
@@ -805,7 +801,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan = NULL;
-	struct rxrpc_net *rxnet = bundle->local->rxnet;
+	struct rxrpc_local *local = bundle->local;
 	unsigned int channel;
 	bool may_reuse;
 	u32 cid;
@@ -895,11 +891,11 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 		conn->idle_timestamp = jiffies;
 
 		rxrpc_get_connection(conn, rxrpc_conn_get_idle);
-		spin_lock(&rxnet->client_conn_cache_lock);
-		list_move_tail(&conn->cache_link, &rxnet->idle_client_conns);
-		spin_unlock(&rxnet->client_conn_cache_lock);
+		spin_lock(&local->client_conn_cache_lock);
+		list_move_tail(&conn->cache_link, &local->idle_client_conns);
+		spin_unlock(&local->client_conn_cache_lock);
 
-		rxrpc_set_client_reap_timer(rxnet);
+		rxrpc_set_client_reap_timer(local);
 	}
 
 out:
@@ -986,42 +982,34 @@ void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
  * This may be called from conn setup or from a work item so cannot be
  * considered non-reentrant.
  */
-void rxrpc_discard_expired_client_conns(struct work_struct *work)
+void rxrpc_discard_expired_client_conns(struct rxrpc_local *local)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_net *rxnet =
-		container_of(work, struct rxrpc_net, client_conn_reaper);
 	unsigned long expiry, conn_expires_at, now;
 	unsigned int nr_conns;
 
 	_enter("");
 
-	if (list_empty(&rxnet->idle_client_conns)) {
+	if (list_empty(&local->idle_client_conns)) {
 		_leave(" [empty]");
 		return;
 	}
 
-	/* Don't double up on the discarding */
-	if (!mutex_trylock(&rxnet->client_conn_discard_lock)) {
-		_leave(" [already]");
-		return;
-	}
-
 	/* We keep an estimate of what the number of conns ought to be after
 	 * we've discarded some so that we don't overdo the discarding.
 	 */
-	nr_conns = atomic_read(&rxnet->nr_client_conns);
+	nr_conns = atomic_read(&local->rxnet->nr_client_conns);
 
 next:
-	spin_lock(&rxnet->client_conn_cache_lock);
+	spin_lock(&local->client_conn_cache_lock);
 
-	if (list_empty(&rxnet->idle_client_conns))
+	if (list_empty(&local->idle_client_conns))
 		goto out;
 
-	conn = list_entry(rxnet->idle_client_conns.next,
+	conn = list_entry(local->idle_client_conns.next,
 			  struct rxrpc_connection, cache_link);
 
-	if (!rxnet->kill_all_client_conns) {
+	if (!local->kill_all_client_conns) {
 		/* If the number of connections is over the reap limit, we
 		 * expedite discard by reducing the expiry timeout.  We must,
 		 * however, have at least a short grace period to be able to do
@@ -1044,7 +1032,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 	list_del_init(&conn->cache_link);
 
-	spin_unlock(&rxnet->client_conn_cache_lock);
+	spin_unlock(&local->client_conn_cache_lock);
 
 	rxrpc_unbundle_conn(conn);
 	/* Drop the ->cache_link ref */
@@ -1062,32 +1050,11 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	 * then things get messier.
 	 */
 	_debug("not yet");
-	if (!rxnet->kill_all_client_conns)
-		timer_reduce(&rxnet->client_conn_reap_timer, conn_expires_at);
+	if (!local->kill_all_client_conns)
+		timer_reduce(&local->client_conn_reap_timer, conn_expires_at);
 
 out:
-	spin_unlock(&rxnet->client_conn_cache_lock);
-	mutex_unlock(&rxnet->client_conn_discard_lock);
-	_leave("");
-}
-
-/*
- * Preemptively destroy all the client connection records rather than waiting
- * for them to time out
- */
-void rxrpc_destroy_all_client_connections(struct rxrpc_net *rxnet)
-{
-	_enter("");
-
-	spin_lock(&rxnet->client_conn_cache_lock);
-	rxnet->kill_all_client_conns = true;
-	spin_unlock(&rxnet->client_conn_cache_lock);
-
-	del_timer_sync(&rxnet->client_conn_reap_timer);
-
-	if (!rxrpc_queue_work(&rxnet->client_conn_reaper))
-		_debug("destroy: queue failed");
-
+	spin_unlock(&local->client_conn_cache_lock);
 	_leave("");
 }
 
@@ -1097,14 +1064,19 @@ void rxrpc_destroy_all_client_connections(struct rxrpc_net *rxnet)
 void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 {
 	struct rxrpc_connection *conn, *tmp;
-	struct rxrpc_net *rxnet = local->rxnet;
 	LIST_HEAD(graveyard);
 
 	_enter("");
 
-	spin_lock(&rxnet->client_conn_cache_lock);
+	spin_lock(&local->client_conn_cache_lock);
+	local->kill_all_client_conns = true;
+	spin_unlock(&local->client_conn_cache_lock);
+
+	del_timer_sync(&local->client_conn_reap_timer);
+
+	spin_lock(&local->client_conn_cache_lock);
 
-	list_for_each_entry_safe(conn, tmp, &rxnet->idle_client_conns,
+	list_for_each_entry_safe(conn, tmp, &local->idle_client_conns,
 				 cache_link) {
 		if (conn->local == local) {
 			atomic_dec(&conn->active);
@@ -1113,7 +1085,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 		}
 	}
 
-	spin_unlock(&rxnet->client_conn_cache_lock);
+	spin_unlock(&local->client_conn_cache_lock);
 
 	while (!list_empty(&graveyard)) {
 		conn = list_entry(graveyard.next,
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 2a7d5378300c..3d8c1dc6a82a 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -470,7 +470,6 @@ void rxrpc_destroy_all_connections(struct rxrpc_net *rxnet)
 	_enter("");
 
 	atomic_dec(&rxnet->nr_conns);
-	rxrpc_destroy_all_client_connections(rxnet);
 
 	del_timer_sync(&rxnet->service_conn_reap_timer);
 	rxrpc_queue_work(&rxnet->service_conn_reaper);
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 751139b3c1ac..a299cc34c140 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -435,6 +435,10 @@ int rxrpc_io_thread(void *data)
 			continue;
 		}
 
+		if (test_and_clear_bit(RXRPC_CLIENT_CONN_REAP_TIMER,
+				       &local->client_conn_flags))
+			rxrpc_discard_expired_client_conns(local);
+
 		/* Deal with calls that want immediate attention. */
 		if ((call = list_first_entry_or_null(&local->call_attend_q,
 						     struct rxrpc_call,
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ca8b3ee68b59..9bc8d08ca12c 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -82,6 +82,16 @@ static long rxrpc_local_cmp_key(const struct rxrpc_local *local,
 	}
 }
 
+static void rxrpc_client_conn_reap_timeout(struct timer_list *timer)
+{
+	struct rxrpc_local *local =
+		container_of(timer, struct rxrpc_local, client_conn_reap_timer);
+
+	if (local->kill_all_client_conns &&
+	    test_and_set_bit(RXRPC_CLIENT_CONN_REAP_TIMER, &local->client_conn_flags))
+		rxrpc_wake_up_io_thread(local);
+}
+
 /*
  * Allocate a new local endpoint.
  */
@@ -103,8 +113,15 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->conn_attend_q);
 		INIT_LIST_HEAD(&local->call_attend_q);
+
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);
+		local->kill_all_client_conns = false;
+		spin_lock_init(&local->client_conn_cache_lock);
+		INIT_LIST_HEAD(&local->idle_client_conns);
+		timer_setup(&local->client_conn_reap_timer,
+			    rxrpc_client_conn_reap_timeout, 0);
+
 		spin_lock_init(&local->lock);
 		rwlock_init(&local->services_lock);
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 5905530e2f33..a0319c040c25 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -10,15 +10,6 @@
 
 unsigned int rxrpc_net_id;
 
-static void rxrpc_client_conn_reap_timeout(struct timer_list *timer)
-{
-	struct rxrpc_net *rxnet =
-		container_of(timer, struct rxrpc_net, client_conn_reap_timer);
-
-	if (rxnet->live)
-		rxrpc_queue_work(&rxnet->client_conn_reaper);
-}
-
 static void rxrpc_service_conn_reap_timeout(struct timer_list *timer)
 {
 	struct rxrpc_net *rxnet =
@@ -63,14 +54,6 @@ static __net_init int rxrpc_init_net(struct net *net)
 		    rxrpc_service_conn_reap_timeout, 0);
 
 	atomic_set(&rxnet->nr_client_conns, 0);
-	rxnet->kill_all_client_conns = false;
-	spin_lock_init(&rxnet->client_conn_cache_lock);
-	mutex_init(&rxnet->client_conn_discard_lock);
-	INIT_LIST_HEAD(&rxnet->idle_client_conns);
-	INIT_WORK(&rxnet->client_conn_reaper,
-		  rxrpc_discard_expired_client_conns);
-	timer_setup(&rxnet->client_conn_reap_timer,
-		    rxrpc_client_conn_reap_timeout, 0);
 
 	INIT_HLIST_HEAD(&rxnet->local_endpoints);
 	mutex_init(&rxnet->local_mutex);


