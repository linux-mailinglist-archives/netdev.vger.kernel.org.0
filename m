Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACEB96C5E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbfHTWdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36994 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oUsTSvSDmYgcEQnLx8tgcQnz/Pw556FSq7JuLbGhR9g=; b=ENwi3zZzWHiXsxCp0u57JCSROP
        k0SMrK2zWnzUosHwYjYggOQFJy+gIv6eYwTpvXXeDJgOMy+V6oaYO5mQX28HfH+MQvwRbscVdAGtn
        LMNiDWJJMns78CFGuyUzUFzXs4SbOmeDEbA11uwr8nLmn+f7dvOBhQOlp2L6ZoF+4a351Zg3HhZxL
        2vmtLEfu+DiEb4b7IPBy1UJQEvj145RH91fweVODWGyFhGG2xCh+4xRJf6aIYe00FLWVmA5R3b1DH
        UHeA/DNI5S/DbkCtS70plH3NE8dMnxKf4Sa1FCPGzJVLfRpuPbUX9ZIAT9hurFszkHUsRLRhvVd3g
        dTc0m1hQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rE-JK; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 18/38] rxrpc: Convert to XArray
Date:   Tue, 20 Aug 2019 15:32:39 -0700
Message-Id: <20190820223259.22348-19-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The XArray requires a separate cursor, but embeds the lock, so it's
a minor saving.  Also, there's no need to preload.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/rxrpc/af_rxrpc.c    |  2 +-
 net/rxrpc/ar-internal.h |  3 ++-
 net/rxrpc/conn_client.c | 49 +++++++++++++++--------------------------
 net/rxrpc/conn_object.c |  2 +-
 4 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index d09eaf153544..16e289bbc825 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -981,7 +981,7 @@ static int __init af_rxrpc_init(void)
 	tmp &= 0x3fffffff;
 	if (tmp == 0)
 		tmp = 1;
