Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1A36F047
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhD2TR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:17:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43708 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234754AbhD2TMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:12:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ6FJA019574;
        Thu, 29 Apr 2021 12:11:20 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 387erumw6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:11:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:11:18 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:11:15 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 24/27] qedn: Add support of NVME ICReq & ICResp
Date:   Thu, 29 Apr 2021 22:09:23 +0300
Message-ID: <20210429190926.5086-25-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: wnovlya5CaaZBftyeStPXW-71TDgas-Z
X-Proofpoint-ORIG-GUID: wnovlya5CaaZBftyeStPXW-71TDgas-Z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

Once a TCP connection established, the host sends an Initialize
Connection Request (ICReq) PDU to the controller.
Further Initialize Connection Response (ICResp) PDU received from
controller is processed by host to establish a connection and
exchange connection configuration parameters.

This patch present support of generation of ICReq and processing of
ICResp. It also update host configuration based on exchanged parameters.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/qedn/qedn.h      |  36 ++++
 drivers/nvme/hw/qedn/qedn_conn.c | 317 ++++++++++++++++++++++++++++++-
 drivers/nvme/hw/qedn/qedn_main.c |  22 +++
 drivers/nvme/hw/qedn/qedn_task.c |   8 +-
 4 files changed, 379 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 880ca245b02c..773a57994148 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -16,6 +16,7 @@
 
 /* Driver includes */
 #include "../../host/tcp-offload.h"
+#include <linux/nvme-tcp.h>
 
 #define QEDN_MAJOR_VERSION		8
 #define QEDN_MINOR_VERSION		62
@@ -52,6 +53,8 @@
 
 /* Protocol defines */
 #define QEDN_MAX_IO_SIZE QED_NVMETCP_MAX_IO_SIZE
+#define QEDN_MAX_PDU_SIZE 0x80000 /* 512KB */
+#define QEDN_MAX_OUTSTANDING_R2T_PDUS 0 /* 0 Based == 1 max R2T */
 
 #define QEDN_SGE_BUFF_SIZE 4096
 #define QEDN_MAX_SGES_PER_TASK DIV_ROUND_UP(QEDN_MAX_IO_SIZE, QEDN_SGE_BUFF_SIZE)
@@ -65,6 +68,11 @@
 #define QEDN_TASK_INSIST_TMO 1000 /* 1 sec */
 #define QEDN_INVALID_ITID 0xFFFF
 
