Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5C14ED45
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgAaN3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:29:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728642AbgAaN3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 08:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580477385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvoNRoUk9KBgVLuysJvYzllHw7oTRziyJNZ8f1NEPNw=;
        b=YIZ0P1PHpYOVS2ywrtzS2PIo+lP1zPHsHAHuc2T3R8i59QvXQg41otRILar8QlW0wx1iai
        oIbmmN9LbED7RJNLDIwPawJQXgWxJQuaSH/Feq6ShTl2fHN7SUoeggAdlOIlGvV7VZUpqy
        EQCfxbr3mJVW7oveBj8Sallt1L6KfHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-ZfOQ6wcANROEKh3ylNlEvw-1; Fri, 31 Jan 2020 08:29:39 -0500
X-MC-Unique: ZfOQ6wcANROEKh3ylNlEvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 961C9477;
        Fri, 31 Jan 2020 13:29:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A086119C4F;
        Fri, 31 Jan 2020 13:29:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/4] rxrpc: Fix missing active use pinning of rxrpc_local
 object
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 31 Jan 2020 13:29:36 +0000
Message-ID: <158047737679.133127.13567286503234295.stgit@warthog.procyon.org.uk>
In-Reply-To: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
References: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of a split between the reference count on rxrpc_local
objects and the usage count didn't quite go far enough.  A number of kernel
work items need to make use of the socket to perform transmission.  These
also need to get an active count on the local object to prevent the socket
from being closed.

Fix this by getting the active count in those places.

Also split out the raw active count get/put functions as these places tend
to hold refs on the rxrpc_local object already, so getting and putting an
extra object ref is just a waste of time.

The problem can lead to symptoms like:

    BUG: kernel NULL pointer dereference, address: 0000000000000018
    ..
    CPU: 2 PID: 818 Comm: kworker/u9:0 Not tainted 5.5.0-fscache+ #51
    ...
    RIP: 0010:selinux_socket_sendmsg+0x5/0x13
    ...
    Call Trace:
     security_socket_sendmsg+0x2c/0x3e
     sock_sendmsg+0x1a/0x46
     rxrpc_send_keepalive+0x131/0x1ae
     rxrpc_peer_keepalive_worker+0x219/0x34b
     process_one_work+0x18e/0x271
     worker_thread+0x1a3/0x247
     kthread+0xe6/0xeb
     ret_from_fork+0x1f/0x30

Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/af_rxrpc.c     |    2 ++
 net/rxrpc/ar-internal.h  |   10 ++++++++++
 net/rxrpc/conn_event.c   |   32 ++++++++++++++++++++++----------
 net/rxrpc/local_object.c |   18 +++++++-----------
 net/rxrpc/peer_event.c   |   42 +++++++++++++++++++++++-------------------
 5 files changed, 64 insertions(+), 40 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 9d3c4d2d893a..fe42f986cd94 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -194,6 +194,7 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 service_in_use:
 	write_unlock(&local->services_lock);
 	rxrpc_unuse_local(local);
+	rxrpc_put_local(local);
 	ret = -EADDRINUSE;
 error_unlock:
 	release_sock(&rx->sk);
@@ -899,6 +900,7 @@ static int rxrpc_release_sock(struct sock *sk)
 	rxrpc_purge_queue(&sk->sk_receive_queue);
 
 	rxrpc_unuse_local(rx->local);
+	rxrpc_put_local(rx->local);
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5e99df80e80a..94441fee85bc 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1021,6 +1021,16 @@ void rxrpc_unuse_local(struct rxrpc_local *);
 void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
+static inline bool __rxrpc_unuse_local(struct rxrpc_local *local)
+{
+	return atomic_dec_return(&local->active_users) == 0;
+}
+
+static inline bool __rxrpc_use_local(struct rxrpc_local *local)
+{
+	return atomic_fetch_add_unless(&local->active_users, 1, 0) != 0;
+}
+
 /*
  * misc.c
  */
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 808a4723f868..abfff3e0921c 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -133,6 +133,8 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 		break;
 	}
 
+	BUG_ON(!conn->params.local);
+	BUG_ON(!conn->params.local->socket);
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, ioc, len);
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
@@ -438,16 +440,12 @@ static void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn)
 /*
  * connection-level event processor
  */
-void rxrpc_process_connection(struct work_struct *work)
+static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 {
-	struct rxrpc_connection *conn =
-		container_of(work, struct rxrpc_connection, processor);
 	struct sk_buff *skb;
 	u32 abort_code = RX_PROTOCOL_ERROR;
 	int ret;
 
-	rxrpc_see_connection(conn);
-
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
 		rxrpc_secure_connection(conn);
 
@@ -475,18 +473,32 @@ void rxrpc_process_connection(struct work_struct *work)
 		}
 	}
 
