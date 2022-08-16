Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C75953D7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiHPHdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiHPHdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:33:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5949F7FF83
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 21:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660623134; x=1692159134;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f3s1FTeOi6UzIDDOxu+3BUnFTjFV/9DO78H2zGSUdhs=;
  b=bhX2izpCWrYVmJdoVlvsp54egbBnL5zSzAOot3QakSJcPl4LYC7nyQaz
   Ka8CE7XZP7xSrGz2VlsFYgk/lRDBbY9RhBHRBHU/qMazYtZRQP6p+vvQa
   7VHMkLOxos5eCy1KPVM7lCaBBDLxJmdHm+VrYcKmpC4pC2YeTN6TMlDAT
   t940W0wwLgEkxxrnsZV91ROJ7rQAe4X0IKCeZey5zaJhBtOtOm07IF9c6
   rivqz6INV0YV5oq0QhNbmVRkO5nns1BhbacpYrWnuHuBlXdnHaIN7An0C
   gfpIKwX8W3LO2pUTRIumBpFQspbiEXijLwvYwrGNavYGKt4XKtl24Ubiy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="271890426"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="271890426"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:12:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="606886784"
Received: from bswcg005.iind.intel.com ([10.224.174.23])
  by orsmga002.jf.intel.com with ESMTP; 15 Aug 2022 21:12:09 -0700
From:   m.chetan.kumar@intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
Date:   Tue, 16 Aug 2022 09:53:53 +0530
Message-Id: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

PCI rescan module implements "rescan work queue". In firmware flashing
or coredump collection procedure WWAN device is programmed to boot in
fastboot mode and a work item is scheduled for removal & detection.
The WWAN device is reset using APCI call as part driver removal flow.
Work queue rescans pci bus at fixed interval for device detection,
later when device is detect work queue exits.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
---
 drivers/net/wwan/t7xx/Makefile             |   3 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |   5 +
 drivers/net/wwan/t7xx/t7xx_pci.c           |  51 ++++++++-
 drivers/net/wwan/t7xx/t7xx_pci.h           |   1 +
 drivers/net/wwan/t7xx/t7xx_pci_rescan.c    | 117 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci_rescan.h    |  29 +++++
 drivers/net/wwan/t7xx/t7xx_port_wwan.c     |   6 ++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   2 +
 8 files changed, 212 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index dc6a7d682c15..df42764b3df8 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -17,4 +17,5 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_dpmaif_tx.o \
 		t7xx_hif_dpmaif_rx.o  \
 		t7xx_dpmaif.o \
-		t7xx_netdev.o
+		t7xx_netdev.o \
+		t7xx_pci_rescan.o
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index ec2269dfaf2c..fb79d041dbf5 100644
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
@@ -192,6 +193,10 @@ static irqreturn_t t7xx_rgu_isr_thread(int irq, void *data)
 
 	msleep(RGU_RESET_DELAY_MS);
 	t7xx_reset_device_via_pmic(t7xx_dev);
+
+	if (!t7xx_dev->hp_enable)
+		t7xx_rescan_queue_work(t7xx_dev->pdev);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 871f2a27a398..2f5c6fbe601e 100644
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
@@ -715,8 +716,11 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 	}
 
+	t7xx_rescan_done();
 	t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
 	t7xx_pcie_mac_interrupts_en(t7xx_dev);
+	if (!t7xx_dev->hp_enable)
+		pci_ignore_hotplug(pdev);
 
 	return 0;
 }
