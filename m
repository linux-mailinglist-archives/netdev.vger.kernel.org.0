Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E524676689
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 14:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjAUNeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 08:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjAUNeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 08:34:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5377D4941B
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 05:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674308042; x=1705844042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kJDhVen0LLx+ycSXhg2TBMGI0+prGzBoFilKvcAilpc=;
  b=kO2hg3VLYE6BpcZUe1Wq/ComqWeGvAYRl9Ou+COhTOgrnYuRV+W3xA3u
   GphioiZZe07kcJkIh1YZT9NZhSubwy3vhqV8Do0eCyp6FxM+3V+wJrwUw
   qLM/l1xdMjgDBm/kkhZ9nRg4raHgTLTiztI+wzgOoeHR53YNRZOgkO7S1
   I33zr0YinwkTECzpyBf4L9ZKoCvma+fY9tMXHuyzwHFT4MHXhIVv0LxXz
   nKiOl8SJEBbvGl75ifthnOKKKGhjHj4UEJN2ZSP+DsgqNafmJ/LCSGyjg
   KjfNlimuFz1VB/hz4d1GQWHLDOUkUyhwDvwY56qxEZKi0e7FCUrmUZ6yJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="324471518"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="324471518"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 05:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="610783329"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="610783329"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2023 05:33:56 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Subject: [PATCH v5 net-next 3/5] net: wwan: t7xx: PCIe reset rescan
Date:   Sat, 21 Jan 2023 19:03:23 +0530
Message-Id: <b58e4062a78053e558cbd40b9c6bb8fb36d01f64.1674307425.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

PCI rescan module implements "rescan work queue".
In firmware flashing or coredump collection procedure
WWAN device is programmed to boot in fastboot mode and
a work item is scheduled for removal & detection.

The WWAN device is reset using APCI call as part driver
removal flow. Work queue rescans pci bus at fixed interval
for device detection, later when device is detect work queue
exits.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
--
v5:
 * No Change.
v4:
 * Change "is still exist" to "still exists".
v3:
 * No Change.
v2:
 * Drop empty line inside critical sections.
 * Correct log message.
 * Correct logic inside t7xx_always_match().
 * Drop hp_enable changes.
 * Drop g_ prefix from t7xx_rescan_ctx.
 * Use tab before comment in struct decl.
 * Remove extra white space.
 * Drop modem exception state check.
 * Crit section newlines.
 * Remove unnecessary header files inclusion.
 * Drop spinlock around reset and rescan flow.
---
 drivers/net/wwan/t7xx/Makefile          |  3 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c  |  3 +
 drivers/net/wwan/t7xx/t7xx_pci.c        | 56 ++++++++++++++-
 drivers/net/wwan/t7xx/t7xx_pci_rescan.c | 96 +++++++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci_rescan.h | 28 ++++++++
 5 files changed, 184 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 268ff9e87e5b..ba5c607404a4 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -17,7 +17,8 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_dpmaif_tx.o \
 		t7xx_hif_dpmaif_rx.o  \
 		t7xx_dpmaif.o \
-		t7xx_netdev.o
+		t7xx_netdev.o \
+		t7xx_pci_rescan.o
 
 mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) += \
 		t7xx_port_trace.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index cbd65aa48721..2fcaea4694ba 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -37,6 +37,7 @@
 #include "t7xx_modem_ops.h"
 #include "t7xx_netdev.h"
 #include "t7xx_pci.h"
+#include "t7xx_pci_rescan.h"
 #include "t7xx_pcie_mac.h"
 #include "t7xx_port.h"
 #include "t7xx_port_proxy.h"
@@ -194,6 +195,8 @@ static irqreturn_t t7xx_rgu_isr_thread(int irq, void *data)
 
 	msleep(RGU_RESET_DELAY_MS);
 	t7xx_reset_device_via_pmic(t7xx_dev);
+	t7xx_rescan_queue_work(t7xx_dev->pdev);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 871f2a27a398..3f5ebbc11b82 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -38,6 +38,7 @@
 #include "t7xx_mhccif.h"
 #include "t7xx_modem_ops.h"
 #include "t7xx_pci.h"
+#include "t7xx_pci_rescan.h"
 #include "t7xx_pcie_mac.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
@@ -715,6 +716,7 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 	}
 
+	t7xx_rescan_done();
 	t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
 	t7xx_pcie_mac_interrupts_en(t7xx_dev);
 
@@ -754,7 +756,59 @@ static struct pci_driver t7xx_pci_driver = {
 	.shutdown = t7xx_pci_shutdown,
 };
 
