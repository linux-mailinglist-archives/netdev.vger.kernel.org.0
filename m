Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC02C7045
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731486AbgK1Rzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 12:55:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8451 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731497AbgK1ENK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:13:10 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CjcxS4JFTzhhhN;
        Sat, 28 Nov 2020 11:51:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 11:51:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 7/7] net: hns3: keep MAC pause mode when multiple TCs are enabled
Date:   Sat, 28 Nov 2020 11:51:50 +0800
Message-ID: <1606535510-44346-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Bellow HNAE3_DEVICE_VERSION_V3, MAC pause mode just support one
TC, when enabled multiple TCs, force enable PFC mode.

HNAE3_DEVICE_VERSION_V3 can support MAC pause mode on multiple
TCs, so when enable multiple TCs, just keep MAC pause mode,
and enable PFC mode just according to the user settings.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 54767b0..b1026cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -715,7 +715,7 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_pfc_info_init(struct hclge_dev *hdev)
+static void hclge_update_fc_mode_by_dcb_flag(struct hclge_dev *hdev)
 {
 	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE)) {
 		if (hdev->fc_mode_last_time == HCLGE_FC_PFC)
@@ -733,6 +733,27 @@ static void hclge_pfc_info_init(struct hclge_dev *hdev)
 	}
 }
 
+static void hclge_update_fc_mode(struct hclge_dev *hdev)
+{
+	if (!hdev->tm_info.pfc_en) {
+		hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
+		return;
+	}
+
+	if (hdev->tm_info.fc_mode != HCLGE_FC_PFC) {
+		hdev->fc_mode_last_time = hdev->tm_info.fc_mode;
+		hdev->tm_info.fc_mode = HCLGE_FC_PFC;
+	}
+}
+
+static void hclge_pfc_info_init(struct hclge_dev *hdev)
+{
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		hclge_update_fc_mode(hdev);
+	else
+		hclge_update_fc_mode_by_dcb_flag(hdev);
+}
+
 static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 {
 	hclge_tm_pg_info_init(hdev);
-- 
2.7.4

