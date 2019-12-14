Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE6E11EFE7
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLNCGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:06:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbfLNCGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 21:06:41 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E341D60F9EA61F0C7ED0;
        Sat, 14 Dec 2019 10:06:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 14 Dec 2019 10:06:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/5] net: hns3: do not schedule the periodic task when reset fail
Date:   Sat, 14 Dec 2019 10:06:41 +0800
Message-ID: <1576289201-57017-6-git-send-email-tanhuazhong@huawei.com>
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

From: Guojia Liao <liaoguojia@huawei.com>

service_task will be scheduled  per second to do some periodic
jobs. When reset fails, it means this device is not available
now, so the periodic jobs do not need to be handled.

This patch adds flag HCLGE_STATE_RST_FAIL/HCLGEVF_STATE_RST_FAIL
to indicate that reset fails, and checks this flag before
schedule periodic task.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 7 ++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5129b4a..4e7a078 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2683,7 +2683,8 @@ static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
-	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state))
+	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
+	    !test_bit(HCLGE_STATE_RST_FAIL, &hdev->state))
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
 				    hclge_wq, &hdev->service_task,
 				    delay_time);
@@ -3690,6 +3691,8 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 
 	hclge_dbg_dump_rst_info(hdev);
 
+	set_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
+
 	return false;
 }
 
@@ -3843,6 +3846,7 @@ static void hclge_reset(struct hclge_dev *hdev)
 	hdev->rst_stats.reset_fail_cnt = 0;
 	hdev->rst_stats.reset_done_cnt++;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
+	clear_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
 
 	/* if default_reset_request has a higher level reset request,
 	 * it should be handled as soon as possible. since some errors
@@ -9303,6 +9307,7 @@ static void hclge_state_init(struct hclge_dev *hdev)
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 	clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
+	clear_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
 	clear_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ad40cf6..3a91397 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -215,6 +215,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_STATISTICS_UPDATING,
 	HCLGE_STATE_CMD_DISABLE,
 	HCLGE_STATE_LINK_UPDATING,
+	HCLGE_STATE_RST_FAIL,
 	HCLGE_STATE_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b56c19a..c33b802 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1598,6 +1598,7 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		hclgevf_reset_task_schedule(hdev);
 	} else {
+		set_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
 		hclgevf_dump_rst_info(hdev);
 	}
 }
@@ -1659,6 +1660,7 @@ static int hclgevf_reset(struct hclgevf_dev *hdev)
 	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hdev->rst_stats.rst_done_cnt++;
 	hdev->rst_stats.rst_fail_cnt = 0;
+	clear_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
 
 	return ret;
 err_reset_lock:
@@ -1791,7 +1793,8 @@ void hclgevf_mbx_task_schedule(struct hclgevf_dev *hdev)
 static void hclgevf_task_schedule(struct hclgevf_dev *hdev,
 				  unsigned long delay)
 {
-	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state))
+	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
+	    !test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state))
 		mod_delayed_work(hclgevf_wq, &hdev->service_task, delay);
 }
 
@@ -2283,6 +2286,7 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 {
 	clear_bit(HCLGEVF_STATE_MBX_SERVICE_SCHED, &hdev->state);
 	clear_bit(HCLGEVF_STATE_MBX_HANDLING, &hdev->state);
+	clear_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
 
 	INIT_DELAYED_WORK(&hdev->service_task, hclgevf_service_task);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 450e587..003114f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -148,6 +148,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_MBX_HANDLING,
 	HCLGEVF_STATE_CMD_DISABLE,
 	HCLGEVF_STATE_LINK_UPDATING,
+	HCLGEVF_STATE_RST_FAIL,
 };
 
 struct hclgevf_mac {
-- 
2.7.4

