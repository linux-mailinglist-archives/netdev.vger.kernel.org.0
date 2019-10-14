Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247BAD6095
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbfJNKux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731449AbfJNKuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:52 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9D820854;
        Mon, 14 Oct 2019 10:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050251;
        bh=V6KWXXKDskkxQKW1/7ZFU4FhCKDXpmooQrLUTywaD2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOy7GgHkeV6LXMoYVAYOuKF1sxX92ZglRybxC4iesSxvsyhZuPAwiS5bYn+91pnl6
         Oo4bLtXFq0nC+Z/oHwqNaqHmJZj1sBpjcGNszR6TnN39xFTQESRcR+ycGnWsgepK5/
         OwgZxeNQ0pkrdVR+tWMiykUZBV/Gje/qposE31so=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Date:   Mon, 14 Oct 2019 12:49:55 +0200
Message-Id: <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
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
index 477ae6592fa3..ff663877e237 100644
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
@@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
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
 mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp)
@@ -1994,6 +2100,11 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
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
@@ -4527,6 +4638,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_get_stats64     = mvneta_get_stats64,
 	.ndo_do_ioctl        = mvneta_ioctl,
 	.ndo_bpf	     = mvneta_xdp,
+	.ndo_xdp_xmit        = mvneta_xdp_xmit,
 };
 
 static const struct ethtool_ops mvneta_eth_tool_ops = {
-- 
2.21.0

