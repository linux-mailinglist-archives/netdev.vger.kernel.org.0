Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C748865501A
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiLWMEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiLWMCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:02:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD6644968
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmA9IRf/XDUcMNbY2O+OHqWXJXMxbWvGXciFgaBeaSw=;
        b=DVTNH9EAwbrz77YE2fDqQXqM5/bFfh+iklFQQpd5Us1pNBbsgqMAxfyu6Bz9y03qjEMMr7
        uJGutzOqdfl28UL0Yf+LN64+RREEWnehBRA5Z8N39UNWdX1AD1KUwf0O4dTHojhlLL5QQ/
        Ip5Je/DP6HbJcW5EaeghlYGf4YfOkcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-_V7BJsqkOw2_ioxwY1UB8A-1; Fri, 23 Dec 2022 07:01:38 -0500
X-MC-Unique: _V7BJsqkOw2_ioxwY1UB8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 474948533DB;
        Fri, 23 Dec 2022 12:01:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CD7D140EBF5;
        Fri, 23 Dec 2022 12:01:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 15/19] rxrpc: Move call state changes from sendmsg to
 I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 12:01:37 +0000
Message-ID: <167179689701.2516210.8153044683757609080.stgit@warthog.procyon.org.uk>
In-Reply-To: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
References: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move all the call state changes that are made in rxrpc_sendmsg() to the I/O
thread.  This is a step towards removing the call state lock.

This requires the switch to the RXRPC_CALL_CLIENT_AWAIT_REPLY and
RXRPC_CALL_SERVER_SEND_REPLY states to be done when the last packet is
decanted from ->tx_sendmsg to ->tx_buffer in the I/O thread, not when it is
added to ->tx_sendmsg by sendmsg().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 Documentation/networking/rxrpc.rst |    4 +-
 net/rxrpc/call_event.c             |   50 +++++++++++++++++++++++++-
 net/rxrpc/sendmsg.c                |   69 +++++++-----------------------------
 3 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
index 39494a6ea739..e1af54424192 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -880,8 +880,8 @@ The kernel interface functions are as follows:
 
      notify_end_rx can be NULL or it can be used to specify a function to be
      called when the call changes state to end the Tx phase.  This function is
-     called with the call-state spinlock held to prevent any reply or final ACK
-     from being delivered first.
+     called with a spinlock held to prevent the last DATA packet from being
+     transmitted until the function returns.
 
  (#) Receive data from a call::
 
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index d076b0a87b1c..edb54d9ce6e8 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -251,6 +251,50 @@ void rxrpc_resend(struct rxrpc_call *call, struct sk_buff *ack_skb)
 	_leave("");
 }
 
