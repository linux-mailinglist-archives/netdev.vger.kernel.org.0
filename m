Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3311F3EC8AE
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 13:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhHOLGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 07:06:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9620 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhHOLGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 07:06:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17F6lqYP030054;
        Sun, 15 Aug 2021 04:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=rZbWBLQy/lqzWKNOZE4mSTYWfcCCh3ed7BThzcKSGGo=;
 b=ffjzdfb7txwt8C4u2FFQDS4uaLSCs7LCMKOTlQ+F+2oDgp37CFUhV7sf1DiUpZ3zWuwt
 9Ds44I2Yi8mrblF+07SGr7SNjHrKC0m1uepNt/Y075I8NDbC/zWlJDRafGjMDS6kgFrk
 w8ROMeCorsOrxXnn3f7QznmyHD4z+ycOI3JoYPMT5v69Bs0X/I/RV6vp/fjCHAYFybnF
 vi7rOnYIyaI6YDq8IcUZw04BErAkt+ajdA3YyaUEskOJML9p7byu0Qh2PxTzaTEW3E1n
 WNinbHAwxkqETkLGyNlEURVO6gppInVvFNOWLo6O8zjqYBwwYPdF0RHDzECiDkn+frw+ iQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3aedbkj0f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Aug 2021 04:05:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 15 Aug
 2021 04:05:39 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 15 Aug 2021 04:05:37 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH v3] qed: qed ll2 race condition fixes
Date:   Sun, 15 Aug 2021 14:05:08 +0300
Message-ID: <20210815110508.19434-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0I1iKUKElZcQxG3nhpU_3zPgPxyqBlpD
X-Proofpoint-ORIG-GUID: 0I1iKUKElZcQxG3nhpU_3zPgPxyqBlpD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-15_03,2021-08-13_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoiding qed ll2 race condition and NULL pointer dereference as part
of the remove and recovery flows.

Changes form V1:
- Change (!p_rx->set_prod_addr).
- qed_ll2.c checkpatch fixes.

Change from V2:
- Revert "qed_ll2.c checkpatch fixes".

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 02a4610d9330..c46a7f756ed5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
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
 
@@ -1728,6 +1746,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
 	if (!p_ll2_conn)
 		return -EINVAL;
 	p_rx = &p_ll2_conn->rx_queue;
+	if (!p_rx->set_prod_addr)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
-- 
2.22.0

