Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEBA2B1A20
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKMLcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:32:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7496 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgKML3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:29:55 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CXbpj6Ky2zhgGr;
        Fri, 13 Nov 2020 19:29:33 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Nov 2020
 19:29:35 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <oleksandr.mazur@plvision.eu>, <vadym.kochan@plvision.eu>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: marvell: prestera: fix error return code in prestera_pci_probe()
Date:   Fri, 13 Nov 2020 19:32:36 +0800
Message-ID: <20201113113236.71678-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 4c2703dfd7fa ("net: marvell: prestera: Add PCI interface support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 1b97adae542e..be5677623455 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -676,7 +676,8 @@ static int prestera_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30));
+	if (err) {
 		dev_err(&pdev->dev, "fail to set DMA mask\n");
 		goto err_dma_mask;
 	}
@@ -702,8 +703,10 @@ static int prestera_pci_probe(struct pci_dev *pdev,
 	dev_info(fw->dev.dev, "Prestera FW is ready\n");
 
 	fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
-	if (!fw->wq)
+	if (!fw->wq) {
+		err = -ENOMEM;
 		goto err_wq_alloc;
+	}
 
 	INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
 
-- 
2.17.1

