Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20F34EE84
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfFUSOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:24 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37646 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFUSOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIE4Np094244;
        Fri, 21 Jun 2019 13:14:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140844;
        bh=ENjsN5kegksVeR5oY2u4VrTQckpq6CeGJZrWqofChw4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qbeahvbOJpHYR25uUJyiXEfQtZF8hDVkFj+oQij1gfvYElw8kunoMhnR+Gn+n4M73
         E2bMz8iePDvYmj2doCUWcGUkzlNDEx/4BLGbA6LPrEnpzKJPM/zVisTF4hdE8KPML5
         lokTko8UicjPRqjAD6rJAhhpXDZPCIMNy8MQoPl0=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIE4p0118333
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:14:04 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:14:04 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:14:03 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIE2OR029576;
        Fri, 21 Jun 2019 13:14:03 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 07/11] net: ethernet: ti: introduce cpsw switchdev based driver part 2 - switch
Date:   Fri, 21 Jun 2019 21:13:10 +0300
Message-ID: <20190621181314.20778-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

CPSW switchdev based driver which is operating in dual-emac mode by
default, thus working as 2 individual network interfaces. The Switch mode
can be enabled by configuring devlink driver parameter "switch_mode" to 1:

	devlink dev param set platform/48484000.ethernet_switch \
	name switch_mode value 1 cmode runtime

This can be done regardless of the state of Port's netdevs - UP/DOWN, but
Port's netdev devices have to be in UP before joining the bridge to avoid
overwriting of bridge configuration as CPSW switch driver completely
reloads its configuration when first Port changes its state to UP.
When the both interfaces joined the bridge - CPSW switch driver will start
marking packets with offload_fwd_mark flag unless "ale_bypass=0".

All configuration is implemented via switchdev API and notifiers.
Supported:
 - SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
 - SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS: BR_MCAST_FLOOD
 - SWITCHDEV_ATTR_ID_PORT_STP_STATE
 - SWITCHDEV_OBJ_ID_PORT_VLAN
 - SWITCHDEV_OBJ_ID_PORT_MDB
 - SWITCHDEV_OBJ_ID_HOST_MDB

Hence CPSW switchdev driver supports:
- FDB offloading
- MDB offloading
- VLAN filtering and offloading
- STP

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/Makefile         |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c       | 372 +++++++++++++-
 drivers/net/ethernet/ti/cpsw_priv.h      |   5 +
 drivers/net/ethernet/ti/cpsw_switchdev.c | 589 +++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_switchdev.h |  15 +
 5 files changed, 975 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_switchdev.h

diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index c59670956ed3..d34df8e5cf94 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_TI_CPTS_MOD) += cpts.o
 obj-$(CONFIG_TI_CPSW) += ti_cpsw.o
 ti_cpsw-y := cpsw.o davinci_cpdma.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
 obj-$(CONFIG_TI_CPSW_SWITCHDEV) += ti_cpsw_new.o
-ti_cpsw_new-y := cpsw_new.o davinci_cpdma.o cpsw_ale.o cpsw_sl.o cpsw_priv.o cpsw_ethtool.o
+ti_cpsw_new-y := cpsw_switchdev.o cpsw_new.o davinci_cpdma.o cpsw_ale.o cpsw_sl.o cpsw_priv.o cpsw_ethtool.o
 
 obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
 keystone_netcp-y := netcp_core.o cpsw_ale.o
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 25fd83f3531e..9083ef33c271 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -35,6 +35,7 @@
 #include "cpsw_ale.h"
 #include "cpsw_priv.h"
 #include "cpsw_sl.h"
+#include "cpsw_switchdev.h"
 #include "cpts.h"
 #include "davinci_cpdma.h"
 
