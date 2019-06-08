Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F9839F88
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfFHMGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:06:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52055 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfFHMFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id f10so4442421wmb.1;
        Sat, 08 Jun 2019 05:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mrLCHUkxoq0vdypdq8oSgKuhkVA6dSGlWFRz5G1x+S0=;
        b=hd195ePouD8lgo0MA9intXCsJM5Sn2C/InmmLk6BkYTqYZzOKc8PXGgJVdZtb2hcAg
         dX2BppsE1xsm/Xv1/boHSxV8NIFvpoeEq0cajaYAK7o7wZcbYGyULxnRwzLgjBfB00nz
         cEz+UWXhao7wo3aq4gLuODrZfSttWtCsgq+DxQcUVGh835+YgC4TXf5BJwf8MtXyTYZu
         E6Vk7FthGuynVLPkpFVMrZk8nyZVCsbpFIJllfY5Sby/V4bLR4hHShqDMPlKozZ/2c64
         1FUSiRoeExzXaL+t6gZAkATyysRELYOGxuIR2chTC2bTGj/y8JaUBDIt6EueILFiS67y
         W1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mrLCHUkxoq0vdypdq8oSgKuhkVA6dSGlWFRz5G1x+S0=;
        b=rLKwkwmUxNyUmgyrL+EtegA6eCwkaohTXqUnUX36yjiW21TT9st0/nJj3AylO0pu6X
         VouG2p+LKvLfezTWSkuQY4S7PCm3qnbbKuXFyyapBm31TOW9wYo4/aOuW+pHWKZr2JjM
         YPEmfXaGvq0B4bnXlV2ZDl50ZQdKBmOiyk1pGbcVLoVAqoEaHJWbG+X1Tfq8xNgRk6KF
         o7pLHP/WQ48+/A8CT1G/kdEr/ne9jlI3NBdtsnsRV4SuTLsnqOyGVDBerfbqLqCqJvzC
         c9WamwDj1xLr3Kah+pq8UDjBp1qd1W0UXmVrxNGxBAZ967WVQyTl2L8OrNrkFIlnLGkW
         QpbA==
X-Gm-Message-State: APjAAAUcW5SuY2+r1Q/CPipunsvpzQ28T2PEDisLh+7TIM+g27Q1LZr7
        xvfatgWYQdF7uaOA+NW/UPg=
X-Google-Smtp-Source: APXvYqzqsuFV2hhligDoyMfbvzNuTxAKq10hLIoGQEeO65A9YyBVmhmZn2AA7tsJFy2Zo6mqqzHwKg==
X-Received: by 2002:a7b:cc81:: with SMTP id p1mr6661443wma.107.1559995543903;
        Sat, 08 Jun 2019 05:05:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 08/17] net: dsa: sja1105: Add support for the PTP clock
Date:   Sat,  8 Jun 2019 15:04:34 +0300
Message-Id: <20190608120443.21889-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The design of this PHC driver is influenced by the switch's behavior
w.r.t. timestamping.  It exposes two PTP counters, one free-running
(PTPTSCLK) and the other offset- and frequency-corrected in hardware
through PTPCLKVAL, PTPCLKADD and PTPCLKRATE.  The MACs can sample either
of these for frame timestamps.

However, the user manual warns that taking timestamps based on the
corrected clock is less than useful, as the switch can deliver corrupted
timestamps in a variety of circumstances.

Therefore, this PHC uses the free-running PTPTSCLK together with a
timecounter/cyclecounter structure that translates it into a software
time domain.  Thus, the settime/adjtime and adjfine callbacks are
hardware no-ops.

The timestamps (introduced in a further patch) will also be translated
to the correct time domain before being handed over to the userspace PTP
stack.

The introduction of a second set of PHC operations that operate on the
hardware PTPCLKVAL/PTPCLKADD/PTPCLKRATE in the future is somewhat
unavoidable, as the TTEthernet core uses the corrected PTP time domain.
However, the free-running counter + timecounter structure combination
will suffice for now, as the resulting timestamps yield a sub-50 ns
synchronization offset in steady state using linuxptp.

For this patch, in absence of frame timestamping, the operations of the
switch PHC were tested by syncing it to the system time as a local slave
clock with:

phc2sys -s CLOCK_REALTIME -c swp2 -O 0 -m -S 0.01

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

Added a bunch of EXPORT_SYMBOL_GPL.

