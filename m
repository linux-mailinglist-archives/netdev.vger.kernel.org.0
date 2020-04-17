Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D081AE36F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgDQRNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:30122 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbgDQRNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:18 -0400
IronPort-SDR: y7DFSBzGX1p5WT2s119yfNaeEeodyH+umcQtLSaZ4HZKoQN5CuByW8WT0RyG8qLDxyoBWBP8He
 ctDVkl9138wQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:57 -0700
IronPort-SDR: dUlFi3dDd89kJZg0HQ7knO3APx8P8QTtclgqcp4BZo/koZgKUogn9Q0QcfbZ7Ly3F/Gtx+RsIr
 edwCUQ35G5kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383737"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:56 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 10/16] RDMA/irdma: Add RoCEv2 UD OP support
Date:   Fri, 17 Apr 2020 10:12:45 -0700
Message-Id: <20200417171251.1533371-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
 drivers/infiniband/hw/irdma/uda.c   | 390 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/uda.h   |  64 +++++
 drivers/infiniband/hw/irdma/uda_d.h | 382 +++++++++++++++++++++++++++
 3 files changed, 836 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/uda.c
 create mode 100644 drivers/infiniband/hw/irdma/uda.h
 create mode 100644 drivers/infiniband/hw/irdma/uda_d.h

