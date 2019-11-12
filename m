Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACFDF84F1
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfKLAMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:12:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42014 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLAMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:12:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so16531393wrf.9
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 16:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8PuMqsPIYMA+DSIgKeaYHmyoKJq9jwSabIz5AT0YfFA=;
        b=dBnwlzElSTiMnySa4Ii7oyC7yi8mZbull6R2VfMpSg0aBZ7DCU75SXiHsOonOFUNu5
         1n9nyIh3fLrEafDI89VCpk2ymciaLX9GmZpnI6g4h2rUJGHQHIXbsj8CcliN/H8ouWmq
         9FA19XqZmqqxD5S7ElzSzVzVBQB8UAwJZPGs89FJe9pCcJ60sRZVxspJec36cJbr4Yp6
         ZrLhDfjN9hRrFSjYCPyFsr4vsSoSI8r8Kf7ve3ZKcHq9ByMhk8lPsa2P7NBvYvAoPNBG
         Vf5rQz77ah54bQsLNbbo3j5lE5euxXYEHDNowIHBHE+j7vcITavnx+aikKbPyB6CqUoF
         sNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8PuMqsPIYMA+DSIgKeaYHmyoKJq9jwSabIz5AT0YfFA=;
        b=oK6s3s+bgVUFRDj+eFN65tnEf3FahRH33j5peJMvE60jW6di0JjnU3cVfgzvoQgLAY
         E3nNSgarwmfM9dlN310XABvSXYxjB9SZU1HAcgl795sGrxy9bX4JVF0xBuD/WI1uydhq
         ZQymmDthVMrKT/tgG6K7kUiu6iiCbB+S6/4usSm5q7O6Krvvyc9mT7wGev25Dc2pONNa
         jjGMXiGgeHKkcslka12+HyvaNUhjIOX8HCVpqeEVfj93Kkn6nV1zel5h6tv8zWiBcu3+
         Oy1CbRHM9XHjJAY8qvh7O6duE/5PHrLo839+bMPfaK7kQk5I3384POPANGk6xIkxGlFV
         9/zA==
X-Gm-Message-State: APjAAAVmS1em4yqntSinIGuLUpAsUudF44FStUu0azfplZ5BYVBHKRZX
        qeO+vqoczQwgTcwJ3KUzYwslbHbjnpA=
X-Google-Smtp-Source: APXvYqzDs9xfmc50TRI2GAgagu0Ij0H9SNBHNrwbOV5M2BWVB1iOEptiiW8KwxWPRCbb6Z+v3ccnKQ==
X-Received: by 2002:adf:ee92:: with SMTP id b18mr4860577wro.346.1573517522402;
        Mon, 11 Nov 2019 16:12:02 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id m25sm808687wmi.46.2019.11.11.16.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 16:12:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     vinicius.gomes@intel.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: Implement state machine for TAS with PTP clock source
Date:   Tue, 12 Nov 2019 02:11:54 +0200
Message-Id: <20191112001154.26650-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112001154.26650-1-olteanv@gmail.com>
References: <20191112001154.26650-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested using the following bash script and the tc from iproute2-next:

	#!/bin/bash

	set -e -u -o pipefail

	NSEC_PER_SEC="1000000000"

	gatemask() {
		local tc_list="$1"
		local mask=0

		for tc in ${tc_list}; do
			mask=$((${mask} | (1 << ${tc})))
		done

		printf "%02x" ${mask}
	}

	if ! systemctl is-active --quiet ptp4l; then
		echo "Please start the ptp4l service"
		exit
	fi

	now=$(phc_ctl /dev/ptp1 get | gawk '/clock time is/ { print $5; }')
	# Phase-align the base time to the start of the next second.
	sec=$(echo "${now}" | gawk -F. '{ print $1; }')
	base_time="$(((${sec} + 1) * ${NSEC_PER_SEC}))"

	tc qdisc add dev swp5 parent root handle 100 taprio \
		num_tc 8 \
		map 0 1 2 3 5 6 7 \
		queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
		base-time ${base_time} \
		sched-entry S $(gatemask 7) 100000 \
		sched-entry S $(gatemask "0 1 2 3 4 5 6") 400000 \
		clockid CLOCK_TAI flags 2

