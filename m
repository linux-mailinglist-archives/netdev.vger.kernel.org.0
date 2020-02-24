Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C316B4A0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBXWyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:13 -0500
Received: from foss.arm.com ([217.140.110.172]:43892 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgBXWyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 185521063;
        Mon, 24 Feb 2020 14:54:12 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0780B3F534;
        Mon, 24 Feb 2020 14:54:12 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v2 3/6] net: bcmgenet: enable automatic phy discovery
Date:   Mon, 24 Feb 2020 16:54:00 -0600
Message-Id: <20200224225403.1650656-4-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224225403.1650656-1-jeremy.linton@arm.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The unimac mdio driver falls back to scanning the
entire bus if its given an appropriate mask. In ACPI
mode we expect that the system is well behaved and
conforms to recent versions of the specification.

We then utilize phy_find_first(), and
phy_connect_direct() to find and attach to the
discovered phy during net_device open. While its
apparently possible to build a genet based device
with multiple phys on a single mdio bus, this works
for current machines. Further, this driver makes
a number of assumptions about the platform device,
mac, mdio and phy all being 1:1. Lastly, It also
avoids having to create references across the ACPI
namespace hierarchy.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 39 +++++++++++++++++---
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index e7a1bf8ed36f..678545e580d4 100644
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
@@ -311,7 +311,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 int bcmgenet_mii_probe(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct device_node *dn = priv->pdev->dev.of_node;
+	struct device *kdev = &priv->pdev->dev;
+	struct device_node *dn = kdev->of_node;
 	struct phy_device *phydev;
 	u32 phy_flags = 0;
 	int ret;
@@ -334,7 +335,27 @@ int bcmgenet_mii_probe(struct net_device *dev)
 			return -ENODEV;
 		}
 	} else {
-		phydev = dev->phydev;
+		if (has_acpi_companion(kdev)) {
+			char mdio_bus_id[MII_BUS_ID_SIZE];
+			struct mii_bus *unimacbus;
+
+			snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
+				 UNIMAC_MDIO_DRV_NAME, priv->pdev->id);
+
+			unimacbus = mdio_find_bus(mdio_bus_id);
+			if (!unimacbus) {
+				pr_err("Unable to find mii\n");
+				return -ENODEV;
+			}
+			phydev = phy_find_first(unimacbus);
+			put_device(&unimacbus->dev);
+			if (!phydev) {
+				pr_err("Unable to find PHY\n");
+				return -ENODEV;
+			}
+		} else {
+			phydev = dev->phydev;
+		}
 		phydev->dev_flags = phy_flags;
 
 		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
@@ -455,9 +476,12 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	/* Retain this platform_device pointer for later cleanup */
 	priv->mii_pdev = ppdev;
 	ppdev->dev.parent = &pdev->dev;
-	ppdev->dev.of_node = bcmgenet_mii_of_find_mdio(priv);
-	if (pdata)
+	if (dn)
+		ppdev->dev.of_node = bcmgenet_mii_of_find_mdio(priv);
+	else if (pdata)
 		bcmgenet_mii_pdata_init(priv, &ppd);
+	else
+		ppd.phy_mask = ~0;
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)
@@ -591,10 +615,13 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 
 static int bcmgenet_mii_bus_init(struct bcmgenet_priv *priv)
 {
-	struct device_node *dn = priv->pdev->dev.of_node;
+	struct device *kdev = &priv->pdev->dev;
+	struct device_node *dn = kdev->of_node;
 
 	if (dn)
 		return bcmgenet_mii_of_init(priv);
+	else if (has_acpi_companion(kdev))
+		return bcmgenet_phy_interface_init(priv);
 	else
 		return bcmgenet_mii_pd_init(priv);
 }
-- 
2.24.1

