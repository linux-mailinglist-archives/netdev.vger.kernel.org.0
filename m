Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4017B4BE
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCFC6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:58:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbgCFC6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 21:58:00 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 46AF96E88F00CB871696;
        Fri,  6 Mar 2020 10:57:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Mar 2020 10:57:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: print out command code when dump fails in debugfs
Date:   Fri, 6 Mar 2020 10:57:16 +0800
Message-ID: <1583463438-60953-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
References: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch adds a local variable to save the command code in
some dump cases which need to modify the command code, then
the failing command code can be print out for debugging.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 56 +++++++++++++---------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 5814f36..8ba6985 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -179,6 +179,7 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 {
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_dbg_bitmap_cmd *bitmap;
+	enum hclge_opcode_type cmd;
 	int rq_id, pri_id, qset_id;
 	int port_id, nq_id, pg_id;
 	struct hclge_desc desc[2];
@@ -193,10 +194,10 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 		return;
 	}
 
-	ret = hclge_dbg_cmd_send(hdev, desc, qset_id, 1,
-				 HCLGE_OPC_QSET_DFX_STS);
+	cmd = HCLGE_OPC_QSET_DFX_STS;
+	ret = hclge_dbg_cmd_send(hdev, desc, qset_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
 	dev_info(dev, "roce_qset_mask: 0x%x\n", bitmap->bit0);
@@ -204,48 +205,53 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 	dev_info(dev, "qs_shaping_pass: 0x%x\n", bitmap->bit2);
 	dev_info(dev, "qs_bp_sts: 0x%x\n", bitmap->bit3);
 
-	ret = hclge_dbg_cmd_send(hdev, desc, pri_id, 1, HCLGE_OPC_PRI_DFX_STS);
+	cmd = HCLGE_OPC_PRI_DFX_STS;
+	ret = hclge_dbg_cmd_send(hdev, desc, pri_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
 	dev_info(dev, "pri_mask: 0x%x\n", bitmap->bit0);
 	dev_info(dev, "pri_cshaping_pass: 0x%x\n", bitmap->bit1);
 	dev_info(dev, "pri_pshaping_pass: 0x%x\n", bitmap->bit2);
 
-	ret = hclge_dbg_cmd_send(hdev, desc, pg_id, 1, HCLGE_OPC_PG_DFX_STS);
+	cmd = HCLGE_OPC_PG_DFX_STS;
+	ret = hclge_dbg_cmd_send(hdev, desc, pg_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
 	dev_info(dev, "pg_mask: 0x%x\n", bitmap->bit0);
 	dev_info(dev, "pg_cshaping_pass: 0x%x\n", bitmap->bit1);
 	dev_info(dev, "pg_pshaping_pass: 0x%x\n", bitmap->bit2);
 
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
-				 HCLGE_OPC_PORT_DFX_STS);
+	cmd = HCLGE_OPC_PORT_DFX_STS;
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
 	dev_info(dev, "port_mask: 0x%x\n", bitmap->bit0);
 	dev_info(dev, "port_shaping_pass: 0x%x\n", bitmap->bit1);
 
-	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, HCLGE_OPC_SCH_NQ_CNT);
+	cmd = HCLGE_OPC_SCH_NQ_CNT;
+	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	dev_info(dev, "sch_nq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 
-	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, HCLGE_OPC_SCH_RQ_CNT);
+	cmd = HCLGE_OPC_SCH_RQ_CNT;
+	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	dev_info(dev, "sch_rq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 
-	ret = hclge_dbg_cmd_send(hdev, desc, 0, 2, HCLGE_OPC_TM_INTERNAL_STS);
+	cmd = HCLGE_OPC_TM_INTERNAL_STS;
+	ret = hclge_dbg_cmd_send(hdev, desc, 0, 2, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	dev_info(dev, "pri_bp: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 	dev_info(dev, "fifo_dfx_info: 0x%x\n", le32_to_cpu(desc[0].data[2]));
@@ -257,18 +263,18 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 	dev_info(dev, "SSU_TM_BYPASS_EN: 0x%x\n", le32_to_cpu(desc[1].data[0]));
 	dev_info(dev, "SSU_RESERVE_CFG: 0x%x\n", le32_to_cpu(desc[1].data[1]));
 
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
-				 HCLGE_OPC_TM_INTERNAL_CNT);
+	cmd = HCLGE_OPC_TM_INTERNAL_CNT;
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	dev_info(dev, "SCH_NIC_NUM: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 	dev_info(dev, "SCH_ROCE_NUM: 0x%x\n", le32_to_cpu(desc[0].data[2]));
 
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
-				 HCLGE_OPC_TM_INTERNAL_STS_1);
+	cmd = HCLGE_OPC_TM_INTERNAL_STS_1;
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
 	if (ret)
-		return;
+		goto err_dcb_cmd_send;
 
 	dev_info(dev, "TC_MAP_SEL: 0x%x\n", le32_to_cpu(desc[0].data[1]));
 	dev_info(dev, "IGU_PFC_PRI_EN: 0x%x\n", le32_to_cpu(desc[0].data[2]));
@@ -277,6 +283,12 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 		 le32_to_cpu(desc[0].data[4]));
 	dev_info(dev, "IGU_TX_PRI_MAP_TC_CFG: 0x%x\n",
 		 le32_to_cpu(desc[0].data[5]));
+	return;
+
+err_dcb_cmd_send:
+	dev_err(&hdev->pdev->dev,
+		"failed to dump dcb dfx, cmd = %#x, ret = %d\n",
+		cmd, ret);
 }
 
 static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
-- 
2.7.4

