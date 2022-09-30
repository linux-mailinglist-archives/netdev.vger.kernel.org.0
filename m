Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22B75F067C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiI3Icj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiI3Icg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:32:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107A8105D6E;
        Fri, 30 Sep 2022 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664526754; x=1696062754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zH67B2lsi//GnVtzo6a5QycTJ3Q3AcLbv3cECyJd+jI=;
  b=m346LobR+s6BeK7U3eYJx2bThZWjz77cN6A+JpXD+fueL6ZdSXqwQs5Q
   ClwPHFWmGEUATBOkbguhuQJMxifW5lZYb8J9enBpgO2JcpINIJz0oITtG
   zcI+rBNDwHO7vdTVOUBWm9BaZWh9sizOBzYC2p7zJkMRfrE7oLJIdlhME
   7crk2b4FWZ5njgAT0LaXIYUYfoWd2TzgzSQURgDSCZlrYc9rp/WS1UGVv
   YYzPz6USxi7PM4Hd42nXGy4iZgn2wCbAdpmVQDTJjO4psh3nRodOUCg0h
   axvQZkm0Fspk3T4TV1TkGD/vPQZnoNIhh4PRm4Qgj6GIxIDzPsaeBE/g3
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="116203060"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 01:32:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 01:32:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 30 Sep 2022 01:32:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/2] net: lan966x: Add port mirroring support using tc-matchall
Date:   Fri, 30 Sep 2022 10:35:40 +0200
Message-ID: <20220930083540.347686-3-horatiu.vultur@microchip.com>
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

Add support for port mirroring. It is possible to mirror only one port
at a time and it is possible to have both ingress and egress mirroring.
Frames injected by the CPU don't get egress mirrored because they are
bypassing the analyzer module.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  20 +++
 .../microchip/lan966x/lan966x_mirror.c        | 138 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  24 +++
 .../microchip/lan966x/lan966x_tc_matchall.c   |  10 ++
 5 files changed, 193 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index d00f7b67b6ecb..962f7c5f9e7dd 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -11,4 +11,4 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
