Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEBF47BA2B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhLUGuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:29879 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234238AbhLUGuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069418; x=1671605418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l4XQdmvnmgYwDvAzizZrcppUYqNiCALJIK53TGVh5XA=;
  b=U3WiTbC6H0N+apyO03sklfK2JRACXQSjtQEum5OZtndm/TMzeNd4wKYz
   NMucPYIQCokV43gf+5nkAXpwka9dF4UlqvABMOp6zOVH/dwg0S89h+oj9
   uOxfOVLCpwmg77wcXi4b0gLXngBOzPJQGz+fCFPjAFRgEh1x039AcQ0+p
   cL21gUUcV6dprAeJomWKsiIAoyiixOAWsxEjtIcRiYFRm+pHWqBHB9VYD
   l2CDifkpULwyUc7pvpnQLy1rTf57pqeJhqPccp0duVDdExsq66OJnn60W
   c1dgiLwBKrq/Ug1cFFirMT+Yn2t5zWtPCwBwtsasuBr6pT5fvEDCufrUN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107469"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107469"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570118998"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:17 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 04/17] dlb: add configfs interface and scheduling domain directory
Date:   Tue, 21 Dec 2021 00:50:34 -0600
Message-Id: <20211221065047.290182-5-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the dlb device level configfs interface. Each dlb device has a
configfs node at /sys/kernel/config/dlb/dlb%N, which is used to control
and configure the device.

Also add the scheduling domain directory in the device node of configfs.
A scheduling domain serves as a HW container of DLB resources -- e.g.
ports, queues, and credits -- with the property that a port can only
enqueue to and dequeue from queues within its domain. A scheduling domain
is created on-demand by a user-space application, whose request includes
the DLB resource allocation.

To create a HW scheduling domain, a user creates a domain directory using
"mkdir" in the configfs, and configure the resources needed (such as number
of ports and queues, and credits, etc)  by writing to the attribute files
in the directory. A final write of "1" to "create" file triggers creation
of a scheduling domain in DLB.

The hardware operation for scheduling domain creation will be added in a
subsequent commit.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/Makefile       |   2 +-
 drivers/misc/dlb/dlb_args.h     |  60 +++++++
 drivers/misc/dlb/dlb_configfs.c | 299 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_configfs.h |  39 +++++
 drivers/misc/dlb/dlb_main.c     |   9 +
 drivers/misc/dlb/dlb_main.h     |  10 ++
 drivers/misc/dlb/dlb_resource.c |  10 ++
 7 files changed, 428 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/dlb/dlb_args.h
 create mode 100644 drivers/misc/dlb/dlb_configfs.c
 create mode 100644 drivers/misc/dlb/dlb_configfs.h

diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
index 66d885619e66..1567bfdfc7a7 100644
--- a/drivers/misc/dlb/Makefile
+++ b/drivers/misc/dlb/Makefile
@@ -3,4 +3,4 @@
 obj-$(CONFIG_INTEL_DLB) := dlb.o
 
 dlb-objs := dlb_main.o
