Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98114660C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWK6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:58:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbgAWK6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:58:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAux3K021434;
        Thu, 23 Jan 2020 02:58:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=xzImv0gxMb2qtextmFi53KCN1qZ8hXpfM86bkSfWKcc=;
 b=XjSyCmx5O5lPvOV+8f/NPq0ru6Yr1D2oOuqMxwLzAe8zZBoCvoFRHPINBMU6TnfiMG8D
 w9Kc9Gm8Nwn8VWRL0dbUhFBcam6PA1uVnm1GGjp1WKKJXuk3qGfRxXZh+tK13rjzyKeg
 yQ89ygDJT6mXQO8Tt85oxJpG5qnDvVm0jNwbD+wA+eVh+YCJuMG3N836iB1iM5vIicdn
 y4G+d9KT1Wc+rIyG7Ut1rEZUWIEJYYA8RftBjB7S2keGFSeZ9+3Z13VLjaodRprrWxo9
 ExJcHxcFc8unxmqk1SRgK0BWsmeSvtRCbrLrkBY9eGSTwuI8gWAMUDqejvsnSpISOVKL Jg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xq4x4h2y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:58:52 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:58:51 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:58:50 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 51ED93F7040;
        Thu, 23 Jan 2020 02:58:49 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 03/13] qed: FW 8.42.2.0 Queue Manager changes
Date:   Thu, 23 Jan 2020 12:58:26 +0200
Message-ID: <20200123105836.15090-4-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains changes in initialization and usage of the QM blocks.
Instead of setting a rate limiter per vport the rate limiters are now a
global resource and set independentaly.

The patch also contains a field name change:
vport_wfq which is part of vport_params was renamed to wfq as the vport
prefix is redundant.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |   1 -
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  21 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          |  42 ++--
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    | 249 +++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   8 +-
 5 files changed, 161 insertions(+), 160 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 8e1bdf58b9e7..5ebafbc379db 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1522,7 +1522,6 @@ void qed_qm_init_pf(struct qed_hwfn *p_hwfn,
 	params.num_vports = qm_info->num_vports;
 	params.pf_wfq = qm_info->pf_wfq;
 	params.pf_rl = qm_info->pf_rl;
-	params.link_speed = p_link->speed;
 	params.pq_params = qm_info->qm_pq_params;
 	params.vport_params = qm_info->qm_vport_params;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index a1ebc2b1ca0b..249fcc3dc138 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1571,7 +1571,7 @@ static void qed_init_qm_vport_params(struct qed_hwfn *p_hwfn)
 
 	/* all vports participate in weighted fair queueing */
 	for (i = 0; i < qed_init_qm_get_num_vports(p_hwfn); i++)
-		qm_info->qm_vport_params[i].vport_wfq = 1;
+		qm_info->qm_vport_params[i].wfq = 1;
 }
 
 /* initialize qm port params */
@@ -2034,9 +2034,8 @@ static void qed_dp_init_qm_params(struct qed_hwfn *p_hwfn)
 		vport = &(qm_info->qm_vport_params[i]);
 		DP_VERBOSE(p_hwfn,
 			   NETIF_MSG_HW,
-			   "vport idx %d, vport_rl %d, wfq %d, first_tx_pq_id [ ",
-			   qm_info->start_vport + i,
-			   vport->vport_rl, vport->vport_wfq);
+			   "vport idx %d, wfq %d, first_tx_pq_id [ ",
+			   qm_info->start_vport + i, vport->wfq);
 		for (tc = 0; tc < NUM_OF_TCS; tc++)
 			DP_VERBOSE(p_hwfn,
 				   NETIF_MSG_HW,
@@ -2049,11 +2048,11 @@ static void qed_dp_init_qm_params(struct qed_hwfn *p_hwfn)
 		pq = &(qm_info->qm_pq_params[i]);
 		DP_VERBOSE(p_hwfn,
 			   NETIF_MSG_HW,
-			   "pq idx %d, port %d, vport_id %d, tc %d, wrr_grp %d, rl_valid %d\n",
+			   "pq idx %d, port %d, vport_id %d, tc %d, wrr_grp %d, rl_valid %d rl_id %d\n",
 			   qm_info->start_pq + i,
 			   pq->port_id,
 			   pq->vport_id,
-			   pq->tc_id, pq->wrr_group, pq->rl_valid);
+			   pq->tc_id, pq->wrr_group, pq->rl_valid, pq->rl_id);
 	}
 }
 