The "state machine" is a workqueue invoked after each manipulation
command on the PTP clock (reset, adjust time, set time, adjust
frequency) which checks over the state of the time-aware scheduler.
So it is not monitored periodically, only in reaction to a PTP command
typically triggered from a userspace daemon (linuxptp). Otherwise there
is no reason for things to go wrong.

Now that the timecounter/cyclecounter has been replaced with hardware
operations on the PTP clock, the TAS Kconfig now depends upon PTP and
the standalone clocksource operating mode has been removed.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig       |   1 +
 drivers/net/dsa/sja1105/sja1105.h     |   2 +
 drivers/net/dsa/sja1105/sja1105_ptp.c |  30 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h |  12 +
 drivers/net/dsa/sja1105/sja1105_spi.c |   4 +
 drivers/net/dsa/sja1105/sja1105_tas.c | 428 +++++++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_tas.h |  27 ++
 7 files changed, 487 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index ffac0ea4e8d5..0fe1ae173aa1 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -28,6 +28,7 @@ config NET_DSA_SJA1105_TAS
 	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
 	depends on NET_DSA_SJA1105 && NET_SCH_TAPRIO
 	depends on NET_SCH_TAPRIO=y || NET_DSA_SJA1105=m
+	depends on NET_DSA_SJA1105_PTP
 	help
 	  This enables support for the TTEthernet-based egress scheduling
 	  engine in the SJA1105 DSA driver, which is controlled using a
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 38340b74249e..29c7ed60cfdc 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -40,6 +40,8 @@ struct sja1105_regs {
 	u64 ptp_control;
 	u64 ptpclkval;
 	u64 ptpclkrate;
+	u64 ptpclkcorp;
+	u64 ptpschtm;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 pad_mii_id[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 00014e836d3f..54258a25031d 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -201,6 +201,8 @@ void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
 	u64 valid = 1;
 
 	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->ptpstrtsch, 30, 30, size, op);
+	sja1105_packing(buf, &cmd->ptpstopsch, 29, 29, size, op);
 	sja1105_packing(buf, &cmd->resptp,      2,  2, size, op);
 	sja1105_packing(buf, &cmd->corrclk4ts,  1,  1, size, op);
 	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
@@ -214,15 +216,17 @@ void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
 	u64 valid = 1;
 
 	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->ptpstrtsch, 30, 30, size, op);
+	sja1105_packing(buf, &cmd->ptpstopsch, 29, 29, size, op);
 	sja1105_packing(buf, &cmd->resptp,      3,  3, size, op);
 	sja1105_packing(buf, &cmd->corrclk4ts,  2,  2, size, op);
 	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
 }
 
-static int sja1105_ptp_commit(struct sja1105_private *priv,
-			      struct sja1105_ptp_cmd *cmd,
-			      sja1105_spi_rw_mode_t rw)
+int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
+		       sja1105_spi_rw_mode_t rw)
 {
+	const struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
 	int rc;
@@ -448,7 +452,9 @@ static int sja1105_ptp_reset(struct dsa_switch *ds)
 	cmd.resptp = 1;
 
 	dev_dbg(ds->dev, "Resetting PTP clock\n");
-	rc = sja1105_ptp_commit(priv, &cmd, SPI_WRITE);
+	rc = sja1105_ptp_commit(ds, &cmd, SPI_WRITE);
+
+	sja1105_tas_clockstep(priv->ds);
 
 	mutex_unlock(&ptp_data->lock);
 
@@ -504,7 +510,7 @@ static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 
 	ptp_data->cmd.ptpclkadd = mode;
 
-	return sja1105_ptp_commit(priv, &ptp_data->cmd, SPI_WRITE);
+	return sja1105_ptp_commit(priv->ds, &ptp_data->cmd, SPI_WRITE);
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 0 */
@@ -521,7 +527,11 @@ int __sja1105_ptp_settime(struct dsa_switch *ds, u64 ns,
 		return rc;
 	}
 
-	return sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+	rc = sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+
+	sja1105_tas_clockstep(priv->ds);
+
+	return rc;
 }
 
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
@@ -563,6 +573,8 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	rc = sja1105_xfer_u32(priv, SPI_WRITE, regs->ptpclkrate, &clkrate32,
 			      NULL);
 
+	sja1105_tas_adjfreq(priv->ds);
+
 	mutex_unlock(&ptp_data->lock);
 
 	return rc;
