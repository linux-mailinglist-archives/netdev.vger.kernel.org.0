Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69398597695
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiHQTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238368AbiHQTbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B8D97D4F;
        Wed, 17 Aug 2022 12:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764661; x=1692300661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x/ty76AJsDtLiPWehmmB97wsO0JueVJBh4uSG5UkQqA=;
  b=Vd/XcI47SAD3V0cwDuxjIMOKr8Uz2dWzhHKkR5tot6tXX+XBbrXvzXsL
   dpDpkPM6/cwoSKSNXJ8bN4re/qPa1Zh2kWTm/Yf+AwwHflyFtsnmymJg9
   QZniRoIgDbD75qaDV6IY/H3NtkZM/gCo1NSrY5pGdrVgXATT9eH6h6hR+
   xnTVkLs7KqI0ENLPa608Ajr4r44SdYL1bFrTb9HiWve6b2ub2Gxnyt4Wo
   YxOXdSrGVsqSiXo0UVxmccNuk/0UV9pytvzOqLt7CV5IQetJfV3fI9YLe
   IDitEv16xz/7brbwfgSSxCo/SxG52PC/rW8y6wvEQs3kWW2Lr/2zDrsRx
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="109504379"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 6/8] net: lan966x: Add lag support for lan966x
Date:   Wed, 17 Aug 2022 21:34:47 +0200
Message-ID: <20220817193449.1673002-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add link aggregation hardware offload support for lan966x

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 337 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  31 ++
 .../microchip/lan966x/lan966x_switchdev.c     |  92 ++++-
 5 files changed, 443 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 4241ff0e5098..49e1464a4313 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -4,6 +4,7 @@ config LAN966X_SWITCH
 	depends on HAS_IOMEM
 	depends on OF
 	depends on NET_SWITCHDEV
+	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
 	select PACKING
 	help
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
index 000000000000..e214e8e50723
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/if_bridge.h>
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
+static void lan966x_lag_update_ids(struct lan966x *lan966x)
+{
+	lan966x_lag_set_port_ids(lan966x);
+	lan966x_update_fwd_mask(lan966x);
+	lan966x_lag_set_aggr_pgids(lan966x);
+}
+
+int lan966x_lag_port_join(struct lan966x_port *port,
+			  struct net_device *brport_dev,
+			  struct net_device *bond,
+			  struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct net_device *dev = port->dev;
+	int err;
+
+	port->bond = bond;
+	lan966x_lag_update_ids(lan966x);
+
+	err = switchdev_bridge_port_offload(brport_dev, dev, port,
+					    &lan966x_switchdev_nb,
+					    &lan966x_switchdev_blocking_nb,
+					    false, extack);
+	if (err)
+		goto out;
+
+	lan966x_port_stp_state_set(port, br_port_get_stp_state(brport_dev));
+
+	return 0;
+
+out:
+	port->bond = NULL;
+	lan966x_lag_update_ids(lan966x);
+
+	return err;
+}
+
+void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	port->bond = NULL;
+	lan966x_lag_update_ids(lan966x);
+	lan966x_port_stp_state_set(port, BR_STATE_FORWARDING);
+}
+
+static bool lan966x_lag_port_check_hash_types(struct lan966x *lan966x,
+					      enum netdev_lag_hash hash_type)
+{
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		struct lan966x_port *port = lan966x->ports[p];
+
+		if (!port || !port->bond)
+			continue;
+
+		if (port->hash_type != hash_type)
+			return false;
+	}
+
+	return true;
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
+	if (!lui) {
+		port->hash_type = NETDEV_LAG_HASH_NONE;
+		return NOTIFY_DONE;
+	}
+
+	if (lui->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG device using unsupported Tx type");
+		return -EINVAL;
+	}
+
+	if (!lan966x_lag_port_check_hash_types(lan966x, lui->hash_type)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG devices can have only the same hash_type");
+		return -EINVAL;
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
+		return -EINVAL;
+	}
+
+	port->hash_type = lui->hash_type;
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
index 516ed8e9183d..96182ae0df3e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -292,6 +292,10 @@ struct lan966x_port {
 	u8 ptp_cmd;
 	u16 ts_id;
 	struct sk_buff_head tx_skbs;
+
+	struct net_device *bond;
+	bool lag_tx_active;
+	enum netdev_lag_hash hash_type;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -409,6 +413,33 @@ int lan966x_fdma_init(struct lan966x *lan966x);
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
+void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state);
+void lan966x_port_ageing_set(struct lan966x_port *port,
+			     unsigned long ageing_clock_t);
+void lan966x_update_fwd_mask(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index c4951eeb6636..5bf574111bce 100644
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
@@ -148,7 +153,7 @@ static void lan966x_update_fwd_mask(struct lan966x *lan966x)
 	}
 }
 
-static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
+void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
 {
 	struct lan966x *lan966x = port->lan966x;
 	bool learn_ena = false;
@@ -169,8 +174,8 @@ static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
 	lan966x_update_fwd_mask(lan966x);
 }
 
-static void lan966x_port_ageing_set(struct lan966x_port *port,
-				    unsigned long ageing_clock_t)
+void lan966x_port_ageing_set(struct lan966x_port *port,
+			     unsigned long ageing_clock_t)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
 	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
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
@@ -304,26 +311,46 @@ static int lan966x_port_changeupper(struct net_device *dev,
 
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
 
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking) {
 		switchdev_bridge_port_unoffload(port->dev, port, NULL, NULL);
 		lan966x_fdb_flush_workqueue(port->lan966x);
 	}
 
-	return NOTIFY_DONE;
+	if (netif_is_lag_master(info->upper_dev)) {
+		err = lan966x_lag_port_prechangeupper(dev, info);
+		if (err || info->linking)
+			return err;
+
+		switchdev_bridge_port_unoffload(brport_dev, port, NULL, NULL);
+	}
+
+	return err;
 }
 
 static int lan966x_foreign_bridging_check(struct net_device *upper,
@@ -401,21 +428,44 @@ static int lan966x_netdevice_port_event(struct net_device *dev,
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
 
@@ -433,19 +483,23 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(ret);
 }
 
-/* We don't offload uppers such as LAG as bridge ports, so every device except
- * the bridge itself is foreign.
- */
 static bool lan966x_foreign_dev_check(const struct net_device *dev,
 				      const struct net_device *foreign_dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
+	int i;
 
 	if (netif_is_bridge_master(foreign_dev))
 		if (lan966x->bridge == foreign_dev)
 			return false;
 
+	if (netif_is_lag_master(foreign_dev))
+		for (i = 0; i < lan966x->num_phys_ports; ++i)
+			if (lan966x->ports[i] &&
+			    lan966x->ports[i]->bond == foreign_dev)
+				return false;
+
 	return true;
 }
 
-- 
2.33.0

