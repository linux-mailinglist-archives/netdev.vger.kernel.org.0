Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29AC277CE6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIYA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14230 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbgIYA3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:06 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB363E89807D430A4C36;
        Fri, 25 Sep 2020 08:29:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/6] net: hns3: add a hardware error detect type
Date:   Fri, 25 Sep 2020 08:26:15 +0800
Message-ID: <1600993578-41008-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

In hns3_process_hw_error(), the hardware error detection of the
ROCEE AXI RESP error type is added. When this error occurs,
the client needs to be notified of this error and take
corresponding operation.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h            | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c        | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 088550d..55843ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -152,6 +152,7 @@ enum hnae3_hw_error_type {
 	HNAE3_PPU_POISON_ERROR,
 	HNAE3_CMDQ_ECC_ERROR,
 	HNAE3_IMP_RD_POISON_ERROR,
+	HNAE3_ROCEE_AXI_RESP_ERROR,
 };
 
 enum hnae3_reset_type {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0542033..e886700 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4600,6 +4600,8 @@ static const struct hns3_hw_error_info hns3_hw_err[] = {
 	  .msg = "IMP CMDQ error" },
 	{ .type = HNAE3_IMP_RD_POISON_ERROR,
 	  .msg = "IMP RD poison" },
+	{ .type = HNAE3_ROCEE_AXI_RESP_ERROR,
+	  .msg = "ROCEE AXI RESP error" },
 };
 
 static void hns3_process_hw_error(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 50d5ef7..39b7f71 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1507,6 +1507,8 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 
 		reset_type = HNAE3_FUNC_RESET;
 
+		hclge_report_hw_error(hdev, HNAE3_ROCEE_AXI_RESP_ERROR);
+
 		ret = hclge_log_rocee_axi_error(hdev);
 		if (ret)
 			return HNAE3_GLOBAL_RESET;
-- 
2.7.4

