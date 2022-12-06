Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E005D644886
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiLFQBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiLFQAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:00:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653F9286ED
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=el1eJH3pKHyw7YaqmJGn3ZCvlJHOAyoKsmcdLN1455w=;
        b=cHWrkFTNN8r4mJtdmUkXf2JySRzPWzflUHGHKHFA86bV1MC8vY+7Y0Ne+Bp1oalOASngMg
        AqsbgDRtFHx8cv9X4oJJZ5KBUwyoUgX5gfAmd1wfM/qgog7gq9YuQAI0i9C7XAlDilAAWu
        Quq9JcFadj5aipLa+eY3tCmOEPPttT8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-9_jGAE6tMfqgPdn8KrQvTg-1; Tue, 06 Dec 2022 10:59:29 -0500
X-MC-Unique: 9_jGAE6tMfqgPdn8KrQvTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B417D858F13;
        Tue,  6 Dec 2022 15:59:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0067F140EBF5;
        Tue,  6 Dec 2022 15:59:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 06/32] rxrpc: Convert call->state_lock to a spinlock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:25 +0000
Message-ID: <167034236532.1105287.7206596176961982004.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert call->state_lock to a spinlock and use a barrier on it when setting
the completion state.  The only readers can then be made to read it
locklessly.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    2 +-
 net/rxrpc/call_object.c |    2 +-
 net/rxrpc/conn_client.c |    4 ++--
 net/rxrpc/conn_event.c  |    4 ++--
 net/rxrpc/input.c       |    6 +++---
 net/rxrpc/recvmsg.c     |   23 ++++++++++++-----------
 net/rxrpc/sendmsg.c     |   17 ++++++-----------
 7 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 423f2e1eddb3..755395d1f2ca 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -622,7 +622,7 @@ struct rxrpc_call {
 	unsigned long		flags;
 	unsigned long		events;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
-	rwlock_t		state_lock;	/* lock for state transition */
+	spinlock_t		state_lock;	/* lock for state transition */
 	u32			abort_code;	/* Local/remote abort code */
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 36cc868b8922..07abf12e99bb 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -162,7 +162,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
-	rwlock_init(&call->state_lock);
+	spin_lock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
 	call->tx_total_len = -1;
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 87efa0373aed..ec8913de42c9 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -555,9 +555,9 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	trace_rxrpc_connect_call(call);
 
-	write_lock(&call->state_lock);
+	spin_lock(&call->state_lock);
 	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
-	write_unlock(&call->state_lock);
+	spin_unlock(&call->state_lock);
 
 	/* Paired with the read barrier in rxrpc_connect_call().  This orders
 	 * cid and epoch in the connection wrt to call_id without the need to
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index dfd29882126f..f05d58636307 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -265,12 +265,12 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
 {
 	_enter("%p", call);
 	if (call) {
-		write_lock(&call->state_lock);
+		spin_lock(&call->state_lock);
 		if (call->state == RXRPC_CALL_SERVER_SECURING) {
 			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
 			rxrpc_notify_socket(call);
 		}
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 	}
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dbd92f09c2ca..3b2e8e7d2e0f 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -257,7 +257,7 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 
 	ASSERT(test_bit(RXRPC_CALL_TX_LAST, &call->flags));
 
-	write_lock(&call->state_lock);
+	spin_lock(&call->state_lock);
 
 	state = call->state;
 	switch (state) {
@@ -278,7 +278,7 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 		goto bad_state;
 	}
 
-	write_unlock(&call->state_lock);
+	spin_unlock(&call->state_lock);
 	if (state == RXRPC_CALL_CLIENT_AWAIT_REPLY)
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_await_reply);
 	else
@@ -287,7 +287,7 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 	return true;
 
 bad_state:
-	write_unlock(&call->state_lock);
+	spin_unlock(&call->state_lock);
 	kdebug("end_tx %s", rxrpc_call_states[call->state]);
 	rxrpc_proto_abort(abort_why, call, call->tx_top);
 	return false;
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 0cde2b477711..a9c9b2a8a27a 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -70,7 +70,8 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *call,
 		call->abort_code = abort_code;
 		call->error = error;
 		call->completion = compl;
-		call->state = RXRPC_CALL_COMPLETE;
+		/* Allow reader of completion state to operate locklessly */
+		smp_store_release(&call->state, RXRPC_CALL_COMPLETE);
 		trace_rxrpc_call_complete(call);
 		wake_up(&call->waitq);
 		rxrpc_notify_socket(call);
@@ -87,9 +88,9 @@ bool rxrpc_set_call_completion(struct rxrpc_call *call,
 	bool ret = false;
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock(&call->state_lock);
+		spin_lock(&call->state_lock);
 		ret = __rxrpc_set_call_completion(call, compl, abort_code, error);
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 	}
 	return ret;
 }
@@ -107,9 +108,9 @@ bool rxrpc_call_completed(struct rxrpc_call *call)
 	bool ret = false;
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
-		write_lock(&call->state_lock);
+		spin_lock(&call->state_lock);
 		ret = __rxrpc_call_completed(call);
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 	}
 	return ret;
 }
@@ -131,9 +132,9 @@ bool rxrpc_abort_call(const char *why, struct rxrpc_call *call,
 {
 	bool ret;
 
-	write_lock(&call->state_lock);
+	spin_lock(&call->state_lock);
 	ret = __rxrpc_abort_call(why, call, seq, abort_code, error);
-	write_unlock(&call->state_lock);
+	spin_unlock(&call->state_lock);
 	return ret;
 }
 
@@ -193,23 +194,23 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY)
 		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
 
-	write_lock(&call->state_lock);
+	spin_lock(&call->state_lock);
 
 	switch (call->state) {
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 		__rxrpc_call_completed(call);
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 		rxrpc_propose_delay_ACK(call, serial,
 					rxrpc_propose_ack_processing_op);
 		break;
 	default:
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 		break;
 	}
 }
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index cde1e65f16b4..816c1b083a69 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -195,7 +195,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 
 	if (last || call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
 		_debug("________awaiting reply/ACK__________");
-		write_lock(&call->state_lock);
+		spin_lock(&call->state_lock);
 		switch (call->state) {
 		case RXRPC_CALL_CLIENT_SEND_REQUEST:
 			call->state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
@@ -218,7 +218,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		default:
 			break;
 		}
-		write_unlock(&call->state_lock);
+		spin_unlock(&call->state_lock);
 	}
 
 	if (poke)
@@ -354,12 +354,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
-	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
-		read_lock(&call->state_lock);
-		if (call->error < 0)
-			ret = call->error;
-		read_unlock(&call->state_lock);
-	}
+	if (smp_load_acquire(&call->state) == RXRPC_CALL_COMPLETE &&
+	    call->error < 0)
+		ret = call->error;
 out:
 	call->tx_pending = txb;
 	_leave(" = %d", ret);
@@ -715,7 +712,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	_debug("CALL %d USR %lx ST %d on CONN %p",
 	       call->debug_id, call->user_call_ID, call->state, call->conn);
 
-	switch (READ_ONCE(call->state)) {
+	switch (smp_load_acquire(&call->state)) {
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
@@ -723,9 +720,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 				      notify_end_tx, &dropped_lock);
 		break;
 	case RXRPC_CALL_COMPLETE:
-		read_lock(&call->state_lock);
 		ret = call->error;
-		read_unlock(&call->state_lock);
 		break;
 	default:
 		/* Request phase complete for this client call */


