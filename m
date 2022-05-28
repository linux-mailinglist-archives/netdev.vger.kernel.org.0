Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5B1536B54
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 08:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiE1GzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 02:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiE1GzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 02:55:16 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E158BBF;
        Fri, 27 May 2022 23:55:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VEaTnjx_1653720909;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VEaTnjx_1653720909)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 May 2022 14:55:10 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
Date:   Sat, 28 May 2022 14:54:57 +0800
Message-Id: <20220528065457.93676-1-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
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

"struct smc_cdc_tx_pend **" can not directly convert
to "struct smc_wr_tx_pend_priv *".

Fixes: 2bced6aefa3d ("net/smc: put slot when connection is killed")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/smc_cdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 5c731f27996e..53f63bfbaf5f 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -82,7 +82,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 		/* abnormal termination */
 		if (!rc)
 			smc_wr_tx_put_slot(link,
-					   (struct smc_wr_tx_pend_priv *)pend);
+					   (struct smc_wr_tx_pend_priv *)(*pend));
 		rc = -EPIPE;
 	}
 	return rc;
-- 
2.24.3 (Apple Git-128)

