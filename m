Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4081D63D8
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 21:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgEPTYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 15:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726360AbgEPTYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 15:24:50 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C5AC061A0C;
        Sat, 16 May 2020 12:24:49 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=pengu.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ja2QE-000668-8m; Sat, 16 May 2020 21:24:34 +0200
From:   Roelof Berg <rberg@berg-solutions.de>
To:     rberg@berg-solutions.de
Cc:     andrew@lunn.ch, Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: Added fixed link support
Date:   Sat, 16 May 2020 21:24:01 +0200
Message-Id: <20200516192402.4201-1-rberg@berg-solutions.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589657090;71ce8ce2;
X-HE-SMSGID: 1ja2QE-000668-8m
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Microchip lan7431 is frequently connected to a phy. However, it
can also be directly connected to a MII remote peer without
any phy in between. For supporting such a phyless hardware setup
in Linux we added the capability to the driver to understand
the fixed-link and the phy-connection-type entries in the device
tree.

If a fixed-link node is configured in the device tree the lan7431
device will deactivate auto negotiation and uses the speed and
duplex settings configured in the fixed-link node.

Also the phy-connection-type can be configured in the device tree
and in case of a fixed-link connection the RGMII mode can be
configured, all other modes fall back to the default: GMII.

Example:

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
 drivers/net/ethernet/microchip/lan743x_main.c | 93 +++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |  4 +
 2 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a43140f7b5eb..278765dfc3b3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -9,9 +9,12 @@
 #include <linux/microchipphy.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
+#include <linux/phy_fixed.h>
 #include <linux/rtnetlink.h>
 #include <linux/iopoll.h>
 #include <linux/crc16.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
@@ -946,6 +949,9 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
+	struct device_node *phynode;
+	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
+	u32 data;
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
@@ -953,6 +959,48 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
+		/* check if a fixed-link is defined in device-tree */
+		phynode = of_node_get(adapter->pdev->dev.of_node);
+		if (phynode && of_phy_is_fixed_link(phynode)) {
+			/* Configure MAC to fixed link parameters */
+			data = lan743x_csr_read(adapter, MAC_CR);
+			/* Disable auto negotiation */
+			data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
+			/* Set duplex mode */
+			if (phydev->duplex)
+				data |= MAC_CR_DPX_;
+			else
+				data &= ~MAC_CR_DPX_;
+			/* Set bus speed */
+			switch (phydev->speed) {
+			case 10:
+				data &= ~MAC_CR_CFG_H_;
+				data &= ~MAC_CR_CFG_L_;
+				break;
+			case 100:
+				data &= ~MAC_CR_CFG_H_;
+				data |= MAC_CR_CFG_L_;
+				break;
+			case 1000:
+				data |= MAC_CR_CFG_H_;
+				data |= MAC_CR_CFG_L_;
+				break;
+			}
+			/* Set interface mode */
+			of_get_phy_mode(phynode, &phyifc);
+			if (phyifc == PHY_INTERFACE_MODE_RGMII ||
+			    phyifc == PHY_INTERFACE_MODE_RGMII_ID ||
+			    phyifc == PHY_INTERFACE_MODE_RGMII_RXID ||
+			    phyifc == PHY_INTERFACE_MODE_RGMII_TXID)
+				/* RGMII */
+				data &= ~MAC_CR_MII_EN_;
+			else
+				/* GMII */
+				data |= MAC_CR_MII_EN_;
+			lan743x_csr_write(adapter, MAC_CR, data);
+		}
+		of_node_put(phynode);
+
 		memset(&ksettings, 0, sizeof(ksettings));
 		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
@@ -974,6 +1022,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
 	phy_stop(netdev->phydev);
 	phy_disconnect(netdev->phydev);
+	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
+		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
 	netdev->phydev = NULL;
 }
 
@@ -982,18 +1032,44 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	struct lan743x_phy *phy = &adapter->phy;
 	struct phy_device *phydev;
 	struct net_device *netdev;
+	struct device_node *phynode = NULL;
+	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
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
+	/* check if a fixed-link is defined in device-tree */
+	phynode = of_node_get(adapter->pdev->dev.of_node);
+	if (phynode && of_phy_is_fixed_link(phynode)) {
+		netdev_dbg(netdev, "fixed-link detected\n");
+
+		ret = of_phy_register_fixed_link(phynode);
+		if (ret) {
+			netdev_err(netdev, "cannot register fixed PHY\n");
+			goto return_error;
+		}
+
+		of_get_phy_mode(phynode, &phyifc);
+		phydev = of_phy_connect(netdev, phynode,
+					lan743x_phy_link_status_change,
+					0, phyifc);
+		if (!phydev)
+			goto return_error;
+	} else {
+		phydev = phy_find_first(adapter->mdiobus);
+		if (!phydev)
+			goto return_error;
+
+		ret = phy_connect_direct(netdev, phydev,
+					 lan743x_phy_link_status_change,
+					 PHY_INTERFACE_MODE_GMII);
+		/* Note: We cannot use phyifc here because this would be SGMII
+		 * on a standard PC.
+		 */
+		if (ret)
+			goto return_error;
+	}
+	of_node_put(phynode);
 
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
@@ -1008,6 +1084,7 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	return 0;
 
 return_error:
+	of_node_put(phynode);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 3b02eeae5f45..e49f6b6cd440 100644
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
-- 
2.20.1

