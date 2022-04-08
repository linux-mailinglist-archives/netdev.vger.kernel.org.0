Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CD04F9B36
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbiDHRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiDHRCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:02:18 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730FF320366;
        Fri,  8 Apr 2022 10:00:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k13so3191132plk.12;
        Fri, 08 Apr 2022 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MFquQ2nlZU7UD5jppHLKsUElAi2pxVsRDHNjjy9QppE=;
        b=mAqVYurv82jlyvMdRRHGHN7+7Za95erXg2NoSqtQaFAI+7Y2nqZ8Up7Kp5WtTjP6zd
         7F5okvUQTkpvB1bWUlXiwA3QL9ViN0uaArVaA1QGPoeAv+Gwm6fA7P8qAAD2MjrX8Gv7
         kgfhtHbLlFn52LyUoyY8Aujt1f4z2z+GfDEnAe7Fe8jda1NvlY65KC5j7F4kh8Hw9CX4
         g+ydR4hPJ6jOeXPtZrcBnKn5GlrYPXV4G6gT7lphjMz1U3ei0NWZqkkI3WuXp9LXENA1
         Klafrp2oIJkjI/1ZKOlVekaKNhIMtyANSBKakM3NjYSezvmjabqyQCpTzcIyyK3bDMtf
         WfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MFquQ2nlZU7UD5jppHLKsUElAi2pxVsRDHNjjy9QppE=;
        b=f2KI4UpN+Kk2vCAt8qaOKk2t3ZNzI1IdvqHvaPG5WsDxdNjCvTXiUjCuOBa2E+LHYT
         ljAK+4XfvA2e4gHS06VHyDKhFCSAuZCaeGPfEe1F3Wg+zYXe20oustPTmtDKzpicXge/
         XHsSYqa/Go1FhwuTy5jialGN9CQRYy3H0XdDDIPwSaLYAluhOFHteVT9LVzqwkNoSLBX
         H1HcF64SfEbYvt/MzmRT2zXV1QNVs7J0BTgws6ut0Bd9mmxiMdBLVtutRq3Qa5+vnAjN
         bm5YcdFKiQNSEUzRzbKeA7d3WV5Tu+JHrA5A3Gy1oWZ/hyxnKaHJnlvgM6sjnn1KGpzE
         UxZw==
X-Gm-Message-State: AOAM5304769gyhiOk8Z+14hXorccj0qhBwEgTnNa1TitcUK0GYJdTXWN
        fpXznqtB8L3u3I2jNdvIdWM=
X-Google-Smtp-Source: ABdhPJyNw6yEOWkFkJk/KXLtZNG6g/EZN74fD1oxchmzf736u/QhfZPP5cfT+n55IXXIGFxTABRXAA==
X-Received: by 2002:a17:90b:4b83:b0:1cb:c99:5922 with SMTP id lr3-20020a17090b4b8300b001cb0c995922mr11902846pjb.41.1649437213522;
        Fri, 08 Apr 2022 10:00:13 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78d18000000b0050564584660sm6513479pfe.32.2022.04.08.10.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:00:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v3 2/3] net: atlantic: Implement xdp data plane
Date:   Fri,  8 Apr 2022 16:59:49 +0000
Message-Id: <20220408165950.10515-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220408165950.10515-1-ap420073@gmail.com>
References: <20220408165950.10515-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It supports XDP_PASS, XDP_DROP and multi buffer.

The new function aq_nic_xmit_xdpf() is used to send packet with
xdp_frame and internally it calls aq_nic_map_xdp().

AQC chip supports 32 multi-queues and 8 vectors(irq).
there are two option
1. under 8 cores and 4 tx queues per core.
2. under 4 cores and 8 tx queues per core.

Like ixgbe, these tx queues can be used only for XDP_TX, XDP_REDIRECT
queue. If so, no tx_lock is needed.
But this patchset doesn't use this strategy because getting hardware tx
queue index cost is too high.
So, tx_lock is used in the aq_nic_xmit_xdpf().

single-core, single queue, 80% cpu utilization.

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

v3:
 - Change wrong PPS performance result 40% -> 80% in single
   core(Intel i3-12100)
 - Separate aq_nic_map_xdp() from aq_nic_map_skb()
 - Drop multi buffer packets if single buffer XDP is attached
 - Use xdp_get_{frame/buff}_len()

