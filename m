Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BB83B405D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFYJ1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:04 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53328 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhFYJ1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:27:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F002C200701;
        Fri, 25 Jun 2021 11:24:39 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 889632006E4;
        Fri, 25 Jun 2021 11:24:39 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 1CDB2183AC99;
        Fri, 25 Jun 2021 17:24:37 +0800 (+08)
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
Subject: [net-next, v4, 06/11] ptp: add kernel API ptp_convert_timestamp()
Date:   Fri, 25 Jun 2021 17:35:08 +0800
Message-Id: <20210625093513.38524-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kernel API ptp_convert_timestamp() to convert raw hardware timestamp
to a specified ptp vclock time.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Split from v1 patch #1 and #2.
	- Fixed build warning.
Changes for v3:
	- Converted HW timestamps to PHC bound, instead of previous
	  binding domain value to PHC idea.
Changes for v4:
	- Fixed build issue.
---
 drivers/ptp/ptp_vclock.c         | 34 ++++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h | 13 ++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index cefab29a0592..e0f87c57749a 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -183,3 +183,37 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 	return num;
 }
 EXPORT_SYMBOL(ptp_get_vclocks_index);
+
+void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
+			   int vclock_index)
+{
+	char name[PTP_CLOCK_NAME_LEN] = "";
+	struct ptp_vclock *vclock;
+	struct ptp_clock *ptp;
+	unsigned long flags;
+	struct device *dev;
+	u64 ns;
+
+	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", vclock_index);
+	dev = class_find_device_by_name(ptp_class, name);
+	if (!dev)
+		return;
+
+	ptp = dev_get_drvdata(dev);
+	if (!ptp->is_virtual_clock) {
+		put_device(dev);
+		return;
+	}
+
+	vclock = info_to_vclock(ptp->info);
+
+	ns = ktime_to_ns(hwtstamps->hwtstamp);
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	ns = timecounter_cyc2time(&vclock->tc, ns);
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	put_device(dev);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+EXPORT_SYMBOL(ptp_convert_timestamp);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 300a984fec87..71fac9237725 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -12,6 +12,7 @@
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock.h>
 #include <linux/timecounter.h>
+#include <linux/skbuff.h>
 
 #define PTP_CLOCK_NAME_LEN	32
 /**
@@ -318,6 +319,15 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp);
  */
 int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
 
+/**
+ * ptp_convert_timestamp() - convert timestamp to a ptp vclock time
+ *
+ * @hwtstamps:    skb_shared_hwtstamps structure pointer
+ * @vclock_index: phc index of ptp vclock.
+ */
+void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
+			   int vclock_index);
+
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -339,6 +349,9 @@ static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
 static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 { return 0; }
+static inline void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
+					 int vclock_index)
+{ }
 
 #endif
 
-- 
2.25.1

