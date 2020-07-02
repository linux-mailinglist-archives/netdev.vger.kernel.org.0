Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0182125E8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgGBOPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:15:08 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37779 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgGBOPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:15:07 -0400
Received: by mail-ed1-f67.google.com with SMTP id g20so23868319edm.4;
        Thu, 02 Jul 2020 07:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZ5bfRXqxL3ylBVnjbJiEghl+4XoO/oYizBWKcVs5ec=;
        b=NED8YGI54GARI9Mhk0onshCThItCe7g5FNd/l9lhsDyjbdFA3g4HQCVk9PFsHklHl2
         v43tEcV102q/yTlzaxC80y+HQTei39icFDuut6MBRxIizzz431y/tnZbNnUhm6dIACCq
         sIU2ApMrlPcul4IQA1gEIwgcueTAOX4r9mlvgJbY+98Tgmc5s/AlAmgyFi0vSPJVbRdX
         3gpazwtH+TBCO/dkVrQkJAez0A1JBKJNbx8F/tWRQQrKWKakpmOJ2bMRVeVSSmdWl2br
         Y4SFknuTm/ZIxc+v92i6svtAYQJ/Q7cZ/LiZWK/kB2r6K3Ip+ZwRXqj5muN5TE36oV8Q
         9czA==
X-Gm-Message-State: AOAM533+wshMLAYsspxSpZVk75DFRv3SCPo9+b4pSc4p1k8C8hSFdkQk
        V0a6oA3hbvnvZCBjqEqlUsACd8iqWr7dlw==
X-Google-Smtp-Source: ABdhPJx6wcZSn+GeGdvme9FxlI8WWcM1e3wAaBXpUzajayA9PhN8HlZi7faKzCEdSy2+EHFhieQNLg==
X-Received: by 2002:a50:fc97:: with SMTP id f23mr26021986edq.255.1593699304361;
        Thu, 02 Jul 2020 07:15:04 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id fi29sm6841274ejb.83.2020.07.02.07.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 07:15:03 -0700 (PDT)
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
Subject: [PATCH net-next v2 4/5] mvpp2: XDP TX support
Date:   Thu,  2 Jul 2020 16:12:43 +0200
Message-Id: <20200702141244.51295-5-mcroce@linux.microsoft.com>
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

Add the transmit part of XDP support, which includes:
- support for XDP_TX in mvpp2_xdp()
- .ndo_xdp_xmit hook for AF_XDP and XDP_REDIRECT with mvpp2 as destination

mvpp2_xdp_submit_frame() is a generic function which is called by
mvpp2_xdp_xmit_back() when doing XDP_TX, and by mvpp2_xdp_xmit when
doing AF_XDP or XDP_REDIRECT target.

The buffer allocation has been reworked to be able to map the buffers
as DMA_FROM_DEVICE or DMA_BIDIRECTIONAL depending if native XDP is
in use or not.

Co-developed-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  13 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 304 +++++++++++++++---
 2 files changed, 272 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index f351e41c9da6..c52955b33fab 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1082,9 +1082,20 @@ struct mvpp2_rx_desc {
 	};
 };
 
+enum mvpp2_tx_buf_type {
+	MVPP2_TYPE_SKB,
+	MVPP2_TYPE_XDP_TX,
+	MVPP2_TYPE_XDP_NDO,
+};
+
 struct mvpp2_txq_pcpu_buf {
+	enum mvpp2_tx_buf_type type;
+
 	/* Transmitted SKB */
-	struct sk_buff *skb;
+	union {
+		struct xdp_frame *xdpf;
+		struct sk_buff *skb;
+	};
 
 	/* Physical address of transmitted buffer */
 	dma_addr_t dma;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5f740c96a02c..d49a814311be 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -97,7 +97,8 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 }
 
 static struct page_pool *
