Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A6B86FAA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405424AbfHICdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58998 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405045AbfHICdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1FE1CEC65638FE023AF5;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: modify how pause options is displayed
Date:   Fri, 9 Aug 2019 10:31:11 +0800
Message-ID: <1565317878-31806-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Currently, the pause options of HNS3 shown like this:
"RX/TX" is always the same with "RX negotiated/TX negotiated".
Because of the driver covered the value of "RX/TX" with the value
of "RX negotiated/TX negotiated" after adjust link.

This patch records the pause configurations of the user, and never
covered them in adjust link.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 38 ++++++++++++----------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c0feae3a..381f195 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8207,28 +8207,15 @@ static int hclge_cfg_pauseparam(struct hclge_dev *hdev, u32 rx_en, u32 tx_en)
 {
 	int ret;
 
-	if (rx_en && tx_en)
-		hdev->fc_mode_last_time = HCLGE_FC_FULL;
-	else if (rx_en && !tx_en)
-		hdev->fc_mode_last_time = HCLGE_FC_RX_PAUSE;
-	else if (!rx_en && tx_en)
-		hdev->fc_mode_last_time = HCLGE_FC_TX_PAUSE;
-	else
-		hdev->fc_mode_last_time = HCLGE_FC_NONE;
-
 	if (hdev->tm_info.fc_mode == HCLGE_FC_PFC)
 		return 0;
 
 	ret = hclge_mac_pause_en_cfg(hdev, tx_en, rx_en);
-	if (ret) {
-		dev_err(&hdev->pdev->dev, "configure pauseparam error, ret = %d.\n",
-			ret);
-		return ret;
-	}
-
-	hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"configure pauseparam error, ret = %d.\n", ret);
 
-	return 0;
+	return ret;
 }
 
 int hclge_cfg_flowctrl(struct hclge_dev *hdev)
@@ -8293,6 +8280,21 @@ static void hclge_get_pauseparam(struct hnae3_handle *handle, u32 *auto_neg,
 	}
 }
 
+static void hclge_record_user_pauseparam(struct hclge_dev *hdev,
+					 u32 rx_en, u32 tx_en)
+{
+	if (rx_en && tx_en)
+		hdev->fc_mode_last_time = HCLGE_FC_FULL;
+	else if (rx_en && !tx_en)
+		hdev->fc_mode_last_time = HCLGE_FC_RX_PAUSE;
+	else if (!rx_en && tx_en)
+		hdev->fc_mode_last_time = HCLGE_FC_TX_PAUSE;
+	else
+		hdev->fc_mode_last_time = HCLGE_FC_NONE;
+
+	hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
+}
+
 static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 				u32 rx_en, u32 tx_en)
 {
@@ -8318,6 +8320,8 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 
 	hclge_set_flowctrl_adv(hdev, rx_en, tx_en);
 
+	hclge_record_user_pauseparam(hdev, rx_en, tx_en);
+
 	if (!auto_neg)
 		return hclge_cfg_pauseparam(hdev, rx_en, tx_en);
 
-- 
2.7.4

