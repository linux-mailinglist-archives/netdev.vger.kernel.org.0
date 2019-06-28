Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280F85988C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfF1Kjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:39:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34778 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfF1Kjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:39:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so9045422wmd.1
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 03:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m6+ZOA6WCB5tUFbM8EVXOBvKjOZJWASoT89nEIqWhis=;
        b=poCclX2kYfGq/1UjbebXuw2gjGIxS58Ob61CrkKwLKRl6okK1Ro8ri4u1+ZGRLoRgh
         KzmttXUyLIxOzbpQvr9vxsmVOywgMMrdsnHlBrjE7fmIu/o4Ucl30H45qS2qwctsNrRE
         rzPPm7NJ+KNS7uHs6n98xSgPqXE4m2bOflsIbdwJWEpUpwJsvez0jso2fhvp922oUmlF
         CkcLtavEVB5qcD4m5/Blt+z5igC3/DNfv2o+CQi+y4HZwbr24j1eNGbC948njaSmUzS0
         b3BrqOZsDxzYQqzqpv146TQ3fmThrd8mOEOZiDbXW0KD71lZzdEsGd/Q0FHDZMvrCQWE
         JLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m6+ZOA6WCB5tUFbM8EVXOBvKjOZJWASoT89nEIqWhis=;
        b=QfGb650fxEzu58l+OK2ph23d2Laz7ZIRBTCHXYL/hcZprtG5pAHaJX4YXwPIK0BZ01
         ZROS8/rQoM7XHyNEX0LsU52joNviYrWGSy7vTunJVPfltStj4xpw7MTiXCGRLVtH9rN5
         KvLvJq2Cd6TXJ54boxTefDNxLDYnyXRvyGa5e2j9Lammp8UDTYEuAcgR1o5eTqcXc812
         usxawk40XeL9C9uumtt/ns5kqK2VfIWDQTnoRhIaYiR6U79IlzhaED46n9Y+zIqpKLME
         L7KnKMNZa5/6yB6puHw6pd0LLrz1bKNlK/hyNdMOLXwodPQczZDCQ2+c50ndzFT1e4Wy
         z5ow==
X-Gm-Message-State: APjAAAUKRv1tV0X5cqVeMH2onQFLo7c7DakXwb1lnyUuzVdB9q5IsfKB
        6QBRdWfj5BL2uVBx6+tKLyqtYahuj0g=
X-Google-Smtp-Source: APXvYqw31MtxzUUxxuEh9Hj5wf+iUc8+6vU52I2JfM/sIUjGEu61cytR2maK3yeu6OI2Bsr2UY4v+w==
X-Received: by 2002:a1c:7408:: with SMTP id p8mr6472090wmc.161.1561718379667;
        Fri, 28 Jun 2019 03:39:39 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id r5sm3397742wrg.10.2019.06.28.03.39.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 03:39:39 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 1/3, net-next] net: netsec: Use page_pool API
Date:   Fri, 28 Jun 2019 13:39:13 +0300
Message-Id: <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use page_pool and it's DMA mapping capabilities for Rx buffers instead
of netdev/napi_alloc_frag()

Although this will result in a slight performance penalty on small sized
packets (~10%) the use of the API will allow to easily add XDP support.
The penalty won't be visible in network testing i.e ipef/netperf etc, it
only happens during raw packet drops.
Furthermore we intend to add recycling capabilities on the API
in the future. Once the recycling is added the performance penalty will
go away.
The only 'real' penalty is the slightly increased memory usage, since we
now allocate a page per packet instead of the amount of bytes we need +
skb metadata (difference is roughly 2kb per packet).
With a minimum of 4BG of RAM on the only SoC that has this NIC the
extra memory usage is negligible (a bit more on 64K pages)

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/Kconfig  |   1 +
 drivers/net/ethernet/socionext/netsec.c | 121 +++++++++++++++---------
 2 files changed, 75 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/socionext/Kconfig b/drivers/net/ethernet/socionext/Kconfig
