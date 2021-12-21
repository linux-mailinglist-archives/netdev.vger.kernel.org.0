Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D218347BA48
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhLUGvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:29910 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhLUGvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069503; x=1671605503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cH8ImR6Xy7UR4WcxJWNL2L6hJoGFrhT5iMhaSKpaui4=;
  b=jqKM0YsL94brcR6M8lFaYFezqAySZ1HqGEoePQWbv6g8mtM0+Lkg4xG0
   dz+zBb5CD7TdUn+HP3/4BC31tEKBBd2c9wb7SjwEa0kchGzsR1Sx0OpgQ
   4IN3AE2PDKyF11bUDyQnpnBCbvGXFXtynPVI2mOKCHpuPgGRCD/vaiEfQ
   Glar+MxoY+mI95C2hIvpyJye2dnL4qDD6Tt11vFrgDqF9kFgajX/dNESs
   ye92jqLt3yTUMEtUjIIutY04eWSzGQAjd7Lnrzs0dp6gL8R4Dc/OXJfGP
   jsQwE+3gHq59X2MOEvnxezajzPaK6k2fmbCMOdP+EEUXk6Y4jHBEtiyxT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107541"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107541"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119111"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:40 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 15/17] dlb: add queue map, unmap, and pending unmap
Date:   Tue, 21 Dec 2021 00:50:45 -0600
Message-Id: <20211221065047.290182-16-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the high-level code for queue map, unmap, and pending unmap query
configfs interface and argument verification -- with stubs for the
low-level register accesses and the queue map/unmap state machine, to be
filled in a later commit.

The queue map/unmap in this commit refers to link/unlink between DLB's
load-balanced queues (internal) and consumer ports.See Documentation/
misc-devices/dlb.rst for details.

Load-balanced queues can be "mapped" to any number of load-balanced ports.
Once mapped, the port becomes a candidate to which the device can schedule
queue entries from the queue. If a port is unmapped from a queue, it is no
longer a candidate for scheduling from that queue.

The pending unmaps function queries how many unmap operations are
in-progress for a given port. These operations are asynchronous, so
multiple may be in-flight at any given time.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_args.h     |  63 ++++++
 drivers/misc/dlb/dlb_configfs.c | 101 ++++++++++
 drivers/misc/dlb/dlb_configfs.h |   3 +
 drivers/misc/dlb/dlb_main.h     |   9 +
 drivers/misc/dlb/dlb_resource.c | 330 ++++++++++++++++++++++++++++++++
 include/uapi/linux/dlb.h        |   2 +
 6 files changed, 508 insertions(+)

diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index 7c3e7794efee..eac8890c3a70 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -265,6 +265,69 @@ struct dlb_start_domain_args {
 	struct dlb_cmd_response response;
 };
 
