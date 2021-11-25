Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC02F45D4BF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348867AbhKYG1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:27:31 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:52526 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347376AbhKYGZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:25:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyDiZwl_1637821337;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyDiZwl_1637821337)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 14:22:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: Don't call clcsock shutdown twice when smc shutdown
Date:   Thu, 25 Nov 2021 14:19:35 +0800
Message-Id: <20211125061932.74874-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211125061932.74874-1-tonylu@linux.alibaba.com>
References: <20211125061932.74874-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When applications call shutdown() with SHUT_RDWR in userspace,
smc_close_active() calls kernel_sock_shutdown(), and it is called
twice in smc_shutdown().

This fixes this by checking sk_state before do clcsock shutdown, and
avoids missing the application's call of smc_shutdown().

Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 4b62c925a13e..7b04cb4d15f4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2373,6 +2373,7 @@ static int smc_shutdown(struct socket *sock, int how)
 	struct smc_sock *smc;
 	int rc = -EINVAL;
 	int rc1 = 0;
+	int old_state;
 
 	smc = smc_sk(sk);
 
@@ -2398,7 +2399,12 @@ static int smc_shutdown(struct socket *sock, int how)
 	}
 	switch (how) {
 	case SHUT_RDWR:		/* shutdown in both directions */
+		old_state = sk->sk_state;
 		rc = smc_close_active(smc);
+		if (old_state == SMC_ACTIVE &&
+		    sk->sk_state == SMC_PEERCLOSEWAIT1)
+			goto out_no_shutdown;
+
 		break;
 	case SHUT_WR:
 		rc = smc_close_shutdown_write(smc);
@@ -2410,6 +2416,8 @@ static int smc_shutdown(struct socket *sock, int how)
 	}
 	if (smc->clcsock)
 		rc1 = kernel_sock_shutdown(smc->clcsock, how);
+
+out_no_shutdown:
 	/* map sock_shutdown_cmd constants to sk_shutdown value range */
 	sk->sk_shutdown |= how + 1;
 
-- 
2.32.0.3.g01195cf9f

