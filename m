Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6216C4C9D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCVN63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjCVN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53545ADEE
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679493389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtS3YWGo7RY6tVsuPyos429cdA5Trk9Ko9ArMj/GbFM=;
        b=ItBuZxBs2YhA2nZSAF7jIJphw4mZ16OCWltVhttF6BOZH8cd1C1ox5vW7SNWiBGY2Pfz7C
        6L+YwPZsyWHqV5PBAoNSeTaoRbuAJ3dAOMQuRGvH+vEQpZqNoNSijGWg6QJNXdhSdMnOEs
        cBVpl86oprFbpgLIjxyd5/5a8AbCDQ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-GRhCHvTpPwOySiq_XJ8zBQ-1; Wed, 22 Mar 2023 09:56:23 -0400
X-MC-Unique: GRhCHvTpPwOySiq_XJ8zBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FA66800B23;
        Wed, 22 Mar 2023 13:56:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541871731B;
        Wed, 22 Mar 2023 13:56:18 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        apparmor@lists.ubuntu.com, bpf@vger.kernel.org,
        dccp@vger.kernel.org, kvm@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-x25@vger.kernel.org,
        mptcp@lists.linux.dev, rds-devel@oss.oracle.com,
        selinux@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org
Subject: [RFC PATCH 1/3] net: Drop the size argument from ->sendmsg()
Date:   Wed, 22 Mar 2023 13:56:10 +0000
Message-Id: <20230322135612.3265850-2-dhowells@redhat.com>
In-Reply-To: <20230322135612.3265850-1-dhowells@redhat.com>
References: <6419bda5a2b4d_59e87208ca@willemb.c.googlers.com.notmuch>
 <20230322135612.3265850-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size argument to ->sendmsg() ought to be redundant as the same
information should be conveyed by msg->msg_iter.count as returned by
msg_data_left().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: netdev@vger.kernel.org
cc: apparmor@lists.ubuntu.com
cc: bpf@vger.kernel.org
cc: dccp@vger.kernel.org
cc: kvm@vger.kernel.org
cc: linux-afs@lists.infradead.org
cc: linux-arm-msm@vger.kernel.org
cc: linux-bluetooth@vger.kernel.org
cc: linux-can@vger.kernel.org
cc: linux-crypto@vger.kernel.org
cc: linux-hams@vger.kernel.org
cc: linux-rdma@vger.kernel.org
cc: linux-s390@vger.kernel.org
cc: linux-sctp@vger.kernel.org
cc: linux-security-module@vger.kernel.org
cc: linux-wpan@vger.kernel.org
cc: linux-x25@vger.kernel.org
cc: mptcp@lists.linux.dev
cc: rds-devel@oss.oracle.com
cc: selinux@vger.kernel.org
cc: tipc-discussion@lists.sourceforge.net
cc: virtualization@lists.linux-foundation.org
cc: xen-devel@lists.xenproject.org
---
 crypto/af_alg.c                               | 12 +++----
 crypto/algif_aead.c                           |  9 +++--
 crypto/algif_hash.c                           |  8 ++---
 crypto/algif_rng.c                            |  3 +-
 crypto/algif_skcipher.c                       | 10 +++---
 drivers/isdn/mISDN/socket.c                   |  3 +-
 .../chelsio/inline_crypto/chtls/chtls.h       |  2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 15 ++++----
 drivers/net/ppp/pppoe.c                       |  4 +--
 drivers/net/tap.c                             |  3 +-
 drivers/net/tun.c                             |  3 +-
 drivers/vhost/net.c                           |  6 ++--
 drivers/xen/pvcalls-back.c                    |  2 +-
 drivers/xen/pvcalls-front.c                   |  4 +--
 drivers/xen/pvcalls-front.h                   |  3 +-
 fs/afs/rxrpc.c                                |  8 ++---
 include/crypto/if_alg.h                       |  3 +-
 include/linux/lsm_hook_defs.h                 |  3 +-
 include/linux/lsm_hooks.h                     |  1 -
 include/linux/net.h                           |  6 ++--
 include/linux/security.h                      |  4 +--
 include/net/af_rxrpc.h                        |  3 +-
 include/net/inet_common.h                     |  2 +-
 include/net/ipv6.h                            |  2 +-
 include/net/ping.h                            |  2 +-
 include/net/sock.h                            |  7 ++--
 include/net/tcp.h                             |  8 ++---
 include/net/udp.h                             |  2 +-
 net/appletalk/ddp.c                           |  3 +-
 net/atm/common.c                              |  3 +-
 net/atm/common.h                              |  2 +-
 net/ax25/af_ax25.c                            |  4 +--
 net/bluetooth/hci_sock.c                      |  4 +--
 net/bluetooth/iso.c                           |  4 +--
 net/bluetooth/l2cap_sock.c                    |  5 ++-
 net/bluetooth/rfcomm/sock.c                   |  7 ++--
 net/bluetooth/sco.c                           |  4 +--
 net/caif/caif_socket.c                        | 13 +++----
 net/can/bcm.c                                 |  3 +-
 net/can/isotp.c                               |  3 +-
 net/can/j1939/socket.c                        |  4 +--
 net/can/raw.c                                 |  3 +-
 net/core/sock.c                               |  4 +--
 net/dccp/dccp.h                               |  2 +-
 net/dccp/proto.c                              |  3 +-
 net/ieee802154/socket.c                       | 11 +++---
 net/ipv4/af_inet.c                            |  4 +--
 net/ipv4/ping.c                               |  8 +++--
 net/ipv4/raw.c                                |  3 +-
 net/ipv4/tcp.c                                | 17 +++++-----
 net/ipv4/tcp_bpf.c                            |  5 +--
 net/ipv4/tcp_input.c                          |  3 +-
 net/ipv4/udp.c                                |  5 +--
 net/ipv6/af_inet6.c                           |  7 ++--
 net/ipv6/ping.c                               |  5 +--
 net/ipv6/raw.c                                |  3 +-
 net/ipv6/udp.c                                |  7 ++--
 net/ipv6/udp_impl.h                           |  2 +-
 net/iucv/af_iucv.c                            |  4 +--
 net/kcm/kcmsock.c                             |  2 +-
 net/key/af_key.c                              |  3 +-
 net/l2tp/l2tp_ip.c                            |  3 +-
 net/l2tp/l2tp_ip6.c                           |  3 +-
 net/l2tp/l2tp_ppp.c                           |  4 +--
 net/llc/af_llc.c                              |  5 ++-
 net/mctp/af_mctp.c                            |  3 +-
 net/mptcp/protocol.c                          |  8 ++---
 net/netlink/af_netlink.c                      | 11 +++---
 net/netrom/af_netrom.c                        |  3 +-
 net/nfc/llcp_sock.c                           |  7 ++--
 net/nfc/rawsock.c                             |  3 +-
 net/packet/af_packet.c                        | 11 +++---
 net/phonet/datagram.c                         |  3 +-
 net/phonet/pep.c                              |  3 +-
 net/phonet/socket.c                           |  5 ++-
 net/qrtr/af_qrtr.c                            |  4 +--
 net/rds/rds.h                                 |  2 +-
 net/rds/send.c                                |  3 +-
 net/rose/af_rose.c                            |  3 +-
 net/rxrpc/af_rxrpc.c                          |  6 ++--
 net/rxrpc/ar-internal.h                       |  2 +-
 net/rxrpc/output.c                            | 22 ++++++------
 net/rxrpc/rxperf.c                            |  4 +--
 net/rxrpc/sendmsg.c                           | 15 ++++----
 net/sctp/socket.c                             |  3 +-
 net/smc/af_smc.c                              |  5 +--
 net/socket.c                                  | 16 ++++-----
 net/tipc/socket.c                             | 34 +++++++++----------
 net/tls/tls.h                                 |  4 +--
 net/tls/tls_device.c                          |  5 +--
 net/tls/tls_sw.c                              |  2 +-
 net/unix/af_unix.c                            | 19 +++++------
 net/vmw_vsock/af_vsock.c                      | 16 ++++-----
 net/x25/af_x25.c                              |  3 +-
 net/xdp/xsk.c                                 |  6 ++--
 net/xfrm/espintcp.c                           |  8 +++--
 security/apparmor/lsm.c                       |  6 ++--
 security/security.c                           |  4 +--
 security/selinux/hooks.c                      |  3 +-
 security/smack/smack_lsm.c                    |  4 +--
 security/tomoyo/common.h                      |  3 +-
 security/tomoyo/network.c                     |  4 +--
 security/tomoyo/tomoyo.c                      |  6 ++--
 103 files changed, 286 insertions(+), 296 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5f7252a5b7b4..dc49b4e2d719 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -952,19 +952,18 @@ static void af_alg_data_wakeup(struct sock *sk)
  *
  * @sock: socket of connection to user space
  * @msg: message from user space
- * @size: size of message from user space
  * @ivsize: the size of the IV for the cipher operation to verify that the
  *	   user-space-provided IV has the right size
  * Return: the number of copied data upon success, < 0 upon error
  */
-int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		   unsigned int ivsize)
+int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, unsigned int ivsize)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct af_alg_control con = {};
+	size_t len;
 	long copied = 0;
 	bool enc = false;
 	bool init = false;
@@ -1012,9 +1011,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		ctx->aead_assoclen = con.aead_assoclen;
 	}
 
-	while (size) {
+	while ((len = msg_data_left(msg))) {
 		struct scatterlist *sg;
-		size_t len = size;
 		size_t plen;
 
 		/* use the existing memory in an allocated page */
@@ -1037,7 +1035,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 			ctx->used += len;
 			copied += len;
-			size -= len;
 			continue;
 		}
 
@@ -1086,11 +1083,10 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			len -= plen;
 			ctx->used += plen;
 			copied += plen;
-			size -= plen;
 			sgl->cur++;
 		} while (len && sgl->cur < MAX_SGL_ENTS);
 
-		if (!size)
+		if (!msg_data_left(msg))
 			sg_mark_end(sg + sgl->cur - 1);
 
 		ctx->merge = plen & (PAGE_SIZE - 1);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 42493b4d8ce4..1005c755c4c8 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -58,7 +58,7 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+static int aead_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -68,7 +68,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int ivsize = crypto_aead_ivsize(tfm);
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	return af_alg_sendmsg(sock, msg, ivsize);
 }
 
 static int crypto_aead_copy_sgl(struct crypto_sync_skcipher *null_tfm,
@@ -408,8 +408,7 @@ static int aead_check_key(struct socket *sock)
 	return err;
 }
 
