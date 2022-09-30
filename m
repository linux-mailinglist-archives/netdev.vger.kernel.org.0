Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095995F067D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiI3Ici (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiI3Ice (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:32:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3327D07A7;
        Fri, 30 Sep 2022 01:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664526751; x=1696062751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nQi4JkBcQnspTceMYlLj/FZojGXfZALb+hUy23543cI=;
  b=lVL4Ej9xktKctGqDGP/a6keUdLj1bqlw/Pj8Zu1ZDJNOze/RBxb0JXem
   C/3U6MK4OmDs0mHweBEJ0Q2X2YjI7MEkzL3CjeWFbyn7jxrjXe5ZnQHEN
   grzweZ/QAfAf63Ekyxtk3ZjlnQRQAFMBW+Nitji0VkiBKkzr2QqAR5bfK
   T0nMEK+aGUG+XyAR92+WzAAO3jGjp2+k9o6KIaP4vqTJ+9oc7NJgGd9pI
   eDaVDXX+2iRxuwmVkzIQxHAcDCS/D5ePyVRR26K/nwOEOdpRqqg/GTLsc
   OgRh2Y13F3vun24qGraJx7JJLGptus7EwWN/VFKv8sT00S+BcoUpyDSyB
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="116203029"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 01:32:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 01:32:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 30 Sep 2022 01:32:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/2] net: lan966x: Add port police support using tc-matchall
Date:   Fri, 30 Sep 2022 10:35:39 +0200
Message-ID: <20220930083540.347686-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220930083540.347686-1-horatiu.vultur@microchip.com>
References: <20220930083540.347686-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for port police. It is possible to police only on the
ingress side. To be able to add police support also it was required to
add tc-matchall classifier offload support.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  24 ++
 .../microchip/lan966x/lan966x_police.c        | 235 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  72 ++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |  50 ++++
 .../microchip/lan966x/lan966x_tc_matchall.c   |  85 +++++++
 6 files changed, 468 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_police.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 7360c1c7b53c3..d00f7b67b6ecb 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -10,4 +10,5 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
-			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o
+			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
+			lan966x_tc_matchall.o lan966x_police.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 78665eb9a3f11..10ffc6a76d39e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -276,6 +276,12 @@ struct lan966x_port_config {
 	bool autoneg;
 };
 
+struct lan966x_port_tc {
+	bool ingress_shared_block;
+	unsigned long police_id;
+	struct flow_stats police_stat;
+};
+
 struct lan966x_port {
 	struct net_device *dev;
 	struct lan966x *lan966x;
@@ -302,6 +308,8 @@ struct lan966x_port {
 	struct net_device *bond;
 	bool lag_tx_active;
 	enum netdev_lag_hash hash_type;
+
+	struct lan966x_port_tc tc;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -481,6 +489,22 @@ int lan966x_ets_add(struct lan966x_port *port,
 int lan966x_ets_del(struct lan966x_port *port,
 		    struct tc_ets_qopt_offload *qopt);
 
+int lan966x_tc_matchall(struct lan966x_port *port,
+			struct tc_cls_matchall_offload *f,
+			bool ingress);
+
+int lan966x_police_port_add(struct lan966x_port *port,
+			    struct flow_action *action,
+			    struct flow_action_entry *act,
+			    unsigned long police_id,
+			    bool ingress,
+			    struct netlink_ext_ack *extack);
+int lan966x_police_port_del(struct lan966x_port *port,
+			    unsigned long police_id,
+			    struct netlink_ext_ack *extack);
+void lan966x_police_port_stats(struct lan966x_port *port,
+			       struct flow_stats *stats);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
new file mode 100644
index 0000000000000..a9aec900d608d
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+/* 0-8 : 9 port policers */
+#define POL_IDX_PORT	0
+
+/* Policer order: Serial (QoS -> Port -> VCAP) */
+#define POL_ORDER	0x1d3
+
+struct lan966x_tc_policer {
+	/* kilobit per second */
+	u32 rate;
+	/* bytes */
+	u32 burst;
+};
+
+static int lan966x_police_add(struct lan966x_port *port,
+			      struct lan966x_tc_policer *pol,
+			      u16 pol_idx)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* Rate unit is 33 1/3 kpps */
+	pol->rate = DIV_ROUND_UP(pol->rate * 3, 100);
+	/* Avoid zero burst size */
+	pol->burst = pol->burst ?: 1;
+	/* Unit is 4kB */
+	pol->burst = DIV_ROUND_UP(pol->burst, 4096);
+
+	if (pol->rate > GENMASK(15, 0) ||
+	    pol->burst > GENMASK(6, 0))
+		return -EINVAL;
+
+	lan_wr(ANA_POL_MODE_DROP_ON_YELLOW_ENA_SET(0) |
+	       ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA_SET(0) |
+	       ANA_POL_MODE_IPG_SIZE_SET(20) |
+	       ANA_POL_MODE_FRM_MODE_SET(1) |
+	       ANA_POL_MODE_OVERSHOOT_ENA_SET(1),
+	       lan966x, ANA_POL_MODE(pol_idx));
+
+	lan_wr(ANA_POL_PIR_STATE_PIR_LVL_SET(0),
+	       lan966x, ANA_POL_PIR_STATE(pol_idx));
+
+	lan_wr(ANA_POL_PIR_CFG_PIR_RATE_SET(pol->rate) |
+	       ANA_POL_PIR_CFG_PIR_BURST_SET(pol->burst),
+	       lan966x, ANA_POL_PIR_CFG(pol_idx));
+
+	return 0;
+}
+
+static int lan966x_police_del(struct lan966x_port *port,
+			      u16 pol_idx)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_wr(ANA_POL_MODE_DROP_ON_YELLOW_ENA_SET(0) |
+	       ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA_SET(0) |
+	       ANA_POL_MODE_IPG_SIZE_SET(20) |
+	       ANA_POL_MODE_FRM_MODE_SET(2) |
+	       ANA_POL_MODE_OVERSHOOT_ENA_SET(1),
+	       lan966x, ANA_POL_MODE(pol_idx));
+
+	lan_wr(ANA_POL_PIR_STATE_PIR_LVL_SET(0),
+	       lan966x, ANA_POL_PIR_STATE(pol_idx));
+
+	lan_wr(ANA_POL_PIR_CFG_PIR_RATE_SET(GENMASK(14, 0)) |
+	       ANA_POL_PIR_CFG_PIR_BURST_SET(0),
+	       lan966x, ANA_POL_PIR_CFG(pol_idx));
+
+	return 0;
+}
+
+static int lan966x_police_validate(struct lan966x_port *port,
+				   const struct flow_action *action,
+				   const struct flow_action_entry *act,
+				   unsigned long police_id,
+				   bool ingress,
+				   struct netlink_ext_ack *extack)
+{
+	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+	    !flow_action_is_last_entry(action, act)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is ok, but action is not last");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ingress) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Policer is not supported on egress");
+		return -EOPNOTSUPP;
+	}
+
+	if (port->tc.ingress_shared_block) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Policer is not supported on shared ingress blocks");
+		return -EOPNOTSUPP;
+	}
+
+	if (port->tc.police_id && port->tc.police_id != police_id) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one policer per port is supported");
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
+int lan966x_police_port_add(struct lan966x_port *port,
+			    struct flow_action *action,
+			    struct flow_action_entry *act,
+			    unsigned long police_id,
+			    bool ingress,
+			    struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct rtnl_link_stats64 new_stats;
+	struct lan966x_tc_policer pol;
+	struct flow_stats *old_stats;
+	int err;
+
+	err = lan966x_police_validate(port, action, act, police_id, ingress,
+				      extack);
+	if (err)
+		return err;
+
+	memset(&pol, 0, sizeof(pol));
+
+	pol.rate = div_u64(act->police.rate_bytes_ps, 1000) * 8;
+	pol.burst = act->police.burst;
+
+	err = lan966x_police_add(port, &pol, POL_IDX_PORT + port->chip_port);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to add policer to port");
+		return err;
+	}
+
+	lan_rmw(ANA_POL_CFG_PORT_POL_ENA_SET(1) |
+		ANA_POL_CFG_POL_ORDER_SET(POL_ORDER),
+		ANA_POL_CFG_PORT_POL_ENA |
+		ANA_POL_CFG_POL_ORDER,
+		lan966x, ANA_POL_CFG(port->chip_port));
+
+	port->tc.police_id = police_id;
+
+	/* Setup initial stats */
+	old_stats = &port->tc.police_stat;
+	lan966x_stats_get(port->dev, &new_stats);
+	old_stats->bytes = new_stats.rx_bytes;
+	old_stats->pkts = new_stats.rx_packets;
+	old_stats->drops = new_stats.rx_dropped;
+	old_stats->lastused = jiffies;
+
+	return 0;
+}
+
+int lan966x_police_port_del(struct lan966x_port *port,
+			    unsigned long police_id,
+			    struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	int err;
+
+	if (port->tc.police_id != police_id) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid policer id");
+		return -EINVAL;
+	}
+
+	err = lan966x_police_del(port, port->tc.police_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to add policer to port");
+		return err;
+	}
+
+	lan_rmw(ANA_POL_CFG_PORT_POL_ENA_SET(0) |
+		ANA_POL_CFG_POL_ORDER_SET(POL_ORDER),
+		ANA_POL_CFG_PORT_POL_ENA |
+		ANA_POL_CFG_POL_ORDER,
+		lan966x, ANA_POL_CFG(port->chip_port));
+
+	port->tc.police_id = 0;
+
+	return 0;
+}
+
+void lan966x_police_port_stats(struct lan966x_port *port,
+			       struct flow_stats *stats)
+{
+	struct rtnl_link_stats64 new_stats;
+	struct flow_stats *old_stats;
+
+	old_stats = &port->tc.police_stat;
+	lan966x_stats_get(port->dev, &new_stats);
+
+	flow_stats_update(stats,
+			  new_stats.rx_bytes - old_stats->bytes,
+			  new_stats.rx_packets - old_stats->pkts,
+			  new_stats.rx_dropped - old_stats->drops,
+			  old_stats->lastused,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+	old_stats->bytes = new_stats.rx_bytes;
+	old_stats->pkts = new_stats.rx_packets;
+	old_stats->drops = new_stats.rx_dropped;
+	old_stats->lastused = jiffies;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 4f00f95d66b68..5cb88d81afbac 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -354,6 +354,21 @@ enum lan966x_target {
 #define ANA_PORT_CFG_PORTID_VAL_GET(x)\
 	FIELD_GET(ANA_PORT_CFG_PORTID_VAL, x)
 
+/*      ANA:PORT:POL_CFG */
+#define ANA_POL_CFG(g)            __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 116, 0, 1, 4)
+
+#define ANA_POL_CFG_PORT_POL_ENA                 BIT(17)
+#define ANA_POL_CFG_PORT_POL_ENA_SET(x)\
+	FIELD_PREP(ANA_POL_CFG_PORT_POL_ENA, x)
+#define ANA_POL_CFG_PORT_POL_ENA_GET(x)\
+	FIELD_GET(ANA_POL_CFG_PORT_POL_ENA, x)
+
+#define ANA_POL_CFG_POL_ORDER                    GENMASK(8, 0)
+#define ANA_POL_CFG_POL_ORDER_SET(x)\
+	FIELD_PREP(ANA_POL_CFG_POL_ORDER, x)
+#define ANA_POL_CFG_POL_ORDER_GET(x)\
+	FIELD_GET(ANA_POL_CFG_POL_ORDER, x)
+
 /*      ANA:PFC:PFC_CFG */
 #define ANA_PFC_CFG(g)            __REG(TARGET_ANA, 0, 1, 30720, g, 8, 64, 0, 0, 1, 4)
 
@@ -408,6 +423,63 @@ enum lan966x_target {
 #define ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_GET(x)\
 	FIELD_GET(ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, x)
 
+/*      ANA:POL:POL_PIR_CFG */
+#define ANA_POL_PIR_CFG(g)        __REG(TARGET_ANA, 0, 1, 16384, g, 345, 32, 0, 0, 1, 4)
+
+#define ANA_POL_PIR_CFG_PIR_RATE                 GENMASK(20, 6)
+#define ANA_POL_PIR_CFG_PIR_RATE_SET(x)\
+	FIELD_PREP(ANA_POL_PIR_CFG_PIR_RATE, x)
+#define ANA_POL_PIR_CFG_PIR_RATE_GET(x)\
+	FIELD_GET(ANA_POL_PIR_CFG_PIR_RATE, x)
+
+#define ANA_POL_PIR_CFG_PIR_BURST                GENMASK(5, 0)
+#define ANA_POL_PIR_CFG_PIR_BURST_SET(x)\
+	FIELD_PREP(ANA_POL_PIR_CFG_PIR_BURST, x)
+#define ANA_POL_PIR_CFG_PIR_BURST_GET(x)\
+	FIELD_GET(ANA_POL_PIR_CFG_PIR_BURST, x)
+
+/*      ANA:POL:POL_MODE_CFG */
+#define ANA_POL_MODE(g)           __REG(TARGET_ANA, 0, 1, 16384, g, 345, 32, 8, 0, 1, 4)
+
+#define ANA_POL_MODE_DROP_ON_YELLOW_ENA          BIT(11)
+#define ANA_POL_MODE_DROP_ON_YELLOW_ENA_SET(x)\
+	FIELD_PREP(ANA_POL_MODE_DROP_ON_YELLOW_ENA, x)
+#define ANA_POL_MODE_DROP_ON_YELLOW_ENA_GET(x)\
+	FIELD_GET(ANA_POL_MODE_DROP_ON_YELLOW_ENA, x)
+
+#define ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA       BIT(10)
+#define ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA_SET(x)\
+	FIELD_PREP(ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA, x)
+#define ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA_GET(x)\
+	FIELD_GET(ANA_POL_MODE_MARK_ALL_FRMS_RED_ENA, x)
+
+#define ANA_POL_MODE_IPG_SIZE                    GENMASK(9, 5)
+#define ANA_POL_MODE_IPG_SIZE_SET(x)\
+	FIELD_PREP(ANA_POL_MODE_IPG_SIZE, x)
+#define ANA_POL_MODE_IPG_SIZE_GET(x)\
+	FIELD_GET(ANA_POL_MODE_IPG_SIZE, x)
+
+#define ANA_POL_MODE_FRM_MODE                    GENMASK(4, 3)
+#define ANA_POL_MODE_FRM_MODE_SET(x)\
+	FIELD_PREP(ANA_POL_MODE_FRM_MODE, x)
+#define ANA_POL_MODE_FRM_MODE_GET(x)\
+	FIELD_GET(ANA_POL_MODE_FRM_MODE, x)
+
+#define ANA_POL_MODE_OVERSHOOT_ENA               BIT(0)
+#define ANA_POL_MODE_OVERSHOOT_ENA_SET(x)\
+	FIELD_PREP(ANA_POL_MODE_OVERSHOOT_ENA, x)
+#define ANA_POL_MODE_OVERSHOOT_ENA_GET(x)\
+	FIELD_GET(ANA_POL_MODE_OVERSHOOT_ENA, x)
+
+/*      ANA:POL:POL_PIR_STATE */
+#define ANA_POL_PIR_STATE(g)      __REG(TARGET_ANA, 0, 1, 16384, g, 345, 32, 12, 0, 1, 4)
+
+#define ANA_POL_PIR_STATE_PIR_LVL                GENMASK(21, 0)
+#define ANA_POL_PIR_STATE_PIR_LVL_SET(x)\
+	FIELD_PREP(ANA_POL_PIR_STATE_PIR_LVL, x)
+#define ANA_POL_PIR_STATE_PIR_LVL_GET(x)\
+	FIELD_GET(ANA_POL_PIR_STATE_PIR_LVL, x)
+
 /*      CHIP_TOP:CUPHY_CFG:CUPHY_PORT_CFG */
 #define CHIP_TOP_CUPHY_PORT_CFG(r) __REG(TARGET_CHIP_TOP, 0, 1, 16, 0, 1, 20, 8, r, 2, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 336eb7ee0d608..651d5493ae55b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -4,6 +4,8 @@
 
 #include "lan966x_main.h"
 
+static LIST_HEAD(lan966x_tc_block_cb_list);
+
 static int lan966x_tc_setup_qdisc_mqprio(struct lan966x_port *port,
 					 struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -59,6 +61,52 @@ static int lan966x_tc_setup_qdisc_ets(struct lan966x_port *port,
 	return -EOPNOTSUPP;
 }
 
+static int lan966x_tc_block_cb(enum tc_setup_type type, void *type_data,
+			       void *cb_priv, bool ingress)
+{
+	struct lan966x_port *port = cb_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return lan966x_tc_matchall(port, type_data, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int lan966x_tc_block_cb_ingress(enum tc_setup_type type,
+				       void *type_data, void *cb_priv)
+{
+	return lan966x_tc_block_cb(type, type_data, cb_priv, true);
+}
+
+static int lan966x_tc_block_cb_egress(enum tc_setup_type type,
+				      void *type_data, void *cb_priv)
+{
+	return lan966x_tc_block_cb(type, type_data, cb_priv, false);
+}
+
+static int lan966x_tc_setup_block(struct lan966x_port *port,
+				  struct flow_block_offload *f)
+{
+	flow_setup_cb_t *cb;
+	bool ingress;
+
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+		cb = lan966x_tc_block_cb_ingress;
+		port->tc.ingress_shared_block = f->block_shared;
+		ingress = true;
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+		cb = lan966x_tc_block_cb_egress;
+		ingress = false;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return flow_block_cb_setup_simple(f, &lan966x_tc_block_cb_list,
+					  cb, port, port, ingress);
+}
+
 int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data)
 {
@@ -75,6 +123,8 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		return lan966x_tc_setup_qdisc_cbs(port, type_data);
 	case TC_SETUP_QDISC_ETS:
 		return lan966x_tc_setup_qdisc_ets(port, type_data);
+	case TC_SETUP_BLOCK:
+		return lan966x_tc_setup_block(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
new file mode 100644
index 0000000000000..dc065b556ef7b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+static int lan966x_tc_matchall_add(struct lan966x_port *port,
+				   struct tc_cls_matchall_offload *f,
+				   bool ingress)
+{
+	struct flow_action_entry *act;
+
+	if (!flow_offload_has_one_action(&f->rule->action)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Only once action per filter is supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &f->rule->action.entries[0];
+	switch (act->id) {
+	case FLOW_ACTION_POLICE:
+		return lan966x_police_port_add(port, &f->rule->action, act,
+					       f->cookie, ingress,
+					       f->common.extack);
+	default:
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unsupported action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int lan966x_tc_matchall_del(struct lan966x_port *port,
+				   struct tc_cls_matchall_offload *f,
+				   bool ingress)
+{
+	if (f->cookie == port->tc.police_id) {
+		return lan966x_police_port_del(port, f->cookie,
+					       f->common.extack);
+	} else {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unsupported action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int lan966x_tc_matchall_stats(struct lan966x_port *port,
+				     struct tc_cls_matchall_offload *f,
+				     bool ingress)
+{
+	if (f->cookie == port->tc.police_id) {
+		lan966x_police_port_stats(port, &f->stats);
+	} else {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unsupported action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int lan966x_tc_matchall(struct lan966x_port *port,
+			struct tc_cls_matchall_offload *f,
+			bool ingress)
+{
+	if (!tc_cls_can_offload_and_chain0(port->dev, &f->common)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Only chain zero is supported");
+		return -EOPNOTSUPP;
+	}
+
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return lan966x_tc_matchall_add(port, f, ingress);
+	case TC_CLSMATCHALL_DESTROY:
+		return lan966x_tc_matchall_del(port, f, ingress);
+	case TC_CLSMATCHALL_STATS:
+		return lan966x_tc_matchall_stats(port, f, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
-- 
2.33.0