Changes in v3:

None.

Changes in v2:

Now resetting the PTP clock each time the switch core itself gets reset.

 drivers/net/dsa/sja1105/Kconfig        |   7 +
 drivers/net/dsa/sja1105/Makefile       |   1 +
 drivers/net/dsa/sja1105/sja1105.h      |  18 ++
 drivers/net/dsa/sja1105/sja1105_main.c |   7 +
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 296 +++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  47 ++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  19 ++
 7 files changed, 395 insertions(+)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.h

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 1144fc5f61a8..049cea8240e4 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -16,3 +16,10 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1105Q (Gen. 2, No SGMII, TT-Ethernet)
 	    - SJA1105R (Gen. 2, SGMII, No TT-Ethernet)
 	    - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
+
+config NET_DSA_SJA1105_PTP
+tristate "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
+	depends on NET_DSA_SJA1105
+	help
+	  This enables support for timestamping and PTP clock manipulations in
+	  the SJA1105 DSA driver.
diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 941848de8b46..946eea7d8480 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_SJA1105) += sja1105.o
+obj-$(CONFIG_NET_DSA_SJA1105_PTP) += sja1105_ptp.o
 
 sja1105-objs := \
     sja1105_spi.o \
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 61d00682de60..3c6296203c21 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -5,6 +5,8 @@
 #ifndef _SJA1105_H
 #define _SJA1105_H
 
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
 #include <linux/dsa/sja1105.h>
 #include <net/dsa.h>
 #include <linux/mutex.h>
