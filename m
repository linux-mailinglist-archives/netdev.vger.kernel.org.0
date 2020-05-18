Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567371D8B93
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgERXU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:20:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbgERXU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:20:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04INKr9o011274;
        Mon, 18 May 2020 16:20:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=+HQVainiJfi0XF4YKmHGXu/OmGVvn2L0RWCanyhLtJA=;
 b=qyOEWoNiQmIV1/z9NvXMHhPtZkAtir667KaWxhdUg3mkbdhNh7hcR6pgGLCSrxJbUYIe
 KNqozEg2oZm1rMF+TEsSkz33X7QbjDcR2eZbfF16JJ5c20YDUKVwIsl9pJRhiO0+DFzd
 UOp39IpUhqeGUjr7Xv4ZEMvDzbUk80SFCQJeHwB+f7Wu6QLK5paGwih7OTD3F5M/MvWq
 aII1HRRO639iEGPKtk1K1Sh8afXvFORHi4LRZthseYZTN84Zr/0/nuQLkNyfLtEpwlZL
 NcFTJXSLq7JFuY8FzMT4+65JA8TEE2QECPMl10JfsX/WbXoTt/6aC1Mdf3kV6dEPiy0e Jg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp10ra-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:20:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 May
 2020 16:20:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 18 May 2020 16:20:53 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id C4C533F703F;
        Mon, 18 May 2020 16:20:51 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Michal Kalderon <mkalderon@marvell.com>,
        "Yuval Bason" <ybason@marvell.com>
Subject: [PATCH net-next 2/2] qed: Add XRC to RoCE
Date:   Tue, 19 May 2020 01:21:00 +0300
Message-ID: <20200518222100.30306-3-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200518222100.30306-1-ybason@marvell.com>
References: <20200518222100.30306-1-ybason@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for XRC-SRQ's and XRC-QP's for upper layer driver.

We maintain separate bitmaps for resource management for srq and
xrc-srq, However, the range in FW is one, The xrc-srq's are first
and then the srq's follow. Therefore we maintain a srq-id offset.

Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Bason <ybason@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 137 +++++++++++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_rdma.h |  19 ++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c |  29 ++++++
 include/linux/qed/qed_rdma_if.h            |  19 ++++
 4 files changed, 188 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 415f3f3..9d5c8a4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -212,6 +212,15 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
 		goto free_rdma_port;
 	}
 
+	/* Allocate bit map for XRC Domains */
+	rc = qed_rdma_bmap_alloc(p_hwfn, &p_rdma_info->xrcd_map,
+				 QED_RDMA_MAX_XRCDS, "XRCD");
+	if (rc) {
+		DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
+			   "Failed to allocate xrcd_map,rc = %d\n", rc);
+		return rc;
+	}
+
 	/* Allocate DPI bitmap */
 	rc = qed_rdma_bmap_alloc(p_hwfn, &p_rdma_info->dpi_map,
 				 p_hwfn->dpi_count, "DPI");
@@ -271,6 +280,19 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
 		goto free_cid_map;
 	}
 
+	/* The first SRQ follows the last XRC SRQ. This means that the
+	 * SRQ IDs start from an offset equals to max_xrc_srqs.
+	 */
+	p_rdma_info->srq_id_offset = p_hwfn->p_cxt_mngr->xrc_srq_count;
+	rc = qed_rdma_bmap_alloc(p_hwfn,
+				 &p_rdma_info->xrc_srq_map,
+				 p_hwfn->p_cxt_mngr->xrc_srq_count, "XRC SRQ");
+	if (rc) {
+		DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
+			   "Failed to allocate xrc srq bitmap, rc = %d\n", rc);
+		return rc;
+	}
+
 	/* Allocate bitmap for srqs */
 	p_rdma_info->num_srqs = p_hwfn->p_cxt_mngr->srq_count;
 	rc = qed_rdma_bmap_alloc(p_hwfn, &p_rdma_info->srq_map,
@@ -377,6 +399,7 @@ static void qed_rdma_resc_free(struct qed_hwfn *p_hwfn)
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->tid_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->srq_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->real_cid_map, 1);
+	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->xrc_srq_map, 1);
 
 	kfree(p_rdma_info->port);
 	kfree(p_rdma_info->dev);
