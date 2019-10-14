Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8FD6090
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbfJNKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731449AbfJNKul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:41 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CD020873;
        Mon, 14 Oct 2019 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050241;
        bh=OktE2SiUCpokyP/z7/rLxGgnyv/iRRnFyolWXEH9qf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB0ywMWCzTbuglD3JuxDxSBKHZyUgk7h5sGcl/6+VTJDbFg9U0djPRlzGfYAmsUYi
         fEKqPuThGXAjN8Z+K1si3S+OPKDB6Kuj9liNnUxGFujY743y2j1DF9yRCmXdMEXNJO
         9s4Vxn7IoUPCyPsxSyEvjAk6fZyjEuI4RPLdOMks=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 3/8] net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
Date:   Mon, 14 Oct 2019 12:49:50 +0200
Message-Id: <879290b9a7ee1d0908af7a0db7dfbaae964daa22.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
allocate skb since the previous patch introduced buffer recycling using
the page_pool API.
This patch fixes even an issue in the original driver where dma buffers
are accessed before dma sync

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 197 ++++++++++++++------------
 1 file changed, 103 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 31cecc1ed848..77d4e8a48dd9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -323,6 +323,11 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
 
+#define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
+			 NET_SKB_PAD))
+#define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
+#define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
+
 #define IS_TSO_HEADER(txq, addr) \
 	((addr >= txq->tso_hdrs_phys) && \
 	 (addr < txq->tso_hdrs_phys + txq->size * TSO_HEADER_SIZE))
@@ -646,7 +651,6 @@ static int txq_number = 8;
 static int rxq_def;
 
 static int rx_copybreak __read_mostly = 256;
-static int rx_header_size __read_mostly = 128;
 
 /* HW BM need that each port be identify by a unique ID */
 static int global_port_id;
@@ -1942,30 +1946,101 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 	return i;
 }
 
