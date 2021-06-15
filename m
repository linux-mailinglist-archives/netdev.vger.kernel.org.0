Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084BC3A7ACC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhFOJiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:46 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56468 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhFOJil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6B9F01A29D4;
        Tue, 15 Jun 2021 11:36:35 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 299DB1A16D4;
        Tue, 15 Jun 2021 11:36:29 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 865B240327;
        Tue, 15 Jun 2021 17:36:21 +0800 (+08)
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
Subject: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks conversion
Date:   Tue, 15 Jun 2021 17:45:09 +0800
Message-Id: <20210615094517.48752-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
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
---
 Documentation/ABI/testing/sysfs-ptp | 13 +++++
 drivers/ptp/ptp_clock.c             | 22 +++++++
 drivers/ptp/ptp_private.h           | 15 +++++
 drivers/ptp/ptp_sysfs.c             | 89 +++++++++++++++++++++++++++++
 include/uapi/linux/ptp_clock.h      |  5 ++
 5 files changed, 144 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index 2363ad810ddb..2ef11b775f47 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -61,6 +61,19 @@ Description:
 		This file contains the number of programmable pins
 		offered by the PTP hardware clock.
 
+What:		/sys/class/ptp/ptpN/n_vclocks
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This file contains the ptp virtual clocks number in use,
+		based on current ptp physical clock. In default, the
+		value is 0 meaning only ptp physical clock is in use.
+		Setting the value can create corresponding number of ptp
+		virtual clocks to use. But current ptp physical clock is
+		guaranteed to stay free running. Setting the value back
+		to 0 can delete ptp virtual clocks and back use ptp
+		physical clock again.
+
 What:		/sys/class/ptp/ptpN/pins
 Date:		March 2014
 Contact:	Richard Cochran <richardcochran@gmail.com>
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index a780435331c8..78414b3e16dd 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -76,6 +76,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
+	if (ptp_guaranteed_pclock(ptp)) {
+		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
+		return -EBUSY;
+	}
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -97,6 +102,11 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
+	if (ptp_guaranteed_pclock(ptp)) {
+		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
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
@@ -220,6 +232,10 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 		}
 	}
 
+	/* PTP virtual clock is being registered under physical clock */
+	if (parent->class && strcmp(parent->class->name, "ptp") == 0)
+		ptp->vclock_flag = true;
+
 	err = ptp_populate_pin_groups(ptp);
 	if (err)
 		goto no_pin_groups;
@@ -269,6 +285,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 kworker_err:
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
+	mutex_destroy(&ptp->n_vclocks_mux);
 	ida_simple_remove(&ptp_clocks_map, index);
 no_slot:
 	kfree(ptp);
@@ -279,6 +296,11 @@ EXPORT_SYMBOL(ptp_clock_register);
 
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
+	if (ptp_guaranteed_pclock(ptp)) {
+		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
+		return -EBUSY;
+	}
+
 	ptp->defunct = 1;
 	wake_up_interruptible(&ptp->tsev_wq);
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 3f388d63904c..6949afc9d733 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -46,6 +46,9 @@ struct ptp_clock {
 	const struct attribute_group *pin_attr_groups[2];
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work aux_work;
+	u8 n_vclocks;
+	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
+	bool vclock_flag;
 };
 
 #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
@@ -75,6 +78,18 @@ static inline int queue_cnt(struct timestamp_event_queue *q)
 	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
 }
 
+/*
+ * Guarantee physical clock to stay free running, if ptp virtual clocks
+ * on it are in use.
+ */
+static inline bool ptp_guaranteed_pclock(struct ptp_clock *ptp)
+{
+	if (!ptp->vclock_flag && ptp->n_vclocks)
+		return true;
+
+	return false;
+}
+
 /*
  * see ptp_chardev.c
  */
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be076a91e20e..600edd7a90af 100644
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
@@ -148,6 +149,90 @@ static ssize_t pps_enable_store(struct device *dev,
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
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->n_vclocks);
+}
+
+static ssize_t n_vclocks_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_vclock *vclock;
+	int err = -EINVAL;
+	u8 num, i;
+
+	if (kstrtou8(buf, 0, &num))
+		goto out;
+
+	if (num > PTP_MAX_VCLOCKS) {
+		dev_err(dev, "max value is %d\n", PTP_MAX_VCLOCKS);
+		goto out;
+	}
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return -ERESTARTSYS;
+
+	/* Need to create more vclocks */
+	if (num > ptp->n_vclocks) {
+		for (i = 0; i < num - ptp->n_vclocks; i++) {
+			vclock = ptp_vclock_register(ptp);
+			if (!vclock) {
+				mutex_unlock(&ptp->n_vclocks_mux);
+				goto out;
+			}
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
+	return err;
+}
+static DEVICE_ATTR_RW(n_vclocks);
+
 static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
 
@@ -162,6 +247,7 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_fifo.attr,
 	&dev_attr_period.attr,
 	&dev_attr_pps_enable.attr,
+	&dev_attr_n_vclocks.attr,
 	NULL
 };
 
@@ -183,6 +269,9 @@ static umode_t ptp_is_attribute_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_pps_enable.attr) {
 		if (!info->pps)
 			mode = 0;
+	} else if (attr == &dev_attr_n_vclocks.attr) {
+		if (ptp->vclock_flag)
+			mode = 0;
 	}
 
 	return mode;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1d108d597f66..4b933dc1b81b 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -69,6 +69,11 @@
  */
 #define PTP_PEROUT_V1_VALID_FLAGS	(0)
 
+/*
+ * Max number of PTP virtual clocks per PTP physical clock
+ */
+#define PTP_MAX_VCLOCKS			20
+
 /*
  * struct ptp_clock_time - represents a time value
  *
-- 
2.25.1

