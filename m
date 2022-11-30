Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF763DB32
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiK3Q5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiK3Q4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:56:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F2E8DFD7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRsrjTWsdHtPIVIzz7RIyloR2kSQnVsq53ws+OkgYXY=;
        b=N1ZHGvVutWtOjbqHfGnwMWTZLSygAGIe/zBm74rZbTGTXirJp0aK6b8kL4o90rbHOOU0eG
        jd2fGnxaJg7JdKTcHZrbKuoFQFauWwpUzDeybRgQRdD+Y6GcYUHoY5bs+d96akqrdXTHY1
        Y4R2en64jVKiSKm3XnMeJb625isLjYU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-IWMc6HehN2OtJHwJyhodmw-1; Wed, 30 Nov 2022 11:55:39 -0500
X-MC-Unique: IWMc6HehN2OtJHwJyhodmw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 201641C0CE62;
        Wed, 30 Nov 2022 16:55:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46283492B04;
        Wed, 30 Nov 2022 16:55:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 09/35] rxrpc: trace: Don't use
 __builtin_return_address for rxrpc_local tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:55:35 +0000
Message-ID: <166982733564.621383.13364100665781176323.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
than __builtin_return_address() for the rxrpc_local tracepoint

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   49 +++++++++++++++++++-------
 net/rxrpc/af_rxrpc.c         |    8 ++--
 net/rxrpc/ar-internal.h      |   41 +++++++++++++++++-----
 net/rxrpc/call_accept.c      |    4 +-
 net/rxrpc/call_event.c       |    2 +
 net/rxrpc/conn_client.c      |    2 +
 net/rxrpc/conn_event.c       |    4 +-
 net/rxrpc/conn_object.c      |    2 +
 net/rxrpc/input.c            |    4 +-
 net/rxrpc/local_object.c     |   78 +++++++++++++++++++++++-------------------
 net/rxrpc/output.c           |    3 +-
 net/rxrpc/peer_event.c       |    4 +-
 net/rxrpc/peer_object.c      |    4 +-
 13 files changed, 129 insertions(+), 76 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 2b77f9a75bf7..015569845b1d 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -32,12 +32,35 @@
 	E_(rxrpc_skb_unshared_nomem,		"US0")
 
 #define rxrpc_local_traces \
-	EM(rxrpc_local_got,			"GOT") \
-	EM(rxrpc_local_new,			"NEW") \
-	EM(rxrpc_local_processing,		"PRO") \
-	EM(rxrpc_local_put,			"PUT") \
-	EM(rxrpc_local_queued,			"QUE") \
-	E_(rxrpc_local_tx_ack,			"TAK")
+	EM(rxrpc_local_free,			"FREE        ") \
+	EM(rxrpc_local_get_client_conn,		"GET conn-cln") \
+	EM(rxrpc_local_get_for_use,		"GET for-use ") \
+	EM(rxrpc_local_get_peer,		"GET peer    ") \
+	EM(rxrpc_local_get_prealloc_conn,	"GET conn-pre") \
+	EM(rxrpc_local_get_queue,		"GET queue   ") \
+	EM(rxrpc_local_new,			"NEW         ") \
+	EM(rxrpc_local_processing,		"PROCESSING  ") \
+	EM(rxrpc_local_put_already_queued,	"PUT alreadyq") \
+	EM(rxrpc_local_put_bind,		"PUT bind    ") \
+	EM(rxrpc_local_put_for_use,		"PUT for-use ") \
+	EM(rxrpc_local_put_kill_conn,		"PUT conn-kil") \
+	EM(rxrpc_local_put_peer,		"PUT peer    ") \
+	EM(rxrpc_local_put_prealloc_conn,	"PUT conn-pre") \
+	EM(rxrpc_local_put_release_sock,	"PUT rel-sock") \
+	EM(rxrpc_local_put_queue,		"PUT queue   ") \
+	EM(rxrpc_local_queued,			"QUEUED      ") \
+	EM(rxrpc_local_see_tx_ack,		"SEE tx-ack  ") \
+	EM(rxrpc_local_stop,			"STOP        ") \
+	EM(rxrpc_local_stopped,			"STOPPED     ") \
+	EM(rxrpc_local_unuse_bind,		"UNU bind    ") \
+	EM(rxrpc_local_unuse_conn_work,		"UNU conn-wrk") \
+	EM(rxrpc_local_unuse_peer_keepalive,	"UNU peer-kpa") \
+	EM(rxrpc_local_unuse_release_sock,	"UNU rel-sock") \
+	EM(rxrpc_local_unuse_work,		"UNU work    ") \
+	EM(rxrpc_local_use_conn_work,		"USE conn-wrk") \
+	EM(rxrpc_local_use_lookup,		"USE lookup  ") \
+	EM(rxrpc_local_use_peer_keepalive,	"USE peer-kpa") \
+	E_(rxrpc_local_use_work,		"USE work    ")
 
 #define rxrpc_peer_traces \
 	EM(rxrpc_peer_got,			"GOT") \
