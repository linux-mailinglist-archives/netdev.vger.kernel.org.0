Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12EB14663A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAWK6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:58:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18164 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbgAWK6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:58:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAuoNR005434;
        Thu, 23 Jan 2020 02:58:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=g+yv2h4QzZgi9xvC2bD2bxF4wswprEmI+EpqU76OyFY=;
 b=OSd9qK0BCScp/a0t3ExXN5Z48IE4+j074Wr2TBtjvjNV8Djy6daMjGoCeM31HF+KPzwk
 W6RC8FTCfshcrS/Qmptepj+nKnpcwmXcoLFauaidb+TndCwCsQHJpAe7jo7bnAH52FjL
 II83+ptp5ZFNJ6K9RpFkAGomFyok7h7L2+sIU77RhhvEfMZXmpAxG7E7FpFLwuGj+xXy
 ped8Gn595a5A9JxNHNxDfIECOSOf5l0Vd4TSNWchtkZnrbZHFWZQGlR12py9zptrFUYe
 6ue+Nz4oltzhLDV1TpDCKCpz2Go7k2xqqH2tdJaYLkdSCJ0RRiLfHeQc6gMS5GUQC+F0 nw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dtbd2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:58:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:58:46 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:58:46 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 806153F7040;
        Thu, 23 Jan 2020 02:58:44 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 01/13] qed: FW 8.42.2.0 Internal ram offsets modifications
Date:   Thu, 23 Jan 2020 12:58:24 +0200
Message-ID: <20200123105836.15090-2-michal.kalderon@marvell.com>
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

