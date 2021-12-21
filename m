Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509A147BA28
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhLUGuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:29879 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhLUGuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069416; x=1671605416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Bo3IhyZyGFFcKO7ox3FUoXM88KNn1ugCizs6oTmd1U=;
  b=jhapZzIgXMzXb1hB1YaTRK6uwW5Jv2N6pyA6k5tzyXFr7uixVUkZR4X+
   X27PQGiIrrEitWDHdGvt11ZhOsqBIuZPcOwQqaTLt1Q4SPgCq0jb1C+Py
   8rgJdDsmMFuvM/MH5XYdI1j+ZSvxh6XBHbaaT+PRhThwfJa3ChMpKJe0R
   DxNvhj662TPebccbc+iOXYX+tIznlWqc+KetUWf5xUrKZH+p2F8J4+4bY
   gOMCcySWWRJF+yiZbUQ6cjFM+RQEIsew2Hi3haZ01UeOWanJIFEl6PCJl
   uX1EmfFNab0DXtTYoGQEg7S+EUy3UweQCR5pB8BX4heWZNuMj/SQnn3f4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107467"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107467"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570118992"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:15 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 03/17] dlb: add resource and device initialization
Date:   Tue, 21 Dec 2021 00:50:33 -0600
Message-Id: <20211221065047.290182-4-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the hardware resource data structures, functions for
their initialization/teardown, and a function for device power-on. In
subsequent commits, dlb_resource.c will be expanded to hold the dlb
resource-management and configuration logic (using the data structures
defined in dlb_main.h).

There is a resource data structure for each system level: device/function,
scheduling domain, port and queue. At the device/function level, this
data structure is struct dlb_function_resources, which holds used and
avialable domains/ports/queues/history lists for the device function
(either physical or virtual).

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/Makefile       |   2 +-
 drivers/misc/dlb/dlb_main.c     |  46 ++++++
 drivers/misc/dlb/dlb_main.h     | 249 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_pf_ops.c   |  56 +++++++
 drivers/misc/dlb/dlb_regs.h     | 119 +++++++++++++++
 drivers/misc/dlb/dlb_resource.c | 210 +++++++++++++++++++++++++++
 6 files changed, 681 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/dlb/dlb_regs.h
 create mode 100644 drivers/misc/dlb/dlb_resource.c

diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index 027556fd3f1f..66d885619e66 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -3,4 +3,4 @@
 obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
-dlb-objs += dlb_pf_ops.o
+dlb-objs += dlb_pf_ops.o dlb_resource.o
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 00f7949e4d95..136e8b54ea2b 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -21,6 +21,23 @@ static dev_t dlb_devt;
 static DEFINE_IDR(dlb_ids);
 static DEFINE_MUTEX(dlb_ids_lock);
 
