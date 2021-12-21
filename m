Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC347BA40
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhLUGvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:29913 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhLUGue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069434; x=1671605434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZo+6Rh5OxE4wAyRdgei/VKBVcW/upxuLMu5/wT22EI=;
  b=kl1tIHImyRraDqUf4zJCLQ19bUS2ymPvCHKL0euZGjNY42+gjrwIY3Eg
   MyF3I+xSCbpltLstoWjSpbCUrpD33x9nqYoqBDHLgva4FpNInAbbk2OXp
   Ao0NpjVtA4WtvOul+6RnJ9DlcVfwdX3je4qrDePS0VIT/2BxMbUiASDVv
   qLuBW9uiQvjXnF+xs2QLEoPHucW3CPD2LJdbJAoO8Jy5hwoiUHtTvIZeq
   xIk65qHDatcSIpQN3+8cj5yU2FUC6bNHG/ie9TJpn2ZJ30MvvOEes11wq
   d68/obMC1QX/Pp20g/sATcM19FTI/P772PKsxwN3Y3OhDKZNYsf4YzjpN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107510"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107510"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119080"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:33 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 11/17] dlb: add configfs interface to configure ports
Date:   Tue, 21 Dec 2021 00:50:41 -0600
Message-Id: <20211221065047.290182-12-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add high-level code for port configuration and poll-mode query configfs
interface, argument verification, and placeholder functions for the
low-level register accesses. A subsequent commit will add the low-level
logic.

The port is a core's interface to the DLB, and it consists of an MMIO page
(the "producer port" (PP)) through which the core enqueues queue entries
and an in-memory queue (the "consumer queue" (CQ)) to which the device
schedules QEs. A subsequent commit will add the mmap interface for an
application to directly access the PP and CQ regions.

The driver allocates DMA memory for each port's CQ, and frees this memory
during domain reset or driver removal. Domain reset will also drains each
port's CQ and disables them from further scheduling.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_args.h     |  59 +++++-
 drivers/misc/dlb/dlb_configfs.c | 295 ++++++++++++++++++++++++++-
 drivers/misc/dlb/dlb_configfs.h |  24 +++
 drivers/misc/dlb/dlb_main.c     |  51 +++++
 drivers/misc/dlb/dlb_main.h     |  22 +++
 drivers/misc/dlb/dlb_pf_ops.c   |   7 +
 drivers/misc/dlb/dlb_resource.c | 341 ++++++++++++++++++++++++++++++++
 include/uapi/linux/dlb.h        |   6 +
 8 files changed, 803 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index 2a1584756e43..b54483bfa767 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -167,4 +167,61 @@ struct dlb_get_dir_queue_depth_args {
 	/* Input parameters */
 	__u32 queue_id;
 };
-#endif /* DLB_ARGS_H */
+
+/*
+ * dlb_create_ldb_port_args: Used to configure a load-balanced port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: port ID.
+ *
+ * Input parameters:
+ * @cq_depth: Depth of the port's CQ. Must be a power-of-two between 8 and
+ *	1024, inclusive.
+ * @cq_depth_threshold: CQ depth interrupt threshold. A value of N means that
+ *	the CQ interrupt won't fire until there are N or more outstanding CQ
+ *	tokens.
+ * @num_hist_list_entries: Number of history list entries. This must be
+ *	greater than or equal cq_depth.
+ */
+
+struct dlb_create_ldb_port_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u16 cq_depth;
+	__u16 cq_depth_threshold;
+	__u16 cq_history_list_size;
+};
+
+/*
+ * dlb_create_dir_port_args: Used to configure a directed port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: Port ID.
+ *
+ * Input parameters:
+ * @cq_depth: Depth of the port's CQ. Must be a power-of-two between 8 and
+ *	1024, inclusive.
+ * @cq_depth_threshold: CQ depth interrupt threshold. A value of N means that
+ *	the CQ interrupt won't fire until there are N or more outstanding CQ
+ *	tokens.
+ * @qid: Queue ID. If the corresponding directed queue is already created,
+ *	specify its ID here. Else this argument must be 0xFFFFFFFF to indicate
+ *	that the port is being created before the queue.
+ */
+struct dlb_create_dir_port_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u16 cq_depth;
+	__u16 cq_depth_threshold;
+	__s32 queue_id;
+};
+
+#define DLB_CQ_SIZE 65536
+
+#endif /* __DLB_ARGS_H */
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index f47d3d9b96ba..045d1dae2b7f 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -45,6 +45,109 @@ DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_dir_queue_depth)
 
