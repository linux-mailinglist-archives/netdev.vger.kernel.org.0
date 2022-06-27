Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36C55C833
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241168AbiF0UKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbiF0UKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:10:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D11F2C0;
        Mon, 27 Jun 2022 13:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656360608; x=1687896608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wgu6POdzgV8KAlLItDO1QhgVKPEmcMH6pP30KL3/CCk=;
  b=HdpX5BUOWAFo5g4rNsZG5WFsp8edZtb6K5nTf7W4f6N49Fkg8TOiGD8+
   g0TnGh5a1ok2DqYxHdHsvLNb+GE3xbN69I4JhNKfYI82z2L9w1+Xz+VMV
   zkO8OAktETVGbM/gtGQ+YpvnvLvxr8NllGYFEA2cy7uAMsGjxg1JrnUO7
   eGzbT3gOeQhy9Y0qti4Sxu6Z6nLYaZEC9+U26lslXrvN6oW/EKmslJdCq
   D0YUG0f1RD//7yj+XdRsFwqI7LMBN1U//QNYPjwIgK2zrAU8Yvai+ekk6
   xB5DdQDV9yyIIP/j0Uun45d5jDpTok9USW6UGHT8QYA74//Lotv39Py2R
   g==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="169809425"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 13:10:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 13:09:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 13:09:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 5/7] net: lan966x: Add lag support for lan966x.
Date:   Mon, 27 Jun 2022 22:13:28 +0200
Message-ID: <20220627201330.45219-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220627201330.45219-1-horatiu.vultur@microchip.com>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add link aggregation hardware offload support for lan966x

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 292 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  27 ++
 .../microchip/lan966x/lan966x_switchdev.c     |  77 ++++-
 4 files changed, 382 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index fd2e0ebb2427..0c22c86bdaa9 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
