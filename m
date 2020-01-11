Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464C7137C65
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgAKIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36970 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728680AbgAKIeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:05 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A407B6B1A9ABB317CFBD;
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
Subject: [PATCH net-next 4/7] net: hns3: refactor the procedure of VF FLR
Date:   Sat, 11 Jan 2020 16:33:50 +0800
Message-ID: <1578731633-10709-5-git-send-email-tanhuazhong@huawei.com>
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

Currently, the actual work of VF FLR is handled in the reset task,
which is asynchronous. So in some case, if the preparing and
rebuilding are not done, then the VF FLR will trigger some problems,
for example, makes hardware go into chaos.

So this patch separates the process of VF FLR from reset task, and
adds a semaphore to serialize this reset and others.

When FLR's preparing fails, if there has other higher level reset
pending or failing times less than the HCLGE_FLR_RETRY_CNT, this
preparing should be retried, otherwise it will get into a wrong state.

BTW, while the hardware reports misc interrupt during pcie_flr(),
the driver can not receive this interrupt anymore, so disable it
when hclgevf_flr_prepare() return, and re-enable it when enter
hclgevf_flr_done().

Avoid declaring internal function hclgevf_enable_vector(), this patch
also moves its definition forward, and removes unused enum
hnae3_flr_state.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   5 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 114 ++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 3 files changed, 55 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6b131ab..a3e4081 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -167,11 +167,6 @@ enum hnae3_reset_type {
 	HNAE3_MAX_RESET,
 };
 
