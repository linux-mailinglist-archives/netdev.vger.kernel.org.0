Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1A814A4F9
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgA0N0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbgA0N0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDPEve006267;
        Mon, 27 Jan 2020 05:26:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u1CNqM77EmVeizaAqJJlcfhZrYc9vkRlnd533HffqIA=;
 b=SC/sN0CmKA+dzNbGQlbw4aLrjPTegT+CQWKlUwn/kmVVhY4wIo5zpbXFygXPr7TlF9X7
 9faJ9t62PnFMmkPbEEGbKwx8Ov6L+sXpSrDeopTeJvdyrG6dPDFaKv0TvP+tYQ7iw14E
 Y1PmK2GImqza87Op/3H8KsncdXEdh1QGy/Ypb4NYV2Ydl2iPrC2EznLWij7OhMxHhY3n
 kTHhg1CV46VoxuOSl4IX/dJUB7GQaaxVRLO/mZR5FtSBbmg3mnrqFnJ3Qwiz/fvNbJ3P
 ItLdysrEYr0BU0A2vtuWiwLB+zZfPf1VNfieieSuIn2g4kmSUJEhDIcBxCVtGPbqHQLW PQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xrkwufduj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:45 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:43 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:43 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 422A03F703F;
        Mon, 27 Jan 2020 05:26:42 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 07/13] qed: Add abstraction for different hsi values per chip
Date:   Mon, 27 Jan 2020 15:26:13 +0200
Message-ID: <20200127132619.27144-8-michal.kalderon@marvell.com>
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

The number of BTB blocks was modified to be different between the two chip
flavors supported (BB/K2) as a result, this lead to a re-write of selecting
the default hsi value based on the chip.
This patch creates a lookup table for hsi values per chip rather than
ask again and again for every value.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h     | 56 +++++++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 62 +++++++++++++++++++++----------
 include/linux/qed/common_hsi.h            |  4 +-
 3 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index cfa45fb9a5a4..cfbfe7441ecb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -532,6 +532,23 @@ struct qed_nvm_image_info {
 	bool valid;
 };
 
+enum qed_hsi_def_type {
+	QED_HSI_DEF_MAX_NUM_VFS,
+	QED_HSI_DEF_MAX_NUM_L2_QUEUES,
+	QED_HSI_DEF_MAX_NUM_PORTS,
+	QED_HSI_DEF_MAX_SB_PER_PATH,
+	QED_HSI_DEF_MAX_NUM_PFS,
+	QED_HSI_DEF_MAX_NUM_VPORTS,
+	QED_HSI_DEF_NUM_ETH_RSS_ENGINE,
+	QED_HSI_DEF_MAX_QM_TX_QUEUES,
+	QED_HSI_DEF_NUM_PXP_ILT_RECORDS,
+	QED_HSI_DEF_NUM_RDMA_STATISTIC_COUNTERS,
+	QED_HSI_DEF_MAX_QM_GLOBAL_RLS,
+	QED_HSI_DEF_MAX_PBF_CMD_LINES,
+	QED_HSI_DEF_MAX_BTB_BLOCKS,
+	QED_NUM_HSI_DEFS
+};
+
 #define DRV_MODULE_VERSION		      \
 	__stringify(QED_MAJOR_VERSION) "."    \
 	__stringify(QED_MINOR_VERSION) "."    \
@@ -869,16 +886,35 @@ struct qed_dev {
 	bool				iwarp_cmt;
 };
 
