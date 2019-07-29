Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77EC78378
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfG2C4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:56:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbfG2Czl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 22:55:41 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F2FE75454DBC8BE2B94C;
        Mon, 29 Jul 2019 10:55:35 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Jul 2019 10:55:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 07/10] net: hns3: make hclge_service use delayed workqueue
Date:   Mon, 29 Jul 2019 10:53:28 +0800
Message-ID: <1564368811-65492-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Use delayed work instead of using timers to trigger the
hclge_serive.

Simplify the code with one less middle function and in order
to support misc irq affinity.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 52 +++++++++-------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  3 +-
 2 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 14199c4..13c9697 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2513,8 +2513,12 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
 	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
-		(void)schedule_work(&hdev->service_task);
+	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state)) {
+		hdev->hw_stats.stats_timer++;
+		hdev->fd_arfs_expire_timer++;
+		mod_delayed_work(system_wq, &hdev->service_task,
+				 round_jiffies_relative(HZ));
+	}
 }
 
 static int hclge_get_mac_link_status(struct hclge_dev *hdev)
@@ -2729,25 +2733,6 @@ static int hclge_get_status(struct hnae3_handle *handle)
 	return hdev->hw.mac.link;
 }
 
-static void hclge_service_timer(struct timer_list *t)
-{
-	struct hclge_dev *hdev = from_timer(hdev, t, service_timer);
-
-	mod_timer(&hdev->service_timer, jiffies + HZ);
-	hdev->hw_stats.stats_timer++;
-	hdev->fd_arfs_expire_timer++;
-	hclge_task_schedule(hdev);
-}
-
-static void hclge_service_complete(struct hclge_dev *hdev)
-{
-	WARN_ON(!test_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state));
-
-	/* Flush memory before next watchdog */
-	smp_mb__before_atomic();
-	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
-}
-
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
 	u32 rst_src_reg, cmdq_src_reg, msix_src_reg;
@@ -3594,7 +3579,9 @@ static void hclge_update_vport_alive(struct hclge_dev *hdev)
 static void hclge_service_task(struct work_struct *work)
 {
 	struct hclge_dev *hdev =
-		container_of(work, struct hclge_dev, service_task);
+		container_of(work, struct hclge_dev, service_task.work);
+
+	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
 
 	if (hdev->hw_stats.stats_timer >= HCLGE_STATS_TIMER_INTERVAL) {
 		hclge_update_stats_for_all(hdev);
@@ -3609,7 +3596,8 @@ static void hclge_service_task(struct work_struct *work)
 		hclge_rfs_filter_expire(hdev);
 		hdev->fd_arfs_expire_timer = 0;
 	}
-	hclge_service_complete(hdev);
+
+	hclge_task_schedule(hdev);
 }
 
 struct hclge_vport *hclge_get_vport(struct hnae3_handle *handle)
@@ -6148,10 +6136,13 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 	struct hclge_dev *hdev = vport->back;
 
 	if (enable) {
-		mod_timer(&hdev->service_timer, jiffies + HZ);
+		hclge_task_schedule(hdev);
 	} else {
-		del_timer_sync(&hdev->service_timer);
-		cancel_work_sync(&hdev->service_task);
+		/* Set the DOWN flag here to disable the service to be
+		 * scheduled again
+		 */
+		set_bit(HCLGE_STATE_DOWN, &hdev->state);
+		cancel_delayed_work_sync(&hdev->service_task);
 		clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
 	}
 }
@@ -8590,12 +8581,10 @@ static void hclge_state_uninit(struct hclge_dev *hdev)
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 	set_bit(HCLGE_STATE_REMOVING, &hdev->state);
 
-	if (hdev->service_timer.function)
-		del_timer_sync(&hdev->service_timer);
 	if (hdev->reset_timer.function)
 		del_timer_sync(&hdev->reset_timer);
-	if (hdev->service_task.func)
-		cancel_work_sync(&hdev->service_task);
+	if (hdev->service_task.work.func)
+		cancel_delayed_work_sync(&hdev->service_task);
 	if (hdev->rst_service_task.func)
 		cancel_work_sync(&hdev->rst_service_task);
 	if (hdev->mbx_service_task.func)
@@ -8800,9 +8789,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_dcb_ops_set(hdev);
 
-	timer_setup(&hdev->service_timer, hclge_service_timer, 0);
 	timer_setup(&hdev->reset_timer, hclge_reset_timer, 0);
-	INIT_WORK(&hdev->service_task, hclge_service_task);
+	INIT_DELAYED_WORK(&hdev->service_task, hclge_service_task);
 	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 6a12285..dde8f22 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -806,9 +806,8 @@ struct hclge_dev {
 	u16 adminq_work_limit; /* Num of admin receive queue desc to process */
 	unsigned long service_timer_period;
 	unsigned long service_timer_previous;
-	struct timer_list service_timer;
 	struct timer_list reset_timer;
-	struct work_struct service_task;
+	struct delayed_work service_task;
 	struct work_struct rst_service_task;
 	struct work_struct mbx_service_task;
 
-- 
2.7.4

