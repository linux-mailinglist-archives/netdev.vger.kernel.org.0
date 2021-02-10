Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A248316DA6
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhBJSCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:02:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:60442 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhBJR7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:59:32 -0500
IronPort-SDR: jtGK+Qcq9rfzoMbi7bvJLDGpegqMuEMFlMsD3fFZ1Bwax9bqI2hifqligRU+rER6XHGGvM5UPC
 1dauFGwak/lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236051"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236051"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:14 -0800
IronPort-SDR: ZcUb1FKeCF5kzaCXrin+3a/W7qR7U7/41Iyan8CGYM4/Ov8bqogtiDyWNfyb9J26j0e+jUXDig
 qjogCYtclRaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235831"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:14 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 19/20] dlb: add queue unmap register operations
Date:   Wed, 10 Feb 2021 11:54:22 -0600
Message-Id: <20210210175423.1873-20-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the "dynamic" unmap procedure and associated register operations.
Unmapping a load-balanced queue from a port removes that port from the
queue's load-balancing candidates. If a queue unmap is requested after the
domain is started, the driver must disable the requested queue and wait for
it to quiesce before mapping it to the requested port.

Add the code to drain unmapped queues during domain reset. This consists of
mapping a port to the queue, then calling the function to drain a mapped
queue.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_resource.c | 289 ++++++++++++++++++++++++++++++++
 1 file changed, 289 insertions(+)

diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 93a3de642024..f4bd2049557a 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -2320,6 +2320,28 @@ static int dlb_ldb_port_set_has_work_bits(struct dlb_hw *hw,
 	return 0;
 }
 
+static void dlb_ldb_port_clear_has_work_bits(struct dlb_hw *hw,
+					     struct dlb_ldb_port *port, u8 slot)
+{
+	u32 ctrl = 0;
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_RLIST_HASWORK_V;
+
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	BITS_SET(ctrl, port->id.phys_id, LSP_LDB_SCHED_CTRL_CQ);
+	BITS_SET(ctrl, slot, LSP_LDB_SCHED_CTRL_QIDIX);
+	ctrl |= LSP_LDB_SCHED_CTRL_NALB_HASWORK_V;
+
+	DLB_CSR_WR(hw, LSP_LDB_SCHED_CTRL, ctrl);
+
+	dlb_flush_csr(hw);
+}
+
 static void dlb_ldb_port_clear_queue_if_status(struct dlb_hw *hw,
 					       struct dlb_ldb_port *port,
 					       int slot)
@@ -2579,6 +2601,87 @@ static int dlb_ldb_port_map_qid(struct dlb_hw *hw, struct dlb_hw_domain *domain,
 		return dlb_ldb_port_map_qid_static(hw, port, queue, prio);
 }
 
