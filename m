Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F6B3507E1
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhCaUJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbhCaUJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24822C061574;
        Wed, 31 Mar 2021 13:09:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jy13so31954559ejc.2;
        Wed, 31 Mar 2021 13:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3KM4a6OLQRnYhBSYHdPt+GN1/+0sqBukLjCDrxOj9Y=;
        b=FwEa96JN8k3BvcxESsDmX5k7f6BT/orBb+SI9d7XD+b76fkMTdyhOAj4ONaQp3ihCW
         hJOdb2QVm9/1E73GSY9VaBhKFRZo5FjZBTEwYm8jgXVyawWJ3OCPo2zkIc7u67902dLt
         4BYeo1HilwnlQrm8MUxYPmgiOOJVaI2ENcJ8dxu+OMp7ubNi5eFNPonI1M/LejI7BZSp
         S4m4vfc7stWeNI3WIRfUAxXGth6HWQRTYHjbMJ5hitzdRtlQyXq0ZgRdTwZSxLKh6xMK
         nLyjYw1TgHcseM27NIh//ZtWLnFk/NOrLci1JK46bfy859Ywm9zsQQwO8QRdUhd8eYAo
         Ysxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3KM4a6OLQRnYhBSYHdPt+GN1/+0sqBukLjCDrxOj9Y=;
        b=dh/9NbhhPd4Fha4X2nSHI2fuPIDkcMOadPaO4AfSix3tIrTCOWXGmKMVyIYTKKyHQX
         1K0ZT8Pes2F3uKBVjIEE5BlD6zYRYsRPfWKiXaqc+ZNUnNi0kgNOAJcXAOcT5WLuwa/5
         N/LlFHTl8lAvtd+dLlTxrAcs5gf8hcrx2BHZaGq/87E/+hm6zPcA7zdB8SDG4EbbPprp
         aH6xONvndUtX+JPTDzXWVjnmyQNggAgpcXsBHm3XqWSP3/qUqIQFaqhD37mN2Xb1AVuZ
         lU6LbNvvC1FVMViMCA0XtttjlvGPHk2UT2T5Ul/AzOZ++iIRr2CUTYtsrhSXgxZVXVUa
         12Wg==
X-Gm-Message-State: AOAM531M7VTlZUnl4WpTcslDAjMAtuHGLlmzKkPQIctrSjgdT4BIeI13
        jAnEMBRcmVkGKqfBrhDJrtQ=
X-Google-Smtp-Source: ABdhPJy4DyywNuU+3QbyU8g8JiOvKzMrW1WP/u3zhISN0oYWI7u1Mb8ONoM/9h5BtBEr5YBPF90KYg==
X-Received: by 2002:a17:906:1a16:: with SMTP id i22mr5546241ejf.522.1617221365819;
        Wed, 31 Mar 2021 13:09:25 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 9/9] net: enetc: add support for XDP_REDIRECT
Date:   Wed, 31 Mar 2021 23:08:57 +0300
Message-Id: <20210331200857.3274425-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver implementation of the XDP_REDIRECT action reuses parts from
XDP_TX, most notably the enetc_xdp_tx function which transmits an array
of TX software BDs. Only this time, the buffers don't have DMA mappings,
we need to create them.

When a BPF program reaches the XDP_REDIRECT verdict for a frame, we can
employ the same buffer reuse strategy as for the normal processing path
and for XDP_PASS: we can flip to the other page half and seed that to
the RX ring.

Note that scatter/gather support is there, but disabled due to lack of
multi-buffer support in XDP (which is added by this series):
https://patchwork.kernel.org/project/netdevbpf/cover/cover.1616179034.git.lorenzo@kernel.org/

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 212 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |  11 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   6 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
 4 files changed, 218 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ba5313a5d7a4..57049ae97201 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -8,6 +8,23 @@
 #include <linux/vmalloc.h>
 #include <net/pkt_sched.h>
 
+static struct sk_buff *enetc_tx_swbd_get_skb(struct enetc_tx_swbd *tx_swbd)
+{
+	if (tx_swbd->is_xdp_tx || tx_swbd->is_xdp_redirect)
+		return NULL;
+
+	return tx_swbd->skb;
+}
+
+static struct xdp_frame *
+enetc_tx_swbd_get_xdp_frame(struct enetc_tx_swbd *tx_swbd)
+{
+	if (tx_swbd->is_xdp_redirect)
+		return tx_swbd->xdp_frame;
+
+	return NULL;
+}
+
 static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 				struct enetc_tx_swbd *tx_swbd)
 {
@@ -25,14 +42,20 @@ static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 	tx_swbd->dma = 0;
 }
 
