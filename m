Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D372236F78A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 11:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhD3JHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 05:07:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5143 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhD3JHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 05:07:06 -0400
Received: from dggeml754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FWmdB6HcDzYcNX;
        Fri, 30 Apr 2021 17:03:58 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml754-chm.china.huawei.com (10.1.199.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Apr 2021 17:06:17 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Apr 2021 17:06:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: clear unnecessary reset request in hclge_reset_rebuild
Date:   Fri, 30 Apr 2021 17:06:21 +0800
Message-ID: <1619773582-17828-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
References: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

HW error and global reset are reported through MSIX interrupts.
The same error may be reported to different functions at the
same time. When global reset begins, the pending reset request
set by this error is unnecessary. So clear the pending reset
request after the reset is complete to avoid the repeated reset.

Fixes: f6162d44126c ("net: hns3: add handling of hw errors reported through MSIX")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c296ab6..6304aed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3978,6 +3978,12 @@ static void hclge_update_reset_level(struct hclge_dev *hdev)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	enum hnae3_reset_type reset_level;
 
+	/* reset request will not be set during reset, so clear
+	 * pending reset request to avoid unnecessary reset
+	 * caused by the same reason.
+	 */
+	hclge_get_reset_level(ae_dev, &hdev->reset_request);
+
 	/* if default_reset_request has a higher level reset request,
 	 * it should be handled as soon as possible. since some errors
 	 * need this kind of reset to fix.
-- 
2.7.4

