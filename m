Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7E60DE96
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiJZKHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiJZKHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:07:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DEE8A1E2;
        Wed, 26 Oct 2022 03:07:44 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4My4B15HGRzmV7d;
        Wed, 26 Oct 2022 18:02:49 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:42 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:42 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH openEuler-1.0-LTS v2 1/4] ipv6: provide and use ipv6 specific version for {recv, send}msg
Date:   Wed, 26 Oct 2022 18:28:16 +0800
Message-ID: <1666780099-9989-2-git-send-email-xujia39@huawei.com>
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

From: Paolo Abeni <pabeni@redhat.com>

mainline inclusion
from mainline-v5.3-rc1
commit 68ab5d1496a35f3a76b68fed57719bfc46a51e07
category: bugfix
bugzilla: 187846
CVE: CVE-2022-3567

Reference: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=68ab5d1496a35f3a76b68fed57719bfc46a51e07

---------------------------

This will simplify indirect call wrapper invocation in the following
patch.

No functional change intended, any - out-of-tree - IPv6 user of
inet_{recv,send}msg can keep using the existing functions.

SCTP code still uses the existing version even for ipv6: as this series
will not add ICW for SCTP, moving to the new helper would not give
any benefit.

The only other in-kernel user of inet_{recv,send}msg is
pvcalls_conn_back_read(), but psvcalls explicitly creates only IPv4 socket,
so no need to update that code path, too.

v1 -> v2: drop inet6_{recv,send}msg declaration from header file,
   prefer ICW macro instead

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 net/ipv6/af_inet6.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 5c2351d..bf95759 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -574,6 +574,33 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(inet6_ioctl);
 
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return -EAGAIN;
+
+	return sk->sk_prot->sendmsg(sk, msg, size);
+}
+
+int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		  int flags)
+{
+	struct sock *sk = sock->sk;
+	int addr_len = 0;
+	int err;
+
+	if (likely(!(flags & MSG_ERRQUEUE)))
+		sock_rps_record_flow(sk);
+
+	err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+				   flags & ~MSG_DONTWAIT, &addr_len);
+	if (err >= 0)
+		msg->msg_namelen = addr_len;
+	return err;
+}
+
 const struct proto_ops inet6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
@@ -589,8 +616,8 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
-	.recvmsg	   = inet_recvmsg,		/* ok		*/
+	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
+	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
@@ -622,8 +649,8 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
-	.recvmsg	   = inet_recvmsg,		/* ok		*/
+	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
+	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
-- 
1.8.3.1

