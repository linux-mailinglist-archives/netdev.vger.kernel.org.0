Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE85CCCBF
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfJEUpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 16:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfJEUpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 16:45:49 -0400
Received: from lore-desk.lan (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E01222C8;
        Sat,  5 Oct 2019 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570308348;
        bh=U80piS/r2IkLywPQweSRDVUxqMtLKTnIYWaV4i0i7yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvWzXqeFn+FRpQXw1iz7X+z9wd1Xtt+YEdMDLGg9PikJ6S7PNiwneX+yZagKLba0f
         74hKsT6Vlg16GFJ1kcVabQlZ0b34w6jbTc1zmkyYvCn2ffI4LLKPA6gKU05OxX8mV9
         SKk7uLMzDA4a5l9o54AXVe51akNvAQ+X4AH0eOCw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: [PATCH 7/7] net: mvneta: add XDP_TX support
Date:   Sat,  5 Oct 2019 22:44:40 +0200
Message-Id: <80d510375ba04f3cd1755ab2f470dbf6cd84e13b.1570307172.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1570307172.git.lorenzo@kernel.org>
References: <cover.1570307172.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
pointer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 126 ++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 28b35e55aa35..9ec97086f991 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1800,16 +1800,19 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 
 		mvneta_txq_inc_get(txq);
 
-		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
+		if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr) &&
+		    buf->type != MVNETA_TYPE_XDP_TX)
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
-		if (!buf->skb)
-			continue;
-
-		bytes_compl += buf->skb->len;
-		pkts_compl++;
-		dev_kfree_skb_any(buf->skb);
+		if (buf->type == MVNETA_TYPE_SKB && buf->skb) {
+			bytes_compl += buf->skb->len;
+			pkts_compl++;
+			dev_kfree_skb_any(buf->skb);
+		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
+			   buf->type == MVNETA_TYPE_XDP_NDO) {
+			xdp_return_frame(buf->xdpf);
+		}
 	}
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
@@ -1967,6 +1970,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 	return i;
 }
 
+static int
+mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
+			struct xdp_frame *xdpf, bool dma_map)
+{
+	struct mvneta_tx_desc *tx_desc;
+	struct mvneta_tx_buf *buf;
+	dma_addr_t dma_addr;
+
+	if (txq->count >= txq->tx_stop_threshold)
+		return MVNETA_XDP_CONSUMED;
+
+	tx_desc = mvneta_txq_next_desc_get(txq);
+
+	buf = &txq->buf[txq->txq_put_index];
+	if (dma_map) {
+		/* ndo_xdp_xmit */
+		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
+					  xdpf->len, DMA_TO_DEVICE);
+		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
+			mvneta_txq_desc_put(txq);
+			return MVNETA_XDP_CONSUMED;
+		}
+		buf->type = MVNETA_TYPE_XDP_NDO;
+	} else {
+		struct page *page = virt_to_page(xdpf->data);
+
+		dma_addr = page_pool_get_dma_addr(page) +
+			   pp->rx_offset_correction + MVNETA_MH_SIZE;
+		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
+					   xdpf->len, DMA_BIDIRECTIONAL);
+		buf->type = MVNETA_TYPE_XDP_TX;
+	}
+	buf->xdpf = xdpf;
+
+	tx_desc->command = MVNETA_TXD_FLZ_DESC;
+	tx_desc->buf_phys_addr = dma_addr;
+	tx_desc->data_size = xdpf->len;
+
+	mvneta_update_stats(pp, 1, xdpf->len, true);
+	mvneta_txq_inc_put(txq);
+	txq->pending++;
+	txq->count++;
+
+	return MVNETA_XDP_TX;
+}
+
+static int
+mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+	int cpu = smp_processor_id();
+	struct mvneta_tx_queue *txq;
+	struct netdev_queue *nq;
+	u32 ret;
+
+	if (unlikely(!xdpf))
+		return MVNETA_XDP_CONSUMED;
+
+	txq = &pp->txqs[cpu % txq_number];
+	nq = netdev_get_tx_queue(pp->dev, txq->id);
+
+	__netif_tx_lock(nq, cpu);
+	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
+	if (ret == MVNETA_XDP_TX)
+		mvneta_txq_pend_desc_add(pp, txq, 0);
+	__netif_tx_unlock(nq);
+
+	return ret;
+}
+
+static int
+mvneta_xdp_xmit(struct net_device *dev, int num_frame,
+		struct xdp_frame **frames, u32 flags)
+{
+	struct mvneta_port *pp = netdev_priv(dev);
+	int cpu = smp_processor_id();
+	struct mvneta_tx_queue *txq;
+	struct netdev_queue *nq;
+	int i, drops = 0;
+	u32 ret;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	txq = &pp->txqs[cpu % txq_number];
+	nq = netdev_get_tx_queue(pp->dev, txq->id);
+
+	__netif_tx_lock(nq, cpu);
+	for (i = 0; i < num_frame; i++) {
+		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
+		if (ret != MVNETA_XDP_TX) {
+			xdp_return_frame_rx_napi(frames[i]);
+			drops++;
+		}
+	}
+
+	if (unlikely(flags & XDP_XMIT_FLUSH))
+		mvneta_txq_pend_desc_add(pp, txq, 0);
+	__netif_tx_unlock(nq);
+
+	return num_frame - drops;
+}
+
 static int
 mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
 	       struct xdp_buff *xdp)
@@ -1989,6 +2095,11 @@ mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
 		}
 		break;
 	}
+	case XDP_TX:
+		ret = mvneta_xdp_xmit_back(pp, xdp);
+		if (ret != MVNETA_XDP_TX)
+			xdp_return_buff(xdp);
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		/* fall through */
@@ -4523,6 +4634,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_get_stats64     = mvneta_get_stats64,
 	.ndo_do_ioctl        = mvneta_ioctl,
 	.ndo_bpf	     = mvneta_xdp,
+	.ndo_xdp_xmit        = mvneta_xdp_xmit,
 };
 
 static const struct ethtool_ops mvneta_eth_tool_ops = {
-- 
2.21.0

