Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2542125D7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgGBOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:14:19 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:39540 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgGBOOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:14:19 -0400
Received: by mail-ej1-f67.google.com with SMTP id w6so29850011ejq.6;
        Thu, 02 Jul 2020 07:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q89I1ySKymBId6rZo4L3MUOtVh2K642+GZDrzgVlFFE=;
        b=nBPANgJfiEpYRmkMIt14ZzSH1ebIW4ZKvGgJD6ZJqBBcjIKOthBjUbcsMm2Gl0cAAs
         fjPbo2ob0rYdNOybDgEpO5ZMNbYzKy6kmWci72CJo38CtGuKWNGf0FaWh16uLwH2Jpo5
         IctGVCnXs8Lw31aC0QYfM/WhSiwLcHJulyT6/Mip1/RUWX+I2x4itmYSagMo8ufUsgG4
         rYnTD7CeTq2uRkh/S6JZUD8A9I8NejNpm0AkJ6KkL60bdTkBssR5O8pWlFWG1bM6rkyD
         SGgJ/sAxi7Lm8e/GrHitYkRpNGwDYzwr5nMrRju/jAmgY8EwShr/TGT4V8MVWjAzUEqW
         9TuQ==
X-Gm-Message-State: AOAM532vXto/vOI/stw8PP6g9mSnjPd+itdOAczZgvvIlcJXhYKBcHhE
        vXKByKgW+sx1K/WPlic1rQtVqcZW7dZR5Q==
X-Google-Smtp-Source: ABdhPJzm6v+ZaFsaVn+W0rB3MAAT8fHDsWvd83PkkkZfPoPeqshuO4rj7QmY4OXtNDrOpSfaRkRpQg==
X-Received: by 2002:a17:906:1a54:: with SMTP id j20mr27301344ejf.455.1593699254591;
        Thu, 02 Jul 2020 07:14:14 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id fi29sm6841274ejb.83.2020.07.02.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 07:14:13 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 2/5] mvpp2: use page_pool allocator
Date:   Thu,  2 Jul 2020 16:12:41 +0200
Message-Id: <20200702141244.51295-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702141244.51295-1-mcroce@linux.microsoft.com>
References: <20200702141244.51295-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Use the page_pool API for memory management.
This is a prerequisite for native XDP support.

Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   8 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 156 +++++++++++++++---
 3 files changed, 140 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index cd8ddd1ef6f2..ef4f35ba077d 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -87,6 +87,7 @@ config MVPP2
 	depends on ARCH_MVEBU || COMPILE_TEST
 	select MVMDIO
 	select PHYLINK
+	select PAGE_POOL
 	help
 	  This driver supports the network interface units in the
 	  Marvell ARMADA 375, 7K and 8K SoCs.
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 543a310ec102..4c16c9e9c1e5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <net/flow_offload.h>
+#include <net/page_pool.h>
 
 /* Fifo Registers */
 #define MVPP2_RX_DATA_FIFO_SIZE_REG(port)	(0x00 + 4 * (port))
@@ -820,6 +821,9 @@ struct mvpp2 {
 
 	/* RSS Indirection tables */
 	struct mvpp2_rss_table *rss_tables[MVPP22_N_RSS_TABLES];
+
+	/* page_pool allocator */
+	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
 };
 
 struct mvpp2_pcpu_stats {
@@ -1161,6 +1165,10 @@ struct mvpp2_rx_queue {
 
 	/* Port's logic RXQ number to which physical RXQ is mapped */
 	int logic_rxq;
+
+	/* XDP memory accounting */
+	struct xdp_rxq_info xdp_rxq_short;
+	struct xdp_rxq_info xdp_rxq_long;
 };
 
 struct mvpp2_bm_pool {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 027de7291f92..5d0e02c161a6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -95,6 +95,22 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 	return cpu % priv->nthreads;
 }
 
+static struct page_pool *
+mvpp2_create_page_pool(struct device *dev, int num, int len)
+{
+	struct page_pool_params pp_params = {
+		/* internal DMA mapping in page_pool */
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = num,
+		.nid = NUMA_NO_NODE,
+		.dev = dev,
+		.dma_dir = DMA_FROM_DEVICE,
+		.max_len = len,
+	};
+
+	return page_pool_create(&pp_params);
+}
+
 /* These accessors should be used to access:
  *
  * - per-thread registers, where each thread has its own copy of the
@@ -327,17 +343,25 @@ static inline int mvpp2_txq_phys(int port, int txq)
 	return (MVPP2_MAX_TCONT + port) * MVPP2_MAX_TXQ + txq;
 }
 
-static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool)
+/* Returns a struct page if page_pool is set, otherwise a buffer */
+static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool,
+			      struct page_pool *page_pool)
 {
+	if (page_pool)
+		return page_pool_dev_alloc_pages(page_pool);
+
 	if (likely(pool->frag_size <= PAGE_SIZE))
 		return netdev_alloc_frag(pool->frag_size);
-	else
-		return kmalloc(pool->frag_size, GFP_ATOMIC);
+
+	return kmalloc(pool->frag_size, GFP_ATOMIC);
 }
 
