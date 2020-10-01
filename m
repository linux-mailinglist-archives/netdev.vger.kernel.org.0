Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECC92801CF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbgJAO5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732621AbgJAO5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y+0YS5QwAJcHWBSFmzGr/WZMtkwEhQFQQYI+uWG7i8w=;
        b=hasXnJFXfVsyfaa0p/PgqH1QqQkmEj4VpByIsyQed4kGieh5j1FsE0yqaNgDU4416KIX53
        cFkwzeEJ/12zMmAvs9gLsHxQ/ZBBg8/km3vcmYViygv0BrylsOcPNKo3BIVZz0zDKsWp7H
        A4saRlLpiZz3SKAzQjPmyS8FkoynbK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-GaVPbEyRP_SONcoyo5Bwxg-1; Thu, 01 Oct 2020 10:57:34 -0400
X-MC-Unique: GaVPbEyRP_SONcoyo5Bwxg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9FEAE82A;
        Thu,  1 Oct 2020 14:57:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F1D10013BD;
        Thu,  1 Oct 2020 14:57:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/23] rxrpc: Fix accept on a connection that need
 securing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:31 +0100
Message-ID: <160156425143.1728886.6000195161084999281.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a new incoming call arrives at an userspace rxrpc socket on a new
connection that has a security class set, the code currently pushes it onto
the accept queue to hold a ref on it for the socket.  This doesn't work,
however, as recvmsg() pops it off, notices that it's in the SERVER_SECURING
state and discards the ref.  This means that the call runs out of refs too
early and the kernel oopses.

By contrast, a kernel rxrpc socket manually pre-charges the incoming call
pool with calls that already have user call IDs assigned, so they are ref'd
by the call tree on the socket.

Change the mode of operation for userspace rxrpc server sockets to work
like this too.  Although this is a UAPI change, server sockets aren't
currently functional.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/rxrpc.h |    2 
 net/rxrpc/ar-internal.h    |    7 -
 net/rxrpc/call_accept.c    |  263 ++++++--------------------------------------
 net/rxrpc/call_object.c    |    5 -
 net/rxrpc/conn_event.c     |    2 
 net/rxrpc/recvmsg.c        |   36 ------
 net/rxrpc/sendmsg.c        |   15 +--
 7 files changed, 49 insertions(+), 281 deletions(-)