@@ -345,29 +368,29 @@ rxrpc_txqueue_traces;
 
 TRACE_EVENT(rxrpc_local,
 	    TP_PROTO(unsigned int local_debug_id, enum rxrpc_local_trace op,
-		     int usage, const void *where),
+		     int ref, int usage),
 
-	    TP_ARGS(local_debug_id, op, usage, where),
+	    TP_ARGS(local_debug_id, op, ref, usage),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	local		)
 		    __field(int,		op		)
+		    __field(int,		ref		)
 		    __field(int,		usage		)
-		    __field(const void *,	where		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->local = local_debug_id;
 		    __entry->op = op;
+		    __entry->ref = ref;
 		    __entry->usage = usage;
-		    __entry->where = where;
 			   ),
 
-	    TP_printk("L=%08x %s u=%d sp=%pSR",
+	    TP_printk("L=%08x %s r=%d u=%d",
 		      __entry->local,
 		      __print_symbolic(__entry->op, rxrpc_local_traces),
-		      __entry->usage,
-		      __entry->where)
+		      __entry->ref,
+		      __entry->usage)
 	    );
 
 TRACE_EVENT(rxrpc_peer,
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index aacdd96a9886..989ebca899f3 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -194,8 +194,8 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 
 service_in_use:
 	write_unlock(&local->services_lock);
-	rxrpc_unuse_local(local);
-	rxrpc_put_local(local);
+	rxrpc_unuse_local(local, rxrpc_local_unuse_bind);
+	rxrpc_put_local(local, rxrpc_local_put_bind);
 	ret = -EADDRINUSE;
 error_unlock:
 	release_sock(&rx->sk);
@@ -888,8 +888,8 @@ static int rxrpc_release_sock(struct sock *sk)
 	flush_workqueue(rxrpc_workqueue);
 	rxrpc_purge_queue(&sk->sk_receive_queue);
 
-	rxrpc_unuse_local(rx->local);
-	rxrpc_put_local(rx->local);
+	rxrpc_unuse_local(rx->local, rxrpc_local_unuse_release_sock);
+	rxrpc_put_local(rx->local, rxrpc_local_put_release_sock);
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 7c48b0163032..dde9ce21ef48 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -979,22 +979,45 @@ extern void rxrpc_process_local_events(struct rxrpc_local *);
  * local_object.c
  */
 struct rxrpc_local *rxrpc_lookup_local(struct net *, const struct sockaddr_rxrpc *);
-struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *);
-struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *);
-void rxrpc_put_local(struct rxrpc_local *);
-struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *);
-void rxrpc_unuse_local(struct rxrpc_local *);
+struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *, enum rxrpc_local_trace);
+struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *, enum rxrpc_local_trace);
+void rxrpc_put_local(struct rxrpc_local *, enum rxrpc_local_trace);
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *, enum rxrpc_local_trace);
+void rxrpc_unuse_local(struct rxrpc_local *, enum rxrpc_local_trace);
 void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
