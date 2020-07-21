Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03829228269
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgGUOkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgGUOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:40:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5AFC061794;
        Tue, 21 Jul 2020 07:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u6nwafrlz+b6UdlZYCqETk12fRffjhyamYNM/ceEc+s=; b=k4THOww0LUHvm8Enagu5lTaLvx
        l9JhkkX9hG158fRmX0pPkbVysZmaVcm8hNqmE+qog+taHTLq0zg4UvN9EkDLWca+HogSnp0M6cygt
        B50ElMDPhOZgNVS0UI5LyZ4cEQoVoZsS6KY5d6aRhb/UlB2cs5dcxPQrxdnpjWhXldphZj3qjJFR5
        N/BuMrqYdOUXDeS1Rs6CO6e+O6lnPbNA/YD2q+J34MM0U6FhAcxTCFyuNf2R5P5cnJgJ/KFcKwyCM
        HIPk+LtL1wgYRezNy0yslqKaHFDRPuWWSp8WOQMNntf3cMAoj50PfEJbfxy9avFQ/b/QpwK7WDuZ2
        caIgawaQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43020 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxtRj-0004RU-Jf; Tue, 21 Jul 2020 15:40:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxtRj-0003Tz-CG; Tue, 21 Jul 2020 15:40:43 +0100
In-Reply-To: <20200721143756.GT1605@shell.armlinux.org.uk>
References: <20200721143756.GT1605@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 3/3] phy: armada-38x: fix NETA lockup when repeatedly
 switching speeds
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxtRj-0003Tz-CG@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 15:40:43 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvneta hardware appears to lock up in various random ways when
repeatedly switching speeds between 1G and 2.5G, which involves
reprogramming the COMPHY.  It is not entirely clear why this happens,
but best guess is that reprogramming the COMPHY glitches mvneta clocks
causing the hardware to fail.  It seems that rebooting resolves the
failure, but not down/up cycling the interface alone.

Various other approaches have been tried, such as trying to cleanly
power down the COMPHY and then take it back through the power up
initialisation, but this does not seem to help.

It was finally noticed that u-boot's last step when configuring a
COMPHY for "SGMII" mode was to poke at a register described as
"GBE_CONFIGURATION_REG", which is undocumented in any external
documentation.  All that we have is the fact that u-boot sets a bit
corresponding to the "SGMII" lane at the end of COMPHY initialisation.

Experimentation shows that if we clear this bit prior to changing the
speed, and then set it afterwards, mvneta does not suffer this problem
on the SolidRun Clearfog when switching speeds between 1G and 2.5G.

This problem was found while script-testing phylink.

This fix also requires the corresponding change to DT to be effective.
See "ARM: dts: armada-38x: fix NETA lockup when repeatedly switching
speeds".

Fixes: 14dc100b4411 ("phy: armada38x: add common phy support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/phy/marvell/phy-armada38x-comphy.c | 45 ++++++++++++++++++----
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/marvell/phy-armada38x-comphy.c b/drivers/phy/marvell/phy-armada38x-comphy.c
index 6960dfd8ad8c..0fe408964334 100644
--- a/drivers/phy/marvell/phy-armada38x-comphy.c
+++ b/drivers/phy/marvell/phy-armada38x-comphy.c
@@ -41,6 +41,7 @@ struct a38x_comphy_lane {
 
 struct a38x_comphy {
 	void __iomem *base;
+	void __iomem *conf;
 	struct device *dev;
 	struct a38x_comphy_lane lane[MAX_A38X_COMPHY];
 };
@@ -54,6 +55,21 @@ static const u8 gbe_mux[MAX_A38X_COMPHY][MAX_A38X_PORTS] = {
 	{ 0, 0, 3 },
 };
 
+static void a38x_set_conf(struct a38x_comphy_lane *lane, bool enable)
+{
+	struct a38x_comphy *priv = lane->priv;
+	u32 conf;
+
+	if (priv->conf) {
+		conf = readl_relaxed(priv->conf);
+		if (enable)
+			conf |= BIT(lane->port);
+		else
+			conf &= ~BIT(lane->port);
+		writel(conf, priv->conf);
+	}
+}
+
 static void a38x_comphy_set_reg(struct a38x_comphy_lane *lane,
 				unsigned int offset, u32 mask, u32 value)
 {
@@ -97,6 +113,7 @@ static int a38x_comphy_set_mode(struct phy *phy, enum phy_mode mode, int sub)
 {
 	struct a38x_comphy_lane *lane = phy_get_drvdata(phy);
 	unsigned int gen;
+	int ret;
 
 	if (mode != PHY_MODE_ETHERNET)
 		return -EINVAL;
@@ -115,13 +132,20 @@ static int a38x_comphy_set_mode(struct phy *phy, enum phy_mode mode, int sub)
 		return -EINVAL;
 	}
 
+	a38x_set_conf(lane, false);
+
 	a38x_comphy_set_speed(lane, gen, gen);
 
-	return a38x_comphy_poll(lane, COMPHY_STAT1,
-				COMPHY_STAT1_PLL_RDY_TX |
-				COMPHY_STAT1_PLL_RDY_RX,
-				COMPHY_STAT1_PLL_RDY_TX |
-				COMPHY_STAT1_PLL_RDY_RX);
+	ret = a38x_comphy_poll(lane, COMPHY_STAT1,
+			       COMPHY_STAT1_PLL_RDY_TX |
+			       COMPHY_STAT1_PLL_RDY_RX,
+			       COMPHY_STAT1_PLL_RDY_TX |
+			       COMPHY_STAT1_PLL_RDY_RX);
+
+	if (ret == 0)
+		a38x_set_conf(lane, true);
+
+	return ret;
 }
 
 static const struct phy_ops a38x_comphy_ops = {
@@ -174,14 +198,21 @@ static int a38x_comphy_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
 	priv->dev = &pdev->dev;
 	priv->base = base;
 
+	/* Optional */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "conf");
+	if (res) {
+		priv->conf = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->conf))
+			return PTR_ERR(priv->conf);
+	}
+
 	for_each_available_child_of_node(pdev->dev.of_node, child) {
 		struct phy *phy;
 		int ret;
-- 
2.20.1

