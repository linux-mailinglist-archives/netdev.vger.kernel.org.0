Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6C47BA42
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhLUGv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:29894 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234503AbhLUGuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069444; x=1671605444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z1ANIhm+CxW5sY4quI1mMBJLHpkNrHtRY2dLV3u/WTs=;
  b=IkQaArcGXLVGy71f5zTXxjULnzJWpPeHxbrWIk4hyRdRKYnAbsOTTbWE
   KDTWWN1qfAtE218zo+PMpRuuidM8rNjZ9xfo3UzA2QnUntZDHyQANbAeT
   kdFPdkxivQ7aauL6N5cbfzTPGZ/ZqvSD0EoU7Vv9PpO/4eCZM0fkxqtmH
   GrABqwV0jiAVpWPlcuQvyUWhB4c1JuRXX/VW7ZSPuJ/P1s+5NYGM5NpRY
   QXedgOGs4a7Bde1B56EqrKlXDwVIbBw+aqNvCPowFFBNFw71Iaf12+Ox0
   sLW1jlc8ojpDMxVKPN7cKYJKZ0lkWT5tcZTHHXj9vmkzJ4VVVDDYa6u+Q
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107516"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107516"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119089"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:35 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 12/17] dlb: add register operations for port management
Date:   Tue, 21 Dec 2021 00:50:42 -0600
Message-Id: <20211221065047.290182-13-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the low-level code for configuring a new port, programming the
device-wide poll mode setting, and resetting a port.

The low-level port configuration functions program the device based on the
user-supplied parameters (from configfs attributes). These parameter are
first verified, e.g.  to ensure that the port's CQ base address is properly
cache-line aligned.

During domain reset, each port is drained until its inflight count and
owed-token count reaches 0, reflecting an empty CQ. Once the ports are
drained, the domain reset operation disables them from being candidates
for future scheduling decisions -- until they are re-assigned to a new
scheduling domain in the future and re-enabled.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_resource.c | 418 +++++++++++++++++++++++++++++++-
 1 file changed, 417 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 3521ae2ca76b..d1e1d1efe8c7 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -1217,6 +1217,296 @@ static void dlb_dir_port_cq_disable(struct dlb_hw *hw,
 	dlb_flush_csr(hw);
 }
 