@@ -27,6 +29,10 @@ struct sja1105_regs {
 	u64 rgu;
 	u64 config;
 	u64 rmii_pll1;
+	u64 ptp_control;
+	u64 ptpclk;
+	u64 ptpclkrate;
+	u64 ptptsclk;
 	u64 pad_mii_tx[SJA1105_NUM_PORTS];
 	u64 cgu_idiv[SJA1105_NUM_PORTS];
 	u64 rgmii_pad_mii_tx[SJA1105_NUM_PORTS];
@@ -53,6 +59,7 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
+	int (*ptp_cmd)(const void *ctx, const void *data);
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
@@ -72,6 +79,16 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	struct ptp_clock_info ptp_caps;
+	struct ptp_clock *clock;
+	/* The cycle counter translates the PTP timestamps (based on
+	 * a free-running counter) into a software time domain.
+	 */
+	struct cyclecounter tstamp_cc;
+	struct timecounter tstamp_tc;
+	struct delayed_work refresh_work;
+	/* Serializes all operations on the cycle counter */
+	struct mutex ptp_lock;
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
@@ -79,6 +96,7 @@ struct sja1105_private {
 };
 
 #include "sja1105_dynamic_config.h"
+#include "sja1105_ptp.h"
 
 struct sja1105_spi_message {
 	u64 access;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ea854ea903d1..f897fdb12930 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1530,6 +1530,11 @@ static int sja1105_setup(struct dsa_switch *ds)
 		return rc;
 	}
 
+	rc = sja1105_ptp_clock_register(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to register PTP clock: %d\n", rc);
+		return rc;
+	}
 	/* Create and send configuration down to device */
 	rc = sja1105_static_config_load(priv, ports);
 	if (rc < 0) {
@@ -1681,6 +1686,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
+	.get_ts_info		= sja1105_get_ts_info,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
@@ -1805,6 +1811,7 @@ static int sja1105_remove(struct spi_device *spi)
 {
 	struct sja1105_private *priv = spi_get_drvdata(spi);
 
+	sja1105_ptp_clock_unregister(priv);
 	dsa_unregister_switch(priv->ds);
 	sja1105_static_config_free(&priv->static_config);
 	return 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
new file mode 100644
index 000000000000..47313a6ec932
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -0,0 +1,296 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include "sja1105.h"
+
+/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
+ * therefore scaled_ppm between [-2,147,483,648, 2,147,483,647].
+ * Set the maximum supported ppb to a round value smaller than the maximum.
+ *
+ * Percentually speaking, this is a +/- 0.032x adjustment of the
+ * free-running counter (0.968x to 1.032x).
+ */
+#define SJA1105_MAX_ADJ_PPB		32000000
+#define SJA1105_SIZE_PTP_CMD		4
+
+/* Timestamps are in units of 8 ns clock ticks (equivalent to a fixed
+ * 125 MHz clock) so the scale factor (MULT / SHIFT) needs to be 8.
+ * Furthermore, wisely pick SHIFT as 28 bits, which translates
+ * MULT into 2^31 (0x80000000).  This is the same value around which
+ * the hardware PTPCLKRATE is centered, so the same ppb conversion
+ * arithmetic can be reused.
+ */
+#define SJA1105_CC_SHIFT		28
+#define SJA1105_CC_MULT			(8 << SJA1105_CC_SHIFT)
+
+/* Having 33 bits of cycle counter left until a 64-bit overflow during delta
+ * conversion, we multiply this by the 8 ns counter resolution and arrive at
+ * a comfortable 68.71 second refresh interval until the delta would cause
+ * an integer overflow, in absence of any other readout.
+ * Approximate to 1 minute.
+ */
+#define SJA1105_REFRESH_INTERVAL	(HZ * 60)
+
+/*            This range is actually +/- SJA1105_MAX_ADJ_PPB
+ *            divided by 1000 (ppb -> ppm) and with a 16-bit
+ *            "fractional" part (actually fixed point).
+ *                                    |
+ *                                    v
+ * Convert scaled_ppm from the +/- ((10^6) << 16) range
+ * into the +/- (1 << 31) range.
+ *
+ * This forgoes a "ppb" numeric representation (up to NSEC_PER_SEC)
+ * and defines the scaling factor between scaled_ppm and the actual
+ * frequency adjustments (both cycle counter and hardware).
+ *
+ *   ptpclkrate = scaled_ppm * 2^31 / (10^6 * 2^16)
+ *   simplifies to
+ *   ptpclkrate = scaled_ppm * 2^9 / 5^6
+ */
+#define SJA1105_CC_MULT_NUM		(1 << 9)
+#define SJA1105_CC_MULT_DEM		15625
+
+#define ptp_to_sja1105(d) container_of((d), struct sja1105_private, ptp_caps)
+#define cc_to_sja1105(d) container_of((d), struct sja1105_private, tstamp_cc)
+#define dw_to_sja1105(d) container_of((d), struct sja1105_private, refresh_work)
+
+struct sja1105_ptp_cmd {
+	u64 resptp;       /* reset */
+};
+
+int sja1105_get_ts_info(struct dsa_switch *ds, int port,
+			struct ethtool_ts_info *info)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	/* Called during cleanup */
+	if (!priv->clock)
+		return -ENODEV;
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = (1 << HWTSTAMP_TX_OFF);
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
+	info->phc_index = ptp_clock_index(priv->clock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sja1105_get_ts_info);
+
+int sja1105et_ptp_cmd(const void *ctx, const void *data)
+{
+	const struct sja1105_ptp_cmd *cmd = data;
+	const struct sja1105_private *priv = ctx;
+	const struct sja1105_regs *regs = priv->info->regs;
+	const int size = SJA1105_SIZE_PTP_CMD;
+	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
+	/* No need to keep this as part of the structure */
+	u64 valid = 1;
+
+	sja1105_pack(buf, &valid,           31, 31, size);
+	sja1105_pack(buf, &cmd->resptp,      2,  2, size);
+
+	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
+					   buf, SJA1105_SIZE_PTP_CMD);
+}
+EXPORT_SYMBOL_GPL(sja1105et_ptp_cmd);
+
+int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
+{
+	const struct sja1105_ptp_cmd *cmd = data;
+	const struct sja1105_private *priv = ctx;
+	const struct sja1105_regs *regs = priv->info->regs;
+	const int size = SJA1105_SIZE_PTP_CMD;
+	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
+	/* No need to keep this as part of the structure */
+	u64 valid = 1;
+
+	sja1105_pack(buf, &valid,           31, 31, size);
+	sja1105_pack(buf, &cmd->resptp,      3,  3, size);
+
+	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
+					   buf, SJA1105_SIZE_PTP_CMD);
+}
+EXPORT_SYMBOL_GPL(sja1105pqrs_ptp_cmd);
+
+int sja1105_ptp_reset(struct sja1105_private *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	struct sja1105_ptp_cmd cmd = {0};
+	int rc;
+
+	mutex_lock(&priv->ptp_lock);
+
+	cmd.resptp = 1;
+	dev_dbg(ds->dev, "Resetting PTP clock\n");
+	rc = priv->info->ptp_cmd(priv, &cmd);
+
+	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc,
+			 ktime_to_ns(ktime_get_real()));
+
+	mutex_unlock(&priv->ptp_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sja1105_ptp_reset);
+
+static int sja1105_ptp_gettime(struct ptp_clock_info *ptp,
+			       struct timespec64 *ts)
+{
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	u64 ns;
+
+	mutex_lock(&priv->ptp_lock);
+	ns = timecounter_read(&priv->tstamp_tc);
+	mutex_unlock(&priv->ptp_lock);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int sja1105_ptp_settime(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	u64 ns = timespec64_to_ns(ts);
+
+	mutex_lock(&priv->ptp_lock);
+	timecounter_init(&priv->tstamp_tc, &priv->tstamp_cc, ns);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+	s64 clkrate;
+
+	clkrate = (s64)scaled_ppm * SJA1105_CC_MULT_NUM;
+	clkrate = div_s64(clkrate, SJA1105_CC_MULT_DEM);
+
+	mutex_lock(&priv->ptp_lock);
+
+	/* Force a readout to update the timer *before* changing its frequency.
+	 *
+	 * This way, its corrected time curve can at all times be modeled
+	 * as a linear "A * x + B" function, where:
+	 *
+	 * - B are past frequency adjustments and offset shifts, all
+	 *   accumulated into the cycle_last variable.
+	 *
+	 * - A is the new frequency adjustments we're just about to set.
+	 *
+	 * Reading now makes B accumulate the correct amount of time,
+	 * corrected at the old rate, before changing it.
+	 *
+	 * Hardware timestamps then become simple points on the curve and
+	 * are approximated using the above function.  This is still better
+	 * than letting the switch take the timestamps using the hardware
+	 * rate-corrected clock (PTPCLKVAL) - the comparison in this case would
+	 * be that we're shifting the ruler at the same time as we're taking
+	 * measurements with it.
+	 *
+	 * The disadvantage is that it's possible to receive timestamps when
+	 * a frequency adjustment took place in the near past.
+	 * In this case they will be approximated using the new ppb value
+	 * instead of a compound function made of two segments (one at the old
+	 * and the other at the new rate) - introducing some inaccuracy.
+	 */
+	timecounter_read(&priv->tstamp_tc);
+
+	priv->tstamp_cc.mult = SJA1105_CC_MULT + clkrate;
+
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct sja1105_private *priv = ptp_to_sja1105(ptp);
+
+	mutex_lock(&priv->ptp_lock);
+	timecounter_adjtime(&priv->tstamp_tc, delta);
+	mutex_unlock(&priv->ptp_lock);
+
+	return 0;
+}
+
+static u64 sja1105_ptptsclk_read(const struct cyclecounter *cc)
+{
+	struct sja1105_private *priv = cc_to_sja1105(cc);
+	const struct sja1105_regs *regs = priv->info->regs;
+	u64 ptptsclk = 0;
+	int rc;
+
+	rc = sja1105_spi_send_int(priv, SPI_READ, regs->ptptsclk,
+				  &ptptsclk, 8);
+	if (rc < 0)
+		dev_err_ratelimited(priv->ds->dev,
+				    "failed to read ptp cycle counter: %d\n",
+				    rc);
+	return ptptsclk;
+}
+
+static void sja1105_ptp_overflow_check(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct sja1105_private *priv = dw_to_sja1105(dw);
+	struct timespec64 ts;
+
+	sja1105_ptp_gettime(&priv->ptp_caps, &ts);
+
+	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+}
+
+static const struct ptp_clock_info sja1105_ptp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "SJA1105 PHC",
+	.adjfine	= sja1105_ptp_adjfine,
+	.adjtime	= sja1105_ptp_adjtime,
+	.gettime64	= sja1105_ptp_gettime,
+	.settime64	= sja1105_ptp_settime,
+	.max_adj	= SJA1105_MAX_ADJ_PPB,
+};
+
+int sja1105_ptp_clock_register(struct sja1105_private *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+
+	/* Set up the cycle counter */
+	priv->tstamp_cc = (struct cyclecounter) {
+		.read = sja1105_ptptsclk_read,
+		.mask = CYCLECOUNTER_MASK(64),
+		.shift = SJA1105_CC_SHIFT,
+		.mult = SJA1105_CC_MULT,
+	};
+	mutex_init(&priv->ptp_lock);
+	INIT_DELAYED_WORK(&priv->refresh_work, sja1105_ptp_overflow_check);
+
+	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
+
+	priv->ptp_caps = sja1105_ptp_caps;
+
+	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
+	if (IS_ERR_OR_NULL(priv->clock))
+		return PTR_ERR(priv->clock);
+
+	return sja1105_ptp_reset(priv);
+}
+EXPORT_SYMBOL_GPL(sja1105_ptp_clock_register);
+
+void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
+{
+	if (IS_ERR_OR_NULL(priv->clock))
+		return;
+
+	ptp_clock_unregister(priv->clock);
+	priv->clock = NULL;
+}
+EXPORT_SYMBOL_GPL(sja1105_ptp_clock_unregister);
+
+MODULE_AUTHOR("Vladimir Oltean <olteanv@gmail.com>");
+MODULE_DESCRIPTION("SJA1105 PHC Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
new file mode 100644
index 000000000000..137ffbb0a233
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#ifndef _SJA1105_PTP_H
+#define _SJA1105_PTP_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
+
+int sja1105_ptp_clock_register(struct sja1105_private *priv);
+
+void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
+
+int sja1105et_ptp_cmd(const void *ctx, const void *data);
+
+int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
+
+int sja1105_get_ts_info(struct dsa_switch *ds, int port,
+			struct ethtool_ts_info *ts);
+
+int sja1105_ptp_reset(struct sja1105_private *priv);
+
+#else
+
+static inline int sja1105_ptp_clock_register(struct sja1105_private *priv)
+{
+	return 0;
+}
+
+static inline void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
+{
+	return;
+}
+
+static inline int sja1105_ptp_reset(struct sja1105_private *priv)
+{
+	return 0;
+}
+
+#define sja1105et_ptp_cmd NULL
+
+#define sja1105pqrs_ptp_cmd NULL
+
+#define sja1105_get_ts_info NULL
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
+
+#endif /* _SJA1105_PTP_H */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 422894068c8b..a0d08e6c22ff 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -480,7 +480,12 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 		dev_info(dev, "Succeeded after %d tried\n", RETRIES - retries);
 	}
 
+	rc = sja1105_ptp_reset(priv);
+	if (rc < 0)
+		dev_err(dev, "Failed to reset PTP clock: %d\n", rc);
+
 	dev_info(dev, "Reset switch and programmed static config\n");
+
 out:
 	kfree(config_buf);
 	return rc;
@@ -509,6 +514,10 @@ static struct sja1105_regs sja1105et_regs = {
 	.rgmii_tx_clk = {0x100016, 0x10001D, 0x100024, 0x10002B, 0x100032},
 	.rmii_ref_clk = {0x100015, 0x10001C, 0x100023, 0x10002A, 0x100031},
 	.rmii_ext_tx_clk = {0x100018, 0x10001F, 0x100026, 0x10002D, 0x100034},
+	.ptp_control = 0x17,
+	.ptpclk = 0x18, /* Spans 0x18 to 0x19 */
+	.ptpclkrate = 0x1A,
+	.ptptsclk = 0x1B, /* Spans 0x1B to 0x1C */
 };
 
 static struct sja1105_regs sja1105pqrs_regs = {
@@ -535,6 +544,10 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rmii_ref_clk = {0x100015, 0x10001B, 0x100021, 0x100027, 0x10002D},
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
 	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
+	.ptp_control = 0x18,
+	.ptpclk = 0x19,
+	.ptpclkrate = 0x1B,
+	.ptptsclk = 0x1C,
 };
 
 struct sja1105_info sja1105e_info = {
@@ -545,6 +558,7 @@ struct sja1105_info sja1105e_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
+	.ptp_cmd		= sja1105et_ptp_cmd,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
@@ -556,6 +570,7 @@ struct sja1105_info sja1105t_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
+	.ptp_cmd		= sja1105et_ptp_cmd,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
@@ -567,6 +582,7 @@ struct sja1105_info sja1105p_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
@@ -578,6 +594,7 @@ struct sja1105_info sja1105q_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
@@ -589,6 +606,7 @@ struct sja1105_info sja1105r_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
@@ -601,5 +619,6 @@ struct sja1105_info sja1105s_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
+	.ptp_cmd		= sja1105pqrs_ptp_cmd,
 	.name			= "SJA1105S",
 };
-- 
2.17.1