@@ -754,7 +758,52 @@ static struct pci_driver t7xx_pci_driver = {
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
+	return dev->parent->fwnode == data;
+}
+
+static void __exit t7xx_pci_cleanup(void)
+{
+	int remove_flag = 0;
+	struct device *dev;
+
+	dev = driver_find_device(&t7xx_pci_driver.driver, NULL, NULL, t7xx_always_match);
+	if (dev) {
+		pr_debug("unregister t7xx PCIe driver while device is still exist.\n");
+		put_device(dev);
+		remove_flag = 1;
+	} else {
+		pr_debug("no t7xx PCIe driver found.\n");
+	}
+
+	pci_lock_rescan_remove();
+	pci_unregister_driver(&t7xx_pci_driver);
+	pci_unlock_rescan_remove();
+	t7xx_rescan_deinit();
+
+	if (remove_flag) {
+		pr_debug("remove t7xx PCI device\n");
+		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
+	}
+}
+
+module_exit(t7xx_pci_cleanup);
 
 MODULE_AUTHOR("MediaTek Inc");
 MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index 50b37056ce5a..a87c4cae94ef 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -69,6 +69,7 @@ struct t7xx_pci_dev {
 	struct t7xx_modem	*md;
 	struct t7xx_ccmni_ctrl	*ccmni_ctlb;
 	bool			rgu_pci_irq_en;
+	bool			hp_enable;
 
 	/* Low Power Items */
 	struct list_head	md_pm_entities;
diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
new file mode 100644
index 000000000000..045777d8a843
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
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
+static struct remove_rescan_context g_mtk_rescan_context;
+
+void t7xx_pci_dev_rescan(void)
+{
+	struct pci_bus *b = NULL;
+
+	pci_lock_rescan_remove();
+	while ((b = pci_find_next_bus(b)))
+		pci_rescan_bus(b);
+
+	pci_unlock_rescan_remove();
+}
+
+void t7xx_rescan_done(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
+	if (g_mtk_rescan_context.rescan_done == 0) {
+		pr_debug("this is a rescan probe\n");
+		g_mtk_rescan_context.rescan_done = 1;
+	} else {
+		pr_debug("this is a init probe\n");
+	}
+	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+}
+
+static void t7xx_remove_rescan(struct work_struct *work)
+{
+	struct pci_dev *pdev;
+	int num_retries = RESCAN_RETRIES;
+	unsigned long flags;
+
+	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
+	g_mtk_rescan_context.rescan_done = 0;
+	pdev = g_mtk_rescan_context.dev;
+	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+
+	if (pdev) {
+		pci_stop_and_remove_bus_device_locked(pdev);
+		pr_debug("start remove and rescan flow\n");
+	}
+
+	do {
+		t7xx_pci_dev_rescan();
+		spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
+		if (g_mtk_rescan_context.rescan_done) {
+			spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+			break;
+		}
+
+		spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+		msleep(DELAY_RESCAN_MTIME);
+	} while (num_retries--);
+}
+
+void t7xx_rescan_queue_work(struct pci_dev *pdev)
+{
+	unsigned long flags;
+
+	dev_info(&pdev->dev, "start queue_mtk_rescan_work\n");
+	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
+	if (!g_mtk_rescan_context.rescan_done) {
+		dev_err(&pdev->dev, "rescan failed because last rescan undone\n");
+		spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+		return;
+	}
+
+	g_mtk_rescan_context.dev = pdev;
+	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+	queue_work(g_mtk_rescan_context.pcie_rescan_wq, &g_mtk_rescan_context.service_task);
+}
+
+int t7xx_rescan_init(void)
+{
+	spin_lock_init(&g_mtk_rescan_context.dev_lock);
+	g_mtk_rescan_context.rescan_done = 1;
+	g_mtk_rescan_context.dev = NULL;
+	g_mtk_rescan_context.pcie_rescan_wq = create_singlethread_workqueue(MTK_RESCAN_WQ);
+	if (!g_mtk_rescan_context.pcie_rescan_wq) {
+		pr_err("Failed to create workqueue: %s\n", MTK_RESCAN_WQ);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&g_mtk_rescan_context.service_task, t7xx_remove_rescan);
+
+	return 0;
+}
+
+void t7xx_rescan_deinit(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
+	g_mtk_rescan_context.rescan_done = 0;
+	g_mtk_rescan_context.dev = NULL;
+	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
+	cancel_work_sync(&g_mtk_rescan_context.service_task);
+	destroy_workqueue(g_mtk_rescan_context.pcie_rescan_wq);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.h b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
new file mode 100644
index 000000000000..de4ca1363bb0
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
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
+	struct work_struct	 service_task;
+	struct workqueue_struct *pcie_rescan_wq;
+	spinlock_t		dev_lock; /* protects device */
+	struct pci_dev		*dev;
+	int			rescan_done;
+};
+
+void t7xx_pci_dev_rescan(void);
+void t7xx_rescan_queue_work(struct pci_dev *pdev);
+int t7xx_rescan_init(void);
+void t7xx_rescan_deinit(void);
+void t7xx_rescan_done(void);
+
+#endif	/* __T7XX_PCI_RESCAN_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index e53651ee2005..dfd7fb487fc0 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -156,6 +156,12 @@ static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int
 {
 	const struct t7xx_port_conf *port_conf = port->port_conf;
 
+	if (state == MD_STATE_EXCEPTION) {
+		if (port->wwan_port)
+			wwan_port_txoff(port->wwan_port);
+		return;
+	}
+
 	if (state != MD_STATE_READY)
 		return;
 
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index c1789a558c9d..9c222809371b 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -35,9 +35,11 @@
 #include "t7xx_hif_cldma.h"
 #include "t7xx_mhccif.h"
 #include "t7xx_modem_ops.h"
+#include "t7xx_netdev.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
 #include "t7xx_port_proxy.h"
+#include "t7xx_pci_rescan.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
-- 
2.34.1