-#define NUM_OF_VFS(dev)         (QED_IS_BB(dev) ? MAX_NUM_VFS_BB \
-						: MAX_NUM_VFS_K2)
-#define NUM_OF_L2_QUEUES(dev)   (QED_IS_BB(dev) ? MAX_NUM_L2_QUEUES_BB \
-						: MAX_NUM_L2_QUEUES_K2)
-#define NUM_OF_PORTS(dev)       (QED_IS_BB(dev) ? MAX_NUM_PORTS_BB \
-						: MAX_NUM_PORTS_K2)
-#define NUM_OF_SBS(dev)         (QED_IS_BB(dev) ? MAX_SB_PER_PATH_BB \
-						: MAX_SB_PER_PATH_K2)
-#define NUM_OF_ENG_PFS(dev)     (QED_IS_BB(dev) ? MAX_NUM_PFS_BB \
-						: MAX_NUM_PFS_K2)
+u32 qed_get_hsi_def_val(struct qed_dev *cdev, enum qed_hsi_def_type type);
+
+#define NUM_OF_VFS(dev)	\
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_NUM_VFS)
+#define NUM_OF_L2_QUEUES(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_NUM_L2_QUEUES)
+#define NUM_OF_PORTS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_NUM_PORTS)
+#define NUM_OF_SBS(dev)	\
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_SB_PER_PATH)
+#define NUM_OF_ENG_PFS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_NUM_PFS)
+#define NUM_OF_VPORTS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_NUM_VPORTS)
+#define NUM_OF_RSS_ENGINES(dev)	\
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_NUM_ETH_RSS_ENGINE)
+#define NUM_OF_QM_TX_QUEUES(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_QM_TX_QUEUES)
+#define NUM_OF_PXP_ILT_RECORDS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_NUM_PXP_ILT_RECORDS)
+#define NUM_OF_RDMA_STATISTIC_COUNTERS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_NUM_RDMA_STATISTIC_COUNTERS)
+#define NUM_OF_QM_GLOBAL_RLS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_QM_GLOBAL_RLS)
+#define NUM_OF_PBF_CMD_LINES(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_PBF_CMD_LINES)
+#define NUM_OF_BTB_BLOCKS(dev) \
+	qed_get_hsi_def_val(dev, QED_HSI_DEF_MAX_BTB_BLOCKS)
+
 
 /**
  * @brief qed_concrete_to_sw_fid - get the sw function id from
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 898c1f8d1530..e3e0376c13d6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1579,6 +1579,7 @@ static void qed_init_qm_port_params(struct qed_hwfn *p_hwfn)
 {
 	/* Initialize qm port parameters */
 	u8 i, active_phys_tcs, num_ports = p_hwfn->cdev->num_ports_in_engine;
+	struct qed_dev *cdev = p_hwfn->cdev;
 
 	/* indicate how ooo and high pri traffic is dealt with */
 	active_phys_tcs = num_ports == MAX_NUM_PORTS_K2 ?
@@ -1588,11 +1589,13 @@ static void qed_init_qm_port_params(struct qed_hwfn *p_hwfn)
 	for (i = 0; i < num_ports; i++) {
 		struct init_qm_port_params *p_qm_port =
 		    &p_hwfn->qm_info.qm_port_params[i];
+		u16 pbf_max_cmd_lines;
 
 		p_qm_port->active = 1;
 		p_qm_port->active_phys_tcs = active_phys_tcs;
-		p_qm_port->num_pbf_cmd_lines = PBF_MAX_CMD_LINES / num_ports;
-		p_qm_port->num_btb_blocks = BTB_MAX_BLOCKS / num_ports;
+		pbf_max_cmd_lines = (u16)NUM_OF_PBF_CMD_LINES(cdev);
+		p_qm_port->num_pbf_cmd_lines = pbf_max_cmd_lines / num_ports;
+		p_qm_port->num_btb_blocks = NUM_OF_BTB_BLOCKS(cdev) / num_ports;
 	}
 }
 
