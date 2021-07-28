Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C643D8D81
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhG1MLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:11:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7883 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbhG1MLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 08:11:36 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GZXVD0Qd5z81Cy;
        Wed, 28 Jul 2021 20:07:48 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 28
 Jul 2021 20:11:32 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <venza@brownhat.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] sis900: Fix missing pci_disable_device() in probe and remove
Date:   Wed, 28 Jul 2021 20:11:07 +0800
Message-ID: <20210728121107.273717-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace pci_enable_device() with pcim_enable_device(),
pci_disable_device() and pci_release_regions() will be
called in release automatically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/sis/sis900.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index ca9c00b7f588..cff87de9178a 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -443,7 +443,7 @@ static int sis900_probe(struct pci_dev *pci_dev,
 #endif
 
 	/* setup various bits in PCI command register */
-	ret = pci_enable_device(pci_dev);
+	ret = pcim_enable_device(pci_dev);
 	if(ret) return ret;
 
 	i = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
@@ -469,7 +469,7 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	ioaddr = pci_iomap(pci_dev, 0, 0);
 	if (!ioaddr) {
 		ret = -ENOMEM;
-		goto err_out_cleardev;
+		goto err_out;
 	}
 
 	sis_priv = netdev_priv(net_dev);
@@ -581,8 +581,6 @@ static int sis900_probe(struct pci_dev *pci_dev,
 			  sis_priv->tx_ring_dma);
 err_out_unmap:
 	pci_iounmap(pci_dev, ioaddr);
-err_out_cleardev:
-	pci_release_regions(pci_dev);
  err_out:
 	free_netdev(net_dev);
 	return ret;
@@ -2499,7 +2497,6 @@ static void sis900_remove(struct pci_dev *pci_dev)
 			  sis_priv->tx_ring_dma);
 	pci_iounmap(pci_dev, sis_priv->ioaddr);
 	free_netdev(net_dev);
-	pci_release_regions(pci_dev);
 }
 
 static int __maybe_unused sis900_suspend(struct device *dev)
-- 
2.17.1

