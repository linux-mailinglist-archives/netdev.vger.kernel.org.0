Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D53178F0E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgCDK7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:59:30 -0500
Received: from vsmx009.vodafonemail.xion.oxcs.net ([153.92.174.87]:13362 "EHLO
        vsmx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387762AbgCDK73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:59:29 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 05:59:27 EST
Received: from vsmx001.vodafonemail.xion.oxcs.net (unknown [192.168.75.191])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id E522A159DA98;
        Wed,  4 Mar 2020 10:53:15 +0000 (UTC)
Received: from app-31.app.xion.oxcs.net (app-31.app.xion.oxcs.net [10.10.1.31])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 93DBF159DA68;
        Wed,  4 Mar 2020 10:53:03 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:53:03 +0100 (CET)
From:   Markus Moll <moll.markus@arcor.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <1187386028.315311.1583319183516@mail.vodafone.de>
Subject: [PATCH 2/3] net: phy: dp83867: Add ability to configure LEDs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev66
X-Originating-Client: open-xchange-appsuite
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83867 PHY has configurable LED outputs. This code adds the
devicetree property ti,led-modes as an array of four LED mode
values corresponding to LED_0 through LED_3. Accepted values can be
found in dt-bindings/net/ti-dp83867.h.

Signed-off-by: Markus Moll <moll.markus@arcor.de>
---
 drivers/net/phy/dp83867.c | 57 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 13f7f2d5a2e..ddf1ec8390e 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,7 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR1		0x18
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -145,6 +146,16 @@
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
+/* LEDCR1 bits */
+#define DP83867_LED_RESERVED			0xC
+#define DP83867_LED_MAX				0xE
+#define DP83867_LED_3_SHIFT			12
+#define DP83867_LED_2_SHIFT			8
+#define DP83867_LED_1_SHIFT			4
+#define DP83867_LED_0_SHIFT			0
+
+#define NUM_LEDS				4
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -162,6 +173,7 @@ struct dp83867_private {
 	bool set_clk_output;
 	u32 clk_output_sel;
 	bool sgmii_ref_clk_en;
+	u32 led_modes[NUM_LEDS];
 };
 
 static int dp83867_ack_interrupt(struct phy_device *phydev)
@@ -483,6 +495,30 @@ static int dp83867_verify_rgmii_cfg(struct phy_device *phydev)
 	return 0;
 }
 
+static int dp83867_validate_led_modes(struct phy_device *phydev)
+{
+	struct dp83867_private *dp83867 = phydev->priv;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dp83867->led_modes); i++) {
+		if (dp83867->led_modes[i] == DP83867_LED_RESERVED) {
+			phydev_err(phydev,
+				   "ti,led-modes value %u invalid\n",
+				   dp83867->led_modes[i]);
+			return -EINVAL;
+		}
+
+		if (dp83867->led_modes[i] > DP83867_LED_MAX) {
+			phydev_err(phydev,
+				   "ti,led-modes value %u out of range\n",
+				   dp83867->led_modes[i]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_OF_MDIO
 static int dp83867_of_init(struct phy_device *phydev)
 {
@@ -578,6 +614,17 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	/* default LED modes according to data sheet */
+	dp83867->led_modes[0] = DP83867_LED_LINK;
+	dp83867->led_modes[1] = DP83867_LED_LINK_1000_BT;
+	dp83867->led_modes[2] = DP83867_LED_ACT_RX_TX;
+	dp83867->led_modes[3] = DP83867_LED_LINK_100_BTX;
+
+	ret = of_property_read_u32_array(of_node, "ti,led-modes",
+					 &dp83867->led_modes[0], NUM_LEDS);
+	if (!ret && dp83867_validate_led_modes(phydev))
+		return -EINVAL;
+
 	return 0;
 }
 #else
@@ -617,6 +664,16 @@ static int dp83867_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	/* Set LED modes */
+	val = 0;
+	val |= (dp83867->led_modes[0] << DP83867_LED_0_SHIFT);
+	val |= (dp83867->led_modes[1] << DP83867_LED_1_SHIFT);
+	val |= (dp83867->led_modes[2] << DP83867_LED_2_SHIFT);
+	val |= (dp83867->led_modes[3] << DP83867_LED_3_SHIFT);
+	ret = phy_write(phydev, DP83867_LEDCR1, val);
+	if (ret)
+		return ret;
+
 	/* RX_DV/RX_CTRL strapped in mode 1 or mode 2 workaround */
 	if (dp83867->rxctrl_strap_quirk)
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
-- 
2.25.0
