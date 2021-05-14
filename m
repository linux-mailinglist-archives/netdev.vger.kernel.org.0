Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E9380B73
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhENORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:17:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:53038 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhENOQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:16:35 -0400
IronPort-SDR: gxFv6NWLdPlX9ZoxUTC/CV5CjSkaYcC5wVSg9oZl92eHBELHR3qW1WNju5q2S+KTMEzOgUPVWU
 vnfQ1lJ7hUDw==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199872551"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199872551"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:23 -0700
IronPort-SDR: WyoNoXg+5lBbcuZs6AtBu1zUXpQJJze3EWVBT1iVYrxwGiuQwPOQL03iGybEMBVzgUTNPhwAbc
 yK4BT6346x4Q==
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="542867772"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.97.94])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:21 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v5 16/22] RDMA/irdma: Add RoCEv2 UD OP support
Date:   Fri, 14 May 2021 09:12:08 -0500
Message-Id: <20210514141214.2120-17-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210514141214.2120-1-shiraz.saleem@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add the header, data structures and functions
to populate the WQE descriptors and issue the
Control QP commands that support RoCEv2 UD operations.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/uda.c   | 271 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/uda.h   |  89 ++++++++++++
 drivers/infiniband/hw/irdma/uda_d.h | 128 +++++++++++++++++
 3 files changed, 488 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/uda.c
 create mode 100644 drivers/infiniband/hw/irdma/uda.h
 create mode 100644 drivers/infiniband/hw/irdma/uda_d.h

