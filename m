Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24649342162
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCSP5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhCSP5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:57:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B5AC061761
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:57:13 -0700 (PDT)
Received: from [2a0a:edc0:0:c01:1d::a2] (helo=drehscheibe.grey.stw.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUt-0007z3-LF; Fri, 19 Mar 2021 16:57:11 +0100
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00011G-Dr; Fri, 19 Mar 2021 16:57:10 +0100
Received: from mtr by dude03.red.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lNHUs-00BilV-Co; Fri, 19 Mar 2021 16:57:10 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc:     m.tretter@pengutronix.de, kernel@pengutronix.de,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        dmurphy@ti.com
Subject: [PATCH 2/2] net: phy: dp83867: add support for changing LED modes
Date:   Fri, 19 Mar 2021 16:57:10 +0100
Message-Id: <20210319155710.2793637-3-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210319155710.2793637-1-m.tretter@pengutronix.de>
References: <20210319155710.2793637-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

The DP83867 supports four configurable LEDs. Several functions can be
multiplexed to these LEDs. The multiplexing can be configured in the
LEDCR1 register.

Add support for changing the multiplexing of the LEDs via device tree.

Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/net/phy/dp83867.c | 57 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9bd9a5c0b1db..dfcac95941f3 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -25,6 +25,7 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR1		0x18
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -138,6 +139,12 @@
 #define DP83867_DOWNSHIFT_4_COUNT	4
 #define DP83867_DOWNSHIFT_8_COUNT	8
 
+/* LEDCR1 bits */
+#define DP83867_LEDCR1_LED_0_SEL	GENMASK(3, 0)
+#define DP83867_LEDCR1_LED_1_SEL	GENMASK(7, 4)
+#define DP83867_LEDCR1_LED_2_SEL	GENMASK(11, 8)
+#define DP83867_LEDCR1_LED_GPIO_SEL	GENMASK(15, 12)
+
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
 #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
@@ -154,6 +161,14 @@ enum {
 	DP83867_PORT_MIRROING_DIS,
 };
 
+enum {
+	DP83867_LED_0,
+	DP83867_LED_1,
+	DP83867_LED_2,
+	DP83867_LED_GPIO,
+	DP83867_LED_MAX,
+};
+
 struct dp83867_private {
 	u32 rx_id_delay;
 	u32 tx_id_delay;
@@ -165,6 +180,7 @@ struct dp83867_private {
 	bool set_clk_output;
 	u32 clk_output_sel;
 	bool sgmii_ref_clk_en;
+	u32 led_mode[DP83867_LED_MAX];
 };
 
 static int dp83867_ack_interrupt(struct phy_device *phydev)
@@ -521,6 +537,27 @@ static int dp83867_verify_rgmii_cfg(struct phy_device *phydev)
 }
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
+static int dp83867_of_led_mode_read(struct device_node *of_node,
+				    const char *led_name, u32 *mode)
+{
+	u32 tmp;
+	int index;
+	int err;
+
+	index = of_property_match_string(of_node, "ti,dp83867-led-mode-names",
+					 led_name);
+	err = of_property_read_u32_index(of_node, "ti,dp83867-led-modes",
+					 index, tmp);
+	if (err)
+		return err;
+	if (tmp == 0xc || tmp >= 0xf)
+		return -EINVAL;
+
+	*mode = tmp;
+
+	return 0;
+}
+
 static int dp83867_of_init(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 = phydev->priv;
@@ -614,6 +651,15 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	dp83867_of_led_mode_read(of_node, "led-0",
+				 &dp83867->led_mode[DP83867_LED_0]);
+	dp83867_of_led_mode_read(of_node, "led-1",
+				 &dp83867->led_mode[DP83867_LED_1]);
+	dp83867_of_led_mode_read(of_node, "led-2",
+				 &dp83867->led_mode[DP83867_LED_2]);
+	dp83867_of_led_mode_read(of_node, "led-gpio",
+				 &dp83867->led_mode[DP83867_LED_GPIO]);
+
 	return 0;
 }
 #else
@@ -632,6 +678,11 @@ static int dp83867_probe(struct phy_device *phydev)
 	if (!dp83867)
 		return -ENOMEM;
 
+	dp83867->led_mode[DP83867_LED_0] = DP83867_LED_LINK_EST;
+	dp83867->led_mode[DP83867_LED_1] = DP83867_LED_1000_BT_LINK;
+	dp83867->led_mode[DP83867_LED_2] = DP83867_LED_RX_TX_ACT;
+	dp83867->led_mode[DP83867_LED_GPIO] = DP83867_LED_100_BT_LINK;
+
 	phydev->priv = dp83867;
 
 	return dp83867_of_init(phydev);
@@ -792,6 +843,12 @@ static int dp83867_config_init(struct phy_device *phydev)
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
 	}
 
+	val = FIELD_PREP(DP83867_LEDCR1_LED_0_SEL, dp83867->led_mode[DP83867_LED_0]) |
+	      FIELD_PREP(DP83867_LEDCR1_LED_1_SEL, dp83867->led_mode[DP83867_LED_1]) |
+	      FIELD_PREP(DP83867_LEDCR1_LED_2_SEL, dp83867->led_mode[DP83867_LED_2]) |
+	      FIELD_PREP(DP83867_LEDCR1_LED_GPIO_SEL, dp83867->led_mode[DP83867_LED_GPIO]);
+	phy_write(phydev, DP83867_LEDCR1, val);
+
 	val = phy_read(phydev, DP83867_CFG3);
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev))
-- 
2.29.2

