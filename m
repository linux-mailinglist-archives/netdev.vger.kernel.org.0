Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62346316D84
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhBJR7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:59:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:60424 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhBJR6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:58:16 -0500
IronPort-SDR: rnmL6cBUKxTe+ZlWQ4gVoV4uw+1qqfRzc0wHpl95zeRj+6rLKtHpCSk9oUKeo3qOM9M4GgQQPq
 PVt5UBICqCPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236034"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236034"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:11 -0800
IronPort-SDR: BF+cynANtCBo+V0nbTEifyYEfmX29G4MNEytVv3ihQnC9sOjU1aWxqQwiegxQZjL5tCHo5ulUF
 Rt0CpS1DnwoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235781"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:10 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 12/20] dlb: add register operations for port management
Date:   Wed, 10 Feb 2021 11:54:15 -0600
Message-Id: <20210210175423.1873-13-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the low-level code for configuring a new port, programming the
device-wide poll mode setting, and resetting a port.

The low-level port configuration functions program the device based on the
user-supplied ioctl arguments. These arguments are first verified, e.g.
to ensure that the port's CQ base address is properly cache-line aligned.

During domain reset, each port is drained until its inflight count and
owed-token count reaches 0, reflecting an empty CQ. Once the ports are
drained, the domain reset operation disables them from being candidates
for future scheduling decisions -- until they are re-assigned to a new
scheduling domain in the future and re-enabled.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/misc/dlb/dlb_resource.c | 448 +++++++++++++++++++++++++++++++-
 1 file changed, 443 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index ac6c5889c435..822c1f4f7849 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -890,7 +890,7 @@ static void dlb_configure_ldb_queue(struct dlb_hw *hw,
 	DLB_CSR_WR(hw, LSP_QID_AQED_ACTIVE_LIM(queue->id.phys_id), reg);
 
 	level = args->lock_id_comp_level;
-	if (level >= 64 && level <= 4096)
+	if (level >= 64 && level <= 4096 && is_power_of_2(level))
 		BITS_SET(reg, ilog2(level) - 5, AQED_QID_HID_WIDTH_COMPRESS_CODE);
 	else
 		reg = 0;
@@ -1001,12 +1001,10 @@ static void dlb_configure_dir_queue(struct dlb_hw *hw,
 static bool
 dlb_cq_depth_is_valid(u32 depth)
 {
-	u32 n = ilog2(depth);
-
 	/* Valid values for depth are
 	 * 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, and 1024.
 	 */
-	if (depth > 1024 || ((1U << n) != depth))
+	if (!is_power_of_2(depth) || depth > 1024)
 		return false;
 
 	return true;
@@ -1347,6 +1345,320 @@ static void dlb_dir_port_cq_disable(struct dlb_hw *hw,
 	dlb_flush_csr(hw);
 }
 
+static void dlb_ldb_port_configure_pp(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain,
+				      struct dlb_ldb_port *port)
+{
+	u32 reg = 0;
+
+	BITS_SET(reg, domain->id.phys_id, SYS_LDB_PP2VAS_VAS);
+	DLB_CSR_WR(hw, SYS_LDB_PP2VAS(port->id.phys_id), reg);
+
+	reg = 0;
+	reg |= SYS_LDB_PP_V_PP_V;
+	DLB_CSR_WR(hw, SYS_LDB_PP_V(port->id.phys_id), reg);
+}
+
+static int dlb_ldb_port_configure_cq(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain,
+				     struct dlb_ldb_port *port,
+				     uintptr_t cq_dma_base,
+				     struct dlb_create_ldb_port_args *args,
+				     bool vdev_req, unsigned int vdev_id)
+{
+	u32 hl_base = 0;
+	u32 reg = 0;
+	u32 ds = 0;
+	u32 n;
+
+	/* The CQ address is 64B-aligned, and the DLB only wants bits [63:6] */
+	BITS_SET(reg, cq_dma_base >> 6, SYS_LDB_CQ_ADDR_L_ADDR_L);
+	DLB_CSR_WR(hw, SYS_LDB_CQ_ADDR_L(port->id.phys_id), reg);
+
+	reg = cq_dma_base >> 32;
+	DLB_CSR_WR(hw, SYS_LDB_CQ_ADDR_U(port->id.phys_id), reg);
+
+	/*
+	 * 'ro' == relaxed ordering. This setting allows DLB to write
+	 * cache lines out-of-order (but QEs within a cache line are always
+	 * updated in-order).
+	 */
+	reg = 0;
+	BITS_SET(reg, vdev_id, SYS_LDB_CQ2VF_PF_RO_VF);
+	BITS_SET(reg, (u32)(!vdev_req), SYS_LDB_CQ2VF_PF_RO_IS_PF);
+	reg |= SYS_LDB_CQ2VF_PF_RO_RO;
+
+	DLB_CSR_WR(hw, SYS_LDB_CQ2VF_PF_RO(port->id.phys_id), reg);
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		DLB_HW_ERR(hw,
+			   "[%s():%d] Internal error: invalid CQ depth\n",
+			   __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	if (args->cq_depth <= 8) {
+		ds = 1;
+	} else {
+		n = ilog2(args->cq_depth);
+		ds = n - 2;
+	}
+
+	reg = 0;
+	BITS_SET(reg, ds, CHP_LDB_CQ_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT);
+	DLB_CSR_WR(hw, CHP_LDB_CQ_TKN_DEPTH_SEL(port->id.phys_id), reg);
+
+	/*
+	 * To support CQs with depth less than 8, program the token count
+	 * register with a non-zero initial value. Operations such as domain
+	 * reset must take this initial value into account when quiescing the
+	 * CQ.
+	 */
+	port->init_tkn_cnt = 0;
+
+	if (args->cq_depth < 8) {
+		reg = 0;
+		port->init_tkn_cnt = 8 - args->cq_depth;
+
+		BITS_SET(reg, port->init_tkn_cnt, LSP_CQ_LDB_TKN_CNT_TOKEN_COUNT);
+		DLB_CSR_WR(hw, LSP_CQ_LDB_TKN_CNT(port->id.phys_id), reg);
+	} else {
+		DLB_CSR_WR(hw,
+			   LSP_CQ_LDB_TKN_CNT(port->id.phys_id),
+			   LSP_CQ_LDB_TKN_CNT_RST);
+	}
+
+	reg = 0;
+	BITS_SET(reg, ds, LSP_CQ_LDB_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT);
+	DLB_CSR_WR(hw, LSP_CQ_LDB_TKN_DEPTH_SEL(port->id.phys_id), reg);
+
+	/* Reset the CQ write pointer */
+	DLB_CSR_WR(hw,
+		   CHP_LDB_CQ_WPTR(port->id.phys_id),
+		   CHP_LDB_CQ_WPTR_RST);
+
+	reg = 0;
+	BITS_SET(reg, port->hist_list_entry_limit - 1, CHP_HIST_LIST_LIM_LIMIT);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_LIM(port->id.phys_id), reg);
+
+	BITS_SET(hl_base, port->hist_list_entry_base, CHP_HIST_LIST_BASE_BASE);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_BASE(port->id.phys_id), hl_base);
+
+	/*
+	 * The inflight limit sets a cap on the number of QEs for which this CQ
+	 * can owe completions at one time.
+	 */
+	reg = 0;
+	BITS_SET(reg, args->cq_history_list_size, LSP_CQ_LDB_INFL_LIM_LIMIT);
+	DLB_CSR_WR(hw, LSP_CQ_LDB_INFL_LIM(port->id.phys_id), reg);
+
+	reg = 0;
+	BITS_SET(reg, BITS_GET(hl_base, CHP_HIST_LIST_BASE_BASE),
+		 CHP_HIST_LIST_PUSH_PTR_PUSH_PTR);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_PUSH_PTR(port->id.phys_id), reg);
+
+	reg = 0;
+	BITS_SET(reg, BITS_GET(hl_base, CHP_HIST_LIST_BASE_BASE),
+		 CHP_HIST_LIST_POP_PTR_POP_PTR);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_POP_PTR(port->id.phys_id), reg);
+
+	/*
+	 * Address translation (AT) settings: 0: untranslated, 2: translated
+	 * (see ATS spec regarding Address Type field for more details)
+	 */
+
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_LDB_CQ_AT(port->id.phys_id), reg);
+	DLB_CSR_WR(hw, SYS_LDB_CQ_PASID(port->id.phys_id), reg);
+
+	reg = 0;
+	BITS_SET(reg, domain->id.phys_id, CHP_LDB_CQ2VAS_CQ2VAS);
+	DLB_CSR_WR(hw, CHP_LDB_CQ2VAS(port->id.phys_id), reg);
+
+	/* Disable the port's QID mappings */
+	reg = 0;
+	DLB_CSR_WR(hw, LSP_CQ2PRIOV(port->id.phys_id), reg);
+
+	return 0;
+}
+
+static int dlb_configure_ldb_port(struct dlb_hw *hw, struct dlb_hw_domain *domain,
+				  struct dlb_ldb_port *port,
+				  uintptr_t cq_dma_base,
+				  struct dlb_create_ldb_port_args *args,
+				  bool vdev_req, unsigned int vdev_id)
+{
+	int ret, i;
+
+	port->hist_list_entry_base = domain->hist_list_entry_base +
+				     domain->hist_list_entry_offset;
+	port->hist_list_entry_limit = port->hist_list_entry_base +
+				      args->cq_history_list_size;
+
+	domain->hist_list_entry_offset += args->cq_history_list_size;
+	domain->avail_hist_list_entries -= args->cq_history_list_size;
+
+	ret = dlb_ldb_port_configure_cq(hw,
+					domain,
+					port,
+					cq_dma_base,
+					args,
+					vdev_req,
+					vdev_id);
+	if (ret)
+		return ret;
+
+	dlb_ldb_port_configure_pp(hw, domain, port);
+
+	dlb_ldb_port_cq_enable(hw, port);
+
+	for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++)
+		port->qid_map[i].state = DLB_QUEUE_UNMAPPED;
+	port->num_mappings = 0;
+
+	port->enabled = true;
+
+	port->configured = true;
+
+	return 0;
+}
+
+static void dlb_dir_port_configure_pp(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain,
+				      struct dlb_dir_pq_pair *port)
+{
+	u32 reg = 0;
+
+	BITS_SET(reg, domain->id.phys_id, SYS_DIR_PP2VAS_VAS);
+	DLB_CSR_WR(hw, SYS_DIR_PP2VAS(port->id.phys_id), reg);
+
+	reg = 0;
+	reg |= SYS_DIR_PP_V_PP_V;
+	DLB_CSR_WR(hw, SYS_DIR_PP_V(port->id.phys_id), reg);
+}
+
+static int dlb_dir_port_configure_cq(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain,
+				     struct dlb_dir_pq_pair *port,
+				     uintptr_t cq_dma_base,
+				     struct dlb_create_dir_port_args *args,
+				     bool vdev_req, unsigned int vdev_id)
+{
+	u32 reg = 0;
+	u32 ds = 0;
+	u32 n;
+
+	/* The CQ address is 64B-aligned, and the DLB only wants bits [63:6] */
+	BITS_SET(reg, cq_dma_base >> 6, SYS_DIR_CQ_ADDR_L_ADDR_L);
+	DLB_CSR_WR(hw, SYS_DIR_CQ_ADDR_L(port->id.phys_id), reg);
+
+	reg = cq_dma_base >> 32;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_ADDR_U(port->id.phys_id), reg);
+
+	/*
+	 * 'ro' == relaxed ordering. This setting allows DLB to write
+	 * cache lines out-of-order (but QEs within a cache line are always
+	 * updated in-order).
+	 */
+	reg = 0;
+	BITS_SET(reg, vdev_id, SYS_DIR_CQ2VF_PF_RO_VF);
+	BITS_SET(reg, (u32)(!vdev_req), SYS_DIR_CQ2VF_PF_RO_IS_PF);
+	reg |= SYS_DIR_CQ2VF_PF_RO_RO;
+
+	DLB_CSR_WR(hw, SYS_DIR_CQ2VF_PF_RO(port->id.phys_id), reg);
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		DLB_HW_ERR(hw,
+			   "[%s():%d] Internal error: invalid CQ depth\n",
+			   __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	if (args->cq_depth <= 8) {
+		ds = 1;
+	} else {
+		n = ilog2(args->cq_depth);
+		ds = n - 2;
+	}
+
+	reg = 0;
+	BITS_SET(reg, ds, CHP_DIR_CQ_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT);
+	DLB_CSR_WR(hw, CHP_DIR_CQ_TKN_DEPTH_SEL(port->id.phys_id), reg);
+
+	/*
+	 * To support CQs with depth less than 8, program the token count
+	 * register with a non-zero initial value. Operations such as domain
+	 * reset must take this initial value into account when quiescing the
+	 * CQ.
+	 */
+	port->init_tkn_cnt = 0;
+
+	if (args->cq_depth < 8) {
+		reg = 0;
+		port->init_tkn_cnt = 8 - args->cq_depth;
+
+		BITS_SET(reg, port->init_tkn_cnt, LSP_CQ_DIR_TKN_CNT_COUNT);
+		DLB_CSR_WR(hw, LSP_CQ_DIR_TKN_CNT(port->id.phys_id), reg);
+	} else {
+		DLB_CSR_WR(hw,
+			   LSP_CQ_DIR_TKN_CNT(port->id.phys_id),
+			   LSP_CQ_DIR_TKN_CNT_RST);
+	}
+
+	reg = 0;
+	BITS_SET(reg, ds, LSP_CQ_DIR_TKN_DEPTH_SEL_DSI_TOKEN_DEPTH_SELECT);
+	DLB_CSR_WR(hw, LSP_CQ_DIR_TKN_DEPTH_SEL_DSI(port->id.phys_id), reg);
+
+	/* Reset the CQ write pointer */
+	DLB_CSR_WR(hw,
+		   CHP_DIR_CQ_WPTR(port->id.phys_id),
+		   CHP_DIR_CQ_WPTR_RST);
+
+	/* Virtualize the PPID */
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_FMT(port->id.phys_id), reg);
+
+	/*
+	 * Address translation (AT) settings: 0: untranslated, 2: translated
+	 * (see ATS spec regarding Address Type field for more details)
+	 */
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_AT(port->id.phys_id), reg);
+
+	DLB_CSR_WR(hw, SYS_DIR_CQ_PASID(port->id.phys_id), reg);
+
+	reg = 0;
+	BITS_SET(reg, domain->id.phys_id, CHP_DIR_CQ2VAS_CQ2VAS);
+	DLB_CSR_WR(hw, CHP_DIR_CQ2VAS(port->id.phys_id), reg);
+
+	return 0;
+}
+
+static int dlb_configure_dir_port(struct dlb_hw *hw, struct dlb_hw_domain *domain,
+				  struct dlb_dir_pq_pair *port,
+				  uintptr_t cq_dma_base,
+				  struct dlb_create_dir_port_args *args,
+				  bool vdev_req, unsigned int vdev_id)
+{
+	int ret;
+
+	ret = dlb_dir_port_configure_cq(hw, domain, port, cq_dma_base,
+					args, vdev_req, vdev_id);
+
+	if (ret)
+		return ret;
+
+	dlb_dir_port_configure_pp(hw, domain, port);
+
+	dlb_dir_port_cq_enable(hw, port);
+
+	port->enabled = true;
+
+	port->port_configured = true;
+
+	return 0;
+}
+
 static void
 dlb_log_create_sched_domain_args(struct dlb_hw *hw,
 				 struct dlb_create_sched_domain_args *args,
@@ -1693,6 +2005,11 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	ret = dlb_configure_ldb_port(hw, domain, port, cq_dma_base,
+				     args, vdev_req, vdev_id);
+	if (ret)
+		return ret;
+
 	/*
 	 * Configuration succeeded, so move the resource from the 'avail' to
 	 * the 'used' list.
@@ -1775,6 +2092,11 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	ret = dlb_configure_dir_port(hw, domain, port, cq_dma_base,
+				     args, vdev_req, vdev_id);
+	if (ret)
+		return ret;
+
 	/*
 	 * Configuration succeeded, so move the resource from the 'avail' to
 	 * the 'used' list (if it's not already there).
@@ -1877,6 +2199,33 @@ static void dlb_drain_ldb_cq(struct dlb_hw *hw, struct dlb_ldb_port *port)
 	}
 }
 
+static int dlb_domain_wait_for_ldb_cqs_to_empty(struct dlb_hw *hw,
+						struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	int i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			int j;
+
+			for (j = 0; j < DLB_MAX_CQ_COMP_CHECK_LOOPS; j++) {
+				if (dlb_ldb_cq_inflight_count(hw, port) == 0)
+					break;
+			}
+
+			if (j == DLB_MAX_CQ_COMP_CHECK_LOOPS) {
+				DLB_HW_ERR(hw,
+					   "[%s()] Internal error: failed to flush load-balanced port %d's completions.\n",
+					   __func__, port->id.phys_id);
+				return -EFAULT;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int dlb_domain_reset_software_state(struct dlb_hw *hw,
 					   struct dlb_hw_domain *domain)
 {
@@ -2564,7 +2913,10 @@ static u32 dlb_dir_cq_token_count(struct dlb_hw *hw,
 static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
 					   struct dlb_hw_domain *domain)
 {
+	struct dlb_dir_pq_pair *dir_port;
+	struct dlb_ldb_port *ldb_port;
 	struct dlb_ldb_queue *queue;
+	int i;
 
 	/*
 	 * Confirm that all the domain's queue's inflight counts and AQED
@@ -2579,6 +2931,35 @@ static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
 		}
 	}
 
+	/* Confirm that all the domain's CQs inflight and token counts are 0. */
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(ldb_port, &domain->used_ldb_ports[i], domain_list) {
+			if (dlb_ldb_cq_inflight_count(hw, ldb_port) ||
+			    dlb_ldb_cq_token_count(hw, ldb_port)) {
+				DLB_HW_ERR(hw,
+					   "[%s()] Internal error: failed to empty ldb port %d\n",
+					   __func__, ldb_port->id.phys_id);
+				return -EFAULT;
+			}
+		}
+	}
+
+	list_for_each_entry(dir_port, &domain->used_dir_pq_pairs, domain_list) {
+		if (!dlb_dir_queue_is_empty(hw, dir_port)) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: failed to empty dir queue %d\n",
+				   __func__, dir_port->id.phys_id);
+			return -EFAULT;
+		}
+
+		if (dlb_dir_cq_token_count(hw, dir_port)) {
+			DLB_HW_ERR(hw,
+				   "[%s()] Internal error: failed to empty dir port %d\n",
+				   __func__, dir_port->id.phys_id);
+			return -EFAULT;
+		}
+	}
+
 	return 0;
 }
 
