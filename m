Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BDC557CFD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiFWN3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiFWN3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DEE94B1EB
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uef2yh6j1zy01ZHqkGb+HrXgHU+Hh0UFr+oU45pcct0=;
        b=NqfdyRxFKj0dihwCdUJv1RrElrgjAkwsjSmod5+HjXWTNcPoxGyVVw22mNWeWO+gVRdzGm
        BeICfWQvt6slvbtdHQEiiMofdj/mhg/2Ymmf05TZnl9Nck6L6yWrvRKWi7DlgeI4SHAJIF
        nU9muUGV7dDd3+SpcskpkCVjJnSkQzM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-ZcBih0k_ORiu8YP_QNUXXQ-1; Thu, 23 Jun 2022 09:29:14 -0400
X-MC-Unique: ZcBih0k_ORiu8YP_QNUXXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 664D08032F4;
        Thu, 23 Jun 2022 13:29:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7995F2166B29;
        Thu, 23 Jun 2022 13:29:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 3/8] rxrpc: Allow multiple AF_RXRPC sockets to be bound
 together to form queues
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:12 +0100
Message-ID: <165599095279.1827880.8011666375060763290.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow one rxrpc socket to be bound onto another to form a queue.  This is
done by allocating a socket and setting it up, then allocating more sockets
and using a sockopt to bind them together:

	fd1 = socket(AF_RXRPC, SOCK_DGRAM, IPPROTO_IPV6);
	bind(fd1, &address);
	listen(fd1, depth);

	fd2 = socket(AF_RXRPC, SOCK_DGRAM, IPPROTO_IPV6);
	setsockopt(fd2, SOL_RXRPC, RXRPC_BIND_CHANNEL, &fd1, sizeof(fd1));

