Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F0238BD6C
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbhEUE2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:46 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52428 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239050AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 15DB4202EEE;
        Fri, 21 May 2021 06:26:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 15DB4202EEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector4; t=1621571189;
        bh=vTs5ZY6eg7HBoI/z05ojsDHNzx+U9X1CiogcZAGAv+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACeWwX+/2xLmHYhnxUc0o0cfG24tib7MSAvzVdCrSHsGRgcHVcyLxNOCjKfu+8oSi
         /IFEtCk5dJ81kF2DCh7h8DwBDD1aMSG9CVauYQYGYbRwqlb9YCHv/4tTGEFDKXkSy+
         ZJ60Cu4TC5S47JJSL86v2kQij+HAYPI7jn5iIoIngklLmImWnVrSDzdeyXmLiqvHrt
         RGqWVBQo3Le5ej3vFxwU3s7Kw/YYBPXY8S4pEKfQMJp9hipi2cIzyiXM2Cwq23WE+R
         DnJy7QaEK4bGbrkTiR4Qo5Wh4EBjMgBoxDlFYEMn3QTF8MeBj4+3YrrG0Nfq+gfEen
         BpUZHVDlK9sAQ==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3717720067E;
        Fri, 21 May 2021 06:26:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 3717720067E
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id E3E774024D;
        Fri, 21 May 2021 12:26:22 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 1/7] ptp: add ptp virtual clock driver framework
Date:   Fri, 21 May 2021 12:36:13 +0800
Message-Id: <20210521043619.44694-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add ptp virtual clock driver framework
which just exports essential APIs.

A new member is added for ptp_clock_info structure. Device driver
can provide initial cyclecounter info for ptp virtual clock via
this member, before normally registering ptp clock.

- struct ptp_vclock_cc *vclock_cc;

PTP vclock register/unregister APIs are private for PTP driver.
They can be called after normal ptp clock registering.

- ptp_vclock_register()
- ptp_vclock_unregister()

And below API added is for device driver to get ptp_clock_info of
registered physical clock through cyclecounter pointer of ptp virtual
clock. This is needed for cyclecounter .read callback to read
physical clock cycles.

- ptp_get_pclock_info()

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from v1 patch #1.
	- Fixed build warning.
	- Updated copyright.
---
 MAINTAINERS                      |   6 ++
 drivers/ptp/Makefile             |   2 +-
 drivers/ptp/ptp_private.h        |  23 +++++
 drivers/ptp/ptp_vclock.c         | 142 +++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h |  43 +++++++++-
 5 files changed, 214 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bd7aff0c120f..13ef366e4ab4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14818,6 +14818,12 @@ F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
 
+PTP VIRTUAL CLOCK SUPPORT
+M:	Yangbo Lu <yangbo.lu@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/ptp/ptp_vclock.c
+
 PTRACE SUPPORT
 M:	Oleg Nesterov <oleg@redhat.com>
 S:	Maintained
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 8673d1743faa..3c6a905760e2 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -3,7 +3,7 @@
 # Makefile for PTP 1588 clock support.
 #
 
-ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
+ptp-y					:= ptp_clock.o ptp_vclock.o ptp_chardev.o ptp_sysfs.o
 ptp_kvm-$(CONFIG_X86)			:= ptp_kvm_x86.o ptp_kvm_common.o
 ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:= ptp_kvm_arm.o ptp_kvm_common.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 6b97155148f1..870e54506781 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -3,6 +3,7 @@
  * PTP 1588 clock support - private declarations for the core module.
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
+ * Copyright 2021 NXP
  */
 #ifndef _PTP_PRIVATE_H_
 #define _PTP_PRIVATE_H_
@@ -48,6 +49,26 @@ struct ptp_clock {
 	struct kthread_delayed_work aux_work;
 };
 
