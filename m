Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74537182920
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbgCLGep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:34:45 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57023 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387954AbgCLGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:34:35 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCHQF-0006xQ-M4; Thu, 12 Mar 2020 07:34:23 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jCHQE-0006AV-DP; Thu, 12 Mar 2020 07:34:22 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 4/4] net: phy: tja11xx: add delayed registration of TJA1102 PHY1
Date:   Thu, 12 Mar 2020 07:34:19 +0100
Message-Id: <20200312063419.23615-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200312063419.23615-1-o.rempel@pengutronix.de>
References: <20200312063419.23615-1-o.rempel@pengutronix.de>
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
 drivers/net/phy/nxp-tja11xx.c | 112 +++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index a064e4ab3616..2bde9386baf1 100644
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
@@ -360,6 +361,103 @@ static int tja11xx_probe(struct phy_device *phydev)
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
+	struct phy_device *phydev_phy0 = priv->phydev;
+	struct mii_bus *bus = phydev_phy0->mdio.bus;
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
+		} else if (addr != phydev_phy0->mdio.addr + 1) {
+			/* Currently we care only about double PHY chip TJA1102.
+			 * If some day NXP will decide to bring chips with more
+			 * PHYs, this logic should be reworked.
+			 */
+			dev_err(dev, "Unexpected address. Should be: %i\n",
+				phydev_phy0->mdio.addr + 1);
+			continue;
+		}
+
+		if (mdiobus_is_registered_device(bus, addr)) {
+			dev_err(dev, "device is already registered\n");
+			continue;
+		}
+
+		/* Real PHY ID of Port 1 is 0 */
+		phy = phy_device_create(bus, addr, PHY_ID_TJA1102, false, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "Can't create PHY device for Port 1: %i\n",
+				addr);
+			continue;
+		}
+
+		/* Overwrite parent device. phy_device_create() set parent to
+		 * the mii_bus->dev, which is not correct in case.
+		 */
+		phy->mdio.dev.parent = dev;
+
+		ret = __of_mdiobus_register_phy(bus, phy, child, addr);
+		if (ret) {
+			/* All resources needed for Port 1 should be already
+			 * available for Port 0. Both ports use the same
+			 * interrupt line, so -EPROBE_DEFER would make no sense
+			 * here.
+			 */
+			dev_err(dev, "Can't register Port 1. Unexpected error: %i\n",
+				ret);
+			phy_device_free(phy);
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
@@ -443,7 +541,7 @@ static struct phy_driver tja11xx_driver[] = {
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

