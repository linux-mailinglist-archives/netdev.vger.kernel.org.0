Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AF6479D97
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhLRVsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:31363 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbhLRVsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864111; x=1671400111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U9nJYZVkaDVb6fHSZeBh1zMhZta20QWiq7UhgIRz/Ws=;
  b=DbEJQgeSeSl7SvCwPVptfC3LHvFfEbhCPCZLZGe7HPsci4TBUAosTSHy
   ctw/PojPuRod+FwLfMB6SW6Che8BggcIqulKxPFbyC/vK+Bl7ZCpqCDtk
   znf3kSyRb9kQmCku+wx2YZuAOg7bxeGii2oBhzsVjco2fWrXoDeqQYm6e
   bjzFeAErboEdqgkJ2V+dnOKQp7Ac3ewlMI9+4s9kOYrOOY/d2/A++ewtW
   aPZMGGEQJj7wADdT9F6fJfxxSBdOh5pNP4M0zOxh3jCQ+lAOOq9+SLDQm
   Qi/Rae8UAMZup1rgsUENorSm8wCOSii/B/H22WKcp7oKSS9bMw8xuf3og
   g==;
IronPort-SDR: fjcXKdGKkb3UwcNMR8fj5B2Urx+vEweR+wxMTmt3kTp8TNv5F7ha2GxnPFDsIHmorgvyoslcvQ
 scwgJ2qKu00/iYo6UxWW2jM9+Bbh4MXidZeQG+E0E4fusADwSLcxffYs3gznIVh/teXw6KyFrC
 bEe9o7ClB5MKCZxM+bnjdwVKE7Nip0+qXZf2mn31OieK5lLntnqTkXIqG58X5gjHKSPYKG7xWZ
 OCuLDvwP6d9lz7IU/O3TKF5SS98gPzDxbtQnx/pKIuHxjcAi6rrDnCDWSyY9zVh5tDtPG6cL8I
 c7R0eHo8aV/hh/8an3mgpph3
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="142863315"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v8 7/9] net: lan966x: Add vlan support.
Date:   Sat, 18 Dec 2021 22:49:44 +0100
Message-ID: <20211218214946.531940-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the driver to support vlan filtering  by implementing the
switchdev calls SWITCHDEV_OBJ_ID_PORT_VLAN,
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  20 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  26 +-
 .../microchip/lan966x/lan966x_switchdev.c     | 104 +++++-
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 301 ++++++++++++++++++
 5 files changed, 448 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 974229c51f55..d82e896c2e53 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
-			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
+			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
+			lan966x_vlan.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 418480313e75..1162f5540a65 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -108,12 +108,12 @@ static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 	int ret;
 
 	/* Learn the new net device MAC address in the mac table. */
-	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, port->pvid);
+	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, HOST_PVID);
 	if (ret)
 		return ret;
 
 	/* Then forget the previous one. */
-	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, port->pvid);
+	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, HOST_PVID);
 	if (ret)
 		return ret;
 
@@ -283,6 +283,12 @@ static void lan966x_ifh_set_ipv(void *ifh, u64 bypass)
 		IFH_POS_IPV, IFH_LEN * 4, PACK, 0);
 }
 
+static void lan966x_ifh_set_vid(void *ifh, u64 vid)
+{
+	packing(ifh, &vid, IFH_POS_TCI + IFH_WID_TCI - 1,
+		IFH_POS_TCI, IFH_LEN * 4, PACK, 0);
+}
+
 static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -294,6 +300,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
 	lan966x_ifh_set_qos_class(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
 	lan966x_ifh_set_ipv(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
+	lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
 
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
@@ -575,13 +582,14 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	port->dev = dev;
 	port->lan966x = lan966x;
 	port->chip_port = p;
-	port->pvid = PORT_PVID;
 	lan966x->ports[p] = port;
 
 	dev->max_mtu = ETH_MAX_MTU;
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_STAG_TX;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
@@ -628,6 +636,10 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 		return err;
 	}
 
+	lan966x_vlan_port_set_vlan_aware(port, 0);
+	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
+	lan966x_vlan_port_apply(port);
+
 	return 0;
 }
 
@@ -638,6 +650,8 @@ static void lan966x_init(struct lan966x *lan966x)
 	/* MAC table initialization */
 	lan966x_mac_init(lan966x);
 
+	lan966x_vlan_init(lan966x);
+
 	/* Flush queues */
 	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
 	       GENMASK(1, 0),
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 4723a904c13e..19635cea6634 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -4,6 +4,7 @@
 #define __LAN966X_MAIN_H__
 
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/jiffies.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
@@ -22,7 +23,8 @@
 #define PGID_SRC			80
 #define PGID_ENTRIES			89
 
