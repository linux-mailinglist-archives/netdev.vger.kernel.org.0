Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47A02AAFEE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgKIDWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7195 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbgKIDWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:49 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CTxBD4MZ8zkgLf;
        Mon,  9 Nov 2020 11:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 02/11] net: hns3: add support for querying maximum value of GL
Date:   Mon, 9 Nov 2020 11:22:30 +0800
Message-ID: <1604892159-19990-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For maintainability and compatibility, add support for querying
the maximum value of GL.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h           |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 14 ++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h    |  8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  6 ++++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h  |  8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |  6 ++++++
 8 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 912c51e..f9d4d23 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -278,6 +278,7 @@ struct hnae3_dev_specs {
 	u16 rss_ind_tbl_size;
 	u16 rss_key_size;
 	u16 int_ql_max; /* max value of interrupt coalesce based on INT_QL */
+	u16 max_int_gl; /* max value of interrupt coalesce based on INT_GL */
 	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index dc9a857..a5ebca8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -349,6 +349,7 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
 	dev_info(priv->dev, "Total number of enabled TCs: %u\n", kinfo->num_tc);
 	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
+	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 10990bd..be099dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -420,7 +420,6 @@ enum hns3_flow_level_range {
 	HNS3_FLOW_ULTRA = 3,
 };
 
-#define HNS3_INT_GL_MAX			0x1FE0
 #define HNS3_INT_GL_50K			0x0014
 #define HNS3_INT_GL_20K			0x0032
 #define HNS3_INT_GL_18K			0x0036
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 9af7cb9..9e90d67 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1130,19 +1130,21 @@ static int hns3_get_coalesce(struct net_device *netdev,
 static int hns3_check_gl_coalesce_para(struct net_device *netdev,
 				       struct ethtool_coalesce *cmd)
 {
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	u32 rx_gl, tx_gl;
 
-	if (cmd->rx_coalesce_usecs > HNS3_INT_GL_MAX) {
+	if (cmd->rx_coalesce_usecs > ae_dev->dev_specs.max_int_gl) {
 		netdev_err(netdev,
-			   "Invalid rx-usecs value, rx-usecs range is 0-%d\n",
-			   HNS3_INT_GL_MAX);
+			   "invalid rx-usecs value, rx-usecs range is 0-%u\n",
+			   ae_dev->dev_specs.max_int_gl);
 		return -EINVAL;
 	}
 
-	if (cmd->tx_coalesce_usecs > HNS3_INT_GL_MAX) {
+	if (cmd->tx_coalesce_usecs > ae_dev->dev_specs.max_int_gl) {
 		netdev_err(netdev,
-			   "Invalid tx-usecs value, tx-usecs range is 0-%d\n",
-			   HNS3_INT_GL_MAX);
+			   "invalid tx-usecs value, tx-usecs range is 0-%u\n",
+			   ae_dev->dev_specs.max_int_gl);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 096e26a..5b7967c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1103,6 +1103,14 @@ struct hclge_dev_specs_0_cmd {
 	__le32 max_tm_rate;
 };
 
+#define HCLGE_DEF_MAX_INT_GL		0x1FE0U
+
+struct hclge_dev_specs_1_cmd {
+	__le32 rsv0;
+	__le16 max_int_gl;
+	u8 rsv1[18];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8bcdb28..7102001 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1366,6 +1366,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
 	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
+	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1373,8 +1374,10 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_dev_specs_0_cmd *req0;
+	struct hclge_dev_specs_1_cmd *req1;
 
 	req0 = (struct hclge_dev_specs_0_cmd *)desc[0].data;
+	req1 = (struct hclge_dev_specs_1_cmd *)desc[1].data;
 
 	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
 	ae_dev->dev_specs.rss_ind_tbl_size =
@@ -1382,6 +1385,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
+	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
@@ -1396,6 +1400,8 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->rss_key_size = HCLGE_RSS_KEY_SIZE;
 	if (!dev_specs->max_tm_rate)
 		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
+	if (!dev_specs->max_int_gl)
+		dev_specs->max_int_gl = HCLGE_DEF_MAX_INT_GL;
 }
 
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 9460c12..f94f5d4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -285,6 +285,14 @@ struct hclgevf_dev_specs_0_cmd {
 	u8 rsv1[5];
 };
 
+#define HCLGEVF_DEF_MAX_INT_GL		0x1FE0U
+
+struct hclgevf_dev_specs_1_cmd {
+	__le32 rsv0;
+	__le16 max_int_gl;
+	u8 rsv1[18];
+};
+
 static inline void hclgevf_write_reg(void __iomem *base, u32 reg, u32 value)
 {
 	writel(value, base + reg);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8209be9..71007e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2991,6 +2991,7 @@ static void hclgevf_set_default_dev_specs(struct hclgevf_dev *hdev)
 					HCLGEVF_MAX_NON_TSO_BD_NUM;
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
 	ae_dev->dev_specs.rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+	ae_dev->dev_specs.max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
 }
 
 static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
@@ -2998,14 +2999,17 @@ static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_dev_specs_0_cmd *req0;
+	struct hclgevf_dev_specs_1_cmd *req1;
 
 	req0 = (struct hclgevf_dev_specs_0_cmd *)desc[0].data;
+	req1 = (struct hclgevf_dev_specs_1_cmd *)desc[1].data;
 
 	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
 	ae_dev->dev_specs.rss_ind_tbl_size =
 					le16_to_cpu(req0->rss_ind_tbl_size);
 	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
+	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
 }
 
 static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
@@ -3018,6 +3022,8 @@ static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
 		dev_specs->rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
 	if (!dev_specs->rss_key_size)
 		dev_specs->rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+	if (!dev_specs->max_int_gl)
+		dev_specs->max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
 }
 
 static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
-- 
2.7.4

