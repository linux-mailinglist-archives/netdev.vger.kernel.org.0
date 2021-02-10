Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4B316038
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhBJHpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:45:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12895 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbhBJHo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:44:58 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBZ010zDz7jRK;
        Wed, 10 Feb 2021 15:42:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:03 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/13] net: hns3: refactor out hclgevf_get_rss_tuple()
Date:   Wed, 10 Feb 2021 15:43:19 +0800
Message-ID: <1612943005-59416-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
References: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

To improve code readability and maintainability, separate
the flow type parsing part and the converting part from
bloated hclgevf_get_rss_tuple().

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 67 ++++++++++++++--------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ece3169..c4ac2b9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -954,56 +954,73 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	return 0;
 }
 
-static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
-				 struct ethtool_rxnfc *nfc)
+static int hclgevf_get_rss_tuple_by_flow_type(struct hclgevf_dev *hdev,
+					      int flow_type, u8 *tuple_sets)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	u8 tuple_sets;
-
-	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
-		return -EOPNOTSUPP;
-
-	nfc->data = 0;
-
-	switch (nfc->flow_type) {
+	switch (flow_type) {
 	case TCP_V4_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en;
 		break;
 	case UDP_V4_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv4_udp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en;
 		break;
 	case TCP_V6_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en;
 		break;
 	case UDP_V6_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv6_udp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en;
 		break;
 	case SCTP_V4_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en;
 		break;
 	case SCTP_V6_FLOW:
-		tuple_sets = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
+		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en;
 		break;
 	case IPV4_FLOW:
 	case IPV6_FLOW:
-		tuple_sets = HCLGEVF_S_IP_BIT | HCLGEVF_D_IP_BIT;
+		*tuple_sets = HCLGEVF_S_IP_BIT | HCLGEVF_D_IP_BIT;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (!tuple_sets)
-		return 0;
+	return 0;
+}
+
+static u64 hclgevf_convert_rss_tuple(u8 tuple_sets)
+{
+	u64 tuple_data = 0;
 
 	if (tuple_sets & HCLGEVF_D_PORT_BIT)
-		nfc->data |= RXH_L4_B_2_3;
+		tuple_data |= RXH_L4_B_2_3;
 	if (tuple_sets & HCLGEVF_S_PORT_BIT)
-		nfc->data |= RXH_L4_B_0_1;
+		tuple_data |= RXH_L4_B_0_1;
 	if (tuple_sets & HCLGEVF_D_IP_BIT)
-		nfc->data |= RXH_IP_DST;
+		tuple_data |= RXH_IP_DST;
 	if (tuple_sets & HCLGEVF_S_IP_BIT)
-		nfc->data |= RXH_IP_SRC;
+		tuple_data |= RXH_IP_SRC;
+
+	return tuple_data;
+}
+
+static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
+				 struct ethtool_rxnfc *nfc)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	u8 tuple_sets;
+	int ret;
+
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
+		return -EOPNOTSUPP;
+
+	nfc->data = 0;
+
+	ret = hclgevf_get_rss_tuple_by_flow_type(hdev, nfc->flow_type,
+						 &tuple_sets);
+	if (ret || !tuple_sets)
+		return ret;
+
+	nfc->data = hclgevf_convert_rss_tuple(tuple_sets);
 
 	return 0;
 }
-- 
2.7.4

