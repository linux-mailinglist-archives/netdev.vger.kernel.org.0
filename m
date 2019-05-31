Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E430AE2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfEaI51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:57:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbfEaI4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:39 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3B04956F9E58EF8E01CB;
        Fri, 31 May 2019 16:56:37 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: add a check to pointer in error_detected and slot_reset
Date:   Fri, 31 May 2019 16:54:51 +0800
Message-ID: <1559292898-64090-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

If we add a VF without loading hclgevf.ko and then there is a RAS error
occurs, PCIe AER will call error_detected and slot_reset of all functions,
and will get a NULL pointer when we check ad_dev->ops->handle_hw_ras_error.
This will cause a call trace and failures on handling of follow-up RAS
errors.

This patch check ae_dev and ad_dev->ops at first to solve above issues.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1e68bcb..0501b78 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1920,9 +1920,9 @@ static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	if (!ae_dev) {
+	if (!ae_dev || !ae_dev->ops) {
 		dev_err(&pdev->dev,
-			"Can't recover - error happened during device init\n");
+			"Can't recover - error happened before device initialized\n");
 		return PCI_ERS_RESULT_NONE;
 	}
 
@@ -1941,6 +1941,9 @@ static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 
 	dev_info(dev, "requesting reset due to PCI error\n");
 
+	if (!ae_dev || !ae_dev->ops)
+		return PCI_ERS_RESULT_NONE;
+
 	/* request the reset */
 	if (ae_dev->ops->reset_event) {
 		if (!ae_dev->override_pci_need_reset)
-- 
2.7.4

