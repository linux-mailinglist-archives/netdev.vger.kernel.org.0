Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1CB1D1E8B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbgEMTHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:07:38 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DAEC061A0C;
        Wed, 13 May 2020 12:07:38 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=pengu.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jYwis-0004tW-H9; Wed, 13 May 2020 21:07:18 +0200
From:   Roelof Berg <rberg@berg-solutions.de>
To:     rberg@berg-solutions.de
Cc:     andrew@lunn.ch, Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: Added fixed link support
Date:   Wed, 13 May 2020 21:06:33 +0200
Message-Id: <20200513190633.7815-1-rberg@berg-solutions.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589396858;56c0db42;
X-HE-SMSGID: 1jYwis-0004tW-H9
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
 drivers/net/ethernet/microchip/lan743x_main.c | 94 +++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |  4 +
 2 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a43140f7b5eb..85f12881340b 100644
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
 
@@ -974,6 +977,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
 	phy_stop(netdev->phydev);
 	phy_disconnect(netdev->phydev);
+	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
+		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
 	netdev->phydev = NULL;
 }
 
@@ -982,18 +987,86 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	struct lan743x_phy *phy = &adapter->phy;
 	struct phy_device *phydev;
 	struct net_device *netdev;
+	struct device_node *phynode;
+	u32 data;
+	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
+	bool fixed_link = false;
 	int ret = -EIO;
 
 	netdev = adapter->netdev;
-	phydev = phy_find_first(adapter->mdiobus);
-	if (!phydev)
-		goto return_error;
+	phynode = of_node_get(adapter->pdev->dev.of_node);
+	if (phynode)
+		of_get_phy_mode(phynode, &phyifc);
+
+	/* check if a fixed-link is defined in device-tree */
+	if (phynode && of_phy_is_fixed_link(phynode)) {
+		fixed_link = true;
+		netdev_dbg(netdev, "fixed-link detected\n");
+
+		ret = of_phy_register_fixed_link(phynode);
+		if (ret) {
+			netdev_err(netdev, "cannot register fixed PHY\n");
+			goto return_error;
+		}
 
-	ret = phy_connect_direct(netdev, phydev,
-				 lan743x_phy_link_status_change,
-				 PHY_INTERFACE_MODE_GMII);
-	if (ret)
-		goto return_error;
+		phydev = of_phy_connect(netdev, phynode,
+					lan743x_phy_link_status_change,
+					0, phyifc);
+		if (!phydev)
+			goto return_error;
+
+		/* Configure MAC to fixed link parameters */
+		data = lan743x_csr_read(adapter, MAC_CR);
+		/* Disable auto negotiation */
+		data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
+		/* Set duplex mode */
+		if (phydev->duplex)
+			data |= MAC_CR_DPX_;
+		else
+			data &= ~MAC_CR_DPX_;
+		/* Set bus speed */
+		switch (phydev->speed) {
+		case 10:
+			data &= ~MAC_CR_CFG_H_;
+			data &= ~MAC_CR_CFG_L_;
+			break;
+		case 100:
+			data &= ~MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+			break;
+		case 1000:
+			data |= MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+			break;
+		}
+		/* Set interface mode */
+		if (phyifc == PHY_INTERFACE_MODE_RGMII ||
+		    phyifc == PHY_INTERFACE_MODE_RGMII_ID ||
+		    phyifc == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    phyifc == PHY_INTERFACE_MODE_RGMII_TXID)
+			/* RGMII */
+			data &= ~MAC_CR_MII_EN_;
+		else
+			/* GMII */
+			data |= MAC_CR_MII_EN_;
+		lan743x_csr_write(adapter, MAC_CR, data);
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
+
+	if (phynode)
+		of_node_put(phynode);
 
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
@@ -1004,10 +1077,13 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	phy->fc_autoneg = phydev->autoneg;
 
 	phy_start(phydev);
-	phy_start_aneg(phydev);
+	if (!fixed_link)
+		phy_start_aneg(phydev);
 	return 0;
 
 return_error:
+	if (phynode)
+		of_node_put(phynode);
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

