Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE274673EA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379595AbhLCJ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:05 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29086 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379576AbhLCJ3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:04 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J56mv6WWSz1DJKQ;
        Fri,  3 Dec 2021 17:22:55 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:39 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 01/11] net: hns3: optimize function hclge_cfg_common_loopback()
Date:   Fri, 3 Dec 2021 17:20:49 +0800
Message-ID: <20211203092059.24947-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

hclge_cfg_common_loopback() is a bit too long, so
encapsulate hclge_cfg_common_loopback_cmd_send() and
hclge_cfg_common_loopback_wait() two functions to
improve readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 62 +++++++++++++------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6d68cc23f1c0..5a5e74dfd0be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8000,16 +8000,13 @@ static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
-static int hclge_cfg_common_loopback(struct hclge_dev *hdev, bool en,
-				     enum hnae3_loop loop_mode)
+static int hclge_cfg_common_loopback_cmd_send(struct hclge_dev *hdev, bool en,
+					      enum hnae3_loop loop_mode)
 {
-#define HCLGE_COMMON_LB_RETRY_MS	10
-#define HCLGE_COMMON_LB_RETRY_NUM	100
-
 	struct hclge_common_lb_cmd *req;
 	struct hclge_desc desc;
-	int ret, i = 0;
 	u8 loop_mode_b;
+	int ret;
 
 	req = (struct hclge_common_lb_cmd *)desc.data;
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK, false);
@@ -8026,23 +8023,34 @@ static int hclge_cfg_common_loopback(struct hclge_dev *hdev, bool en,
 		break;
 	default:
 		dev_err(&hdev->pdev->dev,
-			"unsupported common loopback mode %d\n", loop_mode);
+			"unsupported loopback mode %d\n", loop_mode);
 		return -ENOTSUPP;
 	}
 
-	if (en) {
+	req->mask = loop_mode_b;
+	if (en)
 		req->enable = loop_mode_b;
-		req->mask = loop_mode_b;
-	} else {
-		req->mask = loop_mode_b;
-	}
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret) {
+	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"common loopback set fail, ret = %d\n", ret);
-		return ret;
-	}
+			"failed to send loopback cmd, loop_mode = %d, ret = %d\n",
+			loop_mode, ret);
+
+	return ret;
+}
+
+static int hclge_cfg_common_loopback_wait(struct hclge_dev *hdev)
+{
+#define HCLGE_COMMON_LB_RETRY_MS	10
+#define HCLGE_COMMON_LB_RETRY_NUM	100
+
+	struct hclge_common_lb_cmd *req;
+	struct hclge_desc desc;
+	u32 i = 0;
+	int ret;
+
+	req = (struct hclge_common_lb_cmd *)desc.data;
 
 	do {
 		msleep(HCLGE_COMMON_LB_RETRY_MS);
@@ -8051,20 +8059,34 @@ static int hclge_cfg_common_loopback(struct hclge_dev *hdev, bool en,
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"common loopback get, ret = %d\n", ret);
+				"failed to get loopback done status, ret = %d\n",
+				ret);
 			return ret;
 		}
 	} while (++i < HCLGE_COMMON_LB_RETRY_NUM &&
 		 !(req->result & HCLGE_CMD_COMMON_LB_DONE_B));
 
 	if (!(req->result & HCLGE_CMD_COMMON_LB_DONE_B)) {
-		dev_err(&hdev->pdev->dev, "common loopback set timeout\n");
+		dev_err(&hdev->pdev->dev, "wait loopback timeout\n");
 		return -EBUSY;
 	} else if (!(req->result & HCLGE_CMD_COMMON_LB_SUCCESS_B)) {
-		dev_err(&hdev->pdev->dev, "common loopback set failed in fw\n");
+		dev_err(&hdev->pdev->dev, "faile to do loopback test\n");
 		return -EIO;
 	}
-	return ret;
+
+	return 0;
+}
+
+static int hclge_cfg_common_loopback(struct hclge_dev *hdev, bool en,
+				     enum hnae3_loop loop_mode)
+{
+	int ret;
+
+	ret = hclge_cfg_common_loopback_cmd_send(hdev, en, loop_mode);
+	if (ret)
+		return ret;
+
+	return hclge_cfg_common_loopback_wait(hdev);
 }
 
 static int hclge_set_common_loopback(struct hclge_dev *hdev, bool en,
-- 
2.33.0