-mvpp2_create_page_pool(struct device *dev, int num, int len)
+mvpp2_create_page_pool(struct device *dev, int num, int len,
+		       enum dma_data_direction dma_dir)
 {
 	struct page_pool_params pp_params = {
 		/* internal DMA mapping in page_pool */
@@ -105,7 +106,7 @@ mvpp2_create_page_pool(struct device *dev, int num, int len)
 		.pool_size = num,
 		.nid = NUMA_NO_NODE,
 		.dev = dev,
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = dma_dir,
 		.offset = MVPP2_SKB_HEADROOM,
 		.max_len = len,
 	};
@@ -299,12 +300,17 @@ static void mvpp2_txq_inc_get(struct mvpp2_txq_pcpu *txq_pcpu)
 
 static void mvpp2_txq_inc_put(struct mvpp2_port *port,
 			      struct mvpp2_txq_pcpu *txq_pcpu,
-			      struct sk_buff *skb,
-			      struct mvpp2_tx_desc *tx_desc)
+			      void *data,
+			      struct mvpp2_tx_desc *tx_desc,
+			      enum mvpp2_tx_buf_type buf_type)
 {
 	struct mvpp2_txq_pcpu_buf *tx_buf =
 		txq_pcpu->buffs + txq_pcpu->txq_put_index;
-	tx_buf->skb = skb;
+	tx_buf->type = buf_type;
+	if (buf_type == MVPP2_TYPE_SKB)
+		tx_buf->skb = data;
+	else
+		tx_buf->xdpf = data;
 	tx_buf->size = mvpp2_txdesc_size_get(port, tx_desc);
 	tx_buf->dma = mvpp2_txdesc_dma_addr_get(port, tx_desc) +
 		mvpp2_txdesc_offset_get(port, tx_desc);
@@ -527,9 +533,6 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 	int buf_num;
 	u32 val;
 
-	if (priv->percpu_pools)
-		page_pool_destroy(priv->page_pool[bm_pool->id]);
-
 	buf_num = mvpp2_check_hw_buf_num(priv, bm_pool);
 	mvpp2_bm_bufs_free(dev, priv, bm_pool, buf_num);
 
@@ -545,6 +548,9 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 	val |= MVPP2_BM_STOP_MASK;
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
+	if (priv->percpu_pools)
+		page_pool_destroy(priv->page_pool[bm_pool->id]);
+
 	dma_free_coherent(dev, bm_pool->size_bytes,
 			  bm_pool->virt_addr,
 			  bm_pool->dma_addr);
@@ -580,9 +586,19 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 
 static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
+	enum dma_data_direction dma_dir = DMA_FROM_DEVICE;
 	int i, err, poolnum = MVPP2_BM_POOLS_NUM;
+	struct mvpp2_port *port;
 
 	if (priv->percpu_pools) {
+		for (i = 0; i < priv->port_count; i++) {
+			port = priv->port_list[i];
+			if (port->xdp_prog) {
+				dma_dir = DMA_BIDIRECTIONAL;
+				break;
+			}
+		}
+
 		poolnum = mvpp2_get_nrxqs(priv) * 2;
 		for (i = 0; i < poolnum; i++) {
 			/* the pool in use */
@@ -591,7 +607,8 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 			priv->page_pool[i] =
 				mvpp2_create_page_pool(dev,
 						       mvpp2_pools[pn].buf_num,
-						       mvpp2_pools[pn].pkt_size);
+						       mvpp2_pools[pn].pkt_size,
+						       dma_dir);
 			if (IS_ERR(priv->page_pool[i]))
 				return PTR_ERR(priv->page_pool[i]);
 		}
@@ -2318,11 +2335,15 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
 		struct mvpp2_txq_pcpu_buf *tx_buf =
 			txq_pcpu->buffs + txq_pcpu->txq_get_index;
 
-		if (!IS_TSO_HEADER(txq_pcpu, tx_buf->dma))
+		if (!IS_TSO_HEADER(txq_pcpu, tx_buf->dma) &&
+		    tx_buf->type != MVPP2_TYPE_XDP_TX)
 			dma_unmap_single(port->dev->dev.parent, tx_buf->dma,
 					 tx_buf->size, DMA_TO_DEVICE);
-		if (tx_buf->skb)
+		if (tx_buf->type == MVPP2_TYPE_SKB && tx_buf->skb)
 			dev_kfree_skb_any(tx_buf->skb);
+		else if (tx_buf->type == MVPP2_TYPE_XDP_TX ||
+			 tx_buf->type == MVPP2_TYPE_XDP_NDO)
+			xdp_return_frame(tx_buf->xdpf);
 
 		mvpp2_txq_inc_get(txq_pcpu);
 	}
