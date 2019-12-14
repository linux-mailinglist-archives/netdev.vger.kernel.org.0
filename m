Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338C111EFDD
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLNCGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:06:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7239 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfLNCGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 21:06:43 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 043F4D40A87014C1B191;
        Sat, 14 Dec 2019 10:06:39 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 14 Dec 2019 10:06:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/5] net: hns3: remove unnecessary work in hclgevf_main
Date:   Sat, 14 Dec 2019 10:06:39 +0800
Message-ID: <1576289201-57017-4-git-send-email-tanhuazhong@huawei.com>
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

There are four work (mbx_service_task, service_task,
rst_service_task and keep_alive_task)in the hclgevf module,
mbx_service_task is for handling mailbox issue, service_task is
for periodic management issue and rst_service_task is for reset
related issue, keep_alive_task is used to keepalive between PF
and VF, which can be done in a single work.

This patch removes the mbx_service_task, rst_service_task and
keep_alive_task, and moves the related handling to the
service_task work in order to remove concurrency between the four
work and to improve efficiency.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 175 ++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   9 +-
 2 files changed, 88 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e48f8fe..004dbaf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -440,6 +440,9 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 	struct hnae3_client *rclient;
 	struct hnae3_client *client;
 
+	if (test_and_set_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state))
+		return;
+
 	client = handle->client;
 	rclient = hdev->roce_client;
 
@@ -452,6 +455,8 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 			rclient->ops->link_status_change(rhandle, !!link_state);
 		hdev->hw.mac.link = link_state;
 	}
+
+	clear_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state);
 }
 
 static void hclgevf_update_link_mode(struct hclgevf_dev *hdev)
@@ -1767,54 +1772,38 @@ static void hclgevf_get_misc_vector(struct hclgevf_dev *hdev)
 
 void hclgevf_reset_task_schedule(struct hclgevf_dev *hdev)
 {
-	if (!test_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state) &&
-	    !test_bit(HCLGEVF_STATE_REMOVING, &hdev->state)) {
-		set_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state);
-		schedule_work(&hdev->rst_service_task);
-	}
+	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
+	    !test_and_set_bit(HCLGEVF_STATE_RST_SERVICE_SCHED,
+			      &hdev->state))
+		mod_delayed_work(system_wq, &hdev->service_task, 0);
 }
 
 void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev)
 {
-	if (!test_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state) &&
-	    !test_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state)) {
-		set_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state);
-		schedule_work(&hdev->mbx_service_task);
-	}
+	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
+	    !test_and_set_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED,
+			      &hdev->state))
+		mod_delayed_work(system_wq, &hdev->service_task, 0);
 }
 
-static void hclgevf_task_schedule(struct hclgevf_dev *hdev)
+static void hclgevf_task_schedule(struct hclgevf_dev *hdev,
+				  unsigned long delay)
 {
-	if (!test_bit(HCLGEVF_STATE_DOWN, &hdev->state)  &&
-	    !test_and_set_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state)) {
-		mod_delayed_work(system_wq, &hdev->service_task,
-				 round_jiffies_relative(HZ));
-		hdev->stats_timer++;
-	}
+	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state))
+		mod_delayed_work(system_wq, &hdev->service_task, delay);
 }
 
-static void hclgevf_deferred_task_schedule(struct hclgevf_dev *hdev)
-{
-	/* if we have any pending mailbox event then schedule the mbx task */
-	if (hdev->mbx_event_pending)
-		hclgevf_mbx_task_schedule(hdev);
-
-	if (test_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state))
-		hclgevf_reset_task_schedule(hdev);
-}
-
-static void hclgevf_reset_service_task(struct work_struct *work)
+static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 {
 #define	HCLGEVF_MAX_RESET_ATTEMPTS_CNT	3
 
-	struct hclgevf_dev *hdev =
-		container_of(work, struct hclgevf_dev, rst_service_task);
 	int ret;
 
-	if (test_and_set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+	if (!test_and_clear_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
-	clear_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state);
+	if (test_and_set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+		return;
 
 	if (test_and_clear_bit(HCLGEVF_RESET_PENDING,
 			       &hdev->reset_state)) {
@@ -1877,39 +1866,24 @@ static void hclgevf_reset_service_task(struct work_struct *work)
 	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
 }
 
-static void hclgevf_mailbox_service_task(struct work_struct *work)
+static void hclgevf_mailbox_service_task(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_dev *hdev;
-
-	hdev = container_of(work, struct hclgevf_dev, mbx_service_task);
+	if (!test_and_clear_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state))
+		return;
 
 	if (test_and_set_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state))
 		return;
 
-	clear_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state);
-
 	hclgevf_mbx_async_handler(hdev);
 
 	clear_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state);
 }
 
