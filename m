Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A7E62EA7F
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbiKRAoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbiKRAoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:44:14 -0500
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C09B62078;
        Thu, 17 Nov 2022 16:44:13 -0800 (PST)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1ovp2u-000nxs-JY; Fri, 18 Nov 2022 00:15:52 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 2/3] net: phy: dp83867: add LED mode configuration via dt
Date:   Thu, 17 Nov 2022 16:15:47 -0800
Message-Id: <20221118001548.635752-3-tharvey@gateworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118001548.635752-1-tharvey@gateworks.com>
References: <20221118001548.635752-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configuration of LED modes per device-tree property ti,led-modes.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/phy/dp83867.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..008941a8d6aa 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,7 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR1		0x18
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -150,6 +151,10 @@
 /* FLD_THR_CFG */
 #define DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK	0x7
 
+/* LED Configuration 1 bits */
+#define DP83867_LED_MODE_SHIFT			4
+#define DP83867_LED_MODE_MASK			0xf
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -167,6 +172,7 @@ struct dp83867_private {
 	bool set_clk_output;
 	u32 clk_output_sel;
 	bool sgmii_ref_clk_en;
+	int led_modes[4];
 };
 
 static int dp83867_ack_interrupt(struct phy_device *phydev)
@@ -573,7 +579,7 @@ static int dp83867_of_init(struct phy_device *phydev)
 	struct dp83867_private *dp83867 = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
-	int ret;
+	int ret, led;
 
 	if (!of_node)
 		return -ENODEV;
@@ -658,6 +664,13 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	if (of_property_read_u32_array(of_node, "ti,led-modes",
+				       dp83867->led_modes,
+				       ARRAY_SIZE(dp83867->led_modes))) {
+		for (led = 0; led < ARRAY_SIZE(dp83867->led_modes); led++)
+			dp83867->led_modes[led] = -EINVAL;
+	}
+
 	return 0;
 }
 #else
@@ -665,6 +678,7 @@ static int dp83867_of_init(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 = phydev->priv;
 	u16 delay;
+	int led;
 
 	/* For non-OF device, the RX and TX ID values are either strapped
 	 * or take from default value. So, we init RX & TX ID values here
@@ -682,6 +696,10 @@ static int dp83867_of_init(struct phy_device *phydev)
 	 */
 	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
 
+	/* LED mode unconfigured */
+	for (led = 0; led < ARRAY_SIZE(dp83867->led_modes); led++)
+		dp83867->led_modes[led] = -EINVAL;
+
 	return 0;
 }
 #endif /* CONFIG_OF_MDIO */
@@ -703,7 +721,7 @@ static int dp83867_probe(struct phy_device *phydev)
 static int dp83867_config_init(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 = phydev->priv;
-	int ret, val, bs;
+	int ret, val, bs, led;
 	u16 delay;
 
 	/* Force speed optimization for the PHY even if it strapped */
@@ -882,6 +900,16 @@ static int dp83867_config_init(struct phy_device *phydev)
 			       mask, val);
 	}
 
+	/* LED Configuration */
+	val = phy_read(phydev, DP83867_LEDCR1);
+	for (led = 0; led < ARRAY_SIZE(dp83867->led_modes); led++) {
+		if (dp83867->led_modes[led] != -EINVAL) {
+			val &= ~(DP83867_LED_MODE_MASK << (DP83867_LED_MODE_SHIFT * led));
+			val |= (dp83867->led_modes[led] << (DP83867_LED_MODE_SHIFT * led));
+		}
+	}
+	phy_write(phydev, DP83867_LEDCR1, val);
+
 	return 0;
 }
 
-- 
2.25.1

