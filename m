Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18C42F133
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 14:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhJOMpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 08:45:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235956AbhJOMnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 08:43:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19FCVK23018220;
        Fri, 15 Oct 2021 05:41:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=H5WNJRk1/hdQEC6s80QTybSslIqvaspRBHyU0FpdjSE=;
 b=M8IiwWjjrQxcoQnek4GJ3D5nsDOW1DhywwCxCqgXkCcZRdJgEXaODhZImT2ipdNdCf4K
 Ide6C2iCte7hjO/tsHlWxlCNfL4oImN4diZlCsCd9nreXyM3OZ/EXK3hjkGXo+WZMrRH
 4QY9Sd031aEBU3gibxFrdOuFMvwdwEhfD3MzIp/5B9bmIiSz9ySzm6q6lNenZYXTL7DL
 T6pbhaCuar9x43QzM98BvzL7rLhrzk3otvmXb0xeQVMqPS7YLlrkHJUskLynGvqpbiXv
 zGs6X2VhMlkgaJBC6B5OmTxNNBT7kWPnlMoWDEEqVaOKVj7hCCz267W12mN+jG5H6aWG 3g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bq9q8g169-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Oct 2021 05:41:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 15 Oct
 2021 05:41:38 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 15 Oct 2021 05:41:37 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH net-next 2/2] qed: Change the TCP common variable - "iscsi_ooo"
Date:   Fri, 15 Oct 2021 15:41:17 +0300
Message-ID: <20211015124118.29041-2-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20211015124118.29041-1-smalin@marvell.com>
References: <20211015124118.29041-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: yWKIL9lRTq8z6f7Vz2uUUHNzkp2GWT8w
X-Proofpoint-ORIG-GUID: yWKIL9lRTq8z6f7Vz2uUUHNzkp2GWT8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_04,2021-10-14_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the TCP common variable - "iscsi_ooo" to "ooo_opq".
This variable is common between all the TCP L5 protocols and not
specific to iSCSI.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 50 +++++++++++------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 6068b0b94ea3..ed274f033626 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -623,18 +623,18 @@ static bool
 qed_ll2_lb_rxq_handler_slowpath(struct qed_hwfn *p_hwfn,
 				struct core_rx_slow_path_cqe *p_cqe)
 {
-	struct ooo_opaque *iscsi_ooo;
+	struct ooo_opaque *ooo_opq;
 	u32 cid;
 
 	if (p_cqe->ramrod_cmd_id != CORE_RAMROD_RX_QUEUE_FLUSH)
 		return false;
 
-	iscsi_ooo = (struct ooo_opaque *)&p_cqe->opaque_data;
-	if (iscsi_ooo->ooo_opcode != TCP_EVENT_DELETE_ISLES)
+	ooo_opq = (struct ooo_opaque *)&p_cqe->opaque_data;
+	if (ooo_opq->ooo_opcode != TCP_EVENT_DELETE_ISLES)
 		return false;
 
 	/* Need to make a flush */
-	cid = le32_to_cpu(iscsi_ooo->cid);
+	cid = le32_to_cpu(ooo_opq->cid);
 	qed_ooo_release_connection_isles(p_hwfn, p_hwfn->p_ooo_info, cid);
 
 	return true;
@@ -650,7 +650,7 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 	union core_rx_cqe_union *cqe = NULL;
 	u16 cq_new_idx = 0, cq_old_idx = 0;
 	struct qed_ooo_buffer *p_buffer;
-	struct ooo_opaque *iscsi_ooo;
+	struct ooo_opaque *ooo_opq;
 	u8 placement_offset = 0;
 	u8 cqe_type;
 
@@ -683,18 +683,17 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 		parse_flags = le16_to_cpu(p_cqe_fp->parse_flags.flags);
 		packet_length = le16_to_cpu(p_cqe_fp->packet_length);
 		vlan = le16_to_cpu(p_cqe_fp->vlan);
-		iscsi_ooo = (struct ooo_opaque *)&p_cqe_fp->opaque_data;
-		qed_ooo_save_history_entry(p_hwfn, p_hwfn->p_ooo_info,
-					   iscsi_ooo);
-		cid = le32_to_cpu(iscsi_ooo->cid);
+		ooo_opq = (struct ooo_opaque *)&p_cqe_fp->opaque_data;
+		qed_ooo_save_history_entry(p_hwfn, p_hwfn->p_ooo_info, ooo_opq);
+		cid = le32_to_cpu(ooo_opq->cid);
 
 		/* Process delete isle first */
-		if (iscsi_ooo->drop_size)
+		if (ooo_opq->drop_size)
 			qed_ooo_delete_isles(p_hwfn, p_hwfn->p_ooo_info, cid,
-					     iscsi_ooo->drop_isle,
-					     iscsi_ooo->drop_size);
+					     ooo_opq->drop_isle,
+					     ooo_opq->drop_size);
 
