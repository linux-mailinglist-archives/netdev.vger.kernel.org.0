Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BE2EA678
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfJ3WnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:43:13 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:34885 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfJ3WnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:43:07 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BFD4822EE9;
        Wed, 30 Oct 2019 23:43:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572475383;
        bh=XFnpLVTbRIOcv1JIzgMCiJ0o/IuB8jUGvt9WomlOMmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQYCiXIqi++5FhEhgAeuFiPqNbek6Rkmh9YO82+pNsUhBv27AZv9oygpNLusWhej5
         CYvnyfdZbU5uRmcIM6BZ2hDA/4lxIjqYgQkXA4CHYiJtVKY+UJ5Jt/kUeIslQuUZN3
         I/BqZIfXqXkn3Pvvz4lLncWIMC17wX6JMU+C6slg=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
Date:   Wed, 30 Oct 2019 23:42:51 +0100
Message-Id: <20191030224251.21578-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030224251.21578-1-michael@walle.cc>
References: <20191030224251.21578-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring the CLK_25M pin as well as the RGMII I/O
voltage by the device tree.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 156 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 1eb5d4fb8925..32be4c72cf4b 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -13,7 +13,9 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/of_gpio.h>
+#include <linux/bitfield.h>
 #include <linux/gpio/consumer.h>
+#include <dt-bindings/net/atheros-at803x.h>
 
 #define AT803X_SPECIFIC_STATUS			0x11
 #define AT803X_SS_SPEED_MASK			(3 << 14)
@@ -62,6 +64,37 @@
 #define AT803X_DEBUG_REG_5			0x05
 #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
 
+#define AT803X_DEBUG_REG_1F			0x1F
+#define AT803X_DEBUG_PLL_ON			BIT(2)
+#define AT803X_DEBUG_RGMII_1V8			BIT(3)
+
+/* AT803x supports either the XTAL input pad, an internal PLL or the
+ * DSP as clock reference for the clock output pad. The XTAL reference
+ * is only used for 25 MHz output, all other frequencies need the PLL.
+ * The DSP as a clock reference is used in synchronous ethernet
+ * applications.
+ *
+ * By default the PLL is only enabled if there is a link. Otherwise
+ * the PHY will go into low power state and disabled the PLL. You can
+ * set the PLL_ON bit (see debug register 0x1f) to keep the PLL always
+ * enabled.
+ */
+#define AT803X_MMD7_CLK25M			0x8016
+#define AT803X_CLK_OUT_MASK			GENMASK(4, 2)
+#define AT803X_CLK_OUT_25MHZ_XTAL		0
+#define AT803X_CLK_OUT_25MHZ_DSP		1
+#define AT803X_CLK_OUT_50MHZ_PLL		2
+#define AT803X_CLK_OUT_50MHZ_DSP		3
+#define AT803X_CLK_OUT_62_5MHZ_PLL		4
+#define AT803X_CLK_OUT_62_5MHZ_DSP		5
+#define AT803X_CLK_OUT_125MHZ_PLL		6
+#define AT803X_CLK_OUT_125MHZ_DSP		7
+
+#define AT803X_CLK_OUT_STRENGTH_MASK		GENMASK(8, 7)
+#define AT803X_CLK_OUT_STRENGTH_FULL		0
+#define AT803X_CLK_OUT_STRENGTH_HALF		1
+#define AT803X_CLK_OUT_STRENGTH_QUARTER		2
+
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
 #define ATH8035_PHY_ID 0x004dd072
@@ -73,6 +106,11 @@ MODULE_LICENSE("GPL");
 
 struct at803x_priv {
 	bool phy_reset:1;
+	int flags;
+#define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
+#define AT803X_RGMII_1V8	BIT(1)	/* use 1.8V RGMII voltage */
+	u16 clk_25m_reg;
+	u16 clk_25m_mask;
 };
 
 struct at803x_context {
@@ -240,6 +278,74 @@ static int at803x_resume(struct phy_device *phydev)
 	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN | BMCR_ISOLATE, 0);
 }
 
+static int at803x_parse_dt(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct at803x_priv *priv = phydev->priv;
+	u32 freq, strength;
+	unsigned int sel;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!node)
+		return 0;
+
+	if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
+		priv->flags |= AT803X_KEEP_PLL_ENABLED;
+
+	if (of_property_read_bool(node, "atheros,rgmii-io-1v8"))
+		priv->flags |= AT803X_RGMII_1V8;
+
+	ret = of_property_read_u32(node, "atheros,clk-out-frequency", &freq);
+	if (!ret) {
+		switch (freq) {
+		case 25000000:
+			sel = AT803X_CLK_OUT_25MHZ_XTAL;
+			break;
+		case 50000000:
+			sel = AT803X_CLK_OUT_50MHZ_PLL;
+			break;
+		case 62500000:
+			sel = AT803X_CLK_OUT_62_5MHZ_PLL;
+			break;
+		case 125000000:
+			sel = AT803X_CLK_OUT_125MHZ_PLL;
+			break;
+		default:
+			phydev_err(phydev,
+				   "invalid atheros,clk-out-frequency\n");
+			return -EINVAL;
+		}
+
+		priv->clk_25m_reg |= FIELD_PREP(AT803X_CLK_OUT_MASK, sel);
+		priv->clk_25m_mask |= AT803X_CLK_OUT_MASK;
+	}
+
+	ret = of_property_read_u32(node, "atheros,clk-out-strength", &strength);
+	if (!ret) {
+		priv->clk_25m_mask |= AT803X_CLK_OUT_STRENGTH_MASK;
+		switch (strength) {
+		case AT803X_STRENGTH_FULL:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_FULL;
+			break;
+		case AT803X_STRENGTH_HALF:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_HALF;
+			break;
+		case AT803X_STRENGTH_QUARTER:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_QUARTER;
+			break;
+		default:
+			phydev_err(phydev,
+				   "invalid atheros,clk-out-strength\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int at803x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -251,11 +357,31 @@ static int at803x_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	return 0;
+	return at803x_parse_dt(phydev);
+}
+
+static int at803x_clk_out_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	int val;
+
+	if (!priv->clk_25m_mask)
+		return 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, AT803X_MMD7_CLK25M);
+	if (val < 0)
+		return val;
+
+	val &= ~priv->clk_25m_mask;
+	val |= priv->clk_25m_reg;
+
+	return phy_write_mmd(phydev, MDIO_MMD_AN, AT803X_MMD7_CLK25M, val);
 }
 
 static int at803x_config_init(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
+	u16 set = 0, clear = 0;
 	int ret;
 
 	/* The RX and TX delay default is:
@@ -276,8 +402,34 @@ static int at803x_config_init(struct phy_device *phydev)
 		ret = at803x_enable_tx_delay(phydev);
 	else
 		ret = at803x_disable_tx_delay(phydev);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	ret = at803x_clk_out_config(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* The default after hardware reset is:
+	 *   1.5V RGMII I/O voltage
+	 *   PLL OFF (which means it is off if there is no link)
+	 *
+	 * After a soft reset, the values are retained.
+	 */
+	if (priv->flags & AT803X_KEEP_PLL_ENABLED)
+		set |= AT803X_DEBUG_PLL_ON;
+	else
+		clear |= AT803X_DEBUG_PLL_ON;
+
+	if (priv->flags & AT803X_RGMII_1V8)
+		set |= AT803X_DEBUG_RGMII_1V8;
+	else
+		clear |= AT803X_DEBUG_RGMII_1V8;
+
+	ret = at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_1F, clear, set);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int at803x_ack_interrupt(struct phy_device *phydev)
-- 
2.20.1

