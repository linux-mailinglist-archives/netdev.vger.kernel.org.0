Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75DE43E70
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbfFMPuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:50:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18146 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731695AbfFMJOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:17 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 355D28786EA0F2F2D657;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:07 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: some changes of MSI-X bits in PPU(RCB)
Date:   Thu, 13 Jun 2019 17:12:25 +0800
Message-ID: <1560417152-53050-6-git-send-email-tanhuazhong@huawei.com>
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

From: Weihang Li <liweihang@hisilicon.com>

This patch modifies print message of rx_q_search_miss from error to dfx to
prevent misleading users, because this interrupt may occur if we receive
packets during initialization of HNS3 driver.
Otherwise, this patch masks 28th bit of PPU_MPF_ABNORMAL_SRC2 which is now
meaningless.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 5 ++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index ab9c5d5..3e0d6ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1780,9 +1780,8 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 	status = le32_to_cpu(*(desc_data + 2)) &
 			HCLGE_PPU_MPF_INT_ST2_MSIX_MASK;
 	if (status)
-		hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
-				&hclge_ppu_mpf_abnormal_int_st2[0],
-				status, reset_requests);
+		dev_warn(dev, "PPU_MPF_ABNORMAL_INT_ST2 rx_q_search_miss found [dfx status=0x%x\n]",
+			 status);
 
 	/* clear all main PF MSIx errors */
 	ret = hclge_clear_hw_msix_error(hdev, desc, true, mpf_bd_num);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index d821a76..db318a4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -81,7 +81,7 @@
 #define HCLGE_IGU_EGU_TNL_INT_MASK	GENMASK(5, 0)
 #define HCLGE_PPP_MPF_INT_ST3_MASK	GENMASK(5, 0)
 #define HCLGE_PPU_MPF_INT_ST3_MASK	GENMASK(7, 0)
-#define HCLGE_PPU_MPF_INT_ST2_MSIX_MASK	GENMASK(29, 28)
+#define HCLGE_PPU_MPF_INT_ST2_MSIX_MASK	BIT(29)
 #define HCLGE_PPU_PF_INT_RAS_MASK	0x18
 #define HCLGE_PPU_PF_INT_MSIX_MASK	0x26
 #define HCLGE_PPU_PF_OVER_8BD_ERR_MASK	0x01
-- 
2.7.4

