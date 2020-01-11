Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D546C137C67
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAKIea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36874 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728642AbgAKIeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:04 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9A18C354D811AD693C56;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: refactor the precedure of PF FLR
Date:   Sat, 11 Jan 2020 16:33:49 +0800
Message-ID: <1578731633-10709-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
References: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the actual work of PF FLR is handled in the reset task,
which is asynchronous. So in some case, if the preparing and
rebuilding are not done, then the PF FLR will trigger some problems,
for example, makes hardware go into chaos.

So this patch separates the process of PF FLR from reset task, and
adds a semaphore to serialize this reset and others.

When FLR's preparing fails, if there has other higher level reset
pending or failing times less than the HCLGE_FLR_RETRY_CNT, this
preparing should be retried, otherwise PF and its VF may get into
wrong state.

BTW, while the hardware reports misc interrupt during pcie_flr(),
the driver can not receive this interrupt anymore, so disable it
when hclge_flr_prepare() return, and re-enable it when enter
hclge_flr_done().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 85 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9cbc0b6..89621b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3277,8 +3277,6 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
 		reg = HCLGE_FUN_RST_ING;
 		reg_bit = HCLGE_FUN_RST_ING_B;
 		break;
-	case HNAE3_FLR_RESET:
-		break;
 	default:
 		dev_err(&hdev->pdev->dev,
 			"Wait for unsupported reset type: %d\n",
@@ -3286,20 +3284,6 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
 		return -EINVAL;
 	}
 
-	if (hdev->reset_type == HNAE3_FLR_RESET) {
-		while (!test_bit(HNAE3_FLR_DONE, &hdev->flr_state) &&
-		       cnt++ < HCLGE_RESET_WAIT_CNT)
-			msleep(HCLGE_RESET_WATI_MS);
-
-		if (!test_bit(HNAE3_FLR_DONE, &hdev->flr_state)) {
-			dev_err(&hdev->pdev->dev,
-				"flr wait timeout: %u\n", cnt);
-			return -EBUSY;
-		}
-
-		return 0;
-	}
-
 	val = hclge_read_dev(&hdev->hw, reg);
 	while (hnae3_get_bit(val, reg_bit) && cnt < HCLGE_RESET_WAIT_CNT) {
 		msleep(HCLGE_RESET_WATI_MS);
@@ -3490,12 +3474,6 @@ static void hclge_do_reset(struct hclge_dev *hdev)
 		set_bit(HNAE3_FUNC_RESET, &hdev->reset_pending);
 		hclge_reset_task_schedule(hdev);
 		break;
-	case HNAE3_FLR_RESET:
-		dev_info(&pdev->dev, "FLR requested\n");
-		/* schedule again to check later */
-		set_bit(HNAE3_FLR_RESET, &hdev->reset_pending);
-		hclge_reset_task_schedule(hdev);
-		break;
 	default:
 		dev_warn(&pdev->dev,
 			 "Unsupported reset type: %d\n", hdev->reset_type);
@@ -3650,10 +3628,6 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		ret = hclge_func_reset_sync_vf(hdev);
 		if (ret)
 			return ret;
-
-		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
-		set_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
-		hdev->rst_stats.flr_rst_cnt++;
 		break;
 	case HNAE3_IMP_RESET:
 		hclge_handle_imp_error(hdev);
@@ -3989,12 +3963,13 @@ static void hclge_reset_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
-	if (test_and_set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
-		return;
+	down(&hdev->reset_sem);
+	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 
 	hclge_reset_subtask(hdev);
 
 	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+	up(&hdev->reset_sem);
 }
 
 static void hclge_update_vport_alive(struct hclge_dev *hdev)
@@ -9341,30 +9316,53 @@ static void hclge_state_uninit(struct hclge_dev *hdev)
 
 static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
 {
-#define HCLGE_FLR_WAIT_MS	100
-#define HCLGE_FLR_WAIT_CNT	50
-	struct hclge_dev *hdev = ae_dev->priv;
-	int cnt = 0;
+#define HCLGE_FLR_RETRY_WAIT_MS	500
+#define HCLGE_FLR_RETRY_CNT	5
 
-	clear_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
-	clear_bit(HNAE3_FLR_DONE, &hdev->flr_state);
-	set_bit(HNAE3_FLR_RESET, &hdev->default_reset_request);
-	hclge_reset_event(hdev->pdev, NULL);
+	struct hclge_dev *hdev = ae_dev->priv;
+	int retry_cnt = 0;
+	int ret;
 
-	while (!test_bit(HNAE3_FLR_DOWN, &hdev->flr_state) &&
-	       cnt++ < HCLGE_FLR_WAIT_CNT)
-		msleep(HCLGE_FLR_WAIT_MS);
+retry:
+	down(&hdev->reset_sem);
+	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+	hdev->reset_type = HNAE3_FLR_RESET;
+	ret = hclge_reset_prepare(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
+			ret);
+		if (hdev->reset_pending ||
+		    retry_cnt++ < HCLGE_FLR_RETRY_CNT) {
+			dev_err(&hdev->pdev->dev,
+				"reset_pending:0x%lx, retry_cnt:%d\n",
+				hdev->reset_pending, retry_cnt);
+			clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+			up(&hdev->reset_sem);
+			msleep(HCLGE_FLR_RETRY_WAIT_MS);
+			goto retry;
+		}
+	}
 
-	if (!test_bit(HNAE3_FLR_DOWN, &hdev->flr_state))
-		dev_err(&hdev->pdev->dev,
-			"flr wait down timeout: %d\n", cnt);
+	/* disable misc vector before FLR done */
+	hclge_enable_vector(&hdev->misc_vector, false);
+	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
+	hdev->rst_stats.flr_rst_cnt++;
 }
 
 static void hclge_flr_done(struct hnae3_ae_dev *ae_dev)
 {
 	struct hclge_dev *hdev = ae_dev->priv;
+	int ret;
+
+	hclge_enable_vector(&hdev->misc_vector, true);
 
-	set_bit(HNAE3_FLR_DONE, &hdev->flr_state);
+	ret = hclge_reset_rebuild(hdev);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "fail to rebuild, ret=%d\n", ret);
+
+	hdev->reset_type = HNAE3_NONE_RESET;
+	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+	up(&hdev->reset_sem);
 }
 
 static void hclge_clear_resetting_state(struct hclge_dev *hdev)
@@ -9407,6 +9405,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	mutex_init(&hdev->vport_lock);
 	spin_lock_init(&hdev->fd_rule_lock);
+	sema_init(&hdev->reset_sem, 1);
 
 	ret = hclge_pci_init(hdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 4e5cfda..1c1d6b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -720,6 +720,7 @@ struct hclge_dev {
 	unsigned long reset_request;	/* reset has been requested */
 	unsigned long reset_pending;	/* client rst is pending to be served */
 	struct hclge_rst_stats rst_stats;
+	struct semaphore reset_sem;	/* protect reset process */
 	u32 fw_version;
 	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
 	u16 num_tqps;			/* Num task queue pairs of this PF */
-- 
2.7.4

