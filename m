Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6A408C24
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbhIMNN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:13:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9425 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc41JhLz8yVj;
        Mon, 13 Sep 2021 21:08:04 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 3/6] net: hns3: change affinity_mask to numa node range
Date:   Mon, 13 Sep 2021 21:08:22 +0800
Message-ID: <20210913130825.27025-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130825.27025-1-huangguangbin2@huawei.com>
References: <20210913130825.27025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, affinity_mask is set to a single cpu. As a result,
irqbalance becomes invalid in SUBSET or EXACT mode. To solve
this problem, change affinity_mask to numa node range. In this
way, irqbalance can be performed on the cpu of the numa node.

Fixes: 0812545487ec ("net: hns3: add interrupt affinity support for misc interrupt")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e55ba2e511b1..aed97c934bfb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1528,9 +1528,10 @@ static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
 static int hclge_configure(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	const struct cpumask *cpumask = cpu_online_mask;
 	struct hclge_cfg cfg;
 	unsigned int i;
-	int ret;
+	int node, ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
 	if (ret)
@@ -1595,11 +1596,12 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	hclge_init_kdump_kernel_config(hdev);
 
-	/* Set the init affinity based on pci func number */
-	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev->dev)));
-	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
-	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev->pdev->dev)),
-			&hdev->affinity_mask);
+	/* Set the affinity based on numa node */
+	node = dev_to_node(&hdev->pdev->dev);
+	if (node != NUMA_NO_NODE)
+		cpumask = cpumask_of_node(node);
+
+	cpumask_copy(&hdev->affinity_mask, cpumask);
 
 	return ret;
 }
-- 
2.33.0

