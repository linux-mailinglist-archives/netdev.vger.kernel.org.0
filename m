Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E0D488479
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiAHQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 11:16:22 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:53576 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiAHQQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 11:16:21 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6EOAnCR2IWUfj6EOAnE8Wo; Sat, 08 Jan 2022 17:16:20 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 08 Jan 2022 17:16:20 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] bna: Simplify DMA setting
Date:   Sat,  8 Jan 2022 17:16:16 +0100
Message-Id: <1d5a7b3f4fa735f1233c3eb3fa07e71df95fad75.1641658516.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'using_dac' is known to be
'true'. This variable can be removed.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 34 ++++++++-----------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index bbdc829c3524..f1d2c4cd5da2 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3421,7 +3421,7 @@ static const struct net_device_ops bnad_netdev_ops = {
 };
 
 static void
-bnad_netdev_init(struct bnad *bnad, bool using_dac)
+bnad_netdev_init(struct bnad *bnad)
 {
 	struct net_device *netdev = bnad->netdev;
 
@@ -3434,10 +3434,8 @@ bnad_netdev_init(struct bnad *bnad, bool using_dac)
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 		NETIF_F_TSO | NETIF_F_TSO6;
 
-	netdev->features |= netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	if (using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER |
+			    NETIF_F_HIGHDMA;
 
 	netdev->mem_start = bnad->mmio_start;
 	netdev->mem_end = bnad->mmio_start + bnad->mmio_len - 1;
@@ -3544,8 +3542,7 @@ bnad_lock_uninit(struct bnad *bnad)
 
 /* PCI Initialization */
 static int
-bnad_pci_init(struct bnad *bnad,
-	      struct pci_dev *pdev, bool *using_dac)
+bnad_pci_init(struct bnad *bnad, struct pci_dev *pdev)
 {
 	int err;
 
@@ -3555,14 +3552,9 @@ bnad_pci_init(struct bnad *bnad,
 	err = pci_request_regions(pdev, BNAD_NAME);
 	if (err)
 		goto disable_device;
-	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
-		*using_dac = true;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err)
-			goto release_regions;
-		*using_dac = false;
-	}
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err)
+		goto release_regions;
 	pci_set_master(pdev);
 	return 0;
 
@@ -3585,7 +3577,6 @@ static int
 bnad_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *pcidev_id)
 {
-	bool	using_dac;
 	int	err;
 	struct bnad *bnad;
 	struct bna *bna;
@@ -3615,13 +3606,8 @@ bnad_pci_probe(struct pci_dev *pdev,
 	bnad->id = atomic_inc_return(&bna_id) - 1;
 
 	mutex_lock(&bnad->conf_mutex);
-	/*
-	 * PCI initialization
-	 *	Output : using_dac = 1 for 64 bit DMA
-	 *			   = 0 for 32 bit DMA
-	 */
-	using_dac = false;
-	err = bnad_pci_init(bnad, pdev, &using_dac);
+	/* PCI initialization */
+	err = bnad_pci_init(bnad, pdev);
 	if (err)
 		goto unlock_mutex;
 
@@ -3634,7 +3620,7 @@ bnad_pci_probe(struct pci_dev *pdev,
 		goto pci_uninit;
 
 	/* Initialize netdev structure, set up ethtool ops */
-	bnad_netdev_init(bnad, using_dac);
+	bnad_netdev_init(bnad);
 
 	/* Set link to down state */
 	netif_carrier_off(netdev);
-- 
2.32.0

