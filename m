Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60A14A4FF
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgA0N0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9368 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728690AbgA0N0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDQbuw032252;
        Mon, 27 Jan 2020 05:26:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=e5Gswfd8kMWjiu3nSUin8vr0VTK5Pgr7i0akhQ0N2Pg=;
 b=kjuvh3TS2FhPpH2+xO2kxz9zLDlvUXOKSg/NqbX9wEiLvJmSlG4OHRfbLwItRKoCTV7U
 0hBn4K3AllOgL/AmTshVoWdxtQw+KQDK2fWtAROvS5IN/iTZYxOROlCX93vA183mG4lm
 wXEWOIOv77wcyepReKfm4rF3RFMAEt1htUu4XruYNYP+iq0bkhZfO+uHRG0T5nTiby8V
 ahdb0JhBKqYXUJJU5RFt3o/tSCV+VfRgJFTjjMG1qzsjg8tpKG/qF8eJN26MyIu87IKw
 BEkX8ChEGVLB2PVNbG6t3tlWXeQ53tO63x22p8tPfLGsc9j0+QYEszbTzTT4z6TkGP8l Gg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xrp2sxxv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:43 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:41 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:41 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 1B8B53F7044;
        Mon, 27 Jan 2020 05:26:39 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 06/13] qed: FW 8.42.2.0 Additional ll2 type
