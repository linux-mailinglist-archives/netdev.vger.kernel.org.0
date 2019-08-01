Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD857E629
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbfHAXHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:07:40 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55954 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfHAXHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:07:40 -0400
Received: by mail-pf1-f201.google.com with SMTP id i26so46706071pfo.22
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KKPdA9CpsFqfR0sAx1/A7acqnQCjrNcoU3vR/GJmBEo=;
        b=IBJBUI72FRiRnBZuxUcbXoUHPsePTHkgrGaFrl2TxWJOzVwyJb5gRbCRM4FmJLUlUG
         KJYfggqUlzvNgBYrBVFNJ48d4DXMHrW8ieOLLMsfCec3XP01dFIUNgWO0O9J3CsNL7Jp
         rfcYpJB+Nu11NV4nG1LIKOELfAehoFoXpMLfG1eGFoCTxAfvC17k09E9xLSRQFZjv2oU
         NwsBXvkhLVkuDdOyJ5j1dIQWoBVs64TGTL/59tgvU29oYfUQEDyh4d+PW7pk9oZpP8rg
         RdSk7kSlH1llPQn4qeCJCyZg6mN6F4Wj0MznDqGvAmp2//WKMu/DmArK7blA1zFNEUf4
         oBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KKPdA9CpsFqfR0sAx1/A7acqnQCjrNcoU3vR/GJmBEo=;
        b=ClFeUb02cG0Qnqi1PBYIydRljzRwO+YupQ2Lod/JXs4zyYCHHlM0UoxS2aRkRMpPU/
         WKGG9F1DbHyAf45CTwtaK05zF/5djoU39GSi35IZ7QTTPrUv5lkU5MRd1M5HwaxNfEDI
         pQKd6NeObYIDOIcCzDNrGkl4W2LWPO8C+kxdkxiKwuwdsVhplcSnziScQqGfYUL2bZNp
         M04LTcrEB30qbMsNYj1IB6TD/TVcJuMKq/yIORePImaWwpx/N5SIWVDRZfldsSD4AeRX
         BuKBKCWsAanI5ZMKXmNe8Yn/Z7dAnWT8WsSPo8cd/+fCuetoOdi1KdG++yZl97vwdhS7
         cudw==
X-Gm-Message-State: APjAAAV12GLfPAzYwnp/3bcxX+uR2enW1iBE4fiOTIBN9cjf9nsMjrh0
        ozBS8HxaeYobPnO1FdFpxC+GcTJVmHZHPfL051WhPwHznW0j0+C02G98lVmL2g3Ik3/5OkSfxKV
        fs8D4KxGMRJML4U35yMrD9GNDrcp0xTjrsFajvjXN/svEuPGbDGKXlhtXzdrpqA==
X-Google-Smtp-Source: APXvYqx+oufGSvitwg7n8BA74M+34RKnPom02Pp0XDtd6Sw+SFrhiJmmObge/kUyEnJ5ALWvHWthReTtuE4=
X-Received: by 2002:a65:528d:: with SMTP id y13mr33189391pgp.120.1564700859000;
 Thu, 01 Aug 2019 16:07:39 -0700 (PDT)
Date:   Thu,  1 Aug 2019 16:07:31 -0700
Message-Id: <20190801230731.142536-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH net] gve: Fix case where desc_cnt and data_cnt can get out of sync
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

desc_cnt and data_cnt should always be equal. In the case of a dropped
packet desc_cnt was still getting updated (correctly), data_cnt
was not. To eliminate this bug and prevent it from recurring this
patch combines them into one ring level cnt.

Signed-off-by: Catherine Sullivan <csully@google.com>
Reviewed-by: Sagi Shahar <sagis@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  8 ++---
 drivers/net/ethernet/google/gve/gve_ethtool.c |  4 +--
 drivers/net/ethernet/google/gve/gve_rx.c      | 34 ++++++++-----------
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 92372dc43be8..ebc37e256922 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -31,9 +31,6 @@
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
 	dma_addr_t bus; /* the bus for the desc_ring */
-	u32 cnt; /* free-running total number of completed packets */
-	u32 fill_cnt; /* free-running total number of descriptors posted */
-	u32 mask; /* masks the cnt to the size of the ring */
 	u8 seqno; /* the next expected seqno for this desc*/
 };
 
@@ -60,8 +57,6 @@ struct gve_rx_data_queue {
 	dma_addr_t data_bus; /* dma mapping of the slots */
 	struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
 	struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
-	u32 mask; /* masks the cnt to the size of the ring */
-	u32 cnt; /* free-running total number of completed packets */
 };
 
 struct gve_priv;
