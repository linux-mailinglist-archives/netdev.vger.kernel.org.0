Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172651AE3AB
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgDQRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:19:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:38151 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgDQRTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:19:03 -0400
IronPort-SDR: BBLCvMjcxUik9p7YFdk8ya4O30PpjsOQf03vThpvWzQnpl/PcxwdOaFxBQLOcGsMi+TOtAwMOd
 DUZ4yOPlPynQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:54 -0700
IronPort-SDR: WXDDpZsOjxf+eeMcV96ZbHWB97rw22A6ET/rkoxChcdoEzSsegJ6z/deFjNcsovaf/pCJcwEjw
 AUGOu2gpVQAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383705"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:53 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 03/16] RDMA/irdma: Implement HW Admin Queue OPs
Date:   Fri, 17 Apr 2020 10:12:38 -0700
Message-Id: <20200417171251.1533371-4-jeffrey.t.kirsher@intel.com>
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

The driver posts privileged commands to the HW
Admin Queue (Control QP or CQP) to request administrative
actions from the HW. Implement create/destroy of CQP
and the supporting functions, data structures and headers
to handle the different CQP commands

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/ctrl.c  | 5985 +++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h  | 2132 ++++++++++
 drivers/infiniband/hw/irdma/irdma.h |  190 +
 drivers/infiniband/hw/irdma/type.h  | 1714 ++++++++
 4 files changed, 10021 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/ctrl.c
 create mode 100644 drivers/infiniband/hw/irdma/defs.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma.h
 create mode 100644 drivers/infiniband/hw/irdma/type.h

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
new file mode 100644
index 000000000000..46db672548c1
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -0,0 +1,5985 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
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
+ * irdma_sc_qp_suspend_resume - suspend/resume all qp's on VSI
+ * @vsi: the VSI struct pointer
+ * @op: Set to IRDMA_OP_RESUME or IRDMA_OP_SUSPEND
+ */
+void irdma_sc_suspend_resume_qps(struct irdma_sc_vsi *vsi, u8 op)
+{
+	struct irdma_sc_qp *qp = NULL;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		spin_lock_irqsave(&vsi->qos[i].lock, flags);
+		qp = irdma_get_qp_from_list(&vsi->qos[i].qplist, qp);
+		while (qp) {
+			if (op == IRDMA_OP_RESUME) {
+				if (!irdma_ws_add(vsi, i)) {
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
+		spin_unlock_irqrestore(&vsi->qos[i].lock, flags);
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
+		irdma_reinitialize_ieq(vsi);
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
+	unsigned long flags;
+
+	if (!qp->on_qoslist)
+		return;
+
+	spin_lock_irqsave(&vsi->qos[qp->user_pri].lock, flags);
+	qp->on_qoslist = false;
+	list_del(&qp->list);
+	spin_unlock_irqrestore(&vsi->qos[qp->user_pri].lock, flags);
+	dev_dbg(rfdev_to_dev(qp->dev),
+		"DCB: DCB: Remove qp[%d] UP[%d] qset[%d]\n", qp->qp_uk.qp_id,
+		qp->user_pri, qp->qs_handle);
+}
+
+/**
+ * irdma_qp_add_qos - called during setctx for qp to be added to qos
+ * @qp: qp to be added to qos
+ */
+void irdma_qp_add_qos(struct irdma_sc_qp *qp)
+{
+	struct irdma_sc_vsi *vsi = qp->vsi;
+	unsigned long flags;
+
+	if (qp->on_qoslist)
+		return;
+
+	spin_lock_irqsave(&vsi->qos[qp->user_pri].lock, flags);
+	list_add(&qp->list, &vsi->qos[qp->user_pri].qplist);
+	qp->on_qoslist = true;
+	qp->qs_handle = vsi->qos[qp->user_pri].qs_handle;
+	spin_unlock_irqrestore(&vsi->qos[qp->user_pri].lock, flags);
+	dev_dbg(rfdev_to_dev(qp->dev),
+		"DCB: DCB: Add qp[%d] UP[%d] qset[%d]\n", qp->qp_uk.qp_id,
+		qp->user_pri, qp->qs_handle);
+}
+
+/**
+ * irdma_sc_pd_init - initialize sc pd struct
+ * @dev: sc device struct
+ * @pd: sc pd ptr
+ * @pd_id: pd_id for allocated pd
+ * @abi_ver: ABI version from user context, -1 if not valid
+ */
+static void irdma_sc_pd_init(struct irdma_sc_dev *dev, struct irdma_sc_pd *pd,
+			     u32 pd_id, int abi_ver)
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
+	u64 temp, hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 8, info->reach_max);
+
+	temp = info->mac_addr[5] | LS_64_1(info->mac_addr[4], 8) |
+	       LS_64_1(info->mac_addr[3], 16) | LS_64_1(info->mac_addr[2], 24) |
+	       LS_64_1(info->mac_addr[1], 32) | LS_64_1(info->mac_addr[0], 40);
+	set_64bit_val(wqe, 16, temp);
+
+	hdr = info->arp_index |
+	      LS_64(IRDMA_CQP_OP_MANAGE_ARP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64((info->permanent ? 1 : 0), IRDMA_CQPSQ_MAT_PERMANENT) |
+	      LS_64(1, IRDMA_CQPSQ_MAT_ENTRYVALID) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "ARP_CACHE_ENTRY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	hdr = arp_index | LS_64(IRDMA_CQP_OP_MANAGE_ARP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "ARP_CACHE_DEL_ENTRY WQE",
+			wqe, IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_query_arp_cache_entry - cqp wqe to query arp and arp index
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @arp_index: arp index to delete arp entry
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_query_arp_cache_entry(struct irdma_sc_cqp *cqp, u64 scratch,
+			       u16 arp_index, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	hdr = arp_index | LS_64(IRDMA_CQP_OP_MANAGE_ARP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_MAT_QUERY) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QUERY_ARP_CACHE_ENTRY WQE",
+			wqe, IRDMA_CQP_WQE_SIZE * 8);
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
+	hdr = LS_64(IRDMA_CQP_OP_MANAGE_APBVT, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->add, IRDMA_CQPSQ_MAPT_ADDPORT) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_APBVT WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	temp = info->mac_addr[5] | LS_64_1(info->mac_addr[4], 8) |
+	       LS_64_1(info->mac_addr[3], 16) | LS_64_1(info->mac_addr[2], 24) |
+	       LS_64_1(info->mac_addr[1], 32) | LS_64_1(info->mac_addr[0], 40);
+	set_64bit_val(wqe, 0, temp);
+
+	qw1 = LS_64(info->qp_num, IRDMA_CQPSQ_QHASH_QPN) |
+	      LS_64(info->dest_port, IRDMA_CQPSQ_QHASH_DEST_PORT);
+	if (info->ipv4_valid) {
+		set_64bit_val(wqe, 48,
+			      LS_64(info->dest_ip[0], IRDMA_CQPSQ_QHASH_ADDR3));
+	} else {
+		set_64bit_val(wqe, 56,
+			      LS_64(info->dest_ip[0], IRDMA_CQPSQ_QHASH_ADDR0) |
+			      LS_64(info->dest_ip[1], IRDMA_CQPSQ_QHASH_ADDR1));
+
+		set_64bit_val(wqe, 48,
+			      LS_64(info->dest_ip[2], IRDMA_CQPSQ_QHASH_ADDR2) |
+			      LS_64(info->dest_ip[3], IRDMA_CQPSQ_QHASH_ADDR3));
+	}
+	qw2 = LS_64(vsi->qos[info->user_pri].qs_handle,
+		    IRDMA_CQPSQ_QHASH_QS_HANDLE);
+	if (info->vlan_valid)
+		qw2 |= LS_64(info->vlan_id, IRDMA_CQPSQ_QHASH_VLANID);
+	set_64bit_val(wqe, 16, qw2);
+	if (info->entry_type == IRDMA_QHASH_TYPE_TCP_ESTABLISHED) {
+		qw1 |= LS_64(info->src_port, IRDMA_CQPSQ_QHASH_SRC_PORT);
+		if (!info->ipv4_valid) {
+			set_64bit_val(wqe, 40,
+				      LS_64(info->src_ip[0], IRDMA_CQPSQ_QHASH_ADDR0) |
+				      LS_64(info->src_ip[1], IRDMA_CQPSQ_QHASH_ADDR1));
+			set_64bit_val(wqe, 32,
+				      LS_64(info->src_ip[2], IRDMA_CQPSQ_QHASH_ADDR2) |
+				      LS_64(info->src_ip[3], IRDMA_CQPSQ_QHASH_ADDR3));
+		} else {
+			set_64bit_val(wqe, 32,
+				      LS_64(info->src_ip[0], IRDMA_CQPSQ_QHASH_ADDR3));
+		}
+	}
+
+	set_64bit_val(wqe, 8, qw1);
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_QHASH_WQEVALID) |
+	       LS_64(IRDMA_CQP_OP_MANAGE_QUAD_HASH_TABLE_ENTRY,
+		     IRDMA_CQPSQ_QHASH_OPCODE) |
+	       LS_64(info->manage, IRDMA_CQPSQ_QHASH_MANAGE) |
+	       LS_64(info->ipv4_valid, IRDMA_CQPSQ_QHASH_IPV4VALID) |
+	       LS_64(info->vlan_valid, IRDMA_CQPSQ_QHASH_VLANVALID) |
+	       LS_64(info->entry_type, IRDMA_CQPSQ_QHASH_ENTRYTYPE);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_QHASH WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cqp_nop - send a nop wqe
+ * @cqp: struct for cqp hw
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_cqp_nop(struct irdma_sc_cqp *cqp,
+					       u64 scratch, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	hdr = LS_64(IRDMA_CQP_OP_NOP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "NOP WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code irdma_sc_qp_init(struct irdma_sc_qp *qp,
+					       struct irdma_qp_init_info *info)
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
+	ret_code = irdma_qp_uk_init(&qp->qp_uk, &info->qp_uk_init_info);
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
+	qp->qp_type = info->type ? info->type : IRDMA_QP_TYPE_IWARP;
+	qp->hw_sq_size = irdma_get_encoded_wqe_size(qp->qp_uk.sq_ring.size, false);
+	dev_dbg(rfdev_to_dev(qp->dev),
+		"WQE: hw_sq_size[%04d] sq_ring.size[%04d]\n", qp->hw_sq_size,
+		qp->qp_uk.sq_ring.size);
+	if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1 && qp->pd->abi_ver > 4)
+		wqe_size = IRDMA_WQE_SIZE_128;
+	else
+		ret_code = irdma_fragcnt_to_wqesize_rq(qp->qp_uk.max_rq_frag_cnt,
+						       &wqe_size);
+	if (ret_code)
+		return ret_code;
+
+	qp->hw_rq_size = irdma_get_encoded_wqe_size(qp->qp_uk.rq_size *
+				(wqe_size / IRDMA_QP_WQE_MIN_SIZE), false);
+	dev_dbg(rfdev_to_dev(qp->dev),
+		"WQE: hw_rq_size[%04d] qp_uk.rq_size[%04d] wqe_size[%04d]\n",
+		qp->hw_rq_size, qp->qp_uk.rq_size, wqe_size);
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
+static enum irdma_status_code
+irdma_sc_qp_create(struct irdma_sc_qp *qp, struct irdma_create_qp_info *info,
+		   u64 scratch, bool post_sq)
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
+	      LS_64(IRDMA_CQP_OP_CREATE_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64((info->ord_valid ? 1 : 0), IRDMA_CQPSQ_QP_ORDVALID) |
+	      LS_64(info->tcp_ctx_valid, IRDMA_CQPSQ_QP_TOECTXVALID) |
+	      LS_64(info->mac_valid, IRDMA_CQPSQ_QP_MACVALID) |
+	      LS_64(qp->qp_type, IRDMA_CQPSQ_QP_QPTYPE) |
+	      LS_64(qp->virtual_map, IRDMA_CQPSQ_QP_VQ) |
+	      LS_64(info->force_lpb, IRDMA_CQPSQ_QP_FORCELOOPBACK) |
+	      LS_64(info->cq_num_valid, IRDMA_CQPSQ_QP_CQNUMVALID) |
+	      LS_64(info->arp_cache_idx_valid, IRDMA_CQPSQ_QP_ARPTABIDXVALID) |
+	      LS_64(info->next_iwarp_state, IRDMA_CQPSQ_QP_NEXTIWSTATE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QP_CREATE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code
+irdma_sc_qp_modify(struct irdma_sc_qp *qp, struct irdma_modify_qp_info *info,
+		   u64 scratch, bool post_sq)
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
+		      LS_64(info->new_mss, IRDMA_CQPSQ_QP_NEWMSS) |
+		      LS_64(term_len, IRDMA_CQPSQ_QP_TERMLEN));
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      LS_64(IRDMA_CQP_OP_MODIFY_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->ord_valid, IRDMA_CQPSQ_QP_ORDVALID) |
+	      LS_64(info->tcp_ctx_valid, IRDMA_CQPSQ_QP_TOECTXVALID) |
+	      LS_64(info->cached_var_valid, IRDMA_CQPSQ_QP_CACHEDVARVALID) |
+	      LS_64(qp->virtual_map, IRDMA_CQPSQ_QP_VQ) |
+	      LS_64(info->force_lpb, IRDMA_CQPSQ_QP_FORCELOOPBACK) |
+	      LS_64(info->cq_num_valid, IRDMA_CQPSQ_QP_CQNUMVALID) |
+	      LS_64(info->force_lpb, IRDMA_CQPSQ_QP_FORCELOOPBACK) |
+	      LS_64(info->mac_valid, IRDMA_CQPSQ_QP_MACVALID) |
+	      LS_64(qp->qp_type, IRDMA_CQPSQ_QP_QPTYPE) |
+	      LS_64(info->mss_change, IRDMA_CQPSQ_QP_MSSCHANGE) |
+	      LS_64(info->remove_hash_idx, IRDMA_CQPSQ_QP_REMOVEHASHENTRY) |
+	      LS_64(term_actions, IRDMA_CQPSQ_QP_TERMACT) |
+	      LS_64(info->reset_tcp_conn, IRDMA_CQPSQ_QP_RESETCON) |
+	      LS_64(info->arp_cache_idx_valid, IRDMA_CQPSQ_QP_ARPTABIDXVALID) |
+	      LS_64(info->next_iwarp_state, IRDMA_CQPSQ_QP_NEXTIWSTATE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QP_MODIFY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code
+irdma_sc_qp_destroy(struct irdma_sc_qp *qp, u64 scratch, bool remove_hash_idx,
+		    bool ignore_mw_bnd, bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+
+	irdma_qp_rem_qos(qp);
+	cqp = qp->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      LS_64(IRDMA_CQP_OP_DESTROY_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(qp->qp_type, IRDMA_CQPSQ_QP_QPTYPE) |
+	      LS_64(ignore_mw_bnd, IRDMA_CQPSQ_QP_IGNOREMWBOUND) |
+	      LS_64(remove_hash_idx, IRDMA_CQPSQ_QP_REMOVEHASHENTRY) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QP_DESTROY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_setctx_roce - set qp's context
+ * @qp: sc qp
+ * @qp_ctx: context ptr
+ * @info: ctx info
+ */
+static enum irdma_status_code
+irdma_sc_qp_setctx_roce(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+			struct irdma_qp_host_ctx_info *info)
+{
+	struct irdma_roce_offload_info *roce_info;
+	struct irdma_udp_offload_info *udp;
+	u8 push_mode_en;
+	u16 push_idx;
+	u64 mac;
+
+	roce_info = info->roce_info;
+	udp = info->udp_info;
+
+	mac = LS_64_1(roce_info->mac_addr[5], 16) |
+	      LS_64_1(roce_info->mac_addr[4], 24) |
+	      LS_64_1(roce_info->mac_addr[3], 32) |
+	      LS_64_1(roce_info->mac_addr[2], 40) |
+	      LS_64_1(roce_info->mac_addr[1], 48) |
+	      LS_64_1(roce_info->mac_addr[0], 56);
+
+	qp->user_pri = info->user_pri;
+	if (info->add_to_qoslist)
+		irdma_qp_add_qos(qp);
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX) {
+		push_mode_en = 0;
+		push_idx = 0;
+	} else {
+		push_mode_en = 1;
+		push_idx = qp->push_idx;
+	}
+	set_64bit_val(qp_ctx, 0,
+		      LS_64(qp->qp_uk.rq_wqe_size, IRDMAQPC_RQWQESIZE) |
+		      LS_64(qp->rcv_tph_en, IRDMAQPC_RCVTPHEN) |
+		      LS_64(qp->xmit_tph_en, IRDMAQPC_XMITTPHEN) |
+		      LS_64(qp->rq_tph_en, IRDMAQPC_RQTPHEN) |
+		      LS_64(qp->sq_tph_en, IRDMAQPC_SQTPHEN) |
+		      LS_64(push_idx, IRDMAQPC_PPIDX) |
+		      LS_64(push_mode_en, IRDMAQPC_PMENA) |
+		      LS_64(roce_info->pd_id >> 16, IRDMAQPC_PDIDXHI) |
+		      LS_64(roce_info->dctcp_en, IRDMAQPC_DC_TCP_EN) |
+		      LS_64(roce_info->err_rq_idx_valid, IRDMAQPC_ERR_RQ_IDX_VALID) |
+		      LS_64(roce_info->is_qp1, IRDMAQPC_ISQP1) |
+		      LS_64(roce_info->roce_tver, IRDMAQPC_ROCE_TVER) |
+		      LS_64(udp->ipv4, IRDMAQPC_IPV4) |
+		      LS_64(udp->insert_vlan_tag, IRDMAQPC_INSERTVLANTAG));
+	set_64bit_val(qp_ctx, 8, qp->sq_pa);
+	set_64bit_val(qp_ctx, 16, qp->rq_pa);
+	if ((roce_info->dcqcn_en || roce_info->dctcp_en) &&
+	    !(udp->tos & 0x03))
+		udp->tos |= ECN_CODE_PT_VAL;
+	set_64bit_val(qp_ctx, 24,
+		      LS_64(qp->hw_rq_size, IRDMAQPC_RQSIZE) |
+		      LS_64(qp->hw_sq_size, IRDMAQPC_SQSIZE) |
+		      LS_64(udp->ttl, IRDMAQPC_TTL) | LS_64(udp->tos, IRDMAQPC_TOS) |
+		      LS_64(udp->src_port, IRDMAQPC_SRCPORTNUM) |
+		      LS_64(udp->dst_port, IRDMAQPC_DESTPORTNUM));
+	set_64bit_val(qp_ctx, 32,
+		      LS_64(udp->dest_ip_addr2, IRDMAQPC_DESTIPADDR2) |
+		      LS_64(udp->dest_ip_addr3, IRDMAQPC_DESTIPADDR3));
+	set_64bit_val(qp_ctx, 40,
+		      LS_64(udp->dest_ip_addr0, IRDMAQPC_DESTIPADDR0) |
+		      LS_64(udp->dest_ip_addr1, IRDMAQPC_DESTIPADDR1));
+	set_64bit_val(qp_ctx, 48,
+		      LS_64(udp->snd_mss, IRDMAQPC_SNDMSS) |
+		      LS_64(udp->vlan_tag, IRDMAQPC_VLANTAG) |
+		      LS_64(udp->arp_idx, IRDMAQPC_ARPIDX));
+	set_64bit_val(qp_ctx, 56,
+		      LS_64(roce_info->p_key, IRDMAQPC_PKEY) |
+		      LS_64(roce_info->pd_id, IRDMAQPC_PDIDX) |
+		      LS_64(roce_info->ack_credits, IRDMAQPC_ACKCREDITS) |
+		      LS_64(udp->flow_label, IRDMAQPC_FLOWLABEL));
+	set_64bit_val(qp_ctx, 64,
+		      LS_64(roce_info->qkey, IRDMAQPC_QKEY) |
+		      LS_64(roce_info->dest_qp, IRDMAQPC_DESTQP));
+	set_64bit_val(qp_ctx, 80,
+		      LS_64(udp->psn_nxt, IRDMAQPC_PSNNXT) |
+		      LS_64(udp->lsn, IRDMAQPC_LSN));
+	set_64bit_val(qp_ctx, 88, LS_64(udp->epsn, IRDMAQPC_EPSN));
+	set_64bit_val(qp_ctx, 96,
+		      LS_64(udp->psn_max, IRDMAQPC_PSNMAX) |
+		      LS_64(udp->psn_una, IRDMAQPC_PSNUNA));
+	set_64bit_val(qp_ctx, 112,
+		      LS_64(udp->cwnd, IRDMAQPC_CWNDROCE));
+	set_64bit_val(qp_ctx, 128,
+		      LS_64(roce_info->err_rq_idx, IRDMAQPC_ERR_RQ_IDX) |
+		      LS_64(udp->rnr_nak_thresh, IRDMAQPC_RNRNAK_THRESH) |
+		      LS_64(udp->rexmit_thresh, IRDMAQPC_REXMIT_THRESH));
+	set_64bit_val(qp_ctx, 136,
+		      LS_64(info->send_cq_num, IRDMAQPC_TXCQNUM) |
+		      LS_64(info->rcv_cq_num, IRDMAQPC_RXCQNUM));
+	set_64bit_val(qp_ctx, 144,
+		      LS_64(info->stats_idx, IRDMAQPC_STAT_INDEX));
+	set_64bit_val(qp_ctx, 152, mac);
+	set_64bit_val(qp_ctx, 160,
+		      LS_64(roce_info->ord_size, IRDMAQPC_ORDSIZE) |
+		      LS_64(roce_info->ird_size, IRDMAQPC_IRDSIZE) |
+		      LS_64(roce_info->wr_rdresp_en, IRDMAQPC_WRRDRSPOK) |
+		      LS_64(roce_info->rd_en, IRDMAQPC_RDOK) |
+		      LS_64(info->stats_idx_valid, IRDMAQPC_USESTATSINSTANCE) |
+		      LS_64(roce_info->bind_en, IRDMAQPC_BINDEN) |
+		      LS_64(roce_info->fast_reg_en, IRDMAQPC_FASTREGEN) |
+		      LS_64(roce_info->dcqcn_en, IRDMAQPC_DCQCNENABLE) |
+		      LS_64(roce_info->rcv_no_icrc, IRDMAQPC_RCVNOICRC) |
+		      LS_64(roce_info->fw_cc_enable, IRDMAQPC_FW_CC_ENABLE) |
+		      LS_64(roce_info->udprivcq_en, IRDMAQPC_UDPRIVCQENABLE) |
+		      LS_64(roce_info->priv_mode_en, IRDMAQPC_PRIVEN) |
+		      LS_64(roce_info->timely_en, IRDMAQPC_TIMELYENABLE));
+	set_64bit_val(qp_ctx, 168,
+		      LS_64(info->qp_compl_ctx, IRDMAQPC_QPCOMPCTX));
+	set_64bit_val(qp_ctx, 176,
+		      LS_64(qp->sq_tph_val, IRDMAQPC_SQTPHVAL) |
+		      LS_64(qp->rq_tph_val, IRDMAQPC_RQTPHVAL) |
+		      LS_64(qp->qs_handle, IRDMAQPC_QSHANDLE));
+	set_64bit_val(qp_ctx, 184,
+		      LS_64(udp->local_ipaddr3, IRDMAQPC_LOCAL_IPADDR3) |
+		      LS_64(udp->local_ipaddr2, IRDMAQPC_LOCAL_IPADDR2));
+	set_64bit_val(qp_ctx, 192,
+		      LS_64(udp->local_ipaddr1, IRDMAQPC_LOCAL_IPADDR1) |
+		      LS_64(udp->local_ipaddr0, IRDMAQPC_LOCAL_IPADDR0));
+	set_64bit_val(qp_ctx, 200,
+		      LS_64(roce_info->t_high, IRDMAQPC_THIGH) |
+		      LS_64(roce_info->t_low, IRDMAQPC_TLOW));
+	set_64bit_val(qp_ctx, 208,
+		      LS_64(info->rem_endpoint_idx, IRDMAQPC_REMENDPOINTIDX));
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "QP_HOST CTX WQE", qp_ctx,
+			IRDMA_QP_CTX_SIZE);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_alloc_local_mac_entry - allocate a mac entry
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
+	wqe = cqp->dev->cqp_ops->cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	hdr = LS_64(IRDMA_CQP_OP_ALLOCATE_LOC_MAC_TABLE_ENTRY,
+		    IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "ALLOCATE_LOCAL_MAC WQE",
+			wqe, IRDMA_CQP_WQE_SIZE * 8);
+
+	if (post_sq)
+		cqp->dev->cqp_ops->cqp_post_sq(cqp);
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
+	u64 temp, header;
+
+	wqe = cqp->dev->cqp_ops->cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	temp = info->mac_addr[5] | LS_64_1(info->mac_addr[4], 8) |
+	       LS_64_1(info->mac_addr[3], 16) | LS_64_1(info->mac_addr[2], 24) |
+	       LS_64_1(info->mac_addr[1], 32) | LS_64_1(info->mac_addr[0], 40);
+
+	set_64bit_val(wqe, 32, temp);
+
+	header = LS_64(info->entry_idx, IRDMA_CQPSQ_MLM_TABLEIDX) |
+		 LS_64(IRDMA_CQP_OP_MANAGE_LOC_MAC_TABLE, IRDMA_CQPSQ_OPCODE) |
+		 LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, header);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "ADD_LOCAL_MAC WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+
+	if (post_sq)
+		cqp->dev->cqp_ops->cqp_post_sq(cqp);
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
+	wqe = cqp->dev->cqp_ops->cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	header = LS_64(entry_idx, IRDMA_CQPSQ_MLM_TABLEIDX) |
+		 LS_64(IRDMA_CQP_OP_MANAGE_LOC_MAC_TABLE, IRDMA_CQPSQ_OPCODE) |
+		 LS_64(1, IRDMA_CQPSQ_MLM_FREEENTRY) |
+		 LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID) |
+		 LS_64(ignore_ref_count, IRDMA_CQPSQ_MLM_IGNORE_REF_CNT);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, header);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "DEL_LOCAL_MAC_IPADDR WQE",
+			wqe, IRDMA_CQP_WQE_SIZE * 8);
+
+	if (post_sq)
+		cqp->dev->cqp_ops->cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_qp_setctx - set qp's context
+ * @qp: sc qp
+ * @qp_ctx: context ptr
+ * @info: ctx info
+ */
+static enum irdma_status_code
+irdma_sc_qp_setctx(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+		   struct irdma_qp_host_ctx_info *info)
+{
+	struct irdma_iwarp_offload_info *iw;
+	struct irdma_tcp_offload_info *tcp;
+	struct irdma_sc_dev *dev;
+	u8 push_mode_en;
+	u16 push_idx;
+	u64 qw0, qw3, qw7 = 0;
+	u64 mac = 0;
+
+	iw = info->iwarp_info;
+	tcp = info->tcp_info;
+	dev = qp->dev;
+
+	if (dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		mac = LS_64_1(iw->mac_addr[5], 16) |
+		      LS_64_1(iw->mac_addr[4], 24) |
+		      LS_64_1(iw->mac_addr[3], 32) |
+		      LS_64_1(iw->mac_addr[2], 40) |
+		      LS_64_1(iw->mac_addr[1], 48) |
+		      LS_64_1(iw->mac_addr[0], 56);
+	}
+
+	qp->user_pri = info->user_pri;
+	if (info->add_to_qoslist)
+		irdma_qp_add_qos(qp);
+
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX) {
+		push_mode_en = 0;
+		push_idx = 0;
+	} else {
+		push_mode_en = 1;
+		push_idx = qp->push_idx;
+	}
+	qw0 = LS_64(qp->qp_uk.rq_wqe_size, IRDMAQPC_RQWQESIZE) |
+	      LS_64(iw->err_rq_idx_valid, IRDMAQPC_ERR_RQ_IDX_VALID) |
+	      LS_64(qp->rcv_tph_en, IRDMAQPC_RCVTPHEN) |
+	      LS_64(qp->xmit_tph_en, IRDMAQPC_XMITTPHEN) |
+	      LS_64(qp->rq_tph_en, IRDMAQPC_RQTPHEN) |
+	      LS_64(qp->sq_tph_en, IRDMAQPC_SQTPHEN) |
+	      LS_64(push_idx, IRDMAQPC_PPIDX) |
+	      LS_64(push_mode_en, IRDMAQPC_PMENA) |
+	      LS_64(iw->ib_rd_en, IRDMAQPC_IBRDENABLE) |
+	      LS_64(iw->pd_id >> 16, IRDMAQPC_PDIDXHI);
+
+	set_64bit_val(qp_ctx, 8, qp->sq_pa);
+	set_64bit_val(qp_ctx, 16, qp->rq_pa);
+
+	qw3 = LS_64(qp->hw_rq_size, IRDMAQPC_RQSIZE) |
+	      LS_64(qp->hw_sq_size, IRDMAQPC_SQSIZE);
+	if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		qw3 |= LS_64(qp->src_mac_addr_idx, IRDMAQPC_GEN1_SRCMACADDRIDX);
+	set_64bit_val(qp_ctx, 128,
+		      LS_64(iw->err_rq_idx, IRDMAQPC_ERR_RQ_IDX));
+	set_64bit_val(qp_ctx, 136,
+		      LS_64(info->send_cq_num, IRDMAQPC_TXCQNUM) |
+		      LS_64(info->rcv_cq_num, IRDMAQPC_RXCQNUM));
+	set_64bit_val(qp_ctx, 168,
+		      LS_64(info->qp_compl_ctx, IRDMAQPC_QPCOMPCTX));
+	set_64bit_val(qp_ctx, 176,
+		      LS_64(qp->sq_tph_val, IRDMAQPC_SQTPHVAL) |
+		      LS_64(qp->rq_tph_val, IRDMAQPC_RQTPHVAL) |
+		      LS_64(qp->qs_handle, IRDMAQPC_QSHANDLE) |
+		      LS_64(qp->ieq_qp, IRDMAQPC_EXCEPTION_LAN_QUEUE));
+	if (info->iwarp_info_valid) {
+		qw0 |= LS_64(iw->ddp_ver, IRDMAQPC_DDP_VER) |
+		       LS_64(iw->rdmap_ver, IRDMAQPC_RDMAP_VER) |
+		       LS_64(iw->dctcp_en, IRDMAQPC_DC_TCP_EN) |
+		       LS_64(iw->ecn_en, IRDMAQPC_ECN_EN);
+		qw7 |= LS_64(iw->pd_id, IRDMAQPC_PDIDX);
+		set_64bit_val(qp_ctx, 144,
+			      LS_64(qp->q2_pa >> 8, IRDMAQPC_Q2ADDR) |
+			      LS_64(info->stats_idx, IRDMAQPC_STAT_INDEX));
+		set_64bit_val(qp_ctx, 152,
+			      mac | LS_64(iw->last_byte_sent, IRDMAQPC_LASTBYTESENT));
+		set_64bit_val(qp_ctx, 160,
+			      LS_64(iw->ord_size, IRDMAQPC_ORDSIZE) |
+			      LS_64(iw->ird_size, IRDMAQPC_IRDSIZE) |
+			      LS_64(iw->wr_rdresp_en, IRDMAQPC_WRRDRSPOK) |
+			      LS_64(iw->rd_en, IRDMAQPC_RDOK) |
+			      LS_64(iw->snd_mark_en, IRDMAQPC_SNDMARKERS) |
+			      LS_64(iw->bind_en, IRDMAQPC_BINDEN) |
+			      LS_64(iw->fast_reg_en, IRDMAQPC_FASTREGEN) |
+			      LS_64(iw->priv_mode_en, IRDMAQPC_PRIVEN) |
+			      LS_64(info->stats_idx_valid, IRDMAQPC_USESTATSINSTANCE) |
+			      LS_64(1, IRDMAQPC_IWARPMODE) |
+			      LS_64(iw->rcv_mark_en, IRDMAQPC_RCVMARKERS) |
+			      LS_64(iw->align_hdrs, IRDMAQPC_ALIGNHDRS) |
+			      LS_64(iw->rcv_no_mpa_crc, IRDMAQPC_RCVNOMPACRC) |
+			      LS_64(iw->rcv_mark_offset || !tcp ? iw->rcv_mark_offset : tcp->rcv_nxt, IRDMAQPC_RCVMARKOFFSET) |
+			      LS_64(iw->snd_mark_offset || !tcp ? iw->snd_mark_offset : tcp->snd_nxt, IRDMAQPC_SNDMARKOFFSET) |
+			      LS_64(iw->timely_en, IRDMAQPC_TIMELYENABLE));
+	}
+	if (info->tcp_info_valid) {
+		qw0 |= LS_64(tcp->ipv4, IRDMAQPC_IPV4) |
+		       LS_64(tcp->no_nagle, IRDMAQPC_NONAGLE) |
+		       LS_64(tcp->insert_vlan_tag, IRDMAQPC_INSERTVLANTAG) |
+		       LS_64(tcp->time_stamp, IRDMAQPC_TIMESTAMP) |
+		       LS_64(tcp->cwnd_inc_limit, IRDMAQPC_LIMIT) |
+		       LS_64(tcp->drop_ooo_seg, IRDMAQPC_DROPOOOSEG) |
+		       LS_64(tcp->dup_ack_thresh, IRDMAQPC_DUPACK_THRESH);
+
+		if ((iw->ecn_en || iw->dctcp_en) && !(tcp->tos & 0x03))
+			tcp->tos |= ECN_CODE_PT_VAL;
+
+		qw3 |= LS_64(tcp->ttl, IRDMAQPC_TTL) |
+		       LS_64(tcp->avoid_stretch_ack, IRDMAQPC_AVOIDSTRETCHACK) |
+		       LS_64(tcp->tos, IRDMAQPC_TOS) |
+		       LS_64(tcp->src_port, IRDMAQPC_SRCPORTNUM) |
+		       LS_64(tcp->dst_port, IRDMAQPC_DESTPORTNUM);
+		if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1) {
+			qw3 |= LS_64(tcp->src_mac_addr_idx,
+				     IRDMAQPC_GEN1_SRCMACADDRIDX);
+
+			qp->src_mac_addr_idx = tcp->src_mac_addr_idx;
+		}
+		set_64bit_val(qp_ctx, 32,
+			      LS_64(tcp->dest_ip_addr2, IRDMAQPC_DESTIPADDR2) |
+			      LS_64(tcp->dest_ip_addr3, IRDMAQPC_DESTIPADDR3));
+		set_64bit_val(qp_ctx, 40,
+			      LS_64(tcp->dest_ip_addr0, IRDMAQPC_DESTIPADDR0) |
+			      LS_64(tcp->dest_ip_addr1, IRDMAQPC_DESTIPADDR1));
+		set_64bit_val(qp_ctx, 48,
+			      LS_64(tcp->snd_mss, IRDMAQPC_SNDMSS) |
+			      LS_64(tcp->syn_rst_handling, IRDMAQPC_SYN_RST_HANDLING) |
+			      LS_64(tcp->vlan_tag, IRDMAQPC_VLANTAG) |
+			      LS_64(tcp->arp_idx, IRDMAQPC_ARPIDX));
+		qw7 |= LS_64(tcp->flow_label, IRDMAQPC_FLOWLABEL) |
+		       LS_64(tcp->wscale, IRDMAQPC_WSCALE) |
+		       LS_64(tcp->ignore_tcp_opt, IRDMAQPC_IGNORE_TCP_OPT) |
+		       LS_64(tcp->ignore_tcp_uns_opt,
+			     IRDMAQPC_IGNORE_TCP_UNS_OPT) |
+		       LS_64(tcp->tcp_state, IRDMAQPC_TCPSTATE) |
+		       LS_64(tcp->rcv_wscale, IRDMAQPC_RCVSCALE) |
+		       LS_64(tcp->snd_wscale, IRDMAQPC_SNDSCALE);
+		set_64bit_val(qp_ctx, 72,
+			      LS_64(tcp->time_stamp_recent, IRDMAQPC_TIMESTAMP_RECENT) |
+			      LS_64(tcp->time_stamp_age, IRDMAQPC_TIMESTAMP_AGE));
+		set_64bit_val(qp_ctx, 80,
+			      LS_64(tcp->snd_nxt, IRDMAQPC_SNDNXT) |
+			      LS_64(tcp->snd_wnd, IRDMAQPC_SNDWND));
+		set_64bit_val(qp_ctx, 88,
+			      LS_64(tcp->rcv_nxt, IRDMAQPC_RCVNXT) |
+			      LS_64(tcp->rcv_wnd, IRDMAQPC_RCVWND));
+		set_64bit_val(qp_ctx, 96,
+			      LS_64(tcp->snd_max, IRDMAQPC_SNDMAX) |
+			      LS_64(tcp->snd_una, IRDMAQPC_SNDUNA));
+		set_64bit_val(qp_ctx, 104,
+			      LS_64(tcp->srtt, IRDMAQPC_SRTT) |
+			      LS_64(tcp->rtt_var, IRDMAQPC_RTTVAR));
+		set_64bit_val(qp_ctx, 112,
+			      LS_64(tcp->ss_thresh, IRDMAQPC_SSTHRESH) |
+			      LS_64(tcp->cwnd, IRDMAQPC_CWND));
+		set_64bit_val(qp_ctx, 120,
+			      LS_64(tcp->snd_wl1, IRDMAQPC_SNDWL1) |
+			      LS_64(tcp->snd_wl2, IRDMAQPC_SNDWL2));
+		set_64bit_val(qp_ctx, 128,
+			      LS_64(tcp->max_snd_window, IRDMAQPC_MAXSNDWND) |
+			      LS_64(tcp->rexmit_thresh, IRDMAQPC_REXMIT_THRESH));
+		set_64bit_val(qp_ctx, 184,
+			      LS_64(tcp->local_ipaddr3, IRDMAQPC_LOCAL_IPADDR3) |
+			      LS_64(tcp->local_ipaddr2, IRDMAQPC_LOCAL_IPADDR2));
+		set_64bit_val(qp_ctx, 192,
+			      LS_64(tcp->local_ipaddr1, IRDMAQPC_LOCAL_IPADDR1) |
+			      LS_64(tcp->local_ipaddr0, IRDMAQPC_LOCAL_IPADDR0));
+		set_64bit_val(qp_ctx, 200,
+			      LS_64(iw->t_high, IRDMAQPC_THIGH) |
+			      LS_64(iw->t_low, IRDMAQPC_TLOW));
+		set_64bit_val(qp_ctx, 208,
+			      LS_64(info->rem_endpoint_idx, IRDMAQPC_REMENDPOINTIDX));
+	}
+
+	set_64bit_val(qp_ctx, 0, qw0);
+	set_64bit_val(qp_ctx, 24, qw3);
+	set_64bit_val(qp_ctx, 56, qw7);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "QP_HOST CTX", qp_ctx,
+			IRDMA_QP_CTX_SIZE);
+
+	return 0;
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
+		      LS_64(info->total_len, IRDMA_CQPSQ_STAG_STAGLEN));
+	set_64bit_val(wqe, 16,
+		      LS_64(info->stag_idx, IRDMA_CQPSQ_STAG_IDX));
+	set_64bit_val(wqe, 40,
+		      LS_64(info->hmc_fcn_index, IRDMA_CQPSQ_STAG_HMCFNIDX));
+
+	if (info->chunk_size)
+		set_64bit_val(wqe, 48,
+			      LS_64(info->first_pm_pbl_idx, IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX));
+
+	hdr = LS_64(IRDMA_CQP_OP_ALLOC_STAG, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_STAG_MR) |
+	      LS_64(info->access_rights, IRDMA_CQPSQ_STAG_ARIGHTS) |
+	      LS_64(info->chunk_size, IRDMA_CQPSQ_STAG_LPBLSIZE) |
+	      LS_64(page_size, IRDMA_CQPSQ_STAG_HPAGESIZE) |
+	      LS_64(info->remote_access, IRDMA_CQPSQ_STAG_REMACCENABLED) |
+	      LS_64(info->use_hmc_fcn_index, IRDMA_CQPSQ_STAG_USEHMCFNIDX) |
+	      LS_64(info->use_pf_rid, IRDMA_CQPSQ_STAG_USEPFRID) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "ALLOC_STAG WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	u64 temp;
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
+	else
+		page_size = IRDMA_PAGE_SIZE_4K;
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
+
+	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
+		(uintptr_t)info->va : info->fbo;
+
+	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 8,
+		      LS_64(info->total_len, IRDMA_CQPSQ_STAG_STAGLEN) |
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID));
+	set_64bit_val(wqe, 16,
+		      LS_64(info->stag_key, IRDMA_CQPSQ_STAG_KEY) |
+		      LS_64(info->stag_idx, IRDMA_CQPSQ_STAG_IDX));
+	if (!info->chunk_size) {
+		set_64bit_val(wqe, 32, info->reg_addr_pa);
+		set_64bit_val(wqe, 48, 0);
+	} else {
+		set_64bit_val(wqe, 32, 0);
+		set_64bit_val(wqe, 48,
+			      LS_64(info->first_pm_pbl_index, IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX));
+	}
+	set_64bit_val(wqe, 40, info->hmc_fcn_index);
+	set_64bit_val(wqe, 56, 0);
+
+	addr_type = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ? 1 : 0;
+	hdr = LS_64(IRDMA_CQP_OP_REG_MR, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_STAG_MR) |
+	      LS_64(info->chunk_size, IRDMA_CQPSQ_STAG_LPBLSIZE) |
+	      LS_64(page_size, IRDMA_CQPSQ_STAG_HPAGESIZE) |
+	      LS_64(info->access_rights, IRDMA_CQPSQ_STAG_ARIGHTS) |
+	      LS_64(remote_access, IRDMA_CQPSQ_STAG_REMACCENABLED) |
+	      LS_64(addr_type, IRDMA_CQPSQ_STAG_VABASEDTO) |
+	      LS_64(info->use_hmc_fcn_index, IRDMA_CQPSQ_STAG_USEHMCFNIDX) |
+	      LS_64(info->use_pf_rid, IRDMA_CQPSQ_STAG_USEPFRID) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "MR_REG_NS WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_mr_reg_shared - registered shared memory region
+ * @dev: sc device struct
+ * @info: info for shared memory registration
+ * @scratch: u64 saved to be used during cqp completion
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code
+irdma_sc_mr_reg_shared(struct irdma_sc_dev *dev,
+		       struct irdma_register_shared_stag *info, u64 scratch,
+		       bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 temp, va64, fbo, hdr;
+	u32 va32;
+	bool remote_access;
+	u8 addr_type;
+
+	if (info->access_rights & (IRDMA_ACCESS_FLAGS_REMOTEREAD_ONLY |
+				   IRDMA_ACCESS_FLAGS_REMOTEWRITE_ONLY))
+		remote_access = true;
+	else
+		remote_access = false;
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	va64 = (uintptr_t)(info->va);
+	va32 = (u32)(va64 & 0x00000000FFFFFFFF);
+	fbo = (u64)(va32 & (4096 - 1));
+
+	set_64bit_val(wqe, 0,
+		      (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED ?
+		       (uintptr_t)info->va : fbo));
+	set_64bit_val(wqe, 8,
+		      FLD_LS_64(dev, info->pd_id, IRDMA_CQPSQ_STAG_PDID));
+	temp = LS_64(info->new_stag_key, IRDMA_CQPSQ_STAG_KEY) |
+	       LS_64(info->new_stag_idx, IRDMA_CQPSQ_STAG_IDX) |
+	       LS_64(info->parent_stag_idx, IRDMA_CQPSQ_STAG_PARENTSTAGIDX);
+	set_64bit_val(wqe, 16, temp);
+
+	addr_type = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ? 1 : 0;
+	hdr = LS_64(IRDMA_CQP_OP_REG_SMR, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_STAG_MR) |
+	      LS_64(info->access_rights, IRDMA_CQPSQ_STAG_ARIGHTS) |
+	      LS_64(remote_access, IRDMA_CQPSQ_STAG_REMACCENABLED) |
+	      LS_64(addr_type, IRDMA_CQPSQ_STAG_VABASEDTO) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "MR_REG_SHARED WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+		      LS_64(info->stag_idx, IRDMA_CQPSQ_STAG_IDX));
+
+	hdr = LS_64(IRDMA_CQP_OP_DEALLOC_STAG, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->mr, IRDMA_CQPSQ_STAG_MR) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "DEALLOC_STAG WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_query_stag - query hardware for stag
+ * @dev: sc device struct
+ * @scratch: u64 saved to be used during cqp completion
+ * @stag_index: stag index for query
+ * @post_sq: flag for cqp db to ring
+ */
+static enum irdma_status_code irdma_sc_query_stag(struct irdma_sc_dev *dev,
+						  u64 scratch, u32 stag_index,
+						  bool post_sq)
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
+	set_64bit_val(wqe, 16,
+		      LS_64(stag_index, IRDMA_CQPSQ_QUERYSTAG_IDX));
+
+	hdr = LS_64(IRDMA_CQP_OP_QUERY_STAG, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "QUERY_STAG WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+		      LS_64(info->mw_stag_index, IRDMA_CQPSQ_STAG_IDX));
+
+	hdr = LS_64(IRDMA_CQP_OP_ALLOC_STAG, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->mw_wide, IRDMA_CQPSQ_STAG_MWTYPE) |
+	      LS_64(info->mw1_bind_dont_vldt_key,
+		    IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "MW_ALLOC WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	dev_dbg(rfdev_to_dev(qp->dev),
+		"MR: wr_id[%llxh] wqe_idx[%04d] location[%p]\n", info->wr_id,
+		wqe_idx, &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
+
+	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
+		(uintptr_t)info->va : info->fbo;
+	set_64bit_val(wqe, 0, temp);
+
+	temp = RS_64(info->first_pm_pbl_index >> 16, IRDMAQPSQ_FIRSTPMPBLIDXHI);
+	set_64bit_val(wqe, 8,
+		      LS_64(temp, IRDMAQPSQ_FIRSTPMPBLIDXHI) |
+		      LS_64(info->reg_addr_pa >> IRDMAQPSQ_PBLADDR_S, IRDMAQPSQ_PBLADDR));
+	set_64bit_val(wqe, 16,
+		      info->total_len |
+		      LS_64(info->first_pm_pbl_index, IRDMAQPSQ_FIRSTPMPBLIDXLO));
+
+	hdr = LS_64(info->stag_key, IRDMAQPSQ_STAGKEY) |
+	      LS_64(info->stag_idx, IRDMAQPSQ_STAGINDEX) |
+	      LS_64(IRDMAQP_OP_FAST_REGISTER, IRDMAQPSQ_OPCODE) |
+	      LS_64(info->chunk_size, IRDMAQPSQ_LPBLSIZE) |
+	      LS_64(page_size, IRDMAQPSQ_HPAGESIZE) |
+	      LS_64(info->access_rights, IRDMAQPSQ_STAGRIGHTS) |
+	      LS_64(info->addr_type, IRDMAQPSQ_VABASEDTO) |
+	      LS_64((sq_info.push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(info->read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(info->local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "FAST_REG WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
+	if (sq_info.push_wqe) {
+		irdma_qp_push_wqe(&qp->qp_uk, wqe, IRDMA_QP_WQE_MIN_QUANTA,
+				  wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(&qp->qp_uk);
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
+	hdr = LS_64(IRDMAQP_OP_NOP, IRDMAQPSQ_OPCODE) |
+	      LS_64(1, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_QP, "NOP W/LOCAL FENCE WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
+
+	wqe = qp_uk->sq_base[2].elem;
+	hdr = LS_64(IRDMAQP_OP_GEN_RTS_AE, IRDMAQPSQ_OPCODE) |
+	      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_QP, "CONN EST WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
+}
+
+/**
+ * irdma_sc_send_lsmm - send last streaming mode message
+ * @qp: sc qp struct
+ * @lsmm_buf: buffer with lsmm message
+ * @size: size of lsmm buffer
+ * @stag: stag of lsmm buffer
+ */
+static void irdma_sc_send_lsmm(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size,
+			       irdma_stag stag)
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
+			      LS_64(size, IRDMAQPSQ_GEN1_FRAG_LEN) |
+			      LS_64(stag, IRDMAQPSQ_GEN1_FRAG_STAG));
+	} else {
+		set_64bit_val(wqe, 8,
+			      LS_64(size, IRDMAQPSQ_FRAG_LEN) |
+			      LS_64(stag, IRDMAQPSQ_FRAG_STAG) |
+			      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID));
+	}
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = LS_64(IRDMAQP_OP_RDMA_SEND, IRDMAQPSQ_OPCODE) |
+	      LS_64(1, IRDMAQPSQ_STREAMMODE) |
+	      LS_64(1, IRDMAQPSQ_WAITFORRCVPDU) |
+	      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "SEND_LSMM WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
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
+static void irdma_sc_send_lsmm_nostag(struct irdma_sc_qp *qp, void *lsmm_buf,
+				      u32 size)
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
+			      LS_64(size, IRDMAQPSQ_GEN1_FRAG_LEN));
+	else
+		set_64bit_val(wqe, 8,
+			      LS_64(size, IRDMAQPSQ_FRAG_LEN) |
+			      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID));
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = LS_64(IRDMAQP_OP_RDMA_SEND, IRDMAQPSQ_OPCODE) |
+	      LS_64(1, IRDMAQPSQ_STREAMMODE) |
+	      LS_64(1, IRDMAQPSQ_WAITFORRCVPDU) |
+	      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "SEND_LSMM_NOSTAG WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
+}
+
+/**
+ * irdma_sc_send_rtt - send last read0 or write0
+ * @qp: sc qp struct
+ * @read: Do read0 or write0
+ */
+static void irdma_sc_send_rtt(struct irdma_sc_qp *qp, bool read)
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
+				      LS_64(0xabcd, IRDMAQPSQ_GEN1_FRAG_STAG));
+		} else {
+			set_64bit_val(wqe, 8,
+				      (u64)0xabcd | LS_64(qp->qp_uk.swqe_polarity,
+				      IRDMAQPSQ_VALID));
+		}
+		hdr = LS_64(0x1234, IRDMAQPSQ_REMSTAG) |
+		      LS_64(IRDMAQP_OP_RDMA_READ, IRDMAQPSQ_OPCODE) |
+		      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+
+	} else {
+		if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1) {
+			set_64bit_val(wqe, 8, 0);
+		} else {
+			set_64bit_val(wqe, 8,
+				      LS_64(qp->qp_uk.swqe_polarity,
+					    IRDMAQPSQ_VALID));
+		}
+		hdr = LS_64(IRDMAQP_OP_RDMA_WRITE, IRDMAQPSQ_OPCODE) |
+		      LS_64(qp->qp_uk.swqe_polarity, IRDMAQPSQ_VALID);
+	}
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_WQE, "RTR WQE", wqe,
+			IRDMA_QP_WQE_MIN_SIZE);
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
+	qp->eventtype = TERM_EVENT_QP_FATAL;
+
+	switch (info->ae_id) {
+	case IRDMA_AE_AMP_UNALLOCATED_STAG:
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
+		irdma_bld_termhdr_ctrl(qp, termhdr, FLUSH_REM_ACCESS_ERR,
+				       (LAYER_RDMA << 4) | RDMAP_REMOTE_PROT,
+				       RDMAP_ACCESS);
+		break;
+	case IRDMA_AE_AMP_TO_WRAP:
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+		qp->eventtype = TERM_EVENT_QP_ACCESS_ERR;
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
+	qp->eventtype = TERM_EVENT_QP_FATAL;
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
+void irdma_sc_vsi_init(struct irdma_sc_vsi *vsi,
+		       struct irdma_vsi_init_info *info)
+{
+	int i;
+	u32 reg_data;
+	u32 __iomem *reg_addr;
+	struct irdma_l2params *l2p;
+
+	vsi->dev = info->dev;
+	vsi->back_vsi = info->back_vsi;
+	vsi->register_qset = info->register_qset;
+	vsi->unregister_qset = info->unregister_qset;
+	vsi->mtu = info->params->mtu;
+	vsi->exception_lan_q = info->exception_lan_q;
+	vsi->vsi_idx = info->pf_data_vsi_num;
+	vsi->vm_vf_type = info->vm_vf_type;
+	vsi->vm_id = info->vm_id;
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
+		spin_lock_init(&vsi->qos[i].lock);
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
+	if (info->dev->privileged) {
+		reg_addr = info->dev->hw_regs[IRDMA_VSIQF_PE_CTL1] + vsi->vsi_idx;
+		if (vsi->dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1) {
+			writel(0x1, reg_addr);
+		} else {
+			reg_data = readl(reg_addr);
+			reg_data |= 0x2;
+			writel(reg_data, reg_addr);
+		}
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
+	stats_buff_mem->va = dma_alloc_coherent(hw_to_dev(vsi->pestat->hw),
+						stats_buff_mem->size,
+						&stats_buff_mem->pa,
+						GFP_KERNEL);
+	if (!stats_buff_mem->va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	vsi->pestat->gather_info.gather_stats = stats_buff_mem->va;
+	vsi->pestat->gather_info.last_gather_stats =
+		(void *)((uintptr_t)stats_buff_mem->va +
+			 IRDMA_GATHER_STATS_BUF_SIZE);
+
+	if (vsi->dev->privileged)
+		irdma_hw_stats_start_timer(vsi);
+
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
+	dma_free_coherent(hw_to_dev(vsi->pestat->hw), stats_buff_mem->size,
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
+	if (vsi->dev->privileged)
+		irdma_hw_stats_stop_timer(vsi);
+	dma_free_coherent(hw_to_dev(vsi->pestat->hw),
+			  vsi->pestat->gather_info.stats_buff_mem.size,
+			  vsi->pestat->gather_info.stats_buff_mem.va,
+			  vsi->pestat->gather_info.stats_buff_mem.pa);
+	vsi->pestat->gather_info.stats_buff_mem.va = NULL;
+}
+
+/**
+ * irdma_get_encoded_wqe_size - given wq size, returns hardware encoded size
+ * @wqsize: size of the wq (sq, rq) to encoded_size
+ * @cqpsq: encoded size for sq for cqp as its encoded size is 1+ other wq's
+ */
+u8 irdma_get_encoded_wqe_size(u32 wqsize, bool cqpsq)
+{
+	u8 encoded_size = 0;
+
+	/* cqp sq's hw coded value starts from 1 for size of 4
+	 * while it starts from 0 for qp' wq's.
+	 */
+	if (cqpsq)
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
+		      LS_64(info->hmc_fcn_index, IRDMA_CQPSQ_STATS_HMC_FCN_INDEX));
+	set_64bit_val(wqe, 32, info->stats_buff_mem.pa);
+
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_STATS_WQEVALID) |
+	       LS_64(info->use_stats_inst, IRDMA_CQPSQ_STATS_USE_INST) |
+	       LS_64(info->stats_inst_index, IRDMA_CQPSQ_STATS_INST_INDEX) |
+	       LS_64(info->use_hmc_fcn_index,
+		     IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX) |
+	       LS_64(IRDMA_CQP_OP_GATHER_STATS, IRDMA_CQPSQ_STATS_OP);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_STATS, "GATHER_STATS WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	writel(IRDMA_RING_CURRENT_HEAD(cqp->sq_ring),
+	       cqp->dev->hw_regs[IRDMA_CQPDB]);
+	dev_dbg(rfdev_to_dev(cqp->dev),
+		"STATS: CQP SQ head 0x%x tail 0x%x size 0x%x\n",
+		cqp->sq_ring.head, cqp->sq_ring.tail, cqp->sq_ring.size);
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
+		      LS_64(info->hmc_fn_id, IRDMA_CQPSQ_STATS_HMC_FCN_INDEX));
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_STATS_WQEVALID) |
+	       LS_64(alloc, IRDMA_CQPSQ_STATS_ALLOC_INST) |
+	       LS_64(info->use_hmc_fcn_index, IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX) |
+	       LS_64(info->stats_idx, IRDMA_CQPSQ_STATS_INST_INDEX) |
+	       LS_64(IRDMA_CQP_OP_MANAGE_STATS, IRDMA_CQPSQ_STATS_OP);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_STATS WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+
+	irdma_sc_cqp_post_sq(cqp);
+	return 0;
+}
+
+/**
+ * irdma_sc_set_up_mapping - set the up map table
+ * @cqp: struct for cqp hw
+ * @info: User priority map info
+ * @scratch: u64 saved to be used during cqp completion
+ */
+static enum irdma_status_code irdma_sc_set_up_map(struct irdma_sc_cqp *cqp,
+						  struct irdma_up_info *info,
+						  u64 scratch)
+{
+	__le64 *wqe;
+	u64 temp;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	temp = info->map[0] | LS_64_1(info->map[1], 8) |
+	       LS_64_1(info->map[2], 16) | LS_64_1(info->map[3], 24) |
+	       LS_64_1(info->map[4], 32) | LS_64_1(info->map[5], 40) |
+	       LS_64_1(info->map[6], 48) | LS_64_1(info->map[7], 56);
+
+	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 40,
+		      LS_64(info->cnp_up_override, IRDMA_CQPSQ_UP_CNPOVERRIDE) |
+		      LS_64(info->hmc_fcn_idx, IRDMA_CQPSQ_UP_HMCFCNIDX));
+
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_UP_WQEVALID) |
+	       LS_64(info->use_vlan, IRDMA_CQPSQ_UP_USEVLAN) |
+	       LS_64(info->use_cnp_up_override, IRDMA_CQPSQ_UP_USEOVERRIDE) |
+	       LS_64(IRDMA_CQP_OP_UP_MAP, IRDMA_CQPSQ_UP_OP);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "UPMAP WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+		      LS_64(info->vsi, IRDMA_CQPSQ_WS_VSI) |
+		      LS_64(info->weight, IRDMA_CQPSQ_WS_WEIGHT));
+
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_WS_WQEVALID) |
+	       LS_64(node_op, IRDMA_CQPSQ_WS_NODEOP) |
+	       LS_64(info->enable, IRDMA_CQPSQ_WS_ENABLENODE) |
+	       LS_64(info->type_leaf, IRDMA_CQPSQ_WS_NODETYPE) |
+	       LS_64(info->prio_type, IRDMA_CQPSQ_WS_PRIOTYPE) |
+	       LS_64(info->tc, IRDMA_CQPSQ_WS_TC) |
+	       LS_64(IRDMA_CQP_OP_WORK_SCHED_NODE, IRDMA_CQPSQ_WS_OP) |
+	       LS_64(info->parent_id, IRDMA_CQPSQ_WS_PARENTID) |
+	       LS_64(info->id, IRDMA_CQPSQ_WS_NODEID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_WS WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code
+irdma_sc_qp_flush_wqes(struct irdma_sc_qp *qp, struct irdma_qp_flush_info *info,
+		       u64 scratch, bool post_sq)
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
+		dev_dbg(rfdev_to_dev(qp->dev),
+			"CQP: Additional flush request ignored\n");
+		return 0;
+	}
+
+	cqp = qp->pd->dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	if (info->userflushcode) {
+		if (flush_rq)
+			temp |= LS_64(info->rq_minor_code, IRDMA_CQPSQ_FWQE_RQMNERR) |
+				LS_64(info->rq_major_code, IRDMA_CQPSQ_FWQE_RQMJERR);
+		if (flush_sq)
+			temp |= LS_64(info->sq_minor_code, IRDMA_CQPSQ_FWQE_SQMNERR) |
+				LS_64(info->sq_major_code, IRDMA_CQPSQ_FWQE_SQMJERR);
+	}
+	set_64bit_val(wqe, 16, temp);
+
+	temp = (info->generate_ae) ?
+		info->ae_code | LS_64(info->ae_src, IRDMA_CQPSQ_FWQE_AESOURCE) : 0;
+	set_64bit_val(wqe, 8, temp);
+
+	hdr = qp->qp_uk.qp_id |
+	      LS_64(IRDMA_CQP_OP_FLUSH_WQES, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->generate_ae, IRDMA_CQPSQ_FWQE_GENERATE_AE) |
+	      LS_64(info->userflushcode, IRDMA_CQPSQ_FWQE_USERFLCODE) |
+	      LS_64(flush_sq, IRDMA_CQPSQ_FWQE_FLUSHSQ) |
+	      LS_64(flush_rq, IRDMA_CQPSQ_FWQE_FLUSHRQ) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QP_FLUSH WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	temp = info->ae_code | LS_64(info->ae_src, IRDMA_CQPSQ_FWQE_AESOURCE);
+	set_64bit_val(wqe, 8, temp);
+
+	hdr = qp->qp_uk.qp_id | LS_64(IRDMA_CQP_OP_GEN_AE, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_FWQE_GENERATE_AE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "GEN_AE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	hdr = LS_64(info->qp_id, IRDMA_CQPSQ_UCTX_QPID) |
+	      LS_64(IRDMA_CQP_OP_UPLOAD_CONTEXT, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->qp_type, IRDMA_CQPSQ_UCTX_QPTYPE) |
+	      LS_64(info->raw_format, IRDMA_CQPSQ_UCTX_RAWFORMAT) |
+	      LS_64(info->freeze_qp, IRDMA_CQPSQ_UCTX_FREEZEQP) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "QP_UPLOAD_CTX WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	if (info->push_idx >= cqp->dev->hw_attrs.max_hw_device_pages)
+		return IRDMA_ERR_INVALID_PUSH_PAGE_INDEX;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, info->qs_handle);
+	hdr = LS_64(info->push_idx, IRDMA_CQPSQ_MPP_PPIDX) |
+	      LS_64(info->push_page_type, IRDMA_CQPSQ_MPP_PPTYPE) |
+	      LS_64(IRDMA_CQP_OP_MANAGE_PUSH_PAGES, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID) |
+	      LS_64(info->free_page, IRDMA_CQPSQ_MPP_FREE_PAGE);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "MANAGE_PUSH_PAGES WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	hdr = LS_64(qp->qp_uk.qp_id, IRDMA_CQPSQ_SUSPENDQP_QPID) |
+	      LS_64(IRDMA_CQP_OP_SUSPEND_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "SUSPEND_QP WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+		      LS_64(qp->qs_handle, IRDMA_CQPSQ_RESUMEQP_QSHANDLE));
+
+	hdr = LS_64(qp->qp_uk.qp_id, IRDMA_CQPSQ_RESUMEQP_QPID) |
+	      LS_64(IRDMA_CQP_OP_RESUME_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "RESUME_QP WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cq_ack - acknowledge completion q
+ * @cq: cq struct
+ */
+static void irdma_sc_cq_ack(struct irdma_sc_cq *cq)
+{
+	writel(cq->cq_uk.cq_id, cq->cq_uk.cq_ack_db);
+}
+
+/**
+ * irdma_sc_cq_init - initialize completion q
+ * @cq: cq struct
+ * @info: cq initialization info
+ */
+static enum irdma_status_code irdma_sc_cq_init(struct irdma_sc_cq *cq,
+					       struct irdma_cq_init_info *info)
+{
+	enum irdma_status_code ret_code;
+	u32 pble_obj_cnt;
+
+	if (info->cq_uk_init_info.cq_size < info->dev->hw_attrs.uk_attrs.min_hw_cq_size ||
+	    info->cq_uk_init_info.cq_size > info->dev->hw_attrs.uk_attrs.max_hw_cq_size)
+		return IRDMA_ERR_INVALID_SIZE;
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
+	ret_code = irdma_cq_uk_init(&cq->cq_uk, &info->cq_uk_init_info);
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
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	ceq = cq->dev->ceq[cq->ceq_id];
+	if (ceq && ceq->reg_cq)
+		ret_code = irdma_sc_add_cq_ctx(ceq, cq);
+
+	if (ret_code)
+		return ret_code;
+
+	set_64bit_val(wqe, 0, cq->cq_uk.cq_size);
+	set_64bit_val(wqe, 8, RS_64_1(cq, 1));
+	set_64bit_val(wqe, 16,
+		      LS_64(cq->shadow_read_threshold,
+			    IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD));
+	set_64bit_val(wqe, 32, (cq->virtual_map ? 0 : cq->cq_pa));
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48,
+		      LS_64((cq->virtual_map ? cq->first_pm_pbl_idx : 0),
+			    IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX));
+	set_64bit_val(wqe, 56,
+		      LS_64(cq->tph_val, IRDMA_CQPSQ_TPHVAL) |
+		      LS_64(cq->vsi->vsi_idx, IRDMA_CQPSQ_VSIIDX));
+
+	hdr = FLD_LS_64(cq->dev, cq->cq_uk.cq_id, IRDMA_CQPSQ_CQ_CQID) |
+	      FLD_LS_64(cq->dev, (cq->ceq_id_valid ? cq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      LS_64(IRDMA_CQP_OP_CREATE_CQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cq->pbl_chunk_size, IRDMA_CQPSQ_CQ_LPBLSIZE) |
+	      LS_64(check_overflow, IRDMA_CQPSQ_CQ_CHKOVERFLOW) |
+	      LS_64(cq->virtual_map, IRDMA_CQPSQ_CQ_VIRTMAP) |
+	      LS_64(cq->ceqe_mask, IRDMA_CQPSQ_CQ_ENCEQEMASK) |
+	      LS_64(cq->ceq_id_valid, IRDMA_CQPSQ_CQ_CEQIDVALID) |
+	      LS_64(cq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(cq->cq_uk.avoid_mem_cflct, IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CQ_CREATE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code irdma_sc_cq_destroy(struct irdma_sc_cq *cq,
+						  u64 scratch, bool post_sq)
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
+	set_64bit_val(wqe, 8, RS_64_1(cq, 1));
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48,
+		      (cq->virtual_map ? cq->first_pm_pbl_idx : 0));
+
+	hdr = cq->cq_uk.cq_id |
+	      FLD_LS_64(cq->dev, (cq->ceq_id_valid ? cq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      LS_64(IRDMA_CQP_OP_DESTROY_CQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cq->pbl_chunk_size, IRDMA_CQPSQ_CQ_LPBLSIZE) |
+	      LS_64(cq->virtual_map, IRDMA_CQPSQ_CQ_VIRTMAP) |
+	      LS_64(cq->ceqe_mask, IRDMA_CQPSQ_CQ_ENCEQEMASK) |
+	      LS_64(cq->ceq_id_valid, IRDMA_CQPSQ_CQ_CEQIDVALID) |
+	      LS_64(cq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(cq->cq_uk.avoid_mem_cflct, IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CQ_DESTROY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static void irdma_sc_cq_resize(struct irdma_sc_cq *cq, struct irdma_modify_cq_info *info)
+{
+	cq->virtual_map = info->virtual_map;
+	cq->cq_pa = info->cq_pa;
+	cq->first_pm_pbl_idx = info->first_pm_pbl_idx;
+	cq->pbl_chunk_size = info->pbl_chunk_size;
+	cq->cq_uk.ops.iw_cq_resize(&cq->cq_uk, info->cq_base, info->cq_size);
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
+	if (info->ceq_valid &&
+	    info->ceq_id > (cq->dev->hmc_fpm_misc.max_ceqs - 1))
+		return IRDMA_ERR_INVALID_CEQ_ID;
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
+	set_64bit_val(wqe, 8, RS_64_1(cq, 1));
+	set_64bit_val(wqe, 16,
+		      LS_64(info->shadow_read_threshold,
+			    IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD));
+	set_64bit_val(wqe, 32, info->cq_pa);
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 48, info->first_pm_pbl_idx);
+	set_64bit_val(wqe, 56,
+		      LS_64(cq->tph_val, IRDMA_CQPSQ_TPHVAL) |
+		      LS_64(cq->vsi->vsi_idx, IRDMA_CQPSQ_VSIIDX));
+
+	hdr = cq->cq_uk.cq_id |
+	      FLD_LS_64(cq->dev, (info->ceq_valid ? cq->ceq_id : 0),
+			IRDMA_CQPSQ_CQ_CEQID) |
+	      LS_64(IRDMA_CQP_OP_MODIFY_CQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->cq_resize, IRDMA_CQPSQ_CQ_CQRESIZE) |
+	      LS_64(info->pbl_chunk_size, IRDMA_CQPSQ_CQ_LPBLSIZE) |
+	      LS_64(info->check_overflow, IRDMA_CQPSQ_CQ_CHKOVERFLOW) |
+	      LS_64(info->virtual_map, IRDMA_CQPSQ_CQ_VIRTMAP) |
+	      LS_64(cq->ceqe_mask, IRDMA_CQPSQ_CQ_ENCEQEMASK) |
+	      LS_64(info->ceq_valid, IRDMA_CQPSQ_CQ_CEQIDVALID) |
+	      LS_64(cq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(cq->cq_uk.avoid_mem_cflct, IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CQ_MODIFY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static void irdma_check_cqp_progress(struct irdma_cqp_timeout *timeout,
+				     struct irdma_sc_dev *dev)
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
+	*tail = RS_32(*val, IRDMA_CQPTAIL_WQTAIL);
+	*error = RS_32(*val, IRDMA_CQPTAIL_CQP_OP_ERR);
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
+			dev_dbg(rfdev_to_dev(cqp->dev),
+				"CQP: CQPERRCODES error_code[x%08X]\n", error);
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
+ * @buf: pointer to commit buffer
+ * @buf_idx: buffer index
+ * @obj_info: object info pointer
+ * @rsrc_idx: indexs of memory resource
+ */
+static u64 irdma_sc_decode_fpm_commit(__le64 *buf, u32 buf_idx,
+				      struct irdma_hmc_obj_info *obj_info,
+				      u32 rsrc_idx)
+{
+	u64 temp;
+
+	get_64bit_val(buf, buf_idx, &temp);
+
+	switch (rsrc_idx) {
+	case IRDMA_HMC_IW_QP:
+		obj_info[rsrc_idx].cnt = (u32)RS_64(temp, IRDMA_COMMIT_FPM_QPCNT);
+		break;
+	case IRDMA_HMC_IW_CQ:
+		obj_info[rsrc_idx].cnt = (u32)RS_64(temp, IRDMA_COMMIT_FPM_CQCNT);
+		break;
+	case IRDMA_HMC_IW_APBVT_ENTRY:
+		obj_info[rsrc_idx].cnt = 1;
+		break;
+	default:
+		obj_info[rsrc_idx].cnt = (u32)temp;
+		break;
+	}
+
+	obj_info[rsrc_idx].base = (u64)RS_64_1(temp, IRDMA_COMMIT_FPM_BASE_S) * 512;
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
+	irdma_sc_decode_fpm_commit(buf, 0, info, IRDMA_HMC_IW_QP);
+	irdma_sc_decode_fpm_commit(buf, 8, info, IRDMA_HMC_IW_CQ);
+	/* skiping RSRVD */
+	irdma_sc_decode_fpm_commit(buf, 24, info, IRDMA_HMC_IW_HTE);
+	irdma_sc_decode_fpm_commit(buf, 32, info, IRDMA_HMC_IW_ARP);
+	irdma_sc_decode_fpm_commit(buf, 40, info,
+				   IRDMA_HMC_IW_APBVT_ENTRY);
+	irdma_sc_decode_fpm_commit(buf, 48, info, IRDMA_HMC_IW_MR);
+	irdma_sc_decode_fpm_commit(buf, 56, info, IRDMA_HMC_IW_XF);
+	irdma_sc_decode_fpm_commit(buf, 64, info, IRDMA_HMC_IW_XFFL);
+	irdma_sc_decode_fpm_commit(buf, 72, info, IRDMA_HMC_IW_Q1);
+	irdma_sc_decode_fpm_commit(buf, 80, info, IRDMA_HMC_IW_Q1FL);
+	irdma_sc_decode_fpm_commit(buf, 88, info,
+				   IRDMA_HMC_IW_TIMER);
+	irdma_sc_decode_fpm_commit(buf, 112, info,
+				   IRDMA_HMC_IW_PBLE);
+	/* skipping RSVD. */
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1) {
+		irdma_sc_decode_fpm_commit(buf, 96, info,
+					   IRDMA_HMC_IW_FSIMC);
+		irdma_sc_decode_fpm_commit(buf, 104, info,
+					   IRDMA_HMC_IW_FSIAV);
+		irdma_sc_decode_fpm_commit(buf, 128, info,
+					   IRDMA_HMC_IW_RRF);
+		irdma_sc_decode_fpm_commit(buf, 136, info,
+					   IRDMA_HMC_IW_RRFFL);
+		irdma_sc_decode_fpm_commit(buf, 144, info,
+					   IRDMA_HMC_IW_HDR);
+		irdma_sc_decode_fpm_commit(buf, 152, info,
+					   IRDMA_HMC_IW_MD);
+		irdma_sc_decode_fpm_commit(buf, 160, info,
+					   IRDMA_HMC_IW_OOISC);
+		irdma_sc_decode_fpm_commit(buf, 168, info,
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
+	size = (u32)RS_64_1(temp, 32);
+	obj_info[rsrc_idx].size = LS_64_1(1, size);
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
+	hmc_info->first_sd_index = (u16)RS_64(temp, IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX);
+	max_pe_sds = (u16)RS_64(temp, IRDMA_QUERY_FPM_MAX_PE_SDS);
+
+	/* Reduce SD count for VFs by 1 to account
+	 * for PBLE backing page rounding
+	 */
+	if (hmc_info->hmc_fn_id >= dev->hw_attrs.first_hw_vf_fpm_id)
+		max_pe_sds--;
+	hmc_fpm_misc->max_sds = max_pe_sds;
+	hmc_info->sd_table.sd_cnt = max_pe_sds + hmc_info->first_sd_index;
+	get_64bit_val(buf, 8, &temp);
+	obj_info[IRDMA_HMC_IW_QP].max_cnt = (u32)RS_64(temp, IRDMA_QUERY_FPM_MAX_QPS);
+	size = (u32)RS_64_1(temp, 32);
+	obj_info[IRDMA_HMC_IW_QP].size = LS_64_1(1, size);
+
+	get_64bit_val(buf, 16, &temp);
+	obj_info[IRDMA_HMC_IW_CQ].max_cnt = (u32)RS_64(temp, IRDMA_QUERY_FPM_MAX_CQS);
+	size = (u32)RS_64_1(temp, 32);
+	obj_info[IRDMA_HMC_IW_CQ].size = LS_64_1(1, size);
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
+	hmc_fpm_misc->xf_block_size = RS_64(temp, IRDMA_QUERY_FPM_XFBLOCKSIZE);
+	if (!hmc_fpm_misc->xf_block_size)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	irdma_sc_decode_fpm_query(buf, 72, obj_info, IRDMA_HMC_IW_Q1);
+	get_64bit_val(buf, 80, &temp);
+	obj_info[IRDMA_HMC_IW_Q1FL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_Q1FL].size = 4;
+
+	hmc_fpm_misc->q1_block_size = RS_64(temp, IRDMA_QUERY_FPM_Q1BLOCKSIZE);
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
+	hmc_fpm_misc->max_ceqs = RS_64(temp, IRDMA_QUERY_FPM_MAX_CEQS);
+	hmc_fpm_misc->ht_multiplier = RS_64(temp, IRDMA_QUERY_FPM_HTMULTIPLIER);
+	hmc_fpm_misc->timer_bucket = RS_64(temp, IRDMA_QUERY_FPM_TIMERBUCKET);
+	if (dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		return 0;
+	irdma_sc_decode_fpm_query(buf, 96, obj_info, IRDMA_HMC_IW_FSIMC);
+	irdma_sc_decode_fpm_query(buf, 104, obj_info, IRDMA_HMC_IW_FSIAV);
+	irdma_sc_decode_fpm_query(buf, 128, obj_info, IRDMA_HMC_IW_RRF);
+
+	get_64bit_val(buf, 136, &temp);
+	obj_info[IRDMA_HMC_IW_RRFFL].max_cnt = (u32)temp;
+	obj_info[IRDMA_HMC_IW_RRFFL].size = 4;
+	hmc_fpm_misc->rrf_block_size = RS_64(temp, IRDMA_QUERY_FPM_RRFBLOCKSIZE);
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
+	hmc_fpm_misc->ooiscf_block_size = RS_64(temp, IRDMA_QUERY_FPM_OOISCFBLOCKSIZE);
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
+static enum irdma_status_code
+irdma_sc_cqp_init(struct irdma_sc_cqp *cqp, struct irdma_cqp_init_info *info)
+{
+	u8 hw_sq_size;
+
+	if (info->sq_size > IRDMA_CQP_SW_SQSIZE_2048 ||
+	    info->sq_size < IRDMA_CQP_SW_SQSIZE_4 ||
+	    ((info->sq_size & (info->sq_size - 1))))
+		return IRDMA_ERR_INVALID_SIZE;
+
+	hw_sq_size = irdma_get_encoded_wqe_size(info->sq_size, true);
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
+	info->dev->cqp = cqp;
+
+	IRDMA_RING_INIT(cqp->sq_ring, cqp->sq_size);
+	cqp->dev->cqp_cmd_stats[IRDMA_OP_REQ_CMDS] = 0;
+	cqp->dev->cqp_cmd_stats[IRDMA_OP_CMPL_CMDS] = 0;
+	/* for the cqp commands backlog. */
+	INIT_LIST_HEAD(&cqp->dev->cqp_cmd_head);
+
+	writel(0, cqp->dev->hw_regs[IRDMA_CQPTAIL]);
+	if (cqp->dev->hw_attrs.uk_attrs.hw_rev <= IRDMA_GEN_2)
+		writel(0, cqp->dev->hw_regs[IRDMA_CQPDB]);
+	writel(0, cqp->dev->hw_regs[IRDMA_CCQPSTATUS]);
+
+	dev_dbg(rfdev_to_dev(cqp->dev),
+		"WQE: sq_size[%04d] hw_sq_size[%04d] sq_base[%p] sq_pa[%pK] cqp[%p] polarity[x%04x]\n",
+		cqp->sq_size, cqp->hw_sq_size, cqp->sq_base,
+		(u64 *)(uintptr_t)cqp->sq_pa, cqp, cqp->polarity);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_cqp_create - create cqp during bringup
+ * @cqp: struct for cqp hw
+ * @maj_err: If error, major err number
+ * @min_err: If error, minor err number
+ */
+static enum irdma_status_code irdma_sc_cqp_create(struct irdma_sc_cqp *cqp,
+						  u16 *maj_err, u16 *min_err)
+{
+	u64 temp;
+	u32 cnt = 0, p1, p2, val = 0, err_code;
+	enum irdma_status_code ret_code;
+
+	cqp->sdbuf.size = ALIGN(IRDMA_UPDATE_SD_BUFF_SIZE * cqp->sq_size,
+				IRDMA_SD_BUF_ALIGNMENT);
+	cqp->sdbuf.va = dma_alloc_coherent(hw_to_dev(cqp->dev->hw),
+					   cqp->sdbuf.size, &cqp->sdbuf.pa,
+					   GFP_KERNEL);
+	if (!cqp->sdbuf.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	temp = LS_64(cqp->hw_sq_size, IRDMA_CQPHC_SQSIZE) |
+	       LS_64(cqp->struct_ver, IRDMA_CQPHC_SVER) |
+	       LS_64(cqp->rocev2_rto_policy, IRDMA_CQPHC_ROCEV2_RTO_POLICY) |
+	       LS_64(cqp->protocol_used, IRDMA_CQPHC_PROTOCOL_USED) |
+	       LS_64(cqp->disable_packed, IRDMA_CQPHC_DISABLE_PFPDUS) |
+	       LS_64(cqp->ceqs_per_vf, IRDMA_CQPHC_CEQPERVF);
+	set_64bit_val(cqp->host_ctx, 0, temp);
+	set_64bit_val(cqp->host_ctx, 8, cqp->sq_pa);
+
+	temp = LS_64(cqp->ena_vf_count, IRDMA_CQPHC_ENABLED_VFS) |
+	       LS_64(cqp->hmc_profile, IRDMA_CQPHC_HMC_PROFILE);
+	set_64bit_val(cqp->host_ctx, 16, temp);
+	set_64bit_val(cqp->host_ctx, 24, (uintptr_t)cqp);
+	set_64bit_val(cqp->host_ctx, 32, 0);
+	temp = LS_64(cqp->hw_maj_ver, IRDMA_CQPHC_HW_MAJVER) |
+	       LS_64(cqp->hw_min_ver, IRDMA_CQPHC_HW_MINVER);
+	set_64bit_val(cqp->host_ctx, 32, temp);
+	set_64bit_val(cqp->host_ctx, 40, 0);
+	set_64bit_val(cqp->host_ctx, 48, 0);
+	set_64bit_val(cqp->host_ctx, 56, 0);
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CQP_HOST_CTX WQE",
+			cqp->host_ctx, IRDMA_CQP_CTX_SIZE * 8);
+	p1 = RS_32_1(cqp->host_ctx_pa, 32);
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
+	dma_free_coherent(hw_to_dev(cqp->dev->hw), cqp->sdbuf.size,
+			  cqp->sdbuf.va, cqp->sdbuf.pa);
+	cqp->sdbuf.va = NULL;
+	err_code = readl(cqp->dev->hw_regs[IRDMA_CQPERRCODES]);
+	*min_err = RS_32(err_code, IRDMA_CQPERRCODES_CQP_MINOR_CODE);
+	*maj_err = RS_32(err_code, IRDMA_CQPERRCODES_CQP_MAJOR_CODE);
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
+	dev_dbg(rfdev_to_dev(cqp->dev),
+		"WQE: CQP SQ head 0x%x tail 0x%x size 0x%x\n",
+		cqp->sq_ring.head, cqp->sq_ring.tail, cqp->sq_ring.size);
+}
+
+/**
+ * irdma_sc_cqp_get_next_send_wqe_idx - get next wqe on cqp sq
+ * and pass back index
+ * @cqp: CQP HW structure
+ * @scratch: private data for CQP WQE
+ * @wqe_idx: WQE index of CQP SQ
+ */
+static __le64 *irdma_sc_cqp_get_next_send_wqe_idx(struct irdma_sc_cqp *cqp,
+						  u64 scratch, u32 *wqe_idx)
+{
+	__le64 *wqe = NULL;
+	enum irdma_status_code ret_code;
+
+	if (IRDMA_RING_FULL_ERR(cqp->sq_ring)) {
+		dev_dbg(rfdev_to_dev(cqp->dev),
+			"WQE: CQP SQ is full, head 0x%x tail 0x%x size 0x%x\n",
+			cqp->sq_ring.head, cqp->sq_ring.tail,
+			cqp->sq_ring.size);
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
+ * irdma_sc_cqp_get_next_send_wqe - get next wqe on cqp sq
+ * @cqp: struct for cqp hw
+ * @scratch: private data for CQP WQE
+ */
+__le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch)
+{
+	u32 wqe_idx;
+
+	return irdma_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
+}
+
+/**
+ * irdma_sc_cqp_destroy - destroy cqp during close
+ * @cqp: struct for cqp hw
+ */
+static enum irdma_status_code irdma_sc_cqp_destroy(struct irdma_sc_cqp *cqp)
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
+	dma_free_coherent(hw_to_dev(cqp->dev->hw), cqp->sdbuf.size,
+			  cqp->sdbuf.va, cqp->sdbuf.pa);
+	cqp->sdbuf.va = NULL;
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_ccq_arm - enable intr for control cq
+ * @ccq: ccq sc struct
+ */
+static void irdma_sc_ccq_arm(struct irdma_sc_cq *ccq)
+{
+	u64 temp_val;
+	u16 sw_cq_sel;
+	u8 arm_next_se;
+	u8 arm_seq_num;
+
+	get_64bit_val(ccq->cq_uk.shadow_area, 32, &temp_val);
+	sw_cq_sel = (u16)RS_64(temp_val, IRDMA_CQ_DBSA_SW_CQ_SELECT);
+	arm_next_se = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_NEXT_SE);
+	arm_seq_num = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_SEQ_NUM);
+	arm_seq_num++;
+	temp_val = LS_64(arm_seq_num, IRDMA_CQ_DBSA_ARM_SEQ_NUM) |
+		   LS_64(sw_cq_sel, IRDMA_CQ_DBSA_SW_CQ_SELECT) |
+		   LS_64(arm_next_se, IRDMA_CQ_DBSA_ARM_NEXT_SE) |
+		   LS_64(1, IRDMA_CQ_DBSA_ARM_NEXT);
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
+static enum irdma_status_code
+irdma_sc_ccq_get_cqe_info(struct irdma_sc_cq *ccq,
+			  struct irdma_ccq_cqe_info *info)
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
+	polarity = (u8)RS_64(temp, IRDMA_CQ_VALID);
+	if (polarity != ccq->cq_uk.polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	get_64bit_val(cqe, 8, &qp_ctx);
+	cqp = (struct irdma_sc_cqp *)(unsigned long)qp_ctx;
+	info->error = (bool)RS_64(temp, IRDMA_CQ_ERROR);
+	info->min_err_code = (u16)RS_64(temp, IRDMA_CQ_MINERR);
+	if (info->error) {
+		info->maj_err_code = (u16)RS_64(temp, IRDMA_CQ_MAJERR);
+		info->min_err_code = (u16)RS_64(temp, IRDMA_CQ_MINERR);
+		error = readl(cqp->dev->hw_regs[IRDMA_CQPERRCODES]);
+		dev_dbg(rfdev_to_dev(cqp->dev),
+			"CQP: CQPERRCODES error_code[x%08X]\n", error);
+	}
+	wqe_idx = (u32)RS_64(temp, IRDMA_CQ_WQEIDX);
+	info->scratch = cqp->scratch_array[wqe_idx];
+
+	get_64bit_val(cqe, 16, &temp1);
+	info->op_ret_val = (u32)RS_64(temp1, IRDMA_CCQ_OPRETVAL);
+	get_64bit_val(cqp->sq_base[wqe_idx].elem, 24, &temp1);
+	info->op_code = (u8)RS_64(temp1, IRDMA_CQPSQ_OPCODE);
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
+static enum irdma_status_code
+irdma_sc_poll_for_cqp_op_done(struct irdma_sc_cqp *cqp, u8 op_code,
+			      struct irdma_ccq_cqe_info *compl_info)
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
+		if (info.error) {
+			ret_code = IRDMA_ERR_CQP_COMPL_ERROR;
+			break;
+		}
+		/* make sure op code matches*/
+		if (op_code == info.op_code)
+			break;
+		dev_dbg(rfdev_to_dev(cqp->dev),
+			"WQE: opcode mismatch for my op code 0x%x, returned opcode %x\n",
+			op_code, info.op_code);
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
+	hdr = LS_64(info->vf_id, IRDMA_CQPSQ_MHMC_VFIDX) |
+	      LS_64(IRDMA_CQP_OP_MANAGE_HMC_PM_FUNC_TABLE,
+		    IRDMA_CQPSQ_OPCODE) |
+	      LS_64(info->free_fcn, IRDMA_CQPSQ_MHMC_FREEPMFN) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE,
+			"MANAGE_HMC_PM_FUNC_TABLE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	if (post_sq)
+		irdma_sc_cqp_post_sq(cqp);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_manage_hmc_pm_func_table_done - wait for cqp wqe completion for function table
+ * @cqp: struct for cqp hw
+ */
+static enum irdma_status_code
+irdma_sc_manage_hmc_pm_func_table_done(struct irdma_sc_cqp *cqp)
+{
+	return irdma_sc_poll_for_cqp_op_done(cqp,
+					     IRDMA_CQP_OP_MANAGE_HMC_PM_FUNC_TABLE,
+					     NULL);
+}
+
+/**
+ * irdma_sc_commit_fpm_values_done - wait for cqp eqe completion for fpm commit
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
+	hdr = LS_64(IRDMA_COMMIT_FPM_BUF_SIZE, IRDMA_CQPSQ_BUFSIZE) |
+	      LS_64(IRDMA_CQP_OP_COMMIT_FPM_VAL, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "COMMIT_FPM_VAL WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+
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
+ * irdma_sc_query_fpm_values_done - poll for cqp wqe completion for query fpm
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
+	hdr = LS_64(IRDMA_CQP_OP_QUERY_FPM_VAL, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QUERY_FPM WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
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
+static enum irdma_status_code
+irdma_sc_ceq_init(struct irdma_sc_ceq *ceq, struct irdma_ceq_init_info *info)
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
+static enum irdma_status_code irdma_sc_ceq_create(struct irdma_sc_ceq *ceq,
+						  u64 scratch, bool post_sq)
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
+		      LS_64(ceq->tph_val, IRDMA_CQPSQ_TPHVAL) |
+		      LS_64(ceq->vsi->vsi_idx, IRDMA_CQPSQ_VSIIDX));
+	hdr = ceq->ceq_id | LS_64(IRDMA_CQP_OP_CREATE_CEQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(ceq->pbl_chunk_size, IRDMA_CQPSQ_CEQ_LPBLSIZE) |
+	      LS_64(ceq->virtual_map, IRDMA_CQPSQ_CEQ_VMAP) |
+	      LS_64(ceq->itr_no_expire, IRDMA_CQPSQ_CEQ_ITRNOEXPIRE) |
+	      LS_64(ceq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CEQ_CREATE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code
+irdma_sc_cceq_destroy_done(struct irdma_sc_ceq *ceq)
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
+static enum irdma_status_code irdma_sc_cceq_create(struct irdma_sc_ceq *ceq,
+						   u64 scratch)
+{
+	enum irdma_status_code ret_code;
+
+	ceq->dev->ccq->vsi = ceq->vsi;
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
+static enum irdma_status_code irdma_sc_ceq_destroy(struct irdma_sc_ceq *ceq,
+						   u64 scratch, bool post_sq)
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
+	      LS_64(IRDMA_CQP_OP_DESTROY_CEQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(ceq->pbl_chunk_size, IRDMA_CQPSQ_CEQ_LPBLSIZE) |
+	      LS_64(ceq->virtual_map, IRDMA_CQPSQ_CEQ_VMAP) |
+	      LS_64(ceq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CEQ_DESTROY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+ */
+static void *irdma_sc_process_ceq(struct irdma_sc_dev *dev,
+				  struct irdma_sc_ceq *ceq)
+{
+	u64 temp;
+	__le64 *ceqe;
+	struct irdma_sc_cq *cq;
+	u8 polarity;
+	u32 cq_idx = 0;
+	unsigned long flags;
+
+	do {
+		ceqe = IRDMA_GET_CURRENT_CEQ_ELEM(ceq);
+		get_64bit_val(ceqe, 0, &temp);
+		polarity = (u8)RS_64(temp, IRDMA_CEQE_VALID);
+		if (polarity != ceq->polarity)
+			return NULL;
+
+		cq = (struct irdma_sc_cq *)(unsigned long)LS_64_1(temp, 1);
+		if (!cq)
+			return NULL;
+
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
+	irdma_sc_cq_ack(cq);
+
+	return cq;
+}
+
+/**
+ * irdma_sc_aeq_init - initialize aeq
+ * @aeq: aeq structure ptr
+ * @info: aeq initialization info
+ */
+static enum irdma_status_code
+irdma_sc_aeq_init(struct irdma_sc_aeq *aeq, struct irdma_aeq_init_info *info)
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
+	hdr = LS_64(IRDMA_CQP_OP_CREATE_AEQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(aeq->pbl_chunk_size, IRDMA_CQPSQ_AEQ_LPBLSIZE) |
+	      LS_64(aeq->virtual_map, IRDMA_CQPSQ_AEQ_VMAP) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "AEQ_CREATE WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	if (dev->privileged)
+		writel(0, dev->hw_regs[IRDMA_PFINT_AEQCTL]);
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+	set_64bit_val(wqe, 16, aeq->elem_cnt);
+	set_64bit_val(wqe, 48, aeq->first_pm_pbl_idx);
+	hdr = LS_64(IRDMA_CQP_OP_DESTROY_AEQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(aeq->pbl_chunk_size, IRDMA_CQPSQ_AEQ_LPBLSIZE) |
+	      LS_64(aeq->virtual_map, IRDMA_CQPSQ_AEQ_VMAP) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "AEQ_DESTROY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+static enum irdma_status_code
+irdma_sc_get_next_aeqe(struct irdma_sc_aeq *aeq, struct irdma_aeqe_info *info)
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
+	polarity = (u8)RS_64(temp, IRDMA_AEQE_VALID);
+
+	if (aeq->polarity != polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	irdma_debug_buf(aeq->dev, IRDMA_DEBUG_WQE, "AEQ_ENTRY WQE", aeqe, 16);
+
+	ae_src = (u8)RS_64(temp, IRDMA_AEQE_AESRC);
+	wqe_idx = (u16)RS_64(temp, IRDMA_AEQE_WQDESCIDX);
+	info->qp_cq_id = (u32)RS_64(temp, IRDMA_AEQE_QPCQID_LOW) |
+			 ((u32)RS_64(temp, IRDMA_AEQE_QPCQID_HI) << 18);
+	info->ae_id = (u16)RS_64(temp, IRDMA_AEQE_AECODE);
+	info->tcp_state = (u8)RS_64(temp, IRDMA_AEQE_TCPSTATE);
+	info->iwarp_state = (u8)RS_64(temp, IRDMA_AEQE_IWSTATE);
+	info->q2_data_written = (u8)RS_64(temp, IRDMA_AEQE_Q2DATA);
+	info->aeqe_overflow = (bool)RS_64(temp, IRDMA_AEQE_OVERFLOW);
+
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
+	case IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE:
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
+	case IRDMA_AE_LLP_CLOSE_COMPLETE:
+	case IRDMA_AE_LLP_CONNECTION_RESET:
+	case IRDMA_AE_LLP_FIN_RECEIVED:
+	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
+	case IRDMA_AE_LLP_SEGMENT_TOO_SMALL:
+	case IRDMA_AE_LLP_SYN_RECEIVED:
+	case IRDMA_AE_LLP_TERMINATE_RECEIVED:
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
+		ae_src = IRDMA_AE_SOURCE_RSVD;
+		break;
+	case IRDMA_AE_LCE_CQ_CATASTROPHIC:
+		info->cq = true;
+		info->compl_ctx = LS_64_1(compl_ctx, 1);
+		ae_src = IRDMA_AE_SOURCE_RSVD;
+		break;
+	case IRDMA_AE_ROCE_EMPTY_MCG:
+	case IRDMA_AE_ROCE_BAD_MC_IP_ADDR:
+	case IRDMA_AE_ROCE_BAD_MC_QPID:
+	case IRDMA_AE_MCG_QP_PROTOCOL_MISMATCH:
+		ae_src = IRDMA_AE_SOURCE_RSVD;
+		break;
+	default:
+		break;
+	}
+
+	switch (ae_src) {
+	case IRDMA_AE_SOURCE_RQ:
+	case IRDMA_AE_SOURCE_RQ_0011:
+		info->qp = true;
+		info->wqe_idx = wqe_idx;
+		info->compl_ctx = compl_ctx;
+		break;
+	case IRDMA_AE_SOURCE_CQ:
+	case IRDMA_AE_SOURCE_CQ_0110:
+	case IRDMA_AE_SOURCE_CQ_1010:
+	case IRDMA_AE_SOURCE_CQ_1110:
+		info->cq = true;
+		info->compl_ctx = LS_64_1(compl_ctx, 1);
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
+		/* fallthrough */
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
+static enum irdma_status_code
+irdma_sc_repost_aeq_entries(struct irdma_sc_dev *dev, u32 count)
+{
+	writel(count, dev->hw_regs[IRDMA_AEQALLOC]);
+
+	return 0;
+}
+
+/**
+ * irdma_sc_aeq_create_done - create aeq
+ * @aeq: aeq structure ptr
+ */
+static enum irdma_status_code irdma_sc_aeq_create_done(struct irdma_sc_aeq *aeq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	cqp = aeq->dev->cqp;
+
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_CREATE_AEQ,
+					     NULL);
+}
+
+/**
+ * irdma_sc_aeq_destroy_done - destroy of aeq during close
+ * @aeq: aeq structure ptr
+ */
+static enum irdma_status_code
+irdma_sc_aeq_destroy_done(struct irdma_sc_aeq *aeq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	cqp = aeq->dev->cqp;
+
+	return irdma_sc_poll_for_cqp_op_done(cqp, IRDMA_CQP_OP_DESTROY_AEQ,
+					     NULL);
+}
+
+/**
+ * irdma_sc_ccq_init - initialize control cq
+ * @cq: sc's cq ctruct
+ * @info: info for control cq initialization
+ */
+static enum irdma_status_code
+irdma_sc_ccq_init(struct irdma_sc_cq *cq, struct irdma_ccq_init_info *info)
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
+static enum irdma_status_code irdma_sc_ccq_create_done(struct irdma_sc_cq *ccq)
+{
+	struct irdma_sc_cqp *cqp;
+
+	cqp = ccq->dev->cqp;
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
+static enum irdma_status_code irdma_sc_ccq_create(struct irdma_sc_cq *ccq,
+						  u64 scratch,
+						  bool check_overflow,
+						  bool post_sq)
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
+static enum irdma_status_code irdma_sc_ccq_destroy(struct irdma_sc_cq *ccq,
+						   u64 scratch, bool post_sq)
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
+	set_64bit_val(wqe, 8, RS_64_1(ccq, 1));
+	set_64bit_val(wqe, 40, ccq->shadow_area_pa);
+
+	hdr = ccq->cq_uk.cq_id |
+	      LS_64((ccq->ceq_id_valid ? ccq->ceq_id : 0),
+		    IRDMA_CQPSQ_CQ_CEQID) |
+	      LS_64(IRDMA_CQP_OP_DESTROY_CQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(ccq->ceqe_mask, IRDMA_CQPSQ_CQ_ENCEQEMASK) |
+	      LS_64(ccq->ceq_id_valid, IRDMA_CQPSQ_CQ_CEQIDVALID) |
+	      LS_64(ccq->tph_en, IRDMA_CQPSQ_TPHEN) |
+	      LS_64(ccq->cq_uk.avoid_mem_cflct, IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "CCQ_DESTROY WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+	if (error)
+		return IRDMA_ERR_CQP_COMPL_ERROR;
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		ret_code = irdma_cqp_poll_registers(cqp, tail, 1000);
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
+	struct irdma_dma_mem query_fpm_mem;
+	enum irdma_status_code ret_code = 0;
+	bool poll_registers = true;
+	u8 wait_type;
+
+	if (hmc_fn_id > dev->hw_attrs.max_hw_vf_fpm_id ||
+	    (dev->hmc_fn_id != hmc_fn_id &&
+	     hmc_fn_id < dev->hw_attrs.first_hw_vf_fpm_id))
+		return IRDMA_ERR_INVALID_HMCFN_ID;
+
+	dev_dbg(rfdev_to_dev(dev), "HMC: hmc_fn_id %u, dev->hmc_fn_id %u\n",
+		hmc_fn_id, dev->hmc_fn_id);
+	if (hmc_fn_id == dev->hmc_fn_id) {
+		hmc_info = dev->hmc_info;
+		query_fpm_mem.pa = dev->fpm_query_buf_pa;
+		query_fpm_mem.va = dev->fpm_query_buf;
+	} else {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: Bad hmc function id: hmc_fn_id %u, dev->hmc_fn_id %u\n",
+			hmc_fn_id, dev->hmc_fn_id);
+
+		return IRDMA_ERR_INVALID_HMCFN_ID;
+	}
+	hmc_info->hmc_fn_id = hmc_fn_id;
+	wait_type = poll_registers ? (u8)IRDMA_CQP_WAIT_POLL_REGS :
+				     (u8)IRDMA_CQP_WAIT_POLL_CQ;
+
+	ret_code = irdma_sc_query_fpm_val(dev->cqp, 0, hmc_info->hmc_fn_id,
+					  &query_fpm_mem, true, wait_type);
+	if (ret_code)
+		return ret_code;
+
+	/* parse the fpm_query_buf and fill hmc obj info */
+	ret_code = irdma_sc_parse_fpm_query_buf(dev, query_fpm_mem.va, hmc_info,
+						&dev->hmc_fpm_misc);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_HMC, "QUERY FPM BUFFER",
+			query_fpm_mem.va, IRDMA_QUERY_FPM_BUF_SIZE);
+	return ret_code;
+}
+
+/**
+ * irdma_sc_configure_iw_fpm() - commits hmc obj cnt values using cqp command and
+ * populates fpm base address in hmc_info
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
+	bool poll_registers = true;
+	u8 wait_type;
+
+	if (hmc_fn_id > dev->hw_attrs.max_hw_vf_fpm_id ||
+	    (dev->hmc_fn_id != hmc_fn_id &&
+	     hmc_fn_id < dev->hw_attrs.first_hw_vf_fpm_id))
+		return IRDMA_ERR_INVALID_HMCFN_ID;
+
+	if (hmc_fn_id != dev->hmc_fn_id)
+		return IRDMA_ERR_INVALID_FPM_FUNC_ID;
+
+	hmc_info = dev->hmc_info;
+	if (!hmc_info)
+		return IRDMA_ERR_BAD_PTR;
+
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
+	wait_type = poll_registers ? (u8)IRDMA_CQP_WAIT_POLL_REGS :
+				     (u8)IRDMA_CQP_WAIT_POLL_CQ;
+	irdma_debug_buf(dev, IRDMA_DEBUG_HMC, "COMMIT FPM BUFFER",
+			commit_fpm_mem.va, IRDMA_COMMIT_FPM_BUF_SIZE);
+	ret_code = irdma_sc_commit_fpm_val(dev->cqp, 0, hmc_info->hmc_fn_id,
+					   &commit_fpm_mem, true, wait_type);
+	if (!ret_code)
+		ret_code = irdma_sc_parse_fpm_commit_buf(dev, dev->fpm_commit_buf,
+							 hmc_info->hmc_obj,
+							 &hmc_info->sd_table.sd_cnt);
+	irdma_debug_buf(dev, IRDMA_DEBUG_HMC, "COMMIT FPM BUFFER",
+			commit_fpm_mem.va, IRDMA_COMMIT_FPM_BUF_SIZE);
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
+	u64 offset;
+	u32 wqe_idx;
+
+	wqe = irdma_sc_cqp_get_next_send_wqe_idx(cqp, scratch, &wqe_idx);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	IRDMA_CQP_INIT_WQE(wqe);
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
+	data |= LS_64(info->hmc_fn_id, IRDMA_CQPSQ_UPESD_HMCFNID);
+	set_64bit_val(wqe, 16, data);
+
+	switch (wqe_entries) {
+	case 3:
+		set_64bit_val(wqe, 48,
+			      (LS_64(info->entry[2].cmd, IRDMA_CQPSQ_UPESD_SDCMD) |
+			       LS_64(1, IRDMA_CQPSQ_UPESD_ENTRY_VALID)));
+
+		set_64bit_val(wqe, 56, info->entry[2].data);
+		/* fallthrough */
+	case 2:
+		set_64bit_val(wqe, 32,
+			      (LS_64(info->entry[1].cmd, IRDMA_CQPSQ_UPESD_SDCMD) |
+			       LS_64(1, IRDMA_CQPSQ_UPESD_ENTRY_VALID)));
+
+		set_64bit_val(wqe, 40, info->entry[1].data);
+		/* fallthrough */
+	case 1:
+		set_64bit_val(wqe, 0,
+			      LS_64(info->entry[0].cmd, IRDMA_CQPSQ_UPESD_SDCMD));
+
+		set_64bit_val(wqe, 8, info->entry[0].data);
+		break;
+	default:
+		break;
+	}
+
+	hdr = LS_64(IRDMA_CQP_OP_UPDATE_PE_SDS, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID) |
+	      LS_64(mem_entries, IRDMA_CQPSQ_UPESD_ENTRY_COUNT);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "UPDATE_PE_SDS WQE", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	if (error)
+		return IRDMA_ERR_CQP_COMPL_ERROR;
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
+		      LS_64(hmc_fn_id, IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID));
+
+	hdr = LS_64(IRDMA_CQP_OP_SHMC_PAGES_ALLOCATED, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "SHMC_PAGES_ALLOCATED WQE",
+			wqe, IRDMA_CQP_WQE_SIZE * 8);
+	irdma_get_cqp_reg_info(cqp, &val, &tail, &error);
+	if (error)
+		return IRDMA_ERR_CQP_COMPL_ERROR;
+
+	if (post_sq) {
+		irdma_sc_cqp_post_sq(cqp);
+		if (poll_registers)
+			/* check for cqp sq tail update */
+			return irdma_cqp_poll_registers(cqp, tail, 1000);
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
+	if (dev->privileged)
+		size += round_up(hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt *
+			hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].size, 512);
+	if (size & 0x1FFFFF)
+		sd = (size >> 21) + 1; /* add 1 for remainder */
+	else
+		sd = size >> 21;
+	if (!dev->privileged) {
+		/* 2MB alignment for VF PBLE HMC */
+		size = hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt *
+		       hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].size;
+		if (size & 0x1FFFFF)
+			sd += (size >> 21) + 1; /* add 1 for remainder */
+		else
+			sd += size >> 21;
+	}
+	if (sd > 0xFFFFFFFF) {
+		dev_dbg(rfdev_to_dev(dev), "HMC: sd overflow[%lld]\n", sd);
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
+	temp = LS_64(cqp->polarity, IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID) |
+	       LS_64(buf->size, IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN) |
+	       LS_64(IRDMA_CQP_OP_QUERY_RDMA_FEATURES, IRDMA_CQPSQ_UP_OP);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, temp);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_WQE, "QUERY RDMA FEATURES", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
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
+	feat_buf.va = dma_alloc_coherent(hw_to_dev(dev->hw), feat_buf.size,
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
+	feat_cnt = (u16)RS_64(temp, IRDMA_FEATURE_CNT);
+	if (feat_cnt < 2) {
+		ret_code = IRDMA_ERR_INVALID_FEAT_CNT;
+		goto exit;
+	} else if (feat_cnt > IRDMA_MAX_FEATURES) {
+		dev_dbg(rfdev_to_dev(dev),
+			"DEV: feature buf size insufficient, retrying with larger buffer\n");
+		dma_free_coherent(hw_to_dev(dev->hw), feat_buf.size,
+				  feat_buf.va, feat_buf.pa);
+		feat_buf.va = NULL;
+		feat_buf.size = ALIGN(8 * feat_cnt,
+				      IRDMA_FEATURE_BUF_ALIGNMENT);
+		feat_buf.va = dma_alloc_coherent(hw_to_dev(dev->hw),
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
+		feat_cnt = (u16)RS_64(temp, IRDMA_FEATURE_CNT);
+		if (feat_cnt < 2) {
+			ret_code = IRDMA_ERR_INVALID_FEAT_CNT;
+			goto exit;
+		}
+	}
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_WQE, "QUERY RDMA FEATURES", feat_buf.va,
+			feat_cnt * 8);
+
+	for (byte_idx = 0, feat_idx = 0; feat_idx < min_t(u16, feat_cnt, IRDMA_MAX_FEATURES);
+	     feat_idx++, byte_idx += 8) {
+		get_64bit_val(feat_buf.va, byte_idx, &temp);
+		feat_type = RS_64(temp, IRDMA_FEATURE_TYPE);
+		if (feat_type >= IRDMA_MAX_FEATURES) {
+			dev_dbg(rfdev_to_dev(dev),
+				"DEV: found unrecognized feature type %d\n",
+				feat_type);
+			continue;
+		}
+		dev->feature_info[feat_type] = temp;
+	}
+exit:
+	dma_free_coherent(hw_to_dev(dev->hw), feat_buf.size, feat_buf.va,
+			  feat_buf.pa);
+	feat_buf.va = NULL;
+	return ret_code;
+}
+
+static void cfg_fpm_value_gen_1(struct irdma_sc_dev *dev,
+				struct irdma_hmc_info *hmc_info, u32 qpwanted)
+{
+	u32 powerof2 = 1;
+
+	while (powerof2 < dev->hw_attrs.max_hw_wqes)
+		powerof2 *= 2;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt = powerof2 * qpwanted;
+
+	powerof2 = 1;
+	while (powerof2 < dev->hw_attrs.max_hw_ird)
+		powerof2 *= 2;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].cnt = powerof2 * qpwanted * 2;
+}
+
+static void cfg_fpm_value_gen_2(struct irdma_sc_dev *dev,
+				struct irdma_hmc_info *hmc_info, u32 qpwanted)
+{
+	struct irdma_hmc_fpm_misc *hmc_fpm_misc = &dev->hmc_fpm_misc;
+
+	hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt =
+		2 * hmc_fpm_misc->xf_block_size * qpwanted;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].cnt = 2 * 16 * qpwanted;
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
+ * irdma_config_fpm_values - configure HMC objects
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
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: irdma_sc_init_iw_hmc returned error_code = %d\n",
+			ret_code);
+		return ret_code;
+	}
+
+	for (i = IRDMA_HMC_IW_QP; i < IRDMA_HMC_IW_MAX; i++)
+		hmc_info->hmc_obj[i].cnt = hmc_info->hmc_obj[i].max_cnt;
+	sd_needed = irdma_est_sd(dev, hmc_info);
+	dev_dbg(rfdev_to_dev(dev),
+		"HMC: FW max resources sd_needed[%08d] first_sd_index[%04d]\n",
+		sd_needed, hmc_info->first_sd_index);
+	dev_dbg(rfdev_to_dev(dev), "HMC: sd count %d where max sd is %d\n",
+		hmc_info->sd_table.sd_cnt, hmc_fpm_misc->max_sds);
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
+	dev_dbg(rfdev_to_dev(dev),
+		"HMC: req_qp=%d max_sd=%d, max_qp = %d, max_cq=%d, max_mr=%d, max_pble=%d, mc=%d, av=%d\n",
+		qp_count, hmc_fpm_misc->max_sds,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].max_cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_MR].max_cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].max_cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].max_cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].max_cnt);
+	hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].max_cnt;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].max_cnt;
+	hmc_info->hmc_obj[IRDMA_HMC_IW_ARP].cnt =
+		hmc_info->hmc_obj[IRDMA_HMC_IW_ARP].max_cnt;
+
+	hmc_info->hmc_obj[IRDMA_HMC_IW_APBVT_ENTRY].cnt = 1;
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
+		hmc_info->hmc_obj[IRDMA_HMC_IW_XFFL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_XF].cnt / hmc_fpm_misc->xf_block_size;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_Q1FL].cnt =
+			hmc_info->hmc_obj[IRDMA_HMC_IW_Q1].cnt / hmc_fpm_misc->q1_block_size;
+		hmc_info->hmc_obj[IRDMA_HMC_IW_TIMER].cnt =
+			(round_up(qpwanted, 512) / 512 + 1) * hmc_fpm_misc->timer_bucket;
+
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt = pblewanted;
+		sd_needed = irdma_est_sd(dev, hmc_info);
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: sd_needed = %d, hmc_fpm_misc->max_sds=%d, mrwanted=%d, pblewanted=%d qpwanted=%d\n",
+			sd_needed, hmc_fpm_misc->max_sds, mrwanted,
+			pblewanted, qpwanted);
+
+		/* Do not reduce resources further. All objects fit with max SDs */
+		if (sd_needed <= hmc_fpm_misc->max_sds)
+			break;
+
+		sd_diff = sd_needed - hmc_fpm_misc->max_sds;
+		if (sd_diff > 128) {
+			if (qpwanted > 128)
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
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: cfg_fpm failed loop_cnt=%d, sd_needed=%d, max sd count %d\n",
+			loop_count, sd_needed, hmc_info->sd_table.sd_cnt);
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
+	dev_dbg(rfdev_to_dev(dev),
+		"HMC: loop_cnt=%d, sd_needed=%d, qpcnt = %d, cqcnt=%d, mrcnt=%d, pblecnt=%d, mc=%d, ah=%d, max sd count %d, first sd index %d\n",
+		loop_count, sd_needed, hmc_info->hmc_obj[IRDMA_HMC_IW_QP].cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_MR].cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIMC].cnt,
+		hmc_info->hmc_obj[IRDMA_HMC_IW_FSIAV].cnt,
+		hmc_info->sd_table.sd_cnt, hmc_info->first_sd_index);
+
+	ret_code = irdma_sc_cfg_iw_fpm(dev, dev->hmc_fn_id);
+	if (ret_code) {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: cfg_iw_fpm returned error_code[x%08X]\n",
+			readl(dev->hw_regs[IRDMA_CQPERRCODES]));
+		return ret_code;
+	}
+
+	mem_size = sizeof(struct irdma_hmc_sd_entry) *
+		   (hmc_info->sd_table.sd_cnt + hmc_info->first_sd_index + 1);
+	virt_mem.size = mem_size;
+	virt_mem.va = kzalloc(virt_mem.size, GFP_ATOMIC);
+	if (!virt_mem.va) {
+		dev_dbg(rfdev_to_dev(dev),
+			"HMC: failed to allocate memory for sd_entry buffer\n");
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
+		/* fall-through */
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
+		status =
+			irdma_sc_dealloc_stag(pcmdinfo->in.u.dealloc_stag.dev,
+					      &pcmdinfo->in.u.dealloc_stag.info,
+					      pcmdinfo->in.u.dealloc_stag.scratch,
+					      pcmdinfo->post_sq);
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
+		status = dev->cqp_misc_ops->alloc_local_mac_entry(pcmdinfo->in.u.alloc_local_mac_entry.cqp,
+								  pcmdinfo->in.u.alloc_local_mac_entry.scratch,
+								  pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_ADD_LOCAL_MAC_ENTRY:
+		status = dev->cqp_misc_ops->add_local_mac_entry(pcmdinfo->in.u.add_local_mac_entry.cqp,
+								&pcmdinfo->in.u.add_local_mac_entry.info,
+								pcmdinfo->in.u.add_local_mac_entry.scratch,
+								pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_DELETE_LOCAL_MAC_ENTRY:
+		status = dev->cqp_misc_ops->del_local_mac_entry(pcmdinfo->in.u.del_local_mac_entry.cqp,
+								pcmdinfo->in.u.del_local_mac_entry.scratch,
+								pcmdinfo->in.u.del_local_mac_entry.entry_idx,
+								pcmdinfo->in.u.del_local_mac_entry.ignore_ref_count,
+								pcmdinfo->post_sq);
+		break;
+	case IRDMA_OP_AH_CREATE:
+		status = dev->iw_uda_ops->create_ah(pcmdinfo->in.u.ah_create.cqp,
+						    &pcmdinfo->in.u.ah_create.info,
+						    pcmdinfo->in.u.ah_create.scratch);
+		break;
+	case IRDMA_OP_AH_DESTROY:
+		status = dev->iw_uda_ops->destroy_ah(pcmdinfo->in.u.ah_destroy.cqp,
+						     &pcmdinfo->in.u.ah_destroy.info,
+						     pcmdinfo->in.u.ah_destroy.scratch);
+		break;
+	case IRDMA_OP_MC_CREATE:
+		status = dev->iw_uda_ops->mcast_grp_create(pcmdinfo->in.u.mc_create.cqp,
+							   &pcmdinfo->in.u.mc_create.info,
+							   pcmdinfo->in.u.mc_create.scratch);
+		break;
+	case IRDMA_OP_MC_DESTROY:
+		status = dev->iw_uda_ops->mcast_grp_destroy(pcmdinfo->in.u.mc_destroy.cqp,
+							    &pcmdinfo->in.u.mc_destroy.info,
+							    pcmdinfo->in.u.mc_destroy.scratch);
+		break;
+	case IRDMA_OP_MC_MODIFY:
+		status = dev->iw_uda_ops->mcast_grp_modify(pcmdinfo->in.u.mc_modify.cqp,
+							   &pcmdinfo->in.u.mc_modify.info,
+							   pcmdinfo->in.u.mc_modify.scratch);
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
+ * irdma_enable_irq - Enable interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ */
+static void irdma_ena_irq(struct irdma_sc_dev *dev, u32 idx)
+{
+	u32 val;
+
+	val = IRDMA_GLINT_DYN_CTL_INTENA_M | IRDMA_GLINT_DYN_CTL_CLEARPBA_M |
+	      IRDMA_GLINT_DYN_CTL_ITR_INDX_M;
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1)
+		writel(val, dev->hw_regs[IRDMA_GLINT_DYN_CTL] + idx);
+	else
+		writel(val, dev->hw_regs[IRDMA_GLINT_DYN_CTL] + (idx - 1));
+}
+
+/**
+ * irdma_disable_irq - Disable interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ */
+static void irdma_disable_irq(struct irdma_sc_dev *dev, u32 idx)
+{
+	if (dev->hw_attrs.uk_attrs.hw_rev != IRDMA_GEN_1)
+		writel(0, dev->hw_regs[IRDMA_GLINT_DYN_CTL] + idx);
+	else
+		writel(0, dev->hw_regs[IRDMA_GLINT_DYN_CTL] + (idx - 1));
+}
+
+/**
+ * irdma_config_ceq- Configure CEQ interrupt
+ * @dev: pointer to the device structure
+ * @ceq_id: Completion Event Queue ID
+ * @idx: vector index
+ */
+static void irdma_cfg_ceq(struct irdma_sc_dev *dev, u32 ceq_id, u32 idx)
+{
+	u32 reg_val;
+
+	reg_val = (IRDMA_GLINT_CEQCTL_CAUSE_ENA_M |
+		   (idx << IRDMA_GLINT_CEQCTL_MSIX_INDX_S) |
+		   IRDMA_GLINT_CEQCTL_ITR_INDX_M);
+
+	writel(reg_val, dev->hw_regs[IRDMA_GLINT_CEQCTL] + ceq_id);
+}
+
+/**
+ * irdma_config_aeq- Configure AEQ interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ */
+static void irdma_cfg_aeq(struct irdma_sc_dev *dev, u32 idx)
+{
+	u32 reg_val;
+
+	reg_val = (IRDMA_PFINT_AEQCTL_CAUSE_ENA_M |
+		   (idx << IRDMA_PFINT_AEQCTL_MSIX_INDX_S) |
+		   IRDMA_PFINT_AEQCTL_ITR_INDX_M);
+
+	writel(reg_val, dev->hw_regs[IRDMA_PFINT_AEQCTL]);
+}
+
+/* iwarp pd ops */
+static struct irdma_pd_ops iw_pd_ops = {
+	.pd_init = irdma_sc_pd_init
+};
+
+static struct irdma_priv_qp_ops iw_priv_qp_ops = {
+	.iw_mr_fast_register = irdma_sc_mr_fast_register,
+	.qp_create = irdma_sc_qp_create,
+	.qp_destroy = irdma_sc_qp_destroy,
+	.qp_flush_wqes = irdma_sc_qp_flush_wqes,
+	.qp_init = irdma_sc_qp_init,
+	.qp_modify = irdma_sc_qp_modify,
+	.qp_send_lsmm = irdma_sc_send_lsmm,
+	.qp_send_lsmm_nostag = irdma_sc_send_lsmm_nostag,
+	.qp_send_rtt = irdma_sc_send_rtt,
+	.qp_setctx = irdma_sc_qp_setctx,
+	.qp_setctx_roce = irdma_sc_qp_setctx_roce,
+	.qp_upload_context = irdma_sc_qp_upload_context,
+	.update_resume_qp = irdma_sc_resume_qp,
+	.update_suspend_qp = irdma_sc_suspend_qp,
+};
+
+static struct irdma_mr_ops iw_mr_ops = {
+	.alloc_stag = irdma_sc_alloc_stag,
+	.dealloc_stag = irdma_sc_dealloc_stag,
+	.mr_reg_non_shared = irdma_sc_mr_reg_non_shared,
+	.mr_reg_shared = irdma_sc_mr_reg_shared,
+	.mw_alloc = irdma_sc_mw_alloc,
+	.query_stag = irdma_sc_query_stag,
+};
+
+static struct irdma_cqp_misc_ops iw_cqp_misc_ops = {
+	.add_arp_cache_entry = irdma_sc_add_arp_cache_entry,
+	.add_local_mac_entry = irdma_sc_add_local_mac_entry,
+	.alloc_local_mac_entry = irdma_sc_alloc_local_mac_entry,
+	.cqp_nop = irdma_sc_cqp_nop,
+	.del_arp_cache_entry = irdma_sc_del_arp_cache_entry,
+	.del_local_mac_entry = irdma_sc_del_local_mac_entry,
+	.gather_stats = irdma_sc_gather_stats,
+	.manage_apbvt_entry = irdma_sc_manage_apbvt_entry,
+	.manage_push_page = irdma_sc_manage_push_page,
+	.manage_qhash_table_entry = irdma_sc_manage_qhash_table_entry,
+	.manage_stats_instance = irdma_sc_manage_stats_inst,
+	.manage_ws_node = irdma_sc_manage_ws_node,
+	.query_arp_cache_entry = irdma_sc_query_arp_cache_entry,
+	.query_rdma_features = irdma_sc_query_rdma_features,
+	.set_up_map = irdma_sc_set_up_map,
+};
+
+static struct irdma_irq_ops iw_irq_ops = {
+	.irdma_cfg_aeq = irdma_cfg_aeq,
+	.irdma_cfg_ceq = irdma_cfg_ceq,
+	.irdma_dis_irq = irdma_disable_irq,
+	.irdma_en_irq = irdma_ena_irq,
+};
+
+static struct irdma_cqp_ops iw_cqp_ops = {
+	.check_cqp_progress = irdma_check_cqp_progress,
+	.cqp_create = irdma_sc_cqp_create,
+	.cqp_destroy = irdma_sc_cqp_destroy,
+	.cqp_get_next_send_wqe = irdma_sc_cqp_get_next_send_wqe,
+	.cqp_init = irdma_sc_cqp_init,
+	.cqp_post_sq = irdma_sc_cqp_post_sq,
+	.poll_for_cqp_op_done = irdma_sc_poll_for_cqp_op_done,
+};
+
+static struct irdma_priv_cq_ops iw_priv_cq_ops = {
+	.cq_ack = irdma_sc_cq_ack,
+	.cq_create = irdma_sc_cq_create,
+	.cq_destroy = irdma_sc_cq_destroy,
+	.cq_init = irdma_sc_cq_init,
+	.cq_modify = irdma_sc_cq_modify,
+	.cq_resize = irdma_sc_cq_resize,
+};
+
+static struct irdma_ccq_ops iw_ccq_ops = {
+	.ccq_arm = irdma_sc_ccq_arm,
+	.ccq_create = irdma_sc_ccq_create,
+	.ccq_create_done = irdma_sc_ccq_create_done,
+	.ccq_destroy = irdma_sc_ccq_destroy,
+	.ccq_get_cqe_info = irdma_sc_ccq_get_cqe_info,
+	.ccq_init = irdma_sc_ccq_init,
+};
+
+static struct irdma_ceq_ops iw_ceq_ops = {
+	.cceq_create = irdma_sc_cceq_create,
+	.cceq_create_done = irdma_sc_cceq_create_done,
+	.cceq_destroy_done = irdma_sc_cceq_destroy_done,
+	.ceq_create = irdma_sc_ceq_create,
+	.ceq_destroy = irdma_sc_ceq_destroy,
+	.ceq_init = irdma_sc_ceq_init,
+	.process_ceq = irdma_sc_process_ceq,
+};
+
+static struct irdma_aeq_ops iw_aeq_ops = {
+	.aeq_create = irdma_sc_aeq_create,
+	.aeq_create_done = irdma_sc_aeq_create_done,
+	.aeq_destroy = irdma_sc_aeq_destroy,
+	.aeq_destroy_done = irdma_sc_aeq_destroy_done,
+	.aeq_init = irdma_sc_aeq_init,
+	.get_next_aeqe = irdma_sc_get_next_aeqe,
+	.repost_aeq_entries = irdma_sc_repost_aeq_entries,
+};
+
+static struct irdma_hmc_ops iw_hmc_ops = {
+	.cfg_iw_fpm = irdma_sc_cfg_iw_fpm,
+	.commit_fpm_val = irdma_sc_commit_fpm_val,
+	.commit_fpm_val_done = irdma_sc_commit_fpm_val_done,
+	.create_hmc_object = irdma_sc_create_hmc_obj,
+	.del_hmc_object = irdma_sc_del_hmc_obj,
+	.init_iw_hmc = irdma_sc_init_iw_hmc,
+	.manage_hmc_pm_func_table = irdma_sc_manage_hmc_pm_func_table,
+	.manage_hmc_pm_func_table_done = irdma_sc_manage_hmc_pm_func_table_done,
+	.parse_fpm_commit_buf = irdma_sc_parse_fpm_commit_buf,
+	.parse_fpm_query_buf = irdma_sc_parse_fpm_query_buf,
+	.pf_init_vfhmc = NULL,
+	.query_fpm_val = irdma_sc_query_fpm_val,
+	.query_fpm_val_done = irdma_sc_query_fpm_val_done,
+	.static_hmc_pages_allocated = irdma_sc_static_hmc_pages_allocated,
+	.vf_cfg_vffpm = NULL,
+};
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
+/**
+ * irdma_sc_ctrl_init - Initialize control part of device
+ * @ver: version
+ * @dev: Device pointer
+ * @info: Device init info
+ */
+enum irdma_status_code irdma_sc_ctrl_init(enum irdma_vers ver,
+					  struct irdma_sc_dev *dev,
+					  struct irdma_device_init_info *info)
+{
+	u32 val;
+	u16 hmc_fcn = 0;
+	enum irdma_status_code ret_code = 0;
+	u8 db_size;
+
+	spin_lock_init(&dev->cqp_lock);
+	INIT_LIST_HEAD(&dev->cqp_cmd_head); /* for CQP command backlog */
+	dev->hmc_fn_id = info->hmc_fn_id;
+	dev->privileged = info->privileged;
+	dev->fpm_query_buf_pa = info->fpm_query_buf_pa;
+	dev->fpm_query_buf = info->fpm_query_buf;
+	dev->fpm_commit_buf_pa = info->fpm_commit_buf_pa;
+	dev->fpm_commit_buf = info->fpm_commit_buf;
+	dev->hw = info->hw;
+	dev->hw->hw_addr = info->bar0;
+	dev->irq_ops = &iw_irq_ops;
+	dev->cqp_ops = &iw_cqp_ops;
+	dev->ccq_ops = &iw_ccq_ops;
+	dev->ceq_ops = &iw_ceq_ops;
+	dev->aeq_ops = &iw_aeq_ops;
+	dev->hmc_ops = &iw_hmc_ops;
+	dev->iw_priv_cq_ops = &iw_priv_cq_ops;
+
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
+	dev->hw_attrs.max_hw_vf_fpm_id = IRDMA_MAX_VF_FPM_ID;
+	dev->hw_attrs.first_hw_vf_fpm_id = IRDMA_FIRST_VF_FPM_ID;
+	dev->hw_attrs.uk_attrs.max_hw_inline = IRDMA_MAX_INLINE_DATA_SIZE;
+	dev->hw_attrs.max_hw_ird = IRDMA_MAX_IRD_SIZE;
+	dev->hw_attrs.max_hw_ord = IRDMA_MAX_ORD_SIZE;
+	dev->hw_attrs.max_hw_wqes = IRDMA_MAX_WQ_ENTRIES;
+	dev->hw_attrs.max_qp_wr = IRDMA_MAX_QP_WRS;
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
+
+	info->init_hw(dev);
+	if (dev->privileged) {
+		if (irdma_wait_pe_ready(dev))
+			return IRDMA_ERR_TIMEOUT;
+
+		val = readl(dev->hw_regs[IRDMA_GLPCI_LBARCTRL]);
+		db_size = (u8)RS_32(val, IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE);
+		if (db_size != IRDMA_PE_DB_SIZE_4M &&
+		    db_size != IRDMA_PE_DB_SIZE_8M) {
+			pr_err("RDMA feature not enabled! db_size=%d\n",
+			       db_size);
+			return IRDMA_ERR_PE_DOORBELL_NOT_ENA;
+		}
+	}
+	dev->hw->hmc.hmc_fn_id = (u8)hmc_fcn;
+	dev->db_addr = dev->hw->hw_addr + (uintptr_t)dev->hw_regs[IRDMA_DB_ADDR_OFFSET];
+
+	return ret_code;
+}
+
+/**
+ * irdma_sc_rt_init - Runtime initialize device
+ * @dev: IWARP device pointer
+ */
+void irdma_sc_rt_init(struct irdma_sc_dev *dev)
+{
+	mutex_init(&dev->ws_mutex);
+	irdma_device_init_uk(&dev->dev_uk);
+	dev->cqp_misc_ops = &iw_cqp_misc_ops;
+	dev->iw_pd_ops = &iw_pd_ops;
+	dev->iw_priv_qp_ops = &iw_priv_qp_ops;
+	dev->mr_ops = &iw_mr_ops;
+	dev->iw_uda_ops = &irdma_uda_ops;
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
index 000000000000..156d27be612e
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -0,0 +1,2132 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
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
+#define IRDMA_VF_PUSH_OFFSET		((8 + 64) * 1024)
+#define IRDMA_VF_FIRST_PUSH_PAGE_INDEX	2
+#define IRDMA_VF_BAR_RSVD		4096
+#define IRDMA_VF_STATS_SIZE_V0	280
+
+#define IRDMA_PE_DB_SIZE_4M	1
+#define IRDMA_PE_DB_SIZE_8M	2
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
+#define IRDMA_QP_STATE_RTR		4
+#define IRDMA_QP_STATE_TERMINATE	5
+#define IRDMA_QP_STATE_ERROR		6
+
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
+#define IRDMA_MAX_ENCODED_IRD_SIZE	4
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
+/* CQP SQ WQES */
+#define IRDMA_QP_TYPE_IWARP	1
+#define IRDMA_QP_TYPE_UDA	2
+#define IRDMA_QP_TYPE_ROCE_RC	3
+#define IRDMA_QP_TYPE_ROCE_UD	4
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
+#define IRDMA_MAX_QP_WRS (((IRDMA_QP_SW_MAX_WQ_QUANTA - IRDMA_SQ_RSVD) / IRDMA_MAX_QUANTA_PER_WR))
+
+#define IRDMAQP_TERM_SEND_TERM_AND_FIN		0
+#define IRDMAQP_TERM_SEND_TERM_ONLY		1
+#define IRDMAQP_TERM_SEND_FIN_ONLY		2
+#define IRDMAQP_TERM_DONOT_SEND_TERM_OR_FIN	3
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
+
+#define IRDMA_SQ_RSVD	258
+#define IRDMA_RQ_RSVD	1
+
+#define IRDMA_FEATURE_RTS_AE			1ULL
+#define IRDMA_FEATURE_CQ_RESIZE			2ULL
+
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
+#define IRDMA_OP_CEQ_DESTROY			1
+#define IRDMA_OP_AEQ_DESTROY			2
+#define IRDMA_OP_DELETE_ARP_CACHE_ENTRY		3
+#define IRDMA_OP_MANAGE_APBVT_ENTRY		4
+#define IRDMA_OP_CEQ_CREATE			5
+#define IRDMA_OP_AEQ_CREATE			6
+#define IRDMA_OP_MANAGE_QHASH_TABLE_ENTRY	7
+#define IRDMA_OP_QP_MODIFY			8
+#define IRDMA_OP_QP_UPLOAD_CONTEXT		9
+#define IRDMA_OP_CQ_CREATE			10
+#define IRDMA_OP_CQ_DESTROY			11
+#define IRDMA_OP_QP_CREATE			12
+#define IRDMA_OP_QP_DESTROY			13
+#define IRDMA_OP_ALLOC_STAG			14
+#define IRDMA_OP_MR_REG_NON_SHARED		15
+#define IRDMA_OP_DEALLOC_STAG			16
+#define IRDMA_OP_MW_ALLOC			17
+#define IRDMA_OP_QP_FLUSH_WQES			18
+#define IRDMA_OP_ADD_ARP_CACHE_ENTRY		19
+#define IRDMA_OP_MANAGE_PUSH_PAGE		20
+#define IRDMA_OP_UPDATE_PE_SDS			21
+#define IRDMA_OP_MANAGE_HMC_PM_FUNC_TABLE	22
+#define IRDMA_OP_SUSPEND			23
+#define IRDMA_OP_RESUME				24
+#define IRDMA_OP_MANAGE_VF_PBLE_BP		25
+#define IRDMA_OP_QUERY_FPM_VAL			26
+#define IRDMA_OP_COMMIT_FPM_VAL			27
+#define IRDMA_OP_REQ_CMDS			28
+#define IRDMA_OP_CMPL_CMDS			29
+#define IRDMA_OP_AH_CREATE			30
+#define IRDMA_OP_AH_MODIFY			31
+#define IRDMA_OP_AH_DESTROY			32
+#define IRDMA_OP_MC_CREATE			33
+#define IRDMA_OP_MC_DESTROY			34
+#define IRDMA_OP_MC_MODIFY			35
+#define IRDMA_OP_STATS_ALLOCATE			36
+#define IRDMA_OP_STATS_FREE			37
+#define IRDMA_OP_STATS_GATHER			38
+#define IRDMA_OP_WS_ADD_NODE			39
+#define IRDMA_OP_WS_MODIFY_NODE			40
+#define IRDMA_OP_WS_DELETE_NODE			41
+#define IRDMA_OP_SET_UP_MAP			42
+#define IRDMA_OP_GEN_AE				43
+#define IRDMA_OP_QUERY_RDMA_FEATURES		44
+#define IRDMA_OP_ALLOC_LOCAL_MAC_ENTRY		45
+#define IRDMA_OP_ADD_LOCAL_MAC_ENTRY		46
+#define IRDMA_OP_DELETE_LOCAL_MAC_ENTRY		47
+#define IRDMA_OP_CQ_MODIFY                      48
+#define IRDMA_OP_SIZE_CQP_STAT_ARRAY		49
+
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
+#define LS_64_1(val, bits)	((u64)(uintptr_t)(val) << (bits))
+#define RS_64_1(val, bits)	((u64)(uintptr_t)(val) >> (bits))
+#define LS_32_1(val, bits)	(u32)((val) << (bits))
+#define RS_32_1(val, bits)	(u32)((val) >> (bits))
+#define LS_64(val, field)	(((u64)(val) << field ## _S) & (field ## _M))
+#define RS_64(val, field)	((u64)((val) & field ## _M) >> field ## _S)
+#define LS_32(val, field)	(((val) << field ## _S) & (field ## _M))
+#define RS_32(val, field)	(((val) & field ## _M) >> field ## _S)
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
+#define FW_MAJOR_VER(dev)	\
+	((u16)RS_64((dev)->feature_info[IRDMA_FEATURE_FW_INFO], IRDMA_FW_VER_MAJOR))
+#define FW_MINOR_VER(dev)	\
+	((u16)RS_64((dev)->feature_info[IRDMA_FEATURE_FW_INFO], IRDMA_FW_VER_MINOR))
+
+#define IRDMA_STATS_DELTA(a, b, c) ((a) >= (b) ? (a) - (b) : (a) + (c) - (b))
+#define IRDMA_MAX_STATS_32	0xFFFFFFFFULL
+#define IRDMA_MAX_STATS_48	0xFFFFFFFFFFFFULL
+
+#define IRDMA_MAX_CQ_READ_THRESH 0x3FFFF
+/* ILQ CQP hash table fields */
+#define IRDMA_CQPSQ_QHASH_VLANID_S 32
+#define IRDMA_CQPSQ_QHASH_VLANID_M \
+	((u64)0xfff << IRDMA_CQPSQ_QHASH_VLANID_S)
+
+#define IRDMA_CQPSQ_QHASH_QPN_S 32
+#define IRDMA_CQPSQ_QHASH_QPN_M \
+	((u64)0x3ffff << IRDMA_CQPSQ_QHASH_QPN_S)
+
+#define IRDMA_CQPSQ_QHASH_QS_HANDLE_S 0
+#define IRDMA_CQPSQ_QHASH_QS_HANDLE_M ((u64)0x3ff << IRDMA_CQPSQ_QHASH_QS_HANDLE_S)
+
+#define IRDMA_CQPSQ_QHASH_SRC_PORT_S 16
+#define IRDMA_CQPSQ_QHASH_SRC_PORT_M \
+	((u64)0xffff << IRDMA_CQPSQ_QHASH_SRC_PORT_S)
+
+#define IRDMA_CQPSQ_QHASH_DEST_PORT_S 0
+#define IRDMA_CQPSQ_QHASH_DEST_PORT_M \
+	((u64)0xffff << IRDMA_CQPSQ_QHASH_DEST_PORT_S)
+
+#define IRDMA_CQPSQ_QHASH_ADDR0_S 32
+#define IRDMA_CQPSQ_QHASH_ADDR0_M \
+	((u64)0xffffffff << IRDMA_CQPSQ_QHASH_ADDR0_S)
+
+#define IRDMA_CQPSQ_QHASH_ADDR1_S 0
+#define IRDMA_CQPSQ_QHASH_ADDR1_M \
+	((u64)0xffffffff << IRDMA_CQPSQ_QHASH_ADDR1_S)
+
+#define IRDMA_CQPSQ_QHASH_ADDR2_S 32
+#define IRDMA_CQPSQ_QHASH_ADDR2_M \
+	((u64)0xffffffff << IRDMA_CQPSQ_QHASH_ADDR2_S)
+
+#define IRDMA_CQPSQ_QHASH_ADDR3_S 0
+#define IRDMA_CQPSQ_QHASH_ADDR3_M \
+	((u64)0xffffffff << IRDMA_CQPSQ_QHASH_ADDR3_S)
+
+#define IRDMA_CQPSQ_QHASH_WQEVALID_S 63
+#define IRDMA_CQPSQ_QHASH_WQEVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QHASH_WQEVALID_S)
+#define IRDMA_CQPSQ_QHASH_OPCODE_S 32
+#define IRDMA_CQPSQ_QHASH_OPCODE_M \
+	((u64)0x3f << IRDMA_CQPSQ_QHASH_OPCODE_S)
+
+#define IRDMA_CQPSQ_QHASH_MANAGE_S 61
+#define IRDMA_CQPSQ_QHASH_MANAGE_M \
+	((u64)0x3 << IRDMA_CQPSQ_QHASH_MANAGE_S)
+
+#define IRDMA_CQPSQ_QHASH_IPV4VALID_S 60
+#define IRDMA_CQPSQ_QHASH_IPV4VALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QHASH_IPV4VALID_S)
+
+#define IRDMA_CQPSQ_QHASH_VLANVALID_S 59
+#define IRDMA_CQPSQ_QHASH_VLANVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QHASH_VLANVALID_S)
+
+#define IRDMA_CQPSQ_QHASH_ENTRYTYPE_S 42
+#define IRDMA_CQPSQ_QHASH_ENTRYTYPE_M \
+	((u64)0x7 << IRDMA_CQPSQ_QHASH_ENTRYTYPE_S)
+
+/* Stats */
+#define IRDMA_CQPSQ_STATS_WQEVALID_S 63
+#define IRDMA_CQPSQ_STATS_WQEVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_STATS_WQEVALID_S)
+
+#define IRDMA_CQPSQ_STATS_ALLOC_INST_S 62
+#define IRDMA_CQPSQ_STATS_ALLOC_INST_M \
+	BIT_ULL(IRDMA_CQPSQ_STATS_ALLOC_INST_S)
+
+#define IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX_S 60
+#define IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX_M \
+	BIT_ULL(IRDMA_CQPSQ_STATS_USE_HMC_FCN_INDEX_S)
+
+#define IRDMA_CQPSQ_STATS_USE_INST_S 61
+#define IRDMA_CQPSQ_STATS_USE_INST_M \
+	BIT_ULL(IRDMA_CQPSQ_STATS_USE_INST_S)
+
+#define IRDMA_CQPSQ_STATS_OP_S 32
+#define IRDMA_CQPSQ_STATS_OP_M \
+	((u64)0x3f << IRDMA_CQPSQ_STATS_OP_S)
+
+#define IRDMA_CQPSQ_STATS_INST_INDEX_S 0
+#define IRDMA_CQPSQ_STATS_INST_INDEX_M \
+	((u64)0x7f << IRDMA_CQPSQ_STATS_INST_INDEX_S)
+
+#define IRDMA_CQPSQ_STATS_HMC_FCN_INDEX_S 0
+#define IRDMA_CQPSQ_STATS_HMC_FCN_INDEX_M \
+	((u64)0x3f << IRDMA_CQPSQ_STATS_HMC_FCN_INDEX_S)
+
+/* WS - Work Scheduler */
+#define IRDMA_CQPSQ_WS_WQEVALID_S 63
+#define IRDMA_CQPSQ_WS_WQEVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_WS_WQEVALID_S)
+
+#define IRDMA_CQPSQ_WS_NODEOP_S 52
+#define IRDMA_CQPSQ_WS_NODEOP_M \
+	((u64)0x3 << IRDMA_CQPSQ_WS_NODEOP_S)
+
+#define IRDMA_CQPSQ_WS_ENABLENODE_S 62
+#define IRDMA_CQPSQ_WS_ENABLENODE_M \
+	BIT_ULL(IRDMA_CQPSQ_WS_ENABLENODE_S)
+
+#define IRDMA_CQPSQ_WS_NODETYPE_S 61
+#define IRDMA_CQPSQ_WS_NODETYPE_M \
+	BIT_ULL(IRDMA_CQPSQ_WS_NODETYPE_S)
+
+#define IRDMA_CQPSQ_WS_PRIOTYPE_S 59
+#define IRDMA_CQPSQ_WS_PRIOTYPE_M \
+	((u64)0x3 << IRDMA_CQPSQ_WS_PRIOTYPE_S)
+
+#define IRDMA_CQPSQ_WS_TC_S 56
+#define IRDMA_CQPSQ_WS_TC_M \
+	((u64)0x7 << IRDMA_CQPSQ_WS_TC_S)
+
+#define IRDMA_CQPSQ_WS_VMVFTYPE_S 54
+#define IRDMA_CQPSQ_WS_VMVFTYPE_M \
+	((u64)0x3 << IRDMA_CQPSQ_WS_VMVFTYPE_S)
+
+#define IRDMA_CQPSQ_WS_VMVFNUM_S 42
+#define IRDMA_CQPSQ_WS_VMVFNUM_M \
+	((u64)0x3ff << IRDMA_CQPSQ_WS_VMVFNUM_S)
+
+#define IRDMA_CQPSQ_WS_OP_S 32
+#define IRDMA_CQPSQ_WS_OP_M \
+	((u64)0x3f << IRDMA_CQPSQ_WS_OP_S)
+
+#define IRDMA_CQPSQ_WS_PARENTID_S 16
+#define IRDMA_CQPSQ_WS_PARENTID_M \
+	((u64)0x3ff << IRDMA_CQPSQ_WS_PARENTID_S)
+
+#define IRDMA_CQPSQ_WS_NODEID_S 0
+#define IRDMA_CQPSQ_WS_NODEID_M \
+	((u64)0x3ff << IRDMA_CQPSQ_WS_NODEID_S)
+
+#define IRDMA_CQPSQ_WS_VSI_S 48
+#define IRDMA_CQPSQ_WS_VSI_M \
+	((u64)0x3ff << IRDMA_CQPSQ_WS_VSI_S)
+
+#define IRDMA_CQPSQ_WS_WEIGHT_S 32
+#define IRDMA_CQPSQ_WS_WEIGHT_M \
+	((u64)0x7f << IRDMA_CQPSQ_WS_WEIGHT_S)
+
+/* UP to UP mapping */
+#define IRDMA_CQPSQ_UP_WQEVALID_S 63
+#define IRDMA_CQPSQ_UP_WQEVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_UP_WQEVALID_S)
+
+#define IRDMA_CQPSQ_UP_USEVLAN_S 62
+#define IRDMA_CQPSQ_UP_USEVLAN_M \
+	BIT_ULL(IRDMA_CQPSQ_UP_USEVLAN_S)
+
+#define IRDMA_CQPSQ_UP_USEOVERRIDE_S 61
+#define IRDMA_CQPSQ_UP_USEOVERRIDE_M \
+	BIT_ULL(IRDMA_CQPSQ_UP_USEOVERRIDE_S)
+
+#define IRDMA_CQPSQ_UP_OP_S 32
+#define IRDMA_CQPSQ_UP_OP_M \
+	((u64)0x3f << IRDMA_CQPSQ_UP_OP_S)
+
+#define IRDMA_CQPSQ_UP_HMCFCNIDX_S 0
+#define IRDMA_CQPSQ_UP_HMCFCNIDX_M \
+	((u64)0x3f << IRDMA_CQPSQ_UP_HMCFCNIDX_S)
+
+#define IRDMA_CQPSQ_UP_CNPOVERRIDE_S 32
+#define IRDMA_CQPSQ_UP_CNPOVERRIDE_M \
+	((u64)0x3f << IRDMA_CQPSQ_UP_CNPOVERRIDE_S)
+
+/* Query RDMA features*/
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID_S 63
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QUERY_RDMA_FEATURES_WQEVALID_S)
+
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN_S 0
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN_M \
+	((u64)0xffffffff << IRDMA_CQPSQ_QUERY_RDMA_FEATURES_BUF_LEN_S)
+
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_OP_S 32
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_OP_M \
+	((u64)0x3f << IRDMA_CQPSQ_QUERY_RDMA_FEATURES_OP_S)
+
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MODEL_USED_S 32
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MODEL_USED_M \
+	(0xffffULL << IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MODEL_USED_S)
+
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MAJOR_VERSION_S 16
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MAJOR_VERSION_M \
+	(0xffULL << IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MAJOR_VERSION_S)
+
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MINOR_VERSION_S 0
+#define IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MINOR_VERSION_M \
+	(0xffULL << IRDMA_CQPSQ_QUERY_RDMA_FEATURES_HW_MINOR_VERSION_S)
+
+/* CQP Host Context */
+#define IRDMA_CQPHC_EN_DC_TCP_S 25
+#define IRDMA_CQPHC_EN_DC_TCP_M BIT_ULL(IRDMA_CQPHC_EN_DC_TCP_S)
+
+#define IRDMA_CQPHC_SQSIZE_S 8
+#define IRDMA_CQPHC_SQSIZE_M (0xfULL << IRDMA_CQPHC_SQSIZE_S)
+
+#define IRDMA_CQPHC_DISABLE_PFPDUS_S 1
+#define IRDMA_CQPHC_DISABLE_PFPDUS_M BIT_ULL(IRDMA_CQPHC_DISABLE_PFPDUS_S)
+
+#define IRDMA_CQPHC_ROCEV2_RTO_POLICY_S 2
+#define IRDMA_CQPHC_ROCEV2_RTO_POLICY_M BIT_ULL(IRDMA_CQPHC_ROCEV2_RTO_POLICY_S)
+
+#define IRDMA_CQPHC_PROTOCOL_USED_S 3
+#define IRDMA_CQPHC_PROTOCOL_USED_M (0x3ULL << IRDMA_CQPHC_PROTOCOL_USED_S)
+
+#define IRDMA_CQPHC_HW_MINVER_S 0
+#define IRDMA_CQPHC_HW_MINVER_M (0xffffULL << IRDMA_CQPHC_HW_MINVER_S)
+
+#define IRDMA_CQPHC_HW_MAJVER_S 16
+#define IRDMA_CQPHC_HW_MAJVER_M (0xffffULL << IRDMA_CQPHC_HW_MAJVER_S)
+
+#define IRDMA_CQPHC_STRUCTVER_S 24
+#define IRDMA_CQPHC_STRUCTVER_M (0xffULL << IRDMA_CQPHC_STRUCTVER_S)
+
+#define IRDMA_CQPHC_CEQPERVF_S 32
+#define IRDMA_CQPHC_CEQPERVF_M (0xffULL << IRDMA_CQPHC_CEQPERVF_S)
+
+#define IRDMA_CQPHC_ENABLED_VFS_S 32
+#define IRDMA_CQPHC_ENABLED_VFS_M (0x3fULL << IRDMA_CQPHC_ENABLED_VFS_S)
+
+#define IRDMA_CQPHC_HMC_PROFILE_S 0
+#define IRDMA_CQPHC_HMC_PROFILE_M (0x7ULL << IRDMA_CQPHC_HMC_PROFILE_S)
+
+#define IRDMA_CQPHC_SVER_S 24
+#define IRDMA_CQPHC_SVER_M (0xffULL << IRDMA_CQPHC_SVER_S)
+
+#define IRDMA_CQPHC_SQBASE_S 9
+#define IRDMA_CQPHC_SQBASE_M \
+	(0xfffffffffffffeULL << IRDMA_CQPHC_SQBASE_S)
+
+#define IRDMA_CQPHC_QPCTX_S 0
+#define IRDMA_CQPHC_QPCTX_M \
+	(0xffffffffffffffffULL << IRDMA_CQPHC_QPCTX_S)
+
+/* iWARP QP Doorbell shadow area */
+#define IRDMA_QP_DBSA_HW_SQ_TAIL_S 0
+#define IRDMA_QP_DBSA_HW_SQ_TAIL_M \
+	(0x7fffULL << IRDMA_QP_DBSA_HW_SQ_TAIL_S)
+
+/* Completion Queue Doorbell shadow area */
+#define IRDMA_CQ_DBSA_CQEIDX_S 0
+#define IRDMA_CQ_DBSA_CQEIDX_M (0xfffffULL << IRDMA_CQ_DBSA_CQEIDX_S)
+
+#define IRDMA_CQ_DBSA_SW_CQ_SELECT_S 0
+#define IRDMA_CQ_DBSA_SW_CQ_SELECT_M \
+	(0x3fffULL << IRDMA_CQ_DBSA_SW_CQ_SELECT_S)
+
+#define IRDMA_CQ_DBSA_ARM_NEXT_S 14
+#define IRDMA_CQ_DBSA_ARM_NEXT_M BIT_ULL(IRDMA_CQ_DBSA_ARM_NEXT_S)
+
+#define IRDMA_CQ_DBSA_ARM_NEXT_SE_S 15
+#define IRDMA_CQ_DBSA_ARM_NEXT_SE_M BIT_ULL(IRDMA_CQ_DBSA_ARM_NEXT_SE_S)
+
+#define IRDMA_CQ_DBSA_ARM_SEQ_NUM_S 16
+#define IRDMA_CQ_DBSA_ARM_SEQ_NUM_M \
+	(0x3ULL << IRDMA_CQ_DBSA_ARM_SEQ_NUM_S)
+
+/* CQP and iWARP Completion Queue */
+#define IRDMA_CQ_QPCTX_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQ_QPCTX_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_CCQ_OPRETVAL_S 0
+#define IRDMA_CCQ_OPRETVAL_M (0xffffffffULL << IRDMA_CCQ_OPRETVAL_S)
+
+#define IRDMA_CQ_MINERR_S 0
+#define IRDMA_CQ_MINERR_M (0xffffULL << IRDMA_CQ_MINERR_S)
+
+#define IRDMA_CQ_MAJERR_S 16
+#define IRDMA_CQ_MAJERR_M (0xffffULL << IRDMA_CQ_MAJERR_S)
+
+#define IRDMA_CQ_WQEIDX_S 32
+#define IRDMA_CQ_WQEIDX_M (0x7fffULL << IRDMA_CQ_WQEIDX_S)
+
+#define IRDMA_CQ_EXTCQE_S 50
+#define IRDMA_CQ_EXTCQE_M BIT_ULL(IRDMA_CQ_EXTCQE_S)
+
+#define IRDMA_CQ_ERROR_S 55
+#define IRDMA_CQ_ERROR_M BIT_ULL(IRDMA_CQ_ERROR_S)
+
+#define IRDMA_CQ_SQ_S 62
+#define IRDMA_CQ_SQ_M BIT_ULL(IRDMA_CQ_SQ_S)
+
+#define IRDMA_CQ_VALID_S 63
+#define IRDMA_CQ_VALID_M BIT_ULL(IRDMA_CQ_VALID_S)
+
+#define IRDMA_CQ_IMMVALID_S 62
+#define IRDMA_CQ_IMMVALID_M BIT_ULL(IRDMA_CQ_IMMVALID_S)
+
+#define IRDMA_CQ_UDSMACVALID_S 61
+#define IRDMA_CQ_UDSMACVALID_M BIT_ULL(IRDMA_CQ_UDSMACVALID_S)
+
+#define IRDMA_CQ_UDVLANVALID_S 60
+#define IRDMA_CQ_UDVLANVALID_M BIT_ULL(IRDMA_CQ_UDVLANVALID_S)
+
+#define IRDMA_CQ_UDSMAC_S 0
+#define IRDMA_CQ_UDSMAC_M (0xffffffffffffULL << IRDMA_CQ_UDSMAC_S)
+
+#define IRDMA_CQ_UDVLAN_S 48
+#define IRDMA_CQ_UDVLAN_M (0xffffULL << IRDMA_CQ_UDVLAN_S)
+
+#define IRDMA_CQ_IMMDATA_S 0
+#define IRDMA_CQ_IMMDATA_M (0xffffffffffffffffULL << IRDMA_CQ_IMMVALID_S)
+
+#define IRDMA_CQ_IMMDATALOW32_S 0
+#define IRDMA_CQ_IMMDATALOW32_M (0xffffffffULL << IRDMA_CQ_IMMDATALOW32_S)
+
+#define IRDMA_CQ_IMMDATAUP32_S 32
+#define IRDMA_CQ_IMMDATAUP32_M (0xffffffffULL << IRDMA_CQ_IMMDATAUP32_S)
+
+#define IRDMACQ_PAYLDLEN_S 0
+#define IRDMACQ_PAYLDLEN_M (0xffffffffULL << IRDMACQ_PAYLDLEN_S)
+
+#define IRDMACQ_TCPSEQNUMRTT_S 32
+#define IRDMACQ_TCPSEQNUMRTT_M (0xffffffffULL << IRDMACQ_TCPSEQNUMRTT_S)
+
+#define IRDMACQ_INVSTAG_S 0
+#define IRDMACQ_INVSTAG_M (0xffffffffULL << IRDMACQ_INVSTAG_S)
+
+#define IRDMACQ_QPID_S 32
+#define IRDMACQ_QPID_M (0x3ffffULL << IRDMACQ_QPID_S)
+
+#define IRDMACQ_UDSRCQPN_S 0
+#define IRDMACQ_UDSRCQPN_M (0xffffffffULL << IRDMACQ_UDSRCQPN_S)
+
+#define IRDMACQ_PSHDROP_S 51
+#define IRDMACQ_PSHDROP_M BIT_ULL(IRDMACQ_PSHDROP_S)
+
+#define IRDMACQ_STAG_S 53
+#define IRDMACQ_STAG_M BIT_ULL(IRDMACQ_STAG_S)
+
+#define IRDMACQ_IPV4_S 53
+#define IRDMACQ_IPV4_M BIT_ULL(IRDMACQ_IPV4_S)
+
+#define IRDMACQ_SOEVENT_S 54
+#define IRDMACQ_SOEVENT_M BIT_ULL(IRDMACQ_SOEVENT_S)
+
+#define IRDMACQ_OP_S 56
+#define IRDMACQ_OP_M (0x3fULL << IRDMACQ_OP_S)
+
+/* CEQE format */
+#define IRDMA_CEQE_CQCTX_S 0
+#define IRDMA_CEQE_CQCTX_M \
+	(0x7fffffffffffffffULL << IRDMA_CEQE_CQCTX_S)
+
+#define IRDMA_CEQE_VALID_S 63
+#define IRDMA_CEQE_VALID_M BIT_ULL(IRDMA_CEQE_VALID_S)
+
+/* AEQE format */
+#define IRDMA_AEQE_COMPCTX_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_AEQE_COMPCTX_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_AEQE_QPCQID_LOW_S 0
+#define IRDMA_AEQE_QPCQID_LOW_M (0x3ffffULL << IRDMA_AEQE_QPCQID_LOW_S)
+
+#define IRDMA_AEQE_QPCQID_HI_S 46
+#define IRDMA_AEQE_QPCQID_HI_M BIT_ULL(IRDMA_AEQE_QPCQID_HI_S)
+
+#define IRDMA_AEQE_WQDESCIDX_S 18
+#define IRDMA_AEQE_WQDESCIDX_M (0x7fffULL << IRDMA_AEQE_WQDESCIDX_S)
+
+#define IRDMA_AEQE_OVERFLOW_S 33
+#define IRDMA_AEQE_OVERFLOW_M BIT_ULL(IRDMA_AEQE_OVERFLOW_S)
+
+#define IRDMA_AEQE_AECODE_S 34
+#define IRDMA_AEQE_AECODE_M (0xfffULL << IRDMA_AEQE_AECODE_S)
+
+#define IRDMA_AEQE_AESRC_S 50
+#define IRDMA_AEQE_AESRC_M (0xfULL << IRDMA_AEQE_AESRC_S)
+
+#define IRDMA_AEQE_IWSTATE_S 54
+#define IRDMA_AEQE_IWSTATE_M (0x7ULL << IRDMA_AEQE_IWSTATE_S)
+
+#define IRDMA_AEQE_TCPSTATE_S 57
+#define IRDMA_AEQE_TCPSTATE_M (0xfULL << IRDMA_AEQE_TCPSTATE_S)
+
+#define IRDMA_AEQE_Q2DATA_S 61
+#define IRDMA_AEQE_Q2DATA_M (0x3ULL << IRDMA_AEQE_Q2DATA_S)
+
+#define IRDMA_AEQE_VALID_S 63
+#define IRDMA_AEQE_VALID_M BIT_ULL(IRDMA_AEQE_VALID_S)
+
+#define IRDMA_UDA_QPSQ_NEXT_HDR_S 16
+#define IRDMA_UDA_QPSQ_NEXT_HDR_M ((u64)0xff << IRDMA_UDA_QPSQ_NEXT_HDR_S)
+
+#define IRDMA_UDA_QPSQ_OPCODE_S 32
+#define IRDMA_UDA_QPSQ_OPCODE_M ((u64)0x3f << IRDMA_UDA_QPSQ_OPCODE_S)
+
+#define IRDMA_UDA_QPSQ_L4LEN_S 42
+#define IRDMA_UDA_QPSQ_L4LEN_M ((u64)0xf << IRDMA_UDA_QPSQ_L4LEN_S)
+
+#define IRDMA_GEN1_UDA_QPSQ_L4LEN_S 24
+#define IRDMA_GEN1_UDA_QPSQ_L4LEN_M ((u64)0xf << IRDMA_GEN1_UDA_QPSQ_L4LEN_S)
+
+#define IRDMA_UDA_QPSQ_AHIDX_S 0
+#define IRDMA_UDA_QPSQ_AHIDX_M ((u64)0x1ffff << IRDMA_UDA_QPSQ_AHIDX_S)
+
+#define IRDMA_UDA_QPSQ_VALID_S 63
+#define IRDMA_UDA_QPSQ_VALID_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_VALID_S)
+
+#define IRDMA_UDA_QPSQ_SIGCOMPL_S 62
+#define IRDMA_UDA_QPSQ_SIGCOMPL_M BIT_ULL(IRDMA_UDA_QPSQ_SIGCOMPL_S)
+
+#define IRDMA_UDA_QPSQ_MACLEN_S 56
+#define IRDMA_UDA_QPSQ_MACLEN_M \
+	((u64)0x7f << IRDMA_UDA_QPSQ_MACLEN_S)
+
+#define IRDMA_UDA_QPSQ_IPLEN_S 48
+#define IRDMA_UDA_QPSQ_IPLEN_M \
+	((u64)0x7f << IRDMA_UDA_QPSQ_IPLEN_S)
+
+#define IRDMA_UDA_QPSQ_L4T_S 30
+#define IRDMA_UDA_QPSQ_L4T_M \
+	((u64)0x3 << IRDMA_UDA_QPSQ_L4T_S)
+
+#define IRDMA_UDA_QPSQ_IIPT_S 28
+#define IRDMA_UDA_QPSQ_IIPT_M \
+	((u64)0x3 << IRDMA_UDA_QPSQ_IIPT_S)
+
+#define IRDMA_UDA_PAYLOADLEN_S 0
+#define IRDMA_UDA_PAYLOADLEN_M ((u64)0x3fff << IRDMA_UDA_PAYLOADLEN_S)
+
+#define IRDMA_UDA_HDRLEN_S 16
+#define IRDMA_UDA_HDRLEN_M ((u64)0x1ff << IRDMA_UDA_HDRLEN_S)
+
+#define IRDMA_VLAN_TAG_VALID_S 50
+#define IRDMA_VLAN_TAG_VALID_M BIT_ULL(IRDMA_VLAN_TAG_VALID_S)
+
+#define IRDMA_UDA_L3PROTO_S 0
+#define IRDMA_UDA_L3PROTO_M ((u64)0x3 << IRDMA_UDA_L3PROTO_S)
+
+#define IRDMA_UDA_L4PROTO_S 16
+#define IRDMA_UDA_L4PROTO_M ((u64)0x3 << IRDMA_UDA_L4PROTO_S)
+
+#define IRDMA_UDA_QPSQ_DOLOOPBACK_S 44
+#define IRDMA_UDA_QPSQ_DOLOOPBACK_M \
+	BIT_ULL(IRDMA_UDA_QPSQ_DOLOOPBACK_S)
+
+/* CQP SQ WQE common fields */
+#define IRDMA_CQPSQ_BUFSIZE_S 0
+#define IRDMA_CQPSQ_BUFSIZE_M (0xffffffffULL << IRDMA_CQPSQ_BUFSIZE_S)
+
+#define IRDMA_CQPSQ_OPCODE_S 32
+#define IRDMA_CQPSQ_OPCODE_M (0x3fULL << IRDMA_CQPSQ_OPCODE_S)
+
+#define IRDMA_CQPSQ_WQEVALID_S 63
+#define IRDMA_CQPSQ_WQEVALID_M BIT_ULL(IRDMA_CQPSQ_WQEVALID_S)
+
+#define IRDMA_CQPSQ_TPHVAL_S 0
+#define IRDMA_CQPSQ_TPHVAL_M (0xffULL << IRDMA_CQPSQ_TPHVAL_S)
+
+#define IRDMA_CQPSQ_VSIIDX_S 8
+#define IRDMA_CQPSQ_VSIIDX_M (0x3ffULL << IRDMA_CQPSQ_VSIIDX_S)
+
+#define IRDMA_CQPSQ_TPHEN_S 60
+#define IRDMA_CQPSQ_TPHEN_M BIT_ULL(IRDMA_CQPSQ_TPHEN_S)
+
+#define IRDMA_CQPSQ_PBUFADDR_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_PBUFADDR_M IRDMA_CQPHC_QPCTX_M
+
+/* Create/Modify/Destroy QP */
+
+#define IRDMA_CQPSQ_QP_NEWMSS_S 32
+#define IRDMA_CQPSQ_QP_NEWMSS_M (0x3fffULL << IRDMA_CQPSQ_QP_NEWMSS_S)
+
+#define IRDMA_CQPSQ_QP_TERMLEN_S 48
+#define IRDMA_CQPSQ_QP_TERMLEN_M (0xfULL << IRDMA_CQPSQ_QP_TERMLEN_S)
+
+#define IRDMA_CQPSQ_QP_QPCTX_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_QP_QPCTX_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_CQPSQ_QP_QPID_S 0
+#define IRDMA_CQPSQ_QP_QPID_M (0x3FFFFUL)
+
+#define IRDMA_CQPSQ_QP_OP_S 32
+#define IRDMA_CQPSQ_QP_OP_M IRDMACQ_OP_M
+
+#define IRDMA_CQPSQ_QP_ORDVALID_S 42
+#define IRDMA_CQPSQ_QP_ORDVALID_M BIT_ULL(IRDMA_CQPSQ_QP_ORDVALID_S)
+
+#define IRDMA_CQPSQ_QP_TOECTXVALID_S 43
+#define IRDMA_CQPSQ_QP_TOECTXVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_TOECTXVALID_S)
+
+#define IRDMA_CQPSQ_QP_CACHEDVARVALID_S 44
+#define IRDMA_CQPSQ_QP_CACHEDVARVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_CACHEDVARVALID_S)
+
+#define IRDMA_CQPSQ_QP_VQ_S 45
+#define IRDMA_CQPSQ_QP_VQ_M BIT_ULL(IRDMA_CQPSQ_QP_VQ_S)
+
+#define IRDMA_CQPSQ_QP_FORCELOOPBACK_S 46
+#define IRDMA_CQPSQ_QP_FORCELOOPBACK_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_FORCELOOPBACK_S)
+
+#define IRDMA_CQPSQ_QP_CQNUMVALID_S 47
+#define IRDMA_CQPSQ_QP_CQNUMVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_CQNUMVALID_S)
+
+#define IRDMA_CQPSQ_QP_QPTYPE_S 48
+#define IRDMA_CQPSQ_QP_QPTYPE_M (0x7ULL << IRDMA_CQPSQ_QP_QPTYPE_S)
+
+#define IRDMA_CQPSQ_QP_MACVALID_S 51
+#define IRDMA_CQPSQ_QP_MACVALID_M BIT_ULL(IRDMA_CQPSQ_QP_MACVALID_S)
+
+#define IRDMA_CQPSQ_QP_MSSCHANGE_S 52
+#define IRDMA_CQPSQ_QP_MSSCHANGE_M BIT_ULL(IRDMA_CQPSQ_QP_MSSCHANGE_S)
+
+#define IRDMA_CQPSQ_QP_IGNOREMWBOUND_S 54
+#define IRDMA_CQPSQ_QP_IGNOREMWBOUND_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_IGNOREMWBOUND_S)
+
+#define IRDMA_CQPSQ_QP_REMOVEHASHENTRY_S 55
+#define IRDMA_CQPSQ_QP_REMOVEHASHENTRY_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_REMOVEHASHENTRY_S)
+
+#define IRDMA_CQPSQ_QP_TERMACT_S 56
+#define IRDMA_CQPSQ_QP_TERMACT_M (0x3ULL << IRDMA_CQPSQ_QP_TERMACT_S)
+
+#define IRDMA_CQPSQ_QP_RESETCON_S 58
+#define IRDMA_CQPSQ_QP_RESETCON_M BIT_ULL(IRDMA_CQPSQ_QP_RESETCON_S)
+
+#define IRDMA_CQPSQ_QP_ARPTABIDXVALID_S 59
+#define IRDMA_CQPSQ_QP_ARPTABIDXVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_QP_ARPTABIDXVALID_S)
+
+#define IRDMA_CQPSQ_QP_NEXTIWSTATE_S 60
+#define IRDMA_CQPSQ_QP_NEXTIWSTATE_M \
+	(0x7ULL << IRDMA_CQPSQ_QP_NEXTIWSTATE_S)
+
+#define IRDMA_CQPSQ_QP_DBSHADOWADDR_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_QP_DBSHADOWADDR_M IRDMA_CQPHC_QPCTX_M
+
+/* Create/Modify/Destroy CQ */
+#define IRDMA_CQPSQ_CQ_CQSIZE_S 0
+#define IRDMA_CQPSQ_CQ_CQSIZE_M (0x1fffffULL << IRDMA_CQPSQ_CQ_CQSIZE_S)
+
+#define IRDMA_CQPSQ_CQ_CQCTX_S 0
+#define IRDMA_CQPSQ_CQ_CQCTX_M \
+	(0x7fffffffffffffffULL << IRDMA_CQPSQ_CQ_CQCTX_S)
+
+#define IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD_S 0
+#define IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD_M \
+	(0x3ffff << IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD_S)
+
+#define IRDMA_CQPSQ_CQ_OP_S 32
+#define IRDMA_CQPSQ_CQ_OP_M (0x3fULL << IRDMA_CQPSQ_CQ_OP_S)
+
+#define IRDMA_CQPSQ_CQ_CQRESIZE_S 43
+#define IRDMA_CQPSQ_CQ_CQRESIZE_M BIT_ULL(IRDMA_CQPSQ_CQ_CQRESIZE_S)
+
+#define IRDMA_CQPSQ_CQ_LPBLSIZE_S 44
+#define IRDMA_CQPSQ_CQ_LPBLSIZE_M (3ULL << IRDMA_CQPSQ_CQ_LPBLSIZE_S)
+
+#define IRDMA_CQPSQ_CQ_CHKOVERFLOW_S 46
+#define IRDMA_CQPSQ_CQ_CHKOVERFLOW_M \
+	BIT_ULL(IRDMA_CQPSQ_CQ_CHKOVERFLOW_S)
+
+#define IRDMA_CQPSQ_CQ_VIRTMAP_S 47
+#define IRDMA_CQPSQ_CQ_VIRTMAP_M BIT_ULL(IRDMA_CQPSQ_CQ_VIRTMAP_S)
+
+#define IRDMA_CQPSQ_CQ_ENCEQEMASK_S 48
+#define IRDMA_CQPSQ_CQ_ENCEQEMASK_M \
+	BIT_ULL(IRDMA_CQPSQ_CQ_ENCEQEMASK_S)
+
+#define IRDMA_CQPSQ_CQ_CEQIDVALID_S 49
+#define IRDMA_CQPSQ_CQ_CEQIDVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_CQ_CEQIDVALID_S)
+
+#define IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT_S 61
+#define IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT_M \
+	BIT_ULL(IRDMA_CQPSQ_CQ_AVOIDMEMCNFLCT_S)
+
+#define IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX_S 0
+#define IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX_M \
+	(0xfffffffULL << IRDMA_CQPSQ_CQ_FIRSTPMPBLIDX_S)
+
+/* Allocate/Register/Register Shared/Deallocate Stag */
+#define IRDMA_CQPSQ_STAG_VA_FBO_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_STAG_VA_FBO_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_CQPSQ_STAG_STAGLEN_S 0
+#define IRDMA_CQPSQ_STAG_STAGLEN_M \
+	(0x3fffffffffffULL << IRDMA_CQPSQ_STAG_STAGLEN_S)
+
+#define IRDMA_CQPSQ_STAG_KEY_S 0
+#define IRDMA_CQPSQ_STAG_KEY_M (0xffULL << IRDMA_CQPSQ_STAG_KEY_S)
+
+#define IRDMA_CQPSQ_STAG_IDX_S 8
+#define IRDMA_CQPSQ_STAG_IDX_M (0xffffffULL << IRDMA_CQPSQ_STAG_IDX_S)
+
+#define IRDMA_CQPSQ_STAG_PARENTSTAGIDX_S 32
+#define IRDMA_CQPSQ_STAG_PARENTSTAGIDX_M \
+	(0xffffffULL << IRDMA_CQPSQ_STAG_PARENTSTAGIDX_S)
+
+#define IRDMA_CQPSQ_STAG_MR_S 43
+#define IRDMA_CQPSQ_STAG_MR_M BIT_ULL(IRDMA_CQPSQ_STAG_MR_S)
+
+#define IRDMA_CQPSQ_STAG_MWTYPE_S 42
+#define IRDMA_CQPSQ_STAG_MWTYPE_M BIT_ULL(IRDMA_CQPSQ_STAG_MWTYPE_S)
+
+#define IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY_S 58
+#define IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY_M \
+	BIT_ULL(IRDMA_CQPSQ_STAG_MW1_BIND_DONT_VLDT_KEY_S)
+
+#define IRDMA_CQPSQ_STAG_LPBLSIZE_S IRDMA_CQPSQ_CQ_LPBLSIZE_S
+#define IRDMA_CQPSQ_STAG_LPBLSIZE_M IRDMA_CQPSQ_CQ_LPBLSIZE_M
+
+#define IRDMA_CQPSQ_STAG_HPAGESIZE_S 46
+#define IRDMA_CQPSQ_STAG_HPAGESIZE_M \
+	((u64)3 << IRDMA_CQPSQ_STAG_HPAGESIZE_S)
+
+#define IRDMA_CQPSQ_STAG_ARIGHTS_S 48
+#define IRDMA_CQPSQ_STAG_ARIGHTS_M \
+	(0x1fULL << IRDMA_CQPSQ_STAG_ARIGHTS_S)
+
+#define IRDMA_CQPSQ_STAG_REMACCENABLED_S 53
+#define IRDMA_CQPSQ_STAG_REMACCENABLED_M \
+	BIT_ULL(IRDMA_CQPSQ_STAG_REMACCENABLED_S)
+
+#define IRDMA_CQPSQ_STAG_VABASEDTO_S 59
+#define IRDMA_CQPSQ_STAG_VABASEDTO_M \
+	BIT_ULL(IRDMA_CQPSQ_STAG_VABASEDTO_S)
+
+#define IRDMA_CQPSQ_STAG_USEHMCFNIDX_S 60
+#define IRDMA_CQPSQ_STAG_USEHMCFNIDX_M \
+	BIT_ULL(IRDMA_CQPSQ_STAG_USEHMCFNIDX_S)
+
+#define IRDMA_CQPSQ_STAG_USEPFRID_S 61
+#define IRDMA_CQPSQ_STAG_USEPFRID_M \
+	BIT_ULL(IRDMA_CQPSQ_STAG_USEPFRID_S)
+
+#define IRDMA_CQPSQ_STAG_PBA_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_STAG_PBA_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_CQPSQ_STAG_HMCFNIDX_S 0
+#define IRDMA_CQPSQ_STAG_HMCFNIDX_M \
+	(0x3fULL << IRDMA_CQPSQ_STAG_HMCFNIDX_S)
+
+#define IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX_S 0
+#define IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX_M \
+	(0xfffffffULL << IRDMA_CQPSQ_STAG_FIRSTPMPBLIDX_S)
+
+#define IRDMA_CQPSQ_QUERYSTAG_IDX_S IRDMA_CQPSQ_STAG_IDX_S
+#define IRDMA_CQPSQ_QUERYSTAG_IDX_M IRDMA_CQPSQ_STAG_IDX_M
+
+/* Manage Local MAC Table - MLM */
+#define IRDMA_CQPSQ_MLM_TABLEIDX_S 0
+#define IRDMA_CQPSQ_MLM_TABLEIDX_M \
+	(0x3fULL << IRDMA_CQPSQ_MLM_TABLEIDX_S)
+
+#define IRDMA_CQPSQ_MLM_FREEENTRY_S 62
+#define IRDMA_CQPSQ_MLM_FREEENTRY_M \
+	BIT_ULL(IRDMA_CQPSQ_MLM_FREEENTRY_S)
+
+#define IRDMA_CQPSQ_MLM_IGNORE_REF_CNT_S 61
+#define IRDMA_CQPSQ_MLM_IGNORE_REF_CNT_M \
+	BIT_ULL(IRDMA_CQPSQ_MLM_IGNORE_REF_CNT_S)
+
+#define IRDMA_CQPSQ_MLM_MAC0_S 0
+#define IRDMA_CQPSQ_MLM_MAC0_M (0xffULL << IRDMA_CQPSQ_MLM_MAC0_S)
+
+#define IRDMA_CQPSQ_MLM_MAC1_S 8
+#define IRDMA_CQPSQ_MLM_MAC1_M (0xffULL << IRDMA_CQPSQ_MLM_MAC1_S)
+
+#define IRDMA_CQPSQ_MLM_MAC2_S 16
+#define IRDMA_CQPSQ_MLM_MAC2_M (0xffULL << IRDMA_CQPSQ_MLM_MAC2_S)
+
+#define IRDMA_CQPSQ_MLM_MAC3_S 24
+#define IRDMA_CQPSQ_MLM_MAC3_M (0xffULL << IRDMA_CQPSQ_MLM_MAC3_S)
+
+#define IRDMA_CQPSQ_MLM_MAC4_S 32
+#define IRDMA_CQPSQ_MLM_MAC4_M (0xffULL << IRDMA_CQPSQ_MLM_MAC4_S)
+
+#define IRDMA_CQPSQ_MLM_MAC5_S 40
+#define IRDMA_CQPSQ_MLM_MAC5_M (0xffULL << IRDMA_CQPSQ_MLM_MAC5_S)
+
+/* Manage ARP Table  - MAT */
+#define IRDMA_CQPSQ_MAT_REACHMAX_S 0
+#define IRDMA_CQPSQ_MAT_REACHMAX_M \
+	(0xffffffffULL << IRDMA_CQPSQ_MAT_REACHMAX_S)
+
+#define IRDMA_CQPSQ_MAT_MACADDR_S 0
+#define IRDMA_CQPSQ_MAT_MACADDR_M \
+	(0xffffffffffffULL << IRDMA_CQPSQ_MAT_MACADDR_S)
+
+#define IRDMA_CQPSQ_MAT_ARPENTRYIDX_S 0
+#define IRDMA_CQPSQ_MAT_ARPENTRYIDX_M \
+	(0xfffULL << IRDMA_CQPSQ_MAT_ARPENTRYIDX_S)
+
+#define IRDMA_CQPSQ_MAT_ENTRYVALID_S 42
+#define IRDMA_CQPSQ_MAT_ENTRYVALID_M \
+	BIT_ULL(IRDMA_CQPSQ_MAT_ENTRYVALID_S)
+
+#define IRDMA_CQPSQ_MAT_PERMANENT_S 43
+#define IRDMA_CQPSQ_MAT_PERMANENT_M \
+	BIT_ULL(IRDMA_CQPSQ_MAT_PERMANENT_S)
+
+#define IRDMA_CQPSQ_MAT_QUERY_S 44
+#define IRDMA_CQPSQ_MAT_QUERY_M BIT_ULL(IRDMA_CQPSQ_MAT_QUERY_S)
+
+/* Manage VF PBLE Backing Pages - MVPBP*/
+#define IRDMA_CQPSQ_MVPBP_PD_ENTRY_CNT_S 0
+#define IRDMA_CQPSQ_MVPBP_PD_ENTRY_CNT_M \
+	(0x3ffULL << IRDMA_CQPSQ_MVPBP_PD_ENTRY_CNT_S)
+
+#define IRDMA_CQPSQ_MVPBP_FIRST_PD_INX_S 16
+#define IRDMA_CQPSQ_MVPBP_FIRST_PD_INX_M \
+	(0x1ffULL << IRDMA_CQPSQ_MVPBP_FIRST_PD_INX_S)
+
+#define IRDMA_CQPSQ_MVPBP_SD_INX_S 32
+#define IRDMA_CQPSQ_MVPBP_SD_INX_M \
+	(0xfffULL << IRDMA_CQPSQ_MVPBP_SD_INX_S)
+
+#define IRDMA_CQPSQ_MVPBP_INV_PD_ENT_S 62
+#define IRDMA_CQPSQ_MVPBP_INV_PD_ENT_M \
+	BIT_ULL(IRDMA_CQPSQ_MVPBP_INV_PD_ENT_S)
+
+#define IRDMA_CQPSQ_MVPBP_PD_PLPBA_S 3
+#define IRDMA_CQPSQ_MVPBP_PD_PLPBA_M \
+	(0x1fffffffffffffffULL << IRDMA_CQPSQ_MVPBP_PD_PLPBA_S)
+
+/* Manage Push Page - MPP */
+#define IRDMA_INVALID_PUSH_PAGE_INDEX 0xffff
+
+#define IRDMA_CQPSQ_MPP_QS_HANDLE_S 0
+#define IRDMA_CQPSQ_MPP_QS_HANDLE_M \
+	(0x3ffULL << IRDMA_CQPSQ_MPP_QS_HANDLE_S)
+
+#define IRDMA_CQPSQ_MPP_PPIDX_S 0
+#define IRDMA_CQPSQ_MPP_PPIDX_M (0x3ffULL << IRDMA_CQPSQ_MPP_PPIDX_S)
+
+#define IRDMA_CQPSQ_MPP_PPTYPE_S 60
+#define IRDMA_CQPSQ_MPP_PPTYPE_M (0x3ULL << IRDMA_CQPSQ_MPP_PPTYPE_S)
+
+#define IRDMA_CQPSQ_MPP_FREE_PAGE_S 62
+#define IRDMA_CQPSQ_MPP_FREE_PAGE_M BIT_ULL(IRDMA_CQPSQ_MPP_FREE_PAGE_S)
+
+/* Upload Context - UCTX */
+#define IRDMA_CQPSQ_UCTX_QPCTXADDR_S IRDMA_CQPHC_QPCTX_S
+#define IRDMA_CQPSQ_UCTX_QPCTXADDR_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMA_CQPSQ_UCTX_QPID_S 0
+#define IRDMA_CQPSQ_UCTX_QPID_M (0x3ffffULL << IRDMA_CQPSQ_UCTX_QPID_S)
+
+#define IRDMA_CQPSQ_UCTX_QPTYPE_S 48
+#define IRDMA_CQPSQ_UCTX_QPTYPE_M (0xfULL << IRDMA_CQPSQ_UCTX_QPTYPE_S)
+
+#define IRDMA_CQPSQ_UCTX_RAWFORMAT_S 61
+#define IRDMA_CQPSQ_UCTX_RAWFORMAT_M \
+	BIT_ULL(IRDMA_CQPSQ_UCTX_RAWFORMAT_S)
+
+#define IRDMA_CQPSQ_UCTX_FREEZEQP_S 62
+#define IRDMA_CQPSQ_UCTX_FREEZEQP_M \
+	BIT_ULL(IRDMA_CQPSQ_UCTX_FREEZEQP_S)
+
+/* Manage HMC PM Function Table - MHMC */
+#define IRDMA_CQPSQ_MHMC_VFIDX_S 0
+#define IRDMA_CQPSQ_MHMC_VFIDX_M (0xffffULL << IRDMA_CQPSQ_MHMC_VFIDX_S)
+
+#define IRDMA_CQPSQ_MHMC_FREEPMFN_S 62
+#define IRDMA_CQPSQ_MHMC_FREEPMFN_M \
+	BIT_ULL(IRDMA_CQPSQ_MHMC_FREEPMFN_S)
+
+/* Set HMC Resource Profile - SHMCRP */
+#define IRDMA_CQPSQ_SHMCRP_HMC_PROFILE_S 0
+#define IRDMA_CQPSQ_SHMCRP_HMC_PROFILE_M \
+	(0x7ULL << IRDMA_CQPSQ_SHMCRP_HMC_PROFILE_S)
+#define IRDMA_CQPSQ_SHMCRP_VFNUM_S 32
+#define IRDMA_CQPSQ_SHMCRP_VFNUM_M (0x3fULL << IRDMA_CQPSQ_SHMCRP_VFNUM_S)
+
+/* Create/Destroy CEQ */
+#define IRDMA_CQPSQ_CEQ_CEQSIZE_S 0
+#define IRDMA_CQPSQ_CEQ_CEQSIZE_M \
+	(0x1ffffULL << IRDMA_CQPSQ_CEQ_CEQSIZE_S)
+
+#define IRDMA_CQPSQ_CEQ_CEQID_S 0
+#define IRDMA_CQPSQ_CEQ_CEQID_M (0x3ffULL << IRDMA_CQPSQ_CEQ_CEQID_S)
+
+#define IRDMA_CQPSQ_CEQ_LPBLSIZE_S IRDMA_CQPSQ_CQ_LPBLSIZE_S
+#define IRDMA_CQPSQ_CEQ_LPBLSIZE_M IRDMA_CQPSQ_CQ_LPBLSIZE_M
+
+#define IRDMA_CQPSQ_CEQ_VMAP_S 47
+#define IRDMA_CQPSQ_CEQ_VMAP_M BIT_ULL(IRDMA_CQPSQ_CEQ_VMAP_S)
+
+#define IRDMA_CQPSQ_CEQ_ITRNOEXPIRE_S 46
+#define IRDMA_CQPSQ_CEQ_ITRNOEXPIRE_M BIT_ULL(IRDMA_CQPSQ_CEQ_ITRNOEXPIRE_S)
+
+#define IRDMA_CQPSQ_CEQ_FIRSTPMPBLIDX_S 0
+#define IRDMA_CQPSQ_CEQ_FIRSTPMPBLIDX_M \
+	(0xfffffffULL << IRDMA_CQPSQ_CEQ_FIRSTPMPBLIDX_S)
+
+/* Create/Destroy AEQ */
+#define IRDMA_CQPSQ_AEQ_AEQECNT_S 0
+#define IRDMA_CQPSQ_AEQ_AEQECNT_M \
+	(0x7ffffULL << IRDMA_CQPSQ_AEQ_AEQECNT_S)
+
+#define IRDMA_CQPSQ_AEQ_LPBLSIZE_S IRDMA_CQPSQ_CQ_LPBLSIZE_S
+#define IRDMA_CQPSQ_AEQ_LPBLSIZE_M IRDMA_CQPSQ_CQ_LPBLSIZE_M
+
+#define IRDMA_CQPSQ_AEQ_VMAP_S 47
+#define IRDMA_CQPSQ_AEQ_VMAP_M BIT_ULL(IRDMA_CQPSQ_AEQ_VMAP_S)
+
+#define IRDMA_CQPSQ_AEQ_FIRSTPMPBLIDX_S 0
+#define IRDMA_CQPSQ_AEQ_FIRSTPMPBLIDX_M \
+	(0xfffffffULL << IRDMA_CQPSQ_AEQ_FIRSTPMPBLIDX_S)
+
+/* Commit FPM Values - CFPM */
+#define IRDMA_COMMIT_FPM_QPCNT_S 0
+#define IRDMA_COMMIT_FPM_QPCNT_M (0x7ffffULL << IRDMA_COMMIT_FPM_QPCNT_S)
+
+#define IRDMA_COMMIT_FPM_CQCNT_S 0
+#define IRDMA_COMMIT_FPM_CQCNT_M (0xfffffULL << IRDMA_COMMIT_FPM_CQCNT_S)
+
+#define IRDMA_COMMIT_FPM_BASE_S 32
+
+#define IRDMA_CQPSQ_CFPM_HMCFNID_S 0
+#define IRDMA_CQPSQ_CFPM_HMCFNID_M (0x3fULL << IRDMA_CQPSQ_CFPM_HMCFNID_S)
+
+/* Flush WQEs - FWQE */
+#define IRDMA_CQPSQ_FWQE_AECODE_S 0
+#define IRDMA_CQPSQ_FWQE_AECODE_M (0xffffULL << IRDMA_CQPSQ_FWQE_AECODE_S)
+
+#define IRDMA_CQPSQ_FWQE_AESOURCE_S 16
+#define IRDMA_CQPSQ_FWQE_AESOURCE_M \
+	(0xfULL << IRDMA_CQPSQ_FWQE_AESOURCE_S)
+
+#define IRDMA_CQPSQ_FWQE_RQMNERR_S 0
+#define IRDMA_CQPSQ_FWQE_RQMNERR_M \
+	(0xffffULL << IRDMA_CQPSQ_FWQE_RQMNERR_S)
+
+#define IRDMA_CQPSQ_FWQE_RQMJERR_S 16
+#define IRDMA_CQPSQ_FWQE_RQMJERR_M \
+	(0xffffULL << IRDMA_CQPSQ_FWQE_RQMJERR_S)
+
+#define IRDMA_CQPSQ_FWQE_SQMNERR_S 32
+#define IRDMA_CQPSQ_FWQE_SQMNERR_M \
+	(0xffffULL << IRDMA_CQPSQ_FWQE_SQMNERR_S)
+
+#define IRDMA_CQPSQ_FWQE_SQMJERR_S 48
+#define IRDMA_CQPSQ_FWQE_SQMJERR_M \
+	(0xffffULL << IRDMA_CQPSQ_FWQE_SQMJERR_S)
+
+#define IRDMA_CQPSQ_FWQE_QPID_S 0
+#define IRDMA_CQPSQ_FWQE_QPID_M (0x3ffffULL << IRDMA_CQPSQ_FWQE_QPID_S)
+
+#define IRDMA_CQPSQ_FWQE_GENERATE_AE_S 59
+#define IRDMA_CQPSQ_FWQE_GENERATE_AE_M \
+	BIT_ULL(IRDMA_CQPSQ_FWQE_GENERATE_AE_S)
+
+#define IRDMA_CQPSQ_FWQE_USERFLCODE_S 60
+#define IRDMA_CQPSQ_FWQE_USERFLCODE_M \
+	BIT_ULL(IRDMA_CQPSQ_FWQE_USERFLCODE_S)
+
+#define IRDMA_CQPSQ_FWQE_FLUSHSQ_S 61
+#define IRDMA_CQPSQ_FWQE_FLUSHSQ_M BIT_ULL(IRDMA_CQPSQ_FWQE_FLUSHSQ_S)
+
+#define IRDMA_CQPSQ_FWQE_FLUSHRQ_S 62
+#define IRDMA_CQPSQ_FWQE_FLUSHRQ_M BIT_ULL(IRDMA_CQPSQ_FWQE_FLUSHRQ_S)
+
+/* Manage Accelerated Port Table - MAPT */
+#define IRDMA_CQPSQ_MAPT_PORT_S 0
+#define IRDMA_CQPSQ_MAPT_PORT_M (0xffffULL << IRDMA_CQPSQ_MAPT_PORT_S)
+
+#define IRDMA_CQPSQ_MAPT_ADDPORT_S 62
+#define IRDMA_CQPSQ_MAPT_ADDPORT_M BIT_ULL(IRDMA_CQPSQ_MAPT_ADDPORT_S)
+
+/* Update Protocol Engine SDs */
+#define IRDMA_CQPSQ_UPESD_SDCMD_S 0
+#define IRDMA_CQPSQ_UPESD_SDCMD_M (0xffffffffULL << IRDMA_CQPSQ_UPESD_SDCMD_S)
+
+#define IRDMA_CQPSQ_UPESD_SDDATALOW_S 0
+#define IRDMA_CQPSQ_UPESD_SDDATALOW_M \
+	(0xffffffffULL << IRDMA_CQPSQ_UPESD_SDDATALOW_S)
+
+#define IRDMA_CQPSQ_UPESD_SDDATAHI_S 32
+#define IRDMA_CQPSQ_UPESD_SDDATAHI_M \
+	(0xffffffffULL << IRDMA_CQPSQ_UPESD_SDDATAHI_S)
+#define IRDMA_CQPSQ_UPESD_HMCFNID_S 0
+#define IRDMA_CQPSQ_UPESD_HMCFNID_M \
+	(0x3fULL << IRDMA_CQPSQ_UPESD_HMCFNID_S)
+
+#define IRDMA_CQPSQ_UPESD_ENTRY_VALID_S 63
+#define IRDMA_CQPSQ_UPESD_ENTRY_VALID_M \
+	BIT_ULL(IRDMA_CQPSQ_UPESD_ENTRY_VALID_S)
+
+#define IRDMA_CQPSQ_UPESD_ENTRY_COUNT_S 0
+#define IRDMA_CQPSQ_UPESD_ENTRY_COUNT_M \
+	(0xfULL << IRDMA_CQPSQ_UPESD_ENTRY_COUNT_S)
+
+#define IRDMA_CQPSQ_UPESD_SKIP_ENTRY_S 7
+#define IRDMA_CQPSQ_UPESD_SKIP_ENTRY_M \
+	BIT_ULL(IRDMA_CQPSQ_UPESD_SKIP_ENTRY_S)
+
+/* Suspend QP */
+#define IRDMA_CQPSQ_SUSPENDQP_QPID_S 0
+#define IRDMA_CQPSQ_SUSPENDQP_QPID_M (0x3FFFFULL)
+
+/* Resume QP */
+#define IRDMA_CQPSQ_RESUMEQP_QSHANDLE_S 0
+#define IRDMA_CQPSQ_RESUMEQP_QSHANDLE_M \
+	(0xffffffffULL << IRDMA_CQPSQ_RESUMEQP_QSHANDLE_S)
+
+#define IRDMA_CQPSQ_RESUMEQP_QPID_S 0
+#define IRDMA_CQPSQ_RESUMEQP_QPID_M (0x3FFFFUL)
+
+/* IW QP Context */
+#define IRDMAQPC_DDP_VER_S 0
+#define IRDMAQPC_DDP_VER_M (3ULL << IRDMAQPC_DDP_VER_S)
+
+#define IRDMAQPC_IBRDENABLE_S 2
+#define IRDMAQPC_IBRDENABLE_M BIT_ULL(IRDMAQPC_IBRDENABLE_S)
+
+#define IRDMAQPC_IPV4_S 3
+#define IRDMAQPC_IPV4_M BIT_ULL(IRDMAQPC_IPV4_S)
+
+#define IRDMAQPC_NONAGLE_S 4
+#define IRDMAQPC_NONAGLE_M BIT_ULL(IRDMAQPC_NONAGLE_S)
+
+#define IRDMAQPC_INSERTVLANTAG_S 5
+#define IRDMAQPC_INSERTVLANTAG_M BIT_ULL(IRDMAQPC_INSERTVLANTAG_S)
+
+#define IRDMAQPC_ISQP1_S 6
+#define IRDMAQPC_ISQP1_M BIT_ULL(IRDMAQPC_ISQP1_S)
+
+#define IRDMAQPC_TIMESTAMP_S 7
+#define IRDMAQPC_TIMESTAMP_M BIT_ULL(IRDMAQPC_TIMESTAMP_S)
+
+#define IRDMAQPC_RQWQESIZE_S 8
+#define IRDMAQPC_RQWQESIZE_M (3ULL << IRDMAQPC_RQWQESIZE_S)
+
+#define IRDMAQPC_INSERTL2TAG2_S 11
+#define IRDMAQPC_INSERTL2TAG2_M BIT_ULL(IRDMAQPC_INSERTL2TAG2_S)
+
+#define IRDMAQPC_LIMIT_S 12
+#define IRDMAQPC_LIMIT_M (3ULL << IRDMAQPC_LIMIT_S)
+
+#define IRDMAQPC_ECN_EN_S 14
+#define IRDMAQPC_ECN_EN_M BIT_ULL(IRDMAQPC_ECN_EN_S)
+
+#define IRDMAQPC_DROPOOOSEG_S 15
+#define IRDMAQPC_DROPOOOSEG_M BIT_ULL(IRDMAQPC_DROPOOOSEG_S)
+
+#define IRDMAQPC_DUPACK_THRESH_S 16
+#define IRDMAQPC_DUPACK_THRESH_M (7ULL << IRDMAQPC_DUPACK_THRESH_S)
+
+#define IRDMAQPC_ERR_RQ_IDX_VALID_S 19
+#define IRDMAQPC_ERR_RQ_IDX_VALID_M BIT_ULL(IRDMAQPC_ERR_RQ_IDX_VALID_S)
+
+#define IRDMAQPC_DIS_VLAN_CHECKS_S 19
+#define IRDMAQPC_DIS_VLAN_CHECKS_M (7ULL << IRDMAQPC_DIS_VLAN_CHECKS_S)
+
+#define IRDMAQPC_DC_TCP_EN_S 25
+#define IRDMAQPC_DC_TCP_EN_M BIT_ULL(IRDMAQPC_DC_TCP_EN_S)
+
+#define IRDMAQPC_RCVTPHEN_S 28
+#define IRDMAQPC_RCVTPHEN_M BIT_ULL(IRDMAQPC_RCVTPHEN_S)
+
+#define IRDMAQPC_XMITTPHEN_S 29
+#define IRDMAQPC_XMITTPHEN_M BIT_ULL(IRDMAQPC_XMITTPHEN_S)
+
+#define IRDMAQPC_RQTPHEN_S 30
+#define IRDMAQPC_RQTPHEN_M BIT_ULL(IRDMAQPC_RQTPHEN_S)
+
+#define IRDMAQPC_SQTPHEN_S 31
+#define IRDMAQPC_SQTPHEN_M BIT_ULL(IRDMAQPC_SQTPHEN_S)
+
+#define IRDMAQPC_PPIDX_S 32
+#define IRDMAQPC_PPIDX_M (0x3ffULL << IRDMAQPC_PPIDX_S)
+
+#define IRDMAQPC_PMENA_S 47
+#define IRDMAQPC_PMENA_M BIT_ULL(IRDMAQPC_PMENA_S)
+
+#define IRDMAQPC_RDMAP_VER_S 62
+#define IRDMAQPC_RDMAP_VER_M (3ULL << IRDMAQPC_RDMAP_VER_S)
+
+#define IRDMAQPC_ROCE_TVER_S 60
+#define IRDMAQPC_ROCE_TVER_M (0x0fULL << IRDMAQPC_ROCE_TVER_S)
+#define IRDMAQPC_SQADDR_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPC_SQADDR_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPC_RQADDR_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPC_RQADDR_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPC_TTL_S 0
+#define IRDMAQPC_TTL_M (0xffULL << IRDMAQPC_TTL_S)
+
+#define IRDMAQPC_RQSIZE_S 8
+#define IRDMAQPC_RQSIZE_M (0xfULL << IRDMAQPC_RQSIZE_S)
+
+#define IRDMAQPC_SQSIZE_S 12
+#define IRDMAQPC_SQSIZE_M (0xfULL << IRDMAQPC_SQSIZE_S)
+
+#define IRDMAQPC_GEN1_SRCMACADDRIDX_S 16
+#define IRDMAQPC_GEN1_SRCMACADDRIDX_M (0x3fUL << IRDMAQPC_GEN1_SRCMACADDRIDX_S)
+
+#define IRDMAQPC_AVOIDSTRETCHACK_S 23
+#define IRDMAQPC_AVOIDSTRETCHACK_M BIT_ULL(IRDMAQPC_AVOIDSTRETCHACK_S)
+
+#define IRDMAQPC_TOS_S 24
+#define IRDMAQPC_TOS_M (0xffULL << IRDMAQPC_TOS_S)
+
+#define IRDMAQPC_SRCPORTNUM_S 32
+#define IRDMAQPC_SRCPORTNUM_M (0xffffULL << IRDMAQPC_SRCPORTNUM_S)
+
+#define IRDMAQPC_DESTPORTNUM_S 48
+#define IRDMAQPC_DESTPORTNUM_M (0xffffULL << IRDMAQPC_DESTPORTNUM_S)
+
+#define IRDMAQPC_DESTIPADDR0_S 32
+#define IRDMAQPC_DESTIPADDR0_M \
+	(0xffffffffULL << IRDMAQPC_DESTIPADDR0_S)
+
+#define IRDMAQPC_DESTIPADDR1_S 0
+#define IRDMAQPC_DESTIPADDR1_M \
+	(0xffffffffULL << IRDMAQPC_DESTIPADDR1_S)
+
+#define IRDMAQPC_DESTIPADDR2_S 32
+#define IRDMAQPC_DESTIPADDR2_M \
+	(0xffffffffULL << IRDMAQPC_DESTIPADDR2_S)
+
+#define IRDMAQPC_DESTIPADDR3_S 0
+#define IRDMAQPC_DESTIPADDR3_M \
+	(0xffffffffULL << IRDMAQPC_DESTIPADDR3_S)
+
+#define IRDMAQPC_SNDMSS_S 16
+#define IRDMAQPC_SNDMSS_M (0x3fffULL << IRDMAQPC_SNDMSS_S)
+
+#define IRDMAQPC_SYN_RST_HANDLING_S 30
+#define IRDMAQPC_SYN_RST_HANDLING_M (0x3ULL << IRDMAQPC_SYN_RST_HANDLING_S)
+
+#define IRDMAQPC_VLANTAG_S 32
+#define IRDMAQPC_VLANTAG_M (0xffffULL << IRDMAQPC_VLANTAG_S)
+
+#define IRDMAQPC_ARPIDX_S 48
+#define IRDMAQPC_ARPIDX_M (0xffffULL << IRDMAQPC_ARPIDX_S)
+
+#define IRDMAQPC_FLOWLABEL_S 0
+#define IRDMAQPC_FLOWLABEL_M (0xfffffULL << IRDMAQPC_FLOWLABEL_S)
+
+#define IRDMAQPC_WSCALE_S 20
+#define IRDMAQPC_WSCALE_M BIT_ULL(IRDMAQPC_WSCALE_S)
+
+#define IRDMAQPC_KEEPALIVE_S 21
+#define IRDMAQPC_KEEPALIVE_M BIT_ULL(IRDMAQPC_KEEPALIVE_S)
+
+#define IRDMAQPC_IGNORE_TCP_OPT_S 22
+#define IRDMAQPC_IGNORE_TCP_OPT_M BIT_ULL(IRDMAQPC_IGNORE_TCP_OPT_S)
+
+#define IRDMAQPC_IGNORE_TCP_UNS_OPT_S 23
+#define IRDMAQPC_IGNORE_TCP_UNS_OPT_M \
+	BIT_ULL(IRDMAQPC_IGNORE_TCP_UNS_OPT_S)
+
+#define IRDMAQPC_TCPSTATE_S 28
+#define IRDMAQPC_TCPSTATE_M (0xfULL << IRDMAQPC_TCPSTATE_S)
+
+#define IRDMAQPC_RCVSCALE_S 32
+#define IRDMAQPC_RCVSCALE_M (0xfULL << IRDMAQPC_RCVSCALE_S)
+
+#define IRDMAQPC_SNDSCALE_S 40
+#define IRDMAQPC_SNDSCALE_M (0xfULL << IRDMAQPC_SNDSCALE_S)
+
+#define IRDMAQPC_PDIDX_S 48
+#define IRDMAQPC_PDIDX_M (0xffffULL << IRDMAQPC_PDIDX_S)
+
+#define IRDMAQPC_PDIDXHI_S 20
+#define IRDMAQPC_PDIDXHI_M (0x3ULL << IRDMAQPC_PDIDXHI_S)
+
+#define IRDMAQPC_PKEY_S 32
+#define IRDMAQPC_PKEY_M (0xffffULL << IRDMAQPC_PKEY_S)
+
+#define IRDMAQPC_ACKCREDITS_S 20
+#define IRDMAQPC_ACKCREDITS_M (0x1fULL << IRDMAQPC_ACKCREDITS_S)
+
+#define IRDMAQPC_QKEY_S 32
+#define IRDMAQPC_QKEY_M (0xffffffffULL << IRDMAQPC_QKEY_S)
+
+#define IRDMAQPC_DESTQP_S 0
+#define IRDMAQPC_DESTQP_M (0xffffffULL << IRDMAQPC_DESTQP_S)
+
+#define IRDMAQPC_KALIVE_TIMER_MAX_PROBES_S 16
+#define IRDMAQPC_KALIVE_TIMER_MAX_PROBES_M \
+	(0xffULL << IRDMAQPC_KALIVE_TIMER_MAX_PROBES_S)
+
+#define IRDMAQPC_KEEPALIVE_INTERVAL_S 24
+#define IRDMAQPC_KEEPALIVE_INTERVAL_M \
+	(0xffULL << IRDMAQPC_KEEPALIVE_INTERVAL_S)
+
+#define IRDMAQPC_TIMESTAMP_RECENT_S 0
+#define IRDMAQPC_TIMESTAMP_RECENT_M \
+	(0xffffffffULL << IRDMAQPC_TIMESTAMP_RECENT_S)
+
+#define IRDMAQPC_TIMESTAMP_AGE_S 32
+#define IRDMAQPC_TIMESTAMP_AGE_M \
+	(0xffffffffULL << IRDMAQPC_TIMESTAMP_AGE_S)
+
+#define IRDMAQPC_SNDNXT_S 0
+#define IRDMAQPC_SNDNXT_M (0xffffffffULL << IRDMAQPC_SNDNXT_S)
+
+#define IRDMAQPC_ISN_S 32
+#define IRDMAQPC_ISN_M (0x00ffffffULL << IRDMAQPC_ISN_S)
+
+#define IRDMAQPC_PSNNXT_S 0
+#define IRDMAQPC_PSNNXT_M (0x00ffffffULL << IRDMAQPC_PSNNXT_S)
+
+#define IRDMAQPC_LSN_S 32
+#define IRDMAQPC_LSN_M (0x00ffffffULL << IRDMAQPC_LSN_S)
+
+#define IRDMAQPC_SNDWND_S 32
+#define IRDMAQPC_SNDWND_M (0xffffffffULL << IRDMAQPC_SNDWND_S)
+
+#define IRDMAQPC_RCVNXT_S 0
+#define IRDMAQPC_RCVNXT_M (0xffffffffULL << IRDMAQPC_RCVNXT_S)
+
+#define IRDMAQPC_EPSN_S 0
+#define IRDMAQPC_EPSN_M (0x00ffffffULL << IRDMAQPC_EPSN_S)
+
+#define IRDMAQPC_RCVWND_S 32
+#define IRDMAQPC_RCVWND_M (0xffffffffULL << IRDMAQPC_RCVWND_S)
+
+#define IRDMAQPC_SNDMAX_S 0
+#define IRDMAQPC_SNDMAX_M (0xffffffffULL << IRDMAQPC_SNDMAX_S)
+
+#define IRDMAQPC_SNDUNA_S 32
+#define IRDMAQPC_SNDUNA_M (0xffffffffULL << IRDMAQPC_SNDUNA_S)
+
+#define IRDMAQPC_PSNMAX_S 0
+#define IRDMAQPC_PSNMAX_M (0x00ffffffULL << IRDMAQPC_PSNMAX_S)
+#define IRDMAQPC_PSNUNA_S 32
+#define IRDMAQPC_PSNUNA_M (0xffffffULL << IRDMAQPC_PSNUNA_S)
+
+#define IRDMAQPC_SRTT_S 0
+#define IRDMAQPC_SRTT_M (0xffffffffULL << IRDMAQPC_SRTT_S)
+
+#define IRDMAQPC_RTTVAR_S 32
+#define IRDMAQPC_RTTVAR_M (0xffffffffULL << IRDMAQPC_RTTVAR_S)
+
+#define IRDMAQPC_SSTHRESH_S 0
+#define IRDMAQPC_SSTHRESH_M (0xffffffffULL << IRDMAQPC_SSTHRESH_S)
+
+#define IRDMAQPC_CWND_S 32
+#define IRDMAQPC_CWND_M (0xffffffffULL << IRDMAQPC_CWND_S)
+
+#define IRDMAQPC_CWNDROCE_S 32
+#define IRDMAQPC_CWNDROCE_M (0xffffffULL << IRDMAQPC_CWNDROCE_S)
+#define IRDMAQPC_SNDWL1_S 0
+#define IRDMAQPC_SNDWL1_M (0xffffffffULL << IRDMAQPC_SNDWL1_S)
+
+#define IRDMAQPC_SNDWL2_S 32
+#define IRDMAQPC_SNDWL2_M (0xffffffffULL << IRDMAQPC_SNDWL2_S)
+
+#define IRDMAQPC_ERR_RQ_IDX_S 32
+#define IRDMAQPC_ERR_RQ_IDX_M (0x3fffULL << IRDMAQPC_ERR_RQ_IDX_S)
+
+#define IRDMAQPC_MAXSNDWND_S 0
+#define IRDMAQPC_MAXSNDWND_M (0xffffffffULL << IRDMAQPC_MAXSNDWND_S)
+
+#define IRDMAQPC_REXMIT_THRESH_S 48
+#define IRDMAQPC_REXMIT_THRESH_M (0x3fULL << IRDMAQPC_REXMIT_THRESH_S)
+
+#define IRDMAQPC_RNRNAK_THRESH_S 54
+#define IRDMAQPC_RNRNAK_THRESH_M (0x7ULL << IRDMAQPC_RNRNAK_THRESH_S)
+
+#define IRDMAQPC_TXCQNUM_S 0
+#define IRDMAQPC_TXCQNUM_M (0x7ffffULL << IRDMAQPC_TXCQNUM_S)
+
+#define IRDMAQPC_RXCQNUM_S 32
+#define IRDMAQPC_RXCQNUM_M (0x7ffffULL << IRDMAQPC_RXCQNUM_S)
+
+#define IRDMAQPC_STAT_INDEX_S 0
+#define IRDMAQPC_STAT_INDEX_M (0x7fULL << IRDMAQPC_STAT_INDEX_S)
+
+#define IRDMAQPC_Q2ADDR_S 8
+#define IRDMAQPC_Q2ADDR_M (0xffffffffffffffULL << IRDMAQPC_Q2ADDR_S)
+
+#define IRDMAQPC_LASTBYTESENT_S 0
+#define IRDMAQPC_LASTBYTESENT_M (0xffULL << IRDMAQPC_LASTBYTESENT_S)
+
+#define IRDMAQPC_MACADDRESS_S 16
+#define IRDMAQPC_MACADDRESS_M (0xffffffffffffULL << IRDMAQPC_MACADDRESS_S)
+
+#define IRDMAQPC_ORDSIZE_S 0
+#define IRDMAQPC_ORDSIZE_M (0xffULL << IRDMAQPC_ORDSIZE_S)
+
+#define IRDMAQPC_IRDSIZE_S 16
+#define IRDMAQPC_IRDSIZE_M (0x7ULL << IRDMAQPC_IRDSIZE_S)
+
+#define IRDMAQPC_UDPRIVCQENABLE_S 19
+#define IRDMAQPC_UDPRIVCQENABLE_M BIT_ULL(IRDMAQPC_UDPRIVCQENABLE_S)
+
+#define IRDMAQPC_WRRDRSPOK_S 20
+#define IRDMAQPC_WRRDRSPOK_M BIT_ULL(IRDMAQPC_WRRDRSPOK_S)
+
+#define IRDMAQPC_RDOK_S 21
+#define IRDMAQPC_RDOK_M BIT_ULL(IRDMAQPC_RDOK_S)
+
+#define IRDMAQPC_SNDMARKERS_S 22
+#define IRDMAQPC_SNDMARKERS_M BIT_ULL(IRDMAQPC_SNDMARKERS_S)
+
+#define IRDMAQPC_DCQCNENABLE_S 22
+#define IRDMAQPC_DCQCNENABLE_M BIT_ULL(IRDMAQPC_DCQCNENABLE_S)
+
+#define IRDMAQPC_FW_CC_ENABLE_S 28
+#define IRDMAQPC_FW_CC_ENABLE_M BIT_ULL(IRDMAQPC_FW_CC_ENABLE_S)
+
+#define IRDMAQPC_RCVNOICRC_S 31
+#define IRDMAQPC_RCVNOICRC_M BIT_ULL(IRDMAQPC_RCVNOICRC_S)
+
+#define IRDMAQPC_BINDEN_S 23
+#define IRDMAQPC_BINDEN_M BIT_ULL(IRDMAQPC_BINDEN_S)
+
+#define IRDMAQPC_FASTREGEN_S 24
+#define IRDMAQPC_FASTREGEN_M BIT_ULL(IRDMAQPC_FASTREGEN_S)
+
+#define IRDMAQPC_PRIVEN_S 25
+#define IRDMAQPC_PRIVEN_M BIT_ULL(IRDMAQPC_PRIVEN_S)
+
+#define IRDMAQPC_TIMELYENABLE_S 27
+#define IRDMAQPC_TIMELYENABLE_M BIT_ULL(IRDMAQPC_TIMELYENABLE_S)
+
+#define IRDMAQPC_THIGH_S 52
+#define IRDMAQPC_THIGH_M ((u64)0xfff << IRDMAQPC_THIGH_S)
+
+#define IRDMAQPC_TLOW_S 32
+#define IRDMAQPC_TLOW_M ((u64)0xFF << IRDMAQPC_TLOW_S)
+
+#define IRDMAQPC_REMENDPOINTIDX_S 0
+#define IRDMAQPC_REMENDPOINTIDX_M ((u64)0x1FFFF << IRDMAQPC_REMENDPOINTIDX_S)
+
+#define IRDMAQPC_USESTATSINSTANCE_S 26
+#define IRDMAQPC_USESTATSINSTANCE_M BIT_ULL(IRDMAQPC_USESTATSINSTANCE_S)
+
+#define IRDMAQPC_IWARPMODE_S 28
+#define IRDMAQPC_IWARPMODE_M BIT_ULL(IRDMAQPC_IWARPMODE_S)
+
+#define IRDMAQPC_RCVMARKERS_S 29
+#define IRDMAQPC_RCVMARKERS_M BIT_ULL(IRDMAQPC_RCVMARKERS_S)
+
+#define IRDMAQPC_ALIGNHDRS_S 30
+#define IRDMAQPC_ALIGNHDRS_M BIT_ULL(IRDMAQPC_ALIGNHDRS_S)
+
+#define IRDMAQPC_RCVNOMPACRC_S 31
+#define IRDMAQPC_RCVNOMPACRC_M BIT_ULL(IRDMAQPC_RCVNOMPACRC_S)
+
+#define IRDMAQPC_RCVMARKOFFSET_S 32
+#define IRDMAQPC_RCVMARKOFFSET_M (0x1ffULL << IRDMAQPC_RCVMARKOFFSET_S)
+
+#define IRDMAQPC_SNDMARKOFFSET_S 48
+#define IRDMAQPC_SNDMARKOFFSET_M (0x1ffULL << IRDMAQPC_SNDMARKOFFSET_S)
+
+#define IRDMAQPC_QPCOMPCTX_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPC_QPCOMPCTX_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPC_SQTPHVAL_S 0
+#define IRDMAQPC_SQTPHVAL_M (0xffULL << IRDMAQPC_SQTPHVAL_S)
+
+#define IRDMAQPC_RQTPHVAL_S 8
+#define IRDMAQPC_RQTPHVAL_M (0xffULL << IRDMAQPC_RQTPHVAL_S)
+
+#define IRDMAQPC_QSHANDLE_S 16
+#define IRDMAQPC_QSHANDLE_M (0x3ffULL << IRDMAQPC_QSHANDLE_S)
+
+#define IRDMAQPC_EXCEPTION_LAN_QUEUE_S 32
+#define IRDMAQPC_EXCEPTION_LAN_QUEUE_M \
+	(0xfffULL << IRDMAQPC_EXCEPTION_LAN_QUEUE_S)
+
+#define IRDMAQPC_LOCAL_IPADDR3_S 0
+#define IRDMAQPC_LOCAL_IPADDR3_M \
+	(0xffffffffULL << IRDMAQPC_LOCAL_IPADDR3_S)
+
+#define IRDMAQPC_LOCAL_IPADDR2_S 32
+#define IRDMAQPC_LOCAL_IPADDR2_M \
+	(0xffffffffULL << IRDMAQPC_LOCAL_IPADDR2_S)
+
+#define IRDMAQPC_LOCAL_IPADDR1_S 0
+#define IRDMAQPC_LOCAL_IPADDR1_M \
+	(0xffffffffULL << IRDMAQPC_LOCAL_IPADDR1_S)
+
+#define IRDMAQPC_LOCAL_IPADDR0_S 32
+#define IRDMAQPC_LOCAL_IPADDR0_M \
+	(0xffffffffULL << IRDMAQPC_LOCAL_IPADDR0_S)
+
+#define IRDMA_FW_VER_MINOR_S 0
+#define IRDMA_FW_VER_MINOR_M \
+	(0xffffULL << IRDMA_FW_VER_MINOR_S)
+
+#define IRDMA_FW_VER_MAJOR_S 16
+#define IRDMA_FW_VER_MAJOR_M \
+	(0xffffULL << IRDMA_FW_VER_MAJOR_S)
+
+#define IRDMA_FEATURE_INFO_S 0
+#define IRDMA_FEATURE_INFO_M \
+	(0xffffffffffffULL << IRDMA_FEATURE_INFO_S)
+
+#define IRDMA_FEATURE_CNT_S 32
+#define IRDMA_FEATURE_CNT_M \
+	(0xffffULL << IRDMA_FEATURE_CNT_S)
+
+#define IRDMA_FEATURE_TYPE_S 48
+#define IRDMA_FEATURE_TYPE_M \
+	(0xffffULL << IRDMA_FEATURE_TYPE_S)
+
+#define IRDMA_RSVD_S 41
+#define IRDMA_RSVD_M (0x7fffULL << IRDMA_RSVD_S)
+
+/* iwarp QP SQ WQE common fields */
+#define IRDMAQPSQ_OPCODE_S 32
+#define IRDMAQPSQ_OPCODE_M (0x3fULL << IRDMAQPSQ_OPCODE_S)
+
+#define IRDMAQPSQ_COPY_HOST_PBL_S 43
+#define IRDMAQPSQ_COPY_HOST_PBL_M BIT_ULL(IRDMAQPSQ_COPY_HOST_PBL_S)
+
+#define IRDMAQPSQ_ADDFRAGCNT_S 38
+#define IRDMAQPSQ_ADDFRAGCNT_M (0xfULL << IRDMAQPSQ_ADDFRAGCNT_S)
+
+#define IRDMAQPSQ_PUSHWQE_S 56
+#define IRDMAQPSQ_PUSHWQE_M BIT_ULL(IRDMAQPSQ_PUSHWQE_S)
+
+#define IRDMAQPSQ_STREAMMODE_S 58
+#define IRDMAQPSQ_STREAMMODE_M BIT_ULL(IRDMAQPSQ_STREAMMODE_S)
+
+#define IRDMAQPSQ_WAITFORRCVPDU_S 59
+#define IRDMAQPSQ_WAITFORRCVPDU_M BIT_ULL(IRDMAQPSQ_WAITFORRCVPDU_S)
+
+#define IRDMAQPSQ_READFENCE_S 60
+#define IRDMAQPSQ_READFENCE_M BIT_ULL(IRDMAQPSQ_READFENCE_S)
+
+#define IRDMAQPSQ_LOCALFENCE_S 61
+#define IRDMAQPSQ_LOCALFENCE_M BIT_ULL(IRDMAQPSQ_LOCALFENCE_S)
+
+#define IRDMAQPSQ_UDPHEADER_S 61
+#define IRDMAQPSQ_UDPHEADER_M BIT_ULL(IRDMAQPSQ_UDPHEADER_S)
+
+#define IRDMAQPSQ_L4LEN_S 42
+#define IRDMAQPSQ_L4LEN_M ((u64)0xF << IRDMAQPSQ_L4LEN_S)
+
+#define IRDMAQPSQ_SIGCOMPL_S 62
+#define IRDMAQPSQ_SIGCOMPL_M BIT_ULL(IRDMAQPSQ_SIGCOMPL_S)
+
+#define IRDMAQPSQ_VALID_S 63
+#define IRDMAQPSQ_VALID_M BIT_ULL(IRDMAQPSQ_VALID_S)
+
+#define IRDMAQPSQ_FRAG_TO_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPSQ_FRAG_TO_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPSQ_FRAG_VALID_S 63
+#define IRDMAQPSQ_FRAG_VALID_M BIT_ULL(IRDMAQPSQ_FRAG_VALID_S)
+
+#define IRDMAQPSQ_FRAG_LEN_S 32
+#define IRDMAQPSQ_FRAG_LEN_M (0x7fffffffULL << IRDMAQPSQ_FRAG_LEN_S)
+
+#define IRDMAQPSQ_FRAG_STAG_S 0
+#define IRDMAQPSQ_FRAG_STAG_M (0xffffffffULL << IRDMAQPSQ_FRAG_STAG_S)
+
+#define IRDMAQPSQ_GEN1_FRAG_LEN_S 0
+#define IRDMAQPSQ_GEN1_FRAG_LEN_M (0xffffffffULL << IRDMAQPSQ_GEN1_FRAG_LEN_S)
+
+#define IRDMAQPSQ_GEN1_FRAG_STAG_S 32
+#define IRDMAQPSQ_GEN1_FRAG_STAG_M (0xffffffffULL << IRDMAQPSQ_GEN1_FRAG_STAG_S)
+
+#define IRDMAQPSQ_REMSTAGINV_S 0
+#define IRDMAQPSQ_REMSTAGINV_M (0xffffffffULL << IRDMAQPSQ_REMSTAGINV_S)
+
+#define IRDMAQPSQ_DESTQKEY_S 0
+#define IRDMAQPSQ_DESTQKEY_M (0xffffffffULL << IRDMAQPSQ_DESTQKEY_S)
+
+#define IRDMAQPSQ_DESTQPN_S 32
+#define IRDMAQPSQ_DESTQPN_M (0x00ffffffULL << IRDMAQPSQ_DESTQPN_S)
+
+#define IRDMAQPSQ_AHID_S 0
+#define IRDMAQPSQ_AHID_M (0x0001ffffULL << IRDMAQPSQ_AHID_S)
+
+#define IRDMAQPSQ_INLINEDATAFLAG_S 57
+#define IRDMAQPSQ_INLINEDATAFLAG_M BIT_ULL(IRDMAQPSQ_INLINEDATAFLAG_S)
+
+#define IRDMA_INLINE_VALID_S 7
+
+#define IRDMAQPSQ_INLINEDATALEN_S 48
+#define IRDMAQPSQ_INLINEDATALEN_M \
+	(0xffULL << IRDMAQPSQ_INLINEDATALEN_S)
+#define IRDMAQPSQ_IMMDATAFLAG_S 47
+#define IRDMAQPSQ_IMMDATAFLAG_M \
+	BIT_ULL(IRDMAQPSQ_IMMDATAFLAG_S)
+#define IRDMAQPSQ_REPORTRTT_S 46
+#define IRDMAQPSQ_REPORTRTT_M \
+	BIT_ULL(IRDMAQPSQ_REPORTRTT_S)
+
+#define IRDMAQPSQ_IMMDATA_S 0
+#define IRDMAQPSQ_IMMDATA_M \
+	(0xffffffffffffffffULL << IRDMAQPSQ_IMMDATA_S)
+
+/* rdma write */
+#define IRDMAQPSQ_REMSTAG_S 0
+#define IRDMAQPSQ_REMSTAG_M (0xffffffffULL << IRDMAQPSQ_REMSTAG_S)
+
+#define IRDMAQPSQ_REMTO_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPSQ_REMTO_M IRDMA_CQPHC_QPCTX_M
+
+/* memory window */
+#define IRDMAQPSQ_STAGRIGHTS_S 48
+#define IRDMAQPSQ_STAGRIGHTS_M (0x1fULL << IRDMAQPSQ_STAGRIGHTS_S)
+
+#define IRDMAQPSQ_VABASEDTO_S 53
+#define IRDMAQPSQ_VABASEDTO_M BIT_ULL(IRDMAQPSQ_VABASEDTO_S)
+
+#define IRDMAQPSQ_MEMWINDOWTYPE_S 54
+#define IRDMAQPSQ_MEMWINDOWTYPE_M BIT_ULL(IRDMAQPSQ_MEMWINDOWTYPE_S)
+
+#define IRDMAQPSQ_MWLEN_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPSQ_MWLEN_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPSQ_PARENTMRSTAG_S 32
+#define IRDMAQPSQ_PARENTMRSTAG_M \
+	(0xffffffffULL << IRDMAQPSQ_PARENTMRSTAG_S)
+
+#define IRDMAQPSQ_MWSTAG_S 0
+#define IRDMAQPSQ_MWSTAG_M (0xffffffffULL << IRDMAQPSQ_MWSTAG_S)
+
+#define IRDMAQPSQ_BASEVA_TO_FBO_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPSQ_BASEVA_TO_FBO_M IRDMA_CQPHC_QPCTX_M
+
+/* Local Invalidate */
+#define IRDMAQPSQ_LOCSTAG_S 0
+#define IRDMAQPSQ_LOCSTAG_M (0xffffffffULL << IRDMAQPSQ_LOCSTAG_S)
+
+/* Fast Register */
+#define IRDMAQPSQ_STAGKEY_S 0
+#define IRDMAQPSQ_STAGKEY_M (0xffULL << IRDMAQPSQ_STAGKEY_S)
+
+#define IRDMAQPSQ_STAGINDEX_S 8
+#define IRDMAQPSQ_STAGINDEX_M (0xffffffULL << IRDMAQPSQ_STAGINDEX_S)
+
+#define IRDMAQPSQ_COPYHOSTPBLS_S 43
+#define IRDMAQPSQ_COPYHOSTPBLS_M BIT_ULL(IRDMAQPSQ_COPYHOSTPBLS_S)
+
+#define IRDMAQPSQ_LPBLSIZE_S 44
+#define IRDMAQPSQ_LPBLSIZE_M (3ULL << IRDMAQPSQ_LPBLSIZE_S)
+
+#define IRDMAQPSQ_HPAGESIZE_S 46
+#define IRDMAQPSQ_HPAGESIZE_M (3ULL << IRDMAQPSQ_HPAGESIZE_S)
+
+#define IRDMAQPSQ_STAGLEN_S 0
+#define IRDMAQPSQ_STAGLEN_M (0x1ffffffffffULL << IRDMAQPSQ_STAGLEN_S)
+
+#define IRDMAQPSQ_FIRSTPMPBLIDXLO_S 48
+#define IRDMAQPSQ_FIRSTPMPBLIDXLO_M \
+	(0xffffULL << IRDMAQPSQ_FIRSTPMPBLIDXLO_S)
+
+#define IRDMAQPSQ_FIRSTPMPBLIDXHI_S 0
+#define IRDMAQPSQ_FIRSTPMPBLIDXHI_M \
+	(0xfffULL << IRDMAQPSQ_FIRSTPMPBLIDXHI_S)
+
+#define IRDMAQPSQ_PBLADDR_S 12
+#define IRDMAQPSQ_PBLADDR_M (0xfffffffffffffULL << IRDMAQPSQ_PBLADDR_S)
+
+/* iwarp QP RQ WQE common fields */
+#define IRDMAQPRQ_ADDFRAGCNT_S IRDMAQPSQ_ADDFRAGCNT_S
+#define IRDMAQPRQ_ADDFRAGCNT_M IRDMAQPSQ_ADDFRAGCNT_M
+
+#define IRDMAQPRQ_VALID_S IRDMAQPSQ_VALID_S
+#define IRDMAQPRQ_VALID_M IRDMAQPSQ_VALID_M
+
+#define IRDMAQPRQ_COMPLCTX_S IRDMA_CQPHC_QPCTX_S
+#define IRDMAQPRQ_COMPLCTX_M IRDMA_CQPHC_QPCTX_M
+
+#define IRDMAQPRQ_FRAG_LEN_S IRDMAQPSQ_FRAG_LEN_S
+#define IRDMAQPRQ_FRAG_LEN_M IRDMAQPSQ_FRAG_LEN_M
+
+#define IRDMAQPRQ_STAG_S IRDMAQPSQ_FRAG_STAG_S
+#define IRDMAQPRQ_STAG_M IRDMAQPSQ_FRAG_STAG_M
+
+#define IRDMAQPRQ_TO_S IRDMAQPSQ_FRAG_TO_S
+#define IRDMAQPRQ_TO_M IRDMAQPSQ_FRAG_TO_M
+
+/* Query FPM CQP buf */
+#define IRDMA_QUERY_FPM_MAX_QPS_S 0
+#define IRDMA_QUERY_FPM_MAX_QPS_M \
+	(0x7ffffULL << IRDMA_QUERY_FPM_MAX_QPS_S)
+
+#define IRDMA_QUERY_FPM_MAX_CQS_S 0
+#define IRDMA_QUERY_FPM_MAX_CQS_M \
+	(0xfffffULL << IRDMA_QUERY_FPM_MAX_CQS_S)
+
+#define IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX_S 0
+#define IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX_M \
+	(0x3fffULL << IRDMA_QUERY_FPM_FIRST_PE_SD_INDEX_S)
+
+#define IRDMA_QUERY_FPM_MAX_PE_SDS_S 32
+#define IRDMA_QUERY_FPM_MAX_PE_SDS_M \
+	(0x3fffULL << IRDMA_QUERY_FPM_MAX_PE_SDS_S)
+
+#define IRDMA_QUERY_FPM_MAX_CEQS_S 0
+#define IRDMA_QUERY_FPM_MAX_CEQS_M \
+	(0x3ffULL << IRDMA_QUERY_FPM_MAX_CEQS_S)
+
+#define IRDMA_QUERY_FPM_XFBLOCKSIZE_S 32
+#define IRDMA_QUERY_FPM_XFBLOCKSIZE_M \
+	(0xffffffffULL << IRDMA_QUERY_FPM_XFBLOCKSIZE_S)
+
+#define IRDMA_QUERY_FPM_Q1BLOCKSIZE_S 32
+#define IRDMA_QUERY_FPM_Q1BLOCKSIZE_M \
+	(0xffffffffULL << IRDMA_QUERY_FPM_Q1BLOCKSIZE_S)
+
+#define IRDMA_QUERY_FPM_HTMULTIPLIER_S 16
+#define IRDMA_QUERY_FPM_HTMULTIPLIER_M \
+	(0xfULL << IRDMA_QUERY_FPM_HTMULTIPLIER_S)
+
+#define IRDMA_QUERY_FPM_TIMERBUCKET_S 32
+#define IRDMA_QUERY_FPM_TIMERBUCKET_M \
+	(0xffFFULL << IRDMA_QUERY_FPM_TIMERBUCKET_S)
+
+#define IRDMA_QUERY_FPM_RRFBLOCKSIZE_S 32
+#define IRDMA_QUERY_FPM_RRFBLOCKSIZE_M \
+	(0xffffffffULL << IRDMA_QUERY_FPM_RRFBLOCKSIZE_S)
+
+#define IRDMA_QUERY_FPM_RRFFLBLOCKSIZE_S 32
+#define IRDMA_QUERY_FPM_RRFFLBLOCKSIZE_M \
+	(0xffffffffULL << IRDMA_QUERY_FPM_RRFFLBLOCKSIZE_S)
+
+#define IRDMA_QUERY_FPM_OOISCFBLOCKSIZE_S 32
+#define IRDMA_QUERY_FPM_OOISCFBLOCKSIZE_M \
+	(0xffffffffULL << IRDMA_QUERY_FPM_OOISCFBLOCKSIZE_S)
+
+/* Static HMC pages allocated buf */
+#define IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID_S 0
+#define IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID_M \
+	(0x3fULL << IRDMA_SHMC_PAGE_ALLOCATED_HMC_FN_ID_S)
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
+	IRDMA_FAILOVER_START,
+	IRDMA_FAILOVER_COMPLETE,
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
+static inline void set_32bit_val(u32 *wqe_words, u32 byte_index, u32 val)
+{
+	wqe_words[byte_index >> 2] = val;
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
+static inline void get_32bit_val(u32 *wqe_words, u32 byte_index, u32 *val)
+{
+	*val = wqe_words[byte_index >> 2];
+}
+#endif /* IRDMA_DEFS_H */
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
new file mode 100644
index 000000000000..31da13d411b6
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -0,0 +1,190 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#ifndef IRDMA_H
+#define IRDMA_H
+
+#define IRDMA_WQEALLOC_WQE_DESC_INDEX_S		20
+#define IRDMA_WQEALLOC_WQE_DESC_INDEX_M		(0xfff << IRDMA_WQEALLOC_WQE_DESC_INDEX_S)
+
+#define IRDMA_CQPTAIL_WQTAIL_S			0
+#define IRDMA_CQPTAIL_WQTAIL_M			(0x7ff << IRDMA_CQPTAIL_WQTAIL_S)
+
+#define IRDMA_CQPTAIL_CQP_OP_ERR_S		31
+#define IRDMA_CQPTAIL_CQP_OP_ERR_M		(0x1 << IRDMA_CQPTAIL_CQP_OP_ERR_S)
+
+#define IRDMA_CQPERRCODES_CQP_MINOR_CODE_S	0
+#define IRDMA_CQPERRCODES_CQP_MINOR_CODE_M	(0xffff << IRDMA_CQPERRCODES_CQP_MINOR_CODE_S)
+#define IRDMA_CQPERRCODES_CQP_MAJOR_CODE_S	16
+#define IRDMA_CQPERRCODES_CQP_MAJOR_CODE_M	(0xffff << IRDMA_CQPERRCODES_CQP_MAJOR_CODE_S)
+
+#define IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE_S	4
+#define IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE_M	(0x3 << IRDMA_GLPCI_LBARCTRL_PE_DB_SIZE_S)
+
+#define IRDMA_GLINT_DYN_CTL_INTENA_S		0
+#define IRDMA_GLINT_DYN_CTL_INTENA_M		(0x1 << IRDMA_GLINT_DYN_CTL_INTENA_S)
+
+#define IRDMA_GLINT_DYN_CTL_CLEARPBA_S		1
+#define IRDMA_GLINT_DYN_CTL_CLEARPBA_M		(0x1 << IRDMA_GLINT_DYN_CTL_CLEARPBA_S)
+
+#define IRDMA_GLINT_DYN_CTL_ITR_INDX_S		3
+#define IRDMA_GLINT_DYN_CTL_ITR_INDX_M		(0x3 << IRDMA_GLINT_DYN_CTL_ITR_INDX_S)
+
+#define IRDMA_GLINT_CEQCTL_ITR_INDX_S		11
+#define IRDMA_GLINT_CEQCTL_ITR_INDX_M		(0x3 << IRDMA_GLINT_CEQCTL_ITR_INDX_S)
+
+#define IRDMA_GLINT_CEQCTL_CAUSE_ENA_S		30
+#define IRDMA_GLINT_CEQCTL_CAUSE_ENA_M		(0x1 << IRDMA_GLINT_CEQCTL_CAUSE_ENA_S)
+
+#define IRDMA_GLINT_CEQCTL_MSIX_INDX_S		0
+#define IRDMA_GLINT_CEQCTL_MSIX_INDX_M		(0x7ff << IRDMA_GLINT_CEQCTL_MSIX_INDX_S)
+
+#define IRDMA_PFINT_AEQCTL_MSIX_INDX_S		0
+#define IRDMA_PFINT_AEQCTL_MSIX_INDX_M		(0x7ff << IRDMA_PFINT_AEQCTL_MSIX_INDX_S)
+
+#define IRDMA_PFINT_AEQCTL_ITR_INDX_S		11
+#define IRDMA_PFINT_AEQCTL_ITR_INDX_M		(0x3 << IRDMA_PFINT_AEQCTL_ITR_INDX_S)
+
+#define IRDMA_PFINT_AEQCTL_CAUSE_ENA_S		30
+#define IRDMA_PFINT_AEQCTL_CAUSE_ENA_M		(0x1 << IRDMA_PFINT_AEQCTL_CAUSE_ENA_S)
+
+#define IRDMA_PFHMC_PDINV_PMSDIDX_S		0
+#define IRDMA_PFHMC_PDINV_PMSDIDX_M		(0xfff << IRDMA_PFHMC_PDINV_PMSDIDX_S)
+
+#define IRDMA_PFHMC_PDINV_PMSDPARTSEL_S		15
+#define IRDMA_PFHMC_PDINV_PMSDPARTSEL_M		(0x1 << IRDMA_PFHMC_PDINV_PMSDPARTSEL_S)
+
+#define IRDMA_PFHMC_PDINV_PMPDIDX_S		16
+#define IRDMA_PFHMC_PDINV_PMPDIDX_M		(0x1ff << IRDMA_PFHMC_PDINV_PMPDIDX_S)
+
+#define IRDMA_PFHMC_SDDATALOW_PMSDVALID_S	0
+#define IRDMA_PFHMC_SDDATALOW_PMSDVALID_M	(0x1 << IRDMA_PFHMC_SDDATALOW_PMSDVALID_S)
+#define IRDMA_PFHMC_SDDATALOW_PMSDTYPE_S	1
+#define IRDMA_PFHMC_SDDATALOW_PMSDTYPE_M	(0x1 << IRDMA_PFHMC_SDDATALOW_PMSDTYPE_S)
+#define IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT_S	2
+#define IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT_M	(0x3ff << IRDMA_PFHMC_SDDATALOW_PMSDBPCOUNT_S)
+#define IRDMA_PFHMC_SDDATALOW_PMSDDATALOW_S	12
+#define IRDMA_PFHMC_SDDATALOW_PMSDDATALOW_M	(0xfffff << IRDMA_PFHMC_SDDATALOW_PMSDDATALOW_S)
+
+#define IRDMA_PFHMC_SDCMD_PMSDWR_S		31
+#define IRDMA_PFHMC_SDCMD_PMSDWR_M		(0x1 << IRDMA_PFHMC_SDCMD_PMSDWR_S)
+
+#define IRDMA_INVALID_CQ_IDX			0xffffffff
+
+/* I40IW FW VER which supports RTS AE and CQ RESIZE */
+#define IRDMA_FW_VER_0x30010			0x30010
+/* IRDMA FW VER */
+#define IRDMA_FW_VER_0x1000D			0x1000D
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
+	IRDMA_MAX_REGS, /* Must be last entry */
+};
+
+enum irdma_shifts {
+	IRDMA_CCQPSTATUS_CCQP_DONE_S,
+	IRDMA_CCQPSTATUS_CCQP_ERR_S,
+	IRDMA_CQPSQ_STAG_PDID_S,
+	IRDMA_CQPSQ_CQ_CEQID_S,
+	IRDMA_CQPSQ_CQ_CQID_S,
+	IRDMA_MAX_SHIFTS,
+};
+
+enum irdma_masks {
+	IRDMA_CCQPSTATUS_CCQP_DONE_M,
+	IRDMA_CCQPSTATUS_CCQP_ERR_M,
+	IRDMA_CQPSQ_STAG_PDID_M,
+	IRDMA_CQPSQ_CQ_CEQID_M,
+	IRDMA_CQPSQ_CQ_CQID_M,
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
+	IRDMA_GEN_3,
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
+void icrdma_init_hw(struct irdma_sc_dev *dev);
+#endif /* IRDMA_H*/
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
new file mode 100644
index 000000000000..ec5daf16ffb4
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -0,0 +1,1714 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_TYPE_H
+#define IRDMA_TYPE_H
+#include "osdep.h"
+#include "irdma.h"
+#include "user.h"
+#include "hmc.h"
+#include "uda.h"
+#include "ws.h"
+
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
+enum irdma_flush_opcode {
+	FLUSH_INVALID = 0,
+	FLUSH_PROT_ERR,
+	FLUSH_REM_ACCESS_ERR,
+	FLUSH_LOC_QP_OP_ERR,
+	FLUSH_REM_OP_ERR,
+	FLUSH_LOC_LEN_ERR,
+	FLUSH_GENERAL_ERR,
+	FLUSH_FATAL_ERR,
+};
+
+enum irdma_term_eventtypes {
+	TERM_EVENT_QP_FATAL,
+	TERM_EVENT_QP_ACCESS_ERR,
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
+struct irdma_sc_dev;
+struct irdma_vsi_pestat;
+struct irdma_irq_ops;
+struct irdma_cqp_ops;
+struct irdma_ccq_ops;
+struct irdma_ceq_ops;
+struct irdma_aeq_ops;
+struct irdma_mr_ops;
+struct irdma_cqp_misc_ops;
+struct irdma_pd_ops;
+struct irdma_ah_ops;
+struct irdma_priv_qp_ops;
+struct irdma_priv_cq_ops;
+struct irdma_hmc_ops;
+
+struct irdma_cqp_init_info {
+	u64 cqp_compl_ctx;
+	u64 host_ctx_pa;
+	u64 sq_pa;
+	struct irdma_sc_dev *dev;
+	struct irdma_cqp_quanta *sq;
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
+	struct irdma_gather_stats *gather_stats;
+	struct irdma_gather_stats *last_gather_stats;
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
+	struct pci_dev *pdev;
+	struct irdma_hmc_info hmc;
+};
+
+struct irdma_pfpdu {
+	struct list_head rxlist;
+	u32 rcv_nxt;
+	u32 fps;
+	u32 max_fpdu_data;
+	u32 nextseqnum;
+	bool mode:1;
+	bool mpa_crc_err:1;
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
+	u16 qs_handle;
+	u16 push_idx;
+	u16 push_offset;
+	u8 flush_wqes_count;
+	u8 sq_tph_val;
+	u8 rq_tph_val;
+	u8 qp_state;
+	u8 qp_type;
+	u8 hw_sq_size;
+	u8 hw_rq_size;
+	u8 src_mac_addr_idx;
+	bool drop_ieq:1;
+	bool on_qoslist:1;
+	bool ieq_pass_thru:1;
+	bool sq_tph_en:1;
+	bool rq_tph_en:1;
+	bool rcv_tph_en:1;
+	bool xmit_tph_en:1;
+	bool virtual_map:1;
+	bool flush_sq:1;
+	bool flush_rq:1;
+	bool sq_flush:1;
+	enum irdma_flush_opcode flush_code;
+	enum irdma_term_eventtypes eventtype;
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
+	spinlock_t lock; /* protect qos list */
+	u64 lan_qos_handle;
+	u32 l2_sched_node_id;
+	u16 qs_handle;
+	u8 traffic_class;
+	u8 rel_bw;
+	u8 prio_type;
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
+	struct irdma_dev_uk dev_uk;
+	bool fcn_id_array[IRDMA_MAX_STATS_COUNT];
+	struct irdma_dma_mem vf_fpm_query_buf[IRDMA_MAX_PE_ENA_VF_COUNT];
+	u64 fpm_query_buf_pa;
+	u64 fpm_commit_buf_pa;
+	__le64 *fpm_query_buf;
+	__le64 *fpm_commit_buf;
+	void *back_dev;
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
+	u64 hw_masks[IRDMA_MAX_MASKS];
+	u64 hw_shifts[IRDMA_MAX_SHIFTS];
+	u64 hw_stats_regs_32[IRDMA_HW_STAT_INDEX_MAX_32];
+	u64 hw_stats_regs_64[IRDMA_HW_STAT_INDEX_MAX_64];
+	u64 feature_info[IRDMA_MAX_FEATURES];
+	u64 cqp_cmd_stats[IRDMA_OP_SIZE_CQP_STAT_ARRAY];
+	struct irdma_hw_attrs hw_attrs;
+	struct irdma_hmc_info *hmc_info;
+	struct irdma_vfdev *vf_dev[IRDMA_MAX_PE_ENA_VF_COUNT];
+	struct irdma_sc_cqp *cqp;
+	struct irdma_sc_aeq *aeq;
+	struct irdma_sc_ceq *ceq[IRDMA_CEQ_MAX_COUNT];
+	struct irdma_sc_cq *ccq;
+	struct irdma_irq_ops *irq_ops;
+	struct irdma_cqp_ops *cqp_ops;
+	struct irdma_ccq_ops *ccq_ops;
+	struct irdma_ceq_ops *ceq_ops;
+	struct irdma_aeq_ops *aeq_ops;
+	struct irdma_pd_ops *iw_pd_ops;
+	struct irdma_ah_ops *iw_ah_ops;
+	struct irdma_priv_qp_ops *iw_priv_qp_ops;
+	struct irdma_priv_cq_ops *iw_priv_cq_ops;
+	struct irdma_mr_ops *mr_ops;
+	struct irdma_cqp_misc_ops *cqp_misc_ops;
+	struct irdma_hmc_ops *hmc_ops;
+	struct irdma_uda_ops *iw_uda_ops;
+	struct irdma_hmc_fpm_misc hmc_fpm_misc;
+	struct irdma_ws_node *ws_tree_root;
+	struct mutex ws_mutex; /* ws tree mutex */
+	u16 num_vfs;
+	u8 hmc_fn_id;
+	u8 vf_id;
+	bool privileged:1;
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
+	u32 ceq_id;
+	u32 cq_size;
+	u32 shadow_read_threshold;
+	u8 pbl_chunk_size;
+	u32 first_pm_pbl_idx;
+	bool virtual_map:1;
+	bool check_overflow;
+	bool cq_resize:1;
+	bool ceq_valid:1;
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
+	enum irdma_status_code (*vchnl_send)(struct irdma_sc_dev *dev,
+					     u32 vf_id, u8 *msg, u16 len);
+	void (*init_hw)(struct irdma_sc_dev *dev);
+	u8 hmc_fn_id;
+	bool privileged;
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
+	u32 dest_ip_addr0;
+	u32 dest_ip_addr1;
+	u32 dest_ip_addr2;
+	u32 dest_ip_addr3;
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
+	u32 local_ipaddr0;
+	u32 local_ipaddr1;
+	u32 local_ipaddr2;
+	u32 local_ipaddr3;
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
+	u8 ird_size;
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
+
+};
+
+struct irdma_iwarp_offload_info {
+	u16 rcv_mark_offset;
+	u16 snd_mark_offset;
+	u8 ddp_ver;
+	u8 rdmap_ver;
+	u8 iwarp_mode;
+
+	u16 err_rq_idx;
+	u32 pd_id;
+	u16 ord_size;
+	u8 ird_size;
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
+	u32 dest_ip_addr0;
+	u32 dest_ip_addr1;
+	u32 dest_ip_addr2;
+	u32 dest_ip_addr3;
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
+	u32 local_ipaddr0;
+	u32 local_ipaddr1;
+	u32 local_ipaddr2;
+	u32 local_ipaddr3;
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
+	bool add_to_qoslist:1;
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
+	bool in_rdrsp_wr:1;
+	bool out_rdrsp:1;
+	bool aeqe_overflow:1;
+	u8 q2_data_written;
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
+	void *va;
+	enum irdma_addressing_type addr_type;
+	irdma_stag_index new_stag_idx;
+	irdma_stag_index parent_stag_idx;
+	u32 access_rights;
+	u32 pd_id;
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
+	u8 type;
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
+	void (*irdma_cfg_aeq)(struct irdma_sc_dev *dev, u32 idx);
+	void (*irdma_cfg_ceq)(struct irdma_sc_dev *dev, u32 ceq_id, u32 idx);
+	void (*irdma_dis_irq)(struct irdma_sc_dev *dev, u32 idx);
+	void (*irdma_en_irq)(struct irdma_sc_dev *dev, u32 idx);
+};
+
+struct irdma_cqp_ops {
+	void (*check_cqp_progress)(struct irdma_cqp_timeout *cqp_timeout,
+				   struct irdma_sc_dev *dev);
+	enum irdma_status_code (*cqp_create)(struct irdma_sc_cqp *cqp,
+					     u16 *maj_err, u16 *min_err);
+	enum irdma_status_code (*cqp_destroy)(struct irdma_sc_cqp *cqp);
+	__le64 *(*cqp_get_next_send_wqe)(struct irdma_sc_cqp *cqp, u64 scratch);
+	enum irdma_status_code (*cqp_init)(struct irdma_sc_cqp *cqp,
+					   struct irdma_cqp_init_info *info);
+	void (*cqp_post_sq)(struct irdma_sc_cqp *cqp);
+	enum irdma_status_code (*poll_for_cqp_op_done)(struct irdma_sc_cqp *cqp,
+						       u8 opcode,
+						       struct irdma_ccq_cqe_info *cmpl_info);
+};
+
+struct irdma_ccq_ops {
+	void (*ccq_arm)(struct irdma_sc_cq *ccq);
+	enum irdma_status_code (*ccq_create)(struct irdma_sc_cq *ccq,
+					     u64 scratch, bool check_overflow,
+					     bool post_sq);
+	enum irdma_status_code (*ccq_create_done)(struct irdma_sc_cq *ccq);
+	enum irdma_status_code (*ccq_destroy)(struct irdma_sc_cq *ccq, u64 scratch, bool post_sq);
+	enum irdma_status_code (*ccq_get_cqe_info)(struct irdma_sc_cq *ccq,
+						   struct irdma_ccq_cqe_info *info);
+	enum irdma_status_code (*ccq_init)(struct irdma_sc_cq *ccq,
+					   struct irdma_ccq_init_info *info);
+};
+
+struct irdma_ceq_ops {
+	enum irdma_status_code (*ceq_create)(struct irdma_sc_ceq *ceq,
+					     u64 scratch, bool post_sq);
+	enum irdma_status_code (*cceq_create_done)(struct irdma_sc_ceq *ceq);
+	enum irdma_status_code (*cceq_destroy_done)(struct irdma_sc_ceq *ceq);
+	enum irdma_status_code (*cceq_create)(struct irdma_sc_ceq *ceq,
+					      u64 scratch);
+	enum irdma_status_code (*ceq_destroy)(struct irdma_sc_ceq *ceq,
+					      u64 scratch, bool post_sq);
+	enum irdma_status_code (*ceq_init)(struct irdma_sc_ceq *ceq,
+					   struct irdma_ceq_init_info *info);
+	void *(*process_ceq)(struct irdma_sc_dev *dev,
+			     struct irdma_sc_ceq *ceq);
+};
+
+struct irdma_aeq_ops {
+	enum irdma_status_code (*aeq_init)(struct irdma_sc_aeq *aeq,
+					   struct irdma_aeq_init_info *info);
+	enum irdma_status_code (*aeq_create)(struct irdma_sc_aeq *aeq,
+					     u64 scratch, bool post_sq);
+	enum irdma_status_code (*aeq_destroy)(struct irdma_sc_aeq *aeq,
+					      u64 scratch, bool post_sq);
+	enum irdma_status_code (*get_next_aeqe)(struct irdma_sc_aeq *aeq,
+						struct irdma_aeqe_info *info);
+	enum irdma_status_code (*repost_aeq_entries)(struct irdma_sc_dev *dev,
+						     u32 count);
+	enum irdma_status_code (*aeq_create_done)(struct irdma_sc_aeq *aeq);
+	enum irdma_status_code (*aeq_destroy_done)(struct irdma_sc_aeq *aeq);
+};
+
+struct irdma_pd_ops {
+	void (*pd_init)(struct irdma_sc_dev *dev, struct irdma_sc_pd *pd,
+			u32 pd_id, int abi_ver);
+};
+
+struct irdma_priv_qp_ops {
+	enum irdma_status_code (*iw_mr_fast_register)(struct irdma_sc_qp *qp,
+						      struct irdma_fast_reg_stag_info *info,
+						      bool post_sq);
+	enum irdma_status_code (*qp_create)(struct irdma_sc_qp *qp,
+					    struct irdma_create_qp_info *info,
+					    u64 scratch, bool post_sq);
+	enum irdma_status_code (*qp_destroy)(struct irdma_sc_qp *qp,
+					     u64 scratch, bool remove_hash_idx,
+					     bool ignore_mw_bnd, bool post_sq);
+	enum irdma_status_code (*qp_flush_wqes)(struct irdma_sc_qp *qp,
+						struct irdma_qp_flush_info *info,
+						u64 scratch, bool post_sq);
+	enum irdma_status_code (*qp_init)(struct irdma_sc_qp *qp,
+					  struct irdma_qp_init_info *info);
+	enum irdma_status_code (*qp_modify)(struct irdma_sc_qp *qp,
+					    struct irdma_modify_qp_info *info,
+					    u64 scratch, bool post_sq);
+	void (*qp_send_lsmm)(struct irdma_sc_qp *qp, void *lsmm_buf, u32 size,
+			     irdma_stag stag);
+	void (*qp_send_lsmm_nostag)(struct irdma_sc_qp *qp, void *lsmm_buf,
+				    u32 size);
+	void (*qp_send_rtt)(struct irdma_sc_qp *qp, bool read);
+	enum irdma_status_code (*qp_setctx)(struct irdma_sc_qp *qp,
+					    __le64 *qp_ctx,
+					    struct irdma_qp_host_ctx_info *info);
+	enum irdma_status_code (*qp_setctx_roce)(struct irdma_sc_qp *qp, __le64 *qp_ctx,
+						 struct irdma_qp_host_ctx_info *info);
+	enum irdma_status_code (*qp_upload_context)(struct irdma_sc_dev *dev,
+						    struct irdma_upload_context_info *info,
+						    u64 scratch, bool post_sq);
+	enum irdma_status_code (*update_suspend_qp)(struct irdma_sc_cqp *cqp,
+						    struct irdma_sc_qp *qp,
+						    u64 scratch);
+	enum irdma_status_code (*update_resume_qp)(struct irdma_sc_cqp *cqp,
+						   struct irdma_sc_qp *qp,
+						   u64 scratch);
+};
+
+struct irdma_priv_cq_ops {
+	void (*cq_ack)(struct irdma_sc_cq *cq);
+	enum irdma_status_code (*cq_create)(struct irdma_sc_cq *cq, u64 scratch,
+					    bool check_overflow, bool post_sq);
+	enum irdma_status_code (*cq_destroy)(struct irdma_sc_cq *cq,
+					     u64 scratch, bool post_sq);
+	enum irdma_status_code (*cq_init)(struct irdma_sc_cq *cq,
+					  struct irdma_cq_init_info *info);
+	enum irdma_status_code (*cq_modify)(struct irdma_sc_cq *cq,
+					    struct irdma_modify_cq_info *info,
+					    u64 scratch, bool post_sq);
+	void (*cq_resize)(struct irdma_sc_cq *cq, struct irdma_modify_cq_info *info);
+};
+
+struct irdma_mr_ops {
+	enum irdma_status_code (*alloc_stag)(struct irdma_sc_dev *dev,
+					     struct irdma_allocate_stag_info *info,
+					     u64 scratch, bool post_sq);
+	enum irdma_status_code (*dealloc_stag)(struct irdma_sc_dev *dev,
+					       struct irdma_dealloc_stag_info *info,
+					       u64 scratch, bool post_sq);
+	enum irdma_status_code (*mr_reg_non_shared)(struct irdma_sc_dev *dev,
+						    struct irdma_reg_ns_stag_info *info,
+						    u64 scratch, bool post_sq);
+	enum irdma_status_code (*mr_reg_shared)(struct irdma_sc_dev *dev,
+						struct irdma_register_shared_stag *stag,
+						u64 scratch, bool post_sq);
+	enum irdma_status_code (*mw_alloc)(struct irdma_sc_dev *dev,
+					   struct irdma_mw_alloc_info *info,
+					   u64 scratch, bool post_sq);
+	enum irdma_status_code (*query_stag)(struct irdma_sc_dev *dev, u64 scratch,
+					     u32 stag_index, bool post_sq);
+};
+
+struct irdma_cqp_misc_ops {
+	enum irdma_status_code (*add_arp_cache_entry)(struct irdma_sc_cqp *cqp,
+						      struct irdma_add_arp_cache_entry_info *info,
+						      u64 scratch, bool post_sq);
+	enum irdma_status_code (*add_local_mac_entry)(struct irdma_sc_cqp *cqp,
+						      struct irdma_local_mac_entry_info *info,
+						      u64 scratch, bool post_sq);
+	enum irdma_status_code (*alloc_local_mac_entry)(struct irdma_sc_cqp *cqp,
+							u64 scratch,
+							bool post_sq);
+	enum irdma_status_code (*cqp_nop)(struct irdma_sc_cqp *cqp, u64 scratch, bool post_sq);
+	enum irdma_status_code (*del_arp_cache_entry)(struct irdma_sc_cqp *cqp,
+						      u64 scratch,
+						      u16 arp_index,
+						      bool post_sq);
+	enum irdma_status_code (*del_local_mac_entry)(struct irdma_sc_cqp *cqp,
+						      u64 scratch,
+						      u16 entry_idx,
+						      u8 ignore_ref_count,
+						      bool post_sq);
+	enum irdma_status_code (*gather_stats)(struct irdma_sc_cqp *cqp,
+					       struct irdma_stats_gather_info *info,
+					       u64 scratch);
+	enum irdma_status_code (*manage_apbvt_entry)(struct irdma_sc_cqp *cqp,
+						     struct irdma_apbvt_info *info,
+						     u64 scratch, bool post_sq);
+	enum irdma_status_code (*manage_push_page)(struct irdma_sc_cqp *cqp,
+						   struct irdma_cqp_manage_push_page_info *info,
+						   u64 scratch, bool post_sq);
+	enum irdma_status_code (*manage_qhash_table_entry)(struct irdma_sc_cqp *cqp,
+							   struct irdma_qhash_table_info *info,
+							   u64 scratch, bool post_sq);
+	enum irdma_status_code (*manage_stats_instance)(struct irdma_sc_cqp *cqp,
+							struct irdma_stats_inst_info *info,
+							bool alloc, u64 scratch);
+	enum irdma_status_code (*manage_ws_node)(struct irdma_sc_cqp *cqp,
+						 struct irdma_ws_node_info *info,
+						 enum irdma_ws_node_op node_op,
+						 u64 scratch);
+	enum irdma_status_code (*query_arp_cache_entry)(struct irdma_sc_cqp *cqp,
+							u64 scratch, u16 arp_index, bool post_sq);
+	enum irdma_status_code (*query_rdma_features)(struct irdma_sc_cqp *cqp,
+						      struct irdma_dma_mem *buf,
+						      u64 scratch);
+	enum irdma_status_code (*set_up_map)(struct irdma_sc_cqp *cqp,
+					     struct irdma_up_info *info,
+					     u64 scratch);
+};
+
+struct irdma_hmc_ops {
+	enum irdma_status_code (*cfg_iw_fpm)(struct irdma_sc_dev *dev,
+					     u8 hmc_fn_id);
+	enum irdma_status_code (*commit_fpm_val)(struct irdma_sc_cqp *cqp,
+						 u64 scratch, u8 hmc_fn_id,
+						 struct irdma_dma_mem *commit_fpm_mem,
+						 bool post_sq, u8 wait_type);
+	enum irdma_status_code (*commit_fpm_val_done)(struct irdma_sc_cqp *cqp);
+	enum irdma_status_code (*create_hmc_object)(struct irdma_sc_dev *dev,
+						    struct irdma_hmc_create_obj_info *info);
+	enum irdma_status_code (*del_hmc_object)(struct irdma_sc_dev *dev,
+						 struct irdma_hmc_del_obj_info *info,
+						 bool reset);
+	enum irdma_status_code (*init_iw_hmc)(struct irdma_sc_dev *dev, u8 hmc_fn_id);
+	enum irdma_status_code (*manage_hmc_pm_func_table)(struct irdma_sc_cqp *cqp,
+							   struct irdma_hmc_fcn_info *info,
+							   u64 scratch,
+							   bool post_sq);
+	enum irdma_status_code (*manage_hmc_pm_func_table_done)(struct irdma_sc_cqp *cqp);
+	enum irdma_status_code (*parse_fpm_commit_buf)(struct irdma_sc_dev *dev,
+						       __le64 *buf,
+						       struct irdma_hmc_obj_info *info,
+						       u32 *sd);
+	enum irdma_status_code (*parse_fpm_query_buf)(struct irdma_sc_dev *dev,
+						      __le64 *buf,
+						      struct irdma_hmc_info *hmc_info,
+						      struct irdma_hmc_fpm_misc *hmc_fpm_misc);
+	enum irdma_status_code (*pf_init_vfhmc)(struct irdma_sc_dev *dev,
+						u8 vf_hmc_fn_id,
+						u32 *vf_cnt_array);
+	enum irdma_status_code (*query_fpm_val)(struct irdma_sc_cqp *cqp,
+						u64 scratch,
+						u8 hmc_fn_id,
+						struct irdma_dma_mem *query_fpm_mem,
+						bool post_sq, u8 wait_type);
+	enum irdma_status_code (*query_fpm_val_done)(struct irdma_sc_cqp *cqp);
+	enum irdma_status_code (*static_hmc_pages_allocated)(struct irdma_sc_cqp *cqp,
+							     u64 scratch,
+							     u8 hmc_fn_id,
+							     bool post_sq,
+							     bool poll_registers);
+	enum irdma_status_code (*vf_cfg_vffpm)(struct irdma_sc_dev *dev, u32 *vf_cnt_array);
+};
+
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
+struct irdma_virtchnl_work_info {
+	void (*callback_fcn)(void *vf_dev);
+	void *worker_vf_dev;
+};
+#endif /* IRDMA_TYPE_H */
-- 
2.25.2

