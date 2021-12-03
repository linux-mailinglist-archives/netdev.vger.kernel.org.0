Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA7D46758B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380099AbhLCKtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32101 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380109AbhLCKt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528363; x=1670064363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NXs5gV+27rpQoJzwNXvMmUzE3YgJzT0J31DSHN1iOwU=;
  b=D2NEySohrF8UhD1yn1OT320Q0jPEfbBKzYl46c+uMPVVTAnCnyoUG2OL
   g32U7hUSVTdfwllIOxWMD8bTSlwxVkRRKKCQDKOKPkZ9PIOmmyMSjrAfS
   1tZRcGzIqke3/olmXndiXyik7vbiAUY+end34rvMU/5FoFxUIhVFeqBKT
   VoOLyOdE0HYDe0u+arT42W0dsjPsSiiEcNJYnxw8/CytGriywFLSZVr9N
   lab7injSiSAA9myLynqvCh9kvAtSaK2LYiuCLmLIy//75XPv24wrR5cB3
   q/fuyxO7RAcGzPs+zzLJsAU+Af11EXXI+hvMKSiKOiBcJG2XD7pRKT/JD
   A==;
IronPort-SDR: S8Akf3B+bIAYpCgS1EYGwzPSSTZFFi47SHujwyIm0zRwFoCY8eVdRmvpri/z+00bgdvy7ePASP
 gStcYtL6V1xZ4NZUJAGD9cNQ8ZGbfMUUUDHQO2Et5nmwXLSJLqYrxrKMz2YFHpTxQeqcvjGvXB
 yqW4VbAh5TEmYjFBJmD2eXSu4Ha1Mn15uHlayT8z2FYuDHe+DAtpIfQ0WQDaGvKGmMSVY+C2fD
 DSJR8MWNFlh75zGYJ7heZW0MhF6xScLaSm0wy6VTxA0RMdjFOINBzaLQfkkIV8oJlT1fAhmG9r
 sLVz48SuQ5d+dnZ81HxLlVfE
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="145985169"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:46:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:46:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:46:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/6] net: lan966x: Add vlan support
Date:   Fri, 3 Dec 2021 11:46:44 +0100
Message-ID: <20211203104645.1476704-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
References: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for vlan in lan966x.
This allows add/remove front ports from vlans and also allows the CPU
port to be added/remove from vlans. In this way it is possible to
filter frames towards the CPU based on the vlan.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  35 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  39 +-
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 432 ++++++++++++++++++
 5 files changed, 504 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 2989ba528236..f7e6068a91cb 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
-			lan966x_mac.o lan966x_ethtool.o
+			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 690184eba81b..aa72f39bc19d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -197,7 +197,7 @@ static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type,
 	struct switchdev_notifier_fdb_info info = { 0 };
 
 	info.addr = mac;
-	info.vid = vid == PORT_PVID ? 0 : vid;
+	info.vid = vid == UNAWARE_PVID ? 0 : vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 38868cf184c6..3b6926553e52 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -103,17 +103,18 @@ static int lan966x_create_targets(struct platform_device *pdev,
 static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	u16 pvid = lan966x_vlan_port_get_pvid(port);
 	struct lan966x *lan966x = port->lan966x;
 	const struct sockaddr *addr = p;
 	int ret;
 
 	/* Learn the new net device MAC address in the mac table. */
-	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, port->pvid);
+	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, pvid);
 	if (ret)
 		return ret;
 
 	/* Then forget the previous one. */
-	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, port->pvid);
+	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, pvid);
 	if (ret)
 		return ret;
 
@@ -283,6 +284,12 @@ static void lan966x_ifh_set_ipv(void *ifh, u64 bypass)
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
@@ -294,6 +301,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
 	lan966x_ifh_set_qos_class(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
 	lan966x_ifh_set_ipv(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
+	lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
 
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
@@ -365,6 +373,18 @@ static int lan966x_port_get_parent_id(struct net_device *dev,
 	return 0;
 }
 
+static int lan966x_port_set_features(struct net_device *dev,
+				     netdev_features_t features)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	netdev_features_t changed = dev->features ^ features;
+
+	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
+		lan966x_vlan_mode(port, features);
+
+	return 0;
+}
+
 static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_open			= lan966x_port_open,
 	.ndo_stop			= lan966x_port_stop,
@@ -376,6 +396,9 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_get_stats64		= lan966x_stats_get,
 	.ndo_set_mac_address		= lan966x_port_set_mac_address,
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
+	.ndo_set_features		= lan966x_port_set_features,
+	.ndo_vlan_rx_add_vid		= lan966x_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid		= lan966x_vlan_rx_kill_vid,
 };
 
 static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
