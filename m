Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF0748F666
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 11:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiAOK3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 05:29:50 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:53810 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbiAOK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 05:29:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1si10H_1642242587;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V1si10H_1642242587)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 15 Jan 2022 18:29:48 +0800
Date:   Sat, 15 Jan 2022 18:29:47 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Fix hung_task when removing SMC-R devices
Message-ID: <20220115102947.GB13341@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1642167444-107744-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1642167444-107744-1-git-send-email-guwen@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 09:37:24PM +0800, Wen Gu wrote:
>A hung_task is observed when removing SMC-R devices. Suppose that
>a link group has two active links(lnk_A, lnk_B) associated with two
>different SMC-R devices(dev_A, dev_B). When dev_A is removed, the
>link group will be removed from smc_lgr_list and added into
>lgr_linkdown_list. lnk_A will be cleared and smcibdev(A)->lnk_cnt
>will reach to zero. However, when dev_B is removed then, the link
>group can't be found in smc_lgr_list and lnk_B won't be cleared,
>making smcibdev->lnk_cnt never reaches zero, which causes a hung_task.
>
>This patch fixes this issue by restoring the implementation of
>smc_smcr_terminate_all() to what it was before commit 349d43127dac
>("net/smc: fix kernel panic caused by race of smc_sock"). The original
>implementation also satisfies the intention that make sure QP destroy
>earlier than CQ destroy because we will always wait for smcibdev->lnk_cnt
>reaches zero, which guarantees QP has been destroyed.

Good catch, thank you !

Update the comments of smc_smcr_terminate_all as well ?

>
>Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
>Signed-off-by: Wen Gu <guwen@linux.alibaba.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

>---
> net/smc/smc_core.c | 13 +------------
> 1 file changed, 1 insertion(+), 12 deletions(-)
>
>diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>index b19c0aa..1124594 100644
>--- a/net/smc/smc_core.c
>+++ b/net/smc/smc_core.c
>@@ -1533,7 +1533,6 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
> {
> 	struct smc_link_group *lgr, *lg;
> 	LIST_HEAD(lgr_free_list);
>-	LIST_HEAD(lgr_linkdown_list);
> 	int i;
> 
> 	spin_lock_bh(&smc_lgr_list.lock);
>@@ -1545,7 +1544,7 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
> 		list_for_each_entry_safe(lgr, lg, &smc_lgr_list.list, list) {
> 			for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
> 				if (lgr->lnk[i].smcibdev == smcibdev)
>-					list_move_tail(&lgr->list, &lgr_linkdown_list);
>+					smcr_link_down_cond_sched(&lgr->lnk[i]);
> 			}
> 		}
> 	}
>@@ -1557,16 +1556,6 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
> 		__smc_lgr_terminate(lgr, false);
> 	}
> 
>-	list_for_each_entry_safe(lgr, lg, &lgr_linkdown_list, list) {
>-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
>-			if (lgr->lnk[i].smcibdev == smcibdev) {
>-				mutex_lock(&lgr->llc_conf_mutex);
>-				smcr_link_down_cond(&lgr->lnk[i]);
>-				mutex_unlock(&lgr->llc_conf_mutex);
>-			}
>-		}
>-	}
>-
> 	if (smcibdev) {
> 		if (atomic_read(&smcibdev->lnk_cnt))
> 			wait_event(smcibdev->lnks_deleted,
>-- 
>1.8.3.1
