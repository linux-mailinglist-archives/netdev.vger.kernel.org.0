Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2A63DB45
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiK3Q71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiK3Q6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:58:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911078BD2F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3YmpGDKcnBEnpAHkJlNK2byBHIgeHPDnNurcx2Ouqo=;
        b=YcjkOmdvBj8J9XIepywYbFBfL3CcKwrANYvafrr+qWY5rw9LlhsyEZeEAlcl56Vkn2e+1k
        m/NWYOZFeIwb4eJCknYo3M8uY4bpD/yw4BzrAt51cGs3/VQkhdlRXTwyYpSPOTz7j/gm0J
        Ra7fMrNmu7KCClWN2Ap5nyiUfWKML00=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-_ZyxTHPUPQmHds55cGh_SA-1; Wed, 30 Nov 2022 11:56:40 -0500
X-MC-Unique: _ZyxTHPUPQmHds55cGh_SA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70ED33C10149;
        Wed, 30 Nov 2022 16:56:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 973EB40C83D9;
        Wed, 30 Nov 2022 16:56:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/35] rxrpc: Don't hold a ref for connection
 workqueue
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:56:36 +0000
Message-ID: <166982739680.621383.8533102684905128534.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
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

Currently, rxrpc gives the connection's work item a ref on the connection
when it queues it - and this is called from the timer expiration function.
The problem comes when queue_work() fails (ie. the work item is already
queued): the timer routine must put the ref - but this may cause the
cleanup code to run.

This has the unfortunate effect that the cleanup code may then be run in
softirq context - which means that any spinlocks it might need to touch
have to be guarded to disable softirqs (ie. they need a "_bh" suffix).

 (1) Don't give a ref to the work item.

 (2) Simplify handling of service connections by adding a separate active
     count so that the refcount isn't also used for this.

 (3) Connection destruction for both client and service connections can
     then be cleaned up by putting rxrpc_put_connection() out of line and
     making a tidy progression through the destruction code (offloaded to a
     workqueue if put from softirq or processor function context).  The RCU
     part of the cleanup then only deals with the freeing at the end.

 (4) Make rxrpc_queue_conn() return immediately if it sees the active count
     is -1 rather then queuing the connection.

 (5) Make sure that the cleanup routine waits for the work item to
     complete.

 (6) Stash the rxrpc_net pointer in the conn struct so that the rcu free
     routine can use it, even if the local endpoint has been freed.

Unfortunately, neither the timer nor the work item can simply get around
the problem by just using refcount_inc_not_zero() as the waits would still
have to be done, and there would still be the possibility of having to put
the ref in the expiration function.

Note the connection work item is mostly going to go away with the main
event work being transferred to the I/O thread, so the wait in (6) will
become obsolete.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   11 +--
 net/rxrpc/ar-internal.h      |   25 ++----
 net/rxrpc/call_accept.c      |    1 
 net/rxrpc/conn_client.c      |   31 ++------
 net/rxrpc/conn_event.c       |    4 -
 net/rxrpc/conn_object.c      |  169 +++++++++++++++++++++++-------------------
 net/rxrpc/conn_service.c     |    4 +
 net/rxrpc/net_ns.c           |    2 
 net/rxrpc/proc.c             |    5 +
 9 files changed, 123 insertions(+), 129 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4538de0079a5..44a9be9836f9 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -112,7 +112,6 @@
 	EM(rxrpc_conn_get_service_conn,		"GET svc-conn") \
 	EM(rxrpc_conn_new_client,		"NEW client  ") \
 	EM(rxrpc_conn_new_service,		"NEW service ") \
-	EM(rxrpc_conn_put_already_queued,	"PUT alreadyq") \
 	EM(rxrpc_conn_put_call,			"PUT call    ") \
 	EM(rxrpc_conn_put_call_input,		"PUT inp-call") \
 	EM(rxrpc_conn_put_conn_input,		"PUT inp-conn") \
@@ -121,13 +120,13 @@
 	EM(rxrpc_conn_put_local_dead,		"PUT loc-dead") \
 	EM(rxrpc_conn_put_noreuse,		"PUT noreuse ") \
 	EM(rxrpc_conn_put_poke,			"PUT poke    ") \
