Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983563074C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfEaDyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:04 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42931 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfEaDyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:04 -0400
Received: by mail-io1-f66.google.com with SMTP id g16so7017359iom.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/L/8emfxyGoTsf39QVK6y6tpkz0o/6m0FIh3x5x+sE=;
        b=LtLkVr6OY0lYm0adAANtt9XSE9nmqSNczmco3ezqSEOhx/itnTww+YEPey+9Fdj8U9
         I+TSsz/OakQ+JoXbdZ+9imwMGJk3TOevNxYUEHh1Ck+0SDMYd+8Ce/JsLk/xu590Eoj/
         cq6zTD7yEzdwntV2kbEJB3swnxkREsqTc9GhZo9KTsSu8hWSWPAshCulOxawv8pFQ+h7
         C7rurTp3aK3HaKZSkvleqWnUKVjlSVGMlBHYrlAyHTjTANIgGBLGk+LAJN5Lfra2ZTb/
         ujeW9SAUXkWgIbgwM+uKb4QCz0bf8e/QdH6vlUY4bAX/zyTay6JWcoSa14FHqNRJoHTL
         OPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/L/8emfxyGoTsf39QVK6y6tpkz0o/6m0FIh3x5x+sE=;
        b=DldTGQAmX/+QheNghvHWT4y1w9kC2oJ5o5UxZHUlKBu+SpjPJ50D0Q/UW0qwSusNgG
         uMmjd0CbQ3gOH+haKp+HONizCAIORAiWXY8llc6u6mNtYnhI+9wI9dvbD7D5f/QyGm8u
         ADBE6ZW3UdRcY5L+opLHaBz69lJC1101osql4is+ptSXyOzUCpXnCbuXSGiZ0/IV/7ah
         sIpT+eMfOF2tKWQYchSqJYYQdMPVZ+AQee0D12nDRLXyjRWQiPi+Gs748ihT/QLX5I37
         ZLGxslfvTotl7W5EFZoNzjfoe3pgrvQe55vbkanEePj7oiteaXg0rHIB7fXdTkUvo+Mn
         IqBQ==
X-Gm-Message-State: APjAAAVdYOV39dKS6Dqv0yElmmMktt6Oppk56GGxtp2fJmg3755pAoTG
        iuIH9Fz43k80bAoEyuvB5sUW2w==
X-Google-Smtp-Source: APXvYqwNL7Lj06x1ekIS8NyAGLzYPS264SsHtVDZDVqTlA9ic7gjyozgPmtszRnQmHgWpFmfaUdyjw==
X-Received: by 2002:a5d:9743:: with SMTP id c3mr5044760ioo.32.1559274842452;
        Thu, 30 May 2019 20:54:02 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:01 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 05/17] soc: qcom: ipa: clocking, interrupts, and memory
