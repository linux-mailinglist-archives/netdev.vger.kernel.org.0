Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2843880A
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJXJsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14852 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HcY3l2lvdz8yYh;
        Sun, 24 Oct 2021 17:40:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 2/8] net: hns3: modify mac statistics update process for compatibility
Date:   Sun, 24 Oct 2021 17:41:09 +0800
Message-ID: <20211024094115.42158-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After querying mac statistics from firmware, driver copies data from
descriptors to struct mac_stats of hdev, and the number of copied data
is just according to the register number queried from firmware. There is
a problem that if the register number queried from firmware is larger
than data number of struct mac_stats, it will cause a copy overflow.

So if the firmware adds more mac statistics in later version, it is not
compatible with driver of old version.

To fix this problem, the number of copied data needs to be used the
minimum value between the register number queried from firmware and
data number of struct mac_stats.

The first descriptor has three data and there is one reserved, to
optimize the copy process, add this reserverd data to struct mac_stats.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 90 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  5 +-
 2 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index be6f0a6229aa..a4e3349d2157 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -451,8 +451,9 @@ static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 	u64 *data = (u64 *)(&hdev->mac_stats);
 	struct hclge_desc desc[HCLGE_MAC_CMD_NUM];
 	__le64 *desc_data;
-	int i, k, n;
+	u32 data_size;
 	int ret;
+	u32 i;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_STATS_MAC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_MAC_CMD_NUM);
@@ -463,33 +464,36 @@ static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 		return ret;
 	}
 
-	for (i = 0; i < HCLGE_MAC_CMD_NUM; i++) {
-		/* for special opcode 0032, only the first desc has the head */
-		if (unlikely(i == 0)) {
-			desc_data = (__le64 *)(&desc[i].data[0]);
-			n = HCLGE_RD_FIRST_STATS_NUM;
-		} else {
-			desc_data = (__le64 *)(&desc[i]);
-			n = HCLGE_RD_OTHER_STATS_NUM;
-		}
+	/* The first desc has a 64-bit header, so data size need to minus 1 */
+	data_size = sizeof(desc) / (sizeof(u64)) - 1;
 
-		for (k = 0; k < n; k++) {
-			*data += le64_to_cpu(*desc_data);
-			data++;
-			desc_data++;
-		}
+	desc_data = (__le64 *)(&desc[0].data[0]);
+	for (i = 0; i < data_size; i++) {
+		/* data memory is continuous becase only the first desc has a
+		 * header in this command
+		 */
+		*data += le64_to_cpu(*desc_data);
+		data++;
+		desc_data++;
 	}
 
 	return 0;
 }
 
-static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 desc_num)
+static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 reg_num)
 {
+#define HCLGE_REG_NUM_PER_DESC		4
+
 	u64 *data = (u64 *)(&hdev->mac_stats);
 	struct hclge_desc *desc;
 	__le64 *desc_data;
-	u16 i, k, n;
+	u32 data_size;
+	u32 desc_num;
 	int ret;
+	u32 i;
+
+	/* The first desc has a 64-bit header, so need to consider it */
+	desc_num = reg_num / HCLGE_REG_NUM_PER_DESC + 1;
 
 	/* This may be called inside atomic sections,
 	 * so GFP_ATOMIC is more suitalbe here
@@ -505,21 +509,16 @@ static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 desc_num)
 		return ret;
 	}
 
-	for (i = 0; i < desc_num; i++) {
-		/* for special opcode 0034, only the first desc has the head */
-		if (i == 0) {
-			desc_data = (__le64 *)(&desc[i].data[0]);
-			n = HCLGE_RD_FIRST_STATS_NUM;
-		} else {
-			desc_data = (__le64 *)(&desc[i]);
-			n = HCLGE_RD_OTHER_STATS_NUM;
-		}
+	data_size = min_t(u32, sizeof(hdev->mac_stats) / sizeof(u64), reg_num);
 
-		for (k = 0; k < n; k++) {
-			*data += le64_to_cpu(*desc_data);
-			data++;
-			desc_data++;
-		}
+	desc_data = (__le64 *)(&desc[0].data[0]);
+	for (i = 0; i < data_size; i++) {
+		/* data memory is continuous becase only the first desc has a
+		 * header in this command
+		 */
+		*data += le64_to_cpu(*desc_data);
+		data++;
+		desc_data++;
 	}
 
 	kfree(desc);
@@ -527,40 +526,41 @@ static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 desc_num)
 	return 0;
 }
 
-static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *desc_num)
+static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *reg_num)
 {
 	struct hclge_desc desc;
-	__le32 *desc_data;
-	u32 reg_num;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_MAC_REG_NUM, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query mac statistic reg number, ret = %d\n",
+			ret);
 		return ret;
+	}
 
-	desc_data = (__le32 *)(&desc.data[0]);
-	reg_num = le32_to_cpu(*desc_data);
-
-	*desc_num = 1 + ((reg_num - 3) >> 2) +
-		    (u32)(((reg_num - 3) & 0x3) ? 1 : 0);
+	*reg_num = le32_to_cpu(desc.data[0]);
+	if (*reg_num == 0) {
+		dev_err(&hdev->pdev->dev,
+			"mac statistic reg number is invalid!\n");
+		return -ENODATA;
+	}
 
 	return 0;
 }
 
 static int hclge_mac_update_stats(struct hclge_dev *hdev)
 {
-	u32 desc_num;
+	u32 reg_num;
 	int ret;
 
-	ret = hclge_mac_query_reg_num(hdev, &desc_num);
+	ret = hclge_mac_query_reg_num(hdev, &reg_num);
 	/* The firmware supports the new statistics acquisition method */
 	if (!ret)
-		ret = hclge_mac_update_stats_complete(hdev, desc_num);
+		ret = hclge_mac_update_stats_complete(hdev, reg_num);
 	else if (ret == -EOPNOTSUPP)
 		ret = hclge_mac_update_stats_defective(hdev);
-	else
-		dev_err(&hdev->pdev->dev, "query mac reg num fail!\n");
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ca25e2edf3f0..36f1847b1c59 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -412,6 +412,7 @@ struct hclge_comm_stats_str {
 struct hclge_mac_stats {
 	u64 mac_tx_mac_pause_num;
 	u64 mac_rx_mac_pause_num;
+	u64 rsv0;
 	u64 mac_tx_pfc_pri0_pkt_num;
 	u64 mac_tx_pfc_pri1_pkt_num;
 	u64 mac_tx_pfc_pri2_pkt_num;
@@ -448,7 +449,7 @@ struct hclge_mac_stats {
 	u64 mac_tx_1519_2047_oct_pkt_num;
 	u64 mac_tx_2048_4095_oct_pkt_num;
 	u64 mac_tx_4096_8191_oct_pkt_num;
-	u64 rsv0;
+	u64 rsv1;
 	u64 mac_tx_8192_9216_oct_pkt_num;
 	u64 mac_tx_9217_12287_oct_pkt_num;
 	u64 mac_tx_12288_16383_oct_pkt_num;
@@ -475,7 +476,7 @@ struct hclge_mac_stats {
 	u64 mac_rx_1519_2047_oct_pkt_num;
 	u64 mac_rx_2048_4095_oct_pkt_num;
 	u64 mac_rx_4096_8191_oct_pkt_num;
-	u64 rsv1;
+	u64 rsv2;
 	u64 mac_rx_8192_9216_oct_pkt_num;
 	u64 mac_rx_9217_12287_oct_pkt_num;
 	u64 mac_rx_12288_16383_oct_pkt_num;
-- 
2.33.0

