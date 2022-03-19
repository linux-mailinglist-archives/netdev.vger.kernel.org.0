Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF6E4DE840
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 15:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243105AbiCSOGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 10:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCSOG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 10:06:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235351BE0D9
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:05:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n2so9245380plf.4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 07:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8vd6rjFo5MDV4GkLyXevsU20OroNc9yzyYA/hrhY5wA=;
        b=nAdP+XpNZ4htWFV2F+vJ2d/CIx6QtWoGJqyICersoDnrQccHF7oFWID3R5kNAOl9fK
         ghAs2xfzLTWg55rPUMhdSNf5oLiHLMnsPbwkCPsozZ6+ojyZcKdnLm45DAIecE9z3u3A
         ADXYkeTO95jJg8Ba4czhDDt3895k6DNQc9Ks/e3Hu+tl0LgBRIh4Xv6tZ6Eu/KbufBsi
         1UQKZMyMpTvDnKsWXh9Z4j7zAehRb92o4L/r9nUhehaCcs4P5yYRUJ275iSOLxUUXvVp
         bORmWOJ1f4T0EqADuMXJhOEuBXqi94IZztDpWhEZw/NJymNqoW5ShNcSUm0wx9ekR12a
         pmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8vd6rjFo5MDV4GkLyXevsU20OroNc9yzyYA/hrhY5wA=;
        b=r+ueXE88YJCDc5WGc3DHnmxdkI/3iZcMZsJYdGVt8dplmSYrYRbZ3yoQCcZY/3CzD0
         waYXXHs1sjanY3pM5ZarJccyBq7vFxy6dcBczf6RtrrZBScck56wZOAvO8ss5USfH05G
         Os5X15lDl0w/1euCjIbzzWak2PFMjihPWD7CfPT04wqk1EiZxk0r9r3jbB1CzTjnioED
         EJ+yqEDyXurqadPkytdAiPtp3c7OvsUM0zu4QSlPSn8bZY871u5wMaLBfy0IsjxnYc4T
         QSLppXUsyCiaSb6AXrRxTqacB8WIrkc5UmaOu+KU4SwnXdUnTogVQHgzip+/rX6joxsA
         bCgQ==
X-Gm-Message-State: AOAM531tTRloPF8CEJcFssROTFMpdDZFehtmUkwZWmucZIyMLsF6kya7
        xyhTvYIEFDArW2i6JhXW/z8=
X-Google-Smtp-Source: ABdhPJxTa6mDyvkz5v1X25j8lM54QbVEVHIORHIET2rtjYbVeyty1tSBmoTmWNU8gVxjdINedwwuuA==
X-Received: by 2002:a17:90b:38c9:b0:1bf:8668:9399 with SMTP id nn9-20020a17090b38c900b001bf86689399mr26770350pjb.87.1647698704436;
        Sat, 19 Mar 2022 07:05:04 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm10168438pgh.94.2022.03.19.07.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 07:05:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        irusskikh@marvell.com, epomozov@marvell.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 2/3] net: atlantic: Implement xdp data plane
Date:   Sat, 19 Mar 2022 14:04:42 +0000
Message-Id: <20220319140443.6645-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220319140443.6645-1-ap420073@gmail.com>
References: <20220319140443.6645-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It supports XDP_PASS, XDP_DROP and multi buffer.

From now on aq_nic_map_skb() supports xdp_frame to send packet.
So, TX path of both skb and xdp_frame can use aq_nic_map_skb().
aq_nic_xmit() is used to send packet with skb and internally it
calls aq_nic_map_skb(). aq_nic_xmit_xdpf() is used to send packet with
xdp_frame and internally it calls aq_nic_map_skb().

AQC chip supports 32 multi-queues and 8 vectors(irq).
there are two option
1. under 8 cores and 4 tx queues per core.
2. under 4 cores and 8 tx queues per core.

Like ixgbe, these tx queues can be used only for XDP_TX, XDP_REDIRECT
queue. If so, no tx_lock is needed.
But this patchset doesn't use this strategy because getting hardware tx
queue index cost is too high.
So, tx_lock is used in the aq_nic_xmit_xdpf().

