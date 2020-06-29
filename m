Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90AA20D376
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgF2S7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:59:05 -0400
Received: from inva020.nxp.com ([92.121.34.13]:45094 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbgF2S7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:59:03 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D2B341A125C;
        Mon, 29 Jun 2020 12:40:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BBE441A124F;
        Mon, 29 Jun 2020 12:40:04 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8E7B7205D4;
        Mon, 29 Jun 2020 12:40:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] dpaa2-eth: send a scatter-gather FD instead of realloc-ing
Date:   Mon, 29 Jun 2020 13:39:53 +0300
Message-Id: <20200629103954.18021-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629103954.18021-1-ioana.ciornei@nxp.com>
References: <20200629103954.18021-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of realloc-ing the skb on the Tx path when the provided headroom
is smaller than the HW requirements, create a Scatter/Gather frame
descriptor with only one entry.

Remove the '[drv] tx realloc frames' counter exposed previously through
ethtool since it is no longer used.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |   7 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 177 +++++++++++++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   9 +-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |   1 -
 4 files changed, 160 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 2880ca02d7e7..5cb357c74dec 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -19,14 +19,14 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Per-CPU stats for %s\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n",
+	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s\n",
 		   "CPU", "Rx", "Rx Err", "Rx SG", "Tx", "Tx Err", "Tx conf",
-		   "Tx SG", "Tx realloc", "Enq busy");
+		   "Tx SG", "Enq busy");
 
 	for_each_online_cpu(i) {
 		stats = per_cpu_ptr(priv->percpu_stats, i);
 		extras = per_cpu_ptr(priv->percpu_extras, i);
-		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu\n",
+		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu\n",
 			   i,
 			   stats->rx_packets,
 			   stats->rx_errors,
@@ -35,7 +35,6 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 			   stats->tx_errors,
 			   extras->tx_conf_frames,
 			   extras->tx_sg_frames,
-			   extras->tx_reallocs,
 			   extras->tx_portal_busy);
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 712bbfdbe7d7..4a264b75c035 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -685,6 +685,86 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv,
 	return err;
 }
 
