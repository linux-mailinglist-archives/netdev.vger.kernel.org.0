Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB17C4D2A45
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiCIICI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiCIICA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:02:00 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1414CC90;
        Wed,  9 Mar 2022 00:00:49 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22980RLL010730;
        Wed, 9 Mar 2022 02:00:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1646812827;
        bh=nfHDdSN/CiPwFxUEu5dVbm9FyXahN4H18CrgEGxtWYk=;
        h=From:To:CC:Subject:Date;
        b=xbx14C2xvkzNNVznAOuOKdKpbUxJifMVGMioPRiKNo8r9W9l3cwfRkcS8W9VBqKsb
         yHq8H4ZxcA4Yhc+zZIGM22V31eh6tx7TwO7ydv52hT3HsAs+UBQoiHdjAhdJXGjGqP
         FYamldQJqVu8psmfvjjD0Bmdo5AG61O6O6ws9IjE=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22980RPS101827
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Mar 2022 02:00:27 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 9
 Mar 2022 02:00:26 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 9 Mar 2022 02:00:26 -0600
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22980LAQ048040;
        Wed, 9 Mar 2022 02:00:23 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v2] net: ethernet: ti: am65-cpsw: Convert to PHYLINK
Date:   Wed, 9 Mar 2022 13:29:44 +0530
Message-ID: <20220309075944.32166-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert am65-cpsw driver and am65-cpsw ethtool to use Phylink APIs
as described at Documentation/networking/sfp-phylink.rst. All calls
to Phy APIs are replaced with their equivalent Phylink APIs.

No functional change intended. Use Phylink instead of conventional
Phylib, in preparation to add support for SGMII/QSGMII modes.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
Change log:
v1 -> v2:
1. Update commit message to include reason for converting to Phylink.
2. Initialize .validate member of struct phylink_mac_ops directly.
3. Use netif_tx_stop_all_queues() instead of netif_tx_disable() in am65_cpsw_nuss_mac_link_down().
4. Remove call to deprecated .pcs_poll member of struct phylink_config.
5. Remove SGMII and 1000BASE-X modes as driver doesn't support them currently.
6. Remove MAC_2500FD from mac_capabilities as it is currently not supported.
7. Add am65_cpsw_nuss_phylink_cleanup() function to invoke phylink_destroy() and clean up the
   created phylink instances.

v1: https://lore.kernel.org/r/20220304075812.1723-1-s-vadapalli@ti.com/

Tested on Texas Instruments AM64, AM65, J7200 and J721e devices.

 drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  56 +----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 228 ++++++++++----------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   5 +-
 3 files changed, 129 insertions(+), 160 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index d45b6bb86f0b..72acdf802258 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/net_tstamp.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