single-core, single queue, 40% cpu utilization.

  30.75%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
  10.35%  [kernel]                  [k] aq_hw_read_reg <---------- here
   4.38%  [kernel]                  [k] get_page_from_freelist

single-core, 8 queues, 100% cpu utilization, half PPS.

  45.56%  [kernel]                  [k] aq_hw_read_reg <---------- here
  17.58%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
   4.72%  [kernel]                  [k] hw_atl_b0_hw_ring_rx_receive

The new function __aq_ring_xdp_clean() is a xdp rx handler and this is
called only when XDP is attached.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

V2:
 - Do not use inline in C file

 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 126 +++++--
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 329 +++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   6 +
 6 files changed, 428 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a418238f6309..b33979bdfde0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -97,6 +97,14 @@ static const char * const aq_ethtool_queue_rx_stat_names[] = {
 	"%sQueue[%d] AllocFails",
 	"%sQueue[%d] SkbAllocFails",
 	"%sQueue[%d] Polls",
+	"%sQueue[%d] PageFlips",
+	"%sQueue[%d] PageReuses",
+	"%sQueue[%d] XdpAbort",
+	"%sQueue[%d] XdpDrop",
+	"%sQueue[%d] XdpPass",
+	"%sQueue[%d] XdpTx",
+	"%sQueue[%d] XdpInvalid",
+	"%sQueue[%d] XdpRedirect",
 };
 
 static const char * const aq_ethtool_queue_tx_stat_names[] = {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 33f1a1377588..c79967370af3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -570,29 +570,50 @@ int aq_nic_start(struct aq_nic_s *self)
 }
 
 unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
-			    struct aq_ring_s *ring)
+			    struct xdp_frame *xdpf, struct aq_ring_s *ring)
 {
-	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
 	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
 	struct device *dev = aq_nic_get_dev(self);
 	struct aq_ring_buff_s *first = NULL;
-	u8 ipver = ip_hdr(skb)->version;
 	struct aq_ring_buff_s *dx_buff;
+	struct skb_shared_info *sinfo;
 	bool need_context_tag = false;
 	unsigned int frag_count = 0U;
+	unsigned int nr_frags = 0;
 	unsigned int ret = 0U;
 	unsigned int dx;
+	void *data_ptr;
 	u8 l4proto = 0;
+	u16 total_len;
+	u8 ipver;
+
+	dx = ring->sw_tail;
+	dx_buff = &ring->buff_ring[dx];
+	dx_buff->flags = 0U;
+
+	if (xdpf) {
+		sinfo = xdp_get_shared_info_from_frame(xdpf);
+		total_len = xdpf->len;
+		dx_buff->len = total_len;
+		data_ptr = xdpf->data;
+		if (xdp_frame_has_frags(xdpf)) {
+			nr_frags = sinfo->nr_frags;
+			total_len += sinfo->xdp_frags_size;
+		}
+		goto start_xdp;
+	} else {
+		sinfo = skb_shinfo(skb);
+		ipver = ip_hdr(skb)->version;
+		nr_frags = sinfo->nr_frags;
+		total_len = skb->len;
+		data_ptr = skb->data;
+	}
 
 	if (ipver == 4)
 		l4proto = ip_hdr(skb)->protocol;
 	else if (ipver == 6)
 		l4proto = ipv6_hdr(skb)->nexthdr;
 
-	dx = ring->sw_tail;
-	dx_buff = &ring->buff_ring[dx];
-	dx_buff->flags = 0U;
-
 	if (unlikely(skb_is_gso(skb))) {
 		dx_buff->mss = skb_shinfo(skb)->gso_size;
 		if (l4proto == IPPROTO_TCP) {
@@ -630,9 +651,16 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 		++ret;
 	}
 
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		dx_buff->is_ip_cso = (htons(ETH_P_IP) == skb->protocol);
+		dx_buff->is_tcp_cso = (l4proto == IPPROTO_TCP);
+		dx_buff->is_udp_cso = (l4proto == IPPROTO_UDP);
+	}
+
 	dx_buff->len = skb_headlen(skb);
+start_xdp:
 	dx_buff->pa = dma_map_single(dev,
-				     skb->data,
+				     data_ptr,
 				     dx_buff->len,
 				     DMA_TO_DEVICE);
 
@@ -642,25 +670,17 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	}
 
 	first = dx_buff;
