Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D222AE79
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGWL4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:56:30 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33886 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWL42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505387; x=1627041387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c9cf+yqkxJFtCdCghMbFfcDHmBUoTBqFsVimgFHWM+8=;
  b=dcbRRUS4/5hkk2Et3ISgyfb6ixJTO4YV2ncx85kIwCx36sAKhBmepTQm
   hXBO9uNmyz4zPeW36NtU+krZ1Dj7d5ekUGm6m89JVhjwm917A0zQ2f93G
   sVS2pSqyKQdEIHJYdwzc812JwIh74RGJqKvAyRosdpgmSKuzsVwTuHU3/
   sIX8Dxwca6f0V3IDoy0wq7yM+Cxgz/8JdwC5Qmw+lZajU/8k006m7JECR
   Wmptq4KpZM8wIcbBIkGMbzsRWWluaWDO8D5USYWmsv+lvIP5XQALI1yDB
   oUX8U/erTrLWwbdhUgOPw43C1003WQ0tr6BXQmBXj2Pz+Xbt8ge00IGum
   Q==;
IronPort-SDR: DnzKIYHj5hPdUeLnEaEN8KnaTNe0v6PIzhNBEQ0Za5eqTdoRKQ07htlYdFt/QxISPihZlf9ibo
 0zRq2k/pknAKBeiTC/auZ2UGjDLnSgQA87HWnwg0jPFS+Jl6OhI+2t76Og89n5G+hAxv2jIgs/
 ztXsP0MPlDWv1cJYZbxP9NMzd51NPJNd73GLepx3DlT+Wul3yqBkunSdZMKWi9AzQjNQj8264E
 xNgFVgbX06Ux5CQykBL8rPIv80gxvIKtK1EBdrozmmlBNea6iV2BmpYNnFEULhlzicm2UrcCyP
 93Y=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="20277508"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:56:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:55:45 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:55:44 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 5/6] smsc95xx: use PAL framework read/write functions
Date:   Thu, 23 Jul 2020 13:55:06 +0200
Message-ID: <20200723115507.26194-6-andre.edich@microchip.com>
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

Use functions phy_read and phy_write instead of smsc95xx_mdio_read and
smsc95xx_mdio_write respectively.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 43 +++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 8731724bf2c5..8add7109e661 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -582,22 +582,20 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 
 	if (pdata->internal_phy) {
 		/* clear interrupt status */
-		ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
+		ret = phy_read(pdata->phydev, PHY_INT_SRC);
 		if (ret < 0)
 			return ret;
 
-		smsc95xx_mdio_write(dev->net, mii->phy_id, PHY_INT_MASK,
-				    PHY_INT_MASK_DEFAULT_);
+		ret = phy_write(pdata->phydev, PHY_INT_MASK,
+				PHY_INT_MASK_DEFAULT_);
+		if (ret < 0)
+			return ret;
 	}
 
 	mii_check_media(mii, 1, 1);
 	mii_ethtool_gset(&dev->mii, &ecmd);
-	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
-	rmtadv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_LPA);
-
-	netif_dbg(dev, link, dev->net,
-		  "speed: %u duplex: %d lcladv: %04x rmtadv: %04x\n",
-		  ethtool_cmd_speed(&ecmd), ecmd.duplex, lcladv, rmtadv);
+	lcladv = phy_read(pdata->phydev, MII_ADVERTISE);
+	rmtadv = phy_read(pdata->phydev, MII_LPA);
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
 	if (ecmd.duplex != DUPLEX_FULL) {
@@ -761,10 +759,11 @@ static int smsc95xx_ethtool_set_wol(struct net_device *net,
 static int get_mdix_status(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int buf;
 
-	buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, SPECIAL_CTRL_STS);
+	buf = phy_read(pdata->phydev, SPECIAL_CTRL_STS);
 	if (buf & SPECIAL_CTRL_STS_OVRRD_AMDIX_) {
 		if (buf & SPECIAL_CTRL_STS_AMDIX_ENABLE_)
 			return ETH_TP_MDI_AUTO;
@@ -790,39 +789,31 @@ static void set_mdix_status(struct net_device *net, __u8 mdix_ctrl)
 	    (pdata->chip_id == ID_REV_CHIP_ID_89530_) ||
 	    (pdata->chip_id == ID_REV_CHIP_ID_9730_)) {
 		/* Extend Manual AutoMDIX timer for 9500A/9500Ai */
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 PHY_EDPD_CONFIG);
+		buf = phy_read(pdata->phydev, PHY_EDPD_CONFIG);
 		buf |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    PHY_EDPD_CONFIG, buf);
+		phy_write(pdata->phydev, PHY_EDPD_CONFIG, buf);
 	}
 
 	if (mdix_ctrl == ETH_TP_MDI) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
+		buf = phy_read(pdata->phydev, SPECIAL_CTRL_STS);
 		buf |= SPECIAL_CTRL_STS_OVRRD_AMDIX_;
 		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
 			 SPECIAL_CTRL_STS_AMDIX_STATE_);
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
+		phy_write(pdata->phydev, SPECIAL_CTRL_STS, buf);
 	} else if (mdix_ctrl == ETH_TP_MDI_X) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
+		buf = phy_read(pdata->phydev, SPECIAL_CTRL_STS);
 		buf |= SPECIAL_CTRL_STS_OVRRD_AMDIX_;
 		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
 			 SPECIAL_CTRL_STS_AMDIX_STATE_);
 		buf |= SPECIAL_CTRL_STS_AMDIX_STATE_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
+		phy_write(pdata->phydev, SPECIAL_CTRL_STS, buf);
 	} else if (mdix_ctrl == ETH_TP_MDI_AUTO) {
-		buf = smsc95xx_mdio_read(dev->net, dev->mii.phy_id,
-					 SPECIAL_CTRL_STS);
+		buf = phy_read(pdata->phydev, SPECIAL_CTRL_STS);
 		buf &= ~SPECIAL_CTRL_STS_OVRRD_AMDIX_;
 		buf &= ~(SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
 			 SPECIAL_CTRL_STS_AMDIX_STATE_);
 		buf |= SPECIAL_CTRL_STS_AMDIX_ENABLE_;
-		smsc95xx_mdio_write(dev->net, dev->mii.phy_id,
-				    SPECIAL_CTRL_STS, buf);
+		phy_write(pdata->phydev, SPECIAL_CTRL_STS, buf);
 	}
 	pdata->mdix_ctrl = mdix_ctrl;
 }
-- 
2.27.0

