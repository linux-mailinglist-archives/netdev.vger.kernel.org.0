Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB542A2BA7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfH3ArU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53209 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbfH3ArO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id t17so5496578wmi.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8QMFISiQjz0hREIh8mIIF5ovLu505oRHUDBNINKJUpE=;
        b=Sv2Ay4H1AW/BS2SKUG9WQDSeIhif8zNfCHv5gALgNpRG6OMgighDLxqG3qsCTnDur6
         LNgtNHwFnJBGzub/uUYj+Jo14CWCMdaG9LPNublpM0AV2SLfbzj9cuCrBby54Rd1dUD+
         HO+vr1Z1LykqkhR5JuyMk93425K14/ORExAJUWYd2hPOqVtGMpFMfcHWehVXo7DyVhDi
         brQlfrcrn1HBodfN7zAtad+sK3hl+3cXcq0BNBcFqibiTIqZnXT5ZaYAhixIhbO69ks3
         SbVesfpWCG6jX/1k1/Yn/ZvczNFQ5qAx/vCOzzLM2b89b+BLMZ6VtmriLEx5qrg970ZY
         LFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8QMFISiQjz0hREIh8mIIF5ovLu505oRHUDBNINKJUpE=;
        b=jvkZy8XPMGX2U+UnvURqe2GcuDZMl+N0PpEz/Yr379pvmULYsB8oocdL8mWtPxhpAA
         zNGHuKr6YSvPyH+HJJYS9fTrv7jINwHcE23bYJbTrqoQTdm+7Yv/xVBkuSw25qsTrX9F
         9F3/6btQMa1IY/aN7JW1fKetQUcMZkcMPzqRZu5HAlOfUVvwO/XDLp9/TmNL5YEc89J3
         HyaX3kyQ1NKIkKUdEigSOCMVGzX3Y4zBBIjrt/Kooeeqen6Du8CxRA641J75TZByLqQ+
         Y1XeDimje5mA0mB4zQrlW7jXaL4mMU34UmqoIIvk8x9iLC4gpW+vqo02Do3/6Emyu9Cz
         RyYQ==
X-Gm-Message-State: APjAAAWwdKvEjx0aB0NkrJjnKtkkMr7QdsKO0roxvd+M8yZbJXSjkt1q
        NXDC7BFO0iYFvtL7wCzpr/w=
X-Google-Smtp-Source: APXvYqyyK4FdscfnC68GXA7dQq7K1IdZkmbth7kJqqwFdnRyQiQaMKmlJ9bhDVVIQdDnZbs+IAgFXA==
X-Received: by 2002:a1c:3944:: with SMTP id g65mr15205926wma.68.1567126027987;
        Thu, 29 Aug 2019 17:47:07 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:47:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 15/15] net: dsa: sja1105: Implement state machine for TAS with PTP clock source
Date:   Fri, 30 Aug 2019 03:46:35 +0300
Message-Id: <20190830004635.24863-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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

	echo 'file drivers/net/dsa/sja1105/sja1105_tas.c +plm' | \
		sudo tee /sys/kernel/debug/dynamic_debug/control

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
 drivers/net/dsa/sja1105/Kconfig       |   2 +-
 drivers/net/dsa/sja1105/sja1105.h     |   2 +
 drivers/net/dsa/sja1105/sja1105_ptp.c |  26 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c |   4 +
 drivers/net/dsa/sja1105/sja1105_tas.c | 420 +++++++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_tas.h |  27 ++
 7 files changed, 480 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 4dc873e985e6..9316a23b7c30 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -35,7 +35,7 @@ config NET_DSA_SJA1105_PTP
 
 config NET_DSA_SJA1105_TAS
 	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