-#define PORT_PVID			0
+#define UNAWARE_PVID			0
+#define HOST_PVID			4095
 
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
@@ -82,6 +84,9 @@ struct lan966x {
 	struct list_head mac_entries;
 	spinlock_t mac_lock; /* lock for mac_entries list */
 
+	u16 vlan_mask[VLAN_N_VID];
+	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
+
 	/* stats */
 	const struct lan966x_stat_layout *stats_layout;
 	u32 num_stats;
@@ -113,6 +118,8 @@ struct lan966x_port {
 
 	u8 chip_port;
 	u16 pvid;
+	u16 vid;
+	bool vlan_aware;
 
 	struct phylink_config phylink_config;
 	struct phylink_pcs phylink_pcs;
@@ -166,6 +173,23 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
 void lan966x_mac_purge_entries(struct lan966x *lan966x);
 irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
 
+void lan966x_vlan_init(struct lan966x *lan966x);
+void lan966x_vlan_port_apply(struct lan966x_port *port);
+bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid);
+void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
+				      bool vlan_aware);
+int lan966x_vlan_port_set_vid(struct lan966x_port *port,
+			      u16 vid,
+			      bool pvid,
+			      bool untagged);
+void lan966x_vlan_port_add_vlan(struct lan966x_port *port,
+				u16 vid,
+				bool pvid,
+				bool untagged);
+void lan966x_vlan_port_del_vlan(struct lan966x_port *port, u16 vid);
+void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid);
+void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 9db17b677357..81e37624b553 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -73,6 +73,10 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		lan966x_port_ageing_set(port, attr->u.ageing_time);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
+		lan966x_vlan_port_apply(port);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -120,7 +124,10 @@ static void lan966x_port_bridge_leave(struct lan966x_port *port,
 	if (!lan966x->bridge_mask)
 		lan966x->bridge = NULL;
 
-	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
+	/* Set the port back to host mode */
+	lan966x_vlan_port_set_vlan_aware(port, false);
+	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
+	lan966x_vlan_port_apply(port);
 }
 
 static int lan966x_port_changeupper(struct net_device *dev,
@@ -264,6 +271,91 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static int lan966x_handle_port_vlan_add(struct lan966x_port *port,
+					const struct switchdev_obj *obj)
+{
+	const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct lan966x *lan966x = port->lan966x;
+
+	/* When adding a port to a vlan, we get a callback for the port but
+	 * also for the bridge. When get the callback for the bridge just bail
+	 * out. Then when the bridge is added to the vlan, then we get a
+	 * callback here but in this case the flags has set:
+	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
+	 * port is added to the vlan, so the broadcast frames and unicast frames
+	 * with dmac of the bridge should be foward to CPU.
+	 */
+	if (netif_is_bridge_master(obj->orig_dev) &&
+	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
+
+	if (!netif_is_bridge_master(obj->orig_dev))
+		lan966x_vlan_port_add_vlan(port, v->vid,
+					   v->flags & BRIDGE_VLAN_INFO_PVID,
+					   v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	else
+		lan966x_vlan_cpu_add_vlan(lan966x, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_add(struct net_device *dev, const void *ctx,
+				       const struct switchdev_obj *obj,
+				       struct netlink_ext_ack *extack)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int err;
+
+	if (ctx && ctx != port)
+		return 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_add(port, obj);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int lan966x_handle_port_vlan_del(struct lan966x_port *port,
+					const struct switchdev_obj *obj)
+{
+	const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!netif_is_bridge_master(obj->orig_dev))
+		lan966x_vlan_port_del_vlan(port, v->vid);
+	else
+		lan966x_vlan_cpu_del_vlan(lan966x, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_del(struct net_device *dev, const void *ctx,
+				       const struct switchdev_obj *obj)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int err;
+
+	if (ctx && ctx != port)
+		return 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_del(port, obj);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
 static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
 					    unsigned long event,
 					    void *ptr)
@@ -272,6 +364,16 @@ static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
 	int err;
 
 	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    lan966x_netdevice_check,
+						    lan966x_handle_port_obj_add);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    lan966x_netdevice_check,
+						    lan966x_handle_port_obj_del);
+		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     lan966x_netdevice_check,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
new file mode 100644
index 000000000000..64eb80626deb
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+#define VLANACCESS_CMD_IDLE		0
+#define VLANACCESS_CMD_READ		1
+#define VLANACCESS_CMD_WRITE		2
+#define VLANACCESS_CMD_INIT		3
+
+static int lan966x_vlan_get_status(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, ANA_VLANACCESS);
+}
+
+static int lan966x_vlan_wait_for_completion(struct lan966x *lan966x)
+{
+	u32 val;
+
+	return readx_poll_timeout(lan966x_vlan_get_status,
+		lan966x, val,
+		(val & ANA_VLANACCESS_VLAN_TBL_CMD) ==
+		VLANACCESS_CMD_IDLE,
+		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+}
+
+static void lan966x_vlan_set_mask(struct lan966x *lan966x, u16 vid)
+{
+	u16 mask = lan966x->vlan_mask[vid];
+	bool cpu_dis;
+
+	cpu_dis = !(mask & BIT(CPU_PORT));
+
+	/* Set flags and the VID to configure */
+	lan_rmw(ANA_VLANTIDX_VLAN_PGID_CPU_DIS_SET(cpu_dis) |
+		ANA_VLANTIDX_V_INDEX_SET(vid),
+		ANA_VLANTIDX_VLAN_PGID_CPU_DIS |
+		ANA_VLANTIDX_V_INDEX,
+		lan966x, ANA_VLANTIDX);
+
+	/* Set the vlan port members mask */
+	lan_rmw(ANA_VLAN_PORT_MASK_VLAN_PORT_MASK_SET(mask),
+		ANA_VLAN_PORT_MASK_VLAN_PORT_MASK,
+		lan966x, ANA_VLAN_PORT_MASK);
+
+	/* Issue a write command */
+	lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_WRITE),
+		ANA_VLANACCESS_VLAN_TBL_CMD,
+		lan966x, ANA_VLANACCESS);
+
+	if (lan966x_vlan_wait_for_completion(lan966x))
+		dev_err(lan966x->dev, "Vlan set mask failed\n");
+}
+
+static void lan966x_vlan_port_add_vlan_mask(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 p = port->chip_port;
+
+	lan966x->vlan_mask[vid] |= BIT(p);
+	lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static void lan966x_vlan_port_del_vlan_mask(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 p = port->chip_port;
+
+	lan966x->vlan_mask[vid] &= ~BIT(p);
+	lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	return !!(lan966x->vlan_mask[vid] & ~BIT(CPU_PORT));
+}
+
+static void lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	lan966x->vlan_mask[vid] |= BIT(CPU_PORT);
+	lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static void lan966x_vlan_cpu_del_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	lan966x->vlan_mask[vid] &= ~BIT(CPU_PORT);
+	lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	__set_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+static void lan966x_vlan_cpu_del_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	__clear_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	return test_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+static u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!(lan966x->bridge_mask & BIT(port->chip_port)))
+		return HOST_PVID;
+
+	return port->vlan_aware ? port->pvid : UNAWARE_PVID;
+}
+
+int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
+			      bool pvid, bool untagged)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* Egress vlan classification */
+	if (untagged && port->vid != vid) {
+		if (port->vid) {
+			dev_err(lan966x->dev,
+				"Port already has a native VLAN: %d\n",
+				port->vid);
+			return -EBUSY;
+		}
+		port->vid = vid;
+	}
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
+	return 0;
+}
+
+static void lan966x_vlan_port_remove_vid(struct lan966x_port *port, u16 vid)
+{
+	if (port->pvid == vid)
+		port->pvid = 0;
+
+	if (port->vid == vid)
+		port->vid = 0;
+}
+
+void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
+				      bool vlan_aware)
+{
+	port->vlan_aware = vlan_aware;
+}
+
+void lan966x_vlan_port_apply(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u16 pvid;
+	u32 val;
+
+	pvid = lan966x_vlan_port_get_pvid(port);
+
+	/* Ingress clasification (ANA_PORT_VLAN_CFG) */
+	/* Default vlan to classify for untagged frames (may be zero) */
+	val = ANA_VLAN_CFG_VLAN_VID_SET(pvid);
+	if (port->vlan_aware)
+		val |= ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
+		       ANA_VLAN_CFG_VLAN_POP_CNT_SET(1);
+
+	lan_rmw(val,
+		ANA_VLAN_CFG_VLAN_VID | ANA_VLAN_CFG_VLAN_AWARE_ENA |
+		ANA_VLAN_CFG_VLAN_POP_CNT,
+		lan966x, ANA_VLAN_CFG(port->chip_port));
+
+	/* Drop frames with multicast source address */
+	val = ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(1);
+	if (port->vlan_aware && !pvid)
+		/* If port is vlan-aware and tagged, drop untagged and priority
+		 * tagged frames.
+		 */
+		val |= ANA_DROP_CFG_DROP_UNTAGGED_ENA_SET(1) |
+		       ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA_SET(1) |
+		       ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA_SET(1);
+
+	lan_wr(val, lan966x, ANA_DROP_CFG(port->chip_port));
+
+	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
+	val = REW_TAG_CFG_TAG_TPID_CFG_SET(0);
+	if (port->vlan_aware) {
+		if (port->vid)
+			/* Tag all frames except when VID == DEFAULT_VLAN */
+			val |= REW_TAG_CFG_TAG_CFG_SET(1);
+		else
+			val |= REW_TAG_CFG_TAG_CFG_SET(3);
+	}
+
+	/* Update only some bits in the register */
+	lan_rmw(val,
+		REW_TAG_CFG_TAG_TPID_CFG | REW_TAG_CFG_TAG_CFG,
+		lan966x, REW_TAG_CFG(port->chip_port));
+
+	/* Set default VLAN and tag type to 8021Q */
+	lan_rmw(REW_PORT_VLAN_CFG_PORT_TPID_SET(ETH_P_8021Q) |
+		REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
+		REW_PORT_VLAN_CFG_PORT_TPID |
+		REW_PORT_VLAN_CFG_PORT_VID,
+		lan966x, REW_PORT_VLAN_CFG(port->chip_port));
+}
+
+void lan966x_vlan_port_add_vlan(struct lan966x_port *port,
+				u16 vid,
+				bool pvid,
+				bool untagged)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid))
+		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+
+	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
+	lan966x_vlan_port_add_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+}
+
+void lan966x_vlan_port_del_vlan(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan966x_vlan_port_remove_vid(port, vid);
+	lan966x_vlan_port_del_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+
+	/* In case there are no other ports in vlan then remove the CPU from
+	 * that vlan but still keep it in the mask because it may be needed
+	 * again then another port gets added in that vlan
+	 */
+	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+}
+
+void lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x, u16 vid)
+{
+	/* Add an entry in the MAC table for the CPU
+	 * Add the CPU part of the vlan only if there is another port in that
+	 * vlan otherwise all the broadcast frames in that vlan will go to CPU
+	 * even if none of the ports are in the vlan and then the CPU will just
+	 * need to discard these frames. It is required to store this
+	 * information so when a front port is added then it would add also the
+	 * CPU port.
+	 */
+	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+
+	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
+}
+
+void lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x, u16 vid)
+{
+	/* Remove the CPU part of the vlan */
+	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
+	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+}
+
+void lan966x_vlan_init(struct lan966x *lan966x)
+{
+	u16 port, vid;
+
+	/* Clear VLAN table, by default all ports are members of all VLANS */
+	lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_INIT),
+		ANA_VLANACCESS_VLAN_TBL_CMD,
+		lan966x, ANA_VLANACCESS);
+	lan966x_vlan_wait_for_completion(lan966x);
+
+	for (vid = 1; vid < VLAN_N_VID; vid++) {
+		lan966x->vlan_mask[vid] = 0;
+		lan966x_vlan_set_mask(lan966x, vid);
+	}
+
+	/* Set all the ports + cpu to be part of HOST_PVID and UNAWARE_PVID */
+	lan966x->vlan_mask[HOST_PVID] =
+		GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
+	lan966x_vlan_set_mask(lan966x, HOST_PVID);
+
+	lan966x->vlan_mask[UNAWARE_PVID] =
+		GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
+	lan966x_vlan_set_mask(lan966x, UNAWARE_PVID);
+
+	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, UNAWARE_PVID);
+
+	/* Configure the CPU port to be vlan aware */
+	lan_wr(ANA_VLAN_CFG_VLAN_VID_SET(0) |
+	       ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
+	       ANA_VLAN_CFG_VLAN_POP_CNT_SET(1),
+	       lan966x, ANA_VLAN_CFG(CPU_PORT));
+
+	/* Set vlan ingress filter mask to all ports */
+	lan_wr(GENMASK(lan966x->num_phys_ports, 0),
+	       lan966x, ANA_VLANMASK);
+
+	for (port = 0; port < lan966x->num_phys_ports; port++) {
+		lan_wr(0, lan966x, REW_PORT_VLAN_CFG(port));
+		lan_wr(0, lan966x, REW_TAG_CFG(port));
+	}
+}
-- 
2.33.0