index 25f18be27423..95e99baf3f45 100644
--- a/drivers/net/ethernet/socionext/Kconfig
+++ b/drivers/net/ethernet/socionext/Kconfig
@@ -26,6 +26,7 @@ config SNI_NETSEC
 	tristate "Socionext NETSEC ethernet support"
 	depends on (ARCH_SYNQUACER || COMPILE_TEST) && OF
 	select PHYLIB
+	select PAGE_POOL
 	select MII
 	---help---
 	  Enable to add support for the SocioNext NetSec Gigabit Ethernet
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 48fd7448b513..e653b24d0534 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 
 #include <net/tcp.h>
+#include <net/page_pool.h>
 #include <net/ip6_checksum.h>
 
 #define NETSEC_REG_SOFT_RST			0x104
@@ -235,7 +236,8 @@
 #define DESC_NUM	256
 
 #define NETSEC_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
-#define NETSEC_RX_BUF_SZ 1536
+#define NETSEC_RX_BUF_NON_DATA (NETSEC_SKB_PAD + \
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 #define DESC_SZ	sizeof(struct netsec_de)
 
@@ -258,6 +260,8 @@ struct netsec_desc_ring {
 	struct netsec_desc *desc;
 	void *vaddr;
 	u16 head, tail;
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct netsec_priv {
@@ -673,33 +677,27 @@ static void netsec_process_tx(struct netsec_priv *priv)
 }
 
 static void *netsec_alloc_rx_data(struct netsec_priv *priv,
-				  dma_addr_t *dma_handle, u16 *desc_len,
-				  bool napi)
+				  dma_addr_t *dma_handle, u16 *desc_len)
+
 {
-	size_t total_len = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	size_t payload_len = NETSEC_RX_BUF_SZ;
-	dma_addr_t mapping;
-	void *buf;
 
-	total_len += SKB_DATA_ALIGN(payload_len + NETSEC_SKB_PAD);
+	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	struct page *page;
 
-	buf = napi ? napi_alloc_frag(total_len) : netdev_alloc_frag(total_len);
-	if (!buf)
+	page = page_pool_dev_alloc_pages(dring->page_pool);
+	if (!page)
 		return NULL;
 
-	mapping = dma_map_single(priv->dev, buf + NETSEC_SKB_PAD, payload_len,
-				 DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, mapping)))
-		goto err_out;
-
-	*dma_handle = mapping;
-	*desc_len = payload_len;
-
-	return buf;
+	/* page_pool API will map the whole page, skip
+	 * NET_SKB_PAD + NET_IP_ALIGN for the payload
+	 */
+	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_SKB_PAD;
+	/* make sure the incoming payload fits in the page with the needed
+	 * NET_SKB_PAD + NET_IP_ALIGN + skb_shared_info
+	 */
+	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
 
-err_out:
-	skb_free_frag(buf);
-	return NULL;
+	return page_address(page);
 }
 
 static void netsec_rx_fill(struct netsec_priv *priv, u16 from, u16 num)
@@ -728,10 +726,10 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		u16 idx = dring->tail;
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
+		struct page *page = virt_to_page(desc->addr);
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
 		void *buf_addr;
-		u32 truesize;
 
 		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
 			/* reading the register clears the irq */
@@ -766,8 +764,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		/* allocate a fresh buffer and map it to the hardware.
 		 * This will eventually replace the old buffer in the hardware
 		 */
-		buf_addr = netsec_alloc_rx_data(priv, &dma_handle, &desc_len,
-						true);
+		buf_addr = netsec_alloc_rx_data(priv, &dma_handle, &desc_len);
+
 		if (unlikely(!buf_addr))
 			break;
 
@@ -775,22 +773,19 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 					DMA_FROM_DEVICE);
 		prefetch(desc->addr);
 
