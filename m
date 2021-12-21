Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C8947BA3C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhLUGup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234467AbhLUGu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069429; x=1671605429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=50UWZqHnt77nGelCecHhdFhkJu5FJX8XxBK4me+hTpE=;
  b=dnTigmqCNMUTejeVLFVsIJTedOx23mIKCDFmpm18WjvPS5Kr3rcQoeQh
   pudnYfE9LQa/pVw5+Ko8NpWnDAgQWR0I7BmGCKPkQZTRQq/GGCz826gAB
   7IeKiyl0NKvrU1Qzywp/louOFazxd54p17i2UHG8rpnBWnhMBUa7ZOoOd
   XpIQ40+Zik5O/cN1t+O5EYvWK0su/FO9ue2tCST/HDwjaGnbtbC4yKsti
   ygOWXd6uTsBb8hbJQ/NCtNMuuW0XCFyBOAsUzhpEkv2r6NcvFp+fo29LA
   6fhLwTPOtsbnqvwmfownWO8BogiWk4AH1JYsjAtf+I9GbSLqW+4nZG4Zm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107494"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107494"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119057"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:28 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 09/17] dlb: add queue create, reset, get-depth configfs interface
Date:   Tue, 21 Dec 2021 00:50:39 -0600
Message-Id: <20211221065047.290182-10-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configfs interface to create DLB queues and query their depth, and the
corresponding scheduling domain reset code to drain the queues when they
are no longer in use.

When a CPU enqueues a queue entry (QE) to DLB, the QE entry is sent to
a DLB queue. These queues hold queue entries (QEs) that have not yet
been scheduled to a destination port. The queue's depth is the number of
QEs residing in a queue.

Each queue supports multiple priority levels, and while a directed queue
has a 1:1 mapping with a directed port, load-balanced queues can be
configured with a set of load-balanced ports that software desires the
queue's QEs to be scheduled to.

For ease of review, this commit is limited to higher-level code including
the configfs interface, request verification, and debug log messages. All
low level register access/configuration code will be included in a
subsequent commit.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_args.h     | 110 +++++++
 drivers/misc/dlb/dlb_configfs.c | 276 ++++++++++++++++
 drivers/misc/dlb/dlb_configfs.h |  58 ++++
 drivers/misc/dlb/dlb_main.h     |  41 +++
 drivers/misc/dlb/dlb_resource.c | 538 ++++++++++++++++++++++++++++++++
 include/uapi/linux/dlb.h        |   9 +
 6 files changed, 1032 insertions(+)

diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index a7541a6b0ebe..2a1584756e43 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -57,4 +57,114 @@ struct dlb_create_sched_domain_args {
 	__u32 num_ldb_credits;
 	__u32 num_dir_credits;
 };
+
+/*************************************************/
+/* 'domain' level control/access data structures */
+/*************************************************/
+
+/*
+ * dlb_create_ldb_queue_args: Used to configure a load-balanced queue.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: Queue ID.
+ *
+ * Input parameters:
+ * @num_atomic_inflights: This specifies the amount of temporary atomic QE
+ *	storage for this queue. If zero, the queue will not support atomic
+ *	scheduling.
+ * @num_sequence_numbers: This specifies the number of sequence numbers used
+ *	by this queue. If zero, the queue will not support ordered scheduling.
+ *	If non-zero, the queue will not support unordered scheduling.
+ * @num_qid_inflights: The maximum number of QEs that can be inflight
+ *	(scheduled to a CQ but not completed) at any time. If
+ *	num_sequence_numbers is non-zero, num_qid_inflights must be set equal
+ *	to num_sequence_numbers.
+ * @lock_id_comp_level: Lock ID compression level. Specifies the number of
+ *	unique lock IDs the queue should compress down to. Valid compression
+ *	levels: 0, 64, 128, 256, 512, 1k, 2k, 4k, 64k. If lock_id_comp_level is
+ *	0, the queue won't compress its lock IDs.
+ * @depth_threshold: DLB sets two bits in the received QE to indicate the
+ *	depth of the queue relative to the threshold before scheduling the
+ *	QE to a CQ:
+ *	- 2’b11: depth > threshold
+ *	- 2’b10: threshold >= depth > 0.75 * threshold
+ *	- 2’b01: 0.75 * threshold >= depth > 0.5 * threshold
+ *	- 2’b00: depth <= 0.5 * threshold
+ */
+struct dlb_create_ldb_queue_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 num_sequence_numbers;
+	__u32 num_qid_inflights;
+	__u32 num_atomic_inflights;
+	__u32 lock_id_comp_level;
+	__u32 depth_threshold;
+};
+
+/*
+ * dlb_create_dir_queue_args: Used to configure a directed queue.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: Queue ID.
+ *
+ * Input parameters:
+ * @port_id: Port ID. If the corresponding directed port is already created,
+ *	specify its ID here. Else this argument must be 0xFFFFFFFF to indicate
+ *	that the queue is being created before the port.
+ * @depth_threshold: DLB sets two bits in the received QE to indicate the
+ *	depth of the queue relative to the threshold before scheduling the
+ *	QE to a CQ:
+ *	- 2’b11: depth > threshold
+ *	- 2’b10: threshold >= depth > 0.75 * threshold
+ *	- 2’b01: 0.75 * threshold >= depth > 0.5 * threshold
+ *	- 2’b00: depth <= 0.5 * threshold
+ */
+struct dlb_create_dir_queue_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__s32 port_id;
+	__u32 depth_threshold;
+};
+
+/*
+ * dlb_get_ldb_queue_depth_args: Used to get a load-balanced queue's depth.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: queue depth.
+ *
+ * Input parameters:
+ * @queue_id: The load-balanced queue ID.
+ */
+struct dlb_get_ldb_queue_depth_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 queue_id;
+};
+
+/*
+ * dlb_get_dir_queue_depth_args: Used to get a directed queue's depth.
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	request arg is invalid, the driver won't set status.
+ * @response.id: queue depth.
+ *
+ * Input parameters:
+ * @queue_id: The directed queue ID.
+ */
+struct dlb_get_dir_queue_depth_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+	/* Input parameters */
+	__u32 queue_id;
+};
 #endif /* DLB_ARGS_H */
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index dc4d1a3bae0f..f47d3d9b96ba 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -9,6 +9,42 @@
 
 struct dlb_device_configfs dlb_dev_configfs[16];
 
