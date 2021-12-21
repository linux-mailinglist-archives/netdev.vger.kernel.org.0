Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D17547BA4C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhLUGv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhLUGvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069508; x=1671605508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nWH8n9kTyD2iwRgGuJa9kqNKiX43tG/cyKOmbrL67wY=;
  b=AGnq7i6EDxRCpkJka3KtwCmlha3s1s0xITavCwoe5kjaBgUBx2qgN9ht
   6ghyjgH3uJ1Ecgc1V5hDYnrL21dAHNlZGyw0oFhQFC5aqgLwVA7gL+s/T
   Yj6RIYW7KojSTIa3sR9yvoTJFbcN4PWC4BRuHKyaZsGHZgDWvJhc0099M
   BrtnOULbHrpVHL7KPY9tez+vxYHkiYL5DNANrUqgAoJFhZrz+REOLj6RB
   2lc8VXlTH8iQyF7LtT5kaprwfEO6Jb45nwt4UYDx2ZqrIBO+c/pcc54x1
   Ab6ZF+dlIc6Kn2brVS+IsCuJ6GVUkza+bt0DX9NB2pmqw8Z6/01GWcG8/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107553"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107553"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119141"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:44 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Date:   Tue, 21 Dec 2021 00:50:47 -0600
Message-Id: <20211221065047.290182-18-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dlb sysfs interfaces include files for reading the total and
available device resources, and reading the device ID and version. The
interfaces are used for device level configurations and resource
inquiries.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-dlb | 116 ++++++++++++
 drivers/misc/dlb/dlb_args.h                |  34 ++++
 drivers/misc/dlb/dlb_main.c                |   5 +
 drivers/misc/dlb/dlb_main.h                |   3 +
 drivers/misc/dlb/dlb_pf_ops.c              | 195 +++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.c            |  50 ++++++
 6 files changed, 403 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-dlb

diff --git a/Documentation/ABI/testing/sysfs-driver-dlb b/Documentation/ABI/testing/sysfs-driver-dlb
new file mode 100644
index 000000000000..bf09ef6f8a3a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-dlb
@@ -0,0 +1,116 @@
+What:		/sys/bus/pci/devices/.../total_resources/num_atomic_inflights
+What:		/sys/bus/pci/devices/.../total_resources/num_dir_credits
+What:		/sys/bus/pci/devices/.../total_resources/num_dir_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_hist_list_entries
+What:		/sys/bus/pci/devices/.../total_resources/num_ldb_credits
+What:		/sys/bus/pci/devices/.../total_resources/num_ldb_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_cos0_ldb_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_cos1_ldb_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_cos2_ldb_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_cos3_ldb_ports
+What:		/sys/bus/pci/devices/.../total_resources/num_ldb_queues
+What:		/sys/bus/pci/devices/.../total_resources/num_sched_domains
+Date:		Oct 15, 2021
+KernelVersion:	5.15
+Contact:	mike.ximing.chen@intel.com
+Description:
+		The total_resources subdirectory contains read-only files that
+		indicate the total number of resources in the device.
+
+		num_atomic_inflights:  Total number of atomic inflights in the
+				       device. Atomic inflights refers to the
+				       on-device storage used by the atomic
+				       scheduler.
+
+		num_dir_credits:       Total number of directed credits in the
+				       device.
+
+		num_dir_ports:	       Total number of directed ports (and
+				       queues) in the device.
+
+		num_hist_list_entries: Total number of history list entries in
+				       the device.
+
+		num_ldb_credits:       Total number of load-balanced credits in
+				       the device.
+
+		num_ldb_ports:	       Total number of load-balanced ports in
+				       the device.
+
+		num_cos<M>_ldb_ports:  Total number of load-balanced ports
+				       belonging to class-of-service M in the
+				       device.
+
+		num_ldb_queues:	       Total number of load-balanced queues in
+				       the device.
+
+		num_sched_domains:     Total number of scheduling domains in the
+				       device.
+
+What:		/sys/bus/pci/devices/.../avail_resources/num_atomic_inflights
+What:		/sys/bus/pci/devices/.../avail_resources/num_dir_credits
+What:		/sys/bus/pci/devices/.../avail_resources/num_dir_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_hist_list_entries
+What:		/sys/bus/pci/devices/.../avail_resources/num_ldb_credits
+What:		/sys/bus/pci/devices/.../avail_resources/num_ldb_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_cos0_ldb_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_cos1_ldb_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_cos2_ldb_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_cos3_ldb_ports
+What:		/sys/bus/pci/devices/.../avail_resources/num_ldb_queues
+What:		/sys/bus/pci/devices/.../avail_resources/num_sched_domains
+What:		/sys/bus/pci/devices/.../avail_resources/max_ctg_hl_entries
+Date:		Oct 15, 2021
+KernelVersion:	5.15
+Contact:	mike.ximing.chen@intel.com
+Description:
+		The avail_resources subdirectory contains read-only files that
+		indicate the available number of resources in the device.
+		"Available" here means resources that are not currently in use
+		by an application or, in the case of a physical function
+		device, assigned to a virtual function.
+
+		num_atomic_inflights:  Available number of atomic inflights in
+				       the device.
+
+		num_dir_ports:	       Available number of directed ports (and
+				       queues) in the device.
+
+		num_hist_list_entries: Available number of history list entries
+				       in the device.
+
+		num_ldb_credits:       Available number of load-balanced credits
+				       in the device.
+
+		num_ldb_ports:	       Available number of load-balanced ports
+				       in the device.
+
+		num_cos<M>_ldb_ports:  Available number of load-balanced ports
+				       belonging to class-of-service M in the
+				       device.
+
+		num_ldb_queues:	       Available number of load-balanced queues
+				       in the device.
+
+		num_sched_domains:     Available number of scheduling domains in
+				       the device.
+
+		max_ctg_hl_entries:    Maximum contiguous history list entries
+				       available in the device.
+
+				       Each scheduling domain is created with
+				       an allocation of history list entries,
+				       and each domain's allocation of entries
+				       must be contiguous.
+
+What:		/sys/bus/pci/devices/.../dev_id
+Date:		Oct 15, 2021
+KernelVersion:	5.15
+Contact:	mike.ximing.chen@intel.com
+Description:	Device ID used in /dev, i.e. /dev/dlb<device ID>
+
+		Each DLB 2.0 PF and VF device is granted a unique ID by the
+		kernel driver, and this ID is used to construct the device's
+		/dev directory: /dev/dlb<device ID>. This sysfs file can be read
+		to determine a device's ID, which allows the user to map a
+		device file to a PCI BDF.
diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index eac8890c3a70..7a48751f4b56 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -58,6 +58,40 @@ struct dlb_create_sched_domain_args {
 	__u32 num_dir_credits;
 };
 
