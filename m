Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58D357AD5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhDHDkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:40:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16030 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhDHDkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:40:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG6QH6cTFzNtq3;
        Thu,  8 Apr 2021 11:37:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 11:39:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/2] net: hns3: change flr_prepare/flr_done function names
Date:   Thu, 8 Apr 2021 11:40:04 +0800
Message-ID: <1617853205-32760-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
References: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

The flr_prepare/flr_done functions are not only used in the FLR scenario,
but also used in the suspend/resume.

Change the function names to prepare_for_reset/rebuild_for_reset, change
the flr_prepare/flr_done to reset_prepare/reset_done in hnae3_ae_ops.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 +++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 27 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 27 ++++++++++++----------
 4 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a234116..1d21890 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -474,8 +474,9 @@ struct hnae3_ae_dev {
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
 	void (*uninit_ae_dev)(struct hnae3_ae_dev *ae_dev);
-	void (*flr_prepare)(struct hnae3_ae_dev *ae_dev);
-	void (*flr_done)(struct hnae3_ae_dev *ae_dev);
+	void (*reset_prepare)(struct hnae3_ae_dev *ae_dev,
+			      enum hnae3_reset_type rst_type);
+	void (*reset_done)(struct hnae3_ae_dev *ae_dev);
 	int (*init_client_instance)(struct hnae3_client *client,
 				    struct hnae3_ae_dev *ae_dev);
 	void (*uninit_client_instance)(struct hnae3_client *client,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 076bfb7..67fc5aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2423,8 +2423,8 @@ static void hns3_reset_prepare(struct pci_dev *pdev)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 
 	dev_info(&pdev->dev, "FLR prepare\n");
-	if (ae_dev && ae_dev->ops && ae_dev->ops->flr_prepare)
-		ae_dev->ops->flr_prepare(ae_dev);
+	if (ae_dev && ae_dev->ops && ae_dev->ops->reset_prepare)
+		ae_dev->ops->reset_prepare(ae_dev, HNAE3_FLR_RESET);
 }
 
 static void hns3_reset_done(struct pci_dev *pdev)
@@ -2432,8 +2432,8 @@ static void hns3_reset_done(struct pci_dev *pdev)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 
 	dev_info(&pdev->dev, "FLR done\n");
-	if (ae_dev && ae_dev->ops && ae_dev->ops->flr_done)
-		ae_dev->ops->flr_done(ae_dev);
+	if (ae_dev && ae_dev->ops && ae_dev->ops->reset_done)
+		ae_dev->ops->reset_done(ae_dev);
 }
 
 static const struct pci_error_handlers hns3_err_handler = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bc805d5..47c95dc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11058,10 +11058,11 @@ static void hclge_state_uninit(struct hclge_dev *hdev)
 		cancel_delayed_work_sync(&hdev->service_task);
 }
 
-static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
+static void hclge_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
+					enum hnae3_reset_type rst_type)
 {
-#define HCLGE_FLR_RETRY_WAIT_MS	500
-#define HCLGE_FLR_RETRY_CNT	5
+#define HCLGE_RESET_RETRY_WAIT_MS	500
+#define HCLGE_RESET_RETRY_CNT	5
 
 	struct hclge_dev *hdev = ae_dev->priv;
 	int retry_cnt = 0;
@@ -11070,30 +11071,32 @@ static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
 retry:
 	down(&hdev->reset_sem);
 	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
-	hdev->reset_type = HNAE3_FLR_RESET;
+	hdev->reset_type = rst_type;
 	ret = hclge_reset_prepare(hdev);
 	if (ret || hdev->reset_pending) {
-		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
+		dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
 			ret);
 		if (hdev->reset_pending ||
-		    retry_cnt++ < HCLGE_FLR_RETRY_CNT) {
+		    retry_cnt++ < HCLGE_RESET_RETRY_CNT) {
 			dev_err(&hdev->pdev->dev,
 				"reset_pending:0x%lx, retry_cnt:%d\n",
 				hdev->reset_pending, retry_cnt);
 			clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 			up(&hdev->reset_sem);
-			msleep(HCLGE_FLR_RETRY_WAIT_MS);
+			msleep(HCLGE_RESET_RETRY_WAIT_MS);
 			goto retry;
 		}
 	}
 
