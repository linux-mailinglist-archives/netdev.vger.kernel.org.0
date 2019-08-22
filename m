Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6959935F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732002AbfHVM0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbfHVM0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:26:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B672C7FDCD;
        Thu, 22 Aug 2019 12:26:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D3B05DE5C;
        Thu, 22 Aug 2019 12:26:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix lack of conn cleanup when local endpoint is
 cleaned up
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 13:26:38 +0100
Message-ID: <156647679816.11606.13713532963081370001.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 22 Aug 2019 12:26:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a local endpoint is ceases to be in use, such as when the kafs module
is unloaded, the kernel will emit an assertion failure if there are any
outstanding client connections:

	rxrpc: Assertion failed
	------------[ cut here ]------------
	kernel BUG at net/rxrpc/local_object.c:433!

and even beyond that, will evince other oopses if there are service
connections still present.

Fix this by:

 (1) Removing the triggering of connection reaping when an rxrpc socket is
     released.  These don't actually clean up the connections anyway - and
     further, the local endpoint may still be in use through another
     socket.

 (2) Mark the local endpoint as dead when we start the process of tearing
     it down.

 (3) When destroying a local endpoint, strip all of its client connections
     from the idle list and discard the ref on each that the list was
     holding.

 (4) When destroying a local endpoint, call the service connection reaper
     directly (rather than through a workqueue) to immediately kill off all
     outstanding service connections.

 (5) Make the service connection reaper reap connections for which the
     local endpoint is marked dead.

Only after destroying the connections can we close the socket lest we get
an oops in a workqueue that's looking at a connection or a peer.

Fixes: 3d18cbb7fd0c ("rxrpc: Fix conn expiry timers")
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
---

 net/rxrpc/af_rxrpc.c     |    3 ---
 net/rxrpc/ar-internal.h  |    1 +
 net/rxrpc/conn_client.c  |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/conn_object.c  |    2 +-
 net/rxrpc/local_object.c |    5 ++++-
 5 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0dbbfd1b6487..d72ddb67bb74 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -862,7 +862,6 @@ static void rxrpc_sock_destructor(struct sock *sk)
 static int rxrpc_release_sock(struct sock *sk)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
-	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
 
 	_enter("%p{%d,%d}", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
@@ -898,8 +897,6 @@ static int rxrpc_release_sock(struct sock *sk)
 	rxrpc_release_calls_on_socket(rx);
 	flush_workqueue(rxrpc_workqueue);
 	rxrpc_purge_queue(&sk->sk_receive_queue);
-	rxrpc_queue_work(&rxnet->service_conn_reaper);
-	rxrpc_queue_work(&rxnet->client_conn_reaper);
 
 	rxrpc_unuse_local(rx->local);
 	rx->local = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index a42d6b833675..ef5aa28e679c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -911,6 +911,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *);
 void rxrpc_put_client_conn(struct rxrpc_connection *);
 void rxrpc_discard_expired_client_conns(struct work_struct *);
 void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
+void rxrpc_clean_up_local_conns(struct rxrpc_local *);
 
 /*
  * conn_event.c
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index aea82f909c60..2244fb7f53ec 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -1162,3 +1162,52 @@ void rxrpc_destroy_all_client_connections(struct rxrpc_net *rxnet)
 
 	_leave("");
 }
+
+/*
+ * Clean up the client connections on a local endpoint.
+ */
+void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
+{
+	struct rxrpc_connection *conn, *tmp;
+	struct rxrpc_net *rxnet = local->rxnet;
+	unsigned int nr_active;
+	LIST_HEAD(graveyard);
+
+	_enter("");
+
+	spin_lock(&rxnet->client_conn_cache_lock);
+	nr_active = rxnet->nr_active_client_conns;
+
+	list_for_each_entry_safe(conn, tmp, &rxnet->idle_client_conns,
+				 cache_link) {
+		if (conn->params.local == local) {
+			ASSERTCMP(conn->cache_state, ==, RXRPC_CONN_CLIENT_IDLE);
+
+			trace_rxrpc_client(conn, -1, rxrpc_client_discard);
+			if (!test_and_clear_bit(RXRPC_CONN_EXPOSED, &conn->flags))
+				BUG();
+			conn->cache_state = RXRPC_CONN_CLIENT_INACTIVE;
+			list_move(&conn->cache_link, &graveyard);
+			nr_active--;
+		}
+	}
+
+	rxnet->nr_active_client_conns = nr_active;
+	spin_unlock(&rxnet->client_conn_cache_lock);
+	ASSERTCMP(nr_active, >=, 0);
+
+	spin_lock(&rxnet->client_conn_cache_lock);
+	while (!list_empty(&graveyard)) {
+		conn = list_entry(graveyard.next,
+				  struct rxrpc_connection, cache_link);
+		list_del_init(&conn->cache_link);
+		spin_unlock(&rxnet->client_conn_cache_lock);
+
+		rxrpc_put_connection(conn);
+
+		spin_lock(&rxnet->client_conn_cache_lock);
+	}
+	spin_unlock(&rxnet->client_conn_cache_lock);
+
+	_leave(" [culled]");
+}
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 434ef392212b..ed05b6922132 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -398,7 +398,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
 
-		if (rxnet->live) {
+		if (rxnet->live && !conn->params.local->dead) {
 			idle_timestamp = READ_ONCE(conn->idle_timestamp);
 			expire_at = idle_timestamp + rxrpc_connection_expiry * HZ;
 			if (conn->params.local->service_closed)
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 72a6e12a9304..36587260cabd 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -426,11 +426,14 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 
 	_enter("%d", local->debug_id);
 
+	local->dead = true;
+
 	mutex_lock(&rxnet->local_mutex);
 	list_del_init(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 
-	ASSERT(RB_EMPTY_ROOT(&local->client_conns));
+	rxrpc_clean_up_local_conns(local);
+	rxrpc_service_connection_reaper(&rxnet->service_conn_reaper);
 	ASSERT(!local->service);
 
 	if (socket) {

