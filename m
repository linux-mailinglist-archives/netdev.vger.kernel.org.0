Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD3BA8873
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfIDOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:09:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730214AbfIDOJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:09:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A8923C5F11525DB5FF1D;
        Wed,  4 Sep 2019 22:09:13 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 22:09:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: disable loopback setting in hclge_mac_init
Date:   Wed, 4 Sep 2019 22:06:45 +0800
Message-ID: <1567606006-39598-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
References: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

If the selftest and reset are performed at the same time, the loopback
setting may be still in the enable state after the reset. As a result,
packets cannot be sent out.

This patch fixes this issue by disabling loopback in hclge_mac_init.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 34 +++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dde752f..8d4dc1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -66,6 +66,7 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev);
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle);
 static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 						   unsigned long *addr);
+static int hclge_set_default_loopback(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -2599,6 +2600,10 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 		return ret;
 	}
 
+	ret = hclge_set_default_loopback(hdev);
+	if (ret)
+		return ret;
+
 	ret = hclge_buffer_alloc(hdev);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
@@ -6331,7 +6336,7 @@ static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
-static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
+static int hclge_cfg_serdes_loopback(struct hclge_dev *hdev, bool en,
 				     enum hnae3_loop loop_mode)
 {
 #define HCLGE_SERDES_RETRY_MS	10
@@ -6392,6 +6397,17 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 		dev_err(&hdev->pdev->dev, "serdes loopback set failed in fw\n");
 		return -EIO;
 	}
+	return ret;
+}
+
+static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
+				     enum hnae3_loop loop_mode)
+{
+	int ret;
+
+	ret = hclge_cfg_serdes_loopback(hdev, en, loop_mode);
+	if (ret)
+		return ret;
 
 	hclge_cfg_mac_mode(hdev, en);
 
@@ -6535,6 +6551,22 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	return 0;
 }
 
+static int hclge_set_default_loopback(struct hclge_dev *hdev)
+{
+	int ret;
+
+	ret = hclge_set_app_loopback(hdev, false);
+	if (ret)
+		return ret;
+
+	ret = hclge_cfg_serdes_loopback(hdev, false, HNAE3_LOOP_SERIAL_SERDES);
+	if (ret)
+		return ret;
+
+	return hclge_cfg_serdes_loopback(hdev, false,
+					 HNAE3_LOOP_PARALLEL_SERDES);
+}
+
 static void hclge_reset_tqp_stats(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-- 
2.7.4

