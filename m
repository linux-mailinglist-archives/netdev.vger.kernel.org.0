Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8AB3A7AD6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhFOJiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:55 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56794 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231583AbhFOJis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:48 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8E77D1A29DA;
        Tue, 15 Jun 2021 11:36:43 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4E4B41A29E6;
        Tue, 15 Jun 2021 11:36:37 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 0479840336;
        Tue, 15 Jun 2021 17:36:28 +0800 (+08)
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
Subject: [net-next, v3, 06/10] ptp: add kernel API ptp_convert_timestamp()
Date:   Tue, 15 Jun 2021 17:45:13 +0800
Message-Id: <20210615094517.48752-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
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
---
 drivers/ptp/ptp_vclock.c         | 34 ++++++++++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h | 13 ++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 8944b4fe32d8..65ca31916691 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -176,3 +176,37 @@ int ptp_get_vclocks_index(int pclock_index, int *vclock_index)
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
+	if (!ptp->vclock_flag) {
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
index 37f49d3e761e..b9414fc19249 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -12,6 +12,7 @@
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock.h>
 #include <linux/timecounter.h>
+#include <linux/skbuff.h>
 
 #define PTP_CLOCK_NAME_LEN	32
 /**
@@ -316,6 +317,15 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp);
  */
 int ptp_get_vclocks_index(int pclock_index, int *vclock_index);
 
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
@@ -337,6 +347,9 @@ static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
 static int ptp_get_vclocks_index(int pclock_index, int *vclock_index)
 { return 0; }
+static void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
+				  int vclock_index)
+{ }
 
 #endif
 
-- 
2.25.1

