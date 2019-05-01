Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9253C10970
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfEAOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VtaDFqgm3V8SW1Rv73RNuUUQ3caFdNsfs9O0wBEP/es=; b=ID1p3M19weFPyLum97x2w0ufk
        fRFSy1osbb4v51A3VeZOAqMy5iSv6ElG+689QMKwI9u/JO+55pGOHdPuA+hw7BdvozJ2OYnxkZO1+
        Axy0iPjBSVwNQ+3FzHkT3Icu17cIIrCxW+cXDIKUDfLkrK3cKX+H967fq1HJLHf7LNQQnV996M2qq
        1Jf89OFNQiRWx+syM1Rj9oVBmL4vNmgiB9PkybiNX488UzB4Ao4yzD5XqHKZun+PolEUFZNM1AOF/
        xRa+Y97GqhNrlvORwyxKCk04qNbaIN/TYH3PpVWdkJ240eftBR8UVWFi+pwQ5HvM0LxkgtB+07XcJ
        fqnW8J7Tg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTj-00025Z-Rl; Wed, 01 May 2019 14:44:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 3/7] net: Use skb accessors in network drivers
Date:   Wed,  1 May 2019 07:44:53 -0700
Message-Id: <20190501144457.7942-4-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for renaming skb_frag fields, use the fine accessors which
already exist.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/hsi/clients/ssi_protocol.c              |  3 ++-
 drivers/net/ethernet/3com/3c59x.c               |  2 +-
 drivers/net/ethernet/agere/et131x.c             |  4 ++--
 .../net/ethernet/apm/xgene/xgene_enet_main.c    |  3 ++-
 drivers/net/ethernet/calxeda/xgmac.c            |  2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 17 ++++++++---------
 .../net/ethernet/cavium/liquidio/lio_vf_main.c  | 15 +++++++--------
 drivers/net/ethernet/cortina/gemini.c           |  5 ++---
 drivers/net/ethernet/freescale/fec_main.c       |  4 ++--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c   |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c   |  3 ++-
 drivers/net/ethernet/intel/igb/igb_main.c       |  3 ++-
 drivers/net/ethernet/intel/igc/igc_main.c       |  3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |  3 ++-
 drivers/net/ethernet/marvell/mvneta.c           |  4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  7 ++++---
 .../net/ethernet/myricom/myri10ge/myri10ge.c    |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c   |  5 +++--
 drivers/net/usb/usbnet.c                        |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c         |  6 +++---
 drivers/net/wireless/ath/wil6210/txrx_edma.c    |  2 +-
 drivers/net/xen-netback/netback.c               |  4 ++--
 drivers/staging/octeon/ethernet-tx.c            |  3 +--
 drivers/target/iscsi/cxgbit/cxgbit_target.c     |  6 +++---
 24 files changed, 57 insertions(+), 53 deletions(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 561abf7bdf1f..9f506c00ad85 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -194,7 +194,8 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 		sg = sg_next(sg);
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
-		sg_set_page(sg, frag->page.p, frag->size, frag->page_offset);
+		sg_set_page(sg, skb_page_frag(frag), frag->size,
+				frag->page_offset);
 	}
 }
 
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 147051404194..7be91e896f2d 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2175,7 +2175,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			dma_addr = skb_frag_dma_map(vp->gendev, frag,
 						    0,
-						    frag->size,
+						    skb_frag_size(frag),
 						    DMA_TO_DEVICE);
 			if (dma_mapping_error(vp->gendev, dma_addr)) {
 				for(i = i-1; i >= 0; i--)
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index ea34bcb868b5..9a587ac1377a 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2488,11 +2488,11 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				frag++;
 			}
 		} else {
-			desc[frag].len_vlan = frags[i - 1].size;
+			desc[frag].len_vlan = skb_frag_size(&frags[i - 1]);
 			dma_addr = skb_frag_dma_map(&adapter->pdev->dev,
 						    &frags[i - 1],
 						    0,
-						    frags[i - 1].size,
+						    desc[frag].len_vlan,
 						    DMA_TO_DEVICE);
 			desc[frag].addr_lo = lower_32_bits(dma_addr);
 			desc[frag].addr_hi = upper_32_bits(dma_addr);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 50dd6bf176d0..f4714e14bced 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -352,7 +352,8 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 				nr_frags = skb_shinfo(skb)->nr_frags;
 
 				for (i = 0; i < 2 && i < nr_frags; i++)
-					len += skb_shinfo(skb)->frags[i].size;
+					len += skb_frag_size(
+						&skb_shinfo(skb)->frags[i]);
 
 				/* HW requires header must reside in 3 buffer */
 				if (unlikely(hdr_len > len)) {
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 13741ee49b9b..804dadc97fd1 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1115,7 +1115,7 @@ static netdev_tx_t xgmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	for (i = 0; i < nfrags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		len = frag->size;
+		len = skb_frag_size(frag);
 
 		paddr = skb_frag_dma_map(priv->device, frag, 0, len,
 					 DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index fb6f813cff65..739b3127598c 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1496,7 +1496,7 @@ static void free_netsgbuf(void *buf)
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -1539,7 +1539,7 @@ static void free_netsgbuf_with_resp(void *buf)
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -2462,11 +2462,9 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 			frag = &skb_shinfo(skb)->frags[i - 1];
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
-				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
-					     frag->page_offset,
-					     frag->size,
-					     DMA_TO_DEVICE);
+				skb_frag_dma_map(&oct->pci_dev->dev,
+					         frag, 0, skb_frag_size(frag),
+						 DMA_TO_DEVICE);
 
 			if (dma_mapping_error(&oct->pci_dev->dev,
 					      g->sg[i >> 2].ptr[i & 3])) {
@@ -2478,7 +2476,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 					frag = &skb_shinfo(skb)->frags[j - 1];
 					dma_unmap_page(&oct->pci_dev->dev,
 						       g->sg[j >> 2].ptr[j & 3],
-						       frag->size,
+						       skb_frag_size(frag),
 						       DMA_TO_DEVICE);
 				}
 				dev_err(&oct->pci_dev->dev, "%s DMA mapping error 3\n",
@@ -2486,7 +2484,8 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 				return NETDEV_TX_BUSY;
 			}
 
-			add_sg_size(&g->sg[(i >> 2)], frag->size, (i & 3));
+			add_sg_size(&g->sg[(i >> 2)], skb_frag_size(frag),
+				    (i & 3));
 			i++;
 		}
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 54b245797d2e..8706714c8b2f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -841,7 +841,7 @@ static void free_netsgbuf(void *buf)
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -885,7 +885,7 @@ static void free_netsgbuf_with_resp(void *buf)
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -1535,10 +1535,8 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 			frag = &skb_shinfo(skb)->frags[i - 1];
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
-				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
-					     frag->page_offset,
-					     frag->size,
+				skb_frag_dma_map(&oct->pci_dev->dev,
+					     frag, 0, skb_frag_size(frag),
 					     DMA_TO_DEVICE);
 			if (dma_mapping_error(&oct->pci_dev->dev,
 					      g->sg[i >> 2].ptr[i & 3])) {
@@ -1550,7 +1548,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 					frag = &skb_shinfo(skb)->frags[j - 1];
 					dma_unmap_page(&oct->pci_dev->dev,
 						       g->sg[j >> 2].ptr[j & 3],
-						       frag->size,
+						       skb_frag_size(frag),
 						       DMA_TO_DEVICE);
 				}
 				dev_err(&oct->pci_dev->dev, "%s DMA mapping error 3\n",
@@ -1558,7 +1556,8 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 				return NETDEV_TX_BUSY;
 			}
 
-			add_sg_size(&g->sg[(i >> 2)], frag->size, (i & 3));
+			add_sg_size(&g->sg[(i >> 2)], skb_frag_size(frag),
+				    (i & 3));
 			i++;
 		}
 
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 949103db8a8a..f30eb73cf1cf 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1182,9 +1182,8 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 			buflen = skb_headlen(skb);
 		} else {
 			skb_frag = skb_si->frags + frag;
-			buffer = page_address(skb_frag_page(skb_frag)) +
-				 skb_frag->page_offset;
-			buflen = skb_frag->size;
+			buffer = skb_frag_address(skb_frag);
+			buflen = skb_frag_size(skb_frag);
 		}
 
 		if (frag == last_frag) {
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a96ad20ee484..d69dad647cee 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -365,7 +365,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 		status = fec16_to_cpu(bdp->cbd_sc);
 		status &= ~BD_ENET_TX_STATS;
 		status |= (BD_ENET_TX_TC | BD_ENET_TX_READY);
-		frag_len = skb_shinfo(skb)->frags[frag].size;
+		frag_len = skb_frag_size(&skb_shinfo(skb)->frags[frag]);
 
 		/* Handle the last BD specially */
 		if (frag == nr_frags - 1) {
@@ -387,7 +387,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
 
-		bufaddr = page_address(this_frag->page.p) + this_frag->page_offset;
+		bufaddr = skb_frag_address(this_frag);
 
 		index = fec_enet_get_bd_index(bdp, &txq->bd);
 		if (((unsigned long) bufaddr) & fep->tx_align ||
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index e5d853b7b454..add57b9dd8a5 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -723,7 +723,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		int len = frag->size;
+		int len = skb_frag_size(frag);
 
 		addr = skb_frag_dma_map(priv->dev, frag, 0, len, DMA_TO_DEVICE);
 		ret = dma_mapping_error(priv->dev, addr);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index ecef949f3baa..0fcfcc684fbd 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -1079,7 +1079,8 @@ netdev_tx_t fm10k_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (fm10k_maybe_stop_tx(tx_ring, count + 3)) {
 		tx_ring->tx_stats.tx_busy++;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3269d8e94744..43378101b5ae 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6087,7 +6087,8 @@ netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (igb_maybe_stop_tx(tx_ring, count + 3)) {
 		/* this is a hard error */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 87a11879bf2d..6d9a0e66a382 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -950,7 +950,8 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (igc_maybe_stop_tx(tx_ring, count + 3)) {
 		/* this is a hard error */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index e100054a3765..4a0e4091978f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8607,7 +8607,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (ixgbe_maybe_stop_tx(tx_ring, count + 3)) {
 		tx_ring->tx_stats.tx_busy++;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c0a3718b2e2a..972f8a246a83 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2349,10 +2349,10 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 
 	for (i = 0; i < nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvneta_txq_next_desc_get(txq);
-		tx_desc->data_size = frag->size;
+		tx_desc->data_size = skb_frag_size(frag);
 
 		tx_desc->buf_phys_addr =
 			dma_map_single(pp->dev->dev.parent, addr,
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 25fbed2b8d94..2ed390a7edce 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2822,14 +2822,15 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
 		mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
-		mvpp2_txdesc_size_set(port, tx_desc, frag->size);
+		mvpp2_txdesc_size_set(port, tx_desc, skb_frag_size(frag));
 
 		buf_dma_addr = dma_map_single(port->dev->dev.parent, addr,
-					      frag->size, DMA_TO_DEVICE);
+					      skb_frag_size(frag),
+					      DMA_TO_DEVICE);
 		if (dma_mapping_error(port->dev->dev.parent, buf_dma_addr)) {
 			mvpp2_txq_desc_put(txq);
 			goto cleanup;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index e0340f778d8f..09da5a69f690 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1365,7 +1365,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 
 	/* remove padding */
 	rx_frags[0].page_offset += MXGEFW_PAD;
-	rx_frags[0].size -= MXGEFW_PAD;
+	skb_frag_size_sub(&rx_frags[0], MXGEFW_PAD);
 	len -= MXGEFW_PAD;
 
 	skb->len = len;
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 20d2400ad300..a57b84d12af4 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1398,9 +1398,10 @@ static void emac_tx_fill_tpd(struct emac_adapter *adpt,
 		frag = &skb_shinfo(skb)->frags[i];
 
 		tpbuf = GET_TPD_BUFFER(tx_q, tx_q->tpd.produce_idx);
-		tpbuf->length = frag->size;
+		tpbuf->length = skb_frag_size(frag);
 		tpbuf->dma_addr = dma_map_page(adpt->netdev->dev.parent,
-					       frag->page.p, frag->page_offset,
+					       skb_frag_page(frag),
+					       frag->page_offset,
 					       tpbuf->length, DMA_TO_DEVICE);
 		ret = dma_mapping_error(adpt->netdev->dev.parent,
 					tpbuf->dma_addr);
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 504282af27e5..486a295489f1 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1338,7 +1338,7 @@ static int build_dma_sg(const struct sk_buff *skb, struct urb *urb)
 		struct skb_frag_struct *f = &skb_shinfo(skb)->frags[i];
 
 		total_len += skb_frag_size(f);
-		sg_set_page(&urb->sg[i + s], f->page.p, f->size,
+		sg_set_page(&urb->sg[i + s], skb_frag_page(f), skb_frag_size(f),
 				f->page_offset);
 	}
 	urb->transfer_buffer_length = total_len;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4ccfd1404458..298ffb7c946f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1653,7 +1653,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 				     len);
 		} else {
 			frag = &skb_shinfo(skb)->frags[f];
-			len = frag->size;
+			len = skb_frag_size(frag);
 			wil_dbg_txrx(wil, "TSO: frag[%d]: len %u\n", f, len);
 		}
 
@@ -1674,8 +1674,8 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 
 			if (!headlen) {
 				pa = skb_frag_dma_map(dev, frag,
-						      frag->size - len, lenmss,
-						      DMA_TO_DEVICE);
+						      skb_frag_size(frag) - len,
+						      lenmss, DMA_TO_DEVICE);
 				vring->ctx[i].mapped_as = wil_mapped_as_page;
 			} else {
 				pa = dma_map_single(dev,
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index c38773878ae3..d0702f5a02dc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1445,7 +1445,7 @@ static int __wil_tx_ring_tso_edma(struct wil6210_priv *wil,
 	/* Rest of the descriptors are from the SKB fragments */
 	for (f = 0; f < nr_frags; f++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
-		int len = frag->size;
+		int len = skb_frag_size(frag);
 
 		wil_dbg_txrx(wil, "TSO: frag[%d]: len %u, descs_used %d\n", f,
 			     len, descs_used);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7..a96c5c2a2c5a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1055,7 +1055,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			int j;
 			skb->truesize += skb->data_len;
 			for (j = 0; j < i; j++)
-				put_page(frags[j].page.p);
+				put_page(skb_frag_page(&frags[j]));
 			return -ENOMEM;
 		}
 
@@ -1067,7 +1067,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			BUG();
 
 		offset += len;
-		frags[i].page.p = page;
+		__skb_frag_set_page(&frags[i], page);
 		frags[i].page_offset = 0;
 		skb_frag_size_set(&frags[i], len);
 	}
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 317c9720467c..29a31f37f66b 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -281,8 +281,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			struct skb_frag_struct *fs = skb_shinfo(skb)->frags + i;
 
 			hw_buffer.s.addr = XKPHYS_TO_PHYS(
-				(u64)(page_address(fs->page.p) +
-				fs->page_offset));
+				(u64)skb_frag_address(fs));
 			hw_buffer.s.size = fs->size;
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 29b350a0b58f..9cac100b3169 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -902,9 +902,9 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 		skb_frag_t *dfrag = &ssi->frags[pdu_cb->dfrag_idx];
 
 		sg_init_table(&ccmd->sg, 1);
-		sg_set_page(&ccmd->sg, dfrag->page.p, skb_frag_size(dfrag),
-			    dfrag->page_offset);
-		get_page(dfrag->page.p);
+		sg_set_page(&ccmd->sg, skb_frag_page(dfrag),
+				skb_frag_size(dfrag), dfrag->page_offset);
+		get_page(skb_frag_page(dfrag));
 
 		cmd->se_cmd.t_data_sg = &ccmd->sg;
 		cmd->se_cmd.t_data_nents = 1;
-- 
2.20.1

