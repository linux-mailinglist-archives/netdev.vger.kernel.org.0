Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE13C3F74C1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbhHYMFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbhHYMFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:05:47 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9BCC061757;
        Wed, 25 Aug 2021 05:05:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y23so22845400pgi.7;
        Wed, 25 Aug 2021 05:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QSiBXeq3/LnPdKRh6dpjgFPvUTy6ZP5LQTegDoZrYI=;
        b=p6f55rdw/Sra6W2SJ3m//Tlt8dyIpKuz/alKYmQdJvG80/0EkuuilCD57wrXV1JtJq
         bhucdLhDzrJuO2lIOH32K024VjjnXP04O3/wUzjdUBCfwN57isPWPuFmE9XyEBEAHS5F
         nzW0tTEoFne2w740PgQW8vZuSVxe3VZJn+OnyNyJD8iSmtDAxfbJFGXthVAxugUBjVuu
         SyszLSLh28tPVoAkNLtaSET+mgEMnMTmlT6DgbnaDmKDCWcofLmdscjD+mtELbP5q9Au
         SFMjMbaI3iUaMbb/6j91QcQYkhsEbWhjGjPjVu9m3Awh+fdcJtTnX+y6PVUJxKIe/5vE
         lU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QSiBXeq3/LnPdKRh6dpjgFPvUTy6ZP5LQTegDoZrYI=;
        b=uUzC6UTtqjofUHIYqPRErj2tTuyRxVvypObhY5dz5EA+kJcQSVBusVo0JlYdweE6W9
         OY62OSt7iENiopmFc3VonBmjEy9tdnFv0FO1O6eIDrv6cVOeD4ulkAXvIaemFSkZjHFn
         WmqBJkH1Et4hor0EMhUFnpqWkNvf+oJSkkopdGZ0nYNhPgE/S0QYLqqypfwr7Yiz6Ezz
         WxTZ+u2oYhgLp2G1fdcczbHREHCwkPrXl3jTTSlPVEibTKBp/6qGVw6ZVnX18LQ6F2ud
         7yS2SnK0KL02QxnqkImbTdjTztnpNxUyHepW3PvSppzTQsrvEx7tvlGdwDz9kBqrhTRt
         s9Cg==
X-Gm-Message-State: AOAM531olgoKcYGyQBQO4vvr5aUaQYru1rNK5I09hLiTNGDE9DtjvKXY
        TC+26hADbt7qbwSgJaWWw+c=
X-Google-Smtp-Source: ABdhPJzmb8LykImBmLRhUPGhHuRWPVZG7iudemCexh5Jpdou7SC8UGrZ/X6xuRz1G4TQtzJFW0n7uQ==
X-Received: by 2002:aa7:83d8:0:b0:3ef:990f:5525 with SMTP id j24-20020aa783d8000000b003ef990f5525mr2795407pfn.29.1629893101478;
        Wed, 25 Aug 2021 05:05:01 -0700 (PDT)
Received: from localhost.localdomain ([154.86.159.245])
        by smtp.gmail.com with ESMTPSA id x19sm22202342pfa.104.2021.08.25.05.04.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 05:05:01 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: [PATCH v2] ixgbe: let the xdpdrv work with more than 64 cpus
Date:   Wed, 25 Aug 2021 20:02:41 +0800
Message-Id: <20210825120241.7389-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <CAL+tcoDUhZfy3NTx4TOv3wa1f8SMkNhzNpVS5qyySaVOm6L-qQ@mail.gmail.com>
References: <CAL+tcoDUhZfy3NTx4TOv3wa1f8SMkNhzNpVS5qyySaVOm6L-qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
server is equipped with more than 64 cpus online. So it turns out that
the loading of xdpdrv causes the "NOMEM" failure.

Actually, we can adjust the algorithm and then make it work through
mapping the current cpu to some xdp ring with the protect of @tx_lock.

Considering the performance of xdpdrv mode, I add another limit like ice
driver where the number of cpus should be within the twice of
MAX_XDP_QUEUES.

v2:
- Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
- Add a fallback path. (Maciej)
- Adjust other parts related to xdp ring.

Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
Co-developed-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 11 +++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  6 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 63 ++++++++++++++++++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 15 ++++---
 4 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index a604552..466b2b0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -82,6 +82,8 @@
 #define IXGBE_2K_TOO_SMALL_WITH_PADDING \
 ((NET_SKB_PAD + IXGBE_RXBUFFER_1536) > SKB_WITH_OVERHEAD(IXGBE_RXBUFFER_2K))
 
+DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
+
 static inline int ixgbe_compute_pad(int rx_buf_len)
 {
 	int page_size, pad_size;
@@ -351,6 +353,7 @@ struct ixgbe_ring {
 	};
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t tx_lock;	/* used in XDP mode */
 	struct xsk_buff_pool *xsk_pool;
 	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
 	u16 rx_buf_len;
@@ -772,6 +775,14 @@ struct ixgbe_adapter {
 #endif /* CONFIG_IXGBE_IPSEC */
 };
 
+static inline int ixgbe_determine_xdp_cpu(int cpu)
+{
+	if (static_key_enabled(&ixgbe_xdp_locking_key))
+		return cpu % MAX_XDP_QUEUES;
+	else
+		return cpu;
+}
+
 static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
 {
 	switch (adapter->hw.mac.type) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 0218f6c..d6b58e1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
 
 static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
 {
-	return adapter->xdp_prog ? nr_cpu_ids : 0;
+	return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;
 }
 
 #define IXGBE_RSS_64Q_MASK	0x3F
@@ -947,6 +947,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->count = adapter->tx_ring_count;
 		ring->queue_index = xdp_idx;
 		set_ring_xdp(ring);
+		spin_lock_init(&ring->tx_lock);
 
 		/* assign ring to adapter */
 		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
@@ -1032,6 +1033,9 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 	adapter->q_vector[v_idx] = NULL;
 	__netif_napi_del(&q_vector->napi);
 
+	if (static_key_enabled(&ixgbe_xdp_locking_key))
+		static_branch_dec(&ixgbe_xdp_locking_key);
+
 	/*
 	 * after a call to __netif_napi_del() napi may still be used and
 	 * ixgbe_get_stats64() might access the rings on this vector,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 14aea40..4c94577 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -165,6 +165,9 @@ static int ixgbe_notify_dca(struct notifier_block *, unsigned long event,
 MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
 MODULE_LICENSE("GPL v2");
 
+DEFINE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
+EXPORT_SYMBOL(ixgbe_xdp_locking_key);
+
 static struct workqueue_struct *ixgbe_wq;
 
 static bool ixgbe_check_cfg_remove(struct ixgbe_hw *hw, struct pci_dev *pdev);
@@ -2422,13 +2425,14 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		xdp_do_flush_map();
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
-		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
+		int cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
+		struct ixgbe_ring *ring = adapter->xdp_ring[cpu];
 
-		/* Force memory writes to complete before letting h/w
-		 * know there are new descriptors to fetch.
-		 */
-		wmb();
-		writel(ring->next_to_use, ring->tail);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_lock(&ring->tx_lock);
+		ixgbe_xdp_ring_update_tail(ring);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_unlock(&ring->tx_lock);
 	}
 
 	u64_stats_update_begin(&rx_ring->syncp);
@@ -8539,21 +8543,33 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
 			struct xdp_frame *xdpf)
 {
-	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
+	struct ixgbe_ring *ring;
 	struct ixgbe_tx_buffer *tx_buffer;
 	union ixgbe_adv_tx_desc *tx_desc;
 	u32 len, cmd_type;
 	dma_addr_t dma;
 	u16 i;
+	int cpu;
+	int ret;
 
 	len = xdpf->len;
 
-	if (unlikely(!ixgbe_desc_unused(ring)))
-		return IXGBE_XDP_CONSUMED;
+	cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
+	ring = adapter->xdp_ring[cpu];
+
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_lock(&ring->tx_lock);
+
+	if (unlikely(!ixgbe_desc_unused(ring))) {
+		ret = IXGBE_XDP_CONSUMED;
+		goto out;
+	}
 
 	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ring->dev, dma))
-		return IXGBE_XDP_CONSUMED;
+	if (dma_mapping_error(ring->dev, dma)) {
+		ret = IXGBE_XDP_CONSUMED;
+		goto out;
+	}
 
 	/* record the location of the first descriptor for this packet */
 	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
@@ -8590,7 +8606,11 @@ int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
 	tx_buffer->next_to_watch = tx_desc;
 	ring->next_to_use = i;
 
-	return IXGBE_XDP_TX;
+	ret = IXGBE_XDP_TX;
+out:
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_unlock(&ring->tx_lock);
+	return ret;
 }
 
 netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
@@ -10130,8 +10150,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			return -EINVAL;
 	}
 
-	if (nr_cpu_ids > MAX_XDP_QUEUES)
+	/* if the number of cpus is much larger than the maximum of queues,
+	 * we should stop it and then return with NOMEM like before!
+	 */
+	if (nr_cpu_ids > MAX_XDP_QUEUES * 2)
 		return -ENOMEM;
+	else if (nr_cpu_ids > MAX_XDP_QUEUES)
+		static_branch_inc(&ixgbe_xdp_locking_key);
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
 	need_reset = (!!prog != !!old_prog);
@@ -10201,6 +10226,7 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct ixgbe_ring *ring;
 	int nxmit = 0;
+	int cpu;
 	int i;
 
 	if (unlikely(test_bit(__IXGBE_DOWN, &adapter->state)))
@@ -10209,10 +10235,12 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
+	cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
+
 	/* During program transitions its possible adapter->xdp_prog is assigned
 	 * but ring has not been configured yet. In this case simply abort xmit.
 	 */
-	ring = adapter->xdp_prog ? adapter->xdp_ring[smp_processor_id()] : NULL;
+	ring = adapter->xdp_prog ? adapter->xdp_ring[cpu] : NULL;
 	if (unlikely(!ring))
 		return -ENXIO;
 
@@ -10229,8 +10257,13 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 		nxmit++;
 	}
 
-	if (unlikely(flags & XDP_XMIT_FLUSH))
+	if (unlikely(flags & XDP_XMIT_FLUSH)) {
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_lock(&ring->tx_lock);
 		ixgbe_xdp_ring_update_tail(ring);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_unlock(&ring->tx_lock);
+	}
 
 	return nxmit;
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index b1d22e4..e9ce6c1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -334,13 +334,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		xdp_do_flush_map();
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
-		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
-
-		/* Force memory writes to complete before letting h/w
-		 * know there are new descriptors to fetch.
-		 */
-		wmb();
-		writel(ring->next_to_use, ring->tail);
+		int cpu = ixgbe_determine_xdp_cpu(smp_processor_id());
+		struct ixgbe_ring *ring = adapter->xdp_ring[cpu];
+
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_lock(&ring->tx_lock);
+		ixgbe_xdp_ring_update_tail(ring);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_unlock(&ring->tx_lock);
 	}
 
 	u64_stats_update_begin(&rx_ring->syncp);
-- 
1.8.3.1

