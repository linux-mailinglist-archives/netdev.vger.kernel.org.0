Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D0686683
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjBANPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjBANPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:33 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 837A331E36;
        Wed,  1 Feb 2023 05:15:31 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="148127785"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id F11BB400C9F6;
        Wed,  1 Feb 2023 22:15:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 2/5] net: renesas: rswitch: Convert to phy_device
Date:   Wed,  1 Feb 2023 22:14:51 +0900
Message-Id: <20230201131454.1928136-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intended to set phy_device->host_interfaces by phylink in the future.
But there is difficult to implement phylink properly, especially
supporting the in-band mode on this driver because extra initialization
is needed after linked the ethernet PHY up. So, convert to phy_device
from phylink.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 110 ++++++++++++++-----------
 drivers/net/ethernet/renesas/rswitch.h |   2 -
 2 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 1c154018d795..479499f9fcb5 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -16,7 +16,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/phylink.h>
 #include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
 #include <linux/rtnetlink.h>
@@ -1139,61 +1138,78 @@ static void rswitch_mii_unregister(struct rswitch_device *rdev)
 	}
 }
 
-static void rswitch_mac_config(struct phylink_config *config,
-			       unsigned int mode,
-			       const struct phylink_link_state *state)
+static void rswitch_adjust_link(struct net_device *ndev)
 {
-}
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct phy_device *phydev = ndev->phydev;
 
-static void rswitch_mac_link_down(struct phylink_config *config,
-				  unsigned int mode,
-				  phy_interface_t interface)
-{
+	/* Current hardware has a restriction not to change speed at runtime */
+	if (phydev->link != rdev->etha->link) {
+		phy_print_status(phydev);
+		rdev->etha->link = phydev->link;
+	}
 }
 
-static void rswitch_mac_link_up(struct phylink_config *config,
-				struct phy_device *phydev, unsigned int mode,
-				phy_interface_t interface, int speed,
-				int duplex, bool tx_pause, bool rx_pause)
+static void rswitch_phy_remove_link_mode(struct rswitch_device *rdev,
+					 struct phy_device *phydev)
 {
-	/* Current hardware cannot change speed at runtime */
-}
+	/* Current hardware has a restriction not to change speed at runtime */
+	switch (rdev->etha->speed) {
+	case SPEED_2500:
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+		break;
+	case SPEED_1000:
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+		break;
+	case SPEED_100:
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+		break;
+	default:
+		break;
+	}
 
-static const struct phylink_mac_ops rswitch_phylink_ops = {
-	.mac_config = rswitch_mac_config,
-	.mac_link_down = rswitch_mac_link_down,
-	.mac_link_up = rswitch_mac_link_up,
-};
+	phy_set_max_speed(phydev, rdev->etha->speed);
+}
 
-static int rswitch_phylink_init(struct rswitch_device *rdev)
+static int rswitch_phy_device_init(struct rswitch_device *rdev)
 {
-	struct phylink *phylink;
+	struct phy_device *phydev;
+	struct device_node *phy;
 
 	if (!rdev->np_port)
 		return -ENODEV;
 
-	rdev->phylink_config.dev = &rdev->ndev->dev;
-	rdev->phylink_config.type = PHYLINK_NETDEV;
-	__set_bit(PHY_INTERFACE_MODE_SGMII, rdev->phylink_config.supported_interfaces);
-	__set_bit(PHY_INTERFACE_MODE_USXGMII, rdev->phylink_config.supported_interfaces);
-	rdev->phylink_config.mac_capabilities = MAC_100FD | MAC_1000FD | MAC_2500FD;
+	phy = of_parse_phandle(rdev->np_port, "phy-handle", 0);
+	if (!phy)
+		return -ENODEV;
+
+	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
+				rdev->etha->phy_interface);
+	of_node_put(phy);
+	if (!phydev)
+		return -ENOENT;
 
