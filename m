Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEEB57285D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiGLVQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 17:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGLVQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 17:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB75BD03A0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 14:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D26FB81BE8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 21:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE40BC3411C;
        Tue, 12 Jul 2022 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657660594;
        bh=35yzR2p2Q3Ck4oS7liLj3pEuLgLDqJpiPpQIVlQLrLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhmQ2sRtid+z/3ZYCtnz/Mku87YZzbuWIA/AKowTZDo2/2cS89Naz0y2Q2baHm2xv
         Mn6Rm16Bvqx+xH+WkgJE/PmW/+uQwqF0eWzQkviwwLSOgc2mTCKwF0dbgDB8P7rDby
         +dh33d1vqJSBnh7Cmh1+TtOazNPlY91GHvMBuQTixpXh5ir69Co+ovzS/4O0FTV+YZ
         IPo9EISmjgmvtHmnvxhYh8ejscRY9T3u3tkbaCSSbninkZ8WVIdRvJhACwH/Xzt94r
         GCMVtqLJjFxJ3+vRHOnF0SK+VCBnb5CWoWWXnFTJkj6tMeQkAJcfRszQ02mfKrx7Qp
         hML9NXottqGyA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v2 net-next 1/4] net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
Date:   Tue, 12 Jul 2022 23:16:14 +0200
Message-Id: <8c78967b7ac88b68986f9daa3bbb895d60798823.1657660277.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657660277.git.lorenzo@kernel.org>
References: <cover.1657660277.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on page_pool allocator for single page buffers in order to keep
them dma mapped and add skb recycling support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/Kconfig       |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 185 +++++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  10 ++
 3 files changed, 156 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index da4ec235d146..d2422c7b31b0 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -17,6 +17,7 @@ config NET_MEDIATEK_SOC
 	select PINCTRL
 	select PHYLINK
 	select DIMLIB
+	select PAGE_POOL
 	help
 	  This driver supports the gigabit ethernet MACs in the
 	  MediaTek SoC family.
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6beb3d4873a3..9a92d602ebd5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1432,6 +1432,68 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *eth)
 	}
 }
 
+static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
+					      struct xdp_rxq_info *xdp_q,
+					      int id, int size)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = NUMA_NO_NODE,
+		.dev = eth->dma_dev,
+		.dma_dir = DMA_FROM_DEVICE,
+		.offset = MTK_PP_HEADROOM,
+		.max_len = MTK_PP_MAX_BUF_SIZE,
+	};
+	struct page_pool *pp;
+	int err;
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp))
+		return pp;
+
+	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, eth->rx_napi.napi_id,
+				 id, PAGE_SIZE);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(xdp_q, MEM_TYPE_PAGE_POOL, pp);
+	if (err)
+		goto err_unregister_rxq;
+
+	return pp;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(xdp_q);
+err_free_pp:
+	page_pool_destroy(pp);
+
+	return ERR_PTR(err);
+}
+
+static void *mtk_page_pool_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
+				    gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
+	if (!page)
+		return NULL;
+
+	*dma_addr = page_pool_get_dma_addr(page) + MTK_PP_HEADROOM;
+	return page_address(page);
+}
+
+static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
+{
+	if (ring->page_pool)
+		page_pool_put_full_page(ring->page_pool,
+					virt_to_head_page(data), napi);
+	else
+		skb_free_frag(data);
+}
+
 static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		       struct mtk_eth *eth)
 {
@@ -1445,9 +1507,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
+		u32 hash, reason, reserve_len;
 		struct net_device *netdev;
 		dma_addr_t dma_addr;
-		u32 hash, reason;
 		int mac = 0;
 
 		ring = mtk_get_rx_ring(eth);
@@ -1478,36 +1540,54 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		if (ring->frag_size <= PAGE_SIZE)
-			new_data = napi_alloc_frag(ring->frag_size);
-		else
-			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
-		if (unlikely(!new_data)) {
-			netdev->stats.rx_dropped++;
-			goto release_desc;
-		}
-		dma_addr = dma_map_single(eth->dma_dev,
-					  new_data + NET_SKB_PAD +
-					  eth->ip_align,
-					  ring->buf_size,
-					  DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr))) {
-			skb_free_frag(new_data);
-			netdev->stats.rx_dropped++;
-			goto release_desc;
-		}
+		if (ring->page_pool) {
+			new_data = mtk_page_pool_get_buff(ring->page_pool,
+							  &dma_addr,
+							  GFP_ATOMIC);
+			if (unlikely(!new_data)) {
+				netdev->stats.rx_dropped++;
+				goto release_desc;
+			}
+		} else {
+			if (ring->frag_size <= PAGE_SIZE)
+				new_data = napi_alloc_frag(ring->frag_size);
+			else
+				new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
+
+			if (unlikely(!new_data)) {
+				netdev->stats.rx_dropped++;
+				goto release_desc;
+			}
 
-		dma_unmap_single(eth->dma_dev, trxd.rxd1,
-				 ring->buf_size, DMA_FROM_DEVICE);
+			dma_addr = dma_map_single(eth->dma_dev,
+				new_data + NET_SKB_PAD + eth->ip_align,
+				ring->buf_size, DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(eth->dma_dev,
+						       dma_addr))) {
+				skb_free_frag(new_data);
+				netdev->stats.rx_dropped++;
+				goto release_desc;
+			}
+
+			dma_unmap_single(eth->dma_dev, trxd.rxd1,
+					 ring->buf_size, DMA_FROM_DEVICE);
+		}
 
 		/* receive data */
 		skb = build_skb(data, ring->frag_size);
 		if (unlikely(!skb)) {
-			skb_free_frag(data);
+			mtk_rx_put_buff(ring, data, true);
 			netdev->stats.rx_dropped++;
 			goto skip_rx;
 		}
