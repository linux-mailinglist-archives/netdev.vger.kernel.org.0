Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D3B35DB4F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbhDMJdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:33:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:62647 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhDMJdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:33:07 -0400
IronPort-SDR: k8YakVZacqKTz+s+A6RvHYOw/o2oERvIpXbIuZj0xbNFxjN7+MP8MB6MQTg6vd3TM6b/mJ292t
 qA5bBXHXP6Mw==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="191188632"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="191188632"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 02:32:48 -0700
IronPort-SDR: EQYk7wZoUkdPz9Or2nMTKf79q6bHfUpfeFRoqNL2/e2nLNknwwRDBaF83P5LGlImrxzyXH3Vup
 fkVkptV816rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="424178242"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2021 02:32:41 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     alexandre.torgue@foss.st.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 6/7] net: stmmac: Enable RX via AF_XDP zero-copy
Date:   Tue, 13 Apr 2021 17:36:25 +0800
Message-Id: <20210413093626.3447-7-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413093626.3447-1-boon.leong.ong@intel.com>
References: <20210413093626.3447-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the support for receiving packet via AF_XDP zero-copy
mechanism.

XDP ZC uses 1:1 mapping of XDP buffer to receive packet, therefore the
use of split header is not used currently. The 'xdp_buff' is declared as
union together with a struct that contains 'page', 'addr' and
'page_offset' that are associated with primary buffer.

RX buffers are now allocated either via page_pool or xsk pool. For RX
buffers from xsk_pool they are allocated and deallocated using below
functions:

 * stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv, u32 queue)
 * dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)

With above functions now available, we then extend the following driver
functions to support XDP ZC:
 * stmmac_reinit_rx_buffers()
 * __init_dma_rx_desc_rings()
 * init_dma_rx_desc_rings()
 * __free_dma_rx_desc_resources()

Note: stmmac_alloc_rx_buffers_zc() may return -ENOMEM due to RX XDP
buffer pool is not allocated (e.g. samples/bpf/xdpsock TX-only). But,
it is still ok to let TX XDP ZC to continue, therefore, the -ENOMEM
is silently ignored to let the driver succcessfully transition to XDP
ZC mode for the said RX and TX queue.

As XDP ZC buffer size is different, the DMA buffer size is required
to be reprogrammed accordingly for RX DMA/Queue that is populated with
XDP buffer from XSK pool.

Next, to add or remove per-queue XSK pool, stmmac_xdp_setup_pool()
will call stmmac_xdp_enable_pool() or stmmac_xdp_disable_pool()
that in-turn coordinates the tearing down and setting up RX ring via
RX buffers and descriptors removal and reallocation through
stmmac_disable_rx_queue() and stmmac_enable_rx_queue(). In addition,
stmmac_xsk_wakeup() is added to initiate XDP RX buffer replenishing
by signalling user application to add available XDP frames back to
FILL queue.

For RX processing using XDP zero-copy buffer, stmmac_rx_zc() is
introduced which is implemented with the assumption that RX split
header is disabled. For XDP verdict is XDP_PASS, the XDP buffer is
copied into a sk_buff allocated through stmmac_construct_skb_zc()
and sent to Linux network GRO inside stmmac_dispatch_skb_zc(). Free RX
buffers are then replenished using stmmac_rx_refill_zc()

v2: introduce __stmmac_disable_all_queues() to contain the original code
    that does napi_disable() and then make stmmac_setup_tc_block_cb()
    to use it. Move synchronize_rcu() into stmmac_disable_all_queues()
    that eventually calls __stmmac_disable_all_queues(). Then,
    make both stmmac_release() and stmmac_suspend() to use
    stmmac_disable_all_queues(). Thanks David Miller for spotting the
    synchronize_rcu() issue in v1 patch.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 600 +++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.c  |  87 +++
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.h  |   3 +
 4 files changed, 679 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index c49debb62b05..aa0db622ee69 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -77,9 +77,14 @@ struct stmmac_tx_queue {
 };
 
 struct stmmac_rx_buffer {
-	struct page *page;
-	dma_addr_t addr;
-	__u32 page_offset;
+	union {
+		struct {
+			struct page *page;
+			dma_addr_t addr;
+			__u32 page_offset;
+		};
+		struct xdp_buff *xdp;
+	};
 	struct page *sec_page;
 	dma_addr_t sec_addr;
 };