-	dx_buff->len_pkt = skb->len;
+	dx_buff->len_pkt = total_len;
 	dx_buff->is_sop = 1U;
 	dx_buff->is_mapped = 1U;
 	++ret;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		dx_buff->is_ip_cso = (htons(ETH_P_IP) == skb->protocol);
-		dx_buff->is_tcp_cso = (l4proto == IPPROTO_TCP);
-		dx_buff->is_udp_cso = (l4proto == IPPROTO_UDP);
-	}
-
 	for (; nr_frags--; ++frag_count) {
-		unsigned int frag_len = 0U;
+		skb_frag_t *frag = &sinfo->frags[frag_count];
+		unsigned int frag_len = skb_frag_size(frag);
 		unsigned int buff_offset = 0U;
 		unsigned int buff_size = 0U;
 		dma_addr_t frag_pa;
-		skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_count];
-
-		frag_len = skb_frag_size(frag);
 
 		while (frag_len) {
 			if (frag_len > AQ_CFG_TX_FRAME_MAX)
@@ -697,6 +717,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	first->eop_index = dx;
 	dx_buff->is_eop = 1U;
 	dx_buff->skb = skb;
+	dx_buff->xdpf = xdpf;
 	goto exit;
 
 mapping_error:
@@ -725,6 +746,54 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	return ret;
 }
 
+static int __aq_nic_xmit(struct aq_nic_s *aq_nic, struct aq_ring_s *tx_ring,
+			 struct sk_buff *skb, struct xdp_frame *xdpf,
+			 unsigned int frags)
+{
+	u16 queue_index = AQ_NIC_RING2QMAP(aq_nic, tx_ring->idx);
+	int err = NETDEV_TX_BUSY;
+
+	aq_ring_update_queue_state(tx_ring);
+
+	/* Above status update may stop the queue. Check this. */
+	if (__netif_subqueue_stopped(aq_nic_get_ndev(aq_nic), queue_index))
+		return err;
+
+	frags = aq_nic_map_skb(aq_nic, skb, xdpf, tx_ring);
+	if (likely(frags))
+		err = aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw, tx_ring,
+							 frags);
+
+	return err;
+}
+
+int aq_nic_xmit_xdpf(struct aq_nic_s *aq_nic, struct aq_ring_s *tx_ring,
+		     struct xdp_frame *xdpf)
+{
+	struct net_device *ndev = aq_nic_get_ndev(aq_nic);
+	struct skb_shared_info *sinfo;
+	int cpu = smp_processor_id();
+	int err = NETDEV_TX_BUSY;
+	struct netdev_queue *nq;
+	unsigned int frags = 1;
+
+	if (xdp_frame_has_frags(xdpf)) {
+		sinfo = xdp_get_shared_info_from_frame(xdpf);
+		frags += sinfo->nr_frags;
+	}
+
+	if (frags > AQ_CFG_SKB_FRAGS_MAX)
+		return err;
+
+	nq = netdev_get_tx_queue(ndev, tx_ring->idx);
+	__netif_tx_lock(nq, cpu);
+	err = __aq_nic_xmit(aq_nic, tx_ring, NULL, xdpf, frags);
+	txq_trans_cond_update(nq);
+	__netif_tx_unlock(nq);
+
+	return err;
+}
+
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 {
 	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
@@ -743,29 +812,12 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 		goto err_exit;
 	}
 
-	aq_ring_update_queue_state(ring);
-
 	if (cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
 		err = NETDEV_TX_BUSY;
 		goto err_exit;
 	}
 
