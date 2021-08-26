Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C9E3F865E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbhHZL0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8777 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwL9n5VYwzYtrv;
        Thu, 26 Aug 2021 19:25:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 1/7] net: hns3: clear hardware resource when loading driver
Date:   Thu, 26 Aug 2021 19:21:55 +0800
Message-ID: <1629976921-43438-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

If a PF is bonded to a virtual machine and the virtual machine exits
unexpectedly, some hardware resource cannot be cleared. In this case,
loading driver may cause exceptions. Therefore, the hardware resource
needs to be cleared when the driver is loaded.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 26 ++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 18bde77ef944..d455d689d93a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -270,6 +270,9 @@ enum hclge_opcode_type {
 	/* Led command */
 	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
 
+	/* clear hardware resource command */
+	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
+
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ebeaf12e409b..ac88608a94b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11443,6 +11443,28 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 	}
 }
 
+static int hclge_clear_hw_resource(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CLEAR_HW_RESOURCE, false);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	/* This new command is only supported by new firmware, it will
+	 * fail with older firmware. Error value -EOPNOSUPP can only be
+	 * returned by older firmware running this command, to keep code
+	 * backward compatible we will override this value and return
+	 * success.
+	 */
+	if (ret && ret != -EOPNOTSUPP) {
+		dev_err(&hdev->pdev->dev,
+			"failed to clear hw resource, ret = %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
 static void hclge_init_rxd_adv_layout(struct hclge_dev *hdev)
 {
 	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
@@ -11492,6 +11514,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_cmd_uninit;
 
+	ret  = hclge_clear_hw_resource(hdev);
+	if (ret)
+		goto err_cmd_uninit;
+
 	ret = hclge_get_cap(hdev);
 	if (ret)
 		goto err_cmd_uninit;
-- 
2.8.1

