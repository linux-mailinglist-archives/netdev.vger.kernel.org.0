Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB0A5BFDBB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIUMVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiIUMV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:21:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE308A1FF;
        Wed, 21 Sep 2022 05:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663762888; x=1695298888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dgdYLbX1qUoPFjIGrn3C5L3BLZi553PH1I2pPFQxoeg=;
  b=XTYUyf6nWNwniT2AqdLDzD6eXIlihBKyJ3SuEjlmZ+vK+5+I4SrBttb1
   y95P59ruP88FctudLQXbPcda6bUDHuwvjidpo66HpjVkDcg9EyrVFxD5M
   5c5WS9KCXIQ3GL2gpRUvCHfPlJ0CQsy/RRJjMduHIk09emjrTFyXYAC0E
   wUBV5gGlxvYz+XKnU18Toj+YS7AwaD2qziOPBSPD9E5Q9ty00OBy73Ev+
   VqvF6jxpiuZgGnuCIZneySQEe37KU9Vw4JDxV0QJyWRKq8XNnJMQuJSzN
   QhFlCvCcwH3v31fvj0QulmZ++tg/WXX26t6a6zhyvsrzti/j8S/DriA1k
   g==;
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="174903322"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Sep 2022 05:21:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 21 Sep 2022 05:21:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 21 Sep 2022 05:21:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/4] net: lan966x: Add offload support for taprio
Date:   Wed, 21 Sep 2022 14:25:38 +0200
Message-ID: <20220921122538.2079744-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
References: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lan966x switch supports time-based egress shaping in hardware
according to IEEE 802.1Qbv. Add support for TAS configuration on
egress port of lan966x switch.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  10 +
 .../ethernet/microchip/lan966x/lan966x_port.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  |   9 +-
 .../microchip/lan966x/lan966x_taprio.c        | 528 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |   9 +
 7 files changed, 560 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 2ea66b94abac9..cac8b3901eaef 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -9,4 +9,4 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
 			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
-			lan966x_tc.o lan966x_mqprio.o
+			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 033120a5b056c..b98d37c76edbc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -963,6 +963,8 @@ static void lan966x_init(struct lan966x *lan966x)
 		lan966x, ANA_ANAINTR);
 
 	spin_lock_init(&lan966x->tx_lock);
+
+	lan966x_taprio_init(lan966x);
 }
 
 static int lan966x_ram_init(struct lan966x *lan966x)
@@ -1172,6 +1174,7 @@ static int lan966x_remove(struct platform_device *pdev)
 {
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
+	lan966x_taprio_deinit(lan966x);
 	lan966x_fdma_deinit(lan966x);
 	lan966x_cleanup_ports(lan966x);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index b037b1feec8f3..935c116715939 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -9,6 +9,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/pkt_sched.h>
 #include <net/switchdev.h>
 
 #include "lan966x_regs.h"
@@ -410,6 +411,8 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 				  struct sk_buff *skb);
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args);
+u32 lan966x_ptp_get_period_ps(void);
+int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
@@ -452,6 +455,13 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 int lan966x_mqprio_add(struct lan966x_port *port, u8 num_tc);
 int lan966x_mqprio_del(struct lan966x_port *port);
 
+void lan966x_taprio_init(struct lan966x *lan966x);
+void lan966x_taprio_deinit(struct lan966x *lan966x);
+int lan966x_taprio_add(struct lan966x_port *port,
+		       struct tc_taprio_qopt_offload *qopt);
+int lan966x_taprio_del(struct lan966x_port *port);
+int lan966x_taprio_speed_set(struct lan966x_port *port, int speed);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 702542fa0902d..0050fcb988b75 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -165,6 +165,8 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 		break;
 	}
 
+	lan966x_taprio_speed_set(port, config->speed);
+
 	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
 	 * port speed for QSGMII ports.
 	 */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 3a621c5165bc5..e5a2bbe064f8f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -464,8 +464,7 @@ static int lan966x_ptp_settime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
-static int lan966x_ptp_gettime64(struct ptp_clock_info *ptp,
-				 struct timespec64 *ts)
+int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
 	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
 	struct lan966x *lan966x = phc->lan966x;
