Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FC847BA36
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhLUGud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhLUGuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069421; x=1671605421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hxkn9sFeqVI7k7whs61YFJXzOjXNCfNGIIbdvV62c2o=;
  b=PpP/r3VT3FDrAdVIEu46NorxKePt6gJ4Hip7mOGO/1ZWP5dJ7kJkc66k
   EE6oomLu+6oQgjnRYI7QN9TpM22RmUGl3VathaS6ycntdlo9UOwSgXaMM
   HOmkD0WqNDv3r3rNVzeWOk7j6XmrZSHESwov+4+9DJt+ckbUqw0OziJZ2
   1C1q9iFA9FFsRBYjFfTRXfbWOhmy/W8cLXuB8NxP1WXEGZhm30Wz5Wf9L
   LOU79W1vYCKcvHRTB+uuQNHChoFMcRgxRAmh+LYDAxUIQ7H+cGzVZN483
   Jm0JucC8oiylclpu/cfIgUXj9DcQBPYuM0nCvHs0Laowr3w9XWI23OkYI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107476"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107476"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119009"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:20 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 06/17] dlb: add domain software reset
Date:   Tue, 21 Dec 2021 00:50:36 -0600
Message-Id: <20211221065047.290182-7-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add operation to reset a domain's resource's software state when its
reference count reaches zero, and re-inserts those resources in their
respective available-resources linked lists, for use by future scheduling
domains.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_configfs.c |  10 +-
 drivers/misc/dlb/dlb_main.c     |  10 +-
 drivers/misc/dlb/dlb_main.h     |  36 ++++++
 drivers/misc/dlb/dlb_resource.c | 204 ++++++++++++++++++++++++++++++++
 include/uapi/linux/dlb.h        |   1 +
 5 files changed, 259 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/dlb/dlb_configfs.c b/drivers/misc/dlb/dlb_configfs.c
index 7e5db0390a6a..dc4d1a3bae0f 100644
--- a/drivers/misc/dlb/dlb_configfs.c
+++ b/drivers/misc/dlb/dlb_configfs.c
@@ -20,13 +20,21 @@ static int dlb_configfs_create_sched_domain(struct dlb *dlb,
 
 	mutex_lock(&dlb->resource_mutex);
 
+	if (dlb->domain_reset_failed) {
+		response.status = DLB_ST_DOMAIN_RESET_FAILED;
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	ret = dlb_hw_create_sched_domain(&dlb->hw, arg, &response);
 	if (ret)
 		goto unlock;
 
 	ret = dlb_init_domain(dlb, response.id);
-	if (ret)
+	if (ret) {
+		dlb_reset_domain(&dlb->hw, response.id);
 		goto unlock;
+	}
 
 	domain = dlb->sched_domains[response.id];
 
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
index 3c949d9b4cf0..343bf72dc9c7 100644
--- a/drivers/misc/dlb/dlb_main.c
+++ b/drivers/misc/dlb/dlb_main.c
@@ -101,12 +101,20 @@ int dlb_init_domain(struct dlb *dlb, u32 domain_id)
 static int __dlb_free_domain(struct dlb_domain *domain)
 {
 	struct dlb *dlb = domain->dlb;
+	int ret;
+
+	ret = dlb_reset_domain(&dlb->hw, domain->id);
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
index 6c9b9cce148e..b6e79397f312 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -139,6 +139,12 @@ struct dlb_sn_group {
 	u32 id;
 };
 
+static inline void
+dlb_sn_group_free_slot(struct dlb_sn_group *group, int slot)
+{
+	group->slot_use_bitmap &= ~(BIT(slot));
+}
+
 /*
  * Scheduling domain level resource data structure.
  *
@@ -271,6 +277,7 @@ struct dlb {
 	enum dlb_device_type type;
 	int id;
 	dev_t dev_number;
+	u8 domain_reset_failed;
 };
 
 /*************************/
@@ -337,6 +344,34 @@ static inline void dlb_bitmap_free(struct dlb_bitmap *bitmap)
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
@@ -460,6 +495,7 @@ void dlb_resource_free(struct dlb_hw *hw);
 int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 			       struct dlb_create_sched_domain_args *args,
 			       struct dlb_cmd_response *resp);
+int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id);
 void dlb_clr_pmcsr_disable(struct dlb_hw *hw);
 
 /* Prototypes for dlb_configfs.c */
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 2d74d158219c..c5b3f1ff3d7e 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -190,6 +190,14 @@ int dlb_resource_init(struct dlb_hw *hw)
 	return ret;
 }
 
