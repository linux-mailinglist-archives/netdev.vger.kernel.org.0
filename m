Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857374AF3CC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiBIOLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbiBIOLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:11:31 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15421C05CBA4;
        Wed,  9 Feb 2022 06:11:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4.ipev_1644415884;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4.ipev_1644415884)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 22:11:24 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v6 4/5] net/smc: Dynamic control auto fallback by socket options
Date:   Wed,  9 Feb 2022 22:11:14 +0800
Message-Id: <47e067deb658407bc68899ee9e6827f8159f11b4.1644413637.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644413637.git.alibuda@linux.alibaba.com>
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch aims to add dynamic control for SMC auto fallback, since we
don't have socket option level for SMC yet, which requires we need to
implement it at the same time.

This patch does the following:

- add new socket option level: SOL_SMC.
- add new SMC socket option: SMC_AUTO_FALLBACK.
- provide getter/setter for SMC socket options.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/linux/socket.h   |  1 +
 include/uapi/linux/smc.h |  4 +++
 net/smc/af_smc.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc.h            |  1 +
 4 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8ef26d8..6f85f5d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -366,6 +366,7 @@ struct ucred {
 #define SOL_XDP		283
 #define SOL_MPTCP	284
 #define SOL_MCTP	285
+#define SOL_SMC		286
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 6c2874f..9f2cbf8 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -284,4 +284,8 @@ enum {
 	__SMC_NLA_SEID_TABLE_MAX,
 	SMC_NLA_SEID_TABLE_MAX = __SMC_NLA_SEID_TABLE_MAX - 1
 };
+
+/* SMC socket options */
+#define SMC_AUTO_FALLBACK 1	/* allow auto fallback to TCP */
+
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8175f60..c313561 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2325,7 +2325,8 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
 
-	tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;
+	if (smc->auto_fallback)
+		tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
@@ -2620,6 +2621,67 @@ static int smc_shutdown(struct socket *sock, int how)
 	return rc ? rc : rc1;
 }
 
+static int __smc_getsockopt(struct socket *sock, int level, int optname,
+			    char __user *optval, int __user *optlen)
+{
+	struct smc_sock *smc;
+	int val, len;
+
+	smc = smc_sk(sock->sk);
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	len = min_t(int, len, sizeof(int));
+
+	if (len < 0)
+		return -EINVAL;
+
+	switch (optname) {
+	case SMC_AUTO_FALLBACK:
+		val = smc->auto_fallback;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int __smc_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+	struct smc_sock *smc;
+	int val, rc;
+
+	smc = smc_sk(sk);
+
+	lock_sock(sk);
+	switch (optname) {
+	case SMC_AUTO_FALLBACK:
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (copy_from_sockptr(&val, optval, sizeof(int)))
+			return -EFAULT;
+
+		smc->auto_fallback = !!val;
+		rc = 0;
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+		break;
+	}
+	release_sock(sk);
+
+	return rc;
+}
+
 static int smc_setsockopt(struct socket *sock, int level, int optname,
 			  sockptr_t optval, unsigned int optlen)
 {
@@ -2629,6 +2691,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 
 	if (level == SOL_TCP && optname == TCP_ULP)
 		return -EOPNOTSUPP;
+	else if (level == SOL_SMC)
+		return __smc_setsockopt(sock, level, optname, optval, optlen);
 
 	smc = smc_sk(sk);
 
@@ -2711,6 +2775,9 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int rc;
 
+	if (level == SOL_SMC)
+		return __smc_getsockopt(sock, level, optname, optval, optlen);
+
 	smc = smc_sk(sock->sk);
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 5e5e38d..a0bdf75 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -249,6 +249,7 @@ struct smc_sock {				/* smc sock container */
 	struct work_struct	smc_listen_work;/* prepare new accept socket */
 	struct list_head	accept_q;	/* sockets to be accepted */
 	spinlock_t		accept_q_lock;	/* protects accept_q */
+	bool			auto_fallback;	/* auto fallabck to tcp */
 	bool			use_fallback;	/* fallback to tcp */
 	int			fallback_rsn;	/* reason for fallback */
 	u32			peer_diagnosis; /* decline reason from peer */
-- 
1.8.3.1

