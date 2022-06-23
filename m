Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA8D557D04
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiFWNaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiFWN3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 802FC4D25F
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciFb9FbqYXRy6BbmwiZEF2VpsKy4dqwovfR5dOvDF5U=;
        b=IttNTGV/eTd5Imx54WmymgZFMuFiIoqBuxTHkINxFVKqdK6UhCmmmTyx+Ylwxsq/0uhV31
        brwHJE1H+AFzIKDFNw4r7rLWBfaCVGAOm29nyUmj6thkmFF67FP1ls+UQtK1LPEnO7u/xw
        hYJxA6GVYc/5VoCGy7gaNWzAuNoYhgg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-snzvviWCPp-l4Lxt8Zg-xg-1; Thu, 23 Jun 2022 09:29:28 -0400
X-MC-Unique: snzvviWCPp-l4Lxt8Zg-xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28A62919EA1;
        Thu, 23 Jun 2022 13:29:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 023BCC23DBF;
        Thu, 23 Jun 2022 13:29:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 5/8] rxrpc: Implement sendfile() support
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:26 +0100
Message-ID: <165599096629.1827880.6190981681205501847.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the sendpage protocol operation so that sendfile() will work
directly with AF_RXRPC calls.  To use sendfile() to communicate with a call
requires the call to be specified beforehand with setsockopt():

	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_SEND,
		   &call_id, sizeof(call_id));
	sendfile(client, source, &pos, st.st_size);

The specified call ID can be cleared:

	call_id = 0;
	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_SEND,
		   &call_id, sizeof(call_id));

or changed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/af_rxrpc.c    |   40 +++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/sendmsg.c     |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 8ac014aff7a2..41420c456e77 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -798,6 +798,44 @@ static int rxrpc_bind_channel(struct rxrpc_sock *rx2, int fd)
 	return ret;
 }
 
+/*
+ * Splice into a call.  The call to send as part of must have been set with
+ * setsockopt(RXRPC_SELECT_CALL_FOR_SEND).
+ */
+static ssize_t rxrpc_sendpage(struct socket *sock, struct page *page, int offset,
+			      size_t size, int flags)
+{
+	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
+	struct rxrpc_call *call;
+	ssize_t ret;
+
+	_enter("{%d},,%u,%zu,%x", rx->sk.sk_state, offset, size, flags);
+
+	lock_sock(&rx->sk);
+
+	read_lock_bh(&rx->recvmsg_lock);
+	call = rx->selected_send_call;
+	if (!call) {
+		read_unlock_bh(&rx->recvmsg_lock);
+		release_sock(&rx->sk);
+		return -EBADSLT;
+	}
+
+	rxrpc_get_call(call, rxrpc_call_got);
+	read_unlock_bh(&rx->recvmsg_lock);
+
+	ret = mutex_lock_interruptible(&call->user_mutex);
+	release_sock(&rx->sk);
+	if (ret == 0) {
+		ret = rxrpc_do_sendpage(rx, call, page, offset, size, flags);
+		mutex_unlock(&call->user_mutex);
+	}
+
+	rxrpc_put_call(call, rxrpc_call_put);
+	_leave(" = %zd", ret);
+	return ret;
+}
+
 /*
  * Set the default call for 'targetless' operations such as splice(), SIOCINQ
  * and SIOCOUTQ and also as a filter for recvmsg().  Calling this function
@@ -1279,9 +1317,9 @@ static const struct proto_ops rxrpc_rpc_ops = {
 	.setsockopt	= rxrpc_setsockopt,
 	.getsockopt	= rxrpc_getsockopt,
 	.sendmsg	= rxrpc_sendmsg,
+	.sendpage	= rxrpc_sendpage,
 	.recvmsg	= rxrpc_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 static struct proto rxrpc_proto = {
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ec2c614082b9..bec398c66341 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1107,6 +1107,8 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
  * sendmsg.c
  */
 int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
+ssize_t rxrpc_do_sendpage(struct rxrpc_sock *, struct rxrpc_call *,
+			  struct page *, int, size_t, int);
 
 /*
  * server_key.c
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..77699008c428 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -762,6 +762,45 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	return ret;
 }
 
+/*
+ * Handle data input from a splice.  The call to send as part of must have been
+ * set with setsockopt(RXRPC_SELECT_CALL_FOR_SEND).
+ */
+ssize_t rxrpc_do_sendpage(struct rxrpc_sock *rx, struct rxrpc_call *call,
+			  struct page *page, int offset, size_t size, int flags)
+{
+	struct bio_vec bv = {
+		.bv_page	= page,
+		.bv_offset	= offset,
+		.bv_len		= size,
+	};
+	struct msghdr msg = {
+		.msg_flags	= flags,
+	};
+
+	_enter(",,%lx,%u,%zu,%x", page->index, offset, size, flags);
+
+	switch (READ_ONCE(call->state)) {
+	case RXRPC_CALL_COMPLETE:
+		return -ESHUTDOWN;
+	default:
+		return -EPROTO;
+	case RXRPC_CALL_CLIENT_SEND_REQUEST:
+	case RXRPC_CALL_SERVER_ACK_REQUEST:
+	case RXRPC_CALL_SERVER_SEND_REPLY:
+		break;
+	}
+
+	/* Ideally, we'd allow sendfile() to end the Tx phase - but there's no
+	 * way for userspace to communicate this option through that syscall.
+	 */
+	//if (flags & MSG_SENDPAGE_NOTLAST)
+	msg.msg_flags |= MSG_MORE;
+
+	iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, size);
+	return rxrpc_send_data(rx, call, &msg, size, NULL);
+}
+
 /**
  * rxrpc_kernel_send_data - Allow a kernel service to send data on a call
  * @sock: The socket the call is on


