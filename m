Return-Path: <netdev+bounces-2034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0B2700046
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB841C210FD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3794D6ABD;
	Fri, 12 May 2023 06:25:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5263B6;
	Fri, 12 May 2023 06:25:01 +0000 (UTC)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F53C16;
	Thu, 11 May 2023 23:24:58 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0ViNyZOP_1683872692;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0ViNyZOP_1683872692)
          by smtp.aliyun-inc.com;
          Fri, 12 May 2023 14:24:53 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: kgraul@linux.ibm.com,
	wenjia@linux.ibm.com,
	jaka@linux.ibm.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	pabeni@redhat.com,
	song@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	yhs@fb.com,
	edumazet@google.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	jolsa@kernel.org,
	guwen@linux.alibaba.com
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH bpf-next v1 3/5] net/smc: allow set or get smc negotiator by sockopt
Date: Fri, 12 May 2023 14:24:42 +0800
Message-Id: <1683872684-64872-4-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
References: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

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
 net/smc/af_smc.c         | 131 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 98 insertions(+), 34 deletions(-)

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
index 7406fd4..a433c74 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3001,48 +3001,37 @@ static int smc_shutdown(struct socket *sock, int how)
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
@@ -3053,15 +3042,17 @@ static int __smc_setsockopt(struct socket *sock, int level, int optname,
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
@@ -3076,7 +3067,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (level == SOL_TCP && optname == TCP_ULP)
 		return -EOPNOTSUPP;
 	else if (level == SOL_SMC)
-		return __smc_setsockopt(sock, level, optname, optval, optlen);
+		return __smc_setsockopt(sk, level, optname, optval, optlen);
 
 	smc = smc_sk(sk);
 
@@ -3153,6 +3144,77 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
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
@@ -3160,7 +3222,8 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 	int rc;
 
 	if (level == SOL_SMC)
-		return __smc_getsockopt(sock, level, optname, optval, optlen);
+		return __smc_getsockopt(sock->sk, level, optname,
+					USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 
 	smc = smc_sk(sock->sk);
 	mutex_lock(&smc->clcsock_release_lock);
-- 
1.8.3.1


