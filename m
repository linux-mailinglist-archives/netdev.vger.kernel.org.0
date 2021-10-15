Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAD42F134
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 14:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbhJOMpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 08:45:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235537AbhJOMnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 08:43:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F8q6rQ020963;
        Fri, 15 Oct 2021 05:41:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TuDa8RUssHM+AhIXjtFb+ywL32f2E3gIbk1Rm8LgbiA=;
 b=R76Ee/AsK3b0xIM5EqZFpcrAArJDn9gvAYCMuCgiqOmeD5vakVOiDLxqzJkqvoF/yOtx
 Ryh24JA0Rp5QeWJr9XiHvHwro86IcPrHsR2D0fIZ8G6KAdZ3C53BeWYFqvVOfztCaOdF
 h/4WugvqEZXrckIIwVpk9I/5IvDEHcpcZ55L/kTx+PGRw8kQrs++rUz5o1lVo52e86+d
 WcPRz3fygTBj9NU466XzXwZ5QLbE25DXkuF7KxvWni2fIX+NUklZ8ibKK2vRNag55NAF
 uJTApZFOYMbxLPe+dxOUbo+P9FscEcgYtlTxqjeWaJ5XixiJKgj7R612mQ1YbtokTJyl Yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bq6gt8ssy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Oct 2021 05:41:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 15 Oct
 2021 05:41:32 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 15 Oct 2021 05:41:31 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH net-next 1/2] qed: Optimize the ll2 ooo flow
Date:   Fri, 15 Oct 2021 15:41:16 +0300
Message-ID: <20211015124118.29041-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: EJki38gKfoKPCV-bVjItLveXYzuMXZI2
X-Proofpoint-ORIG-GUID: EJki38gKfoKPCV-bVjItLveXYzuMXZI2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_04,2021-10-14_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize the ll2 TCP out-of-order likely flows:
- Optimize the non-error flows of the ll2 ooo data path.
- Optimize "QED_OOO_RIGHT_BUF" over "QED_OOO_LEFT_BUF".

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 63 ++++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_ooo.c | 20 +++----
 2 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 3fedcefc36d8..6068b0b94ea3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -378,7 +378,7 @@ static int qed_ll2_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 		num_bds_in_packet = p_pkt->bd_used;
 		list_del(&p_pkt->list_entry);
 