@@ -581,7 +593,11 @@ int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta)
 		return rc;
 	}
 
-	return sja1105_ptpclkval_write(priv, ticks, NULL);
+	rc = sja1105_ptpclkval_write(priv, ticks, NULL);
+
+	sja1105_tas_clockstep(priv->ds);
+
+	return rc;
 }
 
 static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 83d9d4ae6d3a..470f44b76318 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -22,6 +22,8 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 }
 
 struct sja1105_ptp_cmd {
+	u64 ptpstrtsch;		/* start schedule */
+	u64 ptpstopsch;		/* stop schedule */
 	u64 resptp;		/* reset */
 	u64 corrclk4ts;		/* use the corrected clock for timestamps */
 	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
@@ -69,6 +71,9 @@ int __sja1105_ptp_settime(struct dsa_switch *ds, u64 ns,
 
 int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta);
 
+int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
+		       sja1105_spi_rw_mode_t rw);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -110,6 +115,13 @@ static inline int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta)
 	return 0;
 }
 
+static inline int sja1105_ptp_commit(struct dsa_switch *ds,
+				     struct sja1105_ptp_cmd *cmd,
+				     sja1105_spi_rw_mode_t rw)
+{
+	return 0;
+}
+
 #define sja1105et_ptp_cmd_packing NULL
 
 #define sja1105pqrs_ptp_cmd_packing NULL
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index ba245bd98124..fca3a973764b 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -539,9 +539,11 @@ static struct sja1105_regs sja1105et_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
 	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
+	.ptpschtm = 0x12, /* Spans 0x12 to 0x13 */
 	.ptp_control = 0x17,
 	.ptpclkval = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
+	.ptpclkcorp = 0x1D,
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -569,9 +571,11 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
 	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
+	.ptpschtm = 0x13, /* Spans 0x13 to 0x14 */
 	.ptp_control = 0x18,
 	.ptpclkval = 0x19,
 	.ptpclkrate = 0x1B,
+	.ptpclkcorp = 0x1E,
 };
 
 struct sja1105_info sja1105e_info = {
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index d846fb5c4e4d..26b925b5dace 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -10,6 +10,11 @@
 #define SJA1105_TAS_MAX_DELTA		BIT(19)
 #define SJA1105_GATE_MASK		GENMASK_ULL(SJA1105_NUM_TC - 1, 0)
 
+#define work_to_sja1105_tas(d) \
+	container_of((d), struct sja1105_tas_data, tas_work)
+#define tas_to_sja1105(d) \
+	container_of((d), struct sja1105_private, tas_data)
+
 /* This is not a preprocessor macro because the "ns" argument may or may not be
  * s64 at caller side. This ensures it is properly type-cast before div_s64.
  */
@@ -18,6 +23,100 @@ static s64 ns_to_sja1105_delta(s64 ns)
 	return div_s64(ns, 200);
 }
 
