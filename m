Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93E552DA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfFYPGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:06:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51899 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfFYPG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:06:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so3222863wma.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6uE0o1e6m9pAymtEtefJVO5xedkQCUUL6Oh6UkUvWk0=;
        b=lzIAHDY5RNGoyqL67DbinugFPintAAAmLWTYJid4YHYdu/hrSgECEYyfo9pIKuBEDy
         RLOkaTeQqxY4K9ORR9vU36dx9t15jbNNZrTrKzz4r2rgtP7nXIoiLYe6yQk1jOHWzhnB
         lI4diIQ85lz1vprgcoiM9KOPgs1dNBkQKSHBmu2yotfXdhTF5asm4DvHsEGo7DUBj5Uw
         TTMlXTx6BKRib/xcE9zuhHMvh3b8G1hAqwHuvsq2OGXq8F6C2W2FERrhp2NSfj09Y1m5
         YnNMVgSEx2/Mjs3YT6xhx2CrJoGD2m03b3yF6nqPw+yhIQ14lwI38Ec2hsnNClHAjDwR
         e1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6uE0o1e6m9pAymtEtefJVO5xedkQCUUL6Oh6UkUvWk0=;
        b=LhT7nk/MLBEs6pYWutiO5oypnSuz00eUabsCejhtKhi7jV8MOXeA+kOnzpiqCE8So9
         rYD78+1lu1Ba5CLNmGQOukqRuqTJdYs4hXthJ82t6i2nBckyYGDKnh76DDs2/6fEf2R/
         JKBdpzSE2lk6PpnB0Ydxw4D+eQBH7BKGmKriHJKEvyY63ATKC/vynLiF46bDJn5cLrT2
         eOjMBQoJz+lR+GMogbdvuyiMg5Rzqx5AS/nczy4q8XZ0KD1qnhuLBerF3ZaC0i+9TFp1
         nc0YB+dQVpyX3EigTE594Ayhm4YdJisl8Shr13HUX6ifMMjry7FCRBE3g1Za3wCOfya/
         25BA==
X-Gm-Message-State: APjAAAVrhFRiUToz22uZi4dBDrS8GUfACLqPD4YLohqRiEt2J5H5gYti
        gk4vtZUL0WsJPKLVpnRVh3l6QhsYHDI=
X-Google-Smtp-Source: APXvYqzxV1oXeJIz8mqUbTiOD1aBP6kWDw4VOtHJ7pgayrrvYaVKEfZf39DF/7p2qStZPb4u4jSXlw==
X-Received: by 2002:a05:600c:114f:: with SMTP id z15mr19771282wmz.131.1561475187664;
        Tue, 25 Jun 2019 08:06:27 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id r131sm1982108wmf.4.2019.06.25.08.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Jun 2019 08:06:27 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC, PATCH 2/2, net-next] net: netsec: add XDP support
Date:   Tue, 25 Jun 2019 18:06:19 +0300
Message-Id: <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interface only supports 1 Tx queue so locking is introduced on
the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
.ndo_xdp_xmit won't corrupt Tx ring

- Performance (SMMU off)

Benchmark   XDP_SKB     XDP_DRV
xdp1        291kpps     344kpps
rxdrop      282kpps     342kpps

- Performance (SMMU on)
Benchmark   XDP_SKB     XDP_DRV
xdp1        167kpps     324kpps
rxdrop      164kpps     323kpps

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 351 ++++++++++++++++++++++--
 1 file changed, 325 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index e653b24d0534..c7c7e5119b46 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -9,6 +9,9 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/netlink.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #include <net/tcp.h>
 #include <net/page_pool.h>
@@ -236,23 +239,41 @@
 #define DESC_NUM	256
 
 #define NETSEC_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
-#define NETSEC_RX_BUF_NON_DATA (NETSEC_SKB_PAD + \
+#define NETSEC_RXBUF_HEADROOM (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
+			       NET_IP_ALIGN)
+#define NETSEC_RX_BUF_NON_DATA (NETSEC_RXBUF_HEADROOM + \
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 #define DESC_SZ	sizeof(struct netsec_de)
 
 #define NETSEC_F_NETSEC_VER_MAJOR_NUM(x)	((x) & 0xffff0000)
 