+static int dlb_ldb_port_unmap_qid(struct dlb_hw *hw, struct dlb_ldb_port *port,
+				  struct dlb_ldb_queue *queue)
+{
+	enum dlb_qid_map_state mapped, in_progress, pending_map, unmapped;
+	u32 lsp_qid2cq2;
+	u32 lsp_qid2cq;
+	u32 atm_qid2cq;
+	u32 cq2priov;
+	u32 queue_id;
+	u32 port_id;
+	int i;
+
+	/* Find the queue's slot */
+	mapped = DLB_QUEUE_MAPPED;
+	in_progress = DLB_QUEUE_UNMAP_IN_PROG;
+	pending_map = DLB_QUEUE_UNMAP_IN_PROG_PENDING_MAP;
+
+	if (!dlb_port_find_slot_queue(port, mapped, queue, &i) &&
+	    !dlb_port_find_slot_queue(port, in_progress, queue, &i) &&
+	    !dlb_port_find_slot_queue(port, pending_map, queue, &i)) {
+		DLB_HW_ERR(hw,
+			   "[%s():%d] Internal error: QID %d isn't mapped\n",
+			   __func__, __LINE__, queue->id.phys_id);
+		return -EFAULT;
+	}
+
+	port_id = port->id.phys_id;
+	queue_id = queue->id.phys_id;
+
+	/* Read-modify-write the priority and valid bit register */
+	cq2priov = DLB_CSR_RD(hw, LSP_CQ2PRIOV(port_id));
+
+	cq2priov &= ~(1 << (i + LSP_CQ2PRIOV_V_LOC));
+
+	DLB_CSR_WR(hw, LSP_CQ2PRIOV(port_id), cq2priov);
+
+	atm_qid2cq = DLB_CSR_RD(hw, ATM_QID2CQIDIX(queue_id, port_id / 4));
+
+	lsp_qid2cq = DLB_CSR_RD(hw, LSP_QID2CQIDIX(queue_id, port_id / 4));
+
+	lsp_qid2cq2 = DLB_CSR_RD(hw, LSP_QID2CQIDIX2(queue_id, port_id / 4));
+
+	switch (port_id % 4) {
+	case 0:
+		atm_qid2cq &= ~(1 << (i + ATM_QID2CQIDIX_00_CQ_P0_LOC));
+		lsp_qid2cq &= ~(1 << (i + LSP_QID2CQIDIX_00_CQ_P0_LOC));
+		lsp_qid2cq2 &= ~(1 << (i + LSP_QID2CQIDIX2_00_CQ_P0_LOC));
+		break;
+
+	case 1:
+		atm_qid2cq &= ~(1 << (i + ATM_QID2CQIDIX_00_CQ_P1_LOC));
+		lsp_qid2cq &= ~(1 << (i + LSP_QID2CQIDIX_00_CQ_P1_LOC));
+		lsp_qid2cq2 &= ~(1 << (i + LSP_QID2CQIDIX2_00_CQ_P1_LOC));
+		break;
+
+	case 2:
+		atm_qid2cq &= ~(1 << (i + ATM_QID2CQIDIX_00_CQ_P2_LOC));
+		lsp_qid2cq &= ~(1 << (i + LSP_QID2CQIDIX_00_CQ_P2_LOC));
+		lsp_qid2cq2 &= ~(1 << (i + LSP_QID2CQIDIX2_00_CQ_P2_LOC));
+		break;
+
+	case 3:
+		atm_qid2cq &= ~(1 << (i + ATM_QID2CQIDIX_00_CQ_P3_LOC));
+		lsp_qid2cq &= ~(1 << (i + LSP_QID2CQIDIX_00_CQ_P3_LOC));
+		lsp_qid2cq2 &= ~(1 << (i + LSP_QID2CQIDIX2_00_CQ_P3_LOC));
+		break;
+	}
+
+	DLB_CSR_WR(hw, ATM_QID2CQIDIX(queue_id, port_id / 4), atm_qid2cq);
+
+	DLB_CSR_WR(hw, LSP_QID2CQIDIX(queue_id, port_id / 4), lsp_qid2cq);
+
+	DLB_CSR_WR(hw, LSP_QID2CQIDIX2(queue_id, port_id / 4), lsp_qid2cq2);
+
+	dlb_flush_csr(hw);
+
+	unmapped = DLB_QUEUE_UNMAPPED;
+
+	return dlb_port_slot_state_transition(hw, port, queue, i, unmapped);
+}
+
 static void
 dlb_log_create_sched_domain_args(struct dlb_hw *hw,
 				 struct dlb_create_sched_domain_args *args,
@@ -3033,6 +3136,106 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void
+dlb_domain_finish_unmap_port_slot(struct dlb_hw *hw,
+				  struct dlb_hw_domain *domain,
+				  struct dlb_ldb_port *port, int slot)
+{
+	enum dlb_qid_map_state state;
+	struct dlb_ldb_queue *queue;
+
+	queue = &hw->rsrcs.ldb_queues[port->qid_map[slot].qid];
+
+	state = port->qid_map[slot].state;
+
+	/* Update the QID2CQIDX and CQ2QID vectors */
+	dlb_ldb_port_unmap_qid(hw, port, queue);
+
+	/*
+	 * Ensure the QID will not be serviced by this {CQ, slot} by clearing
+	 * the has_work bits
+	 */
+	dlb_ldb_port_clear_has_work_bits(hw, port, slot);
+
+	/* Reset the {CQ, slot} to its default state */
+	dlb_ldb_port_set_queue_if_status(hw, port, slot);
+
+	/* Re-enable the CQ if it wasn't manually disabled by the user */
+	if (port->enabled)
+		dlb_ldb_port_cq_enable(hw, port);
+
+	/*
+	 * If there is a mapping that is pending this slot's removal, perform
+	 * the mapping now.
+	 */
+	if (state == DLB_QUEUE_UNMAP_IN_PROG_PENDING_MAP) {
+		struct dlb_ldb_port_qid_map *map;
+		struct dlb_ldb_queue *map_queue;
+		u8 prio;
+
+		map = &port->qid_map[slot];
+
+		map->qid = map->pending_qid;
+		map->priority = map->pending_priority;
+
+		map_queue = &hw->rsrcs.ldb_queues[map->qid];
+		prio = map->priority;
+
+		dlb_ldb_port_map_qid(hw, domain, port, map_queue, prio);
+	}
+}
+
+static bool dlb_domain_finish_unmap_port(struct dlb_hw *hw,
+					 struct dlb_hw_domain *domain,
+					 struct dlb_ldb_port *port)
+{
+	u32 infl_cnt;
+	int i;
+
+	if (port->num_pending_removals == 0)
+		return false;
+
+	/*
+	 * The unmap requires all the CQ's outstanding inflights to be
+	 * completed.
+	 */
+	infl_cnt = DLB_CSR_RD(hw, LSP_CQ_LDB_INFL_CNT(port->id.phys_id));
+	if (BITS_GET(infl_cnt, LSP_CQ_LDB_INFL_CNT_COUNT) > 0)
+		return false;
+
+	for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++) {
+		struct dlb_ldb_port_qid_map *map;
+
+		map = &port->qid_map[i];
+
+		if (map->state != DLB_QUEUE_UNMAP_IN_PROG &&
+		    map->state != DLB_QUEUE_UNMAP_IN_PROG_PENDING_MAP)
+			continue;
+
+		dlb_domain_finish_unmap_port_slot(hw, domain, port, i);
+	}
+
+	return true;
+}
+
+static unsigned int
+dlb_domain_finish_unmap_qid_procedures(struct dlb_hw *hw,
+				       struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	if (!domain->configured || domain->num_pending_removals == 0)
+		return 0;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list)
+			dlb_domain_finish_unmap_port(hw, domain, port);
+	}
+
+	return domain->num_pending_removals;
+}
+
 static void dlb_domain_finish_map_port(struct dlb_hw *hw,
 				       struct dlb_hw_domain *domain,
 				       struct dlb_ldb_port *port)
