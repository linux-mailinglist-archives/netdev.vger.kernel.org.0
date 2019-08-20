Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18E496324
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfHTOyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:54:07 -0400
Received: from vps.xff.cz ([195.181.215.36]:60092 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbfHTOxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312826; bh=fJp1/iHxqT8rIRrQhM5u30ZJqn3FLJCfRTqKNHdiDpk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OUSQL0xWoyyXiFXG3/LwHN+ZkRJ0/NRPLbNEZ28F4MzGzDOMyvlvwINEM5mFJYNBR
         be7A368YMVBuW/BTSfCfJpd3WPAJFNcr60QlNdWdrKPxhUsesiBpVmvMoqsy48u2/Q
         a46vrrjCQAzAMqZWEPxmeFnRIKmjGU0LoyfmSZ0s=
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
Subject: [PATCH 4/6] net: stmmac: sun8i: Rename PHY regulator variable to regulator_phy
Date:   Tue, 20 Aug 2019 16:53:41 +0200
Message-Id: <20190820145343.29108-5-megous@megous.com>
In-Reply-To: <20190820145343.29108-1-megous@megous.com>
References: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

We'll be adding further optional regulators, and this makes it clearer
what the regulator is for.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 3e951a11aec3..e7df30d3cab1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -57,19 +57,21 @@ struct emac_variant {
 };
 
 /* struct sunxi_priv_data - hold all sunxi private data
- * @tx_clk:	reference to MAC TX clock
- * @ephy_clk:	reference to the optional EPHY clock for the internal PHY
- * @regulator:	reference to the optional regulator
- * @rst_ephy:	reference to the optional EPHY reset for the internal PHY
- * @variant:	reference to the current board variant
- * @regmap:	regmap for using the syscon
- * @internal_phy_powered: Does the internal PHY is enabled
- * @mux_handle:	Internal pointer used by mdio-mux lib
+ * @tx_clk:			reference to MAC TX clock
+ * @ephy_clk:			reference to the optional EPHY clock for
+ *				the internal PHY
+ * @regulator_phy:		reference to the optional regulator
+ * @rst_ephy:			reference to the optional EPHY reset for
+ *				the internal PHY
+ * @variant:			reference to the current board variant
+ * @regmap:			regmap for using the syscon
+ * @internal_phy_powered:	Does the internal PHY is enabled
+ * @mux_handle:			Internal pointer used by mdio-mux lib
  */
 struct sunxi_priv_data {
 	struct clk *tx_clk;
 	struct clk *ephy_clk;
-	struct regulator *regulator;
+	struct regulator *regulator_phy;
 	struct reset_control *rst_ephy;
 	const struct emac_variant *variant;
 	struct regmap_field *regmap_field;
@@ -528,9 +530,9 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 	struct sunxi_priv_data *gmac = priv;
 	int ret;
 
-	ret = regulator_enable(gmac->regulator);
+	ret = regulator_enable(gmac->regulator_phy);
 	if (ret) {
-		dev_err(&pdev->dev, "Fail to enable regulator\n");
+		dev_err(&pdev->dev, "Fail to enable PHY regulator\n");
 		return ret;
 	}
 
@@ -990,7 +992,7 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 
 	clk_disable_unprepare(gmac->tx_clk);
 
-	regulator_disable(gmac->regulator);
+	regulator_disable(gmac->regulator_phy);
 }
 
 static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
@@ -1126,9 +1128,9 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	}
 
 	/* Optional regulator for PHY */
-	gmac->regulator = devm_regulator_get(dev, "phy");
-	if (IS_ERR(gmac->regulator)) {
-		ret = PTR_ERR(gmac->regulator);
+	gmac->regulator_phy = devm_regulator_get(dev, "phy");
+	if (IS_ERR(gmac->regulator_phy)) {
+		ret = PTR_ERR(gmac->regulator_phy);
 		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get PHY regulator (%d)\n", ret);
 		return ret;
-- 
2.22.1

