Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8648BEDD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 08:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351141AbiALHLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 02:11:39 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33911 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237258AbiALHLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 02:11:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1dZVxb_1641971494;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V1dZVxb_1641971494)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jan 2022 15:11:34 +0800
Date:   Wed, 12 Jan 2022 15:11:34 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
Message-ID: <20220112071134.GA47613@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 05:38:25PM +0800, Wen Gu wrote:
>We encountered a crash in smc_setsockopt() and it is caused by
>accessing smc->clcsock after clcsock was released.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000020
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
> RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
> Call Trace:
>  <TASK>
>  __sys_setsockopt+0xfc/0x190
>  __x64_sys_setsockopt+0x20/0x30
>  do_syscall_64+0x34/0x90
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f16ba83918e
>  </TASK>
>
>This patch tries to fix it by holding clcsock_release_lock and
>checking whether clcsock has already been released. In case that
>a crash of the same reason happens in smc_getsockopt(), this patch
>also checkes smc->clcsock in smc_getsockopt().
>
>Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>---
> net/smc/af_smc.c | 16 +++++++++++++++-
> 1 file changed, 15 insertions(+), 1 deletion(-)
>
>diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>index 1c9289f..af423f4 100644
>--- a/net/smc/af_smc.c
>+++ b/net/smc/af_smc.c
>@@ -2441,6 +2441,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
> 	/* generic setsockopts reaching us here always apply to the
> 	 * CLC socket
> 	 */
>+	mutex_lock(&smc->clcsock_release_lock);
>+	if (!smc->clcsock) {
>+		mutex_unlock(&smc->clcsock_release_lock);
>+		return -EBADF;
>+	}
> 	if (unlikely(!smc->clcsock->ops->setsockopt))
> 		rc = -EOPNOTSUPP;
> 	else
>@@ -2450,6 +2455,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
> 		sk->sk_err = smc->clcsock->sk->sk_err;
> 		sk_error_report(sk);
> 	}
>+	mutex_unlock(&smc->clcsock_release_lock);
> 
> 	if (optlen < sizeof(int))
> 		return -EINVAL;
>@@ -2509,13 +2515,21 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
> 			  char __user *optval, int __user *optlen)
> {
> 	struct smc_sock *smc;
>+	int rc;
> 
> 	smc = smc_sk(sock->sk);
>+	mutex_lock(&smc->clcsock_release_lock);
>+	if (!smc->clcsock) {
>+		mutex_unlock(&smc->clcsock_release_lock);
>+		return -EBADF;
>+	}
> 	/* socket options apply to the CLC socket */
> 	if (unlikely(!smc->clcsock->ops->getsockopt))
Missed a mutex_unlock() here ?

> 		return -EOPNOTSUPP;

>-	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
>+	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
> 					     optval, optlen);
>+	mutex_unlock(&smc->clcsock_release_lock);
>+	return rc;
> }
> 
> static int smc_ioctl(struct socket *sock, unsigned int cmd,
>-- 
>1.8.3.1