+static void dlb_ldb_port_configure_pp(struct dlb_hw *hw,
+				      struct dlb_hw_domain *domain,
+				      struct dlb_ldb_port *port)
+{
+	u32 reg;
+
+	reg = FIELD_PREP(SYS_LDB_PP2VAS_VAS, domain->id);
+	DLB_CSR_WR(hw, SYS_LDB_PP2VAS(port->id), reg);
+
+	reg = 0;
+	reg |= SYS_LDB_PP_V_PP_V;
+	DLB_CSR_WR(hw, SYS_LDB_PP_V(port->id), reg);
+}
+
+static int dlb_ldb_port_configure_cq(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain,
+				     struct dlb_ldb_port *port,
+				     uintptr_t cq_dma_base,
+				     struct dlb_create_ldb_port_args *args)
+{
+	u32 hl_base = 0;
+	u32 reg = 0;
+	u32 ds, n;
+
+	/* The CQ address is 64B-aligned, and the DLB only wants bits [63:6] */
+	reg = FIELD_PREP(SYS_LDB_CQ_ADDR_L_ADDR_L, cq_dma_base >> 6);
+	DLB_CSR_WR(hw, SYS_LDB_CQ_ADDR_L(port->id), reg);
+
+	reg = cq_dma_base >> 32;
+	DLB_CSR_WR(hw, SYS_LDB_CQ_ADDR_U(port->id), reg);
+
+	/*
+	 * 'ro' == relaxed ordering. This setting allows DLB to write
+	 * cache lines out-of-order (but QEs within a cache line are always
+	 * updated in-order).
+	 */
+	reg = FIELD_PREP(SYS_LDB_CQ2VF_PF_RO_IS_PF, 1);
+	reg |= SYS_LDB_CQ2VF_PF_RO_RO;
+
+	DLB_CSR_WR(hw, SYS_LDB_CQ2VF_PF_RO(port->id), reg);
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		dev_err(hw_to_dev(hw),
+			"[%s():%d] Internal error: invalid CQ depth\n",
+			__func__, __LINE__);
+		return -EINVAL;
+	}
+
+	if (args->cq_depth <= 8) {
+		ds = 1;
+	} else {
+		n = ilog2(args->cq_depth);
+		ds = (n - 2) & 0x0f;
+	}
+
+	reg = FIELD_PREP(CHP_LDB_CQ_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT, ds);
+	DLB_CSR_WR(hw, CHP_LDB_CQ_TKN_DEPTH_SEL(port->id), reg);
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
+		port->init_tkn_cnt = 8 - args->cq_depth;
+
+		reg = FIELD_PREP(LSP_CQ_LDB_TKN_CNT_TOKEN_COUNT, port->init_tkn_cnt);
+		DLB_CSR_WR(hw, LSP_CQ_LDB_TKN_CNT(port->id), reg);
+	} else {
+		DLB_CSR_WR(hw,
+			   LSP_CQ_LDB_TKN_CNT(port->id),
+			   LSP_CQ_LDB_TKN_CNT_RST);
+	}
+
+	reg = FIELD_PREP(LSP_CQ_LDB_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT, ds);
+	DLB_CSR_WR(hw, LSP_CQ_LDB_TKN_DEPTH_SEL(port->id), reg);
+
+	/* Reset the CQ write pointer */
+	DLB_CSR_WR(hw,
+		   CHP_LDB_CQ_WPTR(port->id),
+		   CHP_LDB_CQ_WPTR_RST);
+
+	reg = FIELD_PREP(CHP_HIST_LIST_LIM_LIMIT, port->hist_list_entry_limit - 1);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_LIM(port->id), reg);
+
+	hl_base = FIELD_PREP(CHP_HIST_LIST_BASE_BASE, port->hist_list_entry_base);
+	DLB_CSR_WR(hw, CHP_HIST_LIST_BASE(port->id), hl_base);
+
+	/*
+	 * The inflight limit sets a cap on the number of QEs for which this CQ
+	 * can owe completions at one time.
+	 */
+	reg = FIELD_PREP(LSP_CQ_LDB_INFL_LIM_LIMIT, args->cq_history_list_size);
+	DLB_CSR_WR(hw, LSP_CQ_LDB_INFL_LIM(port->id), reg);
+
+	reg = FIELD_PREP(CHP_HIST_LIST_PUSH_PTR_PUSH_PTR,
+		  FIELD_GET(CHP_HIST_LIST_BASE_BASE, hl_base));
+	DLB_CSR_WR(hw, CHP_HIST_LIST_PUSH_PTR(port->id), reg);
+
+	reg = FIELD_PREP(CHP_HIST_LIST_POP_PTR_POP_PTR,
+		  FIELD_GET(CHP_HIST_LIST_BASE_BASE, hl_base));
+	DLB_CSR_WR(hw, CHP_HIST_LIST_POP_PTR(port->id), reg);
+
+	/*
+	 * Address translation (AT) settings: 0: untranslated, 2: translated
+	 * (see ATS spec regarding Address Type field for more details)
+	 */
+
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_LDB_CQ_AT(port->id), reg);
+	DLB_CSR_WR(hw, SYS_LDB_CQ_PASID(port->id), reg);
+
+	reg = FIELD_PREP(CHP_LDB_CQ2VAS_CQ2VAS, domain->id);
+	DLB_CSR_WR(hw, CHP_LDB_CQ2VAS(port->id), reg);
+
+	/* Disable the port's QID mappings */
+	reg = 0;
+	DLB_CSR_WR(hw, LSP_CQ2PRIOV(port->id), reg);
+
+	return 0;
+}
+
+static int dlb_configure_ldb_port(struct dlb_hw *hw, struct dlb_hw_domain *domain,
+				  struct dlb_ldb_port *port,
+				  uintptr_t cq_dma_base,
+				  struct dlb_create_ldb_port_args *args)
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
+					args);
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
+	u32 reg;
+
+	reg = FIELD_PREP(SYS_DIR_PP2VAS_VAS, domain->id);
+	DLB_CSR_WR(hw, SYS_DIR_PP2VAS(port->id), reg);
+
+	reg = 0;
+	reg |= SYS_DIR_PP_V_PP_V;
+	DLB_CSR_WR(hw, SYS_DIR_PP_V(port->id), reg);
+}
+
+static int dlb_dir_port_configure_cq(struct dlb_hw *hw,
+				     struct dlb_hw_domain *domain,
+				     struct dlb_dir_pq_pair *port,
+				     uintptr_t cq_dma_base,
+				     struct dlb_create_dir_port_args *args)
+{
+	u32 reg;
+	u32 ds, n;
+
+	/* The CQ address is 64B-aligned, and the DLB only wants bits [63:6] */
+	reg = FIELD_PREP(SYS_DIR_CQ_ADDR_L_ADDR_L, cq_dma_base >> 6);
+	DLB_CSR_WR(hw, SYS_DIR_CQ_ADDR_L(port->id), reg);
+
+	reg = cq_dma_base >> 32;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_ADDR_U(port->id), reg);
+
+	/*
+	 * 'ro' == relaxed ordering. This setting allows DLB to write
+	 * cache lines out-of-order (but QEs within a cache line are always
+	 * updated in-order).
+	 */
+	reg = FIELD_PREP(SYS_DIR_CQ2VF_PF_RO_IS_PF, 1);
+	reg |= SYS_DIR_CQ2VF_PF_RO_RO;
+
+	DLB_CSR_WR(hw, SYS_DIR_CQ2VF_PF_RO(port->id), reg);
+
+	if (!dlb_cq_depth_is_valid(args->cq_depth)) {
+		dev_err(hw_to_dev(hw),
+			"[%s():%d] Internal error: invalid CQ depth\n",
+			__func__, __LINE__);
+		return -EINVAL;
+	}
+
+	if (args->cq_depth <= 8) {
+		ds = 1;
+	} else {
+		n = ilog2(args->cq_depth);
+		ds = (n - 2) & 0x0f;
+	}
+
+	reg = FIELD_PREP(CHP_DIR_CQ_TKN_DEPTH_SEL_TOKEN_DEPTH_SELECT, ds);
+	DLB_CSR_WR(hw, CHP_DIR_CQ_TKN_DEPTH_SEL(port->id), reg);
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
+		port->init_tkn_cnt = 8 - args->cq_depth;
+
+		reg = FIELD_PREP(LSP_CQ_DIR_TKN_CNT_COUNT, port->init_tkn_cnt);
+		DLB_CSR_WR(hw, LSP_CQ_DIR_TKN_CNT(port->id), reg);
+	} else {
+		DLB_CSR_WR(hw,
+			   LSP_CQ_DIR_TKN_CNT(port->id),
+			   LSP_CQ_DIR_TKN_CNT_RST);
+	}
+
+	reg = FIELD_PREP(LSP_CQ_DIR_TKN_DEPTH_SEL_DSI_TOKEN_DEPTH_SELECT, ds);
+	DLB_CSR_WR(hw, LSP_CQ_DIR_TKN_DEPTH_SEL_DSI(port->id), reg);
+
+	/* Reset the CQ write pointer */
+	DLB_CSR_WR(hw,
+		   CHP_DIR_CQ_WPTR(port->id),
+		   CHP_DIR_CQ_WPTR_RST);
+
+	/* Virtualize the PPID */
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_FMT(port->id), reg);
+
+	/*
+	 * Address translation (AT) settings: 0: untranslated, 2: translated
+	 * (see ATS spec regarding Address Type field for more details)
+	 */
+	reg = 0;
+	DLB_CSR_WR(hw, SYS_DIR_CQ_AT(port->id), reg);
+
+	DLB_CSR_WR(hw, SYS_DIR_CQ_PASID(port->id), reg);
+
+	reg = FIELD_PREP(CHP_DIR_CQ2VAS_CQ2VAS, domain->id);
+	DLB_CSR_WR(hw, CHP_DIR_CQ2VAS(port->id), reg);
+
+	return 0;
+}
+
+static int dlb_configure_dir_port(struct dlb_hw *hw, struct dlb_hw_domain *domain,
+				  struct dlb_dir_pq_pair *port,
+				  uintptr_t cq_dma_base,
+				  struct dlb_create_dir_port_args *args)
+{
+	int ret;
+
+	ret = dlb_dir_port_configure_cq(hw, domain, port, cq_dma_base,
+					args);
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
 				 struct dlb_create_sched_domain_args *args)
