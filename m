Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A0E316D76
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhBJR56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:57:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:60436 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhBJR5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:57:04 -0500
IronPort-SDR: XyI0voq2kAjWsG02HXwSI12Fjufnx04dl23HnBGOOBJa91v4luk7t83tcAcFw85vu+vqSFT+Cf
 yXC1LZrymPsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236018"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236018"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:07 -0800
IronPort-SDR: zSixV8+/D1xCxmJnjd0M5Tz7zsei2ozPVflk5yQrwKciyLu5t4jiYpWj79AEIOgSQCcyv3KY1Y
 iBKW+SLfXPEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235735"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:07 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 06/20] dlb: add domain software reset
Date:   Wed, 10 Feb 2021 11:54:09 -0600
Message-Id: <20210210175423.1873-7-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add operation to reset a domain's resource's software state when its
reference count reaches zero, and re-inserts those resources in their
respective available-resources linked lists, for use by future scheduling
domains.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_bitmap.h   |  28 +++++
 drivers/misc/dlb/dlb_hw_types.h |   6 +
 drivers/misc/dlb/dlb_ioctl.c    |  10 +-
 drivers/misc/dlb/dlb_main.c     |  10 +-
 drivers/misc/dlb/dlb_main.h     |   2 +
 drivers/misc/dlb/dlb_pf_ops.c   |   7 ++
 drivers/misc/dlb/dlb_resource.c | 217 ++++++++++++++++++++++++++++++++
 drivers/misc/dlb/dlb_resource.h |   3 +
 include/uapi/linux/dlb.h        |   1 +
 9 files changed, 282 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/dlb/dlb_bitmap.h b/drivers/misc/dlb/dlb_bitmap.h
index 5cebf833fab4..332135689dd9 100644
--- a/drivers/misc/dlb/dlb_bitmap.h
+++ b/drivers/misc/dlb/dlb_bitmap.h
@@ -73,6 +73,34 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
 	kfree(bitmap);
 }
 
+/**
+ * dlb_bitmap_set_range() - set a range of bitmap entries
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
+static inline int dlb_bitmap_set_range(struct dlb_bitmap *bitmap,
+				       unsigned int bit,
+				       unsigned int len)
+{
+	if (!bitmap || !bitmap->map)
+		return -EINVAL;
+
+	if (bitmap->len <= bit)
+		return -EINVAL;
+
+	bitmap_set(bitmap->map, bit, len);
+
+	return 0;
+}
+
 /**
  * dlb_bitmap_clear_range() - clear a range of bitmap entries
  * @bitmap: pointer to dlb_bitmap structure.
diff --git a/drivers/misc/dlb/dlb_hw_types.h b/drivers/misc/dlb/dlb_hw_types.h
index 3e03b061d5ff..c486ea344292 100644
--- a/drivers/misc/dlb/dlb_hw_types.h
+++ b/drivers/misc/dlb/dlb_hw_types.h
@@ -150,6 +150,12 @@ struct dlb_sn_group {
 	u32 id;
 };
 
+static inline void
+dlb_sn_group_free_slot(struct dlb_sn_group *group, int slot)
+{
+	group->slot_use_bitmap &= ~(BIT(slot));
+}
+
 struct dlb_hw_domain {
 	struct dlb_function_resources *parent_func;
 	struct list_head func_list;
diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
index 7871d0cea118..75892966f061 100644
--- a/drivers/misc/dlb/dlb_ioctl.c
+++ b/drivers/misc/dlb/dlb_ioctl.c
@@ -57,13 +57,21 @@ static int dlb_ioctl_create_sched_domain(struct dlb *dlb, unsigned long user_arg
 
 	mutex_lock(&dlb->resource_mutex);
 
+	if (dlb->domain_reset_failed) {
+		response.status = DLB_ST_DOMAIN_RESET_FAILED;
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	ret = dlb->ops->create_sched_domain(&dlb->hw, &arg, &response);
 	if (ret)
 		goto unlock;
 
 	ret = dlb_init_domain(dlb, response.id);
-	if (ret)
+	if (ret) {
+		dlb->ops->reset_domain(&dlb->hw, response.id);
 		goto unlock;
+	}
 
 	domain = dlb->sched_domains[response.id];
 
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index a4ed413eee2f..70030d779033 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -103,12 +103,20 @@ int dlb_init_domain(struct dlb *dlb, u32 domain_id)
 static int __dlb_free_domain(struct dlb_domain *domain)
 {
 	struct dlb *dlb = domain->dlb;
+	int ret;
+
+	ret = dlb->ops->reset_domain(&dlb->hw, domain->id);
+	if (ret) {
+		dlb->domain_reset_failed = true;
+		dev_err(dlb->dev,
+			"Internal error: Domain reset failed. To recover, reset the device.\n");
+	}
 
 	dlb->sched_domains[domain->id] = NULL;
 
 	kfree(domain);
 
-	return 0;
+	return ret;
 }
 
 void dlb_free_domain(struct kref *kref)
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 824416e6cdcf..ecfda11b297b 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -44,6 +44,7 @@ struct dlb_device_ops {
 				   struct dlb_cmd_response *resp);
 	int (*get_num_resources)(struct dlb_hw *hw,
 				 struct dlb_get_num_resources_args *args);
+	int (*reset_domain)(struct dlb_hw *hw, u32 domain_id);
 };
 
 extern struct dlb_device_ops dlb_pf_ops;
@@ -70,6 +71,7 @@ struct dlb {
 	enum dlb_device_type type;
 	int id;
 	dev_t dev_number;
+	u8 domain_reset_failed;
 };
 
 /* Prototypes for dlb_ioctl.c */
diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
index b59e9eaa600d..5dea0037d14b 100644
--- a/drivers/misc/dlb/dlb_pf_ops.c
+++ b/drivers/misc/dlb/dlb_pf_ops.c
@@ -112,6 +112,12 @@ static int dlb_pf_get_num_resources(struct dlb_hw *hw,
 	return dlb_hw_get_num_resources(hw, args, false, 0);
 }
 
+static int
+dlb_pf_reset_domain(struct dlb_hw *hw, u32 id)
+{
+	return dlb_reset_domain(hw, id, false, 0);
+}
+
 /********************************/
 /****** DLB PF Device Ops ******/
 /********************************/
@@ -124,4 +130,5 @@ struct dlb_device_ops dlb_pf_ops = {
 	.wait_for_device_ready = dlb_pf_wait_for_device_ready,
 	.create_sched_domain = dlb_pf_create_sched_domain,
 	.get_num_resources = dlb_pf_get_num_resources,
+	.reset_domain = dlb_pf_reset_domain,
 };
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index b7df23c6a158..6d73c2479819 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -201,6 +201,29 @@ int dlb_resource_init(struct dlb_hw *hw)
 	return ret;
 }
 
+static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id,
+						    bool vdev_req,
+						    unsigned int vdev_id)
+{
+	struct dlb_function_resources *rsrcs;
+	struct dlb_hw_domain *domain;
+
+	if (id >= DLB_MAX_NUM_DOMAINS)
+		return NULL;
+
+	if (!vdev_req)
+		return &hw->domains[id];
+
+	rsrcs = &hw->vdev[vdev_id];
+
+	list_for_each_entry(domain, &rsrcs->used_domains, func_list) {
+		if (domain->id.virt_id == id)
+			return domain;
+	}
+
+	return NULL;
+}
+
 static int dlb_attach_ldb_queues(struct dlb_hw *hw,
 				 struct dlb_function_resources *rsrcs,
 				 struct dlb_hw_domain *domain, u32 num_queues,
@@ -805,6 +828,200 @@ int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 	return 0;
 }
 