+#define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
+#define cc_to_vclock(d) container_of((d), struct ptp_vclock, cc)
+#define dw_to_vclock(d) container_of((d), struct ptp_vclock, refresh_work)
+
+struct ptp_vclock {
+	struct ptp_clock *pclock;
+	struct ptp_clock_info info;
+	struct ptp_clock *clock;
+
+	/* timecounter/cyclecounter definitions */
+	struct cyclecounter cc;
+	struct timecounter tc;
+	spinlock_t lock;	/* protects tc/cc */
+	struct delayed_work refresh_work;
+	unsigned long refresh_interval;
+	u32 mult;
+	u32 mult_factor;
+	u32 div_factor;
+};
+
 /*
  * The function queue_cnt() is safe for readers to call without
  * holding q->lock. Readers use this function to verify that the queue
@@ -89,4 +110,6 @@ extern const struct attribute_group *ptp_groups[];
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
 
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock);
+void ptp_vclock_unregister(struct ptp_vclock *vclock);
 #endif
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
new file mode 100644
index 000000000000..70aae8696003
--- /dev/null
+++ b/drivers/ptp/ptp_vclock.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PTP virtual clock driver
+ *
+ * Copyright 2021 NXP
+ */
+#include <linux/slab.h>
+#include "ptp_private.h"
+
+static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	unsigned long flags;
+	s64 adj;
+
+	adj = (s64)scaled_ppm * vclock->mult_factor;
+	adj = div_s64(adj, vclock->div_factor);
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	timecounter_read(&vclock->tc);
+	vclock->cc.mult = vclock->mult + adj;
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	return 0;
+}
+
+static int ptp_vclock_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	timecounter_adjtime(&vclock->tc, delta);
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	return 0;
+}
+
+static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
+			      struct timespec64 *ts)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	ns = timecounter_read(&vclock->tc);
+	spin_unlock_irqrestore(&vclock->lock, flags);
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int ptp_vclock_settime(struct ptp_clock_info *ptp,
+			      const struct timespec64 *ts)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	u64 ns = timespec64_to_ns(ts);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	timecounter_init(&vclock->tc, &vclock->cc, ns);
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	return 0;
+}
+
+static const struct ptp_clock_info ptp_vclock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "ptp virtual clock",
+	/* The maximum ppb value that long scaled_ppm can support */
+	.max_adj	= 32767999,
+	.adjfine	= ptp_vclock_adjfine,
+	.adjtime	= ptp_vclock_adjtime,
+	.gettime64	= ptp_vclock_gettime,
+	.settime64	= ptp_vclock_settime,
+};
+
+static void ptp_vclock_refresh(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct ptp_vclock *vclock = dw_to_vclock(dw);
+	struct timespec64 ts;
+
+	ptp_vclock_gettime(&vclock->info, &ts);
+	schedule_delayed_work(&vclock->refresh_work, vclock->refresh_interval);
+}
+
+struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc)
+{
+	struct ptp_vclock *vclock = cc_to_vclock(cc);
+
+	return vclock->pclock->info;
+}
+EXPORT_SYMBOL(ptp_get_pclock_info);
+
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
+{
+	struct ptp_vclock_cc *vclock_cc = pclock->info->vclock_cc;
+	struct ptp_vclock *vclock;
+
+	vclock = kzalloc(sizeof(*vclock), GFP_KERNEL);
+	if (!vclock)
+		return NULL;
+
+	vclock->pclock = pclock;
+
+	vclock->info = ptp_vclock_info;
+	vclock->info.vclock_cc = vclock_cc;
+	snprintf(vclock->info.name, PTP_CLOCK_NAME_LEN,
+		 "virtual clock on ptp%d", pclock->index);
+
+	/* Copy members initial values of ptp_vclock_cc to ptp_vclock */
+	vclock->cc = vclock_cc->cc;
+	vclock->mult = vclock_cc->cc.mult;
+	vclock->refresh_interval = vclock_cc->refresh_interval;
+	vclock->mult_factor = vclock_cc->mult_factor;
+	vclock->div_factor = vclock_cc->div_factor;
+
+	spin_lock_init(&vclock->lock);
+
+	vclock->clock = ptp_clock_register(&vclock->info, pclock->dev.parent);
+	if (IS_ERR_OR_NULL(vclock->clock)) {
+		kfree(vclock);
+		return NULL;
+	}
+
+	timecounter_init(&vclock->tc, &vclock->cc,
+			 ktime_to_ns(ktime_get_real()));
+
+	INIT_DELAYED_WORK(&vclock->refresh_work, ptp_vclock_refresh);
+	schedule_delayed_work(&vclock->refresh_work, vclock->refresh_interval);
+
+	return vclock;
+}
+
+void ptp_vclock_unregister(struct ptp_vclock *vclock)
+{
+	cancel_delayed_work_sync(&vclock->refresh_work);
+	ptp_clock_unregister(vclock->clock);
+	kfree(vclock);
+}
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index a311bddd9e85..e4c1c6411e7d 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -3,6 +3,7 @@
  * PTP 1588 clock support
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
+ * Copyright 2021 NXP
  */
 
 #ifndef _PTP_CLOCK_KERNEL_H_