@@ -51,6 +52,7 @@ struct cpsw_devlink {
 
 enum cpsw_devlink_param_id {
 	CPSW_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	CPSW_DL_PARAM_SWITCH_MODE,
 	CPSW_DL_PARAM_ALE_BYPASS,
 };
 
@@ -66,12 +68,20 @@ static int cpsw_slave_index_priv(struct cpsw_common *cpsw,
 	return priv->emac_port - 1;
 }
 
+static bool cpsw_is_switch_en(struct cpsw_common *cpsw)
+{
+	return !cpsw->data.dual_emac;
+}
+
 static void cpsw_set_promiscious(struct net_device *ndev, bool enable)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	bool enable_uni = false;
 	int i;
 
+	if (cpsw_is_switch_en(cpsw))
+		return;
+
 	/* Enabling promiscuous mode for one interface will be
 	 * common for both the interface as the interface shares
 	 * the same hardware resource.
@@ -297,6 +307,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	priv = netdev_priv(ndev);
+	skb->offload_fwd_mark = priv->offload_fwd_mark;
 
 	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
 	if (new_skb) {
@@ -335,8 +346,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		dev_kfree_skb_any(new_skb);
 }
 
-static inline int cpsw_add_vlan_ale_entry(struct cpsw_priv *priv,
-					  unsigned short vid)
+static int cpsw_add_vlan_ale_entry(struct cpsw_priv *priv,
+				   unsigned short vid)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	int unreg_mcast_mask = 0;
@@ -381,6 +392,11 @@ static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 	struct cpsw_common *cpsw = priv->cpsw;
 	int ret, i;
 
+	if (cpsw_is_switch_en(cpsw)) {
+		dev_dbg(cpsw->dev, ".ndo_vlan_rx_add_vid called in switch mode\n");
+		return 0;
+	}
+
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
@@ -435,9 +451,36 @@ static void cpsw_restore(struct cpsw_priv *priv)
 	cpsw_cbs_resume(&cpsw->slaves[priv->emac_port - 1], priv);
 }
 
-static void cpsw_init_host_port_dual_mac(struct cpsw_priv *priv)
+static void cpsw_init_stp_ale_entry(struct cpsw_common *cpsw)
+{
+	char stpa[] = {0x01, 0x80, 0xc2, 0x0, 0x0, 0x0};
+
+	cpsw_ale_add_mcast(cpsw->ale, stpa,
+			   ALE_PORT_HOST, ALE_SUPER, 0,
+			   ALE_MCAST_BLOCK_LEARN_FWD);
+}
+
+static void cpsw_init_host_port_switch(struct cpsw_common *cpsw)
+{
+	int vlan = cpsw->data.default_vlan;
+
+	writel(CPSW_FIFO_NORMAL_MODE, &cpsw->host_port_regs->tx_in_ctl);
+
+	writel(vlan, &cpsw->host_port_regs->port_vlan);
+
+	cpsw_ale_add_vlan(cpsw->ale, vlan, ALE_ALL_PORTS,
+			  ALE_ALL_PORTS, ALE_ALL_PORTS,
+			  ALE_PORT_1 | ALE_PORT_2);
+
+	cpsw_init_stp_ale_entry(cpsw);
+
+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM, ALE_P0_UNI_FLOOD, 1);
+	dev_dbg(cpsw->dev, "Set P0_UNI_FLOOD\n");
+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM, ALE_PORT_NOLEARN, 0);
+}
+
+static void cpsw_init_host_port_dual_mac(struct cpsw_common *cpsw)
 {
-	struct cpsw_common *cpsw = priv->cpsw;
 	int vlan = cpsw->data.default_vlan;
 
 	writel(CPSW_FIFO_DUAL_MAC_MODE, &cpsw->host_port_regs->tx_in_ctl);
@@ -482,7 +525,10 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	/* Enable internal fifo flow control */
 	writel(0x7, &cpsw->regs->flow_control);
 
-	cpsw_init_host_port_dual_mac(priv);
+	if (cpsw_is_switch_en(cpsw))
+		cpsw_init_host_port_switch(cpsw);
+	else
+		cpsw_init_host_port_dual_mac(cpsw);
 
 	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM,
 			     ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
@@ -514,6 +560,41 @@ static void cpsw_port_add_dual_emac_def_ale_entries(struct cpsw_priv *priv,
 			     ALE_PORT_NOLEARN, 1);
 }
 
+static void cpsw_port_add_switch_def_ale_entries(struct cpsw_priv *priv,
+						 struct cpsw_slave *slave)
+{
+	u32 port_mask = 1 << priv->emac_port | ALE_PORT_HOST;
+	struct cpsw_common *cpsw = priv->cpsw;
+	u32 reg;
+
+	cpsw_ale_control_set(cpsw->ale, priv->emac_port,
+			     ALE_PORT_DROP_UNKNOWN_VLAN, 0);
+	cpsw_ale_control_set(cpsw->ale, priv->emac_port,
+			     ALE_PORT_NOLEARN, 0);
+	/* disabling SA_UPDATE required to make stp work, without this setting
+	 * Host MAC addresses will jump between ports.
+	 * As per TRM MAC address can be defined as unicast supervisory (super)
+	 * by setting both (ALE_BLOCKED | ALE_SECURE) which should prevent
+	 * SA_UPDATE, but HW seems works incorrectly and setting ALE_SECURE
+	 * causes STP packets to be dropped due to ingress filter
+	 *	if (source address found) and (secure) and
+	 *	   (receive port number != port_number))
+	 *	   then discard the packet
+	 */
+	cpsw_ale_control_set(cpsw->ale, priv->emac_port,
+			     ALE_PORT_NO_SA_UPDATE, 1);
+
+	cpsw_ale_add_mcast(cpsw->ale, priv->ndev->broadcast,
+			   port_mask, ALE_VLAN, slave->port_vlan,
+			   ALE_MCAST_FWD_2);
+	cpsw_ale_add_ucast(cpsw->ale, priv->mac_addr,
+			   HOST_PORT_NUM, ALE_VLAN, slave->port_vlan);
+
+	reg = (cpsw->version == CPSW_VERSION_1) ? CPSW1_PORT_VLAN :
+	       CPSW2_PORT_VLAN;
+	slave_write(slave, slave->port_vlan, reg);
+}
+
 static void cpsw_adjust_link(struct net_device *ndev)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
