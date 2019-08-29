Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38049A2323
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfH2SNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbfH2SNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542B32189D;
        Thu, 29 Aug 2019 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102419;
        bh=dkhchyWdtMxa8jcjPXHapPWPE4rhmniDAp/Qs15YCTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei3R/AIepm5x8fmRuA7bGr2p4oXeNNyCCRXCbe5XV99Pi/bf4UdQJxyvZPUGybT0s
         h22DiHW+5ZFDDN6oG0ddRWpMkMNUtWcRsi9jd+udMgqQrx68zR5/0NOkuU7T+RmbNT
         7oFAATNfsnZcVt4TRHj72OjNkkfouOKjITaDWwLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 13/76] rxrpc: Fix local endpoint refcounting
Date:   Thu, 29 Aug 2019 14:12:08 -0400
Message-Id: <20190829181311.7562-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 730c5fd42c1e3652a065448fd235cb9fafb2bd10 ]

The object lifetime management on the rxrpc_local struct is broken in that
the rxrpc_local_processor() function is expected to clean up and remove an
object - but it may get requeued by packets coming in on the backing UDP
socket once it starts running.

This may result in the assertion in rxrpc_local_rcu() firing because the
memory has been scheduled for RCU destruction whilst still queued:

	rxrpc: Assertion failed
	------------[ cut here ]------------
	kernel BUG at net/rxrpc/local_object.c:468!

Note that if the processor comes around before the RCU free function, it
will just do nothing because ->dead is true.

Fix this by adding a separate refcount to count active users of the
endpoint that causes the endpoint to be destroyed when it reaches 0.

The original refcount can then be used to refcount objects through the work
processor and cause the memory to be rcu freed when that reaches 0.

Fixes: 4f95dd78a77e ("rxrpc: Rework local endpoint management")
Reported-by: syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c     |  4 +-
 net/rxrpc/ar-internal.h  |  5 ++-
 net/rxrpc/input.c        | 16 ++++++--
 net/rxrpc/local_object.c | 86 +++++++++++++++++++++++++---------------
 4 files changed, 72 insertions(+), 39 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index d09eaf1535441..8c9bd3ae9edf7 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -193,7 +193,7 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 
 service_in_use:
 	write_unlock(&local->services_lock);
-	rxrpc_put_local(local);
+	rxrpc_unuse_local(local);
 	ret = -EADDRINUSE;
 error_unlock:
 	release_sock(&rx->sk);
@@ -901,7 +901,7 @@ static int rxrpc_release_sock(struct sock *sk)
 	rxrpc_queue_work(&rxnet->service_conn_reaper);
 	rxrpc_queue_work(&rxnet->client_conn_reaper);
 