-static int aead_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
-				  size_t size)
+static int aead_sendmsg_nokey(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 
@@ -417,7 +416,7 @@ static int aead_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	return aead_sendmsg(sock, msg, size);
+	return aead_sendmsg(sock, msg);
 }
 
 static ssize_t aead_sendpage_nokey(struct socket *sock, struct page *page,
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1d017ec5c63c..9817adecdf1a 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -60,8 +60,7 @@ static void hash_free_result(struct sock *sk, struct hash_ctx *ctx)
 	ctx->result = NULL;
 }
 
-static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
-			size_t ignored)
+static int hash_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int limit = ALG_MAX_PAGES * PAGE_SIZE;
 	struct sock *sk = sock->sk;
@@ -325,8 +324,7 @@ static int hash_check_key(struct socket *sock)
 	return err;
 }
 
-static int hash_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
-			      size_t size)
+static int hash_sendmsg_nokey(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 
@@ -334,7 +332,7 @@ static int hash_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	return hash_sendmsg(sock, msg, size);
+	return hash_sendmsg(sock, msg);
 }
 
 static ssize_t hash_sendpage_nokey(struct socket *sock, struct page *page,
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 407408c43730..f838be6c2fd7 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -130,11 +130,12 @@ static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return ret;
 }
 
-static int rng_test_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int rng_test_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 	struct alg_sock *ask = alg_sk(sock->sk);
 	struct rng_ctx *ctx = ask->private;
+	size_t len = msg_data_left(msg);
 
 	lock_sock(sock->sk);
 	if (len > MAXSIZE) {
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ee8890ee8f33..f5cd9dbbad1b 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -34,8 +34,7 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
-			    size_t size)
+static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -44,7 +43,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	return af_alg_sendmsg(sock, msg, ivsize);
 }
 
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
@@ -234,8 +233,7 @@ static int skcipher_check_key(struct socket *sock)
 	return err;
 }
 
-static int skcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
-				  size_t size)
+static int skcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 
@@ -243,7 +241,7 @@ static int skcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	return skcipher_sendmsg(sock, msg, size);
+	return skcipher_sendmsg(sock, msg);
 }
 
 static ssize_t skcipher_sendpage_nokey(struct socket *sock, struct page *page,
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 2776ca5fc33f..4c42d39e994a 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -164,10 +164,11 @@ mISDN_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 }
 
 static int
-mISDN_sock_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+mISDN_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock		*sk = sock->sk;
 	struct sk_buff		*skb;
+	size_t			len = msg_data_left(msg);
 	int			err = -ENOMEM;
 
 	if (*debug & DEBUG_SOCKET)
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 41714203ace8..32077c61273b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -565,7 +565,7 @@ void chtls_close(struct sock *sk, long timeout);
 int chtls_disconnect(struct sock *sk, int flags);
 void chtls_shutdown(struct sock *sk, int how);
 void chtls_destroy_sock(struct sock *sk);
-int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int chtls_sendmsg(struct sock *sk, struct msghdr *msg);
 int chtls_recvmsg(struct sock *sk, struct msghdr *msg,
 		  size_t len, int flags, int *addr_len);
 int chtls_sendpage(struct sock *sk, struct page *page,
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index ae6b17b96bf1..5782267618cf 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1004,7 +1004,7 @@ static int chtls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 	return rc;
 }
 
-int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+int chtls_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
 	struct chtls_dev *cdev = csk->cdev;
@@ -1058,7 +1058,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 					tx_skb_finalize(skb);
 			}
 
-			recordsz = size;
+			recordsz = msg_data_left(msg);
 			csk->tlshws.txleft = recordsz;
 			csk->tlshws.type = record_type;
 		}
@@ -1080,8 +1080,8 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 								 false);
 			} else {
 				skb = get_tx_skb(sk,
-						 select_size(sk, size, flags,
-							     TX_HEADER_LEN));
+						 select_size(sk, msg_data_left(msg),
+							     flags, TX_HEADER_LEN));
 			}
 			if (unlikely(!skb))
 				goto wait_for_memory;
@@ -1089,8 +1089,8 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			copy = mss;
 		}
-		if (copy > size)
-			copy = size;
+		if (copy > msg_data_left(msg))
+			copy = msg_data_left(msg);
 
 		if (skb_tailroom(skb) > 0) {
 			copy = min(copy, skb_tailroom(skb));
@@ -1182,7 +1182,6 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			tx_skb_finalize(skb);
 		tp->write_seq += copy;
 		copied += copy;
-		size -= copy;
 
 		if (is_tls_tx(csk))
 			csk->tlshws.txleft -= copy;
@@ -1191,7 +1190,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		    (sk_stream_wspace(sk) < sk_stream_min_wspace(sk)))
 			ULP_SKB_CB(skb)->flags |= ULPCB_FLAG_NO_APPEND;
 
-		if (size == 0)
+		if (msg_data_left(msg) == 0)
 			goto out;
 
 		if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND)
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index ce2cbb5903d7..7ae28a1f528a 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -833,8 +833,7 @@ static int pppoe_ioctl(struct socket *sock, unsigned int cmd,
 	return err;
 }
 
-static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
-			 size_t total_len)
+static int pppoe_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sk_buff *skb;
 	struct sock *sk = sock->sk;
@@ -843,6 +842,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	struct pppoe_hdr hdr;
 	struct pppoe_hdr *ph;
 	struct net_device *dev;
+	size_t total_len = msg_data_left(m);
 	char *start;
 	int hlen;
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ce993cc75bf3..2b076d4a1a58 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1224,8 +1224,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	return err;
 }
 
-static int tap_sendmsg(struct socket *sock, struct msghdr *m,
-		       size_t total_len)
+static int tap_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
 	struct tun_msg_ctl *ctl = m->msg_control;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4c7f74904c25..b31d696adafd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2531,13 +2531,14 @@ static int tun_xdp_one(struct tun_struct *tun,
 	return ret;
 }
 
-static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int tun_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	int ret, i;
 	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
 	struct tun_struct *tun = tun_get(tfile);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	size_t total_len = msg_data_left(m);
 
 	if (!tun)
 		return -EBADFD;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 07181cd8d52e..ddf01a21f208 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -476,7 +476,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 
 	msghdr->msg_control = &ctl;
 	msghdr->msg_controllen = sizeof(ctl);
-	err = sock->ops->sendmsg(sock, msghdr, 0);
+	err = sock->ops->sendmsg(sock, msghdr);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
 
@@ -836,7 +836,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				msg.msg_flags &= ~MSG_MORE;
 		}
 
-		err = sock->ops->sendmsg(sock, &msg, len);
+		err = sock->ops->sendmsg(sock, &msg);
 		if (unlikely(err < 0)) {
 			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
 				vhost_discard_vq_desc(vq, 1);
@@ -933,7 +933,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			msg.msg_flags &= ~MSG_MORE;
 		}
 
-		err = sock->ops->sendmsg(sock, &msg, len);
+		err = sock->ops->sendmsg(sock, &msg);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
 				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index 1f5219e12cc3..37cfd15b6d9d 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -200,7 +200,7 @@ static bool pvcalls_conn_back_write(struct sock_mapping *map)
 		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 2, size);
 	}
 
-	ret = inet_sendmsg(map->sock, &msg, size);
+	ret = inet_sendmsg(map->sock, &msg);
 	if (ret == -EAGAIN) {
 		atomic_inc(&map->write);
 		atomic_inc(&map->io);
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index d5d589bda243..257d92612371 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -531,10 +531,10 @@ static int __write_ring(struct pvcalls_data_intf *intf,
 	return len;
 }
 
-int pvcalls_front_sendmsg(struct socket *sock, struct msghdr *msg,
-			  size_t len)
+int pvcalls_front_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock_mapping *map;
+	size_t len = msg_data_left(msg);
 	int sent, tot_sent = 0;
 	int count = 0, flags;
 
diff --git a/drivers/xen/pvcalls-front.h b/drivers/xen/pvcalls-front.h
index f694ad77379f..f0c5429604e6 100644
--- a/drivers/xen/pvcalls-front.h
+++ b/drivers/xen/pvcalls-front.h
@@ -14,8 +14,7 @@ int pvcalls_front_accept(struct socket *sock,
 			 struct socket *newsock,
 			 int flags);
 int pvcalls_front_sendmsg(struct socket *sock,
-			  struct msghdr *msg,
-			  size_t len);
+			  struct msghdr *msg);
 int pvcalls_front_recvmsg(struct socket *sock,
 			  struct msghdr *msg,
 			  size_t len,
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 7817e2b860e5..95ef04862025 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -367,8 +367,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	msg.msg_flags		= MSG_WAITALL | (call->write_iter ? MSG_MORE : 0);
 
 	ret = rxrpc_kernel_send_data(call->net->socket, rxcall,
-				     &msg, call->request_size,
-				     afs_notify_end_request_tx);
+				     &msg, afs_notify_end_request_tx);
 	if (ret < 0)
 		goto error_do_abort;
 
@@ -379,7 +378,6 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 
 		ret = rxrpc_kernel_send_data(call->net->socket,
 					     call->rxcall, &msg,
-					     iov_iter_count(&msg.msg_iter),
 					     afs_notify_end_request_tx);
 		*call->write_iter = msg.msg_iter;
 
@@ -834,7 +832,7 @@ void afs_send_empty_reply(struct afs_call *call)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
+	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				       afs_notify_end_reply_tx)) {
 	case 0:
 		_leave(" [replied]");
@@ -875,7 +873,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	n = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, len,
+	n = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg,
 				   afs_notify_end_reply_tx);
 	if (n >= 0) {
 		/* Success */
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 7e76623f9ec3..bcf0077aae6d 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -228,8 +228,7 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
-int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
-		   unsigned int ivsize);
+int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
 void af_alg_free_resources(struct af_alg_async_req *areq);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 094b76dc7164..b176525025da 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -298,8 +298,7 @@ LSM_HOOK(int, 0, socket_connect, struct socket *sock, struct sockaddr *address,
 	 int addrlen)
 LSM_HOOK(int, 0, socket_listen, struct socket *sock, int backlog)
 LSM_HOOK(int, 0, socket_accept, struct socket *sock, struct socket *newsock)
-LSM_HOOK(int, 0, socket_sendmsg, struct socket *sock, struct msghdr *msg,
-	 int size)
+LSM_HOOK(int, 0, socket_sendmsg, struct socket *sock, struct msghdr *msg)
 LSM_HOOK(int, 0, socket_recvmsg, struct socket *sock, struct msghdr *msg,
 	 int size, int flags)
 LSM_HOOK(int, 0, socket_getsockname, struct socket *sock)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 6e156d2acffc..6f48be80b6bf 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -932,7 +932,6 @@
  *	Check permission before transmitting a message to another socket.
  *	@sock contains the socket structure.
  *	@msg contains the message to be transmitted.
