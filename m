Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D74A615B4
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfGGR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51694 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfGGR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so13542464wma.1
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jT+kO3GoSoLptWDkqc1INwNbspePX3jmLWmG1/Yd7bc=;
        b=g8d6r+aQwnYRhC+ssTDiPnyI7kBwxdfuPn/IHfO29xaspTqdr47K/MxAe+nkyymeTw
         0z+ahCJCQEmoIHpnACw/IO5YcELGTUXjFavRdnoWYJh10awJcTvJnOHn1uh6YKZcx4aO
         np8OjPEGySnbp3+bgTIAiAySDWMA60vykdeeGNZ9UX9fVncoHEh0KG5cT93U42lj2KbY
         Y0oFKQuzK+FLfgpGPLIV2Y59dMxSwL/Fyko4kUMyB4Czocr598lUaA0QoZcM1/+ZdqOE
         4AcRP6nEZ8dGsYCSbnr1E6AZN0SmAyJoqmeA6hTKdiNxmdG8Q7Sr9L8QpJ0VoHmohglb
         qNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jT+kO3GoSoLptWDkqc1INwNbspePX3jmLWmG1/Yd7bc=;
        b=J4BvkRgp+mqJ/C1fJG1zunGBDTtkFn1iEq9m9h02chGLAkuwXNesAUttavkABYh0n7
         tfpPL+XrzmndKAL16diG1IBsq1LDN6VQfJGlJc7qXRIGuq7PdWp9usofAHjL1JofPCTC
         qQwy3ZbJpkLEsXZFq4taOBW7GYk7WpjhktjsoTvSXeURqQuXdgSR2H3YcCj6ZJWDO8mm
         s2hAnC5IA8SF04MnDTvjSOWithG7MTSg5885JntAEC0CIj6vsnmLRmwQ7KnsCxi6eiQZ
         9xJgayjM9/4ISHjnKVnPT1v+gTMCCGBNZfUN5oYhOTHV984CpnVS0ok1O2h4GhctNByl
         IGTQ==
X-Gm-Message-State: APjAAAV/QGUFwzaP1jBW1vTg12I66imh7FAMNmtOtLecYPQBIH46CDnX
        jlb/YFToQRnNxH8qa2kBC6c=
X-Google-Smtp-Source: APXvYqxFkjZeRFxPfyFQNR2bAQZJuO3BZnnkuBfharO1y/pD3JNBCdo72gYKeqDSY04zQGVpW9/PpA==
X-Received: by 2002:a1c:f918:: with SMTP id x24mr12239564wmh.132.1562520580483;
        Sun, 07 Jul 2019 10:29:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 6/6] net: dsa: sja1105: Configure the Time-Aware Shaper via tc-taprio offload
Date:   Sun,  7 Jul 2019 20:29:21 +0300
Message-Id: <20190707172921.17731-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
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
  never get to execute a GCL entry simultaneously. I created a O(n^5)
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
  base time parameter doesn't really do much. This is because the PTP
  part of the driver uses a timecounter/cyclecounter and its PTP clock
  is free-running (so it's not a valid time source for 802.1Qbv anyway).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig        |   8 +
 drivers/net/dsa/sja1105/Makefile       |   4 +
 drivers/net/dsa/sja1105/sja1105.h      |   6 +
 drivers/net/dsa/sja1105/sja1105_main.c |  12 +-
 drivers/net/dsa/sja1105/sja1105_tas.c  | 452 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h  |  22 ++
 6 files changed, 503 insertions(+), 1 deletion(-)
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
index 12cfcae0dc11..b326345f3f5c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -8,6 +8,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/dsa/sja1105.h>
+#include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include <linux/mutex.h>
 #include "sja1105_static_config.h"
@@ -111,6 +112,8 @@ struct sja1105_private {
 	 */
 	struct mutex mgmt_lock;
 	struct sja1105_tagger_data tagger_data;
+	struct tc_taprio_qopt_offload *tas_config[SJA1105_NUM_PORTS];
+	struct work_struct tas_config_work;
 };
 
 #include "sja1105_dynamic_config.h"
@@ -127,6 +130,9 @@ typedef enum {
 	SPI_WRITE = 1,
 } sja1105_spi_rw_mode_t;
 
+/* From sja1105_main.c */
+int sja1105_static_config_reload(struct sja1105_private *priv);
+
 /* From sja1105_spi.c */
 int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 				sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 30761e6545a3..0efc4bfa42d9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -22,6 +22,7 @@
 #include <linux/if_ether.h>
 #include <linux/dsa/8021q.h>
 #include "sja1105.h"
+#include "sja1105_tas.h"
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
@@ -1375,7 +1376,7 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
  * modify at runtime (currently only MAC) and restore them after uploading,
  * such that this operation is relatively seamless.
  */
-static int sja1105_static_config_reload(struct sja1105_private *priv)
+int sja1105_static_config_reload(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry *mac;
 	int speed_mbps[SJA1105_NUM_PORTS];
@@ -1719,9 +1720,16 @@ static int sja1105_setup(struct dsa_switch *ds)
 static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	int port;
 
 	cancel_work_sync(&priv->tagger_data.rxtstamp_work);
 	skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
+
+	cancel_work_sync(&priv->tas_config_work);
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++)
+		if (priv->tas_config[port])
+			kfree(priv->tas_config[port]);
 }
 
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
@@ -2075,6 +2083,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_hwtstamp_set	= sja1105_hwtstamp_set,
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
+	.port_setup_taprio	= sja1105_setup_taprio,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2173,6 +2182,7 @@ static int sja1105_probe(struct spi_device *spi)
 	tagger_data = &priv->tagger_data;
 	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
 	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+	INIT_WORK(&priv->tas_config_work, sja1105_tas_config_work);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
