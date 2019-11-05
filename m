Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E01EF52B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbfKEFwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:52:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54284 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387555AbfKEFwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:52:16 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA55noBZ019326;
        Mon, 4 Nov 2019 21:52:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=r8rqjkDk9Xs3X5i+DwoLFU84Pty0tEgaRM/HXaB88t4=;
 b=ppkKyySL29Rp4N+quC8c1Fxmzu+xfdZ5kHtbWDgAxE4USqebgyOLBmneF6jgvRbFAuoT
 ZtdlN3Eg2dFhRE5YATvWiYVevRxhTb4+1j6WBfqhEdSaSWL+hFZpN+bdV4OPG9tO3L9C
 ezPtofWUa6EfDATkZNImolepMaSr1JFul/jZqS7OW+gqcTS7EGVHie63P4451dO/1vFp
 bDkHVpIkeYTiWzlRv9E1SmnXG/9l01/s+acj9GU39NvXg4GZOGqykh4w5n2FEI5145UN
 jv4pAvFU1KpnKforEPwer6FfH67sl1WocORSi4IbyJKesUTJ4aIZiUiiHn3myZKGuFYV mg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n91equ-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 21:52:14 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 21:52:13 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 4 Nov 2019 21:52:13 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C7C173F7040;
        Mon,  4 Nov 2019 21:52:13 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA55qDkQ030062;
        Mon, 4 Nov 2019 21:52:13 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA55qDg6030061;
        Mon, 4 Nov 2019 21:52:13 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mrangankar@marvell.com>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 3/4] bnx2x: Fix PF-VF communication over multi-cos queues.
Date:   Mon, 4 Nov 2019 21:51:11 -0800
Message-ID: <20191105055112.30005-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105055112.30005-1-skalluru@marvell.com>
References: <20191105055112.30005-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_01:2019-11-04,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

PF driver doesn't enable tx-switching for all cos queues/clients,
which causes packets drop from PF to VF. Fix this by enabling
tx-switching on all cos queues/clients.

Signed-off-by: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 0edbb0a..5097a44 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -2397,15 +2397,21 @@ static int bnx2x_set_pf_tx_switching(struct bnx2x *bp, bool enable)
 	/* send the ramrod on all the queues of the PF */
 	for_each_eth_queue(bp, i) {
 		struct bnx2x_fastpath *fp = &bp->fp[i];
+		int tx_idx;
 
 		/* Set the appropriate Queue object */
 		q_params.q_obj = &bnx2x_sp_obj(bp, fp).q_obj;
 
-		/* Update the Queue state */
-		rc = bnx2x_queue_state_change(bp, &q_params);
-		if (rc) {
-			BNX2X_ERR("Failed to configure Tx switching\n");
-			return rc;
+		for (tx_idx = FIRST_TX_COS_INDEX;
+		     tx_idx < fp->max_cos; tx_idx++) {
+			q_params.params.update.cid_index = tx_idx;
+
+			/* Update the Queue state */
+			rc = bnx2x_queue_state_change(bp, &q_params);
+			if (rc) {
+				BNX2X_ERR("Failed to configure Tx switching\n");
+				return rc;
+			}
 		}
 	}
 
-- 
1.8.3.1