From this point:

 (1) Each channel must be charged with user call IDs separately.  Each
     channel has a separate call ID space.  A call ID on one channel cannot
     be used to send a message on another channel.  The same call ID on
     different channels refers to different calls.

 (2) An incoming call will get bound to the next channel that does a
     recvmsg() on an empty queue.  All further incoming packets relating to
     that call will go to that channel exclusively.

 (3) An outgoung client call made on a particular channel will be bound to
     that channel.

 (4) If a channel is closed, all calls bound to that channel will be
     aborted.

 (5) Unaccepted incoming calls are held in a queue common to all channels
     and is of the depth set by listen().  Each time recvmsg() is called on
     a channel, if that channel has at least one charge available, it will
     pop an incoming call from that queue, bind the next charge to it,
     attach it to the socket and push it onto the tail of the recvmsg
     queue.

     This can be used as a mechanism to distribute calls between a thread
     pool and a mechanism to control the arrival of new calls on any
     particular channel.  New calls can and will only be collected if the
     channel is charged.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/rxrpc.h |    1 +
 net/rxrpc/af_rxrpc.c       |   79 +++++++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/call_accept.c    |    5 ---
 net/rxrpc/call_object.c    |    2 +
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/rxrpc.h b/include/uapi/linux/rxrpc.h
index 8f8dc7a937a4..811923643751 100644
--- a/include/uapi/linux/rxrpc.h
+++ b/include/uapi/linux/rxrpc.h
@@ -36,6 +36,7 @@ struct sockaddr_rxrpc {
 #define RXRPC_MIN_SECURITY_LEVEL	4	/* minimum security level */
 #define RXRPC_UPGRADEABLE_SERVICE	5	/* Upgrade service[0] -> service[1] */
 #define RXRPC_SUPPORTED_CMSG		6	/* Get highest supported control message type */
+#define RXRPC_BIND_CHANNEL		7	/* Bind a socket as an additional recvmsg channel */
 
 /*
  * RxRPC control messages
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 703e10969d2f..6b89a5a969e0 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -733,6 +733,71 @@ int rxrpc_sock_set_upgradeable_service(struct sock *sk, unsigned int val[2])
 }
 EXPORT_SYMBOL(rxrpc_sock_set_upgradeable_service);
 
+/*
+ * Bind this socket to another socket that's already set up and listening to
+ * use this as an additional channel for receiving new service calls.
+ */
+static int rxrpc_bind_channel(struct rxrpc_sock *rx2, int fd)
+{
+	struct rxrpc_service *b;
+	struct rxrpc_sock *rx1;
+	struct socket *sock1;
+	unsigned long *call_id_backlog;
+	int ret;
+
+	if (rx2->sk.sk_state != RXRPC_UNBOUND)
+		return -EISCONN;
+	if (rx2->service || rx2->exclusive)
+		return -EINVAL;
+
+	sock1 = sockfd_lookup(fd, &ret);
+	if (!sock1)
+		return ret;
+	rx1 = rxrpc_sk(sock1->sk);
+
+	ret = -EINVAL;
+	if (rx1 == rx2 || rx2->family != rx1->family ||
+	    sock_net(&rx2->sk) != sock_net(&rx1->sk))
+		goto error;
+
+	ret = -EISCONN;
+	if (rx1->sk.sk_state != RXRPC_SERVER_LISTENING)
+		goto error;
+
+	ret = -ENOMEM;
+	call_id_backlog = kcalloc(RXRPC_BACKLOG_MAX,
+				  sizeof(call_id_backlog[0]),
+				  GFP_KERNEL);
+	if (!call_id_backlog)
+		goto error;
+
+	lock_sock_nested(&rx1->sk, 1);
+
+	ret = -EISCONN;
+	if (rx1->sk.sk_state != RXRPC_SERVER_LISTENING)
+		goto error_unlock;
+
+	b = rx1->service;
+	refcount_inc(&b->ref);
+	refcount_inc(&b->active);
+	rx2->service		= b;
+	rx2->srx		= rx1->srx;
+	rx2->call_id_backlog	= call_id_backlog;
+	rx2->min_sec_level	= rx1->min_sec_level;
+	rx2->local		= rxrpc_get_local(rx1->local);
+	atomic_inc(&rx1->local->active_users);
+	rx2->sk.sk_state	= RXRPC_SERVER_LISTENING;
+	call_id_backlog = NULL;
+	ret = 0;
+
+error_unlock:
+	release_sock(&rx1->sk);
+	kfree(call_id_backlog);
+error:
+	fput(sock1->file);
+	return ret;
+}
+
 /*
  * set RxRPC socket options
  */
@@ -742,7 +807,7 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
 	unsigned int min_sec_level;
 	u16 service_upgrade[2];
-	int ret;
+	int ret, fd;
 
 	_enter(",%d,%d,,%d", level, optname, optlen);
 
@@ -817,6 +882,18 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 				goto error;
 			goto success;
 
+		case RXRPC_BIND_CHANNEL:
+			ret = -EINVAL;
+			if (optlen != sizeof(fd))
+				goto error;
+			ret = -EFAULT;
+			if (copy_from_sockptr(&fd, optval, sizeof(fd)) != 0)
+				goto error;
+			ret = rxrpc_bind_channel(rx, fd);
+			if (ret < 0)
+				goto error;
+			goto success;
+
 		default:
 			break;
 		}
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 3cba4dacb8d4..68760a0657a1 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -296,8 +296,6 @@ void rxrpc_deactivate_service(struct rxrpc_sock *rx)
 	if (!refcount_dec_and_test(&rx->service->active))
 		return;
 
-	kdebug("-- deactivate --");
-
 	/* Now that active is 0, make sure that there aren't any incoming calls
 	 * being set up before we clear the preallocation buffers.
 	 */
@@ -335,12 +333,9 @@ void rxrpc_deactivate_service(struct rxrpc_sock *rx)
 
 	head = b->call_backlog_head;
 	tail = b->call_backlog_tail;
-	kdebug("backlog %x %x", head, tail);
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_call *call = b->call_backlog[tail];
 
-		kdebug("discard c=%08x", call->debug_id);
-
 		trace_rxrpc_call(call->debug_id, rxrpc_call_discard,
 				 refcount_read(&call->ref),
 				 NULL, (const void *)call->user_call_ID);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index e90b205a6c0f..4ee98ac689f9 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -712,7 +712,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	if (WARN_ON(!test_bit(RXRPC_CALL_RELEASED, &call->flags))) {
-		kdebug("### UNRELEASED c=%08x", call->debug_id);
+		pr_warn("### UNRELEASED c=%08x", call->debug_id);
 		return;
 	}
 


