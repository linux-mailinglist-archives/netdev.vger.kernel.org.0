Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E008F482CB1
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiABU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 15:27:43 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:60037 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiABU1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 15:27:43 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 47S8nfS03IEdl47S8n6KhE; Sun, 02 Jan 2022 21:27:41 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 02 Jan 2022 21:27:41 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ethernet: s2io: Use dma_set_mask_and_coherent() and simplify code
Date:   Sun,  2 Jan 2022 21:27:39 +0100
Message-Id: <e53afd59c8938bfaaa94cadd4621d40f54ec2102.1641155181.git.christophe.jaillet@wanadoo.fr>
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

That said, 'dma_flag' can only be 'true' after a successful
dma_set_mask_and_coherent().

Simplify code and remove some dead code accordingly, including the now
useless 'high_dma_flag' field in 'struct s2io_nic'.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/neterion/s2io.c | 18 +++---------------
 drivers/net/ethernet/neterion/s2io.h |  1 -
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index d6ae44f164a9..6dd451adc331 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7658,7 +7658,6 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	struct s2io_nic *sp;
 	struct net_device *dev;
 	int i, j, ret;
-	int dma_flag = false;
 	u32 mac_up, mac_down;
 	u64 val64 = 0, tmp64 = 0;
 	struct XENA_dev_config __iomem *bar0 = NULL;
@@ -7680,17 +7679,8 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 		return ret;
 	}
 
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		DBG_PRINT(INIT_DBG, "%s: Using 64bit DMA\n", __func__);
-		dma_flag = true;
-		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-			DBG_PRINT(ERR_DBG,
-				  "Unable to obtain 64bit DMA for coherent allocations\n");
-			pci_disable_device(pdev);
-			return -ENOMEM;
-		}
-	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		DBG_PRINT(INIT_DBG, "%s: Using 32bit DMA\n", __func__);
 	} else {
 		pci_disable_device(pdev);
 		return -ENOMEM;
@@ -7720,7 +7710,6 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	sp = netdev_priv(dev);
 	sp->dev = dev;
 	sp->pdev = pdev;
-	sp->high_dma_flag = dma_flag;
 	sp->device_enabled_once = false;
 	if (rx_ring_mode == 1)
 		sp->rxd_mode = RXD_MODE_1;
@@ -7868,9 +7857,8 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 		NETIF_F_TSO | NETIF_F_TSO6 |
 		NETIF_F_RXCSUM | NETIF_F_LRO;
 	dev->features |= dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	if (sp->high_dma_flag == true)
-		dev->features |= NETIF_F_HIGHDMA;
+		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+		NETIF_F_HIGHDMA;
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
 	INIT_WORK(&sp->set_link_task, s2io_set_link);
diff --git a/drivers/net/ethernet/neterion/s2io.h b/drivers/net/ethernet/neterion/s2io.h
index a4266d1544ab..cb7080eb5912 100644
--- a/drivers/net/ethernet/neterion/s2io.h
+++ b/drivers/net/ethernet/neterion/s2io.h
@@ -873,7 +873,6 @@ struct s2io_nic {
 	struct mac_addr def_mac_addr[256];
 
 	struct net_device_stats stats;
-	int high_dma_flag;
 	int device_enabled_once;
 
 	char name[60];
-- 
2.32.0

