Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EB32C7FDF
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgK3I3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:29:18 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60862 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgK3I3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:29:17 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8SJLn117817;
        Mon, 30 Nov 2020 02:28:19 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606724899;
        bh=khXZMsNO7yAliLu4W3Acp+/GUkv4zYS9PU8esXfdH/k=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=B+aF/LX02QrZzXiTRbqnvRjRqp+l5yVdApBw8W9guYidO/0PvRUicBm4RpF8Ms0kj
         ky7dPjCYB7IbTPIuUaNXOKnsQUWcLTtqy1loFOrsP74iXRgukz3btLGeJxp2pHMMOh
         c8lh09B36J9D6cSDSwurg7Le3aV370bDlfhajce8=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU8SJTS017128
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 02:28:19 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 02:28:19 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 02:28:19 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8S9Dr057144;
        Mon, 30 Nov 2020 02:28:15 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/4] net: ti: am65-cpsw-nuss: Add devlink support
Date:   Mon, 30 Nov 2020 13:50:43 +0530
Message-ID: <20201130082046.16292-2-vigneshr@ti.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130082046.16292-1-vigneshr@ti.com>
References: <20201130082046.16292-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AM65 NUSS ethernet switch on K3 devices can be configured to work either
in independent mac mode where each port acts as independent network
interface (multi mac) or switch mode.

Add devlink hooks to provide a way to switch b/w these modes.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 .../devlink/am65-nuss-cpsw-switch.rst         |  26 ++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/ti/Kconfig               |  10 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 363 +++++++++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  22 ++
 5 files changed, 404 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/networking/devlink/am65-nuss-cpsw-switch.rst

diff --git a/Documentation/networking/devlink/am65-nuss-cpsw-switch.rst b/Documentation/networking/devlink/am65-nuss-cpsw-switch.rst
new file mode 100644
index 000000000000..1e589c26abff
--- /dev/null
+++ b/Documentation/networking/devlink/am65-nuss-cpsw-switch.rst
@@ -0,0 +1,26 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================
+am65-cpsw-nuss devlink support
+==============================
+
+This document describes the devlink features implemented by the ``am65-cpsw-nuss``
+device driver.
+
+Parameters
+==========
+
+The ``am65-cpsw-nuss`` driver implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``switch_mode``
+     - Boolean
+     - runtime
+     - Enable switch mode
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index d82874760ae2..b9064d6f4a6d 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -44,3 +44,4 @@ parameters, info versions, and other features it supports.
    sja1105
    qed
    ti-cpsw-switch
+   am65-nuss-cpsw-switch
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index abfc4c435d59..affcf92cd3aa 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -92,6 +92,7 @@ config TI_CPTS
 config TI_K3_AM65_CPSW_NUSS
 	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
+	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
 	imply PHY_TI_GMII_SEL
 	depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
@@ -105,6 +106,15 @@ config TI_K3_AM65_CPSW_NUSS
 	  To compile this driver as a module, choose M here: the module
 	  will be called ti-am65-cpsw-nuss.
 
+config TI_K3_AM65_CPSW_SWITCHDEV
+	bool "TI K3 AM654x/J721E CPSW Switch mode support"
+	depends on TI_K3_AM65_CPSW_NUSS
+	depends on NET_SWITCHDEV
+	help
+	 This enables switchdev support for TI K3 CPSWxG Ethernet
+	 Switch. Enable this driver to support hardware switch support for AM65
+	 CPSW NUSS driver.
+
 config TI_K3_AM65_CPTS
 	tristate "TI K3 AM65x CPTS"
 	depends on ARCH_K3 && OF
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 766e8866bbef..a635f6be7979 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -406,6 +406,11 @@ void am65_cpsw_nuss_set_p0_ptype(struct am65_cpsw_common *common)
 	writel(val, host_p->port_base + AM65_CPSW_PORT_REG_PRI_CTL);
 }
 
+static void am65_cpsw_init_host_port_switch(struct am65_cpsw_common *common);
+static void am65_cpsw_init_host_port_emac(struct am65_cpsw_common *common);
+static void am65_cpsw_init_port_switch_ale(struct am65_cpsw_port *port);
+static void am65_cpsw_init_port_emac_ale(struct am65_cpsw_port *port);
+
 static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 				      netdev_features_t features)
 {
@@ -452,9 +457,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 			     ALE_DEFAULT_THREAD_ID, 0);
 	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
 			     ALE_DEFAULT_THREAD_ENABLE, 1);