-static void enetc_free_tx_skb(struct enetc_bdr *tx_ring,
-			      struct enetc_tx_swbd *tx_swbd)
+static void enetc_free_tx_frame(struct enetc_bdr *tx_ring,
+				struct enetc_tx_swbd *tx_swbd)
 {
+	struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
+	struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
+
 	if (tx_swbd->dma)
 		enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
-	if (tx_swbd->skb) {
-		dev_kfree_skb_any(tx_swbd->skb);
+	if (xdp_frame) {
+		xdp_return_frame(tx_swbd->xdp_frame);
+		tx_swbd->xdp_frame = NULL;
+	} else if (skb) {
+		dev_kfree_skb_any(skb);
 		tx_swbd->skb = NULL;
 	}
 }
@@ -183,7 +206,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 
 	do {
 		tx_swbd = &tx_ring->tx_swbd[i];
-		enetc_free_tx_skb(tx_ring, tx_swbd);
+		enetc_free_tx_frame(tx_ring, tx_swbd);
 		if (i == 0)
 			i = tx_ring->bd_count;
 		i--;
@@ -381,6 +404,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	do_tstamp = false;
 
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
+		struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
+		struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
+
 		if (unlikely(tx_swbd->check_wb)) {
 			struct enetc_ndev_priv *priv = netdev_priv(ndev);
 			union enetc_tx_bd *txbd;
@@ -400,12 +426,15 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		else if (likely(tx_swbd->dma))
 			enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
-		if (tx_swbd->skb) {
+		if (xdp_frame) {
+			xdp_return_frame(xdp_frame);
+			tx_swbd->xdp_frame = NULL;
+		} else if (skb) {
 			if (unlikely(do_tstamp)) {
-				enetc_tstamp_tx(tx_swbd->skb, tstamp);
+				enetc_tstamp_tx(skb, tstamp);
 				do_tstamp = false;
 			}
-			napi_consume_skb(tx_swbd->skb, napi_budget);
+			napi_consume_skb(skb, napi_budget);
 			tx_swbd->skb = NULL;
 		}
 
@@ -827,6 +856,109 @@ static bool enetc_xdp_tx(struct enetc_bdr *tx_ring,
 	return true;
 }
 
+static int enetc_xdp_frame_to_xdp_tx_swbd(struct enetc_bdr *tx_ring,
+					  struct enetc_tx_swbd *xdp_tx_arr,
+					  struct xdp_frame *xdp_frame)
+{
+	struct enetc_tx_swbd *xdp_tx_swbd = &xdp_tx_arr[0];
+	struct skb_shared_info *shinfo;
+	void *data = xdp_frame->data;
+	int len = xdp_frame->len;
+	skb_frag_t *frag;
+	dma_addr_t dma;
+	unsigned int f;
+	int n = 0;
+
+	dma = dma_map_single(tx_ring->dev, data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(tx_ring->dev, dma))) {
+		netdev_err(tx_ring->ndev, "DMA map error\n");
+		return -1;
+	}
+
+	xdp_tx_swbd->dma = dma;
+	xdp_tx_swbd->dir = DMA_TO_DEVICE;
+	xdp_tx_swbd->len = len;
+	xdp_tx_swbd->is_xdp_redirect = true;
+	xdp_tx_swbd->is_eof = false;
+	xdp_tx_swbd->xdp_frame = NULL;
+
+	n++;
+	xdp_tx_swbd = &xdp_tx_arr[n];
+
+	shinfo = xdp_get_shared_info_from_frame(xdp_frame);
+
+	for (f = 0, frag = &shinfo->frags[0]; f < shinfo->nr_frags;
+	     f++, frag++) {
+		data = skb_frag_address(frag);
+		len = skb_frag_size(frag);
+
+		dma = dma_map_single(tx_ring->dev, data, len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(tx_ring->dev, dma))) {
+			/* Undo the DMA mapping for all fragments */
+			while (n-- >= 0)
+				enetc_unmap_tx_buff(tx_ring, &xdp_tx_arr[n]);
+
+			netdev_err(tx_ring->ndev, "DMA map error\n");
+			return -1;
+		}
+
+		xdp_tx_swbd->dma = dma;
+		xdp_tx_swbd->dir = DMA_TO_DEVICE;
+		xdp_tx_swbd->len = len;
+		xdp_tx_swbd->is_xdp_redirect = true;
+		xdp_tx_swbd->is_eof = false;
+		xdp_tx_swbd->xdp_frame = NULL;
+
+		n++;
+		xdp_tx_swbd = &xdp_tx_arr[n];
+	}
+
+	xdp_tx_arr[n - 1].is_eof = true;
+	xdp_tx_arr[n - 1].xdp_frame = xdp_frame;
+
+	return n;
+}
+
+int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
+		   struct xdp_frame **frames, u32 flags)
+{
+	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_bdr *tx_ring;
+	int xdp_tx_bd_cnt, i, k;
+	int xdp_tx_frm_cnt = 0;
+
+	tx_ring = priv->tx_ring[smp_processor_id()];
+
+	prefetchw(ENETC_TXBD(*tx_ring, tx_ring->next_to_use));
+
+	for (k = 0; k < num_frames; k++) {
+		xdp_tx_bd_cnt = enetc_xdp_frame_to_xdp_tx_swbd(tx_ring,
+							       xdp_redirect_arr,
+							       frames[k]);
+		if (unlikely(xdp_tx_bd_cnt < 0))
+			break;
+
+		if (unlikely(!enetc_xdp_tx(tx_ring, xdp_redirect_arr,
+					   xdp_tx_bd_cnt))) {
+			for (i = 0; i < xdp_tx_bd_cnt; i++)
+				enetc_unmap_tx_buff(tx_ring,
+						    &xdp_redirect_arr[i]);
+			tx_ring->stats.xdp_tx_drops++;
+			break;
+		}
+
+		xdp_tx_frm_cnt++;
+	}
+
+	if (unlikely((flags & XDP_XMIT_FLUSH) || k != xdp_tx_frm_cnt))
+		enetc_update_tx_ring_tail(tx_ring);
+
+	tx_ring->stats.xdp_tx += xdp_tx_frm_cnt;
+
+	return xdp_tx_frm_cnt;
+}
+
 static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 				     struct xdp_buff *xdp_buff, u16 size)
 {
@@ -948,14 +1080,31 @@ static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 	rx_ring->stats.xdp_drops++;
 }
 