-	/* Above status update may stop the queue. Check this. */
-	if (__netif_subqueue_stopped(self->ndev,
-				     AQ_NIC_RING2QMAP(self, ring->idx))) {
-		err = NETDEV_TX_BUSY;
-		goto err_exit;
-	}
-
-	frags = aq_nic_map_skb(self, skb, ring);
-
-	if (likely(frags)) {
-		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
-						       ring, frags);
-	} else {
-		err = NETDEV_TX_BUSY;
-	}
-
+	err = __aq_nic_xmit(self, ring, skb, NULL, frags);
 err_exit:
 	return err;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 47123baabd5e..a4c314f31c3a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -179,7 +179,9 @@ int aq_nic_ndev_register(struct aq_nic_s *self);
 void aq_nic_ndev_free(struct aq_nic_s *self);
 int aq_nic_start(struct aq_nic_s *self);
 unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
-			    struct aq_ring_s *ring);
+			    struct xdp_frame *xdpf, struct aq_ring_s *ring);
+int aq_nic_xmit_xdpf(struct aq_nic_s *aq_nic, struct aq_ring_s *tx_ring,
+		     struct xdp_frame *xdpf);
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 06de19f63287..24e50c89f7cf 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -778,7 +778,7 @@ int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb)
 	skb_tx_timestamp(skb);
 
 	spin_lock_irqsave(&aq_nic->aq_ptp->ptp_ring_lock, irq_flags);
-	frags = aq_nic_map_skb(aq_nic, skb, ring);
+	frags = aq_nic_map_skb(aq_nic, skb, NULL, ring);
 
 	if (likely(frags)) {
 		err = aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index b261283641a7..85c3b7a9f387 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -31,6 +31,39 @@ static inline void aq_free_rxpage(struct aq_rxpage *rxpage, struct device *dev)
 	rxpage->page = NULL;
 }
 