-	if (AM65_CPSW_IS_CPSW2G(common))
-		cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
-				     ALE_PORT_NOLEARN, 1);
 	/* switch to vlan unaware mode */
 	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_VLAN_AWARE, 1);
 	cpsw_ale_control_set(common->ale, HOST_PORT_NUM,
@@ -468,6 +470,11 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 			  port_mask, port_mask,
 			  port_mask & ~ALE_PORT_HOST);
 
+	if (common->is_emac_mode)
+		am65_cpsw_init_host_port_emac(common);
+	else
+		am65_cpsw_init_host_port_switch(common);
+
 	for (i = 0; i < common->rx_chns.descs_num; i++) {
 		skb = __netdev_alloc_skb_ip_align(NULL,
 						  AM65_CPSW_MAX_PACKET_SIZE,
@@ -596,7 +603,6 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-	u32 port_mask;
 	int ret, i;
 
 	ret = pm_runtime_get_sync(common->dev);
@@ -629,19 +635,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	am65_cpsw_port_set_sl_mac(port, ndev->dev_addr);
 
-	if (port->slave.mac_only) {
-		/* enable mac-only mode on port */
-		cpsw_ale_control_set(common->ale, port->port_id,
-				     ALE_PORT_MACONLY, 1);
-		cpsw_ale_control_set(common->ale, port->port_id,
-				     ALE_PORT_NOLEARN, 1);
-	}
-
-	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
-	cpsw_ale_add_ucast(common->ale, ndev->dev_addr,
-			   HOST_PORT_NUM, ALE_SECURE, 0);
-	cpsw_ale_add_mcast(common->ale, ndev->broadcast,
-			   port_mask, 0, 0, ALE_MCAST_FWD_2);
+	if (common->is_emac_mode)
+		am65_cpsw_init_port_emac_ale(port);
+	else
+		am65_cpsw_init_port_switch_ale(port);
 
 	/* mac_sl should be configured via phy-link interface */
 	am65_cpsw_sl_ctl_reset(port);
@@ -1441,6 +1438,13 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
+static struct devlink_port *am65_cpsw_ndo_get_devlink_port(struct net_device *ndev)
+{
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+
+	return &port->devlink_port;
+}
+
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
@@ -1454,6 +1458,7 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
+	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
 };
 
 static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
@@ -2018,6 +2023,316 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
 	}
 }
 
