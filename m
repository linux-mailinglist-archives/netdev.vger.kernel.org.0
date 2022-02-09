Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A827C4AF3C5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiBIOLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiBIOLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:11:20 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3722EC06157B;
        Wed,  9 Feb 2022 06:11:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4.YhE9_1644415880;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4.YhE9_1644415880)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 22:11:20 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v6 1/5] net/smc: Make smc_tcp_listen_work() independent
Date:   Wed,  9 Feb 2022 22:11:11 +0800
Message-Id: <75b1108013d44bdaab905db9ab75ad2a16619b57.1644413637.git.alibuda@linux.alibaba.com>
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
the workqueue became congested, it's will block the accept() from TCP
listen.

This patch creates a independent workqueue(smc_tcp_ls_wq) for
smc_tcp_listen_work(), separate it from smc_listen_work(), which is
quite acceptable considering that smc_tcp_listen_work() runs very fast.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00b2e9d..4969ac8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -59,6 +59,7 @@
 						 * creation on client
 						 */
 
+static struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
@@ -2227,7 +2228,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
-		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
+		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
 }
@@ -3024,9 +3025,14 @@ static int __init smc_init(void)
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
@@ -3097,6 +3103,8 @@ static int __init smc_init(void)
 	destroy_workqueue(smc_close_wq);
 out_alloc_hs_wq:
 	destroy_workqueue(smc_hs_wq);
+out_alloc_tcp_ls_wq:
+	destroy_workqueue(smc_tcp_ls_wq);
 out_pnet:
 	smc_pnet_exit();
 out_nl:
@@ -3115,6 +3123,7 @@ static void __exit smc_exit(void)
 	smc_core_exit();
 	smc_ib_unregister_client();
 	destroy_workqueue(smc_close_wq);
+	destroy_workqueue(smc_tcp_ls_wq);
 	destroy_workqueue(smc_hs_wq);
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
-- 
1.8.3.1

