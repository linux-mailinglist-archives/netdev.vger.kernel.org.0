Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6772A313146
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhBHLq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:46:57 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12589 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbhBHLlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:41:14 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT062cz165Ks;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: cleanup for endian issue for VF RSS
Date:   Mon, 8 Feb 2021 19:39:42 +0800
Message-ID: <1612784382-27262-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently the RSS commands of VF are using host byte order.
According to the user manual, it should use little endian in
the command to firmware. For the host and firmware are both
using little endian, so it can work well in this case.

Do cleanup to make it more explicitly.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h  |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 15 ++++++++++-----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 2a6aaff..8a37a22 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -216,8 +216,8 @@ struct hclgevf_rss_input_tuple_cmd {
 #define HCLGEVF_RSS_CFG_TBL_SIZE	16
 
 struct hclgevf_rss_indirection_table_cmd {
-	u16 start_table_index;
-	u16 rss_set_bitmap;
+	__le16 start_table_index;
+	__le16 rss_set_bitmap;
 	u8 rsv[4];
 	u8 rss_result[HCLGEVF_RSS_CFG_TBL_SIZE];
 };
@@ -229,7 +229,7 @@ struct hclgevf_rss_indirection_table_cmd {
 #define HCLGEVF_RSS_TC_VALID_B		15
 #define HCLGEVF_MAX_TC_NUM		8
 struct hclgevf_rss_tc_mode_cmd {
-	u16 rss_tc_mode[HCLGEVF_MAX_TC_NUM];
+	__le16 rss_tc_mode[HCLGEVF_MAX_TC_NUM];
 	u8 rsv[8];
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ab213ad..ece3169 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -658,8 +658,9 @@ static int hclgevf_set_rss_indir_table(struct hclgevf_dev *hdev)
 	for (i = 0; i < rss_cfg_tbl_num; i++) {
 		hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INDIR_TABLE,
 					     false);
-		req->start_table_index = i * HCLGEVF_RSS_CFG_TBL_SIZE;
-		req->rss_set_bitmap = HCLGEVF_RSS_SET_BITMAP_MSK;
+		req->start_table_index =
+			cpu_to_le16(i * HCLGEVF_RSS_CFG_TBL_SIZE);
+		req->rss_set_bitmap = cpu_to_le16(HCLGEVF_RSS_SET_BITMAP_MSK);
 		for (j = 0; j < HCLGEVF_RSS_CFG_TBL_SIZE; j++)
 			req->rss_result[j] =
 				indir[i * HCLGEVF_RSS_CFG_TBL_SIZE + j];
@@ -700,12 +701,16 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_TC_MODE, false);
 	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++) {
-		hnae3_set_bit(req->rss_tc_mode[i], HCLGEVF_RSS_TC_VALID_B,
+		u16 mode = 0;
+
+		hnae3_set_bit(mode, HCLGEVF_RSS_TC_VALID_B,
 			      (tc_valid[i] & 0x1));
-		hnae3_set_field(req->rss_tc_mode[i], HCLGEVF_RSS_TC_SIZE_M,
+		hnae3_set_field(mode, HCLGEVF_RSS_TC_SIZE_M,
 				HCLGEVF_RSS_TC_SIZE_S, tc_size[i]);
-		hnae3_set_field(req->rss_tc_mode[i], HCLGEVF_RSS_TC_OFFSET_M,
+		hnae3_set_field(mode, HCLGEVF_RSS_TC_OFFSET_M,
 				HCLGEVF_RSS_TC_OFFSET_S, tc_offset[i]);
+
+		req->rss_tc_mode[i] = cpu_to_le16(mode);
 	}
 	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
-- 
2.7.4

