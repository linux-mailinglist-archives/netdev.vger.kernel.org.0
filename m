Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56FB6448B4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiLFQFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiLFQDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864F62FFD7
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJxJ6nTOVr7Gy43WamAHi0hFK2FQROOHVi+eeAx3fds=;
        b=LH9+XlYn3CDjgUQzla/aC4hm9NTGGvZl0GQD+Jd7PHci+KtXsRdrOhgd5Sd98aiQm2CGyE
        SAJSpgX6UJKWvuJKWXBRpOvCevlTBuHI/9iXwk6oRySXFcSZplyAESUNyZvljLXM9B9ZMn
        G8F/aXv4QWP8SQVBV5fshFwJIjXJsXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-lNiyyTCJMAemoyBvNA02qw-1; Tue, 06 Dec 2022 11:02:12 -0500
X-MC-Unique: lNiyyTCJMAemoyBvNA02qw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25413857D0E;
        Tue,  6 Dec 2022 16:02:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2EE4A9254;
        Tue,  6 Dec 2022 16:02:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 25/32] rxrpc: Move call state changes from recvmsg to
 I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:02:07 +0000
Message-ID: <167034252760.1105287.5705932376803769848.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the call state changes that are made in rxrpc_recvmsg() to the I/O
thread.  This means that, thenceforth, only the I/O thread does this and
the call state lock can be removed.

This requires the Rx phase to be ended when the last packet is received,
not when it is processed.

Since this now changes the rxrpc call state to SUCCEEDED before we've
consumed all the data from it, rxrpc_kernel_check_life() mustn't say the
call is dead until the recvmsg queue is empty (unless the call has failed).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 fs/afs/rxrpc.c          |    1 
 net/rxrpc/af_rxrpc.c    |   10 ++-
 net/rxrpc/ar-internal.h |    3 +
 net/rxrpc/input.c       |   38 ++++++++++-
 net/rxrpc/recvmsg.c     |  168 +++++++++++++++++------------------------------
 5 files changed, 109 insertions(+), 111 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index cfff7f9ccc33..1224cc4566d0 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -909,6 +909,7 @@ int afs_extract_data(struct afs_call *call, bool want_more)
 	ret = rxrpc_kernel_recv_data(net->socket, call->rxcall, iter,
 				     &call->iov_len, want_more, &remote_abort,
 				     &call->service_id);
+	trace_afs_receive_data(call, call->iter, want_more, ret);
 	if (ret == 0 || ret == -EAGAIN)
 		return ret;
 
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 74304f81ade7..6f790d48e51e 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -373,13 +373,17 @@ EXPORT_SYMBOL(rxrpc_kernel_end_call);
  * @sock: The socket the call is on
  * @call: The call to check
  *
- * Allow a kernel service to find out whether a call is still alive -
- * ie. whether it has completed.
+ * Allow a kernel service to find out whether a call is still alive - whether
+ * it has completed successfully and all received data has been consumed.
  */
 bool rxrpc_kernel_check_life(const struct socket *sock,
 			     const struct rxrpc_call *call)
 {
-	return !rxrpc_call_is_complete(call);
+	if (!rxrpc_call_is_complete(call))
+		return true;
+	if (call->completion != RXRPC_CALL_SUCCEEDED)
+		return false;
+	return !skb_queue_empty(&call->recvmsg_queue);
 }
 EXPORT_SYMBOL(rxrpc_kernel_check_life);
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6a5552274dca..beb5fbee2efd 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -546,7 +546,8 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
 	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
 	RXRPC_CALL_EXCLUSIVE,		/* The call uses a once-only connection */