@@ -2623,7 +2622,7 @@ static int qed_hw_init_common(struct qed_hwfn *p_hwfn,
 	params.max_phys_tcs_per_port = qm_info->max_phys_tcs_per_port;
 	params.pf_rl_en = qm_info->pf_rl_en;
 	params.pf_wfq_en = qm_info->pf_wfq_en;
-	params.vport_rl_en = qm_info->vport_rl_en;
+	params.global_rl_en = qm_info->vport_rl_en;
 	params.vport_wfq_en = qm_info->vport_wfq_en;
 	params.port_params = qm_info->qm_port_params;
 
@@ -5087,11 +5086,11 @@ static void qed_configure_wfq_for_all_vports(struct qed_hwfn *p_hwfn,
 	for (i = 0; i < p_hwfn->qm_info.num_vports; i++) {
 		u32 wfq_speed = p_hwfn->qm_info.wfq_data[i].min_speed;
 
-		vport_params[i].vport_wfq = (wfq_speed * QED_WFQ_UNIT) /
+		vport_params[i].wfq = (wfq_speed * QED_WFQ_UNIT) /
 						min_pf_rate;
 		qed_init_vport_wfq(p_hwfn, p_ptt,
 				   vport_params[i].first_tx_pq_id,
-				   vport_params[i].vport_wfq);
+				   vport_params[i].wfq);
 	}
 }
 
@@ -5102,7 +5101,7 @@ static void qed_init_wfq_default_param(struct qed_hwfn *p_hwfn,
 	int i;
 
 	for (i = 0; i < p_hwfn->qm_info.num_vports; i++)
-		p_hwfn->qm_info.qm_vport_params[i].vport_wfq = 1;
+		p_hwfn->qm_info.qm_vport_params[i].wfq = 1;
 }
 
 static void qed_disable_wfq_for_all_vports(struct qed_hwfn *p_hwfn,
@@ -5118,7 +5117,7 @@ static void qed_disable_wfq_for_all_vports(struct qed_hwfn *p_hwfn,
 		qed_init_wfq_default_param(p_hwfn, min_pf_rate);
 		qed_init_vport_wfq(p_hwfn, p_ptt,
 				   vport_params[i].first_tx_pq_id,
-				   vport_params[i].vport_wfq);
+				   vport_params[i].wfq);
 	}
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index efabe0ca5cbe..fb4c0de44aaa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -2630,13 +2630,18 @@ struct init_nig_pri_tc_map_req {
 	struct init_nig_pri_tc_map_entry pri[NUM_OF_VLAN_PRIORITIES];
 };
 
+/* QM per global RL init parameters */
+struct init_qm_global_rl_params {
+	u32 rate_limit;
+};
+
 /* QM per-port init parameters */
 struct init_qm_port_params {
-	u8 active;
-	u8 active_phys_tcs;
+	u16 active_phys_tcs;
 	u16 num_pbf_cmd_lines;
 	u16 num_btb_blocks;
-	u16 reserved;
+	u8 active;
+	u8 reserved;
 };
 
 /* QM per-PQ init parameters */
@@ -2645,15 +2650,14 @@ struct init_qm_pq_params {
 	u8 tc_id;
 	u8 wrr_group;
 	u8 rl_valid;
+	u16 rl_id;
 	u8 port_id;
-	u8 reserved0;
-	u16 reserved1;
+	u8 reserved;
 };
 
 /* QM per-vport init parameters */
 struct init_qm_vport_params {
-	u32 vport_rl;
-	u16 vport_wfq;
+	u16 wfq;
 	u16 first_tx_pq_id[NUM_OF_TCS];
 };
 