+/*
+ * dlb_get_num_resources_args: Used to get the number of available resources
+ *      (queues, ports, etc.) that this device owns.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @num_domains: Number of available scheduling domains.
+ * @num_ldb_queues: Number of available load-balanced queues.
+ * @num_ldb_ports: Total number of available load-balanced ports.
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
+	__u32 num_dir_ports;
+	__u32 num_atomic_inflights;
+	__u32 num_hist_list_entries;
+	__u32 max_contiguous_hist_list_entries;
+	__u32 num_ldb_credits;
+	__u32 num_dir_credits;
+};
+
 /*************************************************/
 /* 'domain' level control/access data structures */
 /*************************************************/
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index ce3cbe15e198..ea2139462602 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -409,6 +409,10 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto dma_set_mask_fail;
 
+	ret = dlb_pf_sysfs_create(dlb);
+	if (ret)
+		goto sysfs_create_fail;
+
 	ret = dlb_configfs_create_device(dlb);
 	if (ret)
 		goto configfs_create_fail;
@@ -453,6 +457,7 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 dlb_reset_fail:
 wait_for_device_ready_fail:
 configfs_create_fail:
+sysfs_create_fail:
 dma_set_mask_fail:
 	device_destroy(dlb_class, dlb->dev_number);
 map_pci_bar_fail:
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index f410e7307c12..2c1401532496 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -330,6 +330,7 @@ struct dlb;
 int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
 void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
 int dlb_pf_init_driver_state(struct dlb *dlb);
+int dlb_pf_sysfs_create(struct dlb *dlb);
 void dlb_pf_enable_pm(struct dlb *dlb);
 int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev);
 void dlb_pf_init_hardware(struct dlb *dlb);
@@ -625,6 +626,8 @@ int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 int dlb_ldb_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
 int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
+int dlb_hw_get_num_resources(struct dlb_hw *hw,
+			     struct dlb_get_num_resources_args *arg);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
 			       struct dlb_get_ldb_queue_depth_args *args,
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 66fb4ffae939..4dde46642d6e 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -102,3 +102,198 @@ void dlb_pf_init_hardware(struct dlb *dlb)
 	dlb_hw_enable_sparse_ldb_cq_mode(&dlb->hw);
 	dlb_hw_enable_sparse_dir_cq_mode(&dlb->hw);
 }