@@ -2810,7 +2831,7 @@ static int mvpp2_setup_rxqs(struct mvpp2_port *port)
 static int mvpp2_setup_txqs(struct mvpp2_port *port)
 {
 	struct mvpp2_tx_queue *txq;
-	int queue, err, cpu;
+	int queue, err;
 
 	for (queue = 0; queue < port->ntxqs; queue++) {
 		txq = port->txqs[queue];
@@ -2819,8 +2840,8 @@ static int mvpp2_setup_txqs(struct mvpp2_port *port)
 			goto err_cleanup;
 
 		/* Assign this queue to a CPU */
-		cpu = queue % num_present_cpus();
-		netif_set_xps_queue(port->dev, cpumask_of(cpu), queue);
+		if (queue < num_possible_cpus())
+			netif_set_xps_queue(port->dev, cpumask_of(queue), queue);
 	}
 
 	if (port->has_tx_irqs) {
@@ -3039,6 +3060,164 @@ static u32 mvpp2_skb_tx_csum(struct mvpp2_port *port, struct sk_buff *skb)
 	return MVPP2_TXD_L4_CSUM_NOT | MVPP2_TXD_IP_CSUM_DISABLE;
 }
 
+static void mvpp2_xdp_finish_tx(struct mvpp2_port *port, u16 txq_id, int nxmit, int nxmit_byte)
+{
+	unsigned int thread = mvpp2_cpu_to_thread(port->priv, smp_processor_id());
+	struct mvpp2_pcpu_stats *stats = per_cpu_ptr(port->stats, thread);
+	struct mvpp2_tx_queue *aggr_txq;
+	struct mvpp2_txq_pcpu *txq_pcpu;
+	struct mvpp2_tx_queue *txq;
+	struct netdev_queue *nq;
+
+	txq = port->txqs[txq_id];
+	txq_pcpu = per_cpu_ptr(txq->pcpu, thread);
+	nq = netdev_get_tx_queue(port->dev, txq_id);
+	aggr_txq = &port->priv->aggr_txqs[thread];
+
+	txq_pcpu->reserved_num -= nxmit;
+	txq_pcpu->count += nxmit;
+	aggr_txq->count += nxmit;
+
+	/* Enable transmit */
+	wmb();
+	mvpp2_aggr_txq_pend_desc_add(port, nxmit);
+
+	if (txq_pcpu->count >= txq_pcpu->stop_threshold)
+		netif_tx_stop_queue(nq);
+
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += nxmit_byte;
+	stats->tx_packets += nxmit;
+	u64_stats_update_end(&stats->syncp);
+
+	/* Finalize TX processing */
+	if (!port->has_tx_irqs && txq_pcpu->count >= txq->done_pkts_coal)
+		mvpp2_txq_done(port, txq, txq_pcpu);
+}
+
+static int
+mvpp2_xdp_submit_frame(struct mvpp2_port *port, u16 txq_id,
+		       struct xdp_frame *xdpf, bool dma_map)
+{
+	unsigned int thread = mvpp2_cpu_to_thread(port->priv, smp_processor_id());
+	u32 tx_cmd = MVPP2_TXD_L4_CSUM_NOT | MVPP2_TXD_IP_CSUM_DISABLE |
+		     MVPP2_TXD_F_DESC | MVPP2_TXD_L_DESC;
+	enum mvpp2_tx_buf_type buf_type;
+	struct mvpp2_txq_pcpu *txq_pcpu;
+	struct mvpp2_tx_queue *aggr_txq;
+	struct mvpp2_tx_desc *tx_desc;
+	struct mvpp2_tx_queue *txq;
+	int ret = MVPP2_XDP_TX;
+	dma_addr_t dma_addr;
+
+	txq = port->txqs[txq_id];
+	txq_pcpu = per_cpu_ptr(txq->pcpu, thread);
+	aggr_txq = &port->priv->aggr_txqs[thread];
+
+	/* Check number of available descriptors */
+	if (mvpp2_aggr_desc_num_check(port, aggr_txq, 1) ||
+	    mvpp2_txq_reserved_desc_num_proc(port, txq, txq_pcpu, 1)) {
+		ret = MVPP2_XDP_DROPPED;
+		goto out;
+	}
+
+	/* Get a descriptor for the first part of the packet */
+	tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
+	mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
+	mvpp2_txdesc_size_set(port, tx_desc, xdpf->len);
+
+	if (dma_map) {
+		/* XDP_REDIRECT or AF_XDP */
+		dma_addr = dma_map_single(port->dev->dev.parent, xdpf->data,
+					  xdpf->len, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(port->dev->dev.parent, dma_addr))) {
+			mvpp2_txq_desc_put(txq);
+			ret = MVPP2_XDP_DROPPED;
+			goto out;
+		}
+
+		buf_type = MVPP2_TYPE_XDP_NDO;
+	} else {
+		/* XDP_TX */
+		struct page *page = virt_to_page(xdpf->data);
+
+		dma_addr = page_pool_get_dma_addr(page) +
+			   sizeof(*xdpf) + xdpf->headroom;
+		dma_sync_single_for_device(port->dev->dev.parent, dma_addr,
+					   xdpf->len, DMA_BIDIRECTIONAL);
+
+		buf_type = MVPP2_TYPE_XDP_TX;
+	}
+
+	mvpp2_txdesc_dma_addr_set(port, tx_desc, dma_addr);
+
+	mvpp2_txdesc_cmd_set(port, tx_desc, tx_cmd);
+	mvpp2_txq_inc_put(port, txq_pcpu, xdpf, tx_desc, buf_type);
+
+out:
+	return ret;
+}
+
+static int
+mvpp2_xdp_xmit_back(struct mvpp2_port *port, struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf;
+	u16 txq_id;
+	int ret;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return MVPP2_XDP_DROPPED;
+
+	/* The first of the TX queues are used for XPS,
+	 * the second half for XDP_TX
+	 */
+	txq_id = mvpp2_cpu_to_thread(port->priv, smp_processor_id()) + (port->ntxqs / 2);
+
+	ret = mvpp2_xdp_submit_frame(port, txq_id, xdpf, false);
+	if (ret == MVPP2_XDP_TX)
+		mvpp2_xdp_finish_tx(port, txq_id, 1, xdpf->len);
+
+	return ret;
+}
+
+static int
+mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
+	       struct xdp_frame **frames, u32 flags)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	int i, nxmit_byte = 0, nxmit = num_frame;
+	u16 txq_id;
+	u32 ret;
+
+	if (unlikely(test_bit(0, &port->state)))
+		return -ENETDOWN;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	/* The first of the TX queues are used for XPS,
+	 * the second half for XDP_TX
+	 */
+	txq_id = mvpp2_cpu_to_thread(port->priv, smp_processor_id()) + (port->ntxqs / 2);
+
+	for (i = 0; i < num_frame; i++) {
+		ret = mvpp2_xdp_submit_frame(port, txq_id, frames[i], true);
+		if (ret == MVPP2_XDP_TX) {
+			nxmit_byte += frames[i]->len;
+		} else {
+			xdp_return_frame_rx_napi(frames[i]);
+			nxmit--;
+		}
+	}
+
+	if (nxmit > 0)
+		mvpp2_xdp_finish_tx(port, txq_id, nxmit, nxmit_byte);
+
+	return nxmit;
+}
+
 static int
 mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 	      struct bpf_prog *prog, struct xdp_buff *xdp,
