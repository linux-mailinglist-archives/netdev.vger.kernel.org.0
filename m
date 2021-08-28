Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32453FA41D
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhH1HAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15222 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhH1HAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GxS986dlRz1DDCS;
        Sat, 28 Aug 2021 14:58:36 +0800 (CST)
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
Subject: [PATCH net-next 2/7] net: hns3: refactor function hclge_parse_capability()
Date:   Sat, 28 Aug 2021 14:55:16 +0800
Message-ID: <1630133721-9260-3-git-send-email-huangguangbin2@huawei.com>
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

The function hclge_parse_capability() uses too many if statement, and
it may add more in the future. To improve code readability, maintainability
and simplicity, refactor this function by using a bit mapping array of IMP
capabilities and driver capabilities.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 51 ++++++++++------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  6 +++
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 444c46241afc..474c6d1664e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -362,41 +362,34 @@ static void hclge_set_default_capability(struct hclge_dev *hdev)
 	}
 }
 
+const struct hclge_caps_bit_map hclge_cmd_caps_bit_map0[] = {
+	{HCLGE_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
+	{HCLGE_CAP_PTP_B, HNAE3_DEV_SUPPORT_PTP_B},
+	{HCLGE_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
+	{HCLGE_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
+	{HCLGE_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
+	{HCLGE_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
+	{HCLGE_CAP_FD_FORWARD_TC_B, HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B},
+	{HCLGE_CAP_FEC_B, HNAE3_DEV_SUPPORT_FEC_B},
+	{HCLGE_CAP_PAUSE_B, HNAE3_DEV_SUPPORT_PAUSE_B},
+	{HCLGE_CAP_PHY_IMP_B, HNAE3_DEV_SUPPORT_PHY_IMP_B},
+	{HCLGE_CAP_RAS_IMP_B, HNAE3_DEV_SUPPORT_RAS_IMP_B},
+	{HCLGE_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
+	{HCLGE_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B},
+	{HCLGE_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B},
+};
+
 static void hclge_parse_capability(struct hclge_dev *hdev,
 				   struct hclge_query_version_cmd *cmd)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	u32 caps;
+	u32 caps, i;
 
 	caps = __le32_to_cpu(cmd->caps[0]);
-	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_GSO_B))
-		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_PTP_B))
-		set_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_INT_QL_B))
-		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_TQP_TXRX_INDEP_B))
-		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_HW_TX_CSUM_B))
-		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_TUNNEL_CSUM_B))
-		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_FD_FORWARD_TC_B))
-		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_FEC_B))
-		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_PAUSE_B))
-		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_PHY_IMP_B))
-		set_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_RAS_IMP_B))
-		set_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_RXD_ADV_LAYOUT_B))
-		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
-	if (hnae3_get_bit(caps, HCLGE_CAP_PORT_VLAN_BYPASS_B)) {
-		set_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, ae_dev->caps);
-		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
-	}
+	for (i = 0; i < ARRAY_SIZE(hclge_cmd_caps_bit_map0); i++)
+		if (hnae3_get_bit(caps, hclge_cmd_caps_bit_map0[i].imp_bit))
+			set_bit(hclge_cmd_caps_bit_map0[i].local_bit,
+				ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index afca9ee9ca4f..0583e88d31d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1234,6 +1234,12 @@ struct hclge_phy_reg_cmd {
 	u8 rsv1[18];
 };
 
+/* capabilities bits map between imp firmware and local driver */
+struct hclge_caps_bit_map {
+	u16 imp_bit;
+	u16 local_bit;
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
-- 
2.8.1

