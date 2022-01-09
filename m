Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DEC488865
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 09:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiAIIwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 03:52:00 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:63576 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiAIIwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 03:52:00 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6TvhnHBR2FGqt6TvhnEcVo; Sun, 09 Jan 2022 09:51:58 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 09:51:58 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ronak Doshi <doshir@vmware.com>, pv-drivers@vmware.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] vmxnet3: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 09:50:22 +0100
Message-Id: <43e5dcf1a5e9e9c5d2d86f87810d6e93e3d22e32.1641718188.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So if dma_set_mask_and_coherent() succeeds, 'dma64' is know to be 'true'.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index fd407c0e2856..d9d90baac72a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3159,14 +3159,14 @@ vmxnet3_change_mtu(struct net_device *netdev, int new_mtu)
 
 
 static void
-vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
+vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
 	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 		NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_LRO;
+		NETIF_F_LRO | NETIF_F_HIGHDMA;
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
 		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
@@ -3179,8 +3179,6 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
 			NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
-	if (dma64)
-		netdev->hw_features |= NETIF_F_HIGHDMA;
 	netdev->vlan_features = netdev->hw_features &
 				~(NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX);
@@ -3397,7 +3395,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #endif
 	};
 	int err;
-	bool dma64;
 	u32 ver;
 	struct net_device *netdev;
 	struct vmxnet3_adapter *adapter;
@@ -3439,15 +3436,10 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	adapter->rx_ring_size = VMXNET3_DEF_RX_RING_SIZE;
 	adapter->rx_ring2_size = VMXNET3_DEF_RX_RING2_SIZE;
 
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) == 0) {
-		dma64 = true;
-	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "dma_set_mask failed\n");
-			goto err_set_mask;
-		}
-		dma64 = false;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "dma_set_mask failed\n");
+		goto err_set_mask;
 	}
 
 	spin_lock_init(&adapter->cmd_lock);
@@ -3614,7 +3606,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	}
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	vmxnet3_declare_features(adapter, dma64);
+	vmxnet3_declare_features(adapter);
 
 	adapter->rxdata_desc_size = VMXNET3_VERSION_GE_3(adapter) ?
 		VMXNET3_DEF_RXDATA_DESC_SIZE : 0;
-- 
2.32.0

