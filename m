Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56963B7E78
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhF3IDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:03:55 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59332 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233207AbhF3IDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:03:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1AE65200720;
        Wed, 30 Jun 2021 10:01:22 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B02B6200698;
        Wed, 30 Jun 2021 10:01:21 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id B15C5183ACCB;
        Wed, 30 Jun 2021 16:01:19 +0800 (+08)
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
Subject: [net-next, v5, 02/11] ptp: support ptp physical/virtual clocks conversion
Date:   Wed, 30 Jun 2021 16:11:53 +0800
Message-Id: <20210630081202.4423-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210630081202.4423-1-yangbo.lu@nxp.com>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support ptp physical/virtual clocks conversion via sysfs.
There will be a new attribute n_vclocks under ptp physical
clock sysfs.

- In default, the value is 0 meaning only ptp physical clock
  is in use.
- Setting the value can create corresponding number of ptp
  virtual clocks to use. But current physical clock is guaranteed
  to stay free running.
- Setting the value back to 0 can delete virtual clocks and back
  use physical clock again.

Another new attribute max_vclocks control the maximum number of
ptp vclocks.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from v1 patch #2.
	- Converted to num_vclocks for creating virtual clocks.
	- Guranteed physical clock free running when using virtual
	  clocks.
	- Fixed build warning.
	- Updated copyright.
Changes for v3:
	- Protected concurrency of ptp->num_vclocks accessing.
Changes for v4:
	- Rephrased description in doc.
	- Used unsigned int for vclocks number, and max_vclocks
	  for limitiation.
	- Fixed mutex locking.
	- Other minor fixes.
Changes for v5:
	- Fixed checkpatch.
	- Checked pointer parent->class->name.
---
 Documentation/ABI/testing/sysfs-ptp |  20 ++++
 drivers/ptp/ptp_clock.c             |  26 ++++++
 drivers/ptp/ptp_private.h           |  21 +++++
 drivers/ptp/ptp_sysfs.c             | 138 ++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index 2363ad810ddb..d378f57c1b73 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -33,6 +33,13 @@ Description:
 		frequency adjustment value (a positive integer) in
 		parts per billion.
 
+What:		/sys/class/ptp/ptpN/max_vclocks
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This file contains the maximum number of ptp vclocks.
+		Write integer to re-configure it.
+
 What:		/sys/class/ptp/ptpN/n_alarms
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
@@ -61,6 +68,19 @@ Description:
 		This file contains the number of programmable pins
 		offered by the PTP hardware clock.
 
+What:		/sys/class/ptp/ptpN/n_vclocks
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This file contains the number of virtual PTP clocks in
+		use.  By default, the value is 0 meaning that only the
+		physical clock is in use.  Setting the value creates
+		the corresponding number of virtual clocks and causes
+		the physical clock to become free running.  Setting the
+		value back to 0 deletes the virtual clocks and
+		switches the physical clock back to normal, adjustable
+		operation.
+
 What:		/sys/class/ptp/ptpN/pins
 Date:		March 2014
 Contact:	Richard Cochran <richardcochran@gmail.com>
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index a23a37a4d5dc..7334f478dde7 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -76,6 +76,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
+	if (ptp_vclock_in_use(ptp)) {
+		pr_err("ptp: virtual clock in use\n");
+		return -EBUSY;
+	}
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -97,6 +102,11 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
+	if (ptp_vclock_in_use(ptp)) {
+		pr_err("ptp: virtual clock in use\n");
+		return -EBUSY;
+	}
+
 	ops = ptp->info;
 
 	if (tx->modes & ADJ_SETOFFSET) {
@@ -161,6 +171,7 @@ static void ptp_clock_release(struct device *dev)
 	ptp_cleanup_pin_groups(ptp);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
+	mutex_destroy(&ptp->n_vclocks_mux);
 	ida_simple_remove(&ptp_clocks_map, ptp->index);
 	kfree(ptp);
 }
@@ -208,6 +219,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	spin_lock_init(&ptp->tsevq.lock);
 	mutex_init(&ptp->tsevq_mux);
 	mutex_init(&ptp->pincfg_mux);
