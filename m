Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44820B2DA7
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfIOBxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38960 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfIOBxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so5918567wml.4
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvM4Cx5eKfJzQy36fH6gLKKjiEbPr26cgPTbB6U6mag=;
        b=Xj2MCIe5BQB7XY6RwVLu+muqwS9069dbVxVyhoBePhSRfOhiWE7gHoehhW2cycKrGM
         y7pvPdxdusX1xUMJDNPJHYd4tzF8Tv8ZUlDum4XHAkMTPjT3jckWZhV6iTI9ZB9S4k2q
         qpxVM0s/nuLRGIX172f4GoYHjFP/vejPCmTRfsJ6AH2pfQaFvHmUAbR3tk6iuo7UgSkh
         9dQeitpZn1u+4SSG88840kwwIb78In/SLmsDjJHu31z4Et2SXDOnwX3AlaKdSyvAvgqu
         7AGKSAI8t+G6BFpbKof1PrnH6EcEG7bnbaSBKK1R+tiV8uQPFBlD9hMa39t8nL74iuHG
         9UxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvM4Cx5eKfJzQy36fH6gLKKjiEbPr26cgPTbB6U6mag=;
        b=QMJEss7OeZM4f5Q7GvCrTz+bKsDrBGjNbbSlkk31Usoo+Bmn1Qq2liDQ9qnSDC3js0
         Mn+LrfI11KDXzhfmq4i8Ck00HmNMHGUbocZr3PCgEKTyWA0Bt2fsnjYITQyWz+SJg1YA
         11ZdtCfUQL2UEB68i12yVGXeQcR3hwGisdfZjfh/0+TbNKw21uywlzYGmr5gKS1YnHwN
         y6ieF56tm6cu3GvNGz8GGejv5HgqpcVQKoDwSs5Z9gBCAoKsoi9a8jSGPq76cCUrOXQY
         y+uDHxsISdjcv2vJOe6zLv3a+kyWlK4GQJy2cQ8bWL2pwAkv86Ddt2zcl0yZNlgAQElm
         1Jhg==
X-Gm-Message-State: APjAAAX9faXXwq+q3CHGs6B3JtQZ/X/LdTdRJ3n7LBprxfXzpu5MlRoo
        9qz4x6I2aKAIc2IwgaJJask=
X-Google-Smtp-Source: APXvYqxPSfBItLXCbYsLi0/0hGC3kEbs/DggEZ2r8MNnDsobBgEh7EEmp+1mgl7yp/jPscP1PuyAOw==
X-Received: by 2002:a05:600c:294f:: with SMTP id n15mr562018wmd.157.1568512427655;
        Sat, 14 Sep 2019 18:53:47 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 6/7] net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload
Date:   Sun, 15 Sep 2019 04:53:13 +0300
Message-Id: <20190915015314.26605-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915015314.26605-1-olteanv@gmail.com>
References: <20190915015314.26605-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This qdisc offload is the closest thing to what the SJA1105 supports in
hardware for time-based egress shaping. The switch core really is built
around SAE AS6802/TTEthernet (a TTTech standard) but can be made to
operate similarly to IEEE 802.1Qbv with some constraints:

- The gate control list is a global list for all ports. There are 8
  execution threads that iterate through this global list in parallel.
  I don't know why 8, there are only 4 front-panel ports.

- Care must be taken by the user to make sure that two execution threads
  never get to execute a GCL entry simultaneously. I created a O(n^4)
  checker for this hardware limitation, prior to accepting a taprio
  offload configuration as valid.

- The spec says that if a GCL entry's interval is shorter than the frame
  length, you shouldn't send it (and end up in head-of-line blocking).
  Well, this switch does anyway.

- The switch has no concept of ADMIN and OPER configurations. Because
  it's so simple, the TAS settings are loaded through the static config
  tables interface, so there isn't even place for any discussion about
  'graceful switchover between ADMIN and OPER'. You just reset the
  switch and upload a new OPER config.

- The switch accepts multiple time sources for the gate events. Right
  now I am using the standalone clock source as opposed to PTP. So the
  base time parameter doesn't really do much. Support for the PTP clock
  source will be added in a future series.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig        |   8 +
 drivers/net/dsa/sja1105/Makefile       |   4 +
 drivers/net/dsa/sja1105/sja1105.h      |   6 +
 drivers/net/dsa/sja1105/sja1105_main.c |  19 +-
 drivers/net/dsa/sja1105/sja1105_tas.c  | 427 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h  |  42 +++
 6 files changed, 505 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index e26666b1ecb9..4dc873e985e6 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -32,3 +32,11 @@ config NET_DSA_SJA1105_PTP
 	help
 	  This enables support for timestamping and PTP clock manipulations in
 	  the SJA1105 DSA driver.