- *	@size contains the size of message.
  *	Return 0 if permission is granted.
  * @socket_recvmsg:
  *	Check permission before receiving a message from a socket.
diff --git a/include/linux/net.h b/include/linux/net.h
index b73ad8e3c212..8adf1328445a 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -192,8 +192,7 @@ struct proto_ops {
 	int		(*getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
-	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
-				      size_t total_len);
+	int		(*sendmsg)   (struct socket *sock, struct msghdr *m);
 	/* Notes for implementing recvmsg:
 	 * ===============================
 	 * msg->msg_namelen should get updated by the recvmsg handlers
@@ -222,8 +221,7 @@ struct proto_ops {
 	int		(*read_skb)(struct sock *sk, skb_read_actor_t recv_actor);
 	int		(*sendpage_locked)(struct sock *sk, struct page *page,
 					   int offset, size_t size, int flags);
-	int		(*sendmsg_locked)(struct sock *sk, struct msghdr *msg,
-					  size_t size);
+	int		(*sendmsg_locked)(struct sock *sk, struct msghdr *msg);
 	int		(*set_rcvlowat)(struct sock *sk, int val);
 };
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 5984d0d550b4..6c67a4de4a89 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1436,7 +1436,7 @@ int security_socket_bind(struct socket *sock, struct sockaddr *address, int addr
 int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen);
 int security_socket_listen(struct socket *sock, int backlog);
 int security_socket_accept(struct socket *sock, struct socket *newsock);
-int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size);
+int security_socket_sendmsg(struct socket *sock, struct msghdr *msg);
 int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags);
 int security_socket_getsockname(struct socket *sock);
@@ -1538,7 +1538,7 @@ static inline int security_socket_accept(struct socket *sock,
 }
 
 static inline int security_socket_sendmsg(struct socket *sock,
-					  struct msghdr *msg, int size)
+					  struct msghdr *msg)
 {
 	return 0;
 }
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index ba717eac0229..33f1b8c622e3 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -51,8 +51,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *,
 					   enum rxrpc_interruptibility,
 					   unsigned int);
 int rxrpc_kernel_send_data(struct socket *, struct rxrpc_call *,
-			   struct msghdr *, size_t,
-			   rxrpc_notify_end_tx_t);
+			   struct msghdr *, rxrpc_notify_end_tx_t);
 int rxrpc_kernel_recv_data(struct socket *, struct rxrpc_call *,
 			   struct iov_iter *, size_t *, bool, u32 *, u16 *);
 bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cec453c18f1d..ec798fdd371c 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -32,7 +32,7 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
 int inet_send_prepare(struct sock *sk);
-int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
+int inet_sendmsg(struct socket *sock, struct msghdr *msg);
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags);
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 7332296eca44..f2132311e92b 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1228,7 +1228,7 @@ int inet6_compat_ioctl(struct socket *sock, unsigned int cmd,
 
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 			      struct sock *sk);
-int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg);
 int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		  int flags);
 
diff --git a/include/net/ping.h b/include/net/ping.h
index 9233ad3de0ad..04814edde8e3 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -70,7 +70,7 @@ int  ping_getfrag(void *from, char *to, int offset, int fraglen, int odd,
 
 int  ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		  int flags, int *addr_len);
-int  ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
+int  ping_common_sendmsg(int family, struct msghdr *msg,
 			 void *user_icmph, size_t icmph_len);
 int  ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 enum skb_drop_reason ping_rcv(struct sk_buff *skb);
diff --git a/include/net/sock.h b/include/net/sock.h
index 573f2bf7e0de..7a6d06c181b6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1261,8 +1261,7 @@ struct proto {
 	int			(*compat_ioctl)(struct sock *sk,
 					unsigned int cmd, unsigned long arg);
 #endif
-	int			(*sendmsg)(struct sock *sk, struct msghdr *msg,
-					   size_t len);
+	int			(*sendmsg)(struct sock *sk, struct msghdr *msg);
 	int			(*recvmsg)(struct sock *sk, struct msghdr *msg,
 					   size_t len, int flags, int *addr_len);
 	int			(*sendpage)(struct sock *sk, struct page *page,
@@ -1901,8 +1900,8 @@ int sock_no_getname(struct socket *, struct sockaddr *, int);
 int sock_no_ioctl(struct socket *, unsigned int, unsigned long);
 int sock_no_listen(struct socket *, int);
 int sock_no_shutdown(struct socket *, int);
-int sock_no_sendmsg(struct socket *, struct msghdr *, size_t);
-int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
+int sock_no_sendmsg(struct socket *sk, struct msghdr *msg);
+int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *msg);
 int sock_no_recvmsg(struct socket *, struct msghdr *, size_t, int);
 int sock_no_mmap(struct file *file, struct socket *sock,
 		 struct vm_area_struct *vma);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index a0a91a988272..12b228e3d563 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -325,10 +325,10 @@ int tcp_v4_rcv(struct sk_buff *skb);
 
 void tcp_remove_empty_skb(struct sock *sk);
 int tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
-int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
-int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
+int tcp_sendmsg(struct sock *sk, struct msghdr *msg);
+int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg);
 int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
-			 size_t size, struct ubuf_info *uarg);
+			 struct ubuf_info *uarg);
 int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
@@ -479,7 +479,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 int tcp_disconnect(struct sock *sk, int flags);
 
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb);
-int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size);
+int tcp_send_rcvq(struct sock *sk, struct msghdr *msg);
 void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb);
 
 /* From syncookies.c */
diff --git a/include/net/udp.h b/include/net/udp.h
index de4b528522bb..b9b2ea5af42d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -277,7 +277,7 @@ int udp_get_port(struct sock *sk, unsigned short snum,
 				  const struct sock *));
 int udp_err(struct sk_buff *, u32);
 int udp_abort(struct sock *sk, int err);
-int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+int udp_sendmsg(struct sock *sk, struct msghdr *msg);
 int udp_push_pending_frames(struct sock *sk);
 void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index a06f4d4a6f47..70008c57503f 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1566,7 +1566,7 @@ static int ltalk_rcv(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int atalk_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct atalk_sock *at = at_sk(sk);
@@ -1579,6 +1579,7 @@ static int atalk_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct ddpehdr *ddp;
 	int size, hard_header_len;
 	struct atalk_route *rt, *rt_lo = NULL;
+	size_t len = msg_data_left(msg);
 	int err;
 
 	if (flags & ~(MSG_DONTWAIT|MSG_CMSG_COMPAT))
diff --git a/net/atm/common.c b/net/atm/common.c
index f7019df41c3e..09060644760b 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -565,12 +565,13 @@ int vcc_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return copied;
 }
 
-int vcc_sendmsg(struct socket *sock, struct msghdr *m, size_t size)
+int vcc_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	DEFINE_WAIT(wait);
 	struct atm_vcc *vcc;
 	struct sk_buff *skb;
+	size_t size = msg_data_left(m);
 	int eff, error;
 
 	lock_sock(sk);
diff --git a/net/atm/common.h b/net/atm/common.h
index a1e56e8de698..6597f8308f03 100644
--- a/net/atm/common.h
+++ b/net/atm/common.h
@@ -16,7 +16,7 @@ int vcc_release(struct socket *sock);
 int vcc_connect(struct socket *sock, int itf, short vpi, int vci);
 int vcc_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		int flags);
-int vcc_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len);
+int vcc_sendmsg(struct socket *sock, struct msghdr *m);
 __poll_t vcc_poll(struct file *file, struct socket *sock, poll_table *wait);
 int vcc_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
 int vcc_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d8da400cb4de..48f96e28f7ea 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1489,7 +1489,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	return err;
 }
 
-static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int ax25_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	DECLARE_SOCKADDR(struct sockaddr_ax25 *, usax, msg->msg_name);
 	struct sock *sk = sock->sk;
@@ -1497,7 +1497,7 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sk_buff *skb;
 	ax25_digi dtmp, *dp;
 	ax25_cb *ax25;
-	size_t size;
+	size_t size, len = msg_data_left(msg);
 	int lv, err, addr_len = msg->msg_namelen;
 
 	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_CMSG_COMPAT))
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 06581223238c..9d6f713eeac1 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1692,8 +1692,7 @@ static int hci_logging_frame(struct sock *sk, struct sk_buff *skb,
 	return err;
 }
 
-static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			    size_t len)
+static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct hci_mgmt_chan *chan;
@@ -1701,6 +1700,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int err;
 	const unsigned int flags = msg->msg_flags;
+	size_t len = msg_data_left(msg);
 
 	BT_DBG("sock %p sk %p", sock, sk);
 
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 24444b502e58..6d8863878abc 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1031,12 +1031,12 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 	return sizeof(struct sockaddr_iso);
 }
 
-static int iso_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			    size_t len)
+static int iso_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct iso_conn *conn = iso_pi(sk)->conn;
 	struct sk_buff *skb, **frag;
+	size_t len = msg_data_left(msg);
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index eebe256104bc..d488aca82037 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1143,8 +1143,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
-static int l2cap_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			      size_t len)
+static int l2cap_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
@@ -1169,7 +1168,7 @@ static int l2cap_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;
 
 	l2cap_chan_lock(chan);
-	err = l2cap_chan_send(chan, msg, len);
+	err = l2cap_chan_send(chan, msg, msg_data_left(msg));
 	l2cap_chan_unlock(chan);
 
 	return err;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4397e14ff560..8a0a51b5c3a3 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -558,8 +558,7 @@ static int rfcomm_sock_getname(struct socket *sock, struct sockaddr *addr, int p
 	return sizeof(struct sockaddr_rc);
 }
 
-static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct rfcomm_dlc *d = rfcomm_pi(sk)->dlc;
@@ -586,8 +585,8 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (sent)
 		return sent;
 
-	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
-			      RFCOMM_SKB_TAIL_RESERVE);
+	skb = bt_skb_sendmmsg(sk, msg, msg_data_left(msg), d->mtu,
+			      RFCOMM_SKB_HEAD_RESERVE, RFCOMM_SKB_TAIL_RESERVE);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1111da4e2f2b..8c62c5dc5b57 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -722,11 +722,11 @@ static int sco_sock_getname(struct socket *sock, struct sockaddr *addr,
 	return sizeof(struct sockaddr_sco);
 }
 
