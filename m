Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DFF21DC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbfKFWhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:37:20 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:55673 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfKFWhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:37:00 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BF91823E48;
        Wed,  6 Nov 2019 23:36:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573079817;
        bh=THmjNYuB/baQOsCYVMIBafmJyXUq/o5Ix4mzfk3+nwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpOstLsrAcVtN0l01gLedH7BBxmeKlWR8u0N4vDA9/0yE9iUPTl5Zw16N6zEdNfZP
         /IeuJGYG9n5igAloGv0q85IbD4uKa0gn0HQDGHuFpsFZzoNFLRyxueSTmh0ZR0YqnX
         T7taaur7ZDg5vyeG2GS7s/rYe51NOhbAjA+TOB3g=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 3/6] net: phy: at803x: add device tree binding
Date:   Wed,  6 Nov 2019 23:36:14 +0100
Message-Id: <20191106223617.1655-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106223617.1655-1-michael@walle.cc>
References: <20191106223617.1655-1-michael@walle.cc>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/at803x.c | 301 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 300 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 8e30db28fd7d..aa782b28615b 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -13,7 +13,12 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/of_gpio.h>
+#include <linux/bitfield.h>
 #include <linux/gpio/consumer.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/consumer.h>
+#include <dt-bindings/net/qca-ar803x.h>
 
 #define AT803X_SPECIFIC_STATUS			0x11
 #define AT803X_SS_SPEED_MASK			(3 << 14)
@@ -62,6 +67,42 @@
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
+/* The AR8035 has another mask which is compatible with the AR8031 mask but
+ * doesn't support choosing between XTAL/PLL and DSP.
+ */
+#define AT8035_CLK_OUT_MASK			GENMASK(4, 3)
+
+#define AT803X_CLK_OUT_STRENGTH_MASK		GENMASK(8, 7)
+#define AT803X_CLK_OUT_STRENGTH_FULL		0
+#define AT803X_CLK_OUT_STRENGTH_HALF		1
+#define AT803X_CLK_OUT_STRENGTH_QUARTER		2
+
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
@@ -72,6 +113,16 @@ MODULE_DESCRIPTION("Atheros 803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
+struct at803x_priv {
+	int flags;
+#define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
+	u16 clk_25m_reg;
+	u16 clk_25m_mask;
+	struct regulator_dev *vddio_rdev;
+	struct regulator_dev *vddh_rdev;
+	struct regulator *vddio;
+};
+
 struct at803x_context {
 	u16 bmcr;
 	u16 advertise;
@@ -237,6 +288,238 @@ static int at803x_resume(struct phy_device *phydev)
 	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN | BMCR_ISOLATE, 0);
 }
 
