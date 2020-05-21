Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395691DCEDF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgEUOEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:04:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgEUOEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 10:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4c1KI5lLVJTMb6lJcGXvj8JYpY0SbtyNOYn13xpdyK8=; b=UAumwUH8lVQyRxrLhLMjfgnC2r
        r71Gp9+lVeSh75ff89G0cZQNKvHDgpHMfHLtmI2kDasSmcr8yPl/5vdLrvF3EE+mv57LkEwhbmkPz
        9J1hqB1sT05VB7gIwNv/lw2NH/BS7csGTVQliYiDaaN+cxK2HW3a/BVAYYYuIDOK6aaI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jblo8-002uOK-51; Thu, 21 May 2020 16:04:24 +0200
Date:   Thu, 21 May 2020 16:04:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link support
Message-ID: <20200521140424.GD657910@lunn.ch>
References: <20200520171006.5263-1-rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520171006.5263-1-rberg@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 07:10:06PM +0200, Roelof Berg wrote:

Hi Roelof

Here is how i would do this. I don't like this MII bus snooping. It is
a microchip propriety's thing, which is not well understood. It adds
no value over just doing what every other MAC driver does in the
link_change callback, which lots of people understand.

I also removed all OF handing from within the callback. And i unified
fixed-link and normal PHY.

This is compile tested only, so is probably broken...

     Andrew


diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 3a0b289d9771..c533d06fbe3a 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -2,11 +2,11 @@
 /* Copyright (C) 2018 Microchip Technology Inc. */
 
 #include <linux/netdevice.h>
-#include "lan743x_main.h"
-#include "lan743x_ethtool.h"
 #include <linux/net_tstamp.h>
 #include <linux/pci.h>
 #include <linux/phy.h>
+#include "lan743x_main.h"
+#include "lan743x_ethtool.h"
 
 /* eeprom */
 #define LAN743X_EEPROM_MAGIC		    (0x74A5)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a43140f7b5eb..5aaa0ac96970 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -8,7 +8,10 @@
 #include <linux/crc32.h>
 #include <linux/microchipphy.h>
 #include <linux/net_tstamp.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include <linux/phy.h>
+#include <linux/phy_fixed.h>
 #include <linux/rtnetlink.h>
 #include <linux/iopoll.h>
 #include <linux/crc16.h>
@@ -798,9 +801,9 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 
 	netdev = adapter->netdev;
 
-	/* setup auto duplex, and speed detection */
+	/* disable auto duplex, and speed detection. Phylib does that */
 	data = lan743x_csr_read(adapter, MAC_CR);
-	data |= MAC_CR_ADD_ | MAC_CR_ASD_;
+	data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
 	data |= MAC_CR_CNTR_RST_;
 	lan743x_csr_write(adapter, MAC_CR, data);
 
@@ -946,6 +949,7 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
+	u32 data;
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
@@ -953,6 +957,39 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
+		data = lan743x_csr_read(adapter, MAC_CR);
+
+		/* set interface mode */
+		if (phy_interface_mode_is_rgmii(adapter->phy_mode))
+			/* RGMII */
+			data &= ~MAC_CR_MII_EN_;
+		else
+			/* GMII */
+			data |= MAC_CR_MII_EN_;
+
+		/* set fixed duplex mode */
+		if (phydev->duplex)
+			data |= MAC_CR_DPX_;
+		else
+			data &= ~MAC_CR_DPX_;
+
+		/* set fixed bus speed */
+		switch (phydev->speed) {
+		case SPEED_10:
+			data &= ~MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+			break;
+		case SPEED_100:
+			data &= ~MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+			break;
+		case SPEED_1000:
+			data |= MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+			break;
+		}
+		lan743x_csr_write(adapter, MAC_CR, data);
+
 		memset(&ksettings, 0, sizeof(ksettings));
 		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
@@ -974,26 +1011,53 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
 	phy_stop(netdev->phydev);
 	phy_disconnect(netdev->phydev);
+	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
+		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
 	netdev->phydev = NULL;
 }
 
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct lan743x_phy *phy = &adapter->phy;
+	struct device_node *phynode;
 	struct phy_device *phydev;
 	struct net_device *netdev;
 	int ret = -EIO;
 
 	netdev = adapter->netdev;
-	phydev = phy_find_first(adapter->mdiobus);
-	if (!phydev)
-		goto return_error;
 
-	ret = phy_connect_direct(netdev, phydev,
-				 lan743x_phy_link_status_change,
-				 PHY_INTERFACE_MODE_GMII);
-	if (ret)
-		goto return_error;
+	phynode = of_node_get(adapter->pdev->dev.of_node);
+	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
+
+	if (phynode) {
+		of_get_phy_mode(phynode, &adapter->phy_mode);
+
+		if (of_phy_is_fixed_link(phynode)) {
+			ret = of_phy_register_fixed_link(phynode);
+			if (ret) {
+				netdev_err(netdev,
+					   "cannot register fixed PHY\n");
+				of_node_put(phynode);
+				goto return_error;
+			}
+		}
+		phydev = of_phy_connect(netdev, phynode,
+					lan743x_phy_link_status_change, 0,
+					adapter->phy_mode);
+		of_node_put(phynode);
+		if (!phydev)
+			goto return_error;
+	} else {
+		phydev = phy_find_first(adapter->mdiobus);
+		if (!phydev)
+			goto return_error;
+
+		ret = phy_connect_direct(netdev, phydev,
+					 lan743x_phy_link_status_change,
+					 adapter->phy_mode);
+		if (ret)
+			goto return_error;
+	}
 
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 3b02eeae5f45..f769903538e4 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -104,10 +104,14 @@
 	((value << 0) & FCT_FLOW_CTL_ON_THRESHOLD_)
 
 #define MAC_CR				(0x100)
+#define MAC_CR_MII_EN_			BIT(19)
 #define MAC_CR_EEE_EN_			BIT(17)
 #define MAC_CR_ADD_			BIT(12)
 #define MAC_CR_ASD_			BIT(11)
 #define MAC_CR_CNTR_RST_		BIT(5)
+#define MAC_CR_DPX_			BIT(3)
+#define MAC_CR_CFG_H_			BIT(2)
+#define MAC_CR_CFG_L_			BIT(1)
 #define MAC_CR_RST_			BIT(0)
 
 #define MAC_RX				(0x104)
@@ -698,6 +702,7 @@ struct lan743x_rx {
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
+	phy_interface_t		phy_mode;
 	int                     msg_enable;
 #ifdef CONFIG_PM
 	u32			wolopts;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 9399f6a98748..b1df214a6973 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -2,12 +2,12 @@
 /* Copyright (C) 2018 Microchip Technology Inc. */
 
 #include <linux/netdevice.h>
-#include "lan743x_main.h"
-
+#include <linux/phy.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/net_tstamp.h>
+#include "lan743x_main.h"
 
 #include "lan743x_ptp.h"
 
