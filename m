Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8743447BA2C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhLUGuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:29890 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234296AbhLUGuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069420; x=1671605420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UklYNvsFkl2Q5UfLCQQh0wnUPn0/Uw2OLvdAUwBwOB4=;
  b=bXdG9BKfuCILqqWlHlCOSx5b9Zv0ZKEBUHK+4G3rKQf2YAlnyeY3Ii/d
   5GaHp1CmVfdcK8k8SuvOYLxEXuVo/qn3fOuWP+cQa05tuFIyDfLJjlFRU
   y6rHGDN3oTCVgf5SQw21R1K3+TiMJ2ea2bMxafl9O9ogyHV96SQUQ5uY0
   YrkX55RGUV4C9PWrTLi82B1vWawWJTSFDediiTkrnjB2CqZjjainf68b5
   RDMUAmg1CyN1uKthlUz5Klox4X5j+m5LwTCdDlJ0GGZ1bLt6YMwcSTZB3
   20gYNS51NQ4VZuOsCg0lpaySEMQLYatryd3OphpGLMVyq1U12FwkqgD3c
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107472"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107472"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119004"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:18 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 05/17] dlb: add scheduling domain configuration
Date:   Tue, 21 Dec 2021 00:50:35 -0600
Message-Id: <20211221065047.290182-6-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring a scheduling domain, creating the domain fd,
and reserving the domain's resources.

When a user requests to create a scheduling domain via configfs, the
requested resources are validated against the number currently available,
and then reserved for the scheduling domain. An anonymous file descriptor
for the domain is created and installed in the calling process's file
descriptor table.

The driver maintains a reference count for each scheduling domain,
incrementing it each time user-space requests a file descriptor for a dlb
port access and decrementing it in the file's release callback.

When the reference count transitions from 1->0 the driver automatically
resets the scheduling domain's resources and makes them available for use
by future applications. This ensures that applications that crash without
explicitly cleaning up do not orphan device resources. The code to perform
the domain reset will be added in subsequent commits.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_configfs.c |  46 ++-
 drivers/misc/dlb/dlb_main.c     |  68 ++++
 drivers/misc/dlb/dlb_main.h     | 128 ++++++++
 drivers/misc/dlb/dlb_regs.h     |  18 ++
 drivers/misc/dlb/dlb_resource.c | 528 +++++++++++++++++++++++++++++++-
 include/uapi/linux/dlb.h        |  22 ++
 6 files changed, 808 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/dlb.h

diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index bdabf3c6444f..7e5db0390a6a 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 // Copyright(c) 2017-2020 Intel Corporation
 
+#include <linux/anon_inodes.h>
+#include <linux/version.h>
 #include <linux/configfs.h>
+#include <linux/fdtable.h>
 #include "dlb_configfs.h"
 
 struct dlb_device_configfs dlb_dev_configfs[16];
