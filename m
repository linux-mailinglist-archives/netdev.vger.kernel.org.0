Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480FE46758E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380137AbhLCKtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:42 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32122 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380157AbhLCKt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528365; x=1670064365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xcLOcZqYewJXRyYOYvMfsthUbO95i/u8X+lCD874Dl8=;
  b=flPUAzfIcUfrJwa9PIGu9C8Sg+FEC12O/wieXqV9iFOdzv1Zm6PJwCFk
   D0fYtRz4Xtok1cJ+TNgww3CZwwI6cO1HsktMlA19xrcHXqpYJ96TGRwi4
   SmWcA6Us3IZ+aMzU90FcGK0WbhaEi0dsZ4BrnCugF8gdJ5d7+tc4qvg/i
   Kgw+be1VKsyeDZxtwqh8Z72vqozp4j2kGe63W0FPmmni6Y1LWw+rwadd2
   F6pRt4SdspCv3sUwPsXjoOgaMmKbqtH1g9j4hvrnGoRk5wRDrmfInuA4Z
   rWRMGcjsIgYBmvXhUesztF8yJ8/G9+9Tfi6jzHYkQDJljAbRKKGoj+MdU
   g==;
IronPort-SDR: cV90tYrJdYJ+z9YOmzwy7TldTpc4TpfXwR+z7WA9Hla1S9BsI9fVXnNyfpiGlDNEN+fyGtGEex
 h/z3hXXrQHye1HzbQcA1PaJH0c+T/vWqCkjhjJHk32NFQpOtI5Zqi3ZBmTus5D8WdwXwkLBOW9
 7k+imai4Evw5wFRgoczqMiiqtCzuuqurByFGNMTzSC03px7OxoxfvVVB1PDrOB0vMNy8PzH4ae
 gUhzypc0RNlhB8YaQ3BPiGCe7UiK+zkv4RZljV2PQZrJ4rOghV+y4ypvFuq8agmghsy++NQHXw
 i/I5weXqltA6rQRug/tD1DfM
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="145985175"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:46:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:46:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:46:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/6] net: lan966x: Add switchdev support
Date:   Fri, 3 Dec 2021 11:46:45 +0100
Message-ID: <20211203104645.1476704-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
References: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for switchdev in lan966x.
It offloads to the HW basic forwarding and vlan filtering. To be able to
offload this to the HW, it is required to disable promisc mode for ports
that are part of the bridge.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  41 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  18 +
 .../microchip/lan966x/lan966x_switchdev.c     | 544 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c |   9 +-
 5 files changed, 603 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index f7e6068a91cb..d82e896c2e53 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
-			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o
+			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
+			lan966x_vlan.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 3b6926553e52..cc22c5fba5e5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -306,7 +306,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
 
-static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
+void lan966x_set_promisc(struct lan966x_port *port, bool enable)
 {
 	struct lan966x *lan966x = port->lan966x;
 
@@ -318,14 +318,18 @@ static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
 static void lan966x_port_change_rx_flags(struct net_device *dev, int flags)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	bool enable;
 
 	if (!(flags & IFF_PROMISC))
 		return;
 
-	if (dev->flags & IFF_PROMISC)
-		lan966x_set_promisc(port, true);
-	else
-		lan966x_set_promisc(port, false);
+	enable = dev->flags & IFF_PROMISC ? true : false;
+	port->promisc = enable;
+
+	if (port->bridge)
+		return;
+
+	lan966x_set_promisc(port, enable);
 }
 
 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
@@ -340,7 +344,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
+int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
@@ -348,7 +352,7 @@ static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	return lan966x_mac_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
 }
 
-static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
+int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
@@ -401,6 +405,11 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid		= lan966x_vlan_rx_kill_vid,
 };
 
