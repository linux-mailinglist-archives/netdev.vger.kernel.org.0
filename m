Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED2316D6F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhBJR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:57:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:60442 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhBJR4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:56:55 -0500
IronPort-SDR: tQL10W59T+e6BvFap6RdI1/btlAzo/D6B4v569/5A4IrDPbpTwSlb0qB3vGavF3lOtMfgCHtdm
 0OtbJeXaPM6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236015"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236015"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:06 -0800
IronPort-SDR: +1GA0qKxBkldCO6AIIkXR2iNu6x6SqlHnQ/q7wPjxw7NyvX96h4AAUCo85xG8BiqtRYLX2GeLp
 UgJEZrboblRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235720"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:06 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 04/20] dlb: add device ioctl layer and first three ioctls
Date:   Wed, 10 Feb 2021 11:54:07 -0600
Message-Id: <20210210175423.1873-5-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the dlb device ioctl layer and the first three ioctls: query
device version, query available resources, and create a scheduling domain.
Also introduce the user-space interface file dlb_user.h.

The device version query is designed to allow each DLB device version/type
to have its own unique ioctl API through the /dev/dlb%d node. Each such API
would share in common the device version command as its first command, and
all subsequent commands can be unique to the particular device.

The hardware operation for scheduling domain creation will be added in a
subsequent commit.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 drivers/misc/dlb/Makefile                     |   2 +-
 drivers/misc/dlb/dlb_bitmap.h                 |  32 ++++
 drivers/misc/dlb/dlb_ioctl.c                  | 103 +++++++++++
 drivers/misc/dlb/dlb_main.c                   |   1 +
 drivers/misc/dlb/dlb_main.h                   |  10 ++
 drivers/misc/dlb/dlb_pf_ops.c                 |  22 +++
 drivers/misc/dlb/dlb_resource.c               |  62 +++++++
 drivers/misc/dlb/dlb_resource.h               |   4 +
 include/uapi/linux/dlb.h                      | 167 ++++++++++++++++++
 10 files changed, 403 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/dlb/dlb_ioctl.c
 create mode 100644 include/uapi/linux/dlb.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index a4c75a28c839..747b48b141c8 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
 'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
 '|'   00-7F  linux/media.h
 0x80  00-1F  linux/fb.h
+0x81  00-1F  uapi/linux/dlb.h
 0x89  00-06  arch/x86/include/asm/sockios.h
 0x89  0B-DF  linux/sockios.h
 0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index 8a49ea5fd752..aaafb3086d8d 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -7,4 +7,4 @@
 obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
-dlb-objs += dlb_pf_ops.o dlb_resource.o
+dlb-objs += dlb_pf_ops.o dlb_resource.o dlb_ioctl.o
diff --git a/drivers/misc/dlb/dlb_bitmap.h b/drivers/misc/dlb/dlb_bitmap.h
index fb3ef52a306d..3ea78b42c79f 100644
--- a/drivers/misc/dlb/dlb_bitmap.h
+++ b/drivers/misc/dlb/dlb_bitmap.h
@@ -73,4 +73,36 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
 	kfree(bitmap);
 }
 
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
 #endif /*  __DLB_OSDEP_BITMAP_H */
diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
new file mode 100644
index 000000000000..47d6cab773d4
--- /dev/null
+++ b/drivers/misc/dlb/dlb_ioctl.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/uaccess.h>
+
+#include <uapi/linux/dlb.h>
+
+#include "dlb_main.h"
+
+/* [7:0]: device revision, [15:8]: device version */
+#define DLB_SET_DEVICE_VERSION(ver, rev) (((ver) << 8) | (rev))
+
+static int dlb_ioctl_get_device_version(unsigned long user_arg)
+{
+	struct dlb_get_device_version_args arg;
+	u8 revision;
+
+	switch (boot_cpu_data.x86_stepping) {
+	case 0:
+		revision = DLB_REV_A0;
+		break;
+	case 1:
+		revision = DLB_REV_A1;
+		break;
+	case 2:
+		revision = DLB_REV_A2;
+		break;
+	default:
+		/* Treat all revisions >= 3 as B0 */
+		revision = DLB_REV_B0;
+		break;
+	}
+
+	arg.response.status = 0;
+	arg.response.id = DLB_SET_DEVICE_VERSION(2, revision);
+
+	if (copy_to_user((void __user *)user_arg, &arg, sizeof(arg)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int dlb_ioctl_create_sched_domain(struct dlb *dlb, unsigned long user_arg)
+{
+	struct dlb_create_sched_domain_args __user *uarg;
+	struct dlb_create_sched_domain_args arg;
+	struct dlb_cmd_response response = {0};
+	int ret;
+
+	uarg = (void __user *)user_arg;
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	ret = dlb->ops->create_sched_domain(&dlb->hw, &arg, &response);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	response.status = ret;
+	BUILD_BUG_ON(offsetof(typeof(arg), response) != 0);
+
+	if (copy_to_user((void __user *)&uarg->response, &response, sizeof(response)))
+		return -EFAULT;
+
+	return ret;
+}
+
+static int dlb_ioctl_get_num_resources(struct dlb *dlb, unsigned long user_arg)
+{
+	struct dlb_get_num_resources_args arg = {0};
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	ret = dlb->ops->get_num_resources(&dlb->hw, &arg);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	BUILD_BUG_ON(offsetof(typeof(arg), response) != 0);
+	arg.response.status = ret;
+
+	if (copy_to_user((void __user *)user_arg, &arg, sizeof(arg)))
+		return -EFAULT;
+
+	return ret;
+}
+
+long dlb_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	struct dlb *dlb = f->private_data;
+
+	switch (cmd) {
+	case DLB_IOC_GET_DEVICE_VERSION:
+		return dlb_ioctl_get_device_version(arg);
+	case DLB_IOC_CREATE_SCHED_DOMAIN:
+		return dlb_ioctl_create_sched_domain(dlb, arg);
+	case DLB_IOC_GET_NUM_RESOURCES:
+		return dlb_ioctl_get_num_resources(dlb, arg);
+	default:
+		return -ENOTTY;
+	}
+}
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 12707b23ab3e..d92956b1643d 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -64,6 +64,7 @@ static int dlb_device_create(struct dlb *dlb, struct pci_dev *pdev)
 
 static const struct file_operations dlb_fops = {
 	.owner   = THIS_MODULE,
+	.unlocked_ioctl = dlb_ioctl,
 };
 
 /**********************************/
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index ec5eb7bd8f54..3089a66a3560 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -12,6 +12,8 @@
 #include <linux/pci.h>
 #include <linux/types.h>
 
+#include <uapi/linux/dlb.h>
+
 #include "dlb_hw_types.h"
 
 /*
@@ -37,6 +39,11 @@ struct dlb_device_ops {
 	int (*init_driver_state)(struct dlb *dlb);
 	void (*enable_pm)(struct dlb *dlb);
 	int (*wait_for_device_ready)(struct dlb *dlb, struct pci_dev *pdev);
+	int (*create_sched_domain)(struct dlb_hw *hw,
+				   struct dlb_create_sched_domain_args *args,
+				   struct dlb_cmd_response *resp);
+	int (*get_num_resources)(struct dlb_hw *hw,
+				 struct dlb_get_num_resources_args *args);
 };
 
 extern struct dlb_device_ops dlb_pf_ops;
@@ -56,4 +63,7 @@ struct dlb {
 	dev_t dev_number;
 };
 
+/* Prototypes for dlb_ioctl.c */
+long dlb_ioctl(struct file *f, unsigned int cmd, unsigned long arg);
+
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 124b4fee8564..125ef6fe6c70 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -95,6 +95,26 @@ static int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev)
 	return 0;
 }
 
+/*****************************/
+/****** IOCTL callbacks ******/
+/*****************************/
+
+static int dlb_pf_create_sched_domain(struct dlb_hw *hw,
+				      struct dlb_create_sched_domain_args *args,
+				      struct dlb_cmd_response *resp)
+{
+	resp->id = 0;
+	resp->status = 0;
+
+	return 0;
+}
+
+static int dlb_pf_get_num_resources(struct dlb_hw *hw,
+				    struct dlb_get_num_resources_args *args)
+{
+	return dlb_hw_get_num_resources(hw, args, false, 0);
+}
+
 /********************************/
 /****** DLB PF Device Ops ******/
 /********************************/
@@ -105,4 +125,6 @@ struct dlb_device_ops dlb_pf_ops = {
 	.init_driver_state = dlb_pf_init_driver_state,
 	.enable_pm = dlb_pf_enable_pm,
 	.wait_for_device_ready = dlb_pf_wait_for_device_ready,
+	.create_sched_domain = dlb_pf_create_sched_domain,
+	.get_num_resources = dlb_pf_get_num_resources,
 };
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index fca444c46aca..9d75b12eb793 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -200,6 +200,68 @@ int dlb_resource_init(struct dlb_hw *hw)
 	return ret;
 }
 
