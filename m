Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2403A2B571F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgKQCxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:53:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7693 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgKQCxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:53:49 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CZr9P4wnnzkYRC;
        Tue, 17 Nov 2020 10:53:29 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 17 Nov 2020 10:53:41 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hkallweit1@gmail.com>,
        <yanaijie@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <mst@redhat.com>, <leon@kernel.org>, <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] atl1c: fix error return code in atl1c_probe()
Date:   Tue, 17 Nov 2020 10:55:21 +0800
Message-ID: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 0c12cf7..3f65f2b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
-	    (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (err) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
-- 
2.9.5