@@ -623,7 +704,10 @@ static void cpsw_slave_open(struct cpsw_slave *slave, struct cpsw_priv *priv)
 
 	slave->mac_control = 0;	/* no link yet */
 
-	cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
+	if (cpsw_is_switch_en(cpsw))
+		cpsw_port_add_switch_def_ale_entries(priv, slave);
+	else
+		cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
 
 	if (!slave->data->phy_node)
 		dev_err(priv->dev, "no phy found on slave %d\n",
@@ -671,7 +755,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 	struct cpsw_common *cpsw = priv->cpsw;
 	int ret;
 
-	cpsw_info(priv, ifdown, "starting ndev\n");
+	dev_info(priv->dev, "starting ndev. mode: %s\n",
+		 cpsw_is_switch_en(cpsw) ? "switch" : "dual_mac");
 	ret = pm_runtime_get_sync(cpsw->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(cpsw->dev);
@@ -878,6 +963,11 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 	int ret;
 	int i;
 
+	if (cpsw_is_switch_en(cpsw)) {
+		dev_dbg(cpsw->dev, "ndo del vlan is called in switch mode\n");
+		return 0;
+	}
+
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
@@ -931,6 +1021,17 @@ static void cpsw_ndo_poll_controller(struct net_device *ndev)
 }
 #endif
 
+static int cpsw_get_port_parent_id(struct net_device *ndev,
+				   struct netdev_phys_item_id *ppid)
+{
+	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
+
+	ppid->id_len = sizeof(cpsw->base_mac);
+	memcpy(&ppid->id, &cpsw->base_mac, ppid->id_len);
+
+	return 0;
+}
+
 static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_open		= cpsw_ndo_open,
 	.ndo_stop		= cpsw_ndo_stop,
@@ -948,6 +1049,7 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= cpsw_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc           = cpsw_ndo_setup_tc,
 	.ndo_get_phys_port_name = cpsw_ndo_get_phys_port_name,
+	.ndo_get_port_parent_id	= cpsw_get_port_parent_id,
 };
 
 static void cpsw_get_drvinfo(struct net_device *ndev,
@@ -1245,8 +1347,249 @@ static void cpsw_unregister_ports(struct cpsw_common *cpsw)
 	}
 }
 
