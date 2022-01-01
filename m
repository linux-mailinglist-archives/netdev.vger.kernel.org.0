Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108D648288B
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 22:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiAAVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 16:15:35 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:65221 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAAVPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 16:15:35 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3lisnPd6Q1yYB3lisn10zq; Sat, 01 Jan 2022 22:15:33 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 01 Jan 2022 22:15:33 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     bigeasy@linutronix.de, davem@davemloft.net, kuba@kernel.org,
        tanhuazhong@huawei.com, arnd@arndb.de, moyufeng@huawei.com,
        chenhao288@hisilicon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] chelsio: cxgb: Use dma_set_mask_and_coherent() and simplify code
Date:   Sat,  1 Jan 2022 22:15:29 +0100
Message-Id: <80d7dd276d9be857f090fbe1f3dbbdc4b07141ec.1641071656.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_set_mask_and_coherent() instead of unrolling it with some
dma_set_mask()+dma_set_coherent_mask().

Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
fail if dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

That said, 'pci_using_dac' can only be 1 after a successful
dma_set_mask_and_coherent().

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 18acd7cf3d6d..f4054d2553ea 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -944,11 +944,11 @@ static const struct net_device_ops cxgb_netdev_ops = {
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int i, err, pci_using_dac = 0;
 	unsigned long mmio_start, mmio_len;
 	const struct board_info *bi;
 	struct adapter *adapter = NULL;
 	struct port_info *pi;
+	int i, err;
 
 	err = pci_enable_device(pdev);
 	if (err)
@@ -961,17 +961,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_pdev;
 	}
 
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-
-		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-			pr_err("%s: unable to obtain 64-bit DMA for coherent allocations\n",
-			       pci_name(pdev));
-			err = -ENODEV;
-			goto out_disable_pdev;
-		}
-
-	} else if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) != 0) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
 		pr_err("%s: no usable DMA configuration\n", pci_name(pdev));
 		goto out_disable_pdev;
 	}
@@ -1043,10 +1034,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
 			NETIF_F_RXCSUM;
 		netdev->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_LLTX;
+			NETIF_F_RXCSUM | NETIF_F_LLTX | NETIF_F_HIGHDMA;
 
-		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
 		if (vlan_tso_capable(adapter)) {
 			netdev->features |=
 				NETIF_F_HW_VLAN_CTAG_TX |
-- 
2.32.0

