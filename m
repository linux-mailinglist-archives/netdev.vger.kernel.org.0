Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0539F2C281
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfE1JFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17617 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbfE1JEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7F5F573EF48DCB2AC809;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: stop schedule reset service while unloading driver
Date:   Tue, 28 May 2019 17:03:00 +0800
Message-ID: <1559034182-24737-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unloading driver, the reset task should not be scheduled
anymore. If disable IRQ before cancel ongoing reset task,
the IRQ may be re-enabled by the reset task.

This patch uses HCLGE_STATE_REMOVING/HCLGEVF_STATE_REMOVING
flag to indicate that the driver is unloading, and we should
stop new coming reset service to be scheduled, otherwise,
reset service will access some resource which has been freed
by unloading.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a563815..0545f38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2427,7 +2427,8 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
-	if (!test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
+	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
+	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		schedule_work(&hdev->rst_service_task);
 }
 
@@ -8385,6 +8386,7 @@ static void hclge_state_init(struct hclge_dev *hdev)
 static void hclge_state_uninit(struct hclge_dev *hdev)
 {
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
+	set_bit(HCLGE_STATE_REMOVING, &hdev->state);
 
 	if (hdev->service_timer.function)
 		del_timer_sync(&hdev->service_timer);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ee1eeca..87a619d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1621,7 +1621,8 @@ static void hclgevf_get_misc_vector(struct hclgevf_dev *hdev)
 
 void hclgevf_reset_task_schedule(struct hclgevf_dev *hdev)
 {
-	if (!test_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state)) {
+	if (!test_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state) &&
+	    !test_bit(HCLGEVF_STATE_REMOVING, &hdev->state)) {
 		set_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state);
 		schedule_work(&hdev->rst_service_task);
 	}
@@ -2132,6 +2133,7 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 static void hclgevf_state_uninit(struct hclgevf_dev *hdev)
 {
 	set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+	set_bit(HCLGEVF_STATE_REMOVING, &hdev->state);
 
 	if (hdev->keep_alive_timer.function)
 		del_timer_sync(&hdev->keep_alive_timer);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index eab1095..a7fbd38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -130,6 +130,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_DOWN,
 	HCLGEVF_STATE_DISABLED,
 	HCLGEVF_STATE_IRQ_INITED,
+	HCLGEVF_STATE_REMOVING,
 	HCLGEVF_STATE_NIC_REGISTERED,
 	/* task states */
 	HCLGEVF_STATE_SERVICE_SCHED,
-- 
2.7.4