+/*
+ * DLB domain configfs callback template minimizes replication of boilerplate
+ * code to copy arguments, acquire and release the resource lock, and execute
+ * the command.  The arguments and response structure name should have the
+ * format dlb_<lower_name>_args.
+ */
+#define DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(lower_name)		   \
+static int dlb_domain_configfs_##lower_name(struct dlb *dlb,		   \
+				   struct dlb_domain *domain,		   \
+				   void *karg)				   \
+{									   \
+	struct dlb_cmd_response response = {0};				   \
+	struct dlb_##lower_name##_args *arg = karg;			   \
+	int ret;							   \
+									   \
+	mutex_lock(&dlb->resource_mutex);				   \
+									   \
+	ret = dlb_hw_##lower_name(&dlb->hw,				   \
+				  domain->id,				   \
+				  arg,					   \
+				  &response);				   \
+									   \
+	mutex_unlock(&dlb->resource_mutex);				   \
+									   \
+	BUILD_BUG_ON(offsetof(typeof(*arg), response) != 0);		   \
+									   \
+	memcpy(karg, &response, sizeof(response));			   \
+									   \
+	return ret;							   \
+}
+
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_ldb_queue)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_dir_queue)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_ldb_queue_depth)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_dir_queue_depth)
+
 static int dlb_configfs_create_sched_domain(struct dlb *dlb,
 					    void *karg)
 {
@@ -87,6 +123,213 @@ static int dlb_configfs_create_sched_domain(struct dlb *dlb,
  *                    ...
  */
 
+/*
+ * ------ Configfs for dlb queues ---------
+ *
+ * These are the templates for show and store functions in queue
+ * groups/directories, which minimizes replication of boilerplate
+ * code to copy arguments. All attributes, except for "create" store,
+ * use the template. "name" is the attribute name in the group.
+ */
+#define DLB_CONFIGFS_QUEUE_SHOW(name)				\
+static ssize_t dlb_cfs_queue_##name##_show(			\
+	struct config_item *item,				\
+	char *page)						\
+{								\
+	return sprintf(page, "%u\n",				\
+	       to_dlb_cfs_queue(item)->name);			\
+}								\
+
+#define DLB_CONFIGFS_QUEUE_STORE(name)				\
+static ssize_t dlb_cfs_queue_##name##_store(			\
+	struct config_item *item,				\
+	const char *page,					\
+	size_t count)						\
+{								\
+	struct dlb_cfs_queue *dlb_cfs_queue =			\
+				to_dlb_cfs_queue(item);		\
+	int ret;						\
+								\
+	ret = kstrtoint(page, 10,				\
+			 &dlb_cfs_queue->name);			\
+	if (ret)						\
+		return ret;					\
+								\
+	return count;						\
+}								\
+
+static ssize_t dlb_cfs_queue_queue_depth_show(struct config_item *item,
+					      char *page)
+{
+	struct dlb_cfs_queue *dlb_cfs_queue = to_dlb_cfs_queue(item);
+	struct dlb_domain *dlb_domain;
+	struct dlb *dlb = NULL;
+	int ret;
+
+	ret = dlb_configfs_get_dlb_domain(dlb_cfs_queue->domain_grp,
+					  &dlb, &dlb_domain);
+	if (ret)
+		return ret;
+
+	if (dlb_cfs_queue->is_ldb) {
+		struct dlb_get_ldb_queue_depth_args args = {0};
+
+		args.queue_id = dlb_cfs_queue->queue_id;
+		ret = dlb_domain_configfs_get_ldb_queue_depth(dlb,
+						dlb_domain, &args);
+
+		dlb_cfs_queue->status = args.response.status;
+		dlb_cfs_queue->queue_depth = args.response.id;
+	} else {
+		struct dlb_get_dir_queue_depth_args args = {0};
+
+		args.queue_id = dlb_cfs_queue->queue_id;
+		ret = dlb_domain_configfs_get_dir_queue_depth(dlb,
+						dlb_domain, &args);
+
+		dlb_cfs_queue->status = args.response.status;
+		dlb_cfs_queue->queue_depth = args.response.id;
+	}
+
+	if (ret) {
+		dev_err(dlb->dev,
+			"Getting queue depth failed: ret=%d\n", ret);
+		return ret;
+	}
+
+	return sprintf(page, "%u\n", dlb_cfs_queue->queue_depth);
+}
+
+DLB_CONFIGFS_QUEUE_SHOW(status)
+DLB_CONFIGFS_QUEUE_SHOW(queue_id)
+DLB_CONFIGFS_QUEUE_SHOW(is_ldb)
+DLB_CONFIGFS_QUEUE_SHOW(depth_threshold)
+DLB_CONFIGFS_QUEUE_SHOW(num_sequence_numbers)
+DLB_CONFIGFS_QUEUE_SHOW(num_qid_inflights)
+DLB_CONFIGFS_QUEUE_SHOW(num_atomic_inflights)
+DLB_CONFIGFS_QUEUE_SHOW(lock_id_comp_level)
+DLB_CONFIGFS_QUEUE_SHOW(port_id)
+DLB_CONFIGFS_QUEUE_SHOW(create)
+
+DLB_CONFIGFS_QUEUE_STORE(is_ldb)
+DLB_CONFIGFS_QUEUE_STORE(depth_threshold)
+DLB_CONFIGFS_QUEUE_STORE(num_sequence_numbers)
+DLB_CONFIGFS_QUEUE_STORE(num_qid_inflights)
+DLB_CONFIGFS_QUEUE_STORE(num_atomic_inflights)
+DLB_CONFIGFS_QUEUE_STORE(lock_id_comp_level)
+DLB_CONFIGFS_QUEUE_STORE(port_id)
+
+static ssize_t dlb_cfs_queue_create_store(struct config_item *item,
+					  const char *page, size_t count)
+{
+	struct dlb_cfs_queue *dlb_cfs_queue = to_dlb_cfs_queue(item);
+	struct dlb_domain *dlb_domain;
+	struct dlb *dlb = NULL;
+	int ret;
+
+	ret = dlb_configfs_get_dlb_domain(dlb_cfs_queue->domain_grp,
+					  &dlb, &dlb_domain);
+	if (ret)
+		return ret;
+
+	ret = kstrtoint(page, 10, &dlb_cfs_queue->create);
+	if (ret)
+		return ret;
+
+	if (dlb_cfs_queue->create == 0)  /* ToDo ? */
+		return count;
+
+	if (dlb_cfs_queue->is_ldb) {
+		struct dlb_create_ldb_queue_args args = {0};
+
+		args.num_sequence_numbers = dlb_cfs_queue->num_sequence_numbers;
+		args.num_qid_inflights = dlb_cfs_queue->num_qid_inflights;
+		args.num_atomic_inflights = dlb_cfs_queue->num_atomic_inflights;
+		args.lock_id_comp_level = dlb_cfs_queue->lock_id_comp_level;
+		args.depth_threshold = dlb_cfs_queue->depth_threshold;
+
+		dev_dbg(dlb->dev,
+			"Creating ldb queue: %s\n",
+			dlb_cfs_queue->group.cg_item.ci_namebuf);
+
+		ret = dlb_domain_configfs_create_ldb_queue(dlb, dlb_domain, &args);
+
+		dlb_cfs_queue->status = args.response.status;
+		dlb_cfs_queue->queue_id = args.response.id;
+	} else {
+		struct dlb_create_dir_queue_args args = {0};
+
+		args.port_id = dlb_cfs_queue->port_id;
+		args.depth_threshold = dlb_cfs_queue->depth_threshold;
+
+		dev_dbg(dlb->dev,
+			"Creating ldb queue: %s\n",
+			dlb_cfs_queue->group.cg_item.ci_namebuf);
+
+		ret = dlb_domain_configfs_create_dir_queue(dlb, dlb_domain, &args);
+
+		dlb_cfs_queue->status = args.response.status;
+		dlb_cfs_queue->queue_id = args.response.id;
+	}
+
+	if (ret) {
+		dev_err(dlb->dev,
+			"create queue() failed: ret=%d is_ldb=%u\n", ret,
+			dlb_cfs_queue->is_ldb);
+		return ret;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR_RO(dlb_cfs_queue_, status);
+CONFIGFS_ATTR_RO(dlb_cfs_queue_, queue_id);
+CONFIGFS_ATTR_RO(dlb_cfs_queue_, queue_depth);
+CONFIGFS_ATTR(dlb_cfs_queue_, is_ldb);
+CONFIGFS_ATTR(dlb_cfs_queue_, depth_threshold);
+CONFIGFS_ATTR(dlb_cfs_queue_, num_sequence_numbers);
+CONFIGFS_ATTR(dlb_cfs_queue_, num_qid_inflights);
+CONFIGFS_ATTR(dlb_cfs_queue_, num_atomic_inflights);
+CONFIGFS_ATTR(dlb_cfs_queue_, lock_id_comp_level);
+CONFIGFS_ATTR(dlb_cfs_queue_, port_id);
+CONFIGFS_ATTR(dlb_cfs_queue_, create);
+
+static struct configfs_attribute *dlb_cfs_queue_attrs[] = {
+	&dlb_cfs_queue_attr_status,
+	&dlb_cfs_queue_attr_queue_id,
+	&dlb_cfs_queue_attr_queue_depth,
+	&dlb_cfs_queue_attr_is_ldb,
+	&dlb_cfs_queue_attr_depth_threshold,
+	&dlb_cfs_queue_attr_num_sequence_numbers,
+	&dlb_cfs_queue_attr_num_qid_inflights,
+	&dlb_cfs_queue_attr_num_atomic_inflights,
+	&dlb_cfs_queue_attr_lock_id_comp_level,
+	&dlb_cfs_queue_attr_port_id,
+	&dlb_cfs_queue_attr_create,
+
+	NULL,
+};
+
+static void dlb_cfs_queue_release(struct config_item *item)
+{
+	kfree(to_dlb_cfs_queue(item));
+}
+
+static struct configfs_item_operations dlb_cfs_queue_item_ops = {
+	.release	= dlb_cfs_queue_release,
+};
+
+/*
+ * Note that, since no extra work is required on ->drop_item(),
+ * no ->drop_item() is provided. no _group_ops either because we
+ * don't need to create any groups or items in queue configfs.
+ */
+static const struct config_item_type dlb_cfs_queue_type = {
+	.ct_item_ops	= &dlb_cfs_queue_item_ops,
+	.ct_attrs	= dlb_cfs_queue_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
 /*
  * ------ Configfs for dlb domains---------
  *
@@ -228,6 +471,30 @@ static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
 	NULL,
 };
 
+static struct config_group *dlb_cfs_domain_make_queue_port(struct config_group *group,
+							   const char *name)
+{
+	if (strstr(name, "queue")) {
+		struct dlb_cfs_queue *dlb_cfs_queue;
+
+		dlb_cfs_queue = kzalloc(sizeof(*dlb_cfs_queue), GFP_KERNEL);
+		if (!dlb_cfs_queue)
+			return ERR_PTR(-ENOMEM);
+
+		dlb_cfs_queue->domain_grp = group;
+
+		config_group_init_type_name(&dlb_cfs_queue->group, name,
+					    &dlb_cfs_queue_type);
+
+		dlb_cfs_queue->queue_id = 0xffffffff;
+		dlb_cfs_queue->port_id = 0xffffffff;
+
+		return &dlb_cfs_queue->group;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
 static void dlb_cfs_domain_release(struct config_item *item)
 {
 	kfree(to_dlb_cfs_domain(item));
@@ -237,8 +504,17 @@ static struct configfs_item_operations dlb_cfs_domain_item_ops = {
 	.release	= dlb_cfs_domain_release,
 };
 
+/*
+ * Note that, since no extra work is required on ->drop_item(),
+ * no ->drop_item() is provided.
+ */
+static struct configfs_group_operations dlb_cfs_domain_group_ops = {
+	.make_group     = dlb_cfs_domain_make_queue_port,
+};
+
 static const struct config_item_type dlb_cfs_domain_type = {
 	.ct_item_ops	= &dlb_cfs_domain_item_ops,
+	.ct_group_ops	= &dlb_cfs_domain_group_ops,
 	.ct_attrs	= dlb_cfs_domain_attrs,
 	.ct_owner	= THIS_MODULE,
 };
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
index 03019e046429..e70b40560742 100644
--- a/drivers/misc/dlb/dlb_configfs.h
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -29,6 +29,35 @@ struct dlb_cfs_domain {
 
 };
 
+struct dlb_cfs_queue {
+	struct config_group group;
+	struct config_group *domain_grp;
+	unsigned int status;
+	unsigned int queue_id;
+	/* Input parameters */
+	unsigned int is_ldb;
+	unsigned int queue_depth;
+	unsigned int depth_threshold;
+	unsigned int create;
+
+	/* For LDB queue only */
+	unsigned int num_sequence_numbers;
+	unsigned int num_qid_inflights;
+	unsigned int num_atomic_inflights;
+	unsigned int lock_id_comp_level;
+
+	/* For DIR queue only, default = 0xffffffff */
+	unsigned int port_id;
+
+};
+
+static inline
+struct dlb_cfs_queue *to_dlb_cfs_queue(struct config_item *item)
+{
+	return container_of(to_config_group(item),
+			    struct dlb_cfs_queue, group);
+}
+
 static inline
 struct dlb_cfs_domain *to_dlb_cfs_domain(struct config_item *item)
 {
@@ -36,4 +65,33 @@ struct dlb_cfs_domain *to_dlb_cfs_domain(struct config_item *item)
 			    struct dlb_cfs_domain, group);
 }
 
+/*
+ * Get the dlb and dlb_domain pointers from the domain configfs group
+ * in the dlb_cfs_domain structure.
+ */
+static
+int dlb_configfs_get_dlb_domain(struct config_group *domain_grp,
+				struct dlb **dlb,
+				struct dlb_domain **dlb_domain)
+{
+	struct dlb_device_configfs *dlb_dev_configfs;
+	struct dlb_cfs_domain *dlb_cfs_domain;
+
+	dlb_cfs_domain = container_of(domain_grp, struct dlb_cfs_domain, group);
+
+	dlb_dev_configfs = container_of(dlb_cfs_domain->dev_grp,
+					struct dlb_device_configfs,
+					dev_group);
+	*dlb = dlb_dev_configfs->dlb;
+
+	if (!*dlb)
+		return -EINVAL;
+
+	*dlb_domain = (*dlb)->sched_domains[dlb_cfs_domain->domain_id];
+
+	if (!*dlb_domain)
+		return -EINVAL;
+
+	return 0;
+}
 #endif /* DLB_CONFIGFS_H */
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index b6e79397f312..7c63ab63991b 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -139,6 +139,35 @@ struct dlb_sn_group {
 	u32 id;
 };
 
+static inline bool dlb_sn_group_full(struct dlb_sn_group *group)
+{
+	/* SN mask
+	 *	0x0000ffff,  64 SNs per queue,   mode 0
+	 *	0x000000ff,  128 SNs per queue,  mode 1
+	 *	0x0000000f,  256 SNs per queue,  mode 2
+	 *	0x00000003,  512 SNs per queue,  mode 3
+	 *	0x00000001,  1024 SNs per queue, mode 4
+	 */
+	u32 mask = GENMASK(15 >> group->mode, 0);
+
+	return group->slot_use_bitmap == mask;
+}
+
+static inline int dlb_sn_group_alloc_slot(struct dlb_sn_group *group)
+{
+	u32 bound = 16 >> group->mode; /* {16, 8, 4, 2, 1} */
+	u32 i;
+
+	for (i = 0; i < bound; i++) {
+		if (!(group->slot_use_bitmap & BIT(i))) {
+			group->slot_use_bitmap |= BIT(i);
+			return i;
+		}
+	}
+
+	return -1;
+}
+
 static inline void
 dlb_sn_group_free_slot(struct dlb_sn_group *group, int slot)
 {
@@ -495,8 +524,20 @@ void dlb_resource_free(struct dlb_hw *hw);
 int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 			       struct dlb_create_sched_domain_args *args,
 			       struct dlb_cmd_response *resp);
+int dlb_hw_create_ldb_queue(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_create_ldb_queue_args *args,
+			    struct dlb_cmd_response *resp);
+int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_create_dir_queue_args *args,
+			    struct dlb_cmd_response *resp);
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
+int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_get_ldb_queue_depth_args *args,
+			       struct dlb_cmd_response *resp);
+int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_get_dir_queue_depth_args *args,
+			       struct dlb_cmd_response *resp);
 
 /* Prototypes for dlb_configfs.c */
 int dlb_configfs_create_device(struct dlb *dlb);
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 84f6cba6b681..971fc60ce93e 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -198,6 +198,38 @@ static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id)
 	return &hw->domains[id];
 }
 
