Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A3215AE5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgGFPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729545AbgGFPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066Fb2ps011557;
        Mon, 6 Jul 2020 08:39:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=+xvkJ7VdRjsghSQ8k8x84vtQru9YWkhYUBSKRlDq7g8=;
 b=qm3D2sp/keYhsaDTO9eMlfyRf6WW5I9Tkpi/QbKThcb8hgE9joF5jyTiQCROaGJAUVvy
 Z6FJdDkjfHUKSQOzVg+JhMLmIgNw6Ih2AmiWDmvA1VEqNOfm/pCzTb67ELh+XosX+0UP
 4nA2nDIPZxyisvCXmXsM/uU3grsccDdktKCUGmWLp4vRAJwWo6uAvVRX+xNGlRzgv/tk
 surVoVEEAGeCHAjiCg9VmSwXgPf3MbJJ/a862TQi+8SxEq1alm1tQoZFS1V7wWgSvJv6
 Y8I/LvljHOQd+As+qJPEImFk91a2+hUhP1PUkmrtxOCOxZ6tP6NR4RcTvtMJKumSOkTa kA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 322s9n6waq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:12 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 932C43F703F;
        Mon,  6 Jul 2020 08:39:09 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 6/9] net: qed: use ptr shortcuts to dedup field accessing in some parts
