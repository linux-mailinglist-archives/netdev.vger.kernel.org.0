Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379D5316D71
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhBJR5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:57:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:60424 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhBJR4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:56:55 -0500
IronPort-SDR: Uvp1RRGAQlme63LHo8+vdr814cJVlps2IKljVcyET4y+u6Pt8/VIioBitCXP/Ccm/rVS30Wou9
 UMe4TnqMui7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236012"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236012"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:06 -0800
IronPort-SDR: nO8QFxjL8KhqlE5iFyEt7ngwHNkhcigGcu2U3l94jsWUnfNmQzQD9TAM+tCGM65ERavCoZbXxK
 cancO9lnuGmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235716"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:05 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 03/20] dlb: add resource and device initialization
Date:   Wed, 10 Feb 2021 11:54:06 -0600
Message-Id: <20210210175423.1873-4-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the hardware resource data structures, functions for
their initialization/teardown, and a function for device power-on. In
subsequent commits, dlb_resource.c will be expanded to hold the dlb
resource-management and configuration logic (using the data structures
defined in dlb_hw_types.h).

Introduce dlb_bitmap_* functions, a thin convenience layer wrapping the
Linux bitmap interfaces, used by the bitmaps in the dlb hardware types.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/Makefile       |   2 +-
 drivers/misc/dlb/dlb_bitmap.h   |  76 +++++++++++
 drivers/misc/dlb/dlb_hw_types.h | 177 +++++++++++++++++++++++++
 drivers/misc/dlb/dlb_main.c     |  47 +++++++
 drivers/misc/dlb/dlb_main.h     |   8 ++
 drivers/misc/dlb/dlb_pf_ops.c   |  66 +++++++++-
 drivers/misc/dlb/dlb_regs.h     | 119 +++++++++++++++++
 drivers/misc/dlb/dlb_resource.c | 220 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.h |  17 +++
 9 files changed, 727 insertions(+), 5 deletions(-)
 create mode 100644 drivers/misc/dlb/dlb_bitmap.h
 create mode 100644 drivers/misc/dlb/dlb_regs.h
 create mode 100644 drivers/misc/dlb/dlb_resource.c
 create mode 100644 drivers/misc/dlb/dlb_resource.h

diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index a33bf774e6a8..8a49ea5fd752 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -7,4 +7,4 @@
 obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
-dlb-objs += dlb_pf_ops.o
+dlb-objs += dlb_pf_ops.o dlb_resource.o
diff --git a/drivers/misc/dlb/dlb_bitmap.h b/drivers/misc/dlb/dlb_bitmap.h
new file mode 100644
index 000000000000..fb3ef52a306d
--- /dev/null
+++ b/drivers/misc/dlb/dlb_bitmap.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_OSDEP_BITMAP_H
+#define __DLB_OSDEP_BITMAP_H
+
+#include <linux/bitmap.h>
+#include <linux/slab.h>
+
+#include "dlb_main.h"
+
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
+#endif /*  __DLB_OSDEP_BITMAP_H */
diff --git a/drivers/misc/dlb/dlb_hw_types.h b/drivers/misc/dlb/dlb_hw_types.h
index a4ce28c157de..3e03b061d5ff 100644
--- a/drivers/misc/dlb/dlb_hw_types.h
+++ b/drivers/misc/dlb/dlb_hw_types.h
@@ -5,6 +5,13 @@
 #define __DLB_HW_TYPES_H
 
 #include <linux/io.h>