-			lan966x_tc_matchall.o lan966x_police.o
+			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 10ffc6a76d39e..9656071b8289e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -264,6 +264,11 @@ struct lan966x {
 	struct lan966x_rx rx;
 	struct lan966x_tx tx;
 	struct napi_struct napi;
+
+	/* Mirror */
+	struct lan966x_port *mirror_monitor;
+	u32 mirror_mask[2];
+	u32 mirror_count;
 };
 
 struct lan966x_port_config {
@@ -279,7 +284,10 @@ struct lan966x_port_config {
 struct lan966x_port_tc {
 	bool ingress_shared_block;
 	unsigned long police_id;
+	unsigned long ingress_mirror_id;
+	unsigned long egress_mirror_id;
 	struct flow_stats police_stat;
+	struct flow_stats mirror_stat;
 };
 
 struct lan966x_port {
@@ -505,6 +513,18 @@ int lan966x_police_port_del(struct lan966x_port *port,
 void lan966x_police_port_stats(struct lan966x_port *port,
 			       struct flow_stats *stats);
 
+int lan966x_mirror_port_add(struct lan966x_port *port,
+			    struct flow_action_entry *action,
+			    unsigned long mirror_id,
+			    bool ingress,
+			    struct netlink_ext_ack *extack);
+int lan966x_mirror_port_del(struct lan966x_port *port,
+			    bool ingress,
+			    struct netlink_ext_ack *extack);
+void lan966x_mirror_port_stats(struct lan966x_port *port,
+			       struct flow_stats *stats,
+			       bool ingress);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c
new file mode 100644
index 0000000000000..7e1ba3f40c35e
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+int lan966x_mirror_port_add(struct lan966x_port *port,
+			    struct flow_action_entry *action,
+			    unsigned long mirror_id,
+			    bool ingress,
+			    struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_port *monitor_port;
+
+	if (!lan966x_netdevice_check(action->dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Destination not an lan966x port");
+		return -EOPNOTSUPP;
+	}
+
+	monitor_port = netdev_priv(action->dev);
+
+	if (lan966x->mirror_mask[ingress] & BIT(port->chip_port)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Mirror already exists");
+		return -EEXIST;
+	}
+
+	if (lan966x->mirror_monitor &&
+	    lan966x->mirror_monitor != monitor_port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot change mirror port while in use");
+		return -EBUSY;
+	}
+
+	if (port == monitor_port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot mirror the monitor port");
+		return -EINVAL;
+	}
+
+	lan966x->mirror_mask[ingress] |= BIT(port->chip_port);
+
+	lan966x->mirror_monitor = monitor_port;
+	lan_wr(BIT(monitor_port->chip_port), lan966x, ANA_MIRRORPORTS);
+
+	if (ingress) {
+		lan_rmw(ANA_PORT_CFG_SRC_MIRROR_ENA_SET(1),
+			ANA_PORT_CFG_SRC_MIRROR_ENA,
+			lan966x, ANA_PORT_CFG(port->chip_port));
+	} else {
+		lan_wr(lan966x->mirror_mask[0], lan966x,
+		       ANA_EMIRRORPORTS);
+	}
+
+	lan966x->mirror_count++;
+
+	if (ingress)
+		port->tc.ingress_mirror_id = mirror_id;
+	else
+		port->tc.egress_mirror_id = mirror_id;
+
+	return 0;
+}
+
+int lan966x_mirror_port_del(struct lan966x_port *port,
+			    bool ingress,
+			    struct netlink_ext_ack *extack)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	if (!(lan966x->mirror_mask[ingress] & BIT(port->chip_port))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "There is no mirroring for this port");
+		return -ENOENT;
+	}
+
+	lan966x->mirror_mask[ingress] &= ~BIT(port->chip_port);
+
+	if (ingress) {
+		lan_rmw(ANA_PORT_CFG_SRC_MIRROR_ENA_SET(0),
+			ANA_PORT_CFG_SRC_MIRROR_ENA,
+			lan966x, ANA_PORT_CFG(port->chip_port));
+	} else {
+		lan_wr(lan966x->mirror_mask[0], lan966x,
+		       ANA_EMIRRORPORTS);
+	}
+
+	lan966x->mirror_count--;
+
+	if (lan966x->mirror_count == 0) {
+		lan966x->mirror_monitor = NULL;
+		lan_wr(0, lan966x, ANA_MIRRORPORTS);
+	}
+
+	if (ingress)
+		port->tc.ingress_mirror_id = 0;
+	else
+		port->tc.egress_mirror_id = 0;
+
+	return 0;
+}
+
+void lan966x_mirror_port_stats(struct lan966x_port *port,
+			       struct flow_stats *stats,
+			       bool ingress)
+{
+	struct rtnl_link_stats64 new_stats;
+	struct flow_stats *old_stats;
+
+	old_stats = &port->tc.mirror_stat;
+	lan966x_stats_get(port->dev, &new_stats);
+
+	if (ingress) {
+		flow_stats_update(stats,
+				  new_stats.rx_bytes - old_stats->bytes,
+				  new_stats.rx_packets - old_stats->pkts,
+				  new_stats.rx_dropped - old_stats->drops,
+				  old_stats->lastused,
+				  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+		old_stats->bytes = new_stats.rx_bytes;
+		old_stats->pkts = new_stats.rx_packets;
+		old_stats->drops = new_stats.rx_dropped;
+		old_stats->lastused = jiffies;
+	} else {
+		flow_stats_update(stats,
+				  new_stats.tx_bytes - old_stats->bytes,
+				  new_stats.tx_packets - old_stats->pkts,
+				  new_stats.tx_dropped - old_stats->drops,
+				  old_stats->lastused,
+				  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+		old_stats->bytes = new_stats.tx_bytes;
+		old_stats->pkts = new_stats.tx_packets;
+		old_stats->drops = new_stats.tx_dropped;
+		old_stats->lastused = jiffies;
+	}
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 5cb88d81afbac..1d90b93dd417a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -90,6 +90,24 @@ enum lan966x_target {
 #define ANA_AUTOAGE_AGE_PERIOD_GET(x)\
 	FIELD_GET(ANA_AUTOAGE_AGE_PERIOD, x)
 
+/*      ANA:ANA:MIRRORPORTS */
+#define ANA_MIRRORPORTS           __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 60, 0, 1, 4)
+
+#define ANA_MIRRORPORTS_MIRRORPORTS              GENMASK(8, 0)
+#define ANA_MIRRORPORTS_MIRRORPORTS_SET(x)\
+	FIELD_PREP(ANA_MIRRORPORTS_MIRRORPORTS, x)
+#define ANA_MIRRORPORTS_MIRRORPORTS_GET(x)\
+	FIELD_GET(ANA_MIRRORPORTS_MIRRORPORTS, x)
+
+/*      ANA:ANA:EMIRRORPORTS */
+#define ANA_EMIRRORPORTS          __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 64, 0, 1, 4)
+
+#define ANA_EMIRRORPORTS_EMIRRORPORTS            GENMASK(8, 0)
+#define ANA_EMIRRORPORTS_EMIRRORPORTS_SET(x)\
+	FIELD_PREP(ANA_EMIRRORPORTS_EMIRRORPORTS, x)
+#define ANA_EMIRRORPORTS_EMIRRORPORTS_GET(x)\
+	FIELD_GET(ANA_EMIRRORPORTS_EMIRRORPORTS, x)
+
 /*      ANA:ANA:FLOODING */
 #define ANA_FLOODING(r)           __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 68, r, 8, 4)
 
@@ -330,6 +348,12 @@ enum lan966x_target {
 /*      ANA:PORT:PORT_CFG */
 #define ANA_PORT_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 112, 0, 1, 4)
 
+#define ANA_PORT_CFG_SRC_MIRROR_ENA              BIT(13)
+#define ANA_PORT_CFG_SRC_MIRROR_ENA_SET(x)\
+	FIELD_PREP(ANA_PORT_CFG_SRC_MIRROR_ENA, x)
+#define ANA_PORT_CFG_SRC_MIRROR_ENA_GET(x)\
+	FIELD_GET(ANA_PORT_CFG_SRC_MIRROR_ENA, x)
+
 #define ANA_PORT_CFG_LEARNAUTO                   BIT(6)
 #define ANA_PORT_CFG_LEARNAUTO_SET(x)\
 	FIELD_PREP(ANA_PORT_CFG_LEARNAUTO, x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
index dc065b556ef7b..7368433b9277a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
@@ -20,6 +20,9 @@ static int lan966x_tc_matchall_add(struct lan966x_port *port,
 		return lan966x_police_port_add(port, &f->rule->action, act,
 					       f->cookie, ingress,
 					       f->common.extack);
+	case FLOW_ACTION_MIRRED:
+		return lan966x_mirror_port_add(port, act, f->cookie,
+					       ingress, f->common.extack);
 	default:
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported action");
@@ -36,6 +39,10 @@ static int lan966x_tc_matchall_del(struct lan966x_port *port,
 	if (f->cookie == port->tc.police_id) {
 		return lan966x_police_port_del(port, f->cookie,
 					       f->common.extack);
+	} else if (f->cookie == port->tc.ingress_mirror_id ||
+		   f->cookie == port->tc.egress_mirror_id) {
+		return lan966x_mirror_port_del(port, ingress,
+					       f->common.extack);
 	} else {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported action");
@@ -51,6 +58,9 @@ static int lan966x_tc_matchall_stats(struct lan966x_port *port,
 {
 	if (f->cookie == port->tc.police_id) {
 		lan966x_police_port_stats(port, &f->stats);
+	} else if (f->cookie == port->tc.ingress_mirror_id ||
+		   f->cookie == port->tc.egress_mirror_id) {
+		lan966x_mirror_port_stats(port, &f->stats, ingress);
 	} else {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported action");
-- 
2.33.0

