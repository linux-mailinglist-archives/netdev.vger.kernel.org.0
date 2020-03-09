Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0365E17D9F6
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 08:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCIHky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 03:40:54 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57487 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgCIHkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 03:40:53 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jBD1r-00047c-VK; Mon, 09 Mar 2020 08:40:47 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jBD1q-0006PZ-PF; Mon, 09 Mar 2020 08:40:46 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: [PATCH v2 2/2] net: phy: tja11xx: add delayed registration of TJA1102 PHY1
Date:   Mon,  9 Mar 2020 08:40:44 +0100
Message-Id: <20200309074044.21399-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200309074044.21399-1-o.rempel@pengutronix.de>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TJA1102 is a dual PHY package with PHY0 having proper PHYID and PHY1
having no ID. On one hand it is possible to for PHY detection by
compatible, on other hand we should be able to reset complete chip
before PHY1 configured it, and we need to define dependencies for proper
power management.

We can solve it by defining PHY1 as child of PHY0:
	tja1102_phy0: ethernet-phy@4 {
		reg = <0x4>;

		interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;

		reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
		reset-assert-us = <20>;
		reset-deassert-us = <2000>;

		tja1102_phy1: ethernet-phy@5 {
			reg = <0x5>;

			interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
		};
	};

The PHY1 should be a subnode of PHY0 and registered only after PHY0 was
completely reset and initialized.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 116 ++++++++++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index f79c9aa051ed..53e9e0aa9b5b 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -6,11 +6,14 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
+#include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/hwmon.h>
 #include <linux/bitfield.h>
+#include <linux/of_mdio.h>
+#include <linux/of_irq.h>
 
 #define PHY_ID_MASK			0xfffffff0
 #define PHY_ID_TJA1100			0x0180dc40
@@ -57,6 +60,8 @@
 struct tja11xx_priv {
 	char		*hwmon_name;
 	struct device	*hwmon_dev;
+	struct phy_device *phydev;
+	struct work_struct phy_register_work;
 };
 
 struct tja11xx_phy_stats {
@@ -333,16 +338,12 @@ static const struct hwmon_chip_info tja11xx_hwmon_chip_info = {
 	.info		= tja11xx_hwmon_info,
 };
 
-static int tja11xx_probe(struct phy_device *phydev)
+static int tja11xx_hwmon_register(struct phy_device *phydev,
+				  struct tja11xx_priv *priv)
 {
 	struct device *dev = &phydev->mdio.dev;
-	struct tja11xx_priv *priv;
 	int i;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
 	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
 	if (!priv->hwmon_name)
 		return -ENOMEM;
@@ -360,6 +361,107 @@ static int tja11xx_probe(struct phy_device *phydev)
 	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
 }
 
+static int tja11xx_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct tja11xx_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->phydev = phydev;
+
+	return tja11xx_hwmon_register(phydev, priv);
+}
+
+static void tja1102_p1_register(struct work_struct *work)
+{
+	struct tja11xx_priv *priv = container_of(work, struct tja11xx_priv,
+						 phy_register_work);
+
+	struct phy_device *phydev_phy0 = priv->phydev;
+        struct mii_bus *bus = phydev_phy0->mdio.bus;
+	struct device *dev = &phydev_phy0->mdio.dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *child;
+	int ret;
+
+	for_each_available_child_of_node(np, child) {
+		struct phy_device *phy;
+		int addr;
+
+		addr = of_mdio_parse_addr(dev, child);
+		if (addr < 0) {
+			dev_err(dev, "Can't parse addr\n");
+			continue;
+		}
+
+		/* skip already registered PHYs */
+		if (mdiobus_is_registered_device(bus, addr)) {
+			dev_err(dev, "device is already registred \n");
+			continue;
+		}
+
+		phy = phy_device_create(bus, addr, PHY_ID_TJA1102,
+						false, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "Can't register Port : %i\n", addr);
+			continue;
+		}
+
+		ret = of_irq_get(child, 0);
+		/* can we be deferred here? */
+		if (ret > 0) {
+			phy->irq = ret;
+			bus->irq[addr] = ret;
+		} else {
+			phy->irq = bus->irq[addr];
+		}
+
+		/* overwrite parent phy_device_create() set parent to the
+		 * mii_bus->dev
+		 */
+		phy->mdio.dev.parent = dev;
+
+		/* Associate the OF node with the device structure so it
+		 * can be looked up later */
+		of_node_get(child);
+		phy->mdio.dev.of_node = child;
+		phy->mdio.dev.fwnode = of_fwnode_handle(child);
+
+		/* All data is now stored in the phy struct;
+		 * register it */
+		ret = phy_device_register(phy);
+		if (ret) {
+			phy_device_free(phy);
+			of_node_put(child);
+		}
+	}
+}
+
+static int tja1102_p0_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct tja11xx_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->phydev = phydev;
+	INIT_WORK(&priv->phy_register_work, tja1102_p1_register);
+
+	ret = tja11xx_hwmon_register(phydev, priv);
+	if (ret)
+		return ret;
+
+	schedule_work(&priv->phy_register_work);
+
+	return 0;
+}
+
 static int tja1102_match_phy_device(struct phy_device *phydev, bool port0)
 {
 	int ret;
@@ -454,7 +556,7 @@ static struct phy_driver tja11xx_driver[] = {
 	}, {
 		.name		= "NXP TJA1102 Port 0",
 		.features       = PHY_BASIC_T1_FEATURES,
-		.probe		= tja11xx_probe,
+		.probe		= tja1102_p0_probe,
 		.soft_reset	= tja11xx_soft_reset,
 		.config_init	= tja11xx_config_init,
 		.read_status	= tja11xx_read_status,
-- 
2.25.1