-static void hclgevf_keep_alive_timer(struct timer_list *t)
-{
-	struct hclgevf_dev *hdev = from_timer(hdev, t, keep_alive_timer);
-
-	schedule_work(&hdev->keep_alive_task);
-	mod_timer(&hdev->keep_alive_timer, jiffies +
-		  HCLGEVF_KEEP_ALIVE_TASK_INTERVAL * HZ);
-}
-
-static void hclgevf_keep_alive_task(struct work_struct *work)
+static void hclgevf_keep_alive(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_dev *hdev;
 	u8 respmsg;
 	int ret;
 
-	hdev = container_of(work, struct hclgevf_dev, keep_alive_task);
-
 	if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state))
 		return;
 
@@ -1920,19 +1894,32 @@ static void hclgevf_keep_alive_task(struct work_struct *work)
 			"VF sends keep alive cmd failed(=%d)\n", ret);
 }
 
-static void hclgevf_service_task(struct work_struct *work)
+static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 {
-	struct hnae3_handle *handle;
-	struct hclgevf_dev *hdev;
+	unsigned long delta = round_jiffies_relative(HZ);
+	struct hnae3_handle *handle = &hdev->nic;
 
-	hdev = container_of(work, struct hclgevf_dev, service_task.work);
-	handle = &hdev->nic;
+	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
+		delta = jiffies - hdev->last_serv_processed;
 
-	if (hdev->stats_timer >= HCLGEVF_STATS_TIMER_INTERVAL) {
-		hclgevf_tqps_update_stats(handle);
-		hdev->stats_timer = 0;
+		if (delta < round_jiffies_relative(HZ)) {
+			delta = round_jiffies_relative(HZ) - delta;
+			goto out;
+		}
+	}
+
+	hdev->serv_processed_cnt++;
+	if (!(hdev->serv_processed_cnt % HCLGEVF_KEEP_ALIVE_TASK_INTERVAL))
+		hclgevf_keep_alive(hdev);
+
+	if (test_bit(HCLGEVF_STATE_DOWN, &hdev->state)) {
+		hdev->last_serv_processed = jiffies;
+		goto out;
 	}
 
+	if (!(hdev->serv_processed_cnt % HCLGEVF_STATS_TIMER_INTERVAL))
+		hclgevf_tqps_update_stats(handle);
+
 	/* request the link status from the PF. PF would be able to tell VF
 	 * about such updates in future so we might remove this later
 	 */
@@ -1942,11 +1929,27 @@ static void hclgevf_service_task(struct work_struct *work)
 
 	hclgevf_sync_vlan_filter(hdev);
 
-	hclgevf_deferred_task_schedule(hdev);
+	hdev->last_serv_processed = jiffies;
 
-	clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
+out:
+	hclgevf_task_schedule(hdev, delta);
+}
+
+static void hclgevf_service_task(struct work_struct *work)
+{
+	struct hclgevf_dev *hdev = container_of(work, struct hclgevf_dev,
+						service_task.work);
 
-	hclgevf_task_schedule(hdev);
+	hclgevf_reset_service_task(hdev);
+	hclgevf_mailbox_service_task(hdev);
+	hclgevf_periodic_service_task(hdev);
+
+	/* Handle reset and mbx again in case periodical task delays the
+	 * handling by calling hclgevf_task_schedule() in
+	 * hclgevf_periodic_service_task()
+	 */
+	hclgevf_reset_service_task(hdev);
+	hclgevf_mailbox_service_task(hdev);
 }
 
 static void hclgevf_clear_event_cause(struct hclgevf_dev *hdev, u32 regclr)
@@ -2183,16 +2186,31 @@ static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
 				       false);
 }
 
+static void hclgevf_flush_link_update(struct hclgevf_dev *hdev)
+{
+#define HCLGEVF_FLUSH_LINK_TIMEOUT	100000
+
+	unsigned long last = hdev->serv_processed_cnt;
+	int i = 0;
+
+	while (test_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state) &&
+	       i++ < HCLGEVF_FLUSH_LINK_TIMEOUT &&
+	       last == hdev->serv_processed_cnt)
+		usleep_range(1, 1);
+}
+
 static void hclgevf_set_timer_task(struct hnae3_handle *handle, bool enable)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
 	if (enable) {
-		hclgevf_task_schedule(hdev);
+		hclgevf_task_schedule(hdev, 0);
 	} else {
 		set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
-		cancel_delayed_work_sync(&hdev->service_task);
-		clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
+
+		/* flush memory to make sure DOWN is seen by service task */
+		smp_mb__before_atomic();
+		hclgevf_flush_link_update(hdev);
 	}
 }
 