+static int dlb_reset_device(struct pci_dev *pdev)
+{
+	int ret;
+
+	ret = pci_save_state(pdev);
+	if (ret)
+		return ret;
+
+	ret = __pci_reset_function_locked(pdev);
+	if (ret)
+		return ret;
+
+	pci_restore_state(pdev);
+
+	return 0;
+}
+
 static int dlb_device_create(struct dlb *dlb, struct pci_dev *pdev)
 {
 	/*
@@ -111,8 +128,35 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto dma_set_mask_fail;
 
+	/*
+	 * PM enable must be done before any other MMIO accesses, and this
+	 * setting is persistent across device reset.
+	 */
+	dlb_pf_enable_pm(dlb);
+
+	ret = dlb_pf_wait_for_device_ready(dlb, pdev);
+	if (ret)
+		goto wait_for_device_ready_fail;
+
+	ret = dlb_reset_device(pdev);
+	if (ret)
+		goto dlb_reset_fail;
+
+	ret = dlb_resource_init(&dlb->hw);
+	if (ret)
+		goto resource_init_fail;
+
+	ret = dlb_pf_init_driver_state(dlb);
+	if (ret)
+		goto init_driver_state_fail;
+
 	return 0;
 
+init_driver_state_fail:
+	dlb_resource_free(&dlb->hw);
+resource_init_fail:
+dlb_reset_fail:
+wait_for_device_ready_fail:
 dma_set_mask_fail:
 	device_destroy(dlb_class, dlb->dev_number);
 map_pci_bar_fail:
@@ -129,6 +173,8 @@ static void dlb_remove(struct pci_dev *pdev)
 {
 	struct dlb *dlb = pci_get_drvdata(pdev);
 
+	dlb_resource_free(&dlb->hw);
+
 	device_destroy(dlb_class, dlb->dev_number);
 
 	pci_disable_pcie_error_reporting(pdev);
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index efe74ffcbf0c..a65b12b75b4c 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -11,11 +11,23 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/types.h>
+#include <linux/bitfield.h>
 
 /*
  * Hardware related #defines and data structures.
  *
  */
+/* Read/write register 'reg' in the CSR BAR space */
+#define DLB_CSR_REG_ADDR(a, reg)   ((a)->csr_kva + (reg))
+#define DLB_CSR_RD(hw, reg)	    ioread32(DLB_CSR_REG_ADDR((hw), (reg)))
+#define DLB_CSR_WR(hw, reg, value) iowrite32((value), \
+					      DLB_CSR_REG_ADDR((hw), (reg)))
+
+/* Read/write register 'reg' in the func BAR space */
+#define DLB_FUNC_REG_ADDR(a, reg)   ((a)->func_kva + (reg))
+#define DLB_FUNC_RD(hw, reg)	     ioread32(DLB_FUNC_REG_ADDR((hw), (reg)))
+#define DLB_FUNC_WR(hw, reg, value) iowrite32((value), \
+					       DLB_FUNC_REG_ADDR((hw), (reg)))
 
 #define DLB_MAX_NUM_VDEVS			16
 #define DLB_MAX_NUM_DOMAINS			32
@@ -42,6 +54,159 @@
 
 #define PCI_DEVICE_ID_INTEL_DLB_PF		0x2710
 