+static const struct devlink_ops am65_cpsw_devlink_ops = {};
+
+static void am65_cpsw_init_stp_ale_entry(struct am65_cpsw_common *cpsw)
+{
+	cpsw_ale_add_mcast(cpsw->ale, eth_stp_addr, ALE_PORT_HOST, ALE_SUPER, 0,
+			   ALE_MCAST_BLOCK_LEARN_FWD);
+}
+
+static void am65_cpsw_init_host_port_switch(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_host *host = am65_common_get_host(common);
+
+	writel(common->default_vlan, host->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
+	am65_cpsw_init_stp_ale_entry(common);
+
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_P0_UNI_FLOOD, 1);
+	dev_dbg(common->dev, "Set P0_UNI_FLOOD\n");
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_PORT_NOLEARN, 0);
+}
+
+static void am65_cpsw_init_host_port_emac(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_host *host = am65_common_get_host(common);
+
+	writel(0, host->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_P0_UNI_FLOOD, 0);
+	dev_dbg(common->dev, "unset P0_UNI_FLOOD\n");
+
+	/* learning make no sense in multi-mac mode */
+	cpsw_ale_control_set(common->ale, HOST_PORT_NUM, ALE_PORT_NOLEARN, 1);
+}
+
+static int am65_cpsw_dl_switch_mode_get(struct devlink *dl, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct am65_cpsw_devlink *dl_priv = devlink_priv(dl);
+	struct am65_cpsw_common *common = dl_priv->common;
+
+	dev_dbg(common->dev, "%s id:%u\n", __func__, id);
+
+	if (id != AM65_CPSW_DL_PARAM_SWITCH_MODE)
+		return -EOPNOTSUPP;
+
+	ctx->val.vbool = !common->is_emac_mode;
+
+	return 0;
+}
+
+static void am65_cpsw_init_port_emac_ale(struct  am65_cpsw_port *port)
+{
+	struct am65_cpsw_slave_data *slave = &port->slave;
+	struct am65_cpsw_common *common = port->common;
+	u32 port_mask;
+
+	writel(slave->port_vlan, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
+	if (slave->mac_only)
+		/* enable mac-only mode on port */
+		cpsw_ale_control_set(common->ale, port->port_id,
+				     ALE_PORT_MACONLY, 1);
+
+	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_NOLEARN, 1);
+
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
+
+	cpsw_ale_add_ucast(common->ale, port->ndev->dev_addr,
+			   HOST_PORT_NUM, ALE_SECURE, slave->port_vlan);
+	cpsw_ale_add_mcast(common->ale, port->ndev->broadcast,
+			   port_mask, ALE_VLAN, slave->port_vlan, ALE_MCAST_FWD_2);
+}
+
+static void am65_cpsw_init_port_switch_ale(struct am65_cpsw_port *port)
+{
+	struct am65_cpsw_slave_data *slave = &port->slave;
+	struct am65_cpsw_common *cpsw = port->common;
+	u32 port_mask;
+
+	cpsw_ale_control_set(cpsw->ale, port->port_id,
+			     ALE_PORT_NOLEARN, 0);
+
+	cpsw_ale_add_ucast(cpsw->ale, port->ndev->dev_addr,
+			   HOST_PORT_NUM, ALE_SECURE | ALE_BLOCKED | ALE_VLAN,
+			   slave->port_vlan);
+
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
+
+	cpsw_ale_add_mcast(cpsw->ale, port->ndev->broadcast,
+			   port_mask, ALE_VLAN, slave->port_vlan,
+			   ALE_MCAST_FWD_2);
+
+	writel(slave->port_vlan, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
+	cpsw_ale_control_set(cpsw->ale, port->port_id,
+			     ALE_PORT_MACONLY, 0);
+}
+
+static int am65_cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct am65_cpsw_devlink *dl_priv = devlink_priv(dl);
+	struct am65_cpsw_common *cpsw = dl_priv->common;
+	bool switch_en = ctx->val.vbool;
+	bool if_running = false;
+	int i;
+
+	dev_dbg(cpsw->dev, "%s id:%u\n", __func__, id);
+
+	if (id != AM65_CPSW_DL_PARAM_SWITCH_MODE)
+		return -EOPNOTSUPP;
+
+	if (switch_en == !cpsw->is_emac_mode)
+		return 0;
+
+	if (!switch_en && cpsw->br_members) {
+		dev_err(cpsw->dev, "Remove ports from bridge before disabling switch mode\n");
+		return -EINVAL;
+	}
+
+	rtnl_lock();
+
+	cpsw->is_emac_mode = !switch_en;
+
+	for (i = 0; i < cpsw->port_num; i++) {
+		struct net_device *sl_ndev = cpsw->ports[i].ndev;
+
+		if (!sl_ndev || !netif_running(sl_ndev))
+			continue;
+
+		if_running = true;
+	}
+
+	if (!if_running) {
+		/* all ndevs are down */
+		for (i = 0; i < cpsw->port_num; i++) {
+			struct net_device *sl_ndev = cpsw->ports[i].ndev;
+			struct am65_cpsw_slave_data *slave;
+
+			if (!sl_ndev)
+				continue;
+
+			slave = am65_ndev_to_slave(sl_ndev);
+			if (switch_en)
+				slave->port_vlan = cpsw->default_vlan;
+			else
+				slave->port_vlan = 0;
+		}
+
+		goto exit;
+	}
+
+	cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS, 1);
+	/* clean up ALE table */
+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM, ALE_CLEAR, 1);
+	cpsw_ale_control_get(cpsw->ale, HOST_PORT_NUM, ALE_AGEOUT);
+
+	if (switch_en) {
+		dev_info(cpsw->dev, "Enable switch mode\n");
+
+		am65_cpsw_init_host_port_switch(cpsw);
+
+		for (i = 0; i < cpsw->port_num; i++) {
+			struct net_device *sl_ndev = cpsw->ports[i].ndev;
+			struct am65_cpsw_slave_data *slave;
+			struct am65_cpsw_port *port;
+
+			if (!sl_ndev)
+				continue;
+
+			port = am65_ndev_to_port(sl_ndev);
+			slave = am65_ndev_to_slave(sl_ndev);
+			slave->port_vlan = cpsw->default_vlan;
+
+			if (netif_running(sl_ndev))
+				am65_cpsw_init_port_switch_ale(port);
+		}
+
+	} else {
+		dev_info(cpsw->dev, "Disable switch mode\n");
+
+		am65_cpsw_init_host_port_emac(cpsw);
+
+		for (i = 0; i < cpsw->port_num; i++) {
+			struct net_device *sl_ndev = cpsw->ports[i].ndev;
+			struct am65_cpsw_port *port;
+
+			if (!sl_ndev)
+				continue;
+
+			port = am65_ndev_to_port(sl_ndev);
+			port->slave.port_vlan = 0;
+			if (netif_running(sl_ndev))
+				am65_cpsw_init_port_emac_ale(port);
+		}
+	}
+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM, ALE_BYPASS, 0);
+exit:
+	rtnl_unlock();
+
+	return 0;
+}
+
+static const struct devlink_param am65_cpsw_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(AM65_CPSW_DL_PARAM_SWITCH_MODE, "switch_mode",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     am65_cpsw_dl_switch_mode_get,
+			     am65_cpsw_dl_switch_mode_set, NULL),
+};
+
+static void am65_cpsw_unregister_devlink_ports(struct am65_cpsw_common *common)
+{
+	struct devlink_port *dl_port;
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 1; i <= common->port_num; i++) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		if (dl_port->registered)
+			devlink_port_unregister(dl_port);
+	}
+}
+
+static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
+{
+	struct devlink_port_attrs attrs = {};
+	struct am65_cpsw_devlink *dl_priv;
+	struct device *dev = common->dev;
+	struct devlink_port *dl_port;
+	struct am65_cpsw_port *port;
+	int ret = 0;
+	int i;
+
+	common->devlink =
+		devlink_alloc(&am65_cpsw_devlink_ops, sizeof(*dl_priv));
+	if (!common->devlink)
+		return -ENOMEM;
+
+	dl_priv = devlink_priv(common->devlink);
+	dl_priv->common = common;
+
+	ret = devlink_register(common->devlink, dev);
+	if (ret) {
+		dev_err(dev, "devlink reg fail ret:%d\n", ret);
+		goto dl_free;
+	}
+
+	/* Provide devlink hook to switch mode when multiple external ports
+	 * are present NUSS switchdev driver is enabled.
+	 */
+	if (!AM65_CPSW_IS_CPSW2G(common) &&
+	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
+		ret = devlink_params_register(common->devlink,
+					      am65_cpsw_devlink_params,
+					      ARRAY_SIZE(am65_cpsw_devlink_params));
+		if (ret) {
+			dev_err(dev, "devlink params reg fail ret:%d\n", ret);
+			goto dl_unreg;
+		}
+		devlink_params_publish(common->devlink);
+	}
+
+	for (i = 1; i <= common->port_num; i++) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = port->port_id;
+		attrs.switch_id.id_len = sizeof(resource_size_t);
+		memcpy(attrs.switch_id.id, common->switch_id, attrs.switch_id.id_len);
+		devlink_port_attrs_set(dl_port, &attrs);
+
+		ret = devlink_port_register(common->devlink, dl_port, port->port_id);
+		if (ret) {
+			dev_err(dev, "devlink_port reg fail for port %d, ret:%d\n",
+				port->port_id, ret);
+			goto dl_port_unreg;
+		}
+		devlink_port_type_eth_set(dl_port, port->ndev);
+	}
+
+	return ret;
+
+dl_port_unreg:
+	am65_cpsw_unregister_devlink_ports(common);
+dl_unreg:
+	devlink_unregister(common->devlink);
+dl_free:
+	devlink_free(common->devlink);
+
+	return ret;
+}
+
+static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
+{
+	if (!AM65_CPSW_IS_CPSW2G(common) &&
+	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
+		devlink_params_unpublish(common->devlink);
+		devlink_params_unregister(common->devlink, am65_cpsw_devlink_params,
+					  ARRAY_SIZE(am65_cpsw_devlink_params));
+	}
+
+	am65_cpsw_unregister_devlink_ports(common);
+	devlink_unregister(common->devlink);
+	devlink_free(common->devlink);
+}
+
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
@@ -2051,12 +2366,15 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		}
 	}
 
