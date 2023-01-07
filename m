Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763D2660D90
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbjAGJ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbjAGJzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:55:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773C84633
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/pzfzoQoks9CVZvIXcjczM97qrw6Z3DoyVszHY01W0=;
        b=H9KPf9DiRi/N1O8tZVR2K/CdflR6akoN6hHOmrA3mL1Rj3pAnQFfh2ZLjlgsMijL8DK4ZP
        ikCYA1QCYiG82T7nsLHrjfWIudYkjIxh3gdE5/wKzPVmkuZPDjaMSGOZaPIK8LH06CvQ3a
        fET2s/8PkfNODkSlDH/AZIWj9hEAiIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-uSKDvUQxNYWRBoD7e8YL3Q-1; Sat, 07 Jan 2023 04:54:40 -0500
X-MC-Unique: uSKDvUQxNYWRBoD7e8YL3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19B09101A52E;
        Sat,  7 Jan 2023 09:54:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 333DA42238;
        Sat,  7 Jan 2023 09:54:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 16/19] rxrpc: Remove call->state_lock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:54:38 +0000
Message-ID: <167308527862.1538866.6683287154473536219.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the setters of call->state are now in the I/O thread and thus the state
lock is now unnecessary.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |   33 +++++++++++-----
 net/rxrpc/call_accept.c |    2 -
 net/rxrpc/call_event.c  |   42 ++++++++-------------
 net/rxrpc/call_object.c |   30 +++++++--------
 net/rxrpc/call_state.c  |   87 ++++++++++++++++---------------------------
 net/rxrpc/conn_client.c |   10 ++---
 net/rxrpc/conn_event.c  |   11 +----
 net/rxrpc/input.c       |   96 ++++++++++++++++++++---------------------------
 net/rxrpc/output.c      |    4 +-
 net/rxrpc/proc.c        |    6 ++-
 net/rxrpc/rxkad.c       |    2 -
 net/rxrpc/sendmsg.c     |    3 -
 12 files changed, 142 insertions(+), 184 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 861273439736..751b1903fd6e 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -631,14 +631,13 @@ struct rxrpc_call {
 	unsigned long		flags;
 	unsigned long		events;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
-	rwlock_t		state_lock;	/* lock for state transition */
 	unsigned int		send_abort_why; /* Why the abort [enum rxrpc_abort_reason] */
 	s32			send_abort;	/* Abort code to be sent */
 	short			send_abort_err;	/* Error to be associated with the abort */
 	rxrpc_seq_t		send_abort_seq;	/* DATA packet that incurred the abort (or 0) */
 	s32			abort_code;	/* Local/remote abort code */
 	int			error;		/* Local error incurred */
-	enum rxrpc_call_state	state;		/* current state of call */
+	enum rxrpc_call_state	_state;		/* Current state of call (needs barrier) */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
 	refcount_t		ref;
 	u8			security_ix;	/* Security type */
@@ -889,25 +888,37 @@ static inline bool rxrpc_is_client_call(const struct rxrpc_call *call)
 /*
  * call_state.c
  */
-bool __rxrpc_set_call_completion(struct rxrpc_call *call,
-				 enum rxrpc_call_completion compl,
-				 u32 abort_code,
-				 int error);
 bool rxrpc_set_call_completion(struct rxrpc_call *call,
 			       enum rxrpc_call_completion compl,
 			       u32 abort_code,
 			       int error);
-bool __rxrpc_call_completed(struct rxrpc_call *call);
 bool rxrpc_call_completed(struct rxrpc_call *call);
-bool __rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
-			u32 abort_code, int error, enum rxrpc_abort_reason why);
 bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
 		      u32 abort_code, int error, enum rxrpc_abort_reason why);