+static void enetc_xdp_free(struct enetc_bdr *rx_ring, int rx_ring_first,
+			   int rx_ring_last)
+{
+	while (rx_ring_first != rx_ring_last) {
+		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[rx_ring_first];
+
+		if (rx_swbd->page) {
+			dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
+				       rx_swbd->dir);
+			__free_page(rx_swbd->page);
+			rx_swbd->page = NULL;
+		}
+		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
+	}
+	rx_ring->stats.xdp_redirect_failures++;
+}
+
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				   struct napi_struct *napi, int work_limit,
 				   struct bpf_prog *prog)
 {
+	int xdp_tx_bd_cnt, xdp_tx_frm_cnt = 0, xdp_redirect_frm_cnt = 0;
 	struct enetc_tx_swbd xdp_tx_arr[ENETC_MAX_SKB_FRAGS] = {0};
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
 	struct enetc_bdr *tx_ring = priv->tx_ring[rx_ring->index];
-	int xdp_tx_bd_cnt, xdp_tx_frm_cnt = 0;
 	int rx_frm_cnt = 0, rx_byte_cnt = 0;
 	int cleaned_cnt, i;
 	u32 xdp_act;
@@ -969,6 +1118,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		int orig_i, orig_cleaned_cnt;
 		struct xdp_buff xdp_buff;
 		struct sk_buff *skb;
+		int tmp_orig_i, err;
 		u32 bd_status;
 
 		rxbd = enetc_rxbd(rx_ring, i);
@@ -1026,6 +1176,43 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
 				xdp_tx_frm_cnt++;
 			}
