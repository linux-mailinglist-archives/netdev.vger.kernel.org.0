Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A588494FDD
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344879AbiATOLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:11:16 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42374 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344741AbiATOLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:11:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V2N7nuG_1642687871;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2N7nuG_1642687871)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 22:11:12 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next] net/smc: Use kvzalloc for allocating smc_link_group
Date:   Thu, 20 Jan 2022 22:09:30 +0800
Message-Id: <20220120140928.7137-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When analyzed memory usage of SMC, we found that the size of struct
smc_link_group is 16048 bytes, which is too big for a busy machine to
allocate contiguous memory. Using kvzalloc instead that falls back to
vmalloc if there has not enough contiguous memory.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8935ef4811b0..a5024b098540 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -828,7 +828,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 	}
 
-	lgr = kzalloc(sizeof(*lgr), GFP_KERNEL);
+	lgr = kvzalloc(sizeof(*lgr), GFP_KERNEL);
 	if (!lgr) {
 		rc = SMC_CLC_DECL_MEM;
 		goto ism_put_vlan;
@@ -914,7 +914,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 free_wq:
 	destroy_workqueue(lgr->tx_wq);
 free_lgr:
-	kfree(lgr);
+	kvfree(lgr);
 ism_put_vlan:
 	if (ini->is_smcd && ini->vlan_id)
 		smc_ism_put_vlan(ini->ism_dev[ini->ism_selected], ini->vlan_id);
@@ -1317,7 +1317,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
-	kfree(lgr);
+	kvfree(lgr);
 }
 
 static void smc_sk_wake_ups(struct smc_sock *smc)
-- 
2.32.0.3.g01195cf9f