diff --git a/drivers/infiniband/hw/irdma/uda.c b/drivers/infiniband/hw/irdma/uda.c
new file mode 100644
index 000000000000..08c9f486491e
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda.c
@@ -0,0 +1,390 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019 Intel Corporation */
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
+ * irdma_sc_ah_init - initialize sc ah struct
+ * @dev: sc device struct
+ * @ah: sc ah ptr
+ */
+static void irdma_sc_init_ah(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah)
+{
+	ah->dev = dev;
+}
+
+/**
+ * irdma_sc_access_ah() - Create, modify or delete AH
+ * @cqp: struct for cqp hw
+ * @info: ah information
+ * @op: Operation
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_access_ah(struct irdma_sc_cqp *cqp,
+						 struct irdma_ah_info *info,
+						 u32 op, u64 scratch)
+{
+	__le64 *wqe;
+	u64 qw1, qw2;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, LS_64_1(info->mac_addr[5], 16) |
+					 LS_64_1(info->mac_addr[4], 24) |
+					 LS_64_1(info->mac_addr[3], 32) |
+					 LS_64_1(info->mac_addr[2], 40) |
+					 LS_64_1(info->mac_addr[1], 48) |
+					 LS_64_1(info->mac_addr[0], 56));
+
+	qw1 = LS_64(info->pd_idx, IRDMA_UDA_CQPSQ_MAV_PDINDEXLO) |
+	      LS_64(info->tc_tos, IRDMA_UDA_CQPSQ_MAV_TC) |
+	      LS_64(info->vlan_tag, IRDMA_UDAQPC_VLANTAG);
+
+	qw2 = LS_64(info->dst_arpindex, IRDMA_UDA_CQPSQ_MAV_ARPINDEX) |
+	      LS_64(info->flow_label, IRDMA_UDA_CQPSQ_MAV_FLOWLABEL) |
+	      LS_64(info->hop_ttl, IRDMA_UDA_CQPSQ_MAV_HOPLIMIT) |
+	      LS_64(info->pd_idx >> 16, IRDMA_UDA_CQPSQ_MAV_PDINDEXHI);
+
+	if (!info->ipv4_valid) {
+		set_64bit_val(wqe, 40,
+			      LS_64(info->dest_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR0) |
+			      LS_64(info->dest_ip_addr[1], IRDMA_UDA_CQPSQ_MAV_ADDR1));
+		set_64bit_val(wqe, 32,
+			      LS_64(info->dest_ip_addr[2], IRDMA_UDA_CQPSQ_MAV_ADDR2) |
+			      LS_64(info->dest_ip_addr[3], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+
+		set_64bit_val(wqe, 56,
+			      LS_64(info->src_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR0) |
+			      LS_64(info->src_ip_addr[1], IRDMA_UDA_CQPSQ_MAV_ADDR1));
+		set_64bit_val(wqe, 48,
+			      LS_64(info->src_ip_addr[2], IRDMA_UDA_CQPSQ_MAV_ADDR2) |
+			      LS_64(info->src_ip_addr[3], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+	} else {
+		set_64bit_val(wqe, 32,
+			      LS_64(info->dest_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+
+		set_64bit_val(wqe, 48,
+			      LS_64(info->src_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+	}
+
+	set_64bit_val(wqe, 8, qw1);
+	set_64bit_val(wqe, 16, qw2);
+
+	dma_wmb(); /* need write block before writing WQE header */
+
+	set_64bit_val(
+		wqe, 24,
+		LS_64(cqp->polarity, IRDMA_UDA_CQPSQ_MAV_WQEVALID) |
+		LS_64(op, IRDMA_UDA_CQPSQ_MAV_OPCODE) |
+		LS_64(info->do_lpbk, IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK) |
+		LS_64(info->ipv4_valid, IRDMA_UDA_CQPSQ_MAV_IPV4VALID) |
+		LS_64(info->ah_idx, IRDMA_UDA_CQPSQ_MAV_AVIDX) |
+		LS_64(info->insert_vlan_tag,
+		      IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG));
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_AH WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_create_ah() - Create AH
+ * @cqp: struct for cqp hw
+ * @info: ah information
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_create_ah(struct irdma_sc_cqp *cqp,
+						 struct irdma_ah_info *info,
+						 u64 scratch)
+{
+	return irdma_sc_access_ah(cqp, info, IRDMA_CQP_OP_CREATE_ADDR_HANDLE,
+				  scratch);
+}
+
+/**
+ * irdma_sc_modify_ah() - Modify AH
+ * @cqp: struct for cqp hw
+ * @info: ah information
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_modify_ah(struct irdma_sc_cqp *cqp,
+						 struct irdma_ah_info *info,
+						 u64 scratch)
+{
+	return irdma_sc_access_ah(cqp, info, IRDMA_CQP_OP_MODIFY_ADDR_HANDLE,
+				  scratch);
+}
+
+/**
+ * irdma_sc_destroy_ah() - Delete AH
+ * @cqp: struct for cqp hw
+ * @info: ah information
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_destroy_ah(struct irdma_sc_cqp *cqp,
+						  struct irdma_ah_info *info,
+						  u64 scratch)
+{
+	return irdma_sc_access_ah(cqp, info, IRDMA_CQP_OP_DESTROY_ADDR_HANDLE,
+				  scratch);
+}
+
+/**
+ * create_mg_ctx() - create a mcg context
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
+				      LS_64(entry_info->dest_port, IRDMA_UDA_MGCTX_DESTPORT) |
+				      LS_64(entry_info->valid_entry, IRDMA_UDA_MGCTX_VALIDENT) |
+				      LS_64(entry_info->qp_id, IRDMA_UDA_MGCTX_QPID));
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
+static enum irdma_status_code
+irdma_access_mcast_grp(struct irdma_sc_cqp *cqp,
+		       struct irdma_mcast_grp_info *info, u32 op, u64 scratch)
+{
+	__le64 *wqe;
+	enum irdma_status_code ret_code = 0;
+
+	if (info->mg_id >= IRDMA_UDA_MAX_FSI_MGS) {
+		dev_dbg(rfdev_to_dev(cqp->dev), "WQE: mg_id out of range\n");
+		return IRDMA_ERR_PARAM;
+	}
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe) {
+		dev_dbg(rfdev_to_dev(cqp->dev), "WQE: ring full\n");
+		return IRDMA_ERR_RING_FULL;
+	}
+
+	ret_code = irdma_create_mg_ctx(info);
+	if (ret_code)
+		return ret_code;
+
+	set_64bit_val(wqe, 32, info->dma_mem_mc.pa);
+	set_64bit_val(wqe, 16,
+		      LS_64(info->vlan_id, IRDMA_UDA_CQPSQ_MG_VLANID) |
+		      LS_64(info->qs_handle, IRDMA_UDA_CQPSQ_QS_HANDLE));
+	set_64bit_val(wqe, 0, LS_64_1(info->dest_mac_addr[5], 0) |
+					 LS_64_1(info->dest_mac_addr[4], 8) |
+					 LS_64_1(info->dest_mac_addr[3], 16) |
+					 LS_64_1(info->dest_mac_addr[2], 24) |
+					 LS_64_1(info->dest_mac_addr[1], 32) |
+					 LS_64_1(info->dest_mac_addr[0], 40));
+	set_64bit_val(wqe, 8,
+		      LS_64(info->hmc_fcn_id, IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID));
+
+	if (!info->ipv4_valid) {
+		set_64bit_val(wqe, 56,
+			      LS_64(info->dest_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR0) |
+			      LS_64(info->dest_ip_addr[1], IRDMA_UDA_CQPSQ_MAV_ADDR1));
+		set_64bit_val(wqe, 48,
+			      LS_64(info->dest_ip_addr[2], IRDMA_UDA_CQPSQ_MAV_ADDR2) |
+			      LS_64(info->dest_ip_addr[3], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+	} else {
+		set_64bit_val(wqe, 48,
+			      LS_64(info->dest_ip_addr[0], IRDMA_UDA_CQPSQ_MAV_ADDR3));
+	}
+
+	dma_wmb(); /* need write memory block before writing the WQE header. */
+
+	set_64bit_val(wqe, 24,
+		      LS_64(cqp->polarity, IRDMA_UDA_CQPSQ_MG_WQEVALID) |
+		      LS_64(op, IRDMA_UDA_CQPSQ_MG_OPCODE) |
+		      LS_64(info->mg_id, IRDMA_UDA_CQPSQ_MG_MGIDX) |
+		      LS_64(info->vlan_valid, IRDMA_UDA_CQPSQ_MG_VLANVALID) |
+		      LS_64(info->ipv4_valid, IRDMA_UDA_CQPSQ_MG_IPV4VALID));
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_MCG WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MCG_HOST CTX WQE",
+			info->dma_mem_mc.va, IRDMA_MAX_MGS_PER_CTX * 8);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_create_mcast_grp() - Create mcast group.
+ * @cqp: Control QP
+ * @info: multicast group context info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_create_mcast_grp(struct irdma_sc_cqp *cqp,
+			  struct irdma_mcast_grp_info *info, u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_CREATE_MCAST_GRP,
+				      scratch);
+}
+
+/**
+ * irdma_sc_modify_mcast_grp() - Modify mcast group
+ * @cqp: Control QP
+ * @info: multicast group context info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_modify_mcast_grp(struct irdma_sc_cqp *cqp,
+			  struct irdma_mcast_grp_info *info, u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_MODIFY_MCAST_GRP,
+				      scratch);
+}
+
+/**
+ * irdma_sc_destroy_mcast_grp() - Destroys mcast group
+ * @cqp: Control QP
+ * @info: multicast group context info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_destroy_mcast_grp(struct irdma_sc_cqp *cqp,
+			   struct irdma_mcast_grp_info *info, u64 scratch)
+{
+	return irdma_access_mcast_grp(cqp, info, IRDMA_CQP_OP_DESTROY_MCAST_GRP,
+				      scratch);
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
+static enum irdma_status_code
+irdma_sc_add_mcast_grp(struct irdma_mcast_grp_info *ctx,
+		       struct irdma_mcast_grp_ctx_entry_info *mg)
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
+static enum irdma_status_code
+irdma_sc_del_mcast_grp(struct irdma_mcast_grp_info *ctx,
+		       struct irdma_mcast_grp_ctx_entry_info *mg)
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
+
+struct irdma_uda_ops irdma_uda_ops = {
+	.create_ah = irdma_sc_create_ah,
+	.destroy_ah = irdma_sc_destroy_ah,
+	.init_ah = irdma_sc_init_ah,
+	.mcast_grp_add = irdma_sc_add_mcast_grp,
+	.mcast_grp_create = irdma_sc_create_mcast_grp,
+	.mcast_grp_del = irdma_sc_del_mcast_grp,
+	.mcast_grp_destroy = irdma_sc_destroy_mcast_grp,
+	.mcast_grp_modify = irdma_sc_modify_mcast_grp,
+	.modify_ah = irdma_sc_modify_ah,
+};
diff --git a/drivers/infiniband/hw/irdma/uda.h b/drivers/infiniband/hw/irdma/uda.h
new file mode 100644
index 000000000000..71c399048a57
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#ifndef IRDMA_UDA_H
+#define IRDMA_UDA_H
+
+extern struct irdma_uda_ops irdma_uda_ops;
+
+#define IRDMA_UDA_MAX_FSI_MGS	4096
+#define IRDMA_UDA_MAX_PFS	16
+#define IRDMA_UDA_MAX_VFS	128
+
+struct irdma_sc_cqp;
+
+struct irdma_ah_info {
+	struct irdma_sc_ah *ah;
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
+struct irdma_uda_ops {
+	void (*init_ah)(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah);
+	enum irdma_status_code (*create_ah)(struct irdma_sc_cqp *cqp,
+					    struct irdma_ah_info *info,
+					    u64 scratch);
+	enum irdma_status_code (*modify_ah)(struct irdma_sc_cqp *cqp,
+					    struct irdma_ah_info *info,
+					    u64 scratch);
+	enum irdma_status_code (*destroy_ah)(struct irdma_sc_cqp *cqp,
+					     struct irdma_ah_info *info,
+					     u64 scratch);
+	/* multicast */
+	enum irdma_status_code (*mcast_grp_create)(struct irdma_sc_cqp *cqp,
+						   struct irdma_mcast_grp_info *info,
+						   u64 scratch);
+	enum irdma_status_code (*mcast_grp_modify)(struct irdma_sc_cqp *cqp,
+						   struct irdma_mcast_grp_info *info,
+						   u64 scratch);
+	enum irdma_status_code (*mcast_grp_destroy)(struct irdma_sc_cqp *cqp,
+						    struct irdma_mcast_grp_info *info,
+						    u64 scratch);
+	enum irdma_status_code (*mcast_grp_add)(struct irdma_mcast_grp_info *ctx,
+						struct irdma_mcast_grp_ctx_entry_info *mg);
+	enum irdma_status_code (*mcast_grp_del)(struct irdma_mcast_grp_info *ctx,
+						struct irdma_mcast_grp_ctx_entry_info *mg);
+};
+#endif /* IRDMA_UDA_H */
diff --git a/drivers/infiniband/hw/irdma/uda_d.h b/drivers/infiniband/hw/irdma/uda_d.h
new file mode 100644
index 000000000000..266e9ed567c0
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uda_d.h
@@ -0,0 +1,382 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
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
+
+/* UDA defined fields for transmit descriptors */
+#define IRDMA_UDA_QPSQ_PUSHWQE_S 56
+#define IRDMA_UDA_QPSQ_PUSHWQE_M BIT_ULL(IRDMA_UDA_QPSQ_PUSHWQE_S)
+
+#define IRDMA_UDA_QPSQ_INLINEDATAFLAG_S 57
+#define IRDMA_UDA_QPSQ_INLINEDATAFLAG_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_INLINEDATAFLAG_S)
+
+#define IRDMA_UDA_QPSQ_INLINEDATALEN_S 48
+#define IRDMA_UDA_QPSQ_INLINEDATALEN_M \
+	((u64)0xff << IRDMA_UDA_QPSQ_INLINEDATALEN_S)
+
+#define IRDMA_UDA_QPSQ_ADDFRAGCNT_S 38
+#define IRDMA_UDA_QPSQ_ADDFRAGCNT_M \
+	((u64)0x0F << IRDMA_UDA_QPSQ_ADDFRAGCNT_S)
+
+#define IRDMA_UDA_QPSQ_IPFRAGFLAGS_S 42
+#define IRDMA_UDA_QPSQ_IPFRAGFLAGS_M \
+	((u64)0x3 << IRDMA_UDA_QPSQ_IPFRAGFLAGS_S)
+
+#define IRDMA_UDA_QPSQ_NOCHECKSUM_S 45
+#define IRDMA_UDA_QPSQ_NOCHECKSUM_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_NOCHECKSUM_S)
+
+#define IRDMA_UDA_QPSQ_AHIDXVALID_S 46
+#define IRDMA_UDA_QPSQ_AHIDXVALID_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_AHIDXVALID_S)
+
+#define IRDMA_UDA_QPSQ_LOCAL_FENCE_S 61
+#define IRDMA_UDA_QPSQ_LOCAL_FENCE_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_LOCAL_FENCE_S)
+
+#define IRDMA_UDA_QPSQ_AHIDX_S 0
+#define IRDMA_UDA_QPSQ_AHIDX_M ((u64)0x1ffff << IRDMA_UDA_QPSQ_AHIDX_S)
+
+#define IRDMA_UDA_QPSQ_PROTOCOL_S 16
+#define IRDMA_UDA_QPSQ_PROTOCOL_M \
+	((u64)0xff << IRDMA_UDA_QPSQ_PROTOCOL_S)
+
+#define IRDMA_UDA_QPSQ_EXTHDRLEN_S 32
+#define IRDMA_UDA_QPSQ_EXTHDRLEN_M \
+	((u64)0x1ff << IRDMA_UDA_QPSQ_EXTHDRLEN_S)
+
+#define IRDMA_UDA_QPSQ_MULTICAST_S 63
+#define IRDMA_UDA_QPSQ_MULTICAST_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_MULTICAST_S)
+
+#define IRDMA_UDA_QPSQ_MACLEN_S 56
+#define IRDMA_UDA_QPSQ_MACLEN_M \
+	((u64)0x7f << IRDMA_UDA_QPSQ_MACLEN_S)
+#define IRDMA_UDA_QPSQ_MACLEN_LINE 2
+
+#define IRDMA_UDA_QPSQ_IPLEN_S 48
+#define IRDMA_UDA_QPSQ_IPLEN_M \
+	((u64)0x7f << IRDMA_UDA_QPSQ_IPLEN_S)
+#define IRDMA_UDA_QPSQ_IPLEN_LINE 2
+
+#define IRDMA_UDA_QPSQ_L4T_S 30
+#define IRDMA_UDA_QPSQ_L4T_M ((u64)0x3 << IRDMA_UDA_QPSQ_L4T_S)
+#define IRDMA_UDA_QPSQ_L4T_LINE 2
+
+#define IRDMA_UDA_QPSQ_IIPT_S 28
+#define IRDMA_UDA_QPSQ_IIPT_M ((u64)0x3 << IRDMA_UDA_QPSQ_IIPT_S)
+#define IRDMA_UDA_QPSQ_IIPT_LINE 2
+
+#define IRDMA_UDA_QPSQ_DO_LPB_LINE 3
+
+#define IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM_S 45
+#define IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM_S)
+#define IRDMA_UDA_QPSQ_FWD_PROG_CONFIRM_LINE 3
+
+#define IRDMA_UDA_QPSQ_IMMDATA_S 0
+#define IRDMA_UDA_QPSQ_IMMDATA_M \
+	((u64)0xffffffffffffffff << IRDMA_UDA_QPSQ_IMMDATA_S)
+
+/* Byte Offset 0 */
+#define IRDMA_UDAQPC_IPV4_S 3
+#define IRDMA_UDAQPC_IPV4_M BIT_ULL(IRDMAQPC_IPV4_S)
+
+#define IRDMA_UDAQPC_INSERTVLANTAG_S 5
+#define IRDMA_UDAQPC_INSERTVLANTAG_M BIT_ULL(IRDMA_UDAQPC_INSERTVLANTAG_S)
+
+#define IRDMA_UDAQPC_ISQP1_S 6
+#define IRDMA_UDAQPC_ISQP1_M BIT_ULL(IRDMA_UDAQPC_ISQP1_S)
+
+#define IRDMA_UDAQPC_RQWQESIZE_S IRDMAQPC_RQWQESIZE_S
+#define IRDMA_UDAQPC_RQWQESIZE_M IRDMAQPC_RQWQESIZE_M
+
+#define IRDMA_UDAQPC_ECNENABLE_S 14
+#define IRDMA_UDAQPC_ECNENABLE_M BIT_ULL(IRDMA_UDAQPC_ECNENABLE_S)
+
+#define IRDMA_UDAQPC_PDINDEXHI_S 20
+#define IRDMA_UDAQPC_PDINDEXHI_M ((u64)3 << IRDMA_UDAQPC_PDINDEXHI_S)
+
+#define IRDMA_UDAQPC_DCTCPENABLE_S 25
+#define IRDMA_UDAQPC_DCTCPENABLE_M BIT_ULL(IRDMA_UDAQPC_DCTCPENABLE_S)
+
+#define IRDMA_UDAQPC_RCVTPHEN_S IRDMAQPC_RCVTPHEN_S
+#define IRDMA_UDAQPC_RCVTPHEN_M IRDMAQPC_RCVTPHEN_M
+
+#define IRDMA_UDAQPC_XMITTPHEN_S IRDMAQPC_XMITTPHEN_S
+#define IRDMA_UDAQPC_XMITTPHEN_M IRDMAQPC_XMITTPHEN_M
+
+#define IRDMA_UDAQPC_RQTPHEN_S IRDMAQPC_RQTPHEN_S
+#define IRDMA_UDAQPC_RQTPHEN_M IRDMAQPC_RQTPHEN_M
+
+#define IRDMA_UDAQPC_SQTPHEN_S IRDMAQPC_SQTPHEN_S
+#define IRDMA_UDAQPC_SQTPHEN_M IRDMAQPC_SQTPHEN_M
+
+#define IRDMA_UDAQPC_PPIDX_S IRDMAQPC_PPIDX_S
+#define IRDMA_UDAQPC_PPIDX_M IRDMAQPC_PPIDX_M
+
+#define IRDMA_UDAQPC_PMENA_S IRDMAQPC_PMENA_S
+#define IRDMA_UDAQPC_PMENA_M IRDMAQPC_PMENA_M
+
+#define IRDMA_UDAQPC_INSERTTAG2_S 11
+#define IRDMA_UDAQPC_INSERTTAG2_M BIT_ULL(IRDMA_UDAQPC_INSERTTAG2_S)
+
+#define IRDMA_UDAQPC_INSERTTAG3_S 14
+#define IRDMA_UDAQPC_INSERTTAG3_M BIT_ULL(IRDMA_UDAQPC_INSERTTAG3_S)
+
+#define IRDMA_UDAQPC_RQSIZE_S IRDMAQPC_RQSIZE_S
+#define IRDMA_UDAQPC_RQSIZE_M IRDMAQPC_RQSIZE_M
+
+#define IRDMA_UDAQPC_SQSIZE_S IRDMAQPC_SQSIZE_S
+#define IRDMA_UDAQPC_SQSIZE_M IRDMAQPC_SQSIZE_M
+
+#define IRDMA_UDAQPC_TXCQNUM_S IRDMAQPC_TXCQNUM_S
+#define IRDMA_UDAQPC_TXCQNUM_M IRDMAQPC_TXCQNUM_M
+
+#define IRDMA_UDAQPC_RXCQNUM_S IRDMAQPC_RXCQNUM_S
+#define IRDMA_UDAQPC_RXCQNUM_M IRDMAQPC_RXCQNUM_M
+
+#define IRDMA_UDAQPC_QPCOMPCTX_S IRDMAQPC_QPCOMPCTX_S
+#define IRDMA_UDAQPC_QPCOMPCTX_M IRDMAQPC_QPCOMPCTX_M
+
+#define IRDMA_UDAQPC_SQTPHVAL_S IRDMAQPC_SQTPHVAL_S
+#define IRDMA_UDAQPC_SQTPHVAL_M IRDMAQPC_SQTPHVAL_M
+
+#define IRDMA_UDAQPC_RQTPHVAL_S IRDMAQPC_RQTPHVAL_S
+#define IRDMA_UDAQPC_RQTPHVAL_M IRDMAQPC_RQTPHVAL_M
+
+#define IRDMA_UDAQPC_QSHANDLE_S IRDMAQPC_QSHANDLE_S
+#define IRDMA_UDAQPC_QSHANDLE_M IRDMAQPC_QSHANDLE_M
+
+#define IRDMA_UDAQPC_RQHDRRINGBUFSIZE_S 48
+#define IRDMA_UDAQPC_RQHDRRINGBUFSIZE_M \
+	((u64)0x3 << IRDMA_UDAQPC_RQHDRRINGBUFSIZE_S)
+
+#define IRDMA_UDAQPC_SQHDRRINGBUFSIZE_S 32
+#define IRDMA_UDAQPC_SQHDRRINGBUFSIZE_M \
+	((u64)0x3 << IRDMA_UDAQPC_SQHDRRINGBUFSIZE_S)
+
+#define IRDMA_UDAQPC_PRIVILEGEENABLE_S 25
+#define IRDMA_UDAQPC_PRIVILEGEENABLE_M \
+	BIT_ULL(IRDMA_UDAQPC_PRIVILEGEENABLE_S)
+
+#define IRDMA_UDAQPC_USE_STATISTICS_INSTANCE_S 26
+#define IRDMA_UDAQPC_USE_STATISTICS_INSTANCE_M \
+	BIT_ULL(IRDMA_UDAQPC_USE_STATISTICS_INSTANCE_S)
+
+#define IRDMA_UDAQPC_STATISTICS_INSTANCE_INDEX_S 0
+#define IRDMA_UDAQPC_STATISTICS_INSTANCE_INDEX_M \
+	((u64)0x7F << IRDMA_UDAQPC_STATISTICS_INSTANCE_INDEX_S)
+
+#define IRDMA_UDAQPC_PRIVHDRGENENABLE_S 0
+#define IRDMA_UDAQPC_PRIVHDRGENENABLE_M \
+	BIT_ULL(IRDMA_UDAQPC_PRIVHDRGENENABLE_S)
+
+#define IRDMA_UDAQPC_RQHDRSPLITENABLE_S 3
+#define IRDMA_UDAQPC_RQHDRSPLITENABLE_M \
+	BIT_ULL(IRDMA_UDAQPC_RQHDRSPLITENABLE_S)
+
+#define IRDMA_UDAQPC_RQHDRRINGBUFENABLE_S 2
+#define IRDMA_UDAQPC_RQHDRRINGBUFENABLE_M \
+	BIT_ULL(IRDMA_UDAQPC_RQHDRRINGBUFENABLE_S)
+
+#define IRDMA_UDAQPC_SQHDRRINGBUFENABLE_S 1
+#define IRDMA_UDAQPC_SQHDRRINGBUFENABLE_M \
+	BIT_ULL(IRDMA_UDAQPC_SQHDRRINGBUFENABLE_S)
+
+#define IRDMA_UDAQPC_IPID_S 32
+#define IRDMA_UDAQPC_IPID_M ((u64)0xffff << IRDMA_UDAQPC_IPID_S)
+
+#define IRDMA_UDAQPC_SNDMSS_S 16
+#define IRDMA_UDAQPC_SNDMSS_M ((u64)0x3fff << IRDMA_UDAQPC_SNDMSS_S)
+
+#define IRDMA_UDAQPC_VLANTAG_S 0
+#define IRDMA_UDAQPC_VLANTAG_M  ((u64)0xffff << IRDMA_UDAQPC_VLANTAG_S)
+
+/* Address Handle */
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXHI_S 20
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXHI_M \
+	((u64)0x3 << IRDMA_UDA_CQPSQ_MAV_PDINDEXHI_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXLO_S 48
+#define IRDMA_UDA_CQPSQ_MAV_PDINDEXLO_M \
+	((u64)0xffff << IRDMA_UDA_CQPSQ_MAV_PDINDEXLO_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_SRCMACADDRINDEX_S 24
+#define IRDMA_UDA_CQPSQ_MAV_SRCMACADDRINDEX_M \
+	((u64)0x3f << IRDMA_UDA_CQPSQ_MAV_SRCMACADDRINDEX_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_ARPINDEX_S 48
+#define IRDMA_UDA_CQPSQ_MAV_ARPINDEX_M \
+	((u64)0xffff << IRDMA_UDA_CQPSQ_MAV_ARPINDEX_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_TC_S 32
+#define IRDMA_UDA_CQPSQ_MAV_TC_M ((u64)0xff << IRDMA_UDA_CQPSQ_MAV_TC_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_HOPLIMIT_S 32
+#define IRDMA_UDA_CQPSQ_MAV_HOPLIMIT_M \
+	((u64)0xff << IRDMA_UDA_CQPSQ_MAV_HOPLIMIT_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_FLOWLABEL_S 0
+#define IRDMA_UDA_CQPSQ_MAV_FLOWLABEL_M \
+	((u64)0xfffff << IRDMA_UDA_CQPSQ_MAV_FLOWLABEL_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_ADDR0_S 32
+#define IRDMA_UDA_CQPSQ_MAV_ADDR0_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_MAV_ADDR0_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_ADDR1_S 0
+#define IRDMA_UDA_CQPSQ_MAV_ADDR1_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_MAV_ADDR1_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_ADDR2_S 32
+#define IRDMA_UDA_CQPSQ_MAV_ADDR2_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_MAV_ADDR2_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_ADDR3_S 0
+#define IRDMA_UDA_CQPSQ_MAV_ADDR3_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_MAV_ADDR3_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_WQEVALID_S 63
+#define IRDMA_UDA_CQPSQ_MAV_WQEVALID_M \
+	BIT_ULL(IRDMA_UDA_CQPSQ_MAV_WQEVALID_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_OPCODE_S 32
+#define IRDMA_UDA_CQPSQ_MAV_OPCODE_M \
+	((u64)0x3f << IRDMA_UDA_CQPSQ_MAV_OPCODE_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK_S 62
+#define IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK_M \
+	BIT_ULL(IRDMA_UDA_CQPSQ_MAV_DOLOOPBACKK_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_IPV4VALID_S 59
+#define IRDMA_UDA_CQPSQ_MAV_IPV4VALID_M \
+	BIT_ULL(IRDMA_UDA_CQPSQ_MAV_IPV4VALID_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_AVIDX_S 0
+#define IRDMA_UDA_CQPSQ_MAV_AVIDX_M \
+	((u64)0x1ffff << IRDMA_UDA_CQPSQ_MAV_AVIDX_S)
+
+#define IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG_S 60
+#define IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG_M BIT_ULL(IRDMA_UDA_CQPSQ_MAV_INSERTVLANTAG_S)
+
+/* UDA multicast group */
+
+#define IRDMA_UDA_MGCTX_VFFLAG_S 29
+#define IRDMA_UDA_MGCTX_VFFLAG_M BIT_ULL(IRDMA_UDA_MGCTX_VFFLAG_S)
+
+#define IRDMA_UDA_MGCTX_DESTPORT_S 32
+#define IRDMA_UDA_MGCTX_DESTPORT_M ((u64)0xffff << IRDMA_UDA_MGCTX_DESTPORT_S)
+
+#define IRDMA_UDA_MGCTX_VFID_S 22
+#define IRDMA_UDA_MGCTX_VFID_M ((u64)0x7f << IRDMA_UDA_MGCTX_VFID_S)
+
+#define IRDMA_UDA_MGCTX_VALIDENT_S 31
+#define IRDMA_UDA_MGCTX_VALIDENT_M BIT_ULL(IRDMA_UDA_MGCTX_VALIDENT_S)
+
+#define IRDMA_UDA_MGCTX_PFID_S 18
+#define IRDMA_UDA_MGCTX_PFID_M ((u64)0xf << IRDMA_UDA_MGCTX_PFID_S)
+
+#define IRDMA_UDA_MGCTX_FLAGIGNOREDPORT_S 30
+#define IRDMA_UDA_MGCTX_FLAGIGNOREDPORT_M \
+	BIT_ULL(IRDMA_UDA_MGCTX_FLAGIGNOREDPORT_S)
+
+#define IRDMA_UDA_MGCTX_QPID_S 0
+#define IRDMA_UDA_MGCTX_QPID_M ((u64)0x3ffff << IRDMA_UDA_MGCTX_QPID_S)
+
+/* multicast group create CQP command */
+
+#define IRDMA_UDA_CQPSQ_MG_WQEVALID_S 63
+#define IRDMA_UDA_CQPSQ_MG_WQEVALID_M \
+	BIT_ULL(IRDMA_UDA_CQPSQ_MG_WQEVALID_S)
+
+#define IRDMA_UDA_CQPSQ_MG_OPCODE_S 32
+#define IRDMA_UDA_CQPSQ_MG_OPCODE_M ((u64)0x3f << IRDMA_UDA_CQPSQ_MG_OPCODE_S)
+
+#define IRDMA_UDA_CQPSQ_MG_MGIDX_S 0
+#define IRDMA_UDA_CQPSQ_MG_MGIDX_M ((u64)0x1fff << IRDMA_UDA_CQPSQ_MG_MGIDX_S)
+
+#define IRDMA_UDA_CQPSQ_MG_IPV4VALID_S 60
+#define IRDMA_UDA_CQPSQ_MG_IPV4VALID_M BIT_ULL(IRDMA_UDA_CQPSQ_MG_IPV4VALID_S)
+
+#define IRDMA_UDA_CQPSQ_MG_VLANVALID_S 59
+#define IRDMA_UDA_CQPSQ_MG_VLANVALID_M BIT_ULL(IRDMA_UDA_CQPSQ_MG_VLANVALID_S)
+
+#define IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID_S 0
+#define IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID_M ((u64)0x3F << IRDMA_UDA_CQPSQ_MG_HMC_FCN_ID_S)
+
+#define IRDMA_UDA_CQPSQ_MG_VLANID_S 32
+#define IRDMA_UDA_CQPSQ_MG_VLANID_M ((u64)0xFFF << IRDMA_UDA_CQPSQ_MG_VLANID_S)
+
+#define IRDMA_UDA_CQPSQ_QS_HANDLE_S 0
+#define IRDMA_UDA_CQPSQ_QS_HANDLE_M ((u64)0x3FF << IRDMA_UDA_CQPSQ_QS_HANDLE_S)
+
+/* Quad hash table */
+#define IRDMA_UDA_CQPSQ_QHASH_QPN_S 32
+#define IRDMA_UDA_CQPSQ_QHASH_QPN_M \
+	((u64)0x3ffff << IRDMA_UDA_CQPSQ_QHASH_QPN_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH__S 0
+#define IRDMA_UDA_CQPSQ_QHASH__M BIT_ULL(IRDMA_UDA_CQPSQ_QHASH__S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_SRC_PORT_S 16
+#define IRDMA_UDA_CQPSQ_QHASH_SRC_PORT_M \
+	((u64)0xffff << IRDMA_UDA_CQPSQ_QHASH_SRC_PORT_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_DEST_PORT_S 0
+#define IRDMA_UDA_CQPSQ_QHASH_DEST_PORT_M \
+	((u64)0xffff << IRDMA_UDA_CQPSQ_QHASH_DEST_PORT_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR0_S 32
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR0_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_QHASH_ADDR0_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR1_S 0
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR1_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_QHASH_ADDR1_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR2_S 32
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR2_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_QHASH_ADDR2_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR3_S 0
+#define IRDMA_UDA_CQPSQ_QHASH_ADDR3_M \
+	((u64)0xffffffff << IRDMA_UDA_CQPSQ_QHASH_ADDR3_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_WQEVALID_S 63
+#define IRDMA_UDA_CQPSQ_QHASH_WQEVALID_M \
+	BIT_ULL(IRDMA_UDA_CQPSQ_QHASH_WQEVALID_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_OPCODE_S 32
+#define IRDMA_UDA_CQPSQ_QHASH_OPCODE_M \
+	((u64)0x3f << IRDMA_UDA_CQPSQ_QHASH_OPCODE_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_MANAGE_S 61
+#define IRDMA_UDA_CQPSQ_QHASH_MANAGE_M \
+	((u64)0x3 << IRDMA_UDA_CQPSQ_QHASH_MANAGE_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_IPV4VALID_S 60
+#define IRDMA_UDA_CQPSQ_QHASH_IPV4VALID_M \
+	((u64)0x1 << IRDMA_UDA_CQPSQ_QHASH_IPV4VALID_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_LANFWD_S 59
+#define IRDMA_UDA_CQPSQ_QHASH_LANFWD_M \
+	((u64)0x1 << IRDMA_UDA_CQPSQ_QHASH_LANFWD_S)
+
+#define IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_S 42
+#define IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_M \
+	((u64)0x7 << IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_S)
+#endif /* IRDMA_UDA_D_H */
-- 
2.25.2

