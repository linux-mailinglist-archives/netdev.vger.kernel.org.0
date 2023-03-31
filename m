Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9F6D255D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjCaQXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjCaQW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DBF25543
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejDFB6GslgSZqdhXNjSzgpO0TYgGHDllqYvzU5uLDLo=;
        b=bawT90mGqMy2GFCyTv2tRa7Qui9u+IYBtFjIDRqqpd3punShWS+K1AOhYMo/4c44vX8d8q
        m0Qbugw+8JlwAqMp10maaFL1JPXQEel8M/abmjnyIOaM6rOIhds/VgRWJmH7aJR4OtnJq8
        KzD2JbKM1sVmTI+zVWvuO9HS7w2IXdo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-yCDTb6EqOze4c3qxvyUDQA-1; Fri, 31 Mar 2023 12:11:58 -0400
X-MC-Unique: yCDTb6EqOze4c3qxvyUDQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A69C73801EC3;
        Fri, 31 Mar 2023 16:11:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA58B1415139;
        Fri, 31 Mar 2023 16:11:52 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, bpf@vger.kernel.org,
        dccp@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-can@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-x25@vger.kernel.org, mptcp@lists.linux.dev,
        rds-devel@oss.oracle.com, tipc-discussion@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 55/55] sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)
Date:   Fri, 31 Mar 2023 17:09:14 +0100
Message-Id: <20230331160914.1608208-56-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove ->sendpage() and ->sendpage_locked().  sendmsg() with
MSG_SPLICE_PAGES should be used instead.  This allows multiple pages and
multipage folios to be passed through.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: bpf@vger.kernel.org
cc: dccp@vger.kernel.org
cc: linux-afs@lists.infradead.org
cc: linux-arm-msm@vger.kernel.org
cc: linux-can@vger.kernel.org
cc: linux-crypto@vger.kernel.org
cc: linux-doc@vger.kernel.org
cc: linux-hams@vger.kernel.org
cc: linux-kernel@vger.kernel.org
cc: linux-rdma@vger.kernel.org
cc: linux-sctp@vger.kernel.org
cc: linux-wpan@vger.kernel.org
cc: linux-x25@vger.kernel.org
cc: mptcp@lists.linux.dev
cc: netdev@vger.kernel.org
cc: rds-devel@oss.oracle.com
cc: tipc-discussion@lists.sourceforge.net
cc: virtualization@lists.linux-foundation.org
---
 Documentation/networking/scaling.rst          |   4 +-
 crypto/af_alg.c                               |  29 ----
 crypto/algif_aead.c                           |  22 +--
 crypto/algif_rng.c                            |   2 -
 crypto/algif_skcipher.c                       |  14 --
 .../chelsio/inline_crypto/chtls/chtls.h       |   2 -
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  14 --
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   1 -
 include/linux/net.h                           |   8 -
 include/net/inet_common.h                     |   2 -
 include/net/sock.h                            |   6 -
 net/appletalk/ddp.c                           |   1 -
 net/atm/pvc.c                                 |   1 -
 net/atm/svc.c                                 |   1 -
 net/ax25/af_ax25.c                            |   1 -
 net/caif/caif_socket.c                        |   2 -
 net/can/bcm.c                                 |   1 -
 net/can/isotp.c                               |   1 -
 net/can/j1939/socket.c                        |   1 -
 net/can/raw.c                                 |   1 -
 net/core/sock.c                               |  35 +----
 net/dccp/ipv4.c                               |   1 -
 net/dccp/ipv6.c                               |   1 -
 net/ieee802154/socket.c                       |   2 -
 net/ipv4/af_inet.c                            |  21 ---
 net/ipv4/tcp.c                                |  34 -----
 net/ipv4/tcp_bpf.c                            |  21 +--
 net/ipv4/tcp_ipv4.c                           |   1 -
 net/ipv4/udp.c                                |  22 ---
 net/ipv4/udp_impl.h                           |   2 -
 net/ipv4/udplite.c                            |   1 -
 net/ipv6/af_inet6.c                           |   3 -
 net/ipv6/raw.c                                |   1 -
 net/ipv6/tcp_ipv6.c                           |   1 -
 net/kcm/kcmsock.c                             |  20 ---
 net/key/af_key.c                              |   1 -
 net/l2tp/l2tp_ip.c                            |   1 -
 net/l2tp/l2tp_ip6.c                           |   1 -
 net/llc/af_llc.c                              |   1 -
 net/mctp/af_mctp.c                            |   1 -
 net/mptcp/protocol.c                          |   2 -
 net/netlink/af_netlink.c                      |   1 -
 net/netrom/af_netrom.c                        |   1 -
 net/packet/af_packet.c                        |   2 -
 net/phonet/socket.c                           |   2 -
 net/qrtr/af_qrtr.c                            |   1 -
 net/rds/af_rds.c                              |   1 -
 net/rose/af_rose.c                            |   1 -
 net/rxrpc/af_rxrpc.c                          |   1 -
 net/sctp/protocol.c                           |   1 -
 net/socket.c                                  |  48 ------
 net/tipc/socket.c                             |   3 -
 net/tls/tls_main.c                            |   7 -
 net/unix/af_unix.c                            | 139 ------------------
 net/vmw_vsock/af_vsock.c                      |   3 -
 net/x25/af_x25.c                              |   1 -
 net/xdp/xsk.c                                 |   1 -
 57 files changed, 9 insertions(+), 491 deletions(-)

diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 3d435caa3ef2..92c9fb46d6a2 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -269,8 +269,8 @@ a single application thread handles flows with many different flow hashes.
 rps_sock_flow_table is a global flow table that contains the *desired* CPU
 for flows: the CPU that is currently processing the flow in userspace.
 Each table value is a CPU index that is updated during calls to recvmsg
