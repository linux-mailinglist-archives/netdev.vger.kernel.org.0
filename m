Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F67EA2BA4
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfH3ArN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38496 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfH3ArH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id e16so5208047wro.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gBu+Z0kpeIIVY2J23gGKWd+J3LOAZAzKI50m7BCV0WI=;
        b=nuFUxtVhe1OQ2RmhaxslHaI4+o0jCwBBtz7S2KPgxysRm0AcX95je1adXX/mUc8bEf
         dcZyMYnx+AgtxF5IH1wJyJq4t2pmiqPQTlQG8aI/XLhFKHpVla7jJzgLDFA3rDgHbMee
         0Oo5H8r9Qw1PcN2ILYiE1IdhguyC3pkkHfC1giVesf9Xz8SzDk/pmcH05Cj4OsbFCsa4
         Qy20o2G9OT5EhNDpjRzZwUioXfSqHw3HujmWgQx62LIBvjOVvrmFhMtc8jorbn1gF0fw
         CS9i0sTdxdFI91EWg0DVWUmA04kMM4MwHjuewbkMj6oHOOY/L/KWciaOXPs+Iz/yTNp9
         ASQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gBu+Z0kpeIIVY2J23gGKWd+J3LOAZAzKI50m7BCV0WI=;
        b=O7cBZQSf0N6wOT1VpP24IHppk3nEnU08/W2I3ZA72g7HZ133Ghu3uj9sM2kABATp1J
         b1Bf3vMSElcz12s6OGyUQYg3BhJDa3QGzD1ECLIVkgAuIaUAUg8zc/eCXJUIw9gLnw3m
         xRQ3sdloh7uHV9+ofaC3mrZGuSA69bny5kfA6wEH5V55LAg5iZmWgx9bAvh/UC/AcL5C
         YPzmjWDleEN5DvsFaDWGCszTTKZan85IIKPy4Z3ZDT8PuYd0G+WSfPp0sNFSztFDxhqh
         qEKhpuBBm0M61ey6LFCJU1qikP5VYHRYmOnJzCgwr14pZXINgSb/NuBKQDH+6rvHUUym
         j7NQ==
X-Gm-Message-State: APjAAAWEAOkqyfLs8o/8nhNQbZodA7aR9KfCxXZb8TTVNTwzwaSqVzfr
        fVM8ZebkPIwAHFNWdQF5l/k=
X-Google-Smtp-Source: APXvYqwtPYCsa6nt9hkXC/4b/Hj/qpmfJnLUtPdZi0qdgwcAlxcgV9Jyy03q+0vpVJyoo4YhqpgtEA==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr15495932wrn.140.1567126024192;
        Thu, 29 Aug 2019 17:47:04 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:47:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 12/15] net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload
Date:   Fri, 30 Aug 2019 03:46:32 +0300
Message-Id: <20190830004635.24863-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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
  source will be added in the next patch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig        |   8 +
 drivers/net/dsa/sja1105/Makefile       |   4 +
 drivers/net/dsa/sja1105/sja1105.h      |   5 +
 drivers/net/dsa/sja1105/sja1105_main.c |  19 +-
 drivers/net/dsa/sja1105/sja1105_tas.c  | 447 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h  |  47 +++
 6 files changed, 529 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 770134a66e48..55424f39cb0d 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -23,3 +23,11 @@ config NET_DSA_SJA1105_PTP
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
index 3ca0b87aa3e4..d95f9ce3b4f9 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -21,6 +21,7 @@
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
 #include "sja1105_ptp.h"
+#include "sja1105_tas.h"
 
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
@@ -96,6 +97,7 @@ struct sja1105_private {
 	struct mutex mgmt_lock;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
+	struct sja1105_tas_data tas_data;
 };
 
 #include "sja1105_dynamic_config.h"
@@ -111,6 +113,9 @@ typedef enum {
 	SPI_WRITE = 1,
 } sja1105_spi_rw_mode_t;
 
+/* From sja1105_main.c */
+int sja1105_static_config_reload(struct sja1105_private *priv);
+
 /* From sja1105_spi.c */
 int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8b930cc2dabc..4b393782cc84 100644
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
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
@@ -1761,6 +1762,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	sja1105_tas_teardown(priv);
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
 	sja1105_ptp_clock_unregister(priv);
