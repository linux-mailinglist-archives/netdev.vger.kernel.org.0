Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0607863DB3C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiK3Q61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiK3Q5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1C291C0E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRrmPOQXGyQvrE192VqLxp1giKxs1t8Q4mImd844U28=;
        b=gNNs5yo60CT/CoAg40NvmVIZsg6Q346OQXmu4rO5fHokCvfdbUfBBXDm5KYwWLzAXVMhal
        F+igDNyAfnTP50ygR8g+RvEjQoEcYRz2QAxSEIGqH2RALvUMVlshftOGZywCwrtv+U6WRM
        8FwbbzloGjnTogfTdiziKwJg2Mh10Rg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-z94zSuQCMJiBNsyLzHrzdQ-1; Wed, 30 Nov 2022 11:56:14 -0500
X-MC-Unique: z94zSuQCMJiBNsyLzHrzdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F9D7882822;
        Wed, 30 Nov 2022 16:56:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 602237AE5;
        Wed, 30 Nov 2022 16:56:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/35] rxrpc: Trace rxrpc_bundle refcount
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:56:10 +0000
Message-ID: <166982737062.621383.16260737246000488854.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint for the rxrpc_bundle refcounting.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   34 ++++++++++++++++++++++++++++++++++
 net/rxrpc/ar-internal.h      |    4 ++--
 net/rxrpc/conn_client.c      |   27 ++++++++++++++++-----------
 net/rxrpc/conn_object.c      |    2 +-
 net/rxrpc/conn_service.c     |    3 ++-
 5 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 3f6de4294148..6f5be7ac7f6b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -81,6 +81,15 @@
 	EM(rxrpc_peer_put_input_error,		"PUT inpt-err") \
 	E_(rxrpc_peer_put_keepalive,		"PUT keepaliv")
 
+#define rxrpc_bundle_traces \
+	EM(rxrpc_bundle_free,			"FREE        ") \
+	EM(rxrpc_bundle_get_client_call,	"GET clt-call") \
+	EM(rxrpc_bundle_get_client_conn,	"GET clt-conn") \
+	EM(rxrpc_bundle_get_service_conn,	"GET svc-conn") \
+	EM(rxrpc_bundle_put_conn,		"PUT conn    ") \
+	EM(rxrpc_bundle_put_discard,		"PUT discard ") \
+	E_(rxrpc_bundle_new,			"NEW         ")
+
 #define rxrpc_conn_traces \
 	EM(rxrpc_conn_free,			"FREE        ") \
 	EM(rxrpc_conn_get_activate_call,	"GET act-call") \
@@ -361,6 +370,7 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
+enum rxrpc_bundle_trace		{ rxrpc_bundle_traces } __mode(byte);
 enum rxrpc_call_trace		{ rxrpc_call_traces } __mode(byte);
 enum rxrpc_client_trace		{ rxrpc_client_traces } __mode(byte);
 enum rxrpc_congest_change	{ rxrpc_congest_changes } __mode(byte);
@@ -390,6 +400,7 @@ enum rxrpc_txqueue_trace	{ rxrpc_txqueue_traces } __mode(byte);
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
+rxrpc_bundle_traces;
 rxrpc_call_traces;
 rxrpc_client_traces;
 rxrpc_congest_changes;
@@ -467,6 +478,29 @@ TRACE_EVENT(rxrpc_peer,
 		      __entry->ref)
 	    );
 
+TRACE_EVENT(rxrpc_bundle,
+	    TP_PROTO(unsigned int bundle_debug_id, int ref, enum rxrpc_bundle_trace why),
+
+	    TP_ARGS(bundle_debug_id, ref, why),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	bundle		)
+		    __field(int,		ref		)
+		    __field(int,		why		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->bundle = bundle_debug_id;
+		    __entry->ref = ref;
+		    __entry->why = why;
+			   ),
+
+	    TP_printk("CB=%08x %s r=%d",
+		      __entry->bundle,
+		      __print_symbolic(__entry->why, rxrpc_bundle_traces),
+		      __entry->ref)
+	    );
+
 TRACE_EVENT(rxrpc_conn,
 	    TP_PROTO(unsigned int conn_debug_id, int ref, enum rxrpc_conn_trace why),
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 82eb09b961a0..c588c0e81f63 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -875,8 +875,8 @@ extern unsigned long rxrpc_conn_idle_client_fast_expiry;
 extern struct idr rxrpc_client_conn_ids;
 
 void rxrpc_destroy_client_conn_ids(void);
-struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *);
-void rxrpc_put_bundle(struct rxrpc_bundle *);
+struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
+void rxrpc_put_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
 int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
 		       struct rxrpc_conn_parameters *, struct sockaddr_rxrpc *,
 		       gfp_t);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 4352e777aa2a..34ff6fa85c32 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -133,31 +133,36 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 		atomic_set(&bundle->active, 1);
 		spin_lock_init(&bundle->channel_lock);
 		INIT_LIST_HEAD(&bundle->waiting_calls);
