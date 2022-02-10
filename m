Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C104B0937
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiBJJLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:11:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiBJJLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:11:43 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD55103E;
        Thu, 10 Feb 2022 01:11:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V43Rnh9_1644484301;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V43Rnh9_1644484301)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 17:11:41 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v7 3/5] net/smc: Limit SMC visits when handshake workqueue congested
Date:   Thu, 10 Feb 2022 17:11:36 +0800
Message-Id: <f894f58e311ce5da675af38ae3c1a7d5160dc909.1644481811.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644481811.git.alibuda@linux.alibaba.com>
References: <cover.1644481811.git.alibuda@linux.alibaba.com>
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

This patch intends to provide a mechanism to put constraint on SMC
connections visit according to the pressure of SMC handshake process.
At present, frequent visits will cause the incoming connections to be
backlogged in SMC handshake queue, raise the connections established
time. Which is quite unacceptable for those applications who base on
short lived connections.

There are two ways to implement this mechanism:

1. Put limitation after TCP established.
2. Put limitation before TCP established.

In the first way, we need to wait and receive CLC messages that the
client will potentially send, and then actively reply with a decline
message, in a sense, which is also a sort of SMC handshake, affect the
connections established time on its way.

In the second way, the only problem is that we need to inject SMC logic
into TCP when it is about to reply the incoming SYN, since we already do
that, it's seems not a problem anymore. And advantage is obvious, few
additional processes are required to complete the constraint.

This patch use the second way. After this patch, connections who beyond
constraint will not informed any SMC indication, and SMC will not be
involved in any of its subsequent processes.

Link: https://lore.kernel.org/all/1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com/
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/linux/tcp.h  |  1 +
 net/ipv4/tcp_input.c |  3 ++-
 net/smc/af_smc.c     | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 78b91bb..1168302 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -394,6 +394,7 @@ struct tcp_sock {
 	bool	is_mptcp;
 #endif
 #if IS_ENABLED(CONFIG_SMC)
+	bool	(*smc_hs_congested)(const struct sock *sk);
 	bool	syn_smc;	/* SYN includes SMC */
 #endif
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af94a6d..92e65d5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6703,7 +6703,8 @@ static void tcp_openreq_init(struct request_sock *req,
 	ireq->ir_num = ntohs(tcp_hdr(skb)->dest);
 	ireq->ir_mark = inet_request_mark(sk, skb);
 #if IS_ENABLED(CONFIG_SMC)
-	ireq->smc_ok = rx_opt->smc_ok;
+	ireq->smc_ok = rx_opt->smc_ok && !(tcp_sk(sk)->smc_hs_congested &&
+			tcp_sk(sk)->smc_hs_congested(sk));
 #endif
 }
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8587242..a05ffb2 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -103,6 +103,21 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
 	return NULL;
 }
 
+static bool smc_hs_congested(const struct sock *sk)
+{
+	const struct smc_sock *smc;
+
+	smc = smc_clcsock_user_data(sk);
+
+	if (!smc)
+		return true;
+
+	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
+		return true;
+
+	return false;
+}
+
 static struct smc_hashinfo smc_v4_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
 };
@@ -2311,6 +2326,8 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
 
+	tcp_sk(smc->clcsock->sk)->smc_hs_congested = smc_hs_congested;
+
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
 		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
-- 
1.8.3.1

