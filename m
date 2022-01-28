Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C709049FC49
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346083AbiA1O7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiA1O7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:59:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26059C061714;
        Fri, 28 Jan 2022 06:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D25BCB824FE;
        Fri, 28 Jan 2022 14:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E653EC340E0;
        Fri, 28 Jan 2022 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643381989;
        bh=/uP5vvPUBDipAzrUPDGSTlRiO2kQLT1St7WxjZjMoZk=;
        h=From:To:Cc:Subject:Date:From;
        b=KaCJ79tkFQvlEpR301IzypviUYVubfPBjlOsca0nvdWG1Xn7aOKyWYO8nu+VHoOxq
         z+7LbBCCoKKEoPiWkRzH7JvrtP/2RAr/8+tDGtKD1qjEs6ugWYyL2q8E5WvSMPRbuH
         nVgt0gWpzAeqcjncb3w8WOh4EPmSsiC6YChX/bcEZpHX1hbcNehVJSUj1yk35f0+eD
         BFBwIiUW7+cqgIzbMfoJTmuRom0tnBpATDnijlDpURSy40q8JWlFzHXqnBZaHN1Ngg
         dfzl4tqGb9+fIWYKA289jDwwy8eA16SESsXYAUPhRMFWd6yBIbaclE5ycpq1M00KvA
         EPczk6P2rUXkQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: dwmac-sun8i: make clk really gated during rpm suspended
Date:   Fri, 28 Jan 2022 22:52:13 +0800
Message-Id: <20220128145213.2454-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the dwmac-sun8i's stmmaceth clk isn't disabled even if the
the device has been runtime suspended. The reason is the driver gets
the "stmmaceth" clk as tx_clk and enabling it during probe. But
there's no other usage of tx_clk except preparing and enabling, so
we can remove tx_clk and its usage then rely on the common routine
stmmac_probe_config_dt() to prepare and enable the stmmaceth clk
during driver initialization, and benefit from the runtime pm feature
after probed.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 30 +++++++------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 09644ab0d87a..f86cc83003f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -16,6 +16,7 @@
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
 #include <linux/stmmac.h>
@@ -57,7 +58,6 @@ struct emac_variant {
 };
 
 /* struct sunxi_priv_data - hold all sunxi private data
- * @tx_clk:	reference to MAC TX clock
  * @ephy_clk:	reference to the optional EPHY clock for the internal PHY
  * @regulator:	reference to the optional regulator
  * @rst_ephy:	reference to the optional EPHY reset for the internal PHY
@@ -68,7 +68,6 @@ struct emac_variant {
  * @mux_handle:	Internal pointer used by mdio-mux lib
  */
 struct sunxi_priv_data {
-	struct clk *tx_clk;
 	struct clk *ephy_clk;
 	struct regulator *regulator;
 	struct reset_control *rst_ephy;
@@ -579,22 +578,14 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 		}
 	}
 
-	ret = clk_prepare_enable(gmac->tx_clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not enable AHB clock\n");
-		goto err_disable_regulator;
-	}
-
 	if (gmac->use_internal_phy) {
 		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
 		if (ret)
-			goto err_disable_clk;
+			goto err_disable_regulator;
 	}
 
 	return 0;
 
-err_disable_clk:
-	clk_disable_unprepare(gmac->tx_clk);
 err_disable_regulator:
 	if (gmac->regulator)
 		regulator_disable(gmac->regulator);
@@ -1043,8 +1034,6 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 	if (gmac->variant->soc_has_internal_phy)
 		sun8i_dwmac_unpower_internal_phy(gmac);
 
-	clk_disable_unprepare(gmac->tx_clk);
-
 	if (gmac->regulator)
 		regulator_disable(gmac->regulator);
 }
@@ -1167,12 +1156,6 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	gmac->tx_clk = devm_clk_get(dev, "stmmaceth");
-	if (IS_ERR(gmac->tx_clk)) {
-		dev_err(dev, "Could not get TX clock\n");
-		return PTR_ERR(gmac->tx_clk);
-	}
-
 	/* Optional regulator for PHY */
 	gmac->regulator = devm_regulator_get_optional(dev, "phy");
 	if (IS_ERR(gmac->regulator)) {
@@ -1254,6 +1237,12 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	ndev = dev_get_drvdata(&pdev->dev);
 	priv = netdev_priv(ndev);
 
+	/* the MAC is runtime suspended after stmmac_dvr_probe(), so we
+	 * need to ensure the MAC resume back before other operations such
+	 * as reset.
+	 */
+	pm_runtime_get_sync(&pdev->dev);
+
 	/* The mux must be registered after parent MDIO
 	 * so after stmmac_dvr_probe()
 	 */
@@ -1272,12 +1261,15 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 			goto dwmac_remove;
 	}
 
+	pm_runtime_put(&pdev->dev);
+
 	return 0;
 
 dwmac_mux:
 	reset_control_put(gmac->rst_ephy);
 	clk_put(gmac->ephy_clk);
 dwmac_remove:
+	pm_runtime_put_noidle(&pdev->dev);
 	stmmac_dvr_remove(&pdev->dev);
 dwmac_exit:
 	sun8i_dwmac_exit(pdev, gmac);
-- 
2.34.1