+static int dlb_domain_configfs_create_ldb_port(struct dlb *dlb,
+					       struct dlb_domain *domain,
+					       void *karg)
+{
+	struct dlb_cmd_response response = {0};
+	struct dlb_create_ldb_port_args *arg = karg;
+	dma_addr_t cq_dma_base = 0;
+	void *cq_base;
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	cq_base = dma_alloc_coherent(&dlb->pdev->dev,
+				     DLB_CQ_SIZE,
+				     &cq_dma_base,
+				     GFP_KERNEL);
+	if (!cq_base) {
+		response.status = DLB_ST_NO_MEMORY;
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	ret = dlb_hw_create_ldb_port(&dlb->hw, domain->id,
+				     arg, (uintptr_t)cq_dma_base,
+				     &response);
+	if (ret)
+		goto unlock;
+
+	/* Fill out the per-port data structure */
+	dlb->ldb_port[response.id].id = response.id;
+	dlb->ldb_port[response.id].is_ldb = true;
+	dlb->ldb_port[response.id].domain = domain;
+	dlb->ldb_port[response.id].cq_base = cq_base;
+	dlb->ldb_port[response.id].cq_dma_base = cq_dma_base;
+	dlb->ldb_port[response.id].valid = true;
+
+unlock:
+	if (ret && cq_dma_base)
+		dma_free_coherent(&dlb->pdev->dev,
+				  DLB_CQ_SIZE,
+				  cq_base,
+				  cq_dma_base);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	BUILD_BUG_ON(offsetof(typeof(*arg), response) != 0);
+
+	memcpy(karg, &response, sizeof(response));
+
+	return ret;
+}
+
+static int dlb_domain_configfs_create_dir_port(struct dlb *dlb,
+					       struct dlb_domain *domain,
+					       void *karg)
+{
+	struct dlb_cmd_response response = {0};
+	struct dlb_create_dir_port_args *arg = karg;
+	dma_addr_t cq_dma_base = 0;
+	void *cq_base;
+	int ret;
+
+	mutex_lock(&dlb->resource_mutex);
+
+	cq_base = dma_alloc_coherent(&dlb->pdev->dev,
+				     DLB_CQ_SIZE,
+				     &cq_dma_base,
+				     GFP_KERNEL);
+	if (!cq_base) {
+		response.status = DLB_ST_NO_MEMORY;
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	ret = dlb_hw_create_dir_port(&dlb->hw, domain->id,
+				     arg, (uintptr_t)cq_dma_base,
+				     &response);
+	if (ret)
+		goto unlock;
+
+	/* Fill out the per-port data structure */
+	dlb->dir_port[response.id].id = response.id;
+	dlb->dir_port[response.id].is_ldb = false;
+	dlb->dir_port[response.id].domain = domain;
+	dlb->dir_port[response.id].cq_base = cq_base;
+	dlb->dir_port[response.id].cq_dma_base = cq_dma_base;
+	dlb->dir_port[response.id].valid = true;
+unlock:
+	if (ret && cq_dma_base)
+		dma_free_coherent(&dlb->pdev->dev,
+				  DLB_CQ_SIZE,
+				  cq_base,
+				  cq_dma_base);
+
+	mutex_unlock(&dlb->resource_mutex);
+
+	BUILD_BUG_ON(offsetof(typeof(*arg), response) != 0);
+
+	memcpy(karg, &response, sizeof(response));
+
+	return ret;
+}
+
 static int dlb_configfs_create_sched_domain(struct dlb *dlb,
 					    void *karg)
 {
@@ -330,6 +433,180 @@ static const struct config_item_type dlb_cfs_queue_type = {
 	.ct_owner	= THIS_MODULE,
 };
 
+/*
+ * ------ Configfs for dlb ports ---------
+ *
+ * These are the templates for show and store functions in port
+ * groups/directories, which minimizes replication of boilerplate
+ * code to copy arguments. Most attributes, use the simple template.
+ * "name" is the attribute name in the group.
+ */
+#define DLB_CONFIGFS_PORT_SHOW(name)					\
+static ssize_t dlb_cfs_port_##name##_show(				\
+	struct config_item *item,					\
+	char *page)							\
+{									\
+	return sprintf(page, "%u\n", to_dlb_cfs_port(item)->name);	\
+}									\
+
+#define DLB_CONFIGFS_PORT_SHOW64(name)					\
+static ssize_t dlb_cfs_port_##name##_show(				\
+	struct config_item *item,					\
+	char *page)							\
+{									\
+	return sprintf(page, "%llx\n", to_dlb_cfs_port(item)->name);	\
+}									\
+
+#define DLB_CONFIGFS_PORT_STORE(name)					\
+static ssize_t dlb_cfs_port_##name##_store(				\
+	struct config_item *item,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct dlb_cfs_port *dlb_cfs_port = to_dlb_cfs_port(item);	\
+	int ret;							\
+									\
+	ret = kstrtoint(page, 10, &dlb_cfs_port->name);			\
+	if (ret)							\
+		return ret;						\
+									\
+	return count;							\
+}									\
+
+#define DLB_CONFIGFS_PORT_STORE64(name)					\
+static ssize_t dlb_cfs_port_##name##_store(				\
+	struct config_item *item,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	int ret;							\
+	struct dlb_cfs_port *dlb_cfs_port = to_dlb_cfs_port(item);	\
+									\
+	ret = kstrtoll(page, 16, &dlb_cfs_port->name);			\
+	if (ret)							\
+		return ret;						\
+									\
+	return count;							\
+}									\
+
+DLB_CONFIGFS_PORT_SHOW(status)
+DLB_CONFIGFS_PORT_SHOW(port_id)
+DLB_CONFIGFS_PORT_SHOW(is_ldb)
+DLB_CONFIGFS_PORT_SHOW(cq_depth)
+DLB_CONFIGFS_PORT_SHOW(cq_depth_threshold)
+DLB_CONFIGFS_PORT_SHOW(cq_history_list_size)
+DLB_CONFIGFS_PORT_SHOW(create)
+DLB_CONFIGFS_PORT_SHOW(queue_id)
+
+DLB_CONFIGFS_PORT_STORE(is_ldb)
+DLB_CONFIGFS_PORT_STORE(cq_depth)
+DLB_CONFIGFS_PORT_STORE(cq_depth_threshold)
+DLB_CONFIGFS_PORT_STORE(cq_history_list_size)
+DLB_CONFIGFS_PORT_STORE(queue_id)
+
+static ssize_t dlb_cfs_port_create_store(struct config_item *item,
+					 const char *page, size_t count)
+{
+	struct dlb_cfs_port *dlb_cfs_port = to_dlb_cfs_port(item);
+	struct dlb_domain *dlb_domain;
+	struct dlb *dlb = NULL;
+	int ret;
+
+	ret = dlb_configfs_get_dlb_domain(dlb_cfs_port->domain_grp,
+					  &dlb, &dlb_domain);
+	if (ret)
+		return ret;
+
+	ret = kstrtoint(page, 10, &dlb_cfs_port->create);
+	if (ret)
+		return ret;
+
+	if (dlb_cfs_port->create == 0)
+		return count;
+
+	if (dlb_cfs_port->is_ldb) {
+		struct dlb_create_ldb_port_args args = {0};
+
+		args.cq_depth = dlb_cfs_port->cq_depth;
+		args.cq_depth_threshold = dlb_cfs_port->cq_depth_threshold;
+		args.cq_history_list_size = dlb_cfs_port->cq_history_list_size;
+
+		dev_dbg(dlb->dev,
+			"Creating ldb port: %s\n",
+			dlb_cfs_port->group.cg_item.ci_namebuf);
+
+		ret = dlb_domain_configfs_create_ldb_port(dlb, dlb_domain, &args);
+
+		dlb_cfs_port->status = args.response.status;
+		dlb_cfs_port->port_id = args.response.id;
+	} else {
+		struct dlb_create_dir_port_args args = {0};
+
+		args.queue_id = dlb_cfs_port->queue_id;
+		args.cq_depth = dlb_cfs_port->cq_depth;
+		args.cq_depth_threshold = dlb_cfs_port->cq_depth_threshold;
+
+		dev_dbg(dlb->dev,
+			"Creating dir port: %s\n",
+			dlb_cfs_port->group.cg_item.ci_namebuf);
+
+		ret = dlb_domain_configfs_create_dir_port(dlb, dlb_domain, &args);
+
+		dlb_cfs_port->status = args.response.status;
+		dlb_cfs_port->port_id = args.response.id;
+	}
+
+	if (ret) {
+		dev_err(dlb->dev,
+			"creat port %s failed: ret=%d\n",
+			dlb_cfs_port->group.cg_item.ci_namebuf, ret);
+		return ret;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR_RO(dlb_cfs_port_, status);
+CONFIGFS_ATTR_RO(dlb_cfs_port_, port_id);
+CONFIGFS_ATTR(dlb_cfs_port_, is_ldb);
+CONFIGFS_ATTR(dlb_cfs_port_, cq_depth);
+CONFIGFS_ATTR(dlb_cfs_port_, cq_depth_threshold);
+CONFIGFS_ATTR(dlb_cfs_port_, cq_history_list_size);
+CONFIGFS_ATTR(dlb_cfs_port_, create);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_id);
+
+static struct configfs_attribute *dlb_cfs_port_attrs[] = {
+	&dlb_cfs_port_attr_status,
+	&dlb_cfs_port_attr_port_id,
+	&dlb_cfs_port_attr_is_ldb,
+	&dlb_cfs_port_attr_cq_depth,
+	&dlb_cfs_port_attr_cq_depth_threshold,
+	&dlb_cfs_port_attr_cq_history_list_size,
+	&dlb_cfs_port_attr_create,
+	&dlb_cfs_port_attr_queue_id,
+
+	NULL,
+};
+
+static void dlb_cfs_port_release(struct config_item *item)
+{
+	kfree(to_dlb_cfs_port(item));
+}
+
+static struct configfs_item_operations dlb_cfs_port_item_ops = {
+	.release	= dlb_cfs_port_release,
+};
+
+/*
+ * Note that, since no extra work is required on ->drop_item(),
+ * no ->drop_item() is provided.
+ */
+static const struct config_item_type dlb_cfs_port_type = {
+	.ct_item_ops	= &dlb_cfs_port_item_ops,
+	.ct_attrs	= dlb_cfs_port_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
 /*
  * ------ Configfs for dlb domains---------
  *
@@ -474,7 +751,23 @@ static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
 static struct config_group *dlb_cfs_domain_make_queue_port(struct config_group *group,
 							   const char *name)
 {
-	if (strstr(name, "queue")) {
+	if (strstr(name, "port")) {
+		struct dlb_cfs_port *dlb_cfs_port;
+
+		dlb_cfs_port = kzalloc(sizeof(*dlb_cfs_port), GFP_KERNEL);
+		if (!dlb_cfs_port)
+			return ERR_PTR(-ENOMEM);
+
+		dlb_cfs_port->domain_grp = group;
+
+		config_group_init_type_name(&dlb_cfs_port->group, name,
+					    &dlb_cfs_port_type);
+
+		dlb_cfs_port->queue_id = 0xffffffff;
+		dlb_cfs_port->port_id = 0xffffffff;
+
+		return &dlb_cfs_port->group;
+	} else if (strstr(name, "queue")) {
 		struct dlb_cfs_queue *dlb_cfs_queue;
 
 		dlb_cfs_queue = kzalloc(sizeof(*dlb_cfs_queue), GFP_KERNEL);
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
index e70b40560742..06f4f93d4139 100644
--- a/drivers/misc/dlb/dlb_configfs.h
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -51,6 +51,23 @@ struct dlb_cfs_queue {
 
 };
 
+struct dlb_cfs_port {
+	struct config_group group;
+	struct config_group *domain_grp;
+	unsigned int status;
+	unsigned int port_id;
+	/* Input parameters */
+	unsigned int is_ldb;
+	unsigned int cq_depth;
+	unsigned int cq_depth_threshold;
+	unsigned int cq_history_list_size;
+	unsigned int create;
+
+	/* For DIR port only, default = 0xffffffff */
+	unsigned int queue_id;
+
+};
+
 static inline
 struct dlb_cfs_queue *to_dlb_cfs_queue(struct config_item *item)
 {
@@ -58,6 +75,13 @@ struct dlb_cfs_queue *to_dlb_cfs_queue(struct config_item *item)
 			    struct dlb_cfs_queue, group);
 }
 
