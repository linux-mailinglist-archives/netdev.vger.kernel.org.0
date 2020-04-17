Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465831AE3BA
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgDQRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:21:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:30739 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgDQRV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:21:28 -0400
IronPort-SDR: zxE7/LEvamOavczAwOVpFSfDKnUYmhAfVrf7Rnib/In7loT15oB+UeOpeShmlBlcCqXVh+esUb
 QkPxCUym2Ugg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:57 -0700
IronPort-SDR: kI5SgG4r9/s6YtqY8n6Q4O2CH2+H2LbGdhGRCpXO4tiTcmaNr0r/EQ4uRS/IXqhQa9mirO4RWV
 TNrU2M+rTnMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383740"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 11/16] RDMA/irdma: Add user/kernel shared libraries
Date:   Fri, 17 Apr 2020 10:12:46 -0700
Message-Id: <20200417171251.1533371-12-jeffrey.t.kirsher@intel.com>
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

Building the WQE descriptors for different verb
operations are similar in kernel and user-space.
Add these shared libraries.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/uk.c   | 1744 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/user.h |  448 +++++++
 2 files changed, 2192 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/uk.c
 create mode 100644 drivers/infiniband/hw/irdma/user.h

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
new file mode 100644
index 000000000000..18c72be7e73b
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -0,0 +1,1744 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "defs.h"
+#include "user.h"
+#include "irdma.h"
+
+/**
+ * irdma_set_fragment - set fragment in wqe
+ * @wqe: wqe for setting fragment
+ * @offset: offset value
+ * @sge: sge length and stag
+ * @valid: The wqe valid
+ */
+static void irdma_set_fragment(__le64 *wqe, u32 offset, struct irdma_sge *sge,
+			       u8 valid)
+{
+	if (sge) {
+		set_64bit_val(wqe, offset,
+			      LS_64(sge->tag_off, IRDMAQPSQ_FRAG_TO));
+		set_64bit_val(wqe, offset + 8,
+			      LS_64(valid, IRDMAQPSQ_VALID) |
+			      LS_64(sge->len, IRDMAQPSQ_FRAG_LEN) |
+			      LS_64(sge->stag, IRDMAQPSQ_FRAG_STAG));
+	} else {
+		set_64bit_val(wqe, offset, 0);
+		set_64bit_val(wqe, offset + 8,
+			      LS_64(valid, IRDMAQPSQ_VALID));
+	}
+}
+
+/**
+ * irdma_set_fragment_gen_1 - set fragment in wqe
+ * @wqe: wqe for setting fragment
+ * @offset: offset value
+ * @sge: sge length and stag
+ * @valid: wqe valid flag
+ */
+static void irdma_set_fragment_gen_1(__le64 *wqe, u32 offset,
+				     struct irdma_sge *sge, u8 valid)
+{
+	if (sge) {
+		set_64bit_val(wqe, offset,
+			      LS_64(sge->tag_off, IRDMAQPSQ_FRAG_TO));
+		set_64bit_val(wqe, offset + 8,
+			      LS_64(sge->len, IRDMAQPSQ_GEN1_FRAG_LEN) |
+			      LS_64(sge->stag, IRDMAQPSQ_GEN1_FRAG_STAG));
+	} else {
+		set_64bit_val(wqe, offset, 0);
+		set_64bit_val(wqe, offset + 8, 0);
+	}
+}
+
+/**
+ * irdma_nop_1 - insert a NOP wqe
+ * @qp: hw qp ptr
+ */
+static enum irdma_status_code irdma_nop_1(struct irdma_qp_uk *qp)
+{
+	u64 hdr;
+	__le64 *wqe;
+	u32 wqe_idx;
+	bool signaled = false;
+
+	if (!qp->sq_ring.head)
+		return IRDMA_ERR_PARAM;
+
+	wqe_idx = IRDMA_RING_CURRENT_HEAD(qp->sq_ring);
+	wqe = qp->sq_base[wqe_idx].elem;
+
+	qp->sq_wrtrk_array[wqe_idx].quanta = IRDMA_QP_WQE_MIN_QUANTA;
+
+	set_64bit_val(wqe, 0, 0);
+	set_64bit_val(wqe, 8, 0);
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = LS_64(IRDMAQP_OP_NOP, IRDMAQPSQ_OPCODE) |
+	      LS_64(signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	/* make sure WQE is written before valid bit is set */
+	dma_wmb();
+
+	set_64bit_val(wqe, 24, hdr);
+
+	return 0;
+}
+
+/**
+ * irdma_clear_wqes - clear next 128 sq entries
+ * @qp: hw qp ptr
+ * @qp_wqe_idx: wqe_idx
+ */
+void irdma_clr_wqes(struct irdma_qp_uk *qp, u32 qp_wqe_idx)
+{
+	u64 wqe_addr;
+	u32 wqe_idx;
+
+	if (!(qp_wqe_idx & 0x7F)) {
+		wqe_idx = (qp_wqe_idx + 128) % qp->sq_ring.size;
+		wqe_addr = (u64)qp->sq_base->elem + IRDMA_WQE_SIZE_32 * wqe_idx;
+
+		if (wqe_idx)
+			memset((void *)wqe_addr, qp->swqe_polarity ? 0 : 0xFF, 0x1000);
+		else
+			memset((void *)wqe_addr, qp->swqe_polarity ? 0xFF : 0, 0x1000);
+	}
+}
+
+/**
+ * irdma_qp_post_wr - ring doorbell
+ * @qp: hw qp ptr
+ */
+void irdma_qp_post_wr(struct irdma_qp_uk *qp)
+{
+	u64 temp;
+	u32 hw_sq_tail;
+	u32 sw_sq_head;
+
+	/* valid bit is written and loads completed before reading shadow */
+	mb();
+
+	/* read the doorbell shadow area */
+	get_64bit_val(qp->shadow_area, 0, &temp);
+
+	hw_sq_tail = (u32)RS_64(temp, IRDMA_QP_DBSA_HW_SQ_TAIL);
+	sw_sq_head = IRDMA_RING_CURRENT_HEAD(qp->sq_ring);
+	if (sw_sq_head != qp->initial_ring.head) {
+		if (qp->push_mode) {
+			writel(qp->qp_id, qp->wqe_alloc_db);
+			qp->push_mode = false;
+		} else if (sw_sq_head != hw_sq_tail) {
+			if (sw_sq_head > qp->initial_ring.head) {
+				if (hw_sq_tail >= qp->initial_ring.head &&
+				    hw_sq_tail < sw_sq_head)
+					writel(qp->qp_id, qp->wqe_alloc_db);
+			} else {
+				if (hw_sq_tail >= qp->initial_ring.head ||
+				    hw_sq_tail < sw_sq_head)
+					writel(qp->qp_id, qp->wqe_alloc_db);
+			}
+		}
+	}
+
+	qp->initial_ring.head = qp->sq_ring.head;
+}
+
+/**
+ * irdma_qp_ring_push_db -  ring qp doorbell
+ * @qp: hw qp ptr
+ * @wqe_idx: wqe index
+ */
+static void irdma_qp_ring_push_db(struct irdma_qp_uk *qp, u32 wqe_idx)
+{
+	set_32bit_val(qp->push_db, 0,
+		      LS_32(wqe_idx >> 3, IRDMA_WQEALLOC_WQE_DESC_INDEX) | qp->qp_id);
+	qp->initial_ring.head = qp->sq_ring.head;
+	qp->push_mode = true;
+}
+
+void irdma_qp_push_wqe(struct irdma_qp_uk *qp, __le64 *wqe, u16 quanta,
+		       u32 wqe_idx, bool post_sq)
+{
+	__le64 *push;
+
+	if (IRDMA_RING_CURRENT_HEAD(qp->initial_ring) !=
+		    IRDMA_RING_CURRENT_TAIL(qp->sq_ring) &&
+	    !(qp->push_mode)) {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	} else {
+		push = (__le64 *)((uintptr_t)qp->push_wqe +
+				  (wqe_idx & 0x7) * 0x20);
+		memcpy(push, wqe, quanta * IRDMA_QP_WQE_MIN_SIZE);
+		irdma_qp_ring_push_db(qp, wqe_idx);
+	}
+}
+
+/**
+ * irdma_qp_get_next_send_wqe - pad with NOP if needed, return where next WR should go
+ * @qp: hw qp ptr
+ * @wqe_idx: return wqe index
+ * @quanta: size of WR in quanta
+ * @total_size: size of WR in bytes
+ * @info: info on WR
+ */
+__le64 *irdma_qp_get_next_send_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx,
+				   u16 quanta, u32 total_size,
+				   struct irdma_post_sq_info *info)
+{
+	__le64 *wqe;
+	__le64 *wqe_0 = NULL;
+	u16 nop_cnt;
+	u16 i;
+
+	nop_cnt = IRDMA_RING_CURRENT_HEAD(qp->sq_ring) %
+		  qp->uk_attrs->max_hw_sq_chunk;
+	if (nop_cnt)
+		nop_cnt = qp->uk_attrs->max_hw_sq_chunk - nop_cnt;
+
+	if (quanta > nop_cnt) {
+		/* Need to pad with NOP */
+		/* Make sure SQ has room for nop_cnt + quanta */
+		if ((u32)(quanta + nop_cnt) >
+			IRDMA_SQ_RING_FREE_QUANTA(qp->sq_ring))
+			return NULL;
+
+		/* pad with NOP */
+		for (i = 0; i < nop_cnt; i++) {
+			irdma_nop_1(qp);
+			IRDMA_RING_MOVE_HEAD_NOCHECK(qp->sq_ring);
+		}
+		info->push_wqe = false;
+	} else {
+		/* no need to pad with NOP */
+		if (quanta > IRDMA_SQ_RING_FREE_QUANTA(qp->sq_ring))
+			return NULL;
+	}
+
+	*wqe_idx = IRDMA_RING_CURRENT_HEAD(qp->sq_ring);
+	if (!*wqe_idx)
+		qp->swqe_polarity = !qp->swqe_polarity;
+
+	IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(qp->sq_ring, quanta);
+
+	wqe = qp->sq_base[*wqe_idx].elem;
+	if (qp->uk_attrs->hw_rev == IRDMA_GEN_1 && quanta == 1 &&
+	    (IRDMA_RING_CURRENT_HEAD(qp->sq_ring) & 1)) {
+		wqe_0 = qp->sq_base[IRDMA_RING_CURRENT_HEAD(qp->sq_ring)].elem;
+		wqe_0[3] = cpu_to_le64(LS_64(!qp->swqe_polarity, IRDMAQPSQ_VALID));
+	}
+	qp->sq_wrtrk_array[*wqe_idx].wrid = info->wr_id;
+	qp->sq_wrtrk_array[*wqe_idx].wr_len = total_size;
+	qp->sq_wrtrk_array[*wqe_idx].quanta = quanta;
+
+	return wqe;
+}
+
+/**
+ * irdma_qp_get_next_recv_wqe - get next qp's rcv wqe
+ * @qp: hw qp ptr
+ * @wqe_idx: return wqe index
+ */
+__le64 *irdma_qp_get_next_recv_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx)
+{
+	__le64 *wqe;
+	enum irdma_status_code ret_code;
+
+	if (IRDMA_RING_FULL_ERR(qp->rq_ring))
+		return NULL;
+
+	IRDMA_ATOMIC_RING_MOVE_HEAD(qp->rq_ring, *wqe_idx, ret_code);
+	if (ret_code)
+		return NULL;
+
+	if (!*wqe_idx)
+		qp->rwqe_polarity = !qp->rwqe_polarity;
+	/* rq_wqe_size_multiplier is no of 32 byte quanta in in one rq wqe */
+	wqe = qp->rq_base[*wqe_idx * qp->rq_wqe_size_multiplier].elem;
+
+	return wqe;
+}
+
+/**
+ * irdma_rdma_write - rdma write operation
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code irdma_rdma_write(struct irdma_qp_uk *qp,
+					       struct irdma_post_sq_info *info,
+					       bool post_sq)
+{
+	u64 hdr;
+	__le64 *wqe;
+	struct irdma_rdma_write *op_info;
+	u32 i, wqe_idx;
+	u32 total_size = 0, byte_off;
+	enum irdma_status_code ret_code;
+	u32 frag_cnt, addl_frag_cnt;
+	bool read_fence = false;
+	u16 quanta;
+
+	info->push_wqe = qp->push_db ? true : false;
+
+	op_info = &info->op.rdma_write;
+	if (op_info->num_lo_sges > qp->max_sq_frag_cnt)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	for (i = 0; i < op_info->num_lo_sges; i++)
+		total_size += op_info->lo_sg_list[i].len;
+
+	read_fence |= info->read_fence;
+
+	if (info->imm_data_valid)
+		frag_cnt = op_info->num_lo_sges + 1;
+	else
+		frag_cnt = op_info->num_lo_sges;
+	addl_frag_cnt = frag_cnt > 1 ? (frag_cnt - 1) : 0;
+	ret_code = irdma_fragcnt_to_quanta_sq(frag_cnt, &quanta);
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, quanta, total_size,
+					 info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	set_64bit_val(wqe, 16,
+		      LS_64(op_info->rem_addr.tag_off, IRDMAQPSQ_FRAG_TO));
+
+	if (info->imm_data_valid) {
+		set_64bit_val(wqe, 0,
+			      LS_64(info->imm_data, IRDMAQPSQ_IMMDATA));
+		i = 0;
+	} else {
+		qp->wqe_ops.iw_set_fragment(wqe, 0,
+					    op_info->lo_sg_list,
+					    qp->swqe_polarity);
+		i = 1;
+	}
+
+	for (byte_off = 32; i < op_info->num_lo_sges; i++) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off,
+					    &op_info->lo_sg_list[i],
+					    qp->swqe_polarity);
+		byte_off += 16;
+	}
+
+	/* if not an odd number set valid bit in next fragment */
+	if (qp->uk_attrs->hw_rev > IRDMA_GEN_1 && !(frag_cnt & 0x01) &&
+	    frag_cnt) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, NULL,
+					    qp->swqe_polarity);
+		if (qp->uk_attrs->hw_rev == IRDMA_GEN_2)
+			++addl_frag_cnt;
+	}
+
+	hdr = LS_64(op_info->rem_addr.stag, IRDMAQPSQ_REMSTAG) |
+	      LS_64(info->op_type, IRDMAQPSQ_OPCODE) |
+	      LS_64((info->imm_data_valid ? 1 : 0), IRDMAQPSQ_IMMDATAFLAG) |
+	      LS_64((info->report_rtt ? 1 : 0), IRDMAQPSQ_REPORTRTT) |
+	      LS_64(addl_frag_cnt, IRDMAQPSQ_ADDFRAGCNT) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(info->local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, quanta, wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_rdma_read - rdma read command
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @inv_stag: flag for inv_stag
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code irdma_rdma_read(struct irdma_qp_uk *qp,
+					      struct irdma_post_sq_info *info,
+					      bool inv_stag, bool post_sq)
+{
+	struct irdma_rdma_read *op_info;
+	enum irdma_status_code ret_code;
+	u32 i, byte_off, total_size = 0;
+	bool local_fence = false;
+	u32 addl_frag_cnt;
+	__le64 *wqe;
+	u32 wqe_idx;
+	u16 quanta;
+	u64 hdr;
+
+	info->push_wqe = qp->push_db ? true : false;
+
+	op_info = &info->op.rdma_read;
+	if (qp->max_sq_frag_cnt < op_info->num_lo_sges)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	for (i = 0; i < op_info->num_lo_sges; i++)
+		total_size += op_info->lo_sg_list[i].len;
+
+	ret_code = irdma_fragcnt_to_quanta_sq(op_info->num_lo_sges, &quanta);
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, quanta, total_size,
+					 info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	addl_frag_cnt = op_info->num_lo_sges > 1 ?
+			(op_info->num_lo_sges - 1) : 0;
+	local_fence |= info->local_fence;
+
+	qp->wqe_ops.iw_set_fragment(wqe, 0, op_info->lo_sg_list,
+				    qp->swqe_polarity);
+	for (i = 1, byte_off = 32; i < op_info->num_lo_sges; ++i) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off,
+					    &op_info->lo_sg_list[i],
+					    qp->swqe_polarity);
+		byte_off += 16;
+	}
+
+	/* if not an odd number set valid bit in next fragment */
+	if (qp->uk_attrs->hw_rev > IRDMA_GEN_1 &&
+	    !(op_info->num_lo_sges & 0x01) && op_info->num_lo_sges) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, NULL,
+					    qp->swqe_polarity);
+		if (qp->uk_attrs->hw_rev == IRDMA_GEN_2)
+			++addl_frag_cnt;
+	}
+	set_64bit_val(wqe, 16,
+		      LS_64(op_info->rem_addr.tag_off, IRDMAQPSQ_FRAG_TO));
+	hdr = LS_64(op_info->rem_addr.stag, IRDMAQPSQ_REMSTAG) |
+	      LS_64((info->report_rtt ? 1 : 0), IRDMAQPSQ_REPORTRTT) |
+	      LS_64(addl_frag_cnt, IRDMAQPSQ_ADDFRAGCNT) |
+	      LS_64((inv_stag ? IRDMAQP_OP_RDMA_READ_LOC_INV : IRDMAQP_OP_RDMA_READ),
+		    IRDMAQPSQ_OPCODE) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(info->read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, quanta, wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_send - rdma send command
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code irdma_send(struct irdma_qp_uk *qp,
+					 struct irdma_post_sq_info *info,
+					 bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_post_send *op_info;
+	u64 hdr;
+	u32 i, wqe_idx, total_size = 0, byte_off;
+	enum irdma_status_code ret_code;
+	u32 frag_cnt, addl_frag_cnt;
+	bool read_fence = false;
+	u16 quanta;
+
+	info->push_wqe = qp->push_db ? true : false;
+
+	op_info = &info->op.send;
+	if (qp->max_sq_frag_cnt < op_info->num_sges)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	for (i = 0; i < op_info->num_sges; i++)
+		total_size += op_info->sg_list[i].len;
+
+	if (info->imm_data_valid)
+		frag_cnt = op_info->num_sges + 1;
+	else
+		frag_cnt = op_info->num_sges;
+	ret_code = irdma_fragcnt_to_quanta_sq(frag_cnt, &quanta);
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, quanta, total_size,
+					 info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	read_fence |= info->read_fence;
+	addl_frag_cnt = frag_cnt > 1 ? (frag_cnt - 1) : 0;
+	if (info->imm_data_valid) {
+		set_64bit_val(wqe, 0,
+			      LS_64(info->imm_data, IRDMAQPSQ_IMMDATA));
+		i = 0;
+	} else {
+		qp->wqe_ops.iw_set_fragment(wqe, 0, op_info->sg_list,
+					    qp->swqe_polarity);
+		i = 1;
+	}
+
+	for (byte_off = 32; i < op_info->num_sges; i++) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, &op_info->sg_list[i],
+					    qp->swqe_polarity);
+		byte_off += 16;
+	}
+
+	/* if not an odd number set valid bit in next fragment */
+	if (qp->uk_attrs->hw_rev > IRDMA_GEN_1 && !(frag_cnt & 0x01) &&
+	    frag_cnt) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, NULL,
+					    qp->swqe_polarity);
+		if (qp->uk_attrs->hw_rev == IRDMA_GEN_2)
+			++addl_frag_cnt;
+	}
+
+	set_64bit_val(wqe, 16,
+		      LS_64(op_info->qkey, IRDMAQPSQ_DESTQKEY) |
+		      LS_64(op_info->dest_qp, IRDMAQPSQ_DESTQPN));
+	hdr = LS_64(info->stag_to_inv, IRDMAQPSQ_REMSTAG) |
+	      LS_64(op_info->ah_id, IRDMAQPSQ_AHID) |
+	      LS_64((info->imm_data_valid ? 1 : 0), IRDMAQPSQ_IMMDATAFLAG) |
+	      LS_64((info->report_rtt ? 1 : 0), IRDMAQPSQ_REPORTRTT) |
+	      LS_64(info->op_type, IRDMAQPSQ_OPCODE) |
+	      LS_64(addl_frag_cnt, IRDMAQPSQ_ADDFRAGCNT) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(info->local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(info->udp_hdr, IRDMAQPSQ_UDPHEADER) |
+	      LS_64(info->l4len, IRDMAQPSQ_L4LEN) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, quanta, wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_set_mw_bind_wqe_gen_1 - set mw bind wqe
+ * @wqe: wqe for setting fragment
+ * @op_info: info for setting bind wqe values
+ */
+static void irdma_set_mw_bind_wqe_gen_1(__le64 *wqe,
+					struct irdma_bind_window *op_info)
+{
+	set_64bit_val(wqe, 0, (uintptr_t)op_info->va);
+	set_64bit_val(wqe, 8,
+		      LS_64(op_info->mw_stag, IRDMAQPSQ_PARENTMRSTAG) |
+		      LS_64(op_info->mr_stag, IRDMAQPSQ_MWSTAG));
+	set_64bit_val(wqe, 16, op_info->bind_len);
+}
+
+/**
+ * irdma_copy_inline_data_gen_1 - Copy inline data to wqe
+ * @dest: pointer to wqe
+ * @src: pointer to inline data
+ * @len: length of inline data to copy
+ * @polarity: compatibility parameter
+ */
+static void irdma_copy_inline_data_gen_1(u8 *dest, u8 *src, u32 len,
+					 u8 polarity)
+{
+	if (len <= 16) {
+		memcpy(dest, src, len);
+	} else {
+		memcpy(dest, src, 16);
+		src += 16;
+		dest = dest + 32;
+		memcpy(dest, src, len - 16);
+	}
+}
+
+/**
+ * irdma_inline_data_size_to_quanta_gen_1 - based on inline data, quanta
+ * @data_size: data size for inline
+ * @quanta: size of sq wqe returned
+ * @max_size: maximum allowed inline size
+ *
+ * Gets the quanta based on inline and immediate data.
+ */
+static enum irdma_status_code
+irdma_inline_data_size_to_quanta_gen_1(u32 data_size, u16 *quanta, u32 max_size)
+{
+	if (data_size > max_size)
+		return IRDMA_ERR_INVALID_INLINE_DATA_SIZE;
+
+	if (data_size <= 16)
+		*quanta = IRDMA_QP_WQE_MIN_QUANTA;
+	else
+		*quanta = 2;
+
+	return 0;
+}
+
+/**
+ * irdma_set_mw_bind_wqe - set mw bind in wqe
+ * @wqe: wqe for setting mw bind
+ * @op_info: info for setting wqe values
+ */
+static void irdma_set_mw_bind_wqe(__le64 *wqe,
+				  struct irdma_bind_window *op_info)
+{
+	set_64bit_val(wqe, 0, (uintptr_t)op_info->va);
+	set_64bit_val(wqe, 8,
+		      LS_64(op_info->mr_stag, IRDMAQPSQ_PARENTMRSTAG) |
+		      LS_64(op_info->mw_stag, IRDMAQPSQ_MWSTAG));
+	set_64bit_val(wqe, 16, op_info->bind_len);
+}
+
+/**
+ * irdma_copy_inline_data - Copy inline data to wqe
+ * @dest: pointer to wqe
+ * @src: pointer to inline data
+ * @len: length of inline data to copy
+ * @polarity: polarity of wqe valid bit
+ */
+static void irdma_copy_inline_data(u8 *dest, u8 *src, u32 len, u8 polarity)
+{
+	u8 inline_valid = polarity << IRDMA_INLINE_VALID_S;
+	u32 copy_size;
+
+	dest += 8;
+	if (len <= 8) {
+		memcpy(dest, src, len);
+		return;
+	}
+
+	*((u64 *)dest) = *((u64 *)src);
+	len -= 8;
+	src += 8;
+	dest += 24; /* point to additional 32 byte quanta */
+
+	while (len) {
+		copy_size = len < 31 ? len : 31;
+		memcpy(dest, src, copy_size);
+		*(dest + 31) = inline_valid;
+		len -= copy_size;
+		dest += 32;
+		src += copy_size;
+	}
+}
+
+/**
+ * irdma_inline_data_size_to_quanta - based on inline data, quanta
+ * @data_size: data size for inline
+ * @quanta: size of sq wqe returned
+ * @max_size: maximum allowed inline size
+ *
+ * Gets the quanta based on inline and immediate data.
+ */
+static enum irdma_status_code
+irdma_inline_data_size_to_quanta(u32 data_size, u16 *quanta, u32 max_size)
+{
+	if (data_size > max_size)
+		return IRDMA_ERR_INVALID_INLINE_DATA_SIZE;
+
+	if (data_size <= 8)
+		*quanta = IRDMA_QP_WQE_MIN_QUANTA;
+	else if (data_size <= 39)
+		*quanta = 2;
+	else if (data_size <= 70)
+		*quanta = 3;
+	else if (data_size <= 101)
+		*quanta = 4;
+	else if (data_size <= 132)
+		*quanta = 5;
+	else if (data_size <= 163)
+		*quanta = 6;
+	else if (data_size <= 194)
+		*quanta = 7;
+	else
+		*quanta = 8;
+
+	return 0;
+}
+
+/**
+ * irdma_inline_rdma_write - inline rdma write operation
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code
+irdma_inline_rdma_write(struct irdma_qp_uk *qp, struct irdma_post_sq_info *info,
+			bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_inline_rdma_write *op_info;
+	u64 hdr = 0;
+	u32 wqe_idx;
+	enum irdma_status_code ret_code;
+	bool read_fence = false;
+	u16 quanta;
+
+	info->push_wqe = qp->push_db ? true : false;
+	op_info = &info->op.inline_rdma_write;
+	ret_code = qp->wqe_ops.iw_inline_data_size_to_quanta(op_info->len, &quanta,
+							     qp->uk_attrs->max_hw_inline);
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, quanta, op_info->len,
+					 info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	read_fence |= info->read_fence;
+	set_64bit_val(wqe, 16,
+		      LS_64(op_info->rem_addr.tag_off, IRDMAQPSQ_FRAG_TO));
+
+	hdr = LS_64(op_info->rem_addr.stag, IRDMAQPSQ_REMSTAG) |
+	      LS_64(info->op_type, IRDMAQPSQ_OPCODE) |
+	      LS_64(op_info->len, IRDMAQPSQ_INLINEDATALEN) |
+	      LS_64(info->report_rtt ? 1 : 0, IRDMAQPSQ_REPORTRTT) |
+	      LS_64(1, IRDMAQPSQ_INLINEDATAFLAG) |
+	      LS_64(info->imm_data_valid ? 1 : 0, IRDMAQPSQ_IMMDATAFLAG) |
+	      LS_64(info->push_wqe ? 1 : 0, IRDMAQPSQ_PUSHWQE) |
+	      LS_64(read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(info->local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	if (info->imm_data_valid)
+		set_64bit_val(wqe, 0,
+			      LS_64(info->imm_data, IRDMAQPSQ_IMMDATA));
+
+	qp->wqe_ops.iw_copy_inline_data((u8 *)wqe, op_info->data, op_info->len,
+					qp->swqe_polarity);
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, quanta, wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_inline_send - inline send operation
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code irdma_inline_send(struct irdma_qp_uk *qp,
+						struct irdma_post_sq_info *info,
+						bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_post_inline_send *op_info;
+	u64 hdr;
+	u32 wqe_idx;
+	enum irdma_status_code ret_code;
+	bool read_fence = false;
+	u16 quanta;
+
+	info->push_wqe = qp->push_db ? true : false;
+	op_info = &info->op.inline_send;
+
+	ret_code = qp->wqe_ops.iw_inline_data_size_to_quanta(op_info->len,
+							     &quanta,
+							     qp->uk_attrs->max_hw_inline);
+	if (ret_code)
+		return ret_code;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, quanta, op_info->len,
+					 info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	set_64bit_val(wqe, 16,
+		      LS_64(op_info->qkey, IRDMAQPSQ_DESTQKEY) |
+		      LS_64(op_info->dest_qp, IRDMAQPSQ_DESTQPN));
+
+	read_fence |= info->read_fence;
+	hdr = LS_64(info->stag_to_inv, IRDMAQPSQ_REMSTAG) |
+	      LS_64(op_info->ah_id, IRDMAQPSQ_AHID) |
+	      LS_64(info->op_type, IRDMAQPSQ_OPCODE) |
+	      LS_64(op_info->len, IRDMAQPSQ_INLINEDATALEN) |
+	      LS_64((info->imm_data_valid ? 1 : 0), IRDMAQPSQ_IMMDATAFLAG) |
+	      LS_64((info->report_rtt ? 1 : 0), IRDMAQPSQ_REPORTRTT) |
+	      LS_64(1, IRDMAQPSQ_INLINEDATAFLAG) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(info->local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(info->udp_hdr, IRDMAQPSQ_UDPHEADER) |
+	      LS_64(info->l4len, IRDMAQPSQ_L4LEN) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	if (info->imm_data_valid)
+		set_64bit_val(wqe, 0,
+			      LS_64(info->imm_data, IRDMAQPSQ_IMMDATA));
+	qp->wqe_ops.iw_copy_inline_data((u8 *)wqe, op_info->data, op_info->len,
+					qp->swqe_polarity);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, quanta, wqe_idx, post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_stag_local_invalidate - stag invalidate operation
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code
+irdma_stag_local_invalidate(struct irdma_qp_uk *qp,
+			    struct irdma_post_sq_info *info, bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_inv_local_stag *op_info;
+	u64 hdr;
+	u32 wqe_idx;
+	bool local_fence = false;
+	struct irdma_sge sge = {};
+
+	info->push_wqe = qp->push_db ? true : false;
+	op_info = &info->op.inv_local_stag;
+	local_fence = info->local_fence;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, IRDMA_QP_WQE_MIN_QUANTA,
+					 0, info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	sge.stag = op_info->target_stag;
+	qp->wqe_ops.iw_set_fragment(wqe, 0, &sge, 0);
+
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = LS_64(IRDMA_OP_TYPE_INV_STAG, IRDMAQPSQ_OPCODE) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(info->read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, IRDMA_QP_WQE_MIN_QUANTA, wqe_idx,
+				  post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_mw_bind - bind Memory Window
+ * @qp: hw qp ptr
+ * @info: post sq information
+ * @post_sq: flag to post sq
+ */
+static enum irdma_status_code irdma_mw_bind(struct irdma_qp_uk *qp,
+					    struct irdma_post_sq_info *info,
+					    bool post_sq)
+{
+	__le64 *wqe;
+	struct irdma_bind_window *op_info;
+	u64 hdr;
+	u32 wqe_idx;
+	bool local_fence = false;
+
+	info->push_wqe = qp->push_db ? true : false;
+	op_info = &info->op.bind_window;
+	local_fence |= info->local_fence;
+
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, IRDMA_QP_WQE_MIN_QUANTA,
+					 0, info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	qp->wqe_ops.iw_set_mw_bind_wqe(wqe, op_info);
+
+	hdr = LS_64(IRDMA_OP_TYPE_BIND_MW, IRDMAQPSQ_OPCODE) |
+	      LS_64(((op_info->ena_reads << 2) | (op_info->ena_writes << 3)),
+		    IRDMAQPSQ_STAGRIGHTS) |
+	      LS_64((op_info->addressing_type == IRDMA_ADDR_TYPE_VA_BASED ?  1 : 0),
+		    IRDMAQPSQ_VABASEDTO) |
+	      LS_64((op_info->mem_window_type_1 ? 1 : 0),
+		    IRDMAQPSQ_MEMWINDOWTYPE) |
+	      LS_64((info->push_wqe ? 1 : 0), IRDMAQPSQ_PUSHWQE) |
+	      LS_64(info->read_fence, IRDMAQPSQ_READFENCE) |
+	      LS_64(local_fence, IRDMAQPSQ_LOCALFENCE) |
+	      LS_64(info->signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	if (info->push_wqe) {
+		irdma_qp_push_wqe(qp, wqe, IRDMA_QP_WQE_MIN_QUANTA, wqe_idx,
+				  post_sq);
+	} else {
+		if (post_sq)
+			irdma_qp_post_wr(qp);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_post_receive - post receive wqe
+ * @qp: hw qp ptr
+ * @info: post rq information
+ */
+static enum irdma_status_code
+irdma_post_receive(struct irdma_qp_uk *qp, struct irdma_post_rq_info *info)
+{
+	u32 total_size = 0, wqe_idx, i, byte_off;
+	u32 addl_frag_cnt;
+	__le64 *wqe;
+	u64 hdr;
+
+	if (qp->max_rq_frag_cnt < info->num_sges)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	for (i = 0; i < info->num_sges; i++)
+		total_size += info->sg_list[i].len;
+
+	wqe = irdma_qp_get_next_recv_wqe(qp, &wqe_idx);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	qp->rq_wrid_array[wqe_idx] = info->wr_id;
+	addl_frag_cnt = info->num_sges > 1 ? (info->num_sges - 1) : 0;
+	qp->wqe_ops.iw_set_fragment(wqe, 0, info->sg_list,
+				    qp->rwqe_polarity);
+
+	for (i = 1, byte_off = 32; i < info->num_sges; i++) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, &info->sg_list[i],
+					    qp->rwqe_polarity);
+		byte_off += 16;
+	}
+
+	/* if not an odd number set valid bit in next fragment */
+	if (qp->uk_attrs->hw_rev > IRDMA_GEN_1 && !(info->num_sges & 0x01) &&
+	    info->num_sges) {
+		qp->wqe_ops.iw_set_fragment(wqe, byte_off, NULL,
+					    qp->rwqe_polarity);
+		if (qp->uk_attrs->hw_rev == IRDMA_GEN_2)
+			++addl_frag_cnt;
+	}
+
+	set_64bit_val(wqe, 16, 0);
+	hdr = LS_64(addl_frag_cnt, IRDMAQPSQ_ADDFRAGCNT) |
+	      LS_64(qp->rwqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	return 0;
+}
+
+/**
+ * irdma_cq_resize - reset the cq buffer info
+ * @cq: cq to resize
+ * @cq_base: new cq buffer addr
+ * @cq_size: number of cqes
+ */
+static void irdma_cq_resize(struct irdma_cq_uk *cq, void *cq_base, int cq_size)
+{
+	cq->cq_base = cq_base;
+	cq->cq_size = cq_size;
+	IRDMA_RING_INIT(cq->cq_ring, cq->cq_size);
+	cq->polarity = 1;
+}
+
+/**
+ * irdma_cq_set_resized_cnt - record the count of the resized buffers
+ * @cq: cq to resize
+ * @cq_cnt: the count of the resized cq buffers
+ */
+static void irdma_cq_set_resized_cnt(struct irdma_cq_uk *cq, u16 cq_cnt)
+{
+	u64 temp_val;
+	u16 sw_cq_sel;
+	u8 arm_next_se;
+	u8 arm_next;
+	u8 arm_seq_num;
+
+	get_64bit_val(cq->shadow_area, 32, &temp_val);
+
+	sw_cq_sel = (u16)RS_64(temp_val, IRDMA_CQ_DBSA_SW_CQ_SELECT);
+	sw_cq_sel += cq_cnt;
+
+	arm_seq_num = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_SEQ_NUM);
+	arm_next_se = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_NEXT_SE);
+	arm_next = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_NEXT);
+
+	temp_val = LS_64(arm_seq_num, IRDMA_CQ_DBSA_ARM_SEQ_NUM) |
+		   LS_64(sw_cq_sel, IRDMA_CQ_DBSA_SW_CQ_SELECT) |
+		   LS_64(arm_next_se, IRDMA_CQ_DBSA_ARM_NEXT_SE) |
+		   LS_64(arm_next, IRDMA_CQ_DBSA_ARM_NEXT);
+
+	set_64bit_val(cq->shadow_area, 32, temp_val);
+}
+
+/**
+ * irdma_cq_request_notification - cq notification request (door bell)
+ * @cq: hw cq
+ * @cq_notify: notification type
+ */
+static void irdma_cq_request_notification(struct irdma_cq_uk *cq,
+					  enum irdma_cmpl_notify cq_notify)
+{
+	u64 temp_val;
+	u16 sw_cq_sel;
+	u8 arm_next_se = 0;
+	u8 arm_next = 0;
+	u8 arm_seq_num;
+
+	get_64bit_val(cq->shadow_area, 32, &temp_val);
+	arm_seq_num = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_SEQ_NUM);
+	arm_seq_num++;
+	sw_cq_sel = (u16)RS_64(temp_val, IRDMA_CQ_DBSA_SW_CQ_SELECT);
+	arm_next_se = (u8)RS_64(temp_val, IRDMA_CQ_DBSA_ARM_NEXT_SE);
+	arm_next_se |= 1;
+	if (cq_notify == IRDMA_CQ_COMPL_EVENT)
+		arm_next = 1;
+	temp_val = LS_64(arm_seq_num, IRDMA_CQ_DBSA_ARM_SEQ_NUM) |
+		   LS_64(sw_cq_sel, IRDMA_CQ_DBSA_SW_CQ_SELECT) |
+		   LS_64(arm_next_se, IRDMA_CQ_DBSA_ARM_NEXT_SE) |
+		   LS_64(arm_next, IRDMA_CQ_DBSA_ARM_NEXT);
+
+	set_64bit_val(cq->shadow_area, 32, temp_val);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	writel(cq->cq_id, cq->cqe_alloc_db);
+}
+
+/**
+ * irdma_cq_post_entries - update tail in shadow memory
+ * @cq: hw cq
+ * @count: # of entries processed
+ */
+static enum irdma_status_code irdma_cq_post_entries(struct irdma_cq_uk *cq,
+						    u8 count)
+{
+	IRDMA_RING_MOVE_TAIL_BY_COUNT(cq->cq_ring, count);
+	set_64bit_val(cq->shadow_area, 0,
+		      IRDMA_RING_CURRENT_HEAD(cq->cq_ring));
+
+	return 0;
+}
+
+/**
+ * irdma_cq_poll_cmpl - get cq completion info
+ * @cq: hw cq
+ * @info: cq poll information returned
+ */
+static enum irdma_status_code
+irdma_cq_poll_cmpl(struct irdma_cq_uk *cq, struct irdma_cq_poll_info *info)
+{
+	u64 comp_ctx, qword0, qword2, qword3, qword4, qword6, qword7, wqe_qword;
+	__le64 *cqe, *sw_wqe;
+	struct irdma_qp_uk *qp;
+	struct irdma_ring *pring = NULL;
+	u32 wqe_idx, q_type, array_idx = 0;
+	enum irdma_status_code ret_code = 0;
+	bool move_cq_head = true;
+	u8 polarity;
+	bool ext_valid;
+	__le64 *ext_cqe;
+	u32 peek_head;
+	unsigned long flags = 0;
+
+	if (cq->avoid_mem_cflct)
+		cqe = IRDMA_GET_CURRENT_EXTENDED_CQ_ELEM(cq);
+	else
+		cqe = IRDMA_GET_CURRENT_CQ_ELEM(cq);
+
+	get_64bit_val(cqe, 24, &qword3);
+	polarity = (u8)RS_64(qword3, IRDMA_CQ_VALID);
+	if (polarity != cq->polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	/* Ensure CQE contents are read after valid bit is checked */
+	dma_rmb();
+
+	ext_valid = (bool)RS_64(qword3, IRDMA_CQ_EXTCQE);
+	if (ext_valid) {
+		if (cq->avoid_mem_cflct) {
+			ext_cqe = (__le64 *)((u8 *)cqe + 32);
+			get_64bit_val(ext_cqe, 24, &qword7);
+			polarity = (u8)RS_64(qword7, IRDMA_CQ_VALID);
+		} else {
+			peek_head = (cq->cq_ring.head + 1) % cq->cq_ring.size;
+			ext_cqe = cq->cq_base[peek_head].buf;
+			get_64bit_val(ext_cqe, 24, &qword7);
+			polarity = (u8)RS_64(qword7, IRDMA_CQ_VALID);
+			if (!peek_head)
+				polarity ^= 1;
+		}
+		if (polarity != cq->polarity)
+			return IRDMA_ERR_Q_EMPTY;
+
+		/* Ensure ext CQE contents are read after ext valid bit is checked */
+		dma_rmb();
+
+		info->imm_valid = (bool)RS_64(qword7, IRDMA_CQ_IMMVALID);
+		if (info->imm_valid) {
+			get_64bit_val(ext_cqe, 0, &qword4);
+			info->imm_data = (u32)RS_64(qword4, IRDMA_CQ_IMMDATALOW32);
+		}
+		info->ud_smac_valid = (bool)RS_64(qword7, IRDMA_CQ_UDSMACVALID);
+		info->ud_vlan_valid = (bool)RS_64(qword7, IRDMA_CQ_UDVLANVALID);
+		if (info->ud_smac_valid || info->ud_vlan_valid) {
+			get_64bit_val(ext_cqe, 16, &qword6);
+			if (info->ud_vlan_valid)
+				info->ud_vlan = (u16)RS_64(qword6, IRDMA_CQ_UDVLAN);
+			if (info->ud_smac_valid) {
+				info->ud_smac[5] = qword6 & 0xFF;
+				info->ud_smac[4] = (qword6 >> 8) & 0xFF;
+				info->ud_smac[3] = (qword6 >> 16) & 0xFF;
+				info->ud_smac[2] = (qword6 >> 24) & 0xFF;
+				info->ud_smac[1] = (qword6 >> 32) & 0xFF;
+				info->ud_smac[0] = (qword6 >> 40) & 0xFF;
+			}
+		}
+	} else {
+		info->imm_valid = false;
+		info->ud_smac_valid = false;
+		info->ud_vlan_valid = false;
+	}
+
+	q_type = (u8)RS_64(qword3, IRDMA_CQ_SQ);
+	info->error = (bool)RS_64(qword3, IRDMA_CQ_ERROR);
+	info->push_dropped = (bool)RS_64(qword3, IRDMACQ_PSHDROP);
+	info->ipv4 = (bool)RS_64(qword3, IRDMACQ_IPV4);
+	if (info->error) {
+		info->major_err = RS_64(qword3, IRDMA_CQ_MAJERR);
+		info->minor_err = RS_64(qword3, IRDMA_CQ_MINERR);
+		if (info->major_err == IRDMA_FLUSH_MAJOR_ERR)
+			info->comp_status = IRDMA_COMPL_STATUS_FLUSHED;
+		else if (info->major_err == IRDMA_LEN_MAJOR_ERR)
+			info->comp_status = IRDMA_COMPL_STATUS_INVALID_LEN;
+		else
+			info->comp_status = IRDMA_COMPL_STATUS_UNKNOWN;
+	} else {
+		info->comp_status = IRDMA_COMPL_STATUS_SUCCESS;
+	}
+
+	get_64bit_val(cqe, 0, &qword0);
+	get_64bit_val(cqe, 16, &qword2);
+
+	info->tcp_seq_num_rtt = (u32)RS_64(qword0, IRDMACQ_TCPSEQNUMRTT);
+	info->qp_id = (u32)RS_64(qword2, IRDMACQ_QPID);
+	info->ud_src_qpn = (u32)RS_64(qword2, IRDMACQ_UDSRCQPN);
+
+	get_64bit_val(cqe, 8, &comp_ctx);
+
+	info->solicited_event = (bool)RS_64(qword3, IRDMACQ_SOEVENT);
+
+	qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
+	if (!qp) {
+		ret_code = IRDMA_ERR_Q_DESTROYED;
+		goto exit;
+	}
+	wqe_idx = (u32)RS_64(qword3, IRDMA_CQ_WQEIDX);
+	info->qp_handle = (irdma_qp_handle)(unsigned long)qp;
+
+	if (q_type == IRDMA_CQE_QTYPE_RQ) {
+		array_idx = wqe_idx / qp->rq_wqe_size_multiplier;
+		if (info->comp_status == IRDMA_COMPL_STATUS_FLUSHED ||
+		    info->comp_status == IRDMA_COMPL_STATUS_INVALID_LEN) {
+			if (!IRDMA_RING_MORE_WORK(qp->rq_ring)) {
+				ret_code = IRDMA_ERR_Q_EMPTY;
+				goto exit;
+			}
+
+			info->wr_id = qp->rq_wrid_array[qp->rq_ring.tail];
+			array_idx = qp->rq_ring.tail;
+		} else {
+			info->wr_id = qp->rq_wrid_array[array_idx];
+		}
+
+		if (info->imm_valid)
+			info->op_type = IRDMA_OP_TYPE_REC_IMM;
+		else
+			info->op_type = IRDMA_OP_TYPE_REC;
+		if (qword3 & IRDMACQ_STAG_M) {
+			info->stag_invalid_set = true;
+			info->inv_stag = (u32)RS_64(qword2, IRDMACQ_INVSTAG);
+		} else {
+			info->stag_invalid_set = false;
+		}
+		info->bytes_xfered = (u32)RS_64(qword0, IRDMACQ_PAYLDLEN);
+		IRDMA_RING_SET_TAIL(qp->rq_ring, array_idx + 1);
+		if (info->comp_status == IRDMA_COMPL_STATUS_FLUSHED) {
+			spin_lock_irqsave(qp->lock, flags);
+			if (!IRDMA_RING_MORE_WORK(qp->rq_ring))
+				qp->rq_flush_complete = true;
+			else
+				move_cq_head = false;
+			spin_unlock_irqrestore(qp->lock, flags);
+		}
+		pring = &qp->rq_ring;
+	} else { /* q_type is IRDMA_CQE_QTYPE_SQ */
+		if (qp->first_sq_wq) {
+			qp->first_sq_wq = false;
+			if (!wqe_idx && qp->sq_ring.head == qp->sq_ring.tail) {
+				IRDMA_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
+				IRDMA_RING_MOVE_TAIL(cq->cq_ring);
+				set_64bit_val(cq->shadow_area, 0,
+					      IRDMA_RING_CURRENT_HEAD(cq->cq_ring));
+				memset(info, 0,
+				       sizeof(struct irdma_cq_poll_info));
+				return irdma_cq_poll_cmpl(cq, info);
+			}
+		}
+		/*cease posting push mode on push drop*/
+		if (info->push_dropped)
+			qp->push_mode = false;
+
+		if (info->comp_status != IRDMA_COMPL_STATUS_FLUSHED) {
+			info->wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
+			if (!info->comp_status)
+				info->bytes_xfered = qp->sq_wrtrk_array[wqe_idx].wr_len;
+			info->op_type = (u8)RS_64(qword3, IRDMACQ_OP);
+			sw_wqe = qp->sq_base[wqe_idx].elem;
+			get_64bit_val(sw_wqe, 24, &wqe_qword);
+			IRDMA_RING_SET_TAIL(qp->sq_ring,
+					    wqe_idx + qp->sq_wrtrk_array[wqe_idx].quanta);
+		} else {
+			if (!IRDMA_RING_MORE_WORK(qp->sq_ring)) {
+				ret_code = IRDMA_ERR_Q_EMPTY;
+				goto exit;
+			}
+
+			do {
+				u8 op_type;
+				u32 tail;
+
+				tail = qp->sq_ring.tail;
+				sw_wqe = qp->sq_base[tail].elem;
+				get_64bit_val(sw_wqe, 24,
+					      &wqe_qword);
+				op_type = (u8)RS_64(wqe_qword, IRDMAQPSQ_OPCODE);
+				info->op_type = op_type;
+				IRDMA_RING_SET_TAIL(qp->sq_ring,
+						    tail + qp->sq_wrtrk_array[tail].quanta);
+				if (op_type != IRDMAQP_OP_NOP) {
+					info->wr_id = qp->sq_wrtrk_array[tail].wrid;
+					info->bytes_xfered = qp->sq_wrtrk_array[tail].wr_len;
+					break;
+				}
+			} while (1);
+			spin_lock_irqsave(qp->lock, flags);
+			if (!IRDMA_RING_MORE_WORK(qp->sq_ring))
+				qp->sq_flush_complete = true;
+			else
+				move_cq_head = false;
+			spin_unlock_irqrestore(qp->lock, flags);
+		}
+		pring = &qp->sq_ring;
+	}
+
+	ret_code = 0;
+
+exit:
+
+	if (move_cq_head) {
+		IRDMA_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
+		if (!IRDMA_RING_CURRENT_HEAD(cq->cq_ring))
+			cq->polarity ^= 1;
+
+		if (ext_valid && !cq->avoid_mem_cflct) {
+			IRDMA_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
+			if (!IRDMA_RING_CURRENT_HEAD(cq->cq_ring))
+				cq->polarity ^= 1;
+		}
+
+		IRDMA_RING_MOVE_TAIL(cq->cq_ring);
+		if (!cq->avoid_mem_cflct && ext_valid)
+			IRDMA_RING_MOVE_TAIL(cq->cq_ring);
+		set_64bit_val(cq->shadow_area, 0,
+			      IRDMA_RING_CURRENT_HEAD(cq->cq_ring));
+	} else {
+		qword3 &= ~IRDMA_CQ_WQEIDX_M;
+		qword3 |= LS_64(pring->tail, IRDMA_CQ_WQEIDX);
+		set_64bit_val(cqe, 24, qword3);
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_qp_roundup - return round up qp wq depth
+ * @wqdepth: wq depth in quanta to round up
+ */
+static int irdma_qp_round_up(u32 wqdepth)
+{
+	int scount = 1;
+
+	for (wqdepth--; scount <= 16; scount *= 2)
+		wqdepth |= wqdepth >> scount;
+
+	return ++wqdepth;
+}
+
+/**
+ * irdma_get_wqe_shift - get shift count for maximum wqe size
+ * @uk_attrs: qp HW attributes
+ * @sge: Maximum Scatter Gather Elements wqe
+ * @inline_data: Maximum inline data size
+ * @shift: Returns the shift needed based on sge
+ *
+ * Shift can be used to left shift the wqe size based on number of SGEs and inlind data size.
+ * For 1 SGE or inline data <= 8, shift = 0 (wqe size of 32
+ * bytes). For 2 or 3 SGEs or inline data <= 39, shift = 1 (wqe
+ * size of 64 bytes).
+ * For 4-7 SGE's and inline <= 101 Shift of 2 otherwise (wqe
+ * size of 256 bytes).
+ */
+void irdma_get_wqe_shift(struct irdma_uk_attrs *uk_attrs, u32 sge,
+			 u32 inline_data, u8 *shift)
+{
+	*shift = 0;
+	if (uk_attrs->hw_rev > IRDMA_GEN_1) {
+		if (sge > 1 || inline_data > 8) {
+			if (sge < 4 && inline_data <= 39)
+				*shift = 1;
+			else if (sge < 8 && inline_data <= 101)
+				*shift = 2;
+			else
+				*shift = 3;
+		}
+	} else if (sge > 1 || inline_data > 16) {
+		*shift = (sge < 4 && inline_data <= 48) ? 1 : 2;
+	}
+}
+
+/*
+ * irdma_get_sqdepth - get SQ depth (quanta)
+ * @uk_attrs: qp HW attributes
+ * @sq_size: SQ size
+ * @shift: shift which determines size of WQE
+ * @sqdepth: depth of SQ
+ *
+ */
+enum irdma_status_code irdma_get_sqdepth(struct irdma_uk_attrs *uk_attrs,
+					 u32 sq_size, u8 shift, u32 *sqdepth)
+{
+	*sqdepth = irdma_qp_round_up((sq_size << shift) + IRDMA_SQ_RSVD);
+
+	if (*sqdepth < (IRDMA_QP_SW_MIN_WQSIZE << shift))
+		*sqdepth = IRDMA_QP_SW_MIN_WQSIZE << shift;
+	else if (*sqdepth > uk_attrs->max_hw_wq_quanta)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	return 0;
+}
+
+/*
+ * irdma_get_rqdepth - get RQ depth (quanta)
+ * @uk_attrs: qp HW attributes
+ * @rq_size: RQ size
+ * @shift: shift which determines size of WQE
+ * @rqdepth: depth of RQ
+ */
+enum irdma_status_code irdma_get_rqdepth(struct irdma_uk_attrs *uk_attrs,
+					 u32 rq_size, u8 shift, u32 *rqdepth)
+{
+	*rqdepth = irdma_qp_round_up((rq_size << shift) + IRDMA_RQ_RSVD);
+
+	if (*rqdepth < (IRDMA_QP_SW_MIN_WQSIZE << shift))
+		*rqdepth = IRDMA_QP_SW_MIN_WQSIZE << shift;
+	else if (*rqdepth > uk_attrs->max_hw_rq_quanta)
+		return IRDMA_ERR_INVALID_SIZE;
+
+	return 0;
+}
+
+static struct irdma_qp_uk_ops iw_qp_uk_ops = {
+	.iw_inline_rdma_write = irdma_inline_rdma_write,
+	.iw_inline_send = irdma_inline_send,
+	.iw_mw_bind = irdma_mw_bind,
+	.iw_post_nop = irdma_nop,
+	.iw_post_receive = irdma_post_receive,
+	.iw_qp_post_wr = irdma_qp_post_wr,
+	.iw_qp_ring_push_db = irdma_qp_ring_push_db,
+	.iw_rdma_read = irdma_rdma_read,
+	.iw_rdma_write = irdma_rdma_write,
+	.iw_send = irdma_send,
+	.iw_stag_local_invalidate = irdma_stag_local_invalidate,
+};
+
+static struct irdma_wqe_uk_ops iw_wqe_uk_ops = {
+	.iw_copy_inline_data = irdma_copy_inline_data,
+	.iw_inline_data_size_to_quanta = irdma_inline_data_size_to_quanta,
+	.iw_set_fragment = irdma_set_fragment,
+	.iw_set_mw_bind_wqe = irdma_set_mw_bind_wqe,
+};
+
+static struct irdma_wqe_uk_ops iw_wqe_uk_ops_gen_1 = {
+	.iw_copy_inline_data = irdma_copy_inline_data_gen_1,
+	.iw_inline_data_size_to_quanta = irdma_inline_data_size_to_quanta_gen_1,
+	.iw_set_fragment = irdma_set_fragment_gen_1,
+	.iw_set_mw_bind_wqe = irdma_set_mw_bind_wqe_gen_1,
+};
+
+static struct irdma_cq_ops iw_cq_ops = {
+	.iw_cq_clean = irdma_clean_cq,
+	.iw_cq_poll_cmpl = irdma_cq_poll_cmpl,
+	.iw_cq_post_entries = irdma_cq_post_entries,
+	.iw_cq_request_notification = irdma_cq_request_notification,
+	.iw_cq_resize = irdma_cq_resize,
+	.iw_cq_set_resized_cnt = irdma_cq_set_resized_cnt,
+};
+
+static struct irdma_device_uk_ops iw_device_uk_ops = {
+	.iw_cq_uk_init = irdma_cq_uk_init,
+	.iw_qp_uk_init = irdma_qp_uk_init,
+};
+
+/**
+ * irdma_setup_connection_wqes - setup WQEs necessary to complete
+ * connection.
+ * @qp: hw qp (user and kernel)
+ * @info: qp initialization info
+ */
+static void irdma_setup_connection_wqes(struct irdma_qp_uk *qp,
+					struct irdma_qp_uk_init_info *info)
+{
+	u16 move_cnt = 1;
+
+	if (info->abi_ver > 5 &&
+	    (qp->uk_attrs->feature_flags & IRDMA_FEATURE_RTS_AE))
+		move_cnt = 3;
+
+	IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(qp->sq_ring, move_cnt);
+	IRDMA_RING_MOVE_TAIL_BY_COUNT(qp->sq_ring, move_cnt);
+	IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(qp->initial_ring, move_cnt);
+}
+
+/**
+ * irdma_qp_uk_init - initialize shared qp
+ * @qp: hw qp (user and kernel)
+ * @info: qp initialization info
+ *
+ * initializes the vars used in both user and kernel mode.
+ * size of the wqe depends on numbers of max. fragements
+ * allowed. Then size of wqe * the number of wqes should be the
+ * amount of memory allocated for sq and rq.
+ */
+enum irdma_status_code irdma_qp_uk_init(struct irdma_qp_uk *qp,
+					struct irdma_qp_uk_init_info *info)
+{
+	enum irdma_status_code ret_code = 0;
+	u32 sq_ring_size;
+	u8 sqshift, rqshift;
+
+	qp->uk_attrs = info->uk_attrs;
+	if (info->max_sq_frag_cnt > qp->uk_attrs->max_hw_wq_frags ||
+	    info->max_rq_frag_cnt > qp->uk_attrs->max_hw_wq_frags)
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+
+	irdma_get_wqe_shift(qp->uk_attrs, info->max_rq_frag_cnt, 0, &rqshift);
+	if (qp->uk_attrs->hw_rev == IRDMA_GEN_1) {
+		irdma_get_wqe_shift(qp->uk_attrs, info->max_sq_frag_cnt,
+				    info->max_inline_data, &sqshift);
+		if (info->abi_ver > 4)
+			rqshift = IRDMA_MAX_RQ_WQE_SHIFT_GEN1;
+	} else {
+		irdma_get_wqe_shift(qp->uk_attrs, info->max_sq_frag_cnt + 1,
+				    info->max_inline_data, &sqshift);
+	}
+	qp->qp_caps = info->qp_caps;
+	qp->sq_base = info->sq;
+	qp->rq_base = info->rq;
+	qp->shadow_area = info->shadow_area;
+	qp->sq_wrtrk_array = info->sq_wrtrk_array;
+	qp->rq_wrid_array = info->rq_wrid_array;
+	qp->wqe_alloc_db = info->wqe_alloc_db;
+	qp->qp_id = info->qp_id;
+	qp->sq_size = info->sq_size;
+	qp->push_mode = false;
+	qp->max_sq_frag_cnt = info->max_sq_frag_cnt;
+	sq_ring_size = qp->sq_size << sqshift;
+	IRDMA_RING_INIT(qp->sq_ring, sq_ring_size);
+	IRDMA_RING_INIT(qp->initial_ring, sq_ring_size);
+	if (info->first_sq_wq) {
+		irdma_setup_connection_wqes(qp, info);
+		qp->swqe_polarity = 1;
+		qp->first_sq_wq = true;
+	} else {
+		qp->swqe_polarity = 0;
+	}
+	qp->swqe_polarity_deferred = 1;
+	qp->rwqe_polarity = 0;
+	qp->rq_size = info->rq_size;
+	qp->max_rq_frag_cnt = info->max_rq_frag_cnt;
+	qp->max_inline_data = info->max_inline_data;
+	qp->rq_wqe_size = rqshift;
+	IRDMA_RING_INIT(qp->rq_ring, qp->rq_size);
+	qp->rq_wqe_size_multiplier = 1 << rqshift;
+	qp->qp_ops = iw_qp_uk_ops;
+	if (qp->uk_attrs->hw_rev == IRDMA_GEN_1)
+		qp->wqe_ops = iw_wqe_uk_ops_gen_1;
+	else
+		qp->wqe_ops = iw_wqe_uk_ops;
+
+	return ret_code;
+}
+
+/**
+ * irdma_cq_uk_init - initialize shared cq (user and kernel)
+ * @cq: hw cq
+ * @info: hw cq initialization info
+ */
+enum irdma_status_code irdma_cq_uk_init(struct irdma_cq_uk *cq,
+					struct irdma_cq_uk_init_info *info)
+{
+	cq->cq_base = info->cq_base;
+	cq->cq_id = info->cq_id;
+	cq->cq_size = info->cq_size;
+	cq->cqe_alloc_db = info->cqe_alloc_db;
+	cq->cq_ack_db = info->cq_ack_db;
+	cq->shadow_area = info->shadow_area;
+	cq->avoid_mem_cflct = info->avoid_mem_cflct;
+	IRDMA_RING_INIT(cq->cq_ring, cq->cq_size);
+	cq->polarity = 1;
+	cq->ops = iw_cq_ops;
+
+	return 0;
+}
+
+/**
+ * irdma_device_init_uk - setup routines for iwarp shared device
+ * @dev: iwarp shared (user and kernel)
+ */
+void irdma_device_init_uk(struct irdma_dev_uk *dev)
+{
+	dev->ops_uk = iw_device_uk_ops;
+}
+
+/**
+ * irdma_clean_cq - clean cq entries
+ * @q: completion context
+ * @cq: cq to clean
+ */
+void irdma_clean_cq(void *q, struct irdma_cq_uk *cq)
+{
+	__le64 *cqe;
+	u64 qword3, comp_ctx;
+	u32 cq_head;
+	u8 polarity, temp;
+
+	cq_head = cq->cq_ring.head;
+	temp = cq->polarity;
+	do {
+		if (cq->avoid_mem_cflct)
+			cqe = ((struct irdma_extended_cqe *)(cq->cq_base))[cq_head].buf;
+		else
+			cqe = cq->cq_base[cq_head].buf;
+		get_64bit_val(cqe, 24, &qword3);
+		polarity = (u8)RS_64(qword3, IRDMA_CQ_VALID);
+
+		if (polarity != temp)
+			break;
+
+		get_64bit_val(cqe, 8, &comp_ctx);
+		if ((void *)(unsigned long)comp_ctx == q)
+			set_64bit_val(cqe, 8, 0);
+
+		cq_head = (cq_head + 1) % cq->cq_ring.size;
+		if (!cq_head)
+			temp ^= 1;
+	} while (true);
+}
+
+/**
+ * irdma_nop - post a nop
+ * @qp: hw qp ptr
+ * @wr_id: work request id
+ * @signaled: signaled for completion
+ * @post_sq: ring doorbell
+ */
+enum irdma_status_code irdma_nop(struct irdma_qp_uk *qp, u64 wr_id,
+				 bool signaled, bool post_sq)
+{
+	__le64 *wqe;
+	u64 hdr;
+	u32 wqe_idx;
+	struct irdma_post_sq_info info = {};
+
+	info.push_wqe = false;
+	info.wr_id = wr_id;
+	wqe = irdma_qp_get_next_send_wqe(qp, &wqe_idx, IRDMA_QP_WQE_MIN_QUANTA,
+					 0, &info);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	irdma_clr_wqes(qp, wqe_idx);
+
+	set_64bit_val(wqe, 0, 0);
+	set_64bit_val(wqe, 8, 0);
+	set_64bit_val(wqe, 16, 0);
+
+	hdr = LS_64(IRDMAQP_OP_NOP, IRDMAQPSQ_OPCODE) |
+	      LS_64(signaled, IRDMAQPSQ_SIGCOMPL) |
+	      LS_64(qp->swqe_polarity, IRDMAQPSQ_VALID);
+
+	dma_wmb(); /* make sure WQE is populated before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+	if (post_sq)
+		irdma_qp_post_wr(qp);
+
+	return 0;
+}
+
+/**
+ * irdma_fragcnt_to_quanta_sq - calculate quanta based on fragment count for SQ
+ * @frag_cnt: number of fragments
+ * @quanta: quanta for frag_cnt
+ */
+enum irdma_status_code irdma_fragcnt_to_quanta_sq(u32 frag_cnt, u16 *quanta)
+{
+	switch (frag_cnt) {
+	case 0:
+	case 1:
+		*quanta = IRDMA_QP_WQE_MIN_QUANTA;
+		break;
+	case 2:
+	case 3:
+		*quanta = 2;
+		break;
+	case 4:
+	case 5:
+		*quanta = 3;
+		break;
+	case 6:
+	case 7:
+		*quanta = 4;
+		break;
+	case 8:
+	case 9:
+		*quanta = 5;
+		break;
+	case 10:
+	case 11:
+		*quanta = 6;
+		break;
+	case 12:
+	case 13:
+		*quanta = 7;
+		break;
+	case 14:
+	case 15: /* when immediate data is present */
+		*quanta = 8;
+		break;
+	default:
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_fragcnt_to_wqesize_rq - calculate wqe size based on fragment count for RQ
+ * @frag_cnt: number of fragments
+ * @wqe_size: size in bytes given frag_cnt
+ */
+enum irdma_status_code irdma_fragcnt_to_wqesize_rq(u32 frag_cnt, u16 *wqe_size)
+{
+	switch (frag_cnt) {
+	case 0:
+	case 1:
+		*wqe_size = 32;
+		break;
+	case 2:
+	case 3:
+		*wqe_size = 64;
+		break;
+	case 4:
+	case 5:
+	case 6:
+	case 7:
+		*wqe_size = 128;
+		break;
+	case 8:
+	case 9:
+	case 10:
+	case 11:
+	case 12:
+	case 13:
+	case 14:
+		*wqe_size = 256;
+		break;
+	default:
+		return IRDMA_ERR_INVALID_FRAG_COUNT;
+	}
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
new file mode 100644
index 000000000000..aba2b0917aa8
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -0,0 +1,448 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_USER_H
+#define IRDMA_USER_H
+
+#define irdma_handle void *
+#define irdma_adapter_handle irdma_handle
+#define irdma_qp_handle irdma_handle
+#define irdma_cq_handle irdma_handle
+#define irdma_pd_id irdma_handle
+#define irdma_stag_handle irdma_handle
+#define irdma_stag_index u32
+#define irdma_stag u32
+#define irdma_stag_key u8
+#define irdma_tagged_offset u64
+#define irdma_access_privileges u32
+#define irdma_physical_fragment u64
+#define irdma_address_list u64 *
+#define irdma_sgl struct irdma_sge *
+
+#define	IRDMA_MAX_MR_SIZE       0x7FFFFFFFL
+
+#define IRDMA_ACCESS_FLAGS_LOCALREAD		0x01
+#define IRDMA_ACCESS_FLAGS_LOCALWRITE		0x02
+#define IRDMA_ACCESS_FLAGS_REMOTEREAD_ONLY	0x04
+#define IRDMA_ACCESS_FLAGS_REMOTEREAD		0x05
+#define IRDMA_ACCESS_FLAGS_REMOTEWRITE_ONLY	0x08
+#define IRDMA_ACCESS_FLAGS_REMOTEWRITE		0x0a
+#define IRDMA_ACCESS_FLAGS_BIND_WINDOW		0x10
+#define IRDMA_ACCESS_FLAGS_ALL			0x1f
+
+#define IRDMA_OP_TYPE_RDMA_WRITE		0x00
+#define IRDMA_OP_TYPE_RDMA_READ			0x01
+#define IRDMA_OP_TYPE_SEND			0x03
+#define IRDMA_OP_TYPE_SEND_INV			0x04
+#define IRDMA_OP_TYPE_SEND_SOL			0x05
+#define IRDMA_OP_TYPE_SEND_SOL_INV		0x06
+#define IRDMA_OP_TYPE_RDMA_WRITE_SOL		0x0d
+#define IRDMA_OP_TYPE_BIND_MW			0x08
+#define IRDMA_OP_TYPE_FAST_REG_NSMR		0x09
+#define IRDMA_OP_TYPE_INV_STAG			0x0a
+#define IRDMA_OP_TYPE_RDMA_READ_INV_STAG	0x0b
+#define IRDMA_OP_TYPE_NOP			0x0c
+#define IRDMA_OP_TYPE_REC	0x3e
+#define IRDMA_OP_TYPE_REC_IMM	0x3f
+
+#define IRDMA_FLUSH_MAJOR_ERR	1
+#define IRDMA_LEN_MAJOR_ERR	2
+
+enum irdma_device_caps_const {
+	IRDMA_WQE_SIZE =			4,
+	IRDMA_CQP_WQE_SIZE =			8,
+	IRDMA_CQE_SIZE =			4,
+	IRDMA_EXTENDED_CQE_SIZE =		8,
+	IRDMA_AEQE_SIZE =			2,
+	IRDMA_CEQE_SIZE =			1,
+	IRDMA_CQP_CTX_SIZE =			8,
+	IRDMA_SHADOW_AREA_SIZE =		8,
+	IRDMA_QUERY_FPM_BUF_SIZE =		176,
+	IRDMA_COMMIT_FPM_BUF_SIZE =		176,
+	IRDMA_GATHER_STATS_BUF_SIZE =		1024,
+	IRDMA_MIN_IW_QP_ID =			0,
+	IRDMA_MAX_IW_QP_ID =			262143,
+	IRDMA_MIN_CEQID =			0,
+	IRDMA_MAX_CEQID =			1023,
+	IRDMA_CEQ_MAX_COUNT =			IRDMA_MAX_CEQID + 1,
+	IRDMA_MIN_CQID =			0,
+	IRDMA_MAX_CQID =			524287,
+	IRDMA_MIN_AEQ_ENTRIES =			1,
+	IRDMA_MAX_AEQ_ENTRIES =			524287,
+	IRDMA_MIN_CEQ_ENTRIES =			1,
+	IRDMA_MAX_CEQ_ENTRIES =			262143,
+	IRDMA_MIN_CQ_SIZE =			1,
+	IRDMA_MAX_CQ_SIZE =			1048575,
+	IRDMA_DB_ID_ZERO =			0,
+	IRDMA_MAX_WQ_FRAGMENT_COUNT =		13,
+	IRDMA_MAX_SGE_RD =			13,
+	IRDMA_MAX_OUTBOUND_MSG_SIZE =		2147483647,
+	IRDMA_MAX_INBOUND_MSG_SIZE =		2147483647,
+	IRDMA_MAX_PUSH_PAGE_COUNT =		4096,
+	IRDMA_MAX_PE_ENA_VF_COUNT =		32,
+	IRDMA_MAX_VF_FPM_ID =			47,
+	IRDMA_MAX_SQ_PAYLOAD_SIZE =		2145386496,
+	IRDMA_MAX_INLINE_DATA_SIZE =		96,
+	IRDMA_MAX_IRD_SIZE =			127,
+	IRDMA_MAX_ORD_SIZE =			255,
+	IRDMA_MAX_WQ_ENTRIES =			32768,
+	IRDMA_Q2_BUF_SIZE =			256,
+	IRDMA_QP_CTX_SIZE =			256,
+	IRDMA_MAX_PDS =				262144,
+};
+
+enum irdma_addressing_type {
+	IRDMA_ADDR_TYPE_ZERO_BASED = 0,
+	IRDMA_ADDR_TYPE_VA_BASED   = 1,
+};
+
+enum irdma_cmpl_status {
+	IRDMA_COMPL_STATUS_SUCCESS = 0,
+	IRDMA_COMPL_STATUS_FLUSHED,
+	IRDMA_COMPL_STATUS_INVALID_WQE,
+	IRDMA_COMPL_STATUS_QP_CATASTROPHIC,
+	IRDMA_COMPL_STATUS_REMOTE_TERMINATION,
+	IRDMA_COMPL_STATUS_INVALID_STAG,
+	IRDMA_COMPL_STATUS_BASE_BOUND_VIOLATION,
+	IRDMA_COMPL_STATUS_ACCESS_VIOLATION,
+	IRDMA_COMPL_STATUS_INVALID_PD_ID,
+	IRDMA_COMPL_STATUS_WRAP_ERROR,
+	IRDMA_COMPL_STATUS_STAG_INVALID_PDID,
+	IRDMA_COMPL_STATUS_RDMA_READ_ZERO_ORD,
+	IRDMA_COMPL_STATUS_QP_NOT_PRIVLEDGED,
+	IRDMA_COMPL_STATUS_STAG_NOT_INVALID,
+	IRDMA_COMPL_STATUS_INVALID_PHYS_BUF_SIZE,
+	IRDMA_COMPL_STATUS_INVALID_PHYS_BUF_ENTRY,
+	IRDMA_COMPL_STATUS_INVALID_FBO,
+	IRDMA_COMPL_STATUS_INVALID_LEN,
+	IRDMA_COMPL_STATUS_INVALID_ACCESS,
+	IRDMA_COMPL_STATUS_PHYS_BUF_LIST_TOO_LONG,
+	IRDMA_COMPL_STATUS_INVALID_VIRT_ADDRESS,
+	IRDMA_COMPL_STATUS_INVALID_REGION,
+	IRDMA_COMPL_STATUS_INVALID_WINDOW,
+	IRDMA_COMPL_STATUS_INVALID_TOTAL_LEN,
+	IRDMA_COMPL_STATUS_UNKNOWN,
+};
+
+enum irdma_cmpl_notify {
+	IRDMA_CQ_COMPL_EVENT     = 0,
+	IRDMA_CQ_COMPL_SOLICITED = 1,
+};
+
+enum irdma_qp_caps {
+	IRDMA_WRITE_WITH_IMM = 1,
+	IRDMA_SEND_WITH_IMM  = 2,
+	IRDMA_ROCE	     = 4,
+};
+
+struct irdma_qp_uk;
+struct irdma_cq_uk;
+struct irdma_qp_uk_init_info;
+struct irdma_cq_uk_init_info;
+
+struct irdma_sge {
+	irdma_tagged_offset tag_off;
+	u32 len;
+	irdma_stag stag;
+};
+
+struct irdma_ring {
+	u32 head;
+	u32 tail;
+	u32 size;
+};
+
+struct irdma_cqe {
+	__le64 buf[IRDMA_CQE_SIZE];
+};
+
+struct irdma_extended_cqe {
+	__le64 buf[IRDMA_EXTENDED_CQE_SIZE];
+};
+
+struct irdma_post_send {
+	irdma_sgl sg_list;
+	u32 num_sges;
+	u32 qkey;
+	u32 dest_qp;
+	u32 ah_id;
+};
+
+struct irdma_post_inline_send {
+	void *data;
+	u32 len;
+	u32 qkey;
+	u32 dest_qp;
+	u32 ah_id;
+};
+
+struct irdma_rdma_write {
+	irdma_sgl lo_sg_list;
+	u32 num_lo_sges;
+	struct irdma_sge rem_addr;
+};
+
+struct irdma_inline_rdma_write {
+	void *data;
+	u32 len;
+	struct irdma_sge rem_addr;
+};
+
+struct irdma_rdma_read {
+	irdma_sgl lo_sg_list;
+	u32 num_lo_sges;
+	struct irdma_sge rem_addr;
+};
+
+struct irdma_bind_window {
+	irdma_stag mr_stag;
+	u64 bind_len;
+	void *va;
+	enum irdma_addressing_type addressing_type;
+	bool ena_reads:1;
+	bool ena_writes:1;
+	irdma_stag mw_stag;
+	bool mem_window_type_1:1;
+};
+
+struct irdma_inv_local_stag {
+	irdma_stag target_stag;
+};
+
+struct irdma_post_sq_info {
+	u64 wr_id;
+	u8 op_type;
+	u8 l4len;
+	bool signaled:1;
+	bool read_fence:1;
+	bool local_fence:1;
+	bool inline_data:1;
+	bool imm_data_valid:1;
+	bool push_wqe:1;
+	bool report_rtt:1;
+	bool udp_hdr:1;
+	bool defer_flag:1;
+	u32 imm_data;
+	u32 stag_to_inv;
+	union {
+		struct irdma_post_send send;
+		struct irdma_rdma_write rdma_write;
+		struct irdma_rdma_read rdma_read;
+		struct irdma_bind_window bind_window;
+		struct irdma_inv_local_stag inv_local_stag;
+		struct irdma_inline_rdma_write inline_rdma_write;
+		struct irdma_post_inline_send inline_send;
+	} op;
+};
+
+struct irdma_post_rq_info {
+	u64 wr_id;
+	irdma_sgl sg_list;
+	u32 num_sges;
+};
+
+struct irdma_cq_poll_info {
+	u64 wr_id;
+	irdma_qp_handle qp_handle;
+	u32 bytes_xfered;
+	u32 tcp_seq_num_rtt;
+	u32 qp_id;
+	u32 ud_src_qpn;
+	u32 imm_data;
+	irdma_stag inv_stag; /* or L_R_Key */
+	enum irdma_cmpl_status comp_status;
+	u16 major_err;
+	u16 minor_err;
+	u16 ud_vlan;
+	u8 ud_smac[6];
+	u8 op_type;
+	bool stag_invalid_set:1; /* or L_R_Key set */
+	bool push_dropped:1;
+	bool error:1;
+	bool solicited_event:1;
+	bool ipv4:1;
+	bool ud_vlan_valid:1;
+	bool ud_smac_valid:1;
+	bool imm_valid:1;
+};
+
+struct irdma_qp_uk_ops {
+	enum irdma_status_code (*iw_rdma_write)(struct irdma_qp_uk *qp,
+						struct irdma_post_sq_info *info,
+						bool post_sq);
+	enum irdma_status_code (*iw_inline_send)(struct irdma_qp_uk *qp,
+						 struct irdma_post_sq_info *info,
+						 bool post_sq);
+	enum irdma_status_code (*iw_mw_bind)(struct irdma_qp_uk *qp,
+					     struct irdma_post_sq_info *info,
+					     bool post_sq);
+	enum irdma_status_code (*iw_post_nop)(struct irdma_qp_uk *qp, u64 wr_id,
+					      bool signaled, bool post_sq);
+	enum irdma_status_code (*iw_post_receive)(struct irdma_qp_uk *qp,
+						  struct irdma_post_rq_info *info);
+	void (*iw_qp_post_wr)(struct irdma_qp_uk *qp);
+	void (*iw_qp_ring_push_db)(struct irdma_qp_uk *qp, u32 wqe_index);
+	enum irdma_status_code (*iw_rdma_read)(struct irdma_qp_uk *qp,
+					       struct irdma_post_sq_info *info,
+					       bool inv_stag, bool post_sq);
+	enum irdma_status_code (*iw_inline_rdma_write)(struct irdma_qp_uk *qp,
+						       struct irdma_post_sq_info *info,
+						       bool post_sq);
+	enum irdma_status_code (*iw_send)(struct irdma_qp_uk *qp,
+					  struct irdma_post_sq_info *info,
+					  bool post_sq);
+	enum irdma_status_code (*iw_stag_local_invalidate)(struct irdma_qp_uk *qp,
+							   struct irdma_post_sq_info *info,
+							   bool post_sq);
+};
+
+struct irdma_wqe_uk_ops {
+	void (*iw_copy_inline_data)(u8 *dest, u8 *src, u32 len, u8 polarity);
+	enum irdma_status_code (*iw_inline_data_size_to_quanta)(u32 data_size,
+								u16 *quanta,
+								u32 max_size);
+	void (*iw_set_fragment)(__le64 *wqe, u32 offset, struct irdma_sge *sge,
+				u8 valid);
+	void (*iw_set_mw_bind_wqe)(__le64 *wqe,
+				   struct irdma_bind_window *op_info);
+};
+
+struct irdma_cq_ops {
+	void (*iw_cq_clean)(void *q, struct irdma_cq_uk *cq);
+	enum irdma_status_code (*iw_cq_poll_cmpl)(struct irdma_cq_uk *cq,
+						  struct irdma_cq_poll_info *info);
+	enum irdma_status_code (*iw_cq_post_entries)(struct irdma_cq_uk *cq,
+						     u8 count);
+	void (*iw_cq_request_notification)(struct irdma_cq_uk *cq,
+					   enum irdma_cmpl_notify cq_notify);
+	void (*iw_cq_resize)(struct irdma_cq_uk *cq, void *cq_base, int size);
+	void (*iw_cq_set_resized_cnt)(struct irdma_cq_uk *qp, u16 cnt);
+};
+
+struct irdma_dev_uk;
+
+struct irdma_device_uk_ops {
+	enum irdma_status_code (*iw_cq_uk_init)(struct irdma_cq_uk *cq,
+						struct irdma_cq_uk_init_info *info);
+	enum irdma_status_code (*iw_qp_uk_init)(struct irdma_qp_uk *qp,
+						struct irdma_qp_uk_init_info *info);
+};
+
+struct irdma_dev_uk {
+	struct irdma_device_uk_ops ops_uk;
+};
+
+struct irdma_sq_uk_wr_trk_info {
+	u64 wrid;
+	u32 wr_len;
+	u16 quanta;
+	u8 reserved[2];
+};
+
+struct irdma_qp_quanta {
+	__le64 elem[IRDMA_WQE_SIZE];
+};
+
+struct irdma_qp_uk {
+	struct irdma_qp_quanta *sq_base;
+	struct irdma_qp_quanta *rq_base;
+	struct irdma_uk_attrs *uk_attrs;
+	u32 __iomem *wqe_alloc_db;
+	struct irdma_sq_uk_wr_trk_info *sq_wrtrk_array;
+	u64 *rq_wrid_array;
+	__le64 *shadow_area;
+	u32 *push_db;
+	__le64 *push_wqe;
+	struct irdma_ring sq_ring;
+	struct irdma_ring rq_ring;
+	struct irdma_ring initial_ring;
+	u32 qp_id;
+	u32 qp_caps;
+	u32 sq_size;
+	u32 rq_size;
+	u32 max_sq_frag_cnt;
+	u32 max_rq_frag_cnt;
+	u32 max_inline_data;
+	struct irdma_qp_uk_ops qp_ops;
+	struct irdma_wqe_uk_ops wqe_ops;
+	u8 swqe_polarity;
+	u8 swqe_polarity_deferred;
+	u8 rwqe_polarity;
+	u8 rq_wqe_size;
+	u8 rq_wqe_size_multiplier;
+	bool deferred_flag:1;
+	bool push_mode:1; /* whether the last post wqe was pushed */
+	bool first_sq_wq:1;
+	bool sq_flush_complete:1; /* Indicates flush was seen and SQ was empty after the flush */
+	bool rq_flush_complete:1; /* Indicates flush was seen and RQ was empty after the flush */
+	void *back_qp;
+	void *lock;
+	u8 dbg_rq_flushed;
+};
+
+struct irdma_cq_uk {
+	struct irdma_cqe *cq_base;
+	u32 __iomem *cqe_alloc_db;
+	u32 __iomem *cq_ack_db;
+	__le64 *shadow_area;
+	u32 cq_id;
+	u32 cq_size;
+	struct irdma_ring cq_ring;
+	u8 polarity;
+	struct irdma_cq_ops ops;
+	bool avoid_mem_cflct;
+};
+
+struct irdma_qp_uk_init_info {
+	struct irdma_qp_quanta *sq;
+	struct irdma_qp_quanta *rq;
+	struct irdma_uk_attrs *uk_attrs;
+	u32 __iomem *wqe_alloc_db;
+	__le64 *shadow_area;
+	struct irdma_sq_uk_wr_trk_info *sq_wrtrk_array;
+	u64 *rq_wrid_array;
+	u32 qp_id;
+	u32 qp_caps;
+	u32 sq_size;
+	u32 rq_size;
+	u32 max_sq_frag_cnt;
+	u32 max_rq_frag_cnt;
+	u32 max_inline_data;
+	u8 first_sq_wq;
+	int abi_ver;
+};
+
+struct irdma_cq_uk_init_info {
+	u32 __iomem *cqe_alloc_db;
+	u32 __iomem *cq_ack_db;
+	struct irdma_cqe *cq_base;
+	__le64 *shadow_area;
+	u32 cq_size;
+	u32 cq_id;
+	bool avoid_mem_cflct;
+};
+
+void irdma_device_init_uk(struct irdma_dev_uk *dev);
+void irdma_qp_post_wr(struct irdma_qp_uk *qp);
+__le64 *irdma_qp_get_next_send_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx,
+				   u16 quanta, u32 total_size,
+				   struct irdma_post_sq_info *info);
+__le64 *irdma_qp_get_next_recv_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx);
+enum irdma_status_code irdma_cq_uk_init(struct irdma_cq_uk *cq,
+					struct irdma_cq_uk_init_info *info);
+enum irdma_status_code irdma_qp_uk_init(struct irdma_qp_uk *qp,
+					struct irdma_qp_uk_init_info *info);
+void irdma_clean_cq(void *q, struct irdma_cq_uk *cq);
+enum irdma_status_code irdma_nop(struct irdma_qp_uk *qp, u64 wr_id,
+				 bool signaled, bool post_sq);
+enum irdma_status_code irdma_fragcnt_to_quanta_sq(u32 frag_cnt, u16 *quanta);
+enum irdma_status_code irdma_fragcnt_to_wqesize_rq(u32 frag_cnt, u16 *wqe_size);
+void irdma_get_wqe_shift(struct irdma_uk_attrs *uk_attrs, u32 sge,
+			 u32 inline_data, u8 *shift);
+enum irdma_status_code irdma_get_sqdepth(struct irdma_uk_attrs *uk_attrs,
+					 u32 sq_size, u8 shift, u32 *wqdepth);
+enum irdma_status_code irdma_get_rqdepth(struct irdma_uk_attrs *uk_attrs,
+					 u32 rq_size, u8 shift, u32 *wqdepth);
+void irdma_qp_push_wqe(struct irdma_qp_uk *qp, __le64 *wqe, u16 quanta,
+		       u32 wqe_idx, bool post_sq);
+void irdma_clr_wqes(struct irdma_qp_uk *qp, u32 qp_wqe_idx);
+#endif /* IRDMA_USER_H */
-- 
2.25.2

