Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952A544C267
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhKJNuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:22 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27194 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhKJNuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:17 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hq5hr3n44z8tt0;
        Wed, 10 Nov 2021 21:45:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/8] net: hns3: fix ROCE base interrupt vector initialization bug
Date:   Wed, 10 Nov 2021 21:42:50 +0800
Message-ID: <20211110134256.25025-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, NIC init ROCE interrupt vector with MSIX interrupt. But ROCE use
pci_irq_vector() to get interrupt vector, which adds the relative interrupt
vector again and gets wrong interrupt vector.

So fixes it by assign relative interrupt vector to ROCE instead of MSIX
interrupt vector and delete the unused struct member base_msi_vector
declaration of hclgevf_dev.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 +-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 --
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index eb96bea9e3ce..0fc2b81f4712 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2581,7 +2581,7 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 	if (hdev->num_msi < hdev->num_nic_msi + hdev->num_roce_msi)
 		return -EINVAL;
 
-	roce->rinfo.base_vector = hdev->roce_base_vector;
+	roce->rinfo.base_vector = hdev->num_nic_msi;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = hdev->hw.io_base;
@@ -2617,10 +2617,6 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
 
-	hdev->base_msi_vector = pdev->irq;
-	hdev->roce_base_vector = hdev->base_msi_vector +
-				hdev->num_nic_msi;
-
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
 	if (!hdev->vector_status) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e1eede599ec..21013776de55 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -904,12 +904,10 @@ struct hclge_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
-	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
 	u16 num_nic_msi;	/* Num of nic vectors for this PF */
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
-	int roce_base_vector;
 
 	unsigned long service_timer_period;
 	unsigned long service_timer_previous;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 645b2c0011e6..98332dad804d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2557,7 +2557,7 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 	    hdev->num_msi_left == 0)
 		return -EINVAL;
 
-	roce->rinfo.base_vector = hdev->roce_base_vector;
+	roce->rinfo.base_vector = hdev->roce_base_msix_offset;
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = hdev->hw.io_base;
@@ -2823,9 +2823,6 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
 
-	hdev->base_msi_vector = pdev->irq;
-	hdev->roce_base_vector = pdev->irq + hdev->roce_base_msix_offset;
-
 	hdev->vector_status = devm_kcalloc(&pdev->dev, hdev->num_msi,
 					   sizeof(u16), GFP_KERNEL);
 	if (!hdev->vector_status) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 28288d7e3303..4bd922b47501 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -308,8 +308,6 @@ struct hclgevf_dev {
 	u16 num_nic_msix;	/* Num of nic vectors for this VF */
 	u16 num_roce_msix;	/* Num of roce vectors for this VF */
 	u16 roce_base_msix_offset;
-	int roce_base_vector;
-	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
 
-- 
2.33.0

