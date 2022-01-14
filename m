Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211BD48EAE2
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiANNhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:37:54 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:49642 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbiANNhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 08:37:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1p8aYo_1642167444;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1p8aYo_1642167444)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 21:37:52 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Fix hung_task when removing SMC-R devices
Date:   Fri, 14 Jan 2022 21:37:24 +0800
Message-Id: <1642167444-107744-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A hung_task is observed when removing SMC-R devices. Suppose that
a link group has two active links(lnk_A, lnk_B) associated with two
different SMC-R devices(dev_A, dev_B). When dev_A is removed, the
link group will be removed from smc_lgr_list and added into
lgr_linkdown_list. lnk_A will be cleared and smcibdev(A)->lnk_cnt
will reach to zero. However, when dev_B is removed then, the link
group can't be found in smc_lgr_list and lnk_B won't be cleared,
making smcibdev->lnk_cnt never reaches zero, which causes a hung_task.

This patch fixes this issue by restoring the implementation of
smc_smcr_terminate_all() to what it was before commit 349d43127dac
("net/smc: fix kernel panic caused by race of smc_sock"). The original
implementation also satisfies the intention that make sure QP destroy
earlier than CQ destroy because we will always wait for smcibdev->lnk_cnt
reaches zero, which guarantees QP has been destroyed.

Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b19c0aa..1124594 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1533,7 +1533,6 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 {
 	struct smc_link_group *lgr, *lg;
 	LIST_HEAD(lgr_free_list);
-	LIST_HEAD(lgr_linkdown_list);
 	int i;
 
 	spin_lock_bh(&smc_lgr_list.lock);
@@ -1545,7 +1544,7 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 		list_for_each_entry_safe(lgr, lg, &smc_lgr_list.list, list) {
 			for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 				if (lgr->lnk[i].smcibdev == smcibdev)
-					list_move_tail(&lgr->list, &lgr_linkdown_list);
+					smcr_link_down_cond_sched(&lgr->lnk[i]);
 			}
 		}
 	}
@@ -1557,16 +1556,6 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 		__smc_lgr_terminate(lgr, false);
 	}
 
-	list_for_each_entry_safe(lgr, lg, &lgr_linkdown_list, list) {
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].smcibdev == smcibdev) {
-				mutex_lock(&lgr->llc_conf_mutex);
-				smcr_link_down_cond(&lgr->lnk[i]);
-				mutex_unlock(&lgr->llc_conf_mutex);
-			}
-		}
-	}
-
 	if (smcibdev) {
 		if (atomic_read(&smcibdev->lnk_cnt))
 			wait_event(smcibdev->lnks_deleted,
-- 
1.8.3.1

