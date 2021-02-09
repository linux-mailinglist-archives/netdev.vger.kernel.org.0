Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BB7314698
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhBICnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:43:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12874 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhBICnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:43:40 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DZRwp2Qx5z7jBq;
        Tue,  9 Feb 2021 10:41:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 10:42:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/11] net: hns3: clean up some incorrect variable types in hclge_dbg_dump_tm_map()
Date:   Tue, 9 Feb 2021 10:41:51 +0800
Message-ID: <1612838521-59915-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

queue_id, qset_id and other IDs are unsigned type, so modify
the corresponding local variables' type in hclge_dbg_dump_tm_map()
from signed to unsigned. kstrtouint() and the print format should
be updated as well.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 113efd4..a0a33c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -696,17 +696,16 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	u32 qset_mapping[HCLGE_BP_EXT_GRP_NUM];
 	struct hclge_qs_to_pri_link_cmd *map;
 	struct hclge_tqp_tx_queue_tc_cmd *tc;
+	u16 group_id, queue_id, qset_id;
 	enum hclge_opcode_type cmd;
+	u8 grp_num, pri_id, tc_id;
 	struct hclge_desc desc;
-	int queue_id, group_id;
-	int tc_id, qset_id;
-	int pri_id, ret;
 	u16 qs_id_l;
 	u16 qs_id_h;
-	u8 grp_num;
+	int ret;
 	u32 i;
 
-	ret = kstrtouint(cmd_buf, 0, &queue_id);
+	ret = kstrtou16(cmd_buf, 0, &queue_id);
 	queue_id = (ret != 0) ? 0 : queue_id;
 
 	cmd = HCLGE_OPC_TM_NQ_TO_QS_LINK;
@@ -754,7 +753,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	tc_id = tc->tc_id & 0x7;
 
 	dev_info(&hdev->pdev->dev, "queue_id | qset_id | pri_id | tc_id\n");
-	dev_info(&hdev->pdev->dev, "%04d     | %04d    | %02d     | %02d\n",
+	dev_info(&hdev->pdev->dev, "%04u     | %04u    | %02u     | %02u\n",
 		 queue_id, qset_id, pri_id, tc_id);
 
 	if (!hnae3_dev_dcb_supported(hdev)) {
-- 
2.7.4