+/*
+ * dlb_map_qid_args: Used to map a load-balanced queue to a load-balanced port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ * @qid: Load-balanced queue ID.
+ * @priority: Queue->port service priority.
+ */
+struct dlb_map_qid_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+	__u32 qid;
+	__u32 priority;
+};
+
+/*
+ * dlb_unmap_qid_args: Used to nnmap a load-balanced queue to a load-balanced
+ *	port.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ * @qid: Load-balanced queue ID.
+ */
+struct dlb_unmap_qid_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+	__u32 qid;
+};
+
+/*
+ * dlb_pending_port_unmaps_args: Used to get number of queue unmap operations in
+ *	progress for a load-balanced port.
+ *
+ *	Note: This is a snapshot; the number of unmap operations in progress
+ *	is subject to change at any time.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: number of unmaps in progress.
+ *
+ * Input parameters:
+ * @port_id: Load-balanced port ID.
+ */
+struct dlb_pending_port_unmaps_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 port_id;
+};
+
 /*
  * Mapping sizes for memory mapping the consumer queue (CQ) memory space, and
  * producer port (PP) MMIO space.
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index 1f7e8a293594..3f279c81fbbb 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -45,6 +45,8 @@ DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_dir_queue_depth)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(start_domain)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(map_qid)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(unmap_qid)
 
 static int dlb_create_port_fd(struct dlb *dlb,
 			      const char *prefix,
@@ -611,6 +613,15 @@ end:									\
 	return sprintf(page, "%u\n", to_dlb_cfs_port(item)->name);	\
 }									\
 
+#define DLB_CONFIGFS_PORT_LINK_SHOW(name, port)				\
+static ssize_t dlb_cfs_port_##name##_##port##_show(			\
+	struct config_item *item,					\
+	char *page)							\
+{									\
+	return sprintf(page, "Ox%08x\n",				\
+	       to_dlb_cfs_port(item)->name[port]);			\
+}
+
 #define DLB_CONFIGFS_PORT_STORE(name)					\
 static ssize_t dlb_cfs_port_##name##_store(				\
 	struct config_item *item,					\
@@ -643,6 +654,55 @@ static ssize_t dlb_cfs_port_##name##_store(				\
 	return count;							\
 }									\
 
+#define DLB_CONFIGFS_PORT_LINK_STORE(name, port)			\
+static ssize_t dlb_cfs_port_##name##_##port##_store(			\
+	struct config_item *item,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct dlb_cfs_port *dlb_cfs_port = to_dlb_cfs_port(item);	\
+	struct dlb_domain *dlb_domain;					\
+	struct dlb *dlb = NULL;						\
+	int ret;							\
+									\
+	ret = dlb_configfs_get_dlb_domain(dlb_cfs_port->domain_grp,	\
+					  &dlb, &dlb_domain);		\
+	if (ret)							\
+		return ret;						\
+									\
+	ret = kstrtoint(page, 16, &dlb_cfs_port->name[port]);		\
+	if (ret)							\
+		return ret;						\
+									\
+	if (dlb_cfs_port->name[port] & 0x10000) {			\
+		struct dlb_map_qid_args args;				\
+									\
+		args.port_id = dlb_cfs_port->port_id;			\
+		args.qid = dlb_cfs_port->name[port] & 0xff;		\
+		args.priority = (dlb_cfs_port->name[port] >> 8) & 0xff;	\
+									\
+		ret = dlb_domain_configfs_map_qid(dlb, dlb_domain,	\
+						  &args);		\
+									\
+		dlb_cfs_port->status = args.response.status;		\
+	} else {							\
+		struct dlb_unmap_qid_args args;				\
+									\
+		args.port_id = dlb_cfs_port->port_id;			\
+		args.qid = dlb_cfs_port->name[port] & 0xff;		\
+									\
+		ret = dlb_domain_configfs_unmap_qid(dlb, dlb_domain,	\
+						    &args);		\
+									\
+		dlb_cfs_port->status = args.response.status;		\
+	}								\
+									\
+	if (ret)							\
+		return ret;						\
+									\
+	return count;							\
+}
+
 DLB_CONFIGFS_PORT_SHOW_FD(pp_fd)
 DLB_CONFIGFS_PORT_SHOW_FD(cq_fd)
 DLB_CONFIGFS_PORT_SHOW(status)
@@ -652,12 +712,28 @@ DLB_CONFIGFS_PORT_SHOW(cq_depth)
 DLB_CONFIGFS_PORT_SHOW(cq_depth_threshold)
 DLB_CONFIGFS_PORT_SHOW(cq_history_list_size)
 DLB_CONFIGFS_PORT_SHOW(create)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 0)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 1)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 2)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 3)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 4)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 5)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 6)
+DLB_CONFIGFS_PORT_LINK_SHOW(queue_link, 7)
 DLB_CONFIGFS_PORT_SHOW(queue_id)
 
 DLB_CONFIGFS_PORT_STORE(is_ldb)
 DLB_CONFIGFS_PORT_STORE(cq_depth)
 DLB_CONFIGFS_PORT_STORE(cq_depth_threshold)
 DLB_CONFIGFS_PORT_STORE(cq_history_list_size)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 0)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 1)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 2)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 3)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 4)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 5)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 6)
+DLB_CONFIGFS_PORT_LINK_STORE(queue_link, 7)
 DLB_CONFIGFS_PORT_STORE(queue_id)
 
 static ssize_t dlb_cfs_port_create_store(struct config_item *item,
@@ -682,6 +758,7 @@ static ssize_t dlb_cfs_port_create_store(struct config_item *item,
 
 	if (dlb_cfs_port->is_ldb) {
 		struct dlb_create_ldb_port_args args = {0};
+		int i;
 
 		args.cq_depth = dlb_cfs_port->cq_depth;
 		args.cq_depth_threshold = dlb_cfs_port->cq_depth_threshold;
@@ -695,6 +772,10 @@ static ssize_t dlb_cfs_port_create_store(struct config_item *item,
 
 		dlb_cfs_port->status = args.response.status;
 		dlb_cfs_port->port_id = args.response.id;
+
+		/* reset the links */
+		for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++)
+			dlb_cfs_port->queue_link[i] = 0x1ffff;
 	} else {
 		struct dlb_create_dir_port_args args = {0};
 
@@ -734,6 +815,14 @@ CONFIGFS_ATTR(dlb_cfs_port_, cq_depth);
 CONFIGFS_ATTR(dlb_cfs_port_, cq_depth_threshold);
 CONFIGFS_ATTR(dlb_cfs_port_, cq_history_list_size);
 CONFIGFS_ATTR(dlb_cfs_port_, create);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_0);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_1);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_2);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_3);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_4);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_5);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_6);