+static int
+mvneta_swbm_rx_frame(struct mvneta_port *pp,
+		     struct mvneta_rx_desc *rx_desc,
+		     struct mvneta_rx_queue *rxq,
+		     struct page *page)
+{
+	unsigned char *data = page_address(page);
+	int data_len = -MVNETA_MH_SIZE, len;
+	struct net_device *dev = pp->dev;
+	enum dma_data_direction dma_dir;
+
+	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
+		len = MVNETA_MAX_RX_BUF_SIZE;
+		data_len += len;
+	} else {
+		len = rx_desc->data_size;
+		data_len += len - ETH_FCS_LEN;
+	}
+
+	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
+	dma_sync_single_for_cpu(dev->dev.parent,
+				rx_desc->buf_phys_addr,
+				len, dma_dir);
+
+	rxq->skb = build_skb(data, PAGE_SIZE);
+	if (unlikely(!rxq->skb)) {
+		netdev_err(dev,
+			   "Can't allocate skb on queue %d\n",
+			   rxq->id);
+		dev->stats.rx_dropped++;
+		rxq->skb_alloc_err++;
+		return -ENOMEM;
+	}
+	page_pool_release_page(rxq->page_pool, page);
+
+	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
+	skb_put(rxq->skb, data_len);
+	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
+
+	rxq->left_size = rx_desc->data_size - len;
+	rx_desc->buf_phys_addr = 0;
+
+	return 0;
+}
+
+static void
+mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
+			    struct mvneta_rx_desc *rx_desc,
+			    struct mvneta_rx_queue *rxq,
+			    struct page *page)
+{
+	struct net_device *dev = pp->dev;
+	enum dma_data_direction dma_dir;
+	int data_len, len;
+
+	if (rxq->left_size > MVNETA_MAX_RX_BUF_SIZE) {
+		len = MVNETA_MAX_RX_BUF_SIZE;
+		data_len = len;
+	} else {
+		len = rxq->left_size;
+		data_len = len - ETH_FCS_LEN;
+	}
+	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
+	dma_sync_single_for_cpu(dev->dev.parent,
+				rx_desc->buf_phys_addr,
+				len, dma_dir);
+	if (data_len > 0) {
+		/* refill descriptor with new buffer later */
+		skb_add_rx_frag(rxq->skb,
+				skb_shinfo(rxq->skb)->nr_frags,
+				page, NET_SKB_PAD, data_len,
+				PAGE_SIZE);
+	}
+	page_pool_release_page(rxq->page_pool, page);
+	rx_desc->buf_phys_addr = 0;
+	rxq->left_size -= len;
+}
+
 /* Main rx processing when using software buffer management */
 static int mvneta_rx_swbm(struct napi_struct *napi,
 			  struct mvneta_port *pp, int budget,
 			  struct mvneta_rx_queue *rxq)
 {
-	struct net_device *dev = pp->dev;
-	int rx_todo, rx_proc;
-	int refill = 0;
-	u32 rcvd_pkts = 0;
-	u32 rcvd_bytes = 0;
+	int rcvd_pkts = 0, rcvd_bytes = 0;
+	int rx_pending, refill, done = 0;
 
 	/* Get number of received packets */
-	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
-	rx_proc = 0;
+	rx_pending = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
 	/* Fairness NAPI loop */
-	while ((rcvd_pkts < budget) && (rx_proc < rx_todo)) {
+	while (done < budget && done < rx_pending) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
 		unsigned char *data;
 		struct page *page;
-		dma_addr_t phys_addr;
-		u32 rx_status, index;
-		int rx_bytes, skb_size, copy_size;
-		int frag_num, frag_size, frag_offset;
+		int index;
 
 		index = rx_desc - rxq->descs;
 		page = (struct page *)rxq->buf_virt_addr[index];
@@ -1973,98 +2048,33 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		/* Prefetch header */
 		prefetch(data);
 
-		phys_addr = rx_desc->buf_phys_addr;
-		rx_status = rx_desc->status;
-		rx_proc++;
 		rxq->refill_num++;
+		done++;
+
+		if (rx_desc->status & MVNETA_RXD_FIRST_DESC) {
+			int err;
 
-		if (rx_status & MVNETA_RXD_FIRST_DESC) {
 			/* Check errors only for FIRST descriptor */
-			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
+			if (rx_desc->status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
-				dev->stats.rx_errors++;
+				pp->dev->stats.rx_errors++;
 				/* leave the descriptor untouched */
 				continue;
 			}
-			rx_bytes = rx_desc->data_size -
-				   (ETH_FCS_LEN + MVNETA_MH_SIZE);
 
-			/* Allocate small skb for each new packet */
-			skb_size = max(rx_copybreak, rx_header_size);
-			rxq->skb = netdev_alloc_skb_ip_align(dev, skb_size);
-			if (unlikely(!rxq->skb)) {
-				netdev_err(dev,
-					   "Can't allocate skb on queue %d\n",
-					   rxq->id);
-				dev->stats.rx_dropped++;
-				rxq->skb_alloc_err++;
+			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
+			if (err)
 				continue;
-			}
-			copy_size = min(skb_size, rx_bytes);
-
-			/* Copy data from buffer to SKB, skip Marvell header */
-			memcpy(rxq->skb->data, data + MVNETA_MH_SIZE,
-			       copy_size);
-			skb_put(rxq->skb, copy_size);
-			rxq->left_size = rx_bytes - copy_size;
-
-			mvneta_rx_csum(pp, rx_status, rxq->skb);
-			if (rxq->left_size == 0) {
-				int size = copy_size + MVNETA_MH_SIZE;
-
-				dma_sync_single_range_for_cpu(dev->dev.parent,
-							      phys_addr, 0,
-							      size,
-							      DMA_FROM_DEVICE);
-
-				/* leave the descriptor and buffer untouched */
-			} else {
-				/* refill descriptor with new buffer later */
-				rx_desc->buf_phys_addr = 0;
-
-				frag_num = 0;
-				frag_offset = copy_size + MVNETA_MH_SIZE;
-				frag_size = min(rxq->left_size,
-						(int)(PAGE_SIZE - frag_offset));
-				skb_add_rx_frag(rxq->skb, frag_num, page,
-						frag_offset, frag_size,
-						PAGE_SIZE);
-				page_pool_release_page(rxq->page_pool, page);
-				rxq->left_size -= frag_size;
-			}
 		} else {
-			/* Middle or Last descriptor */
 			if (unlikely(!rxq->skb)) {
 				pr_debug("no skb for rx_status 0x%x\n",
-					 rx_status);
+					 rx_desc->status);
 				continue;
 			}
-			if (!rxq->left_size) {
-				/* last descriptor has only FCS */
-				/* and can be discarded */
-				dma_sync_single_range_for_cpu(dev->dev.parent,
-							      phys_addr, 0,
-							      ETH_FCS_LEN,
-							      DMA_FROM_DEVICE);
-				/* leave the descriptor and buffer untouched */
-			} else {
-				/* refill descriptor with new buffer later */
-				rx_desc->buf_phys_addr = 0;
-
-				frag_num = skb_shinfo(rxq->skb)->nr_frags;
-				frag_offset = 0;
-				frag_size = min(rxq->left_size,
-						(int)(PAGE_SIZE - frag_offset));
-				skb_add_rx_frag(rxq->skb, frag_num, page,
-						frag_offset, frag_size,
-						PAGE_SIZE);
-
-				page_pool_release_page(rxq->page_pool, page);
-				rxq->left_size -= frag_size;
-			}
+			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, page);
 		} /* Middle or Last descriptor */
 
-		if (!(rx_status & MVNETA_RXD_LAST_DESC))
+		if (!(rx_desc->status & MVNETA_RXD_LAST_DESC))
 			/* no last descriptor this time */
 			continue;
 
@@ -2080,13 +2090,12 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		rcvd_bytes += rxq->skb->len;
 
 		/* Linux processing */
-		rxq->skb->protocol = eth_type_trans(rxq->skb, dev);
+		rxq->skb->protocol = eth_type_trans(rxq->skb, pp->dev);
 
 		napi_gro_receive(napi, rxq->skb);
 
 		/* clean uncomplete skb pointer in queue */
 		rxq->skb = NULL;
-		rxq->left_size = 0;
 	}
 
 	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
@@ -2095,7 +2104,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	refill = mvneta_rx_refill_queue(pp, rxq);
 
 	/* Update rxq management counters */
-	mvneta_rxq_desc_num_update(pp, rxq, rx_proc, refill);
+	mvneta_rxq_desc_num_update(pp, rxq, done, refill);
 
 	return rcvd_pkts;
 }
@@ -2946,7 +2955,7 @@ static void mvneta_rxq_hw_init(struct mvneta_port *pp,
 		/* Set Offset */
 		mvneta_rxq_offset_set(pp, rxq, 0);
 		mvneta_rxq_buf_size_set(pp, rxq, PAGE_SIZE < SZ_64K ?
-					PAGE_SIZE :
+					MVNETA_MAX_RX_BUF_SIZE :
 					MVNETA_RX_BUF_SIZE(pp->pkt_size));
 		mvneta_rxq_bm_disable(pp, rxq);
 		mvneta_rxq_fill(pp, rxq, rxq->size);
@@ -4656,7 +4665,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	pp->id = global_port_id++;
-	pp->rx_offset_correction = 0; /* not relevant for SW BM */
+	pp->rx_offset_correction = NET_SKB_PAD;
 
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
-- 
2.21.0

