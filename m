Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD8136C7F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgAJLz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:55:26 -0500
Received: from foss.arm.com ([217.140.110.172]:43140 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgAJLyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 648261435;
        Fri, 10 Jan 2020 03:54:31 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44ABC3F534;
        Fri, 10 Jan 2020 03:54:30 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] net: axienet: Check for DMA mapping errors
Date:   Fri, 10 Jan 2020 11:54:07 +0000
Message-Id: <20200110115415.75683-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110115415.75683-1-andre.przywara@arm.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
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
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 82abe2b0f16a..8d2b67cbecf9 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -248,6 +248,11 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 						     skb->data,
 						     lp->max_frm_size,
 						     DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
+			dev_kfree_skb(skb);
+			goto out;
+		}
+
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
 
@@ -668,6 +673,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	dma_addr_t tail_p;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
+	u32 orig_tail_ptr = lp->tx_bd_tail;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -703,9 +709,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
 				     skb_headlen(skb), DMA_TO_DEVICE);
+	if (dma_mapping_error(ndev->dev.parent, cur_p->phys))
+		return NETDEV_TX_BUSY;
+	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -716,6 +724,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					     skb_frag_address(frag),
 					     skb_frag_size(frag),
 					     DMA_TO_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
+			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
+					      NULL);
+			lp->tx_bd_tail = orig_tail_ptr;
+
+			return NETDEV_TX_BUSY;
+		}
 		cur_p->cntrl = skb_frag_size(frag);
 	}
 
@@ -796,6 +811,11 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
 					     lp->max_frm_size,
 					     DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
+			dev_kfree_skb(new_skb);
+			return;
+		}
+
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
-- 
2.17.1

