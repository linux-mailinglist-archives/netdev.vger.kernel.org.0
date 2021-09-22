Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5713C4146FE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhIVKz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:55:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234760AbhIVKz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:55:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M6IRPq013649;
        Wed, 22 Sep 2021 03:53:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=HeLzvEv+OHXq6mfxXu9+zfgFI2D5BDVxLkosP+DdywY=;
 b=i14IIWdC2AKrx4PAdf08oP1RzXohRH1c6xdnlLpUdhugMKYPPkUXOceDW+iTLKfdAjg5
 q9Xd2GKBJkuo9GcIuU6T6A00AzslUlpbq0HCnYLhveXxGGFWB2YsK/1CS0HbWDdvLCpP
 +RrvPbXCQj/LAu/QoPa8gCuWkBP2BhZjPYjKgGGOZ9ZKrdFZbhUHSBXF3NJp5X/TcwGk
 d6f1/3oPSLx4yweyb5KXlwdNP3Fh8bvzsmCZWZrPRh3YGuRq/a4nss1Fl0lmpao1owxY
 X2SdxuklEjV5oMj5ViCRkHEMqqvyJKMmf27vr+50gHAUWpjHAREQNGOec6YkmB0Ac/JL pA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b7q5djduc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:53:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 03:53:51 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 22 Sep 2021 03:53:48 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>,
        "Michal Kalderon" <mkalderon@marvell.com>
Subject: [PATCH net v3] qed: rdma - don't wait for resources under hw error recovery flow
Date:   Wed, 22 Sep 2021 13:53:26 +0300
Message-ID: <20210922105326.10653-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: x0ATHPK60dcjE8UiX5bAH7RSlhbNTra-
X-Proofpoint-ORIG-GUID: x0ATHPK60dcjE8UiX5bAH7RSlhbNTra-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
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
Changes since v1:
- Fix race condition (thanks to Leon Romanovsky).

Changes since v2:
- Comment fix.
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

