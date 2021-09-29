Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7841CB4E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbhI2Rxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:53:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:52393 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244498AbhI2Rxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:53:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="286018648"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="286018648"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 10:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="538938987"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 29 Sep 2021 10:52:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jason Xing <xingwanli@kuaishou.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.co,
        bpf@vger.kernel.org, Shujin Li <lishujin@kuaishou.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/1] ixgbe: let the xdpdrv work with more than 64 cpus
Date:   Wed, 29 Sep 2021 10:56:05 -0700
Message-Id: <20210929175605.3963510-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
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

Here are some numbers before/after applying this patch with xdp-example
loaded on the eth0X:

As client (tx path):
                     Before    After
TCP_STREAM send-64   734.14    714.20
TCP_STREAM send-128  1401.91   1395.05
TCP_STREAM send-512  5311.67   5292.84
TCP_STREAM send-1k   9277.40   9356.22 (not stable)
TCP_RR     send-1    22559.75  21844.22
TCP_RR     send-128  23169.54  22725.13
TCP_RR     send-512  21670.91  21412.56

As server (rx path):
                     Before    After
TCP_STREAM send-64   1416.49   1383.12
TCP_STREAM send-128  3141.49   3055.50
TCP_STREAM send-512  9488.73   9487.44
TCP_STREAM send-1k   9491.17   9356.22 (not stable)
TCP_RR     send-1    23617.74  23601.60
...

Notice: the TCP_RR mode is unstable as the official document explains.

I tested many times with different parameters combined through netperf.
Though the result is not that accurate, I cannot see much influence on
this patch. The static key is places on the hot path, but it actually
shouldn't cause a huge regression theoretically.

Co-developed-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 23 ++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  9 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 50 ++++++++++++++-----
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 16 +++---
 5 files changed, 77 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index a604552fa634..4a69823e6abd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -351,6 +351,7 @@ struct ixgbe_ring {
 	};
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t tx_lock;	/* used in XDP mode */
 	struct xsk_buff_pool *xsk_pool;
 	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
 	u16 rx_buf_len;
@@ -375,11 +376,13 @@ enum ixgbe_ring_f_enum {
 #define IXGBE_MAX_FCOE_INDICES		8
 #define MAX_RX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
 #define MAX_TX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
-#define MAX_XDP_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
+#define IXGBE_MAX_XDP_QS		(IXGBE_MAX_FDIR_INDICES + 1)
 #define IXGBE_MAX_L2A_QUEUES		4
 #define IXGBE_BAD_L2A_QUEUE		3
 #define IXGBE_MAX_MACVLANS		63
 
+DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
+
 struct ixgbe_ring_feature {
 	u16 limit;	/* upper limit on feature indices */
 	u16 indices;	/* current value of indices */
@@ -629,7 +632,7 @@ struct ixgbe_adapter {
 
 	/* XDP */
 	int num_xdp_queues;
-	struct ixgbe_ring *xdp_ring[MAX_XDP_QUEUES];
+	struct ixgbe_ring *xdp_ring[IXGBE_MAX_XDP_QS];
 	unsigned long *af_xdp_zc_qps; /* tracks AF_XDP ZC enabled rings */
 
 	/* TX */
@@ -772,6 +775,22 @@ struct ixgbe_adapter {
 #endif /* CONFIG_IXGBE_IPSEC */
 };
 
+static inline int ixgbe_determine_xdp_q_idx(int cpu)
+{
+	if (static_key_enabled(&ixgbe_xdp_locking_key))
+		return cpu % IXGBE_MAX_XDP_QS;
+	else
+		return cpu;
+}
+
+static inline
+struct ixgbe_ring *ixgbe_determine_xdp_ring(struct ixgbe_adapter *adapter)
+{
+	int index = ixgbe_determine_xdp_q_idx(smp_processor_id());
+
+	return adapter->xdp_ring[index];
+}
+
 static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
 {
 	switch (adapter->hw.mac.type) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 0218f6c9b925..86b11164655e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
 
 static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
 {
-	return adapter->xdp_prog ? nr_cpu_ids : 0;
+	int queues;
+
+	queues = min_t(int, IXGBE_MAX_XDP_QS, nr_cpu_ids);
+	return adapter->xdp_prog ? queues : 0;
 }
 
 #define IXGBE_RSS_64Q_MASK	0x3F
@@ -947,6 +950,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->count = adapter->tx_ring_count;
 		ring->queue_index = xdp_idx;
 		set_ring_xdp(ring);
+		spin_lock_init(&ring->tx_lock);
 
 		/* assign ring to adapter */
 		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
@@ -1032,6 +1036,9 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 	adapter->q_vector[v_idx] = NULL;
 	__netif_napi_del(&q_vector->napi);
 
+	if (static_key_enabled(&ixgbe_xdp_locking_key))
+		static_branch_dec(&ixgbe_xdp_locking_key);
+
 	/*
 	 * after a call to __netif_napi_del() napi may still be used and
 	 * ixgbe_get_stats64() might access the rings on this vector,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 24e06ba6f5e9..ae4e8397be4e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -165,6 +165,9 @@ MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
 MODULE_LICENSE("GPL v2");
 
+DEFINE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
+EXPORT_SYMBOL(ixgbe_xdp_locking_key);
+
 static struct workqueue_struct *ixgbe_wq;
 
 static bool ixgbe_check_cfg_remove(struct ixgbe_hw *hw, struct pci_dev *pdev);
@@ -2197,6 +2200,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 {
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
+	struct ixgbe_ring *ring;
 	struct xdp_frame *xdpf;
 	u32 act;
 
@@ -2215,7 +2219,12 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf))
 			goto out_failure;
-		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		ring = ixgbe_determine_xdp_ring(adapter);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_lock(&ring->tx_lock);
+		result = ixgbe_xmit_xdp_ring(ring, xdpf);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_unlock(&ring->tx_lock);
 		if (result == IXGBE_XDP_CONSUMED)
 			goto out_failure;
 		break;
@@ -2422,13 +2431,9 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		xdp_do_flush_map();
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
-		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
+		struct ixgbe_ring *ring = ixgbe_determine_xdp_ring(adapter);
 
-		/* Force memory writes to complete before letting h/w
-		 * know there are new descriptors to fetch.
-		 */
-		wmb();
-		writel(ring->next_to_use, ring->tail);
+		ixgbe_xdp_ring_update_tail_locked(ring);
 	}
 
 	u64_stats_update_begin(&rx_ring->syncp);
@@ -6320,7 +6325,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 	if (ixgbe_init_rss_key(adapter))
 		return -ENOMEM;
 
-	adapter->af_xdp_zc_qps = bitmap_zalloc(MAX_XDP_QUEUES, GFP_KERNEL);
+	adapter->af_xdp_zc_qps = bitmap_zalloc(IXGBE_MAX_XDP_QS, GFP_KERNEL);
 	if (!adapter->af_xdp_zc_qps)
 		return -ENOMEM;
 
@@ -8536,10 +8541,9 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 
 #endif
-int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
+int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,
 			struct xdp_frame *xdpf)
 {
-	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
 	struct ixgbe_tx_buffer *tx_buffer;
 	union ixgbe_adv_tx_desc *tx_desc;
 	u32 len, cmd_type;
@@ -10130,8 +10134,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			return -EINVAL;
 	}
 
-	if (nr_cpu_ids > MAX_XDP_QUEUES)
+	/* if the number of cpus is much larger than the maximum of queues,
+	 * we should stop it and then return with ENOMEM like before.
+	 */
+	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
 		return -ENOMEM;
+	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
+		static_branch_inc(&ixgbe_xdp_locking_key);
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
 	need_reset = (!!prog != !!old_prog);
@@ -10195,6 +10204,15 @@ void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring)
 	writel(ring->next_to_use, ring->tail);
 }
 