+/*
+ * Start transmitting the reply to a service.  This cancels the need to ACK the
+ * request if we haven't yet done so.
+ */
+static void rxrpc_begin_service_reply(struct rxrpc_call *call)
+{
+	unsigned long now;
+
+	write_lock(&call->state_lock);
+
+	if (call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
+		now = jiffies;
+		call->state = RXRPC_CALL_SERVER_SEND_REPLY;
+		WRITE_ONCE(call->delay_ack_at, now + MAX_JIFFY_OFFSET);
+		if (call->ackr_reason == RXRPC_ACK_DELAY)
+			call->ackr_reason = 0;
+		trace_rxrpc_timer(call, rxrpc_timer_init_for_send_reply, now);
+	}
+
+	write_unlock(&call->state_lock);
+}
+
+/*
+ * Close the transmission phase.  After this point there is no more data to be
+ * transmitted in the call.
+ */
+static void rxrpc_close_tx_phase(struct rxrpc_call *call)
+{
+	_debug("________awaiting reply/ACK__________");
+
+	write_lock(&call->state_lock);
+	switch (call->state) {
+	case RXRPC_CALL_CLIENT_SEND_REQUEST:
+		call->state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
+		break;
+	case RXRPC_CALL_SERVER_SEND_REPLY:
+		call->state = RXRPC_CALL_SERVER_AWAIT_ACK;
+		break;
+	default:
+		break;
+	}
+	write_unlock(&call->state_lock);
+}
+
 static bool rxrpc_tx_window_has_space(struct rxrpc_call *call)
 {
 	unsigned int winsize = min_t(unsigned int, call->tx_winsize,
@@ -283,6 +327,9 @@ static void rxrpc_decant_prepared_tx(struct rxrpc_call *call)
 		call->tx_top = txb->seq;
 		list_add_tail(&txb->call_link, &call->tx_buffer);
 
+		if (txb->wire.flags & RXRPC_LAST_PACKET)
+			rxrpc_close_tx_phase(call);
+
 		rxrpc_transmit_one(call, txb);
 
 		if (!rxrpc_tx_window_has_space(call))
@@ -296,12 +343,11 @@ static void rxrpc_transmit_some_data(struct rxrpc_call *call)
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 		if (list_empty(&call->tx_sendmsg))
 			return;
+		rxrpc_begin_service_reply(call);
 		fallthrough;
 
 	case RXRPC_CALL_SERVER_SEND_REPLY:
-	case RXRPC_CALL_SERVER_AWAIT_ACK:
 	case RXRPC_CALL_CLIENT_SEND_REQUEST:
-	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
 		if (!rxrpc_tx_window_has_space(call))
 			return;
 		if (list_empty(&call->tx_sendmsg)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 5aa5b5a3c4e6..5b17ee1cbfbf 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -188,7 +188,6 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 			       struct rxrpc_txbuf *txb,
 			       rxrpc_notify_end_tx_t notify_end_tx)
 {
-	unsigned long now;
 	rxrpc_seq_t seq = txb->seq;
 	bool last = test_bit(RXRPC_TXBUF_LAST, &txb->flags), poke;
 
@@ -211,36 +210,10 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	poke = list_empty(&call->tx_sendmsg);
 	list_add_tail(&txb->call_link, &call->tx_sendmsg);
 	call->tx_prepared = seq;
+	if (last)
+		rxrpc_notify_end_tx(rx, call, notify_end_tx);
 	spin_unlock(&call->tx_lock);
 
-	if (last || call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
-		_debug("________awaiting reply/ACK__________");
-		write_lock(&call->state_lock);
-		switch (call->state) {
-		case RXRPC_CALL_CLIENT_SEND_REQUEST:
-			call->state = RXRPC_CALL_CLIENT_AWAIT_REPLY;
-			rxrpc_notify_end_tx(rx, call, notify_end_tx);
-			break;
-		case RXRPC_CALL_SERVER_ACK_REQUEST:
-			call->state = RXRPC_CALL_SERVER_SEND_REPLY;
-			now = jiffies;
-			WRITE_ONCE(call->delay_ack_at, now + MAX_JIFFY_OFFSET);
-			if (call->ackr_reason == RXRPC_ACK_DELAY)
-				call->ackr_reason = 0;
-			trace_rxrpc_timer(call, rxrpc_timer_init_for_send_reply, now);
-			if (!last)
-				break;
-			fallthrough;
-		case RXRPC_CALL_SERVER_SEND_REPLY:
-			call->state = RXRPC_CALL_SERVER_AWAIT_ACK;
-			rxrpc_notify_end_tx(rx, call, notify_end_tx);
-			break;
-		default:
-			break;
-		}
-		write_unlock(&call->state_lock);
-	}
-
 	if (poke)
 		rxrpc_poke_call(call, rxrpc_call_poke_start);
 }
@@ -279,8 +252,13 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	ret = -EPROTO;
 	if (state != RXRPC_CALL_CLIENT_SEND_REQUEST &&
 	    state != RXRPC_CALL_SERVER_ACK_REQUEST &&
-	    state != RXRPC_CALL_SERVER_SEND_REPLY)
+	    state != RXRPC_CALL_SERVER_SEND_REPLY) {
+		/* Request phase complete for this client call */
+		trace_rxrpc_abort(call->debug_id, rxrpc_sendmsg_late_send,
+				  call->cid, call->call_id, call->rx_consumed,
+				  0, -EPROTO);
 		goto maybe_error;
+	}
 
 	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
@@ -572,7 +550,6 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
 int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	__releases(&rx->sk.sk_lock.slock)
 {
-	enum rxrpc_call_state state;
 	struct rxrpc_call *call;
 	unsigned long now, j;
 	bool dropped_lock = false;
@@ -671,11 +648,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		break;
 	}
 
-	state = rxrpc_call_state(call);
-	_debug("CALL %d USR %lx ST %d on CONN %p",
-	       call->debug_id, call->user_call_ID, state, call->conn);
-
-	if (state >= RXRPC_CALL_COMPLETE) {
+	if (rxrpc_call_is_complete(call)) {
 		/* it's too late for this call */
 		ret = -ESHUTDOWN;
 	} else if (p.command == RXRPC_CMD_SEND_ABORT) {
@@ -721,7 +694,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	bool dropped_lock = false;
 	int ret;
 
-	_enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
+	_enter("{%d},", call->debug_id);
 
 	ASSERTCMP(msg->msg_name, ==, NULL);
 	ASSERTCMP(msg->msg_control, ==, NULL);
@@ -731,26 +704,10 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	_debug("CALL %d USR %lx ST %d on CONN %p",
 	       call->debug_id, call->user_call_ID, call->state, call->conn);
 
-	switch (rxrpc_call_state(call)) {
-	case RXRPC_CALL_CLIENT_SEND_REQUEST:
-	case RXRPC_CALL_SERVER_ACK_REQUEST:
-	case RXRPC_CALL_SERVER_SEND_REPLY:
-		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx, &dropped_lock);
-		break;
-	case RXRPC_CALL_COMPLETE:
-		read_lock(&call->state_lock);
+	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
+			      notify_end_tx, &dropped_lock);
+	if (ret == -ESHUTDOWN)
 		ret = call->error;
-		read_unlock(&call->state_lock);
-		break;
-	default:
-		/* Request phase complete for this client call */
-		trace_rxrpc_abort(call->debug_id, rxrpc_sendmsg_late_send,
-				  call->cid, call->call_id, call->rx_consumed,
-				  0, -EPROTO);
-		ret = -EPROTO;
-		break;
-	}
 
 	if (!dropped_lock)
 		mutex_unlock(&call->user_mutex);