+struct dlb_ldb_queue {
+	struct list_head domain_list;
+	struct list_head func_list;
+	u32 id;
+	u32 domain_id;
+	u32 num_qid_inflights;
+	u32 aqed_limit;
+	u32 sn_group; /* sn == sequence number */
+	u32 sn_slot;
+	u32 num_mappings;
+	u8 sn_cfg_valid;
+	u8 num_pending_additions;
+	u8 owned;
+	u8 configured;
+};
+
+/*
+ * Directed ports and queues are paired by nature, so the driver tracks them
+ * with a single data structure.
+ */
+struct dlb_dir_pq_pair {
+	struct list_head domain_list;
+	struct list_head func_list;
+	u32 id;
+	u32 domain_id;
+	u32 ref_cnt;
+	u8 init_tkn_cnt;
+	u8 queue_configured;
+	u8 port_configured;
+	u8 owned;
+	u8 enabled;
+};
+
+enum dlb_qid_map_state {
+	/* The slot doesn't contain a valid queue mapping */
+	DLB_QUEUE_UNMAPPED,
+	/* The slot contains a valid queue mapping */
+	DLB_QUEUE_MAPPED,
+	/* The driver is mapping a queue into this slot */
+	DLB_QUEUE_MAP_IN_PROG,
+	/* The driver is unmapping a queue from this slot */
+	DLB_QUEUE_UNMAP_IN_PROG,
+	/*
+	 * The driver is unmapping a queue from this slot, and once complete
+	 * will replace it with another mapping.
+	 */
+	DLB_QUEUE_UNMAP_IN_PROG_PENDING_MAP,
+};
+
+struct dlb_ldb_port_qid_map {
+	enum dlb_qid_map_state state;
+	u16 qid;
+	u16 pending_qid;
+	u8 priority;
+	u8 pending_priority;
+};
+
+struct dlb_ldb_port {
+	struct list_head domain_list;
+	struct list_head func_list;
+	u32 id;
+	u32 domain_id;
+	/* The qid_map represents the hardware QID mapping state. */
+	struct dlb_ldb_port_qid_map qid_map[DLB_MAX_NUM_QIDS_PER_LDB_CQ];
+	u32 hist_list_entry_base;
+	u32 hist_list_entry_limit;
+	u32 ref_cnt;
+	u8 init_tkn_cnt;
+	u8 num_pending_removals;
+	u8 num_mappings;
+	u8 owned;
+	u8 enabled;
+	u8 configured;
+};
+
+struct dlb_sn_group {
+	u32 mode;
+	u32 sequence_numbers_per_queue;
+	u32 slot_use_bitmap;
+	u32 id;
+};
+
+/*
+ * Scheduling domain level resource data structure.
+ *
+ */
+struct dlb_hw_domain {
+	struct dlb_function_resources *parent_func;
+	struct list_head func_list;
+	struct list_head used_ldb_queues;
+	struct list_head used_ldb_ports[DLB_NUM_COS_DOMAINS];
+	struct list_head used_dir_pq_pairs;
+	struct list_head avail_ldb_queues;
+	struct list_head avail_ldb_ports[DLB_NUM_COS_DOMAINS];
+	struct list_head avail_dir_pq_pairs;
+	u32 total_hist_list_entries;
+	u32 avail_hist_list_entries;
+	u32 hist_list_entry_base;
+	u32 hist_list_entry_offset;
+	u32 num_ldb_credits;
+	u32 num_dir_credits;
+	u32 num_avail_aqed_entries;
+	u32 num_used_aqed_entries;
+	u32 id;
+	int num_pending_removals;
+	int num_pending_additions;
+	u8 configured;
+	u8 started;
+};
+
+/*
+ * Device function (either PF or VF) level resource data structure.
+ *
+ */
+struct dlb_function_resources {
+	struct list_head avail_domains;
+	struct list_head used_domains;
+	struct list_head avail_ldb_queues;
+	struct list_head avail_ldb_ports[DLB_NUM_COS_DOMAINS];
+	struct list_head avail_dir_pq_pairs;
+	struct dlb_bitmap *avail_hist_list_entries;
+	u32 num_avail_domains;
+	u32 num_avail_ldb_queues;
+	u32 num_avail_ldb_ports[DLB_NUM_COS_DOMAINS];
+	u32 num_avail_dir_pq_pairs;
+	u32 num_avail_qed_entries;
+	u32 num_avail_dqed_entries;
+	u32 num_avail_aqed_entries;
+	u8 locked; /* (VDEV only) */
+};
+
+/*
+ * After initialization, each resource in dlb_hw_resources is located in one
+ * of the following lists:
+ * -- The PF's available resources list. These are unconfigured resources owned
+ *	by the PF and not allocated to a dlb scheduling domain.
+ * -- A VDEV's available resources list. These are VDEV-owned unconfigured
+ *	resources not allocated to a dlb scheduling domain.
+ * -- A domain's available resources list. These are domain-owned unconfigured
+ *	resources.
+ * -- A domain's used resources list. These are domain-owned configured
+ *	resources.
+ *
+ * A resource moves to a new list when a VDEV or domain is created or destroyed,
+ * or when the resource is configured.
+ */
+struct dlb_hw_resources {
+	struct dlb_ldb_queue ldb_queues[DLB_MAX_NUM_LDB_QUEUES];
+	struct dlb_ldb_port ldb_ports[DLB_MAX_NUM_LDB_PORTS];
+	struct dlb_dir_pq_pair dir_pq_pairs[DLB_MAX_NUM_DIR_PORTS];
+	struct dlb_sn_group sn_groups[DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS];
+};
+
 struct dlb_hw {
 	/* BAR 0 address */
 	void __iomem *csr_kva;
@@ -49,6 +214,13 @@ struct dlb_hw {
 	/* BAR 2 address */
 	void __iomem *func_kva;
 	unsigned long func_phys_addr;
+
+	/* Resource tracking */
+	struct dlb_hw_resources rsrcs;
+	struct dlb_function_resources pf;
+	struct dlb_function_resources vdev[DLB_MAX_NUM_VDEVS];
+	struct dlb_hw_domain domains[DLB_MAX_NUM_DOMAINS];
+	u8 cos_reservation[DLB_NUM_COS_DOMAINS];
 };
 
 /*
@@ -70,14 +242,91 @@ struct dlb;
 
 int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
 void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
+int dlb_pf_init_driver_state(struct dlb *dlb);
+void dlb_pf_enable_pm(struct dlb *dlb);
+int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev);
 
 struct dlb {
 	struct pci_dev *pdev;
 	struct dlb_hw hw;
 	struct device *dev;
+	/*
+	 * The resource mutex serializes access to driver data structures and
+	 * hardware registers.
+	 */
+	struct mutex resource_mutex;
 	enum dlb_device_type type;
 	int id;
 	dev_t dev_number;
 };
 