@@ -612,7 +635,10 @@ static int qed_rdma_start_fw(struct qed_hwfn *p_hwfn,
 	p_params_header->cnq_start_offset = (u8)RESC_START(p_hwfn,
 							   QED_RDMA_CNQ_RAM);
 	p_params_header->num_cnqs = params->desired_cnq;
-
+	p_params_header->first_reg_srq_id =
+	    cpu_to_le16(p_hwfn->p_rdma_info->srq_id_offset);
+	p_params_header->reg_srq_base_addr =
+	    cpu_to_le32(qed_cxt_get_ilt_page_size(p_hwfn, ILT_CLI_TSDM));
 	if (params->cq_mode == QED_RDMA_CQ_MODE_16_BITS)
 		p_params_header->cq_ring_mode = 1;
 	else
@@ -983,6 +1009,41 @@ static void qed_rdma_free_pd(void *rdma_cxt, u16 pd)
 	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
 }
 
+static int qed_rdma_alloc_xrcd(void *rdma_cxt, u16 *xrcd_id)
+{
+	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
+	u32 returned_id;
+	int rc;
+
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "Alloc XRCD\n");
+
+	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
+	rc = qed_rdma_bmap_alloc_id(p_hwfn,
+				    &p_hwfn->p_rdma_info->xrcd_map,
+				    &returned_id);
+	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
+	if (rc) {
+		DP_NOTICE(p_hwfn, "Failed in allocating xrcd id\n");
+		return rc;
+	}
+
+	*xrcd_id = (u16)returned_id;
+
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "Alloc XRCD - done, rc = %d\n", rc);
+	return rc;
+}
+
+static void qed_rdma_free_xrcd(void *rdma_cxt, u16 xrcd_id)
+{
+	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
+
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "xrcd_id = %08x\n", xrcd_id);
+
+	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
+	qed_bmap_release_id(p_hwfn, &p_hwfn->p_rdma_info->xrcd_map, xrcd_id);
+	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
+}
+
 static enum qed_rdma_toggle_bit
 qed_rdma_toggle_bit_create_resize_cq(struct qed_hwfn *p_hwfn, u16 icid)
 {
@@ -1306,6 +1367,8 @@ static int qed_rdma_destroy_qp(void *rdma_cxt, struct qed_rdma_qp *qp)
 	qp->resp_offloaded = false;
 	qp->e2e_flow_control_en = qp->use_srq ? false : true;
 	qp->stats_queue = in_params->stats_queue;
+	qp->qp_type = in_params->qp_type;
+	qp->xrcd_id = in_params->xrcd_id;
 
 	if (QED_IS_IWARP_PERSONALITY(p_hwfn)) {
 		rc = qed_iwarp_create_qp(p_hwfn, qp, out_params);
@@ -1418,6 +1481,18 @@ static int qed_rdma_modify_qp(void *rdma_cxt,
 			   qp->cur_state);
 	}
 
+	switch (qp->qp_type) {
+	case QED_RDMA_QP_TYPE_XRC_INI:
+		qp->has_req = 1;
+		break;
+	case QED_RDMA_QP_TYPE_XRC_TGT:
+		qp->has_resp = 1;
+		break;
+	default:
+		qp->has_req = 1;
+		qp->has_resp = 1;
+	}
+
 	if (QED_IS_IWARP_PERSONALITY(p_hwfn)) {
 		enum qed_iwarp_qp_state new_state =
 		    qed_roce2iwarp_state(qp->cur_state);
@@ -1657,6 +1732,15 @@ static void *qed_rdma_get_rdma_ctx(struct qed_dev *cdev)
 	return QED_AFFIN_HWFN(cdev);
 }
 
+static struct qed_bmap *qed_rdma_get_srq_bmap(struct qed_hwfn *p_hwfn,
+					      bool is_xrc)
+{
+	if (is_xrc)
+		return &p_hwfn->p_rdma_info->xrc_srq_map;
+
+	return &p_hwfn->p_rdma_info->srq_map;
+}
+
 static int qed_rdma_modify_srq(void *rdma_cxt,
 			       struct qed_rdma_modify_srq_in_params *in_params)
 {
@@ -1686,8 +1770,8 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
 	if (rc)
 		return rc;
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "modified SRQ id = %x",
-		   in_params->srq_id);
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "modified SRQ id = %x, is_xrc=%u\n",
+		   in_params->srq_id, in_params->is_xrc);
 
 	return rc;
 }
@@ -1702,6 +1786,7 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
 	struct qed_spq_entry *p_ent;
 	struct qed_bmap *bmap;
 	u16 opaque_fid;
+	u16 offset;
 	int rc;
 
 	opaque_fid = p_hwfn->hw_info.opaque_fid;
@@ -1723,14 +1808,16 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
 	if (rc)
 		return rc;
 
-	bmap = &p_hwfn->p_rdma_info->srq_map;
+	bmap = qed_rdma_get_srq_bmap(p_hwfn, in_params->is_xrc);
+	offset = (in_params->is_xrc) ? 0 : p_hwfn->p_rdma_info->srq_id_offset;
 
 	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