+static int dlb_domain_reset_software_state(struct dlb_hw *hw,
+					   struct dlb_hw_domain *domain)
+{
+	struct dlb *dlb = container_of(hw, struct dlb, hw);
+	struct dlb_dir_pq_pair *tmp_dir_port;
+	struct dlb_function_resources *rsrcs;
+	struct dlb_ldb_queue *tmp_ldb_queue;
+	struct dlb_ldb_port *tmp_ldb_port;
+	struct dlb_dir_pq_pair *dir_port;
+	struct dlb_ldb_queue *ldb_queue;
+	struct dlb_ldb_port *ldb_port;
+	int ret, i;
+
+	lockdep_assert_held(&dlb->resource_mutex);
+
+	rsrcs = domain->parent_func;
+
+	/* Move the domain's ldb queues to the function's avail list */
+	list_for_each_entry_safe(ldb_queue, tmp_ldb_queue,
+				 &domain->used_ldb_queues, domain_list) {
+		if (ldb_queue->sn_cfg_valid) {
+			struct dlb_sn_group *grp;
+
+			grp = &hw->rsrcs.sn_groups[ldb_queue->sn_group];
+
+			dlb_sn_group_free_slot(grp, ldb_queue->sn_slot);
+			ldb_queue->sn_cfg_valid = false;
+		}
+
+		ldb_queue->owned = false;
+		ldb_queue->num_mappings = 0;
+		ldb_queue->num_pending_additions = 0;
+
+		list_del(&ldb_queue->domain_list);
+		list_add(&ldb_queue->func_list, &rsrcs->avail_ldb_queues);
+		rsrcs->num_avail_ldb_queues++;
+	}
+
+	list_for_each_entry_safe(ldb_queue, tmp_ldb_queue,
+				 &domain->avail_ldb_queues, domain_list) {
+		ldb_queue->owned = false;
+
+		list_del(&ldb_queue->domain_list);
+		list_add(&ldb_queue->func_list, &rsrcs->avail_ldb_queues);
+		rsrcs->num_avail_ldb_queues++;
+	}
+
+	/* Move the domain's ldb ports to the function's avail list */
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry_safe(ldb_port, tmp_ldb_port,
+					 &domain->used_ldb_ports[i], domain_list) {
+			int j;
+
+			ldb_port->owned = false;
+			ldb_port->configured = false;
+			ldb_port->num_pending_removals = 0;
+			ldb_port->num_mappings = 0;
+			ldb_port->init_tkn_cnt = 0;
+			for (j = 0; j < DLB_MAX_NUM_QIDS_PER_LDB_CQ; j++)
+				ldb_port->qid_map[j].state =
+					DLB_QUEUE_UNMAPPED;
+
+			list_del(&ldb_port->domain_list);
+			list_add(&ldb_port->func_list,
+				 &rsrcs->avail_ldb_ports[i]);
+			rsrcs->num_avail_ldb_ports[i]++;
+		}
+
+		list_for_each_entry_safe(ldb_port, tmp_ldb_port,
+					 &domain->avail_ldb_ports[i], domain_list) {
+			ldb_port->owned = false;
+
+			list_del(&ldb_port->domain_list);
+			list_add(&ldb_port->func_list,
+				 &rsrcs->avail_ldb_ports[i]);
+			rsrcs->num_avail_ldb_ports[i]++;
+		}
+	}
+
+	/* Move the domain's dir ports to the function's avail list */
+	list_for_each_entry_safe(dir_port, tmp_dir_port,
+				 &domain->used_dir_pq_pairs, domain_list) {
+		dir_port->owned = false;
+		dir_port->port_configured = false;
+		dir_port->init_tkn_cnt = 0;
+
+		list_del(&dir_port->domain_list);
+
+		list_add(&dir_port->func_list, &rsrcs->avail_dir_pq_pairs);
+		rsrcs->num_avail_dir_pq_pairs++;
+	}
+
+	list_for_each_entry_safe(dir_port, tmp_dir_port,
+				 &domain->avail_dir_pq_pairs, domain_list) {
+		dir_port->owned = false;
+
+		list_del(&dir_port->domain_list);
+
+		list_add(&dir_port->func_list, &rsrcs->avail_dir_pq_pairs);
+		rsrcs->num_avail_dir_pq_pairs++;
+	}
+
+	/* Return hist list entries to the function */
+	ret = dlb_bitmap_set_range(rsrcs->avail_hist_list_entries,
+				   domain->hist_list_entry_base,
+				   domain->total_hist_list_entries);
+	if (ret) {
+		DLB_HW_ERR(hw,
+			   "[%s()] Internal error: domain hist list base doesn't match the function's bitmap.\n",
+			   __func__);
+		return ret;
+	}
+
+	domain->total_hist_list_entries = 0;
+	domain->avail_hist_list_entries = 0;
+	domain->hist_list_entry_base = 0;
+	domain->hist_list_entry_offset = 0;
+
+	rsrcs->num_avail_qed_entries += domain->num_ldb_credits;
+	domain->num_ldb_credits = 0;
+
+	rsrcs->num_avail_dqed_entries += domain->num_dir_credits;
+	domain->num_dir_credits = 0;
+
+	rsrcs->num_avail_aqed_entries += domain->num_avail_aqed_entries;
+	rsrcs->num_avail_aqed_entries += domain->num_used_aqed_entries;
+	domain->num_avail_aqed_entries = 0;
+	domain->num_used_aqed_entries = 0;
+
+	domain->num_pending_removals = 0;
+	domain->num_pending_additions = 0;
+	domain->configured = false;
+	domain->started = false;
+
+	/*
+	 * Move the domain out of the used_domains list and back to the
+	 * function's avail_domains list.
+	 */
+	list_del(&domain->func_list);
+	list_add(&domain->func_list, &rsrcs->avail_domains);
+	rsrcs->num_avail_domains++;
+
+	return 0;
+}
+
+static void dlb_log_reset_domain(struct dlb_hw *hw, u32 domain_id,
+				 bool vdev_req, unsigned int vdev_id)
+{
+	DLB_HW_DBG(hw, "DLB reset domain:\n");
+	if (vdev_req)
+		DLB_HW_DBG(hw, "(Request from vdev %d)\n", vdev_id);
+	DLB_HW_DBG(hw, "\tDomain ID: %d\n", domain_id);
+}
+
+/**
+ * dlb_reset_domain() - reset a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ * @vdev_req: indicates whether this request came from a vdev.
+ * @vdev_id: If vdev_req is true, this contains the vdev's ID.
+ *
+ * This function resets and frees a DLB 2.0 scheduling domain and its associated
+ * resources.
+ *
+ * Pre-condition: the driver must ensure software has stopped sending QEs
+ * through this domain's producer ports before invoking this function, or
+ * undefined behavior will result.
+ *
+ * A vdev can be either an SR-IOV virtual function or a Scalable IOV virtual
+ * device.
+ *
+ * Return:
+ * Returns 0 upon success, -1 otherwise.
+ *
+ * EINVAL - Invalid domain ID, or the domain is not configured.
+ * EFAULT - Internal error. (Possibly caused if software is the pre-condition
+ *	    is not met.)
+ * ETIMEDOUT - Hardware component didn't reset in the expected time.
+ */
+int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
+		     unsigned int vdev_id)
+{
+	struct dlb_hw_domain *domain;
+
+	dlb_log_reset_domain(hw, domain_id, vdev_req, vdev_id);
+
+	domain = dlb_get_domain_from_id(hw, domain_id, vdev_req, vdev_id);
+
+	if (!domain || !domain->configured)
+		return -EINVAL;
+
+	return dlb_domain_reset_software_state(hw, domain);
+}
+
 /**
  * dlb_hw_get_num_resources() - query the PCI function's available resources
  * @hw: dlb_hw handle for a particular device.
diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
index efc5140970cd..8c50f449cb9b 100644
--- a/drivers/misc/dlb/dlb_resource.h
+++ b/drivers/misc/dlb/dlb_resource.h
@@ -19,6 +19,9 @@ int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 			       struct dlb_cmd_response *resp,
 			       bool vdev_req, unsigned int vdev_id);
 
+int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
+		     unsigned int vdev_id);
+
 int dlb_hw_get_num_resources(struct dlb_hw *hw,
 			     struct dlb_get_num_resources_args *arg,
 			     bool vdev_req, unsigned int vdev_id);
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 0b152d29f9e4..0513116072a7 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -18,6 +18,7 @@ enum dlb_error {
 	DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE,
 	DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE,
 	DLB_ST_LDB_PORT_REQUIRED_FOR_LDB_QUEUES,
+	DLB_ST_DOMAIN_RESET_FAILED,
 };
 
 struct dlb_cmd_response {
-- 
2.17.1