+#define NETSEC_XDP_PASS          0
+#define NETSEC_XDP_CONSUMED      BIT(0)
+#define NETSEC_XDP_TX            BIT(1)
+#define NETSEC_XDP_REDIR         BIT(2)
+#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_XDP_REDIR)
+
 enum ring_id {
 	NETSEC_RING_TX = 0,
 	NETSEC_RING_RX
 };
 
+enum buf_type {
+	TYPE_NETSEC_SKB = 0,
+	TYPE_NETSEC_XDP_TX,
+	TYPE_NETSEC_XDP_NDO,
+};
+
 struct netsec_desc {
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 	dma_addr_t dma_addr;
 	void *addr;
 	u16 len;
+	u8 buf_type;
 };
 
 struct netsec_desc_ring {
@@ -260,13 +281,17 @@ struct netsec_desc_ring {
 	struct netsec_desc *desc;
 	void *vaddr;
 	u16 head, tail;
+	u16 xdp_xmit; /* netsec_xdp_xmit packets */
+	bool is_xdp;
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t lock; /* XDP tx queue locking */
 };
 
 struct netsec_priv {
 	struct netsec_desc_ring desc_ring[NETSEC_RING_MAX];
 	struct ethtool_coalesce et_coalesce;
+	struct bpf_prog *xdp_prog;
 	spinlock_t reglock; /* protect reg access */
 	struct napi_struct napi;
 	phy_interface_t phy_interface;
@@ -303,6 +328,11 @@ struct netsec_rx_pkt_info {
 	bool err_flag;
 };
 
+static void netsec_set_tx_de(struct netsec_priv *priv,
+			     struct netsec_desc_ring *dring,
+			     const struct netsec_tx_pkt_ctrl *tx_ctrl,
+			     const struct netsec_desc *desc, void *buf);
+
 static void netsec_write(struct netsec_priv *priv, u32 reg_addr, u32 val)
 {
 	writel(val, priv->ioaddr + reg_addr);
@@ -609,6 +639,9 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 	int tail = dring->tail;
 	int cnt = 0;
 
+	if (dring->is_xdp)
+		spin_lock(&dring->lock);
+
 	pkts = 0;
 	bytes = 0;
 	entry = dring->vaddr + DESC_SZ * tail;
@@ -622,16 +655,24 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 		eop = (entry->attr >> NETSEC_TX_LAST) & 1;
 		dma_rmb();
 
-		dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
-				 DMA_TO_DEVICE);
-		if (eop) {
-			pkts++;
+		if (!eop)
+			goto next;
+
+		if (desc->buf_type == TYPE_NETSEC_SKB) {
+			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
+					 DMA_TO_DEVICE);
 			bytes += desc->skb->len;
 			dev_kfree_skb(desc->skb);
+		} else {
+			if (desc->buf_type == TYPE_NETSEC_XDP_NDO)
+				dma_unmap_single(priv->dev, desc->dma_addr,
+						 desc->len, DMA_TO_DEVICE);
+			xdp_return_frame(desc->xdpf);
 		}
 		/* clean up so netsec_uninit_pkt_dring() won't free the skb
 		 * again
 		 */
+next:
 		*desc = (struct netsec_desc){};
 
 		/* entry->attr is not going to be accessed by the NIC until
@@ -645,6 +686,8 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 		entry = dring->vaddr + DESC_SZ * tail;
 		cnt++;
 	}
+	if (dring->is_xdp)
+		spin_unlock(&dring->lock);
 
 	if (!cnt)
 		return false;
@@ -688,12 +731,13 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	if (!page)
 		return NULL;
 
-	/* page_pool API will map the whole page, skip
-	 * NET_SKB_PAD + NET_IP_ALIGN for the payload
+	/* We allocate the same buffer length for XDP and non-XDP cases.
+	 * page_pool API will map the whole page, skip what's needed for
+	 * network payloads and/or XDP
 	 */
-	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_SKB_PAD;
-	/* make sure the incoming payload fits in the page with the needed
-	 * NET_SKB_PAD + NET_IP_ALIGN + skb_shared_info
+	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
+	/* Make sure the incoming payload fits in the page for XDP and non-XDP
+	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
 	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
 
@@ -714,12 +758,144 @@ static void netsec_rx_fill(struct netsec_priv *priv, u16 from, u16 num)
 	}
 }
 
+static void netsec_xdp_ring_tx_db(struct netsec_priv *priv, u16 pkts)
+{
+	if (likely(pkts))
+		netsec_write(priv, NETSEC_REG_NRM_TX_PKTCNT, pkts);
+}
+
+static void netsec_finalize_xdp_rx(struct netsec_priv *priv, u32 xdp_res,
+				   u16 pkts)
+{
+	if (xdp_res & NETSEC_XDP_REDIR)
+		xdp_do_flush_map();
+
+	if (xdp_res & NETSEC_XDP_TX)
+		netsec_xdp_ring_tx_db(priv, pkts);
+}
+
+/* The current driver only supports 1 Txq, this should run under spin_lock() */
+static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
+				struct xdp_frame *xdpf, bool is_ndo)
+
+{
+	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
+	struct page *page = virt_to_page(xdpf->data);
+	struct netsec_tx_pkt_ctrl tx_ctrl = {};
+	struct netsec_desc tx_desc;
+	dma_addr_t dma_handle;
+	u16 filled;
+
+	if (tx_ring->head >= tx_ring->tail)
+		filled = tx_ring->head - tx_ring->tail;
+	else
+		filled = tx_ring->head + DESC_NUM - tx_ring->tail;
+
+	if (DESC_NUM - filled <= 1)
+		return NETSEC_XDP_CONSUMED;
+
+	if (is_ndo) {
+		/* this is for ndo_xdp_xmit, the buffer needs mapping before
+		 * sending
+		 */
+		dma_handle = dma_map_single(priv->dev, xdpf->data, xdpf->len,
+					    DMA_TO_DEVICE);
+		if (dma_mapping_error(priv->dev, dma_handle))
+			return NETSEC_XDP_CONSUMED;
+		tx_desc.buf_type = TYPE_NETSEC_XDP_NDO;
+	} else {
+		/* This is the device Rx buffer from page_pool. No need to remap
+		 * just sync and send it
+		 */
+		dma_handle = page_pool_get_dma_addr(page) +
+			NETSEC_RXBUF_HEADROOM;
+		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
+					   DMA_BIDIRECTIONAL);
+		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;
+	}
+	tx_ctrl.cksum_offload_flag = false;
+	tx_ctrl.tcp_seg_offload_flag = false;
+	tx_ctrl.tcp_seg_len = 0;
+
+	tx_desc.dma_addr = dma_handle;
+	tx_desc.addr = xdpf->data;
+	tx_desc.len = xdpf->len;
+
+	netsec_set_tx_de(priv, tx_ring, &tx_ctrl, &tx_desc, xdpf);
+
+	return NETSEC_XDP_TX;
+}
+
+static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
+{
+	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
+	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+	u32 ret;
+
+	if (unlikely(!xdpf))
+		return NETSEC_XDP_CONSUMED;
+
+	spin_lock(&tx_ring->lock);
+	ret = netsec_xdp_queue_one(priv, xdpf, false);
+	spin_unlock(&tx_ring->lock);
+
+	return ret;
+}
+
+static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
+			  struct xdp_buff *xdp)
+{
+	u32 ret = NETSEC_XDP_PASS;
+	int err;
+	u32 act;
+
+	rcu_read_lock();
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	switch (act) {
+	case XDP_PASS:
+		ret = NETSEC_XDP_PASS;
+		break;
+	case XDP_TX:
+		ret = netsec_xdp_xmit_back(priv, xdp);
+		if (ret != NETSEC_XDP_TX)
+			xdp_return_buff(xdp);
+		break;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(priv->ndev, xdp, prog);
+		if (!err) {
+			ret = NETSEC_XDP_REDIR;
+		} else {
+			ret = NETSEC_XDP_CONSUMED;
+			xdp_return_buff(xdp);
+		}
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(priv->ndev, prog, act);
+		/* fall through -- handle aborts by dropping packet */
+	case XDP_DROP:
+		ret = NETSEC_XDP_CONSUMED;
+		xdp_return_buff(xdp);
+		break;
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int netsec_process_rx(struct netsec_priv *priv, int budget)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
 	struct net_device *ndev = priv->ndev;
 	struct netsec_rx_pkt_info rx_info;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	u16 xdp_xmit = 0;
+	u32 xdp_act = 0;
 	int done = 0;
 
 	while (done < budget) {
@@ -727,8 +903,10 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
+		struct xdp_buff xdp;
 		void *buf_addr;
 
 		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
@@ -773,7 +951,23 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 					DMA_FROM_DEVICE);
 		prefetch(desc->addr);
 
+		xdp.data_hard_start = desc->addr;
+		xdp.data = desc->addr + NETSEC_RXBUF_HEADROOM;
+		xdp_set_data_meta_invalid(&xdp);
+		xdp.data_end = xdp.data + pkt_len;
+		xdp.rxq = &dring->xdp_rxq;
+
+		if (xdp_prog) {
+			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);
+			if (xdp_result != NETSEC_XDP_PASS) {
+				xdp_act |= xdp_result;
+				if (xdp_result == NETSEC_XDP_TX)
+					xdp_xmit++;
+				goto next;
+			}
+		}
 		skb = build_skb(desc->addr, desc->len + NETSEC_RX_BUF_NON_DATA);
+
 		if (unlikely(!skb)) {
 			/* If skb fails recycle_direct will either unmap and
 			 * free the page or refill the cache depending on the
@@ -787,27 +981,30 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		}
 		page_pool_release_page(dring->page_pool, page);
 
-		/* Update the descriptor with the new buffer we allocated */
-		desc->len = desc_len;
-		desc->dma_addr = dma_handle;
-		desc->addr = buf_addr;
-
-		skb_reserve(skb, NETSEC_SKB_PAD);
-		skb_put(skb, pkt_len);
+		skb_reserve(skb, xdp.data - xdp.data_hard_start);
+		skb_put(skb, xdp.data_end - xdp.data);
 		skb->protocol = eth_type_trans(skb, priv->ndev);
 
 		if (priv->rx_cksum_offload_flag &&
 		    rx_info.rx_cksum_result == NETSEC_RX_CKSUM_OK)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-		if (napi_gro_receive(&priv->napi, skb) != GRO_DROP) {
+next:
+		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
+		    xdp_result & NETSEC_XDP_RX_OK) {
 			ndev->stats.rx_packets++;
-			ndev->stats.rx_bytes += pkt_len;
+			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
 		}
 
+		/* Update the descriptor with fresh buffers */
+		desc->len = desc_len;
+		desc->dma_addr = dma_handle;
+		desc->addr = buf_addr;
+
 		netsec_rx_fill(priv, idx, 1);
 		dring->tail = (dring->tail + 1) % DESC_NUM;
 	}
+	netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
 
 	return done;
 }