@@ -2239,16 +2257,12 @@ static int hclgevf_set_alive(struct hnae3_handle *handle, bool alive)
 
 static int hclgevf_client_start(struct hnae3_handle *handle)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	int ret;
 
 	ret = hclgevf_set_alive(handle, true);
 	if (ret)
 		return ret;
 
-	mod_timer(&hdev->keep_alive_timer, jiffies +
-		  HCLGEVF_KEEP_ALIVE_TASK_INTERVAL * HZ);
-
 	return 0;
 }
 
@@ -2261,22 +2275,14 @@ static void hclgevf_client_stop(struct hnae3_handle *handle)
 	if (ret)
 		dev_warn(&hdev->pdev->dev,
 			 "%s failed %d\n", __func__, ret);
-
-	del_timer_sync(&hdev->keep_alive_timer);
-	cancel_work_sync(&hdev->keep_alive_task);
 }
 
 static void hclgevf_state_init(struct hclgevf_dev *hdev)
 {
-	/* setup tasks for the MBX */
-	INIT_WORK(&hdev->mbx_service_task, hclgevf_mailbox_service_task);
 	clear_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state);
 
 	INIT_DELAYED_WORK(&hdev->service_task, hclgevf_service_task);
-	clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
-
-	INIT_WORK(&hdev->rst_service_task, hclgevf_reset_service_task);
 
 	mutex_init(&hdev->mbx_resp.mbx_mutex);
 
@@ -2289,16 +2295,8 @@ static void hclgevf_state_uninit(struct hclgevf_dev *hdev)
 	set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
 	set_bit(HCLGEVF_STATE_REMOVING, &hdev->state);
 
-	if (hdev->keep_alive_timer.function)
-		del_timer_sync(&hdev->keep_alive_timer);
-	if (hdev->keep_alive_task.func)
-		cancel_work_sync(&hdev->keep_alive_task);
 	if (hdev->service_task.work.func)
 		cancel_delayed_work_sync(&hdev->service_task);
-	if (hdev->mbx_service_task.func)
-		cancel_work_sync(&hdev->mbx_service_task);
-	if (hdev->rst_service_task.func)
-		cancel_work_sync(&hdev->rst_service_task);
 
 	mutex_destroy(&hdev->mbx_resp.mbx_mutex);
 }
@@ -2796,6 +2794,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	dev_info(&hdev->pdev->dev, "finished initializing %s driver\n",
 		 HCLGEVF_DRIVER_NAME);
 
+	hclgevf_task_schedule(hdev, round_jiffies_relative(HZ));
+
 	return 0;
 
 err_config:
@@ -2827,7 +2827,6 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 static int hclgevf_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
-	struct hclgevf_dev *hdev;
 	int ret;
 
 	ret = hclgevf_alloc_hdev(ae_dev);
@@ -2842,10 +2841,6 @@ static int hclgevf_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
-	hdev = ae_dev->priv;
-	timer_setup(&hdev->keep_alive_timer, hclgevf_keep_alive_timer, 0);
-	INIT_WORK(&hdev->keep_alive_task, hclgevf_keep_alive_task);
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 991a924..450e587 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -142,12 +142,12 @@ enum hclgevf_states {
 	HCLGEVF_STATE_REMOVING,
 	HCLGEVF_STATE_NIC_REGISTERED,
 	/* task states */
-	HCLGEVF_STATE_SERVICE_SCHED,
 	HCLGEVF_STATE_RST_SERVICE_SCHED,
 	HCLGEVF_STATE_RST_HANDLING,
 	HCLGEVF_STATE_MBX_SERVICE_SCHED,
 	HCLGEVF_STATE_MBX_HANDLING,
 	HCLGEVF_STATE_CMD_DISABLE,
+	HCLGEVF_STATE_LINK_UPDATING,
 };
 
 struct hclgevf_mac {
@@ -283,11 +283,7 @@ struct hclgevf_dev {
 	struct hclgevf_mbx_resp_status mbx_resp; /* mailbox response */
 	struct hclgevf_mbx_arq_ring arq; /* mailbox async rx queue */
 
-	struct timer_list keep_alive_timer;
 	struct delayed_work service_task;
-	struct work_struct keep_alive_task;
-	struct work_struct rst_service_task;
-	struct work_struct mbx_service_task;
 
 	struct hclgevf_tqp *htqp;
 
@@ -297,7 +293,8 @@ struct hclgevf_dev {
 	struct hnae3_client *nic_client;
 	struct hnae3_client *roce_client;
 	u32 flag;
-	u32 stats_timer;
+	unsigned long serv_processed_cnt;
+	unsigned long last_serv_processed;
 };
 
 static inline bool hclgevf_is_reset_pending(struct hclgevf_dev *hdev)
-- 
2.7.4