Date:   Thu, 30 May 2019 22:53:36 -0500
Message-Id: <20190531035348.7194-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch incorporates three source files (and their headers).  They're
grouped into one patch mainly for the purpose of making the number and
size of patches in this series somewhat reasonable.

  - "ipa_clock.c" and "ipa_clock.h" implement clocking for the IPA device.
    The IPA has a single core clock managed by the common clock framework.
    In addition, the IPA has three buses whose bandwidth is managed by the
    Linux interconnect framework.  At this time the core clock and all
    three buses are either on or off; we don't yet do any more fine-grained
    management than that.  The core clock and interconnects are enabled
    and disabled as a unit, using a unified clock-like abstraction,
    ipa_clock_get()/ipa_clock_put().

  - "ipa_interrupt.c" and "ipa_interrupt.h" implement IPA interrupts.
    There are two hardare IRQs used by the IPA driver (the other is
    the GSI interrupt, described in a separate patch).  Several types
    of interrupt are handled by the IPA IRQ handler; these are not part
    of data/fast path.

  - The IPA has a region of local memory that is accessible by the AP
    (and modem).  Within that region are areas with certain defined
    purposes.  "ipa_mem.c" and "ipa_mem.h" define those regions, and
    implement their initialization.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c     | 297 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_clock.h     |  52 ++++++
 drivers/net/ipa/ipa_interrupt.c | 279 ++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_interrupt.h |  53 ++++++
 drivers/net/ipa/ipa_mem.c       | 234 +++++++++++++++++++++++++
 drivers/net/ipa/ipa_mem.h       |  83 +++++++++
 6 files changed, 998 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_clock.c
 create mode 100644 drivers/net/ipa/ipa_clock.h
 create mode 100644 drivers/net/ipa/ipa_interrupt.c
 create mode 100644 drivers/net/ipa/ipa_interrupt.h
 create mode 100644 drivers/net/ipa/ipa_mem.c
 create mode 100644 drivers/net/ipa/ipa_mem.h

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
new file mode 100644
index 000000000000..9ed12e8183ad
--- /dev/null
+++ b/drivers/net/ipa/ipa_clock.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+
+#include <linux/atomic.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/interconnect.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_netdev.h"
+
+/**
+ * DOC: IPA Clocking
+ *
+ * The "IPA Clock" manages both the IPA core clock and the interconnects
+ * (buses) the IPA depends on as a single logical entity.  A reference count
+ * is incremented by "get" operations and decremented by "put" operations.
+ * Transitions of that count from 0 to 1 result in the clock and interconnects
+ * being enabled, and transitions of the count from 1 to 0 cause them to be
+ * disabled.  We currently operate the core clock at a fixed clock rate, and
+ * all buses at a fixed average and peak bandwidth.  As more advanced IPA
+ * features are enabled, we can will better use of clock and bus scaling.
+ *
+ * An IPA clock reference must be held for any access to IPA hardware.
+ */
+
+#define	IPA_CORE_CLOCK_RATE		(75UL * 1000 * 1000)	/* Hz */
+
+/* Interconnect path bandwidths (each times 1000 bytes per second) */
+#define IPA_MEMORY_AVG			(80 * 1000)	/* 80 MBps */
+#define IPA_MEMORY_PEAK			(600 * 1000)
+
+#define IPA_IMEM_AVG			(80 * 1000)
+#define IPA_IMEM_PEAK			(350 * 1000)
+
+#define IPA_CONFIG_AVG			(40 * 1000)
+#define IPA_CONFIG_PEAK			(40 * 1000)
+
+/**
+ * struct ipa_clock - IPA clocking information
+ * @core:		IPA core clock
+ * @memory_path:	Memory interconnect
+ * @imem_path:		Internal memory interconnect
+ * @config_path:	Configuration space interconnect
+ * @mutex;		Protects clock enable/disable
+ * @count:		Clocking reference count
+ */
+struct ipa_clock {
+	struct ipa *ipa;
+	atomic_t count;
+	struct mutex mutex; /* protects clock enable/disable */
+	struct clk *core;
+	struct icc_path *memory_path;
+	struct icc_path *imem_path;
+	struct icc_path *config_path;
+};
+
+/* Initialize interconnects required for IPA operation */
+static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev)
+{
+	struct icc_path *path;
+
+	path = of_icc_get(dev, "memory");
+	if (IS_ERR(path))
+		goto err_return;
+	clock->memory_path = path;
+
+	path = of_icc_get(dev, "imem");
+	if (IS_ERR(path))
+		goto err_memory_path_put;
+	clock->imem_path = path;
+
+	path = of_icc_get(dev, "config");
+	if (IS_ERR(path))
+		goto err_imem_path_put;
+	clock->config_path = path;
+
+	return 0;
+
+err_imem_path_put:
+	icc_put(clock->imem_path);
+err_memory_path_put:
+	icc_put(clock->memory_path);
+err_return:
+
+	return PTR_ERR(path);
+}
+
+/* Inverse of ipa_interconnect_init() */
+static void ipa_interconnect_exit(struct ipa_clock *clock)
+{
+	icc_put(clock->config_path);
+	icc_put(clock->imem_path);
+	icc_put(clock->memory_path);
+}
+
+/* Currently we only use one bandwidth level, so just "enable" interconnects */
+static int ipa_interconnect_enable(struct ipa_clock *clock)
+{
+	int ret;
+
+	ret = icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+	if (ret)
+		return ret;
+
+	ret = icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+	if (ret)
+		goto err_disable_memory_path;
+
+	ret = icc_set_bw(clock->config_path, IPA_CONFIG_AVG, IPA_CONFIG_PEAK);
+	if (ret)
+		goto err_disable_imem_path;
+
+	return 0;
+
+err_disable_imem_path:
+	(void)icc_set_bw(clock->imem_path, 0, 0);
+err_disable_memory_path:
+	(void)icc_set_bw(clock->memory_path, 0, 0);
+
+	return ret;
+}
+
+/* To disable an interconnect, we just its bandwidth to 0 */
+static int ipa_interconnect_disable(struct ipa_clock *clock)
+{
+	int ret;
+
+	ret = icc_set_bw(clock->memory_path, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = icc_set_bw(clock->imem_path, 0, 0);
+	if (ret)
+		goto err_reenable_memory_path;
+
+	ret = icc_set_bw(clock->config_path, 0, 0);
+	if (ret)
+		goto err_reenable_imem_path;
+
+	return 0;
+
+err_reenable_imem_path:
+	(void)icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+err_reenable_memory_path:
+	(void)icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+
+	return ret;
+}
+
+/* Turn on IPA clocks, including interconnects */
+static int ipa_clock_enable(struct ipa_clock *clock)
+{
+	int ret;
+
+	ret = ipa_interconnect_enable(clock);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(clock->core);
+	if (ret)
+		ipa_interconnect_disable(clock);
+
+	return ret;
+}
+
+/* Inverse of ipa_clock_enable() */
+static void ipa_clock_disable(struct ipa_clock *clock)
+{
+	clk_disable_unprepare(clock->core);
+	(void)ipa_interconnect_disable(clock);
+}
+
+/* Get an IPA clock reference, but only if the reference count is
+ * already non-zero.  Returns true if the additional reference was
+ * added successfully, or false otherwise.
+ */
+bool ipa_clock_get_additional(struct ipa_clock *clock)
+{
+	return !!atomic_inc_not_zero(&clock->count);
+}
+
+/* Get an IPA clock reference.  If the reference count is non-zero, it is
+ * incremented and return is immediate.  Otherwise it is checked again
+ * under protection of the mutex, and enable clocks and resume RX endpoints
+ * before returning.  For the first reference, the count is intentionally
+ * not incremented until after these activities are complete.
+ */
+void ipa_clock_get(struct ipa_clock *clock)
+{
+	/* If the clock is running, just bump the reference count */
+	if (ipa_clock_get_additional(clock))
+		return;
+
+	/* Otherwise get the mutex and check again */
+	mutex_lock(&clock->mutex);
+
+	/* A reference might have been added before we got the mutex. */
+	if (!ipa_clock_get_additional(clock)) {
+		int ret;
+
+		ret = ipa_clock_enable(clock);
+		if (!WARN(ret, "error %d enabling IPA clock\n", ret)) {
+			struct ipa *ipa = clock->ipa;
+
+			if (ipa->command_endpoint)
+				ipa_endpoint_resume(ipa->command_endpoint);
+
+			if (ipa->default_endpoint)
+				ipa_endpoint_resume(ipa->default_endpoint);
+
+			if (ipa->modem_netdev)
+				ipa_netdev_resume(ipa->modem_netdev);
+
+			atomic_inc(&clock->count);
+		}
+	}
+
+	mutex_unlock(&clock->mutex);
+}
+
+/* Attempt to remove an IPA clock reference.  If this represents
+ * the last reference, suspend endpoints and disable the clock
+ * (and interconnects) under protection of a mutex.
+ */
+void ipa_clock_put(struct ipa_clock *clock)
+{
+	/* If this is not the last reference there's nothing more to do */
+	if (!atomic_dec_and_mutex_lock(&clock->count, &clock->mutex))
+		return;
+
+	if (clock->ipa->modem_netdev)
+		ipa_netdev_suspend(clock->ipa->modem_netdev);
+
+	if (clock->ipa->default_endpoint)
+		ipa_endpoint_suspend(clock->ipa->default_endpoint);
+
+	if (clock->ipa->command_endpoint)
+		ipa_endpoint_suspend(clock->ipa->command_endpoint);
+
+	ipa_clock_disable(clock);
+
+	mutex_unlock(&clock->mutex);
+}
+
+/* Initialize IPA clocking */
+struct ipa_clock *ipa_clock_init(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct ipa_clock *clock;
+	int ret;
+
+	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	if (!clock)
+		return ERR_PTR(-ENOMEM);
+
+	clock->ipa = ipa;
+	clock->core = clk_get(dev, "core");
+	if (IS_ERR(clock->core)) {
+		ret = PTR_ERR(clock->core);
+		goto err_free_clock;
+	}
+
+	ret = clk_set_rate(clock->core, IPA_CORE_CLOCK_RATE);
+	if (ret)
+		goto err_clk_put;
+
+	ret = ipa_interconnect_init(clock, dev);
+	if (ret)
+		goto err_clk_put;
+
+	mutex_init(&clock->mutex);
+	atomic_set(&clock->count, 0);
+
+	return clock;
+
+err_clk_put:
+	clk_put(clock->core);
+err_free_clock:
+	kfree(clock);
+
+	return ERR_PTR(ret);
+}
+
+/* Inverse of ipa_clock_init() */
+void ipa_clock_exit(struct ipa_clock *clock)
+{
+	mutex_destroy(&clock->mutex);
+	ipa_interconnect_exit(clock);
+	clk_put(clock->core);
+	kfree(clock);
+}
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
new file mode 100644
index 000000000000..f38c3face29a
--- /dev/null
+++ b/drivers/net/ipa/ipa_clock.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_CLOCK_H_
+#define _IPA_CLOCK_H_
+
+struct ipa;
+struct ipa_clock;
+
+/**
+ * ipa_clock_init() - Initialize IPA clocking
+ * @ipa:	IPA pointer
+ *
+ * @Return:	A pointer to an ipa_clock structure, or a pointer-coded error
+ */
+struct ipa_clock *ipa_clock_init(struct ipa *ipa);
+
+/**
+ * ipa_clock_exit() - Inverse of ipa_clock_init()
+ * @clock:	IPA clock pointer
+ */
+void ipa_clock_exit(struct ipa_clock *clock);
+
+/**
+ * ipa_clock_get() - Get an IPA clock reference
+ * @clock:	IPA clock pointer
+ *
+ * This call blocks if this is the first reference.
+ */
+void ipa_clock_get(struct ipa_clock *clock);
+
+/**
+ * ipa_clock_get_additional() - Get an IPA clock reference if not first
+ * @clock:	IPA clock pointer
+ *
+ * This returns immediately, and only takes a reference if not the first
+ */
+bool ipa_clock_get_additional(struct ipa_clock *clock);
+
+/**
+ * ipa_clock_put() - Drop an IPA clock reference
+ * @clock:	IPA clock pointer
+ *
+ * This drops a clock reference.  If the last reference is being dropped,
+ * the clock is stopped and RX endpoints are suspended.  This call will
+ * not block unless the last reference is dropped.
+ */
+void ipa_clock_put(struct ipa_clock *clock);
+
+#endif /* _IPA_CLOCK_H_ */
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
new file mode 100644
index 000000000000..5be6b3c762ed
--- /dev/null
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+
+/* DOC: IPA Interrupts
+ *
+ * The IPA has an interrupt line distinct from the interrupt used by the GSI
+ * code.  Whereas GSI interrupts are generally related to channel events (like
+ * transfer completions), IPA interrupts are related to other events related
+ * to the IPA.  Some of the IPA interrupts come from a microcontroller
+ * embedded in the IPA.  Each IPA interrupt type can be both masked and
+ * acknowledged independent of the others.
+ *
+ * Two of the IPA interrupts are initiated by the microcontroller.  A third
+ * can be generated to signal the need for a wakeup/resume when an IPA
+ * endpoint has been suspended.  There are other IPA events defined, but at
+ * this time only these three are supported.
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_reg.h"
+#include "ipa_endpoint.h"
+#include "ipa_interrupt.h"
+
+/* Maximum number of bits in an IPA interrupt mask */
+#define IPA_INTERRUPT_MAX	(sizeof(u32) * BITS_PER_BYTE)
+
+struct ipa_interrupt_info {
+	ipa_irq_handler_t handler;
+	enum ipa_interrupt_id interrupt_id;
+};
+
+/**
+ * struct ipa_interrupt - IPA interrupt information
+ * @ipa:		IPA pointer
+ * @irq:		Linux IRQ number used for IPA interrupts
+ * @interrupt_info:	Information for each IPA interrupt type
+ */
+struct ipa_interrupt {
+	struct ipa *ipa;
+	u32 irq;
+	u32 enabled;
+	struct ipa_interrupt_info info[IPA_INTERRUPT_MAX];
+};
+
+/* Map a logical interrupt number to a hardware IPA IRQ number */
+static const u32 ipa_interrupt_mapping[] = {
+	[IPA_INTERRUPT_UC_0]		= 2,
+	[IPA_INTERRUPT_UC_1]		= 3,
+	[IPA_INTERRUPT_TX_SUSPEND]	= 14,
+};
+
+static bool ipa_interrupt_uc(struct ipa_interrupt *interrupt, u32 ipa_irq)
+{
+	return ipa_irq == ipa_interrupt_mapping[IPA_INTERRUPT_UC_0] ||
+		ipa_irq == ipa_interrupt_mapping[IPA_INTERRUPT_UC_1];
+}
+
+static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 ipa_irq)
+{
+	struct ipa_interrupt_info *info = &interrupt->info[ipa_irq];
+	bool uc_irq = ipa_interrupt_uc(interrupt, ipa_irq);
+	struct ipa *ipa = interrupt->ipa;
+	u32 mask = BIT(ipa_irq);
+
+	/* For microcontroller interrupts, clear the interrupt right away,
+	 * "to avoid clearing unhandled interrupts."
+	 */
+	if (uc_irq)
+		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+
+	if (info->handler)
+		info->handler(interrupt->ipa, info->interrupt_id);
+
+	/* Clearing the SUSPEND_TX interrupt also clears the register
+	 * that tells us which suspended endpoint(s) caused the interrupt,
+	 * so defer clearing until after the handler's been called.
+	 */
+	if (!uc_irq)
+		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+}
+
+static void ipa_interrupt_process_all(struct ipa_interrupt *interrupt)
+{
+	struct ipa *ipa = interrupt->ipa;
+	u32 enabled = interrupt->enabled;
+	u32 mask;
+
+	/* The status register indicates which conditions are present,
+	 * including conditions whose interrupt is not enabled.  Handle
+	 * only the enabled ones.
+	 */
+	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	while ((mask &= enabled)) {
+		do {
+			u32 ipa_irq = __ffs(mask);
+
+			mask ^= BIT(ipa_irq);
+
+			ipa_interrupt_process(interrupt, ipa_irq);
+		} while (mask);
+		mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	}
+}
+
+/* Threaded part of the IRQ handler */
+static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
+{
+	struct ipa_interrupt *interrupt = dev_id;
+
+	ipa_clock_get(interrupt->ipa->clock);
+
+	ipa_interrupt_process_all(interrupt);
+
+	ipa_clock_put(interrupt->ipa->clock);
+
+	return IRQ_HANDLED;
+}
+
+/* Hard part of the IRQ handler */
+static irqreturn_t ipa_isr(int irq, void *dev_id)
+{
+	struct ipa_interrupt *interrupt = dev_id;
+	struct ipa *ipa = interrupt->ipa;
+	u32 mask;
+
+	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	if (mask & interrupt->enabled)
+		return IRQ_WAKE_THREAD;
+
+	/* Nothing in the mask was supposed to cause an interrupt */
+	iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+
+	dev_err(&ipa->pdev->dev, "%s: unexpected interrupt, mask 0x%08x\n",
+		__func__, mask);
+
+	return IRQ_HANDLED;
+}
+
+static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
+					  enum ipa_endpoint_id endpoint_id,
+					  bool enable)
+{
+	u32 offset = IPA_REG_SUSPEND_IRQ_EN_OFFSET;
+	u32 mask = BIT(endpoint_id);
+	u32 val;
+
+	val = ioread32(interrupt->ipa->reg_virt + offset);
+	if (enable)
+		val |= mask;
+	else
+		val &= ~mask;
+	iowrite32(val, interrupt->ipa->reg_virt + offset);
+}
+
+void ipa_interrupt_suspend_enable(struct ipa_interrupt *interrupt,
+				  enum ipa_endpoint_id endpoint_id)
+{
+	ipa_interrupt_suspend_control(interrupt, endpoint_id, true);
+}
+
+void ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt,
+				   enum ipa_endpoint_id endpoint_id)
+{
+	ipa_interrupt_suspend_control(interrupt, endpoint_id, false);
+}
+
+/* Clear the suspend interrupt for all endpoints that signaled it */
+void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
+{
+	struct ipa *ipa = interrupt->ipa;
+	u32 val;
+
+	val = ioread32(ipa->reg_virt + IPA_REG_IRQ_SUSPEND_INFO_OFFSET);
+	iowrite32(val, ipa->reg_virt + IPA_REG_SUSPEND_IRQ_CLR_OFFSET);
+}
+
+/**
+ * ipa_interrupt_simulate() - Simulate arrival of an IPA TX_SUSPEND interrupt
+ *
+ * This is needed to work around a problem that occurs if aggregation
+ * is active on an endpoint when its underlying channel is suspended.
+ */
+void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt)
+{
+	u32 ipa_irq = ipa_interrupt_mapping[IPA_INTERRUPT_TX_SUSPEND];
+
+	ipa_interrupt_process(interrupt, ipa_irq);
+}
+
+/**
+ * ipa_interrupt_add() - Adds handler for an IPA interrupt
+ * @interrupt_id:	IPA interrupt type
+ * @handler:		The handler for that interrupt
+ *
+ * Adds handler for an IPA interrupt and enable it.  IPA interrupt
+ * handlers are run in threaded interrupt context, so are allowed to
+ * block.
+ */
+void ipa_interrupt_add(struct ipa_interrupt *interrupt,
+		       enum ipa_interrupt_id interrupt_id,
+		       ipa_irq_handler_t handler)
+{
+	u32 ipa_irq = ipa_interrupt_mapping[interrupt_id];
+	struct ipa *ipa = interrupt->ipa;
+
+	interrupt->info[ipa_irq].handler = handler;
+	interrupt->info[ipa_irq].interrupt_id = interrupt_id;
+
+	/* Update the IPA interrupt mask to enable it */
+	interrupt->enabled |= BIT(ipa_irq);
+	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+}
+
+/**
+ * ipa_interrupt_remove() - Removes handler for an IPA interrupt type
+ * @interrupt:		IPA interrupt type
+ *
+ * Remove an IPA interrupt handler and disable it.
+ */
+void ipa_interrupt_remove(struct ipa_interrupt *interrupt,
+			  enum ipa_interrupt_id interrupt_id)
+{
+	u32 ipa_irq = ipa_interrupt_mapping[interrupt_id];
+	struct ipa *ipa = interrupt->ipa;
+
+	/* Update the IPA interrupt mask to disable it */
+	interrupt->enabled &= ~BIT(ipa_irq);
+	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+
+	interrupt->info[ipa_irq].handler = NULL;
+}
+
+/**
+ * ipa_interrupts_init() - Initialize the IPA interrupts framework
+ */
+struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
+{
+	struct ipa_interrupt *interrupt;
+	unsigned int irq;
+	int ret;
+
+	ret = platform_get_irq_byname(ipa->pdev, "ipa");
+	if (ret < 0)
+		return ERR_PTR(ret);
+	irq = ret;
+
+	interrupt = kzalloc(sizeof(*interrupt), GFP_KERNEL);
+	if (!interrupt)
+		return ERR_PTR(-ENOMEM);
+	interrupt->ipa = ipa;
+	interrupt->irq = irq;
+
+	/* Start with all IPA interrupts disabled */
+	iowrite32(0, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+
+	ret = request_threaded_irq(irq, ipa_isr, ipa_isr_thread, IRQF_ONESHOT,
+				   "ipa", interrupt);
+	if (ret)
+		goto err_free_interrupt;
+
+	return interrupt;
+
+err_free_interrupt:
+	kfree(interrupt);
+
+	return ERR_PTR(ret);
+}
+
+void ipa_interrupt_teardown(struct ipa_interrupt *interrupt)
+{
+	free_irq(interrupt->irq, interrupt);
+}
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
new file mode 100644
index 000000000000..6e452430c156
--- /dev/null
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _IPA_INTERRUPT_H_
+#define _IPA_INTERRUPT_H_
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+struct ipa;
+struct ipa_interrupt;
+
+/**
+ * enum ipa_interrupt_id - IPA Interrupt Type
+ *
+ * Used to register handlers for IPA interrupts.
+ */
+enum ipa_interrupt_id {
+	IPA_INTERRUPT_UC_0,
+	IPA_INTERRUPT_UC_1,
+	IPA_INTERRUPT_TX_SUSPEND,
+};
+
+/**
+ * typedef ipa_irq_handler_t - irq handler/callback type
+ * @param interrupt		- interrupt type
+ * @param interrupt_data	- interrupt information data
+ *
+ * Callback function registered by ipa_interrupt_add() to handle a specific
+ * interrupt type
+ */
+typedef void (*ipa_irq_handler_t)(struct ipa *ipa,
+				  enum ipa_interrupt_id interrupt_id);
+
+struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa);
+void ipa_interrupt_teardown(struct ipa_interrupt *interrupt);
+
+void ipa_interrupt_add(struct ipa_interrupt *interrupt,
+		       enum ipa_interrupt_id interrupt_id,
+		       ipa_irq_handler_t handler);
+void ipa_interrupt_remove(struct ipa_interrupt *interrupt,
+			  enum ipa_interrupt_id interrupt_id);
+
+void ipa_interrupt_suspend_enable(struct ipa_interrupt *interrupt,
+				  enum ipa_endpoint_id endpoint_id);
+void ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt,
+				   enum ipa_endpoint_id endpoint_id);
+void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
+void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
+
+#endif /* _IPA_INTERRUPT_H_ */
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
new file mode 100644
index 000000000000..ad7e55aec31f
--- /dev/null
+++ b/drivers/net/ipa/ipa_mem.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/bitfield.h>
+#include <linux/bug.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+
+#include "ipa.h"
+#include "ipa_reg.h"
+#include "ipa_cmd.h"
+#include "ipa_mem.h"
+
+/* "Canary" value placed between memory regions to detect overflow */
+#define IPA_SMEM_CANARY_VAL		cpu_to_le32(0xdeadbeef)
+
+/* Only used for IPA_SMEM_UC_EVENT_RING */
+static __always_inline void smem_set_canary(struct ipa *ipa, u32 offset)
+{
+	__le32 *cp = ipa->shared_virt + offset;
+
+	BUILD_BUG_ON(offset < sizeof(*cp));
+
+	*--cp = IPA_SMEM_CANARY_VAL;
+}
+
+static __always_inline void smem_set_canaries(struct ipa *ipa, u32 offset)
+{
+	__le32 *cp = ipa->shared_virt + offset;
+
+	/* IPA accesses memory at 8-byte aligned offsets, 8 bytes at a time */
+	BUILD_BUG_ON(offset % 8);
+	BUILD_BUG_ON(offset < 2 * sizeof(*cp));
+
+	*--cp = IPA_SMEM_CANARY_VAL;
+	*--cp = IPA_SMEM_CANARY_VAL;
+}
+
+/**
+ * ipa_smem_setup() - Set up IPA AP and modem shared memory areas
+ *
+ * Set up the IPA-local shared memory areas located in shared memory
+ * located in the IPA.  This involves zero-filling each area (using
+ * DMA) and then telling the IPA where it's located.  We set up the
+ * regions for the header and processing context structures used by
+ * both the modem and the AP.
+ *
+ * The modem and AP header areas are contiguous, with the modem area
+ * located at the lower address.  The processing context memory areas
+ * for the modem and AP are also contiguous, with the modem at the base
+ * of the combined space.
+ *
+ * The modem portions are also zeroed in ipa_smem_zero_modem(); if it
+ * crashes and restarts via SSR these areas need to be * re-initialized.
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int ipa_smem_setup(struct ipa *ipa)
+{
+	u32 offset;
+	u32 size;
+	int ret;
+
+	/* Alignments of some offsets are verified in smem_set_canaries() */
+	BUILD_BUG_ON(IPA_SMEM_AP_HDR_OFFSET % 8);
+	BUILD_BUG_ON(IPA_SMEM_MODEM_HDR_SIZE % 8);
+	BUILD_BUG_ON(IPA_SMEM_AP_HDR_SIZE % 8);
+
+	/* Initialize IPA-local header memory */
+	offset = IPA_SMEM_MODEM_HDR_OFFSET;
+	size = IPA_SMEM_MODEM_HDR_SIZE + IPA_SMEM_AP_HDR_SIZE;
+	ret = ipa_cmd_hdr_init_local(ipa, offset, size);
+	if (ret)
+		return ret;
+
+	BUILD_BUG_ON(IPA_SMEM_AP_HDR_PROC_CTX_OFFSET % 8);
+	BUILD_BUG_ON(IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE % 8);
+	BUILD_BUG_ON(IPA_SMEM_AP_HDR_PROC_CTX_SIZE % 8);
+
+	/* Zero the processing context IPA-local memory for the modem and AP */
+	offset = IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET;
+	size = IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE + IPA_SMEM_AP_HDR_PROC_CTX_SIZE;
+	ret = ipa_cmd_smem_dma_zero(ipa, offset, size);
+	if (ret)
+		return ret;
+
+	/* Tell the hardware where the processing context area is located */
+	iowrite32(ipa->shared_offset + offset,
+		  ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET);
+
+	return ret;
+}
+
+void ipa_smem_teardown(struct ipa *ipa)
+{
+	/* Nothing to do */
+}
+
+/**
+ * ipa_smem_config() - Configure IPA shared memory
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int ipa_smem_config(struct ipa *ipa)
+{
+	u32 size;
+	u32 val;
+
+	/* Check the advertised location and size of the shared memory area */
+	val = ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
+
+	/* The fields in the register are in 8 byte units */
+	ipa->shared_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
+	dev_dbg(&ipa->pdev->dev, "shared memory offset 0x%x bytes\n",
+		ipa->shared_offset);
+	if (WARN_ON(ipa->shared_offset))
+		return -EINVAL;
+
+	/* The code assumes a certain minimum shared memory area size */
+	size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+	dev_dbg(&ipa->pdev->dev, "shared memory size 0x%x bytes\n", size);
+	if (WARN_ON(size < IPA_SMEM_SIZE))
+		return -EINVAL;
+
+	/* Now write "canary" values before each sub-section. */
+	smem_set_canaries(ipa, IPA_SMEM_V4_FLT_HASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V4_FLT_NHASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V6_FLT_HASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V6_FLT_NHASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V4_RT_HASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V4_RT_NHASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V6_RT_HASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_V6_RT_NHASH_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_MODEM_HDR_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_MODEM_HDR_PROC_CTX_OFFSET);
+	smem_set_canaries(ipa, IPA_SMEM_MODEM_OFFSET);
+
+	/* Only one canary precedes the microcontroller ring */
+	BUILD_BUG_ON(IPA_SMEM_UC_EVENT_RING_OFFSET % 1024);
+	smem_set_canary(ipa, IPA_SMEM_UC_EVENT_RING_OFFSET);
+
+	return 0;
+}
+
+void ipa_smem_deconfig(struct ipa *ipa)
+{
+	/* Don't bother zeroing any of the shared memory on exit */
+}
+
+/**
+ * ipa_smem_zero_modem() - Zero modem IPA-local memory regions
+ *
+ * Zero regions of IPA-local memory used by the modem.  These are
+ * configured (and initially zeroed) by ipa_smem_setup(), but if
+ * the modem crashes and restarts via SSR we need to re-initialize
+ * them.
+ */
+int ipa_smem_zero_modem(struct ipa *ipa)
+{
+	int ret;
+
+	ret = ipa_cmd_smem_dma_zero(ipa, IPA_SMEM_MODEM_OFFSET,
+				    IPA_SMEM_MODEM_SIZE);
+	if (ret)
+		return ret;
+
+	ret = ipa_cmd_smem_dma_zero(ipa, IPA_SMEM_MODEM_HDR_OFFSET,
+				    IPA_SMEM_MODEM_HDR_SIZE);
+	if (ret)
+		return ret;
+
+	ret = ipa_cmd_smem_dma_zero(ipa, IPA_SMEM_MODEM_HDR_PROC_CTX_OFFSET,
+				    IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE);
+
+	return ret;
+}
+
+int ipa_mem_init(struct ipa *ipa)
+{
+	struct resource *res;
+	int ret;
+
+	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
+	if (ret)
+		return ret;
+
+	/* Set up IPA shared memory */
+	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
+					   "ipa-shared");
+	if (!res)
+		return -ENODEV;
+
+	/* The code assumes a certain minimum shared memory area size */
+	if (WARN_ON(resource_size(res) < IPA_SMEM_SIZE))
+		return -EINVAL;
+
+	ipa->shared_virt = memremap(res->start, resource_size(res),
+				    MEMREMAP_WC);
+	if (!ipa->shared_virt)
+		ret = -ENOMEM;
+	ipa->shared_phys = res->start;
+
+	/* Setup IPA register memory  */
+	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
+					   "ipa-reg");
+	if (!res) {
+		ret = -ENODEV;
+		goto err_unmap_shared;
+	}
+
+	ipa->reg_virt = ioremap(res->start, resource_size(res));
+	if (!ipa->reg_virt) {
+		ret = -ENOMEM;
+		goto err_unmap_shared;
+	}
+	ipa->reg_phys = res->start;
+
+	return 0;
+
+err_unmap_shared:
+	memunmap(ipa->shared_virt);
+
+	return ret;
+}
+
+void ipa_mem_exit(struct ipa *ipa)
+{
+	iounmap(ipa->reg_virt);
+	memunmap(ipa->shared_virt);
+}
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
new file mode 100644
index 000000000000..179b62c958ed
--- /dev/null
+++ b/drivers/net/ipa/ipa_mem.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _IPA_MEM_H_
+#define _IPA_MEM_H_
+
+struct ipa;
+
+/**
+ * DOC: IPA Local Memory
+ *
+ * The IPA has a block of shared memory, divided into regions used for
+ * specific purposes.  The offset within the IPA address space of this shared
+ * memory block is defined by the IPA_SMEM_DIRECT_ACCESS_OFFSET register.
+ *
+ * The regions within the shared block are bounded by an offset and size found
+ * in the IPA_SHARED_MEM_SIZE register.  The first 128 bytes of the shared
+ * memory block are shared with the microcontroller, and the first 40 bytes of
+ * that contain a structure used to communicate between the microcontroller
+ * and the AP.
+ *
+ * There is a set of filter and routing tables, and each is given a 128 byte
+ * region in shared memory.  Each entry in a filter or route table is
+ * IPA_TABLE_ENTRY_SIZE, or 8 bytes.  The first "slot" of every table is
+ * filled with a "canary" value, and the table offsets defined below represent
+ * the location of the first real entry in each table after this.
+ *
+ * The number of filter table entries depends on the number of endpoints that
+ * support filtering.  The first non-canary slot of a filter table contains a
+ * bitmap, with each set bit indicating an endpoint containing an entry in the
+ * table.  Bit 0 is used to represent a global filter.
+ *
+ * About half of the routing table entries are reserved for modem use.
+ */
+
+/* The maximum number of filter table entries (IPv4, IPv6; hashed and not) */
+#define IPA_SMEM_FLT_COUNT			14
+
+/* The number of routing table entries (IPv4, IPv6; hashed and not) */
+#define IPA_SMEM_RT_COUNT			15
+
+ /* Which routing table entries are for the modem */
+#define IPA_SMEM_MODEM_RT_COUNT			8
+#define IPA_SMEM_MODEM_RT_INDEX_MIN		0
+#define IPA_SMEM_MODEM_RT_INDEX_MAX \
+		(IPA_SMEM_MODEM_RT_INDEX_MIN + IPA_SMEM_MODEM_RT_COUNT - 1)
+
+/* Regions within the shared memory block.  Table sizes are 0x80 bytes. */
+#define IPA_SMEM_V4_FLT_HASH_OFFSET		0x0288
+#define IPA_SMEM_V4_FLT_NHASH_OFFSET		0x0308
+#define IPA_SMEM_V6_FLT_HASH_OFFSET		0x0388
+#define IPA_SMEM_V6_FLT_NHASH_OFFSET		0x0408
+#define IPA_SMEM_V4_RT_HASH_OFFSET		0x0488
+#define IPA_SMEM_V4_RT_NHASH_OFFSET		0x0508
+#define IPA_SMEM_V6_RT_HASH_OFFSET		0x0588
+#define IPA_SMEM_V6_RT_NHASH_OFFSET		0x0608
+#define IPA_SMEM_MODEM_HDR_OFFSET		0x0688
+#define IPA_SMEM_MODEM_HDR_SIZE			0x0140
+#define IPA_SMEM_AP_HDR_OFFSET			0x07c8
+#define IPA_SMEM_AP_HDR_SIZE			0x0000
+#define IPA_SMEM_MODEM_HDR_PROC_CTX_OFFSET	0x07d0
+#define IPA_SMEM_MODEM_HDR_PROC_CTX_SIZE	0x0200
+#define IPA_SMEM_AP_HDR_PROC_CTX_OFFSET		0x09d0
+#define IPA_SMEM_AP_HDR_PROC_CTX_SIZE		0x0200
+#define IPA_SMEM_MODEM_OFFSET			0x0bd8
+#define IPA_SMEM_MODEM_SIZE			0x1024
+#define IPA_SMEM_UC_EVENT_RING_OFFSET		0x1c00	/* v3.5 and later */
+#define IPA_SMEM_SIZE				0x2000
+
+int ipa_smem_config(struct ipa *ipa);
+void ipa_smem_deconfig(struct ipa *ipa);
+
+int ipa_smem_setup(struct ipa *ipa);
+void ipa_smem_teardown(struct ipa *ipa);
+
+int ipa_smem_zero_modem(struct ipa *ipa);
+
+int ipa_mem_init(struct ipa *ipa);
+void ipa_mem_exit(struct ipa *ipa);
+
+#endif /* _IPA_SMEM_H_ */
-- 
2.20.1