@@ -837,8 +1034,7 @@ static int netsec_napi_poll(struct napi_struct *napi, int budget)
 static void netsec_set_tx_de(struct netsec_priv *priv,
 			     struct netsec_desc_ring *dring,
 			     const struct netsec_tx_pkt_ctrl *tx_ctrl,
-			     const struct netsec_desc *desc,
-			     struct sk_buff *skb)
+			     const struct netsec_desc *desc, void *buf)
 {
 	int idx = dring->head;
 	struct netsec_de *de;
@@ -861,10 +1057,16 @@ static void netsec_set_tx_de(struct netsec_priv *priv,
 	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
 	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
 	de->attr = attr;
-	dma_wmb();
+	/* under spin_lock if using XDP */
+	if (!dring->is_xdp)
+		dma_wmb();
 
 	dring->desc[idx] = *desc;
-	dring->desc[idx].skb = skb;
+	if (desc->buf_type == TYPE_NETSEC_SKB)
+		dring->desc[idx].skb = buf;
+	else if (desc->buf_type == TYPE_NETSEC_XDP_TX ||
+		 desc->buf_type == TYPE_NETSEC_XDP_NDO)
+		dring->desc[idx].xdpf = buf;
 
 	/* move head ahead */
 	dring->head = (dring->head + 1) % DESC_NUM;
@@ -915,8 +1117,12 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	u16 tso_seg_len = 0;
 	int filled;
 
+	if (dring->is_xdp)
+		spin_lock_bh(&dring->lock);
 	filled = netsec_desc_used(dring);
 	if (netsec_check_stop_tx(priv, filled)) {
+		if (dring->is_xdp)
+			spin_unlock_bh(&dring->lock);
 		net_warn_ratelimited("%s %s Tx queue full\n",
 				     dev_name(priv->dev), ndev->name);
 		return NETDEV_TX_BUSY;
@@ -949,6 +1155,8 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	tx_desc.dma_addr = dma_map_single(priv->dev, skb->data,
 					  skb_headlen(skb), DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->dev, tx_desc.dma_addr)) {
+		if (dring->is_xdp)
+			spin_unlock_bh(&dring->lock);
 		netif_err(priv, drv, priv->ndev,
 			  "%s: DMA mapping failed\n", __func__);
 		ndev->stats.tx_dropped++;
@@ -957,11 +1165,14 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	}
 	tx_desc.addr = skb->data;
 	tx_desc.len = skb_headlen(skb);
+	tx_desc.buf_type = TYPE_NETSEC_SKB;
 
 	skb_tx_timestamp(skb);
 	netdev_sent_queue(priv->ndev, skb->len);
 
 	netsec_set_tx_de(priv, dring, &tx_ctrl, &tx_desc, skb);
+	if (dring->is_xdp)
+		spin_unlock_bh(&dring->lock);
 	netsec_write(priv, NETSEC_REG_NRM_TX_PKTCNT, 1); /* submit another tx */
 
 	return NETDEV_TX_OK;
@@ -1042,6 +1253,7 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 static void netsec_setup_tx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
+	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
 	int i;
 
 	for (i = 0; i < DESC_NUM; i++) {
@@ -1054,11 +1266,18 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
 		 */
 		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
 	}
+
+	if (xdp_prog)
+		dring->is_xdp = true;
+	else
+		dring->is_xdp = false;
+
 }
 
 static int netsec_setup_rx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
 	struct page_pool_params pp_params = { 0 };
 	int i, err;
 
@@ -1068,7 +1287,7 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 	pp_params.pool_size = DESC_NUM;
 	pp_params.nid = cpu_to_node(0);
 	pp_params.dev = priv->dev;
-	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 
 	dring->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(dring->page_pool)) {
@@ -1490,6 +1709,9 @@ static int netsec_netdev_init(struct net_device *ndev)
 	if (ret)
 		goto err2;
 
+	spin_lock_init(&priv->desc_ring[NETSEC_RING_TX].lock);
+	spin_lock_init(&priv->desc_ring[NETSEC_RING_RX].lock);
+
 	return 0;
 err2:
 	netsec_free_dring(priv, NETSEC_RING_RX);
@@ -1522,6 +1744,81 @@ static int netsec_netdev_ioctl(struct net_device *ndev, struct ifreq *ifr,
 	return phy_mii_ioctl(ndev->phydev, ifr, cmd);
 }
 
+static int netsec_xdp_xmit(struct net_device *ndev, int n,
+			   struct xdp_frame **frames, u32 flags)
+{
+	struct netsec_priv *priv = netdev_priv(ndev);
+	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
+	int drops = 0;
+	int i;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	spin_lock(&tx_ring->lock);
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = netsec_xdp_queue_one(priv, xdpf, true);
+		if (err != NETSEC_XDP_TX) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		} else {
+			tx_ring->xdp_xmit++;
+		}
+	}
+	spin_unlock(&tx_ring->lock);
+
+	if (unlikely(flags & XDP_XMIT_FLUSH)) {
+		netsec_xdp_ring_tx_db(priv, tx_ring->xdp_xmit);
+		tx_ring->xdp_xmit = 0;
+	}
+
+	return n - drops;
+}
+
+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
+			    struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = priv->ndev;
+	struct bpf_prog *old_prog;
+
+	/* For now just support only the usual MTU sized frames */
+	if (prog && dev->mtu > 1500) {
+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_running(dev))
+		netsec_netdev_stop(dev);
+
+	/* Detach old prog, if any */
+	old_prog = xchg(&priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (netif_running(dev))
+		netsec_netdev_open(dev);
+
+	return 0;
+}
+
+static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
+{
+	struct netsec_priv *priv = netdev_priv(ndev);
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct net_device_ops netsec_netdev_ops = {
 	.ndo_init		= netsec_netdev_init,
 	.ndo_uninit		= netsec_netdev_uninit,
@@ -1532,6 +1829,8 @@ static const struct net_device_ops netsec_netdev_ops = {
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= netsec_netdev_ioctl,
+	.ndo_xdp_xmit		= netsec_xdp_xmit,
+	.ndo_bpf		= netsec_xdp,
 };
 
 static int netsec_of_probe(struct platform_device *pdev,
-- 
2.20.1

