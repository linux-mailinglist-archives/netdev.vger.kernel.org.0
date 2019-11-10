Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07EFF6500
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfKJDD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbfKJCrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:47:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C7E5215EA;
        Sun, 10 Nov 2019 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354020;
        bh=S8BLw9qnAgSSUKEXrYw9zZJE/vcu51H7519p3nX+zS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6Iis/LvVf8ZEh+MmlvJO675XLpIX84xRG9Ca6+uAqEF9bg0bHSmxvsFFH3AnZB4Q
         7xKQckAIon93WpaGIQQwsY2T7flzRmsAfncf65cSOozgAkushw7Syjt2xrcKmeHtB0
         yYIxWWqH/IDglnLo7p1Au2Ui/aGe0t0YR6bp1vFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 043/109] net: phy: mdio-bcm-unimac: Allow configuring MDIO clock divider
Date:   Sat,  9 Nov 2019 21:44:35 -0500
Message-Id: <20191110024541.31567-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b78ac6ecd1b6b46f8767cbafa95a7b0b51b87ad8 ]

Allow the configuration of the MDIO clock divider when the Device Tree
contains 'clock-frequency' property (similar to I2C and SPI buses).
Because the hardware may have lost its state during suspend/resume,
re-apply the MDIO clock divider upon resumption.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/net/brcm,unimac-mdio.txt         |  3 +
 drivers/net/phy/mdio-bcm-unimac.c             | 83 ++++++++++++++++++-
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
index 4648948f7c3b8..e15589f477876 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
@@ -19,6 +19,9 @@ Optional properties:
 - interrupt-names: must be "mdio_done_error" when there is a share interrupt fed
   to this hardware block, or must be "mdio_done" for the first interrupt and
   "mdio_error" for the second when there are separate interrupts
+- clocks: A reference to the clock supplying the MDIO bus controller
+- clock-frequency: the MDIO bus clock that must be output by the MDIO bus
+  hardware, if absent, the default hardware values are used
 
 Child nodes of this MDIO bus controller node are standard Ethernet PHY device
 nodes as described in Documentation/devicetree/bindings/net/phy.txt
diff --git a/drivers/net/phy/mdio-bcm-unimac.c b/drivers/net/phy/mdio-bcm-unimac.c
index 08e0647b85e23..f9d98a6e67bc4 100644
--- a/drivers/net/phy/mdio-bcm-unimac.c
+++ b/drivers/net/phy/mdio-bcm-unimac.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -45,6 +46,8 @@ struct unimac_mdio_priv {
 	void __iomem		*base;
 	int (*wait_func)	(void *wait_func_data);
 	void			*wait_func_data;
+	struct clk		*clk;
+	u32			clk_freq;
 };
 
 static inline u32 unimac_mdio_readl(struct unimac_mdio_priv *priv, u32 offset)
@@ -189,6 +192,35 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
+{
+	unsigned long rate;
+	u32 reg, div;
+
+	/* Keep the hardware default values */
+	if (!priv->clk_freq)
+		return;
+
+	if (!priv->clk)
+		rate = 250000000;
+	else
+		rate = clk_get_rate(priv->clk);
+
+	div = (rate / (2 * priv->clk_freq)) - 1;
+	if (div & ~MDIO_CLK_DIV_MASK) {
+		pr_warn("Incorrect MDIO clock frequency, ignoring\n");
+		return;
+	}
+
+	/* The MDIO clock is the reference clock (typicaly 250Mhz) divided by
+	 * 2 x (MDIO_CLK_DIV + 1)
+	 */
+	reg = unimac_mdio_readl(priv, MDIO_CFG);
+	reg &= ~(MDIO_CLK_DIV_MASK << MDIO_CLK_DIV_SHIFT);
+	reg |= div << MDIO_CLK_DIV_SHIFT;
+	unimac_mdio_writel(priv, reg, MDIO_CFG);
+}
+
 static int unimac_mdio_probe(struct platform_device *pdev)
 {
 	struct unimac_mdio_pdata *pdata = pdev->dev.platform_data;
@@ -215,9 +247,26 @@ static int unimac_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
+		return PTR_ERR(priv->clk);
+	else
+		priv->clk = NULL;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	if (of_property_read_u32(np, "clock-frequency", &priv->clk_freq))
+		priv->clk_freq = 0;
+
+	unimac_mdio_clk_set(priv);
+
 	priv->mii_bus = mdiobus_alloc();
-	if (!priv->mii_bus)
-		return -ENOMEM;
+	if (!priv->mii_bus) {
+		ret = -ENOMEM;
+		goto out_clk_disable;
+	}
 
 	bus = priv->mii_bus;
 	bus->priv = priv;
@@ -251,6 +300,8 @@ static int unimac_mdio_probe(struct platform_device *pdev)
 
 out_mdio_free:
 	mdiobus_free(bus);
+out_clk_disable:
+	clk_disable_unprepare(priv->clk);
 	return ret;
 }
 
@@ -260,10 +311,37 @@ static int unimac_mdio_remove(struct platform_device *pdev)
 
 	mdiobus_unregister(priv->mii_bus);
 	mdiobus_free(priv->mii_bus);
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static int unimac_mdio_suspend(struct device *d)
+{
+	struct unimac_mdio_priv *priv = dev_get_drvdata(d);
+
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static int unimac_mdio_resume(struct device *d)
+{
+	struct unimac_mdio_priv *priv = dev_get_drvdata(d);
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	unimac_mdio_clk_set(priv);
 
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
+			 unimac_mdio_suspend, unimac_mdio_resume);
+
 static const struct of_device_id unimac_mdio_ids[] = {
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
@@ -279,6 +357,7 @@ static struct platform_driver unimac_mdio_driver = {
 	.driver = {
 		.name = UNIMAC_MDIO_DRV_NAME,
 		.of_match_table = unimac_mdio_ids,
+		.pm = &unimac_mdio_pm_ops,
 	},
 	.probe	= unimac_mdio_probe,
 	.remove	= unimac_mdio_remove,
-- 
2.20.1

