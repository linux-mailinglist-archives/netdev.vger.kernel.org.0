Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A000E557D0D
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiFWNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiFWN3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECBAE2CDD8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEGqSQZXobODK/J05ZLNJnTGwEg2alyjPQ3FpZyAFms=;
        b=PCrE95ONvlYCYMD17Rydo58QZKrWBGjhjNcF1a6cCaC3mK7748JTeAR9Gnro25aei5xajE
        nKHq57rxSDVc16yWKP9Y0Ea88dc2SESra6TEGJsDfcqMVz6p8w9Zof/x47aZjM1YpoBEcd
        gnK0bqJPFByAXIt+1BpdVy1DzzeqmwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-L5TXAQqLPpaG1PEviqwmUA-1; Thu, 23 Jun 2022 09:29:41 -0400
X-MC-Unique: L5TXAQqLPpaG1PEviqwmUA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 586E2811E81;
        Thu, 23 Jun 2022 13:29:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AEE6492CA5;
        Thu, 23 Jun 2022 13:29:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 7/8] rxrpc: Implement splice-read for rxrpc calls
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:39 +0100
Message-ID: <165599097976.1827880.6339180782812070930.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the splice_read protocol operation for AF_RXRPC sockets.  This
allows the received data from a call to be spliced elsewhere.  The call
to be read from must be prespecified with setsockopt():

	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_RECV,
		   &call_id, sizeof(call_id));

	while (count < datasize) {
		ret = splice(client, NULL, pipefd[1], NULL,
			     datasize - count, 0);
		OSERROR(ret, "splice");
		count += ret;
	}

The splice keeps going until the call ends or the output pipe is full (in
which case it returns a short read or EWOULDBLOCK).

The prespecified call ID can be cleared with:

	call_id = 0;
	ret = setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_RECV,
			 &call_id, sizeof(call_id));

or changed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |    3 +
 net/rxrpc/af_rxrpc.c         |    1 
 net/rxrpc/ar-internal.h      |    2 
 net/rxrpc/recvmsg.c          |  204 ++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 200 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index b9b0b694b223..212e2b01fdd4 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -116,6 +116,9 @@
 	EM(rxrpc_recvmsg_full,			"FULL") \
 	EM(rxrpc_recvmsg_hole,			"HOLE") \
 	EM(rxrpc_recvmsg_next,			"NEXT") \
+	EM(rxrpc_recvmsg_splice,		"SPLC") \
+	EM(rxrpc_recvmsg_splice_full,		"SPFU") \
+	EM(rxrpc_recvmsg_splice_skb,		"SPSK") \
 	EM(rxrpc_recvmsg_requeue,		"REQU") \
 	EM(rxrpc_recvmsg_return,		"RETN") \
 	EM(rxrpc_recvmsg_terminal,		"TERM") \
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 41420c456e77..bf2bb1b99890 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -1319,6 +1319,7 @@ static const struct proto_ops rxrpc_rpc_ops = {
 	.sendmsg	= rxrpc_sendmsg,
 	.sendpage	= rxrpc_sendpage,
 	.recvmsg	= rxrpc_recvmsg,
+	.splice_read	= rxrpc_splice_read,
 	.mmap		= sock_no_mmap,
 };
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index bec398c66341..526169effe89 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1056,6 +1056,8 @@ bool rxrpc_call_completed(struct rxrpc_call *);
 bool __rxrpc_abort_call(const char *, struct rxrpc_call *, rxrpc_seq_t, u32, int);
 bool rxrpc_abort_call(const char *, struct rxrpc_call *, rxrpc_seq_t, u32, int);
 int rxrpc_recvmsg(struct socket *, struct msghdr *, size_t, int);
+ssize_t rxrpc_splice_read(struct socket *, loff_t *, struct pipe_inode_info *,
+			  size_t, unsigned int);
 
 /*
  * Abort a call due to a protocol error.
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 3fc6bf8b1ff2..3bbee5ae4c75 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -375,6 +375,8 @@ static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
  */
 static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			      struct msghdr *msg, struct iov_iter *iter,
+			      struct pipe_inode_info *pipe,
+			      unsigned int splice_flags,
 			      size_t len, int flags, size_t *_offset)
 {
 	struct rxrpc_skb_priv *sp;
@@ -444,17 +446,41 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 					    rx_pkt_offset, rx_pkt_len, 0);
 		}
 