-		if (iscsi_ooo->ooo_opcode == TCP_EVENT_NOP)
+		if (ooo_opq->ooo_opcode == TCP_EVENT_NOP)
 			continue;
 
 		/* Now process create/add/join isles */
@@ -708,11 +707,11 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 		p_pkt = list_first_entry(&p_rx->active_descq,
 					 struct qed_ll2_rx_packet, list_entry);
 
-		if (likely(iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE ||
-			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT ||
-			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT ||
-			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN ||
-			   iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN)) {
+		if (likely(ooo_opq->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE ||
+			   ooo_opq->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT ||
+			   ooo_opq->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT ||
+			   ooo_opq->ooo_opcode == TCP_EVENT_ADD_PEN ||
+			   ooo_opq->ooo_opcode == TCP_EVENT_JOIN)) {
 			if (unlikely(!p_pkt)) {
 				DP_NOTICE(p_hwfn,
 					  "LL2 OOO RX packet is not valid\n");
@@ -727,19 +726,19 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 			qed_chain_consume(&p_rx->rxq_chain);
 			list_add_tail(&p_pkt->list_entry, &p_rx->free_descq);
 
-			switch (iscsi_ooo->ooo_opcode) {
+			switch (ooo_opq->ooo_opcode) {
 			case TCP_EVENT_ADD_NEW_ISLE:
 				qed_ooo_add_new_isle(p_hwfn,
 						     p_hwfn->p_ooo_info,
 						     cid,
-						     iscsi_ooo->ooo_isle,
+						     ooo_opq->ooo_isle,
 						     p_buffer);
 				break;
 			case TCP_EVENT_ADD_ISLE_RIGHT:
 				qed_ooo_add_new_buffer(p_hwfn,
 						       p_hwfn->p_ooo_info,
 						       cid,
-						       iscsi_ooo->ooo_isle,
+						       ooo_opq->ooo_isle,
 						       p_buffer,
 						       QED_OOO_RIGHT_BUF);
 				break;
@@ -747,7 +746,7 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 				qed_ooo_add_new_buffer(p_hwfn,
 						       p_hwfn->p_ooo_info,
 						       cid,
-						       iscsi_ooo->ooo_isle,
+						       ooo_opq->ooo_isle,
 						       p_buffer,
 						       QED_OOO_LEFT_BUF);
 				break;
@@ -755,13 +754,12 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 				qed_ooo_add_new_buffer(p_hwfn,
 						       p_hwfn->p_ooo_info,
 						       cid,
-						       iscsi_ooo->ooo_isle +
-						       1,
+						       ooo_opq->ooo_isle + 1,
 						       p_buffer,
 						       QED_OOO_LEFT_BUF);
 				qed_ooo_join_isles(p_hwfn,
 						   p_hwfn->p_ooo_info,
-						   cid, iscsi_ooo->ooo_isle);
+						   cid, ooo_opq->ooo_isle);
 				break;
 			case TCP_EVENT_ADD_PEN:
 				num_ooo_add_to_peninsula++;
@@ -773,7 +771,7 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 		} else {
 			DP_NOTICE(p_hwfn,
 				  "Unexpected event (%d) TX OOO completion\n",
-				  iscsi_ooo->ooo_opcode);
+				  ooo_opq->ooo_opcode);
 		}
 	}
 
-- 
2.22.0

