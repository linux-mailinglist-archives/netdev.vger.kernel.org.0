Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD643A7AC8
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhFOJil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41828 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhFOJij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:39 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C661B2015F5;
        Tue, 15 Jun 2021 11:36:33 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 82CF62015FA;
        Tue, 15 Jun 2021 11:36:27 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id E3FEB40326;
        Tue, 15 Jun 2021 17:36:19 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v3, 01/10] ptp: add ptp virtual clock driver framework
Date:   Tue, 15 Jun 2021 17:45:08 +0800
Message-Id: <20210615094517.48752-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add ptp virtual clock driver framework
utilizing timecounter/cyclecounter.

The patch just exports two essential APIs for PTP driver.

- ptp_vclock_register()
- ptp_vclock_unregister()

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from v1 patch #1.
	- Fixed build warning.
	- Updated copyright.
Changes for v3:
	- Supported PTP virtual clock in default in PTP driver.
---
 drivers/ptp/Makefile             |   2 +-
 drivers/ptp/ptp_private.h        |  16 ++++
 drivers/ptp/ptp_vclock.c         | 154 +++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h |   4 +-
 4 files changed, 174 insertions(+), 2 deletions(-)
 create mode 100644 drivers/ptp/ptp_vclock.c

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
index 6b97155148f1..3f388d63904c 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -48,6 +48,20 @@ struct ptp_clock {
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
+	struct cyclecounter cc;
+	struct timecounter tc;
+	spinlock_t lock;	/* protects tc/cc */
+	struct delayed_work refresh_work;
+};
+
 /*
  * The function queue_cnt() is safe for readers to call without
  * holding q->lock. Readers use this function to verify that the queue
@@ -89,4 +103,6 @@ extern const struct attribute_group *ptp_groups[];
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
 
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock);
+void ptp_vclock_unregister(struct ptp_vclock *vclock);
 #endif
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
new file mode 100644
index 000000000000..b8f500677314
--- /dev/null
+++ b/drivers/ptp/ptp_vclock.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PTP virtual clock driver
+ *
+ * Copyright 2021 NXP
+ */
+#include <linux/slab.h>
+#include "ptp_private.h"
+
+#define PTP_VCLOCK_CC_MULT		(1 << 31)
+#define PTP_VCLOCK_CC_SHIFT		31
+#define PTP_VCLOCK_CC_MULT_NUM		(1 << 9)
+#define PTP_VCLOCK_CC_MULT_DEM		15625ULL
+#define PTP_VCLOCK_CC_REFRESH_INTERVAL	(HZ * 2)
+
+static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	unsigned long flags;
+	s64 adj;
+
+	adj = (s64)scaled_ppm * PTP_VCLOCK_CC_MULT_NUM;
+	adj = div_s64(adj, PTP_VCLOCK_CC_MULT_DEM);
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	timecounter_read(&vclock->tc);
+	vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
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
+	schedule_delayed_work(&vclock->refresh_work,
+			      PTP_VCLOCK_CC_REFRESH_INTERVAL);
+}
+
+static u64 ptp_vclock_read(const struct cyclecounter *cc)
+{
+	struct ptp_vclock *vclock = cc_to_vclock(cc);
+	struct ptp_clock *ptp = vclock->pclock;
+	struct timespec64 ts = {};
+
+	if (ptp->info->gettimex64)
+		ptp->info->gettimex64(ptp->info, &ts, NULL);
+	else
+		ptp->info->gettime64(ptp->info, &ts);
+
+	return timespec64_to_ns(&ts);
+}
+
+static const struct cyclecounter ptp_vclock_cc = {
+	.read	= ptp_vclock_read,
+	.mask	= CYCLECOUNTER_MASK(32),
+	.mult	= PTP_VCLOCK_CC_MULT,
+	.shift	= PTP_VCLOCK_CC_SHIFT,
+};
+
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
+{
+	struct ptp_vclock *vclock;
+
+	vclock = kzalloc(sizeof(*vclock), GFP_KERNEL);
+	if (!vclock)
+		return NULL;
+
+	vclock->pclock = pclock;
+	vclock->info = ptp_vclock_info;
+	vclock->cc = ptp_vclock_cc;
+
+	snprintf(vclock->info.name, PTP_CLOCK_NAME_LEN, "ptp%d_virt",
+		 pclock->index);
+
+	spin_lock_init(&vclock->lock);
+
+	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
+	if (IS_ERR_OR_NULL(vclock->clock)) {
+		kfree(vclock);
+		return NULL;
+	}
+
+	timecounter_init(&vclock->tc, &vclock->cc, 0);
+
+	INIT_DELAYED_WORK(&vclock->refresh_work, ptp_vclock_refresh);
+	schedule_delayed_work(&vclock->refresh_work,
+			      PTP_VCLOCK_CC_REFRESH_INTERVAL);
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
index a311bddd9e85..af12cc1e76d7 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -11,7 +11,9 @@
 #include <linux/device.h>
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock.h>
+#include <linux/timecounter.h>
 
+#define PTP_CLOCK_NAME_LEN	32
 /**
  * struct ptp_clock_request - request PTP clock event
  *
@@ -134,7 +136,7 @@ struct ptp_system_timestamp {
 
 struct ptp_clock_info {
 	struct module *owner;
-	char name[16];
+	char name[PTP_CLOCK_NAME_LEN];
 	s32 max_adj;
 	int n_alarm;
 	int n_ext_ts;
-- 
2.25.1

