Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70E5E2784
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391968AbfJXAt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45164 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407813AbfJXAtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id x28so511124pfi.12
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mDi1Kyt0PaCDDUWz2tL2DeC9lf1lGs1wka753n82eAM=;
        b=v9JEatMINrne/8TmmQ3mki7VHzkgA0dEDm6fE7t0M9l//09DCeR2huRbLKAzQKIRfs
         GZ/ZNFfJDQHBadONv37ZUX0u/tWZR70N2kSbfp0E3r0mDLTMhqHAhgf6avp5/bgo4sMj
         GN5934QPg6ygJRIbBUIsF6zHtQePqzjaOofJmMMNsi3r8H5ILBWNtYHokI9pfwsJyOZB
         aXqLA8aE+2MBZUEmOFks7sheZskOeV2YX9YTNkqoOj3O2M42Et49GKNoP56pzMmGzepl
         P3YfzUY64hQEKUWxjzwaqq3v9iJvNZxR27l6d+1/WE0WUE+zO4ZPzCPQ382T1qqgE80u
         K1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mDi1Kyt0PaCDDUWz2tL2DeC9lf1lGs1wka753n82eAM=;
        b=Lp28g+lBrb4YVAh9uIbAQ3iIwIe66pyJwbRj6VuYtv4/l7f2DOeJLawDvMCK9Ng1Mw
         hLI9Ovus5XeVCXLSSuBx06EXszqTYTv6PmwM0uVWFMZtlgKgN/MEuVSoJD4zHq7VD4H7
         PZXuw4z8sa7sMPWY/E+ec6pX55PgWnhwrhnbF58KI29yAM+Xv9aLz2rwl6M5BSU1Q1k/
         Luyz7egGx0X7JbMhvsYmBiT2F4pEKY9Sp8HT3OtZDQA3lOFnLwPrLJjHyap8uhlwRN4n
         P5cNfvN2Ork0yMNooRvZXUh+KYzTqJg1tjJ55DEfYYjrgDQC8IlXPmvmd6NXaRkl9SZo
         Y4Bg==
X-Gm-Message-State: APjAAAVGabt/M3KLPIMVS6Cv2Iz77xugxaltJFTOLVXbGJKaX/gNwzLG
        AUW07EEQxshZVzjzNuncFmbMo/qgRqsxNw==
X-Google-Smtp-Source: APXvYqwfVvMS5VW8CAGtAlRsqWG3j+lRB2TBubldnNzUb8Oe6G8tU+Pajvy2gXaHjXuID7jrEvUjQA==
X-Received: by 2002:a63:3108:: with SMTP id x8mr13228612pgx.339.1571878160251;
        Wed, 23 Oct 2019 17:49:20 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:19 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/6] ionic: implement support for rx sgl
Date:   Wed, 23 Oct 2019 17:48:59 -0700
Message-Id: <20191024004900.6561-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even out Rx performance across MTU sizes by changing from full
skb allocations to page-based frag allocations.  The device
supports a form of scatter-gather in the Rx path, so we can
set up a number of pages for each descriptor, all of which are
easier to alloc and pass around than the standard kzalloc'd
buffer.  An skb is wrapped around the pages while processing
the received packets, and pages are recycled as needed, or
left alone if they weren't used in the Rx.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   9 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 292 +++++++++++++-----
 3 files changed, 224 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 78691c1ba20b..4665c5dc5324 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -155,12 +155,19 @@ typedef void (*ionic_desc_cb)(struct ionic_queue *q,
 			      struct ionic_desc_info *desc_info,
 			      struct ionic_cq_info *cq_info, void *cb_arg);
 
+struct ionic_page_info {
+	struct page *page;
+	dma_addr_t dma_addr;
+};
+
 struct ionic_desc_info {
 	void *desc;
 	void *sg_desc;
 	struct ionic_desc_info *next;
 	unsigned int index;
 	unsigned int left;
+	unsigned int npages;
+	struct ionic_page_info pages[IONIC_RX_MAX_SG_ELEMS + 1];
 	ionic_desc_cb cb;
 	void *cb_arg;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index cf64dea53f82..a9bb12ce5f13 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -622,12 +622,14 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
 			.index = cpu_to_le32(q->index),
-			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ),
+			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+					     IONIC_QINIT_F_SG),
 			.intr_index = cpu_to_le16(cq->bound_intr->index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
 			.cq_ring_base = cpu_to_le64(cq->base_pa),
+			.sg_ring_base = cpu_to_le64(q->sg_base_pa),
 		},
 	};
 	int err;
@@ -1460,13 +1462,14 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
 	}
 
-	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_INTR;
+	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 				      lif->nrxq_descs,
 				      sizeof(struct ionic_rxq_desc),
 				      sizeof(struct ionic_rxq_comp),
