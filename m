Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC314F4617
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386726AbiDEOZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354841AbiDENH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:07:28 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DA724F14;
        Tue,  5 Apr 2022 05:09:59 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id ADE092224D;
        Tue,  5 Apr 2022 14:09:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649160597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WaKtmsAct4eFrA+KGGxilxHVP2Bwhzu8dzCAWhFx8o=;
        b=oYg7yuaMfIQM3IfqfMlSOS+FFRinbYbWLjZ2z7mOaGm5ij6LMGR5XRgD/0FcrunnyZil/+
        hjc/DVsyPEGkck2J2e1qhmXosWa43vLuvFJLU+R07V1WCoM0g/3pQCgK+anUImsp3yY1KM
        nlimXoK2aKyugaERn+/nRB9Tf9iP2Mw=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 3/3] net: phy: mscc-miim: add support to set MDIO bus frequency
Date:   Tue,  5 Apr 2022 14:09:51 +0200
Message-Id: <20220405120951.4044875-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220405120951.4044875-1-michael@walle.cc>
References: <20220405120951.4044875-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now, the MDIO bus will have the hardware default bus frequency.
Read the desired frequency of the bus from the device tree and configure
it.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/mdio-mscc-miim.c | 58 +++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index c9efcfa2a1ce..7fd979f68dc0 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
@@ -30,6 +31,8 @@
 #define		MSCC_MIIM_CMD_VLD		BIT(31)
 #define MSCC_MIIM_REG_DATA		0xC
 #define		MSCC_MIIM_DATA_ERROR		(BIT(16) | BIT(17))
+#define MSCC_MIIM_REG_CFG		0x10
+#define		MSCC_MIIM_CFG_PRESCALE_MASK	GENMASK(7, 0)
 
 #define MSCC_PHY_REG_PHY_CFG	0x0
 #define		PHY_CFG_PHY_ENA		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
@@ -50,6 +53,8 @@ struct mscc_miim_dev {
 	int mii_status_offset;
 	struct regmap *phy_regs;
 	const struct mscc_miim_info *info;
+	struct clk *clk;
+	u32 bus_freq;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
@@ -242,9 +247,32 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 }
 EXPORT_SYMBOL(mscc_miim_setup);
 
+static int mscc_miim_clk_set(struct mii_bus *bus)
+{
+	struct mscc_miim_dev *miim = bus->priv;
+	unsigned long rate;
+	u32 div;
+
+	/* Keep the current settings */
+	if (!miim->bus_freq)
+		return 0;
+
+	rate = clk_get_rate(miim->clk);
+
+	div = DIV_ROUND_UP(rate, 2 * miim->bus_freq) - 1;
+	if (div == 0 || div & ~MSCC_MIIM_CFG_PRESCALE_MASK) {
+		dev_err(&bus->dev, "Incorrect MDIO clock frequency\n");
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(miim->regs, MSCC_MIIM_REG_CFG,
+				  MSCC_MIIM_CFG_PRESCALE_MASK, div);
+}
+
 static int mscc_miim_probe(struct platform_device *pdev)
 {
 	struct regmap *mii_regmap, *phy_regmap = NULL;
+	struct device_node *np = pdev->dev.of_node;
 	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
 	struct resource *res;
@@ -295,21 +323,47 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	if (!miim->info)
 		return -EINVAL;
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	miim->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(miim->clk))
+		return PTR_ERR(miim->clk);
+
+	of_property_read_u32(np, "clock-frequency", &miim->bus_freq);
+
+	if (miim->bus_freq && !miim->clk) {
+		dev_err(&pdev->dev,
+			"cannot use clock-frequency without a clock\n");
+		return -EINVAL;
+	}
+
+	ret = clk_prepare_enable(miim->clk);
+	if (ret)
+		return ret;
+
+	ret = mscc_miim_clk_set(bus);
+	if (ret)
+		goto out_disable_clk;
+
+	ret = of_mdiobus_register(bus, np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
-		return ret;
+		goto out_disable_clk;
 	}
 
 	platform_set_drvdata(pdev, bus);
 
 	return 0;
+
+out_disable_clk:
+	clk_disable_unprepare(miim->clk);
+	return ret;
 }
 
 static int mscc_miim_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mscc_miim_dev *miim = bus->priv;
 
+	clk_disable_unprepare(miim->clk);
 	mdiobus_unregister(bus);
 
 	return 0;
-- 
2.30.2

