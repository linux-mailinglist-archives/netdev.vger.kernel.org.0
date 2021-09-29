Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6ED41C1C8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245239AbhI2JmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:42:10 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23233 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245091AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKBCm6LMvz8tY2;
        Wed, 29 Sep 2021 17:39:16 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 4/8] net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
Date:   Wed, 29 Sep 2021 17:35:52 +0800
Message-ID: <20210929093556.9146-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

HCLGE_FLAG_MQPRIO_ENABLE is supposed to set when enable
multiple TCs with tc mqprio, and HCLGE_FLAG_DCB_ENABLE is
supposed to set when enable multiple TCs with ets. But
the driver mixed the flags when updating the tm configuration.

Furtherly, PFC should be available when HCLGE_FLAG_MQPRIO_ENABLE
too, so remove the unnecessary limitation.

Fixes: 5a5c90917467 ("net: hns3: add support for tc mqprio offload")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  7 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 31 +++----------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 351b8f179a29..307c9e830510 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -247,6 +247,10 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	}
 
 	hclge_tm_schd_info_update(hdev, num_tc);
+	if (num_tc > 1)
+		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
+	else
+		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 
 	ret = hclge_ieee_ets_to_tm_info(hdev, ets);
 	if (ret)
@@ -306,8 +310,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u8 i, j, pfc_map, *prio_tc;
 	int ret;
 
-	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE) ||
-	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
+	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
 	if (pfc->pfc_en == hdev->tm_info.pfc_en)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 6f5035a788c0..f314dbd3ce11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -727,14 +727,6 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
 		hdev->tm_info.prio_tc[i] =
 			(i >= hdev->tm_info.num_tc) ? 0 : i;
-
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
 }
 
 static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
@@ -765,10 +757,10 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 
 static void hclge_update_fc_mode_by_dcb_flag(struct hclge_dev *hdev)
 {
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE)) {
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en) {
 		if (hdev->fc_mode_last_time == HCLGE_FC_PFC)
 			dev_warn(&hdev->pdev->dev,
-				 "DCB is disable, but last mode is FC_PFC\n");
+				 "Only 1 tc used, but last mode is FC_PFC\n");
 
 		hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
 	} else if (hdev->tm_info.fc_mode != HCLGE_FC_PFC) {
@@ -794,7 +786,7 @@ static void hclge_update_fc_mode(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_pfc_info_init(struct hclge_dev *hdev)
+void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
 {
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		hclge_update_fc_mode(hdev);
@@ -810,7 +802,7 @@ static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 
 	hclge_tm_vport_info_update(hdev);
 
-	hclge_pfc_info_init(hdev);
+	hclge_tm_pfc_info_update(hdev);
 }
 
 static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
@@ -1556,19 +1548,6 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
 	hclge_tm_schd_info_init(hdev);
 }
 
-void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
-{
-	/* DCB is enabled if we have more than 1 TC or pfc_en is
-	 * non-zero.
-	 */
-	if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
-		hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
-	else
-		hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
-
-	hclge_pfc_info_init(hdev);
-}
-
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init)
 {
 	int ret;
@@ -1614,7 +1593,7 @@ int hclge_tm_vport_map_update(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE))
+	if (hdev->tm_info.num_tc == 1 && !hdev->tm_info.pfc_en)
 		return 0;
 
 	return hclge_tm_bp_setup(hdev);
-- 
2.33.0

