Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9311B47BA3E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhLUGvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:29910 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhLUGuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069431; x=1671605431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WjhJwJh2vbqaRKtG0II4qpBZiOyEoq8hOicYRAxyMeE=;
  b=PT7DFcrrS7rhfXDVrAIEbMLratyrGIff/0JO9EngCUX51ywOfI8sgW8X
   MlRFaCQc0wffAlfu3TnV5Sis2sA8VQQ48Bnn0DhwKCOzW+XjG3VhrLN3B
   40PhCyszZnk6XYYk6E1+Eo2uOA0soNCvAcTP7fmuDVCxnjHYjL8jshD9A
   17ZF7NoniEMVTzWrMZytDnqaLytGPlExSuUoOpSYW9HmcfrnD9Ds+PkX8
   vTGP0fHXeK3uJrEymDiFIbfAsAfonme/qaj+cNLgaSFBaEUMs5btmxblu
   t+gz2T6nz2A+FuIZMZPM+1ktDp3hXufzyP8Zo/k8pRvp8r1OyV/MCzm4O
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107507"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107507"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119069"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:30 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 10/17] dlb: add register operations for queue management
Date:   Tue, 21 Dec 2021 00:50:40 -0600
Message-Id: <20211221065047.290182-11-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the low-level code for configuring a new queue and querying its depth.
When configuring a queue, program the device based on the user-supplied
queue configuration (from the corresponding configfs attributes).

Also add low-level code for resetting (draining) a non-empty queue during
scheduling domain reset. Draining a queue is an iterative process of
checking if the queue is empty, and if not then selecting a linked 'victim'
port and dequeueing the queue's events through this port. A port can only
receive a small number of events at a time, usually much fewer than the
queue depth, so draining a queue typically takes multiple iterations. This
process is finite since software cannot enqueue new events to the DLB's
(finite) on-device storage.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_main.h     |  46 +++
 drivers/misc/dlb/dlb_resource.c | 574 +++++++++++++++++++++++++++++++-
 2 files changed, 618 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
index 7c63ab63991b..3bd2d9ee0a44 100644
--- a/drivers/misc/dlb/dlb_main.h
+++ b/drivers/misc/dlb/dlb_main.h
@@ -57,6 +57,52 @@
 
 #define PCI_DEVICE_ID_INTEL_DLB_PF		0x2710
 