+bool cpsw_port_dev_check(const struct net_device *ndev)
+{
+	if (ndev->netdev_ops == &cpsw_netdev_ops) {
+		struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
+
+		return !cpsw->data.dual_emac;
+	}
+
+	return false;
+}
+
+void cpsw_port_offload_fwd_mark_update(struct cpsw_common *cpsw)
+{
+	int set_val = 0;
+	int i;
+
+	if (!cpsw->ale_bypass &&
+	    (cpsw->br_members == (ALE_PORT_1 | ALE_PORT_2)))
+		set_val = 1;
+
+	dev_dbg(cpsw->dev, "set offload_fwd_mark %d\n", set_val);
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *sl_ndev = cpsw->slaves[i].ndev;
+		struct cpsw_priv *priv = netdev_priv(sl_ndev);
+
+		priv->offload_fwd_mark = set_val;
+	}
+}
+
+static int cpsw_netdevice_port_link(struct net_device *ndev,
+				    struct net_device *br_ndev)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+
+	if (!cpsw->br_members) {
+		cpsw->hw_bridge_dev = br_ndev;
+	} else {
+		/* This is adding the port to a second bridge, this is
+		 * unsupported
+		 */
+		if (cpsw->hw_bridge_dev != br_ndev)
+			return -EOPNOTSUPP;
+	}
+
+	cpsw->br_members |= BIT(priv->emac_port);
+
+	cpsw_port_offload_fwd_mark_update(cpsw);
+
+	return NOTIFY_DONE;
+}
+
+static void cpsw_netdevice_port_unlink(struct net_device *ndev)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+
+	cpsw->br_members &= ~BIT(priv->emac_port);
+
+	cpsw_port_offload_fwd_mark_update(cpsw);
+
+	if (!cpsw->br_members)
+		cpsw->hw_bridge_dev = NULL;
+}
+
+/* netdev notifier */
+static int cpsw_netdevice_event(struct notifier_block *unused,
+				unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info;
+	int ret = NOTIFY_DONE;
+
+	if (!cpsw_port_dev_check(ndev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		info = ptr;
+
+		if (netif_is_bridge_master(info->upper_dev)) {
+			if (info->linking)
+				ret = cpsw_netdevice_port_link(ndev,
+							       info->upper_dev);
+			else
+				cpsw_netdevice_port_unlink(ndev);
+		}
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block cpsw_netdevice_nb __read_mostly = {
+	.notifier_call = cpsw_netdevice_event,
+};
+
+static int cpsw_register_notifiers(struct cpsw_common *cpsw)
+{
+	int ret = 0;
+
+	ret = register_netdevice_notifier(&cpsw_netdevice_nb);
+	if (ret) {
+		dev_err(cpsw->dev, "can't register netdevice notifier\n");
+		return ret;
+	}
+
+	ret = cpsw_switchdev_register_notifiers(cpsw);
+	if (ret)
+		unregister_netdevice_notifier(&cpsw_netdevice_nb);
+
+	return ret;
+}
+
+static void cpsw_unregister_notifiers(struct cpsw_common *cpsw)
+{
+	cpsw_switchdev_unregister_notifiers(cpsw);
+	unregister_netdevice_notifier(&cpsw_netdevice_nb);
+}
+
 static const struct devlink_ops cpsw_devlink_ops;
 
+static int cpsw_dl_switch_mode_get(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct cpsw_devlink *dl_priv = devlink_priv(dl);
+	struct cpsw_common *cpsw = dl_priv->cpsw;
+
+	dev_dbg(cpsw->dev, "%s id:%u\n", __func__, id);
+
+	if (id != CPSW_DL_PARAM_SWITCH_MODE)
+		return  -EOPNOTSUPP;
+
+	ctx->val.vbool = !cpsw->data.dual_emac;
+
+	return 0;
+}
+
+static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct cpsw_devlink *dl_priv = devlink_priv(dl);
+	struct cpsw_common *cpsw = dl_priv->cpsw;
+	int vlan = cpsw->data.default_vlan;
+	bool switch_en = ctx->val.vbool;
+	bool if_running = false;
+	int i;
+
+	dev_dbg(cpsw->dev, "%s id:%u\n", __func__, id);
+
+	if (id != CPSW_DL_PARAM_SWITCH_MODE)
+		return  -EOPNOTSUPP;
+
+	if (switch_en == !cpsw->data.dual_emac)
+		return 0;
+
+	if (!switch_en && cpsw->br_members) {
+		dev_err(cpsw->dev, "Remove ports from BR before disabling switch mode\n");
+		return -EINVAL;
+	}
+
+	rtnl_lock();
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct cpsw_slave *slave = &cpsw->slaves[i];
+		struct net_device *sl_ndev = slave->ndev;
+
+		if (!sl_ndev || !netif_running(sl_ndev))
+			continue;
+
+		if_running = true;
+	}
+
+	if (!if_running) {
+		/* all ndevs are down */
+		cpsw->data.dual_emac = !switch_en;
+		goto exit;
+	}
+
+	if (switch_en) {
+		dev_info(cpsw->dev, "Enable switch mode\n");
+
+		/* enable bypass - no forwarding; all traffic goes to Host */
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS, 1);
+
+		/* clean up ALE table */
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_CLEAR, 1);
+		cpsw_ale_control_get(cpsw->ale, 0, ALE_AGEOUT);
+
+		cpsw_init_host_port_switch(cpsw);
+
+		for (i = 0; i < cpsw->data.slaves; i++) {
+			struct cpsw_slave *slave = &cpsw->slaves[i];
+			struct net_device *sl_ndev = slave->ndev;
+			struct cpsw_priv *priv;
+
+			if (!sl_ndev)
+				continue;
+
+			priv = netdev_priv(sl_ndev);
+			slave->port_vlan = vlan;
+			cpsw_port_add_switch_def_ale_entries(priv, slave);
+		}
+
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS, 0);
+		cpsw->data.dual_emac = false;
+	} else {
+		dev_info(cpsw->dev, "Disable switch mode\n");
+
+		/* enable bypass - no forwarding; all traffic goes to Host */
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS, 1);
+
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_CLEAR, 1);
+		cpsw_ale_control_get(cpsw->ale, 0, ALE_AGEOUT);
+
+		cpsw_init_host_port_dual_mac(cpsw);
+
+		for (i = 0; i < cpsw->data.slaves; i++) {
+			struct cpsw_slave *slave = &cpsw->slaves[i];
+			struct net_device *sl_ndev = slave->ndev;
+			struct cpsw_priv *priv;
+
+			if (!sl_ndev)
+				continue;
+
+			priv = netdev_priv(slave->ndev);
+			slave->port_vlan = slave->data->dual_emac_res_vlan;
+
+			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
+		}
+
+		cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS, 0);
+		cpsw->data.dual_emac = true;
+	}
+exit:
+	rtnl_unlock();
+
+	return 0;
+}
+
 static int cpsw_dl_ale_ctrl_get(struct devlink *dl, u32 id,
 				struct devlink_param_gset_ctx *ctx)
 {
@@ -1279,6 +1622,10 @@ static int cpsw_dl_ale_ctrl_set(struct devlink *dl, u32 id,
 	case CPSW_DL_PARAM_ALE_BYPASS:
 		ret = cpsw_ale_control_set(cpsw->ale, 0, ALE_BYPASS,
 					   ctx->val.vbool);
+		if (!ret) {
+			cpsw->ale_bypass = ctx->val.vbool;
+			cpsw_port_offload_fwd_mark_update(cpsw);
+		}
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1288,6 +1635,11 @@ static int cpsw_dl_ale_ctrl_set(struct devlink *dl, u32 id,
 }
 
 static const struct devlink_param cpsw_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_SWITCH_MODE,
+			     "switch_mode", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     cpsw_dl_switch_mode_get, cpsw_dl_switch_mode_set,
+			     NULL),
 	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_ALE_BYPASS,
 			     "ale_bypass", DEVLINK_PARAM_TYPE_BOOL,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
@@ -1437,6 +1789,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	cpsw->rx_packet_max = rx_packet_max;
 	cpsw->descs_pool_size = descs_pool_size;
+	eth_random_addr(cpsw->base_mac);
 
 	ret = cpsw_init_common(cpsw, ss_regs, ale_ageout,
 			       (u32 __force)ss_res->start + CPSW2_BD_OFFSET,
@@ -1491,6 +1844,10 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_unregister_netdev;
 	}
 
+	ret = cpsw_register_notifiers(cpsw);
+	if (ret)
+		goto clean_unregister_netdev;
+
 	ret = cpsw_register_devlink(cpsw);
 	if (ret)
 		goto clean_unregister_netdev;
@@ -1529,6 +1886,7 @@ static int cpsw_remove(struct platform_device *pdev)
 		return ret;
 	}
 
