Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6D2A0F2E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgJ3UHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:07:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33236 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgJ3UHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:07:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7ZYc108177;
        Fri, 30 Oct 2020 15:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604088455;
        bh=0m+e0cNmj2jKDpartKZUa902BaxeaD2NZhdh8fdtk68=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vFtQ3pDoNAPkLuQaaBGhd9ccEdY5a6yvRsPGhQkR5WB6CX6EJ6S+qaxcV7VtDDEnx
         nvGpaATy8cEOqwEQUsCOYq9EPbRyC+NeUxqBdyC8iy6KpJrH015RxT4+SijYAQxtmM
         6PPR6iJYZEh6yYfrU8Qzu24ICWAfE59UtcmVmZ2c=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UK7Zo4036591
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:07:35 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 15:07:35 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 15:07:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UK7YXk101800;
        Fri, 30 Oct 2020 15:07:35 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 09/10] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date:   Fri, 30 Oct 2020 22:07:06 +0200
Message-ID: <20201030200707.24294-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201030200707.24294-1-grygorii.strashko@ti.com>
References: <20201030200707.24294-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds final multi-port support to TI AM65x CPSW driver path in
preparation for adding support for multi-port devices, like Main CPSW0 on
K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
- the separate netdev is created for every enabled external Port;
- DMA channels are common/shared for all external Ports and the RX/TX NAPI
and DMA processing assigned to first available netdev;
- external Ports are configured in mac-only mode, which is similar to TI
"dual-mac" mode for legacy TI CPSW - packets are sent to the Host port only
in ingress and directly to the Port on egress. No packet switching between
external ports happens.
- every port supports the same features as current AM65x CPSW on external
device.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 129 ++++++++++++++---------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   1 +
 2 files changed, 82 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 86bfd253e295..feb94b813ffc 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -272,8 +272,8 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	return ret;
 }
 