-				      0, lif->kern_pid, &lif->rxqcqs[i].qcq);
+				      sizeof(struct ionic_rxq_sg_desc),
+				      lif->kern_pid, &lif->rxqcqs[i].qcq);
 		if (err)
 			goto err_out;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index ab6663d94f42..0aeac3157160 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -34,52 +34,110 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
 }
 
-static void ionic_rx_recycle(struct ionic_queue *q, struct ionic_desc_info *desc_info,
-			     struct sk_buff *skb)
+static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
+					  unsigned int len, bool frags)
 {
-	struct ionic_rxq_desc *old = desc_info->desc;
-	struct ionic_rxq_desc *new = q->head->desc;
+	struct ionic_lif *lif = q->lif;
+	struct ionic_rx_stats *stats;
+	struct net_device *netdev;
+	struct sk_buff *skb;
+
+	netdev = lif->netdev;
+	stats = q_to_rx_stats(q);
+
+	if (frags)
+		skb = napi_get_frags(&q_to_qcq(q)->napi);
+	else
+		skb = netdev_alloc_skb_ip_align(netdev, len);
 
-	new->addr = old->addr;
-	new->len = old->len;
+	if (unlikely(!skb)) {
+		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
+				     netdev->name, q->name);
+		stats->alloc_err++;
+		return NULL;
+	}
 
-	ionic_rxq_post(q, true, ionic_rx_clean, skb);
+	return skb;
 }
 
-static bool ionic_rx_copybreak(struct ionic_queue *q, struct ionic_desc_info *desc_info,
-			       struct ionic_cq_info *cq_info, struct sk_buff **skb)
+static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
+				      struct ionic_desc_info *desc_info,
+				      struct ionic_cq_info *cq_info)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
-	struct ionic_rxq_desc *desc = desc_info->desc;
-	struct net_device *netdev = q->lif->netdev;
 	struct device *dev = q->lif->ionic->dev;
-	struct sk_buff *new_skb;
-	u16 clen, dlen;
-
-	clen = le16_to_cpu(comp->len);
-	dlen = le16_to_cpu(desc->len);
-	if (clen > q->lif->rx_copybreak) {
-		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
-				 dlen, DMA_FROM_DEVICE);
-		return false;
-	}
+	struct ionic_page_info *page_info;
+	struct sk_buff *skb;
+	unsigned int i;
+	u16 frag_len;
+	u16 len;
 
-	new_skb = netdev_alloc_skb_ip_align(netdev, clen);
-	if (!new_skb) {
-		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
-				 dlen, DMA_FROM_DEVICE);
-		return false;
-	}
+	page_info = &desc_info->pages[0];
+	len = le16_to_cpu(comp->len);
 
-	dma_sync_single_for_cpu(dev, (dma_addr_t)le64_to_cpu(desc->addr),
-				clen, DMA_FROM_DEVICE);
+	prefetch(page_address(page_info->page) + NET_IP_ALIGN);
 
-	memcpy(new_skb->data, (*skb)->data, clen);
+	skb = ionic_rx_skb_alloc(q, len, true);
+	if (unlikely(!skb))
+		return NULL;
 
-	ionic_rx_recycle(q, desc_info, *skb);
-	*skb = new_skb;
+	i = comp->num_sg_elems + 1;
+	do {
+		if (unlikely(!page_info->page)) {
+			struct napi_struct *napi = &q_to_qcq(q)->napi;
 
-	return true;
+			napi->skb = NULL;
+			dev_kfree_skb(skb);
+			return NULL;
+		}
+
+		frag_len = min(len, (u16)PAGE_SIZE);
+		len -= frag_len;
+
+		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
+			       PAGE_SIZE, DMA_FROM_DEVICE);
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				page_info->page, 0, frag_len, PAGE_SIZE);
+		page_info->page = NULL;
+		page_info++;
+		i--;
+	} while (i > 0);
+
+	return skb;
+}
+
+static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
+					  struct ionic_desc_info *desc_info,
+					  struct ionic_cq_info *cq_info)
+{
+	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct device *dev = q->lif->ionic->dev;
+	struct ionic_page_info *page_info;
+	struct sk_buff *skb;
+	u16 len;
+
+	page_info = &desc_info->pages[0];
+	len = le16_to_cpu(comp->len);
+
+	skb = ionic_rx_skb_alloc(q, len, false);
+	if (unlikely(!skb))
+		return NULL;
+
+	if (unlikely(!page_info->page)) {
+		dev_kfree_skb(skb);
+		return NULL;
+	}
+
+	dma_sync_single_for_cpu(dev, dma_unmap_addr(page_info, dma_addr),
+				len, DMA_FROM_DEVICE);
+	skb_copy_to_linear_data(skb, page_address(page_info->page), len);
+	dma_sync_single_for_device(dev, dma_unmap_addr(page_info, dma_addr),
+				   len, DMA_FROM_DEVICE);
+
+	skb_put(skb, len);
+	skb->protocol = eth_type_trans(skb, q->lif->netdev);
+
+	return skb;
 }
 
 static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