@@ -73,6 +68,9 @@ struct gve_rx_ring {
 	struct gve_rx_data_queue data;
 	u64 rbytes; /* free-running bytes received */
 	u64 rpackets; /* free-running packets received */
+	u32 cnt; /* free-running total number of completed packets */
+	u32 fill_cnt; /* free-running total number of descs and buffs posted */
+	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 26540b856541..d8fa816f4473 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -138,8 +138,8 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			struct gve_rx_ring *rx = &priv->rx[ring];
 
-			data[i++] = rx->desc.cnt;
-			data[i++] = rx->desc.fill_cnt;
+			data[i++] = rx->cnt;
+			data[i++] = rx->fill_cnt;
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 1914b8350da7..59564ac99d2a 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -37,7 +37,7 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 	rx->data.qpl = NULL;
 	kvfree(rx->data.page_info);
 
-	slots = rx->data.mask + 1;
+	slots = rx->mask + 1;
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(dev, bytes, rx->data.data_ring,
 			  rx->data.data_bus);
@@ -64,7 +64,7 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	/* Allocate one page per Rx queue slot. Each page is split into two
 	 * packet buffers, when possible we "page flip" between the two.
 	 */
-	slots = rx->data.mask + 1;
+	slots = rx->mask + 1;
 
 	rx->data.page_info = kvzalloc(slots *
 				      sizeof(*rx->data.page_info), GFP_KERNEL);
@@ -111,7 +111,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 	rx->q_num = idx;
 
 	slots = priv->rx_pages_per_qpl;
-	rx->data.mask = slots - 1;
+	rx->mask = slots - 1;
 
 	/* alloc rx data ring */
 	bytes = sizeof(*rx->data.data_ring) * slots;
@@ -125,7 +125,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 		err = -ENOMEM;
 		goto abort_with_slots;
 	}
-	rx->desc.fill_cnt = filled_pages;
+	rx->fill_cnt = filled_pages;
 	/* Ensure data ring slots (packet buffers) are visible. */
 	dma_wmb();
 
@@ -156,8 +156,8 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 		err = -ENOMEM;
 		goto abort_with_q_resources;
 	}
-	rx->desc.mask = slots - 1;
-	rx->desc.cnt = 0;
+	rx->mask = slots - 1;
+	rx->cnt = 0;
 	rx->desc.seqno = 1;
 	gve_rx_add_to_block(priv, idx);
 
@@ -213,7 +213,7 @@ void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx)
 {
 	u32 db_idx = be32_to_cpu(rx->q_resources->db_index);
 
-	iowrite32be(rx->desc.fill_cnt, &priv->db_bar2[db_idx]);
+	iowrite32be(rx->fill_cnt, &priv->db_bar2[db_idx]);
 }
 
 static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
@@ -273,7 +273,7 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
 }
 
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
-		   netdev_features_t feat)
+		   netdev_features_t feat, u32 idx)
 {
 	struct gve_rx_slot_page_info *page_info;
 	struct gve_priv *priv = rx->gve;
@@ -282,14 +282,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct sk_buff *skb;
 	int pagecount;
 	u16 len;
-	u32 idx;
 
 	/* drop this packet */
 	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR))
 		return true;
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
-	idx = rx->data.cnt & rx->data.mask;
 	page_info = &rx->data.page_info[idx];
 
 	/* gvnic can only receive into registered segments. If the buffer
@@ -340,8 +338,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	if (!skb)
 		return true;
 
-	rx->data.cnt++;
-
 	if (likely(feat & NETIF_F_RXCSUM)) {
 		/* NIC passes up the partial sum */
 		if (rx_desc->csum)
@@ -370,7 +366,7 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
 	__be16 flags_seq;
 	u32 next_idx;
 
-	next_idx = rx->desc.cnt & rx->desc.mask;
+	next_idx = rx->cnt & rx->mask;
 	desc = rx->desc.desc_ring + next_idx;
 
 	flags_seq = desc->flags_seq;
@@ -385,8 +381,8 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 {
 	struct gve_priv *priv = rx->gve;
 	struct gve_rx_desc *desc;
-	u32 cnt = rx->desc.cnt;
-	u32 idx = cnt & rx->desc.mask;
+	u32 cnt = rx->cnt;
+	u32 idx = cnt & rx->mask;
 	u32 work_done = 0;
 	u64 bytes = 0;
 
@@ -401,10 +397,10 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   rx->q_num, GVE_SEQNO(desc->flags_seq),
 			   rx->desc.seqno);
 		bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
-		if (!gve_rx(rx, desc, feat))
+		if (!gve_rx(rx, desc, feat, idx))
 			gve_schedule_reset(priv);
 		cnt++;
-		idx = cnt & rx->desc.mask;
+		idx = cnt & rx->mask;
 		desc = rx->desc.desc_ring + idx;
 		rx->desc.seqno = gve_next_seqno(rx->desc.seqno);
 		work_done++;
@@ -417,8 +413,8 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 	rx->rpackets += work_done;
 	rx->rbytes += bytes;
 	u64_stats_update_end(&rx->statss);
-	rx->desc.cnt = cnt;
-	rx->desc.fill_cnt += work_done;
+	rx->cnt = cnt;
+	rx->fill_cnt += work_done;
 
 	/* restock desc ring slots */
 	dma_wmb();	/* Ensure descs are visible before ringing doorbell */
-- 
2.22.0.770.g0f2c4a37fd-goog

