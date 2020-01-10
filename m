Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF052136ED9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgAJN54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727503AbgAJN5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 08:57:55 -0500
Received: from localhost.localdomain.com (mob-176-246-50-46.net.vodafone.it [176.246.50.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 504D32072E;
        Fri, 10 Jan 2020 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578664674;
        bh=FDvqn5gzu+XlgXmfvrv9xYlw6SXOT0W4toCRURJ9jdk=;
        h=From:To:Cc:Subject:Date:From;
        b=p3FL5m9ZvPYZP4LBa4ep3Uqx98Rr8sCSHAzpW/wiF+G9V5qnujd9J3YAc+nccXlRg
         d2Q+mnnHF4srFgKhUaTwFFPO3ZieS/HG2apvzbKeAcZCojx6MiVsCTTlrqc49u/2yW
         Ht803xHIeWvU6ms63FeIUmQdQ/OrN8FezNkYpZ10=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in netsec_alloc_rx_data
Date:   Fri, 10 Jan 2020 14:57:44 +0100
Message-Id: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
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
Changes since v1:
- rely on original frame size for dma sync
---
 drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index b5a9e947a4a8..45c76b437457 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -243,6 +243,7 @@
 			       NET_IP_ALIGN)
 #define NETSEC_RX_BUF_NON_DATA (NETSEC_RXBUF_HEADROOM + \
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define NETSEC_RX_BUF_SIZE	(PAGE_SIZE - NETSEC_RX_BUF_NON_DATA)
 
 #define DESC_SZ	sizeof(struct netsec_de)
 
@@ -719,7 +720,6 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 {
 
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
-	enum dma_data_direction dma_dir;
 	struct page *page;
 
 	page = page_pool_dev_alloc_pages(dring->page_pool);
@@ -734,9 +734,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	/* Make sure the incoming payload fits in the page for XDP and non-XDP
 	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
-	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
-	dma_dir = page_pool_get_dma_dir(dring->page_pool);
-	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
+	*desc_len = NETSEC_RX_BUF_SIZE;
 
 	return page_address(page);
 }
@@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
 static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			  struct xdp_buff *xdp)
 {
+	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	unsigned int len = xdp->data_end - xdp->data;
 	u32 ret = NETSEC_XDP_PASS;
 	int err;
 	u32 act;
@@ -896,7 +896,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 	case XDP_TX:
 		ret = netsec_xdp_xmit_back(priv, xdp);
 		if (ret != NETSEC_XDP_TX)
-			xdp_return_buff(xdp);
+			__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     len, true);
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(priv->ndev, xdp, prog);
@@ -904,7 +906,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			ret = NETSEC_XDP_REDIR;
 		} else {
 			ret = NETSEC_XDP_CONSUMED;
-			xdp_return_buff(xdp);
+			__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     len, true);
 		}
 		break;
 	default:
@@ -915,7 +919,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 		/* fall through -- handle aborts by dropping packet */
 	case XDP_DROP:
 		ret = NETSEC_XDP_CONSUMED;
-		xdp_return_buff(xdp);
+		__page_pool_put_page(dring->page_pool,
+				     virt_to_head_page(xdp->data),
+				     len, true);
 		break;
 	}
 
@@ -1014,7 +1020,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 			 * cache state. Since we paid the allocation cost if
 			 * building an skb fails try to put the page into cache
 			 */
-			page_pool_recycle_direct(dring->page_pool, page);
+			__page_pool_put_page(dring->page_pool, page,
+					     pkt_len, true);
 			netif_err(priv, drv, priv->ndev,
 				  "rx failed to build skb\n");
 			break;
@@ -1272,17 +1279,19 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
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
-- 
2.21.1

