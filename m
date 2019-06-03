Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0071E33A76
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFCV5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:33 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:36577 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCV5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:33 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53LvV7I015793
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:32 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMI008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:30 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 01/18] net: axienet: Fix casting of pointers to u32
Date:   Mon,  3 Jun 2019 15:57:00 -0600
Message-Id: <1559599037-8514-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was casting skb pointers to u32 and storing them as such in
the DMA buffer descriptor, which is obviously broken on 64-bit. The area
of the buffer descriptor being used is not accessed by the hardware and
has sufficient room for a 32 or 64-bit pointer, so just store the skb
pointer as such.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 11 +++-------
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 26 ++++++++++++-----------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 011adae..e09dc14 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -356,9 +356,6 @@
  * @app2:         MM2S/S2MM User Application Field 2.
  * @app3:         MM2S/S2MM User Application Field 3.
  * @app4:         MM2S/S2MM User Application Field 4.
- * @sw_id_offset: MM2S/S2MM Sw ID
- * @reserved5:    Reserved and not used
- * @reserved6:    Reserved and not used
  */
 struct axidma_bd {
 	u32 next;	/* Physical address of next buffer descriptor */
@@ -373,11 +370,9 @@ struct axidma_bd {
 	u32 app1;	/* TX start << 16 | insert */
 	u32 app2;	/* TX csum seed */
 	u32 app3;
-	u32 app4;
-	u32 sw_id_offset;
-	u32 reserved5;
-	u32 reserved6;
-};
+	u32 app4;   /* Last field used by HW */
+	struct sk_buff *skb;
+} __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);
 
 /**
  * struct axienet_local - axienet private per device data
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 831967f..1bace60 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -159,8 +159,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < RX_BD_NUM; i++) {
 		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
 				 lp->max_frm_size, DMA_FROM_DEVICE);
-		dev_kfree_skb((struct sk_buff *)
-			      (lp->rx_bd_v[i].sw_id_offset));
+		dev_kfree_skb(lp->rx_bd_v[i].skb);
 	}
 
 	if (lp->rx_bd_v) {
@@ -227,7 +226,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		if (!skb)
 			goto out;
 
-		lp->rx_bd_v[i].sw_id_offset = (u32) skb;
+		lp->rx_bd_v[i].skb = skb;
 		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
 						     skb->data,
 						     lp->max_frm_size,
@@ -595,14 +594,15 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				DMA_TO_DEVICE);
-		if (cur_p->app4)
-			dev_consume_skb_irq((struct sk_buff *)cur_p->app4);
+		if (cur_p->skb)
+			dev_consume_skb_irq(cur_p->skb);
 		/*cur_p->phys = 0;*/
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app4 = 0;
 		cur_p->status = 0;
+		cur_p->skb = NULL;
 
 		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 		packets++;
@@ -707,7 +707,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	}
 
 	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
-	cur_p->app4 = (unsigned long)skb;
+	cur_p->skb = skb;
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
@@ -742,13 +742,15 @@ static void axienet_recv(struct net_device *ndev)
 
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-		skb = (struct sk_buff *) (cur_p->sw_id_offset);
-		length = cur_p->app4 & 0x0000FFFF;
 
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				 lp->max_frm_size,
 				 DMA_FROM_DEVICE);
 
+		skb = cur_p->skb;
+		cur_p->skb = NULL;
+		length = cur_p->app4 & 0x0000FFFF;
+
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
 		/*skb_checksum_none_assert(skb);*/
@@ -783,7 +785,7 @@ static void axienet_recv(struct net_device *ndev)
 					     DMA_FROM_DEVICE);
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
-		cur_p->sw_id_offset = (u32) new_skb;
+		cur_p->skb = new_skb;
 
 		++lp->rx_bd_ci;
 		lp->rx_bd_ci %= RX_BD_NUM;
@@ -1343,8 +1345,8 @@ static void axienet_dma_err_handler(unsigned long data)
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-		if (cur_p->app4)
-			dev_kfree_skb_irq((struct sk_buff *) cur_p->app4);
+		if (cur_p->skb)
+			dev_kfree_skb_irq(cur_p->skb);
 		cur_p->phys = 0;
 		cur_p->cntrl = 0;
 		cur_p->status = 0;
@@ -1353,7 +1355,7 @@ static void axienet_dma_err_handler(unsigned long data)
 		cur_p->app2 = 0;
 		cur_p->app3 = 0;
 		cur_p->app4 = 0;
-		cur_p->sw_id_offset = 0;
+		cur_p->skb = NULL;
 	}
 
 	for (i = 0; i < RX_BD_NUM; i++) {
-- 
1.8.3.1