@@ -3069,6 +3248,13 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 			ret = MVPP2_XDP_REDIR;
 		}
 		break;
+	case XDP_TX:
+		ret = mvpp2_xdp_xmit_back(port, xdp);
+		if (ret != MVPP2_XDP_TX) {
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(pp, page, sync, true);
+		}
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -3090,6 +3276,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		    int rx_todo, struct mvpp2_rx_queue *rxq)
 {
 	struct net_device *dev = port->dev;
+	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
 	int rx_received;
@@ -3139,13 +3326,19 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		if (rx_status & MVPP2_RXD_ERR_SUMMARY)
 			goto err_drop_frame;
 
+		if (port->priv->percpu_pools) {
+			pp = port->priv->page_pool[pool];
+			dma_dir = page_pool_get_dma_dir(pp);
+		} else {
+			dma_dir = DMA_FROM_DEVICE;
+		}
+
 		dma_sync_single_for_cpu(dev->dev.parent, dma_addr,
 					rx_bytes + MVPP2_MH_SIZE,
-					DMA_FROM_DEVICE);
-		prefetch(data);
+					dma_dir);
 
-		if (port->priv->percpu_pools)
-			pp = port->priv->page_pool[pool];
+		/* Prefetch header */
+		prefetch(data);
 
 		if (bm_pool->frag_size > PAGE_SIZE)
 			frag_size = 0;
@@ -3218,6 +3411,9 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 	rcu_read_unlock();
 
+	if (xdp_ret & MVPP2_XDP_REDIR)
+		xdp_do_flush_map();
+
 	if (rcvd_pkts) {
 		struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 
@@ -3284,11 +3480,11 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 			/* Last descriptor */
 			mvpp2_txdesc_cmd_set(port, tx_desc,
 					     MVPP2_TXD_L_DESC);
-			mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc);
+			mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc, MVPP2_TYPE_SKB);
 		} else {
 			/* Descriptor in the middle: Not First, Not Last */
 			mvpp2_txdesc_cmd_set(port, tx_desc, 0);
-			mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc);
+			mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc, MVPP2_TYPE_SKB);
 		}
 	}
 