@@ -3982,9 +3986,10 @@ struct qed_qm_common_rt_init_params {
 	u8 max_phys_tcs_per_port;
 	bool pf_rl_en;
 	bool pf_wfq_en;
-	bool vport_rl_en;
+	bool global_rl_en;
 	bool vport_wfq_en;
 	struct init_qm_port_params *port_params;
+	struct init_qm_global_rl_params global_rl_params[MAX_QM_GLOBAL_RLS];
 };
 
 int qed_qm_common_rt_init(struct qed_hwfn *p_hwfn,
@@ -4001,11 +4006,10 @@ struct qed_qm_pf_rt_init_params {
 	u16 start_pq;
 	u16 num_pf_pqs;
 	u16 num_vf_pqs;
-	u8 start_vport;
-	u8 num_vports;
+	u16 start_vport;
+	u16 num_vports;
 	u16 pf_wfq;
 	u32 pf_rl;
-	u32 link_speed;
 	struct init_qm_pq_params *pq_params;
 	struct init_qm_vport_params *vport_params;
 };
@@ -4054,22 +4058,22 @@ int qed_init_pf_rl(struct qed_hwfn *p_hwfn,
  */
 int qed_init_vport_wfq(struct qed_hwfn *p_hwfn,
 		       struct qed_ptt *p_ptt,
-		       u16 first_tx_pq_id[NUM_OF_TCS], u16 vport_wfq);
+		       u16 first_tx_pq_id[NUM_OF_TCS], u16 wfq);
 
 /**
- * @brief qed_init_vport_rl - Initializes the rate limit of the specified VPORT
+ * @brief qed_init_global_rl - Initializes the rate limit of the specified
+ * rate limiter
  *
  * @param p_hwfn
  * @param p_ptt - ptt window used for writing the registers
- * @param vport_id - VPORT ID
- * @param vport_rl - rate limit in Mb/sec units
- * @param link_speed - link speed in Mbps.
+ * @param rl_id - RL ID
+ * @param rate_limit - rate limit in Mb/sec units
  *
  * @return 0 on success, -1 on error.
  */
-int qed_init_vport_rl(struct qed_hwfn *p_hwfn,
-		      struct qed_ptt *p_ptt,
-		      u8 vport_id, u32 vport_rl, u32 link_speed);
+int qed_init_global_rl(struct qed_hwfn *p_hwfn,
+		       struct qed_ptt *p_ptt,
+		       u16 rl_id, u32 rate_limit);
 
 /**
  * @brief qed_send_qm_stop_cmd  Sends a stop command to the QM
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 2307f8842c9e..bdfc002c1877 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -61,6 +61,9 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 								0x100) - 1 : 0)
 #define QM_INVALID_PQ_ID		0xffff
 
+/* Max link speed (in Mbps) */
+#define QM_MAX_LINK_SPEED               100000
+
 /* Feature enable */
 #define QM_BYPASS_EN	1
 #define QM_BYTE_CRD_EN	1
@@ -128,8 +131,6 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 /* Pure LB CmdQ lines (+spare) */
 #define PBF_CMDQ_PURE_LB_LINES	150
 
-#define PBF_CMDQ_LINES_E5_RSVD_RATIO	8
-
 #define PBF_CMDQ_LINES_RT_OFFSET(ext_voq) \
 	(PBF_REG_YCMD_QS_NUM_LINES_VOQ0_RT_OFFSET + \
 	 (ext_voq) * (PBF_REG_YCMD_QS_NUM_LINES_VOQ1_RT_OFFSET - \
@@ -140,6 +141,9 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 	 (ext_voq) * (PBF_REG_BTB_GUARANTEED_VOQ1_RT_OFFSET - \
 		PBF_REG_BTB_GUARANTEED_VOQ0_RT_OFFSET))
 
+/* Returns the VOQ line credit for the specified number of PBF command lines.
+ * PBF lines are specified in 256b units.
+ */
 #define QM_VOQ_LINE_CRD(pbf_cmd_lines) \
 	((((pbf_cmd_lines) - 4) * 2) | QM_LINE_CRD_REG_SIGN_BIT)
 
@@ -178,14 +182,14 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 		  cmd ## _ ## field, \
 		  value)
 
-#define QM_INIT_TX_PQ_MAP(p_hwfn, map, chip, pq_id, rl_valid, vp_pq_id, rl_id, \
+#define QM_INIT_TX_PQ_MAP(p_hwfn, map, chip, pq_id, vp_pq_id, rl_valid, rl_id, \
 			  ext_voq, wrr) \
 	do { \
 		typeof(map) __map; \
 		memset(&__map, 0, sizeof(__map)); \
 		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _PQ_VALID, 1); \
 		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _RL_VALID, \