-module_pci_driver(t7xx_pci_driver);
+static int __init t7xx_pci_init(void)
+{
+	int ret;
+
+	t7xx_pci_dev_rescan();
+	ret = t7xx_rescan_init();
+	if (ret) {
+		pr_err("Failed to init t7xx rescan work\n");
+		return ret;
+	}
+
+	return pci_register_driver(&t7xx_pci_driver);
+}
+module_init(t7xx_pci_init);
+
+static int t7xx_always_match(struct device *dev, const void *data)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	const struct pci_device_id *id = data;
+
+	if (pci_match_id(id, pdev))
+		return 1;
+
+	return 0;
+}
+
+static void __exit t7xx_pci_cleanup(void)
+{
+	int remove_flag = 0;
+	struct device *dev;
+
+	dev = driver_find_device(&t7xx_pci_driver.driver, NULL, &t7xx_pci_table[0],
+				 t7xx_always_match);
+	if (dev) {
+		pr_debug("unregister t7xx PCIe driver while device still exists.\n");
+		put_device(dev);
+		remove_flag = 1;
+	} else {
+		pr_debug("no t7xx PCIe driver found.\n");
+	}
+
+	pci_lock_rescan_remove();
+	pci_unregister_driver(&t7xx_pci_driver);
+	pci_unlock_rescan_remove();
+
+	t7xx_rescan_deinit();
+	if (remove_flag) {
+		pr_debug("remove t7xx PCI device\n");
+		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
+	}
+}
+
+module_exit(t7xx_pci_cleanup);
 
 MODULE_AUTHOR("MediaTek Inc");
 MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");
diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
new file mode 100644
index 000000000000..67f13c035846
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2023, Intel Corporation.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":t7xx:%s: " fmt, __func__
+#define dev_fmt(fmt) "t7xx: " fmt
+
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_pci_rescan.h"
+
+static struct remove_rescan_context t7xx_rescan_ctx;
+
+void t7xx_pci_dev_rescan(void)
+{
+	struct pci_bus *b = NULL;
+
+	pci_lock_rescan_remove();
+	while ((b = pci_find_next_bus(b)))
+		pci_rescan_bus(b);
+	pci_unlock_rescan_remove();
+}
+
+void t7xx_rescan_done(void)
+{
+	if (!atomic_read(&t7xx_rescan_ctx.rescan_done)) {
+		atomic_set(&t7xx_rescan_ctx.rescan_done, 1);
+		pr_debug("Rescan probe\n");
+	} else {
+		pr_debug("Init probe\n");
+	}
+}
+
+static void t7xx_remove_rescan(struct work_struct *work)
+{
+	int num_retries = RESCAN_RETRIES;
+	struct pci_dev *pdev;
+
+	atomic_set(&t7xx_rescan_ctx.rescan_done, 0);
+	pdev = t7xx_rescan_ctx.dev;
+
+	if (pdev) {
+		pci_stop_and_remove_bus_device_locked(pdev);
+		pr_debug("start remove and rescan flow\n");
+	}
+
+	do {
+		t7xx_pci_dev_rescan();
+
+		if (atomic_read(&t7xx_rescan_ctx.rescan_done))
+			break;
+
+		msleep(DELAY_RESCAN_MTIME);
+	} while (num_retries--);
+}
+
+void t7xx_rescan_queue_work(struct pci_dev *pdev)
+{
+	if (!atomic_read(&t7xx_rescan_ctx.rescan_done)) {
+		dev_err(&pdev->dev, "Rescan failed\n");
+		return;
+	}
+
+	t7xx_rescan_ctx.dev = pdev;
+	queue_work(t7xx_rescan_ctx.pcie_rescan_wq, &t7xx_rescan_ctx.service_task);
+}
+
+int t7xx_rescan_init(void)
+{
+	atomic_set(&t7xx_rescan_ctx.rescan_done, 1);
+	t7xx_rescan_ctx.dev = NULL;
+
+	t7xx_rescan_ctx.pcie_rescan_wq = create_singlethread_workqueue(MTK_RESCAN_WQ);
+	if (!t7xx_rescan_ctx.pcie_rescan_wq) {
+		pr_err("Failed to create workqueue: %s\n", MTK_RESCAN_WQ);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&t7xx_rescan_ctx.service_task, t7xx_remove_rescan);
+
+	return 0;
+}
+
+void t7xx_rescan_deinit(void)
+{
+	t7xx_rescan_ctx.dev = NULL;
+	atomic_set(&t7xx_rescan_ctx.rescan_done, 0);
+	cancel_work_sync(&t7xx_rescan_ctx.service_task);
+	destroy_workqueue(t7xx_rescan_ctx.pcie_rescan_wq);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.h b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
new file mode 100644
index 000000000000..80b25c44151c
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2023, Intel Corporation.
+ */
+
+#ifndef __T7XX_PCI_RESCAN_H__
+#define __T7XX_PCI_RESCAN_H__
+
+#define MTK_RESCAN_WQ "mtk_rescan_wq"
+
+#define DELAY_RESCAN_MTIME 1000
+#define RESCAN_RETRIES 35
+
+struct remove_rescan_context {
+	struct work_struct service_task;
+	struct workqueue_struct *pcie_rescan_wq;
+	struct pci_dev *dev;
+	atomic_t rescan_done;
+};
+
+void t7xx_pci_dev_rescan(void);
+void t7xx_rescan_queue_work(struct pci_dev *pdev);
+int t7xx_rescan_init(void);
+void t7xx_rescan_deinit(void);
+void t7xx_rescan_done(void);
+
+#endif	/* __T7XX_PCI_RESCAN_H__ */
-- 
2.34.1

