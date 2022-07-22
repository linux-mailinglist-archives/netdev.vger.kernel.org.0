Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C488C57DB2E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiGVHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiGVHWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45516220C1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C58A6621BA
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 07:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2E6C341C6;
        Fri, 22 Jul 2022 07:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658474525;
        bh=mLF633ysa+rlMIaW85kQ89y9ybghbbfygiqrq9kYvLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrmsLuXQflDws66rey6+jCLV0XwZXN+zPmNva2+D3hI5HDldvQFiKxsc/M43IVh67
         zozj0iV0VnW+EE7lJ4QKvXSVvfrdsF/JPw/yrFfIwnVgXt8nRO58DDQMhDHHT2261N
         Dk4BSCY5bbwyvJPAMf+/+zecUNla58dnt/UqBAiiGfTqICZroQ0xKJ528YftCNjzIa
         SbT79cTA239clTDLlhpiEHP9+gbLBG1sWzilme8GD94CpQrz+MM6yMjJEXFg+h50kC
         ZRPswqwN5e6DPOscLJnvX1JIhbN830BTghc3AKPbX4XPNoaP15qC97Z2w40eoffDhs
         SzVgqOX13BAxA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v4 net-next 4/5] net: ethernet: mtk_eth_soc: add xmit XDP support
Date:   Fri, 22 Jul 2022 09:19:39 +0200
Message-Id: <b15705b9096d025468198c86a894218e9722c0a9.1658474059.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1658474059.git.lorenzo@kernel.org>
References: <cover.1658474059.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce XDP support for XDP_TX verdict and ndo_xdp_xmit function
pointer.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 192 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  10 +-
 2 files changed, 180 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index cd96eaf72b6b..cfbdcf68f9b9 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1031,15 +1031,26 @@ static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
 		}
 	}
 
-	tx_buf->flags = 0;
-	if (tx_buf->skb &&
-	    (tx_buf->skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC)) {
-		if (napi)
-			napi_consume_skb(tx_buf->skb, napi);
+	if (tx_buf->type == MTK_TYPE_SKB) {
+		if (tx_buf->data &&
+		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+			struct sk_buff *skb = tx_buf->data;
+
+			if (napi)
+				napi_consume_skb(skb, napi);
+			else
+				dev_kfree_skb_any(skb);
+		}
+	} else if (tx_buf->data) {
+		struct xdp_frame *xdpf = tx_buf->data;
+
+		if (napi && tx_buf->type == MTK_TYPE_XDP_TX)
+			xdp_return_frame_rx_napi(xdpf);
 		else
-			dev_kfree_skb_any(tx_buf->skb);
+			xdp_return_frame(xdpf);
 	}
-	tx_buf->skb = NULL;
+	tx_buf->flags = 0;
+	tx_buf->data = NULL;
 }
 
 static void setup_tx_buf(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
@@ -1056,7 +1067,7 @@ static void setup_tx_buf(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
 			dma_unmap_addr_set(tx_buf, dma_addr1, mapped_addr);
 			dma_unmap_len_set(tx_buf, dma_len1, size);
 		} else {
-			tx_buf->skb = (struct sk_buff *)MTK_DMA_DUMMY_DESC;
+			tx_buf->data = (void *)MTK_DMA_DUMMY_DESC;
 			txd->txd1 = mapped_addr;
 			txd->txd2 = TX_DMA_PLEN0(size);
 			dma_unmap_addr_set(tx_buf, dma_addr0, mapped_addr);
@@ -1232,7 +1243,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 						    soc->txrx.txd_size);
 			if (new_desc)
 				memset(tx_buf, 0, sizeof(*tx_buf));
-			tx_buf->skb = (struct sk_buff *)MTK_DMA_DUMMY_DESC;
+			tx_buf->data = (void *)MTK_DMA_DUMMY_DESC;
 			tx_buf->flags |= MTK_TX_FLAGS_PAGE0;
 			tx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
 					 MTK_TX_FLAGS_FPORT1;
@@ -1246,7 +1257,8 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	/* store skb to cleanup */
-	itx_buf->skb = skb;
+	itx_buf->type = MTK_TYPE_SKB;
+	itx_buf->data = skb;
 
 	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		if (k & 0x1)
@@ -1458,13 +1470,14 @@ static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
 		.pool_size = size,
 		.nid = NUMA_NO_NODE,
 		.dev = eth->dma_dev,
-		.dma_dir = DMA_FROM_DEVICE,
 		.offset = MTK_PP_HEADROOM,
 		.max_len = MTK_PP_MAX_BUF_SIZE,
 	};
 	struct page_pool *pp;
 	int err;
 
