Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8207047BA26
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhLUGuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:29879 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234123AbhLUGuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069414; x=1671605414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C+Vu8aT8Lx6FmsGpV7fP6vez8x96D34fiYhEaskC7oY=;
  b=nznMkY5kb43YNskntJReOE3dkgJUpiml4pjqvxqV2Zz2Qwyc1SttY12v
   7vfOfEGePXEzUIa/vMrPYrh4tpSva+v6On7BFGbIUF1DJM7CzjdVe+/R2
   /K8+HCn5iOP+zONkmGgpqnEi+In4aLBwPQwH9h1ItBFhzYV3dEMUJTYjB
   7IDSqYn9X8LevouoBert3juctXndFMJlDpfeJXzl1Q4kvekzsSjioy+M3
   i5+5+L5q66tPbSZdjX0C2dq8u4iT8lh6MpLCgdBFd8qY2gqFEWzwrrDPM
   8SG9NAOU1LZ8Agy4UUR7C3taCjPRCgGnJEx3F4p1DtY40vHVBzCmtInCh
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107464"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107464"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570118987"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:13 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 02/17] dlb: initialize DLB device
Date:   Tue, 21 Dec 2021 00:50:32 -0600
Message-Id: <20211221065047.290182-3-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map the PCI BAR space, create a char device, and set the DMA API mask for
64-bit addressing. Add the corresponding undo/remove operations.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/Makefile     |  1 +
 drivers/misc/dlb/dlb_main.c   | 57 +++++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_main.h   | 19 ++++++++++++
 drivers/misc/dlb/dlb_pf_ops.c | 33 ++++++++++++++++++++
 4 files changed, 110 insertions(+)
 create mode 100644 drivers/misc/dlb/dlb_pf_ops.c

diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index a5cd3eec3304..027556fd3f1f 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
+dlb-objs += dlb_pf_ops.o
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 12346ee8acf7..00f7949e4d95 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -16,10 +16,38 @@ MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel(R) Dynamic Load Balancer (DLB) Driver");
 
 static struct class *dlb_class;
+static struct cdev dlb_cdev;
 static dev_t dlb_devt;
 static DEFINE_IDR(dlb_ids);
 static DEFINE_MUTEX(dlb_ids_lock);
 
+static int dlb_device_create(struct dlb *dlb, struct pci_dev *pdev)
+{
+	/*
+	 * Create a new device in order to create a /dev/dlb node. This device
+	 * is a child of the DLB PCI device.
+	 */
+	dlb->dev_number = MKDEV(MAJOR(dlb_devt), dlb->id);
+	dlb->dev = device_create(dlb_class, &pdev->dev, dlb->dev_number, dlb,
+				 "dlb%d", dlb->id);
+	if (IS_ERR(dlb->dev)) {
+		dev_err(dlb->dev, "device_create() returned %ld\n",
+			PTR_ERR(dlb->dev));
+
+		return PTR_ERR(dlb->dev);
+	}
+
+	return 0;
+}
+
+/********************************/
+/****** Char dev callbacks ******/
+/********************************/
+
+static const struct file_operations dlb_fops = {
+	.owner   = THIS_MODULE,
+};
+
 /**********************************/
 /****** PCI driver callbacks ******/
 /**********************************/
@@ -71,8 +99,24 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret != 0)
 		dev_info(&pdev->dev, "AER is not supported\n");
 
+	ret = dlb_pf_map_pci_bar_space(dlb, pdev);
+	if (ret)
+		goto map_pci_bar_fail;
+
+	ret = dlb_device_create(dlb, pdev);
+	if (ret)
+		goto map_pci_bar_fail;
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret)
+		goto dma_set_mask_fail;
+
 	return 0;
 
+dma_set_mask_fail:
+	device_destroy(dlb_class, dlb->dev_number);
+map_pci_bar_fail:
+	pci_disable_pcie_error_reporting(pdev);
 pci_enable_device_fail:
 	mutex_lock(&dlb_ids_lock);
 	idr_remove(&dlb_ids, dlb->id);
