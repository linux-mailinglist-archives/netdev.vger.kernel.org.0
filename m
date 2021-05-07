Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0B37624E
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbhEGIsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59670 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236422AbhEGIsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:46 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 484B81A19CC;
        Fri,  7 May 2021 10:47:46 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B3AE1A19C3;
        Fri,  7 May 2021 10:47:43 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 53074402CF;
        Fri,  7 May 2021 10:47:39 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 1/6] ptp: add ptp virtual clock driver framework
Date:   Fri,  7 May 2021 16:57:51 +0800
Message-Id: <20210507085756.20427-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add ptp virtual clock driver framework. The main purpose
is to support PTP multiple domains over multiple PTP virtual clocks with
only single physical clock.

What has the patch exported,

- ptp_vclock_cc structure for specifying cyclecounter information that ptp
  virtual clocks will use. When registering ptp clock for physical clock,
  the ptp virtual clock will be valid to register if the pointer of
  ptp_vclock_cc structure is provided in ptp_clock_info of physical clock.

- ptp_vclock_register/ptp_vclock_unregister APIs for ptp virtual clock
  register/unregister for specified domain number. They are private for ptp
  driver.

- ptp_clock_domain_tstamp API to convert hardware time stamp to domain time
  stamp.

- ptp_get_pclock_info API for device driver to get ptp_clock_info pointer
  of physical clock from cyclecounter pointer of ptp virtual clock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 MAINTAINERS                      |   6 ++
 drivers/ptp/Makefile             |   2 +-
 drivers/ptp/ptp_private.h        |  25 +++++
 drivers/ptp/ptp_vclock.c         | 176 +++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h |  51 +++++++++
 5 files changed, 259 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ptp/ptp_vclock.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4796ccf9f871..9f9280b29e47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14733,6 +14733,12 @@ F:	drivers/net/phy/dp83640*
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
index db5aef3bddc6..3c75d7de7793 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -3,7 +3,7 @@
 # Makefile for PTP 1588 clock support.
 #
 
-ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
+ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o ptp_vclock.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 6b97155148f1..9ff0afc57a7f 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -48,6 +48,29 @@ struct ptp_clock {
 	struct kthread_delayed_work aux_work;
 };
 