+		trace_rxrpc_bundle(bundle->debug_id, 1, rxrpc_bundle_new);
 	}
 	return bundle;
 }
 
-struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
+struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle,
+				      enum rxrpc_bundle_trace why)
 {
-	refcount_inc(&bundle->ref);
+	int r;
+
+	__refcount_inc(&bundle->ref, &r);
+	trace_rxrpc_bundle(bundle->debug_id, r + 1, why);
 	return bundle;
 }
 
 static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 {
+	trace_rxrpc_bundle(bundle->debug_id, 1, rxrpc_bundle_free);
 	rxrpc_put_peer(bundle->peer, rxrpc_peer_put_bundle);
 	kfree(bundle);
 }
 
-void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
+void rxrpc_put_bundle(struct rxrpc_bundle *bundle, enum rxrpc_bundle_trace why)
 {
-	unsigned int d = bundle->debug_id;
+	unsigned int id = bundle->debug_id;
 	bool dead;
 	int r;
 
 	dead = __refcount_dec_and_test(&bundle->ref, &r);
-
-	_debug("PUT B=%x %d", d, r - 1);
+	trace_rxrpc_bundle(id, r - 1, why);
 	if (dead)
 		rxrpc_free_bundle(bundle);
 }
@@ -206,7 +211,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
 	write_unlock(&rxnet->conn_lock);
 
-	rxrpc_get_bundle(bundle);
+	rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_conn);
 	rxrpc_get_peer(conn->peer, rxrpc_peer_get_client_conn);
 	rxrpc_get_local(conn->local, rxrpc_local_get_client_conn);
 	key_get(conn->key);
@@ -342,7 +347,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	candidate->debug_id = atomic_inc_return(&rxrpc_bundle_id);
 	rb_link_node(&candidate->local_node, parent, pp);
 	rb_insert_color(&candidate->local_node, &local->client_bundles);
-	rxrpc_get_bundle(candidate);
+	rxrpc_get_bundle(candidate, rxrpc_bundle_get_client_call);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = %u [new]", candidate->debug_id);
 	return candidate;
@@ -350,7 +355,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 found_bundle_free:
 	rxrpc_free_bundle(candidate);
 found_bundle:
-	rxrpc_get_bundle(bundle);
+	rxrpc_get_bundle(bundle, rxrpc_bundle_get_client_call);
 	atomic_inc(&bundle->active);
 	spin_unlock(&local->client_bundles_lock);
 	_leave(" = %u [found]", bundle->debug_id);
@@ -740,7 +745,7 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 
 out_put_bundle:
 	rxrpc_deactivate_bundle(bundle);
-	rxrpc_put_bundle(bundle);
+	rxrpc_put_bundle(bundle, rxrpc_bundle_get_client_call);
 out:
 	_leave(" = %d", ret);
 	return ret;
@@ -958,7 +963,7 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
 
 		spin_unlock(&local->client_bundles_lock);
 		if (need_put)
-			rxrpc_put_bundle(bundle);
+			rxrpc_put_bundle(bundle, rxrpc_bundle_put_discard);
 	}
 }
 
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index bbace8d9953d..f7c271a740ed 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -363,7 +363,7 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	conn->security->clear(conn);
 	key_put(conn->key);
-	rxrpc_put_bundle(conn->bundle);
+	rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
 	rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
 
 	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index bf087213bd4d..2c44d67b43dc 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -133,7 +133,8 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
 		refcount_set(&conn->ref, 2);
-		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle);
+		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle,
+						rxrpc_bundle_get_service_conn);
 
 		atomic_inc(&rxnet->nr_conns);
 		write_lock(&rxnet->conn_lock);


