Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCE5834CC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiG0VWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG0VWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51665720A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 253DA608D3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 21:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C29C433B5;
        Wed, 27 Jul 2022 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658956968;
        bh=bGkV0/NSbHA6qEcuG2LEzyvloU5oiNR/vG45e/SG7tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieM7guo7cZ8Qtm+MXvAg4bYaoEM3u8o9PvvtIKN3fRxFRx+YL9RTgKqwYtTmNPofH
         MRhcV53e2Ep94sh2Mh6G6rHn+hf/5RBenBSLgGzNJ9LaEzkiJCSHfdK4c15yEhbN/U
         Rj6MmJC+3v80mUSxsgoEo84Uzu43eKtHz22fuRtvoUH72AUYYrJJLUoX7cG+Ksclv4
         ZInt3rEPUZ+gL9G87nn8INc1FCpUdVJP1rA7lG7MB3aOM5UsbmQNAAnNxR6DQ9QkiT
         yjNClhsNWtsHBUKQb5s2usXrIxuMB+lRszsSVkCfrKEsgtRbUGgFUzto92J4LIUyCs
         o9CFwrPjm/39w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: introduce xdp multi-frag support
Date:   Wed, 27 Jul 2022 23:20:51 +0200
Message-Id: <24704aaeb7f1fc44d6d2cdfa2fb919f625884421.1658955249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1658955249.git.lorenzo@kernel.org>
References: <cover.1658955249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to map non-linear xdp frames in XDP_TX and
ndo_xdp_xmit callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 125 +++++++++++++-------
 1 file changed, 82 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8450604d22ff..24235f8f0a8f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1031,23 +1031,22 @@ static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
 		}
 	}
 
