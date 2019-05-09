Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC8F18772
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfEIJIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:08:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:46120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfEIJIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 05:08:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 687EFB7B2;
        Thu,  9 May 2019 09:08:50 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     dmitry.bezrukov@aquantia.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 2/3] aqc111: fix writing to the phy on BE
Date:   Thu,  9 May 2019 11:08:17 +0200
Message-Id: <20190509090818.9257-2-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190509090818.9257-1-oneukum@suse.com>
References: <20190509090818.9257-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When writing to the phy on BE architectures an internal data structure
was directly given, leading to it being byte swapped in the wrong
way for the CPU in 50% of all cases. A temporary buffer must be used.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/aqc111.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 408df2d335e3..599d560a8450 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -320,6 +320,7 @@ static int aqc111_get_link_ksettings(struct net_device *net,
 static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
+	u32 phy_on_the_wire;
 
 	aqc111_data->phy_cfg &= ~AQ_ADV_MASK;
 	aqc111_data->phy_cfg |= AQ_PAUSE;
@@ -361,7 +362,8 @@ static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
 		}
 	}
 
-	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &aqc111_data->phy_cfg);
+	phy_on_the_wire = aqc111_data->phy_cfg;
+	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &phy_on_the_wire);
 }
 
 static int aqc111_set_link_ksettings(struct net_device *net,
@@ -755,6 +757,7 @@ static void aqc111_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u16 reg16;
+	u32 phy_on_the_wire;
 
 	/* Force bz */
 	reg16 = SFR_PHYPWR_RSTCTL_BZ;
@@ -768,8 +771,9 @@ static void aqc111_unbind(struct usbnet *dev, struct usb_interface *intf)
 	aqc111_data->phy_cfg &= ~AQ_ADV_MASK;
 	aqc111_data->phy_cfg |= AQ_LOW_POWER;
 	aqc111_data->phy_cfg &= ~AQ_PHY_POWER_EN;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd_nopm(dev, AQ_PHY_OPS, 0, 0,
-				&aqc111_data->phy_cfg);
+				&phy_on_the_wire);
 
 	kfree(aqc111_data);
 }
@@ -992,6 +996,7 @@ static int aqc111_reset(struct usbnet *dev)
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u8 reg8 = 0;
+	u32 phy_on_the_wire;
 
 	dev->rx_urb_size = URB_SIZE;
 
@@ -1004,8 +1009,9 @@ static int aqc111_reset(struct usbnet *dev)
 
 	/* Power up ethernet PHY */
 	aqc111_data->phy_cfg = AQ_PHY_POWER_EN;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-			   &aqc111_data->phy_cfg);
+			   &phy_on_the_wire);
 
 	/* Set the MAC address */
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_NODE_ID, ETH_ALEN,
@@ -1036,6 +1042,7 @@ static int aqc111_stop(struct usbnet *dev)
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u16 reg16 = 0;
+	u32 phy_on_the_wire;
 
 	aqc111_read16_cmd(dev, AQ_ACCESS_MAC, SFR_MEDIUM_STATUS_MODE,
 			  2, &reg16);
@@ -1047,8 +1054,9 @@ static int aqc111_stop(struct usbnet *dev)
 
 	/* Put PHY to low power*/
 	aqc111_data->phy_cfg |= AQ_LOW_POWER;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-			   &aqc111_data->phy_cfg);
+			   &phy_on_the_wire);
 
 	netif_carrier_off(dev->net);
 
@@ -1324,6 +1332,7 @@ static int aqc111_suspend(struct usb_interface *intf, pm_message_t message)
 	u16 temp_rx_ctrl = 0x00;
 	u16 reg16;
 	u8 reg8;
+	u32 phy_on_the_wire;
 
 	usbnet_suspend(intf, message);
 
@@ -1395,12 +1404,14 @@ static int aqc111_suspend(struct usb_interface *intf, pm_message_t message)
 
 		aqc111_write_cmd(dev, AQ_WOL_CFG, 0, 0,
 				 WOL_CFG_SIZE, &wol_cfg);
+		phy_on_the_wire = aqc111_data->phy_cfg;
 		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+				   &phy_on_the_wire);
 	} else {
 		aqc111_data->phy_cfg |= AQ_LOW_POWER;
+		phy_on_the_wire = aqc111_data->phy_cfg;
 		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+				   &phy_on_the_wire);
 
 		/* Disable RX path */
 		aqc111_read16_cmd_nopm(dev, AQ_ACCESS_MAC,
-- 
2.16.4