-	depends on NET_DSA_SJA1105
+	depends on NET_DSA_SJA1105_PTP
 	help
 	  This enables support for the TTEthernet-based egress scheduling
 	  engine in the SJA1105 DSA driver, which is controlled using a
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 44f7385c51b5..e8f95b6fadfa 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -40,6 +40,8 @@ struct sja1105_regs {
 	u64 ptp_control;
 	u64 ptpclk;
 	u64 ptpclkrate;
+	u64 ptpclkcorp;
+	u64 ptpschtm;
 	u64 ptpegr_ts[SJA1105_NUM_PORTS];
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 pad_mii_id[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index ed80278a3521..b037834ff820 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -67,6 +67,8 @@ void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
 	u64 valid = 1;
 
 	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->ptpstrtsch, 30, 30, size, op);
+	sja1105_packing(buf, &cmd->ptpstopsch, 29, 29, size, op);
 	sja1105_packing(buf, &cmd->resptp,      2,  2, size, op);
 	sja1105_packing(buf, &cmd->corrclk4ts,  1,  1, size, op);
 	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
@@ -80,14 +82,16 @@ void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
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
+int sja1105_ptp_commit(struct sja1105_private *priv,
+		       struct sja1105_ptp_cmd *cmd,
+		       sja1105_spi_rw_mode_t rw)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
@@ -222,6 +226,8 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 	dev_dbg(priv->ds->dev, "Resetting PTP clock\n");
 	rc = sja1105_ptp_commit(priv, &cmd, SPI_WRITE);
 
+	sja1105_tas_clockstep(priv);
+
 	mutex_unlock(&ptp_data->lock);
 
 	return rc;
@@ -291,7 +297,11 @@ int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
 		return rc;
 	}
 
-	return sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+	rc = sja1105_ptpclkval_write(priv, ticks, ptp_sts);
+
+	sja1105_tas_clockstep(priv);
+
+	return rc;
 }
 
 static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
@@ -331,6 +341,8 @@ static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
 				  &clkrate, 4, NULL);
 
+	sja1105_tas_adjfreq(priv);
+
 	mutex_unlock(&priv->ptp_data.lock);
 
 	return rc;
@@ -366,7 +378,11 @@ int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
 		return rc;
 	}
 
-	return sja1105_ptpclkval_write(priv, ticks, NULL);
+	rc = sja1105_ptpclkval_write(priv, ticks, NULL);
+
+	sja1105_tas_clockstep(priv);
+
+	return rc;
 }
 
 static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index c24c40115650..da68e5881e5f 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -29,6 +29,8 @@ enum sja1105_ptp_clk_mode {
 };
 
 struct sja1105_ptp_cmd {
+	u64 ptpstrtsch;		/* start schedule */
+	u64 ptpstopsch;		/* stop schedule */
 	u64 resptp;		/* reset */
 	u64 corrclk4ts;		/* use the corrected clock for timestamps */
 	u64 ptpclkadd;		/* enum sja1105_ptp_clk_mode */
@@ -73,6 +75,10 @@ int __sja1105_ptp_settime(struct sja1105_private *priv, u64 ns,
 
 int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta);
 
+int sja1105_ptp_commit(struct sja1105_private *priv,
+		       struct sja1105_ptp_cmd *cmd,
+		       sja1105_spi_rw_mode_t rw);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -135,6 +141,13 @@ static inline int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
 	return 0;
 }
 
+static inline int sja1105_ptp_commit(struct sja1105_private *priv,
+				     struct sja1105_ptp_cmd *cmd,
+				     sja1105_spi_rw_mode_t rw)
+{
+	return 0;
+}
+
 #define sja1105et_ptp_cmd_packing NULL
 
 #define sja1105pqrs_ptp_cmd_packing NULL
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 794cc5077565..f6df050c15ec 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -526,9 +526,11 @@ static struct sja1105_regs sja1105et_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
 	.ptpegr_ts = {0xC0, 0xC2, 0xC4, 0xC6, 0xC8},
+	.ptpschtm = 0x12, /* Spans 0x12 to 0x13 */
 	.ptp_control = 0x17,
 	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
 	.ptpclkrate = 0x1A,
+	.ptpclkcorp = 0x1D,
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -556,9 +558,11 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
 	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
