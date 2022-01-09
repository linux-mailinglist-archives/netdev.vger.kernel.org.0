Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F114B4889B8
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiAINxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:53:33 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:51599 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiAINxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:53:33 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6YdXnCf5oUujj6YdXnIXeC; Sun, 09 Jan 2022 14:53:32 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 14:53:32 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] cxgb4: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 14:53:27 +0100
Message-Id: <56db10d53be0897ff1be5f37d64b91cb7e1d932c.1641736387.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'highdma' is known to be true.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index dde1cf51d0ab..0c78c0db8937 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6608,7 +6608,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int adap_idx = 1;
 	int s_qpp, qpp, num_seg;
 	struct port_info *pi;
-	bool highdma = false;
 	enum chip_type chip;
 	void __iomem *regs;
 	int func, chip_ver;
@@ -6687,14 +6686,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return 0;
 	}
 
-	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
-		highdma = true;
-	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto out_free_adapter;
-		}
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto out_free_adapter;
 	}
 
 	pci_enable_pcie_error_reporting(pdev);
@@ -6823,7 +6818,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC | NETIF_F_NTUPLE;
+			NETIF_F_HW_TC | NETIF_F_NTUPLE | NETIF_F_HIGHDMA;
 
 		if (chip_ver > CHELSIO_T5) {
 			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
@@ -6841,8 +6836,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
-		if (highdma)
-			netdev->hw_features |= NETIF_F_HIGHDMA;
 		netdev->features |= netdev->hw_features;
 		netdev->vlan_features = netdev->features & VLAN_FEAT;
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
-- 
2.32.0