new file mode 100644
index 000000000000..7fe7c5cbfbff
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -0,0 +1,452 @@
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
+/* This is not a preprocessor macro because the "ns" argument may or may not be
+ * u64 at caller side. This ensures it is properly type-cast before div_u64.
+ */
+static u64 sja1105_tas_cycles(u64 ns)
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
+		if (priv->tas_config[port]) {
+			num_entries += priv->tas_config[port]->num_entries;
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
+		tas_config = priv->tas_config[port];
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
+		entry_point_delta = sja1105_tas_cycles(tas_config->base_time);
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
+			schedule[k].delta = sja1105_tas_cycles(delta_ns);
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
+static struct tc_taprio_qopt_offload
+*tc_taprio_qopt_offload_copy(const struct tc_taprio_qopt_offload *from)
+{
+	struct tc_taprio_qopt_offload *to;
+	size_t size;
+
+	size = sizeof(*from) +
+		from->num_entries * sizeof(struct tc_taprio_sched_entry);
+
+	to = kzalloc(size, GFP_ATOMIC);
+	if (!to)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(to, from, size);
+
+	return to;
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
+ * conflict with the already established TAS configuration in priv->tas_config.
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
+	int port;
+
+	/* No conflicts if we just want to disable this port's TAS config */
+	if (!qopt->enable)
+		return false;
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
+		tas_config = priv->tas_config[port];
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
+#define to_sja1105(d) \
+	container_of((d), struct sja1105_private, tas_config_work)
+
+void sja1105_tas_config_work(struct work_struct *work)
+{
+	struct sja1105_private *priv = to_sja1105(work);
+	struct dsa_switch *ds = priv->ds;
+	int rc;
+
+	rc = sja1105_static_config_reload(priv);
+	if (rc)
+		dev_err(ds->dev, "Failed to change scheduling settings\n");
+}
+
+int sja1105_setup_taprio(struct dsa_switch *ds, int port,
+			 const struct tc_taprio_qopt_offload *qopt)
+{
+	struct tc_taprio_qopt_offload *tas_config;
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+	int i;
+
+	/* Can't change an already configured port (must delete qdisc first).
+	 * Can't delete the qdisc from an unconfigured port.
+	 */
+	if (!!priv->tas_config[port] == qopt->enable)
+		return -EINVAL;
+
+	if (!qopt->enable) {
+		kfree(priv->tas_config[port]);
+		priv->tas_config[port] = NULL;
+		rc = sja1105_init_scheduling(priv);
+		if (rc < 0)
+			return rc;
+
+		schedule_work(&priv->tas_config_work);
+		return 0;
+	}
+
+	/* What is this? */
+	if (qopt->cycle_time_extension)
+		return -ENOTSUPP;
+
+	if (!sja1105_tas_cycles(qopt->base_time)) {
+		dev_err(ds->dev, "A base time of zero is not hardware-allowed\n");
+		return -ERANGE;
+	}
+
+	tas_config = tc_taprio_qopt_offload_copy(qopt);
+	if (IS_ERR_OR_NULL(tas_config))
+		return PTR_ERR(tas_config);
+
+	if (!tas_config->cycle_time) {
+		for (i = 0; i < tas_config->num_entries; i++) {
+			u64 delta_ns = tas_config->entries[i].interval;
+			u64 delta_cycles = sja1105_tas_cycles(delta_ns);
+			bool too_long, too_short;
+
+			/* The cycle_time may not be provided. In that case it
+			 * will be sum of all time interval of the entries in
+			 * the schedule.
+			 */
+			tas_config->cycle_time += delta_ns;
+
+			too_long = (delta_cycles >= SJA1105_TAS_MAX_DELTA);
+			too_short = (delta_cycles == 0);
+			if (too_long || too_short) {
+				dev_err(priv->ds->dev,
+					"Interval %llu too %s for GCL entry %d\n",
+					delta_ns, too_long ? "long" : "short", i);
+				return -ERANGE;
+			}
+		}
+	}
+
+	if (sja1105_tas_check_conflicts(priv, tas_config)) {
+		kfree(tas_config);
+		return -ERANGE;
+	}
+
+	priv->tas_config[port] = tas_config;
+
+	rc = sja1105_init_scheduling(priv);
+	if (rc < 0)
+		return rc;
+
+	schedule_work(&priv->tas_config_work);
+	return 0;
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
new file mode 100644
index 000000000000..af535b4f5f29
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#ifndef _SJA1105_TAS_H
+#define _SJA1105_TAS_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS)
+
+void sja1105_tas_config_work(struct work_struct *work);
+
+int sja1105_setup_taprio(struct dsa_switch *ds, int port,
+			 struct tc_taprio_qopt_offload *qopt);
+
+#else
+
+#define sja1105_tas_config_work NULL
+
+#define sja1105_setup_taprio NULL
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
+
+#endif /* _SJA1105_TAS_H */
-- 
2.17.1