+	EM(rxrpc_conn_put_service_reaped,	"PUT svc-reap") \
 	EM(rxrpc_conn_put_unbundle,		"PUT unbundle") \
 	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
-	EM(rxrpc_conn_put_work,			"PUT work    ") \
-	EM(rxrpc_conn_queue_challenge,		"GQ  chall   ") \
-	EM(rxrpc_conn_queue_retry_work,		"GQ  retry-wk") \
-	EM(rxrpc_conn_queue_rx_work,		"GQ  rx-work ") \
-	EM(rxrpc_conn_queue_timer,		"GQ  timer   ") \
+	EM(rxrpc_conn_queue_challenge,		"QUE chall   ") \
+	EM(rxrpc_conn_queue_retry_work,		"QUE retry-wk") \
+	EM(rxrpc_conn_queue_rx_work,		"QUE rx-work ") \
+	EM(rxrpc_conn_queue_timer,		"QUE timer   ") \
 	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
 	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
 	E_(rxrpc_conn_see_work,			"SEE work    ")
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 03523a864c11..41a57c145f2b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -76,7 +76,7 @@ struct rxrpc_net {
 	bool			kill_all_client_conns;
 	atomic_t		nr_client_conns;
 	spinlock_t		client_conn_cache_lock; /* Lock for ->*_client_conns */
-	spinlock_t		client_conn_discard_lock; /* Prevent multiple discarders */
+	struct mutex		client_conn_discard_lock; /* Prevent multiple discarders */
 	struct list_head	idle_client_conns;
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
@@ -432,9 +432,11 @@ struct rxrpc_connection {
 	struct rxrpc_conn_proto	proto;
 	struct rxrpc_local	*local;		/* Representation of local endpoint */
 	struct rxrpc_peer	*peer;		/* Remote endpoint */
+	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
 	struct key		*key;		/* Security details */
 
 	refcount_t		ref;
+	atomic_t		active;		/* Active count for service conns */
 	struct rcu_head		rcu;
 	struct list_head	cache_link;
 
@@ -455,6 +457,7 @@ struct rxrpc_connection {
 
 	struct timer_list	timer;		/* Conn event timer */
 	struct work_struct	processor;	/* connection event processor */
+	struct work_struct	destructor;	/* In-process-context destroyer */
 	struct rxrpc_bundle	*bundle;	/* Client connection bundle */
 	struct rb_node		service_node;	/* Node in peer->service_conns */
 	struct list_head	proc_link;	/* link in procfs list */
@@ -897,20 +900,20 @@ void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
 extern unsigned int rxrpc_connection_expiry;
 extern unsigned int rxrpc_closed_conn_expiry;
 
-struct rxrpc_connection *rxrpc_alloc_connection(gfp_t);
+struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *, gfp_t);
 struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *,
 						   struct sk_buff *,
 						   struct rxrpc_peer **);
 void __rxrpc_disconnect_call(struct rxrpc_connection *, struct rxrpc_call *);
 void rxrpc_disconnect_call(struct rxrpc_call *);
-void rxrpc_kill_connection(struct rxrpc_connection *);
-bool rxrpc_queue_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
+void rxrpc_kill_client_conn(struct rxrpc_connection *);
+void rxrpc_queue_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
 void rxrpc_see_connection(struct rxrpc_connection *, enum rxrpc_conn_trace);
 struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *,
 					      enum rxrpc_conn_trace);
 struct rxrpc_connection *rxrpc_get_connection_maybe(struct rxrpc_connection *,
 						    enum rxrpc_conn_trace);
-void rxrpc_put_service_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
+void rxrpc_put_connection(struct rxrpc_connection *, enum rxrpc_conn_trace);
 void rxrpc_service_connection_reaper(struct work_struct *);
 void rxrpc_destroy_all_connections(struct rxrpc_net *);
 
@@ -924,18 +927,6 @@ static inline bool rxrpc_conn_is_service(const struct rxrpc_connection *conn)
 	return !rxrpc_conn_is_client(conn);
 }
 
