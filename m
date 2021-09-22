Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC84142CB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhIVHiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:38:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36060 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233059AbhIVHiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:38:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M7Xvls023412;
        Wed, 22 Sep 2021 00:36:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=H2h4i5QnywBiltIrM26U6RNn2J9IeFNTywYLGHiONy4=;
 b=lVQiW/oaFLzhz0MVFngax3yObf88ahpY7XbDeedjuPPvwRWt6bMMUqopy2XC9aIHz3fc
 UhoWFXbM/3L1x1Oom3qHrd9oujv8Ov+cX4Aaxx8KXzhbkAxDUgEBBrNX80FappGo5zRU
 X9L8JjefaWIpweow2KdkSqfrlVuOb2hWXk82a1gNJqih49mVwphGDF8eD1YAaH/7YQbe
 nxwSIZqYkjZVAsalX3T4ZDD+OcuX5iPNR9OAOJgb10pGSVsfx9gBLpMwpPd52vdmGskI
 TbDs59ZkgnCjMPi1tUw5i+vMHorl4xztYTqCEWRIPtIFnl8gkv3S/zyEJfFRymvZJSGr Cg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b7q5d9sju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 00:36:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 00:36:44 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 22 Sep 2021 00:36:42 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>,
        "Michal Kalderon" <mkalderon@marvell.com>
Subject: [PATCH net v2] qed: rdma - don't wait for resources under hw error recovery flow
Date:   Wed, 22 Sep 2021 10:36:31 +0300
Message-ID: <20210922073631.31626-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: dLvSkQoqfyvzDtggDSyahM_vhlaeEsRq
X-Proofpoint-ORIG-GUID: dLvSkQoqfyvzDtggDSyahM_vhlaeEsRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the HW device is during recovery, the HW resources will never return,
hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
This fix speeds up the error recovery flow.

Changes since v1:
- Fix race condition (thanks to Leon Romanovsky).

Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 8 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c  | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index fc8b3e64f153..186d0048a9d1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1297,6 +1297,14 @@ qed_iwarp_wait_cid_map_cleared(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap)
 	prev_weight = weight;
 
 	while (weight) {
+		/* If the HW device is during recovery, all resources are
+		 * immediately reset without receiving a per-cid indication
+		 * from HW. In this case we don't expect the cid_map to be
+		 * cleared.
+		 */
+		if (p_hwfn->cdev->recov_in_prog)
+			return 0;
+
 		msleep(QED_IWARP_MAX_CID_CLEAN_TIME);
 
 		weight = bitmap_weight(bmap->bitmap, bmap->max_count);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index f16a157bb95a..cf5baa5e59bc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -77,6 +77,14 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	 * Beyond the added delay we clear the bitmap anyway.
 	 */
 	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
+		/* If the HW device is during recovery, all resources are
+		 * immediately reset without receiving a per-cid indication
+		 * from HW. In this case we don't expect the cid bitmap to be
+		 * cleared.
+		 */
+		if (p_hwfn->cdev->recov_in_prog)
+			return;
+
 		msleep(100);
 		if (wait_count++ > 20) {
 			DP_NOTICE(p_hwfn, "cid bitmap wait timed out\n");
-- 
2.27.0

