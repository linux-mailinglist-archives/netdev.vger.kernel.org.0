Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3563938BD67
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhEUE2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:40 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52448 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239054AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CB426202EF3;
        Fri, 21 May 2021 06:26:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com CB426202EF3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector4; t=1621571189;
        bh=hoUYGy9nnJnFlkjcdb6m6crgv00+bIpL9Gcfu+ehN+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNHCiArtWYXEfh/D5qAs+f6T+oe9XbUT72e1VWWlcWIEzPQVtJP8UGsStnrAl6Nyz
         vJNGMwDJCzL43P3ESBdsACRWBVy84Syvvf908Lt/HYP5N5S4c1xGB30uNv5F6bx5jU
         3vr6a5rws/zV1EZ7mKXPfc4fKLpZ2UJ0Jdqv4x1DOOKCV26miU+/AKMdW8aAi1eF0H
         E/Vn/TEeRNNCKR6HLSTPOvnBB2H7SChW0lkh14APoyp9BssgVdhjSg5IZRph/KAbCe
         MtgcDzcaLsWRKgo6/VoCZCN4pV58B/iTInXfnxBIUTX816n6ecamSir1FuLLTmEO0X
         pnubtSPZ/zvqQ==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ECAF42006B6;
        Fri, 21 May 2021 06:26:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com ECAF42006B6
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A672640280;
        Fri, 21 May 2021 12:26:23 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks conversion
Date:   Fri, 21 May 2021 12:36:14 +0800
Message-Id: <20210521043619.44694-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support ptp physical/virtual clocks conversion via sysfs.
There will be a new attribute num_vclocks under ptp physical
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
---
 Documentation/ABI/testing/sysfs-ptp | 13 +++++
 drivers/ptp/ptp_clock.c             | 11 ++++
 drivers/ptp/ptp_private.h           | 13 +++++
 drivers/ptp/ptp_sysfs.c             | 79 +++++++++++++++++++++++++++++
 drivers/ptp/ptp_vclock.c            |  1 +
 include/linux/ptp_clock_kernel.h    |  1 +
 6 files changed, 118 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index 2363ad810ddb..6403e746eeb4 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -61,6 +61,19 @@ Description:
 		This file contains the number of programmable pins
 		offered by the PTP hardware clock.
 
+What:		/sys/class/ptp/ptpN/num_vclocks
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
index a780435331c8..9b8ab1e6625f 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -3,6 +3,7 @@
  * PTP 1588 clock support
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
+ * Copyright 2021 NXP
  */
 #include <linux/idr.h>
 #include <linux/device.h>
@@ -76,6 +77,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
+	if (ptp_guarantee_pclock(ptp)) {
+		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
+		return -EBUSY;
+	}
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -97,6 +103,11 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
+	if (ptp_guarantee_pclock(ptp)) {
+		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
+		return -EBUSY;
+	}
+
 	ops = ptp->info;
 
 	if (tx->modes & ADJ_SETOFFSET) {
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 870e54506781..da24d0c83799 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -47,6 +47,7 @@ struct ptp_clock {
 	const struct attribute_group *pin_attr_groups[2];
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work aux_work;
+	u8 num_vclocks;
 };
 
 #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
@@ -82,6 +83,18 @@ static inline int queue_cnt(struct timestamp_event_queue *q)
 	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
 }
 
+/*
+ * Guarantee physical clock to stay free running, if ptp virtual clocks
+ * on it are in use.
+ */
+static inline bool ptp_guarantee_pclock(struct ptp_clock *ptp)
+{
+	if (!ptp->info->vclock_flag && ptp->num_vclocks)
+		return true;
+
+	return false;
+}
+
 /*
  * see ptp_chardev.c
  */
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be076a91e20e..5e1b5947dbff 100644
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
@@ -148,6 +149,80 @@ static ssize_t pps_enable_store(struct device *dev,
 }
 static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
 
+static int unregister_vclock(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	struct ptp_vclock *vclock;
+	u8 *num = data;
+
+	if (info->vclock_flag) {
+		vclock = info_to_vclock(info);
+		dev_info(&vclock->pclock->dev, "delete virtual clock ptp%d\n",
+			 vclock->clock->index);
+		ptp_vclock_unregister(vclock);
+		(*num)--;
+	}
+
+	/* For break. Not error. */
+	if (*num == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static ssize_t num_vclocks_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->num_vclocks);
+}
+
+static ssize_t num_vclocks_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_vclock *vclock;
+	int err = -EINVAL;
+	u8 num, i;
+
+	if (kstrtou8(buf, 0, &num))
+		goto out;
+
+	/* Need to create more vclocks */
+	if (num > ptp->num_vclocks) {
+		for (i = 0; i < num - ptp->num_vclocks; i++) {
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
+	if (num < ptp->num_vclocks) {
+		i = ptp->num_vclocks - num;
+		device_for_each_child_reverse(dev->parent, &i,
+					      unregister_vclock);
+	}
+
+	if (num == 0)
+		dev_info(dev, "only physical clock in use now\n");
+	else
+		dev_info(dev, "guarantee physical clock free running\n");
+
+	ptp->num_vclocks = num;
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_RW(num_vclocks);
+
 static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
 
@@ -162,6 +237,7 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_fifo.attr,
 	&dev_attr_period.attr,
 	&dev_attr_pps_enable.attr,
+	&dev_attr_num_vclocks.attr,
 	NULL
 };
 
@@ -183,6 +259,9 @@ static umode_t ptp_is_attribute_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_pps_enable.attr) {
 		if (!info->pps)
 			mode = 0;
+	} else if (attr == &dev_attr_num_vclocks.attr) {
+		if (info->vclock_flag || !info->vclock_cc)
+			mode = 0;
 	}
 
 	return mode;
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 70aae8696003..fce09f10ae69 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -68,6 +68,7 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 static const struct ptp_clock_info ptp_vclock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ptp virtual clock",
+	.vclock_flag	= true,
 	/* The maximum ppb value that long scaled_ppm can support */
 	.max_adj	= 32767999,
 	.adjfine	= ptp_vclock_adjfine,
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index e4c1c6411e7d..8f34f192f2cf 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -174,6 +174,7 @@ struct ptp_clock_info {
 	int pps;
 	struct ptp_pin_desc *pin_config;
 	struct ptp_vclock_cc *vclock_cc;
+	bool vclock_flag;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
 	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
 	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
-- 
2.25.1