-			  rl_valid); \
+			  rl_valid ? 1 : 0);\
 		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _VP_PQ_ID, \
 			  vp_pq_id); \
 		SET_FIELD(__map.reg, QM_RF_PQ_MAP_ ## chip ## _RL_ID, rl_id); \
@@ -200,9 +204,12 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 #define WRITE_PQ_INFO_TO_RAM	1
 #define PQ_INFO_ELEMENT(vp, pf, tc, port, rl_valid, rl) \
 	(((vp) << 0) | ((pf) << 12) | ((tc) << 16) | ((port) << 20) | \
-	((rl_valid) << 22) | ((rl) << 24))
+	((rl_valid ? 1 : 0) << 22) | (((rl) & 255) << 24) | \
+	(((rl) >> 8) << 9))
+
 #define PQ_INFO_RAM_GRC_ADDRESS(pq_id) \
-	(XSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM + 21776 + (pq_id) * 4)
+	XSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM + \
+	XSTORM_PQ_INFO_OFFSET(pq_id)
 
 /******************** INTERNAL IMPLEMENTATION *********************/
 
@@ -256,12 +263,12 @@ static void qed_enable_pf_wfq(struct qed_hwfn *p_hwfn, bool pf_wfq_en)
 			     QM_WFQ_UPPER_BOUND);
 }
 