@@ -11,12 +14,38 @@ static int dlb_configfs_create_sched_domain(struct dlb *dlb,
 {
 	struct dlb_create_sched_domain_args *arg = karg;
 	struct dlb_cmd_response response = {0};
-	int ret;
+	struct dlb_domain *domain;
+	u32 flags = O_RDONLY;
+	int ret, fd;
 
 	mutex_lock(&dlb->resource_mutex);
 
 	ret = dlb_hw_create_sched_domain(&dlb->hw, arg, &response);
+	if (ret)
+		goto unlock;
+
+	ret = dlb_init_domain(dlb, response.id);
+	if (ret)
+		goto unlock;
 
+	domain = dlb->sched_domains[response.id];
+
+	if (dlb->f->f_mode & FMODE_WRITE)
+		flags = O_RDWR;
+
+	fd = anon_inode_getfd("[dlbdomain]", &dlb_domain_fops,
+			      domain, flags);
+
+	if (fd < 0) {
+		dev_err(dlb->dev, "Failed to get anon fd.\n");
+		kref_put(&domain->refcnt, dlb_free_domain);
+		ret = fd;
+		goto unlock;
+	}
+
+	arg->domain_fd = fd;
+
+unlock:
 	mutex_unlock(&dlb->resource_mutex);
 
 	memcpy(karg, &response, sizeof(response));
@@ -84,6 +113,7 @@ static ssize_t dlb_cfs_domain_##name##_store(			\
 	return count;						\
 }								\
 
+DLB_CONFIGFS_DOMAIN_SHOW(domain_fd)
 DLB_CONFIGFS_DOMAIN_SHOW(status)
 DLB_CONFIGFS_DOMAIN_SHOW(domain_id)
 DLB_CONFIGFS_DOMAIN_SHOW(num_ldb_queues)
@@ -137,6 +167,7 @@ static ssize_t dlb_cfs_domain_create_store(struct config_item *item,
 
 		dlb_cfs_domain->status = args.response.status;
 		dlb_cfs_domain->domain_id = args.response.id;
+		dlb_cfs_domain->domain_fd = args.domain_fd;
 
 		if (ret) {
 			dev_err(dlb->dev,
@@ -145,11 +176,23 @@ static ssize_t dlb_cfs_domain_create_store(struct config_item *item,
 		}
 
 		dlb_cfs_domain->create = 1;
+	} else if (create_in == 0 && dlb_cfs_domain->create == 1) {
+		dev_dbg(dlb->dev,
+			"Close domain: %s\n",
+			dlb_cfs_domain->group.cg_item.ci_namebuf);
+
+		ret = close_fd(dlb_cfs_domain->domain_fd);
+		if (ret)
+			dev_err(dlb->dev,
+				"close sched domain failed: ret=%d\n", ret);
+
+		dlb_cfs_domain->create = 0;
 	}
 
 	return count;
 }
 
+CONFIGFS_ATTR_RO(dlb_cfs_domain_, domain_fd);
 CONFIGFS_ATTR_RO(dlb_cfs_domain_, status);
 CONFIGFS_ATTR_RO(dlb_cfs_domain_, domain_id);
 CONFIGFS_ATTR(dlb_cfs_domain_, num_ldb_queues);
@@ -162,6 +205,7 @@ CONFIGFS_ATTR(dlb_cfs_domain_, num_dir_credits);
 CONFIGFS_ATTR(dlb_cfs_domain_, create);
 
 static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
+	&dlb_cfs_domain_attr_domain_fd,
 	&dlb_cfs_domain_attr_status,
 	&dlb_cfs_domain_attr_domain_id,
 	&dlb_cfs_domain_attr_num_ldb_queues,
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 1bd9ca7772a9..3c949d9b4cf0 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -61,8 +61,76 @@ static int dlb_device_create(struct dlb *dlb, struct pci_dev *pdev)
 /****** Char dev callbacks ******/
 /********************************/
 
+static int dlb_open(struct inode *i, struct file *f)
+{
+	struct dlb *dlb;
+
+	mutex_lock(&dlb_ids_lock);
+	dlb = idr_find(&dlb_ids, iminor(i));
+	mutex_unlock(&dlb_ids_lock);
+
+	f->private_data = dlb;
+	dlb->f = f;
+
+	return 0;
+}
+
 static const struct file_operations dlb_fops = {
 	.owner   = THIS_MODULE,
+	.open    = dlb_open,
+};
+
+int dlb_init_domain(struct dlb *dlb, u32 domain_id)
+{
+	struct dlb_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return -ENOMEM;
+
+	domain->id = domain_id;
+
+	kref_init(&domain->refcnt);
+	domain->dlb = dlb;
+
+	dlb->sched_domains[domain_id] = domain;
+
+	return 0;
+}
+
+static int __dlb_free_domain(struct dlb_domain *domain)
+{
+	struct dlb *dlb = domain->dlb;
+
+	dlb->sched_domains[domain->id] = NULL;
+
+	kfree(domain);
+
+	return 0;
+}
+
+void dlb_free_domain(struct kref *kref)
+{
+	__dlb_free_domain(container_of(kref, struct dlb_domain, refcnt));
+}
+
+static int dlb_domain_close(struct inode *i, struct file *f)
+{
+	struct dlb_domain *domain = f->private_data;
+	struct dlb *dlb = domain->dlb;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	kref_put(&domain->refcnt, dlb_free_domain);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	return 0;
+}
+
+const struct file_operations dlb_domain_fops = {
+	.owner   = THIS_MODULE,
+	.release = dlb_domain_close,
 };
 
 /**********************************/
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 4921333a6ec3..6c9b9cce148e 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 
+#include <uapi/linux/dlb.h>
 #include "dlb_args.h"
 
 /*
@@ -248,10 +249,20 @@ int dlb_pf_init_driver_state(struct dlb *dlb);
 void dlb_pf_enable_pm(struct dlb *dlb);
 int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev);
 
+extern const struct file_operations dlb_domain_fops;
+
+struct dlb_domain {
+	struct dlb *dlb;
+	struct kref refcnt;
+	u8 id;
+};
+
 struct dlb {
 	struct pci_dev *pdev;
 	struct dlb_hw hw;
 	struct device *dev;
+	struct dlb_domain *sched_domains[DLB_MAX_NUM_DOMAINS];
+	struct file *f;
 	/*
 	 * The resource mutex serializes access to driver data structures and
 	 * hardware registers.
@@ -326,6 +337,123 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
 	kfree(bitmap);
 }
 
+/**
+ * dlb_bitmap_clear_range() - clear a range of bitmap entries
+ * @bitmap: pointer to dlb_bitmap structure.
+ * @bit: starting bit index.
+ * @len: length of the range.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise.
+ *
+ * Errors:
+ * EINVAL - bitmap is NULL or is uninitialized, or the range exceeds the bitmap
+ *	    length.
+ */
+static inline int dlb_bitmap_clear_range(struct dlb_bitmap *bitmap,
+					 unsigned int bit,
+					 unsigned int len)
+{
+	if (!bitmap || !bitmap->map)
+		return -EINVAL;
+
+	if (bitmap->len <= bit)
+		return -EINVAL;
+
+	bitmap_clear(bitmap->map, bit, len);
+
+	return 0;
+}
+
+/**
+ * dlb_bitmap_find_set_bit_range() - find an range of set bits
+ * @bitmap: pointer to dlb_bitmap structure.
+ * @len: length of the range.
+ *
+ * This function looks for a range of set bits of length @len.
+ *
+ * Return:
+ * Returns the base bit index upon success, < 0 otherwise.
+ *
+ * Errors:
+ * ENOENT - unable to find a length *len* range of set bits.
+ * EINVAL - bitmap is NULL or is uninitialized, or len is invalid.
+ */
+static inline int dlb_bitmap_find_set_bit_range(struct dlb_bitmap *bitmap,
+						unsigned int len)
+{
+	struct dlb_bitmap *complement_mask = NULL;
+	int ret;
+
+	if (!bitmap || !bitmap->map || len == 0)
+		return -EINVAL;
+
+	if (bitmap->len < len)
+		return -ENOENT;
+
+	ret = dlb_bitmap_alloc(&complement_mask, bitmap->len);
+	if (ret)
+		return ret;
+
+	bitmap_zero(complement_mask->map, complement_mask->len);
+
+	bitmap_complement(complement_mask->map, bitmap->map, bitmap->len);
+
+	ret = bitmap_find_next_zero_area(complement_mask->map,
+					 complement_mask->len,
+					 0,
+					 len,
+					 0);
+
+	dlb_bitmap_free(complement_mask);
+
+	/* No set bit range of length len? */
+	return (ret >= (int)bitmap->len) ? -ENOENT : ret;
+}
+
+/**
+ * dlb_bitmap_longest_set_range() - returns longest contiguous range of set
+ *				     bits
+ * @bitmap: pointer to dlb_bitmap structure.
+ *
+ * Return:
+ * Returns the bitmap's longest contiguous range of set bits upon success,
+ * <0 otherwise.
+ *
+ * Errors:
+ * EINVAL - bitmap is NULL or is uninitialized.
+ */
+static inline int dlb_bitmap_longest_set_range(struct dlb_bitmap *bitmap)
+{
+	int max_len, len;
+	int start, end;
+
+	if (!bitmap || !bitmap->map)
+		return -EINVAL;
+
+	if (bitmap_weight(bitmap->map, bitmap->len) == 0)
+		return 0;
+
+	max_len = 0;
+	bitmap_for_each_set_region(bitmap->map, start, end, 0, bitmap->len) {
+		len = end - start;
+		if (max_len < len)
+			max_len = len;
+	}
+	return max_len;
+}
+
+int dlb_init_domain(struct dlb *dlb, u32 domain_id);
+void dlb_free_domain(struct kref *kref);
+
+static inline struct device *hw_to_dev(struct dlb_hw *hw)
+{
+	struct dlb *dlb;
+
+	dlb = container_of(hw, struct dlb, hw);
+	return dlb->dev;
+}
+
 /* Prototypes for dlb_resource.c */
 int dlb_resource_init(struct dlb_hw *hw);
 void dlb_resource_free(struct dlb_hw *hw);
diff --git a/drivers/misc/dlb/dlb_regs.h b/drivers/misc/dlb/dlb_regs.h
index 72f3cb22b933..0fd499f384de 100644
--- a/drivers/misc/dlb/dlb_regs.h
+++ b/drivers/misc/dlb/dlb_regs.h
@@ -6,6 +6,24 @@
 
 #include <linux/types.h>
 
+#define CHP_CFG_DIR_VAS_CRD(x) \
+	(0x40000000 + (x) * 0x1000)
+#define CHP_CFG_DIR_VAS_CRD_RST 0x0
+
+#define CHP_CFG_DIR_VAS_CRD_COUNT	0x00003FFF
+#define CHP_CFG_DIR_VAS_CRD_RSVD0	0xFFFFC000
+#define CHP_CFG_DIR_VAS_CRD_COUNT_LOC	0
+#define CHP_CFG_DIR_VAS_CRD_RSVD0_LOC	14
+
+#define CHP_CFG_LDB_VAS_CRD(x) \
+	(0x40080000 + (x) * 0x1000)
+#define CHP_CFG_LDB_VAS_CRD_RST 0x0
+
+#define CHP_CFG_LDB_VAS_CRD_COUNT	0x00007FFF
+#define CHP_CFG_LDB_VAS_CRD_RSVD0	0xFFFF8000
+#define CHP_CFG_LDB_VAS_CRD_COUNT_LOC	0
+#define CHP_CFG_LDB_VAS_CRD_RSVD0_LOC	15
+
 #define CM_CFG_DIAGNOSTIC_IDLE_STATUS 0xb4000004
 #define CM_CFG_DIAGNOSTIC_IDLE_STATUS_RST 0x9d0fffff
 
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 7d7ebf3db292..2d74d158219c 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -190,11 +190,537 @@ int dlb_resource_init(struct dlb_hw *hw)
 	return ret;
 }
 
+static int dlb_attach_ldb_queues(struct dlb_hw *hw,
+				 struct dlb_function_resources *rsrcs,
+				 struct dlb_hw_domain *domain, u32 num_queues,
+				 struct dlb_cmd_response *resp)
+{
+	unsigned int i;
+
+	if (rsrcs->num_avail_ldb_queues < num_queues) {
+		resp->status = DLB_ST_LDB_QUEUES_UNAVAILABLE;
+		dev_dbg(hw_to_dev(hw), "[%s()] Internal error: %d\n", __func__,
+			resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_queues; i++) {
+		struct dlb_ldb_queue *queue;
+
+		queue = list_first_entry_or_null(&rsrcs->avail_ldb_queues,
+						 typeof(*queue), func_list);
+		if (!queue) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: domain validation failed\n",
+				__func__);
+			return -EFAULT;
+		}
+
+		list_del(&queue->func_list);
+
+		queue->domain_id = domain->id;
+		queue->owned = true;
+
+		list_add(&queue->domain_list, &domain->avail_ldb_queues);
+	}
+
+	rsrcs->num_avail_ldb_queues -= num_queues;
+
+	return 0;
+}
+
+static struct dlb_ldb_port *
+dlb_get_next_ldb_port(struct dlb_hw *hw, struct dlb_function_resources *rsrcs,
+		      u32 domain_id, u32 cos_id)
+{
+	struct dlb_ldb_port *port;
+
+	/*
+	 * To reduce the odds of consecutive load-balanced ports mapping to the
+	 * same queue(s), the driver attempts to allocate ports whose neighbors
+	 * are owned by a different domain.
+	 */
+	list_for_each_entry(port, &rsrcs->avail_ldb_ports[cos_id], func_list) {
+		u32 next, prev;
+		u32 phys_id;
+
+		phys_id = port->id;
+		next = phys_id + 1;
+		prev = phys_id - 1;
+
+		if (phys_id == DLB_MAX_NUM_LDB_PORTS - 1)
+			next = 0;
+		if (phys_id == 0)
+			prev = DLB_MAX_NUM_LDB_PORTS - 1;
+
+		if (!hw->rsrcs.ldb_ports[next].owned ||
+		    hw->rsrcs.ldb_ports[next].domain_id == domain_id)
+			continue;
+
+		if (!hw->rsrcs.ldb_ports[prev].owned ||
+		    hw->rsrcs.ldb_ports[prev].domain_id == domain_id)
+			continue;
+
+		return port;
+	}
+
+	/*
+	 * Failing that, the driver looks for a port with one neighbor owned by
+	 * a different domain and the other unallocated.
+	 */
+	list_for_each_entry(port, &rsrcs->avail_ldb_ports[cos_id], func_list) {
+		u32 next, prev;
+		u32 phys_id;
+
+		phys_id = port->id;
+		next = phys_id + 1;
+		prev = phys_id - 1;
+
+		if (phys_id == DLB_MAX_NUM_LDB_PORTS - 1)
+			next = 0;
+		if (phys_id == 0)
+			prev = DLB_MAX_NUM_LDB_PORTS - 1;
+
+		if (!hw->rsrcs.ldb_ports[prev].owned &&
+		    hw->rsrcs.ldb_ports[next].owned &&
+		    hw->rsrcs.ldb_ports[next].domain_id != domain_id)
+			return port;
+
+		if (!hw->rsrcs.ldb_ports[next].owned &&
+		    hw->rsrcs.ldb_ports[prev].owned &&
+		    hw->rsrcs.ldb_ports[prev].domain_id != domain_id)
+			return port;
+	}
+
+	/*
+	 * Failing that, the driver looks for a port with both neighbors
+	 * unallocated.
+	 */
+	list_for_each_entry(port, &rsrcs->avail_ldb_ports[cos_id], func_list) {
+		u32 next, prev;
+		u32 phys_id;
+
+		phys_id = port->id;
+		next = phys_id + 1;
+		prev = phys_id - 1;
+
+		if (phys_id == DLB_MAX_NUM_LDB_PORTS - 1)
+			next = 0;
+		if (phys_id == 0)
+			prev = DLB_MAX_NUM_LDB_PORTS - 1;
+
+		if (!hw->rsrcs.ldb_ports[prev].owned &&
+		    !hw->rsrcs.ldb_ports[next].owned)
+			return port;
+	}
+
+	/* If all else fails, the driver returns the next available port. */
+	return list_first_entry_or_null(&rsrcs->avail_ldb_ports[cos_id],
+					typeof(*port), func_list);
+}
+
+static int __dlb_attach_ldb_ports(struct dlb_hw *hw,
+				  struct dlb_function_resources *rsrcs,
+				  struct dlb_hw_domain *domain, u32 num_ports,
+				  u32 cos_id, struct dlb_cmd_response *resp)
+{
+	unsigned int i;
+
+	if (rsrcs->num_avail_ldb_ports[cos_id] < num_ports) {
+		resp->status = DLB_ST_LDB_PORTS_UNAVAILABLE;
+		dev_dbg(hw_to_dev(hw),
+			"[%s()] Internal error: %d\n",
+			__func__, resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		struct dlb_ldb_port *port;
+
+		port = dlb_get_next_ldb_port(hw, rsrcs,
+					     domain->id, cos_id);
+		if (!port) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: domain validation failed\n",
+				__func__);
+			return -EFAULT;
+		}
+
+		list_del(&port->func_list);
+
+		port->domain_id = domain->id;
+		port->owned = true;
+
+		list_add(&port->domain_list,
+			 &domain->avail_ldb_ports[cos_id]);
+	}
+
+	rsrcs->num_avail_ldb_ports[cos_id] -= num_ports;
+
+	return 0;
+}
+
+static int dlb_attach_ldb_ports(struct dlb_hw *hw,
+				struct dlb_function_resources *rsrcs,
+				struct dlb_hw_domain *domain,
+				struct dlb_create_sched_domain_args *args,
+				struct dlb_cmd_response *resp)
+{
+	unsigned int i, j;
+	int ret;
+
+	/* Allocate num_ldb_ports from any class-of-service */
+	for (i = 0; i < args->num_ldb_ports; i++) {
+		for (j = 0; j < DLB_NUM_COS_DOMAINS; j++) {
+			ret = __dlb_attach_ldb_ports(hw, rsrcs, domain, 1, j, resp);
+			if (ret == 0)
+				break;
+		}
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int dlb_attach_dir_ports(struct dlb_hw *hw,
+				struct dlb_function_resources *rsrcs,
+				struct dlb_hw_domain *domain, u32 num_ports,
+				struct dlb_cmd_response *resp)
+{
+	unsigned int i;
+
+	if (rsrcs->num_avail_dir_pq_pairs < num_ports) {
+		resp->status = DLB_ST_DIR_PORTS_UNAVAILABLE;
+		dev_dbg(hw_to_dev(hw),
+			"[%s()] Internal error: %d\n",
+			__func__, resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		struct dlb_dir_pq_pair *port;
+
+		port = list_first_entry_or_null(&rsrcs->avail_dir_pq_pairs,
+						typeof(*port), func_list);
+		if (!port) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: domain validation failed\n",
+				__func__);
+			return -EFAULT;
+		}
+
+		list_del(&port->func_list);
+
+		port->domain_id = domain->id;
+		port->owned = true;
+
+		list_add(&port->domain_list, &domain->avail_dir_pq_pairs);
+	}
+
+	rsrcs->num_avail_dir_pq_pairs -= num_ports;
+
+	return 0;
+}
+
+static int dlb_attach_ldb_credits(struct dlb_function_resources *rsrcs,
+				  struct dlb_hw_domain *domain, u32 num_credits,
+				  struct dlb_cmd_response *resp)
+{
+	if (rsrcs->num_avail_qed_entries < num_credits) {
+		resp->status = DLB_ST_LDB_CREDITS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	rsrcs->num_avail_qed_entries -= num_credits;
+	domain->num_ldb_credits += num_credits;
+	return 0;
+}
+
+static int dlb_attach_dir_credits(struct dlb_function_resources *rsrcs,
+				  struct dlb_hw_domain *domain, u32 num_credits,
+				  struct dlb_cmd_response *resp)
+{
+	if (rsrcs->num_avail_dqed_entries < num_credits) {
+		resp->status = DLB_ST_DIR_CREDITS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	rsrcs->num_avail_dqed_entries -= num_credits;
+	domain->num_dir_credits += num_credits;
+	return 0;
+}
+
+static int dlb_attach_atomic_inflights(struct dlb_function_resources *rsrcs,
+				       struct dlb_hw_domain *domain,
+				       u32 num_atomic_inflights,
+				       struct dlb_cmd_response *resp)
+{
+	if (rsrcs->num_avail_aqed_entries < num_atomic_inflights) {
+		resp->status = DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	rsrcs->num_avail_aqed_entries -= num_atomic_inflights;
+	domain->num_avail_aqed_entries += num_atomic_inflights;
+	return 0;
+}
+
+static int
+dlb_attach_domain_hist_list_entries(struct dlb_function_resources *rsrcs,
+				    struct dlb_hw_domain *domain,
+				    u32 num_hist_list_entries,
+				    struct dlb_cmd_response *resp)
+{
+	struct dlb_bitmap *bitmap;
+	int base;
+
+	if (num_hist_list_entries) {
+		bitmap = rsrcs->avail_hist_list_entries;
+
+		base = dlb_bitmap_find_set_bit_range(bitmap,
+						     num_hist_list_entries);
+		if (base < 0)
+			goto error;
+
+		domain->total_hist_list_entries = num_hist_list_entries;
+		domain->avail_hist_list_entries = num_hist_list_entries;
+		domain->hist_list_entry_base = base;
+		domain->hist_list_entry_offset = 0;
+
+		dlb_bitmap_clear_range(bitmap, base, num_hist_list_entries);
+	}
+	return 0;
+
+error:
+	resp->status = DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE;
+	return -EINVAL;
+}
+
+static int
+dlb_verify_create_sched_dom_args(struct dlb_function_resources *rsrcs,
+				 struct dlb_create_sched_domain_args *args,
+				 struct dlb_cmd_response *resp,
+				 struct dlb_hw_domain **out_domain)
+{
+	u32 num_avail_ldb_ports, req_ldb_ports;
+	struct dlb_bitmap *avail_hl_entries;
+	unsigned int max_contig_hl_range;
+	struct dlb_hw_domain *domain;
+	int i;
+
+	avail_hl_entries = rsrcs->avail_hist_list_entries;
+
+	max_contig_hl_range = dlb_bitmap_longest_set_range(avail_hl_entries);
+
+	num_avail_ldb_ports = 0;
+	req_ldb_ports = 0;
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		num_avail_ldb_ports += rsrcs->num_avail_ldb_ports[i];
+
+	req_ldb_ports += args->num_ldb_ports;
+
+	if (rsrcs->num_avail_domains < 1) {
+		resp->status = DLB_ST_DOMAIN_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	domain = list_first_entry_or_null(&rsrcs->avail_domains,
+					  typeof(*domain), func_list);
+	if (!domain) {
+		resp->status = DLB_ST_DOMAIN_UNAVAILABLE;
+		return -EFAULT;
+	}
+
+	if (rsrcs->num_avail_ldb_queues < args->num_ldb_queues) {
+		resp->status = DLB_ST_LDB_QUEUES_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (req_ldb_ports > num_avail_ldb_ports) {
+		resp->status = DLB_ST_LDB_PORTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (args->num_ldb_queues > 0 && req_ldb_ports == 0) {
+		resp->status = DLB_ST_LDB_PORT_REQUIRED_FOR_LDB_QUEUES;
+		return -EINVAL;
+	}
+
+	if (rsrcs->num_avail_dir_pq_pairs < args->num_dir_ports) {
+		resp->status = DLB_ST_DIR_PORTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (rsrcs->num_avail_qed_entries < args->num_ldb_credits) {
+		resp->status = DLB_ST_LDB_CREDITS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (rsrcs->num_avail_dqed_entries < args->num_dir_credits) {
+		resp->status = DLB_ST_DIR_CREDITS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (rsrcs->num_avail_aqed_entries < args->num_atomic_inflights) {
+		resp->status = DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (max_contig_hl_range < args->num_hist_list_entries) {
+		resp->status = DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+
+	return 0;
+}
+
+static void dlb_configure_domain_credits(struct dlb_hw *hw,
+					 struct dlb_hw_domain *domain)
+{
+	u32 reg;
+
+	reg = FIELD_PREP(CHP_CFG_LDB_VAS_CRD_COUNT, domain->num_ldb_credits);
+	DLB_CSR_WR(hw, CHP_CFG_LDB_VAS_CRD(domain->id), reg);
+
+	reg = FIELD_PREP(CHP_CFG_DIR_VAS_CRD_COUNT, domain->num_dir_credits);
+	DLB_CSR_WR(hw, CHP_CFG_DIR_VAS_CRD(domain->id), reg);
+}
+
+static int
+dlb_domain_attach_resources(struct dlb_hw *hw,
+			    struct dlb_function_resources *rsrcs,
+			    struct dlb_hw_domain *domain,
+			    struct dlb_create_sched_domain_args *args,
+			    struct dlb_cmd_response *resp)
+{
+	int ret;
+
+	ret = dlb_attach_ldb_queues(hw, rsrcs, domain, args->num_ldb_queues, resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_ldb_ports(hw, rsrcs, domain, args, resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_dir_ports(hw, rsrcs, domain, args->num_dir_ports, resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_ldb_credits(rsrcs, domain,
+				     args->num_ldb_credits, resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_dir_credits(rsrcs, domain, args->num_dir_credits, resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_domain_hist_list_entries(rsrcs, domain,
+						  args->num_hist_list_entries,
+						  resp);
+	if (ret)
+		return ret;
+
+	ret = dlb_attach_atomic_inflights(rsrcs, domain,
+					  args->num_atomic_inflights, resp);
+	if (ret)
+		return ret;
+
+	dlb_configure_domain_credits(hw, domain);
+
+	domain->configured = true;
+
+	domain->started = false;
+
+	rsrcs->num_avail_domains--;
+
+	return 0;
+}
+
+static void
+dlb_log_create_sched_domain_args(struct dlb_hw *hw,
+				 struct dlb_create_sched_domain_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB create sched domain arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tNumber of LDB queues:          %d\n",
+		args->num_ldb_queues);
+	dev_dbg(hw_to_dev(hw), "\tNumber of LDB ports (any CoS): %d\n",
+		args->num_ldb_ports);
+	dev_dbg(hw_to_dev(hw), "\tNumber of DIR ports:           %d\n",
+		args->num_dir_ports);
+	dev_dbg(hw_to_dev(hw), "\tNumber of ATM inflights:       %d\n",
+		args->num_atomic_inflights);
+	dev_dbg(hw_to_dev(hw), "\tNumber of hist list entries:   %d\n",
+		args->num_hist_list_entries);
+	dev_dbg(hw_to_dev(hw), "\tNumber of LDB credits:         %d\n",
+		args->num_ldb_credits);
+	dev_dbg(hw_to_dev(hw), "\tNumber of DIR credits:         %d\n",
+		args->num_dir_credits);
+}
+
+/**
+ * dlb_hw_create_sched_domain() - create a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @args: scheduling domain creation arguments.
+ * @resp: response structure.
+ *
+ * This function creates a scheduling domain containing the resources specified
+ * in args. The individual resources (queues, ports, credits) can be configured
+ * after creating a scheduling domain.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the domain ID.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, or the requested domain name
+ *	    is already in use.
+ * EFAULT - Internal error (resp->status not set).
+ */
 int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 			       struct dlb_create_sched_domain_args *args,
 			       struct dlb_cmd_response *resp)
 {
-	resp->id = 0;
+	struct dlb_function_resources *rsrcs;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	rsrcs = &hw->pf;
+
+	dlb_log_create_sched_domain_args(hw, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_create_sched_dom_args(rsrcs, args, resp, &domain);
+	if (ret)
+		return ret;
+
+	dlb_init_domain_rsrc_lists(domain);
+
+	ret = dlb_domain_attach_resources(hw, rsrcs, domain, args, resp);
+	if (ret) {
+		dev_err(hw_to_dev(hw),
+			"[%s()] Internal error: failed to verify args.\n",
+			__func__);
+
+		return ret;
+	}
+
+	/*
+	 * Configuration succeeded, so move the resource from the 'avail' to
+	 * the 'used' list (if it's not already there).
+	 */
+	list_move(&domain->func_list, &rsrcs->used_domains);
+
+	resp->id = domain->id;
 	resp->status = 0;
 
 	return 0;
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
new file mode 100644
index 000000000000..91551d8a0175
--- /dev/null
+++ b/include/uapi/linux/dlb.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_H
+#define __DLB_H
+
+#include <linux/types.h>
+
+enum dlb_error {
+	DLB_ST_SUCCESS = 0,
+	DLB_ST_DOMAIN_UNAVAILABLE,
+	DLB_ST_LDB_PORTS_UNAVAILABLE,
+	DLB_ST_DIR_PORTS_UNAVAILABLE,
+	DLB_ST_LDB_QUEUES_UNAVAILABLE,
+	DLB_ST_LDB_CREDITS_UNAVAILABLE,
+	DLB_ST_DIR_CREDITS_UNAVAILABLE,
+	DLB_ST_SEQUENCE_NUMBERS_UNAVAILABLE,
+	DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE,
+	DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE,
+	DLB_ST_LDB_PORT_REQUIRED_FOR_LDB_QUEUES,
+};
+#endif /* __DLB_H */
-- 
2.27.0