+void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring)
+{
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_lock(&ring->tx_lock);
+	ixgbe_xdp_ring_update_tail(ring);
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_unlock(&ring->tx_lock);
+}
+
 static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 			  struct xdp_frame **frames, u32 flags)
 {
@@ -10212,18 +10230,21 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 	/* During program transitions its possible adapter->xdp_prog is assigned
 	 * but ring has not been configured yet. In this case simply abort xmit.
 	 */
-	ring = adapter->xdp_prog ? adapter->xdp_ring[smp_processor_id()] : NULL;
+	ring = adapter->xdp_prog ? ixgbe_determine_xdp_ring(adapter) : NULL;
 	if (unlikely(!ring))
 		return -ENXIO;
 
 	if (unlikely(test_bit(__IXGBE_TX_DISABLED, &ring->state)))
 		return -ENXIO;
 
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_lock(&ring->tx_lock);
+
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 		int err;
 
-		err = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		err = ixgbe_xmit_xdp_ring(ring, xdpf);
 		if (err != IXGBE_XDP_TX)
 			break;
 		nxmit++;
@@ -10232,6 +10253,9 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		ixgbe_xdp_ring_update_tail(ring);
 
+	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+		spin_unlock(&ring->tx_lock);
+
 	return nxmit;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index 2aeec78029bc..a82533f21d36 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -12,7 +12,7 @@
 #define IXGBE_TXD_CMD (IXGBE_TXD_CMD_EOP | \
 		       IXGBE_TXD_CMD_RS)
 
-int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
+int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,
 			struct xdp_frame *xdpf);
 bool ixgbe_cleanup_headers(struct ixgbe_ring *rx_ring,
 			   union ixgbe_adv_rx_desc *rx_desc,
@@ -23,6 +23,7 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
 		  struct sk_buff *skb);
 void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring);
+void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring);
 void ixgbe_irq_rearm_queues(struct ixgbe_adapter *adapter, u64 qmask);
 
 void ixgbe_txrx_ring_disable(struct ixgbe_adapter *adapter, int ring);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index b1d22e4d5ec9..db2bc58dfcfd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -100,6 +100,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 {
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
+	struct ixgbe_ring *ring;
 	struct xdp_frame *xdpf;
 	u32 act;
 
@@ -120,7 +121,12 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf))
 			goto out_failure;
-		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		ring = ixgbe_determine_xdp_ring(adapter);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_lock(&ring->tx_lock);
+		result = ixgbe_xmit_xdp_ring(ring, xdpf);
+		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
+			spin_unlock(&ring->tx_lock);
 		if (result == IXGBE_XDP_CONSUMED)
 			goto out_failure;
 		break;
@@ -334,13 +340,9 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		xdp_do_flush_map();
 
 	if (xdp_xmit & IXGBE_XDP_TX) {
-		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
+		struct ixgbe_ring *ring = ixgbe_determine_xdp_ring(adapter);
 
-		/* Force memory writes to complete before letting h/w
-		 * know there are new descriptors to fetch.
-		 */
-		wmb();
-		writel(ring->next_to_use, ring->tail);
+		ixgbe_xdp_ring_update_tail_locked(ring);
 	}
 
 	u64_stats_update_begin(&rx_ring->syncp);
-- 
2.26.2