+CONFIGFS_ATTR(dlb_cfs_port_, queue_link_7);
 CONFIGFS_ATTR(dlb_cfs_port_, queue_id);
 
 static struct configfs_attribute *dlb_cfs_port_attrs[] = {
@@ -746,6 +835,14 @@ static struct configfs_attribute *dlb_cfs_port_attrs[] = {
 	&dlb_cfs_port_attr_cq_depth_threshold,
 	&dlb_cfs_port_attr_cq_history_list_size,
 	&dlb_cfs_port_attr_create,
+	&dlb_cfs_port_attr_queue_link_0,
+	&dlb_cfs_port_attr_queue_link_1,
+	&dlb_cfs_port_attr_queue_link_2,
+	&dlb_cfs_port_attr_queue_link_3,
+	&dlb_cfs_port_attr_queue_link_4,
+	&dlb_cfs_port_attr_queue_link_5,
+	&dlb_cfs_port_attr_queue_link_6,
+	&dlb_cfs_port_attr_queue_link_7,
 	&dlb_cfs_port_attr_queue_id,
 
 	NULL,
@@ -957,6 +1054,7 @@ static struct config_group *dlb_cfs_domain_make_queue_port(struct config_group *
 {
 	if (strstr(name, "port")) {
 		struct dlb_cfs_port *dlb_cfs_port;
+		int i;
 
 		dlb_cfs_port = kzalloc(sizeof(*dlb_cfs_port), GFP_KERNEL);
 		if (!dlb_cfs_port)
@@ -967,6 +1065,9 @@ static struct config_group *dlb_cfs_domain_make_queue_port(struct config_group *
 		config_group_init_type_name(&dlb_cfs_port->group, name,
 					    &dlb_cfs_port_type);
 
+		for (i = 0; i < 8; i++)
+			dlb_cfs_port->queue_link[i] = 0xffffffff;
+
 		dlb_cfs_port->queue_id = 0xffffffff;
 		dlb_cfs_port->port_id = 0xffffffff;
 
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
index 2503d0242399..91cc7d829f9a 100644
--- a/drivers/misc/dlb/dlb_configfs.h
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -68,6 +68,9 @@ struct dlb_cfs_port {
 	unsigned int cq_history_list_size;
 	unsigned int create;
 
+	/* For LDB port only */
+	unsigned int queue_link[DLB_MAX_NUM_QIDS_PER_LDB_CQ];
+
 	/* For DIR port only, default = 0xffffffff */
 	unsigned int queue_id;
 
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index bff006e2dc8d..f410e7307c12 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -616,6 +616,12 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 			   struct dlb_cmd_response *resp);
 int dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
 			struct dlb_cmd_response *resp);
+int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
+		   struct dlb_map_qid_args *args,
+		   struct dlb_cmd_response *resp);
+int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+		     struct dlb_unmap_qid_args *args,
+		     struct dlb_cmd_response *resp);
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 int dlb_ldb_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
 int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
@@ -626,6 +632,9 @@ int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
 int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 			       struct dlb_get_dir_queue_depth_args *args,
 			       struct dlb_cmd_response *resp);
+int dlb_hw_pending_port_unmaps(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_pending_port_unmaps_args *args,
+			       struct dlb_cmd_response *resp);
 void dlb_hw_enable_sparse_ldb_cq_mode(struct dlb_hw *hw);
 void dlb_hw_enable_sparse_dir_cq_mode(struct dlb_hw *hw);
 
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 9e38fa850e5c..5d4ffdab69b5 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -210,6 +210,30 @@ static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id)
 	return &hw->domains[id];
 }
 