v2:
 - Do not use inline in C file

 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 137 +++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   2 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 335 +++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   6 +
 5 files changed, 480 insertions(+), 8 deletions(-)

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
index 33f1a1377588..37110d51e7e3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -569,6 +569,104 @@ int aq_nic_start(struct aq_nic_s *self)
 	return err;
 }
 
+static unsigned int aq_nic_map_xdp(struct aq_nic_s *self,
+				   struct xdp_frame *xdpf,
+				   struct aq_ring_s *ring)
+{
+	struct device *dev = aq_nic_get_dev(self);
+	struct aq_ring_buff_s *first = NULL;
+	unsigned int dx = ring->sw_tail;
+	struct aq_ring_buff_s *dx_buff;
+	struct skb_shared_info *sinfo;
+	unsigned int frag_count = 0U;
+	unsigned int nr_frags = 0U;
+	unsigned int ret = 0U;
+	u16 total_len;
+
+	dx_buff = &ring->buff_ring[dx];
+	dx_buff->flags = 0U;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	total_len = xdpf->len;
+	dx_buff->len = total_len;
+	if (xdp_frame_has_frags(xdpf)) {
+		nr_frags = sinfo->nr_frags;
+		total_len += sinfo->xdp_frags_size;
+	}
+	dx_buff->pa = dma_map_single(dev, xdpf->data, dx_buff->len,
+				     DMA_TO_DEVICE);
+
+	if (unlikely(dma_mapping_error(dev, dx_buff->pa)))
+		goto exit;
+
+	first = dx_buff;
+	dx_buff->len_pkt = total_len;
+	dx_buff->is_sop = 1U;
+	dx_buff->is_mapped = 1U;
+	++ret;
+
+	for (; nr_frags--; ++frag_count) {
+		skb_frag_t *frag = &sinfo->frags[frag_count];
+		unsigned int frag_len = skb_frag_size(frag);
+		unsigned int buff_offset = 0U;
+		unsigned int buff_size = 0U;
+		dma_addr_t frag_pa;
+
+		while (frag_len) {
+			if (frag_len > AQ_CFG_TX_FRAME_MAX)
+				buff_size = AQ_CFG_TX_FRAME_MAX;
+			else
+				buff_size = frag_len;
+
+			frag_pa = skb_frag_dma_map(dev, frag, buff_offset,
+						   buff_size, DMA_TO_DEVICE);
+
+			if (unlikely(dma_mapping_error(dev, frag_pa)))
+				goto mapping_error;
+
+			dx = aq_ring_next_dx(ring, dx);
+			dx_buff = &ring->buff_ring[dx];
+
+			dx_buff->flags = 0U;
+			dx_buff->len = buff_size;
+			dx_buff->pa = frag_pa;
+			dx_buff->is_mapped = 1U;
+			dx_buff->eop_index = 0xffffU;
+
+			frag_len -= buff_size;
+			buff_offset += buff_size;
+
+			++ret;
+		}
+	}
+
+	first->eop_index = dx;
+	dx_buff->is_eop = 1U;
+	dx_buff->skb = NULL;
+	dx_buff->xdpf = xdpf;
+	goto exit;
+
+mapping_error:
+	for (dx = ring->sw_tail;
+	     ret > 0;
+	     --ret, dx = aq_ring_next_dx(ring, dx)) {
+		dx_buff = &ring->buff_ring[dx];
+
+		if (!(dx_buff->is_gso_tcp || dx_buff->is_gso_udp) &&
+		    !dx_buff->is_vlan && dx_buff->pa) {
+			if (unlikely(dx_buff->is_sop))
+				dma_unmap_single(dev, dx_buff->pa, dx_buff->len,
+						 DMA_TO_DEVICE);
+			else
+				dma_unmap_page(dev, dx_buff->pa, dx_buff->len,
+					       DMA_TO_DEVICE);
+		}
+	}
+
+exit:
+	return ret;
+}
+
 unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 			    struct aq_ring_s *ring)
 {
@@ -697,6 +795,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	first->eop_index = dx;
 	dx_buff->is_eop = 1U;
 	dx_buff->skb = skb;
+	dx_buff->xdpf = NULL;
 	goto exit;
 
 mapping_error:
@@ -725,6 +824,44 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	return ret;
 }
 
