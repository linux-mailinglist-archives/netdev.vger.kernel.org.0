Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36511E87D3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgE2Tag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgE2Taf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:30:35 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06050C03E969;
        Fri, 29 May 2020 12:30:35 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=pengu.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jeki5-0003hF-O9; Fri, 29 May 2020 21:30:29 +0200
From:   Roelof Berg <rberg@berg-solutions.de>
To:     rberg@berg-solutions.de
Cc:     andrew@lunn.ch, Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: Added fixed link and RGMII support
Date:   Fri, 29 May 2020 21:30:02 +0200
Message-Id: <20200529193003.3717-1-rberg@berg-solutions.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1590780635;1d319076;
X-HE-SMSGID: 1jeki5-0003hF-O9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Microchip lan7431 is frequently connected to a phy. However, it
can also be directly connected to a MII remote peer without
any phy in between. For supporting such a phyless hardware setup
in Linux we utilized phylib, which supports a fixed-link
configuration via the device tree. And we added support for
defining the connection type R/GMII in the device tree.

New behavior:
-------------
. The automatic speed and duplex detection of the lan743x silicon
  between mac and phy is disabled. Instead phylib is used like in
  other typical Linux drivers. The usage of phylib allows to
  specify fixed-link parameters in the device tree.

. The device tree entry phy-connection-type is supported now with
  the modes RGMII or (G)MII (default).

Development state:
------------------
. Tested with fixed-phy configurations. Not yet tested in normal
  configurations with phy. Microchip kindly offered testing
  as soon as the Corona measures allow this.

. All review findings of Andrew Lunn are included

Example:
--------
&pcie {
	status = "okay";

	host@0 {
		reg = <0 0 0 0 0>;

		#address-cells = <3>;
		#size-cells = <2>;

		ethernet@0 {
			compatible = "weyland-yutani,noscom1", "microchip,lan743x";
			status = "okay";
			reg = <0 0 0 0 0>;
			phy-connection-type = "rgmii";

			fixed-link {
				speed = <100>;
				full-duplex;
			};
		};
	};
};

Signed-off-by: Roelof Berg <rberg@berg-solutions.de>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  |  4 +-
 drivers/net/ethernet/microchip/lan743x_main.c | 81 ++++++++++++++++---
 drivers/net/ethernet/microchip/lan743x_main.h |  6 ++
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  2 +-
 4 files changed, 80 insertions(+), 13 deletions(-)

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
index a43140f7b5eb..36624e3c633b 100644
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
+		/* set duplex mode */
+		if (phydev->duplex)
+			data |= MAC_CR_DPX_;
+		else
+			data &= ~MAC_CR_DPX_;
+
+		/* set bus speed */
+		switch (phydev->speed) {
+		case SPEED_10:
+			data &= ~MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+		break;
+		case SPEED_100:
+			data &= ~MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+		break;
+		case SPEED_1000:
+			data |= MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+		break;
+		}
+		lan743x_csr_write(adapter, MAC_CR, data);
+
 		memset(&ksettings, 0, sizeof(ksettings));
 		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
@@ -980,20 +1017,44 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
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
 
-	ret = phy_connect_direct(netdev, phydev,
-				 lan743x_phy_link_status_change,
-				 PHY_INTERFACE_MODE_GMII);
-	if (ret)
-		goto return_error;
+		ret = phy_connect_direct(netdev, phydev,
+					 lan743x_phy_link_status_change,
+					 adapter->phy_mode);
+		if (ret)
+			goto return_error;
+	}
 
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 3b02eeae5f45..c61a40411317 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -4,6 +4,7 @@
 #ifndef _LAN743X_H
 #define _LAN743X_H
 
+#include <linux/phy.h>
 #include "lan743x_ptp.h"
 
 #define DRIVER_AUTHOR   "Bryan Whitehead <Bryan.Whitehead@microchip.com>"
@@ -104,10 +105,14 @@
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
@@ -698,6 +703,7 @@ struct lan743x_rx {
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
+	phy_interface_t		phy_mode;
 	int                     msg_enable;
 #ifdef CONFIG_PM
 	u32			wolopts;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 9399f6a98748..ab6d719d40f0 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -2,12 +2,12 @@
 /* Copyright (C) 2018 Microchip Technology Inc. */
 
 #include <linux/netdevice.h>
-#include "lan743x_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/net_tstamp.h>
+#include "lan743x_main.h"
 
 #include "lan743x_ptp.h"
 
-- 
2.25.1