+/*************************/
+/*** Bitmap operations ***/
+/*************************/
+struct dlb_bitmap {
+	unsigned long *map;
+	unsigned int len;
+};
+
+/**
+ * dlb_bitmap_alloc() - alloc a bitmap data structure
+ * @bitmap: pointer to dlb_bitmap structure pointer.
+ * @len: number of entries in the bitmap.
+ *
+ * This function allocates a bitmap and initializes it with length @len. All
+ * entries are initially zero.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise.
+ *
+ * Errors:
+ * EINVAL - bitmap is NULL or len is 0.
+ * ENOMEM - could not allocate memory for the bitmap data structure.
+ */
+static inline int dlb_bitmap_alloc(struct dlb_bitmap **bitmap,
+				   unsigned int len)
+{
+	struct dlb_bitmap *bm;
+
+	if (!bitmap || len == 0)
+		return -EINVAL;
+
+	bm = kzalloc(sizeof(*bm), GFP_KERNEL);
+	if (!bm)
+		return -ENOMEM;
+
+	bm->map = bitmap_zalloc(len, GFP_KERNEL);
+	if (!bm->map) {
+		kfree(bm);
+		return -ENOMEM;
+	}
+
+	bm->len = len;
+
+	*bitmap = bm;
+
+	return 0;
+}
+
+/**
+ * dlb_bitmap_free() - free a previously allocated bitmap data structure
+ * @bitmap: pointer to dlb_bitmap structure.
+ *
+ * This function frees a bitmap that was allocated with dlb_bitmap_alloc().
+ */
+static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
+{
+	if (!bitmap)
+		return;
+
+	bitmap_free(bitmap->map);
+
+	kfree(bitmap);
+}
+
+/* Prototypes for dlb_resource.c */
+int dlb_resource_init(struct dlb_hw *hw);
+void dlb_resource_free(struct dlb_hw *hw);
+void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
+
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 77ca7bf2d961..8d179beb9d5b 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
+#include <linux/delay.h>
+
 #include "dlb_main.h"
+#include "dlb_regs.h"
 
 /********************************/
 /****** PCI BAR management ******/
@@ -31,3 +34,56 @@ int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
 
 	return 0;
 }
