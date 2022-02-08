Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B54E4AD968
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiBHNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359731AbiBHMxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:53:25 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41F4C03FECE;
        Tue,  8 Feb 2022 04:53:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3wYVms_1644324798;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3wYVms_1644324798)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 20:53:19 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v5 2/5] net/smc: Limit backlog connections
Date:   Tue,  8 Feb 2022 20:53:10 +0800
Message-Id: <c597e6c6d004e5b2a26a9535c8099d389214f273.1644323503.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1644323503.git.alibuda@linux.alibaba.com>
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
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

Current implementation does not handling backlog semantics, one
potential risk is that server will be flooded by infinite amount
connections, even if client was SMC-incapable.

This patch works to put a limit on backlog connections, referring to the
TCP implementation, we divides SMC connections into two categories:

1. Half SMC connection, which includes all TCP established while SMC not
connections.

2. Full SMC connection, which includes all SMC established connections.

For half SMC connection, since all half SMC connections starts with TCP
established, we can achieve our goal by put a limit before TCP
established. Refer to the implementation of TCP, this limits will based
on not only the half SMC connections but also the full connections,
which is also a constraint on full SMC connections.

For full SMC connections, although we know exactly where it starts, it's
quite hard to put a limit before it. The easiest way is to block wait
before receive SMC confirm CLC message, while it's under protection by
smc_server_lgr_pending, a global lock, which leads this limit to the
entire host instead of a single listen socket. Another way is to drop
the full connections, but considering the cast of SMC connections, we
prefer to keep full SMC connections.

Even so, the limits of full SMC connections still exists, see commits
about half SMC connection below.

After this patch, the limits of backend connection shows like:

For SMC:

1. Client with SMC-capability can makes 2 * backlog full SMC connections
   or 1 * backlog half SMC connections and 1 * backlog full SMC
   connections at most.

2. Client without SMC-capability can only makes 1 * backlog half TCP
   connections and 1 * backlog full TCP connections.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc.h    |  4 ++++
 2 files changed, 47 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 4969ac8..ebfce3d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -73,6 +73,34 @@ static void smc_set_keepalive(struct sock *sk, int val)
 	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
 }
 
+static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
+					  struct request_sock *req,
+					  struct dst_entry *dst,
+					  struct request_sock *req_unhash,
+					  bool *own_req)
+{
+	struct smc_sock *smc;
+
+	smc = (struct smc_sock *)((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);
+
+	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->smc_pendings) >
+				sk->sk_max_ack_backlog)
+		goto drop;
+
+	if (sk_acceptq_is_full(&smc->sk)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		goto drop;
+	}
+
+	/* passthrough to origin syn recv sock fct */
+	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
+
+drop:
+	dst_release(dst);
+	tcp_listendrop(sk);
+	return NULL;
+}
+
 static struct smc_hashinfo smc_v4_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
 };
@@ -1595,6 +1623,9 @@ static void smc_listen_out(struct smc_sock *new_smc)
 	struct smc_sock *lsmc = new_smc->listen_smc;
 	struct sock *newsmcsk = &new_smc->sk;
 
+	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
+		atomic_dec(&lsmc->smc_pendings);
+
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
@@ -2200,6 +2231,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
 		if (!new_smc)
 			continue;
 
+		if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
+			atomic_inc(&lsmc->smc_pendings);
+
 		new_smc->listen_smc = lsmc;
 		new_smc->use_fallback = lsmc->use_fallback;
 		new_smc->fallback_rsn = lsmc->fallback_rsn;
@@ -2266,6 +2300,15 @@ static int smc_listen(struct socket *sock, int backlog)
 	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+
+	/* save origin ops */
+	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
+
+	smc->af_ops = *smc->ori_af_ops;
+	smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
+
+	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
+
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
 		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 37b2001..5e5e38d 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -252,6 +252,10 @@ struct smc_sock {				/* smc sock container */
 	bool			use_fallback;	/* fallback to tcp */
 	int			fallback_rsn;	/* reason for fallback */
 	u32			peer_diagnosis; /* decline reason from peer */
+	atomic_t                smc_pendings;   /* pending smc connections */
+	struct inet_connection_sock_af_ops		af_ops;
+	const struct inet_connection_sock_af_ops	*ori_af_ops;
+						/* origin af ops */
 	int			sockopt_defer_accept;
 						/* sockopt TCP_DEFER_ACCEPT
 						 * value
-- 
1.8.3.1

