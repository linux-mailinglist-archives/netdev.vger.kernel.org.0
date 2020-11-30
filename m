Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACCF2C7FEC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgK3IaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:30:23 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32832 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbgK3IaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:30:23 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8STEq117872;
        Mon, 30 Nov 2020 02:28:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606724910;
        bh=wiXeYyoXZq5Zgk4FecdhwnnphVw+Ph9VppgHLw2S4oA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=I2+TQrYNlaODIE8TAB/gPH9UQxq+eOEQQ2HMxrH8VY8ZLiM6zp1WZ2X26eSRBSWs7
         bphnM/fan+phZP8n2vk5tTW+bIiEMju4T9GRHLu5dfBO22CtZBnacvRMh8MT5GOa++
         UXT8FqDyu9KugWrQNl9h4IX7hUE059Tmt/QPD3Hs=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU8STHb017251
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 02:28:29 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 02:28:29 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 02:28:29 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8S9Dt057144;
        Mon, 30 Nov 2020 02:28:24 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/4] net: ti: am65-cpsw-nuss: Add switchdev support
Date:   Mon, 30 Nov 2020 13:50:45 +0530
Message-ID: <20201130082046.16292-4-vigneshr@ti.com>
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

J721e, J7200 and AM64 have multi port switches which can work in multi
mac mode and in switch mode. Add support for configuring this HW in
switch mode using devlink and switchdev notifiers.

Support is similar to existing CPSW switchdev implementation of TI's 32 bit
platform like DRA7xx.

To enable switch mode:
devlink dev param set platform/c000000.ethernet name switch_mode value true cmode runtime

All configuration is implemented via switchdev API and notifiers.
Supported:
      - SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
      - SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS: BR_MCAST_FLOOD
      - SWITCHDEV_ATTR_ID_PORT_STP_STATE
      - SWITCHDEV_OBJ_ID_PORT_VLAN
      - SWITCHDEV_OBJ_ID_PORT_MDB
      - SWITCHDEV_OBJ_ID_HOST_MDB

    Hence AM65 CPSW switchdev driver supports:
     - FDB offloading
     - MDB offloading
     - VLAN filtering and offloading
     - STP

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 drivers/net/ethernet/ti/Makefile              |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  20 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 572 ++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-switchdev.h |  34 ++
 4 files changed, 626 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-switchdev.h

diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 6e779292545d..75f761efbea7 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -26,4 +26,5 @@ keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o cpsw_ale.
 
 obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
 ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-cppi-desc-pool.o am65-cpsw-qos.o
+ti-am65-cpsw-nuss-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV) += am65-cpsw-switchdev.o
 obj-$(CONFIG_TI_K3_AM65_CPTS) += am65-cpts.o
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index a7e5a0489aec..69c0366f2beb 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -31,6 +31,7 @@
 #include "cpsw_ale.h"
 #include "cpsw_sl.h"
 #include "am65-cpsw-nuss.h"
+#include "am65-cpsw-switchdev.h"
 #include "k3-cppi-desc-pool.h"
 #include "am65-cpts.h"
 
@@ -228,6 +229,9 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	u32 port_mask, unreg_mcast = 0;
 	int ret;
 
+	if (!common->is_emac_mode)
+		return 0;
+
 	if (!netif_running(ndev) || !vid)
 		return 0;
 
@@ -255,6 +259,9 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret;
 
+	if (!common->is_emac_mode)
+		return 0;
+
 	if (!netif_running(ndev) || !vid)
 		return 0;
 