+	pp_params.dma_dir = rcu_access_pointer(eth->prog) ? DMA_BIDIRECTIONAL
+							  : DMA_FROM_DEVICE;
 	pp = page_pool_create(&pp_params);
 	if (IS_ERR(pp))
 		return pp;
@@ -1510,6 +1523,122 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
 		skb_free_frag(data);
 }
 
+static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
+				struct net_device *dev, bool dma_map)
+{
+	const struct mtk_soc_data *soc = eth->soc;
+	struct mtk_tx_ring *ring = &eth->tx_ring;
+	struct mtk_tx_dma_desc_info txd_info = {
+		.size	= xdpf->len,
+		.first	= true,
+		.last	= true,
+	};
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_tx_dma *txd, *txd_pdma;
+	int err = 0, index = 0, n_desc = 1;
+	struct mtk_tx_buf *tx_buf;
+
+	if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
+		return -EBUSY;
+
+	if (unlikely(atomic_read(&ring->free_count) <= 1))
+		return -EBUSY;
+
+	spin_lock(&eth->page_lock);
+
+	txd = ring->next_free;
+	if (txd == ring->last_free) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	tx_buf = mtk_desc_to_tx_buf(ring, txd, soc->txrx.txd_size);
+	memset(tx_buf, 0, sizeof(*tx_buf));
+
+	if (dma_map) {  /* ndo_xdp_xmit */
+		txd_info.addr = dma_map_single(eth->dma_dev, xdpf->data,
+					       txd_info.size, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(eth->dma_dev, txd_info.addr))) {
+			err = -ENOMEM;
+			goto out;
+		}
+		tx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
+	} else {
+		struct page *page = virt_to_head_page(xdpf->data);
+
+		txd_info.addr = page_pool_get_dma_addr(page) +
+				sizeof(*xdpf) + xdpf->headroom;
+		dma_sync_single_for_device(eth->dma_dev, txd_info.addr,
+					   txd_info.size,
+					   DMA_BIDIRECTIONAL);
+	}
+	mtk_tx_set_dma_desc(dev, txd, &txd_info);
+
+	tx_buf->flags |= !mac->id ? MTK_TX_FLAGS_FPORT0 : MTK_TX_FLAGS_FPORT1;
+
+	txd_pdma = qdma_to_pdma(ring, txd);
+	setup_tx_buf(eth, tx_buf, txd_pdma, txd_info.addr, txd_info.size,
+		     index++);
+
+	/* store xdpf for cleanup */
+	tx_buf->type = dma_map ? MTK_TYPE_XDP_NDO : MTK_TYPE_XDP_TX;
+	tx_buf->data = xdpf;
+
+	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
+		if (index & 1)
+			txd_pdma->txd2 |= TX_DMA_LS0;
+		else
+			txd_pdma->txd2 |= TX_DMA_LS1;
+	}
+
+	ring->next_free = mtk_qdma_phys_to_virt(ring, txd->txd2);
+	atomic_sub(n_desc, &ring->free_count);
+
+	/* make sure that all changes to the dma ring are flushed before we
+	 * continue
+	 */
+	wmb();
+
+	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
+		mtk_w32(eth, txd->txd2, soc->reg_map->qdma.ctx_ptr);
+	} else {
+		int idx;
+
+		idx = txd_to_idx(ring, txd, soc->txrx.txd_size);
+		mtk_w32(eth, NEXT_DESP_IDX(idx, ring->dma_size),
+			MT7628_TX_CTX_IDX0);
+	}
+out:
+	spin_unlock(&eth->page_lock);
+
+	return err;
+}
+
+static int mtk_xdp_xmit(struct net_device *dev, int num_frame,
+			struct xdp_frame **frames, u32 flags)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_hw_stats *hw_stats = mac->hw_stats;
+	struct mtk_eth *eth = mac->hw;
+	int i, nxmit = 0;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	for (i = 0; i < num_frame; i++) {
+		if (mtk_xdp_submit_frame(eth, frames[i], dev, true))
+			break;
+		nxmit++;
+	}
+
+	u64_stats_update_begin(&hw_stats->syncp);
+	hw_stats->xdp_stats.tx_xdp_xmit += nxmit;
+	hw_stats->xdp_stats.tx_xdp_xmit_errors += num_frame - nxmit;
+	u64_stats_update_end(&hw_stats->syncp);
+
+	return nxmit;
+}
+
 static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 		       struct xdp_buff *xdp, struct net_device *dev)
 {
@@ -1538,6 +1667,18 @@ static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 
 		count = &hw_stats->xdp_stats.rx_xdp_redirect;
 		goto update_stats;
+	case XDP_TX: {
+		struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
+
+		if (mtk_xdp_submit_frame(eth, xdpf, dev, false)) {
+			count = &hw_stats->xdp_stats.rx_xdp_tx_errors;
+			act = XDP_DROP;
+			break;
+		}
+
+		count = &hw_stats->xdp_stats.rx_xdp_tx;
+		goto update_stats;
+	}
 	default:
 		bpf_warn_invalid_xdp_action(dev, prog, act);
 		fallthrough;
@@ -1771,9 +1912,8 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 {
 	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
-	struct mtk_tx_dma *desc;
-	struct sk_buff *skb;
 	struct mtk_tx_buf *tx_buf;
+	struct mtk_tx_dma *desc;
 	u32 cpu, dma;
 
 	cpu = ring->last_free_ptr;
@@ -1794,15 +1934,21 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
 			mac = 1;
 
-		skb = tx_buf->skb;
-		if (!skb)
+		if (!tx_buf->data)
 			break;
 
-		if (skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC) {
+		if (tx_buf->type == MTK_TYPE_SKB &&
+		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+			struct sk_buff *skb = tx_buf->data;
+
 			bytes[mac] += skb->len;
 			done[mac]++;
 			budget--;
+		} else if (tx_buf->type == MTK_TYPE_XDP_TX ||
+			   tx_buf->type == MTK_TYPE_XDP_NDO) {
+			budget--;
 		}
+
 		mtk_tx_unmap(eth, tx_buf, true);
 
 		ring->last_free = desc;
@@ -1821,9 +1967,8 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 			    unsigned int *done, unsigned int *bytes)
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
-	struct mtk_tx_dma *desc;
-	struct sk_buff *skb;
 	struct mtk_tx_buf *tx_buf;
+	struct mtk_tx_dma *desc;
 	u32 cpu, dma;
 
 	cpu = ring->cpu_idx;
@@ -1831,14 +1976,18 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 
 	while ((cpu != dma) && budget) {
 		tx_buf = &ring->buf[cpu];
-		skb = tx_buf->skb;
-		if (!skb)
+		if (!tx_buf->data)
 			break;
 
-		if (skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC) {
+		if (tx_buf->type == MTK_TYPE_SKB &&
+		    tx_buf->data != (void *)MTK_DMA_DUMMY_DESC) {
+			struct sk_buff *skb = tx_buf->data;
 			bytes[0] += skb->len;
 			done[0]++;
 			budget--;
+		} else if (tx_buf->type == MTK_TYPE_XDP_TX ||
+			   tx_buf->type == MTK_TYPE_XDP_NDO) {
+			budget--;
 		}
 
 		mtk_tx_unmap(eth, tx_buf, true);
@@ -3518,6 +3667,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 #endif
 	.ndo_setup_tc		= mtk_eth_setup_tc,
 	.ndo_bpf		= mtk_xdp,
+	.ndo_xdp_xmit		= mtk_xdp_xmit,
 };
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2775da1a6ec3..7405c97cda66 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -696,6 +696,12 @@ enum mtk_dev_state {
 	MTK_RESETTING
 };
 
+enum mtk_tx_buf_type {
+	MTK_TYPE_SKB,
+	MTK_TYPE_XDP_TX,
+	MTK_TYPE_XDP_NDO,
+};
+
 /* struct mtk_tx_buf -	This struct holds the pointers to the memory pointed at
  *			by the TX descriptor	s
  * @skb:		The SKB pointer of the packet being sent
@@ -705,7 +711,9 @@ enum mtk_dev_state {
  * @dma_len1:		The length of the second segment
  */
 struct mtk_tx_buf {
-	struct sk_buff *skb;
+	enum mtk_tx_buf_type type;
+	void *data;
+
 	u32 flags;
 	DEFINE_DMA_UNMAP_ADDR(dma_addr0);
 	DEFINE_DMA_UNMAP_LEN(dma_len0);
-- 
2.36.1