+
+config NET_DSA_SJA1105_TAS
+	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
+	depends on NET_DSA_SJA1105
+	help
+	  This enables support for the TTEthernet-based egress scheduling
+	  engine in the SJA1105 DSA driver, which is controlled using a
+	  hardware offload of the tc-tqprio qdisc.
diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 4483113e6259..66161e874344 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -12,3 +12,7 @@ sja1105-objs := \
 ifdef CONFIG_NET_DSA_SJA1105_PTP
 sja1105-objs += sja1105_ptp.o
 endif
+
+ifdef CONFIG_NET_DSA_SJA1105_TAS
+sja1105-objs += sja1105_tas.o
+endif
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 78094db32622..e53e494c22e0 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -20,6 +20,8 @@
  */
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
+#include "sja1105_tas.h"
+
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
 	u64 device_id;
@@ -104,6 +106,7 @@ struct sja1105_private {
 	 */
 	struct mutex mgmt_lock;
 	struct sja1105_tagger_data tagger_data;
+	struct sja1105_tas_data tas_data;
 };
 
 #include "sja1105_dynamic_config.h"
@@ -120,6 +123,9 @@ typedef enum {
 	SPI_WRITE = 1,
 } sja1105_spi_rw_mode_t;
 
+/* From sja1105_main.c */
+int sja1105_static_config_reload(struct sja1105_private *priv);
+
 /* From sja1105_spi.c */
 int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0b0205abc3d2..7f09ebd529d0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -22,6 +22,7 @@
 #include <linux/if_ether.h>
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
+#include "sja1105_tas.h"
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
@@ -1382,7 +1383,7 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
  * modify at runtime (currently only MAC) and restore them after uploading,
  * such that this operation is relatively seamless.
  */
-static int sja1105_static_config_reload(struct sja1105_private *priv)
+int sja1105_static_config_reload(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
@@ -1727,6 +1728,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	sja1105_tas_teardown(ds);
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
 	sja1105_ptp_clock_unregister(priv);
@@ -2056,6 +2058,18 @@ static bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
 	return true;
 }
 
+static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type,
+				 void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_TAPRIO:
+		return sja1105_setup_tc_taprio(ds, port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -2088,6 +2102,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_hwtstamp_set	= sja1105_hwtstamp_set,
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
+	.port_setup_tc		= sja1105_port_setup_tc,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2197,6 +2212,8 @@ static int sja1105_probe(struct spi_device *spi)
 	}
 	mutex_init(&priv->mgmt_lock);
 