+static void aq_unset_rxpage_xdp(struct aq_ring_s *rx_ring,
+				struct aq_ring_buff_s *buff,
+				struct device *dev,
+				struct xdp_buff *xdp)
+{
+	struct aq_ring_buff_s *nbuff = buff;
+	struct skb_shared_info *sinfo;
+	unsigned int next = 0;
+	int i;
+
+	if (xdp_buff_has_frags(xdp)) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+
+		for (i = 0; i < sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+			struct page *page;
+
+			page = skb_frag_page(frag);
+
+			dma_unmap_page(dev, page->dma_addr, skb_frag_size(frag),
+				       DMA_FROM_DEVICE);
+		}
+
+		do {
+			next = nbuff->next;
+			nbuff = &rx_ring->buff_ring[next];
+			nbuff->rxdata.page = NULL;
+		} while (!nbuff->is_eop);
+	}
+	dma_unmap_page(dev, buff->rxdata.daddr, PAGE_SIZE, DMA_FROM_DEVICE);
+	buff->rxdata.page = NULL;
+}
+
 static int aq_get_rxpage(struct aq_rxpage *rxpage, struct aq_ring_s *rx_ring)
 {
 	struct device *dev = aq_nic_get_dev(rx_ring->aq_nic);
@@ -293,6 +326,7 @@ void aq_ring_queue_stop(struct aq_ring_s *ring)
 bool aq_ring_tx_clean(struct aq_ring_s *self)
 {
 	struct device *dev = aq_nic_get_dev(self->aq_nic);
+	struct skb_shared_info *sinfo;
 	unsigned int budget;
 
 	for (budget = AQ_CFG_TX_CLEAN_BUDGET;
@@ -316,15 +350,33 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 			}
 		}
 
-		if (unlikely(buff->is_eop && buff->skb)) {
+		if (likely(!buff->is_eop))
+			goto out;
+
+		if (buff->skb) {
 			u64_stats_update_begin(&self->stats.tx.syncp);
 			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
 			u64_stats_update_end(&self->stats.tx.syncp);
-
 			dev_kfree_skb_any(buff->skb);
-			buff->skb = NULL;
+		} else if (buff->xdpf) {
+			u64_stats_update_begin(&self->stats.tx.syncp);
+			++self->stats.tx.packets;
+			self->stats.tx.bytes += buff->xdpf->len;
+			u64_stats_update_end(&self->stats.tx.syncp);
+			if (xdp_frame_has_frags(buff->xdpf)) {
+				sinfo = xdp_get_shared_info_from_frame(buff->xdpf);
+				u64_stats_update_begin(&self->stats.rx.syncp);
+				self->stats.tx.bytes += sinfo->xdp_frags_size;
+				u64_stats_update_end(&self->stats.rx.syncp);
+			}
+
+			xdp_return_frame_rx_napi(buff->xdpf);
 		}
+
+out:
+		buff->skb = NULL;
+		buff->xdpf = NULL;
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
 		self->sw_head = aq_ring_next_dx(self, self->sw_head);
@@ -357,11 +409,130 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 		__skb_incr_checksum_unnecessary(skb);
 }
 
-#define AQ_SKB_ALIGN SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
-int aq_ring_rx_clean(struct aq_ring_s *self,
-		     struct napi_struct *napi,
-		     int *work_done,
-		     int budget)
+static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
+				       struct xdp_buff *xdp,
+				       struct aq_ring_s *rx_ring,
+				       struct aq_ring_buff_s *buff)
+{
+	struct skb_shared_info *sinfo;
+	int result = NETDEV_TX_BUSY;
+	struct aq_ring_s *tx_ring;
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	struct sk_buff *skb;
+	u32 act;
+
+	u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+	++rx_ring->stats.rx.packets;
+	rx_ring->stats.rx.bytes += buff->len;
+	if (xdp_buff_has_frags(xdp)) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		rx_ring->stats.rx.bytes += sinfo->xdp_frags_size;
+	}
+	u64_stats_update_end(&rx_ring->stats.rx.syncp);
+
+	prog = READ_ONCE(rx_ring->xdp_prog);
+	if (!prog)
+		goto pass;
+
+	prefetchw(xdp->data_hard_start); /* xdp_frame write */
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+pass:
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf))
+			goto out_aborted;
+		skb = xdp_build_skb_from_frame(xdpf, aq_nic->ndev);
+		if (!skb)
+			goto out_aborted;
+		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+		++rx_ring->stats.rx.xdp_pass;
+		u64_stats_update_end(&rx_ring->stats.rx.syncp);
+		aq_unset_rxpage_xdp(rx_ring, buff, &aq_nic->ndev->dev, xdp);
+		return skb;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf))
+			goto out_aborted;
+		tx_ring = aq_nic->aq_ring_tx[rx_ring->idx];
+		result = aq_nic_xmit_xdpf(aq_nic, tx_ring, xdpf);
+		if (result == NETDEV_TX_BUSY)
+			goto out_aborted;
+		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+		++rx_ring->stats.rx.xdp_tx;
+		u64_stats_update_end(&rx_ring->stats.rx.syncp);
+		aq_unset_rxpage_xdp(rx_ring, buff, &aq_nic->ndev->dev, xdp);
+		break;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(aq_nic->ndev, xdp, prog) < 0)
+			goto out_aborted;
+		xdp_do_flush();
+		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+		++rx_ring->stats.rx.xdp_redirect;
+		u64_stats_update_end(&rx_ring->stats.rx.syncp);
+		aq_unset_rxpage_xdp(rx_ring, buff, &aq_nic->ndev->dev, xdp);
+		break;
+	default:
+		fallthrough;
+	case XDP_ABORTED:
+out_aborted:
+		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+		++rx_ring->stats.rx.xdp_aborted;
+		u64_stats_update_end(&rx_ring->stats.rx.syncp);
+		trace_xdp_exception(aq_nic->ndev, prog, act);
+		bpf_warn_invalid_xdp_action(aq_nic->ndev, prog, act);
+		break;
+	case XDP_DROP:
+		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+		++rx_ring->stats.rx.xdp_drop;
+		u64_stats_update_end(&rx_ring->stats.rx.syncp);
+		break;
+	}
+
+	return ERR_PTR(-result);
+}
+
+static void aq_add_rx_fragment(struct device *dev,
+			       struct aq_ring_s *ring,
+			       struct aq_ring_buff_s *buff,
+			       struct xdp_buff *xdp)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	struct aq_ring_buff_s *buff_ = buff;
+
+	memset(sinfo, 0, sizeof(*sinfo));
+	do {
+		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags++];
+
+		buff_ = &ring->buff_ring[buff_->next];
+		dma_sync_single_range_for_cpu(dev,
+					      buff_->rxdata.daddr,
+					      buff_->rxdata.pg_off,
+					      buff_->len,
+					      DMA_FROM_DEVICE);
+		skb_frag_off_set(frag, buff_->rxdata.pg_off);
+		skb_frag_size_set(frag, buff_->len);
+		sinfo->xdp_frags_size += buff_->len;
+		__skb_frag_set_page(frag, buff_->rxdata.page);
+
+		buff_->is_cleaned = 1;
+
+		buff->is_ip_cso &= buff_->is_ip_cso;
+		buff->is_udp_cso &= buff_->is_udp_cso;
+		buff->is_tcp_cso &= buff_->is_tcp_cso;
+		buff->is_cso_err |= buff_->is_cso_err;
+
+		if (page_is_pfmemalloc(buff_->rxdata.page))
+			xdp_buff_set_frag_pfmemalloc(xdp);
+	} while (!buff_->is_eop);
+
+	xdp_buff_set_frags_flag(xdp);
+}
+
+static int __aq_ring_rx_clean(struct aq_ring_s *self, struct napi_struct *napi,
+			      int *work_done, int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
 	bool is_rsc_completed = true;
@@ -528,6 +699,140 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 	return err;
 }
 
