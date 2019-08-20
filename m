Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0196326
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfHTOxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:53:48 -0400
Received: from vps.xff.cz ([195.181.215.36]:60066 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbfHTOxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312826; bh=BmUD9BF7ZWHwfIwmCa4uNboL8E51kehruNiRWEgChOs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=YlHw2Dihm2NXzNp1zXkFKZN/lDdmrVAGr6ZDu+rY6O6dYeqmdgN0A83O/0NDFzmTa
         MwI3Lq5KMIkfmJzFuQPpfM1Q/zoE9oTxK8lsvn+/6iD+bOjPtAe8y5kVFdMvOwXQqw
         +2gulGYP98IVdqI8xiM7wtztu84yRSq4lyKyiv4s=
From:   megous@megous.com
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 3/6] net: stmmac: sun8i: Use devm_regulator_get for PHY regulator
Date:   Tue, 20 Aug 2019 16:53:40 +0200
Message-Id: <20190820145343.29108-4-megous@megous.com>
In-Reply-To: <20190820145343.29108-1-megous@megous.com>
References: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Use devm_regulator_get instead of devm_regulator_get_optional and rely
on dummy supply. This avoids NULL checks before regulator_enable/disable
calls.

This path also improves error reporting, because we now report both
use of dummy supply and error during registration with more detail,
instead of generic info level message "No regulator found" that
was reported previously on errors and lack of regulator property in DT.

Finally, we'll be adding further optional regulators, and the overall
code will be simpler.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 23 ++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4083019c547a..3e951a11aec3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -528,12 +528,10 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 	struct sunxi_priv_data *gmac = priv;
 	int ret;
 
-	if (gmac->regulator) {
-		ret = regulator_enable(gmac->regulator);
-		if (ret) {
-			dev_err(&pdev->dev, "Fail to enable regulator\n");
-			return ret;
-		}
+	ret = regulator_enable(gmac->regulator);
+	if (ret) {
+		dev_err(&pdev->dev, "Fail to enable regulator\n");
+		return ret;
 	}
 
 	ret = clk_prepare_enable(gmac->tx_clk);
@@ -992,8 +990,7 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 
 	clk_disable_unprepare(gmac->tx_clk);
 
-	if (gmac->regulator)
-		regulator_disable(gmac->regulator);
+	regulator_disable(gmac->regulator);
 }
 
 static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
@@ -1129,12 +1126,12 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	}
 
 	/* Optional regulator for PHY */
-	gmac->regulator = devm_regulator_get_optional(dev, "phy");
+	gmac->regulator = devm_regulator_get(dev, "phy");
 	if (IS_ERR(gmac->regulator)) {
-		if (PTR_ERR(gmac->regulator) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_info(dev, "No regulator found\n");
-		gmac->regulator = NULL;
+		ret = PTR_ERR(gmac->regulator);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get PHY regulator (%d)\n", ret);
+		return ret;
 	}
 
 	/* The "GMAC clock control" register might be located in the
-- 
2.22.1