+
+/*******************************/
+/****** Driver management ******/
+/*******************************/
+
+int dlb_pf_init_driver_state(struct dlb *dlb)
+{
+	mutex_init(&dlb->resource_mutex);
+
+	return 0;
+}
+
+void dlb_pf_enable_pm(struct dlb *dlb)
+{
+	/*
+	 * Clear the power-management-disable register to power on the bulk of
+	 * the device's hardware.
+	 */
+	dlb_clr_pmcsr_disable(&dlb->hw);
+}
+
+#define DLB_READY_RETRY_LIMIT 1000
+int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev)
+{
+	u32 retries = DLB_READY_RETRY_LIMIT;
+
+	/* Allow at least 1s for the device to become active after power-on */
+	do {
+		u32 idle, pm_st, addr;
+
+		addr = CM_CFG_PM_STATUS;
+
+		pm_st = DLB_CSR_RD(&dlb->hw, addr);
+
+		addr = CM_CFG_DIAGNOSTIC_IDLE_STATUS;
+
+		idle = DLB_CSR_RD(&dlb->hw, addr);
+
+		if (FIELD_GET(CM_CFG_PM_STATUS_PMSM, pm_st) == 1 &&
+		    FIELD_GET(CM_CFG_DIAGNOSTIC_IDLE_STATUS_DLB_FUNC_IDLE, idle)
+		    == 1)
+			break;
+
+		usleep_range(1000, 2000);
+	} while (--retries);
+
+	if (!retries) {
+		dev_err(&pdev->dev, "Device idle test failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/misc/dlb/dlb_regs.h b/drivers/misc/dlb/dlb_regs.h
new file mode 100644
index 000000000000..72f3cb22b933
--- /dev/null
+++ b/drivers/misc/dlb/dlb_regs.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_REGS_H
+#define __DLB_REGS_H
+
+#include <linux/types.h>
+
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS 0xb4000004
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RST 0x9d0fffff
+
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_CHP_PIPEIDLE		0x00000001
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_ROP_PIPEIDLE		0x00000002
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_LSP_PIPEIDLE		0x00000004
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_NALB_PIPEIDLE		0x00000008
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AP_PIPEIDLE		0x00000010
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DP_PIPEIDLE		0x00000020
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_QED_PIPEIDLE		0x00000040
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DQED_PIPEIDLE		0x00000080
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AQED_PIPEIDLE		0x00000100
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_SYS_PIPEIDLE		0x00000200
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_CHP_UNIT_IDLE		0x00000400
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_ROP_UNIT_IDLE		0x00000800
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_LSP_UNIT_IDLE		0x00001000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_NALB_UNIT_IDLE		0x00002000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AP_UNIT_IDLE		0x00004000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DP_UNIT_IDLE		0x00008000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_QED_UNIT_IDLE		0x00010000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DQED_UNIT_IDLE		0x00020000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AQED_UNIT_IDLE		0x00040000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_SYS_UNIT_IDLE		0x00080000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RSVD1			0x00F00000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_CFG_RING_IDLE	0x01000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_CFG_MSTR_IDLE	0x02000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_FLR_CLKREQ_B		0x04000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_PROC_IDLE		0x08000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_PROC_IDLE_MASKED	0x10000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RSVD0			0x60000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DLB_FUNC_IDLE		0x80000000
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_CHP_PIPEIDLE_LOC		0
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_ROP_PIPEIDLE_LOC		1
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_LSP_PIPEIDLE_LOC		2
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_NALB_PIPEIDLE_LOC		3
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AP_PIPEIDLE_LOC		4
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DP_PIPEIDLE_LOC		5
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_QED_PIPEIDLE_LOC		6
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DQED_PIPEIDLE_LOC		7
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AQED_PIPEIDLE_LOC		8
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_SYS_PIPEIDLE_LOC		9
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_CHP_UNIT_IDLE_LOC		10
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_ROP_UNIT_IDLE_LOC		11
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_LSP_UNIT_IDLE_LOC		12
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_NALB_UNIT_IDLE_LOC	13
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AP_UNIT_IDLE_LOC		14
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DP_UNIT_IDLE_LOC		15
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_QED_UNIT_IDLE_LOC		16
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DQED_UNIT_IDLE_LOC	17
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_AQED_UNIT_IDLE_LOC	18
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_SYS_UNIT_IDLE_LOC		19
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RSVD1_LOC			20
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_CFG_RING_IDLE_LOC	24
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_CFG_MSTR_IDLE_LOC	25
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_FLR_CLKREQ_B_LOC	26
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_PROC_IDLE_LOC	27
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_MSTR_PROC_IDLE_MASKED_LOC	28
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RSVD0_LOC			29
+#define CM_CFG_DIAGNOSTIC_IDLE_STATUS_DLB_FUNC_IDLE_LOC		31
+
+#define CM_CFG_PM_STATUS 0xb4000014
+#define CM_CFG_PM_STATUS_RST 0x100403e
+
+#define CM_CFG_PM_STATUS_PROCHOT		0x00000001
+#define CM_CFG_PM_STATUS_PGCB_DLB_IDLE		0x00000002
+#define CM_CFG_PM_STATUS_PGCB_DLB_PG_RDY_ACK_B	0x00000004
+#define CM_CFG_PM_STATUS_PMSM_PGCB_REQ_B	0x00000008
+#define CM_CFG_PM_STATUS_PGBC_PMC_PG_REQ_B	0x00000010
+#define CM_CFG_PM_STATUS_PMC_PGCB_PG_ACK_B	0x00000020
+#define CM_CFG_PM_STATUS_PMC_PGCB_FET_EN_B	0x00000040
+#define CM_CFG_PM_STATUS_PGCB_FET_EN_B		0x00000080
+#define CM_CFG_PM_STATUS_RSVZ0			0x00000100
+#define CM_CFG_PM_STATUS_RSVZ1			0x00000200
+#define CM_CFG_PM_STATUS_FUSE_FORCE_ON		0x00000400
+#define CM_CFG_PM_STATUS_FUSE_PROC_DISABLE	0x00000800
+#define CM_CFG_PM_STATUS_RSVZ2			0x00001000
+#define CM_CFG_PM_STATUS_RSVZ3			0x00002000
+#define CM_CFG_PM_STATUS_PM_FSM_D0TOD3_OK	0x00004000
+#define CM_CFG_PM_STATUS_PM_FSM_D3TOD0_OK	0x00008000
+#define CM_CFG_PM_STATUS_DLB_IN_D3		0x00010000
+#define CM_CFG_PM_STATUS_RSVZ4			0x00FE0000
+#define CM_CFG_PM_STATUS_PMSM			0xFF000000
+#define CM_CFG_PM_STATUS_PROCHOT_LOC			0
+#define CM_CFG_PM_STATUS_PGCB_DLB_IDLE_LOC		1
+#define CM_CFG_PM_STATUS_PGCB_DLB_PG_RDY_ACK_B_LOC	2
+#define CM_CFG_PM_STATUS_PMSM_PGCB_REQ_B_LOC		3
+#define CM_CFG_PM_STATUS_PGBC_PMC_PG_REQ_B_LOC		4
+#define CM_CFG_PM_STATUS_PMC_PGCB_PG_ACK_B_LOC		5
+#define CM_CFG_PM_STATUS_PMC_PGCB_FET_EN_B_LOC		6
+#define CM_CFG_PM_STATUS_PGCB_FET_EN_B_LOC		7
+#define CM_CFG_PM_STATUS_RSVZ0_LOC			8
+#define CM_CFG_PM_STATUS_RSVZ1_LOC			9
+#define CM_CFG_PM_STATUS_FUSE_FORCE_ON_LOC		10
+#define CM_CFG_PM_STATUS_FUSE_PROC_DISABLE_LOC		11
+#define CM_CFG_PM_STATUS_RSVZ2_LOC			12
+#define CM_CFG_PM_STATUS_RSVZ3_LOC			13
+#define CM_CFG_PM_STATUS_PM_FSM_D0TOD3_OK_LOC		14
+#define CM_CFG_PM_STATUS_PM_FSM_D3TOD0_OK_LOC		15
+#define CM_CFG_PM_STATUS_DLB_IN_D3_LOC			16
+#define CM_CFG_PM_STATUS_RSVZ4_LOC			17
+#define CM_CFG_PM_STATUS_PMSM_LOC			24
+
+#define CM_CFG_PM_PMCSR_DISABLE 0xb4000018
+#define CM_CFG_PM_PMCSR_DISABLE_RST 0x1
+
+#define CM_CFG_PM_PMCSR_DISABLE_DISABLE	0x00000001
+#define CM_CFG_PM_PMCSR_DISABLE_RSVZ0	0xFFFFFFFE
+#define CM_CFG_PM_PMCSR_DISABLE_DISABLE_LOC	0
+#define CM_CFG_PM_PMCSR_DISABLE_RSVZ0_LOC	1
+
+#endif /* __DLB_REGS_H */
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
new file mode 100644
index 000000000000..c192d4fb8463
--- /dev/null
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include "dlb_regs.h"
+#include "dlb_main.h"
+
+static void dlb_init_fn_rsrc_lists(struct dlb_function_resources *rsrc)
+{
+	int i;
+
+	INIT_LIST_HEAD(&rsrc->avail_domains);
+	INIT_LIST_HEAD(&rsrc->used_domains);
+	INIT_LIST_HEAD(&rsrc->avail_ldb_queues);
+	INIT_LIST_HEAD(&rsrc->avail_dir_pq_pairs);
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		INIT_LIST_HEAD(&rsrc->avail_ldb_ports[i]);
+}
+
+static void dlb_init_domain_rsrc_lists(struct dlb_hw_domain *domain)
+{
+	int i;
+
+	INIT_LIST_HEAD(&domain->used_ldb_queues);
+	INIT_LIST_HEAD(&domain->used_dir_pq_pairs);
+	INIT_LIST_HEAD(&domain->avail_ldb_queues);
+	INIT_LIST_HEAD(&domain->avail_dir_pq_pairs);
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		INIT_LIST_HEAD(&domain->used_ldb_ports[i]);
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		INIT_LIST_HEAD(&domain->avail_ldb_ports[i]);
+}
+
+/**
+ * dlb_resource_free() - free device state memory
+ * @hw: dlb_hw handle for a particular device.
+ *
+ * This function frees software state pointed to by dlb_hw. This function
+ * should be called when resetting the device or unloading the driver.
+ */
+void dlb_resource_free(struct dlb_hw *hw)
+{
+	int i;
+
+	if (hw->pf.avail_hist_list_entries)
+		dlb_bitmap_free(hw->pf.avail_hist_list_entries);
+
+	for (i = 0; i < DLB_MAX_NUM_VDEVS; i++) {
+		if (hw->vdev[i].avail_hist_list_entries)
+			dlb_bitmap_free(hw->vdev[i].avail_hist_list_entries);
+	}
+}
+
+/**
+ * dlb_resource_init() - initialize the device
+ * @hw: pointer to struct dlb_hw.
+ *
+ * This function initializes the device's software state (pointed to by the hw
+ * argument) and programs global scheduling QoS registers. This function should
+ * be called during driver initialization, and the dlb_hw structure should
+ * be zero-initialized before calling the function.
+ *
+ * The dlb_hw struct must be unique per DLB 2.0 device and persist until the
+ * device is reset.
+ *
+ * Return:
+ * Returns 0 upon success, <0 otherwise.
+ */
+int dlb_resource_init(struct dlb_hw *hw)
+{
+	struct dlb_bitmap *map;
+	struct list_head *list;
+	unsigned int i;
+	int ret;
+
+	/*
+	 * For optimal load-balancing, ports that map to one or more QIDs in
+	 * common should not be in numerical sequence. The port->QID mapping is
+	 * application dependent, but the driver interleaves port IDs as much
+	 * as possible to reduce the likelihood of sequential ports mapping to
+	 * the same QID(s). This initial allocation of port IDs maximizes the
+	 * average distance between an ID and its immediate neighbors (i.e.
+	 * the distance from 1 to 0 and to 2, the distance from 2 to 1 and to
+	 * 3, etc.).
+	 */
+	const u8 init_ldb_port_allocation[DLB_MAX_NUM_LDB_PORTS] = {
+		0,  7,  14,  5, 12,  3, 10,  1,  8, 15,  6, 13,  4, 11,  2,  9,
+		16, 23, 30, 21, 28, 19, 26, 17, 24, 31, 22, 29, 20, 27, 18, 25,
+		32, 39, 46, 37, 44, 35, 42, 33, 40, 47, 38, 45, 36, 43, 34, 41,
+		48, 55, 62, 53, 60, 51, 58, 49, 56, 63, 54, 61, 52, 59, 50, 57,
+	};
+
+	dlb_init_fn_rsrc_lists(&hw->pf);
+
+	for (i = 0; i < DLB_MAX_NUM_VDEVS; i++)
+		dlb_init_fn_rsrc_lists(&hw->vdev[i]);
+
+	for (i = 0; i < DLB_MAX_NUM_DOMAINS; i++) {
+		dlb_init_domain_rsrc_lists(&hw->domains[i]);
+		hw->domains[i].parent_func = &hw->pf;
+	}
+
+	/* Give all resources to the PF driver */
+	hw->pf.num_avail_domains = DLB_MAX_NUM_DOMAINS;
+	for (i = 0; i < hw->pf.num_avail_domains; i++) {
+		list = &hw->domains[i].func_list;
+
+		list_add(list, &hw->pf.avail_domains);
+	}
+
+	hw->pf.num_avail_ldb_queues = DLB_MAX_NUM_LDB_QUEUES;
+	for (i = 0; i < hw->pf.num_avail_ldb_queues; i++) {
+		list = &hw->rsrcs.ldb_queues[i].func_list;
+
+		list_add(list, &hw->pf.avail_ldb_queues);
+	}
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		hw->pf.num_avail_ldb_ports[i] =
+			DLB_MAX_NUM_LDB_PORTS / DLB_NUM_COS_DOMAINS;
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_PORTS; i++) {
+		int cos_id = i >> DLB_NUM_COS_DOMAINS;
+		struct dlb_ldb_port *port;
+
+		port = &hw->rsrcs.ldb_ports[init_ldb_port_allocation[i]];
+
+		list_add(&port->func_list, &hw->pf.avail_ldb_ports[cos_id]);
+	}
+
+	hw->pf.num_avail_dir_pq_pairs = DLB_MAX_NUM_DIR_PORTS;
+	for (i = 0; i < hw->pf.num_avail_dir_pq_pairs; i++) {
+		list = &hw->rsrcs.dir_pq_pairs[i].func_list;
+
+		list_add(list, &hw->pf.avail_dir_pq_pairs);
+	}
+
+	hw->pf.num_avail_qed_entries = DLB_MAX_NUM_LDB_CREDITS;
+	hw->pf.num_avail_dqed_entries = DLB_MAX_NUM_DIR_CREDITS;
+	hw->pf.num_avail_aqed_entries = DLB_MAX_NUM_AQED_ENTRIES;
+
+	ret = dlb_bitmap_alloc(&hw->pf.avail_hist_list_entries,
+			       DLB_MAX_NUM_HIST_LIST_ENTRIES);
+	if (ret)
+		goto unwind;
+
+	map = hw->pf.avail_hist_list_entries;
+	bitmap_fill(map->map, map->len);
+
+	for (i = 0; i < DLB_MAX_NUM_VDEVS; i++) {
+		ret = dlb_bitmap_alloc(&hw->vdev[i].avail_hist_list_entries,
+				       DLB_MAX_NUM_HIST_LIST_ENTRIES);
+		if (ret)
+			goto unwind;
+
+		map = hw->vdev[i].avail_hist_list_entries;
+		bitmap_zero(map->map, map->len);
+	}
+
+	/* Initialize the hardware resource IDs */
+	for (i = 0; i < DLB_MAX_NUM_DOMAINS; i++)
+		hw->domains[i].id = i;
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_QUEUES; i++)
+		hw->rsrcs.ldb_queues[i].id = i;
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_PORTS; i++)
+		hw->rsrcs.ldb_ports[i].id = i;
+
+	for (i = 0; i < DLB_MAX_NUM_DIR_PORTS; i++)
+		hw->rsrcs.dir_pq_pairs[i].id = i;
+
+	for (i = 0; i < DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS; i++) {
+		hw->rsrcs.sn_groups[i].id = i;
+		/* Default mode (0) is 64 sequence numbers per queue */
+		hw->rsrcs.sn_groups[i].mode = 0;
+		hw->rsrcs.sn_groups[i].sequence_numbers_per_queue = 64;
+		hw->rsrcs.sn_groups[i].slot_use_bitmap = 0;
+	}
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		hw->cos_reservation[i] = 100 / DLB_NUM_COS_DOMAINS;
+
+	return 0;
+
+unwind:
+	dlb_resource_free(hw);
+
+	return ret;
+}
+
+/**
+ * dlb_clr_pmcsr_disable() - power on bulk of DLB 2.0 logic
+ * @hw: dlb_hw handle for a particular device.
+ *
+ * Clearing the PMCSR must be done at initialization to make the device fully
+ * operational.
+ */
+void dlb_clr_pmcsr_disable(struct dlb_hw *hw)
+{
+	u32 pmcsr_dis;
+
+	pmcsr_dis = DLB_CSR_RD(hw, CM_CFG_PM_PMCSR_DISABLE);
+
+	/* Clear register bits */
+	pmcsr_dis &= ~CM_CFG_PM_PMCSR_DISABLE_DISABLE;
+
+	DLB_CSR_WR(hw, CM_CFG_PM_PMCSR_DISABLE, pmcsr_dis);
+}
-- 
2.27.0

