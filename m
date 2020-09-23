Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB60275C30
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIWPll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:41:41 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51260 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIWPlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 11:41:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B38681A05BF;
        Wed, 23 Sep 2020 17:41:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A3D701A019E;
        Wed, 23 Sep 2020 17:41:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EF1E2033F;
        Wed, 23 Sep 2020 17:41:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/3] of: add of_mdio_find_device() api
Date:   Wed, 23 Sep 2020 18:41:22 +0300
Message-Id: <20200923154123.636-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923154123.636-1-ioana.ciornei@nxp.com>
References: <20200923154123.636-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Add a helper function which finds the mdio_device structure given a
device tree node. This is helpful for finding the PCS device based on a
DTS node but managing it as a mdio_device instead of a phy_device.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/of/of_mdio.c    | 38 +++++++++++++++++++++++++++++---------
 include/linux/of_mdio.h |  6 ++++++
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index cb32d7ef4938..4daf94bb56a5 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -337,6 +337,29 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 }
 EXPORT_SYMBOL(of_mdiobus_register);
 
+/**
+ * of_mdio_find_device - Given a device tree node, find the mdio_device
+ * @np: pointer to the mdio_device's device tree node
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use
+ */
+struct mdio_device *of_mdio_find_device(struct device_node *np)
+{
+	struct device *d;
+
+	if (!np)
+		return NULL;
+
+	d = bus_find_device_by_of_node(&mdio_bus_type, np);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(of_mdio_find_device);
+
 /**
  * of_phy_find_device - Give a PHY node, find the phy_device
  * @phy_np: Pointer to the phy's device tree node
@@ -346,19 +369,16 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct device *d;
 	struct mdio_device *mdiodev;
 
-	if (!phy_np)
+	mdiodev = of_mdio_find_device(phy_np);
+	if (!mdiodev)
 		return NULL;
 
-	d = bus_find_device_by_of_node(&mdio_bus_type, phy_np);
-	if (d) {
-		mdiodev = to_mdio_device(d);
-		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-			return to_phy_device(d);
-		put_device(d);
-	}
+	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+		return to_phy_device(&mdiodev->dev);
+
+	put_device(&mdiodev->dev);
 
 	return NULL;
 }
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 1efb88d9f892..cfe8c607a628 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -17,6 +17,7 @@ bool of_mdiobus_child_is_phy(struct device_node *child);
 int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
 int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 			     struct device_node *np);
+struct mdio_device *of_mdio_find_device(struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
 of_phy_connect(struct net_device *dev, struct device_node *phy_np,
@@ -74,6 +75,11 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
 	return mdiobus_register(mdio);
 }
 
+static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
+{
+	return NULL;
+}
+
 static inline struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
 	return NULL;
-- 
2.25.1