+	ret = am65_cpsw_nuss_register_devlink(common);
+	if (ret)
+		goto err_cleanup_ndev;
 
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
-	return 0;
 
+	return 0;
 err_cleanup_ndev:
 	am65_cpsw_nuss_cleanup_ndev(common);
 	return ret;
@@ -2131,6 +2449,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	struct device_node *node;
 	struct resource *res;
 	struct clk *clk;
+	u64 id_temp;
 	int ret, i;
 
 	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
@@ -2150,6 +2469,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (IS_ERR(common->ss_base))
 		return PTR_ERR(common->ss_base);
 	common->cpsw_base = common->ss_base + AM65_CPSW_CPSW_NU_BASE;
+	/* Use device's physical base address as switch id */
+	id_temp = cpu_to_be64(res->start);
+	memcpy(common->switch_id, &id_temp, sizeof(res->start));
 
 	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
 	if (!node)
@@ -2163,6 +2485,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
 	common->pf_p0_rx_ptype_rrobin = false;
+	common->default_vlan = 1;
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
@@ -2248,6 +2571,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, common);
 
+	common->is_emac_mode = true;
+
 	ret = am65_cpsw_nuss_init_ndevs(common);
 	if (ret)
 		goto err_of_clear;
@@ -2281,6 +2606,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 		return ret;
 	}
 