+/* Create a SG frame descriptor based on a linear skb.
+ *
+ * This function is used on the Tx path when the skb headroom is not large
+ * enough for the HW requirements, thus instead of realloc-ing the skb we
+ * create a SG frame descriptor with only one entry.
+ */
+static int build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
+				  struct sk_buff *skb,
+				  struct dpaa2_fd *fd)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpaa2_eth_sgt_cache *sgt_cache;
+	struct dpaa2_sg_entry *sgt;
+	struct dpaa2_eth_swa *swa;
+	dma_addr_t addr, sgt_addr;
+	void *sgt_buf = NULL;
+	int sgt_buf_size;
+	int err;
+
+	/* Prepare the HW SGT structure */
+	sgt_cache = this_cpu_ptr(priv->sgt_cache);
+	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
+
+	if (sgt_cache->count == 0)
+		sgt_buf = kzalloc(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN,
+				  GFP_ATOMIC);
+	else
+		sgt_buf = sgt_cache->buf[--sgt_cache->count];
+	if (unlikely(!sgt_buf))
+		return -ENOMEM;
+
+	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
+	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
+
+	addr = dma_map_single(dev, skb->data, skb->len, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, addr))) {
+		err = -ENOMEM;
+		goto data_map_failed;
+	}
+
+	/* Fill in the HW SGT structure */
+	dpaa2_sg_set_addr(sgt, addr);
+	dpaa2_sg_set_len(sgt, skb->len);
+	dpaa2_sg_set_final(sgt, true);
+
+	/* Store the skb backpointer in the SGT buffer */
+	swa = (struct dpaa2_eth_swa *)sgt_buf;
+	swa->type = DPAA2_ETH_SWA_SINGLE;
+	swa->single.skb = skb;
+	swa->sg.sgt_size = sgt_buf_size;
+
+	/* Separately map the SGT buffer */
+	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, sgt_addr))) {
+		err = -ENOMEM;
+		goto sgt_map_failed;
+	}
+
+	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
+	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
+	dpaa2_fd_set_addr(fd, sgt_addr);
+	dpaa2_fd_set_len(fd, skb->len);
+	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
+
+	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+		enable_tx_tstamp(fd, sgt_buf);
+
+	return 0;
+
+sgt_map_failed:
+	dma_unmap_single(dev, addr, skb->len, DMA_BIDIRECTIONAL);
+data_map_failed:
+	if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
+		kfree(sgt_buf);
+	else
+		sgt_cache->buf[sgt_cache->count++] = sgt_buf;
+
+	return err;
+}
+
 /* Create a frame descriptor based on a linear skb */
 static int build_single_fd(struct dpaa2_eth_priv *priv,
 			   struct sk_buff *skb,
@@ -743,13 +823,16 @@ static void free_tx_fd(const struct dpaa2_eth_priv *priv,
 		       const struct dpaa2_fd *fd, bool in_napi)
 {
 	struct device *dev = priv->net_dev->dev.parent;
-	dma_addr_t fd_addr;
+	dma_addr_t fd_addr, sg_addr;
 	struct sk_buff *skb = NULL;
 	unsigned char *buffer_start;
 	struct dpaa2_eth_swa *swa;
 	u8 fd_format = dpaa2_fd_get_format(fd);
 	u32 fd_len = dpaa2_fd_get_len(fd);
 
+	struct dpaa2_eth_sgt_cache *sgt_cache;
+	struct dpaa2_sg_entry *sgt;
+
 	fd_addr = dpaa2_fd_get_addr(fd);
 	buffer_start = dpaa2_iova_to_virt(priv->iommu_domain, fd_addr);
 	swa = (struct dpaa2_eth_swa *)buffer_start;
@@ -769,16 +852,29 @@ static void free_tx_fd(const struct dpaa2_eth_priv *priv,
 					 DMA_BIDIRECTIONAL);
 		}
 	} else if (fd_format == dpaa2_fd_sg) {
-		skb = swa->sg.skb;
+		if (swa->type == DPAA2_ETH_SWA_SG) {
+			skb = swa->sg.skb;
+
+			/* Unmap the scatterlist */
+			dma_unmap_sg(dev, swa->sg.scl, swa->sg.num_sg,
+				     DMA_BIDIRECTIONAL);
+			kfree(swa->sg.scl);
 
-		/* Unmap the scatterlist */
-		dma_unmap_sg(dev, swa->sg.scl, swa->sg.num_sg,
-			     DMA_BIDIRECTIONAL);
-		kfree(swa->sg.scl);
+			/* Unmap the SGT buffer */
+			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
+					 DMA_BIDIRECTIONAL);
+		} else {
+			skb = swa->single.skb;
 
-		/* Unmap the SGT buffer */
-		dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
-				 DMA_BIDIRECTIONAL);
+			/* Unmap the SGT Buffer */
+			dma_unmap_single(dev, fd_addr, swa->single.sgt_size,
+					 DMA_BIDIRECTIONAL);
+
+			sgt = (struct dpaa2_sg_entry *)(buffer_start +
+							priv->tx_data_offset);
+			sg_addr = dpaa2_sg_get_addr(sgt);
+			dma_unmap_single(dev, sg_addr, skb->len, DMA_BIDIRECTIONAL);
+		}
 	} else {
 		netdev_dbg(priv->net_dev, "Invalid FD format\n");
 		return;
@@ -808,8 +904,17 @@ static void free_tx_fd(const struct dpaa2_eth_priv *priv,
 	}
 
 	/* Free SGT buffer allocated on tx */
-	if (fd_format != dpaa2_fd_single)
-		skb_free_frag(buffer_start);
+	if (fd_format != dpaa2_fd_single) {
+		sgt_cache = this_cpu_ptr(priv->sgt_cache);
+		if (swa->type == DPAA2_ETH_SWA_SG) {
+			skb_free_frag(buffer_start);
+		} else {
+			if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
+				kfree(buffer_start);
+			else
+				sgt_cache->buf[sgt_cache->count++] = buffer_start;
+		}
+	}
 
 	/* Move on with skb release */
 	napi_consume_skb(skb, in_napi);
@@ -833,22 +938,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
 	needed_headroom = dpaa2_eth_needed_headroom(priv, skb);
-	if (skb_headroom(skb) < needed_headroom) {
-		struct sk_buff *ns;
-
-		ns = skb_realloc_headroom(skb, needed_headroom);
-		if (unlikely(!ns)) {
-			percpu_stats->tx_dropped++;
-			goto err_alloc_headroom;
-		}
-		percpu_extras->tx_reallocs++;
-
-		if (skb->sk)
-			skb_set_owner_w(ns, skb->sk);
-
-		dev_kfree_skb(skb);
-		skb = ns;
-	}
 
 	/* We'll be holding a back-reference to the skb until Tx Confirmation;
 	 * we don't want that overwritten by a concurrent Tx with a cloned skb.
@@ -867,6 +956,10 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 		err = build_sg_fd(priv, skb, &fd);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
+	} else if (skb_headroom(skb) < needed_headroom) {
+		err = build_sg_fd_single_buf(priv, skb, &fd);
+		percpu_extras->tx_sg_frames++;
+		percpu_extras->tx_sg_bytes += skb->len;
 	} else {
 		err = build_single_fd(priv, skb, &fd);
 	}
@@ -924,7 +1017,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	return NETDEV_TX_OK;
 
 err_build_fd:
-err_alloc_headroom:
 	dev_kfree_skb(skb);
 
 	return NETDEV_TX_OK;
@@ -1161,6 +1253,22 @@ static int refill_pool(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
+static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
+{
+	struct dpaa2_eth_sgt_cache *sgt_cache;
+	u16 count;
+	int k, i;
+
+	for_each_online_cpu(k) {
+		sgt_cache = per_cpu_ptr(priv->sgt_cache, k);
+		count = sgt_cache->count;
+
+		for (i = 0; i < count; i++)
+			kfree(sgt_cache->buf[i]);
+		sgt_cache->count = 0;
+	}
+}
+
 static int pull_channel(struct dpaa2_eth_channel *ch)
 {
 	int err;
@@ -1562,6 +1670,9 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	/* Empty the buffer pool */
 	drain_pool(priv);
 
+	/* Empty the Scatter-Gather Buffer cache */
+	dpaa2_eth_sgt_cache_drain(priv);
+
 	return 0;
 }
 