@@ -1503,6 +1793,11 @@ int dlb_hw_create_ldb_port(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	ret = dlb_configure_ldb_port(hw, domain, port, cq_dma_base,
+				     args);
+	if (ret)
+		return ret;
+
 	/*
 	 * Configuration succeeded, so move the resource from the 'avail' to
 	 * the 'used' list.
@@ -1571,6 +1866,11 @@ int dlb_hw_create_dir_port(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	ret = dlb_configure_dir_port(hw, domain, port, cq_dma_base,
+				     args);
+	if (ret)
+		return ret;
+
 	/*
 	 * Configuration succeeded, so move the resource from the 'avail' to
 	 * the 'used' list (if it's not already there).
@@ -1670,6 +1970,33 @@ static void dlb_drain_ldb_cq(struct dlb_hw *hw, struct dlb_ldb_port *port)
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
+				dev_err(hw_to_dev(hw),
+					"[%s()] Internal error: failed to flush load-balanced port %d's completions.\n",
+					__func__, port->id);
+				return -EFAULT;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /*
  * dlb_domain_reset_software_state() - returns domain's resources
  * @hw: dlb_hw handle for a particular device.
@@ -2348,7 +2675,10 @@ static u32 dlb_dir_cq_token_count(struct dlb_hw *hw,
 static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
 					   struct dlb_hw_domain *domain)
 {
+	struct dlb_dir_pq_pair *dir_port;
+	struct dlb_ldb_port *ldb_port;
 	struct dlb_ldb_queue *queue;
+	int i;
 
 	/*
 	 * Confirm that all the domain's queue's inflight counts and AQED
@@ -2363,6 +2693,35 @@ static int dlb_domain_verify_reset_success(struct dlb_hw *hw,
 		}
 	}
 
+	/* Confirm that all the domain's CQs inflight and token counts are 0. */
+	for (i = 0; i < DLB_NUM_COS_DOMAINS; i++) {
+		list_for_each_entry(ldb_port, &domain->used_ldb_ports[i], domain_list) {
+			if (dlb_ldb_cq_inflight_count(hw, ldb_port) ||
+			    dlb_ldb_cq_token_count(hw, ldb_port)) {
+				dev_err(hw_to_dev(hw),
+					"[%s()] Internal error: failed to empty ldb port %d\n",
+					__func__, ldb_port->id);
+				return -EFAULT;
+			}
+		}
+	}
+
+	list_for_each_entry(dir_port, &domain->used_dir_pq_pairs, domain_list) {
+		if (!dlb_dir_queue_is_empty(hw, dir_port)) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: failed to empty dir queue %d\n",
+				__func__, dir_port->id);
+			return -EFAULT;
+		}
+
+		if (dlb_dir_cq_token_count(hw, dir_port)) {
+			dev_err(hw_to_dev(hw),
+				"[%s()] Internal error: failed to empty dir port %d\n",
+				__func__, dir_port->id);
+			return -EFAULT;
+		}
+	}
+
 	return 0;
 }
 
