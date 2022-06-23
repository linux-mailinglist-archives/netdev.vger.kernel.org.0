Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DC557D02
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiFWNaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiFWN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9ACE165B1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zYIQeoAkoeeQL2ElZSgJ29nwy/cQigs10yk4C7PCNAg=;
        b=eDaKzaAOIPuu16qiI6ZulOm1YJgK2MFt5HenHiajX4WJuBdysyeozB6DkkEcaaaEtiIGaN
        oFszVmgymMQ8agEvio6dxvd8sE5PtomlIYlImYtQmif1/+1zfG7QZmpNEP1nesS9bDzs9L
        SdV8tH9i7b6/BafXBMGuP2EVC3MB68U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-LWjBXqF-MPSDTCtvXpwO3w-1; Thu, 23 Jun 2022 09:29:21 -0400
X-MC-Unique: LWjBXqF-MPSDTCtvXpwO3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20A571C05131;
        Thu, 23 Jun 2022 13:29:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9532166B29;
        Thu, 23 Jun 2022 13:29:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 4/8] rxrpc: Allow the call to interact with to be
 preselected
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:19 +0100
Message-ID: <165599095958.1827880.2714875214673999398.stgit@warthog.procyon.org.uk>
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

Provide a pair of socket options that allow the call to be interacted with
by various system calls to be preselected.  Both of them take a user call
ID or 0 as a parameter.  When this is called, the previous selection is
cleared; if call ID 0 is supplied no new selection is made.

 (*) RXRPC_SELECT_CALL_FOR_RECV:

     This affects recvmsg().  If set, recvmsg() will only see the specified
     call until the selection is cleared.  The selection is automatically
     cleared when the matching call termination message is passed to
     userspace by recvmsg().

     In the future, this will be used to configure things like splice-out
     and SIOCINQ.  If a selection is set, splice and SIOCINQ will access
     only the selected call.

 (*) RXRPC_SELECT_CALL_FOR_SEND:

     Future patches will use this to configure sendfile(), splice-in and
     SIOCOUTQ.  This does not affect sendmsg() as that is given the call ID
     through the control message.

When used with sockets that are bound together, these only affect the
socket they're set on and not any other sockets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/rxrpc.h |    2 +
 net/rxrpc/af_rxrpc.c       |  126 ++++++++++++++++++++++++++++++++++++++++++--
 net/rxrpc/ar-internal.h    |    2 +
 3 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/rxrpc.h b/include/uapi/linux/rxrpc.h
index 811923643751..b4bbaa809b78 100644
--- a/include/uapi/linux/rxrpc.h
+++ b/include/uapi/linux/rxrpc.h
@@ -37,6 +37,8 @@ struct sockaddr_rxrpc {
 #define RXRPC_UPGRADEABLE_SERVICE	5	/* Upgrade service[0] -> service[1] */
 #define RXRPC_SUPPORTED_CMSG		6	/* Get highest supported control message type */
 #define RXRPC_BIND_CHANNEL		7	/* Bind a socket as an additional recvmsg channel */
+#define RXRPC_SELECT_CALL_FOR_RECV	8	/* Specify the call for recvmsg, SIOCINQ, etc. */
+#define RXRPC_SELECT_CALL_FOR_SEND	9	/* Specify the call for splice, SIOCOUTQ, etc. */
 
 /*
  * RxRPC control messages
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 6b89a5a969e0..8ac014aff7a2 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -798,6 +798,54 @@ static int rxrpc_bind_channel(struct rxrpc_sock *rx2, int fd)
 	return ret;
 }
 
+/*
+ * Set the default call for 'targetless' operations such as splice(), SIOCINQ
+ * and SIOCOUTQ and also as a filter for recvmsg().  Calling this function
+ * always clears the old call attachment, and specifying a call_id
+ * of 0 doesn't attach a new call.
+ */
+static int rxrpc_set_select_call(struct rxrpc_sock *rx, unsigned long call_id,
+				 int optname)
+{
+	struct rxrpc_call *call, *old;
+
+	write_lock_bh(&rx->recvmsg_lock);
+	if (optname == RXRPC_SELECT_CALL_FOR_RECV) {
+		old = rx->selected_recv_call;
+		rx->selected_recv_call = NULL;
+	} else {
+		old = rx->selected_send_call;
+		rx->selected_send_call = NULL;
+	}
+	write_unlock_bh(&rx->recvmsg_lock);
+
+	if (old)
+		rxrpc_put_call(old, rxrpc_call_put);
+
+	if (!call_id)
+		return 0;
+
+	call = rxrpc_find_call_by_user_ID(rx, call_id);
+	if (!call)
+		return -EBADSLT;
+
+	switch (call->state) {
+	case RXRPC_CALL_UNINITIALISED:
+	case RXRPC_CALL_SERVER_PREALLOC:
+	case RXRPC_CALL_SERVER_SECURING:
+		rxrpc_put_call(call, rxrpc_call_put);
+		return -EBUSY;
+	default:
+		write_lock_bh(&rx->recvmsg_lock);
+		if (optname == RXRPC_SELECT_CALL_FOR_RECV)
+			rx->selected_recv_call = call;
+		else
+			rx->selected_send_call = call;
+		write_unlock_bh(&rx->recvmsg_lock);
+	}
+	return 0;
+}
+
 /*
  * set RxRPC socket options
  */
@@ -805,6 +853,7 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
+	unsigned long long call_id;
 	unsigned int min_sec_level;
 	u16 service_upgrade[2];
 	int ret, fd;
@@ -894,9 +943,24 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 				goto error;
 			goto success;
 
+		case RXRPC_SELECT_CALL_FOR_RECV:
+		case RXRPC_SELECT_CALL_FOR_SEND:
+#warning compat_setsockopt disappeared
+			ret = -EINVAL;
+			if (optlen != sizeof(call_id))
+				goto error;
+			ret = -EFAULT;
+			if (copy_from_sockptr(&call_id, optval,
+					      sizeof(call_id)) != 0)
+				goto error;
+			ret = rxrpc_set_select_call(rx, call_id, optname);
+			goto error;
+
 		default:
-			break;
+			goto error;
 		}