-static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			    size_t len)
+static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 4eebcc66c19a..827230b3f7c3 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -510,8 +510,7 @@ static int transmit_skb(struct sk_buff *skb, struct caifsock *cf_sk,
 }
 
 /* Copied from af_unix:unix_dgram_sendmsg, and adapted to CAIF */
-static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct caifsock *cf_sk = container_of(sk, struct caifsock, sk);
@@ -520,6 +519,8 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb = NULL;
 	int noblock;
 	long timeo;
+	size_t len = msg_data_left(msg);
+
 	caif_assert(cf_sk);
 	ret = sock_error(sk);
 	if (ret)
@@ -582,8 +583,7 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
  * Changed removed permission handling and added waiting for flow on
  * and other minor adaptations.
  */
-static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct caifsock *cf_sk = container_of(sk, struct caifsock, sk);
@@ -605,10 +605,7 @@ static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
 		goto pipe_err;
 
-	while (sent < len) {
-
-		size = len-sent;
-
+	while ((size = msg_data_left(msg))) {
 		if (size > cf_sk->maxframe)
 			size = cf_sk->maxframe;
 
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 27706f6ace34..9baace5e0d71 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1287,12 +1287,13 @@ static int bcm_tx_send(struct msghdr *msg, int ifindex, struct sock *sk,
 /*
  * bcm_sendmsg - process BCM commands (opcodes) from the userspace
  */
-static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+static int bcm_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct bcm_sock *bo = bcm_sk(sk);
 	int ifindex = bo->ifindex; /* default ifindex for this bcm_op */
 	struct bcm_msg_head msg_head;
+	size_t size = msg_data_left(msg);
 	int cfsiz;
 	int ret; /* read bytes or error codes as return value */
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..6b5d3ebd6748 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -914,7 +914,7 @@ static enum hrtimer_restart isotp_txfr_timer_handler(struct hrtimer *hrtimer)
 	return HRTIMER_NORESTART;
 }
 
-static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+static int isotp_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
@@ -922,6 +922,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
+	size_t size = msg_data_left(msg);
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
 	s64 hrtimer_sec = ISOTP_ECHO_TIMEOUT;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 7e90f9e61d9b..2b009b69e853 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1187,12 +1187,12 @@ static int j1939_sk_send_loop(struct j1939_priv *priv,  struct sock *sk,
 	return ret;
 }
 
-static int j1939_sk_sendmsg(struct socket *sock, struct msghdr *msg,
-			    size_t size)
+static int j1939_sk_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct j1939_sock *jsk = j1939_sk(sk);
 	struct j1939_priv *priv;
+	size_t size = msg_data_left(msg);
 	int ifindex;
 	int ret;
 
diff --git a/net/can/raw.c b/net/can/raw.c
index f64469b98260..0c37f1c70685 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -814,13 +814,14 @@ static bool raw_bad_txframe(struct raw_sock *ro, struct sk_buff *skb, int mtu)
 	return true;
 }
 
-static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+static int raw_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
 	struct sockcm_cookie sockc;
 	struct sk_buff *skb;
 	struct net_device *dev;
+	size_t size = msg_data_left(msg);
 	int ifindex;
 	int err = -EINVAL;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index c25888795390..4170381356aa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3183,13 +3183,13 @@ int sock_no_shutdown(struct socket *sock, int how)
 }
 EXPORT_SYMBOL(sock_no_shutdown);
 
-int sock_no_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
+int sock_no_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(sock_no_sendmsg);
 
-int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *m, size_t len)
+int sock_no_sendmsg_locked(struct sock *sk, struct msghdr *m)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9ddc3a9e89e4..3d5d7615ddd8 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -293,7 +293,7 @@ int dccp_getsockopt(struct sock *sk, int level, int optname,
 int dccp_setsockopt(struct sock *sk, int level, int optname,
 		    sockptr_t optval, unsigned int optlen);
 int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg);
-int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int dccp_sendmsg(struct sock *sk, struct msghdr *msg);
 int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		 int *addr_len);
 void dccp_shutdown(struct sock *sk, int how);
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index a06b5641287a..6f6623bb1ff8 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -725,12 +725,13 @@ static int dccp_msghdr_parse(struct msghdr *msg, struct sk_buff *skb)
 	return 0;
 }
 
-int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+int dccp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	const struct dccp_sock *dp = dccp_sk(sk);
 	const int flags = msg->msg_flags;
 	const int noblock = flags & MSG_DONTWAIT;
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	int rc, size;
 	long timeo;
 
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 1fa2fe041ec0..70f2948b7946 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -88,12 +88,11 @@ static int ieee802154_sock_release(struct socket *sock)
 	return 0;
 }
 
-static int ieee802154_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-				   size_t len)
+static int ieee802154_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->sendmsg(sk, msg, len);
+	return sk->sk_prot->sendmsg(sk, msg);
 }
 
 static int ieee802154_sock_bind(struct socket *sock, struct sockaddr *uaddr,
@@ -238,11 +237,12 @@ static int raw_disconnect(struct sock *sk, int flags)
 	return 0;
 }
 
-static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+static int raw_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct net_device *dev;
 	unsigned int mtu;
 	struct sk_buff *skb;
+	size_t size = msg_data_left(msg);
 	int hlen, tlen;
 	int err;
 
@@ -605,7 +605,7 @@ static int dgram_disconnect(struct sock *sk, int flags)
 	return 0;
 }
 
-static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+static int dgram_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct net_device *dev;
 	unsigned int mtu;
@@ -614,6 +614,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
 	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
+	size_t size = msg_data_left(msg);
 	int hlen, tlen;
 	int err;
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 940062e08f57..4facfef8bded 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -815,7 +815,7 @@ int inet_send_prepare(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_send_prepare);
 
-int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+int inet_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 
@@ -823,7 +823,7 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		return -EAGAIN;
 
 	return INDIRECT_CALL_2(sk->sk_prot->sendmsg, tcp_sendmsg, udp_sendmsg,
-			       sk, msg, size);
+			       sk, msg);
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 409ec2a1f95b..f689f9f530c9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -657,9 +657,10 @@ static int ping_v4_push_pending_frames(struct sock *sk, struct pingfakehdr *pfh,
 	return ip_push_pending_frames(sk, fl4);
 }
 
-int ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
+int ping_common_sendmsg(int family, struct msghdr *msg,
 			void *user_icmph, size_t icmph_len)
 {
+	size_t len = msg_data_left(msg);
 	u8 type, code;
 
 	if (len > 0xFFFF)
@@ -703,7 +704,7 @@ int ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
 }
 EXPORT_SYMBOL_GPL(ping_common_sendmsg);
 
-static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct net *net = sock_net(sk);
 	struct flowi4 fl4;
@@ -713,6 +714,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct pingfakehdr pfh;
 	struct rtable *rt = NULL;
 	struct ip_options_data opt_copy;
+	size_t len = msg_data_left(msg);
 	int free = 0;
 	__be32 saddr, daddr, faddr;
 	u8  tos;
@@ -720,7 +722,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	pr_debug("ping_v4_sendmsg(sk=%p,sk->num=%u)\n", inet, inet->inet_num);
 
-	err = ping_common_sendmsg(AF_INET, msg, len, &user_icmph,
+	err = ping_common_sendmsg(AF_INET, msg, &user_icmph,
 				  sizeof(user_icmph));
 	if (err)
 		return err;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 3cf68695b40d..f2859c117796 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -471,7 +471,7 @@ static int raw_getfrag(void *from, char *to, int offset, int len, int odd,
 	return ip_generic_getfrag(rfv->msg, to, offset, len, odd, skb);
 }
 
-static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int raw_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct net *net = sock_net(sk);
@@ -485,6 +485,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int err;
 	struct ip_options_data opt_copy;
 	struct raw_frag_vec rfv;
+	size_t len = msg_data_left(msg);
 	int hdrincl;
 
 	err = -EMSGSIZE;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fd68d49490f2..2a98b104892c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1166,7 +1166,7 @@ void tcp_free_fastopen_req(struct tcp_sock *tp)
 }
 
 int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
-			 size_t size, struct ubuf_info *uarg)
+			 struct ubuf_info *uarg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
@@ -1186,7 +1186,7 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 	if (unlikely(!tp->fastopen_req))
 		return -ENOBUFS;
 	tp->fastopen_req->data = msg;
-	tp->fastopen_req->size = size;
+	tp->fastopen_req->size = msg_data_left(msg);
 	tp->fastopen_req->uarg = uarg;
 
 	if (inet->defer_connect) {
@@ -1212,12 +1212,13 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 	return err;
 }
 
-int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
+int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
 	struct sockcm_cookie sockc;
+	size_t size = msg_data_left(msg);
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
 	int process_backlog = 0;
@@ -1226,7 +1227,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	flags = msg->msg_flags;
 
-	if ((flags & MSG_ZEROCOPY) && size) {
+	if ((flags & MSG_ZEROCOPY) && msg_data_left(msg)) {
 		skb = tcp_write_queue_tail(sk);
 
 		if (msg->msg_ubuf) {
@@ -1247,7 +1248,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
 	    !tp->repair) {
-		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn, size, uarg);
+		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn, uarg);
 		if (err == -EINPROGRESS && copied_syn > 0)
 			goto out;
 		else if (err)
@@ -1271,7 +1272,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (unlikely(tp->repair)) {
 		if (tp->repair_queue == TCP_RECV_QUEUE) {
-			copied = tcp_send_rcvq(sk, msg, size);
+			copied = tcp_send_rcvq(sk, msg);
 			goto out_nopush;
 		}
 
@@ -1477,12 +1478,12 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 }
 EXPORT_SYMBOL_GPL(tcp_sendmsg_locked);
 
-int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+int tcp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	int ret;
 
 	lock_sock(sk);
-	ret = tcp_sendmsg_locked(sk, msg, size);
+	ret = tcp_sendmsg_locked(sk, msg);
 	release_sock(sk);
 
 	return ret;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ebf917511937..843eb2b6b8d3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -396,9 +396,10 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
-static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct sk_msg tmp, *msg_tx = NULL;
+	size_t size = msg_data_left(msg);
 	int copied = 0, err = 0;
 	struct sk_psock *psock;
 	long timeo;
@@ -410,7 +411,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return tcp_sendmsg(sk, msg, size);
+		return tcp_sendmsg(sk, msg);
 
 	lock_sock(sk);
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2b75cd9e2e92..a1c7d834abca 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4948,9 +4948,10 @@ static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
 	return eaten;
 }
 