@@ -890,3 +889,9 @@ void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
 	shhwtstamps = skb_hwtstamps(skb);
 	shhwtstamps->hwtstamp = full_ts_in_ns;
 }
+
+u32 lan966x_ptp_get_period_ps(void)
+{
+	/* This represents the system clock period in picoseconds */
+	return 15125;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c b/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
new file mode 100644
index 0000000000000..3f5b212066c5c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
@@ -0,0 +1,528 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+#define LAN966X_TAPRIO_TIMEOUT_MS		1000
+#define LAN966X_TAPRIO_ENTRIES_PER_PORT		2
+
+/* Minimum supported cycle time in nanoseconds */
+#define LAN966X_TAPRIO_MIN_CYCLE_TIME_NS	NSEC_PER_USEC
+
+/* Maximum supported cycle time in nanoseconds */
+#define LAN966X_TAPRIO_MAX_CYCLE_TIME_NS	(NSEC_PER_SEC - 1)
+
+/* Total number of TAS GCL entries */
+#define LAN966X_TAPRIO_NUM_GCL			256
+
+/* TAPRIO link speeds for calculation of guard band */
+enum lan966x_taprio_link_speed {
+	LAN966X_TAPRIO_SPEED_NO_GB,
+	LAN966X_TAPRIO_SPEED_10,
+	LAN966X_TAPRIO_SPEED_100,
+	LAN966X_TAPRIO_SPEED_1000,
+	LAN966X_TAPRIO_SPEED_2500,
+};
+
+/* TAPRIO list states */
+enum lan966x_taprio_state {
+	LAN966X_TAPRIO_STATE_ADMIN,
+	LAN966X_TAPRIO_STATE_ADVANCING,
+	LAN966X_TAPRIO_STATE_PENDING,
+	LAN966X_TAPRIO_STATE_OPERATING,
+	LAN966X_TAPRIO_STATE_TERMINATING,
+	LAN966X_TAPRIO_STATE_MAX,
+};
+
+/* TAPRIO GCL command */
+enum lan966x_taprio_gcl_cmd {
+	LAN966X_TAPRIO_GCL_CMD_SET_GATE_STATES = 0,
+};
+
+static u32 lan966x_taprio_list_index(struct lan966x_port *port, u8 entry)
+{
+	return port->chip_port * LAN966X_TAPRIO_ENTRIES_PER_PORT + entry;
+}
+
+static u32 lan966x_taprio_list_state_get(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	val = lan_rd(lan966x, QSYS_TAS_LST);
+	return QSYS_TAS_LST_LIST_STATE_GET(val);
+}
+
+static u32 lan966x_taprio_list_index_state_get(struct lan966x_port *port,
+					       u32 list)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_rmw(QSYS_TAS_CFG_CTRL_LIST_NUM_SET(list),
+		QSYS_TAS_CFG_CTRL_LIST_NUM,
+		lan966x, QSYS_TAS_CFG_CTRL);
+
+	return lan966x_taprio_list_state_get(port);
+}
+
+static void lan966x_taprio_list_state_set(struct lan966x_port *port,
+					  u32 state)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_rmw(QSYS_TAS_LST_LIST_STATE_SET(state),
+		QSYS_TAS_LST_LIST_STATE,
+		lan966x, QSYS_TAS_LST);
+}
+
+static int lan966x_taprio_list_shutdown(struct lan966x_port *port,
+					u32 list)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool pending, operating;
+	unsigned long end;
+	u32 state;
+
+	end = jiffies +  msecs_to_jiffies(LAN966X_TAPRIO_TIMEOUT_MS);
+	/* It is required to try multiple times to set the state of list,
+	 * because the HW can overwrite this.
+	 */
+	do {
+		state = lan966x_taprio_list_state_get(port);
+
+		pending = false;
+		operating = false;
+
+		if (state == LAN966X_TAPRIO_STATE_ADVANCING ||
+		    state == LAN966X_TAPRIO_STATE_PENDING) {
+			lan966x_taprio_list_state_set(port,
+						      LAN966X_TAPRIO_STATE_ADMIN);
+			pending = true;
+		}
+
+		if (state == LAN966X_TAPRIO_STATE_OPERATING) {
+			lan966x_taprio_list_state_set(port,
+						      LAN966X_TAPRIO_STATE_TERMINATING);
+			operating = true;
+		}
+
+		/* If the entry was in pending and now gets in admin, then there
+		 * is nothing else to do, so just bail out
+		 */
+		state = lan966x_taprio_list_state_get(port);
+		if (pending &&
+		    state == LAN966X_TAPRIO_STATE_ADMIN)
+			return 0;
+
+		/* If the list was in operating and now is in terminating or
+		 * admin, then is OK to exit but it needs to wait until the list
+		 * will get in admin. It is not required to set the state
+		 * again.
+		 */
+		if (operating &&
+		    (state == LAN966X_TAPRIO_STATE_TERMINATING ||
+		     state == LAN966X_TAPRIO_STATE_ADMIN))
+			break;
+
+	} while (!time_after(jiffies, end));
+
+	end = jiffies + msecs_to_jiffies(LAN966X_TAPRIO_TIMEOUT_MS);
+	do {
+		state = lan966x_taprio_list_state_get(port);
+		if (state == LAN966X_TAPRIO_STATE_ADMIN)
+			break;
+
+	} while (!time_after(jiffies, end));
+
+	/* If the list was in operating mode, it could be stopped while some
+	 * queues where closed, so make sure to restore "all-queues-open"
+	 */
+	if (operating) {
+		lan_wr(QSYS_TAS_GS_CTRL_HSCH_POS_SET(port->chip_port),
+		       lan966x, QSYS_TAS_GS_CTRL);
+
+		lan_wr(QSYS_TAS_GATE_STATE_TAS_GATE_STATE_SET(0xff),
+		       lan966x, QSYS_TAS_GATE_STATE);
+	}
+
+	return 0;
+}
+
+static int lan966x_taprio_shutdown(struct lan966x_port *port)
+{
+	u32 i, list, state;
+	int err;
+
+	for (i = 0; i < LAN966X_TAPRIO_ENTRIES_PER_PORT; ++i) {
+		list = lan966x_taprio_list_index(port, i);
+		state = lan966x_taprio_list_index_state_get(port, list);
+		if (state == LAN966X_TAPRIO_STATE_ADMIN)
+			continue;
+
+		err = lan966x_taprio_list_shutdown(port, list);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Find a suitable list for a new schedule. First priority is a list in state
+ * pending. Second priority is a list in state admin.
+ */
+static int lan966x_taprio_find_list(struct lan966x_port *port,
+				    struct tc_taprio_qopt_offload *qopt,
+				    int *new_list, int *obs_list)
+{
+	int state[LAN966X_TAPRIO_ENTRIES_PER_PORT];
+	int list[LAN966X_TAPRIO_ENTRIES_PER_PORT];
+	int err, oper = -1;
+	u32 i;
+
+	*new_list = -1;
+	*obs_list = -1;
+
+	/* If there is already an entry in operating mode, return this list in
+	 * obs_list, such that when the new list will get activated the
+	 * operating list will be stopped. In this way is possible to have
+	 * smooth transitions between the lists
+	 */
+	for (i = 0; i < LAN966X_TAPRIO_ENTRIES_PER_PORT; ++i) {
+		list[i] = lan966x_taprio_list_index(port, i);
+		state[i] = lan966x_taprio_list_index_state_get(port, list[i]);
+		if (state[i] == LAN966X_TAPRIO_STATE_OPERATING)
+			oper = list[i];
+	}
+
+	for (i = 0; i < LAN966X_TAPRIO_ENTRIES_PER_PORT; ++i) {
+		if (state[i] == LAN966X_TAPRIO_STATE_PENDING) {
+			err = lan966x_taprio_shutdown(port);
+			if (err)
+				return err;
+
+			*new_list = list[i];
+			*obs_list = (oper == -1) ? *new_list : oper;
+			return 0;
+		}
+	}
+
+	for (i = 0; i < LAN966X_TAPRIO_ENTRIES_PER_PORT; ++i) {
+		if (state[i] == LAN966X_TAPRIO_STATE_ADMIN) {
+			*new_list = list[i];
+			*obs_list = (oper == -1) ? *new_list : oper;
+			return 0;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static int lan966x_taprio_check(struct tc_taprio_qopt_offload *qopt)
+{
+	u64 total_time = 0;
+	u32 i;
+
+	/* This is not supported by th HW */
+	if (qopt->cycle_time_extension)
+		return -EOPNOTSUPP;
+
+	/* There is a limited number of gcl entries that can be used, they are
+	 * shared by all ports
+	 */
+	if (qopt->num_entries > LAN966X_TAPRIO_NUM_GCL)
+		return -EINVAL;
+
+	/* Don't allow cycle times bigger than 1 sec or smaller than 1 usec */
+	if (qopt->cycle_time < LAN966X_TAPRIO_MIN_CYCLE_TIME_NS ||
+	    qopt->cycle_time > LAN966X_TAPRIO_MAX_CYCLE_TIME_NS)
+		return -EINVAL;
+
+	for (i = 0; i < qopt->num_entries; ++i) {
+		struct tc_taprio_sched_entry *entry = &qopt->entries[i];
+
+		/* Don't allow intervals bigger than 1 sec or smaller than 1
+		 * usec
+		 */
+		if (entry->interval < LAN966X_TAPRIO_MIN_CYCLE_TIME_NS ||
+		    entry->interval > LAN966X_TAPRIO_MAX_CYCLE_TIME_NS)
+			return -EINVAL;
+
+		if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+			return -EINVAL;
+
+		total_time += qopt->entries[i].interval;
+	}
+
+	/* Don't allow the total time of intervals be bigger than 1 sec */
+	if (total_time > LAN966X_TAPRIO_MAX_CYCLE_TIME_NS)
+		return -EINVAL;
+
+	/* The HW expects that the cycle time to be at least as big as sum of
+	 * each interval of gcl
+	 */
+	if (qopt->cycle_time < total_time)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int lan966x_taprio_gcl_free_get(struct lan966x_port *port,
+				       unsigned long *free_list)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 num_free, state, list;
+	u32 base, next, max_list;
+
+	/* By default everything is free */
+	bitmap_fill(free_list, LAN966X_TAPRIO_NUM_GCL);
+	num_free = LAN966X_TAPRIO_NUM_GCL;
+
+	/* Iterate over all gcl entries and find out which are free. And mark
+	 * those that are not free.
+	 */
+	max_list = lan966x->num_phys_ports * LAN966X_TAPRIO_ENTRIES_PER_PORT;
+	for (list = 0; list < max_list; ++list) {
+		state = lan966x_taprio_list_index_state_get(port, list);
+		if (state == LAN966X_TAPRIO_STATE_ADMIN)
+			continue;
+
+		base = lan_rd(lan966x, QSYS_TAS_LIST_CFG);
+		base = QSYS_TAS_LIST_CFG_LIST_BASE_ADDR_GET(base);
+		next = base;
+
+		do {
+			clear_bit(next, free_list);
+			num_free--;
+
+			lan_rmw(QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM_SET(next),
+				QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM,
+				lan966x, QSYS_TAS_CFG_CTRL);
+
+			next = lan_rd(lan966x, QSYS_TAS_GCL_CT_CFG2);
+			next = QSYS_TAS_GCL_CT_CFG2_NEXT_GCL_GET(next);
+		} while (base != next);
+	}
+
+	return num_free;
+}
+
+static void lan966x_taprio_gcl_setup_entry(struct lan966x_port *port,
+					   struct tc_taprio_sched_entry *entry,
+					   u32 next_entry)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	/* Setup a single gcl entry */
+	lan_wr(QSYS_TAS_GCL_CT_CFG_GATE_STATE_SET(entry->gate_mask) |
+	       QSYS_TAS_GCL_CT_CFG_HSCH_POS_SET(port->chip_port) |
+	       QSYS_TAS_GCL_CT_CFG_OP_TYPE_SET(LAN966X_TAPRIO_GCL_CMD_SET_GATE_STATES),
+	       lan966x, QSYS_TAS_GCL_CT_CFG);
+
+	lan_wr(QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE_SET(port->chip_port) |
+	       QSYS_TAS_GCL_CT_CFG2_NEXT_GCL_SET(next_entry),
+	       lan966x, QSYS_TAS_GCL_CT_CFG2);
+
+	lan_wr(entry->interval, lan966x, QSYS_TAS_GCL_TM_CFG);
+}
+
+static int lan966x_taprio_gcl_setup(struct lan966x_port *port,
+				    struct tc_taprio_qopt_offload *qopt,
+				    int list)
+{
+	DECLARE_BITMAP(free_list, LAN966X_TAPRIO_NUM_GCL);
+	struct lan966x *lan966x = port->lan966x;
+	u32 i, base, next;
+
+	if (lan966x_taprio_gcl_free_get(port, free_list) < qopt->num_entries)
+		return -ENOSPC;
+
+	/* Select list */
+	lan_rmw(QSYS_TAS_CFG_CTRL_LIST_NUM_SET(list),
+		QSYS_TAS_CFG_CTRL_LIST_NUM,
+		lan966x, QSYS_TAS_CFG_CTRL);
+
+	/* Setup the address of the first gcl entry */
+	base = find_first_bit(free_list, LAN966X_TAPRIO_NUM_GCL);
+	lan_rmw(QSYS_TAS_LIST_CFG_LIST_BASE_ADDR_SET(base),
+		QSYS_TAS_LIST_CFG_LIST_BASE_ADDR,
+		lan966x, QSYS_TAS_LIST_CFG);
+
+	/* Iterate over entries and add them to the gcl list */
+	next = base;
+	for (i = 0; i < qopt->num_entries; ++i) {
+		lan_rmw(QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM_SET(next),
+			QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM,
+			lan966x, QSYS_TAS_CFG_CTRL);
+
+		/* If the entry is last, point back to the start of the list */
+		if (i == qopt->num_entries - 1)
+			next = base;
+		else
+			next = find_next_bit(free_list, LAN966X_TAPRIO_NUM_GCL,
+					     next + 1);
+
+		lan966x_taprio_gcl_setup_entry(port, &qopt->entries[i], next);
+	}
+
+	return 0;
+}
+
+/* Calculate new base_time based on cycle_time. The HW recommends to have the
+ * new base time at least 2 * cycle type + current time
+ */
+static void lan966x_taprio_new_base_time(struct lan966x *lan966x,
+					 const u32 cycle_time,
+					 const ktime_t org_base_time,
+					 ktime_t *new_base_time)
+{
+	ktime_t current_time, threshold_time;
+	struct timespec64 ts;
+
+	/* Get the current time and calculate the threshold_time */
+	lan966x_ptp_gettime64(&lan966x->phc[LAN966X_PHC_PORT].info, &ts);
+	current_time = timespec64_to_ktime(ts);
+	threshold_time = current_time + (2 * cycle_time);
+
+	/* If the org_base_time is in enough in future just use it */
+	if (org_base_time >= threshold_time) {
+		*new_base_time = org_base_time;
+		return;
+	}
+
+	/* If the org_base_time is smaller than current_time, calculate the new
+	 * base time as following.
+	 */
+	if (org_base_time <= current_time) {
+		u64 tmp = current_time - org_base_time;
+		u32 rem = 0;
+
+		if (tmp > cycle_time)
+			div_u64_rem(tmp, cycle_time, &rem);
+		rem = cycle_time - rem;
+		*new_base_time = threshold_time + rem;
+		return;
+	}
+
+	/* The only left place for org_base_time is between current_time and
+	 * threshold_time. In this case the new_base_time is calculated like
+	 * org_base_time + 2 * cycletime
+	 */
+	*new_base_time = org_base_time + 2 * cycle_time;
+}
+
+int lan966x_taprio_speed_set(struct lan966x_port *port, int speed)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u8 taprio_speed;
+
+	switch (speed) {
+	case SPEED_10:
+		taprio_speed = LAN966X_TAPRIO_SPEED_10;
+		break;
+	case SPEED_100:
+		taprio_speed = LAN966X_TAPRIO_SPEED_100;
+		break;
+	case SPEED_1000:
+		taprio_speed = LAN966X_TAPRIO_SPEED_1000;
+		break;
+	case SPEED_2500:
+		taprio_speed = LAN966X_TAPRIO_SPEED_2500;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	lan_rmw(QSYS_TAS_PROFILE_CFG_LINK_SPEED_SET(taprio_speed),
+		QSYS_TAS_PROFILE_CFG_LINK_SPEED,
+		lan966x, QSYS_TAS_PROFILE_CFG(port->chip_port));
+
+	return 0;
+}
+
+int lan966x_taprio_add(struct lan966x_port *port,
+		       struct tc_taprio_qopt_offload *qopt)
+{
+	struct lan966x *lan966x = port->lan966x;
+	int err, new_list, obs_list;
+	struct timespec64 ts;
+	ktime_t base_time;
+
+	err = lan966x_taprio_check(qopt);
+	if (err)
+		return err;
+
+	err = lan966x_taprio_find_list(port, qopt, &new_list, &obs_list);
+	if (err)
+		return err;
+
+	err = lan966x_taprio_gcl_setup(port, qopt, new_list);
+	if (err)
+		return err;
+
+	lan966x_taprio_new_base_time(lan966x, qopt->cycle_time,
+				     qopt->base_time, &base_time);
+
+	ts = ktime_to_timespec64(base_time);
+	lan_wr(QSYS_TAS_BT_NSEC_NSEC_SET(ts.tv_nsec),
+	       lan966x, QSYS_TAS_BT_NSEC);
+
+	lan_wr(lower_32_bits(ts.tv_sec),
+	       lan966x, QSYS_TAS_BT_SEC_LSB);
+
+	lan_wr(QSYS_TAS_BT_SEC_MSB_SEC_MSB_SET(upper_32_bits(ts.tv_sec)),
+	       lan966x, QSYS_TAS_BT_SEC_MSB);
+
+	lan_wr(qopt->cycle_time, lan966x, QSYS_TAS_CT_CFG);
+
+	lan_rmw(QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX_SET(obs_list),
+		QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX,
+		lan966x, QSYS_TAS_STARTUP_CFG);
+
+	/* Start list processing */
+	lan_rmw(QSYS_TAS_LST_LIST_STATE_SET(LAN966X_TAPRIO_STATE_ADVANCING),
+		QSYS_TAS_LST_LIST_STATE,
+		lan966x, QSYS_TAS_LST);
+
+	return err;
+}
+
+int lan966x_taprio_del(struct lan966x_port *port)
+{
+	return lan966x_taprio_shutdown(port);
+}
+
+void lan966x_taprio_init(struct lan966x *lan966x)
+{
+	int num_taprio_lists;
+	int p;
+
+	lan_wr(QSYS_TAS_STM_CFG_REVISIT_DLY_SET((256 * 1000) /
+						lan966x_ptp_get_period_ps()),
+	       lan966x, QSYS_TAS_STM_CFG);
+
+	num_taprio_lists = lan966x->num_phys_ports *
+			   LAN966X_TAPRIO_ENTRIES_PER_PORT;
+
+	/* For now we always use guard band on all queues */
+	lan_rmw(QSYS_TAS_CFG_CTRL_LIST_NUM_MAX_SET(num_taprio_lists) |
+		QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q_SET(1),
+		QSYS_TAS_CFG_CTRL_LIST_NUM_MAX |
+		QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q,
+		lan966x, QSYS_TAS_CFG_CTRL);
+
+	for (p = 0; p < lan966x->num_phys_ports; p++)
+		lan_rmw(QSYS_TAS_PROFILE_CFG_PORT_NUM_SET(p),
+			QSYS_TAS_PROFILE_CFG_PORT_NUM,
+			lan966x, QSYS_TAS_PROFILE_CFG(p));
+}
+
+void lan966x_taprio_deinit(struct lan966x *lan966x)
+{
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		if (!lan966x->ports[p])
+			continue;
+
+		lan966x_taprio_del(lan966x->ports[p]);
+	}
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 3fea0937076e1..cabc563f67685 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -15,6 +15,13 @@ static int lan966x_tc_setup_qdisc_mqprio(struct lan966x_port *port,
 			lan966x_mqprio_del(port);
 }
 
+static int lan966x_tc_setup_qdisc_taprio(struct lan966x_port *port,
+					 struct tc_taprio_qopt_offload *taprio)
+{
+	return taprio->enable ? lan966x_taprio_add(port, taprio) :
+				lan966x_taprio_del(port);
+}
+
 int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 		     void *type_data)
 {
@@ -23,6 +30,8 @@ int lan966x_tc_setup(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return lan966x_tc_setup_qdisc_mqprio(port, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return lan966x_tc_setup_qdisc_taprio(port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.33.0

