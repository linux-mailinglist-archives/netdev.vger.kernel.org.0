Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F69655017
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiLWMEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiLWMC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:02:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B1844940
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PgrmfjXeWEeD5sELunlv02gveJigfLaS+2uTka5ehoc=;
        b=Hur2cg0M5fMb8XgJzA2opRzuRijY96s0Ue11J0T4cq1PDaXgOl4f41AfAWXK7O3dI2OdJp
        u5keeMahVknqyKhmRuaiMGAwSnFEvofl2CWY2XxlZjjmL0P10G8pli0SD5qYnHpEYBAgjU
        pAuer0enjOqQddQZ5M+4hBmFuFnYMWQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-XfIKoIS2Mie4IuExMX3HAQ-1; Fri, 23 Dec 2022 07:01:32 -0500
X-MC-Unique: XfIKoIS2Mie4IuExMX3HAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B3D811E6E;
        Fri, 23 Dec 2022 12:01:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2629540C2064;
        Fri, 23 Dec 2022 12:01:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 14/19] rxrpc: Wrap accesses to get call state to put
 the barrier in one place
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 12:01:30 +0000
Message-ID: <167179689059.2516210.8408335203131711858.stgit@warthog.procyon.org.uk>
In-Reply-To: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
References: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap accesses to get the state of a call from outside of the I/O thread in
a single place so that the barrier needed to order wrt the error code and
abort code is in just that place.

Also use a barrier when setting the call state and again when reading the
call state such that the auxiliary completion info (error code, abort code)
can be read without taking a read lock on the call state lock.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c    |    2 +-
 net/rxrpc/ar-internal.h |   16 ++++++++++++++++
 net/rxrpc/call_state.c  |    3 ++-
 net/rxrpc/recvmsg.c     |   12 ++++++------
 net/rxrpc/sendmsg.c     |   29 +++++++++++++----------------
 5 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index f4e1ffff2ba4..61c30d0f6735 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(rxrpc_kernel_end_call);
 bool rxrpc_kernel_check_life(const struct socket *sock,
 			     const struct rxrpc_call *call)
 {
-	return call->state != RXRPC_CALL_COMPLETE;
+	return !rxrpc_call_is_complete(call);
 }
 EXPORT_SYMBOL(rxrpc_kernel_check_life);
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 4eb721f1d0f2..20fe1467de55 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -893,6 +893,22 @@ bool rxrpc_call_completed(struct rxrpc_call *);
 bool __rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
 bool rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
 
+static inline enum rxrpc_call_state rxrpc_call_state(const struct rxrpc_call *call)
+{
+	/* Order read ->state before read ->error. */
+	return smp_load_acquire(&call->state);
+}
+
+static inline bool rxrpc_call_is_complete(const struct rxrpc_call *call)
+{
+	return rxrpc_call_state(call) == RXRPC_CALL_COMPLETE;
+}
+
+static inline bool rxrpc_call_has_failed(const struct rxrpc_call *call)
+{
+	return rxrpc_call_is_complete(call) && call->completion != RXRPC_CALL_SUCCEEDED;
+}
+
 /*
  * conn_client.c
  */
diff --git a/net/rxrpc/call_state.c b/net/rxrpc/call_state.c
index 62259837d609..d72874237c3f 100644
--- a/net/rxrpc/call_state.c
+++ b/net/rxrpc/call_state.c
@@ -19,7 +19,8 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *call,
 		call->abort_code = abort_code;
 		call->error = error;
 		call->completion = compl;
-		call->state = RXRPC_CALL_COMPLETE;
+		/* Allow reader of completion state to operate locklessly */
+		smp_store_release(&call->state, RXRPC_CALL_COMPLETE);
 		trace_rxrpc_call_complete(call);
 		wake_up(&call->waitq);
 		rxrpc_notify_socket(call);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index ff08f917ecda..7bf36a8839ec 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -89,7 +89,7 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 		ret = put_cmsg(msg, SOL_RXRPC, RXRPC_LOCAL_ERROR, 4, &tmp);
 		break;
 	default:
-		pr_err("Invalid terminal call state %u\n", call->state);
+		pr_err("Invalid terminal call state %u\n", call->completion);
 		BUG();
 		break;
 	}
@@ -111,7 +111,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 
 	trace_rxrpc_receive(call, rxrpc_receive_end, 0, whigh);
 
-	if (call->state == RXRPC_CALL_CLIENT_RECV_REPLY)
+	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_RECV_REPLY)
 		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
 
 	write_lock(&call->state_lock);