+static struct dlb_hw_domain *dlb_get_domain_from_id(struct dlb_hw *hw, u32 id)
+{
+	if (id >= DLB_MAX_NUM_DOMAINS)
+		return NULL;
+
+	return &hw->domains[id];
+}
+
 static int dlb_attach_ldb_queues(struct dlb_hw *hw,
 				 struct dlb_function_resources *rsrcs,
 				 struct dlb_hw_domain *domain, u32 num_queues,
@@ -726,6 +734,202 @@ int dlb_hw_create_sched_domain(struct dlb_hw *hw,
 	return 0;
 }
 
+/*
+ * dlb_domain_reset_software_state() - returns domain's resources
+ * @hw: dlb_hw handle for a particular device.
+ * @domain: pointer to scheduling domain.
+ *
+ * This function returns the resources allocated/assigned to a domain back to
+ * the device/function level resource pool. These resources include ldb/dir
+ * queues,  ports, history lists, etc. It is called by the dlb_reset_domain().
+ * When a domain is created/initialized, resources are moved to a domain from
+ * the resource pool.
+ *
+ */
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
+				 &domain->used_ldb_ports[i], domain_list) {
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
+				 &domain->avail_ldb_ports[i], domain_list) {
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
+		dev_err(hw_to_dev(hw),
+			"[%s()] Internal error: domain hist list base doesn't match the function's bitmap.\n",
+			__func__);
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
+	list_move(&domain->func_list, &rsrcs->avail_domains);
+	rsrcs->num_avail_domains++;
+
+	return 0;
+}
+
+static void dlb_log_reset_domain(struct dlb_hw *hw, u32 domain_id)
+{
+	dev_dbg(hw_to_dev(hw), "DLB reset domain:\n");
+	dev_dbg(hw_to_dev(hw), "\tDomain ID: %d\n", domain_id);
+}
+
+/**
+ * dlb_reset_domain() - reset a scheduling domain
+ * @hw: dlb_hw handle for a particular device.
+ * @domain_id: domain ID.
+ *
+ * This function resets and frees a DLB 2.0 scheduling domain and its associated
+ * resources.
+ *
+ * Pre-condition: the driver must ensure software has stopped sending QEs
+ * through this domain's producer ports before invoking this function, or
+ * undefined behavior will result.
+ *
+ * Return:
+ * Returns 0 upon success, -1 otherwise.
+ *
+ * EINVAL - Invalid domain ID, or the domain is not configured.
+ * EFAULT - Internal error. (Possibly caused if software is the pre-condition
+ *	    is not met.)
+ * ETIMEDOUT - Hardware component didn't reset in the expected time.
+ */
+int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
+{
+	struct dlb_hw_domain *domain;
+
+	dlb_log_reset_domain(hw, domain_id);
+
+	domain = dlb_get_domain_from_id(hw, domain_id);
+
+	if (!domain || !domain->configured)
+		return -EINVAL;
+
+	return dlb_domain_reset_software_state(hw, domain);
+}
+
 /**
  * dlb_clr_pmcsr_disable() - power on bulk of DLB 2.0 logic
  * @hw: dlb_hw handle for a particular device.
diff --git a/include/uapi/linux/dlb.h b/include/uapi/linux/dlb.h
index 91551d8a0175..580a5cafbe61 100644
--- a/include/uapi/linux/dlb.h
+++ b/include/uapi/linux/dlb.h
@@ -18,5 +18,6 @@ enum dlb_error {
 	DLB_ST_ATOMIC_INFLIGHTS_UNAVAILABLE,
 	DLB_ST_HIST_LIST_ENTRIES_UNAVAILABLE,
 	DLB_ST_LDB_PORT_REQUIRED_FOR_LDB_QUEUES,
+	DLB_ST_DOMAIN_RESET_FAILED,
 };
 #endif /* __DLB_H */
-- 
2.27.0

