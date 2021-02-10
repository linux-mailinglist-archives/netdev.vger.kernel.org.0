Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135DC316D75
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhBJR5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:57:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:60432 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhBJR5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:57:03 -0500
IronPort-SDR: 6uAOWHW9VvQ19BQuCmWTU3EyIRuZhTyfIdMN/xeoyQmHsd6bEg08hs6onPgsVRXHYwn/J2Xm6i
 LNGmK/KftwYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236017"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236017"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:07 -0800
IronPort-SDR: dSjztFf+LRgXZ4Eb0QeJkaQ7+/wcBv2w5XvP7/xhJriHr/jtZR2aBqyBXNjBgek/mC35rprSak
 2JTJu/8OQs/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235729"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:06 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 05/20] dlb: add scheduling domain configuration
Date:   Wed, 10 Feb 2021 11:54:08 -0600
Message-Id: <20210210175423.1873-6-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring a scheduling domain, creating the domain fd,
and reserving the domain's resources.

A scheduling domain serves as a container of DLB resources -- e.g. ports,
queues, and credits -- with the property that a port can only enqueue
to and dequeue from queues within its domain. A scheduling domain is
created on-demand by a user-space application, whose request includes
the DLB resource allocation.

When a user requests to create a scheduling domain, the requested resources
are validated against the number currently available, and then reserved for
the scheduling domain. Finally, the ioctl handler allocates an anonymous
file descriptor for the domain and installs this in the calling process's
file descriptor table.

Once created, user-space can use this file descriptor to configure the
scheduling domain's resources (to be added in a subsequent commit). For
multiprocess applications, this descriptor can be shared over a unix
domain socket.

The driver maintains a reference count for each scheduling domain,
incrementing it each time user-space requests a file descriptor and
decrementing it in the file's release callback.

When the reference count transitions from 1->0 the driver automatically
resets the scheduling domain's resources and makes them available for use
by future applications. This ensures that applications that crash without
explicitly cleaning up do not orphan device resources. The code to perform
the domain reset will be added in subsequent commits.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_bitmap.h   |  74 ++++
 drivers/misc/dlb/dlb_ioctl.c    |  36 +-
 drivers/misc/dlb/dlb_main.c     |  68 ++++
 drivers/misc/dlb/dlb_main.h     |  24 ++
 drivers/misc/dlb/dlb_pf_ops.c   |   5 +-
 drivers/misc/dlb/dlb_regs.h     |  18 +
 drivers/misc/dlb/dlb_resource.c | 605 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.h |   7 +
 include/uapi/linux/dlb.h        |  14 +
 9 files changed, 845 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/dlb/dlb_bitmap.h b/drivers/misc/dlb/dlb_bitmap.h
index 3ea78b42c79f..5cebf833fab4 100644
--- a/drivers/misc/dlb/dlb_bitmap.h
+++ b/drivers/misc/dlb/dlb_bitmap.h
@@ -73,6 +73,80 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
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
 /**
  * dlb_bitmap_longest_set_range() - returns longest contiguous range of set
  *				     bits
diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
index 47d6cab773d4..7871d0cea118 100644
--- a/drivers/misc/dlb/dlb_ioctl.c
+++ b/drivers/misc/dlb/dlb_ioctl.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
+#include <linux/anon_inodes.h>
 #include <linux/uaccess.h>
 
 #include <uapi/linux/dlb.h>
@@ -45,7 +46,10 @@ static int dlb_ioctl_create_sched_domain(struct dlb *dlb, unsigned long user_arg
 	struct dlb_create_sched_domain_args __user *uarg;
 	struct dlb_create_sched_domain_args arg;
 	struct dlb_cmd_response response = {0};
-	int ret;
+	struct dlb_domain *domain;
+	u32 flags = O_RDONLY;
+	size_t offset;
+	int ret, fd;
 
 	uarg = (void __user *)user_arg;
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
@@ -54,10 +58,38 @@ static int dlb_ioctl_create_sched_domain(struct dlb *dlb, unsigned long user_arg
 	mutex_lock(&dlb->resource_mutex);
 
 	ret = dlb->ops->create_sched_domain(&dlb->hw, &arg, &response);
+	if (ret)
+		goto unlock;
+
+	ret = dlb_init_domain(dlb, response.id);
+	if (ret)
+		goto unlock;
+
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
+	offset = offsetof(struct dlb_create_sched_domain_args, domain_fd);
+
+	if (copy_to_user((void __user *)(user_arg + offset), &fd, sizeof(fd))) {
+		mutex_unlock(&dlb->resource_mutex);
+		return -EFAULT;
+	}
 
+unlock:
 	mutex_unlock(&dlb->resource_mutex);
 
-	response.status = ret;
 	BUILD_BUG_ON(offsetof(typeof(arg), response) != 0);
 
 	if (copy_to_user((void __user *)&uarg->response, &response, sizeof(response)))
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index d92956b1643d..a4ed413eee2f 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -62,11 +62,79 @@ static int dlb_device_create(struct dlb *dlb, struct pci_dev *pdev)
 /****** Char dev callbacks ******/
 /********************************/
 
