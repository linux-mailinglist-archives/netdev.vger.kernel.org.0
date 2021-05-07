Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F83B37624F
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhEGIsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:52 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59710 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhEGIsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 57FD61A19D1;
        Fri,  7 May 2021 10:47:47 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 771531A09DC;
        Fri,  7 May 2021 10:47:44 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4261340307;
        Fri,  7 May 2021 10:47:40 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 2/6] ptp: support virtual clock and domain via sysfs
Date:   Fri,  7 May 2021 16:57:52 +0800
Message-Id: <20210507085756.20427-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for virtual clock and domain via sysfs. Attributes
new_vclock_domain/delete_vclock_domain are to create/remove ptp
virtual clock. Attribute domain is to change domain value of the
ptp clock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 Documentation/ABI/testing/sysfs-ptp |  25 ++++++
 drivers/ptp/ptp_sysfs.c             | 122 ++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index 2363ad810ddb..9c419c5554b5 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -25,6 +25,23 @@ Description:
 		MAC based ones. The string does not necessarily have
 		to be any kind of unique id.
 
+What:		/sys/class/ptp/ptpN/delete_vclock_domain
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This write-only file removes PTP virtual clock for the
+		specified domain. Write the u8 domain value into this
+		file to remove the PTP virtual clock.
+
+What:		/sys/class/ptp/ptpN/domain
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This file contains the domain value that the PTP clock
+		serves. Time stamps of PTP messages of this domain are
+		provided by this PTP clock. Write a new u8 value into
+		this file to change the domain.
+
 What:		/sys/class/ptp/ptpN/max_adjustment
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
@@ -101,6 +118,14 @@ Description:
 		the form of three integers: channel index, seconds,
 		and nanoseconds.
 
+What:		/sys/class/ptp/ptpN/new_vclock_domain
+Date:		May 2021
+Contact:	Yangbo Lu <yangbo.lu@nxp.com>
+Description:
+		This write-only file creates PTP virtual clock for a
+		specified domain. Write the u8 domain value into this
+		file to create the PTP virtual clock.
+
 What:		/sys/class/ptp/ptpN/period
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be076a91e20e..d8e7e05bd52d 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -121,6 +121,119 @@ static ssize_t period_store(struct device *dev,
 }
 static DEVICE_ATTR(period, 0220, NULL, period_store);
 
+static int check_domain_avail(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	u8 *domain = data;
+
+	if (info->domain == *domain)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int delete_vclock_domain(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	struct ptp_vclock *vclock = info_to_vclock(info);
+	u8 *domain = data;
+
+	if (!info->is_vclock)
+		return 0;
+
+	if (info->domain == *domain) {
+		ptp_vclock_unregister(vclock);
+		/* For break. Not error. */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static ssize_t domain_show(struct device *dev,
+			   struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->info->domain);
+}
+
+static ssize_t domain_store(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	int err = -EINVAL;
+	u8 domain;
+
+	if (kstrtou8(buf, 0, &domain))
+		goto out;
+
+	if (device_for_each_child(dev->parent, &domain, check_domain_avail)) {
+		dev_err(dev, "the domain value already in used\n");
+		goto out;
+	}
+
+	info->domain = domain;
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_RW(domain);
+
+static ssize_t new_vclock_domain_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_vclock *vclock;
+	int err = -EINVAL;
+	u8 domain;
+
+	if (kstrtou8(buf, 0, &domain))
+		goto out;
+
+	if (device_for_each_child(dev->parent, &domain, check_domain_avail)) {
+		dev_err(dev, "the domain value already in used\n");
+		goto out;
+	}
+
+	vclock = ptp_vclock_register(ptp, domain);
+	if (!vclock)
+		goto out;
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_WO(new_vclock_domain);
+
+static ssize_t delete_vclock_domain_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	int err = -EINVAL;
+	u8 domain;
+
+	if (kstrtou8(buf, 0, &domain))
+		goto out;
+
+	if (!device_for_each_child(dev->parent, &domain,
+				   delete_vclock_domain)) {
+		dev_err(dev, "no such vclock domain in used\n");
+		goto out;
+	}
+
+	return count;
+out:
+	return err;
+}
+static DEVICE_ATTR_WO(delete_vclock_domain);
+
 static ssize_t pps_enable_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
@@ -161,6 +274,9 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_extts_enable.attr,
 	&dev_attr_fifo.attr,
 	&dev_attr_period.attr,
+	&dev_attr_domain.attr,
+	&dev_attr_new_vclock_domain.attr,
+	&dev_attr_delete_vclock_domain.attr,
 	&dev_attr_pps_enable.attr,
 	NULL
 };
@@ -183,6 +299,12 @@ static umode_t ptp_is_attribute_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_pps_enable.attr) {
 		if (!info->pps)
 			mode = 0;
+	} else if (attr == &dev_attr_new_vclock_domain.attr) {
+		if (info->is_vclock || !info->vclock_cc)
+			mode = 0;
+	} else if (attr == &dev_attr_delete_vclock_domain.attr) {
+		if (info->is_vclock || !info->vclock_cc)
+			mode = 0;
 	}
 
 	return mode;
-- 
2.25.1

