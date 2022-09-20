Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8704C5BDD87
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiITGoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITGoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:44:20 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3982674;
        Mon, 19 Sep 2022 23:44:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VQI-knc_1663656189;
Received: from h68b04305.sqa.eu95.tbsite.net(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VQI-knc_1663656189)
          by smtp.aliyun-inc.com;
          Tue, 20 Sep 2022 14:44:16 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: Stop the CLC flow if no link to map buffers on
Date:   Tue, 20 Sep 2022 14:43:09 +0800
Message-Id: <1663656189-32090-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There might be a potential race between SMC-R buffer map and
link group termination.

smc_smcr_terminate_all()     | smc_connect_rdma()
--------------------------------------------------------------
                             | smc_conn_create()
for links in smcibdev        |
        schedule links down  |
                             | smc_buf_create()
                             |  \- smcr_buf_map_usable_links()
                             |      \- no usable links found,
                             |         (rmb->mr = NULL)
                             |
                             | smc_clc_send_confirm()
                             |  \- access conn->rmb_desc->mr[]->rkey
                             |     (panic)

During reboot and IB device module remove, all links will be set
down and no usable links remain in link groups. In such situation
smcr_buf_map_usable_links() should return an error and stop the
CLC flow accessing to uninitialized mr.

Fixes: b9247544c1bc ("net/smc: convert static link ID instances to support multiple links")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index ebf56cd..df89c2e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2239,7 +2239,7 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 				     struct smc_buf_desc *buf_desc, bool is_rmb)
 {
-	int i, rc = 0;
+	int i, rc = 0, cnt = 0;
 
 	/* protect against parallel link reconfiguration */
 	mutex_lock(&lgr->llc_conf_mutex);
@@ -2252,9 +2252,12 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 			rc = -ENOMEM;
 			goto out;
 		}
+		cnt++;
 	}
 out:
 	mutex_unlock(&lgr->llc_conf_mutex);
+	if (!rc && !cnt)
+		rc = -EINVAL;
 	return rc;
 }
 
-- 
1.8.3.1