@@ -277,6 +284,11 @@ static void am65_cpsw_slave_set_promisc(struct am65_cpsw_port *port,
 {
 	struct am65_cpsw_common *common = port->common;
 
+	if (promisc && !common->is_emac_mode) {
+		dev_dbg(common->dev, "promisc mode requested in switch mode");
+		return;
+	}
+
 	if (promisc) {
 		/* Enable promiscuous mode */
 		cpsw_ale_control_set(common->ale, port->port_id,
@@ -796,12 +808,13 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 
 	new_skb = netdev_alloc_skb_ip_align(ndev, AM65_CPSW_MAX_PACKET_SIZE);
 	if (new_skb) {
+		ndev_priv = netdev_priv(ndev);
+		am65_cpsw_nuss_set_offload_fwd_mark(skb, ndev_priv->offload_fwd_mark);
 		skb_put(skb, pkt_len);
 		skb->protocol = eth_type_trans(skb, ndev);
 		am65_cpsw_nuss_rx_csum(skb, csum_info);
 		napi_gro_receive(&common->napi_rx, skb);
 
-		ndev_priv = netdev_priv(ndev);
 		stats = this_cpu_ptr(ndev_priv->stats);
 
 		u64_stats_update_begin(&stats->syncp);
@@ -2131,6 +2144,10 @@ static int am65_cpsw_register_notifiers(struct am65_cpsw_common *cpsw)
 		return ret;
 	}
 
+	ret = am65_cpsw_switchdev_register_notifiers(cpsw);
+	if (ret)
+		unregister_netdevice_notifier(&cpsw->am65_cpsw_netdevice_nb);
+
 	return ret;
 }
 
@@ -2140,6 +2157,7 @@ static void am65_cpsw_unregister_notifiers(struct am65_cpsw_common *cpsw)
 	    !IS_REACHABLE(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV))
 		return;
 
+	am65_cpsw_switchdev_unregister_notifiers(cpsw);
 	unregister_netdevice_notifier(&cpsw->am65_cpsw_netdevice_nb);
 }
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
new file mode 100644
index 000000000000..0fd7b90e60cf
--- /dev/null
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -0,0 +1,572 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Texas Instruments K3 AM65 Ethernet Switchdev Driver
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <net/switchdev.h>
+
+#include "am65-cpsw-nuss.h"
+#include "am65-cpsw-switchdev.h"
+#include "cpsw_ale.h"
+
+struct am65_cpsw_switchdev_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct am65_cpsw_port *port;
+	unsigned long event;
+};
+
+static int am65_cpsw_port_stp_state_set(struct am65_cpsw_port *port,
+					struct switchdev_trans *trans, u8 state)
+{
+	struct am65_cpsw_common *cpsw = port->common;
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
+	ret = cpsw_ale_control_set(cpsw->ale, port->port_id,
+				   ALE_PORT_STATE, cpsw_state);
+	netdev_dbg(port->ndev, "ale state: %u\n", cpsw_state);
+
+	return ret;
+}
+
+static int am65_cpsw_port_attr_br_flags_set(struct am65_cpsw_port *port,
+					    struct switchdev_trans *trans,
+					    struct net_device *orig_dev,
+					    unsigned long brport_flags)
+{
+	struct am65_cpsw_common *cpsw = port->common;
+	bool unreg_mcast_add = false;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (brport_flags & BR_MCAST_FLOOD)
+		unreg_mcast_add = true;
+	netdev_dbg(port->ndev, "BR_MCAST_FLOOD: %d port %u\n",
+		   unreg_mcast_add, port->port_id);
+
+	cpsw_ale_set_unreg_mcast(cpsw->ale, BIT(port->port_id),
+				 unreg_mcast_add);
+
+	return 0;
+}
+
+static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
+						struct switchdev_trans *trans,
+						unsigned long flags)
+{
+	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int am65_cpsw_port_attr_set(struct net_device *ndev,
+				   const struct switchdev_attr *attr,
+				   struct switchdev_trans *trans)
+{
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	int ret;
+
+	netdev_dbg(ndev, "attr: id %u port: %u\n", attr->id, port->port_id);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		ret = am65_cpsw_port_attr_br_flags_pre_set(ndev, trans,
+							   attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		ret = am65_cpsw_port_stp_state_set(port, trans, attr->u.stp_state);
+		netdev_dbg(ndev, "stp state: %u\n", attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		ret = am65_cpsw_port_attr_br_flags_set(port, trans, attr->orig_dev,
+						       attr->u.brport_flags);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static u16 am65_cpsw_get_pvid(struct am65_cpsw_port *port)
+{
+	struct am65_cpsw_common *cpsw = port->common;
+	struct am65_cpsw_host *host_p = am65_common_get_host(cpsw);
+	u32 pvid;
+
+	if (port->port_id)
+		pvid = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+	else
+		pvid = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
+	pvid = pvid & 0xfff;
+
+	return pvid;
+}
+
+static void am65_cpsw_set_pvid(struct am65_cpsw_port *port, u16 vid, bool cfi, u32 cos)
+{
+	struct am65_cpsw_common *cpsw = port->common;
+	struct am65_cpsw_host *host_p = am65_common_get_host(cpsw);
+	u32 pvid;
+
+	pvid = vid;
+	pvid |= cfi ? BIT(12) : 0;
+	pvid |= (cos & 0x7) << 13;
+
+	if (port->port_id)
+		writel(pvid, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+	else
+		writel(pvid, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+}
+
+static int am65_cpsw_port_vlan_add(struct am65_cpsw_port *port, bool untag, bool pvid,
+				   u16 vid, struct net_device *orig_dev)
+{
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct am65_cpsw_common *cpsw = port->common;
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
+		port_mask = BIT(port->port_id);
+		flags = port->ndev->flags;
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
+		netdev_err(port->ndev, "Unable to add vlan\n");
+		return ret;
+	}
+
+	if (cpu_port)
+		cpsw_ale_add_ucast(cpsw->ale, port->slave.mac_addr,
+				   HOST_PORT_NUM, ALE_VLAN | ALE_SECURE, vid);
+	if (!pvid)
+		return ret;
+
+	am65_cpsw_set_pvid(port, vid, 0, 0);
+
+	netdev_dbg(port->ndev, "VID add: %s: vid:%u ports:%X\n",
+		   port->ndev->name, vid, port_mask);
+
+	return ret;
+}
+
+static int am65_cpsw_port_vlan_del(struct am65_cpsw_port *port, u16 vid,
+				   struct net_device *orig_dev)
+{
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct am65_cpsw_common *cpsw = port->common;
+	int port_mask;
+	int ret = 0;
+
+	if (cpu_port)
+		port_mask = BIT(HOST_PORT_NUM);
+	else
+		port_mask = BIT(port->port_id);
+
+	ret = cpsw_ale_del_vlan(cpsw->ale, vid, port_mask);
+	if (ret != 0)
+		return ret;
+
+	/* We don't care for the return value here, error is returned only if
+	 * the unicast entry is not present
+	 */
+	if (cpu_port)
+		cpsw_ale_del_ucast(cpsw->ale, port->slave.mac_addr,
+				   HOST_PORT_NUM, ALE_VLAN, vid);
+
+	if (vid == am65_cpsw_get_pvid(port))
+		am65_cpsw_set_pvid(port, 0, 0, 0);
+
+	/* We don't care for the return value here, error is returned only if
+	 * the multicast entry is not present
+	 */
+	cpsw_ale_del_mcast(cpsw->ale, port->ndev->broadcast, port_mask,
+			   ALE_VLAN, vid);
+	netdev_dbg(port->ndev, "VID del: %s: vid:%u ports:%X\n",
+		   port->ndev->name, vid, port_mask);
+
+	return ret;
+}
+
+static int am65_cpsw_port_vlans_add(struct am65_cpsw_port *port,
+				    const struct switchdev_obj_port_vlan *vlan,
+				    struct switchdev_trans *trans)
+{
+	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	struct net_device *orig_dev = vlan->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	u16 vid;
+
+	netdev_dbg(port->ndev, "VID add: %s: vid:%u flags:%X\n",
+		   port->ndev->name, vlan->vid_begin, vlan->flags);
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
+		err = am65_cpsw_port_vlan_add(port, untag, pvid, vid, orig_dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int am65_cpsw_port_vlans_del(struct am65_cpsw_port *port,
+				    const struct switchdev_obj_port_vlan *vlan)
+
+{
+	struct net_device *orig_dev = vlan->obj.orig_dev;
+	u16 vid;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		int err;
+
+		err = am65_cpsw_port_vlan_del(port, vid, orig_dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int am65_cpsw_port_mdb_add(struct am65_cpsw_port *port,
+				  struct switchdev_obj_port_mdb *mdb,
+				  struct switchdev_trans *trans)
+
+{
+	struct net_device *orig_dev = mdb->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct am65_cpsw_common *cpsw = port->common;
+	int port_mask;
+	int err;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (cpu_port)
+		port_mask = BIT(HOST_PORT_NUM);
+	else
+		port_mask = BIT(port->port_id);
+
+	err = cpsw_ale_add_mcast(cpsw->ale, mdb->addr, port_mask,
+				 ALE_VLAN, mdb->vid, 0);
+	netdev_dbg(port->ndev, "MDB add: %s: vid %u:%pM  ports: %X\n",
+		   port->ndev->name, mdb->vid, mdb->addr, port_mask);
+
+	return err;
+}
+
+static int am65_cpsw_port_mdb_del(struct am65_cpsw_port *port,
+				  struct switchdev_obj_port_mdb *mdb)
+
+{
+	struct net_device *orig_dev = mdb->obj.orig_dev;
+	bool cpu_port = netif_is_bridge_master(orig_dev);
+	struct am65_cpsw_common *cpsw = port->common;
+	int del_mask;
+
+	if (cpu_port)
+		del_mask = BIT(HOST_PORT_NUM);
+	else
+		del_mask = BIT(port->port_id);
+
+	/* Ignore error as error code is returned only when entry is already removed */
+	cpsw_ale_del_mcast(cpsw->ale, mdb->addr, del_mask,
+			   ALE_VLAN, mdb->vid);
+	netdev_dbg(port->ndev, "MDB del: %s: vid %u:%pM  ports: %X\n",
+		   port->ndev->name, mdb->vid, mdb->addr, del_mask);
+
+	return 0;
+}
+
+static int am65_cpsw_port_obj_add(struct net_device *ndev,
+				  const struct switchdev_obj *obj,
+				  struct switchdev_trans *trans,
+				  struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	int err = 0;
+
+	netdev_dbg(ndev, "obj_add: id %u port: %u\n", obj->id, port->port_id);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = am65_cpsw_port_vlans_add(port, vlan, trans);
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = am65_cpsw_port_mdb_add(port, mdb, trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int am65_cpsw_port_obj_del(struct net_device *ndev,
+				  const struct switchdev_obj *obj)
+{
+	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct switchdev_obj_port_mdb *mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	int err = 0;
+
+	netdev_dbg(ndev, "obj_del: id %u port: %u\n", obj->id, port->port_id);
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = am65_cpsw_port_vlans_del(port, vlan);
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		err = am65_cpsw_port_mdb_del(port, mdb);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static void am65_cpsw_fdb_offload_notify(struct net_device *ndev,
+					 struct switchdev_notifier_fdb_info *rcv)
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
+static void am65_cpsw_switchdev_event_work(struct work_struct *work)
+{
+	struct am65_cpsw_switchdev_event_work *switchdev_work =
+		container_of(work, struct am65_cpsw_switchdev_event_work, work);
+	struct am65_cpsw_port *port = switchdev_work->port;
+	struct switchdev_notifier_fdb_info *fdb;
+	struct am65_cpsw_common *cpsw = port->common;
+	int port_id = port->port_id;
+
+	rtnl_lock();
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fdb = &switchdev_work->fdb_info;
+
+		netdev_dbg(port->ndev, "cpsw_fdb_add: MACID = %pM vid = %u flags = %u %u -- port %d\n",
+			   fdb->addr, fdb->vid, fdb->added_by_user,
+			   fdb->offloaded, port_id);
+
+		if (!fdb->added_by_user)
+			break;
+		if (memcmp(port->slave.mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
+			port_id = HOST_PORT_NUM;
+
+		cpsw_ale_add_ucast(cpsw->ale, (u8 *)fdb->addr, port_id,
+				   fdb->vid ? ALE_VLAN : 0, fdb->vid);
+		am65_cpsw_fdb_offload_notify(port->ndev, fdb);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb = &switchdev_work->fdb_info;
+
+		netdev_dbg(port->ndev, "cpsw_fdb_del: MACID = %pM vid = %u flags = %u %u -- port %d\n",
+			   fdb->addr, fdb->vid, fdb->added_by_user,
+			   fdb->offloaded, port_id);
+
+		if (!fdb->added_by_user)
+			break;
+		if (memcmp(port->slave.mac_addr, (u8 *)fdb->addr, ETH_ALEN) == 0)
+			port_id = HOST_PORT_NUM;
+
+		cpsw_ale_del_ucast(cpsw->ale, (u8 *)fdb->addr, port_id,
+				   fdb->vid ? ALE_VLAN : 0, fdb->vid);
+		break;
+	default:
+		break;
+	}
+	rtnl_unlock();
+
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(port->ndev);
+}
+
+/* called under rcu_read_lock() */
+static int am65_cpsw_switchdev_event(struct notifier_block *unused,
+				     unsigned long event, void *ptr)
+{
+	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
+	struct am65_cpsw_switchdev_event_work *switchdev_work;
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+	struct switchdev_notifier_fdb_info *fdb_info = ptr;
+	int err;
+
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		err = switchdev_handle_port_attr_set(ndev, ptr,
+						     am65_cpsw_port_dev_check,
+						     am65_cpsw_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	if (!am65_cpsw_port_dev_check(ndev))
+		return NOTIFY_DONE;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (WARN_ON(!switchdev_work))
+		return NOTIFY_BAD;
+
+	INIT_WORK(&switchdev_work->work, am65_cpsw_switchdev_event_work);
+	switchdev_work->port = port;
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
+	.notifier_call = am65_cpsw_switchdev_event,
+};
+
+static int am65_cpsw_switchdev_blocking_event(struct notifier_block *unused,
+					      unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    am65_cpsw_port_dev_check,
+						    am65_cpsw_port_obj_add);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    am65_cpsw_port_dev_check,
+						    am65_cpsw_port_obj_del);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     am65_cpsw_port_dev_check,
+						     am65_cpsw_port_attr_set);
+		return notifier_from_errno(err);
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cpsw_switchdev_bl_notifier = {
+	.notifier_call = am65_cpsw_switchdev_blocking_event,
+};
+
+int am65_cpsw_switchdev_register_notifiers(struct am65_cpsw_common *cpsw)
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
+void am65_cpsw_switchdev_unregister_notifiers(struct am65_cpsw_common *cpsw)
+{
+	unregister_switchdev_blocking_notifier(&cpsw_switchdev_bl_notifier);
+	unregister_switchdev_notifier(&cpsw_switchdev_notifier);
+}
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.h b/drivers/net/ethernet/ti/am65-cpsw-switchdev.h
new file mode 100644
index 000000000000..a67a7606bc80
--- /dev/null
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2020 Texas Instruments Incorporated - https://www.ti.com/
+ */
+
+#ifndef DRIVERS_NET_ETHERNET_TI_AM65_CPSW_SWITCHDEV_H_
+#define DRIVERS_NET_ETHERNET_TI_AM65_CPSW_SWITCHDEV_H_
+
+#include <linux/skbuff.h>
+
+#if IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)
+static inline void am65_cpsw_nuss_set_offload_fwd_mark(struct sk_buff *skb, bool val)
+{
+	skb->offload_fwd_mark = val;
+}
+
+int am65_cpsw_switchdev_register_notifiers(struct am65_cpsw_common *cpsw);
+void am65_cpsw_switchdev_unregister_notifiers(struct am65_cpsw_common *cpsw);
+#else
+static inline int am65_cpsw_switchdev_register_notifiers(struct am65_cpsw_common *cpsw)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void am65_cpsw_switchdev_unregister_notifiers(struct am65_cpsw_common *cpsw)
+{
+}
+
+static inline void am65_cpsw_nuss_set_offload_fwd_mark(struct sk_buff *skb, bool val)
+{
+}
+
+#endif
+
+#endif /* DRIVERS_NET_ETHERNET_TI_AM65_CPSW_SWITCHDEV_H_ */
-- 
2.29.2