diff --git a/include/uapi/linux/rxrpc.h b/include/uapi/linux/rxrpc.h
index 4accfa7e266d..8f8dc7a937a4 100644
--- a/include/uapi/linux/rxrpc.h
+++ b/include/uapi/linux/rxrpc.h
@@ -51,11 +51,11 @@ enum rxrpc_cmsg_type {
 	RXRPC_BUSY		= 6,	/* -r: server busy received [terminal] */
 	RXRPC_LOCAL_ERROR	= 7,	/* -r: local error generated [terminal] */
 	RXRPC_NEW_CALL		= 8,	/* -r: [Service] new incoming call notification */
-	RXRPC_ACCEPT		= 9,	/* s-: [Service] accept request */
 	RXRPC_EXCLUSIVE_CALL	= 10,	/* s-: Call should be on exclusive connection */
 	RXRPC_UPGRADE_SERVICE	= 11,	/* s-: Request service upgrade for client call */
 	RXRPC_TX_LENGTH		= 12,	/* s-: Total length of Tx data */
 	RXRPC_SET_CALL_TIMEOUT	= 13,	/* s-: Set one or more call timeouts */
+	RXRPC_CHARGE_ACCEPT	= 14,	/* s-: Charge the accept pool with a user call ID */
 	RXRPC__SUPPORTED
 };
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 0b4233fdd740..dce48162f6c2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -514,7 +514,6 @@ enum rxrpc_call_state {
 	RXRPC_CALL_CLIENT_RECV_REPLY,	/* - client receiving reply phase */
 	RXRPC_CALL_SERVER_PREALLOC,	/* - service preallocation */
 	RXRPC_CALL_SERVER_SECURING,	/* - server securing request connection */
-	RXRPC_CALL_SERVER_ACCEPTING,	/* - server accepting request */
 	RXRPC_CALL_SERVER_RECV_REQUEST,	/* - server receiving request */
 	RXRPC_CALL_SERVER_ACK_REQUEST,	/* - server pending ACK of request */
 	RXRPC_CALL_SERVER_SEND_REPLY,	/* - server sending reply */
@@ -710,8 +709,8 @@ struct rxrpc_ack_summary {
 enum rxrpc_command {
 	RXRPC_CMD_SEND_DATA,		/* send data message */
 	RXRPC_CMD_SEND_ABORT,		/* request abort generation */
-	RXRPC_CMD_ACCEPT,		/* [server] accept incoming call */
 	RXRPC_CMD_REJECT_BUSY,		/* [server] reject a call as busy */
+	RXRPC_CMD_CHARGE_ACCEPT,	/* [server] charge accept preallocation */
 };
 
 struct rxrpc_call_params {
@@ -752,9 +751,7 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *,
 					   struct rxrpc_sock *,
 					   struct sk_buff *);
 void rxrpc_accept_incoming_calls(struct rxrpc_local *);
-struct rxrpc_call *rxrpc_accept_call(struct rxrpc_sock *, unsigned long,
-				     rxrpc_notify_rx_t);
-int rxrpc_reject_call(struct rxrpc_sock *);
+int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 
 /*
  * call_event.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index ef160566aa9a..8df1964db333 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -39,8 +39,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 				      unsigned int debug_id)
 {
 	const void *here = __builtin_return_address(0);
-	struct rxrpc_call *call;
+	struct rxrpc_call *call, *xcall;
 	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
+	struct rb_node *parent, **pp;
 	int max, tmp;
 	unsigned int size = RXRPC_BACKLOG_MAX;
 	unsigned int head, tail, call_head, call_tail;
@@ -94,7 +95,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	}
 
 	/* Now it gets complicated, because calls get registered with the
-	 * socket here, particularly if a user ID is preassigned by the user.
+	 * socket here, with a user ID preassigned by the user.
 	 */
 	call = rxrpc_alloc_call(rx, gfp, debug_id);
 	if (!call)
@@ -107,34 +108,33 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 			 here, (const void *)user_call_ID);
 
 	write_lock(&rx->call_lock);
-	if (user_attach_call) {
-		struct rxrpc_call *xcall;
-		struct rb_node *parent, **pp;
-
-		/* Check the user ID isn't already in use */
-		pp = &rx->calls.rb_node;
-		parent = NULL;
-		while (*pp) {
-			parent = *pp;
-			xcall = rb_entry(parent, struct rxrpc_call, sock_node);
-			if (user_call_ID < xcall->user_call_ID)
-				pp = &(*pp)->rb_left;
-			else if (user_call_ID > xcall->user_call_ID)
-				pp = &(*pp)->rb_right;
-			else
-				goto id_in_use;
-		}
 
-		call->user_call_ID = user_call_ID;
-		call->notify_rx = notify_rx;
+	/* Check the user ID isn't already in use */
+	pp = &rx->calls.rb_node;
+	parent = NULL;
+	while (*pp) {
+		parent = *pp;
+		xcall = rb_entry(parent, struct rxrpc_call, sock_node);
+		if (user_call_ID < xcall->user_call_ID)
+			pp = &(*pp)->rb_left;
+		else if (user_call_ID > xcall->user_call_ID)
+			pp = &(*pp)->rb_right;
+		else
+			goto id_in_use;
+	}
+
+	call->user_call_ID = user_call_ID;
+	call->notify_rx = notify_rx;
+	if (user_attach_call) {
 		rxrpc_get_call(call, rxrpc_call_got_kernel);
 		user_attach_call(call, user_call_ID);
-		rxrpc_get_call(call, rxrpc_call_got_userid);
-		rb_link_node(&call->sock_node, parent, pp);
-		rb_insert_color(&call->sock_node, &rx->calls);
-		set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
 	}
 
+	rxrpc_get_call(call, rxrpc_call_got_userid);
+	rb_link_node(&call->sock_node, parent, pp);
+	rb_insert_color(&call->sock_node, &rx->calls);
+	set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
+
 	list_add(&call->sock_link, &rx->sock_calls);
 
 	write_unlock(&rx->call_lock);
@@ -157,11 +157,8 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 }
 
 /*
- * Preallocate sufficient service connections, calls and peers to cover the
- * entire backlog of a socket.  When a new call comes in, if we don't have
- * sufficient of each available, the call gets rejected as busy or ignored.
- *
- * The backlog is replenished when a connection is accepted or rejected.
+ * Allocate the preallocation buffers for incoming service calls.  These must
+ * be charged manually.
  */
 int rxrpc_service_prealloc(struct rxrpc_sock *rx, gfp_t gfp)
 {
@@ -174,13 +171,6 @@ int rxrpc_service_prealloc(struct rxrpc_sock *rx, gfp_t gfp)
 		rx->backlog = b;
 	}
 
-	if (rx->discard_new_call)
-		return 0;
-
-	while (rxrpc_service_prealloc_one(rx, b, NULL, NULL, 0, gfp,
-					  atomic_inc_return(&rxrpc_debug_id)) == 0)
-		;
-
 	return 0;
 }
 
