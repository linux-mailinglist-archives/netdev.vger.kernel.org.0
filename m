Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24A0465FB6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356129AbhLBIoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32866 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345684AbhLBIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:10 -0500
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J4TtZ06xczcbl5;
        Thu,  2 Dec 2021 16:40:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 7/9] net: hns3: refactor function hclge_configure()
Date:   Thu, 2 Dec 2021 16:36:01 +0800
Message-ID: <20211202083603.25176-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently  hclge_configure() is a bit long. Refactor it by extracting sub
process to improve the readability.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 53 ++++++++++---------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4a52d18f4166..996ba57b8155 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1613,12 +1613,39 @@ static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
 	hdev->num_rx_desc = HCLGE_MIN_RX_DESC;
 }
 
+static void hclge_init_tc_config(struct hclge_dev *hdev)
+{
+	unsigned int i;
+
+	if (hdev->tc_max > HNAE3_MAX_TC ||
+	    hdev->tc_max < 1) {
+		dev_warn(&hdev->pdev->dev, "TC num = %u.\n",
+			 hdev->tc_max);
+		hdev->tc_max = 1;
+	}
+
+	/* Dev does not support DCB */
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		hdev->tc_max = 1;
+		hdev->pfc_max = 0;
+	} else {
+		hdev->pfc_max = hdev->tc_max;
+	}
+
+	hdev->tm_info.num_tc = 1;
+
+	/* Currently not support uncontiuous tc */
+	for (i = 0; i < hdev->tm_info.num_tc; i++)
+		hnae3_set_bit(hdev->hw_tc_map, i, 1);
+
+	hdev->tx_sch_mode = HCLGE_FLAG_TC_BASE_SCH_MODE;
+}
+
 static int hclge_configure(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	const struct cpumask *cpumask = cpu_online_mask;
 	struct hclge_cfg cfg;
-	unsigned int i;
 	int node, ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
@@ -1662,29 +1689,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	hdev->hw.mac.max_speed = hclge_get_max_speed(cfg.speed_ability);
 
-	if ((hdev->tc_max > HNAE3_MAX_TC) ||
-	    (hdev->tc_max < 1)) {
-		dev_warn(&hdev->pdev->dev, "TC num = %u.\n",
-			 hdev->tc_max);
-		hdev->tc_max = 1;
-	}
-
-	/* Dev does not support DCB */
-	if (!hnae3_dev_dcb_supported(hdev)) {
-		hdev->tc_max = 1;
-		hdev->pfc_max = 0;
-	} else {
-		hdev->pfc_max = hdev->tc_max;
-	}
-
-	hdev->tm_info.num_tc = 1;
-
-	/* Currently not support uncontiuous tc */
-	for (i = 0; i < hdev->tm_info.num_tc; i++)
-		hnae3_set_bit(hdev->hw_tc_map, i, 1);
-
-	hdev->tx_sch_mode = HCLGE_FLAG_TC_BASE_SCH_MODE;
-
+	hclge_init_tc_config(hdev);
 	hclge_init_kdump_kernel_config(hdev);
 
 	/* Set the affinity based on numa node */
-- 
2.33.0

