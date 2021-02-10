Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64264316D9A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhBJSB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:01:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:60436 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhBJR72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:59:28 -0500
IronPort-SDR: 8P4cz92t4RWG5slcnYM0BlNzlnm0t3ndDV/46FnBh/OGrujGAKmQ1f+NMjmKZHzkSlXpBy/QDj
 meW6CN1+uRGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236048"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236048"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:14 -0800
IronPort-SDR: zoTi9p+HQMlNlyThxik+9u3uKhzsmO+OVWEfwUDgVk90qKzCQpBmr7YeLZ0U8O1ISu6Z7dmO4L
 0DeC+dHQMm6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235823"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:13 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 18/20] dlb: add dynamic queue map register operations
Date:   Wed, 10 Feb 2021 11:54:21 -0600
Message-Id: <20210210175423.1873-19-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the "dynamic" map procedure and register operations. If a queue map
is requested after the domain is started, the driver must disable the
requested queue and wait for it to quiesce before mapping it to the
requested port.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_resource.c | 393 +++++++++++++++++++++++++++++++-
 1 file changed, 392 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 95ccb7eddb8b..93a3de642024 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -328,6 +328,37 @@ dlb_get_domain_dir_pq(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 	return NULL;
 }
 
+static struct dlb_ldb_queue *
+dlb_get_ldb_queue_from_id(struct dlb_hw *hw, u32 id, bool vdev_req,
+			  unsigned int vdev_id)
+{
+	struct dlb_function_resources *rsrcs;
+	struct dlb_hw_domain *domain;
+	struct dlb_ldb_queue *queue;
+
+	if (id >= DLB_MAX_NUM_LDB_QUEUES)
+		return NULL;
+
+	rsrcs = (vdev_req) ? &hw->vdev[vdev_id] : &hw->pf;
+
+	if (!vdev_req)
+		return &hw->rsrcs.ldb_queues[id];
+
+	list_for_each_entry(domain, &rsrcs->used_domains, func_list) {
+		list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+			if (queue->id.virt_id == id)
+				return queue;
+		}
+	}
+
+	list_for_each_entry(queue, &rsrcs->avail_ldb_queues, func_list) {
+		if (queue->id.virt_id == id)
+			return queue;
+	}
+
+	return NULL;
+}
+
 static struct dlb_ldb_queue *
 dlb_get_domain_ldb_queue(u32 id, bool vdev_req, struct dlb_hw_domain *domain)
 {
@@ -2251,6 +2282,75 @@ static void dlb_ldb_port_change_qid_priority(struct dlb_hw *hw,
 	port->qid_map[slot].priority = args->priority;
 }
 
+static int dlb_ldb_port_set_has_work_bits(struct dlb_hw *hw,
+					  struct dlb_ldb_port *port,
+					  struct dlb_ldb_queue *queue, int slot)
+{
+	u32 ctrl = 0;
+	u32 active;
+	u32 enq;
+
+	/* Set the atomic scheduling haswork bit */
+	active = DLB_CSR_RD(hw, LSP_QID_AQED_ACTIVE_CNT(queue->id.phys_id));
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_VALUE;
+	BITS_SET(ctrl, (u32)(BITS_GET(active, LSP_QID_AQED_ACTIVE_CNT_COUNT) > 0),
+		 LSP_LDB_SCHED_CTRL_RLIST_HASWORK_V);
+
+	/* Set the non-atomic scheduling haswork bit */
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	enq = DLB_CSR_RD(hw,
+			 LSP_QID_LDB_ENQUEUE_CNT(queue->id.phys_id));
+
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_VALUE;
+	BITS_SET(ctrl, (u32)(BITS_GET(enq, LSP_QID_LDB_ENQUEUE_CNT_COUNT) > 0),
+		 LSP_LDB_SCHED_CTRL_NALB_HASWORK_V);
+
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	dlb_flush_csr(hw);
+
+	return 0;
+}
+
+static void dlb_ldb_port_clear_queue_if_status(struct dlb_hw *hw,
+					       struct dlb_ldb_port *port,
+					       int slot)
+{
+	u32 ctrl = 0;
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_INFLIGHT_OK_V;
+
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	dlb_flush_csr(hw);
+}
+
+static void dlb_ldb_port_set_queue_if_status(struct dlb_hw *hw,
+					     struct dlb_ldb_port *port,
+					     int slot)
+{
+	u32 ctrl = 0;
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_VALUE;
+	ctrl |= LSP_LDB_SCHED_CTRL_INFLIGHT_OK_V;
+
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	dlb_flush_csr(hw);
+}
+
 static void dlb_ldb_queue_set_inflight_limit(struct dlb_hw *hw,
 					     struct dlb_ldb_queue *queue)
 {
@@ -2261,11 +2361,222 @@ static void dlb_ldb_queue_set_inflight_limit(struct dlb_hw *hw,
 	DLB_CSR_WR(hw, LSP_QID_LDB_INFL_LIM(queue->id.phys_id), infl_lim);
 }
 
+static void dlb_ldb_queue_clear_inflight_limit(struct dlb_hw *hw,
+					       struct dlb_ldb_queue *queue)
+{
+	DLB_CSR_WR(hw,
+		   LSP_QID_LDB_INFL_LIM(queue->id.phys_id),
+		   LSP_QID_LDB_INFL_LIM_RST);
+}
+
+/*
+ * dlb_ldb_queue_{enable, disable}_mapped_cqs() don't operate exactly as
+ * their function names imply, and should only be called by the dynamic CQ
+ * mapping code.
+ */
+static void dlb_ldb_queue_disable_mapped_cqs(struct dlb_hw *hw,
+					     struct dlb_hw_domain *domain,
+					     struct dlb_ldb_queue *queue)
+{
+	struct dlb_ldb_port *port;
+	int slot, i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			enum dlb_qid_map_state state = DLB_QUEUE_MAPPED;
+
+			if (!dlb_port_find_slot_queue(port, state,
+						      queue, &slot))
+				continue;
+
+			if (port->enabled)
+				dlb_ldb_port_cq_disable(hw, port);
+		}
+	}
+}
+
+static void dlb_ldb_queue_enable_mapped_cqs(struct dlb_hw *hw,
+					    struct dlb_hw_domain *domain,
+					    struct dlb_ldb_queue *queue)
+{
+	struct dlb_ldb_port *port;
+	int slot, i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			enum dlb_qid_map_state state = DLB_QUEUE_MAPPED;
+
+			if (!dlb_port_find_slot_queue(port, state,
+						      queue, &slot))
+				continue;
+
+			if (port->enabled)
+				dlb_ldb_port_cq_enable(hw, port);
+		}
+	}
+}
+
+static int dlb_ldb_port_finish_map_qid_dynamic(struct dlb_hw *hw,
+					       struct dlb_hw_domain *domain,
+					       struct dlb_ldb_port *port,
+					       struct dlb_ldb_queue *queue)
+{
+	enum dlb_qid_map_state state;
+	int slot, ret, i;
+	u32 infl_cnt;
+	u8 prio;
+
+	infl_cnt = DLB_CSR_RD(hw, LSP_QID_LDB_INFL_CNT(queue->id.phys_id));
+
+	if (BITS_GET(infl_cnt, LSP_QID_LDB_INFL_CNT_COUNT)) {
+		DLB_HW_ERR(hw,
+			   "[%s()] Internal error: non-zero QID inflight count\n",
+			   __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Static map the port and set its corresponding has_work bits.
+	 */
+	state = DLB_QUEUE_MAP_IN_PROG;
+	if (!dlb_port_find_slot_queue(port, state, queue, &slot))
+		return -EINVAL;
+
+	prio = port->qid_map[slot].priority;
+
+	/*
+	 * Update the CQ2QID, CQ2PRIOV, and QID2CQIDX registers, and
+	 * the port's qid_map state.
+	 */
+	ret = dlb_ldb_port_map_qid_static(hw, port, queue, prio);
+	if (ret)
+		return ret;
+
+	ret = dlb_ldb_port_set_has_work_bits(hw, port, queue, slot);
+	if (ret)
+		return ret;
+
+	/*
+	 * Ensure IF_status(cq,qid) is 0 before enabling the port to
+	 * prevent spurious schedules to cause the queue's inflight
+	 * count to increase.
+	 */
+	dlb_ldb_port_clear_queue_if_status(hw, port, slot);
+
+	/* Reset the queue's inflight status */
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			state = DLB_QUEUE_MAPPED;
+			if (!dlb_port_find_slot_queue(port, state,
+						      queue, &slot))
+				continue;
+
+			dlb_ldb_port_set_queue_if_status(hw, port, slot);
+		}
+	}
+
+	dlb_ldb_queue_set_inflight_limit(hw, queue);
+
+	/* Re-enable CQs mapped to this queue */
+	dlb_ldb_queue_enable_mapped_cqs(hw, domain, queue);
+
+	/* If this queue has other mappings pending, clear its inflight limit */
+	if (queue->num_pending_additions > 0)
+		dlb_ldb_queue_clear_inflight_limit(hw, queue);
+
+	return 0;
+}
+
+/**
+ * dlb_ldb_port_map_qid_dynamic() - perform a "dynamic" QID->CQ mapping
+ * @hw: dlb_hw handle for a particular device.
+ * @port: load-balanced port
+ * @queue: load-balanced queue
+ * @priority: queue servicing priority
+ *
+ * Returns 0 if the queue was mapped, 1 if the mapping is scheduled to occur
+ * at a later point, and <0 if an error occurred.
+ */
+static int dlb_ldb_port_map_qid_dynamic(struct dlb_hw *hw,
+					struct dlb_ldb_port *port,
+					struct dlb_ldb_queue *queue,
+					u8 priority)
+{
+	enum dlb_qid_map_state state;
+	struct dlb_hw_domain *domain;
+	int domain_id, slot, ret;
+	u32 infl_cnt;
+
+	domain_id = port->domain_id.phys_id;
+
+	domain = dlb_get_domain_from_id(hw, domain_id, false, 0);
+	if (!domain) {
+		DLB_HW_ERR(hw,
+			   "[%s()] Internal error: unable to find domain %d\n",
+			   __func__, port->domain_id.phys_id);
+		return -EINVAL;
+	}
+
+	/*
+	 * Set the QID inflight limit to 0 to prevent further scheduling of the
+	 * queue.
+	 */
+	DLB_CSR_WR(hw, LSP_QID_LDB_INFL_LIM(queue->id.phys_id), 0);
+
+	if (!dlb_port_find_slot(port, DLB_QUEUE_UNMAPPED, &slot)) {
+		DLB_HW_ERR(hw,
+			   "Internal error: No available unmapped slots\n");
+		return -EFAULT;
+	}
+
+	port->qid_map[slot].qid = queue->id.phys_id;
+	port->qid_map[slot].priority = priority;
+
+	state = DLB_QUEUE_MAP_IN_PROG;
+	ret = dlb_port_slot_state_transition(hw, port, queue, slot, state);
+	if (ret)
+		return ret;
+
+	infl_cnt = DLB_CSR_RD(hw, LSP_QID_LDB_INFL_CNT(queue->id.phys_id));
+
+	if (BITS_GET(infl_cnt, LSP_QID_LDB_INFL_CNT_COUNT))
+		return 1;
+
+	/*
+	 * Disable the affected CQ, and the CQs already mapped to the QID,
+	 * before reading the QID's inflight count a second time. There is an
+	 * unlikely race in which the QID may schedule one more QE after we
+	 * read an inflight count of 0, and disabling the CQs guarantees that
+	 * the race will not occur after a re-read of the inflight count
+	 * register.
+	 */
+	if (port->enabled)
+		dlb_ldb_port_cq_disable(hw, port);
+
+	dlb_ldb_queue_disable_mapped_cqs(hw, domain, queue);
+
+	infl_cnt = DLB_CSR_RD(hw, LSP_QID_LDB_INFL_CNT(queue->id.phys_id));
+
+	if (BITS_GET(infl_cnt, LSP_QID_LDB_INFL_CNT_COUNT)) {
+		if (port->enabled)
+			dlb_ldb_port_cq_enable(hw, port);
+
+		dlb_ldb_queue_enable_mapped_cqs(hw, domain, queue);
+
+		return 1;
+	}
+
+	return dlb_ldb_port_finish_map_qid_dynamic(hw, domain, port, queue);
+}
+
 static int dlb_ldb_port_map_qid(struct dlb_hw *hw, struct dlb_hw_domain *domain,
 				struct dlb_ldb_port *port,
 				struct dlb_ldb_queue *queue, u8 prio)
 {
-	return dlb_ldb_port_map_qid_static(hw, port, queue, prio);
+	if (domain->started)
+		return dlb_ldb_port_map_qid_dynamic(hw, port, queue, prio);
+	else
+		return dlb_ldb_port_map_qid_static(hw, port, queue, prio);
 }
 
 static void