@@ -3197,6 +3400,9 @@ int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
 	 * attempt to complete them. This may be necessary to free up a QID
 	 * slot for this requested mapping.
 	 */
+	if (port->num_pending_removals)
+		dlb_domain_finish_unmap_port(hw, domain, port);
+
 	ret = dlb_verify_map_qid_slot_available(port, queue, resp);
 	if (ret)
 		return ret;
@@ -3440,6 +3646,13 @@ int dlb_hw_unmap_qid(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	/*
+	 * Attempt to finish the unmapping now, in case the port has no
+	 * outstanding inflights. If that's not the case, this will fail and
+	 * the unmapping will be completed at a later time.
+	 */
+	dlb_domain_finish_unmap_port(hw, domain, port);
+
 unmap_qid_done:
 	resp->status = 0;
 
@@ -4539,6 +4752,74 @@ static int dlb_domain_drain_mapped_queues(struct dlb_hw *hw,
 	return 0;
 }
 
+static int dlb_domain_drain_unmapped_queue(struct dlb_hw *hw,
+					   struct dlb_hw_domain *domain,
+					   struct dlb_ldb_queue *queue)
+{
+	struct dlb_ldb_port *port = NULL;
+	int ret, i;
+
+	/* If a domain has LDB queues, it must have LDB ports */
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		port = list_first_entry_or_null(&domain->used_ldb_ports[i],
+						typeof(*port), domain_list);
+		if (port)
+			break;
+	}
+
+	if (!port) {
+		DLB_HW_ERR(hw,
+			   "[%s()] Internal error: No configured LDB ports\n",
+			   __func__);
+		return -EFAULT;
+	}
+
+	/* If necessary, free up a QID slot in this CQ */
+	if (port->num_mappings == DLB_MAX_NUM_QIDS_PER_LDB_CQ) {
+		struct dlb_ldb_queue *mapped_queue;
+
+		mapped_queue = &hw->rsrcs.ldb_queues[port->qid_map[0].qid];
+
+		ret = dlb_ldb_port_unmap_qid(hw, port, mapped_queue);
+		if (ret)
+			return ret;
+	}
+
+	ret = dlb_ldb_port_map_qid_dynamic(hw, port, queue, 0);
+	if (ret)
+		return ret;
+
+	return dlb_domain_drain_mapped_queues(hw, domain);
+}
+
+static int dlb_domain_drain_unmapped_queues(struct dlb_hw *hw,
+					    struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_queue *queue;
+	int ret;
+
+	/* If the domain hasn't been started, there's no traffic to drain */
+	if (!domain->started)
+		return 0;
+
+	/*
+	 * Pre-condition: the unattached queue must not have any outstanding
+	 * completions. This is ensured by calling dlb_domain_drain_ldb_cqs()
+	 * prior to this in dlb_domain_drain_mapped_queues().
+	 */
+	list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+		if (queue->num_mappings != 0 ||
+		    dlb_ldb_queue_is_empty(hw, queue))
+			continue;
+
+		ret = dlb_domain_drain_unmapped_queue(hw, domain, queue);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int dlb_drain_dir_cq(struct dlb_hw *hw, struct dlb_dir_pq_pair *port)
 {
 	unsigned int port_id = port->id.phys_id;
@@ -4841,6 +5122,10 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 	if (ret)
 		return ret;
 
+	ret = dlb_domain_finish_unmap_qid_procedures(hw, domain);
+	if (ret)
+		return ret;
+
 	ret = dlb_domain_finish_map_qid_procedures(hw, domain);
 	if (ret)
 		return ret;
@@ -4852,6 +5137,10 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 	if (ret)
 		return ret;
 
+	ret = dlb_domain_drain_unmapped_queues(hw, domain);
+	if (ret)
+		return ret;
+
 	/* Done draining LDB QEs, so disable the CQs. */
 	dlb_domain_disable_ldb_cqs(hw, domain);
 
-- 
2.17.1