+	cpsw_unregister_notifiers(cpsw);
 	cpsw_unregister_devlink(cpsw);
 	cpsw_unregister_ports(cpsw);
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 7f272df01e5d..8eb4c1527855 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -354,6 +354,10 @@ struct cpsw_common {
 	int				rx_ch_num, tx_ch_num;
 	int				speed;
 	int				usage_count;
+	u8 br_members;
+	struct net_device *hw_bridge_dev;
+	bool ale_bypass;
+	u8 base_mac[ETH_ALEN];
 };
 
 struct cpsw_priv {
@@ -370,6 +374,7 @@ struct cpsw_priv {
 	int				rx_ts_enabled;
 	u32 emac_port;
 	struct cpsw_common *cpsw;
+	int offload_fwd_mark;
 };
 
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
new file mode 100644
index 000000000000..985a929bb957
--- /dev/null
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -0,0 +1,589 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Texas Instruments switchdev Driver
+ *
+ * Copyright (C) 2019 Texas Instruments
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <net/switchdev.h>
+
+#include "cpsw.h"
+#include "cpsw_ale.h"
+#include "cpsw_priv.h"
+#include "cpsw_switchdev.h"
+
+struct cpsw_switchdev_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct cpsw_priv *priv;
+	unsigned long event;
+};
+
+static int cpsw_port_stp_state_set(struct cpsw_priv *priv,
+				   struct switchdev_trans *trans, u8 state)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	u8 cpsw_state;
+	int ret = 0;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		cpsw_state = ALE_PORT_STATE_FORWARD;
+		break;
+	case BR_STATE_LEARNING:
+		cpsw_state = ALE_PORT_STATE_LEARN;
+		break;
+	case BR_STATE_DISABLED:
+		cpsw_state = ALE_PORT_STATE_DISABLE;
+		break;
+	case BR_STATE_LISTENING:
+	case BR_STATE_BLOCKING:
+		cpsw_state = ALE_PORT_STATE_BLOCK;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = cpsw_ale_control_set(cpsw->ale, priv->emac_port,
+				   ALE_PORT_STATE, cpsw_state);
+	dev_dbg(priv->dev, "ale state: %u\n", cpsw_state);
+
+	return ret;
+}
+
+static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
+				       struct switchdev_trans *trans,
+				       struct net_device *orig_dev,
+				       unsigned long brport_flags)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	bool unreg_mcast_add = false;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (brport_flags & BR_MCAST_FLOOD)
+		unreg_mcast_add = true;
+	dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
+		unreg_mcast_add, priv->emac_port);
+
+	cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(priv->emac_port),
+				 unreg_mcast_add);
+
+	return 0;
+}
+
+static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
+					   struct switchdev_trans *trans,
+					   unsigned long flags)
+{
+	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cpsw_port_attr_set(struct net_device *ndev,
+			      const struct switchdev_attr *attr,
+			      struct switchdev_trans *trans)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	dev_dbg(priv->dev, "attr: id %u port: %u\n", attr->id, priv->emac_port);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		ret = cpsw_port_attr_br_flags_pre_set(ndev, trans,
+						      attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		ret = cpsw_port_stp_state_set(priv, trans, attr->u.stp_state);
+		dev_dbg(priv->dev, "stp state: %u\n", attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		ret = cpsw_port_attr_br_flags_set(priv, trans, attr->orig_dev,
+						  attr->u.brport_flags);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static u16 cpsw_get_pvid(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	u32 __iomem *port_vlan_reg;
+	u32 pvid;
+
+	if (priv->emac_port) {
+		int reg = CPSW2_PORT_VLAN;
+
+		if (cpsw->version == CPSW_VERSION_1)
+			reg = CPSW1_PORT_VLAN;
+		pvid = slave_read(cpsw->slaves + (priv->emac_port - 1), reg);
+	} else {
+		port_vlan_reg = &cpsw->host_port_regs->port_vlan;
+		pvid = readl(port_vlan_reg);
+	}
+
+	pvid = pvid & 0xfff;
+
+	return pvid;
+}
+
+static void cpsw_set_pvid(struct cpsw_priv *priv, u16 vid, bool cfi, u32 cos)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	void __iomem *port_vlan_reg;
+	u32 pvid;
+
+	pvid = vid;
+	pvid |= cfi ? BIT(12) : 0;
+	pvid |= (cos & 0x7) << 13;
+
+	if (priv->emac_port) {
+		int reg = CPSW2_PORT_VLAN;
+
+		if (cpsw->version == CPSW_VERSION_1)
+			reg = CPSW1_PORT_VLAN;
+		/* no barrier */
+		slave_write(cpsw->slaves + (priv->emac_port - 1), pvid, reg);
+	} else {
+		/* CPU port */
+		port_vlan_reg = &cpsw->host_port_regs->port_vlan;
+		writel(pvid, port_vlan_reg);
+	}
+}
+
+static int cpsw_port_vlan_add(struct cpsw_priv *priv, bool untag, bool pvid,
+			      u16 vid, struct net_device *orig_dev)
+{
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int unreg_mcast_mask = 0;
+	int reg_mcast_mask = 0;
+	int untag_mask = 0;
+	int port_mask;
+	int ret = 0;
+	u32 flags;
+
+	if (cpu_port) {
+		port_mask = BIT(HOST_PORT_NUM);
+		flags = orig_dev->flags;
+		unreg_mcast_mask = port_mask;
+	} else {
+		port_mask = BIT(priv->emac_port);
+		flags = priv->ndev->flags;
+	}
+
+	if (flags & IFF_MULTICAST)
+		reg_mcast_mask = port_mask;
+
+	if (untag)
+		untag_mask = port_mask;
+
+	ret = cpsw_ale_vlan_add_modify(cpsw->ale, vid, port_mask, untag_mask,
+				       reg_mcast_mask, unreg_mcast_mask);
+	if (ret) {
+		dev_err(priv->dev, "Unable to add vlan\n");
+		return ret;
+	}
+
+	if (cpu_port)
+		cpsw_ale_add_ucast(cpsw->ale, priv->mac_addr,
+				   HOST_PORT_NUM, ALE_VLAN, vid);
+	if (!pvid)
+		return ret;
+
+	cpsw_set_pvid(priv, vid, 0, 0);
+
+	dev_dbg(priv->dev, "VID add: %s: vid:%u ports:%X\n",
+		priv->ndev->name, vid, port_mask);
+	return ret;
+}
+
+static int cpsw_port_vlan_del(struct cpsw_priv *priv, u16 vid,
+			      struct net_device *orig_dev)
+{
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int port_mask;
+	int ret = 0;
+
+	if (cpu_port)
+		port_mask = BIT(HOST_PORT_NUM);
+	else
+		port_mask = BIT(priv->emac_port);
+
+	ret = cpsw_ale_del_vlan(cpsw->ale, vid, port_mask);
+	if (ret != 0)
+		return ret;
+
+	/* We don't care for the return value here, error is returned only if
+	 * the unicast entry is not present
+	 */
+	if (cpu_port)
+		cpsw_ale_del_ucast(cpsw->ale, priv->mac_addr,
+				   HOST_PORT_NUM, ALE_VLAN, vid);
+
+	if (vid == cpsw_get_pvid(priv))
+		cpsw_set_pvid(priv, 0, 0, 0);
+
+	/* We don't care for the return value here, error is returned only if
+	 * the multicast entry is not present
+	 */
+	cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
+			   port_mask, ALE_VLAN, vid);
+	dev_dbg(priv->dev, "VID del: %s: vid:%u ports:%X\n",
+		priv->ndev->name, vid, port_mask);
+
+	return ret;
+}
+
+static int cpsw_port_vlans_add(struct cpsw_priv *priv,
+			       const struct switchdev_obj_port_vlan *vlan,
+			       struct switchdev_trans *trans)
+{
+	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct net_device *orig_dev = vlan->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	u16 vid;
+
+	dev_dbg(priv->dev, "VID add: %s: vid:%u flags:%X\n",
+		priv->ndev->name, vlan->vid_begin, vlan->flags);
+
+	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		int err;
+
+		err = cpsw_port_vlan_add(priv, untag, pvid, vid, orig_dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cpsw_port_vlans_del(struct cpsw_priv *priv,
+			       const struct switchdev_obj_port_vlan *vlan)
+
+{
+	struct net_device *orig_dev = vlan->obj.orig_dev;
+	u16 vid;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		int err;
+
+		err = cpsw_port_vlan_del(priv, vid, orig_dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int cpsw_port_mdb_add(struct cpsw_priv *priv,
+			     struct switchdev_obj_port_mdb *mdb,
+			     struct switchdev_trans *trans)
+
+{
+	struct net_device *orig_dev = mdb->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int port_mask;
+	int err;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (cpu_port)
+		port_mask = BIT(HOST_PORT_NUM);
+	else
+		port_mask = BIT(priv->emac_port);
+
+	err = cpsw_ale_add_mcast(cpsw->ale, mdb->addr, port_mask,
+				 ALE_VLAN, mdb->vid, 0);
+	dev_dbg(priv->dev, "MDB add: %s: vid %u:%pM  ports: %X\n",
+		priv->ndev->name, mdb->vid, mdb->addr, port_mask);
+
+	return err;
+}
+
+static int cpsw_port_mdb_del(struct cpsw_priv *priv,
+			     struct switchdev_obj_port_mdb *mdb)
+
+{
+	struct net_device *orig_dev = mdb->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int del_mask;
+	int err;
+
+	if (cpu_port)
+		del_mask = BIT(HOST_PORT_NUM);
+	else
+		del_mask = BIT(priv->emac_port);
+
+	err = cpsw_ale_del_mcast(cpsw->ale, mdb->addr, del_mask,
+				 ALE_VLAN, mdb->vid);
+	dev_dbg(priv->dev, "MDB del: %s: vid %u:%pM  ports: %X\n",
+		priv->ndev->name, mdb->vid, mdb->addr, del_mask);
+
+	return err;
+}
+
+static int cpsw_port_obj_add(struct net_device *ndev,
+			     const struct switchdev_obj *obj,
+			     struct switchdev_trans *trans,
+			     struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int err = 0;
+
+	dev_dbg(priv->dev, "obj_add: id %u port: %u\n",
+		obj->id, priv->emac_port);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = cpsw_port_vlans_add(priv, vlan, trans);
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = cpsw_port_mdb_add(priv, mdb, trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int cpsw_port_obj_del(struct net_device *ndev,
+			     const struct switchdev_obj *obj)
+{
+	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int err = 0;
+
+	dev_dbg(priv->dev, "obj_del: id %u port: %u\n",
+		obj->id, priv->emac_port);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = cpsw_port_vlans_del(priv, vlan);
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = cpsw_port_mdb_del(priv, mdb);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static void cpsw_fdb_offload_notify(struct net_device *ndev,
+				    struct switchdev_notifier_fdb_info *rcv)
+{
+	struct switchdev_notifier_fdb_info info;
+
+	info.addr = rcv->addr;
+	info.vid = rcv->vid;
+	info.offloaded = true;
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
+				 ndev, &info.info, NULL);
+}
+
+static void cpsw_switchdev_event_work(struct work_struct *work)
+{
+	struct cpsw_switchdev_event_work *switchdev_work =
+		container_of(work, struct cpsw_switchdev_event_work, work);
+	struct cpsw_priv *priv = switchdev_work->priv;
+	struct switchdev_notifier_fdb_info *fdb;
+	struct cpsw_common *cpsw = priv->cpsw;
+	int port = priv->emac_port;
+
+	rtnl_lock();
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fdb = &switchdev_work->fdb_info;
+
+		dev_dbg(cpsw->dev, "cpsw_fdb_add: MACID = %pM vid = %u flags = %u %u -- port %d\n",
+			fdb->addr, fdb->vid, fdb->added_by_user,
+			fdb->offloaded, port);
+
+		if (!fdb->added_by_user)
+			break;
+		if (memcmp(priv->mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
+			port = HOST_PORT_NUM;
+
+		cpsw_ale_add_ucast(cpsw->ale, (u8 *)fdb->addr, port,
+				   fdb->vid ? ALE_VLAN : 0, fdb->vid);
+		cpsw_fdb_offload_notify(priv->ndev, fdb);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb = &switchdev_work->fdb_info;
+
+		dev_dbg(cpsw->dev, "cpsw_fdb_del: MACID = %pM vid = %u flags = %u %u -- port %d\n",
+			fdb->addr, fdb->vid, fdb->added_by_user,
+			fdb->offloaded, port);
+
+		if (!fdb->added_by_user)
+			break;
+		if (memcmp(priv->mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
+			port = HOST_PORT_NUM;
+
+		cpsw_ale_del_ucast(cpsw->ale, (u8 *)fdb->addr, port,
+				   fdb->vid ? ALE_VLAN : 0, fdb->vid);
+		break;
+	default:
+		break;
+	}
+	rtnl_unlock();
+
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(priv->ndev);
+}
+
+/* called under rcu_read_lock() */
+static int cpsw_switchdev_event(struct notifier_block *unused,
+				unsigned long event, void *ptr)
+{
+	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info = ptr;
+	struct cpsw_switchdev_event_work *switchdev_work;
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(ndev, ptr,
+						     cpsw_port_dev_check,
+						     cpsw_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	if (!cpsw_port_dev_check(ndev))
+		return NOTIFY_DONE;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (WARN_ON(!switchdev_work))
+		return NOTIFY_BAD;
+
+	INIT_WORK(&switchdev_work->work, cpsw_switchdev_event_work);
+	switchdev_work->priv = priv;
+	switchdev_work->event = event;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		memcpy(&switchdev_work->fdb_info, ptr,
+		       sizeof(switchdev_work->fdb_info));
+		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!switchdev_work->fdb_info.addr)
+			goto err_addr_alloc;
+		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(ndev);
+		break;
+	default:
+		kfree(switchdev_work);
+		return NOTIFY_DONE;
+	}
+
+	queue_work(system_long_wq, &switchdev_work->work);
+
+	return NOTIFY_DONE;
+
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
+static struct notifier_block cpsw_switchdev_notifier = {
+	.notifier_call = cpsw_switchdev_event,
+};
+
+static int cpsw_switchdev_blocking_event(struct notifier_block *unused,
+					 unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    cpsw_port_dev_check,
+						    cpsw_port_obj_add);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    cpsw_port_dev_check,
+						    cpsw_port_obj_del);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     cpsw_port_dev_check,
+						     cpsw_port_attr_set);
+		return notifier_from_errno(err);
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cpsw_switchdev_bl_notifier = {
+	.notifier_call = cpsw_switchdev_blocking_event,
+};
+
+int cpsw_switchdev_register_notifiers(struct cpsw_common *cpsw)
+{
+	int ret = 0;
+
+	ret = register_switchdev_notifier(&cpsw_switchdev_notifier);
+	if (ret) {
+		dev_err(cpsw->dev, "register switchdev notifier fail ret:%d\n",
+			ret);
+		return ret;
+	}
+
+	ret = register_switchdev_blocking_notifier(&cpsw_switchdev_bl_notifier);
+	if (ret) {
+		dev_err(cpsw->dev, "register switchdev blocking notifier ret:%d\n",
+			ret);
+		unregister_switchdev_notifier(&cpsw_switchdev_notifier);
+	}
+
+	return ret;
+}
+
+void cpsw_switchdev_unregister_notifiers(struct cpsw_common *cpsw)
+{
+	unregister_switchdev_blocking_notifier(&cpsw_switchdev_bl_notifier);
+	unregister_switchdev_notifier(&cpsw_switchdev_notifier);
+}
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.h b/drivers/net/ethernet/ti/cpsw_switchdev.h
new file mode 100644
index 000000000000..04a045dba7d4
--- /dev/null
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Texas Instruments Ethernet Switch Driver
+ */
+
+#ifndef DRIVERS_NET_ETHERNET_TI_CPSW_SWITCHDEV_H_
+#define DRIVERS_NET_ETHERNET_TI_CPSW_SWITCHDEV_H_
+
+#include <net/switchdev.h>
+
+bool cpsw_port_dev_check(const struct net_device *dev);
+int cpsw_switchdev_register_notifiers(struct cpsw_common *cpsw);
+void cpsw_switchdev_unregister_notifiers(struct cpsw_common *cpsw);
+
+#endif /* DRIVERS_NET_ETHERNET_TI_CPSW_SWITCHDEV_H_ */
-- 
2.17.1