-int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
+int tcp_send_rcvq(struct sock *sk, struct msghdr *msg)
 {
 	struct sk_buff *skb;
+	size_t size = msg_data_left(msg);
 	int err = -ENOMEM;
 	int data_len = 0;
 	bool fragstolen;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa32afd871ee..b2ed9d37a362 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1049,13 +1049,14 @@ int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size)
 }
 EXPORT_SYMBOL_GPL(udp_cmsg_send);
 
-int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+int udp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct udp_sock *up = udp_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_in *, usin, msg->msg_name);
 	struct flowi4 fl4_stack;
 	struct flowi4 *fl4;
+	unsigned int len = msg_data_left(msg);
 	int ulen = len;
 	struct ipcm_cookie ipc;
 	struct rtable *rt = NULL;
@@ -1346,7 +1347,7 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		 * sendpage interface can't pass.
 		 * This will succeed only when the socket is connected.
 		 */
-		ret = udp_sendmsg(sk, &msg, 0);
+		ret = udp_sendmsg(sk, &msg);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e1b679a590c9..d6b4cfc44e2a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -636,9 +636,8 @@ int inet6_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 EXPORT_SYMBOL_GPL(inet6_compat_ioctl);
 #endif /* CONFIG_COMPAT */
 
-INDIRECT_CALLABLE_DECLARE(int udpv6_sendmsg(struct sock *, struct msghdr *,
-					    size_t));
-int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+INDIRECT_CALLABLE_DECLARE(int udpv6_sendmsg(struct sock *, struct msghdr *));
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot;
@@ -649,7 +648,7 @@ int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
 	prot = READ_ONCE(sk->sk_prot);
 	return INDIRECT_CALL_2(prot->sendmsg, tcp_sendmsg, udpv6_sendmsg,
-			       sk, msg, size);
+			       sk, msg);
 }
 
 INDIRECT_CALLABLE_DECLARE(int udpv6_recvmsg(struct sock *, struct msghdr *,
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index c4835dbdfcff..54c94b28744f 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -59,7 +59,7 @@ static int ping_v6_pre_connect(struct sock *sk, struct sockaddr *uaddr,
 	return BPF_CGROUP_RUN_PROG_INET6_CONNECT_LOCK(sk, uaddr);
 }
 
-static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
@@ -73,8 +73,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct rt6_info *rt;
 	struct pingfakehdr pfh;
 	struct ipcm6_cookie ipc6;
+	size_t len = msg_data_left(msg);
 
-	err = ping_common_sendmsg(AF_INET6, msg, len, &user_icmph,
+	err = ping_common_sendmsg(AF_INET6, msg, &user_icmph,
 				  sizeof(user_icmph));
 	if (err)
 		return err;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6ac2f2690c44..a3437deeeb74 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -735,7 +735,7 @@ static int raw6_getfrag(void *from, char *to, int offset, int len, int odd,
 	return ip_generic_getfrag(rfv->msg, to, offset, len, odd, skb);
 }
 
-static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct ipv6_txoptions *opt_to_free = NULL;
 	struct ipv6_txoptions opt_space;
@@ -751,6 +751,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct flowi6 fl6;
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
+	size_t len = msg_data_left(msg);
 	int hdrincl;
 	u16 proto;
 	int err;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d350e57c4792..80f2eb58ba1a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1326,7 +1326,7 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 	return err;
 }
 
-int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+int udpv6_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct ipv6_txoptions opt_space;
 	struct udp_sock *up = udp_sk(sk);
@@ -1343,6 +1343,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
+	size_t len = msg_data_left(msg);
 	int ulen = len;
 	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
@@ -1397,7 +1398,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 do_udp_sendmsg:
 			if (ipv6_only_sock(sk))
 				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
+			return udp_sendmsg(sk, msg);
 		}
 	}
 
@@ -1410,7 +1411,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
 		if (up->pending == AF_INET)
-			return udp_sendmsg(sk, msg, len);
+			return udp_sendmsg(sk, msg);
 		/*
 		 * There are pending frames.
 		 * The socket lock must be held while it's corked.
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 0590f566379d..c905a5cb34af 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -20,7 +20,7 @@ int udpv6_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *optlen);
 int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		     unsigned int optlen);
-int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+int udpv6_sendmsg(struct sock *sk, struct msghdr *msg);
 int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 		  int *addr_len);
 void udpv6_destroy_sock(struct sock *sk);
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 498a0c35b7bb..d963d245a4e2 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -895,8 +895,7 @@ static int iucv_send_iprm(struct iucv_path *path, struct iucv_message *msg,
 				 (void *) prmdata, 8);
 }
 
-static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			     size_t len)
+static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
@@ -905,6 +904,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	struct iucv_message txmsg = {0};
 	struct cmsghdr *cmsg;
+	size_t len = msg_data_left(msg);
 	int cmsg_done;
 	long timeo;
 	char user_id[9];
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index cfe828bd7fc6..caf13ed1bfeb 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -904,7 +904,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	return err;
 }
 
-static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int kcm_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index a815f5ab4c49..3cde1e0c3119 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3662,13 +3662,14 @@ static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 }
 #endif
 
-static int pfkey_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int pfkey_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb = NULL;
 	struct sadb_msg *hdr = NULL;
 	int err;
 	struct net *net = sock_net(sk);
+	size_t len = msg_data_left(msg);
 
 	err = -EOPNOTSUPP;
 	if (msg->msg_flags & MSG_OOB)
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4db5a554bdbd..474ce4ae9b63 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -394,13 +394,14 @@ static int l2tp_ip_backlog_recv(struct sock *sk, struct sk_buff *skb)
 /* Userspace will call sendmsg() on the tunnel socket to send L2TP
  * control frames.
  */
-static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct sk_buff *skb;
 	int rc;
 	struct inet_sock *inet = inet_sk(sk);
 	struct rtable *rt = NULL;
 	struct flowi4 *fl4;
+	size_t len = msg_data_left(msg);
 	int connected = 0;
 	__be32 daddr;
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2478aa60145f..7619afe77855 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -488,7 +488,7 @@ static int l2tp_ip6_push_pending_frames(struct sock *sk)
 /* Userspace will call sendmsg() on the tunnel socket to send L2TP
  * control frames.
  */
-static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct ipv6_txoptions opt_space;
 	DECLARE_SOCKADDR(struct sockaddr_l2tpip6 *, lsa, msg->msg_name);
@@ -500,6 +500,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct dst_entry *dst = NULL;
 	struct flowi6 fl6;
 	struct ipcm6_cookie ipc6;
+	size_t len = msg_data_left(msg);
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
 	int ulen;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index f011af6601c9..ae351f50adff 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -262,14 +262,14 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
  * when a user application does a sendmsg() on the session socket. L2TP and
  * PPP headers must be inserted into the user's data.
  */
-static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
-			    size_t total_len)
+static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int error;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel;
+	size_t total_len = msg_data_left(m);
 	int uhlen;
 
 	error = -ENOTCONN;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index da7fe94bea2e..d10b5ef66c88 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -919,12 +919,11 @@ static int llc_ui_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
  *	llc_ui_sendmsg - Transmit data provided by the socket user.
  *	@sock: Socket to transmit data from.
  *	@msg: Various user related information.
- *	@len: Length of data to transmit.
  *
  *	Transmit data provided by the socket user.
  *	Returns non-negative upon success, negative otherwise.
  */
-static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
@@ -954,7 +953,7 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			goto out;
 	}
 	hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);
-	size = hdrlen + len;
+	size = hdrlen + msg_data_left(msg);
 	if (size > llc->dev->mtu)
 		size = llc->dev->mtu;
 	copied = size - hdrlen;
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index bb4bd0b6a4f7..9ead250f1be3 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -90,7 +90,7 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 	return rc;
 }
 
-static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int mctp_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	DECLARE_SOCKADDR(struct sockaddr_mctp *, addr, msg->msg_name);
 	int rc, addrlen = msg->msg_namelen;
@@ -99,6 +99,7 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct sk_buff *skb = NULL;
+	size_t len = msg_data_left(msg);
 	int hlen;
 
 	if (addr) {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2d26b9114373..0a58f2dbd3ce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1663,7 +1663,7 @@ static void mptcp_set_nospace(struct sock *sk)
 static int mptcp_disconnect(struct sock *sk, int flags);
 
 static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msghdr *msg,
-				  size_t len, int *copied_syn)
+				  int *copied_syn)
 {
 	unsigned int saved_flags = msg->msg_flags;
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1673,7 +1673,7 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 	msg->msg_flags |= MSG_DONTWAIT;
 	msk->connect_flags = O_NONBLOCK;
 	msk->fastopening = 1;
-	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, len, NULL);
+	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, NULL);
 	msk->fastopening = 0;
 	msg->msg_flags = saved_flags;
 	release_sock(ssk);
@@ -1695,7 +1695,7 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 	return ret;
 }
 
-static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct page_frag *pfrag;
@@ -1714,7 +1714,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			       msg->msg_flags & MSG_FASTOPEN))) {
 		int copied_syn = 0;
 
-		ret = mptcp_sendmsg_fastopen(sk, ssock->sk, msg, len, &copied_syn);
+		ret = mptcp_sendmsg_fastopen(sk, ssock->sk, msg, &copied_syn);
 		copied += copied_syn;
 		if (ret == -EINPROGRESS && copied_syn > 0)
 			goto out;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 877f1da1a8ac..519487cbfcce 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1857,7 +1857,7 @@ static void netlink_cmsg_listen_all_nsid(struct sock *sk, struct msghdr *msg,
 		 &NETLINK_CB(skb).nsid);
 }
 
-static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int netlink_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
@@ -1872,7 +1872,7 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (len == 0) {
+	if (msg_data_left(msg) == 0) {
 		pr_warn_once("Zero length message leads to an empty skb\n");
 		return -ENODATA;
 	}
@@ -1911,10 +1911,10 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	}
 
 	err = -EMSGSIZE;
-	if (len > sk->sk_sndbuf - 32)
+	if (msg_data_left(msg) > sk->sk_sndbuf - 32)
 		goto out;
 	err = -ENOBUFS;
-	skb = netlink_alloc_large_skb(len, dst_group);
+	skb = netlink_alloc_large_skb(msg_data_left(msg), dst_group);
 	if (skb == NULL)
 		goto out;
 
@@ -1924,7 +1924,8 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	NETLINK_CB(skb).flags	= netlink_skb_flags;
 
 	err = -EFAULT;
-	if (memcpy_from_msg(skb_put(skb, len), msg, len)) {
+	if (memcpy_from_msg(skb_put(skb, msg_data_left(msg)),
+			    msg, msg_data_left(msg))) {
 		kfree_skb(skb);
 		goto out;
 	}
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 5a4cb796150f..d2c65f38c22c 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1034,7 +1034,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	return 1;
 }
 
