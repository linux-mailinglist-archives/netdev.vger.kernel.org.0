Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A335489570
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243029AbiAJJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:38:36 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58163 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243064AbiAJJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:38:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1PG-vG_1641807505;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1PG-vG_1641807505)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 17:38:33 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Avoid setting clcsock options after clcsock released
Date:   Mon, 10 Jan 2022 17:38:25 +0800
Message-Id: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encountered a crash in smc_setsockopt() and it is caused by
accessing smc->clcsock after clcsock was released.

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
 RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
 Call Trace:
  <TASK>
  __sys_setsockopt+0xfc/0x190
  __x64_sys_setsockopt+0x20/0x30
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f16ba83918e
  </TASK>

This patch tries to fix it by holding clcsock_release_lock and
checking whether clcsock has already been released. In case that
a crash of the same reason happens in smc_getsockopt(), this patch
also checkes smc->clcsock in smc_getsockopt().

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1c9289f..af423f4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2441,6 +2441,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	/* generic setsockopts reaching us here always apply to the
 	 * CLC socket
 	 */
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	if (unlikely(!smc->clcsock->ops->setsockopt))
 		rc = -EOPNOTSUPP;
 	else
@@ -2450,6 +2455,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk_error_report(sk);
 	}
+	mutex_unlock(&smc->clcsock_release_lock);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -2509,13 +2515,21 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
 	struct smc_sock *smc;
+	int rc;
 
 	smc = smc_sk(sock->sk);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (!smc->clcsock) {
+		mutex_unlock(&smc->clcsock_release_lock);
+		return -EBADF;
+	}
 	/* socket options apply to the CLC socket */
 	if (unlikely(!smc->clcsock->ops->getsockopt))
 		return -EOPNOTSUPP;
-	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
+	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
 					     optval, optlen);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_ioctl(struct socket *sock, unsigned int cmd,
-- 
1.8.3.1

