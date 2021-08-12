Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F4B3EAB64
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhHLTyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:54:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9586 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234057AbhHLTyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:54:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CJotPT004069;
        Thu, 12 Aug 2021 12:53:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=7qUhYeLTb22J/JlPbERhY2CQ7VK9cj0bdyTLsvaaaHs=;
 b=IQLo+BE24vEkO8GSUEEQ5R1cmaf3d/e6I+pxKklNu9hWt8YXicd0bB/X3IP+i0WRsYBW
 RyeACzY0/ZSZb6Eodbnk8OhXD7fU1s8YzUqtcqnsZLDkPbCAWS4MHvdnsvrZIMxEF6jP
 87Sy1gCaAiUBM2/qbDcSm8HcWCG7sbnMDpRgo+UJbBv87+z9c33lHtpd57/RjLu6Txqj
 IHjPEFpGRxuqze2bI8YL564tYz+awzzymkRk/xrCJ2ZmSwljm9E6jRNvVnFvF2IMnvfD
 h+WUXout+X+Kju/dEJ2UAjCgOpoyNQg/h/u7Ccx5g58KaP4uiE6jQh1a0QcF6PpvCsYR IA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ad8x9g8dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 12:53:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 12 Aug
 2021 12:53:48 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 12 Aug 2021 12:53:47 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH v2] qed: qed ll2 race condition fixes
Date:   Thu, 12 Aug 2021 22:53:13 +0300
Message-ID: <20210812195313.7220-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: qUsNGCo2bnOW-iWB4S0_PJPCjeifpgwK
X-Proofpoint-ORIG-GUID: qUsNGCo2bnOW-iWB4S0_PJPCjeifpgwK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_06:2021-08-12,2021-08-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoiding qed ll2 race condition and NULL pointer dereference as part
of the remove and recovery flows.

Changes form V1:
- Change (!p_rx->set_prod_addr).
- qed_ll2.c checkpatch fixes.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 38 +++++++++++++++++------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 02a4610d9330..9a9f0c516c0c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -106,7 +106,7 @@ static int qed_ll2_alloc_buffer(struct qed_dev *cdev,
 }
 
 static int qed_ll2_dealloc_buffer(struct qed_dev *cdev,
-				 struct qed_ll2_buffer *buffer)
+				  struct qed_ll2_buffer *buffer)
 {
 	spin_lock_bh(&cdev->ll2->lock);
 
@@ -327,6 +327,9 @@ static int qed_ll2_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	unsigned long flags;
 	int rc = -EINVAL;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_tx->lock, flags);
 	if (p_tx->b_completing_packet) {
 		rc = -EBUSY;
@@ -500,7 +503,16 @@ static int qed_ll2_rxq_completion(struct qed_hwfn *p_hwfn, void *cookie)
 	unsigned long flags = 0;
 	int rc = 0;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_rx->lock, flags);
+
+	if (!QED_LL2_RX_REGISTERED(p_ll2_conn)) {
+		spin_unlock_irqrestore(&p_rx->lock, flags);
+		return 0;
+	}
+
 	cq_new_idx = le16_to_cpu(*p_rx->p_fw_cons);
 	cq_old_idx = qed_chain_get_cons_idx(&p_rx->rcq_chain);
 
@@ -670,11 +682,11 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 		p_pkt = list_first_entry(&p_rx->active_descq,
 					 struct qed_ll2_rx_packet, list_entry);
 
-		if ((iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN)) {
+		if (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE ||
+		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT ||
+		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT ||
+		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN ||
+		    iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN) {
 			if (!p_pkt) {
 				DP_NOTICE(p_hwfn,
 					  "LL2 OOO RX packet is not valid\n");
@@ -821,6 +833,9 @@ static int qed_ll2_lb_rxq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	struct qed_ll2_info *p_ll2_conn = (struct qed_ll2_info *)p_cookie;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_RX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -844,6 +859,9 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	u16 new_idx = 0, num_bds = 0;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -1106,6 +1124,7 @@ static int qed_sp_ll2_tx_queue_stop(struct qed_hwfn *p_hwfn,
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
 	int rc = -EINVAL;
+
 	qed_db_recovery_del(p_hwfn->cdev, p_tx->doorbell_addr, &p_tx->db_msg);
 
 	/* Get SPQ entry */
@@ -1728,6 +1747,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
 	if (!p_ll2_conn)
 		return -EINVAL;
 	p_rx = &p_ll2_conn->rx_queue;
+	if (!p_rx->set_prod_addr)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
@@ -1742,7 +1763,7 @@ int qed_ll2_post_rx_buffer(void *cxt,
 		}
 	}
 
-	/* If we're lacking entires, let's try to flush buffers to FW */
+	/* If we're lacking entries, let's try to flush buffers to FW */
 	if (!p_curp || !p_curb) {
 		rc = -EBUSY;
 		p_curp = NULL;
@@ -2258,7 +2279,7 @@ static int __qed_ll2_get_stats(void *cxt, u8 connection_handle,
 	struct qed_ll2_info *p_ll2_conn = NULL;
 	struct qed_ptt *p_ptt;
 
-	if ((connection_handle >= QED_MAX_NUM_OF_LL2_CONNECTIONS) ||
+	if (connection_handle >= QED_MAX_NUM_OF_LL2_CONNECTIONS ||
 	    !p_hwfn->p_ll2_info)
 		return -EINVAL;
 
@@ -2589,7 +2610,6 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 			DP_NOTICE(cdev, "Failed to add an LLH filter\n");
 			goto err3;
 		}
-
 	}
 
 	ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
-- 
2.22.0

