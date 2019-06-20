Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF304CA09
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbfFTIzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:55:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42462 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731450AbfFTIyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9D0E7174FB50B2EE36AA;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/11] net: hns3: code optimizaition of hclge_handle_hw_ras_error()
Date:   Thu, 20 Jun 2019 16:52:39 +0800
Message-ID: <1561020765-14481-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

This patch optimizes hclge_handle_hw_ras_error() to make the code logic
clearer.
1. If there was no NIC or Roce RAS when we read
   HCLGE_RAS_PF_OTHER_INT_STS_REG, we return directly.
2. Because NIC and Roce RAS may occurs at the same time, so we should
   check value of revision at first before we handle Roce RAS instead
   of only checking it in branch of no NIC RAS is detected.
3. Check HCLGE_STATE_RST_HANDLING each time before we want to return
   PCI_ERS_RESULT_NEED_RESET.
4. Remove checking of HCLGE_RAS_REG_NFE_MASK and
   HCLGE_RAS_REG_ROCEE_ERR_MASK because if hw_err_reset_req is not
   zero, it proves that we have set it in handling of NIC or Roce RAS.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index fb616cb..3dfb265 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1606,6 +1606,8 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	if (status & HCLGE_RAS_REG_NFE_MASK ||
 	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK)
 		ae_dev->hw_err_reset_req = 0;
+	else
+		goto out;
 
 	/* Handling Non-fatal HNS RAS errors */
 	if (status & HCLGE_RAS_REG_NFE_MASK) {
@@ -1613,27 +1615,25 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 			 "HNS Non-Fatal RAS error(status=0x%x) identified\n",
 			 status);
 		hclge_handle_all_ras_errors(hdev);
-	} else {
-		if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
-		    hdev->pdev->revision < 0x21) {
-			ae_dev->override_pci_need_reset = 1;
-			return PCI_ERS_RESULT_RECOVERED;
-		}
 	}
 
-	if (status & HCLGE_RAS_REG_ROCEE_ERR_MASK) {
-		dev_warn(dev, "ROCEE uncorrected RAS error identified\n");
+	/* Handling Non-fatal Rocee RAS errors */
+	if (hdev->pdev->revision >= 0x21 &&
+	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK) {
+		dev_warn(dev, "ROCEE Non-Fatal RAS error identified\n");
 		hclge_handle_rocee_ras_error(ae_dev);
 	}
 
-	if ((status & HCLGE_RAS_REG_NFE_MASK ||
-	     status & HCLGE_RAS_REG_ROCEE_ERR_MASK) &&
-	     ae_dev->hw_err_reset_req) {
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		goto out;
+
+	if (ae_dev->hw_err_reset_req) {
 		ae_dev->override_pci_need_reset = 0;
 		return PCI_ERS_RESULT_NEED_RESET;
 	}
-	ae_dev->override_pci_need_reset = 1;
 
+out:
+	ae_dev->override_pci_need_reset = 1;
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
-- 
2.7.4

