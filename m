Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823434C259
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhC2D7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15029 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhC2D6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zJH2zY0zNqyW;
        Mon, 29 Mar 2021 11:55:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/9] net: hns3: remediate a potential overflow risk of bd_num_list
Date:   Mon, 29 Mar 2021 11:57:47 +0800
Message-ID: <1616990273-46426-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The array size of bd_num_list is a fixed value, it may have potential
overflow risk when array size of hclge_dfx_bd_offset_list is greater
than that fixed value. So modify bd_num_list as a pointer and allocate
memory for it according to array size of hclge_dfx_bd_offset_list.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 27 ++++++++++++++++------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 042dfd8..5ec4be7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11930,7 +11930,6 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 #define REG_LEN_PER_LINE	(REG_NUM_PER_LINE * sizeof(u32))
 #define REG_SEPARATOR_LINE	1
 #define REG_NUM_REMAIN_MASK	3
-#define BD_LIST_MAX_NUM		30
 
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 {
@@ -12024,15 +12023,19 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
 	int data_len_per_desc, bd_num, i;
-	int bd_num_list[BD_LIST_MAX_NUM];
+	int *bd_num_list;
 	u32 data_len;
 	int ret;
 
+	bd_num_list = kcalloc(dfx_reg_type_num, sizeof(int), GFP_KERNEL);
+	if (!bd_num_list)
+		return -ENOMEM;
+
 	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get dfx reg bd num fail, status is %d.\n", ret);
-		return ret;
+		goto out;
 	}
 
 	data_len_per_desc = sizeof_field(struct hclge_desc, data);
@@ -12043,6 +12046,8 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 		*len += (data_len / REG_LEN_PER_LINE + 1) * REG_LEN_PER_LINE;
 	}
 
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
@@ -12050,16 +12055,20 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
 	int bd_num, bd_num_max, buf_len, i;
-	int bd_num_list[BD_LIST_MAX_NUM];
 	struct hclge_desc *desc_src;
+	int *bd_num_list;
 	u32 *reg = data;
 	int ret;
 
+	bd_num_list = kcalloc(dfx_reg_type_num, sizeof(int), GFP_KERNEL);
+	if (!bd_num_list)
+		return -ENOMEM;
+
 	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get dfx reg bd num fail, status is %d.\n", ret);
-		return ret;
+		goto out;
 	}
 
 	bd_num_max = bd_num_list[0];
@@ -12068,8 +12077,10 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 
 	buf_len = sizeof(*desc_src) * bd_num_max;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
-	if (!desc_src)
-		return -ENOMEM;
+	if (!desc_src) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < dfx_reg_type_num; i++) {
 		bd_num = bd_num_list[i];
@@ -12085,6 +12096,8 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 	}
 
 	kfree(desc_src);
+out:
+	kfree(bd_num_list);
 	return ret;
 }
 
-- 
2.7.4