-and sendmsg (specifically, inet_recvmsg(), inet_sendmsg(), inet_sendpage()
-and tcp_splice_read()).
+and sendmsg (specifically, inet_recvmsg(), inet_sendmsg() and
+tcp_splice_read()).
 
 When the scheduler moves a thread to a new CPU while it has outstanding
 receive packets on the old CPU, packets may arrive out of order. To
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 686610a4986f..9f84816dcabf 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -483,7 +483,6 @@ static const struct proto_ops alg_proto_ops = {
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
 	.mmap		=	sock_no_mmap,
-	.sendpage	=	sock_no_sendpage,
 	.sendmsg	=	sock_no_sendmsg,
 	.recvmsg	=	sock_no_recvmsg,
 
@@ -1110,34 +1109,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 }
 EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 
-/**
- * af_alg_sendpage - sendpage system call handler
- * @sock: socket of connection to user space to write to
- * @page: data to send
- * @offset: offset into page to begin sending
- * @size: length of data
- * @flags: message send/receive flags
- *
- * This is a generic implementation of sendpage to fill ctx->tsgl_list.
- */
-ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
-			int offset, size_t size, int flags)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = {
-		.msg_flags = flags | MSG_SPLICE_PAGES,
-	};
-
-	bvec_set_page(&bvec, page, size, offset);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	return sock_sendmsg(sock, &msg);
-}
-EXPORT_SYMBOL_GPL(af_alg_sendpage);
-
 /**
  * af_alg_free_resources - release resources required for crypto request
  * @areq: Request holding the TX and RX SGL
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index b16111a3025a..37b08e5f9114 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -9,10 +9,10 @@
  * The following concept of the memory management is used:
  *
  * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
- * filled by user space with the data submitted via sendpage. Filling up
- * the TX SGL does not cause a crypto operation -- the data will only be
- * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
- * provide a buffer which is tracked with the RX SGL.
+ * filled by user space with the data submitted via sendmsg (maybe with with
+ * MSG_SPLICE_PAGES).  Filling up the TX SGL does not cause a crypto operation
+ * -- the data will only be tracked by the kernel. Upon receipt of one recvmsg
+ * call, the caller must provide a buffer which is tracked with the RX SGL.
  *
  * During the processing of the recvmsg operation, the cipher request is
  * allocated and prepared. As part of the recvmsg operation, the processed
@@ -368,7 +368,6 @@ static struct proto_ops algif_aead_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	aead_sendmsg,
-	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	aead_recvmsg,
 	.poll		=	af_alg_poll,
 };
@@ -420,18 +419,6 @@ static int aead_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	return aead_sendmsg(sock, msg, size);
 }
 
-static ssize_t aead_sendpage_nokey(struct socket *sock, struct page *page,
-				       int offset, size_t size, int flags)
-{
-	int err;
-
-	err = aead_check_key(sock);
-	if (err)
-		return err;
-
-	return af_alg_sendpage(sock, page, offset, size, flags);
-}
-
 static int aead_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
 				  size_t ignored, int flags)
 {
@@ -459,7 +446,6 @@ static struct proto_ops algif_aead_ops_nokey = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	aead_sendmsg_nokey,
-	.sendpage	=	aead_sendpage_nokey,
 	.recvmsg	=	aead_recvmsg_nokey,
 	.poll		=	af_alg_poll,
 };
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 407408c43730..10c41adac3b1 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -174,7 +174,6 @@ static struct proto_ops algif_rng_ops = {
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
 	.sendmsg	=	sock_no_sendmsg,
-	.sendpage	=	sock_no_sendpage,
 
 	.release	=	af_alg_release,
 	.recvmsg	=	rng_recvmsg,
@@ -192,7 +191,6 @@ static struct proto_ops __maybe_unused algif_rng_test_ops = {
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.sendpage	=	sock_no_sendpage,
 
 	.release	=	af_alg_release,
 	.recvmsg	=	rng_test_recvmsg,
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index b1f321b9f846..9ada9b741af8 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -194,7 +194,6 @@ static struct proto_ops algif_skcipher_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	skcipher_sendmsg,
-	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
 	.poll		=	af_alg_poll,
 };
@@ -246,18 +245,6 @@ static int skcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	return skcipher_sendmsg(sock, msg, size);
 }
 
-static ssize_t skcipher_sendpage_nokey(struct socket *sock, struct page *page,
-				       int offset, size_t size, int flags)
-{
-	int err;
-
-	err = skcipher_check_key(sock);
-	if (err)
-		return err;
-
-	return af_alg_sendpage(sock, page, offset, size, flags);
-}
-
 static int skcipher_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
 				  size_t ignored, int flags)
 {
@@ -285,7 +272,6 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	skcipher_sendmsg_nokey,
-	.sendpage	=	skcipher_sendpage_nokey,
 	.recvmsg	=	skcipher_recvmsg_nokey,
 	.poll		=	af_alg_poll,
 };
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 41714203ace8..94760a681566 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -568,8 +568,6 @@ void chtls_destroy_sock(struct sock *sk);
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int chtls_recvmsg(struct sock *sk, struct msghdr *msg,
 		  size_t len, int flags, int *addr_len);
-int chtls_sendpage(struct sock *sk, struct page *page,
-		   int offset, size_t size, int flags);
 int send_tx_flowc_wr(struct sock *sk, int compl,
 		     u32 snd_nxt, u32 rcv_nxt);
 void chtls_tcp_push(struct sock *sk, int flags);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 5c397cb57300..fb44333efa3e 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1285,20 +1285,6 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	goto done;
 }
 
-int chtls_sendpage(struct sock *sk, struct page *page,
-		   int offset, size_t size, int flags)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	bvec_set_page(&bvec, page, offset, size);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-	return chtls_sendmsg(sk, &msg, size);
-}
-
 static void chtls_select_window(struct sock *sk)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
index 1e55b12fee51..1b8e6994e8fe 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -606,7 +606,6 @@ static void __init chtls_init_ulp_ops(void)
 	chtls_cpl_prot.destroy		= chtls_destroy_sock;
 	chtls_cpl_prot.shutdown		= chtls_shutdown;
 	chtls_cpl_prot.sendmsg		= chtls_sendmsg;
-	chtls_cpl_prot.sendpage		= chtls_sendpage;
 	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
 	chtls_cpl_prot.setsockopt	= chtls_setsockopt;
 	chtls_cpl_prot.getsockopt	= chtls_getsockopt;
diff --git a/include/linux/net.h b/include/linux/net.h
index b73ad8e3c212..e5794968ac9f 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -206,8 +206,6 @@ struct proto_ops {
 				      size_t total_len, int flags);
 	int		(*mmap)	     (struct file *file, struct socket *sock,
 				      struct vm_area_struct * vma);
-	ssize_t		(*sendpage)  (struct socket *sock, struct page *page,
-				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
 	int		(*set_peek_off)(struct sock *sk, int val);
@@ -220,8 +218,6 @@ struct proto_ops {
 				     sk_read_actor_t recv_actor);
 	/* This is different from read_sock(), it reads an entire skb at a time. */
 	int		(*read_skb)(struct sock *sk, skb_read_actor_t recv_actor);
