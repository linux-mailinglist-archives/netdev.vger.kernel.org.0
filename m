Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E760DE9A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiJZKH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiJZKHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:07:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B39923EA;
        Wed, 26 Oct 2022 03:07:46 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4My4Ck666bzpVpb;
        Wed, 26 Oct 2022 18:04:18 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:44 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:43 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH openEuler-1.0-LTS v2 4/4] ipv6: Fix data races around sk->sk_prot.
Date:   Wed, 26 Oct 2022 18:28:19 +0800
Message-ID: <1666780099-9989-5-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666780099-9989-1-git-send-email-xujia39@huawei.com>
References: <1666780099-9989-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

mainline inclusion
from mainline-6.1-rc1
commit 364f997b5cfe1db0d63a390fe7c801fa2b3115f6
category: bugfix
bugzilla: 187846
CVE: CVE-2022-3567

Reference: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=364f997b5cfe1db0d63a390fe7c801fa2b3115f6

---------------------------

Commit 086d49058cd8 ("ipv6: annotate some data-races around sk->sk_prot")
fixed some data-races around sk->sk_prot but it was not enough.

Some functions in inet6_(stream|dgram)_ops still access sk->sk_prot
without lock_sock() or rtnl_lock(), so they need READ_ONCE() to avoid
load tearing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Conflicts:
	net/ipv6/ipv6_sockglue.c

Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 net/core/sock.c          | 26 ++++++++++++++++----------
 net/ipv4/af_inet.c       | 23 ++++++++++++++++-------
 net/ipv6/ipv6_sockglue.c |  4 ++--
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6e891db..be898a8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3067,7 +3067,8 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_getsockopt);
 
@@ -3076,11 +3077,13 @@ int compat_sock_common_getsockopt(struct socket *sock, int level, int optname,
 				  char __user *optval, int __user *optlen)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
-	if (sk->sk_prot->compat_getsockopt != NULL)
-		return sk->sk_prot->compat_getsockopt(sk, level, optname,
-						      optval, optlen);
-	return sk->sk_prot->getsockopt(sk, level, optname, optval, optlen);
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->compat_getsockopt != NULL)
+		return prot->compat_getsockopt(sk, level, optname,
+					       optval, optlen);
+	return prot->getsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(compat_sock_common_getsockopt);
 #endif
@@ -3108,7 +3111,8 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
-	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	return READ_ONCE(sk->sk_prot)->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
 
@@ -3117,11 +3121,13 @@ int compat_sock_common_setsockopt(struct socket *sock, int level, int optname,
 				  char __user *optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
-	if (sk->sk_prot->compat_setsockopt != NULL)
-		return sk->sk_prot->compat_setsockopt(sk, level, optname,
-						      optval, optlen);
-	return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->compat_setsockopt != NULL)
+		return prot->compat_setsockopt(sk, level, optname,
+					       optval, optlen);
+	return prot->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(compat_sock_common_setsockopt);
 #endif
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d526dd6..428efff 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -553,22 +553,27 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 	int err;
 
 	if (addr_len < sizeof(uaddr->sa_family))
 		return -EINVAL;
+
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+
 	if (uaddr->sa_family == AF_UNSPEC)
-		return sk->sk_prot->disconnect(sk, flags);
+		return prot->disconnect(sk, flags);
 
 	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
-		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
+		err = prot->pre_connect(sk, uaddr, addr_len);
 		if (err)
 			return err;
 	}
 
 	if (!inet_sk(sk)->inet_num && inet_autobind(sk))
 		return -EAGAIN;
-	return sk->sk_prot->connect(sk, uaddr, addr_len);
+	return prot->connect(sk, uaddr, addr_len);
 }
 EXPORT_SYMBOL(inet_dgram_connect);
 
@@ -729,10 +734,11 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern)
 {
-	struct sock *sk1 = sock->sk;
+	struct sock *sk1 = sock->sk, *sk2;
 	int err = -EINVAL;
-	struct sock *sk2 = sk1->sk_prot->accept(sk1, flags, &err, kern);
 
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, flags, &err, kern);
 	if (!sk2)
 		goto do_err;
 
@@ -812,12 +818,15 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags)
 {
 	struct sock *sk = sock->sk;
+	const struct proto *prot;
 
 	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
-	if (sk->sk_prot->sendpage)
-		return sk->sk_prot->sendpage(sk, page, offset, size, flags);
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->sendpage)
+		return prot->sendpage(sk, page, offset, size, flags);
 	return sock_no_sendpage(sock, page, offset, size, flags);
 }
 EXPORT_SYMBOL(inet_sendpage);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 97e8c34..dccbc71 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -230,7 +230,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, &tcp_prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
 				WRITE_ONCE(sk->sk_prot, &tcp_prot);
 				/* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
 				WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
@@ -246,7 +246,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				sock_prot_inuse_add(net, sk->sk_prot, -1);
 				sock_prot_inuse_add(net, prot, 1);
 				local_bh_enable();
-				/* Paired with READ_ONCE(sk->sk_prot) in net/ipv6/af_inet6.c */
+				/* Paired with READ_ONCE(sk->sk_prot) in inet6_dgram_ops */
 				WRITE_ONCE(sk->sk_prot, prot);
 				sk->sk_socket->ops = &inet_dgram_ops;
 				sk->sk_family = PF_INET;
-- 
1.8.3.1