+static int dlb_open(struct inode *i, struct file *f)
+{
+	struct dlb *dlb;
+
+	spin_lock(&dlb_ids_lock);
+	dlb = idr_find(&dlb_ids, iminor(i));
+	spin_unlock(&dlb_ids_lock);
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
 	.unlocked_ioctl = dlb_ioctl,
 };
 
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
+};
+
 /**********************************/
 /****** PCI driver callbacks ******/
 /**********************************/
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 3089a66a3560..824416e6cdcf 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -47,12 +47,21 @@ struct dlb_device_ops {
 };
 
 extern struct dlb_device_ops dlb_pf_ops;
+extern const struct file_operations dlb_domain_fops;
+
+struct dlb_domain {
+	struct dlb *dlb;
+	struct kref refcnt;
+	u8 id;
+};
 
 struct dlb {
 	struct pci_dev *pdev;
 	struct dlb_hw hw;
 	struct dlb_device_ops *ops;
 	struct device *dev;
+	struct dlb_domain *sched_domains[DLB_MAX_NUM_DOMAINS];
+	struct file *f;
 	/*
 	 * The resource mutex serializes access to driver data structures and
 	 * hardware registers.
@@ -66,4 +75,19 @@ struct dlb {
 /* Prototypes for dlb_ioctl.c */
 long dlb_ioctl(struct file *f, unsigned int cmd, unsigned long arg);
 
+int dlb_init_domain(struct dlb *dlb, u32 domain_id);
+void dlb_free_domain(struct kref *kref);
+
+#define DLB_HW_ERR(hw, ...) do {		  \
+	struct dlb *dlb;			  \
+	dlb = container_of(hw, struct dlb, hw); \
+	dev_err(dlb->dev, __VA_ARGS__);	  \
+} while (0)
+
+#define DLB_HW_DBG(hw, ...) do {		  \
+	struct dlb *dlb;			  \
+	dlb = container_of(hw, struct dlb, hw); \
+	dev_dbg(dlb->dev, __VA_ARGS__);	  \
+} while (0)
+
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 125ef6fe6c70..b59e9eaa600d 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -103,10 +103,7 @@ static int dlb_pf_create_sched_domain(struct dlb_hw *hw,
 				      struct dlb_create_sched_domain_args *args,
 				      struct dlb_cmd_response *resp)
 {
-	resp->id = 0;
-	resp->status = 0;
-
-	return 0;
+	return dlb_hw_create_sched_domain(hw, args, resp, false, 0);
 }
 
 static int dlb_pf_get_num_resources(struct dlb_hw *hw,
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
index 9d75b12eb793..b7df23c6a158 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -3,6 +3,7 @@
 
 #include "dlb_bitmap.h"
 #include "dlb_hw_types.h"
+#include "dlb_main.h"
 #include "dlb_regs.h"
 #include "dlb_resource.h"
 
@@ -200,6 +201,610 @@ int dlb_resource_init(struct dlb_hw *hw)
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
+		DLB_HW_DBG(hw, "[%s()] Internal error: %d\n", __func__,
+			   resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_queues; i++) {
+		struct dlb_ldb_queue *queue;
+
+		queue = list_first_entry_or_null(&rsrcs->avail_ldb_queues,
+						 typeof(*queue), func_list);
+		if (!queue) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: domain validation failed\n",
+				   __func__);
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
+		phys_id = port->id.phys_id;
+		next = phys_id + 1;
+		prev = phys_id - 1;
+
+		if (phys_id == DLB_MAX_NUM_LDB_PORTS - 1)
+			next = 0;
+		if (phys_id == 0)
+			prev = DLB_MAX_NUM_LDB_PORTS - 1;
+
+		if (!hw->rsrcs.ldb_ports[next].owned ||
+		    hw->rsrcs.ldb_ports[next].domain_id.phys_id == domain_id)
+			continue;
+
+		if (!hw->rsrcs.ldb_ports[prev].owned ||
+		    hw->rsrcs.ldb_ports[prev].domain_id.phys_id == domain_id)
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
+		phys_id = port->id.phys_id;
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
+		    hw->rsrcs.ldb_ports[next].domain_id.phys_id != domain_id)
+			return port;
+
+		if (!hw->rsrcs.ldb_ports[next].owned &&
+		    hw->rsrcs.ldb_ports[prev].owned &&
+		    hw->rsrcs.ldb_ports[prev].domain_id.phys_id != domain_id)
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
+		phys_id = port->id.phys_id;
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
+		DLB_HW_DBG(hw,
+			   "[%s()] Internal error: %d\n",
+			   __func__,
+			   resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		struct dlb_ldb_port *port;
+
+		port = dlb_get_next_ldb_port(hw, rsrcs,
+					     domain->id.phys_id, cos_id);
+		if (!port) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: domain validation failed\n",
+				   __func__);
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
+	if (args->cos_strict) {
+		for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+			u32 num = args->num_cos_ldb_ports[i];
+
+			/* Allocate ports from specific classes-of-service */
+			ret = __dlb_attach_ldb_ports(hw, rsrcs, domain, num,
+						     i, resp);
+			if (ret)
+				return ret;
+		}
+	} else {
+		unsigned int k;
+		u32 cos_id;
+
+		/*
+		 * Attempt to allocate from specific class-of-service, but
+		 * fallback to the other classes if that fails.
+		 */
+		for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+			for (j = 0; j < args->num_cos_ldb_ports[i]; j++) {
+				for (k = 0; k < DLB_NUM_COS_DOMAINS; k++) {
+					cos_id = (i + k) % DLB_NUM_COS_DOMAINS;
+
+					ret = __dlb_attach_ldb_ports(hw, rsrcs, domain,
+								     1, cos_id, resp);
+					if (ret == 0)
+						break;
+				}
+
+				if (ret)
+					return ret;
+			}
+		}
+	}
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
+		DLB_HW_DBG(hw,
+			   "[%s()] Internal error: %d\n",
+			   __func__,
+			   resp->status);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		struct dlb_dir_pq_pair *port;
+
+		port = list_first_entry_or_null(&rsrcs->avail_dir_pq_pairs,
+						typeof(*port), func_list);
+		if (!port) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: domain validation failed\n",
+				   __func__);
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
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		num_avail_ldb_ports += rsrcs->num_avail_ldb_ports[i];
+
+		req_ldb_ports += args->num_cos_ldb_ports[i];
+	}
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
+	for (i = 0; args->cos_strict && i < DLB_NUM_COS_DOMAINS; i++) {
+		if (args->num_cos_ldb_ports[i] >
+		    rsrcs->num_avail_ldb_ports[i]) {
+			resp->status = DLB_ST_LDB_PORTS_UNAVAILABLE;
+			return -EINVAL;
+		}
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
+	u32 reg = 0;
+
+	BITS_SET(reg, domain->num_ldb_credits, CHP_CFG_LDB_VAS_CRD_COUNT);
+	DLB_CSR_WR(hw, CHP_CFG_LDB_VAS_CRD(domain->id.phys_id), reg);
+
+	reg = 0;
+	BITS_SET(reg, domain->num_dir_credits, CHP_CFG_DIR_VAS_CRD_COUNT);
+	DLB_CSR_WR(hw, CHP_CFG_DIR_VAS_CRD(domain->id.phys_id), reg);
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
+				 struct dlb_create_sched_domain_args *args,
+				 bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB create sched domain arguments:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from vdev %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tNumber of LDB queues:          %d\n",
+		   args->num_ldb_queues);
+	DLB_HW_DBG(hw, "\tNumber of LDB ports (any CoS): %d\n",
+		   args->num_ldb_ports);
+	DLB_HW_DBG(hw, "\tNumber of LDB ports (CoS 0):   %d\n",
+		   args->num_cos_ldb_ports[0]);
+	DLB_HW_DBG(hw, "\tNumber of LDB ports (CoS 1):   %d\n",
+		   args->num_cos_ldb_ports[1]);
+	DLB_HW_DBG(hw, "\tNumber of LDB ports (CoS 2):   %d\n",
+		   args->num_cos_ldb_ports[2]);
+	DLB_HW_DBG(hw, "\tNumber of LDB ports (CoS 3):   %d\n",
+		   args->num_cos_ldb_ports[3]);
+	DLB_HW_DBG(hw, "\tStrict CoS allocation:         %d\n",
+		   args->cos_strict);
+	DLB_HW_DBG(hw, "\tNumber of DIR ports:           %d\n",
+		   args->num_dir_ports);
+	DLB_HW_DBG(hw, "\tNumber of ATM inflights:       %d\n",
+		   args->num_atomic_inflights);
+	DLB_HW_DBG(hw, "\tNumber of hist list entries:   %d\n",
+		   args->num_hist_list_entries);
+	DLB_HW_DBG(hw, "\tNumber of LDB credits:         %d\n",
+		   args->num_ldb_credits);
+	DLB_HW_DBG(hw, "\tNumber of DIR credits:         %d\n",
+		   args->num_dir_credits);
+}
+
+/**
+ * dlb_hw_create_sched_domain() - create a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @args: scheduling domain creation arguments.
+ * @resp: response structure.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function creates a scheduling domain containing the resources specified
+ * in args. The individual resources (queues, ports, credits) can be configured
+ * after creating a scheduling domain.
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the domain ID.
+ *
+ * resp->id contains a virtual ID if vdev_req is true.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, or the requested domain name
+ *	    is already in use.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_create_sched_domain(struct dlb_hw *hw,
+			       struct dlb_create_sched_domain_args *args,
+			       struct dlb_cmd_response *resp,
+			       bool vdev_req, unsigned int vdev_id)
+{
+	struct dlb_function_resources *rsrcs;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	rsrcs = (vdev_req) ? &hw->vdev[vdev_id] : &hw->pf;
+
+	dlb_log_create_sched_domain_args(hw, args, vdev_req, vdev_id);
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
+		DLB_HW_ERR(hw,
+			   "[%s()] Internal error: failed to verify args.\n",
+			   __func__);
+
+		return ret;
+	}
+
+	list_del(&domain->func_list);
+
+	list_add(&domain->func_list, &rsrcs->used_domains);
+
+	resp->id = (vdev_req) ? domain->id.virt_id : domain->id.phys_id;
+	resp->status = 0;
+
+	return 0;
+}
+
 /**
  * dlb_hw_get_num_resources() - query the PCI function's available resources
  * @hw: dlb_hw handle for a particular device.
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
index 3e6d419796bc..efc5140970cd 100644
--- a/drivers/misc/dlb/dlb_resource.h
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -6,12 +6,19 @@
 
 #include <linux/types.h>
 
+#include <uapi/linux/dlb.h>
+
 #include "dlb_hw_types.h"
 
 int dlb_resource_init(struct dlb_hw *hw);
 
 void dlb_resource_free(struct dlb_hw *hw);
 
+int dlb_hw_create_sched_domain(struct dlb_hw *hw,
+			       struct dlb_create_sched_domain_args *args,
+			       struct dlb_cmd_response *resp,
+			       bool vdev_req, unsigned int vdev_id);
+
 int dlb_hw_get_num_resources(struct dlb_hw *hw,
 			     struct dlb_get_num_resources_args *arg,
 			     bool vdev_req, unsigned int vdev_id);
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 87ba1bfa75ed..0b152d29f9e4 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -6,6 +6,20 @@
 
 #include <linux/types.h>
 
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
+
 struct dlb_cmd_response {
 	__u32 status; /* Interpret using enum dlb_error */
 	__u32 id;
-- 
2.17.1

