Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E2443C95A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbhJ0MSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:18:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26124 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241771AbhJ0MSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:18:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HfSKf5QS4z1DHpk;
        Wed, 27 Oct 2021 20:14:14 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/7] net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode
Date:   Wed, 27 Oct 2021 20:11:44 +0800
Message-ID: <20211027121149.45897-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211027121149.45897-1-huangguangbin2@huawei.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the workqueue of hclge/hclgevf is executed on
the CPU that initiates scheduling requests by default. In
stress scenarios, the CPU may be busy and workqueue scheduling
is completed after a long period of time. To avoid this
situation and implement proper scheduling, use the WQ_UNBOUND
mode instead. In this way, the workqueue can be performed on
a relatively idle CPU.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 34 +++----------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 -
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 3 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c6b9806c75a5..3dbde0496545 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2847,33 +2847,28 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 static void hclge_errhand_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_bit(HCLGE_STATE_RST_FAIL, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task,
-				    delay_time);
+		mod_delayed_work(hclge_wq, &hdev->service_task, delay_time);
 }
 
 static int hclge_get_mac_link_status(struct hclge_dev *hdev, int *link_status)
@@ -3491,33 +3486,14 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
 	hdev->num_msi_used += 1;
 }
 
-static void hclge_irq_affinity_notify(struct irq_affinity_notify *notify,
-				      const cpumask_t *mask)
-{
-	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
-					      affinity_notify);
-
-	cpumask_copy(&hdev->affinity_mask, mask);
-}
-
-static void hclge_irq_affinity_release(struct kref *ref)
-{
-}
-
 static void hclge_misc_affinity_setup(struct hclge_dev *hdev)
 {
 	irq_set_affinity_hint(hdev->misc_vector.vector_irq,
 			      &hdev->affinity_mask);
-
-	hdev->affinity_notify.notify = hclge_irq_affinity_notify;
-	hdev->affinity_notify.release = hclge_irq_affinity_release;
-	irq_set_affinity_notifier(hdev->misc_vector.vector_irq,
-				  &hdev->affinity_notify);
 }
 
 static void hclge_misc_affinity_teardown(struct hclge_dev *hdev)
 {
-	irq_set_affinity_notifier(hdev->misc_vector.vector_irq, NULL);
 	irq_set_affinity_hint(hdev->misc_vector.vector_irq, NULL);
 }
 
@@ -13082,7 +13058,7 @@ static int hclge_init(void)
 {
 	pr_info("%s is initializing\n", HCLGE_NAME);
 
-	hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
+	hclge_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGE_NAME);
 	if (!hclge_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index de6afbcbfbac..69cd8f87b4c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -944,7 +944,6 @@ struct hclge_dev {
 
 	/* affinity mask and notify for misc interrupt */
 	cpumask_t affinity_mask;
-	struct irq_affinity_notify affinity_notify;
 	struct hclge_ptp *ptp;
 	struct devlink *devlink;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index bef6b98e2f50..5efa5420297d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3899,7 +3899,7 @@ static int hclgevf_init(void)
 {
 	pr_info("%s is initializing\n", HCLGEVF_NAME);
 
-	hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
+	hclgevf_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGEVF_NAME);
 	if (!hclgevf_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
 		return -ENOMEM;
-- 
2.33.0