@@ -2580,6 +2939,51 @@ static int dlb_domain_drain_dir_queues(struct dlb_hw *hw,
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
+		DLB_CSR_WR(hw, SYS_DIR_PP_V(port->id), pp_v);
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
+				   SYS_LDB_PP_V(port->id),
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
+				   CHP_SN_CHK_ENBL(port->id),
+				   chk_en);
+		}
+	}
+}
+
 static void
 dlb_domain_disable_ldb_queue_write_perms(struct dlb_hw *hw,
 					 struct dlb_hw_domain *domain)
@@ -2697,6 +3101,9 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 
 	dlb_domain_disable_ldb_queue_write_perms(hw, domain);
 
+	/* Turn off completion tracking on all the domain's PPs. */
+	dlb_domain_disable_ldb_seq_checks(hw, domain);
+
 	/*
 	 * Disable the LDB CQs and drain them in order to complete the map and
 	 * unmap procedures, which require zero CQ inflights and zero QID
@@ -2706,6 +3113,10 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
 
 	dlb_domain_drain_ldb_cqs(hw, domain, false);
 
+	ret = dlb_domain_wait_for_ldb_cqs_to_empty(hw, domain);
+	if (ret)
+		return ret;
+
 	/* Re-enable the CQs in order to drain the mapped queues. */
 	dlb_domain_enable_ldb_cqs(hw, domain);
 
@@ -2721,6 +3132,11 @@ int dlb_reset_domain(struct dlb_hw *hw, u32 domain_id)
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
@@ -2752,7 +3168,7 @@ void dlb_clr_pmcsr_disable(struct dlb_hw *hw)
 
 /**
  * dlb_hw_enable_sparse_ldb_cq_mode() - enable sparse mode for load-balanced
- *      ports.
+ *	ports.
  * @hw: dlb_hw handle for a particular device.
  *
  * This function must be called prior to configuring scheduling domains.
-- 
2.27.0

