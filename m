Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EAD41C48A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbhI2MRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:17:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16846 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343750AbhI2MQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8e7NY008407;
        Wed, 29 Sep 2021 05:13:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=AHOVgTFhb2oHZF48CQZTli68nfiMSiwbfcCqlx16MZY=;
 b=desJ9YiCQIiguv2uq03DIL0hVkwKnZK3Ve7nIfgZNREXgNWBPbjNPZ0XDAPdAVl5skEy
 dVsAJ4m7fzf+PbxEbiaybV+1xozJLsrkfrbDRTXHSVHLKXnszgTvLZILSVuox71wtRJV
 wljTkCUWYVuamOcxygi8mTEc2AtZhZz2JZuspZMt/4LfoiMARzck4ogefsXmbzssNDCv
 Pj6DUDCnhrfETpwPNDrSEa5YpDnZrtdCTCi4/G6PX+73r/t665qDxsoJW3+xIsrecXzY
 U/XUgKsVlea7ER/s9bS7WB8OWDqKU8I+idxWpJvz/fEwb11B9gcEcNdb+uYPv7Z24YwJ sw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bcfd4a0by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:13:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:13:18 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:13:15 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 12/12] qed: fix ll2 establishment during load of RDMA driver
Date:   Wed, 29 Sep 2021 15:12:15 +0300
Message-ID: <20210929121215.17864-13-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: jIwWeE_-sSEevTOdAl7QJRYjzsPLT5sS
X-Proofpoint-ORIG-GUID: jIwWeE_-sSEevTOdAl7QJRYjzsPLT5sS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

If stats ID of a LL2 (light l2) queue exceeds than the total amount
of statistics counters, it may cause system crash upon enabling
RDMA on all PFs.

This patch makes sure that the stats ID of the LL2 queue doesn't exceed
the max allowed value.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 49 ++++++++++++++++++++---
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 1a8c0df3d3dc..e199877a6526 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -44,6 +44,8 @@
 #define QED_LL2_TX_SIZE (256)
 #define QED_LL2_RX_SIZE (4096)
 
+#define QED_LL2_INVALID_STATS_ID        0xff
+
 struct qed_cb_ll2_info {
 	int rx_cnt;
 	u32 rx_size;
@@ -63,6 +65,29 @@ struct qed_ll2_buffer {
 	dma_addr_t phys_addr;
 };
 
+static inline u8 qed_ll2_handle_to_stats_id(struct qed_hwfn *p_hwfn,
+					    u8 ll2_queue_type, u8 qid)
+{
+	u8 stats_id;
+
+	/* For legacy (RAM based) queues, the stats_id will be set as the
+	 * queue_id. Otherwise (context based queue), it will be set to
+	 * the "abs_pf_id" offset from the end of the RAM based queue IDs.
+	 * If the final value exceeds the total counters amount, return
+	 * INVALID value to indicate that the stats for this connection should
+	 * be disabled.
+	 */
+	if (ll2_queue_type == QED_LL2_RX_TYPE_LEGACY)
+		stats_id = qid;
+	else
+		stats_id = MAX_NUM_LL2_RX_RAM_QUEUES + p_hwfn->abs_pf_id;
+
+	if (stats_id < MAX_NUM_LL2_TX_STATS_COUNTERS)
+		return stats_id;
+	else
+		return QED_LL2_INVALID_STATS_ID;
+}
+
 static void qed_ll2b_complete_tx_packet(void *cxt,
 					u8 connection_handle,
 					void *cookie,
@@ -1546,7 +1571,7 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 	int rc = -EINVAL;
 	u32 i, capacity;
 	size_t desc_size;
-	u8 qid;
+	u8 qid, stats_id;
 
 	p_ptt = qed_ptt_acquire(p_hwfn);
 	if (!p_ptt)
@@ -1612,12 +1637,26 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 
 	qid = qed_ll2_handle_to_queue_id(p_hwfn, connection_handle,
 					 p_ll2_conn->input.rx_conn_type);
+	stats_id = qed_ll2_handle_to_stats_id(p_hwfn,
+					      p_ll2_conn->input.rx_conn_type,
+					      qid);
 	p_ll2_conn->queue_id = qid;
-	p_ll2_conn->tx_stats_id = qid;
+	p_ll2_conn->tx_stats_id = stats_id;
 
-	DP_VERBOSE(p_hwfn, QED_MSG_LL2,
-		   "Establishing ll2 queue. PF %d ctx_based=%d abs qid=%d\n",
-		   p_hwfn->rel_pf_id, p_ll2_conn->input.rx_conn_type, qid);
+	/* If there is no valid stats id for this connection, disable stats */
+	if (p_ll2_conn->tx_stats_id == QED_LL2_INVALID_STATS_ID) {
+		p_ll2_conn->tx_stats_en = 0;
+		DP_VERBOSE(p_hwfn,
+			   QED_MSG_LL2,
+			   "Disabling stats for queue %d - not enough counters\n",
+			   qid);
+	}
+
+	DP_VERBOSE(p_hwfn,
+		   QED_MSG_LL2,
+		   "Establishing ll2 queue. PF %d ctx_bsaed=%d abs qid=%d stats_id=%d\n",
+		   p_hwfn->rel_pf_id,
+		   p_ll2_conn->input.rx_conn_type, qid, stats_id);
 
 	if (p_ll2_conn->input.rx_conn_type == QED_LL2_RX_TYPE_LEGACY) {
 		p_rx->set_prod_addr =
-- 
2.24.1

