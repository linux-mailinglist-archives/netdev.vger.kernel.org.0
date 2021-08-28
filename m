Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC8E3FA423
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhH1HAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14430 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhH1HAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxS5P4qyDzbf10;
        Sat, 28 Aug 2021 14:55:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: refactor function hclgevf_parse_capability()
Date:   Sat, 28 Aug 2021 14:55:17 +0800
Message-ID: <1630133721-9260-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
References: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function hclgevf_parse_capability() will add more if statement in the
future, to improve code readability, maintainability and simplicity,
refactor this function by using a bit mapping array of IMP capabilities
and driver capabilities.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 27 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  6 +++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index d9ddb0a243d4..3c2600315f97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -342,25 +342,26 @@ static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
 	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 }
 
+const struct hclgevf_caps_bit_map hclgevf_cmd_caps_bit_map0[] = {
+	{HCLGEVF_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
+	{HCLGEVF_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
+	{HCLGEVF_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
+	{HCLGEVF_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
+	{HCLGEVF_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
+	{HCLGEVF_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
+};
+
 static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 				     struct hclgevf_query_version_cmd *cmd)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	u32 caps;
+	u32 caps, i;
 
 	caps = __le32_to_cpu(cmd->caps[0]);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_GSO_B))
-		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_INT_QL_B))
-		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_TQP_TXRX_INDEP_B))
-		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_HW_TX_CSUM_B))
-		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_TUNNEL_CSUM_B))
-		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGEVF_CAP_RXD_ADV_LAYOUT_B))
-		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
+	for (i = 0; i < ARRAY_SIZE(hclgevf_cmd_caps_bit_map0); i++)
+		if (hnae3_get_bit(caps, hclgevf_cmd_caps_bit_map0[i].imp_bit))
+			set_bit(hclgevf_cmd_caps_bit_map0[i].local_bit,
+				ae_dev->caps);
 }
 
 static __le32 hclgevf_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index f6d6502f0389..39d0b589c720 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -296,6 +296,12 @@ struct hclgevf_dev_specs_1_cmd {
 	u8 rsv1[18];
 };
 
+/* capabilities bits map between imp firmware and local driver */
+struct hclgevf_caps_bit_map {
+	u16 imp_bit;
+	u16 local_bit;
+};
+
 static inline void hclgevf_write_reg(void __iomem *base, u32 reg, u32 value)
 {
 	writel(value, base + reg);
-- 
2.8.1

