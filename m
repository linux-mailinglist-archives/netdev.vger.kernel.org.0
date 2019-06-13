Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE77143E60
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbfFMPtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731700AbfFMJOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:25 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 47D14962C0FD70911828;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:08 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: clear restting state when initializing HW device
Date:   Thu, 13 Jun 2019 17:12:27 +0800
Message-ID: <1560417152-53050-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

IMP will set restting state for all function when PF FLR, driver
just clear the restting state in resetting progress, but don't do
it in initializing progress. As FLR is not created by driver,
it is necessary to clear restting state when initializing HW device.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6761d72..c1e5a00 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8450,6 +8450,23 @@ static void hclge_flr_done(struct hnae3_ae_dev *ae_dev)
 	set_bit(HNAE3_FLR_DONE, &hdev->flr_state);
 }
 
+static void hclge_clear_resetting_state(struct hclge_dev *hdev)
+{
+	u16 i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hclge_vport *vport = &hdev->vport[i];
+		int ret;
+
+		 /* Send cmd to clear VF's FUNC_RST_ING */
+		ret = hclge_set_vf_rst(hdev, vport->vport_id, false);
+		if (ret)
+			dev_warn(&hdev->pdev->dev,
+				 "clear vf(%d) rst failed %d!\n",
+				 vport->vport_id, ret);
+	}
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -8610,6 +8627,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
 	hclge_clear_all_event_cause(hdev);
+	hclge_clear_resetting_state(hdev);
 
 	/* Log and clear the hw errors those already occurred */
 	hclge_handle_all_hns_hw_errors(ae_dev);
-- 
2.7.4

