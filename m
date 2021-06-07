Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056B439DB1B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFGLXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:23:14 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4337 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhFGLXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:23:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fz9mZ3LwMz1BKn8;
        Mon,  7 Jun 2021 19:16:30 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [PATCH net-next 1/3] net: hns3: add a separate error handling task
Date:   Mon, 7 Jun 2021 19:18:10 +0800
Message-ID: <1623064692-24205-2-git-send-email-huangguangbin2@huawei.com>
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

Error handling and recovery logic are intertwined. Error handling (i.e.
error identification, clearing error sources and initiation of recovery)
is done in context of reset task. If certain hardware errors get
delivered during driver init time, which can cause driver init/loading
to fail.

Introduce a separate error handling task to ensure below:

1. Reset logic remains independent of the error handling logic.
2. Add the hclge_errhand_task_schedule to schedule error recovery
tasks, This will ensure that common misellaneous MSI-X interrupt are
re-enabled quickly.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  4 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 38 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 8223d699cd94..f125aa425872 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1940,8 +1940,8 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 
 	if (!test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state)) {
 		dev_err(dev,
-			"Can't handle - MSIx error reported during dev init\n");
-		return 0;
+			"failed to handle msix error during dev init\n");
+		return -EAGAIN;
 	}
 
 	return hclge_handle_all_hw_msix_error(hdev, reset_requests);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6ecc106af334..8a431e124adb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2843,6 +2843,14 @@ static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 				    hclge_wq, &hdev->service_task, 0);
 }
 
+static void hclge_errhand_task_schedule(struct hclge_dev *hdev)
+{
+	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
+	    !test_and_set_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
+		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
+				    hclge_wq, &hdev->service_task, 0);
+}
+
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
@@ -4264,6 +4272,36 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 	hdev->reset_type = HNAE3_NONE_RESET;
 }
 
+static void hclge_misc_err_recovery(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct device *dev = &hdev->pdev->dev;
+	u32 msix_sts_reg;
+
+	msix_sts_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
+
+	if (msix_sts_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
+		if (hclge_handle_hw_msix_error(hdev,
+					       &hdev->default_reset_request))
+			dev_info(dev, "received msix interrupt 0x%x\n",
+				 msix_sts_reg);
+
+		if (hdev->default_reset_request)
+			if (ae_dev->ops->reset_event)
+				ae_dev->ops->reset_event(hdev->pdev, NULL);
+	}
+
+	hclge_enable_vector(&hdev->misc_vector, true);
+}
+
+static void hclge_errhand_service_task(struct hclge_dev *hdev)
+{
+	if (!test_and_clear_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
+		return;
+
+	hclge_misc_err_recovery(hdev);
+}
+
 static void hclge_reset_service_task(struct hclge_dev *hdev)
 {
 	if (!test_and_clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7595f841aaac..9b8abb5d7a8e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -221,6 +221,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_RST_HANDLING,
 	HCLGE_STATE_MBX_SERVICE_SCHED,
 	HCLGE_STATE_MBX_HANDLING,
+	HCLGE_STATE_ERR_SERVICE_SCHED,
 	HCLGE_STATE_STATISTICS_UPDATING,
 	HCLGE_STATE_CMD_DISABLE,
 	HCLGE_STATE_LINK_UPDATING,
-- 
2.8.1