+/**
+ * dlb_hw_get_num_resources() - query the PCI function's available resources
+ * @hw: dlb_hw handle for a particular device.
+ * @arg: pointer to resource counts.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function returns the number of available resources for the PF or for a
+ * VF.
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, -EINVAL if vdev_req is true and vdev_id is
+ * invalid.
+ */
+int dlb_hw_get_num_resources(struct dlb_hw *hw,
+			     struct dlb_get_num_resources_args *arg,
+			     bool vdev_req, unsigned int vdev_id)
+{
+	struct dlb_function_resources *rsrcs;
+	struct dlb_bitmap *map;
+	int i;
+
+	if (vdev_req && vdev_id >= DLB_MAX_NUM_VDEVS)
+		return -EINVAL;
+
+	if (vdev_req)
+		rsrcs = &hw->vdev[vdev_id];
+	else
+		rsrcs = &hw->pf;
+
+	arg->num_sched_domains = rsrcs->num_avail_domains;
+
+	arg->num_ldb_queues = rsrcs->num_avail_ldb_queues;
+
+	arg->num_ldb_ports = 0;
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		arg->num_ldb_ports += rsrcs->num_avail_ldb_ports[i];
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		arg->num_cos_ldb_ports[i] = rsrcs->num_avail_ldb_ports[i];
+
+	arg->num_dir_ports = rsrcs->num_avail_dir_pq_pairs;
+
+	arg->num_atomic_inflights = rsrcs->num_avail_aqed_entries;
+
+	map = rsrcs->avail_hist_list_entries;
+
+	arg->num_hist_list_entries = bitmap_weight(map->map, map->len);
+
+	arg->max_contiguous_hist_list_entries =
+		dlb_bitmap_longest_set_range(map);
+
+	arg->num_ldb_credits = rsrcs->num_avail_qed_entries;
+
+	arg->num_dir_credits = rsrcs->num_avail_dqed_entries;
+
+	return 0;
+}
+
 /**
  * dlb_clr_pmcsr_disable() - power on bulk of DLB 2.0 logic
  * @hw: dlb_hw handle for a particular device.
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
index 2229813d9c45..3e6d419796bc 100644
--- a/drivers/misc/dlb/dlb_resource.h
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -12,6 +12,10 @@ int dlb_resource_init(struct dlb_hw *hw);
 
 void dlb_resource_free(struct dlb_hw *hw);
 
+int dlb_hw_get_num_resources(struct dlb_hw *hw,
+			     struct dlb_get_num_resources_args *arg,
+			     bool vdev_req, unsigned int vdev_id);
+
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 
 #endif /* __DLB_RESOURCE_H */
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
new file mode 100644
index 000000000000..87ba1bfa75ed
--- /dev/null
+++ b/include/uapi/linux/dlb.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_H
+#define __DLB_H
+
+#include <linux/types.h>
+
+struct dlb_cmd_response {
+	__u32 status; /* Interpret using enum dlb_error */
+	__u32 id;
+};
+
+/********************************/
+/* 'dlb' device file commands  */
+/********************************/
+
+#define DLB_DEVICE_VERSION(x) (((x) >> 8) & 0xFF)
+#define DLB_DEVICE_REVISION(x) ((x) & 0xFF)
+
+enum dlb_revisions {
+	DLB_REV_A0 = 0,
+	DLB_REV_A1,
+	DLB_REV_A2,
+	DLB_REV_B0,
+};
+
+/*
+ * DLB_CMD_GET_DEVICE_VERSION: Query the DLB device version.
+ *
+ *	All DLB device versions have the same ioctl API. Each version may have
+ *	different resource and feature set. The device revision is provided
+ *	in case of any hardware errata.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ * @response.id[7:0]: Device revision.
+ * @response.id[15:8]: Device version.
+ */
+
+struct dlb_get_device_version_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+};
+
+/*
+ * DLB_CMD_CREATE_SCHED_DOMAIN: Create a DLB 2.0 scheduling domain and reserve
+ *	its hardware resources. This command returns the newly created domain
+ *	ID and a file descriptor for accessing the domain.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ * @response.id: domain ID.
+ * @domain_fd: file descriptor for performing the domain's ioctl operations
+ * @padding0: Reserved for future use.
+ *
+ * Input parameters:
+ * @num_ldb_queues: Number of load-balanced queues.
+ * @num_ldb_ports: Number of load-balanced ports that can be allocated from
+ *	any class-of-service with available ports.
+ * @num_cos_ldb_ports[4]: Number of load-balanced ports from
+ *	classes-of-service 0-3.
+ * @num_dir_ports: Number of directed ports. A directed port has one directed
+ *	queue, so no num_dir_queues argument is necessary.
+ * @num_atomic_inflights: This specifies the amount of temporary atomic QE
+ *	storage for the domain. This storage is divided among the domain's
+ *	load-balanced queues that are configured for atomic scheduling.
+ * @num_hist_list_entries: Amount of history list storage. This is divided
+ *	among the domain's CQs.
+ * @num_ldb_credits: Amount of load-balanced QE storage (QED). QEs occupy this
+ *	space until they are scheduled to a load-balanced CQ. One credit
+ *	represents the storage for one QE.
+ * @num_dir_credits: Amount of directed QE storage (DQED). QEs occupy this
+ *	space until they are scheduled to a directed CQ. One credit represents
+ *	the storage for one QE.
+ * @cos_strict: If set, return an error if there are insufficient ports in
+ *	class-of-service N to satisfy the num_ldb_ports_cosN argument. If
+ *	unset, attempt to fulfill num_ldb_ports_cosN arguments from other
+ *	classes-of-service if class N does not contain enough free ports.
+ * @padding1: Reserved for future use.
+ */
+struct dlb_create_sched_domain_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	__u32 domain_fd;
+	__u32 padding0;
+	/* Input parameters */
+	__u32 num_ldb_queues;
+	__u32 num_ldb_ports;
+	__u32 num_cos_ldb_ports[4];
+	__u32 num_dir_ports;
+	__u32 num_atomic_inflights;
+	__u32 num_hist_list_entries;
+	__u32 num_ldb_credits;
+	__u32 num_dir_credits;
+	__u8 cos_strict;
+	__u8 padding1[3];
+};
+
+/*
+ * DLB_CMD_GET_NUM_RESOURCES: Return the number of available resources
+ *	(queues, ports, etc.) that this device owns.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	ioctl request arg is invalid, the driver won't set status.
+ * @num_domains: Number of available scheduling domains.
+ * @num_ldb_queues: Number of available load-balanced queues.
+ * @num_ldb_ports: Total number of available load-balanced ports.
+ * @num_cos_ldb_ports[4]: Number of available load-balanced ports from
+ *	classes-of-service 0-3.
+ * @num_dir_ports: Number of available directed ports. There is one directed
+ *	queue for every directed port.
+ * @num_atomic_inflights: Amount of available temporary atomic QE storage.
+ * @num_hist_list_entries: Amount of history list storage.
+ * @max_contiguous_hist_list_entries: History list storage is allocated in
+ *	a contiguous chunk, and this return value is the longest available
+ *	contiguous range of history list entries.
+ * @num_ldb_credits: Amount of available load-balanced QE storage.
+ * @num_dir_credits: Amount of available directed QE storage.
+ */
+struct dlb_get_num_resources_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	__u32 num_sched_domains;
+	__u32 num_ldb_queues;
+	__u32 num_ldb_ports;
+	__u32 num_cos_ldb_ports[4];
+	__u32 num_dir_ports;
+	__u32 num_atomic_inflights;
+	__u32 num_hist_list_entries;
+	__u32 max_contiguous_hist_list_entries;
+	__u32 num_ldb_credits;
+	__u32 num_dir_credits;
+};
+
+enum dlb_user_interface_commands {
+	DLB_CMD_GET_DEVICE_VERSION,
+	DLB_CMD_CREATE_SCHED_DOMAIN,
+	DLB_CMD_GET_NUM_RESOURCES,
+
+	/* NUM_DLB_CMD must be last */
+	NUM_DLB_CMD,
+};
+
+/********************/
+/* dlb ioctl codes */
+/********************/
+
+#define DLB_IOC_MAGIC	0x81
+
+#define DLB_IOC_GET_DEVICE_VERSION				\
+		_IOR(DLB_IOC_MAGIC,				\
+		     DLB_CMD_GET_DEVICE_VERSION,		\
+		     struct dlb_get_device_version_args)
+#define DLB_IOC_CREATE_SCHED_DOMAIN				\
+		_IOWR(DLB_IOC_MAGIC,				\
+		      DLB_CMD_CREATE_SCHED_DOMAIN,		\
+		      struct dlb_create_sched_domain_args)
+#define DLB_IOC_GET_NUM_RESOURCES				\
+		_IOR(DLB_IOC_MAGIC,				\
+		     DLB_CMD_GET_NUM_RESOURCES,			\
+		     struct dlb_get_num_resources_args)
+
+#endif /* __DLB_H */
-- 
2.17.1