-static inline bool __rxrpc_unuse_local(struct rxrpc_local *local)
+static inline bool __rxrpc_unuse_local(struct rxrpc_local *local,
+				       enum rxrpc_local_trace why)
 {
-	return atomic_dec_return(&local->active_users) == 0;
+	unsigned int debug_id = local->debug_id;
+	int r, u;
+
+	r = refcount_read(&local->ref);
+	u = atomic_dec_return(&local->active_users);
+	trace_rxrpc_local(debug_id, why, r, u);
+	return u == 0;
+}
+
+static inline bool __rxrpc_use_local(struct rxrpc_local *local,
+				     enum rxrpc_local_trace why)
+{
+	int r, u;
+
+	r = refcount_read(&local->ref);
+	u = atomic_fetch_add_unless(&local->active_users, 1, 0);
+	trace_rxrpc_local(local->debug_id, why, r, u);
+	return u != 0;
 }
 
-static inline bool __rxrpc_use_local(struct rxrpc_local *local)
+static inline void rxrpc_see_local(struct rxrpc_local *local,
+				   enum rxrpc_local_trace why)
 {
-	return atomic_fetch_add_unless(&local->active_users, 1, 0) != 0;
+	int r, u;
+
+	r = refcount_read(&local->ref);
+	u = atomic_read(&local->active_users);
+	trace_rxrpc_local(local->debug_id, why, r, u);
 }
 
 /*
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 4888959e4727..1b12d4e28373 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -197,7 +197,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail = b->peer_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_peer *peer = b->peer_backlog[tail];
-		rxrpc_put_local(peer->local);
+		rxrpc_put_local(peer->local, rxrpc_local_put_prealloc_conn);
 		kfree(peer);
 		tail = (tail + 1) & (size - 1);
 	}
@@ -305,7 +305,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		b->conn_backlog[conn_tail] = NULL;
 		smp_store_release(&b->conn_backlog_tail,
 				  (conn_tail + 1) & (RXRPC_BACKLOG_MAX - 1));
-		conn->local = rxrpc_get_local(local);
+		conn->local = rxrpc_get_local(local, rxrpc_local_get_prealloc_conn);
 		conn->peer = peer;
 		rxrpc_see_connection(conn);
 		rxrpc_new_incoming_connection(rx, conn, sec, skb);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index b17ed37434bd..591af8e2e3d0 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -114,7 +114,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	if (in_task()) {
 		rxrpc_transmit_ack_packets(call->peer->local);
 	} else {
-		rxrpc_get_local(local);
+		rxrpc_get_local(local, rxrpc_local_get_queue);
 		rxrpc_queue_local(local);
 	}
 }
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 71404b33623f..9a69b4c1b182 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -208,7 +208,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 
 	rxrpc_get_bundle(bundle);
 	rxrpc_get_peer(conn->peer);
-	rxrpc_get_local(conn->local);
+	rxrpc_get_local(conn->local, rxrpc_local_get_client_conn);
 	key_get(conn->key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index f890a30c4df6..225edaf019f1 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -474,9 +474,9 @@ void rxrpc_process_connection(struct work_struct *work)
 
 	rxrpc_see_connection(conn);
 
-	if (__rxrpc_use_local(conn->local)) {
+	if (__rxrpc_use_local(conn->local, rxrpc_local_use_conn_work)) {
 		rxrpc_do_process_connection(conn);
-		rxrpc_unuse_local(conn->local);
+		rxrpc_unuse_local(conn->local, rxrpc_local_unuse_conn_work);
 	}
 
 	rxrpc_put_connection(conn);
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index ad6e5ee1f069..725359afeac0 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -366,7 +366,7 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
 		wake_up_var(&conn->local->rxnet->nr_conns);
-	rxrpc_put_local(conn->local);
+	rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
 
 	kfree(conn);
 	_leave("");
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 42c8257158f7..cecfd201d832 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1133,7 +1133,7 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 {
 	_enter("%p,%p", local, skb);
 
-	if (rxrpc_get_local_maybe(local)) {
+	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
 		skb_queue_tail(&local->event_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
@@ -1146,7 +1146,7 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
  */
 static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	if (rxrpc_get_local_maybe(local)) {
+	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 11080c335d42..1617ce651b9b 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -110,7 +110,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
 		memcpy(&local->srx, srx, sizeof(*srx));
 		local->srx.srx_service = 0;
-		trace_rxrpc_local(local->debug_id, rxrpc_local_new, 1, NULL);
+		trace_rxrpc_local(local->debug_id, rxrpc_local_new, 1, 1);
 	}
 
 	_leave(" = %p", local);