+static inline
+struct dlb_cfs_port *to_dlb_cfs_port(struct config_item *item)
+{
+	return container_of(to_config_group(item),
+			    struct dlb_cfs_port, group);
+}
+
 static inline
 struct dlb_cfs_domain *to_dlb_cfs_domain(struct config_item *item)
 {
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 4b263e849061..9e6168b27859 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -125,12 +125,56 @@ int dlb_init_domain(struct dlb *dlb, u32 domain_id)
 	return 0;
 }
 
+static void dlb_release_port_memory(struct dlb *dlb,
+				    struct dlb_port *port,
+				    bool check_domain,
+				    u32 domain_id)
+{
+	if (port->valid &&
+	    (!check_domain || port->domain->id == domain_id))
+		dma_free_coherent(&dlb->pdev->dev,
+				  DLB_CQ_SIZE,
+				  port->cq_base,
+				  port->cq_dma_base);
+
+	port->valid = false;
+}
+
+static void dlb_release_domain_memory(struct dlb *dlb,
+				      bool check_domain,
+				      u32 domain_id)
+{
+	struct dlb_port *port;
+	int i;
+
+	for (i = 0; i < DLB_MAX_NUM_LDB_PORTS; i++) {
+		port = &dlb->ldb_port[i];
+
+		dlb_release_port_memory(dlb, port, check_domain, domain_id);
+	}
+
+	for (i = 0; i < DLB_MAX_NUM_DIR_PORTS; i++) {
+		port = &dlb->dir_port[i];
+
+		dlb_release_port_memory(dlb, port, check_domain, domain_id);
+	}
+}
+
+static void dlb_release_device_memory(struct dlb *dlb)
+{
+	dlb_release_domain_memory(dlb, false, 0);
+}
+
 static int __dlb_free_domain(struct dlb_domain *domain)
 {
 	struct dlb *dlb = domain->dlb;
 	int ret;
 
 	ret = dlb_reset_domain(&dlb->hw, domain->id);
+
+	/* Unpin and free all memory pages associated with the domain */
+	dlb_release_domain_memory(dlb, true, domain->id);
+
 	if (ret) {
 		dlb->domain_reset_failed = true;
 		dev_err(dlb->dev,
@@ -271,6 +315,8 @@ static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	if (ret)
 		goto init_driver_state_fail;
 
+	dlb_pf_init_hardware(dlb);
+
 	/*
 	 * Undo the 'get' operation by the PCI layer during probe and
 	 * (if PF) immediately suspend the device. Since the device is only
@@ -308,6 +354,8 @@ static void dlb_remove(struct pci_dev *pdev)
 
 	dlb_resource_free(&dlb->hw);
 
+	dlb_release_device_memory(dlb);
+
 	device_destroy(dlb_class, dlb->dev_number);
 
 	pci_disable_pcie_error_reporting(pdev);
@@ -321,6 +369,9 @@ static void dlb_remove(struct pci_dev *pdev)
 static void dlb_reset_hardware_state(struct dlb *dlb)
 {
 	dlb_reset_device(dlb->pdev);
+
+	/* Reinitialize any other hardware state */
+	dlb_pf_init_hardware(dlb);
 }
 
 static int dlb_runtime_suspend(struct device *dev)
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 3bd2d9ee0a44..fbfbc6e3fc87 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -329,9 +329,19 @@ void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev);
 int dlb_pf_init_driver_state(struct dlb *dlb);
 void dlb_pf_enable_pm(struct dlb *dlb);
 int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev);
