Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907B51461CD
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgAWGIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:08:37 -0500
Received: from foss.arm.com ([217.140.110.172]:35366 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgAWGIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:08:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CF381FB;
        Wed, 22 Jan 2020 22:08:35 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7AD173F68E;
        Wed, 22 Jan 2020 22:08:35 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 1/2] net: bcmgenet: Initial bcmgenet ACPI support
Date:   Thu, 23 Jan 2020 00:08:22 -0600
Message-Id: <20200123060823.1902366-2-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123060823.1902366-1-jeremy.linton@arm.com>
References: <20200123060823.1902366-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rpi4 is capable of booting in ACPI mode with the latest
edk2-platform commits. As such, it would be helpful if the genet
platform device were usable.

To achive this we convert some of the of_ calls to device_ and
add the ACPI id module table, and tweak the phy connection code
to use phy_connect() in the ACPI path.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 +++--
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 76 ++++++++++++-------
 2 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 120fa05a39ff..c736700f829e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
 
+#include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -3476,7 +3477,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
-	const void *macaddr;
+	const void *macaddr = NULL;
 	unsigned int i;
 	int err = -EIO;
 	const char *phy_mode_str;
@@ -3510,7 +3511,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	if (dn)
 		macaddr = of_get_mac_address(dn);
-	else
+	else if (pd)
 		macaddr = pd->mac_address;
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
@@ -3555,8 +3556,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->dev = dev;
 	priv->pdev = pdev;
-	if (of_id) {
-		pdata = of_id->data;
+
+	pdata = device_get_match_data(&pdev->dev);
+	if (pdata) {
 		priv->version = pdata->version;
 		priv->dma_max_burst_length = pdata->dma_max_burst_length;
 	} else {
@@ -3595,7 +3597,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	/* If this is an internal GPHY, power it on now, before UniMAC is
 	 * brought out of reset as absolutely no UniMAC activity is allowed
 	 */
-	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
+	if (!device_property_read_string(&pdev->dev, "phy-mode", &phy_mode_str) &&
 	    !strcasecmp(phy_mode_str, "internal"))
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
@@ -3768,6 +3770,12 @@ static int bcmgenet_suspend(struct device *d)
 
 static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
 
+static const struct acpi_device_id genet_acpi_match[] = {
+	{ "BCM6E4E", (kernel_ulong_t)&bcm2711_plat_data },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, genet_acpi_match);
+
 static struct platform_driver bcmgenet_driver = {
 	.probe	= bcmgenet_probe,
 	.remove	= bcmgenet_remove,
@@ -3776,6 +3784,7 @@ static struct platform_driver bcmgenet_driver = {
 		.name	= "bcmgenet",
 		.of_match_table = bcmgenet_match,
 		.pm	= &bcmgenet_pm_ops,
+		.acpi_match_table = ACPI_PTR(genet_acpi_match),
 	},
 };
 module_platform_driver(bcmgenet_driver);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6392a2530183..054be1eaa1ae 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2014-2017 Broadcom
  */
 
-
+#include <linux/acpi.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
@@ -308,10 +308,21 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	return 0;
 }
 
+static void bcmgenet_phy_name(char *phy_name, int mdid, int phid)
+{
+	char mdio_bus_id[MII_BUS_ID_SIZE];
+
+	snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
+		 UNIMAC_MDIO_DRV_NAME, mdid);
+	snprintf(phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT, mdio_bus_id, phid);
+}
+
 int bcmgenet_mii_probe(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct device_node *dn = priv->pdev->dev.of_node;
+	struct device *kdev = &priv->pdev->dev;
+	struct device_node *dn = kdev->of_node;
+
 	struct phy_device *phydev;
 	u32 phy_flags = 0;
 	int ret;
@@ -333,6 +344,16 @@ int bcmgenet_mii_probe(struct net_device *dev)
 			pr_err("could not attach to PHY\n");
 			return -ENODEV;
 		}