+/*
+ * Hardware-defined base addresses. Those prefixed 'DLB_DRV' are only used by
+ * the PF driver.
+ */
+#define DLB_DRV_LDB_PP_BASE   0x2300000
+#define DLB_DRV_LDB_PP_STRIDE 0x1000
+#define DLB_DRV_LDB_PP_BOUND  (DLB_DRV_LDB_PP_BASE + \
+				DLB_DRV_LDB_PP_STRIDE * DLB_MAX_NUM_LDB_PORTS)
+#define DLB_DRV_DIR_PP_BASE   0x2200000
+#define DLB_DRV_DIR_PP_STRIDE 0x1000
+#define DLB_DRV_DIR_PP_BOUND  (DLB_DRV_DIR_PP_BASE + \
+				DLB_DRV_DIR_PP_STRIDE * DLB_MAX_NUM_DIR_PORTS)
+#define DLB_LDB_PP_BASE       0x2100000
+#define DLB_LDB_PP_STRIDE     0x1000
+#define DLB_LDB_PP_BOUND      (DLB_LDB_PP_BASE + \
+				DLB_LDB_PP_STRIDE * DLB_MAX_NUM_LDB_PORTS)
+#define DLB_LDB_PP_OFFSET(id) (DLB_LDB_PP_BASE + (id) * DLB_PP_SIZE)
+#define DLB_DIR_PP_BASE       0x2000000
+#define DLB_DIR_PP_STRIDE     0x1000
+#define DLB_DIR_PP_BOUND      (DLB_DIR_PP_BASE + \
+				DLB_DIR_PP_STRIDE * DLB_MAX_NUM_DIR_PORTS)
+#define DLB_DIR_PP_OFFSET(id) (DLB_DIR_PP_BASE + (id) * DLB_PP_SIZE)
+
+struct dlb_hcw {
+	u64 data;
+	/* Word 3 */
+	u16 opaque;
+	u8 qid;
+	u8 sched_type:2;
+	u8 priority:3;
+	u8 msg_type:3;
+	/* Word 4 */
+	u16 lock_id;
+	u8 ts_flag:1;
+	u8 rsvd1:2;
+	u8 no_dec:1;
+	u8 cmp_id:4;
+	u8 cq_token:1;
+	u8 qe_comp:1;
+	u8 qe_frag:1;
+	u8 qe_valid:1;
+	u8 int_arm:1;
+	u8 error:1;
+	u8 rsvd:2;
+};
+
 struct dlb_ldb_queue {
 	struct list_head domain_list;
 	struct list_head func_list;
diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 971fc60ce93e..83c000839f15 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -1,9 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
 
+#include <linux/log2.h>
 #include "dlb_regs.h"
 #include "dlb_main.h"
 
+/*
+ * The PF driver cannot assume that a register write will affect subsequent HCW
+ * writes. To ensure a write completes, the driver must read back a CSR. This
+ * function only need be called for configuration that can occur after the
+ * domain has started; prior to starting, applications can't send HCWs.
+ */
+static inline void dlb_flush_csr(struct dlb_hw *hw)
+{
+	DLB_CSR_RD(hw, SYS_TOTAL_VAS);
+}
+
 static void dlb_init_fn_rsrc_lists(struct dlb_function_resources *rsrc)
 {
 	int i;
@@ -766,6 +778,112 @@ dlb_verify_create_dir_queue_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static void dlb_configure_ldb_queue(struct dlb_hw *hw,
+				    struct dlb_hw_domain *domain,
+				    struct dlb_ldb_queue *queue,
+				    struct dlb_create_ldb_queue_args *args)
+{
+	struct dlb_sn_group *sn_group;
+	unsigned int offs;
+	u32 reg = 0;
+	u32 alimit;
+	u32 level;
+
+	/* QID write permissions are turned on when the domain is started */
+	offs = domain->id * DLB_MAX_NUM_LDB_QUEUES + queue->id;
+
+	DLB_CSR_WR(hw, SYS_LDB_VASQID_V(offs), reg);
+
+	/*
+	 * Unordered QIDs get 4K inflights, ordered get as many as the number
+	 * of sequence numbers.
+	 */
+	reg = FIELD_PREP(LSP_QID_LDB_INFL_LIM_LIMIT, args->num_qid_inflights);
+	DLB_CSR_WR(hw, LSP_QID_LDB_INFL_LIM(queue->id), reg);
+
+	alimit = queue->aqed_limit;
+
+	if (alimit > DLB_MAX_NUM_AQED_ENTRIES)
+		alimit = DLB_MAX_NUM_AQED_ENTRIES;
+
+	reg = FIELD_PREP(LSP_QID_AQED_ACTIVE_LIM_LIMIT, alimit);
+	DLB_CSR_WR(hw, LSP_QID_AQED_ACTIVE_LIM(queue->id), reg);
+
+	level = args->lock_id_comp_level;
+	if (level >= 64 && level <= 4096 && is_power_of_2(level)) {
+		reg &= ~AQED_QID_HID_WIDTH_COMPRESS_CODE;
+		reg |= FIELD_PREP(AQED_QID_HID_WIDTH_COMPRESS_CODE, ilog2(level) - 5);
+	} else {
+		reg = 0;
+	}
+
+	DLB_CSR_WR(hw, AQED_QID_HID_WIDTH(queue->id), reg);
+
+	reg = 0;
+	/* Don't timestamp QEs that pass through this queue */
+	DLB_CSR_WR(hw, SYS_LDB_QID_ITS(queue->id), reg);
+
+	reg = FIELD_PREP(LSP_QID_ATM_DEPTH_THRSH_THRESH, args->depth_threshold);
+	DLB_CSR_WR(hw, LSP_QID_ATM_DEPTH_THRSH(queue->id), reg);
+
+	reg = FIELD_PREP(LSP_QID_NALDB_DEPTH_THRSH_THRESH, args->depth_threshold);
+	DLB_CSR_WR(hw, LSP_QID_NALDB_DEPTH_THRSH(queue->id), reg);
+
+	/*
+	 * This register limits the number of inflight flows a queue can have
+	 * at one time.  It has an upper bound of 2048, but can be
+	 * over-subscribed. 512 is chosen so that a single queue doesn't use
+	 * the entire atomic storage, but can use a substantial portion if
+	 * needed.
+	 */
+	reg = FIELD_PREP(AQED_QID_FID_LIM_QID_FID_LIMIT, 512);
+	DLB_CSR_WR(hw, AQED_QID_FID_LIM(queue->id), reg);
+
+	/* Configure SNs */
+	sn_group = &hw->rsrcs.sn_groups[queue->sn_group];
+	reg = FIELD_PREP(CHP_ORD_QID_SN_MAP_MODE, sn_group->mode);
+	reg |= FIELD_PREP(CHP_ORD_QID_SN_MAP_SLOT, queue->sn_slot);
+	reg |= FIELD_PREP(CHP_ORD_QID_SN_MAP_GRP, sn_group->id);
+
+	DLB_CSR_WR(hw, CHP_ORD_QID_SN_MAP(queue->id), reg);
+
+	reg = FIELD_PREP(SYS_LDB_QID_CFG_V_SN_CFG_V,
+		  (u32)(args->num_sequence_numbers != 0));
+	reg |= FIELD_PREP(SYS_LDB_QID_CFG_V_FID_CFG_V,
+		  (u32)(args->num_atomic_inflights != 0));
+
+	DLB_CSR_WR(hw, SYS_LDB_QID_CFG_V(queue->id), reg);
+
+	reg = SYS_LDB_QID_V_QID_V;
+	DLB_CSR_WR(hw, SYS_LDB_QID_V(queue->id), reg);
+}
+
+static void dlb_configure_dir_queue(struct dlb_hw *hw,
+				    struct dlb_hw_domain *domain,
+				    struct dlb_dir_pq_pair *queue,
+				    struct dlb_create_dir_queue_args *args)
+{
+	unsigned int offs;
+	u32 reg = 0;
+
+	/* QID write permissions are turned on when the domain is started */
+	offs = domain->id * DLB_MAX_NUM_DIR_QUEUES +
+		queue->id;
+
+	DLB_CSR_WR(hw, SYS_DIR_VASQID_V(offs), reg);
+
+	/* Don't timestamp QEs that pass through this queue */
+	DLB_CSR_WR(hw, SYS_DIR_QID_ITS(queue->id), reg);
+
+	reg = FIELD_PREP(LSP_QID_DIR_DEPTH_THRSH_THRESH, args->depth_threshold);
+	DLB_CSR_WR(hw, LSP_QID_DIR_DEPTH_THRSH(queue->id), reg);
+
+	reg = SYS_DIR_QID_V_QID_V;
+	DLB_CSR_WR(hw, SYS_DIR_QID_V(queue->id), reg);
+
+	queue->queue_configured = true;
+}
+
 static void dlb_configure_domain_credits(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
 {
@@ -892,6 +1010,56 @@ dlb_ldb_queue_attach_resources(struct dlb_hw *hw,
 	return 0;
 }
 
+static void dlb_ldb_port_cq_enable(struct dlb_hw *hw,
+				   struct dlb_ldb_port *port)
+{
+	u32 reg = 0;
+
+	/*
+	 * Don't re-enable the port if a removal is pending. The caller should
+	 * mark this port as enabled (if it isn't already), and when the
+	 * removal completes the port will be enabled.
+	 */
+	if (port->num_pending_removals)
+		return;
+
+	DLB_CSR_WR(hw, LSP_CQ_LDB_DSBL(port->id), reg);
+
+	dlb_flush_csr(hw);
+}
+
+static void dlb_ldb_port_cq_disable(struct dlb_hw *hw,
+				    struct dlb_ldb_port *port)
+{
+	u32 reg = 0;
+
+	reg |= LSP_CQ_LDB_DSBL_DISABLED;
+	DLB_CSR_WR(hw, LSP_CQ_LDB_DSBL(port->id), reg);
+
+	dlb_flush_csr(hw);
+}
+
+static void dlb_dir_port_cq_enable(struct dlb_hw *hw,
+				   struct dlb_dir_pq_pair *port)
+{
+	u32 reg = 0;
+
+	DLB_CSR_WR(hw, LSP_CQ_DIR_DSBL(port->id), reg);
+
+	dlb_flush_csr(hw);
+}
+
+static void dlb_dir_port_cq_disable(struct dlb_hw *hw,
+				    struct dlb_dir_pq_pair *port)
+{
+	u32 reg = 0;
+
+	reg |= LSP_CQ_DIR_DSBL_DISABLED;
+	DLB_CSR_WR(hw, LSP_CQ_DIR_DSBL(port->id), reg);
+
+	dlb_flush_csr(hw);
+}
+
 static void
 dlb_log_create_sched_domain_args(struct dlb_hw *hw,
 				 struct dlb_create_sched_domain_args *args)
@@ -1038,6 +1206,8 @@ int dlb_hw_create_ldb_queue(struct dlb_hw *hw, u32 domain_id,
 		return ret;
 	}
 
+	dlb_configure_ldb_queue(hw, domain, queue, args);
+
 	queue->num_mappings = 0;
 
 	queue->configured = true;
@@ -1101,6 +1271,8 @@ int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	dlb_configure_dir_queue(hw, domain, queue, args);
+
 	/*
 	 * Configuration succeeded, so move the resource from the 'avail' to
 	 * the 'used' list (if it's not already there).
@@ -1115,6 +1287,92 @@ int dlb_hw_create_dir_queue(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static u32 dlb_ldb_cq_inflight_count(struct dlb_hw *hw,
+				     struct dlb_ldb_port *port)
+{
+	u32 cnt;
+
+	cnt = DLB_CSR_RD(hw, LSP_CQ_LDB_INFL_CNT(port->id));
+
+	return FIELD_GET(LSP_CQ_LDB_INFL_CNT_COUNT, cnt);
+}
+
+static u32 dlb_ldb_cq_token_count(struct dlb_hw *hw, struct dlb_ldb_port *port)
+{
+	u32 cnt;
+
+	cnt = DLB_CSR_RD(hw, LSP_CQ_LDB_TKN_CNT(port->id));
+
+	/*
+	 * Account for the initial token count, which is used in order to
+	 * provide a CQ with depth less than 8.
+	 */
+
+	return FIELD_GET(LSP_CQ_LDB_TKN_CNT_TOKEN_COUNT, cnt) - port->init_tkn_cnt;
+}
+
+static void __iomem *dlb_producer_port_addr(struct dlb_hw *hw, u8 port_id,
+					    bool is_ldb)
+{
+	struct dlb *dlb = container_of(hw, struct dlb, hw);
+	uintptr_t address = (uintptr_t)dlb->hw.func_kva;
+	unsigned long size;
+
+	if (is_ldb) {
+		size = DLB_LDB_PP_STRIDE;
+		address += DLB_DRV_LDB_PP_BASE + size * port_id;
+	} else {
+		size = DLB_DIR_PP_STRIDE;
+		address += DLB_DRV_DIR_PP_BASE + size * port_id;
+	}
+
+	return (void __iomem *)address;
+}
+
+static void dlb_drain_ldb_cq(struct dlb_hw *hw, struct dlb_ldb_port *port)
+{
+	u32 infl_cnt, tkn_cnt;
+	unsigned int i;
+
+	infl_cnt = dlb_ldb_cq_inflight_count(hw, port);
+	tkn_cnt = dlb_ldb_cq_token_count(hw, port);
+
+	if (infl_cnt || tkn_cnt) {
+		struct dlb_hcw hcw_mem[8], *hcw;
+		void __iomem *pp_addr;
+
+		pp_addr = dlb_producer_port_addr(hw, port->id, true);
+
+		/* Point hcw to a 64B-aligned location */
+		hcw = (struct dlb_hcw *)((uintptr_t)&hcw_mem[4] & ~0x3F);
+
+		/*
+		 * Program the first HCW for a completion and token return and
+		 * the other HCWs as NOOPS
+		 */
+
+		memset(hcw, 0, 4 * sizeof(*hcw));
+		hcw->qe_comp = (infl_cnt > 0);
+		hcw->cq_token = (tkn_cnt > 0);
+		hcw->lock_id = tkn_cnt - 1;
+
+		/*
+		 * To ensure outstanding HCWs reach the device before subsequent
+		 * device accesses, fence them.
+		 */
+		wmb();
+
+		/* Return tokens in the first HCW */
+		iosubmit_cmds512(pp_addr, hcw, 1);
+
+		hcw->cq_token = 0;
+
+		/* Issue remaining completions (if any) */
+		for (i = 1; i < infl_cnt; i++)
+			iosubmit_cmds512(pp_addr, hcw, 1);
+	}
+}
+
 /*
  * dlb_domain_reset_software_state() - returns domain's resources
  * @hw: dlb_hw handle for a particular device.
@@ -1271,6 +1529,21 @@ static int dlb_domain_reset_software_state(struct dlb_hw *hw,
 	return 0;
 }
 
+static u32 dlb_dir_queue_depth(struct dlb_hw *hw, struct dlb_dir_pq_pair *queue)
+{
+	u32 cnt;
+
+	cnt = DLB_CSR_RD(hw, LSP_QID_DIR_ENQUEUE_CNT(queue->id));
+
+	return FIELD_GET(LSP_QID_DIR_ENQUEUE_CNT_COUNT, cnt);
+}
+
+static bool dlb_dir_queue_is_empty(struct dlb_hw *hw,
+				   struct dlb_dir_pq_pair *queue)
+{
+	return dlb_dir_queue_depth(hw, queue) == 0;
+}
+
 static void dlb_log_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 					u32 queue_id)
 {
@@ -1322,7 +1595,7 @@ int dlb_hw_get_dir_queue_depth(struct dlb_hw *hw, u32 domain_id,
 		return -EINVAL;
 	}
 
-	resp->id = 0;
+	resp->id = dlb_dir_queue_depth(hw, queue);
 
 	return 0;
 }
@@ -1391,7 +1664,7 @@ int dlb_hw_get_ldb_queue_depth(struct dlb_hw *hw, u32 domain_id,
 		return -EINVAL;
 	}
 
-	resp->id = 0;
+	resp->id = dlb_ldb_queue_depth(hw, queue);
 
 	return 0;
 }
@@ -1760,6 +2033,21 @@ static void dlb_domain_reset_dir_queue_registers(struct dlb_hw *hw,
 	}
 }
 
+static u32 dlb_dir_cq_token_count(struct dlb_hw *hw,
+				  struct dlb_dir_pq_pair *port)
+{
+	u32 cnt;
+
+	cnt = DLB_CSR_RD(hw, LSP_CQ_DIR_TKN_CNT(port->id));
+
+	/*
+	 * Account for the initial token count, which is used in order to
+	 * provide a CQ with depth less than 8.
+	 */
+
+	return FIELD_GET(LSP_CQ_DIR_TKN_CNT_COUNT, cnt) - port->init_tkn_cnt;
+}
+
 static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
 					   struct dlb_hw_domain *domain)
 {
@@ -1801,6 +2089,270 @@ static void dlb_domain_reset_registers(struct dlb_hw *hw,
 		   CHP_CFG_DIR_VAS_CRD_RST);
 }
 
+static void dlb_domain_drain_ldb_cqs(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain,
+				     bool toggle_port)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	/* If the domain hasn't been started, there's no traffic to drain */
+	if (!domain->started)
+		return;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			if (toggle_port)
+				dlb_ldb_port_cq_disable(hw, port);
+
+			dlb_drain_ldb_cq(hw, port);
+
+			if (toggle_port)
+				dlb_ldb_port_cq_enable(hw, port);
+		}
+	}
+}
+
+static bool dlb_domain_mapped_queues_empty(struct dlb_hw *hw,
+					   struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_queue *queue;
+
+	list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+		if (queue->num_mappings == 0)
+			continue;
+
+		if (!dlb_ldb_queue_is_empty(hw, queue))
+			return false;
+	}
+
+	return true;
+}
+
+static int dlb_domain_drain_mapped_queues(struct dlb_hw *hw,
+					  struct dlb_hw_domain *domain)
+{
+	int i;
+
+	/* If the domain hasn't been started, there's no traffic to drain */
+	if (!domain->started)
+		return 0;
+
+	if (domain->num_pending_removals > 0) {
+		dev_err(hw_to_dev(hw),
+			"[%s()] Internal error: failed to unmap domain queues\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < DLB_MAX_QID_EMPTY_CHECK_LOOPS; i++) {
+		dlb_domain_drain_ldb_cqs(hw, domain, true);
+
+		if (dlb_domain_mapped_queues_empty(hw, domain))
+			break;
+	}
+
+	if (i == DLB_MAX_QID_EMPTY_CHECK_LOOPS) {
+		dev_err(hw_to_dev(hw),
+			"[%s()] Internal error: failed to empty queues\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	/*
+	 * Drain the CQs one more time. For the queues to go empty, they would
+	 * have scheduled one or more QEs.
+	 */
+	dlb_domain_drain_ldb_cqs(hw, domain, true);
+
+	return 0;
+}
+
+static int dlb_drain_dir_cq(struct dlb_hw *hw, struct dlb_dir_pq_pair *port)
+{
+	unsigned int port_id = port->id;
+	u32 cnt;
+
+	/* Return any outstanding tokens */
+	cnt = dlb_dir_cq_token_count(hw, port);
+
+	if (cnt != 0) {
+		struct dlb_hcw hcw_mem[8], *hcw;
+		void __iomem *pp_addr;
+
+		pp_addr = dlb_producer_port_addr(hw, port_id, false);
+
+		/* Point hcw to a 64B-aligned location */
+		hcw = (struct dlb_hcw *)((uintptr_t)&hcw_mem[4] & ~0x3F);
+
+		/*
+		 * Program the first HCW for a batch token return and
+		 * the rest as NOOPS
+		 */
+		memset(hcw, 0, 4 * sizeof(*hcw));
+		hcw->cq_token = 1;
+		hcw->lock_id = cnt - 1;
+
+		/*
+		 * To ensure outstanding HCWs reach the device before subsequent
+		 * device accesses, fence them.
+		 */
+		wmb();
+
+		iosubmit_cmds512(pp_addr, hcw, 1);
+	}
+
+	return 0;
+}
+
+static int dlb_domain_drain_dir_cqs(struct dlb_hw *hw,
+				    struct dlb_hw_domain *domain,
+				    bool toggle_port)
+{
+	struct dlb_dir_pq_pair *port;
+	int ret;
+
+	list_for_each_entry(port, &domain->used_dir_pq_pairs, domain_list) {
+		/*
+		 * Can't drain a port if it's not configured, and there's
+		 * nothing to drain if its queue is unconfigured.
+		 */
+		if (!port->port_configured || !port->queue_configured)
+			continue;
+
+		if (toggle_port)
+			dlb_dir_port_cq_disable(hw, port);
+
+		ret = dlb_drain_dir_cq(hw, port);
+		if (ret)
+			return ret;
+
+		if (toggle_port)
+			dlb_dir_port_cq_enable(hw, port);
+	}
+
+	return 0;
+}
+
+static bool dlb_domain_dir_queues_empty(struct dlb_hw *hw,
+					struct dlb_hw_domain *domain)
+{
+	struct dlb_dir_pq_pair *queue;
+
+	list_for_each_entry(queue, &domain->used_dir_pq_pairs, domain_list) {
+		if (!dlb_dir_queue_is_empty(hw, queue))
+			return false;
+	}
+
+	return true;
+}
+
+static int dlb_domain_drain_dir_queues(struct dlb_hw *hw,
+				       struct dlb_hw_domain *domain)
+{
+	int i, ret;
+
+	/* If the domain hasn't been started, there's no traffic to drain */
+	if (!domain->started)
+		return 0;
+
+	for (i = 0; i < DLB_MAX_QID_EMPTY_CHECK_LOOPS; i++) {
+		ret = dlb_domain_drain_dir_cqs(hw, domain, true);
+		if (ret)
+			return ret;
+
+		if (dlb_domain_dir_queues_empty(hw, domain))
+			break;
+	}
+
+	if (i == DLB_MAX_QID_EMPTY_CHECK_LOOPS) {
+		dev_err(hw_to_dev(hw),
+			"[%s()] Internal error: failed to empty queues\n",
+			__func__);
+		return -EFAULT;
+	}
+
+	/*
+	 * Drain the CQs one more time. For the queues to go empty, they would
+	 * have scheduled one or more QEs.
+	 */
+	ret = dlb_domain_drain_dir_cqs(hw, domain, true);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void
+dlb_domain_disable_ldb_queue_write_perms(struct dlb_hw *hw,
+					 struct dlb_hw_domain *domain)
+{
+	int domain_offset = domain->id * DLB_MAX_NUM_LDB_QUEUES;
+	struct dlb_ldb_queue *queue;
+
+	list_for_each_entry(queue, &domain->used_ldb_queues, domain_list) {
+		int idx = domain_offset + queue->id;
+
+		DLB_CSR_WR(hw, SYS_LDB_VASQID_V(idx), 0);
+	}
+}
+
+static void
+dlb_domain_disable_dir_queue_write_perms(struct dlb_hw *hw,
+					 struct dlb_hw_domain *domain)
+{
+	int domain_offset = domain->id * DLB_MAX_NUM_DIR_PORTS;
+	struct dlb_dir_pq_pair *queue;
+
+	list_for_each_entry(queue, &domain->used_dir_pq_pairs, domain_list) {
+		int idx = domain_offset + queue->id;
+
+		DLB_CSR_WR(hw, SYS_DIR_VASQID_V(idx), 0);
+	}
+}
+
+static void dlb_domain_disable_dir_cqs(struct dlb_hw *hw,
+				       struct dlb_hw_domain *domain)
+{
+	struct dlb_dir_pq_pair *port;
+
+	list_for_each_entry(port, &domain->used_dir_pq_pairs, domain_list) {
+		port->enabled = false;
+
+		dlb_dir_port_cq_disable(hw, port);
+	}
+}
+
+static void dlb_domain_disable_ldb_cqs(struct dlb_hw *hw,
+				       struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			port->enabled = false;
+
+			dlb_ldb_port_cq_disable(hw, port);
+		}
+	}
+}
+
+static void dlb_domain_enable_ldb_cqs(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			port->enabled = true;
+
+			dlb_ldb_port_cq_enable(hw, port);
+		}
+	}
+}
+
 static void dlb_log_reset_domain(struct dlb_hw *hw, u32 domain_id)
 {
 	dev_dbg(hw_to_dev(hw), "DLB reset domain:\n");
@@ -1844,6 +2396,24 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 	 * cause any traffic sent to it to be dropped. Well-behaved software
 	 * should not be sending QEs at this point.
 	 */
+	dlb_domain_disable_dir_queue_write_perms(hw, domain);
+
+	dlb_domain_disable_ldb_queue_write_perms(hw, domain);
+
+	/* Re-enable the CQs in order to drain the mapped queues. */
+	dlb_domain_enable_ldb_cqs(hw, domain);
+
+	ret = dlb_domain_drain_mapped_queues(hw, domain);
+	if (ret)
+		return ret;
+
+	/* Done draining LDB QEs, so disable the CQs. */
+	dlb_domain_disable_ldb_cqs(hw, domain);
+
+	dlb_domain_drain_dir_queues(hw, domain);
+
+	/* Done draining DIR QEs, so disable the CQs. */
+	dlb_domain_disable_dir_cqs(hw, domain);
 
 	ret = dlb_domain_verify_reset_success(hw, domain);
 	if (ret)
-- 
2.27.0

