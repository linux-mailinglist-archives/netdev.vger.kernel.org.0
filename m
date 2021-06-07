Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED0139DB1C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhFGLXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:23:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4338 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhFGLXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:23:13 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fz9mb36hFz1BKml;
        Mon,  7 Jun 2021 19:16:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 19:21:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/3] net: hns3: remove now redundant logic related to HNAE3_UNKNOWN_RESET
Date:   Mon, 7 Jun 2021 19:18:12 +0800
Message-ID: <1623064692-24205-4-git-send-email-huangguangbin2@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

Earlier patches have decoupled the MSI-X conveyed error handling
and recovery logic. This earlier concept code is no longer required.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 22 ----------------------
 2 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 89b2b7fa7b8b..dc9b5bc3431b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -243,7 +243,6 @@ enum hnae3_reset_type {
 	HNAE3_FUNC_RESET,
 	HNAE3_GLOBAL_RESET,
 	HNAE3_IMP_RESET,
-	HNAE3_UNKNOWN_RESET,
 	HNAE3_NONE_RESET,
 	HNAE3_MAX_RESET,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4b1aa5c45852..45102681bd2a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3792,28 +3792,6 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
 	struct hclge_dev *hdev = ae_dev->priv;
 
-	/* first, resolve any unknown reset type to the known type(s) */
-	if (test_bit(HNAE3_UNKNOWN_RESET, addr)) {
-		u32 msix_sts_reg = hclge_read_dev(&hdev->hw,
-					HCLGE_MISC_VECTOR_INT_STS);
-		/* we will intentionally ignore any errors from this function
-		 *  as we will end up in *some* reset request in any case
-		 */
-		if (hclge_handle_hw_msix_error(hdev, addr))
-			dev_info(&hdev->pdev->dev, "received msix interrupt 0x%x\n",
-				 msix_sts_reg);
-
-		clear_bit(HNAE3_UNKNOWN_RESET, addr);
-		/* We defered the clearing of the error event which caused
-		 * interrupt since it was not posssible to do that in
-		 * interrupt context (and this is the reason we introduced
-		 * new UNKNOWN reset type). Now, the errors have been
-		 * handled and cleared in hardware we can safely enable
-		 * interrupts. This is an exception to the norm.
-		 */
-		hclge_enable_vector(&hdev->misc_vector, true);
-	}
-
 	/* return the highest priority reset level amongst all */
 	if (test_bit(HNAE3_IMP_RESET, addr)) {
 		rst_level = HNAE3_IMP_RESET;
-- 
2.8.1

