Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA7147BA46
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhLUGvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhLUGvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:51:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069503; x=1671605503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=feL+1jyWik9hk4+YvG/jINhXH4u0JSZagpApsQdR3YQ=;
  b=MfadmT5MiDBweyW+6bJW0754/ZicwqmIwn9iGK/TjWTooK03SRWI233O
   hFRj2M03i8ZzEho7Gg0xpzs/N/gYed55h1n1pvFRPfcBeaU4+2O7UogA7
   g3P0GJxKfT3FAdFFuIk0ZcWbDIcH4Dns/sfHOAZPRTvpFJ3UNomYdWgo1
   L6y4nL9YHQDbHUHwbF6NAjowoIUVTDy5RJJtWwPup1Cn703aC7AEDmDuN
   YsY0BvohLPGauCkK1arVliCiPivBb2XNgivdNnCW5TUjzyXdyx51JhqaL
   XUk/46dTV0qdrq9UYe9jq0b6TP7aQE2r/6p8+PGEsd2GrbeFRn3BsDOZF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107528"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107528"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119103"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:39 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 14/17] dlb: add start domain configfs attribute
Date:   Tue, 21 Dec 2021 00:50:44 -0600
Message-Id: <20211221065047.290182-15-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configfs interface to start a domain. Once a scheduling domain and its
resources have been configured, this ioctl is called to allow the domain's
ports to begin enqueueing to the device. Once started, the domain's
resources cannot be configured again until after the domain is reset.

A write to "start" configfs file in a domain directory instructs the DLB
device to start load-balancing operations.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_args.h     |  17 +++++
 drivers/misc/dlb/dlb_configfs.c |  42 +++++++++++++
 drivers/misc/dlb/dlb_configfs.h |   1 +
 drivers/misc/dlb/dlb_main.h     |   2 +
 drivers/misc/dlb/dlb_resource.c | 106 ++++++++++++++++++++++++++++++++
 5 files changed, 168 insertions(+)

diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
index b16670e62370..7c3e7794efee 100644
--- a/drivers/misc/dlb/dlb_args.h
+++ b/drivers/misc/dlb/dlb_args.h
@@ -248,6 +248,23 @@ struct dlb_get_port_fd_args {
 	__u32 port_id;
 };
 