-	idr_set_cursor(&rxrpc_client_conn_ids, tmp);
+	rxrpc_client_conn_next = tmp;
 
 	ret = -ENOMEM;
 	rxrpc_call_jar = kmem_cache_create(
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 63b26baa108a..7721448aa7a4 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -898,7 +898,8 @@ extern unsigned int rxrpc_max_client_connections;
 extern unsigned int rxrpc_reap_client_connections;
 extern unsigned long rxrpc_conn_idle_client_expiry;
 extern unsigned long rxrpc_conn_idle_client_fast_expiry;
-extern struct idr rxrpc_client_conn_ids;
+extern struct xarray rxrpc_client_conn_ids;
+extern u32 rxrpc_client_conn_next;
 
 void rxrpc_destroy_client_conn_ids(void);
 int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index aea82f909c60..d967de7a5eb9 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -72,7 +72,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/slab.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/timer.h>
 #include <linux/sched/signal.h>
 
@@ -86,14 +86,14 @@ __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 /*
  * We use machine-unique IDs for our client connections.
  */
-DEFINE_IDR(rxrpc_client_conn_ids);
-static DEFINE_SPINLOCK(rxrpc_conn_id_lock);
+DEFINE_XARRAY_ALLOC1(rxrpc_client_conn_ids);
+u32 rxrpc_client_conn_next;
 
 static void rxrpc_cull_active_client_conns(struct rxrpc_net *);
 
 /*
  * Get a connection ID and epoch for a client connection from the global pool.
- * The connection struct pointer is then recorded in the idr radix tree.  The
+ * The connection struct pointer is then recorded in the XArray.  The
  * epoch doesn't change until the client is rebooted (or, at least, unless the
  * module is unloaded).
  */
@@ -101,21 +101,15 @@ static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 					  gfp_t gfp)
 {
 	struct rxrpc_net *rxnet = conn->params.local->rxnet;
-	int id;
+	int err, id;
 
 	_enter("");
 
-	idr_preload(gfp);
-	spin_lock(&rxrpc_conn_id_lock);
-
-	id = idr_alloc_cyclic(&rxrpc_client_conn_ids, conn,
-			      1, 0x40000000, GFP_NOWAIT);
-	if (id < 0)
+	err = xa_alloc_cyclic(&rxrpc_client_conn_ids, &id, conn,
+			XA_LIMIT(1, 0x40000000), &rxrpc_client_conn_next, gfp);
+	if (err < 0)
 		goto error;
 
-	spin_unlock(&rxrpc_conn_id_lock);
-	idr_preload_end();
-
 	conn->proto.epoch = rxnet->epoch;
 	conn->proto.cid = id << RXRPC_CIDSHIFT;
 	set_bit(RXRPC_CONN_HAS_IDR, &conn->flags);
@@ -123,10 +117,8 @@ static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 	return 0;
 
 error:
-	spin_unlock(&rxrpc_conn_id_lock);
-	idr_preload_end();
-	_leave(" = %d", id);
-	return id;
+	_leave(" = %d", err);
+	return err;
 }
 
 /*
@@ -135,30 +127,26 @@ static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 static void rxrpc_put_client_connection_id(struct rxrpc_connection *conn)
 {
 	if (test_bit(RXRPC_CONN_HAS_IDR, &conn->flags)) {
-		spin_lock(&rxrpc_conn_id_lock);
-		idr_remove(&rxrpc_client_conn_ids,
+		xa_erase(&rxrpc_client_conn_ids,
 			   conn->proto.cid >> RXRPC_CIDSHIFT);
-		spin_unlock(&rxrpc_conn_id_lock);
 	}
 }
 
 /*
- * Destroy the client connection ID tree.
+ * There should be no outstanding client connections.
  */
 void rxrpc_destroy_client_conn_ids(void)
 {
-	struct rxrpc_connection *conn;
-	int id;
+	if (!xa_empty(&rxrpc_client_conn_ids)) {
+		struct rxrpc_connection *conn;
+		unsigned long id;
 
-	if (!idr_is_empty(&rxrpc_client_conn_ids)) {
-		idr_for_each_entry(&rxrpc_client_conn_ids, conn, id) {
+		xa_for_each(&rxrpc_client_conn_ids, id, conn) {
 			pr_err("AF_RXRPC: Leaked client conn %p {%d}\n",
 			       conn, atomic_read(&conn->usage));
 		}
 		BUG();
 	}
-
-	idr_destroy(&rxrpc_client_conn_ids);
 }
 
 /*
@@ -234,7 +222,7 @@ rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
 static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 {
 	struct rxrpc_net *rxnet = conn->params.local->rxnet;
-	int id_cursor, id, distance, limit;
+	int id, distance, limit;
 
 	if (test_bit(RXRPC_CONN_DONT_REUSE, &conn->flags))
 		goto dont_reuse;
@@ -248,9 +236,8 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	 * times the maximum number of client conns away from the current
 	 * allocation point to try and keep the IDs concentrated.
 	 */
-	id_cursor = idr_get_cursor(&rxrpc_client_conn_ids);
 	id = conn->proto.cid >> RXRPC_CIDSHIFT;
-	distance = id - id_cursor;
+	distance = id - rxrpc_client_conn_next;
 	if (distance < 0)
 		distance = -distance;
 	limit = max(rxrpc_max_client_connections * 4, 1024U);
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 434ef392212b..31eef9c2a9ac 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -115,7 +115,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		/* Look up client connections by connection ID alone as their
 		 * IDs are unique for this machine.
 		 */
-		conn = idr_find(&rxrpc_client_conn_ids,
+		conn = xa_load(&rxrpc_client_conn_ids,
 				sp->hdr.cid >> RXRPC_CIDSHIFT);
 		if (!conn || atomic_read(&conn->usage) == 0) {
 			_debug("no conn");
-- 
2.23.0.rc1