@@ -585,7 +608,6 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	port->dev = dev;
 	port->lan966x = lan966x;
 	port->chip_port = p;
-	port->pvid = PORT_PVID;
 	lan966x->ports[p] = port;
 
 	dev->max_mtu = ETH_MAX_MTU;
@@ -638,6 +660,10 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 		return err;
 	}
 
+	lan966x_vlan_port_set_vlan_aware(port, 0);
+	lan966x_vlan_port_set_vid(port, UNAWARE_PVID, false, false);
+	lan966x_vlan_port_apply(port);
+
 	return 0;
 }
 
@@ -648,6 +674,9 @@ static void lan966x_init(struct lan966x *lan966x)
 	/* MAC table initialization */
 	lan966x_mac_init(lan966x);
 
+	/* Vlan initialization */
+	lan966x_vlan_init(lan966x);
+
 	/* Flush queues */
 	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
 	       GENMASK(1, 0),
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c6749ef0418a..56603b72423c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -4,6 +4,7 @@
 #define __LAN966X_MAIN_H__
 
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/jiffies.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
@@ -22,7 +23,7 @@
 #define PGID_SRC			80
 #define PGID_ENTRIES			89
 
-#define PORT_PVID			0
+#define UNAWARE_PVID			4095
 
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
@@ -78,6 +79,9 @@ struct lan966x {
 	struct list_head mac_entries;
 	spinlock_t mac_lock; /* lock for mac_entries list */
 
+	u16 vlan_mask[VLAN_N_VID];
+	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
+
 	/* stats */
 	const struct lan966x_stat_layout *stats_layout;
 	u32 num_stats;
@@ -109,6 +113,8 @@ struct lan966x_port {
 
 	u8 chip_port;
 	u16 pvid;
+	u16 vid;
+	u8 vlan_aware;
 
 	struct phylink_config phylink_config;
 	struct phylink_pcs phylink_pcs;
@@ -156,6 +162,37 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
 			  u16 vid);
 irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
 
+void lan966x_vlan_init(struct lan966x *lan966x);
+void lan966x_vlan_port_apply(struct lan966x_port *port);
+
+int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid);
+int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
+
+void lan966x_vlan_mode(struct lan966x_port *port, netdev_features_t features);
+u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port);
+
+bool lan966x_vlan_port_member_vlan_mask(struct lan966x_port *port, u16 vid);
+bool lan966x_vlan_cpu_member_vlan_mask(struct lan966x *lan966x, u16 vid);
+bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid);
+
+void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port);
+void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
+				      bool vlan_aware);
+int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
+			      bool pvid, bool untagged);
+int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
+			       u16 vid,
+			       bool pvid,
+			       bool untagged);
+int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
+			       u16 vid);
+int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
+			      struct net_device *dev,
+			      u16 vid);
+int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
+			      struct net_device *dev,
+			      u16 vid);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
new file mode 100644
index 000000000000..c035f24e77c2
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -0,0 +1,432 @@
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
+static int lan966x_vlan_set_mask(struct lan966x *lan966x, u16 vid)
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
+	return lan966x_vlan_wait_for_completion(lan966x);
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
+	/* Set all the ports + cpu to be part of UNAWARE_PVID */
+	lan966x->vlan_mask[UNAWARE_PVID] =
+		GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
+	lan966x_vlan_set_mask(lan966x, UNAWARE_PVID);
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
+
+static int lan966x_vlan_port_add_vlan_mask(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 p = port->chip_port;
+
+	lan966x->vlan_mask[vid] |= BIT(p);
+	return lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static int lan966x_vlan_port_del_vlan_mask(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 p = port->chip_port;
+
+	lan966x->vlan_mask[vid] &= ~BIT(p);
+	return lan966x_vlan_set_mask(lan966x, vid);
+}
+
+bool lan966x_vlan_port_member_vlan_mask(struct lan966x_port *port, u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 p = port->chip_port;
+
+	return lan966x->vlan_mask[vid] & BIT(p);
+}
+
+bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	return !!(lan966x->vlan_mask[vid] & ~BIT(CPU_PORT));
+}
+
+static int lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	lan966x->vlan_mask[vid] |= BIT(CPU_PORT);
+	return lan966x_vlan_set_mask(lan966x, vid);
+}
+
+static int lan966x_vlan_cpu_del_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	lan966x->vlan_mask[vid] &= ~BIT(CPU_PORT);
+	return lan966x_vlan_set_mask(lan966x, vid);
+}
+
+bool lan966x_vlan_cpu_member_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	return lan966x->vlan_mask[vid] & BIT(CPU_PORT);
+}
+
+static void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	set_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+static void lan966x_vlan_cpu_del_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	clear_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+static bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 vid)
+{
+	return test_bit(vid, lan966x->cpu_vlan_mask);
+}
+
+u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
+{
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
+static int lan966x_vlan_port_remove_vid(struct lan966x_port *port, u16 vid)
+{
+	if (port->pvid == vid)
+		port->pvid = 0;
+
+	if (port->vid == vid)
+		port->vid = 0;
+
+	return 0;
+}
+
+void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
+				      bool vlan_aware)
+{
+	port->vlan_aware = vlan_aware;
+}
+
+void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!port->vlan_aware) {
+		/* In case of vlan unaware, all the ports will be set in
+		 * UNAWARE_PVID and have their PVID set to this PVID
+		 * The CPU doesn't need to be added because it is always part of
+		 * that vlan, it is required just to add entries in the MAC
+		 * table for the front port and the CPU
+		 */
+		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+
+		lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
+		lan966x_vlan_port_apply(port);
+	} else {
+		/* In case of vlan aware, just clear what happened when changed
+		 * to vlan unaware
+		 */
+		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
+
+		lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
+		lan966x_vlan_port_apply(port);
+	}
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
+	/* Default vlan to casify for untagged frames (may be zero) */
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
+int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
+			       u16 vid,
+			       bool pvid,
+			       bool untagged)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* If the CPU(br) is already part of the vlan then add the MAC
+	 * address of the device in MAC table to copy the frames to the
+	 * CPU(br). If the CPU(br) is not part of the vlan then it would
+	 * just drop the frames.
+	 */
+	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
+		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
+		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
+	}
+
+	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
+	lan966x_vlan_port_add_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+
+	return 0;
+}
+
+int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
+			       u16 vid)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* In case the CPU(br) is part of the vlan then remove the MAC entry
+	 * because frame doesn't need to reach to CPU
+	 */
+	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid))
+		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
+
+	lan966x_vlan_port_remove_vid(port, vid);
+	lan966x_vlan_port_del_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+
+	/* In case there are no other ports in vlan then remove the CPU from
+	 * that vlan but still keep it in the mask because it may be needed
+	 * again then another port gets added in tha vlan
+	 */
+	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+
+	return 0;
+}
+
+int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
+			      struct net_device *dev,
+			      u16 vid)
+{
+	int p;
+
+	/* Iterate over the ports and see which ones are part of the
+	 * vlan and for those ports add entry in the MAC table to
+	 * copy the frames to the CPU
+	 */
+	for (p = 0; p < lan966x->num_phys_ports; p++) {
+		struct lan966x_port *port = lan966x->ports[p];
+
+		if (!port ||
+		    !lan966x_vlan_port_member_vlan_mask(port, vid))
+			continue;
+
+		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
+	}
+
+	/* Add an entry in the MAC table for the CPU */
+	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid))
+		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
+
+	/* Add the CPU part of the vlan only if there is another port in that
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
+
+	return 0;
+}
+
+int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
+			      struct net_device *dev,
+			      u16 vid)
+{
+	int p;
+
+	/* Iterate over the ports and see which ones are part of the
+	 * vlan and for those ports remove entry in the MAC table to
+	 * copy the frames to the CPU
+	 */
+	for (p = 0; p < lan966x->num_phys_ports; p++) {
+		struct lan966x_port *port = lan966x->ports[p];
+
+		if (!port ||
+		    !lan966x_vlan_port_member_vlan_mask(port, vid))
+			continue;
+
+		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
+	}
+
+	/* Remove an entry in the MAC table for the CPU */
+	lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
+
+	/* Remove the CPU part of the vlan */
+	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
+	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
+
+	return 0;
+}
+
+int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	lan966x_vlan_port_set_vid(port, vid, false, false);
+	lan966x_vlan_port_add_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+
+	return 0;
+}
+
+int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
+			     u16 vid)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	lan966x_vlan_port_remove_vid(port, vid);
+	lan966x_vlan_port_del_vlan_mask(port, vid);
+	lan966x_vlan_port_apply(port);
+
+	return 0;
+}
+
+void lan966x_vlan_mode(struct lan966x_port *port,
+		       netdev_features_t features)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	/* Filtering */
+	val = lan_rd(lan966x, ANA_VLANMASK);
+	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		val |= BIT(port->chip_port);
+	else
+		val &= ~BIT(port->chip_port);
+	lan_wr(val, lan966x, ANA_VLANMASK);
+}
-- 
2.33.0