+	am65_cpsw_unregister_devlink(common);
+
 	/* must unregister ndevs here because DD release_driver routine calls
 	 * dma_deconfigure(dev) before devres_release_all(dev)
 	 */
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 02aed4c0ceba..153181e894b2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -6,12 +6,14 @@
 #ifndef AM65_CPSW_NUSS_H_
 #define AM65_CPSW_NUSS_H_
 
+#include <linux/if_ether.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ti/k3-ringacc.h>
+#include <net/devlink.h>
 #include "am65-cpsw-qos.h"
 
 struct am65_cpts;
@@ -22,6 +24,8 @@ struct am65_cpts;
 #define AM65_CPSW_MAX_RX_QUEUES	1
 #define AM65_CPSW_MAX_RX_FLOWS	1
 
+#define AM65_CPSW_PORT_VLAN_REG_OFFSET	0x014
+
 struct am65_cpsw_slave_data {
 	bool				mac_only;
 	struct cpsw_sl			*mac_sl;
@@ -32,6 +36,7 @@ struct am65_cpsw_slave_data {
 	bool				rx_pause;
 	bool				tx_pause;
 	u8				mac_addr[ETH_ALEN];
+	int				port_vlan;
 };
 
 struct am65_cpsw_port {
@@ -47,6 +52,7 @@ struct am65_cpsw_port {
 	bool				tx_ts_enabled;
 	bool				rx_ts_enabled;
 	struct am65_cpsw_qos		qos;
+	struct devlink_port		devlink_port;
 };
 
 struct am65_cpsw_host {
@@ -83,6 +89,15 @@ struct am65_cpsw_pdata {
 	const char	*ale_dev_id;
 };
 
+enum cpsw_devlink_param_id {
+	AM65_CPSW_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	AM65_CPSW_DL_PARAM_SWITCH_MODE,
+};
+
+struct am65_cpsw_devlink {
+	struct am65_cpsw_common *common;
+};
+
 struct am65_cpsw_common {
 	struct device		*dev;
 	struct device		*mdio_dev;
@@ -115,6 +130,12 @@ struct am65_cpsw_common {
 	bool			pf_p0_rx_ptype_rrobin;
 	struct am65_cpts	*cpts;
 	int			est_enabled;
+
+	bool		is_emac_mode;
+	u16			br_members;
+	int			default_vlan;
+	struct devlink *devlink;
+	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
 };
 
 struct am65_cpsw_ndev_stats {
@@ -129,6 +150,7 @@ struct am65_cpsw_ndev_priv {
 	u32			msg_enable;
 	struct am65_cpsw_port	*port;
 	struct am65_cpsw_ndev_stats __percpu *stats;
+	bool offload_fwd_mark;
 };
 
 #define am65_ndev_to_priv(ndev) \
-- 
2.29.2