+void dlb_pf_init_hardware(struct dlb *dlb);
 
 extern const struct file_operations dlb_domain_fops;
 
+struct dlb_port {
+	void *cq_base;
+	dma_addr_t cq_dma_base;
+	struct dlb_domain *domain;
+	int id;
+	u8 is_ldb;
+	u8 valid;
+};
+
 struct dlb_domain {
 	struct dlb *dlb;
 	struct kref refcnt;
@@ -344,6 +354,8 @@ struct dlb {
 	struct device *dev;
 	struct dlb_domain *sched_domains[DLB_MAX_NUM_DOMAINS];
 	struct file *f;
+	struct dlb_port ldb_port[DLB_MAX_NUM_LDB_PORTS];
+	struct dlb_port dir_port[DLB_MAX_NUM_DIR_PORTS];
 	/*
 	 * The resource mutex serializes access to driver data structures and
 	 * hardware registers.
@@ -576,6 +588,14 @@ int dlb_hw_create_ldb_queue(struct dlb_hw *hw, u32 domain_id,
 int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
 			    struct dlb_create_dir_queue_args *args,
 			    struct dlb_cmd_response *resp);
+int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
+			   struct dlb_create_dir_port_args *args,
+			   uintptr_t cq_dma_base,
+			   struct dlb_cmd_response *resp);
+int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
+			   struct dlb_create_ldb_port_args *args,
+			   uintptr_t cq_dma_base,
+			   struct dlb_cmd_response *resp);
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
@@ -584,6 +604,8 @@ int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
 int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 			       struct dlb_get_dir_queue_depth_args *args,
 			       struct dlb_cmd_response *resp);
+void dlb_hw_enable_sparse_ldb_cq_mode(struct dlb_hw *hw);
+void dlb_hw_enable_sparse_dir_cq_mode(struct dlb_hw *hw);
 
 /* Prototypes for dlb_configfs.c */
 int dlb_configfs_create_device(struct dlb *dlb);
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index 65213c0475e5..66fb4ffae939 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -95,3 +95,10 @@ int dlb_pf_wait_for_device_ready(struct dlb *dlb, struct pci_dev *pdev)
 
 	return 0;
 }
+
+void dlb_pf_init_hardware(struct dlb *dlb)
+{
+	/* Use sparse mode as default */
+	dlb_hw_enable_sparse_ldb_cq_mode(&dlb->hw);
+	dlb_hw_enable_sparse_dir_cq_mode(&dlb->hw);
+}
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 83c000839f15..3521ae2ca76b 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -884,6 +884,163 @@ static void dlb_configure_dir_queue(struct dlb_hw *hw,
 	queue->queue_configured = true;
 }
 
+static bool
+dlb_cq_depth_is_valid(u32 depth)
+{
+	/* Valid values for depth are
+	 * 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, and 1024.
+	 */
+	if (!is_power_of_2(depth) || depth > 1024)
+		return false;
+
+	return true;
+}
+
+static int
+dlb_verify_create_ldb_port_args(struct dlb_hw *hw, u32 domain_id,
+				uintptr_t cq_dma_base,
+				struct dlb_create_ldb_port_args *args,
+				struct dlb_cmd_response *resp,
+				struct dlb_hw_domain **out_domain,
+				struct dlb_ldb_port **out_port, int *out_cos_id)
+{
+	struct dlb_ldb_port *port = NULL;
+	struct dlb_hw_domain *domain;
+	int i, id;
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	if (!domain->configured) {
+		resp->status = DLB_ST_DOMAIN_NOT_CONFIGURED;
+		return -EINVAL;
+	}
+
+	if (domain->started) {
+		resp->status = DLB_ST_DOMAIN_STARTED;
+		return -EINVAL;
+	}
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		id = i % DLB_NUM_COS_DOMAINS;
+
+		port = list_first_entry_or_null(&domain->avail_ldb_ports[id],
+						typeof(*port), domain_list);
+		if (port)
+			break;
+	}
+
+	if (!port) {
+		resp->status = DLB_ST_LDB_PORTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	/* DLB requires 64B alignment */
+	if (!IS_ALIGNED(cq_dma_base, 64)) {
+		resp->status = DLB_ST_INVALID_CQ_VIRT_ADDR;
+		return -EINVAL;
+	}
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		resp->status = DLB_ST_INVALID_CQ_DEPTH;
+		return -EINVAL;
+	}
+
+	/* The history list size must be >= 1 */
+	if (!args->cq_history_list_size) {
+		resp->status = DLB_ST_INVALID_HIST_LIST_DEPTH;
+		return -EINVAL;
+	}
+
+	if (args->cq_history_list_size > domain->avail_hist_list_entries) {
+		resp->status = DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_port = port;
+	*out_cos_id = id;
+
+	return 0;
+}
+
+static int
+dlb_verify_create_dir_port_args(struct dlb_hw *hw, u32 domain_id,
+				uintptr_t cq_dma_base,
+				struct dlb_create_dir_port_args *args,
+				struct dlb_cmd_response *resp,
+				struct dlb_hw_domain **out_domain,
+				struct dlb_dir_pq_pair **out_port)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_dir_pq_pair *pq;
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	if (!domain->configured) {
+		resp->status = DLB_ST_DOMAIN_NOT_CONFIGURED;
+		return -EINVAL;
+	}
+
+	if (domain->started) {
+		resp->status = DLB_ST_DOMAIN_STARTED;
+		return -EINVAL;
+	}
+
+	if (args->queue_id != -1) {
+		/*
+		 * If the user claims the queue is already configured, validate
+		 * the queue ID, its domain, and whether the queue is
+		 * configured.
+		 */
+		pq = dlb_get_domain_used_dir_pq(args->queue_id,
+						false,
+						domain);
+
+		if (!pq || pq->domain_id != domain->id ||
+		    !pq->queue_configured) {
+			resp->status = DLB_ST_INVALID_DIR_QUEUE_ID;
+			return -EINVAL;
+		}
+	} else {
+		/*
+		 * If the port's queue is not configured, validate that a free
+		 * port-queue pair is available.
+		 */
+		pq = list_first_entry_or_null(&domain->avail_dir_pq_pairs,
+					      typeof(*pq), domain_list);
+		if (!pq) {
+			resp->status = DLB_ST_DIR_PORTS_UNAVAILABLE;
+			return -EINVAL;
+		}
+	}
+
+	/* DLB requires 64B alignment */
+	if (!IS_ALIGNED(cq_dma_base, 64)) {
+		resp->status = DLB_ST_INVALID_CQ_VIRT_ADDR;
+		return -EINVAL;
+	}
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		resp->status = DLB_ST_INVALID_CQ_DEPTH;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_port = pq;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -1287,6 +1444,146 @@ int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void
+dlb_log_create_ldb_port_args(struct dlb_hw *hw, u32 domain_id,
+			     uintptr_t cq_dma_base,
+			     struct dlb_create_ldb_port_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB create load-balanced port arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID:                 %d\n",
+		domain_id);
+	dev_dbg(hw_to_dev(hw), "\tCQ depth:                  %d\n",
+		args->cq_depth);
+	dev_dbg(hw_to_dev(hw), "\tCQ hist list size:         %d\n",
+		args->cq_history_list_size);
+	dev_dbg(hw_to_dev(hw), "\tCQ base address:           0x%lx\n",
+		cq_dma_base);
+}
+
+/**
+ * dlb_hw_create_ldb_port() - create a load-balanced port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: port creation arguments.
+ * @cq_dma_base: base address of the CQ memory. This can be a PA or an IOVA.
+ * @resp: response structure.
+ *
+ * This function creates a load-balanced port.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the port ID.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, a credit setting is invalid, a
+ *	    pointer address is not properly aligned, the domain is not
+ *	    configured, or the domain has already been started.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
+			   struct dlb_create_ldb_port_args *args,
+			   uintptr_t cq_dma_base,
+			   struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_port *port;
+	int ret, cos_id;
+
+	dlb_log_create_ldb_port_args(hw, domain_id, cq_dma_base,
+				     args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_create_ldb_port_args(hw, domain_id, cq_dma_base, args,
+					      resp, &domain,
+					      &port, &cos_id);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configuration succeeded, so move the resource from the 'avail' to
+	 * the 'used' list.
+	 */
+	list_move(&port->domain_list, &domain->used_ldb_ports[cos_id]);
+
+	resp->status = 0;
+	resp->id = port->id;
+
+	return 0;
+}
+
+static void
+dlb_log_create_dir_port_args(struct dlb_hw *hw,
+			     u32 domain_id, uintptr_t cq_dma_base,
+			     struct dlb_create_dir_port_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB create directed port arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID:                 %d\n",
+		domain_id);
+	dev_dbg(hw_to_dev(hw), "\tCQ depth:                  %d\n",
+		args->cq_depth);
+	dev_dbg(hw_to_dev(hw), "\tCQ base address:           0x%lx\n",
+		cq_dma_base);
+}
+
+/**
+ * dlb_hw_create_dir_port() - create a directed port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: port creation arguments.
+ * @cq_dma_base: base address of the CQ memory. This can be a PA or an IOVA.
+ * @resp: response structure.
+ *
+ * This function creates a directed port.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the port ID.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, a credit setting is invalid, a
+ *	    pointer address is not properly aligned, the domain is not
+ *	    configured, or the domain has already been started.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
+			   struct dlb_create_dir_port_args *args,
+			   uintptr_t cq_dma_base,
+			   struct dlb_cmd_response *resp)
+{
+	struct dlb_dir_pq_pair *port;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	dlb_log_create_dir_port_args(hw, domain_id, cq_dma_base, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_create_dir_port_args(hw, domain_id, cq_dma_base,
+					      args, resp,
+					      &domain, &port);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configuration succeeded, so move the resource from the 'avail' to
+	 * the 'used' list (if it's not already there).
+	 */
+	if (args->queue_id == -1)
+		list_move(&port->domain_list, &domain->used_dir_pq_pairs);
+
+	resp->status = 0;
+	resp->id = port->id;
+
+	return 0;
+}
+
 static u32 dlb_ldb_cq_inflight_count(struct dlb_hw *hw,
 				     struct dlb_ldb_port *port)
 {
@@ -2400,6 +2697,15 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 
 	dlb_domain_disable_ldb_queue_write_perms(hw, domain);
 
+	/*
+	 * Disable the LDB CQs and drain them in order to complete the map and
+	 * unmap procedures, which require zero CQ inflights and zero QID
+	 * inflights respectively.
+	 */
+	dlb_domain_disable_ldb_cqs(hw, domain);
+
+	dlb_domain_drain_ldb_cqs(hw, domain, false);
+
 	/* Re-enable the CQs in order to drain the mapped queues. */
 	dlb_domain_enable_ldb_cqs(hw, domain);
 
@@ -2443,3 +2749,38 @@ void dlb_clr_pmcsr_disable(struct dlb_hw *hw)
 
 	DLB_CSR_WR(hw, CM_CFG_PM_PMCSR_DISABLE, pmcsr_dis);
 }