+#define QEDN_ICREQ_FW_PAYLOAD (sizeof(struct nvme_tcp_icreq_pdu) - \
+			       sizeof(struct nvmetcp_init_conn_req_hdr))
+/* The FW will handle the ICReq as CCCID 0 (FW internal design) */
+#define QEDN_ICREQ_CCCID 0
+
 /*
  * TCP offload stack default configurations and defines.
  * Future enhancements will allow controlling the configurable
@@ -136,6 +144,16 @@ struct qedn_fp_queue {
 	char irqname[QEDN_IRQ_NAME_LEN];
 };
 
+struct qedn_negotiation_params {
+	u32 maxh2cdata; /* Negotiation */
+	u32 maxr2t; /* Validation */
+	u16 pfv; /* Validation */
+	bool hdr_digest; /* Negotiation */
+	bool data_digest; /* Negotiation */
+	u8 cpda; /* Negotiation */
+	u8 hpda; /* Validation */
+};
+
 struct qedn_ctx {
 	struct pci_dev *pdev;
 	struct qed_dev *cdev;
@@ -195,6 +213,9 @@ struct qedn_endpoint {
 	struct qed_chain fw_sq_chain;
 	void __iomem *p_doorbell;
 
+	/* Spinlock for accessing FW queue */
+	spinlock_t doorbell_lock;
+
 	/* TCP Params */
 	__be32 dst_addr[4]; /* In network order */
 	__be32 src_addr[4]; /* In network order */
@@ -268,6 +289,12 @@ struct qedn_ctrl {
 	atomic_t host_num_active_conns;
 };
 
+struct qedn_icreq_padding {
+	u32 *buffer;
+	dma_addr_t pa;
+	struct nvmetcp_sge sge;
+};
+
 /* Connection level struct */
 struct qedn_conn_ctx {
 	/* IO path */
@@ -329,6 +356,11 @@ struct qedn_conn_ctx {
 
 	size_t sq_depth;
 
+	struct qedn_negotiation_params required_params;
+	struct qedn_negotiation_params pdu_params;
+	struct nvmetcp_icresp_hdr_psh icresp;
+	struct qedn_icreq_padding *icreq_pad;
+
 	/* "dummy" socket */
 	struct socket *sock;
 };
@@ -337,6 +369,7 @@ enum qedn_conn_resources_state {
 	QEDN_CONN_RESRC_FW_SQ,
 	QEDN_CONN_RESRC_ACQUIRE_CONN,
 	QEDN_CONN_RESRC_TASKS,
+	QEDN_CONN_RESRC_ICREQ_PAD,
 	QEDN_CONN_RESRC_CCCID_ITID_MAP,
 	QEDN_CONN_RESRC_TCP_PORT,
 	QEDN_CONN_RESRC_MAX = 64
@@ -375,5 +408,8 @@ void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task_params);
 void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
 void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
 			     struct qedn_io_resources *io_resrc);
+void qedn_swap_bytes(u32 *p, int size);
+void qedn_prep_icresp(struct qedn_conn_ctx *conn_ctx, struct nvmetcp_fw_cqe *cqe);
+void qedn_ring_doorbell(struct qedn_conn_ctx *conn_ctx);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index 10a80fbeac43..5679354aa0e0 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -34,6 +34,25 @@ inline int qedn_qid(struct nvme_tcp_ofld_queue *queue)
 	return queue - queue->ctrl->queues;
 }
 
+void qedn_ring_doorbell(struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvmetcp_db_data dbell = { 0 };
+	u16 prod_idx;
+
+	dbell.agg_flags = 0;
+	dbell.params |= DB_DEST_XCM << NVMETCP_DB_DATA_DEST_SHIFT;
+	dbell.params |= DB_AGG_CMD_SET << NVMETCP_DB_DATA_AGG_CMD_SHIFT;
+	dbell.params |=
+		DQ_XCM_ISCSI_SQ_PROD_CMD << NVMETCP_DB_DATA_AGG_VAL_SEL_SHIFT;
+	dbell.params |= 1 << NVMETCP_DB_DATA_BYPASS_EN_SHIFT;
+	prod_idx = qed_chain_get_prod_idx(&conn_ctx->ep.fw_sq_chain);
+	dbell.sq_prod = cpu_to_le16(prod_idx);
+
+	/* wmb - Make sure fw idx is coherent */
+	wmb();
+	writel(*(u32 *)&dbell, conn_ctx->ep.p_doorbell);
+}
+
 int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state)
 {
 	spin_lock_bh(&conn_ctx->conn_state_lock);
@@ -130,6 +149,71 @@ int qedn_initialize_endpoint(struct qedn_endpoint *ep, u8 *local_mac_addr,
 	return -1;
 }
 
+static int qedn_alloc_icreq_pad(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_icreq_padding *icreq_pad;
+	u32 *buffer;
+	int rc = 0;
+
+	icreq_pad = kzalloc(sizeof(*icreq_pad), GFP_KERNEL);
+	if (!icreq_pad)
+		return -ENOMEM;
+
+	conn_ctx->icreq_pad = icreq_pad;
+	memset(&icreq_pad->sge, 0, sizeof(icreq_pad->sge));
+	buffer = dma_alloc_coherent(&qedn->pdev->dev,
+				    QEDN_ICREQ_FW_PAYLOAD,
+				    &icreq_pad->pa,
+				    GFP_KERNEL);
+	if (!buffer) {
+		pr_err("Could not allocate icreq_padding SGE buffer.\n");
+		rc =  -ENOMEM;
+		goto release_icreq_pad;
+	}
+
+	DMA_REGPAIR_LE(icreq_pad->sge.sge_addr, icreq_pad->pa);
+	icreq_pad->sge.sge_len = cpu_to_le32(QEDN_ICREQ_FW_PAYLOAD);
+	icreq_pad->buffer = buffer;
+	set_bit(QEDN_CONN_RESRC_ICREQ_PAD, &conn_ctx->resrc_state);
+
+	return 0;
+
+release_icreq_pad:
+	kfree(icreq_pad);
+	conn_ctx->icreq_pad = NULL;
+
+	return rc;
+}
+
+static void qedn_free_icreq_pad(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_icreq_padding *icreq_pad;
+	u32 *buffer;
+
+	icreq_pad = conn_ctx->icreq_pad;
+	if (unlikely(!icreq_pad)) {
+		pr_err("null ptr in icreq_pad in conn_ctx\n");
+		goto finally;
+	}
+
+	buffer = icreq_pad->buffer;
+	if (buffer) {
+		dma_free_coherent(&qedn->pdev->dev,
+				  QEDN_ICREQ_FW_PAYLOAD,
+				  (void *)buffer,
+				  icreq_pad->pa);
+		icreq_pad->buffer = NULL;
+	}
+
+	kfree(icreq_pad);
+	conn_ctx->icreq_pad = NULL;
+
+finally:
+	clear_bit(QEDN_CONN_RESRC_ICREQ_PAD, &conn_ctx->resrc_state);
+}
+
 static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
 {
 	struct qedn_ctx *qedn = conn_ctx->qedn;
@@ -151,6 +235,9 @@ static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
 		clear_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
 	}
 
+	if (test_bit(QEDN_CONN_RESRC_ICREQ_PAD, &conn_ctx->resrc_state))
+		qedn_free_icreq_pad(conn_ctx);
+
 	if (test_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state)) {
 		clear_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state);
 			qedn_return_active_tasks(conn_ctx);