+	.ptpschtm = 0x13, /* Spans 0x13 to 0x14 */
 	.ptp_control = 0x18,
 	.ptpclk = 0x19,
 	.ptpclkrate = 0x1B,
+	.ptpclkcorp = 0x1E,
 };
 
 struct sja1105_info sja1105e_info = {
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index e316008246f6..d19c8c62812c 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -12,6 +12,8 @@
 
 #define config_work_to_sja1105_tas(d) \
 	container_of((d), struct sja1105_tas_data, config_work)
+#define tas_work_to_sja1105_tas(d) \
+	container_of((d), struct sja1105_tas_data, tas_work)
 #define tas_to_sja1105(d) \
 	container_of((d), struct sja1105_private, tas_data)
 
@@ -23,6 +25,100 @@ static u64 ns_to_sja1105_delta(u64 ns)
 	return div_u64(ns, 200);
 }
 
+static u64 sja1105_delta_to_ns(u64 tas_cycles)
+{
+	return tas_cycles * 200;
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
+static u64 future_base_time(u64 base_time, u64 cycle_time, u64 now)
+{
+	u64 a, b, n;
+
+	if (base_time >= now)
+		return base_time;
+
+	a = now - base_time;
+	b = cycle_time;
+	n = div_u64(a + b - 1, b);
+
+	return base_time + n * cycle_time;
+}
+
+static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	s64 earliest_base_time = S64_MAX;
+	s64 latest_base_time = 0;
+	s64 its_cycle_time = 0;
+	s64 max_cycle_time = 0;
+	int port;
+
+	tas_data->enabled = false;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		const struct tc_taprio_qopt_offload *tas_config;
+
+		tas_config = tas_data->config[port];
+		if (!tas_config)
+			continue;
+
+		tas_data->enabled = true;
+
+		if (max_cycle_time < tas_config->cycle_time)
+			max_cycle_time = tas_config->cycle_time;
+		if (latest_base_time < tas_config->base_time)
+			latest_base_time = tas_config->base_time;
+		if (earliest_base_time > tas_config->base_time) {
+			earliest_base_time = tas_config->base_time;
+			its_cycle_time = tas_config->cycle_time;
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
+	if (latest_base_time - earliest_base_time >
+	    sja1105_delta_to_ns(SJA1105_TAS_MAX_DELTA)) {
+		dev_err(priv->ds->dev,
+			"Base times too far apart: min %llu max %llu\n",
+			earliest_base_time, latest_base_time);
+		return -ERANGE;
+	}
+
+	tas_data->earliest_base_time = earliest_base_time;
+	tas_data->max_cycle_time = max_cycle_time;
+
+	dev_dbg(priv->ds->dev, "earliest base time %llu\n",
+		tas_data->earliest_base_time);
+	dev_dbg(priv->ds->dev, "latest base time %llu\n",
+		tas_data->earliest_base_time);
+	dev_dbg(priv->ds->dev, "max cycle time %llu\n",
+		tas_data->max_cycle_time);
+
+	return 0;
+}
+
 /* Lo and behold: the egress scheduler from hell.
  *
  * At the hardware level, the Time-Aware Shaper holds a global linear arrray of
@@ -108,7 +204,11 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
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
@@ -189,11 +289,13 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 	schedule_entry_points = table->entries;
 
 	/* Finally start populating the static config tables */
-	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_STANDALONE;
+	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_PTP;
 	schedule_entry_points_params->actsubsch = num_cycles - 1;
 
 	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
 		const struct tc_taprio_qopt_offload *tas_config;
+		/* Relative base time */
+		u64 rbt;
 
 		tas_config = tas_data->config[port];
 		if (!tas_config)
@@ -201,13 +303,20 @@ static int sja1105_init_scheduling(struct sja1105_private *priv)
 
 		schedule_start_idx = k;
 		schedule_end_idx = k + tas_config->num_entries - 1;
-		/* TODO this is only a relative base time for the subschedule
-		 * (relative to PTPSCHTM). But as we're using standalone and
-		 * not PTP clock as time reference, leave it like this for now.
-		 * Later we'll have to enforce that all ports' base times are
-		 * within SJA1105_TAS_MAX_DELTA 200ns cycles of one another.
+		/* This is only a relative base time for the subschedule
+		 * (relative to PTPSCHTM - aka the operational base time).
 		 */
-		entry_point_delta = ns_to_sja1105_delta(tas_config->base_time);
+		rbt = future_base_time(tas_config->base_time,
+				       tas_config->cycle_time,
+				       tas_data->earliest_base_time);
+		rbt -= tas_data->earliest_base_time;
+		/* UM10944.pdf 4.2.2. Schedule Entry Points table says that
+		 * delta cannot be zero, which is shitty. Advance all relative
+		 * base times by 1 TAS cycle, so that even the earliest base
+		 * time becomes 1 in relative terms. Then start the operational
+		 * base time (PTPSCHTM) one TAS cycle earlier than planned.
+		 */
+		entry_point_delta = ns_to_sja1105_delta(rbt) + 1;
 
 		schedule_entry_points[cycle].subschindx = cycle;
 		schedule_entry_points[cycle].delta = entry_point_delta;
@@ -429,9 +538,303 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int sja1105_tas_check_running(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_ptp_cmd cmd = {0};
+	int rc;
+
+	rc = sja1105_ptp_commit(priv, &cmd, SPI_READ);
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
+	u64 ptpclkcorp = ns_to_sja1105_ticks(correction);
+
+	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkcorp,
+				    &ptpclkcorp, 4, NULL);
+}
+
+/* Write to PTPSCHTM */
+static int sja1105_tas_set_base_time(struct sja1105_private *priv,
+				     u64 base_time)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u64 ptpschtm = ns_to_sja1105_ticks(base_time);
+
+	return sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpschtm,
+				    &ptpschtm, 8, NULL);
+}
+
+static int sja1105_tas_start(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+	struct sja1105_ptp_cmd *cmd = &priv->ptp_data.cmd;
+	int rc;
+
+	dev_dbg(priv->ds->dev, "Starting the TAS\n");
+
+	if (tas_data->state == SJA1105_TAS_STATE_ENABLED_NOT_RUNNING ||
+	    tas_data->state == SJA1105_TAS_STATE_RUNNING) {
+		dev_err(priv->ds->dev, "TAS already started\n");
+		return -EINVAL;
+	}
+
+	cmd->ptpstrtsch = 1;
+	cmd->ptpstopsch = 0;
+
+	rc = sja1105_ptp_commit(priv, cmd, SPI_WRITE);
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
+	int rc;
+
+	dev_dbg(priv->ds->dev, "Stopping the TAS\n");
+
+	if (tas_data->state == SJA1105_TAS_STATE_DISABLED) {
+		dev_err(priv->ds->dev, "TAS already disabled\n");
+		return -EINVAL;
+	}
+
+	cmd->ptpstopsch = 1;
+	cmd->ptpstrtsch = 0;
+
+	rc = sja1105_ptp_commit(priv, cmd, SPI_WRITE);
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
+	struct sja1105_tas_data *tas_data = tas_work_to_sja1105_tas(work);
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
+
+		dev_dbg(ds->dev, "TAS state: disabled\n");
+		/* Can't do anything at all if clock is still being stepped */
+		if (tas_data->last_op != SJA1105_PTP_ADJUSTFREQ)
+			break;
+
+		rc = sja1105_tas_adjust_drift(priv, tas_data->max_cycle_time);
+		if (rc < 0)
+			break;
+
+		now = __sja1105_ptp_gettimex(priv, NULL);
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
+		/* Check if TAS has actually started, by comparing the
+		 * scheduled start time with the SJA1105 PTP clock
+		 */
+		dev_dbg(ds->dev, "TAS state: enabled but not running\n");
+
+		/* Clock was stepped.. bad news for TAS */
+		if (tas_data->last_op != SJA1105_PTP_ADJUSTFREQ) {
+			sja1105_tas_stop(priv);
+			break;
+		}
+
+		now = __sja1105_ptp_gettimex(priv, NULL);
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
+		if (tas_data->state == SJA1105_TAS_STATE_RUNNING)
+			/* TAS has started */
+			dev_dbg(ds->dev, "TAS state: transitioned to running\n");
+		else
+			dev_err(ds->dev, "TAS state: not started despite time elapsed\n");
+
+		break;
+
+	case SJA1105_TAS_STATE_RUNNING:
+		dev_dbg(ds->dev, "TAS state: running\n");
+
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
+		if (tas_data->state != SJA1105_TAS_STATE_RUNNING) {
+			dev_err(ds->dev, "TAS surprisingly stopped\n");
+			break;
+		}
+
+		now = __sja1105_ptp_gettimex(priv, NULL);
+
+		diff = ns_to_timespec64(now - tas_data->oper_base_time);
+
+		dev_dbg(ds->dev, "Time since TAS started: [%lld.%09ld]\n",
+			diff.tv_sec, diff.tv_nsec);
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
+void sja1105_tas_clockstep(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+
+	if (!tas_data->enabled)
+		return;
+
+	tas_data->last_op = SJA1105_PTP_CLOCKSTEP;
+	schedule_work(&tas_data->tas_work);
+}
+
+void sja1105_tas_adjfreq(struct sja1105_private *priv)
+{
+	struct sja1105_tas_data *tas_data = &priv->tas_data;
+
+	if (!tas_data->enabled)
+		return;
+
+	tas_data->last_op = SJA1105_PTP_ADJUSTFREQ;
+	schedule_work(&tas_data->tas_work);
+}
+
 void sja1105_tas_setup(struct sja1105_private *priv)
 {
 	INIT_WORK(&priv->tas_data.config_work, sja1105_tas_config_work);
+	INIT_WORK(&priv->tas_data.tas_work, sja1105_tas_state_machine);
+	priv->tas_data.state = SJA1105_TAS_STATE_DISABLED;
+	priv->tas_data.last_op = SJA1105_PTP_NONE;
 }
 
 void sja1105_tas_teardown(struct sja1105_private *priv)
@@ -440,6 +843,7 @@ void sja1105_tas_teardown(struct sja1105_private *priv)
 	int port;
 
 	cancel_work_sync(&tas_data->config_work);
+	cancel_work_sync(&tas_data->tas_work);
 
 	for (port = 0; port < SJA1105_NUM_PORTS; port++)
 		if (tas_data->config[port])
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index 1629492e20ab..942be6945058 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -8,9 +8,28 @@
 
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
 	struct tc_taprio_qopt_offload *config[SJA1105_NUM_PORTS];
 	struct work_struct config_work;
+	enum sja1105_tas_state state;
+	enum sja1105_ptp_op last_op;
+	struct work_struct tas_work;
+	s64 earliest_base_time;
+	s64 oper_base_time;
+	u64 max_cycle_time;
+	bool enabled;
 };
 
 void sja1105_tas_config_work(struct work_struct *work);
@@ -22,6 +41,10 @@ void sja1105_tas_setup(struct sja1105_private *priv);
 
 void sja1105_tas_teardown(struct sja1105_private *priv);
 
+void sja1105_tas_clockstep(struct sja1105_private *priv);
+
+void sja1105_tas_adjfreq(struct sja1105_private *priv);
+
 #else
 
 /* C doesn't allow empty structures, bah! */
@@ -42,6 +65,10 @@ static inline void sja1105_tas_setup(struct sja1105_private *priv) { }
 
 static inline void sja1105_tas_teardown(struct sja1105_private *priv) { }
 
+static inline void sja1105_tas_clockstep(struct sja1105_private *priv) { }
+
+static inline void sja1105_tas_adjfreq(struct sja1105_private *priv) { }
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_TAS) */
 
 #endif /* _SJA1105_TAS_H */
-- 
2.17.1

