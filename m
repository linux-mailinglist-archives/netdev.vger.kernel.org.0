Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF1408AD1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 14:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbhIMMQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 08:16:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236646AbhIMMQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 08:16:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DBCZbM027773;
        Mon, 13 Sep 2021 05:14:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ZkYkSi87hsL+grghR6IhSwsdsAdctcJhvAJgiHkJ1eM=;
 b=JrPUk8r7ERubuIZnN00OcckKXz5cZaMFyV2O1jH3/DoZQl9qRU+BUQI2L8ffWbVS9pVv
 36IfxpHoDYX31oC+YcFh9CTJndYkkk/kcAWTtEyyvpTwyCM/Vejbo9m2ilAbhGVp8pCj
 8M8Vl0AAn0iSRD0yVahrFuPsKm5l1QNb9hWWhpDU/GwtBxm8/HlbZ8zqY2cTclzSSxYZ
 I1BPg2t1CUr9bdDrS9HmKpkBuoAj/O74qhd9cmrb0V2GWhKyznZ81i1KWnWDWRDI+V5G
 HRC0P0P0XQpjEgH9fHD7HHSdm5o3IARbGdPIy9dU0fojQWUed4XSN3Mm9aynBcgwsXVs KA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b25je85tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 05:14:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 05:14:55 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Mon, 13 Sep 2021 05:14:53 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <jgg@ziepe.ca>, <aelior@marvell.com>,
        <smalin@marvell.com>, <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: [PATCH net] qed: rdma - don't wait for resources under hw error recovery flow
Date:   Mon, 13 Sep 2021 15:14:42 +0300
Message-ID: <20210913121442.10189-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: U3ZYdH0xZRVdNC57Iu2hoQZR4aFO4fmu
X-Proofpoint-ORIG-GUID: U3ZYdH0xZRVdNC57Iu2hoQZR4aFO4fmu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_04,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the HW device is during recovery, the HW resources will never return,
hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
This fix speeds up the error recovery flow.

Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 7 +++++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c  | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index fc8b3e64f153..4967e383c31a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1323,6 +1323,13 @@ static int qed_iwarp_wait_for_all_cids(struct qed_hwfn *p_hwfn)
 	int rc;
 	int i;
 
+	/* If the HW device is during recovery, all resources are immediately
+	 * reset without receiving a per-cid indication from HW. In this case
+	 * we don't expect the cid_map to be cleared.
+	 */
+	if (p_hwfn->cdev->recov_in_prog)
+		return 0;
+
 	rc = qed_iwarp_wait_cid_map_cleared(p_hwfn,
 					    &p_hwfn->p_rdma_info->tcp_cid_map);
 	if (rc)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index f16a157bb95a..aff5a2871b8f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -71,6 +71,13 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	struct qed_bmap *rcid_map = &p_hwfn->p_rdma_info->real_cid_map;
 	int wait_count = 0;
 
+	/* If the HW device is during recovery, all resources are immediately
+	 * reset without receiving a per-cid indication from HW. In this case
+	 * we don't expect the cid bitmap to be cleared.
+	 */
+	if (p_hwfn->cdev->recov_in_prog)
+		return;
+
 	/* when destroying a_RoCE QP the control is returned to the user after
 	 * the synchronous part. The asynchronous part may take a little longer.
 	 * We delay for a short while if an async destroy QP is still expected.
-- 
2.22.0

