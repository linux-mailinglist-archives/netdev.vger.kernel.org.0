Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6441F2B5749
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgKQC4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:56:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8099 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQC4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:56:24 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZrDN2H3tzLntq;
        Tue, 17 Nov 2020 10:56:04 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 17 Nov 2020 10:56:17 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <mst@redhat.com>,
        <leon@kernel.org>, <hkallweit1@gmail.com>, <tglx@linutronix.de>,
        <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] atl1e: fix error return code in atl1e_probe()
Date:   Tue, 17 Nov 2020 10:57:55 +0800
Message-ID: <1605581875-36281-1-git-send-email-zhangchangzhong@huawei.com>
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
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 098b032..ff9f96d 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2312,8 +2312,8 @@ static int atl1e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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