+static s64 sja1105_delta_to_ns(s64 delta)
+{
+	return delta * 200;
+}
+
+/* Calculate the first base_time in the future that satisfies this
+ * relationship:
+ *
+ * future_base_time = base_time + N x cycle_time >= now, or
+ *
+ *      now - base_time
+ * N >= ---------------
+ *         cycle_time
+ *
+ * Because N is an integer, the ceiling value of the above "a / b" ratio
+ * is in fact precisely the floor value of "(a + b - 1) / b", which is
+ * easier to calculate only having integer division tools.
+ */
+static s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
+{
+	s64 a, b, n;
+
+	if (base_time >= now)
+		return base_time;
+
+	a = now - base_time;
+	b = cycle_time;
+	n = div_s64(a + b - 1, b);
+
+	return base_time + n * cycle_time;
+}
+
+static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct dsa_switch *ds = priv->ds;
+	s64 earliest_base_time = S64_MAX;
+	s64 latest_base_time = 0;
+	s64 its_cycle_time = 0;
+	s64 max_cycle_time = 0;
+	int port;
+
+	tas_data->enabled = false;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		const struct tc_taprio_qopt_offload *offload;
+
+		offload = tas_data->offload[port];
+		if (!offload)
+			continue;
+
+		tas_data->enabled = true;
+
+		if (max_cycle_time < offload->cycle_time)
+			max_cycle_time = offload->cycle_time;
+		if (latest_base_time < offload->base_time)
+			latest_base_time = offload->base_time;
+		if (earliest_base_time > offload->base_time) {
+			earliest_base_time = offload->base_time;
+			its_cycle_time = offload->cycle_time;
+		}
+	}
+
+	if (!tas_data->enabled)
+		return 0;
+
+	/* Roll the earliest base time over until it is in a comparable
+	 * time base with the latest, then compare their deltas.
+	 * We want to enforce that all ports' base times are within
+	 * SJA1105_TAS_MAX_DELTA 200ns cycles of one another.
+	 */
+	earliest_base_time = future_base_time(earliest_base_time,
+					      its_cycle_time,
+					      latest_base_time);
+	while (earliest_base_time > latest_base_time)
+		earliest_base_time -= its_cycle_time;
+	if (latest_base_time - earliest_base_time >
+	    sja1105_delta_to_ns(SJA1105_TAS_MAX_DELTA)) {
+		dev_err(ds->dev,
+			"Base times too far apart: min %llu max %llu\n",
+			earliest_base_time, latest_base_time);
+		return -ERANGE;
+	}
+
+	tas_data->earliest_base_time = earliest_base_time;
+	tas_data->max_cycle_time = max_cycle_time;
+
+	dev_dbg(ds->dev, "earliest base time %lld ns\n", earliest_base_time);
+	dev_dbg(ds->dev, "latest base time %lld ns\n", latest_base_time);
+	dev_dbg(ds->dev, "longest cycle time %lld ns\n", max_cycle_time);
+
+	return 0;
+}
+
 /* Lo and behold: the egress scheduler from hell.
  *
  * At the hardware level, the Time-Aware Shaper holds a global linear arrray of
@@ -99,7 +198,11 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 	int num_cycles = 0;
 	int cycle = 0;
 	int i, k = 0;
-	int port;
+	int port, rc;
+
+	rc = sja1105_tas_set_runtime_params(priv);
+	if (rc < 0)
+		return rc;
 
 	/* Discard previous Schedule Table */
 	table = &priv->static_config.tables[BLK_IDX_SCHEDULE];
@@ -184,11 +287,13 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 	schedule_entry_points = table->entries;
 
 	/* Finally start populating the static config tables */
-	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_STANDALONE;
+	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_PTP;
 	schedule_entry_points_params->actsubsch = num_cycles - 1;
 
 	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
 		const struct tc_taprio_qopt_offload *offload;
+		/* Relative base time */
+		s64 rbt;
 
 		offload = tas_data->offload[port];
 		if (!offload)
@@ -196,15 +301,21 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 
 		schedule_start_idx = k;
 		schedule_end_idx = k + offload->num_entries - 1;
-		/* TODO this is the base time for the port's subschedule,
-		 * relative to PTPSCHTM. But as we're using the standalone
-		 * clock source and not PTP clock as time reference, there's
-		 * little point in even trying to put more logic into this,
-		 * like preserving the phases between the subschedules of
-		 * different ports. We'll get all of that when switching to the
-		 * PTP clock source.
+		/* This is the base time expressed as a number of TAS ticks
+		 * relative to PTPSCHTM, which we'll (perhaps improperly) call
+		 * the operational base time.
+		 */
+		rbt = future_base_time(offload->base_time,
+				       offload->cycle_time,
+				       tas_data->earliest_base_time);
+		rbt -= tas_data->earliest_base_time;
+		/* UM10944.pdf 4.2.2. Schedule Entry Points table says that
+		 * delta cannot be zero, which is shitty. Advance all relative
+		 * base times by 1 TAS delta, so that even the earliest base
+		 * time becomes 1 in relative terms. Then start the operational
+		 * base time (PTPSCHTM) one TAS delta earlier than planned.
 		 */
-		entry_point_delta = 1;
+		entry_point_delta = ns_to_sja1105_delta(rbt) + 1;
 
 		schedule_entry_points[cycle].subschindx = cycle;
 		schedule_entry_points[cycle].delta = entry_point_delta;
@@ -403,8 +514,303 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	return sja1105_static_config_reload(priv, SJA1105_SCHEDULING);
 }
 
