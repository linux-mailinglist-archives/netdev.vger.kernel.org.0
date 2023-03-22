Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6331C6C4D9C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjCVO1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjCVO1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:27:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB985FEAE;
        Wed, 22 Mar 2023 07:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679495242; x=1711031242;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1ziEFRtGV0V5UoqLClzya6tGpzKrLUw0UJ3qscuxhis=;
  b=Z4Pdu2ZgxZm5SsI/7QVvpADoY0dhWH61I8E7StdWh6qUXF4FgneHU8B9
   Vjm6GGruILAyZnW2Cta/+ReKH7imASjOR87aGnTRgcjqvx5GG7KW2f6s6
   xwsRnXt1l3wu6M63FaQmyWBblNlhRMLlSx/QiDZI3wbK1QdqbBJVq5qzr
   eeVCcfrUw12LektpzpPsPpAhesUy/cXhlB1MAcNVaiU8TnWyDZQQd6Cnr
   wEwnPDfRP5FnqRYDU3X8iKoDQXLqmqPpoCWgvWr4hftg3jtZpNHw5lX6L
   RngdHZpGMM/1MCY02E0XDXTI00JmcljfJuwzGwSEPjP4B+OrHs8L5xd/L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="323069476"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="323069476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 07:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="632010172"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="632010172"
Received: from unknown (HELO fedora.sh.intel.com) ([10.238.175.104])
  by orsmga003.jf.intel.com with ESMTP; 22 Mar 2023 07:27:15 -0700
From:   Tianfei Zhang <tianfei.zhang@intel.com>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com, nico@fluxnic.net,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Date:   Wed, 22 Mar 2023 10:35:47 -0400
Message-Id: <20230322143547.233250-1-tianfei.zhang@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a DFL (Device Feature List) device driver of ToD device for
Intel FPGA cards.

The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
the system clock to its ToD information using phc2sys utility of the
Linux PTP stack. The DFL is a hardware List within FPGA, which defines
a linked list of feature headers within the device MMIO space to provide
an extensible way of adding subdevice features.

Signed-off-by: Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>

---
v2:
- handle NULL for ptp_clock_register().
- use readl_poll_timeout_atomic() instead of readl_poll_timeout(), and
  change the interval timeout to 10us.
- fix the uninitialized variable.
---
 MAINTAINERS               |   7 +
 drivers/ptp/Kconfig       |  13 ++
 drivers/ptp/Makefile      |   1 +
 drivers/ptp/ptp_dfl_tod.c | 333 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 354 insertions(+)
 create mode 100644 drivers/ptp/ptp_dfl_tod.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d8ebab595b2a..3fd603369464 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15623,6 +15623,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/ptp/ptp_ocp.c
 
+INTEL PTP DFL ToD DRIVER
+M:	Tianfei Zhang <tianfei.zhang@intel.com>
+L:	linux-fpga@vger.kernel.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/ptp/ptp_dfl_tod.c
+
 OPENCORES I2C BUS DRIVER
 M:	Peter Korsgaard <peter@korsgaard.com>
 M:	Andrew Lunn <andrew@lunn.ch>
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index fe4971b65c64..e0d6f136ee46 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -186,4 +186,17 @@ config PTP_1588_CLOCK_OCP
 
 	  More information is available at http://www.timingcard.com/
 
+config PTP_DFL_TOD
+	tristate "FPGA DFL ToD Driver"
+	depends on FPGA_DFL
+	help
+	  The DFL (Device Feature List) device driver for the Intel ToD
+	  (Time-of-Day) device in FPGA card. The ToD IP within the FPGA
+	  is exposed as PTP Hardware Clock (PHC) device to the Linux PTP
+	  stack to synchronize the system clock to its ToD information
+	  using phc2sys utility of the Linux PTP stack.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_dfl_tod.
+
 endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 28a6fe342d3e..553f18bf3c83 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
 obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+= ptp_vmw.o
 obj-$(CONFIG_PTP_1588_CLOCK_OCP)	+= ptp_ocp.o