-static void mvpp2_frag_free(const struct mvpp2_bm_pool *pool, void *data)
+static void mvpp2_frag_free(const struct mvpp2_bm_pool *pool,
+			    struct page_pool *page_pool, void *data)
 {
-	if (likely(pool->frag_size <= PAGE_SIZE))
+	if (page_pool)
+		page_pool_put_full_page(page_pool, virt_to_head_page(data), false);
+	else if (likely(pool->frag_size <= PAGE_SIZE))
 		skb_free_frag(data);
 	else
 		kfree(data);
@@ -442,6 +466,7 @@ static void mvpp2_bm_bufs_get_addrs(struct device *dev, struct mvpp2 *priv,
 static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 			       struct mvpp2_bm_pool *bm_pool, int buf_num)
 {
+	struct page_pool *pp = NULL;
 	int i;
 
 	if (buf_num > bm_pool->buf_num) {
@@ -450,6 +475,9 @@ static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 		buf_num = bm_pool->buf_num;
 	}
 
+	if (priv->percpu_pools)
+		pp = priv->page_pool[bm_pool->id];
+
 	for (i = 0; i < buf_num; i++) {
 		dma_addr_t buf_dma_addr;
 		phys_addr_t buf_phys_addr;
@@ -458,14 +486,15 @@ static void mvpp2_bm_bufs_free(struct device *dev, struct mvpp2 *priv,
 		mvpp2_bm_bufs_get_addrs(dev, priv, bm_pool,
 					&buf_dma_addr, &buf_phys_addr);
 
-		dma_unmap_single(dev, buf_dma_addr,
-				 bm_pool->buf_size, DMA_FROM_DEVICE);
+		if (!pp)
+			dma_unmap_single(dev, buf_dma_addr,
+					 bm_pool->buf_size, DMA_FROM_DEVICE);
 
 		data = (void *)phys_to_virt(buf_phys_addr);
 		if (!data)
 			break;
 
-		mvpp2_frag_free(bm_pool, data);
+		mvpp2_frag_free(bm_pool, pp, data);
 	}
 
 	/* Update BM driver with number of buffers removed from pool */
@@ -496,6 +525,9 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 	int buf_num;
 	u32 val;
 
+	if (priv->percpu_pools)
+		page_pool_destroy(priv->page_pool[bm_pool->id]);
+
 	buf_num = mvpp2_check_hw_buf_num(priv, bm_pool);
 	mvpp2_bm_bufs_free(dev, priv, bm_pool, buf_num);
 
@@ -548,8 +580,20 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
 	int i, err, poolnum = MVPP2_BM_POOLS_NUM;
 
-	if (priv->percpu_pools)
+	if (priv->percpu_pools) {
 		poolnum = mvpp2_get_nrxqs(priv) * 2;
+		for (i = 0; i < poolnum; i++) {
+			/* the pool in use */
+			int pn = i / (poolnum / 2);
+
+			priv->page_pool[i] =
+				mvpp2_create_page_pool(dev,
+						       mvpp2_pools[pn].buf_num,
+						       mvpp2_pools[pn].pkt_size);
+			if (IS_ERR(priv->page_pool[i]))
+				return PTR_ERR(priv->page_pool[i]);
+		}
+	}
 
 	dev_info(dev, "using %d %s buffers\n", poolnum,
 		 priv->percpu_pools ? "per-cpu" : "shared");
@@ -632,23 +676,31 @@ static void mvpp2_rxq_short_pool_set(struct mvpp2_port *port,
 
 static void *mvpp2_buf_alloc(struct mvpp2_port *port,
 			     struct mvpp2_bm_pool *bm_pool,
+			     struct page_pool *page_pool,
 			     dma_addr_t *buf_dma_addr,
 			     phys_addr_t *buf_phys_addr,
 			     gfp_t gfp_mask)
 {
 	dma_addr_t dma_addr;
+	struct page *page;
 	void *data;
 
-	data = mvpp2_frag_alloc(bm_pool);
+	data = mvpp2_frag_alloc(bm_pool, page_pool);
 	if (!data)
 		return NULL;
 
-	dma_addr = dma_map_single(port->dev->dev.parent, data,
-				  MVPP2_RX_BUF_SIZE(bm_pool->pkt_size),
-				  DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
-		mvpp2_frag_free(bm_pool, data);
-		return NULL;
+	if (page_pool) {
+		page = (struct page *)data;
+		dma_addr = page_pool_get_dma_addr(page);
+		data = page_to_virt(page);
+	} else {
+		dma_addr = dma_map_single(port->dev->dev.parent, data,
+					  MVPP2_RX_BUF_SIZE(bm_pool->pkt_size),
+					  DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
+			mvpp2_frag_free(bm_pool, NULL, data);
+			return NULL;
+		}
 	}
 	*buf_dma_addr = dma_addr;
 	*buf_phys_addr = virt_to_phys(data);
@@ -706,6 +758,7 @@ static int mvpp2_bm_bufs_add(struct mvpp2_port *port,
 	int i, buf_size, total_size;
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
+	struct page_pool *pp = NULL;
 	void *buf;
 
 	if (port->priv->percpu_pools &&
@@ -726,8 +779,10 @@ static int mvpp2_bm_bufs_add(struct mvpp2_port *port,
 		return 0;
 	}
 
+	if (port->priv->percpu_pools)
+		pp = port->priv->page_pool[bm_pool->id];
 	for (i = 0; i < buf_num; i++) {
-		buf = mvpp2_buf_alloc(port, bm_pool, &dma_addr,
+		buf = mvpp2_buf_alloc(port, bm_pool, pp, &dma_addr,
 				      &phys_addr, GFP_KERNEL);
 		if (!buf)
 			break;
@@ -2374,10 +2429,11 @@ static int mvpp2_aggr_txq_init(struct platform_device *pdev,
 /* Create a specified Rx queue */
 static int mvpp2_rxq_init(struct mvpp2_port *port,
 			  struct mvpp2_rx_queue *rxq)
-
 {
+	struct mvpp2 *priv = port->priv;
 	unsigned int thread;
 	u32 rxq_dma;
+	int err;
 
 	rxq->size = port->rx_ring_size;
 
@@ -2415,7 +2471,43 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	/* Add number of descriptors ready for receiving packets */
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
+	if (priv->percpu_pools) {
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id);
+		if (err < 0)
+			goto err_free_dma;
+
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id);
+		if (err < 0)
+			goto err_unregister_rxq_short;
+
+		/* Every RXQ has a pool for short and another for long packets */
+		err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_short,
+						 MEM_TYPE_PAGE_POOL,
+						 priv->page_pool[rxq->logic_rxq]);
+		if (err < 0)
+			goto err_unregister_rxq_long;
+
+		err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_long,
+						 MEM_TYPE_PAGE_POOL,
+						 priv->page_pool[rxq->logic_rxq +
+								 port->nrxqs]);
+		if (err < 0)
+			goto err_unregister_mem_rxq_short;
+	}
+
 	return 0;
+
+err_unregister_mem_rxq_short:
+	xdp_rxq_info_unreg_mem_model(&rxq->xdp_rxq_short);
+err_unregister_rxq_long:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq_long);
+err_unregister_rxq_short:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq_short);
+err_free_dma:
+	dma_free_coherent(port->dev->dev.parent,
+			  rxq->size * MVPP2_DESC_ALIGNED_SIZE,
+			  rxq->descs, rxq->descs_dma);
+	return err;
 }
 
 /* Push packets received by the RXQ to BM pool */
@@ -2449,6 +2541,12 @@ static void mvpp2_rxq_deinit(struct mvpp2_port *port,
 {
 	unsigned int thread;
 
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq_short))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq_short);
+
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq_long))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq_long);
+
 	mvpp2_rxq_drop_pkts(port, rxq);
 
 	if (rxq->descs)
@@ -2890,14 +2988,15 @@ static void mvpp2_rx_csum(struct mvpp2_port *port, u32 status,
 
 /* Allocate a new skb and add it to BM pool */
 static int mvpp2_rx_refill(struct mvpp2_port *port,
-			   struct mvpp2_bm_pool *bm_pool, int pool)
+			   struct mvpp2_bm_pool *bm_pool,
+			   struct page_pool *page_pool, int pool)
 {
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
 	void *buf;
 
-	buf = mvpp2_buf_alloc(port, bm_pool, &dma_addr, &phys_addr,
-			      GFP_ATOMIC);
+	buf = mvpp2_buf_alloc(port, bm_pool, page_pool,
+			      &dma_addr, &phys_addr, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 
@@ -2956,6 +3055,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	while (rx_done < rx_todo) {
 		struct mvpp2_rx_desc *rx_desc = mvpp2_rxq_next_desc_get(rxq);
 		struct mvpp2_bm_pool *bm_pool;
+		struct page_pool *pp = NULL;
 		struct sk_buff *skb;
 		unsigned int frag_size;
 		dma_addr_t dma_addr;
@@ -2989,6 +3089,9 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					DMA_FROM_DEVICE);
 		prefetch(data);
 
+		if (port->priv->percpu_pools)
+			pp = port->priv->page_pool[pool];
+
 		if (bm_pool->frag_size > PAGE_SIZE)
 			frag_size = 0;
 		else
@@ -3000,15 +3103,18 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			goto err_drop_frame;
 		}
 
-		err = mvpp2_rx_refill(port, bm_pool, pool);
+		err = mvpp2_rx_refill(port, bm_pool, pp, pool);
 		if (err) {
 			netdev_err(port->dev, "failed to refill BM pools\n");
 			goto err_drop_frame;
 		}
 
-		dma_unmap_single_attrs(dev->dev.parent, dma_addr,
-				       bm_pool->buf_size, DMA_FROM_DEVICE,
-				       DMA_ATTR_SKIP_CPU_SYNC);
+		if (pp)
+			page_pool_release_page(pp, virt_to_page(data));
+		else
+			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
+					       bm_pool->buf_size, DMA_FROM_DEVICE,
+					       DMA_ATTR_SKIP_CPU_SYNC);
 
 		rcvd_pkts++;
 		rcvd_bytes += rx_bytes;
-- 
2.26.2

