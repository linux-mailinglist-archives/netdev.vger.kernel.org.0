Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF011EFDF
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLNCGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:06:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbfLNCGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 21:06:43 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09ABE28656E5414BFF2D;
        Sat, 14 Dec 2019 10:06:39 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 14 Dec 2019 10:06:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: schedule hclgevf_service by using delayed workqueue
Date:   Sat, 14 Dec 2019 10:06:37 +0800
Message-ID: <1576289201-57017-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
References: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently, a timer is defined to schedule hclgevf_service per
second. To simplify the code, this patch uses the delayed work
instead of timer to schedule hclgevf_serive.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 39 ++++++++--------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  3 +-
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 25d78a5..e48f8fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1786,8 +1786,11 @@ void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev)
 static void hclgevf_task_schedule(struct hclgevf_dev *hdev)
 {
 	if (!test_bit(HCLGEVF_STATE_DOWN, &hdev->state)  &&
-	    !test_and_set_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state))
-		schedule_work(&hdev->service_task);
+	    !test_and_set_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state)) {
+		mod_delayed_work(system_wq, &hdev->service_task,
+				 round_jiffies_relative(HZ));
+		hdev->stats_timer++;
+	}
 }
 
 static void hclgevf_deferred_task_schedule(struct hclgevf_dev *hdev)
@@ -1800,17 +1803,6 @@ static void hclgevf_deferred_task_schedule(struct hclgevf_dev *hdev)
 		hclgevf_reset_task_schedule(hdev);
 }
 
-static void hclgevf_service_timer(struct timer_list *t)
-{
-	struct hclgevf_dev *hdev = from_timer(hdev, t, service_timer);
-
-	mod_timer(&hdev->service_timer, jiffies +
-		  HCLGEVF_GENERAL_TASK_INTERVAL * HZ);
-
-	hdev->stats_timer++;
-	hclgevf_task_schedule(hdev);
-}
-
 static void hclgevf_reset_service_task(struct work_struct *work)
 {
 #define	HCLGEVF_MAX_RESET_ATTEMPTS_CNT	3
@@ -1933,7 +1925,7 @@ static void hclgevf_service_task(struct work_struct *work)
 	struct hnae3_handle *handle;
 	struct hclgevf_dev *hdev;
 
-	hdev = container_of(work, struct hclgevf_dev, service_task);
+	hdev = container_of(work, struct hclgevf_dev, service_task.work);
 	handle = &hdev->nic;
 
 	if (hdev->stats_timer >= HCLGEVF_STATS_TIMER_INTERVAL) {
@@ -1953,6 +1945,8 @@ static void hclgevf_service_task(struct work_struct *work)
 	hclgevf_deferred_task_schedule(hdev);
 
 	clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
+
+	hclgevf_task_schedule(hdev);
 }
 
 static void hclgevf_clear_event_cause(struct hclgevf_dev *hdev, u32 regclr)
@@ -2194,10 +2188,10 @@ static void hclgevf_set_timer_task(struct hnae3_handle *handle, bool enable)
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
 	if (enable) {
-		mod_timer(&hdev->service_timer, jiffies + HZ);
+		hclgevf_task_schedule(hdev);
 	} else {
-		del_timer_sync(&hdev->service_timer);
-		cancel_work_sync(&hdev->service_task);
+		set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+		cancel_delayed_work_sync(&hdev->service_task);
 		clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
 	}
 }
@@ -2279,10 +2273,7 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 	clear_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state);
 
-	/* setup tasks for service timer */
-	timer_setup(&hdev->service_timer, hclgevf_service_timer, 0);
-
-	INIT_WORK(&hdev->service_task, hclgevf_service_task);
+	INIT_DELAYED_WORK(&hdev->service_task, hclgevf_service_task);
 	clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
 
 	INIT_WORK(&hdev->rst_service_task, hclgevf_reset_service_task);
@@ -2302,10 +2293,8 @@ static void hclgevf_state_uninit(struct hclgevf_dev *hdev)
 		del_timer_sync(&hdev->keep_alive_timer);
 	if (hdev->keep_alive_task.func)
 		cancel_work_sync(&hdev->keep_alive_task);
-	if (hdev->service_timer.function)
-		del_timer_sync(&hdev->service_timer);
-	if (hdev->service_task.func)
-		cancel_work_sync(&hdev->service_task);
+	if (hdev->service_task.work.func)
+		cancel_delayed_work_sync(&hdev->service_task);
 	if (hdev->mbx_service_task.func)
 		cancel_work_sync(&hdev->mbx_service_task);
 	if (hdev->rst_service_task.func)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 2f4c81b..991a924 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -283,9 +283,8 @@ struct hclgevf_dev {
 	struct hclgevf_mbx_resp_status mbx_resp; /* mailbox response */
 	struct hclgevf_mbx_arq_ring arq; /* mailbox async rx queue */
 
-	struct timer_list service_timer;
 	struct timer_list keep_alive_timer;
-	struct work_struct service_task;
+	struct delayed_work service_task;
 	struct work_struct keep_alive_task;
 	struct work_struct rst_service_task;
 	struct work_struct mbx_service_task;
-- 
2.7.4

