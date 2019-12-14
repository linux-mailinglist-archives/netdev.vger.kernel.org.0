Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0F611EFE5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfLNCGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:06:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfLNCGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 21:06:41 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F34151EEAAA3EF4F9F15;
        Sat, 14 Dec 2019 10:06:38 +0800 (CST)
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
Subject: [PATCH net-next 4/5] net: hns3: allocate WQ with WQ_MEM_RECLAIM flag
Date:   Sat, 14 Dec 2019 10:06:40 +0800
Message-ID: <1576289201-57017-5-git-send-email-tanhuazhong@huawei.com>
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

The hns3 driver may be used in memory reclaim path when it
is the low level transport of a network file system, so it
needs to guarantee forward progress even under memory pressure.

This patch allocates a private WQ with WQ_MEM_RECLAIM set for
both hclge_main and hclgevf_main modules.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 ++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 15 ++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a0177e3..5129b4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -72,6 +72,8 @@ static int hclge_set_default_loopback(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
 
+static struct workqueue_struct *hclge_wq;
+
 static const struct pci_device_id ae_algo_pci_tbl[] = {
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_GE), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_25GE), 0},
@@ -2668,7 +2670,7 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    system_wq, &hdev->service_task, 0);
+				    hclge_wq, &hdev->service_task, 0);
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
@@ -2676,14 +2678,14 @@ static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    system_wq, &hdev->service_task, 0);
+				    hclge_wq, &hdev->service_task, 0);
 }
 
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state))
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    system_wq, &hdev->service_task,
+				    hclge_wq, &hdev->service_task,
 				    delay_time);
 }
 
@@ -10652,6 +10654,12 @@ static int hclge_init(void)
 {
 	pr_info("%s is initializing\n", HCLGE_NAME);
 
+	hclge_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, HCLGE_NAME);
+	if (!hclge_wq) {
+		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
+		return -ENOMEM;
+	}
+
 	hnae3_register_ae_algo(&ae_algo);
 
 	return 0;
@@ -10660,6 +10668,7 @@ static int hclge_init(void)
 static void hclge_exit(void)
 {
 	hnae3_unregister_ae_algo(&ae_algo);
+	destroy_workqueue(hclge_wq);
 }
 module_init(hclge_init);
 module_exit(hclge_exit);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 004dbaf..b56c19a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -16,6 +16,8 @@
 static int hclgevf_reset_hdev(struct hclgevf_dev *hdev);
 static struct hnae3_ae_algo ae_algovf;
 
+static struct workqueue_struct *hclgevf_wq;
+
 static const struct pci_device_id ae_algovf_pci_tbl[] = {
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_VF), 0},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF), 0},
@@ -1775,7 +1777,7 @@ void hclgevf_reset_task_schedule(struct hclgevf_dev *hdev)
 	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGEVF_STATE_RST_SERVICE_SCHED,
 			      &hdev->state))
-		mod_delayed_work(system_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclgevf_wq, &hdev->service_task, 0);
 }
 
 void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev)
@@ -1783,14 +1785,14 @@ void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev)
 	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED,
 			      &hdev->state))
-		mod_delayed_work(system_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclgevf_wq, &hdev->service_task, 0);
 }
 
 static void hclgevf_task_schedule(struct hclgevf_dev *hdev,
 				  unsigned long delay)
 {
 	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state))
-		mod_delayed_work(system_wq, &hdev->service_task, delay);
+		mod_delayed_work(hclgevf_wq, &hdev->service_task, delay);
 }
 
 static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
@@ -3197,6 +3199,12 @@ static int hclgevf_init(void)
 {
 	pr_info("%s is initializing\n", HCLGEVF_NAME);
 
+	hclgevf_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, HCLGEVF_NAME);
+	if (!hclgevf_wq) {
+		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
+		return -ENOMEM;
+	}
+
 	hnae3_register_ae_algo(&ae_algovf);
 
 	return 0;
@@ -3205,6 +3213,7 @@ static int hclgevf_init(void)
 static void hclgevf_exit(void)
 {
 	hnae3_unregister_ae_algo(&ae_algovf);
+	destroy_workqueue(hclgevf_wq);
 }
 module_init(hclgevf_init);
 module_exit(hclgevf_exit);
-- 
2.7.4