+#include <linux/types.h>
+
+#include "dlb_bitmap.h"
+
+#define BITS_SET(x, val, mask)	(x = ((x) & ~(mask))     \
+				 | (((val) << (mask##_LOC)) & (mask)))
+#define BITS_GET(x, mask)       (((x) & (mask)) >> (mask##_LOC))
 
 /* Read/write register 'reg' in the CSR BAR space */
 #define DLB_CSR_REG_ADDR(a, reg)   ((a)->csr_kva + (reg))
@@ -43,6 +50,169 @@
 
 #define PCI_DEVICE_ID_INTEL_DLB_PF		0x2710
 
+struct dlb_resource_id {
+	u32 phys_id;
+	u32 virt_id;
+	u8 vdev_owned;
+	u8 vdev_id;
+};
+
+struct dlb_freelist {
+	u32 base;
+	u32 bound;
+	u32 offset;
+};
+
+static inline u32 dlb_freelist_count(struct dlb_freelist *list)
+{
+	return list->bound - list->base - list->offset;
+}
+
+struct dlb_ldb_queue {
+	struct list_head domain_list;
+	struct list_head func_list;
+	struct dlb_resource_id id;
+	struct dlb_resource_id domain_id;
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
+	struct dlb_resource_id id;
+	struct dlb_resource_id domain_id;
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
+	struct dlb_resource_id id;
+	struct dlb_resource_id domain_id;
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
+	struct dlb_resource_id id;
+	int num_pending_removals;
+	int num_pending_additions;
+	u8 configured;
+	u8 started;
+};
+
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
@@ -50,6 +220,13 @@ struct dlb_hw {
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
 
 #endif /* __DLB_HW_TYPES_H */
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 7fb6e9c360c8..12707b23ab3e 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 
 #include "dlb_main.h"
+#include "dlb_resource.h"
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel(R) Dynamic Load Balancer (DLB) Driver");
@@ -21,6 +22,23 @@ static dev_t dlb_devt;
 static DEFINE_IDR(dlb_ids);
 static DEFINE_SPINLOCK(dlb_ids_lock);
 
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
@@ -113,8 +131,35 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto dma_set_mask_fail;
 
+	/*
+	 * PM enable must be done before any other MMIO accesses, and this
+	 * setting is persistent across device reset.
+	 */
+	dlb->ops->enable_pm(dlb);
+
+	ret = dlb->ops->wait_for_device_ready(dlb, pdev);
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
+	ret = dlb->ops->init_driver_state(dlb);
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
@@ -131,6 +176,8 @@ static void dlb_remove(struct pci_dev *pdev)
 {
 	struct dlb *dlb = pci_get_drvdata(pdev);
 
+	dlb_resource_free(&dlb->hw);
+
 	device_destroy(dlb_class, dlb->dev_number);
 
 	pci_disable_pcie_error_reporting(pdev);
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 21570b206419..ec5eb7bd8f54 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -34,6 +34,9 @@ struct dlb;
 struct dlb_device_ops {
 	int (*map_pci_bar_space)(struct dlb *dlb, struct pci_dev *pdev);
 	void (*unmap_pci_bar_space)(struct dlb *dlb, struct pci_dev *pdev);
+	int (*init_driver_state)(struct dlb *dlb);
+	void (*enable_pm)(struct dlb *dlb);
+	int (*wait_for_device_ready)(struct dlb *dlb, struct pci_dev *pdev);
 };
 
 extern struct dlb_device_ops dlb_pf_ops;
@@ -43,6 +46,11 @@ struct dlb {
 	struct dlb_hw hw;
 	struct dlb_device_ops *ops;
 	struct device *dev;
+	/*
+	 * The resource mutex serializes access to driver data structures and
+	 * hardware registers.
+	 */
+	struct mutex resource_mutex;
 	enum dlb_device_type type;
 	int id;
 	dev_t dev_number;
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 0951c99f6183..124b4fee8564 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -1,21 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
+#include <linux/delay.h>
+
 #include "dlb_main.h"
+#include "dlb_regs.h"
+#include "dlb_resource.h"
 
 /********************************/
 /****** PCI BAR management ******/
 /********************************/
 
-static void
-dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
+static void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
 {
 	pcim_iounmap(pdev, dlb->hw.csr_kva);
 	pcim_iounmap(pdev, dlb->hw.func_kva);
 }
 
-static int
-dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
+static int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
 {
 	dlb->hw.func_kva = pcim_iomap_table(pdev)[DLB_FUNC_BAR];
 	dlb->hw.func_phys_addr = pci_resource_start(pdev, DLB_FUNC_BAR);
@@ -40,6 +42,59 @@ dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
 	return 0;
 }
 
+/*******************************/
+/****** Driver management ******/
+/*******************************/
+
+static int dlb_pf_init_driver_state(struct dlb *dlb)
+{
+	mutex_init(&dlb->resource_mutex);
+
+	return 0;
+}
+
+static void dlb_pf_enable_pm(struct dlb *dlb)
+{
+	/*
+	 * Clear the power-management-disable register to power on the bulk of
+	 * the device's hardware.
+	 */
+	dlb_clr_pmcsr_disable(&dlb->hw);
+}
+
+#define DLB_READY_RETRY_LIMIT 1000
+static int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev)
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
+		if (BITS_GET(pm_st, CM_CFG_PM_STATUS_PMSM) == 1 &&
+		    BITS_GET(idle, CM_CFG_DIAGNOSTIC_IDLE_STATUS_DLB_FUNC_IDLE)
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
+
 /********************************/
 /****** DLB PF Device Ops ******/
 /********************************/
@@ -47,4 +102,7 @@ dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
 struct dlb_device_ops dlb_pf_ops = {
 	.map_pci_bar_space = dlb_pf_map_pci_bar_space,
 	.unmap_pci_bar_space = dlb_pf_unmap_pci_bar_space,
+	.init_driver_state = dlb_pf_init_driver_state,
+	.enable_pm = dlb_pf_enable_pm,
+	.wait_for_device_ready = dlb_pf_wait_for_device_ready,
 };
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
index 000000000000..fca444c46aca
--- /dev/null
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include "dlb_bitmap.h"
+#include "dlb_hw_types.h"
+#include "dlb_regs.h"
+#include "dlb_resource.h"
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
+	for (i = 0; i < DLB_MAX_NUM_DOMAINS; i++) {
+		hw->domains[i].id.phys_id = i;
+		hw->domains[i].id.vdev_owned = false;
+	}
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_QUEUES; i++) {
+		hw->rsrcs.ldb_queues[i].id.phys_id = i;
+		hw->rsrcs.ldb_queues[i].id.vdev_owned = false;
+	}
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_PORTS; i++) {
+		hw->rsrcs.ldb_ports[i].id.phys_id = i;
+		hw->rsrcs.ldb_ports[i].id.vdev_owned = false;
+	}
+
+	for (i = 0; i < DLB_MAX_NUM_DIR_PORTS; i++) {
+		hw->rsrcs.dir_pq_pairs[i].id.phys_id = i;
+		hw->rsrcs.dir_pq_pairs[i].id.vdev_owned = false;
+	}
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
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
new file mode 100644
index 000000000000..2229813d9c45
--- /dev/null
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_RESOURCE_H
+#define __DLB_RESOURCE_H
+
+#include <linux/types.h>
+
+#include "dlb_hw_types.h"
+
+int dlb_resource_init(struct dlb_hw *hw);
+
+void dlb_resource_free(struct dlb_hw *hw);
+
+void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
+
+#endif /* __DLB_RESOURCE_H */
-- 
2.17.1