diff --git a/drivers/infiniband/hw/irdma/uda.c b/drivers/infiniband/hw/irdma/uda.c
new file mode 100644
index 0000000..f5b1b61
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2016 - 2021 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+#include "uda.h"
+#include "uda_d.h"
+
+/**
+ * irdma_sc_access_ah() - Create, modify or delete AH
+ * @cqp: struct for cqp hw
+ * @info: ah information
+ * @op: Operation
+ * @scratch: u64 saved to be used during cqp completion
+ */
+enum irdma_status_code irdma_sc_access_ah(struct irdma_sc_cqp *cqp,
+					  struct irdma_ah_info *info,
+					  u32 op, u64 scratch)
+{
+	__le64 *wqe;
+	u64 qw1, qw2;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, ether_addr_to_u64(info->mac_addr) << 16);
+	qw1 = FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_PDINDEXLO, info->pd_idx) |
+	      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_TC, info->tc_tos) |
+	      FIELD_PREP(IRDMA_UDAQPC_VLANTAG, info->vlan_tag);
+
+	qw2 = FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ARPINDEX, info->dst_arpindex) |
+	      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_FLOWLABEL, info->flow_label) |
+	      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_HOPLIMIT, info->hop_ttl) |
+	      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_PDINDEXHI, info->pd_idx >> 16);
+
+	if (!info->ipv4_valid) {
+		set_64bit_val(wqe, 40,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR0, info->dest_ip_addr[0]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR1, info->dest_ip_addr[1]));
+		set_64bit_val(wqe, 32,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR2, info->dest_ip_addr[2]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->dest_ip_addr[3]));
+
+		set_64bit_val(wqe, 56,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR0, info->src_ip_addr[0]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR1, info->src_ip_addr[1]));
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR2, info->src_ip_addr[2]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->src_ip_addr[3]));
+	} else {
+		set_64bit_val(wqe, 32,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->dest_ip_addr[0]));
+
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->src_ip_addr[0]));
+	}
+
+	set_64bit_val(wqe, 8, qw1);
+	set_64bit_val(wqe, 16, qw2);
+
+	dma_wmb(); /* need write block before writing WQE header */
+
+	set_64bit_val(
+		wqe, 24,
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_WQEVALID, cqp->polarity) |
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_OPCODE, op) |
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK, info->do_lpbk) |
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_IPV4VALID, info->ipv4_valid) |
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_AVIDX, info->ah_idx) |
+		FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG, info->insert_vlan_tag));
+
+	print_hex_dump_debug("WQE: MANAGE_AH WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_create_mg_ctx() - create a mcg context
+ * @info: multicast group context info
+ */
+static enum irdma_status_code
+irdma_create_mg_ctx(struct irdma_mcast_grp_info *info)
+{
+	struct irdma_mcast_grp_ctx_entry_info *entry_info = NULL;
+	u8 idx = 0; /* index in the array */
+	u8 ctx_idx = 0; /* index in the MG context */
+
+	memset(info->dma_mem_mc.va, 0, IRDMA_MAX_MGS_PER_CTX * sizeof(u64));
+
+	for (idx = 0; idx < IRDMA_MAX_MGS_PER_CTX; idx++) {
+		entry_info = &info->mg_ctx_info[idx];
+		if (entry_info->valid_entry) {
+			set_64bit_val((__le64 *)info->dma_mem_mc.va,
+				      ctx_idx * sizeof(u64),
+				      FIELD_PREP(IRDMA_UDA_MGCTX_DESTPORT, entry_info->dest_port) |
+				      FIELD_PREP(IRDMA_UDA_MGCTX_VALIDENT, entry_info->valid_entry) |
+				      FIELD_PREP(IRDMA_UDA_MGCTX_QPID, entry_info->qp_id));
+			ctx_idx++;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_access_mcast_grp() - Access mcast group based on op
+ * @cqp: Control QP
+ * @info: multicast group context info
+ * @op: operation to perform
+ * @scratch: u64 saved to be used during cqp completion
+ */
+enum irdma_status_code irdma_access_mcast_grp(struct irdma_sc_cqp *cqp,
+					      struct irdma_mcast_grp_info *info,
+					      u32 op, u64 scratch)
+{
+	__le64 *wqe;
+	enum irdma_status_code ret_code = 0;
+
+	if (info->mg_id >= IRDMA_UDA_MAX_FSI_MGS) {
+		ibdev_dbg(to_ibdev(cqp->dev), "WQE: mg_id out of range\n");
+		return IRDMA_ERR_PARAM;
+	}
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe) {
+		ibdev_dbg(to_ibdev(cqp->dev), "WQE: ring full\n");
+		return IRDMA_ERR_RING_FULL;
+	}
+
+	ret_code = irdma_create_mg_ctx(info);
+	if (ret_code)
+		return ret_code;
+
+	set_64bit_val(wqe, 32, info->dma_mem_mc.pa);
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_VLANID, info->vlan_id) |
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_QS_HANDLE, info->qs_handle));
+	set_64bit_val(wqe, 0, ether_addr_to_u64(info->dest_mac_addr));
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID, info->hmc_fcn_id));
+
+	if (!info->ipv4_valid) {
+		set_64bit_val(wqe, 56,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR0, info->dest_ip_addr[0]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR1, info->dest_ip_addr[1]));
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR2, info->dest_ip_addr[2]) |
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->dest_ip_addr[3]));
+	} else {
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_UDA_CQPSQ_MAV_ADDR3, info->dest_ip_addr[0]));
+	}
+
+	dma_wmb(); /* need write memory block before writing the WQE header. */
+
+	set_64bit_val(wqe, 24,
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_WQEVALID, cqp->polarity) |
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_OPCODE, op) |
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_MGIDX, info->mg_id) |
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_VLANVALID, info->vlan_valid) |
+		      FIELD_PREP(IRDMA_UDA_CQPSQ_MG_IPV4VALID, info->ipv4_valid));
+
+	print_hex_dump_debug("WQE: MANAGE_MCG WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	print_hex_dump_debug("WQE: MCG_HOST CTX WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, info->dma_mem_mc.va,
+			     IRDMA_MAX_MGS_PER_CTX * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_compare_mgs - Compares two multicast group structures
+ * @entry1: Multcast group info
+ * @entry2: Multcast group info in context
+ */
+static bool irdma_compare_mgs(struct irdma_mcast_grp_ctx_entry_info *entry1,
+			      struct irdma_mcast_grp_ctx_entry_info *entry2)
+{
+	if (entry1->dest_port == entry2->dest_port &&
+	    entry1->qp_id == entry2->qp_id)
+		return true;
+
+	return false;
+}
+
+/**
+ * irdma_sc_add_mcast_grp - Allocates mcast group entry in ctx
+ * @ctx: Multcast group context
+ * @mg: Multcast group info
+ */
+enum irdma_status_code irdma_sc_add_mcast_grp(struct irdma_mcast_grp_info *ctx,
+					      struct irdma_mcast_grp_ctx_entry_info *mg)
+{
+	u32 idx;
+	bool free_entry_found = false;
+	u32 free_entry_idx = 0;
+
+	/* find either an identical or a free entry for a multicast group */
+	for (idx = 0; idx < IRDMA_MAX_MGS_PER_CTX; idx++) {
+		if (ctx->mg_ctx_info[idx].valid_entry) {
+			if (irdma_compare_mgs(&ctx->mg_ctx_info[idx], mg)) {
+				ctx->mg_ctx_info[idx].use_cnt++;
+				return 0;
+			}
+			continue;
+		}
+		if (!free_entry_found) {
+			free_entry_found = true;
+			free_entry_idx = idx;
+		}
+	}
+
+	if (free_entry_found) {
+		ctx->mg_ctx_info[free_entry_idx] = *mg;
+		ctx->mg_ctx_info[free_entry_idx].valid_entry = true;
+		ctx->mg_ctx_info[free_entry_idx].use_cnt = 1;
+		ctx->no_of_mgs++;
+		return 0;
+	}
+
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_sc_del_mcast_grp - Delete mcast group
+ * @ctx: Multcast group context
+ * @mg: Multcast group info
+ *
+ * Finds and removes a specific mulicast group from context, all
+ * parameters must match to remove a multicast group.
+ */
+enum irdma_status_code irdma_sc_del_mcast_grp(struct irdma_mcast_grp_info *ctx,
+					      struct irdma_mcast_grp_ctx_entry_info *mg)
+{
+	u32 idx;
+
+	/* find an entry in multicast group context */
+	for (idx = 0; idx < IRDMA_MAX_MGS_PER_CTX; idx++) {
+		if (!ctx->mg_ctx_info[idx].valid_entry)
+			continue;
+
+		if (irdma_compare_mgs(mg, &ctx->mg_ctx_info[idx])) {
+			ctx->mg_ctx_info[idx].use_cnt--;
+
+			if (!ctx->mg_ctx_info[idx].use_cnt) {
+				ctx->mg_ctx_info[idx].valid_entry = false;
+				ctx->no_of_mgs--;
+				/* Remove gap if element was not the last */
+				if (idx != ctx->no_of_mgs &&
+				    ctx->no_of_mgs > 0) {
+					memcpy(&ctx->mg_ctx_info[idx],
+					       &ctx->mg_ctx_info[ctx->no_of_mgs - 1],
+					       sizeof(ctx->mg_ctx_info[idx]));
+					ctx->mg_ctx_info[ctx->no_of_mgs - 1].valid_entry = false;
+				}
+			}
+
+			return 0;
+		}
+	}
+
+	return IRDMA_ERR_PARAM;
+}
diff --git a/drivers/infiniband/hw/irdma/uda.h b/drivers/infiniband/hw/irdma/uda.h
new file mode 100644
index 0000000..a4ad036
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2016 - 2021 Intel Corporation */
+#ifndef IRDMA_UDA_H
+#define IRDMA_UDA_H
+
+#define IRDMA_UDA_MAX_FSI_MGS	4096
+#define IRDMA_UDA_MAX_PFS	16
+#define IRDMA_UDA_MAX_VFS	128
+
+struct irdma_sc_cqp;
+
+struct irdma_ah_info {
+	struct irdma_sc_vsi *vsi;
+	u32 pd_idx;
+	u32 dst_arpindex;
+	u32 dest_ip_addr[4];
+	u32 src_ip_addr[4];
+	u32 flow_label;
+	u32 ah_idx;
+	u16 vlan_tag;
+	u8 insert_vlan_tag;
+	u8 tc_tos;
+	u8 hop_ttl;
+	u8 mac_addr[ETH_ALEN];
+	bool ah_valid:1;
+	bool ipv4_valid:1;
+	bool do_lpbk:1;
+};
+
+struct irdma_sc_ah {
+	struct irdma_sc_dev *dev;
+	struct irdma_ah_info ah_info;
+};
+
+enum irdma_status_code irdma_sc_add_mcast_grp(struct irdma_mcast_grp_info *ctx,
+					      struct irdma_mcast_grp_ctx_entry_info *mg);
+enum irdma_status_code irdma_sc_del_mcast_grp(struct irdma_mcast_grp_info *ctx,
+					      struct irdma_mcast_grp_ctx_entry_info *mg);
+enum irdma_status_code irdma_sc_access_ah(struct irdma_sc_cqp *cqp, struct irdma_ah_info *info,
+					  u32 op, u64 scratch);
+enum irdma_status_code irdma_access_mcast_grp(struct irdma_sc_cqp *cqp,
+					      struct irdma_mcast_grp_info *info,
+					      u32 op, u64 scratch);
+
+static inline void irdma_sc_init_ah(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah)
+{
+	ah->dev = dev;
+}
+
+static inline enum irdma_status_code irdma_sc_create_ah(struct irdma_sc_cqp *cqp,
+							struct irdma_ah_info *info,
+							u64 scratch)
+{
+	return irdma_sc_access_ah(cqp, info, IRDMA_CQP_OP_CREATE_ADDR_HANDLE,
+				  scratch);
+}
+
+static inline enum irdma_status_code irdma_sc_destroy_ah(struct irdma_sc_cqp *cqp,
+							 struct irdma_ah_info *info,
+							 u64 scratch)
+{
+	return irdma_sc_access_ah(cqp, info, IRDMA_CQP_OP_DESTROY_ADDR_HANDLE,
+				  scratch);
+}
+
+static inline enum irdma_status_code irdma_sc_create_mcast_grp(struct irdma_sc_cqp *cqp,
+							       struct irdma_mcast_grp_info *info,
+							       u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_CREATE_MCAST_GRP,
+				      scratch);
+}
+
+static inline enum irdma_status_code irdma_sc_modify_mcast_grp(struct irdma_sc_cqp *cqp,
+							       struct irdma_mcast_grp_info *info,
+							       u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_MODIFY_MCAST_GRP,
+				      scratch);
+}
+
+static inline enum irdma_status_code irdma_sc_destroy_mcast_grp(struct irdma_sc_cqp *cqp,
+								struct irdma_mcast_grp_info *info,
+								u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_DESTROY_MCAST_GRP,
+				      scratch);
+}
+#endif /* IRDMA_UDA_H */
diff --git a/drivers/infiniband/hw/irdma/uda_d.h b/drivers/infiniband/hw/irdma/uda_d.h
new file mode 100644
index 0000000..bfc81ca
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda_d.h
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2016 - 2021 Intel Corporation */
+#ifndef IRDMA_UDA_D_H
+#define IRDMA_UDA_D_H
+
+/* L4 packet type */
+#define IRDMA_E_UDA_SQ_L4T_UNKNOWN	0
+#define IRDMA_E_UDA_SQ_L4T_TCP		1
+#define IRDMA_E_UDA_SQ_L4T_SCTP		2
+#define IRDMA_E_UDA_SQ_L4T_UDP		3
+
+/* Inner IP header type */
+#define IRDMA_E_UDA_SQ_IIPT_UNKNOWN		0
+#define IRDMA_E_UDA_SQ_IIPT_IPV6		1
+#define IRDMA_E_UDA_SQ_IIPT_IPV4_NO_CSUM	2
+#define IRDMA_E_UDA_SQ_IIPT_IPV4_CSUM		3
+#define IRDMA_UDA_QPSQ_PUSHWQE BIT_ULL(56)
+#define IRDMA_UDA_QPSQ_INLINEDATAFLAG BIT_ULL(57)
+#define IRDMA_UDA_QPSQ_INLINEDATALEN GENMASK_ULL(55, 48)
+#define IRDMA_UDA_QPSQ_ADDFRAGCNT GENMASK_ULL(41, 38)
+#define IRDMA_UDA_QPSQ_IPFRAGFLAGS GENMASK_ULL(43, 42)
+#define IRDMA_UDA_QPSQ_NOCHECKSUM BIT_ULL(45)
+#define IRDMA_UDA_QPSQ_AHIDXVALID BIT_ULL(46)
+#define IRDMA_UDA_QPSQ_LOCAL_FENCE BIT_ULL(61)
+#define IRDMA_UDA_QPSQ_AHIDX GENMASK_ULL(16, 0)
+#define IRDMA_UDA_QPSQ_PROTOCOL GENMASK_ULL(23, 16)
+#define IRDMA_UDA_QPSQ_EXTHDRLEN GENMASK_ULL(40, 32)
+#define IRDMA_UDA_QPSQ_MULTICAST BIT_ULL(63)
+#define IRDMA_UDA_QPSQ_MACLEN GENMASK_ULL(62, 56)
+#define IRDMA_UDA_QPSQ_MACLEN_LINE 2
+#define IRDMA_UDA_QPSQ_IPLEN GENMASK_ULL(54, 48)
+#define IRDMA_UDA_QPSQ_IPLEN_LINE 2
+#define IRDMA_UDA_QPSQ_L4T GENMASK_ULL(31, 30)
+#define IRDMA_UDA_QPSQ_L4T_LINE 2
+#define IRDMA_UDA_QPSQ_IIPT GENMASK_ULL(29, 28)
+#define IRDMA_UDA_QPSQ_IIPT_LINE 2
+
+#define IRDMA_UDA_QPSQ_DO_LPB_LINE 3
+#define IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM BIT_ULL(45)
+#define IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM_LINE 3
+#define IRDMA_UDA_QPSQ_IMMDATA GENMASK_ULL(63, 0)
+
+/* Byte Offset 0 */
+#define IRDMA_UDAQPC_IPV4_M BIT_ULL(3)
+#define IRDMA_UDAQPC_INSERTVLANTAG BIT_ULL(5)
+#define IRDMA_UDAQPC_ISQP1 BIT_ULL(6)
+
+#define IRDMA_UDAQPC_ECNENABLE BIT_ULL(14)
+#define IRDMA_UDAQPC_PDINDEXHI GENMASK_ULL(21, 20)
+#define IRDMA_UDAQPC_DCTCPENABLE BIT_ULL(25)
+
+#define IRDMA_UDAQPC_RCVTPHEN IRDMAQPC_RCVTPHEN
+#define IRDMA_UDAQPC_XMITTPHEN IRDMAQPC_XMITTPHEN
+#define IRDMA_UDAQPC_RQTPHEN IRDMAQPC_RQTPHEN
+#define IRDMA_UDAQPC_SQTPHEN IRDMAQPC_SQTPHEN
+#define IRDMA_UDAQPC_PPIDX IRDMAQPC_PPIDX
+#define IRDMA_UDAQPC_PMENA IRDMAQPC_PMENA
+#define IRDMA_UDAQPC_INSERTTAG2 BIT_ULL(11)
+#define IRDMA_UDAQPC_INSERTTAG3 BIT_ULL(14)
+
+#define IRDMA_UDAQPC_RQSIZE IRDMAQPC_RQSIZE
+#define IRDMA_UDAQPC_SQSIZE IRDMAQPC_SQSIZE
+#define IRDMA_UDAQPC_TXCQNUM IRDMAQPC_TXCQNUM
+#define IRDMA_UDAQPC_RXCQNUM IRDMAQPC_RXCQNUM
+#define IRDMA_UDAQPC_QPCOMPCTX IRDMAQPC_QPCOMPCTX
+#define IRDMA_UDAQPC_SQTPHVAL IRDMAQPC_SQTPHVAL
+#define IRDMA_UDAQPC_RQTPHVAL IRDMAQPC_RQTPHVAL
+#define IRDMA_UDAQPC_QSHANDLE IRDMAQPC_QSHANDLE
+#define IRDMA_UDAQPC_RQHDRRINGBUFSIZE GENMASK_ULL(49, 48)
+#define IRDMA_UDAQPC_SQHDRRINGBUFSIZE GENMASK_ULL(33, 32)
+#define IRDMA_UDAQPC_PRIVILEGEENABLE BIT_ULL(25)
+#define IRDMA_UDAQPC_USE_STATISTICS_INSTANCE BIT_ULL(26)
+#define IRDMA_UDAQPC_STATISTICS_INSTANCE_INDEX GENMASK_ULL(6, 0)
+#define IRDMA_UDAQPC_PRIVHDRGENENABLE BIT_ULL(0)
+#define IRDMA_UDAQPC_RQHDRSPLITENABLE BIT_ULL(3)
+#define IRDMA_UDAQPC_RQHDRRINGBUFENABLE BIT_ULL(2)
+#define IRDMA_UDAQPC_SQHDRRINGBUFENABLE BIT_ULL(1)
+#define IRDMA_UDAQPC_IPID GENMASK_ULL(47, 32)
+#define IRDMA_UDAQPC_SNDMSS GENMASK_ULL(29, 16)
+#define IRDMA_UDAQPC_VLANTAG GENMASK_ULL(15, 0)
+
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXHI GENMASK_ULL(21, 20)
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXLO GENMASK_ULL(63, 48)
+#define IRDMA_UDA_CQPSQ_MAV_SRCMACADDRINDEX GENMASK_ULL(29, 24)
+#define IRDMA_UDA_CQPSQ_MAV_ARPINDEX GENMASK_ULL(63, 48)
+#define IRDMA_UDA_CQPSQ_MAV_TC GENMASK_ULL(39, 32)
+#define IRDMA_UDA_CQPSQ_MAV_HOPLIMIT GENMASK_ULL(39, 32)
+#define IRDMA_UDA_CQPSQ_MAV_FLOWLABEL GENMASK_ULL(19, 0)
+#define IRDMA_UDA_CQPSQ_MAV_ADDR0 GENMASK_ULL(63, 32)
+#define IRDMA_UDA_CQPSQ_MAV_ADDR1 GENMASK_ULL(31, 0)
+#define IRDMA_UDA_CQPSQ_MAV_ADDR2 GENMASK_ULL(63, 32)
+#define IRDMA_UDA_CQPSQ_MAV_ADDR3 GENMASK_ULL(31, 0)
+#define IRDMA_UDA_CQPSQ_MAV_WQEVALID BIT_ULL(63)
+#define IRDMA_UDA_CQPSQ_MAV_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK BIT_ULL(62)
+#define IRDMA_UDA_CQPSQ_MAV_IPV4VALID BIT_ULL(59)
+#define IRDMA_UDA_CQPSQ_MAV_AVIDX GENMASK_ULL(16, 0)
+#define IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG BIT_ULL(60)
+#define IRDMA_UDA_MGCTX_VFFLAG BIT_ULL(29)
+#define IRDMA_UDA_MGCTX_DESTPORT GENMASK_ULL(47, 32)
+#define IRDMA_UDA_MGCTX_VFID GENMASK_ULL(28, 22)
+#define IRDMA_UDA_MGCTX_VALIDENT BIT_ULL(31)
+#define IRDMA_UDA_MGCTX_PFID GENMASK_ULL(21, 18)
+#define IRDMA_UDA_MGCTX_FLAGIGNOREDPORT BIT_ULL(30)
+#define IRDMA_UDA_MGCTX_QPID GENMASK_ULL(17, 0)
+#define IRDMA_UDA_CQPSQ_MG_WQEVALID BIT_ULL(63)
+#define IRDMA_UDA_CQPSQ_MG_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_UDA_CQPSQ_MG_MGIDX GENMASK_ULL(12, 0)
+#define IRDMA_UDA_CQPSQ_MG_IPV4VALID BIT_ULL(60)
+#define IRDMA_UDA_CQPSQ_MG_VLANVALID BIT_ULL(59)
+#define IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID GENMASK_ULL(5, 0)
+#define IRDMA_UDA_CQPSQ_MG_VLANID GENMASK_ULL(43, 32)
+#define IRDMA_UDA_CQPSQ_QS_HANDLE GENMASK_ULL(9, 0)
+#define IRDMA_UDA_CQPSQ_QHASH_QPN GENMASK_ULL(49, 32)
+#define IRDMA_UDA_CQPSQ_QHASH_ BIT_ULL(0)
+#define IRDMA_UDA_CQPSQ_QHASH_SRC_PORT GENMASK_ULL(31, 16)
+#define IRDMA_UDA_CQPSQ_QHASH_DEST_PORT GENMASK_ULL(15, 0)
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR0 GENMASK_ULL(63, 32)
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR1 GENMASK_ULL(31, 0)
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR2 GENMASK_ULL(63, 32)
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR3 GENMASK_ULL(31, 0)
+#define IRDMA_UDA_CQPSQ_QHASH_WQEVALID BIT_ULL(63)
+#define IRDMA_UDA_CQPSQ_QHASH_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_UDA_CQPSQ_QHASH_MANAGE GENMASK_ULL(62, 61)
+#define IRDMA_UDA_CQPSQ_QHASH_IPV4VALID GENMASK_ULL(60, 60)
+#define IRDMA_UDA_CQPSQ_QHASH_LANFWD GENMASK_ULL(59, 59)
+#define IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE GENMASK_ULL(44, 42)
+#endif /* IRDMA_UDA_D_H */
-- 
1.8.3.1