@@ -2796,6 +3177,51 @@ static int dlb_domain_drain_dir_queues(struct dlb_hw *hw,
 	return 0;
 }
 
+static void
+dlb_domain_disable_dir_producer_ports(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain)
+{
+	struct dlb_dir_pq_pair *port;
+	u32 pp_v = 0;
+
+	list_for_each_entry(port, &domain->used_dir_pq_pairs, domain_list) {
+		DLB_CSR_WR(hw, SYS_DIR_PP_V(port->id.phys_id), pp_v);
+	}
+}
+
+static void
+dlb_domain_disable_ldb_producer_ports(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	u32 pp_v = 0;
+	int i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			DLB_CSR_WR(hw,
+				   SYS_LDB_PP_V(port->id.phys_id),
+				   pp_v);
+		}
+	}
+}
+
+static void dlb_domain_disable_ldb_seq_checks(struct dlb_hw *hw,
+					      struct dlb_hw_domain *domain)
+{
+	struct dlb_ldb_port *port;
+	u32 chk_en = 0;
+	int i;
+
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(port, &domain->used_ldb_ports[i], domain_list) {
+			DLB_CSR_WR(hw,
+				   CHP_SN_CHK_ENBL(port->id.phys_id),
+				   chk_en);
+		}
+	}
+}
+
 static void
 dlb_domain_disable_ldb_queue_write_perms(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
@@ -2922,6 +3348,9 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 
 	dlb_domain_disable_ldb_queue_write_perms(hw, domain);
 
+	/* Turn off completion tracking on all the domain's PPs. */
+	dlb_domain_disable_ldb_seq_checks(hw, domain);
+
 	/*
 	 * Disable the LDB CQs and drain them in order to complete the map and
 	 * unmap procedures, which require zero CQ inflights and zero QID
@@ -2931,6 +3360,10 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 
 	dlb_domain_drain_ldb_cqs(hw, domain, false);
 
+	ret = dlb_domain_wait_for_ldb_cqs_to_empty(hw, domain);
+	if (ret)
+		return ret;
+
 	/* Re-enable the CQs in order to drain the mapped queues. */
 	dlb_domain_enable_ldb_cqs(hw, domain);
 
@@ -2946,6 +3379,11 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id, bool vdev_req,
 	/* Done draining DIR QEs, so disable the CQs. */
 	dlb_domain_disable_dir_cqs(hw, domain);
 
+	/* Disable PPs */
+	dlb_domain_disable_dir_producer_ports(hw, domain);
+
+	dlb_domain_disable_ldb_producer_ports(hw, domain);
+
 	ret = dlb_domain_verify_reset_success(hw, domain);
 	if (ret)
 		return ret;
@@ -3039,7 +3477,7 @@ void dlb_clr_pmcsr_disable(struct dlb_hw *hw)
 
 /**
  * dlb_hw_enable_sparse_ldb_cq_mode() - enable sparse mode for load-balanced
- *      ports.
+ *	ports.
  * @hw: dlb_hw handle for a particular device.
  *
  * This function must be called prior to configuring scheduling domains.
-- 
2.17.1