+	} else if (has_acpi_companion(kdev)) {
+		char phy_name[MII_BUS_ID_SIZE + 3];
+
+		bcmgenet_phy_name(phy_name,  priv->pdev->id, 1);
+		phydev = phy_connect(dev, phy_name, bcmgenet_mii_setup,
+				     priv->phy_interface);
+		if (!IS_ERR(phydev))
+			phydev->dev_flags = phy_flags;
+		else
+			return -ENODEV;
 	} else {
 		phydev = dev->phydev;
 		phydev->dev_flags = phy_flags;
@@ -435,6 +456,7 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	ppd.wait_func = bcmgenet_mii_wait;
 	ppd.wait_func_data = priv;
 	ppd.bus_name = "bcmgenet MII bus";
+	ppd.phy_mask = ~0;
 
 	/* Unimac MDIO bus controller starts at UniMAC offset + MDIO_CMD
 	 * and is 2 * 32-bits word long, 8 bytes total.
@@ -477,12 +499,28 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	return ret;
 }
 
+static int bcmgenet_mii_phy_init(struct bcmgenet_priv *priv)
+{
+	struct device *kdev = &priv->pdev->dev;
+
+	priv->phy_interface = device_get_phy_mode(kdev);
+	if (priv->phy_interface < 0)
+		priv->phy_interface = PHY_INTERFACE_MODE_RGMII;
+
+	/* We need to specifically look up whether this PHY interface is internal
+	 * or not *before* we even try to probe the PHY driver over MDIO as we
+	 * may have shut down the internal PHY for power saving purposes.
+	 */
+	if (priv->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
+		priv->internal_phy = true;
+
+	return 0;
+}
+
 static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 {
 	struct device_node *dn = priv->pdev->dev.of_node;
-	struct device *kdev = &priv->pdev->dev;
 	struct phy_device *phydev;
-	phy_interface_t phy_mode;
 	int ret;
 
 	/* Fetch the PHY phandle */
@@ -500,23 +538,10 @@ static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 	}
 
 	/* Get the link mode */
-	ret = of_get_phy_mode(dn, &phy_mode);
-	if (ret) {
-		dev_err(kdev, "invalid PHY mode property\n");
-		return ret;
-	}
-
-	priv->phy_interface = phy_mode;
-
-	/* We need to specifically look up whether this PHY interface is internal
-	 * or not *before* we even try to probe the PHY driver over MDIO as we
-	 * may have shut down the internal PHY for power saving purposes.
-	 */
-	if (priv->phy_interface == PHY_INTERFACE_MODE_INTERNAL)
-		priv->internal_phy = true;
+	bcmgenet_mii_phy_init(priv);
 
 	/* Make sure we initialize MoCA PHYs with a link down */
-	if (phy_mode == PHY_INTERFACE_MODE_MOCA) {
+	if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
 		phydev = of_phy_find_device(dn);
 		if (phydev) {
 			phydev->link = 0;
@@ -532,16 +557,10 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 	struct device *kdev = &priv->pdev->dev;
 	struct bcmgenet_platform_data *pd = kdev->platform_data;
 	char phy_name[MII_BUS_ID_SIZE + 3];
-	char mdio_bus_id[MII_BUS_ID_SIZE];
 	struct phy_device *phydev;
 
-	snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
-		 UNIMAC_MDIO_DRV_NAME, priv->pdev->id);
-
 	if (pd->phy_interface != PHY_INTERFACE_MODE_MOCA && pd->mdio_enabled) {
-		snprintf(phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT,
-			 mdio_bus_id, pd->phy_address);
-
+		bcmgenet_phy_name(phy_name,  priv->pdev->id, pd->phy_address);
 		/*
 		 * Internal or external PHY with MDIO access
 		 */
@@ -581,10 +600,13 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 
 static int bcmgenet_mii_bus_init(struct bcmgenet_priv *priv)
 {
-	struct device_node *dn = priv->pdev->dev.of_node;
+	struct device *kdev = &priv->pdev->dev;
+	struct device_node *dn = kdev->of_node;
 
 	if (dn)
 		return bcmgenet_mii_of_init(priv);
+	else if (has_acpi_companion(kdev))
+		return bcmgenet_mii_phy_init(priv);
 	else
 		return bcmgenet_mii_pd_init(priv);
 }
-- 
2.24.1

