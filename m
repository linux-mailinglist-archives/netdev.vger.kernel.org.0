Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E396A2D5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbfGPHVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:21:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:56499 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfGPHVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:21:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:21:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796269"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:59 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 5/5] PTP: Add support for Intel PMC Timed GPIO Controller
Date:   Tue, 16 Jul 2019 10:20:38 +0300
Message-Id: <20190716072038.8408-6-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a driver supporting Intel Timed GPIO controller available as part
of some Intel PMCs.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/ptp/Kconfig               |   8 +
 drivers/ptp/Makefile              |   1 +
 drivers/ptp/ptp-intel-pmc-tgpio.c | 378 ++++++++++++++++++++++++++++++
 3 files changed, 387 insertions(+)
 create mode 100644 drivers/ptp/ptp-intel-pmc-tgpio.c

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 9b8fee5178e8..bb0fce70a783 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -107,6 +107,14 @@ config PTP_1588_CLOCK_PCH
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_pch.
 
+config PTP_INTEL_PMC_TGPIO
+	tristate "Intel PMC Timed GPIO"
+	depends on X86
+	depends on ACPI
+	imply PTP_1588_CLOCK
+	help
+	  This driver adds support for Intel PMC Timed GPIO Controller
+
 config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 677d1d178a3e..ff89c90ace82 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -7,6 +7,7 @@ ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
+obj-$(CONFIG_PTP_INTEL_PMC_TGPIO)	+= ptp-intel-pmc-tgpio.o
 obj-$(CONFIG_PTP_1588_CLOCK_PCH)	+= ptp_pch.o
 obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
