Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B7238BD6A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbhEUE2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:44 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52466 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239056AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 90E22202EF4;
        Fri, 21 May 2021 06:26:30 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 90E22202EF4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector4; t=1621571190;
        bh=JXllx/O7GZHB4piX09sK6Og9wRNio96Vg2ZN46xlKNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR2bTUTks7aTNCVyibTrYJgBOtUaRZJ+1+ZUj2Qw7wWD5TEb4zy0hHwW+oMS6wZjK
         aDboBqBl0mydTwxSYT6K1kUO1Ppkhrp0rle6bOD5KaZxREPRo/3pjgBEl5Zm9Y0doU
         6FU9a+qjmGZmvG8rTf0cjCY30Kifoijwqw+sA7EsdCMHUgKpryjF1LiTLr/ImZGRWr
         IeqvDigNs/is7lajTdrIxHuJNryUA9BYNpeJetvHPdOWO2mzaM/g84Aa+KcCiOi79r
         H9HwOTIpUa4rfUarpU6d3ZlfLdftlVK9S972xPu0qKI9WKkUI/pkAOPtRRwEOEPjuv
         lQMzf6/YJTmKg==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B1CE9202EEF;
        Fri, 21 May 2021 06:26:27 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com B1CE9202EEF
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 69CCA40299;
        Fri, 21 May 2021 12:26:24 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 3/7] ptp: support domains and timestamp conversion
Date:   Fri, 21 May 2021 12:36:15 +0800
Message-Id: <20210521043619.44694-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP virtual clocks support is actually for multiple domains
synchronization.

This patch is to support configuring domain value for PTP
virtual clock via sysfs and to support hardware timestamp
conversion to domain time. The idea is driver identifying
PTP message domain number, matching with PTP virtual clock
which has same domain number configured, and then converting
to the PTP virtual clock time. The identifying could be in
MAC driver, the matching and converting is through the API
this patch added which can be called by MAC driver,

- ptp_clock_domain_tstamp()

Different domain values should be configured for multiple ptp
virtual clocks based on same one free running ptp physical clock.
If ptp message domain value has no PTP clock matched, the
original hardware timestamp will be used.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from v1 patch #1 and #2.
	- Fixed build warning.
---
 Documentation/ABI/testing/sysfs-ptp | 12 +++++++
 drivers/ptp/ptp_clock.c             |  1 +
 drivers/ptp/ptp_private.h           |  6 ++++
 drivers/ptp/ptp_sysfs.c             | 55 +++++++++++++++++++++++++++++
 drivers/ptp/ptp_vclock.c            | 33 +++++++++++++++++
 include/linux/ptp_clock_kernel.h    | 13 +++++++
 6 files changed, 120 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index 6403e746eeb4..7a518185cb11 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -25,6 +25,18 @@ Description:
 		MAC based ones. The string does not necessarily have
 		to be any kind of unique id.
 
+What:		/sys/class/ptp/ptpN/domain
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This file contains the domain value that the PTP virtual
+		clock serves. PTP virtual clock will provide timestamp
+		to PTP messages which have same domain matched.
+		Write value 0 ~ 255 into this file to change the domain.
+		Writing -1 means serving no domain. If PTP message domain
+		value does not have a PTP virtual clock matched, the
+		original hardware time stamp will be used.
+
 What:		/sys/class/ptp/ptpN/max_adjustment
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 9b8ab1e6625f..4ad20b2aae57 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -216,6 +216,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	ptp->info = info;
 	ptp->devid = MKDEV(major, index);
 	ptp->index = index;
+	ptp->domain = -1;	/* No domain set */
 	spin_lock_init(&ptp->tsevq.lock);
 	mutex_init(&ptp->tsevq_mux);
 	mutex_init(&ptp->pincfg_mux);
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index da24d0c83799..fe8f976b7b75 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -48,6 +48,7 @@ struct ptp_clock {
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work aux_work;
 	u8 num_vclocks;
+	int16_t domain;
 };
 
 #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
@@ -70,6 +71,11 @@ struct ptp_vclock {
 	u32 div_factor;
 };
 
