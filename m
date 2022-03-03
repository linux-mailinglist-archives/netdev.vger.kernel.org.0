Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F034CB9EC
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiCCJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiCCJPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:15:35 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57CF119855;
        Thu,  3 Mar 2022 01:14:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V67Be.m_1646298882;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V67Be.m_1646298882)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 17:14:47 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: ethernet: sun: Remove redundant code
Date:   Thu,  3 Mar 2022 17:14:40 +0800
Message-Id: <20220303091440.71416-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because CAS_FLAG_REG_PLUS is assigned a value of 1, it never enters
these for loops.

Clean up the following smatch warning:

drivers/net/ethernet/sun/cassini.c:3513 cas_start_dma() warn: we never
enter this loop.

drivers/net/ethernet/sun/cassini.c:1239 cas_init_rx_dma() warn: we never
enter this loop.

drivers/net/ethernet/sun/cassini.c:1247 cas_init_rx_dma() warn: we never
enter this loop.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/sun/cassini.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 947a76a788c7..153edc5eadad 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1235,19 +1235,6 @@ static void cas_init_rx_dma(struct cas *cp)
 	 */
 	readl(cp->regs + REG_INTR_STATUS_ALIAS);
 	writel(INTR_RX_DONE | INTR_RX_BUF_UNAVAIL, cp->regs + REG_ALIAS_CLEAR);
-	if (cp->cas_flags & CAS_FLAG_REG_PLUS) {
-		for (i = 1; i < N_RX_COMP_RINGS; i++)
-			readl(cp->regs + REG_PLUS_INTRN_STATUS_ALIAS(i));
-
-		/* 2 is different from 3 and 4 */
-		if (N_RX_COMP_RINGS > 1)
-			writel(INTR_RX_DONE_ALT | INTR_RX_BUF_UNAVAIL_1,
-			       cp->regs + REG_PLUS_ALIASN_CLEAR(1));
-
-		for (i = 2; i < N_RX_COMP_RINGS; i++)
-			writel(INTR_RX_DONE_ALT,
-			       cp->regs + REG_PLUS_ALIASN_CLEAR(i));
-	}
 
 	/* set up pause thresholds */
 	val  = CAS_BASE(RX_PAUSE_THRESH_OFF,
@@ -3509,9 +3496,6 @@ static inline void cas_start_dma(struct cas *cp)
 		if (N_RX_DESC_RINGS > 1)
 			writel(RX_DESC_RINGN_SIZE(1) - 4,
 			       cp->regs + REG_PLUS_RX_KICK1);
-
-		for (i = 1; i < N_RX_COMP_RINGS; i++)
-			writel(0, cp->regs + REG_PLUS_RX_COMPN_TAIL(i));
 	}
 }
 
-- 
2.20.1.7.g153144c

