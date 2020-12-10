Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70352D51CD
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgLJDo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:44:26 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9425 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbgLJDoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:44:12 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x65wXz7CBC;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: adjust rss indirection table configure command
Date:   Thu, 10 Dec 2020 11:42:11 +0800
Message-ID: <1607571732-24219-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

For the max rss size of PF may be up to 512, so adjust the
command of configuring rss indirection table to support
queue id larger than 255. The width of queue id is extended
from 8 bits to 10 bits. The high 2 bits are stored in filed
rss_qid_h when the queue id is larger than 255.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   |  7 +++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 20 ++++++++++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index f5a620c..a6c306b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -560,12 +560,15 @@ struct hclge_rss_input_tuple_cmd {
 };
 
 #define HCLGE_RSS_CFG_TBL_SIZE	16
+#define HCLGE_RSS_CFG_TBL_SIZE_H	4
+#define HCLGE_RSS_CFG_TBL_BW_H		2U
+#define HCLGE_RSS_CFG_TBL_BW_L		8U
 
 struct hclge_rss_indirection_table_cmd {
 	__le16 start_table_index;
 	__le16 rss_set_bitmap;
-	u8 rsv[4];
-	u8 rss_result[HCLGE_RSS_CFG_TBL_SIZE];
+	u8 rss_qid_h[HCLGE_RSS_CFG_TBL_SIZE_H];
+	u8 rss_qid_l[HCLGE_RSS_CFG_TBL_SIZE];
 };
 
 #define HCLGE_RSS_TC_OFFSET_S		0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f361226..5de45a9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4282,8 +4282,12 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 {
 	struct hclge_rss_indirection_table_cmd *req;
 	struct hclge_desc desc;
-	int i, j;
+	u8 rss_msb_oft;
+	u8 rss_msb_val;
 	int ret;
+	u16 qid;
+	int i;
+	u32 j;
 
 	req = (struct hclge_rss_indirection_table_cmd *)desc.data;
 
@@ -4294,11 +4298,15 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 		req->start_table_index =
 			cpu_to_le16(i * HCLGE_RSS_CFG_TBL_SIZE);
 		req->rss_set_bitmap = cpu_to_le16(HCLGE_RSS_SET_BITMAP_MSK);
-
-		for (j = 0; j < HCLGE_RSS_CFG_TBL_SIZE; j++)
-			req->rss_result[j] =
-				indir[i * HCLGE_RSS_CFG_TBL_SIZE + j];
-
+		for (j = 0; j < HCLGE_RSS_CFG_TBL_SIZE; j++) {
+			qid = indir[i * HCLGE_RSS_CFG_TBL_SIZE + j];
+			req->rss_qid_l[j] = qid & 0xff;
+			rss_msb_oft =
+				j * HCLGE_RSS_CFG_TBL_BW_H / BITS_PER_BYTE;
+			rss_msb_val = (qid >> HCLGE_RSS_CFG_TBL_BW_L & 0x1) <<
+				(j * HCLGE_RSS_CFG_TBL_BW_H % BITS_PER_BYTE);
+			req->rss_qid_h[rss_msb_oft] |= rss_msb_val;
+		}
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-- 
2.7.4

