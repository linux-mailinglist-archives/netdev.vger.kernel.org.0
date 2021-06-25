Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25303B4059
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhFYJ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52974 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhFYJ05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:26:57 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 99EC02006EA;
        Fri, 25 Jun 2021 11:24:34 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 32B1E200694;
        Fri, 25 Jun 2021 11:24:34 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 1EC70183ACDC;
        Fri, 25 Jun 2021 17:24:32 +0800 (+08)
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
Subject: [net-next, v4, 03/11] ptp: track available ptp vclocks information
Date:   Fri, 25 Jun 2021 17:35:05 +0800
Message-Id: <20210625093513.38524-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track available ptp vclocks information. Record index values
of available ptp vclocks during registering and unregistering.

This is preparation for supporting ptp vclocks info query
through ethtool.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
Changes for v4:
	- Dynamically allocated memory for vclock index storage.
---
 drivers/ptp/ptp_clock.c   | 15 ++++++++++++++-
 drivers/ptp/ptp_private.h |  1 +
 drivers/ptp/ptp_sysfs.c   | 28 +++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 9fa8fea13616..3ded22b4a062 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -196,6 +196,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 {
 	struct ptp_clock *ptp;
 	int err = 0, index, major = MAJOR(ptp_devt);
+	size_t size;
 
 	if (info->n_alarm > PTP_MAX_ALARMS)
 		return ERR_PTR(-EINVAL);
@@ -236,9 +237,17 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	if (parent->class && strcmp(parent->class->name, "ptp") == 0)
 		ptp->is_virtual_clock = true;
 
-	if (!ptp->is_virtual_clock)
+	if (!ptp->is_virtual_clock) {
 		ptp->max_vclocks = PTP_DEFAULT_MAX_VCLOCKS;
 
+		size = sizeof(int) * ptp->max_vclocks;
+		ptp->vclock_index = kzalloc(size, GFP_KERNEL);
+		if (!ptp->vclock_index) {
+			err = -ENOMEM;
+			goto no_mem_for_vclocks;
+		}
+	}
+
 	err = ptp_populate_pin_groups(ptp);
 	if (err)
 		goto no_pin_groups;
@@ -283,6 +292,8 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 no_pps:
 	ptp_cleanup_pin_groups(ptp);
 no_pin_groups:
+	kfree(ptp->vclock_index);
+no_mem_for_vclocks:
 	if (ptp->kworker)
 		kthread_destroy_worker(ptp->kworker);
 kworker_err:
@@ -307,6 +318,8 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	ptp->defunct = 1;
 	wake_up_interruptible(&ptp->tsev_wq);
 
+	kfree(ptp->vclock_index);
+
 	if (ptp->kworker) {
 		kthread_cancel_delayed_work_sync(&ptp->aux_work);
 		kthread_destroy_worker(ptp->kworker);
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 87cb55953b69..f75fadd9b244 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -49,6 +49,7 @@ struct ptp_clock {
 	struct kthread_delayed_work aux_work;
 	unsigned int max_vclocks;
 	unsigned int n_vclocks;
+	int *vclock_index;
 	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
 	bool is_virtual_clock;
 };
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 0c6411409a18..53353f015662 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -213,6 +213,9 @@ static ssize_t n_vclocks_store(struct device *dev,
 			if (!vclock)
 				goto out;
 
+			*(ptp->vclock_index + ptp->n_vclocks + i) =
+				vclock->clock->index;
+
 			dev_info(dev, "new virtual clock ptp%d\n",
 				 vclock->clock->index);
 		}
@@ -223,6 +226,9 @@ static ssize_t n_vclocks_store(struct device *dev,
 		i = ptp->n_vclocks - num;
 		device_for_each_child_reverse(dev, &i,
 					      unregister_vclock);
+
+		for (i = 1; i <= ptp->n_vclocks - num; i++)
+			*(ptp->vclock_index + ptp->n_vclocks - i) = -1;
 	}
 
 	if (num == 0)
@@ -256,6 +262,9 @@ static ssize_t max_vclocks_store(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	unsigned int *vclock_index;
+	int err = -EINVAL;
+	size_t size;
 	u32 max;
 
 	if (kstrtou32(buf, 0, &max) || max == 0)
@@ -267,16 +276,29 @@ static ssize_t max_vclocks_store(struct device *dev,
 	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
 		return -ERESTARTSYS;
 
-	if (max < ptp->n_vclocks) {
-		mutex_unlock(&ptp->n_vclocks_mux);
-		return -EINVAL;
+	if (max < ptp->n_vclocks)
+		goto out;
+
+	size = sizeof(int) * max;
+	vclock_index = kzalloc(size, GFP_KERNEL);
+	if (!vclock_index) {
+		err = -ENOMEM;
+		goto out;
 	}
 
+	size = sizeof(int) * ptp->n_vclocks;
+	memcpy(vclock_index, ptp->vclock_index, size);
+
+	kfree(ptp->vclock_index);
+	ptp->vclock_index = vclock_index;
 	ptp->max_vclocks = max;
 
 	mutex_unlock(&ptp->n_vclocks_mux);
 
 	return count;
+out:
+	mutex_unlock(&ptp->n_vclocks_mux);
+	return err;
 }
 static DEVICE_ATTR_RW(max_vclocks);
 
-- 
2.25.1

