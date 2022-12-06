Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408116448A7
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiLFQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiLFQC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:02:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA7240B3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyMJU0zPv3CwtJEFI3fq9r//RZkVzS7vkDP3RQzQTFw=;
        b=FPJAN/4VVRchepG7zmkJO0H76O3JM0XehAq2rdApsNLlusQh6mqfDwfUbseI8fzv1lhfXX
        qITcANsNYko7HpapIN75Vkvo8Zo3SvLOiel2xv+Guf5UXrhi/l3QVHvwttHr/LuTv6kze6
        G26fCZI/8Vhxs4J/ULDluxxHxjKJliQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-E3lObi4COeiWzPfraYzPIQ-1; Tue, 06 Dec 2022 11:01:21 -0500
X-MC-Unique: E3lObi4COeiWzPfraYzPIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1631D86EB22;
        Tue,  6 Dec 2022 16:01:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 578C01121315;
        Tue,  6 Dec 2022 16:01:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 19/32] rxrpc: Make the set of connection IDs per
 local endpoint
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:01:17 +0000
Message-ID: <167034247767.1105287.2181920855570975717.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the set of connection IDs per local endpoint so that endpoints don't
cause each other's connections to get dismissed.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c     |    8 --------
 net/rxrpc/ar-internal.h  |    5 +++--
 net/rxrpc/conn_client.c  |   44 +++++++++++++++++++-------------------------
 net/rxrpc/conn_object.c  |    6 +++---
 net/rxrpc/local_object.c |   10 ++++++++++
 5 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index b9dadc89fede..c82af5ebc2b3 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -957,16 +957,9 @@ static const struct net_proto_family rxrpc_family_ops = {
 static int __init af_rxrpc_init(void)
 {
 	int ret = -1;
-	unsigned int tmp;
 
 	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_field(struct sk_buff, cb));
 
-	get_random_bytes(&tmp, sizeof(tmp));
-	tmp &= 0x3fffffff;
-	if (tmp == 0)
-		tmp = 1;
-	idr_set_cursor(&rxrpc_client_conn_ids, tmp);
-
 	ret = -ENOMEM;
 	rxrpc_call_jar = kmem_cache_create(
 		"rxrpc_call_jar", sizeof(struct rxrpc_call), 0,
@@ -1062,7 +1055,6 @@ static void __exit af_rxrpc_exit(void)
 	 * are released.
 	 */
 	rcu_barrier();
-	rxrpc_destroy_client_conn_ids();
 
 	destroy_workqueue(rxrpc_workqueue);
 	rxrpc_exit_security();
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 1e6e11fb3a90..4f4dc3d49c35 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -301,6 +301,8 @@ struct rxrpc_local {
 	int			debug_id;	/* debug ID for printks */
 	bool			dead;
 	bool			service_closed;	/* Service socket closed */
+	struct idr		conn_ids;	/* List of connection IDs */
+	spinlock_t		conn_lock;	/* Lock for client connection pool */
 	struct sockaddr_rxrpc	srx;		/* local address */
 };
 
@@ -888,9 +890,8 @@ static inline bool rxrpc_is_client_call(const struct rxrpc_call *call)
 extern unsigned int rxrpc_reap_client_connections;
 extern unsigned long rxrpc_conn_idle_client_expiry;
 extern unsigned long rxrpc_conn_idle_client_fast_expiry;
-extern struct idr rxrpc_client_conn_ids;
 
-void rxrpc_destroy_client_conn_ids(void);
+void rxrpc_destroy_client_conn_ids(struct rxrpc_local *);
 struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
 void rxrpc_put_bundle(struct rxrpc_bundle *, enum rxrpc_bundle_trace);
 int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 4cfd8845df90..66aca478290e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -34,12 +34,6 @@ __read_mostly unsigned int rxrpc_reap_client_connections = 900;
 __read_mostly unsigned long rxrpc_conn_idle_client_expiry = 2 * 60 * HZ;
 __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 
-/*
- * We use machine-unique IDs for our client connections.
- */
-DEFINE_IDR(rxrpc_client_conn_ids);
-static DEFINE_SPINLOCK(rxrpc_conn_id_lock);
-
 static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 
 /*
@@ -51,65 +45,65 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 					  gfp_t gfp)
 {
-	struct rxrpc_net *rxnet = conn->rxnet;
+	struct rxrpc_local *local = conn->local;
 	int id;
 
 	_enter("");
 
 	idr_preload(gfp);
-	spin_lock(&rxrpc_conn_id_lock);
+	spin_lock(&local->conn_lock);
 
-	id = idr_alloc_cyclic(&rxrpc_client_conn_ids, conn,
+	id = idr_alloc_cyclic(&local->conn_ids, conn,
 			      1, 0x40000000, GFP_NOWAIT);
 	if (id < 0)
 		goto error;
 
-	spin_unlock(&rxrpc_conn_id_lock);
+	spin_unlock(&local->conn_lock);
 	idr_preload_end();
 
-	conn->proto.epoch = rxnet->epoch;
+	conn->proto.epoch = local->rxnet->epoch;
 	conn->proto.cid = id << RXRPC_CIDSHIFT;
 	set_bit(RXRPC_CONN_HAS_IDR, &conn->flags);
 	_leave(" [CID %x]", conn->proto.cid);
 	return 0;
 
 error:
-	spin_unlock(&rxrpc_conn_id_lock);
+	spin_unlock(&local->conn_lock);
 	idr_preload_end();
 	_leave(" = %d", id);
 	return id;
 }
 
 /*
- * Release a connection ID for a client connection from the global pool.
+ * Release a connection ID for a client connection.
  */
-static void rxrpc_put_client_connection_id(struct rxrpc_connection *conn)
+static void rxrpc_put_client_connection_id(struct rxrpc_local *local,
+					   struct rxrpc_connection *conn)
 {
 	if (test_bit(RXRPC_CONN_HAS_IDR, &conn->flags)) {
-		spin_lock(&rxrpc_conn_id_lock);
-		idr_remove(&rxrpc_client_conn_ids,
-			   conn->proto.cid >> RXRPC_CIDSHIFT);
-		spin_unlock(&rxrpc_conn_id_lock);
+		spin_lock(&local->conn_lock);
+		idr_remove(&local->conn_ids, conn->proto.cid >> RXRPC_CIDSHIFT);
+		spin_unlock(&local->conn_lock);
 	}
 }
 
 /*
  * Destroy the client connection ID tree.
  */
-void rxrpc_destroy_client_conn_ids(void)
+void rxrpc_destroy_client_conn_ids(struct rxrpc_local *local)
 {
 	struct rxrpc_connection *conn;
 	int id;
 
-	if (!idr_is_empty(&rxrpc_client_conn_ids)) {
-		idr_for_each_entry(&rxrpc_client_conn_ids, conn, id) {
+	if (!idr_is_empty(&local->conn_ids)) {
+		idr_for_each_entry(&local->conn_ids, conn, id) {
 			pr_err("AF_RXRPC: Leaked client conn %p {%d}\n",
 			       conn, refcount_read(&conn->ref));
 		}
 		BUG();
 	}
 
-	idr_destroy(&rxrpc_client_conn_ids);
+	idr_destroy(&local->conn_ids);
 }
 
 /*
@@ -225,7 +219,7 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	return conn;
 
 error_1:
-	rxrpc_put_client_connection_id(conn);
+	rxrpc_put_client_connection_id(bundle->local, conn);
 error_0:
 	kfree(conn);
 	_leave(" = %d", ret);
@@ -257,7 +251,7 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	 * times the maximum number of client conns away from the current
 	 * allocation point to try and keep the IDs concentrated.
 	 */
-	id_cursor = idr_get_cursor(&rxrpc_client_conn_ids);
+	id_cursor = idr_get_cursor(&conn->local->conn_ids);
 	id = conn->proto.cid >> RXRPC_CIDSHIFT;
 	distance = id - id_cursor;
 	if (distance < 0)
@@ -982,7 +976,7 @@ void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 	trace_rxrpc_client(conn, -1, rxrpc_client_cleanup);
 	atomic_dec(&rxnet->nr_client_conns);
 
-	rxrpc_put_client_connection_id(conn);
+	rxrpc_put_client_connection_id(local, conn);
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index b3cb85e0ed70..52fad0744239 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -100,10 +100,10 @@ struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_local *lo
 
 	_enter(",%x", sp->hdr.cid & RXRPC_CIDMASK);
 
-	/* Look up client connections by connection ID alone as their IDs are
-	 * unique for this machine.
+	/* Look up client connections by connection ID alone as their
+	 * IDs are unique for this machine.
 	 */
-	conn = idr_find(&rxrpc_client_conn_ids, sp->hdr.cid >> RXRPC_CIDSHIFT);
+	conn = idr_find(&local->conn_ids, sp->hdr.cid >> RXRPC_CIDSHIFT);
 	if (!conn || refcount_read(&conn->ref) == 0) {
 		_debug("no conn");
 		goto not_found;
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 3843418ea90f..57697adf52c6 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -89,6 +89,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 					     const struct sockaddr_rxrpc *srx)
 {
 	struct rxrpc_local *local;
+	u32 tmp;
 
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
@@ -110,6 +111,14 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
 		memcpy(&local->srx, srx, sizeof(*srx));
 		local->srx.srx_service = 0;
+		idr_init(&local->conn_ids);
+		get_random_bytes(&tmp, sizeof(tmp));
+		tmp &= 0x3fffffff;
+		if (tmp == 0)
+			tmp = 1;
+		idr_set_cursor(&local->conn_ids, tmp);
+		spin_lock_init(&local->conn_lock);
+
 		trace_rxrpc_local(local->debug_id, rxrpc_local_new, 1, 1);
 	}
 
@@ -411,6 +420,7 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	rxrpc_purge_queue(&local->rx_delay_queue);
 #endif
 	rxrpc_purge_queue(&local->rx_queue);
+	rxrpc_destroy_client_conn_ids(local);
 }
 
 /*


