Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6245D4AF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347534AbhKYG0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:26:25 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56884 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347307AbhKYGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:24:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyDiBcg_1637821271;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyDiBcg_1637821271)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 14:21:12 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net 1/2] net/smc: Keep smc_close_final rc during active close
Date:   Thu, 25 Nov 2021 14:19:33 +0800
Message-Id: <20211125061932.74874-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211125061932.74874-1-tonylu@linux.alibaba.com>
References: <20211125061932.74874-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When smc_close_final() returns error, the return code overwrites by
kernel_sock_shutdown() in smc_close_active(). The return code of
smc_close_final() is more important than kernel_sock_shutdown(), and it
will pass to userspace directly.

Fix it by keeping both return codes, if smc_close_final() raises an
error, return it or kernel_sock_shutdown()'s.

Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_close.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 3715d2f5ad55..292e4d904ab6 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -195,6 +195,7 @@ int smc_close_active(struct smc_sock *smc)
 	int old_state;
 	long timeout;
 	int rc = 0;
+	int rc1 = 0;
 
 	timeout = current->flags & PF_EXITING ?
 		  0 : sock_flag(sk, SOCK_LINGER) ?
@@ -232,8 +233,11 @@ int smc_close_active(struct smc_sock *smc)
 			/* actively shutdown clcsock before peer close it,
 			 * prevent peer from entering TIME_WAIT state.
 			 */
-			if (smc->clcsock && smc->clcsock->sk)
-				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
+			if (smc->clcsock && smc->clcsock->sk) {
+				rc1 = kernel_sock_shutdown(smc->clcsock,
+							   SHUT_RDWR);
+				rc = rc ? rc : rc1;
+			}
 		} else {
 			/* peer event has changed the state */
 			goto again;
-- 
2.32.0.3.g01195cf9f