-static void am65_cpsw_slave_set_promisc_2g(struct am65_cpsw_port *port,
-					   bool promisc)
+static void am65_cpsw_slave_set_promisc(struct am65_cpsw_port *port,
+					bool promisc)
 {
 	struct am65_cpsw_common *common = port->common;
 
@@ -298,7 +298,7 @@ static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
 	bool promisc;
 
 	promisc = !!(ndev->flags & IFF_PROMISC);
-	am65_cpsw_slave_set_promisc_2g(port, promisc);
+	am65_cpsw_slave_set_promisc(port, promisc);
 
 	if (promisc)
 		return;
@@ -629,13 +629,13 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	am65_cpsw_port_set_sl_mac(port, ndev->dev_addr);
 
-	if (port->slave.mac_only)
+	if (port->slave.mac_only) {
 		/* enable mac-only mode on port */
 		cpsw_ale_control_set(common->ale, port->port_id,
 				     ALE_PORT_MACONLY, 1);
-	if (AM65_CPSW_IS_CPSW2G(common))
 		cpsw_ale_control_set(common->ale, port->port_id,
 				     ALE_PORT_NOLEARN, 1);
+	}
 
 	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
 	cpsw_ale_add_ucast(common->ale, ndev->dev_addr,
@@ -1441,7 +1441,7 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
+static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
 	.ndo_start_xmit		= am65_cpsw_nuss_ndo_slave_xmit,
@@ -1463,7 +1463,6 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 	if (!port->disabled)
 		return;
 
-	common->disabled_ports_mask |= BIT(port->port_id);
 	cpsw_ale_control_set(common->ale, port->port_id,
 			     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
 
@@ -1832,8 +1831,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			return PTR_ERR(port->slave.mac_sl);
 
 		port->disabled = !of_device_is_available(port_np);
-		if (port->disabled)
+		if (port->disabled) {
+			common->disabled_ports_mask |= BIT(port->port_id);
 			continue;
+		}
 
 		port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
 		if (IS_ERR(port->slave.ifphy)) {
@@ -1887,6 +1888,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	}
 	of_node_put(node);
 
+	/* is there at least one ext.port */
+	if (!(~common->disabled_ports_mask & GENMASK(common->port_num, 1))) {
+		dev_err(dev, "No Ext. port are available\n");
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
@@ -1897,14 +1904,18 @@ static void am65_cpsw_pcpu_stats_free(void *data)
 	free_percpu(stats);
 }
 
-static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
+static int
+am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
 	struct am65_cpsw_ndev_priv *ndev_priv;
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
 	int ret;
 
-	port = am65_common_get_port(common, 1);
+	port = &common->ports[port_idx];
+
+	if (port->disabled)
+		return 0;
 
 	/* alloc netdev */
 	port->ndev = devm_alloc_etherdev_mqs(common->dev,
@@ -1933,7 +1944,7 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
-	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops_2g;
+	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
@@ -1946,29 +1957,41 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 
 	ret = devm_add_action_or_reset(dev, am65_cpsw_pcpu_stats_free,
 				       ndev_priv->stats);
-	if (ret) {
-		dev_err(dev, "Failed to add percpu stat free action %d\n", ret);
-		return ret;
+	if (ret)
+		dev_err(dev, "failed to add percpu stat free action %d\n", ret);
+
+	if (!common->dma_ndev)
+		common->dma_ndev = port->ndev;
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		ret = am65_cpsw_nuss_init_port_ndev(common, i);
+		if (ret)
+			return ret;
 	}
 
-	netif_napi_add(port->ndev, &common->napi_rx,
+	netif_napi_add(common->dma_ndev, &common->napi_rx,
 		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
 
 	return ret;
 }
 
-static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
+static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
-	struct am65_cpsw_port *port;
 	int i, ret = 0;
 
-	port = am65_common_get_port(common, 1);
-
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		netif_tx_napi_add(port->ndev, &tx_chn->napi_tx,
+		netif_tx_napi_add(common->dma_ndev, &tx_chn->napi_tx,
 				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
 
 		ret = devm_request_irq(dev, tx_chn->irq,
@@ -1986,16 +2009,27 @@ static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
 	return ret;
 }
 
-static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
+static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		if (port->ndev)
+			unregister_netdev(port->ndev);
+	}
+}
+
+static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
-	int ret = 0;
+	int ret = 0, i;
 
-	port = am65_common_get_port(common, 1);
-	ret = am65_cpsw_nuss_ndev_add_napi_2g(common);
+	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = devm_request_irq(dev, common->rx_chns.irq,
 			       am65_cpsw_nuss_rx_irq,
@@ -2003,17 +2037,31 @@ static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
 	if (ret) {
 		dev_err(dev, "failure requesting rx irq %u, %d\n",
 			common->rx_chns.irq, ret);
-		goto err;
+		return ret;
+	}
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+
+		if (!port->ndev)
+			continue;
+
+		ret = register_netdev(port->ndev);
+		if (ret) {
+			dev_err(dev, "error registering slave net device%i %d\n",
+				i, ret);
+			goto err_cleanup_ndev;
+		}
 	}
 
-	ret = register_netdev(port->ndev);
-	if (ret)
-		dev_err(dev, "error registering slave net device %d\n", ret);
 
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
-err:
+	return 0;
+
+err_cleanup_ndev:
+	am65_cpsw_nuss_cleanup_ndev(common);
 	return ret;
 }
 
@@ -2026,19 +2074,7 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
 	if (ret)
 		return ret;
 
-	return am65_cpsw_nuss_ndev_add_napi_2g(common);
-}
-
-static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
-{
-	struct am65_cpsw_port *port;
-	int i;
-
-	for (i = 0; i < common->port_num; i++) {
-		port = &common->ports[i];
-		if (port->ndev)
-			unregister_netdev(port->ndev);
-	}
+	return am65_cpsw_nuss_ndev_add_tx_napi(common);
 }
 
 struct am65_cpsw_soc_pdata {
@@ -2126,9 +2162,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return -ENOENT;
 	of_node_put(node);
 
-	if (common->port_num != 1)
-		return -EOPNOTSUPP;
-
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
@@ -2223,11 +2256,11 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, common);
 
-	ret = am65_cpsw_nuss_init_ndev_2g(common);
+	ret = am65_cpsw_nuss_init_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
-	ret = am65_cpsw_nuss_ndev_reg_2g(common);
+	ret = am65_cpsw_nuss_register_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 8e0dc5728253..02aed4c0ceba 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -95,6 +95,7 @@ struct am65_cpsw_common {
 	struct am65_cpsw_host   host;
 	struct am65_cpsw_port	*ports;
 	u32			disabled_ports_mask;
+	struct net_device	*dma_ndev;
 
 	int			usage_count; /* number of opened ports */
 	struct cpsw_ale		*ale;
-- 
2.17.1

