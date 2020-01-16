Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958CB13F368
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbgAPRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390134AbgAPRLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F98A24693;
        Thu, 16 Jan 2020 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194662;
        bh=4uRfGzFONEgds9jU/XPgMux8GCmiIPHpVnszzqD+900=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9HmppbxXv/WGQxYAIpYWVVZM2pnSp8sdcnI3mVW91ByASzOFo9dWN6AFCbMTYHEU
         s7TS+2GX8BvfeQNA1Hxu2MIUdcuZOnTYvuI6vxFgiRwXt3n7+3cIyswHflg+ZWhqdR
         menyNGR35tO+VCmqY/61Ge50tHzP3Y6+ylzYol6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 512/671] rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ver #2]
Date:   Thu, 16 Jan 2020 12:02:30 -0500
Message-Id: <20200116170509.12787-249-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d12040b6933f684a26773afad46dbba9778608d7 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c     |  3 ---
 net/rxrpc/ar-internal.h  |  1 +
 net/rxrpc/conn_client.c  | 44 ++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/conn_object.c  |  2 +-
 net/rxrpc/local_object.c |  5 ++++-
 5 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 7319d3ca30e9..a74edb10cbfc 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -869,7 +869,6 @@ static void rxrpc_sock_destructor(struct sock *sk)
 static int rxrpc_release_sock(struct sock *sk)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
-	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
 
 	_enter("%p{%d,%d}", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
@@ -905,8 +904,6 @@ static int rxrpc_release_sock(struct sock *sk)
 	rxrpc_release_calls_on_socket(rx);
 	flush_workqueue(rxrpc_workqueue);
 	rxrpc_purge_queue(&sk->sk_receive_queue);
-	rxrpc_queue_work(&rxnet->service_conn_reaper);
-	rxrpc_queue_work(&rxnet->client_conn_reaper);
 
 	rxrpc_unuse_local(rx->local);
 	rx->local = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 37e4c1801a41..ccef6e40e002 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -903,6 +903,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *);
 void rxrpc_put_client_conn(struct rxrpc_connection *);
 void rxrpc_discard_expired_client_conns(struct work_struct *);
 void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
+void rxrpc_clean_up_local_conns(struct rxrpc_local *);
 
 /*
  * conn_event.c
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index c979a56faaef..3dbb126e6060 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -1166,3 +1166,47 @@ void rxrpc_destroy_all_client_connections(struct rxrpc_net *rxnet)
 
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
+	while (!list_empty(&graveyard)) {
+		conn = list_entry(graveyard.next,
+				  struct rxrpc_connection, cache_link);
+		list_del_init(&conn->cache_link);
+
+		rxrpc_put_connection(conn);
+	}
+
+	_leave(" [culled]");
+}
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 885dae829f4a..004a6eb529bc 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -401,7 +401,7 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
 
-		if (rxnet->live) {
+		if (rxnet->live && !conn->params.local->dead) {
 			idle_timestamp = READ_ONCE(conn->idle_timestamp);
 			expire_at = idle_timestamp + rxrpc_connection_expiry * HZ;
 			if (conn->params.local->service_closed)
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index c752ad487067..04f0976841a4 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -430,11 +430,14 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 
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
-- 
2.20.1