+bool lan966x_netdevice_check(const struct net_device *dev)
+{
+	return dev && (dev->netdev_ops == &lan966x_port_netdev_ops);
+}
+
 static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
 {
 	return lan_rd(lan966x, QS_XTR_RD(grp));
@@ -537,6 +546,11 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 
 		skb->protocol = eth_type_trans(skb, dev);
 
+#ifdef CONFIG_NET_SWITCHDEV
+		if (lan966x->ports[src_port]->bridge)
+			skb->offload_fwd_mark = 1;
+#endif
+
 		netif_rx_ni(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
@@ -614,13 +628,16 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
+	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			    NETIF_F_RXFCS;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			 NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_STAG_TX;
+	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
 
-	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
-			  ENTRYTYPE_LOCKED);
-
 	port->phylink_config.dev = &port->dev->dev;
 	port->phylink_config.type = PHYLINK_NETDEV;
 	port->phylink_pcs.poll = true;
@@ -944,6 +961,8 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	lan966x_register_notifier_blocks(lan966x);
+
 	return 0;
 
 cleanup_ports:
@@ -962,6 +981,8 @@ static int lan966x_remove(struct platform_device *pdev)
 {
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
+	lan966x_unregister_notifier_blocks(lan966x);
+
 	lan966x_cleanup_ports(lan966x);
 
 	cancel_delayed_work_sync(&lan966x->stats_work);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 56603b72423c..512bc699a6f1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -79,6 +79,11 @@ struct lan966x {
 	struct list_head mac_entries;
 	spinlock_t mac_lock; /* lock for mac_entries list */
 
+	/* Notifiers */
+	struct notifier_block netdevice_nb;
+	struct notifier_block switchdev_nb;
+	struct notifier_block switchdev_blocking_nb;
+
 	u16 vlan_mask[VLAN_N_VID];
 	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
 
@@ -111,6 +116,10 @@ struct lan966x_port {
 	struct net_device *dev;
 	struct lan966x *lan966x;
 
+	struct net_device *bridge;
+	u8 stp_state;
+	u8 promisc;
+
 	u8 chip_port;
 	u16 pvid;
 	u16 vid;
@@ -128,6 +137,14 @@ extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
 extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
 extern const struct ethtool_ops lan966x_ethtool_ops;
 
+int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr);
+int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr);
+
+bool lan966x_netdevice_check(const struct net_device *dev);
+
+int lan966x_register_notifier_blocks(struct lan966x *lan966x);
+void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
+
 void lan966x_stats_get(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats);
 int lan966x_stats_init(struct lan966x *lan966x);
@@ -138,6 +155,7 @@ void lan966x_port_status_get(struct lan966x_port *port,
 			     struct phylink_link_state *state);
 int lan966x_port_pcs_set(struct lan966x_port *port,
 			 struct lan966x_port_config *config);
+void lan966x_set_promisc(struct lan966x_port *port, bool enable);
 void lan966x_port_init(struct lan966x_port *port);
 
 int lan966x_mac_learn(struct lan966x *lan966x, int port,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
new file mode 100644
index 000000000000..683363549024
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/if_bridge.h>
+#include <net/switchdev.h>
+
+#include "lan966x_main.h"
+
+static struct workqueue_struct *lan966x_owq;
+
+struct lan966x_fdb_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	struct lan966x *lan966x;
+	unsigned long event;
+};
+
+static void lan966x_port_attr_bridge_flags(struct lan966x_port *port,
+					   struct switchdev_brport_flags flags)
+{
+	u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_MC));
+
+	val = ANA_PGID_PGID_GET(val);
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		if (flags.val & BR_MCAST_FLOOD)
+			val |= BIT(port->chip_port);
+		else
+			val &= ~BIT(port->chip_port);
+	}
+
+	lan_rmw(ANA_PGID_PGID_SET(val),
+		ANA_PGID_PGID,
+		port->lan966x, ANA_PGID(PGID_MC));
+}
+
+static u32 lan966x_get_fwd_mask(struct lan966x_port *port)
+{
+	struct net_device *bridge = port->bridge;
+	struct lan966x *lan966x = port->lan966x;
+	u8 ingress_src = port->chip_port;
+	u32 mask = 0;
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; p++) {
+		port = lan966x->ports[p];
+
+		if (!port)
+			continue;
+
+		if (port->stp_state == BR_STATE_FORWARDING &&
+		    port->bridge == bridge)
+			mask |= BIT(p);
+	}
+
+	mask &= ~BIT(ingress_src);
+
+	return mask;
+}
+
+static void lan966x_update_fwd_mask(struct lan966x *lan966x)
+{
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; p++) {
+		struct lan966x_port *port = lan966x->ports[p];
+		unsigned long mask = 0;
+
+		if (port->bridge)
+			mask = lan966x_get_fwd_mask(port);
+
+		mask |= BIT(CPU_PORT);
+
+		lan_wr(ANA_PGID_PGID_SET(mask),
+		       lan966x, ANA_PGID(PGID_SRC + p));
+	}
+}
+
+static void lan966x_attr_stp_state_set(struct lan966x_port *port,
+				       u8 state)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool learn_ena = 0;
+
+	port->stp_state = state;
+
+	if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
+		learn_ena = 1;
+
+	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
+		ANA_PORT_CFG_LEARN_ENA,
+		lan966x, ANA_PORT_CFG(port->chip_port));
+
+	lan966x_update_fwd_mask(lan966x);
+}
+
+static void lan966x_port_attr_ageing_set(struct lan966x_port *port,
+					 unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
+
+	lan966x_mac_set_ageing(port->lan966x, ageing_time);
+}
+
+static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
+				 const struct switchdev_attr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		lan966x_port_attr_bridge_flags(port, attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		lan966x_attr_stp_state_set(port, attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		lan966x_port_attr_ageing_set(port, attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
+		lan966x_vlan_port_apply(port);
+		lan966x_vlan_cpu_set_vlan_aware(port);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int lan966x_port_bridge_join(struct lan966x_port *port,
+				    struct net_device *bridge,
+				    struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = port->dev;
+	int err;
+
+	err = switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
+					    false, extack);
+	if (err)
+		return err;
+
+	port->bridge = bridge;
+
+	/* Port enters in bridge mode therefor don't need to copy to CPU
+	 * frames for multicast in case the bridge is not requesting them
+	 */
+	__dev_mc_unsync(dev, lan966x_mc_unsync);
+
+	/* make sure that the promisc is disabled when entering under the bridge
+	 * because we don't want all the frames to come to CPU
+	 */
+	lan966x_set_promisc(port, false);
+
+	return 0;
+}
+
+static void lan966x_port_bridge_leave(struct lan966x_port *port,
+				      struct net_device *bridge)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	switchdev_bridge_port_unoffload(port->dev, NULL, NULL, NULL);
+	port->bridge = NULL;
+
+	/* Set the port back to host mode */
+	lan966x_vlan_port_set_vlan_aware(port, 0);
+	lan966x_vlan_port_set_vid(port, UNAWARE_PVID, false, false);
+	lan966x_vlan_port_apply(port);
+
+	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+
+	/* Port enters in host more therefore restore mc list */
+	__dev_mc_sync(port->dev, lan966x_mc_sync, lan966x_mc_unsync);
+
+	/* Restore back the promisc as it was before the interfaces was added to
+	 * the bridge
+	 */
+	lan966x_set_promisc(port, port->promisc);
+}
+
+static int lan966x_port_changeupper(struct net_device *dev,
+				    struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct netlink_ext_ack *extack;
+	int err = 0;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking)
+			err = lan966x_port_bridge_join(port, info->upper_dev,
+						       extack);
+		else
+			lan966x_port_bridge_leave(port, info->upper_dev);
+	}
+
+	return err;
+}
+
+static int lan966x_port_add_addr(struct net_device *dev, bool up)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	u16 vid;
+
+	vid = lan966x_vlan_port_get_pvid(port);
+
+	if (up)
+		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
+	else
+		lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
+
+	return 0;
+}
+
+static int lan966x_netdevice_port_event(struct net_device *dev,
+					struct notifier_block *nb,
+					unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	if (!lan966x_netdevice_check(dev))
+		return 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		err = lan966x_port_changeupper(dev, ptr);
+		break;
+	case NETDEV_PRE_UP:
+		err = lan966x_port_add_addr(dev, true);
+		break;
+	case NETDEV_DOWN:
+		err = lan966x_port_add_addr(dev, false);
+		break;
+	}
+
+	return err;
+}
+
+static int lan966x_netdevice_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int ret;
+
+	ret = lan966x_netdevice_port_event(dev, nb, event, ptr);
+
+	return notifier_from_errno(ret);
+}
+
+static void lan966x_fdb_event_work(struct work_struct *work)
+{
+	struct lan966x_fdb_event_work *fdb_work =
+		container_of(work, struct lan966x_fdb_event_work, work);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct net_device *dev = fdb_work->dev;
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	rtnl_lock();
+
+	fdb_info = &fdb_work->fdb_info;
+	lan966x = fdb_work->lan966x;
+
+	if (lan966x_netdevice_check(dev)) {
+		port = netdev_priv(dev);
+
+		switch (fdb_work->event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			if (!fdb_info->added_by_user)
+				break;
+			lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
+					      fdb_info->vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			if (!fdb_info->added_by_user)
+				break;
+			lan966x_mac_del_entry(lan966x, fdb_info->addr, fdb_info->vid);
+			break;
+		}
+	} else {
+		if (!netif_is_bridge_master(dev))
+			goto out;
+
+		/* If the CPU is not part of the vlan then there is no point
+		 * to copy the frames to the CPU because they will be dropped
+		 */
+		if (!lan966x_vlan_cpu_member_vlan_mask(lan966x, fdb_info->vid))
+			goto out;
+
+		/* In case the bridge is called */
+		switch (fdb_work->event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			/* If there is no front port in this vlan, there is no
+			 * point to copy the frame to CPU because it would be
+			 * just dropped at later point. So add it only if
+			 * there is a port
+			 */
+			if (!lan966x_vlan_port_any_vlan_mask(lan966x, fdb_info->vid))
+				break;
+
+			lan966x_mac_cpu_learn(lan966x, fdb_info->addr, fdb_info->vid);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			/* It is OK to always forget the entry it */
+			lan966x_mac_cpu_forget(lan966x, fdb_info->addr, fdb_info->vid);
+			break;
+		}
+	}
+
+out:
+	rtnl_unlock();
+	kfree(fdb_work->fdb_info.addr);
+	kfree(fdb_work);
+	dev_put(dev);
+}
+
+static int lan966x_switchdev_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct lan966x *lan966x = container_of(nb, struct lan966x, switchdev_nb);
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	struct lan966x_fdb_event_work *fdb_work;
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     lan966x_netdevice_check,
+						     lan966x_port_attr_set);
+		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fallthrough;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_work = kzalloc(sizeof(*fdb_work), GFP_ATOMIC);
+		if (!fdb_work)
+			return NOTIFY_BAD;
+
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+
+		fdb_work->dev = dev;
+		fdb_work->lan966x = lan966x;
+		fdb_work->event = event;
+		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
+		memcpy(&fdb_work->fdb_info, ptr, sizeof(fdb_work->fdb_info));
+		fdb_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!fdb_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
+		dev_hold(dev);
+
+		queue_work(lan966x_owq, &fdb_work->work);
+		break;
+	}
+
+	return NOTIFY_DONE;
+err_addr_alloc:
+	kfree(fdb_work);
+	return NOTIFY_BAD;
+}
+
+static int lan966x_handle_port_vlan_add(struct net_device *dev,
+					struct notifier_block *nb,
+					const struct switchdev_obj_port_vlan *v)
+{
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	/* When adding a port to a vlan, we get a callback for the port but
+	 * also for the bridge. When get the callback for the bridge just bail
+	 * out. Then when the bridge is added to the vlan, then we get a
+	 * callback here but in this case the flags has set:
+	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
+	 * port is added to the vlan, so the broadcast frames and unicast frames
+	 * with dmac of the bridge should be foward to CPU.
+	 */
+	if (netif_is_bridge_master(dev) &&
+	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
+
+	lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
+
+	/* In case the port gets called */
+	if (!(netif_is_bridge_master(dev))) {
+		if (!lan966x_netdevice_check(dev))
+			return -EOPNOTSUPP;
+
+		port = netdev_priv(dev);
+		return lan966x_vlan_port_add_vlan(port, v->vid,
+						  v->flags & BRIDGE_VLAN_INFO_PVID,
+						  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	}
+
+	/* In case the bridge gets called */
+	if (netif_is_bridge_master(dev))
+		return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_add(struct net_device *dev,
+				       struct notifier_block *nb,
+				       struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_add(dev, nb,
+						   SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int lan966x_handle_port_vlan_del(struct net_device *dev,
+					struct notifier_block *nb,
+					const struct switchdev_obj_port_vlan *v)
+{
+	struct lan966x_port *port;
+	struct lan966x *lan966x;
+
+	lan966x = container_of(nb, struct lan966x, switchdev_blocking_nb);
+
+	/* In case the physical port gets called */
+	if (!netif_is_bridge_master(dev)) {
+		if (!lan966x_netdevice_check(dev))
+			return -EOPNOTSUPP;
+
+		port = netdev_priv(dev);
+		return lan966x_vlan_port_del_vlan(port, v->vid);
+	}
+
+	/* In case the bridge gets called */
+	if (netif_is_bridge_master(dev))
+		return lan966x_vlan_cpu_del_vlan(lan966x, dev, v->vid);
+
+	return 0;
+}
+
+static int lan966x_handle_port_obj_del(struct net_device *dev,
+				       struct notifier_block *nb,
+				       struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = lan966x_handle_port_vlan_del(dev, nb,
+						   SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
+					    unsigned long event,
+					    void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = lan966x_handle_port_obj_add(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = lan966x_handle_port_obj_del(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     lan966x_netdevice_check,
+						     lan966x_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+int lan966x_register_notifier_blocks(struct lan966x *lan966x)
+{
+	int err;
+
+	lan966x->netdevice_nb.notifier_call = lan966x_netdevice_event;
+	err = register_netdevice_notifier(&lan966x->netdevice_nb);
+	if (err)
+		return err;
+
+	lan966x->switchdev_nb.notifier_call = lan966x_switchdev_event;
+	err = register_switchdev_notifier(&lan966x->switchdev_nb);
+	if (err)
+		goto err_switchdev_nb;
+
+	lan966x->switchdev_blocking_nb.notifier_call = lan966x_switchdev_blocking_event;
+	err = register_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
+	if (err)
+		goto err_switchdev_blocking_nb;
+
+	lan966x_owq = alloc_ordered_workqueue("lan966x_order", 0);
+	if (!lan966x_owq) {
+		err = -ENOMEM;
+		goto err_switchdev_blocking_nb;
+	}
+
+	return 0;
+
+err_switchdev_blocking_nb:
+	unregister_switchdev_notifier(&lan966x->switchdev_nb);
+err_switchdev_nb:
+	unregister_netdevice_notifier(&lan966x->netdevice_nb);
+
+	return err;
+}
+
+void lan966x_unregister_notifier_blocks(struct lan966x *lan966x)
+{
+	destroy_workqueue(lan966x_owq);
+
+	unregister_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
+	unregister_switchdev_notifier(&lan966x->switchdev_nb);
+	unregister_netdevice_notifier(&lan966x->netdevice_nb);
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index c035f24e77c2..cec35de078fc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -206,6 +206,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
 		 * table for the front port and the CPU
 		 */
 		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+		lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr,
+				      UNAWARE_PVID);
 
 		lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
 		lan966x_vlan_port_apply(port);
@@ -214,6 +216,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
 		 * to vlan unaware
 		 */
 		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+		lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr,
+				       UNAWARE_PVID);
 
 		lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
 		lan966x_vlan_port_apply(port);
@@ -289,6 +293,7 @@ int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
 	 */
 	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
 		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
+		lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
 	}
 
@@ -318,8 +323,10 @@ int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
 	 * that vlan but still keep it in the mask because it may be needed
 	 * again then another port gets added in tha vlan
 	 */
-	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
+		lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+	}
 
 	return 0;
 }
-- 
2.33.0

