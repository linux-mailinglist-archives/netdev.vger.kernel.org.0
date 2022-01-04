Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4028648422B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiADNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:12:47 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:48625 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbiADNMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:12:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0xwEaA_1641301963;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V0xwEaA_1641301963)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 21:12:44 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock listen queue
Date:   Tue,  4 Jan 2022 21:12:41 +0800
Message-Id: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

In nginx/wrk multithread and 10K connections benchmark, the
backend TCP connection established very slowly, and lots of TCP
connections stay in SYN_SENT state.

Server: smc_run nginx

Client: smc_run wrk -c 10000 -t 4 http://server

Socket state in client host (wrk) shows like:

ss -t  | wc -l
10000

ss -t  | grep "SYN-SENT"  | wc -l
6248

While the socket state in server host (nginx) shows like:

ss -t  | wc -l
3752

Furthermore, the netstate of server host shows like:
    145042 times the listen queue of a socket overflowed
    145042 SYNs to LISTEN sockets dropped

This issue caused by smc_listen_work(), since the smc_tcp_listen_work()
shared the same workqueue (smc_hs_wq) with smc_listen_work(), while
smc_listen_work() do blocking wait for smc connection established, which
meanwhile block the accept() from TCP listen queue.

This patch creates a independent workqueue(smc_tcp_ls_wq) for
smc_tcp_listen_work(), separate it from smc_listen_work(), which is
quite acceptable considering that smc_tcp_listen_work() runs very fast.

After this patch, the smc 10K connections benchmark in my case is 5
times faster than before.

Before patch :

smc_run  ./wrk -c 10000 -t 3 -d 20  http://server
  3 threads and 10000 connections
  143300 requests in 20.04s, 94.29MB read
Requests/sec:   7150.33
Transfer/sec:      4.70MB

After patch:

smc_run  ./wrk -c 10000 -t 3 -d 20  http://server
  3 threads and 10000 connections
  902091 requests in 21.99s, 593.56MB read
Requests/sec:  41017.52
Transfer/sec:     26.99MB

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
changelog:
v2: code format
---
 net/smc/af_smc.c | 13 +++++++++++--
 net/smc/smc.h    |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0bb614e..08722c0 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -62,6 +62,7 @@
 						 * creation on client
 						 */
 
+struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
@@ -1872,7 +1873,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
-		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
+		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
 }
@@ -2610,9 +2611,14 @@ static int __init smc_init(void)
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
@@ -2709,6 +2715,8 @@ static int __init smc_init(void)
 	destroy_workqueue(smc_close_wq);
 out_alloc_hs_wq:
 	destroy_workqueue(smc_hs_wq);
+out_alloc_tcp_ls_wq:
+	destroy_workqueue(smc_tcp_ls_wq);
 out_pnet:
 	smc_pnet_exit();
 out_nl:
@@ -2728,6 +2736,7 @@ static void __exit smc_exit(void)
 	smc_core_exit();
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
+	destroy_workqueue(smc_tcp_ls_wq);
 	destroy_workqueue(smc_hs_wq);
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index b1d6625..18fa803 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -256,6 +256,7 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
-- 
1.8.3.1

