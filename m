Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A7C44C19A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhKJMx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:53:59 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:63052 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhKJMx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:53:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UvuzFxJ_1636548651;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UvuzFxJ_1636548651)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Nov 2021 20:50:59 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com
Subject: [RFC PATCH net 2/2] net/smc: Transfer remaining wait queue entries during fallback
Date:   Wed, 10 Nov 2021 20:50:51 +0800
Message-Id: <1636548651-44649-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
References: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SMC fallback is incomplete currently. There may be some
wait queue entries remaining in smc socket->wq, which should
be removed to clcsocket->wq during the fallback.

For example, in nginx/wrk benchmark, this issue causes an
all-zeros test result:

server: nginx -g 'daemon off;'
client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html

  Running 5s test @ http://11.200.15.93/index.html
     1 threads and 1 connections
     Thread Stats   Avg      Stdev     Max   ± Stdev
     	Latency     0.00us    0.00us   0.00us    -nan%
	Req/Sec     0.00      0.00     0.00      -nan%
	0 requests in 5.00s, 0.00B read
     Requests/sec:      0.00
     Transfer/sec:       0.00B

The reason for this all-zeros result is that when wrk used SMC
to replace TCP, it added an eppoll_entry into smc socket->wq
and expected to be notified if epoll events like EPOLL_IN/
EPOLL_OUT occurred on the smc socket.

However, once a fallback occurred, wrk switches to use clcsocket.
Now it is clcsocket->wq instead of smc socket->wq which will
be woken up. The eppoll_entry remaining in smc socket->wq does
not work anymore and wrk stops the test.

This patch fixes this issue by removing remaining wait queue
entries from smc socket->wq to clcsocket->wq during the fallback.

Link: https://lore.kernel.org/all/db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0cf7ed2..11a966a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -562,6 +562,10 @@ static void smc_stat_fallback(struct smc_sock *smc)
 
 static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
+	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
+	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
+	unsigned long flags;
+
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -571,6 +575,16 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->file->private_data = smc->clcsock;
 		smc->clcsock->wq.fasync_list =
 			smc->sk.sk_socket->wq.fasync_list;
+
+		/* There might be some wait queue entries remaining
+		 * in smc socket->wq, which should be removed to
+		 * clcsocket->wq during the fallback.
+		 */
+		spin_lock_irqsave(&smc_wait->lock, flags);
+		spin_lock_irqsave(&clc_wait->lock, flags);
+		list_splice_init(&smc_wait->head, &clc_wait->head);
+		spin_unlock_irqrestore(&clc_wait->lock, flags);
+		spin_unlock_irqrestore(&smc_wait->lock, flags);
 	}
 }
 
-- 
1.8.3.1

