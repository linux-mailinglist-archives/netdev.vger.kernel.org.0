Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06E4A95CF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 10:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbiBDJOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 04:14:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24423 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiBDJOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 04:14:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643966050; x=1675502050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PXz5LcqbB2J5E4dIMZHvhO7p3+GuhjBzt1wp7IDft7Q=;
  b=NIwe73Bjk9a0yZTcnahQnVky6wwMrOBTd548bBPnDQjorW3D2GpGWFTp
   weq9YRIEIsptApnEvxNY2+OzWCwQ8BUgitjTGn+YuK867eQ8tz6Lh8hP6
   62jpGzinwM2yMFNCD81OTKxQ9zGx0rwvzLTrxcvwTLyQP3iGX6vba/PnF
   4od4BhCrJaJOBuDTSs1RHEaAnqt5RIInmX8HBzOBMF/vhg02Jl295Fcot
   1+kP1noMXB38pQgRmdbD4kXzo8o364ZyCDsTn/uNLePF/fsIKU/uTi+rx
   pD1LYDbF6hyYHwKpJttHcTKs8bhXTQ+cQA3LRtnGw/I0Jj00Vi2iD4OIT
   Q==;
IronPort-SDR: pZeOjiO2xZdE5xTS95nnnF2WM6NNBMxXo4JZiFyxQrNEk0nrfevrt2mV9KNb2F999YepBFrReA
 jubzhnGLeP1fKu6hqjWTxsUnzGIktO4UfcSa3QEk4LUwnskmZIj721saEJ2OIrnZq5kD7jYqfz
 Hu2rVL9sCQ2+kGxX7W67JAAyQHdHVZwzzH07FqrmF+4+GSKa3RbIJoe+SilL11Ah/rielV097R
 87KSo72U5QdjKTcbk7fGAxeqN7I8f527yaGM/Ezj/zg0u8p+oohSvuHpjIOTZMbNK6hx7c9Spc
 FfKQXri1/UbXeJw/16imwSER
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="151947614"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 02:14:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 02:14:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 02:14:04 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/3] net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
Date:   Fri, 4 Feb 2022 10:14:51 +0100
Message-ID: <20220204091452.403706-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220204091452.403706-1-horatiu.vultur@microchip.com>
References: <20220204091452.403706-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback allows to enable/disable multicast snooping.
When the snooping is enabled, all IGMP and MLD frames are redirected to
the CPU, therefore make sure not to set the skb flag 'offload_fwd_mark'.
The HW will not flood multicast ipv4/ipv6 data frames.
When the snooping is disabled, the HW will flood IGMP, MLD and multicast
ipv4/ipv6 frames according to the mcast_flood flag.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 35 +++++++++++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  1 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 18 ++++++
 .../microchip/lan966x/lan966x_switchdev.c     | 57 +++++++++++++++++++
 4 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 3d1072955183..d62484f14564 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -4,11 +4,13 @@
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
 #include <linux/iopoll.h>
+#include <linux/ip.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/packing.h>
 #include <linux/phy/phy.h>
 #include <linux/reset.h>
+#include <net/addrconf.h>
 
 #include "lan966x_main.h"
 
@@ -419,6 +421,32 @@ bool lan966x_netdevice_check(const struct net_device *dev)
 	return dev->netdev_ops == &lan966x_port_netdev_ops;
 }
 