@@ -309,6 +396,194 @@ void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx, int abrt_flag)
 	queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
 }
 
+static int qedn_nvmetcp_update_conn(struct qedn_ctx *qedn, struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_negotiation_params *pdu_params = &conn_ctx->pdu_params;
+	struct qed_nvmetcp_params_update *conn_info;
+	int rc;
+
+	conn_info = kzalloc(sizeof(*conn_info), GFP_KERNEL);
+	if (!conn_info)
+		return -ENOMEM;
+
+	conn_info->hdr_digest_en = pdu_params->hdr_digest;
+	conn_info->data_digest_en = pdu_params->data_digest;
+	conn_info->max_recv_pdu_length = QEDN_MAX_PDU_SIZE;
+	conn_info->max_io_size = QEDN_MAX_IO_SIZE;
+	conn_info->max_send_pdu_length = pdu_params->maxh2cdata;
+
+	rc = qed_ops->update_conn(qedn->cdev, conn_ctx->conn_handle, conn_info);
+	if (rc) {
+		pr_err("Could not update connection\n");
+		rc = -ENXIO;
+	}
+
+	kfree(conn_info);
+
+	return rc;
+}
+
+static int qedn_update_ramrod(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int rc = 0;
+
+	rc = qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_UPDATE_EQE);
+	if (rc)
+		return rc;
+
+	rc = qedn_nvmetcp_update_conn(qedn, conn_ctx);
+	if (rc)
+		return rc;
+
+	if (conn_ctx->state != CONN_STATE_WAIT_FOR_UPDATE_EQE) {
+		pr_err("cid 0x%x: Unexpected state 0x%x after update ramrod\n",
+		       conn_ctx->fw_cid, conn_ctx->state);
+
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
+static int qedn_send_icreq(struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvmetcp_init_conn_req_hdr *icreq_ptr = NULL;
+	struct storage_sgl_task_params *sgl_task_params;
+	struct nvmetcp_task_params task_params;
+	struct qedn_task_ctx *qedn_task = NULL;
+	struct nvme_tcp_icreq_pdu icreq;
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+
+	qedn_task = qedn_get_task_from_pool_insist(conn_ctx, QEDN_ICREQ_CCCID);
+	if (!qedn_task)
+		return -EINVAL;
+
+	memset(&icreq, 0, sizeof(icreq));
+	memset(&local_sqe, 0, sizeof(local_sqe));
+
+	/* Initialize ICReq */
+	icreq.hdr.type = nvme_tcp_icreq;
+	icreq.hdr.hlen = sizeof(icreq);
+	icreq.hdr.pdo = 0;
+	icreq.hdr.plen = cpu_to_le32(icreq.hdr.hlen);
+	icreq.pfv = cpu_to_le16(conn_ctx->required_params.pfv);
+	icreq.maxr2t = cpu_to_le32(conn_ctx->required_params.maxr2t);
+	icreq.hpda = conn_ctx->required_params.hpda;
+	if (conn_ctx->required_params.hdr_digest)
+		icreq.digest |= NVME_TCP_HDR_DIGEST_ENABLE;
+	if (conn_ctx->required_params.data_digest)
+		icreq.digest |= NVME_TCP_DATA_DIGEST_ENABLE;
+
+	qedn_swap_bytes((u32 *)&icreq,
+			(sizeof(icreq) - QEDN_ICREQ_FW_PAYLOAD) /
+			 sizeof(u32));
+
+	/* Initialize task params */
+	task_params.opq.lo = cpu_to_le32(((u64)(qedn_task)) & 0xffffffff);
+	task_params.opq.hi = cpu_to_le32(((u64)(qedn_task)) >> 32);
+	task_params.context = qedn_task->fw_task_ctx;
+	task_params.sqe = &local_sqe;
+	task_params.conn_icid = (u16)conn_ctx->conn_handle;
+	task_params.itid = qedn_task->itid;
+	task_params.cq_rss_number = conn_ctx->default_cq;
+	task_params.tx_io_size = QEDN_ICREQ_FW_PAYLOAD;
+	task_params.rx_io_size = 0; /* Rx doesn't use SGL for icresp */
+
+	/* Init SGE for ICReq padding */
+	sgl_task_params = &qedn_task->sgl_task_params;
+	sgl_task_params->total_buffer_size = task_params.tx_io_size;
+	sgl_task_params->small_mid_sge = false;
+	sgl_task_params->num_sges = 1;
+	memcpy(sgl_task_params->sgl, &conn_ctx->icreq_pad->sge,
+	       sizeof(conn_ctx->icreq_pad->sge));
+	icreq_ptr = (struct nvmetcp_init_conn_req_hdr *)&icreq;
+
+	qed_ops->init_icreq_exchange(&task_params, icreq_ptr, sgl_task_params,  NULL);
+
+	qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_IC_COMP);
+	atomic_inc(&conn_ctx->num_active_fw_tasks);
+
+	/* spin_lock - doorbell is accessed  both Rx flow and response flow */
+	spin_lock(&conn_ctx->ep.doorbell_lock);
+	chain_sqe = qed_chain_produce(&conn_ctx->ep.fw_sq_chain);
+	memcpy(chain_sqe, &local_sqe, sizeof(local_sqe));
+	qedn_ring_doorbell(conn_ctx);
+	spin_unlock(&conn_ctx->ep.doorbell_lock);
+
+	return 0;
+}
+
+void qedn_prep_icresp(struct qedn_conn_ctx *conn_ctx, struct nvmetcp_fw_cqe *cqe)
+{
+	struct nvmetcp_icresp_hdr_psh *icresp_from_cqe =
+		(struct nvmetcp_icresp_hdr_psh *)&cqe->nvme_cqe;
+	struct nvme_tcp_ofld_ctrl *ctrl = conn_ctx->ctrl;
+	struct qedn_ctrl *qctrl = NULL;
+
+	qctrl = (struct qedn_ctrl *)ctrl->private_data;
+
+	memcpy(&conn_ctx->icresp, icresp_from_cqe, sizeof(conn_ctx->icresp));
+	qedn_set_sp_wa(conn_ctx, HANDLE_ICRESP);
+	queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
+}
+
+static int qedn_handle_icresp(struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvmetcp_icresp_hdr_psh *icresp = &conn_ctx->icresp;
+	u16 pfv = __swab16(le16_to_cpu(icresp->pfv_swapped));
+	int rc = 0;
+
+	qedn_free_icreq_pad(conn_ctx);
+
+	/* Validate ICResp */
+	if (pfv != conn_ctx->required_params.pfv) {
+		pr_err("cid %u: unsupported pfv %u\n", conn_ctx->fw_cid, pfv);
+
+		return -EINVAL;
+	}
+
+	if (icresp->cpda > conn_ctx->required_params.cpda) {
+		pr_err("cid %u: unsupported cpda %u\n", conn_ctx->fw_cid, icresp->cpda);
+
+		return -EINVAL;
+	}
+
+	if ((NVME_TCP_HDR_DIGEST_ENABLE & icresp->digest) !=
+	    conn_ctx->required_params.hdr_digest) {
+		if ((NVME_TCP_HDR_DIGEST_ENABLE & icresp->digest) >
+		    conn_ctx->required_params.hdr_digest) {
+			pr_err("cid 0x%x: invalid header digest bit\n", conn_ctx->fw_cid);
+		}
+	}
+
+	if ((NVME_TCP_DATA_DIGEST_ENABLE & icresp->digest) !=
+	    conn_ctx->required_params.data_digest) {
+		if ((NVME_TCP_DATA_DIGEST_ENABLE & icresp->digest) >
+		    conn_ctx->required_params.data_digest) {
+			pr_err("cid 0x%x: invalid data digest bit\n", conn_ctx->fw_cid);
+	}
+	}
+
+	memset(&conn_ctx->pdu_params, 0, sizeof(conn_ctx->pdu_params));
+	conn_ctx->pdu_params.maxh2cdata =
+		__swab32(le32_to_cpu(icresp->maxdata_swapped));
+	conn_ctx->pdu_params.maxh2cdata = QEDN_MAX_PDU_SIZE;
+	if (conn_ctx->pdu_params.maxh2cdata > QEDN_MAX_PDU_SIZE)
+		conn_ctx->pdu_params.maxh2cdata = QEDN_MAX_PDU_SIZE;
+
+	conn_ctx->pdu_params.pfv = pfv;
+	conn_ctx->pdu_params.cpda = icresp->cpda;
+	conn_ctx->pdu_params.hpda = conn_ctx->required_params.hpda;
+	conn_ctx->pdu_params.hdr_digest = NVME_TCP_HDR_DIGEST_ENABLE & icresp->digest;
+	conn_ctx->pdu_params.data_digest = NVME_TCP_DATA_DIGEST_ENABLE & icresp->digest;
+	conn_ctx->pdu_params.maxr2t = conn_ctx->required_params.maxr2t;
+	rc = qedn_update_ramrod(conn_ctx);
+
+	return rc;
+}
+
 /* Slowpath EQ Callback */
 int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
 {
@@ -363,7 +638,8 @@ int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
 			if (rc)
 				return rc;
 
-			/* Placeholder - for ICReq flow */
+			qedn_set_sp_wa(conn_ctx, SEND_ICREQ);
+			queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
 		}
 
 		break;
