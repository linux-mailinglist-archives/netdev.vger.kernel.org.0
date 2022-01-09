Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12D488A51
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 16:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbiAIPua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 10:50:30 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:65149 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiAIPu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 10:50:29 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6aShnj1ubIEdl6aShnROx1; Sun, 09 Jan 2022 16:50:28 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 16:50:28 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] lan743x: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 16:50:19 +0100
Message-Id: <ef548716606f257939df9738a801f15b6edf2568.1641743405.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7d7647481f70..8c6390d95158 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1739,13 +1739,10 @@ static int lan743x_tx_ring_init(struct lan743x_tx *tx)
 	}
 	if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
 				      DMA_BIT_MASK(64))) {
-		if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
-					      DMA_BIT_MASK(32))) {
-			dev_warn(&tx->adapter->pdev->dev,
-				 "lan743x_: No suitable DMA available\n");
-			ret = -ENOMEM;
-			goto cleanup;
-		}
+		dev_warn(&tx->adapter->pdev->dev,
+			 "lan743x_: No suitable DMA available\n");
+		ret = -ENOMEM;
+		goto cleanup;
 	}
 	ring_allocation_size = ALIGN(tx->ring_size *
 				     sizeof(struct lan743x_tx_descriptor),
@@ -2284,13 +2281,10 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 	}
 	if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
 				      DMA_BIT_MASK(64))) {
-		if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
-					      DMA_BIT_MASK(32))) {
-			dev_warn(&rx->adapter->pdev->dev,
-				 "lan743x_: No suitable DMA available\n");
-			ret = -ENOMEM;
-			goto cleanup;
-		}
+		dev_warn(&rx->adapter->pdev->dev,
+			 "lan743x_: No suitable DMA available\n");
+		ret = -ENOMEM;
+		goto cleanup;
 	}
 	ring_allocation_size = ALIGN(rx->ring_size *
 				     sizeof(struct lan743x_rx_descriptor),
-- 
2.32.0