-static inline void rxrpc_put_connection(struct rxrpc_connection *conn,
-					enum rxrpc_conn_trace why)
-{
-	if (!conn)
-		return;
-
-	if (rxrpc_conn_is_client(conn))
-		rxrpc_put_client_conn(conn, why);
-	else
-		rxrpc_put_service_conn(conn, why);
-}
-
 static inline void rxrpc_reduce_conn_timer(struct rxrpc_connection *conn,
 					   unsigned long expire_at)
 {
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index dd4ca4bee77f..8d106b626aa3 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -308,6 +308,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		rxrpc_new_incoming_connection(rx, conn, sec, skb);
 	} else {
 		rxrpc_get_connection(conn, rxrpc_conn_get_service_conn);
+		atomic_inc(&conn->active);
 	}
 
 	/* And now we can allocate and set up a new call */
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 34ff6fa85c32..9485a3d18f29 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -51,7 +51,7 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 					  gfp_t gfp)
 {
-	struct rxrpc_net *rxnet = conn->local->rxnet;
+	struct rxrpc_net *rxnet = conn->rxnet;
 	int id;
 
 	_enter("");
@@ -179,7 +179,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 
 	_enter("");
 
-	conn = rxrpc_alloc_connection(gfp);
+	conn = rxrpc_alloc_connection(rxnet, gfp);
 	if (!conn) {
 		_leave(" = -ENOMEM");
 		return ERR_PTR(-ENOMEM);
@@ -243,7 +243,7 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	if (!conn)
 		goto dont_reuse;
 
-	rxnet = conn->local->rxnet;
+	rxnet = conn->rxnet;
 	if (test_bit(RXRPC_CONN_DONT_REUSE, &conn->flags))
 		goto dont_reuse;
 
@@ -970,7 +970,7 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
 /*
  * Clean up a dead client connection.
  */
-static void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
+void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_local *local = conn->local;
 	struct rxrpc_net *rxnet = local->rxnet;
@@ -981,23 +981,6 @@ static void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 	atomic_dec(&rxnet->nr_client_conns);
 
 	rxrpc_put_client_connection_id(conn);
-	rxrpc_kill_connection(conn);
-}
-
-/*
- * Clean up a dead client connections.
- */
-void rxrpc_put_client_conn(struct rxrpc_connection *conn,
-			   enum rxrpc_conn_trace why)
-{
-	unsigned int debug_id = conn->debug_id;
-	bool dead;
-	int r;
-
-	dead = __refcount_dec_and_test(&conn->ref, &r);
-	trace_rxrpc_conn(debug_id, r - 1, why);
-	if (dead)
-		rxrpc_kill_client_conn(conn);
 }
 
 /*
@@ -1023,7 +1006,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	}
 
 	/* Don't double up on the discarding */
-	if (!spin_trylock(&rxnet->client_conn_discard_lock)) {
+	if (!mutex_trylock(&rxnet->client_conn_discard_lock)) {
 		_leave(" [already]");
 		return;
 	}
@@ -1061,6 +1044,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 			goto not_yet_expired;
 	}
 
+	atomic_dec(&conn->active);
 	trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 	list_del_init(&conn->cache_link);
 
@@ -1087,7 +1071,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 
 out:
 	spin_unlock(&rxnet->client_conn_cache_lock);
-	spin_unlock(&rxnet->client_conn_discard_lock);
+	mutex_unlock(&rxnet->client_conn_discard_lock);
 	_leave("");
 }
 
@@ -1127,6 +1111,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 	list_for_each_entry_safe(conn, tmp, &rxnet->idle_client_conns,
 				 cache_link) {
 		if (conn->local == local) {
+			atomic_dec(&conn->active);
 			trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 			list_move(&conn->cache_link, &graveyard);
 		}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 49d885f73fa5..23a74e35052d 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -478,8 +478,4 @@ void rxrpc_process_connection(struct work_struct *work)
 		rxrpc_do_process_connection(conn);
 		rxrpc_unuse_local(conn->local, rxrpc_local_unuse_conn_work);
 	}
-
-	rxrpc_put_connection(conn, rxrpc_conn_put_work);
-	_leave("");
-	return;
 }
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index f7c271a740ed..c2e05ea29f12 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -19,7 +19,9 @@
 unsigned int __read_mostly rxrpc_connection_expiry = 10 * 60;
 unsigned int __read_mostly rxrpc_closed_conn_expiry = 10;
 