@@ -399,6 +675,7 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 	}
 
 	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
+	spin_lock_init(&conn_ctx->ep.doorbell_lock);
 	INIT_LIST_HEAD(&conn_ctx->host_pend_req_list);
 	spin_lock_init(&conn_ctx->nvme_req_lock);
 	atomic_set(&conn_ctx->num_active_tasks, 0);
@@ -463,6 +740,11 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 
 	memset(conn_ctx->host_cccid_itid, 0xFF, dma_size);
 	set_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP, &conn_ctx->resrc_state);
+
+	rc = qedn_alloc_icreq_pad(conn_ctx);
+		if (rc)
+			goto rel_conn;
+
 	rc = qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_CONNECT_DONE);
 	if (rc)
 		goto rel_conn;
@@ -523,6 +805,9 @@ void qedn_sp_wq_handler(struct work_struct *work)
 
 	qedn = conn_ctx->qedn;
 	if (test_bit(DESTROY_CONNECTION, &conn_ctx->agg_work_action)) {
+		if (test_bit(HANDLE_ICRESP, &conn_ctx->agg_work_action))
+			qedn_clr_sp_wa(conn_ctx, HANDLE_ICRESP);
+
 		qedn_destroy_connection(conn_ctx);
 
 		return;
@@ -537,6 +822,36 @@ void qedn_sp_wq_handler(struct work_struct *work)
 			return;
 		}
 	}
