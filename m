Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6A3FA422
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhH1HAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9379 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhH1HAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxS5641GYz8vqq;
        Sat, 28 Aug 2021 14:55:06 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: add new function hclge_get_speed_bit()
Date:   Sat, 28 Aug 2021 14:55:18 +0800
Message-ID: <1630133721-9260-5-git-send-email-huangguangbin2@huawei.com>
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

Currently, function hclge_check_port_speed() uses switch/case statement
to get speed bit according to speed. To reuse this part of code and
improve code readability and maintainability, add a new function
hclge_get_speed_bit() to get speed bit according to map relationship
of speed and speed bit defined in array speed_bit_map.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 61 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  5 ++
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 750390c2533a..a1dcdf76fdfe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -993,44 +993,43 @@ static int hclge_parse_speed(u8 speed_cmd, u32 *speed)
 	return 0;
 }
 
+static const struct hclge_speed_bit_map speed_bit_map[] = {
+	{HCLGE_MAC_SPEED_10M, HCLGE_SUPPORT_10M_BIT},
+	{HCLGE_MAC_SPEED_100M, HCLGE_SUPPORT_100M_BIT},
+	{HCLGE_MAC_SPEED_1G, HCLGE_SUPPORT_1G_BIT},
+	{HCLGE_MAC_SPEED_10G, HCLGE_SUPPORT_10G_BIT},
+	{HCLGE_MAC_SPEED_25G, HCLGE_SUPPORT_25G_BIT},
+	{HCLGE_MAC_SPEED_40G, HCLGE_SUPPORT_40G_BIT},
+	{HCLGE_MAC_SPEED_50G, HCLGE_SUPPORT_50G_BIT},
+	{HCLGE_MAC_SPEED_100G, HCLGE_SUPPORT_100G_BIT},
+	{HCLGE_MAC_SPEED_200G, HCLGE_SUPPORT_200G_BIT},
+};
+
+static int hclge_get_speed_bit(u32 speed, u32 *speed_bit)
+{
+	u16 i;
+
+	for (i = 0; i < ARRAY_SIZE(speed_bit_map); i++) {
+		if (speed == speed_bit_map[i].speed) {
+			*speed_bit = speed_bit_map[i].speed_bit;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	u32 speed_ability = hdev->hw.mac.speed_ability;
 	u32 speed_bit = 0;
+	int ret;
 
-	switch (speed) {
-	case HCLGE_MAC_SPEED_10M:
-		speed_bit = HCLGE_SUPPORT_10M_BIT;
-		break;
-	case HCLGE_MAC_SPEED_100M:
-		speed_bit = HCLGE_SUPPORT_100M_BIT;
-		break;
-	case HCLGE_MAC_SPEED_1G:
-		speed_bit = HCLGE_SUPPORT_1G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_10G:
-		speed_bit = HCLGE_SUPPORT_10G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_25G:
-		speed_bit = HCLGE_SUPPORT_25G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_40G:
-		speed_bit = HCLGE_SUPPORT_40G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_50G:
-		speed_bit = HCLGE_SUPPORT_50G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_100G:
-		speed_bit = HCLGE_SUPPORT_100G_BIT;
-		break;
-	case HCLGE_MAC_SPEED_200G:
-		speed_bit = HCLGE_SUPPORT_200G_BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
+	ret = hclge_get_speed_bit(speed, &speed_bit);
+	if (ret)
+		return ret;
 
 	if (speed_bit & speed_ability)
 		return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9ca7bb26912a..de6afbcbfbac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1058,6 +1058,11 @@ struct hclge_vport {
 	struct list_head vlan_list;     /* Store VF vlan table */
 };
 
+struct hclge_speed_bit_map {
+	u32 speed;
+	u32 speed_bit;
+};
+
 int hclge_set_vport_promisc_mode(struct hclge_vport *vport, bool en_uc_pmc,
 				 bool en_mc_pmc, bool en_bc_pmc);
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
-- 
2.8.1

