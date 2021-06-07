Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22439DB1F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhFGLXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:23:17 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4339 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhFGLXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:23:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fz9mb2t9Wz1BKmg;
        Mon,  7 Jun 2021 19:16:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: add scheduling logic for error handling task
Date:   Mon, 7 Jun 2021 19:18:11 +0800
Message-ID: <1623064692-24205-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623064692-24205-1-git-send-email-huangguangbin2@huawei.com>
References: <1623064692-24205-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

Error handling & recovery is done in context of reset task which
gets scheduled from misc interrupt handler in existing code. But
since error handling has been moved to new task, it should get
scheduled instead of the reset task from the interrupt handler.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8a431e124adb..4b1aa5c45852 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3402,18 +3402,8 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	/* vector 0 interrupt is shared with reset and mailbox source events.*/
 	switch (event_cause) {
 	case HCLGE_VECTOR0_EVENT_ERR:
-		/* we do not know what type of reset is required now. This could
-		 * only be decided after we fetch the type of errors which
-		 * caused this event. Therefore, we will do below for now:
-		 * 1. Assert HNAE3_UNKNOWN_RESET type of reset. This means we
-		 *    have defered type of reset to be used.
-		 * 2. Schedule the reset service task.
-		 * 3. When service task receives  HNAE3_UNKNOWN_RESET type it
-		 *    will fetch the correct type of reset.  This would be done
-		 *    by first decoding the types of errors.
-		 */
-		set_bit(HNAE3_UNKNOWN_RESET, &hdev->reset_request);
-		fallthrough;
+		hclge_errhand_task_schedule(hdev);
+		break;
 	case HCLGE_VECTOR0_EVENT_RST:
 		hclge_reset_task_schedule(hdev);
 		break;
@@ -4385,14 +4375,16 @@ static void hclge_service_task(struct work_struct *work)
 	struct hclge_dev *hdev =
 		container_of(work, struct hclge_dev, service_task.work);
 
+	hclge_errhand_service_task(hdev);
 	hclge_reset_service_task(hdev);
 	hclge_mailbox_service_task(hdev);
 	hclge_periodic_service_task(hdev);
 
-	/* Handle reset and mbx again in case periodical task delays the
-	 * handling by calling hclge_task_schedule() in
+	/* Handle error recovery, reset and mbx again in case periodical task
+	 * delays the handling by calling hclge_task_schedule() in
 	 * hclge_periodic_service_task().
 	 */
+	hclge_errhand_service_task(hdev);
 	hclge_reset_service_task(hdev);
 	hclge_mailbox_service_task(hdev);
 }
-- 
2.8.1