-	qed_bmap_release_id(p_hwfn, bmap, in_params->srq_id);
+	qed_bmap_release_id(p_hwfn, bmap, in_params->srq_id - offset);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "SRQ destroyed Id = %x",
-		   in_params->srq_id);
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
+		   "XRC/SRQ destroyed Id = %x, is_xrc=%u\n",
+		   in_params->srq_id, in_params->is_xrc);
 
 	return rc;
 }
@@ -1748,24 +1835,26 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
 	u16 opaque_fid, srq_id;
 	struct qed_bmap *bmap;
 	u32 returned_id;
+	u16 offset;
 	int rc;
 
-	bmap = &p_hwfn->p_rdma_info->srq_map;
+	bmap = qed_rdma_get_srq_bmap(p_hwfn, in_params->is_xrc);
 	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
 	rc = qed_rdma_bmap_alloc_id(p_hwfn, bmap, &returned_id);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
 
 	if (rc) {
-		DP_NOTICE(p_hwfn, "failed to allocate srq id\n");
+		DP_NOTICE(p_hwfn,
+			  "failed to allocate xrc/srq id (is_xrc=%u)\n",
+			  in_params->is_xrc);
 		return rc;
 	}
 
-	elem_type = QED_ELEM_SRQ;
+	elem_type = (in_params->is_xrc) ? (QED_ELEM_XRC_SRQ) : (QED_ELEM_SRQ);
 	rc = qed_cxt_dynamic_ilt_alloc(p_hwfn, elem_type, returned_id);
 	if (rc)
 		goto err;
-	/* returned id is no greater than u16 */
-	srq_id = (u16)returned_id;
+
 	opaque_fid = p_hwfn->hw_info.opaque_fid;
 
 	opaque_fid = p_hwfn->hw_info.opaque_fid;
@@ -1782,20 +1871,34 @@ static int qed_rdma_modify_srq(void *rdma_cxt,
 	DMA_REGPAIR_LE(p_ramrod->pbl_base_addr, in_params->pbl_base_addr);
 	p_ramrod->pages_in_srq_pbl = cpu_to_le16(in_params->num_pages);
 	p_ramrod->pd_id = cpu_to_le16(in_params->pd_id);
-	p_ramrod->srq_id.srq_idx = cpu_to_le16(srq_id);
 	p_ramrod->srq_id.opaque_fid = cpu_to_le16(opaque_fid);
 	p_ramrod->page_size = cpu_to_le16(in_params->page_size);
 	DMA_REGPAIR_LE(p_ramrod->producers_addr, in_params->prod_pair_addr);
+	offset = (in_params->is_xrc) ? 0 : p_hwfn->p_rdma_info->srq_id_offset;
+	srq_id = (u16)returned_id + offset;
+	p_ramrod->srq_id.srq_idx = cpu_to_le16(srq_id);
 
+	if (in_params->is_xrc) {
+		SET_FIELD(p_ramrod->flags,
+			  RDMA_SRQ_CREATE_RAMROD_DATA_XRC_FLAG, 1);
+		SET_FIELD(p_ramrod->flags,
+			  RDMA_SRQ_CREATE_RAMROD_DATA_RESERVED_KEY_EN,
+			  in_params->reserved_key_en);
+		p_ramrod->xrc_srq_cq_cid =
+			cpu_to_le32((p_hwfn->hw_info.opaque_fid << 16) |
+				     in_params->cq_cid);
+		p_ramrod->xrc_domain = cpu_to_le16(in_params->xrcd_id);
+	}
 	rc = qed_spq_post(p_hwfn, p_ent, NULL);
 	if (rc)
 		goto err;
 
 	out_params->srq_id = srq_id;
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
-		   "SRQ created Id = %x\n", out_params->srq_id);
-
+	DP_VERBOSE(p_hwfn,
+		   QED_MSG_RDMA,
+		   "XRC/SRQ created Id = %x (is_xrc=%u)\n",
+		   out_params->srq_id, in_params->is_xrc);
 	return rc;
 
 err:
@@ -1961,6 +2064,8 @@ static int qed_iwarp_set_engine_affin(struct qed_dev *cdev, bool b_reset)
 	.rdma_cnq_prod_update = &qed_rdma_cnq_prod_update,
 	.rdma_alloc_pd = &qed_rdma_alloc_pd,
 	.rdma_dealloc_pd = &qed_rdma_free_pd,