+
+	if (test_bit(SEND_ICREQ, &conn_ctx->agg_work_action)) {
+		qedn_clr_sp_wa(conn_ctx, SEND_ICREQ);
+		rc = qedn_send_icreq(conn_ctx);
+		if (rc)
+			return;
+
+		return;
+	}
+
+	if (test_bit(HANDLE_ICRESP, &conn_ctx->agg_work_action)) {
+		rc = qedn_handle_icresp(conn_ctx);
+
+		qedn_clr_sp_wa(conn_ctx, HANDLE_ICRESP);
+		if (rc) {
+			pr_err("IC handling returned with 0x%x\n", rc);
+			if (test_and_set_bit(DESTROY_CONNECTION, &conn_ctx->agg_work_action))
+				return;
+
+			qedn_destroy_connection(conn_ctx);
+
+			return;
+		}
+
+		atomic_inc(&conn_ctx->est_conn_indicator);
+		qedn_set_con_state(conn_ctx, CONN_STATE_NVMETCP_CONN_ESTABLISHED);
+		wake_up_interruptible(&conn_ctx->conn_waitq);
+
+		return;
+	}
 }
 
 /* Clear connection aggregative slowpath work action */
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 8d9c19d63480..a6756d7250b7 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -285,6 +285,19 @@ static void qedn_set_ctrl_io_cpus(struct qedn_conn_ctx *conn_ctx, int qid)
 	conn_ctx->cpu = fp_q->cpu;
 }
 