diff --git a/drivers/ptp/ptp-intel-pmc-tgpio.c b/drivers/ptp/ptp-intel-pmc-tgpio.c
new file mode 100644
index 000000000000..880ece34868a
--- /dev/null
+++ b/drivers/ptp/ptp-intel-pmc-tgpio.c
@@ -0,0 +1,378 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Intel Timed GPIO Controller Driver
+ *
+ * Copyright (C) 2018 Intel Corporation
+ * Author: Felipe Balbi <felipe.balbi@linux.intel.com>
+ */
+
+#include <linux/acpi.h>
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/ptp_clock_kernel.h>
+#include <asm/tsc.h>
+
+#define TGPIOCTL		0x00
+#define TGPIOCOMPV31_0		0x10
+#define TGPIOCOMPV63_32		0x14
+#define TGPIOPIV31_0		0x18
+#define TGPIOPIV63_32		0x1c
+#define TGPIOTCV31_0		0x20
+#define TGPIOTCV63_32		0x24
+#define TGPIOECCV31_0		0x28
+#define TGPIOECCV63_32		0x2c
+#define TGPIOEC31_0		0x30
+#define TGPIOEC63_32		0x34
+
+/* Control Register */
+#define TGPIOCTL_EN		BIT(0)
+#define TGPIOCTL_DIR		BIT(1)
+#define TGPIOCTL_EP		GENMASK(3, 2)
+#define TGPIOCTL_EP_RISING_EDGE	(0 << 2)
+#define TGPIOCTL_EP_FALLING_EDGE (1 << 2)
+#define TGPIOCTL_EP_TOGGLE_EDGE	(2 << 2)
+#define TGPIOCTL_PM		BIT(4)
+
+#define NSECS_PER_SEC		1000000000
+#define TGPIO_MAX_ADJ_TIME	999999900
+
+struct intel_pmc_tgpio {
+	struct ptp_clock_info	info;
+	struct ptp_clock	*clock;
+
+	struct mutex		lock;
+	struct device		*dev;
+	void __iomem		*base;
+
+	struct task_struct	*event_thread;
+	bool			input;
+};
+#define to_intel_pmc_tgpio(i)	(container_of((i), struct intel_pmc_tgpio, info))
+
+static inline u64 to_intel_pmc_tgpio_time(struct ptp_clock_time *t)
+{
+	return t->sec * NSECS_PER_SEC + t->nsec;
+}
+
+static inline u64 intel_pmc_tgpio_readq(void __iomem *base, u32 offset)
+{
+	return lo_hi_readq(base + offset);
+}
+
+static inline void intel_pmc_tgpio_writeq(void __iomem *base, u32 offset, u64 v)
+{
+	return lo_hi_writeq(v, base + offset);
+}
+
+static inline u32 intel_pmc_tgpio_readl(void __iomem *base, u32 offset)
+{
+	return readl(base + offset);
+}
+
+static inline void intel_pmc_tgpio_writel(void __iomem *base, u32 offset, u32 value)
+{
+	writel(value, base + offset);
+}
+
+static struct ptp_pin_desc intel_pmc_tgpio_pin_config[] = {
+	{					\
+		.name	= "pin0",		\
+		.index	= 0,			\
+		.func	= PTP_PF_NONE,		\
+		.chan	= 0,			\
+	}
+};
+
+static int intel_pmc_tgpio_gettime64(struct ptp_clock_info *info,
+		struct timespec64 *ts)
+{
+	struct intel_pmc_tgpio	*tgpio = to_intel_pmc_tgpio(info);
+	u64 now;
+
+	mutex_lock(&tgpio->lock);
+	now = get_art_ns_now();
+	*ts = ns_to_timespec64(now);
+	mutex_unlock(&tgpio->lock);
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_settime64(struct ptp_clock_info *info,
+		const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
+static int intel_pmc_tgpio_event_thread(void *_tgpio)
+{
+	struct intel_pmc_tgpio	*tgpio = _tgpio;
+	u64 reg;
+
+	while (!kthread_should_stop()) {
+		bool input;
+		int i;
+
+		mutex_lock(&tgpio->lock);
+		input = tgpio->input;
+		mutex_unlock(&tgpio->lock);
+
+		if (!input)
+			schedule();
+
+		reg = intel_pmc_tgpio_readq(tgpio->base, TGPIOEC31_0);
+
+		for (i = 0; i < reg; i++) {
+			struct ptp_clock_event event;
+
+			event.type = PTP_CLOCK_EXTTS;
+			event.index = 0;
+			event.timestamp = intel_pmc_tgpio_readq(tgpio->base,
+					TGPIOTCV31_0);
+
+			ptp_clock_event(tgpio->clock, &event);
+		}
+		schedule_timeout_interruptible(10);
+	}
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_config_input(struct intel_pmc_tgpio *tgpio,
+		struct ptp_extts_request *extts, int on)
+{
+	u32			ctrl;
+	bool			input;
+
+	ctrl = intel_pmc_tgpio_readl(tgpio->base, TGPIOCTL);
+	ctrl &= ~TGPIOCTL_EN;
+	intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+
+	if (on) {
+		ctrl |= TGPIOCTL_DIR;
+
+		if (extts->flags & PTP_RISING_EDGE &&
+				extts->flags & PTP_FALLING_EDGE)
+			ctrl |= TGPIOCTL_EP_TOGGLE_EDGE;
+		else if (extts->flags & PTP_RISING_EDGE)
+			ctrl |= TGPIOCTL_EP_RISING_EDGE;
+		else if (extts->flags & PTP_FALLING_EDGE)
+			ctrl |= TGPIOCTL_EP_FALLING_EDGE;
+
+		/* gotta program all other bits before EN bit is set */
+		intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+		ctrl |= TGPIOCTL_EN;
+		input = true;
+	} else {
+		ctrl &= ~(TGPIOCTL_DIR | TGPIOCTL_EN);
+		input = false;
+	}
+
+	intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+	tgpio->input = input;
+
+	if (input)
+		wake_up_process(tgpio->event_thread);
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_config_output(struct intel_pmc_tgpio *tgpio,
+		struct ptp_perout_request *perout, int on)
+{
+	u32			ctrl;
+
+	ctrl = intel_pmc_tgpio_readl(tgpio->base, TGPIOCTL);
+	if (on) {
+		struct ptp_clock_time *period = &perout->period;
+		struct ptp_clock_time *start = &perout->start;
+
+		if (ctrl & TGPIOCTL_EN)
+			return 0;
+
+		intel_pmc_tgpio_writeq(tgpio->base, TGPIOCOMPV31_0,
+				to_intel_pmc_tgpio_time(start));
+
+		intel_pmc_tgpio_writeq(tgpio->base, TGPIOPIV31_0,
+				to_intel_pmc_tgpio_time(period));
+
+		ctrl &= ~TGPIOCTL_DIR;
+		if (perout->flags & PTP_PEROUT_ONE_SHOT)
+			ctrl &= ~TGPIOCTL_PM;
+		else
+			ctrl |= TGPIOCTL_PM;
+
+		/* gotta program all other bits before EN bit is set */
+		intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+
+		ctrl |= TGPIOCTL_EN;
+		intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+	} else {
+		if (!(ctrl & ~TGPIOCTL_EN))
+			return 0;
+
+		ctrl &= ~(TGPIOCTL_EN | TGPIOCTL_PM);
+		intel_pmc_tgpio_writel(tgpio->base, TGPIOCTL, ctrl);
+	}
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_enable(struct ptp_clock_info *info,
+		struct ptp_clock_request *req, int on)
+{
+	struct intel_pmc_tgpio	*tgpio = to_intel_pmc_tgpio(info);
+	int			ret = -EOPNOTSUPP;
+
+	mutex_lock(&tgpio->lock);
+	switch (req->type) {
+	case PTP_CLK_REQ_EXTTS:
+		ret = intel_pmc_tgpio_config_input(tgpio, &req->extts, on);
+		break;
+	case PTP_CLK_REQ_PEROUT:
+		ret = intel_pmc_tgpio_config_output(tgpio, &req->perout, on);
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&tgpio->lock);
+
+	return ret;
+}
+
+static int intel_pmc_tgpio_get_time_fn(ktime_t *device_time,
+		struct system_counterval_t *system_counter, void *_tgpio)
+{
+	get_tsc_ns(system_counter, device_time);
+	return 0;
+}
+
+static int intel_pmc_tgpio_getcrosststamp(struct ptp_clock_info *info,
+		struct system_device_crosststamp *cts)
+{
+	struct intel_pmc_tgpio	*tgpio = to_intel_pmc_tgpio(info);
+
+	return get_device_system_crosststamp(intel_pmc_tgpio_get_time_fn, tgpio,
+			NULL, cts);
+}
+
+static int intel_pmc_tgpio_counttstamp(struct ptp_clock_info *info,
+		struct ptp_event_count_tstamp *count)
+{
+	struct intel_pmc_tgpio	*tgpio = to_intel_pmc_tgpio(info);
+	u32 dt_hi_tmp;
+	u32 dt_hi;
+	u32 dt_lo;
+
+	dt_hi_tmp = intel_pmc_tgpio_readl(tgpio->base, TGPIOTCV63_32);
+	dt_lo = intel_pmc_tgpio_readl(tgpio->base, TGPIOTCV31_0);
+
+	count->event_count = intel_pmc_tgpio_readl(tgpio->base, TGPIOECCV63_32);
+	count->event_count <<= 32;
+	count->event_count |= intel_pmc_tgpio_readl(tgpio->base, TGPIOECCV31_0);
+
+	dt_hi = intel_pmc_tgpio_readl(tgpio->base, TGPIOTCV63_32);
+
+	if (dt_hi_tmp != dt_hi && dt_lo & 0x80000000)
+		count->device_time.sec = dt_hi_tmp;
+	else
+		count->device_time.sec = dt_hi;
+
+	count->device_time.nsec = dt_lo;
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_verify(struct ptp_clock_info *ptp, unsigned int pin,
+		enum ptp_pin_function func, unsigned int chan)
+{
+	return 0;
+}
+
+static const struct ptp_clock_info intel_pmc_tgpio_info = {
+	.owner		= THIS_MODULE,
+	.name		= "Intel PMC TGPIO",
+	.max_adj	= 50000000,
+	.n_pins		= 1,
+	.n_ext_ts	= 1,
+	.n_per_out	= 1,
+	.pin_config	= intel_pmc_tgpio_pin_config,
+	.gettime64	= intel_pmc_tgpio_gettime64,
+	.settime64	= intel_pmc_tgpio_settime64,
+	.enable		= intel_pmc_tgpio_enable,
+	.getcrosststamp	= intel_pmc_tgpio_getcrosststamp,
+	.counttstamp	= intel_pmc_tgpio_counttstamp,
+	.verify		= intel_pmc_tgpio_verify,
+};
+
+static int intel_pmc_tgpio_probe(struct platform_device *pdev)
+{
+	struct intel_pmc_tgpio	*tgpio;
+	struct device		*dev;
+	struct resource		*res;
+
+	dev = &pdev->dev;
+	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
+	if (!tgpio)
+		return -ENOMEM;
+
+	tgpio->dev = dev;
+	tgpio->info = intel_pmc_tgpio_info;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	tgpio->base = devm_ioremap_resource(dev, res);
+	if (!tgpio->base)
+		return -ENOMEM;
+
+	mutex_init(&tgpio->lock);
+	platform_set_drvdata(pdev, tgpio);
+
+	tgpio->event_thread = kthread_create(intel_pmc_tgpio_event_thread,
+			tgpio, dev_name(tgpio->dev));
+	if (IS_ERR(tgpio->event_thread))
+		return PTR_ERR(tgpio->event_thread);
+
+	tgpio->clock = ptp_clock_register(&tgpio->info, &pdev->dev);
+	if (IS_ERR(tgpio->clock))
+		return PTR_ERR(tgpio->clock);
+
+	wake_up_process(tgpio->event_thread);
+
+	return 0;
+}
+
+static int intel_pmc_tgpio_remove(struct platform_device *pdev)
+{
+	struct intel_pmc_tgpio	*tgpio = platform_get_drvdata(pdev);
+
+	ptp_clock_unregister(tgpio->clock);
+
+	return 0;
+}
+
+static const struct acpi_device_id intel_pmc_acpi_match[] = {
+	/* TODO */
+
+	{  },
+};
+
+/* MODULE_ALIAS("acpi*:TODO:*"); */
+
+static struct platform_driver intel_pmc_tgpio_driver = {
+	.probe		= intel_pmc_tgpio_probe,
+	.remove		= intel_pmc_tgpio_remove,
+	.driver		= {
+		.name	= "intel-pmc-tgpio",
+		.acpi_match_table = ACPI_PTR(intel_pmc_acpi_match),
+	},
+};
+
+module_platform_driver(intel_pmc_tgpio_driver);
+
+MODULE_AUTHOR("Felipe Balbi <felipe.balbi@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Intel PMC Timed GPIO Controller Driver");
-- 
2.22.0

