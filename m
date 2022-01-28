Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6B49FBFE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349389AbiA1OpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:45:09 -0500
Received: from out199-10.us.a.mail.aliyun.com ([47.90.199.10]:50277 "EHLO
        out199-10.us.a.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349404AbiA1OpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:45:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V334mTe_1643381096;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V334mTe_1643381096)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 Jan 2022 22:44:57 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        matthieu.baerts@tessares.net,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH v2 net-next 3/3] net/smc: Fallback when handshake workqueue congested
Date:   Fri, 28 Jan 2022 22:44:38 +0800
Message-Id: <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1643380219.git.alibuda@linux.alibaba.com>
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch intends to provide a mechanism to allow automatic fallback to
TCP according to the pressure of SMC handshake process. At present,
frequent visits will cause the incoming connections to be backlogged in
SMC handshake queue, raise the connections established time. Which is
quite unacceptable for those applications who base on short lived
connections.

It should be optional for applications that don't care about connection
established time. For now, this patch only provides the switch at the
compile time.

There are two ways to implement this mechanism:

1. Fallback when TCP established.
2. Fallback before TCP established.

In the first way, we need to wait and receive CLC messages that the
client will potentially send, and then actively reply with a decline
message, in a sense, which is also a sort of SMC handshake, affect the
connections established time on its way.

In the second way, the only problem is that we need to inject SMC logic
into TCP when it is about to reply the incoming SYN, since we already do
that, it's seems not a problem anymore. And advantage is obvious, few
additional processes are required to complete the fallback.

This patch use the second way.

Link: https://lore.kernel.org/all/1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com/
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
changelog:
v2: fix invalid dependencies for kconfig 
---
 include/linux/tcp.h  |  1 +
 net/ipv4/tcp_input.c |  3 ++-
 net/smc/Kconfig      | 12 ++++++++++++
 net/smc/af_smc.c     | 22 ++++++++++++++++++++++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 78b91bb..1c4ae5d 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -394,6 +394,7 @@ struct tcp_sock {
 	bool	is_mptcp;
 #endif
 #if IS_ENABLED(CONFIG_SMC)
+	bool	(*smc_in_limited)(const struct sock *sk);
 	bool	syn_smc;	/* SYN includes SMC */
 #endif
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d..9890de9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6701,7 +6701,8 @@ static void tcp_openreq_init(struct request_sock *req,
 	ireq->ir_num = ntohs(tcp_hdr(skb)->dest);
 	ireq->ir_mark = inet_request_mark(sk, skb);
 #if IS_ENABLED(CONFIG_SMC)
-	ireq->smc_ok = rx_opt->smc_ok;
+	ireq->smc_ok = rx_opt->smc_ok && !(tcp_sk(sk)->smc_in_limited &&
+			tcp_sk(sk)->smc_in_limited(sk));
 #endif
 }
 
diff --git a/net/smc/Kconfig b/net/smc/Kconfig
index 1ab3c5a..a4e1713 100644
--- a/net/smc/Kconfig
+++ b/net/smc/Kconfig
@@ -19,3 +19,15 @@ config SMC_DIAG
 	  smcss.
 
 	  if unsure, say Y.
+
+if SMC
+
+config SMC_AUTO_FALLBACK
+	bool "SMC: automatic fallback to TCP"
+	default y
+	help
+	  Allow automatic fallback to TCP accroding to the pressure of SMC-R
+	  handshake process.
+
+	  If that's not what you except or unsure, say N.
+endif
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 66a0e64..49b8a29 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -101,6 +101,24 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_SMC_AUTO_FALLBACK)
+static bool smc_is_in_limited(const struct sock *sk)
+{
+	const struct smc_sock *smc;
+
+	smc = (const struct smc_sock *)
+		((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);
+
+	if (!smc)
+		return true;
+
+	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
+		return true;
+
+	return false;
+}
+#endif
+
 static struct smc_hashinfo smc_v4_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
 };
@@ -2206,6 +2224,10 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
 
+#if IS_ENABLED(CONFIG_SMC_AUTO_FALLBACK)
+	tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;
+#endif
+
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
 		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
-- 
1.8.3.1