@@ -210,7 +210,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
 
-	if (call->state >= RXRPC_CALL_SERVER_ACK_REQUEST) {
+	if (rxrpc_call_state(call) >= RXRPC_CALL_SERVER_ACK_REQUEST) {
 		seq = lower_32_bits(atomic64_read(&call->ackr_window)) - 1;
 		ret = 1;
 		goto done;
@@ -416,7 +416,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		msg->msg_namelen = len;
 	}
 
-	switch (READ_ONCE(call->state)) {
+	switch (rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
@@ -436,7 +436,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (ret < 0)
 		goto error_unlock_call;
 
-	if (call->state == RXRPC_CALL_COMPLETE) {
+	if (rxrpc_call_is_complete(call)) {
 		ret = rxrpc_recvmsg_term(call, msg);
 		if (ret < 0)
 			goto error_unlock_call;
@@ -516,7 +516,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 
 	mutex_lock(&call->user_mutex);
 
-	switch (READ_ONCE(call->state)) {
+	switch (rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 8eb97b822f5f..5aa5b5a3c4e6 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -25,7 +25,7 @@ bool rxrpc_propose_abort(struct rxrpc_call *call, s32 abort_code, int error,
 {
 	_enter("{%d},%d,%d,%u", call->debug_id, abort_code, error, why);
 
-	if (!call->send_abort && call->state < RXRPC_CALL_COMPLETE) {
+	if (!call->send_abort && !rxrpc_call_is_complete(call)) {
 		call->send_abort_why = why;
 		call->send_abort_err = error;
 		call->send_abort_seq = 0;
@@ -59,7 +59,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 		if (rxrpc_check_tx_space(call, NULL))
 			return 0;
 
-		if (call->state >= RXRPC_CALL_COMPLETE)
+		if (rxrpc_call_is_complete(call))
 			return call->error;
 
 		if (signal_pending(current))
@@ -94,7 +94,7 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 		if (rxrpc_check_tx_space(call, &tx_win))
 			return 0;
 
-		if (call->state >= RXRPC_CALL_COMPLETE)
+		if (rxrpc_call_is_complete(call))
 			return call->error;
 
 		if (timeout == 0 &&
@@ -123,7 +123,7 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		if (rxrpc_check_tx_space(call, NULL))
 			return 0;
 
-		if (call->state >= RXRPC_CALL_COMPLETE)
+		if (rxrpc_call_is_complete(call))
 			return call->error;
 
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
@@ -272,7 +272,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	ret = -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
 		goto maybe_error;
-	state = READ_ONCE(call->state);
+	state = rxrpc_call_state(call);
 	ret = -ESHUTDOWN;
 	if (state >= RXRPC_CALL_COMPLETE)
 		goto maybe_error;
@@ -349,7 +349,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 		/* check for the far side aborting the call or a network error
 		 * occurring */
-		if (call->state == RXRPC_CALL_COMPLETE)
+		if (rxrpc_call_is_complete(call))
 			goto call_terminated;
 
 		/* add the packet to the send queue if it's now full */
@@ -374,12 +374,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
-	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
-		read_lock(&call->state_lock);
-		if (call->error < 0)
-			ret = call->error;
-		read_unlock(&call->state_lock);
-	}
+	if (rxrpc_call_is_complete(call) &&
+	    call->error < 0)
+		ret = call->error;
 out:
 	call->tx_pending = txb;
 	_leave(" = %d", ret);
@@ -617,10 +614,10 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			return PTR_ERR(call);
 		/* ... and we have the call lock. */
 		ret = 0;
-		if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE)
+		if (rxrpc_call_is_complete(call))
 			goto out_put_unlock;
 	} else {
-		switch (READ_ONCE(call->state)) {
+		switch (rxrpc_call_state(call)) {
 		case RXRPC_CALL_UNINITIALISED:
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
 		case RXRPC_CALL_SERVER_PREALLOC:
@@ -674,7 +671,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		break;
 	}
 
-	state = READ_ONCE(call->state);
+	state = rxrpc_call_state(call);
 	_debug("CALL %d USR %lx ST %d on CONN %p",
 	       call->debug_id, call->user_call_ID, state, call->conn);
 
@@ -734,7 +731,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	_debug("CALL %d USR %lx ST %d on CONN %p",
 	       call->debug_id, call->user_call_ID, call->state, call->conn);
 
-	switch (READ_ONCE(call->state)) {
+	switch (rxrpc_call_state(call)) {
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:


