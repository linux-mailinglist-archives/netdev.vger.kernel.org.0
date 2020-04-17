Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570841AE391
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgDQRQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:16:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:38157 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgDQRQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:16:56 -0400
IronPort-SDR: mLI0tb0uACqUaPCJPgVkx389tgwMsApyY7uICDqN+HAAv+xwMvXD8vGilIyOIaGmfALjh3ytk9
 L/leD+0+Z+SA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:53 -0700
IronPort-SDR: TBBgFW05u8dfsMAqY54bleg8GthqB5AXLjpZJqRJhgtAF1LUqP/Jbk/VwcLjcA1hg6AIYp5Izg
 zWku7J9OYa0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383700"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:53 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 02/16] RDMA/irdma: Implement device initialization definitions
Date:   Fri, 17 Apr 2020 10:12:37 -0700
Message-Id: <20200417171251.1533371-3-jeffrey.t.kirsher@intel.com>
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

Implement device initialization routines, interrupt set-up,
and allocate object bit-map tracking structures.
Also, add device specific attributes and register definitions.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/hw.c        | 2597 +++++++++++++++++++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c  |  211 ++
 drivers/infiniband/hw/irdma/i40iw_hw.h  |  162 ++
 drivers/infiniband/hw/irdma/icrdma_hw.c |   76 +
 drivers/infiniband/hw/irdma/icrdma_hw.h |   62 +
 5 files changed, 3108 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.h

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
new file mode 100644
index 000000000000..294ee3c2b0c4
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -0,0 +1,2597 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "main.h"
+
+static struct irdma_rsrc_limits rsrc_limits_table[] = {
+	[0] = {
+		.qplimit = 4096,
+	},
+	[1] = {
+		.qplimit = 128,
+	},
+	[2] = {
+		.qplimit = 1024,
+	},
+	[3] = {
+		.qplimit = 2048,
+	},
+	[4] = {
+		.qplimit = 16384,
+	},
+	[5] = {
+		.qplimit = 65536,
+	},
+};
+
+/* types of hmc objects */
+static enum irdma_hmc_rsrc_type iw_hmc_obj_types[] = {
+	IRDMA_HMC_IW_QP,
+	IRDMA_HMC_IW_CQ,
+	IRDMA_HMC_IW_HTE,
+	IRDMA_HMC_IW_ARP,
+	IRDMA_HMC_IW_APBVT_ENTRY,
+	IRDMA_HMC_IW_MR,
+	IRDMA_HMC_IW_XF,
+	IRDMA_HMC_IW_XFFL,
+	IRDMA_HMC_IW_Q1,
+	IRDMA_HMC_IW_Q1FL,
+	IRDMA_HMC_IW_TIMER,
+	IRDMA_HMC_IW_FSIMC,
+	IRDMA_HMC_IW_FSIAV,
+	IRDMA_HMC_IW_RRF,
+	IRDMA_HMC_IW_RRFFL,
+	IRDMA_HMC_IW_HDR,
+	IRDMA_HMC_IW_MD,
+	IRDMA_HMC_IW_OOISC,
+	IRDMA_HMC_IW_OOISCFFL,
+};
+
+/**
+ * irdma_iwarp_ce_handler - handle iwarp completions
+ * @iwcq: iwarp cq receiving event
+ */
+static void irdma_iwarp_ce_handler(struct irdma_sc_cq *iwcq)
+{
+	struct irdma_cq *cq = iwcq->back_cq;
+
+	if (cq->ibcq.comp_handler)
+		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
+
+/**
+ * irdma_puda_ce_handler - handle puda completion events
+ * @rf: RDMA PCI function
+ * @cq: puda completion q for event
+ */
+static void irdma_puda_ce_handler(struct irdma_pci_f *rf,
+				  struct irdma_sc_cq *cq)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+	u32 compl_error;
+
+	do {
+		status = irdma_puda_poll_cmpl(dev, cq, &compl_error);
+		if (status == IRDMA_ERR_Q_EMPTY)
+			break;
+		if (status) {
+			dev_dbg(rfdev_to_dev(dev), "ERR: puda status = %d\n",
+				status);
+			break;
+		}
+		if (compl_error) {
+			dev_dbg(rfdev_to_dev(dev),
+				"ERR: puda compl_err  =0x%x\n", compl_error);
+			break;
+		}
+	} while (1);
+
+	dev->ccq_ops->ccq_arm(cq);
+}
+
+/**
+ * irdma_process_ceq - handle ceq for completions
+ * @rf: RDMA PCI function
+ * @ceq: ceq having cq for completion
+ */
+static void irdma_process_ceq(struct irdma_pci_f *rf, struct irdma_ceq *ceq)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_sc_ceq *sc_ceq;
+	struct irdma_sc_cq *cq;
+
+	sc_ceq = &ceq->sc_ceq;
+	do {
+		cq = dev->ceq_ops->process_ceq(dev, sc_ceq);
+		if (!cq)
+			break;
+
+		if (cq->cq_type == IRDMA_CQ_TYPE_CQP)
+			queue_work(rf->cqp_cmpl_wq, &rf->cqp_cmpl_work);
+		else if (cq->cq_type == IRDMA_CQ_TYPE_IWARP)
+			irdma_iwarp_ce_handler(cq);
+		else if (cq->cq_type == IRDMA_CQ_TYPE_ILQ ||
+			 cq->cq_type == IRDMA_CQ_TYPE_IEQ)
+			irdma_puda_ce_handler(rf, cq);
+	} while (1);
+}
+
+/**
+ * irdma_process_aeq - handle aeq events
+ * @rf: RDMA PCI function
+ */
+static void irdma_process_aeq(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_aeq *aeq = &rf->aeq;
+	struct irdma_sc_aeq *sc_aeq = &aeq->sc_aeq;
+	struct irdma_aeqe_info aeinfo;
+	struct irdma_aeqe_info *info = &aeinfo;
+	int ret;
+	struct irdma_qp *iwqp = NULL;
+	struct irdma_sc_cq *cq = NULL;
+	struct irdma_cq *iwcq = NULL;
+	struct irdma_sc_qp *qp = NULL;
+	struct irdma_qp_host_ctx_info *ctx_info = NULL;
+	unsigned long flags;
+
+	u32 aeqcnt = 0;
+
+	if (!sc_aeq->size)
+		return;
+
+	do {
+		memset(info, 0, sizeof(*info));
+		ret = dev->aeq_ops->get_next_aeqe(sc_aeq, info);
+		if (ret)
+			break;
+
+		aeqcnt++;
+		dev_dbg(rfdev_to_dev(dev),
+			"AEQ: ae_id = 0x%x bool qp=%d qp_id = %d\n",
+			info->ae_id, info->qp, info->qp_cq_id);
+		if (info->qp) {
+			spin_lock_irqsave(&rf->qptable_lock, flags);
+			iwqp = rf->qp_table[info->qp_cq_id];
+			if (!iwqp) {
+				spin_unlock_irqrestore(&rf->qptable_lock,
+						       flags);
+				if (info->ae_id == IRDMA_AE_QP_SUSPEND_COMPLETE) {
+					struct irdma_device *iwdev;
+
+					iwdev = irdma_get_device(rf->netdev);
+					if (iwdev) {
+						atomic_dec(&iwdev->vsi.qp_suspend_reqs);
+						wake_up(&iwdev->suspend_wq);
+						irdma_put_device(iwdev);
+					}
+					continue;
+				}
+				dev_dbg(rfdev_to_dev(dev),
+					"AEQ: qp_id %d is already freed\n",
+					info->qp_cq_id);
+				continue;
+			}
+			irdma_add_ref(&iwqp->ibqp);
+			spin_unlock_irqrestore(&rf->qptable_lock, flags);
+			qp = &iwqp->sc_qp;
+			spin_lock_irqsave(&iwqp->lock, flags);
+			iwqp->hw_tcp_state = info->tcp_state;
+			iwqp->hw_iwarp_state = info->iwarp_state;
+			iwqp->last_aeq = info->ae_id;
+			spin_unlock_irqrestore(&iwqp->lock, flags);
+			ctx_info = &iwqp->ctx_info;
+			if (rdma_protocol_roce(&iwqp->iwdev->ibdev, 1))
+				ctx_info->roce_info->err_rq_idx_valid = true;
+			else
+				ctx_info->iwarp_info->err_rq_idx_valid = true;
+		} else {
+			if (info->ae_id != IRDMA_AE_CQ_OPERATION_ERROR)
+				continue;
+		}
+
+		switch (info->ae_id) {
+			struct irdma_cm_node *cm_node;
+		case IRDMA_AE_LLP_CONNECTION_ESTABLISHED:
+			cm_node = iwqp->cm_node;
+			if (cm_node->accept_pend) {
+				atomic_dec(&cm_node->listener->pend_accepts_cnt);
+				cm_node->accept_pend = 0;
+			}
+			iwqp->rts_ae_rcvd = 1;
+			wake_up_interruptible(&iwqp->waitq);
+			break;
+		case IRDMA_AE_LLP_FIN_RECEIVED:
+		case IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE:
+			if (qp->term_flags)
+				break;
+			if (atomic_inc_return(&iwqp->close_timer_started) == 1) {
+				iwqp->hw_tcp_state = IRDMA_TCP_STATE_CLOSE_WAIT;
+				if (iwqp->hw_tcp_state == IRDMA_TCP_STATE_CLOSE_WAIT &&
+				    iwqp->ibqp_state == IB_QPS_RTS) {
+					irdma_next_iw_state(iwqp,
+							    IRDMA_QP_STATE_CLOSING,
+							    0, 0, 0);
+					irdma_cm_disconn(iwqp);
+				}
+				iwqp->cm_id->add_ref(iwqp->cm_id);
+				irdma_schedule_cm_timer(iwqp->cm_node,
+							(struct irdma_puda_buf *)iwqp,
+							IRDMA_TIMER_TYPE_CLOSE,
+							1, 0);
+			}
+			break;
+		case IRDMA_AE_LLP_CLOSE_COMPLETE:
+			if (qp->term_flags)
+				irdma_terminate_done(qp, 0);
+			else
+				irdma_cm_disconn(iwqp);
+			break;
+		case IRDMA_AE_BAD_CLOSE:
+			/* fall through */
+		case IRDMA_AE_RESET_SENT:
+			irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, 1, 0,
+					    0);
+			irdma_cm_disconn(iwqp);
+			break;
+		case IRDMA_AE_LLP_CONNECTION_RESET:
+			if (atomic_read(&iwqp->close_timer_started))
+				break;
+			irdma_cm_disconn(iwqp);
+			break;
+		case IRDMA_AE_QP_SUSPEND_COMPLETE:
+			atomic_dec(&iwqp->sc_qp.vsi->qp_suspend_reqs);
+			wake_up(&iwqp->iwdev->suspend_wq);
+			break;
+		case IRDMA_AE_TERMINATE_SENT:
+			irdma_terminate_send_fin(qp);
+			break;
+		case IRDMA_AE_LLP_TERMINATE_RECEIVED:
+			irdma_terminate_received(qp, info);
+			break;
+		case IRDMA_AE_CQ_OPERATION_ERROR:
+			dev_err(rfdev_to_dev(dev),
+				"Processing an iWARP related AE for CQ misc = 0x%04X\n",
+				info->ae_id);
+			cq = (struct irdma_sc_cq *)(unsigned long)
+			     info->compl_ctx;
+
+			iwcq = cq->back_cq;
+
+			if (iwcq->ibcq.event_handler) {
+				struct ib_event ibevent;
+
+				ibevent.device = iwcq->ibcq.device;
+				ibevent.event = IB_EVENT_CQ_ERR;
+				ibevent.element.cq = &iwcq->ibcq;
+				iwcq->ibcq.event_handler(&ibevent,
+							 iwcq->ibcq.cq_context);
+			}
+			break;
+		case IRDMA_AE_LLP_DOUBT_REACHABILITY:
+		case IRDMA_AE_RESOURCE_EXHAUSTION:
+			break;
+		case IRDMA_AE_PRIV_OPERATION_DENIED:
+		case IRDMA_AE_STAG_ZERO_INVALID:
+		case IRDMA_AE_IB_RREQ_AND_Q1_FULL:
+		case IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION:
+		case IRDMA_AE_DDP_UBE_INVALID_MO:
+		case IRDMA_AE_DDP_UBE_INVALID_QN:
+		case IRDMA_AE_DDP_NO_L_BIT:
+		case IRDMA_AE_RDMAP_ROE_INVALID_RDMAP_VERSION:
+		case IRDMA_AE_RDMAP_ROE_UNEXPECTED_OPCODE:
+		case IRDMA_AE_ROE_INVALID_RDMA_READ_REQUEST:
+		case IRDMA_AE_ROE_INVALID_RDMA_WRITE_OR_READ_RESP:
+		case IRDMA_AE_INVALID_ARP_ENTRY:
+		case IRDMA_AE_INVALID_TCP_OPTION_RCVD:
+		case IRDMA_AE_STALE_ARP_ENTRY:
+		case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
+		case IRDMA_AE_LLP_SEGMENT_TOO_SMALL:
+		case IRDMA_AE_LLP_SYN_RECEIVED:
+		case IRDMA_AE_LLP_TOO_MANY_RETRIES:
+		case IRDMA_AE_LCE_QP_CATASTROPHIC:
+		case IRDMA_AE_LCE_FUNCTION_CATASTROPHIC:
+		case IRDMA_AE_LCE_CQ_CATASTROPHIC:
+		case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
+			if (rdma_protocol_roce(&iwqp->iwdev->ibdev, 1))
+				ctx_info->roce_info->err_rq_idx_valid = false;
+			else
+				ctx_info->iwarp_info->err_rq_idx_valid = false;
+			/* fall through */
+		default:
+			dev_err(rfdev_to_dev(dev),
+				"abnormal ae_id = 0x%x bool qp=%d qp_id = %d\n",
+				info->ae_id, info->qp, info->qp_cq_id);
+			if (rdma_protocol_roce(&iwqp->iwdev->ibdev, 1)) {
+				if (!info->sq && ctx_info->roce_info->err_rq_idx_valid) {
+					ctx_info->roce_info->err_rq_idx = info->wqe_idx;
+					ret = dev->iw_priv_qp_ops->qp_setctx_roce(&iwqp->sc_qp,
+										  iwqp->host_ctx.va,
+										  ctx_info);
+				}
+				irdma_cm_disconn(iwqp);
+				break;
+			}
+			if (!info->sq && ctx_info->iwarp_info->err_rq_idx_valid) {
+				ctx_info->iwarp_info->err_rq_idx = info->wqe_idx;
+				ctx_info->tcp_info_valid = false;
+				ctx_info->iwarp_info_valid = false;
+				ret = dev->iw_priv_qp_ops->qp_setctx(&iwqp->sc_qp,
+								     iwqp->host_ctx.va,
+								     ctx_info);
+			}
+			if (iwqp->hw_iwarp_state != IRDMA_QP_STATE_RTS &&
+			    iwqp->hw_iwarp_state != IRDMA_QP_STATE_TERMINATE) {
+				irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, 1, 0, 0);
+				irdma_cm_disconn(iwqp);
+			} else {
+				irdma_terminate_connection(qp, info);
+			}
+			break;
+		}
+		if (info->qp)
+			irdma_rem_ref(&iwqp->ibqp);
+	} while (1);
+
+	if (aeqcnt)
+		dev->aeq_ops->repost_aeq_entries(dev, aeqcnt);
+}
+
+/**
+ * irdma_enable_intr - set up device interrupts
+ * @dev: hardware control device structure
+ * @msix_id: id of the interrupt to be enabled
+ */
+static void irdma_ena_intr(struct irdma_sc_dev *dev, u32 msix_id)
+{
+	dev->irq_ops->irdma_en_irq(dev, msix_id);
+}
+
+/**
+ * irdma_dpc - tasklet for aeq and ceq 0
+ * @data: RDMA PCI function
+ */
+static void irdma_dpc(unsigned long data)
+{
+	struct irdma_pci_f *rf = (struct irdma_pci_f *)data;
+
+	if (rf->msix_shared)
+		irdma_process_ceq(rf, rf->ceqlist);
+	irdma_process_aeq(rf);
+	irdma_ena_intr(&rf->sc_dev, rf->iw_msixtbl[0].idx);
+}
+
+/**
+ * irdma_ceq_dpc - dpc handler for CEQ
+ * @data: data points to CEQ
+ */
+static void irdma_ceq_dpc(unsigned long data)
+{
+	struct irdma_ceq *iwceq = (struct irdma_ceq *)data;
+	struct irdma_pci_f *rf = iwceq->rf;
+
+	irdma_process_ceq(rf, iwceq);
+	irdma_ena_intr(&rf->sc_dev, iwceq->msix_idx);
+}
+
+/**
+ * irdma_save_msix_info - copy msix vector information to iwarp device
+ * @rf: RDMA PCI function
+ *
+ * Allocate iwdev msix table and copy the ldev msix info to the table
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_save_msix_info(struct irdma_pci_f *rf)
+{
+	struct irdma_priv_ldev *ldev = &rf->ldev;
+	struct irdma_qvlist_info *iw_qvlist;
+	struct irdma_qv_info *iw_qvinfo;
+	struct msix_entry *pmsix;
+	u32 ceq_idx;
+	u32 i;
+	u32 size;
+
+	if (!ldev->msix_count) {
+		pr_err("No MSI-X vectors for RDMA\n");
+		return IRDMA_ERR_CFG;
+	}
+
+	rf->msix_count = ldev->msix_count;
+	size = sizeof(struct irdma_msix_vector) * rf->msix_count;
+	size += sizeof(struct irdma_qvlist_info);
+	size += sizeof(struct irdma_qv_info) * rf->msix_count - 1;
+	rf->iw_msixtbl = kzalloc(size, GFP_KERNEL);
+	if (!rf->iw_msixtbl)
+		return IRDMA_ERR_NO_MEMORY;
+
+	rf->iw_qvlist = (struct irdma_qvlist_info *)
+			(&rf->iw_msixtbl[rf->msix_count]);
+	iw_qvlist = rf->iw_qvlist;
+	iw_qvinfo = iw_qvlist->qv_info;
+	iw_qvlist->num_vectors = rf->msix_count;
+	if (rf->msix_count <= num_online_cpus())
+		rf->msix_shared = true;
+
+	for (i = 0, ceq_idx = 0, pmsix = ldev->msix_entries; i < rf->msix_count;
+	     i++, iw_qvinfo++, pmsix++) {
+		rf->iw_msixtbl[i].idx = pmsix->entry;
+		rf->iw_msixtbl[i].irq = pmsix->vector;
+		rf->iw_msixtbl[i].cpu_affinity = ceq_idx;
+		if (!i) {
+			iw_qvinfo->aeq_idx = 0;
+			if (rf->msix_shared)
+				iw_qvinfo->ceq_idx = ceq_idx++;
+			else
+				iw_qvinfo->ceq_idx = IRDMA_Q_INVALID_IDX;
+		} else {
+			iw_qvinfo->aeq_idx = IRDMA_Q_INVALID_IDX;
+			iw_qvinfo->ceq_idx = ceq_idx++;
+		}
+		iw_qvinfo->itr_idx = 3;
+		iw_qvinfo->v_idx = rf->iw_msixtbl[i].idx;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_irq_handler - interrupt handler for aeq and ceq0
+ * @irq: Interrupt request number
+ * @data: RDMA PCI function
+ */
+static irqreturn_t irdma_irq_handler(int irq, void *data)
+{
+	struct irdma_pci_f *rf = data;
+
+	tasklet_schedule(&rf->dpc_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * irdma_ceq_handler - interrupt handler for ceq
+ * @irq: interrupt request number
+ * @data: ceq pointer
+ */
+static irqreturn_t irdma_ceq_handler(int irq, void *data)
+{
+	struct irdma_ceq *iwceq = data;
+
+	if (iwceq->irq != irq)
+		dev_err(rfdev_to_dev(&iwceq->rf->sc_dev),
+			"expected irq = %d received irq = %d\n", iwceq->irq,
+			irq);
+	tasklet_schedule(&iwceq->dpc_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * irdma_destroy_irq - destroy device interrupts
+ * @rf: RDMA PCI function
+ * @msix_vec: msix vector to disable irq
+ * @dev_id: parameter to pass to free_irq (used during irq setup)
+ *
+ * The function is called when destroying aeq/ceq
+ */
+static void irdma_destroy_irq(struct irdma_pci_f *rf,
+			      struct irdma_msix_vector *msix_vec, void *dev_id)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+
+	dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
+	irq_set_affinity_hint(msix_vec->irq, NULL);
+	free_irq(msix_vec->irq, dev_id);
+}
+
+/**
+ * irdma_destroy_cqp  - destroy control qp
+ * @rf: RDMA PCI function
+ * @free_hwcqp: 1 if hw cqp should be freed
+ *
+ * Issue destroy cqp request and
+ * free the resources associated with the cqp
+ */
+static void irdma_destroy_cqp(struct irdma_pci_f *rf, bool free_hwcqp)
+{
+	enum irdma_status_code status = 0;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cqp *cqp = &rf->cqp;
+
+	if (rf->cqp_cmpl_wq)
+		destroy_workqueue(rf->cqp_cmpl_wq);
+
+	if (free_hwcqp)
+		status = dev->cqp_ops->cqp_destroy(dev->cqp);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: Destroy CQP failed %d\n",
+			status);
+
+	irdma_cleanup_pending_cqp_op(rf);
+	dma_free_coherent(hw_to_dev(dev->hw), cqp->sq.size, cqp->sq.va,
+			  cqp->sq.pa);
+	cqp->sq.va = NULL;
+	kfree(cqp->scratch_array);
+	cqp->scratch_array = NULL;
+	kfree(cqp->cqp_requests);
+	cqp->cqp_requests = NULL;
+}
+
+/**
+ * irdma_destroy_aeq - destroy aeq
+ * @rf: RDMA PCI function
+ *
+ * Issue a destroy aeq request and
+ * free the resources associated with the aeq
+ * The function is called during driver unload
+ */
+static void irdma_destroy_aeq(struct irdma_pci_f *rf)
+{
+	enum irdma_status_code status = IRDMA_ERR_NOT_READY;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_aeq *aeq = &rf->aeq;
+
+	if (!rf->msix_shared)
+		irdma_destroy_irq(rf, rf->iw_msixtbl, rf);
+	if (rf->reset)
+		goto exit;
+
+	if (!dev->aeq_ops->aeq_destroy(&aeq->sc_aeq, 0, 1))
+		status = dev->aeq_ops->aeq_destroy_done(&aeq->sc_aeq);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: Destroy AEQ failed %d\n",
+			status);
+
+exit:
+	dma_free_coherent(hw_to_dev(dev->hw), aeq->mem.size, aeq->mem.va,
+			  aeq->mem.pa);
+	aeq->mem.va = NULL;
+}
+
+/**
+ * irdma_destroy_ceq - destroy ceq
+ * @rf: RDMA PCI function
+ * @iwceq: ceq to be destroyed
+ *
+ * Issue a destroy ceq request and
+ * free the resources associated with the ceq
+ */
+static void irdma_destroy_ceq(struct irdma_pci_f *rf, struct irdma_ceq *iwceq)
+{
+	enum irdma_status_code status;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+
+	if (rf->reset)
+		goto exit;
+
+	status = dev->ceq_ops->ceq_destroy(&iwceq->sc_ceq, 0, 1);
+	if (status) {
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: CEQ destroy command failed %d\n", status);
+		goto exit;
+	}
+
+	status = dev->ceq_ops->cceq_destroy_done(&iwceq->sc_ceq);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: CEQ destroy completion failed %d\n", status);
+exit:
+	dma_free_coherent(hw_to_dev(dev->hw), iwceq->mem.size, iwceq->mem.va,
+			  iwceq->mem.pa);
+	iwceq->mem.va = NULL;
+}
+
+/**
+ * irdma_del_ceq_0 - destroy ceq 0
+ * @rf: RDMA PCI function
+ *
+ * Disable the ceq 0 interrupt and destroy the ceq 0
+ */
+static void irdma_del_ceq_0(struct irdma_pci_f *rf)
+{
+	struct irdma_ceq *iwceq = rf->ceqlist;
+	struct irdma_msix_vector *msix_vec;
+
+	if (rf->msix_shared) {
+		msix_vec = &rf->iw_msixtbl[0];
+		irdma_destroy_irq(rf, msix_vec, rf);
+	} else {
+		msix_vec = &rf->iw_msixtbl[1];
+		irdma_destroy_irq(rf, msix_vec, iwceq);
+	}
+	irdma_destroy_ceq(rf, iwceq);
+	rf->sc_dev.ceq_valid = false;
+	rf->ceqs_count = 0;
+}
+
+/**
+ * irdma_del_ceqs - destroy all ceq's except CEQ 0
+ * @rf: RDMA PCI function
+ *
+ * Go through all of the device ceq's, except 0, and for each
+ * ceq disable the ceq interrupt and destroy the ceq
+ */
+static void irdma_del_ceqs(struct irdma_pci_f *rf)
+{
+	struct irdma_ceq *iwceq = &rf->ceqlist[1];
+	struct irdma_msix_vector *msix_vec;
+	u32 i = 0;
+
+	if (rf->msix_shared)
+		msix_vec = &rf->iw_msixtbl[1];
+	else
+		msix_vec = &rf->iw_msixtbl[2];
+
+	for (i = 1; i < rf->ceqs_count; i++, msix_vec++, iwceq++) {
+		irdma_destroy_irq(rf, msix_vec, iwceq);
+		irdma_cqp_ceq_cmd(&rf->sc_dev, &iwceq->sc_ceq,
+				  IRDMA_OP_CEQ_DESTROY);
+		dma_free_coherent(hw_to_dev(rf->sc_dev.hw), iwceq->mem.size,
+				  iwceq->mem.va, iwceq->mem.pa);
+		iwceq->mem.va = NULL;
+	}
+	rf->ceqs_count = 1;
+}
+
+/**
+ * irdma_destroy_ccq - destroy control cq
+ * @rf: RDMA PCI function
+ *
+ * Issue destroy ccq request and
+ * free the resources associated with the ccq
+ */
+static void irdma_destroy_ccq(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_ccq *ccq = &rf->ccq;
+	enum irdma_status_code status = 0;
+
+	if (!rf->reset)
+		status = dev->ccq_ops->ccq_destroy(dev->ccq, 0, true);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CCQ destroy failed %d\n",
+			status);
+	dma_free_coherent(hw_to_dev(dev->hw), ccq->mem_cq.size,
+			  ccq->mem_cq.va, ccq->mem_cq.pa);
+	ccq->mem_cq.va = NULL;
+}
+
+/**
+ * irdma_close_hmc_objects_type - delete hmc objects of a given type
+ * @dev: iwarp device
+ * @obj_type: the hmc object type to be deleted
+ * @hmc_info: host memory info struct
+ * @privileged: permission to close HMC objects
+ * @reset: true if called before reset
+ */
+static void irdma_close_hmc_objects_type(struct irdma_sc_dev *dev,
+					 enum irdma_hmc_rsrc_type obj_type,
+					 struct irdma_hmc_info *hmc_info,
+					 bool privileged, bool reset)
+{
+	struct irdma_hmc_del_obj_info info = {};
+
+	info.hmc_info = hmc_info;
+	info.rsrc_type = obj_type;
+	info.count = hmc_info->hmc_obj[obj_type].cnt;
+	info.privileged = privileged;
+	if (dev->hmc_ops->del_hmc_object(dev, &info, reset))
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: del HMC obj of type %d failed\n", obj_type);
+}
+
+/**
+ * irdma_del_hmc_objects - remove all device hmc objects
+ * @dev: iwarp device
+ * @hmc_info: hmc_info to free
+ * @privileged: permission to delete HMC objects
+ * @reset: true if called before reset
+ * @vers: hardware version
+ */
+static void irdma_del_hmc_objects(struct irdma_sc_dev *dev,
+				  struct irdma_hmc_info *hmc_info, bool privileged,
+				  bool reset, enum irdma_vers vers)
+{
+	unsigned int i;
+
+	for (i = 0; i < IW_HMC_OBJ_TYPE_NUM; i++) {
+		if (dev->hmc_info->hmc_obj[iw_hmc_obj_types[i]].cnt)
+			irdma_close_hmc_objects_type(dev, iw_hmc_obj_types[i],
+						     hmc_info, privileged, reset);
+		if (vers == IRDMA_GEN_1 && i == IRDMA_HMC_IW_TIMER)
+			break;
+	}
+}
+
+/**
+ * irdma_create_hmc_obj_type - create hmc object of a given type
+ * @dev: hardware control device structure
+ * @info: information for the hmc object to create
+ */
+static enum irdma_status_code
+irdma_create_hmc_obj_type(struct irdma_sc_dev *dev,
+			  struct irdma_hmc_create_obj_info *info)
+{
+	return dev->hmc_ops->create_hmc_object(dev, info);
+}
+
+/**
+ * irdma_create_hmc_objs - create all hmc objects for the device
+ * @rf: RDMA PCI function
+ * @privileged: permission to create HMC objects
+ * @vers: HW version
+ *
+ * Create the device hmc objects and allocate hmc pages
+ * Return 0 if successful, otherwise clean up and return error
+ */
+static enum irdma_status_code
+irdma_create_hmc_objs(struct irdma_pci_f *rf, bool privileged, enum irdma_vers vers)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_hmc_create_obj_info info = {};
+	enum irdma_status_code status = 0;
+	int i;
+
+	info.hmc_info = dev->hmc_info;
+	info.privileged = privileged;
+	info.entry_type = rf->sd_type;
+
+	for (i = 0; i < IW_HMC_OBJ_TYPE_NUM; i++) {
+		if (dev->hmc_info->hmc_obj[iw_hmc_obj_types[i]].cnt) {
+			info.rsrc_type = iw_hmc_obj_types[i];
+			info.count = dev->hmc_info->hmc_obj[info.rsrc_type].cnt;
+			info.add_sd_cnt = 0;
+			status = irdma_create_hmc_obj_type(dev, &info);
+			if (status) {
+				dev_dbg(rfdev_to_dev(dev),
+					"ERR: create obj type %d status = %d\n",
+					iw_hmc_obj_types[i], status);
+				break;
+			}
+		}
+		if (vers == IRDMA_GEN_1 && i == IRDMA_HMC_IW_TIMER)
+			break;
+	}
+
+	if (!status)
+		return dev->hmc_ops->static_hmc_pages_allocated(dev->cqp, 0,
+								dev->hmc_fn_id,
+								true, true);
+
+	while (i) {
+		i--;
+		/* destroy the hmc objects of a given type */
+		irdma_close_hmc_objects_type(dev, iw_hmc_obj_types[i],
+					     dev->hmc_info, privileged, false);
+	}
+
+	return status;
+}
+
+/**
+ * irdma_obj_aligned_mem - get aligned memory from device allocated memory
+ * @rf: RDMA PCI function
+ * @memptr: points to the memory addresses
+ * @size: size of memory needed
+ * @mask: mask for the aligned memory
+ *
+ * Get aligned memory of the requested size and
+ * update the memptr to point to the new aligned memory
+ * Return 0 if successful, otherwise return no memory error
+ */
+static enum irdma_status_code
+irdma_obj_aligned_mem(struct irdma_pci_f *rf, struct irdma_dma_mem *memptr,
+		      u32 size, u32 mask)
+{
+	unsigned long va, newva;
+	unsigned long extra;
+
+	va = (unsigned long)rf->obj_next.va;
+	newva = va;
+	if (mask)
+		newva = ALIGN(va, (unsigned long)mask + 1ULL);
+	extra = newva - va;
+	memptr->va = (u8 *)va + extra;
+	memptr->pa = rf->obj_next.pa + extra;
+	memptr->size = size;
+	if ((memptr->va + size) > (rf->obj_mem.va + rf->obj_mem.size))
+		return IRDMA_ERR_NO_MEMORY;
+
+	rf->obj_next.va = memptr->va + size;
+	rf->obj_next.pa = memptr->pa + size;
+
+	return 0;
+}
+
+/**
+ * irdma_create_cqp - create control qp
+ * @rf: RDMA PCI function
+ *
+ * Return 0, if the cqp and all the resources associated with it
+ * are successfully created, otherwise return error
+ */
+static enum irdma_status_code irdma_create_cqp(struct irdma_pci_f *rf)
+{
+	enum irdma_status_code status;
+	u32 sqsize = IRDMA_CQP_SW_SQSIZE_2048;
+	struct irdma_dma_mem mem;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cqp_init_info cqp_init_info = {};
+	struct irdma_cqp *cqp = &rf->cqp;
+	u16 maj_err, min_err;
+	int i;
+
+	cqp->cqp_requests = kcalloc(sqsize, sizeof(*cqp->cqp_requests), GFP_KERNEL);
+	if (!cqp->cqp_requests)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp->scratch_array = kcalloc(sqsize, sizeof(*cqp->scratch_array), GFP_KERNEL);
+	if (!cqp->scratch_array) {
+		kfree(cqp->cqp_requests);
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	dev->cqp = &cqp->sc_cqp;
+	dev->cqp->dev = dev;
+	cqp->sq.size = ALIGN(sizeof(struct irdma_cqp_sq_wqe) * sqsize,
+			     IRDMA_CQP_ALIGNMENT);
+	cqp->sq.va = dma_alloc_coherent(hw_to_dev(dev->hw), cqp->sq.size,
+					&cqp->sq.pa, GFP_KERNEL);
+	if (!cqp->sq.va) {
+		kfree(cqp->scratch_array);
+		kfree(cqp->cqp_requests);
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	status = irdma_obj_aligned_mem(rf, &mem, sizeof(struct irdma_cqp_ctx),
+				       IRDMA_HOST_CTX_ALIGNMENT_M);
+	if (status)
+		goto exit;
+
+	dev->cqp->host_ctx_pa = mem.pa;
+	dev->cqp->host_ctx = mem.va;
+	/* populate the cqp init info */
+	cqp_init_info.dev = dev;
+	cqp_init_info.sq_size = sqsize;
+	cqp_init_info.sq = cqp->sq.va;
+	cqp_init_info.sq_pa = cqp->sq.pa;
+	cqp_init_info.host_ctx_pa = mem.pa;
+	cqp_init_info.host_ctx = mem.va;
+	cqp_init_info.hmc_profile = rf->rsrc_profile;
+	cqp_init_info.ena_vf_count = rf->max_rdma_vfs;
+	cqp_init_info.scratch_array = cqp->scratch_array;
+	cqp_init_info.disable_packed = true;
+	cqp_init_info.protocol_used = rf->protocol_used;
+	status = dev->cqp_ops->cqp_init(dev->cqp, &cqp_init_info);
+	if (status) {
+		dev_dbg(rfdev_to_dev(dev), "ERR: cqp init status %d\n",
+			status);
+		goto exit;
+	}
+
+	status = dev->cqp_ops->cqp_create(dev->cqp, &maj_err, &min_err);
+	if (status) {
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: cqp create failed - status %d maj_err %d min_err %d\n",
+			status, maj_err, min_err);
+		goto exit;
+	}
+
+	spin_lock_init(&cqp->req_lock);
+	spin_lock_init(&cqp->compl_lock);
+	INIT_LIST_HEAD(&cqp->cqp_avail_reqs);
+	INIT_LIST_HEAD(&cqp->cqp_pending_reqs);
+
+	/* init the waitqueue of the cqp_requests and add them to the list */
+	for (i = 0; i < sqsize; i++) {
+		init_waitqueue_head(&cqp->cqp_requests[i].waitq);
+		list_add_tail(&cqp->cqp_requests[i].list, &cqp->cqp_avail_reqs);
+	}
+	init_waitqueue_head(&cqp->remove_wq);
+	return 0;
+
+exit:
+	irdma_destroy_cqp(rf, false);
+
+	return status;
+}
+
+/**
+ * irdma_create_ccq - create control cq
+ * @rf: RDMA PCI function
+ *
+ * Return 0, if the ccq and the resources associated with it
+ * are successfully created, otherwise return error
+ */
+static enum irdma_status_code irdma_create_ccq(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+	struct irdma_ccq_init_info info = {};
+	struct irdma_ccq *ccq = &rf->ccq;
+
+	dev->ccq = &ccq->sc_cq;
+	dev->ccq->dev = dev;
+	info.dev = dev;
+	ccq->shadow_area.size = sizeof(struct irdma_cq_shadow_area);
+	ccq->mem_cq.size = ALIGN(sizeof(struct irdma_cqe) * IW_CCQ_SIZE,
+				 IRDMA_CQ0_ALIGNMENT);
+	ccq->mem_cq.va = dma_alloc_coherent(hw_to_dev(dev->hw),
+					    ccq->mem_cq.size, &ccq->mem_cq.pa,
+					    GFP_KERNEL);
+	if (!ccq->mem_cq.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	status = irdma_obj_aligned_mem(rf, &ccq->shadow_area,
+				       ccq->shadow_area.size,
+				       IRDMA_SHADOWAREA_M);
+	if (status)
+		goto exit;
+
+	ccq->sc_cq.back_cq = ccq;
+	/* populate the ccq init info */
+	info.cq_base = ccq->mem_cq.va;
+	info.cq_pa = ccq->mem_cq.pa;
+	info.num_elem = IW_CCQ_SIZE;
+	info.shadow_area = ccq->shadow_area.va;
+	info.shadow_area_pa = ccq->shadow_area.pa;
+	info.ceqe_mask = false;
+	info.ceq_id_valid = true;
+	info.shadow_read_threshold = 16;
+	info.vsi = &rf->default_vsi;
+	status = dev->ccq_ops->ccq_init(dev->ccq, &info);
+	if (!status)
+		status = dev->ccq_ops->ccq_create(dev->ccq, 0, true, true);
+exit:
+	if (status) {
+		dma_free_coherent(hw_to_dev(dev->hw), ccq->mem_cq.size,
+				  ccq->mem_cq.va, ccq->mem_cq.pa);
+		ccq->mem_cq.va = NULL;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_alloc_set_mac - set up a mac address table entry
+ * @iwdev: irdma device
+ *
+ * Allocate a mac ip entry and add it to the hw table Return 0
+ * if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_alloc_set_mac(struct irdma_device *iwdev)
+{
+	enum irdma_status_code status;
+
+	status = irdma_alloc_local_mac_entry(iwdev->rf,
+					     &iwdev->mac_ip_table_idx);
+	if (!status) {
+		status = irdma_add_local_mac_entry(iwdev->rf,
+						   (u8 *)iwdev->netdev->dev_addr,
+						   (u8)iwdev->mac_ip_table_idx);
+		if (status)
+			irdma_del_local_mac_entry(iwdev->rf,
+						  (u8)iwdev->mac_ip_table_idx);
+	}
+	return status;
+}
+
+/**
+ * irdma_configure_ceq_vector - set up the msix interrupt vector for ceq
+ * @rf: RDMA PCI function
+ * @iwceq: ceq associated with the vector
+ * @ceq_id: the id number of the iwceq
+ * @msix_vec: interrupt vector information
+ *
+ * Allocate interrupt resources and enable irq handling
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code
+irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
+		     u32 ceq_id, struct irdma_msix_vector *msix_vec)
+{
+	int status;
+
+	if (rf->msix_shared && !ceq_id) {
+		tasklet_init(&rf->dpc_tasklet, irdma_dpc, (unsigned long)rf);
+		status = request_irq(msix_vec->irq, irdma_irq_handler, 0,
+				     "AEQCEQ", rf);
+	} else {
+		tasklet_init(&iwceq->dpc_tasklet, irdma_ceq_dpc,
+			     (unsigned long)iwceq);
+
+		status = request_irq(msix_vec->irq, irdma_ceq_handler, 0, "CEQ",
+				     iwceq);
+	}
+
+	cpumask_clear(&msix_vec->mask);
+	cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
+	irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
+	if (status) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: ceq irq config fail\n");
+		return IRDMA_ERR_CFG;
+	}
+
+	msix_vec->ceq_id = ceq_id;
+	rf->sc_dev.irq_ops->irdma_cfg_ceq(&rf->sc_dev, ceq_id, msix_vec->idx);
+
+	return 0;
+}
+
+/**
+ * irdma_configure_aeq_vector - set up the msix vector for aeq
+ * @rf: RDMA PCI function
+ *
+ * Allocate interrupt resources and enable irq handling
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_cfg_aeq_vector(struct irdma_pci_f *rf)
+{
+	struct irdma_msix_vector *msix_vec = rf->iw_msixtbl;
+	u32 ret = 0;
+
+	if (!rf->msix_shared) {
+		tasklet_init(&rf->dpc_tasklet, irdma_dpc, (unsigned long)rf);
+		ret = request_irq(msix_vec->irq, irdma_irq_handler, 0, "irdma",
+				  rf);
+	}
+	if (ret) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: aeq irq config fail\n");
+		return IRDMA_ERR_CFG;
+	}
+
+	rf->sc_dev.irq_ops->irdma_cfg_aeq(&rf->sc_dev, msix_vec->idx);
+
+	return 0;
+}
+
+/**
+ * irdma_create_ceq - create completion event queue
+ * @rf: RDMA PCI function
+ * @iwceq: pointer to the ceq resources to be created
+ * @ceq_id: the id number of the iwceq
+ * @vsi: SC vsi struct
+ *
+ * Return 0, if the ceq and the resources associated with it
+ * are successfully created, otherwise return error
+ */
+static enum irdma_status_code irdma_create_ceq(struct irdma_pci_f *rf,
+					       struct irdma_ceq *iwceq,
+					       u32 ceq_id,
+					       struct irdma_sc_vsi *vsi)
+{
+	enum irdma_status_code status;
+	struct irdma_ceq_init_info info = {};
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	u64 scratch;
+
+	info.ceq_id = ceq_id;
+	iwceq->rf = rf;
+	iwceq->mem.size = ALIGN(sizeof(struct irdma_ceqe) * rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt,
+				IRDMA_CEQ_ALIGNMENT);
+	iwceq->mem.va = dma_alloc_coherent(hw_to_dev(dev->hw),
+					   iwceq->mem.size, &iwceq->mem.pa,
+					   GFP_KERNEL);
+	if (!iwceq->mem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	info.ceq_id = ceq_id;
+	info.ceqe_base = iwceq->mem.va;
+	info.ceqe_pa = iwceq->mem.pa;
+	info.elem_cnt = rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt;
+	iwceq->sc_ceq.ceq_id = ceq_id;
+	info.dev = dev;
+	info.vsi = vsi;
+	scratch = (uintptr_t)&rf->cqp.sc_cqp;
+	status = dev->ceq_ops->ceq_init(&iwceq->sc_ceq, &info);
+	if (!status) {
+		if (dev->ceq_valid)
+			status = irdma_cqp_ceq_cmd(&rf->sc_dev, &iwceq->sc_ceq,
+						   IRDMA_OP_CEQ_CREATE);
+		else
+			status = dev->ceq_ops->cceq_create(&iwceq->sc_ceq,
+							   scratch);
+	}
+
+	if (status) {
+		dma_free_coherent(hw_to_dev(dev->hw), iwceq->mem.size,
+				  iwceq->mem.va, iwceq->mem.pa);
+		iwceq->mem.va = NULL;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_setup_ceq_0 - create CEQ 0 and it's interrupt resource
+ * @rf: RDMA PCI function
+ *
+ * Allocate a list for all device completion event queues
+ * Create the ceq 0 and configure it's msix interrupt vector
+ * Return 0, if successfully set up, otherwise return error
+ */
+static enum irdma_status_code irdma_setup_ceq_0(struct irdma_pci_f *rf)
+{
+	u32 i;
+	struct irdma_ceq *iwceq;
+	struct irdma_msix_vector *msix_vec;
+	enum irdma_status_code status = 0;
+	u32 num_ceqs;
+
+	num_ceqs = min(rf->msix_count, rf->sc_dev.hmc_fpm_misc.max_ceqs);
+	rf->ceqlist = kcalloc(num_ceqs, sizeof(*rf->ceqlist), GFP_KERNEL);
+	if (!rf->ceqlist) {
+		status = IRDMA_ERR_NO_MEMORY;
+		goto exit;
+	}
+
+	i = rf->msix_shared ? 0 : 1;
+	iwceq = &rf->ceqlist[0];
+	status = irdma_create_ceq(rf, iwceq, 0, &rf->default_vsi);
+	if (status) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: create ceq status = %d\n", status);
+		goto exit;
+	}
+
+	msix_vec = &rf->iw_msixtbl[i];
+	iwceq->irq = msix_vec->irq;
+	iwceq->msix_idx = msix_vec->idx;
+	status = irdma_cfg_ceq_vector(rf, iwceq, 0, msix_vec);
+	if (status) {
+		irdma_destroy_ceq(rf, iwceq);
+		goto exit;
+	}
+
+	irdma_ena_intr(&rf->sc_dev, msix_vec->idx);
+	rf->ceqs_count++;
+
+exit:
+	if (status && !rf->ceqs_count) {
+		kfree(rf->ceqlist);
+		rf->ceqlist = NULL;
+		return status;
+	}
+	rf->sc_dev.ceq_valid = true;
+
+	return 0;
+}
+
+/**
+ * irdma_setup_ceqs - manage the device ceq's and their interrupt resources
+ * @rf: RDMA PCI function
+ * @vsi: VSI structure for this CEQ
+ *
+ * Allocate a list for all device completion event queues
+ * Create the ceq's and configure their msix interrupt vectors
+ * Return 0, if at least one ceq is successfully set up, otherwise return error
+ */
+static enum irdma_status_code irdma_setup_ceqs(struct irdma_pci_f *rf,
+					       struct irdma_sc_vsi *vsi)
+{
+	u32 i;
+	u32 ceq_id;
+	struct irdma_ceq *iwceq;
+	struct irdma_msix_vector *msix_vec;
+	enum irdma_status_code status = 0;
+	u32 num_ceqs;
+
+	num_ceqs = min(rf->msix_count, rf->sc_dev.hmc_fpm_misc.max_ceqs);
+	i = (rf->msix_shared) ? 1 : 2;
+	for (ceq_id = 1; i < num_ceqs; i++, ceq_id++) {
+		iwceq = &rf->ceqlist[ceq_id];
+		status = irdma_create_ceq(rf, iwceq, ceq_id, vsi);
+		if (status) {
+			dev_dbg(rfdev_to_dev(&rf->sc_dev),
+				"ERR: create ceq status = %d\n", status);
+			break;
+		}
+		msix_vec = &rf->iw_msixtbl[i];
+		iwceq->irq = msix_vec->irq;
+		iwceq->msix_idx = msix_vec->idx;
+		status = irdma_cfg_ceq_vector(rf, iwceq, ceq_id, msix_vec);
+		if (status) {
+			irdma_destroy_ceq(rf, iwceq);
+			break;
+		}
+		irdma_ena_intr(&rf->sc_dev, msix_vec->idx);
+		rf->ceqs_count++;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_create_aeq - create async event queue
+ * @rf: RDMA PCI function
+ *
+ * Return 0, if the aeq and the resources associated with it
+ * are successfully created, otherwise return error
+ */
+static enum irdma_status_code irdma_create_aeq(struct irdma_pci_f *rf)
+{
+	enum irdma_status_code status;
+	struct irdma_aeq_init_info info = {};
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_aeq *aeq = &rf->aeq;
+	struct irdma_hmc_info *hmc_info = rf->sc_dev.hmc_info;
+	u64 scratch = 0;
+	u32 aeq_size;
+
+	aeq_size = 2 * hmc_info->hmc_obj[IRDMA_HMC_IW_QP].cnt +
+		   hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt;
+	aeq->mem.size = ALIGN(sizeof(struct irdma_sc_aeqe) * aeq_size,
+			      IRDMA_AEQ_ALIGNMENT);
+	aeq->mem.va = dma_alloc_coherent(hw_to_dev(dev->hw), aeq->mem.size,
+					 &aeq->mem.pa, GFP_KERNEL);
+	if (!aeq->mem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	info.aeqe_base = aeq->mem.va;
+	info.aeq_elem_pa = aeq->mem.pa;
+	info.elem_cnt = aeq_size;
+	info.dev = dev;
+	status = dev->aeq_ops->aeq_init(&aeq->sc_aeq, &info);
+	if (status)
+		goto exit;
+
+	status = dev->aeq_ops->aeq_create(&aeq->sc_aeq, scratch, 1);
+	if (!status)
+		status = dev->aeq_ops->aeq_create_done(&aeq->sc_aeq);
+exit:
+	if (status) {
+		dma_free_coherent(hw_to_dev(dev->hw), aeq->mem.size,
+				  aeq->mem.va, aeq->mem.pa);
+		aeq->mem.va = NULL;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_setup_aeq - set up the device aeq
+ * @rf: RDMA PCI function
+ *
+ * Create the aeq and configure its msix interrupt vector
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_setup_aeq(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+
+	status = irdma_create_aeq(rf);
+	if (status)
+		return status;
+
+	status = irdma_cfg_aeq_vector(rf);
+	if (status) {
+		irdma_destroy_aeq(rf);
+		return status;
+	}
+
+	if (!rf->msix_shared)
+		irdma_ena_intr(dev, rf->iw_msixtbl[0].idx);
+
+	return 0;
+}
+
+/**
+ * irdma_initialize_ilq - create iwarp local queue for cm
+ * @iwdev: irdma device
+ *
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_initialize_ilq(struct irdma_device *iwdev)
+{
+	struct irdma_puda_rsrc_info info = {};
+	enum irdma_status_code status;
+
+	info.type = IRDMA_PUDA_RSRC_TYPE_ILQ;
+	info.cq_id = 1;
+	info.qp_id = 1;
+	info.count = 1;
+	info.pd_id = 1;
+	info.sq_size = min(iwdev->rf->max_qp / 2, (u32)32768);
+	info.rq_size = info.sq_size;
+	info.buf_size = 1024;
+	info.tx_buf_cnt = 2 * info.sq_size;
+	info.receive = irdma_receive_ilq;
+	info.xmit_complete = irdma_free_sqbuf;
+	status = irdma_puda_create_rsrc(&iwdev->vsi, &info);
+	if (status)
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"ERR: ilq create fail\n");
+
+	return status;
+}
+
+/**
+ * irdma_initialize_ieq - create iwarp exception queue
+ * @iwdev: irdma device
+ *
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_initialize_ieq(struct irdma_device *iwdev)
+{
+	struct irdma_puda_rsrc_info info = {};
+	enum irdma_status_code status;
+
+	info.type = IRDMA_PUDA_RSRC_TYPE_IEQ;
+	info.cq_id = 2;
+	info.qp_id = iwdev->vsi.exception_lan_q;
+	info.count = 1;
+	info.pd_id = 2;
+	info.sq_size = min(iwdev->rf->max_qp / 2, (u32)32768);
+	info.rq_size = info.sq_size;
+	info.buf_size = iwdev->vsi.mtu + IRDMA_IPV4_PAD;
+	info.tx_buf_cnt = 4096;
+	status = irdma_puda_create_rsrc(&iwdev->vsi, &info);
+	if (status)
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"ERR: ieq create fail\n");
+
+	return status;
+}
+
+/**
+ * irdma_reinitialize_ieq - destroy and re-create ieq
+ * @vsi: VSI structure
+ */
+void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct irdma_pci_f *rf = iwdev->rf;
+
+	irdma_puda_dele_rsrc(vsi, IRDMA_PUDA_RSRC_TYPE_IEQ, false);
+	if (irdma_initialize_ieq(iwdev)) {
+		iwdev->reset = true;
+		rf->gen_ops.request_reset(rf);
+	}
+}
+
+/**
+ * irdma_hmc_setup - create hmc objects for the device
+ * @rf: RDMA PCI function
+ *
+ * Set up the device private memory space for the number and size of
+ * the hmc objects and create the objects
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_hmc_setup(struct irdma_pci_f *rf)
+{
+	enum irdma_status_code status;
+	u32 qpcnt;
+
+	if (rf->rdma_ver == IRDMA_GEN_1)
+		qpcnt = rsrc_limits_table[rf->limits_sel].qplimit * 2;
+	else
+		qpcnt = rsrc_limits_table[rf->limits_sel].qplimit;
+
+	rf->sd_type = IRDMA_SD_TYPE_DIRECT;
+	status = irdma_cfg_fpm_val(&rf->sc_dev, qpcnt);
+	if (status)
+		return status;
+
+	status = irdma_create_hmc_objs(rf, true, rf->rdma_ver);
+
+	return status;
+}
+
+/**
+ * irdma_del_init_mem - deallocate memory resources
+ * @rf: RDMA PCI function
+ */
+static void irdma_del_init_mem(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+
+	kfree(dev->hmc_info->sd_table.sd_entry);
+	dev->hmc_info->sd_table.sd_entry = NULL;
+	kfree(rf->mem_rsrc);
+	rf->mem_rsrc = NULL;
+	dma_free_coherent(hw_to_dev(&rf->hw), rf->obj_mem.size,
+			  rf->obj_mem.va, rf->obj_mem.pa);
+	rf->obj_mem.va = NULL;
+	if (rf->rdma_ver != IRDMA_GEN_1) {
+		kfree(rf->allocated_ws_nodes);
+		rf->allocated_ws_nodes = NULL;
+	}
+	kfree(rf->ceqlist);
+	rf->ceqlist = NULL;
+	kfree(rf->iw_msixtbl);
+	rf->iw_msixtbl = NULL;
+	kfree(rf->hmc_info_mem);
+	rf->hmc_info_mem = NULL;
+}
+/**
+ * irdma_initialize_dev - initialize device
+ * @rf: RDMA PCI function
+ * @ldev: lan device information
+ *
+ * Allocate memory for the hmc objects and initialize iwdev
+ * Return 0 if successful, otherwise clean up the resources
+ * and return error
+ */
+static enum irdma_status_code irdma_initialize_dev(struct irdma_pci_f *rf,
+						   struct irdma_priv_ldev *ldev)
+{
+	enum irdma_status_code status;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_device_init_info info = {};
+	struct irdma_dma_mem mem;
+	u32 size;
+
+	size = sizeof(struct irdma_hmc_pble_rsrc) +
+	       sizeof(struct irdma_hmc_info) +
+	       (sizeof(struct irdma_hmc_obj_info) * IRDMA_HMC_IW_MAX);
+
+	rf->hmc_info_mem = kzalloc(size, GFP_KERNEL);
+	if (!rf->hmc_info_mem)
+		return IRDMA_ERR_NO_MEMORY;
+
+	rf->pble_rsrc = (struct irdma_hmc_pble_rsrc *)rf->hmc_info_mem;
+	dev->hmc_info = &rf->hw.hmc;
+	dev->hmc_info->hmc_obj = (struct irdma_hmc_obj_info *)
+				 (rf->pble_rsrc + 1);
+
+	status = irdma_obj_aligned_mem(rf, &mem, IRDMA_QUERY_FPM_BUF_SIZE,
+				       IRDMA_FPM_QUERY_BUF_ALIGNMENT_M);
+	if (status)
+		goto error;
+
+	info.fpm_query_buf_pa = mem.pa;
+	info.fpm_query_buf = mem.va;
+	info.init_hw = rf->gen_ops.init_hw;
+
+	status = irdma_obj_aligned_mem(rf, &mem, IRDMA_COMMIT_FPM_BUF_SIZE,
+				       IRDMA_FPM_COMMIT_BUF_ALIGNMENT_M);
+	if (status)
+		goto error;
+
+	info.fpm_commit_buf_pa = mem.pa;
+	info.fpm_commit_buf = mem.va;
+
+	info.bar0 = rf->hw.hw_addr;
+	info.hmc_fn_id = (u8)ldev->fn_num;
+	info.privileged = !ldev->ftype;
+	info.hw = &rf->hw;
+	info.vchnl_send = NULL;
+	status = irdma_sc_ctrl_init(rf->rdma_ver, &rf->sc_dev, &info);
+	if (status)
+		goto error;
+
+	return status;
+error:
+	kfree(rf->hmc_info_mem);
+	rf->hmc_info_mem = NULL;
+
+	return status;
+}
+
+/**
+ * irdma_rt_deinit_hw - clean up the irdma device resources
+ * @iwdev: irdma device
+ *
+ * remove the mac ip entry and ipv4/ipv6 addresses, destroy the
+ * device queues and free the pble and the hmc objects
+ */
+void irdma_rt_deinit_hw(struct irdma_device *iwdev)
+{
+	dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev), "INIT: state = %d\n",
+		iwdev->init_state);
+
+	switch (iwdev->init_state) {
+	case IP_ADDR_REGISTERED:
+		if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+			irdma_del_local_mac_entry(iwdev->rf,
+						  (u8)iwdev->mac_ip_table_idx);
+		/* fallthrough */
+	case PBLE_CHUNK_MEM:
+		/* fallthrough */
+	case CEQS_CREATED:
+		/* fallthrough */
+	case IEQ_CREATED:
+		irdma_puda_dele_rsrc(&iwdev->vsi, IRDMA_PUDA_RSRC_TYPE_IEQ,
+				     iwdev->reset);
+		/* fallthrough */
+	case ILQ_CREATED:
+		if (iwdev->create_ilq)
+			irdma_puda_dele_rsrc(&iwdev->vsi,
+					     IRDMA_PUDA_RSRC_TYPE_ILQ,
+					     iwdev->reset);
+		break;
+	default:
+		dev_warn(rfdev_to_dev(&iwdev->rf->sc_dev),
+			 "bad init_state = %d\n", iwdev->init_state);
+		break;
+	}
+
+	irdma_cleanup_cm_core(&iwdev->cm_core);
+	if (iwdev->vsi.pestat) {
+		irdma_vsi_stats_free(&iwdev->vsi);
+		kfree(iwdev->vsi.pestat);
+	}
+	destroy_workqueue(iwdev->cleanup_wq);
+	list_del(&iwdev->list);
+}
+
+/**
+ * irdma_setup_init_state - set up the initial device struct
+ * @rf: RDMA PCI function
+ *
+ * Initialize the iwarp device and its hdl information
+ * using the ldev and client information
+ * Return 0 if successful, otherwise return error
+ */
+static enum irdma_status_code irdma_setup_init_state(struct irdma_pci_f *rf)
+{
+	struct irdma_priv_ldev *ldev = &rf->ldev;
+	enum irdma_status_code status;
+
+	status = irdma_save_msix_info(rf);
+	if (status)
+		return status;
+
+	rf->hw.pdev = rf->pdev;
+	rf->obj_mem.size = ALIGN(8192, IRDMA_HW_PAGE_SIZE);
+	rf->obj_mem.va = dma_alloc_coherent(hw_to_dev(&rf->hw),
+					    rf->obj_mem.size, &rf->obj_mem.pa,
+					    GFP_KERNEL);
+	if (!rf->obj_mem.va) {
+		kfree(rf->iw_msixtbl);
+		rf->iw_msixtbl = NULL;
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	rf->obj_next = rf->obj_mem;
+	rf->ooo = false;
+	init_waitqueue_head(&rf->vchnl_waitq);
+	status = irdma_initialize_dev(rf, ldev);
+	if (status) {
+		kfree(rf->iw_msixtbl);
+		dma_free_coherent(hw_to_dev(&rf->hw), rf->obj_mem.size,
+				  rf->obj_mem.va, rf->obj_mem.pa);
+		rf->obj_mem.va = NULL;
+		rf->iw_msixtbl = NULL;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_get_used_rsrc - determine resources used internally
+ * @iwdev: irdma device
+ *
+ * Called at the end of open to get all internal allocations
+ */
+static void irdma_get_used_rsrc(struct irdma_device *iwdev)
+{
+	iwdev->rf->used_pds = find_next_zero_bit(iwdev->rf->allocated_pds,
+						 iwdev->rf->max_pd, 0);
+	iwdev->rf->used_qps = find_next_zero_bit(iwdev->rf->allocated_qps,
+						 iwdev->rf->max_qp, 0);
+	iwdev->rf->used_cqs = find_next_zero_bit(iwdev->rf->allocated_cqs,
+						 iwdev->rf->max_cq, 0);
+	iwdev->rf->used_mrs = find_next_zero_bit(iwdev->rf->allocated_mrs,
+						 iwdev->rf->max_mr, 0);
+}
+
+void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf)
+{
+	enum init_completion_state state = rf->init_state;
+
+	rf->init_state = INVALID_STATE;
+	if (rf->rsrc_created) {
+		irdma_destroy_pble_prm(rf->pble_rsrc);
+		irdma_del_ceqs(rf);
+		rf->rsrc_created = false;
+	}
+	switch (state) {
+	case CEQ0_CREATED:
+		irdma_del_ceq_0(rf);
+		/* fallthrough */
+	case AEQ_CREATED:
+		irdma_destroy_aeq(rf);
+		/* fallthrough */
+	case CCQ_CREATED:
+		irdma_destroy_ccq(rf);
+		/* fallthrough */
+	case HW_RSRC_INITIALIZED:
+		/* fallthrough */
+	case HMC_OBJS_CREATED:
+		irdma_del_hmc_objects(&rf->sc_dev, rf->sc_dev.hmc_info, true,
+				      rf->reset, rf->rdma_ver);
+		/* fallthrough */
+	case CQP_CREATED:
+		irdma_destroy_cqp(rf, true);
+		/* fallthrough */
+	case INITIAL_STATE:
+		irdma_del_init_mem(rf);
+		break;
+	case INVALID_STATE:
+		/* fallthrough */
+	default:
+		pr_warn("bad init_state = %d\n", rf->init_state);
+		break;
+	}
+}
+
+/**
+ * irdma_rt_init_hw - Initializes runtime portion of HW
+ * @rf: RDMA PCI function
+ * @iwdev: irdma device
+ * @l2params: qos, tc, mtu info from netdev driver
+ *
+ * Create device queues ILQ, IEQ, CEQs and PBLEs. Setup irdma
+ * device resource objects.
+ */
+enum irdma_status_code irdma_rt_init_hw(struct irdma_pci_f *rf,
+					struct irdma_device *iwdev,
+					struct irdma_l2params *l2params)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+	struct irdma_vsi_init_info vsi_info = {};
+	struct irdma_vsi_stats_info stats_info = {};
+
+	list_add(&iwdev->list, &rf->vsi_dev_list);
+	irdma_sc_rt_init(dev);
+	vsi_info.vm_vf_type = rf->ldev.ftype ? IRDMA_VF_TYPE : IRDMA_PF_TYPE;
+	vsi_info.dev = dev;
+	vsi_info.back_vsi = iwdev;
+	vsi_info.params = l2params;
+	vsi_info.pf_data_vsi_num = iwdev->vsi_num;
+	vsi_info.register_qset = rf->gen_ops.register_qset;
+	vsi_info.unregister_qset = rf->gen_ops.unregister_qset;
+	vsi_info.exception_lan_q = 2;
+	irdma_sc_vsi_init(&iwdev->vsi, &vsi_info);
+
+	status = irdma_setup_cm_core(iwdev, rf->rdma_ver);
+	if (status)
+		return status;
+
+	stats_info.pestat = kzalloc(sizeof(*stats_info.pestat), GFP_KERNEL);
+	if (!stats_info.pestat) {
+		irdma_cleanup_cm_core(&iwdev->cm_core);
+		list_del(&iwdev->list);
+		return IRDMA_ERR_NO_MEMORY;
+	}
+	stats_info.fcn_id = dev->hmc_fn_id;
+	status = irdma_vsi_stats_init(&iwdev->vsi, &stats_info);
+	if (status) {
+		irdma_cleanup_cm_core(&iwdev->cm_core);
+		kfree(stats_info.pestat);
+		list_del(&iwdev->list);
+		return status;
+	}
+
+	do {
+		if (iwdev->create_ilq) {
+			status = irdma_initialize_ilq(iwdev);
+			if (status)
+				break;
+			iwdev->init_state = ILQ_CREATED;
+		}
+		status = irdma_initialize_ieq(iwdev);
+		if (status)
+			break;
+		iwdev->init_state = IEQ_CREATED;
+		if (!rf->rsrc_created) {
+			status = irdma_setup_ceqs(rf, &iwdev->vsi);
+			if (status)
+				break;
+			iwdev->init_state = CEQS_CREATED;
+
+			status = irdma_hmc_init_pble(&rf->sc_dev,
+						     rf->pble_rsrc);
+			if (status) {
+				irdma_del_ceqs(rf);
+				break;
+			}
+			spin_lock_init(&rf->pble_rsrc->pble_lock);
+			iwdev->init_state = PBLE_CHUNK_MEM;
+			rf->rsrc_created = true;
+		}
+
+		iwdev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY |
+					  IB_DEVICE_MEM_WINDOW |
+					  IB_DEVICE_MEM_MGT_EXTENSIONS;
+
+		if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+			irdma_alloc_set_mac(iwdev);
+		irdma_add_ip(iwdev);
+		iwdev->init_state = IP_ADDR_REGISTERED;
+
+		/* handles asynch cleanup tasks - disconnect CM , free qp,
+		 * free cq bufs
+		 */
+		iwdev->cleanup_wq = alloc_workqueue("irdma-cleanup-wq",
+					WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
+		if (!iwdev->cleanup_wq)
+			return IRDMA_ERR_NO_MEMORY;
+		irdma_get_used_rsrc(iwdev);
+		init_waitqueue_head(&iwdev->suspend_wq);
+
+		return 0;
+	} while (0);
+
+	dev_err(rfdev_to_dev(dev), "VSI open FAIL status = %d last cmpl = %d\n",
+		status, iwdev->init_state);
+	irdma_rt_deinit_hw(iwdev);
+
+	return status;
+}
+
+/**
+ * irdma_ctrl_init_hw - Initializes control portion of HW
+ * @rf: RDMA PCI function
+ *
+ * Create admin queues, HMC obejcts and RF resource objects
+ */
+enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+
+	INIT_LIST_HEAD(&rf->vsi_dev_list);
+
+	do {
+		status = irdma_setup_init_state(rf);
+		if (status)
+			break;
+		rf->init_state = INITIAL_STATE;
+
+		status = irdma_create_cqp(rf);
+		if (status)
+			break;
+		rf->init_state = CQP_CREATED;
+
+		status = irdma_hmc_setup(rf);
+		if (status)
+			break;
+		rf->init_state = HMC_OBJS_CREATED;
+
+		status = irdma_initialize_hw_rsrc(rf);
+		if (status)
+			break;
+		rf->init_state = HW_RSRC_INITIALIZED;
+
+		status = irdma_create_ccq(rf);
+		if (status)
+			break;
+		rf->init_state = CCQ_CREATED;
+
+		status = irdma_setup_aeq(rf);
+		if (status)
+			break;
+		rf->init_state = AEQ_CREATED;
+		rf->sc_dev.feature_info[IRDMA_FEATURE_FW_INFO] = IRDMA_FW_VER_DEFAULT;
+
+		if (rf->rdma_ver != IRDMA_GEN_1)
+			status = irdma_get_rdma_features(&rf->sc_dev);
+		if (!status) {
+			u32 fw_ver = dev->feature_info[IRDMA_FEATURE_FW_INFO];
+			u8 hw_rev = dev->hw_attrs.uk_attrs.hw_rev;
+
+			if ((hw_rev == IRDMA_GEN_1 && fw_ver >= IRDMA_FW_VER_0x30010) ||
+			    (hw_rev != IRDMA_GEN_1 && fw_ver >= IRDMA_FW_VER_0x1000D))
+
+				dev->hw_attrs.uk_attrs.feature_flags |= IRDMA_FEATURE_RTS_AE |
+									IRDMA_FEATURE_CQ_RESIZE;
+		}
+
+		status = irdma_setup_ceq_0(rf);
+		if (status)
+			break;
+		rf->init_state = CEQ0_CREATED;
+		/* Handles processing of CQP completions */
+		rf->cqp_cmpl_wq = alloc_ordered_workqueue("cqp_cmpl_wq",
+						WQ_HIGHPRI | WQ_UNBOUND);
+		if (!rf->cqp_cmpl_wq) {
+			status = IRDMA_ERR_NO_MEMORY;
+			break;
+		}
+		INIT_WORK(&rf->cqp_cmpl_work, cqp_compl_worker);
+		dev->ccq_ops->ccq_arm(dev->ccq);
+		return 0;
+	} while (0);
+
+	pr_err("IRDMA hardware initialization FAILED init_state=%d status=%d\n",
+	       rf->init_state, status);
+	irdma_ctrl_deinit_hw(rf);
+	return status;
+}
+
+/**
+ * irdma_initialize_hw_resources - initialize hw resource tracking array
+ * @rf: RDMA PCI function
+ */
+u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf)
+{
+	unsigned long num_pds;
+	u32 rsrc_size;
+	u32 max_mr;
+	u32 max_qp;
+	u32 max_cq;
+	u32 arp_table_size;
+	u32 mrdrvbits;
+	void *rsrc_ptr;
+	u32 num_ahs;
+	u32 num_mcg;
+
+	if (rf->rdma_ver != IRDMA_GEN_1) {
+		rf->allocated_ws_nodes =
+			kcalloc(BITS_TO_LONGS(IRDMA_MAX_WS_NODES),
+				sizeof(unsigned long), GFP_KERNEL);
+		if (!rf->allocated_ws_nodes)
+			return -ENOMEM;
+
+		set_bit(0, rf->allocated_ws_nodes);
+		rf->max_ws_node_id = IRDMA_MAX_WS_NODES;
+	}
+	max_qp = rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_QP].cnt;
+	max_cq = rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].cnt;
+	max_mr = rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_MR].cnt;
+	arp_table_size = rf->sc_dev.hmc_info->hmc_obj[IRDMA_HMC_IW_ARP].cnt;
+	rf->max_cqe = rf->sc_dev.hw_attrs.uk_attrs.max_hw_cq_size;
+	num_pds = rf->sc_dev.hw_attrs.max_hw_pds;
+	rsrc_size = sizeof(struct irdma_arp_entry) * arp_table_size;
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(max_qp);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(max_mr);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(max_cq);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(num_pds);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(arp_table_size);
+	num_ahs = max_qp * 4;
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(num_ahs);
+	num_mcg = max_qp;
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(num_mcg);
+	rsrc_size += sizeof(struct irdma_qp **) * max_qp;
+
+	rf->mem_rsrc = kzalloc(rsrc_size, GFP_KERNEL);
+	if (!rf->mem_rsrc) {
+		kfree(rf->allocated_ws_nodes);
+		rf->allocated_ws_nodes = NULL;
+		return -ENOMEM;
+	}
+
+	rf->max_qp = max_qp;
+	rf->max_mr = max_mr;
+	rf->max_cq = max_cq;
+	rf->max_pd = num_pds;
+	rf->arp_table_size = arp_table_size;
+	rf->arp_table = (struct irdma_arp_entry *)rf->mem_rsrc;
+	rsrc_ptr = rf->mem_rsrc +
+		   (sizeof(struct irdma_arp_entry) * arp_table_size);
+	rf->max_ah = num_ahs;
+	rf->max_mcg = num_mcg;
+	rf->allocated_qps = rsrc_ptr;
+	rf->allocated_cqs = &rf->allocated_qps[BITS_TO_LONGS(max_qp)];
+	rf->allocated_mrs = &rf->allocated_cqs[BITS_TO_LONGS(max_cq)];
+	rf->allocated_pds = &rf->allocated_mrs[BITS_TO_LONGS(max_mr)];
+	rf->allocated_ahs = &rf->allocated_pds[BITS_TO_LONGS(num_pds)];
+	rf->allocated_mcgs = &rf->allocated_ahs[BITS_TO_LONGS(num_ahs)];
+	rf->allocated_arps = &rf->allocated_mcgs[BITS_TO_LONGS(num_mcg)];
+	rf->qp_table = (struct irdma_qp **)
+		       (&rf->allocated_arps[BITS_TO_LONGS(arp_table_size)]);
+
+	set_bit(0, rf->allocated_mrs);
+	set_bit(0, rf->allocated_qps);
+	set_bit(0, rf->allocated_cqs);
+	set_bit(0, rf->allocated_pds);
+	set_bit(0, rf->allocated_arps);
+	set_bit(0, rf->allocated_ahs);
+	set_bit(0, rf->allocated_mcgs);
+	set_bit(2, rf->allocated_qps); /* qp 2 IEQ */
+	set_bit(1, rf->allocated_qps); /* qp 1 ILQ */
+	set_bit(1, rf->allocated_cqs);
+	set_bit(1, rf->allocated_pds);
+	set_bit(2, rf->allocated_cqs);
+	set_bit(2, rf->allocated_pds);
+
+	spin_lock_init(&rf->rsrc_lock);
+	spin_lock_init(&rf->arp_lock);
+	spin_lock_init(&rf->qptable_lock);
+	spin_lock_init(&rf->qh_list_lock);
+
+	INIT_LIST_HEAD(&rf->mc_qht_list.list);
+	/* stag index mask has a minimum of 14 bits */
+	mrdrvbits = 24 - max(get_count_order(rf->max_mr), 14);
+	rf->mr_stagmask = ~(((1 << mrdrvbits) - 1) << (32 - mrdrvbits));
+
+	return 0;
+}
+
+/**
+ * irdma_cqp_ce_handler - handle cqp completions
+ * @rf: RDMA PCI function
+ * @cq: cq for cqp completions
+ */
+void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	u32 cqe_count = 0;
+	struct irdma_ccq_cqe_info info;
+	unsigned long flags;
+	int ret;
+
+	do {
+		memset(&info, 0, sizeof(info));
+		spin_lock_irqsave(&rf->cqp.compl_lock, flags);
+		ret = dev->ccq_ops->ccq_get_cqe_info(cq, &info);
+		spin_unlock_irqrestore(&rf->cqp.compl_lock, flags);
+		if (ret)
+			break;
+
+		cqp_request = (struct irdma_cqp_request *)
+			      (unsigned long)info.scratch;
+		if (info.error)
+			dev_dbg(rfdev_to_dev(dev),
+				"ERR: opcode = 0x%x maj_err_code = 0x%x min_err_code = 0x%x\n",
+				info.op_code, info.maj_err_code,
+				info.min_err_code);
+		if (cqp_request) {
+			cqp_request->compl_info.maj_err_code = info.maj_err_code;
+			cqp_request->compl_info.min_err_code = info.min_err_code;
+			cqp_request->compl_info.op_ret_val = info.op_ret_val;
+			cqp_request->compl_info.error = info.error;
+
+			if (cqp_request->waiting) {
+				cqp_request->request_done = true;
+				wake_up(&cqp_request->waitq);
+				irdma_put_cqp_request(&rf->cqp, cqp_request);
+			} else {
+				if (cqp_request->callback_fcn)
+					cqp_request->callback_fcn(cqp_request);
+				irdma_put_cqp_request(&rf->cqp, cqp_request);
+			}
+		}
+
+		cqe_count++;
+	} while (1);
+
+	if (cqe_count) {
+		irdma_process_bh(dev);
+		dev->ccq_ops->ccq_arm(cq);
+	}
+}
+
+/**
+ * cqp_compl_worker - Handle cqp completions
+ * @work: Pointer to work structure
+ */
+void cqp_compl_worker(struct work_struct *work)
+{
+	struct irdma_pci_f *rf = container_of(work, struct irdma_pci_f,
+					      cqp_cmpl_work);
+	struct irdma_sc_cq *cq = &rf->ccq.sc_cq;
+
+	irdma_cqp_ce_handler(rf, cq);
+}
+
+/**
+ * irdma_next_iw_state - modify qp state
+ * @iwqp: iwarp qp to modify
+ * @state: next state for qp
+ * @del_hash: del hash
+ * @term: term message
+ * @termlen: length of term message
+ */
+void irdma_next_iw_state(struct irdma_qp *iwqp, u8 state, u8 del_hash, u8 term,
+			 u8 termlen)
+{
+	struct irdma_modify_qp_info info = {};
+
+	info.next_iwarp_state = state;
+	info.remove_hash_idx = del_hash;
+	info.cq_num_valid = true;
+	info.arp_cache_idx_valid = true;
+	info.dont_send_term = true;
+	info.dont_send_fin = true;
+	info.termlen = termlen;
+
+	if (term & IRDMAQP_TERM_SEND_TERM_ONLY)
+		info.dont_send_term = false;
+	if (term & IRDMAQP_TERM_SEND_FIN_ONLY)
+		info.dont_send_fin = false;
+	if (iwqp->sc_qp.term_flags && state == IRDMA_QP_STATE_ERROR)
+		info.reset_tcp_conn = true;
+	iwqp->hw_iwarp_state = state;
+	irdma_hw_modify_qp(iwqp->iwdev, iwqp, &info, 0);
+	iwqp->iwarp_state = info.next_iwarp_state;
+}
+
+/**
+ * irdma_del_mac_entry - remove a mac entry from the hw table
+ * @rf: RDMA PCI function
+ * @idx: the index of the mac ip address to delete
+ */
+void irdma_del_local_mac_entry(struct irdma_pci_f *rf, u16 idx)
+{
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status = 0;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request) {
+		pr_err("cqp_request memory failed\n");
+		return;
+	}
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_DELETE_LOCAL_MAC_ENTRY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.del_local_mac_entry.cqp = &iwcqp->sc_cqp;
+	cqp_info->in.u.del_local_mac_entry.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.del_local_mac_entry.entry_idx = idx;
+	cqp_info->in.u.del_local_mac_entry.ignore_ref_count = 0;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		pr_err("CQP-OP Del MAC entry fail");
+}
+
+/**
+ * irdma_add_mac_entry - add a mac ip address entry to the hw table
+ * @rf: RDMA PCI function
+ * @mac_addr: pointer to mac address
+ * @idx: the index of the mac ip address to add
+ */
+int irdma_add_local_mac_entry(struct irdma_pci_f *rf, u8 *mac_addr, u16 idx)
+{
+	struct irdma_local_mac_entry_info *info;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status = 0;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request) {
+		pr_err("cqp_request memory failed\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	cqp_info = &cqp_request->info;
+	cqp_info->post_sq = 1;
+	info = &cqp_info->in.u.add_local_mac_entry.info;
+	ether_addr_copy(info->mac_addr, mac_addr);
+	info->entry_idx = idx;
+	cqp_info->in.u.add_local_mac_entry.scratch = (uintptr_t)cqp_request;
+	cqp_info->cqp_cmd = IRDMA_OP_ADD_LOCAL_MAC_ENTRY;
+	cqp_info->in.u.add_local_mac_entry.cqp = &iwcqp->sc_cqp;
+	cqp_info->in.u.add_local_mac_entry.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		pr_err("CQP-OP Add MAC entry fail");
+
+	return status;
+}
+
+/**
+ * irdma_alloc_local_mac_entry - allocate a mac entry
+ * @rf: RDMA PCI function
+ * @mac_tbl_idx: the index of the new mac address
+ *
+ * Allocate a mac address entry and update the mac_tbl_idx
+ * to hold the index of the newly created mac address
+ * Return 0 if successful, otherwise return error
+ */
+int irdma_alloc_local_mac_entry(struct irdma_pci_f *rf, u16 *mac_tbl_idx)
+{
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status = 0;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request) {
+		pr_err("cqp_request memory failed\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	/* increment refcount, because we need the cqp request ret value */
+	refcount_inc(&cqp_request->refcnt);
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_ALLOC_LOCAL_MAC_ENTRY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.alloc_local_mac_entry.cqp = &iwcqp->sc_cqp;
+	cqp_info->in.u.alloc_local_mac_entry.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (!status)
+		*mac_tbl_idx = (u16)cqp_request->compl_info.op_ret_val;
+	else
+		pr_err("CQP-OP Alloc MAC entry fail");
+	/* decrement refcount and free the cqp request, if no longer used */
+	irdma_put_cqp_request(iwcqp, cqp_request);
+
+	return status;
+}
+
+/**
+ * irdma_cqp_manage_apbvt_cmd - send cqp command manage apbvt
+ * @iwdev: irdma device
+ * @accel_local_port: port for apbvt
+ * @add_port: add ordelete port
+ */
+static enum irdma_status_code
+irdma_cqp_manage_apbvt_cmd(struct irdma_device *iwdev, u16 accel_local_port,
+			   bool add_port)
+{
+	struct irdma_apbvt_info *info;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(&iwdev->rf->cqp, add_port);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	info = &cqp_info->in.u.manage_apbvt_entry.info;
+	memset(info, 0, sizeof(*info));
+	info->add = add_port;
+	info->port = accel_local_port;
+	cqp_info->cqp_cmd = IRDMA_OP_MANAGE_APBVT_ENTRY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.manage_apbvt_entry.cqp = &iwdev->rf->cqp.sc_cqp;
+	cqp_info->in.u.manage_apbvt_entry.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(iwdev->rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"ERR: CQP-OP Manage APBVT entry fail");
+
+	return status;
+}
+
+/**
+ * irdma_manage_apbvt - add or delete tcp port
+ * @iwdev: irdma device
+ * @accel_local_port: port for apbvt
+ * @add_port: add or delete port
+ */
+enum irdma_status_code irdma_manage_apbvt(struct irdma_device *iwdev,
+					  u16 accel_local_port, bool add_port)
+{
+	struct irdma_cm_core *cm_core = &iwdev->cm_core;
+	enum irdma_status_code status = 0;
+	unsigned long flags;
+	bool in_use;
+
+	/* apbvt_lock is held across CQP delete APBVT OP (non-waiting) to
+	 * protect against race where add APBVT CQP can race ahead of the delete
+	 * APBVT for same port.
+	 */
+	if (add_port) {
+		spin_lock_irqsave(&cm_core->apbvt_lock, flags);
+		in_use = __test_and_set_bit(accel_local_port,
+					    cm_core->ports_in_use);
+		spin_unlock_irqrestore(&cm_core->apbvt_lock, flags);
+		if (in_use)
+			return 0;
+		return irdma_cqp_manage_apbvt_cmd(iwdev, accel_local_port,
+						  true);
+	} else {
+		spin_lock_irqsave(&cm_core->apbvt_lock, flags);
+		in_use = irdma_port_in_use(cm_core, accel_local_port);
+		if (in_use) {
+			spin_unlock_irqrestore(&cm_core->apbvt_lock, flags);
+			return 0;
+		}
+		__clear_bit(accel_local_port, cm_core->ports_in_use);
+		status = irdma_cqp_manage_apbvt_cmd(iwdev, accel_local_port,
+						    false);
+		spin_unlock_irqrestore(&cm_core->apbvt_lock, flags);
+		return status;
+	}
+}
+
+/**
+ * irdma_manage_arp_cache - manage hw arp cache
+ * @rf: RDMA PCI function
+ * @mac_addr: mac address ptr
+ * @ip_addr: ip addr for arp cache
+ * @ipv4: flag inicating IPv4
+ * @action: add, delete or modify
+ */
+void irdma_manage_arp_cache(struct irdma_pci_f *rf, unsigned char *mac_addr,
+			    u32 *ip_addr, bool ipv4, u32 action)
+{
+	struct irdma_add_arp_cache_entry_info *info;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	int arp_index;
+
+	arp_index = irdma_arp_table(rf, ip_addr, ipv4, mac_addr, action);
+	if (arp_index == -1)
+		return;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	if (action == IRDMA_ARP_ADD) {
+		cqp_info->cqp_cmd = IRDMA_OP_ADD_ARP_CACHE_ENTRY;
+		info = &cqp_info->in.u.add_arp_cache_entry.info;
+		memset(info, 0, sizeof(*info));
+		info->arp_index = (u16)arp_index;
+		info->permanent = true;
+		ether_addr_copy(info->mac_addr, mac_addr);
+		cqp_info->in.u.add_arp_cache_entry.scratch =
+			(uintptr_t)cqp_request;
+		cqp_info->in.u.add_arp_cache_entry.cqp = &rf->cqp.sc_cqp;
+	} else {
+		cqp_info->cqp_cmd = IRDMA_OP_DELETE_ARP_CACHE_ENTRY;
+		cqp_info->in.u.del_arp_cache_entry.scratch =
+			(uintptr_t)cqp_request;
+		cqp_info->in.u.del_arp_cache_entry.cqp = &rf->cqp.sc_cqp;
+		cqp_info->in.u.del_arp_cache_entry.arp_index = arp_index;
+	}
+
+	cqp_info->in.u.add_arp_cache_entry.cqp = &rf->cqp.sc_cqp;
+	cqp_info->in.u.add_arp_cache_entry.scratch = (uintptr_t)cqp_request;
+	cqp_info->post_sq = 1;
+	if (irdma_handle_cqp_op(rf, cqp_request))
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP-OP Add/Del Arp Cache entry fail");
+}
+
+/**
+ * irdma_send_syn_cqp_callback - do syn/ack after qhash
+ * @cqp_request: qhash cqp completion
+ */
+static void irdma_send_syn_cqp_callback(struct irdma_cqp_request *cqp_request)
+{
+	irdma_send_syn(cqp_request->param, 1);
+}
+
+/**
+ * irdma_manage_qhash - add or modify qhash
+ * @iwdev: irdma device
+ * @cminfo: cm info for qhash
+ * @etype: type (syn or quad)
+ * @mtype: type of qhash
+ * @cmnode: cmnode associated with connection
+ * @wait: wait for completion
+ */
+enum irdma_status_code
+irdma_manage_qhash(struct irdma_device *iwdev, struct irdma_cm_info *cminfo,
+		   enum irdma_quad_entry_type etype,
+		   enum irdma_quad_hash_manage_type mtype, void *cmnode,
+		   bool wait)
+{
+	struct irdma_qhash_table_info *info;
+	struct irdma_sc_dev *dev = &iwdev->rf->sc_dev;
+	enum irdma_status_code status;
+	struct irdma_cqp *iwcqp = &iwdev->rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	info = &cqp_info->in.u.manage_qhash_table_entry.info;
+	memset(info, 0, sizeof(*info));
+	info->vsi = &iwdev->vsi;
+	info->manage = mtype;
+	info->entry_type = etype;
+	if (cminfo->vlan_id < VLAN_N_VID) {
+		info->vlan_valid = true;
+		info->vlan_id = cminfo->vlan_id;
+	} else {
+		info->vlan_valid = false;
+	}
+	info->ipv4_valid = cminfo->ipv4;
+	info->user_pri = cminfo->user_pri;
+	ether_addr_copy(info->mac_addr, iwdev->netdev->dev_addr);
+	info->qp_num = cminfo->qh_qpid;
+	info->dest_port = cminfo->loc_port;
+	info->dest_ip[0] = cminfo->loc_addr[0];
+	info->dest_ip[1] = cminfo->loc_addr[1];
+	info->dest_ip[2] = cminfo->loc_addr[2];
+	info->dest_ip[3] = cminfo->loc_addr[3];
+	if (etype == IRDMA_QHASH_TYPE_TCP_ESTABLISHED ||
+	    etype == IRDMA_QHASH_TYPE_UDP_UNICAST ||
+	    etype == IRDMA_QHASH_TYPE_UDP_MCAST ||
+	    etype == IRDMA_QHASH_TYPE_ROCE_MCAST ||
+	    etype == IRDMA_QHASH_TYPE_ROCEV2_HW) {
+		info->src_port = cminfo->rem_port;
+		info->src_ip[0] = cminfo->rem_addr[0];
+		info->src_ip[1] = cminfo->rem_addr[1];
+		info->src_ip[2] = cminfo->rem_addr[2];
+		info->src_ip[3] = cminfo->rem_addr[3];
+	}
+	if (cmnode) {
+		cqp_request->callback_fcn = irdma_send_syn_cqp_callback;
+		cqp_request->param = cmnode;
+	}
+	if (info->ipv4_valid)
+		dev_dbg(rfdev_to_dev(dev),
+			"CM: %s IP=%pI4, port=%d, mac=%pM, vlan_id=%d\n",
+			!mtype ? "DELETE" : "ADD", info->dest_ip,
+			info->dest_port, info->mac_addr, cminfo->vlan_id);
+	else
+		dev_dbg(rfdev_to_dev(dev),
+			"CM: %s IP=%pI6, port=%d, mac=%pM, vlan_id=%d\n",
+			!mtype ? "DELETE" : "ADD", info->dest_ip,
+			info->dest_port, info->mac_addr, cminfo->vlan_id);
+	cqp_info->in.u.manage_qhash_table_entry.cqp = &iwdev->rf->cqp.sc_cqp;
+	cqp_info->in.u.manage_qhash_table_entry.scratch = (uintptr_t)cqp_request;
+	cqp_info->cqp_cmd = IRDMA_OP_MANAGE_QHASH_TABLE_ENTRY;
+	cqp_info->post_sq = 1;
+	status = irdma_handle_cqp_op(iwdev->rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: CQP-OP Manage Qhash Entry fail");
+
+	return status;
+}
+
+/**
+ * irdma_post_qp_fatal - Post QP_FATAL event associated with given QP
+ * @qp: QP associated with QP_FATL event
+ */
+static inline void irdma_post_qp_fatal(struct irdma_qp *qp)
+{
+	struct ib_event ibevent;
+
+	if (qp->ibqp.event_handler) {
+		ibevent.device = qp->ibqp.device;
+		ibevent.event = IB_EVENT_QP_FATAL;
+		ibevent.element.qp = &qp->ibqp;
+		qp->ibqp.event_handler(&ibevent, qp->ibqp.qp_context);
+	}
+}
+
+/**
+ * irdma_hw_flush_wqes_callback - Check return code after flush
+ * @cqp_request: qhash cqp completion
+ */
+static void irdma_hw_flush_wqes_callback(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_qp_flush_info *hw_info;
+	struct irdma_sc_qp *qp;
+	struct irdma_qp *iwqp;
+	struct cqp_cmds_info *cqp_info;
+
+	cqp_info = &cqp_request->info;
+	hw_info = &cqp_request->info.in.u.qp_flush_wqes.info;
+	qp = cqp_info->in.u.qp_flush_wqes.qp;
+	iwqp = qp->qp_uk.back_qp;
+
+	if (cqp_request->compl_info.maj_err_code)
+		return;
+	if (hw_info->rq &&
+	    (cqp_request->compl_info.min_err_code == IRDMA_CQP_COMPL_SQ_WQE_FLUSHED ||
+	     cqp_request->compl_info.min_err_code == 0)) {
+		/* RQ WQE flush was requested but did not happen */
+		qp->qp_uk.rq_flush_complete = true;
+		complete(&iwqp->rq_drained);
+	}
+	if (hw_info->sq &&
+	    (cqp_request->compl_info.min_err_code == IRDMA_CQP_COMPL_RQ_WQE_FLUSHED ||
+	     cqp_request->compl_info.min_err_code == 0)) {
+		qp->qp_uk.sq_flush_complete = true;
+		complete(&iwqp->sq_drained);
+	}
+}
+
+/**
+ * irdma_hw_flush_wqes - flush qp's wqe
+ * @rf: RDMA PCI function
+ * @qp: hardware control qp
+ * @info: info for flush
+ * @wait: flag wait for completion
+ */
+enum irdma_status_code irdma_hw_flush_wqes(struct irdma_pci_f *rf,
+					   struct irdma_sc_qp *qp,
+					   struct irdma_qp_flush_info *info,
+					   bool wait)
+{
+	enum irdma_status_code status;
+	struct irdma_qp_flush_info *hw_info;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_qp *iwqp = qp->qp_uk.back_qp;
+	unsigned long flags = 0;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	if (!wait)
+		cqp_request->callback_fcn = irdma_hw_flush_wqes_callback;
+	hw_info = &cqp_request->info.in.u.qp_flush_wqes.info;
+	memcpy(hw_info, info, sizeof(*hw_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_FLUSH_WQES;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_flush_wqes.qp = qp;
+	cqp_info->in.u.qp_flush_wqes.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP-OP Flush WQE's fail");
+		complete(&iwqp->sq_drained);
+		complete(&iwqp->rq_drained);
+		qp->qp_uk.sq_flush_complete = true;
+		qp->qp_uk.rq_flush_complete = true;
+		return status;
+	}
+
+	if (!wait || cqp_request->compl_info.maj_err_code)
+		return 0;
+
+	if (info->rq) {
+		if (cqp_request->compl_info.min_err_code == IRDMA_CQP_COMPL_SQ_WQE_FLUSHED ||
+		    cqp_request->compl_info.min_err_code == 0) {
+			/* RQ WQE flush was requested but did not happen */
+			qp->qp_uk.rq_flush_complete = true;
+			complete(&iwqp->rq_drained);
+		}
+	}
+	if (info->sq) {
+		if (cqp_request->compl_info.min_err_code == IRDMA_CQP_COMPL_RQ_WQE_FLUSHED ||
+		    cqp_request->compl_info.min_err_code == 0) {
+			spin_lock_irqsave(&iwqp->lock, flags);
+			/*
+			 * Handling case where WQE is posted to empty SQ when
+			 * flush has not completed
+			 */
+			if (IRDMA_RING_MORE_WORK(qp->qp_uk.sq_ring)) {
+				struct irdma_cqp_request *new_req;
+
+				if (!qp->qp_uk.sq_flush_complete) {
+					spin_unlock_irqrestore(&iwqp->lock, flags);
+					return 0;
+				}
+				qp->qp_uk.sq_flush_complete = false;
+				qp->flush_sq = false;
+				spin_unlock_irqrestore(&iwqp->lock, flags);
+
+				info->rq = false;
+				info->sq = true;
+				new_req = irdma_get_cqp_request(&rf->cqp, true);
+				if (!new_req)
+					return IRDMA_ERR_NO_MEMORY;
+				cqp_info = &new_req->info;
+				hw_info = &new_req->info.in.u.qp_flush_wqes.info;
+				memcpy(hw_info, info, sizeof(*hw_info));
+				cqp_info->cqp_cmd = IRDMA_OP_QP_FLUSH_WQES;
+				cqp_info->post_sq = 1;
+				cqp_info->in.u.qp_flush_wqes.qp = qp;
+				cqp_info->in.u.qp_flush_wqes.scratch = (uintptr_t)new_req;
+
+				status = irdma_handle_cqp_op(rf, new_req);
+				if (new_req->compl_info.maj_err_code ||
+				    new_req->compl_info.min_err_code != IRDMA_CQP_COMPL_SQ_WQE_FLUSHED ||
+				    status) {
+					pr_err("SQ in error but not flushed");
+					qp->qp_uk.sq_flush_complete = false;
+					irdma_post_qp_fatal(iwqp);
+				}
+			} else {
+				/* SQ WQE flush was requested but did not happen */
+				qp->qp_uk.sq_flush_complete = true;
+				spin_unlock_irqrestore(&iwqp->lock, flags);
+				complete(&iwqp->sq_drained);
+			}
+		} else {
+			spin_lock_irqsave(&iwqp->lock, flags);
+			if (!IRDMA_RING_MORE_WORK(qp->qp_uk.sq_ring)) {
+				qp->qp_uk.sq_flush_complete = true;
+				spin_unlock_irqrestore(&iwqp->lock, flags);
+				complete(&iwqp->sq_drained);
+			} else {
+				spin_unlock_irqrestore(&iwqp->lock, flags);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_gen_ae - generate AE
+ * @rf: RDMA PCI function
+ * @qp: qp associated with AE
+ * @info: info for ae
+ * @wait: wait for completion
+ */
+void irdma_gen_ae(struct irdma_pci_f *rf, struct irdma_sc_qp *qp,
+		  struct irdma_gen_ae_info *info, bool wait)
+{
+	struct irdma_gen_ae_info *ae_info;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	ae_info = &cqp_request->info.in.u.gen_ae.info;
+	memcpy(ae_info, info, sizeof(*ae_info));
+	cqp_info->cqp_cmd = IRDMA_OP_GEN_AE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.gen_ae.qp = qp;
+	cqp_info->in.u.gen_ae.scratch = (uintptr_t)cqp_request;
+	if (irdma_handle_cqp_op(rf, cqp_request))
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP OP failed attempting to generate ae_code=0x%x\n",
+			info->ae_code);
+}
+
+/**
+ * irdma_get_ib_wc - return change flush code to IB's
+ * @opcode: iwarp flush code
+ */
+static enum ib_wc_status irdma_get_ib_wc(enum irdma_flush_opcode opcode)
+{
+	switch (opcode) {
+	case FLUSH_PROT_ERR:
+		return IB_WC_LOC_PROT_ERR;
+	case FLUSH_REM_ACCESS_ERR:
+		return IB_WC_REM_ACCESS_ERR;
+	case FLUSH_LOC_QP_OP_ERR:
+		return IB_WC_LOC_QP_OP_ERR;
+	case FLUSH_REM_OP_ERR:
+		return IB_WC_REM_OP_ERR;
+	case FLUSH_LOC_LEN_ERR:
+		return IB_WC_LOC_LEN_ERR;
+	case FLUSH_GENERAL_ERR:
+		return IB_WC_GENERAL_ERR;
+	case FLUSH_FATAL_ERR:
+	default:
+		return IB_WC_FATAL_ERR;
+	}
+}
+
+void irdma_flush_wqes(struct irdma_qp *iwqp, u32 flush_mask)
+{
+	struct irdma_qp_flush_info info = {};
+	struct irdma_pci_f *rf = iwqp->iwdev->rf;
+	u8 opcode = iwqp->sc_qp.flush_code;
+
+	if (!(flush_mask & IRDMA_FLUSH_SQ)  && !(flush_mask & IRDMA_FLUSH_RQ))
+		return;
+
+	/* Set flush info fields*/
+	info.sq = flush_mask & IRDMA_FLUSH_SQ;
+	info.rq = flush_mask & IRDMA_FLUSH_RQ;
+
+	if (flush_mask & IRDMA_REFLUSH) {
+		if (info.sq)
+			iwqp->sc_qp.flush_sq = false;
+		if (info.rq)
+			iwqp->sc_qp.flush_rq = false;
+	}
+
+	/* Generate userflush errors in CQE */
+	if (opcode) {
+		if (info.sq) {
+			info.sq_minor_code = (u16)irdma_get_ib_wc(opcode);
+			info.sq_major_code = IRDMA_FLUSH_MAJOR_ERR;
+		}
+		if (info.rq) {
+			info.rq_minor_code = (u16)irdma_get_ib_wc(opcode);
+			info.rq_major_code = IRDMA_FLUSH_MAJOR_ERR;
+		}
+		info.userflushcode = true;
+	}
+
+	if (irdma_upload_context && !(flush_mask & IRDMA_REFLUSH) &&
+	    irdma_upload_qp_context(iwqp, 0, 1))
+		dev_warn(rfdev_to_dev(&rf->sc_dev),
+			 "failed to upload QP context\n");
+
+	/* Issue flush */
+	(void)irdma_hw_flush_wqes(rf, &iwqp->sc_qp, &info,
+				  flush_mask & IRDMA_FLUSH_WAIT);
+	iwqp->flush_issued = true;
+}
diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.c b/drivers/infiniband/hw/irdma/i40iw_hw.c
new file mode 100644
index 000000000000..8abee8aaf6f5
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "osdep.h"
+#include "type.h"
+#include "i40iw_hw.h"
+#include "status.h"
+#include "protos.h"
+
+#define I40E_CQPSQ_CQ_CQID_SHIFT 0
+#define I40E_CQPSQ_CQ_CQID_MASK \
+	(0xffffULL << I40E_CQPSQ_CQ_CQID_SHIFT)
+
+static u32 i40iw_regs[IRDMA_MAX_REGS] = {
+	I40E_PFPE_CQPTAIL,
+	I40E_PFPE_CQPDB,
+	I40E_PFPE_CCQPSTATUS,
+	I40E_PFPE_CCQPHIGH,
+	I40E_PFPE_CCQPLOW,
+	I40E_PFPE_CQARM,
+	I40E_PFPE_CQACK,
+	I40E_PFPE_AEQALLOC,
+	I40E_PFPE_CQPERRCODES,
+	I40E_PFPE_WQEALLOC,
+	I40E_PFINT_DYN_CTLN(0),
+	I40IW_DB_ADDR_OFFSET,
+
+	I40E_GLPCI_LBARCTRL,
+	I40E_GLPE_CPUSTATUS0,
+	I40E_GLPE_CPUSTATUS1,
+	I40E_GLPE_CPUSTATUS2,
+	I40E_PFINT_AEQCTL,
+	I40E_PFINT_CEQCTL(0),
+	I40E_VSIQF_CTL(0),
+	I40E_PFHMC_PDINV,
+	I40E_GLHMC_VFPDINV(0)
+};
+
+static u32 i40iw_stat_offsets_32[IRDMA_HW_STAT_INDEX_MAX_32] = {
+	I40E_GLPES_PFIP4RXDISCARD(0),
+	I40E_GLPES_PFIP4RXTRUNC(0),
+	I40E_GLPES_PFIP4TXNOROUTE(0),
+	I40E_GLPES_PFIP6RXDISCARD(0),
+	I40E_GLPES_PFIP6RXTRUNC(0),
+	I40E_GLPES_PFIP6TXNOROUTE(0),
+	I40E_GLPES_PFTCPRTXSEG(0),
+	I40E_GLPES_PFTCPRXOPTERR(0),
+	I40E_GLPES_PFTCPRXPROTOERR(0),
+	I40E_GLPES_PFRXVLANERR(0)
+};
+
+static u32 i40iw_stat_offsets_64[IRDMA_HW_STAT_INDEX_MAX_64] = {
+	I40E_GLPES_PFIP4RXOCTSLO(0),
+	I40E_GLPES_PFIP4RXPKTSLO(0),
+	I40E_GLPES_PFIP4RXFRAGSLO(0),
+	I40E_GLPES_PFIP4RXMCPKTSLO(0),
+	I40E_GLPES_PFIP4TXOCTSLO(0),
+	I40E_GLPES_PFIP4TXPKTSLO(0),
+	I40E_GLPES_PFIP4TXFRAGSLO(0),
+	I40E_GLPES_PFIP4TXMCPKTSLO(0),
+	I40E_GLPES_PFIP6RXOCTSLO(0),
+	I40E_GLPES_PFIP6RXPKTSLO(0),
+	I40E_GLPES_PFIP6RXFRAGSLO(0),
+	I40E_GLPES_PFIP6RXMCPKTSLO(0),
+	I40E_GLPES_PFIP6TXOCTSLO(0),
+	I40E_GLPES_PFIP6TXPKTSLO(0),
+	I40E_GLPES_PFIP6TXFRAGSLO(0),
+	I40E_GLPES_PFIP6TXMCPKTSLO(0),
+	I40E_GLPES_PFTCPRXSEGSLO(0),
+	I40E_GLPES_PFTCPTXSEGLO(0),
+	I40E_GLPES_PFRDMARXRDSLO(0),
+	I40E_GLPES_PFRDMARXSNDSLO(0),
+	I40E_GLPES_PFRDMARXWRSLO(0),
+	I40E_GLPES_PFRDMATXRDSLO(0),
+	I40E_GLPES_PFRDMATXSNDSLO(0),
+	I40E_GLPES_PFRDMATXWRSLO(0),
+	I40E_GLPES_PFRDMAVBNDLO(0),
+	I40E_GLPES_PFRDMAVINVLO(0),
+	I40E_GLPES_PFIP4RXMCOCTSLO(0),
+	I40E_GLPES_PFIP4TXMCOCTSLO(0),
+	I40E_GLPES_PFIP6RXMCOCTSLO(0),
+	I40E_GLPES_PFIP6TXMCOCTSLO(0),
+	I40E_GLPES_PFUDPRXPKTSLO(0),
+	I40E_GLPES_PFUDPTXPKTSLO(0)
+};
+
+static u64 i40iw_masks[IRDMA_MAX_MASKS] = {
+	I40E_PFPE_CCQPSTATUS_CCQP_DONE_MASK,
+	I40E_PFPE_CCQPSTATUS_CCQP_ERR_MASK,
+	I40E_CQPSQ_STAG_PDID_MASK,
+	I40E_CQPSQ_CQ_CEQID_MASK,
+	I40E_CQPSQ_CQ_CQID_MASK,
+};
+
+static u64 i40iw_shifts[IRDMA_MAX_SHIFTS] = {
+	I40E_PFPE_CCQPSTATUS_CCQP_DONE_SHIFT,
+	I40E_PFPE_CCQPSTATUS_CCQP_ERR_SHIFT,
+	I40E_CQPSQ_STAG_PDID_SHIFT,
+	I40E_CQPSQ_CQ_CEQID_SHIFT,
+	I40E_CQPSQ_CQ_CQID_SHIFT,
+};
+
+static struct irdma_irq_ops i40iw_irq_ops;
+
+/**
+ * i40iw_config_ceq- Configure CEQ interrupt
+ * @dev: pointer to the device structure
+ * @ceq_id: Completion Event Queue ID
+ * @idx: vector index
+ */
+static void i40iw_config_ceq(struct irdma_sc_dev *dev, u32 ceq_id, u32 idx)
+{
+	u32 reg_val;
+
+	reg_val = (ceq_id << I40E_PFINT_LNKLSTN_FIRSTQ_INDX_SHIFT);
+	reg_val |= (QUEUE_TYPE_CEQ << I40E_PFINT_LNKLSTN_FIRSTQ_TYPE_SHIFT);
+	wr32(dev->hw, I40E_PFINT_LNKLSTN(idx - 1), reg_val);
+
+	reg_val = (0x3 << I40E_PFINT_DYN_CTLN_ITR_INDX_SHIFT);
+	reg_val |= I40E_PFINT_DYN_CTLN_INTENA_MASK;
+	wr32(dev->hw, I40E_PFINT_DYN_CTLN(idx - 1), reg_val);
+
+	reg_val = (IRDMA_GLINT_CEQCTL_CAUSE_ENA_M |
+		   (idx << IRDMA_GLINT_CEQCTL_MSIX_INDX_S) |
+		   IRDMA_GLINT_CEQCTL_ITR_INDX_M);
+	reg_val |= (NULL_QUEUE_INDEX << I40E_PFINT_CEQCTL_NEXTQ_INDX_SHIFT);
+
+	wr32(dev->hw, i40iw_regs[IRDMA_GLINT_CEQCTL] + 4 * ceq_id, reg_val);
+}
+
+/**
+ * i40iw_ena_irq - Enable interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ */
+static void i40iw_ena_irq(struct irdma_sc_dev *dev, u32 idx)
+{
+	u32 val;
+
+	val = IRDMA_GLINT_DYN_CTL_INTENA_M | IRDMA_GLINT_DYN_CTL_CLEARPBA_M |
+	      IRDMA_GLINT_DYN_CTL_ITR_INDX_M;
+	wr32(dev->hw, i40iw_regs[IRDMA_GLINT_DYN_CTL] + 4 * (idx - 1), val);
+}
+
+/**
+ * irdma_disable_irq - Disable interrupt
+ * @dev: pointer to the device structure
+ * @idx: vector index
+ */
+static void i40iw_disable_irq(struct irdma_sc_dev *dev, u32 idx)
+{
+	wr32(dev->hw, i40iw_regs[IRDMA_GLINT_DYN_CTL] + 4 * (idx - 1), 0);
+}
+
+void i40iw_init_hw(struct irdma_sc_dev *dev)
+{
+	int i;
+	u8 __iomem *hw_addr;
+
+	for (i = 0; i < IRDMA_MAX_REGS; ++i) {
+		hw_addr = dev->hw->hw_addr;
+
+		if (i == IRDMA_DB_ADDR_OFFSET)
+			hw_addr = NULL;
+
+		dev->hw_regs[i] = (u32 __iomem *)(i40iw_regs[i] + hw_addr);
+	}
+
+	for (i = 0; i < IRDMA_HW_STAT_INDEX_MAX_32; ++i)
+		dev->hw_stats_regs_32[i] = i40iw_stat_offsets_32[i];
+
+	for (i = 0; i < IRDMA_HW_STAT_INDEX_MAX_64; ++i)
+		dev->hw_stats_regs_64[i] = i40iw_stat_offsets_64[i];
+
+	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
+		dev->hw_shifts[i] = i40iw_shifts[i];
+
+	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
+		dev->hw_masks[i] = i40iw_masks[i];
+
+	dev->wqe_alloc_db = dev->hw_regs[IRDMA_WQEALLOC];
+	dev->cq_arm_db = dev->hw_regs[IRDMA_CQARM];
+	dev->aeq_alloc_db = dev->hw_regs[IRDMA_AEQALLOC];
+	dev->cqp_db = dev->hw_regs[IRDMA_CQPDB];
+	dev->cq_ack_db = dev->hw_regs[IRDMA_CQACK];
+	dev->ceq_itr_mask_db = NULL;
+	dev->aeq_itr_mask_db = NULL;
+
+	memcpy(&i40iw_irq_ops, dev->irq_ops, sizeof(i40iw_irq_ops));
+	i40iw_irq_ops.irdma_en_irq = i40iw_ena_irq;
+	i40iw_irq_ops.irdma_dis_irq = i40iw_disable_irq;
+	i40iw_irq_ops.irdma_cfg_ceq = i40iw_config_ceq;
+	dev->irq_ops = &i40iw_irq_ops;
+
+	/* Setup the hardware limits, hmc may limit further */
+	dev->hw_attrs.uk_attrs.max_hw_wq_frags = I40IW_MAX_WQ_FRAGMENT_COUNT;
+	dev->hw_attrs.uk_attrs.max_hw_read_sges = I40IW_MAX_SGE_RD;
+	dev->hw_attrs.max_hw_device_pages = I40IW_MAX_PUSH_PAGE_COUNT;
+	dev->hw_attrs.first_hw_vf_fpm_id = I40IW_FIRST_VF_FPM_ID;
+	dev->hw_attrs.uk_attrs.max_hw_inline = I40IW_MAX_INLINE_DATA_SIZE;
+	dev->hw_attrs.max_hw_ird = I40IW_MAX_IRD_SIZE;
+	dev->hw_attrs.max_hw_ord = I40IW_MAX_ORD_SIZE;
+	dev->hw_attrs.max_hw_wqes = I40IW_MAX_WQ_ENTRIES;
+	dev->hw_attrs.uk_attrs.max_hw_rq_quanta = I40IW_QP_SW_MAX_RQ_QUANTA;
+	dev->hw_attrs.uk_attrs.max_hw_wq_quanta = I40IW_QP_SW_MAX_WQ_QUANTA;
+	dev->hw_attrs.uk_attrs.max_hw_sq_chunk = I40IW_MAX_QUANTA_PER_WR;
+	dev->hw_attrs.max_hw_pds = I40IW_MAX_PDS;
+	dev->hw_attrs.max_stat_inst = I40IW_MAX_STATS_COUNT;
+	dev->hw_attrs.max_hw_outbound_msg_size = I40IW_MAX_OUTBOUND_MSG_SIZE;
+	dev->hw_attrs.max_hw_inbound_msg_size = I40IW_MAX_INBOUND_MSG_SIZE;
+	dev->hw_attrs.max_qp_wr = I40IW_MAX_QP_WRS;
+}
diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.h b/drivers/infiniband/hw/irdma/i40iw_hw.h
new file mode 100644
index 000000000000..058b25211d4a
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.h
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef I40IW_HW_H
+#define I40IW_HW_H
+#define I40E_VFPE_CQPTAIL1            0x0000A000 /* Reset: VFR */
+#define I40E_VFPE_CQPDB1              0x0000BC00 /* Reset: VFR */
+#define I40E_VFPE_CCQPSTATUS1         0x0000B800 /* Reset: VFR */
+#define I40E_VFPE_CCQPHIGH1           0x00009800 /* Reset: VFR */
+#define I40E_VFPE_CCQPLOW1            0x0000AC00 /* Reset: VFR */
+#define I40E_VFPE_CQARM1              0x0000B400 /* Reset: VFR */
+#define I40E_VFPE_CQACK1              0x0000B000 /* Reset: VFR */
+#define I40E_VFPE_AEQALLOC1           0x0000A400 /* Reset: VFR */
+#define I40E_VFPE_CQPERRCODES1        0x00009C00 /* Reset: VFR */
+#define I40E_VFPE_WQEALLOC1           0x0000C000 /* Reset: VFR */
+#define I40E_VFINT_DYN_CTLN(_INTVF)   (0x00024800 + ((_INTVF) * 4)) /* _i=0...511 */ /* Reset: VFR */
+
+#define I40E_PFPE_CQPTAIL             0x00008080 /* Reset: PFR */
+
+#define I40E_PFPE_CQPDB               0x00008000 /* Reset: PFR */
+#define I40E_PFPE_CCQPSTATUS          0x00008100 /* Reset: PFR */
+#define I40E_PFPE_CCQPHIGH            0x00008200 /* Reset: PFR */
+#define I40E_PFPE_CCQPLOW             0x00008180 /* Reset: PFR */
+#define I40E_PFPE_CQARM               0x00131080 /* Reset: PFR */
+#define I40E_PFPE_CQACK               0x00131100 /* Reset: PFR */
+#define I40E_PFPE_AEQALLOC            0x00131180 /* Reset: PFR */
+#define I40E_PFPE_CQPERRCODES         0x00008880 /* Reset: PFR */
+#define I40E_PFPE_WQEALLOC            0x00138C00 /* Reset: PFR */
+#define I40E_GLPCI_LBARCTRL           0x000BE484 /* Reset: POR */
+#define I40E_GLPE_CPUSTATUS0          0x0000D040 /* Reset: PE_CORER */
+#define I40E_GLPE_CPUSTATUS1          0x0000D044 /* Reset: PE_CORER */
+#define I40E_GLPE_CPUSTATUS2          0x0000D048 /* Reset: PE_CORER */
+#define I40E_PFHMC_PDINV              0x000C0300 /* Reset: PFR */
+#define I40E_GLHMC_VFPDINV(_i)        (0x000C8300 + ((_i) * 4)) /* _i=0...31 */ /* Reset: CORER */
+#define I40E_PFINT_DYN_CTLN(_INTPF)   (0x00034800 + ((_INTPF) * 4)) /* _i=0...511 */	/* Reset: PFR */
+#define I40E_PFINT_AEQCTL             0x00038700 /* Reset: CORER */
+
+#define I40E_GLPES_PFIP4RXDISCARD(_i)            (0x00010600 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXTRUNC(_i)              (0x00010700 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXNOROUTE(_i)            (0x00012E00 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXDISCARD(_i)            (0x00011200 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXTRUNC(_i)              (0x00011300 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+
+#define I40E_GLPES_PFRDMAVBNDLO(_i)              (0x00014800 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXMCOCTSLO(_i)           (0x00012000 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXMCOCTSLO(_i)           (0x00011600 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6TXMCOCTSLO(_i)           (0x00012A00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFUDPRXPKTSLO(_i)             (0x00013800 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFUDPTXPKTSLO(_i)             (0x00013A00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+
+#define I40E_GLPES_PFIP6TXNOROUTE(_i)            (0x00012F00 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFTCPRTXSEG(_i)               (0x00013600 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFTCPRXOPTERR(_i)             (0x00013200 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFTCPRXPROTOERR(_i)           (0x00013300 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRXVLANERR(_i)               (0x00010000 + ((_i) * 4)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXOCTSLO(_i)             (0x00010200 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXPKTSLO(_i)             (0x00010400 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXFRAGSLO(_i)            (0x00010800 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXMCPKTSLO(_i)           (0x00010C00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXOCTSLO(_i)             (0x00011A00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXPKTSLO(_i)             (0x00011C00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXFRAGSLO(_i)            (0x00011E00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4TXMCPKTSLO(_i)           (0x00012200 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXOCTSLO(_i)             (0x00010E00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXPKTSLO(_i)             (0x00011000 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXFRAGSLO(_i)            (0x00011400 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6TXOCTSLO(_i)             (0x00012400 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6TXPKTSLO(_i)             (0x00012600 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6TXFRAGSLO(_i)            (0x00012800 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6TXMCPKTSLO(_i)           (0x00012C00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFTCPTXSEGLO(_i)              (0x00013400 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMARXRDSLO(_i)             (0x00013E00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMARXSNDSLO(_i)            (0x00014000 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMARXWRSLO(_i)             (0x00013C00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMATXRDSLO(_i)             (0x00014400 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMATXSNDSLO(_i)            (0x00014600 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMATXWRSLO(_i)             (0x00014200 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP4RXMCOCTSLO(_i)           (0x00010A00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFIP6RXMCPKTSLO(_i)           (0x00011800 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFTCPRXSEGSLO(_i)             (0x00013000 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+#define I40E_GLPES_PFRDMAVINVLO(_i)              (0x00014A00 + ((_i) * 8)) /* _i=0...15 */ /* Reset: PE_CORER */
+
+#define I40IW_DB_ADDR_OFFSET    (4 * 1024 * 1024 - 64 * 1024)
+
+#define I40IW_VF_DB_ADDR_OFFSET (64 * 1024)
+
+#define I40E_PFINT_LNKLSTN(_INTPF)           (0x00035000 + ((_INTPF) * 4)) /* _i=0...511 */ /* Reset: PFR */
+#define I40E_PFINT_LNKLSTN_MAX_INDEX         511
+#define I40E_PFINT_LNKLSTN_FIRSTQ_INDX_SHIFT 0
+#define I40E_PFINT_LNKLSTN_FIRSTQ_INDX_MASK  (0x7FF << I40E_PFINT_LNKLSTN_FIRSTQ_INDX_SHIFT)
+#define I40E_PFINT_LNKLSTN_FIRSTQ_TYPE_SHIFT 11
+#define I40E_PFINT_LNKLSTN_FIRSTQ_TYPE_MASK  (0x3 << I40E_PFINT_LNKLSTN_FIRSTQ_TYPE_SHIFT)
+
+#define I40E_PFINT_CEQCTL(_INTPF)          (0x00036800 + ((_INTPF) * 4)) /* _i=0...511 */ /* Reset: CORER */
+#define I40E_PFINT_CEQCTL_MAX_INDEX        511
+#define I40E_PFINT_CEQCTL_MSIX_INDX_SHIFT  0
+#define I40E_PFINT_CEQCTL_MSIX_INDX_MASK   (0xFF << I40E_PFINT_CEQCTL_MSIX_INDX_SHIFT)
+#define I40E_PFINT_CEQCTL_ITR_INDX_SHIFT   11
+#define I40E_PFINT_CEQCTL_ITR_INDX_MASK    (0x3 << I40E_PFINT_CEQCTL_ITR_INDX_SHIFT)
+#define I40E_PFINT_CEQCTL_MSIX0_INDX_SHIFT 13
+#define I40E_PFINT_CEQCTL_MSIX0_INDX_MASK  (0x7 << I40E_PFINT_CEQCTL_MSIX0_INDX_SHIFT)
+#define I40E_PFINT_CEQCTL_NEXTQ_INDX_SHIFT 16
+#define I40E_PFINT_CEQCTL_NEXTQ_INDX_MASK  (0x7FF << I40E_PFINT_CEQCTL_NEXTQ_INDX_SHIFT)
+#define I40E_PFINT_CEQCTL_NEXTQ_TYPE_SHIFT 27
+#define I40E_PFINT_CEQCTL_NEXTQ_TYPE_MASK  (0x3 << I40E_PFINT_CEQCTL_NEXTQ_TYPE_SHIFT)
+#define I40E_PFINT_CEQCTL_CAUSE_ENA_SHIFT  30
+#define I40E_PFINT_CEQCTL_CAUSE_ENA_MASK   (0x1 << I40E_PFINT_CEQCTL_CAUSE_ENA_SHIFT)
+#define I40E_PFINT_CEQCTL_INTEVENT_SHIFT   31
+#define I40E_PFINT_CEQCTL_INTEVENT_MASK    (0x1 << I40E_PFINT_CEQCTL_INTEVENT_SHIFT)
+
+#define I40E_CQPSQ_STAG_PDID_SHIFT         48
+#define I40E_CQPSQ_STAG_PDID_MASK          (0x7FFFULL << I40E_CQPSQ_STAG_PDID_SHIFT)
+
+#define I40E_PFPE_CCQPSTATUS_CCQP_DONE_SHIFT   0
+#define I40E_PFPE_CCQPSTATUS_CCQP_DONE_MASK    (0x1ULL <<  I40E_PFPE_CCQPSTATUS_CCQP_DONE_SHIFT)
+
+#define I40E_PFPE_CCQPSTATUS_CCQP_ERR_SHIFT    31
+#define I40E_PFPE_CCQPSTATUS_CCQP_ERR_MASK     (0x1ULL <<  I40E_PFPE_CCQPSTATUS_CCQP_ERR_SHIFT)
+
+#define I40E_PFINT_DYN_CTLN_ITR_INDX_SHIFT     3
+#define I40E_PFINT_DYN_CTLN_ITR_INDX_MASK      (0x3 <<  I40E_PFINT_DYN_CTLN_ITR_INDX_SHIFT)
+
+#define I40E_PFINT_DYN_CTLN_INTENA_SHIFT       0
+#define I40E_PFINT_DYN_CTLN_INTENA_MASK        (0x1 <<  I40E_PFINT_DYN_CTLN_INTENA_SHIFT)
+
+#define I40E_CQPSQ_CQ_CEQID_SHIFT 24
+#define I40E_CQPSQ_CQ_CEQID_MASK (0x7fUL << I40E_CQPSQ_CQ_CEQID_SHIFT)
+
+#define I40E_VSIQF_CTL(_VSI)             (0x0020D800 + ((_VSI) * 4))
+
+enum i40iw_device_caps_const {
+	I40IW_MAX_WQ_FRAGMENT_COUNT		= 3,
+	I40IW_MAX_SGE_RD			= 1,
+	I40IW_MAX_PUSH_PAGE_COUNT		= 0,
+	I40IW_MAX_INLINE_DATA_SIZE		= 48,
+	I40IW_MAX_IRD_SIZE			= 63,
+	I40IW_MAX_ORD_SIZE			= 127,
+	I40IW_MAX_WQ_ENTRIES			= 2048,
+	I40IW_MAX_WQE_SIZE_RQ			= 128,
+	I40IW_MAX_PDS				= 32768,
+	I40IW_MAX_STATS_COUNT			= 16,
+	I40IW_MAX_CQ_SIZE			= 1048575,
+	I40IW_MAX_OUTBOUND_MSG_SIZE		= 2147483647,
+	I40IW_MAX_INBOUND_MSG_SIZE		= 2147483647,
+};
+
+#define I40IW_QP_WQE_MIN_SIZE	32
+#define I40IW_QP_WQE_MAX_SIZE	128
+#define I40IW_QP_SW_MIN_WQSIZE	4
+
+#define	I40IW_MAX_RQ_WQE_SHIFT	2
+#define I40IW_MAX_QUANTA_PER_WR 2
+
+#define I40IW_QP_SW_MAX_SQ_QUANTA 2048
+#define I40IW_QP_SW_MAX_RQ_QUANTA 16384
+#define I40IW_QP_SW_MAX_WQ_QUANTA 2048
+#define I40IW_MAX_QP_WRS ((I40IW_QP_SW_MAX_SQ_QUANTA - IRDMA_SQ_RSVD) / I40IW_MAX_QUANTA_PER_WR)
+#define I40IW_FIRST_VF_FPM_ID	16
+#define QUEUE_TYPE_CEQ		2
+#define NULL_QUEUE_INDEX	0x7FF
+
+void i40iw_init_hw(struct irdma_sc_dev *dev);
+#endif /* I40IW_HW_H */
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.c b/drivers/infiniband/hw/irdma/icrdma_hw.c
new file mode 100644
index 000000000000..90ceb9c29235
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019 Intel Corporation */
+#include "osdep.h"
+#include "type.h"
+#include "icrdma_hw.h"
+
+static u32 icrdma_regs[IRDMA_MAX_REGS] = {
+	PFPE_CQPTAIL,
+	PFPE_CQPDB,
+	PFPE_CCQPSTATUS,
+	PFPE_CCQPHIGH,
+	PFPE_CCQPLOW,
+	PFPE_CQARM,
+	PFPE_CQACK,
+	PFPE_AEQALLOC,
+	PFPE_CQPERRCODES,
+	PFPE_WQEALLOC,
+	GLINT_DYN_CTL(0),
+	ICRDMA_DB_ADDR_OFFSET,
+
+	GLPCI_LBARCTRL,
+	GLPE_CPUSTATUS0,
+	GLPE_CPUSTATUS1,
+	GLPE_CPUSTATUS2,
+	PFINT_AEQCTL,
+	GLINT_CEQCTL(0),
+	VSIQF_PE_CTL1(0),
+	PFHMC_PDINV,
+	GLHMC_VFPDINV(0)
+};
+
+static u64 icrdma_masks[IRDMA_MAX_MASKS] = {
+	ICRDMA_CCQPSTATUS_CCQP_DONE_M,
+	ICRDMA_CCQPSTATUS_CCQP_ERR_M,
+	ICRDMA_CQPSQ_STAG_PDID_M,
+	ICRDMA_CQPSQ_CQ_CEQID_M,
+	ICRDMA_CQPSQ_CQ_CQID_M,
+};
+
+static u64 icrdma_shifts[IRDMA_MAX_SHIFTS] = {
+	ICRDMA_CCQPSTATUS_CCQP_DONE_S,
+	ICRDMA_CCQPSTATUS_CCQP_ERR_S,
+	ICRDMA_CQPSQ_STAG_PDID_S,
+	ICRDMA_CQPSQ_CQ_CEQID_S,
+	ICRDMA_CQPSQ_CQ_CQID_S,
+};
+
+void icrdma_init_hw(struct irdma_sc_dev *dev)
+{
+	int i;
+	u8 __iomem *hw_addr;
+
+	for (i = 0; i < IRDMA_MAX_REGS; ++i) {
+		hw_addr = dev->hw->hw_addr;
+
+		if (i == IRDMA_DB_ADDR_OFFSET)
+			hw_addr = NULL;
+
+		dev->hw_regs[i] = (u32 __iomem *)(hw_addr + icrdma_regs[i]);
+	}
+
+	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
+		dev->hw_shifts[i] = icrdma_shifts[i];
+
+	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
+		dev->hw_masks[i] = icrdma_masks[i];
+
+	dev->wqe_alloc_db = dev->hw_regs[IRDMA_WQEALLOC];
+	dev->cq_arm_db = dev->hw_regs[IRDMA_CQARM];
+	dev->aeq_alloc_db = dev->hw_regs[IRDMA_AEQALLOC];
+	dev->cqp_db = dev->hw_regs[IRDMA_CQPDB];
+	dev->cq_ack_db = dev->hw_regs[IRDMA_CQACK];
+	dev->hw_attrs.max_stat_inst = ICRDMA_MAX_STATS_COUNT;
+
+	dev->hw_attrs.uk_attrs.max_hw_sq_chunk = IRDMA_MAX_QUANTA_PER_WR;
+}
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.h b/drivers/infiniband/hw/irdma/icrdma_hw.h
new file mode 100644
index 000000000000..7eb7cbdcfb73
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#ifndef ICRDMA_HW_H
+#define ICRDMA_HW_H
+
+#define VFPE_CQPTAIL1		0x0000a000
+#define VFPE_CQPDB1		0x0000bc00
+#define VFPE_CCQPSTATUS1	0x0000b800
+#define VFPE_CCQPHIGH1		0x00009800
+#define VFPE_CCQPLOW1		0x0000ac00
+#define VFPE_CQARM1		0x0000b400
+#define VFPE_CQARM1		0x0000b400
+#define VFPE_CQACK1		0x0000b000
+#define VFPE_AEQALLOC1		0x0000a400
+#define VFPE_CQPERRCODES1	0x00009c00
+#define VFPE_WQEALLOC1		0x0000c000
+#define VFINT_DYN_CTLN(_i)	(0x00003800 + ((_i) * 4)) /* _i=0...63 */
+
+#define PFPE_CQPTAIL		0x00500880
+#define PFPE_CQPDB		0x00500800
+#define PFPE_CCQPSTATUS		0x0050a000
+#define PFPE_CCQPHIGH		0x0050a100
+#define PFPE_CCQPLOW		0x0050a080
+#define PFPE_CQARM		0x00502c00
+#define PFPE_CQACK		0x00502c80
+#define PFPE_AEQALLOC		0x00502d00
+#define GLINT_DYN_CTL(_INT)	(0x00160000 + ((_INT) * 4)) /* _i=0...2047 */
+#define GLPCI_LBARCTRL		0x0009de74
+#define GLPE_CPUSTATUS0		0x0050ba5c
+#define GLPE_CPUSTATUS1		0x0050ba60
+#define GLPE_CPUSTATUS2		0x0050ba64
+#define PFINT_AEQCTL		0x0016cb00
+#define PFPE_CQPERRCODES	0x0050a200
+#define PFPE_WQEALLOC		0x00504400
+#define GLINT_CEQCTL(_INT)	(0x0015c000 + ((_INT) * 4)) /* _i=0...2047 */
+#define VSIQF_PE_CTL1(_VSI)	(0x00414000 + ((_VSI) * 4)) /* _i=0...767 */
+#define PFHMC_PDINV		0x00520300
+#define GLHMC_VFPDINV(_i)	(0x00528300 + ((_i) * 4)) /* _i=0...31 */
+
+#define ICRDMA_DB_ADDR_OFFSET		(8 * 1024 * 1024 - 64 * 1024)
+
+#define ICRDMA_VF_DB_ADDR_OFFSET	(64 * 1024)
+
+/* CCQSTATUS */
+#define ICRDMA_CCQPSTATUS_CCQP_DONE_S	0
+#define ICRDMA_CCQPSTATUS_CCQP_DONE_M	(0x1ULL << ICRDMA_CCQPSTATUS_CCQP_DONE_S)
+#define ICRDMA_CCQPSTATUS_CCQP_ERR_S	31
+#define ICRDMA_CCQPSTATUS_CCQP_ERR_M	(0x1ULL << ICRDMA_CCQPSTATUS_CCQP_ERR_S)
+#define ICRDMA_CQPSQ_STAG_PDID_S	46
+#define ICRDMA_CQPSQ_STAG_PDID_M	(0x3ffffULL << ICRDMA_CQPSQ_STAG_PDID_S)
+#define ICRDMA_CQPSQ_CQ_CEQID_S		22
+#define ICRDMA_CQPSQ_CQ_CEQID_M		(0x3ffULL << ICRDMA_CQPSQ_CQ_CEQID_S)
+#define ICRDMA_CQPSQ_CQ_CQID_S 0
+#define ICRDMA_CQPSQ_CQ_CQID_M \
+	(0x7ffffULL << ICRDMA_CQPSQ_CQ_CQID_S)
+
+enum icrdma_device_caps_const {
+	ICRDMA_MAX_STATS_COUNT = 128,
+};
+
+void icrdma_init_hw(struct irdma_sc_dev *dev);
+#endif /* ICRDMA_HW_H*/
-- 
2.25.2

