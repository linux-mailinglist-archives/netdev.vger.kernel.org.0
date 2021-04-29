Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FA836E715
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbhD2Ifn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:35:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16172 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhD2Ifm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:35:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FW7yV2PHxzlW2f;
        Thu, 29 Apr 2021 16:31:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 16:34:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/3] net: hns3: fix incorrect configuration for igu_egu_hw_err
Date:   Thu, 29 Apr 2021 16:34:50 +0800
Message-ID: <1619685292-46644-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
References: <1619685292-46644-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

According to the UM, the type and enable status of igu_egu_hw_err
should be configured separately. Currently, the type field is
incorrect when disable this error. So fix it by configuring these
two fields separately.

Fixes: bf1faf9415dd ("net: hns3: Add enable and process hw errors from IGU, EGU and NCSI")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 0ca7f1b..78d3eb1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -753,8 +753,9 @@ static int hclge_config_igu_egu_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure IGU,EGU error interrupts */
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_IGU_COMMON_INT_EN, false);
+	desc.data[0] = cpu_to_le32(HCLGE_IGU_ERR_INT_TYPE);
 	if (en)
-		desc.data[0] = cpu_to_le32(HCLGE_IGU_ERR_INT_EN);
+		desc.data[0] |= cpu_to_le32(HCLGE_IGU_ERR_INT_EN);
 
 	desc.data[1] = cpu_to_le32(HCLGE_IGU_ERR_INT_EN_MASK);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 608fe26..d647f3c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -32,7 +32,8 @@
 #define HCLGE_TQP_ECC_ERR_INT_EN_MASK	0x0FFF
 #define HCLGE_MSIX_SRAM_ECC_ERR_INT_EN_MASK	0x0F000000
 #define HCLGE_MSIX_SRAM_ECC_ERR_INT_EN	0x0F000000
-#define HCLGE_IGU_ERR_INT_EN	0x0000066F
+#define HCLGE_IGU_ERR_INT_EN	0x0000000F
+#define HCLGE_IGU_ERR_INT_TYPE	0x00000660
 #define HCLGE_IGU_ERR_INT_EN_MASK	0x000F
 #define HCLGE_IGU_TNL_ERR_INT_EN    0x0002AABF
 #define HCLGE_IGU_TNL_ERR_INT_EN_MASK  0x003F
-- 
2.7.4