+
+/*****************************/
+/****** Sysfs callbacks ******/
+/*****************************/
+
+#define DLB_TOTAL_SYSFS_SHOW(name, macro)		\
+static ssize_t total_##name##_show(			\
+	struct device *dev,				\
+	struct device_attribute *attr,			\
+	char *buf)					\
+{							\
+	int val = DLB_MAX_NUM_##macro;			\
+							\
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	\
+}
+
+DLB_TOTAL_SYSFS_SHOW(num_sched_domains, DOMAINS)
+DLB_TOTAL_SYSFS_SHOW(num_ldb_queues, LDB_QUEUES)
+DLB_TOTAL_SYSFS_SHOW(num_ldb_ports, LDB_PORTS)
+DLB_TOTAL_SYSFS_SHOW(num_dir_ports, DIR_PORTS)
+DLB_TOTAL_SYSFS_SHOW(num_ldb_credits, LDB_CREDITS)
+DLB_TOTAL_SYSFS_SHOW(num_dir_credits, DIR_CREDITS)
+DLB_TOTAL_SYSFS_SHOW(num_atomic_inflights, AQED_ENTRIES)
+DLB_TOTAL_SYSFS_SHOW(num_hist_list_entries, HIST_LIST_ENTRIES)
+
+#define DLB_AVAIL_SYSFS_SHOW(name)			     \
+static ssize_t avail_##name##_show(			     \
+	struct device *dev,				     \
+	struct device_attribute *attr,			     \
+	char *buf)					     \
+{							     \
+	struct dlb *dlb = dev_get_drvdata(dev);		     \
+	struct dlb_get_num_resources_args arg;		     \
+	struct dlb_hw *hw = &dlb->hw;			     \
+	int val;					     \
+							     \
+	mutex_lock(&dlb->resource_mutex);		     \
+							     \
+	val = dlb_hw_get_num_resources(hw, &arg);	     \
+							     \
+	mutex_unlock(&dlb->resource_mutex);		     \
+							     \
+	if (val)					     \
+		return -1;				     \
+							     \
+	val = arg.name;					     \
+							     \
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	     \
+}
+
+DLB_AVAIL_SYSFS_SHOW(num_sched_domains)
+DLB_AVAIL_SYSFS_SHOW(num_ldb_queues)
+DLB_AVAIL_SYSFS_SHOW(num_ldb_ports)
+DLB_AVAIL_SYSFS_SHOW(num_dir_ports)
+DLB_AVAIL_SYSFS_SHOW(num_ldb_credits)
+DLB_AVAIL_SYSFS_SHOW(num_dir_credits)
+DLB_AVAIL_SYSFS_SHOW(num_atomic_inflights)
+DLB_AVAIL_SYSFS_SHOW(num_hist_list_entries)
+
+static ssize_t max_ctg_hl_entries_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct dlb *dlb = dev_get_drvdata(dev);
+	struct dlb_get_num_resources_args arg;
+	struct dlb_hw *hw = &dlb->hw;
+	int val;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	val = dlb_hw_get_num_resources(hw, &arg);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	if (val)
+		return -1;
+
+	val = arg.max_contiguous_hist_list_entries;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
+/*
+ * Device attribute name doesn't match the show function name, so we define our
+ * own DEVICE_ATTR macro.
+ */
+#define DLB_DEVICE_ATTR_RO(_prefix, _name) \
+struct device_attribute dev_attr_##_prefix##_##_name = {\
+	.attr = { .name = __stringify(_name), .mode = 0444 },\
+	.show = _prefix##_##_name##_show,\
+}
+
+static DLB_DEVICE_ATTR_RO(total, num_sched_domains);
+static DLB_DEVICE_ATTR_RO(total, num_ldb_queues);
+static DLB_DEVICE_ATTR_RO(total, num_ldb_ports);
+static DLB_DEVICE_ATTR_RO(total, num_dir_ports);
+static DLB_DEVICE_ATTR_RO(total, num_ldb_credits);
+static DLB_DEVICE_ATTR_RO(total, num_dir_credits);
+static DLB_DEVICE_ATTR_RO(total, num_atomic_inflights);
+static DLB_DEVICE_ATTR_RO(total, num_hist_list_entries);
+
+static struct attribute *dlb_total_attrs[] = {
+	&dev_attr_total_num_sched_domains.attr,
+	&dev_attr_total_num_ldb_queues.attr,
+	&dev_attr_total_num_ldb_ports.attr,
+	&dev_attr_total_num_dir_ports.attr,
+	&dev_attr_total_num_ldb_credits.attr,
+	&dev_attr_total_num_dir_credits.attr,
+	&dev_attr_total_num_atomic_inflights.attr,
+	&dev_attr_total_num_hist_list_entries.attr,
+	NULL
+};
+
+static const struct attribute_group dlb_total_attr_group = {
+	.attrs = dlb_total_attrs,
+	.name = "total_resources",
+};
+
+static DLB_DEVICE_ATTR_RO(avail, num_sched_domains);
+static DLB_DEVICE_ATTR_RO(avail, num_ldb_queues);
+static DLB_DEVICE_ATTR_RO(avail, num_ldb_ports);
+static DLB_DEVICE_ATTR_RO(avail, num_dir_ports);
+static DLB_DEVICE_ATTR_RO(avail, num_ldb_credits);
+static DLB_DEVICE_ATTR_RO(avail, num_dir_credits);
+static DLB_DEVICE_ATTR_RO(avail, num_atomic_inflights);
+static DLB_DEVICE_ATTR_RO(avail, num_hist_list_entries);
+static DEVICE_ATTR_RO(max_ctg_hl_entries);
+
+static struct attribute *dlb_avail_attrs[] = {
+	&dev_attr_avail_num_sched_domains.attr,
+	&dev_attr_avail_num_ldb_queues.attr,
+	&dev_attr_avail_num_ldb_ports.attr,
+	&dev_attr_avail_num_dir_ports.attr,
+	&dev_attr_avail_num_ldb_credits.attr,
+	&dev_attr_avail_num_dir_credits.attr,
+	&dev_attr_avail_num_atomic_inflights.attr,
+	&dev_attr_avail_num_hist_list_entries.attr,
+	&dev_attr_max_ctg_hl_entries.attr,
+	NULL
+};
+
+static const struct attribute_group dlb_avail_attr_group = {
+	.attrs = dlb_avail_attrs,
+	.name = "avail_resources",
+};
+
+static ssize_t dev_id_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct dlb *dlb = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", dlb->id);
+}
+
+/* [7:0]: device revision, [15:8]: device version */
+#define DLB_SET_DEVICE_VERSION(ver, rev) (((ver) << 8) | (rev))
+
+static ssize_t dev_ver_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	int ver;
+
+	ver = DLB_SET_DEVICE_VERSION(2, 0);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ver);
+}
+
+static DEVICE_ATTR_RO(dev_id);
+static DEVICE_ATTR_RO(dev_ver);
+
+static struct attribute *dlb_dev_id_attr[] = {
+	&dev_attr_dev_id.attr,
+	&dev_attr_dev_ver.attr,
+	NULL
+};
+
+static const struct attribute_group dlb_dev_id_attr_group = {
+	.attrs = dlb_dev_id_attr,
+};
+
+static const struct attribute_group *dlb_pf_attr_groups[] = {
+	&dlb_dev_id_attr_group,
+	&dlb_total_attr_group,
+	&dlb_avail_attr_group,
+	NULL,
+};
+
+int dlb_pf_sysfs_create(struct dlb *dlb)
+{
+	struct device *dev = &dlb->pdev->dev;
+
+	return devm_device_add_groups(dev, dlb_pf_attr_groups);
+}
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index e19c0f6cc321..6926ad95d9e2 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -3855,6 +3855,56 @@ int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id)
 	return port->domain_id == domain->id;
 }
 
+/**
+ * dlb_hw_get_num_resources() - query the PCI function's available resources
+ * @hw: dlb_hw handle for a particular device.
+ * @arg: pointer to resource counts.
+ *
+ * This function returns the number of available resources for the PF or for a
+ * VF.
+ *
+ * Return:
+ * Returns 0 upon success, -EINVAL if input argument is
+ * invalid.
+ */
+int dlb_hw_get_num_resources(struct dlb_hw *hw,
+			     struct dlb_get_num_resources_args *arg)
+{
+	struct dlb_function_resources *rsrcs;
+	struct dlb_bitmap *map;
+	int i;
+
+	if (!hw || !arg)
+		return -EINVAL;
+
+	rsrcs = &hw->pf;
+
+	arg->num_sched_domains = rsrcs->num_avail_domains;
+
+	arg->num_ldb_queues = rsrcs->num_avail_ldb_queues;
+
+	arg->num_ldb_ports = 0;
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++)
+		arg->num_ldb_ports += rsrcs->num_avail_ldb_ports[i];
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
-- 
2.27.0

