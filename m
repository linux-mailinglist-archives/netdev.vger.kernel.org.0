Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF727FDD6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgJAKyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:54:25 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34202 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732116AbgJAKx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:59 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091ArtKF098069;
        Thu, 1 Oct 2020 05:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549635;
        bh=7U60rcJagVgqZGhl4iVXfst6M+VbVwiRMgDoQ76EAl4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yhLkgG74hSWxbvICnReI1C1YbqkkdtKM+l/MZ1G2UB8s32tUpzCgbS1+4hR8mzdGj
         PqL4PEti+GywJo7ER8GJoaTHMyc/z3JQP5Xcy4hTZSsMDlF9focm4JhHdY82n9XEqG
         r4JFteupYD4eAzWeaTZ2293SLiIRj/unAmNRiPKE=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091Art1P130587
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:55 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:55 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:55 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091Arri0074487;
        Thu, 1 Oct 2020 05:53:54 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 8/8] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date:   Thu, 1 Oct 2020 13:52:58 +0300
Message-ID: <20201001105258.2139-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds final multi-port support to TI AM65x CPSW driver in
preparation for adding support for multi-port devices, like Main CPSW0 on
K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
- the separate netdev is created for every enabled external Port;
- DMA channels are common/shared for all external Ports and the RX/TX NAPI
and DMA processing assigned to first netdev;
- external Ports are configured in mac-only mode, which is similar to TI
"dual-mac" mode for legacy TI CPSW - packets are sent to the Host port only
in ingress and directly to the Port on egress. No packet switching between
external ports happens.
- every port supports the same features as current AM65x CPSW on external
device.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 111 ++++++++++++++---------
 1 file changed, 70 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index a8094e8e49ca..1658c4f305b5 100644
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
@@ -631,13 +631,13 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
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
@@ -1398,7 +1398,7 @@ static int am65_cpsw_nuss_ndo_slave_set_features(struct net_device *ndev,
 	return 0;
 }
 
-static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
+static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
 	.ndo_start_xmit		= am65_cpsw_nuss_ndo_slave_xmit,
@@ -1855,14 +1855,18 @@ static void am65_cpsw_pcpu_stats_free(void *data)
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
@@ -1891,7 +1895,7 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
-	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops_2g;
+	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
@@ -1904,18 +1908,33 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 
 	ret = devm_add_action_or_reset(dev, am65_cpsw_pcpu_stats_free,
 				       ndev_priv->stats);
-	if (ret) {
-		dev_err(dev, "Failed to add percpu stat free action %d\n", ret);
-		return ret;
+	if (ret)
+		dev_err(dev, "failed to add percpu stat free action %d\n", ret);
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int ret;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		ret = am65_cpsw_nuss_init_port_ndev(common, i);
+		if (ret)
+			return ret;
 	}
 
+	port = am65_common_get_port(common, 1);
+
 	netif_napi_add(port->ndev, &common->napi_rx,
 		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
 
 	return ret;
 }
 
-static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
+static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
@@ -1944,16 +1963,27 @@ static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
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
@@ -1961,17 +1991,31 @@ static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
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
 
@@ -1984,19 +2028,7 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
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
@@ -2084,9 +2116,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return -ENOENT;
 	of_node_put(node);
 
-	if (common->port_num != 1)
-		return -EOPNOTSUPP;
-
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
@@ -2181,11 +2210,11 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, common);
 
-	ret = am65_cpsw_nuss_init_ndev_2g(common);
+	ret = am65_cpsw_nuss_init_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
-	ret = am65_cpsw_nuss_ndev_reg_2g(common);
+	ret = am65_cpsw_nuss_register_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
-- 
2.17.1

