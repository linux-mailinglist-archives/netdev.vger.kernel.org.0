Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2235F6394E1
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKZJEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKZJD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:03:56 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7DB2A42C;
        Sat, 26 Nov 2022 01:03:54 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VViBjTo_1669453432;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VViBjTo_1669453432)
          by smtp.aliyun-inc.com;
          Sat, 26 Nov 2022 17:03:52 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v6 6/7] net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
Date:   Sat, 26 Nov 2022 17:03:41 +0800
Message-Id: <1669453422-38152-7-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669453422-38152-1-git-send-email-alibuda@linux.alibaba.com>
References: <1669453422-38152-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
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
index c4253b5..0af7b2c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -513,11 +513,26 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
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
@@ -529,7 +544,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 		if (rc)
 			goto out;
 	}
-
+fast_path:
 	/* exchange confirm_rkey msg with peer */
 	rc = smc_llc_do_confirm_rkey(link, rmb_desc);
 	if (rc) {
@@ -538,7 +553,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
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

