Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7AB30BE82
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhBBMo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:44:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12110 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbhBBMmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:42:10 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk49n4z162kP;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: add api capability bits for firmware
Date:   Tue, 2 Feb 2021 20:39:47 +0800
Message-ID: <1612269593-18691-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

To improve the compatibility of firmware for driver, help firmware
to deal with different api commands, add api capability bits when
initialization the command queue.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 10 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   |  6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 10 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h |  6 +++++-
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index b728be4..6546b47 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -363,6 +363,15 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
 }
 
+static __le32 hclge_build_api_caps(void)
+{
+	u32 api_caps = 0;
+
+	hnae3_set_bit(api_caps, HCLGE_API_CAP_FLEX_RSS_TBL_B, 1);
+
+	return cpu_to_le32(api_caps);
+}
+
 static enum hclge_cmd_status
 hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 {
@@ -373,6 +382,7 @@ hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_FW_VER, 1);
 	resp = (struct hclge_query_version_cmd *)desc.data;
+	resp->api_caps = hclge_build_api_caps();
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index f861bdb..9ceb059 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -386,11 +386,15 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
 };
 
+enum HCLGE_API_CAP_BITS {
+	HCLGE_API_CAP_FLEX_RSS_TBL_B,
+};
+
 #define HCLGE_QUERY_CAP_LENGTH		3
 struct hclge_query_version_cmd {
 	__le32 firmware;
 	__le32 hardware;
-	__le32 rsv;
+	__le32 api_caps;
 	__le32 caps[HCLGE_QUERY_CAP_LENGTH]; /* capabilities of device */
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index e04c0cf..0f93c2d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -342,6 +342,15 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 }
 
+static __le32 hclgevf_build_api_caps(void)
+{
+	u32 api_caps = 0;
+
+	hnae3_set_bit(api_caps, HCLGEVF_API_CAP_FLEX_RSS_TBL_B, 1);
+
+	return cpu_to_le32(api_caps);
+}
+
 static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -352,6 +361,7 @@ static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 	resp = (struct hclgevf_query_version_cmd *)desc.data;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_FW_VER, 1);
+	resp->api_caps = hclgevf_build_api_caps();
 	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
 		return status;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 82eed25..d591b33 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -161,11 +161,15 @@ enum HCLGEVF_CAP_BITS {
 	HCLGEVF_CAP_UDP_TUNNEL_CSUM_B,
 };
 
+enum HCLGEVF_API_CAP_BITS {
+	HCLGEVF_API_CAP_FLEX_RSS_TBL_B,
+};
+
 #define HCLGEVF_QUERY_CAP_LENGTH		3
 struct hclgevf_query_version_cmd {
 	__le32 firmware;
 	__le32 hardware;
-	__le32 rsv;
+	__le32 api_caps;
 	__le32 caps[HCLGEVF_QUERY_CAP_LENGTH]; /* capabilities of device */
 };
 
-- 
2.7.4