-dlb-objs += dlb_pf_ops.o dlb_resource.o
+dlb-objs += dlb_pf_ops.o dlb_resource.o dlb_configfs.o
diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
new file mode 100644
index 000000000000..a7541a6b0ebe
--- /dev/null
+++ b/drivers/misc/dlb/dlb_args.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_ARGS_H
+#define __DLB_ARGS_H
+
+struct dlb_cmd_response {
+	__u32 status; /* Interpret using enum dlb_error */
+	__u32 id;
+};
+
+#define DLB_DEVICE_VERSION(x) (((x) >> 8) & 0xFF)
+#define DLB_DEVICE_REVISION(x) ((x) & 0xFF)
+
+/*****************************************************/
+/* 'dlb' device level control/access data structures */
+/*****************************************************/
+
+/*
+ * dlb_create_sched_domain_args: Used to create a DLB 2.0 scheduling domain
+ *	and reserve its hardware resources.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: domain ID.
+ * @domain_fd: file descriptor for performing the domain's reset operation.
+ *
+ * Input parameters:
+ * @num_ldb_queues: Number of load-balanced queues.
+ * @num_ldb_ports: Number of load-balanced ports that can be allocated from
+ *	any class-of-service with available ports.
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
+ */
+struct dlb_create_sched_domain_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	__u32 domain_fd;
+	/* Input parameters */
+	__u32 num_ldb_queues;
+	__u32 num_ldb_ports;
+	__u32 num_dir_ports;
+	__u32 num_atomic_inflights;
+	__u32 num_hist_list_entries;
+	__u32 num_ldb_credits;
+	__u32 num_dir_credits;
+};
+#endif /* DLB_ARGS_H */
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
new file mode 100644
index 000000000000..bdabf3c6444f
--- /dev/null
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright(c) 2017-2020 Intel Corporation
+
+#include <linux/configfs.h>
+#include "dlb_configfs.h"
+
+struct dlb_device_configfs dlb_dev_configfs[16];
+
+static int dlb_configfs_create_sched_domain(struct dlb *dlb,
+					    void *karg)
+{
+	struct dlb_create_sched_domain_args *arg = karg;
+	struct dlb_cmd_response response = {0};
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	ret = dlb_hw_create_sched_domain(&dlb->hw, arg, &response);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	memcpy(karg, &response, sizeof(response));
+
+	return ret;
+}
+
+/*
+ * Configfs directory structure for dlb driver implementation:
+ *
+ *                             config
+ *                                |
+ *                               dlb
+ *                                |
+ *                        +------+------+------+------
+ *                        |      |      |      |
+ *                       dlb0   dlb1   dlb2   dlb3  ...
+ *                        |
+ *                +-----------+--+--------+-------
+ *                |           |           |
+ *             domain0     domain1     domain2   ...
+ *                |
+ *        +-------+-----+------------+---------------+------------+----------
+ *        |             |            |               |            |
+ * num_ldb_queues     port0         port1   ...    queue0       queue1   ...
+ * num_ldb_ports        |		             |
+ * ...                is_ldb                   num_sequence_numbers
+ * create             cq_depth                 num_qid_inflights
+ * start              ...                      num_atomic_iflights
+ *                    enable                   ...
+ *                    ...
+ */
+
+/*
+ * ------ Configfs for dlb domains---------
+ *
+ * These are the templates for show and store functions in domain
+ * groups/directories, which minimizes replication of boilerplate
+ * code to copy arguments. Most attributes, use the simple template.
+ * "name" is the attribute name in the group.
+ */
+#define DLB_CONFIGFS_DOMAIN_SHOW(name)				\
+static ssize_t dlb_cfs_domain_##name##_show(			\
+	struct config_item *item,				\
+	char *page)						\
+{								\
+	return sprintf(page, "%u\n",				\
+		       to_dlb_cfs_domain(item)->name);		\
+}								\
+
+#define DLB_CONFIGFS_DOMAIN_STORE(name)				\
+static ssize_t dlb_cfs_domain_##name##_store(			\
+	struct config_item *item,				\
+	const char *page,					\
+	size_t count)						\
+{								\
+	int ret;						\
+	struct dlb_cfs_domain *dlb_cfs_domain =			\
+				to_dlb_cfs_domain(item);	\
+								\
+	ret = kstrtoint(page, 10, &dlb_cfs_domain->name);	\
+	if (ret)						\
+		return ret;					\
+								\
+	return count;						\
+}								\
+
+DLB_CONFIGFS_DOMAIN_SHOW(status)
+DLB_CONFIGFS_DOMAIN_SHOW(domain_id)
+DLB_CONFIGFS_DOMAIN_SHOW(num_ldb_queues)
+DLB_CONFIGFS_DOMAIN_SHOW(num_ldb_ports)
+DLB_CONFIGFS_DOMAIN_SHOW(num_dir_ports)
+DLB_CONFIGFS_DOMAIN_SHOW(num_atomic_inflights)
+DLB_CONFIGFS_DOMAIN_SHOW(num_hist_list_entries)
+DLB_CONFIGFS_DOMAIN_SHOW(num_ldb_credits)
+DLB_CONFIGFS_DOMAIN_SHOW(num_dir_credits)
+DLB_CONFIGFS_DOMAIN_SHOW(create)
+
+DLB_CONFIGFS_DOMAIN_STORE(num_ldb_queues)
+DLB_CONFIGFS_DOMAIN_STORE(num_ldb_ports)
+DLB_CONFIGFS_DOMAIN_STORE(num_dir_ports)
+DLB_CONFIGFS_DOMAIN_STORE(num_atomic_inflights)
+DLB_CONFIGFS_DOMAIN_STORE(num_hist_list_entries)
+DLB_CONFIGFS_DOMAIN_STORE(num_ldb_credits)
+DLB_CONFIGFS_DOMAIN_STORE(num_dir_credits)
+
+static ssize_t dlb_cfs_domain_create_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	struct dlb_cfs_domain *dlb_cfs_domain = to_dlb_cfs_domain(item);
+	struct dlb_device_configfs *dlb_dev_configfs;
+	struct dlb *dlb;
+	int ret, create_in;
+
+	dlb_dev_configfs = container_of(dlb_cfs_domain->dev_grp,
+					struct dlb_device_configfs,
+					dev_group);
+	dlb = dlb_dev_configfs->dlb;
+	if (!dlb)
+		return -EINVAL;
+
+	ret = kstrtoint(page, 10, &create_in);
+	if (ret)
+		return ret;
+
+	/* Writing 1 to the 'create' triggers scheduling domain creation */
+	if (create_in == 1 && dlb_cfs_domain->create == 0) {
+		struct dlb_create_sched_domain_args args = {0};
+
+		memcpy(&args.response, &dlb_cfs_domain->status,
+		       sizeof(struct dlb_create_sched_domain_args));
+
+		dev_dbg(dlb->dev,
+			"Create domain: %s\n",
+			dlb_cfs_domain->group.cg_item.ci_namebuf);
+
+		ret = dlb_configfs_create_sched_domain(dlb, &args);
+
+		dlb_cfs_domain->status = args.response.status;
+		dlb_cfs_domain->domain_id = args.response.id;
+
+		if (ret) {
+			dev_err(dlb->dev,
+				"create sched domain failed: ret=%d\n", ret);
+			return ret;
+		}
+
+		dlb_cfs_domain->create = 1;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR_RO(dlb_cfs_domain_, status);
+CONFIGFS_ATTR_RO(dlb_cfs_domain_, domain_id);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_ldb_queues);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_ldb_ports);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_dir_ports);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_atomic_inflights);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_hist_list_entries);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_ldb_credits);
+CONFIGFS_ATTR(dlb_cfs_domain_, num_dir_credits);
+CONFIGFS_ATTR(dlb_cfs_domain_, create);
+
+static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
+	&dlb_cfs_domain_attr_status,
+	&dlb_cfs_domain_attr_domain_id,
+	&dlb_cfs_domain_attr_num_ldb_queues,
+	&dlb_cfs_domain_attr_num_ldb_ports,
+	&dlb_cfs_domain_attr_num_dir_ports,
+	&dlb_cfs_domain_attr_num_atomic_inflights,
+	&dlb_cfs_domain_attr_num_hist_list_entries,
+	&dlb_cfs_domain_attr_num_ldb_credits,
+	&dlb_cfs_domain_attr_num_dir_credits,
+	&dlb_cfs_domain_attr_create,
+
+	NULL,
+};
+
+static void dlb_cfs_domain_release(struct config_item *item)
+{
+	kfree(to_dlb_cfs_domain(item));
+}
+
+static struct configfs_item_operations dlb_cfs_domain_item_ops = {
+	.release	= dlb_cfs_domain_release,
+};
+
+static const struct config_item_type dlb_cfs_domain_type = {
+	.ct_item_ops	= &dlb_cfs_domain_item_ops,
+	.ct_attrs	= dlb_cfs_domain_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+/*
+ *--------- dlb device level configfs -----------
+ *
+ * Scheduling domains are created in the device-level configfs driectory.
+ */
+static struct config_group *dlb_cfs_device_make_domain(struct config_group *group,
+						       const char *name)
+{
+	struct dlb_cfs_domain *dlb_cfs_domain;
+
+	dlb_cfs_domain = kzalloc(sizeof(*dlb_cfs_domain), GFP_KERNEL);
+	if (!dlb_cfs_domain)
+		return ERR_PTR(-ENOMEM);
+
+	dlb_cfs_domain->dev_grp = group;
+
+	config_group_init_type_name(&dlb_cfs_domain->group, name,
+				    &dlb_cfs_domain_type);
+
+	return &dlb_cfs_domain->group;
+}
+
+static struct configfs_group_operations dlb_cfs_device_group_ops = {
+	.make_group     = dlb_cfs_device_make_domain,
+};
+
+static const struct config_item_type dlb_cfs_device_type = {
+	/* No need for _item_ops() at the device-level, and default
+	 * attribute.
+	 * .ct_item_ops	= &dlb_cfs_device_item_ops,
+	 * .ct_attrs	= dlb_cfs_device_attrs,
+	 */
+
+	.ct_group_ops	= &dlb_cfs_device_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+/*------------------- dlb group subsystem for configfs ----------------
+ *
+ * we only need a simple configfs item type here that does not let
+ * user to create new entry. The group for each dlb device will be
+ * generated when the device is detected in dlb_probe().
+ */
+
+static const struct config_item_type dlb_device_group_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+/* dlb group subsys in configfs */
+static struct configfs_subsystem dlb_device_group_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "dlb",
+			.ci_type = &dlb_device_group_type,
+		},
+	},
+};
+
+/* Create a configfs directory dlbN for each dlb device probed
+ * in dlb_probe()
+ */
+int dlb_configfs_create_device(struct dlb *dlb)
+{
+	struct config_group *parent_group, *dev_grp;
+	char device_name[16];
+	int ret = 0;
+
+	snprintf(device_name, 6, "dlb%d", dlb->id);
+	parent_group = &dlb_device_group_subsys.su_group;
+
+	dev_grp = &dlb_dev_configfs[dlb->id].dev_group;
+	config_group_init_type_name(dev_grp,
+				    device_name,
+				    &dlb_cfs_device_type);
+	ret = configfs_register_group(parent_group, dev_grp);
+
+	if (ret)
+		return ret;
+
+	dlb_dev_configfs[dlb->id].dlb = dlb;
+
+	return ret;
+}
+
+int configfs_dlb_init(void)
+{
+	struct configfs_subsystem *subsys;
+	int ret;
+
+	/* set up and register configfs subsystem for dlb */
+	subsys = &dlb_device_group_subsys;
+	config_group_init(&subsys->su_group);
+	mutex_init(&subsys->su_mutex);
+	ret = configfs_register_subsystem(subsys);
+	if (ret) {
+		pr_err("Error %d while registering subsystem %s\n",
+		       ret, subsys->su_group.cg_item.ci_namebuf);
+	}
+
+	return ret;
+}
+
+void configfs_dlb_exit(void)
+{
+	configfs_unregister_subsystem(&dlb_device_group_subsys);
+}
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
new file mode 100644
index 000000000000..03019e046429
--- /dev/null
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_CONFIGFS_H
+#define __DLB_CONFIGFS_H
+
+#include "dlb_main.h"
+
+struct dlb_device_configfs {
+	struct config_group dev_group;
+	struct dlb *dlb;
+};
+
+struct dlb_cfs_domain {
+	struct config_group group;
+	struct config_group *dev_grp;
+	unsigned int status;
+	unsigned int domain_id;
+	/* Input parameters */
+	unsigned int domain_fd;
+	unsigned int num_ldb_queues;
+	unsigned int num_ldb_ports;
+	unsigned int num_dir_ports;
+	unsigned int num_atomic_inflights;
+	unsigned int num_hist_list_entries;
+	unsigned int num_ldb_credits;
+	unsigned int num_dir_credits;
+	unsigned int create;
+
+};
+
+static inline
+struct dlb_cfs_domain *to_dlb_cfs_domain(struct config_item *item)
+{
+	return container_of(to_config_group(item),
+			    struct dlb_cfs_domain, group);
+}
+
+#endif /* DLB_CONFIGFS_H */
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 136e8b54ea2b..1bd9ca7772a9 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -128,6 +128,10 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto dma_set_mask_fail;
 