+static struct dlb_dir_pq_pair *
+dlb_get_domain_used_dir_pq(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_dir_pq_pair *port;
+
+	if (id >= DLB_MAX_NUM_DIR_PORTS)
+		return NULL;
+
+	list_for_each_entry(port, &domain->used_dir_pq_pairs, domain_list) {
+		if (!vdev_req && port->id == id)
+			return port;
+	}
+
+	return NULL;
+}
+
+static struct dlb_ldb_queue *
+dlb_get_domain_ldb_queue(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_queue *queue;
+
+	if (id >= DLB_MAX_NUM_LDB_QUEUES)
+		return NULL;
+
+	list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+		if (!vdev_req && queue->id == id)
+			return queue;
+	}
+
+	return NULL;
+}
+
 static int dlb_attach_ldb_queues(struct dlb_hw *hw,
 				 struct dlb_function_resources *rsrcs,
 				 struct dlb_hw_domain *domain, u32 num_queues,
@@ -586,6 +618,154 @@ dlb_verify_create_sched_dom_args(struct dlb_function_resources *rsrcs,
 	return 0;
 }
 
+static int
+dlb_verify_create_ldb_queue_args(struct dlb_hw *hw, u32 domain_id,
+				 struct dlb_create_ldb_queue_args *args,
+				 struct dlb_cmd_response *resp,
+				 struct dlb_hw_domain **out_domain,
+				 struct dlb_ldb_queue **out_queue)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	int i;
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
+	queue = list_first_entry_or_null(&domain->avail_ldb_queues,
+					 typeof(*queue), domain_list);
+	if (!queue) {
+		resp->status = DLB_ST_LDB_QUEUES_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (args->num_sequence_numbers) {
+		for (i = 0; i < DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS; i++) {
+			struct dlb_sn_group *group = &hw->rsrcs.sn_groups[i];
+
+			if (group->sequence_numbers_per_queue ==
+			    args->num_sequence_numbers &&
+			    !dlb_sn_group_full(group))
+				break;
+		}
+
+		if (i == DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS) {
+			resp->status = DLB_ST_SEQUENCE_NUMBERS_UNAVAILABLE;
+			return -EINVAL;
+		}
+	}
+
+	if (args->num_qid_inflights > 4096) {
+		resp->status = DLB_ST_INVALID_QID_INFLIGHT_ALLOCATION;
+		return -EINVAL;
+	}
+
+	/* Inflights must be <= number of sequence numbers if ordered */
+	if (args->num_sequence_numbers != 0 &&
+	    args->num_qid_inflights > args->num_sequence_numbers) {
+		resp->status = DLB_ST_INVALID_QID_INFLIGHT_ALLOCATION;
+		return -EINVAL;
+	}
+
+	if (domain->num_avail_aqed_entries < args->num_atomic_inflights) {
+		resp->status = DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE;
+		return -EINVAL;
+	}
+
+	if (args->num_atomic_inflights &&
+	    args->lock_id_comp_level != 0 &&
+	    args->lock_id_comp_level != 64 &&
+	    args->lock_id_comp_level != 128 &&
+	    args->lock_id_comp_level != 256 &&
+	    args->lock_id_comp_level != 512 &&
+	    args->lock_id_comp_level != 1024 &&
+	    args->lock_id_comp_level != 2048 &&
+	    args->lock_id_comp_level != 4096 &&
+	    args->lock_id_comp_level != 65536) {
+		resp->status = DLB_ST_INVALID_LOCK_ID_COMP_LEVEL;
+		return -EINVAL;
+	}
+
+	*out_domain = domain;
+	*out_queue = queue;
+
+	return 0;
+}
+
+static int
+dlb_verify_create_dir_queue_args(struct dlb_hw *hw, u32 domain_id,
+				 struct dlb_create_dir_queue_args *args,
+				 struct dlb_cmd_response *resp,
+				 struct dlb_hw_domain **out_domain,
+				 struct dlb_dir_pq_pair **out_queue)
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
+	/*
+	 * If the user claims the port is already configured, validate the port
+	 * ID, its domain, and whether the port is configured.
+	 */
+	if (args->port_id != -1) {
+		pq = dlb_get_domain_used_dir_pq(args->port_id,
+						false,
+						domain);
+
+		if (!pq || pq->domain_id != domain->id ||
+		    !pq->port_configured) {
+			resp->status = DLB_ST_INVALID_PORT_ID;
+			return -EINVAL;
+		}
+	} else {
+		/*
+		 * If the queue's port is not configured, validate that a free
+		 * port-queue pair is available.
+		 */
+		pq = list_first_entry_or_null(&domain->avail_dir_pq_pairs,
+					      typeof(*pq), domain_list);
+		if (!pq) {
+			resp->status = DLB_ST_DIR_QUEUES_UNAVAILABLE;
+			return -EINVAL;
+		}
+	}
+
+	*out_domain = domain;
+	*out_queue = pq;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -650,6 +830,68 @@ dlb_domain_attach_resources(struct dlb_hw *hw,
 	return 0;
 }
 
+static int
+dlb_ldb_queue_attach_to_sn_group(struct dlb_hw *hw,
+				 struct dlb_ldb_queue *queue,
+				 struct dlb_create_ldb_queue_args *args)
+{
+	int slot = -1;
+	int i;
+
+	queue->sn_cfg_valid = false;
+
+	if (args->num_sequence_numbers == 0)
+		return 0;
+
+	for (i = 0; i < DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS; i++) {
+		struct dlb_sn_group *group = &hw->rsrcs.sn_groups[i];
+
+		if (group->sequence_numbers_per_queue ==
+		    args->num_sequence_numbers &&
+		    !dlb_sn_group_full(group)) {
+			slot = dlb_sn_group_alloc_slot(group);
+			if (slot >= 0)
+				break;
+		}
+	}
+
+	if (slot == -1) {
+		dev_err(hw_to_dev(hw),
+			"[%s():%d] Internal error: no sequence number slots available\n",
+			__func__, __LINE__);
+		return -EFAULT;
+	}
+
+	queue->sn_cfg_valid = true;
+	queue->sn_group = i;
+	queue->sn_slot = slot;
+	return 0;
+}
+
+static int
+dlb_ldb_queue_attach_resources(struct dlb_hw *hw,
+			       struct dlb_hw_domain *domain,
+			       struct dlb_ldb_queue *queue,
+			       struct dlb_create_ldb_queue_args *args)
+{
+	int ret;
+
+	ret = dlb_ldb_queue_attach_to_sn_group(hw, queue, args);
+	if (ret)
+		return ret;
+
+	/* Attach QID inflights */
+	queue->num_qid_inflights = args->num_qid_inflights;
+
+	/* Attach atomic inflights */
+	queue->aqed_limit = args->num_atomic_inflights;
+
+	domain->num_avail_aqed_entries -= args->num_atomic_inflights;
+	domain->num_used_aqed_entries += args->num_atomic_inflights;
+
+	return 0;
+}
+
 static void
 dlb_log_create_sched_domain_args(struct dlb_hw *hw,
 				 struct dlb_create_sched_domain_args *args)
@@ -734,6 +976,145 @@ int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 	return 0;
 }
 