-enum hnae3_flr_state {
-	HNAE3_FLR_DOWN,
-	HNAE3_FLR_DONE,
-};
-
 enum hnae3_port_base_vlan_state {
 	HNAE3_PORT_BASE_VLAN_DISABLE,
 	HNAE3_PORT_BASE_VLAN_ENABLE,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 02b44d3..b26b8ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1411,32 +1411,6 @@ static int hclgevf_notify_client(struct hclgevf_dev *hdev,
 	return ret;
 }
 
-static void hclgevf_flr_done(struct hnae3_ae_dev *ae_dev)
-{
-	struct hclgevf_dev *hdev = ae_dev->priv;
-
-	set_bit(HNAE3_FLR_DONE, &hdev->flr_state);
-}
-
-static int hclgevf_flr_poll_timeout(struct hclgevf_dev *hdev,
-				    unsigned long delay_us,
-				    unsigned long wait_cnt)
-{
-	unsigned long cnt = 0;
-
-	while (!test_bit(HNAE3_FLR_DONE, &hdev->flr_state) &&
-	       cnt++ < wait_cnt)
-		usleep_range(delay_us, delay_us * 2);
-
-	if (!test_bit(HNAE3_FLR_DONE, &hdev->flr_state)) {
-		dev_err(&hdev->pdev->dev,
-			"flr wait timeout\n");
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-
 static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RESET_WAIT_US	20000
@@ -1447,11 +1421,7 @@ static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 	u32 val;
 	int ret;
 
-	if (hdev->reset_type == HNAE3_FLR_RESET)
-		return hclgevf_flr_poll_timeout(hdev,
-						HCLGEVF_RESET_WAIT_US,
-						HCLGEVF_RESET_WAIT_CNT);
-	else if (hdev->reset_type == HNAE3_VF_RESET)
+	if (hdev->reset_type == HNAE3_VF_RESET)
 		ret = readl_poll_timeout(hdev->hw.io_base +
 					 HCLGEVF_VF_RST_ING, val,
 					 !(val & HCLGEVF_VF_RST_ING_BIT),
@@ -1533,18 +1503,10 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 
 	int ret = 0;
 
-	switch (hdev->reset_type) {
-	case HNAE3_VF_FUNC_RESET:
+	if (hdev->reset_type == HNAE3_VF_FUNC_RESET) {
 		ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_RESET, 0, NULL,
 					   0, true, NULL, sizeof(u8));
 		hdev->rst_stats.vf_func_rst_cnt++;
-		break;
-	case HNAE3_FLR_RESET:
-		set_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
-		hdev->rst_stats.flr_rst_cnt++;
-		break;
-	default:
-		break;
 	}
 
 	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
@@ -1734,25 +1696,60 @@ static void hclgevf_set_def_reset_request(struct hnae3_ae_dev *ae_dev,
 	set_bit(rst_type, &hdev->default_reset_request);
 }
 
+static void hclgevf_enable_vector(struct hclgevf_misc_vector *vector, bool en)
+{
+	writel(en ? 1 : 0, vector->addr);
+}
+
 static void hclgevf_flr_prepare(struct hnae3_ae_dev *ae_dev)
 {
-#define HCLGEVF_FLR_WAIT_MS	100
-#define HCLGEVF_FLR_WAIT_CNT	50
+#define HCLGEVF_FLR_RETRY_WAIT_MS	500
+#define HCLGEVF_FLR_RETRY_CNT		5
+
+	struct hclgevf_dev *hdev = ae_dev->priv;
+	int retry_cnt = 0;
+	int ret;
+
+retry:
+	down(&hdev->reset_sem);
+	set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
+	hdev->reset_type = HNAE3_FLR_RESET;
+	ret = hclgevf_reset_prepare(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
+			ret);
+		if (hdev->reset_pending ||
+		    retry_cnt++ < HCLGEVF_FLR_RETRY_CNT) {
+			dev_err(&hdev->pdev->dev,
+				"reset_pending:0x%lx, retry_cnt:%d\n",
+				hdev->reset_pending, retry_cnt);
+			clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
+			up(&hdev->reset_sem);
+			msleep(HCLGEVF_FLR_RETRY_WAIT_MS);
+			goto retry;
+		}
+	}
+
+	/* disable misc vector before FLR done */
+	hclgevf_enable_vector(&hdev->misc_vector, false);
+	hdev->rst_stats.flr_rst_cnt++;
+}
+
+static void hclgevf_flr_done(struct hnae3_ae_dev *ae_dev)
+{
 	struct hclgevf_dev *hdev = ae_dev->priv;
-	int cnt = 0;
+	int ret;
 
-	clear_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
-	clear_bit(HNAE3_FLR_DONE, &hdev->flr_state);
-	set_bit(HNAE3_FLR_RESET, &hdev->default_reset_request);
-	hclgevf_reset_event(hdev->pdev, NULL);
+	hclgevf_enable_vector(&hdev->misc_vector, true);
 
-	while (!test_bit(HNAE3_FLR_DOWN, &hdev->flr_state) &&
-	       cnt++ < HCLGEVF_FLR_WAIT_CNT)
-		msleep(HCLGEVF_FLR_WAIT_MS);
+	ret = hclgevf_reset_rebuild(hdev);
+	if (ret)
+		dev_warn(&hdev->pdev->dev, "fail to rebuild, ret=%d\n",
+			 ret);
 
-	if (!test_bit(HNAE3_FLR_DOWN, &hdev->flr_state))
-		dev_err(&hdev->pdev->dev,
-			"flr wait down timeout: %d\n", cnt);
+	hdev->reset_type = HNAE3_NONE_RESET;
+	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
+	up(&hdev->reset_sem);
 }
 
 static u32 hclgevf_get_fw_version(struct hnae3_handle *handle)
@@ -1808,8 +1805,8 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 	if (!test_and_clear_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
-	if (test_and_set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
-		return;
+	down(&hdev->reset_sem);
+	set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
 
 	if (test_and_clear_bit(HCLGEVF_RESET_PENDING,
 			       &hdev->reset_state)) {
@@ -1866,6 +1863,7 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 	}
 
 	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
+	up(&hdev->reset_sem);
 }
 
 static void hclgevf_mailbox_service_task(struct hclgevf_dev *hdev)
@@ -2009,11 +2007,6 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 	return HCLGEVF_VECTOR0_EVENT_OTHER;
 }
 
-static void hclgevf_enable_vector(struct hclgevf_misc_vector *vector, bool en)
-{
-	writel(en ? 1 : 0, vector->addr);
-}
-
 static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 {
 	enum hclgevf_evt_cause event_cause;
@@ -2288,6 +2281,7 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 	INIT_DELAYED_WORK(&hdev->service_task, hclgevf_service_task);
 
 	mutex_init(&hdev->mbx_resp.mbx_mutex);
+	sema_init(&hdev->reset_sem, 1);
 
 	/* bring the device down */
 	set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 2cbc7df..fee8d97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -253,6 +253,7 @@ struct hclgevf_dev {
 	unsigned long reset_state;	/* requested, pending */
 	struct hclgevf_rst_stats rst_stats;
 	u32 reset_attempts;
+	struct semaphore reset_sem;	/* protect reset process */
 
 	u32 fw_version;
 	u16 num_tqps;		/* num task queue pairs of this PF */
-- 
2.7.4