@@ -471,9 +471,7 @@ static void am65_cpsw_get_pauseparam(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	pause->autoneg = AUTONEG_DISABLE;
-	pause->rx_pause = salve->rx_pause ? true : false;
-	pause->tx_pause = salve->tx_pause ? true : false;
+	phylink_ethtool_get_pauseparam(salve->phylink, pause);
 }
 
 static int am65_cpsw_set_pauseparam(struct net_device *ndev,
@@ -481,18 +479,7 @@ static int am65_cpsw_set_pauseparam(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy)
-		return -EINVAL;
-
-	if (!phy_validate_pause(salve->phy, pause))
-		return -EINVAL;
-
-	salve->rx_pause = pause->rx_pause ? true : false;
-	salve->tx_pause = pause->tx_pause ? true : false;
-
-	phy_set_asym_pause(salve->phy, salve->rx_pause, salve->tx_pause);
-
-	return 0;
+	return phylink_ethtool_set_pauseparam(salve->phylink, pause);
 }
 
 static void am65_cpsw_get_wol(struct net_device *ndev,
@@ -500,11 +487,7 @@ static void am65_cpsw_get_wol(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	wol->supported = 0;
-	wol->wolopts = 0;
-
-	if (salve->phy)
-		phy_ethtool_get_wol(salve->phy, wol);
+	phylink_ethtool_get_wol(salve->phylink, wol);
 }
 
 static int am65_cpsw_set_wol(struct net_device *ndev,
@@ -512,10 +495,7 @@ static int am65_cpsw_set_wol(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy)
-		return -EOPNOTSUPP;
-
-	return phy_ethtool_set_wol(salve->phy, wol);
+	return phylink_ethtool_set_wol(salve->phylink, wol);
 }
 
 static int am65_cpsw_get_link_ksettings(struct net_device *ndev,
@@ -523,11 +503,7 @@ static int am65_cpsw_get_link_ksettings(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy)
-		return -EOPNOTSUPP;
-
-	phy_ethtool_ksettings_get(salve->phy, ecmd);
-	return 0;
+	return phylink_ethtool_ksettings_get(salve->phylink, ecmd);
 }
 
 static int
@@ -536,40 +512,28 @@ am65_cpsw_set_link_ksettings(struct net_device *ndev,
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
-		return -EOPNOTSUPP;
-
-	return phy_ethtool_ksettings_set(salve->phy, ecmd);
+	return phylink_ethtool_ksettings_set(salve->phylink, ecmd);
 }
 
 static int am65_cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
-		return -EOPNOTSUPP;
-
-	return phy_ethtool_get_eee(salve->phy, edata);
+	return phylink_ethtool_get_eee(salve->phylink, edata);
 }
 
 static int am65_cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
-		return -EOPNOTSUPP;
-
-	return phy_ethtool_set_eee(salve->phy, edata);
+	return phylink_ethtool_set_eee(salve->phylink, edata);
 }
 
 static int am65_cpsw_nway_reset(struct net_device *ndev)
 {
 	struct am65_cpsw_slave_data *salve = am65_ndev_to_slave(ndev);
 
-	if (!salve->phy || phy_is_pseudo_fixed_link(salve->phy))
-		return -EOPNOTSUPP;
-
-	return phy_restart_aneg(salve->phy);
+	return phylink_ethtool_nway_reset(salve->phylink);
 }
 
 static int am65_cpsw_get_regs_len(struct net_device *ndev)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8251d7eb001b..d2747e9db286 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -18,7 +18,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_device.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -159,69 +159,6 @@ static void am65_cpsw_nuss_get_ver(struct am65_cpsw_common *common)
 		common->pdata.quirks);
 }
 
