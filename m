Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D439191082
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgCXN3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:29:09 -0400
Received: from foss.arm.com ([217.140.110.172]:34574 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgCXNYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15825FEC;
        Tue, 24 Mar 2020 06:24:05 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8AF23F52E;
        Tue, 24 Mar 2020 06:24:03 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 07/14] net: axienet: Check for DMA mapping errors
Date:   Tue, 24 Mar 2020 13:23:40 +0000
Message-Id: <20200324132347.23709-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Especially with the default 32-bit DMA mask, DMA buffers are a limited
resource, so their allocation can fail.
So as the DMA API documentation requires, add error checking code after
dma_map_single() calls to catch the case where we run out of "low" memory.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5c1b53944771..736ac1b7a052 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -248,6 +248,11 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 						     skb->data,
 						     lp->max_frm_size,
 						     DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
+			netdev_err(ndev, "DMA mapping error\n");
+			goto out;
+		}
+
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
 
@@ -679,6 +684,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	dma_addr_t tail_p;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
+	u32 orig_tail_ptr = lp->tx_bd_tail;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -714,9 +720,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
 				     skb_headlen(skb), DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+		if (net_ratelimit())
+			netdev_err(ndev, "TX DMA mapping error\n");
+		ndev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
+	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -727,6 +739,16 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					     skb_frag_address(frag),
 					     skb_frag_size(frag),
 					     DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+			if (net_ratelimit())
+				netdev_err(ndev, "TX DMA mapping error\n");
+			ndev->stats.tx_dropped++;
+			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
+					      NULL);
+			lp->tx_bd_tail = orig_tail_ptr;
+
+			return NETDEV_TX_OK;
+		}
 		cur_p->cntrl = skb_frag_size(frag);
 	}
 
@@ -807,6 +829,13 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
 					     lp->max_frm_size,
 					     DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+			if (net_ratelimit())
+				netdev_err(ndev, "RX DMA mapping error\n");
+			dev_kfree_skb(new_skb);
+			return;
+		}
+
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
-- 
2.17.1