-/* Prepare VPORT RL enable/disable runtime init values */
-static void qed_enable_vport_rl(struct qed_hwfn *p_hwfn, bool vport_rl_en)
+/* Prepare global RL enable/disable runtime init values */
+static void qed_enable_global_rl(struct qed_hwfn *p_hwfn, bool global_rl_en)
 {
 	STORE_RT_REG(p_hwfn, QM_REG_RLGLBLENABLE_RT_OFFSET,
-		     vport_rl_en ? 1 : 0);
-	if (vport_rl_en) {
+		     global_rl_en ? 1 : 0);
+	if (global_rl_en) {
 		/* Write RL period (use timer 0 only) */
 		STORE_RT_REG(p_hwfn,
 			     QM_REG_RLGLBLPERIOD_0_RT_OFFSET,
@@ -328,8 +335,7 @@ static void qed_cmdq_lines_rt_init(
 			continue;
 
 		/* Find number of command queue lines to divide between the
-		 * active physical TCs. In E5, 1/8 of the lines are reserved.
-		 * the lines for pure LB TC are subtracted.
+		 * active physical TCs.
 		 */
 		phys_lines = port_params[port_id].num_pbf_cmd_lines;
 		phys_lines -= PBF_CMDQ_PURE_LB_LINES;
@@ -358,11 +364,30 @@ static void qed_cmdq_lines_rt_init(
 		ext_voq = qed_get_ext_voq(p_hwfn,
 					  port_id,
 					  PURE_LB_TC, max_phys_tcs_per_port);
-		qed_cmdq_lines_voq_rt_init(p_hwfn,
-					   ext_voq, PBF_CMDQ_PURE_LB_LINES);
+		qed_cmdq_lines_voq_rt_init(p_hwfn, ext_voq,
+					   PBF_CMDQ_PURE_LB_LINES);
 	}
 }
 
+/* Prepare runtime init values to allocate guaranteed BTB blocks for the
+ * specified port. The guaranteed BTB space is divided between the TCs as
+ * follows (shared space Is currently not used):
+ * 1. Parameters:
+ *    B - BTB blocks for this port
+ *    C - Number of physical TCs for this port
+ * 2. Calculation:
+ *    a. 38 blocks (9700B jumbo frame) are allocated for global per port
+ *	 headroom.
+ *    b. B = B - 38 (remainder after global headroom allocation).
+ *    c. MAX(38,B/(C+0.7)) blocks are allocated for the pure LB VOQ.
+ *    d. B = B - MAX(38, B/(C+0.7)) (remainder after pure LB allocation).
+ *    e. B/C blocks are allocated for each physical TC.
+ * Assumptions:
+ * - MTU is up to 9700 bytes (38 blocks)
+ * - All TCs are considered symmetrical (same rate and packet size)
+ * - No optimization for lossy TC (all are considered lossless). Shared space
+ *   is not enabled and allocated for each TC.
+ */
 static void qed_btb_blocks_rt_init(
 	struct qed_hwfn *p_hwfn,
 	u8 max_ports_per_engine,
@@ -421,6 +446,45 @@ static void qed_btb_blocks_rt_init(
 	}
 }
 
+/* Prepare runtime init values for the specified RL.
+ * If global_rl_params is NULL, max link speed (100Gbps) is used instead.
+ * Return -1 on error.
+ */
+static int qed_global_rl_rt_init(struct qed_hwfn *p_hwfn,
+				 struct init_qm_global_rl_params
+				 global_rl_params[MAX_QM_GLOBAL_RLS])
+{
+	u32 upper_bound = QM_VP_RL_UPPER_BOUND(QM_MAX_LINK_SPEED) |
+			  (u32)QM_RL_CRD_REG_SIGN_BIT;
+	u32 inc_val;
+	u16 rl_id;
+
+	/* Go over all global RLs */
+	for (rl_id = 0; rl_id < MAX_QM_GLOBAL_RLS; rl_id++) {
+		u32 rate_limit =
+		    global_rl_params ? global_rl_params[rl_id].rate_limit : 0;
+
+		inc_val =
+		    QM_RL_INC_VAL(rate_limit ? rate_limit : QM_MAX_LINK_SPEED);
+		if (inc_val > QM_VP_RL_MAX_INC_VAL(QM_MAX_LINK_SPEED)) {
+			DP_NOTICE(p_hwfn,
+				  "Invalid rate limit configuration.\n");
+			return -1;
+		}
+
+		STORE_RT_REG(p_hwfn,
+			     QM_REG_RLGLBLCRD_RT_OFFSET + rl_id,
+			     (u32)QM_RL_CRD_REG_SIGN_BIT);
+		STORE_RT_REG(p_hwfn,
+			     QM_REG_RLGLBLUPPERBOUND_RT_OFFSET + rl_id,
+			     upper_bound);
+		STORE_RT_REG(p_hwfn,
+			     QM_REG_RLGLBLINCVAL_RT_OFFSET + rl_id, inc_val);
+	}
+
+	return 0;
+}
+
 /* Prepare Tx PQ mapping runtime init values for the specified PF */
 static void qed_tx_pq_map_rt_init(struct qed_hwfn *p_hwfn,
 				  struct qed_ptt *p_ptt,
@@ -457,18 +521,17 @@ static void qed_tx_pq_map_rt_init(struct qed_hwfn *p_hwfn,
 
 	/* Go over all Tx PQs */
 	for (i = 0, pq_id = p_params->start_pq; i < num_pqs; i++, pq_id++) {
-		u8 ext_voq, vport_id_in_pf, tc_id = pq_params[i].tc_id;
-		u32 max_qm_global_rls = MAX_QM_GLOBAL_RLS;
+		u16 *p_first_tx_pq_id, vport_id_in_pf;
 		struct qm_rf_pq_map_e4 tx_pq_map;
-		bool is_vf_pq, rl_valid;
-		u16 *p_first_tx_pq_id;
+		u8 tc_id = pq_params[i].tc_id;
+		bool is_vf_pq;
+		u8 ext_voq;
 
 		ext_voq = qed_get_ext_voq(p_hwfn,
 					  pq_params[i].port_id,
 					  tc_id,
 					  p_params->max_phys_tcs_per_port);
 		is_vf_pq = (i >= p_params->num_pf_pqs);
-		rl_valid = pq_params[i].rl_valid > 0;
 
 		/* Update first Tx PQ of VPORT/TC */
 		vport_id_in_pf = pq_params[i].vport_id - p_params->start_vport;
@@ -489,21 +552,14 @@ static void qed_tx_pq_map_rt_init(struct qed_hwfn *p_hwfn,
 				     map_val);
 		}
 
-		/* Check RL ID */
-		if (rl_valid && pq_params[i].vport_id >= max_qm_global_rls) {
-			DP_NOTICE(p_hwfn,
-				  "Invalid VPORT ID for rate limiter configuration\n");
-			rl_valid = false;
-		}
-
 		/* Prepare PQ map entry */
 		QM_INIT_TX_PQ_MAP(p_hwfn,
 				  tx_pq_map,
 				  E4,
 				  pq_id,
-				  rl_valid ? 1 : 0,
 				  *p_first_tx_pq_id,
-				  rl_valid ? pq_params[i].vport_id : 0,
+				  pq_params[i].rl_valid,
+				  pq_params[i].rl_id,
 				  ext_voq, pq_params[i].wrr_group);
 
 		/* Set PQ base address */
@@ -526,9 +582,8 @@ static void qed_tx_pq_map_rt_init(struct qed_hwfn *p_hwfn,
 						  p_params->pf_id,
 						  tc_id,
 						  pq_params[i].port_id,
-						  rl_valid ? 1 : 0,
-						  rl_valid ?
-						  pq_params[i].vport_id : 0);
+						  pq_params[i].rl_valid,
+						  pq_params[i].rl_id);
 			qed_wr(p_hwfn, p_ptt, PQ_INFO_RAM_GRC_ADDRESS(pq_id),
 			       pq_info);
 		}
@@ -666,19 +721,19 @@ static int qed_pf_rl_rt_init(struct qed_hwfn *p_hwfn, u8 pf_id, u32 pf_rl)
  * Return -1 on error.
  */
 static int qed_vp_wfq_rt_init(struct qed_hwfn *p_hwfn,
-			      u8 num_vports,
+			      u16 num_vports,
 			      struct init_qm_vport_params *vport_params)
 {
-	u16 vport_pq_id;
+	u16 vport_pq_id, i;
 	u32 inc_val;
-	u8 tc, i;
+	u8 tc;
 
 	/* Go over all PF VPORTs */
 	for (i = 0; i < num_vports; i++) {
-		if (!vport_params[i].vport_wfq)
+		if (!vport_params[i].wfq)
 			continue;
 
-		inc_val = QM_WFQ_INC_VAL(vport_params[i].vport_wfq);
+		inc_val = QM_WFQ_INC_VAL(vport_params[i].wfq);
 		if (inc_val > QM_WFQ_MAX_INC_VAL) {
 			DP_NOTICE(p_hwfn,
 				  "Invalid VPORT WFQ weight configuration\n");
@@ -703,48 +758,6 @@ static int qed_vp_wfq_rt_init(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
-/* Prepare VPORT RL runtime init values for the specified VPORTs.
- * Return -1 on error.
- */
-static int qed_vport_rl_rt_init(struct qed_hwfn *p_hwfn,
-				u8 start_vport,
-				u8 num_vports,
-				u32 link_speed,
-				struct init_qm_vport_params *vport_params)
-{
-	u8 i, vport_id;
-	u32 inc_val;
-
-	if (start_vport + num_vports >= MAX_QM_GLOBAL_RLS) {
-		DP_NOTICE(p_hwfn,
-			  "Invalid VPORT ID for rate limiter configuration\n");
-		return -1;
-	}
-
-	/* Go over all PF VPORTs */
-	for (i = 0, vport_id = start_vport; i < num_vports; i++, vport_id++) {
-		inc_val = QM_RL_INC_VAL(vport_params[i].vport_rl ?
-			  vport_params[i].vport_rl :
-			  link_speed);
-		if (inc_val > QM_VP_RL_MAX_INC_VAL(link_speed)) {
-			DP_NOTICE(p_hwfn,
-				  "Invalid VPORT rate-limit configuration\n");
-			return -1;
-		}
-
-		STORE_RT_REG(p_hwfn, QM_REG_RLGLBLCRD_RT_OFFSET + vport_id,
-			     (u32)QM_RL_CRD_REG_SIGN_BIT);
-		STORE_RT_REG(p_hwfn,
-			     QM_REG_RLGLBLUPPERBOUND_RT_OFFSET + vport_id,
-			     QM_VP_RL_UPPER_BOUND(link_speed) |
-			     (u32)QM_RL_CRD_REG_SIGN_BIT);
-		STORE_RT_REG(p_hwfn, QM_REG_RLGLBLINCVAL_RT_OFFSET + vport_id,
-			     inc_val);
-	}
-
-	return 0;
-}
-
 static bool qed_poll_on_qm_cmd_ready(struct qed_hwfn *p_hwfn,
 				     struct qed_ptt *p_ptt)
 {
@@ -796,23 +809,20 @@ u32 qed_qm_pf_mem_size(u32 num_pf_cids,
 int qed_qm_common_rt_init(struct qed_hwfn *p_hwfn,
 			  struct qed_qm_common_rt_init_params *p_params)
 {
-	/* Init AFullOprtnstcCrdMask */
-	u32 mask = (QM_OPPOR_LINE_VOQ_DEF <<
-		    QM_RF_OPPORTUNISTIC_MASK_LINEVOQ_SHIFT) |
-		   (QM_BYTE_CRD_EN << QM_RF_OPPORTUNISTIC_MASK_BYTEVOQ_SHIFT) |
-		   (p_params->pf_wfq_en <<
-		    QM_RF_OPPORTUNISTIC_MASK_PFWFQ_SHIFT) |
-		   (p_params->vport_wfq_en <<
-		    QM_RF_OPPORTUNISTIC_MASK_VPWFQ_SHIFT) |
-		   (p_params->pf_rl_en <<
-		    QM_RF_OPPORTUNISTIC_MASK_PFRL_SHIFT) |
-		   (p_params->vport_rl_en <<
-		    QM_RF_OPPORTUNISTIC_MASK_VPQCNRL_SHIFT) |
-		   (QM_OPPOR_FW_STOP_DEF <<
-		    QM_RF_OPPORTUNISTIC_MASK_FWPAUSE_SHIFT) |
-		   (QM_OPPOR_PQ_EMPTY_DEF <<
-		    QM_RF_OPPORTUNISTIC_MASK_QUEUEEMPTY_SHIFT);
+	u32 mask = 0;
 
+	/* Init AFullOprtnstcCrdMask */
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_LINEVOQ,
+		  QM_OPPOR_LINE_VOQ_DEF);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_BYTEVOQ, QM_BYTE_CRD_EN);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_PFWFQ, p_params->pf_wfq_en);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_VPWFQ, p_params->vport_wfq_en);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_PFRL, p_params->pf_rl_en);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_VPQCNRL,
+		  p_params->global_rl_en);
+	SET_FIELD(mask, QM_RF_OPPORTUNISTIC_MASK_FWPAUSE, QM_OPPOR_FW_STOP_DEF);
+	SET_FIELD(mask,
+		  QM_RF_OPPORTUNISTIC_MASK_QUEUEEMPTY, QM_OPPOR_PQ_EMPTY_DEF);
 	STORE_RT_REG(p_hwfn, QM_REG_AFULLOPRTNSTCCRDMASK_RT_OFFSET, mask);
 
 	/* Enable/disable PF RL */
@@ -821,8 +831,8 @@ int qed_qm_common_rt_init(struct qed_hwfn *p_hwfn,
 	/* Enable/disable PF WFQ */
 	qed_enable_pf_wfq(p_hwfn, p_params->pf_wfq_en);
 
-	/* Enable/disable VPORT RL */
-	qed_enable_vport_rl(p_hwfn, p_params->vport_rl_en);
+	/* Enable/disable global RL */
+	qed_enable_global_rl(p_hwfn, p_params->global_rl_en);
 
 	/* Enable/disable VPORT WFQ */
 	qed_enable_vport_wfq(p_hwfn, p_params->vport_wfq_en);
@@ -839,6 +849,8 @@ int qed_qm_common_rt_init(struct qed_hwfn *p_hwfn,
 			       p_params->max_phys_tcs_per_port,
 			       p_params->port_params);
 
+	qed_global_rl_rt_init(p_hwfn, p_params->global_rl_params);
+
 	return 0;
 }
 
@@ -850,7 +862,9 @@ int qed_qm_pf_rt_init(struct qed_hwfn *p_hwfn,
 	u32 other_mem_size_4kb = QM_PQ_MEM_4KB(p_params->num_pf_cids +
 					       p_params->num_tids) *
 				 QM_OTHER_PQS_PER_PF;
-	u8 tc, i;
+	u16 i;
+	u8 tc;
+
 
 	/* Clear first Tx PQ ID array for each VPORT */
 	for (i = 0; i < p_params->num_vports; i++)
@@ -875,16 +889,10 @@ int qed_qm_pf_rt_init(struct qed_hwfn *p_hwfn,
 	if (qed_pf_rl_rt_init(p_hwfn, p_params->pf_id, p_params->pf_rl))
 		return -1;
 
-	/* Set VPORT WFQ */
+	/* Init VPORT WFQ */
 	if (qed_vp_wfq_rt_init(p_hwfn, p_params->num_vports, vport_params))
 		return -1;
 
-	/* Set VPORT RL */
-	if (qed_vport_rl_rt_init(p_hwfn, p_params->start_vport,
-				 p_params->num_vports, p_params->link_speed,
-				 vport_params))
-		return -1;
-
 	return 0;
 }
 
@@ -922,18 +930,19 @@ int qed_init_pf_rl(struct qed_hwfn *p_hwfn,
 
 int qed_init_vport_wfq(struct qed_hwfn *p_hwfn,
 		       struct qed_ptt *p_ptt,
-		       u16 first_tx_pq_id[NUM_OF_TCS], u16 vport_wfq)
+		       u16 first_tx_pq_id[NUM_OF_TCS], u16 wfq)
 {
 	u16 vport_pq_id;
 	u32 inc_val;
 	u8 tc;
 
-	inc_val = QM_WFQ_INC_VAL(vport_wfq);
+	inc_val = QM_WFQ_INC_VAL(wfq);
 	if (!inc_val || inc_val > QM_WFQ_MAX_INC_VAL) {
-		DP_NOTICE(p_hwfn, "Invalid VPORT WFQ weight configuration\n");
+		DP_NOTICE(p_hwfn, "Invalid VPORT WFQ configuration.\n");
 		return -1;
 	}
 
+	/* A VPORT can have several VPORT PQ IDs for various TCs */
 	for (tc = 0; tc < NUM_OF_TCS; tc++) {
 		vport_pq_id = first_tx_pq_id[tc];
 		if (vport_pq_id != QM_INVALID_PQ_ID)
@@ -945,28 +954,20 @@ int qed_init_vport_wfq(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
-int qed_init_vport_rl(struct qed_hwfn *p_hwfn,
-		      struct qed_ptt *p_ptt,
-		      u8 vport_id, u32 vport_rl, u32 link_speed)
+int qed_init_global_rl(struct qed_hwfn *p_hwfn,
+		       struct qed_ptt *p_ptt, u16 rl_id, u32 rate_limit)
 {
-	u32 inc_val, max_qm_global_rls = MAX_QM_GLOBAL_RLS;
-
-	if (vport_id >= max_qm_global_rls) {
-		DP_NOTICE(p_hwfn,
-			  "Invalid VPORT ID for rate limiter configuration\n");
-		return -1;
-	}
+	u32 inc_val;
 
-	inc_val = QM_RL_INC_VAL(vport_rl ? vport_rl : link_speed);
-	if (inc_val > QM_VP_RL_MAX_INC_VAL(link_speed)) {
-		DP_NOTICE(p_hwfn, "Invalid VPORT rate-limit configuration\n");
+	inc_val = QM_RL_INC_VAL(rate_limit);
+	if (inc_val > QM_VP_RL_MAX_INC_VAL(rate_limit)) {
+		DP_NOTICE(p_hwfn, "Invalid rate limit configuration.\n");
 		return -1;
 	}
 
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       QM_REG_RLGLBLCRD + vport_id * 4, (u32)QM_RL_CRD_REG_SIGN_BIT);
-	qed_wr(p_hwfn, p_ptt, QM_REG_RLGLBLINCVAL + vport_id * 4, inc_val);
+	qed_wr(p_hwfn, p_ptt,
+	       QM_REG_RLGLBLCRD + rl_id * 4, (u32)QM_RL_CRD_REG_SIGN_BIT);
+	qed_wr(p_hwfn, p_ptt, QM_REG_RLGLBLINCVAL + rl_id * 4, inc_val);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index dcb5c917f373..fe4b740de14c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4354,9 +4354,9 @@ qed_iov_bulletin_get_forced_vlan(struct qed_hwfn *p_hwfn, u16 rel_vf_id)
 static int qed_iov_configure_tx_rate(struct qed_hwfn *p_hwfn,
 				     struct qed_ptt *p_ptt, int vfid, int val)
 {
-	struct qed_mcp_link_state *p_link;
 	struct qed_vf_info *vf;
 	u8 abs_vp_id = 0;
+	u16 rl_id;
 	int rc;
 
 	vf = qed_iov_get_vf_info(p_hwfn, (u16)vfid, true);
@@ -4367,10 +4367,8 @@ static int qed_iov_configure_tx_rate(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	p_link = &QED_LEADING_HWFN(p_hwfn->cdev)->mcp_info->link_output;
-
-	return qed_init_vport_rl(p_hwfn, p_ptt, abs_vp_id, (u32)val,
-				 p_link->speed);
+	rl_id = abs_vp_id;	/* The "rl_id" is set as the "vport_id" */
+	return qed_init_global_rl(p_hwfn, p_ptt, rl_id, (u32)val);
 }
 
 static int
-- 
2.14.5