+	sja1105_tas_setup(ds);
+
 	return dsa_register_switch(priv->ds);
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
new file mode 100644
index 000000000000..053c7d09b76f
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -0,0 +1,427 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include "sja1105.h"
+
+#define SJA1105_TAS_CLKSRC_DISABLED	0
+#define SJA1105_TAS_CLKSRC_STANDALONE	1
+#define SJA1105_TAS_CLKSRC_AS6802	2
+#define SJA1105_TAS_CLKSRC_PTP		3
+#define SJA1105_TAS_MAX_DELTA		BIT(19)
+#define SJA1105_GATE_MASK		GENMASK_ULL(SJA1105_NUM_TC - 1, 0)
+
+/* This is not a preprocessor macro because the "ns" argument may or may not be
+ * s64 at caller side. This ensures it is properly type-cast before div_s64.
+ */
+static s64 ns_to_sja1105_delta(s64 ns)
+{
+	return div_s64(ns, 200);
+}
+
+/* Lo and behold: the egress scheduler from hell.
+ *
+ * At the hardware level, the Time-Aware Shaper holds a global linear arrray of
+ * all schedule entries for all ports. These are the Gate Control List (GCL)
+ * entries, let's call them "timeslots" for short. This linear array of
+ * timeslots is held in BLK_IDX_SCHEDULE.
+ *
+ * Then there are a maximum of 8 "execution threads" inside the switch, which
+ * iterate cyclically through the "schedule". Each "cycle" has an entry point
+ * and an exit point, both being timeslot indices in the schedule table. The
+ * hardware calls each cycle a "subschedule".
+ *
+ * Subschedule (cycle) i starts when
+ *   ptpclkval >= ptpschtm + BLK_IDX_SCHEDULE_ENTRY_POINTS[i].delta.
+ *
+ * The hardware scheduler iterates BLK_IDX_SCHEDULE with a k ranging from
+ *   k = BLK_IDX_SCHEDULE_ENTRY_POINTS[i].address to
+ *   k = BLK_IDX_SCHEDULE_PARAMS.subscheind[i]
+ *
+ * For each schedule entry (timeslot) k, the engine executes the gate control
+ * list entry for the duration of BLK_IDX_SCHEDULE[k].delta.
+ *
+ *         +---------+
+ *         |         | BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS
+ *         +---------+
+ *              |
+ *              +-----------------+
+ *                                | .actsubsch
+ *  BLK_IDX_SCHEDULE_ENTRY_POINTS v
+ *                 +-------+-------+
+ *                 |cycle 0|cycle 1|
+ *                 +-------+-------+
+ *                   |  |      |  |
+ *  +----------------+  |      |  +-------------------------------------+
+ *  |   .subschindx     |      |             .subschindx                |
+ *  |                   |      +---------------+                        |
+ *  |          .address |        .address      |                        |
+ *  |                   |                      |                        |
+ *  |                   |                      |                        |
+ *  |  BLK_IDX_SCHEDULE v                      v                        |
+ *  |              +-------+-------+-------+-------+-------+------+     |
+ *  |              |entry 0|entry 1|entry 2|entry 3|entry 4|entry5|     |
+ *  |              +-------+-------+-------+-------+-------+------+     |
+ *  |                                  ^                    ^  ^  ^     |
+ *  |                                  |                    |  |  |     |
+ *  |        +-------------------------+                    |  |  |     |
+ *  |        |              +-------------------------------+  |  |     |
+ *  |        |              |              +-------------------+  |     |
+ *  |        |              |              |                      |     |
+ *  | +---------------------------------------------------------------+ |
+ *  | |subscheind[0]<=subscheind[1]<=subscheind[2]<=...<=subscheind[7]| |
+ *  | +---------------------------------------------------------------+ |
+ *  |        ^              ^                BLK_IDX_SCHEDULE_PARAMS    |
+ *  |        |              |                                           |
+ *  +--------+              +-------------------------------------------+
+ *
+ *  In the above picture there are two subschedules (cycles):
+ *
+ *  - cycle 0: iterates the schedule table from 0 to 2 (and back)
+ *  - cycle 1: iterates the schedule table from 3 to 5 (and back)
+ *
+ *  All other possible execution threads must be marked as unused by making
+ *  their "subschedule end index" (subscheind) equal to the last valid
+ *  subschedule's end index (in this case 5).
+ */
+static int sja1105_init_scheduling(struct sja1105_private *priv)
+{
+	struct sja1105_schedule_entry_points_entry *schedule_entry_points;
+	struct sja1105_schedule_entry_points_params_entry
+					*schedule_entry_points_params;
+	struct sja1105_schedule_params_entry *schedule_params;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_schedule_entry *schedule;
+	struct sja1105_table *table;
+	int schedule_start_idx;
+	s64 entry_point_delta;
+	int schedule_end_idx;
+	int num_entries = 0;
+	int num_cycles = 0;
+	int cycle = 0;
+	int i, k = 0;
+	int port;
+
+	/* Discard previous Schedule Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Discard previous Schedule Entry Points Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Discard previous Schedule Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_PARAMS];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Discard previous Schedule Entry Points Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS];
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Figure out the dimensioning of the problem */
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		if (tas_data->offload[port]) {
+			num_entries += tas_data->offload[port]->num_entries;
+			num_cycles++;
+		}
+	}
+
+	/* Nothing to do */
+	if (!num_cycles)
+		return 0;
+
+	/* Pre-allocate space in the static config tables */
+
+	/* Schedule Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE];
+	table->entries = kcalloc(num_entries, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = num_entries;
+	schedule = table->entries;
+
+	/* Schedule Points Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS];
+	table->entries = kcalloc(SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		/* Previously allocated memory will be freed automatically in
+		 * sja1105_static_config_free. This is true for all early
+		 * returns below.
+		 */
+		return -ENOMEM;
+	table->entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT;
+	schedule_entry_points_params = table->entries;
+
+	/* Schedule Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_PARAMS];
+	table->entries = kcalloc(SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT;
+	schedule_params = table->entries;
+
+	/* Schedule Entry Points Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS];
+	table->entries = kcalloc(num_cycles, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = num_cycles;
+	schedule_entry_points = table->entries;
+
+	/* Finally start populating the static config tables */
+	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_STANDALONE;
+	schedule_entry_points_params->actsubsch = num_cycles - 1;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		const struct tc_taprio_qopt_offload *offload;
+
+		offload = tas_data->offload[port];
+		if (!offload)
+			continue;
+
+		schedule_start_idx = k;
+		schedule_end_idx = k + offload->num_entries - 1;
+		/* TODO this is only a relative base time for the subschedule
+		 * (relative to PTPSCHTM). But as we're using standalone and
+		 * not PTP clock as time reference, leave it like this for now.
+		 * Later we'll have to enforce that all ports' base times are
+		 * within SJA1105_TAS_MAX_DELTA 200ns cycles of one another.
+		 */
+		entry_point_delta = ns_to_sja1105_delta(offload->base_time);
+
+		schedule_entry_points[cycle].subschindx = cycle;
+		schedule_entry_points[cycle].delta = entry_point_delta;
+		schedule_entry_points[cycle].address = schedule_start_idx;
+
+		/* The subschedule end indices need to be
+		 * monotonically increasing.
+		 */
+		for (i = cycle; i < 8; i++)
+			schedule_params->subscheind[i] = schedule_end_idx;
+
+		for (i = 0; i < offload->num_entries; i++, k++) {
+			s64 delta_ns = offload->entries[i].interval;
+
+			schedule[k].delta = ns_to_sja1105_delta(delta_ns);
+			schedule[k].destports = BIT(port);
+			schedule[k].resmedia_en = true;
+			schedule[k].resmedia = SJA1105_GATE_MASK &
+					~offload->entries[i].gate_mask;
+		}
+		cycle++;
+	}
+
+	return 0;
+}
+
+/* Be there 2 port subschedules, each executing an arbitrary number of gate
+ * open/close events cyclically.
+ * None of those gate events must ever occur at the exact same time, otherwise
+ * the switch is known to act in exotically strange ways.
+ * However the hardware doesn't bother performing these integrity checks - the
+ * designers probably said "nah, let's leave that to the experts" - oh well,
+ * now we're the experts.
+ * So here we are with the task of validating whether the @new offload has any
+ * conflict with the already established TAS configuration in tas_data->offload.
+ * We already know the other ports are in harmony with one another, otherwise
+ * we wouldn't have saved them.
+ * Each gate event executes periodically, with a period of @cycle_time and a
+ * phase given by its cycle's @base_time plus its offset within the cycle
+ * (which in turn is given by the length of the events prior to it).
+ * There are two aspects to possible collisions:
+ * - Collisions within one cycle's (actually the longest cycle's) time frame.
+ *   For that, we need to compare the cartesian product of each possible
+ *   occurrence of each event within one cycle time.
+ * - Collisions in the future. Events may not collide within one cycle time,
+ *   but if two port schedules don't have the same periodicity (aka the cycle
+ *   times aren't multiples of one another), they surely will some time in the
+ *   future (actually they will collide an infinite amount of times).
+ */
+static bool
+sja1105_tas_check_conflicts(struct sja1105_private *priv,
+			    const struct tc_taprio_qopt_offload *new)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	int port;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		const struct tc_taprio_qopt_offload *offload;
+		s64 max_cycle_time, min_cycle_time;
+		s64 delta1, delta2;
+		s64 rbt1, rbt2;
+		s64 stop_time;
+		s64 t1, t2;
+		int i, j;
+		s32 rem;
+
+		offload = tas_data->offload[port];
+
+		if (!offload)
+			continue;
+
+		/* Check if the two cycle times are multiples of one another.
+		 * If they aren't, then they will surely collide.
+		 */
+		max_cycle_time = max(offload->cycle_time, new->cycle_time);
+		min_cycle_time = min(offload->cycle_time, new->cycle_time);
+		div_s64_rem(max_cycle_time, min_cycle_time, &rem);
+		if (rem)
+			return true;
+
+		/* Calculate the "reduced" base time of each of the two cycles
+		 * (transposed back as close to 0 as possible) by dividing to
+		 * the cycle time.
+		 */
+		div_s64_rem(offload->base_time, offload->cycle_time, &rem);
+		rbt1 = rem;
+
+		div_s64_rem(new->base_time, new->cycle_time, &rem);
+		rbt2 = rem;
+
+		stop_time = max_cycle_time + max(rbt1, rbt2);
+
+		/* delta1 is the relative base time of each GCL entry within
+		 * the established ports' TAS config.
+		 */
+		for (i = 0, delta1 = 0;
+		     i < offload->num_entries;
+		     delta1 += offload->entries[i].interval, i++) {
+
+			/* delta2 is the relative base time of each GCL entry
+			 * within the newly added TAS config.
+			 */
+			for (j = 0, delta2 = 0;
+			     j < new->num_entries;
+			     delta2 += new->entries[j].interval, j++) {
+
+				/* t1 follows all possible occurrences of the
+				 * established ports' GCL entry i within the
+				 * first cycle time.
+				 */
+				for (t1 = rbt1 + delta1;
+				     t1 <= stop_time;
+				     t1 += offload->cycle_time) {
+
+					/* t2 follows all possible occurrences
+					 * of the newly added GCL entry j
+					 * within the first cycle time.
+					 */
+					for (t2 = rbt2 + delta2;
+					     t2 <= stop_time;
+					     t2 += new->cycle_time) {
+
+						if (t1 == t2) {
+							dev_warn(priv->ds->dev,
+								 "GCL entry %d collides with entry %d of port %d\n",
+								 j, i, port);
+							return true;
+						}
+					}
+				}
+			}
+		}
+	}
+
+	return false;
+}
+
+int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			    struct tc_taprio_qopt_offload *offload)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	int rc, i;
+
+	/* Can't change an already configured port (must delete qdisc first).
+	 * Can't delete the qdisc from an unconfigured port.
+	 */
+	if (!!tas_data->offload[port] == offload->enable)
+		return -EINVAL;
+
+	if (!offload->enable) {
+		taprio_offload_free(tas_data->offload[port]);
+		tas_data->offload[port] = NULL;
+
+		rc = sja1105_init_scheduling(priv);
+		if (rc < 0)
+			return rc;
+
+		return sja1105_static_config_reload(priv);
+	}
+
+	/* The cycle time extension is the amount of time the last cycle from
+	 * the old OPER needs to be extended in order to phase-align with the
+	 * base time of the ADMIN when that becomes the new OPER.
+	 * But of course our switch needs to be reset to switch-over between
+	 * the ADMIN and the OPER configs - so much for a seamless transition.
+	 * So don't add insult over injury and just say we don't support cycle
+	 * time extension.
+	 */
+	if (offload->cycle_time_extension)
+		return -ENOTSUPP;
+
+	if (!ns_to_sja1105_delta(offload->base_time)) {
+		dev_err(ds->dev, "A base time of zero is not hardware-allowed\n");
+		return -ERANGE;
+	}
+
+	for (i = 0; i < offload->num_entries; i++) {
+		s64 delta_ns = offload->entries[i].interval;
+		s64 delta_cycles = ns_to_sja1105_delta(delta_ns);
+		bool too_long, too_short;
+
+		too_long = (delta_cycles >= SJA1105_TAS_MAX_DELTA);
+		too_short = (delta_cycles == 0);
+		if (too_long || too_short) {
+			dev_err(priv->ds->dev,
+				"Interval %llu too %s for GCL entry %d\n",
+				delta_ns, too_long ? "long" : "short", i);
+			return -ERANGE;
+		}
+	}
+
+	if (sja1105_tas_check_conflicts(priv, offload))
+		return -ERANGE;
+
+	tas_data->offload[port] = taprio_offload_get(offload);
+
+	rc = sja1105_init_scheduling(priv);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_config_reload(priv);
+}
+
+void sja1105_tas_setup(struct dsa_switch *ds)
+{
+}
+
+void sja1105_tas_teardown(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct tc_taprio_qopt_offload *offload;
+	int port;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		offload = priv->tas_data.offload[port];
+		if (!offload)
+			continue;
+
+		taprio_offload_free(offload);
+	}
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
new file mode 100644
index 000000000000..c735ad6a8236
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#ifndef _SJA1105_TAS_H
+#define _SJA1105_TAS_H
+
+#include <net/pkt_sched.h>
+
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS)
+
+struct sja1105_tas_data {
+	struct tc_taprio_qopt_offload *offload[SJA1105_NUM_PORTS];
+};
+
+int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			    struct tc_taprio_qopt_offload *offload);
+
+void sja1105_tas_setup(struct dsa_switch *ds);
+
+void sja1105_tas_teardown(struct dsa_switch *ds);
+
+#else
+
+/* C doesn't allow empty structures, bah! */
+struct sja1105_tas_data {
+	u8 dummy;
+};
+
+static inline int
+sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			struct tc_taprio_qopt_offload *offload)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void sja1105_tas_setup(struct dsa_switch *ds) { }
+
+static inline void sja1105_tas_teardown(struct dsa_switch *ds) { }
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
+
+#endif /* _SJA1105_TAS_H */
-- 
2.17.1