-static void rxrpc_destroy_connection(struct rcu_head *);
+static void rxrpc_clean_up_connection(struct work_struct *work);
+static void rxrpc_set_service_reap_timer(struct rxrpc_net *rxnet,
+					 unsigned long reap_at);
 
 static void rxrpc_connection_timer(struct timer_list *timer)
 {
@@ -32,7 +34,8 @@ static void rxrpc_connection_timer(struct timer_list *timer)
 /*
  * allocate a new connection
  */
-struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
+struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
+						gfp_t gfp)
 {
 	struct rxrpc_connection *conn;
 
@@ -42,10 +45,12 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 	if (conn) {
 		INIT_LIST_HEAD(&conn->cache_link);
 		timer_setup(&conn->timer, &rxrpc_connection_timer, 0);
-		INIT_WORK(&conn->processor, &rxrpc_process_connection);
+		INIT_WORK(&conn->processor, rxrpc_process_connection);
+		INIT_WORK(&conn->destructor, rxrpc_clean_up_connection);
 		INIT_LIST_HEAD(&conn->proc_link);
 		INIT_LIST_HEAD(&conn->link);
 		skb_queue_head_init(&conn->rx_queue);
+		conn->rxnet = rxnet;
 		conn->security = &rxrpc_no_security;
 		spin_lock_init(&conn->state_lock);
 		conn->debug_id = atomic_inc_return(&rxrpc_debug_id);
@@ -224,53 +229,20 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	conn->idle_timestamp = jiffies;
-}
-
-/*
- * Kill off a connection.
- */
-void rxrpc_kill_connection(struct rxrpc_connection *conn)
-{
-	struct rxrpc_net *rxnet = conn->local->rxnet;
-
-	ASSERT(!rcu_access_pointer(conn->channels[0].call) &&
-	       !rcu_access_pointer(conn->channels[1].call) &&
-	       !rcu_access_pointer(conn->channels[2].call) &&
-	       !rcu_access_pointer(conn->channels[3].call));
-	ASSERT(list_empty(&conn->cache_link));
-
-	write_lock(&rxnet->conn_lock);
-	list_del_init(&conn->proc_link);
-	write_unlock(&rxnet->conn_lock);
-
-	/* Drain the Rx queue.  Note that even though we've unpublished, an
-	 * incoming packet could still be being added to our Rx queue, so we
-	 * will need to drain it again in the RCU cleanup handler.
-	 */
-	rxrpc_purge_queue(&conn->rx_queue);
-
-	/* Leave final destruction to RCU.  The connection processor work item
-	 * must carry a ref on the connection to prevent us getting here whilst
-	 * it is queued or running.
-	 */
-	call_rcu(&conn->rcu, rxrpc_destroy_connection);
+	if (atomic_dec_and_test(&conn->active))
+		rxrpc_set_service_reap_timer(conn->rxnet,
+					     jiffies + rxrpc_connection_expiry);
 }
 
 /*
  * Queue a connection's work processor, getting a ref to pass to the work
  * queue.
  */
-bool rxrpc_queue_conn(struct rxrpc_connection *conn, enum rxrpc_conn_trace why)
+void rxrpc_queue_conn(struct rxrpc_connection *conn, enum rxrpc_conn_trace why)
 {
-	int r;
-
-	if (!__refcount_inc_not_zero(&conn->ref, &r))
-		return false;
-	if (rxrpc_queue_work(&conn->processor))
-		trace_rxrpc_conn(conn->debug_id, why, r + 1);
-	else
-		rxrpc_put_connection(conn, rxrpc_conn_put_already_queued);
-	return true;
+	if (atomic_read(&conn->active) >= 0 &&
+	    rxrpc_queue_work(&conn->processor))
+		rxrpc_see_connection(conn, why);
 }
 
 /*
@@ -327,51 +299,96 @@ static void rxrpc_set_service_reap_timer(struct rxrpc_net *rxnet,
 		timer_reduce(&rxnet->service_conn_reap_timer, reap_at);
 }
 
-/*
- * Release a service connection
- */
-void rxrpc_put_service_conn(struct rxrpc_connection *conn,
-			    enum rxrpc_conn_trace why)
-{
-	unsigned int debug_id = conn->debug_id;
-	int r;
-
-	__refcount_dec(&conn->ref, &r);
-	trace_rxrpc_conn(debug_id, r - 1, why);
-	if (r - 1 == 1)
-		rxrpc_set_service_reap_timer(conn->local->rxnet,
-					     jiffies + rxrpc_connection_expiry);
-}
-
 /*
  * destroy a virtual connection
  */
-static void rxrpc_destroy_connection(struct rcu_head *rcu)
+static void rxrpc_rcu_free_connection(struct rcu_head *rcu)
 {
 	struct rxrpc_connection *conn =
 		container_of(rcu, struct rxrpc_connection, rcu);
+	struct rxrpc_net *rxnet = conn->rxnet;
 
 	_enter("{%d,u=%d}", conn->debug_id, refcount_read(&conn->ref));
 
 	trace_rxrpc_conn(conn->debug_id, refcount_read(&conn->ref),
 			 rxrpc_conn_free);
+	kfree(conn);
 
-	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
+	if (atomic_dec_and_test(&rxnet->nr_conns))
+		wake_up_var(&rxnet->nr_conns);
+}
+
+/*
+ * Clean up a dead connection.
+ */
+static void rxrpc_clean_up_connection(struct work_struct *work)
+{
+	struct rxrpc_connection *conn =
+		container_of(work, struct rxrpc_connection, destructor);
+	struct rxrpc_net *rxnet = conn->rxnet;
+
+	ASSERT(!rcu_access_pointer(conn->channels[0].call) &&
+	       !rcu_access_pointer(conn->channels[1].call) &&
+	       !rcu_access_pointer(conn->channels[2].call) &&
+	       !rcu_access_pointer(conn->channels[3].call));
+	ASSERT(list_empty(&conn->cache_link));
 
 	del_timer_sync(&conn->timer);
+	cancel_work_sync(&conn->processor); /* Processing may restart the timer */
+	del_timer_sync(&conn->timer);
+
+	write_lock(&rxnet->conn_lock);
+	list_del_init(&conn->proc_link);
+	write_unlock(&rxnet->conn_lock);
+
 	rxrpc_purge_queue(&conn->rx_queue);
 
+	rxrpc_kill_client_conn(conn);
+
 	conn->security->clear(conn);
 	key_put(conn->key);
 	rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
 	rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
-
-	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
-		wake_up_var(&conn->local->rxnet->nr_conns);
 	rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
 
-	kfree(conn);
-	_leave("");
+	/* Drain the Rx queue.  Note that even though we've unpublished, an
+	 * incoming packet could still be being added to our Rx queue, so we
+	 * will need to drain it again in the RCU cleanup handler.
+	 */
+	rxrpc_purge_queue(&conn->rx_queue);
+
+	call_rcu(&conn->rcu, rxrpc_rcu_free_connection);
+}
+
+/*
+ * Drop a ref on a connection.
+ */
+void rxrpc_put_connection(struct rxrpc_connection *conn,
+			  enum rxrpc_conn_trace why)
+{
+	unsigned int debug_id;
+	bool dead;
+	int r;
+
+	if (!conn)
+		return;
+
+	debug_id = conn->debug_id;
+	dead = __refcount_dec_and_test(&conn->ref, &r);
+	trace_rxrpc_conn(debug_id, r - 1, why);
+	if (dead) {
+		del_timer(&conn->timer);
+		cancel_work(&conn->processor);
+
+		if (in_softirq() || work_busy(&conn->processor) ||
+		    timer_pending(&conn->timer))
+			/* Can't use the rxrpc workqueue as we need to cancel/flush
+			 * something that may be running/waiting there.
+			 */
+			schedule_work(&conn->destructor);
+		else
+			rxrpc_clean_up_connection(&conn->destructor);
+	}
 }
 
 /*
@@ -383,6 +400,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 	struct rxrpc_net *rxnet =
 		container_of(work, struct rxrpc_net, service_conn_reaper);
 	unsigned long expire_at, earliest, idle_timestamp, now;
+	int active;
 
 	LIST_HEAD(graveyard);
 
@@ -393,8 +411,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 
 	write_lock(&rxnet->conn_lock);
 	list_for_each_entry_safe(conn, _p, &rxnet->service_conns, link) {
-		ASSERTCMP(refcount_read(&conn->ref), >, 0);
-		if (likely(refcount_read(&conn->ref) > 1))
+		ASSERTCMP(atomic_read(&conn->active), >=, 0);
+		if (likely(atomic_read(&conn->active) > 0))
 			continue;
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
@@ -405,8 +423,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 			if (conn->local->service_closed)
 				expire_at = idle_timestamp + rxrpc_closed_conn_expiry * HZ;
 
-			_debug("reap CONN %d { u=%d,t=%ld }",
-			       conn->debug_id, refcount_read(&conn->ref),
+			_debug("reap CONN %d { a=%d,t=%ld }",
+			       conn->debug_id, atomic_read(&conn->active),
 			       (long)expire_at - (long)now);
 
 			if (time_before(now, expire_at)) {
@@ -416,10 +434,11 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 			}
 		}
 
-		/* The usage count sits at 1 whilst the object is unused on the
-		 * list; we reduce that to 0 to make the object unavailable.
+		/* The activity count sits at 0 whilst the conn is unused on
+		 * the list; we reduce that to -1 to make the conn unavailable.
 		 */
-		if (!refcount_dec_if_one(&conn->ref))
+		active = 0;
+		if (!atomic_try_cmpxchg(&conn->active, &active, -1))
 			continue;
 		rxrpc_see_connection(conn, rxrpc_conn_see_reap_service);
 
@@ -443,8 +462,8 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 				  link);
 		list_del_init(&conn->link);
 
