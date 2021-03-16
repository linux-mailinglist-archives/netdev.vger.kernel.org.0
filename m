Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F385B33DCA2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhCPSfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:35:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1044 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240035AbhCPSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:34:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GIGx6A026702;
        Tue, 16 Mar 2021 11:34:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=e+zbY4od732AXWTaXqK6NEy9ir/8elZEaKsBmrscTik=;
 b=VoLhQ1cLMzh2na53Ewdk9yaT21wlFi4sv9yfS6godamLzornNn44Vn0q1yP14ufeqo+K
 /+0I/P7Js5t3pGVoW22iX12FBQokuv1HGbDpCMpSN//IoA5n1J0X5BqFAKZp0IwlPTEH
 Ryf6WOW7s+p7Ej1gzaIUkrK/Cif7TybrSBU48JDtQzSA/sjnSdr5/TsW21rpwjGXhm0O
 hnJrxgnO8zNnG+UZ+2llCK04Utpd8q1COawS7nlhAg427VRgGfsv0b3LKhX95dbWN43j
 wZK/1MdsK0q8sKQhfeY0fXRRNBbIOsEx6HGMZAuxfuxGFJKzaVyoXzwQ8an+bgFvloOn 4g== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqsg81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 11:34:29 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 14:34:28 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 14:34:28 -0400
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 0D8DD3F7041;
        Tue, 16 Mar 2021 11:34:28 -0700 (PDT)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH net 2/2] qede: fix memory allocation failures under heavy load
Date:   Tue, 16 Mar 2021 11:34:10 -0700
Message-ID: <1615919650-4262-3-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
References: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_06:2021-03-16,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when the system is heavily stressed, kernel get lots of memory
allocation failures which causes kernel panic, so enable proper
error handling during skb allocation

Fixes: 8a8633978b84 ("qede: Add build_skb() support.")
Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 8c47a9d2a965..f2d74b53e421 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -751,6 +751,8 @@ qede_build_skb(struct qede_rx_queue *rxq,
 
 	buf = page_address(bd->data) + bd->page_offset;
 	skb = build_skb(buf, rxq->rx_buf_seg_size);
+	if (unlikely(!skb))
+		return NULL;
 
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
@@ -767,6 +769,9 @@ qede_tpa_rx_build_skb(struct qede_dev *edev,
 	struct sk_buff *skb;
 
 	skb = qede_build_skb(rxq, bd, len, pad);
+	if (unlikely(!skb))
+		return NULL;
+
 	bd->page_offset += rxq->rx_buf_seg_size;
 
 	if (bd->page_offset == PAGE_SIZE) {
@@ -814,6 +819,8 @@ qede_rx_build_skb(struct qede_dev *edev,
 	}
 
 	skb = qede_build_skb(rxq, bd, len, pad);
+	if (unlikely(!skb))
+		return NULL;
 
 	if (unlikely(qede_realloc_rx_buffer(rxq, bd))) {
 		/* Incr page ref count to reuse on allocation failure so
@@ -851,11 +858,16 @@ static void qede_tpa_start(struct qede_dev *edev,
 	if (unlikely(!tpa_info->skb)) {
 		DP_NOTICE(edev, "Failed to allocate SKB for gro\n");
 
+		/* Re-use the buffer instantly instead doing it at tpa_end
+		 * as we are already going to throw away this aggregated packet
+		 * (i.e CQEs till tpa_end) and then going to update the
+		 * producer, so it's safe to pin the buffer here only.
+		 */
+		qede_reuse_page(rxq, sw_rx_data_cons);
 		/* Consume from ring but do not produce since
 		 * this might be used by FW still, it will be re-used
 		 * at TPA end.
 		 */
-		tpa_info->tpa_start_fail = true;
 		qede_rx_bd_ring_consume(rxq);
 		tpa_info->state = QEDE_AGG_STATE_ERROR;
 		goto cons_buf;
@@ -1025,11 +1037,6 @@ static int qede_tpa_end(struct qede_dev *edev,
 err:
 	tpa_info->state = QEDE_AGG_STATE_NONE;
 
-	if (tpa_info->tpa_start_fail) {
-		qede_reuse_page(rxq, &tpa_info->buffer);
-		tpa_info->tpa_start_fail = false;
-	}
-
 	dev_kfree_skb_any(tpa_info->skb);
 	tpa_info->skb = NULL;
 	return 0;
-- 
2.17.1