@@ -87,35 +145,34 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
 	struct ionic_qcq *qcq = q_to_qcq(q);
-	struct sk_buff *skb = cb_arg;
 	struct ionic_rx_stats *stats;
 	struct net_device *netdev;
+	struct sk_buff *skb;
 
 	stats = q_to_rx_stats(q);
 	netdev = q->lif->netdev;
 
-	if (comp->status) {
-		ionic_rx_recycle(q, desc_info, skb);
+	if (comp->status)
 		return;
-	}
 
-	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state))) {
-		/* no packet processing while resetting */
-		ionic_rx_recycle(q, desc_info, skb);
+	/* no packet processing while resetting */
+	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state)))
 		return;
-	}
 
 	stats->pkts++;
 	stats->bytes += le16_to_cpu(comp->len);
 
-	ionic_rx_copybreak(q, desc_info, cq_info, &skb);
+	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
+		skb = ionic_rx_copybreak(q, desc_info, cq_info);
+	else
+		skb = ionic_rx_frags(q, desc_info, cq_info);
 
-	skb_put(skb, le16_to_cpu(comp->len));
-	skb->protocol = eth_type_trans(skb, netdev);
+	if (unlikely(!skb))
+		return;
 
 	skb_record_rx_queue(skb, q->index);
 
-	if (netdev->features & NETIF_F_RXHASH) {
+	if (likely(netdev->features & NETIF_F_RXHASH)) {
 		switch (comp->pkt_type_color & IONIC_RXQ_COMP_PKT_TYPE_MASK) {
 		case IONIC_PKT_TYPE_IPV4:
 		case IONIC_PKT_TYPE_IPV6:
@@ -132,7 +189,7 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 		}
 	}
 
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (likely(netdev->features & NETIF_F_RXCSUM)) {
 		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC) {
 			skb->ip_summed = CHECKSUM_COMPLETE;
 			skb->csum = (__wsum)le16_to_cpu(comp->csum);
@@ -142,18 +199,21 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 		stats->csum_none++;
 	}
 
-	if ((comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_TCP_BAD) ||
-	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_UDP_BAD) ||
-	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD))
+	if (unlikely((comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_TCP_BAD) ||
+		     (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_UDP_BAD) ||
+		     (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD)))
 		stats->csum_error++;
 
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (likely(netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
 		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       le16_to_cpu(comp->vlan_tci));
 	}
 
-	napi_gro_receive(&qcq->napi, skb);
+	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
+		napi_gro_receive(&qcq->napi, skb);
+	else
+		napi_gro_frags(&qcq->napi);
 }
 
 static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
@@ -213,66 +273,125 @@ void ionic_rx_flush(struct ionic_cq *cq)
 				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
 }
 
-static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q, unsigned int len,
-					  dma_addr_t *dma_addr)
+static struct page *ionic_rx_page_alloc(struct ionic_queue *q,
+					dma_addr_t *dma_addr)
 {
 	struct ionic_lif *lif = q->lif;
 	struct ionic_rx_stats *stats;
 	struct net_device *netdev;
-	struct sk_buff *skb;
 	struct device *dev;
+	struct page *page;
 
 	netdev = lif->netdev;
 	dev = lif->ionic->dev;
 	stats = q_to_rx_stats(q);
-	skb = netdev_alloc_skb_ip_align(netdev, len);
-	if (!skb) {
-		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
-				     netdev->name, q->name);
+	page = alloc_page(GFP_ATOMIC);
+	if (unlikely(!page)) {
+		net_err_ratelimited("%s: Page alloc failed on %s!\n",
+				    netdev->name, q->name);
 		stats->alloc_err++;
 		return NULL;
 	}
 
-	*dma_addr = dma_map_single(dev, skb->data, len, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, *dma_addr)) {
-		dev_kfree_skb(skb);
-		net_warn_ratelimited("%s: DMA single map failed on %s!\n",
-				     netdev->name, q->name);
+	*dma_addr = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, *dma_addr))) {
+		__free_page(page);
+		net_err_ratelimited("%s: DMA single map failed on %s!\n",
+				    netdev->name, q->name);
 		stats->dma_map_err++;
 		return NULL;
 	}
 