@@ -228,7 +228,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		 * we're attempting to use a local address that the dying
 		 * object is still using.
 		 */
-		if (!rxrpc_use_local(local))
+		if (!rxrpc_use_local(local, rxrpc_local_use_lookup))
 			break;
 
 		goto found;
@@ -272,32 +272,32 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 /*
  * Get a ref on a local endpoint.
  */
-struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
+struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local,
+				    enum rxrpc_local_trace why)
 {
-	const void *here = __builtin_return_address(0);
-	int r;
+	int r, u;
 
+	u = atomic_read(&local->active_users);
 	__refcount_inc(&local->ref, &r);
-	trace_rxrpc_local(local->debug_id, rxrpc_local_got, r + 1, here);
+	trace_rxrpc_local(local->debug_id, why, r + 1, u);
 	return local;
 }
 
 /*
  * Get a ref on a local endpoint unless its usage has already reached 0.
  */
-struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
+struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local,
+					  enum rxrpc_local_trace why)
 {
-	const void *here = __builtin_return_address(0);
-	int r;
+	int r, u;
 
-	if (local) {
-		if (__refcount_inc_not_zero(&local->ref, &r))
-			trace_rxrpc_local(local->debug_id, rxrpc_local_got,
-					  r + 1, here);
-		else
-			local = NULL;
+	if (local && __refcount_inc_not_zero(&local->ref, &r)) {
+		u = atomic_read(&local->active_users);
+		trace_rxrpc_local(local->debug_id, why, r + 1, u);
+		return local;
 	}
-	return local;
+
+	return NULL;
 }
 
 /*
@@ -305,31 +305,31 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
  */
 void rxrpc_queue_local(struct rxrpc_local *local)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = local->debug_id;
 	int r = refcount_read(&local->ref);
+	int u = atomic_read(&local->active_users);
 
 	if (rxrpc_queue_work(&local->processor))
-		trace_rxrpc_local(debug_id, rxrpc_local_queued, r + 1, here);
+		trace_rxrpc_local(debug_id, rxrpc_local_queued, r, u);
 	else
-		rxrpc_put_local(local);
+		rxrpc_put_local(local, rxrpc_local_put_already_queued);
 }
 
 /*
  * Drop a ref on a local endpoint.
  */
-void rxrpc_put_local(struct rxrpc_local *local)
+void rxrpc_put_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id;
 	bool dead;
