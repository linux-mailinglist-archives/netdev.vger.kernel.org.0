Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D6B47D07F
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbhLVLGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:06:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:21325 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbhLVLGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:06:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640171165; x=1671707165;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g5J3Rh22DQzCivBDmFhnr6iSZpsLXO0SLAoKTREpPtE=;
  b=x7LRDP52cb7ETB0UKP4GkpuJzxijyvbZ3KBujBoqsKvdTUitXE14ie9/
   w+24/9H8NfWYvyxqL0gAEa+xm5F+mZhC5Xiyt89HyYOhETwwPUlyMv/B6
   1cvzZqPZIZm7NYYdScL4nE7m2fjMrD5h0AQnQNO7c1LGWJRAqxJavZ8YO
   IT7erFBfwl5WNRZOyRft+/wqOAmlnPCXM4RZAo4GmigMdjTOFiEPhpsst
   sT86HfGtz/D6jsS9m/sT5rw4//UBxUGHw0f3M7pQlOvCwwl1RY4FKKqlw
   SGx0aU1dCCCAK1jPbnjmiw9nUkhSadhZWUvXh7o6inr1dDvL17QJ0MwNP
   g==;
IronPort-SDR: 9VuNPD3oF1kIHsRfBokY8y/DAOkKLuzIVzTVRnwQxIhQArzwDydHhQR2bYEILrdQ4kj8USmx5C
 pyLqaA+V3bIhhjEfyx8ZhvDy+xQhLo7AI7JhMUwr0PHC1gr7gzyvQ3/Xu5bnArUsqY0/eP4K+A
 2rb5qR9tjHkuBhyoe5tZFNveDTJxBgrD/y+EedMN8e0Zo1nqOQbnkKl82K8ONJIZjnFnlJawB2
 OihsAd1R3z4cvWGMptaBbLp5gTOwe9VKVkghmhF4dyYOXZ0mSKt5Q23WyKpGXrUO7smgTY8OCM
 fdHAKjwQTQU7E/L+XPbrXsOg
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="140583721"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2021 04:06:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Dec 2021 04:06:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Dec 2021 04:05:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Add support for multiple bridge flags
Date:   Wed, 22 Dec 2021 12:07:59 +0100
Message-ID: <20211222110759.1404383-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the current supported bridge flags with the
following flags: BR_FLOOD, BR_BCAST_FLOOD and BR_LEARNING.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  7 ++
 .../ethernet/microchip/lan966x/lan966x_main.h |  2 +
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++
 .../microchip/lan966x/lan966x_switchdev.c     | 69 ++++++++++++++++++-
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 5b9f004ad902..16f4d8737d7b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -715,8 +715,10 @@ static void lan966x_init(struct lan966x *lan966x)
 	/* There are 8 priorities */
 	for (i = 0; i < 8; ++i)
 		lan_rmw(ANA_FLOODING_FLD_MULTICAST_SET(PGID_MC) |
+			ANA_FLOODING_FLD_UNICAST_SET(PGID_UC) |
 			ANA_FLOODING_FLD_BROADCAST_SET(PGID_BC),
 			ANA_FLOODING_FLD_MULTICAST |
+			ANA_FLOODING_FLD_UNICAST |
 			ANA_FLOODING_FLD_BROADCAST,
 			lan966x, ANA_FLOODING(i));
 
@@ -768,6 +770,11 @@ static void lan966x_init(struct lan966x *lan966x)
 		ANA_PGID_PGID,
 		lan966x, ANA_PGID(PGID_MCIPV4));
 