@@ -88,6 +93,7 @@ struct stmmac_rx_queue {
 	u32 rx_count_frames;
 	u32 queue_index;
 	struct xdp_rxq_info xdp_rxq;
+	struct xsk_buff_pool *xsk_pool;
 	struct page_pool *page_pool;
 	struct stmmac_rx_buffer *buf_pool;
 	struct stmmac_priv *priv_data;
@@ -95,6 +101,7 @@ struct stmmac_rx_queue {
 	struct dma_desc *dma_rx ____cacheline_aligned_in_smp;
 	unsigned int cur_rx;
 	unsigned int dirty_rx;
+	unsigned int buf_alloc_num;
 	u32 rx_zeroc_thresh;
 	dma_addr_t dma_rx_phy;
 	u32 rx_tail_addr;
@@ -283,6 +290,7 @@ struct stmmac_priv {
 	struct stmmac_rss rss;
 
 	/* XDP BPF Program */
+	unsigned long *af_xdp_zc_qps;
 	struct bpf_prog *xdp_prog;
 };
 
@@ -328,6 +336,10 @@ static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 	return 0;
 }
 
+void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
+void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue);
+int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags);
+
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
 			 struct ethtool_test *etest, u64 *buf);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 329a3abbac76..48e755ebcf2b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -40,6 +40,7 @@
 #include <linux/udp.h>
 #include <linux/bpf_trace.h>
 #include <net/pkt_cls.h>
+#include <net/xdp_sock_drv.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
 #include "stmmac_xdp.h"
@@ -69,6 +70,8 @@ MODULE_PARM_DESC(phyaddr, "Physical device address");
 #define STMMAC_TX_THRESH(x)	((x)->dma_tx_size / 4)
 #define STMMAC_RX_THRESH(x)	((x)->dma_rx_size / 4)
 
+#define STMMAC_RX_FILL_BATCH		16
+
 #define STMMAC_XDP_PASS		0
 #define STMMAC_XDP_CONSUMED	BIT(0)
 #define STMMAC_XDP_TX		BIT(1)
@@ -179,11 +182,7 @@ static void stmmac_verify_args(void)
 		eee_timer = STMMAC_DEFAULT_LPI_TIMER;
 }
 
-/**
- * stmmac_disable_all_queues - Disable all queues
- * @priv: driver private structure
- */
-static void stmmac_disable_all_queues(struct stmmac_priv *priv)
+static void __stmmac_disable_all_queues(struct stmmac_priv *priv)
 {
 	u32 rx_queues_cnt = priv->plat->rx_queues_to_use;
 	u32 tx_queues_cnt = priv->plat->tx_queues_to_use;
@@ -200,6 +199,28 @@ static void stmmac_disable_all_queues(struct stmmac_priv *priv)
 	}
 }
 
