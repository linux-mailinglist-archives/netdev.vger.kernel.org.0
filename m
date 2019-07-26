Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2ABA75D6E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 05:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGZD1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 23:27:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3168 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfGZD1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 23:27:12 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00499DF0BCE0F7A98DA0;
        Fri, 26 Jul 2019 11:27:09 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 11:27:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 09/11] net: hns3: add interrupt affinity support for misc interrupt
Date:   Fri, 26 Jul 2019 11:25:00 +0800
Message-ID: <1564111502-15504-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
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
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 53 ++++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 ++
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e804a19..3e43dff 100644
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
 
@@ -2501,14 +2507,16 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
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
@@ -2518,8 +2526,9 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
 	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state)) {
 		hdev->hw_stats.stats_timer++;
 		hdev->fd_arfs_expire_timer++;
-		mod_delayed_work(system_wq, &hdev->service_task,
-				 round_jiffies_relative(HZ));
+		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
+				    system_wq, &hdev->service_task,
+				    round_jiffies_relative(HZ));
 	}
 }
 
@@ -2905,6 +2914,36 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
 	hdev->num_msi_used += 1;
 }
 
+static void hclge_irq_affinity_notify(struct irq_affinity_notify *notify,
+				      const cpumask_t *mask)
+{
+	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
+					      affinity_notify);
+
+	cpumask_copy(&hdev->affinity_mask, mask);
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
@@ -8796,6 +8835,11 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
+	/* Setup affinity after service timer setup because add_timer_on
+	 * is called in affinity notify.
+	 */
+	hclge_misc_affinity_setup(hdev);
+
 	hclge_clear_all_event_cause(hdev);
 	hclge_clear_resetting_state(hdev);
 
@@ -8957,6 +9001,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct hclge_mac *mac = &hdev->hw.mac;
 
+	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 
 	if (mac->phydev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index dde8f22..688e425 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -863,6 +863,10 @@ struct hclge_dev {
 
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