+static void qedn_set_pdu_params(struct qedn_conn_ctx *conn_ctx)
+{
+	/* Enable digest once supported */
+	conn_ctx->required_params.hdr_digest = 0;
+	conn_ctx->required_params.data_digest = 0;
+
+	conn_ctx->required_params.maxr2t = QEDN_MAX_OUTSTANDING_R2T_PDUS;
+	conn_ctx->required_params.pfv = NVME_TCP_PFV_1_0;
+	conn_ctx->required_params.cpda = 0;
+	conn_ctx->required_params.hpda = 0;
+	conn_ctx->required_params.maxh2cdata = QEDN_MAX_PDU_SIZE;
+}
+
 static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t q_size)
 {
 	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
@@ -307,6 +320,7 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t
 	conn_ctx->ctrl = ctrl;
 	conn_ctx->sq_depth = q_size;
 	qedn_set_ctrl_io_cpus(conn_ctx, qid);
+	qedn_set_pdu_params(conn_ctx);
 
 	init_waitqueue_head(&conn_ctx->conn_waitq);
 	atomic_set(&conn_ctx->est_conn_indicator, 0);
@@ -1073,6 +1087,14 @@ static int qedn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return __qedn_probe(pdev);
 }
 
+void qedn_swap_bytes(u32 *p, int size)
+{
+	int i;
+
+	for (i = 0; i < size; ++i, ++p)
+		*p = __swab32(*p);
+}
+
 static struct pci_driver qedn_pci_driver = {
 	.name     = QEDN_MODULE_NAME,
 	.id_table = qedn_pci_tbl,
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index 54f2f4cba6ea..9cb84883e95e 100644
--- a/drivers/nvme/hw/qedn/qedn_task.c
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -536,9 +536,11 @@ void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 			break;
 
 		case NVMETCP_TASK_TYPE_INIT_CONN_REQUEST:
-
-			/* Placeholder - ICReq flow */
-
+			/* Clear ICReq-padding SGE from SGL */
+			qedn_common_clear_fw_sgl(&qedn_task->sgl_task_params);
+			/* Task is not required for icresp processing */
+			qedn_return_task_to_pool(conn_ctx, qedn_task);
+			qedn_prep_icresp(conn_ctx, cqe);
 			break;
 		default:
 			pr_info("Could not identify task type\n");
-- 
2.22.0