+static int __aq_ring_xdp_clean(struct aq_ring_s *rx_ring,
+			       struct napi_struct *napi, int *work_done,
+			       int budget)
+{
+	struct aq_nic_s *aq_nic = rx_ring->aq_nic;
+	bool is_rsc_completed = true;
+	struct device *dev;
+	int err = 0;
+
+	dev = aq_nic_get_dev(aq_nic);
+
+	for (; (rx_ring->sw_head != rx_ring->hw_head) && budget;
+		rx_ring->sw_head = aq_ring_next_dx(rx_ring, rx_ring->sw_head),
+		--budget, ++(*work_done)) {
+		struct aq_ring_buff_s *buff = &rx_ring->buff_ring[rx_ring->sw_head];
+		bool is_ptp_ring = aq_ptp_ring(rx_ring->aq_nic, rx_ring);
+		struct aq_ring_buff_s *buff_ = NULL;
+		struct sk_buff *skb = NULL;
+		unsigned int next_ = 0U;
+		struct xdp_buff xdp;
+		void *hard_start;
+
+		if (buff->is_cleaned)
+			continue;
+
+		if (!buff->is_eop) {
+			buff_ = buff;
+			do {
+				if (buff_->next >= rx_ring->size) {
+					err = -EIO;
+					goto err_exit;
+				}
+				next_ = buff_->next;
+				buff_ = &rx_ring->buff_ring[next_];
+				is_rsc_completed =
+					aq_ring_dx_in_range(rx_ring->sw_head,
+							    next_,
+							    rx_ring->hw_head);
+
+				if (unlikely(!is_rsc_completed))
+					break;
+
+				buff->is_error |= buff_->is_error;
+				buff->is_cso_err |= buff_->is_cso_err;
+			} while (!buff_->is_eop);
+
+			if (!is_rsc_completed) {
+				err = 0;
+				goto err_exit;
+			}
+			if (buff->is_error ||
+			    (buff->is_lro && buff->is_cso_err)) {
+				buff_ = buff;
+				do {
+					if (buff_->next >= rx_ring->size) {
+						err = -EIO;
+						goto err_exit;
+					}
+					next_ = buff_->next;
+					buff_ = &rx_ring->buff_ring[next_];
+
+					buff_->is_cleaned = true;
+				} while (!buff_->is_eop);
+
+				u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+				++rx_ring->stats.rx.errors;
+				u64_stats_update_end(&rx_ring->stats.rx.syncp);
+				continue;
+			}
+		}
+
+		if (buff->is_error) {
+			u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+			++rx_ring->stats.rx.errors;
+			u64_stats_update_end(&rx_ring->stats.rx.syncp);
+			continue;
+		}
+
+		dma_sync_single_range_for_cpu(dev,
+					      buff->rxdata.daddr,
+					      buff->rxdata.pg_off,
+					      buff->len, DMA_FROM_DEVICE);
+		hard_start = page_address(buff->rxdata.page);
+
+		if (is_ptp_ring)
+			buff->len -=
+				aq_ptp_extract_ts(rx_ring->aq_nic, skb,
+						  aq_buf_vaddr(&buff->rxdata),
+						  buff->len);
+
+		/* page_order is always 0 if xdp is enabled */
+		xdp_init_buff(&xdp, PAGE_SIZE, &rx_ring->xdp_rxq);
+		xdp_prepare_buff(&xdp, hard_start, rx_ring->page_offset,
+				 buff->len, true);
+		if (!buff->is_eop)
+			aq_add_rx_fragment(dev, rx_ring, buff, &xdp);
+
+		skb = aq_xdp_run_prog(aq_nic, &xdp, rx_ring, buff);
+		if (IS_ERR(skb) || !skb)
+			continue;
+
+		if (buff->is_vlan)
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       buff->vlan_rx_tag);
+
+		aq_rx_checksum(rx_ring, buff, skb);
+
+		skb_set_hash(skb, buff->rss_hash,
+			     buff->is_hash_l4 ? PKT_HASH_TYPE_L4 :
+			     PKT_HASH_TYPE_NONE);
+		/* Send all PTP traffic to 0 queue */
+		skb_record_rx_queue(skb,
+				    is_ptp_ring ? 0
+						: AQ_NIC_RING2QMAP(rx_ring->aq_nic,
+								   rx_ring->idx));
+
+		napi_gro_receive(napi, skb);
+	}
+
+err_exit:
+	return err;
+}
+
+int aq_ring_rx_clean(struct aq_ring_s *self,
+		     struct napi_struct *napi,
+		     int *work_done,
+		     int budget)
+{
+	if (static_branch_unlikely(&aq_xdp_locking_key))
+		return __aq_ring_xdp_clean(self, napi, work_done, budget);
+	else
+		return __aq_ring_rx_clean(self, napi, work_done, budget);
+}
+
 void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic)
 {
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
@@ -617,6 +922,14 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 			data[++count] = self->stats.rx.alloc_fails;
 			data[++count] = self->stats.rx.skb_alloc_fails;
 			data[++count] = self->stats.rx.polls;
+			data[++count] = self->stats.rx.pg_flips;
+			data[++count] = self->stats.rx.pg_reuses;
+			data[++count] = self->stats.rx.xdp_aborted;
+			data[++count] = self->stats.rx.xdp_drop;
+			data[++count] = self->stats.rx.xdp_pass;
+			data[++count] = self->stats.rx.xdp_tx;
+			data[++count] = self->stats.rx.xdp_invalid;
+			data[++count] = self->stats.rx.xdp_redirect;
 		} while (u64_stats_fetch_retry_irq(&self->stats.rx.syncp, start));
 	} else {
 		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 168002657629..6a86d9cfac35 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -105,6 +105,12 @@ struct aq_ring_stats_rx_s {
 	u64 pg_losts;
 	u64 pg_flips;
 	u64 pg_reuses;
+	u64 xdp_aborted;
+	u64 xdp_drop;
+	u64 xdp_pass;
+	u64 xdp_tx;
+	u64 xdp_invalid;
+	u64 xdp_redirect;
 };
 
 struct aq_ring_stats_tx_s {
-- 
2.17.1

