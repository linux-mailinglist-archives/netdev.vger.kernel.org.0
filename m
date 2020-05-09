Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099F1CBFCD
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgEIJ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:29:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727086AbgEIJ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 05:28:58 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 449ED30C1BFFC6CF611A;
        Sat,  9 May 2020 17:28:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:28:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: remove a redundant register macro definition
Date:   Sat, 9 May 2020 17:27:37 +0800
Message-ID: <1589016461-10130-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HCLGE_MISC_VECTOR_INT_STS and HCLGE_VECTOR_PF_OTHER_INT_STS_REG
both represent the misc interrupt status register(0x20800), so
removes HCLGE_VECTOR_PF_OTHER_INT_STS_REG and replaces it with
HCLGE_MISC_VECTOR_INT_STS.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h  |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 876fd81a..608fe26 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -16,7 +16,6 @@
 #define HCLGE_RAS_REG_NFE_MASK   0xFF00
 #define HCLGE_RAS_REG_ROCEE_ERR_MASK   0x3000000
 
-#define HCLGE_VECTOR0_PF_OTHER_INT_STS_REG   0x20800
 #define HCLGE_VECTOR0_REG_MSIX_MASK   0x1FF00
 
 #define HCLGE_IMP_TCM_ECC_ERR_INT_EN	0xFFFF0000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 71a54dd..f0b1dc9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2968,13 +2968,11 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
-	u32 rst_src_reg, cmdq_src_reg, msix_src_reg;
+	u32 cmdq_src_reg, msix_src_reg;
 
 	/* fetch the events from their corresponding regs */
-	rst_src_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
 	cmdq_src_reg = hclge_read_dev(&hdev->hw, HCLGE_VECTOR0_CMDQ_SRC_REG);
-	msix_src_reg = hclge_read_dev(&hdev->hw,
-				      HCLGE_VECTOR0_PF_OTHER_INT_STS_REG);
+	msix_src_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
 
 	/* Assumption: If by any chance reset and mailbox events are reported
 	 * together then we will only process reset event in this go and will
@@ -2984,7 +2982,7 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 	 *
 	 * check for vector0 reset event sources
 	 */
-	if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & rst_src_reg) {
+	if (BIT(HCLGE_VECTOR0_IMPRESET_INT_B) & msix_src_reg) {
 		dev_info(&hdev->pdev->dev, "IMP reset interrupt\n");
 		set_bit(HNAE3_IMP_RESET, &hdev->reset_pending);
 		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
@@ -2993,7 +2991,7 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 		return HCLGE_VECTOR0_EVENT_RST;
 	}
 
-	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & rst_src_reg) {
+	if (BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B) & msix_src_reg) {
 		dev_info(&hdev->pdev->dev, "global reset interrupt\n");
 		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 		set_bit(HNAE3_GLOBAL_RESET, &hdev->reset_pending);
@@ -3483,7 +3481,7 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 	/* first, resolve any unknown reset type to the known type(s) */
 	if (test_bit(HNAE3_UNKNOWN_RESET, addr)) {
 		u32 msix_sts_reg = hclge_read_dev(&hdev->hw,
-					HCLGE_VECTOR0_PF_OTHER_INT_STS_REG);
+					HCLGE_MISC_VECTOR_INT_STS);
 		/* we will intentionally ignore any errors from this function
 		 *  as we will end up in *some* reset request in any case
 		 */
-- 
2.7.4

