Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863FD4758DA
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbhLOM30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:29:26 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:40515 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242428AbhLOM3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:29:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V-j2cWu_1639571363;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V-j2cWu_1639571363)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Dec 2021 20:29:23 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net] net/smc: Prevent smc_release() from long blocking
Date:   Wed, 15 Dec 2021 20:29:21 +0800
Message-Id: <1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

In nginx/wrk benchmark, there's a hung problem with high probability
on case likes that: (client will last several minutes to exit)

server: smc_run nginx

client: smc_run wrk -c 10000 -t 1 http://server

Client hangs with the following backtrace:

0 [ffffa7ce8Of3bbf8] __schedule at ffffffff9f9eOd5f
1 [ffffa7ce8Of3bc88] schedule at ffffffff9f9eløe6
2 [ffffa7ce8Of3bcaO] schedule_timeout at ffffffff9f9e3f3c
3 [ffffa7ce8Of3bd2O] wait_for_common at ffffffff9f9el9de
4 [ffffa7ce8Of3bd8O] __flush_work at ffffffff9fOfeOl3
5 [ffffa7ce8øf3bdfO] smc_release at ffffffffcO697d24 [smc]
6 [ffffa7ce8Of3be2O] __sock_release at ffffffff9f8O2e2d
7 [ffffa7ce8Of3be4ø] sock_close at ffffffff9f8ø2ebl
8 [ffffa7ce8øf3be48] __fput at ffffffff9f334f93
9 [ffffa7ce8Of3be78] task_work_run at ffffffff9flOlff5
10 [ffffa7ce8Of3beaO] do_exit at ffffffff9fOe5Ol2
11 [ffffa7ce8Of3bflO] do_group_exit at ffffffff9fOe592a
12 [ffffa7ce8Of3bf38] __x64_sys_exit_group at ffffffff9fOe5994
13 [ffffa7ce8Of3bf4O] do_syscall_64 at ffffffff9f9d4373
14 [ffffa7ce8Of3bfsO] entry_SYSCALL_64_after_hwframe at ffffffff9fa0007c

This issue dues to flush_work(), which is used to wait for
smc_connect_work() to finish in smc_release(). Once lots of
smc_connect_work() was pending or all executing work dangling,
smc_release() has to block until one worker comes to free, which
is equivalent to wait another smc_connnect_work() to finish.

In order to fix this, There are two changes:

1. For those idle smc_connect_work(), cancel it from the workqueue; for
   executing smc_connect_work(), waiting for it to finish. For that
   purpose, replace flush_work() with cancel_work_sync().

2. Since smc_connect() hold a reference for passive closing, if
   smc_connect_work() has been cancelled, release the reference.

Fixes: 24ac3a08e658 ("smc: rebuild nonblocking connect")
Reported-by: Tony Lu <tonylu@linux.alibaba.com>
Tested-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com> 
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b44cc4c..5d9911c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -195,7 +195,9 @@ static int smc_release(struct socket *sock)
 	/* cleanup for a dangling non-blocking connect */
 	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
-	flush_work(&smc->connect_work);
+
+	if (cancel_work_sync(&smc->connect_work))
+		sock_put(&smc->sk); /* sock_hold in smc_connect for passive closing */
 
 	if (sk->sk_state == SMC_LISTEN)
 		/* smc_close_non_accepted() is called and acquires
-- 
1.8.3.1