-		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
+
+		if (ring->page_pool) {
+			reserve_len = MTK_PP_HEADROOM;
+			skb_mark_for_recycle(skb);
+		} else {
+			reserve_len = NET_SKB_PAD + NET_IP_ALIGN;
+		}
+		skb_reserve(skb, reserve_len);
 
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
@@ -1561,7 +1641,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 skip_rx:
 		ring->data[idx] = new_data;
 		rxd->rxd1 = (unsigned int)dma_addr;
-
 release_desc:
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 			rxd->rxd2 = RX_DMA_LSO;
@@ -1569,7 +1648,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			rxd->rxd2 = RX_DMA_PREP_PLEN0(ring->buf_size);
 
 		ring->calc_idx = idx;
-
 		done++;
 	}
 
@@ -1933,13 +2011,15 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 	if (!ring->data)
 		return -ENOMEM;
 
-	for (i = 0; i < rx_dma_size; i++) {
-		if (ring->frag_size <= PAGE_SIZE)
-			ring->data[i] = netdev_alloc_frag(ring->frag_size);
-		else
-			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
-		if (!ring->data[i])
-			return -ENOMEM;
+	if (!eth->hwlro) {
+		struct page_pool *pp;
+
+		pp = mtk_create_page_pool(eth, &ring->xdp_q, ring_no,
+					  rx_dma_size);
+		if (IS_ERR(pp))
+			return PTR_ERR(pp);
+
+		ring->page_pool = pp;
 	}
 
 	ring->dma = dma_alloc_coherent(eth->dma_dev,
@@ -1950,16 +2030,33 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 	for (i = 0; i < rx_dma_size; i++) {
 		struct mtk_rx_dma_v2 *rxd;
-
-		dma_addr_t dma_addr = dma_map_single(eth->dma_dev,
-				ring->data[i] + NET_SKB_PAD + eth->ip_align,
-				ring->buf_size,
-				DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr)))
-			return -ENOMEM;
+		dma_addr_t dma_addr;
+		void *data;
 
 		rxd = ring->dma + i * eth->soc->txrx.rxd_size;
+		if (ring->page_pool) {
+			data = mtk_page_pool_get_buff(ring->page_pool,
+						      &dma_addr, GFP_KERNEL);
+			if (!data)
+				return -ENOMEM;
+		} else {
+			if (ring->frag_size <= PAGE_SIZE)
+				data = netdev_alloc_frag(ring->frag_size);
+			else
+				data = mtk_max_lro_buf_alloc(GFP_KERNEL);
+
+			if (!data)
+				return -ENOMEM;
+
+			dma_addr = dma_map_single(eth->dma_dev,
+				data + NET_SKB_PAD + eth->ip_align,
+				ring->buf_size, DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(eth->dma_dev,
+						       dma_addr)))
+				return -ENOMEM;
+		}
 		rxd->rxd1 = (unsigned int)dma_addr;
+		ring->data[i] = data;
 
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 			rxd->rxd2 = RX_DMA_LSO;
@@ -1975,6 +2072,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 			rxd->rxd8 = 0;
 		}
 	}
+
 	ring->dma_size = rx_dma_size;
 	ring->calc_idx_update = false;
 	ring->calc_idx = rx_dma_size - 1;
@@ -2026,7 +2124,7 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 
 			dma_unmap_single(eth->dma_dev, rxd->rxd1,
 					 ring->buf_size, DMA_FROM_DEVICE);
-			skb_free_frag(ring->data[i]);
+			mtk_rx_put_buff(ring, ring->data[i], false);
 		}
 		kfree(ring->data);
 		ring->data = NULL;
@@ -2038,6 +2136,13 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 				  ring->dma, ring->phys);
 		ring->dma = NULL;
 	}
+
+	if (ring->page_pool) {
+		if (xdp_rxq_info_is_reg(&ring->xdp_q))
+			xdp_rxq_info_unreg(&ring->xdp_q);
+		page_pool_destroy(ring->page_pool);
+		ring->page_pool = NULL;
+	}
 }
 
 static int mtk_hwlro_rx_init(struct mtk_eth *eth)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 0a632896451a..26c019319055 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -18,6 +18,8 @@
 #include <linux/rhashtable.h>
 #include <linux/dim.h>
 #include <linux/bitfield.h>
+#include <net/page_pool.h>
+#include <linux/bpf_trace.h>
 #include "mtk_ppe.h"
 
 #define MTK_QDMA_PAGE_SIZE	2048
@@ -49,6 +51,11 @@
 #define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
 #define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
+#define MTK_PP_HEADROOM		XDP_PACKET_HEADROOM
+#define MTK_PP_PAD		(MTK_PP_HEADROOM + \
+				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define MTK_PP_MAX_BUF_SIZE	(PAGE_SIZE - MTK_PP_PAD)
+
 #define MTK_QRX_OFFSET		0x10
 
 #define MTK_MAX_RX_RING_NUM	4
@@ -745,6 +752,9 @@ struct mtk_rx_ring {
 	bool calc_idx_update;
 	u16 calc_idx;
 	u32 crx_idx_reg;
+	/* page_pool */
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_q;
 };
 
 enum mkt_eth_capabilities {
-- 
2.36.1

