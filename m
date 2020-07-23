Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBAD22AE78
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgGWL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:56:22 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33873 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWL4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505381; x=1627041381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s1uSIGqlOXYzswhFV7D2Fhg5Ku0q68435WJVN+7LHQ8=;
  b=Rwp4gz9vNdFAkY9+IqrZRdP5rHCE7La6GaSrJoHkmE2QkD/O5PoGLL+N
   rZaZoqVWbYkS4r5lnVgWzhKa5rxNjsdXiKRSHNdUPxqZU8wIBkv+W6gbN
   7NM0v2RbbKxE7smWg/fU00LB4/p0PYroFyZQ6yD35IQFrA37rhR453TMN
   6ps+W3fUw0y3mbBmfj/Z4sncxxF76PBC2PRwRw9WAbrm5xkZhXKmPi61y
   cyV8P5Er7pOzN3gI/GZVmVrvIK3z4XnDNFlIznmtloKxrH2di/4muSbMX
   QsRTnCCKOigdNyyeCf6otVxkf3EHoh6c5N9WwkpVmylLnOyqKbYQvoU4u
   g==;
IronPort-SDR: YcP89EbNyYyDa5t5I+x1+o47VbMX3wvnmpBHKPkD54oZ0GxEP/JjnGWPWPXsw/TGxATnEKJC1Q
 4ZTLhV80gwIn9sb9lLNGDFrAR8I6PAJWvc3j0UglIe+mWnfonM8xQy8YpZNUWjyoV3WfD/6eg7
 zRy19IO2ttDMFk8FuQwOhhN6hCVu0yLfEgrD2jn4efR0XMWsu+KiHDDKICBmVx7TVBIoZ0/M3l
 6cloQfqMh/g7ay4lro4YwDOfj4pumErhgdrILSkp5m39oSLETp4mC9rqSBho+D3F+bc6KFSbM4
 6/g=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="20277467"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:56:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:55:39 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:55:38 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 4/6] smsc95xx: remove redundant link status checking
Date:   Thu, 23 Jul 2020 13:55:05 +0200
Message-ID: <20200723115507.26194-5-andre.edich@microchip.com>
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

Current driver supports PAL that does link status checking anyway.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 55 --------------------------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 9d2710f6d396..8731724bf2c5 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -51,8 +51,6 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
-#define CARRIER_CHECK_DELAY (2 * HZ)
-
 struct smsc95xx_priv {
 	u32 chip_id;
 	u32 mac_cr;
@@ -64,8 +62,6 @@ struct smsc95xx_priv {
 	u8 suspend_flags;
 	u8 mdix_ctrl;
 	bool link_ok;
-	struct delayed_work carrier_check;
-	struct usbnet *dev;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
 	bool internal_phy;
@@ -644,44 +640,6 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 			    intdata);
 }
 
-static void set_carrier(struct usbnet *dev, bool link)
-{
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-
-	if (pdata->link_ok == link)
-		return;
-
-	pdata->link_ok = link;
-
-	if (link)
-		usbnet_link_change(dev, 1, 0);
-	else
-		usbnet_link_change(dev, 0, 0);
-}
-
-static void check_carrier(struct work_struct *work)
-{
-	struct smsc95xx_priv *pdata = container_of(work, struct smsc95xx_priv,
-						carrier_check.work);
-	struct usbnet *dev = pdata->dev;
-	int ret;
-
-	if (pdata->suspend_flags != 0)
-		return;
-
-	ret = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, MII_BMSR);
-	if (ret < 0) {
-		netdev_warn(dev->net, "Failed to read MII_BMSR\n");
-		return;
-	}
-	if (ret & BMSR_LSTATUS)
-		set_carrier(dev, 1);
-	else
-		set_carrier(dev, 0);
-
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
-}
-
 /* Enable or disable Tx & Rx checksum offload engines */
 static int smsc95xx_set_features(struct net_device *netdev,
 	netdev_features_t features)
@@ -1333,11 +1291,6 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->min_mtu = ETH_MIN_MTU;
 	dev->net->max_mtu = ETH_DATA_LEN;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-
-	pdata->dev = dev;
-	INIT_DELAYED_WORK(&pdata->carrier_check, check_carrier);
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
-
 	return 0;
 
 unregister_mdio:
@@ -1355,7 +1308,6 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 
-	cancel_delayed_work_sync(&pdata->carrier_check);
 	mdiobus_unregister(pdata->mdiobus);
 	mdiobus_free(pdata->mdiobus);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
@@ -1649,8 +1601,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		return ret;
 	}
 
-	cancel_delayed_work_sync(&pdata->carrier_check);
-
 	if (pdata->suspend_flags) {
 		netdev_warn(dev->net, "error during last resume\n");
 		pdata->suspend_flags = 0;
@@ -1894,10 +1844,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
-	if (ret)
-		schedule_delayed_work(&pdata->carrier_check,
-				      CARRIER_CHECK_DELAY);
-
 	return ret;
 }
 
@@ -1917,7 +1863,6 @@ static int smsc95xx_resume(struct usb_interface *intf)
 
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
-	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
 
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
-- 
2.27.0