+	.rdma_alloc_xrcd = &qed_rdma_alloc_xrcd,
+	.rdma_dealloc_xrcd = &qed_rdma_free_xrcd,
 	.rdma_create_cq = &qed_rdma_create_cq,
 	.rdma_destroy_cq = &qed_rdma_destroy_cq,
 	.rdma_create_qp = &qed_rdma_create_qp,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
index 3689fe3..5a7ebc7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
@@ -63,6 +63,11 @@
 #define QED_RDMA_MAX_CQE_32_BIT             (0x7FFFFFFF - 1)
 #define QED_RDMA_MAX_CQE_16_BIT             (0x7FFF - 1)
 
+/* Up to 2^16 XRC Domains are supported, but the actual number of supported XRC
+ * SRQs is much smaller so there's no need to have that many domains.
+ */
+#define QED_RDMA_MAX_XRCDS      (roundup_pow_of_two(RDMA_MAX_XRC_SRQS))
+
 enum qed_rdma_toggle_bit {
 	QED_RDMA_TOGGLE_BIT_CLEAR = 0,
 	QED_RDMA_TOGGLE_BIT_SET = 1
@@ -81,9 +86,11 @@ struct qed_rdma_info {
 
 	struct qed_bmap cq_map;
 	struct qed_bmap pd_map;
+	struct qed_bmap xrcd_map;
 	struct qed_bmap tid_map;
 	struct qed_bmap qp_map;
 	struct qed_bmap srq_map;
+	struct qed_bmap xrc_srq_map;
 	struct qed_bmap cid_map;
 	struct qed_bmap tcp_cid_map;
 	struct qed_bmap real_cid_map;
@@ -111,6 +118,7 @@ struct qed_rdma_qp {
 	u32 qpid;
 	u16 icid;
 	enum qed_roce_qp_state cur_state;
+	enum qed_rdma_qp_type qp_type;
 	enum qed_iwarp_qp_state iwarp_state;
 	bool use_srq;
 	bool signal_all;
@@ -153,18 +161,21 @@ struct qed_rdma_qp {
 	dma_addr_t orq_phys_addr;
 	u8 orq_num_pages;
 	bool req_offloaded;
+	bool has_req;
 
 	/* responder */
 	u8 max_rd_atomic_resp;
 	u32 rq_psn;
 	u16 rq_cq_id;
 	u16 rq_num_pages;
+	u16 xrcd_id;
 	dma_addr_t rq_pbl_ptr;
 	void *irq;
 	dma_addr_t irq_phys_addr;
 	u8 irq_num_pages;
 	bool resp_offloaded;
 	u32 cq_prod;
+	bool has_resp;
 
 	u8 remote_mac_addr[6];
 	u8 local_mac_addr[6];
@@ -174,6 +185,14 @@ struct qed_rdma_qp {
 	struct qed_iwarp_ep *ep;
 };
 
+static inline bool qed_rdma_is_xrc_qp(struct qed_rdma_qp *qp)
+{
+	if (qp->qp_type == QED_RDMA_QP_TYPE_XRC_TGT ||
+	    qp->qp_type == QED_RDMA_QP_TYPE_XRC_INI)
+		return true;
+
+	return false;
+}
 #if IS_ENABLED(CONFIG_QED_RDMA)
 void qed_rdma_dpm_bar(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
 void qed_rdma_dpm_conf(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 475b899..46a4d09 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -254,6 +254,9 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	int rc;
 	u8 tc;
 
+	if (!qp->has_resp)
+		return 0;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 
 	/* Allocate DMA-able memory for IRQ */
@@ -315,6 +318,10 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 		  ROCE_CREATE_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER,
 		  qp->min_rnr_nak_timer);
 
+	SET_FIELD(p_ramrod->flags,
+		  ROCE_CREATE_QP_RESP_RAMROD_DATA_XRC_FLAG,
+		  qed_rdma_is_xrc_qp(qp));
+
 	p_ramrod->max_ird = qp->max_rd_atomic_resp;
 	p_ramrod->traffic_class = qp->traffic_class_tos;
 	p_ramrod->hop_limit = qp->hop_limit_ttl;
@@ -335,6 +342,7 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	p_ramrod->qp_handle_for_cqe.lo = cpu_to_le32(qp->qp_handle.lo);
 	p_ramrod->cq_cid = cpu_to_le32((p_hwfn->hw_info.opaque_fid << 16) |
 				       qp->rq_cq_id);
+	p_ramrod->xrc_domain = cpu_to_le16(qp->xrcd_id);
 
 	tc = qed_roce_get_qp_tc(p_hwfn, qp);
 	regular_latency_queue = qed_get_cm_pq_idx_ofld_mtc(p_hwfn, tc);
@@ -395,6 +403,9 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 	int rc;
 	u8 tc;
 
+	if (!qp->has_req)
+		return 0;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 
 	/* Allocate DMA-able memory for ORQ */
@@ -444,6 +455,10 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 		  ROCE_CREATE_QP_REQ_RAMROD_DATA_RNR_NAK_CNT,
 		  qp->rnr_retry_cnt);
 
+	SET_FIELD(p_ramrod->flags,
+		  ROCE_CREATE_QP_REQ_RAMROD_DATA_XRC_FLAG,
+		  qed_rdma_is_xrc_qp(qp));
+
 	p_ramrod->max_ord = qp->max_rd_atomic_req;
 	p_ramrod->traffic_class = qp->traffic_class_tos;
 	p_ramrod->hop_limit = qp->hop_limit_ttl;
@@ -517,6 +532,9 @@ static int qed_roce_sp_modify_responder(struct qed_hwfn *p_hwfn,
 	struct qed_spq_entry *p_ent;
 	int rc;
 
+	if (!qp->has_resp)
+		return 0;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 
 	if (move_to_err && !qp->resp_offloaded)
@@ -611,6 +629,9 @@ static int qed_roce_sp_modify_requester(struct qed_hwfn *p_hwfn,
 	struct qed_spq_entry *p_ent;
 	int rc;
 
+	if (!qp->has_req)
+		return 0;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 
 	if (move_to_err && !(qp->req_offloaded))
@@ -705,6 +726,11 @@ static int qed_roce_sp_destroy_qp_responder(struct qed_hwfn *p_hwfn,
 	dma_addr_t ramrod_res_phys;
 	int rc;
 
+	if (!qp->has_resp) {
+		*cq_prod = 0;
+		return 0;
+	}
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 	*cq_prod = qp->cq_prod;
 
@@ -785,6 +811,9 @@ static int qed_roce_sp_destroy_qp_requester(struct qed_hwfn *p_hwfn,
 	dma_addr_t ramrod_res_phys;
 	int rc = -ENOMEM;
 
+	if (!qp->has_req)
+		return 0;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", qp->icid);
 
 	if (!qp->req_offloaded)
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index 74efca1..f93edd5 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -53,6 +53,13 @@ enum qed_roce_qp_state {
 	QED_ROCE_QP_STATE_SQE
 };
 
+enum qed_rdma_qp_type {
+	QED_RDMA_QP_TYPE_RC,
+	QED_RDMA_QP_TYPE_XRC_INI,
+	QED_RDMA_QP_TYPE_XRC_TGT,
+	QED_RDMA_QP_TYPE_INVAL = 0xffff,
+};
+
 enum qed_rdma_tid_type {
 	QED_RDMA_TID_REGISTERED_MR,
 	QED_RDMA_TID_FMR,
@@ -291,6 +298,12 @@ struct qed_rdma_create_srq_in_params {
 	u16 num_pages;
 	u16 pd_id;
 	u16 page_size;
+
+	/* XRC related only */
+	bool reserved_key_en;
+	bool is_xrc;
+	u32 cq_cid;
+	u16 xrcd_id;
 };
 
 struct qed_rdma_destroy_cq_in_params {
@@ -319,7 +332,9 @@ struct qed_rdma_create_qp_in_params {
 	u16 rq_num_pages;
 	u64 rq_pbl_ptr;
 	u16 srq_id;
+	u16 xrcd_id;
 	u8 stats_queue;
+	enum qed_rdma_qp_type qp_type;
 };
 
 struct qed_rdma_create_qp_out_params {
@@ -429,11 +444,13 @@ struct qed_rdma_create_srq_out_params {
 
 struct qed_rdma_destroy_srq_in_params {
 	u16 srq_id;
+	bool is_xrc;
 };
 
 struct qed_rdma_modify_srq_in_params {
 	u32 wqe_limit;
 	u16 srq_id;
+	bool is_xrc;
 };
 
 struct qed_rdma_stats_out_params {
@@ -611,6 +628,8 @@ struct qed_rdma_ops {
 	int (*rdma_set_rdma_int)(struct qed_dev *cdev, u16 cnt);
 	int (*rdma_alloc_pd)(void *rdma_cxt, u16 *pd);
 	void (*rdma_dealloc_pd)(void *rdma_cxt, u16 pd);
+	int (*rdma_alloc_xrcd)(void *rdma_cxt, u16 *xrcd);
+	void (*rdma_dealloc_xrcd)(void *rdma_cxt, u16 xrcd);
 	int (*rdma_create_cq)(void *rdma_cxt,
 			      struct qed_rdma_create_cq_in_params *params,
 			      u16 *icid);
-- 
1.8.3.1