-	int		(*sendpage_locked)(struct sock *sk, struct page *page,
-					   int offset, size_t size, int flags);
 	int		(*sendmsg_locked)(struct sock *sk, struct msghdr *msg,
 					  size_t size);
 	int		(*set_rcvlowat)(struct sock *sk, int val);
@@ -339,10 +335,6 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags);
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
-int kernel_sendpage(struct socket *sock, struct page *page, int offset,
-		    size_t size, int flags);
-int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
-			   size_t size, int flags);
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how);
 
 /* Routine returns the IP overhead imposed by a (caller-protected) socket. */
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cec453c18f1d..054c3388fa51 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -33,8 +33,6 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
 int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
-ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
-		      size_t size, int flags);
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		 int flags);
 int inet_shutdown(struct socket *sock, int how);
diff --git a/include/net/sock.h b/include/net/sock.h
index 573f2bf7e0de..4618cd21e16b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1265,8 +1265,6 @@ struct proto {
 					   size_t len);
 	int			(*recvmsg)(struct sock *sk, struct msghdr *msg,
 					   size_t len, int flags, int *addr_len);
-	int			(*sendpage)(struct sock *sk, struct page *page,
-					int offset, size_t size, int flags);
 	int			(*bind)(struct sock *sk,
 					struct sockaddr *addr, int addr_len);
 	int			(*bind_add)(struct sock *sk,
@@ -1906,10 +1904,6 @@ int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
 int sock_no_recvmsg(struct socket *, struct msghdr *, size_t, int);
 int sock_no_mmap(struct file *file, struct socket *sock,
 		 struct vm_area_struct *vma);
-ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset,
-			 size_t size, int flags);
-ssize_t sock_no_sendpage_locked(struct sock *sk, struct page *page,
-				int offset, size_t size, int flags);
 
 /*
  * Functions to fill in entries in struct proto_ops when a protocol
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index a06f4d4a6f47..8978fb6212ff 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1929,7 +1929,6 @@ static const struct proto_ops atalk_dgram_ops = {
 	.sendmsg	= atalk_sendmsg,
 	.recvmsg	= atalk_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 static struct notifier_block ddp_notifier = {
diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index 53e7d3f39e26..66d9a9bd5896 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -126,7 +126,6 @@ static const struct proto_ops pvc_proto_ops = {
 	.sendmsg =	vcc_sendmsg,
 	.recvmsg =	vcc_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 4a02bcaad279..289240fe234e 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -649,7 +649,6 @@ static const struct proto_ops svc_proto_ops = {
 	.sendmsg =	vcc_sendmsg,
 	.recvmsg =	vcc_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d8da400cb4de..5db805d5f74d 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -2022,7 +2022,6 @@ static const struct proto_ops ax25_proto_ops = {
 	.sendmsg	= ax25_sendmsg,
 	.recvmsg	= ax25_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 /*
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 4eebcc66c19a..9c82698da4f5 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -976,7 +976,6 @@ static const struct proto_ops caif_seqpacket_ops = {
 	.sendmsg = caif_seqpkt_sendmsg,
 	.recvmsg = caif_seqpkt_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 static const struct proto_ops caif_stream_ops = {
@@ -996,7 +995,6 @@ static const struct proto_ops caif_stream_ops = {
 	.sendmsg = caif_stream_sendmsg,
 	.recvmsg = caif_stream_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 /* This function is called when a socket is finally destroyed. */
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 27706f6ace34..65a946a36d92 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1699,7 +1699,6 @@ static const struct proto_ops bcm_ops = {
 	.sendmsg       = bcm_sendmsg,
 	.recvmsg       = bcm_recvmsg,
 	.mmap          = sock_no_mmap,
-	.sendpage      = sock_no_sendpage,
 };
 
 static struct proto bcm_proto __read_mostly = {
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..0c3d11c29a2b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1633,7 +1633,6 @@ static const struct proto_ops isotp_ops = {
 	.sendmsg = isotp_sendmsg,
 	.recvmsg = isotp_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 static struct proto isotp_proto __read_mostly = {
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 7e90f9e61d9b..2bfe4f79bb67 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1301,7 +1301,6 @@ static const struct proto_ops j1939_ops = {
 	.sendmsg = j1939_sk_sendmsg,
 	.recvmsg = j1939_sk_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 static struct proto j1939_proto __read_mostly = {
diff --git a/net/can/raw.c b/net/can/raw.c
index f64469b98260..15c79b079184 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -962,7 +962,6 @@ static const struct proto_ops raw_ops = {
 	.sendmsg       = raw_sendmsg,
 	.recvmsg       = raw_recvmsg,
 	.mmap          = sock_no_mmap,
-	.sendpage      = sock_no_sendpage,
 };
 
 static struct proto raw_proto __read_mostly = {
diff --git a/net/core/sock.c b/net/core/sock.c
index 341c565dbc26..c2ae77bb2075 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3223,36 +3223,6 @@ void __receive_sock(struct file *file)
 	}
 }
 
-ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags)
-{
-	ssize_t res;
-	struct msghdr msg = {.msg_flags = flags};
-	struct kvec iov;
-	char *kaddr = kmap(page);
-	iov.iov_base = kaddr + offset;
-	iov.iov_len = size;
-	res = kernel_sendmsg(sock, &msg, &iov, 1, size);
-	kunmap(page);
-	return res;
-}
-EXPORT_SYMBOL(sock_no_sendpage);
-
-ssize_t sock_no_sendpage_locked(struct sock *sk, struct page *page,
-				int offset, size_t size, int flags)
-{
-	ssize_t res;
-	struct msghdr msg = {.msg_flags = flags};
-	struct kvec iov;
-	char *kaddr = kmap(page);
-
-	iov.iov_base = kaddr + offset;
-	iov.iov_len = size;
-	res = kernel_sendmsg_locked(sk, &msg, &iov, 1, size);
-	kunmap(page);
-	return res;
-}
-EXPORT_SYMBOL(sock_no_sendpage_locked);
-
 /*
  *	Default Socket Callbacks
  */
@@ -4008,7 +3978,7 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 {
 
 	seq_printf(seq, "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s "
-			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
+			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
 		   proto->name,
 		   proto->obj_size,
 		   sock_prot_inuse_get(seq_file_net(seq), proto),
@@ -4029,7 +3999,6 @@ static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
 		   proto_method_implemented(proto->getsockopt),
 		   proto_method_implemented(proto->sendmsg),
 		   proto_method_implemented(proto->recvmsg),
-		   proto_method_implemented(proto->sendpage),
 		   proto_method_implemented(proto->bind),
 		   proto_method_implemented(proto->backlog_rcv),
 		   proto_method_implemented(proto->hash),
@@ -4050,7 +4019,7 @@ static int proto_seq_show(struct seq_file *seq, void *v)
 			   "maxhdr",
 			   "slab",
 			   "module",
-			   "cl co di ac io in de sh ss gs se re sp bi br ha uh gp em\n");
+			   "cl co di ac io in de sh ss gs se re bi br ha uh gp em\n");
 	else
 		proto_seq_printf(seq, list_entry(v, struct proto, node));
 	return 0;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index b780827f5e0a..ea808de374ea 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -1008,7 +1008,6 @@ static const struct proto_ops inet_dccp_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 };
 
 static struct inet_protosw dccp_v4_protosw = {
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b9d7c3dd1cb3..23eb8159e3cd 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1085,7 +1085,6 @@ static const struct proto_ops inet6_dccp_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
 #endif
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 1fa2fe041ec0..1238f036117f 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -426,7 +426,6 @@ static const struct proto_ops ieee802154_raw_ops = {
 	.sendmsg	   = ieee802154_sock_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 };
 
 /* DGRAM Sockets (802.15.4 dataframes) */
@@ -990,7 +989,6 @@ static const struct proto_ops ieee802154_dgram_ops = {
 	.sendmsg	   = ieee802154_sock_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 };
 
 static void ieee802154_sock_destruct(struct sock *sk)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8db6747f892f..869b49933f15 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -827,23 +827,6 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
-ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
-		      size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	const struct proto *prot;
-
-	if (unlikely(inet_send_prepare(sk)))
-		return -EAGAIN;
-
-	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
-	prot = READ_ONCE(sk->sk_prot);
-	if (prot->sendpage)
-		return prot->sendpage(sk, page, offset, size, flags);
-	return sock_no_sendpage(sock, page, offset, size, flags);
-}
-EXPORT_SYMBOL(inet_sendpage);
-
 INDIRECT_CALLABLE_DECLARE(int udp_recvmsg(struct sock *, struct msghdr *,
 					  size_t, int, int *));
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
@@ -1046,12 +1029,10 @@ const struct proto_ops inet_stream_ops = {
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
-	.sendpage	   = inet_sendpage,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
 	.read_skb	   = tcp_read_skb,
 	.sendmsg_locked    = tcp_sendmsg_locked,
-	.sendpage_locked   = tcp_sendpage_locked,
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet_compat_ioctl,
@@ -1080,7 +1061,6 @@ const struct proto_ops inet_dgram_ops = {
 	.read_skb	   = udp_read_skb,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = inet_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet_compat_ioctl,
@@ -1111,7 +1091,6 @@ static const struct proto_ops inet_sockraw_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet_compat_ioctl,
 #endif
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a8f8ccaed10e..bd01a1b23c7b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -971,40 +971,6 @@ static int tcp_wmem_schedule(struct sock *sk, int copy)
 	return min(copy, sk->sk_forward_alloc);
 }
 
-int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
-			size_t size, int flags)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
-
-	if (!(sk->sk_route_caps & NETIF_F_SG))
-		return sock_no_sendpage_locked(sk, page, offset, size, flags);
-
-	tcp_rate_check_app_limited(sk);  /* is sending application-limited? */
-
-	bvec_set_page(&bvec, page, size, offset);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	return tcp_sendmsg_locked(sk, &msg, size);
-}
-EXPORT_SYMBOL_GPL(tcp_sendpage_locked);
-
-int tcp_sendpage(struct sock *sk, struct page *page, int offset,
-		 size_t size, int flags)
-{
-	int ret;
-
-	lock_sock(sk);
-	ret = tcp_sendpage_locked(sk, page, offset, size, flags);
-	release_sock(sk);
-
-	return ret;
-}
-EXPORT_SYMBOL(tcp_sendpage);
-
 void tcp_free_fastopen_req(struct tcp_sock *tp)
 {
 	if (tp->fastopen_req) {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index de37a4372437..ab83cfb9de22 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -482,23 +482,6 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	return copied ? copied : err;
 }
 
-static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
-			    size_t size, int flags)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = {
-		.msg_flags = flags | MSG_SPLICE_PAGES,
-	};
-
-	bvec_set_page(&bvec, page, size, offset);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	return tcp_bpf_sendmsg(sk, &msg, size);
-}
-
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
@@ -528,7 +511,6 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
-	prot[TCP_BPF_TX].sendpage		= tcp_bpf_sendpage;
 
 	prot[TCP_BPF_RX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_RX].recvmsg		= tcp_bpf_recvmsg_parser;