@@ -11,7 +12,9 @@
 #include <linux/device.h>
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock.h>
+#include <linux/timecounter.h>
 
+#define PTP_CLOCK_NAME_LEN	32
 /**
  * struct ptp_clock_request - request PTP clock event
  *
@@ -48,6 +51,32 @@ struct ptp_system_timestamp {
 	struct timespec64 post_ts;
 };
 
+/**
+ * struct ptp_vclock_cc - ptp virtual clock cycle counter info
+ *
+ * @cc:               cyclecounter structure
+ * @refresh_interval: time interval to refresh time counter, to avoid 64-bit
+ *                    overflow during delta conversion. For example, with
+ *                    cc.mult value 2^28,  there are 36 bits left of cycle
+ *                    counter. With 1 ns counter resolution, the overflow time
+ *                    is 2^36 ns which is 68.7 s. The refresh_interval may be
+ *                    (60 * HZ) less than 68.7 s.
+ * @mult_factor:      parameter for cc.mult adjustment calculation, see below
+ * @div_factor:       parameter for cc.mult adjustment calculation, see below
+ *
+ * scaled_ppm to adjustment of cc.mult
+ *
+ * adj = mult * (ppb / 10^9)
+ *     = mult * (scaled_ppm * 1000 / 2^16) / 10^9
+ *     = scaled_ppm * mult_factor / div_factor
+ */
+struct ptp_vclock_cc {
+	struct cyclecounter cc;
+	unsigned long refresh_interval;
+	u32 mult_factor;
+	u32 div_factor;
+};
+
 /**
  * struct ptp_clock_info - describes a PTP hardware clock
  *
@@ -64,6 +93,8 @@ struct ptp_system_timestamp {
  * @pin_config: Array of length 'n_pins'. If the number of
  *              programmable pins is nonzero, then drivers must
  *              allocate and initialize this array.
+ * @vclock_cc: ptp_vclock_cc structure pointer. Provide initial cyclecounter
+ *             info for ptp virtual clock. This is optional.
  *
  * clock operations
  *
@@ -134,7 +165,7 @@ struct ptp_system_timestamp {
 
 struct ptp_clock_info {
 	struct module *owner;
-	char name[16];
+	char name[PTP_CLOCK_NAME_LEN];
 	s32 max_adj;
 	int n_alarm;
 	int n_ext_ts;
@@ -142,6 +173,7 @@ struct ptp_clock_info {
 	int n_pins;
 	int pps;
 	struct ptp_pin_desc *pin_config;
+	struct ptp_vclock_cc *vclock_cc;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
 	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
 	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
@@ -304,6 +336,12 @@ int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay);
  */
 void ptp_cancel_worker_sync(struct ptp_clock *ptp);
 
+/**
+ * ptp_get_pclock_info() - get ptp_clock_info pointer of physical clock
+ *
+ * @cc:     cyclecounter pointer of ptp virtual clock.
+ */
+struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc);
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -324,6 +362,9 @@ static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
 
+static inline struct ptp_clock_info *ptp_get_pclock_info(
+	const struct cyclecounter *cc)
+{ return NULL; }
 #endif
 
 static inline void ptp_read_system_prets(struct ptp_system_timestamp *sts)
-- 
2.25.1