@@ -333,6 +323,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	rxrpc_see_call(call);
 	call->conn = conn;
 	call->security = conn->security;
+	call->security_ix = conn->security_ix;
 	call->peer = rxrpc_get_peer(conn->params.peer);
 	call->cong_cwnd = call->peer->cong_cwnd;
 	return call;
@@ -402,8 +393,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	if (rx->notify_new_call)
 		rx->notify_new_call(&rx->sk, call, call->user_call_ID);
-	else
-		sk_acceptq_added(&rx->sk);
 
 	spin_lock(&conn->state_lock);
 	switch (conn->state) {
@@ -415,12 +404,8 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	case RXRPC_CONN_SERVICE:
 		write_lock(&call->state_lock);
-		if (call->state < RXRPC_CALL_COMPLETE) {
-			if (rx->discard_new_call)
-				call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
-			else
-				call->state = RXRPC_CALL_SERVER_ACCEPTING;
-		}
+		if (call->state < RXRPC_CALL_COMPLETE)
+			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
 		write_unlock(&call->state_lock);
 		break;
 
@@ -440,9 +425,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	rxrpc_send_ping(call, skb);
 
-	if (call->state == RXRPC_CALL_SERVER_ACCEPTING)
-		rxrpc_notify_socket(call);
-
 	/* We have to discard the prealloc queue's ref here and rely on a
 	 * combination of the RCU read lock and refs held either by the socket
 	 * (recvmsg queue, to-be-accepted queue or user ID tree) or the kernel
@@ -460,187 +442,18 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 }
 
 /*
- * handle acceptance of a call by userspace
- * - assign the user call ID to the call at the front of the queue
- * - called with the socket locked.
+ * Charge up socket with preallocated calls, attaching user call IDs.
  */
-struct rxrpc_call *rxrpc_accept_call(struct rxrpc_sock *rx,
-				     unsigned long user_call_ID,
-				     rxrpc_notify_rx_t notify_rx)
-	__releases(&rx->sk.sk_lock.slock)
-	__acquires(call->user_mutex)
+int rxrpc_user_charge_accept(struct rxrpc_sock *rx, unsigned long user_call_ID)
 {
-	struct rxrpc_call *call;
-	struct rb_node *parent, **pp;
-	int ret;
-
-	_enter(",%lx", user_call_ID);
-
-	ASSERT(!irqs_disabled());
-
-	write_lock(&rx->call_lock);
-
-	if (list_empty(&rx->to_be_accepted)) {
-		write_unlock(&rx->call_lock);
-		release_sock(&rx->sk);
-		kleave(" = -ENODATA [empty]");
-		return ERR_PTR(-ENODATA);
-	}
-
-	/* check the user ID isn't already in use */
-	pp = &rx->calls.rb_node;
-	parent = NULL;
-	while (*pp) {
-		parent = *pp;
-		call = rb_entry(parent, struct rxrpc_call, sock_node);
-
-		if (user_call_ID < call->user_call_ID)
-			pp = &(*pp)->rb_left;
-		else if (user_call_ID > call->user_call_ID)
-			pp = &(*pp)->rb_right;
-		else
-			goto id_in_use;
-	}
-
-	/* Dequeue the first call and check it's still valid.  We gain
-	 * responsibility for the queue's reference.
-	 */
-	call = list_entry(rx->to_be_accepted.next,
-			  struct rxrpc_call, accept_link);
-	write_unlock(&rx->call_lock);
-
-	/* We need to gain the mutex from the interrupt handler without
-	 * upsetting lockdep, so we have to release it there and take it here.
-	 * We are, however, still holding the socket lock, so other accepts
-	 * must wait for us and no one can add the user ID behind our backs.
-	 */
-	if (mutex_lock_interruptible(&call->user_mutex) < 0) {
-		release_sock(&rx->sk);
-		kleave(" = -ERESTARTSYS");
-		return ERR_PTR(-ERESTARTSYS);
-	}
-
-	write_lock(&rx->call_lock);
-	list_del_init(&call->accept_link);
-	sk_acceptq_removed(&rx->sk);
-	rxrpc_see_call(call);
-
-	/* Find the user ID insertion point. */
-	pp = &rx->calls.rb_node;
-	parent = NULL;
-	while (*pp) {
-		parent = *pp;
-		call = rb_entry(parent, struct rxrpc_call, sock_node);
-
-		if (user_call_ID < call->user_call_ID)
-			pp = &(*pp)->rb_left;
-		else if (user_call_ID > call->user_call_ID)
-			pp = &(*pp)->rb_right;
-		else
-			BUG();
-	}
-
-	write_lock_bh(&call->state_lock);
-	switch (call->state) {
-	case RXRPC_CALL_SERVER_ACCEPTING:
-		call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
-		break;
-	case RXRPC_CALL_COMPLETE:
-		ret = call->error;
-		goto out_release;
-	default:
-		BUG();
-	}
-
-	/* formalise the acceptance */
-	call->notify_rx = notify_rx;
-	call->user_call_ID = user_call_ID;
-	rxrpc_get_call(call, rxrpc_call_got_userid);
-	rb_link_node(&call->sock_node, parent, pp);
-	rb_insert_color(&call->sock_node, &rx->calls);
-	if (test_and_set_bit(RXRPC_CALL_HAS_USERID, &call->flags))
-		BUG();
-
-	write_unlock_bh(&call->state_lock);
-	write_unlock(&rx->call_lock);
-	rxrpc_notify_socket(call);
-	rxrpc_service_prealloc(rx, GFP_KERNEL);
-	release_sock(&rx->sk);
-	_leave(" = %p{%d}", call, call->debug_id);
-	return call;
-
-out_release:
-	_debug("release %p", call);
-	write_unlock_bh(&call->state_lock);
-	write_unlock(&rx->call_lock);
-	rxrpc_release_call(rx, call);
-	rxrpc_put_call(call, rxrpc_call_put);
-	goto out;
-
-id_in_use:
-	ret = -EBADSLT;
-	write_unlock(&rx->call_lock);
-out:
-	rxrpc_service_prealloc(rx, GFP_KERNEL);
-	release_sock(&rx->sk);
-	_leave(" = %d", ret);
-	return ERR_PTR(ret);
-}
-
-/*
- * Handle rejection of a call by userspace
- * - reject the call at the front of the queue
- */
-int rxrpc_reject_call(struct rxrpc_sock *rx)
-{
-	struct rxrpc_call *call;
-	bool abort = false;
-	int ret;
-
-	_enter("");
-
-	ASSERT(!irqs_disabled());
-
-	write_lock(&rx->call_lock);
-
-	if (list_empty(&rx->to_be_accepted)) {
-		write_unlock(&rx->call_lock);
-		return -ENODATA;
-	}
-
-	/* Dequeue the first call and check it's still valid.  We gain
-	 * responsibility for the queue's reference.
-	 */
-	call = list_entry(rx->to_be_accepted.next,
-			  struct rxrpc_call, accept_link);
-	list_del_init(&call->accept_link);
-	sk_acceptq_removed(&rx->sk);
-	rxrpc_see_call(call);
+	struct rxrpc_backlog *b = rx->backlog;
 
-	write_lock_bh(&call->state_lock);
-	switch (call->state) {
-	case RXRPC_CALL_SERVER_ACCEPTING:
-		__rxrpc_abort_call("REJ", call, 1, RX_USER_ABORT, -ECONNABORTED);
-		abort = true;
-		fallthrough;
-	case RXRPC_CALL_COMPLETE:
-		ret = call->error;
-		goto out_discard;
-	default:
-		BUG();
-	}
+	if (rx->sk.sk_state == RXRPC_CLOSE)
+		return -ESHUTDOWN;
 
-out_discard:
-	write_unlock_bh(&call->state_lock);
-	write_unlock(&rx->call_lock);
-	if (abort) {
-		rxrpc_send_abort_packet(call);
-		rxrpc_release_call(rx, call);
-		rxrpc_put_call(call, rxrpc_call_put);
-	}
-	rxrpc_service_prealloc(rx, GFP_KERNEL);
-	_leave(" = %d", ret);
-	return ret;
+	return rxrpc_service_prealloc_one(rx, b, NULL, NULL, user_call_ID,
+					  GFP_KERNEL,
+					  atomic_inc_return(&rxrpc_debug_id));
 }
 
 /*
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index c8015c76a81c..c845594b663f 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -23,7 +23,6 @@ const char *const rxrpc_call_states[NR__RXRPC_CALL_STATES] = {
 	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
 	[RXRPC_CALL_SERVER_PREALLOC]		= "SvPrealc",
 	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
-	[RXRPC_CALL_SERVER_ACCEPTING]		= "SvAccept",
 	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
 	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
 	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
@@ -393,9 +392,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	call->call_id		= sp->hdr.callNumber;
 	call->service_id	= sp->hdr.serviceId;
 	call->cid		= sp->hdr.cid;
-	call->state		= RXRPC_CALL_SERVER_ACCEPTING;
-	if (sp->hdr.securityIndex > 0)
-		call->state	= RXRPC_CALL_SERVER_SECURING;
+	call->state		= RXRPC_CALL_SERVER_SECURING;
 	call->cong_tstamp	= skb->tstamp;
 
 	/* Set the channel for this call.  We don't get channel_lock as we're
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index c1b64e1dfc4e..aff184145ffa 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -270,7 +270,7 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
 	if (call) {
 		write_lock_bh(&call->state_lock);
 		if (call->state == RXRPC_CALL_SERVER_SECURING) {
-			call->state = RXRPC_CALL_SERVER_ACCEPTING;
+			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
 			rxrpc_notify_socket(call);
 		}
 		write_unlock_bh(&call->state_lock);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index c4684dde1f16..2c842851d72e 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -178,37 +178,6 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 	return ret;
 }
 
-/*
- * Pass back notification of a new call.  The call is added to the
- * to-be-accepted list.  This means that the next call to be accepted might not
- * be the last call seen awaiting acceptance, but unless we leave this on the
- * front of the queue and block all other messages until someone gives us a
- * user_ID for it, there's not a lot we can do.
- */
-static int rxrpc_recvmsg_new_call(struct rxrpc_sock *rx,
-				  struct rxrpc_call *call,
-				  struct msghdr *msg, int flags)
-{
-	int tmp = 0, ret;
-
-	ret = put_cmsg(msg, SOL_RXRPC, RXRPC_NEW_CALL, 0, &tmp);
-
-	if (ret == 0 && !(flags & MSG_PEEK)) {
-		_debug("to be accepted");
-		write_lock_bh(&rx->recvmsg_lock);
-		list_del_init(&call->recvmsg_link);
-		write_unlock_bh(&rx->recvmsg_lock);
-
-		rxrpc_get_call(call, rxrpc_call_got);
-		write_lock(&rx->call_lock);
-		list_add_tail(&call->accept_link, &rx->to_be_accepted);
-		write_unlock(&rx->call_lock);
-	}
-
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_to_be_accepted, 1, 0, 0, ret);
-	return ret;
-}
-
 /*
  * End the packet reception phase.
  */