+			break;
+		case XDP_REDIRECT:
+			/* xdp_return_frame does not support S/G in the sense
+			 * that it leaks the fragments (__xdp_return should not
+			 * call page_frag_free only for the initial buffer).
+			 * Until XDP_REDIRECT gains support for S/G let's keep
+			 * the code structure in place, but dead. We drop the
+			 * S/G frames ourselves to avoid memory leaks which
+			 * would otherwise leave the kernel OOM.
+			 */
+			if (unlikely(cleaned_cnt - orig_cleaned_cnt != 1)) {
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				rx_ring->stats.xdp_redirect_sg++;
+				break;
+			}
+
+			tmp_orig_i = orig_i;
+
+			while (orig_i != i) {
+				enetc_put_rx_buff(rx_ring,
+						  &rx_ring->rx_swbd[orig_i]);
+				enetc_bdr_idx_inc(rx_ring, &orig_i);
+			}
+
+			err = xdp_do_redirect(rx_ring->ndev, &xdp_buff, prog);
+			if (unlikely(err)) {
+				enetc_xdp_free(rx_ring, tmp_orig_i, i);
+			} else {
+				xdp_redirect_frm_cnt++;
+				rx_ring->stats.xdp_redirect++;
+			}
+
+			if (unlikely(xdp_redirect_frm_cnt > ENETC_DEFAULT_TX_WORK)) {
+				xdp_do_flush_map();
+				xdp_redirect_frm_cnt = 0;
+			}
+
 			break;
 		default:
 			bpf_warn_invalid_xdp_action(xdp_act);
@@ -1039,6 +1226,9 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	rx_ring->stats.packets += rx_frm_cnt;
 	rx_ring->stats.bytes += rx_byte_cnt;
 
+	if (xdp_redirect_frm_cnt)
+		xdp_do_flush_map();
+
 	if (xdp_tx_frm_cnt)
 		enetc_update_tx_ring_tail(tx_ring);
 
@@ -1173,7 +1363,7 @@ static void enetc_free_txbdr(struct enetc_bdr *txr)
 	int size, i;
 
 	for (i = 0; i < txr->bd_count; i++)
-		enetc_free_tx_skb(txr, &txr->tx_swbd[i]);
+		enetc_free_tx_frame(txr, &txr->tx_swbd[i]);
 
 	size = txr->bd_count * sizeof(union enetc_tx_bd);
 
@@ -1290,7 +1480,7 @@ static void enetc_free_tx_ring(struct enetc_bdr *tx_ring)
 	for (i = 0; i < tx_ring->bd_count; i++) {
 		struct enetc_tx_swbd *tx_swbd = &tx_ring->tx_swbd[i];
 
-		enetc_free_tx_skb(tx_ring, tx_swbd);
+		enetc_free_tx_frame(tx_ring, tx_swbd);
 	}
 
 	tx_ring->next_to_clean = 0;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index d0619fcbbe97..05474f46b0d9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -19,7 +19,10 @@
 				(ETH_FCS_LEN + ETH_HLEN + VLAN_HLEN))
 
 struct enetc_tx_swbd {
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdp_frame;
+	};
 	dma_addr_t dma;
 	struct page *page;	/* valid only if is_xdp_tx */
 	u16 page_offset;	/* valid only if is_xdp_tx */
@@ -30,6 +33,7 @@ struct enetc_tx_swbd {
 	u8 do_tstamp:1;
 	u8 is_eof:1;
 	u8 is_xdp_tx:1;
+	u8 is_xdp_redirect:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
@@ -61,6 +65,9 @@ struct enetc_ring_stats {
 	unsigned int xdp_drops;
 	unsigned int xdp_tx;
 	unsigned int xdp_tx_drops;
+	unsigned int xdp_redirect;
+	unsigned int xdp_redirect_failures;
+	unsigned int xdp_redirect_sg;
 	unsigned int recycles;
 	unsigned int recycle_failures;
 };
@@ -354,6 +361,8 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
 int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
+int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
+		   struct xdp_frame **frames, u32 flags);
 
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 37821a8b225e..7cc81b453bd7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -195,6 +195,9 @@ static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Rx ring %2d XDP drops",
 	"Rx ring %2d recycles",
 	"Rx ring %2d recycle failures",
+	"Rx ring %2d redirects",
+	"Rx ring %2d redirect failures",
+	"Rx ring %2d redirect S/G",
 };
 
 static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
@@ -284,6 +287,9 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = priv->rx_ring[i]->stats.xdp_drops;
 		data[o++] = priv->rx_ring[i]->stats.recycles;
 		data[o++] = priv->rx_ring[i]->stats.recycle_failures;
+		data[o++] = priv->rx_ring[i]->stats.xdp_redirect;
+		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_failures;
+		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_sg;
 	}
 
 	if (!enetc_si_is_pf(priv->si))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 0484dbe13422..f61fedf462e5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -708,6 +708,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_do_ioctl		= enetc_ioctl,
 	.ndo_setup_tc		= enetc_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
+	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
 
 static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.25.1