+static int sja1105_tas_check_running(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct dsa_switch *ds = priv->ds;
+	struct sja1105_ptp_cmd cmd = {0};
+	int rc;
+
+	rc = sja1105_ptp_commit(ds, &cmd, SPI_READ);
+	if (rc < 0)
+		return rc;
+
+	if (cmd.ptpstrtsch == 1)
+		/* Schedule successfully started */
+		tas_data->state = SJA1105_TAS_STATE_RUNNING;
+	else if (cmd.ptpstopsch == 1)
+		/* Schedule is stopped */
+		tas_data->state = SJA1105_TAS_STATE_DISABLED;
+	else
+		/* Schedule is probably not configured with PTP clock source */
+		rc = -EINVAL;
+
+	return rc;
+}
+
+/* Write to PTPCLKCORP */
+static int sja1105_tas_adjust_drift(struct sja1105_private *priv,
+				    u64 correction)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u32 ptpclkcorp = ns_to_sja1105_ticks(correction);
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->ptpclkcorp,
+				&ptpclkcorp, NULL);
+}
+
+/* Write to PTPSCHTM */
+static int sja1105_tas_set_base_time(struct sja1105_private *priv,
+				     u64 base_time)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u64 ptpschtm = ns_to_sja1105_ticks(base_time);
+
+	return sja1105_xfer_u64(priv, SPI_WRITE, regs->ptpschtm,
+				&ptpschtm, NULL);
+}
+
+static int sja1105_tas_start(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_ptp_cmd *cmd = &priv->ptp_data.cmd;
+	struct dsa_switch *ds = priv->ds;
+	int rc;
+
+	dev_dbg(ds->dev, "Starting the TAS\n");
+
+	if (tas_data->state == SJA1105_TAS_STATE_ENABLED_NOT_RUNNING ||
+	    tas_data->state == SJA1105_TAS_STATE_RUNNING) {
+		dev_err(ds->dev, "TAS already started\n");
+		return -EINVAL;
+	}
+
+	cmd->ptpstrtsch = 1;
+	cmd->ptpstopsch = 0;
+
+	rc = sja1105_ptp_commit(ds, cmd, SPI_WRITE);
+	if (rc < 0)
+		return rc;
+
+	tas_data->state = SJA1105_TAS_STATE_ENABLED_NOT_RUNNING;
+
+	return 0;
+}
+
+static int sja1105_tas_stop(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_ptp_cmd *cmd = &priv->ptp_data.cmd;
+	struct dsa_switch *ds = priv->ds;
+	int rc;
+
+	dev_dbg(ds->dev, "Stopping the TAS\n");
+
+	if (tas_data->state == SJA1105_TAS_STATE_DISABLED) {
+		dev_err(ds->dev, "TAS already disabled\n");
+		return -EINVAL;
+	}
+
+	cmd->ptpstopsch = 1;
+	cmd->ptpstrtsch = 0;
+
+	rc = sja1105_ptp_commit(ds, cmd, SPI_WRITE);
+	if (rc < 0)
+		return rc;
+
+	tas_data->state = SJA1105_TAS_STATE_DISABLED;
+
+	return 0;
+}
+
+/* The schedule engine and the PTP clock are driven by the same oscillator, and
+ * they run in parallel. But whilst the PTP clock can keep an absolute
+ * time-of-day, the schedule engine is only running in 'ticks' (25 ticks make
+ * up a delta, which is 200ns), and wrapping around at the end of each cycle.
+ * The schedule engine is started when the PTP clock reaches the PTPSCHTM time
+ * (in PTP domain).
+ * Because the PTP clock can be rate-corrected (accelerated or slowed down) by
+ * a software servo, and the schedule engine clock runs in parallel to the PTP
+ * clock, there is logic internal to the switch that periodically keeps the
+ * schedule engine from drifting away. The frequency with which this internal
+ * syntonization happens is the PTP clock correction period (PTPCLKCORP). It is
+ * a value also in the PTP clock domain, and is also rate-corrected.
+ * To be precise, during a correction period, there is logic to determine by
+ * how many scheduler clock ticks has the PTP clock drifted. At the end of each
+ * correction period/beginning of new one, the length of a delta is shrunk or
+ * expanded with an integer number of ticks, compared with the typical 25.
+ * So a delta lasts for 200ns (or 25 ticks) only on average.
+ * Sometimes it is longer, sometimes it is shorter. The internal syntonization
+ * logic can adjust for at most 5 ticks each 20 ticks.
+ *
+ * The first implication is that you should choose your schedule correction
+ * period to be an integer multiple of the schedule length. Preferably one.
+ * In case there are schedules of multiple ports active, then the correction
+ * period needs to be a multiple of them all. Given the restriction that the
+ * cycle times have to be multiples of one another anyway, this means the
+ * correction period can simply be the largest cycle time, hence the current
+ * choice. This way, the updates are always synchronous to the transmission
+ * cycle, and therefore predictable.
+ *
+ * The second implication is that at the beginning of a correction period, the
+ * first few deltas will be modulated in time, until the schedule engine is
+ * properly phase-aligned with the PTP clock. For this reason, you should place
+ * your best-effort traffic at the beginning of a cycle, and your
+ * time-triggered traffic afterwards.
+ *
+ * The third implication is that once the schedule engine is started, it can
+ * only adjust for so much drift within a correction period. In the servo you
+ * can only change the PTPCLKRATE, but not step the clock (PTPCLKADD). If you
+ * want to do the latter, you need to stop and restart the schedule engine,
+ * which is what the state machine handles.
+ */
+static void sja1105_tas_state_machine(struct work_struct *work)
+{
+	struct sja1105_tas_data *tas_data = work_to_sja1105_tas(work);
+	struct sja1105_private *priv = tas_to_sja1105(tas_data);
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+	struct timespec64 base_time_ts, now_ts;
+	struct dsa_switch *ds = priv->ds;
+	struct timespec64 diff;
+	s64 base_time, now;
+	int rc = 0;
+
+	mutex_lock(&ptp_data->lock);
+
+	switch (tas_data->state) {
+	case SJA1105_TAS_STATE_DISABLED:
+		/* Can't do anything at all if clock is still being stepped */
+		if (tas_data->last_op != SJA1105_PTP_ADJUSTFREQ)
+			break;
+
+		rc = sja1105_tas_adjust_drift(priv, tas_data->max_cycle_time);
+		if (rc < 0)
+			break;
+
+		rc = __sja1105_ptp_gettimex(ds, &now, NULL);
+		if (rc < 0)
+			break;
+
+		/* Plan to start the earliest schedule first. The others
+		 * will be started in hardware, by way of their respective
+		 * entry points delta.
+		 * Try our best to avoid fringe cases (race condition between
+		 * ptpschtm and ptpstrtsch) by pushing the oper_base_time at
+		 * least one second in the future from now. This is not ideal,
+		 * but this only needs to buy us time until the
+		 * sja1105_tas_start command below gets executed.
+		 */
+		base_time = future_base_time(tas_data->earliest_base_time,
+					     tas_data->max_cycle_time,
+					     now + 1ull * NSEC_PER_SEC);
+		base_time -= sja1105_delta_to_ns(1);
+
+		rc = sja1105_tas_set_base_time(priv, base_time);
+		if (rc < 0)
+			break;
+
+		tas_data->oper_base_time = base_time;
+
+		rc = sja1105_tas_start(priv);
+		if (rc < 0)
+			break;
+
+		base_time_ts = ns_to_timespec64(base_time);
+		now_ts = ns_to_timespec64(now);
+
+		dev_dbg(ds->dev, "OPER base time %lld.%09ld (now %lld.%09ld)\n",
+			base_time_ts.tv_sec, base_time_ts.tv_nsec,
+			now_ts.tv_sec, now_ts.tv_nsec);
+
+		break;
+
+	case SJA1105_TAS_STATE_ENABLED_NOT_RUNNING:
+		if (tas_data->last_op != SJA1105_PTP_ADJUSTFREQ) {
+			/* Clock was stepped.. bad news for TAS */
+			sja1105_tas_stop(priv);
+			break;
+		}
+
+		/* Check if TAS has actually started, by comparing the
+		 * scheduled start time with the SJA1105 PTP clock
+		 */
+		rc = __sja1105_ptp_gettimex(ds, &now, NULL);
+		if (rc < 0)
+			break;
+
+		if (now < tas_data->oper_base_time) {
+			/* TAS has not started yet */
+			diff = ns_to_timespec64(tas_data->oper_base_time - now);
+			dev_dbg(ds->dev, "time to start: [%lld.%09ld]",
+				diff.tv_sec, diff.tv_nsec);
+			break;
+		}
+
+		/* Time elapsed, what happened? */
+		rc = sja1105_tas_check_running(priv);
+		if (rc < 0)
+			break;
+
+		if (tas_data->state != SJA1105_TAS_STATE_RUNNING)
+			/* TAS has started */
+			dev_err(ds->dev,
+				"TAS not started despite time elapsed\n");
+
+		break;
+
+	case SJA1105_TAS_STATE_RUNNING:
+		/* Clock was stepped.. bad news for TAS */
+		if (tas_data->last_op != SJA1105_PTP_ADJUSTFREQ) {
+			sja1105_tas_stop(priv);
+			break;
+		}
+
+		rc = sja1105_tas_check_running(priv);
+		if (rc < 0)
+			break;
+
+		if (tas_data->state != SJA1105_TAS_STATE_RUNNING)
+			dev_err(ds->dev, "TAS surprisingly stopped\n");
+
+		break;
+
+	default:
+		if (net_ratelimit())
+			dev_err(ds->dev, "TAS in an invalid state (incorrect use of API)!\n");
+	}
+
+	if (rc && net_ratelimit())
+		dev_err(ds->dev, "An operation returned %d\n", rc);
+
+	mutex_unlock(&ptp_data->lock);
+}
+
+void sja1105_tas_clockstep(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+
+	if (!tas_data->enabled)
+		return;
+
+	tas_data->last_op = SJA1105_PTP_CLOCKSTEP;
+	schedule_work(&tas_data->tas_work);
+}
+
+void sja1105_tas_adjfreq(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+
+	if (!tas_data->enabled)
+		return;
+
+	/* No reason to schedule the workqueue, nothing changed */
+	if (tas_data->state == SJA1105_TAS_STATE_RUNNING)
+		return;
+
+	tas_data->last_op = SJA1105_PTP_ADJUSTFREQ;
+	schedule_work(&tas_data->tas_work);
+}
+
 void sja1105_tas_setup(struct dsa_switch *ds)
 {
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+
+	INIT_WORK(&tas_data->tas_work, sja1105_tas_state_machine);
+	tas_data->state = SJA1105_TAS_STATE_DISABLED;
+	tas_data->last_op = SJA1105_PTP_NONE;
 }
 
 void sja1105_tas_teardown(struct dsa_switch *ds)