@@ -630,9 +599,6 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	}
 
 	switch (READ_ONCE(call->state)) {
-	case RXRPC_CALL_SERVER_ACCEPTING:
-		ret = rxrpc_recvmsg_new_call(rx, call, msg, flags);
-		break;
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
@@ -728,7 +694,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 	       call->debug_id, rxrpc_call_states[call->state],
 	       iov_iter_count(iter), want_more);
 
-	ASSERTCMP(call->state, !=, RXRPC_CALL_SERVER_ACCEPTING);
+	ASSERTCMP(call->state, !=, RXRPC_CALL_SERVER_SECURING);
 
 	mutex_lock(&call->user_mutex);
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 0824e103d037..d27140c836cc 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -530,10 +530,10 @@ static int rxrpc_sendmsg_cmsg(struct msghdr *msg, struct rxrpc_send_params *p)
 				return -EINVAL;
 			break;
 
-		case RXRPC_ACCEPT:
+		case RXRPC_CHARGE_ACCEPT:
 			if (p->command != RXRPC_CMD_SEND_DATA)
 				return -EINVAL;
-			p->command = RXRPC_CMD_ACCEPT;
+			p->command = RXRPC_CMD_CHARGE_ACCEPT;
 			if (len != 0)
 				return -EINVAL;
 			break;
@@ -659,16 +659,12 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	if (ret < 0)
 		goto error_release_sock;
 
-	if (p.command == RXRPC_CMD_ACCEPT) {
+	if (p.command == RXRPC_CMD_CHARGE_ACCEPT) {
 		ret = -EINVAL;
 		if (rx->sk.sk_state != RXRPC_SERVER_LISTENING)
 			goto error_release_sock;
-		call = rxrpc_accept_call(rx, p.call.user_call_ID, NULL);
-		/* The socket is now unlocked. */
-		if (IS_ERR(call))
-			return PTR_ERR(call);
-		ret = 0;
-		goto out_put_unlock;
+		ret = rxrpc_user_charge_accept(rx, p.call.user_call_ID);
+		goto error_release_sock;
 	}
 
 	call = rxrpc_find_call_by_user_ID(rx, p.call.user_call_ID);
@@ -690,7 +686,6 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
 		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
-		case RXRPC_CALL_SERVER_ACCEPTING:
 			rxrpc_put_call(call, rxrpc_call_put);
 			ret = -EBUSY;
 			goto error_release_sock;