+#define cc_to_vclock(d) container_of((d), struct ptp_vclock, cc)
+#define dw_to_vclock(d) container_of((d), struct ptp_vclock, refresh_work)
+#define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
+
+struct ptp_vclock {
+	struct ptp_clock *pclock;
+	struct ptp_clock_info info;
+	struct ptp_clock *clock;
+	struct cyclecounter cc;
+	struct timecounter tc;
+	spinlock_t lock;	/* protects tc/cc */
+	struct delayed_work refresh_work;
+	unsigned long refresh_interval;
+	u32 mult;
+	u32 mult_num;
+	u32 mult_dem;
+};
+
+struct domain_tstamp {
+	u64 tstamp;
+	u8 domain;
+};
+
 /*
  * The function queue_cnt() is safe for readers to call without
  * holding q->lock. Readers use this function to verify that the queue
@@ -89,4 +112,6 @@ extern const struct attribute_group *ptp_groups[];
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
 
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock, u8 domain);
+void ptp_vclock_unregister(struct ptp_vclock *vclock);
 #endif
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
new file mode 100644
index 000000000000..765acc0f7576
--- /dev/null
+++ b/drivers/ptp/ptp_vclock.c
@@ -0,0 +1,176 @@
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
+	s64 mult_adj;
+
+	mult_adj = (s64)scaled_ppm * vclock->mult_num;
+	mult_adj = div_s64(mult_adj, vclock->mult_dem);
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	timecounter_read(&vclock->tc);
+	vclock->cc.mult = vclock->mult + mult_adj;
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
+	.name		= "ptp vclock",
+	.adjfine	= ptp_vclock_adjfine,
+	.adjtime	= ptp_vclock_adjtime,
+	.gettime64	= ptp_vclock_gettime,
+	.settime64	= ptp_vclock_settime,
+	.max_adj	= 32000000,
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
+static int ptp_clock_find_domain_tstamp(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	struct domain_tstamp *domain_ts = data;
+	struct ptp_vclock *vclock;
+	unsigned long flags;
+
+	if (!info->is_vclock)
+		return 0;
+
+	/* Convert to domain tstamp if there is a domain matched */
+	if (info->domain == domain_ts->domain) {
+		vclock = info_to_vclock(info);
+		spin_lock_irqsave(&vclock->lock, flags);
+		domain_ts->tstamp = timecounter_cyc2time(&vclock->tc, domain_ts->tstamp);
+		spin_unlock_irqrestore(&vclock->lock, flags);
+		/* For break. Not error. */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void ptp_clock_domain_tstamp(struct device *dev, u64 *tstamp, u8 domain)
+{
+	struct domain_tstamp domain_ts;
+
+	domain_ts.tstamp = *tstamp;
+	domain_ts.domain = domain;
+
+	device_for_each_child(dev, &domain_ts, ptp_clock_find_domain_tstamp);
+	*tstamp = domain_ts.tstamp;
+}
+EXPORT_SYMBOL(ptp_clock_domain_tstamp);
+
+struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc)
+{
+	struct ptp_vclock *vclock = cc_to_vclock(cc);
+
+	return vclock->pclock->info;
+}
+EXPORT_SYMBOL(ptp_get_pclock_info);
+
+struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock, u8 domain)
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
+	vclock->info.is_vclock = true;
+	vclock->info.domain = domain;
+
+	vclock->cc = vclock_cc->cc;
+	vclock->mult = vclock_cc->cc.mult;
+	vclock->refresh_interval = vclock_cc->refresh_interval;
+	vclock->mult_num = vclock_cc->mult_num;
+	vclock->mult_dem = vclock_cc->mult_dem;
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
index 0d47fd33b228..b2823af9b150 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -48,6 +48,32 @@ struct ptp_system_timestamp {
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
+ * @mult_num:         parameter for cc.mult adjustment calculation, see below
+ * @mult_dem:         parameter for cc.mult adjustment calculation, see below
+ *
+ * scaled_ppm to adjustment(mult_adj) of cc.mult
+ *
+ * mult_adj = mult * (ppb / 10^9)
+ *          = mult * (scaled_ppm * 1000 / 2^16) / 10^9
+ *          = scaled_ppm * mult_num / mult_dem
+ */
+struct ptp_vclock_cc {
+	struct cyclecounter cc;
+	unsigned long refresh_interval;
+	u32 mult_num;
+	u32 mult_dem;
+};
+
 /**
  * struct ptp_clock_info - describes a PTP hardware clock
  *
@@ -157,6 +183,11 @@ struct ptp_clock_info {
 	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
 		      enum ptp_pin_function func, unsigned int chan);
 	long (*do_aux_work)(struct ptp_clock_info *ptp);
+
+	/* For virtual clock */
+	struct ptp_vclock_cc *vclock_cc;
+	u8 domain;
+	bool is_vclock;
 };
 
 struct ptp_clock;
@@ -286,6 +317,21 @@ int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay);
  */
 void ptp_cancel_worker_sync(struct ptp_clock *ptp);
 
+/**
+ * ptp_get_pclock_info() - get ptp_clock_info pointer of physical clock
+ *
+ * @cc:     cyclecounter pointer of ptp virtual clock.
+ */
+struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc);
+
+/**
+ * ptp_clock_domain_tstamp() - convert to domain time stamp
+ *
+ * @dev:     device pointer of current ptp clock.
+ * @tstamp:  time stamp pointer to hardware time stamp
+ * @domain:  domain number to convert
+ */
+void ptp_clock_domain_tstamp(struct device *dev, u64 *tstamp, u8 domain);
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -306,6 +352,11 @@ static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
 
+static inline struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc);
+{ return NULL; }
+
+void ptp_clock_domain_tstamp(struct device *dev, u64 *tstamp, u8 domain)
+{ }
 #endif
 
 static inline void ptp_read_system_prets(struct ptp_system_timestamp *sts)
-- 
2.25.1

