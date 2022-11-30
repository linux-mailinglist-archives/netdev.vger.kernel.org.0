Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569A863DB33
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiK3Q5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiK3Q5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7C8BD24
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XilLwybICsq41/oo+GVJRMcE1JWK/wGEmIz1NglHaXQ=;
        b=W+r0bYAyQ1QhcTY0yLINPbCRnKU0TnXnmwb8iU6AjUMoLjTX2zDvfBXO1DI2IekBrXucxm
        M5SPh5Hdsrf0TnHz5N1pH7qum1IuApynFy+bDAXbK4aR9Trn4QuyiooyKbO1dl7ODKYVqd
        5r0Qs3vrcSNSlFf6Yu5hXos3uGlWZ04=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-4If4uVqIOs6zTMzlexgKCQ-1; Wed, 30 Nov 2022 11:55:57 -0500
X-MC-Unique: 4If4uVqIOs6zTMzlexgKCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EBAF100F7FE;
        Wed, 30 Nov 2022 16:55:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C65692166B26;
        Wed, 30 Nov 2022 16:55:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/35] rxrpc: trace: Don't use
 __builtin_return_address for rxrpc_conn tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:55:53 +0000
Message-ID: <166982735304.621383.2105219559780451282.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
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

In rxrpc tracing, use enums to generate lists of points of interest rather
than __builtin_return_address() for the rxrpc_conn tracepoint

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   58 +++++++++++++++++++++++++++---------------
 net/rxrpc/ar-internal.h      |   21 +++++++++------
 net/rxrpc/call_accept.c      |    9 ++-----
 net/rxrpc/call_object.c      |    2 +
 net/rxrpc/conn_client.c      |   28 ++++++++++----------
 net/rxrpc/conn_event.c       |    4 +--
 net/rxrpc/conn_object.c      |   40 +++++++++++++++--------------
 net/rxrpc/conn_service.c     |    4 +--
 net/rxrpc/input.c            |    2 +
 9 files changed, 92 insertions(+), 76 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 1c74143a51c1..e09568a8c173 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -82,14 +82,34 @@
 	E_(rxrpc_peer_put_keepalive,		"PUT keepaliv")
 
 #define rxrpc_conn_traces \
-	EM(rxrpc_conn_got,			"GOT") \
-	EM(rxrpc_conn_new_client,		"NWc") \
-	EM(rxrpc_conn_new_service,		"NWs") \
-	EM(rxrpc_conn_put_client,		"PTc") \
-	EM(rxrpc_conn_put_service,		"PTs") \
-	EM(rxrpc_conn_queued,			"QUE") \
-	EM(rxrpc_conn_reap_service,		"RPs") \
-	E_(rxrpc_conn_seen,			"SEE")
+	EM(rxrpc_conn_free,			"FREE        ") \
+	EM(rxrpc_conn_get_activate_call,	"GET act-call") \
+	EM(rxrpc_conn_get_call_input,		"GET inp-call") \
+	EM(rxrpc_conn_get_conn_input,		"GET inp-conn") \
+	EM(rxrpc_conn_get_idle,			"GET idle    ") \
+	EM(rxrpc_conn_get_poke,			"GET poke    ") \
+	EM(rxrpc_conn_get_service_conn,		"GET svc-conn") \
+	EM(rxrpc_conn_new_client,		"NEW client  ") \
+	EM(rxrpc_conn_new_service,		"NEW service ") \
+	EM(rxrpc_conn_put_already_queued,	"PUT alreadyq") \
+	EM(rxrpc_conn_put_call,			"PUT call    ") \
+	EM(rxrpc_conn_put_call_input,		"PUT inp-call") \
+	EM(rxrpc_conn_put_conn_input,		"PUT inp-conn") \
+	EM(rxrpc_conn_put_discard,		"PUT discard ") \
+	EM(rxrpc_conn_put_discard_idle,		"PUT disc-idl") \
+	EM(rxrpc_conn_put_local_dead,		"PUT loc-dead") \
+	EM(rxrpc_conn_put_noreuse,		"PUT noreuse ") \
+	EM(rxrpc_conn_put_poke,			"PUT poke    ") \
+	EM(rxrpc_conn_put_unbundle,		"PUT unbundle") \
+	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
+	EM(rxrpc_conn_put_work,			"PUT work    ") \
+	EM(rxrpc_conn_queue_challenge,		"GQ  chall   ") \
+	EM(rxrpc_conn_queue_retry_work,		"GQ  retry-wk") \
+	EM(rxrpc_conn_queue_rx_work,		"GQ  rx-work ") \
+	EM(rxrpc_conn_queue_timer,		"GQ  timer   ") \
+	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
+	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
+	E_(rxrpc_conn_see_work,			"SEE work    ")
 
 #define rxrpc_client_traces \
 	EM(rxrpc_client_activate_chans,		"Activa") \