+void rxrpc_prefail_call(struct rxrpc_call *call, enum rxrpc_call_completion compl,
+			int error);
+
+static inline void rxrpc_set_call_state(struct rxrpc_call *call,
+					enum rxrpc_call_state state)
+{
+	/* Order write of completion info before write of ->state. */
+	smp_store_release(&call->_state, state);
+}
+
+static inline enum rxrpc_call_state __rxrpc_call_state(const struct rxrpc_call *call)
+{
+	return call->_state; /* Only inside I/O thread */
+}
+
+static inline bool __rxrpc_call_is_complete(const struct rxrpc_call *call)
+{
+	return __rxrpc_call_state(call) == RXRPC_CALL_COMPLETE;
+}
 
 static inline enum rxrpc_call_state rxrpc_call_state(const struct rxrpc_call *call)
 {
-	/* Order read ->state before read ->error. */
-	return smp_load_acquire(&call->state);
+	/* Order read ->state before read of completion info. */
+	return smp_load_acquire(&call->_state);
 }
 
 static inline bool rxrpc_call_is_complete(const struct rxrpc_call *call)
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index a132d486dea0..3fbf2fcaaf9e 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -99,7 +99,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	if (!call)
 		return -ENOMEM;
 	call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
-	call->state = RXRPC_CALL_SERVER_PREALLOC;
+	rxrpc_set_call_state(call, RXRPC_CALL_SERVER_PREALLOC);
 	__set_bit(RXRPC_CALL_EV_INITIAL_PING, &call->events);
 
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 2e3c01060d59..1abdef15debc 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -257,20 +257,13 @@ void rxrpc_resend(struct rxrpc_call *call, struct sk_buff *ack_skb)
  */
 static void rxrpc_begin_service_reply(struct rxrpc_call *call)
 {
-	unsigned long now;
-
-	write_lock(&call->state_lock);
-
-	if (call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
-		now = jiffies;
-		call->state = RXRPC_CALL_SERVER_SEND_REPLY;
-		WRITE_ONCE(call->delay_ack_at, now + MAX_JIFFY_OFFSET);
-		if (call->ackr_reason == RXRPC_ACK_DELAY)
-			call->ackr_reason = 0;
-		trace_rxrpc_timer(call, rxrpc_timer_init_for_send_reply, now);
-	}
+	unsigned long now = jiffies;
 
-	write_unlock(&call->state_lock);
+	rxrpc_set_call_state(call, RXRPC_CALL_SERVER_SEND_REPLY);
+	WRITE_ONCE(call->delay_ack_at, now + MAX_JIFFY_OFFSET);
+	if (call->ackr_reason == RXRPC_ACK_DELAY)
+		call->ackr_reason = 0;
+	trace_rxrpc_timer(call, rxrpc_timer_init_for_send_reply, now);
 }
 
 /*
@@ -281,18 +274,16 @@ static void rxrpc_close_tx_phase(struct rxrpc_call *call)
 {
 	_debug("________awaiting reply/ACK__________");
 
-	write_lock(&call->state_lock);
-	switch (call->state) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
-		call->state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
+		rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_AWAIT_REPLY);
 		break;
 	case RXRPC_CALL_SERVER_SEND_REPLY:
-		call->state = RXRPC_CALL_SERVER_AWAIT_ACK;
+		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_AWAIT_ACK);
 		break;
 	default:
 		break;
 	}
-	write_unlock(&call->state_lock);
 }
 
 static bool rxrpc_tx_window_has_space(struct rxrpc_call *call)
@@ -341,7 +332,7 @@ static void rxrpc_decant_prepared_tx(struct rxrpc_call *call)
 
 static void rxrpc_transmit_some_data(struct rxrpc_call *call)
 {
-	switch (call->state) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 		if (list_empty(&call->tx_sendmsg))
 			return;
@@ -390,9 +381,10 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 
 	//printk("\n--------------------\n");
 	_enter("{%d,%s,%lx}",
-	       call->debug_id, rxrpc_call_states[call->state], call->events);
+	       call->debug_id, rxrpc_call_states[__rxrpc_call_state(call)],
+	       call->events);
 
-	if (call->state == RXRPC_CALL_COMPLETE)
+	if (__rxrpc_call_is_complete(call))
 		goto out;
 
 	/* Handle abort request locklessly, vs rxrpc_propose_abort(). */
