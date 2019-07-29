Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674DE78373
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfG2Czs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:55:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfG2Czq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 22:55:46 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 13E6FB3AADEB861D3943;
        Mon, 29 Jul 2019 10:55:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Jul 2019 10:55:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 08/10] net: hns3: add interrupt affinity support for misc interrupt
Date:   Mon, 29 Jul 2019 10:53:29 +0800
Message-ID: <1564368811-65492-9-git-send-email-tanhuazhong@huawei.com>
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

The misc interrupt is used to schedule the reset and mailbox
subtask, and service_task delayed_work is used to do periodic
management work each second.

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
index 13c9697..30a7074 100644
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
 
@@ -2499,14 +2505,16 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
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
@@ -2516,8 +2524,9 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
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
 
@@ -2903,6 +2912,36 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
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
@@ -8794,6 +8833,11 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
+	/* Setup affinity after service timer setup because add_timer_on
+	 * is called in affinity notify.
+	 */
+	hclge_misc_affinity_setup(hdev);
+
 	hclge_clear_all_event_cause(hdev);
 	hclge_clear_resetting_state(hdev);
 
@@ -8955,6 +8999,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
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