-	RXRPC_CALL_RX_IS_IDLE,		/* Reception is idle - send an ACK */
+	RXRPC_CALL_RX_IS_IDLE,		/* recvmsg() is idle - send an ACK */
+	RXRPC_CALL_RECVMSG_READ_ALL,	/* recvmsg() read all of the received data */
 };
 
 /*
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dce440600f1a..b0ac846b16fc 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -319,6 +319,41 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 	return true;
 }
 
+/*
+ * End the packet reception phase.
+ */
+static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
+{
+	rxrpc_seq_t whigh = READ_ONCE(call->rx_highest_seq);
+
+	_enter("%d,%s", call->debug_id, rxrpc_call_states[call->state]);
+
+	trace_rxrpc_receive(call, rxrpc_receive_end, 0, whigh);
+
+	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_RECV_REPLY)
+		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
+
+	spin_lock(&call->state_lock);
+
+	switch (call->state) {
+	case RXRPC_CALL_CLIENT_RECV_REPLY:
+		__rxrpc_call_completed(call);
+		spin_unlock(&call->state_lock);
+		break;
+
+	case RXRPC_CALL_SERVER_RECV_REQUEST:
+		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
+		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
+		spin_unlock(&call->state_lock);
+		rxrpc_propose_delay_ACK(call, serial,
+					rxrpc_propose_ack_processing_op);
+		break;
+	default:
+		spin_unlock(&call->state_lock);
+		break;
+	}
+}
+
 static void rxrpc_input_update_ack_window(struct rxrpc_call *call,
 					  rxrpc_seq_t window, rxrpc_seq_t wtop)
 {
@@ -338,8 +373,9 @@ static void rxrpc_input_queue_data(struct rxrpc_call *call, struct sk_buff *skb,
 
 	__skb_queue_tail(&call->recvmsg_queue, skb);
 	rxrpc_input_update_ack_window(call, window, wtop);
-
 	trace_rxrpc_receive(call, last ? why + 1 : why, sp->hdr.serial, sp->hdr.seq);
+	if (last)
+		rxrpc_end_rx_phase(call, sp->hdr.serial);
 }
 
 /*
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 44576d16cdb0..1465ad3e691b 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -100,42 +100,6 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 	return ret;
 }
 
-/*
- * End the packet reception phase.
- */
-static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
-{
-	rxrpc_seq_t whigh = READ_ONCE(call->rx_highest_seq);
-
-	_enter("%d,%s", call->debug_id, rxrpc_call_states[call->state]);
-
-	trace_rxrpc_receive(call, rxrpc_receive_end, 0, whigh);
-
-	if (rxrpc_call_state(call) == RXRPC_CALL_CLIENT_RECV_REPLY)
-		rxrpc_propose_delay_ACK(call, serial, rxrpc_propose_ack_terminal_ack);
-
-	spin_lock(&call->state_lock);
-
-	switch (call->state) {
-	case RXRPC_CALL_CLIENT_RECV_REPLY:
-		__rxrpc_call_completed(call);
-		spin_unlock(&call->state_lock);
-		rxrpc_poke_call(call, rxrpc_call_poke_complete);
-		break;
-
-	case RXRPC_CALL_SERVER_RECV_REQUEST:
-		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
-		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
-		spin_unlock(&call->state_lock);
-		rxrpc_propose_delay_ACK(call, serial,
-					rxrpc_propose_ack_processing_op);
-		break;
-	default:
-		spin_unlock(&call->state_lock);
-		break;
-	}
-}
-
 /*
  * Discard a packet we've used up and advance the Rx window by one.
  */
@@ -166,10 +130,9 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 
 	trace_rxrpc_receive(call, last ? rxrpc_receive_rotate_last : rxrpc_receive_rotate,
 			    serial, call->rx_consumed);
-	if (last) {
-		rxrpc_end_rx_phase(call, serial);
-		return;
-	}
+
+	if (last)
+		set_bit(RXRPC_CALL_RECVMSG_READ_ALL, &call->flags);
 
 	/* Check to see if there's an ACK that needs sending. */
 	acked = atomic_add_return(call->rx_consumed - old_consumed,
@@ -194,7 +157,8 @@ static int rxrpc_verify_data(struct rxrpc_call *call, struct sk_buff *skb)
 /*
  * Deliver messages to a call.  This keeps processing packets until the buffer
  * is filled and we find either more DATA (returns 0) or the end of the DATA
- * (returns 1).  If more packets are required, it returns -EAGAIN.
+ * (returns 1).  If more packets are required, it returns -EAGAIN and if the
+ * call has failed it returns -EIO.
  */
 static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			      struct msghdr *msg, struct iov_iter *iter,
@@ -210,7 +174,13 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
 
-	if (rxrpc_call_state(call) >= RXRPC_CALL_SERVER_ACK_REQUEST) {
+	if (rxrpc_call_has_failed(call)) {
+		seq = call->ackr_window - 1;
+		ret = -EIO;
+		goto done;
+	}
+
+	if (test_bit(RXRPC_CALL_RECVMSG_READ_ALL, &call->flags)) {
 		seq = call->ackr_window - 1;
 		ret = 1;
 		goto done;
@@ -234,14 +204,15 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 
 		if (rx_pkt_offset == 0) {
 			ret2 = rxrpc_verify_data(call, skb);
-			rx_pkt_offset = sp->offset;
-			rx_pkt_len = sp->len;
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_next, seq,
-					     rx_pkt_offset, rx_pkt_len, ret2);
+					     sp->offset, sp->len, ret2);
 			if (ret2 < 0) {
+				kdebug("verify = %d", ret2);
 				ret = ret2;
 				goto out;
 			}
+			rx_pkt_offset = sp->offset;
+			rx_pkt_len = sp->len;
 		} else {
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_cont, seq,
 					     rx_pkt_offset, rx_pkt_len, 0);
@@ -414,36 +385,36 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		msg->msg_namelen = len;
 	}
 
-	switch (rxrpc_call_state(call)) {
-	case RXRPC_CALL_CLIENT_RECV_REPLY:
-	case RXRPC_CALL_SERVER_RECV_REQUEST:
-	case RXRPC_CALL_SERVER_ACK_REQUEST:
-		ret = rxrpc_recvmsg_data(sock, call, msg, &msg->msg_iter, len,
-					 flags, &copied);
-		if (ret == -EAGAIN)
-			ret = 0;
-
-		if (!skb_queue_empty(&call->recvmsg_queue))
-			rxrpc_notify_socket(call);
-		break;
-	default:
+	ret = rxrpc_recvmsg_data(sock, call, msg, &msg->msg_iter, len,
+				 flags, &copied);
+	if (ret == -EAGAIN)
 		ret = 0;
-		break;
-	}
-
+	if (ret == -EIO)
+		goto call_failed;
 	if (ret < 0)
 		goto error_unlock_call;
 
-	if (rxrpc_call_is_complete(call)) {
-		ret = rxrpc_recvmsg_term(call, msg);
-		if (ret < 0)
-			goto error_unlock_call;
-		if (!(flags & MSG_PEEK))
-			rxrpc_release_call(rx, call);
-		msg->msg_flags |= MSG_EOR;
-		ret = 1;
-	}
+	if (rxrpc_call_is_complete(call) &&
+	    skb_queue_empty(&call->recvmsg_queue))
+		goto call_complete;
+	if (rxrpc_call_has_failed(call))
+		goto call_failed;
 
+	rxrpc_notify_socket(call);
+	goto not_yet_complete;
+
+call_failed:
+	rxrpc_purge_queue(&call->recvmsg_queue);
+call_complete:
+	ret = rxrpc_recvmsg_term(call, msg);
+	if (ret < 0)
+		goto error_unlock_call;
+	if (!(flags & MSG_PEEK))
+		rxrpc_release_call(rx, call);
+	msg->msg_flags |= MSG_EOR;
+	ret = 1;
+
+not_yet_complete:
 	if (ret == 0)
 		msg->msg_flags |= MSG_MORE;
 	else
@@ -506,49 +477,34 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 	size_t offset = 0;
 	int ret;
 
-	_enter("{%d,%s},%zu,%d",
-	       call->debug_id, rxrpc_call_states[call->state],
-	       *_len, want_more);
-
-	ASSERTCMP(call->state, !=, RXRPC_CALL_SERVER_SECURING);
+	_enter("{%d},%zu,%d", call->debug_id, *_len, want_more);
 
 	mutex_lock(&call->user_mutex);
 
-	switch (rxrpc_call_state(call)) {
-	case RXRPC_CALL_CLIENT_RECV_REPLY:
-	case RXRPC_CALL_SERVER_RECV_REQUEST:
-	case RXRPC_CALL_SERVER_ACK_REQUEST:
-		ret = rxrpc_recvmsg_data(sock, call, NULL, iter,
-					 *_len, 0, &offset);
-		*_len -= offset;
-		if (ret < 0)
-			goto out;
-
-		/* We can only reach here with a partially full buffer if we
-		 * have reached the end of the data.  We must otherwise have a
-		 * full buffer or have been given -EAGAIN.
-		 */
-		if (ret == 1) {
-			if (iov_iter_count(iter) > 0)
-				goto short_data;
-			if (!want_more)
-				goto read_phase_complete;
-			ret = 0;
-			goto out;
-		}
-
-		if (!want_more)
-			goto excess_data;
+	ret = rxrpc_recvmsg_data(sock, call, NULL, iter, *_len, 0, &offset);
+	*_len -= offset;
+	if (ret == -EIO)
+		goto call_failed;
+	if (ret < 0)
 		goto out;
 
-	case RXRPC_CALL_COMPLETE:
-		goto call_complete;
-
-	default:
-		ret = -EINPROGRESS;
+	/* We can only reach here with a partially full buffer if we have
+	 * reached the end of the data.  We must otherwise have a full buffer
+	 * or have been given -EAGAIN.
+	 */
+	if (ret == 1) {
+		if (iov_iter_count(iter) > 0)
+			goto short_data;
+		if (!want_more)
+			goto read_phase_complete;
+		ret = 0;
 		goto out;
 	}
 
+	if (!want_more)
+		goto excess_data;
+	goto out;
+
 read_phase_complete:
 	ret = 1;
 out:
@@ -570,7 +526,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 			  0, -EMSGSIZE);
 	ret = -EMSGSIZE;
 	goto out;
-call_complete:
+call_failed:
 	*_abort = call->abort_code;
 	ret = call->error;
 	if (call->completion == RXRPC_CALL_SUCCEEDED) {