IRO stands for internal RAM offsets. Updating the FW binary produces
different iro offsets. This file contains the different values,
and a new representation of the values.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h | 419 ++++++++++++++++--------------
 2 files changed, 232 insertions(+), 191 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 89fe091c958d..8ec46bf409c2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -796,8 +796,8 @@ struct qed_dev {
 	u8				cache_shift;
 
 	/* Init */
-	const struct iro		*iro_arr;
-#define IRO (p_hwfn->cdev->iro_arr)
+	const u32 *iro_arr;
+#define IRO ((const struct iro *)p_hwfn->cdev->iro_arr)
 
 	/* HW functions */
 	u8				num_hwfns;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index cf3ceb62e397..aaff7117291c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -4282,325 +4282,366 @@ void qed_set_rdma_error_level(struct qed_hwfn *p_hwfn,
 	(IRO[7].base + ((queue_zone_id) * IRO[7].m1))
 #define USTORM_COMMON_QUEUE_CONS_SIZE			(IRO[7].size)
 
+/* Xstorm common PQ info */
+#define XSTORM_PQ_INFO_OFFSET(pq_id) \
+	(IRO[8].base + ((pq_id) * IRO[8].m1))
+#define XSTORM_PQ_INFO_SIZE				(IRO[8].size)
+
 /* Xstorm Integration Test Data */
-#define XSTORM_INTEG_TEST_DATA_OFFSET			(IRO[8].base)
-#define XSTORM_INTEG_TEST_DATA_SIZE			(IRO[8].size)
+#define XSTORM_INTEG_TEST_DATA_OFFSET			(IRO[9].base)
+#define XSTORM_INTEG_TEST_DATA_SIZE			(IRO[9].size)
 
 /* Ystorm Integration Test Data */
-#define YSTORM_INTEG_TEST_DATA_OFFSET			(IRO[9].base)
-#define YSTORM_INTEG_TEST_DATA_SIZE			(IRO[9].size)
+#define YSTORM_INTEG_TEST_DATA_OFFSET			(IRO[10].base)
+#define YSTORM_INTEG_TEST_DATA_SIZE			(IRO[10].size)
 
 /* Pstorm Integration Test Data */
-#define PSTORM_INTEG_TEST_DATA_OFFSET			(IRO[10].base)
-#define PSTORM_INTEG_TEST_DATA_SIZE			(IRO[10].size)
+#define PSTORM_INTEG_TEST_DATA_OFFSET			(IRO[11].base)
+#define PSTORM_INTEG_TEST_DATA_SIZE			(IRO[11].size)
 
 /* Tstorm Integration Test Data */
-#define TSTORM_INTEG_TEST_DATA_OFFSET			(IRO[11].base)
-#define TSTORM_INTEG_TEST_DATA_SIZE			(IRO[11].size)
+#define TSTORM_INTEG_TEST_DATA_OFFSET			(IRO[12].base)
+#define TSTORM_INTEG_TEST_DATA_SIZE			(IRO[12].size)
 
 /* Mstorm Integration Test Data */
-#define MSTORM_INTEG_TEST_DATA_OFFSET			(IRO[12].base)
-#define MSTORM_INTEG_TEST_DATA_SIZE			(IRO[12].size)
+#define MSTORM_INTEG_TEST_DATA_OFFSET			(IRO[13].base)
+#define MSTORM_INTEG_TEST_DATA_SIZE			(IRO[13].size)
 
 /* Ustorm Integration Test Data */
-#define USTORM_INTEG_TEST_DATA_OFFSET			(IRO[13].base)
-#define USTORM_INTEG_TEST_DATA_SIZE			(IRO[13].size)
+#define USTORM_INTEG_TEST_DATA_OFFSET			(IRO[14].base)
+#define USTORM_INTEG_TEST_DATA_SIZE			(IRO[14].size)
+
+/* Xstorm overlay buffer host address */
+#define XSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[15].base)
+#define XSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[15].size)
+
+/* Ystorm overlay buffer host address */
+#define YSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[16].base)
+#define YSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[16].size)
+
+/* Pstorm overlay buffer host address */
+#define PSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[17].base)
+#define PSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[17].size)
+
+/* Tstorm overlay buffer host address */
+#define TSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[18].base)
+#define TSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[18].size)
+
+/* Mstorm overlay buffer host address */
+#define MSTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[19].base)
+#define MSTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[19].size)
+
+/* Ustorm overlay buffer host address */
+#define USTORM_OVERLAY_BUF_ADDR_OFFSET			(IRO[20].base)
+#define USTORM_OVERLAY_BUF_ADDR_SIZE			(IRO[20].size)
 
 /* Tstorm producers */
 #define TSTORM_LL2_RX_PRODS_OFFSET(core_rx_queue_id) \
-	(IRO[14].base + ((core_rx_queue_id) * IRO[14].m1))
-#define TSTORM_LL2_RX_PRODS_SIZE			(IRO[14].size)
+	(IRO[21].base + ((core_rx_queue_id) * IRO[21].m1))
+#define TSTORM_LL2_RX_PRODS_SIZE			(IRO[21].size)
 
 /* Tstorm LightL2 queue statistics */
 #define CORE_LL2_TSTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
-	(IRO[15].base + ((core_rx_queue_id) * IRO[15].m1))
-#define CORE_LL2_TSTORM_PER_QUEUE_STAT_SIZE		(IRO[15].size)
+	(IRO[22].base + ((core_rx_queue_id) * IRO[22].m1))
+#define CORE_LL2_TSTORM_PER_QUEUE_STAT_SIZE		(IRO[22].size)
 
 /* Ustorm LiteL2 queue statistics */
 #define CORE_LL2_USTORM_PER_QUEUE_STAT_OFFSET(core_rx_queue_id) \
-	(IRO[16].base + ((core_rx_queue_id) * IRO[16].m1))
-#define CORE_LL2_USTORM_PER_QUEUE_STAT_SIZE		(IRO[16].size)
+	(IRO[23].base + ((core_rx_queue_id) * IRO[23].m1))
+#define CORE_LL2_USTORM_PER_QUEUE_STAT_SIZE		(IRO[23].size)
 
 /* Pstorm LiteL2 queue statistics */
 #define CORE_LL2_PSTORM_PER_QUEUE_STAT_OFFSET(core_tx_stats_id) \
-	(IRO[17].base + ((core_tx_stats_id) * IRO[17].m1))
-#define CORE_LL2_PSTORM_PER_QUEUE_STAT_SIZE		(IRO[17].size)
+	(IRO[24].base + ((core_tx_stats_id) * IRO[24].m1))
+#define CORE_LL2_PSTORM_PER_QUEUE_STAT_SIZE		(IRO[24].size)
 
 /* Mstorm queue statistics */
 #define MSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
-	(IRO[18].base + ((stat_counter_id) * IRO[18].m1))
-#define MSTORM_QUEUE_STAT_SIZE				(IRO[18].size)
+	(IRO[25].base + ((stat_counter_id) * IRO[25].m1))
+#define MSTORM_QUEUE_STAT_SIZE				(IRO[25].size)
 
-/* Mstorm ETH PF queues producers */
-#define MSTORM_ETH_PF_PRODS_OFFSET(queue_id) \
-	(IRO[19].base + ((queue_id) * IRO[19].m1))
-#define MSTORM_ETH_PF_PRODS_SIZE			(IRO[19].size)
+/* TPA agregation timeout in us resolution (on ASIC) */
+#define MSTORM_TPA_TIMEOUT_US_OFFSET			(IRO[26].base)
+#define MSTORM_TPA_TIMEOUT_US_SIZE			(IRO[26].size)
 
 /* Mstorm ETH VF queues producers offset in RAM. Used in default VF zone size
- * mode.
+ * mode
  */
 #define MSTORM_ETH_VF_PRODS_OFFSET(vf_id, vf_queue_id) \
-	(IRO[20].base + ((vf_id) * IRO[20].m1) + ((vf_queue_id) * IRO[20].m2))
-#define MSTORM_ETH_VF_PRODS_SIZE			(IRO[20].size)
+	(IRO[27].base + ((vf_id) * IRO[27].m1) + ((vf_queue_id) * IRO[27].m2))
+#define MSTORM_ETH_VF_PRODS_SIZE			(IRO[27].size)
 
-/* TPA agregation timeout in us resolution (on ASIC) */
-#define MSTORM_TPA_TIMEOUT_US_OFFSET			(IRO[21].base)
-#define MSTORM_TPA_TIMEOUT_US_SIZE			(IRO[21].size)
+/* Mstorm ETH PF queues producers */
+#define MSTORM_ETH_PF_PRODS_OFFSET(queue_id) \
+	(IRO[28].base + ((queue_id) * IRO[28].m1))
+#define MSTORM_ETH_PF_PRODS_SIZE			(IRO[28].size)
 
 /* Mstorm pf statistics */
 #define MSTORM_ETH_PF_STAT_OFFSET(pf_id) \
-	(IRO[22].base + ((pf_id) * IRO[22].m1))
-#define MSTORM_ETH_PF_STAT_SIZE				(IRO[22].size)
+	(IRO[29].base + ((pf_id) * IRO[29].m1))
+#define MSTORM_ETH_PF_STAT_SIZE				(IRO[29].size)
 
 /* Ustorm queue statistics */
 #define USTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
-	(IRO[23].base + ((stat_counter_id) * IRO[23].m1))
-#define USTORM_QUEUE_STAT_SIZE				(IRO[23].size)
+	(IRO[30].base + ((stat_counter_id) * IRO[30].m1))
+#define USTORM_QUEUE_STAT_SIZE				(IRO[30].size)
 
 /* Ustorm pf statistics */
-#define USTORM_ETH_PF_STAT_OFFSET(pf_id)\
-	(IRO[24].base + ((pf_id) * IRO[24].m1))
-#define USTORM_ETH_PF_STAT_SIZE				(IRO[24].size)
+#define USTORM_ETH_PF_STAT_OFFSET(pf_id) \
+	(IRO[31].base + ((pf_id) * IRO[31].m1))
+#define USTORM_ETH_PF_STAT_SIZE				(IRO[31].size)
 
 /* Pstorm queue statistics */
-#define PSTORM_QUEUE_STAT_OFFSET(stat_counter_id) \
-	(IRO[25].base + ((stat_counter_id) * IRO[25].m1))
-#define PSTORM_QUEUE_STAT_SIZE				(IRO[25].size)
+#define PSTORM_QUEUE_STAT_OFFSET(stat_counter_id)	\
+	(IRO[32].base + ((stat_counter_id) * IRO[32].m1))
+#define PSTORM_QUEUE_STAT_SIZE				(IRO[32].size)
 
 /* Pstorm pf statistics */
 #define PSTORM_ETH_PF_STAT_OFFSET(pf_id) \
-	(IRO[26].base + ((pf_id) * IRO[26].m1))
-#define PSTORM_ETH_PF_STAT_SIZE				(IRO[26].size)
+	(IRO[33].base + ((pf_id) * IRO[33].m1))
+#define PSTORM_ETH_PF_STAT_SIZE				(IRO[33].size)
 
 /* Control frame's EthType configuration for TX control frame security */
-#define PSTORM_CTL_FRAME_ETHTYPE_OFFSET(eth_type_id) \
-	(IRO[27].base + ((eth_type_id) * IRO[27].m1))
-#define PSTORM_CTL_FRAME_ETHTYPE_SIZE			(IRO[27].size)
+#define PSTORM_CTL_FRAME_ETHTYPE_OFFSET(eth_type_id)	\
+	(IRO[34].base + ((eth_type_id) * IRO[34].m1))
+#define PSTORM_CTL_FRAME_ETHTYPE_SIZE			(IRO[34].size)
 
 /* Tstorm last parser message */
-#define TSTORM_ETH_PRS_INPUT_OFFSET			(IRO[28].base)
-#define TSTORM_ETH_PRS_INPUT_SIZE			(IRO[28].size)
+#define TSTORM_ETH_PRS_INPUT_OFFSET			(IRO[35].base)
+#define TSTORM_ETH_PRS_INPUT_SIZE			(IRO[35].size)
 
 /* Tstorm Eth limit Rx rate */
-#define ETH_RX_RATE_LIMIT_OFFSET(pf_id) \
-	(IRO[29].base + ((pf_id) * IRO[29].m1))
-#define ETH_RX_RATE_LIMIT_SIZE				(IRO[29].size)
+#define ETH_RX_RATE_LIMIT_OFFSET(pf_id)	\
+	(IRO[36].base + ((pf_id) * IRO[36].m1))
+#define ETH_RX_RATE_LIMIT_SIZE				(IRO[36].size)
 
 /* RSS indirection table entry update command per PF offset in TSTORM PF BAR0.
- * Use eth_tstorm_rss_update_data for update.
+ * Use eth_tstorm_rss_update_data for update
  */
 #define TSTORM_ETH_RSS_UPDATE_OFFSET(pf_id) \
-	(IRO[30].base + ((pf_id) * IRO[30].m1))
-#define TSTORM_ETH_RSS_UPDATE_SIZE			(IRO[30].size)
+	(IRO[37].base + ((pf_id) * IRO[37].m1))
+#define TSTORM_ETH_RSS_UPDATE_SIZE			(IRO[37].size)
 
 /* Xstorm queue zone */
 #define XSTORM_ETH_QUEUE_ZONE_OFFSET(queue_id) \
-	(IRO[31].base + ((queue_id) * IRO[31].m1))
-#define XSTORM_ETH_QUEUE_ZONE_SIZE			(IRO[31].size)
+	(IRO[38].base + ((queue_id) * IRO[38].m1))
+#define XSTORM_ETH_QUEUE_ZONE_SIZE			(IRO[38].size)
 
 /* Ystorm cqe producer */
 #define YSTORM_TOE_CQ_PROD_OFFSET(rss_id) \
-	(IRO[32].base + ((rss_id) * IRO[32].m1))
-#define YSTORM_TOE_CQ_PROD_SIZE				(IRO[32].size)
+	(IRO[39].base + ((rss_id) * IRO[39].m1))
+#define YSTORM_TOE_CQ_PROD_SIZE				(IRO[39].size)
 
 /* Ustorm cqe producer */
 #define USTORM_TOE_CQ_PROD_OFFSET(rss_id) \
-	(IRO[33].base + ((rss_id) * IRO[33].m1))
-#define USTORM_TOE_CQ_PROD_SIZE				(IRO[33].size)
+	(IRO[40].base + ((rss_id) * IRO[40].m1))
+#define USTORM_TOE_CQ_PROD_SIZE				(IRO[40].size)
 
 /* Ustorm grq producer */
 #define USTORM_TOE_GRQ_PROD_OFFSET(pf_id) \
-	(IRO[34].base + ((pf_id) * IRO[34].m1))
-#define USTORM_TOE_GRQ_PROD_SIZE			(IRO[34].size)
+	(IRO[41].base + ((pf_id) * IRO[41].m1))
+#define USTORM_TOE_GRQ_PROD_SIZE			(IRO[41].size)
 
 /* Tstorm cmdq-cons of given command queue-id */
 #define TSTORM_SCSI_CMDQ_CONS_OFFSET(cmdq_queue_id) \
-	(IRO[35].base + ((cmdq_queue_id) * IRO[35].m1))
-#define TSTORM_SCSI_CMDQ_CONS_SIZE			(IRO[35].size)
+	(IRO[42].base + ((cmdq_queue_id) * IRO[42].m1))
+#define TSTORM_SCSI_CMDQ_CONS_SIZE			(IRO[42].size)
 
 /* Tstorm (reflects M-Storm) bdq-external-producer of given function ID,
- * BDqueue-id.
+ * BDqueue-id
  */
-#define TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(func_id, bdq_id) \
-	(IRO[36].base + ((func_id) * IRO[36].m1) + ((bdq_id) * IRO[36].m2))
-#define TSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[36].size)
+#define TSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id) \
+	(IRO[43].base + ((storage_func_id) * IRO[43].m1) + \
+	 ((bdq_id) * IRO[43].m2))
+#define TSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[43].size)
 
 /* Mstorm bdq-external-producer of given BDQ resource ID, BDqueue-id */
-#define MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(func_id, bdq_id) \
-	(IRO[37].base + ((func_id) * IRO[37].m1) + ((bdq_id) * IRO[37].m2))
-#define MSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[37].size)
+#define MSTORM_SCSI_BDQ_EXT_PROD_OFFSET(storage_func_id, bdq_id) \
+	(IRO[44].base + ((storage_func_id) * IRO[44].m1) + \
+	 ((bdq_id) * IRO[44].m2))
+#define MSTORM_SCSI_BDQ_EXT_PROD_SIZE			(IRO[44].size)
 
 /* Tstorm iSCSI RX stats */
-#define TSTORM_ISCSI_RX_STATS_OFFSET(pf_id) \
-	(IRO[38].base + ((pf_id) * IRO[38].m1))
-#define TSTORM_ISCSI_RX_STATS_SIZE			(IRO[38].size)
+#define TSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
+	(IRO[45].base + ((storage_func_id) * IRO[45].m1))
+#define TSTORM_ISCSI_RX_STATS_SIZE			(IRO[45].size)
 
 /* Mstorm iSCSI RX stats */
-#define MSTORM_ISCSI_RX_STATS_OFFSET(pf_id) \
-	(IRO[39].base + ((pf_id) * IRO[39].m1))
-#define MSTORM_ISCSI_RX_STATS_SIZE			(IRO[39].size)
+#define MSTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
+	(IRO[46].base + ((storage_func_id) * IRO[46].m1))
+#define MSTORM_ISCSI_RX_STATS_SIZE			(IRO[46].size)
 
 /* Ustorm iSCSI RX stats */
-#define USTORM_ISCSI_RX_STATS_OFFSET(pf_id) \
-	(IRO[40].base + ((pf_id) * IRO[40].m1))
-#define USTORM_ISCSI_RX_STATS_SIZE			(IRO[40].size)
+#define USTORM_ISCSI_RX_STATS_OFFSET(storage_func_id) \
+	(IRO[47].base + ((storage_func_id) * IRO[47].m1))
+#define USTORM_ISCSI_RX_STATS_SIZE			(IRO[47].size)
 
 /* Xstorm iSCSI TX stats */
-#define XSTORM_ISCSI_TX_STATS_OFFSET(pf_id) \
-	(IRO[41].base + ((pf_id) * IRO[41].m1))
-#define XSTORM_ISCSI_TX_STATS_SIZE			(IRO[41].size)
+#define XSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[48].base + ((storage_func_id) * IRO[48].m1))
+#define XSTORM_ISCSI_TX_STATS_SIZE			(IRO[48].size)
 
 /* Ystorm iSCSI TX stats */
-#define YSTORM_ISCSI_TX_STATS_OFFSET(pf_id) \
-	(IRO[42].base + ((pf_id) * IRO[42].m1))
-#define YSTORM_ISCSI_TX_STATS_SIZE			(IRO[42].size)
+#define YSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[49].base + ((storage_func_id) * IRO[49].m1))
+#define YSTORM_ISCSI_TX_STATS_SIZE			(IRO[49].size)
 
 /* Pstorm iSCSI TX stats */
-#define PSTORM_ISCSI_TX_STATS_OFFSET(pf_id) \
-	(IRO[43].base + ((pf_id) * IRO[43].m1))
-#define PSTORM_ISCSI_TX_STATS_SIZE			(IRO[43].size)
+#define PSTORM_ISCSI_TX_STATS_OFFSET(storage_func_id) \
+	(IRO[50].base + ((storage_func_id) * IRO[50].m1))
+#define PSTORM_ISCSI_TX_STATS_SIZE			(IRO[50].size)
 
 /* Tstorm FCoE RX stats */
 #define TSTORM_FCOE_RX_STATS_OFFSET(pf_id) \
-	(IRO[44].base + ((pf_id) * IRO[44].m1))
-#define TSTORM_FCOE_RX_STATS_SIZE			(IRO[44].size)
+	(IRO[51].base + ((pf_id) * IRO[51].m1))
+#define TSTORM_FCOE_RX_STATS_SIZE			(IRO[51].size)
 
 /* Pstorm FCoE TX stats */
 #define PSTORM_FCOE_TX_STATS_OFFSET(pf_id) \
-	(IRO[45].base + ((pf_id) * IRO[45].m1))
-#define PSTORM_FCOE_TX_STATS_SIZE			(IRO[45].size)
+	(IRO[52].base + ((pf_id) * IRO[52].m1))
+#define PSTORM_FCOE_TX_STATS_SIZE			(IRO[52].size)
 
 /* Pstorm RDMA queue statistics */
 #define PSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
-	(IRO[46].base + ((rdma_stat_counter_id) * IRO[46].m1))
-#define PSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[46].size)
+	(IRO[53].base + ((rdma_stat_counter_id) * IRO[53].m1))
+#define PSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[53].size)
 
 /* Tstorm RDMA queue statistics */
 #define TSTORM_RDMA_QUEUE_STAT_OFFSET(rdma_stat_counter_id) \
-	(IRO[47].base + ((rdma_stat_counter_id) * IRO[47].m1))
-#define TSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[47].size)
+	(IRO[54].base + ((rdma_stat_counter_id) * IRO[54].m1))
+#define TSTORM_RDMA_QUEUE_STAT_SIZE			(IRO[54].size)
 
 /* Xstorm error level for assert */
 #define XSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[48].base +	((pf_id) * IRO[48].m1))
-#define XSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[48].size)
+	(IRO[55].base + ((pf_id) * IRO[55].m1))
+#define XSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[55].size)
 
 /* Ystorm error level for assert */
 #define YSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[49].base + ((pf_id) * IRO[49].m1))
-#define YSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[49].size)
+	(IRO[56].base + ((pf_id) * IRO[56].m1))
+#define YSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[56].size)
 
 /* Pstorm error level for assert */
 #define PSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[50].base +	((pf_id) * IRO[50].m1))
-#define PSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[50].size)
+	(IRO[57].base + ((pf_id) * IRO[57].m1))
+#define PSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[57].size)
 
 /* Tstorm error level for assert */
 #define TSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[51].base +	((pf_id) * IRO[51].m1))
-#define TSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[51].size)
+	(IRO[58].base + ((pf_id) * IRO[58].m1))
+#define TSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[58].size)
 
 /* Mstorm error level for assert */
 #define MSTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[52].base + ((pf_id) * IRO[52].m1))
-#define MSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[52].size)
+	(IRO[59].base + ((pf_id) * IRO[59].m1))
+#define MSTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[59].size)
 
 /* Ustorm error level for assert */
 #define USTORM_RDMA_ASSERT_LEVEL_OFFSET(pf_id) \
-	(IRO[53].base + ((pf_id) * IRO[53].m1))
-#define USTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[53].size)
+	(IRO[60].base + ((pf_id) * IRO[60].m1))
+#define USTORM_RDMA_ASSERT_LEVEL_SIZE			(IRO[60].size)
 
 /* Xstorm iWARP rxmit stats */
 #define XSTORM_IWARP_RXMIT_STATS_OFFSET(pf_id) \
-	(IRO[54].base +	((pf_id) * IRO[54].m1))
-#define XSTORM_IWARP_RXMIT_STATS_SIZE			(IRO[54].size)
+	(IRO[61].base + ((pf_id) * IRO[61].m1))
+#define XSTORM_IWARP_RXMIT_STATS_SIZE			(IRO[61].size)
 
 /* Tstorm RoCE Event Statistics */
-#define TSTORM_ROCE_EVENTS_STAT_OFFSET(roce_pf_id) \
-	(IRO[55].base + ((roce_pf_id) * IRO[55].m1))
-#define TSTORM_ROCE_EVENTS_STAT_SIZE			(IRO[55].size)
+#define TSTORM_ROCE_EVENTS_STAT_OFFSET(roce_pf_id)	\
+	(IRO[62].base + ((roce_pf_id) * IRO[62].m1))
+#define TSTORM_ROCE_EVENTS_STAT_SIZE			(IRO[62].size)
 
 /* DCQCN Received Statistics */
-#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_OFFSET(roce_pf_id) \
-	(IRO[56].base + ((roce_pf_id) * IRO[56].m1))
-#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_SIZE		(IRO[56].size)
+#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_OFFSET(roce_pf_id)\
+	(IRO[63].base + ((roce_pf_id) * IRO[63].m1))
+#define YSTORM_ROCE_DCQCN_RECEIVED_STATS_SIZE		(IRO[63].size)
 
 /* RoCE Error Statistics */
-#define YSTORM_ROCE_ERROR_STATS_OFFSET(roce_pf_id) \
-	(IRO[57].base + ((roce_pf_id) * IRO[57].m1))
-#define YSTORM_ROCE_ERROR_STATS_SIZE			(IRO[57].size)
+#define YSTORM_ROCE_ERROR_STATS_OFFSET(roce_pf_id)	\
+	(IRO[64].base + ((roce_pf_id) * IRO[64].m1))
+#define YSTORM_ROCE_ERROR_STATS_SIZE			(IRO[64].size)
 
 /* DCQCN Sent Statistics */
-#define PSTORM_ROCE_DCQCN_SENT_STATS_OFFSET(roce_pf_id) \
-	(IRO[58].base + ((roce_pf_id) * IRO[58].m1))
-#define PSTORM_ROCE_DCQCN_SENT_STATS_SIZE		(IRO[58].size)
+#define PSTORM_ROCE_DCQCN_SENT_STATS_OFFSET(roce_pf_id)	\
+	(IRO[65].base + ((roce_pf_id) * IRO[65].m1))
+#define PSTORM_ROCE_DCQCN_SENT_STATS_SIZE		(IRO[65].size)
 
 /* RoCE CQEs Statistics */
-#define USTORM_ROCE_CQE_STATS_OFFSET(roce_pf_id) \
-	(IRO[59].base + ((roce_pf_id) * IRO[59].m1))
-#define USTORM_ROCE_CQE_STATS_SIZE			(IRO[59].size)
-
-static const struct iro iro_arr[60] = {
-	{0x0, 0x0, 0x0, 0x0, 0x8},
-	{0x4cb8, 0x88, 0x0, 0x0, 0x88},
-	{0x6530, 0x20, 0x0, 0x0, 0x20},
-	{0xb00, 0x8, 0x0, 0x0, 0x4},
-	{0xa80, 0x8, 0x0, 0x0, 0x4},
-	{0x0, 0x8, 0x0, 0x0, 0x2},
-	{0x80, 0x8, 0x0, 0x0, 0x4},
-	{0x84, 0x8, 0x0, 0x0, 0x2},
-	{0x4c48, 0x0, 0x0, 0x0, 0x78},
-	{0x3e38, 0x0, 0x0, 0x0, 0x78},
-	{0x3ef8, 0x0, 0x0, 0x0, 0x78},
-	{0x4c40, 0x0, 0x0, 0x0, 0x78},
-	{0x4998, 0x0, 0x0, 0x0, 0x78},
-	{0x7f50, 0x0, 0x0, 0x0, 0x78},
-	{0xa28, 0x8, 0x0, 0x0, 0x8},
-	{0x6210, 0x10, 0x0, 0x0, 0x10},
-	{0xb820, 0x30, 0x0, 0x0, 0x30},
-	{0xa990, 0x30, 0x0, 0x0, 0x30},
-	{0x4b68, 0x80, 0x0, 0x0, 0x40},
-	{0x1f8, 0x4, 0x0, 0x0, 0x4},
-	{0x53a8, 0x80, 0x4, 0x0, 0x4},
-	{0xc7d0, 0x0, 0x0, 0x0, 0x4},
-	{0x4ba8, 0x80, 0x0, 0x0, 0x20},
-	{0x8158, 0x40, 0x0, 0x0, 0x30},
-	{0xe770, 0x60, 0x0, 0x0, 0x60},
-	{0x4090, 0x80, 0x0, 0x0, 0x38},
-	{0xfea8, 0x78, 0x0, 0x0, 0x78},
-	{0x1f8, 0x4, 0x0, 0x0, 0x4},
-	{0xaf20, 0x0, 0x0, 0x0, 0xf0},
-	{0xb010, 0x8, 0x0, 0x0, 0x8},
-	{0xc00, 0x8, 0x0, 0x0, 0x8},
-	{0x1f8, 0x8, 0x0, 0x0, 0x8},
-	{0xac0, 0x8, 0x0, 0x0, 0x8},
-	{0x2578, 0x8, 0x0, 0x0, 0x8},
-	{0x24f8, 0x8, 0x0, 0x0, 0x8},
-	{0x0, 0x8, 0x0, 0x0, 0x8},
-	{0x400, 0x18, 0x8, 0x0, 0x8},
-	{0xb78, 0x18, 0x8, 0x0, 0x2},
-	{0xd898, 0x50, 0x0, 0x0, 0x3c},
-	{0x12908, 0x18, 0x0, 0x0, 0x10},
-	{0x11aa8, 0x40, 0x0, 0x0, 0x18},
-	{0xa588, 0x50, 0x0, 0x0, 0x20},
-	{0x8f00, 0x40, 0x0, 0x0, 0x28},
-	{0x10e30, 0x18, 0x0, 0x0, 0x10},
-	{0xde48, 0x48, 0x0, 0x0, 0x38},
-	{0x11298, 0x20, 0x0, 0x0, 0x20},
-	{0x40c8, 0x80, 0x0, 0x0, 0x10},
-	{0x5048, 0x10, 0x0, 0x0, 0x10},
-	{0xc748, 0x8, 0x0, 0x0, 0x1},
-	{0xa928, 0x8, 0x0, 0x0, 0x1},
-	{0x11a30, 0x8, 0x0, 0x0, 0x1},
-	{0xf030, 0x8, 0x0, 0x0, 0x1},
-	{0x13028, 0x8, 0x0, 0x0, 0x1},
-	{0x12c58, 0x8, 0x0, 0x0, 0x1},
-	{0xc9b8, 0x30, 0x0, 0x0, 0x10},
-	{0xed90, 0x28, 0x0, 0x0, 0x28},
-	{0xad20, 0x18, 0x0, 0x0, 0x18},
-	{0xaea0, 0x8, 0x0, 0x0, 0x8},
-	{0x13c38, 0x8, 0x0, 0x0, 0x8},
-	{0x13c50, 0x18, 0x0, 0x0, 0x18},
+#define USTORM_ROCE_CQE_STATS_OFFSET(roce_pf_id)	\
+	(IRO[66].base + ((roce_pf_id) * IRO[66].m1))
+#define USTORM_ROCE_CQE_STATS_SIZE			(IRO[66].size)
+
+/* IRO Array */
+static const u32 iro_arr[] = {
+	0x00000000, 0x00000000, 0x00080000,
+	0x00003288, 0x00000088, 0x00880000,
+	0x000058e8, 0x00000020, 0x00200000,
+	0x00000b00, 0x00000008, 0x00040000,
+	0x00000a80, 0x00000008, 0x00040000,
+	0x00000000, 0x00000008, 0x00020000,
+	0x00000080, 0x00000008, 0x00040000,
+	0x00000084, 0x00000008, 0x00020000,
+	0x00005718, 0x00000004, 0x00040000,
+	0x00004dd0, 0x00000000, 0x00780000,
+	0x00003e40, 0x00000000, 0x00780000,
+	0x00004480, 0x00000000, 0x00780000,
+	0x00003210, 0x00000000, 0x00780000,
+	0x00003b50, 0x00000000, 0x00780000,
+	0x00007f58, 0x00000000, 0x00780000,
+	0x00005f58, 0x00000000, 0x00080000,
+	0x00007100, 0x00000000, 0x00080000,
+	0x0000aea0, 0x00000000, 0x00080000,
+	0x00004398, 0x00000000, 0x00080000,
+	0x0000a5a0, 0x00000000, 0x00080000,
+	0x0000bde8, 0x00000000, 0x00080000,
+	0x00000020, 0x00000004, 0x00040000,
+	0x000056c8, 0x00000010, 0x00100000,
+	0x0000c210, 0x00000030, 0x00300000,
+	0x0000b088, 0x00000038, 0x00380000,
+	0x00003d20, 0x00000080, 0x00400000,
+	0x0000bf60, 0x00000000, 0x00040000,
+	0x00004560, 0x00040080, 0x00040000,
+	0x000001f8, 0x00000004, 0x00040000,
+	0x00003d60, 0x00000080, 0x00200000,
+	0x00008960, 0x00000040, 0x00300000,
+	0x0000e840, 0x00000060, 0x00600000,
+	0x00004618, 0x00000080, 0x00380000,
+	0x00010738, 0x000000c0, 0x00c00000,
+	0x000001f8, 0x00000002, 0x00020000,
+	0x0000a2a0, 0x00000000, 0x01080000,
+	0x0000a3a8, 0x00000008, 0x00080000,
+	0x000001c0, 0x00000008, 0x00080000,
+	0x000001f8, 0x00000008, 0x00080000,
+	0x00000ac0, 0x00000008, 0x00080000,
+	0x00002578, 0x00000008, 0x00080000,
+	0x000024f8, 0x00000008, 0x00080000,
+	0x00000280, 0x00000008, 0x00080000,
+	0x00000680, 0x00080018, 0x00080000,
+	0x00000b78, 0x00080018, 0x00020000,
+	0x0000c640, 0x00000050, 0x003c0000,
+	0x00012038, 0x00000018, 0x00100000,
+	0x00011b00, 0x00000040, 0x00180000,
+	0x000095d0, 0x00000050, 0x00200000,
+	0x00008b10, 0x00000040, 0x00280000,
+	0x00011640, 0x00000018, 0x00100000,
+	0x0000c828, 0x00000048, 0x00380000,
+	0x00011710, 0x00000020, 0x00200000,
+	0x00004650, 0x00000080, 0x00100000,
+	0x00003618, 0x00000010, 0x00100000,
+	0x0000a968, 0x00000008, 0x00010000,
+	0x000097a0, 0x00000008, 0x00010000,
+	0x00011990, 0x00000008, 0x00010000,
+	0x0000f018, 0x00000008, 0x00010000,
+	0x00012628, 0x00000008, 0x00010000,
+	0x00011da8, 0x00000008, 0x00010000,
+	0x0000aa78, 0x00000030, 0x00100000,
+	0x0000d768, 0x00000028, 0x00280000,
+	0x00009a58, 0x00000018, 0x00180000,
+	0x00009bd8, 0x00000008, 0x00080000,
+	0x00013a18, 0x00000008, 0x00080000,
+	0x000126e8, 0x00000018, 0x00180000,
+	0x0000e608, 0x00500288, 0x00100000,
+	0x00012970, 0x00000138, 0x00280000,
 };
 
 /* Runtime array offsets */
-- 
2.14.5