+	ret = dlb_configfs_create_device(dlb);
+	if (ret)
+		goto configfs_create_fail;
+
 	/*
 	 * PM enable must be done before any other MMIO accesses, and this
 	 * setting is persistent across device reset.
@@ -157,6 +161,7 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 resource_init_fail:
 dlb_reset_fail:
 wait_for_device_ready_fail:
+configfs_create_fail:
 dma_set_mask_fail:
 	device_destroy(dlb_class, dlb->dev_number);
 map_pci_bar_fail:
@@ -225,6 +230,8 @@ static int __init dlb_init_module(void)
 	if (err)
 		goto cdev_add_fail;
 
+	configfs_dlb_init();
+
 	err = pci_register_driver(&dlb_pci_driver);
 	if (err < 0) {
 		pr_err("dlb: pci_register_driver() returned %d\n", err);
@@ -248,6 +255,8 @@ static void __exit dlb_exit_module(void)
 {
 	pci_unregister_driver(&dlb_pci_driver);
 
+	configfs_dlb_exit();
+
 	cdev_del(&dlb_cdev);
 
 	unregister_chrdev_region(dlb_devt, DLB_MAX_NUM_DEVICES);
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index a65b12b75b4c..4921333a6ec3 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -13,6 +13,8 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 
+#include "dlb_args.h"
+
 /*
  * Hardware related #defines and data structures.
  *
@@ -327,6 +329,14 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
 /* Prototypes for dlb_resource.c */
 int dlb_resource_init(struct dlb_hw *hw);
 void dlb_resource_free(struct dlb_hw *hw);
+int dlb_hw_create_sched_domain(struct dlb_hw *hw,
+			       struct dlb_create_sched_domain_args *args,
+			       struct dlb_cmd_response *resp);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 
+/* Prototypes for dlb_configfs.c */
+int dlb_configfs_create_device(struct dlb *dlb);
+int configfs_dlb_init(void);
+void configfs_dlb_exit(void);
+
 #endif /* __DLB_MAIN_H */
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index c192d4fb8463..7d7ebf3db292 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -190,6 +190,16 @@ int dlb_resource_init(struct dlb_hw *hw)
 	return ret;
 }
 
+int dlb_hw_create_sched_domain(struct dlb_hw *hw,
+			       struct dlb_create_sched_domain_args *args,
+			       struct dlb_cmd_response *resp)
+{
+	resp->id = 0;
+	resp->status = 0;
+
+	return 0;
+}
+
 /**
  * dlb_clr_pmcsr_disable() - power on bulk of DLB 2.0 logic
  * @hw: dlb_hw handle for a particular device.
-- 
2.27.0