+/**
+ * stmmac_disable_all_queues - Disable all queues
+ * @priv: driver private structure
+ */
+static void stmmac_disable_all_queues(struct stmmac_priv *priv)
+{
+	u32 rx_queues_cnt = priv->plat->rx_queues_to_use;
+	struct stmmac_rx_queue *rx_q;
+	u32 queue;
+
+	/* synchronize_rcu() needed for pending XDP buffers to drain */
+	for (queue = 0; queue < rx_queues_cnt; queue++) {
+		rx_q = &priv->rx_queue[queue];
+		if (rx_q->xsk_pool) {
+			synchronize_rcu();
+			break;
+		}
+	}
+
+	__stmmac_disable_all_queues(priv);
+}
+
 /**
  * stmmac_enable_all_queues - Enable all queues
  * @priv: driver private structure
@@ -1509,6 +1530,8 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
 					     queue);
 		if (ret)
 			return ret;
+
+		rx_q->buf_alloc_num++;
 	}
 
 	return 0;
@@ -1539,6 +1562,56 @@ static void dma_recycle_rx_skbufs(struct stmmac_priv *priv, u32 queue)
 	}
 }
 
+/**
+ * dma_free_rx_xskbufs - free RX dma buffers from XSK pool
+ * @priv: private structure
+ * @queue: RX queue index
+ */
+static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	int i;
+
+	for (i = 0; i < priv->dma_rx_size; i++) {
+		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+
+		if (!buf->xdp)
+			continue;
+
+		xsk_buff_free(buf->xdp);
+		buf->xdp = NULL;
+	}
+}
+
+static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	int i;
+
+	for (i = 0; i < priv->dma_rx_size; i++) {
+		struct stmmac_rx_buffer *buf;
+		dma_addr_t dma_addr;
+		struct dma_desc *p;
+
+		if (priv->extend_desc)
+			p = (struct dma_desc *)(rx_q->dma_erx + i);
+		else
+			p = rx_q->dma_rx + i;
+
+		buf = &rx_q->buf_pool[i];
+
+		buf->xdp = xsk_buff_alloc(rx_q->xsk_pool);
+		if (!buf->xdp)
+			return -ENOMEM;
+
+		dma_addr = xsk_buff_xdp_get_dma(buf->xdp);
+		stmmac_set_desc_addr(priv, p, dma_addr);
+		rx_q->buf_alloc_num++;
+	}
+
+	return 0;
+}
+
 /**
  * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
  * @priv: driver private structure
@@ -1550,15 +1623,31 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	u32 queue;
 
-	for (queue = 0; queue < rx_count; queue++)
-		dma_recycle_rx_skbufs(priv, queue);
+	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		if (rx_q->xsk_pool)
+			dma_free_rx_xskbufs(priv, queue);
+		else
+			dma_recycle_rx_skbufs(priv, queue);
+
+		rx_q->buf_alloc_num = 0;
+	}
 
 	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 		int ret;
 
-		ret = stmmac_alloc_rx_buffers(priv, queue, GFP_KERNEL);
-		if (ret < 0)
-			goto err_reinit_rx_buffers;
+		if (rx_q->xsk_pool) {
+			/* RX XDP ZC buffer pool may not be populated, e.g.
+			 * xdpsock TX-only.
+			 */
+			stmmac_alloc_rx_buffers_zc(priv, queue);
+		} else {
+			ret = stmmac_alloc_rx_buffers(priv, queue, GFP_KERNEL);
+			if (ret < 0)
+				goto err_reinit_rx_buffers;
+		}
 	}
 
 	return;
@@ -1574,6 +1663,14 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 	}
 }
 
+static struct xsk_buff_pool *stmmac_get_xsk_pool(struct stmmac_priv *priv, u32 queue)
+{
+	if (!stmmac_xdp_is_enabled(priv) || !test_bit(queue, priv->af_xdp_zc_qps))
+		return NULL;
+
+	return xsk_get_pool_from_qid(priv->dev, queue);
+}
+
 /**
  * __init_dma_rx_desc_rings - init the RX descriptor ring (per queue)
  * @priv: driver private structure
@@ -1594,17 +1691,37 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 
 	stmmac_clear_rx_descriptors(priv, queue);
 
-	WARN_ON(xdp_rxq_info_reg_mem_model(&rx_q->xdp_rxq,
-					   MEM_TYPE_PAGE_POOL,
-					   rx_q->page_pool));
+	xdp_rxq_info_unreg_mem_model(&rx_q->xdp_rxq);
 
-	netdev_info(priv->dev,
-		    "Register MEM_TYPE_PAGE_POOL RxQ-%d\n",
-		    rx_q->queue_index);
+	rx_q->xsk_pool = stmmac_get_xsk_pool(priv, queue);
 
-	ret = stmmac_alloc_rx_buffers(priv, queue, flags);
-	if (ret < 0)
-		return -ENOMEM;
+	if (rx_q->xsk_pool) {
+		WARN_ON(xdp_rxq_info_reg_mem_model(&rx_q->xdp_rxq,
+						   MEM_TYPE_XSK_BUFF_POOL,
+						   NULL));
+		netdev_info(priv->dev,
+			    "Register MEM_TYPE_XSK_BUFF_POOL RxQ-%d\n",
+			    rx_q->queue_index);
+		xsk_pool_set_rxq_info(rx_q->xsk_pool, &rx_q->xdp_rxq);
+	} else {
+		WARN_ON(xdp_rxq_info_reg_mem_model(&rx_q->xdp_rxq,
+						   MEM_TYPE_PAGE_POOL,
+						   rx_q->page_pool));
+		netdev_info(priv->dev,
+			    "Register MEM_TYPE_PAGE_POOL RxQ-%d\n",
+			    rx_q->queue_index);
+	}
+
+	if (rx_q->xsk_pool) {
+		/* RX XDP ZC buffer pool may not be populated, e.g.
+		 * xdpsock TX-only.
+		 */
+		stmmac_alloc_rx_buffers_zc(priv, queue);
+	} else {
+		ret = stmmac_alloc_rx_buffers(priv, queue, flags);
+		if (ret < 0)
+			return -ENOMEM;
+	}
 
 	rx_q->cur_rx = 0;
 	rx_q->dirty_rx = 0;