-	/* disable misc vector before FLR done */
+	/* disable misc vector before reset done */
 	hclge_enable_vector(&hdev->misc_vector, false);
 	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
-	hdev->rst_stats.flr_rst_cnt++;
+
+	if (hdev->reset_type == HNAE3_FLR_RESET)
+		hdev->rst_stats.flr_rst_cnt++;
 }
 
-static void hclge_flr_done(struct hnae3_ae_dev *ae_dev)
+static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
 {
 	struct hclge_dev *hdev = ae_dev->priv;
 	int ret;
@@ -12466,8 +12469,8 @@ static int hclge_get_module_eeprom(struct hnae3_handle *handle, u32 offset,
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
-	.flr_prepare = hclge_flr_prepare,
-	.flr_done = hclge_flr_done,
+	.reset_prepare = hclge_reset_prepare_general,
+	.reset_done = hclge_reset_done,
 	.init_client_instance = hclge_init_client_instance,
 	.uninit_client_instance = hclge_uninit_client_instance,
 	.map_ring_to_vector = hclge_map_ring_to_vector,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1682769..c7d5c17 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2114,10 +2114,11 @@ static void hclgevf_enable_vector(struct hclgevf_misc_vector *vector, bool en)
 	writel(en ? 1 : 0, vector->addr);
 }
 
-static void hclgevf_flr_prepare(struct hnae3_ae_dev *ae_dev)
+static void hclgevf_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
+					  enum hnae3_reset_type rst_type)
 {
-#define HCLGEVF_FLR_RETRY_WAIT_MS	500
-#define HCLGEVF_FLR_RETRY_CNT		5
+#define HCLGEVF_RESET_RETRY_WAIT_MS	500
+#define HCLGEVF_RESET_RETRY_CNT		5
 
 	struct hclgevf_dev *hdev = ae_dev->priv;
 	int retry_cnt = 0;
@@ -2126,29 +2127,31 @@ static void hclgevf_flr_prepare(struct hnae3_ae_dev *ae_dev)
 retry:
 	down(&hdev->reset_sem);
 	set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
-	hdev->reset_type = HNAE3_FLR_RESET;
+	hdev->reset_type = rst_type;
 	ret = hclgevf_reset_prepare(hdev);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
+		dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
 			ret);
 		if (hdev->reset_pending ||
-		    retry_cnt++ < HCLGEVF_FLR_RETRY_CNT) {
+		    retry_cnt++ < HCLGEVF_RESET_RETRY_CNT) {
 			dev_err(&hdev->pdev->dev,
 				"reset_pending:0x%lx, retry_cnt:%d\n",
 				hdev->reset_pending, retry_cnt);
 			clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
 			up(&hdev->reset_sem);
-			msleep(HCLGEVF_FLR_RETRY_WAIT_MS);
+			msleep(HCLGEVF_RESET_RETRY_WAIT_MS);
 			goto retry;
 		}
 	}
 
-	/* disable misc vector before FLR done */
+	/* disable misc vector before reset done */
 	hclgevf_enable_vector(&hdev->misc_vector, false);
-	hdev->rst_stats.flr_rst_cnt++;
+
+	if (hdev->reset_type == HNAE3_FLR_RESET)
+		hdev->rst_stats.flr_rst_cnt++;
 }
 
-static void hclgevf_flr_done(struct hnae3_ae_dev *ae_dev)
+static void hclgevf_reset_done(struct hnae3_ae_dev *ae_dev)
 {
 	struct hclgevf_dev *hdev = ae_dev->priv;
 	int ret;
@@ -3748,8 +3751,8 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 static const struct hnae3_ae_ops hclgevf_ops = {
 	.init_ae_dev = hclgevf_init_ae_dev,
 	.uninit_ae_dev = hclgevf_uninit_ae_dev,
-	.flr_prepare = hclgevf_flr_prepare,
-	.flr_done = hclgevf_flr_done,
+	.reset_prepare = hclgevf_reset_prepare_general,
+	.reset_done = hclgevf_reset_done,
 	.init_client_instance = hclgevf_init_client_instance,
 	.uninit_client_instance = hclgevf_uninit_client_instance,
 	.start = hclgevf_ae_start,
-- 
2.7.4