Date:   Mon, 27 Jan 2020 15:26:12 +0200
Message-ID: <20200127132619.27144-7-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200127132619.27144-1-michal.kalderon@marvell.com>
References: <20200127132619.27144-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LL2 queues were a limited resource due to FW constraints.
This FW introduced a new resource which is a context based ll2 queue
(memory on host). The additional ll2 queues are required for RDMA SRIOV.
The code refers to the previous ll2 queues as ram-based or legacy, and the
new queues as ctx-based.
This change decreased the "legacy" ram-based queues therefore the first ll2
queue used for iWARP was converted to the ctx-based ll2 queue.
This feature also exposed a bug in the DIRECT_REG_WR64 macro implementation
which didn't have an effect in other use cases.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h       |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c   |  20 ++--
 drivers/net/ethernet/qlogic/qed/qed_hsi.h   |  42 +++++++-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c |   5 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c |   8 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c   | 149 ++++++++++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_ll2.h   |  14 +++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   |   5 +-
 include/linux/qed/common_hsi.h              |  15 ++-
 include/linux/qed/qed_if.h                  |   4 +-
 include/linux/qed/qed_ll2_if.h              |   7 ++
 11 files changed, 235 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 8ec46bf409c2..cfa45fb9a5a4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -253,7 +253,8 @@ enum qed_resources {
 	QED_VLAN,
 	QED_RDMA_CNQ_RAM,
 	QED_ILT,
-	QED_LL2_QUEUE,
+	QED_LL2_RAM_QUEUE,
+	QED_LL2_CTX_QUEUE,
 	QED_CMDQS_CQS,
 	QED_RDMA_STATS_QUEUE,
 	QED_BDQ,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 479d98e6187a..898c1f8d1530 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3565,8 +3565,10 @@ const char *qed_hw_get_resc_name(enum qed_resources res_id)
 		return "RDMA_CNQ_RAM";
 	case QED_ILT:
 		return "ILT";
-	case QED_LL2_QUEUE:
-		return "LL2_QUEUE";
+	case QED_LL2_RAM_QUEUE:
+		return "LL2_RAM_QUEUE";
+	case QED_LL2_CTX_QUEUE:
+		return "LL2_CTX_QUEUE";
 	case QED_CMDQS_CQS:
 		return "CMDQS_CQS";
 	case QED_RDMA_STATS_QUEUE:
@@ -3615,8 +3617,11 @@ qed_hw_set_soft_resc_size(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 	for (res_id = 0; res_id < QED_MAX_RESC; res_id++) {
 		switch (res_id) {
-		case QED_LL2_QUEUE:
-			resc_max_val = MAX_NUM_LL2_RX_QUEUES;
+		case QED_LL2_RAM_QUEUE:
+			resc_max_val = MAX_NUM_LL2_RX_RAM_QUEUES;
+			break;
+		case QED_LL2_CTX_QUEUE:
+			resc_max_val = MAX_NUM_LL2_RX_CTX_QUEUES;
 			break;
 		case QED_RDMA_CNQ_RAM:
 			/* No need for a case for QED_CMDQS_CQS since
@@ -3691,8 +3696,11 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 		*p_resc_num = (b_ah ? PXP_NUM_ILT_RECORDS_K2 :
 			       PXP_NUM_ILT_RECORDS_BB) / num_funcs;
 		break;
-	case QED_LL2_QUEUE:
-		*p_resc_num = MAX_NUM_LL2_RX_QUEUES / num_funcs;
+	case QED_LL2_RAM_QUEUE:
+		*p_resc_num = MAX_NUM_LL2_RX_RAM_QUEUES / num_funcs;
+		break;
+	case QED_LL2_CTX_QUEUE:
+		*p_resc_num = MAX_NUM_LL2_RX_CTX_QUEUES / num_funcs;
 		break;
 	case QED_RDMA_CNQ_RAM:
 	case QED_CMDQS_CQS:
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index cced2ce365de..f0e5195cae01 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -98,6 +98,7 @@ enum core_event_opcode {
 	CORE_EVENT_RX_QUEUE_STOP,
 	CORE_EVENT_RX_QUEUE_FLUSH,
 	CORE_EVENT_TX_QUEUE_UPDATE,
+	CORE_EVENT_QUEUE_STATS_QUERY,
 	MAX_CORE_EVENT_OPCODE
 };
 
@@ -116,7 +117,7 @@ struct core_ll2_port_stats {
 	struct regpair gsi_crcchksm_error;
 };
 
-/* Ethernet TX Per Queue Stats */
+/* LL2 TX Per Queue Stats */
 struct core_ll2_pstorm_per_queue_stat {
 	struct regpair sent_ucast_bytes;
 	struct regpair sent_mcast_bytes;
@@ -124,13 +125,13 @@ struct core_ll2_pstorm_per_queue_stat {
 	struct regpair sent_ucast_pkts;
 	struct regpair sent_mcast_pkts;
 	struct regpair sent_bcast_pkts;
+	struct regpair error_drop_pkts;
 };
 
 /* Light-L2 RX Producers in Tstorm RAM */
 struct core_ll2_rx_prod {
 	__le16 bd_prod;
 	__le16 cqe_prod;
-	__le32 reserved;
 };
 
 struct core_ll2_tstorm_per_queue_stat {
@@ -147,6 +148,18 @@ struct core_ll2_ustorm_per_queue_stat {
 	struct regpair rcv_bcast_pkts;
 };
 
+/* Structure for doorbell data, in PWM mode, for RX producers update. */
+struct core_pwm_prod_update_data {
+	__le16 icid; /* internal CID */
+	u8 reserved0;
+	u8 params;
+#define CORE_PWM_PROD_UPDATE_DATA_AGG_CMD_MASK	  0x3
+#define CORE_PWM_PROD_UPDATE_DATA_AGG_CMD_SHIFT   0
+#define CORE_PWM_PROD_UPDATE_DATA_RESERVED1_MASK  0x3F	/* Set 0 */
+#define CORE_PWM_PROD_UPDATE_DATA_RESERVED1_SHIFT 2
+	struct core_ll2_rx_prod prod; /* Producers */
+};
+
 /* Core Ramrod Command IDs (light L2) */
 enum core_ramrod_cmd_id {
 	CORE_RAMROD_UNUSED,
@@ -156,6 +169,7 @@ enum core_ramrod_cmd_id {
 	CORE_RAMROD_TX_QUEUE_STOP,
 	CORE_RAMROD_RX_QUEUE_FLUSH,
 	CORE_RAMROD_TX_QUEUE_UPDATE,
+	CORE_RAMROD_QUEUE_STATS_QUERY,
 	MAX_CORE_RAMROD_CMD_ID
 };
 
@@ -274,8 +288,11 @@ struct core_rx_start_ramrod_data {
 	u8 mf_si_mcast_accept_all;
 	struct core_rx_action_on_error action_on_error;
 	u8 gsi_offload_flag;
+	u8 vport_id_valid;
+	u8 vport_id;
+	u8 zero_prod_flg;
 	u8 wipe_inner_vlan_pri_en;
-	u8 reserved[5];
+	u8 reserved[2];
 };
 
 /* Ramrod data for rx queue stop ramrod */
@@ -352,8 +369,11 @@ struct core_tx_start_ramrod_data {
 	__le16 pbl_size;
 	__le16 qm_pq_id;
 	u8 gsi_offload_flag;
+	u8 ctx_stats_en;
+	u8 vport_id_valid;
 	u8 vport_id;
-	u8 resrved[2];
+	u8 enforce_security_flag;
+	u8 reserved[7];
 };
 
 /* Ramrod data for tx queue stop ramrod */
@@ -761,7 +781,7 @@ struct e4_tstorm_core_conn_ag_ctx {
 	__le16 word1;
 	__le16 word2;
 	__le16 word3;
-	__le32 reg9;
+	__le32 ll2_rx_prod;
 	__le32 reg10;
 };
 
@@ -844,6 +864,11 @@ struct ustorm_core_conn_st_ctx {
 	__le32 reserved[4];
 };
 
+/* The core storm context for the Tstorm */
+struct tstorm_core_conn_st_ctx {
+	__le32 reserved[4];
+};
+
 /* core connection context */
 struct e4_core_conn_context {
 	struct ystorm_core_conn_st_ctx ystorm_st_context;
@@ -857,6 +882,8 @@ struct e4_core_conn_context {
 	struct mstorm_core_conn_st_ctx mstorm_st_context;
 	struct ustorm_core_conn_st_ctx ustorm_st_context;
 	struct regpair ustorm_st_padding[2];
+	struct tstorm_core_conn_st_ctx tstorm_st_context;
+	struct regpair tstorm_st_padding[2];
 };
 
 struct eth_mstorm_per_pf_stat {
@@ -12483,6 +12510,11 @@ enum resource_id_enum {
 	RESOURCE_LL2_QUEUE_E = 15,
 	RESOURCE_RDMA_STATS_QUEUE_E = 16,
 	RESOURCE_BDQ_E = 17,
+	RESOURCE_QCN_E = 18,
+	RESOURCE_LLH_FILTER_E = 19,
+	RESOURCE_VF_MAC_ADDR = 20,
+	RESOURCE_LL2_CQS_E = 21,
+	RESOURCE_VF_CNQS = 22,
 	RESOURCE_MAX_NUM,
 	RESOURCE_NUM_INVALID = 0xFFFFFFFF
 };
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 5585c18053ec..8ee668d66b4b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -213,8 +213,9 @@ qed_sp_iscsi_func_start(struct qed_hwfn *p_hwfn,
 	p_init->num_sq_pages_in_ring = p_params->num_sq_pages_in_ring;
 	p_init->num_r2tq_pages_in_ring = p_params->num_r2tq_pages_in_ring;
 	p_init->num_uhq_pages_in_ring = p_params->num_uhq_pages_in_ring;
-	p_init->ll2_rx_queue_id = p_hwfn->hw_info.resc_start[QED_LL2_QUEUE] +
-				  p_params->ll2_ooo_queue_id;
+	p_init->ll2_rx_queue_id =
+	    p_hwfn->hw_info.resc_start[QED_LL2_RAM_QUEUE] +
+	    p_params->ll2_ooo_queue_id;
 
 	p_init->func_params.log_page_size = p_params->log_page_size;
 	val = p_params->num_tasks;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 65ec16a31658..d2fe61a5cf56 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -137,8 +137,8 @@ qed_iwarp_init_fw_ramrod(struct qed_hwfn *p_hwfn,
 			 struct iwarp_init_func_ramrod_data *p_ramrod)
 {
 	p_ramrod->iwarp.ll2_ooo_q_index =
-		RESC_START(p_hwfn, QED_LL2_QUEUE) +
-		p_hwfn->p_rdma_info->iwarp.ll2_ooo_handle;
+	    RESC_START(p_hwfn, QED_LL2_RAM_QUEUE) +
+	    p_hwfn->p_rdma_info->iwarp.ll2_ooo_handle;
 
 	p_ramrod->tcp.max_fin_rt = QED_IWARP_MAX_FIN_RT_DEFAULT;
 
@@ -2651,6 +2651,8 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 
 	memset(&data, 0, sizeof(data));
 	data.input.conn_type = QED_LL2_TYPE_IWARP;
+	/* SYN will use ctx based queues */
+	data.input.rx_conn_type = QED_LL2_RX_TYPE_CTX;
 	data.input.mtu = params->max_mtu;
 	data.input.rx_num_desc = QED_IWARP_LL2_SYN_RX_SIZE;
 	data.input.tx_num_desc = QED_IWARP_LL2_SYN_TX_SIZE;
@@ -2683,6 +2685,8 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 
 	/* Start OOO connection */
 	data.input.conn_type = QED_LL2_TYPE_OOO;
+	/* OOO/unaligned will use legacy ll2 queues (ram based) */
+	data.input.rx_conn_type = QED_LL2_RX_TYPE_LEGACY;
 	data.input.mtu = params->max_mtu;
 
 	n_ooo_bufs = (QED_IWARP_MAX_OOO * rcv_wnd_size) /
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 19a1a58d60f8..037e5978787e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -962,7 +962,7 @@ static int qed_sp_ll2_rx_queue_start(struct qed_hwfn *p_hwfn,
 		return rc;
 
 	p_ramrod = &p_ent->ramrod.core_rx_queue_start;
-
+	memset(p_ramrod, 0, sizeof(*p_ramrod));
 	p_ramrod->sb_id = cpu_to_le16(qed_int_get_sp_sb_id(p_hwfn));
 	p_ramrod->sb_index = p_rx->rx_sb_index;
 	p_ramrod->complete_event_flg = 1;
@@ -996,6 +996,8 @@ static int qed_sp_ll2_rx_queue_start(struct qed_hwfn *p_hwfn,
 
 	p_ramrod->action_on_error.error_type = action_on_error;
 	p_ramrod->gsi_offload_flag = p_ll2_conn->input.gsi_enable;
+	p_ramrod->zero_prod_flg = 1;
+
 	return qed_spq_post(p_hwfn, p_ent, NULL);
 }
 
@@ -1317,6 +1319,25 @@ qed_ll2_set_cbs(struct qed_ll2_info *p_ll2_info, const struct qed_ll2_cbs *cbs)
 	return 0;
 }
 
+static void _qed_ll2_calc_allowed_conns(struct qed_hwfn *p_hwfn,
+					struct qed_ll2_acquire_data *data,
+					u8 *start_idx, u8 *last_idx)
+{
+	/* LL2 queues handles will be split as follows:
+	 * First will be the legacy queues, and then the ctx based.
+	 */
+	if (data->input.rx_conn_type == QED_LL2_RX_TYPE_LEGACY) {
+		*start_idx = QED_LL2_LEGACY_CONN_BASE_PF;
+		*last_idx = *start_idx +
+			QED_MAX_NUM_OF_LEGACY_LL2_CONNS_PF;
+	} else {
+		/* QED_LL2_RX_TYPE_CTX */
+		*start_idx = QED_LL2_CTX_CONN_BASE_PF;
+		*last_idx = *start_idx +
+			QED_MAX_NUM_OF_CTX_LL2_CONNS_PF;
+	}
+}
+
 static enum core_error_handle
 qed_ll2_get_error_choice(enum qed_ll2_error_handle err)
 {
@@ -1337,14 +1358,16 @@ int qed_ll2_acquire_connection(void *cxt, struct qed_ll2_acquire_data *data)
 	struct qed_hwfn *p_hwfn = cxt;
 	qed_int_comp_cb_t comp_rx_cb, comp_tx_cb;
 	struct qed_ll2_info *p_ll2_info = NULL;
-	u8 i, *p_tx_max;
+	u8 i, first_idx, last_idx, *p_tx_max;
 	int rc;
 
 	if (!data->p_connection_handle || !p_hwfn->p_ll2_info)
 		return -EINVAL;
 
+	_qed_ll2_calc_allowed_conns(p_hwfn, data, &first_idx, &last_idx);
+
 	/* Find a free connection to be used */
-	for (i = 0; (i < QED_MAX_NUM_OF_LL2_CONNECTIONS); i++) {
+	for (i = first_idx; i < last_idx; i++) {
 		mutex_lock(&p_hwfn->p_ll2_info[i].mutex);
 		if (p_hwfn->p_ll2_info[i].b_active) {
 			mutex_unlock(&p_hwfn->p_ll2_info[i].mutex);
@@ -1448,6 +1471,7 @@ static int qed_ll2_establish_connection_rx(struct qed_hwfn *p_hwfn,
 	enum qed_ll2_error_handle error_input;
 	enum core_error_handle error_mode;
 	u8 action_on_error = 0;
+	int rc;
 
 	if (!QED_LL2_RX_REGISTERED(p_ll2_conn))
 		return 0;
@@ -1461,7 +1485,18 @@ static int qed_ll2_establish_connection_rx(struct qed_hwfn *p_hwfn,
 	error_mode = qed_ll2_get_error_choice(error_input);
 	SET_FIELD(action_on_error, CORE_RX_ACTION_ON_ERROR_NO_BUFF, error_mode);
 
-	return qed_sp_ll2_rx_queue_start(p_hwfn, p_ll2_conn, action_on_error);
+	rc = qed_sp_ll2_rx_queue_start(p_hwfn, p_ll2_conn, action_on_error);
+	if (rc)
+		return rc;
+
+	if (p_ll2_conn->rx_queue.ctx_based) {
+		rc = qed_db_recovery_add(p_hwfn->cdev,
+					 p_ll2_conn->rx_queue.set_prod_addr,
+					 &p_ll2_conn->rx_queue.db_data,
+					 DB_REC_WIDTH_64B, DB_REC_KERNEL);
+	}
+
+	return rc;
 }
 
 static void
@@ -1475,13 +1510,41 @@ qed_ll2_establish_connection_ooo(struct qed_hwfn *p_hwfn,
 	qed_ooo_submit_rx_buffers(p_hwfn, p_ll2_conn);
 }
 
+static inline u8 qed_ll2_handle_to_queue_id(struct qed_hwfn *p_hwfn,
+					    u8 handle,
+					    u8 ll2_queue_type)
+{
+	u8 qid;
+
+	if (ll2_queue_type == QED_LL2_RX_TYPE_LEGACY)
+		return p_hwfn->hw_info.resc_start[QED_LL2_RAM_QUEUE] + handle;
+
+	/* QED_LL2_RX_TYPE_CTX
+	 * FW distinguishes between the legacy queues (ram based) and the
+	 * ctx based queues by the queue_id.
+	 * The first MAX_NUM_LL2_RX_RAM_QUEUES queues are legacy
+	 * and the queue ids above that are ctx base.
+	 */
+	qid = p_hwfn->hw_info.resc_start[QED_LL2_CTX_QUEUE] +
+	      MAX_NUM_LL2_RX_RAM_QUEUES;
+
+	/* See comment on the acquire connection for how the ll2
+	 * queues handles are divided.
+	 */
+	qid += (handle - QED_MAX_NUM_OF_LEGACY_LL2_CONNS_PF);
+
+	return qid;
+}
+
 int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 {
-	struct qed_hwfn *p_hwfn = cxt;
-	struct qed_ll2_info *p_ll2_conn;
+	struct e4_core_conn_context *p_cxt;
 	struct qed_ll2_tx_packet *p_pkt;
+	struct qed_ll2_info *p_ll2_conn;
+	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_rx_queue *p_rx;
 	struct qed_ll2_tx_queue *p_tx;
+	struct qed_cxt_info cxt_info;
 	struct qed_ptt *p_ptt;
 	int rc = -EINVAL;
 	u32 i, capacity;
@@ -1539,13 +1602,46 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	rc = qed_cxt_acquire_cid(p_hwfn, PROTOCOLID_CORE, &p_ll2_conn->cid);
 	if (rc)
 		goto out;
+	cxt_info.iid = p_ll2_conn->cid;
+	rc = qed_cxt_get_cid_info(p_hwfn, &cxt_info);
+	if (rc) {
+		DP_NOTICE(p_hwfn, "Cannot find context info for cid=%d\n",
+			  p_ll2_conn->cid);
+		goto out;
+	}
+
+	p_cxt = cxt_info.p_cxt;
+
+	memset(p_cxt, 0, sizeof(*p_cxt));
 
-	qid = p_hwfn->hw_info.resc_start[QED_LL2_QUEUE] + connection_handle;
+	qid = qed_ll2_handle_to_queue_id(p_hwfn, connection_handle,
+					 p_ll2_conn->input.rx_conn_type);
 	p_ll2_conn->queue_id = qid;
 	p_ll2_conn->tx_stats_id = qid;
-	p_rx->set_prod_addr = (u8 __iomem *)p_hwfn->regview +
-					    GTT_BAR0_MAP_REG_TSDM_RAM +
-					    TSTORM_LL2_RX_PRODS_OFFSET(qid);
+
+	DP_VERBOSE(p_hwfn, QED_MSG_LL2,
+		   "Establishing ll2 queue. PF %d ctx_based=%d abs qid=%d\n",
+		   p_hwfn->rel_pf_id, p_ll2_conn->input.rx_conn_type, qid);
+
+	if (p_ll2_conn->input.rx_conn_type == QED_LL2_RX_TYPE_LEGACY) {
+		p_rx->set_prod_addr = p_hwfn->regview +
+		    GTT_BAR0_MAP_REG_TSDM_RAM + TSTORM_LL2_RX_PRODS_OFFSET(qid);
+	} else {
+		/* QED_LL2_RX_TYPE_CTX - using doorbell */
+		p_rx->ctx_based = 1;
+
+		p_rx->set_prod_addr = p_hwfn->doorbells +
+			p_hwfn->dpi_start_offset +
+			DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_LL2_PROD_UPDATE);
+
+		/* prepare db data */
+		p_rx->db_data.icid = cpu_to_le16((u16)p_ll2_conn->cid);
+		SET_FIELD(p_rx->db_data.params,
+			  CORE_PWM_PROD_UPDATE_DATA_AGG_CMD, DB_AGG_CMD_SET);
+		SET_FIELD(p_rx->db_data.params,
+			  CORE_PWM_PROD_UPDATE_DATA_RESERVED1, 0);
+	}
+
 	p_tx->doorbell_addr = (u8 __iomem *)p_hwfn->doorbells +
 					    qed_db_addr(p_ll2_conn->cid,
 							DQ_DEMS_LEGACY);
@@ -1556,7 +1652,6 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 		  DQ_XCM_CORE_TX_BD_PROD_CMD);
 	p_tx->db_msg.agg_flags = DQ_XCM_CORE_DQ_CF_CMD;
 
-
 	rc = qed_ll2_establish_connection_rx(p_hwfn, p_ll2_conn);
 	if (rc)
 		goto out;
@@ -1590,7 +1685,7 @@ static void qed_ll2_post_rx_buffer_notify_fw(struct qed_hwfn *p_hwfn,
 					     struct qed_ll2_rx_packet *p_curp)
 {
 	struct qed_ll2_rx_packet *p_posting_packet = NULL;
-	struct core_ll2_rx_prod rx_prod = { 0, 0, 0 };
+	struct core_ll2_rx_prod rx_prod = { 0, 0 };
 	bool b_notify_fw = false;
 	u16 bd_prod, cq_prod;
 
@@ -1615,13 +1710,27 @@ static void qed_ll2_post_rx_buffer_notify_fw(struct qed_hwfn *p_hwfn,
 
 	bd_prod = qed_chain_get_prod_idx(&p_rx->rxq_chain);
 	cq_prod = qed_chain_get_prod_idx(&p_rx->rcq_chain);
-	rx_prod.bd_prod = cpu_to_le16(bd_prod);
-	rx_prod.cqe_prod = cpu_to_le16(cq_prod);
+	if (p_rx->ctx_based) {
+		/* update producer by giving a doorbell */
+		p_rx->db_data.prod.bd_prod = cpu_to_le16(bd_prod);
+		p_rx->db_data.prod.cqe_prod = cpu_to_le16(cq_prod);
+		/* Make sure chain element is updated before ringing the
+		 * doorbell
+		 */
+		dma_wmb();
+		DIRECT_REG_WR64(p_rx->set_prod_addr,
+				*((u64 *)&p_rx->db_data));
+	} else {
+		rx_prod.bd_prod = cpu_to_le16(bd_prod);
+		rx_prod.cqe_prod = cpu_to_le16(cq_prod);
 
-	/* Make sure chain element is updated before ringing the doorbell */
-	dma_wmb();
+		/* Make sure chain element is updated before ringing the
+		 * doorbell
+		 */
+		dma_wmb();
 
-	DIRECT_REG_WR(p_rx->set_prod_addr, *((u32 *)&rx_prod));
+		DIRECT_REG_WR(p_rx->set_prod_addr, *((u32 *)&rx_prod));
+	}
 }
 
 int qed_ll2_post_rx_buffer(void *cxt,
@@ -1965,6 +2074,12 @@ int qed_ll2_terminate_connection(void *cxt, u8 connection_handle)
 	if (QED_LL2_RX_REGISTERED(p_ll2_conn)) {
 		p_ll2_conn->rx_queue.b_cb_registered = false;
 		smp_wmb(); /* Make sure this is seen by ll2_lb_rxq_completion */
+
+		if (p_ll2_conn->rx_queue.ctx_based)
+			qed_db_recovery_del(p_hwfn->cdev,
+					    p_ll2_conn->rx_queue.set_prod_addr,
+					    &p_ll2_conn->rx_queue.db_data);
+
 		rc = qed_sp_ll2_rx_queue_stop(p_hwfn, p_ll2_conn);
 		if (rc)
 			goto out;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.h b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
index 5f01fbd3c073..288642d526b7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
@@ -46,6 +46,18 @@
 #include "qed_sp.h"
 
 #define QED_MAX_NUM_OF_LL2_CONNECTIONS                    (4)
+/* LL2 queues handles will be split as follows:
+ * first will be legacy queues, and then the ctx based queues.
+ */
+#define QED_MAX_NUM_OF_LL2_CONNS_PF            (4)
+#define QED_MAX_NUM_OF_LEGACY_LL2_CONNS_PF   (3)
+
+#define QED_MAX_NUM_OF_CTX_LL2_CONNS_PF	\
+	(QED_MAX_NUM_OF_LL2_CONNS_PF - QED_MAX_NUM_OF_LEGACY_LL2_CONNS_PF)
+
+#define QED_LL2_LEGACY_CONN_BASE_PF     0
+#define QED_LL2_CTX_CONN_BASE_PF        QED_MAX_NUM_OF_LEGACY_LL2_CONNS_PF
+
 
 struct qed_ll2_rx_packet {
 	struct list_head list_entry;
@@ -79,6 +91,7 @@ struct qed_ll2_rx_queue {
 	struct qed_chain rxq_chain;
 	struct qed_chain rcq_chain;
 	u8 rx_sb_index;
+	u8 ctx_based;
 	bool b_cb_registered;
 	__le16 *p_fw_cons;
 	struct list_head active_descq;
@@ -86,6 +99,7 @@ struct qed_ll2_rx_queue {
 	struct list_head posting_descq;
 	struct qed_ll2_rx_packet *descq_array;
 	void __iomem *set_prod_addr;
+	struct core_pwm_prod_update_data db_data;
 };
 
 struct qed_ll2_tx_queue {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 36ddb89856a8..aeac359941de 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3261,9 +3261,12 @@ static enum resource_id_enum qed_mcp_get_mfw_res_id(enum qed_resources res_id)
 	case QED_ILT:
 		mfw_res_id = RESOURCE_ILT_E;
 		break;
-	case QED_LL2_QUEUE:
+	case QED_LL2_RAM_QUEUE:
 		mfw_res_id = RESOURCE_LL2_QUEUE_E;
 		break;
+	case QED_LL2_CTX_QUEUE:
+		mfw_res_id = RESOURCE_LL2_CQS_E;
+		break;
 	case QED_RDMA_CNQ_RAM:
 	case QED_CMDQS_CQS:
 		/* CNQ/CMDQS are the same resource */
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 3f437e826a4c..a2b7826b36f0 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -105,8 +105,15 @@
 
 #define CORE_SPQE_PAGE_SIZE_BYTES	4096
 
-#define MAX_NUM_LL2_RX_QUEUES		48
-#define MAX_NUM_LL2_TX_STATS_COUNTERS	48
+/* Number of LL2 RAM based queues */
+#define MAX_NUM_LL2_RX_RAM_QUEUES 32
+
+/* Number of LL2 context based queues */
+#define MAX_NUM_LL2_RX_CTX_QUEUES 208
+#define MAX_NUM_LL2_RX_QUEUES \
+	(MAX_NUM_LL2_RX_RAM_QUEUES + MAX_NUM_LL2_RX_CTX_QUEUES)
+
+#define MAX_NUM_LL2_TX_STATS_COUNTERS  48
 
 #define FW_MAJOR_VERSION	8
 #define FW_MINOR_VERSION	42
@@ -340,6 +347,10 @@
 #define DQ_PWM_OFFSET_TCM_ROCE_RQ_PROD		(DQ_PWM_OFFSET_TCM16_BASE + 1)
 #define DQ_PWM_OFFSET_TCM_IWARP_RQ_PROD		(DQ_PWM_OFFSET_TCM16_BASE + 3)
 
+/* DQ_DEMS_AGG_VAL_BASE */
+#define DQ_PWM_OFFSET_TCM_LL2_PROD_UPDATE \
+	(DQ_PWM_OFFSET_TCM32_BASE + DQ_TCM_AGG_VAL_SEL_REG9 - 4)
+
 #define	DQ_REGION_SHIFT			(12)
 
 /* DPM */
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index b5db1ee96d78..9bcb2f419004 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -463,7 +463,7 @@ enum qed_db_rec_space {
 
 #define DIRECT_REG_RD(reg_addr) readl((void __iomem *)(reg_addr))
 
-#define DIRECT_REG_WR64(reg_addr, val) writeq((u32)val,	\
+#define DIRECT_REG_WR64(reg_addr, val) writeq((u64)val,	\
 					      (void __iomem *)(reg_addr))
 
 #define QED_COALESCE_MAX 0x1FF
@@ -1177,6 +1177,8 @@ struct qed_common_ops {
 #define GET_FIELD(value, name) \
 	(((value) >> (name ## _SHIFT)) & name ## _MASK)
 
+#define DB_ADDR_SHIFT(addr) ((addr) << DB_PWM_ADDR_OFFSET_SHIFT)
+
 /* Debug print definitions */
 #define DP_ERR(cdev, fmt, ...)					\
 	do {							\
diff --git a/include/linux/qed/qed_ll2_if.h b/include/linux/qed/qed_ll2_if.h
index 5eb022953aca..1313c34d9a68 100644
--- a/include/linux/qed/qed_ll2_if.h
+++ b/include/linux/qed/qed_ll2_if.h
@@ -52,6 +52,12 @@ enum qed_ll2_conn_type {
 	QED_LL2_TYPE_ROCE,
 	QED_LL2_TYPE_IWARP,
 	QED_LL2_TYPE_RESERVED3,
+	MAX_QED_LL2_CONN_TYPE
+};
+
+enum qed_ll2_rx_conn_type {
+	QED_LL2_RX_TYPE_LEGACY,
+	QED_LL2_RX_TYPE_CTX,
 	MAX_QED_LL2_RX_CONN_TYPE
 };
 
@@ -165,6 +171,7 @@ struct qed_ll2_cbs {
 };
 
 struct qed_ll2_acquire_data_inputs {
+	enum qed_ll2_rx_conn_type rx_conn_type;
 	enum qed_ll2_conn_type conn_type;
 	u16 mtu;
 	u16 rx_num_desc;
-- 
2.14.5