@@ -85,6 +129,8 @@ static void dlb_remove(struct pci_dev *pdev)
 {
 	struct dlb *dlb = pci_get_drvdata(pdev);
 
+	device_destroy(dlb_class, dlb->dev_number);
+
 	pci_disable_pcie_error_reporting(pdev);
 
 	mutex_lock(&dlb_ids_lock);
@@ -107,6 +153,7 @@ static struct pci_driver dlb_pci_driver = {
 
 static int __init dlb_init_module(void)
 {
+	int dlb_major;
 	int err;
 
 	dlb_class = class_create(THIS_MODULE, "dlb");
@@ -126,6 +173,12 @@ static int __init dlb_init_module(void)
 		goto alloc_chrdev_fail;
 	}
 
+	dlb_major = MAJOR(dlb_devt);
+	cdev_init(&dlb_cdev, &dlb_fops);
+	err = cdev_add(&dlb_cdev, MKDEV(dlb_major, 0), DLB_MAX_NUM_DEVICES);
+	if (err)
+		goto cdev_add_fail;
+
 	err = pci_register_driver(&dlb_pci_driver);
 	if (err < 0) {
 		pr_err("dlb: pci_register_driver() returned %d\n", err);
@@ -136,6 +189,8 @@ static int __init dlb_init_module(void)
 	return 0;
 
 pci_register_fail:
+	cdev_del(&dlb_cdev);
+cdev_add_fail:
 	unregister_chrdev_region(dlb_devt, DLB_MAX_NUM_DEVICES);
 alloc_chrdev_fail:
 	class_destroy(dlb_class);
@@ -147,6 +202,8 @@ static void __exit dlb_exit_module(void)
 {
 	pci_unregister_driver(&dlb_pci_driver);
 
+	cdev_del(&dlb_cdev);
+
 	unregister_chrdev_region(dlb_devt, DLB_MAX_NUM_DEVICES);
 
 	class_destroy(dlb_class);
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 23f059ec86f1..efe74ffcbf0c 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -16,6 +16,7 @@
  * Hardware related #defines and data structures.
  *
  */
+
 #define DLB_MAX_NUM_VDEVS			16
 #define DLB_MAX_NUM_DOMAINS			32
 #define DLB_MAX_NUM_LDB_QUEUES			32 /* LDB == load-balanced */
@@ -41,6 +42,15 @@
 
 #define PCI_DEVICE_ID_INTEL_DLB_PF		0x2710
 
+struct dlb_hw {
+	/* BAR 0 address */
+	void __iomem *csr_kva;
+	unsigned long csr_phys_addr;
+	/* BAR 2 address */
+	void __iomem *func_kva;
+	unsigned long func_phys_addr;
+};
+
 /*
  * The dlb driver uses a different minor number for each device file, of which
  * there are:
@@ -56,9 +66,18 @@ enum dlb_device_type {
 	DLB_PF,
 };
 
+struct dlb;
+
+int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
+void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
+
 struct dlb {
 	struct pci_dev *pdev;
+	struct dlb_hw hw;
+	struct device *dev;
+	enum dlb_device_type type;
 	int id;
+	dev_t dev_number;
 };
 
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
new file mode 100644
index 000000000000..77ca7bf2d961
--- /dev/null
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include "dlb_main.h"
+
+/********************************/
+/****** PCI BAR management ******/
+/********************************/
+
+int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
+{
+	dlb->hw.func_kva = pcim_iomap_table(pdev)[DLB_FUNC_BAR];
+	dlb->hw.func_phys_addr = pci_resource_start(pdev, DLB_FUNC_BAR);
+
+	if (!dlb->hw.func_kva) {
+		dev_err(&pdev->dev, "Cannot iomap BAR 0 (size %llu)\n",
+			pci_resource_len(pdev, 0));
+
+		return -EIO;
+	}
+
+	dlb->hw.csr_kva = pcim_iomap_table(pdev)[DLB_CSR_BAR];
+	dlb->hw.csr_phys_addr = pci_resource_start(pdev, DLB_CSR_BAR);
+
+	if (!dlb->hw.csr_kva) {
+		dev_err(&pdev->dev, "Cannot iomap BAR 2 (size %llu)\n",
+			pci_resource_len(pdev, 2));
+
+		return -EIO;
+	}
+
+	return 0;
+}
-- 
2.27.0

