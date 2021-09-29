Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8056441C1CA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245270AbhI2JmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:42:12 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24123 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245103AbhI2Jlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKBCH1sxgz1DHPd;
        Wed, 29 Sep 2021 17:38:51 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 8/8] net: hns3: disable firmware compatible features when uninstall PF
Date:   Wed, 29 Sep 2021 17:35:56 +0800
Message-ID: <20210929093556.9146-9-huangguangbin2@huawei.com>
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

Currently, the firmware compatible features are enabled in PF driver
initialization process, but they are not disabled in PF driver
deinitialization process and firmware keeps these features in enabled
status.

In this case, if load an old PF driver (for example, in VM) which not
support the firmware compatible features, firmware will still send mailbox
message to PF when link status changed and PF will print
"un-supported mailbox message, code = 201".

To fix this problem, disable these firmware compatible features in PF
driver deinitialization process.

Fixes: ed8fb4b262ae ("net: hns3: add link change event report")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index ac9b69513332..9c2eeaa82294 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -467,7 +467,7 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 	return ret;
 }
 
-static int hclge_firmware_compat_config(struct hclge_dev *hdev)
+static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
 {
 	struct hclge_firmware_compat_cmd *req;
 	struct hclge_desc desc;
@@ -475,13 +475,16 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
 
-	req = (struct hclge_firmware_compat_cmd *)desc.data;
+	if (en) {
+		req = (struct hclge_firmware_compat_cmd *)desc.data;
 
-	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
-	hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
-	if (hnae3_dev_phy_imp_supported(hdev))
-		hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
-	req->compat = cpu_to_le32(compat);
+		hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
+		if (hnae3_dev_phy_imp_supported(hdev))
+			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
+
+		req->compat = cpu_to_le32(compat);
+	}
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
@@ -538,7 +541,7 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	/* ask the firmware to enable some features, driver can work without
 	 * it.
 	 */
-	ret = hclge_firmware_compat_config(hdev);
+	ret = hclge_firmware_compat_config(hdev, true);
 	if (ret)
 		dev_warn(&hdev->pdev->dev,
 			 "Firmware compatible features not enabled(%d).\n",
@@ -568,6 +571,8 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	hclge_firmware_compat_config(hdev, false);
+
 	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	/* wait to ensure that the firmware completes the possible left
 	 * over commands.
-- 
2.33.0