@@ -415,7 +407,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	t = READ_ONCE(call->expect_req_by);
-	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST &&
+	if (__rxrpc_call_state(call) == RXRPC_CALL_SERVER_RECV_REQUEST &&
 	    time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_idle, now);
 		expired = true;
@@ -499,7 +491,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
 			       rxrpc_propose_ack_ping_for_lost_ack);
 
-	if (resend && call->state != RXRPC_CALL_CLIENT_RECV_REPLY)
+	if (resend && __rxrpc_call_state(call) != RXRPC_CALL_CLIENT_RECV_REPLY)
 		rxrpc_resend(call, NULL);
 
 	if (test_and_clear_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags))
@@ -511,7 +503,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 			       rxrpc_propose_ack_input_data);
 
 	/* Make sure the timer is restarted */
-	if (call->state != RXRPC_CALL_COMPLETE) {
+	if (!__rxrpc_call_is_complete(call)) {
 		next = call->expect_rx_by;
 
 #define set(T) { t = READ_ONCE(T); if (time_before(t, next)) next = t; }
@@ -532,7 +524,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 out:
-	if (call->state == RXRPC_CALL_COMPLETE) {
+	if (__rxrpc_call_is_complete(call)) {
 		del_timer_sync(&call->timer);
 		if (!test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 			rxrpc_disconnect_call(call);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 835e9781afc6..c94161acf3c4 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -69,7 +69,7 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 
 	_enter("%d", call->debug_id);
 
-	if (call->state < RXRPC_CALL_COMPLETE) {
+	if (!__rxrpc_call_is_complete(call)) {
 		trace_rxrpc_timer_expired(call, jiffies);
 		rxrpc_poke_call(call, rxrpc_call_poke_timer);
 	}
@@ -162,7 +162,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
-	rwlock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
 	call->tx_total_len = -1;
@@ -211,7 +210,6 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 	now = ktime_get_real();
 	call->acks_latest_ts	= now;
 	call->cong_tstamp	= now;
-	call->state		= RXRPC_CALL_CLIENT_AWAIT_CONN;
 	call->dest_srx		= *srx;
 	call->interruptibility	= p->interruptibility;
 	call->tx_total_len	= p->tx_total_len;
@@ -227,11 +225,13 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 
 	ret = rxrpc_init_client_call_security(call);
 	if (ret < 0) {
-		__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
+		rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, ret);
 		rxrpc_put_call(call, rxrpc_call_put_discard_error);
 		return ERR_PTR(ret);
 	}
 
+	rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_AWAIT_CONN);
+
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
 			 p->user_call_ID, rxrpc_call_new_client);
 
@@ -384,8 +384,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 error_dup_user_ID:
 	write_unlock(&rx->call_lock);
 	release_sock(&rx->sk);
-	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
-				    RX_CALL_DEAD, -EEXIST);
+	rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, -EEXIST);
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), 0,
 			 rxrpc_call_see_userid_exists);
 	rxrpc_release_call(rx, call);
@@ -403,8 +402,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), ret,
 			 rxrpc_call_see_connect_failed);
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
-	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
-				    RX_CALL_DEAD, ret);
+	rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, ret);
 	_leave(" = c=%08x [err]", call->debug_id);
 	return call;
 }
@@ -427,25 +425,25 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	call->call_id		= sp->hdr.callNumber;
 	call->dest_srx.srx_service = sp->hdr.serviceId;
 	call->cid		= sp->hdr.cid;
-	call->state		= RXRPC_CALL_SERVER_SECURING;
 	call->cong_tstamp	= skb->tstamp;
 
 	__set_bit(RXRPC_CALL_EXPOSED, &call->flags);
+	rxrpc_set_call_state(call, RXRPC_CALL_SERVER_SECURING);
 
 	spin_lock(&conn->state_lock);
 
 	switch (conn->state) {
 	case RXRPC_CONN_SERVICE_UNSECURED:
 	case RXRPC_CONN_SERVICE_CHALLENGING:
-		call->state = RXRPC_CALL_SERVER_SECURING;
+		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_SECURING);
 		break;
 	case RXRPC_CONN_SERVICE:
-		call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
+		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_RECV_REQUEST);
 		break;
 
 	case RXRPC_CONN_ABORTED:
-		__rxrpc_set_call_completion(call, conn->completion,
-					    conn->abort_code, conn->error);
+		rxrpc_set_call_completion(call, conn->completion,
+					  conn->abort_code, conn->error);
 		break;
 	default:
 		BUG();
@@ -614,7 +612,7 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 	dead = __refcount_dec_and_test(&call->ref, &r);
 	trace_rxrpc_call(debug_id, r - 1, 0, why);
 	if (dead) {
-		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
+		ASSERTCMP(__rxrpc_call_state(call), ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
 			spin_lock(&rxnet->call_lock);
@@ -677,7 +675,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 {
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
-	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
+	ASSERTCMP(__rxrpc_call_state(call), ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 
 	del_timer(&call->timer);
@@ -715,7 +713,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
 			       call, refcount_read(&call->ref),
-			       rxrpc_call_states[call->state],
+			       rxrpc_call_states[__rxrpc_call_state(call)],
 			       call->flags, call->events);
 
 			spin_unlock(&rxnet->call_lock);
diff --git a/net/rxrpc/call_state.c b/net/rxrpc/call_state.c
index 649fb9e5d1af..27dc1242b712 100644
--- a/net/rxrpc/call_state.c
+++ b/net/rxrpc/call_state.c
@@ -10,81 +10,60 @@
 /*
  * Transition a call to the complete state.
  */
-bool __rxrpc_set_call_completion(struct rxrpc_call *call,
+bool rxrpc_set_call_completion(struct rxrpc_call *call,
 				 enum rxrpc_call_completion compl,
 				 u32 abort_code,
 				 int error)
 {
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		call->abort_code = abort_code;
-		call->error = error;
-		call->completion = compl;
-		/* Allow reader of completion state to operate locklessly */
-		smp_store_release(&call->state, RXRPC_CALL_COMPLETE);
-		trace_rxrpc_call_complete(call);
-		wake_up(&call->waitq);
-		rxrpc_notify_socket(call);
-		return true;
-	}
-	return false;
-}
-
-bool rxrpc_set_call_completion(struct rxrpc_call *call,
-			       enum rxrpc_call_completion compl,
-			       u32 abort_code,
-			       int error)
-{
-	bool ret = false;
+	if (__rxrpc_call_state(call) == RXRPC_CALL_COMPLETE)
+		return false;
 
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock(&call->state_lock);
-		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
-		write_unlock(&call->state_lock);
-	}
-	return ret;
+	call->abort_code = abort_code;
+	call->error = error;
+	call->completion = compl;
+	/* Allow reader of completion state to operate locklessly */
+	rxrpc_set_call_state(call, RXRPC_CALL_COMPLETE);
+	trace_rxrpc_call_complete(call);
+	wake_up(&call->waitq);
+	rxrpc_notify_socket(call);
+	return true;
 }
 
 /*
  * Record that a call successfully completed.
  */
-bool __rxrpc_call_completed(struct rxrpc_call *call)
-{
-	return __rxrpc_set_call_completion(call, RXRPC_CALL_SUCCEEDED, 0, 0);
-}
-
 bool rxrpc_call_completed(struct rxrpc_call *call)
 {
-	bool ret = false;
-
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock(&call->state_lock);
-		ret = __rxrpc_call_completed(call);
-		write_unlock(&call->state_lock);
-	}
-	return ret;
+	return rxrpc_set_call_completion(call, RXRPC_CALL_SUCCEEDED, 0, 0);
 }
 
 /*
  * Record that a call is locally aborted.
  */
-bool __rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
-			u32 abort_code, int error, enum rxrpc_abort_reason why)
+bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
+		      u32 abort_code, int error, enum rxrpc_abort_reason why)
 {
 	trace_rxrpc_abort(call->debug_id, why, call->cid, call->call_id, seq,
 			  abort_code, error);
-	return __rxrpc_set_call_completion(call, RXRPC_CALL_LOCALLY_ABORTED,
-					   abort_code, error);
+	if (!rxrpc_set_call_completion(call, RXRPC_CALL_LOCALLY_ABORTED,
+				       abort_code, error))
+		return false;
+	if (test_bit(RXRPC_CALL_EXPOSED, &call->flags))
+		rxrpc_send_abort_packet(call);
+	return true;
 }
 
-bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
-		      u32 abort_code, int error, enum rxrpc_abort_reason why)
+/*
+ * Record that a call errored out before even getting off the ground, thereby
+ * setting the state to allow it to be destroyed.
+ */
+void rxrpc_prefail_call(struct rxrpc_call *call, enum rxrpc_call_completion compl,
+			int error)
 {
-	bool ret;
-
-	write_lock(&call->state_lock);
-	ret = __rxrpc_abort_call(call, seq, abort_code, error, why);
-	write_unlock(&call->state_lock);
-	if (ret && test_bit(RXRPC_CALL_EXPOSED, &call->flags))
-		rxrpc_send_abort_packet(call);
-	return ret;
+	call->abort_code	= RX_CALL_DEAD;
+	call->error		= error;
+	call->completion	= compl;
+	call->_state		= RXRPC_CALL_COMPLETE;
+	trace_rxrpc_call_complete(call);
+	__set_bit(RXRPC_CALL_RELEASED, &call->flags);
 }
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index c0db7722571e..8b5ea68dc47e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -553,9 +553,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	trace_rxrpc_connect_call(call);
 
-	write_lock(&call->state_lock);
-	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
-	write_unlock(&call->state_lock);
+	rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_SEND_REQUEST);
 
 	/* Paired with the read barrier in rxrpc_connect_call().  This orders
 	 * cid and epoch in the connection wrt to call_id without the need to
@@ -687,7 +685,7 @@ static int rxrpc_wait_for_channel(struct rxrpc_bundle *bundle,
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			break;
 		}
-		if (READ_ONCE(call->state) != RXRPC_CALL_CLIENT_AWAIT_CONN)
+		if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN)
 			break;
 		if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
 		     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
@@ -729,7 +727,7 @@ int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 		goto out;
 	}
 
-	if (call->state == RXRPC_CALL_CLIENT_AWAIT_CONN) {
+	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_AWAIT_CONN) {
 		ret = rxrpc_wait_for_channel(bundle, call, gfp);
 		if (ret < 0)
 			goto wait_failed;
@@ -748,7 +746,7 @@ int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 	list_del_init(&call->chan_wait_link);
 	spin_unlock(&bundle->channel_lock);
 
-	if (call->state != RXRPC_CALL_CLIENT_AWAIT_CONN) {
+	if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN) {
 		ret = 0;
 		goto granted_channel;
 	}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index b2042702ca9a..8d0b9ff0a5e1 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -230,14 +230,9 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn)
  */
 static void rxrpc_call_is_secure(struct rxrpc_call *call)
 {
-	_enter("%p", call);
-	if (call) {
-		write_lock(&call->state_lock);
-		if (call->state == RXRPC_CALL_SERVER_SECURING) {
-			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
-			rxrpc_notify_socket(call);
-		}
-		write_unlock(&call->state_lock);
+	if (call && __rxrpc_call_state(call) == RXRPC_CALL_SERVER_SECURING) {
+		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_RECV_REQUEST);
+		rxrpc_notify_socket(call);
 	}
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 6eb21425f41f..367927a99881 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -184,7 +184,7 @@ void rxrpc_congestion_degrade(struct rxrpc_call *call)
 	if (call->cong_mode != RXRPC_CALL_SLOW_START &&
 	    call->cong_mode != RXRPC_CALL_CONGEST_AVOIDANCE)
 		return;
-	if (call->state == RXRPC_CALL_CLIENT_AWAIT_REPLY)
+	if (__rxrpc_call_state(call) == RXRPC_CALL_CLIENT_AWAIT_REPLY)
 		return;
 
 	rtt = ns_to_ktime(call->peer->srtt_us * (1000 / 8));
@@ -252,43 +252,31 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 static void rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 			       enum rxrpc_abort_reason abort_why)
 {
-	unsigned int state;
-
 	ASSERT(test_bit(RXRPC_CALL_TX_LAST, &call->flags));
 
-	write_lock(&call->state_lock);
-
-	state = call->state;
-	switch (state) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
 	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
-		if (reply_begun)
-			call->state = state = RXRPC_CALL_CLIENT_RECV_REPLY;
-		else
-			call->state = state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
+		if (reply_begun) {
+			rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_RECV_REPLY);
+			trace_rxrpc_txqueue(call, rxrpc_txqueue_end);
+			break;
+		}
+
+		rxrpc_set_call_state(call, RXRPC_CALL_CLIENT_AWAIT_REPLY);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_await_reply);
 		break;
 
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
-		__rxrpc_call_completed(call);
-		state = call->state;
+		rxrpc_call_completed(call);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_end);
 		break;
 
 	default:
-		goto bad_state;
+		kdebug("end_tx %s", rxrpc_call_states[__rxrpc_call_state(call)]);
+		rxrpc_proto_abort(call, call->tx_top, abort_why);
+		break;
 	}
-
-	write_unlock(&call->state_lock);
-	if (state == RXRPC_CALL_CLIENT_AWAIT_REPLY)
-		trace_rxrpc_txqueue(call, rxrpc_txqueue_await_reply);
-	else
-		trace_rxrpc_txqueue(call, rxrpc_txqueue_end);
-	_leave(" = ok");
-	return;
-
-bad_state:
-	write_unlock(&call->state_lock);
-	kdebug("end_tx %s", rxrpc_call_states[call->state]);
-	rxrpc_proto_abort(call, call->tx_top, abort_why);
 }
 
 /*
@@ -303,7 +291,7 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 	if (call->ackr_reason) {
 		now = jiffies;
 		timo = now + MAX_JIFFY_OFFSET;
-		WRITE_ONCE(call->resend_at, timo);
+
 		WRITE_ONCE(call->delay_ack_at, timo);
 		trace_rxrpc_timer(call, rxrpc_timer_init_for_reply, now);
 	}
@@ -326,30 +314,23 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 {
 	rxrpc_seq_t whigh = READ_ONCE(call->rx_highest_seq);
 
-	_enter("%d,%s", call->debug_id, rxrpc_call_states[call->state]);
+	_enter("%d,%s", call->debug_id, rxrpc_call_states[__rxrpc_call_state(call)]);
 
 	trace_rxrpc_receive(call, rxrpc_receive_end, 0, whigh);
 
-	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_RECV_REPLY)
-		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
-
-	write_lock(&call->state_lock);
-
-	switch (call->state) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
-		__rxrpc_call_completed(call);
-		write_unlock(&call->state_lock);
+		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
+		rxrpc_call_completed(call);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
-		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
+		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_ACK_REQUEST);
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
-		write_unlock(&call->state_lock);
-		rxrpc_propose_delay_ACK(call, serial,
-					rxrpc_propose_ack_processing_op);
+		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_processing_op);
 		break;
+
 	default:
-		write_unlock(&call->state_lock);
 		break;
 	}
 }
@@ -583,7 +564,6 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	enum rxrpc_call_state state;
 	rxrpc_serial_t serial = sp->hdr.serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq;
 
@@ -591,11 +571,20 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	       atomic64_read(&call->ackr_window), call->rx_highest_seq,
 	       skb->len, seq0);
 
-	state = READ_ONCE(call->state);
-	if (state >= RXRPC_CALL_COMPLETE)
+	if (__rxrpc_call_is_complete(call))
 		return;
 
-	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
+	switch (__rxrpc_call_state(call)) {
+	case RXRPC_CALL_CLIENT_SEND_REQUEST:
+	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
+		/* Received data implicitly ACKs all of the request
+		 * packets we sent when we're acting as a client.
+		 */
+		if (!rxrpc_receiving_reply(call))
+			goto out_notify;
+		break;
+
+	case RXRPC_CALL_SERVER_RECV_REQUEST: {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
 
@@ -606,15 +595,12 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			rxrpc_reduce_call_timer(call, expect_req_by, now,
 						rxrpc_timer_set_for_idle);
 		}