@@ -413,6 +819,8 @@ void sja1105_tas_teardown(struct dsa_switch *ds)
 	struct tc_taprio_qopt_offload *offload;
 	int port;
 
+	cancel_work_sync(&priv->tas_data.tas_work);
+
 	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
 		offload = priv->tas_data.offload[port];
 		if (!offload)
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index 0aad212d88b2..b226c3dfd5b1 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -8,8 +8,27 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS)
 
+enum sja1105_tas_state {
+	SJA1105_TAS_STATE_DISABLED,
+	SJA1105_TAS_STATE_ENABLED_NOT_RUNNING,
+	SJA1105_TAS_STATE_RUNNING,
+};
+
+enum sja1105_ptp_op {
+	SJA1105_PTP_NONE,
+	SJA1105_PTP_CLOCKSTEP,
+	SJA1105_PTP_ADJUSTFREQ,
+};
+
 struct sja1105_tas_data {
 	struct tc_taprio_qopt_offload *offload[SJA1105_NUM_PORTS];
+	enum sja1105_tas_state state;
+	enum sja1105_ptp_op last_op;
+	struct work_struct tas_work;
+	s64 earliest_base_time;
+	s64 oper_base_time;
+	u64 max_cycle_time;
+	bool enabled;
 };
 
 int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
@@ -19,6 +38,10 @@ void sja1105_tas_setup(struct dsa_switch *ds);
 
 void sja1105_tas_teardown(struct dsa_switch *ds);
 
+void sja1105_tas_clockstep(struct dsa_switch *ds);
+
+void sja1105_tas_adjfreq(struct dsa_switch *ds);
+
 #else
 
 /* C doesn't allow empty structures, bah! */
@@ -36,6 +59,10 @@ static inline void sja1105_tas_setup(struct dsa_switch *ds) { }
 
 static inline void sja1105_tas_teardown(struct dsa_switch *ds) { }
 
+static inline void sja1105_tas_clockstep(struct dsa_switch *ds) { }
+
+static inline void sja1105_tas_adjfreq(struct dsa_switch *ds) { }
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
 
 #endif /* _SJA1105_TAS_H */
-- 
2.17.1