@@ -430,30 +450,26 @@ TRACE_EVENT(rxrpc_peer,
 	    );
 
 TRACE_EVENT(rxrpc_conn,
-	    TP_PROTO(unsigned int conn_debug_id, enum rxrpc_conn_trace op,
-		     int usage, const void *where),
+	    TP_PROTO(unsigned int conn_debug_id, int ref, enum rxrpc_conn_trace why),
 
-	    TP_ARGS(conn_debug_id, op, usage, where),
+	    TP_ARGS(conn_debug_id, ref, why),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	conn		)
-		    __field(int,		op		)
-		    __field(int,		usage		)
-		    __field(const void *,	where		)
+		    __field(int,		ref		)
+		    __field(int,		why		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->conn = conn_debug_id;
-		    __entry->op = op;
-		    __entry->usage = usage;
-		    __entry->where = where;
+		    __entry->ref = ref;
+		    __entry->why = why;
 			   ),
 
-	    TP_printk("C=%08x %s u=%d sp=%pSR",
+	    TP_printk("C=%08x %s r=%d",
 		      __entry->conn,
-		      __print_symbolic(__entry->op, rxrpc_conn_traces),
-		      __entry->usage,
-		      __entry->where)
+		      __print_symbolic(__entry->why, rxrpc_conn_traces),
+		      __entry->ref)
 	    );
 
 TRACE_EVENT(rxrpc_client,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6cb111e9761c..bc8281c410c5 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -882,7 +882,7 @@ int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
 		       gfp_t);
 void rxrpc_expose_client_call(struct rxrpc_call *);
 void rxrpc_disconnect_client_call(struct rxrpc_bundle *, struct rxrpc_call *);
-void rxrpc_put_client_conn(struct rxrpc_connection *);
+void rxrpc_put_client_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
 void rxrpc_discard_expired_client_conns(struct work_struct *);
 void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
 void rxrpc_clean_up_local_conns(struct rxrpc_local *);
@@ -906,11 +906,13 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *,
 void __rxrpc_disconnect_call(struct rxrpc_connection *, struct rxrpc_call *);
 void rxrpc_disconnect_call(struct rxrpc_call *);
 void rxrpc_kill_connection(struct rxrpc_connection *);
-bool rxrpc_queue_conn(struct rxrpc_connection *);
-void rxrpc_see_connection(struct rxrpc_connection *);
-struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *);
-struct rxrpc_connection *rxrpc_get_connection_maybe(struct rxrpc_connection *);
-void rxrpc_put_service_conn(struct rxrpc_connection *);
+bool rxrpc_queue_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
+void rxrpc_see_connection(struct rxrpc_connection *, enum rxrpc_conn_trace);
+struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *,
+					      enum rxrpc_conn_trace);
+struct rxrpc_connection *rxrpc_get_connection_maybe(struct rxrpc_connection *,
+						    enum rxrpc_conn_trace);
+void rxrpc_put_service_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
 void rxrpc_service_connection_reaper(struct work_struct *);
 void rxrpc_destroy_all_connections(struct rxrpc_net *);
 