-	if (tx_buf->type == MTK_TYPE_SKB) {
-		if (tx_buf->data &&
-		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+	if (tx_buf->data && tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+		if (tx_buf->type == MTK_TYPE_SKB) {
 			struct sk_buff *skb = tx_buf->data;
 
 			if (napi)
 				napi_consume_skb(skb, napi);
 			else
 				dev_kfree_skb_any(skb);
-		}
-	} else if (tx_buf->data) {
-		struct xdp_frame *xdpf = tx_buf->data;
+		} else {
+			struct xdp_frame *xdpf = tx_buf->data;
 
-		if (napi && tx_buf->type == MTK_TYPE_XDP_TX)
-			xdp_return_frame_rx_napi(xdpf);
-		else
-			xdp_return_frame(xdpf);
+			if (napi && tx_buf->type == MTK_TYPE_XDP_TX)
+				xdp_return_frame_rx_napi(xdpf);
+			else
+				xdp_return_frame(xdpf);
+		}
 	}
 	tx_buf->flags = 0;
 	tx_buf->data = NULL;
@@ -1550,6 +1549,8 @@ static int mtk_xdp_frame_map(struct mtk_eth *eth, struct net_device *dev,
 	mtk_tx_set_dma_desc(dev, txd, txd_info);
 
 	tx_buf->flags |= !mac->id ? MTK_TX_FLAGS_FPORT0 : MTK_TX_FLAGS_FPORT1;
+	tx_buf->type = dma_map ? MTK_TYPE_XDP_NDO : MTK_TYPE_XDP_TX;
+	tx_buf->data = (void *)MTK_DMA_DUMMY_DESC;
 
 	txd_pdma = qdma_to_pdma(ring, txd);
 	setup_tx_buf(eth, tx_buf, txd_pdma, txd_info->addr, txd_info->size,
@@ -1561,43 +1562,69 @@ static int mtk_xdp_frame_map(struct mtk_eth *eth, struct net_device *dev,
 static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 				struct net_device *dev, bool dma_map)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_dma_desc_info txd_info = {
 		.size	= xdpf->len,
 		.first	= true,
-		.last	= true,
+		.last	= !xdp_frame_has_frags(xdpf),
 	};
-	int err = 0, index = 0, n_desc = 1;
-	struct mtk_tx_dma *txd, *txd_pdma;
-	struct mtk_tx_buf *tx_buf;
+	int err, index = 0, n_desc = 1, nr_frags;
+	struct mtk_tx_dma *htxd, *txd, *txd_pdma;
+	struct mtk_tx_buf *htx_buf, *tx_buf;
+	void *data = xdpf->data;
 
 	if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
 		return -EBUSY;
 
-	if (unlikely(atomic_read(&ring->free_count) <= 1))
+	nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	if (unlikely(atomic_read(&ring->free_count) <= 1 + nr_frags))
 		return -EBUSY;
 
 	spin_lock(&eth->page_lock);
 
 	txd = ring->next_free;
 	if (txd == ring->last_free) {
-		err = -ENOMEM;
-		goto out;
+		spin_unlock(&eth->page_lock);
+		return -ENOMEM;
 	}
+	htxd = txd;
 
 	tx_buf = mtk_desc_to_tx_buf(ring, txd, soc->txrx.txd_size);
 	memset(tx_buf, 0, sizeof(*tx_buf));
+	htx_buf = tx_buf;
 
-	err = mtk_xdp_frame_map(eth, dev, &txd_info, txd, tx_buf,
-				xdpf->data, xdpf->headroom, index,
-				dma_map);
-	if (err < 0)
-		goto out;
+	for (;;) {
+		err = mtk_xdp_frame_map(eth, dev, &txd_info, txd, tx_buf,
+					data, xdpf->headroom, index, dma_map);
+		if (err < 0)
+			goto unmap;
+
+		if (txd_info.last)
+			break;
+
+		if (MTK_HAS_CAPS(soc->caps, MTK_QDMA) || (index & 0x1)) {
+			txd = mtk_qdma_phys_to_virt(ring, txd->txd2);
+			txd_pdma = qdma_to_pdma(ring, txd);
+			if (txd == ring->last_free)
+				goto unmap;
 
+			tx_buf = mtk_desc_to_tx_buf(ring, txd,
+						    soc->txrx.txd_size);
+			memset(tx_buf, 0, sizeof(*tx_buf));
+			n_desc++;
+		}
+
+		memset(&txd_info, 0, sizeof(struct mtk_tx_dma_desc_info));
+		txd_info.size = skb_frag_size(&sinfo->frags[index]);
+		txd_info.last = index + 1 == nr_frags;
+		data = skb_frag_address(&sinfo->frags[index]);
+
+		index++;
+	}
 	/* store xdpf for cleanup */
-	tx_buf->type = dma_map ? MTK_TYPE_XDP_NDO : MTK_TYPE_XDP_TX;
-	tx_buf->data = xdpf;
+	htx_buf->data = xdpf;
 
 	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		txd_pdma = qdma_to_pdma(ring, txd);
@@ -1624,7 +1651,24 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 		mtk_w32(eth, NEXT_DESP_IDX(idx, ring->dma_size),
 			MT7628_TX_CTX_IDX0);
 	}
-out:
+
+	spin_unlock(&eth->page_lock);
+
+	return 0;
+
+unmap:
+	while (htxd != txd) {
+		txd_pdma = qdma_to_pdma(ring, htxd);
+		tx_buf = mtk_desc_to_tx_buf(ring, htxd, soc->txrx.txd_size);
+		mtk_tx_unmap(eth, tx_buf, false);
+
+		htxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
+			txd_pdma->txd2 = TX_DMA_DESP2_DEF;
+
+		htxd = mtk_qdma_phys_to_virt(ring, htxd->txd2);
+	}
+
 	spin_unlock(&eth->page_lock);
 
 	return err;
@@ -1953,18 +1997,15 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		if (!tx_buf->data)
 			break;
 
-		if (tx_buf->type == MTK_TYPE_SKB &&
-		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
-			struct sk_buff *skb = tx_buf->data;
+		if (tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+			if (tx_buf->type == MTK_TYPE_SKB) {
+				struct sk_buff *skb = tx_buf->data;
 
-			bytes[mac] += skb->len;
-			done[mac]++;
-			budget--;
-		} else if (tx_buf->type == MTK_TYPE_XDP_TX ||
-			   tx_buf->type == MTK_TYPE_XDP_NDO) {
+				bytes[mac] += skb->len;
+				done[mac]++;
+			}
 			budget--;
 		}
-
 		mtk_tx_unmap(eth, tx_buf, true);
 
 		ring->last_free = desc;
@@ -1995,17 +2036,15 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 		if (!tx_buf->data)
 			break;
 
-		if (tx_buf->type == MTK_TYPE_SKB &&
-		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
-			struct sk_buff *skb = tx_buf->data;
-			bytes[0] += skb->len;
-			done[0]++;
-			budget--;
-		} else if (tx_buf->type == MTK_TYPE_XDP_TX ||
-			   tx_buf->type == MTK_TYPE_XDP_NDO) {
+		if (tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+			if (tx_buf->type == MTK_TYPE_SKB) {
+				struct sk_buff *skb = tx_buf->data;
+
+				bytes[0] += skb->len;
+				done[0]++;
+			}
 			budget--;
 		}
-
 		mtk_tx_unmap(eth, tx_buf, true);
 
 		desc = ring->dma + cpu * eth->soc->txrx.txd_size;
-- 
2.37.1

