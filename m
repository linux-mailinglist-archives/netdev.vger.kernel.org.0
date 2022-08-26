Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8805A250F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbiHZJwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbiHZJwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:52:05 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3A2D87DA;
        Fri, 26 Aug 2022 02:52:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNIZJ1Y_1661507517;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNIZJ1Y_1661507517)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 17:51:58 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2 07/10] net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
Date:   Fri, 26 Aug 2022 17:51:34 +0800
Message-Id: <42ee6c7df536391c6b781b16f6df7e8ecfc1fceb.1661407821.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1661407821.git.alibuda@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Unlike smc_buf_create() and smcr_buf_unuse(), smcr_lgr_reg_rmbs() is
exclusive when assigned rmb_desc was not registered, although it can be
executed in parallel when assigned rmb_desc was registered already
and only performs read semtamics on it. Hence, we can not simply replace
it with read semaphore.

The idea here is that if the assigned rmb_desc was registered already,
use read semaphore to protect the critical section, once the assigned
rmb_desc was not registered, keep using keep write semaphore still
to keep its exclusivity.

Thanks to the reusable features of rmb_desc, which allows us to execute
in parallel in most cases.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 04d79d1..e865f5e 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -515,11 +515,26 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 			     struct smc_buf_desc *rmb_desc)
 {
 	struct smc_link_group *lgr = link->lgr;
+	bool do_slow = false;
 	int i, rc = 0;
 
 	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
 	if (rc)
 		return rc;
+
+	down_read(&lgr->llc_conf_mutex);
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (!smc_link_active(&lgr->lnk[i]))
+			continue;
+		if (!rmb_desc->is_reg_mr[link->link_idx]) {
+			up_read(&lgr->llc_conf_mutex);
+			goto slow_path;
+		}
+	}
+	/* mr register already */
+	goto fast_path;
+slow_path:
+	do_slow = true;
 	/* protect against parallel smc_llc_cli_rkey_exchange() and
 	 * parallel smcr_link_reg_buf()
 	 */
@@ -531,7 +546,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 		if (rc)
 			goto out;
 	}
-
+fast_path:
 	/* exchange confirm_rkey msg with peer */
 	rc = smc_llc_do_confirm_rkey(link, rmb_desc);
 	if (rc) {
@@ -540,7 +555,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	}
 	rmb_desc->is_conf_rkey = true;
 out:
-	up_write(&lgr->llc_conf_mutex);
+	do_slow ? up_write(&lgr->llc_conf_mutex) : up_read(&lgr->llc_conf_mutex);
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
-- 
1.8.3.1