+obj-$(CONFIG_PTP_DFL_TOD)		+= ptp_dfl_tod.o
diff --git a/drivers/ptp/ptp_dfl_tod.c b/drivers/ptp/ptp_dfl_tod.c
new file mode 100644
index 000000000000..d1532778c6b7
--- /dev/null
+++ b/drivers/ptp/ptp_dfl_tod.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DFL device driver for Time-of-Day (ToD) private feature
+ *
+ * Copyright (C) 2023 Intel Corporation
+ */
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/dfl.h>
+#include <linux/gcd.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/spinlock.h>
+#include <linux/units.h>
+
+#define FME_FEATURE_ID_TOD		0x22
+
+/* ToD clock register space. */
+#define TOD_CLK_FREQ			0x038
+
+/*
+ * The read sequence of ToD timestamp registers: TOD_NANOSEC, TOD_SECONDSL and
+ * TOD_SECONDSH, because there is a hardware snapshot whenever the TOD_NANOSEC
+ * register is read.
+ *
+ * The ToD IP requires writing registers in the reverse order to the read sequence.
+ * The timestamp is corrected when the TOD_NANOSEC register is written, so the
+ * sequence of write TOD registers: TOD_SECONDSH, TOD_SECONDSL and TOD_NANOSEC.
+ */
+#define TOD_SECONDSH			0x100
+#define TOD_SECONDSL			0x104
+#define TOD_NANOSEC			0x108
+#define TOD_PERIOD			0x110
+#define TOD_ADJUST_PERIOD		0x114
+#define TOD_ADJUST_COUNT		0x118
+#define TOD_DRIFT_ADJUST		0x11c
+#define TOD_DRIFT_ADJUST_RATE		0x120
+#define PERIOD_FRAC_OFFSET		16
+#define SECONDS_MSB			GENMASK_ULL(47, 32)
+#define SECONDS_LSB			GENMASK_ULL(31, 0)
+#define TOD_SECONDSH_SEC_MSB		GENMASK_ULL(15, 0)
+
+#define CAL_SECONDS(m, l)		((FIELD_GET(TOD_SECONDSH_SEC_MSB, (m)) << 32) | (l))
+
+#define TOD_PERIOD_MASK		GENMASK_ULL(19, 0)
+#define TOD_PERIOD_MAX			FIELD_MAX(TOD_PERIOD_MASK)
+#define TOD_PERIOD_MIN			0
+#define TOD_DRIFT_ADJUST_MASK		GENMASK_ULL(15, 0)
+#define TOD_DRIFT_ADJUST_FNS_MAX	FIELD_MAX(TOD_DRIFT_ADJUST_MASK)
+#define TOD_DRIFT_ADJUST_RATE_MAX	TOD_DRIFT_ADJUST_FNS_MAX
+#define TOD_ADJUST_COUNT_MASK		GENMASK_ULL(19, 0)
+#define TOD_ADJUST_COUNT_MAX		FIELD_MAX(TOD_ADJUST_COUNT_MASK)
+#define TOD_ADJUST_INTERVAL_US		10
+#define TOD_ADJUST_MS			\
+		(((TOD_PERIOD_MAX >> 16) + 1) * (TOD_ADJUST_COUNT_MAX + 1))
+#define TOD_ADJUST_MS_MAX		(TOD_ADJUST_MS / MICRO)
+#define TOD_ADJUST_MAX_US		(TOD_ADJUST_MS_MAX * USEC_PER_MSEC)
+#define TOD_MAX_ADJ			(500 * MEGA)
+
+struct dfl_tod {
+	struct ptp_clock_info ptp_clock_ops;
+	struct device *dev;
+	struct ptp_clock *ptp_clock;
+
+	/* ToD Clock address space */
+	void __iomem *tod_ctrl;
+
+	/* ToD clock registers protection */
+	spinlock_t tod_lock;
+};
+
+/*
+ * A fine ToD HW clock offset adjustment. To perform the fine offset adjustment, the
+ * adjust_period and adjust_count argument are used to update the TOD_ADJUST_PERIOD
+ * and TOD_ADJUST_COUNT register for in hardware. The dt->tod_lock spinlock must be
+ * held when calling this function.
+ */
+static int fine_adjust_tod_clock(struct dfl_tod *dt, u32 adjust_period,
+				 u32 adjust_count)
+{
+	void __iomem *base = dt->tod_ctrl;
+	u32 val;
+
+	writel(adjust_period, base + TOD_ADJUST_PERIOD);
+	writel(adjust_count, base + TOD_ADJUST_COUNT);
+
+	/* Wait for present offset adjustment update to complete */
+	return readl_poll_timeout_atomic(base + TOD_ADJUST_COUNT, val, !val, TOD_ADJUST_INTERVAL_US,
+				  TOD_ADJUST_MAX_US);
+}
+
+/*
+ * A coarse ToD HW clock offset adjustment.
+ * The coarse time adjustment performs by adding or subtracting the delta value
+ * from the current ToD HW clock time.
+ */
+static int coarse_adjust_tod_clock(struct dfl_tod *dt, s64 delta)
+{
+	u32 seconds_msb, seconds_lsb, nanosec;
+	void __iomem *base = dt->tod_ctrl;
+	u64 seconds, now;
+
+	if (delta == 0)
+		return 0;
+
+	nanosec = readl(base + TOD_NANOSEC);
+	seconds_lsb = readl(base + TOD_SECONDSL);
+	seconds_msb = readl(base + TOD_SECONDSH);
+
+	/* Calculate new time */
+	seconds = CAL_SECONDS(seconds_msb, seconds_lsb);
+	now = seconds * NSEC_PER_SEC + nanosec + delta;
+
+	seconds = div_u64_rem(now, NSEC_PER_SEC, &nanosec);
+	seconds_msb = FIELD_GET(SECONDS_MSB, seconds);
+	seconds_lsb = FIELD_GET(SECONDS_LSB, seconds);
+
+	writel(seconds_msb, base + TOD_SECONDSH);
+	writel(seconds_lsb, base + TOD_SECONDSL);
+	writel(nanosec, base + TOD_NANOSEC);
+
+	return 0;
+}
+
+static int dfl_tod_adjust_fine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
+	u32 tod_period, tod_rem, tod_drift_adjust_fns, tod_drift_adjust_rate;
+	void __iomem *base = dt->tod_ctrl;
+	unsigned long flags, rate;
+	u64 ppb;
+
+	/* Get the clock rate from clock frequency register offset */
+	rate = readl(base + TOD_CLK_FREQ);
+
+	/* add GIGA as nominal ppb */
+	ppb = scaled_ppm_to_ppb(scaled_ppm) + GIGA;
+
+	tod_period = div_u64_rem(ppb << PERIOD_FRAC_OFFSET, rate, &tod_rem);
+	if (tod_period > TOD_PERIOD_MAX)
+		return -ERANGE;
+
+	/*
+	 * The drift of ToD adjusted periodically by adding a drift_adjust_fns
+	 * correction value every drift_adjust_rate count of clock cycles.
+	 */
+	tod_drift_adjust_fns = tod_rem / gcd(tod_rem, rate);
+	tod_drift_adjust_rate = rate / gcd(tod_rem, rate);
+
+	while ((tod_drift_adjust_fns > TOD_DRIFT_ADJUST_FNS_MAX) ||
+	       (tod_drift_adjust_rate > TOD_DRIFT_ADJUST_RATE_MAX)) {
+		tod_drift_adjust_fns >>= 1;
+		tod_drift_adjust_rate >>= 1;
+	}
+
+	if (tod_drift_adjust_fns == 0)
+		tod_drift_adjust_rate = 0;
+
+	spin_lock_irqsave(&dt->tod_lock, flags);
+	writel(tod_period, base + TOD_PERIOD);
+	writel(0, base + TOD_ADJUST_PERIOD);
+	writel(0, base + TOD_ADJUST_COUNT);
+	writel(tod_drift_adjust_fns, base + TOD_DRIFT_ADJUST);
+	writel(tod_drift_adjust_rate, base + TOD_DRIFT_ADJUST_RATE);
+	spin_unlock_irqrestore(&dt->tod_lock, flags);
+
+	return 0;
+}
+
+static int dfl_tod_adjust_time(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
+	u32 period, diff, rem, rem_period, adj_period;
+	void __iomem *base = dt->tod_ctrl;
+	unsigned long flags;
+	bool neg_adj;
+	u64 count;
+	int ret;
+
+	neg_adj = delta < 0;
+	if (neg_adj)
+		delta = -delta;
+
+	spin_lock_irqsave(&dt->tod_lock, flags);
+
+	/*
+	 * Get the maximum possible value of the Period register offset
+	 * adjustment in nanoseconds scale. This depends on the current
+	 * Period register setting and the maximum and minimum possible
+	 * values of the Period register.
+	 */
+	period = readl(base + TOD_PERIOD);
+
+	if (neg_adj) {
+		diff = (period - TOD_PERIOD_MIN) >> PERIOD_FRAC_OFFSET;
+		adj_period = period - (diff << PERIOD_FRAC_OFFSET);
+		count = div_u64_rem(delta, diff, &rem);
+		rem_period = period - (rem << PERIOD_FRAC_OFFSET);
+	} else {
+		diff = (TOD_PERIOD_MAX - period) >> PERIOD_FRAC_OFFSET;
+		adj_period = period + (diff << PERIOD_FRAC_OFFSET);
+		count = div_u64_rem(delta, diff, &rem);
+		rem_period = period + (rem << PERIOD_FRAC_OFFSET);
+	}
+
+	ret = 0;
+
+	if (count > TOD_ADJUST_COUNT_MAX) {
+		ret = coarse_adjust_tod_clock(dt, delta);
+	} else {
+		/* Adjust the period by count cycles to adjust the time */
+		if (count)
+			ret = fine_adjust_tod_clock(dt, adj_period, count);
+
+		/* If there is a remainder, adjust the period for an additional cycle */
+		if (rem)
+			ret = fine_adjust_tod_clock(dt, rem_period, 1);
+	}
+
+	spin_unlock_irqrestore(&dt->tod_lock, flags);
+
+	return ret;
+}
+
+static int dfl_tod_get_timex(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			     struct ptp_system_timestamp *sts)
+{
+	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
+	u32 seconds_msb, seconds_lsb, nanosec;
+	void __iomem *base = dt->tod_ctrl;
+	unsigned long flags;
+	u64 seconds;
+
+	spin_lock_irqsave(&dt->tod_lock, flags);
+	ptp_read_system_prets(sts);
+	nanosec = readl(base + TOD_NANOSEC);
+	seconds_lsb = readl(base + TOD_SECONDSL);
+	seconds_msb = readl(base + TOD_SECONDSH);
+	ptp_read_system_postts(sts);
+	spin_unlock_irqrestore(&dt->tod_lock, flags);
+
+	seconds = CAL_SECONDS(seconds_msb, seconds_lsb);
+
+	ts->tv_nsec = nanosec;
+	ts->tv_sec = seconds;
+
+	return 0;
+}
+
+static int dfl_tod_set_time(struct ptp_clock_info *ptp,
+			    const struct timespec64 *ts)
+{
+	struct dfl_tod *dt = container_of(ptp, struct dfl_tod, ptp_clock_ops);
+	u32 seconds_msb = FIELD_GET(SECONDS_MSB, ts->tv_sec);
+	u32 seconds_lsb = FIELD_GET(SECONDS_LSB, ts->tv_sec);
+	u32 nanosec = FIELD_GET(SECONDS_LSB, ts->tv_nsec);
+	void __iomem *base = dt->tod_ctrl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dt->tod_lock, flags);
+	writel(seconds_msb, base + TOD_SECONDSH);
+	writel(seconds_lsb, base + TOD_SECONDSL);
+	writel(nanosec, base + TOD_NANOSEC);
+	spin_unlock_irqrestore(&dt->tod_lock, flags);
+
+	return 0;
+}
+
+static struct ptp_clock_info dfl_tod_clock_ops = {
+	.owner = THIS_MODULE,
+	.name = "dfl_tod",
+	.max_adj = TOD_MAX_ADJ,
+	.adjfine = dfl_tod_adjust_fine,
+	.adjtime = dfl_tod_adjust_time,
+	.gettimex64 = dfl_tod_get_timex,
+	.settime64 = dfl_tod_set_time,
+};
+
+static int dfl_tod_probe(struct dfl_device *ddev)
+{
+	struct device *dev = &ddev->dev;
+	struct dfl_tod *dt;
+
+	dt = devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);
+	if (!dt)
+		return -ENOMEM;
+
+	dt->tod_ctrl = devm_ioremap_resource(dev, &ddev->mmio_res);
+	if (IS_ERR(dt->tod_ctrl))
+		return PTR_ERR(dt->tod_ctrl);
+
+	dt->dev = dev;
+	spin_lock_init(&dt->tod_lock);
+	dev_set_drvdata(dev, dt);
+
+	dt->ptp_clock_ops = dfl_tod_clock_ops;
+
+	dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);
+	if (IS_ERR_OR_NULL(dt->ptp_clock))
+		return dev_err_probe(dt->dev, PTR_ERR_OR_ZERO(dt->ptp_clock),
+				     "Unable to register PTP clock\n");
+
+	return 0;
+}
+
+static void dfl_tod_remove(struct dfl_device *ddev)
+{
+	struct dfl_tod *dt = dev_get_drvdata(&ddev->dev);
+
+	ptp_clock_unregister(dt->ptp_clock);
+}
+
+static const struct dfl_device_id dfl_tod_ids[] = {
+	{ FME_ID, FME_FEATURE_ID_TOD },
+	{ }
+};
+MODULE_DEVICE_TABLE(dfl, dfl_tod_ids);
+
+static struct dfl_driver dfl_tod_driver = {
+	.drv = {
+		.name = "dfl-tod",
+	},
+	.id_table = dfl_tod_ids,
+	.probe = dfl_tod_probe,
+	.remove = dfl_tod_remove,
+};
+module_dfl_driver(dfl_tod_driver);
+
+MODULE_DESCRIPTION("FPGA DFL ToD driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL");
-- 
2.38.1