+static void
+dlb_log_create_ldb_queue_args(struct dlb_hw *hw, u32 domain_id,
+			      struct dlb_create_ldb_queue_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB create load-balanced queue arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID:                  %d\n",
+		domain_id);
+	dev_dbg(hw_to_dev(hw), "\tNumber of sequence numbers: %d\n",
+		args->num_sequence_numbers);
+	dev_dbg(hw_to_dev(hw), "\tNumber of QID inflights:    %d\n",
+		args->num_qid_inflights);
+	dev_dbg(hw_to_dev(hw), "\tNumber of ATM inflights:    %d\n",
+		args->num_atomic_inflights);
+}
+
+/**
+ * dlb_hw_create_ldb_queue() - create a load-balanced queue
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: queue creation arguments.
+ * @resp: response structure.
+ *
+ * This function creates a load-balanced queue.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the queue ID.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, the domain is not configured,
+ *	    the domain has already been started, or the requested queue name is
+ *	    already in use.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_create_ldb_queue(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_create_ldb_queue_args *args,
+			    struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+	int ret;
+
+	dlb_log_create_ldb_queue_args(hw, domain_id, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_create_ldb_queue_args(hw, domain_id, args, resp,
+					       &domain, &queue);
+	if (ret)
+		return ret;
+
+	ret = dlb_ldb_queue_attach_resources(hw, domain, queue, args);
+	if (ret) {
+		dev_err(hw_to_dev(hw),
+			"[%s():%d] Internal error: failed to attach the ldb queue resources\n",
+			__func__, __LINE__);
+		return ret;
+	}
+
+	queue->num_mappings = 0;
+
+	queue->configured = true;
+
+	/*
+	 * Configuration succeeded, so move the resource from the 'avail' to
+	 * the 'used' list.
+	 */
+	list_move(&queue->domain_list, &domain->used_ldb_queues);
+
+	resp->status = 0;
+	resp->id = queue->id;
+
+	return 0;
+}
+
+static void
+dlb_log_create_dir_queue_args(struct dlb_hw *hw, u32 domain_id,
+			      struct dlb_create_dir_queue_args *args)
+{
+	dev_dbg(hw_to_dev(hw), "DLB create directed queue arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n", domain_id);
+	dev_dbg(hw_to_dev(hw), "\tPort ID:   %d\n", args->port_id);
+}
+
+/**
+ * dlb_hw_create_dir_queue() - create a directed queue
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: queue creation arguments.
+ * @resp: response structure.
+ *
+ * This function creates a directed queue.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the queue ID.
+ *
+ * Errors:
+ * EINVAL - A requested resource is unavailable, the domain is not configured,
+ *	    or the domain has already been started.
+ * EFAULT - Internal error (resp->status not set).
+ */
+int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
+			    struct dlb_create_dir_queue_args *args,
+			    struct dlb_cmd_response *resp)
+{
+	struct dlb_dir_pq_pair *queue;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	dlb_log_create_dir_queue_args(hw, domain_id, args);
+
+	/*
+	 * Verify that hardware resources are available before attempting to
+	 * satisfy the request. This simplifies the error unwinding code.
+	 */
+	ret = dlb_verify_create_dir_queue_args(hw, domain_id, args, resp,
+					       &domain, &queue);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configuration succeeded, so move the resource from the 'avail' to
+	 * the 'used' list (if it's not already there).
+	 */
+	if (args->port_id == -1)
+		list_move(&queue->domain_list, &domain->used_dir_pq_pairs);
+
+	resp->status = 0;
+
+	resp->id = queue->id;
+
+	return 0;
+}
+
 /*
  * dlb_domain_reset_software_state() - returns domain's resources
  * @hw: dlb_hw handle for a particular device.
@@ -890,6 +1271,131 @@ static int dlb_domain_reset_software_state(struct dlb_hw *hw,
 	return 0;
 }
 
+static void dlb_log_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
+					u32 queue_id)
+{
+	dev_dbg(hw_to_dev(hw), "DLB get directed queue depth:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n", domain_id);
+	dev_dbg(hw_to_dev(hw), "\tQueue ID: %d\n", queue_id);
+}
+
+/**
+ * dlb_hw_get_dir_queue_depth() - returns the depth of a directed queue
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: queue depth args
+ * @resp: response structure.
+ *
+ * This function returns the depth of a directed queue.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the depth.
+ *
+ * Errors:
+ * EINVAL - Invalid domain ID or queue ID.
+ */
+int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_get_dir_queue_depth_args *args,
+			       struct dlb_cmd_response *resp)
+{
+	struct dlb_dir_pq_pair *queue;
+	struct dlb_hw_domain *domain;
+	int id;
+
+	id = domain_id;
+
+	dlb_log_get_dir_queue_depth(hw, domain_id, args->queue_id);
+
+	domain = dlb_get_domain_from_id(hw, id);
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	id = args->queue_id;
+
+	queue = dlb_get_domain_used_dir_pq(id, false, domain);
+	if (!queue) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	resp->id = 0;
+
+	return 0;
+}
+
+static u32 dlb_ldb_queue_depth(struct dlb_hw *hw, struct dlb_ldb_queue *queue)
+{
+	u32 aqed, ldb, atm;
+
+	aqed = DLB_CSR_RD(hw, LSP_QID_AQED_ACTIVE_CNT(queue->id));
+	ldb = DLB_CSR_RD(hw, LSP_QID_LDB_ENQUEUE_CNT(queue->id));
+	atm = DLB_CSR_RD(hw, LSP_QID_ATM_ACTIVE(queue->id));
+
+	return FIELD_GET(LSP_QID_AQED_ACTIVE_CNT_COUNT, aqed)
+	       + FIELD_GET(LSP_QID_LDB_ENQUEUE_CNT_COUNT, ldb)
+	       + FIELD_GET(LSP_QID_ATM_ACTIVE_COUNT, atm);
+}
+
+static bool dlb_ldb_queue_is_empty(struct dlb_hw *hw, struct dlb_ldb_queue *queue)
+{
+	return dlb_ldb_queue_depth(hw, queue) == 0;
+}
+
+static void dlb_log_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
+					u32 queue_id)
+{
+	dev_dbg(hw_to_dev(hw), "DLB get load-balanced queue depth:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n", domain_id);
+	dev_dbg(hw_to_dev(hw), "\tQueue ID: %d\n", queue_id);
+}
+
+/**
+ * dlb_hw_get_ldb_queue_depth() - returns the depth of a load-balanced queue
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @args: queue depth args
+ * @resp: response structure.
+ *
+ * This function returns the depth of a load-balanced queue.
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error. If successful, resp->id
+ * contains the depth.
+ *
+ * Errors:
+ * EINVAL - Invalid domain ID or queue ID.
+ */
+int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
+			       struct dlb_get_ldb_queue_depth_args *args,
+			       struct dlb_cmd_response *resp)
+{
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+
+	dlb_log_get_ldb_queue_depth(hw, domain_id, args->queue_id);
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+	if (!domain) {
+		resp->status = DLB_ST_INVALID_DOMAIN_ID;
+		return -EINVAL;
+	}
+
+	queue = dlb_get_domain_ldb_queue(args->queue_id, false, domain);
+	if (!queue) {
+		resp->status = DLB_ST_INVALID_QID;
+		return -EINVAL;
+	}
+
+	resp->id = 0;
+
+	return 0;
+}
+
 static void __dlb_domain_reset_ldb_port_registers(struct dlb_hw *hw,
 						  struct dlb_ldb_port *port)
 {
@@ -1254,6 +1760,27 @@ static void dlb_domain_reset_dir_queue_registers(struct dlb_hw *hw,
 	}
 }
 