+	/* Unicast to all other ports */
+	lan_rmw(GENMASK(lan966x->num_phys_ports - 1, 0),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_UC));
+
 	/* Broadcast to the CPU port and to other ports */
 	lan_rmw(ANA_PGID_PGID_SET(BIT(CPU_PORT) | GENMASK(lan966x->num_phys_ports - 1, 0)),
 		ANA_PGID_PGID,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 051182890237..c399b1256edc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -126,6 +126,8 @@ struct lan966x_port {
 	u16 vid;
 	bool vlan_aware;
 
+	bool learn_ena;
+
 	struct phylink_config phylink_config;
 	struct phylink_pcs phylink_pcs;
 	struct lan966x_port_config config;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 2f2b26b9f8c6..a13c469e139a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -91,6 +91,12 @@ enum lan966x_target {
 /*      ANA:ANA:FLOODING */
 #define ANA_FLOODING(r)           __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 68, r, 8, 4)
 
+#define ANA_FLOODING_FLD_UNICAST                 GENMASK(17, 12)
+#define ANA_FLOODING_FLD_UNICAST_SET(x)\
+	FIELD_PREP(ANA_FLOODING_FLD_UNICAST, x)
+#define ANA_FLOODING_FLD_UNICAST_GET(x)\
+	FIELD_GET(ANA_FLOODING_FLD_UNICAST, x)
+
 #define ANA_FLOODING_FLD_BROADCAST               GENMASK(11, 6)
 #define ANA_FLOODING_FLD_BROADCAST_SET(x)\
 	FIELD_PREP(ANA_FLOODING_FLD_BROADCAST, x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 42c3170030d0..deb3dd5be67a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -25,18 +25,72 @@ static void lan966x_port_set_mcast_flood(struct lan966x_port *port,
 		port->lan966x, ANA_PGID(PGID_MC));
 }
 
+static void lan966x_port_set_ucast_flood(struct lan966x_port *port,
+					 bool enabled)
+{
+	u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_UC));
+
+	val = ANA_PGID_PGID_GET(val);
+	if (enabled)
+		val |= BIT(port->chip_port);
+	else
+		val &= ~BIT(port->chip_port);
+
+	lan_rmw(ANA_PGID_PGID_SET(val),
+		ANA_PGID_PGID,
+		port->lan966x, ANA_PGID(PGID_UC));
+}
+
+static void lan966x_port_set_bcast_flood(struct lan966x_port *port,
+					 bool enabled)
+{
+	u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_BC));
+
+	val = ANA_PGID_PGID_GET(val);
+	if (enabled)
+		val |= BIT(port->chip_port);
+	else
+		val &= ~BIT(port->chip_port);
+
+	lan_rmw(ANA_PGID_PGID_SET(val),
+		ANA_PGID_PGID,
+		port->lan966x, ANA_PGID(PGID_BC));
+}
+
+static void lan966x_port_set_learning(struct lan966x_port *port, bool enabled)
+{
+	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(enabled),
+		ANA_PORT_CFG_LEARN_ENA,
+		port->lan966x, ANA_PORT_CFG(port->chip_port));
+
+	port->learn_ena = enabled;
+}
+
 static void lan966x_port_bridge_flags(struct lan966x_port *port,
 				      struct switchdev_brport_flags flags)
 {
 	if (flags.mask & BR_MCAST_FLOOD)
 		lan966x_port_set_mcast_flood(port,
 					     !!(flags.val & BR_MCAST_FLOOD));
+
+	if (flags.mask & BR_FLOOD)
+		lan966x_port_set_ucast_flood(port,
+					     !!(flags.val & BR_FLOOD));
+
+	if (flags.mask & BR_BCAST_FLOOD)
+		lan966x_port_set_bcast_flood(port,
+					     !!(flags.val & BR_BCAST_FLOOD));
+
+	if (flags.mask & BR_LEARNING)
+		lan966x_port_set_learning(port,
+					  !!(flags.val & BR_LEARNING));
 }
 
 static int lan966x_port_pre_bridge_flags(struct lan966x_port *port,
 					 struct switchdev_brport_flags flags)
 {
-	if (flags.mask & ~BR_MCAST_FLOOD)
+	if (flags.mask & ~(BR_MCAST_FLOOD | BR_FLOOD | BR_BCAST_FLOOD |
+			   BR_LEARNING))
 		return -EINVAL;
 
 	return 0;
@@ -65,7 +119,8 @@ static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 state)
 	struct lan966x *lan966x = port->lan966x;
 	bool learn_ena = false;
 
-	if (state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING)
+	if ((state == BR_STATE_FORWARDING || state == BR_STATE_LEARNING) &&
+	    port->learn_ena)
 		learn_ena = true;
 
 	if (state == BR_STATE_FORWARDING)
@@ -128,6 +183,7 @@ static int lan966x_port_bridge_join(struct lan966x_port *port,
 				    struct net_device *bridge,
 				    struct netlink_ext_ack *extack)
 {
+	struct switchdev_brport_flags flags = {0};
 	struct lan966x *lan966x = port->lan966x;
 	struct net_device *dev = port->dev;
 	int err;
@@ -150,14 +206,23 @@ static int lan966x_port_bridge_join(struct lan966x_port *port,
 
 	lan966x->bridge_mask |= BIT(port->chip_port);
 
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask;
+	lan966x_port_bridge_flags(port, flags);
+
 	return 0;
 }
 
 static void lan966x_port_bridge_leave(struct lan966x_port *port,
 				      struct net_device *bridge)
 {
+	struct switchdev_brport_flags flags = {0};
 	struct lan966x *lan966x = port->lan966x;
 
+	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask & ~BR_LEARNING;
+	lan966x_port_bridge_flags(port, flags);
+
 	lan966x->bridge_mask &= ~BIT(port->chip_port);
 
 	if (!lan966x->bridge_mask)
-- 
2.33.0