-			lan966x_ptp.o lan966x_fdma.o
+			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
new file mode 100644
index 000000000000..0da398e51aa3
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+static void lan966x_lag_set_aggr_pgids(struct lan966x *lan966x)
+{
+	u32 visited = GENMASK(lan966x->num_phys_ports - 1, 0);
+	int p, lag, i;
+
+	/* Reset destination and aggregation PGIDS */
+	for (p = 0; p < lan966x->num_phys_ports; ++p)
+		lan_wr(ANA_PGID_PGID_SET(BIT(p)),
+		       lan966x, ANA_PGID(p));
+
+	for (p = PGID_AGGR; p < PGID_SRC; ++p)
+		lan_wr(ANA_PGID_PGID_SET(visited),
+		       lan966x, ANA_PGID(p));
+
+	/* The visited ports bitmask holds the list of ports offloading any
+	 * bonding interface. Initially we mark all these ports as unvisited,
+	 * then every time we visit a port in this bitmask, we know that it is
+	 * the lowest numbered port, i.e. the one whose logical ID == physical
+	 * port ID == LAG ID. So we mark as visited all further ports in the
+	 * bitmask that are offloading the same bonding interface. This way,
+	 * we set up the aggregation PGIDs only once per bonding interface.
+	 */
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		struct lan966x_port *port = lan966x->ports[p];
+
+		if (!port || !port->bond)
+			continue;
+
+		visited &= ~BIT(p);
+	}
+
+	/* Now, set PGIDs for each active LAG */
+	for (lag = 0; lag < lan966x->num_phys_ports; ++lag) {
+		struct net_device *bond = lan966x->ports[lag]->bond;
+		int num_active_ports = 0;
+		unsigned long bond_mask;
+		u8 aggr_idx[16];
+
+		if (!bond || (visited & BIT(lag)))
+			continue;
+
+		bond_mask = lan966x_lag_get_mask(lan966x, bond);
+
+		for_each_set_bit(p, &bond_mask, lan966x->num_phys_ports) {
+			struct lan966x_port *port = lan966x->ports[p];
+
+			lan_wr(ANA_PGID_PGID_SET(bond_mask),
+			       lan966x, ANA_PGID(p));
+			if (port->lag_tx_active)
+				aggr_idx[num_active_ports++] = p;
+		}
+
+		for (i = PGID_AGGR; i < PGID_SRC; ++i) {
+			u32 ac;
+
+			ac = lan_rd(lan966x, ANA_PGID(i));
+			ac &= ~bond_mask;
+			/* Don't do division by zero if there was no active
+			 * port. Just make all aggregation codes zero.
+			 */
+			if (num_active_ports)
+				ac |= BIT(aggr_idx[i % num_active_ports]);
+			lan_wr(ANA_PGID_PGID_SET(ac),
+			       lan966x, ANA_PGID(i));
+		}
+
+		/* Mark all ports in the same LAG as visited to avoid applying
+		 * the same config again.
+		 */
+		for (p = lag; p < lan966x->num_phys_ports; p++) {
+			struct lan966x_port *port = lan966x->ports[p];
+
+			if (!port)
+				continue;
+
+			if (port->bond == bond)
+				visited |= BIT(p);
+		}
+	}
+}
+
+static void lan966x_lag_set_port_ids(struct lan966x *lan966x)
+{
+	struct lan966x_port *port;
+	u32 bond_mask;
+	u32 lag_id;
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		port = lan966x->ports[p];
+		if (!port)
+			continue;
+
+		lag_id = port->chip_port;
+
+		bond_mask = lan966x_lag_get_mask(lan966x, port->bond);
+		if (bond_mask)
+			lag_id = __ffs(bond_mask);
+
+		lan_rmw(ANA_PORT_CFG_PORTID_VAL_SET(lag_id),
+			ANA_PORT_CFG_PORTID_VAL,
+			lan966x, ANA_PORT_CFG(port->chip_port));
+	}
+}
+
+int lan966x_lag_port_join(struct lan966x_port *port,
+			  struct net_device *brport_dev,
+			  struct net_device *bond,
+			  struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct net_device *dev = port->dev;
+
+	port->bond = bond;
+	lan966x_lag_set_port_ids(lan966x);
+	lan966x_update_fwd_mask(lan966x);
+	lan966x_lag_set_aggr_pgids(lan966x);
+
+	switchdev_bridge_port_offload(brport_dev, dev, port,
+				      &lan966x_switchdev_nb,
+				      &lan966x_switchdev_blocking_nb,
+				      false, extack);
+
+	return 0;
+}
+
+void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	port->bond = NULL;
+	lan966x_lag_set_port_ids(lan966x);
+	lan966x_update_fwd_mask(lan966x);
+	lan966x_lag_set_aggr_pgids(lan966x);
+}
+
+int lan966x_lag_port_prechangeupper(struct net_device *dev,
+				    struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct netdev_lag_upper_info *lui;
+	struct netlink_ext_ack *extack;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+	lui = info->upper_info;
+	if (!lui)
+		return NOTIFY_DONE;
+
+	if (lui->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG device using unsupported Tx type");
+		return notifier_from_errno(-EINVAL);
+	}
+
+	switch (lui->hash_type) {
+	case NETDEV_LAG_HASH_L2:
+		lan_wr(ANA_AGGR_CFG_AC_DMAC_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_SMAC_ENA_SET(1),
+		       lan966x, ANA_AGGR_CFG);
+		break;
+	case NETDEV_LAG_HASH_L34:
+		lan_wr(ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA_SET(1),
+		       lan966x, ANA_AGGR_CFG);
+		break;
+	case NETDEV_LAG_HASH_L23:
+		lan_wr(ANA_AGGR_CFG_AC_DMAC_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_SMAC_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_SET(1) |
+		       ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_SET(1),
+		       lan966x, ANA_AGGR_CFG);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG device using unsupported hash type");
+		return notifier_from_errno(-EINVAL);
+	}
+
+	return NOTIFY_OK;
+}
+
+int lan966x_lag_port_changelowerstate(struct net_device *dev,
+				      struct netdev_notifier_changelowerstate_info *info)
+{
+	struct netdev_lag_lower_state_info *lag = info->lower_state_info;
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	bool is_active;
+
+	if (!port->bond)
+		return NOTIFY_DONE;
+
+	is_active = lag->link_up && lag->tx_enabled;
+	if (port->lag_tx_active == is_active)
+		return NOTIFY_DONE;
+
+	port->lag_tx_active = is_active;
+	lan966x_lag_set_aggr_pgids(lan966x);
+
+	return NOTIFY_OK;
+}
+
+int lan966x_lag_netdev_prechangeupper(struct net_device *dev,
+				      struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port;
+	struct net_device *lower;
+	struct list_head *iter;
+	int err;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		if (!lan966x_netdevice_check(lower))
+			continue;
+
+		port = netdev_priv(lower);
+		if (port->bond != dev)
+			continue;
+
+		err = lan966x_port_prechangeupper(lower, dev, info);
+		if (err)
+			return err;
+	}
+
+	return NOTIFY_DONE;
+}
+
+int lan966x_lag_netdev_changeupper(struct net_device *dev,
+				   struct netdev_notifier_changeupper_info *info)
+{
+	struct lan966x_port *port;
+	struct net_device *lower;
+	struct list_head *iter;
+	int err;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		if (!lan966x_netdevice_check(lower))
+			continue;
+
+		port = netdev_priv(lower);
+		if (port->bond != dev)
+			continue;
+
+		err = lan966x_port_changeupper(lower, dev, info);
+		if (err)
+			return err;
+	}
+
+	return NOTIFY_DONE;
+}
+
+bool lan966x_lag_first_port(struct net_device *lag, struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	unsigned long bond_mask;
+
+	if (port->bond != lag)
+		return false;
+
+	bond_mask = lan966x_lag_get_mask(lan966x, lag);
+	if (bond_mask && port->chip_port == __ffs(bond_mask))
+		return true;
+
+	return false;
+}
+
+u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond)
+{
+	struct lan966x_port *port;
+	u32 mask = 0;
+	int p;
+
+	if (!bond)
+		return mask;
+
+	for (p = 0; p < lan966x->num_phys_ports; p++) {
+		port = lan966x->ports[p];
+		if (!port)
+			continue;
+
+		if (port->bond == bond)
+			mask |= BIT(p);
+	}
+
+	return mask;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 4701c20c8393..23ddabea8d70 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -291,6 +291,9 @@ struct lan966x_port {
 	u8 ptp_cmd;
 	u16 ts_id;
 	struct sk_buff_head tx_skbs;
+
+	struct net_device *bond;
+	bool lag_tx_active;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -407,6 +410,30 @@ int lan966x_fdma_init(struct lan966x *lan966x);
 void lan966x_fdma_deinit(struct lan966x *lan966x);
 irqreturn_t lan966x_fdma_irq_handler(int irq, void *args);
 
+int lan966x_lag_port_join(struct lan966x_port *port,
+			  struct net_device *brport_dev,
+			  struct net_device *bond,
+			  struct netlink_ext_ack *extack);
+void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond);
+int lan966x_lag_port_prechangeupper(struct net_device *dev,
+				    struct netdev_notifier_changeupper_info *info);
+int lan966x_lag_port_changelowerstate(struct net_device *dev,
+				      struct netdev_notifier_changelowerstate_info *info);
+int lan966x_lag_netdev_prechangeupper(struct net_device *dev,
+				      struct netdev_notifier_changeupper_info *info);
+int lan966x_lag_netdev_changeupper(struct net_device *dev,
+				   struct netdev_notifier_changeupper_info *info);
+bool lan966x_lag_first_port(struct net_device *lag, struct net_device *dev);
+u32 lan966x_lag_get_mask(struct lan966x *lan966x, struct net_device *bond);
+
+int lan966x_port_changeupper(struct net_device *dev,
+			     struct net_device *brport_dev,
+			     struct netdev_notifier_changeupper_info *info);
+int lan966x_port_prechangeupper(struct net_device *dev,
+				struct net_device *brport_dev,
+				struct netdev_notifier_changeupper_info *info);
+void lan966x_update_fwd_mask(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 4bc626ce031a..84d54e528501 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -130,7 +130,7 @@ static int lan966x_port_pre_bridge_flags(struct lan966x_port *port,
 	return 0;
 }
 
-static void lan966x_update_fwd_mask(struct lan966x *lan966x)
+void lan966x_update_fwd_mask(struct lan966x *lan966x)
 {
 	int i;
 
@@ -138,9 +138,14 @@ static void lan966x_update_fwd_mask(struct lan966x *lan966x)
 		struct lan966x_port *port = lan966x->ports[i];
 		unsigned long mask = 0;
 
-		if (port && lan966x->bridge_fwd_mask & BIT(i))
+		if (port && lan966x->bridge_fwd_mask & BIT(i)) {
 			mask = lan966x->bridge_fwd_mask & ~BIT(i);
 
+			if (port->bond)
+				mask &= ~lan966x_lag_get_mask(lan966x,
+							      port->bond);
+		}
+
 		mask |= BIT(CPU_PORT);
 
 		lan_wr(ANA_PGID_PGID_SET(mask),
@@ -239,6 +244,7 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 }
 
 static int lan966x_port_bridge_join(struct lan966x_port *port,
+				    struct net_device *brport_dev,
 				    struct net_device *bridge,
 				    struct netlink_ext_ack *extack)
 {
@@ -256,7 +262,7 @@ static int lan966x_port_bridge_join(struct lan966x_port *port,
 		}
 	}
 
-	err = switchdev_bridge_port_offload(dev, dev, port,
+	err = switchdev_bridge_port_offload(brport_dev, dev, port,
 					    &lan966x_switchdev_nb,
 					    &lan966x_switchdev_blocking_nb,
 					    false, extack);
@@ -293,8 +299,9 @@ static void lan966x_port_bridge_leave(struct lan966x_port *port,
 	lan966x_vlan_port_apply(port);
 }
 
-static int lan966x_port_changeupper(struct net_device *dev,
-				    struct netdev_notifier_changeupper_info *info)
+int lan966x_port_changeupper(struct net_device *dev,
+			     struct net_device *brport_dev,
+			     struct netdev_notifier_changeupper_info *info)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
@@ -304,25 +311,42 @@ static int lan966x_port_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking)
-			err = lan966x_port_bridge_join(port, info->upper_dev,
+			err = lan966x_port_bridge_join(port, brport_dev,
+						       info->upper_dev,
 						       extack);
 		else
 			lan966x_port_bridge_leave(port, info->upper_dev);
 	}
 
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking)
+			err = lan966x_lag_port_join(port, info->upper_dev,
+						    info->upper_dev,
+						    extack);
+		else
+			lan966x_lag_port_leave(port, info->upper_dev);
+	}
+
 	return err;
 }
 