@@ -563,8 +545,7 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	 * indeed valid assumptions.
 	 */
 	return ops->recvmsg  == tcp_recvmsg &&
-	       ops->sendmsg  == tcp_sendmsg &&
-	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
+	       ops->sendmsg  == tcp_sendmsg ? 0 : -ENOTSUPP;
 }
 
 int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea370afa70ed..5c2e1c1ca329 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3112,7 +3112,6 @@ struct proto tcp_prot = {
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
-	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.release_cb		= tcp_release_cb,
 	.hash			= inet_hash,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 097feb92e215..85bd5960f7ef 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1329,27 +1329,6 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 }
 EXPORT_SYMBOL(udp_sendmsg);
 
-int udp_sendpage(struct sock *sk, struct page *page, int offset,
-		 size_t size, int flags)
-{
-	struct bio_vec bvec;
-	struct msghdr msg = {
-		.msg_flags = flags | MSG_SPLICE_PAGES | MSG_MORE
-	};
-	int ret;
-
-	bvec_set_page(&bvec, page, size, offset);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	lock_sock(sk);
-	ret = udp_sendmsg(sk, &msg, size);
-	release_sock(sk);
-	return ret;
-}
-
 #define UDP_SKB_IS_STATELESS 0x80000000
 
 /* all head states (dst, sk, nf conntrack) except skb extensions are
@@ -2926,7 +2905,6 @@ struct proto udp_prot = {
 	.getsockopt		= udp_getsockopt,
 	.sendmsg		= udp_sendmsg,
 	.recvmsg		= udp_recvmsg,
-	.sendpage		= udp_sendpage,
 	.release_cb		= ip4_datagram_release_cb,
 	.hash			= udp_lib_hash,
 	.unhash			= udp_lib_unhash,
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index 4ba7a88a1b1d..e1ff3a375996 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -19,8 +19,6 @@ int udp_getsockopt(struct sock *sk, int level, int optname,
 
 int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		int *addr_len);
-int udp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
-		 int flags);
 void udp_destroy_sock(struct sock *sk);
 
 #ifdef CONFIG_PROC_FS
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index e0c9cc39b81e..69870f0afc6c 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -54,7 +54,6 @@ struct proto 	udplite_prot = {
 	.getsockopt	   = udp_getsockopt,
 	.sendmsg	   = udp_sendmsg,
 	.recvmsg	   = udp_recvmsg,
-	.sendpage	   = udp_sendpage,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
 	.rehash		   = udp_v4_rehash,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce7..769c76d59053 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,9 +695,7 @@ const struct proto_ops inet6_stream_ops = {
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
-	.sendpage	   = inet_sendpage,
 	.sendmsg_locked    = tcp_sendmsg_locked,
-	.sendpage_locked   = tcp_sendpage_locked,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
 	.read_skb	   = tcp_read_skb,
@@ -728,7 +726,6 @@ const struct proto_ops inet6_dgram_ops = {
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
 	.read_skb	   = udp_read_skb,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index bac9ba747bde..c6c062678c0e 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1298,7 +1298,6 @@ const struct proto_ops inet6_sockraw_ops = {
 	.sendmsg	   = inet_sendmsg,		/* ok		*/
 	.recvmsg	   = sock_common_recvmsg,	/* ok		*/
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1bf93b61aa06..03ba1e389901 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2151,7 +2151,6 @@ struct proto tcpv6_prot = {
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
-	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.release_cb		= tcp_release_cb,
 	.hash			= inet6_hash,
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 9c9d379aafb1..94442e359fe2 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1005,24 +1005,6 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
-			    int offset, size_t size, int flags)
-
-{
-	struct bio_vec bvec;
-	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
-
-	if (flags & MSG_OOB)
-		return -EOPNOTSUPP;
-
-	bvec_set_page(&bvec, page, offset, size);
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
-	return kcm_sendmsg(sock, &msg, size);
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
@@ -1810,7 +1792,6 @@ static const struct proto_ops kcm_dgram_ops = {
 	.sendmsg =	kcm_sendmsg,
 	.recvmsg =	kcm_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	kcm_sendpage,
 };
 
 static const struct proto_ops kcm_seqpacket_ops = {
@@ -1831,7 +1812,6 @@ static const struct proto_ops kcm_seqpacket_ops = {
 	.sendmsg =	kcm_sendmsg,
 	.recvmsg =	kcm_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	kcm_sendpage,
 	.splice_read =	kcm_splice_read,
 };
 
diff --git a/net/key/af_key.c b/net/key/af_key.c
index a815f5ab4c49..bf59d42dc697 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3757,7 +3757,6 @@ static const struct proto_ops pfkey_ops = {
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
 	.mmap		=	sock_no_mmap,
-	.sendpage	=	sock_no_sendpage,
 
 	/* Now the operations that really occur. */
 	.release	=	pfkey_release,
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4db5a554bdbd..d0dcbe3a4cd7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -625,7 +625,6 @@ static const struct proto_ops l2tp_ip_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 };
 
 static struct inet_protosw l2tp_ip_protosw = {
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2478aa60145f..49296ce14a90 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -751,7 +751,6 @@ static const struct proto_ops l2tp_ip6_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = sock_common_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
 #endif
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index da7fe94bea2e..addd94da2a81 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1230,7 +1230,6 @@ static const struct proto_ops llc_ui_ops = {
 	.sendmsg     = llc_ui_sendmsg,
 	.recvmsg     = llc_ui_recvmsg,
 	.mmap	     = sock_no_mmap,
-	.sendpage    = sock_no_sendpage,
 };
 
 static const char llc_proc_err_msg[] __initconst =
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 3150f3f0c872..c6fe2e6b85dd 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -485,7 +485,6 @@ static const struct proto_ops mctp_dgram_ops = {
 	.sendmsg	= mctp_sendmsg,
 	.recvmsg	= mctp_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mctp_compat_ioctl,
 #endif
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3ad9c46202fc..ade89b8d0082 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3816,7 +3816,6 @@ static const struct proto_ops mptcp_stream_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = inet_sendpage,
 };
 
 static struct inet_protosw mptcp_protosw = {
@@ -3911,7 +3910,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.sendmsg	   = inet6_sendmsg,
 	.recvmsg	   = inet6_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
 #endif
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c64277659753..f70073a3bb49 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2841,7 +2841,6 @@ static const struct proto_ops netlink_ops = {
 	.sendmsg =	netlink_sendmsg,
 	.recvmsg =	netlink_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 static const struct net_proto_family netlink_family_ops = {
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 5a4cb796150f..eb8ccbd58df7 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1364,7 +1364,6 @@ static const struct proto_ops nr_proto_ops = {
 	.sendmsg	=	nr_sendmsg,
 	.recvmsg	=	nr_recvmsg,
 	.mmap		=	sock_no_mmap,
-	.sendpage	=	sock_no_sendpage,
 };
 
 static struct notifier_block nr_dev_notifier = {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4e76e2ae153..385bd4982b80 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4604,7 +4604,6 @@ static const struct proto_ops packet_ops_spkt = {
 	.sendmsg =	packet_sendmsg_spkt,
 	.recvmsg =	packet_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 static const struct proto_ops packet_ops = {
@@ -4626,7 +4625,6 @@ static const struct proto_ops packet_ops = {
 	.sendmsg =	packet_sendmsg,
 	.recvmsg =	packet_recvmsg,
 	.mmap =		packet_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 static const struct net_proto_family packet_family_ops = {
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 71e2caf6ab85..a246f7d0a817 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -441,7 +441,6 @@ const struct proto_ops phonet_dgram_ops = {
 	.sendmsg	= pn_socket_sendmsg,
 	.recvmsg	= sock_common_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 const struct proto_ops phonet_stream_ops = {
@@ -462,7 +461,6 @@ const struct proto_ops phonet_stream_ops = {
 	.sendmsg	= pn_socket_sendmsg,
 	.recvmsg	= sock_common_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 EXPORT_SYMBOL(phonet_stream_ops);
 
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 5c2fb992803b..5bb7d680bd5f 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1240,7 +1240,6 @@ static const struct proto_ops qrtr_proto_ops = {
 	.shutdown	= sock_no_shutdown,
 	.release	= qrtr_release,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 static struct proto qrtr_proto = {
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 3ff6995244e5..01c4cdfef45d 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -653,7 +653,6 @@ static const struct proto_ops rds_proto_ops = {
 	.sendmsg =	rds_sendmsg,
 	.recvmsg =	rds_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 static void rds_sock_destruct(struct sock *sk)
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ca2b17f32670..49dafe9ac72f 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1496,7 +1496,6 @@ static const struct proto_ops rose_proto_ops = {
 	.sendmsg	=	rose_sendmsg,
 	.recvmsg	=	rose_recvmsg,
 	.mmap		=	sock_no_mmap,
-	.sendpage	=	sock_no_sendpage,
 };
 
 static struct notifier_block rose_dev_notifier = {
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 102f5cbff91a..182495804f8f 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -938,7 +938,6 @@ static const struct proto_ops rxrpc_rpc_ops = {
 	.sendmsg	= rxrpc_sendmsg,
 	.recvmsg	= rxrpc_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 static struct proto rxrpc_proto = {
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c365df24ad33..acb2d2a69268 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1135,7 +1135,6 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
-	.sendpage	   = sock_no_sendpage,
 };
 
 /* Registration with AF_INET family.  */
diff --git a/net/socket.c b/net/socket.c
index 3e9bd8261357..8c7437c983da 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3543,54 +3543,6 @@ int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(kernel_getpeername);
 
-/**
- *	kernel_sendpage - send a &page through a socket (kernel space)
- *	@sock: socket
- *	@page: page
- *	@offset: page offset
- *	@size: total size in bytes
- *	@flags: flags (MSG_DONTWAIT, ...)
- *
- *	Returns the total amount sent in bytes or an error.
- */
-
-int kernel_sendpage(struct socket *sock, struct page *page, int offset,
-		    size_t size, int flags)
-{
-	if (sock->ops->sendpage) {
-		/* Warn in case the improper page to zero-copy send */
-		WARN_ONCE(!sendpage_ok(page), "improper page for zero-copy send");
-		return sock->ops->sendpage(sock, page, offset, size, flags);
-	}
-	return sock_no_sendpage(sock, page, offset, size, flags);
-}
-EXPORT_SYMBOL(kernel_sendpage);
-
-/**
- *	kernel_sendpage_locked - send a &page through the locked sock (kernel space)
- *	@sk: sock
- *	@page: page
- *	@offset: page offset
- *	@size: total size in bytes
- *	@flags: flags (MSG_DONTWAIT, ...)
- *
- *	Returns the total amount sent in bytes or an error.
- *	Caller must hold @sk.
- */
-
-int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
-			   size_t size, int flags)
-{
-	struct socket *sock = sk->sk_socket;
-
-	if (sock->ops->sendpage_locked)
-		return sock->ops->sendpage_locked(sk, page, offset, size,
-						  flags);
-
-	return sock_no_sendpage_locked(sk, page, offset, size, flags);
-}
-EXPORT_SYMBOL(kernel_sendpage_locked);
-
 /**
  *	kernel_sock_shutdown - shut down part of a full-duplex connection (kernel space)
  *	@sock: socket
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 37edfe10f8c6..d2072fbf3272 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3375,7 +3375,6 @@ static const struct proto_ops msg_ops = {
 	.sendmsg	= tipc_sendmsg,
 	.recvmsg	= tipc_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage
 };
 
 static const struct proto_ops packet_ops = {
@@ -3396,7 +3395,6 @@ static const struct proto_ops packet_ops = {
 	.sendmsg	= tipc_send_packet,
 	.recvmsg	= tipc_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage
 };
 
 static const struct proto_ops stream_ops = {
@@ -3417,7 +3415,6 @@ static const struct proto_ops stream_ops = {
 	.sendmsg	= tipc_sendstream,
 	.recvmsg	= tipc_recvstream,
 	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage
 };
 
 static const struct net_proto_family tipc_family_ops = {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 35b2f7ee2fa3..ff02697f484b 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -936,7 +936,6 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 	ops[TLS_BASE][TLS_BASE] = *base;
 
 	ops[TLS_SW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
-	ops[TLS_SW  ][TLS_BASE].sendpage_locked	= tls_sw_sendpage_locked;
 
 	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
 	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
@@ -946,17 +945,14 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 
 #ifdef CONFIG_TLS_DEVICE
 	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
-	ops[TLS_HW  ][TLS_BASE].sendpage_locked	= NULL;
 
 	ops[TLS_HW  ][TLS_SW  ] = ops[TLS_BASE][TLS_SW  ];
-	ops[TLS_HW  ][TLS_SW  ].sendpage_locked	= NULL;
 
 	ops[TLS_BASE][TLS_HW  ] = ops[TLS_BASE][TLS_SW  ];
 
 	ops[TLS_SW  ][TLS_HW  ] = ops[TLS_SW  ][TLS_SW  ];
 
 	ops[TLS_HW  ][TLS_HW  ] = ops[TLS_HW  ][TLS_SW  ];
-	ops[TLS_HW  ][TLS_HW  ].sendpage_locked	= NULL;
 #endif
 #ifdef CONFIG_TLS_TOE
 	ops[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
@@ -1004,7 +1000,6 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
-	prot[TLS_SW][TLS_BASE].sendpage		= tls_sw_sendpage;
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_BASE][TLS_SW].recvmsg		  = tls_sw_recvmsg;
@@ -1019,11 +1014,9 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_HW][TLS_BASE].sendmsg		= tls_device_sendmsg;
-	prot[TLS_HW][TLS_BASE].sendpage		= tls_device_sendpage;
 
 	prot[TLS_HW][TLS_SW] = prot[TLS_BASE][TLS_SW];
 	prot[TLS_HW][TLS_SW].sendmsg		= tls_device_sendmsg;
-	prot[TLS_HW][TLS_SW].sendpage		= tls_device_sendpage;
 
 	prot[TLS_BASE][TLS_HW] = prot[TLS_BASE][TLS_SW];
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 88b91005567e..751715ade2ae 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -758,8 +758,6 @@ static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_stream_recvmsg(struct socket *, struct msghdr *, size_t, int);
-static ssize_t unix_stream_sendpage(struct socket *, struct page *, int offset,
-				    size_t size, int flags);
 static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       struct pipe_inode_info *, size_t size,
 				       unsigned int flags);
@@ -852,7 +850,6 @@ static const struct proto_ops unix_stream_ops = {
 	.recvmsg =	unix_stream_recvmsg,
 	.read_skb =	unix_stream_read_skb,
 	.mmap =		sock_no_mmap,
-	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
 	.set_peek_off =	unix_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
@@ -878,7 +875,6 @@ static const struct proto_ops unix_dgram_ops = {
 	.read_skb =	unix_read_skb,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 	.set_peek_off =	unix_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
 };
@@ -902,7 +898,6 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.sendmsg =	unix_seqpacket_sendmsg,
 	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 	.set_peek_off =	unix_set_peek_off,
 	.show_fdinfo =	unix_show_fdinfo,
 };
@@ -1839,24 +1834,6 @@ static void maybe_add_creds(struct sk_buff *skb, const struct socket *sock,
 	}
 }
 
-static int maybe_init_creds(struct scm_cookie *scm,
-			    struct socket *socket,
-			    const struct sock *other)
-{
-	int err;
-	struct msghdr msg = { .msg_controllen = 0 };
-
-	err = scm_send(socket, &msg, scm, false);
-	if (err)
-		return err;
-
-	if (unix_passcred_enabled(socket, other)) {
-		scm->pid = get_pid(task_tgid(current));
-		current_uid_gid(&scm->creds.uid, &scm->creds.gid);
-	}
-	return err;
-}
-
 static bool unix_skb_scm_eq(struct sk_buff *skb,
 			    struct scm_cookie *scm)
 {
@@ -2349,122 +2326,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	return sent ? : err;
 }
 
-static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
-				    int offset, size_t size, int flags)
-{
-	int err;
-	bool send_sigpipe = false;
-	bool init_scm = true;
-	struct scm_cookie scm;
-	struct sock *other, *sk = socket->sk;
-	struct sk_buff *skb, *newskb = NULL, *tail = NULL;
-
-	if (flags & MSG_OOB)
-		return -EOPNOTSUPP;
-
-	other = unix_peer(sk);
-	if (!other || sk->sk_state != TCP_ESTABLISHED)
-		return -ENOTCONN;
-
-	if (false) {
-alloc_skb:
-		unix_state_unlock(other);
-		mutex_unlock(&unix_sk(other)->iolock);
-		newskb = sock_alloc_send_pskb(sk, 0, 0, flags & MSG_DONTWAIT,
-					      &err, 0);
-		if (!newskb)
-			goto err;
-	}
-
-	/* we must acquire iolock as we modify already present
-	 * skbs in the sk_receive_queue and mess with skb->len
-	 */
-	err = mutex_lock_interruptible(&unix_sk(other)->iolock);
-	if (err) {
-		err = flags & MSG_DONTWAIT ? -EAGAIN : -ERESTARTSYS;
-		goto err;
-	}
-
-	if (sk->sk_shutdown & SEND_SHUTDOWN) {
-		err = -EPIPE;
-		send_sigpipe = true;
-		goto err_unlock;
-	}
-
-	unix_state_lock(other);
-
-	if (sock_flag(other, SOCK_DEAD) ||
-	    other->sk_shutdown & RCV_SHUTDOWN) {
-		err = -EPIPE;
-		send_sigpipe = true;
-		goto err_state_unlock;
-	}
-
-	if (init_scm) {
-		err = maybe_init_creds(&scm, socket, other);
-		if (err)
-			goto err_state_unlock;
-		init_scm = false;
-	}
-
-	skb = skb_peek_tail(&other->sk_receive_queue);
-	if (tail && tail == skb) {
-		skb = newskb;
-	} else if (!skb || !unix_skb_scm_eq(skb, &scm)) {
-		if (newskb) {
-			skb = newskb;
-		} else {
-			tail = skb;
-			goto alloc_skb;
-		}
-	} else if (newskb) {
-		/* this is fast path, we don't necessarily need to
-		 * call to kfree_skb even though with newskb == NULL
-		 * this - does no harm
-		 */
-		consume_skb(newskb);
-		newskb = NULL;
-	}
-
-	if (skb_append_pagefrags(skb, page, offset, size)) {
-		tail = skb;
-		goto alloc_skb;
-	}
-
-	skb->len += size;
-	skb->data_len += size;
-	skb->truesize += size;
-	refcount_add(size, &sk->sk_wmem_alloc);
-
-	if (newskb) {
-		err = unix_scm_to_skb(&scm, skb, false);
-		if (err)
-			goto err_state_unlock;
-		spin_lock(&other->sk_receive_queue.lock);
-		__skb_queue_tail(&other->sk_receive_queue, newskb);
-		spin_unlock(&other->sk_receive_queue.lock);
-	}
-
-	unix_state_unlock(other);
-	mutex_unlock(&unix_sk(other)->iolock);
-
-	other->sk_data_ready(other);
-	scm_destroy(&scm);
-	return size;
-
-err_state_unlock:
-	unix_state_unlock(other);
-err_unlock:
-	mutex_unlock(&unix_sk(other)->iolock);
-err:
-	kfree_skb(newskb);
-	if (send_sigpipe && !(flags & MSG_NOSIGNAL))
-		send_sig(SIGPIPE, current, 0);
-	if (!init_scm)
-		scm_destroy(&scm);
-	return err;
-}
-
 static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 				  size_t len)
 {
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 19aea7cba26e..d0e476755cdc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1271,7 +1271,6 @@ static const struct proto_ops vsock_dgram_ops = {
 	.sendmsg = vsock_dgram_sendmsg,
 	.recvmsg = vsock_dgram_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
@@ -2186,7 +2185,6 @@ static const struct proto_ops vsock_stream_ops = {
 	.sendmsg = vsock_connectible_sendmsg,
 	.recvmsg = vsock_connectible_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 	.set_rcvlowat = vsock_set_rcvlowat,
 };
 
@@ -2208,7 +2206,6 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.sendmsg = vsock_connectible_sendmsg,
 	.recvmsg = vsock_connectible_recvmsg,
 	.mmap = sock_no_mmap,
-	.sendpage = sock_no_sendpage,
 };
 
 static int vsock_create(struct net *net, struct socket *sock,
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 5c7ad301d742..0fb5143bec7a 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1757,7 +1757,6 @@ static const struct proto_ops x25_proto_ops = {
 	.sendmsg =	x25_sendmsg,
 	.recvmsg =	x25_recvmsg,
 	.mmap =		sock_no_mmap,
-	.sendpage =	sock_no_sendpage,
 };
 
 static struct packet_type x25_packet_type __read_mostly = {
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2ac58b282b5e..eff1f0aaa4b5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1386,7 +1386,6 @@ static const struct proto_ops xsk_proto_ops = {
 	.sendmsg	= xsk_sendmsg,
 	.recvmsg	= xsk_recvmsg,
 	.mmap		= xsk_mmap,
-	.sendpage	= sock_no_sendpage,
 };
 
 static void xsk_destruct(struct sock *sk)