+static int at803x_rgmii_reg_set_voltage_sel(struct regulator_dev *rdev,
+					    unsigned int selector)
+{
+	struct phy_device *phydev = rdev_get_drvdata(rdev);
+
+	if (selector)
+		return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_1F,
+					     0, AT803X_DEBUG_RGMII_1V8);
+	else
+		return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_1F,
+					     AT803X_DEBUG_RGMII_1V8, 0);
+}
+
+static int at803x_rgmii_reg_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct phy_device *phydev = rdev_get_drvdata(rdev);
+	int val;
+
+	val = at803x_debug_reg_read(phydev, AT803X_DEBUG_REG_1F);
+	if (val < 0)
+		return val;
+
+	return (val & AT803X_DEBUG_RGMII_1V8) ? 1 : 0;
+}
+
+static struct regulator_ops vddio_regulator_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.set_voltage_sel = at803x_rgmii_reg_set_voltage_sel,
+	.get_voltage_sel = at803x_rgmii_reg_get_voltage_sel,
+};
+
+static const unsigned int vddio_voltage_table[] = {
+	1500000,
+	1800000,
+};
+
+static const struct regulator_desc vddio_desc = {
+	.name = "vddio",
+	.of_match = of_match_ptr("vddio-regulator"),
+	.n_voltages = ARRAY_SIZE(vddio_voltage_table),
+	.volt_table = vddio_voltage_table,
+	.ops = &vddio_regulator_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+};
+
+static struct regulator_ops vddh_regulator_ops = {
+};
+
+static const struct regulator_desc vddh_desc = {
+	.name = "vddh",
+	.of_match = of_match_ptr("vddh-regulator"),
+	.n_voltages = 1,
+	.fixed_uV = 2500000,
+	.ops = &vddh_regulator_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+};
+
+static int at8031_register_regulators(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct regulator_config config = { };
+
+	config.dev = dev;
+	config.driver_data = phydev;
+
+	priv->vddio_rdev = devm_regulator_register(dev, &vddio_desc, &config);
+	if (IS_ERR(priv->vddio_rdev)) {
+		phydev_err(phydev, "failed to register VDDIO regulator\n");
+		return PTR_ERR(priv->vddio_rdev);
+	}
+
+	priv->vddh_rdev = devm_regulator_register(dev, &vddh_desc, &config);
+	if (IS_ERR(priv->vddh_rdev)) {
+		phydev_err(phydev, "failed to register VDDH regulator\n");
+		return PTR_ERR(priv->vddh_rdev);
+	}
+
+	return 0;
+}
+
+static bool at803x_match_phy_id(struct phy_device *phydev, u32 phy_id)
+{
+	return (phydev->phy_id & phydev->drv->phy_id_mask)
+		== (phy_id & phydev->drv->phy_id_mask);
+}
+
+static int at803x_parse_dt(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct at803x_priv *priv = phydev->priv;
+	unsigned int sel, mask;
+	u32 freq, strength;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	ret = of_property_read_u32(node, "qca,clk-out-frequency", &freq);
+	if (!ret) {
+		mask = AT803X_CLK_OUT_MASK;
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
+			phydev_err(phydev, "invalid qca,clk-out-frequency\n");
+			return -EINVAL;
+		}
+
+		priv->clk_25m_reg |= FIELD_PREP(mask, sel);
+		priv->clk_25m_mask |= mask;
+
+		/* Fixup for the AR8030/AR8035. This chip has another mask and
+		 * doesn't support the DSP reference. Eg. the lowest bit of the
+		 * mask. The upper two bits select the same frequencies. Mask
+		 * the lowest bit here.
+		 *
+		 * Warning:
+		 *   There was no datasheet for the AR8030 available so this is
+		 *   just a guess. But the AR8035 is listed as pin compatible
+		 *   to the AR8030 so there might be a good chance it works on
+		 *   the AR8030 too.
+		 */
+		if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
+		    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
+			priv->clk_25m_reg &= ~AT8035_CLK_OUT_MASK;
+			priv->clk_25m_mask &= ~AT8035_CLK_OUT_MASK;
+		}
+	}
+
+	ret = of_property_read_u32(node, "qca,clk-out-strength", &strength);
+	if (!ret) {
+		priv->clk_25m_mask |= AT803X_CLK_OUT_STRENGTH_MASK;
+		switch (strength) {
+		case AR803X_STRENGTH_FULL:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_FULL;
+			break;
+		case AR803X_STRENGTH_HALF:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_HALF;
+			break;
+		case AR803X_STRENGTH_QUARTER:
+			priv->clk_25m_reg |= AT803X_CLK_OUT_STRENGTH_QUARTER;
+			break;
+		default:
+			phydev_err(phydev, "invalid qca,clk-out-strength\n");
+			return -EINVAL;
+		}
+	}
+
+	/* Only supported on AR8031, the AR8030/AR8035 use strapping options */
+	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		if (of_property_read_bool(node, "qca,keep-pll-enabled"))
+			priv->flags |= AT803X_KEEP_PLL_ENABLED;
+
+		ret = at8031_register_regulators(phydev);
+		if (ret < 0)
+			return ret;
+
+		priv->vddio = devm_regulator_get_optional(&phydev->mdio.dev,
+							  "vddio");
+		if (IS_ERR(priv->vddio)) {
+			phydev_err(phydev, "failed to get VDDIO regulator\n");
+			return PTR_ERR(priv->vddio);
+		}
+
+		ret = regulator_enable(priv->vddio);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int at803x_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct at803x_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
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
+}
+
+static int at8031_pll_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	/* The default after hardware reset is PLL OFF. After a soft reset, the
+	 * values are retained.
+	 */
+	if (priv->flags & AT803X_KEEP_PLL_ENABLED)
+		return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_1F,
+					     0, AT803X_DEBUG_PLL_ON);
+	else
+		return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_1F,
+					     AT803X_DEBUG_PLL_ON, 0);
+}
+
 static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -259,8 +542,20 @@ static int at803x_config_init(struct phy_device *phydev)
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
+	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		ret = at8031_pll_config(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int at803x_ack_interrupt(struct phy_device *phydev)
@@ -413,6 +708,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8035_PHY_ID,
 	.name			= "Atheros 8035 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
+	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -427,6 +723,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8030_PHY_ID,
 	.name			= "Atheros 8030 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
+	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.link_change_notify	= at803x_link_change_notify,
 	.set_wol		= at803x_set_wol,
@@ -441,6 +738,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id			= ATH8031_PHY_ID,
 	.name			= "Atheros 8031 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
+	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.set_wol		= at803x_set_wol,
 	.get_wol		= at803x_get_wol,
@@ -455,6 +753,7 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Atheros AR9331 built-in PHY",
+	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
-- 
2.20.1

