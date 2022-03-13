Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D99B4D71E4
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 01:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiCMA0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 19:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiCMA0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 19:26:50 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88E7108760;
        Sat, 12 Mar 2022 16:25:43 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3171C223F0;
        Sun, 13 Mar 2022 01:25:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647131142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ufBbvQAexSriWvMXZv4flnbt/7xBdIcOYOogujbLjik=;
        b=msAWlnRHkz2/v1bAictHgoMiJx1qLqOw3siiyM77UsvrZh//e/MigV+f3kb/VS+VBdFGEC
        oq0d9qlz1qqCWpZprXQsgGZqdkBGbzfzoWsZhuUbHcd3RHxfuY/p4654IiJljGfA8A2Vur
        TKzCU3xoZ33wJSHsHCsMeGTQ68KKrgo=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 3/3] net: mdio: mscc-miim: add lan966x internal phy reset support
Date:   Sun, 13 Mar 2022 01:25:36 +0100
Message-Id: <20220313002536.13068-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220313002536.13068-1-michael@walle.cc>
References: <20220313002536.13068-1-michael@walle.cc>
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

The LAN966x has two internal PHYs which are in reset by default. The
driver already supported the internal PHYs of the SparX-5. Now add
support for the LAN966x, too. Add a new compatible to distinguish them.

The LAN966x has additional control bits in this register, thus convert
the regmap_write() to regmap_update_bits() to leave the remaining bits
untouched. This doesn't change anything for the SparX-5 SoC, because
there, the register consists only of reset bits.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/mdio/mdio-mscc-miim.c | 59 +++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 7773d5019e66..d082a13d9af3 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -15,6 +15,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
@@ -36,11 +37,19 @@
 #define		PHY_CFG_PHY_RESET	(BIT(5) | BIT(6) | BIT(7) | BIT(8))
 #define MSCC_PHY_REG_PHY_STATUS	0x4
 
+#define LAN966X_CUPHY_COMMON_CFG	0x0
+#define		CUPHY_COMMON_CFG_RESET_N	BIT(0)
+
+struct mscc_miim_info {
+	unsigned int phy_reset_offset;
+	unsigned int phy_reset_mask;
+};
+
 struct mscc_miim_dev {
 	struct regmap *regs;
 	int mii_status_offset;
 	struct regmap *phy_regs;
-	int phy_reset_offset;
+	const struct mscc_miim_info *info;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
@@ -157,27 +166,29 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
-	int offset = miim->phy_reset_offset;
-	int mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
-		   PHY_CFG_PHY_RESET;
+	unsigned int offset, mask;
 	int ret;
 
-	if (miim->phy_regs) {
-		ret = regmap_write(miim->phy_regs, offset, 0);
-		if (ret < 0) {
-			WARN_ONCE(1, "mscc reset set error %d\n", ret);
-			return ret;
-		}
+	if (!miim->phy_regs || !miim->info)
+		return 0;
 
-		ret = regmap_write(miim->phy_regs, offset, mask);
-		if (ret < 0) {
-			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
-			return ret;
-		}
+	offset = miim->info->phy_reset_offset;
+	mask = miim->info->phy_reset_mask;
+
+	ret = regmap_update_bits(miim->phy_regs, offset, mask, 0);
+	if (ret < 0) {
+		WARN_ONCE(1, "mscc reset set error %d\n", ret);
+		return ret;
+	}
 
-		mdelay(500);
+	ret = regmap_update_bits(miim->phy_regs, offset, mask, mask);
+	if (ret < 0) {
+		WARN_ONCE(1, "mscc reset clear error %d\n", ret);
+		return ret;
 	}
 
+	mdelay(500);
+
 	return 0;
 }
 
@@ -272,7 +283,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	miim = bus->priv;
 	miim->phy_regs = phy_regmap;
-	miim->phy_reset_offset = MSCC_PHY_REG_PHY_CFG;
+	miim->info = device_get_match_data(&pdev->dev);
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
@@ -294,8 +305,20 @@ static int mscc_miim_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct mscc_miim_info mscc_ocelot_miim_info = {
+	.phy_reset_offset = MSCC_PHY_REG_PHY_CFG,
+	.phy_reset_mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
+			  PHY_CFG_PHY_RESET,
+};
+
+static const struct mscc_miim_info mscc_lan966x_miim_info = {
+	.phy_reset_offset = LAN966X_CUPHY_COMMON_CFG,
+	.phy_reset_mask = CUPHY_COMMON_CFG_RESET_N,
+};
+
 static const struct of_device_id mscc_miim_match[] = {
-	{ .compatible = "mscc,ocelot-miim" },
+	{ .compatible = "mscc,ocelot-miim", .data = &mscc_ocelot_miim_info },
+	{ .compatible = "mscc,lan966x-miim", .data = &mscc_lan966x_miim_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mscc_miim_match);
-- 
2.30.2