@@ -924,15 +926,16 @@ static inline bool rxrpc_conn_is_service(const struct rxrpc_connection *conn)
 	return !rxrpc_conn_is_client(conn);
 }
 
-static inline void rxrpc_put_connection(struct rxrpc_connection *conn)
+static inline void rxrpc_put_connection(struct rxrpc_connection *conn,
+					enum rxrpc_conn_trace why)
 {
 	if (!conn)
 		return;
 
 	if (rxrpc_conn_is_client(conn))
-		rxrpc_put_client_conn(conn);
+		rxrpc_put_client_conn(conn, why);
 	else
-		rxrpc_put_service_conn(conn);
+		rxrpc_put_service_conn(conn, why);
 }
 
 static inline void rxrpc_reduce_conn_timer(struct rxrpc_connection *conn,
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index f6bc3b07c3e5..04b52e28e0cc 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -91,9 +91,6 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 		b->conn_backlog[head] = conn;
 		smp_store_release(&b->conn_backlog_head,
 				  (head + 1) & (size - 1));
-
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 refcount_read(&conn->ref), here);
 	}
 
 	/* Now it gets complicated, because calls get registered with the
@@ -309,10 +306,10 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 				  (conn_tail + 1) & (RXRPC_BACKLOG_MAX - 1));
 		conn->local = rxrpc_get_local(local, rxrpc_local_get_prealloc_conn);
 		conn->peer = peer;
-		rxrpc_see_connection(conn);
+		rxrpc_see_connection(conn, rxrpc_conn_see_new_service_conn);
 		rxrpc_new_incoming_connection(rx, conn, sec, skb);
 	} else {
-		rxrpc_get_connection(conn);
+		rxrpc_get_connection(conn, rxrpc_conn_get_service_conn);
 	}
 
 	/* And now we can allocate and set up a new call */
@@ -402,7 +399,7 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	case RXRPC_CONN_SERVICE_UNSECURED:
 		conn->state = RXRPC_CONN_SERVICE_CHALLENGING;
 		set_bit(RXRPC_CONN_EV_CHALLENGE, &call->conn->events);
-		rxrpc_queue_conn(call->conn);
+		rxrpc_queue_conn(call->conn, rxrpc_conn_queue_challenge);
 		break;
 
 	case RXRPC_CONN_SERVICE:
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 1b725afd6e2c..29ec4013aa0b 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -635,7 +635,7 @@ static void rxrpc_destroy_call(struct work_struct *work)
 
 	rxrpc_delete_call_timer(call);
 
-	rxrpc_put_connection(call->conn);
+	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
 	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	kmem_cache_free(rxrpc_call_jar, call);
 	if (atomic_dec_and_test(&rxnet->nr_calls))
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 9444da235a48..dcfec6a45255 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -211,9 +211,8 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	rxrpc_get_local(conn->local, rxrpc_local_get_client_conn);
 	key_get(conn->key);
 
-	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
-			 refcount_read(&conn->ref),
-			 __builtin_return_address(0));
+	trace_rxrpc_conn(conn->debug_id, refcount_read(&conn->ref),
+			 rxrpc_conn_new_client);
 
 	atomic_inc(&rxnet->nr_client_conns);
 	trace_rxrpc_client(conn, -1, rxrpc_client_alloc);
@@ -467,10 +466,10 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 	if (candidate) {
 		_debug("discard C=%x", candidate->debug_id);
 		trace_rxrpc_client(candidate, -1, rxrpc_client_duplicate);
-		rxrpc_put_connection(candidate);
+		rxrpc_put_connection(candidate, rxrpc_conn_put_discard);
 	}
 
-	rxrpc_put_connection(old);
+	rxrpc_put_connection(old, rxrpc_conn_put_noreuse);
 	_leave("");
 }
 
@@ -544,7 +543,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	rxrpc_see_call(call);
 	list_del_init(&call->chan_wait_link);
 	call->peer	= rxrpc_get_peer(conn->peer, rxrpc_peer_get_activate_call);
