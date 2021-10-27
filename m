Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE343C59A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbhJ0IzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:55:12 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:35796 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241060AbhJ0IzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:55:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uts5tnc_1635324763;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uts5tnc_1635324763)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:52:43 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc fallback
Date:   Wed, 27 Oct 2021 16:52:10 +0800
Message-Id: <20211027085208.16048-5-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211027085208.16048-1-tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

A socket_wq mismatch issue may occur because of fallback.

When use SMC to replace TCP, applications add an epoll entry into SMC
socket's wq, but kernel uses clcsock's wq instead of SMC socket's wq
once fallback occurs, which means the application's epoll fd dosen't
work anymore.

For example:
server: nginx -g 'daemon off;'

client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html

  Running 5s test @ http://11.200.15.93/index.html
    1 threads and 1 connections
    Thread Stats   Avg      Stdev     Max   +/- Stdev
      Latency     0.00us    0.00us   0.00us    -nan%
      Req/Sec     0.00      0.00     0.00      -nan%
    0 requests in 5.00s, 0.00B read
  Requests/sec:      0.00
  Transfer/sec:       0.00B

This patch fixes this issue by using clcsock's wq regardless of
whether fallback occurs.

Reported-by: Jacob Qi <jacob.qi@linux.alibaba.com>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 78b663dbfa1f..3b7ec0abff52 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -546,6 +546,10 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
+
+	/* clcsock's sock uses back to clcsock->wq, see also smc_create() */
+	rcu_assign_pointer(smc->clcsock->sk->sk_wq, &smc->clcsock->wq);
+
 	smc_stat_fallback(smc);
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
@@ -1972,6 +1976,10 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
 	if (rc)
 		goto out;
 
+	/* new smc sock uses clcsock's wq. see also smc_create() */
+	if (!smc_sk(nsk)->use_fallback)
+		rcu_assign_pointer(nsk->sk_wq, &smc_sk(nsk)->clcsock->wq);
+
 	if (lsmc->sockopt_defer_accept && !(flags & O_NONBLOCK)) {
 		/* wait till data arrives on the socket */
 		timeo = msecs_to_jiffies(lsmc->sockopt_defer_accept *
@@ -2108,6 +2116,9 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 		mask = smc->clcsock->ops->poll(file, smc->clcsock, wait);
 		sk->sk_err = smc->clcsock->sk->sk_err;
 	} else {
+		/* use clcsock->wq in sock_poll_wait(), see also smc_create() */
+		sock = smc->clcsock;
+
 		if (sk->sk_state != SMC_CLOSED)
 			sock_poll_wait(file, sock, wait);
 		if (sk->sk_err)
@@ -2505,6 +2516,10 @@ static int smc_create(struct net *net, struct socket *sock, int protocol,
 	smc->sk.sk_sndbuf = max(smc->clcsock->sk->sk_sndbuf, SMC_BUF_MIN_SIZE);
 	smc->sk.sk_rcvbuf = max(smc->clcsock->sk->sk_rcvbuf, SMC_BUF_MIN_SIZE);
 
+	/* In case smc fallbacks to tcp, smc's sock will use clcsock's wq in advance */
+	rcu_assign_pointer(sk->sk_wq, &smc->clcsock->wq);
+	rcu_assign_pointer(smc->clcsock->sk->sk_wq, &smc->sk.sk_socket->wq);
+
 out:
 	return rc;
 }
-- 
2.19.1.6.gb485710b

