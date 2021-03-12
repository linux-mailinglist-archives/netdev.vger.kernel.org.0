Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24023387E3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhCLIu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:50:27 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13152 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhCLItx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:49:53 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxfZr4JytzmWVR;
        Fri, 12 Mar 2021 16:47:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 16:49:40 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: add get/set pause parameters support for imp-controlled PHYs
Date:   Fri, 12 Mar 2021 16:50:14 +0800
Message-ID: <1615539016-45698-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
References: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

When the imp-controlled PHYs feature is enabled, phydev is NULL.
In this case, the autoneg is always off when user uses ethtool -a
command to get pause parameters because  hclge_get_pauseparam()
uses phydev to check whether device is TP port. To fit this new
feature, use media type to check whether device is TP port.

And when user set pause parameters, these parameters need to
always set to mac, no matter whether autoneg is off.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a39afcd..dbca489 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10158,9 +10158,10 @@ static void hclge_get_pauseparam(struct hnae3_handle *handle, u32 *auto_neg,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	struct phy_device *phydev = hdev->hw.mac.phydev;
+	u8 media_type = hdev->hw.mac.media_type;
 
-	*auto_neg = phydev ? hclge_get_autoneg(handle) : 0;
+	*auto_neg = (media_type == HNAE3_MEDIA_TYPE_COPPER) ?
+		    hclge_get_autoneg(handle) : 0;
 
 	if (hdev->tm_info.fc_mode == HCLGE_FC_PFC) {
 		*rx_en = 0;
@@ -10206,7 +10207,7 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	u32 fc_autoneg;
 
-	if (phydev) {
+	if (phydev || hnae3_dev_phy_imp_supported(hdev)) {
 		fc_autoneg = hclge_get_autoneg(handle);
 		if (auto_neg != fc_autoneg) {
 			dev_info(&hdev->pdev->dev,
@@ -10225,7 +10226,7 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 
 	hclge_record_user_pauseparam(hdev, rx_en, tx_en);
 
-	if (!auto_neg)
+	if (!auto_neg || hnae3_dev_phy_imp_supported(hdev))
 		return hclge_cfg_pauseparam(hdev, rx_en, tx_en);
 
 	if (phydev)
-- 
2.7.4

