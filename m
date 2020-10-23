Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD8296D2B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462629AbgJWK5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462575AbgJWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F37C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:39 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087o-Kr; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001kK-E8; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 2/6] net: phy: add a driver for generic CAN PHYs
Date:   Fri, 23 Oct 2020 12:56:22 +0200
Message-Id: <20201023105626.6534-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generic CAN PHY driver should provide support for simple CAN PHYs
(transceiver).

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/Kconfig       |   6 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/can_phy_drv.c | 236 ++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 drivers/net/phy/can_phy_drv.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 39e3f57ea60a..c4ae29c8e9ff 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -153,6 +153,12 @@ config BCM_CYGNUS_PHY
 config BCM_NET_PHYLIB
 	tristate
 
+config CAN_GENERIC_PHY
+	tristate "Generic CAN PHY"
+	depends on CAN_PHY_BUS
+	help
+	  Enable this driver to support the majority of simple CAN PHYs.
+
 config CAN_PHY_BUS
 	tristate "Virtual CAN PHY Bus"
 	depends on PHYLIB
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 0d76d802c07f..80053cb13dc0 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
+obj-$(CONFIG_CAN_GENERIC_PHY)	+= can_phy_drv.o
 obj-$(CONFIG_CAN_PHY_BUS)	+= can_phy_bus.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