+static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
+					   struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_queue *queue;
+
+	/*
+	 * Confirm that all the domain's queue's inflight counts and AQED
+	 * active counts are 0.
+	 */
+	list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+		if (!dlb_ldb_queue_is_empty(hw, queue)) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: failed to empty ldb queue %d\n",
+				__func__, queue->id);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
 static void dlb_domain_reset_registers(struct dlb_hw *hw,
 				       struct dlb_hw_domain *domain)
 {
@@ -1303,6 +1830,7 @@ static void dlb_log_reset_domain(struct dlb_hw *hw, u32 domain_id)
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 {
 	struct dlb_hw_domain *domain;
+	int ret;
 
 	dlb_log_reset_domain(hw, domain_id);
 
@@ -1311,6 +1839,16 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 	if (!domain || !domain->configured)
 		return -EINVAL;
 
+	/*
+	 * For each queue owned by this domain, disable its write permissions to
+	 * cause any traffic sent to it to be dropped. Well-behaved software
+	 * should not be sending QEs at this point.
+	 */
+
+	ret = dlb_domain_verify_reset_success(hw, domain);
+	if (ret)
+		return ret;
+
 	/* Reset the QID and port state. */
 	dlb_domain_reset_registers(hw, domain);
 
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 580a5cafbe61..3586afbccdbf 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -19,5 +19,14 @@ enum dlb_error {
 	DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE,
 	DLB_ST_LDB_PORT_REQUIRED_FOR_LDB_QUEUES,
 	DLB_ST_DOMAIN_RESET_FAILED,
+	DLB_ST_INVALID_DOMAIN_ID,
+	DLB_ST_INVALID_QID_INFLIGHT_ALLOCATION,
+	DLB_ST_INVALID_LDB_QUEUE_ID,
+	DLB_ST_DOMAIN_NOT_CONFIGURED,
+	DLB_ST_INVALID_QID,
+	DLB_ST_DOMAIN_STARTED,
+	DLB_ST_DIR_QUEUES_UNAVAILABLE,
+	DLB_ST_INVALID_PORT_ID,
+	DLB_ST_INVALID_LOCK_ID_COMP_LEVEL,
 };
 #endif /* __DLB_H */
-- 
2.27.0