+	mutex_init(&ptp->n_vclocks_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
 
 	if (ptp->info->do_aux_work) {
@@ -221,6 +233,14 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 		ptp->pps_source->lookup_cookie = ptp;
 	}
 
+	/* PTP virtual clock is being registered under physical clock */
+	if (parent->class && parent->class->name &&
+	    strcmp(parent->class->name, "ptp") == 0)
+		ptp->is_virtual_clock = true;
+
+	if (!ptp->is_virtual_clock)
+		ptp->max_vclocks = PTP_DEFAULT_MAX_VCLOCKS;
+
 	err = ptp_populate_pin_groups(ptp);
 	if (err)
 		goto no_pin_groups;
@@ -270,6 +290,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 kworker_err:
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
+	mutex_destroy(&ptp->n_vclocks_mux);
 	ida_simple_remove(&ptp_clocks_map, index);
 no_slot:
 	kfree(ptp);
@@ -280,6 +301,11 @@ EXPORT_SYMBOL(ptp_clock_register);
 
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
+	if (ptp_vclock_in_use(ptp)) {
+		pr_err("ptp: virtual clock in use\n");
+		return -EBUSY;
+	}
+
 	ptp->defunct = 1;
 	wake_up_interruptible(&ptp->tsev_wq);
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 853b79b6b30e..87cb55953b69 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -18,6 +18,7 @@
 
 #define PTP_MAX_TIMESTAMPS 128
 #define PTP_BUF_TIMESTAMPS 30
+#define PTP_DEFAULT_MAX_VCLOCKS 20
 
 struct timestamp_event_queue {
 	struct ptp_extts_event buf[PTP_MAX_TIMESTAMPS];
@@ -46,6 +47,10 @@ struct ptp_clock {
 	const struct attribute_group *pin_attr_groups[2];
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work aux_work;
+	unsigned int max_vclocks;
+	unsigned int n_vclocks;
+	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
+	bool is_virtual_clock;
 };
 
 #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
@@ -74,6 +79,22 @@ static inline int queue_cnt(struct timestamp_event_queue *q)
 	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
 }
 
+/* Check if ptp virtual clock is in use */
+static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
+{
+	bool in_use = false;
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return true;
+
+	if (!ptp->is_virtual_clock && ptp->n_vclocks)
+		in_use = true;
+
+	mutex_unlock(&ptp->n_vclocks_mux);
+
+	return in_use;
+}
+
 /*
  * see ptp_chardev.c
  */
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be076a91e20e..0b05041783a5 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -3,6 +3,7 @@
  * PTP 1588 clock support - sysfs interface.
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
+ * Copyright 2021 NXP
  */
 #include <linux/capability.h>
 #include <linux/slab.h>
@@ -148,6 +149,137 @@ static ssize_t pps_enable_store(struct device *dev,
 }
 static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
 
+static int unregister_vclock(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	struct ptp_vclock *vclock;
+	u8 *num = data;
+
+	vclock = info_to_vclock(info);
+	dev_info(dev->parent, "delete virtual clock ptp%d\n",
+		 vclock->clock->index);
+
+	ptp_vclock_unregister(vclock);
+	(*num)--;
+
+	/* For break. Not error. */
+	if (*num == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static ssize_t n_vclocks_show(struct device *dev,
+			      struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	ssize_t size;
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return -ERESTARTSYS;
+
+	size = snprintf(page, PAGE_SIZE - 1, "%d\n", ptp->n_vclocks);
+
+	mutex_unlock(&ptp->n_vclocks_mux);
+
+	return size;
+}
+
+static ssize_t n_vclocks_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_vclock *vclock;
+	int err = -EINVAL;
+	u32 num, i;
+
+	if (kstrtou32(buf, 0, &num))
+		return err;
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return -ERESTARTSYS;
+
+	if (num > ptp->max_vclocks) {
+		dev_err(dev, "max value is %d\n", ptp->max_vclocks);
+		goto out;
+	}
+
+	/* Need to create more vclocks */
+	if (num > ptp->n_vclocks) {
+		for (i = 0; i < num - ptp->n_vclocks; i++) {
+			vclock = ptp_vclock_register(ptp);
+			if (!vclock)
+				goto out;
+
+			dev_info(dev, "new virtual clock ptp%d\n",
+				 vclock->clock->index);
+		}
+	}
+
+	/* Need to delete vclocks */
+	if (num < ptp->n_vclocks) {
+		i = ptp->n_vclocks - num;
+		device_for_each_child_reverse(dev, &i,
+					      unregister_vclock);
+	}
+
+	if (num == 0)
+		dev_info(dev, "only physical clock in use now\n");
+	else
+		dev_info(dev, "guarantee physical clock free running\n");
+
+	ptp->n_vclocks = num;
+	mutex_unlock(&ptp->n_vclocks_mux);
+
+	return count;
+out:
+	mutex_unlock(&ptp->n_vclocks_mux);
+	return err;
+}
+static DEVICE_ATTR_RW(n_vclocks);
+
+static ssize_t max_vclocks_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	ssize_t size;
+
+	size = snprintf(page, PAGE_SIZE - 1, "%d\n", ptp->max_vclocks);
+
+	return size;
+}
+
+static ssize_t max_vclocks_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	u32 max;
+
+	if (kstrtou32(buf, 0, &max) || max == 0)
+		return -EINVAL;
+
+	if (max == ptp->max_vclocks)
+		return count;
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return -ERESTARTSYS;
+
+	if (max < ptp->n_vclocks) {
+		mutex_unlock(&ptp->n_vclocks_mux);
+		return -EINVAL;
+	}
+
+	ptp->max_vclocks = max;
+
+	mutex_unlock(&ptp->n_vclocks_mux);
+
+	return count;
+}
+static DEVICE_ATTR_RW(max_vclocks);
+
 static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
 
@@ -162,6 +294,8 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_fifo.attr,
 	&dev_attr_period.attr,
 	&dev_attr_pps_enable.attr,
+	&dev_attr_n_vclocks.attr,
+	&dev_attr_max_vclocks.attr,
 	NULL
 };
 
@@ -183,6 +317,10 @@ static umode_t ptp_is_attribute_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_pps_enable.attr) {
 		if (!info->pps)
 			mode = 0;
+	} else if (attr == &dev_attr_n_vclocks.attr ||
+		   attr == &dev_attr_max_vclocks.attr) {
+		if (ptp->is_virtual_clock)
+			mode = 0;
 	}
 
 	return mode;
-- 
2.25.1

