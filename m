Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353132CDC9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfE1Rkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:40:55 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42998 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfE1Rkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:40:52 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9CBF2200FDD;
        Tue, 28 May 2019 19:40:49 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9A5B8200F77;
        Tue, 28 May 2019 19:40:49 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1954B205F4;
        Tue, 28 May 2019 19:40:49 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 04/11] net: phy: Add phy_standalone sysfs entry
Date:   Tue, 28 May 2019 20:38:10 +0300
Message-Id: <1559065097-31832-5-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export a phy_standalone device attribute that is meant to give the
indication that this PHY lacks an attached_dev and its corresponding
sysfs link. The attribute will be created only when the
phy_attach_direct() function will be called with a NULL net_device.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
 - add new entry in Documentation/ABI/testing/sysfs-class-net-phydev

 Documentation/ABI/testing/sysfs-class-net-phydev |  8 ++++++++
 drivers/net/phy/phy_device.c                     | 22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index 6ebabfb27912..b7c46c2f3fd0 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -34,3 +34,11 @@ Description:
 		xgmii, moca, qsgmii, trgmii, 1000base-x, 2500base-x, rxaui,
 		xaui, 10gbase-kr, unknown
 
+What:		/sys/class/mdio_bus/<bus>/<device>/phy_standalone
+Date:		May 2019
+KernelVersion:	5.3
+Contact:	netdev@vger.kernel.org
+Description:
+		Boolean value indicating whether the PHY device is used in
+		standalone mode, without a net_device associated, by PHYLINK.
+		Attribute created only when this is the case.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b540ed9b326..8b4fc3b4f269 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1164,6 +1164,16 @@ static void phy_sysfs_create_links(struct phy_device *phydev)
 	phydev->sysfs_links = true;
 }
 
+static ssize_t
+phy_standalone_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+
+	return sprintf(buf, "%d\n", !phydev->attached_dev);
+}
+static DEVICE_ATTR_RO(phy_standalone);
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1253,6 +1263,13 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phy_sysfs_create_links(phydev);
 
+	if (!phydev->attached_dev) {
+		err = sysfs_create_file(&phydev->mdio.dev.kobj,
+					&dev_attr_phy_standalone.attr);
+		if (err)
+			phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
+	}
+
 	phydev->dev_flags = flags;
 
 	phydev->interface = interface;
@@ -1380,6 +1397,11 @@ void phy_detach(struct phy_device *phydev)
 			sysfs_remove_link(&dev->dev.kobj, "phydev");
 		sysfs_remove_link(&phydev->mdio.dev.kobj, "attached_dev");
 	}
+
+	if (!phydev->attached_dev)
+		sysfs_remove_file(&phydev->mdio.dev.kobj,
+				  &dev_attr_phy_standalone.attr);
+
 	phy_suspend(phydev);
 	if (dev) {
 		phydev->attached_dev->phydev = NULL;
-- 
1.9.1