-		if (num_bds < num_bds_in_packet) {
+		if (unlikely(num_bds < num_bds_in_packet)) {
 			DP_NOTICE(p_hwfn,
 				  "Rest of BDs does not cover whole packet\n");
 			goto out;
@@ -488,7 +488,7 @@ qed_ll2_rxq_handle_completion(struct qed_hwfn *p_hwfn,
 	if (!list_empty(&p_rx->active_descq))
 		p_pkt = list_first_entry(&p_rx->active_descq,
 					 struct qed_ll2_rx_packet, list_entry);
-	if (!p_pkt) {
+	if (unlikely(!p_pkt)) {
 		DP_NOTICE(p_hwfn,
 			  "[%d] LL2 Rx completion but active_descq is empty\n",
 			  p_ll2_conn->input.conn_type);
@@ -501,7 +501,7 @@ qed_ll2_rxq_handle_completion(struct qed_hwfn *p_hwfn,
 		qed_ll2_rxq_parse_reg(p_hwfn, p_cqe, &data);
 	else
 		qed_ll2_rxq_parse_gsi(p_hwfn, p_cqe, &data);
-	if (qed_chain_consume(&p_rx->rxq_chain) != p_pkt->rxq_bd)
+	if (unlikely(qed_chain_consume(&p_rx->rxq_chain) != p_pkt->rxq_bd))
 		DP_NOTICE(p_hwfn,
 			  "Mismatch between active_descq and the LL2 Rx chain\n");
 
@@ -671,7 +671,7 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 							    &cqe->rx_cqe_sp))
 				continue;
 
-		if (cqe_type != CORE_RX_CQE_TYPE_REGULAR) {
+		if (unlikely(cqe_type != CORE_RX_CQE_TYPE_REGULAR)) {
 			DP_NOTICE(p_hwfn,
 				  "Got a non-regular LB LL2 completion [type 0x%02x]\n",
 				  cqe_type);
@@ -698,7 +698,7 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 			continue;
 
 		/* Now process create/add/join isles */
-		if (list_empty(&p_rx->active_descq)) {
+		if (unlikely(list_empty(&p_rx->active_descq))) {
 			DP_NOTICE(p_hwfn,
 				  "LL2 OOO RX chain has no submitted buffers\n"
 				  );
@@ -708,12 +708,12 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 		p_pkt = list_first_entry(&p_rx->active_descq,
 					 struct qed_ll2_rx_packet, list_entry);
 
-		if ((iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN) ||
-		    (iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN)) {
-			if (!p_pkt) {
+		if (likely(iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE ||
+			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT ||
+			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT ||
+			   iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN ||
+			   iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN)) {
+			if (unlikely(!p_pkt)) {
 				DP_NOTICE(p_hwfn,
 					  "LL2 OOO RX packet is not valid\n");
 				return -EIO;
@@ -885,16 +885,16 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	u16 new_idx = 0, num_bds = 0;
 	int rc;
 
-	if (!p_ll2_conn)
+	if (unlikely(!p_ll2_conn))
 		return 0;
 
-	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
+	if (unlikely(!QED_LL2_TX_REGISTERED(p_ll2_conn)))
 		return 0;
 
 	new_idx = le16_to_cpu(*p_tx->p_fw_cons);
 	num_bds = ((s16)new_idx - (s16)p_tx->bds_idx);
 
-	if (!num_bds)
+	if (unlikely(!num_bds))
 		return 0;
 
 	while (num_bds) {
@@ -903,10 +903,10 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 
 		p_pkt = list_first_entry(&p_tx->active_descq,
 					 struct qed_ll2_tx_packet, list_entry);
-		if (!p_pkt)
+		if (unlikely(!p_pkt))
 			return -EINVAL;
 
-		if (p_pkt->bd_used != 1) {
+		if (unlikely(p_pkt->bd_used != 1)) {
 			DP_NOTICE(p_hwfn,
 				  "Unexpectedly many BDs(%d) in TX OOO completion\n",
 				  p_pkt->bd_used);
@@ -1034,7 +1034,7 @@ static int qed_sp_ll2_tx_queue_start(struct qed_hwfn *p_hwfn,
 	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
 		return 0;
 
-	if (p_ll2_conn->input.conn_type == QED_LL2_TYPE_OOO)
+	if (likely(p_ll2_conn->input.conn_type == QED_LL2_TYPE_OOO))
 		p_ll2_conn->tx_stats_en = 0;
 	else
 		p_ll2_conn->tx_stats_en = 1;
@@ -1885,8 +1885,8 @@ qed_ll2_prepare_tx_packet_set_bd(struct qed_hwfn *p_hwfn,
 	}
 
 	start_bd = (struct core_tx_bd *)qed_chain_produce(p_tx_chain);
-	if (QED_IS_IWARP_PERSONALITY(p_hwfn) &&
-	    p_ll2->input.conn_type == QED_LL2_TYPE_OOO) {
+	if (likely(QED_IS_IWARP_PERSONALITY(p_hwfn) &&
+		   p_ll2->input.conn_type == QED_LL2_TYPE_OOO)) {
 		start_bd->nw_vlan_or_lb_echo =
 		    cpu_to_le16(IWARP_LL2_IN_ORDER_TX_QUEUE);
 	} else {
@@ -2007,28 +2007,29 @@ int qed_ll2_prepare_tx_packet(void *cxt,
 	int rc = 0;
 
 	p_ll2_conn = qed_ll2_handle_sanity(p_hwfn, connection_handle);
-	if (!p_ll2_conn)
+	if (unlikely(!p_ll2_conn))
 		return -EINVAL;
 	p_tx = &p_ll2_conn->tx_queue;
 	p_tx_chain = &p_tx->txq_chain;
 
-	if (pkt->num_of_bds > p_ll2_conn->input.tx_max_bds_per_packet)
+	if (unlikely(pkt->num_of_bds > p_ll2_conn->input.tx_max_bds_per_packet))
 		return -EIO;
 
 	spin_lock_irqsave(&p_tx->lock, flags);
-	if (p_tx->cur_send_packet) {
+	if (unlikely(p_tx->cur_send_packet)) {
 		rc = -EEXIST;
 		goto out;
 	}
 
 	/* Get entry, but only if we have tx elements for it */
-	if (!list_empty(&p_tx->free_descq))
+	if (unlikely(!list_empty(&p_tx->free_descq)))
 		p_curp = list_first_entry(&p_tx->free_descq,
 					  struct qed_ll2_tx_packet, list_entry);
-	if (p_curp && qed_chain_get_elem_left(p_tx_chain) < pkt->num_of_bds)
+	if (unlikely(p_curp &&
+		     qed_chain_get_elem_left(p_tx_chain) < pkt->num_of_bds))
 		p_curp = NULL;
 
-	if (!p_curp) {
+	if (unlikely(!p_curp)) {
 		rc = -EBUSY;
 		goto out;
 	}
@@ -2057,16 +2058,16 @@ int qed_ll2_set_fragment_of_tx_packet(void *cxt,
 	unsigned long flags;
 
 	p_ll2_conn = qed_ll2_handle_sanity(p_hwfn, connection_handle);
-	if (!p_ll2_conn)
+	if (unlikely(!p_ll2_conn))
 		return -EINVAL;
 
-	if (!p_ll2_conn->tx_queue.cur_send_packet)
+	if (unlikely(!p_ll2_conn->tx_queue.cur_send_packet))
 		return -EINVAL;
 
 	p_cur_send_packet = p_ll2_conn->tx_queue.cur_send_packet;
 	cur_send_frag_num = p_ll2_conn->tx_queue.cur_send_frag_num;
 
-	if (cur_send_frag_num >= p_cur_send_packet->bd_used)
+	if (unlikely(cur_send_frag_num >= p_cur_send_packet->bd_used))
 		return -EINVAL;
 
 	/* Fill the BD information, and possibly notify FW */
@@ -2693,7 +2694,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 	 */
 	nr_frags = skb_shinfo(skb)->nr_frags;
 
-	if (1 + nr_frags > CORE_LL2_TX_MAX_BDS_PER_PACKET) {
+	if (unlikely(1 + nr_frags > CORE_LL2_TX_MAX_BDS_PER_PACKET)) {
 		DP_ERR(cdev, "Cannot transmit a packet with %d fragments\n",
 		       1 + nr_frags);
 		return -EINVAL;
@@ -2735,7 +2736,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 	 */
 	rc = qed_ll2_prepare_tx_packet(p_hwfn, cdev->ll2->handle,
 				       &pkt, 1);
-	if (rc)
+	if (unlikely(rc))
 		goto err;
 
 	for (i = 0; i < nr_frags; i++) {
@@ -2759,7 +2760,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 		/* if failed not much to do here, partial packet has been posted
 		 * we can't free memory, will need to wait for completion
 		 */
-		if (rc)
+		if (unlikely(rc))
 			goto err2;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ooo.c b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
index b8c5641b29a8..5d725f59db24 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ooo.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ooo.c
@@ -26,12 +26,12 @@ static struct qed_ooo_archipelago
 	u32 idx = (cid & 0xffff) - p_ooo_info->cid_base;
 	struct qed_ooo_archipelago *p_archipelago;
 
-	if (idx >= p_ooo_info->max_num_archipelagos)
+	if (unlikely(idx >= p_ooo_info->max_num_archipelagos))
 		return NULL;
 
 	p_archipelago = &p_ooo_info->p_archipelagos_mem[idx];
 
-	if (list_empty(&p_archipelago->isles_list))
+	if (unlikely(list_empty(&p_archipelago->isles_list)))
 		return NULL;
 
 	return p_archipelago;
@@ -46,7 +46,7 @@ static struct qed_ooo_isle *qed_ooo_seek_isle(struct qed_hwfn *p_hwfn,
 	u8 the_num_of_isle = 1;
 
 	p_archipelago = qed_ooo_seek_archipelago(p_hwfn, p_ooo_info, cid);
-	if (!p_archipelago) {
+	if (unlikely(!p_archipelago)) {
 		DP_NOTICE(p_hwfn,
 			  "Connection %d is not found in OOO list\n", cid);
 		return NULL;
@@ -362,7 +362,7 @@ void qed_ooo_add_new_isle(struct qed_hwfn *p_hwfn,
 	if (ooo_isle > 1) {
 		p_prev_isle = qed_ooo_seek_isle(p_hwfn,
 						p_ooo_info, cid, ooo_isle - 1);
-		if (!p_prev_isle) {
+		if (unlikely(!p_prev_isle)) {
 			DP_NOTICE(p_hwfn,
 				  "Isle %d is not found(cid %d)\n",
 				  ooo_isle - 1, cid);
@@ -370,7 +370,7 @@ void qed_ooo_add_new_isle(struct qed_hwfn *p_hwfn,
 		}
 	}
 	p_archipelago = qed_ooo_seek_archipelago(p_hwfn, p_ooo_info, cid);
-	if (!p_archipelago && (ooo_isle != 1)) {
+	if (unlikely(!p_archipelago && ooo_isle != 1)) {
 		DP_NOTICE(p_hwfn,
 			  "Connection %d is not found in OOO list\n", cid);
 		return;
@@ -381,7 +381,7 @@ void qed_ooo_add_new_isle(struct qed_hwfn *p_hwfn,
 					  struct qed_ooo_isle, list_entry);
 
 		list_del(&p_isle->list_entry);
-		if (!list_empty(&p_isle->buffers_list)) {
+		if (unlikely(!list_empty(&p_isle->buffers_list))) {
 			DP_NOTICE(p_hwfn, "Free isle is not empty\n");
 			INIT_LIST_HEAD(&p_isle->buffers_list);
 		}
@@ -418,13 +418,13 @@ void qed_ooo_add_new_buffer(struct qed_hwfn *p_hwfn,
 	struct qed_ooo_isle *p_isle = NULL;
 
 	p_isle = qed_ooo_seek_isle(p_hwfn, p_ooo_info, cid, ooo_isle);
-	if (!p_isle) {
+	if (unlikely(!p_isle)) {
 		DP_NOTICE(p_hwfn,
 			  "Isle %d is not found(cid %d)\n", ooo_isle, cid);
 		return;
 	}
 
-	if (buffer_side == QED_OOO_LEFT_BUF)
+	if (unlikely(buffer_side == QED_OOO_LEFT_BUF))
 		list_add(&p_buffer->list_entry, &p_isle->buffers_list);
 	else
 		list_add_tail(&p_buffer->list_entry, &p_isle->buffers_list);
@@ -438,7 +438,7 @@ void qed_ooo_join_isles(struct qed_hwfn *p_hwfn,
 
 	p_right_isle = qed_ooo_seek_isle(p_hwfn, p_ooo_info, cid,
 					 left_isle + 1);
-	if (!p_right_isle) {
+	if (unlikely(!p_right_isle)) {
 		DP_NOTICE(p_hwfn,
 			  "Right isle %d is not found(cid %d)\n",
 			  left_isle + 1, cid);
@@ -450,7 +450,7 @@ void qed_ooo_join_isles(struct qed_hwfn *p_hwfn,
 	if (left_isle) {
 		p_left_isle = qed_ooo_seek_isle(p_hwfn, p_ooo_info, cid,
 						left_isle);
-		if (!p_left_isle) {
+		if (unlikely(!p_left_isle)) {
 			DP_NOTICE(p_hwfn,
 				  "Left isle %d is not found(cid %d)\n",
 				  left_isle, cid);
-- 
2.22.0