@@ -3607,14 +3610,39 @@ __qed_hw_set_soft_resc_size(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
+static u32 qed_hsi_def_val[][MAX_CHIP_IDS] = {
+	{MAX_NUM_VFS_BB, MAX_NUM_VFS_K2},
+	{MAX_NUM_L2_QUEUES_BB, MAX_NUM_L2_QUEUES_K2},
+	{MAX_NUM_PORTS_BB, MAX_NUM_PORTS_K2},
+	{MAX_SB_PER_PATH_BB, MAX_SB_PER_PATH_K2,},
+	{MAX_NUM_PFS_BB, MAX_NUM_PFS_K2},
+	{MAX_NUM_VPORTS_BB, MAX_NUM_VPORTS_K2},
+	{ETH_RSS_ENGINE_NUM_BB, ETH_RSS_ENGINE_NUM_K2},
+	{MAX_QM_TX_QUEUES_BB, MAX_QM_TX_QUEUES_K2},
+	{PXP_NUM_ILT_RECORDS_BB, PXP_NUM_ILT_RECORDS_K2},
+	{RDMA_NUM_STATISTIC_COUNTERS_BB, RDMA_NUM_STATISTIC_COUNTERS_K2},
+	{MAX_QM_GLOBAL_RLS, MAX_QM_GLOBAL_RLS},
+	{PBF_MAX_CMD_LINES, PBF_MAX_CMD_LINES},
+	{BTB_MAX_BLOCKS_BB, BTB_MAX_BLOCKS_K2},
+};
+
+u32 qed_get_hsi_def_val(struct qed_dev *cdev, enum qed_hsi_def_type type)
+{
+	enum chip_ids chip_id = QED_IS_BB(cdev) ? CHIP_BB : CHIP_K2;
+
+	if (type >= QED_NUM_HSI_DEFS) {
+		DP_ERR(cdev, "Unexpected HSI definition type [%d]\n", type);
+		return 0;
+	}
+
+	return qed_hsi_def_val[type][chip_id];
+}
 static int
 qed_hw_set_soft_resc_size(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
-	bool b_ah = QED_IS_AH(p_hwfn->cdev);
 	u32 resc_max_val, mcp_resp;
 	u8 res_id;
 	int rc;
-
 	for (res_id = 0; res_id < QED_MAX_RESC; res_id++) {
 		switch (res_id) {
 		case QED_LL2_RAM_QUEUE:
@@ -3630,8 +3658,8 @@ qed_hw_set_soft_resc_size(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 			resc_max_val = NUM_OF_GLOBAL_QUEUES;
 			break;
 		case QED_RDMA_STATS_QUEUE:
-			resc_max_val = b_ah ? RDMA_NUM_STATISTIC_COUNTERS_K2
-			    : RDMA_NUM_STATISTIC_COUNTERS_BB;
+			resc_max_val =
+			    NUM_OF_RDMA_STATISTIC_COUNTERS(p_hwfn->cdev);
 			break;
 		case QED_BDQ:
 			resc_max_val = BDQ_NUM_RESOURCES;
@@ -3664,28 +3692,24 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 			 u32 *p_resc_num, u32 *p_resc_start)
 {
 	u8 num_funcs = p_hwfn->num_funcs_on_engine;
-	bool b_ah = QED_IS_AH(p_hwfn->cdev);
+	struct qed_dev *cdev = p_hwfn->cdev;
 
 	switch (res_id) {
 	case QED_L2_QUEUE:
-		*p_resc_num = (b_ah ? MAX_NUM_L2_QUEUES_K2 :
-			       MAX_NUM_L2_QUEUES_BB) / num_funcs;
+		*p_resc_num = NUM_OF_L2_QUEUES(cdev) / num_funcs;
 		break;
 	case QED_VPORT:
-		*p_resc_num = (b_ah ? MAX_NUM_VPORTS_K2 :
-			       MAX_NUM_VPORTS_BB) / num_funcs;
+		*p_resc_num = NUM_OF_VPORTS(cdev) / num_funcs;
 		break;
 	case QED_RSS_ENG:
-		*p_resc_num = (b_ah ? ETH_RSS_ENGINE_NUM_K2 :
-			       ETH_RSS_ENGINE_NUM_BB) / num_funcs;
+		*p_resc_num = NUM_OF_RSS_ENGINES(cdev) / num_funcs;
 		break;
 	case QED_PQ:
-		*p_resc_num = (b_ah ? MAX_QM_TX_QUEUES_K2 :
-			       MAX_QM_TX_QUEUES_BB) / num_funcs;
+		*p_resc_num = NUM_OF_QM_TX_QUEUES(cdev) / num_funcs;
 		*p_resc_num &= ~0x7;	/* The granularity of the PQs is 8 */
 		break;
 	case QED_RL:
-		*p_resc_num = MAX_QM_GLOBAL_RLS / num_funcs;
+		*p_resc_num = NUM_OF_QM_GLOBAL_RLS(cdev) / num_funcs;
 		break;
 	case QED_MAC:
 	case QED_VLAN:
@@ -3693,8 +3717,7 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 		*p_resc_num = ETH_NUM_MAC_FILTERS / num_funcs;
 		break;
 	case QED_ILT:
-		*p_resc_num = (b_ah ? PXP_NUM_ILT_RECORDS_K2 :
-			       PXP_NUM_ILT_RECORDS_BB) / num_funcs;
+		*p_resc_num = NUM_OF_PXP_ILT_RECORDS(cdev) / num_funcs;
 		break;
 	case QED_LL2_RAM_QUEUE:
 		*p_resc_num = MAX_NUM_LL2_RX_RAM_QUEUES / num_funcs;
@@ -3708,8 +3731,7 @@ int qed_hw_get_dflt_resc(struct qed_hwfn *p_hwfn,
 		*p_resc_num = NUM_OF_GLOBAL_QUEUES / num_funcs;
 		break;
 	case QED_RDMA_STATS_QUEUE:
-		*p_resc_num = (b_ah ? RDMA_NUM_STATISTIC_COUNTERS_K2 :
-			       RDMA_NUM_STATISTIC_COUNTERS_BB) / num_funcs;
+		*p_resc_num = NUM_OF_RDMA_STATISTIC_COUNTERS(cdev) / num_funcs;
 		break;
 	case QED_BDQ:
 		if (p_hwfn->hw_info.personality != QED_PCI_ISCSI &&
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index a2b7826b36f0..718ce72e5965 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -663,8 +663,8 @@
 #define PBF_MAX_CMD_LINES	3328
 
 /* Number of BTB blocks. Each block is 256B. */
-#define BTB_MAX_BLOCKS		1440
-
+#define BTB_MAX_BLOCKS_BB 1440
+#define BTB_MAX_BLOCKS_K2 1840
 /*****************/
 /* PRS CONSTANTS */
 /*****************/
-- 
2.14.5