+	try_another_transfer:
 		/* We have to handle short, empty and used-up DATA packets. */
 		remain = len - *_offset;
 		copy = rx_pkt_len;
 		if (copy > remain)
 			copy = remain;
 		if (copy > 0) {
-			ret2 = skb_copy_datagram_iter(skb, rx_pkt_offset, iter,
-						      copy);
-			if (ret2 < 0) {
-				ret = ret2;
-				goto out;
+			if (!pipe) {
+				ret2 = skb_copy_datagram_iter(skb, rx_pkt_offset,
+							      iter, copy);
+				if (ret2 < 0) {
+					ret = ret2;
+					goto out;
+				}
+			} else {
+				if (!(sp->hdr.flags & RXRPC_LAST_PACKET))
+					splice_flags |= SPLICE_F_MORE;
+				else if (copy < rx_pkt_len)
+					splice_flags |= SPLICE_F_MORE;
+				else
+					splice_flags &= ~SPLICE_F_MORE;
+
+				ret2 = skb_splice_bits(skb, sock->sk, rx_pkt_offset,
+						       pipe, copy, splice_flags);
+				if (ret2 < 0) {
+					trace_rxrpc_recvmsg(call, rxrpc_recvmsg_splice_full, seq,
+							    rx_pkt_offset, rx_pkt_len, ret2);
+					if (ret2 == -EAGAIN)
+						ret2 = -EXFULL;
+					ret = ret2;
+					goto out;
+				}
+				trace_rxrpc_recvmsg(call, rxrpc_recvmsg_splice_skb, seq,
+						    rx_pkt_offset, rx_pkt_len, ret2);
+				copy = ret2;
 			}
 
 			/* handle piecemeal consumption of data packets */
@@ -463,14 +489,16 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			*_offset += copy;
 		}
 
-		if (rx_pkt_len > 0) {
+		if (*_offset >= len) {
 			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_full, seq,
 					    rx_pkt_offset, rx_pkt_len, 0);
-			ASSERTCMP(*_offset, ==, len);
 			ret = 0;
 			break;
 		}
 
+		if (rx_pkt_len > 0)
+			goto try_another_transfer;
+
 		/* The whole packet has been transferred. */
 		if (!(flags & MSG_PEEK))
 			rxrpc_rotate_rx_window(call);
@@ -679,8 +707,8 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
-		ret = rxrpc_recvmsg_data(sock, call, msg, &msg->msg_iter, len,
-					 flags, &copied);
+		ret = rxrpc_recvmsg_data(sock, call, msg, &msg->msg_iter,
+					 NULL, 0, len, flags, &copied);
 		if (ret == -EAGAIN)
 			ret = 0;
 
@@ -731,6 +759,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
 		write_unlock_bh(&rx->recvmsg_lock);
 		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0, 0, 0, 0);
+		rx->sk.sk_data_ready(&rx->sk);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put);
 	}
@@ -748,6 +777,161 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	goto error_trace;
 }
 