-	call->conn	= rxrpc_get_connection(conn);
+	call->conn	= rxrpc_get_connection(conn, rxrpc_conn_get_activate_call);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
 	call->security	= conn->security;
@@ -592,7 +591,7 @@ static void rxrpc_unidle_conn(struct rxrpc_bundle *bundle, struct rxrpc_connecti
 		}
 		spin_unlock(&rxnet->client_conn_cache_lock);
 		if (drop_ref)
-			rxrpc_put_connection(conn);
+			rxrpc_put_connection(conn, rxrpc_conn_put_unidle);
 	}
 }
 
@@ -896,7 +895,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 		trace_rxrpc_client(conn, channel, rxrpc_client_to_idle);
 		conn->idle_timestamp = jiffies;
 
-		rxrpc_get_connection(conn);
+		rxrpc_get_connection(conn, rxrpc_conn_get_idle);
 		spin_lock(&rxnet->client_conn_cache_lock);
 		list_move_tail(&conn->cache_link, &rxnet->idle_client_conns);
 		spin_unlock(&rxnet->client_conn_cache_lock);
@@ -938,7 +937,7 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 
 	if (need_drop) {
 		rxrpc_deactivate_bundle(bundle);
-		rxrpc_put_connection(conn);
+		rxrpc_put_connection(conn, rxrpc_conn_put_unbundle);
 	}
 }
 
@@ -983,15 +982,15 @@ static void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 /*
  * Clean up a dead client connections.
  */
-void rxrpc_put_client_conn(struct rxrpc_connection *conn)
+void rxrpc_put_client_conn(struct rxrpc_connection *conn,
+			   enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
 	bool dead;
 	int r;
 
 	dead = __refcount_dec_and_test(&conn->ref, &r);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, r - 1, here);
+	trace_rxrpc_conn(debug_id, r - 1, why);
 	if (dead)
 		rxrpc_kill_client_conn(conn);
 }
@@ -1063,7 +1062,8 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	spin_unlock(&rxnet->client_conn_cache_lock);
 
 	rxrpc_unbundle_conn(conn);
-	rxrpc_put_connection(conn); /* Drop the ->cache_link ref */
+	/* Drop the ->cache_link ref */
+	rxrpc_put_connection(conn, rxrpc_conn_put_discard_idle);
 
 	nr_conns--;
 	goto next;
@@ -1134,7 +1134,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 				  struct rxrpc_connection, cache_link);
 		list_del_init(&conn->cache_link);
 		rxrpc_unbundle_conn(conn);
-		rxrpc_put_connection(conn);
+		rxrpc_put_connection(conn, rxrpc_conn_put_local_dead);
 	}
 
 	_leave(" [culled]");
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 225edaf019f1..817f895c77ca 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -472,14 +472,14 @@ void rxrpc_process_connection(struct work_struct *work)
 	struct rxrpc_connection *conn =
 		container_of(work, struct rxrpc_connection, processor);
 
-	rxrpc_see_connection(conn);
+	rxrpc_see_connection(conn, rxrpc_conn_see_work);
 
 	if (__rxrpc_use_local(conn->local, rxrpc_local_use_conn_work)) {
 		rxrpc_do_process_connection(conn);
 		rxrpc_unuse_local(conn->local, rxrpc_local_unuse_conn_work);
 	}
 
-	rxrpc_put_connection(conn);
+	rxrpc_put_connection(conn, rxrpc_conn_put_work);
 	_leave("");
 	return;
 }
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 554ee5dd3325..bbace8d9953d 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -26,7 +26,7 @@ static void rxrpc_connection_timer(struct timer_list *timer)
 	struct rxrpc_connection *conn =
 		container_of(timer, struct rxrpc_connection, timer);
 
-	rxrpc_queue_conn(conn);
+	rxrpc_queue_conn(conn, rxrpc_conn_queue_timer);
 }
 
 /*
@@ -260,43 +260,42 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
  * Queue a connection's work processor, getting a ref to pass to the work
  * queue.
  */