-	int r;
+	int r, u;
 
 	if (local) {
 		debug_id = local->debug_id;
 
+		u = atomic_read(&local->active_users);
 		dead = __refcount_dec_and_test(&local->ref, &r);
-		trace_rxrpc_local(debug_id, rxrpc_local_put, r, here);
+		trace_rxrpc_local(debug_id, why, r, u);
 
 		if (dead)
 			call_rcu(&local->rcu, rxrpc_local_rcu);
@@ -339,14 +339,15 @@ void rxrpc_put_local(struct rxrpc_local *local)
 /*
  * Start using a local endpoint.
  */
-struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local,
+				    enum rxrpc_local_trace why)
 {
-	local = rxrpc_get_local_maybe(local);
+	local = rxrpc_get_local_maybe(local, rxrpc_local_get_for_use);
 	if (!local)
 		return NULL;
 
-	if (!__rxrpc_use_local(local)) {
-		rxrpc_put_local(local);
+	if (!__rxrpc_use_local(local, why)) {
+		rxrpc_put_local(local, rxrpc_local_put_for_use);
 		return NULL;
 	}
 
@@ -357,11 +358,18 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
  * Cease using a local endpoint.  Once the number of active users reaches 0, we
  * start the closure of the transport in the work processor.
  */
-void rxrpc_unuse_local(struct rxrpc_local *local)
+void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
+	unsigned int debug_id;
+	int r, u;
+
 	if (local) {
-		if (__rxrpc_unuse_local(local)) {
-			rxrpc_get_local(local);
+		debug_id = local->debug_id;
+		r = refcount_read(&local->ref);
+		u = atomic_dec_return(&local->active_users);
+		trace_rxrpc_local(debug_id, why, r, u);
+		if (u == 0) {
+			rxrpc_get_local(local, rxrpc_local_get_queue);
 			rxrpc_queue_local(local);
 		}
 	}
@@ -418,12 +426,11 @@ static void rxrpc_local_processor(struct work_struct *work)
 	if (local->dead)
 		return;
 
-	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
-			  refcount_read(&local->ref), NULL);
+	rxrpc_see_local(local, rxrpc_local_processing);
 
 	do {
 		again = false;
-		if (!__rxrpc_use_local(local)) {
+		if (!__rxrpc_use_local(local, rxrpc_local_use_work)) {
 			rxrpc_local_destroyer(local);
 			break;
 		}
@@ -443,10 +450,10 @@ static void rxrpc_local_processor(struct work_struct *work)
 			again = true;
 		}
 
-		__rxrpc_unuse_local(local);
+		__rxrpc_unuse_local(local, rxrpc_local_unuse_work);
 	} while (again);
 
-	rxrpc_put_local(local);
+	rxrpc_put_local(local, rxrpc_local_put_queue);
 }
 
 /*
@@ -460,6 +467,7 @@ static void rxrpc_local_rcu(struct rcu_head *rcu)
 
 	ASSERT(!work_pending(&local->processor));
 
+	rxrpc_see_local(local, rxrpc_local_free);
 	kfree(local);
 	_leave("");
 }
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index b5d8eac8c49c..2762b7ada9ae 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -288,8 +288,7 @@ void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
 	LIST_HEAD(queue);
 	int ret;
 
-	trace_rxrpc_local(local->debug_id, rxrpc_local_tx_ack,
-			  refcount_read(&local->ref), NULL);
+	rxrpc_see_local(local, rxrpc_local_see_tx_ack);
 
 	if (list_empty(&local->ack_tx_queue))
 		return;
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index ad4d1769e02b..3f8d104ecaa7 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -266,7 +266,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 		if (!rxrpc_get_peer_maybe(peer))
 			continue;
 
-		if (__rxrpc_use_local(peer->local)) {
+		if (__rxrpc_use_local(peer->local, rxrpc_local_use_peer_keepalive)) {
 			spin_unlock_bh(&rxnet->peer_hash_lock);
 
 			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
@@ -289,7 +289,7 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 			spin_lock_bh(&rxnet->peer_hash_lock);
 			list_add_tail(&peer->keepalive_link,
 				      &rxnet->peer_keepalive[slot & mask]);
-			rxrpc_unuse_local(peer->local);
+			rxrpc_unuse_local(peer->local, rxrpc_local_unuse_peer_keepalive);
 		}
 		rxrpc_put_peer_locked(peer);
 	}
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index b3c3c1c344fc..bcef897560e7 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -215,7 +215,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
 		refcount_set(&peer->ref, 1);
-		peer->local = rxrpc_get_local(local);
+		peer->local = rxrpc_get_local(local, rxrpc_local_get_peer);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
 		seqlock_init(&peer->service_conn_lock);
@@ -294,7 +294,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 
 static void rxrpc_free_peer(struct rxrpc_peer *peer)
 {
-	rxrpc_put_local(peer->local);
+	rxrpc_put_local(peer->local, rxrpc_local_put_peer);
 	kfree_rcu(peer, rcu);
 }
 


