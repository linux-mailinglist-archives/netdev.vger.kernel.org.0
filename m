Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EEC41DA7A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349436AbhI3NHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349366AbhI3NHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:19 -0400
X-Greylist: delayed 439 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Sep 2021 06:05:34 PDT
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467EEC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:05:34 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1D54BBFBED;
        Thu, 30 Sep 2021 14:58:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633006691; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding; bh=mQP0IN/HZLMfyoaA/4d+d8dWL3535oW7YGMjdydR1ig=;
        b=qeutuzyYZgLkH4wFo7j4ej+hcAFZNaX3EBJyYBWd9u5WsDa+SfWneXBJwoxffIQTYCMIBS
        4XXoWptB+yJ+3oOnt8xhXsZW2cbVL3TvHe0rWfiALGeS5yeK1pHNK59LGMBEPZQf1OLfQx
        p8yu42f9YpEemdC3nOTA9A2NS0MXaDyxcevTO7ZbvWYGj4U0fsYV4IpD6jkSgZQ3vi2qDr
        SZxjz7mG7qZMKJF3iaao7Z6NfJDMQv5uP8pNuCqGDNjcw3ZcLB4Q6AN2qj5bmJWhPRBUOq
        b5x1eed2bl1ULFKy3hZm6BdksOsH+SlYep20uHHlebGn7winEJIT/bt4iY4BwQ==
From:   Frieder Schrempf <frieder@fris.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH 1/3] net: phy: mscc: Add possibilty to disable combined LED mode
Date:   Thu, 30 Sep 2021 14:57:43 +0200
Message-Id: <20210930125747.2511954-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

By default the LED modes offer to combine two indicators like speed/link
and activity in one LED. In order to use a LED only for the first of the
two modes, the combined feature needs to be disabled.

In order to do this we introduce a boolean devicetree property
'vsc8531,led-[N]-combine-disable' and wire it up to the matching
bits in the LED behavior register.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/net/phy/mscc/mscc.h      |  5 ++++
 drivers/net/phy/mscc/mscc_main.c | 47 ++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..114b087fc89a 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -85,6 +85,10 @@ enum rgmii_clock_delay {
 #define LED_MODE_SEL_MASK(x)		  (GENMASK(3, 0) << LED_MODE_SEL_POS(x))
 #define LED_MODE_SEL(x, mode)		  (((mode) << LED_MODE_SEL_POS(x)) & LED_MODE_SEL_MASK(x))
 
+#define MSCC_PHY_LED_BEHAVIOR		  30
+#define LED_COMBINE_DIS_MASK(x)		  (1 << (x))
+#define LED_COMBINE_DIS(x, dis)		  (((dis) ? 1 : 0) << (x))
+
 #define MSCC_EXT_PAGE_CSR_CNTL_17	  17
 #define MSCC_EXT_PAGE_CSR_CNTL_18	  18
 
@@ -363,6 +367,7 @@ struct vsc8531_private {
 	int rate_magic;
 	u16 supp_led_modes;
 	u32 leds_mode[MAX_LEDS];
+	bool leds_combine[MAX_LEDS];
 	u8 nleds;
 	const struct vsc85xx_hw_stat *hw_stats;
 	u64 *stats;
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6e32da28e138..d42723e04c98 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -171,7 +171,8 @@ static void vsc85xx_get_stats(struct phy_device *phydev,
 
 static int vsc85xx_led_cntl_set(struct phy_device *phydev,
 				u8 led_num,
-				u8 mode)
+				u8 mode,
+				bool combine_disable)
 {
 	int rc;
 	u16 reg_val;
@@ -181,6 +182,10 @@ static int vsc85xx_led_cntl_set(struct phy_device *phydev,
 	reg_val &= ~LED_MODE_SEL_MASK(led_num);
 	reg_val |= LED_MODE_SEL(led_num, (u16)mode);
 	rc = phy_write(phydev, MSCC_PHY_LED_MODE_SEL, reg_val);
+	reg_val = phy_read(phydev, MSCC_PHY_LED_BEHAVIOR);
+	reg_val &= ~LED_COMBINE_DIS_MASK(led_num);
+	reg_val |= LED_COMBINE_DIS(led_num, combine_disable);
+	rc = phy_write(phydev, MSCC_PHY_LED_BEHAVIOR, reg_val);
 	mutex_unlock(&phydev->lock);
 
 	return rc;
@@ -432,6 +437,21 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
 	return led_mode;
 }
 
+static bool vsc85xx_dt_led_combine_get(struct phy_device *phydev,
+				       char *led)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	bool led_combine = false;
+	int err;
+
+	if (!of_node)
+		return false;
+
+	return of_property_read_bool(of_node, led);
+}
+
 #else
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
@@ -444,13 +464,19 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
 {
 	return default_mode;
 }
+
+static bool vsc85xx_dt_led_combine_get(struct phy_device *phydev,
+				       char *led)
+{
+	return false;
+}
 #endif /* CONFIG_OF_MDIO */
 
 static int vsc85xx_dt_led_modes_get(struct phy_device *phydev,
 				    u32 *default_mode)
 {
 	struct vsc8531_private *priv = phydev->priv;
-	char led_dt_prop[28];
+	char led_dt_prop[32];
 	int i, ret;
 
 	for (i = 0; i < priv->nleds; i++) {
@@ -463,6 +489,14 @@ static int vsc85xx_dt_led_modes_get(struct phy_device *phydev,
 		if (ret < 0)
 			return ret;
 		priv->leds_mode[i] = ret;
+
+		ret = sprintf(led_dt_prop,
+			      "vsc8531,led-%d-combine-disable", i);
+		if (ret < 0)
+			return ret;
+
+		priv->leds_combine[i] =
+			vsc85xx_dt_led_combine_get(phydev, led_dt_prop);
 	}
 
 	return 0;
@@ -1779,7 +1813,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 		return ret;
 
 	for (i = 0; i < vsc8531->nleds; i++) {
-		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
+		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i],
+					   vsc8531->leds_combine[i]);
 		if (ret)
 			return ret;
 	}
@@ -1846,7 +1881,8 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 		return rc;
 
 	for (i = 0; i < vsc8531->nleds; i++) {
-		rc = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
+		rc = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i],
+					  vsc8531->leds_combine[i]);
 		if (rc)
 			return rc;
 	}
@@ -2099,7 +2135,8 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		return ret;
 
 	for (i = 0; i < vsc8531->nleds; i++) {
-		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
+		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i],
+					   vsc8531->leds_combine[i]);
 		if (ret)
 			return ret;
 	}
-- 
2.33.0