@@ -2722,6 +3033,82 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void dlb_domain_finish_map_port(struct dlb_hw *hw,
+				       struct dlb_hw_domain *domain,
+				       struct dlb_ldb_port *port)
+{
+	int i;
+
+	for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++) {
+		struct dlb_ldb_queue *queue;
+		u32 infl_cnt;
+		int qid;
+
+		if (port->qid_map[i].state != DLB_QUEUE_MAP_IN_PROG)
+			continue;
+
+		qid = port->qid_map[i].qid;
+
+		queue = dlb_get_ldb_queue_from_id(hw, qid, false, 0);
+
+		if (!queue) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: unable to find queue %d\n",
+				   __func__, qid);
+			continue;
+		}
+
+		infl_cnt = DLB_CSR_RD(hw, LSP_QID_LDB_INFL_CNT(qid));
+
+		if (BITS_GET(infl_cnt, LSP_QID_LDB_INFL_CNT_COUNT))
+			continue;
+
+		/*
+		 * Disable the affected CQ, and the CQs already mapped to the
+		 * QID, before reading the QID's inflight count a second time.
+		 * There is an unlikely race in which the QID may schedule one
+		 * more QE after we read an inflight count of 0, and disabling
+		 * the CQs guarantees that the race will not occur after a
+		 * re-read of the inflight count register.
+		 */
+		if (port->enabled)
+			dlb_ldb_port_cq_disable(hw, port);
+
+		dlb_ldb_queue_disable_mapped_cqs(hw, domain, queue);
+
+		infl_cnt = DLB_CSR_RD(hw, LSP_QID_LDB_INFL_CNT(qid));
+
+		if (BITS_GET(infl_cnt, LSP_QID_LDB_INFL_CNT_COUNT)) {
+			if (port->enabled)
+				dlb_ldb_port_cq_enable(hw, port);
+
+			dlb_ldb_queue_enable_mapped_cqs(hw, domain, queue);
+
+			continue;
+		}
+
+		dlb_ldb_port_finish_map_qid_dynamic(hw, domain, port, queue);
+	}
+}
+
+static unsigned int
+dlb_domain_finish_map_qid_procedures(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	if (!domain->configured || domain->num_pending_additions == 0)
+		return 0;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list)
+			dlb_domain_finish_map_port(hw, domain, port);
+	}
+
+	return domain->num_pending_additions;
+}
+
 static void dlb_log_map_qid(struct dlb_hw *hw, u32 domain_id,
 			    struct dlb_map_qid_args *args,
 			    bool vdev_req, unsigned int vdev_id)
@@ -4454,6 +4841,10 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 	if (ret)
 		return ret;
 
+	ret = dlb_domain_finish_map_qid_procedures(hw, domain);
+	if (ret)
+		return ret;
+
 	/* Re-enable the CQs in order to drain the mapped queues. */
 	dlb_domain_enable_ldb_cqs(hw, domain);
 
-- 
2.17.1