-static int lan966x_port_prechangeupper(struct net_device *dev,
-				       struct netdev_notifier_changeupper_info *info)
+int lan966x_port_prechangeupper(struct net_device *dev,
+				struct net_device *brport_dev,
+				struct netdev_notifier_changeupper_info *info)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	int err = NOTIFY_DONE;
 
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
-		switchdev_bridge_port_unoffload(port->dev, port,
-						NULL, NULL);
+		switchdev_bridge_port_unoffload(brport_dev, port, NULL, NULL);
 
-	return NOTIFY_DONE;
+	if (netif_is_lag_master(info->upper_dev) && info->linking)
+		err = lan966x_lag_port_prechangeupper(dev, info);
+
+	if (netif_is_lag_master(info->upper_dev) && !info->linking)
+		switchdev_bridge_port_unoffload(brport_dev, port, NULL, NULL);
+
+	return err;
 }
 
 static int lan966x_foreign_bridging_check(struct net_device *upper,
@@ -400,21 +424,44 @@ static int lan966x_netdevice_port_event(struct net_device *dev,
 	int err = 0;
 
 	if (!lan966x_netdevice_check(dev)) {
-		if (event == NETDEV_CHANGEUPPER)
-			return lan966x_bridge_check(dev, ptr);
+		switch (event) {
+		case NETDEV_CHANGEUPPER:
+		case NETDEV_PRECHANGEUPPER:
+			err = lan966x_bridge_check(dev, ptr);
+			if (err)
+				return err;
+
+			if (netif_is_lag_master(dev)) {
+				if (event == NETDEV_CHANGEUPPER)
+					err = lan966x_lag_netdev_changeupper(dev,
+									     ptr);
+				else
+					err = lan966x_lag_netdev_prechangeupper(dev,
+										ptr);
+
+				return err;
+			}
+			break;
+		default:
+			return 0;
+		}
+
 		return 0;
 	}
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		err = lan966x_port_prechangeupper(dev, ptr);
+		err = lan966x_port_prechangeupper(dev, dev, ptr);
 		break;
 	case NETDEV_CHANGEUPPER:
 		err = lan966x_bridge_check(dev, ptr);
 		if (err)
 			return err;
 
-		err = lan966x_port_changeupper(dev, ptr);
+		err = lan966x_port_changeupper(dev, dev, ptr);
+		break;
+	case NETDEV_CHANGELOWERSTATE:
+		err = lan966x_lag_port_changelowerstate(dev, ptr);
 		break;
 	}
 
-- 
2.33.0