-	rxrpc_put_local(rx->local);
+	rxrpc_unuse_local(rx->local);
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 80335b4ee4fd6..6a231c8f43066 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -254,7 +254,8 @@ struct rxrpc_security {
  */
 struct rxrpc_local {
 	struct rcu_head		rcu;
-	atomic_t		usage;
+	atomic_t		active_users;	/* Number of users of the local endpoint */
+	atomic_t		usage;		/* Number of references to the structure */
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
 	struct list_head	link;
 	struct socket		*socket;	/* my UDP socket */
@@ -1002,6 +1003,8 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *, const struct sockaddr_rxrpc
 struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *);
 struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *);
 void rxrpc_put_local(struct rxrpc_local *);
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *);
+void rxrpc_unuse_local(struct rxrpc_local *);
 void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 5bd6f1546e5c6..ee95d1cd1cdf2 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1108,8 +1108,12 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 {
 	_enter("%p,%p", local, skb);
 
-	skb_queue_tail(&local->event_queue, skb);
-	rxrpc_queue_local(local);
+	if (rxrpc_get_local_maybe(local)) {
+		skb_queue_tail(&local->event_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	}
 }
 
 /*
@@ -1119,8 +1123,12 @@ static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
 	CHECK_SLAB_OKAY(&local->usage);
 
-	skb_queue_tail(&local->reject_queue, skb);
-	rxrpc_queue_local(local);
+	if (rxrpc_get_local_maybe(local)) {
+		skb_queue_tail(&local->reject_queue, skb);
+		rxrpc_queue_local(local);
+	} else {
+		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+	}
 }
 
 /*
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index b1c71bad510b7..9798159ee65fa 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -79,6 +79,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
 		atomic_set(&local->usage, 1);
+		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_LIST_HEAD(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
@@ -266,11 +267,8 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		 * bind the transport socket may still fail if we're attempting
 		 * to use a local address that the dying object is still using.
 		 */
-		if (!rxrpc_get_local_maybe(local)) {
-			cursor = cursor->next;
-			list_del_init(&local->link);
+		if (!rxrpc_use_local(local))
 			break;
-		}
 
 		age = "old";
 		goto found;
@@ -284,7 +282,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	if (ret < 0)
 		goto sock_error;
 
-	list_add_tail(&local->link, cursor);
+	if (cursor != &rxnet->local_endpoints)
+		list_replace(cursor, &local->link);
+	else
+		list_add_tail(&local->link, cursor);
 	age = "new";
 
 found:
@@ -342,7 +343,8 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
 }
 
 /*
- * Queue a local endpoint.
+ * Queue a local endpoint unless it has become unreferenced and pass the
+ * caller's reference to the work item.
  */
 void rxrpc_queue_local(struct rxrpc_local *local)
 {
@@ -351,15 +353,8 @@ void rxrpc_queue_local(struct rxrpc_local *local)
 	if (rxrpc_queue_work(&local->processor))
 		trace_rxrpc_local(local, rxrpc_local_queued,
 				  atomic_read(&local->usage), here);
-}
-
-/*
- * A local endpoint reached its end of life.
- */
-static void __rxrpc_put_local(struct rxrpc_local *local)
-{
-	_enter("%d", local->debug_id);
-	rxrpc_queue_work(&local->processor);
+	else
+		rxrpc_put_local(local);
 }
 
 /*
@@ -375,10 +370,45 @@ void rxrpc_put_local(struct rxrpc_local *local)
 		trace_rxrpc_local(local, rxrpc_local_put, n, here);
 
 		if (n == 0)
-			__rxrpc_put_local(local);
+			call_rcu(&local->rcu, rxrpc_local_rcu);
 	}
 }
 
+/*
+ * Start using a local endpoint.
+ */
+struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
+{
+	unsigned int au;
+
+	local = rxrpc_get_local_maybe(local);
+	if (!local)
+		return NULL;
+
+	au = atomic_fetch_add_unless(&local->active_users, 1, 0);
+	if (au == 0) {
+		rxrpc_put_local(local);
+		return NULL;
+	}
+
+	return local;
+}
+
+/*
+ * Cease using a local endpoint.  Once the number of active users reaches 0, we
+ * start the closure of the transport in the work processor.
+ */
+void rxrpc_unuse_local(struct rxrpc_local *local)
+{
+	unsigned int au;
+
+	au = atomic_dec_return(&local->active_users);
+	if (au == 0)
+		rxrpc_queue_local(local);
+	else
+		rxrpc_put_local(local);
+}
+
 /*
  * Destroy a local endpoint's socket and then hand the record to RCU to dispose
  * of.
@@ -393,16 +423,6 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 
 	_enter("%d", local->debug_id);
 
-	/* We can get a race between an incoming call packet queueing the
-	 * processor again and the work processor starting the destruction
-	 * process which will shut down the UDP socket.
-	 */
-	if (local->dead) {
-		_leave(" [already dead]");
-		return;
-	}
-	local->dead = true;
-
 	mutex_lock(&rxnet->local_mutex);
 	list_del_init(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
@@ -422,13 +442,11 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	 */
 	rxrpc_purge_queue(&local->reject_queue);
 	rxrpc_purge_queue(&local->event_queue);
-
-	_debug("rcu local %d", local->debug_id);
-	call_rcu(&local->rcu, rxrpc_local_rcu);
 }
 
 /*
- * Process events on an endpoint
+ * Process events on an endpoint.  The work item carries a ref which
+ * we must release.
  */
 static void rxrpc_local_processor(struct work_struct *work)
 {
@@ -441,8 +459,10 @@ static void rxrpc_local_processor(struct work_struct *work)
 
 	do {
 		again = false;
-		if (atomic_read(&local->usage) == 0)
-			return rxrpc_local_destroyer(local);
+		if (atomic_read(&local->active_users) == 0) {
+			rxrpc_local_destroyer(local);
+			break;
+		}
 
 		if (!skb_queue_empty(&local->reject_queue)) {
 			rxrpc_reject_packets(local);
@@ -454,6 +474,8 @@ static void rxrpc_local_processor(struct work_struct *work)
 			again = true;
 		}
 	} while (again);
+
+	rxrpc_put_local(local);
 }
 
 /*
-- 
2.20.1

