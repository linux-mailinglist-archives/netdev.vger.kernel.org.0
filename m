Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD974C3EAC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiBYHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiBYHEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:04:00 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDC81AA047;
        Thu, 24 Feb 2022 23:03:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5SDy3-_1645772605;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V5SDy3-_1645772605)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Feb 2022 15:03:26 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net] net/smc: Fix cleanup when register ULP fails
Date:   Fri, 25 Feb 2022 14:56:57 +0800
Message-Id: <20220225065656.60828-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch calls smc_ib_unregister_client() when tcp_register_ulp()
fails, and make sure to clean it up.

Fixes: d7cd421da9da ("net/smc: Introduce TCP ULP support")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 30acc31b2c45..d1a1343623f6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3270,12 +3270,14 @@ static int __init smc_init(void)
 	rc = tcp_register_ulp(&smc_ulp_ops);
 	if (rc) {
 		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_sock;
+		goto out_ib;
 	}
 
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
+out_ib:
+	smc_ib_unregister_client();
 out_sock:
 	sock_unregister(PF_SMC);
 out_proto6:
-- 
2.32.0.3.g01195cf9f