@@ -1645,7 +1762,15 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 err_init_rx_buffers:
 	while (queue >= 0) {
-		dma_free_rx_skbufs(priv, queue);
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		if (rx_q->xsk_pool)
+			dma_free_rx_xskbufs(priv, queue);
+		else
+			dma_free_rx_skbufs(priv, queue);
+
+		rx_q->buf_alloc_num = 0;
+		rx_q->xsk_pool = NULL;
 
 		if (queue == 0)
 			break;
@@ -1790,7 +1915,13 @@ static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
 	/* Release the DMA RX socket buffers */
-	dma_free_rx_skbufs(priv, queue);
+	if (rx_q->xsk_pool)
+		dma_free_rx_xskbufs(priv, queue);
+	else
+		dma_free_rx_skbufs(priv, queue);
+
+	rx_q->buf_alloc_num = 0;
+	rx_q->xsk_pool = NULL;
 
 	/* Free DMA regions of consistent memory previously allocated */
 	if (!priv->extend_desc)
@@ -2222,12 +2353,24 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 
 	/* configure all channels */
 	for (chan = 0; chan < rx_channels_count; chan++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[chan];
+		u32 buf_size;
+
 		qmode = priv->plat->rx_queues_cfg[chan].mode_to_use;
 
 		stmmac_dma_rx_mode(priv, priv->ioaddr, rxmode, chan,
 				rxfifosz, qmode);
-		stmmac_set_dma_bfsize(priv, priv->ioaddr, priv->dma_buf_sz,
-				chan);
+
+		if (rx_q->xsk_pool) {
+			buf_size = xsk_pool_get_rx_frame_size(rx_q->xsk_pool);
+			stmmac_set_dma_bfsize(priv, priv->ioaddr,
+					      buf_size,
+					      chan);
+		} else {
+			stmmac_set_dma_bfsize(priv, priv->ioaddr,
+					      priv->dma_buf_sz,
+					      chan);
+		}
 	}
 
 	for (chan = 0; chan < tx_channels_count; chan++) {
@@ -2638,7 +2781,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 				    rx_q->dma_rx_phy, chan);
 
 		rx_q->rx_tail_addr = rx_q->dma_rx_phy +
-				     (priv->dma_rx_size *
+				     (rx_q->buf_alloc_num *
 				      sizeof(struct dma_desc));
 		stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
 				       rx_q->rx_tail_addr, chan);
@@ -4479,6 +4622,302 @@ static void stmmac_finalize_xdp_rx(struct stmmac_priv *priv,
 		xdp_do_flush();
 }
 
+static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
+					       struct xdp_buff *xdp)
+{
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	unsigned int datasize = xdp->data_end - xdp->data;
+	struct sk_buff *skb;
+
+	skb = __napi_alloc_skb(&ch->rx_napi,
+			       xdp->data_end - xdp->data_hard_start,
+			       GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
+	return skb;
+}
+
+static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
+				   struct dma_desc *p, struct dma_desc *np,
+				   struct xdp_buff *xdp)
+{
+	struct stmmac_channel *ch = &priv->channel[queue];
+	unsigned int len = xdp->data_end - xdp->data;
+	enum pkt_hash_types hash_type;
+	int coe = priv->hw->rx_csum;
+	struct sk_buff *skb;
+	u32 hash;
+
+	skb = stmmac_construct_skb_zc(ch, xdp);
+	if (!skb) {
+		priv->dev->stats.rx_dropped++;
+		return;
+	}
+
+	stmmac_get_rx_hwtstamp(priv, p, np, skb);
+	stmmac_rx_vlan(priv->dev, skb);
+	skb->protocol = eth_type_trans(skb, priv->dev);
+
+	if (unlikely(!coe))
+		skb_checksum_none_assert(skb);
+	else
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	if (!stmmac_get_rx_hash(priv, p, &hash, &hash_type))
+		skb_set_hash(skb, hash, hash_type);
+
+	skb_record_rx_queue(skb, queue);
+	napi_gro_receive(&ch->rx_napi, skb);
+
+	priv->dev->stats.rx_packets++;
+	priv->dev->stats.rx_bytes += len;
+}
+
+static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	unsigned int entry = rx_q->dirty_rx;
+	struct dma_desc *rx_desc = NULL;
+	bool ret = true;
+
+	budget = min(budget, stmmac_rx_dirty(priv, queue));
+
+	while (budget-- > 0 && entry != rx_q->cur_rx) {
+		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[entry];
+		dma_addr_t dma_addr;
+		bool use_rx_wd;
+
+		if (!buf->xdp) {
+			buf->xdp = xsk_buff_alloc(rx_q->xsk_pool);
+			if (!buf->xdp) {
+				ret = false;
+				break;
+			}
+		}
+
+		if (priv->extend_desc)
+			rx_desc = (struct dma_desc *)(rx_q->dma_erx + entry);
+		else
+			rx_desc = rx_q->dma_rx + entry;
+
+		dma_addr = xsk_buff_xdp_get_dma(buf->xdp);
+		stmmac_set_desc_addr(priv, rx_desc, dma_addr);
+		stmmac_set_desc_sec_addr(priv, rx_desc, 0, false);
+		stmmac_refill_desc3(priv, rx_q, rx_desc);
+
+		rx_q->rx_count_frames++;
+		rx_q->rx_count_frames += priv->rx_coal_frames[queue];
+		if (rx_q->rx_count_frames > priv->rx_coal_frames[queue])
+			rx_q->rx_count_frames = 0;
+
+		use_rx_wd = !priv->rx_coal_frames[queue];
+		use_rx_wd |= rx_q->rx_count_frames > 0;
+		if (!priv->use_riwt)
+			use_rx_wd = false;
+
+		dma_wmb();
+		stmmac_set_rx_owner(priv, rx_desc, use_rx_wd);
+
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
+	}
+
+	if (rx_desc) {
+		rx_q->dirty_rx = entry;
+		rx_q->rx_tail_addr = rx_q->dma_rx_phy +
+				     (rx_q->dirty_rx * sizeof(struct dma_desc));
+		stmmac_set_rx_tail_ptr(priv, priv->ioaddr, rx_q->rx_tail_addr, queue);
+	}
+
+	return ret;
+}
+
+static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	unsigned int count = 0, error = 0, len = 0;
+	int dirty = stmmac_rx_dirty(priv, queue);
+	unsigned int next_entry = rx_q->cur_rx;
+	unsigned int desc_size;
+	struct bpf_prog *prog;
+	bool failure = false;
+	int xdp_status = 0;
+	int status = 0;
+
+	if (netif_msg_rx_status(priv)) {
+		void *rx_head;
+
+		netdev_dbg(priv->dev, "%s: descriptor ring:\n", __func__);
+		if (priv->extend_desc) {
+			rx_head = (void *)rx_q->dma_erx;
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
+			rx_head = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
+
+		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
+	}
+	while (count < limit) {
+		struct stmmac_rx_buffer *buf;
+		unsigned int buf1_len = 0;
+		struct dma_desc *np, *p;
+		int entry;
+		int res;
+
+		if (!count && rx_q->state_saved) {
+			error = rx_q->state.error;
+			len = rx_q->state.len;
+		} else {
+			rx_q->state_saved = false;
+			error = 0;
+			len = 0;
+		}
+
+		if (count >= limit)
+			break;
+
+read_again:
+		buf1_len = 0;
+		entry = next_entry;
+		buf = &rx_q->buf_pool[entry];
+
+		if (dirty >= STMMAC_RX_FILL_BATCH) {
+			failure = failure ||
+				  !stmmac_rx_refill_zc(priv, queue, dirty);
+			dirty = 0;
+		}
+
+		if (priv->extend_desc)
+			p = (struct dma_desc *)(rx_q->dma_erx + entry);
+		else
+			p = rx_q->dma_rx + entry;
+
+		/* read the status of the incoming frame */
+		status = stmmac_rx_status(priv, &priv->dev->stats,
+					  &priv->xstats, p);
+		/* check if managed by the DMA otherwise go ahead */
+		if (unlikely(status & dma_own))
+			break;
+
+		/* Prefetch the next RX descriptor */
+		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
+						priv->dma_rx_size);
+		next_entry = rx_q->cur_rx;
+
+		if (priv->extend_desc)
+			np = (struct dma_desc *)(rx_q->dma_erx + next_entry);
+		else
+			np = rx_q->dma_rx + next_entry;
+
+		prefetch(np);
+
+		if (priv->extend_desc)
+			stmmac_rx_extended_status(priv, &priv->dev->stats,
+						  &priv->xstats,
+						  rx_q->dma_erx + entry);
+		if (unlikely(status == discard_frame)) {
+			xsk_buff_free(buf->xdp);
+			buf->xdp = NULL;
+			dirty++;
+			error = 1;
+			if (!priv->hwts_rx_en)
+				priv->dev->stats.rx_errors++;
+		}
+
+		if (unlikely(error && (status & rx_not_ls)))
+			goto read_again;
+		if (unlikely(error)) {
+			count++;
+			continue;
+		}
+
+		/* Ensure a valid XSK buffer before proceed */
+		if (!buf->xdp)
+			break;
+
+		/* XSK pool expects RX frame 1:1 mapped to XSK buffer */
+		if (likely(status & rx_not_ls)) {
+			xsk_buff_free(buf->xdp);
+			buf->xdp = NULL;
+			dirty++;
+			count++;
+			goto read_again;
+		}
+
+		/* XDP ZC Frame only support primary buffers for now */
+		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
+		len += buf1_len;
+
+		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
+		 * Type frames (LLC/LLC-SNAP)
+		 *
+		 * llc_snap is never checked in GMAC >= 4, so this ACS
+		 * feature is always disabled and packets need to be
+		 * stripped manually.
+		 */
+		if (likely(!(status & rx_not_ls)) &&
+		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
+		     unlikely(status != llc_snap))) {
+			buf1_len -= ETH_FCS_LEN;
+			len -= ETH_FCS_LEN;
+		}
+
+		/* RX buffer is good and fit into a XSK pool buffer */
+		buf->xdp->data_end = buf->xdp->data + buf1_len;
+		xsk_buff_dma_sync_for_cpu(buf->xdp, rx_q->xsk_pool);
+
+		rcu_read_lock();
+		prog = READ_ONCE(priv->xdp_prog);
+		res = __stmmac_xdp_run_prog(priv, prog, buf->xdp);
+		rcu_read_unlock();
+
+		switch (res) {
+		case STMMAC_XDP_PASS:
+			stmmac_dispatch_skb_zc(priv, queue, p, np, buf->xdp);
+			xsk_buff_free(buf->xdp);
+			break;
+		case STMMAC_XDP_CONSUMED:
+			xsk_buff_free(buf->xdp);
+			priv->dev->stats.rx_dropped++;
+			break;
+		case STMMAC_XDP_TX:
+		case STMMAC_XDP_REDIRECT:
+			xdp_status |= res;
+			break;
+		}
+
+		buf->xdp = NULL;
+		dirty++;
+		count++;
+	}
+
+	if (status & rx_not_ls) {
+		rx_q->state_saved = true;
+		rx_q->state.error = error;
+		rx_q->state.len = len;
+	}
+
+	stmmac_finalize_xdp_rx(priv, xdp_status);
+
+	if (xsk_uses_need_wakeup(rx_q->xsk_pool)) {
+		if (failure || stmmac_rx_dirty(priv, queue) > 0)
+			xsk_set_rx_need_wakeup(rx_q->xsk_pool);
+		else
+			xsk_clear_rx_need_wakeup(rx_q->xsk_pool);
+
+		return (int)count;
+	}
+
+	return failure ? limit : (int)count;
+}
+
 /**
  * stmmac_rx - manage the receive process
  * @priv: driver private structure
@@ -4766,12 +5205,17 @@ static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_rx_queue *rx_q;
 	u32 chan = ch->index;
 	int work_done;
 
 	priv->xstats.napi_poll++;
 
-	work_done = stmmac_rx(priv, budget, chan);
+	rx_q = &priv->rx_queue[chan];
+
+	work_done = rx_q->xsk_pool ?
+		    stmmac_rx_zc(priv, budget, chan) :
+		    stmmac_rx(priv, budget, chan);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		unsigned long flags;
 
@@ -5254,7 +5698,7 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
 		return ret;
 
-	stmmac_disable_all_queues(priv);
+	__stmmac_disable_all_queues(priv);
 
 	switch (type) {
 	case TC_SETUP_CLSU32:
@@ -5675,6 +6119,9 @@ static int stmmac_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
 		return stmmac_xdp_set_prog(priv, bpf->prog, bpf->extack);
+	case XDP_SETUP_XSK_POOL:
+		return stmmac_xdp_setup_pool(priv, bpf->xsk.pool,
+					     bpf->xsk.queue_id);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -5722,6 +6169,102 @@ static int stmmac_xdp_xmit(struct net_device *dev, int num_frames,
 	return nxmit;
 }
 
+void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_channel *ch = &priv->channel[queue];
+	unsigned long flags;
+
+	spin_lock_irqsave(&ch->lock, flags);
+	stmmac_disable_dma_irq(priv, priv->ioaddr, queue, 1, 0);
+	spin_unlock_irqrestore(&ch->lock, flags);
+
+	stmmac_stop_rx_dma(priv, queue);
+	__free_dma_rx_desc_resources(priv, queue);
+}
+
+void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_channel *ch = &priv->channel[queue];
+	unsigned long flags;
+	u32 buf_size;
+	int ret;
+
+	ret = __alloc_dma_rx_desc_resources(priv, queue);
+	if (ret) {
+		netdev_err(priv->dev, "Failed to alloc RX desc.\n");
+		return;
+	}
+
+	ret = __init_dma_rx_desc_rings(priv, queue, GFP_KERNEL);
+	if (ret) {
+		__free_dma_rx_desc_resources(priv, queue);
+		netdev_err(priv->dev, "Failed to init RX desc.\n");
+		return;
+	}
+
+	stmmac_clear_rx_descriptors(priv, queue);
+
+	stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
+			    rx_q->dma_rx_phy, rx_q->queue_index);
+
+	rx_q->rx_tail_addr = rx_q->dma_rx_phy + (rx_q->buf_alloc_num *
+			     sizeof(struct dma_desc));
+	stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
+			       rx_q->rx_tail_addr, rx_q->queue_index);
+
+	if (rx_q->xsk_pool && rx_q->buf_alloc_num) {
+		buf_size = xsk_pool_get_rx_frame_size(rx_q->xsk_pool);
+		stmmac_set_dma_bfsize(priv, priv->ioaddr,
+				      buf_size,
+				      rx_q->queue_index);
+	} else {
+		stmmac_set_dma_bfsize(priv, priv->ioaddr,
+				      priv->dma_buf_sz,
+				      rx_q->queue_index);
+	}
+
+	stmmac_start_rx_dma(priv, queue);
+
+	spin_lock_irqsave(&ch->lock, flags);
+	stmmac_enable_dma_irq(priv, priv->ioaddr, queue, 1, 0);
+	spin_unlock_irqrestore(&ch->lock, flags);
+}
+
+int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	struct stmmac_rx_queue *rx_q;
+	struct stmmac_channel *ch;
+
+	if (test_bit(STMMAC_DOWN, &priv->state) ||
+	    !netif_carrier_ok(priv->dev))
+		return -ENETDOWN;
+
+	if (!stmmac_xdp_is_enabled(priv))
+		return -ENXIO;
+
+	if (queue >= priv->plat->rx_queues_to_use)
+		return -EINVAL;
+
+	rx_q = &priv->rx_queue[queue];
+	ch = &priv->channel[queue];
+
+	if (!rx_q->xsk_pool)
+		return -ENXIO;
+
+	if (flags & XDP_WAKEUP_RX &&
+	    !napi_if_scheduled_mark_missed(&ch->rx_napi)) {
+		/* EQoS does not have per-DMA channel SW interrupt,
+		 * so we schedule RX Napi straight-away.
+		 */
+		if (likely(napi_schedule_prep(&ch->rx_napi)))
+			__napi_schedule(&ch->rx_napi);
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_open = stmmac_open,
 	.ndo_start_xmit = stmmac_xmit,