-void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
-{
-	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-	struct phy_device *phy = port->slave.phy;
-	u32 mac_control = 0;
-
-	if (!phy)
-		return;
-
-	if (phy->link) {
-		mac_control = CPSW_SL_CTL_GMII_EN;
-
-		if (phy->speed == 1000)
-			mac_control |= CPSW_SL_CTL_GIG;
-		if (phy->speed == 10 && phy_interface_is_rgmii(phy))
-			/* Can be used with in band mode only */
-			mac_control |= CPSW_SL_CTL_EXT_EN;
-		if (phy->speed == 100 && phy->interface == PHY_INTERFACE_MODE_RMII)
-			mac_control |= CPSW_SL_CTL_IFCTL_A;
-		if (phy->duplex)
-			mac_control |= CPSW_SL_CTL_FULLDUPLEX;
-
-		/* RGMII speed is 100M if !CPSW_SL_CTL_GIG*/
-
-		/* rx_pause/tx_pause */
-		if (port->slave.rx_pause)
-			mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
-
-		if (port->slave.tx_pause)
-			mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
-
-		cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
-
-		/* enable forwarding */
-		cpsw_ale_control_set(common->ale, port->port_id,
-				     ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
-
-		am65_cpsw_qos_link_up(ndev, phy->speed);
-		netif_tx_wake_all_queues(ndev);
-	} else {
-		int tmo;
-
-		/* disable forwarding */
-		cpsw_ale_control_set(common->ale, port->port_id,
-				     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
-
-		cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
-
-		tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
-		dev_dbg(common->dev, "donw msc_sl %08x tmo %d\n",
-			cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS),
-			tmo);
-
-		cpsw_sl_ctl_reset(port->slave.mac_sl);
-
-		am65_cpsw_qos_link_down(ndev);
-		netif_tx_stop_all_queues(ndev);
-	}
-
-	phy_print_status(phy);
-}
-
 static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 					    __be16 proto, u16 vid)
 {
@@ -589,15 +526,11 @@ static int am65_cpsw_nuss_ndo_slave_stop(struct net_device *ndev)
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret;
 
-	if (port->slave.phy)
-		phy_stop(port->slave.phy);
+	phylink_stop(port->slave.phylink);
 
 	netif_tx_stop_all_queues(ndev);
 
-	if (port->slave.phy) {
-		phy_disconnect(port->slave.phy);
-		port->slave.phy = NULL;
-	}
+	phylink_disconnect_phy(port->slave.phylink);
 
 	ret = am65_cpsw_nuss_common_stop(common);
 	if (ret)
@@ -667,25 +600,14 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	if (ret)
 		goto error_cleanup;
 
-	if (port->slave.phy_node) {
-		port->slave.phy = of_phy_connect(ndev,
-						 port->slave.phy_node,
-						 &am65_cpsw_nuss_adjust_link,
-						 0, port->slave.phy_if);
-		if (!port->slave.phy) {
-			dev_err(common->dev, "phy %pOF not found on slave %d\n",
-				port->slave.phy_node,
-				port->port_id);
-			ret = -ENODEV;
-			goto error_cleanup;
-		}
-	}
+	ret = phylink_of_phy_connect(port->slave.phylink, port->slave.phy_node, 0);
+	if (ret)
+		goto error_cleanup;
 
 	/* restore vlan configurations */
 	vlan_for_each(ndev, cpsw_restore_vlans, port);
 
-	phy_attached_info(port->slave.phy);
-	phy_start(port->slave.phy);
+	phylink_start(port->slave.phylink);
 
 	return 0;
 
@@ -1431,10 +1353,7 @@ static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
 		return am65_cpsw_nuss_hwtstamp_get(ndev, req);
 	}
 
-	if (!port->slave.phy)
-		return -EOPNOTSUPP;
-
-	return phy_mii_ioctl(port->slave.phy, req, cmd);
+	return phylink_mii_ioctl(port->slave.phylink, req, cmd);
 }
 
 static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
@@ -1494,6 +1413,81 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
 };
 
