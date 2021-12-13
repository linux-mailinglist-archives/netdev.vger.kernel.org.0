Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2EE47291D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbhLMKSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:18:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35175 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhLMKPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390519; x=1670926519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jcgDApbPjCciLcCAATi51bNSJErLRfWXeqJ7NnYOG60=;
  b=NRWrVVYOan+vR76Zw3VtTRT9GVH5BLKIUhmdcYJ73bgt3+OowQq7JOKr
   qBVFKfLFZazabMULZKJ3BZ8TZ+ydsSW093LY/AJfPtqEnh9joXo7mJb18
   /vTC2z+ev6xDotWJUIKiEeYEtDb3oaSTgXjNROBehQtcZ+R4lzRhbpq4P
   Gbf0Oej9IlnQzHUz9COkCIaRXABa3N8MYHWGxyy/rlka//iLRE2n0P5ee
   4krvIqFWic0Qb1DGAUEQ0EUREWe/f80SUT4ZhTzbHY3YsT03x2vR1P8Fq
   eYkmgAXa7bBAwHMG5aINffBJioEpzhaf+1vn0rALkmexSEapng+W5Y5K5
   w==;
IronPort-SDR: zK2Djz/1hgCo6xeBZRH7bwGe+xh1mjmmc/pOugcf5np0T7C4dofmDxtUyML3n5td//bGyJMtEU
 At0XBYspnDe6jNHdlVr1TXuHNwOHRIZ/dMMIBERDkIfgOZKjz3djvUAWd+Hmoz9VJCy7NgpeZM
 GqIjVKYl5HdLaRkmBQmlsr1qWwxDABymSXjXWvMGV7mpkZJeF77ChFvqlvrVxScy8F8Vh3ZbnM
 E+QTI2mmyNK1p8ze62VRlRgf8pY6WeLYsoo2eGk+9G7VsKHfNYp1i7uhSQoWsrgLh34dQrgZCY
 1qNscnMw8leFXHTbx5Zr3c7b
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="146445635"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:14 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:15:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 07/10] net: lan966x: Add support to offload the forwarding.
Date:   Mon, 13 Dec 2021 11:14:29 +0100
Message-ID: <20211213101432.2668820-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic support to offload in the HW the forwarding of the
frames. The driver registers to the switchdev callbacks and implements
the callbacks for attributes SWITCHDEV_ATTR_ID_PORT_STP_STATE and
SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME.
It is not allowed to add a lan966x port to a bridge that contains a
different interface than lan966x.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  19 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  19 +
 .../microchip/lan966x/lan966x_switchdev.c     | 398 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c |  14 +-
 6 files changed, 449 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 2860a8c9923d..ac273f84b69e 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -2,6 +2,7 @@ config LAN966X_SWITCH
 	tristate "Lan966x switch driver"
 	depends on HAS_IOMEM
 	depends on OF
+	depends on NET_SWITCHDEV
 	select PHYLINK
 	select PACKING
 	help
diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index f7e6068a91cb..d489a34fc643 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
-			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o
+			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o \
+			lan966x_switchdev.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 22bb2e4dfdb2..08d8b230548b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -378,6 +378,11 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid		= lan966x_vlan_rx_kill_vid,
 };
 
+bool lan966x_netdevice_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &lan966x_port_netdev_ops;
+}
+
 static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
 {
 	return lan_rd(lan966x, QS_XTR_RD(grp));
@@ -514,6 +519,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 
 		skb->protocol = eth_type_trans(skb, dev);
 
+		if (lan966x->bridge_mask & BIT(src_port))
+			skb->offload_fwd_mark = 1;
+
 		netif_rx_ni(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
@@ -604,9 +612,6 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
 
-	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
-			  ENTRYTYPE_LOCKED);
-
 	port->phylink_config.dev = &port->dev->dev;
 	port->phylink_config.type = PHYLINK_NETDEV;
 	port->phylink_pcs.poll = true;
@@ -930,6 +935,11 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x_port_init(lan966x->ports[p]);
 	}
 
+	lan966x_ext_init(lan966x);
+	err = lan966x_register_notifier_blocks(lan966x);
+	if (err)
+		goto cleanup_ports;
+
 	return 0;
 
 cleanup_ports:
@@ -948,6 +958,8 @@ static int lan966x_remove(struct platform_device *pdev)
 {
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
+	lan966x_unregister_notifier_blocks(lan966x);
+
 	lan966x_cleanup_ports(lan966x);
 
 	cancel_delayed_work_sync(&lan966x->stats_work);
@@ -955,6 +967,7 @@ static int lan966x_remove(struct platform_device *pdev)
 	mutex_destroy(&lan966x->stats_lock);
 
 	lan966x_mac_purge_entries(lan966x);
+	lan966x_ext_purge_entries(lan966x);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 306d52ed140d..ac5ae30468ff 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -77,9 +77,20 @@ struct lan966x {
 
 	u8 base_mac[ETH_ALEN];
 
+	struct net_device *bridge;
+	u16 bridge_mask;
+	u16 bridge_fwd_mask;
+
 	struct list_head mac_entries;
 	spinlock_t mac_lock; /* lock for mac_entries list */
 
+	struct list_head ext_entries;
+
+	/* Notifiers */
+	struct notifier_block netdevice_nb;
+	struct notifier_block switchdev_nb;
+	struct notifier_block switchdev_blocking_nb;
+
 	u16 vlan_mask[VLAN_N_VID];
 	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
 
@@ -129,6 +140,11 @@ extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
 extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
 extern const struct ethtool_ops lan966x_ethtool_ops;
 
+bool lan966x_netdevice_check(const struct net_device *dev);
+
+int lan966x_register_notifier_blocks(struct lan966x *lan966x);
+void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
+
 void lan966x_stats_get(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats);
 int lan966x_stats_init(struct lan966x *lan966x);
@@ -194,6 +210,9 @@ int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
 			      struct net_device *dev,
 			      u16 vid);
 
+void lan966x_ext_purge_entries(struct lan966x *lan966x);
+void lan966x_ext_init(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
new file mode 100644
index 000000000000..3f6d361ad65b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -0,0 +1,398 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/if_bridge.h>
+#include <net/switchdev.h>
+
+#include "lan966x_main.h"
+
+struct lan966x_ext_entry {
+	struct list_head list;
+	struct net_device *dev;
+	u32 ports;
+};
+
+static void lan966x_update_fwd_mask(struct lan966x *lan966x)
+{
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		struct lan966x_port *port = lan966x->ports[i];
+		unsigned long mask = 0;
+
+		if (port && lan966x->bridge_fwd_mask & BIT(i))
+			mask = lan966x->bridge_fwd_mask & ~BIT(i);
+
+		mask |= BIT(CPU_PORT);
+
+		lan_wr(ANA_PGID_PGID_SET(mask),
+		       lan966x, ANA_PGID(PGID_SRC + i));
+	}
+}
+
+static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool learn_ena = false;
+
+	if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
+		learn_ena = true;
+
+	if (state == BR_STATE_FORWARDING)
+		lan966x->bridge_fwd_mask |= BIT(port->chip_port);
+	else
+		lan966x->bridge_fwd_mask &= ~BIT(port->chip_port);
+
+	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
+		ANA_PORT_CFG_LEARN_ENA,
+		lan966x, ANA_PORT_CFG(port->chip_port));
+
+	lan966x_update_fwd_mask(lan966x);
+}
+
+static void lan966x_port_ageing_set(struct lan966x_port *port,
+				    unsigned long ageing_clock_t)
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
+	int err = 0;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		lan966x_port_stp_state_set(port, attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		lan966x_port_ageing_set(port, attr->u.ageing_time);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int lan966x_port_bridge_join(struct lan966x_port *port,
+				    struct net_device *bridge,
+				    struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct net_device *dev = port->dev;
+	int err;
+
+	if (!lan966x->bridge_mask) {
+		lan966x->bridge = bridge;
+	} else {
+		if (lan966x->bridge != bridge)
+			return -ENODEV;
+	}
+
+	err = switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
+					    false, extack);
+	if (err)
+		return err;
+
+	lan966x->bridge_mask |= BIT(port->chip_port);
+
+	return 0;
+}
+
+static void lan966x_port_bridge_leave(struct lan966x_port *port,
+				      struct net_device *bridge)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan966x->bridge_mask &= ~BIT(port->chip_port);
+
+	if (!lan966x->bridge_mask)
+		lan966x->bridge = NULL;
+
+	/* Set the port back to host mode */
+	lan966x_vlan_port_set_vlan_aware(port, false);
+	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
+	lan966x_vlan_port_apply(port);
+
+	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
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
+static int lan966x_port_prechangeupper(struct net_device *dev,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
+		switchdev_bridge_port_unoffload(port->dev, port,
+						&lan966x->netdevice_nb,
+						&lan966x->switchdev_blocking_nb);
+
+	return NOTIFY_DONE;
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
+static struct lan966x_ext_entry *lan966x_ext_find_entry(struct lan966x *lan966x,
+							struct net_device *dev)
+{
+	struct lan966x_ext_entry *ext_entry;
+
+	list_for_each_entry(ext_entry, &lan966x->ext_entries, list) {
+		if (ext_entry->dev == dev)
+			return ext_entry;
+	}
+
+	return NULL;
+}
+
+static bool lan966x_ext_add_entry(struct lan966x *lan966x,
+				  struct net_device *dev)
+{
+	struct lan966x_ext_entry *ext_entry;
+
+	ext_entry = lan966x_ext_find_entry(lan966x, dev);
+	if (ext_entry) {
+		ext_entry->ports++;
+		return true;
+	}
+
+	ext_entry = kzalloc(sizeof(*ext_entry), GFP_KERNEL);
+	if (!ext_entry)
+		return false;
+
+	ext_entry->dev = dev;
+	ext_entry->ports = 1;
+	list_add_tail(&ext_entry->list, &lan966x->ext_entries);
+	return true;
+}
+
+static void lan966x_ext_remove_entry(struct lan966x *lan966x,
+				     struct net_device *dev)
+{
+	struct lan966x_ext_entry *ext_entry;
+
+	ext_entry = lan966x_ext_find_entry(lan966x, dev);
+	if (!ext_entry)
+		return;
+
+	ext_entry->ports--;
+	if (!ext_entry->ports) {
+		list_del(&ext_entry->list);
+		kfree(ext_entry);
+	}
+}
+
+void lan966x_ext_init(struct lan966x *lan966x)
+{
+	INIT_LIST_HEAD(&lan966x->ext_entries);
+}
+
+void lan966x_ext_purge_entries(struct lan966x *lan966x)
+{
+	struct lan966x_ext_entry *ext_entry, *tmp;
+
+	list_for_each_entry_safe(ext_entry, tmp, &lan966x->ext_entries, list) {
+		list_del(&ext_entry->list);
+		kfree(ext_entry);
+	}
+}
+
+static int lan966x_ext_check_entry(struct lan966x *lan966x,
+				   struct net_device *dev,
+				   unsigned long event,
+				   void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info;
+
+	if (event != NETDEV_PRECHANGEUPPER)
+		return 0;
+
+	info = ptr;
+	if (!netif_is_bridge_master(info->upper_dev))
+		return 0;
+
+	/* If the master is used by lan966x,  then don't allow the foreign
+	 * interfaces to be added
+	 */
+	if (lan966x->bridge == info->upper_dev)
+		return -EOPNOTSUPP;
+
+	/* The master is not used by lan966x so return OK, but keep the
+	 * master in a cache in case at a later point one of the lan966x ports
+	 * is added to it. In that case don't allow it.
+	 */
+	if (info->linking) {
+		if (!lan966x_ext_add_entry(lan966x, info->upper_dev))
+			return -EOPNOTSUPP;
+	} else {
+		lan966x_ext_remove_entry(lan966x, info->upper_dev);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static bool lan966x_port_ext_check_entry(struct net_device *dev,
+					 struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!netif_is_bridge_master(info->upper_dev) || !info->linking)
+		return true;
+
+	return lan966x_ext_find_entry(lan966x, info->upper_dev) ? false : true;
+}
+
+static int lan966x_netdevice_port_event(struct net_device *dev,
+					struct notifier_block *nb,
+					unsigned long event, void *ptr)
+{
+	struct lan966x *lan966x = container_of(nb, struct lan966x, netdevice_nb);
+	int err = 0;
+
+	if (!lan966x_netdevice_check(dev))
+		return lan966x_ext_check_entry(lan966x, dev, event, ptr);
+
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		if (!lan966x_port_ext_check_entry(dev, ptr))
+			return -EOPNOTSUPP;
+
+		err = lan966x_port_prechangeupper(dev, ptr);
+		break;
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
+static int lan966x_switchdev_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
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
+static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
+					    unsigned long event,
+					    void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
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
+	unregister_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
+	unregister_switchdev_notifier(&lan966x->switchdev_nb);
+	unregister_netdevice_notifier(&lan966x->netdevice_nb);
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 78d18ab00d81..268e93328a08 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -150,6 +150,11 @@ bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
 
 u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
 {
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!(lan966x->bridge_mask & BIT(port->chip_port)))
+		return HOST_PVID;
+
 	return port->vlan_aware ? port->pvid : UNAWARE_PVID;
 }
 
@@ -205,6 +210,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
 		 * table for the front port and the CPU
 		 */
 		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+		lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr,
+				      UNAWARE_PVID);
 
 		lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
 		lan966x_vlan_port_apply(port);
@@ -213,6 +220,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
 		 * to vlan unaware
 		 */
 		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+		lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr,
+				       UNAWARE_PVID);
 
 		lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
 		lan966x_vlan_port_apply(port);
@@ -288,6 +297,7 @@ int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
 	 */
 	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
 		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
+		lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
 	}
 
@@ -317,8 +327,10 @@ int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
 	 * that vlan but still keep it in the mask because it may be needed
 	 * again then another port gets added in tha vlan
 	 */
-	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
+		lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr, vid);
 		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+	}
 
 	return 0;
 }
-- 
2.33.0