Date:   Mon, 6 Jul 2020 18:38:18 +0300
Message-ID: <20200706153821.786-7-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use intermediate pointers instead of multiple dereferencing to
simplify and beautify parts of code that will be addressed in
the next commit.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  5 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   | 18 +++---
 drivers/net/ethernet/qlogic/qed/qed_l2.c      | 61 ++++++++++---------
 drivers/net/ethernet/qlogic/qed/qed_roce.c    | 24 +++-----
 .../net/ethernet/qlogic/qed/qed_sp_commands.c | 24 ++++----
 5 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index e3fe982532d5..3a62358b9749 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2170,6 +2170,7 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 			  enum qed_cxt_elem_type elem_type, u32 iid)
 {
 	u32 reg_offset, shadow_line, elem_size, hw_p_size, elems_per_p, line;
+	struct tdif_task_context *tdif_context;
 	struct qed_ilt_client_cfg *p_cli;
 	struct qed_ilt_cli_blk *p_blk;
 	struct qed_ptt *p_ptt;
@@ -2252,7 +2253,9 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 
 		for (elem_i = 0; elem_i < elems_per_p; elem_i++) {
 			elem = (union type1_task_context *)elem_start;
-			SET_FIELD(elem->roce_ctx.tdif_context.flags1,
+			tdif_context = &elem->roce_ctx.tdif_context;
+
+			SET_FIELD(tdif_context->flags1,
 				  TDIF_TASK_CONTEXT_REF_TAG_MASK, 0xf);
 			elem_start += TYPE1_TASK_CXT_SIZE(p_hwfn);
 		}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 6f2cd5a18e5f..55e73a842507 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -808,6 +808,7 @@ static int
 qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 {
 	struct iwarp_mpa_offload_ramrod_data *p_mpa_ramrod;
+	struct mpa_outgoing_params *common;
 	struct qed_iwarp_info *iwarp_info;
 	struct qed_sp_init_data init_data;
 	dma_addr_t async_output_phys;
@@ -840,16 +841,17 @@ qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 		return rc;
 
 	p_mpa_ramrod = &p_ent->ramrod.iwarp_mpa_offload;
+	common = &p_mpa_ramrod->common;
+
 	out_pdata_phys = ep->ep_buffer_phys +
 			 offsetof(struct qed_iwarp_ep_memory, out_pdata);
-	DMA_REGPAIR_LE(p_mpa_ramrod->common.outgoing_ulp_buffer.addr,
-		       out_pdata_phys);
-	p_mpa_ramrod->common.outgoing_ulp_buffer.len =
-	    ep->cm_info.private_data_len;
-	p_mpa_ramrod->common.crc_needed = p_hwfn->p_rdma_info->iwarp.crc_needed;
+	DMA_REGPAIR_LE(common->outgoing_ulp_buffer.addr, out_pdata_phys);
+
+	common->outgoing_ulp_buffer.len = ep->cm_info.private_data_len;
+	common->crc_needed = p_hwfn->p_rdma_info->iwarp.crc_needed;
 
-	p_mpa_ramrod->common.out_rq.ord = ep->cm_info.ord;
-	p_mpa_ramrod->common.out_rq.ird = ep->cm_info.ird;
+	common->out_rq.ord = ep->cm_info.ord;
+	common->out_rq.ird = ep->cm_info.ird;
 
 	p_mpa_ramrod->tcp_cid = p_hwfn->hw_info.opaque_fid << 16 | ep->tcp_cid;
 
@@ -873,7 +875,7 @@ qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 		p_mpa_ramrod->stats_counter_id =
 		    RESC_START(p_hwfn, QED_RDMA_STATS_QUEUE) + qp->stats_queue;
 	} else {
-		p_mpa_ramrod->common.reject = 1;
+		common->reject = 1;
 	}
 
 	iwarp_info = &p_hwfn->p_rdma_info->iwarp;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index bf02748f5185..41afd15f4991 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -342,6 +342,7 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 			   struct qed_sp_vport_start_params *p_params)
 {
 	struct vport_start_ramrod_data *p_ramrod = NULL;
+	struct eth_vport_tpa_param *tpa_param;
 	struct qed_spq_entry *p_ent =  NULL;
 	struct qed_sp_init_data init_data;
 	u8 abs_vport_id = 0;
@@ -378,21 +379,21 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 	p_ramrod->rx_mode.state = cpu_to_le16(rx_mode);
 
 	/* TPA related fields */
-	memset(&p_ramrod->tpa_param, 0, sizeof(struct eth_vport_tpa_param));
+	tpa_param = &p_ramrod->tpa_param;
+	memset(tpa_param, 0, sizeof(*tpa_param));
 
-	p_ramrod->tpa_param.max_buff_num = p_params->max_buffers_per_cqe;
+	tpa_param->max_buff_num = p_params->max_buffers_per_cqe;
 
 	switch (p_params->tpa_mode) {
 	case QED_TPA_MODE_GRO:
-		p_ramrod->tpa_param.tpa_max_aggs_num = ETH_TPA_MAX_AGGS_NUM;
-		p_ramrod->tpa_param.tpa_max_size = (u16)-1;
-		p_ramrod->tpa_param.tpa_min_size_to_cont = p_params->mtu / 2;
-		p_ramrod->tpa_param.tpa_min_size_to_start = p_params->mtu / 2;
-		p_ramrod->tpa_param.tpa_ipv4_en_flg = 1;
-		p_ramrod->tpa_param.tpa_ipv6_en_flg = 1;
-		p_ramrod->tpa_param.tpa_pkt_split_flg = 1;
-		p_ramrod->tpa_param.tpa_gro_consistent_flg = 1;
-		break;
+		tpa_param->tpa_max_aggs_num = ETH_TPA_MAX_AGGS_NUM;
+		tpa_param->tpa_max_size = (u16)-1;
+		tpa_param->tpa_min_size_to_cont = p_params->mtu / 2;
+		tpa_param->tpa_min_size_to_start = p_params->mtu / 2;
+		tpa_param->tpa_ipv4_en_flg = 1;
+		tpa_param->tpa_ipv6_en_flg = 1;
+		tpa_param->tpa_pkt_split_flg = 1;
+		tpa_param->tpa_gro_consistent_flg = 1;
 	default:
 		break;
 	}
@@ -601,33 +602,33 @@ qed_sp_update_accept_mode(struct qed_hwfn *p_hwfn,
 static void
 qed_sp_vport_update_sge_tpa(struct qed_hwfn *p_hwfn,
 			    struct vport_update_ramrod_data *p_ramrod,
-			    struct qed_sge_tpa_params *p_params)
+			    const struct qed_sge_tpa_params *param)
 {
-	struct eth_vport_tpa_param *p_tpa;
+	struct eth_vport_tpa_param *tpa;
 
-	if (!p_params) {
+	if (!param) {
 		p_ramrod->common.update_tpa_param_flg = 0;
 		p_ramrod->common.update_tpa_en_flg = 0;
 		p_ramrod->common.update_tpa_param_flg = 0;
 		return;
 	}
 
-	p_ramrod->common.update_tpa_en_flg = p_params->update_tpa_en_flg;
-	p_tpa = &p_ramrod->tpa_param;
-	p_tpa->tpa_ipv4_en_flg = p_params->tpa_ipv4_en_flg;
-	p_tpa->tpa_ipv6_en_flg = p_params->tpa_ipv6_en_flg;
-	p_tpa->tpa_ipv4_tunn_en_flg = p_params->tpa_ipv4_tunn_en_flg;
-	p_tpa->tpa_ipv6_tunn_en_flg = p_params->tpa_ipv6_tunn_en_flg;
-
-	p_ramrod->common.update_tpa_param_flg = p_params->update_tpa_param_flg;
-	p_tpa->max_buff_num = p_params->max_buffers_per_cqe;
-	p_tpa->tpa_pkt_split_flg = p_params->tpa_pkt_split_flg;
-	p_tpa->tpa_hdr_data_split_flg = p_params->tpa_hdr_data_split_flg;
-	p_tpa->tpa_gro_consistent_flg = p_params->tpa_gro_consistent_flg;
-	p_tpa->tpa_max_aggs_num = p_params->tpa_max_aggs_num;
-	p_tpa->tpa_max_size = p_params->tpa_max_size;
-	p_tpa->tpa_min_size_to_start = p_params->tpa_min_size_to_start;
-	p_tpa->tpa_min_size_to_cont = p_params->tpa_min_size_to_cont;
+	p_ramrod->common.update_tpa_en_flg = param->update_tpa_en_flg;
+	tpa = &p_ramrod->tpa_param;
+	tpa->tpa_ipv4_en_flg = param->tpa_ipv4_en_flg;
+	tpa->tpa_ipv6_en_flg = param->tpa_ipv6_en_flg;
+	tpa->tpa_ipv4_tunn_en_flg = param->tpa_ipv4_tunn_en_flg;
+	tpa->tpa_ipv6_tunn_en_flg = param->tpa_ipv6_tunn_en_flg;
+
+	p_ramrod->common.update_tpa_param_flg = param->update_tpa_param_flg;
+	tpa->max_buff_num = param->max_buffers_per_cqe;
+	tpa->tpa_pkt_split_flg = param->tpa_pkt_split_flg;
+	tpa->tpa_hdr_data_split_flg = param->tpa_hdr_data_split_flg;
+	tpa->tpa_gro_consistent_flg = param->tpa_gro_consistent_flg;
+	tpa->tpa_max_aggs_num = param->tpa_max_aggs_num;
+	tpa->tpa_max_size = param->tpa_max_size;
+	tpa->tpa_min_size_to_start = param->tpa_min_size_to_start;
+	tpa->tpa_min_size_to_cont = param->tpa_min_size_to_cont;
 }
 
 static void
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 871282187268..5433e43a1930 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -42,29 +42,25 @@ static int qed_roce_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
 				u8 fw_return_code)
 {
 	struct qed_rdma_events events = p_hwfn->p_rdma_info->events;
+	union rdma_eqe_data *rdata = &data->rdma_data;
 
 	if (fw_event_code == ROCE_ASYNC_EVENT_DESTROY_QP_DONE) {
-		u16 icid =
-		    (u16)le32_to_cpu(data->rdma_data.rdma_destroy_qp_data.cid);
+		u16 icid = (u16)le32_to_cpu(rdata->rdma_destroy_qp_data.cid);
 
 		/* icid release in this async event can occur only if the icid
 		 * was offloaded to the FW. In case it wasn't offloaded this is
 		 * handled in qed_roce_sp_destroy_qp.
 		 */
 		qed_roce_free_real_icid(p_hwfn, icid);
-	} else {
-		if (fw_event_code == ROCE_ASYNC_EVENT_SRQ_EMPTY ||
-		    fw_event_code == ROCE_ASYNC_EVENT_SRQ_LIMIT) {
-			u16 srq_id = (u16)data->rdma_data.async_handle.lo;
-
-			events.affiliated_event(events.context, fw_event_code,
-						&srq_id);
-		} else {
-			union rdma_eqe_data rdata = data->rdma_data;
+	} else if (fw_event_code == ROCE_ASYNC_EVENT_SRQ_EMPTY ||
+		   fw_event_code == ROCE_ASYNC_EVENT_SRQ_LIMIT) {
+		u16 srq_id = (u16)rdata->async_handle.lo;
 
-			events.affiliated_event(events.context, fw_event_code,
-						(void *)&rdata.async_handle);
-		}
+		events.affiliated_event(events.context, fw_event_code,
+					&srq_id);
+	} else {
+		events.affiliated_event(events.context, fw_event_code,
+					(void *)&rdata->async_handle);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 745d76d13732..71ab57bca7c9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -300,6 +300,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 		    struct qed_tunnel_info *p_tunn,
 		    bool allow_npar_tx_switch)
 {
+	struct outer_tag_config_struct *outer_tag_config;
 	struct pf_start_ramrod_data *p_ramrod = NULL;
 	u16 sb = qed_int_get_sp_sb_id(p_hwfn);
 	u8 sb_index = p_hwfn->p_eq->eq_sb_index;
@@ -336,29 +337,30 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 	else
 		p_ramrod->mf_mode = MF_NPAR;
 
-	p_ramrod->outer_tag_config.outer_tag.tci =
-				cpu_to_le16(p_hwfn->hw_info.ovlan);
+	outer_tag_config = &p_ramrod->outer_tag_config;
+	outer_tag_config->outer_tag.tci = cpu_to_le16(p_hwfn->hw_info.ovlan);
+
 	if (test_bit(QED_MF_8021Q_TAGGING, &p_hwfn->cdev->mf_bits)) {
-		p_ramrod->outer_tag_config.outer_tag.tpid = ETH_P_8021Q;
+		outer_tag_config->outer_tag.tpid = ETH_P_8021Q;
 	} else if (test_bit(QED_MF_8021AD_TAGGING, &p_hwfn->cdev->mf_bits)) {
-		p_ramrod->outer_tag_config.outer_tag.tpid = ETH_P_8021AD;
-		p_ramrod->outer_tag_config.enable_stag_pri_change = 1;
+		outer_tag_config->outer_tag.tpid = ETH_P_8021AD;
+		outer_tag_config->enable_stag_pri_change = 1;
 	}
 
-	p_ramrod->outer_tag_config.pri_map_valid = 1;
+	outer_tag_config->pri_map_valid = 1;
 	for (i = 0; i < QED_MAX_PFC_PRIORITIES; i++)
-		p_ramrod->outer_tag_config.inner_to_outer_pri_map[i] = i;
+		outer_tag_config->inner_to_outer_pri_map[i] = i;
 
 	/* enable_stag_pri_change should be set if port is in BD mode or,
 	 * UFP with Host Control mode.
 	 */
 	if (test_bit(QED_MF_UFP_SPECIFIC, &p_hwfn->cdev->mf_bits)) {
 		if (p_hwfn->ufp_info.pri_type == QED_UFP_PRI_OS)
-			p_ramrod->outer_tag_config.enable_stag_pri_change = 1;
+			outer_tag_config->enable_stag_pri_change = 1;
 		else
-			p_ramrod->outer_tag_config.enable_stag_pri_change = 0;
+			outer_tag_config->enable_stag_pri_change = 0;
 
-		p_ramrod->outer_tag_config.outer_tag.tci |=
+		outer_tag_config->outer_tag.tci |=
 		    cpu_to_le16(((u16)p_hwfn->ufp_info.tc << 13));
 	}
 
@@ -406,7 +408,7 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 
 	DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
 		   "Setting event_ring_sb [id %04x index %02x], outer_tag.tci [%d]\n",
-		   sb, sb_index, p_ramrod->outer_tag_config.outer_tag.tci);
+		   sb, sb_index, outer_tag_config->outer_tag.tci);
 
 	rc = qed_spq_post(p_hwfn, p_ent, NULL);
 
-- 
2.25.1