-bool rxrpc_queue_conn(struct rxrpc_connection *conn)
+bool rxrpc_queue_conn(struct rxrpc_connection *conn, enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int r;
 
 	if (!__refcount_inc_not_zero(&conn->ref, &r))
 		return false;
 	if (rxrpc_queue_work(&conn->processor))
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, r + 1, here);
+		trace_rxrpc_conn(conn->debug_id, why, r + 1);
 	else
-		rxrpc_put_connection(conn);
+		rxrpc_put_connection(conn, rxrpc_conn_put_already_queued);
 	return true;
 }
 
 /*
  * Note the re-emergence of a connection.
  */
-void rxrpc_see_connection(struct rxrpc_connection *conn)
+void rxrpc_see_connection(struct rxrpc_connection *conn,
+			  enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	if (conn) {
-		int n = refcount_read(&conn->ref);
+		int r = refcount_read(&conn->ref);
 
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_seen, n, here);
+		trace_rxrpc_conn(conn->debug_id, r, why);
 	}
 }
 
 /*
  * Get a ref on a connection.
  */
-struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn)
+struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn,
+					      enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int r;
 
 	__refcount_inc(&conn->ref, &r);
-	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r, here);
+	trace_rxrpc_conn(conn->debug_id, r + 1, why);
 	return conn;
 }
 
@@ -304,14 +303,14 @@ struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn)
  * Try to get a ref on a connection.
  */
 struct rxrpc_connection *
-rxrpc_get_connection_maybe(struct rxrpc_connection *conn)
+rxrpc_get_connection_maybe(struct rxrpc_connection *conn,
+			   enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int r;
 
 	if (conn) {
 		if (__refcount_inc_not_zero(&conn->ref, &r))
-			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, r + 1, here);
+			trace_rxrpc_conn(conn->debug_id, r + 1, why);
 		else
 			conn = NULL;
 	}
@@ -331,14 +330,14 @@ static void rxrpc_set_service_reap_timer(struct rxrpc_net *rxnet,
 /*
  * Release a service connection
  */
-void rxrpc_put_service_conn(struct rxrpc_connection *conn)
+void rxrpc_put_service_conn(struct rxrpc_connection *conn,
+			    enum rxrpc_conn_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = conn->debug_id;
 	int r;
 
 	__refcount_dec(&conn->ref, &r);
-	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, r - 1, here);
+	trace_rxrpc_conn(debug_id, r - 1, why);
 	if (r - 1 == 1)
 		rxrpc_set_service_reap_timer(conn->local->rxnet,
 					     jiffies + rxrpc_connection_expiry);
@@ -354,6 +353,9 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	_enter("{%d,u=%d}", conn->debug_id, refcount_read(&conn->ref));
 
+	trace_rxrpc_conn(conn->debug_id, refcount_read(&conn->ref),
+			 rxrpc_conn_free);
+
 	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
 	del_timer_sync(&conn->timer);
@@ -419,7 +421,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		 */
 		if (!refcount_dec_if_one(&conn->ref))
 			continue;
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_reap_service, 0, NULL);
+		rxrpc_see_connection(conn, rxrpc_conn_see_reap_service);
 
 		if (rxrpc_conn_is_client(conn))
 			BUG();
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index a3b91864ef21..bf087213bd4d 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -141,9 +141,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
 		write_unlock(&rxnet->conn_lock);
 
-		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 refcount_read(&conn->ref),
-				 __builtin_return_address(0));
+		rxrpc_see_connection(conn, rxrpc_conn_new_service);
 	}
 
 	return conn;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index cecfd201d832..c8ff7489b412 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1121,7 +1121,7 @@ static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
 	_enter("%p,%p", conn, skb);
 
 	skb_queue_tail(&conn->rx_queue, skb);
-	rxrpc_queue_conn(conn);
+	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
 }
 
 /*


