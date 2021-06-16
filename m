Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84353A8EE0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhFPClX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:41:23 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:57600 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhFPClW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:41:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UcZRreS_1623811153;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UcZRreS_1623811153)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Jun 2021 10:39:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] net: stmmac: Fix an error code in dwmac-ingenic.c
Date:   Wed, 16 Jun 2021 10:39:08 +0800
Message-Id: <1623811148-11064-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IS_ERR(mac->regmap) returns true, the value of ret is 0.
So, we set ret to -ENODEV to indicate this error.

Clean up smatch warning:
drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c:266
ingenic_mac_probe() warn: missing error code 'ret'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 60984c1..f3950e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -263,6 +263,7 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 	mac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "mode-reg");
 	if (IS_ERR(mac->regmap)) {
 		dev_err(&pdev->dev, "%s: Failed to get syscon regmap\n", __func__);
+		ret = -ENODEV;
 		goto err_remove_config_dt;
 	}
 
-- 
1.8.3.1

