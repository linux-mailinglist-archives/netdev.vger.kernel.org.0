Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F2F1DBACE
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETRKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETRKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:10:50 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB7AC061A0E;
        Wed, 20 May 2020 10:10:49 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=pengu.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jbSEt-00088y-Ih; Wed, 20 May 2020 19:10:43 +0200
From:   Roelof Berg <rberg@berg-solutions.de>
To:     rberg@berg-solutions.de
Cc:     andrew@lunn.ch, Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: Added fixed link support
Date:   Wed, 20 May 2020 19:10:06 +0200
Message-Id: <20200520171006.5263-1-rberg@berg-solutions.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589994650;ee76ab02;
X-HE-SMSGID: 1jbSEt-00088y-Ih
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

New behavior:
. If no device tree node is configured the behavior of the driver remains
  unchanged. This will ensure backwards compatibility to off-the-shelve
  PC hardware.

. If a device tree node is configured but no fixed-link node is present
  the phy-connection-type (as specified in the device tree)  will be
  applied and of_phy_connect() will be used instead of
  phy_connect_direct().

. If a device tree node is configured and a fixed-link node is present
  the phy-connection-type will be applied, of_phy_connect() will be
  used and the MAC will be configured to use the fix speed and duplex
  mode configured in the fixed-link node. Also ASD and ADD will be
  switched off.

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
 drivers/net/ethernet/microchip/lan743x_main.c | 101 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |   4 +
 2 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a43140f7b5eb..50ca223e8b8f 100644
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
 
@@ -946,6 +949,10 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
+	struct device_node *phynode;
+	phy_interface_t phyifc;
+	int ret = -EIO;
+	u32 data;
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
@@ -953,6 +960,53 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
+		/* check if a device-tree configuration is present */
+		phynode = of_node_get(adapter->pdev->dev.of_node);
+		if (phynode) {
+			data = lan743x_csr_read(adapter, MAC_CR);
+
+			/* set interface mode */
+			ret = of_get_phy_mode(phynode, &phyifc);
+			if (ret)
+				phyifc = PHY_INTERFACE_MODE_GMII;
+
+			if (phy_interface_mode_is_rgmii(phyifc))
+				/* RGMII */
+				data &= ~MAC_CR_MII_EN_;
+			else
+				/* GMII */
+				data |= MAC_CR_MII_EN_;
+
+			/* apply fixed-link configuration */
+			if (of_phy_is_fixed_link(phynode)) {
+				/* disable auto duplex, and speed detection */
+				data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
+				/* set fixed duplex mode */
+				if (phydev->duplex)
+					data |= MAC_CR_DPX_;
+				else
+					data &= ~MAC_CR_DPX_;
+				/* set fixed bus speed */
+				switch (phydev->speed) {
+				case 10:
+					data &= ~MAC_CR_CFG_H_;
+					data &= ~MAC_CR_CFG_L_;
+					break;
+				case 100:
+					data &= ~MAC_CR_CFG_H_;
+					data |= MAC_CR_CFG_L_;
+					break;
+				case 1000:
+					data |= MAC_CR_CFG_H_;
+					data |= MAC_CR_CFG_L_;
+					break;
+				}
+			}
+
+			lan743x_csr_write(adapter, MAC_CR, data);
+			of_node_put(phynode);
+		}
+
 		memset(&ksettings, 0, sizeof(ksettings));
 		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
@@ -974,26 +1028,57 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
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
+	phy_interface_t phyifc;
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
+	/* is a device tree configuration present */
+	phynode = of_node_get(adapter->pdev->dev.of_node);
+	if (phynode) {
+		/* apply device tree configuration */
+		if (of_phy_is_fixed_link(phynode)) {
+			ret = of_phy_register_fixed_link(phynode);
+			if (ret) {
+				netdev_err(netdev, "cannot register fixed PHY\n");
+				of_node_put(phynode);
+				goto return_error;
+			}
+		}
+
+		ret = of_get_phy_mode(phynode, &phyifc);
+		if (ret)
+			phyifc = PHY_INTERFACE_MODE_GMII;
+
+		phydev = of_phy_connect(netdev, phynode,
+					lan743x_phy_link_status_change,
+					0, phyifc);
+		of_node_put(phynode);
+		if (!phydev)
+			goto return_error;
+	} else {
+		/* no device tree configuration */
+		phydev = phy_find_first(adapter->mdiobus);
+		if (!phydev)
+			goto return_error;
+
+		ret = phy_connect_direct(netdev, phydev,
+					 lan743x_phy_link_status_change,
+					 PHY_INTERFACE_MODE_GMII);
+		if (ret)
+			goto return_error;
+	}
 
 	/* MAC doesn't support 1000T Half */
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
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
2.25.1

