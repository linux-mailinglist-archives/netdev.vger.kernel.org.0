Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A746958F1D6
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiHJRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiHJRsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:48:01 -0400
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786718C01B;
        Wed, 10 Aug 2022 10:47:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VLvpTf-_1660153667;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VLvpTf-_1660153667)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 01:47:47 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 06/10] net/smc: use read semaphores to reduce unnecessary blocking in smc_buf_create() & smcr_buf_unuse()
Date:   Thu, 11 Aug 2022 01:47:37 +0800
Message-Id: <b7f5dfd30ed2e0d1279a91b99753bed64593d15b.1660152975.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1660152975.git.alibuda@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Following is part of Off-CPU graph during frequent SMC-R short-lived
processing:

process_one_work				(51.19%)
smc_close_passive_work			(28.36%)
	smcr_buf_unuse				(28.34%)
	rwsem_down_write_slowpath		(28.22%)

smc_listen_work				(22.83%)
	smc_clc_wait_msg			(1.84%)
	smc_buf_create				(20.45%)
		smcr_buf_map_usable_links
		rwsem_down_write_slowpath	(20.43%)
	smcr_lgr_reg_rmbs			(0.53%)
		rwsem_down_write_slowpath	(0.43%)
		smc_llc_do_confirm_rkey		(0.08%)

We can clearly see that during the connection establishment time,
waiting time of connections is not on IO, but on llc_conf_mutex.

What is more important, the core critical area (smcr_buf_unuse() &
smc_buf_create()) only perfroms read semantics on links, we can
easily replace it with read semaphore.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fc8deec..113804d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1388,10 +1388,10 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 		rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
 		if (!rc) {
 			/* protect against smc_llc_cli_rkey_exchange() */
-			down_write(&lgr->llc_conf_mutex);
+			down_read(&lgr->llc_conf_mutex);
 			smc_llc_do_delete_rkey(lgr, buf_desc);
 			buf_desc->is_conf_rkey = false;
-			up_write(&lgr->llc_conf_mutex);
+			up_read(&lgr->llc_conf_mutex);
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 		}
 	}
@@ -2581,7 +2581,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 	int i, rc = 0;
 
 	/* protect against parallel link reconfiguration */
-	down_write(&lgr->llc_conf_mutex);
+	down_read(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
@@ -2593,7 +2593,7 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 		}
 	}
 out:
-	up_write(&lgr->llc_conf_mutex);
+	up_read(&lgr->llc_conf_mutex);
 	return rc;
 }
 
-- 
1.8.3.1