-		ASSERTCMP(refcount_read(&conn->ref), ==, 0);
-		rxrpc_kill_connection(conn);
+		ASSERTCMP(atomic_read(&conn->active), ==, -1);
+		rxrpc_put_connection(conn, rxrpc_conn_put_service_reaped);
 	}
 
 	_leave("");
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 2c44d67b43dc..b5ae7c753fc3 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -125,7 +125,7 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer *peer,
 struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxnet,
 							   gfp_t gfp)
 {
-	struct rxrpc_connection *conn = rxrpc_alloc_connection(gfp);
+	struct rxrpc_connection *conn = rxrpc_alloc_connection(rxnet, gfp);
 
 	if (conn) {
 		/* We maintain an extra ref on the connection whilst it is on
@@ -181,6 +181,8 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 	    conn->service_id == rx->service_upgrade.from)
 		conn->service_id = rx->service_upgrade.to;
 
+	atomic_set(&conn->active, 1);
+
 	/* Make the connection a target for incoming packets. */
 	rxrpc_publish_service_conn(conn->peer, conn);
 }
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 84242c0e467c..5905530e2f33 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -65,7 +65,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	atomic_set(&rxnet->nr_client_conns, 0);
 	rxnet->kill_all_client_conns = false;
 	spin_lock_init(&rxnet->client_conn_cache_lock);
-	spin_lock_init(&rxnet->client_conn_discard_lock);
+	mutex_init(&rxnet->client_conn_discard_lock);
 	INIT_LIST_HEAD(&rxnet->idle_client_conns);
 	INIT_WORK(&rxnet->client_conn_reaper,
 		  rxrpc_discard_expired_client_conns);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index bb2edf6db896..d3a6d24cf871 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -159,7 +159,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq,
 			 "Proto Local                                          "
 			 " Remote                                         "
-			 " SvID ConnID   End Use State    Key     "
+			 " SvID ConnID   End Ref Act State    Key     "
 			 " Serial   ISerial  CallId0  CallId1  CallId2  CallId3\n"
 			 );
 		return 0;
@@ -177,7 +177,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 	sprintf(rbuff, "%pISpc", &conn->peer->srx.transport);
 print:
 	seq_printf(seq,
-		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u"
+		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u %3d"
 		   " %s %08x %08x %08x %08x %08x %08x %08x\n",
 		   lbuff,
 		   rbuff,
@@ -185,6 +185,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   conn->proto.cid,
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
 		   refcount_read(&conn->ref),
+		   atomic_read(&conn->active),
 		   rxrpc_conn_states[conn->state],
 		   key_serial(conn->key),
 		   atomic_read(&conn->serial),


