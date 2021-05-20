Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD838B201
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbhETOla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:41:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:8473 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239106AbhETOkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:40:40 -0400
IronPort-SDR: la5JQO+vGcmMhjyqoNzx2BaZTHr9PAkStfedXBZxw/6dEmsRXxTXdHAkW9y1by+eByQn1f3KnK
 PikXyC4FNyFA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198154554"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198154554"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:39:14 -0700
IronPort-SDR: V7sm4DxHm2OlQ3WsvqwpmyC0/LRoHkZ+LsqdmUYcZaNg0OKbL6ZSMD7j0mWTib6vazkdbYZTwD
 GyIPajd4lgYw==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="475221457"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.170.3])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:39:08 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v6 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Date:   Thu, 20 May 2021 09:37:56 -0500
Message-Id: <20210520143809.819-10-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210520143809.819-1-shiraz.saleem@intel.com>
References: <20210520143809.819-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

The driver posts privileged commands to the HW
Admin Queue (Control QP or CQP) to request administrative
actions from the HW. Implement create/destroy of CQP
and the supporting functions, data structures and headers
to handle the different CQP commands

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/ctrl.c  | 5657 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h  | 1155 +++++++
 drivers/infiniband/hw/irdma/irdma.h |  153 +
 drivers/infiniband/hw/irdma/type.h  | 1541 ++++++++++
 4 files changed, 8506 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/ctrl.c
 create mode 100644 drivers/infiniband/hw/irdma/defs.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma.h
 create mode 100644 drivers/infiniband/hw/irdma/type.h

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
new file mode 100644
index 0000000..5aa1120
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -0,0 +1,5657 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "ws.h"
+#include "protos.h"
+
+/**
+ * irdma_get_qp_from_list - get next qp from a list
+ * @head: Listhead of qp's
+ * @qp: current qp
+ */
+struct irdma_sc_qp *irdma_get_qp_from_list(struct list_head *head,
+					   struct irdma_sc_qp *qp)
+{
+	struct list_head *lastentry;
+	struct list_head *entry = NULL;
+
+	if (list_empty(head))
+		return NULL;
+
+	if (!qp) {
+		entry = head->next;
+	} else {
+		lastentry = &qp->list;
+		entry = lastentry->next;
+		if (entry == head)
+			return NULL;
+	}
+
+	return container_of(entry, struct irdma_sc_qp, list);
+}
+
+/**
+ * irdma_sc_suspend_resume_qps - suspend/resume all qp's on VSI
+ * @vsi: the VSI struct pointer
+ * @op: Set to IRDMA_OP_RESUME or IRDMA_OP_SUSPEND
+ */
+void irdma_sc_suspend_resume_qps(struct irdma_sc_vsi *vsi, u8 op)
+{
+	struct irdma_sc_qp *qp = NULL;
+	u8 i;
+
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		mutex_lock(&vsi->qos[i].qos_mutex);
+		qp = irdma_get_qp_from_list(&vsi->qos[i].qplist, qp);
+		while (qp) {
+			if (op == IRDMA_OP_RESUME) {
+				if (!qp->dev->ws_add(vsi, i)) {
+					qp->qs_handle =
+						vsi->qos[qp->user_pri].qs_handle;
+					irdma_cqp_qp_suspend_resume(qp, op);
+				} else {
+					irdma_cqp_qp_suspend_resume(qp, op);
+					irdma_modify_qp_to_err(qp);
+				}
+			} else if (op == IRDMA_OP_SUSPEND) {
+				/* issue cqp suspend command */
+				if (!irdma_cqp_qp_suspend_resume(qp, op))
+					atomic_inc(&vsi->qp_suspend_reqs);
+			}
+			qp = irdma_get_qp_from_list(&vsi->qos[i].qplist, qp);
+		}
+		mutex_unlock(&vsi->qos[i].qos_mutex);
+	}
+}
+
+/**
+ * irdma_change_l2params - given the new l2 parameters, change all qp
+ * @vsi: RDMA VSI pointer
+ * @l2params: New parameters from l2
+ */
+void irdma_change_l2params(struct irdma_sc_vsi *vsi,
+			   struct irdma_l2params *l2params)
+{
+	if (l2params->mtu_changed) {
+		vsi->mtu = l2params->mtu;
+		if (vsi->ieq)
+			irdma_reinitialize_ieq(vsi);
+	}
+
+	if (!l2params->tc_changed)
+		return;
+
+	vsi->tc_change_pending = false;
+	irdma_sc_suspend_resume_qps(vsi, IRDMA_OP_RESUME);
+}
+
+/**
+ * irdma_qp_rem_qos - remove qp from qos lists during destroy qp
+ * @qp: qp to be removed from qos
+ */
+void irdma_qp_rem_qos(struct irdma_sc_qp *qp)
+{
+	struct irdma_sc_vsi *vsi = qp->vsi;
+
+	ibdev_dbg(to_ibdev(qp->dev),
+		  "DCB: DCB: Remove qp[%d] UP[%d] qset[%d] on_qoslist[%d]\n",
+		  qp->qp_uk.qp_id, qp->user_pri, qp->qs_handle,
+		  qp->on_qoslist);
+	mutex_lock(&vsi->qos[qp->user_pri].qos_mutex);
+	if (qp->on_qoslist) {
+		qp->on_qoslist = false;
+		list_del(&qp->list);
+	}
+	mutex_unlock(&vsi->qos[qp->user_pri].qos_mutex);
+}
+
+/**
+ * irdma_qp_add_qos - called during setctx for qp to be added to qos
+ * @qp: qp to be added to qos
+ */
+void irdma_qp_add_qos(struct irdma_sc_qp *qp)
+{
+	struct irdma_sc_vsi *vsi = qp->vsi;
+
+	ibdev_dbg(to_ibdev(qp->dev),
+		  "DCB: DCB: Add qp[%d] UP[%d] qset[%d] on_qoslist[%d]\n",
+		  qp->qp_uk.qp_id, qp->user_pri, qp->qs_handle,
+		  qp->on_qoslist);
+	mutex_lock(&vsi->qos[qp->user_pri].qos_mutex);
+	if (!qp->on_qoslist) {
+		list_add(&qp->list, &vsi->qos[qp->user_pri].qplist);
+		qp->on_qoslist = true;
+		qp->qs_handle = vsi->qos[qp->user_pri].qs_handle;
+	}
+	mutex_unlock(&vsi->qos[qp->user_pri].qos_mutex);
+}
+
+/**
+ * irdma_sc_pd_init - initialize sc pd struct
+ * @dev: sc device struct
+ * @pd: sc pd ptr
+ * @pd_id: pd_id for allocated pd
+ * @abi_ver: User/Kernel ABI version
+ */
+void irdma_sc_pd_init(struct irdma_sc_dev *dev, struct irdma_sc_pd *pd, u32 pd_id,
+		      int abi_ver)
+{
+	pd->pd_id = pd_id;
+	pd->abi_ver = abi_ver;
+	pd->dev = dev;
+}
+
+/**
+ * irdma_sc_add_arp_cache_entry - cqp wqe add arp cache entry
+ * @cqp: struct for cqp hw
+ * @info: arp entry information
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_add_arp_cache_entry(struct irdma_sc_cqp *cqp,
+			     struct irdma_add_arp_cache_entry_info *info,
+			     u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 8, info->reach_max);
+	set_64bit_val(wqe, 16, ether_addr_to_u64(info->mac_addr));
+
+	hdr = info->arp_index |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MANAGE_ARP) |
+	      FIELD_PREP(IRDMA_CQPSQ_MAT_PERMANENT, (info->permanent ? 1 : 0)) |
+	      FIELD_PREP(IRDMA_CQPSQ_MAT_ENTRYVALID, 1) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: ARP_CACHE_ENTRY WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_del_arp_cache_entry - dele arp cache entry
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @arp_index: arp index to delete arp entry
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_del_arp_cache_entry(struct irdma_sc_cqp *cqp, u64 scratch,
+			     u16 arp_index, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	hdr = arp_index |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MANAGE_ARP) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: ARP_CACHE_DEL_ENTRY WQE",
+			     DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_apbvt_entry - for adding and deleting apbvt entries
+ * @cqp: struct for cqp hw
+ * @info: info for apbvt entry to add or delete
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_manage_apbvt_entry(struct irdma_sc_cqp *cqp,
+			    struct irdma_apbvt_info *info, u64 scratch,
+			    bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, info->port);
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MANAGE_APBVT) |
+	      FIELD_PREP(IRDMA_CQPSQ_MAPT_ADDPORT, info->add) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: MANAGE_APBVT WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_qhash_table_entry - manage quad hash entries
+ * @cqp: struct for cqp hw
+ * @info: info for quad hash to manage
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ *
+ * This is called before connection establishment is started.
+ * For passive connections, when listener is created, it will
+ * call with entry type of  IRDMA_QHASH_TYPE_TCP_SYN with local
+ * ip address and tcp port. When SYN is received (passive
+ * connections) or sent (active connections), this routine is
+ * called with entry type of IRDMA_QHASH_TYPE_TCP_ESTABLISHED
+ * and quad is passed in info.
+ *
+ * When iwarp connection is done and its state moves to RTS, the
+ * quad hash entry in the hardware will point to iwarp's qp
+ * number and requires no calls from the driver.
+ */
+static enum irdma_status_code
+irdma_sc_manage_qhash_table_entry(struct irdma_sc_cqp *cqp,
+				  struct irdma_qhash_table_info *info,
+				  u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 qw1 = 0;
+	u64 qw2 = 0;
+	u64 temp;
+	struct irdma_sc_vsi *vsi = info->vsi;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, ether_addr_to_u64(info->mac_addr));
+
+	qw1 = FIELD_PREP(IRDMA_CQPSQ_QHASH_QPN, info->qp_num) |
+	      FIELD_PREP(IRDMA_CQPSQ_QHASH_DEST_PORT, info->dest_port);
+	if (info->ipv4_valid) {
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR3, info->dest_ip[0]));
+	} else {
+		set_64bit_val(wqe, 56,
+			      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR0, info->dest_ip[0]) |
+			      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR1, info->dest_ip[1]));
+
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR2, info->dest_ip[2]) |
+			      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR3, info->dest_ip[3]));
+	}
+	qw2 = FIELD_PREP(IRDMA_CQPSQ_QHASH_QS_HANDLE,
+			 vsi->qos[info->user_pri].qs_handle);
+	if (info->vlan_valid)
+		qw2 |= FIELD_PREP(IRDMA_CQPSQ_QHASH_VLANID, info->vlan_id);
+	set_64bit_val(wqe, 16, qw2);
+	if (info->entry_type == IRDMA_QHASH_TYPE_TCP_ESTABLISHED) {
+		qw1 |= FIELD_PREP(IRDMA_CQPSQ_QHASH_SRC_PORT, info->src_port);
+		if (!info->ipv4_valid) {
+			set_64bit_val(wqe, 40,
+				      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR0, info->src_ip[0]) |
+				      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR1, info->src_ip[1]));
+			set_64bit_val(wqe, 32,
+				      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR2, info->src_ip[2]) |
+				      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR3, info->src_ip[3]));
+		} else {
+			set_64bit_val(wqe, 32,
+				      FIELD_PREP(IRDMA_CQPSQ_QHASH_ADDR3, info->src_ip[0]));
+		}
+	}
+
+	set_64bit_val(wqe, 8, qw1);
+	temp = FIELD_PREP(IRDMA_CQPSQ_QHASH_WQEVALID, cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_QHASH_OPCODE,
+			  IRDMA_CQP_OP_MANAGE_QUAD_HASH_TABLE_ENTRY) |
+	       FIELD_PREP(IRDMA_CQPSQ_QHASH_MANAGE, info->manage) |
+	       FIELD_PREP(IRDMA_CQPSQ_QHASH_IPV4VALID, info->ipv4_valid) |
+	       FIELD_PREP(IRDMA_CQPSQ_QHASH_VLANVALID, info->vlan_valid) |
+	       FIELD_PREP(IRDMA_CQPSQ_QHASH_ENTRYTYPE, info->entry_type);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("WQE: MANAGE_QHASH WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_init - initialize qp
+ * @qp: sc qp
+ * @info: initialization qp info
+ */
+enum irdma_status_code irdma_sc_qp_init(struct irdma_sc_qp *qp,
+					struct irdma_qp_init_info *info)
+{
+	enum irdma_status_code ret_code;
+	u32 pble_obj_cnt;
+	u16 wqe_size;
+
+	if (info->qp_uk_init_info.max_sq_frag_cnt >
+	    info->pd->dev->hw_attrs.uk_attrs.max_hw_wq_frags ||
+	    info->qp_uk_init_info.max_rq_frag_cnt >
+	    info->pd->dev->hw_attrs.uk_attrs.max_hw_wq_frags)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	qp->dev = info->pd->dev;
+	qp->vsi = info->vsi;
+	qp->ieq_qp = info->vsi->exception_lan_q;
+	qp->sq_pa = info->sq_pa;
+	qp->rq_pa = info->rq_pa;
+	qp->hw_host_ctx_pa = info->host_ctx_pa;
+	qp->q2_pa = info->q2_pa;
+	qp->shadow_area_pa = info->shadow_area_pa;
+	qp->q2_buf = info->q2;
+	qp->pd = info->pd;
+	qp->hw_host_ctx = info->host_ctx;
+	info->qp_uk_init_info.wqe_alloc_db = qp->pd->dev->wqe_alloc_db;
+	ret_code = irdma_uk_qp_init(&qp->qp_uk, &info->qp_uk_init_info);
+	if (ret_code)
+		return ret_code;
+
+	qp->virtual_map = info->virtual_map;
+	pble_obj_cnt = info->pd->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+
+	if ((info->virtual_map && info->sq_pa >= pble_obj_cnt) ||
+	    (info->virtual_map && info->rq_pa >= pble_obj_cnt))
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	qp->llp_stream_handle = (void *)(-1);
+	qp->hw_sq_size = irdma_get_encoded_wqe_size(qp->qp_uk.sq_ring.size,
+						    IRDMA_QUEUE_TYPE_SQ_RQ);
+	ibdev_dbg(to_ibdev(qp->dev),
+		  "WQE: hw_sq_size[%04d] sq_ring.size[%04d]\n",
+		  qp->hw_sq_size, qp->qp_uk.sq_ring.size);
+	if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1 && qp->pd->abi_ver > 4)
+		wqe_size = IRDMA_WQE_SIZE_128;
+	else
+		ret_code = irdma_fragcnt_to_wqesize_rq(qp->qp_uk.max_rq_frag_cnt,
+						       &wqe_size);
+	if (ret_code)
+		return ret_code;
+
+	qp->hw_rq_size = irdma_get_encoded_wqe_size(qp->qp_uk.rq_size *
+				(wqe_size / IRDMA_QP_WQE_MIN_SIZE), IRDMA_QUEUE_TYPE_SQ_RQ);
+	ibdev_dbg(to_ibdev(qp->dev),
+		  "WQE: hw_rq_size[%04d] qp_uk.rq_size[%04d] wqe_size[%04d]\n",
+		  qp->hw_rq_size, qp->qp_uk.rq_size, wqe_size);
+	qp->sq_tph_val = info->sq_tph_val;
+	qp->rq_tph_val = info->rq_tph_val;
+	qp->sq_tph_en = info->sq_tph_en;
+	qp->rq_tph_en = info->rq_tph_en;
+	qp->rcv_tph_en = info->rcv_tph_en;
+	qp->xmit_tph_en = info->xmit_tph_en;
+	qp->qp_uk.first_sq_wq = info->qp_uk_init_info.first_sq_wq;
+	qp->qs_handle = qp->vsi->qos[qp->user_pri].qs_handle;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_create - create qp
+ * @qp: sc qp
+ * @info: qp create info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_qp_create(struct irdma_sc_qp *qp, struct irdma_create_qp_info *info,
+					  u64 scratch, bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+
+	cqp = qp->dev->cqp;
+	if (qp->qp_uk.qp_id < cqp->dev->hw_attrs.min_hw_qp_id ||
+	    qp->qp_uk.qp_id > (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt - 1))
+		return IRDMA_ERR_INVALID_QP_ID;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_CREATE_QP) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_ORDVALID, (info->ord_valid ? 1 : 0)) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_TOECTXVALID, info->tcp_ctx_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_MACVALID, info->mac_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_QPTYPE, qp->qp_uk.qp_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_VQ, qp->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_FORCELOOPBACK, info->force_lpb) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_CQNUMVALID, info->cq_num_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_ARPTABIDXVALID,
+			 info->arp_cache_idx_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_NEXTIWSTATE, info->next_iwarp_state) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QP_CREATE WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_modify - modify qp cqp wqe
+ * @qp: sc qp
+ * @info: modify qp info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_qp_modify(struct irdma_sc_qp *qp,
+					  struct irdma_modify_qp_info *info,
+					  u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	u8 term_actions = 0;
+	u8 term_len = 0;
+
+	cqp = qp->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	if (info->next_iwarp_state == IRDMA_QP_STATE_TERMINATE) {
+		if (info->dont_send_fin)
+			term_actions += IRDMAQP_TERM_SEND_TERM_ONLY;
+		if (info->dont_send_term)
+			term_actions += IRDMAQP_TERM_SEND_FIN_ONLY;
+		if (term_actions == IRDMAQP_TERM_SEND_TERM_AND_FIN ||
+		    term_actions == IRDMAQP_TERM_SEND_TERM_ONLY)
+			term_len = info->termlen;
+	}
+
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMA_CQPSQ_QP_NEWMSS, info->new_mss) |
+		      FIELD_PREP(IRDMA_CQPSQ_QP_TERMLEN, term_len));
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MODIFY_QP) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_ORDVALID, info->ord_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_TOECTXVALID, info->tcp_ctx_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_CACHEDVARVALID,
+			 info->cached_var_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_VQ, qp->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_FORCELOOPBACK, info->force_lpb) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_CQNUMVALID, info->cq_num_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_MACVALID, info->mac_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_QPTYPE, qp->qp_uk.qp_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_MSSCHANGE, info->mss_change) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_REMOVEHASHENTRY,
+			 info->remove_hash_idx) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_TERMACT, term_actions) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_RESETCON, info->reset_tcp_conn) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_ARPTABIDXVALID,
+			 info->arp_cache_idx_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_NEXTIWSTATE, info->next_iwarp_state) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QP_MODIFY WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_destroy - cqp destroy qp
+ * @qp: sc qp
+ * @scratch: u64 saved to be used during cqp completion
+ * @remove_hash_idx: flag if to remove hash idx
+ * @ignore_mw_bnd: memory window bind flag
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_qp_destroy(struct irdma_sc_qp *qp, u64 scratch,
+					   bool remove_hash_idx, bool ignore_mw_bnd,
+					   bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+
+	cqp = qp->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_QP) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_QPTYPE, qp->qp_uk.qp_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_IGNOREMWBOUND, ignore_mw_bnd) |
+	      FIELD_PREP(IRDMA_CQPSQ_QP_REMOVEHASHENTRY, remove_hash_idx) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QP_DESTROY WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_get_encoded_ird_size -
+ * @ird_size: IRD size
+ * The ird from the connection is rounded to a supported HW setting and then encoded
+ * for ird_size field of qp_ctx. Consumers are expected to provide valid ird size based
+ * on hardware attributes. IRD size defaults to a value of 4 in case of invalid input
+ */
+static u8 irdma_sc_get_encoded_ird_size(u16 ird_size)
+{
+	switch (ird_size ?
+		roundup_pow_of_two(2 * ird_size) : 4) {
+	case 256:
+		return IRDMA_IRD_HW_SIZE_256;
+	case 128:
+		return IRDMA_IRD_HW_SIZE_128;
+	case 64:
+	case 32:
+		return IRDMA_IRD_HW_SIZE_64;
+	case 16:
+	case 8:
+		return IRDMA_IRD_HW_SIZE_16;
+	case 4:
+	default:
+		break;
+	}
+
+	return IRDMA_IRD_HW_SIZE_4;
+}
+
+/**
+ * irdma_sc_qp_setctx_roce - set qp's context
+ * @qp: sc qp
+ * @qp_ctx: context ptr
+ * @info: ctx info
+ */
+void irdma_sc_qp_setctx_roce(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+			     struct irdma_qp_host_ctx_info *info)
+{
+	struct irdma_roce_offload_info *roce_info;
+	struct irdma_udp_offload_info *udp;
+	u8 push_mode_en;
+	u32 push_idx;
+
+	roce_info = info->roce_info;
+	udp = info->udp_info;
+	qp->user_pri = info->user_pri;
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX) {
+		push_mode_en = 0;
+		push_idx = 0;
+	} else {
+		push_mode_en = 1;
+		push_idx = qp->push_idx;
+	}
+	set_64bit_val(qp_ctx, 0,
+		      FIELD_PREP(IRDMAQPC_RQWQESIZE, qp->qp_uk.rq_wqe_size) |
+		      FIELD_PREP(IRDMAQPC_RCVTPHEN, qp->rcv_tph_en) |
+		      FIELD_PREP(IRDMAQPC_XMITTPHEN, qp->xmit_tph_en) |
+		      FIELD_PREP(IRDMAQPC_RQTPHEN, qp->rq_tph_en) |
+		      FIELD_PREP(IRDMAQPC_SQTPHEN, qp->sq_tph_en) |
+		      FIELD_PREP(IRDMAQPC_PPIDX, push_idx) |
+		      FIELD_PREP(IRDMAQPC_PMENA, push_mode_en) |
+		      FIELD_PREP(IRDMAQPC_PDIDXHI, roce_info->pd_id >> 16) |
+		      FIELD_PREP(IRDMAQPC_DC_TCP_EN, roce_info->dctcp_en) |
+		      FIELD_PREP(IRDMAQPC_ERR_RQ_IDX_VALID, roce_info->err_rq_idx_valid) |
+		      FIELD_PREP(IRDMAQPC_ISQP1, roce_info->is_qp1) |
+		      FIELD_PREP(IRDMAQPC_ROCE_TVER, roce_info->roce_tver) |
+		      FIELD_PREP(IRDMAQPC_IPV4, udp->ipv4) |
+		      FIELD_PREP(IRDMAQPC_INSERTVLANTAG, udp->insert_vlan_tag));
+	set_64bit_val(qp_ctx, 8, qp->sq_pa);
+	set_64bit_val(qp_ctx, 16, qp->rq_pa);
+	if ((roce_info->dcqcn_en || roce_info->dctcp_en) &&
+	    !(udp->tos & 0x03))
+		udp->tos |= ECN_CODE_PT_VAL;
+	set_64bit_val(qp_ctx, 24,
+		      FIELD_PREP(IRDMAQPC_RQSIZE, qp->hw_rq_size) |
+		      FIELD_PREP(IRDMAQPC_SQSIZE, qp->hw_sq_size) |
+		      FIELD_PREP(IRDMAQPC_TTL, udp->ttl) | FIELD_PREP(IRDMAQPC_TOS, udp->tos) |
+		      FIELD_PREP(IRDMAQPC_SRCPORTNUM, udp->src_port) |
+		      FIELD_PREP(IRDMAQPC_DESTPORTNUM, udp->dst_port));
+	set_64bit_val(qp_ctx, 32,
+		      FIELD_PREP(IRDMAQPC_DESTIPADDR2, udp->dest_ip_addr[2]) |
+		      FIELD_PREP(IRDMAQPC_DESTIPADDR3, udp->dest_ip_addr[3]));
+	set_64bit_val(qp_ctx, 40,
+		      FIELD_PREP(IRDMAQPC_DESTIPADDR0, udp->dest_ip_addr[0]) |
+		      FIELD_PREP(IRDMAQPC_DESTIPADDR1, udp->dest_ip_addr[1]));
+	set_64bit_val(qp_ctx, 48,
+		      FIELD_PREP(IRDMAQPC_SNDMSS, udp->snd_mss) |
+		      FIELD_PREP(IRDMAQPC_VLANTAG, udp->vlan_tag) |
+		      FIELD_PREP(IRDMAQPC_ARPIDX, udp->arp_idx));
+	set_64bit_val(qp_ctx, 56,
+		      FIELD_PREP(IRDMAQPC_PKEY, roce_info->p_key) |
+		      FIELD_PREP(IRDMAQPC_PDIDX, roce_info->pd_id) |
+		      FIELD_PREP(IRDMAQPC_ACKCREDITS, roce_info->ack_credits) |
+		      FIELD_PREP(IRDMAQPC_FLOWLABEL, udp->flow_label));
+	set_64bit_val(qp_ctx, 64,
+		      FIELD_PREP(IRDMAQPC_QKEY, roce_info->qkey) |
+		      FIELD_PREP(IRDMAQPC_DESTQP, roce_info->dest_qp));
+	set_64bit_val(qp_ctx, 80,
+		      FIELD_PREP(IRDMAQPC_PSNNXT, udp->psn_nxt) |
+		      FIELD_PREP(IRDMAQPC_LSN, udp->lsn));
+	set_64bit_val(qp_ctx, 88,
+		      FIELD_PREP(IRDMAQPC_EPSN, udp->epsn));
+	set_64bit_val(qp_ctx, 96,
+		      FIELD_PREP(IRDMAQPC_PSNMAX, udp->psn_max) |
+		      FIELD_PREP(IRDMAQPC_PSNUNA, udp->psn_una));
+	set_64bit_val(qp_ctx, 112,
+		      FIELD_PREP(IRDMAQPC_CWNDROCE, udp->cwnd));
+	set_64bit_val(qp_ctx, 128,
+		      FIELD_PREP(IRDMAQPC_ERR_RQ_IDX, roce_info->err_rq_idx) |
+		      FIELD_PREP(IRDMAQPC_RNRNAK_THRESH, udp->rnr_nak_thresh) |
+		      FIELD_PREP(IRDMAQPC_REXMIT_THRESH, udp->rexmit_thresh) |
+		      FIELD_PREP(IRDMAQPC_RTOMIN, roce_info->rtomin));
+	set_64bit_val(qp_ctx, 136,
+		      FIELD_PREP(IRDMAQPC_TXCQNUM, info->send_cq_num) |
+		      FIELD_PREP(IRDMAQPC_RXCQNUM, info->rcv_cq_num));
+	set_64bit_val(qp_ctx, 144,
+		      FIELD_PREP(IRDMAQPC_STAT_INDEX, info->stats_idx));
+	set_64bit_val(qp_ctx, 152, ether_addr_to_u64(roce_info->mac_addr) << 16);
+	set_64bit_val(qp_ctx, 160,
+		      FIELD_PREP(IRDMAQPC_ORDSIZE, roce_info->ord_size) |
+		      FIELD_PREP(IRDMAQPC_IRDSIZE, irdma_sc_get_encoded_ird_size(roce_info->ird_size)) |
+		      FIELD_PREP(IRDMAQPC_WRRDRSPOK, roce_info->wr_rdresp_en) |
+		      FIELD_PREP(IRDMAQPC_RDOK, roce_info->rd_en) |
+		      FIELD_PREP(IRDMAQPC_USESTATSINSTANCE, info->stats_idx_valid) |
+		      FIELD_PREP(IRDMAQPC_BINDEN, roce_info->bind_en) |
+		      FIELD_PREP(IRDMAQPC_FASTREGEN, roce_info->fast_reg_en) |
+		      FIELD_PREP(IRDMAQPC_DCQCNENABLE, roce_info->dcqcn_en) |
+		      FIELD_PREP(IRDMAQPC_RCVNOICRC, roce_info->rcv_no_icrc) |
+		      FIELD_PREP(IRDMAQPC_FW_CC_ENABLE, roce_info->fw_cc_enable) |
+		      FIELD_PREP(IRDMAQPC_UDPRIVCQENABLE, roce_info->udprivcq_en) |
+		      FIELD_PREP(IRDMAQPC_PRIVEN, roce_info->priv_mode_en) |
+		      FIELD_PREP(IRDMAQPC_TIMELYENABLE, roce_info->timely_en));
+	set_64bit_val(qp_ctx, 168,
+		      FIELD_PREP(IRDMAQPC_QPCOMPCTX, info->qp_compl_ctx));
+	set_64bit_val(qp_ctx, 176,
+		      FIELD_PREP(IRDMAQPC_SQTPHVAL, qp->sq_tph_val) |
+		      FIELD_PREP(IRDMAQPC_RQTPHVAL, qp->rq_tph_val) |
+		      FIELD_PREP(IRDMAQPC_QSHANDLE, qp->qs_handle));
+	set_64bit_val(qp_ctx, 184,
+		      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR3, udp->local_ipaddr[3]) |
+		      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR2, udp->local_ipaddr[2]));
+	set_64bit_val(qp_ctx, 192,
+		      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR1, udp->local_ipaddr[1]) |
+		      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR0, udp->local_ipaddr[0]));
+	set_64bit_val(qp_ctx, 200,
+		      FIELD_PREP(IRDMAQPC_THIGH, roce_info->t_high) |
+		      FIELD_PREP(IRDMAQPC_TLOW, roce_info->t_low));
+	set_64bit_val(qp_ctx, 208,
+		      FIELD_PREP(IRDMAQPC_REMENDPOINTIDX, info->rem_endpoint_idx));
+
+	print_hex_dump_debug("WQE: QP_HOST CTX WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, qp_ctx, IRDMA_QP_CTX_SIZE, false);
+}
+
+/* irdma_sc_alloc_local_mac_entry - allocate a mac entry
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_alloc_local_mac_entry(struct irdma_sc_cqp *cqp, u64 scratch,
+			       bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+			 IRDMA_CQP_OP_ALLOCATE_LOC_MAC_TABLE_ENTRY) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: ALLOCATE_LOCAL_MAC WQE",
+			     DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_add_local_mac_entry - add mac enry
+ * @cqp: struct for cqp hw
+ * @info:mac addr info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_add_local_mac_entry(struct irdma_sc_cqp *cqp,
+			     struct irdma_local_mac_entry_info *info,
+			     u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 header;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 32, ether_addr_to_u64(info->mac_addr));
+
+	header = FIELD_PREP(IRDMA_CQPSQ_MLM_TABLEIDX, info->entry_idx) |
+		 FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+			    IRDMA_CQP_OP_MANAGE_LOC_MAC_TABLE) |
+		 FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, header);
+
+	print_hex_dump_debug("WQE: ADD_LOCAL_MAC WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_del_local_mac_entry - cqp wqe to dele local mac
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @entry_idx: index of mac entry
+ * @ignore_ref_count: to force mac adde delete
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_del_local_mac_entry(struct irdma_sc_cqp *cqp, u64 scratch,
+			     u16 entry_idx, u8 ignore_ref_count, bool post_sq)
+{
+	__le64 *wqe;
+	u64 header;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	header = FIELD_PREP(IRDMA_CQPSQ_MLM_TABLEIDX, entry_idx) |
+		 FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+			    IRDMA_CQP_OP_MANAGE_LOC_MAC_TABLE) |
+		 FIELD_PREP(IRDMA_CQPSQ_MLM_FREEENTRY, 1) |
+		 FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity) |
+		 FIELD_PREP(IRDMA_CQPSQ_MLM_IGNORE_REF_CNT, ignore_ref_count);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, header);
+
+	print_hex_dump_debug("WQE: DEL_LOCAL_MAC_IPADDR WQE",
+			     DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_setctx - set qp's context
+ * @qp: sc qp
+ * @qp_ctx: context ptr
+ * @info: ctx info
+ */
+void irdma_sc_qp_setctx(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+			struct irdma_qp_host_ctx_info *info)
+{
+	struct irdma_iwarp_offload_info *iw;
+	struct irdma_tcp_offload_info *tcp;
+	struct irdma_sc_dev *dev;
+	u8 push_mode_en;
+	u32 push_idx;
+	u64 qw0, qw3, qw7 = 0, qw16 = 0;
+	u64 mac = 0;
+
+	iw = info->iwarp_info;
+	tcp = info->tcp_info;
+	dev = qp->dev;
+	if (iw->rcv_mark_en) {
+		qp->pfpdu.marker_len = 4;
+		qp->pfpdu.rcv_start_seq = tcp->rcv_nxt;
+	}
+	qp->user_pri = info->user_pri;
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX) {
+		push_mode_en = 0;
+		push_idx = 0;
+	} else {
+		push_mode_en = 1;
+		push_idx = qp->push_idx;
+	}
+	qw0 = FIELD_PREP(IRDMAQPC_RQWQESIZE, qp->qp_uk.rq_wqe_size) |
+	      FIELD_PREP(IRDMAQPC_RCVTPHEN, qp->rcv_tph_en) |
+	      FIELD_PREP(IRDMAQPC_XMITTPHEN, qp->xmit_tph_en) |
+	      FIELD_PREP(IRDMAQPC_RQTPHEN, qp->rq_tph_en) |
+	      FIELD_PREP(IRDMAQPC_SQTPHEN, qp->sq_tph_en) |
+	      FIELD_PREP(IRDMAQPC_PPIDX, push_idx) |
+	      FIELD_PREP(IRDMAQPC_PMENA, push_mode_en);
+
+	set_64bit_val(qp_ctx, 8, qp->sq_pa);
+	set_64bit_val(qp_ctx, 16, qp->rq_pa);
+
+	qw3 = FIELD_PREP(IRDMAQPC_RQSIZE, qp->hw_rq_size) |
+	      FIELD_PREP(IRDMAQPC_SQSIZE, qp->hw_sq_size);
+	if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		qw3 |= FIELD_PREP(IRDMAQPC_GEN1_SRCMACADDRIDX,
+				  qp->src_mac_addr_idx);
+	set_64bit_val(qp_ctx, 136,
+		      FIELD_PREP(IRDMAQPC_TXCQNUM, info->send_cq_num) |
+		      FIELD_PREP(IRDMAQPC_RXCQNUM, info->rcv_cq_num));
+	set_64bit_val(qp_ctx, 168,
+		      FIELD_PREP(IRDMAQPC_QPCOMPCTX, info->qp_compl_ctx));
+	set_64bit_val(qp_ctx, 176,
+		      FIELD_PREP(IRDMAQPC_SQTPHVAL, qp->sq_tph_val) |
+		      FIELD_PREP(IRDMAQPC_RQTPHVAL, qp->rq_tph_val) |
+		      FIELD_PREP(IRDMAQPC_QSHANDLE, qp->qs_handle) |
+		      FIELD_PREP(IRDMAQPC_EXCEPTION_LAN_QUEUE, qp->ieq_qp));
+	if (info->iwarp_info_valid) {
+		qw0 |= FIELD_PREP(IRDMAQPC_DDP_VER, iw->ddp_ver) |
+		       FIELD_PREP(IRDMAQPC_RDMAP_VER, iw->rdmap_ver) |
+		       FIELD_PREP(IRDMAQPC_DC_TCP_EN, iw->dctcp_en) |
+		       FIELD_PREP(IRDMAQPC_ECN_EN, iw->ecn_en) |
+		       FIELD_PREP(IRDMAQPC_IBRDENABLE, iw->ib_rd_en) |
+		       FIELD_PREP(IRDMAQPC_PDIDXHI, iw->pd_id >> 16) |
+		       FIELD_PREP(IRDMAQPC_ERR_RQ_IDX_VALID,
+				  iw->err_rq_idx_valid);
+		qw7 |= FIELD_PREP(IRDMAQPC_PDIDX, iw->pd_id);
+		qw16 |= FIELD_PREP(IRDMAQPC_ERR_RQ_IDX, iw->err_rq_idx) |
+			FIELD_PREP(IRDMAQPC_RTOMIN, iw->rtomin);
+		set_64bit_val(qp_ctx, 144,
+			      FIELD_PREP(IRDMAQPC_Q2ADDR, qp->q2_pa >> 8) |
+			      FIELD_PREP(IRDMAQPC_STAT_INDEX, info->stats_idx));
+
+		if (dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
+			mac = ether_addr_to_u64(iw->mac_addr);
+
+		set_64bit_val(qp_ctx, 152,
+			      mac << 16 | FIELD_PREP(IRDMAQPC_LASTBYTESENT, iw->last_byte_sent));
+		set_64bit_val(qp_ctx, 160,
+			      FIELD_PREP(IRDMAQPC_ORDSIZE, iw->ord_size) |
+			      FIELD_PREP(IRDMAQPC_IRDSIZE, irdma_sc_get_encoded_ird_size(iw->ird_size)) |
+			      FIELD_PREP(IRDMAQPC_WRRDRSPOK, iw->wr_rdresp_en) |
+			      FIELD_PREP(IRDMAQPC_RDOK, iw->rd_en) |
+			      FIELD_PREP(IRDMAQPC_SNDMARKERS, iw->snd_mark_en) |
+			      FIELD_PREP(IRDMAQPC_BINDEN, iw->bind_en) |
+			      FIELD_PREP(IRDMAQPC_FASTREGEN, iw->fast_reg_en) |
+			      FIELD_PREP(IRDMAQPC_PRIVEN, iw->priv_mode_en) |
+			      FIELD_PREP(IRDMAQPC_USESTATSINSTANCE, info->stats_idx_valid) |
+			      FIELD_PREP(IRDMAQPC_IWARPMODE, 1) |
+			      FIELD_PREP(IRDMAQPC_RCVMARKERS, iw->rcv_mark_en) |
+			      FIELD_PREP(IRDMAQPC_ALIGNHDRS, iw->align_hdrs) |
+			      FIELD_PREP(IRDMAQPC_RCVNOMPACRC, iw->rcv_no_mpa_crc) |
+			      FIELD_PREP(IRDMAQPC_RCVMARKOFFSET, iw->rcv_mark_offset || !tcp ? iw->rcv_mark_offset : tcp->rcv_nxt) |
+			      FIELD_PREP(IRDMAQPC_SNDMARKOFFSET, iw->snd_mark_offset || !tcp ? iw->snd_mark_offset : tcp->snd_nxt) |
+			      FIELD_PREP(IRDMAQPC_TIMELYENABLE, iw->timely_en));
+	}
+	if (info->tcp_info_valid) {
+		qw0 |= FIELD_PREP(IRDMAQPC_IPV4, tcp->ipv4) |
+		       FIELD_PREP(IRDMAQPC_NONAGLE, tcp->no_nagle) |
+		       FIELD_PREP(IRDMAQPC_INSERTVLANTAG,
+				  tcp->insert_vlan_tag) |
+		       FIELD_PREP(IRDMAQPC_TIMESTAMP, tcp->time_stamp) |
+		       FIELD_PREP(IRDMAQPC_LIMIT, tcp->cwnd_inc_limit) |
+		       FIELD_PREP(IRDMAQPC_DROPOOOSEG, tcp->drop_ooo_seg) |
+		       FIELD_PREP(IRDMAQPC_DUPACK_THRESH, tcp->dup_ack_thresh);
+
+		if ((iw->ecn_en || iw->dctcp_en) && !(tcp->tos & 0x03))
+			tcp->tos |= ECN_CODE_PT_VAL;
+
+		qw3 |= FIELD_PREP(IRDMAQPC_TTL, tcp->ttl) |
+		       FIELD_PREP(IRDMAQPC_AVOIDSTRETCHACK, tcp->avoid_stretch_ack) |
+		       FIELD_PREP(IRDMAQPC_TOS, tcp->tos) |
+		       FIELD_PREP(IRDMAQPC_SRCPORTNUM, tcp->src_port) |
+		       FIELD_PREP(IRDMAQPC_DESTPORTNUM, tcp->dst_port);
+		if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1) {
+			qw3 |= FIELD_PREP(IRDMAQPC_GEN1_SRCMACADDRIDX, tcp->src_mac_addr_idx);
+
+			qp->src_mac_addr_idx = tcp->src_mac_addr_idx;
+		}
+		set_64bit_val(qp_ctx, 32,
+			      FIELD_PREP(IRDMAQPC_DESTIPADDR2, tcp->dest_ip_addr[2]) |
+			      FIELD_PREP(IRDMAQPC_DESTIPADDR3, tcp->dest_ip_addr[3]));
+		set_64bit_val(qp_ctx, 40,
+			      FIELD_PREP(IRDMAQPC_DESTIPADDR0, tcp->dest_ip_addr[0]) |
+			      FIELD_PREP(IRDMAQPC_DESTIPADDR1, tcp->dest_ip_addr[1]));
+		set_64bit_val(qp_ctx, 48,
+			      FIELD_PREP(IRDMAQPC_SNDMSS, tcp->snd_mss) |
+			      FIELD_PREP(IRDMAQPC_SYN_RST_HANDLING, tcp->syn_rst_handling) |
+			      FIELD_PREP(IRDMAQPC_VLANTAG, tcp->vlan_tag) |
+			      FIELD_PREP(IRDMAQPC_ARPIDX, tcp->arp_idx));
+		qw7 |= FIELD_PREP(IRDMAQPC_FLOWLABEL, tcp->flow_label) |
+		       FIELD_PREP(IRDMAQPC_WSCALE, tcp->wscale) |
+		       FIELD_PREP(IRDMAQPC_IGNORE_TCP_OPT,
+				  tcp->ignore_tcp_opt) |
+		       FIELD_PREP(IRDMAQPC_IGNORE_TCP_UNS_OPT,
+				  tcp->ignore_tcp_uns_opt) |
+		       FIELD_PREP(IRDMAQPC_TCPSTATE, tcp->tcp_state) |
+		       FIELD_PREP(IRDMAQPC_RCVSCALE, tcp->rcv_wscale) |
+		       FIELD_PREP(IRDMAQPC_SNDSCALE, tcp->snd_wscale);
+		set_64bit_val(qp_ctx, 72,
+			      FIELD_PREP(IRDMAQPC_TIMESTAMP_RECENT, tcp->time_stamp_recent) |
+			      FIELD_PREP(IRDMAQPC_TIMESTAMP_AGE, tcp->time_stamp_age));
+		set_64bit_val(qp_ctx, 80,
+			      FIELD_PREP(IRDMAQPC_SNDNXT, tcp->snd_nxt) |
+			      FIELD_PREP(IRDMAQPC_SNDWND, tcp->snd_wnd));
+		set_64bit_val(qp_ctx, 88,
+			      FIELD_PREP(IRDMAQPC_RCVNXT, tcp->rcv_nxt) |
+			      FIELD_PREP(IRDMAQPC_RCVWND, tcp->rcv_wnd));
+		set_64bit_val(qp_ctx, 96,
+			      FIELD_PREP(IRDMAQPC_SNDMAX, tcp->snd_max) |
+			      FIELD_PREP(IRDMAQPC_SNDUNA, tcp->snd_una));
+		set_64bit_val(qp_ctx, 104,
+			      FIELD_PREP(IRDMAQPC_SRTT, tcp->srtt) |
+			      FIELD_PREP(IRDMAQPC_RTTVAR, tcp->rtt_var));
+		set_64bit_val(qp_ctx, 112,
+			      FIELD_PREP(IRDMAQPC_SSTHRESH, tcp->ss_thresh) |
+			      FIELD_PREP(IRDMAQPC_CWND, tcp->cwnd));
+		set_64bit_val(qp_ctx, 120,
+			      FIELD_PREP(IRDMAQPC_SNDWL1, tcp->snd_wl1) |
+			      FIELD_PREP(IRDMAQPC_SNDWL2, tcp->snd_wl2));
+		qw16 |= FIELD_PREP(IRDMAQPC_MAXSNDWND, tcp->max_snd_window) |
+			FIELD_PREP(IRDMAQPC_REXMIT_THRESH, tcp->rexmit_thresh);
+		set_64bit_val(qp_ctx, 184,
+			      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR3, tcp->local_ipaddr[3]) |
+			      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR2, tcp->local_ipaddr[2]));
+		set_64bit_val(qp_ctx, 192,
+			      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR1, tcp->local_ipaddr[1]) |
+			      FIELD_PREP(IRDMAQPC_LOCAL_IPADDR0, tcp->local_ipaddr[0]));
+		set_64bit_val(qp_ctx, 200,
+			      FIELD_PREP(IRDMAQPC_THIGH, iw->t_high) |
+			      FIELD_PREP(IRDMAQPC_TLOW, iw->t_low));
+		set_64bit_val(qp_ctx, 208,
+			      FIELD_PREP(IRDMAQPC_REMENDPOINTIDX, info->rem_endpoint_idx));
+	}
+
+	set_64bit_val(qp_ctx, 0, qw0);
+	set_64bit_val(qp_ctx, 24, qw3);
+	set_64bit_val(qp_ctx, 56, qw7);
+	set_64bit_val(qp_ctx, 128, qw16);
+
+	print_hex_dump_debug("WQE: QP_HOST CTX", DUMP_PREFIX_OFFSET, 16, 8,
+			     qp_ctx, IRDMA_QP_CTX_SIZE, false);
+}
+
+/**
+ * irdma_sc_alloc_stag - mr stag alloc
+ * @dev: sc device struct
+ * @info: stag info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_alloc_stag(struct irdma_sc_dev *dev,
+		    struct irdma_allocate_stag_info *info, u64 scratch,
+		    bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	enum irdma_page_size page_size;
+
+	if (info->page_size == 0x40000000)
+		page_size = IRDMA_PAGE_SIZE_1G;
+	else if (info->page_size == 0x200000)
+		page_size = IRDMA_PAGE_SIZE_2M;
+	else
+		page_size = IRDMA_PAGE_SIZE_4K;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 8,
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID) |
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_STAGLEN, info->total_len));
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_IDX, info->stag_idx));
+	set_64bit_val(wqe, 40,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_HMCFNIDX, info->hmc_fcn_index));
+
+	if (info->chunk_size)
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX, info->first_pm_pbl_idx));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_ALLOC_STAG) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_MR, 1) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_ARIGHTS, info->access_rights) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_LPBLSIZE, info->chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_HPAGESIZE, page_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_REMACCENABLED, info->remote_access) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_USEHMCFNIDX, info->use_hmc_fcn_index) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_USEPFRID, info->use_pf_rid) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: ALLOC_STAG WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_mr_reg_non_shared - non-shared mr registration
+ * @dev: sc device struct
+ * @info: mr info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_mr_reg_non_shared(struct irdma_sc_dev *dev,
+			   struct irdma_reg_ns_stag_info *info, u64 scratch,
+			   bool post_sq)
+{
+	__le64 *wqe;
+	u64 fbo;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	u32 pble_obj_cnt;
+	bool remote_access;
+	u8 addr_type;
+	enum irdma_page_size page_size;
+
+	if (info->page_size == 0x40000000)
+		page_size = IRDMA_PAGE_SIZE_1G;
+	else if (info->page_size == 0x200000)
+		page_size = IRDMA_PAGE_SIZE_2M;
+	else if (info->page_size == 0x1000)
+		page_size = IRDMA_PAGE_SIZE_4K;
+	else
+		return IRDMA_ERR_PARAM;
+
+	if (info->access_rights & (IRDMA_ACCESS_FLAGS_REMOTEREAD_ONLY |
+				   IRDMA_ACCESS_FLAGS_REMOTEWRITE_ONLY))
+		remote_access = true;
+	else
+		remote_access = false;
+
+	pble_obj_cnt = dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+	if (info->chunk_size && info->first_pm_pbl_index >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	fbo = info->va & (info->page_size - 1);
+
+	set_64bit_val(wqe, 0,
+		      (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED ?
+		      info->va : fbo));
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_STAGLEN, info->total_len) |
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID));
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_KEY, info->stag_key) |
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_IDX, info->stag_idx));
+	if (!info->chunk_size) {
+		set_64bit_val(wqe, 32, info->reg_addr_pa);
+		set_64bit_val(wqe, 48, 0);
+	} else {
+		set_64bit_val(wqe, 32, 0);
+		set_64bit_val(wqe, 48,
+			      FIELD_PREP(IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX, info->first_pm_pbl_index));
+	}
+	set_64bit_val(wqe, 40, info->hmc_fcn_index);
+	set_64bit_val(wqe, 56, 0);
+
+	addr_type = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ? 1 : 0;
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_REG_MR) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_MR, 1) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_LPBLSIZE, info->chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_HPAGESIZE, page_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_ARIGHTS, info->access_rights) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_REMACCENABLED, remote_access) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_VABASEDTO, addr_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_USEHMCFNIDX, info->use_hmc_fcn_index) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_USEPFRID, info->use_pf_rid) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: MR_REG_NS WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_dealloc_stag - deallocate stag
+ * @dev: sc device struct
+ * @info: dealloc stag info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_dealloc_stag(struct irdma_sc_dev *dev,
+		      struct irdma_dealloc_stag_info *info, u64 scratch,
+		      bool post_sq)
+{
+	u64 hdr;
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 8,
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID));
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_IDX, info->stag_idx));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DEALLOC_STAG) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_MR, info->mr) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: DEALLOC_STAG WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_mw_alloc - mw allocate
+ * @dev: sc device struct
+ * @info: memory window allocation information
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_mw_alloc(struct irdma_sc_dev *dev, struct irdma_mw_alloc_info *info,
+		  u64 scratch, bool post_sq)
+{
+	u64 hdr;
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 8,
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID));
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_STAG_IDX, info->mw_stag_index));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_ALLOC_STAG) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_MWTYPE, info->mw_wide) |
+	      FIELD_PREP(IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY,
+			 info->mw1_bind_dont_vldt_key) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: MW_ALLOC WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_mr_fast_register - Posts RDMA fast register mr WR to iwarp qp
+ * @qp: sc qp struct
+ * @info: fast mr info
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code
+irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
+			  struct irdma_fast_reg_stag_info *info, bool post_sq)
+{
+	u64 temp, hdr;
+	__le64 *wqe;
+	u32 wqe_idx;
+	enum irdma_page_size page_size;
+	struct irdma_post_sq_info sq_info = {};
+
+	if (info->page_size == 0x40000000)
+		page_size = IRDMA_PAGE_SIZE_1G;
+	else if (info->page_size == 0x200000)
+		page_size = IRDMA_PAGE_SIZE_2M;
+	else
+		page_size = IRDMA_PAGE_SIZE_4K;
+
+	sq_info.wr_id = info->wr_id;
+	sq_info.signaled = info->signaled;
+	sq_info.push_wqe = info->push_wqe;
+
+	wqe = irdma_qp_get_next_send_wqe(&qp->qp_uk, &wqe_idx,
+					 IRDMA_QP_WQE_MIN_QUANTA, 0, &sq_info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(&qp->qp_uk, wqe_idx);
+
+	ibdev_dbg(to_ibdev(qp->dev),
+		  "MR: wr_id[%llxh] wqe_idx[%04d] location[%p]\n",
+		  info->wr_id, wqe_idx,
+		  &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
+
+	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
+		(uintptr_t)info->va : info->fbo;
+	set_64bit_val(wqe, 0, temp);
+
+	temp = FIELD_GET(IRDMAQPSQ_FIRSTPMPBLIDXHI,
+			 info->first_pm_pbl_index >> 16);
+	set_64bit_val(wqe, 8,
+		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
+		      FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+	set_64bit_val(wqe, 16,
+		      info->total_len |
+		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXLO, info->first_pm_pbl_index));
+
+	hdr = FIELD_PREP(IRDMAQPSQ_STAGKEY, info->stag_key) |
+	      FIELD_PREP(IRDMAQPSQ_STAGINDEX, info->stag_idx) |
+	      FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_FAST_REGISTER) |
+	      FIELD_PREP(IRDMAQPSQ_LPBLSIZE, info->chunk_size) |
+	      FIELD_PREP(IRDMAQPSQ_HPAGESIZE, page_size) |
+	      FIELD_PREP(IRDMAQPSQ_STAGRIGHTS, info->access_rights) |
+	      FIELD_PREP(IRDMAQPSQ_VABASEDTO, info->addr_type) |
+	      FIELD_PREP(IRDMAQPSQ_PUSHWQE, (sq_info.push_wqe ? 1 : 0)) |
+	      FIELD_PREP(IRDMAQPSQ_READFENCE, info->read_fence) |
+	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, info->local_fence) |
+	      FIELD_PREP(IRDMAQPSQ_SIGCOMPL, info->signaled) |
+	      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: FAST_REG WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_QP_WQE_MIN_SIZE, false);
+	if (sq_info.push_wqe) {
+		irdma_qp_push_wqe(&qp->qp_uk, wqe, IRDMA_QP_WQE_MIN_QUANTA,
+				  wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_uk_qp_post_wr(&qp->qp_uk);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_sc_gen_rts_ae - request AE generated after RTS
+ * @qp: sc qp struct
+ */
+static void irdma_sc_gen_rts_ae(struct irdma_sc_qp *qp)
+{
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_qp_uk *qp_uk;
+
+	qp_uk = &qp->qp_uk;
+
+	wqe = qp_uk->sq_base[1].elem;
+
+	hdr = FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_NOP) |
+	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, 1) |
+	      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	print_hex_dump_debug("QP: NOP W/LOCAL FENCE WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_QP_WQE_MIN_SIZE, false);
+
+	wqe = qp_uk->sq_base[2].elem;
+	hdr = FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_GEN_RTS_AE) |
+	      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	print_hex_dump_debug("QP: CONN EST WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_QP_WQE_MIN_SIZE, false);
+}
+
+/**
+ * irdma_sc_send_lsmm - send last streaming mode message
+ * @qp: sc qp struct
+ * @lsmm_buf: buffer with lsmm message
+ * @size: size of lsmm buffer
+ * @stag: stag of lsmm buffer
+ */
+void irdma_sc_send_lsmm(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size,
+			irdma_stag stag)
+{
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_qp_uk *qp_uk;
+
+	qp_uk = &qp->qp_uk;
+	wqe = qp_uk->sq_base->elem;
+
+	set_64bit_val(wqe, 0, (uintptr_t)lsmm_buf);
+	if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1) {
+		set_64bit_val(wqe, 8,
+			      FIELD_PREP(IRDMAQPSQ_GEN1_FRAG_LEN, size) |
+			      FIELD_PREP(IRDMAQPSQ_GEN1_FRAG_STAG, stag));
+	} else {
+		set_64bit_val(wqe, 8,
+			      FIELD_PREP(IRDMAQPSQ_FRAG_LEN, size) |
+			      FIELD_PREP(IRDMAQPSQ_FRAG_STAG, stag) |
+			      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity));
+	}
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_RDMA_SEND) |
+	      FIELD_PREP(IRDMAQPSQ_STREAMMODE, 1) |
+	      FIELD_PREP(IRDMAQPSQ_WAITFORRCVPDU, 1) |
+	      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: SEND_LSMM WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_QP_WQE_MIN_SIZE, false);
+
+	if (qp->dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_RTS_AE)
+		irdma_sc_gen_rts_ae(qp);
+}
+
+/**
+ * irdma_sc_send_lsmm_nostag - for privilege qp
+ * @qp: sc qp struct
+ * @lsmm_buf: buffer with lsmm message
+ * @size: size of lsmm buffer
+ */
+void irdma_sc_send_lsmm_nostag(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size)
+{
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_qp_uk *qp_uk;
+
+	qp_uk = &qp->qp_uk;
+	wqe = qp_uk->sq_base->elem;
+
+	set_64bit_val(wqe, 0, (uintptr_t)lsmm_buf);
+
+	if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1)
+		set_64bit_val(wqe, 8,
+			      FIELD_PREP(IRDMAQPSQ_GEN1_FRAG_LEN, size));
+	else
+		set_64bit_val(wqe, 8,
+			      FIELD_PREP(IRDMAQPSQ_FRAG_LEN, size) |
+			      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity));
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_RDMA_SEND) |
+	      FIELD_PREP(IRDMAQPSQ_STREAMMODE, 1) |
+	      FIELD_PREP(IRDMAQPSQ_WAITFORRCVPDU, 1) |
+	      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: SEND_LSMM_NOSTAG WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_QP_WQE_MIN_SIZE, false);
+}
+
+/**
+ * irdma_sc_send_rtt - send last read0 or write0
+ * @qp: sc qp struct
+ * @read: Do read0 or write0
+ */
+void irdma_sc_send_rtt(struct irdma_sc_qp *qp, bool read)
+{
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_qp_uk *qp_uk;
+
+	qp_uk = &qp->qp_uk;
+	wqe = qp_uk->sq_base->elem;
+
+	set_64bit_val(wqe, 0, 0);
+	set_64bit_val(wqe, 16, 0);
+	if (read) {
+		if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1) {
+			set_64bit_val(wqe, 8,
+				      FIELD_PREP(IRDMAQPSQ_GEN1_FRAG_STAG, 0xabcd));
+		} else {
+			set_64bit_val(wqe, 8,
+				      (u64)0xabcd | FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity));
+		}
+		hdr = FIELD_PREP(IRDMAQPSQ_REMSTAG, 0x1234) |
+		      FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_RDMA_READ) |
+		      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+
+	} else {
+		if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1) {
+			set_64bit_val(wqe, 8, 0);
+		} else {
+			set_64bit_val(wqe, 8,
+				      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity));
+		}
+		hdr = FIELD_PREP(IRDMAQPSQ_OPCODE, IRDMAQP_OP_RDMA_WRITE) |
+		      FIELD_PREP(IRDMAQPSQ_VALID, qp->qp_uk.swqe_polarity);
+	}
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: RTR WQE", DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_QP_WQE_MIN_SIZE, false);
+
+	if (qp->dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_RTS_AE)
+		irdma_sc_gen_rts_ae(qp);
+}
+
+/**
+ * irdma_iwarp_opcode - determine if incoming is rdma layer
+ * @info: aeq info for the packet
+ * @pkt: packet for error
+ */
+static u32 irdma_iwarp_opcode(struct irdma_aeqe_info *info, u8 *pkt)
+{
+	__be16 *mpa;
+	u32 opcode = 0xffffffff;
+
+	if (info->q2_data_written) {
+		mpa = (__be16 *)pkt;
+		opcode = ntohs(mpa[1]) & 0xf;
+	}
+
+	return opcode;
+}
+
+/**
+ * irdma_locate_mpa - return pointer to mpa in the pkt
+ * @pkt: packet with data
+ */
+static u8 *irdma_locate_mpa(u8 *pkt)
+{
+	/* skip over ethernet header */
+	pkt += IRDMA_MAC_HLEN;
+
+	/* Skip over IP and TCP headers */
+	pkt += 4 * (pkt[0] & 0x0f);
+	pkt += 4 * ((pkt[12] >> 4) & 0x0f);
+
+	return pkt;
+}
+
+/**
+ * irdma_bld_termhdr_ctrl - setup terminate hdr control fields
+ * @qp: sc qp ptr for pkt
+ * @hdr: term hdr
+ * @opcode: flush opcode for termhdr
+ * @layer_etype: error layer + error type
+ * @err: error cod ein the header
+ */
+static void irdma_bld_termhdr_ctrl(struct irdma_sc_qp *qp,
+				   struct irdma_terminate_hdr *hdr,
+				   enum irdma_flush_opcode opcode,
+				   u8 layer_etype, u8 err)
+{
+	qp->flush_code = opcode;
+	hdr->layer_etype = layer_etype;
+	hdr->error_code = err;
+}
+
+/**
+ * irdma_bld_termhdr_ddp_rdma - setup ddp and rdma hdrs in terminate hdr
+ * @pkt: ptr to mpa in offending pkt
+ * @hdr: term hdr
+ * @copy_len: offending pkt length to be copied to term hdr
+ * @is_tagged: DDP tagged or untagged
+ */
+static void irdma_bld_termhdr_ddp_rdma(u8 *pkt, struct irdma_terminate_hdr *hdr,
+				       int *copy_len, u8 *is_tagged)
+{
+	u16 ddp_seg_len;
+
+	ddp_seg_len = ntohs(*(__be16 *)pkt);
+	if (ddp_seg_len) {
+		*copy_len = 2;
+		hdr->hdrct = DDP_LEN_FLAG;
+		if (pkt[2] & 0x80) {
+			*is_tagged = 1;
+			if (ddp_seg_len >= TERM_DDP_LEN_TAGGED) {
+				*copy_len += TERM_DDP_LEN_TAGGED;
+				hdr->hdrct |= DDP_HDR_FLAG;
+			}
+		} else {
+			if (ddp_seg_len >= TERM_DDP_LEN_UNTAGGED) {
+				*copy_len += TERM_DDP_LEN_UNTAGGED;
+				hdr->hdrct |= DDP_HDR_FLAG;
+			}
+			if (ddp_seg_len >= (TERM_DDP_LEN_UNTAGGED + TERM_RDMA_LEN) &&
+			    ((pkt[3] & RDMA_OPCODE_M) == RDMA_READ_REQ_OPCODE)) {
+				*copy_len += TERM_RDMA_LEN;
+				hdr->hdrct |= RDMA_HDR_FLAG;
+			}
+		}
+	}
+}
+
+/**
+ * irdma_bld_terminate_hdr - build terminate message header
+ * @qp: qp associated with received terminate AE
+ * @info: the struct contiaing AE information
+ */
+static int irdma_bld_terminate_hdr(struct irdma_sc_qp *qp,
+				   struct irdma_aeqe_info *info)
+{
+	u8 *pkt = qp->q2_buf + Q2_BAD_FRAME_OFFSET;
+	int copy_len = 0;
+	u8 is_tagged = 0;
+	u32 opcode;
+	struct irdma_terminate_hdr *termhdr;
+
+	termhdr = (struct irdma_terminate_hdr *)qp->q2_buf;
+	memset(termhdr, 0, Q2_BAD_FRAME_OFFSET);
+
+	if (info->q2_data_written) {
+		pkt = irdma_locate_mpa(pkt);
+		irdma_bld_termhdr_ddp_rdma(pkt, termhdr, &copy_len, &is_tagged);
+	}
+
+	opcode = irdma_iwarp_opcode(info, pkt);
+	qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
+	qp->sq_flush_code = info->sq;
+	qp->rq_flush_code = info->rq;
+
+	switch (info->ae_id) {
+	case IRDMA_AE_AMP_UNALLOCATED_STAG:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		if (opcode == IRDMA_OP_TYPE_RDMA_WRITE)
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_PROT_ERR,
+					       (LAYER_DDP << 4) | DDP_TAGGED_BUF,
+					       DDP_TAGGED_INV_STAG);
+		else
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+					       RDMAP_INV_STAG);
+		break;
+	case IRDMA_AE_AMP_BOUNDS_VIOLATION:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		if (info->q2_data_written)
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_PROT_ERR,
+					       (LAYER_DDP << 4) | DDP_TAGGED_BUF,
+					       DDP_TAGGED_BOUNDS);
+		else
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+					       RDMAP_INV_BOUNDS);
+		break;
+	case IRDMA_AE_AMP_BAD_PD:
+		switch (opcode) {
+		case IRDMA_OP_TYPE_RDMA_WRITE:
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_PROT_ERR,
+					       (LAYER_DDP << 4) | DDP_TAGGED_BUF,
+					       DDP_TAGGED_UNASSOC_STAG);
+			break;
+		case IRDMA_OP_TYPE_SEND_INV:
+		case IRDMA_OP_TYPE_SEND_SOL_INV:
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+					       RDMAP_CANT_INV_STAG);
+			break;
+		default:
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+					       RDMAP_UNASSOC_STAG);
+		}
+		break;
+	case IRDMA_AE_AMP_INVALID_STAG:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+				       RDMAP_INV_STAG);
+		break;
+	case IRDMA_AE_AMP_BAD_QP:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_LOC_QP_OP_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_QN);
+		break;
+	case IRDMA_AE_AMP_BAD_STAG_KEY:
+	case IRDMA_AE_AMP_BAD_STAG_INDEX:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		switch (opcode) {
+		case IRDMA_OP_TYPE_SEND_INV:
+		case IRDMA_OP_TYPE_SEND_SOL_INV:
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_OP_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_OP,
+					       RDMAP_CANT_INV_STAG);
+			break;
+		default:
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+					       (LAYER_RDMA << 4) | RDMAP_REMOTE_OP,
+					       RDMAP_INV_STAG);
+		}
+		break;
+	case IRDMA_AE_AMP_RIGHTS_VIOLATION:
+	case IRDMA_AE_AMP_INVALIDATE_NO_REMOTE_ACCESS_RIGHTS:
+	case IRDMA_AE_PRIV_OPERATION_DENIED:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+				       RDMAP_ACCESS);
+		break;
+	case IRDMA_AE_AMP_TO_WRAP:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+				       RDMAP_TO_WRAP);
+		break;
+	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+				       (LAYER_MPA << 4) | DDP_LLP, MPA_CRC);
+		break;
+	case IRDMA_AE_LLP_SEGMENT_TOO_SMALL:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_LOC_LEN_ERR,
+				       (LAYER_DDP << 4) | DDP_CATASTROPHIC,
+				       DDP_CATASTROPHIC_LOCAL);
+		break;
+	case IRDMA_AE_LCE_QP_CATASTROPHIC:
+	case IRDMA_AE_DDP_NO_L_BIT:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_FATAL_ERR,
+				       (LAYER_DDP << 4) | DDP_CATASTROPHIC,
+				       DDP_CATASTROPHIC_LOCAL);
+		break;
+	case IRDMA_AE_DDP_INVALID_MSN_GAP_IN_MSN:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_MSN_RANGE);
+		break;
+	case IRDMA_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER:
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_LOC_LEN_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_TOO_LONG);
+		break;
+	case IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION:
+		if (is_tagged)
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+					       (LAYER_DDP << 4) | DDP_TAGGED_BUF,
+					       DDP_TAGGED_INV_DDP_VER);
+		else
+			irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+					       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+					       DDP_UNTAGGED_INV_DDP_VER);
+		break;
+	case IRDMA_AE_DDP_UBE_INVALID_MO:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_MO);
+		break;
+	case IRDMA_AE_DDP_UBE_INVALID_MSN_NO_BUFFER_AVAILABLE:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_OP_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_MSN_NO_BUF);
+		break;
+	case IRDMA_AE_DDP_UBE_INVALID_QN:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+				       (LAYER_DDP << 4) | DDP_UNTAGGED_BUF,
+				       DDP_UNTAGGED_INV_QN);
+		break;
+	case IRDMA_AE_RDMAP_ROE_INVALID_RDMAP_VERSION:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_GENERAL_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_OP,
+				       RDMAP_INV_RDMAP_VER);
+		break;
+	default:
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_FATAL_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_OP,
+				       RDMAP_UNSPECIFIED);
+		break;
+	}
+
+	if (copy_len)
+		memcpy(termhdr + 1, pkt, copy_len);
+
+	return sizeof(struct irdma_terminate_hdr) + copy_len;
+}
+
+/**
+ * irdma_terminate_send_fin() - Send fin for terminate message
+ * @qp: qp associated with received terminate AE
+ */
+void irdma_terminate_send_fin(struct irdma_sc_qp *qp)
+{
+	irdma_term_modify_qp(qp, IRDMA_QP_STATE_TERMINATE,
+			     IRDMAQP_TERM_SEND_FIN_ONLY, 0);
+}
+
+/**
+ * irdma_terminate_connection() - Bad AE and send terminate to remote QP
+ * @qp: qp associated with received terminate AE
+ * @info: the struct contiaing AE information
+ */
+void irdma_terminate_connection(struct irdma_sc_qp *qp,
+				struct irdma_aeqe_info *info)
+{
+	u8 termlen = 0;
+
+	if (qp->term_flags & IRDMA_TERM_SENT)
+		return;
+
+	termlen = irdma_bld_terminate_hdr(qp, info);
+	irdma_terminate_start_timer(qp);
+	qp->term_flags |= IRDMA_TERM_SENT;
+	irdma_term_modify_qp(qp, IRDMA_QP_STATE_TERMINATE,
+			     IRDMAQP_TERM_SEND_TERM_ONLY, termlen);
+}
+
+/**
+ * irdma_terminate_received - handle terminate received AE
+ * @qp: qp associated with received terminate AE
+ * @info: the struct contiaing AE information
+ */
+void irdma_terminate_received(struct irdma_sc_qp *qp,
+			      struct irdma_aeqe_info *info)
+{
+	u8 *pkt = qp->q2_buf + Q2_BAD_FRAME_OFFSET;
+	__be32 *mpa;
+	u8 ddp_ctl;
+	u8 rdma_ctl;
+	u16 aeq_id = 0;
+	struct irdma_terminate_hdr *termhdr;
+
+	mpa = (__be32 *)irdma_locate_mpa(pkt);
+	if (info->q2_data_written) {
+		/* did not validate the frame - do it now */
+		ddp_ctl = (ntohl(mpa[0]) >> 8) & 0xff;
+		rdma_ctl = ntohl(mpa[0]) & 0xff;
+		if ((ddp_ctl & 0xc0) != 0x40)
+			aeq_id = IRDMA_AE_LCE_QP_CATASTROPHIC;
+		else if ((ddp_ctl & 0x03) != 1)
+			aeq_id = IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION;
+		else if (ntohl(mpa[2]) != 2)
+			aeq_id = IRDMA_AE_DDP_UBE_INVALID_QN;
+		else if (ntohl(mpa[3]) != 1)
+			aeq_id = IRDMA_AE_DDP_INVALID_MSN_GAP_IN_MSN;
+		else if (ntohl(mpa[4]) != 0)
+			aeq_id = IRDMA_AE_DDP_UBE_INVALID_MO;
+		else if ((rdma_ctl & 0xc0) != 0x40)
+			aeq_id = IRDMA_AE_RDMAP_ROE_INVALID_RDMAP_VERSION;
+
+		info->ae_id = aeq_id;
+		if (info->ae_id) {
+			/* Bad terminate recvd - send back a terminate */
+			irdma_terminate_connection(qp, info);
+			return;
+		}
+	}
+
+	qp->term_flags |= IRDMA_TERM_RCVD;
+	qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
+	termhdr = (struct irdma_terminate_hdr *)&mpa[5];
+	if (termhdr->layer_etype == RDMAP_REMOTE_PROT ||
+	    termhdr->layer_etype == RDMAP_REMOTE_OP) {
+		irdma_terminate_done(qp, 0);
+	} else {
+		irdma_terminate_start_timer(qp);
+		irdma_terminate_send_fin(qp);
+	}
+}
+
+static enum irdma_status_code irdma_null_ws_add(struct irdma_sc_vsi *vsi,
+						u8 user_pri)
+{
+	return 0;
+}
+
+static void irdma_null_ws_remove(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	/* do nothing */
+}
+
+static void irdma_null_ws_reset(struct irdma_sc_vsi *vsi)
+{
+	/* do nothing */
+}
+
+/**
+ * irdma_sc_vsi_init - Init the vsi structure
+ * @vsi: pointer to vsi structure to initialize
+ * @info: the info used to initialize the vsi struct
+ */
+void irdma_sc_vsi_init(struct irdma_sc_vsi  *vsi,
+		       struct irdma_vsi_init_info *info)
+{
+	struct irdma_l2params *l2p;
+	int i;
+
+	vsi->dev = info->dev;
+	vsi->back_vsi = info->back_vsi;
+	vsi->register_qset = info->register_qset;
+	vsi->unregister_qset = info->unregister_qset;
+	vsi->mtu = info->params->mtu;
+	vsi->exception_lan_q = info->exception_lan_q;
+	vsi->vsi_idx = info->pf_data_vsi_num;
+	if (vsi->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		vsi->fcn_id = info->dev->hmc_fn_id;
+
+	l2p = info->params;
+	vsi->qos_rel_bw = l2p->vsi_rel_bw;
+	vsi->qos_prio_type = l2p->vsi_prio_type;
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		if (vsi->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+			vsi->qos[i].qs_handle = l2p->qs_handle_list[i];
+		vsi->qos[i].traffic_class = info->params->up2tc[i];
+		vsi->qos[i].rel_bw =
+			l2p->tc_info[vsi->qos[i].traffic_class].rel_bw;
+		vsi->qos[i].prio_type =
+			l2p->tc_info[vsi->qos[i].traffic_class].prio_type;
+		vsi->qos[i].valid = false;
+		mutex_init(&vsi->qos[i].qos_mutex);
+		INIT_LIST_HEAD(&vsi->qos[i].qplist);
+	}
+	if (vsi->register_qset) {
+		vsi->dev->ws_add = irdma_ws_add;
+		vsi->dev->ws_remove = irdma_ws_remove;
+		vsi->dev->ws_reset = irdma_ws_reset;
+	} else {
+		vsi->dev->ws_add = irdma_null_ws_add;
+		vsi->dev->ws_remove = irdma_null_ws_remove;
+		vsi->dev->ws_reset = irdma_null_ws_reset;
+	}
+}
+
+/**
+ * irdma_get_fcn_id - Return the function id
+ * @vsi: pointer to the vsi
+ */
+static u8 irdma_get_fcn_id(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_stats_inst_info stats_info = {};
+	struct irdma_sc_dev *dev = vsi->dev;
+	u8 fcn_id = IRDMA_INVALID_FCN_ID;
+	u8 start_idx, max_stats, i;
+
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1) {
+		if (!irdma_cqp_stats_inst_cmd(vsi, IRDMA_OP_STATS_ALLOCATE,
+					      &stats_info))
+			return stats_info.stats_idx;
+	}
+
+	start_idx = 1;
+	max_stats = 16;
+	for (i = start_idx; i < max_stats; i++)
+		if (!dev->fcn_id_array[i]) {
+			fcn_id = i;
+			dev->fcn_id_array[i] = true;
+			break;
+		}
+
+	return fcn_id;
+}
+
+/**
+ * irdma_vsi_stats_init - Initialize the vsi statistics
+ * @vsi: pointer to the vsi structure
+ * @info: The info structure used for initialization
+ */
+enum irdma_status_code irdma_vsi_stats_init(struct irdma_sc_vsi *vsi,
+					    struct irdma_vsi_stats_info *info)
+{
+	u8 fcn_id = info->fcn_id;
+	struct irdma_dma_mem *stats_buff_mem;
+
+	vsi->pestat = info->pestat;
+	vsi->pestat->hw = vsi->dev->hw;
+	vsi->pestat->vsi = vsi;
+	stats_buff_mem = &vsi->pestat->gather_info.stats_buff_mem;
+	stats_buff_mem->size = ALIGN(IRDMA_GATHER_STATS_BUF_SIZE * 2, 1);
+	stats_buff_mem->va = dma_alloc_coherent(vsi->pestat->hw->device,
+						stats_buff_mem->size,
+						&stats_buff_mem->pa,
+						GFP_KERNEL);
+	if (!stats_buff_mem->va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	vsi->pestat->gather_info.gather_stats_va = stats_buff_mem->va;
+	vsi->pestat->gather_info.last_gather_stats_va =
+		(void *)((uintptr_t)stats_buff_mem->va +
+			 IRDMA_GATHER_STATS_BUF_SIZE);
+
+	irdma_hw_stats_start_timer(vsi);
+	if (info->alloc_fcn_id)
+		fcn_id = irdma_get_fcn_id(vsi);
+	if (fcn_id == IRDMA_INVALID_FCN_ID)
+		goto stats_error;
+
+	vsi->stats_fcn_id_alloc = info->alloc_fcn_id;
+	vsi->fcn_id = fcn_id;
+	if (info->alloc_fcn_id) {
+		vsi->pestat->gather_info.use_stats_inst = true;
+		vsi->pestat->gather_info.stats_inst_index = fcn_id;
+	}
+
+	return 0;
+
+stats_error:
+	dma_free_coherent(vsi->pestat->hw->device, stats_buff_mem->size,
+			  stats_buff_mem->va, stats_buff_mem->pa);
+	stats_buff_mem->va = NULL;
+
+	return IRDMA_ERR_CQP_COMPL_ERROR;
+}
+
+/**
+ * irdma_vsi_stats_free - Free the vsi stats
+ * @vsi: pointer to the vsi structure
+ */
+void irdma_vsi_stats_free(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_stats_inst_info stats_info = {};
+	u8 fcn_id = vsi->fcn_id;
+	struct irdma_sc_dev *dev = vsi->dev;
+
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1) {
+		if (vsi->stats_fcn_id_alloc) {
+			stats_info.stats_idx = vsi->fcn_id;
+			irdma_cqp_stats_inst_cmd(vsi, IRDMA_OP_STATS_FREE,
+						 &stats_info);
+		}
+	} else {
+		if (vsi->stats_fcn_id_alloc &&
+		    fcn_id < vsi->dev->hw_attrs.max_stat_inst)
+			vsi->dev->fcn_id_array[fcn_id] = false;
+	}
+
+	if (!vsi->pestat)
+		return;
+	irdma_hw_stats_stop_timer(vsi);
+	dma_free_coherent(vsi->pestat->hw->device,
+			  vsi->pestat->gather_info.stats_buff_mem.size,
+			  vsi->pestat->gather_info.stats_buff_mem.va,
+			  vsi->pestat->gather_info.stats_buff_mem.pa);
+	vsi->pestat->gather_info.stats_buff_mem.va = NULL;
+}
+
+/**
+ * irdma_get_encoded_wqe_size - given wq size, returns hardware encoded size
+ * @wqsize: size of the wq (sq, rq) to encoded_size
+ * @queue_type: queue type selected for the calculation algorithm
+ */
+u8 irdma_get_encoded_wqe_size(u32 wqsize, enum irdma_queue_type queue_type)
+{
+	u8 encoded_size = 0;
+
+	/* cqp sq's hw coded value starts from 1 for size of 4
+	 * while it starts from 0 for qp' wq's.
+	 */
+	if (queue_type == IRDMA_QUEUE_TYPE_CQP)
+		encoded_size = 1;
+	wqsize >>= 2;
+	while (wqsize >>= 1)
+		encoded_size++;
+
+	return encoded_size;
+}
+
+/**
+ * irdma_sc_gather_stats - collect the statistics
+ * @cqp: struct for cqp hw
+ * @info: gather stats info structure
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_gather_stats(struct irdma_sc_cqp *cqp,
+		      struct irdma_stats_gather_info *info, u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp;
+
+	if (info->stats_buff_mem.size < IRDMA_GATHER_STATS_BUF_SIZE)
+		return IRDMA_ERR_BUF_TOO_SHORT;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 40,
+		      FIELD_PREP(IRDMA_CQPSQ_STATS_HMC_FCN_INDEX, info->hmc_fcn_index));
+	set_64bit_val(wqe, 32, info->stats_buff_mem.pa);
+
+	temp = FIELD_PREP(IRDMA_CQPSQ_STATS_WQEVALID, cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_USE_INST, info->use_stats_inst) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_INST_INDEX,
+			  info->stats_inst_index) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX,
+			  info->use_hmc_fcn_index) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_OP, IRDMA_CQP_OP_GATHER_STATS);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("STATS: GATHER_STATS WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+
+	irdma_sc_cqp_post_sq(cqp);
+	ibdev_dbg(to_ibdev(cqp->dev),
+		  "STATS: CQP SQ head 0x%x tail 0x%x size 0x%x\n",
+		  cqp->sq_ring.head, cqp->sq_ring.tail, cqp->sq_ring.size);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_stats_inst - allocate or free stats instance
+ * @cqp: struct for cqp hw
+ * @info: stats info structure
+ * @alloc: alloc vs. delete flag
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_manage_stats_inst(struct irdma_sc_cqp *cqp,
+			   struct irdma_stats_inst_info *info, bool alloc,
+			   u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 40,
+		      FIELD_PREP(IRDMA_CQPSQ_STATS_HMC_FCN_INDEX, info->hmc_fn_id));
+	temp = FIELD_PREP(IRDMA_CQPSQ_STATS_WQEVALID, cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_ALLOC_INST, alloc) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX,
+			  info->use_hmc_fcn_index) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_INST_INDEX, info->stats_idx) |
+	       FIELD_PREP(IRDMA_CQPSQ_STATS_OP, IRDMA_CQP_OP_MANAGE_STATS);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("WQE: MANAGE_STATS WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+
+	irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_set_up_map - set the up map table
+ * @cqp: struct for cqp hw
+ * @info: User priority map info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_set_up_map(struct irdma_sc_cqp *cqp,
+						  struct irdma_up_info *info,
+						  u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp = 0;
+	int i;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++)
+		temp |= info->map[i] << (i * 8);
+
+	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 40,
+		      FIELD_PREP(IRDMA_CQPSQ_UP_CNPOVERRIDE, info->cnp_up_override) |
+		      FIELD_PREP(IRDMA_CQPSQ_UP_HMCFCNIDX, info->hmc_fcn_idx));
+
+	temp = FIELD_PREP(IRDMA_CQPSQ_UP_WQEVALID, cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_UP_USEVLAN, info->use_vlan) |
+	       FIELD_PREP(IRDMA_CQPSQ_UP_USEOVERRIDE,
+			  info->use_cnp_up_override) |
+	       FIELD_PREP(IRDMA_CQPSQ_UP_OP, IRDMA_CQP_OP_UP_MAP);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("WQE: UPMAP WQE", DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_ws_node - create/modify/destroy WS node
+ * @cqp: struct for cqp hw
+ * @info: node info structure
+ * @node_op: 0 for add 1 for modify, 2 for delete
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_manage_ws_node(struct irdma_sc_cqp *cqp,
+			struct irdma_ws_node_info *info,
+			enum irdma_ws_node_op node_op, u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp = 0;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 32,
+		      FIELD_PREP(IRDMA_CQPSQ_WS_VSI, info->vsi) |
+		      FIELD_PREP(IRDMA_CQPSQ_WS_WEIGHT, info->weight));
+
+	temp = FIELD_PREP(IRDMA_CQPSQ_WS_WQEVALID, cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_NODEOP, node_op) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_ENABLENODE, info->enable) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_NODETYPE, info->type_leaf) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_PRIOTYPE, info->prio_type) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_TC, info->tc) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_OP, IRDMA_CQP_OP_WORK_SCHED_NODE) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_PARENTID, info->parent_id) |
+	       FIELD_PREP(IRDMA_CQPSQ_WS_NODEID, info->id);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("WQE: MANAGE_WS WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_flush_wqes - flush qp's wqe
+ * @qp: sc qp
+ * @info: dlush information
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp,
+					      struct irdma_qp_flush_info *info,
+					      u64 scratch, bool post_sq)
+{
+	u64 temp = 0;
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	bool flush_sq = false, flush_rq = false;
+
+	if (info->rq && !qp->flush_rq)
+		flush_rq = true;
+	if (info->sq && !qp->flush_sq)
+		flush_sq = true;
+	qp->flush_sq |= flush_sq;
+	qp->flush_rq |= flush_rq;
+
+	if (!flush_sq && !flush_rq) {
+		ibdev_dbg(to_ibdev(qp->dev),
+			  "CQP: Additional flush request ignored for qp %x\n",
+			  qp->qp_uk.qp_id);
+		return IRDMA_ERR_FLUSHED_Q;
+	}
+
+	cqp = qp->pd->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	if (info->userflushcode) {
+		if (flush_rq)
+			temp |= FIELD_PREP(IRDMA_CQPSQ_FWQE_RQMNERR,
+					   info->rq_minor_code) |
+				FIELD_PREP(IRDMA_CQPSQ_FWQE_RQMJERR,
+					   info->rq_major_code);
+		if (flush_sq)
+			temp |= FIELD_PREP(IRDMA_CQPSQ_FWQE_SQMNERR,
+					   info->sq_minor_code) |
+				FIELD_PREP(IRDMA_CQPSQ_FWQE_SQMJERR,
+					   info->sq_major_code);
+	}
+	set_64bit_val(wqe, 16, temp);
+
+	temp = (info->generate_ae) ?
+		info->ae_code | FIELD_PREP(IRDMA_CQPSQ_FWQE_AESOURCE,
+					   info->ae_src) : 0;
+	set_64bit_val(wqe, 8, temp);
+
+	hdr = qp->qp_uk.qp_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_FLUSH_WQES) |
+	      FIELD_PREP(IRDMA_CQPSQ_FWQE_GENERATE_AE, info->generate_ae) |
+	      FIELD_PREP(IRDMA_CQPSQ_FWQE_USERFLCODE, info->userflushcode) |
+	      FIELD_PREP(IRDMA_CQPSQ_FWQE_FLUSHSQ, flush_sq) |
+	      FIELD_PREP(IRDMA_CQPSQ_FWQE_FLUSHRQ, flush_rq) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QP_FLUSH WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_gen_ae - generate AE, uses flush WQE CQP OP
+ * @qp: sc qp
+ * @info: gen ae information
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_gen_ae(struct irdma_sc_qp *qp,
+					      struct irdma_gen_ae_info *info,
+					      u64 scratch, bool post_sq)
+{
+	u64 temp;
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+
+	cqp = qp->pd->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	temp = info->ae_code | FIELD_PREP(IRDMA_CQPSQ_FWQE_AESOURCE,
+					  info->ae_src);
+	set_64bit_val(wqe, 8, temp);
+
+	hdr = qp->qp_uk.qp_id | FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+					   IRDMA_CQP_OP_GEN_AE) |
+	      FIELD_PREP(IRDMA_CQPSQ_FWQE_GENERATE_AE, 1) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: GEN_AE WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/*** irdma_sc_qp_upload_context - upload qp's context
+ * @dev: sc device struct
+ * @info: upload context info ptr for return
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_qp_upload_context(struct irdma_sc_dev *dev,
+			   struct irdma_upload_context_info *info, u64 scratch,
+			   bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, info->buf_pa);
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_UCTX_QPID, info->qp_id) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_UPLOAD_CONTEXT) |
+	      FIELD_PREP(IRDMA_CQPSQ_UCTX_QPTYPE, info->qp_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_UCTX_RAWFORMAT, info->raw_format) |
+	      FIELD_PREP(IRDMA_CQPSQ_UCTX_FREEZEQP, info->freeze_qp) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QP_UPLOAD_CTX WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_push_page - Handle push page
+ * @cqp: struct for cqp hw
+ * @info: push page info
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_manage_push_page(struct irdma_sc_cqp *cqp,
+			  struct irdma_cqp_manage_push_page_info *info,
+			  u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	if (info->free_page &&
+	    info->push_idx >= cqp->dev->hw_attrs.max_hw_device_pages)
+		return IRDMA_ERR_INVALID_PUSH_PAGE_INDEX;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, info->qs_handle);
+	hdr = FIELD_PREP(IRDMA_CQPSQ_MPP_PPIDX, info->push_idx) |
+	      FIELD_PREP(IRDMA_CQPSQ_MPP_PPTYPE, info->push_page_type) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MANAGE_PUSH_PAGES) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity) |
+	      FIELD_PREP(IRDMA_CQPSQ_MPP_FREE_PAGE, info->free_page);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: MANAGE_PUSH_PAGES WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_suspend_qp - suspend qp for param change
+ * @cqp: struct for cqp hw
+ * @qp: sc qp struct
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_suspend_qp(struct irdma_sc_cqp *cqp,
+						  struct irdma_sc_qp *qp,
+						  u64 scratch)
+{
+	u64 hdr;
+	__le64 *wqe;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_SUSPENDQP_QPID, qp->qp_uk.qp_id) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_SUSPEND_QP) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: SUSPEND_QP WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_resume_qp - resume qp after suspend
+ * @cqp: struct for cqp hw
+ * @qp: sc qp struct
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_resume_qp(struct irdma_sc_cqp *cqp,
+						 struct irdma_sc_qp *qp,
+						 u64 scratch)
+{
+	u64 hdr;
+	__le64 *wqe;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_RESUMEQP_QSHANDLE, qp->qs_handle));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_RESUMEQP_QPID, qp->qp_uk.qp_id) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_RESUME_QP) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: RESUME_QP WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cq_ack - acknowledge completion q
+ * @cq: cq struct
+ */
+static inline void irdma_sc_cq_ack(struct irdma_sc_cq *cq)
+{
+	writel(cq->cq_uk.cq_id, cq->cq_uk.cq_ack_db);
+}
+
+/**
+ * irdma_sc_cq_init - initialize completion q
+ * @cq: cq struct
+ * @info: cq initialization info
+ */
+enum irdma_status_code irdma_sc_cq_init(struct irdma_sc_cq *cq,
+					struct irdma_cq_init_info *info)
+{
+	enum irdma_status_code ret_code;
+	u32 pble_obj_cnt;
+
+	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+	if (info->virtual_map && info->first_pm_pbl_idx >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	cq->cq_pa = info->cq_base_pa;
+	cq->dev = info->dev;
+	cq->ceq_id = info->ceq_id;
+	info->cq_uk_init_info.cqe_alloc_db = cq->dev->cq_arm_db;
+	info->cq_uk_init_info.cq_ack_db = cq->dev->cq_ack_db;
+	ret_code = irdma_uk_cq_init(&cq->cq_uk, &info->cq_uk_init_info);
+	if (ret_code)
+		return ret_code;
+
+	cq->virtual_map = info->virtual_map;
+	cq->pbl_chunk_size = info->pbl_chunk_size;
+	cq->ceqe_mask = info->ceqe_mask;
+	cq->cq_type = (info->type) ? info->type : IRDMA_CQ_TYPE_IWARP;
+	cq->shadow_area_pa = info->shadow_area_pa;
+	cq->shadow_read_threshold = info->shadow_read_threshold;
+	cq->ceq_id_valid = info->ceq_id_valid;
+	cq->tph_en = info->tph_en;
+	cq->tph_val = info->tph_val;
+	cq->first_pm_pbl_idx = info->first_pm_pbl_idx;
+	cq->vsi = info->vsi;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cq_create - create completion q
+ * @cq: cq struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @check_overflow: flag for overflow check
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_cq_create(struct irdma_sc_cq *cq,
+						 u64 scratch,
+						 bool check_overflow,
+						 bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	struct irdma_sc_ceq *ceq;
+	enum irdma_status_code ret_code = 0;
+
+	cqp = cq->dev->cqp;
+	if (cq->cq_uk.cq_id > (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].max_cnt - 1))
+		return IRDMA_ERR_INVALID_CQ_ID;
+
+	if (cq->ceq_id > (cq->dev->hmc_fpm_misc.max_ceqs - 1))
+		return IRDMA_ERR_INVALID_CEQ_ID;
+
+	ceq = cq->dev->ceq[cq->ceq_id];
+	if (ceq && ceq->reg_cq)
+		ret_code = irdma_sc_add_cq_ctx(ceq, cq);
+
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe) {
+		if (ceq && ceq->reg_cq)
+			irdma_sc_remove_cq_ctx(ceq, cq);
+		return IRDMA_ERR_RING_FULL;
+	}
+
+	set_64bit_val(wqe, 0, cq->cq_uk.cq_size);
+	set_64bit_val(wqe, 8, (uintptr_t)cq >> 1);
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD, cq->shadow_read_threshold));
+	set_64bit_val(wqe, 32, (cq->virtual_map ? 0 : cq->cq_pa));
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48,
+		      FIELD_PREP(IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX, (cq->virtual_map ? cq->first_pm_pbl_idx : 0)));
+	set_64bit_val(wqe, 56,
+		      FIELD_PREP(IRDMA_CQPSQ_TPHVAL, cq->tph_val) |
+		      FIELD_PREP(IRDMA_CQPSQ_VSIIDX, cq->vsi->vsi_idx));
+
+	hdr = FLD_LS_64(cq->dev, cq->cq_uk.cq_id, IRDMA_CQPSQ_CQ_CQID) |
+	      FLD_LS_64(cq->dev, (cq->ceq_id_valid ? cq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_CREATE_CQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_LPBLSIZE, cq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CHKOVERFLOW, check_overflow) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_VIRTMAP, cq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_ENCEQEMASK, cq->ceqe_mask) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CEQIDVALID, cq->ceq_id_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, cq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT,
+			 cq->cq_uk.avoid_mem_cflct) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CQ_CREATE WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cq_destroy - destroy completion q
+ * @cq: cq struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_cq_destroy(struct irdma_sc_cq *cq, u64 scratch,
+					   bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_sc_ceq *ceq;
+
+	cqp = cq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	ceq = cq->dev->ceq[cq->ceq_id];
+	if (ceq && ceq->reg_cq)
+		irdma_sc_remove_cq_ctx(ceq, cq);
+
+	set_64bit_val(wqe, 0, cq->cq_uk.cq_size);
+	set_64bit_val(wqe, 8, (uintptr_t)cq >> 1);
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48,
+		      (cq->virtual_map ? cq->first_pm_pbl_idx : 0));
+
+	hdr = cq->cq_uk.cq_id |
+	      FLD_LS_64(cq->dev, (cq->ceq_id_valid ? cq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_CQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_LPBLSIZE, cq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_VIRTMAP, cq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_ENCEQEMASK, cq->ceqe_mask) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CEQIDVALID, cq->ceq_id_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, cq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT, cq->cq_uk.avoid_mem_cflct) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CQ_DESTROY WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cq_resize - set resized cq buffer info
+ * @cq: resized cq
+ * @info: resized cq buffer info
+ */
+void irdma_sc_cq_resize(struct irdma_sc_cq *cq, struct irdma_modify_cq_info *info)
+{
+	cq->virtual_map = info->virtual_map;
+	cq->cq_pa = info->cq_pa;
+	cq->first_pm_pbl_idx = info->first_pm_pbl_idx;
+	cq->pbl_chunk_size = info->pbl_chunk_size;
+	irdma_uk_cq_resize(&cq->cq_uk, info->cq_base, info->cq_size);
+}
+
+/**
+ * irdma_sc_cq_modify - modify a Completion Queue
+ * @cq: cq struct
+ * @info: modification info struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag to post to sq
+ */
+static enum irdma_status_code
+irdma_sc_cq_modify(struct irdma_sc_cq *cq, struct irdma_modify_cq_info *info,
+		   u64 scratch, bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+	u32 pble_obj_cnt;
+
+	pble_obj_cnt = cq->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+	if (info->cq_resize && info->virtual_map &&
+	    info->first_pm_pbl_idx >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	cqp = cq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, info->cq_size);
+	set_64bit_val(wqe, 8, (uintptr_t)cq >> 1);
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD, info->shadow_read_threshold));
+	set_64bit_val(wqe, 32, info->cq_pa);
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48, info->first_pm_pbl_idx);
+	set_64bit_val(wqe, 56,
+		      FIELD_PREP(IRDMA_CQPSQ_TPHVAL, cq->tph_val) |
+		      FIELD_PREP(IRDMA_CQPSQ_VSIIDX, cq->vsi->vsi_idx));
+
+	hdr = cq->cq_uk.cq_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_MODIFY_CQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CQRESIZE, info->cq_resize) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_LPBLSIZE, info->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CHKOVERFLOW, info->check_overflow) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_VIRTMAP, info->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_ENCEQEMASK, cq->ceqe_mask) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, cq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT,
+			 cq->cq_uk.avoid_mem_cflct) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CQ_MODIFY WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_check_cqp_progress - check cqp processing progress
+ * @timeout: timeout info struct
+ * @dev: sc device struct
+ */
+void irdma_check_cqp_progress(struct irdma_cqp_timeout *timeout, struct irdma_sc_dev *dev)
+{
+	if (timeout->compl_cqp_cmds != dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS]) {
+		timeout->compl_cqp_cmds = dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS];
+		timeout->count = 0;
+	} else {
+		if (dev->cqp_cmd_stats[IRDMA_OP_REQ_CMDS] !=
+		    timeout->compl_cqp_cmds)
+			timeout->count++;
+	}
+}
+
+/**
+ * irdma_get_cqp_reg_info - get head and tail for cqp using registers
+ * @cqp: struct for cqp hw
+ * @val: cqp tail register value
+ * @tail: wqtail register value
+ * @error: cqp processing err
+ */
+static inline void irdma_get_cqp_reg_info(struct irdma_sc_cqp *cqp, u32 *val,
+					  u32 *tail, u32 *error)
+{
+	*val = readl(cqp->dev->hw_regs[IRDMA_CQPTAIL]);
+	*tail = FIELD_GET(IRDMA_CQPTAIL_WQTAIL, *val);
+	*error = FIELD_GET(IRDMA_CQPTAIL_CQP_OP_ERR, *val);
+}
+
+/**
+ * irdma_cqp_poll_registers - poll cqp registers
+ * @cqp: struct for cqp hw
+ * @tail: wqtail register value
+ * @count: how many times to try for completion
+ */
+static enum irdma_status_code irdma_cqp_poll_registers(struct irdma_sc_cqp *cqp,
+						       u32 tail, u32 count)
+{
+	u32 i = 0;
+	u32 newtail, error, val;
+
+	while (i++ < count) {
+		irdma_get_cqp_reg_info(cqp, &val, &newtail, &error);
+		if (error) {
+			error = readl(cqp->dev->hw_regs[IRDMA_CQPERRCODES]);
+			ibdev_dbg(to_ibdev(cqp->dev),
+				  "CQP: CQPERRCODES error_code[x%08X]\n",
+				  error);
+			return IRDMA_ERR_CQP_COMPL_ERROR;
+		}
+		if (newtail != tail) {
+			/* SUCCESS */
+			IRDMA_RING_MOVE_TAIL(cqp->sq_ring);
+			cqp->dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS]++;
+			return 0;
+		}
+		udelay(cqp->dev->hw_attrs.max_sleep_count);
+	}
+
+	return IRDMA_ERR_TIMEOUT;
+}
+
+/**
+ * irdma_sc_decode_fpm_commit - decode a 64 bit value into count and base
+ * @dev: sc device struct
+ * @buf: pointer to commit buffer
+ * @buf_idx: buffer index
+ * @obj_info: object info pointer
+ * @rsrc_idx: indexs of memory resource
+ */
+static u64 irdma_sc_decode_fpm_commit(struct irdma_sc_dev *dev, __le64 *buf,
+				      u32 buf_idx, struct irdma_hmc_obj_info *obj_info,
+				      u32 rsrc_idx)
+{
+	u64 temp;
+
+	get_64bit_val(buf, buf_idx, &temp);
+
+	switch (rsrc_idx) {
+	case IRDMA_HMC_IW_QP:
+		obj_info[rsrc_idx].cnt = (u32)FIELD_GET(IRDMA_COMMIT_FPM_QPCNT, temp);
+		break;
+	case IRDMA_HMC_IW_CQ:
+		obj_info[rsrc_idx].cnt = (u32)FLD_RS_64(dev, temp, IRDMA_COMMIT_FPM_CQCNT);
+		break;
+	case IRDMA_HMC_IW_APBVT_ENTRY:
+		obj_info[rsrc_idx].cnt = 1;
+		break;
+	default:
+		obj_info[rsrc_idx].cnt = (u32)temp;
+		break;
+	}
+
+	obj_info[rsrc_idx].base = (temp >> IRDMA_COMMIT_FPM_BASE_S) * 512;
+
+	return temp;
+}
+
+/**
+ * irdma_sc_parse_fpm_commit_buf - parse fpm commit buffer
+ * @dev: pointer to dev struct
+ * @buf: ptr to fpm commit buffer
+ * @info: ptr to irdma_hmc_obj_info struct
+ * @sd: number of SDs for HMC objects
+ *
+ * parses fpm commit info and copy base value
+ * of hmc objects in hmc_info
+ */
+static enum irdma_status_code
+irdma_sc_parse_fpm_commit_buf(struct irdma_sc_dev *dev, __le64 *buf,
+			      struct irdma_hmc_obj_info *info, u32 *sd)
+{
+	u64 size;
+	u32 i;
+	u64 max_base = 0;
+	u32 last_hmc_obj = 0;
+
+	irdma_sc_decode_fpm_commit(dev, buf, 0, info,
+				   IRDMA_HMC_IW_QP);
+	irdma_sc_decode_fpm_commit(dev, buf, 8, info,
+				   IRDMA_HMC_IW_CQ);
+	/* skiping RSRVD */
+	irdma_sc_decode_fpm_commit(dev, buf, 24, info,
+				   IRDMA_HMC_IW_HTE);
+	irdma_sc_decode_fpm_commit(dev, buf, 32, info,
+				   IRDMA_HMC_IW_ARP);
+	irdma_sc_decode_fpm_commit(dev, buf, 40, info,
+				   IRDMA_HMC_IW_APBVT_ENTRY);
+	irdma_sc_decode_fpm_commit(dev, buf, 48, info,
+				   IRDMA_HMC_IW_MR);
+	irdma_sc_decode_fpm_commit(dev, buf, 56, info,
+				   IRDMA_HMC_IW_XF);
+	irdma_sc_decode_fpm_commit(dev, buf, 64, info,
+				   IRDMA_HMC_IW_XFFL);
+	irdma_sc_decode_fpm_commit(dev, buf, 72, info,
+				   IRDMA_HMC_IW_Q1);
+	irdma_sc_decode_fpm_commit(dev, buf, 80, info,
+				   IRDMA_HMC_IW_Q1FL);
+	irdma_sc_decode_fpm_commit(dev, buf, 88, info,
+				   IRDMA_HMC_IW_TIMER);
+	irdma_sc_decode_fpm_commit(dev, buf, 112, info,
+				   IRDMA_HMC_IW_PBLE);
+	/* skipping RSVD. */
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1) {
+		irdma_sc_decode_fpm_commit(dev, buf, 96, info,
+					   IRDMA_HMC_IW_FSIMC);
+		irdma_sc_decode_fpm_commit(dev, buf, 104, info,
+					   IRDMA_HMC_IW_FSIAV);
+		irdma_sc_decode_fpm_commit(dev, buf, 128, info,
+					   IRDMA_HMC_IW_RRF);
+		irdma_sc_decode_fpm_commit(dev, buf, 136, info,
+					   IRDMA_HMC_IW_RRFFL);
+		irdma_sc_decode_fpm_commit(dev, buf, 144, info,
+					   IRDMA_HMC_IW_HDR);
+		irdma_sc_decode_fpm_commit(dev, buf, 152, info,
+					   IRDMA_HMC_IW_MD);
+		irdma_sc_decode_fpm_commit(dev, buf, 160, info,
+					   IRDMA_HMC_IW_OOISC);
+		irdma_sc_decode_fpm_commit(dev, buf, 168, info,
+					   IRDMA_HMC_IW_OOISCFFL);
+	}
+
+	/* searching for the last object in HMC to find the size of the HMC area. */
+	for (i = IRDMA_HMC_IW_QP; i < IRDMA_HMC_IW_MAX; i++) {
+		if (info[i].base > max_base) {
+			max_base = info[i].base;
+			last_hmc_obj = i;
+		}
+	}
+
+	size = info[last_hmc_obj].cnt * info[last_hmc_obj].size +
+	       info[last_hmc_obj].base;
+
+	if (size & 0x1FFFFF)
+		*sd = (u32)((size >> 21) + 1); /* add 1 for remainder */
+	else
+		*sd = (u32)(size >> 21);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_decode_fpm_query() - Decode a 64 bit value into max count and size
+ * @buf: ptr to fpm query buffer
+ * @buf_idx: index into buf
+ * @obj_info: ptr to irdma_hmc_obj_info struct
+ * @rsrc_idx: resource index into info
+ *
+ * Decode a 64 bit value from fpm query buffer into max count and size
+ */
+static u64 irdma_sc_decode_fpm_query(__le64 *buf, u32 buf_idx,
+				     struct irdma_hmc_obj_info *obj_info,
+				     u32 rsrc_idx)
+{
+	u64 temp;
+	u32 size;
+
+	get_64bit_val(buf, buf_idx, &temp);
+	obj_info[rsrc_idx].max_cnt = (u32)temp;
+	size = (u32)(temp >> 32);
+	obj_info[rsrc_idx].size = BIT_ULL(size);
+
+	return temp;
+}
+
+/**
+ * irdma_sc_parse_fpm_query_buf() - parses fpm query buffer
+ * @dev: ptr to shared code device
+ * @buf: ptr to fpm query buffer
+ * @hmc_info: ptr to irdma_hmc_obj_info struct
+ * @hmc_fpm_misc: ptr to fpm data
+ *
+ * parses fpm query buffer and copy max_cnt and
+ * size value of hmc objects in hmc_info
+ */
+static enum irdma_status_code
+irdma_sc_parse_fpm_query_buf(struct irdma_sc_dev *dev, __le64 *buf,
+			     struct irdma_hmc_info *hmc_info,
+			     struct irdma_hmc_fpm_misc *hmc_fpm_misc)
+{
+	struct irdma_hmc_obj_info *obj_info;
+	u64 temp;
+	u32 size;
+	u16 max_pe_sds;
+
+	obj_info = hmc_info->hmc_obj;
+
+	get_64bit_val(buf, 0, &temp);
+	hmc_info->first_sd_index = (u16)FIELD_GET(IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX, temp);
+	max_pe_sds = (u16)FIELD_GET(IRDMA_QUERY_FPM_MAX_PE_SDS, temp);
+
+	hmc_fpm_misc->max_sds = max_pe_sds;
+	hmc_info->sd_table.sd_cnt = max_pe_sds + hmc_info->first_sd_index;
+	get_64bit_val(buf, 8, &temp);
+	obj_info[IRDMA_HMC_IW_QP].max_cnt = (u32)FIELD_GET(IRDMA_QUERY_FPM_MAX_QPS, temp);
+	size = (u32)(temp >> 32);
+	obj_info[IRDMA_HMC_IW_QP].size = BIT_ULL(size);
+
+	get_64bit_val(buf, 16, &temp);
+	obj_info[IRDMA_HMC_IW_CQ].max_cnt = (u32)FIELD_GET(IRDMA_QUERY_FPM_MAX_CQS, temp);
+	size = (u32)(temp >> 32);
+	obj_info[IRDMA_HMC_IW_CQ].size = BIT_ULL(size);
+
+	irdma_sc_decode_fpm_query(buf, 32, obj_info, IRDMA_HMC_IW_HTE);
+	irdma_sc_decode_fpm_query(buf, 40, obj_info, IRDMA_HMC_IW_ARP);
+
+	obj_info[IRDMA_HMC_IW_APBVT_ENTRY].size = 8192;
+	obj_info[IRDMA_HMC_IW_APBVT_ENTRY].max_cnt = 1;
+
+	irdma_sc_decode_fpm_query(buf, 48, obj_info, IRDMA_HMC_IW_MR);
+	irdma_sc_decode_fpm_query(buf, 56, obj_info, IRDMA_HMC_IW_XF);
+
+	get_64bit_val(buf, 64, &temp);
+	obj_info[IRDMA_HMC_IW_XFFL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_XFFL].size = 4;
+	hmc_fpm_misc->xf_block_size = FIELD_GET(IRDMA_QUERY_FPM_XFBLOCKSIZE, temp);
+	if (!hmc_fpm_misc->xf_block_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	irdma_sc_decode_fpm_query(buf, 72, obj_info, IRDMA_HMC_IW_Q1);
+	get_64bit_val(buf, 80, &temp);
+	obj_info[IRDMA_HMC_IW_Q1FL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_Q1FL].size = 4;
+
+	hmc_fpm_misc->q1_block_size = FIELD_GET(IRDMA_QUERY_FPM_Q1BLOCKSIZE, temp);
+	if (!hmc_fpm_misc->q1_block_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	irdma_sc_decode_fpm_query(buf, 88, obj_info, IRDMA_HMC_IW_TIMER);
+
+	get_64bit_val(buf, 112, &temp);
+	obj_info[IRDMA_HMC_IW_PBLE].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_PBLE].size = 8;
+
+	get_64bit_val(buf, 120, &temp);
+	hmc_fpm_misc->max_ceqs = FIELD_GET(IRDMA_QUERY_FPM_MAX_CEQS, temp);
+	hmc_fpm_misc->ht_multiplier = FIELD_GET(IRDMA_QUERY_FPM_HTMULTIPLIER, temp);
+	hmc_fpm_misc->timer_bucket = FIELD_GET(IRDMA_QUERY_FPM_TIMERBUCKET, temp);
+	if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		return 0;
+	irdma_sc_decode_fpm_query(buf, 96, obj_info, IRDMA_HMC_IW_FSIMC);
+	irdma_sc_decode_fpm_query(buf, 104, obj_info, IRDMA_HMC_IW_FSIAV);
+	irdma_sc_decode_fpm_query(buf, 128, obj_info, IRDMA_HMC_IW_RRF);
+
+	get_64bit_val(buf, 136, &temp);
+	obj_info[IRDMA_HMC_IW_RRFFL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_RRFFL].size = 4;
+	hmc_fpm_misc->rrf_block_size = FIELD_GET(IRDMA_QUERY_FPM_RRFBLOCKSIZE, temp);
+	if (!hmc_fpm_misc->rrf_block_size &&
+	    obj_info[IRDMA_HMC_IW_RRFFL].max_cnt)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	irdma_sc_decode_fpm_query(buf, 144, obj_info, IRDMA_HMC_IW_HDR);
+	irdma_sc_decode_fpm_query(buf, 152, obj_info, IRDMA_HMC_IW_MD);
+	irdma_sc_decode_fpm_query(buf, 160, obj_info, IRDMA_HMC_IW_OOISC);
+
+	get_64bit_val(buf, 168, &temp);
+	obj_info[IRDMA_HMC_IW_OOISCFFL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_OOISCFFL].size = 4;
+	hmc_fpm_misc->ooiscf_block_size = FIELD_GET(IRDMA_QUERY_FPM_OOISCFBLOCKSIZE, temp);
+	if (!hmc_fpm_misc->ooiscf_block_size &&
+	    obj_info[IRDMA_HMC_IW_OOISCFFL].max_cnt)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_find_reg_cq - find cq ctx index
+ * @ceq: ceq sc structure
+ * @cq: cq sc structure
+ */
+static u32 irdma_sc_find_reg_cq(struct irdma_sc_ceq *ceq,
+				struct irdma_sc_cq *cq)
+{
+	u32 i;
+
+	for (i = 0; i < ceq->reg_cq_size; i++) {
+		if (cq == ceq->reg_cq[i])
+			return i;
+	}
+
+	return IRDMA_INVALID_CQ_IDX;
+}
+
+/**
+ * irdma_sc_add_cq_ctx - add cq ctx tracking for ceq
+ * @ceq: ceq sc structure
+ * @cq: cq sc structure
+ */
+enum irdma_status_code irdma_sc_add_cq_ctx(struct irdma_sc_ceq *ceq,
+					   struct irdma_sc_cq *cq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ceq->req_cq_lock, flags);
+
+	if (ceq->reg_cq_size == ceq->elem_cnt) {
+		spin_unlock_irqrestore(&ceq->req_cq_lock, flags);
+		return IRDMA_ERR_REG_CQ_FULL;
+	}
+
+	ceq->reg_cq[ceq->reg_cq_size++] = cq;
+
+	spin_unlock_irqrestore(&ceq->req_cq_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_remove_cq_ctx - remove cq ctx tracking for ceq
+ * @ceq: ceq sc structure
+ * @cq: cq sc structure
+ */
+void irdma_sc_remove_cq_ctx(struct irdma_sc_ceq *ceq, struct irdma_sc_cq *cq)
+{
+	unsigned long flags;
+	u32 cq_ctx_idx;
+
+	spin_lock_irqsave(&ceq->req_cq_lock, flags);
+	cq_ctx_idx = irdma_sc_find_reg_cq(ceq, cq);
+	if (cq_ctx_idx == IRDMA_INVALID_CQ_IDX)
+		goto exit;
+
+	ceq->reg_cq_size--;
+	if (cq_ctx_idx != ceq->reg_cq_size)
+		ceq->reg_cq[cq_ctx_idx] = ceq->reg_cq[ceq->reg_cq_size];
+	ceq->reg_cq[ceq->reg_cq_size] = NULL;
+
+exit:
+	spin_unlock_irqrestore(&ceq->req_cq_lock, flags);
+}
+
+/**
+ * irdma_sc_cqp_init - Initialize buffers for a control Queue Pair
+ * @cqp: IWARP control queue pair pointer
+ * @info: IWARP control queue pair init info pointer
+ *
+ * Initializes the object and context buffers for a control Queue Pair.
+ */
+enum irdma_status_code irdma_sc_cqp_init(struct irdma_sc_cqp *cqp,
+					 struct irdma_cqp_init_info *info)
+{
+	u8 hw_sq_size;
+
+	if (info->sq_size > IRDMA_CQP_SW_SQSIZE_2048 ||
+	    info->sq_size < IRDMA_CQP_SW_SQSIZE_4 ||
+	    ((info->sq_size & (info->sq_size - 1))))
+		return IRDMA_ERR_INVALID_SIZE;
+
+	hw_sq_size = irdma_get_encoded_wqe_size(info->sq_size,
+						IRDMA_QUEUE_TYPE_CQP);
+	cqp->size = sizeof(*cqp);
+	cqp->sq_size = info->sq_size;
+	cqp->hw_sq_size = hw_sq_size;
+	cqp->sq_base = info->sq;
+	cqp->host_ctx = info->host_ctx;
+	cqp->sq_pa = info->sq_pa;
+	cqp->host_ctx_pa = info->host_ctx_pa;
+	cqp->dev = info->dev;
+	cqp->struct_ver = info->struct_ver;
+	cqp->hw_maj_ver = info->hw_maj_ver;
+	cqp->hw_min_ver = info->hw_min_ver;
+	cqp->scratch_array = info->scratch_array;
+	cqp->polarity = 0;
+	cqp->en_datacenter_tcp = info->en_datacenter_tcp;
+	cqp->ena_vf_count = info->ena_vf_count;
+	cqp->hmc_profile = info->hmc_profile;
+	cqp->ceqs_per_vf = info->ceqs_per_vf;
+	cqp->disable_packed = info->disable_packed;
+	cqp->rocev2_rto_policy = info->rocev2_rto_policy;
+	cqp->protocol_used = info->protocol_used;
+	memcpy(&cqp->dcqcn_params, &info->dcqcn_params, sizeof(cqp->dcqcn_params));
+	info->dev->cqp = cqp;
+
+	IRDMA_RING_INIT(cqp->sq_ring, cqp->sq_size);
+	cqp->dev->cqp_cmd_stats[IRDMA_OP_REQ_CMDS] = 0;
+	cqp->dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS] = 0;
+	/* for the cqp commands backlog. */
+	INIT_LIST_HEAD(&cqp->dev->cqp_cmd_head);
+
+	writel(0, cqp->dev->hw_regs[IRDMA_CQPTAIL]);
+	writel(0, cqp->dev->hw_regs[IRDMA_CQPDB]);
+	writel(0, cqp->dev->hw_regs[IRDMA_CCQPSTATUS]);
+
+	ibdev_dbg(to_ibdev(cqp->dev),
+		  "WQE: sq_size[%04d] hw_sq_size[%04d] sq_base[%p] sq_pa[%pK] cqp[%p] polarity[x%04x]\n",
+		  cqp->sq_size, cqp->hw_sq_size, cqp->sq_base,
+		  (u64 *)(uintptr_t)cqp->sq_pa, cqp, cqp->polarity);
+	return 0;
+}
+
+/**
+ * irdma_sc_cqp_create - create cqp during bringup
+ * @cqp: struct for cqp hw
+ * @maj_err: If error, major err number
+ * @min_err: If error, minor err number
+ */
+enum irdma_status_code irdma_sc_cqp_create(struct irdma_sc_cqp *cqp, u16 *maj_err,
+					   u16 *min_err)
+{
+	u64 temp;
+	u8 hw_rev;
+	u32 cnt = 0, p1, p2, val = 0, err_code;
+	enum irdma_status_code ret_code;
+
+	hw_rev = cqp->dev->hw_attrs.uk_attrs.hw_rev;
+	cqp->sdbuf.size = ALIGN(IRDMA_UPDATE_SD_BUFF_SIZE * cqp->sq_size,
+				IRDMA_SD_BUF_ALIGNMENT);
+	cqp->sdbuf.va = dma_alloc_coherent(cqp->dev->hw->device,
+					   cqp->sdbuf.size, &cqp->sdbuf.pa,
+					   GFP_KERNEL);
+	if (!cqp->sdbuf.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	spin_lock_init(&cqp->dev->cqp_lock);
+
+	temp = FIELD_PREP(IRDMA_CQPHC_SQSIZE, cqp->hw_sq_size) |
+	       FIELD_PREP(IRDMA_CQPHC_SVER, cqp->struct_ver) |
+	       FIELD_PREP(IRDMA_CQPHC_DISABLE_PFPDUS, cqp->disable_packed) |
+	       FIELD_PREP(IRDMA_CQPHC_CEQPERVF, cqp->ceqs_per_vf);
+	if (hw_rev >= IRDMA_GEN_2) {
+		temp |= FIELD_PREP(IRDMA_CQPHC_ROCEV2_RTO_POLICY,
+				   cqp->rocev2_rto_policy) |
+			FIELD_PREP(IRDMA_CQPHC_PROTOCOL_USED,
+				   cqp->protocol_used);
+	}
+
+	set_64bit_val(cqp->host_ctx, 0, temp);
+	set_64bit_val(cqp->host_ctx, 8, cqp->sq_pa);
+
+	temp = FIELD_PREP(IRDMA_CQPHC_ENABLED_VFS, cqp->ena_vf_count) |
+	       FIELD_PREP(IRDMA_CQPHC_HMC_PROFILE, cqp->hmc_profile);
+	set_64bit_val(cqp->host_ctx, 16, temp);
+	set_64bit_val(cqp->host_ctx, 24, (uintptr_t)cqp);
+	temp = FIELD_PREP(IRDMA_CQPHC_HW_MAJVER, cqp->hw_maj_ver) |
+	       FIELD_PREP(IRDMA_CQPHC_HW_MINVER, cqp->hw_min_ver);
+	if (hw_rev >= IRDMA_GEN_2) {
+		temp |= FIELD_PREP(IRDMA_CQPHC_MIN_RATE, cqp->dcqcn_params.min_rate) |
+			FIELD_PREP(IRDMA_CQPHC_MIN_DEC_FACTOR, cqp->dcqcn_params.min_dec_factor);
+	}
+	set_64bit_val(cqp->host_ctx, 32, temp);
+	set_64bit_val(cqp->host_ctx, 40, 0);
+	temp = 0;
+	if (hw_rev >= IRDMA_GEN_2) {
+		temp |= FIELD_PREP(IRDMA_CQPHC_DCQCN_T, cqp->dcqcn_params.dcqcn_t) |
+			FIELD_PREP(IRDMA_CQPHC_RAI_FACTOR, cqp->dcqcn_params.rai_factor) |
+			FIELD_PREP(IRDMA_CQPHC_HAI_FACTOR, cqp->dcqcn_params.hai_factor);
+	}
+	set_64bit_val(cqp->host_ctx, 48, temp);
+	temp = 0;
+	if (hw_rev >= IRDMA_GEN_2) {
+		temp |= FIELD_PREP(IRDMA_CQPHC_DCQCN_B, cqp->dcqcn_params.dcqcn_b) |
+			FIELD_PREP(IRDMA_CQPHC_DCQCN_F, cqp->dcqcn_params.dcqcn_f) |
+			FIELD_PREP(IRDMA_CQPHC_CC_CFG_VALID, cqp->dcqcn_params.cc_cfg_valid) |
+			FIELD_PREP(IRDMA_CQPHC_RREDUCE_MPERIOD, cqp->dcqcn_params.rreduce_mperiod);
+	}
+	set_64bit_val(cqp->host_ctx, 56, temp);
+	print_hex_dump_debug("WQE: CQP_HOST_CTX WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, cqp->host_ctx, IRDMA_CQP_CTX_SIZE * 8, false);
+	p1 = cqp->host_ctx_pa >> 32;
+	p2 = (u32)cqp->host_ctx_pa;
+
+	writel(p1, cqp->dev->hw_regs[IRDMA_CCQPHIGH]);
+	writel(p2, cqp->dev->hw_regs[IRDMA_CCQPLOW]);
+
+	do {
+		if (cnt++ > cqp->dev->hw_attrs.max_done_count) {
+			ret_code = IRDMA_ERR_TIMEOUT;
+			goto err;
+		}
+		udelay(cqp->dev->hw_attrs.max_sleep_count);
+		val = readl(cqp->dev->hw_regs[IRDMA_CCQPSTATUS]);
+	} while (!val);
+
+	if (FLD_RS_32(cqp->dev, val, IRDMA_CCQPSTATUS_CCQP_ERR)) {
+		ret_code = IRDMA_ERR_DEVICE_NOT_SUPPORTED;
+		goto err;
+	}
+
+	cqp->process_cqp_sds = irdma_update_sds_noccq;
+	return 0;
+
+err:
+	dma_free_coherent(cqp->dev->hw->device, cqp->sdbuf.size,
+			  cqp->sdbuf.va, cqp->sdbuf.pa);
+	cqp->sdbuf.va = NULL;
+	err_code = readl(cqp->dev->hw_regs[IRDMA_CQPERRCODES]);
+	*min_err = FIELD_GET(IRDMA_CQPERRCODES_CQP_MINOR_CODE, err_code);
+	*maj_err = FIELD_GET(IRDMA_CQPERRCODES_CQP_MAJOR_CODE, err_code);
+	return ret_code;
+}
+
+/**
+ * irdma_sc_cqp_post_sq - post of cqp's sq
+ * @cqp: struct for cqp hw
+ */
+void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp)
+{
+	writel(IRDMA_RING_CURRENT_HEAD(cqp->sq_ring), cqp->dev->cqp_db);
+
+	ibdev_dbg(to_ibdev(cqp->dev),
+		  "WQE: CQP SQ head 0x%x tail 0x%x size 0x%x\n",
+		  cqp->sq_ring.head, cqp->sq_ring.tail, cqp->sq_ring.size);
+}
+
+/**
+ * irdma_sc_cqp_get_next_send_wqe_idx - get next wqe on cqp sq
+ * and pass back index
+ * @cqp: CQP HW structure
+ * @scratch: private data for CQP WQE
+ * @wqe_idx: WQE index of CQP SQ
+ */
+__le64 *irdma_sc_cqp_get_next_send_wqe_idx(struct irdma_sc_cqp *cqp, u64 scratch,
+					   u32 *wqe_idx)
+{
+	__le64 *wqe = NULL;
+	enum irdma_status_code ret_code;
+
+	if (IRDMA_RING_FULL_ERR(cqp->sq_ring)) {
+		ibdev_dbg(to_ibdev(cqp->dev),
+			  "WQE: CQP SQ is full, head 0x%x tail 0x%x size 0x%x\n",
+			  cqp->sq_ring.head, cqp->sq_ring.tail,
+			  cqp->sq_ring.size);
+		return NULL;
+	}
+	IRDMA_ATOMIC_RING_MOVE_HEAD(cqp->sq_ring, *wqe_idx, ret_code);
+	if (ret_code)
+		return NULL;
+
+	cqp->dev->cqp_cmd_stats[IRDMA_OP_REQ_CMDS]++;
+	if (!*wqe_idx)
+		cqp->polarity = !cqp->polarity;
+	wqe = cqp->sq_base[*wqe_idx].elem;
+	cqp->scratch_array[*wqe_idx] = scratch;
+	IRDMA_CQP_INIT_WQE(wqe);
+
+	return wqe;
+}
+
+/**
+ * irdma_sc_cqp_destroy - destroy cqp during close
+ * @cqp: struct for cqp hw
+ */
+enum irdma_status_code irdma_sc_cqp_destroy(struct irdma_sc_cqp *cqp)
+{
+	u32 cnt = 0, val = 1;
+	enum irdma_status_code ret_code = 0;
+
+	writel(0, cqp->dev->hw_regs[IRDMA_CCQPHIGH]);
+	writel(0, cqp->dev->hw_regs[IRDMA_CCQPLOW]);
+	do {
+		if (cnt++ > cqp->dev->hw_attrs.max_done_count) {
+			ret_code = IRDMA_ERR_TIMEOUT;
+			break;
+		}
+		udelay(cqp->dev->hw_attrs.max_sleep_count);
+		val = readl(cqp->dev->hw_regs[IRDMA_CCQPSTATUS]);
+	} while (FLD_RS_32(cqp->dev, val, IRDMA_CCQPSTATUS_CCQP_DONE));
+
+	dma_free_coherent(cqp->dev->hw->device, cqp->sdbuf.size,
+			  cqp->sdbuf.va, cqp->sdbuf.pa);
+	cqp->sdbuf.va = NULL;
+	return ret_code;
+}
+
+/**
+ * irdma_sc_ccq_arm - enable intr for control cq
+ * @ccq: ccq sc struct
+ */
+void irdma_sc_ccq_arm(struct irdma_sc_cq *ccq)
+{
+	u64 temp_val;
+	u16 sw_cq_sel;
+	u8 arm_next_se;
+	u8 arm_seq_num;
+
+	get_64bit_val(ccq->cq_uk.shadow_area, 32, &temp_val);
+	sw_cq_sel = (u16)FIELD_GET(IRDMA_CQ_DBSA_SW_CQ_SELECT, temp_val);
+	arm_next_se = (u8)FIELD_GET(IRDMA_CQ_DBSA_ARM_NEXT_SE, temp_val);
+	arm_seq_num = (u8)FIELD_GET(IRDMA_CQ_DBSA_ARM_SEQ_NUM, temp_val);
+	arm_seq_num++;
+	temp_val = FIELD_PREP(IRDMA_CQ_DBSA_ARM_SEQ_NUM, arm_seq_num) |
+		   FIELD_PREP(IRDMA_CQ_DBSA_SW_CQ_SELECT, sw_cq_sel) |
+		   FIELD_PREP(IRDMA_CQ_DBSA_ARM_NEXT_SE, arm_next_se) |
+		   FIELD_PREP(IRDMA_CQ_DBSA_ARM_NEXT, 1);
+	set_64bit_val(ccq->cq_uk.shadow_area, 32, temp_val);
+
+	dma_wmb(); /* make sure shadow area is updated before arming */
+
+	writel(ccq->cq_uk.cq_id, ccq->dev->cq_arm_db);
+}
+
+/**
+ * irdma_sc_ccq_get_cqe_info - get ccq's cq entry
+ * @ccq: ccq sc struct
+ * @info: completion q entry to return
+ */
+enum irdma_status_code irdma_sc_ccq_get_cqe_info(struct irdma_sc_cq *ccq,
+						 struct irdma_ccq_cqe_info *info)
+{
+	u64 qp_ctx, temp, temp1;
+	__le64 *cqe;
+	struct irdma_sc_cqp *cqp;
+	u32 wqe_idx;
+	u32 error;
+	u8 polarity;
+	enum irdma_status_code ret_code = 0;
+
+	if (ccq->cq_uk.avoid_mem_cflct)
+		cqe = IRDMA_GET_CURRENT_EXTENDED_CQ_ELEM(&ccq->cq_uk);
+	else
+		cqe = IRDMA_GET_CURRENT_CQ_ELEM(&ccq->cq_uk);
+
+	get_64bit_val(cqe, 24, &temp);
+	polarity = (u8)FIELD_GET(IRDMA_CQ_VALID, temp);
+	if (polarity != ccq->cq_uk.polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	get_64bit_val(cqe, 8, &qp_ctx);
+	cqp = (struct irdma_sc_cqp *)(unsigned long)qp_ctx;
+	info->error = (bool)FIELD_GET(IRDMA_CQ_ERROR, temp);
+	info->maj_err_code = IRDMA_CQPSQ_MAJ_NO_ERROR;
+	info->min_err_code = (u16)FIELD_GET(IRDMA_CQ_MINERR, temp);
+	if (info->error) {
+		info->maj_err_code = (u16)FIELD_GET(IRDMA_CQ_MAJERR, temp);
+		error = readl(cqp->dev->hw_regs[IRDMA_CQPERRCODES]);
+		ibdev_dbg(to_ibdev(cqp->dev),
+			  "CQP: CQPERRCODES error_code[x%08X]\n", error);
+	}
+
+	wqe_idx = (u32)FIELD_GET(IRDMA_CQ_WQEIDX, temp);
+	info->scratch = cqp->scratch_array[wqe_idx];
+
+	get_64bit_val(cqe, 16, &temp1);
+	info->op_ret_val = (u32)FIELD_GET(IRDMA_CCQ_OPRETVAL, temp1);
+	get_64bit_val(cqp->sq_base[wqe_idx].elem, 24, &temp1);
+	info->op_code = (u8)FIELD_GET(IRDMA_CQPSQ_OPCODE, temp1);
+	info->cqp = cqp;
+
+	/*  move the head for cq */
+	IRDMA_RING_MOVE_HEAD(ccq->cq_uk.cq_ring, ret_code);
+	if (!IRDMA_RING_CURRENT_HEAD(ccq->cq_uk.cq_ring))
+		ccq->cq_uk.polarity ^= 1;
+
+	/* update cq tail in cq shadow memory also */
+	IRDMA_RING_MOVE_TAIL(ccq->cq_uk.cq_ring);
+	set_64bit_val(ccq->cq_uk.shadow_area, 0,
+		      IRDMA_RING_CURRENT_HEAD(ccq->cq_uk.cq_ring));
+
+	dma_wmb(); /* make sure shadow area is updated before moving tail */
+
+	IRDMA_RING_MOVE_TAIL(cqp->sq_ring);
+	ccq->dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS]++;
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_poll_for_cqp_op_done - Waits for last write to complete in CQP SQ
+ * @cqp: struct for cqp hw
+ * @op_code: cqp opcode for completion
+ * @compl_info: completion q entry to return
+ */
+enum irdma_status_code irdma_sc_poll_for_cqp_op_done(struct irdma_sc_cqp *cqp, u8 op_code,
+						     struct irdma_ccq_cqe_info *compl_info)
+{
+	struct irdma_ccq_cqe_info info = {};
+	struct irdma_sc_cq *ccq;
+	enum irdma_status_code ret_code = 0;
+	u32 cnt = 0;
+
+	ccq = cqp->dev->ccq;
+	while (1) {
+		if (cnt++ > 100 * cqp->dev->hw_attrs.max_done_count)
+			return IRDMA_ERR_TIMEOUT;
+
+		if (irdma_sc_ccq_get_cqe_info(ccq, &info)) {
+			udelay(cqp->dev->hw_attrs.max_sleep_count);
+			continue;
+		}
+		if (info.error && info.op_code != IRDMA_CQP_OP_QUERY_STAG) {
+			ret_code = IRDMA_ERR_CQP_COMPL_ERROR;
+			break;
+		}
+		/* make sure op code matches*/
+		if (op_code == info.op_code)
+			break;
+		ibdev_dbg(to_ibdev(cqp->dev),
+			  "WQE: opcode mismatch for my op code 0x%x, returned opcode %x\n",
+			  op_code, info.op_code);
+	}
+
+	if (compl_info)
+		memcpy(compl_info, &info, sizeof(*compl_info));
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_manage_hmc_pm_func_table - manage of function table
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @info: info for the manage function table operation
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_manage_hmc_pm_func_table(struct irdma_sc_cqp *cqp,
+				  struct irdma_hmc_fcn_info *info,
+				  u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, 0);
+	set_64bit_val(wqe, 8, 0);
+	set_64bit_val(wqe, 16, 0);
+	set_64bit_val(wqe, 32, 0);
+	set_64bit_val(wqe, 40, 0);
+	set_64bit_val(wqe, 48, 0);
+	set_64bit_val(wqe, 56, 0);
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_MHMC_VFIDX, info->vf_id) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+			 IRDMA_CQP_OP_MANAGE_HMC_PM_FUNC_TABLE) |
+	      FIELD_PREP(IRDMA_CQPSQ_MHMC_FREEPMFN, info->free_fcn) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: MANAGE_HMC_PM_FUNC_TABLE WQE",
+			     DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_commit_fpm_val_done - wait for cqp eqe completion
+ * for fpm commit
+ * @cqp: struct for cqp hw
+ */
+static enum irdma_status_code
+irdma_sc_commit_fpm_val_done(struct irdma_sc_cqp *cqp)
+{
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_COMMIT_FPM_VAL,
+					     NULL);
+}
+
+/**
+ * irdma_sc_commit_fpm_val - cqp wqe for commit fpm values
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @hmc_fn_id: hmc function id
+ * @commit_fpm_mem: Memory for fpm values
+ * @post_sq: flag for cqp db to ring
+ * @wait_type: poll ccq or cqp registers for cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_commit_fpm_val(struct irdma_sc_cqp *cqp, u64 scratch, u8 hmc_fn_id,
+			struct irdma_dma_mem *commit_fpm_mem, bool post_sq,
+			u8 wait_type)
+{
+	__le64 *wqe;
+	u64 hdr;
+	u32 tail, val, error;
+	enum irdma_status_code ret_code = 0;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, hmc_fn_id);
+	set_64bit_val(wqe, 32, commit_fpm_mem->pa);
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_BUFSIZE, IRDMA_COMMIT_FPM_BUF_SIZE) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_COMMIT_FPM_VAL) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: COMMIT_FPM_VAL WQE", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		if (wait_type == IRDMA_CQP_WAIT_POLL_REGS)
+			ret_code = irdma_cqp_poll_registers(cqp, tail,
+							    cqp->dev->hw_attrs.max_done_count);
+		else if (wait_type == IRDMA_CQP_WAIT_POLL_CQ)
+			ret_code = irdma_sc_commit_fpm_val_done(cqp);
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_query_fpm_val_done - poll for cqp wqe completion for
+ * query fpm
+ * @cqp: struct for cqp hw
+ */
+static enum irdma_status_code
+irdma_sc_query_fpm_val_done(struct irdma_sc_cqp *cqp)
+{
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_QUERY_FPM_VAL,
+					     NULL);
+}
+
+/**
+ * irdma_sc_query_fpm_val - cqp wqe query fpm values
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @hmc_fn_id: hmc function id
+ * @query_fpm_mem: memory for return fpm values
+ * @post_sq: flag for cqp db to ring
+ * @wait_type: poll ccq or cqp registers for cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_query_fpm_val(struct irdma_sc_cqp *cqp, u64 scratch, u8 hmc_fn_id,
+		       struct irdma_dma_mem *query_fpm_mem, bool post_sq,
+		       u8 wait_type)
+{
+	__le64 *wqe;
+	u64 hdr;
+	u32 tail, val, error;
+	enum irdma_status_code ret_code = 0;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, hmc_fn_id);
+	set_64bit_val(wqe, 32, query_fpm_mem->pa);
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_QUERY_FPM_VAL) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: QUERY_FPM WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		if (wait_type == IRDMA_CQP_WAIT_POLL_REGS)
+			ret_code = irdma_cqp_poll_registers(cqp, tail,
+							    cqp->dev->hw_attrs.max_done_count);
+		else if (wait_type == IRDMA_CQP_WAIT_POLL_CQ)
+			ret_code = irdma_sc_query_fpm_val_done(cqp);
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_ceq_init - initialize ceq
+ * @ceq: ceq sc structure
+ * @info: ceq initialization info
+ */
+enum irdma_status_code irdma_sc_ceq_init(struct irdma_sc_ceq *ceq,
+					 struct irdma_ceq_init_info *info)
+{
+	u32 pble_obj_cnt;
+
+	if (info->elem_cnt < info->dev->hw_attrs.min_hw_ceq_size ||
+	    info->elem_cnt > info->dev->hw_attrs.max_hw_ceq_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	if (info->ceq_id > (info->dev->hmc_fpm_misc.max_ceqs - 1))
+		return IRDMA_ERR_INVALID_CEQ_ID;
+	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+
+	if (info->virtual_map && info->first_pm_pbl_idx >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	ceq->size = sizeof(*ceq);
+	ceq->ceqe_base = (struct irdma_ceqe *)info->ceqe_base;
+	ceq->ceq_id = info->ceq_id;
+	ceq->dev = info->dev;
+	ceq->elem_cnt = info->elem_cnt;
+	ceq->ceq_elem_pa = info->ceqe_pa;
+	ceq->virtual_map = info->virtual_map;
+	ceq->itr_no_expire = info->itr_no_expire;
+	ceq->reg_cq = info->reg_cq;
+	ceq->reg_cq_size = 0;
+	spin_lock_init(&ceq->req_cq_lock);
+	ceq->pbl_chunk_size = (ceq->virtual_map ? info->pbl_chunk_size : 0);
+	ceq->first_pm_pbl_idx = (ceq->virtual_map ? info->first_pm_pbl_idx : 0);
+	ceq->pbl_list = (ceq->virtual_map ? info->pbl_list : NULL);
+	ceq->tph_en = info->tph_en;
+	ceq->tph_val = info->tph_val;
+	ceq->vsi = info->vsi;
+	ceq->polarity = 1;
+	IRDMA_RING_INIT(ceq->ceq_ring, ceq->elem_cnt);
+	ceq->dev->ceq[info->ceq_id] = ceq;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_ceq_create - create ceq wqe
+ * @ceq: ceq sc structure
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+
+static enum irdma_status_code irdma_sc_ceq_create(struct irdma_sc_ceq *ceq, u64 scratch,
+						  bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+
+	cqp = ceq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 16, ceq->elem_cnt);
+	set_64bit_val(wqe, 32,
+		      (ceq->virtual_map ? 0 : ceq->ceq_elem_pa));
+	set_64bit_val(wqe, 48,
+		      (ceq->virtual_map ? ceq->first_pm_pbl_idx : 0));
+	set_64bit_val(wqe, 56,
+		      FIELD_PREP(IRDMA_CQPSQ_TPHVAL, ceq->tph_val) |
+		      FIELD_PREP(IRDMA_CQPSQ_VSIIDX, ceq->vsi->vsi_idx));
+	hdr = FIELD_PREP(IRDMA_CQPSQ_CEQ_CEQID, ceq->ceq_id) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_CREATE_CEQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CEQ_LPBLSIZE, ceq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_CEQ_VMAP, ceq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_CEQ_ITRNOEXPIRE, ceq->itr_no_expire) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, ceq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CEQ_CREATE WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cceq_create_done - poll for control ceq wqe to complete
+ * @ceq: ceq sc structure
+ */
+static enum irdma_status_code
+irdma_sc_cceq_create_done(struct irdma_sc_ceq *ceq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	cqp = ceq->dev->cqp;
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_CREATE_CEQ,
+					     NULL);
+}
+
+/**
+ * irdma_sc_cceq_destroy_done - poll for destroy cceq to complete
+ * @ceq: ceq sc structure
+ */
+enum irdma_status_code irdma_sc_cceq_destroy_done(struct irdma_sc_ceq *ceq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	if (ceq->reg_cq)
+		irdma_sc_remove_cq_ctx(ceq, ceq->dev->ccq);
+
+	cqp = ceq->dev->cqp;
+	cqp->process_cqp_sds = irdma_update_sds_noccq;
+
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_DESTROY_CEQ,
+					     NULL);
+}
+
+/**
+ * irdma_sc_cceq_create - create cceq
+ * @ceq: ceq sc structure
+ * @scratch: u64 saved to be used during cqp completion
+ */
+enum irdma_status_code irdma_sc_cceq_create(struct irdma_sc_ceq *ceq, u64 scratch)
+{
+	enum irdma_status_code ret_code;
+	struct irdma_sc_dev *dev = ceq->dev;
+
+	dev->ccq->vsi = ceq->vsi;
+	if (ceq->reg_cq) {
+		ret_code = irdma_sc_add_cq_ctx(ceq, ceq->dev->ccq);
+		if (ret_code)
+			return ret_code;
+	}
+
+	ret_code = irdma_sc_ceq_create(ceq, scratch, true);
+	if (!ret_code)
+		return irdma_sc_cceq_create_done(ceq);
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_ceq_destroy - destroy ceq
+ * @ceq: ceq sc structure
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_ceq_destroy(struct irdma_sc_ceq *ceq, u64 scratch,
+					    bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+
+	cqp = ceq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, ceq->elem_cnt);
+	set_64bit_val(wqe, 48, ceq->first_pm_pbl_idx);
+	hdr = ceq->ceq_id |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_CEQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CEQ_LPBLSIZE, ceq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_CEQ_VMAP, ceq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, ceq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CEQ_DESTROY WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_process_ceq - process ceq
+ * @dev: sc device struct
+ * @ceq: ceq sc structure
+ *
+ * It is expected caller serializes this function with cleanup_ceqes()
+ * because these functions manipulate the same ceq
+ */
+void *irdma_sc_process_ceq(struct irdma_sc_dev *dev, struct irdma_sc_ceq *ceq)
+{
+	u64 temp;
+	__le64 *ceqe;
+	struct irdma_sc_cq *cq = NULL;
+	struct irdma_sc_cq *temp_cq;
+	u8 polarity;
+	u32 cq_idx;
+	unsigned long flags;
+
+	do {
+		cq_idx = 0;
+		ceqe = IRDMA_GET_CURRENT_CEQ_ELEM(ceq);
+		get_64bit_val(ceqe, 0, &temp);
+		polarity = (u8)FIELD_GET(IRDMA_CEQE_VALID, temp);
+		if (polarity != ceq->polarity)
+			return NULL;
+
+		temp_cq = (struct irdma_sc_cq *)(unsigned long)(temp << 1);
+		if (!temp_cq) {
+			cq_idx = IRDMA_INVALID_CQ_IDX;
+			IRDMA_RING_MOVE_TAIL(ceq->ceq_ring);
+
+			if (!IRDMA_RING_CURRENT_TAIL(ceq->ceq_ring))
+				ceq->polarity ^= 1;
+			continue;
+		}
+
+		cq = temp_cq;
+		if (ceq->reg_cq) {
+			spin_lock_irqsave(&ceq->req_cq_lock, flags);
+			cq_idx = irdma_sc_find_reg_cq(ceq, cq);
+			spin_unlock_irqrestore(&ceq->req_cq_lock, flags);
+		}
+
+		IRDMA_RING_MOVE_TAIL(ceq->ceq_ring);
+		if (!IRDMA_RING_CURRENT_TAIL(ceq->ceq_ring))
+			ceq->polarity ^= 1;
+	} while (cq_idx == IRDMA_INVALID_CQ_IDX);
+
+	if (cq)
+		irdma_sc_cq_ack(cq);
+	return cq;
+}
+
+/**
+ * irdma_sc_cleanup_ceqes - clear the valid ceqes ctx matching the cq
+ * @cq: cq for which the ceqes need to be cleaned up
+ * @ceq: ceq ptr
+ *
+ * The function is called after the cq is destroyed to cleanup
+ * its pending ceqe entries. It is expected caller serializes this
+ * function with process_ceq() in interrupt context.
+ */
+void irdma_sc_cleanup_ceqes(struct irdma_sc_cq *cq, struct irdma_sc_ceq *ceq)
+{
+	struct irdma_sc_cq *next_cq;
+	u8 ceq_polarity = ceq->polarity;
+	__le64 *ceqe;
+	u8 polarity;
+	u64 temp;
+	int next;
+	u32 i;
+
+	next = IRDMA_RING_GET_NEXT_TAIL(ceq->ceq_ring, 0);
+
+	for (i = 1; i <= IRDMA_RING_SIZE(*ceq); i++) {
+		ceqe = IRDMA_GET_CEQ_ELEM_AT_POS(ceq, next);
+
+		get_64bit_val(ceqe, 0, &temp);
+		polarity = (u8)FIELD_GET(IRDMA_CEQE_VALID, temp);
+		if (polarity != ceq_polarity)
+			return;
+
+		next_cq = (struct irdma_sc_cq *)(unsigned long)(temp << 1);
+		if (cq == next_cq)
+			set_64bit_val(ceqe, 0, temp & IRDMA_CEQE_VALID);
+
+		next = IRDMA_RING_GET_NEXT_TAIL(ceq->ceq_ring, i);
+		if (!next)
+			ceq_polarity ^= 1;
+	}
+}
+
+/**
+ * irdma_sc_aeq_init - initialize aeq
+ * @aeq: aeq structure ptr
+ * @info: aeq initialization info
+ */
+enum irdma_status_code irdma_sc_aeq_init(struct irdma_sc_aeq *aeq,
+					 struct irdma_aeq_init_info *info)
+{
+	u32 pble_obj_cnt;
+
+	if (info->elem_cnt < info->dev->hw_attrs.min_hw_aeq_size ||
+	    info->elem_cnt > info->dev->hw_attrs.max_hw_aeq_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+
+	if (info->virtual_map && info->first_pm_pbl_idx >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	aeq->size = sizeof(*aeq);
+	aeq->polarity = 1;
+	aeq->aeqe_base = (struct irdma_sc_aeqe *)info->aeqe_base;
+	aeq->dev = info->dev;
+	aeq->elem_cnt = info->elem_cnt;
+	aeq->aeq_elem_pa = info->aeq_elem_pa;
+	IRDMA_RING_INIT(aeq->aeq_ring, aeq->elem_cnt);
+	aeq->virtual_map = info->virtual_map;
+	aeq->pbl_list = (aeq->virtual_map ? info->pbl_list : NULL);
+	aeq->pbl_chunk_size = (aeq->virtual_map ? info->pbl_chunk_size : 0);
+	aeq->first_pm_pbl_idx = (aeq->virtual_map ? info->first_pm_pbl_idx : 0);
+	aeq->msix_idx = info->msix_idx;
+	info->dev->aeq = aeq;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_aeq_create - create aeq
+ * @aeq: aeq structure ptr
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_aeq_create(struct irdma_sc_aeq *aeq,
+						  u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+
+	cqp = aeq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 16, aeq->elem_cnt);
+	set_64bit_val(wqe, 32,
+		      (aeq->virtual_map ? 0 : aeq->aeq_elem_pa));
+	set_64bit_val(wqe, 48,
+		      (aeq->virtual_map ? aeq->first_pm_pbl_idx : 0));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_CREATE_AEQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_AEQ_LPBLSIZE, aeq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_AEQ_VMAP, aeq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: AEQ_CREATE WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_aeq_destroy - destroy aeq during close
+ * @aeq: aeq structure ptr
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_aeq_destroy(struct irdma_sc_aeq *aeq,
+						   u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	struct irdma_sc_dev *dev;
+	u64 hdr;
+
+	dev = aeq->dev;
+	writel(0, dev->hw_regs[IRDMA_PFINT_AEQCTL]);
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 16, aeq->elem_cnt);
+	set_64bit_val(wqe, 48, aeq->first_pm_pbl_idx);
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_AEQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_AEQ_LPBLSIZE, aeq->pbl_chunk_size) |
+	      FIELD_PREP(IRDMA_CQPSQ_AEQ_VMAP, aeq->virtual_map) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: AEQ_DESTROY WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_get_next_aeqe - get next aeq entry
+ * @aeq: aeq structure ptr
+ * @info: aeqe info to be returned
+ */
+enum irdma_status_code irdma_sc_get_next_aeqe(struct irdma_sc_aeq *aeq,
+					      struct irdma_aeqe_info *info)
+{
+	u64 temp, compl_ctx;
+	__le64 *aeqe;
+	u16 wqe_idx;
+	u8 ae_src;
+	u8 polarity;
+
+	aeqe = IRDMA_GET_CURRENT_AEQ_ELEM(aeq);
+	get_64bit_val(aeqe, 0, &compl_ctx);
+	get_64bit_val(aeqe, 8, &temp);
+	polarity = (u8)FIELD_GET(IRDMA_AEQE_VALID, temp);
+
+	if (aeq->polarity != polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	print_hex_dump_debug("WQE: AEQ_ENTRY WQE", DUMP_PREFIX_OFFSET, 16, 8,
+			     aeqe, 16, false);
+
+	ae_src = (u8)FIELD_GET(IRDMA_AEQE_AESRC, temp);
+	wqe_idx = (u16)FIELD_GET(IRDMA_AEQE_WQDESCIDX, temp);
+	info->qp_cq_id = (u32)FIELD_GET(IRDMA_AEQE_QPCQID_LOW, temp) |
+			 ((u32)FIELD_GET(IRDMA_AEQE_QPCQID_HI, temp) << 18);
+	info->ae_id = (u16)FIELD_GET(IRDMA_AEQE_AECODE, temp);
+	info->tcp_state = (u8)FIELD_GET(IRDMA_AEQE_TCPSTATE, temp);
+	info->iwarp_state = (u8)FIELD_GET(IRDMA_AEQE_IWSTATE, temp);
+	info->q2_data_written = (u8)FIELD_GET(IRDMA_AEQE_Q2DATA, temp);
+	info->aeqe_overflow = (bool)FIELD_GET(IRDMA_AEQE_OVERFLOW, temp);
+
+	info->ae_src = ae_src;
+	switch (info->ae_id) {
+	case IRDMA_AE_PRIV_OPERATION_DENIED:
+	case IRDMA_AE_AMP_INVALIDATE_TYPE1_MW:
+	case IRDMA_AE_AMP_MWBIND_ZERO_BASED_TYPE1_MW:
+	case IRDMA_AE_AMP_FASTREG_INVALID_PBL_HPS_CFG:
+	case IRDMA_AE_AMP_FASTREG_PBLE_MISMATCH:
+	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
+	case IRDMA_AE_UDA_XMIT_BAD_PD:
+	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_SHORT:
+	case IRDMA_AE_BAD_CLOSE:
+	case IRDMA_AE_RDMA_READ_WHILE_ORD_ZERO:
+	case IRDMA_AE_STAG_ZERO_INVALID:
+	case IRDMA_AE_IB_RREQ_AND_Q1_FULL:
+	case IRDMA_AE_IB_INVALID_REQUEST:
+	case IRDMA_AE_WQE_UNEXPECTED_OPCODE:
+	case IRDMA_AE_IB_REMOTE_ACCESS_ERROR:
+	case IRDMA_AE_IB_REMOTE_OP_ERROR:
+	case IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION:
+	case IRDMA_AE_DDP_UBE_INVALID_MO:
+	case IRDMA_AE_DDP_UBE_INVALID_QN:
+	case IRDMA_AE_DDP_NO_L_BIT:
+	case IRDMA_AE_RDMAP_ROE_INVALID_RDMAP_VERSION:
+	case IRDMA_AE_RDMAP_ROE_UNEXPECTED_OPCODE:
+	case IRDMA_AE_ROE_INVALID_RDMA_READ_REQUEST:
+	case IRDMA_AE_ROE_INVALID_RDMA_WRITE_OR_READ_RESP:
+	case IRDMA_AE_ROCE_RSP_LENGTH_ERROR:
+	case IRDMA_AE_INVALID_ARP_ENTRY:
+	case IRDMA_AE_INVALID_TCP_OPTION_RCVD:
+	case IRDMA_AE_STALE_ARP_ENTRY:
+	case IRDMA_AE_INVALID_AH_ENTRY:
+	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
+	case IRDMA_AE_LLP_SEGMENT_TOO_SMALL:
+	case IRDMA_AE_LLP_TOO_MANY_RETRIES:
+	case IRDMA_AE_LLP_DOUBT_REACHABILITY:
+	case IRDMA_AE_LLP_CONNECTION_ESTABLISHED:
+	case IRDMA_AE_RESET_SENT:
+	case IRDMA_AE_TERMINATE_SENT:
+	case IRDMA_AE_RESET_NOT_SENT:
+	case IRDMA_AE_LCE_QP_CATASTROPHIC:
+	case IRDMA_AE_QP_SUSPEND_COMPLETE:
+	case IRDMA_AE_UDA_L4LEN_INVALID:
+		info->qp = true;
+		info->compl_ctx = compl_ctx;
+		break;
+	case IRDMA_AE_LCE_CQ_CATASTROPHIC:
+		info->cq = true;
+		info->compl_ctx = compl_ctx << 1;
+		ae_src = IRDMA_AE_SOURCE_RSVD;
+		break;
+	case IRDMA_AE_ROCE_EMPTY_MCG:
+	case IRDMA_AE_ROCE_BAD_MC_IP_ADDR:
+	case IRDMA_AE_ROCE_BAD_MC_QPID:
+	case IRDMA_AE_MCG_QP_PROTOCOL_MISMATCH:
+		fallthrough;
+	case IRDMA_AE_LLP_CONNECTION_RESET:
+	case IRDMA_AE_LLP_SYN_RECEIVED:
+	case IRDMA_AE_LLP_FIN_RECEIVED:
+	case IRDMA_AE_LLP_CLOSE_COMPLETE:
+	case IRDMA_AE_LLP_TERMINATE_RECEIVED:
+	case IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE:
+		ae_src = IRDMA_AE_SOURCE_RSVD;
+		info->qp = true;
+		info->compl_ctx = compl_ctx;
+		break;
+	default:
+		break;
+	}
+
+	switch (ae_src) {
+	case IRDMA_AE_SOURCE_RQ:
+	case IRDMA_AE_SOURCE_RQ_0011:
+		info->qp = true;
+		info->rq = true;
+		info->wqe_idx = wqe_idx;
+		info->compl_ctx = compl_ctx;
+		break;
+	case IRDMA_AE_SOURCE_CQ:
+	case IRDMA_AE_SOURCE_CQ_0110:
+	case IRDMA_AE_SOURCE_CQ_1010:
+	case IRDMA_AE_SOURCE_CQ_1110:
+		info->cq = true;
+		info->compl_ctx = compl_ctx << 1;
+		break;
+	case IRDMA_AE_SOURCE_SQ:
+	case IRDMA_AE_SOURCE_SQ_0111:
+		info->qp = true;
+		info->sq = true;
+		info->wqe_idx = wqe_idx;
+		info->compl_ctx = compl_ctx;
+		break;
+	case IRDMA_AE_SOURCE_IN_RR_WR:
+	case IRDMA_AE_SOURCE_IN_RR_WR_1011:
+		info->qp = true;
+		info->compl_ctx = compl_ctx;
+		info->in_rdrsp_wr = true;
+		break;
+	case IRDMA_AE_SOURCE_OUT_RR:
+	case IRDMA_AE_SOURCE_OUT_RR_1111:
+		info->qp = true;
+		info->compl_ctx = compl_ctx;
+		info->out_rdrsp = true;
+		break;
+	case IRDMA_AE_SOURCE_RSVD:
+	default:
+		break;
+	}
+
+	IRDMA_RING_MOVE_TAIL(aeq->aeq_ring);
+	if (!IRDMA_RING_CURRENT_TAIL(aeq->aeq_ring))
+		aeq->polarity ^= 1;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_repost_aeq_entries - repost completed aeq entries
+ * @dev: sc device struct
+ * @count: allocate count
+ */
+enum irdma_status_code irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev, u32 count)
+{
+	writel(count, dev->hw_regs[IRDMA_AEQALLOC]);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_ccq_init - initialize control cq
+ * @cq: sc's cq ctruct
+ * @info: info for control cq initialization
+ */
+enum irdma_status_code irdma_sc_ccq_init(struct irdma_sc_cq *cq,
+					 struct irdma_ccq_init_info *info)
+{
+	u32 pble_obj_cnt;
+
+	if (info->num_elem < info->dev->hw_attrs.uk_attrs.min_hw_cq_size ||
+	    info->num_elem > info->dev->hw_attrs.uk_attrs.max_hw_cq_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	if (info->ceq_id > (info->dev->hmc_fpm_misc.max_ceqs - 1))
+		return IRDMA_ERR_INVALID_CEQ_ID;
+
+	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
+
+	if (info->virtual_map && info->first_pm_pbl_idx >= pble_obj_cnt)
+		return IRDMA_ERR_INVALID_PBLE_INDEX;
+
+	cq->cq_pa = info->cq_pa;
+	cq->cq_uk.cq_base = info->cq_base;
+	cq->shadow_area_pa = info->shadow_area_pa;
+	cq->cq_uk.shadow_area = info->shadow_area;
+	cq->shadow_read_threshold = info->shadow_read_threshold;
+	cq->dev = info->dev;
+	cq->ceq_id = info->ceq_id;
+	cq->cq_uk.cq_size = info->num_elem;
+	cq->cq_type = IRDMA_CQ_TYPE_CQP;
+	cq->ceqe_mask = info->ceqe_mask;
+	IRDMA_RING_INIT(cq->cq_uk.cq_ring, info->num_elem);
+	cq->cq_uk.cq_id = 0; /* control cq is id 0 always */
+	cq->ceq_id_valid = info->ceq_id_valid;
+	cq->tph_en = info->tph_en;
+	cq->tph_val = info->tph_val;
+	cq->cq_uk.avoid_mem_cflct = info->avoid_mem_cflct;
+	cq->pbl_list = info->pbl_list;
+	cq->virtual_map = info->virtual_map;
+	cq->pbl_chunk_size = info->pbl_chunk_size;
+	cq->first_pm_pbl_idx = info->first_pm_pbl_idx;
+	cq->cq_uk.polarity = true;
+	cq->vsi = info->vsi;
+	cq->cq_uk.cq_ack_db = cq->dev->cq_ack_db;
+
+	/* Only applicable to CQs other than CCQ so initialize to zero */
+	cq->cq_uk.cqe_alloc_db = NULL;
+
+	info->dev->ccq = cq;
+	return 0;
+}
+
+/**
+ * irdma_sc_ccq_create_done - poll cqp for ccq create
+ * @ccq: ccq sc struct
+ */
+static inline enum irdma_status_code irdma_sc_ccq_create_done(struct irdma_sc_cq *ccq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	cqp = ccq->dev->cqp;
+
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_CREATE_CQ, NULL);
+}
+
+/**
+ * irdma_sc_ccq_create - create control cq
+ * @ccq: ccq sc struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @check_overflow: overlow flag for ccq
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_ccq_create(struct irdma_sc_cq *ccq, u64 scratch,
+					   bool check_overflow, bool post_sq)
+{
+	enum irdma_status_code ret_code;
+
+	ret_code = irdma_sc_cq_create(ccq, scratch, check_overflow, post_sq);
+	if (ret_code)
+		return ret_code;
+
+	if (post_sq) {
+		ret_code = irdma_sc_ccq_create_done(ccq);
+		if (ret_code)
+			return ret_code;
+	}
+	ccq->dev->cqp->process_cqp_sds = irdma_cqp_sds_cmd;
+
+	return 0;
+}
+
+/**
+ * irdma_sc_ccq_destroy - destroy ccq during close
+ * @ccq: ccq sc struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+enum irdma_status_code irdma_sc_ccq_destroy(struct irdma_sc_cq *ccq, u64 scratch,
+					    bool post_sq)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+	enum irdma_status_code ret_code = 0;
+	u32 tail, val, error;
+
+	cqp = ccq->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, ccq->cq_uk.cq_size);
+	set_64bit_val(wqe, 8, (uintptr_t)ccq >> 1);
+	set_64bit_val(wqe, 40, ccq->shadow_area_pa);
+
+	hdr = ccq->cq_uk.cq_id |
+	      FLD_LS_64(ccq->dev, (ccq->ceq_id_valid ? ccq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_DESTROY_CQ) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_ENCEQEMASK, ccq->ceqe_mask) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_CEQIDVALID, ccq->ceq_id_valid) |
+	      FIELD_PREP(IRDMA_CQPSQ_TPHEN, ccq->tph_en) |
+	      FIELD_PREP(IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT, ccq->cq_uk.avoid_mem_cflct) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: CCQ_DESTROY WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		ret_code = irdma_cqp_poll_registers(cqp, tail,
+						    cqp->dev->hw_attrs.max_done_count);
+	}
+
+	cqp->process_cqp_sds = irdma_update_sds_noccq;
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_init_iw_hmc() - queries fpm values using cqp and populates hmc_info
+ * @dev : ptr to irdma_dev struct
+ * @hmc_fn_id: hmc function id
+ */
+enum irdma_status_code irdma_sc_init_iw_hmc(struct irdma_sc_dev *dev,
+					    u8 hmc_fn_id)
+{
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_hmc_fpm_misc *hmc_fpm_misc;
+	struct irdma_dma_mem query_fpm_mem;
+	enum irdma_status_code ret_code = 0;
+	u8 wait_type;
+
+	hmc_info = dev->hmc_info;
+	hmc_fpm_misc = &dev->hmc_fpm_misc;
+	query_fpm_mem.pa = dev->fpm_query_buf_pa;
+	query_fpm_mem.va = dev->fpm_query_buf;
+	hmc_info->hmc_fn_id = hmc_fn_id;
+	wait_type = (u8)IRDMA_CQP_WAIT_POLL_REGS;
+
+	ret_code = irdma_sc_query_fpm_val(dev->cqp, 0, hmc_info->hmc_fn_id,
+					  &query_fpm_mem, true, wait_type);
+	if (ret_code)
+		return ret_code;
+
+	/* parse the fpm_query_buf and fill hmc obj info */
+	ret_code = irdma_sc_parse_fpm_query_buf(dev, query_fpm_mem.va, hmc_info,
+						hmc_fpm_misc);
+
+	print_hex_dump_debug("HMC: QUERY FPM BUFFER", DUMP_PREFIX_OFFSET, 16,
+			     8, query_fpm_mem.va, IRDMA_QUERY_FPM_BUF_SIZE,
+			     false);
+	return ret_code;
+}
+
+/**
+ * irdma_sc_cfg_iw_fpm() - commits hmc obj cnt values using cqp
+ * command and populates fpm base address in hmc_info
+ * @dev : ptr to irdma_dev struct
+ * @hmc_fn_id: hmc function id
+ */
+static enum irdma_status_code irdma_sc_cfg_iw_fpm(struct irdma_sc_dev *dev,
+						  u8 hmc_fn_id)
+{
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_hmc_obj_info *obj_info;
+	__le64 *buf;
+	struct irdma_dma_mem commit_fpm_mem;
+	enum irdma_status_code ret_code = 0;
+	u8 wait_type;
+
+	hmc_info = dev->hmc_info;
+	obj_info = hmc_info->hmc_obj;
+	buf = dev->fpm_commit_buf;
+
+	set_64bit_val(buf, 0, (u64)obj_info[IRDMA_HMC_IW_QP].cnt);
+	set_64bit_val(buf, 8, (u64)obj_info[IRDMA_HMC_IW_CQ].cnt);
+	set_64bit_val(buf, 16, (u64)0); /* RSRVD */
+	set_64bit_val(buf, 24, (u64)obj_info[IRDMA_HMC_IW_HTE].cnt);
+	set_64bit_val(buf, 32, (u64)obj_info[IRDMA_HMC_IW_ARP].cnt);
+	set_64bit_val(buf, 40, (u64)0); /* RSVD */
+	set_64bit_val(buf, 48, (u64)obj_info[IRDMA_HMC_IW_MR].cnt);
+	set_64bit_val(buf, 56, (u64)obj_info[IRDMA_HMC_IW_XF].cnt);
+	set_64bit_val(buf, 64, (u64)obj_info[IRDMA_HMC_IW_XFFL].cnt);
+	set_64bit_val(buf, 72, (u64)obj_info[IRDMA_HMC_IW_Q1].cnt);
+	set_64bit_val(buf, 80, (u64)obj_info[IRDMA_HMC_IW_Q1FL].cnt);
+	set_64bit_val(buf, 88,
+		      (u64)obj_info[IRDMA_HMC_IW_TIMER].cnt);
+	set_64bit_val(buf, 96,
+		      (u64)obj_info[IRDMA_HMC_IW_FSIMC].cnt);
+	set_64bit_val(buf, 104,
+		      (u64)obj_info[IRDMA_HMC_IW_FSIAV].cnt);
+	set_64bit_val(buf, 112,
+		      (u64)obj_info[IRDMA_HMC_IW_PBLE].cnt);
+	set_64bit_val(buf, 120, (u64)0); /* RSVD */
+	set_64bit_val(buf, 128, (u64)obj_info[IRDMA_HMC_IW_RRF].cnt);
+	set_64bit_val(buf, 136,
+		      (u64)obj_info[IRDMA_HMC_IW_RRFFL].cnt);
+	set_64bit_val(buf, 144, (u64)obj_info[IRDMA_HMC_IW_HDR].cnt);
+	set_64bit_val(buf, 152, (u64)obj_info[IRDMA_HMC_IW_MD].cnt);
+	set_64bit_val(buf, 160,
+		      (u64)obj_info[IRDMA_HMC_IW_OOISC].cnt);
+	set_64bit_val(buf, 168,
+		      (u64)obj_info[IRDMA_HMC_IW_OOISCFFL].cnt);
+
+	commit_fpm_mem.pa = dev->fpm_commit_buf_pa;
+	commit_fpm_mem.va = dev->fpm_commit_buf;
+
+	wait_type = (u8)IRDMA_CQP_WAIT_POLL_REGS;
+	print_hex_dump_debug("HMC: COMMIT FPM BUFFER", DUMP_PREFIX_OFFSET, 16,
+			     8, commit_fpm_mem.va, IRDMA_COMMIT_FPM_BUF_SIZE,
+			     false);
+	ret_code = irdma_sc_commit_fpm_val(dev->cqp, 0, hmc_info->hmc_fn_id,
+					   &commit_fpm_mem, true, wait_type);
+	if (!ret_code)
+		ret_code = irdma_sc_parse_fpm_commit_buf(dev, dev->fpm_commit_buf,
+							 hmc_info->hmc_obj,
+							 &hmc_info->sd_table.sd_cnt);
+	print_hex_dump_debug("HMC: COMMIT FPM BUFFER", DUMP_PREFIX_OFFSET, 16,
+			     8, commit_fpm_mem.va, IRDMA_COMMIT_FPM_BUF_SIZE,
+			     false);
+
+	return ret_code;
+}
+
+/**
+ * cqp_sds_wqe_fill - fill cqp wqe doe sd
+ * @cqp: struct for cqp hw
+ * @info: sd info for wqe
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+cqp_sds_wqe_fill(struct irdma_sc_cqp *cqp, struct irdma_update_sds_info *info,
+		 u64 scratch)
+{
+	u64 data;
+	u64 hdr;
+	__le64 *wqe;
+	int mem_entries, wqe_entries;
+	struct irdma_dma_mem *sdbuf = &cqp->sdbuf;
+	u64 offset = 0;
+	u32 wqe_idx;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	wqe_entries = (info->cnt > 3) ? 3 : info->cnt;
+	mem_entries = info->cnt - wqe_entries;
+
+	if (mem_entries) {
+		offset = wqe_idx * IRDMA_UPDATE_SD_BUFF_SIZE;
+		memcpy(((char *)sdbuf->va + offset), &info->entry[3], mem_entries << 4);
+
+		data = (u64)sdbuf->pa + offset;
+	} else {
+		data = 0;
+	}
+	data |= FIELD_PREP(IRDMA_CQPSQ_UPESD_HMCFNID, info->hmc_fn_id);
+	set_64bit_val(wqe, 16, data);
+
+	switch (wqe_entries) {
+	case 3:
+		set_64bit_val(wqe, 48,
+			      (FIELD_PREP(IRDMA_CQPSQ_UPESD_SDCMD, info->entry[2].cmd) |
+			       FIELD_PREP(IRDMA_CQPSQ_UPESD_ENTRY_VALID, 1)));
+
+		set_64bit_val(wqe, 56, info->entry[2].data);
+		fallthrough;
+	case 2:
+		set_64bit_val(wqe, 32,
+			      (FIELD_PREP(IRDMA_CQPSQ_UPESD_SDCMD, info->entry[1].cmd) |
+			       FIELD_PREP(IRDMA_CQPSQ_UPESD_ENTRY_VALID, 1)));
+
+		set_64bit_val(wqe, 40, info->entry[1].data);
+		fallthrough;
+	case 1:
+		set_64bit_val(wqe, 0,
+			      FIELD_PREP(IRDMA_CQPSQ_UPESD_SDCMD, info->entry[0].cmd));
+
+		set_64bit_val(wqe, 8, info->entry[0].data);
+		break;
+	default:
+		break;
+	}
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE, IRDMA_CQP_OP_UPDATE_PE_SDS) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity) |
+	      FIELD_PREP(IRDMA_CQPSQ_UPESD_ENTRY_COUNT, mem_entries);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	if (mem_entries)
+		print_hex_dump_debug("WQE: UPDATE_PE_SDS WQE Buffer",
+				     DUMP_PREFIX_OFFSET, 16, 8,
+				     (char *)sdbuf->va + offset,
+				     mem_entries << 4, false);
+
+	print_hex_dump_debug("WQE: UPDATE_PE_SDS WQE", DUMP_PREFIX_OFFSET, 16,
+			     8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+
+	return 0;
+}
+
+/**
+ * irdma_update_pe_sds - cqp wqe for sd
+ * @dev: ptr to irdma_dev struct
+ * @info: sd info for sd's
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_update_pe_sds(struct irdma_sc_dev *dev,
+		    struct irdma_update_sds_info *info, u64 scratch)
+{
+	struct irdma_sc_cqp *cqp = dev->cqp;
+	enum irdma_status_code ret_code;
+
+	ret_code = cqp_sds_wqe_fill(cqp, info, scratch);
+	if (!ret_code)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return ret_code;
+}
+
+/**
+ * irdma_update_sds_noccq - update sd before ccq created
+ * @dev: sc device struct
+ * @info: sd info for sd's
+ */
+enum irdma_status_code
+irdma_update_sds_noccq(struct irdma_sc_dev *dev,
+		       struct irdma_update_sds_info *info)
+{
+	u32 error, val, tail;
+	struct irdma_sc_cqp *cqp = dev->cqp;
+	enum irdma_status_code ret_code;
+
+	ret_code = cqp_sds_wqe_fill(cqp, info, 0);
+	if (ret_code)
+		return ret_code;
+
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	irdma_sc_cqp_post_sq(cqp);
+	return irdma_cqp_poll_registers(cqp, tail,
+					cqp->dev->hw_attrs.max_done_count);
+}
+
+/**
+ * irdma_sc_static_hmc_pages_allocated - cqp wqe to allocate hmc pages
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @hmc_fn_id: hmc function id
+ * @post_sq: flag for cqp db to ring
+ * @poll_registers: flag to poll register for cqp completion
+ */
+enum irdma_status_code
+irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
+				    u8 hmc_fn_id, bool post_sq,
+				    bool poll_registers)
+{
+	u64 hdr;
+	__le64 *wqe;
+	u32 tail, val, error;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16,
+		      FIELD_PREP(IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID, hmc_fn_id));
+
+	hdr = FIELD_PREP(IRDMA_CQPSQ_OPCODE,
+			 IRDMA_CQP_OP_SHMC_PAGES_ALLOCATED) |
+	      FIELD_PREP(IRDMA_CQPSQ_WQEVALID, cqp->polarity);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	print_hex_dump_debug("WQE: SHMC_PAGES_ALLOCATED WQE",
+			     DUMP_PREFIX_OFFSET, 16, 8, wqe,
+			     IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		if (poll_registers)
+			/* check for cqp sq tail update */
+			return irdma_cqp_poll_registers(cqp, tail,
+							cqp->dev->hw_attrs.max_done_count);
+		else
+			return irdma_sc_poll_for_cqp_op_done(cqp,
+							     IRDMA_CQP_OP_SHMC_PAGES_ALLOCATED,
+							     NULL);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_cqp_ring_full - check if cqp ring is full
+ * @cqp: struct for cqp hw
+ */
+static bool irdma_cqp_ring_full(struct irdma_sc_cqp *cqp)
+{
+	return IRDMA_RING_FULL_ERR(cqp->sq_ring);
+}
+
+/**
+ * irdma_est_sd - returns approximate number of SDs for HMC
+ * @dev: sc device struct
+ * @hmc_info: hmc structure, size and count for HMC objects
+ */
+static u32 irdma_est_sd(struct irdma_sc_dev *dev,
+			struct irdma_hmc_info *hmc_info)
+{
+	int i;
+	u64 size = 0;
+	u64 sd;
+
+	for (i = IRDMA_HMC_IW_QP; i < IRDMA_HMC_IW_MAX; i++)
+		if (i != IRDMA_HMC_IW_PBLE)
+			size += round_up(hmc_info->hmc_obj[i].cnt *
+					 hmc_info->hmc_obj[i].size, 512);
+	size += round_up(hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt *
+			 hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].size, 512);
+	if (size & 0x1FFFFF)
+		sd = (size >> 21) + 1; /* add 1 for remainder */
+	else
+		sd = size >> 21;
+	if (sd > 0xFFFFFFFF) {
+		ibdev_dbg(to_ibdev(dev), "HMC: sd overflow[%lld]\n", sd);
+		sd = 0xFFFFFFFF - 1;
+	}
+
+	return (u32)sd;
+}
+
+/**
+ * irdma_sc_query_rdma_features_done - poll cqp for query features done
+ * @cqp: struct for cqp hw
+ */
+static enum irdma_status_code
+irdma_sc_query_rdma_features_done(struct irdma_sc_cqp *cqp)
+{
+	return irdma_sc_poll_for_cqp_op_done(cqp,
+					     IRDMA_CQP_OP_QUERY_RDMA_FEATURES,
+					     NULL);
+}
+
+/**
+ * irdma_sc_query_rdma_features - query RDMA features and FW ver
+ * @cqp: struct for cqp hw
+ * @buf: buffer to hold query info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code
+irdma_sc_query_rdma_features(struct irdma_sc_cqp *cqp,
+			     struct irdma_dma_mem *buf, u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	temp = buf->pa;
+	set_64bit_val(wqe, 32, temp);
+
+	temp = FIELD_PREP(IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID,
+			  cqp->polarity) |
+	       FIELD_PREP(IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN, buf->size) |
+	       FIELD_PREP(IRDMA_CQPSQ_UP_OP, IRDMA_CQP_OP_QUERY_RDMA_FEATURES);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	print_hex_dump_debug("WQE: QUERY RDMA FEATURES", DUMP_PREFIX_OFFSET,
+			     16, 8, wqe, IRDMA_CQP_WQE_SIZE * 8, false);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_get_rdma_features - get RDMA features
+ * @dev: sc device struct
+ */
+enum irdma_status_code irdma_get_rdma_features(struct irdma_sc_dev *dev)
+{
+	enum irdma_status_code ret_code;
+	struct irdma_dma_mem feat_buf;
+	u64 temp;
+	u16 byte_idx, feat_type, feat_cnt, feat_idx;
+
+	feat_buf.size = ALIGN(IRDMA_FEATURE_BUF_SIZE,
+			      IRDMA_FEATURE_BUF_ALIGNMENT);
+	feat_buf.va = dma_alloc_coherent(dev->hw->device, feat_buf.size,
+					 &feat_buf.pa, GFP_KERNEL);
+	if (!feat_buf.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	ret_code = irdma_sc_query_rdma_features(dev->cqp, &feat_buf, 0);
+	if (!ret_code)
+		ret_code = irdma_sc_query_rdma_features_done(dev->cqp);
+	if (ret_code)
+		goto exit;
+
+	get_64bit_val(feat_buf.va, 0, &temp);
+	feat_cnt = (u16)FIELD_GET(IRDMA_FEATURE_CNT, temp);
+	if (feat_cnt < 2) {
+		ret_code = IRDMA_ERR_INVALID_FEAT_CNT;
+		goto exit;
+	} else if (feat_cnt > IRDMA_MAX_FEATURES) {
+		ibdev_dbg(to_ibdev(dev),
+			  "DEV: feature buf size insufficient, retrying with larger buffer\n");
+		dma_free_coherent(dev->hw->device, feat_buf.size, feat_buf.va,
+				  feat_buf.pa);
+		feat_buf.va = NULL;
+		feat_buf.size = ALIGN(8 * feat_cnt,
+				      IRDMA_FEATURE_BUF_ALIGNMENT);
+		feat_buf.va = dma_alloc_coherent(dev->hw->device,
+						 feat_buf.size, &feat_buf.pa,
+						 GFP_KERNEL);
+		if (!feat_buf.va)
+			return IRDMA_ERR_NO_MEMORY;
+
+		ret_code = irdma_sc_query_rdma_features(dev->cqp, &feat_buf, 0);
+		if (!ret_code)
+			ret_code = irdma_sc_query_rdma_features_done(dev->cqp);
+		if (ret_code)
+			goto exit;
+
+		get_64bit_val(feat_buf.va, 0, &temp);
+		feat_cnt = (u16)FIELD_GET(IRDMA_FEATURE_CNT, temp);
+		if (feat_cnt < 2) {
+			ret_code = IRDMA_ERR_INVALID_FEAT_CNT;
+			goto exit;
+		}
+	}
+
+	print_hex_dump_debug("WQE: QUERY RDMA FEATURES", DUMP_PREFIX_OFFSET,
+			     16, 8, feat_buf.va, feat_cnt * 8, false);
+
+	for (byte_idx = 0, feat_idx = 0; feat_idx < min(feat_cnt, (u16)IRDMA_MAX_FEATURES);
+	     feat_idx++, byte_idx += 8) {
+		get_64bit_val(feat_buf.va, byte_idx, &temp);
+		feat_type = FIELD_GET(IRDMA_FEATURE_TYPE, temp);
+		if (feat_type >= IRDMA_MAX_FEATURES) {
+			ibdev_dbg(to_ibdev(dev),
+				  "DEV: found unrecognized feature type %d\n",
+				  feat_type);
+			continue;
+		}
+		dev->feature_info[feat_type] = temp;
+	}
+exit:
+	dma_free_coherent(dev->hw->device, feat_buf.size, feat_buf.va,
+			  feat_buf.pa);
+	feat_buf.va = NULL;
+	return ret_code;
+}
+
+static u32 irdma_q1_cnt(struct irdma_sc_dev *dev,
+			struct irdma_hmc_info *hmc_info, u32 qpwanted)
+{
+	u32 q1_cnt;
+
+	if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1) {
+		q1_cnt = roundup_pow_of_two(dev->hw_attrs.max_hw_ird * 2 * qpwanted);
+	} else {
+		if (dev->cqp->protocol_used != IRDMA_IWARP_PROTOCOL_ONLY)
+			q1_cnt = roundup_pow_of_two(dev->hw_attrs.max_hw_ird * 2 * qpwanted + 512);
+		else
+			q1_cnt = dev->hw_attrs.max_hw_ird * 2 * qpwanted;
+	}
+
+	return q1_cnt;
+}
+
+static void cfg_fpm_value_gen_1(struct irdma_sc_dev *dev,
+				struct irdma_hmc_info *hmc_info, u32 qpwanted)
+{
+	hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt = roundup_pow_of_two(qpwanted * dev->hw_attrs.max_hw_wqes);
+}
+
+static void cfg_fpm_value_gen_2(struct irdma_sc_dev *dev,
+				struct irdma_hmc_info *hmc_info, u32 qpwanted)
+{
+	struct irdma_hmc_fpm_misc *hmc_fpm_misc = &dev->hmc_fpm_misc;
+
+	hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt =
+		4 * hmc_fpm_misc->xf_block_size * qpwanted;
+
+	hmc_info->hmc_obj[IRDMA_HMC_IW_HDR].cnt = qpwanted;
+
+	if (hmc_info->hmc_obj[IRDMA_HMC_IW_RRF].max_cnt)
+		hmc_info->hmc_obj[IRDMA_HMC_IW_RRF].cnt = 32 * qpwanted;
+	if (hmc_info->hmc_obj[IRDMA_HMC_IW_RRFFL].max_cnt)
+		hmc_info->hmc_obj[IRDMA_HMC_IW_RRFFL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_RRF].cnt /
+			hmc_fpm_misc->rrf_block_size;
+	if (hmc_info->hmc_obj[IRDMA_HMC_IW_OOISC].max_cnt)
+		hmc_info->hmc_obj[IRDMA_HMC_IW_OOISC].cnt = 32 * qpwanted;
+	if (hmc_info->hmc_obj[IRDMA_HMC_IW_OOISCFFL].max_cnt)
+		hmc_info->hmc_obj[IRDMA_HMC_IW_OOISCFFL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_OOISC].cnt /
+			hmc_fpm_misc->ooiscf_block_size;
+}
+
+/**
+ * irdma_cfg_fpm_val - configure HMC objects
+ * @dev: sc device struct
+ * @qp_count: desired qp count
+ */
+enum irdma_status_code irdma_cfg_fpm_val(struct irdma_sc_dev *dev, u32 qp_count)
+{
+	struct irdma_virt_mem virt_mem;
+	u32 i, mem_size;
+	u32 qpwanted, mrwanted, pblewanted;
+	u32 powerof2, hte;
+	u32 sd_needed;
+	u32 sd_diff;
+	u32 loop_count = 0;
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_hmc_fpm_misc *hmc_fpm_misc;
+	enum irdma_status_code ret_code = 0;
+
+	hmc_info = dev->hmc_info;
+	hmc_fpm_misc = &dev->hmc_fpm_misc;
+
+	ret_code = irdma_sc_init_iw_hmc(dev, dev->hmc_fn_id);
+	if (ret_code) {
+		ibdev_dbg(to_ibdev(dev),
+			  "HMC: irdma_sc_init_iw_hmc returned error_code = %d\n",
+			  ret_code);
+		return ret_code;
+	}
+
+	for (i = IRDMA_HMC_IW_QP; i < IRDMA_HMC_IW_MAX; i++)
+		hmc_info->hmc_obj[i].cnt = hmc_info->hmc_obj[i].max_cnt;
+	sd_needed = irdma_est_sd(dev, hmc_info);
+	ibdev_dbg(to_ibdev(dev),
+		  "HMC: FW max resources sd_needed[%08d] first_sd_index[%04d]\n",
+		  sd_needed, hmc_info->first_sd_index);
+	ibdev_dbg(to_ibdev(dev), "HMC: sd count %d where max sd is %d\n",
+		  hmc_info->sd_table.sd_cnt, hmc_fpm_misc->max_sds);
+
+	qpwanted = min(qp_count, hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt);
+
+	powerof2 = 1;
+	while (powerof2 <= qpwanted)
+		powerof2 *= 2;
+	powerof2 /= 2;
+	qpwanted = powerof2;
+
+	mrwanted = hmc_info->hmc_obj[IRDMA_HMC_IW_MR].max_cnt;
+	pblewanted = hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].max_cnt;
+
+	ibdev_dbg(to_ibdev(dev),
+		  "HMC: req_qp=%d max_sd=%d, max_qp = %d, max_cq=%d, max_mr=%d, max_pble=%d, mc=%d, av=%d\n",
+		  qp_count, hmc_fpm_misc->max_sds,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].max_cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_MR].max_cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].max_cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].max_cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].max_cnt);
+	hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].max_cnt;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].max_cnt;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_ARP].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_ARP].max_cnt;
+
+	hmc_info->hmc_obj[IRDMA_HMC_IW_APBVT_ENTRY].cnt = 1;
+
+	while (irdma_q1_cnt(dev, hmc_info, qpwanted) > hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].max_cnt)
+		qpwanted /= 2;
+
+	do {
+		++loop_count;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_QP].cnt = qpwanted;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt =
+			min(2 * qpwanted, hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt);
+		hmc_info->hmc_obj[IRDMA_HMC_IW_RESERVED].cnt = 0; /* Reserved */
+		hmc_info->hmc_obj[IRDMA_HMC_IW_MR].cnt = mrwanted;
+
+		hte = round_up(qpwanted + hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt, 512);
+		powerof2 = 1;
+		while (powerof2 < hte)
+			powerof2 *= 2;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_HTE].cnt =
+			powerof2 * hmc_fpm_misc->ht_multiplier;
+		if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+			cfg_fpm_value_gen_1(dev, hmc_info, qpwanted);
+		else
+			cfg_fpm_value_gen_2(dev, hmc_info, qpwanted);
+
+		hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].cnt = irdma_q1_cnt(dev, hmc_info, qpwanted);
+		hmc_info->hmc_obj[IRDMA_HMC_IW_XFFL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt / hmc_fpm_misc->xf_block_size;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_Q1FL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].cnt / hmc_fpm_misc->q1_block_size;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_TIMER].cnt =
+			(round_up(qpwanted, 512) / 512 + 1) * hmc_fpm_misc->timer_bucket;
+
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt = pblewanted;
+		sd_needed = irdma_est_sd(dev, hmc_info);
+		ibdev_dbg(to_ibdev(dev),
+			  "HMC: sd_needed = %d, hmc_fpm_misc->max_sds=%d, mrwanted=%d, pblewanted=%d qpwanted=%d\n",
+			  sd_needed, hmc_fpm_misc->max_sds, mrwanted,
+			  pblewanted, qpwanted);
+
+		/* Do not reduce resources further. All objects fit with max SDs */
+		if (sd_needed <= hmc_fpm_misc->max_sds)
+			break;
+
+		sd_diff = sd_needed - hmc_fpm_misc->max_sds;
+		if (sd_diff > 128) {
+			if (qpwanted > 128 && sd_diff > 144)
+				qpwanted /= 2;
+			mrwanted /= 2;
+			pblewanted /= 2;
+			continue;
+		}
+		if (dev->cqp->hmc_profile != IRDMA_HMC_PROFILE_FAVOR_VF &&
+		    pblewanted > (512 * FPM_MULTIPLIER * sd_diff)) {
+			pblewanted -= 256 * FPM_MULTIPLIER * sd_diff;
+			continue;
+		} else if (pblewanted > (100 * FPM_MULTIPLIER)) {
+			pblewanted -= 10 * FPM_MULTIPLIER;
+		} else if (pblewanted > FPM_MULTIPLIER) {
+			pblewanted -= FPM_MULTIPLIER;
+		} else if (qpwanted <= 128) {
+			if (hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt > 256)
+				hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt /= 2;
+			if (hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt > 256)
+				hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt /= 2;
+		}
+		if (mrwanted > FPM_MULTIPLIER)
+			mrwanted -= FPM_MULTIPLIER;
+		if (!(loop_count % 10) && qpwanted > 128) {
+			qpwanted /= 2;
+			if (hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt > 256)
+				hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt /= 2;
+		}
+	} while (loop_count < 2000);
+
+	if (sd_needed > hmc_fpm_misc->max_sds) {
+		ibdev_dbg(to_ibdev(dev),
+			  "HMC: cfg_fpm failed loop_cnt=%d, sd_needed=%d, max sd count %d\n",
+			  loop_count, sd_needed, hmc_info->sd_table.sd_cnt);
+		return IRDMA_ERR_CFG;
+	}
+
+	if (loop_count > 1 && sd_needed < hmc_fpm_misc->max_sds) {
+		pblewanted += (hmc_fpm_misc->max_sds - sd_needed) * 256 *
+			      FPM_MULTIPLIER;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt = pblewanted;
+		sd_needed = irdma_est_sd(dev, hmc_info);
+	}
+
+	ibdev_dbg(to_ibdev(dev),
+		  "HMC: loop_cnt=%d, sd_needed=%d, qpcnt = %d, cqcnt=%d, mrcnt=%d, pblecnt=%d, mc=%d, ah=%d, max sd count %d, first sd index %d\n",
+		  loop_count, sd_needed,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_QP].cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_MR].cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt,
+		  hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt,
+		  hmc_info->sd_table.sd_cnt, hmc_info->first_sd_index);
+
+	ret_code = irdma_sc_cfg_iw_fpm(dev, dev->hmc_fn_id);
+	if (ret_code) {
+		ibdev_dbg(to_ibdev(dev),
+			  "HMC: cfg_iw_fpm returned error_code[x%08X]\n",
+			  readl(dev->hw_regs[IRDMA_CQPERRCODES]));
+		return ret_code;
+	}
+
+	mem_size = sizeof(struct irdma_hmc_sd_entry) *
+		   (hmc_info->sd_table.sd_cnt + hmc_info->first_sd_index + 1);
+	virt_mem.size = mem_size;
+	virt_mem.va = kzalloc(virt_mem.size, GFP_KERNEL);
+	if (!virt_mem.va) {
+		ibdev_dbg(to_ibdev(dev),
+			  "HMC: failed to allocate memory for sd_entry buffer\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+	hmc_info->sd_table.sd_entry = virt_mem.va;
+
+	return ret_code;
+}
+
+/**
+ * irdma_exec_cqp_cmd - execute cqp cmd when wqe are available
+ * @dev: rdma device
+ * @pcmdinfo: cqp command info
+ */
+static enum irdma_status_code irdma_exec_cqp_cmd(struct irdma_sc_dev *dev,
+						 struct cqp_cmds_info *pcmdinfo)
+{
+	enum irdma_status_code status;
+	struct irdma_dma_mem val_mem;
+	bool alloc = false;
+
+	dev->cqp_cmd_stats[pcmdinfo->cqp_cmd]++;
+	switch (pcmdinfo->cqp_cmd) {
+	case IRDMA_OP_CEQ_DESTROY:
+		status = irdma_sc_ceq_destroy(pcmdinfo->in.u.ceq_destroy.ceq,
+					      pcmdinfo->in.u.ceq_destroy.scratch,
+					      pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_AEQ_DESTROY:
+		status = irdma_sc_aeq_destroy(pcmdinfo->in.u.aeq_destroy.aeq,
+					      pcmdinfo->in.u.aeq_destroy.scratch,
+					      pcmdinfo->post_sq);
+
+		break;
+	case IRDMA_OP_CEQ_CREATE:
+		status = irdma_sc_ceq_create(pcmdinfo->in.u.ceq_create.ceq,
+					     pcmdinfo->in.u.ceq_create.scratch,
+					     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_AEQ_CREATE:
+		status = irdma_sc_aeq_create(pcmdinfo->in.u.aeq_create.aeq,
+					     pcmdinfo->in.u.aeq_create.scratch,
+					     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_QP_UPLOAD_CONTEXT:
+		status = irdma_sc_qp_upload_context(pcmdinfo->in.u.qp_upload_context.dev,
+						    &pcmdinfo->in.u.qp_upload_context.info,
+						    pcmdinfo->in.u.qp_upload_context.scratch,
+						    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_CQ_CREATE:
+		status = irdma_sc_cq_create(pcmdinfo->in.u.cq_create.cq,
+					    pcmdinfo->in.u.cq_create.scratch,
+					    pcmdinfo->in.u.cq_create.check_overflow,
+					    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_CQ_MODIFY:
+		status = irdma_sc_cq_modify(pcmdinfo->in.u.cq_modify.cq,
+					    &pcmdinfo->in.u.cq_modify.info,
+					    pcmdinfo->in.u.cq_modify.scratch,
+					    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_CQ_DESTROY:
+		status = irdma_sc_cq_destroy(pcmdinfo->in.u.cq_destroy.cq,
+					     pcmdinfo->in.u.cq_destroy.scratch,
+					     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_QP_FLUSH_WQES:
+		status = irdma_sc_qp_flush_wqes(pcmdinfo->in.u.qp_flush_wqes.qp,
+						&pcmdinfo->in.u.qp_flush_wqes.info,
+						pcmdinfo->in.u.qp_flush_wqes.scratch,
+						pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_GEN_AE:
+		status = irdma_sc_gen_ae(pcmdinfo->in.u.gen_ae.qp,
+					 &pcmdinfo->in.u.gen_ae.info,
+					 pcmdinfo->in.u.gen_ae.scratch,
+					 pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_MANAGE_PUSH_PAGE:
+		status = irdma_sc_manage_push_page(pcmdinfo->in.u.manage_push_page.cqp,
+						   &pcmdinfo->in.u.manage_push_page.info,
+						   pcmdinfo->in.u.manage_push_page.scratch,
+						   pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_UPDATE_PE_SDS:
+		status = irdma_update_pe_sds(pcmdinfo->in.u.update_pe_sds.dev,
+					     &pcmdinfo->in.u.update_pe_sds.info,
+					     pcmdinfo->in.u.update_pe_sds.scratch);
+		break;
+	case IRDMA_OP_MANAGE_HMC_PM_FUNC_TABLE:
+		/* switch to calling through the call table */
+		status =
+			irdma_sc_manage_hmc_pm_func_table(pcmdinfo->in.u.manage_hmc_pm.dev->cqp,
+							  &pcmdinfo->in.u.manage_hmc_pm.info,
+							  pcmdinfo->in.u.manage_hmc_pm.scratch,
+							  true);
+		break;
+	case IRDMA_OP_SUSPEND:
+		status = irdma_sc_suspend_qp(pcmdinfo->in.u.suspend_resume.cqp,
+					     pcmdinfo->in.u.suspend_resume.qp,
+					     pcmdinfo->in.u.suspend_resume.scratch);
+		break;
+	case IRDMA_OP_RESUME:
+		status = irdma_sc_resume_qp(pcmdinfo->in.u.suspend_resume.cqp,
+					    pcmdinfo->in.u.suspend_resume.qp,
+					    pcmdinfo->in.u.suspend_resume.scratch);
+		break;
+	case IRDMA_OP_QUERY_FPM_VAL:
+		val_mem.pa = pcmdinfo->in.u.query_fpm_val.fpm_val_pa;
+		val_mem.va = pcmdinfo->in.u.query_fpm_val.fpm_val_va;
+		status = irdma_sc_query_fpm_val(pcmdinfo->in.u.query_fpm_val.cqp,
+						pcmdinfo->in.u.query_fpm_val.scratch,
+						pcmdinfo->in.u.query_fpm_val.hmc_fn_id,
+						&val_mem, true, IRDMA_CQP_WAIT_EVENT);
+		break;
+	case IRDMA_OP_COMMIT_FPM_VAL:
+		val_mem.pa = pcmdinfo->in.u.commit_fpm_val.fpm_val_pa;
+		val_mem.va = pcmdinfo->in.u.commit_fpm_val.fpm_val_va;
+		status = irdma_sc_commit_fpm_val(pcmdinfo->in.u.commit_fpm_val.cqp,
+						 pcmdinfo->in.u.commit_fpm_val.scratch,
+						 pcmdinfo->in.u.commit_fpm_val.hmc_fn_id,
+						 &val_mem,
+						 true,
+						 IRDMA_CQP_WAIT_EVENT);
+		break;
+	case IRDMA_OP_STATS_ALLOCATE:
+		alloc = true;
+		fallthrough;
+	case IRDMA_OP_STATS_FREE:
+		status = irdma_sc_manage_stats_inst(pcmdinfo->in.u.stats_manage.cqp,
+						    &pcmdinfo->in.u.stats_manage.info,
+						    alloc,
+						    pcmdinfo->in.u.stats_manage.scratch);
+		break;
+	case IRDMA_OP_STATS_GATHER:
+		status = irdma_sc_gather_stats(pcmdinfo->in.u.stats_gather.cqp,
+					       &pcmdinfo->in.u.stats_gather.info,
+					       pcmdinfo->in.u.stats_gather.scratch);
+		break;
+	case IRDMA_OP_WS_MODIFY_NODE:
+		status = irdma_sc_manage_ws_node(pcmdinfo->in.u.ws_node.cqp,
+						 &pcmdinfo->in.u.ws_node.info,
+						 IRDMA_MODIFY_NODE,
+						 pcmdinfo->in.u.ws_node.scratch);
+		break;
+	case IRDMA_OP_WS_DELETE_NODE:
+		status = irdma_sc_manage_ws_node(pcmdinfo->in.u.ws_node.cqp,
+						 &pcmdinfo->in.u.ws_node.info,
+						 IRDMA_DEL_NODE,
+						 pcmdinfo->in.u.ws_node.scratch);
+		break;
+	case IRDMA_OP_WS_ADD_NODE:
+		status = irdma_sc_manage_ws_node(pcmdinfo->in.u.ws_node.cqp,
+						 &pcmdinfo->in.u.ws_node.info,
+						 IRDMA_ADD_NODE,
+						 pcmdinfo->in.u.ws_node.scratch);
+		break;
+	case IRDMA_OP_SET_UP_MAP:
+		status = irdma_sc_set_up_map(pcmdinfo->in.u.up_map.cqp,
+					     &pcmdinfo->in.u.up_map.info,
+					     pcmdinfo->in.u.up_map.scratch);
+		break;
+	case IRDMA_OP_QUERY_RDMA_FEATURES:
+		status = irdma_sc_query_rdma_features(pcmdinfo->in.u.query_rdma.cqp,
+						      &pcmdinfo->in.u.query_rdma.query_buff_mem,
+						      pcmdinfo->in.u.query_rdma.scratch);
+		break;
+	case IRDMA_OP_DELETE_ARP_CACHE_ENTRY:
+		status = irdma_sc_del_arp_cache_entry(pcmdinfo->in.u.del_arp_cache_entry.cqp,
+						      pcmdinfo->in.u.del_arp_cache_entry.scratch,
+						      pcmdinfo->in.u.del_arp_cache_entry.arp_index,
+						      pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_MANAGE_APBVT_ENTRY:
+		status = irdma_sc_manage_apbvt_entry(pcmdinfo->in.u.manage_apbvt_entry.cqp,
+						     &pcmdinfo->in.u.manage_apbvt_entry.info,
+						     pcmdinfo->in.u.manage_apbvt_entry.scratch,
+						     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_MANAGE_QHASH_TABLE_ENTRY:
+		status = irdma_sc_manage_qhash_table_entry(pcmdinfo->in.u.manage_qhash_table_entry.cqp,
+							   &pcmdinfo->in.u.manage_qhash_table_entry.info,
+							   pcmdinfo->in.u.manage_qhash_table_entry.scratch,
+							   pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_QP_MODIFY:
+		status = irdma_sc_qp_modify(pcmdinfo->in.u.qp_modify.qp,
+					    &pcmdinfo->in.u.qp_modify.info,
+					    pcmdinfo->in.u.qp_modify.scratch,
+					    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_QP_CREATE:
+		status = irdma_sc_qp_create(pcmdinfo->in.u.qp_create.qp,
+					    &pcmdinfo->in.u.qp_create.info,
+					    pcmdinfo->in.u.qp_create.scratch,
+					    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_QP_DESTROY:
+		status = irdma_sc_qp_destroy(pcmdinfo->in.u.qp_destroy.qp,
+					     pcmdinfo->in.u.qp_destroy.scratch,
+					     pcmdinfo->in.u.qp_destroy.remove_hash_idx,
+					     pcmdinfo->in.u.qp_destroy.ignore_mw_bnd,
+					     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_ALLOC_STAG:
+		status = irdma_sc_alloc_stag(pcmdinfo->in.u.alloc_stag.dev,
+					     &pcmdinfo->in.u.alloc_stag.info,
+					     pcmdinfo->in.u.alloc_stag.scratch,
+					     pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_MR_REG_NON_SHARED:
+		status = irdma_sc_mr_reg_non_shared(pcmdinfo->in.u.mr_reg_non_shared.dev,
+						    &pcmdinfo->in.u.mr_reg_non_shared.info,
+						    pcmdinfo->in.u.mr_reg_non_shared.scratch,
+						    pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_DEALLOC_STAG:
+		status = irdma_sc_dealloc_stag(pcmdinfo->in.u.dealloc_stag.dev,
+					       &pcmdinfo->in.u.dealloc_stag.info,
+					       pcmdinfo->in.u.dealloc_stag.scratch,
+					       pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_MW_ALLOC:
+		status = irdma_sc_mw_alloc(pcmdinfo->in.u.mw_alloc.dev,
+					   &pcmdinfo->in.u.mw_alloc.info,
+					   pcmdinfo->in.u.mw_alloc.scratch,
+					   pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_ADD_ARP_CACHE_ENTRY:
+		status = irdma_sc_add_arp_cache_entry(pcmdinfo->in.u.add_arp_cache_entry.cqp,
+						      &pcmdinfo->in.u.add_arp_cache_entry.info,
+						      pcmdinfo->in.u.add_arp_cache_entry.scratch,
+						      pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_ALLOC_LOCAL_MAC_ENTRY:
+		status = irdma_sc_alloc_local_mac_entry(pcmdinfo->in.u.alloc_local_mac_entry.cqp,
+							pcmdinfo->in.u.alloc_local_mac_entry.scratch,
+							pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_ADD_LOCAL_MAC_ENTRY:
+		status = irdma_sc_add_local_mac_entry(pcmdinfo->in.u.add_local_mac_entry.cqp,
+						      &pcmdinfo->in.u.add_local_mac_entry.info,
+						      pcmdinfo->in.u.add_local_mac_entry.scratch,
+						      pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_DELETE_LOCAL_MAC_ENTRY:
+		status = irdma_sc_del_local_mac_entry(pcmdinfo->in.u.del_local_mac_entry.cqp,
+						      pcmdinfo->in.u.del_local_mac_entry.scratch,
+						      pcmdinfo->in.u.del_local_mac_entry.entry_idx,
+						      pcmdinfo->in.u.del_local_mac_entry.ignore_ref_count,
+						      pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_AH_CREATE:
+		status = irdma_sc_create_ah(pcmdinfo->in.u.ah_create.cqp,
+					    &pcmdinfo->in.u.ah_create.info,
+					    pcmdinfo->in.u.ah_create.scratch);
+		break;
+	case IRDMA_OP_AH_DESTROY:
+		status = irdma_sc_destroy_ah(pcmdinfo->in.u.ah_destroy.cqp,
+					     &pcmdinfo->in.u.ah_destroy.info,
+					     pcmdinfo->in.u.ah_destroy.scratch);
+		break;
+	case IRDMA_OP_MC_CREATE:
+		status = irdma_sc_create_mcast_grp(pcmdinfo->in.u.mc_create.cqp,
+						   &pcmdinfo->in.u.mc_create.info,
+						   pcmdinfo->in.u.mc_create.scratch);
+		break;
+	case IRDMA_OP_MC_DESTROY:
+		status = irdma_sc_destroy_mcast_grp(pcmdinfo->in.u.mc_destroy.cqp,
+						    &pcmdinfo->in.u.mc_destroy.info,
+						    pcmdinfo->in.u.mc_destroy.scratch);
+		break;
+	case IRDMA_OP_MC_MODIFY:
+		status = irdma_sc_modify_mcast_grp(pcmdinfo->in.u.mc_modify.cqp,
+						   &pcmdinfo->in.u.mc_modify.info,
+						   pcmdinfo->in.u.mc_modify.scratch);
+		break;
+	default:
+		status = IRDMA_NOT_SUPPORTED;
+		break;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_process_cqp_cmd - process all cqp commands
+ * @dev: sc device struct
+ * @pcmdinfo: cqp command info
+ */
+enum irdma_status_code irdma_process_cqp_cmd(struct irdma_sc_dev *dev,
+					     struct cqp_cmds_info *pcmdinfo)
+{
+	enum irdma_status_code status = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->cqp_lock, flags);
+	if (list_empty(&dev->cqp_cmd_head) && !irdma_cqp_ring_full(dev->cqp))
+		status = irdma_exec_cqp_cmd(dev, pcmdinfo);
+	else
+		list_add_tail(&pcmdinfo->cqp_cmd_entry, &dev->cqp_cmd_head);
+	spin_unlock_irqrestore(&dev->cqp_lock, flags);
+	return status;
+}
+
+/**
+ * irdma_process_bh - called from tasklet for cqp list
+ * @dev: sc device struct
+ */
+enum irdma_status_code irdma_process_bh(struct irdma_sc_dev *dev)
+{
+	enum irdma_status_code status = 0;
+	struct cqp_cmds_info *pcmdinfo;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->cqp_lock, flags);
+	while (!list_empty(&dev->cqp_cmd_head) &&
+	       !irdma_cqp_ring_full(dev->cqp)) {
+		pcmdinfo = (struct cqp_cmds_info *)irdma_remove_cqp_head(dev);
+		status = irdma_exec_cqp_cmd(dev, pcmdinfo);
+		if (status)
+			break;
+	}
+	spin_unlock_irqrestore(&dev->cqp_lock, flags);
+	return status;
+}
+
+/**
+ * irdma_cfg_aeq- Configure AEQ interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ * @enable: True to enable, False disables
+ */
+void irdma_cfg_aeq(struct irdma_sc_dev *dev, u32 idx, bool enable)
+{
+	u32 reg_val;
+
+	reg_val = FIELD_PREP(IRDMA_PFINT_AEQCTL_CAUSE_ENA, enable) |
+		  FIELD_PREP(IRDMA_PFINT_AEQCTL_MSIX_INDX, idx) |
+		  FIELD_PREP(IRDMA_PFINT_AEQCTL_ITR_INDX, 3);
+	writel(reg_val, dev->hw_regs[IRDMA_PFINT_AEQCTL]);
+}
+
+/**
+ * sc_vsi_update_stats - Update statistics
+ * @vsi: sc_vsi instance to update
+ */
+void sc_vsi_update_stats(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_gather_stats *gather_stats;
+	struct irdma_gather_stats *last_gather_stats;
+
+	gather_stats = vsi->pestat->gather_info.gather_stats_va;
+	last_gather_stats = vsi->pestat->gather_info.last_gather_stats_va;
+	irdma_update_stats(&vsi->pestat->hw_stats, gather_stats,
+			   last_gather_stats);
+}
+
+/**
+ * irdma_wait_pe_ready - Check if firmware is ready
+ * @dev: provides access to registers
+ */
+static int irdma_wait_pe_ready(struct irdma_sc_dev *dev)
+{
+	u32 statuscpu0;
+	u32 statuscpu1;
+	u32 statuscpu2;
+	u32 retrycount = 0;
+
+	do {
+		statuscpu0 = readl(dev->hw_regs[IRDMA_GLPE_CPUSTATUS0]);
+		statuscpu1 = readl(dev->hw_regs[IRDMA_GLPE_CPUSTATUS1]);
+		statuscpu2 = readl(dev->hw_regs[IRDMA_GLPE_CPUSTATUS2]);
+		if (statuscpu0 == 0x80 && statuscpu1 == 0x80 &&
+		    statuscpu2 == 0x80)
+			return 0;
+		mdelay(1000);
+	} while (retrycount++ < dev->hw_attrs.max_pe_ready_count);
+	return -1;
+}
+
+static inline void irdma_sc_init_hw(struct irdma_sc_dev *dev)
+{
+	switch (dev->hw_attrs.uk_attrs.hw_rev) {
+	case IRDMA_GEN_1:
+		i40iw_init_hw(dev);
+		break;
+	case IRDMA_GEN_2:
+		icrdma_init_hw(dev);
+		break;
+	}
+}
+
+/**
+ * irdma_sc_dev_init - Initialize control part of device
+ * @ver: version
+ * @dev: Device pointer
+ * @info: Device init info
+ */
+enum irdma_status_code irdma_sc_dev_init(enum irdma_vers ver,
+					 struct irdma_sc_dev *dev,
+					 struct irdma_device_init_info *info)
+{
+	u32 val;
+	enum irdma_status_code ret_code = 0;
+	u8 db_size;
+
+	INIT_LIST_HEAD(&dev->cqp_cmd_head); /* for CQP command backlog */
+	mutex_init(&dev->ws_mutex);
+	dev->hmc_fn_id = info->hmc_fn_id;
+	dev->fpm_query_buf_pa = info->fpm_query_buf_pa;
+	dev->fpm_query_buf = info->fpm_query_buf;
+	dev->fpm_commit_buf_pa = info->fpm_commit_buf_pa;
+	dev->fpm_commit_buf = info->fpm_commit_buf;
+	dev->hw = info->hw;
+	dev->hw->hw_addr = info->bar0;
+	/* Setup the hardware limits, hmc may limit further */
+	dev->hw_attrs.min_hw_qp_id = IRDMA_MIN_IW_QP_ID;
+	dev->hw_attrs.min_hw_aeq_size = IRDMA_MIN_AEQ_ENTRIES;
+	dev->hw_attrs.max_hw_aeq_size = IRDMA_MAX_AEQ_ENTRIES;
+	dev->hw_attrs.min_hw_ceq_size = IRDMA_MIN_CEQ_ENTRIES;
+	dev->hw_attrs.max_hw_ceq_size = IRDMA_MAX_CEQ_ENTRIES;
+	dev->hw_attrs.uk_attrs.min_hw_cq_size = IRDMA_MIN_CQ_SIZE;
+	dev->hw_attrs.uk_attrs.max_hw_cq_size = IRDMA_MAX_CQ_SIZE;
+	dev->hw_attrs.uk_attrs.max_hw_wq_frags = IRDMA_MAX_WQ_FRAGMENT_COUNT;
+	dev->hw_attrs.uk_attrs.max_hw_read_sges = IRDMA_MAX_SGE_RD;
+	dev->hw_attrs.max_hw_outbound_msg_size = IRDMA_MAX_OUTBOUND_MSG_SIZE;
+	dev->hw_attrs.max_mr_size = IRDMA_MAX_MR_SIZE;
+	dev->hw_attrs.max_hw_inbound_msg_size = IRDMA_MAX_INBOUND_MSG_SIZE;
+	dev->hw_attrs.max_hw_device_pages = IRDMA_MAX_PUSH_PAGE_COUNT;
+	dev->hw_attrs.uk_attrs.max_hw_inline = IRDMA_MAX_INLINE_DATA_SIZE;
+	dev->hw_attrs.max_hw_wqes = IRDMA_MAX_WQ_ENTRIES;
+	dev->hw_attrs.max_qp_wr = IRDMA_MAX_QP_WRS(IRDMA_MAX_QUANTA_PER_WR);
+
+	dev->hw_attrs.uk_attrs.max_hw_rq_quanta = IRDMA_QP_SW_MAX_RQ_QUANTA;
+	dev->hw_attrs.uk_attrs.max_hw_wq_quanta = IRDMA_QP_SW_MAX_WQ_QUANTA;
+	dev->hw_attrs.max_hw_pds = IRDMA_MAX_PDS;
+	dev->hw_attrs.max_hw_ena_vf_count = IRDMA_MAX_PE_ENA_VF_COUNT;
+
+	dev->hw_attrs.max_pe_ready_count = 14;
+	dev->hw_attrs.max_done_count = IRDMA_DONE_COUNT;
+	dev->hw_attrs.max_sleep_count = IRDMA_SLEEP_COUNT;
+	dev->hw_attrs.max_cqp_compl_wait_time_ms = CQP_COMPL_WAIT_TIME_MS;
+
+	dev->hw_attrs.uk_attrs.hw_rev = ver;
+	irdma_sc_init_hw(dev);
+
+	if (irdma_wait_pe_ready(dev))
+		return IRDMA_ERR_TIMEOUT;
+
+	val = readl(dev->hw_regs[IRDMA_GLPCI_LBARCTRL]);
+	db_size = (u8)FIELD_GET(IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE, val);
+	if (db_size != IRDMA_PE_DB_SIZE_4M && db_size != IRDMA_PE_DB_SIZE_8M) {
+		ibdev_dbg(to_ibdev(dev),
+			  "DEV: RDMA PE doorbell is not enabled in CSR val 0x%x db_size=%d\n",
+			  val, db_size);
+		return IRDMA_ERR_PE_DOORBELL_NOT_ENA;
+	}
+	dev->db_addr = dev->hw->hw_addr + (uintptr_t)dev->hw_regs[IRDMA_DB_ADDR_OFFSET];
+
+	return ret_code;
+}
+
+/**
+ * irdma_update_stats - Update statistics
+ * @hw_stats: hw_stats instance to update
+ * @gather_stats: updated stat counters
+ * @last_gather_stats: last stat counters
+ */
+void irdma_update_stats(struct irdma_dev_hw_stats *hw_stats,
+			struct irdma_gather_stats *gather_stats,
+			struct irdma_gather_stats *last_gather_stats)
+{
+	u64 *stats_val = hw_stats->stats_val_32;
+
+	stats_val[IRDMA_HW_STAT_INDEX_RXVLANERR] +=
+		IRDMA_STATS_DELTA(gather_stats->rxvlanerr,
+				  last_gather_stats->rxvlanerr,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXDISCARD] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4rxdiscard,
+				  last_gather_stats->ip4rxdiscard,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXTRUNC] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4rxtrunc,
+				  last_gather_stats->ip4rxtrunc,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4TXNOROUTE] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txnoroute,
+				  last_gather_stats->ip4txnoroute,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXDISCARD] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6rxdiscard,
+				  last_gather_stats->ip6rxdiscard,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXTRUNC] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6rxtrunc,
+				  last_gather_stats->ip6rxtrunc,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6TXNOROUTE] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txnoroute,
+				  last_gather_stats->ip6txnoroute,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_TCPRTXSEG] +=
+		IRDMA_STATS_DELTA(gather_stats->tcprtxseg,
+				  last_gather_stats->tcprtxseg,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_TCPRXOPTERR] +=
+		IRDMA_STATS_DELTA(gather_stats->tcprxopterr,
+				  last_gather_stats->tcprxopterr,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_TCPRXPROTOERR] +=
+		IRDMA_STATS_DELTA(gather_stats->tcprxprotoerr,
+				  last_gather_stats->tcprxprotoerr,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_RXRPCNPHANDLED] +=
+		IRDMA_STATS_DELTA(gather_stats->rxrpcnphandled,
+				  last_gather_stats->rxrpcnphandled,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_RXRPCNPIGNORED] +=
+		IRDMA_STATS_DELTA(gather_stats->rxrpcnpignored,
+				  last_gather_stats->rxrpcnpignored,
+				  IRDMA_MAX_STATS_32);
+	stats_val[IRDMA_HW_STAT_INDEX_TXNPCNPSENT] +=
+		IRDMA_STATS_DELTA(gather_stats->txnpcnpsent,
+				  last_gather_stats->txnpcnpsent,
+				  IRDMA_MAX_STATS_32);
+	stats_val = hw_stats->stats_val_64;
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXOCTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4rxocts,
+				  last_gather_stats->ip4rxocts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4rxpkts,
+				  last_gather_stats->ip4rxpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXFRAGS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txfrag,
+				  last_gather_stats->ip4txfrag,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4RXMCPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4rxmcpkts,
+				  last_gather_stats->ip4rxmcpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4TXOCTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txocts,
+				  last_gather_stats->ip4txocts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4TXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txpkts,
+				  last_gather_stats->ip4txpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4TXFRAGS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txfrag,
+				  last_gather_stats->ip4txfrag,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP4TXMCPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip4txmcpkts,
+				  last_gather_stats->ip4txmcpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXOCTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6rxocts,
+				  last_gather_stats->ip6rxocts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6rxpkts,
+				  last_gather_stats->ip6rxpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXFRAGS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txfrags,
+				  last_gather_stats->ip6txfrags,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6RXMCPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6rxmcpkts,
+				  last_gather_stats->ip6rxmcpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6TXOCTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txocts,
+				  last_gather_stats->ip6txocts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6TXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txpkts,
+				  last_gather_stats->ip6txpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6TXFRAGS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txfrags,
+				  last_gather_stats->ip6txfrags,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_IP6TXMCPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->ip6txmcpkts,
+				  last_gather_stats->ip6txmcpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_TCPRXSEGS] +=
+		IRDMA_STATS_DELTA(gather_stats->tcprxsegs,
+				  last_gather_stats->tcprxsegs,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_TCPTXSEG] +=
+		IRDMA_STATS_DELTA(gather_stats->tcptxsegs,
+				  last_gather_stats->tcptxsegs,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMARXRDS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmarxrds,
+				  last_gather_stats->rdmarxrds,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMARXSNDS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmarxsnds,
+				  last_gather_stats->rdmarxsnds,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMARXWRS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmarxwrs,
+				  last_gather_stats->rdmarxwrs,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMATXRDS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmatxrds,
+				  last_gather_stats->rdmatxrds,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMATXSNDS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmatxsnds,
+				  last_gather_stats->rdmatxsnds,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMATXWRS] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmatxwrs,
+				  last_gather_stats->rdmatxwrs,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMAVBND] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmavbn,
+				  last_gather_stats->rdmavbn,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RDMAVINV] +=
+		IRDMA_STATS_DELTA(gather_stats->rdmavinv,
+				  last_gather_stats->rdmavinv,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_UDPRXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->udprxpkts,
+				  last_gather_stats->udprxpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_UDPTXPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->udptxpkts,
+				  last_gather_stats->udptxpkts,
+				  IRDMA_MAX_STATS_48);
+	stats_val[IRDMA_HW_STAT_INDEX_RXNPECNMARKEDPKTS] +=
+		IRDMA_STATS_DELTA(gather_stats->rxnpecnmrkpkts,
+				  last_gather_stats->rxnpecnmrkpkts,
+				  IRDMA_MAX_STATS_48);
+	memcpy(last_gather_stats, gather_stats, sizeof(*last_gather_stats));
+}
diff --git a/drivers/infiniband/hw/irdma/defs.h b/drivers/infiniband/hw/irdma/defs.h
new file mode 100644
index 0000000..cc3d9a3
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -0,0 +1,1155 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#ifndef IRDMA_DEFS_H
+#define IRDMA_DEFS_H
+
+#define IRDMA_FIRST_USER_QP_ID	3
+
+#define ECN_CODE_PT_VAL	2
+
+#define IRDMA_PUSH_OFFSET		(8 * 1024 * 1024)
+#define IRDMA_PF_FIRST_PUSH_PAGE_INDEX	16
+#define IRDMA_PF_BAR_RSVD		(60 * 1024)
+
+#define IRDMA_PE_DB_SIZE_4M	1
+#define IRDMA_PE_DB_SIZE_8M	2
+
+#define IRDMA_IRD_HW_SIZE_4	0
+#define IRDMA_IRD_HW_SIZE_16	1
+#define IRDMA_IRD_HW_SIZE_64	2
+#define IRDMA_IRD_HW_SIZE_128	3
+#define IRDMA_IRD_HW_SIZE_256	4
+
+enum irdma_protocol_used {
+	IRDMA_ANY_PROTOCOL = 0,
+	IRDMA_IWARP_PROTOCOL_ONLY = 1,
+	IRDMA_ROCE_PROTOCOL_ONLY = 2,
+};
+
+#define IRDMA_QP_STATE_INVALID		0
+#define IRDMA_QP_STATE_IDLE		1
+#define IRDMA_QP_STATE_RTS		2
+#define IRDMA_QP_STATE_CLOSING		3
+#define IRDMA_QP_STATE_SQD		3
+#define IRDMA_QP_STATE_RTR		4
+#define IRDMA_QP_STATE_TERMINATE	5
+#define IRDMA_QP_STATE_ERROR		6
+
+#define IRDMA_MAX_TRAFFIC_CLASS		8
+#define IRDMA_MAX_USER_PRIORITY		8
+#define IRDMA_MAX_APPS			8
+#define IRDMA_MAX_STATS_COUNT		128
+#define IRDMA_FIRST_NON_PF_STAT		4
+
+#define IRDMA_MIN_MTU_IPV4	576
+#define IRDMA_MIN_MTU_IPV6	1280
+#define IRDMA_MTU_TO_MSS_IPV4	40
+#define IRDMA_MTU_TO_MSS_IPV6	60
+#define IRDMA_DEFAULT_MTU	1500
+
+#define Q2_FPSN_OFFSET		64
+#define TERM_DDP_LEN_TAGGED	14
+#define TERM_DDP_LEN_UNTAGGED	18
+#define TERM_RDMA_LEN		28
+#define RDMA_OPCODE_M		0x0f
+#define RDMA_READ_REQ_OPCODE	1
+#define Q2_BAD_FRAME_OFFSET	72
+#define CQE_MAJOR_DRV		0x8000
+
+#define IRDMA_TERM_SENT		1
+#define IRDMA_TERM_RCVD		2
+#define IRDMA_TERM_DONE		4
+#define IRDMA_MAC_HLEN		14
+
+#define IRDMA_CQP_WAIT_POLL_REGS	1
+#define IRDMA_CQP_WAIT_POLL_CQ		2
+#define IRDMA_CQP_WAIT_EVENT		3
+
+#define IRDMA_AE_SOURCE_RSVD		0x0
+#define IRDMA_AE_SOURCE_RQ		0x1
+#define IRDMA_AE_SOURCE_RQ_0011		0x3
+
+#define IRDMA_AE_SOURCE_CQ		0x2
+#define IRDMA_AE_SOURCE_CQ_0110		0x6
+#define IRDMA_AE_SOURCE_CQ_1010		0xa
+#define IRDMA_AE_SOURCE_CQ_1110		0xe
+
+#define IRDMA_AE_SOURCE_SQ		0x5
+#define IRDMA_AE_SOURCE_SQ_0111		0x7
+
+#define IRDMA_AE_SOURCE_IN_RR_WR	0x9
+#define IRDMA_AE_SOURCE_IN_RR_WR_1011	0xb
+#define IRDMA_AE_SOURCE_OUT_RR		0xd
+#define IRDMA_AE_SOURCE_OUT_RR_1111	0xf
+
+#define IRDMA_TCP_STATE_NON_EXISTENT	0
+#define IRDMA_TCP_STATE_CLOSED		1
+#define IRDMA_TCP_STATE_LISTEN		2
+#define IRDMA_STATE_SYN_SEND		3
+#define IRDMA_TCP_STATE_SYN_RECEIVED	4
+#define IRDMA_TCP_STATE_ESTABLISHED	5
+#define IRDMA_TCP_STATE_CLOSE_WAIT	6
+#define IRDMA_TCP_STATE_FIN_WAIT_1	7
+#define IRDMA_TCP_STATE_CLOSING		8
+#define IRDMA_TCP_STATE_LAST_ACK	9
+#define IRDMA_TCP_STATE_FIN_WAIT_2	10
+#define IRDMA_TCP_STATE_TIME_WAIT	11
+#define IRDMA_TCP_STATE_RESERVED_1	12
+#define IRDMA_TCP_STATE_RESERVED_2	13
+#define IRDMA_TCP_STATE_RESERVED_3	14
+#define IRDMA_TCP_STATE_RESERVED_4	15
+
+#define IRDMA_CQP_SW_SQSIZE_4		4
+#define IRDMA_CQP_SW_SQSIZE_2048	2048
+
+#define IRDMA_CQ_TYPE_IWARP	1
+#define IRDMA_CQ_TYPE_ILQ	2
+#define IRDMA_CQ_TYPE_IEQ	3
+#define IRDMA_CQ_TYPE_CQP	4
+
+#define IRDMA_DONE_COUNT	1000
+#define IRDMA_SLEEP_COUNT	10
+
+#define IRDMA_UPDATE_SD_BUFF_SIZE	128
+#define IRDMA_FEATURE_BUF_SIZE		(8 * IRDMA_MAX_FEATURES)
+
+#define IRDMA_MAX_QUANTA_PER_WR	8
+
+#define IRDMA_QP_SW_MAX_WQ_QUANTA	32768
+#define IRDMA_QP_SW_MAX_SQ_QUANTA	32768
+#define IRDMA_QP_SW_MAX_RQ_QUANTA	32768
+#define IRDMA_MAX_QP_WRS(max_quanta_per_wr) \
+	((IRDMA_QP_SW_MAX_WQ_QUANTA - IRDMA_SQ_RSVD) / (max_quanta_per_wr))
+
+#define IRDMAQP_TERM_SEND_TERM_AND_FIN		0
+#define IRDMAQP_TERM_SEND_TERM_ONLY		1
+#define IRDMAQP_TERM_SEND_FIN_ONLY		2
+#define IRDMAQP_TERM_DONOT_SEND_TERM_OR_FIN	3
+
+#define IRDMA_QP_TYPE_IWARP	1
+#define IRDMA_QP_TYPE_UDA	2
+#define IRDMA_QP_TYPE_ROCE_RC	3
+#define IRDMA_QP_TYPE_ROCE_UD	4
+
+#define IRDMA_HW_PAGE_SIZE	4096
+#define IRDMA_HW_PAGE_SHIFT	12
+#define IRDMA_CQE_QTYPE_RQ	0
+#define IRDMA_CQE_QTYPE_SQ	1
+
+#define IRDMA_QP_SW_MIN_WQSIZE	8u /* in WRs*/
+#define IRDMA_QP_WQE_MIN_SIZE	32
+#define IRDMA_QP_WQE_MAX_SIZE	256
+#define IRDMA_QP_WQE_MIN_QUANTA 1
+#define IRDMA_MAX_RQ_WQE_SHIFT_GEN1 2
+#define IRDMA_MAX_RQ_WQE_SHIFT_GEN2 3
+
+#define IRDMA_SQ_RSVD	258
+#define IRDMA_RQ_RSVD	1
+
+#define IRDMA_FEATURE_RTS_AE			1ULL
+#define IRDMA_FEATURE_CQ_RESIZE			2ULL
+#define IRDMAQP_OP_RDMA_WRITE			0x00
+#define IRDMAQP_OP_RDMA_READ			0x01
+#define IRDMAQP_OP_RDMA_SEND			0x03
+#define IRDMAQP_OP_RDMA_SEND_INV		0x04
+#define IRDMAQP_OP_RDMA_SEND_SOL_EVENT		0x05
+#define IRDMAQP_OP_RDMA_SEND_SOL_EVENT_INV	0x06
+#define IRDMAQP_OP_BIND_MW			0x08
+#define IRDMAQP_OP_FAST_REGISTER		0x09
+#define IRDMAQP_OP_LOCAL_INVALIDATE		0x0a
+#define IRDMAQP_OP_RDMA_READ_LOC_INV		0x0b
+#define IRDMAQP_OP_NOP				0x0c
+#define IRDMAQP_OP_RDMA_WRITE_SOL		0x0d
+#define IRDMAQP_OP_GEN_RTS_AE			0x30
+
+enum irdma_cqp_op_type {
+	IRDMA_OP_CEQ_DESTROY			= 1,
+	IRDMA_OP_AEQ_DESTROY			= 2,
+	IRDMA_OP_DELETE_ARP_CACHE_ENTRY		= 3,
+	IRDMA_OP_MANAGE_APBVT_ENTRY		= 4,
+	IRDMA_OP_CEQ_CREATE			= 5,
+	IRDMA_OP_AEQ_CREATE			= 6,
+	IRDMA_OP_MANAGE_QHASH_TABLE_ENTRY	= 7,
+	IRDMA_OP_QP_MODIFY			= 8,
+	IRDMA_OP_QP_UPLOAD_CONTEXT		= 9,
+	IRDMA_OP_CQ_CREATE			= 10,
+	IRDMA_OP_CQ_DESTROY			= 11,
+	IRDMA_OP_QP_CREATE			= 12,
+	IRDMA_OP_QP_DESTROY			= 13,
+	IRDMA_OP_ALLOC_STAG			= 14,
+	IRDMA_OP_MR_REG_NON_SHARED		= 15,
+	IRDMA_OP_DEALLOC_STAG			= 16,
+	IRDMA_OP_MW_ALLOC			= 17,
+	IRDMA_OP_QP_FLUSH_WQES			= 18,
+	IRDMA_OP_ADD_ARP_CACHE_ENTRY		= 19,
+	IRDMA_OP_MANAGE_PUSH_PAGE		= 20,
+	IRDMA_OP_UPDATE_PE_SDS			= 21,
+	IRDMA_OP_MANAGE_HMC_PM_FUNC_TABLE	= 22,
+	IRDMA_OP_SUSPEND			= 23,
+	IRDMA_OP_RESUME				= 24,
+	IRDMA_OP_MANAGE_VF_PBLE_BP		= 25,
+	IRDMA_OP_QUERY_FPM_VAL			= 26,
+	IRDMA_OP_COMMIT_FPM_VAL			= 27,
+	IRDMA_OP_REQ_CMDS			= 28,
+	IRDMA_OP_CMPL_CMDS			= 29,
+	IRDMA_OP_AH_CREATE			= 30,
+	IRDMA_OP_AH_MODIFY			= 31,
+	IRDMA_OP_AH_DESTROY			= 32,
+	IRDMA_OP_MC_CREATE			= 33,
+	IRDMA_OP_MC_DESTROY			= 34,
+	IRDMA_OP_MC_MODIFY			= 35,
+	IRDMA_OP_STATS_ALLOCATE			= 36,
+	IRDMA_OP_STATS_FREE			= 37,
+	IRDMA_OP_STATS_GATHER			= 38,
+	IRDMA_OP_WS_ADD_NODE			= 39,
+	IRDMA_OP_WS_MODIFY_NODE			= 40,
+	IRDMA_OP_WS_DELETE_NODE			= 41,
+	IRDMA_OP_WS_FAILOVER_START		= 42,
+	IRDMA_OP_WS_FAILOVER_COMPLETE		= 43,
+	IRDMA_OP_SET_UP_MAP			= 44,
+	IRDMA_OP_GEN_AE				= 45,
+	IRDMA_OP_QUERY_RDMA_FEATURES		= 46,
+	IRDMA_OP_ALLOC_LOCAL_MAC_ENTRY		= 47,
+	IRDMA_OP_ADD_LOCAL_MAC_ENTRY		= 48,
+	IRDMA_OP_DELETE_LOCAL_MAC_ENTRY		= 49,
+	IRDMA_OP_CQ_MODIFY			= 50,
+
+	/* Must be last entry*/
+	IRDMA_MAX_CQP_OPS			= 51,
+};
+
+/* CQP SQ WQES */
+#define IRDMA_CQP_OP_CREATE_QP				0
+#define IRDMA_CQP_OP_MODIFY_QP				0x1
+#define IRDMA_CQP_OP_DESTROY_QP				0x02
+#define IRDMA_CQP_OP_CREATE_CQ				0x03
+#define IRDMA_CQP_OP_MODIFY_CQ				0x04
+#define IRDMA_CQP_OP_DESTROY_CQ				0x05
+#define IRDMA_CQP_OP_ALLOC_STAG				0x09
+#define IRDMA_CQP_OP_REG_MR				0x0a
+#define IRDMA_CQP_OP_QUERY_STAG				0x0b
+#define IRDMA_CQP_OP_REG_SMR				0x0c
+#define IRDMA_CQP_OP_DEALLOC_STAG			0x0d
+#define IRDMA_CQP_OP_MANAGE_LOC_MAC_TABLE		0x0e
+#define IRDMA_CQP_OP_MANAGE_ARP				0x0f
+#define IRDMA_CQP_OP_MANAGE_VF_PBLE_BP			0x10
+#define IRDMA_CQP_OP_MANAGE_PUSH_PAGES			0x11
+#define IRDMA_CQP_OP_QUERY_RDMA_FEATURES		0x12
+#define IRDMA_CQP_OP_UPLOAD_CONTEXT			0x13
+#define IRDMA_CQP_OP_ALLOCATE_LOC_MAC_TABLE_ENTRY	0x14
+#define IRDMA_CQP_OP_UPLOAD_CONTEXT			0x13
+#define IRDMA_CQP_OP_MANAGE_HMC_PM_FUNC_TABLE		0x15
+#define IRDMA_CQP_OP_CREATE_CEQ				0x16
+#define IRDMA_CQP_OP_DESTROY_CEQ			0x18
+#define IRDMA_CQP_OP_CREATE_AEQ				0x19
+#define IRDMA_CQP_OP_DESTROY_AEQ			0x1b
+#define IRDMA_CQP_OP_CREATE_ADDR_HANDLE			0x1c
+#define IRDMA_CQP_OP_MODIFY_ADDR_HANDLE			0x1d
+#define IRDMA_CQP_OP_DESTROY_ADDR_HANDLE		0x1e
+#define IRDMA_CQP_OP_UPDATE_PE_SDS			0x1f
+#define IRDMA_CQP_OP_QUERY_FPM_VAL			0x20
+#define IRDMA_CQP_OP_COMMIT_FPM_VAL			0x21
+#define IRDMA_CQP_OP_FLUSH_WQES				0x22
+/* IRDMA_CQP_OP_GEN_AE is the same value as IRDMA_CQP_OP_FLUSH_WQES */
+#define IRDMA_CQP_OP_GEN_AE				0x22
+#define IRDMA_CQP_OP_MANAGE_APBVT			0x23
+#define IRDMA_CQP_OP_NOP				0x24
+#define IRDMA_CQP_OP_MANAGE_QUAD_HASH_TABLE_ENTRY	0x25
+#define IRDMA_CQP_OP_CREATE_MCAST_GRP			0x26
+#define IRDMA_CQP_OP_MODIFY_MCAST_GRP			0x27
+#define IRDMA_CQP_OP_DESTROY_MCAST_GRP			0x28
+#define IRDMA_CQP_OP_SUSPEND_QP				0x29
+#define IRDMA_CQP_OP_RESUME_QP				0x2a
+#define IRDMA_CQP_OP_SHMC_PAGES_ALLOCATED		0x2b
+#define IRDMA_CQP_OP_WORK_SCHED_NODE			0x2c
+#define IRDMA_CQP_OP_MANAGE_STATS			0x2d
+#define IRDMA_CQP_OP_GATHER_STATS			0x2e
+#define IRDMA_CQP_OP_UP_MAP				0x2f
+
+/* Async Events codes */
+#define IRDMA_AE_AMP_UNALLOCATED_STAG					0x0102
+#define IRDMA_AE_AMP_INVALID_STAG					0x0103
+#define IRDMA_AE_AMP_BAD_QP						0x0104
+#define IRDMA_AE_AMP_BAD_PD						0x0105
+#define IRDMA_AE_AMP_BAD_STAG_KEY					0x0106
+#define IRDMA_AE_AMP_BAD_STAG_INDEX					0x0107
+#define IRDMA_AE_AMP_BOUNDS_VIOLATION					0x0108
+#define IRDMA_AE_AMP_RIGHTS_VIOLATION					0x0109
+#define IRDMA_AE_AMP_TO_WRAP						0x010a
+#define IRDMA_AE_AMP_FASTREG_VALID_STAG					0x010c
+#define IRDMA_AE_AMP_FASTREG_MW_STAG					0x010d
+#define IRDMA_AE_AMP_FASTREG_INVALID_RIGHTS				0x010e
+#define IRDMA_AE_AMP_FASTREG_INVALID_LENGTH				0x0110
+#define IRDMA_AE_AMP_INVALIDATE_SHARED					0x0111
+#define IRDMA_AE_AMP_INVALIDATE_NO_REMOTE_ACCESS_RIGHTS			0x0112
+#define IRDMA_AE_AMP_INVALIDATE_MR_WITH_BOUND_WINDOWS			0x0113
+#define IRDMA_AE_AMP_MWBIND_VALID_STAG					0x0114
+#define IRDMA_AE_AMP_MWBIND_OF_MR_STAG					0x0115
+#define IRDMA_AE_AMP_MWBIND_TO_ZERO_BASED_STAG				0x0116
+#define IRDMA_AE_AMP_MWBIND_TO_MW_STAG					0x0117
+#define IRDMA_AE_AMP_MWBIND_INVALID_RIGHTS				0x0118
+#define IRDMA_AE_AMP_MWBIND_INVALID_BOUNDS				0x0119
+#define IRDMA_AE_AMP_MWBIND_TO_INVALID_PARENT				0x011a
+#define IRDMA_AE_AMP_MWBIND_BIND_DISABLED				0x011b
+#define IRDMA_AE_PRIV_OPERATION_DENIED					0x011c
+#define IRDMA_AE_AMP_INVALIDATE_TYPE1_MW				0x011d
+#define IRDMA_AE_AMP_MWBIND_ZERO_BASED_TYPE1_MW				0x011e
+#define IRDMA_AE_AMP_FASTREG_INVALID_PBL_HPS_CFG			0x011f
+#define IRDMA_AE_AMP_MWBIND_WRONG_TYPE					0x0120
+#define IRDMA_AE_AMP_FASTREG_PBLE_MISMATCH				0x0121
+#define IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG				0x0132
+#define IRDMA_AE_UDA_XMIT_BAD_PD					0x0133
+#define IRDMA_AE_UDA_XMIT_DGRAM_TOO_SHORT				0x0134
+#define IRDMA_AE_UDA_L4LEN_INVALID					0x0135
+#define IRDMA_AE_BAD_CLOSE						0x0201
+#define IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE				0x0202
+#define IRDMA_AE_CQ_OPERATION_ERROR					0x0203
+#define IRDMA_AE_RDMA_READ_WHILE_ORD_ZERO				0x0205
+#define IRDMA_AE_STAG_ZERO_INVALID					0x0206
+#define IRDMA_AE_IB_RREQ_AND_Q1_FULL					0x0207
+#define IRDMA_AE_IB_INVALID_REQUEST					0x0208
+#define IRDMA_AE_WQE_UNEXPECTED_OPCODE					0x020a
+#define IRDMA_AE_WQE_INVALID_PARAMETER					0x020b
+#define IRDMA_AE_WQE_INVALID_FRAG_DATA					0x020c
+#define IRDMA_AE_IB_REMOTE_ACCESS_ERROR					0x020d
+#define IRDMA_AE_IB_REMOTE_OP_ERROR					0x020e
+#define IRDMA_AE_WQE_LSMM_TOO_LONG					0x0220
+#define IRDMA_AE_DDP_INVALID_MSN_GAP_IN_MSN				0x0301
+#define IRDMA_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER	0x0303
+#define IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION				0x0304
+#define IRDMA_AE_DDP_UBE_INVALID_MO					0x0305
+#define IRDMA_AE_DDP_UBE_INVALID_MSN_NO_BUFFER_AVAILABLE		0x0306
+#define IRDMA_AE_DDP_UBE_INVALID_QN					0x0307
+#define IRDMA_AE_DDP_NO_L_BIT						0x0308
+#define IRDMA_AE_RDMAP_ROE_INVALID_RDMAP_VERSION			0x0311
+#define IRDMA_AE_RDMAP_ROE_UNEXPECTED_OPCODE				0x0312
+#define IRDMA_AE_ROE_INVALID_RDMA_READ_REQUEST				0x0313
+#define IRDMA_AE_ROE_INVALID_RDMA_WRITE_OR_READ_RESP			0x0314
+#define IRDMA_AE_ROCE_RSP_LENGTH_ERROR					0x0316
+#define IRDMA_AE_ROCE_EMPTY_MCG						0x0380
+#define IRDMA_AE_ROCE_BAD_MC_IP_ADDR					0x0381
+#define IRDMA_AE_ROCE_BAD_MC_QPID					0x0382
+#define IRDMA_AE_MCG_QP_PROTOCOL_MISMATCH				0x0383
+#define IRDMA_AE_INVALID_ARP_ENTRY					0x0401
+#define IRDMA_AE_INVALID_TCP_OPTION_RCVD				0x0402
+#define IRDMA_AE_STALE_ARP_ENTRY					0x0403
+#define IRDMA_AE_INVALID_AH_ENTRY					0x0406
+#define IRDMA_AE_LLP_CLOSE_COMPLETE					0x0501
+#define IRDMA_AE_LLP_CONNECTION_RESET					0x0502
+#define IRDMA_AE_LLP_FIN_RECEIVED					0x0503
+#define IRDMA_AE_LLP_RECEIVED_MARKER_AND_LENGTH_FIELDS_DONT_MATCH	0x0504
+#define IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR				0x0505
+#define IRDMA_AE_LLP_SEGMENT_TOO_SMALL					0x0507
+#define IRDMA_AE_LLP_SYN_RECEIVED					0x0508
+#define IRDMA_AE_LLP_TERMINATE_RECEIVED					0x0509
+#define IRDMA_AE_LLP_TOO_MANY_RETRIES					0x050a
+#define IRDMA_AE_LLP_TOO_MANY_KEEPALIVE_RETRIES				0x050b
+#define IRDMA_AE_LLP_DOUBT_REACHABILITY					0x050c
+#define IRDMA_AE_LLP_CONNECTION_ESTABLISHED				0x050e
+#define IRDMA_AE_RESOURCE_EXHAUSTION					0x0520
+#define IRDMA_AE_RESET_SENT						0x0601
+#define IRDMA_AE_TERMINATE_SENT						0x0602
+#define IRDMA_AE_RESET_NOT_SENT						0x0603
+#define IRDMA_AE_LCE_QP_CATASTROPHIC					0x0700
+#define IRDMA_AE_LCE_FUNCTION_CATASTROPHIC				0x0701
+#define IRDMA_AE_LCE_CQ_CATASTROPHIC					0x0702
+#define IRDMA_AE_QP_SUSPEND_COMPLETE					0x0900
+
+#define FLD_LS_64(dev, val, field)	\
+	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
+#define FLD_RS_64(dev, val, field)	\
+	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ## _S])
+#define FLD_LS_32(dev, val, field)	\
+	(((val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
+#define FLD_RS_32(dev, val, field)	\
+	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ## _S])
+
+#define IRDMA_STATS_DELTA(a, b, c) ((a) >= (b) ? (a) - (b) : (a) + (c) - (b))
+#define IRDMA_MAX_STATS_32	0xFFFFFFFFULL
+#define IRDMA_MAX_STATS_48	0xFFFFFFFFFFFFULL
+
+#define IRDMA_MAX_CQ_READ_THRESH 0x3FFFF
+#define IRDMA_CQPSQ_QHASH_VLANID GENMASK_ULL(43, 32)
+#define IRDMA_CQPSQ_QHASH_QPN GENMASK_ULL(49, 32)
+#define IRDMA_CQPSQ_QHASH_QS_HANDLE GENMASK_ULL(9, 0)
+#define IRDMA_CQPSQ_QHASH_SRC_PORT GENMASK_ULL(31, 16)
+#define IRDMA_CQPSQ_QHASH_DEST_PORT GENMASK_ULL(15, 0)
+#define IRDMA_CQPSQ_QHASH_ADDR0 GENMASK_ULL(63, 32)
+#define IRDMA_CQPSQ_QHASH_ADDR1 GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_QHASH_ADDR2 GENMASK_ULL(63, 32)
+#define IRDMA_CQPSQ_QHASH_ADDR3 GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_QHASH_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_QHASH_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_QHASH_MANAGE GENMASK_ULL(62, 61)
+#define IRDMA_CQPSQ_QHASH_IPV4VALID BIT_ULL(60)
+#define IRDMA_CQPSQ_QHASH_VLANVALID BIT_ULL(59)
+#define IRDMA_CQPSQ_QHASH_ENTRYTYPE GENMASK_ULL(44, 42)
+#define IRDMA_CQPSQ_STATS_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_STATS_ALLOC_INST BIT_ULL(62)
+#define IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX BIT_ULL(60)
+#define IRDMA_CQPSQ_STATS_USE_INST BIT_ULL(61)
+#define IRDMA_CQPSQ_STATS_OP GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_STATS_INST_INDEX GENMASK_ULL(6, 0)
+#define IRDMA_CQPSQ_STATS_HMC_FCN_INDEX GENMASK_ULL(5, 0)
+#define IRDMA_CQPSQ_WS_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_WS_NODEOP GENMASK_ULL(53, 52)
+
+#define IRDMA_CQPSQ_WS_ENABLENODE BIT_ULL(62)
+#define IRDMA_CQPSQ_WS_NODETYPE BIT_ULL(61)
+#define IRDMA_CQPSQ_WS_PRIOTYPE GENMASK_ULL(60, 59)
+#define IRDMA_CQPSQ_WS_TC GENMASK_ULL(58, 56)
+#define IRDMA_CQPSQ_WS_VMVFTYPE GENMASK_ULL(55, 54)
+#define IRDMA_CQPSQ_WS_VMVFNUM GENMASK_ULL(51, 42)
+#define IRDMA_CQPSQ_WS_OP GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_WS_PARENTID GENMASK_ULL(25, 16)
+#define IRDMA_CQPSQ_WS_NODEID GENMASK_ULL(9, 0)
+#define IRDMA_CQPSQ_WS_VSI GENMASK_ULL(57, 48)
+#define IRDMA_CQPSQ_WS_WEIGHT GENMASK_ULL(38, 32)
+
+#define IRDMA_CQPSQ_UP_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_UP_USEVLAN BIT_ULL(62)
+#define IRDMA_CQPSQ_UP_USEOVERRIDE BIT_ULL(61)
+#define IRDMA_CQPSQ_UP_OP GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_UP_HMCFCNIDX GENMASK_ULL(5, 0)
+#define IRDMA_CQPSQ_UP_CNPOVERRIDE GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_OP GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MODEL_USED GENMASK_ULL(47, 32)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MAJOR_VERSION GENMASK_ULL(23, 16)
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MINOR_VERSION GENMASK_ULL(7, 0)
+#define IRDMA_CQPHC_SQSIZE GENMASK_ULL(11, 8)
+#define IRDMA_CQPHC_DISABLE_PFPDUS BIT_ULL(1)
+#define IRDMA_CQPHC_ROCEV2_RTO_POLICY BIT_ULL(2)
+#define IRDMA_CQPHC_PROTOCOL_USED GENMASK_ULL(4, 3)
+#define IRDMA_CQPHC_MIN_RATE GENMASK_ULL(51, 48)
+#define IRDMA_CQPHC_MIN_DEC_FACTOR GENMASK_ULL(59, 56)
+#define IRDMA_CQPHC_DCQCN_T GENMASK_ULL(15, 0)
+#define IRDMA_CQPHC_HAI_FACTOR GENMASK_ULL(47, 32)
+#define IRDMA_CQPHC_RAI_FACTOR GENMASK_ULL(63, 48)
+#define IRDMA_CQPHC_DCQCN_B GENMASK_ULL(24, 0)
+#define IRDMA_CQPHC_DCQCN_F GENMASK_ULL(27, 25)
+#define IRDMA_CQPHC_CC_CFG_VALID BIT_ULL(31)
+#define IRDMA_CQPHC_RREDUCE_MPERIOD GENMASK_ULL(63, 32)
+#define IRDMA_CQPHC_HW_MINVER GENMASK_ULL(15, 0)
+
+#define IRDMA_CQPHC_HW_MAJVER_GEN_1 0
+#define IRDMA_CQPHC_HW_MAJVER_GEN_2 1
+#define IRDMA_CQPHC_HW_MAJVER_GEN_3 2
+#define IRDMA_CQPHC_HW_MAJVER GENMASK_ULL(31, 16)
+#define IRDMA_CQPHC_CEQPERVF GENMASK_ULL(39, 32)
+
+#define IRDMA_CQPHC_ENABLED_VFS GENMASK_ULL(37, 32)
+
+#define IRDMA_CQPHC_HMC_PROFILE GENMASK_ULL(2, 0)
+#define IRDMA_CQPHC_SVER GENMASK_ULL(31, 24)
+#define IRDMA_CQPHC_SQBASE GENMASK_ULL(63, 9)
+
+#define IRDMA_CQPHC_QPCTX GENMASK_ULL(63, 0)
+#define IRDMA_QP_DBSA_HW_SQ_TAIL GENMASK_ULL(14, 0)
+#define IRDMA_CQ_DBSA_CQEIDX GENMASK_ULL(19, 0)
+#define IRDMA_CQ_DBSA_SW_CQ_SELECT GENMASK_ULL(13, 0)
+#define IRDMA_CQ_DBSA_ARM_NEXT BIT_ULL(14)
+#define IRDMA_CQ_DBSA_ARM_NEXT_SE BIT_ULL(15)
+#define IRDMA_CQ_DBSA_ARM_SEQ_NUM GENMASK_ULL(17, 16)
+
+/* CQP and iWARP Completion Queue */
+#define IRDMA_CQ_QPCTX IRDMA_CQPHC_QPCTX
+
+#define IRDMA_CCQ_OPRETVAL GENMASK_ULL(31, 0)
+
+#define IRDMA_CQ_MINERR GENMASK_ULL(15, 0)
+#define IRDMA_CQ_MAJERR GENMASK_ULL(31, 16)
+#define IRDMA_CQ_WQEIDX GENMASK_ULL(46, 32)
+#define IRDMA_CQ_EXTCQE BIT_ULL(50)
+#define IRDMA_OOO_CMPL BIT_ULL(54)
+#define IRDMA_CQ_ERROR BIT_ULL(55)
+#define IRDMA_CQ_SQ BIT_ULL(62)
+
+#define IRDMA_CQ_VALID BIT_ULL(63)
+#define IRDMA_CQ_IMMVALID BIT_ULL(62)
+#define IRDMA_CQ_UDSMACVALID BIT_ULL(61)
+#define IRDMA_CQ_UDVLANVALID BIT_ULL(60)
+#define IRDMA_CQ_UDSMAC GENMASK_ULL(47, 0)
+#define IRDMA_CQ_UDVLAN GENMASK_ULL(63, 48)
+
+#define IRDMA_CQ_IMMDATA_S 0
+#define IRDMA_CQ_IMMDATA_M (0xffffffffffffffffULL << IRDMA_CQ_IMMVALID_S)
+#define IRDMA_CQ_IMMDATALOW32 GENMASK_ULL(31, 0)
+#define IRDMA_CQ_IMMDATAUP32 GENMASK_ULL(63, 32)
+#define IRDMACQ_PAYLDLEN GENMASK_ULL(31, 0)
+#define IRDMACQ_TCPSEQNUMRTT GENMASK_ULL(63, 32)
+#define IRDMACQ_INVSTAG GENMASK_ULL(31, 0)
+#define IRDMACQ_QPID GENMASK_ULL(55, 32)
+
+#define IRDMACQ_UDSRCQPN GENMASK_ULL(31, 0)
+#define IRDMACQ_PSHDROP BIT_ULL(51)
+#define IRDMACQ_STAG BIT_ULL(53)
+#define IRDMACQ_IPV4 BIT_ULL(53)
+#define IRDMACQ_SOEVENT BIT_ULL(54)
+#define IRDMACQ_OP GENMASK_ULL(61, 56)
+
+#define IRDMA_CEQE_CQCTX GENMASK_ULL(62, 0)
+#define IRDMA_CEQE_VALID BIT_ULL(63)
+
+/* AEQE format */
+#define IRDMA_AEQE_COMPCTX IRDMA_CQPHC_QPCTX
+#define IRDMA_AEQE_QPCQID_LOW GENMASK_ULL(17, 0)
+#define IRDMA_AEQE_QPCQID_HI BIT_ULL(46)
+#define IRDMA_AEQE_WQDESCIDX GENMASK_ULL(32, 18)
+#define IRDMA_AEQE_OVERFLOW BIT_ULL(33)
+#define IRDMA_AEQE_AECODE GENMASK_ULL(45, 34)
+#define IRDMA_AEQE_AESRC GENMASK_ULL(53, 50)
+#define IRDMA_AEQE_IWSTATE GENMASK_ULL(56, 54)
+#define IRDMA_AEQE_TCPSTATE GENMASK_ULL(60, 57)
+#define IRDMA_AEQE_Q2DATA GENMASK_ULL(62, 61)
+#define IRDMA_AEQE_VALID BIT_ULL(63)
+
+#define IRDMA_UDA_QPSQ_NEXT_HDR GENMASK_ULL(23, 16)
+#define IRDMA_UDA_QPSQ_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_UDA_QPSQ_L4LEN GENMASK_ULL(45, 42)
+#define IRDMA_GEN1_UDA_QPSQ_L4LEN GENMASK_ULL(27, 24)
+#define IRDMA_UDA_QPSQ_AHIDX GENMASK_ULL(16, 0)
+#define IRDMA_UDA_QPSQ_VALID BIT_ULL(63)
+#define IRDMA_UDA_QPSQ_SIGCOMPL BIT_ULL(62)
+#define IRDMA_UDA_QPSQ_MACLEN GENMASK_ULL(62, 56)
+#define IRDMA_UDA_QPSQ_IPLEN GENMASK_ULL(54, 48)
+#define IRDMA_UDA_QPSQ_L4T GENMASK_ULL(31, 30)
+#define IRDMA_UDA_QPSQ_IIPT GENMASK_ULL(29, 28)
+#define IRDMA_UDA_PAYLOADLEN GENMASK_ULL(13, 0)
+#define IRDMA_UDA_HDRLEN GENMASK_ULL(24, 16)
+#define IRDMA_VLAN_TAG_VALID BIT_ULL(50)
+#define IRDMA_UDA_L3PROTO GENMASK_ULL(1, 0)
+#define IRDMA_UDA_L4PROTO GENMASK_ULL(17, 16)
+#define IRDMA_UDA_QPSQ_DOLOOPBACK BIT_ULL(44)
+#define IRDMA_CQPSQ_BUFSIZE GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_OPCODE GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_WQEVALID BIT_ULL(63)
+#define IRDMA_CQPSQ_TPHVAL GENMASK_ULL(7, 0)
+
+#define IRDMA_CQPSQ_VSIIDX GENMASK_ULL(17, 8)
+#define IRDMA_CQPSQ_TPHEN BIT_ULL(60)
+
+#define IRDMA_CQPSQ_PBUFADDR IRDMA_CQPHC_QPCTX
+
+/* Create/Modify/Destroy QP */
+
+#define IRDMA_CQPSQ_QP_NEWMSS GENMASK_ULL(45, 32)
+#define IRDMA_CQPSQ_QP_TERMLEN GENMASK_ULL(51, 48)
+
+#define IRDMA_CQPSQ_QP_QPCTX IRDMA_CQPHC_QPCTX
+
+#define IRDMA_CQPSQ_QP_QPID_S 0
+#define IRDMA_CQPSQ_QP_QPID_M (0xFFFFFFUL)
+
+#define IRDMA_CQPSQ_QP_OP_S 32
+#define IRDMA_CQPSQ_QP_OP_M IRDMACQ_OP_M
+#define IRDMA_CQPSQ_QP_ORDVALID BIT_ULL(42)
+#define IRDMA_CQPSQ_QP_TOECTXVALID BIT_ULL(43)
+#define IRDMA_CQPSQ_QP_CACHEDVARVALID BIT_ULL(44)
+#define IRDMA_CQPSQ_QP_VQ BIT_ULL(45)
+#define IRDMA_CQPSQ_QP_FORCELOOPBACK BIT_ULL(46)
+#define IRDMA_CQPSQ_QP_CQNUMVALID BIT_ULL(47)
+#define IRDMA_CQPSQ_QP_QPTYPE GENMASK_ULL(50, 48)
+#define IRDMA_CQPSQ_QP_MACVALID BIT_ULL(51)
+#define IRDMA_CQPSQ_QP_MSSCHANGE BIT_ULL(52)
+
+#define IRDMA_CQPSQ_QP_IGNOREMWBOUND BIT_ULL(54)
+#define IRDMA_CQPSQ_QP_REMOVEHASHENTRY BIT_ULL(55)
+#define IRDMA_CQPSQ_QP_TERMACT GENMASK_ULL(57, 56)
+#define IRDMA_CQPSQ_QP_RESETCON BIT_ULL(58)
+#define IRDMA_CQPSQ_QP_ARPTABIDXVALID BIT_ULL(59)
+#define IRDMA_CQPSQ_QP_NEXTIWSTATE GENMASK_ULL(62, 60)
+
+#define IRDMA_CQPSQ_QP_DBSHADOWADDR IRDMA_CQPHC_QPCTX
+
+#define IRDMA_CQPSQ_CQ_CQSIZE GENMASK_ULL(20, 0)
+#define IRDMA_CQPSQ_CQ_CQCTX GENMASK_ULL(62, 0)
+#define IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD GENMASK(17, 0)
+
+#define IRDMA_CQPSQ_CQ_OP GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_CQ_CQRESIZE BIT_ULL(43)
+#define IRDMA_CQPSQ_CQ_LPBLSIZE GENMASK_ULL(45, 44)
+#define IRDMA_CQPSQ_CQ_CHKOVERFLOW BIT_ULL(46)
+#define IRDMA_CQPSQ_CQ_VIRTMAP BIT_ULL(47)
+#define IRDMA_CQPSQ_CQ_ENCEQEMASK BIT_ULL(48)
+#define IRDMA_CQPSQ_CQ_CEQIDVALID BIT_ULL(49)
+#define IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT BIT_ULL(61)
+#define IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX GENMASK_ULL(27, 0)
+
+/* Allocate/Register/Register Shared/Deallocate Stag */
+#define IRDMA_CQPSQ_STAG_VA_FBO IRDMA_CQPHC_QPCTX
+#define IRDMA_CQPSQ_STAG_STAGLEN GENMASK_ULL(45, 0)
+#define IRDMA_CQPSQ_STAG_KEY GENMASK_ULL(7, 0)
+#define IRDMA_CQPSQ_STAG_IDX GENMASK_ULL(31, 8)
+#define IRDMA_CQPSQ_STAG_IDX_S 8
+#define IRDMA_CQPSQ_STAG_PARENTSTAGIDX GENMASK_ULL(55, 32)
+#define IRDMA_CQPSQ_STAG_MR BIT_ULL(43)
+#define IRDMA_CQPSQ_STAG_MWTYPE BIT_ULL(42)
+#define IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY BIT_ULL(58)
+
+#define IRDMA_CQPSQ_STAG_LPBLSIZE IRDMA_CQPSQ_CQ_LPBLSIZE
+#define IRDMA_CQPSQ_STAG_HPAGESIZE GENMASK_ULL(47, 46)
+#define IRDMA_CQPSQ_STAG_ARIGHTS GENMASK_ULL(52, 48)
+#define IRDMA_CQPSQ_STAG_REMACCENABLED BIT_ULL(53)
+#define IRDMA_CQPSQ_STAG_VABASEDTO BIT_ULL(59)
+#define IRDMA_CQPSQ_STAG_USEHMCFNIDX BIT_ULL(60)
+#define IRDMA_CQPSQ_STAG_USEPFRID BIT_ULL(61)
+
+#define IRDMA_CQPSQ_STAG_PBA IRDMA_CQPHC_QPCTX
+#define IRDMA_CQPSQ_STAG_HMCFNIDX GENMASK_ULL(5, 0)
+
+#define IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX GENMASK_ULL(27, 0)
+#define IRDMA_CQPSQ_QUERYSTAG_IDX IRDMA_CQPSQ_STAG_IDX
+#define IRDMA_CQPSQ_MLM_TABLEIDX GENMASK_ULL(5, 0)
+#define IRDMA_CQPSQ_MLM_FREEENTRY BIT_ULL(62)
+#define IRDMA_CQPSQ_MLM_IGNORE_REF_CNT BIT_ULL(61)
+#define IRDMA_CQPSQ_MLM_MAC0 GENMASK_ULL(7, 0)
+#define IRDMA_CQPSQ_MLM_MAC1 GENMASK_ULL(15, 8)
+#define IRDMA_CQPSQ_MLM_MAC2 GENMASK_ULL(23, 16)
+#define IRDMA_CQPSQ_MLM_MAC3 GENMASK_ULL(31, 24)
+#define IRDMA_CQPSQ_MLM_MAC4 GENMASK_ULL(39, 32)
+#define IRDMA_CQPSQ_MLM_MAC5 GENMASK_ULL(47, 40)
+#define IRDMA_CQPSQ_MAT_REACHMAX GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_MAT_MACADDR GENMASK_ULL(47, 0)
+#define IRDMA_CQPSQ_MAT_ARPENTRYIDX GENMASK_ULL(11, 0)
+#define IRDMA_CQPSQ_MAT_ENTRYVALID BIT_ULL(42)
+#define IRDMA_CQPSQ_MAT_PERMANENT BIT_ULL(43)
+#define IRDMA_CQPSQ_MAT_QUERY BIT_ULL(44)
+#define IRDMA_CQPSQ_MVPBP_PD_ENTRY_CNT GENMASK_ULL(9, 0)
+#define IRDMA_CQPSQ_MVPBP_FIRST_PD_INX GENMASK_ULL(24, 16)
+#define IRDMA_CQPSQ_MVPBP_SD_INX GENMASK_ULL(43, 32)
+#define IRDMA_CQPSQ_MVPBP_INV_PD_ENT BIT_ULL(62)
+#define IRDMA_CQPSQ_MVPBP_PD_PLPBA GENMASK_ULL(63, 3)
+
+/* Manage Push Page - MPP */
+#define IRDMA_INVALID_PUSH_PAGE_INDEX_GEN_1 0xffff
+#define IRDMA_INVALID_PUSH_PAGE_INDEX 0xffffffff
+
+#define IRDMA_CQPSQ_MPP_QS_HANDLE GENMASK_ULL(9, 0)
+#define IRDMA_CQPSQ_MPP_PPIDX GENMASK_ULL(9, 0)
+#define IRDMA_CQPSQ_MPP_PPTYPE GENMASK_ULL(61, 60)
+
+#define IRDMA_CQPSQ_MPP_FREE_PAGE BIT_ULL(62)
+
+/* Upload Context - UCTX */
+#define IRDMA_CQPSQ_UCTX_QPCTXADDR IRDMA_CQPHC_QPCTX
+#define IRDMA_CQPSQ_UCTX_QPID GENMASK_ULL(23, 0)
+#define IRDMA_CQPSQ_UCTX_QPTYPE GENMASK_ULL(51, 48)
+
+#define IRDMA_CQPSQ_UCTX_RAWFORMAT BIT_ULL(61)
+#define IRDMA_CQPSQ_UCTX_FREEZEQP BIT_ULL(62)
+
+#define IRDMA_CQPSQ_MHMC_VFIDX GENMASK_ULL(15, 0)
+#define IRDMA_CQPSQ_MHMC_FREEPMFN BIT_ULL(62)
+
+#define IRDMA_CQPSQ_SHMCRP_HMC_PROFILE GENMASK_ULL(2, 0)
+#define IRDMA_CQPSQ_SHMCRP_VFNUM GENMASK_ULL(37, 32)
+#define IRDMA_CQPSQ_CEQ_CEQSIZE GENMASK_ULL(21, 0)
+#define IRDMA_CQPSQ_CEQ_CEQID GENMASK_ULL(9, 0)
+
+#define IRDMA_CQPSQ_CEQ_LPBLSIZE IRDMA_CQPSQ_CQ_LPBLSIZE
+#define IRDMA_CQPSQ_CEQ_VMAP BIT_ULL(47)
+#define IRDMA_CQPSQ_CEQ_ITRNOEXPIRE BIT_ULL(46)
+#define IRDMA_CQPSQ_CEQ_FIRSTPMPBLIDX GENMASK_ULL(27, 0)
+#define IRDMA_CQPSQ_AEQ_AEQECNT GENMASK_ULL(18, 0)
+#define IRDMA_CQPSQ_AEQ_LPBLSIZE IRDMA_CQPSQ_CQ_LPBLSIZE
+#define IRDMA_CQPSQ_AEQ_VMAP BIT_ULL(47)
+#define IRDMA_CQPSQ_AEQ_FIRSTPMPBLIDX GENMASK_ULL(27, 0)
+
+#define IRDMA_COMMIT_FPM_QPCNT GENMASK_ULL(18, 0)
+
+#define IRDMA_COMMIT_FPM_BASE_S 32
+#define IRDMA_CQPSQ_CFPM_HMCFNID GENMASK_ULL(5, 0)
+#define IRDMA_CQPSQ_FWQE_AECODE GENMASK_ULL(15, 0)
+#define IRDMA_CQPSQ_FWQE_AESOURCE GENMASK_ULL(19, 16)
+#define IRDMA_CQPSQ_FWQE_RQMNERR GENMASK_ULL(15, 0)
+#define IRDMA_CQPSQ_FWQE_RQMJERR GENMASK_ULL(31, 16)
+#define IRDMA_CQPSQ_FWQE_SQMNERR GENMASK_ULL(47, 32)
+#define IRDMA_CQPSQ_FWQE_SQMJERR GENMASK_ULL(63, 48)
+#define IRDMA_CQPSQ_FWQE_QPID GENMASK_ULL(23, 0)
+#define IRDMA_CQPSQ_FWQE_GENERATE_AE BIT_ULL(59)
+#define IRDMA_CQPSQ_FWQE_USERFLCODE BIT_ULL(60)
+#define IRDMA_CQPSQ_FWQE_FLUSHSQ BIT_ULL(61)
+#define IRDMA_CQPSQ_FWQE_FLUSHRQ BIT_ULL(62)
+#define IRDMA_CQPSQ_MAPT_PORT GENMASK_ULL(15, 0)
+#define IRDMA_CQPSQ_MAPT_ADDPORT BIT_ULL(62)
+#define IRDMA_CQPSQ_UPESD_SDCMD GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_UPESD_SDDATALOW GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_UPESD_SDDATAHI GENMASK_ULL(63, 32)
+#define IRDMA_CQPSQ_UPESD_HMCFNID GENMASK_ULL(5, 0)
+#define IRDMA_CQPSQ_UPESD_ENTRY_VALID BIT_ULL(63)
+
+#define IRDMA_CQPSQ_UPESD_BM_PF 0
+#define IRDMA_CQPSQ_UPESD_BM_CP_LM 1
+#define IRDMA_CQPSQ_UPESD_BM_AXF 2
+#define IRDMA_CQPSQ_UPESD_BM_LM 4
+#define IRDMA_CQPSQ_UPESD_BM GENMASK_ULL(34, 32)
+#define IRDMA_CQPSQ_UPESD_ENTRY_COUNT GENMASK_ULL(3, 0)
+#define IRDMA_CQPSQ_UPESD_SKIP_ENTRY BIT_ULL(7)
+#define IRDMA_CQPSQ_SUSPENDQP_QPID GENMASK_ULL(23, 0)
+#define IRDMA_CQPSQ_RESUMEQP_QSHANDLE GENMASK_ULL(31, 0)
+#define IRDMA_CQPSQ_RESUMEQP_QPID GENMASK(23, 0)
+
+#define IRDMA_CQPSQ_MIN_STAG_INVALID 0x0001
+#define IRDMA_CQPSQ_MIN_SUSPEND_PND 0x0005
+
+#define IRDMA_CQPSQ_MAJ_NO_ERROR 0x0000
+#define IRDMA_CQPSQ_MAJ_OBJCACHE_ERROR 0xF000
+#define IRDMA_CQPSQ_MAJ_CNTXTCACHE_ERROR 0xF001
+#define IRDMA_CQPSQ_MAJ_ERROR 0xFFFF
+#define IRDMAQPC_DDP_VER GENMASK_ULL(1, 0)
+#define IRDMAQPC_IBRDENABLE BIT_ULL(2)
+#define IRDMAQPC_IPV4 BIT_ULL(3)
+#define IRDMAQPC_NONAGLE BIT_ULL(4)
+#define IRDMAQPC_INSERTVLANTAG BIT_ULL(5)
+#define IRDMAQPC_ISQP1 BIT_ULL(6)
+#define IRDMAQPC_TIMESTAMP BIT_ULL(7)
+#define IRDMAQPC_RQWQESIZE GENMASK_ULL(9, 8)
+#define IRDMAQPC_INSERTL2TAG2 BIT_ULL(11)
+#define IRDMAQPC_LIMIT GENMASK_ULL(13, 12)
+
+#define IRDMAQPC_ECN_EN BIT_ULL(14)
+#define IRDMAQPC_DROPOOOSEG BIT_ULL(15)
+#define IRDMAQPC_DUPACK_THRESH GENMASK_ULL(18, 16)
+#define IRDMAQPC_ERR_RQ_IDX_VALID BIT_ULL(19)
+#define IRDMAQPC_DIS_VLAN_CHECKS GENMASK_ULL(21, 19)
+#define IRDMAQPC_DC_TCP_EN BIT_ULL(25)
+#define IRDMAQPC_RCVTPHEN BIT_ULL(28)
+#define IRDMAQPC_XMITTPHEN BIT_ULL(29)
+#define IRDMAQPC_RQTPHEN BIT_ULL(30)
+#define IRDMAQPC_SQTPHEN BIT_ULL(31)
+#define IRDMAQPC_PPIDX GENMASK_ULL(41, 32)
+#define IRDMAQPC_PMENA BIT_ULL(47)
+#define IRDMAQPC_RDMAP_VER GENMASK_ULL(63, 62)
+#define IRDMAQPC_ROCE_TVER GENMASK_ULL(63, 60)
+
+#define IRDMAQPC_SQADDR IRDMA_CQPHC_QPCTX
+#define IRDMAQPC_RQADDR IRDMA_CQPHC_QPCTX
+#define IRDMAQPC_TTL GENMASK_ULL(7, 0)
+#define IRDMAQPC_RQSIZE GENMASK_ULL(11, 8)
+#define IRDMAQPC_SQSIZE GENMASK_ULL(15, 12)
+#define IRDMAQPC_GEN1_SRCMACADDRIDX GENMASK(21, 16)
+#define IRDMAQPC_AVOIDSTRETCHACK BIT_ULL(23)
+#define IRDMAQPC_TOS GENMASK_ULL(31, 24)
+#define IRDMAQPC_SRCPORTNUM GENMASK_ULL(47, 32)
+#define IRDMAQPC_DESTPORTNUM GENMASK_ULL(63, 48)
+#define IRDMAQPC_DESTIPADDR0 GENMASK_ULL(63, 32)
+#define IRDMAQPC_DESTIPADDR1 GENMASK_ULL(31, 0)
+#define IRDMAQPC_DESTIPADDR2 GENMASK_ULL(63, 32)
+#define IRDMAQPC_DESTIPADDR3 GENMASK_ULL(31, 0)
+#define IRDMAQPC_SNDMSS GENMASK_ULL(29, 16)
+#define IRDMAQPC_SYN_RST_HANDLING GENMASK_ULL(31, 30)
+#define IRDMAQPC_VLANTAG GENMASK_ULL(47, 32)
+#define IRDMAQPC_ARPIDX GENMASK_ULL(63, 48)
+#define IRDMAQPC_FLOWLABEL GENMASK_ULL(19, 0)
+#define IRDMAQPC_WSCALE BIT_ULL(20)
+#define IRDMAQPC_KEEPALIVE BIT_ULL(21)
+#define IRDMAQPC_IGNORE_TCP_OPT BIT_ULL(22)
+#define IRDMAQPC_IGNORE_TCP_UNS_OPT BIT_ULL(23)
+#define IRDMAQPC_TCPSTATE GENMASK_ULL(31, 28)
+#define IRDMAQPC_RCVSCALE GENMASK_ULL(35, 32)
+#define IRDMAQPC_SNDSCALE GENMASK_ULL(43, 40)
+#define IRDMAQPC_PDIDX GENMASK_ULL(63, 48)
+#define IRDMAQPC_PDIDXHI GENMASK_ULL(21, 20)
+#define IRDMAQPC_PKEY GENMASK_ULL(47, 32)
+#define IRDMAQPC_ACKCREDITS GENMASK_ULL(24, 20)
+#define IRDMAQPC_QKEY GENMASK_ULL(63, 32)
+#define IRDMAQPC_DESTQP GENMASK_ULL(23, 0)
+#define IRDMAQPC_KALIVE_TIMER_MAX_PROBES GENMASK_ULL(23, 16)
+#define IRDMAQPC_KEEPALIVE_INTERVAL GENMASK_ULL(31, 24)
+#define IRDMAQPC_TIMESTAMP_RECENT GENMASK_ULL(31, 0)
+#define IRDMAQPC_TIMESTAMP_AGE GENMASK_ULL(63, 32)
+#define IRDMAQPC_SNDNXT GENMASK_ULL(31, 0)
+#define IRDMAQPC_ISN GENMASK_ULL(55, 32)
+#define IRDMAQPC_PSNNXT GENMASK_ULL(23, 0)
+#define IRDMAQPC_LSN GENMASK_ULL(55, 32)
+#define IRDMAQPC_SNDWND GENMASK_ULL(63, 32)
+#define IRDMAQPC_RCVNXT GENMASK_ULL(31, 0)
+#define IRDMAQPC_EPSN GENMASK_ULL(23, 0)
+#define IRDMAQPC_RCVWND GENMASK_ULL(63, 32)
+#define IRDMAQPC_SNDMAX GENMASK_ULL(31, 0)
+#define IRDMAQPC_SNDUNA GENMASK_ULL(63, 32)
+#define IRDMAQPC_PSNMAX GENMASK_ULL(23, 0)
+#define IRDMAQPC_PSNUNA GENMASK_ULL(55, 32)
+#define IRDMAQPC_SRTT GENMASK_ULL(31, 0)
+#define IRDMAQPC_RTTVAR GENMASK_ULL(63, 32)
+#define IRDMAQPC_SSTHRESH GENMASK_ULL(31, 0)
+#define IRDMAQPC_CWND GENMASK_ULL(63, 32)
+#define IRDMAQPC_CWNDROCE GENMASK_ULL(55, 32)
+#define IRDMAQPC_SNDWL1 GENMASK_ULL(31, 0)
+#define IRDMAQPC_SNDWL2 GENMASK_ULL(63, 32)
+#define IRDMAQPC_ERR_RQ_IDX GENMASK_ULL(45, 32)
+#define IRDMAQPC_RTOMIN GENMASK_ULL(63, 57)
+#define IRDMAQPC_MAXSNDWND GENMASK_ULL(31, 0)
+#define IRDMAQPC_REXMIT_THRESH GENMASK_ULL(53, 48)
+#define IRDMAQPC_RNRNAK_THRESH GENMASK_ULL(56, 54)
+#define IRDMAQPC_TXCQNUM GENMASK_ULL(18, 0)
+#define IRDMAQPC_RXCQNUM GENMASK_ULL(50, 32)
+#define IRDMAQPC_STAT_INDEX GENMASK_ULL(6, 0)
+#define IRDMAQPC_Q2ADDR GENMASK_ULL(63, 8)
+#define IRDMAQPC_LASTBYTESENT GENMASK_ULL(7, 0)
+#define IRDMAQPC_MACADDRESS GENMASK_ULL(63, 16)
+#define IRDMAQPC_ORDSIZE GENMASK_ULL(7, 0)
+
+#define IRDMAQPC_IRDSIZE GENMASK_ULL(18, 16)
+
+#define IRDMAQPC_UDPRIVCQENABLE BIT_ULL(19)
+#define IRDMAQPC_WRRDRSPOK BIT_ULL(20)
+#define IRDMAQPC_RDOK BIT_ULL(21)
+#define IRDMAQPC_SNDMARKERS BIT_ULL(22)
+#define IRDMAQPC_DCQCNENABLE BIT_ULL(22)
+#define IRDMAQPC_FW_CC_ENABLE BIT_ULL(28)
+#define IRDMAQPC_RCVNOICRC BIT_ULL(31)
+#define IRDMAQPC_BINDEN BIT_ULL(23)
+#define IRDMAQPC_FASTREGEN BIT_ULL(24)
+#define IRDMAQPC_PRIVEN BIT_ULL(25)
+#define IRDMAQPC_TIMELYENABLE BIT_ULL(27)
+#define IRDMAQPC_THIGH GENMASK_ULL(63, 52)
+#define IRDMAQPC_TLOW GENMASK_ULL(39, 32)
+#define IRDMAQPC_REMENDPOINTIDX GENMASK_ULL(16, 0)
+#define IRDMAQPC_USESTATSINSTANCE BIT_ULL(26)
+#define IRDMAQPC_IWARPMODE BIT_ULL(28)
+#define IRDMAQPC_RCVMARKERS BIT_ULL(29)
+#define IRDMAQPC_ALIGNHDRS BIT_ULL(30)
+#define IRDMAQPC_RCVNOMPACRC BIT_ULL(31)
+#define IRDMAQPC_RCVMARKOFFSET GENMASK_ULL(40, 32)
+#define IRDMAQPC_SNDMARKOFFSET GENMASK_ULL(56, 48)
+
+#define IRDMAQPC_QPCOMPCTX IRDMA_CQPHC_QPCTX
+#define IRDMAQPC_SQTPHVAL GENMASK_ULL(7, 0)
+#define IRDMAQPC_RQTPHVAL GENMASK_ULL(15, 8)
+#define IRDMAQPC_QSHANDLE GENMASK_ULL(25, 16)
+#define IRDMAQPC_EXCEPTION_LAN_QUEUE GENMASK_ULL(43, 32)
+#define IRDMAQPC_LOCAL_IPADDR3 GENMASK_ULL(31, 0)
+#define IRDMAQPC_LOCAL_IPADDR2 GENMASK_ULL(63, 32)
+#define IRDMAQPC_LOCAL_IPADDR1 GENMASK_ULL(31, 0)
+#define IRDMAQPC_LOCAL_IPADDR0 GENMASK_ULL(63, 32)
+#define IRDMA_FW_VER_MINOR GENMASK_ULL(15, 0)
+#define IRDMA_FW_VER_MAJOR GENMASK_ULL(31, 16)
+#define IRDMA_FEATURE_INFO GENMASK_ULL(47, 0)
+#define IRDMA_FEATURE_CNT GENMASK_ULL(47, 32)
+#define IRDMA_FEATURE_TYPE GENMASK_ULL(63, 48)
+
+#define IRDMAQPSQ_OPCODE GENMASK_ULL(37, 32)
+#define IRDMAQPSQ_COPY_HOST_PBL BIT_ULL(43)
+#define IRDMAQPSQ_ADDFRAGCNT GENMASK_ULL(41, 38)
+#define IRDMAQPSQ_PUSHWQE BIT_ULL(56)
+#define IRDMAQPSQ_STREAMMODE BIT_ULL(58)
+#define IRDMAQPSQ_WAITFORRCVPDU BIT_ULL(59)
+#define IRDMAQPSQ_READFENCE BIT_ULL(60)
+#define IRDMAQPSQ_LOCALFENCE BIT_ULL(61)
+#define IRDMAQPSQ_UDPHEADER BIT_ULL(61)
+#define IRDMAQPSQ_L4LEN GENMASK_ULL(45, 42)
+#define IRDMAQPSQ_SIGCOMPL BIT_ULL(62)
+#define IRDMAQPSQ_VALID BIT_ULL(63)
+
+#define IRDMAQPSQ_FRAG_TO IRDMA_CQPHC_QPCTX
+#define IRDMAQPSQ_FRAG_VALID BIT_ULL(63)
+#define IRDMAQPSQ_FRAG_LEN GENMASK_ULL(62, 32)
+#define IRDMAQPSQ_FRAG_STAG GENMASK_ULL(31, 0)
+#define IRDMAQPSQ_GEN1_FRAG_LEN GENMASK_ULL(31, 0)
+#define IRDMAQPSQ_GEN1_FRAG_STAG GENMASK_ULL(63, 32)
+#define IRDMAQPSQ_REMSTAGINV GENMASK_ULL(31, 0)
+#define IRDMAQPSQ_DESTQKEY GENMASK_ULL(31, 0)
+#define IRDMAQPSQ_DESTQPN GENMASK_ULL(55, 32)
+#define IRDMAQPSQ_AHID GENMASK_ULL(16, 0)
+#define IRDMAQPSQ_INLINEDATAFLAG BIT_ULL(57)
+
+#define IRDMA_INLINE_VALID_S 7
+#define IRDMAQPSQ_INLINEDATALEN GENMASK_ULL(55, 48)
+#define IRDMAQPSQ_IMMDATAFLAG BIT_ULL(47)
+#define IRDMAQPSQ_REPORTRTT BIT_ULL(46)
+
+#define IRDMAQPSQ_IMMDATA GENMASK_ULL(63, 0)
+#define IRDMAQPSQ_REMSTAG GENMASK_ULL(31, 0)
+
+#define IRDMAQPSQ_REMTO IRDMA_CQPHC_QPCTX
+
+#define IRDMAQPSQ_STAGRIGHTS GENMASK_ULL(52, 48)
+#define IRDMAQPSQ_VABASEDTO BIT_ULL(53)
+#define IRDMAQPSQ_MEMWINDOWTYPE BIT_ULL(54)
+
+#define IRDMAQPSQ_MWLEN IRDMA_CQPHC_QPCTX
+#define IRDMAQPSQ_PARENTMRSTAG GENMASK_ULL(63, 32)
+#define IRDMAQPSQ_MWSTAG GENMASK_ULL(31, 0)
+
+#define IRDMAQPSQ_BASEVA_TO_FBO IRDMA_CQPHC_QPCTX
+
+#define IRDMAQPSQ_LOCSTAG GENMASK_ULL(31, 0)
+
+#define IRDMAQPSQ_STAGKEY GENMASK_ULL(7, 0)
+#define IRDMAQPSQ_STAGINDEX GENMASK_ULL(31, 8)
+#define IRDMAQPSQ_COPYHOSTPBLS BIT_ULL(43)
+#define IRDMAQPSQ_LPBLSIZE GENMASK_ULL(45, 44)
+#define IRDMAQPSQ_HPAGESIZE GENMASK_ULL(47, 46)
+#define IRDMAQPSQ_STAGLEN GENMASK_ULL(40, 0)
+#define IRDMAQPSQ_FIRSTPMPBLIDXLO GENMASK_ULL(63, 48)
+#define IRDMAQPSQ_FIRSTPMPBLIDXHI GENMASK_ULL(11, 0)
+#define IRDMAQPSQ_PBLADDR GENMASK_ULL(63, 12)
+
+/* iwarp QP RQ WQE common fields */
+#define IRDMAQPRQ_ADDFRAGCNT IRDMAQPSQ_ADDFRAGCNT
+#define IRDMAQPRQ_VALID IRDMAQPSQ_VALID
+#define IRDMAQPRQ_COMPLCTX IRDMA_CQPHC_QPCTX
+#define IRDMAQPRQ_FRAG_LEN IRDMAQPSQ_FRAG_LEN
+#define IRDMAQPRQ_STAG IRDMAQPSQ_FRAG_STAG
+#define IRDMAQPRQ_TO IRDMAQPSQ_FRAG_TO
+
+#define IRDMAPFINT_OICR_HMC_ERR_M BIT(26)
+#define IRDMAPFINT_OICR_PE_PUSH_M BIT(27)
+#define IRDMAPFINT_OICR_PE_CRITERR_M BIT(28)
+
+#define IRDMA_QUERY_FPM_MAX_QPS GENMASK_ULL(18, 0)
+#define IRDMA_QUERY_FPM_MAX_CQS GENMASK_ULL(19, 0)
+#define IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX GENMASK_ULL(13, 0)
+#define IRDMA_QUERY_FPM_MAX_PE_SDS GENMASK_ULL(45, 32)
+#define IRDMA_QUERY_FPM_MAX_CEQS GENMASK_ULL(9, 0)
+#define IRDMA_QUERY_FPM_XFBLOCKSIZE GENMASK_ULL(63, 32)
+#define IRDMA_QUERY_FPM_Q1BLOCKSIZE GENMASK_ULL(63, 32)
+#define IRDMA_QUERY_FPM_HTMULTIPLIER GENMASK_ULL(19, 16)
+#define IRDMA_QUERY_FPM_TIMERBUCKET GENMASK_ULL(47, 32)
+#define IRDMA_QUERY_FPM_RRFBLOCKSIZE GENMASK_ULL(63, 32)
+#define IRDMA_QUERY_FPM_RRFFLBLOCKSIZE GENMASK_ULL(63, 32)
+#define IRDMA_QUERY_FPM_OOISCFBLOCKSIZE GENMASK_ULL(63, 32)
+#define IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID GENMASK_ULL(5, 0)
+
+#define IRDMA_GET_CURRENT_AEQ_ELEM(_aeq) \
+	( \
+		(_aeq)->aeqe_base[IRDMA_RING_CURRENT_TAIL((_aeq)->aeq_ring)].buf \
+	)
+
+#define IRDMA_GET_CURRENT_CEQ_ELEM(_ceq) \
+	( \
+		(_ceq)->ceqe_base[IRDMA_RING_CURRENT_TAIL((_ceq)->ceq_ring)].buf \
+	)
+
+#define IRDMA_GET_CEQ_ELEM_AT_POS(_ceq, _pos) \
+	( \
+		(_ceq)->ceqe_base[_pos].buf  \
+	)
+
+#define IRDMA_RING_GET_NEXT_TAIL(_ring, _idx) \
+	( \
+		((_ring).tail + (_idx)) % (_ring).size \
+	)
+
+#define IRDMA_CQP_INIT_WQE(wqe) memset(wqe, 0, 64)
+
+#define IRDMA_GET_CURRENT_CQ_ELEM(_cq) \
+	( \
+		(_cq)->cq_base[IRDMA_RING_CURRENT_HEAD((_cq)->cq_ring)].buf  \
+	)
+#define IRDMA_GET_CURRENT_EXTENDED_CQ_ELEM(_cq) \
+	( \
+		((struct irdma_extended_cqe *) \
+		((_cq)->cq_base))[IRDMA_RING_CURRENT_HEAD((_cq)->cq_ring)].buf \
+	)
+
+#define IRDMA_RING_INIT(_ring, _size) \
+	{ \
+		(_ring).head = 0; \
+		(_ring).tail = 0; \
+		(_ring).size = (_size); \
+	}
+#define IRDMA_RING_SIZE(_ring) ((_ring).size)
+#define IRDMA_RING_CURRENT_HEAD(_ring) ((_ring).head)
+#define IRDMA_RING_CURRENT_TAIL(_ring) ((_ring).tail)
+
+#define IRDMA_RING_MOVE_HEAD(_ring, _retcode) \
+	{ \
+		register u32 size; \
+		size = (_ring).size;  \
+		if (!IRDMA_RING_FULL_ERR(_ring)) { \
+			(_ring).head = ((_ring).head + 1) % size; \
+			(_retcode) = 0; \
+		} else { \
+			(_retcode) = IRDMA_ERR_RING_FULL; \
+		} \
+	}
+#define IRDMA_RING_MOVE_HEAD_BY_COUNT(_ring, _count, _retcode) \
+	{ \
+		register u32 size; \
+		size = (_ring).size; \
+		if ((IRDMA_RING_USED_QUANTA(_ring) + (_count)) < size) { \
+			(_ring).head = ((_ring).head + (_count)) % size; \
+			(_retcode) = 0; \
+		} else { \
+			(_retcode) = IRDMA_ERR_RING_FULL; \
+		} \
+	}
+#define IRDMA_SQ_RING_MOVE_HEAD(_ring, _retcode) \
+	{ \
+		register u32 size; \
+		size = (_ring).size;  \
+		if (!IRDMA_SQ_RING_FULL_ERR(_ring)) { \
+			(_ring).head = ((_ring).head + 1) % size; \
+			(_retcode) = 0; \
+		} else { \
+			(_retcode) = IRDMA_ERR_RING_FULL; \
+		} \
+	}
+#define IRDMA_SQ_RING_MOVE_HEAD_BY_COUNT(_ring, _count, _retcode) \
+	{ \
+		register u32 size; \
+		size = (_ring).size; \
+		if ((IRDMA_RING_USED_QUANTA(_ring) + (_count)) < (size - 256)) { \
+			(_ring).head = ((_ring).head + (_count)) % size; \
+			(_retcode) = 0; \
+		} else { \
+			(_retcode) = IRDMA_ERR_RING_FULL; \
+		} \
+	}
+#define IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(_ring, _count) \
+	(_ring).head = ((_ring).head + (_count)) % (_ring).size
+
+#define IRDMA_RING_MOVE_TAIL(_ring) \
+	(_ring).tail = ((_ring).tail + 1) % (_ring).size
+
+#define IRDMA_RING_MOVE_HEAD_NOCHECK(_ring) \
+	(_ring).head = ((_ring).head + 1) % (_ring).size
+
+#define IRDMA_RING_MOVE_TAIL_BY_COUNT(_ring, _count) \
+	(_ring).tail = ((_ring).tail + (_count)) % (_ring).size
+
+#define IRDMA_RING_SET_TAIL(_ring, _pos) \
+	(_ring).tail = (_pos) % (_ring).size
+
+#define IRDMA_RING_FULL_ERR(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 1))  \
+	)
+
+#define IRDMA_ERR_RING_FULL2(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 2))  \
+	)
+
+#define IRDMA_ERR_RING_FULL3(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 3))  \
+	)
+
+#define IRDMA_SQ_RING_FULL_ERR(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 257))  \
+	)
+
+#define IRDMA_ERR_SQ_RING_FULL2(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 258))  \
+	)
+#define IRDMA_ERR_SQ_RING_FULL3(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) == ((_ring).size - 259))  \
+	)
+#define IRDMA_RING_MORE_WORK(_ring) \
+	( \
+		(IRDMA_RING_USED_QUANTA(_ring) != 0) \
+	)
+
+#define IRDMA_RING_USED_QUANTA(_ring) \
+	( \
+		(((_ring).head + (_ring).size - (_ring).tail) % (_ring).size) \
+	)
+
+#define IRDMA_RING_FREE_QUANTA(_ring) \
+	( \
+		((_ring).size - IRDMA_RING_USED_QUANTA(_ring) - 1) \
+	)
+
+#define IRDMA_SQ_RING_FREE_QUANTA(_ring) \
+	( \
+		((_ring).size - IRDMA_RING_USED_QUANTA(_ring) - 257) \
+	)
+
+#define IRDMA_ATOMIC_RING_MOVE_HEAD(_ring, index, _retcode) \
+	{ \
+		index = IRDMA_RING_CURRENT_HEAD(_ring); \
+		IRDMA_RING_MOVE_HEAD(_ring, _retcode); \
+	}
+
+enum irdma_qp_wqe_size {
+	IRDMA_WQE_SIZE_32  = 32,
+	IRDMA_WQE_SIZE_64  = 64,
+	IRDMA_WQE_SIZE_96  = 96,
+	IRDMA_WQE_SIZE_128 = 128,
+	IRDMA_WQE_SIZE_256 = 256,
+};
+
+enum irdma_ws_node_op {
+	IRDMA_ADD_NODE = 0,
+	IRDMA_MODIFY_NODE,
+	IRDMA_DEL_NODE,
+};
+
+enum {	IRDMA_Q_ALIGNMENT_M		 = (128 - 1),
+	IRDMA_AEQ_ALIGNMENT_M		 = (256 - 1),
+	IRDMA_Q2_ALIGNMENT_M		 = (256 - 1),
+	IRDMA_CEQ_ALIGNMENT_M		 = (256 - 1),
+	IRDMA_CQ0_ALIGNMENT_M		 = (256 - 1),
+	IRDMA_HOST_CTX_ALIGNMENT_M	 = (4 - 1),
+	IRDMA_SHADOWAREA_M		 = (128 - 1),
+	IRDMA_FPM_QUERY_BUF_ALIGNMENT_M	 = (4 - 1),
+	IRDMA_FPM_COMMIT_BUF_ALIGNMENT_M = (4 - 1),
+};
+
+enum irdma_alignment {
+	IRDMA_CQP_ALIGNMENT	    = 0x200,
+	IRDMA_AEQ_ALIGNMENT	    = 0x100,
+	IRDMA_CEQ_ALIGNMENT	    = 0x100,
+	IRDMA_CQ0_ALIGNMENT	    = 0x100,
+	IRDMA_SD_BUF_ALIGNMENT      = 0x80,
+	IRDMA_FEATURE_BUF_ALIGNMENT = 0x8,
+};
+
+enum icrdma_protocol_used {
+	ICRDMA_ANY_PROTOCOL	   = 0,
+	ICRDMA_IWARP_PROTOCOL_ONLY = 1,
+	ICRDMA_ROCE_PROTOCOL_ONLY  = 2,
+};
+
+/**
+ * set_64bit_val - set 64 bit value to hw wqe
+ * @wqe_words: wqe addr to write
+ * @byte_index: index in wqe
+ * @val: value to write
+ **/
+static inline void set_64bit_val(__le64 *wqe_words, u32 byte_index, u64 val)
+{
+	wqe_words[byte_index >> 3] = cpu_to_le64(val);
+}
+
+/**
+ * set_32bit_val - set 32 bit value to hw wqe
+ * @wqe_words: wqe addr to write
+ * @byte_index: index in wqe
+ * @val: value to write
+ **/
+static inline void set_32bit_val(__le32 *wqe_words, u32 byte_index, u32 val)
+{
+	wqe_words[byte_index >> 2] = cpu_to_le32(val);
+}
+
+/**
+ * get_64bit_val - read 64 bit value from wqe
+ * @wqe_words: wqe addr
+ * @byte_index: index to read from
+ * @val: read value
+ **/
+static inline void get_64bit_val(__le64 *wqe_words, u32 byte_index, u64 *val)
+{
+	*val = le64_to_cpu(wqe_words[byte_index >> 3]);
+}
+
+/**
+ * get_32bit_val - read 32 bit value from wqe
+ * @wqe_words: wqe addr
+ * @byte_index: index to reaad from
+ * @val: return 32 bit value
+ **/
+static inline void get_32bit_val(__le32 *wqe_words, u32 byte_index, u32 *val)
+{
+	*val = le32_to_cpu(wqe_words[byte_index >> 2]);
+}
+#endif /* IRDMA_DEFS_H */
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
new file mode 100644
index 0000000..46c1233
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2017 - 2021 Intel Corporation */
+#ifndef IRDMA_H
+#define IRDMA_H
+
+#define IRDMA_WQEALLOC_WQE_DESC_INDEX GENMASK(31, 20)
+
+#define IRDMA_CQPTAIL_WQTAIL GENMASK(10, 0)
+#define IRDMA_CQPTAIL_CQP_OP_ERR BIT(31)
+
+#define IRDMA_CQPERRCODES_CQP_MINOR_CODE GENMASK(15, 0)
+#define IRDMA_CQPERRCODES_CQP_MAJOR_CODE GENMASK(31, 16)
+#define IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE GENMASK(5, 4)
+#define IRDMA_GLINT_RATE_INTERVAL GENMASK(5, 0)
+#define IRDMA_GLINT_RATE_INTRL_ENA BIT(6)
+#define IRDMA_GLINT_DYN_CTL_INTENA BIT(0)
+#define IRDMA_GLINT_DYN_CTL_CLEARPBA BIT(1)
+#define IRDMA_GLINT_DYN_CTL_ITR_INDX GENMASK(4, 3)
+#define IRDMA_GLINT_DYN_CTL_INTERVAL GENMASK(16, 5)
+#define IRDMA_GLINT_CEQCTL_ITR_INDX GENMASK(12, 11)
+#define IRDMA_GLINT_CEQCTL_CAUSE_ENA BIT(30)
+#define IRDMA_GLINT_CEQCTL_MSIX_INDX GENMASK(10, 0)
+#define IRDMA_PFINT_AEQCTL_MSIX_INDX GENMASK(10, 0)
+#define IRDMA_PFINT_AEQCTL_ITR_INDX GENMASK(12, 11)
+#define IRDMA_PFINT_AEQCTL_CAUSE_ENA BIT(30)
+#define IRDMA_PFHMC_PDINV_PMSDIDX GENMASK(11, 0)
+#define IRDMA_PFHMC_PDINV_PMSDPARTSEL BIT(15)
+#define IRDMA_PFHMC_PDINV_PMPDIDX GENMASK(24, 16)
+#define IRDMA_PFHMC_SDDATALOW_PMSDVALID BIT(0)
+#define IRDMA_PFHMC_SDDATALOW_PMSDTYPE BIT(1)
+#define IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT GENMASK(11, 2)
+#define IRDMA_PFHMC_SDDATALOW_PMSDDATALOW GENMASK(31, 12)
+#define IRDMA_PFHMC_SDCMD_PMSDWR BIT(31)
+
+#define IRDMA_INVALID_CQ_IDX			0xffffffff
+enum irdma_registers {
+	IRDMA_CQPTAIL,
+	IRDMA_CQPDB,
+	IRDMA_CCQPSTATUS,
+	IRDMA_CCQPHIGH,
+	IRDMA_CCQPLOW,
+	IRDMA_CQARM,
+	IRDMA_CQACK,
+	IRDMA_AEQALLOC,
+	IRDMA_CQPERRCODES,
+	IRDMA_WQEALLOC,
+	IRDMA_GLINT_DYN_CTL,
+	IRDMA_DB_ADDR_OFFSET,
+	IRDMA_GLPCI_LBARCTRL,
+	IRDMA_GLPE_CPUSTATUS0,
+	IRDMA_GLPE_CPUSTATUS1,
+	IRDMA_GLPE_CPUSTATUS2,
+	IRDMA_PFINT_AEQCTL,
+	IRDMA_GLINT_CEQCTL,
+	IRDMA_VSIQF_PE_CTL1,
+	IRDMA_PFHMC_PDINV,
+	IRDMA_GLHMC_VFPDINV,
+	IRDMA_GLPE_CRITERR,
+	IRDMA_GLINT_RATE,
+	IRDMA_MAX_REGS, /* Must be last entry */
+};
+
+enum irdma_shifts {
+	IRDMA_CCQPSTATUS_CCQP_DONE_S,
+	IRDMA_CCQPSTATUS_CCQP_ERR_S,
+	IRDMA_CQPSQ_STAG_PDID_S,
+	IRDMA_CQPSQ_CQ_CEQID_S,
+	IRDMA_CQPSQ_CQ_CQID_S,
+	IRDMA_COMMIT_FPM_CQCNT_S,
+	IRDMA_MAX_SHIFTS,
+};
+
+enum irdma_masks {
+	IRDMA_CCQPSTATUS_CCQP_DONE_M,
+	IRDMA_CCQPSTATUS_CCQP_ERR_M,
+	IRDMA_CQPSQ_STAG_PDID_M,
+	IRDMA_CQPSQ_CQ_CEQID_M,
+	IRDMA_CQPSQ_CQ_CQID_M,
+	IRDMA_COMMIT_FPM_CQCNT_M,
+	IRDMA_MAX_MASKS, /* Must be last entry */
+};
+
+#define IRDMA_MAX_MGS_PER_CTX	8
+
+struct irdma_mcast_grp_ctx_entry_info {
+	u32 qp_id;
+	bool valid_entry;
+	u16 dest_port;
+	u32 use_cnt;
+};
+
+struct irdma_mcast_grp_info {
+	u8 dest_mac_addr[ETH_ALEN];
+	u16 vlan_id;
+	u8 hmc_fcn_id;
+	bool ipv4_valid:1;
+	bool vlan_valid:1;
+	u16 mg_id;
+	u32 no_of_mgs;
+	u32 dest_ip_addr[4];
+	u16 qs_handle;
+	struct irdma_dma_mem dma_mem_mc;
+	struct irdma_mcast_grp_ctx_entry_info mg_ctx_info[IRDMA_MAX_MGS_PER_CTX];
+};
+
+enum irdma_vers {
+	IRDMA_GEN_RSVD,
+	IRDMA_GEN_1,
+	IRDMA_GEN_2,
+};
+
+struct irdma_uk_attrs {
+	u64 feature_flags;
+	u32 max_hw_wq_frags;
+	u32 max_hw_read_sges;
+	u32 max_hw_inline;
+	u32 max_hw_rq_quanta;
+	u32 max_hw_wq_quanta;
+	u32 min_hw_cq_size;
+	u32 max_hw_cq_size;
+	u16 max_hw_sq_chunk;
+	u8 hw_rev;
+};
+
+struct irdma_hw_attrs {
+	struct irdma_uk_attrs uk_attrs;
+	u64 max_hw_outbound_msg_size;
+	u64 max_hw_inbound_msg_size;
+	u64 max_mr_size;
+	u32 min_hw_qp_id;
+	u32 min_hw_aeq_size;
+	u32 max_hw_aeq_size;
+	u32 min_hw_ceq_size;
+	u32 max_hw_ceq_size;
+	u32 max_hw_device_pages;
+	u32 max_hw_vf_fpm_id;
+	u32 first_hw_vf_fpm_id;
+	u32 max_hw_ird;
+	u32 max_hw_ord;
+	u32 max_hw_wqes;
+	u32 max_hw_pds;
+	u32 max_hw_ena_vf_count;
+	u32 max_qp_wr;
+	u32 max_pe_ready_count;
+	u32 max_done_count;
+	u32 max_sleep_count;
+	u32 max_cqp_compl_wait_time_ms;
+	u16 max_stat_inst;
+};
+
+void i40iw_init_hw(struct irdma_sc_dev *dev);
+void icrdma_init_hw(struct irdma_sc_dev *dev);
+#endif /* IRDMA_H*/
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
new file mode 100644
index 0000000..7387b83
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -0,0 +1,1541 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#ifndef IRDMA_TYPE_H
+#define IRDMA_TYPE_H
+#include "status.h"
+#include "osdep.h"
+#include "irdma.h"
+#include "user.h"
+#include "hmc.h"
+#include "uda.h"
+#include "ws.h"
+#define IRDMA_DEBUG_ERR		"ERR"
+#define IRDMA_DEBUG_INIT	"INIT"
+#define IRDMA_DEBUG_DEV		"DEV"
+#define IRDMA_DEBUG_CM		"CM"
+#define IRDMA_DEBUG_VERBS	"VERBS"
+#define IRDMA_DEBUG_PUDA	"PUDA"
+#define IRDMA_DEBUG_ILQ		"ILQ"
+#define IRDMA_DEBUG_IEQ		"IEQ"
+#define IRDMA_DEBUG_QP		"QP"
+#define IRDMA_DEBUG_CQ		"CQ"
+#define IRDMA_DEBUG_MR		"MR"
+#define IRDMA_DEBUG_PBLE	"PBLE"
+#define IRDMA_DEBUG_WQE		"WQE"
+#define IRDMA_DEBUG_AEQ		"AEQ"
+#define IRDMA_DEBUG_CQP		"CQP"
+#define IRDMA_DEBUG_HMC		"HMC"
+#define IRDMA_DEBUG_USER	"USER"
+#define IRDMA_DEBUG_VIRT	"VIRT"
+#define IRDMA_DEBUG_DCB		"DCB"
+#define	IRDMA_DEBUG_CQE		"CQE"
+#define IRDMA_DEBUG_CLNT	"CLNT"
+#define IRDMA_DEBUG_WS		"WS"
+#define IRDMA_DEBUG_STATS	"STATS"
+
+enum irdma_page_size {
+	IRDMA_PAGE_SIZE_4K = 0,
+	IRDMA_PAGE_SIZE_2M,
+	IRDMA_PAGE_SIZE_1G,
+};
+
+enum irdma_hdrct_flags {
+	DDP_LEN_FLAG  = 0x80,
+	DDP_HDR_FLAG  = 0x40,
+	RDMA_HDR_FLAG = 0x20,
+};
+
+enum irdma_term_layers {
+	LAYER_RDMA = 0,
+	LAYER_DDP  = 1,
+	LAYER_MPA  = 2,
+};
+
+enum irdma_term_error_types {
+	RDMAP_REMOTE_PROT = 1,
+	RDMAP_REMOTE_OP   = 2,
+	DDP_CATASTROPHIC  = 0,
+	DDP_TAGGED_BUF    = 1,
+	DDP_UNTAGGED_BUF  = 2,
+	DDP_LLP		  = 3,
+};
+
+enum irdma_term_rdma_errors {
+	RDMAP_INV_STAG		  = 0x00,
+	RDMAP_INV_BOUNDS	  = 0x01,
+	RDMAP_ACCESS		  = 0x02,
+	RDMAP_UNASSOC_STAG	  = 0x03,
+	RDMAP_TO_WRAP		  = 0x04,
+	RDMAP_INV_RDMAP_VER       = 0x05,
+	RDMAP_UNEXPECTED_OP       = 0x06,
+	RDMAP_CATASTROPHIC_LOCAL  = 0x07,
+	RDMAP_CATASTROPHIC_GLOBAL = 0x08,
+	RDMAP_CANT_INV_STAG       = 0x09,
+	RDMAP_UNSPECIFIED	  = 0xff,
+};
+
+enum irdma_term_ddp_errors {
+	DDP_CATASTROPHIC_LOCAL      = 0x00,
+	DDP_TAGGED_INV_STAG	    = 0x00,
+	DDP_TAGGED_BOUNDS	    = 0x01,
+	DDP_TAGGED_UNASSOC_STAG     = 0x02,
+	DDP_TAGGED_TO_WRAP	    = 0x03,
+	DDP_TAGGED_INV_DDP_VER      = 0x04,
+	DDP_UNTAGGED_INV_QN	    = 0x01,
+	DDP_UNTAGGED_INV_MSN_NO_BUF = 0x02,
+	DDP_UNTAGGED_INV_MSN_RANGE  = 0x03,
+	DDP_UNTAGGED_INV_MO	    = 0x04,
+	DDP_UNTAGGED_INV_TOO_LONG   = 0x05,
+	DDP_UNTAGGED_INV_DDP_VER    = 0x06,
+};
+
+enum irdma_term_mpa_errors {
+	MPA_CLOSED  = 0x01,
+	MPA_CRC     = 0x02,
+	MPA_MARKER  = 0x03,
+	MPA_REQ_RSP = 0x04,
+};
+
+enum irdma_qp_event_type {
+	IRDMA_QP_EVENT_CATASTROPHIC,
+	IRDMA_QP_EVENT_ACCESS_ERR,
+};
+
+enum irdma_hw_stats_index_32b {
+	IRDMA_HW_STAT_INDEX_IP4RXDISCARD	= 0,
+	IRDMA_HW_STAT_INDEX_IP4RXTRUNC		= 1,
+	IRDMA_HW_STAT_INDEX_IP4TXNOROUTE	= 2,
+	IRDMA_HW_STAT_INDEX_IP6RXDISCARD	= 3,
+	IRDMA_HW_STAT_INDEX_IP6RXTRUNC		= 4,
+	IRDMA_HW_STAT_INDEX_IP6TXNOROUTE	= 5,
+	IRDMA_HW_STAT_INDEX_TCPRTXSEG		= 6,
+	IRDMA_HW_STAT_INDEX_TCPRXOPTERR		= 7,
+	IRDMA_HW_STAT_INDEX_TCPRXPROTOERR	= 8,
+	IRDMA_HW_STAT_INDEX_MAX_32_GEN_1	= 9, /* Must be same value as next entry */
+	IRDMA_HW_STAT_INDEX_RXVLANERR		= 9,
+	IRDMA_HW_STAT_INDEX_RXRPCNPHANDLED	= 10,
+	IRDMA_HW_STAT_INDEX_RXRPCNPIGNORED	= 11,
+	IRDMA_HW_STAT_INDEX_TXNPCNPSENT		= 12,
+	IRDMA_HW_STAT_INDEX_MAX_32, /* Must be last entry */
+};
+
+enum irdma_hw_stats_index_64b {
+	IRDMA_HW_STAT_INDEX_IP4RXOCTS	= 0,
+	IRDMA_HW_STAT_INDEX_IP4RXPKTS	= 1,
+	IRDMA_HW_STAT_INDEX_IP4RXFRAGS	= 2,
+	IRDMA_HW_STAT_INDEX_IP4RXMCPKTS	= 3,
+	IRDMA_HW_STAT_INDEX_IP4TXOCTS	= 4,
+	IRDMA_HW_STAT_INDEX_IP4TXPKTS	= 5,
+	IRDMA_HW_STAT_INDEX_IP4TXFRAGS	= 6,
+	IRDMA_HW_STAT_INDEX_IP4TXMCPKTS	= 7,
+	IRDMA_HW_STAT_INDEX_IP6RXOCTS	= 8,
+	IRDMA_HW_STAT_INDEX_IP6RXPKTS	= 9,
+	IRDMA_HW_STAT_INDEX_IP6RXFRAGS	= 10,
+	IRDMA_HW_STAT_INDEX_IP6RXMCPKTS	= 11,
+	IRDMA_HW_STAT_INDEX_IP6TXOCTS	= 12,
+	IRDMA_HW_STAT_INDEX_IP6TXPKTS	= 13,
+	IRDMA_HW_STAT_INDEX_IP6TXFRAGS	= 14,
+	IRDMA_HW_STAT_INDEX_IP6TXMCPKTS	= 15,
+	IRDMA_HW_STAT_INDEX_TCPRXSEGS	= 16,
+	IRDMA_HW_STAT_INDEX_TCPTXSEG	= 17,
+	IRDMA_HW_STAT_INDEX_RDMARXRDS	= 18,
+	IRDMA_HW_STAT_INDEX_RDMARXSNDS	= 19,
+	IRDMA_HW_STAT_INDEX_RDMARXWRS	= 20,
+	IRDMA_HW_STAT_INDEX_RDMATXRDS	= 21,
+	IRDMA_HW_STAT_INDEX_RDMATXSNDS	= 22,
+	IRDMA_HW_STAT_INDEX_RDMATXWRS	= 23,
+	IRDMA_HW_STAT_INDEX_RDMAVBND	= 24,
+	IRDMA_HW_STAT_INDEX_RDMAVINV	= 25,
+	IRDMA_HW_STAT_INDEX_MAX_64_GEN_1 = 26, /* Must be same value as next entry */
+	IRDMA_HW_STAT_INDEX_IP4RXMCOCTS	= 26,
+	IRDMA_HW_STAT_INDEX_IP4TXMCOCTS	= 27,
+	IRDMA_HW_STAT_INDEX_IP6RXMCOCTS	= 28,
+	IRDMA_HW_STAT_INDEX_IP6TXMCOCTS	= 29,
+	IRDMA_HW_STAT_INDEX_UDPRXPKTS	= 30,
+	IRDMA_HW_STAT_INDEX_UDPTXPKTS	= 31,
+	IRDMA_HW_STAT_INDEX_RXNPECNMARKEDPKTS = 32,
+	IRDMA_HW_STAT_INDEX_MAX_64, /* Must be last entry */
+};
+
+enum irdma_feature_type {
+	IRDMA_FEATURE_FW_INFO = 0,
+	IRDMA_HW_VERSION_INFO = 1,
+	IRDMA_QSETS_MAX       = 26,
+	IRDMA_MAX_FEATURES, /* Must be last entry */
+};
+
+enum irdma_sched_prio_type {
+	IRDMA_PRIO_WEIGHTED_RR     = 1,
+	IRDMA_PRIO_STRICT	   = 2,
+	IRDMA_PRIO_WEIGHTED_STRICT = 3,
+};
+
+enum irdma_vm_vf_type {
+	IRDMA_VF_TYPE = 0,
+	IRDMA_VM_TYPE,
+	IRDMA_PF_TYPE,
+};
+
+enum irdma_cqp_hmc_profile {
+	IRDMA_HMC_PROFILE_DEFAULT  = 1,
+	IRDMA_HMC_PROFILE_FAVOR_VF = 2,
+	IRDMA_HMC_PROFILE_EQUAL    = 3,
+};
+
+enum irdma_quad_entry_type {
+	IRDMA_QHASH_TYPE_TCP_ESTABLISHED = 1,
+	IRDMA_QHASH_TYPE_TCP_SYN,
+	IRDMA_QHASH_TYPE_UDP_UNICAST,
+	IRDMA_QHASH_TYPE_UDP_MCAST,
+	IRDMA_QHASH_TYPE_ROCE_MCAST,
+	IRDMA_QHASH_TYPE_ROCEV2_HW,
+};
+
+enum irdma_quad_hash_manage_type {
+	IRDMA_QHASH_MANAGE_TYPE_DELETE = 0,
+	IRDMA_QHASH_MANAGE_TYPE_ADD,
+	IRDMA_QHASH_MANAGE_TYPE_MODIFY,
+};
+
+enum irdma_syn_rst_handling {
+	IRDMA_SYN_RST_HANDLING_HW_TCP_SECURE = 0,
+	IRDMA_SYN_RST_HANDLING_HW_TCP,
+	IRDMA_SYN_RST_HANDLING_FW_TCP_SECURE,
+	IRDMA_SYN_RST_HANDLING_FW_TCP,
+};
+
+enum irdma_queue_type {
+	IRDMA_QUEUE_TYPE_SQ_RQ = 0,
+	IRDMA_QUEUE_TYPE_CQP,
+};
+
+struct irdma_sc_dev;
+struct irdma_vsi_pestat;
+
+struct irdma_dcqcn_cc_params {
+	u8 cc_cfg_valid;
+	u8 min_dec_factor;
+	u8 min_rate;
+	u8 dcqcn_f;
+	u16 rai_factor;
+	u16 hai_factor;
+	u16 dcqcn_t;
+	u32 dcqcn_b;
+	u32 rreduce_mperiod;
+};
+
+struct irdma_cqp_init_info {
+	u64 cqp_compl_ctx;
+	u64 host_ctx_pa;
+	u64 sq_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_cqp_quanta *sq;
+	struct irdma_dcqcn_cc_params dcqcn_params;
+	__le64 *host_ctx;
+	u64 *scratch_array;
+	u32 sq_size;
+	u16 hw_maj_ver;
+	u16 hw_min_ver;
+	u8 struct_ver;
+	u8 hmc_profile;
+	u8 ena_vf_count;
+	u8 ceqs_per_vf;
+	bool en_datacenter_tcp:1;
+	bool disable_packed:1;
+	bool rocev2_rto_policy:1;
+	enum irdma_protocol_used protocol_used;
+};
+
+struct irdma_terminate_hdr {
+	u8 layer_etype;
+	u8 error_code;
+	u8 hdrct;
+	u8 rsvd;
+};
+
+struct irdma_cqp_sq_wqe {
+	__le64 buf[IRDMA_CQP_WQE_SIZE];
+};
+
+struct irdma_sc_aeqe {
+	__le64 buf[IRDMA_AEQE_SIZE];
+};
+
+struct irdma_ceqe {
+	__le64 buf[IRDMA_CEQE_SIZE];
+};
+
+struct irdma_cqp_ctx {
+	__le64 buf[IRDMA_CQP_CTX_SIZE];
+};
+
+struct irdma_cq_shadow_area {
+	__le64 buf[IRDMA_SHADOW_AREA_SIZE];
+};
+
+struct irdma_dev_hw_stats_offsets {
+	u32 stats_offset_32[IRDMA_HW_STAT_INDEX_MAX_32];
+	u32 stats_offset_64[IRDMA_HW_STAT_INDEX_MAX_64];
+};
+
+struct irdma_dev_hw_stats {
+	u64 stats_val_32[IRDMA_HW_STAT_INDEX_MAX_32];
+	u64 stats_val_64[IRDMA_HW_STAT_INDEX_MAX_64];
+};
+
+struct irdma_gather_stats {
+	u32 rsvd1;
+	u32 rxvlanerr;
+	u64 ip4rxocts;
+	u64 ip4rxpkts;
+	u32 ip4rxtrunc;
+	u32 ip4rxdiscard;
+	u64 ip4rxfrags;
+	u64 ip4rxmcocts;
+	u64 ip4rxmcpkts;
+	u64 ip6rxocts;
+	u64 ip6rxpkts;
+	u32 ip6rxtrunc;
+	u32 ip6rxdiscard;
+	u64 ip6rxfrags;
+	u64 ip6rxmcocts;
+	u64 ip6rxmcpkts;
+	u64 ip4txocts;
+	u64 ip4txpkts;
+	u64 ip4txfrag;
+	u64 ip4txmcocts;
+	u64 ip4txmcpkts;
+	u64 ip6txocts;
+	u64 ip6txpkts;
+	u64 ip6txfrags;
+	u64 ip6txmcocts;
+	u64 ip6txmcpkts;
+	u32 ip6txnoroute;
+	u32 ip4txnoroute;
+	u64 tcprxsegs;
+	u32 tcprxprotoerr;
+	u32 tcprxopterr;
+	u64 tcptxsegs;
+	u32 rsvd2;
+	u32 tcprtxseg;
+	u64 udprxpkts;
+	u64 udptxpkts;
+	u64 rdmarxwrs;
+	u64 rdmarxrds;
+	u64 rdmarxsnds;
+	u64 rdmatxwrs;
+	u64 rdmatxrds;
+	u64 rdmatxsnds;
+	u64 rdmavbn;
+	u64 rdmavinv;
+	u64 rxnpecnmrkpkts;
+	u32 rxrpcnphandled;
+	u32 rxrpcnpignored;
+	u32 txnpcnpsent;
+	u32 rsvd3[88];
+};
+
+struct irdma_stats_gather_info {
+	bool use_hmc_fcn_index:1;
+	bool use_stats_inst:1;
+	u8 hmc_fcn_index;
+	u8 stats_inst_index;
+	struct irdma_dma_mem stats_buff_mem;
+	void *gather_stats_va;
+	void *last_gather_stats_va;
+};
+
+struct irdma_vsi_pestat {
+	struct irdma_hw *hw;
+	struct irdma_dev_hw_stats hw_stats;
+	struct irdma_stats_gather_info gather_info;
+	struct timer_list stats_timer;
+	struct irdma_sc_vsi *vsi;
+	struct irdma_dev_hw_stats last_hw_stats;
+	spinlock_t lock; /* rdma stats lock */
+};
+
+struct irdma_hw {
+	u8 __iomem *hw_addr;
+	u8 __iomem *priv_hw_addr;
+	struct device *device;
+	struct irdma_hmc_info hmc;
+};
+
+struct irdma_pfpdu {
+	struct list_head rxlist;
+	u32 rcv_nxt;
+	u32 fps;
+	u32 max_fpdu_data;
+	u32 nextseqnum;
+	u32 rcv_start_seq;
+	bool mode:1;
+	bool mpa_crc_err:1;
+	u8  marker_len;
+	u64 total_ieq_bufs;
+	u64 fpdu_processed;
+	u64 bad_seq_num;
+	u64 crc_err;
+	u64 no_tx_bufs;
+	u64 tx_err;
+	u64 out_of_order;
+	u64 pmode_count;
+	struct irdma_sc_ah *ah;
+	struct irdma_puda_buf *ah_buf;
+	spinlock_t lock; /* fpdu processing lock */
+	struct irdma_puda_buf *lastrcv_buf;
+};
+
+struct irdma_sc_pd {
+	struct irdma_sc_dev *dev;
+	u32 pd_id;
+	int abi_ver;
+};
+
+struct irdma_cqp_quanta {
+	__le64 elem[IRDMA_CQP_WQE_SIZE];
+};
+
+struct irdma_sc_cqp {
+	u32 size;
+	u64 sq_pa;
+	u64 host_ctx_pa;
+	void *back_cqp;
+	struct irdma_sc_dev *dev;
+	enum irdma_status_code (*process_cqp_sds)(struct irdma_sc_dev *dev,
+						  struct irdma_update_sds_info *info);
+	struct irdma_dma_mem sdbuf;
+	struct irdma_ring sq_ring;
+	struct irdma_cqp_quanta *sq_base;
+	struct irdma_dcqcn_cc_params dcqcn_params;
+	__le64 *host_ctx;
+	u64 *scratch_array;
+	u32 cqp_id;
+	u32 sq_size;
+	u32 hw_sq_size;
+	u16 hw_maj_ver;
+	u16 hw_min_ver;
+	u8 struct_ver;
+	u8 polarity;
+	u8 hmc_profile;
+	u8 ena_vf_count;
+	u8 timeout_count;
+	u8 ceqs_per_vf;
+	bool en_datacenter_tcp:1;
+	bool disable_packed:1;
+	bool rocev2_rto_policy:1;
+	enum irdma_protocol_used protocol_used;
+};
+
+struct irdma_sc_aeq {
+	u32 size;
+	u64 aeq_elem_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_sc_aeqe *aeqe_base;
+	void *pbl_list;
+	u32 elem_cnt;
+	struct irdma_ring aeq_ring;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	u32 msix_idx;
+	u8 polarity;
+	bool virtual_map:1;
+};
+
+struct irdma_sc_ceq {
+	u32 size;
+	u64 ceq_elem_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_ceqe *ceqe_base;
+	void *pbl_list;
+	u32 ceq_id;
+	u32 elem_cnt;
+	struct irdma_ring ceq_ring;
+	u8 pbl_chunk_size;
+	u8 tph_val;
+	u32 first_pm_pbl_idx;
+	u8 polarity;
+	struct irdma_sc_vsi *vsi;
+	struct irdma_sc_cq **reg_cq;
+	u32 reg_cq_size;
+	spinlock_t req_cq_lock; /* protect access to reg_cq array */
+	bool virtual_map:1;
+	bool tph_en:1;
+	bool itr_no_expire:1;
+};
+
+struct irdma_sc_cq {
+	struct irdma_cq_uk cq_uk;
+	u64 cq_pa;
+	u64 shadow_area_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_sc_vsi *vsi;
+	void *pbl_list;
+	void *back_cq;
+	u32 ceq_id;
+	u32 shadow_read_threshold;
+	u8 pbl_chunk_size;
+	u8 cq_type;
+	u8 tph_val;
+	u32 first_pm_pbl_idx;
+	bool ceqe_mask:1;
+	bool virtual_map:1;
+	bool check_overflow:1;
+	bool ceq_id_valid:1;
+	bool tph_en;
+};
+
+struct irdma_sc_qp {
+	struct irdma_qp_uk qp_uk;
+	u64 sq_pa;
+	u64 rq_pa;
+	u64 hw_host_ctx_pa;
+	u64 shadow_area_pa;
+	u64 q2_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_sc_vsi *vsi;
+	struct irdma_sc_pd *pd;
+	__le64 *hw_host_ctx;
+	void *llp_stream_handle;
+	struct irdma_pfpdu pfpdu;
+	u32 ieq_qp;
+	u8 *q2_buf;
+	u64 qp_compl_ctx;
+	u32 push_idx;
+	u16 qs_handle;
+	u16 push_offset;
+	u8 flush_wqes_count;
+	u8 sq_tph_val;
+	u8 rq_tph_val;
+	u8 qp_state;
+	u8 hw_sq_size;
+	u8 hw_rq_size;
+	u8 src_mac_addr_idx;
+	bool on_qoslist:1;
+	bool ieq_pass_thru:1;
+	bool sq_tph_en:1;
+	bool rq_tph_en:1;
+	bool rcv_tph_en:1;
+	bool xmit_tph_en:1;
+	bool virtual_map:1;
+	bool flush_sq:1;
+	bool flush_rq:1;
+	bool sq_flush_code:1;
+	bool rq_flush_code:1;
+	enum irdma_flush_opcode flush_code;
+	enum irdma_qp_event_type event_type;
+	u8 term_flags;
+	u8 user_pri;
+	struct list_head list;
+};
+
+struct irdma_stats_inst_info {
+	bool use_hmc_fcn_index;
+	u8 hmc_fn_id;
+	u8 stats_idx;
+};
+
+struct irdma_up_info {
+	u8 map[8];
+	u8 cnp_up_override;
+	u8 hmc_fcn_idx;
+	bool use_vlan:1;
+	bool use_cnp_up_override:1;
+};
+
+#define IRDMA_MAX_WS_NODES	0x3FF
+#define IRDMA_WS_NODE_INVALID	0xFFFF
+
+struct irdma_ws_node_info {
+	u16 id;
+	u16 vsi;
+	u16 parent_id;
+	u16 qs_handle;
+	bool type_leaf:1;
+	bool enable:1;
+	u8 prio_type;
+	u8 tc;
+	u8 weight;
+};
+
+struct irdma_hmc_fpm_misc {
+	u32 max_ceqs;
+	u32 max_sds;
+	u32 xf_block_size;
+	u32 q1_block_size;
+	u32 ht_multiplier;
+	u32 timer_bucket;
+	u32 rrf_block_size;
+	u32 ooiscf_block_size;
+};
+
+#define IRDMA_LEAF_DEFAULT_REL_BW		64
+#define IRDMA_PARENT_DEFAULT_REL_BW		1
+
+struct irdma_qos {
+	struct list_head qplist;
+	struct mutex qos_mutex; /* protect QoS attributes per QoS level */
+	u64 lan_qos_handle;
+	u32 l2_sched_node_id;
+	u16 qs_handle;
+	u8 traffic_class;
+	u8 rel_bw;
+	u8 prio_type;
+	bool valid;
+};
+
+#define IRDMA_INVALID_FCN_ID 0xff
+struct irdma_sc_vsi {
+	u16 vsi_idx;
+	struct irdma_sc_dev *dev;
+	void *back_vsi;
+	u32 ilq_count;
+	struct irdma_virt_mem ilq_mem;
+	struct irdma_puda_rsrc *ilq;
+	u32 ieq_count;
+	struct irdma_virt_mem ieq_mem;
+	struct irdma_puda_rsrc *ieq;
+	u32 exception_lan_q;
+	u16 mtu;
+	u16 vm_id;
+	u8 fcn_id;
+	enum irdma_vm_vf_type vm_vf_type;
+	bool stats_fcn_id_alloc:1;
+	bool tc_change_pending:1;
+	struct irdma_qos qos[IRDMA_MAX_USER_PRIORITY];
+	struct irdma_vsi_pestat *pestat;
+	atomic_t qp_suspend_reqs;
+	enum irdma_status_code (*register_qset)(struct irdma_sc_vsi *vsi,
+						struct irdma_ws_node *tc_node);
+	void (*unregister_qset)(struct irdma_sc_vsi *vsi,
+				struct irdma_ws_node *tc_node);
+	u8 qos_rel_bw;
+	u8 qos_prio_type;
+};
+
+struct irdma_sc_dev {
+	struct list_head cqp_cmd_head; /* head of the CQP command list */
+	spinlock_t cqp_lock; /* protect CQP list access */
+	bool fcn_id_array[IRDMA_MAX_STATS_COUNT];
+	struct irdma_dma_mem vf_fpm_query_buf[IRDMA_MAX_PE_ENA_VF_COUNT];
+	u64 fpm_query_buf_pa;
+	u64 fpm_commit_buf_pa;
+	__le64 *fpm_query_buf;
+	__le64 *fpm_commit_buf;
+	struct irdma_hw *hw;
+	u8 __iomem *db_addr;
+	u32 __iomem *wqe_alloc_db;
+	u32 __iomem *cq_arm_db;
+	u32 __iomem *aeq_alloc_db;
+	u32 __iomem *cqp_db;
+	u32 __iomem *cq_ack_db;
+	u32 __iomem *ceq_itr_mask_db;
+	u32 __iomem *aeq_itr_mask_db;
+	u32 __iomem *hw_regs[IRDMA_MAX_REGS];
+	u32 ceq_itr;   /* Interrupt throttle, usecs between interrupts: 0 disabled. 2 - 8160 */
+	u64 hw_masks[IRDMA_MAX_MASKS];
+	u64 hw_shifts[IRDMA_MAX_SHIFTS];
+	u64 hw_stats_regs_32[IRDMA_HW_STAT_INDEX_MAX_32];
+	u64 hw_stats_regs_64[IRDMA_HW_STAT_INDEX_MAX_64];
+	u64 feature_info[IRDMA_MAX_FEATURES];
+	u64 cqp_cmd_stats[IRDMA_MAX_CQP_OPS];
+	struct irdma_hw_attrs hw_attrs;
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_sc_cqp *cqp;
+	struct irdma_sc_aeq *aeq;
+	struct irdma_sc_ceq *ceq[IRDMA_CEQ_MAX_COUNT];
+	struct irdma_sc_cq *ccq;
+	const struct irdma_irq_ops *irq_ops;
+	struct irdma_hmc_fpm_misc hmc_fpm_misc;
+	struct irdma_ws_node *ws_tree_root;
+	struct mutex ws_mutex; /* ws tree mutex */
+	u16 num_vfs;
+	u8 hmc_fn_id;
+	u8 vf_id;
+	bool vchnl_up:1;
+	bool ceq_valid:1;
+	u8 pci_rev;
+	enum irdma_status_code (*ws_add)(struct irdma_sc_vsi *vsi, u8 user_pri);
+	void (*ws_remove)(struct irdma_sc_vsi *vsi, u8 user_pri);
+	void (*ws_reset)(struct irdma_sc_vsi *vsi);
+};
+
+struct irdma_modify_cq_info {
+	u64 cq_pa;
+	struct irdma_cqe *cq_base;
+	u32 cq_size;
+	u32 shadow_read_threshold;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	bool virtual_map:1;
+	bool check_overflow;
+	bool cq_resize:1;
+};
+
+struct irdma_create_qp_info {
+	bool ord_valid:1;
+	bool tcp_ctx_valid:1;
+	bool cq_num_valid:1;
+	bool arp_cache_idx_valid:1;
+	bool mac_valid:1;
+	bool force_lpb;
+	u8 next_iwarp_state;
+};
+
+struct irdma_modify_qp_info {
+	u64 rx_win0;
+	u64 rx_win1;
+	u16 new_mss;
+	u8 next_iwarp_state;
+	u8 curr_iwarp_state;
+	u8 termlen;
+	bool ord_valid:1;
+	bool tcp_ctx_valid:1;
+	bool udp_ctx_valid:1;
+	bool cq_num_valid:1;
+	bool arp_cache_idx_valid:1;
+	bool reset_tcp_conn:1;
+	bool remove_hash_idx:1;
+	bool dont_send_term:1;
+	bool dont_send_fin:1;
+	bool cached_var_valid:1;
+	bool mss_change:1;
+	bool force_lpb:1;
+	bool mac_valid:1;
+};
+
+struct irdma_ccq_cqe_info {
+	struct irdma_sc_cqp *cqp;
+	u64 scratch;
+	u32 op_ret_val;
+	u16 maj_err_code;
+	u16 min_err_code;
+	u8 op_code;
+	bool error;
+};
+
+struct irdma_dcb_app_info {
+	u8 priority;
+	u8 selector;
+	u16 prot_id;
+};
+
+struct irdma_qos_tc_info {
+	u64 tc_ctx;
+	u8 rel_bw;
+	u8 prio_type;
+	u8 egress_virt_up;
+	u8 ingress_virt_up;
+};
+
+struct irdma_l2params {
+	struct irdma_qos_tc_info tc_info[IRDMA_MAX_USER_PRIORITY];
+	struct irdma_dcb_app_info apps[IRDMA_MAX_APPS];
+	u32 num_apps;
+	u16 qs_handle_list[IRDMA_MAX_USER_PRIORITY];
+	u16 mtu;
+	u8 up2tc[IRDMA_MAX_USER_PRIORITY];
+	u8 num_tc;
+	u8 vsi_rel_bw;
+	u8 vsi_prio_type;
+	bool mtu_changed:1;
+	bool tc_changed:1;
+};
+
+struct irdma_vsi_init_info {
+	struct irdma_sc_dev *dev;
+	void *back_vsi;
+	struct irdma_l2params *params;
+	u16 exception_lan_q;
+	u16 pf_data_vsi_num;
+	enum irdma_vm_vf_type vm_vf_type;
+	u16 vm_id;
+	enum irdma_status_code (*register_qset)(struct irdma_sc_vsi *vsi,
+						struct irdma_ws_node *tc_node);
+	void (*unregister_qset)(struct irdma_sc_vsi *vsi,
+				struct irdma_ws_node *tc_node);
+};
+
+struct irdma_vsi_stats_info {
+	struct irdma_vsi_pestat *pestat;
+	u8 fcn_id;
+	bool alloc_fcn_id;
+};
+
+struct irdma_device_init_info {
+	u64 fpm_query_buf_pa;
+	u64 fpm_commit_buf_pa;
+	__le64 *fpm_query_buf;
+	__le64 *fpm_commit_buf;
+	struct irdma_hw *hw;
+	void __iomem *bar0;
+	u8 hmc_fn_id;
+};
+
+struct irdma_ceq_init_info {
+	u64 ceqe_pa;
+	struct irdma_sc_dev *dev;
+	u64 *ceqe_base;
+	void *pbl_list;
+	u32 elem_cnt;
+	u32 ceq_id;
+	bool virtual_map:1;
+	bool tph_en:1;
+	bool itr_no_expire:1;
+	u8 pbl_chunk_size;
+	u8 tph_val;
+	u32 first_pm_pbl_idx;
+	struct irdma_sc_vsi *vsi;
+	struct irdma_sc_cq **reg_cq;
+	u32 reg_cq_idx;
+};
+
+struct irdma_aeq_init_info {
+	u64 aeq_elem_pa;
+	struct irdma_sc_dev *dev;
+	u32 *aeqe_base;
+	void *pbl_list;
+	u32 elem_cnt;
+	bool virtual_map;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	u32 msix_idx;
+};
+
+struct irdma_ccq_init_info {
+	u64 cq_pa;
+	u64 shadow_area_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_cqe *cq_base;
+	__le64 *shadow_area;
+	void *pbl_list;
+	u32 num_elem;
+	u32 ceq_id;
+	u32 shadow_read_threshold;
+	bool ceqe_mask:1;
+	bool ceq_id_valid:1;
+	bool avoid_mem_cflct:1;
+	bool virtual_map:1;
+	bool tph_en:1;
+	u8 tph_val;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	struct irdma_sc_vsi *vsi;
+};
+
+struct irdma_udp_offload_info {
+	bool ipv4:1;
+	bool insert_vlan_tag:1;
+	u8 ttl;
+	u8 tos;
+	u16 src_port;
+	u16 dst_port;
+	u32 dest_ip_addr[4];
+	u32 snd_mss;
+	u16 vlan_tag;
+	u16 arp_idx;
+	u32 flow_label;
+	u8 udp_state;
+	u32 psn_nxt;
+	u32 lsn;
+	u32 epsn;
+	u32 psn_max;
+	u32 psn_una;
+	u32 local_ipaddr[4];
+	u32 cwnd;
+	u8 rexmit_thresh;
+	u8 rnr_nak_thresh;
+};
+
+struct irdma_roce_offload_info {
+	u16 p_key;
+	u16 err_rq_idx;
+	u32 qkey;
+	u32 dest_qp;
+	u32 local_qp;
+	u8 roce_tver;
+	u8 ack_credits;
+	u8 err_rq_idx_valid;
+	u32 pd_id;
+	u16 ord_size;
+	u16 ird_size;
+	bool is_qp1:1;
+	bool udprivcq_en:1;
+	bool dcqcn_en:1;
+	bool rcv_no_icrc:1;
+	bool wr_rdresp_en:1;
+	bool bind_en:1;
+	bool fast_reg_en:1;
+	bool priv_mode_en:1;
+	bool rd_en:1;
+	bool timely_en:1;
+	bool dctcp_en:1;
+	bool fw_cc_enable:1;
+	bool use_stats_inst:1;
+	u16 t_high;
+	u16 t_low;
+	u8 last_byte_sent;
+	u8 mac_addr[ETH_ALEN];
+	u8 rtomin;
+};
+
+struct irdma_iwarp_offload_info {
+	u16 rcv_mark_offset;
+	u16 snd_mark_offset;
+	u8 ddp_ver;
+	u8 rdmap_ver;
+	u8 iwarp_mode;
+	u16 err_rq_idx;
+	u32 pd_id;
+	u16 ord_size;
+	u16 ird_size;
+	bool ib_rd_en:1;
+	bool align_hdrs:1;
+	bool rcv_no_mpa_crc:1;
+	bool err_rq_idx_valid:1;
+	bool snd_mark_en:1;
+	bool rcv_mark_en:1;
+	bool wr_rdresp_en:1;
+	bool bind_en:1;
+	bool fast_reg_en:1;
+	bool priv_mode_en:1;
+	bool rd_en:1;
+	bool timely_en:1;
+	bool use_stats_inst:1;
+	bool ecn_en:1;
+	bool dctcp_en:1;
+	u16 t_high;
+	u16 t_low;
+	u8 last_byte_sent;
+	u8 mac_addr[ETH_ALEN];
+	u8 rtomin;
+};
+
+struct irdma_tcp_offload_info {
+	bool ipv4:1;
+	bool no_nagle:1;
+	bool insert_vlan_tag:1;
+	bool time_stamp:1;
+	bool drop_ooo_seg:1;
+	bool avoid_stretch_ack:1;
+	bool wscale:1;
+	bool ignore_tcp_opt:1;
+	bool ignore_tcp_uns_opt:1;
+	u8 cwnd_inc_limit;
+	u8 dup_ack_thresh;
+	u8 ttl;
+	u8 src_mac_addr_idx;
+	u8 tos;
+	u16 src_port;
+	u16 dst_port;
+	u32 dest_ip_addr[4];
+	//u32 dest_ip_addr0;
+	//u32 dest_ip_addr1;
+	//u32 dest_ip_addr2;
+	//u32 dest_ip_addr3;
+	u32 snd_mss;
+	u16 syn_rst_handling;
+	u16 vlan_tag;
+	u16 arp_idx;
+	u32 flow_label;
+	u8 tcp_state;
+	u8 snd_wscale;
+	u8 rcv_wscale;
+	u32 time_stamp_recent;
+	u32 time_stamp_age;
+	u32 snd_nxt;
+	u32 snd_wnd;
+	u32 rcv_nxt;
+	u32 rcv_wnd;
+	u32 snd_max;
+	u32 snd_una;
+	u32 srtt;
+	u32 rtt_var;
+	u32 ss_thresh;
+	u32 cwnd;
+	u32 snd_wl1;
+	u32 snd_wl2;
+	u32 max_snd_window;
+	u8 rexmit_thresh;
+	u32 local_ipaddr[4];
+};
+
+struct irdma_qp_host_ctx_info {
+	u64 qp_compl_ctx;
+	union {
+		struct irdma_tcp_offload_info *tcp_info;
+		struct irdma_udp_offload_info *udp_info;
+	};
+	union {
+		struct irdma_iwarp_offload_info *iwarp_info;
+		struct irdma_roce_offload_info *roce_info;
+	};
+	u32 send_cq_num;
+	u32 rcv_cq_num;
+	u32 rem_endpoint_idx;
+	u8 stats_idx;
+	bool srq_valid:1;
+	bool tcp_info_valid:1;
+	bool iwarp_info_valid:1;
+	bool stats_idx_valid:1;
+	u8 user_pri;
+};
+
+struct irdma_aeqe_info {
+	u64 compl_ctx;
+	u32 qp_cq_id;
+	u16 ae_id;
+	u16 wqe_idx;
+	u8 tcp_state;
+	u8 iwarp_state;
+	bool qp:1;
+	bool cq:1;
+	bool sq:1;
+	bool rq:1;
+	bool in_rdrsp_wr:1;
+	bool out_rdrsp:1;
+	bool aeqe_overflow:1;
+	u8 q2_data_written;
+	u8 ae_src;
+};
+
+struct irdma_allocate_stag_info {
+	u64 total_len;
+	u64 first_pm_pbl_idx;
+	u32 chunk_size;
+	u32 stag_idx;
+	u32 page_size;
+	u32 pd_id;
+	u16 access_rights;
+	bool remote_access:1;
+	bool use_hmc_fcn_index:1;
+	bool use_pf_rid:1;
+	u8 hmc_fcn_index;
+};
+
+struct irdma_mw_alloc_info {
+	u32 mw_stag_index;
+	u32 page_size;
+	u32 pd_id;
+	bool remote_access:1;
+	bool mw_wide:1;
+	bool mw1_bind_dont_vldt_key:1;
+};
+
+struct irdma_reg_ns_stag_info {
+	u64 reg_addr_pa;
+	u64 va;
+	u64 total_len;
+	u32 page_size;
+	u32 chunk_size;
+	u32 first_pm_pbl_index;
+	enum irdma_addressing_type addr_type;
+	irdma_stag_index stag_idx;
+	u16 access_rights;
+	u32 pd_id;
+	irdma_stag_key stag_key;
+	bool use_hmc_fcn_index:1;
+	u8 hmc_fcn_index;
+	bool use_pf_rid:1;
+};
+
+struct irdma_fast_reg_stag_info {
+	u64 wr_id;
+	u64 reg_addr_pa;
+	u64 fbo;
+	void *va;
+	u64 total_len;
+	u32 page_size;
+	u32 chunk_size;
+	u32 first_pm_pbl_index;
+	enum irdma_addressing_type addr_type;
+	irdma_stag_index stag_idx;
+	u16 access_rights;
+	u32 pd_id;
+	irdma_stag_key stag_key;
+	bool local_fence:1;
+	bool read_fence:1;
+	bool signaled:1;
+	bool push_wqe:1;
+	bool use_hmc_fcn_index:1;
+	u8 hmc_fcn_index;
+	bool use_pf_rid:1;
+	bool defer_flag:1;
+};
+
+struct irdma_dealloc_stag_info {
+	u32 stag_idx;
+	u32 pd_id;
+	bool mr:1;
+	bool dealloc_pbl:1;
+};
+
+struct irdma_register_shared_stag {
+	u64 va;
+	enum irdma_addressing_type addr_type;
+	irdma_stag_index new_stag_idx;
+	irdma_stag_index parent_stag_idx;
+	u32 access_rights;
+	u32 pd_id;
+	u32 page_size;
+	irdma_stag_key new_stag_key;
+};
+
+struct irdma_qp_init_info {
+	struct irdma_qp_uk_init_info qp_uk_init_info;
+	struct irdma_sc_pd *pd;
+	struct irdma_sc_vsi *vsi;
+	__le64 *host_ctx;
+	u8 *q2;
+	u64 sq_pa;
+	u64 rq_pa;
+	u64 host_ctx_pa;
+	u64 q2_pa;
+	u64 shadow_area_pa;
+	u8 sq_tph_val;
+	u8 rq_tph_val;
+	bool sq_tph_en:1;
+	bool rq_tph_en:1;
+	bool rcv_tph_en:1;
+	bool xmit_tph_en:1;
+	bool virtual_map:1;
+};
+
+struct irdma_cq_init_info {
+	struct irdma_sc_dev *dev;
+	u64 cq_base_pa;
+	u64 shadow_area_pa;
+	u32 ceq_id;
+	u32 shadow_read_threshold;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	bool virtual_map:1;
+	bool ceqe_mask:1;
+	bool ceq_id_valid:1;
+	bool tph_en:1;
+	u8 tph_val;
+	u8 type;
+	struct irdma_cq_uk_init_info cq_uk_init_info;
+	struct irdma_sc_vsi *vsi;
+};
+
+struct irdma_upload_context_info {
+	u64 buf_pa;
+	u32 qp_id;
+	u8 qp_type;
+	bool freeze_qp:1;
+	bool raw_format:1;
+};
+
+struct irdma_local_mac_entry_info {
+	u8 mac_addr[6];
+	u16 entry_idx;
+};
+
+struct irdma_add_arp_cache_entry_info {
+	u8 mac_addr[ETH_ALEN];
+	u32 reach_max;
+	u16 arp_index;
+	bool permanent;
+};
+
+struct irdma_apbvt_info {
+	u16 port;
+	bool add;
+};
+
+struct irdma_qhash_table_info {
+	struct irdma_sc_vsi *vsi;
+	enum irdma_quad_hash_manage_type manage;
+	enum irdma_quad_entry_type entry_type;
+	bool vlan_valid:1;
+	bool ipv4_valid:1;
+	u8 mac_addr[ETH_ALEN];
+	u16 vlan_id;
+	u8 user_pri;
+	u32 qp_num;
+	u32 dest_ip[4];
+	u32 src_ip[4];
+	u16 dest_port;
+	u16 src_port;
+};
+
+struct irdma_cqp_manage_push_page_info {
+	u32 push_idx;
+	u16 qs_handle;
+	u8 free_page;
+	u8 push_page_type;
+};
+
+struct irdma_qp_flush_info {
+	u16 sq_minor_code;
+	u16 sq_major_code;
+	u16 rq_minor_code;
+	u16 rq_major_code;
+	u16 ae_code;
+	u8 ae_src;
+	bool sq:1;
+	bool rq:1;
+	bool userflushcode:1;
+	bool generate_ae:1;
+};
+
+struct irdma_gen_ae_info {
+	u16 ae_code;
+	u8 ae_src;
+};
+
+struct irdma_cqp_timeout {
+	u64 compl_cqp_cmds;
+	u32 count;
+};
+
+struct irdma_irq_ops {
+	void (*irdma_cfg_aeq)(struct irdma_sc_dev *dev, u32 idx, bool enable);
+	void (*irdma_cfg_ceq)(struct irdma_sc_dev *dev, u32 ceq_id, u32 idx,
+			      bool enable);
+	void (*irdma_dis_irq)(struct irdma_sc_dev *dev, u32 idx);
+	void (*irdma_en_irq)(struct irdma_sc_dev *dev, u32 idx);
+};
+
+void irdma_sc_ccq_arm(struct irdma_sc_cq *ccq);
+enum irdma_status_code irdma_sc_ccq_create(struct irdma_sc_cq *ccq, u64 scratch,
+					   bool check_overflow, bool post_sq);
+enum irdma_status_code irdma_sc_ccq_destroy(struct irdma_sc_cq *ccq, u64 scratch,
+					    bool post_sq);
+enum irdma_status_code irdma_sc_ccq_get_cqe_info(struct irdma_sc_cq *ccq,
+						 struct irdma_ccq_cqe_info *info);
+enum irdma_status_code irdma_sc_ccq_init(struct irdma_sc_cq *ccq,
+					 struct irdma_ccq_init_info *info);
+
+enum irdma_status_code irdma_sc_cceq_create(struct irdma_sc_ceq *ceq, u64 scratch);
+enum irdma_status_code irdma_sc_cceq_destroy_done(struct irdma_sc_ceq *ceq);
+
+enum irdma_status_code irdma_sc_ceq_destroy(struct irdma_sc_ceq *ceq, u64 scratch,
+					    bool post_sq);
+enum irdma_status_code irdma_sc_ceq_init(struct irdma_sc_ceq *ceq,
+					 struct irdma_ceq_init_info *info);
+void irdma_sc_cleanup_ceqes(struct irdma_sc_cq *cq, struct irdma_sc_ceq *ceq);
+void *irdma_sc_process_ceq(struct irdma_sc_dev *dev, struct irdma_sc_ceq *ceq);
+
+enum irdma_status_code irdma_sc_aeq_init(struct irdma_sc_aeq *aeq,
+					 struct irdma_aeq_init_info *info);
+enum irdma_status_code irdma_sc_get_next_aeqe(struct irdma_sc_aeq *aeq,
+					      struct irdma_aeqe_info *info);
+enum irdma_status_code irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev,
+						   u32 count);
+
+void irdma_sc_pd_init(struct irdma_sc_dev *dev, struct irdma_sc_pd *pd, u32 pd_id,
+		      int abi_ver);
+void irdma_cfg_aeq(struct irdma_sc_dev *dev, u32 idx, bool enable);
+void irdma_check_cqp_progress(struct irdma_cqp_timeout *cqp_timeout,
+			      struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_sc_cqp_create(struct irdma_sc_cqp *cqp, u16 *maj_err,
+					   u16 *min_err);
+enum irdma_status_code irdma_sc_cqp_destroy(struct irdma_sc_cqp *cqp);
+enum irdma_status_code irdma_sc_cqp_init(struct irdma_sc_cqp *cqp,
+					 struct irdma_cqp_init_info *info);
+void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp);
+enum irdma_status_code irdma_sc_poll_for_cqp_op_done(struct irdma_sc_cqp *cqp, u8 opcode,
+						     struct irdma_ccq_cqe_info *cmpl_info);
+enum irdma_status_code irdma_sc_fast_register(struct irdma_sc_qp *qp,
+					      struct irdma_fast_reg_stag_info *info,
+					      bool post_sq);
+enum irdma_status_code irdma_sc_qp_create(struct irdma_sc_qp *qp,
+					  struct irdma_create_qp_info *info,
+					  u64 scratch, bool post_sq);
+enum irdma_status_code irdma_sc_qp_destroy(struct irdma_sc_qp *qp,
+					   u64 scratch, bool remove_hash_idx,
+					   bool ignore_mw_bnd, bool post_sq);
+enum irdma_status_code irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp,
+					      struct irdma_qp_flush_info *info,
+					      u64 scratch, bool post_sq);
+enum irdma_status_code irdma_sc_qp_init(struct irdma_sc_qp *qp,
+					struct irdma_qp_init_info *info);
+enum irdma_status_code irdma_sc_qp_modify(struct irdma_sc_qp *qp,
+					  struct irdma_modify_qp_info *info,
+					  u64 scratch, bool post_sq);
+void irdma_sc_send_lsmm(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size,
+			irdma_stag stag);
+void irdma_sc_send_lsmm_nostag(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size);
+void irdma_sc_send_rtt(struct irdma_sc_qp *qp, bool read);
+void irdma_sc_qp_setctx(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+			struct irdma_qp_host_ctx_info *info);
+void irdma_sc_qp_setctx_roce(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+			     struct irdma_qp_host_ctx_info *info);
+enum irdma_status_code irdma_sc_cq_destroy(struct irdma_sc_cq *cq, u64 scratch,
+					   bool post_sq);
+enum irdma_status_code irdma_sc_cq_init(struct irdma_sc_cq *cq,
+					struct irdma_cq_init_info *info);
+void irdma_sc_cq_resize(struct irdma_sc_cq *cq, struct irdma_modify_cq_info *info);
+enum irdma_status_code irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp,
+							   u64 scratch, u8 hmc_fn_id,
+							   bool post_sq, bool poll_registers);
+
+void sc_vsi_update_stats(struct irdma_sc_vsi *vsi);
+struct cqp_info {
+	union {
+		struct {
+			struct irdma_sc_qp *qp;
+			struct irdma_create_qp_info info;
+			u64 scratch;
+		} qp_create;
+
+		struct {
+			struct irdma_sc_qp *qp;
+			struct irdma_modify_qp_info info;
+			u64 scratch;
+		} qp_modify;
+
+		struct {
+			struct irdma_sc_qp *qp;
+			u64 scratch;
+			bool remove_hash_idx;
+			bool ignore_mw_bnd;
+		} qp_destroy;
+
+		struct {
+			struct irdma_sc_cq *cq;
+			u64 scratch;
+			bool check_overflow;
+		} cq_create;
+
+		struct {
+			struct irdma_sc_cq *cq;
+			struct irdma_modify_cq_info info;
+			u64 scratch;
+		} cq_modify;
+
+		struct {
+			struct irdma_sc_cq *cq;
+			u64 scratch;
+		} cq_destroy;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_allocate_stag_info info;
+			u64 scratch;
+		} alloc_stag;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_mw_alloc_info info;
+			u64 scratch;
+		} mw_alloc;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_reg_ns_stag_info info;
+			u64 scratch;
+		} mr_reg_non_shared;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_dealloc_stag_info info;
+			u64 scratch;
+		} dealloc_stag;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_add_arp_cache_entry_info info;
+			u64 scratch;
+		} add_arp_cache_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			u64 scratch;
+			u16 arp_index;
+		} del_arp_cache_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_local_mac_entry_info info;
+			u64 scratch;
+		} add_local_mac_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			u64 scratch;
+			u8 entry_idx;
+			u8 ignore_ref_count;
+		} del_local_mac_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			u64 scratch;
+		} alloc_local_mac_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_cqp_manage_push_page_info info;
+			u64 scratch;
+		} manage_push_page;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_upload_context_info info;
+			u64 scratch;
+		} qp_upload_context;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_hmc_fcn_info info;
+			u64 scratch;
+		} manage_hmc_pm;
+
+		struct {
+			struct irdma_sc_ceq *ceq;
+			u64 scratch;
+		} ceq_create;
+
+		struct {
+			struct irdma_sc_ceq *ceq;
+			u64 scratch;
+		} ceq_destroy;
+
+		struct {
+			struct irdma_sc_aeq *aeq;
+			u64 scratch;
+		} aeq_create;
+
+		struct {
+			struct irdma_sc_aeq *aeq;
+			u64 scratch;
+		} aeq_destroy;
+
+		struct {
+			struct irdma_sc_qp *qp;
+			struct irdma_qp_flush_info info;
+			u64 scratch;
+		} qp_flush_wqes;
+
+		struct {
+			struct irdma_sc_qp *qp;
+			struct irdma_gen_ae_info info;
+			u64 scratch;
+		} gen_ae;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			void *fpm_val_va;
+			u64 fpm_val_pa;
+			u8 hmc_fn_id;
+			u64 scratch;
+		} query_fpm_val;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			void *fpm_val_va;
+			u64 fpm_val_pa;
+			u8 hmc_fn_id;
+			u64 scratch;
+		} commit_fpm_val;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_apbvt_info info;
+			u64 scratch;
+		} manage_apbvt_entry;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_qhash_table_info info;
+			u64 scratch;
+		} manage_qhash_table_entry;
+
+		struct {
+			struct irdma_sc_dev *dev;
+			struct irdma_update_sds_info info;
+			u64 scratch;
+		} update_pe_sds;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_sc_qp *qp;
+			u64 scratch;
+		} suspend_resume;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_ah_info info;
+			u64 scratch;
+		} ah_create;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_ah_info info;
+			u64 scratch;
+		} ah_destroy;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_mcast_grp_info info;
+			u64 scratch;
+		} mc_create;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_mcast_grp_info info;
+			u64 scratch;
+		} mc_destroy;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_mcast_grp_info info;
+			u64 scratch;
+		} mc_modify;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_stats_inst_info info;
+			u64 scratch;
+		} stats_manage;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_stats_gather_info info;
+			u64 scratch;
+		} stats_gather;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_ws_node_info info;
+			u64 scratch;
+		} ws_node;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_up_info info;
+			u64 scratch;
+		} up_map;
+
+		struct {
+			struct irdma_sc_cqp *cqp;
+			struct irdma_dma_mem query_buff_mem;
+			u64 scratch;
+		} query_rdma;
+	} u;
+};
+
+struct cqp_cmds_info {
+	struct list_head cqp_cmd_entry;
+	u8 cqp_cmd;
+	u8 post_sq;
+	struct cqp_info in;
+};
+
+__le64 *irdma_sc_cqp_get_next_send_wqe_idx(struct irdma_sc_cqp *cqp, u64 scratch,
+					   u32 *wqe_idx);
+
+/**
+ * irdma_sc_cqp_get_next_send_wqe - get next wqe on cqp sq
+ * @cqp: struct for cqp hw
+ * @scratch: private data for CQP WQE
+ */
+static inline __le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch)
+{
+	u32 wqe_idx;
+
+	return irdma_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
+}
+#endif /* IRDMA_TYPE_H */
-- 
1.8.3.1

