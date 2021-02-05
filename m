Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6783106CB
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBEIeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:34:25 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12430 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhBEIeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:13 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vQ5WcCzjHFD;
        Fri,  5 Feb 2021 16:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 6/6] net: hns3: replace macro of max qset number with specification
Date:   Fri, 5 Feb 2021 16:32:49 +0800
Message-ID: <1612513969-9278-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
References: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The max qset number is a fixed value now and it is defined by a macro.
In order to support other value in different kinds of device, it is
better to use specification queried from firmware to replace macro.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c         | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h     | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 8 +++-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 2 ++
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ed41414..e20a1b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -285,6 +285,7 @@ struct hnae3_dev_specs {
 	u16 max_int_gl; /* max value of interrupt coalesce based on INT_GL */
 	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
 	u16 max_frm_size;
+	u16 max_qset_num;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index d88fc3c..36c7813 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -391,6 +391,7 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
 	dev_info(priv->dev, "MAX frame size: %u\n", dev_specs->max_frm_size);
 	dev_info(priv->dev, "MAX TM RATE: %uMbps\n", dev_specs->max_tm_rate);
+	dev_info(priv->dev, "MAX QSET number: %u\n", dev_specs->max_qset_num);
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 2ad05d6..e7c915e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1132,7 +1132,7 @@ struct hclge_dev_specs_0_cmd {
 
 struct hclge_dev_specs_1_cmd {
 	__le16 max_frm_size;
-	__le16 rsv0;
+	__le16 max_qset_num;
 	__le16 max_int_gl;
 	u8 rsv1[18];
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 8f3fefe..113efd4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1599,8 +1599,6 @@ static void hclge_dbg_dump_qs_shaper_all(struct hclge_dev *hdev)
 static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
 				     const char *cmd_buf)
 {
-#define HCLGE_MAX_QSET_NUM 1024
-
 	u16 qsid;
 	int ret;
 
@@ -1610,9 +1608,9 @@ static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
 		return;
 	}
 
-	if (qsid >= HCLGE_MAX_QSET_NUM) {
-		dev_err(&hdev->pdev->dev, "qsid(%u) out of range[0-1023]\n",
-			qsid);
+	if (qsid >= hdev->ae_dev->dev_specs.max_qset_num) {
+		dev_err(&hdev->pdev->dev, "qsid(%u) out of range[0-%u]\n",
+			qsid, hdev->ae_dev->dev_specs.max_qset_num - 1);
 		return;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1e1b9eb..f5a9884 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1372,6 +1372,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
 	ae_dev->dev_specs.max_frm_size = HCLGE_MAC_MAX_FRAME;
+	ae_dev->dev_specs.max_qset_num = HCLGE_MAX_QSET_NUM;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1390,6 +1391,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
+	ae_dev->dev_specs.max_qset_num = le16_to_cpu(req1->max_qset_num);
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
 	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
 }
@@ -1406,6 +1408,8 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->rss_key_size = HCLGE_RSS_KEY_SIZE;
 	if (!dev_specs->max_tm_rate)
 		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
+	if (!dev_specs->max_qset_num)
+		dev_specs->max_qset_num = HCLGE_MAX_QSET_NUM;
 	if (!dev_specs->max_int_gl)
 		dev_specs->max_int_gl = HCLGE_DEF_MAX_INT_GL;
 	if (!dev_specs->max_frm_size)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index a10a17c..33b17a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -148,6 +148,8 @@
 /* Factor used to calculate offset and bitmap of VF num */
 #define HCLGE_VF_NUM_PER_CMD           64
 
+#define HCLGE_MAX_QSET_NUM		1024
+
 enum HLCGE_PORT_TYPE {
 	HOST_PORT,
 	NETWORK_PORT
-- 
2.7.4