+static struct dlb_ldb_port *
+dlb_get_domain_used_ldb_port(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	if (id >= DLB_MAX_NUM_LDB_PORTS)
+		return NULL;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			if (!vdev_req && port->id == id)
+				return port;
+		}
+
+		list_for_each_entry(port, &domain->avail_ldb_ports[i], domain_list) {
+			if (!vdev_req && port->id == id)
+				return port;
+		}
+	}
+
+	return NULL;
+}
+
 static struct dlb_ldb_port *
 dlb_get_domain_ldb_port(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 {
@@ -1114,6 +1138,122 @@ static int dlb_verify_start_domain_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static int dlb_verify_map_qid_args(struct dlb_hw *hw, u32 domain_id,
+				   struct dlb_map_qid_args *args,
+				   struct dlb_cmd_response *resp,
+				   struct dlb_hw_domain **out_domain,
+				   struct dlb_ldb_port **out_port,
+				   struct dlb_ldb_queue **out_queue)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int id;
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
+	id = args->port_id;
+
+	port = dlb_get_domain_used_ldb_port(id, false, domain);
+
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	if (args->priority >= DLB_QID_PRIORITIES) {
+		resp->status = DLB_ST_INVALID_PRIORITY;
+		return -EINVAL;
+	}
+
+	queue = dlb_get_domain_ldb_queue(args->qid, false, domain);
+
+	if (!queue || !queue->configured) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	if (queue->domain_id != domain->id) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	if (port->domain_id != domain->id) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_queue = queue;
+	*out_port = port;
+
+	return 0;
+}
+
+static int dlb_verify_unmap_qid_args(struct dlb_hw *hw, u32 domain_id,
+				     struct dlb_unmap_qid_args *args,
+				     struct dlb_cmd_response *resp,
+				     struct dlb_hw_domain **out_domain,
+				     struct dlb_ldb_port **out_port,
+				     struct dlb_ldb_queue **out_queue)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int id;
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
+	id = args->port_id;
+
+	port = dlb_get_domain_used_ldb_port(id, false, domain);
+
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	if (port->domain_id != domain->id) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	queue = dlb_get_domain_ldb_queue(args->qid, false, domain);
+
+	if (!queue || !queue->configured) {
+		dev_err(hw_to_dev(hw), "[%s()] Can't unmap unconfigured queue %d\n",
+			__func__, args->qid);
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_port = port;
+	*out_queue = queue;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -1957,6 +2097,145 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void dlb_log_map_qid(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_map_qid_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB map QID arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n",
+		domain_id);
+	dev_dbg(hw_to_dev(hw), "\tPort ID:   %d\n",
+		args->port_id);
+	dev_dbg(hw_to_dev(hw), "\tQueue ID:  %d\n",
+		args->qid);
+	dev_dbg(hw_to_dev(hw), "\tPriority:  %d\n",
+		args->priority);
+}
+
+/**
+ * dlb_hw_map_qid() - map a load-balanced queue to a load-balanced port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: map QID arguments.
+ * @resp: response structure.
+ *
+ * This function configures the DLB to schedule QEs from the specified queue
+ * to the specified port. Each load-balanced port can be mapped to up to 8
+ * queues; each load-balanced queue can potentially map to all the
+ * load-balanced ports.
+ *
+ * A successful return does not necessarily mean the mapping was configured. If
+ * this function is unable to immediately map the queue to the port, it will
+ * add the requested operation to a per-port list of pending map/unmap
+ * operations, and (if it's not already running) launch a kernel thread that
+ * periodically attempts to process all pending operations. In a sense, this is
+ * an asynchronous function.
+ *
+ * This asynchronicity creates two views of the state of hardware: the actual
+ * hardware state and the requested state (as if every request completed
+ * immediately). If there are any pending map/unmap operations, the requested
+ * state will differ from the actual state. All validation is performed with
+ * respect to the pending state; for instance, if there are 8 pending map
+ * operations for port X, a request for a 9th will fail because a load-balanced
+ * port can only map up to 8 queues.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, invalid port or queue ID, or
+ *	    the domain is not configured.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
+		   struct dlb_map_qid_args *args,
+		   struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int ret;
+
+	dlb_log_map_qid(hw, domain_id, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_map_qid_args(hw, domain_id, args, resp,
+				      &domain, &port, &queue);
+	if (ret)
+		return ret;
+
+	resp->status = 0;
+
+	return 0;
+}
+
+static void dlb_log_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+			      struct dlb_unmap_qid_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB unmap QID arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n",
+		domain_id);
+	dev_dbg(hw_to_dev(hw), "\tPort ID:   %d\n",
+		args->port_id);
+	dev_dbg(hw_to_dev(hw), "\tQueue ID:  %d\n",
+		args->qid);
+	if (args->qid < DLB_MAX_NUM_LDB_QUEUES)
+		dev_dbg(hw_to_dev(hw), "\tQueue's num mappings:  %d\n",
+			hw->rsrcs.ldb_queues[args->qid].num_mappings);
+}
+
+/**
+ * dlb_hw_unmap_qid() - Unmap a load-balanced queue from a load-balanced port
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: unmap QID arguments.
+ * @resp: response structure.
+ *
+ * This function configures the DLB to stop scheduling QEs from the specified
+ * queue to the specified port.
+ *
+ * A successful return does not necessarily mean the mapping was removed. If
+ * this function is unable to immediately unmap the queue from the port, it
+ * will add the requested operation to a per-port list of pending map/unmap
+ * operations, and (if it's not already running) launch a kernel thread that
+ * periodically attempts to process all pending operations. See
+ * dlb_hw_map_qid() for more details.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, invalid port or queue ID, or
+ *	    the domain is not configured.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
+		     struct dlb_unmap_qid_args *args,
+		     struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	struct dlb_ldb_port *port;
+	int ret;
+
+	dlb_log_unmap_qid(hw, domain_id, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_unmap_qid_args(hw, domain_id, args, resp,
+					&domain, &port, &queue);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static u32 dlb_ldb_cq_inflight_count(struct dlb_hw *hw,
 				     struct dlb_ldb_port *port)
 {
@@ -2297,6 +2576,57 @@ int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void
+dlb_log_pending_port_unmaps_args(struct dlb_hw *hw,
+				 struct dlb_pending_port_unmaps_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB unmaps in progress arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tPort ID: %d\n", args->port_id);
+}
+
+/**
+ * dlb_hw_pending_port_unmaps() - returns the number of unmap operations in
+ *	progress.
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: number of unmaps in progress args
+ * @resp: response structure.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the number of unmaps in progress.
+ *
+ * Errors:
+ * EINVAL - Invalid port ID.
+ */
+int dlb_hw_pending_port_unmaps(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_pending_port_unmaps_args *args,
+			       struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_port *port;
+
+	dlb_log_pending_port_unmaps_args(hw, args);
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	port = dlb_get_domain_used_ldb_port(args->port_id, false, domain);
+	if (!port || !port->configured) {
+		resp->status = DLB_ST_INVALID_PORT_ID;
+		return -EINVAL;
+	}
+
+	resp->id = port->num_pending_removals;
+
+	return 0;
+}
+
 static u32 dlb_ldb_queue_depth(struct dlb_hw *hw, struct dlb_ldb_queue *queue)
 {
 	u32 aqed, ldb, atm;
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index e8a629f2d10b..a946f9c5e387 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -34,5 +34,7 @@ enum dlb_error {
 	DLB_ST_INVALID_CQ_DEPTH,
 	DLB_ST_INVALID_HIST_LIST_DEPTH,
 	DLB_ST_INVALID_DIR_QUEUE_ID,
+	DLB_ST_INVALID_PRIORITY,
+	DLB_ST_NO_QID_SLOTS_AVAILABLE,
 };
 #endif /* __DLB_H */
-- 
2.27.0