-static int nr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int nr_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct nr_sock *nr = nr_sk(sk);
@@ -1043,6 +1043,7 @@ static int nr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sockaddr_ax25 sax;
 	struct sk_buff *skb;
 	unsigned char *asmptr;
+	size_t len = msg_data_left(msg);
 	int size;
 
 	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_CMSG_COMPAT))
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 77642d18a3b4..70226fc36396 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -770,8 +770,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	return ret;
 }
 
-static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
-			     size_t len)
+static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
@@ -805,7 +804,7 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		release_sock(sk);
 
 		return nfc_llcp_send_ui_frame(llcp_sock, addr->dsap, addr->ssap,
-					      msg, len);
+					      msg, msg_data_left(msg));
 	}
 
 	if (sk->sk_state != LLCP_CONNECTED) {
@@ -815,7 +814,7 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	release_sock(sk);
 
-	return nfc_llcp_send_i_frame(llcp_sock, msg, len);
+	return nfc_llcp_send_i_frame(llcp_sock, msg, msg_data_left(msg));
 }
 
 static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5125392bb68e..d9d54240b2a2 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -202,11 +202,12 @@ static void rawsock_tx_work(struct work_struct *work)
 	kcov_remote_stop();
 }
 
-static int rawsock_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int rawsock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct nfc_dev *dev = nfc_rawsock(sk)->dev;
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	int rc;
 
 	pr_debug("sock=%p sk=%p len=%zu\n", sock, sk, len);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 497193f73030..84a95e177260 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1947,14 +1947,14 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
  *	protocol layers and you must therefore supply it with a complete frame
  */
 
-static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	DECLARE_SOCKADDR(struct sockaddr_pkt *, saddr, msg->msg_name);
 	struct sk_buff *skb = NULL;
 	struct net_device *dev;
 	struct sockcm_cookie sockc;
+	size_t len = msg_data_left(msg);
 	__be16 proto = 0;
 	int err;
 	int extra_len = 0;
@@ -2933,7 +2933,7 @@ static struct sk_buff *packet_alloc_skb(struct sock *sk, size_t prepad,
 	return skb;
 }
 
-static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
+static int packet_snd(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
@@ -2946,6 +2946,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int offset = 0;
 	struct packet_sock *po = pkt_sk(sk);
+	size_t len = msg_data_left(msg);
 	bool has_vnet_hdr = false;
 	int hlen, tlen, linear;
 	int extra_len = 0;
@@ -3093,7 +3094,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int packet_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
@@ -3104,7 +3105,7 @@ static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (data_race(po->tx_ring.pg_vec))
 		return tpacket_snd(po, msg);
 
-	return packet_snd(sock, msg, len);
+	return packet_snd(sock, msg);
 }
 
 /*
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index ff5f49ab236e..4839f7d6785b 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -70,10 +70,11 @@ static int pn_init(struct sock *sk)
 	return 0;
 }
 
-static int pn_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int pn_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	DECLARE_SOCKADDR(struct sockaddr_pn *, target, msg->msg_name);
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	int err;
 
 	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_NOSIGNAL|
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 83ea13a50690..5afc99ab9eca 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1112,10 +1112,11 @@ static int pipe_skb_send(struct sock *sk, struct sk_buff *skb)
 
 }
 
-static int pep_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int pep_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct pep_sock *pn = pep_sk(sk);
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	long timeo;
 	int flags = msg->msg_flags;
 	int err, done;
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 71e2caf6ab85..99cd62f64944 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -414,15 +414,14 @@ static int pn_socket_listen(struct socket *sock, int backlog)
 	return err;
 }
 
-static int pn_socket_sendmsg(struct socket *sock, struct msghdr *m,
-			     size_t total_len)
+static int pn_socket_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 
 	if (pn_socket_autobind(sock))
 		return -EAGAIN;
 
-	return sk->sk_prot->sendmsg(sk, m, total_len);
+	return sk->sk_prot->sendmsg(sk, m);
 }
 
 const struct proto_ops phonet_dgram_ops = {
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 5c2fb992803b..7c1b908dd479 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -888,7 +888,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	return 0;
 }
 
-static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
 	int (*enqueue_fn)(struct qrtr_node *, struct sk_buff *, int,
@@ -898,7 +898,7 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct qrtr_node *node;
 	struct sk_buff *skb;
-	size_t plen;
+	size_t plen, len = msg_data_left(msg);
 	u32 type;
 	int rc;
 
diff --git a/net/rds/rds.h b/net/rds/rds.h
index d35d1fc39807..9e8ecafd5b51 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -909,7 +909,7 @@ void rds6_inc_info_copy(struct rds_incoming *inc,
 			int flip);
 
 /* send.c */
-int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len);
+int rds_sendmsg(struct socket *sock, struct msghdr *msg);
 void rds_send_path_reset(struct rds_conn_path *conn);
 int rds_send_xmit(struct rds_conn_path *cp);
 struct sockaddr_in;
diff --git a/net/rds/send.c b/net/rds/send.c
index 5e57a1581dc6..f588b720e1c3 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1098,7 +1098,7 @@ static int rds_rdma_bytes(struct msghdr *msg, size_t *rdma_bytes)
 	return 0;
 }
 
-int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
+int rds_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct rds_sock *rs = rds_sk_to_rs(sk);
@@ -1114,6 +1114,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	struct rds_conn_path *cpath;
 	struct in6_addr daddr;
 	__u32 scope_id = 0;
+	size_t payload_len = msg_data_left(msg);
 	size_t rdma_payload_len = 0;
 	bool zcopy = ((msg->msg_flags & MSG_ZEROCOPY) &&
 		      sock_flag(rds_rs_to_sk(rs), SOCK_ZEROCOPY));
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ca2b17f32670..938ea0716751 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1069,7 +1069,7 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 	return 1;
 }
 
-static int rose_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int rose_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct rose_sock *rose = rose_sk(sk);
@@ -1078,6 +1078,7 @@ static int rose_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct full_sockaddr_rose srose;
 	struct sk_buff *skb;
 	unsigned char *asmptr;
+	size_t len = msg_data_left(msg);
 	int n, size, qbit = 0;
 
 	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_CMSG_COMPAT))
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 102f5cbff91a..bdce6ab30899 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -502,13 +502,13 @@ static int rxrpc_connect(struct socket *sock, struct sockaddr *addr,
  *   - sends a call data packet
  *   - may send an abort (abort code in control data)
  */
-static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
+static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct rxrpc_local *local;
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
 	int ret;
 
-	_enter(",{%d},,%zu", rx->sk.sk_state, len);
+	_enter(",{%d},,%zu", rx->sk.sk_state, msg_data_left(m));
 
 	if (m->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
@@ -562,7 +562,7 @@ static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 		fallthrough;
 	case RXRPC_SERVER_BOUND:
 	case RXRPC_SERVER_LISTENING:
-		ret = rxrpc_do_sendmsg(rx, m, len);
+		ret = rxrpc_do_sendmsg(rx, m);
 		/* The socket has been unlocked */
 		goto out;
 	default:
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 67b0a894162d..36738f8f050d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1221,7 +1221,7 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
  */
 bool rxrpc_propose_abort(struct rxrpc_call *call, s32 abort_code, int error,
 			 enum rxrpc_abort_reason why);
-int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
+int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *);
 
 /*
  * server_key.c
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 5e53429c6922..0f3ff3455101 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -16,9 +16,9 @@
 #include <net/udp.h>
 #include "ar-internal.h"
 
-extern int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+extern int udpv6_sendmsg(struct sock *sk, struct msghdr *msg);
 
-static ssize_t do_udp_sendmsg(struct socket *socket, struct msghdr *msg, size_t len)
+static ssize_t do_udp_sendmsg(struct socket *socket, struct msghdr *msg)
 {
 	struct sockaddr *sa = msg->msg_name;
 	struct sock *sk = socket->sk;
@@ -29,10 +29,10 @@ static ssize_t do_udp_sendmsg(struct socket *socket, struct msghdr *msg, size_t
 				pr_warn("AF_INET6 address on AF_INET socket\n");
 				return -ENOPROTOOPT;
 			}
-			return udpv6_sendmsg(sk, msg, len);
+			return udpv6_sendmsg(sk, msg);
 		}
 	}
-	return udp_sendmsg(sk, msg, len);
+	return udp_sendmsg(sk, msg);
 }
 
 struct rxrpc_abort_buffer {
@@ -232,7 +232,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	txb->ack.previousPacket	= htonl(call->rx_highest_seq);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
-	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+	ret = do_udp_sendmsg(conn->local->socket, &msg);
 	call->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
@@ -306,7 +306,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	pkt.whdr.serial = htonl(serial);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
-	ret = do_udp_sendmsg(conn->local->socket, &msg, sizeof(pkt));
+	ret = do_udp_sendmsg(conn->local->socket, &msg);
 	conn->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
@@ -424,7 +424,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	 *     message and update the peer record
 	 */
 	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
-	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+	ret = do_udp_sendmsg(conn->local->socket, &msg);
 	conn->peer->last_tx_at = ktime_get_seconds();
 
 	if (ret < 0) {
@@ -497,7 +497,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 		ip_sock_set_mtu_discover(conn->local->socket->sk,
 					 IP_PMTUDISC_DONT);
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_frag);
-		ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+		ret = do_udp_sendmsg(conn->local->socket, &msg);
 		conn->peer->last_tx_at = ktime_get_seconds();
 
 		ip_sock_set_mtu_discover(conn->local->socket->sk,
@@ -564,7 +564,7 @@ void rxrpc_send_conn_abort(struct rxrpc_connection *conn)
 	whdr.serial = htonl(serial);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
-	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+	ret = do_udp_sendmsg(conn->local->socket, &msg);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
 				    rxrpc_tx_point_conn_abort);
@@ -633,7 +633,7 @@ void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		whdr.flags	&= RXRPC_CLIENT_INITIATED;
 
 		iov_iter_kvec(&msg.msg_iter, WRITE, iov, ioc, size);
-		ret = do_udp_sendmsg(local->socket, &msg, size);
+		ret = do_udp_sendmsg(local->socket, &msg);
 		if (ret < 0)
 			trace_rxrpc_tx_fail(local->debug_id, 0, ret,
 					    rxrpc_tx_point_reject);
@@ -682,7 +682,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *peer)
 	len = iov[0].iov_len + iov[1].iov_len;
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
-	ret = do_udp_sendmsg(peer->local->socket, &msg, len);
+	ret = do_udp_sendmsg(peer->local->socket, &msg);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(peer->debug_id, 0, ret,
 				    rxrpc_tx_point_version_keepalive);
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 4a2e90015ca7..0167afb67a7a 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -507,7 +507,7 @@ static int rxperf_process_call(struct rxperf_call *call)
 		iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, len);
 		msg.msg_flags = MSG_MORE;
 		n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
