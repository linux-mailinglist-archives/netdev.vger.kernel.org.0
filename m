Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54049FBF3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349378AbiA1Oo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:44:59 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39312 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349091AbiA1Oo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:44:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V334mTQ_1643381093;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V334mTQ_1643381093)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 Jan 2022 22:44:54 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        matthieu.baerts@tessares.net,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH v2 net-next 1/3] net/smc: Make smc_tcp_listen_work() independent
Date:   Fri, 28 Jan 2022 22:44:36 +0800
Message-Id: <53383b68f056b4c6d697935d2ea1c170618eebbe.1643380219.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1643380219.git.alibuda@linux.alibaba.com>
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

In multithread and 10K connections benchmark, the backend TCP connection
established very slowly, and lots of TCP connections stay in SYN_SENT
state.

Client: smc_run wrk -c 10000 -t 4 http://server

the netstate of server host shows like:
    145042 times the listen queue of a socket overflowed
    145042 SYNs to LISTEN sockets dropped

One reason of this issue is that, since the smc_tcp_listen_work() shared
the same workqueue (smc_hs_wq) with smc_listen_work(), while the
smc_listen_work() do blocking wait for smc connection established. Once
the workqueue became congested, it's will block the accpet() from TCP
listen.

This patch creates a independent workqueue(smc_tcp_ls_wq) for
smc_tcp_listen_work(), separate it from smc_listen_work(), which is
quite acceptable considering that smc_tcp_listen_work() runs very fast.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 13 +++++++++++--
 net/smc/smc.h    |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d5ea62b..1b40304 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -59,6 +59,7 @@
 						 * creation on client
 						 */
 
+struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
@@ -2124,7 +2125,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
-		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
+		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
 }
@@ -2919,9 +2920,14 @@ static int __init smc_init(void)
 		goto out_nl;
 
 	rc = -ENOMEM;
+
+	smc_tcp_ls_wq = alloc_workqueue("smc_tcp_ls_wq", 0, 0);
+	if (!smc_tcp_ls_wq)
+		goto out_pnet;
+
 	smc_hs_wq = alloc_workqueue("smc_hs_wq", 0, 0);
 	if (!smc_hs_wq)
-		goto out_pnet;
+		goto out_alloc_tcp_ls_wq;
 
 	smc_close_wq = alloc_workqueue("smc_close_wq", 0, 0);
 	if (!smc_close_wq)
@@ -2992,6 +2998,8 @@ static int __init smc_init(void)
 	destroy_workqueue(smc_close_wq);
 out_alloc_hs_wq:
 	destroy_workqueue(smc_hs_wq);
+out_alloc_tcp_ls_wq:
+	destroy_workqueue(smc_tcp_ls_wq);
 out_pnet:
 	smc_pnet_exit();
 out_nl:
@@ -3010,6 +3018,7 @@ static void __exit smc_exit(void)
 	smc_core_exit();
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
+	destroy_workqueue(smc_tcp_ls_wq);
 	destroy_workqueue(smc_hs_wq);
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 3d0b8e3..bd2f3dc 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -264,6 +264,7 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
-- 
1.8.3.1