+struct domain_tstamp {
+	u64 tstamp;
+	u8 domain;
+};
+
 /*
  * The function queue_cnt() is safe for readers to call without
  * holding q->lock. Readers use this function to verify that the queue
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 5e1b5947dbff..b854661aadeb 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -223,6 +223,57 @@ static ssize_t num_vclocks_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(num_vclocks);
 
+static int check_domain_avail(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	int16_t *domain = data;
+
+	if (ptp->domain == *domain)
+		return -EINVAL;
+
+	return 0;
+}
+
+static ssize_t domain_show(struct device *dev,
+			   struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->domain);
+}
+
+static ssize_t domain_store(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	int err = -EINVAL;
+	int16_t domain;
+
+	if (kstrtos16(buf, 0, &domain))
+		goto out;
+
+	if (domain > 255 || domain < -1)
+		goto out;
+
+	if (domain == -1) {
+		ptp->domain = -1;
+		return count;
+	}
+
+	if (device_for_each_child(dev->parent, &domain, check_domain_avail)) {
+		dev_err(dev, "the domain value already in used\n");
+		goto out;
+	}
+
+	ptp->domain = domain;
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_RW(domain);
+
 static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
 
@@ -238,6 +289,7 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_period.attr,
 	&dev_attr_pps_enable.attr,
 	&dev_attr_num_vclocks.attr,
+	&dev_attr_domain.attr,
 	NULL
 };
 
@@ -262,6 +314,9 @@ static umode_t ptp_is_attribute_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_num_vclocks.attr) {
 		if (info->vclock_flag || !info->vclock_cc)
 			mode = 0;
+	} else if (attr == &dev_attr_domain.attr) {
+		if (!info->vclock_flag)
+			mode = 0;
 	}
 
 	return mode;
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index fce09f10ae69..6e7d1403d024 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -87,6 +87,39 @@ static void ptp_vclock_refresh(struct work_struct *work)
 	schedule_delayed_work(&vclock->refresh_work, vclock->refresh_interval);
 }
 
+static int ptp_convert_domain_tstamp(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	struct domain_tstamp *domain_ts = data;
+	struct ptp_vclock *vclock;
+	unsigned long flags;
+
+	/* Convert to domain tstamp if there is a domain matched */
+	if (ptp->domain == domain_ts->domain) {
+		vclock = info_to_vclock(info);
+		spin_lock_irqsave(&vclock->lock, flags);
+		domain_ts->tstamp = timecounter_cyc2time(&vclock->tc,
+							 domain_ts->tstamp);
+		spin_unlock_irqrestore(&vclock->lock, flags);
+		return -EINVAL;	/* For break. Not error. */
+	}
+
+	return 0;
+}
+
+void ptp_clock_domain_tstamp(struct device *ptp_dev, u64 *tstamp, u8 domain)
+{
+	struct domain_tstamp domain_ts;
+
+	domain_ts.tstamp = *tstamp;
+	domain_ts.domain = domain;
+
+	device_for_each_child(ptp_dev, &domain_ts, ptp_convert_domain_tstamp);
+	*tstamp = domain_ts.tstamp;
+}
+EXPORT_SYMBOL(ptp_clock_domain_tstamp);
+
 struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc)
 {
 	struct ptp_vclock *vclock = cc_to_vclock(cc);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 8f34f192f2cf..edc816cdfb2c 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -343,6 +343,15 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp);
  * @cc:     cyclecounter pointer of ptp virtual clock.
  */
 struct ptp_clock_info *ptp_get_pclock_info(const struct cyclecounter *cc);
+
+/**
+ * ptp_clock_domain_tstamp() - convert to domain timestamp
+ *
+ * @ptp_dev: device pointer of current ptp clock.
+ * @tstamp:  time stamp pointer to hardware time stamp
+ * @domain:  domain number to convert
+ */
+void ptp_clock_domain_tstamp(struct device *ptp_dev, u64 *tstamp, u8 domain);
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -366,6 +375,10 @@ static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 static inline struct ptp_clock_info *ptp_get_pclock_info(
 	const struct cyclecounter *cc)
 { return NULL; }
+
+static inline void ptp_clock_domain_tstamp(struct device *dev, u64 *tstamp,
+					   u8 domain)
+{ }
 #endif
 
 static inline void ptp_read_system_prets(struct ptp_system_timestamp *sts)
-- 
2.25.1

