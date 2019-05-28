Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B3D2C25F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfE1JEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:04:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17175 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727459AbfE1JEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:39 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4BBDEBBDC9C5E5778912;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: add support for dump firmware statistics by debugfs
Date:   Tue, 28 May 2019 17:02:53 +0800
Message-ID: <1559034182-24737-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongzhu Liu <liuzhongzhu@huawei.com>

This patch prints firmware statistics information.

debugfs command:
echo dump m7 info > cmd

estuary:/dbg/hns3/0000:7d:00.0$ echo dump m7 info > cmd
[  172.577240] hns3 0000:7d:00.0: 0x00000000  0x00000000  0x00000000
[  172.583471] hns3 0000:7d:00.0: 0x00000000  0x00000000  0x00000000
[  172.589552] hns3 0000:7d:00.0: 0x00000030  0x00000000  0x00000000
[  172.595632] hns3 0000:7d:00.0: 0x00000000  0x00000000  0x00000000
estuary:/dbg/hns3/0000:7d:00.0$

Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 57 ++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fc4917a..30354fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -252,6 +252,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 	dev_info(&h->pdev->dev, "dump mng tbl\n");
 	dev_info(&h->pdev->dev, "dump reset info\n");
+	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d79a209..61cb10d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -243,6 +243,9 @@ enum hclge_opcode_type {
 
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
+	/* M7 stats command */
+	HCLGE_OPC_M7_STATS_BD		= 0x7012,
+	HCLGE_OPC_M7_STATS_INFO		= 0x7013,
 
 	/* SFP command */
 	HCLGE_OPC_GET_SFP_INFO		= 0x7104,
@@ -970,6 +973,11 @@ struct hclge_fd_ad_config_cmd {
 	u8 rsv2[8];
 };
 
+struct hclge_get_m7_bd_cmd {
+	__le32 bd_num;
+	u8 rsv[20];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index a9ffb57..ed1f533 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -921,6 +921,61 @@ static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 		 hdev->rst_stats.reset_cnt);
 }
 
+void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
+{
+	struct hclge_desc *desc_src, *desc_tmp;
+	struct hclge_get_m7_bd_cmd *req;
+	struct hclge_desc desc;
+	u32 bd_num, buf_len;
+	int ret, i;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_M7_STATS_BD, true);
+
+	req = (struct hclge_get_m7_bd_cmd *)desc.data;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"get firmware statistics bd number failed, ret=%d\n",
+			ret);
+		return;
+	}
+
+	bd_num = le32_to_cpu(req->bd_num);
+
+	buf_len	 = sizeof(struct hclge_desc) * bd_num;
+	desc_src = kzalloc(buf_len, GFP_KERNEL);
+	if (!desc_src) {
+		dev_err(&hdev->pdev->dev,
+			"allocate desc for get_m7_stats failed\n");
+		return;
+	}
+
+	desc_tmp = desc_src;
+	ret  = hclge_dbg_cmd_send(hdev, desc_tmp, 0, bd_num,
+				  HCLGE_OPC_M7_STATS_INFO);
+	if (ret) {
+		kfree(desc_src);
+		dev_err(&hdev->pdev->dev,
+			"get firmware statistics failed, ret=%d\n", ret);
+		return;
+	}
+
+	for (i = 0; i < bd_num; i++) {
+		dev_info(&hdev->pdev->dev, "0x%08x  0x%08x  0x%08x\n",
+			 le32_to_cpu(desc_tmp->data[0]),
+			 le32_to_cpu(desc_tmp->data[1]),
+			 le32_to_cpu(desc_tmp->data[2]));
+		dev_info(&hdev->pdev->dev, "0x%08x  0x%08x  0x%08x\n",
+			 le32_to_cpu(desc_tmp->data[3]),
+			 le32_to_cpu(desc_tmp->data[4]),
+			 le32_to_cpu(desc_tmp->data[5]));
+
+		desc_tmp++;
+	}
+
+	kfree(desc_src);
+}
+
 /* hclge_dbg_dump_ncl_config: print specified range of NCL_CONFIG file
  * @hdev: pointer to struct hclge_dev
  * @cmd_buf: string that contains offset and length
@@ -1029,6 +1084,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hclge_dbg_dump_reg_cmd(hdev, cmd_buf);
 	} else if (strncmp(cmd_buf, "dump reset info", 15) == 0) {
 		hclge_dbg_dump_rst_info(hdev);
+	} else if (strncmp(cmd_buf, "dump m7 info", 12) == 0) {
+		hclge_dbg_get_m7_stats_info(hdev);
 	} else if (strncmp(cmd_buf, "dump ncl_config", 15) == 0) {
 		hclge_dbg_dump_ncl_config(hdev,
 					  &cmd_buf[sizeof("dump ncl_config")]);
-- 
2.7.4

