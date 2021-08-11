Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914333E95EC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhHKQaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:30:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhHKQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:30:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BGGjYL010654;
        Wed, 11 Aug 2021 09:29:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ftxWIFFouAL26OQNZKsfHrFAzJ5LCVo9bfxEm7isRJY=;
 b=bjXuMnJGyer5eEEw/CiBdv/Xee1cO8P0b1X6g0T4u3N8+eny0QhtrnDCtCC5Jv4y7fT5
 TIxTlgbOObPRZpE+T4AexdfRZJB/mjY7DHROhWEMcIpa47/lf9Us+bio/nsKROtaE6IL
 a9+V8OJpGoX1FP44vnzqTJm3YL3U+cV2Qnwsb46np1+NyoCIjE9uc4es3mKrE1UU8TRX
 n1reO5CT2zNMGoHoWtuBVRUEJUXDAT+3U9Y1ISOJyc43rjzkPyzipw2sItX5goqlzpgl
 oJxMWJqA8BISUGUc/WhYIwwDMDSydVy2Fq8HQq0VsZgLsLnxRmfKFl5NirrJAC0IeXxI 3g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3acc8g9cam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 09:29:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 11 Aug
 2021 09:29:13 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 11 Aug 2021 09:29:12 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH] qed: qed ll2 race condition fixes
Date:   Wed, 11 Aug 2021 19:28:55 +0300
Message-ID: <20210811162855.6746-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: C9hYEgPPhsN7HqmpEPATU41dYU5l1B8V
X-Proofpoint-ORIG-GUID: C9hYEgPPhsN7HqmpEPATU41dYU5l1B8V
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_05:2021-08-11,2021-08-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoiding qed ll2 race condition and NULL pointer dereference as part
of the remove and recovery flows.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 02a4610d9330..927e163cc9d6 100644
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
+	if (p_rx->set_prod_addr == NULL)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
@@ -1742,7 +1762,7 @@ int qed_ll2_post_rx_buffer(void *cxt,
 		}
 	}
 
-	/* If we're lacking entires, let's try to flush buffers to FW */
+	/* If we're lacking entries, let's try to flush buffers to FW */
 	if (!p_curp || !p_curb) {
 		rc = -EBUSY;
 		p_curp = NULL;
@@ -2589,7 +2609,6 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 			DP_NOTICE(cdev, "Failed to add an LLH filter\n");
 			goto err3;
 		}
-
 	}
 
 	ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
-- 
2.22.0

