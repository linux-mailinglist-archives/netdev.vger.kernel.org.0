Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D81A22AE7A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgGWL4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:56:37 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50760 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWL4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505395; x=1627041395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aO0aYQwUSovmbXLoGxRCLOv6fo8TyIugmImIYPwwfWU=;
  b=NchX+S25L96Xt5ISMbZ4/HmYbn8hR5MJp3fUs3gJDp0RBJHCLy0kWfFb
   PmpVHvyYfE1N22gSoEdaF7yrTUs2RToZ8y6D0pbFm2ul/XUJkjlK4VTUe
   kXabcAfaTPpw1gIq0F2ASvGS24VEw10cZnLEIhg7QafpW4041icudcG83
   QuoA/0aWBWOMpyFCstv0J8d1xTA+Zev5XgfWDkN/E6wlwHhNIyucfhbOu
   y1kp0N5VG0rNcuUNqrXaT8yGapMUQpAV6DylIFrxJBjtGxU7EWkoOEhYw
   J5XSDFd8hL8UphaPNnA2uAh5tDEwEaebEzQnJL1LEcNm/tCORl//ayowJ
   g==;
IronPort-SDR: KlqN0TrhcKzasNUIXCUzEh9KkY9OzUqF66SEO3MaGa9HDX+yuKGvo3Ixtbfu6O5UJTWnSnWHiY
 hMtZRTbr8J/3E6afAlgAsv2doQZit63hizdn4jc98BpzHyldZ7jfoA0BBCE1DgtRjaaew1EfGM
 OtkKVX9lo/EoEkPkpX+mOSK2KRtSe9gBLU86zxc9hhTwx76TkVsZeVRDoHYgH+LBJPUTIdu7b8
 DkMidwazRXIOyglxriwi+SbI3GXjBgeviejBEQVRGFHTJ2TdOIa5aVXXH0yJuIgsjvIitHCt8Y
 V9U=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="81033874"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:56:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:56:35 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:55:52 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 6/6] smsc95xx: use PHY framework instead of MII library
Date:   Thu, 23 Jul 2020 13:55:07 +0200
Message-ID: <20200723115507.26194-7-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723115507.26194-1-andre.edich@microchip.com>
References: <20200723115507.26194-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the PHY framework is used anyway, replace the rest of the calls to
the MII library, including those from the USB Network driver
infrastructure, by the calls to the PHY framework.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 78 +++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 8add7109e661..7de20c0aad36 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -174,10 +174,14 @@ static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
 	return -EIO;
 }
 
-static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
+static u32 mii_address(u16 op, int phy_id, int idx)
+{
+	return (phy_id & 0x1f) << 11 | (idx & 0x1f) << 6 | op | MII_BUSY_;
+}
+
+static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 				int in_pm)
 {
-	struct usbnet *dev = netdev_priv(netdev);
 	u32 val, addr;
 	int ret;
 
@@ -191,9 +195,7 @@ static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
 	}
 
 	/* set the address, index & direction (read from PHY) */
-	phy_id &= dev->mii.phy_id_mask;
-	idx &= dev->mii.reg_num_mask;
-	addr = (phy_id << 11) | (idx << 6) | MII_READ_ | MII_BUSY_;
+	addr = mii_address(MII_READ_, phy_id, idx);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Error writing MII_ADDR\n");
@@ -219,10 +221,9 @@ static int __smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx,
 	return ret;
 }
 
-static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
+static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 				  int idx, int regval, int in_pm)
 {
-	struct usbnet *dev = netdev_priv(netdev);
 	u32 val, addr;
 	int ret;
 
@@ -243,9 +244,7 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 	}
 
 	/* set the address, index & direction (write to PHY) */
-	phy_id &= dev->mii.phy_id_mask;
-	idx &= dev->mii.reg_num_mask;
-	addr = (phy_id << 11) | (idx << 6) | MII_WRITE_ | MII_BUSY_;
+	addr = mii_address(MII_WRITE_, phy_id, idx);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Error writing MII_ADDR\n");
@@ -264,34 +263,23 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 
 static int smsc95xx_mdio_read_nopm(struct usbnet *dev, int idx)
 {
-	struct mii_if_info *mii = &dev->mii;
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-	return __smsc95xx_mdio_read(dev->net, mii->phy_id, idx, 1);
+	return __smsc95xx_mdio_read(dev, pdata->phydev->mdio.addr, idx, 1);
 }
 
 static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
 {
-	struct mii_if_info *mii = &dev->mii;
-
-	__smsc95xx_mdio_write(dev->net, mii->phy_id, idx, regval, 1);
-}
-
-static int smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx)
-{
-	return __smsc95xx_mdio_read(netdev, phy_id, idx, 0);
-}
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-static void smsc95xx_mdio_write(struct net_device *netdev, int phy_id, int idx,
-				int regval)
-{
-	__smsc95xx_mdio_write(netdev, phy_id, idx, regval, 0);
+	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
 }
 
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
 