@@ -3846,6 +3957,13 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_alloc_percpu_extras;
 	}
 
+	priv->sgt_cache = alloc_percpu(*priv->sgt_cache);
+	if (!priv->sgt_cache) {
+		dev_err(dev, "alloc_percpu(sgt_cache) failed\n");
+		err = -ENOMEM;
+		goto err_alloc_sgt_cache;
+	}
+
 	err = netdev_init(net_dev);
 	if (err)
 		goto err_netdev_init;
@@ -3914,6 +4032,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_rings:
 err_csum:
 err_netdev_init:
+	free_percpu(priv->sgt_cache);
+err_alloc_sgt_cache:
 	free_percpu(priv->percpu_extras);
 err_alloc_percpu_extras:
 	free_percpu(priv->percpu_stats);
@@ -3959,6 +4079,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 		fsl_mc_free_irqs(ls_dev);
 
 	free_rings(priv);
+	free_percpu(priv->sgt_cache);
 	free_percpu(priv->percpu_stats);
 	free_percpu(priv->percpu_extras);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 2d7ada0f0dbd..9e4ceb92f240 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -125,6 +125,7 @@ struct dpaa2_eth_swa {
 	union {
 		struct {
 			struct sk_buff *skb;
+			int sgt_size;
 		} single;
 		struct {
 			struct sk_buff *skb;
@@ -282,7 +283,6 @@ struct dpaa2_eth_drv_stats {
 	__u64	tx_conf_bytes;
 	__u64	tx_sg_frames;
 	__u64	tx_sg_bytes;
-	__u64	tx_reallocs;
 	__u64	rx_sg_frames;
 	__u64	rx_sg_bytes;
 	/* Enqueues retried due to portal busy */
@@ -395,6 +395,12 @@ struct dpaa2_eth_cls_rule {
 	u8 in_use;
 };
 
+#define DPAA2_ETH_SGT_CACHE_SIZE	256
+struct dpaa2_eth_sgt_cache {
+	void *buf[DPAA2_ETH_SGT_CACHE_SIZE];
+	u16 count;
+};
+
 /* Driver private data */
 struct dpaa2_eth_priv {
 	struct net_device *net_dev;
@@ -409,6 +415,7 @@ struct dpaa2_eth_priv {
 
 	u8 num_channels;
 	struct dpaa2_eth_channel *channel[DPAA2_ETH_MAX_DPCONS];
+	struct dpaa2_eth_sgt_cache __percpu *sgt_cache;
 
 	struct dpni_attr dpni_attrs;
 	u16 dpni_ver_major;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index e88269fe3de7..c4cbbcaa9a3f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -43,7 +43,6 @@ static char dpaa2_ethtool_extras[][ETH_GSTRING_LEN] = {
 	"[drv] tx conf bytes",
 	"[drv] tx sg frames",
 	"[drv] tx sg bytes",
-	"[drv] tx realloc frames",
 	"[drv] rx sg frames",
 	"[drv] rx sg bytes",
 	"[drv] enqueue portal busy",
-- 
2.25.1

