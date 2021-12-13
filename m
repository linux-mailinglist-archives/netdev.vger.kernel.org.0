Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82F4722B2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhLMI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:29:12 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57091 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhLMI3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 03:29:11 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 718C2240004;
        Mon, 13 Dec 2021 08:29:04 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: ocelot: use dma_unmap_addr to get tx buffer dma_addr
Date:   Mon, 13 Dec 2021 09:26:51 +0100
Message-Id: <20211213082651.443577-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_addr was declared using DEFINE_DMA_UNMAP_ADDR() which requires to
use dma_unmap_addr() to access it.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index 350a0b52f021..dffa597bffe6 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -734,8 +734,8 @@ static void ocelot_fdma_free_tx_ring(struct ocelot *ocelot)
 	while (idx != tx_ring->next_to_use) {
 		txb = &tx_ring->bufs[idx];
 		skb = txb->skb;
-		dma_unmap_single(ocelot->dev, txb->dma_addr, skb->len,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(ocelot->dev, dma_unmap_addr(txb, dma_addr),
+				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		idx = ocelot_fdma_idx_next(idx, OCELOT_FDMA_TX_RING_SIZE);
 	}
-- 
2.34.1