-	return skb;
+	return page;
+}
+
+static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
+			       dma_addr_t dma_addr)
+{
+	struct ionic_lif *lif = q->lif;
+	struct net_device *netdev;
+	struct device *dev;
+
+	netdev = lif->netdev;
+	dev = lif->ionic->dev;
+
+	if (unlikely(!page)) {
+		net_err_ratelimited("%s: Trying to free unallocated buffer on %s!\n",
+				    netdev->name, q->name);
+		return;
+	}
+
+	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+
+	__free_page(page);
 }
 
-#define IONIC_RX_RING_DOORBELL_STRIDE		((1 << 2) - 1)
+#define IONIC_RX_RING_DOORBELL_STRIDE		((1 << 5) - 1)
+#define IONIC_RX_RING_HEAD_BUF_SZ		2048
 
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
+	struct ionic_desc_info *desc_info;
+	struct ionic_page_info *page_info;
+	struct ionic_rxq_sg_desc *sg_desc;
+	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_rxq_desc *desc;
-	struct sk_buff *skb;
-	dma_addr_t dma_addr;
+	unsigned int nfrags;
 	bool ring_doorbell;
+	unsigned int i, j;
 	unsigned int len;
-	unsigned int i;
 
 	len = netdev->mtu + ETH_HLEN;
+	nfrags = round_up(len, PAGE_SIZE) / PAGE_SIZE;
 
 	for (i = ionic_q_space_avail(q); i; i--) {
-		skb = ionic_rx_skb_alloc(q, len, &dma_addr);
-		if (!skb)
-			return;
+		desc_info = q->head;
+		desc = desc_info->desc;
+		sg_desc = desc_info->sg_desc;
+		page_info = &desc_info->pages[0];
+
+		if (page_info->page) { /* recycle the buffer */
+			ring_doorbell = ((q->head->index + 1) &
+					IONIC_RX_RING_DOORBELL_STRIDE) == 0;
+			ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, NULL);
+			continue;
+		}
 
-		desc = q->head->desc;
-		desc->addr = cpu_to_le64(dma_addr);
-		desc->len = cpu_to_le16(len);
-		desc->opcode = IONIC_RXQ_DESC_OPCODE_SIMPLE;
+		/* fill main descriptor - pages[0] */
+		desc->opcode = (nfrags > 1) ? IONIC_RXQ_DESC_OPCODE_SG :
+					      IONIC_RXQ_DESC_OPCODE_SIMPLE;
+		desc_info->npages = nfrags;
+		page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
+		if (unlikely(!page_info->page)) {
+			desc->addr = 0;
+			desc->len = 0;
+			return;
+		}
+		desc->addr = cpu_to_le64(page_info->dma_addr);
+		desc->len = cpu_to_le16(PAGE_SIZE);
+		page_info++;
+
+		/* fill sg descriptors - pages[1..n] */
+		for (j = 0; j < nfrags - 1; j++) {
+			if (page_info->page) /* recycle the sg buffer */
+				continue;
+
+			sg_elem = &sg_desc->elems[j];
+			page_info->page = ionic_rx_page_alloc(q, &page_info->dma_addr);
+			if (unlikely(!page_info->page)) {
+				sg_elem->addr = 0;
+				sg_elem->len = 0;
+				return;
+			}
+			sg_elem->addr = cpu_to_le64(page_info->dma_addr);
+			sg_elem->len = cpu_to_le16(PAGE_SIZE);
+			page_info++;
+		}
 
 		ring_doorbell = ((q->head->index + 1) &
 				IONIC_RX_RING_DOORBELL_STRIDE) == 0;
-
-		ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, skb);
+		ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, NULL);
 	}
 }
 
@@ -283,15 +402,26 @@ static void ionic_rx_fill_cb(void *arg)
 
 void ionic_rx_empty(struct ionic_queue *q)
 {
-	struct device *dev = q->lif->ionic->dev;
+	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_desc_info *cur;
 	struct ionic_rxq_desc *desc;
+	unsigned int i;
 
 	for (cur = q->tail; cur != q->head; cur = cur->next) {
 		desc = cur->desc;
-		dma_unmap_single(dev, le64_to_cpu(desc->addr),
-				 le16_to_cpu(desc->len), DMA_FROM_DEVICE);
-		dev_kfree_skb(cur->cb_arg);
+		desc->addr = 0;
+		desc->len = 0;
+
+		sg_desc = cur->sg_desc;
+		for (i = 0; i < cur->npages; i++) {
+			if (likely(cur->pages[i].page)) {
+				ionic_rx_page_free(q, cur->pages[i].page,
+						   cur->pages[i].dma_addr);
+				cur->pages[i].page = NULL;
+				cur->pages[i].dma_addr = 0;
+			}
+		}
+
 		cur->cb_arg = NULL;
 	}
 }
-- 
2.17.1