+
+/**
+ * dlb_hw_enable_sparse_ldb_cq_mode() - enable sparse mode for load-balanced
+ *      ports.
+ * @hw: dlb_hw handle for a particular device.
+ *
+ * This function must be called prior to configuring scheduling domains.
+ */
+void dlb_hw_enable_sparse_ldb_cq_mode(struct dlb_hw *hw)
+{
+	u32 ctrl;
+
+	ctrl = DLB_CSR_RD(hw, CHP_CFG_CHP_CSR_CTRL);
+
+	ctrl |= CHP_CFG_CHP_CSR_CTRL_CFG_64BYTES_QE_LDB_CQ_MODE;
+
+	DLB_CSR_WR(hw, CHP_CFG_CHP_CSR_CTRL, ctrl);
+}
+
+/**
+ * dlb_hw_enable_sparse_dir_cq_mode() - enable sparse mode for directed ports.
+ * @hw: dlb_hw handle for a particular device.
+ *
+ * This function must be called prior to configuring scheduling domains.
+ */
+void dlb_hw_enable_sparse_dir_cq_mode(struct dlb_hw *hw)
+{
+	u32 ctrl;
+
+	ctrl = DLB_CSR_RD(hw, CHP_CFG_CHP_CSR_CTRL);
+
+	ctrl |= CHP_CFG_CHP_CSR_CTRL_CFG_64BYTES_QE_DIR_CQ_MODE;
+
+	DLB_CSR_WR(hw, CHP_CFG_CHP_CSR_CTRL, ctrl);
+}
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 3586afbccdbf..e8a629f2d10b 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -28,5 +28,11 @@ enum dlb_error {
 	DLB_ST_DIR_QUEUES_UNAVAILABLE,
 	DLB_ST_INVALID_PORT_ID,
 	DLB_ST_INVALID_LOCK_ID_COMP_LEVEL,
+	DLB_ST_NO_MEMORY,
+	DLB_ST_INVALID_COS_ID,
+	DLB_ST_INVALID_CQ_VIRT_ADDR,
+	DLB_ST_INVALID_CQ_DEPTH,
+	DLB_ST_INVALID_HIST_LIST_DEPTH,
+	DLB_ST_INVALID_DIR_QUEUE_ID,
 };
 #endif /* __DLB_H */
-- 
2.27.0

