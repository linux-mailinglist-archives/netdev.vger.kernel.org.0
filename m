Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CD12BBAB
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfE0VWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:22:50 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50740 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfE0VWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:49 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F1333200C5D;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E44DD200C5B;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 64A952061C;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH 01/11] net: phy: Add phy_sysfs_create_links helper function
Date:   Tue, 28 May 2019 00:21:57 +0300
Message-Id: <1558992127-26008-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

This is a cosmetic patch that wraps the operation of creating sysfs
links between the netdev->phydev and the phydev->attached_dev.

This is needed to keep the indentation level in check in a follow-up
patch where this function will be guarded against the existence of a
phydev->attached_dev.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 43 ++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d288da9a3b0..8fd1bf37718b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1133,6 +1133,31 @@ void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 }
 EXPORT_SYMBOL(phy_attached_print);
 
+static void phy_sysfs_create_links(struct phy_device *phydev)
+{
+	struct net_device *dev = phydev->attached_dev;
+	int err;
+
+	err = sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
+				"attached_dev");
+	if (err)
+		return;
+
+	err = sysfs_create_link_nowarn(&dev->dev.kobj,
+				       &phydev->mdio.dev.kobj,
+				       "phydev");
+	if (err) {
+		dev_err(&dev->dev, "could not add device link to %s err %d\n",
+			kobject_name(&phydev->mdio.dev.kobj),
+			err);
+		/* non-fatal - some net drivers can use one netdevice
+		 * with more then one phy
+		 */
+	}
+
+	phydev->sysfs_links = true;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1216,23 +1241,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	 */
 	phydev->sysfs_links = false;
 
-	err = sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
-				"attached_dev");
-	if (!err) {
-		err = sysfs_create_link_nowarn(&dev->dev.kobj,
-					       &phydev->mdio.dev.kobj,
-					       "phydev");
-		if (err) {
-			dev_err(&dev->dev, "could not add device link to %s err %d\n",
-				kobject_name(&phydev->mdio.dev.kobj),
-				err);
-			/* non-fatal - some net drivers can use one netdevice
-			 * with more then one phy
-			 */
-		}
-
-		phydev->sysfs_links = true;
-	}
+	phy_sysfs_create_links(phydev);
 
 	phydev->dev_flags = flags;
 
-- 
2.21.0