+/*
+ * Read data from the call specified by setsockopt(RXRPC_SELECT_CALL_FOR_RECV)
+ * and splice it into a pipe.
+ */
+ssize_t rxrpc_splice_read(struct socket *sock, loff_t *ppos,
+			  struct pipe_inode_info *pipe, size_t len,
+			  unsigned int splice_flags)
+{
+	struct rxrpc_call *call;
+	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
+	unsigned int flags = 0;
+	ssize_t ret;
+	size_t copied = 0, partial;
+	long timeo;
+
+	DEFINE_WAIT(wait);
+
+	_enter("%zu", len);
+
+	if (unlikely(!ppos))
+		return -ESPIPE;
+
+	if (splice_flags & SPLICE_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	timeo = sock_rcvtimeo(&rx->sk, splice_flags & SPLICE_F_NONBLOCK);
+
+	lock_sock(&rx->sk);
+	call = rx->selected_recv_call;
+	if (!call) {
+		release_sock(&rx->sk);
+		return -EBADSLT;
+	}
+
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_splice, 0, 0, 0, 0);
+
+	rxrpc_get_call(call, rxrpc_call_got);
+	release_sock(&rx->sk);
+
+try_again:
+	if (list_empty(&call->recvmsg_link)) {
+		if (timeo == 0) {
+			ret = -EWOULDBLOCK;
+			goto error;
+		}
+
+		/* Wait for something to happen */
+		for (;;) {
+			prepare_to_wait_exclusive(sk_sleep(&rx->sk), &wait,
+						  TASK_INTERRUPTIBLE);
+			ret = sock_error(&rx->sk);
+			if (ret)
+				goto wait_error;
+
+			if (!list_empty(&call->recvmsg_link))
+				break;
+
+			if (signal_pending(current))
+				goto wait_interrupted;
+			trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_wait, 0, timeo, 0, 0);
+			timeo = schedule_timeout(timeo);
+			ret = -ETIMEDOUT;
+			if (timeo == 0)
+				goto wait_error;
+		}
+		finish_wait(sk_sleep(&rx->sk), &wait);
+	}
+
+	write_lock_bh(&rx->recvmsg_lock);
+	if (list_empty(&call->recvmsg_link)) {
+		write_unlock_bh(&rx->recvmsg_lock);
+		goto try_again;
+	}
+	list_del_init(&call->recvmsg_link);
+	write_unlock_bh(&rx->recvmsg_lock);
+
+	rxrpc_put_call(call, rxrpc_call_put); /* Drop extra ref inherited from the list */
+
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0, 0, 0, 0);
+
+	/* We're going to drop the socket lock, so we need to lock the call
+	 * against interference by sendmsg.
+	 */
+	if (!mutex_trylock(&call->user_mutex)) {
+		ret = -EWOULDBLOCK;
+		if (splice_flags & SPLICE_F_NONBLOCK)
+			goto error_requeue_call_no_lock;
+		ret = -ERESTARTSYS;
+		if (mutex_lock_interruptible(&call->user_mutex) < 0)
+			goto error_requeue_call_no_lock;
+	}
+
+	switch (READ_ONCE(call->state)) {
+	case RXRPC_CALL_CLIENT_RECV_REPLY:
+	case RXRPC_CALL_SERVER_RECV_REQUEST:
+	case RXRPC_CALL_SERVER_ACK_REQUEST:
+		partial = 0;
+		ret = rxrpc_recvmsg_data(sock, call, NULL, NULL,
+					 pipe, splice_flags, len, flags, &partial);
+		copied += partial;
+		len -= partial;
+		if (ret == -EAGAIN) {
+			if (call->state != RXRPC_CALL_COMPLETE &&
+			    len > 0) {
+				mutex_unlock(&call->user_mutex);
+				goto try_again;
+			}
+			ret = 0;
+		}
+		if (ret == -EXFULL)
+			ret = 0;
+
+		if (after(call->rx_top, call->rx_hard_ack) &&
+		    call->rxtx_buffer[(call->rx_hard_ack + 1) & RXRPC_RXTX_BUFF_MASK])
+			rxrpc_notify_socket(call);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	if (ret < 0)
+		goto error_unlock_call;
+
+	if (call->state == RXRPC_CALL_COMPLETE)
+		/* recvmsg() must be called to get the termination state. */
+		goto error_requeue_call;
+
+	ret = copied;
+
+error_unlock_call:
+	mutex_unlock(&call->user_mutex);
+error:
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, 0, 0, 0, ret);
+	rxrpc_put_call(call, rxrpc_call_put);
+	_leave(" = %zd", ret);
+	return ret;
+
+error_requeue_call:
+	mutex_unlock(&call->user_mutex);
+error_requeue_call_no_lock:
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0, 0, 0, 0);
+	write_lock_bh(&rx->recvmsg_lock);
+	rxrpc_get_call(call, rxrpc_call_got);
+	list_add(&call->recvmsg_link, &rx->recvmsg_q);
+	write_unlock_bh(&rx->recvmsg_lock);
+	rx->sk.sk_data_ready(&rx->sk);
+	goto error;
+
+wait_interrupted:
+	ret = sock_intr_errno(timeo);
+wait_error:
+	finish_wait(sk_sleep(&rx->sk), &wait);
+	goto error;
+}
+
 /**
  * rxrpc_kernel_recv_data - Allow a kernel service to receive data/info
  * @sock: The socket that the call exists on
@@ -787,7 +971,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
-		ret = rxrpc_recvmsg_data(sock, call, NULL, iter,
+		ret = rxrpc_recvmsg_data(sock, call, NULL, iter, NULL, 0,
 					 *_len, 0, &offset);
 		*_len -= offset;
 		if (ret < 0)


