Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B26E5AFF
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJZNT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfJZNT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49FE721D81;
        Sat, 26 Oct 2019 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095967;
        bh=G4tKmQT91fdo3pi0ZcwYS2NIDzLCXtwTmvkJE5wHsbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9u4ZAmKfSCL+Dp0tJBwkuPZz5lclj0vmVHJpIlkJbrzIWqQUquXj+9DzkG5ahjhJ
         1nWgVVYB7z+l2IkQLwYL/C7KMg2WYCI3Y+X1qr8gU8V751wADlV5a+BSzq2Gmz6fjH
         o25/ngQFmZrJTFLNMBAlN/SraMoiMEOHri5TFYXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/59] rxrpc: Fix trace-after-put looking at the put connection record
Date:   Sat, 26 Oct 2019 09:18:23 -0400
Message-Id: <20191026131910.3435-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4c1295dccc0afe0905b6ca4c62ade7f2406f2cfb ]

rxrpc_put_*conn() calls trace_rxrpc_conn() after they have done the
decrement of the refcount - which looks at the debug_id in the connection
record.  But unless the refcount was reduced to zero, we no longer have the
right to look in the record and, indeed, it may be deleted by some other
thread.

Fix this by getting the debug_id out before decrementing the refcount and
then passing that into the tracepoint.

Fixes: 363deeab6d0f ("rxrpc: Add connection tracepoint and client conn state tracepoint")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  6 +++---
 net/rxrpc/call_accept.c      |  2 +-
 net/rxrpc/conn_client.c      |  6 ++++--
 net/rxrpc/conn_object.c      | 13 +++++++------
 net/rxrpc/conn_service.c     |  2 +-
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a08916eb76152..0924119bcfa40 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -554,10 +554,10 @@ TRACE_EVENT(rxrpc_peer,
 	    );
 
 TRACE_EVENT(rxrpc_conn,
-	    TP_PROTO(struct rxrpc_connection *conn, enum rxrpc_conn_trace op,
+	    TP_PROTO(unsigned int conn_debug_id, enum rxrpc_conn_trace op,
 		     int usage, const void *where),
 
-	    TP_ARGS(conn, op, usage, where),
+	    TP_ARGS(conn_debug_id, op, usage, where),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	conn		)
@@ -567,7 +567,7 @@ TRACE_EVENT(rxrpc_conn,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->conn = conn->debug_id;
+		    __entry->conn = conn_debug_id;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->where = where;
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8079aacaecace..c5566bc4aaca3 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -88,7 +88,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 		smp_store_release(&b->conn_backlog_head,
 				  (head + 1) & (size - 1));
 
-		trace_rxrpc_conn(conn, rxrpc_conn_new_service,
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
 				 atomic_read(&conn->usage), here);
 	}
 
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index c979a56faaef0..f16c7e913f50b 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -217,7 +217,8 @@ rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
 	rxrpc_get_local(conn->params.local);
 	key_get(conn->params.key);
 
-	trace_rxrpc_conn(conn, rxrpc_conn_new_client, atomic_read(&conn->usage),
+	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
+			 atomic_read(&conn->usage),
 			 __builtin_return_address(0));
 	trace_rxrpc_client(conn, -1, rxrpc_client_alloc);
 	_leave(" = %p", conn);
@@ -989,11 +990,12 @@ rxrpc_put_one_client_conn(struct rxrpc_connection *conn)
 void rxrpc_put_client_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = conn->debug_id;
 	int n;
 
 	do {
 		n = atomic_dec_return(&conn->usage);
-		trace_rxrpc_conn(conn, rxrpc_conn_put_client, n, here);
+		trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, n, here);
 		if (n > 0)
 			return;
 		ASSERTCMP(n, >=, 0);
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 885dae829f4a1..3d02636b8f856 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -272,7 +272,7 @@ bool rxrpc_queue_conn(struct rxrpc_connection *conn)
 	if (n == 0)
 		return false;
 	if (rxrpc_queue_work(&conn->processor))
-		trace_rxrpc_conn(conn, rxrpc_conn_queued, n + 1, here);
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_queued, n + 1, here);
 	else
 		rxrpc_put_connection(conn);
 	return true;
@@ -287,7 +287,7 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 	if (conn) {
 		int n = atomic_read(&conn->usage);
 
-		trace_rxrpc_conn(conn, rxrpc_conn_seen, n, here);
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_seen, n, here);
 	}
 }
 
@@ -299,7 +299,7 @@ void rxrpc_get_connection(struct rxrpc_connection *conn)
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(&conn->usage);
 
-	trace_rxrpc_conn(conn, rxrpc_conn_got, n, here);
+	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n, here);
 }
 
 /*
@@ -313,7 +313,7 @@ rxrpc_get_connection_maybe(struct rxrpc_connection *conn)
 	if (conn) {
 		int n = atomic_fetch_add_unless(&conn->usage, 1, 0);
 		if (n > 0)
-			trace_rxrpc_conn(conn, rxrpc_conn_got, n + 1, here);
+			trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n + 1, here);
 		else
 			conn = NULL;
 	}
@@ -336,10 +336,11 @@ static void rxrpc_set_service_reap_timer(struct rxrpc_net *rxnet,
 void rxrpc_put_service_conn(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = conn->debug_id;
 	int n;
 
 	n = atomic_dec_return(&conn->usage);
-	trace_rxrpc_conn(conn, rxrpc_conn_put_service, n, here);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, n, here);
 	ASSERTCMP(n, >=, 0);
 	if (n == 1)
 		rxrpc_set_service_reap_timer(conn->params.local->rxnet,
@@ -423,7 +424,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		 */
 		if (atomic_cmpxchg(&conn->usage, 1, 0) != 1)
 			continue;
-		trace_rxrpc_conn(conn, rxrpc_conn_reap_service, 0, NULL);
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_reap_service, 0, NULL);
 
 		if (rxrpc_conn_is_client(conn))
 			BUG();
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 80773a50c7551..6da7c4bf15e88 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -138,7 +138,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
 		write_unlock(&rxnet->conn_lock);
 
-		trace_rxrpc_conn(conn, rxrpc_conn_new_service,
+		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
 				 atomic_read(&conn->usage),
 				 __builtin_return_address(0));
 	}
-- 
2.20.1