+	} else {
+		goto error;
 	}
 
 success:
@@ -912,7 +976,10 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 static int rxrpc_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *_optlen)
 {
+	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
+	unsigned long call_id;
 	int optlen;
+	int ret;
 
 	if (level != SOL_RXRPC)
 		return -EOPNOTSUPP;
@@ -920,18 +987,57 @@ static int rxrpc_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(optlen, _optlen))
 		return -EFAULT;
 
+	lock_sock(&rx->sk);
+
 	switch (optname) {
 	case RXRPC_SUPPORTED_CMSG:
+		ret = -ETOOSMALL;
 		if (optlen < sizeof(int))
-			return -ETOOSMALL;
+			break;
+		ret = -EFAULT;
 		if (put_user(RXRPC__SUPPORTED - 1, (int __user *)optval) ||
 		    put_user(sizeof(int), _optlen))
-			return -EFAULT;
-		return 0;
+			break;
+		ret = 0;
+		break;
+
+	case RXRPC_SELECT_CALL_FOR_RECV:
+		ret = -ETOOSMALL;
+		if (optlen < sizeof(unsigned long))
+			break;
+		read_lock_bh(&rx->recvmsg_lock);
+		call_id = rx->selected_recv_call ?
+			rx->selected_recv_call->user_call_ID : 0;
+		read_unlock_bh(&rx->recvmsg_lock);
+		ret = -EFAULT;
+		if (put_user(call_id, (unsigned long __user *)optval) ||
+		    put_user(sizeof(unsigned long), _optlen))
+			break;
+		ret = 0;
+		break;
+
+	case RXRPC_SELECT_CALL_FOR_SEND:
+		ret = -ETOOSMALL;
+		if (optlen < sizeof(unsigned long))
+			break;
+		read_lock_bh(&rx->recvmsg_lock);
+		call_id = rx->selected_send_call ?
+			rx->selected_send_call->user_call_ID : 0;
+		read_unlock_bh(&rx->recvmsg_lock);
+		ret = -EFAULT;
+		if (put_user(call_id, (unsigned long __user *)optval) ||
+		    put_user(sizeof(unsigned long), _optlen))
+			break;
+		ret = 0;
+		break;
 
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		break;
 	}
+
+	release_sock(&rx->sk);
+	return ret;
 }
 
 /*
@@ -1087,6 +1193,16 @@ static int rxrpc_release_sock(struct sock *sk)
 	if (rx->service)
 		rxrpc_deactivate_service(rx);
 
+	if (rx->selected_recv_call) {
+		rxrpc_put_call(rx->selected_recv_call, rxrpc_call_put);
+		rx->selected_recv_call = NULL;
+	}
+
+	if (rx->selected_send_call) {
+		rxrpc_put_call(rx->selected_send_call, rxrpc_call_put);
+		rx->selected_send_call = NULL;
+	}
+
 	/* We want to kill off all connections from a service socket
 	 * as fast as possible because we can't share these; client
 	 * sockets, on the other hand, can share an endpoint.
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 89f86c31a50b..ec2c614082b9 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -170,6 +170,8 @@ struct rxrpc_sock {
 	struct rb_root		calls;		/* User ID -> call mapping */
 	unsigned long		flags;
 #define RXRPC_SOCK_CONNECTED	0		/* connect_srx is set */
+	struct rxrpc_call	*selected_recv_call; /* Selected call for receive (or 0) */
+	struct rxrpc_call	*selected_send_call; /* Selected call for send (or 0) */
 	rwlock_t		call_lock;	/* lock for calls */
 	u32			min_sec_level;	/* minimum security level */
 #define RXRPC_SECURITY_MAX	RXRPC_SECURITY_ENCRYPT