diff --git a/drivers/net/phy/can_phy_drv.c b/drivers/net/phy/can_phy_drv.c
new file mode 100644
index 000000000000..c52bf11fdc03
--- /dev/null
+++ b/drivers/net/phy/can_phy_drv.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: 2020 Oleksij Rempel <kernel@pengutronix.de>, Pengutronix
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/regulator/consumer.h>
+
+/* flags */
+#define CAN_GEN_SIC_XL			BIT(5)
+#define CAN_GEN_SIC			BIT(4)
+#define CAN_GEN_FD			BIT(3)
+#define CAN_GEN_HS			BIT(2)
+#define CAN_GEN_LS			BIT(1)
+#define CAN_GEN_SW			BIT(0)
+
+struct can_gen_dcfg {
+	u32 flags;
+	u32 max_bitrate;
+};
+
+struct can_gen_priv {
+	struct regulator *reg_xceiver;
+	struct can_gen_dcfg dcfg;
+	bool off;
+};
+
+static const struct can_gen_dcfg can_gen_nxp_tja1051 = {
+	.flags = CAN_GEN_HS | CAN_GEN_FD,
+	.max_bitrate = 5000000,
+};
+
+static const struct of_device_id can_gen_ids[] = {
+	{
+		.compatible = "can,generic-transceiver",
+	}, {
+		.compatible = "nxp,tja1051",
+		.data = &can_gen_nxp_tja1051,
+	}, { /* sentinel */ }
+};
+
+static void can_gen_get_bitrate(struct can_gen_priv *priv,
+			       struct phy_device *phydev)
+{
+	struct device_node *np = phydev->mdio.dev.of_node;
+	struct can_gen_dcfg *dcfg = &priv->dcfg;
+	u32 max_bitrate;
+	int ret;
+
+	ret = of_property_read_u32(np, "max-bitrate", &max_bitrate);
+	if (ret)
+		phydev_warn(phydev, "Can't read max-bitrate\n");
+
+	if (!dcfg->max_bitrate && !max_bitrate) {
+		phydev_warn(phydev, "Huh... Limitless PHY!!\n");
+
+		if (dcfg->flags & CAN_GEN_FD) {
+			max_bitrate = 12000000; /* 12Mbit */
+		} else if (dcfg->flags & CAN_GEN_HS) {
+			max_bitrate = 1000000; /* 1Mbit */
+		} else if (dcfg->flags & CAN_GEN_LS) {
+			max_bitrate = 125000; /* 125Kbit */
+		} else if (dcfg->flags & CAN_GEN_SW) {
+			max_bitrate = 83300; /* 83.3kbit */
+		} else {
+			max_bitrate = 12000000; /* 12Mbit */
+			phydev_warn(phydev, "Can't determine the max bitrate! Set: %d\n",
+				    max_bitrate);
+		}
+
+		dcfg->max_bitrate = max_bitrate;
+	} else if (dcfg->max_bitrate && max_bitrate > dcfg->max_bitrate) {
+		phydev_info(phydev, "Ignoring max-bitrate property: %d, hw limit: %d\n",
+			    max_bitrate, dcfg->max_bitrate);
+	} else {
+		dcfg->max_bitrate = max_bitrate;
+	}
+}
+
+static void can_gen_parse_dt_flags(struct can_gen_priv *priv,
+				   struct phy_device *phydev)
+{
+	struct can_gen_dcfg *dcfg = &priv->dcfg;
+	struct device *dev = &phydev->mdio.dev;
+
+	if (device_property_read_bool(dev, "can-sic-xl"))
+		dcfg->flags |= CAN_GEN_SIC_XL;
+	if (device_property_read_bool(dev, "can-sic"))
+		dcfg->flags |= CAN_GEN_SIC;
+	if (device_property_read_bool(dev, "can-fd"))
+		dcfg->flags |= CAN_GEN_FD;
+	if (device_property_read_bool(dev, "can-hs"))
+		dcfg->flags |= CAN_GEN_HS;
+	if (device_property_read_bool(dev, "can-ls"))
+		dcfg->flags |= CAN_GEN_LS;
+	if (device_property_read_bool(dev, "can-sw"))
+		dcfg->flags |= CAN_GEN_SW;
+}
+
+static int can_gen_probe(struct phy_device *phydev)
+{
+	struct device_node *np = phydev->mdio.dev.of_node;
+	const struct of_device_id *match;
+	struct regulator *reg_xceiver;
+	struct can_gen_priv *priv;
+
+	match = of_match_node(can_gen_ids, np);
+	if (!match)
+		return 0;
+
+	reg_xceiver = devm_regulator_get_optional(&phydev->mdio.dev, "xceiver");
+	if (PTR_ERR(reg_xceiver) == -ENODEV)
+		reg_xceiver = NULL;
+	else if (IS_ERR(reg_xceiver))
+		return dev_err_probe(&phydev->mdio.dev, PTR_ERR(reg_xceiver),
+				     "Failed to get Transceiver regulator!\n");
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (!match->data)
+		can_gen_parse_dt_flags(priv, phydev);
+	else
+		memcpy(&priv->dcfg, match->data, sizeof(priv->dcfg));
+
+	can_gen_get_bitrate(priv, phydev);
+
+	phydev->priv = priv;
+	priv->reg_xceiver = reg_xceiver;
+	priv->off = true;
+
+	return 0;
+}
+
+static int can_gen_read_status(struct phy_device *phydev)
+{
+	phydev->link = true;
+	phydev->duplex = DUPLEX_HALF;
+
+	return 0;
+}
+
+static int can_gen_match_phy_device(struct phy_device *phydev)
+{
+	struct device_node *np = phydev->mdio.dev.of_node;
+	const struct of_device_id *match;
+
+	if (phydev->phy_id)
+		return 0;
+
+	match = of_match_node(can_gen_ids, np);
+	if (!match)
+		return 0;
+
+	return 1;
+}
+
+static int can_get_features(struct phy_device *phydev)
+{
+	struct can_gen_priv *priv = phydev->priv;
+	struct can_gen_dcfg *dcfg = &priv->dcfg;
+
+	phydev->interface = PHY_INTERFACE_MODE_CAN;
+	phydev->max_bitrate = dcfg->max_bitrate;
+
+	if (dcfg->flags & CAN_GEN_SIC_XL)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_SIC_XL_BIT,
+				 phydev->supported);
+	if (dcfg->flags & CAN_GEN_SIC)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_SIC_BIT,
+				 phydev->supported);
+	if (dcfg->flags & CAN_GEN_FD)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_FD_BIT,
+				 phydev->supported);
+	if (dcfg->flags & CAN_GEN_HS)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_HS_BIT,
+				 phydev->supported);
+	if (dcfg->flags & CAN_GEN_LS)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_LS_BIT,
+				 phydev->supported);
+	if (dcfg->flags & CAN_GEN_SW)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_CAN_SW_BIT,
+				 phydev->supported);
+
+	return 0;
+}
+
+static int can_gen_config_aneg(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static int can_gen_resume(struct phy_device *phydev)
+{
+	struct can_gen_priv *priv = phydev->priv;
+
+	/* Resume can be called multiple times, so it will be asymmetric to
+	 * the suspend call.*/
+	if (!priv->off)
+		return 0;
+
+	priv->off = false;
+
+	return regulator_enable(priv->reg_xceiver);
+}
+
+static int can_gen_suspend(struct phy_device *phydev)
+{
+	struct can_gen_priv *priv = phydev->priv;
+
+	if (priv->off)
+		return 0;
+
+	priv->off = true;
+
+	return regulator_disable(priv->reg_xceiver);
+}
+
+static struct phy_driver can_gen_drv[] = {
+	{
+		.name			= "Generic CAN PHY",
+		.match_phy_device	= can_gen_match_phy_device,
+		.probe			= can_gen_probe,
+		.read_status		= can_gen_read_status,
+		.suspend		= can_gen_suspend,
+		.resume			= can_gen_resume,
+		.get_features		= can_get_features,
+		.config_aneg		= can_gen_config_aneg,
+	},
+};
+module_phy_driver(can_gen_drv);
+
+MODULE_DESCRIPTION("Generic CAN PHY driver");
+MODULE_AUTHOR("Oleksij Rempel");
+MODULE_LICENSE("GPLv2");
-- 
2.28.0

