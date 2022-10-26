Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79A60DE9D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiJZKHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiJZKHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:07:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2020F8A1F5;
        Wed, 26 Oct 2022 03:07:45 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4My4Cj5FrYzpSt1;
        Wed, 26 Oct 2022 18:04:17 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:43 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:42 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH openEuler-1.0-LTS v2 2/4] inet: factor out inet_send_prepare()
Date:   Wed, 26 Oct 2022 18:28:17 +0800
Message-ID: <1666780099-9989-3-git-send-email-xujia39@huawei.com>
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
commit e473093639945cb0a07ad4d51d5fd3fc3c3708cf
category: bugfix
bugzilla: 187846
CVE: CVE-2022-3567

Reference: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e473093639945cb0a07ad4d51d5fd3fc3c3708cf

---------------------------

The same code is replicated verbatim in multiple places, and the next
patches will introduce an additional user for it. Factor out a
helper and use it where appropriate. No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 include/net/inet_common.h |  1 +
 net/ipv4/af_inet.c        | 21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 3ca969c..4c2a6b1 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -23,6 +23,7 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags);
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
+int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ba71648..d526dd6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -784,10 +784,8 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL(inet_getname);
 
-int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+int inet_send_prepare(struct sock *sk)
 {
-	struct sock *sk = sock->sk;
-
 	sock_rps_record_flow(sk);
 
 	/* We may need to bind the socket. */
@@ -795,6 +793,17 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	    inet_autobind(sk))
 		return -EAGAIN;
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inet_send_prepare);
+
+int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return -EAGAIN;
+
 	return sk->sk_prot->sendmsg(sk, msg, size);
 }
 EXPORT_SYMBOL(inet_sendmsg);
@@ -804,11 +813,7 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 {
 	struct sock *sk = sock->sk;
 
-	sock_rps_record_flow(sk);
-
-	/* We may need to bind the socket. */
-	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
-	    inet_autobind(sk))
+	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
 	if (sk->sk_prot->sendpage)
-- 
1.8.3.1

