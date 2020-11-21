Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42912BBE28
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 10:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgKUJDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 04:03:35 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55275 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKUJDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 04:03:34 -0500
Received: from localhost.localdomain ([81.185.161.242])
        by mwinf5d61 with ME
        id ux3V2300L5E5lq903x3Wfh; Sat, 21 Nov 2020 10:03:31 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 21 Nov 2020 10:03:31 +0100
X-ME-IP: 81.185.161.242
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, kaixuxia@tencent.com,
        mhabets@solarflare.com, mst@redhat.com,
        luc.vanoostenryck@gmail.com, jesse.brandeburg@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] net: pch_gbe: Use 'dma_free_coherent()' to undo 'dma_alloc_coherent()'
Date:   Sat, 21 Nov 2020 10:03:30 +0100
Message-Id: <20201121090330.1332543-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory allocation are done with 'dma_alloc_coherent()'. Be consistent
and use 'dma_free_coherent()' to free the corresponding memory.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 8e4255efe829..140cee7c459d 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1816,7 +1816,8 @@ void pch_gbe_free_tx_resources(struct pch_gbe_adapter *adapter,
 	pch_gbe_clean_tx_ring(adapter, tx_ring);
 	vfree(tx_ring->buffer_info);
 	tx_ring->buffer_info = NULL;
-	pci_free_consistent(pdev, tx_ring->size, tx_ring->desc, tx_ring->dma);
+	dma_free_coherent(&pdev->dev, tx_ring->size, tx_ring->desc,
+			  tx_ring->dma);
 	tx_ring->desc = NULL;
 }
 
@@ -1833,7 +1834,8 @@ void pch_gbe_free_rx_resources(struct pch_gbe_adapter *adapter,
 	pch_gbe_clean_rx_ring(adapter, rx_ring);
 	vfree(rx_ring->buffer_info);
 	rx_ring->buffer_info = NULL;
-	pci_free_consistent(pdev, rx_ring->size, rx_ring->desc, rx_ring->dma);
+	dma_free_coherent(&pdev->dev, rx_ring->size, rx_ring->desc,
+			  rx_ring->dma);
 	rx_ring->desc = NULL;
 }
 
@@ -1954,8 +1956,8 @@ void pch_gbe_down(struct pch_gbe_adapter *adapter)
 	pch_gbe_clean_tx_ring(adapter, adapter->tx_ring);
 	pch_gbe_clean_rx_ring(adapter, adapter->rx_ring);
 
-	pci_free_consistent(adapter->pdev, rx_ring->rx_buff_pool_size,
-			    rx_ring->rx_buff_pool, rx_ring->rx_buff_pool_logic);
+	dma_free_coherent(&adapter->pdev->dev, rx_ring->rx_buff_pool_size,
+			  rx_ring->rx_buff_pool, rx_ring->rx_buff_pool_logic);
 	rx_ring->rx_buff_pool_logic = 0;
 	rx_ring->rx_buff_pool_size = 0;
 	rx_ring->rx_buff_pool = NULL;
-- 
2.27.0

