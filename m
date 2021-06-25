Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4253B4060
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhFYJ1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:06 -0400
Received: from inva020.nxp.com ([92.121.34.13]:32812 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhFYJ05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:26:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 461941A16CD;
        Fri, 25 Jun 2021 11:24:36 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D37FD1A045A;
        Fri, 25 Jun 2021 11:24:35 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id B3479183AC99;
        Fri, 25 Jun 2021 17:24:33 +0800 (+08)
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
Subject: [net-next, v4, 04/11] ptp: add kernel API ptp_get_vclocks_index()
Date:   Fri, 25 Jun 2021 17:35:06 +0800
Message-Id: <20210625093513.38524-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kernel API ptp_get_vclocks_index() to get all ptp
vclocks index on pclock.

This is preparation for supporting ptp vclocks info query
through ethtool.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
Changes for v4:
	- Dynamically allocated memory for vclock index getting.
---
 drivers/ptp/ptp_clock.c          |  3 ++-
 drivers/ptp/ptp_private.h        |  2 ++
 drivers/ptp/ptp_vclock.c         | 35 ++++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h | 14 +++++++++++++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 3ded22b4a062..dfbddb0b4ab0 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -24,10 +24,11 @@
 #define PTP_PPS_EVENT PPS_CAPTUREASSERT
 #define PTP_PPS_MODE (PTP_PPS_DEFAULTS | PPS_CANWAIT | PPS_TSFMT_TSPEC)
 
+struct class *ptp_class;
+
 /* private globals */
 
 static dev_t ptp_devt;
-static struct class *ptp_class;
 
 static DEFINE_IDA(ptp_clocks_map);
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index f75fadd9b244..dba6be477067 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -96,6 +96,8 @@ static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
 	return in_use;
 }
 
+extern struct class *ptp_class;
+
 /*
  * see ptp_chardev.c
  */
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index fc9205cc504d..cefab29a0592 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -148,3 +148,38 @@ void ptp_vclock_unregister(struct ptp_vclock *vclock)
 	ptp_clock_unregister(vclock->clock);
 	kfree(vclock);
 }
+
+int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
+{
+	char name[PTP_CLOCK_NAME_LEN] = "";
+	struct ptp_clock *ptp;
+	struct device *dev;
+	int num = 0;
+
+	if (pclock_index < 0)
+		return num;
+
+	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", pclock_index);
+	dev = class_find_device_by_name(ptp_class, name);
+	if (!dev)
+		return num;
+
+	ptp = dev_get_drvdata(dev);
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux)) {
+		put_device(dev);
+		return num;
+	}
+
+	*vclock_index = kzalloc(sizeof(int) * ptp->n_vclocks, GFP_KERNEL);
+	if (!(*vclock_index))
+		goto out;
+
+	memcpy(*vclock_index, ptp->vclock_index, sizeof(int) * ptp->n_vclocks);
+	num = ptp->n_vclocks;
+out:
+	mutex_unlock(&ptp->n_vclocks_mux);
+	put_device(dev);
+	return num;
+}
+EXPORT_SYMBOL(ptp_get_vclocks_index);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index b6fb771ee524..300a984fec87 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -306,6 +306,18 @@ int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay);
  */
 void ptp_cancel_worker_sync(struct ptp_clock *ptp);
 
+/**
+ * ptp_get_vclocks_index() - get all vclocks index on pclock, and
+ *                           caller is responsible to free memory
+ *                           of vclock_index
+ *
+ * @pclock_index: phc index of ptp pclock.
+ * @vclock_index: pointer to pointer of vclock index.
+ *
+ * return number of vclocks.
+ */
+int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
+
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -325,6 +337,8 @@ static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 { return -EOPNOTSUPP; }
 static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
+static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
+{ return 0; }
 
 #endif
 
-- 
2.25.1