-					   len, rxperf_notify_end_reply_tx);
+					   rxperf_notify_end_reply_tx);
 		if (n < 0)
 			return n;
 		if (n == 0)
@@ -520,7 +520,7 @@ static int rxperf_process_call(struct rxperf_call *call)
 	iov[0].iov_len	= len;
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	msg.msg_flags = 0;
-	n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg, len,
+	n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
 				   rxperf_notify_end_reply_tx);
 	if (n >= 0)
 		return 0; /* Success */
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index da49fcf1c456..b6ffd8124ced 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -280,7 +280,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
  */
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
-			   struct msghdr *msg, size_t len,
+			   struct msghdr *msg,
 			   rxrpc_notify_end_tx_t notify_end_tx,
 			   bool *_dropped_lock)
 {
@@ -327,9 +327,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
-		if (len - copied > call->tx_total_len)
+		if (msg_data_left(msg) > call->tx_total_len)
 			goto maybe_error;
-		if (!more && len - copied != call->tx_total_len)
+		if (!more && msg_data_left(msg) != call->tx_total_len)
 			goto maybe_error;
 	}
 
@@ -612,7 +612,7 @@ rxrpc_new_client_call_for_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg,
  * - caller holds the socket locked
  * - the socket may be either a client socket or a server socket
  */
-int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
+int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg)
 	__releases(&rx->sk.sk_lock.slock)
 {
 	struct rxrpc_call *call;
@@ -723,7 +723,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
 	} else {
-		ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
+		ret = rxrpc_send_data(rx, call, msg, NULL, &dropped_lock);
 	}
 
 out_put_unlock:
@@ -744,7 +744,6 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
  * @sock: The socket the call is on
  * @call: The call to send data through
  * @msg: The data to send
- * @len: The amount of data to send
  * @notify_end_tx: Notification that the last packet is queued.
  *
  * Allow a kernel service to send data on a call.  The call must be in an state
@@ -753,7 +752,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
  * more data to come, otherwise this data will end the transmission phase.
  */
 int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
-			   struct msghdr *msg, size_t len,
+			   struct msghdr *msg,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
 	bool dropped_lock = false;
@@ -766,7 +765,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 
 	mutex_lock(&call->user_mutex);
 
-	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
+	ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg,
 			      notify_end_tx, &dropped_lock);
 	if (ret == -ESHUTDOWN)
 		ret = call->error;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b91616f819de..da99aab89d82 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1935,7 +1935,7 @@ static void sctp_sendmsg_update_sinfo(struct sctp_association *asoc,
 	}
 }
 
-static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
+static int sctp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_transport *transport = NULL;
@@ -1943,6 +1943,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	struct sctp_association *asoc, *tmp;
 	struct sctp_cmsgs cmsgs;
 	union sctp_addr *daddr;
+	size_t msg_len = msg_data_left(msg);
 	bool new = false;
 	__u16 sflags;
 	int err;
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c6b4a62276f6..0e725698ebcd 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2653,10 +2653,11 @@ static int smc_getname(struct socket *sock, struct sockaddr *addr,
 	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
 }
 
-static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int smc_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
+	size_t len = msg_data_left(msg);
 	int rc;
 
 	smc = smc_sk(sk);
@@ -2681,7 +2682,7 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	}
 
 	if (smc->use_fallback) {
-		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg, len);
+		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg);
 	} else {
 		rc = smc_tx_sendmsg(smc, msg, len);
 		SMC_STAT_TX_PAYLOAD(smc, len, rc);
diff --git a/net/socket.c b/net/socket.c
index 73e493da4589..1690e1782bf0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -708,10 +708,8 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 }
 EXPORT_SYMBOL(__sock_tx_timestamp);
 
-INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
-					   size_t));
-INDIRECT_CALLABLE_DECLARE(int inet6_sendmsg(struct socket *, struct msghdr *,
-					    size_t));
+INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *));
+INDIRECT_CALLABLE_DECLARE(int inet6_sendmsg(struct socket *, struct msghdr *));
 
 static noinline void call_trace_sock_send_length(struct sock *sk, int ret,
 						 int flags)
@@ -722,8 +720,7 @@ static noinline void call_trace_sock_send_length(struct sock *sk, int ret,
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
 	int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
-				     inet_sendmsg, sock, msg,
-				     msg_data_left(msg));
+				     inet_sendmsg, sock, msg);
 	BUG_ON(ret == -EIOCBQUEUED);
 
 	if (trace_sock_send_length_enabled())
@@ -741,8 +738,7 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
  */
 int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
-	int err = security_socket_sendmsg(sock, msg,
-					  msg_data_left(msg));
+	int err = security_socket_sendmsg(sock, msg);
 
 	return err ?: sock_sendmsg_nosec(sock, msg);
 }
@@ -787,11 +783,11 @@ int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 	struct socket *sock = sk->sk_socket;
 
 	if (!sock->ops->sendmsg_locked)
-		return sock_no_sendmsg_locked(sk, msg, size);
+		return sock_no_sendmsg_locked(sk, msg);
 
 	iov_iter_kvec(&msg->msg_iter, ITER_SOURCE, vec, num, size);
 
-	return sock->ops->sendmsg_locked(sk, msg, msg_data_left(msg));
+	return sock->ops->sendmsg_locked(sk, msg);
 }
 EXPORT_SYMBOL(kernel_sendmsg_locked);
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 37edfe10f8c6..bd677e707548 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -156,8 +156,8 @@ static int tipc_sk_leave(struct tipc_sock *tsk);
 static struct tipc_sock *tipc_sk_lookup(struct net *net, u32 portid);
 static int tipc_sk_insert(struct tipc_sock *tsk);
 static void tipc_sk_remove(struct tipc_sock *tsk);
-static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
-static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
+static int __tipc_sendstream(struct socket *sock, struct msghdr *m);
+static int __tipc_sendmsg(struct socket *sock, struct msghdr *m);
 static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
 static int tipc_wait_for_connect(struct socket *sock, long *timeo_p);
 
@@ -1385,7 +1385,6 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
  * tipc_sendmsg - send message in connectionless manner
  * @sock: socket structure
  * @m: message to send
- * @dsz: amount of user data to be sent
  *
  * Message must have an destination specified explicitly.
  * Used for SOCK_RDM and SOCK_DGRAM messages,
@@ -1394,20 +1393,19 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
  *
  * Return: the number of bytes sent on success, or errno otherwise
  */
-static int tipc_sendmsg(struct socket *sock,
-			struct msghdr *m, size_t dsz)
+static int tipc_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	int ret;
 
 	lock_sock(sk);
-	ret = __tipc_sendmsg(sock, m, dsz);
+	ret = __tipc_sendmsg(sock, m);
 	release_sock(sk);
 
 	return ret;
 }
 
-static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
+static int __tipc_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
@@ -1420,6 +1418,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct tipc_socket_addr skaddr;
 	struct sk_buff_head pkts;
+	size_t dlen = msg_data_left(m);
 	int atype, mtu, rc;
 
 	if (unlikely(dlen > TIPC_MAX_USER_MSG_SIZE))
@@ -1535,26 +1534,25 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
  * tipc_sendstream - send stream-oriented data
  * @sock: socket structure
  * @m: data to send
- * @dsz: total length of data to be transmitted
  *
  * Used for SOCK_STREAM data.
  *
  * Return: the number of bytes sent on success (or partial success),
  * or errno if no data sent
  */
-static int tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz)
+static int tipc_sendstream(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	int ret;
 
 	lock_sock(sk);
-	ret = __tipc_sendstream(sock, m, dsz);
+	ret = __tipc_sendstream(sock, m);
 	release_sock(sk);
 
 	return ret;
 }
 
-static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
+static int __tipc_sendstream(struct socket *sock, struct msghdr *m)
 {
 	struct sock *sk = sock->sk;
 	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
@@ -1564,6 +1562,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
 	struct sk_buff *skb;
+	size_t dlen = msg_data_left(m);
 	u32 dnode = tsk_peer_node(tsk);
 	int maxnagle = tsk->maxnagle;
 	int maxpkt = tsk->max_pkt;
@@ -1575,7 +1574,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 
 	/* Handle implicit connection setup */
 	if (unlikely(dest && sk->sk_state == TIPC_OPEN)) {
-		rc = __tipc_sendmsg(sock, m, dlen);
+		rc = __tipc_sendmsg(sock, m);
 		if (dlen && dlen == rc) {
 			tsk->peer_caps = tipc_node_get_capabilities(net, dnode);
 			tsk->snt_unacked = tsk_inc(tsk, dlen + msg_hdr_sz(hdr));
@@ -1643,18 +1642,17 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
  * tipc_send_packet - send a connection-oriented message
  * @sock: socket structure
  * @m: message to send
- * @dsz: length of data to be transmitted
  *
  * Used for SOCK_SEQPACKET messages.
  *
  * Return: the number of bytes sent on success, or errno otherwise
  */
-static int tipc_send_packet(struct socket *sock, struct msghdr *m, size_t dsz)
+static int tipc_send_packet(struct socket *sock, struct msghdr *m)
 {
-	if (dsz > TIPC_MAX_USER_MSG_SIZE)
+	if (msg_data_left(m) > TIPC_MAX_USER_MSG_SIZE)
 		return -EMSGSIZE;
 
-	return tipc_sendstream(sock, m, dsz);
+	return tipc_sendstream(sock, m);
 }
 
 /* tipc_sk_finish_conn - complete the setup of a connection
@@ -2625,7 +2623,7 @@ static int tipc_connect(struct socket *sock, struct sockaddr *dest,
 		if (!timeout)
 			m.msg_flags = MSG_DONTWAIT;
 
-		res = __tipc_sendmsg(sock, &m, 0);
+		res = __tipc_sendmsg(sock, &m);
 		if ((res < 0) && (res != -EWOULDBLOCK))
 			goto exit;
 
@@ -2781,7 +2779,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		skb_set_owner_r(buf, new_sk);
 	}
 	iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
-	__tipc_sendstream(new_sock, &m, 0);
+	__tipc_sendstream(new_sock, &m);
 	release_sock(new_sk);
 exit:
 	release_sock(sk);
diff --git a/net/tls/tls.h b/net/tls/tls.h
index 804c3880d028..a969955ddd7c 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -96,7 +96,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
-int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg);
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 			   int offset, size_t size, int flags);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
@@ -114,7 +114,7 @@ ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
 
-int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_device_sendmsg(struct sock *sk, struct msghdr *msg);
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags);
 int tls_tx_records(struct sock *sk, int flags);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..3616dde20a96 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -566,7 +566,7 @@ static int tls_push_data(struct sock *sk,
 	return rc;
 }
 
-int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+int tls_device_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -583,7 +583,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	}
 
 	iter.msg_iter = &msg->msg_iter;
-	rc = tls_push_data(sk, iter, size, msg->msg_flags, record_type, NULL);
+	rc = tls_push_data(sk, iter, msg_data_left(msg), msg->msg_flags,
+			   record_type, NULL);
 
 out:
 	release_sock(sk);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 635b8bf6b937..17ea9b07a277 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -929,7 +929,7 @@ static int tls_sw_push_pending_record(struct sock *sk, int flags)
 				   &copied, flags);
 }
 
-int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fb31e8a4409e..37c96a73e6b4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -756,20 +756,20 @@ static int unix_ioctl(struct socket *, unsigned int, unsigned long);
 static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
 #endif
 static int unix_shutdown(struct socket *, int);
-static int unix_stream_sendmsg(struct socket *, struct msghdr *, size_t);
+static int unix_stream_sendmsg(struct socket *, struct msghdr *);
 static int unix_stream_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static ssize_t unix_stream_sendpage(struct socket *, struct page *, int offset,
 				    size_t size, int flags);
 static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       struct pipe_inode_info *, size_t size,
 				       unsigned int flags);
-static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
+static int unix_dgram_sendmsg(struct socket *, struct msghdr *);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
-static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
+static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *);
 static int unix_seqpacket_recvmsg(struct socket *, struct msghdr *, size_t,
 				  int);
 
@@ -1888,14 +1888,14 @@ static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
  *	Send AF_UNIX data.
  */
 
-static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
-			      size_t len)
+static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
 	struct sock *sk = sock->sk, *other = NULL;
 	struct unix_sock *u = unix_sk(sk);
 	struct scm_cookie scm;
 	struct sk_buff *skb;
+	size_t len = msg_data_left(msg);
 	int data_len = 0;
 	int sk_locked;
 	long timeo;
@@ -2157,11 +2157,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 }
 #endif
 
-static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct sock *other = NULL;
+	size_t len = msg_data_left(msg);
 	int err, size;
 	struct sk_buff *skb;
 	int sent = 0;
@@ -2388,8 +2388,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 	return err;
 }
 