-		truesize = SKB_DATA_ALIGN(desc->len + NETSEC_SKB_PAD) +
-			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		skb = build_skb(desc->addr, truesize);
+		skb = build_skb(desc->addr, desc->len + NETSEC_RX_BUF_NON_DATA);
 		if (unlikely(!skb)) {
-			/* free the newly allocated buffer, we are not going to
-			 * use it
+			/* If skb fails recycle_direct will either unmap and
+			 * free the page or refill the cache depending on the
+			 * cache state. Since we paid the allocation cost if
+			 * building an skb fails try to put the page into cache
 			 */
-			dma_unmap_single(priv->dev, dma_handle, desc_len,
-					 DMA_FROM_DEVICE);
-			skb_free_frag(buf_addr);
+			page_pool_recycle_direct(dring->page_pool, page);
 			netif_err(priv, drv, priv->ndev,
 				  "rx failed to build skb\n");
 			break;
 		}
-		dma_unmap_single_attrs(priv->dev, desc->dma_addr, desc->len,
-				       DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+		page_pool_release_page(dring->page_pool, page);
 
 		/* Update the descriptor with the new buffer we allocated */
 		desc->len = desc_len;
@@ -980,21 +975,26 @@ static void netsec_uninit_pkt_dring(struct netsec_priv *priv, int id)
 
 	if (!dring->vaddr || !dring->desc)
 		return;
-
 	for (idx = 0; idx < DESC_NUM; idx++) {
 		desc = &dring->desc[idx];
 		if (!desc->addr)
 			continue;
 
-		dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
-				 id == NETSEC_RING_RX ? DMA_FROM_DEVICE :
-							      DMA_TO_DEVICE);
-		if (id == NETSEC_RING_RX)
-			skb_free_frag(desc->addr);
-		else if (id == NETSEC_RING_TX)
+		if (id == NETSEC_RING_RX) {
+			struct page *page = virt_to_page(desc->addr);
+
+			page_pool_put_page(dring->page_pool, page, false);
+		} else if (id == NETSEC_RING_TX) {
+			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb(desc->skb);
+		}
 	}
 
+	/* Rx is currently using page_pool */
+	if (xdp_rxq_info_is_reg(&dring->xdp_rxq))
+		xdp_rxq_info_unreg(&dring->xdp_rxq);
+
 	memset(dring->desc, 0, sizeof(struct netsec_desc) * DESC_NUM);
 	memset(dring->vaddr, 0, DESC_SZ * DESC_NUM);
 
@@ -1059,7 +1059,23 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
 static int netsec_setup_rx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
-	int i;
+	struct page_pool_params pp_params = { 0 };
+	int i, err;
+
+	pp_params.order = 0;
+	/* internal DMA mapping in page_pool */
+	pp_params.flags = PP_FLAG_DMA_MAP;
+	pp_params.pool_size = DESC_NUM;
+	pp_params.nid = cpu_to_node(0);
+	pp_params.dev = priv->dev;
+	pp_params.dma_dir = DMA_FROM_DEVICE;
+
+	dring->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(dring->page_pool)) {
+		err = PTR_ERR(dring->page_pool);
+		dring->page_pool = NULL;
+		goto err_out;
+	}
 
 	for (i = 0; i < DESC_NUM; i++) {
 		struct netsec_desc *desc = &dring->desc[i];
@@ -1067,10 +1083,10 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 		void *buf;
 		u16 len;
 
-		buf = netsec_alloc_rx_data(priv, &dma_handle, &len,
-					   false);
+		buf = netsec_alloc_rx_data(priv, &dma_handle, &len);
+
 		if (!buf) {
-			netsec_uninit_pkt_dring(priv, NETSEC_RING_RX);
+			err = -ENOMEM;
 			goto err_out;
 		}
 		desc->dma_addr = dma_handle;
@@ -1079,11 +1095,22 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 	}
 
 	netsec_rx_fill(priv, 0, DESC_NUM);
+	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0);
+	if (err)
+		goto err_out;
+
+	err = xdp_rxq_info_reg_mem_model(&dring->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 dring->page_pool);
+	if (err) {
+		page_pool_free(dring->page_pool);
+		goto err_out;
+	}
 
 	return 0;
 
 err_out:
-	return -ENOMEM;
+	netsec_uninit_pkt_dring(priv, NETSEC_RING_RX);
+	return err;
 }
 
 static int netsec_netdev_load_ucode_region(struct netsec_priv *priv, u32 reg,
-- 
2.20.1