@@ -2088,6 +2090,18 @@ static bool sja1105_port_txtstamp(struct dsa_switch *ds, int port,
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
@@ -2120,6 +2134,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_hwtstamp_set	= sja1105_hwtstamp_set,
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
+	.port_setup_tc		= sja1105_port_setup_tc,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2229,6 +2244,8 @@ static int sja1105_probe(struct spi_device *spi)
 	}
 	mutex_init(&priv->mgmt_lock);
 
+	sja1105_tas_setup(priv);
+
 	return dsa_register_switch(priv->ds);
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
new file mode 100644
index 000000000000..e316008246f6
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -0,0 +1,447 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include "sja1105.h"
+
+#define SJA1105_TAS_CLKSRC_DISABLED	0
+#define SJA1105_TAS_CLKSRC_STANDALONE	1
+#define SJA1105_TAS_CLKSRC_AS6802	2
+#define SJA1105_TAS_CLKSRC_PTP		3
+#define SJA1105_GATE_MASK		GENMASK_ULL(SJA1105_NUM_TC - 1, 0)
+#define SJA1105_TAS_MAX_DELTA		BIT(19)
+
+#define config_work_to_sja1105_tas(d) \
+	container_of((d), struct sja1105_tas_data, config_work)
+#define tas_to_sja1105(d) \
+	container_of((d), struct sja1105_private, tas_data)
+
+/* This is not a preprocessor macro because the "ns" argument may or may not be
+ * u64 at caller side. This ensures it is properly type-cast before div_u64.
+ */
+static u64 ns_to_sja1105_delta(u64 ns)
+{
+	return div_u64(ns, 200);
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
+ * Subschedule (cycle) i starts when PTPCLKVAL >= BLK_IDX_SCHEDULE_ENTRY_POINTS[i].delta.
+ * The hardware scheduler iterates BLK_IDX_SCHEDULE with a k ranging from
+ * k = BLK_IDX_SCHEDULE_ENTRY_POINTS[i].address to
+ * k = BLK_IDX_SCHEDULE_PARAMS.subscheind[i]
+ * For each schedule entry (timeslot) k, the engine executes the gate control
+ * list entry for the duration of BLK_IDX_SCHEDULE[k].delta.
+ *
+ *         +---------+
+ *         |         | BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS
+ *         +---------+
+ *              |
+ *              | .actsubsch
+ *              +-----------------+
+ *                                |
+ *                                |
+ *                                |
+ *  BLK_IDX_SCHEDULE_ENTRY_POINTS v
+ *                 +---------+---------+
+ *                 | cycle 0 | cycle 1 |
+ *                 +---------+---------+
+ *                   |  |         |  |
+ *  +----------------+  |         |  +-----------------------------------------------+
+ *  |   .subschindx     |         |                          .subschindx             |
+ *  |                   |         +-------------------+                              |
+ *  |          .address |           .address          |                              |
+ *  |                   |                             |                              |
+ *  |                   |                             |                              |
+ *  |  BLK_IDX_SCHEDULE v                             v                              |
+ *  |              +---------+---------+---------+---------+---------+---------+     |
+ *  |              | entry 0 | entry 1 | entry 2 | entry 3 | entry 4 | entry 5 |     |
+ *  |              +---------+---------+---------+---------+---------+---------+     |
+ *  |                                       ^                           ^  ^  ^      |
+ *  |                                       |                           |  |  |      |
+ *  |         +-----------------------------+                           |  |  |      |
+ *  |         |                                                         |  |  |      |
+ *  |         |                  +--------------------------------------+  |  |      |
+ *  |         |                  |                                         |  |      |
+ *  |         |                  |                 +-----------------------+  |      |
+ *  |         |                  |                 |                          |      |
+ *  |         |                  |                 | BLK_IDX_SCHEDULE_PARAMS  |      |
+ *  | +----------------------------------------------------------------------------+ |
+ *  | | .subscheind[0] <= .subscheind[1] <= .subscheind[2] <= ... <= subscheind[7] | |
+ *  | +----------------------------------------------------------------------------+ |
+ *  |         ^                  ^                                                   |
+ *  |         |                  |                                                   |
+ *  +---------+                  +---------------------------------------------------+
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
+	int subscheind[8] = {0};
+	int schedule_start_idx;
+	u64 entry_point_delta;
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
+		if (tas_data->config[port]) {
+			num_entries += tas_data->config[port]->num_entries;
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
+				 GFP_ATOMIC);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = num_entries;
+	schedule = table->entries;
+
+	/* Schedule Points Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS];
+	table->entries = kcalloc(SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_ATOMIC);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT;
+	schedule_entry_points_params = table->entries;
+
+	/* Schedule Parameters Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_PARAMS];
+	table->entries = kcalloc(SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_ATOMIC);
+	if (!table->entries)
+		return -ENOMEM;
+	table->entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT;
+	schedule_params = table->entries;
+
+	/* Schedule Entry Points Table */
+	table = &priv->static_config.tables[BLK_IDX_SCHEDULE_ENTRY_POINTS];
+	table->entries = kcalloc(num_cycles, table->ops->unpacked_entry_size,
+				 GFP_ATOMIC);
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
+		const struct tc_taprio_qopt_offload *tas_config;
+
+		tas_config = tas_data->config[port];
+		if (!tas_config)
+			continue;
+
+		schedule_start_idx = k;
+		schedule_end_idx = k + tas_config->num_entries - 1;
+		/* TODO this is only a relative base time for the subschedule
+		 * (relative to PTPSCHTM). But as we're using standalone and
+		 * not PTP clock as time reference, leave it like this for now.
+		 * Later we'll have to enforce that all ports' base times are
+		 * within SJA1105_TAS_MAX_DELTA 200ns cycles of one another.
+		 */
+		entry_point_delta = ns_to_sja1105_delta(tas_config->base_time);
+
+		schedule_entry_points[cycle].subschindx = cycle;
+		schedule_entry_points[cycle].delta = entry_point_delta;
+		schedule_entry_points[cycle].address = schedule_start_idx;
+
+		for (i = cycle; i < 8; i++)
+			subscheind[i] = schedule_end_idx;
+
+		for (i = 0; i < tas_config->num_entries; i++, k++) {
+			u64 delta_ns = tas_config->entries[i].interval;
+
+			schedule[k].delta = ns_to_sja1105_delta(delta_ns);
+			schedule[k].destports = BIT(port);
+			schedule[k].resmedia_en = true;
+			schedule[k].resmedia = SJA1105_GATE_MASK &
+					~tas_config->entries[i].gate_mask;
+		}
+		cycle++;
+	}
+
+	for (i = 0; i < 8; i++)
+		schedule_params->subscheind[i] = subscheind[i];
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
+ * So here we are with the task of validating whether the new @qopt has any
+ * conflict with the already established TAS configuration in tas_data->config.
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
+			    const struct tc_taprio_qopt_offload *qopt)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	int port;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		const struct tc_taprio_qopt_offload *tas_config;
+		u64 max_cycle_time, min_cycle_time;
+		u64 delta1, delta2;
+		u64 rbt1, rbt2;
+		u64 stop_time;
+		u64 t1, t2;
+		int i, j;
+		s32 rem;
+
+		tas_config = tas_data->config[port];
+
+		if (!tas_config)
+			continue;
+
+		/* Check if the two cycle times are multiples of one another.
+		 * If they aren't, then they will surely collide.
+		 */
+		max_cycle_time = max(tas_config->cycle_time, qopt->cycle_time);
+		min_cycle_time = min(tas_config->cycle_time, qopt->cycle_time);
+		div_u64_rem(max_cycle_time, min_cycle_time, &rem);
+		if (rem)
+			return true;
+
+		/* Calculate the "reduced" base time of each of the two cycles
+		 * (transposed back as close to 0 as possible) by dividing to
+		 * the cycle time.
+		 */
+		div_u64_rem(tas_config->base_time, tas_config->cycle_time,
+			    &rem);
+		rbt1 = rem;
+
+		div_u64_rem(qopt->base_time, qopt->cycle_time, &rem);
+		rbt2 = rem;
+
+		stop_time = max_cycle_time + max(rbt1, rbt2);
+
+		/* delta1 is the relative base time of each GCL entry within
+		 * the established ports' TAS config.
+		 */
+		for (i = 0, delta1 = 0;
+		     i < tas_config->num_entries;
+		     delta1 += tas_config->entries[i].interval, i++) {
+
+			/* delta2 is the relative base time of each GCL entry
+			 * within the newly added TAS config.
+			 */
+			for (j = 0, delta2 = 0;
+			     j < qopt->num_entries;
+			     delta2 += qopt->entries[j].interval, j++) {
+
+				/* t1 follows all possible occurrences of the
+				 * established ports' GCL entry i within the
+				 * first cycle time.
+				 */
+				for (t1 = rbt1 + delta1;
+				     t1 <= stop_time;
+				     t1 += tas_config->cycle_time) {
+
+					/* t2 follows all possible occurrences
+					 * of the newly added GCL entry j
+					 * within the first cycle time.
+					 */
+					for (t2 = rbt2 + delta2;
+					     t2 <= stop_time;
+					     t2 += qopt->cycle_time) {
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
+void sja1105_tas_config_work(struct work_struct *work)
+{
+	struct sja1105_tas_data *tas_data = config_work_to_sja1105_tas(work);
+	struct sja1105_private *priv = tas_to_sja1105(tas_data);
+	struct dsa_switch *ds = priv->ds;
+	int rc;
+
+	rc = sja1105_static_config_reload(priv);
+	if (rc)
+		dev_err(ds->dev, "Failed to change scheduling settings\n");
+}
+
+int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			    struct tc_taprio_qopt_offload *tas_config)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	int rc, i;
+
+	/* Can't change an already configured port (must delete qdisc first).
+	 * Can't delete the qdisc from an unconfigured port.
+	 */
+	if (!!tas_data->config[port] == tas_config->enable)
+		return -EINVAL;
+
+	if (!tas_config->enable) {
+		taprio_free(tas_data->config[port]);
+		tas_data->config[port] = NULL;
+
+		rc = sja1105_init_scheduling(priv);
+		if (rc < 0)
+			return rc;
+
+		schedule_work(&tas_data->config_work);
+
+		return 0;
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
+	if (tas_config->cycle_time_extension)
+		return -ENOTSUPP;
+
+	if (!ns_to_sja1105_delta(tas_config->base_time)) {
+		dev_err(ds->dev, "A base time of zero is not hardware-allowed\n");
+		return -ERANGE;
+	}
+
+	for (i = 0; i < tas_config->num_entries; i++) {
+		u64 delta_ns = tas_config->entries[i].interval;
+		u64 delta_cycles = ns_to_sja1105_delta(delta_ns);
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
+	if (sja1105_tas_check_conflicts(priv, tas_config))
+		return -ERANGE;
+
+	tas_data->config[port] = taprio_get(tas_config);
+
+	rc = sja1105_init_scheduling(priv);
+	if (rc < 0)
+		return rc;
+
+	schedule_work(&tas_data->config_work);
+
+	return 0;
+}
+
+void sja1105_tas_setup(struct sja1105_private *priv)
+{
+	INIT_WORK(&priv->tas_data.config_work, sja1105_tas_config_work);
+}
+
+void sja1105_tas_teardown(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	int port;
+
+	cancel_work_sync(&tas_data->config_work);
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++)
+		if (tas_data->config[port])
+			taprio_free(tas_data->config[port]);
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
new file mode 100644
index 000000000000..1629492e20ab
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -0,0 +1,47 @@
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
+	struct tc_taprio_qopt_offload *config[SJA1105_NUM_PORTS];
+	struct work_struct config_work;
+};
+
+void sja1105_tas_config_work(struct work_struct *work);
+
+int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			    struct tc_taprio_qopt_offload *qopt);
+
+void sja1105_tas_setup(struct sja1105_private *priv);
+
+void sja1105_tas_teardown(struct sja1105_private *priv);
+
+#else
+
+/* C doesn't allow empty structures, bah! */
+struct sja1105_tas_data {
+	u8 dummy;
+};
+
+#define sja1105_tas_config_work NULL
+
+static inline int
+sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
+			struct tc_taprio_qopt_offload *qopt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void sja1105_tas_setup(struct sja1105_private *priv) { }
+
+static inline void sja1105_tas_teardown(struct sja1105_private *priv) { }
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
+
+#endif /* _SJA1105_TAS_H */
-- 
2.17.1