+/*
+ * dlb_start_domain_args: Used to mark the end of the domain configuration. This
+ *	must be called before passing QEs into the device, and no configuration
+ *	via configfs can be done once the domain has started. Sending QEs into the
+ *	device before starting the domain will result in undefined behavior.
+ * Input parameters:
+ * - (None)
+ *
+ * Output parameters:
+ * @response.status: Detailed error code. In certain cases, such as if the
+ *	configfs request arg is invalid, the driver won't set status.
+ */
+struct dlb_start_domain_args {
+	/* Output parameters */
+	struct dlb_cmd_response response;
+};
+
 /*
  * Mapping sizes for memory mapping the consumer queue (CQ) memory space, and
  * producer port (PP) MMIO space.
diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index 1401ad1a04de..1f7e8a293594 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -44,6 +44,7 @@ DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_ldb_queue)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(create_dir_queue)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_ldb_queue_depth)
 DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(get_dir_queue_depth)
+DLB_DOMAIN_CONFIGFS_CALLBACK_TEMPLATE(start_domain)
 
 static int dlb_create_port_fd(struct dlb *dlb,
 			      const char *prefix,
@@ -814,6 +815,7 @@ DLB_CONFIGFS_DOMAIN_SHOW(num_hist_list_entries)
 DLB_CONFIGFS_DOMAIN_SHOW(num_ldb_credits)
 DLB_CONFIGFS_DOMAIN_SHOW(num_dir_credits)
 DLB_CONFIGFS_DOMAIN_SHOW(create)
+DLB_CONFIGFS_DOMAIN_SHOW(start)
 
 DLB_CONFIGFS_DOMAIN_STORE(num_ldb_queues)
 DLB_CONFIGFS_DOMAIN_STORE(num_ldb_ports)
@@ -882,6 +884,44 @@ static ssize_t dlb_cfs_domain_create_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t dlb_cfs_domain_start_store(struct config_item *item,
+					  const char *page, size_t count)
+{
+	struct dlb_cfs_domain *dlb_cfs_domain = to_dlb_cfs_domain(item);
+	struct dlb_device_configfs *dlb_dev_configfs;
+	struct dlb_domain *dlb_domain;
+	struct dlb *dlb;
+	int ret;
+
+	dlb_dev_configfs = container_of(dlb_cfs_domain->dev_grp,
+					struct dlb_device_configfs,
+					dev_group);
+	dlb = dlb_dev_configfs->dlb;
+
+	ret = kstrtoint(page, 10, &dlb_cfs_domain->start);
+	if (ret)
+		return ret;
+
+	if (dlb_cfs_domain->start == 1) {
+		struct dlb_start_domain_args args;
+
+		memcpy(&args.response, &dlb_cfs_domain->status,
+		       sizeof(struct dlb_start_domain_args));
+
+		dlb_domain = dlb->sched_domains[dlb_cfs_domain->domain_id];
+		ret = dlb_domain_configfs_start_domain(dlb, dlb_domain, &args);
+
+		dlb_cfs_domain->status = args.response.status;
+
+		if (ret) {
+			dev_err(dlb->dev,
+				"start sched domain failed: ret=%d\n", ret);
+			return ret;
+		}
+	}
+	return count;
+}
+
 CONFIGFS_ATTR_RO(dlb_cfs_domain_, domain_fd);
 CONFIGFS_ATTR_RO(dlb_cfs_domain_, status);
 CONFIGFS_ATTR_RO(dlb_cfs_domain_, domain_id);
@@ -893,6 +933,7 @@ CONFIGFS_ATTR(dlb_cfs_domain_, num_hist_list_entries);
 CONFIGFS_ATTR(dlb_cfs_domain_, num_ldb_credits);
 CONFIGFS_ATTR(dlb_cfs_domain_, num_dir_credits);
 CONFIGFS_ATTR(dlb_cfs_domain_, create);
+CONFIGFS_ATTR(dlb_cfs_domain_, start);
 
 static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
 	&dlb_cfs_domain_attr_domain_fd,
@@ -906,6 +947,7 @@ static struct configfs_attribute *dlb_cfs_domain_attrs[] = {
 	&dlb_cfs_domain_attr_num_ldb_credits,
 	&dlb_cfs_domain_attr_num_dir_credits,
 	&dlb_cfs_domain_attr_create,
+	&dlb_cfs_domain_attr_start,
 
 	NULL,
 };
diff --git a/drivers/misc/dlb/dlb_configfs.h b/drivers/misc/dlb/dlb_configfs.h
index 23874abfa42e..2503d0242399 100644
--- a/drivers/misc/dlb/dlb_configfs.h
+++ b/drivers/misc/dlb/dlb_configfs.h
@@ -28,6 +28,7 @@ struct dlb_cfs_domain {
 	unsigned int num_ldb_credits;
 	unsigned int num_dir_credits;
 	unsigned int create;
+	unsigned int start;
 
 };
 
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index b361cf55cd8a..bff006e2dc8d 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -614,6 +614,8 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 			   struct dlb_create_ldb_port_args *args,
 			   uintptr_t cq_dma_base,
 			   struct dlb_cmd_response *resp);
+int dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
+			struct dlb_cmd_response *resp);
 int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 int dlb_ldb_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
 int dlb_dir_port_owned_by_domain(struct dlb_hw *hw, u32 domain_id, u32 port_id);
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index b5d75cb9be7a..9e38fa850e5c 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -1086,6 +1086,34 @@ dlb_verify_create_dir_port_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static int dlb_verify_start_domain_args(struct dlb_hw *hw, u32 domain_id,
+					struct dlb_cmd_response *resp,
+					struct dlb_hw_domain **out_domain)
+{
+	struct dlb_hw_domain *domain;
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
+	*out_domain = domain;
+
+	return 0;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -2470,6 +2498,84 @@ static void dlb_domain_reset_ldb_port_registers(struct dlb_hw *hw,
 	}
 }
 
+static void dlb_log_start_domain(struct dlb_hw *hw, u32 domain_id)
+{
+	dev_dbg(hw_to_dev(hw), "DLB start domain arguments:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n", domain_id);
+}
+
+/**
+ * dlb_hw_start_domain() - start a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @unused: unused.
+ * @resp: response structure.
+ *
+ * This function starts a scheduling domain, which allows applications to send
+ * traffic through it. Once a domain is started, its resources can no longer be
+ * configured (besides QID remapping and port enable/disable).
+ *
+ * Return:
+ * Returns 0 upon success, < 0 otherwise. If an error occurs, resp->status is
+ * assigned a detailed error code from enum dlb_error.
+ *
+ * Errors:
+ * EINVAL - the domain is not configured, or the domain is already started.
+ */
+int
+dlb_hw_start_domain(struct dlb_hw *hw, u32 domain_id, void *unused,
+		    struct dlb_cmd_response *resp)
+{
+	struct dlb_dir_pq_pair *dir_queue;
+	struct dlb_ldb_queue *ldb_queue;
+	struct dlb_hw_domain *domain;
+	int ret;
+
+	dlb_log_start_domain(hw, domain_id);
+
+	ret = dlb_verify_start_domain_args(hw, domain_id, resp,
+					   &domain);
+	if (ret)
+		return ret;
+
+	/*
+	 * Enable load-balanced and directed queue write permissions for the
+	 * queues this domain owns. Without this, the DLB will drop all
+	 * incoming traffic to those queues.
+	 */
+	list_for_each_entry(ldb_queue, &domain->used_ldb_queues, domain_list) {
+		u32 vasqid_v = 0;
+		unsigned int offs;
+
+		vasqid_v |= SYS_LDB_VASQID_V_VASQID_V;
+
+		offs = domain->id * DLB_MAX_NUM_LDB_QUEUES +
+			ldb_queue->id;
+
+		DLB_CSR_WR(hw, SYS_LDB_VASQID_V(offs), vasqid_v);
+	}
+
+	list_for_each_entry(dir_queue, &domain->used_dir_pq_pairs, domain_list) {
+		u32 vasqid_v = 0;
+		unsigned int offs;
+
+		vasqid_v |= SYS_DIR_VASQID_V_VASQID_V;
+
+		offs = domain->id * DLB_MAX_NUM_DIR_PORTS +
+			dir_queue->id;
+
+		DLB_CSR_WR(hw, SYS_DIR_VASQID_V(offs), vasqid_v);
+	}
+
+	dlb_flush_csr(hw);
+
+	domain->started = true;
+
+	resp->status = 0;
+
+	return 0;
+}
+
 static void
 __dlb_domain_reset_dir_port_registers(struct dlb_hw *hw,
 				      struct dlb_dir_pq_pair *port)
-- 
2.27.0