-	phylink = phylink_create(&rdev->phylink_config, &rdev->np_port->fwnode,
-				 rdev->etha->phy_interface, &rswitch_phylink_ops);
-	if (IS_ERR(phylink))
-		return PTR_ERR(phylink);
+	phy_set_max_speed(phydev, SPEED_2500);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	rswitch_phy_remove_link_mode(rdev, phydev);
 
-	rdev->phylink = phylink;
+	phy_attached_info(phydev);
 
-	return phylink_of_phy_connect(rdev->phylink, rdev->np_port, rdev->etha->phy_interface);
+	return 0;
 }
 
-static void rswitch_phylink_deinit(struct rswitch_device *rdev)
+static void rswitch_phy_device_deinit(struct rswitch_device *rdev)
 {
-	rtnl_lock();
-	phylink_disconnect_phy(rdev->phylink);
-	rtnl_unlock();
-	phylink_destroy(rdev->phylink);
+	if (rdev->ndev->phydev) {
+		phy_disconnect(rdev->ndev->phydev);
+		rdev->ndev->phydev = NULL;
+	}
 }
 
 static int rswitch_serdes_set_params(struct rswitch_device *rdev)
@@ -1223,9 +1239,9 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 	if (err < 0)
 		return err;
 
-	err = rswitch_phylink_init(rdev);
+	err = rswitch_phy_device_init(rdev);
 	if (err < 0)
-		goto err_phylink_init;
+		goto err_phy_device_init;
 
 	rdev->serdes = devm_of_phy_get(&rdev->priv->pdev->dev, rdev->np_port, NULL);
 	if (IS_ERR(rdev->serdes)) {
@@ -1241,9 +1257,9 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 
 err_serdes_set_params:
 err_serdes_phy_get:
-	rswitch_phylink_deinit(rdev);
+	rswitch_phy_device_deinit(rdev);
 
-err_phylink_init:
+err_phy_device_init:
 	rswitch_mii_unregister(rdev);
 
 	return err;
@@ -1251,7 +1267,7 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 
 static void rswitch_ether_port_deinit_one(struct rswitch_device *rdev)
 {
-	rswitch_phylink_deinit(rdev);
+	rswitch_phy_device_deinit(rdev);
 	rswitch_mii_unregister(rdev);
 }
 
@@ -1299,7 +1315,7 @@ static int rswitch_open(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 
-	phylink_start(rdev->phylink);
+	phy_start(ndev->phydev);
 
 	napi_enable(&rdev->napi);
 	netif_start_queue(ndev);
@@ -1319,7 +1335,7 @@ static int rswitch_stop(struct net_device *ndev)
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, false);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, false);
 
-	phylink_stop(rdev->phylink);
+	phy_stop(ndev->phydev);
 	napi_disable(&rdev->napi);
 
 	return 0;
@@ -1447,8 +1463,6 @@ static int rswitch_hwstamp_set(struct net_device *ndev, struct ifreq *req)
 
 static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
-	struct rswitch_device *rdev = netdev_priv(ndev);
-
 	if (!netif_running(ndev))
 		return -EINVAL;
 
@@ -1458,7 +1472,7 @@ static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd
 	case SIOCSHWTSTAMP:
 		return rswitch_hwstamp_set(ndev, req);
 	default:
-		return phylink_mii_ioctl(rdev->phylink, req, cmd);
+		return phy_mii_ioctl(ndev->phydev, req, cmd);
 	}
 }
 
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 6ae79395006e..59830ab91a69 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -943,8 +943,6 @@ struct rswitch_device {
 	struct rswitch_private *priv;
 	struct net_device *ndev;
 	struct napi_struct napi;
-	struct phylink *phylink;
-	struct phylink_config phylink_config;
 	void __iomem *addr;
 	struct rswitch_gwca_queue *tx_queue;
 	struct rswitch_gwca_queue *rx_queue;
-- 
2.25.1

