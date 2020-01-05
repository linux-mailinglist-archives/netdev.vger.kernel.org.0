Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B14A1307CB
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 12:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgAEL6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 06:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEL6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 06:58:02 -0500
Received: from new-host-5.station (net-2-42-61-77.cust.vodafonedsl.it [2.42.61.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6DE20866;
        Sun,  5 Jan 2020 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578225480;
        bh=auA62vwi4ZTisNq7zoJSsZyP2vvPWS9CZn3iP/TSowI=;
        h=From:To:Cc:Subject:Date:From;
        b=A22pJmFG/toJcU5aRKWOeN78wetVvwmrf30TTCtBB7Sz2mielMG8R9Wx0yPcfgu7j
         k6zlv9JWwzgAcXR96rnVni+PWOzfxwvTOW4kRHCypr+nRD3O6VLjFokJpqZgrxoqkv
         o8b3tWmFqVOnio5UQTLABx6fo8S9rnIBNvgztblg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        lorenzo.bianconi@redhat.com
Subject: [RFC/RFT net-next] net: socionext: get rid of huge dma sync in netsec_alloc_rx_data
Date:   Sun,  5 Jan 2020 12:57:56 +0100
Message-Id: <20094a678ea3d76fc1b8817ae0dd6d136cdc3860.1578225300.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socionext driver can run on dma coherent and non-coherent devices.
Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
now the driver can let page_pool API to managed needed DMA sync

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 60 ++++++++++++++-----------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index b5a9e947a4a8..7a2eb0e71d2a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -243,6 +243,7 @@
 			       NET_IP_ALIGN)
 #define NETSEC_RX_BUF_NON_DATA (NETSEC_RXBUF_HEADROOM + \
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define NETSEC_RX_BUF_SIZE	(PAGE_SIZE - NETSEC_RX_BUF_NON_DATA)
 
 #define DESC_SZ	sizeof(struct netsec_de)
 
@@ -714,12 +715,11 @@ static void netsec_process_tx(struct netsec_priv *priv)
 }
 
 static void *netsec_alloc_rx_data(struct netsec_priv *priv,
-				  dma_addr_t *dma_handle, u16 *desc_len)
+				  dma_addr_t *dma_handle)
 
 {
 
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
-	enum dma_data_direction dma_dir;
 	struct page *page;
 
 	page = page_pool_dev_alloc_pages(dring->page_pool);
@@ -734,10 +734,6 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	/* Make sure the incoming payload fits in the page for XDP and non-XDP
 	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
-	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
-	dma_dir = page_pool_get_dma_dir(dring->page_pool);
-	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
-
 	return page_address(page);
 }
 
@@ -883,6 +879,7 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
 static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			  struct xdp_buff *xdp)
 {
+	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
 	u32 ret = NETSEC_XDP_PASS;
 	int err;
 	u32 act;
@@ -896,7 +893,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 	case XDP_TX:
 		ret = netsec_xdp_xmit_back(priv, xdp);
 		if (ret != NETSEC_XDP_TX)
-			xdp_return_buff(xdp);
+			__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     xdp->data_end - xdp->data_hard_start,
+				     true);
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(priv->ndev, xdp, prog);
@@ -904,7 +904,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			ret = NETSEC_XDP_REDIR;
 		} else {
 			ret = NETSEC_XDP_CONSUMED;
-			xdp_return_buff(xdp);
+			__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     xdp->data_end - xdp->data_hard_start,
+				     true);
 		}
 		break;
 	default:
@@ -915,7 +918,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 		/* fall through -- handle aborts by dropping packet */
 	case XDP_DROP:
 		ret = NETSEC_XDP_CONSUMED;
-		xdp_return_buff(xdp);
+		__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     xdp->data_end - xdp->data_hard_start,
+				     true);
 		break;
 	}
 
@@ -944,10 +950,10 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
 		u32 xdp_result = XDP_PASS;
-		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
 		struct xdp_buff xdp;
 		void *buf_addr;
+		u16 pkt_len;
 
 		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
 			/* reading the register clears the irq */
@@ -982,8 +988,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		/* allocate a fresh buffer and map it to the hardware.
 		 * This will eventually replace the old buffer in the hardware
 		 */
-		buf_addr = netsec_alloc_rx_data(priv, &dma_handle, &desc_len);
-
+		buf_addr = netsec_alloc_rx_data(priv, &dma_handle);
 		if (unlikely(!buf_addr))
 			break;
 
@@ -1014,7 +1019,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 			 * cache state. Since we paid the allocation cost if
 			 * building an skb fails try to put the page into cache
 			 */
-			page_pool_recycle_direct(dring->page_pool, page);
+			__page_pool_put_page(dring->page_pool, page,
+					     desc->len, true);
 			netif_err(priv, drv, priv->ndev,
 				  "rx failed to build skb\n");
 			break;
@@ -1037,7 +1043,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		}
 
 		/* Update the descriptor with fresh buffers */
-		desc->len = desc_len;
+		desc->len = NETSEC_RX_BUF_SIZE;
 		desc->dma_addr = dma_handle;
 		desc->addr = buf_addr;
 
@@ -1272,17 +1278,19 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
 	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
-	struct page_pool_params pp_params = { 0 };
+	struct page_pool_params pp_params = {
+		.order = 0,
+		/* internal DMA mapping in page_pool */
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = DESC_NUM,
+		.nid = NUMA_NO_NODE,
+		.dev = priv->dev,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+		.offset = NETSEC_RXBUF_HEADROOM,
+		.max_len = NETSEC_RX_BUF_SIZE,
+	};
 	int i, err;
 
-	pp_params.order = 0;
-	/* internal DMA mapping in page_pool */
-	pp_params.flags = PP_FLAG_DMA_MAP;
-	pp_params.pool_size = DESC_NUM;
-	pp_params.nid = NUMA_NO_NODE;
-	pp_params.dev = priv->dev;
-	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-
 	dring->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(dring->page_pool)) {
 		err = PTR_ERR(dring->page_pool);
@@ -1303,17 +1311,15 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 		struct netsec_desc *desc = &dring->desc[i];
 		dma_addr_t dma_handle;
 		void *buf;
-		u16 len;
-
-		buf = netsec_alloc_rx_data(priv, &dma_handle, &len);
 
+		buf = netsec_alloc_rx_data(priv, &dma_handle);
 		if (!buf) {
 			err = -ENOMEM;
 			goto err_out;
 		}
+		desc->len = NETSEC_RX_BUF_SIZE;
 		desc->dma_addr = dma_handle;
 		desc->addr = buf;
-		desc->len = len;
 	}
 
 	netsec_rx_fill(priv, 0, DESC_NUM);
-- 
2.21.1

