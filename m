Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96341642AD
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgBSKyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:54:04 -0500
Received: from first.geanix.com ([116.203.34.67]:57128 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSKyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 05:54:04 -0500
Received: from localhost (_gateway [172.20.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id A52EAC002E;
        Wed, 19 Feb 2020 10:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582109640; bh=yH8TvgCUbnfl/izLx4TJFR7NPStHNtUPhDk2EUg7hbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SfV+KvsVtUTU3Q8Ujy7zwg/Dja4IT1GTuJAmkeXVNV1y6ULCzMNiALqN8BV07V7aQ
         LO2X8PDXXQY657KA+LVVvavCX8Kr+PxK1Cnk3HpdvhVFElI/MVyVZy2wOfoMiS7Dr0
         Le3EBMIlIuBOujDmxOWH3tsP4E20Q0UhTaMYCRpvV3Qmx3y3R1mAZHZglyhd3dnMP/
         M9Fb8EVloZK+RiHRRkxvKDyKRI/dgaKNkXPmDO3fyfCAc7Ajy8K0vMxFcFqCsjo7KC
         NuobFMzbIfsA9MqPRwlA/JUR0WJTgK0CKbBCnMcAyRG3NZW07bE90fFZL8hEWxntxk
         qNZ+2oZphv4cA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net 2/4] net: ll_temac: Add more error handling of dma_map_single() calls
Date:   Wed, 19 Feb 2020 11:54:00 +0100
Message-Id: <65907810dd82de3fcaad9869f328ab32800c67ea.1582108989.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582108989.git.esben@geanix.com>
References: <cover.1582108989.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds error handling to the remaining dma_map_single() calls, so that
behavior is well defined if/when we run out of DMA memory.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 26 +++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 996004ef8bd4..c368c3914bda 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -367,6 +367,8 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 					      XTE_MAX_JUMBO_FRAME_SIZE,
 					      DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr))
+			goto out;
 		lp->rx_bd_v[i].phys = cpu_to_be32(skb_dma_addr);
 		lp->rx_bd_v[i].len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
 		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
@@ -863,12 +865,13 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 				      skb_headlen(skb), DMA_TO_DEVICE);
 	cur_p->len = cpu_to_be32(skb_headlen(skb));
+	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr)))
+		return NETDEV_TX_BUSY;
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
 	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
-		lp->tx_bd_tail++;
-		if (lp->tx_bd_tail >= TX_BD_NUM)
+		if (++lp->tx_bd_tail >= TX_BD_NUM)
 			lp->tx_bd_tail = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -876,6 +879,25 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					      skb_frag_address(frag),
 					      skb_frag_size(frag),
 					      DMA_TO_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr)) {
+			if (--lp->tx_bd_tail < 0)
+				lp->tx_bd_tail = TX_BD_NUM - 1;
+			cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+			while (--ii >= 0) {
+				--frag;
+				dma_unmap_single(ndev->dev.parent,
+						 be32_to_cpu(cur_p->phys),
+						 skb_frag_size(frag),
+						 DMA_TO_DEVICE);
+				if (--lp->tx_bd_tail < 0)
+					lp->tx_bd_tail = TX_BD_NUM - 1;
+				cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+			}
+			dma_unmap_single(ndev->dev.parent,
+					 be32_to_cpu(cur_p->phys),
+					 skb_headlen(skb), DMA_TO_DEVICE);
+			return NETDEV_TX_BUSY;
+		}
 		cur_p->phys = cpu_to_be32(skb_dma_addr);
 		cur_p->len = cpu_to_be32(skb_frag_size(frag));
 		cur_p->app0 = 0;
-- 
2.25.0