+int aq_nic_xmit_xdpf(struct aq_nic_s *aq_nic, struct aq_ring_s *tx_ring,
+		     struct xdp_frame *xdpf)
+{
+	u16 queue_index = AQ_NIC_RING2QMAP(aq_nic, tx_ring->idx);
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
+
+	aq_ring_update_queue_state(tx_ring);
+
+	/* Above status update may stop the queue. Check this. */
+	if (__netif_subqueue_stopped(aq_nic_get_ndev(aq_nic), queue_index))
+		goto out;
+
+	frags = aq_nic_map_xdp(aq_nic, xdpf, tx_ring);
+	if (likely(frags))
+		err = aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw, tx_ring,
+							 frags);
+out:
+	__netif_tx_unlock(nq);
+
+	return err;
+}
+
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 {
 	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 47123baabd5e..935ba889bd9a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -180,6 +180,8 @@ void aq_nic_ndev_free(struct aq_nic_s *self);
 int aq_nic_start(struct aq_nic_s *self);
 unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 			    struct aq_ring_s *ring);
+int aq_nic_xmit_xdpf(struct aq_nic_s *aq_nic, struct aq_ring_s *tx_ring,
+		     struct xdp_frame *xdpf);
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index b261283641a7..4c3bfb686d5a 100644
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
@@ -316,15 +349,26 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
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
+			self->stats.tx.bytes += xdp_get_frame_len(buff->xdpf);
+			u64_stats_update_end(&self->stats.tx.syncp);
+			xdp_return_frame_rx_napi(buff->xdpf);
 		}
+
+out:
+		buff->skb = NULL;
+		buff->xdpf = NULL;
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
 		self->sw_head = aq_ring_next_dx(self, self->sw_head);
@@ -357,11 +401,136 @@ static void aq_rx_checksum(struct aq_ring_s *self,
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
+	int result = NETDEV_TX_BUSY;
+	struct aq_ring_s *tx_ring;
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	struct sk_buff *skb;
+	u32 act;
+
+	u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+	++rx_ring->stats.rx.packets;
+	rx_ring->stats.rx.bytes += xdp_get_buff_len(xdp);
+	u64_stats_update_end(&rx_ring->stats.rx.syncp);
+
+	prog = READ_ONCE(rx_ring->xdp_prog);
+	if (!prog)
+		goto pass;
+
+	prefetchw(xdp->data_hard_start); /* xdp_frame write */
+
+	/* single buffer XDP program, but packet is multi buffer, aborted */
+	if (xdp_buff_has_frags(xdp) && !prog->aux->xdp_has_frags)
+		goto out_aborted;
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
+static bool aq_add_rx_fragment(struct device *dev,
+			       struct aq_ring_s *ring,
+			       struct aq_ring_buff_s *buff,
+			       struct xdp_buff *xdp)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	struct aq_ring_buff_s *buff_ = buff;
+
+	memset(sinfo, 0, sizeof(*sinfo));
+	do {
+		skb_frag_t *frag;
+
+		if (unlikely(sinfo->nr_frags >= MAX_SKB_FRAGS))
+			return true;
+
+		frag = &sinfo->frags[sinfo->nr_frags++];
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
+
+	} while (!buff_->is_eop);
+
+	xdp_buff_set_frags_flag(xdp);
+
+	return false;
+}
+
+static int __aq_ring_rx_clean(struct aq_ring_s *self, struct napi_struct *napi,
+			      int *work_done, int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
 	bool is_rsc_completed = true;
@@ -528,6 +697,148 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
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
+		if (!buff->is_eop) {
+			if (aq_add_rx_fragment(dev, rx_ring, buff, &xdp)) {
+				u64_stats_update_begin(&rx_ring->stats.rx.syncp);
+				++rx_ring->stats.rx.packets;
+				rx_ring->stats.rx.bytes += xdp_get_buff_len(&xdp);
+				++rx_ring->stats.rx.xdp_aborted;
+				u64_stats_update_end(&rx_ring->stats.rx.syncp);
+				continue;
+			}
+		}
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
@@ -617,6 +928,14 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
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

