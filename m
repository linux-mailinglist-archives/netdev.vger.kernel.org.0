Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C300D6D9C6B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbjDFPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbjDFPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:30:51 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C408A7E;
        Thu,  6 Apr 2023 08:30:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfTVmhw_1680795043;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VfTVmhw_1680795043)
          by smtp.aliyun-inc.com;
          Thu, 06 Apr 2023 23:30:43 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 3/5] net/smc: allow set or get smc negotiator by sockopt
Date:   Thu,  6 Apr 2023 23:30:32 +0800
Message-Id: <1680795034-86384-4-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
References: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Allow applications to set specific protocol negotiation rules for SMC
Socks. Typically, applications need to know the name of the negotiator
and then set it through the syscall setsockopt, for examples:

const char name[] = "apps";
setsockopt(fd, SOL_SMC, SMC_NEGOTIATOR, name, sizeof(name) - 1);

Noted that there is no default negotiator in SMC implementation,
the application needs to inject the specific implementation through
eBPF before setting it up. Although no default negotiator implementation
is provided,

Note that SMC does not provide a default negotiator in SMC
implementation,
and the application needs to inject the specific implementation through
eBPF before setting it up. Although no default negotiator implementation
is provided, logically it can be seen as an implementation that
always return SK_PASS.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/uapi/linux/smc.h |   1 +
 net/smc/af_smc.c         | 135 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 102 insertions(+), 34 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index bb4dacc..1887ed5 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -299,5 +299,6 @@ enum {
 
 /* SMC socket options */
 #define SMC_LIMIT_HS 1	/* constraint on smc handshake */
+#define SMC_NEGOTIATOR 2 /* SMC protocol negotiator */
 
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 567feef..05e5aaf 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2932,48 +2932,41 @@ static int smc_shutdown(struct socket *sock, int how)
 	return rc ? rc : rc1;
 }
 
-static int __smc_getsockopt(struct socket *sock, int level, int optname,
-			    char __user *optval, int __user *optlen)
+/* set smc negotoiatior by name */
+static int smc_setsockopt_negotiator(struct sock *sk, sockptr_t optval,
+				     unsigned int optlen)
 {
-	struct smc_sock *smc;
-	int val, len;
-
-	smc = smc_sk(sock->sk);
-
-	if (get_user(len, optlen))
-		return -EFAULT;
-
-	len = min_t(int, len, sizeof(int));
+#ifdef CONFIG_SMC_BPF
+	char name[SMC_NEGOTIATOR_NAME_MAX];
+	struct smc_sock *smc = smc_sk(sk);
+	int val, rc;
 
-	if (len < 0)
+	if (optlen < 1)
 		return -EINVAL;
 
-	switch (optname) {
-	case SMC_LIMIT_HS:
-		val = smc->limit_smc_hs;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
+	val = strncpy_from_sockptr(name, optval,
+				   min_t(long, SMC_NEGOTIATOR_NAME_MAX - 1, optlen));
+	if (val < 0)
 		return -EFAULT;
 
-	return 0;
+	/* typical c str */
+	name[val] = 0;
+
+	sockopt_lock_sock(sk);
+	rc = smc_sock_assign_negotiator_ops(smc, name);
+	sockopt_release_sock(sk);
+	return rc;
+#else
+	return -EOPNOTSUPP;
+#endif
 }
 
-static int __smc_setsockopt(struct socket *sock, int level, int optname,
+static int __smc_setsockopt(struct sock *sk, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
-	struct sock *sk = sock->sk;
-	struct smc_sock *smc;
+	struct smc_sock *smc = smc_sk(sk);
 	int val, rc;
 
-	smc = smc_sk(sk);
-
-	lock_sock(sk);
 	switch (optname) {
 	case SMC_LIMIT_HS:
 		if (optlen < sizeof(int)) {
@@ -2984,15 +2977,17 @@ static int __smc_setsockopt(struct socket *sock, int level, int optname,
 			rc = -EFAULT;
 			break;
 		}
-
+		sockopt_lock_sock(sk);
 		smc->limit_smc_hs = !!val;
+		sockopt_release_sock(sk);
 		rc = 0;
 		break;
+	case SMC_NEGOTIATOR:
+		return smc_setsockopt_negotiator(sk, optval, optlen);
 	default:
 		rc = -EOPNOTSUPP;
 		break;
 	}
-	release_sock(sk);
 
 	return rc;
 }
@@ -3007,7 +3002,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (level == SOL_TCP && optname == TCP_ULP)
 		return -EOPNOTSUPP;
 	else if (level == SOL_SMC)
-		return __smc_setsockopt(sock, level, optname, optval, optlen);
+		return __smc_setsockopt(sk, level, optname, optval, optlen);
 
 	smc = smc_sk(sk);
 
@@ -3084,6 +3079,77 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	return rc;
 }
 
+/* get current negotoiatior sock used */
+static int smc_getsockopt_negotiator(struct sock *sk, sockptr_t optval,
+				     sockptr_t optlen)
+{
+#ifdef CONFIG_SMC_BPF
+	const struct smc_sock_negotiator_ops *ops;
+	struct smc_sock *smc = smc_sk(sk);
+	int len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, sizeof(int));
+
+	if (len < 0)
+		return -EINVAL;
+
+	rcu_read_lock();
+	ops = READ_ONCE(smc->negotiator_ops);
+	if (ops) {
+		len = min_t(unsigned int, len, SMC_NEGOTIATOR_NAME_MAX);
+		if (copy_to_sockptr(optval, ops->name, len)) {
+			rcu_read_unlock();
+			return -EFAULT;
+		}
+	} else {
+		len = 0;
+	}
+	rcu_read_unlock();
+
+	if (copy_to_sockptr(optlen, &len, sizeof(int)))
+		return -EFAULT;
+
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int __smc_getsockopt(struct sock *sk, int level, int optname,
+			    sockptr_t optval, sockptr_t optlen)
+{
+	struct smc_sock *smc = smc_sk(sk);
+	int val, len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, sizeof(int));
+
+	if (len < 0)
+		return -EINVAL;
+
+	switch (optname) {
+	case SMC_LIMIT_HS:
+		val = smc->limit_smc_hs;
+		break;
+	case SMC_NEGOTIATOR:
+		return smc_getsockopt_negotiator(sk, optval, optlen);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (copy_to_sockptr(optval, &val, len))
+		return -EFAULT;
+	if (copy_to_sockptr(optlen, &len, sizeof(int)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int smc_getsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
@@ -3091,7 +3157,8 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 	int rc;
 
 	if (level == SOL_SMC)
-		return __smc_getsockopt(sock, level, optname, optval, optlen);
+		return __smc_getsockopt(sock->sk, level, optname,
+					USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 
 	smc = smc_sk(sock->sk);
 	mutex_lock(&smc->clcsock_release_lock);
-- 
1.8.3.1