+static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
+				      const struct phylink_link_state *state)
+{
+	/* Currently not used */
+}
+
+static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
+					 phy_interface_t interface)
+{
+	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
+							  phylink_config);
+	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+	struct am65_cpsw_common *common = port->common;
+	struct net_device *ndev = port->ndev;
+	int tmo;
+
+	/* disable forwarding */
+	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
+
+	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
+
+	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
+	dev_dbg(common->dev, "down msc_sl %08x tmo %d\n",
+		cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
+
+	cpsw_sl_ctl_reset(port->slave.mac_sl);
+
+	am65_cpsw_qos_link_down(ndev);
+	netif_tx_stop_all_queues(ndev);
+}
+
+static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy_device *phy,
+				       unsigned int mode, phy_interface_t interface, int speed,
+				       int duplex, bool tx_pause, bool rx_pause)
+{
+	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
+							  phylink_config);
+	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+	struct am65_cpsw_common *common = port->common;
+	u32 mac_control = CPSW_SL_CTL_GMII_EN;
+	struct net_device *ndev = port->ndev;
+
+	if (speed == SPEED_1000)
+		mac_control |= CPSW_SL_CTL_GIG;
+	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+		/* Can be used with in band mode only */
+		mac_control |= CPSW_SL_CTL_EXT_EN;
+	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
+		mac_control |= CPSW_SL_CTL_IFCTL_A;
+	if (duplex)
+		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
+
+	/* rx_pause/tx_pause */
+	if (rx_pause)
+		mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
+
+	if (tx_pause)
+		mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
+
+	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
+
+	/* enable forwarding */
+	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
+
+	am65_cpsw_qos_link_up(ndev, speed);
+	netif_tx_wake_all_queues(ndev);
+}
+
+static const struct phylink_mac_ops am65_cpsw_phylink_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_config = am65_cpsw_nuss_mac_config,
+	.mac_link_down = am65_cpsw_nuss_mac_link_down,
+	.mac_link_up = am65_cpsw_nuss_mac_link_up,
+};
+
 static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 {
 	struct am65_cpsw_common *common = port->common;
@@ -1890,27 +1884,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				of_property_read_bool(port_np, "ti,mac-only");
 
 		/* get phy/link info */
-		if (of_phy_is_fixed_link(port_np)) {
-			ret = of_phy_register_fixed_link(port_np);
-			if (ret) {
-				ret = dev_err_probe(dev, ret,
-						     "failed to register fixed-link phy %pOF\n",
-						     port_np);
-				goto of_node_put;
-			}
-			port->slave.phy_node = of_node_get(port_np);
-		} else {
-			port->slave.phy_node =
-				of_parse_phandle(port_np, "phy-handle", 0);
-		}
-
-		if (!port->slave.phy_node) {
-			dev_err(dev,
-				"slave[%d] no phy found\n", port_id);
-			ret = -ENODEV;
-			goto of_node_put;
-		}
-
+		port->slave.phy_node = port_np;
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
@@ -1952,12 +1926,25 @@ static void am65_cpsw_pcpu_stats_free(void *data)
 	free_percpu(stats);
 }
 
+static void am65_cpsw_nuss_phylink_cleanup(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		if (port->slave.phylink)
+			phylink_destroy(port->slave.phylink);
+	}
+}
+
 static int
 am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
 	struct am65_cpsw_ndev_priv *ndev_priv;
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
+	struct phylink *phylink;
 	int ret;
 
 	port = &common->ports[port_idx];
@@ -1995,6 +1982,20 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
+	/* Configuring Phylink */
+	port->slave.phylink_config.dev = &port->ndev->dev;
+	port->slave.phylink_config.type = PHYLINK_NETDEV;
+	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
+
+	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+
+	phylink = phylink_create(&port->slave.phylink_config, dev->fwnode, port->slave.phy_if,
+				 &am65_cpsw_phylink_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	port->slave.phylink = phylink;
+
 	/* Disable TX checksum offload by default due to HW bug */
 	if (common->pdata.quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
 		port->ndev->features &= ~NETIF_F_HW_CSUM;
@@ -2761,15 +2762,17 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	ret = am65_cpsw_nuss_init_ndevs(common);
 	if (ret)
-		goto err_of_clear;
+		goto err_free_phylink;
 
 	ret = am65_cpsw_nuss_register_ndevs(common);
 	if (ret)
-		goto err_of_clear;
+		goto err_free_phylink;
 
 	pm_runtime_put(dev);
 	return 0;
 
+err_free_phylink:
+	am65_cpsw_nuss_phylink_cleanup(common);
 err_of_clear:
 	of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
@@ -2792,6 +2795,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 		return ret;
 	}
 
+	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
 	am65_cpsw_unregister_notifiers(common);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 048ed10143c1..ac945631bf2f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -10,7 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ti/k3-ringacc.h>
 #include <net/devlink.h>
@@ -30,13 +30,14 @@ struct am65_cpsw_slave_data {
 	bool				mac_only;
 	struct cpsw_sl			*mac_sl;
 	struct device_node		*phy_node;
-	struct phy_device		*phy;
 	phy_interface_t			phy_if;
 	struct phy			*ifphy;
 	bool				rx_pause;
 	bool				tx_pause;
 	u8				mac_addr[ETH_ALEN];
 	int				port_vlan;
+	struct phylink			*phylink;
+	struct phylink_config		phylink_config;
 };
 
 struct am65_cpsw_port {
-- 
2.17.1

