Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D95E4CA5E7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiCBN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbiCBN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:26:01 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6222DE7;
        Wed,  2 Mar 2022 05:25:17 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V631sQn_1646227514;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V631sQn_1646227514)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 21:25:15 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net v3 2/2] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server
Date:   Wed,  2 Mar 2022 21:25:12 +0800
Message-Id: <a495b3c6d6cb8002a7a0e73da9b83720b9819e3a.1646227183.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1646227183.git.alibuda@linux.alibaba.com>
References: <cover.1646227183.git.alibuda@linux.alibaba.com>
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

The problem of SMC_CLC_DECL_ERR_REGRMB on the server is very clear.
Based on the fact that whether a new SMC connection can be accepted or
not depends on not only the limit of conn nums, but also the available
entries of rtoken. Since the rtoken release is trigger by peer, while
the conn nums is decrease by local, tons of thing can happen in this
time difference.

This only thing that needs to be mentioned is that now all connection
creations are completely protected by smc_server_lgr_pending lock, it's
enough to check only the available entries in rtokens_used_mask.

Fixes: cd6851f30386 ("smc: remote memory buffers (RMBs)")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f8c9675..be7d704 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1864,7 +1864,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;
-- 
1.8.3.1

