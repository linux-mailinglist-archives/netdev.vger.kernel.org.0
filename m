Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2685D3A7AD1
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhFOJiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56686 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhFOJio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:44 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AD78D1A29CC;
        Tue, 15 Jun 2021 11:36:39 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 593A81A0494;
        Tue, 15 Jun 2021 11:36:33 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id D785740341;
        Tue, 15 Jun 2021 17:36:24 +0800 (+08)
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
Subject: [net-next, v3, 04/10] ptp: add kernel API ptp_get_vclocks_index()
Date:   Tue, 15 Jun 2021 17:45:11 +0800
Message-Id: <20210615094517.48752-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
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
---
 drivers/ptp/ptp_clock.c          |  3 ++-
 drivers/ptp/ptp_private.h        |  2 ++
 drivers/ptp/ptp_vclock.c         | 24 ++++++++++++++++++++++++
 include/linux/ptp_clock_kernel.h | 12 ++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 38842a76acf8..88e43451b062 100644
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
index 5671710ca0fa..16b7ba583ddd 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -91,6 +91,8 @@ static inline bool ptp_guaranteed_pclock(struct ptp_clock *ptp)
 	return false;
 }
 
+extern struct class *ptp_class;
+
 /*
  * see ptp_chardev.c
  */
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index b8f500677314..8944b4fe32d8 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -152,3 +152,27 @@ void ptp_vclock_unregister(struct ptp_vclock *vclock)
 	ptp_clock_unregister(vclock->clock);
 	kfree(vclock);
 }
+
+int ptp_get_vclocks_index(int pclock_index, int *vclock_index)
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
+	num = ptp->n_vclocks;
+	memcpy(vclock_index, ptp->vclock_index, sizeof(int) * ptp->n_vclocks);
+	put_device(dev);
+
+	return num;
+}
+EXPORT_SYMBOL(ptp_get_vclocks_index);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index af12cc1e76d7..37f49d3e761e 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -306,6 +306,16 @@ int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay);
  */
 void ptp_cancel_worker_sync(struct ptp_clock *ptp);
 
+/**
+ * ptp_get_vclocks_index() - get all vclocks index on pclock
+ *
+ * @pclock_index: phc index of ptp pclock.
+ * @vclock_index: pointer to phc index of ptp vclocks.
+ *
+ * return number of vclocks.
+ */
+int ptp_get_vclocks_index(int pclock_index, int *vclock_index);
+
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -325,6 +335,8 @@ static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 { return -EOPNOTSUPP; }
 static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
 { }
+static int ptp_get_vclocks_index(int pclock_index, int *vclock_index)
+{ return 0; }
 
 #endif
 
-- 
2.25.1

