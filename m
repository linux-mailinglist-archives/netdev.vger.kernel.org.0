Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F472545
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfGXDVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:21:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50728 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726461AbfGXDVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:21:01 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9EDD0AF284D8CD6EC3E7;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/11] net: hns3: add interrupt affinity support for misc interrupt
Date:   Wed, 24 Jul 2019 11:18:44 +0800
Message-ID: <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The misc interrupt is used to schedule the reset and mailbox
subtask, and a 1 sec timer is used to schedule the service
subtask, which does periodic work.

This patch sets the above three subtask's affinity using the
misc interrupt' affinity.

Also this patch setups a affinity notify for misc interrupt to
allow user to change the above three subtask's affinity.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 59 ++++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 ++
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f345095..fe45986 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1270,6 +1270,12 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	hclge_init_kdump_kernel_config(hdev);
 
+	/* Set the init affinity based on pci func number */
+	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev->dev)));
+	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
+	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev->pdev->dev)),
+			&hdev->affinity_mask);
+
 	return ret;
 }
 
@@ -2502,14 +2508,16 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
-		schedule_work(&hdev->mbx_service_task);
+		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
+			      &hdev->mbx_service_task);
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
-		schedule_work(&hdev->rst_service_task);
+		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
+			      &hdev->rst_service_task);
 }
 
 static void hclge_task_schedule(struct hclge_dev *hdev)
@@ -2517,7 +2525,8 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
 	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
 	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
-		(void)schedule_work(&hdev->service_task);
+		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
+			      &hdev->service_task);
 }
 
 static int hclge_get_mac_link_status(struct hclge_dev *hdev)
@@ -2921,6 +2930,39 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
 	hdev->num_msi_used += 1;
 }
 
+static void hclge_irq_affinity_notify(struct irq_affinity_notify *notify,
+				      const cpumask_t *mask)
+{
+	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
+					      affinity_notify);
+
+	cpumask_copy(&hdev->affinity_mask, mask);
+	del_timer_sync(&hdev->service_timer);
+	hdev->service_timer.expires = jiffies + HZ;
+	add_timer_on(&hdev->service_timer, cpumask_first(&hdev->affinity_mask));
+}
+
+static void hclge_irq_affinity_release(struct kref *ref)
+{
+}
+
+static void hclge_misc_affinity_setup(struct hclge_dev *hdev)
+{
+	irq_set_affinity_hint(hdev->misc_vector.vector_irq,
+			      &hdev->affinity_mask);
+
+	hdev->affinity_notify.notify = hclge_irq_affinity_notify;
+	hdev->affinity_notify.release = hclge_irq_affinity_release;
+	irq_set_affinity_notifier(hdev->misc_vector.vector_irq,
+				  &hdev->affinity_notify);
+}
+
+static void hclge_misc_affinity_teardown(struct hclge_dev *hdev)
+{
+	irq_set_affinity_notifier(hdev->misc_vector.vector_irq, NULL);
+	irq_set_affinity_hint(hdev->misc_vector.vector_irq, NULL);
+}
+
 static int hclge_misc_irq_init(struct hclge_dev *hdev)
 {
 	int ret;
@@ -6151,7 +6193,10 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 	struct hclge_dev *hdev = vport->back;
 
 	if (enable) {
-		mod_timer(&hdev->service_timer, jiffies + HZ);
+		del_timer_sync(&hdev->service_timer);
+		hdev->service_timer.expires = jiffies + HZ;
+		add_timer_on(&hdev->service_timer,
+			     cpumask_first(&hdev->affinity_mask));
 	} else {
 		del_timer_sync(&hdev->service_timer);
 		cancel_work_sync(&hdev->service_task);
@@ -8809,6 +8854,11 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
+	/* Setup affinity after service timer setup because add_timer_on
+	 * is called in affinity notify.
+	 */
+	hclge_misc_affinity_setup(hdev);
+
 	hclge_clear_all_event_cause(hdev);
 	hclge_clear_resetting_state(hdev);
 
@@ -8970,6 +9020,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct hclge_mac *mac = &hdev->hw.mac;
 
+	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 
 	if (mac->phydev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 6a12285..14df23c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -864,6 +864,10 @@ struct hclge_dev {
 
 	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
 		      HCLGE_MAC_TNL_LOG_SIZE);
+
+	/* affinity mask and notify for misc interrupt */
+	cpumask_t affinity_mask;
+	struct irq_affinity_notify affinity_notify;
 };
 
 /* VPort level vlan tag configuration for TX direction */
-- 
2.7.4