-static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
-				  size_t len)
+static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 	struct sock *sk = sock->sk;
@@ -2404,7 +2403,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (msg->msg_namelen)
 		msg->msg_namelen = 0;
 
-	return unix_dgram_sendmsg(sock, msg, len);
+	return unix_dgram_sendmsg(sock, msg);
 }
 
 static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 19aea7cba26e..20bac3e04abd 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1131,8 +1131,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
-static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
-			       size_t len)
+static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int err;
 	struct sock *sk;
@@ -1198,7 +1197,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
-	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+	err = transport->dgram_enqueue(vsk, remote_addr, msg, msg_data_left(msg));
 
 out:
 	release_sock(sk);
@@ -1737,8 +1736,7 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 	return 0;
 }
 
-static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
-				     size_t len)
+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1794,7 +1792,7 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err < 0)
 		goto out;
 
-	while (total_written < len) {
+	while (msg_data_left(msg)) {
 		ssize_t written;
 
 		add_wait_queue(sk_sleep(sk), &wait);
@@ -1856,10 +1854,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		if (sk->sk_type == SOCK_SEQPACKET) {
 			written = transport->seqpacket_enqueue(vsk,
-						msg, len - total_written);
+					msg, msg_data_left(msg));
 		} else {
 			written = transport->stream_enqueue(vsk,
-					msg, len - total_written);
+					msg, msg_data_left(msg));
 		}
 
 		if (written < 0) {
@@ -1882,7 +1880,7 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		 * 1) SOCK_STREAM socket.
 		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
 		 */
-		if (sk->sk_type == SOCK_STREAM || total_written == len)
+		if (sk->sk_type == SOCK_STREAM || !msg_data_left(msg))
 			err = total_written;
 	}
 out:
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 5c7ad301d742..5b8751669136 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1100,7 +1100,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	goto out;
 }
 
-static int x25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int x25_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sock *sk = sock->sk;
 	struct x25_sock *x25 = x25_sk(sk);
@@ -1108,6 +1108,7 @@ static int x25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sockaddr_x25 sx25;
 	struct sk_buff *skb;
 	unsigned char *asmptr;
+	size_t len = msg_data_left(msg);
 	int noblock = msg->msg_flags & MSG_DONTWAIT;
 	size_t size;
 	int qbit = 0, rc = -EINVAL;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2ac58b282b5e..db82e2a287f5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -629,7 +629,7 @@ static int xsk_check_common(struct xdp_sock *xs)
 	return 0;
 }
 
-static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int __xsk_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -663,12 +663,12 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	return 0;
 }
 
-static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int xsk_sendmsg(struct socket *sock, struct msghdr *m)
 {
 	int ret;
 
 	rcu_read_lock();
-	ret = __xsk_sendmsg(sock, m, total_len);
+	ret = __xsk_sendmsg(sock, m);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 872b80188e83..d07faa356347 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -311,13 +311,14 @@ int espintcp_push_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(espintcp_push_skb);
 
-static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 	struct espintcp_msg *emsg = &ctx->partial;
 	struct iov_iter pfx_iter;
 	struct kvec pfx_iov = {};
+	size_t size = msg_data_left(msg);
 	size_t msglen = size + 2;
 	char buf[2] = {0};
 	int err, end;
@@ -325,7 +326,7 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (msg->msg_flags & ~MSG_DONTWAIT)
 		return -EOPNOTSUPP;
 
-	if (size > MAX_ESPINTCP_MSG)
+	if (msg_data_left(msg) > MAX_ESPINTCP_MSG)
 		return -EMSGSIZE;
 
 	if (msg->msg_controllen)
@@ -362,7 +363,8 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (err < 0)
 		goto fail;
 
-	err = sk_msg_memcopy_from_iter(sk, &msg->msg_iter, &emsg->skmsg, size);
+	err = sk_msg_memcopy_from_iter(sk, &msg->msg_iter, &emsg->skmsg,
+				       msg_data_left(msg));
 	if (err < 0)
 		goto fail;
 
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index d6cc4812ca53..cb220a8e8126 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -997,10 +997,10 @@ static int aa_sock_msg_perm(const char *op, u32 request, struct socket *sock,
 /**
  * apparmor_socket_sendmsg - check perms before sending msg to another socket
  */
-static int apparmor_socket_sendmsg(struct socket *sock,
-				   struct msghdr *msg, int size)
+static int apparmor_socket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
-	return aa_sock_msg_perm(OP_SENDMSG, AA_MAY_SEND, sock, msg, size);
+	return aa_sock_msg_perm(OP_SENDMSG, AA_MAY_SEND, sock, msg,
+				msg_data_left(msg));
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index cf6cc576736f..faa87f363af8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2301,9 +2301,9 @@ int security_socket_accept(struct socket *sock, struct socket *newsock)
 	return call_int_hook(socket_accept, 0, sock, newsock);
 }
 
-int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
+int security_socket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
-	return call_int_hook(socket_sendmsg, 0, sock, msg, size);
+	return call_int_hook(socket_sendmsg, 0, sock, msg);
 }
 
 int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a5bdfc21314..ff0d82e6331d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4912,8 +4912,7 @@ static int selinux_socket_accept(struct socket *sock, struct socket *newsock)
 	return 0;
 }
 
-static int selinux_socket_sendmsg(struct socket *sock, struct msghdr *msg,
-				  int size)
+static int selinux_socket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	return sock_has_perm(sock->sk, SOCKET__WRITE);
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index cfcbb748da25..ca30c105f254 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3730,14 +3730,12 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
  * smack_socket_sendmsg - Smack check based on destination host
  * @sock: the socket
  * @msg: the message
- * @size: the size of the message
  *
  * Return 0 if the current subject can write to the destination host.
  * For IPv4 this is only a question if the destination is a single label host.
  * For IPv6 this is a check against the label of the port.
  */
-static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
-				int size)
+static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index ca285f362705..0841098d966a 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -997,8 +997,7 @@ int tomoyo_socket_bind_permission(struct socket *sock, struct sockaddr *addr,
 int tomoyo_socket_connect_permission(struct socket *sock,
 				     struct sockaddr *addr, int addr_len);
 int tomoyo_socket_listen_permission(struct socket *sock);
-int tomoyo_socket_sendmsg_permission(struct socket *sock, struct msghdr *msg,
-				     int size);
+int tomoyo_socket_sendmsg_permission(struct socket *sock, struct msghdr *msg);
 int tomoyo_supervisor(struct tomoyo_request_info *r, const char *fmt, ...)
 	__printf(2, 3);
 int tomoyo_update_domain(struct tomoyo_acl_info *new_entry, const int size,
diff --git a/security/tomoyo/network.c b/security/tomoyo/network.c
index 8dc61335f65e..0315b335cdff 100644
--- a/security/tomoyo/network.c
+++ b/security/tomoyo/network.c
@@ -751,12 +751,10 @@ int tomoyo_socket_bind_permission(struct socket *sock, struct sockaddr *addr,
  *
  * @sock: Pointer to "struct socket".
  * @msg:  Pointer to "struct msghdr".
- * @size: Unused.
  *
  * Returns 0 on success, negative value otherwise.
  */
-int tomoyo_socket_sendmsg_permission(struct socket *sock, struct msghdr *msg,
-				     int size)
+int tomoyo_socket_sendmsg_permission(struct socket *sock, struct msghdr *msg)
 {
 	struct tomoyo_addr_info address;
 	const u8 family = tomoyo_sock_family(sock->sk);
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index af04a7b7eb28..72c6f343ffba 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -489,14 +489,12 @@ static int tomoyo_socket_bind(struct socket *sock, struct sockaddr *addr,
  *
  * @sock: Pointer to "struct socket".
  * @msg:  Pointer to "struct msghdr".
- * @size: Size of message.
  *
  * Returns 0 on success, negative value otherwise.
  */
-static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
-				 int size)
+static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg)
 {
-	return tomoyo_socket_sendmsg_permission(sock, msg, size);
+	return tomoyo_socket_sendmsg_permission(sock, msg);
 }
 
 struct lsm_blob_sizes tomoyo_blob_sizes __lsm_ro_after_init = {