+		break;
 	}
 
-	/* Received data implicitly ACKs all of the request packets we sent
-	 * when we're acting as a client.
-	 */
-	if ((state == RXRPC_CALL_CLIENT_SEND_REQUEST ||
-	     state == RXRPC_CALL_CLIENT_AWAIT_REPLY) &&
-	    !rxrpc_receiving_reply(call))
-		goto out_notify;
+	default:
+		break;
+	}
 
 	if (!rxrpc_input_split_jumbo(call, skb)) {
 		rxrpc_proto_abort(call, sp->hdr.seq, rxrpc_badmsg_bad_jumbo);
@@ -904,7 +890,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		return rxrpc_proto_abort(call, 0, rxrpc_eproto_ackr_zero);
 
 	/* Ignore ACKs unless we are or have just been transmitting. */
-	switch (READ_ONCE(call->state)) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
 	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
@@ -1027,7 +1013,7 @@ void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
  */
 void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 {
-	switch (READ_ONCE(call->state)) {
+	switch (__rxrpc_call_state(call)) {
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		rxrpc_call_completed(call);
 		fallthrough;
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 8a5ff2c9e061..a9746be29634 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -261,7 +261,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 				      rxrpc_tx_point_call_ack);
 	rxrpc_tx_backoff(call, ret);
 
-	if (call->state < RXRPC_CALL_COMPLETE) {
+	if (!__rxrpc_call_is_complete(call)) {
 		if (ret < 0)
 			rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		rxrpc_set_keepalive(call);
@@ -723,7 +723,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *peer)
 static inline void rxrpc_instant_resend(struct rxrpc_call *call,
 					struct rxrpc_txbuf *txb)
 {
-	if (call->state < RXRPC_CALL_COMPLETE)
+	if (!__rxrpc_call_is_complete(call))
 		kdebug("resend");
 }
 
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 63947cce4048..c39ef94602ed 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -50,6 +50,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_local *local;
 	struct rxrpc_call *call;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+	enum rxrpc_call_state state;
 	unsigned long timeout = 0;
 	rxrpc_seq_t acks_hard_ack;
 	char lbuff[50], rbuff[50];
@@ -74,7 +75,8 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
 	sprintf(rbuff, "%pISpc", &call->dest_srx.transport);
 
-	if (call->state != RXRPC_CALL_SERVER_PREALLOC) {
+	state = rxrpc_call_state(call);
+	if (state != RXRPC_CALL_SERVER_PREALLOC) {
 		timeout = READ_ONCE(call->expect_rx_by);
 		timeout -= jiffies;
 	}
@@ -91,7 +93,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->call_id,
 		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
 		   refcount_read(&call->ref),
-		   rxrpc_call_states[call->state],
+		   rxrpc_call_states[state],
 		   call->abort_code,
 		   call->debug_id,
 		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index e52cb8058156..dfb01e7b90fb 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1143,7 +1143,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 			call = rcu_dereference_protected(
 				conn->channels[i].call,
 				lockdep_is_held(&conn->bundle->channel_lock));
-			if (call && call->state < RXRPC_CALL_COMPLETE) {
+			if (call && !__rxrpc_call_is_complete(call)) {
 				rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
 						 rxkad_abort_resp_call_state);
 				goto protocol_error_unlock;
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 0428528abbf4..a5d0005b7ce5 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -702,9 +702,6 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 
 	mutex_lock(&call->user_mutex);
 
-	_debug("CALL %d USR %lx ST %d on CONN %p",
-	       call->debug_id, call->user_call_ID, call->state, call->conn);
-
 	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
 			      notify_end_tx, &dropped_lock);
 	if (ret == -ESHUTDOWN)