@@ -5742,6 +6285,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_vlan_rx_kill_vid = stmmac_vlan_rx_kill_vid,
 	.ndo_bpf = stmmac_bpf,
 	.ndo_xdp_xmit = stmmac_xdp_xmit,
+	.ndo_xsk_wakeup = stmmac_xsk_wakeup,
 };
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
@@ -6075,6 +6619,10 @@ int stmmac_dvr_probe(struct device *device,
 	/* Verify driver arguments */
 	stmmac_verify_args();
 
+	priv->af_xdp_zc_qps = bitmap_zalloc(MTL_MAX_TX_QUEUES, GFP_KERNEL);
+	if (!priv->af_xdp_zc_qps)
+		return -ENOMEM;
+
 	/* Allocate workqueue */
 	priv->wq = create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
index bf38d231860b..caff0dfc6f4b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -1,9 +1,96 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2021, Intel Corporation. */
 
+#include <net/xdp_sock_drv.h>
+
 #include "stmmac.h"
 #include "stmmac_xdp.h"
 
+static int stmmac_xdp_enable_pool(struct stmmac_priv *priv,
+				  struct xsk_buff_pool *pool, u16 queue)
+{
+	struct stmmac_channel *ch = &priv->channel[queue];
+	bool need_update;
+	u32 frame_size;
+	int err;
+
+	if (queue >= priv->plat->rx_queues_to_use)
+		return -EINVAL;
+
+	frame_size = xsk_pool_get_rx_frame_size(pool);
+	/* XDP ZC does not span multiple frame, make sure XSK pool buffer
+	 * size can at least store Q-in-Q frame.
+	 */
+	if (frame_size < ETH_FRAME_LEN + VLAN_HLEN * 2)
+		return -EOPNOTSUPP;
+
+	err = xsk_pool_dma_map(pool, priv->device, STMMAC_RX_DMA_ATTR);
+	if (err) {
+		netdev_err(priv->dev, "Failed to map xsk pool\n");
+		return err;
+	}
+
+	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
+
+	if (need_update) {
+		stmmac_disable_rx_queue(priv, queue);
+		napi_disable(&ch->rx_napi);
+	}
+
+	set_bit(queue, priv->af_xdp_zc_qps);
+
+	if (need_update) {
+		napi_enable(&ch->rx_napi);
+		stmmac_enable_rx_queue(priv, queue);
+
+		err = stmmac_xsk_wakeup(priv->dev, queue, XDP_WAKEUP_RX);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int stmmac_xdp_disable_pool(struct stmmac_priv *priv, u16 queue)
+{
+	struct stmmac_channel *ch = &priv->channel[queue];
+	struct xsk_buff_pool *pool;
+	bool need_update;
+
+	if (queue >= priv->plat->rx_queues_to_use)
+		return -EINVAL;
+
+	pool = xsk_get_pool_from_qid(priv->dev, queue);
+	if (!pool)
+		return -EINVAL;
+
+	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
+
+	if (need_update) {
+		stmmac_disable_rx_queue(priv, queue);
+		synchronize_rcu();
+		napi_disable(&ch->rx_napi);
+	}
+
+	xsk_pool_dma_unmap(pool, STMMAC_RX_DMA_ATTR);
+
+	clear_bit(queue, priv->af_xdp_zc_qps);
+
+	if (need_update) {
+		napi_enable(&ch->rx_napi);
+		stmmac_enable_rx_queue(priv, queue);
+	}
+
+	return 0;
+}
+
+int stmmac_xdp_setup_pool(struct stmmac_priv *priv, struct xsk_buff_pool *pool,
+			  u16 queue)
+{
+	return pool ? stmmac_xdp_enable_pool(priv, pool, queue) :
+		      stmmac_xdp_disable_pool(priv, queue);
+}
+
 int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
index 93948569d92a..896dc987d4ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
@@ -5,7 +5,10 @@
 #define _STMMAC_XDP_H_
 
 #define STMMAC_MAX_RX_BUF_SIZE(num)	(((num) * PAGE_SIZE) - XDP_PACKET_HEADROOM)
+#define STMMAC_RX_DMA_ATTR	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
+int stmmac_xdp_setup_pool(struct stmmac_priv *priv, struct xsk_buff_pool *pool,
+			  u16 queue);
 int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack);
 
-- 
2.25.1