+static bool lan966x_hw_offload(struct lan966x *lan966x, u32 port,
+			       struct sk_buff *skb)
+{
+	u32 val;
+
+	/* The IGMP and MLD frames are not forward by the HW if
+	 * multicast snooping is enabled, therefor don't mark as
+	 * offload to allow the SW to forward the frames accordingly.
+	 */
+	val = lan_rd(lan966x, ANA_CPU_FWD_CFG(port));
+	if (!(val & (ANA_CPU_FWD_CFG_IGMP_REDIR_ENA |
+		     ANA_CPU_FWD_CFG_MLD_REDIR_ENA)))
+		return true;
+
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    ip_hdr(skb)->protocol == IPPROTO_IGMP)
+		return false;
+
+	if (skb->protocol == htons(ETH_P_IPV6) &&
+	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
+	    !ipv6_mc_check_mld(skb))
+		return false;
+
+	return true;
+}
+
 static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
 {
 	return lan_rd(lan966x, QS_XTR_RD(grp));
@@ -563,9 +591,14 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 		lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
 		skb->protocol = eth_type_trans(skb, dev);
 
-		if (lan966x->bridge_mask & BIT(src_port))
+		if (lan966x->bridge_mask & BIT(src_port)) {
 			skb->offload_fwd_mark = 1;
 
+			skb_reset_network_header(skb);
+			if (!lan966x_hw_offload(lan966x, src_port, skb))
+				skb->offload_fwd_mark = 0;
+		}
+
 		netif_rx_ni(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 026474c609ea..31fc54214041 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -170,6 +170,7 @@ struct lan966x_port {
 	bool vlan_aware;
 
 	bool learn_ena;
+	bool mcast_ena;
 
 	struct phylink_config phylink_config;
 	struct phylink_pcs phylink_pcs;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 37a5d7e63cb6..0c0b3e173d53 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -299,6 +299,24 @@ enum lan966x_target {
 /*      ANA:PORT:CPU_FWD_CFG */
 #define ANA_CPU_FWD_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 96, 0, 1, 4)
 
+#define ANA_CPU_FWD_CFG_MLD_REDIR_ENA            BIT(6)
+#define ANA_CPU_FWD_CFG_MLD_REDIR_ENA_SET(x)\
+	FIELD_PREP(ANA_CPU_FWD_CFG_MLD_REDIR_ENA, x)
+#define ANA_CPU_FWD_CFG_MLD_REDIR_ENA_GET(x)\
+	FIELD_GET(ANA_CPU_FWD_CFG_MLD_REDIR_ENA, x)
+
+#define ANA_CPU_FWD_CFG_IGMP_REDIR_ENA           BIT(5)
+#define ANA_CPU_FWD_CFG_IGMP_REDIR_ENA_SET(x)\
+	FIELD_PREP(ANA_CPU_FWD_CFG_IGMP_REDIR_ENA, x)
+#define ANA_CPU_FWD_CFG_IGMP_REDIR_ENA_GET(x)\
+	FIELD_GET(ANA_CPU_FWD_CFG_IGMP_REDIR_ENA, x)
+
+#define ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA       BIT(4)
+#define ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA_SET(x)\
+	FIELD_PREP(ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA, x)
+#define ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA_GET(x)\
+	FIELD_GET(ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA, x)
+
 #define ANA_CPU_FWD_CFG_SRC_COPY_ENA             BIT(3)
 #define ANA_CPU_FWD_CFG_SRC_COPY_ENA_SET(x)\
 	FIELD_PREP(ANA_CPU_FWD_CFG_SRC_COPY_ENA, x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 7de55f6a4da8..cf2535c18df8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -9,6 +9,37 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_nb __read_mostly;
 static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
+static void lan966x_port_set_mcast_ip_flood(struct lan966x_port *port,
+					    u32 pgid_ip)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 flood_mask_ip;
+
+	flood_mask_ip = lan_rd(lan966x, ANA_PGID(pgid_ip));
+	flood_mask_ip = ANA_PGID_PGID_GET(flood_mask_ip);
+
+	/* If mcast snooping is not enabled then use mcast flood mask
+	 * to decide to enable multicast flooding or not.
+	 */
+	if (!port->mcast_ena) {
+		u32 flood_mask;
+
+		flood_mask = lan_rd(lan966x, ANA_PGID(PGID_MC));
+		flood_mask = ANA_PGID_PGID_GET(flood_mask);
+
+		if (flood_mask & BIT(port->chip_port))
+			flood_mask_ip |= BIT(port->chip_port);
+		else
+			flood_mask_ip &= ~BIT(port->chip_port);
+	} else {
+		flood_mask_ip &= ~BIT(port->chip_port);
+	}
+
+	lan_rmw(ANA_PGID_PGID_SET(flood_mask_ip),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(pgid_ip));
+}
+
 static void lan966x_port_set_mcast_flood(struct lan966x_port *port,
 					 bool enabled)
 {
@@ -23,6 +54,11 @@ static void lan966x_port_set_mcast_flood(struct lan966x_port *port,
 	lan_rmw(ANA_PGID_PGID_SET(val),
 		ANA_PGID_PGID,
 		port->lan966x, ANA_PGID(PGID_MC));
+
+	if (!port->mcast_ena) {
+		lan966x_port_set_mcast_ip_flood(port, PGID_MCIPV4);
+		lan966x_port_set_mcast_ip_flood(port, PGID_MCIPV6);
+	}
 }
 
 static void lan966x_port_set_ucast_flood(struct lan966x_port *port,
@@ -144,6 +180,24 @@ static void lan966x_port_ageing_set(struct lan966x_port *port,
 	lan966x_mac_set_ageing(port->lan966x, ageing_time);
 }
 
+static void lan966x_port_mc_set(struct lan966x_port *port, bool mcast_ena)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	port->mcast_ena = mcast_ena;
+
+	lan_rmw(ANA_CPU_FWD_CFG_IGMP_REDIR_ENA_SET(mcast_ena) |
+		ANA_CPU_FWD_CFG_MLD_REDIR_ENA_SET(mcast_ena) |
+		ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA_SET(mcast_ena),
+		ANA_CPU_FWD_CFG_IGMP_REDIR_ENA |
+		ANA_CPU_FWD_CFG_MLD_REDIR_ENA |
+		ANA_CPU_FWD_CFG_IPMC_CTRL_COPY_ENA,
+		lan966x, ANA_CPU_FWD_CFG(port->chip_port));
+
+	lan966x_port_set_mcast_ip_flood(port, PGID_MCIPV4);
+	lan966x_port_set_mcast_ip_flood(port, PGID_MCIPV6);
+}
+
 static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 				 const struct switchdev_attr *attr,
 				 struct netlink_ext_ack *extack)
@@ -171,6 +225,9 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
 		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
 		lan966x_vlan_port_apply(port);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		lan966x_port_mc_set(port, !attr->u.mc_disabled);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.33.0