@@ -3326,7 +3522,7 @@ static inline void mvpp2_tso_put_hdr(struct sk_buff *skb,
 	mvpp2_txdesc_cmd_set(port, tx_desc, mvpp2_skb_tx_csum(port, skb) |
 					    MVPP2_TXD_F_DESC |
 					    MVPP2_TXD_PADDING_DISABLE);
-	mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc);
+	mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc, MVPP2_TYPE_SKB);
 }
 
 static inline int mvpp2_tso_put_data(struct sk_buff *skb,
@@ -3355,14 +3551,14 @@ static inline int mvpp2_tso_put_data(struct sk_buff *skb,
 	if (!left) {
 		mvpp2_txdesc_cmd_set(port, tx_desc, MVPP2_TXD_L_DESC);
 		if (last) {
-			mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc);
+			mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc, MVPP2_TYPE_SKB);
 			return 0;
 		}
 	} else {
 		mvpp2_txdesc_cmd_set(port, tx_desc, 0);
 	}
 
-	mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc);
+	mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc, MVPP2_TYPE_SKB);
 	return 0;
 }
 
@@ -3475,12 +3671,12 @@ static netdev_tx_t mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
 		/* First and Last descriptor */
 		tx_cmd |= MVPP2_TXD_F_DESC | MVPP2_TXD_L_DESC;
 		mvpp2_txdesc_cmd_set(port, tx_desc, tx_cmd);
-		mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc);
+		mvpp2_txq_inc_put(port, txq_pcpu, skb, tx_desc, MVPP2_TYPE_SKB);
 	} else {
 		/* First but not Last */
 		tx_cmd |= MVPP2_TXD_F_DESC | MVPP2_TXD_PADDING_DISABLE;
 		mvpp2_txdesc_cmd_set(port, tx_desc, tx_cmd);
-		mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc);
+		mvpp2_txq_inc_put(port, txq_pcpu, NULL, tx_desc, MVPP2_TYPE_SKB);
 
 		/* Continue with other skb fragments */
 		if (mvpp2_tx_frag_process(port, skb, aggr_txq, txq)) {
@@ -4159,6 +4355,33 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 	return err;
 }
 
+static int mvpp2_check_pagepool_dma(struct mvpp2_port *port)
+{
+	enum dma_data_direction dma_dir = DMA_FROM_DEVICE;
+	struct mvpp2 *priv = port->priv;
+	int err = -1, i;
+
+	if (!priv->percpu_pools)
+		return err;
+
+	if (!priv->page_pool)
+		return -ENOMEM;
+
+	for (i = 0; i < priv->port_count; i++) {
+		port = priv->port_list[i];
+		if (port->xdp_prog) {
+			dma_dir = DMA_BIDIRECTIONAL;
+			break;
+		}
+	}
+
+	/* All pools are equal in terms of DMA direction */
+	if (priv->page_pool[0]->p.dma_dir != dma_dir)
+		err = mvpp2_bm_switch_buffers(priv, true);
+
+	return err;
+}
+
 static void
 mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
@@ -4268,13 +4491,15 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
 		return -EOPNOTSUPP;
 	}
 
-	/* device is up and bpf is added/removed, must setup the RX queues */
-	if (running && reset) {
-		mvpp2_stop_dev(port);
-		mvpp2_cleanup_rxqs(port);
-		mvpp2_cleanup_txqs(port);
+	if (port->ntxqs < num_possible_cpus() * 2) {
+		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP_TX needs two TX queues per CPU");
+		return -EOPNOTSUPP;
 	}
 
+	/* device is up and bpf is added/removed, must setup the RX queues */
+	if (running && reset)
+		mvpp2_stop(port->dev);
+
 	old_prog = xchg(&port->xdp_prog, prog);
 	if (old_prog)
 		bpf_prog_put(old_prog);
@@ -4284,21 +4509,11 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
 		return 0;
 
 	/* device was up, restore the link */
-	if (running) {
-		int ret = mvpp2_setup_rxqs(port);
-
-		if (ret) {
-			netdev_err(port->dev, "mvpp2_setup_rxqs failed\n");
-			return ret;
-		}
-		ret = mvpp2_setup_txqs(port);
-		if (ret) {
-			netdev_err(port->dev, "mvpp2_setup_txqs failed\n");
-			return ret;
-		}
+	if (running)
+		mvpp2_open(port->dev);
 
-		mvpp2_start_dev(port);
-	}
+	/* Check Page Pool DMA Direction */
+	mvpp2_check_pagepool_dma(port);
 
 	return 0;
 }
@@ -4669,6 +4884,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
 	.ndo_set_features	= mvpp2_set_features,
 	.ndo_bpf		= mvpp2_xdp,
+	.ndo_xdp_xmit		= mvpp2_xdp_xmit,
 };
 
 static const struct ethtool_ops mvpp2_eth_tool_ops = {
-- 
2.26.2