-out:
-	rxrpc_put_connection(conn);
-	_leave("");
 	return;
 
 requeue_and_leave:
 	skb_queue_head(&conn->rx_queue, skb);
-	goto out;
+	return;
 
 protocol_error:
 	if (rxrpc_abort_connection(conn, ret, abort_code) < 0)
 		goto requeue_and_leave;
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
-	goto out;
+	return;
+}
+
+void rxrpc_process_connection(struct work_struct *work)
+{
+	struct rxrpc_connection *conn =
+		container_of(work, struct rxrpc_connection, processor);
+
+	rxrpc_see_connection(conn);
+
+	if (__rxrpc_use_local(conn->params.local)) {
+		rxrpc_do_process_connection(conn);
+		rxrpc_unuse_local(conn->params.local);
+	}
+
+	rxrpc_put_connection(conn);
+	_leave("");
+	return;
 }
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 3aa179efcda4..a6c1349e965d 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -383,14 +383,11 @@ void rxrpc_put_local(struct rxrpc_local *local)
  */
 struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
 {
-	unsigned int au;
-
 	local = rxrpc_get_local_maybe(local);
 	if (!local)
 		return NULL;
 
-	au = atomic_fetch_add_unless(&local->active_users, 1, 0);
-	if (au == 0) {
+	if (!__rxrpc_use_local(local)) {
 		rxrpc_put_local(local);
 		return NULL;
 	}
@@ -404,14 +401,11 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
  */
 void rxrpc_unuse_local(struct rxrpc_local *local)
 {
-	unsigned int au;
-
 	if (local) {
-		au = atomic_dec_return(&local->active_users);
-		if (au == 0)
+		if (__rxrpc_unuse_local(local)) {
+			rxrpc_get_local(local);
 			rxrpc_queue_local(local);
-		else
-			rxrpc_put_local(local);
+		}
 	}
 }
 
@@ -468,7 +462,7 @@ static void rxrpc_local_processor(struct work_struct *work)
 
 	do {
 		again = false;
-		if (atomic_read(&local->active_users) == 0) {
+		if (!__rxrpc_use_local(local)) {
 			rxrpc_local_destroyer(local);
 			break;
 		}
@@ -482,6 +476,8 @@ static void rxrpc_local_processor(struct work_struct *work)
 			rxrpc_process_local_events(local);
 			again = true;
 		}
+
+		__rxrpc_unuse_local(local);
 	} while (again);
 
 	rxrpc_put_local(local);
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 48f67a9b1037..923b263c401b 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -364,27 +364,31 @@ static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
 		if (!rxrpc_get_peer_maybe(peer))
 			continue;
 
-		spin_unlock_bh(&rxnet->peer_hash_lock);
-
-		keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
-		slot = keepalive_at - base;
-		_debug("%02x peer %u t=%d {%pISp}",
-		       cursor, peer->debug_id, slot, &peer->srx.transport);
+		if (__rxrpc_use_local(peer->local)) {
+			spin_unlock_bh(&rxnet->peer_hash_lock);
+
+			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
+			slot = keepalive_at - base;
+			_debug("%02x peer %u t=%d {%pISp}",
+			       cursor, peer->debug_id, slot, &peer->srx.transport);
+
+			if (keepalive_at <= base ||
+			    keepalive_at > base + RXRPC_KEEPALIVE_TIME) {
+				rxrpc_send_keepalive(peer);
+				slot = RXRPC_KEEPALIVE_TIME;
+			}
 
-		if (keepalive_at <= base ||
-		    keepalive_at > base + RXRPC_KEEPALIVE_TIME) {
-			rxrpc_send_keepalive(peer);
-			slot = RXRPC_KEEPALIVE_TIME;
+			/* A transmission to this peer occurred since last we
+			 * examined it so put it into the appropriate future
+			 * bucket.
+			 */
+			slot += cursor;
+			slot &= mask;
+			spin_lock_bh(&rxnet->peer_hash_lock);
+			list_add_tail(&peer->keepalive_link,
+				      &rxnet->peer_keepalive[slot & mask]);
+			rxrpc_unuse_local(peer->local);
 		}
-
-		/* A transmission to this peer occurred since last we examined
-		 * it so put it into the appropriate future bucket.
-		 */
-		slot += cursor;
-		slot &= mask;
-		spin_lock_bh(&rxnet->peer_hash_lock);
-		list_add_tail(&peer->keepalive_link,
-			      &rxnet->peer_keepalive[slot & mask]);
 		rxrpc_put_peer_locked(peer);
 	}
 