-	return __smsc95xx_mdio_read(dev->net, phy_id, idx, 0);
+	return __smsc95xx_mdio_read(dev, phy_id, idx, 0);
 }
 
 static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
@@ -299,7 +287,7 @@ static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
 {
 	struct usbnet *dev = bus->priv;
 
-	__smsc95xx_mdio_write(dev->net, phy_id, idx, regval, 0);
+	__smsc95xx_mdio_write(dev, phy_id, idx, regval, 0);
 	return 0;
 }
 
@@ -570,8 +558,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
 static int smsc95xx_link_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	struct mii_if_info *mii = &dev->mii;
-	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
+	struct ethtool_link_ksettings cmd;
 	unsigned long flags;
 	u16 lcladv, rmtadv;
 	int ret;
@@ -592,13 +579,12 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 			return ret;
 	}
 
-	mii_check_media(mii, 1, 1);
-	mii_ethtool_gset(&dev->mii, &ecmd);
+	phy_ethtool_ksettings_get(pdata->phydev, &cmd);
 	lcladv = phy_read(pdata->phydev, MII_ADVERTISE);
 	rmtadv = phy_read(pdata->phydev, MII_LPA);
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
-	if (ecmd.duplex != DUPLEX_FULL) {
+	if (cmd.base.duplex != DUPLEX_FULL) {
 		pdata->mac_cr &= ~MAC_CR_FDPX_;
 		pdata->mac_cr |= MAC_CR_RCVOWN_;
 	} else {
@@ -611,7 +597,8 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = smsc95xx_phy_update_flowcontrol(dev, ecmd.duplex, lcladv, rmtadv);
+	ret = smsc95xx_phy_update_flowcontrol(dev, cmd.base.duplex, lcladv,
+					      rmtadv);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error updating PHY flow control\n");
 
@@ -825,7 +812,7 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
-	retval = usbnet_get_link_ksettings(net, cmd);
+	retval = phy_ethtool_get_link_ksettings(net, cmd);
 	if (pdata->internal_phy) {
 		cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
 		cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
@@ -842,13 +829,18 @@ static int smsc95xx_set_link_ksettings(struct net_device *net,
 
 	if (pdata->mdix_ctrl != mdix_ctrl && pdata->internal_phy)
 		set_mdix_status(net, mdix_ctrl);
+	return phy_ethtool_set_link_ksettings(net, cmd);
+}
 
-	return usbnet_set_link_ksettings(net, cmd);
+static u32 smsc95xx_get_link(struct net_device *net)
+{
+	phy_read_status(net->phydev);
+	return net->phydev->link;
 }
 
 static const struct ethtool_ops smsc95xx_ethtool_ops = {
-	.get_link	= usbnet_get_link,
-	.nway_reset	= usbnet_nway_reset,
+	.get_link	= smsc95xx_get_link,
+	.nway_reset	= phy_ethtool_nway_reset,
 	.get_drvinfo	= usbnet_get_drvinfo,
 	.get_msglevel	= usbnet_get_msglevel,
 	.set_msglevel	= usbnet_set_msglevel,
@@ -866,12 +858,10 @@ static const struct ethtool_ops smsc95xx_ethtool_ops = {
 
 static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 {
-	struct usbnet *dev = netdev_priv(netdev);
-
 	if (!netif_running(netdev))
 		return -EINVAL;
 
-	return generic_mii_ioctl(&dev->mii, if_mii(rq), cmd, NULL);
+	return phy_mii_ioctl(netdev->phydev, rq, cmd);
 }
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
@@ -1233,9 +1223,6 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	pdata->mdiobus->name = "smsc95xx-mdiobus";
 	pdata->mdiobus->parent = &dev->udev->dev;
 
-	dev->mii.phy_id_mask = 0x1f;
-	dev->mii.reg_num_mask = 0x1f;
-
 	snprintf(pdata->mdiobus->id, ARRAY_SIZE(pdata->mdiobus->id),
 		 "usb-%03d:%03d", dev->udev->bus->busnum, dev->udev->devnum);
 
@@ -1252,11 +1239,6 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto unregister_mdio;
 	}
 
-	dev->mii.dev = dev->net;
-	dev->mii.mdio_read = smsc95xx_mdio_read;
-	dev->mii.mdio_write = smsc95xx_mdio_write;
-	dev->mii.phy_id = pdata->phydev->mdio.addr;
-
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
 	if (ret < 0)
-- 
2.27.0

