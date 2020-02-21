Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F7166FCB
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 07:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBUGri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 01:47:38 -0500
Received: from first.geanix.com ([116.203.34.67]:55394 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgBUGrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 01:47:37 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 62C4BAEB4D;
        Fri, 21 Feb 2020 06:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582267654; bh=yH8TvgCUbnfl/izLx4TJFR7NPStHNtUPhDk2EUg7hbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=im76HTD545nmrHWZD9Us/Adc3v/VsJtq/0EvnRGsGoASNjWtz6Edeo+EhJyzfyv76
         Aj0CNr6FZLU2JFTfvEVle0gJTDlUsW8U5oD3drcCUUM38+ML/CntZI9EKzFLOtPaCw
         T+cxjzNDDTikBbm8aTQu+1u40jads+JOaiqS0iiVcfHzaACRrM0BirOkOkaHSEHHhS
         BijbgPg5y5n370nD+usUV/WxBQi9+muOLZxRHRW1Eay/pbhaEVCiur1+MtoH729W65
         vayQhIc9X0Utogjg+pHSyP6h2f3HXkomv0PDUTSjvpbMqA35JcqgRp8VKyPwOXN0Oq
         tlPql6hgS3I9g==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net v2 2/4] net: ll_temac: Add more error handling of dma_map_single() calls
Date:   Fri, 21 Feb 2020 07:47:33 +0100
Message-Id: <65907810dd82de3fcaad9869f328ab32800c67ea.1582267079.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582267079.git.esben@geanix.com>
References: <cover.1582108989.git.esben@geanix.com> <cover.1582267079.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
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

