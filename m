Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBEC1AE36D
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgDQRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:30122 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbgDQRNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:09 -0400
IronPort-SDR: sHx4NHm+O4nwZO1E7bLw/HtPu1b7VQkbRtW9l5vz4Oms69PvSbysn9NSzZ6m84xUaf7bCvS9hT
 4sv4gxeBNsvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:55 -0700
IronPort-SDR: ZyMCtjQxxuNOkGNykXc7y2Issqicu68uc+lVugp5R5AfSbE7xRWGiW4b8suZq95mO5+yMJ1ZpE
 FoMO2PlJYwFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383713"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 05/16] RDMA/irdma: Add privileged UDA queue implementation
Date:   Fri, 17 Apr 2020 10:12:40 -0700
Message-Id: <20200417171251.1533371-6-jeffrey.t.kirsher@intel.com>
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

Implement privileged UDA queues to handle iWARP connection
packets and receive exceptions.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/puda.c | 1690 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/puda.h |  186 +++
 2 files changed, 1876 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/puda.c
 create mode 100644 drivers/infiniband/hw/irdma/puda.h

diff --git a/drivers/infiniband/hw/irdma/puda.c b/drivers/infiniband/hw/irdma/puda.c
new file mode 100644
index 000000000000..c091080dda2b
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/puda.c
@@ -0,0 +1,1690 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+#include "puda.h"
+#include "ws.h"
+
+static void irdma_ieq_receive(struct irdma_sc_vsi *vsi,
+			      struct irdma_puda_buf *buf);
+static void irdma_ieq_tx_compl(struct irdma_sc_vsi *vsi, void *sqwrid);
+static void irdma_ilq_putback_rcvbuf(struct irdma_sc_qp *qp, u32 wqe_idx);
+/**
+ * irdma_puda_get_listbuf - get buffer from puda list
+ * @list: list to use for buffers (ILQ or IEQ)
+ */
+static struct irdma_puda_buf *irdma_puda_get_listbuf(struct list_head *list)
+{
+	struct irdma_puda_buf *buf = NULL;
+
+	if (!list_empty(list)) {
+		buf = (struct irdma_puda_buf *)list->next;
+		list_del((struct list_head *)&buf->list);
+	}
+
+	return buf;
+}
+
+/**
+ * irdma_puda_get_bufpool - return buffer from resource
+ * @rsrc: resource to use for buffer
+ */
+struct irdma_puda_buf *irdma_puda_get_bufpool(struct irdma_puda_rsrc *rsrc)
+{
+	struct irdma_puda_buf *buf = NULL;
+	struct list_head *list = &rsrc->bufpool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rsrc->bufpool_lock, flags);
+	buf = irdma_puda_get_listbuf(list);
+	if (buf) {
+		rsrc->avail_buf_count--;
+		buf->vsi = rsrc->vsi;
+	} else {
+		rsrc->stats_buf_alloc_fail++;
+	}
+	spin_unlock_irqrestore(&rsrc->bufpool_lock, flags);
+
+	return buf;
+}
+
+/**
+ * irdma_puda_ret_bufpool - return buffer to rsrc list
+ * @rsrc: resource to use for buffer
+ * @buf: buffer to return to resource
+ */
+void irdma_puda_ret_bufpool(struct irdma_puda_rsrc *rsrc,
+			    struct irdma_puda_buf *buf)
+{
+	unsigned long flags;
+
+	buf->do_lpb = false;
+	spin_lock_irqsave(&rsrc->bufpool_lock, flags);
+	list_add(&buf->list, &rsrc->bufpool);
+	spin_unlock_irqrestore(&rsrc->bufpool_lock, flags);
+	rsrc->avail_buf_count++;
+}
+
+/**
+ * irdma_puda_post_recvbuf - set wqe for rcv buffer
+ * @rsrc: resource ptr
+ * @wqe_idx: wqe index to use
+ * @buf: puda buffer for rcv q
+ * @initial: flag if during init time
+ */
+static void irdma_puda_post_recvbuf(struct irdma_puda_rsrc *rsrc, u32 wqe_idx,
+				    struct irdma_puda_buf *buf, bool initial)
+{
+	__le64 *wqe;
+	struct irdma_sc_qp *qp = &rsrc->qp;
+	u64 offset24 = 0;
+
+	qp->qp_uk.rq_wrid_array[wqe_idx] = (uintptr_t)buf;
+	wqe = qp->qp_uk.rq_base[wqe_idx].elem;
+	if (!initial)
+		get_64bit_val(wqe, 24, &offset24);
+
+	offset24 = (offset24) ? 0 : LS_64(1, IRDMAQPSQ_VALID);
+
+	set_64bit_val(wqe, 16, 0);
+	set_64bit_val(wqe, 0, buf->mem.pa);
+	if (qp->qp_uk.uk_attrs->hw_rev == IRDMA_GEN_1) {
+		set_64bit_val(wqe, 8,
+			      LS_64(buf->mem.size, IRDMAQPSQ_GEN1_FRAG_LEN));
+	} else {
+		set_64bit_val(wqe, 8,
+			      LS_64(buf->mem.size,
+				    IRDMAQPSQ_FRAG_LEN) | (offset24 & IRDMAQPSQ_VALID_M));
+	}
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, offset24);
+}
+
+/**
+ * irdma_puda_replenish_rq - post rcv buffers
+ * @rsrc: resource to use for buffer
+ * @initial: flag if during init time
+ */
+static enum irdma_status_code
+irdma_puda_replenish_rq(struct irdma_puda_rsrc *rsrc, bool initial)
+{
+	u32 i;
+	u32 invalid_cnt = rsrc->rxq_invalid_cnt;
+	struct irdma_puda_buf *buf = NULL;
+
+	for (i = 0; i < invalid_cnt; i++) {
+		buf = irdma_puda_get_bufpool(rsrc);
+		if (!buf)
+			return IRDMA_ERR_list_empty;
+		irdma_puda_post_recvbuf(rsrc, rsrc->rx_wqe_idx, buf, initial);
+		rsrc->rx_wqe_idx = ((rsrc->rx_wqe_idx + 1) % rsrc->rq_size);
+		rsrc->rxq_invalid_cnt--;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_puda_alloc_buf - allocate mem for buffer
+ * @dev: iwarp device
+ * @len: length of buffer
+ */
+static struct irdma_puda_buf *irdma_puda_alloc_buf(struct irdma_sc_dev *dev,
+						   u32 len)
+{
+	struct irdma_puda_buf *buf = NULL;
+	struct irdma_virt_mem buf_mem;
+
+	buf_mem.size = sizeof(struct irdma_puda_buf);
+	buf_mem.va = kzalloc(buf_mem.size, GFP_ATOMIC);
+	if (!buf_mem.va)
+		return NULL;
+
+	buf = buf_mem.va;
+	buf->mem.size = ALIGN(len, 1);
+	buf->mem.va = dma_alloc_coherent(hw_to_dev(dev->hw), buf->mem.size,
+					 &buf->mem.pa, GFP_KERNEL);
+	if (!buf->mem.va) {
+		kfree(buf_mem.va);
+		return NULL;
+	}
+
+	buf->buf_mem.va = buf_mem.va;
+	buf->buf_mem.size = buf_mem.size;
+
+	return buf;
+}
+
+/**
+ * irdma_puda_dele_buf - delete buffer back to system
+ * @dev: iwarp device
+ * @buf: buffer to free
+ */
+static void irdma_puda_dele_buf(struct irdma_sc_dev *dev,
+				struct irdma_puda_buf *buf)
+{
+	dma_free_coherent(hw_to_dev(dev->hw), buf->mem.size, buf->mem.va,
+			  buf->mem.pa);
+	buf->mem.va = NULL;
+	kfree(buf->buf_mem.va);
+}
+
+/**
+ * irdma_puda_get_next_send_wqe - return next wqe for processing
+ * @qp: puda qp for wqe
+ * @wqe_idx: wqe index for caller
+ */
+static __le64 *irdma_puda_get_next_send_wqe(struct irdma_qp_uk *qp,
+					    u32 *wqe_idx)
+{
+	__le64 *wqe = NULL;
+	enum irdma_status_code ret_code = 0;
+
+	*wqe_idx = IRDMA_RING_CURRENT_HEAD(qp->sq_ring);
+	if (!*wqe_idx)
+		qp->swqe_polarity = !qp->swqe_polarity;
+	IRDMA_RING_MOVE_HEAD(qp->sq_ring, ret_code);
+	if (ret_code)
+		return wqe;
+
+	wqe = qp->sq_base[*wqe_idx].elem;
+
+	return wqe;
+}
+
+/**
+ * irdma_puda_poll_info - poll cq for completion
+ * @cq: cq for poll
+ * @info: info return for successful completion
+ */
+static enum irdma_status_code
+irdma_puda_poll_info(struct irdma_sc_cq *cq, struct irdma_puda_cmpl_info *info)
+{
+	struct irdma_cq_uk *cq_uk = &cq->cq_uk;
+	u64 qword0, qword2, qword3, qword6;
+	__le64 *cqe;
+	__le64 *ext_cqe = NULL;
+	u64 qword7 = 0;
+	u64 comp_ctx;
+	bool valid_bit;
+	bool ext_valid = 0;
+	u32 major_err, minor_err;
+	u32 peek_head;
+	bool error;
+	u8 polarity;
+
+	cqe = IRDMA_GET_CURRENT_CQ_ELEM(&cq->cq_uk);
+	get_64bit_val(cqe, 24, &qword3);
+	valid_bit = (bool)RS_64(qword3, IRDMA_CQ_VALID);
+	if (valid_bit != cq_uk->polarity)
+		return IRDMA_ERR_Q_EMPTY;
+
+	if (cq->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1)
+		ext_valid = (bool)RS_64(qword3, IRDMA_CQ_EXTCQE);
+
+	if (ext_valid) {
+		peek_head = (cq_uk->cq_ring.head + 1) % cq_uk->cq_ring.size;
+		ext_cqe = cq_uk->cq_base[peek_head].buf;
+		get_64bit_val(ext_cqe, 24, &qword7);
+		polarity = (u8)RS_64(qword7, IRDMA_CQ_VALID);
+		if (!peek_head)
+			polarity ^= 1;
+		if (polarity != cq_uk->polarity)
+			return IRDMA_ERR_Q_EMPTY;
+
+		IRDMA_RING_MOVE_HEAD_NOCHECK(cq_uk->cq_ring);
+		if (!IRDMA_RING_CURRENT_HEAD(cq_uk->cq_ring))
+			cq_uk->polarity = !cq_uk->polarity;
+		/* update cq tail in cq shadow memory also */
+		IRDMA_RING_MOVE_TAIL(cq_uk->cq_ring);
+	}
+
+	irdma_debug_buf(cq->dev, IRDMA_DEBUG_PUDA, "PUDA CQE", cqe, 32);
+	if (ext_valid)
+		irdma_debug_buf(cq->dev, IRDMA_DEBUG_PUDA, "PUDA EXT-CQE",
+				ext_cqe, 32);
+
+	error = (bool)RS_64(qword3, IRDMA_CQ_ERROR);
+	if (error) {
+		dev_dbg(rfdev_to_dev(cq->dev), "PUDA: receive error\n");
+		major_err = (u32)(RS_64(qword3, IRDMA_CQ_MAJERR));
+		minor_err = (u32)(RS_64(qword3, IRDMA_CQ_MINERR));
+		info->compl_error = major_err << 16 | minor_err;
+		return IRDMA_ERR_CQ_COMPL_ERROR;
+	}
+
+	get_64bit_val(cqe, 0, &qword0);
+	get_64bit_val(cqe, 16, &qword2);
+
+	info->q_type = (u8)RS_64(qword3, IRDMA_CQ_SQ);
+	info->qp_id = (u32)RS_64(qword2, IRDMACQ_QPID);
+	if (cq->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1)
+		info->ipv4 = (bool)RS_64(qword3, IRDMACQ_IPV4);
+
+	get_64bit_val(cqe, 8, &comp_ctx);
+	info->qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
+	info->wqe_idx = (u32)RS_64(qword3, IRDMA_CQ_WQEIDX);
+
+	if (info->q_type == IRDMA_CQE_QTYPE_RQ) {
+		if (ext_valid) {
+			info->vlan_valid = (bool)RS_64(qword7, IRDMA_CQ_UDVLANVALID);
+			if (info->vlan_valid) {
+				get_64bit_val(ext_cqe, 16, &qword6);
+				info->vlan = (u16)RS_64(qword6, IRDMA_CQ_UDVLAN);
+			}
+			info->smac_valid = (bool)RS_64(qword7, IRDMA_CQ_UDSMACVALID);
+			if (info->smac_valid) {
+				get_64bit_val(ext_cqe, 16, &qword6);
+				info->smac[0] = (u8)((qword6 >> 40) & 0xFF);
+				info->smac[1] = (u8)((qword6 >> 32) & 0xFF);
+				info->smac[2] = (u8)((qword6 >> 24) & 0xFF);
+				info->smac[3] = (u8)((qword6 >> 16) & 0xFF);
+				info->smac[4] = (u8)((qword6 >> 8) & 0xFF);
+				info->smac[5] = (u8)(qword6 & 0xFF);
+			}
+		}
+
+		if (cq->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1) {
+			info->vlan_valid = (bool)RS_64(qword3, IRDMA_VLAN_TAG_VALID);
+			info->l4proto = (u8)RS_64(qword2, IRDMA_UDA_L4PROTO);
+			info->l3proto = (u8)RS_64(qword2, IRDMA_UDA_L3PROTO);
+		}
+
+		info->payload_len = (u32)RS_64(qword0, IRDMACQ_PAYLDLEN);
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_puda_poll_completion - processes completion for cq
+ * @dev: iwarp device
+ * @cq: cq getting interrupt
+ * @compl_err: return any completion err
+ */
+enum irdma_status_code irdma_puda_poll_cmpl(struct irdma_sc_dev *dev,
+					    struct irdma_sc_cq *cq,
+					    u32 *compl_err)
+{
+	struct irdma_qp_uk *qp;
+	struct irdma_cq_uk *cq_uk = &cq->cq_uk;
+	struct irdma_puda_cmpl_info info = {};
+	enum irdma_status_code ret = 0;
+	struct irdma_puda_buf *buf;
+	struct irdma_puda_rsrc *rsrc;
+	void *sqwrid;
+	u8 cq_type = cq->cq_type;
+	unsigned long flags;
+
+	if (cq_type == IRDMA_CQ_TYPE_ILQ || cq_type == IRDMA_CQ_TYPE_IEQ) {
+		rsrc = (cq_type == IRDMA_CQ_TYPE_ILQ) ? cq->vsi->ilq :
+							cq->vsi->ieq;
+	} else {
+		dev_dbg(rfdev_to_dev(dev), "PUDA: qp_type error\n");
+		return IRDMA_ERR_BAD_PTR;
+	}
+
+	ret = irdma_puda_poll_info(cq, &info);
+	*compl_err = info.compl_error;
+	if (ret == IRDMA_ERR_Q_EMPTY)
+		return ret;
+	if (ret)
+		goto done;
+
+	qp = info.qp;
+	if (!qp || !rsrc) {
+		ret = IRDMA_ERR_BAD_PTR;
+		goto done;
+	}
+
+	if (qp->qp_id != rsrc->qp_id) {
+		ret = IRDMA_ERR_BAD_PTR;
+		goto done;
+	}
+
+	if (info.q_type == IRDMA_CQE_QTYPE_RQ) {
+		buf = (struct irdma_puda_buf *)(uintptr_t)
+			      qp->rq_wrid_array[info.wqe_idx];
+		/* Get all the tcpip information in the buf header */
+		ret = irdma_puda_get_tcpip_info(&info, buf);
+		if (ret) {
+			rsrc->stats_rcvd_pkt_err++;
+			if (cq_type == IRDMA_CQ_TYPE_ILQ) {
+				irdma_ilq_putback_rcvbuf(&rsrc->qp,
+							 info.wqe_idx);
+			} else {
+				irdma_puda_ret_bufpool(rsrc, buf);
+				irdma_puda_replenish_rq(rsrc, false);
+			}
+			goto done;
+		}
+
+		rsrc->stats_pkt_rcvd++;
+		rsrc->compl_rxwqe_idx = info.wqe_idx;
+		dev_dbg(rfdev_to_dev(dev), "PUDA: RQ completion\n");
+		rsrc->receive(rsrc->vsi, buf);
+		if (cq_type == IRDMA_CQ_TYPE_ILQ)
+			irdma_ilq_putback_rcvbuf(&rsrc->qp, info.wqe_idx);
+		else
+			irdma_puda_replenish_rq(rsrc, false);
+
+	} else {
+		dev_dbg(rfdev_to_dev(dev), "PUDA: SQ completion\n");
+		sqwrid = (void *)(uintptr_t)qp->sq_wrtrk_array[info.wqe_idx].wrid;
+		IRDMA_RING_SET_TAIL(qp->sq_ring, info.wqe_idx);
+		rsrc->xmit_complete(rsrc->vsi, sqwrid);
+		spin_lock_irqsave(&rsrc->bufpool_lock, flags);
+		rsrc->tx_wqe_avail_cnt++;
+		spin_unlock_irqrestore(&rsrc->bufpool_lock, flags);
+		if (!list_empty(&rsrc->txpend))
+			irdma_puda_send_buf(rsrc, NULL);
+	}
+
+done:
+	IRDMA_RING_MOVE_HEAD_NOCHECK(cq_uk->cq_ring);
+	if (!IRDMA_RING_CURRENT_HEAD(cq_uk->cq_ring))
+		cq_uk->polarity = !cq_uk->polarity;
+	/* update cq tail in cq shadow memory also */
+	IRDMA_RING_MOVE_TAIL(cq_uk->cq_ring);
+	set_64bit_val(cq_uk->shadow_area, 0,
+		      IRDMA_RING_CURRENT_HEAD(cq_uk->cq_ring));
+
+	return ret;
+}
+
+/**
+ * irdma_puda_send - complete send wqe for transmit
+ * @qp: puda qp for send
+ * @info: buffer information for transmit
+ */
+enum irdma_status_code irdma_puda_send(struct irdma_sc_qp *qp,
+				       struct irdma_puda_send_info *info)
+{
+	__le64 *wqe;
+	u32 iplen, l4len;
+	u64 hdr[2];
+	u32 wqe_idx;
+	u8 iipt;
+
+	/* number of 32 bits DWORDS in header */
+	l4len = info->tcplen >> 2;
+	if (info->ipv4) {
+		iipt = 3;
+		iplen = 5;
+	} else {
+		iipt = 1;
+		iplen = 10;
+	}
+
+	wqe = irdma_puda_get_next_send_wqe(&qp->qp_uk, &wqe_idx);
+	if (!wqe)
+		return IRDMA_ERR_QP_TOOMANY_WRS_POSTED;
+
+	qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid = (uintptr_t)info->scratch;
+	/* Third line of WQE descriptor */
+	/* maclen is in words */
+
+	if (qp->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		hdr[0] = 0; /* Dest_QPN and Dest_QKey only for UD */
+		hdr[1] = LS_64(IRDMA_OP_TYPE_SEND, IRDMA_UDA_QPSQ_OPCODE) |
+			 LS_64(l4len, IRDMA_UDA_QPSQ_L4LEN) |
+			 LS_64(info->ah_id, IRDMAQPSQ_AHID) |
+			 LS_64(1, IRDMA_UDA_QPSQ_SIGCOMPL) |
+			 LS_64(qp->qp_uk.swqe_polarity, IRDMA_UDA_QPSQ_VALID);
+
+		/* Forth line of WQE descriptor */
+
+		set_64bit_val(wqe, 0, info->paddr);
+		set_64bit_val(wqe, 8,
+			      LS_64(info->len, IRDMAQPSQ_FRAG_LEN) |
+			      LS_64(qp->qp_uk.swqe_polarity, IRDMA_UDA_QPSQ_VALID));
+	} else {
+		hdr[0] = LS_64((info->maclen >> 1), IRDMA_UDA_QPSQ_MACLEN) |
+			 LS_64(iplen, IRDMA_UDA_QPSQ_IPLEN) |
+			 LS_64(1, IRDMA_UDA_QPSQ_L4T) |
+			 LS_64(iipt, IRDMA_UDA_QPSQ_IIPT) |
+			 LS_64(l4len, IRDMA_GEN1_UDA_QPSQ_L4LEN);
+
+		hdr[1] = LS_64(IRDMA_OP_TYPE_SEND, IRDMA_UDA_QPSQ_OPCODE) |
+			 LS_64(1, IRDMA_UDA_QPSQ_SIGCOMPL) |
+			 LS_64(info->do_lpb, IRDMA_UDA_QPSQ_DOLOOPBACK) |
+			 LS_64(qp->qp_uk.swqe_polarity, IRDMA_UDA_QPSQ_VALID);
+
+		/* Forth line of WQE descriptor */
+
+		set_64bit_val(wqe, 0, info->paddr);
+		set_64bit_val(wqe, 8,
+			      LS_64(info->len, IRDMAQPSQ_GEN1_FRAG_LEN));
+	}
+
+	set_64bit_val(wqe, 16, hdr[0]);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr[1]);
+
+	irdma_debug_buf(qp->dev, IRDMA_DEBUG_PUDA, "PUDA SEND WQE", wqe, 32);
+	irdma_qp_post_wr(&qp->qp_uk);
+	return 0;
+}
+
+/**
+ * irdma_puda_send_buf - transmit puda buffer
+ * @rsrc: resource to use for buffer
+ * @buf: puda buffer to transmit
+ */
+void irdma_puda_send_buf(struct irdma_puda_rsrc *rsrc,
+			 struct irdma_puda_buf *buf)
+{
+	struct irdma_puda_send_info info;
+	enum irdma_status_code ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rsrc->bufpool_lock, flags);
+	/* if no wqe available or not from a completion and we have
+	 * pending buffers, we must queue new buffer
+	 */
+	if (!rsrc->tx_wqe_avail_cnt || (buf && !list_empty(&rsrc->txpend))) {
+		list_add_tail(&buf->list, &rsrc->txpend);
+		spin_unlock_irqrestore(&rsrc->bufpool_lock, flags);
+		rsrc->stats_sent_pkt_q++;
+		if (rsrc->type == IRDMA_PUDA_RSRC_TYPE_ILQ)
+			dev_dbg(rfdev_to_dev(rsrc->dev),
+				"PUDA: adding to txpend\n");
+		return;
+	}
+	rsrc->tx_wqe_avail_cnt--;
+	/* if we are coming from a completion and have pending buffers
+	 * then Get one from pending list
+	 */
+	if (!buf) {
+		buf = irdma_puda_get_listbuf(&rsrc->txpend);
+		if (!buf)
+			goto done;
+	}
+
+	info.scratch = buf;
+	info.paddr = buf->mem.pa;
+	info.len = buf->totallen;
+	info.tcplen = buf->tcphlen;
+	info.ipv4 = buf->ipv4;
+
+	if (rsrc->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		info.ah_id = buf->ah_id;
+	} else {
+		info.maclen = buf->maclen;
+		info.do_lpb = buf->do_lpb;
+	}
+
+	ret = irdma_puda_send(&rsrc->qp, &info);
+	if (ret) {
+		rsrc->tx_wqe_avail_cnt++;
+		rsrc->stats_sent_pkt_q++;
+		list_add(&buf->list, &rsrc->txpend);
+		if (rsrc->type == IRDMA_PUDA_RSRC_TYPE_ILQ)
+			dev_dbg(rfdev_to_dev(rsrc->dev),
+				"PUDA: adding to puda_send\n");
+	} else {
+		rsrc->stats_pkt_sent++;
+	}
+done:
+	spin_unlock_irqrestore(&rsrc->bufpool_lock, flags);
+}
+
+/**
+ * irdma_puda_qp_setctx - during init, set qp's context
+ * @rsrc: qp's resource
+ */
+static void irdma_puda_qp_setctx(struct irdma_puda_rsrc *rsrc)
+{
+	struct irdma_sc_qp *qp = &rsrc->qp;
+	__le64 *qp_ctx = qp->hw_host_ctx;
+
+	set_64bit_val(qp_ctx, 8, qp->sq_pa);
+	set_64bit_val(qp_ctx, 16, qp->rq_pa);
+	set_64bit_val(qp_ctx, 24,
+		      LS_64(qp->hw_rq_size, IRDMAQPC_RQSIZE) |
+		      LS_64(qp->hw_sq_size, IRDMAQPC_SQSIZE));
+	set_64bit_val(qp_ctx, 48,
+		      LS_64(rsrc->buf_size, IRDMAQPC_SNDMSS));
+	set_64bit_val(qp_ctx, 56, 0);
+	if (qp->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		set_64bit_val(qp_ctx, 64, 1);
+	set_64bit_val(qp_ctx, 136,
+		      LS_64(rsrc->cq_id, IRDMAQPC_TXCQNUM) |
+		      LS_64(rsrc->cq_id, IRDMAQPC_RXCQNUM));
+	set_64bit_val(qp_ctx, 144,
+		      LS_64(rsrc->stats_idx, IRDMAQPC_STAT_INDEX));
+	set_64bit_val(qp_ctx, 160,
+		      LS_64(1, IRDMAQPC_PRIVEN) |
+		      LS_64(rsrc->stats_idx_valid, IRDMAQPC_USESTATSINSTANCE));
+	set_64bit_val(qp_ctx, 168,
+		      LS_64((uintptr_t)qp, IRDMAQPC_QPCOMPCTX));
+	set_64bit_val(qp_ctx, 176,
+		      LS_64(qp->sq_tph_val, IRDMAQPC_SQTPHVAL) |
+		      LS_64(qp->rq_tph_val, IRDMAQPC_RQTPHVAL) |
+		      LS_64(qp->qs_handle, IRDMAQPC_QSHANDLE));
+
+	irdma_debug_buf(rsrc->dev, IRDMA_DEBUG_PUDA, "PUDA QP CONTEXT", qp_ctx,
+			IRDMA_QP_CTX_SIZE);
+}
+
+/**
+ * irdma_puda_qp_wqe - setup wqe for qp create
+ * @dev: Device
+ * @qp: Resource qp
+ */
+static enum irdma_status_code irdma_puda_qp_wqe(struct irdma_sc_dev *dev,
+						struct irdma_sc_qp *qp)
+{
+	struct irdma_sc_cqp *cqp;
+	__le64 *wqe;
+	u64 hdr;
+	struct irdma_ccq_cqe_info compl_info;
+	enum irdma_status_code status = 0;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, 0);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 16, qp->hw_host_ctx_pa);
+	set_64bit_val(wqe, 40, qp->shadow_area_pa);
+
+	hdr = qp->qp_uk.qp_id |
+	      LS_64(IRDMA_CQP_OP_CREATE_QP, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(IRDMA_QP_TYPE_UDA, IRDMA_CQPSQ_QP_QPTYPE) |
+	      LS_64(1, IRDMA_CQPSQ_QP_CQNUMVALID) |
+	      LS_64(2, IRDMA_CQPSQ_QP_NEXTIWSTATE) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(cqp->dev, IRDMA_DEBUG_PUDA, "PUDA QP CREATE", wqe, 40);
+	irdma_sc_cqp_post_sq(cqp);
+	status = dev->cqp_ops->poll_for_cqp_op_done(dev->cqp,
+						    IRDMA_CQP_OP_CREATE_QP,
+						    &compl_info);
+
+	return status;
+}
+
+/**
+ * irdma_puda_qp_create - create qp for resource
+ * @rsrc: resource to use for buffer
+ */
+static enum irdma_status_code irdma_puda_qp_create(struct irdma_puda_rsrc *rsrc)
+{
+	struct irdma_sc_qp *qp = &rsrc->qp;
+	struct irdma_qp_uk *ukqp = &qp->qp_uk;
+	enum irdma_status_code ret = 0;
+	u32 sq_size, rq_size;
+	struct irdma_dma_mem *mem;
+
+	sq_size = rsrc->sq_size * IRDMA_QP_WQE_MIN_SIZE;
+	rq_size = rsrc->rq_size * IRDMA_QP_WQE_MIN_SIZE;
+	rsrc->qpmem.size = ALIGN((sq_size + rq_size + (IRDMA_SHADOW_AREA_SIZE << 3) + IRDMA_QP_CTX_SIZE),
+				 IRDMA_HW_PAGE_SIZE);
+	rsrc->qpmem.va = dma_alloc_coherent(hw_to_dev(rsrc->dev->hw),
+					    rsrc->qpmem.size, &rsrc->qpmem.pa,
+					    GFP_KERNEL);
+	if (!rsrc->qpmem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	mem = &rsrc->qpmem;
+	memset(mem->va, 0, rsrc->qpmem.size);
+	qp->hw_sq_size = irdma_get_encoded_wqe_size(rsrc->sq_size, false);
+	qp->hw_rq_size = irdma_get_encoded_wqe_size(rsrc->rq_size, false);
+	qp->pd = &rsrc->sc_pd;
+	qp->qp_type = IRDMA_QP_TYPE_UDA;
+	qp->dev = rsrc->dev;
+	qp->qp_uk.back_qp = rsrc;
+	qp->sq_pa = mem->pa;
+	qp->rq_pa = qp->sq_pa + sq_size;
+	qp->vsi = rsrc->vsi;
+	ukqp->sq_base = mem->va;
+	ukqp->rq_base = &ukqp->sq_base[rsrc->sq_size];
+	ukqp->shadow_area = ukqp->rq_base[rsrc->rq_size].elem;
+	ukqp->uk_attrs = &qp->dev->hw_attrs.uk_attrs;
+	qp->shadow_area_pa = qp->rq_pa + rq_size;
+	qp->hw_host_ctx = ukqp->shadow_area + IRDMA_SHADOW_AREA_SIZE;
+	qp->hw_host_ctx_pa = qp->shadow_area_pa + (IRDMA_SHADOW_AREA_SIZE << 3);
+	qp->push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
+	ukqp->qp_id = rsrc->qp_id;
+	ukqp->sq_wrtrk_array = rsrc->sq_wrtrk_array;
+	ukqp->rq_wrid_array = rsrc->rq_wrid_array;
+	ukqp->sq_size = rsrc->sq_size;
+	ukqp->rq_size = rsrc->rq_size;
+
+	IRDMA_RING_INIT(ukqp->sq_ring, ukqp->sq_size);
+	IRDMA_RING_INIT(ukqp->initial_ring, ukqp->sq_size);
+	IRDMA_RING_INIT(ukqp->rq_ring, ukqp->rq_size);
+	ukqp->wqe_alloc_db = qp->pd->dev->wqe_alloc_db;
+
+	ret = rsrc->dev->ws_add(qp->vsi, qp->user_pri);
+	if (ret) {
+		dma_free_coherent(hw_to_dev(rsrc->dev->hw), rsrc->qpmem.size,
+				  rsrc->qpmem.va, rsrc->qpmem.pa);
+		rsrc->qpmem.va = NULL;
+		return ret;
+	}
+
+	irdma_qp_add_qos(qp);
+	irdma_puda_qp_setctx(rsrc);
+
+	if (rsrc->dev->ceq_valid)
+		ret = irdma_cqp_qp_create_cmd(rsrc->dev, qp);
+	else
+		ret = irdma_puda_qp_wqe(rsrc->dev, qp);
+	if (ret) {
+		irdma_qp_rem_qos(qp);
+		rsrc->dev->ws_remove(qp->vsi, qp->user_pri);
+		dma_free_coherent(hw_to_dev(rsrc->dev->hw), rsrc->qpmem.size,
+				  rsrc->qpmem.va, rsrc->qpmem.pa);
+		rsrc->qpmem.va = NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * irdma_puda_cq_wqe - setup wqe for CQ create
+ * @dev: Device
+ * @cq: resource for cq
+ */
+static enum irdma_status_code irdma_puda_cq_wqe(struct irdma_sc_dev *dev,
+						struct irdma_sc_cq *cq)
+{
+	__le64 *wqe;
+	struct irdma_sc_cqp *cqp;
+	u64 hdr;
+	struct irdma_ccq_cqe_info compl_info;
+	enum irdma_status_code status = 0;
+
+	cqp = dev->cqp;
+	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, 0);
+	if (!wqe)
+		return IRDMA_ERR_RING_FULL;
+
+	set_64bit_val(wqe, 0, cq->cq_uk.cq_size);
+	set_64bit_val(wqe, 8, RS_64_1(cq, 1));
+	set_64bit_val(wqe, 16,
+		      LS_64(cq->shadow_read_threshold,
+			    IRDMA_CQPSQ_CQ_SHADOW_READ_THRESHOLD));
+	set_64bit_val(wqe, 32, cq->cq_pa);
+	set_64bit_val(wqe, 40, cq->shadow_area_pa);
+	set_64bit_val(wqe, 56,
+		      LS_64(cq->tph_val, IRDMA_CQPSQ_TPHVAL) |
+		      LS_64(cq->vsi->vsi_idx, IRDMA_CQPSQ_VSIIDX));
+
+	hdr = cq->cq_uk.cq_id |
+	      LS_64(IRDMA_CQP_OP_CREATE_CQ, IRDMA_CQPSQ_OPCODE) |
+	      LS_64(1, IRDMA_CQPSQ_CQ_CHKOVERFLOW) |
+	      LS_64(1, IRDMA_CQPSQ_CQ_ENCEQEMASK) |
+	      LS_64(1, IRDMA_CQPSQ_CQ_CEQIDVALID) |
+	      LS_64(cqp->polarity, IRDMA_CQPSQ_WQEVALID);
+	dma_wmb(); /* make sure WQE is written before valid bit is set */
+
+	set_64bit_val(wqe, 24, hdr);
+
+	irdma_debug_buf(dev, IRDMA_DEBUG_PUDA, "PUDA CREATE CQ", wqe,
+			IRDMA_CQP_WQE_SIZE * 8);
+	irdma_sc_cqp_post_sq(dev->cqp);
+	status = dev->cqp_ops->poll_for_cqp_op_done(dev->cqp,
+						    IRDMA_CQP_OP_CREATE_CQ,
+						    &compl_info);
+
+	return status;
+}
+
+/**
+ * irdma_puda_cq_create - create cq for resource
+ * @rsrc: resource for which cq to create
+ */
+static enum irdma_status_code irdma_puda_cq_create(struct irdma_puda_rsrc *rsrc)
+{
+	struct irdma_sc_dev *dev = rsrc->dev;
+	struct irdma_sc_cq *cq = &rsrc->cq;
+	enum irdma_status_code ret = 0;
+	u32 cqsize;
+	struct irdma_dma_mem *mem;
+	struct irdma_cq_init_info info = {};
+	struct irdma_cq_uk_init_info *init_info = &info.cq_uk_init_info;
+
+	cq->vsi = rsrc->vsi;
+	cqsize = rsrc->cq_size * (sizeof(struct irdma_cqe));
+	rsrc->cqmem.size = ALIGN(cqsize + sizeof(struct irdma_cq_shadow_area),
+				 IRDMA_CQ0_ALIGNMENT);
+	rsrc->cqmem.va = dma_alloc_coherent(hw_to_dev(dev->hw),
+					    rsrc->cqmem.size, &rsrc->cqmem.pa,
+					    GFP_KERNEL);
+	if (!rsrc->cqmem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	mem = &rsrc->cqmem;
+	info.dev = dev;
+	info.type = (rsrc->type == IRDMA_PUDA_RSRC_TYPE_ILQ) ?
+		    IRDMA_CQ_TYPE_ILQ : IRDMA_CQ_TYPE_IEQ;
+	info.shadow_read_threshold = rsrc->cq_size >> 2;
+	info.cq_base_pa = mem->pa;
+	info.shadow_area_pa = mem->pa + cqsize;
+	init_info->cq_base = mem->va;
+	init_info->shadow_area = (__le64 *)((u8 *)mem->va + cqsize);
+	init_info->cq_size = rsrc->cq_size;
+	init_info->cq_id = rsrc->cq_id;
+	info.ceqe_mask = true;
+	info.ceq_id_valid = true;
+	info.vsi = rsrc->vsi;
+
+	ret = dev->iw_priv_cq_ops->cq_init(cq, &info);
+	if (ret)
+		goto error;
+
+	if (rsrc->dev->ceq_valid)
+		ret = irdma_cqp_cq_create_cmd(dev, cq);
+	else
+		ret = irdma_puda_cq_wqe(dev, cq);
+error:
+	if (ret) {
+		dma_free_coherent(hw_to_dev(dev->hw), rsrc->cqmem.size,
+				  rsrc->cqmem.va, rsrc->cqmem.pa);
+		rsrc->cqmem.va = NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * irdma_puda_free_qp - free qp for resource
+ * @rsrc: resource for which qp to free
+ */
+static void irdma_puda_free_qp(struct irdma_puda_rsrc *rsrc)
+{
+	enum irdma_status_code ret;
+	struct irdma_ccq_cqe_info compl_info;
+	struct irdma_sc_dev *dev = rsrc->dev;
+
+	if (rsrc->dev->ceq_valid) {
+		irdma_cqp_qp_destroy_cmd(dev, &rsrc->qp);
+		rsrc->dev->ws_remove(rsrc->qp.vsi, rsrc->qp.user_pri);
+		return;
+	}
+
+	ret = dev->iw_priv_qp_ops->qp_destroy(&rsrc->qp, 0, false, true, true);
+	if (ret)
+		dev_dbg(rfdev_to_dev(dev),
+			"PUDA: error puda qp destroy wqe, status = %d\n", ret);
+	if (!ret) {
+		ret = dev->cqp_ops->poll_for_cqp_op_done(dev->cqp,
+							 IRDMA_CQP_OP_DESTROY_QP,
+							 &compl_info);
+		if (ret)
+			dev_dbg(rfdev_to_dev(dev),
+				"PUDA: error puda qp destroy failed, status = %d\n",
+				ret);
+	}
+
+	rsrc->dev->ws_remove(rsrc->qp.vsi, rsrc->qp.user_pri);
+}
+
+/**
+ * irdma_puda_free_cq - free cq for resource
+ * @rsrc: resource for which cq to free
+ */
+static void irdma_puda_free_cq(struct irdma_puda_rsrc *rsrc)
+{
+	enum irdma_status_code ret;
+	struct irdma_ccq_cqe_info compl_info;
+	struct irdma_sc_dev *dev = rsrc->dev;
+
+	if (rsrc->dev->ceq_valid) {
+		irdma_cqp_cq_destroy_cmd(dev, &rsrc->cq);
+		return;
+	}
+
+	ret = dev->iw_priv_cq_ops->cq_destroy(&rsrc->cq, 0, true);
+	if (ret)
+		dev_dbg(rfdev_to_dev(dev), "PUDA: error ieq cq destroy\n");
+	if (!ret) {
+		ret = dev->cqp_ops->poll_for_cqp_op_done(dev->cqp,
+							 IRDMA_CQP_OP_DESTROY_CQ,
+							 &compl_info);
+		if (ret)
+			dev_dbg(rfdev_to_dev(dev),
+				"PUDA: error ieq qp destroy done\n");
+	}
+}
+
+/**
+ * irdma_puda_dele_rsrc - delete all resources during close
+ * @vsi: VSI structure of device
+ * @type: type of resource to dele
+ * @reset: true if reset chip
+ */
+void irdma_puda_dele_rsrc(struct irdma_sc_vsi *vsi, enum puda_rsrc_type type,
+			  bool reset)
+{
+	struct irdma_sc_dev *dev = vsi->dev;
+	struct irdma_puda_rsrc *rsrc;
+	struct irdma_puda_buf *buf = NULL;
+	struct irdma_puda_buf *nextbuf = NULL;
+	struct irdma_virt_mem *vmem;
+	struct irdma_sc_ceq *ceq;
+
+	ceq = vsi->dev->ceq[0];
+	switch (type) {
+	case IRDMA_PUDA_RSRC_TYPE_ILQ:
+		rsrc = vsi->ilq;
+		vmem = &vsi->ilq_mem;
+		vsi->ilq = NULL;
+		if (ceq && ceq->reg_cq)
+			irdma_sc_remove_cq_ctx(ceq, &rsrc->cq);
+		break;
+	case IRDMA_PUDA_RSRC_TYPE_IEQ:
+		rsrc = vsi->ieq;
+		vmem = &vsi->ieq_mem;
+		vsi->ieq = NULL;
+		if (ceq && ceq->reg_cq)
+			irdma_sc_remove_cq_ctx(ceq, &rsrc->cq);
+		break;
+	default:
+		dev_dbg(rfdev_to_dev(dev),
+			"PUDA: error resource type = 0x%x\n", type);
+		return;
+	}
+
+	switch (rsrc->cmpl) {
+	case PUDA_HASH_CRC_COMPLETE:
+		irdma_free_hash_desc(rsrc->hash_desc);
+		/* fallthrough */
+	case PUDA_QP_CREATED:
+		if (!reset)
+			irdma_puda_free_qp(rsrc);
+		else
+			irdma_qp_rem_qos(&rsrc->qp);
+
+		dma_free_coherent(hw_to_dev(dev->hw), rsrc->qpmem.size,
+				  rsrc->qpmem.va, rsrc->qpmem.pa);
+		rsrc->qpmem.va = NULL;
+		/* fallthrough */
+	case PUDA_CQ_CREATED:
+		if (!reset)
+			irdma_puda_free_cq(rsrc);
+
+		dma_free_coherent(hw_to_dev(dev->hw), rsrc->cqmem.size,
+				  rsrc->cqmem.va, rsrc->cqmem.pa);
+		rsrc->cqmem.va = NULL;
+		break;
+	default:
+		dev_dbg(rfdev_to_dev(rsrc->dev), "PUDA: error no resources\n");
+		break;
+	}
+	/* Free all allocated puda buffers for both tx and rx */
+	buf = rsrc->alloclist;
+	while (buf) {
+		nextbuf = buf->next;
+		irdma_puda_dele_buf(dev, buf);
+		buf = nextbuf;
+		rsrc->alloc_buf_count--;
+	}
+
+	kfree(vmem->va);
+}
+
+/**
+ * irdma_puda_allocbufs - allocate buffers for resource
+ * @rsrc: resource for buffer allocation
+ * @count: number of buffers to create
+ */
+static enum irdma_status_code irdma_puda_allocbufs(struct irdma_puda_rsrc *rsrc,
+						   u32 count)
+{
+	u32 i;
+	struct irdma_puda_buf *buf;
+	struct irdma_puda_buf *nextbuf;
+
+	for (i = 0; i < count; i++) {
+		buf = irdma_puda_alloc_buf(rsrc->dev, rsrc->buf_size);
+		if (!buf) {
+			rsrc->stats_buf_alloc_fail++;
+			return IRDMA_ERR_NO_MEMORY;
+		}
+		irdma_puda_ret_bufpool(rsrc, buf);
+		rsrc->alloc_buf_count++;
+		if (!rsrc->alloclist) {
+			rsrc->alloclist = buf;
+		} else {
+			nextbuf = rsrc->alloclist;
+			rsrc->alloclist = buf;
+			buf->next = nextbuf;
+		}
+	}
+
+	rsrc->avail_buf_count = rsrc->alloc_buf_count;
+
+	return 0;
+}
+
+/**
+ * irdma_puda_create_rsrc - create resource (ilq or ieq)
+ * @vsi: sc VSI struct
+ * @info: resource information
+ */
+enum irdma_status_code irdma_puda_create_rsrc(struct irdma_sc_vsi *vsi,
+					      struct irdma_puda_rsrc_info *info)
+{
+	struct irdma_sc_dev *dev = vsi->dev;
+	enum irdma_status_code ret = 0;
+	struct irdma_puda_rsrc *rsrc;
+	u32 pudasize;
+	u32 sqwridsize, rqwridsize;
+	struct irdma_virt_mem *vmem;
+	struct irdma_sc_ceq *ceq;
+
+	info->count = 1;
+	pudasize = sizeof(struct irdma_puda_rsrc);
+	sqwridsize = info->sq_size * sizeof(struct irdma_sq_uk_wr_trk_info);
+	rqwridsize = info->rq_size * 8;
+	switch (info->type) {
+	case IRDMA_PUDA_RSRC_TYPE_ILQ:
+		vmem = &vsi->ilq_mem;
+		break;
+	case IRDMA_PUDA_RSRC_TYPE_IEQ:
+		vmem = &vsi->ieq_mem;
+		break;
+	default:
+		return IRDMA_NOT_SUPPORTED;
+	}
+	vmem->size = pudasize + sqwridsize + rqwridsize;
+	vmem->va = kzalloc(vmem->size, GFP_ATOMIC);
+	if (!vmem->va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	rsrc = vmem->va;
+	spin_lock_init(&rsrc->bufpool_lock);
+	switch (info->type) {
+	case IRDMA_PUDA_RSRC_TYPE_ILQ:
+		vsi->ilq = vmem->va;
+		vsi->ilq_count = info->count;
+		rsrc->receive = info->receive;
+		rsrc->xmit_complete = info->xmit_complete;
+		break;
+	case IRDMA_PUDA_RSRC_TYPE_IEQ:
+		vsi->ieq_count = info->count;
+		vsi->ieq = vmem->va;
+		rsrc->receive = irdma_ieq_receive;
+		rsrc->xmit_complete = irdma_ieq_tx_compl;
+		break;
+	default:
+		return IRDMA_NOT_SUPPORTED;
+	}
+
+	rsrc->type = info->type;
+	rsrc->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
+			       ((u8 *)vmem->va + pudasize);
+	rsrc->rq_wrid_array = (u64 *)((u8 *)vmem->va + pudasize + sqwridsize);
+	/* Initialize all ieq lists */
+	INIT_LIST_HEAD(&rsrc->bufpool);
+	INIT_LIST_HEAD(&rsrc->txpend);
+
+	rsrc->tx_wqe_avail_cnt = info->sq_size - 1;
+	dev->iw_pd_ops->pd_init(dev, &rsrc->sc_pd, info->pd_id, -1);
+	rsrc->qp_id = info->qp_id;
+	rsrc->cq_id = info->cq_id;
+	rsrc->sq_size = info->sq_size;
+	rsrc->rq_size = info->rq_size;
+	rsrc->cq_size = info->rq_size + info->sq_size;
+	if (dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		if (rsrc->type == IRDMA_PUDA_RSRC_TYPE_ILQ)
+			rsrc->cq_size += info->rq_size;
+	}
+	rsrc->buf_size = info->buf_size;
+	rsrc->dev = dev;
+	rsrc->vsi = vsi;
+	rsrc->stats_idx = info->stats_idx;
+	rsrc->stats_idx_valid = info->stats_idx_valid;
+
+	ret = irdma_puda_cq_create(rsrc);
+	if (!ret) {
+		rsrc->cmpl = PUDA_CQ_CREATED;
+		ret = irdma_puda_qp_create(rsrc);
+	}
+	if (ret) {
+		dev_dbg(rfdev_to_dev(dev),
+			"PUDA: error qp_create type=%d, status=%d\n",
+			rsrc->type, ret);
+		goto error;
+	}
+	rsrc->cmpl = PUDA_QP_CREATED;
+
+	ceq = vsi->dev->ceq[0];
+	if (ceq->reg_cq)
+		ret = irdma_sc_add_cq_ctx(ceq, &rsrc->cq);
+
+	if (ret) {
+		dev_dbg(rfdev_to_dev(dev),
+			"PUDA: error unable to add to cq_ctx\n");
+		goto error;
+	}
+
+	ret = irdma_puda_allocbufs(rsrc, info->tx_buf_cnt + info->rq_size);
+	if (ret) {
+		dev_dbg(rfdev_to_dev(dev), "PUDA: error alloc_buf\n");
+		goto error;
+	}
+
+	rsrc->rxq_invalid_cnt = info->rq_size;
+	ret = irdma_puda_replenish_rq(rsrc, true);
+	if (ret)
+		goto error;
+
+	if (info->type == IRDMA_PUDA_RSRC_TYPE_IEQ) {
+		if (!irdma_init_hash_desc(&rsrc->hash_desc)) {
+			rsrc->check_crc = true;
+			rsrc->cmpl = PUDA_HASH_CRC_COMPLETE;
+			ret = 0;
+		}
+	}
+
+	dev->ccq_ops->ccq_arm(&rsrc->cq);
+	return ret;
+
+error:
+	irdma_puda_dele_rsrc(vsi, info->type, false);
+
+	return ret;
+}
+
+/**
+ * irdma_ilq_putback_rcvbuf - ilq buffer to put back on rq
+ * @qp: ilq's qp resource
+ * @wqe_idx:  wqe index of completed rcvbuf
+ */
+static void irdma_ilq_putback_rcvbuf(struct irdma_sc_qp *qp, u32 wqe_idx)
+{
+	__le64 *wqe;
+	u64 offset8, offset24;
+
+	wqe = qp->qp_uk.rq_base[wqe_idx].elem;
+	get_64bit_val(wqe, 24, &offset24);
+	if (qp->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		get_64bit_val(wqe, 8, &offset8);
+		if (offset24)
+			offset8 &= ~LS_64(1, IRDMAQPSQ_VALID);
+		else
+			offset8 |= LS_64(1, IRDMAQPSQ_VALID);
+		set_64bit_val(wqe, 8, offset8);
+		dma_wmb(); /* make sure WQE is written before valid bit is set */
+	}
+	if (offset24)
+		offset24 = 0;
+	else
+		offset24 = LS_64(1, IRDMAQPSQ_VALID);
+
+	set_64bit_val(wqe, 24, offset24);
+}
+
+/**
+ * irdma_ieq_get_fpdu_len - given length return fpdu length
+ * @len: length of fpdu
+ */
+static u16 irdma_ieq_get_fpdu_len(u16 len)
+{
+	u16 fpdu_len;
+
+	fpdu_len = len + IRDMA_IEQ_MPA_FRAMING;
+	fpdu_len = (fpdu_len + 3) & 0xfffffffc;
+
+	return fpdu_len;
+}
+
+/**
+ * irdma_ieq_copy_to_txbuf - copydata from rcv buf to tx buf
+ * @buf: rcv buffer with partial
+ * @txbuf: tx buffer for sending back
+ * @buf_offset: rcv buffer offset to copy from
+ * @txbuf_offset: at offset in tx buf to copy
+ * @len: length of data to copy
+ */
+static void irdma_ieq_copy_to_txbuf(struct irdma_puda_buf *buf,
+				    struct irdma_puda_buf *txbuf,
+				    u16 buf_offset, u32 txbuf_offset, u32 len)
+{
+	void *mem1 = (u8 *)buf->mem.va + buf_offset;
+	void *mem2 = (u8 *)txbuf->mem.va + txbuf_offset;
+
+	memcpy(mem2, mem1, len);
+}
+
+/**
+ * irdma_ieq_setup_tx_buf - setup tx buffer for partial handling
+ * @buf: reeive buffer with partial
+ * @txbuf: buffer to prepare
+ */
+static void irdma_ieq_setup_tx_buf(struct irdma_puda_buf *buf,
+				   struct irdma_puda_buf *txbuf)
+{
+	txbuf->tcphlen = buf->tcphlen;
+	txbuf->ipv4 = buf->ipv4;
+
+	if (buf->vsi->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		txbuf->hdrlen = txbuf->tcphlen;
+		irdma_ieq_copy_to_txbuf(buf, txbuf, IRDMA_TCP_OFFSET, 0,
+					txbuf->hdrlen);
+	} else {
+		txbuf->maclen = buf->maclen;
+		txbuf->hdrlen = buf->hdrlen;
+		irdma_ieq_copy_to_txbuf(buf, txbuf, 0, 0, buf->hdrlen);
+	}
+}
+
+/**
+ * irdma_ieq_check_first_buf - check if rcv buffer's seq is in range
+ * @buf: receive exception buffer
+ * @fps: first partial sequence number
+ */
+static void irdma_ieq_check_first_buf(struct irdma_puda_buf *buf, u32 fps)
+{
+	u32 offset;
+
+	if (buf->seqnum < fps) {
+		offset = fps - buf->seqnum;
+		if (offset > buf->datalen)
+			return;
+		buf->data += offset;
+		buf->datalen -= (u16)offset;
+		buf->seqnum = fps;
+	}
+}
+
+/**
+ * irdma_ieq_compl_pfpdu - write txbuf with full fpdu
+ * @ieq: ieq resource
+ * @rxlist: ieq's received buffer list
+ * @pbufl: temporary list for buffers for fpddu
+ * @txbuf: tx buffer for fpdu
+ * @fpdu_len: total length of fpdu
+ */
+static void irdma_ieq_compl_pfpdu(struct irdma_puda_rsrc *ieq,
+				  struct list_head *rxlist,
+				  struct list_head *pbufl,
+				  struct irdma_puda_buf *txbuf, u16 fpdu_len)
+{
+	struct irdma_puda_buf *buf;
+	u32 nextseqnum;
+	u16 txoffset, bufoffset;
+
+	buf = irdma_puda_get_listbuf(pbufl);
+	if (!buf)
+		return;
+
+	nextseqnum = buf->seqnum + fpdu_len;
+	irdma_ieq_setup_tx_buf(buf, txbuf);
+	if (buf->vsi->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		txoffset = txbuf->hdrlen;
+		txbuf->totallen = txbuf->hdrlen + fpdu_len;
+		txbuf->data = (u8 *)txbuf->mem.va + txoffset;
+	} else {
+		txoffset = buf->hdrlen;
+		txbuf->totallen = buf->hdrlen + fpdu_len;
+		txbuf->data = (u8 *)txbuf->mem.va + buf->hdrlen;
+	}
+	bufoffset = (u16)(buf->data - (u8 *)buf->mem.va);
+
+	do {
+		if (buf->datalen >= fpdu_len) {
+			/* copied full fpdu */
+			irdma_ieq_copy_to_txbuf(buf, txbuf, bufoffset, txoffset,
+						fpdu_len);
+			buf->datalen -= fpdu_len;
+			buf->data += fpdu_len;
+			buf->seqnum = nextseqnum;
+			break;
+		}
+		/* copy partial fpdu */
+		irdma_ieq_copy_to_txbuf(buf, txbuf, bufoffset, txoffset,
+					buf->datalen);
+		txoffset += buf->datalen;
+		fpdu_len -= buf->datalen;
+		irdma_puda_ret_bufpool(ieq, buf);
+		buf = irdma_puda_get_listbuf(pbufl);
+		if (!buf)
+			return;
+
+		bufoffset = (u16)(buf->data - (u8 *)buf->mem.va);
+	} while (1);
+
+	/* last buffer on the list*/
+	if (buf->datalen)
+		list_add(&buf->list, rxlist);
+	else
+		irdma_puda_ret_bufpool(ieq, buf);
+}
+
+/**
+ * irdma_ieq_create_pbufl - create buffer list for single fpdu
+ * @pfpdu: pointer to fpdu
+ * @rxlist: resource list for receive ieq buffes
+ * @pbufl: temp. list for buffers for fpddu
+ * @buf: first receive buffer
+ * @fpdu_len: total length of fpdu
+ */
+static enum irdma_status_code
+irdma_ieq_create_pbufl(struct irdma_pfpdu *pfpdu, struct list_head *rxlist,
+		       struct list_head *pbufl, struct irdma_puda_buf *buf,
+		       u16 fpdu_len)
+{
+	enum irdma_status_code status = 0;
+	struct irdma_puda_buf *nextbuf;
+	u32 nextseqnum;
+	u16 plen = fpdu_len - buf->datalen;
+	bool done = false;
+
+	nextseqnum = buf->seqnum + buf->datalen;
+	do {
+		nextbuf = irdma_puda_get_listbuf(rxlist);
+		if (!nextbuf) {
+			status = IRDMA_ERR_list_empty;
+			break;
+		}
+		list_add_tail(&nextbuf->list, pbufl);
+		if (nextbuf->seqnum != nextseqnum) {
+			pfpdu->bad_seq_num++;
+			status = IRDMA_ERR_SEQ_NUM;
+			break;
+		}
+		if (nextbuf->datalen >= plen) {
+			done = true;
+		} else {
+			plen -= nextbuf->datalen;
+			nextseqnum = nextbuf->seqnum + nextbuf->datalen;
+		}
+
+	} while (!done);
+
+	return status;
+}
+
+/**
+ * irdma_ieq_handle_partial - process partial fpdu buffer
+ * @ieq: ieq resource
+ * @pfpdu: partial management per user qp
+ * @buf: receive buffer
+ * @fpdu_len: fpdu len in the buffer
+ */
+static enum irdma_status_code
+irdma_ieq_handle_partial(struct irdma_puda_rsrc *ieq, struct irdma_pfpdu *pfpdu,
+			 struct irdma_puda_buf *buf, u16 fpdu_len)
+{
+	enum irdma_status_code status = 0;
+	u8 *crcptr;
+	u32 mpacrc;
+	u32 seqnum = buf->seqnum;
+	struct list_head pbufl; /* partial buffer list */
+	struct irdma_puda_buf *txbuf = NULL;
+	struct list_head *rxlist = &pfpdu->rxlist;
+
+	INIT_LIST_HEAD(&pbufl);
+	list_add(&buf->list, &pbufl);
+
+	status = irdma_ieq_create_pbufl(pfpdu, rxlist, &pbufl, buf, fpdu_len);
+	if (status)
+		goto error;
+
+	txbuf = irdma_puda_get_bufpool(ieq);
+	if (!txbuf) {
+		pfpdu->no_tx_bufs++;
+		status = IRDMA_ERR_NO_TXBUFS;
+		goto error;
+	}
+
+	irdma_ieq_compl_pfpdu(ieq, rxlist, &pbufl, txbuf, fpdu_len);
+	irdma_ieq_update_tcpip_info(txbuf, fpdu_len, seqnum);
+
+	crcptr = txbuf->data + fpdu_len - 4;
+	mpacrc = *(u32 *)crcptr;
+	if (ieq->check_crc) {
+		status = irdma_ieq_check_mpacrc(ieq->hash_desc, txbuf->data,
+						(fpdu_len - 4), mpacrc);
+		if (status) {
+			dev_dbg(rfdev_to_dev(ieq->dev),
+				"IEQ: error bad crc\n");
+			goto error;
+		}
+	}
+
+	irdma_debug_buf(ieq->dev, IRDMA_DEBUG_IEQ, "IEQ TX BUFFER",
+			txbuf->mem.va, txbuf->totallen);
+	if (ieq->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1)
+		txbuf->ah_id = pfpdu->ah->ah_info.ah_idx;
+	txbuf->do_lpb = true;
+	irdma_puda_send_buf(ieq, txbuf);
+	pfpdu->rcv_nxt = seqnum + fpdu_len;
+	return status;
+
+error:
+	while (!list_empty(&pbufl)) {
+		buf = (struct irdma_puda_buf *)(pbufl.prev);
+		list_del(&buf->list);
+		list_add(&buf->list, rxlist);
+	}
+	if (txbuf)
+		irdma_puda_ret_bufpool(ieq, txbuf);
+
+	return status;
+}
+
+/**
+ * irdma_ieq_process_buf - process buffer rcvd for ieq
+ * @ieq: ieq resource
+ * @pfpdu: partial management per user qp
+ * @buf: receive buffer
+ */
+static enum irdma_status_code irdma_ieq_process_buf(struct irdma_puda_rsrc *ieq,
+						    struct irdma_pfpdu *pfpdu,
+						    struct irdma_puda_buf *buf)
+{
+	u16 fpdu_len = 0;
+	u16 datalen = buf->datalen;
+	u8 *datap = buf->data;
+	u8 *crcptr;
+	u16 ioffset = 0;
+	u32 mpacrc;
+	u32 seqnum = buf->seqnum;
+	u16 len = 0;
+	u16 full = 0;
+	bool partial = false;
+	struct irdma_puda_buf *txbuf;
+	struct list_head *rxlist = &pfpdu->rxlist;
+	enum irdma_status_code ret = 0;
+
+	ioffset = (u16)(buf->data - (u8 *)buf->mem.va);
+	while (datalen) {
+		fpdu_len = irdma_ieq_get_fpdu_len(ntohs(*(__be16 *)datap));
+		if (fpdu_len > pfpdu->max_fpdu_data) {
+			dev_dbg(rfdev_to_dev(ieq->dev),
+				"IEQ: error bad fpdu_len\n");
+			list_add(&buf->list, rxlist);
+			return IRDMA_ERR_MPA_CRC;
+		}
+
+		if (datalen < fpdu_len) {
+			partial = true;
+			break;
+		}
+		crcptr = datap + fpdu_len - 4;
+		mpacrc = *(u32 *)crcptr;
+		if (ieq->check_crc)
+			ret = irdma_ieq_check_mpacrc(ieq->hash_desc, datap,
+						     fpdu_len - 4, mpacrc);
+		if (ret) {
+			list_add(&buf->list, rxlist);
+			dev_dbg(rfdev_to_dev(ieq->dev),
+				"ERR: IRDMA_ERR_MPA_CRC\n");
+			return IRDMA_ERR_MPA_CRC;
+		}
+		full++;
+		pfpdu->fpdu_processed++;
+		datap += fpdu_len;
+		len += fpdu_len;
+		datalen -= fpdu_len;
+	}
+	if (full) {
+		/* copy full pdu's in the txbuf and send them out */
+		txbuf = irdma_puda_get_bufpool(ieq);
+		if (!txbuf) {
+			pfpdu->no_tx_bufs++;
+			list_add(&buf->list, rxlist);
+			return IRDMA_ERR_NO_TXBUFS;
+		}
+		/* modify txbuf's buffer header */
+		irdma_ieq_setup_tx_buf(buf, txbuf);
+		/* copy full fpdu's to new buffer */
+		if (ieq->dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+			irdma_ieq_copy_to_txbuf(buf, txbuf, ioffset,
+						txbuf->hdrlen, len);
+			txbuf->totallen = txbuf->hdrlen + len;
+			txbuf->ah_id = pfpdu->ah->ah_info.ah_idx;
+		} else {
+			irdma_ieq_copy_to_txbuf(buf, txbuf, ioffset,
+						buf->hdrlen, len);
+			txbuf->totallen = buf->hdrlen + len;
+		}
+		irdma_ieq_update_tcpip_info(txbuf, len, buf->seqnum);
+		irdma_debug_buf(ieq->dev, IRDMA_DEBUG_IEQ, "IEQ TX BUFFER",
+				txbuf->mem.va, txbuf->totallen);
+		txbuf->do_lpb = true;
+		irdma_puda_send_buf(ieq, txbuf);
+
+		if (!datalen) {
+			pfpdu->rcv_nxt = buf->seqnum + len;
+			irdma_puda_ret_bufpool(ieq, buf);
+			return 0;
+		}
+		buf->data = datap;
+		buf->seqnum = seqnum + len;
+		buf->datalen = datalen;
+		pfpdu->rcv_nxt = buf->seqnum;
+	}
+	if (partial)
+		return irdma_ieq_handle_partial(ieq, pfpdu, buf, fpdu_len);
+
+	return 0;
+}
+
+/**
+ * irdma_ieq_process_fpdus - process fpdu's buffers on its list
+ * @qp: qp for which partial fpdus
+ * @ieq: ieq resource
+ */
+void irdma_ieq_process_fpdus(struct irdma_sc_qp *qp,
+			     struct irdma_puda_rsrc *ieq)
+{
+	struct irdma_pfpdu *pfpdu = &qp->pfpdu;
+	struct list_head *rxlist = &pfpdu->rxlist;
+	struct irdma_puda_buf *buf;
+	enum irdma_status_code status;
+
+	do {
+		if (list_empty(rxlist))
+			break;
+		buf = irdma_puda_get_listbuf(rxlist);
+		if (!buf) {
+			dev_dbg(rfdev_to_dev(ieq->dev), "IEQ: error no buf\n");
+			break;
+		}
+		if (buf->seqnum != pfpdu->rcv_nxt) {
+			/* This could be out of order or missing packet */
+			pfpdu->out_of_order++;
+			list_add(&buf->list, rxlist);
+			break;
+		}
+		/* keep processing buffers from the head of the list */
+		status = irdma_ieq_process_buf(ieq, pfpdu, buf);
+		if (status == IRDMA_ERR_MPA_CRC) {
+			pfpdu->mpa_crc_err = true;
+			while (!list_empty(rxlist)) {
+				buf = irdma_puda_get_listbuf(rxlist);
+				irdma_puda_ret_bufpool(ieq, buf);
+				pfpdu->crc_err++;
+			}
+			/* create CQP for AE */
+			irdma_ieq_mpa_crc_ae(ieq->dev, qp);
+		}
+	} while (!status);
+}
+
+/**
+ * irdma_ieq_create_ah - create an address handle for IEQ
+ * @qp: qp pointer
+ * @buf: buf received on IEQ used to create AH
+ */
+static enum irdma_status_code irdma_ieq_create_ah(struct irdma_sc_qp *qp,
+						  struct irdma_puda_buf *buf)
+{
+	struct irdma_ah_info ah_info = {};
+
+	qp->pfpdu.ah_buf = buf;
+	irdma_puda_ieq_get_ah_info(qp, &ah_info);
+	return irdma_puda_create_ah(qp->vsi->dev, &ah_info, false,
+				    IRDMA_PUDA_RSRC_TYPE_IEQ, qp,
+				    &qp->pfpdu.ah);
+}
+
+/**
+ * irdma_ieq_handle_exception - handle qp's exception
+ * @ieq: ieq resource
+ * @qp: qp receiving excpetion
+ * @buf: receive buffer
+ */
+static void irdma_ieq_handle_exception(struct irdma_puda_rsrc *ieq,
+				       struct irdma_sc_qp *qp,
+				       struct irdma_puda_buf *buf)
+{
+	struct irdma_pfpdu *pfpdu = &qp->pfpdu;
+	u32 *hw_host_ctx = (u32 *)qp->hw_host_ctx;
+	u32 rcv_wnd = hw_host_ctx[23];
+	/* first partial seq # in q2 */
+	u32 fps = *(u32 *)(qp->q2_buf + Q2_FPSN_OFFSET);
+	struct list_head *rxlist = &pfpdu->rxlist;
+	unsigned long flags = 0;
+	u8 hw_rev = qp->dev->hw_attrs.uk_attrs.hw_rev;
+
+	irdma_debug_buf(ieq->dev, IRDMA_DEBUG_IEQ, "IEQ RX BUFFER", buf->mem.va,
+			buf->totallen);
+
+	spin_lock_irqsave(&pfpdu->lock, flags);
+	pfpdu->total_ieq_bufs++;
+	if (pfpdu->mpa_crc_err) {
+		pfpdu->crc_err++;
+		goto error;
+	}
+	if (pfpdu->mode && fps != pfpdu->fps) {
+		/* clean up qp as it is new partial sequence */
+		irdma_ieq_cleanup_qp(ieq, qp);
+		dev_dbg(rfdev_to_dev(ieq->dev),
+			"IEQ: restarting new partial\n");
+		pfpdu->mode = false;
+	}
+
+	if (!pfpdu->mode) {
+		irdma_debug_buf(ieq->dev, IRDMA_DEBUG_IEQ, "Q2 BUFFER",
+				(u64 *)qp->q2_buf, 128);
+		/* First_Partial_Sequence_Number check */
+		pfpdu->rcv_nxt = fps;
+		pfpdu->fps = fps;
+		pfpdu->mode = true;
+		pfpdu->max_fpdu_data = (buf->ipv4) ?
+				       (ieq->vsi->mtu - IRDMA_MTU_TO_MSS_IPV4) :
+				       (ieq->vsi->mtu - IRDMA_MTU_TO_MSS_IPV6);
+		pfpdu->pmode_count++;
+		INIT_LIST_HEAD(rxlist);
+		irdma_ieq_check_first_buf(buf, fps);
+	}
+
+	if (!(rcv_wnd >= (buf->seqnum - pfpdu->rcv_nxt))) {
+		pfpdu->bad_seq_num++;
+		goto error;
+	}
+
+	if (!list_empty(rxlist)) {
+		if (buf->seqnum != pfpdu->nextseqnum) {
+			irdma_send_ieq_ack(qp);
+			/* throw away out-of-order, duplicates*/
+			goto error;
+		}
+	}
+	/* Insert buf before head */
+	list_add_tail(&buf->list, rxlist);
+	pfpdu->nextseqnum = buf->seqnum + buf->datalen;
+	pfpdu->lastrcv_buf = buf;
+	if (hw_rev > IRDMA_GEN_1 && !pfpdu->ah) {
+		irdma_ieq_create_ah(qp, buf);
+		if (!pfpdu->ah)
+			goto error;
+		goto exit;
+	}
+	if (hw_rev == IRDMA_GEN_1)
+		irdma_ieq_process_fpdus(qp, ieq);
+	else if (pfpdu->ah && pfpdu->ah->ah_info.ah_valid)
+		irdma_ieq_process_fpdus(qp, ieq);
+exit:
+	spin_unlock_irqrestore(&pfpdu->lock, flags);
+	return;
+
+error:
+	irdma_puda_ret_bufpool(ieq, buf);
+	spin_unlock_irqrestore(&pfpdu->lock, flags);
+}
+
+/**
+ * irdma_ieq_receive - received exception buffer
+ * @vsi: VSI of device
+ * @buf: exception buffer received
+ */
+static void irdma_ieq_receive(struct irdma_sc_vsi *vsi,
+			      struct irdma_puda_buf *buf)
+{
+	struct irdma_puda_rsrc *ieq = vsi->ieq;
+	struct irdma_sc_qp *qp = NULL;
+	u32 wqe_idx = ieq->compl_rxwqe_idx;
+
+	qp = irdma_ieq_get_qp(vsi->dev, buf);
+	if (!qp) {
+		ieq->stats_bad_qp_id++;
+		irdma_puda_ret_bufpool(ieq, buf);
+	} else {
+		irdma_ieq_handle_exception(ieq, qp, buf);
+	}
+	/*
+	 * ieq->rx_wqe_idx is used by irdma_puda_replenish_rq()
+	 * on which wqe_idx to start replenish rq
+	 */
+	if (!ieq->rxq_invalid_cnt)
+		ieq->rx_wqe_idx = wqe_idx;
+	ieq->rxq_invalid_cnt++;
+}
+
+/**
+ * irdma_ieq_tx_compl - put back after sending completed exception buffer
+ * @vsi: sc VSI struct
+ * @sqwrid: pointer to puda buffer
+ */
+static void irdma_ieq_tx_compl(struct irdma_sc_vsi *vsi, void *sqwrid)
+{
+	struct irdma_puda_rsrc *ieq = vsi->ieq;
+	struct irdma_puda_buf *buf = sqwrid;
+
+	irdma_puda_ret_bufpool(ieq, buf);
+}
+
+/**
+ * irdma_ieq_cleanup_qp - qp is being destroyed
+ * @ieq: ieq resource
+ * @qp: all pending fpdu buffers
+ */
+void irdma_ieq_cleanup_qp(struct irdma_puda_rsrc *ieq, struct irdma_sc_qp *qp)
+{
+	struct irdma_puda_buf *buf;
+	struct irdma_pfpdu *pfpdu = &qp->pfpdu;
+	struct list_head *rxlist = &pfpdu->rxlist;
+
+	if (!pfpdu->mode)
+		return;
+
+	while (!list_empty(rxlist)) {
+		buf = irdma_puda_get_listbuf(rxlist);
+		irdma_puda_ret_bufpool(ieq, buf);
+	}
+
+	if (qp->pfpdu.ah) {
+		irdma_puda_free_ah(ieq->dev, qp->pfpdu.ah);
+		qp->pfpdu.ah = NULL;
+		qp->pfpdu.ah_buf = NULL;
+	}
+}
diff --git a/drivers/infiniband/hw/irdma/puda.h b/drivers/infiniband/hw/irdma/puda.h
new file mode 100644
index 000000000000..7cee69431f42
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/puda.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_PUDA_H
+#define IRDMA_PUDA_H
+
+#define IRDMA_IEQ_MPA_FRAMING	6
+#define IRDMA_TCP_OFFSET	40
+#define IRDMA_IPV4_PAD		20
+
+enum puda_rsrc_type {
+	IRDMA_PUDA_RSRC_TYPE_ILQ = 1,
+	IRDMA_PUDA_RSRC_TYPE_IEQ,
+	IRDMA_PUDA_RSRC_TYPE_MAX, /* Must be last entry */
+};
+
+enum puda_rsrc_complete {
+	PUDA_CQ_CREATED = 1,
+	PUDA_QP_CREATED,
+	PUDA_TX_COMPLETE,
+	PUDA_RX_COMPLETE,
+	PUDA_HASH_CRC_COMPLETE,
+};
+
+struct irdma_sc_dev;
+struct irdma_sc_qp;
+struct irdma_sc_cq;
+
+struct irdma_puda_cmpl_info {
+	struct irdma_qp_uk *qp;
+	u8 q_type;
+	u8 l3proto;
+	u8 l4proto;
+	u16 vlan;
+	u32 payload_len;
+	u32 compl_error; /* No_err=0, else major and minor err code */
+	u32 qp_id;
+	u32 wqe_idx;
+	bool ipv4:1;
+	bool smac_valid:1;
+	bool vlan_valid:1;
+	u8 smac[ETH_ALEN];
+};
+
+struct irdma_puda_send_info {
+	u64 paddr; /* Physical address */
+	u32 len;
+	u32 ah_id;
+	u8 tcplen;
+	u8 maclen;
+	bool ipv4:1;
+	bool do_lpb:1;
+	void *scratch;
+};
+
+struct irdma_puda_buf {
+	struct list_head list; /* MUST be first entry */
+	struct irdma_dma_mem mem; /* DMA memory for the buffer */
+	struct irdma_puda_buf *next; /* for alloclist in rsrc struct */
+	struct irdma_virt_mem buf_mem; /* Buffer memory for this buffer */
+	void *scratch;
+	u8 *iph;
+	u8 *tcph;
+	u8 *data;
+	u16 datalen;
+	u16 vlan_id;
+	u8 tcphlen; /* tcp length in bytes */
+	u8 maclen; /* mac length in bytes */
+	u32 totallen; /* machlen+iphlen+tcphlen+datalen */
+	refcount_t refcount;
+	u8 hdrlen;
+	bool ipv4:1;
+	bool vlan_valid:1;
+	bool do_lpb:1; /* Loopback buffer */
+	bool smac_valid:1;
+	u32 seqnum;
+	u32 ah_id;
+	u8 smac[ETH_ALEN];
+	struct irdma_sc_vsi *vsi;
+};
+
+struct irdma_puda_rsrc_info {
+	void (*receive)(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *buf);
+	void (*xmit_complete)(struct irdma_sc_vsi *vsi, void *sqwrid);
+	enum puda_rsrc_type type; /* ILQ or IEQ */
+	u32 count;
+	u32 pd_id;
+	u32 cq_id;
+	u32 qp_id;
+	u32 sq_size;
+	u32 rq_size;
+	u32 tx_buf_cnt; /* total bufs allocated will be rq_size + tx_buf_cnt */
+	u16 buf_size;
+	u8 stats_idx;
+	bool stats_idx_valid:1;
+};
+
+struct irdma_puda_rsrc {
+	struct irdma_sc_cq cq;
+	struct irdma_sc_qp qp;
+	struct irdma_sc_pd sc_pd;
+	struct irdma_sc_dev *dev;
+	struct irdma_sc_vsi *vsi;
+	struct irdma_dma_mem cqmem;
+	struct irdma_dma_mem qpmem;
+	struct irdma_virt_mem ilq_mem;
+	enum puda_rsrc_complete cmpl;
+	enum puda_rsrc_type type;
+	u16 buf_size; /*buf must be max datalen + tcpip hdr + mac */
+	u32 cq_id;
+	u32 qp_id;
+	u32 sq_size;
+	u32 rq_size;
+	u32 cq_size;
+	struct irdma_sq_uk_wr_trk_info *sq_wrtrk_array;
+	u64 *rq_wrid_array;
+	u32 compl_rxwqe_idx;
+	u32 rx_wqe_idx;
+	u32 rxq_invalid_cnt;
+	u32 tx_wqe_avail_cnt;
+	struct shash_desc *hash_desc;
+	struct list_head txpend;
+	struct list_head bufpool; /* free buffers pool list for recv and xmit */
+	u32 alloc_buf_count;
+	u32 avail_buf_count; /* snapshot of currently available buffers */
+	spinlock_t bufpool_lock;
+	struct irdma_puda_buf *alloclist;
+	void (*receive)(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *buf);
+	void (*xmit_complete)(struct irdma_sc_vsi *vsi, void *sqwrid);
+	/* puda stats */
+	u64 stats_buf_alloc_fail;
+	u64 stats_pkt_rcvd;
+	u64 stats_pkt_sent;
+	u64 stats_rcvd_pkt_err;
+	u64 stats_sent_pkt_q;
+	u64 stats_bad_qp_id;
+	u8 stats_idx;
+	bool check_crc:1;
+	bool stats_idx_valid:1;
+};
+
+struct irdma_puda_buf *irdma_puda_get_bufpool(struct irdma_puda_rsrc *rsrc);
+void irdma_puda_ret_bufpool(struct irdma_puda_rsrc *rsrc,
+			    struct irdma_puda_buf *buf);
+void irdma_puda_send_buf(struct irdma_puda_rsrc *rsrc,
+			 struct irdma_puda_buf *buf);
+enum irdma_status_code irdma_puda_send(struct irdma_sc_qp *qp,
+				       struct irdma_puda_send_info *info);
+enum irdma_status_code
+irdma_puda_create_rsrc(struct irdma_sc_vsi *vsi,
+		       struct irdma_puda_rsrc_info *info);
+void irdma_puda_dele_rsrc(struct irdma_sc_vsi *vsi, enum puda_rsrc_type type,
+			  bool reset);
+enum irdma_status_code irdma_puda_poll_cmpl(struct irdma_sc_dev *dev,
+					    struct irdma_sc_cq *cq,
+					    u32 *compl_err);
+
+struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
+				     struct irdma_puda_buf *buf);
+enum irdma_status_code
+irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			  struct irdma_puda_buf *buf);
+enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
+					      void *addr, u32 len, u32 val);
+enum irdma_status_code irdma_init_hash_desc(struct shash_desc **desc);
+void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp);
+void irdma_free_hash_desc(struct shash_desc *desc);
+void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf, u16 len,
+				 u32 seqnum);
+enum irdma_status_code irdma_cqp_qp_create_cmd(struct irdma_sc_dev *dev,
+					       struct irdma_sc_qp *qp);
+enum irdma_status_code irdma_cqp_cq_create_cmd(struct irdma_sc_dev *dev,
+					       struct irdma_sc_cq *cq);
+void irdma_cqp_qp_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp);
+void irdma_cqp_cq_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_cq *cq);
+void irdma_puda_ieq_get_ah_info(struct irdma_sc_qp *qp,
+				struct irdma_ah_info *ah_info);
+enum irdma_status_code irdma_puda_create_ah(struct irdma_sc_dev *dev,
+					    struct irdma_ah_info *ah_info,
+					    bool wait, enum puda_rsrc_type type,
+					    void *cb_param,
+					    struct irdma_sc_ah **ah);
+void irdma_puda_free_ah(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah);
+void irdma_ieq_process_fpdus(struct irdma_sc_qp *qp,
+			     struct irdma_puda_rsrc *ieq);
+void irdma_ieq_cleanup_qp(struct irdma_puda_rsrc *ieq, struct irdma_sc_qp *qp);
+#endif /*IRDMA_PROTOS_H */
-- 
2.25.2

