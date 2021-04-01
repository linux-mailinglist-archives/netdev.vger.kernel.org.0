Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CAC350C58
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 04:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhDACIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 22:08:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:12618 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233028AbhDACH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 22:07:57 -0400
IronPort-SDR: d+r7RaSawSR7WIVxF7cGLC95tU19ana+NlimxT9MUefeBI8cdDN1WB8O6dhDm6Im6FbVMDrpOR
 YTBp9+OS69zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="179664039"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="179664039"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 19:07:57 -0700
IronPort-SDR: bcEWFjFuN35gsuu+J+7cu0jXSpXJR7LX3ZIRCvYDIExIbSjXFTxqIe9AJzLS0JSM6DgX77IUje
 XNHaZ9Y1BA/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="528004248"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2021 19:07:51 -0700
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
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v4 4/6] net: stmmac: Add initial XDP support
Date:   Thu,  1 Apr 2021 10:11:15 +0800
Message-Id: <20210401021117.13360-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401021117.13360-1-boon.leong.ong@intel.com>
References: <20210401021117.13360-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the initial XDP support to stmmac driver. It supports
XDP_PASS, XDP_DROP and XDP_ABORTED actions. Upcoming patches will add
support for XDP_TX and XDP_REDIRECT.

To support XDP headroom, this patch adds page_offset into RX buffer and
change the dma_sync_single_for_device|cpu(). The DMA address used for
RX operation are changed to take into page_offset too. As page_pool
can handle dma_sync_single_for_device() on behalf of driver with
PP_FLAG_DMA_SYNC_DEV flag, we skip doing that in stmmac driver.

Current stmmac driver supports split header support (SPH) in RX but
the flexibility of splitting header and payload at different position
makes it very complex to be supported for XDP processing. In addition,
jumbo frame is not supported in XDP to keep the initial codes simple.

This patch has been tested with the sample app "xdp1" located in
samples/bpf directory for both SKB and Native (XDP) mode. The burst
traffic generated using pktgen_sample03_burst_single_flow.sh in
samples/pktgen directory.

Changes in v3:
 - factor in xdp header and tail adjustment done by XDP program.
   Thanks to Jakub Kicinski for pointing out the gap in v2.

Changes in v2:
 - fix for "warning: variable 'len' set but not used" reported by lkp.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  21 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 150 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.c  |  40 +++++
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.h  |  12 ++
 5 files changed, 197 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 366740ab9c5a..f2e478b884b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -6,6 +6,7 @@ stmmac-objs:= stmmac_main.o stmmac_ethtool.o stmmac_mdio.o ring_mode.o	\
 	      mmc_core.o stmmac_hwtstamp.o stmmac_ptp.o dwmac4_descs.o	\
 	      dwmac4_dma.o dwmac4_lib.o dwmac4_core.o dwmac5.o hwif.o \
 	      stmmac_tc.o dwxgmac2_core.o dwxgmac2_dma.o dwxgmac2_descs.o \
+	      stmmac_xdp.o \
 	      $(stmmac-y)
 
 stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e293423f98c3..e72224c8fbac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -68,8 +68,9 @@ struct stmmac_tx_queue {
 
 struct stmmac_rx_buffer {
 	struct page *page;
-	struct page *sec_page;
 	dma_addr_t addr;
+	__u32 page_offset;
+	struct page *sec_page;
 	dma_addr_t sec_addr;
 };
 
@@ -269,6 +270,9 @@ struct stmmac_priv {
 
 	/* Receive Side Scaling */
 	struct stmmac_rss rss;
+
+	/* XDP BPF Program */
+	struct bpf_prog *xdp_prog;
 };
 
 enum stmmac_state {
@@ -285,6 +289,8 @@ void stmmac_set_ethtool_ops(struct net_device *netdev);
 
 void stmmac_ptp_register(struct stmmac_priv *priv);
 void stmmac_ptp_unregister(struct stmmac_priv *priv);
+int stmmac_open(struct net_device *dev);
+int stmmac_release(struct net_device *dev);
 int stmmac_resume(struct device *dev);
 int stmmac_suspend(struct device *dev);
 int stmmac_dvr_remove(struct device *dev);
@@ -298,6 +304,19 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
 int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
 void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable);
 
+static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
+{
+	return !!priv->xdp_prog;
+}
+
+static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
+{
+	if (stmmac_xdp_is_enabled(priv))
+		return XDP_PACKET_HEADROOM;
+
+	return 0;
+}
+
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
 			 struct ethtool_test *etest, u64 *buf);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cb1b2a180429..0dad8ab93eb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -38,9 +38,11 @@
 #include <linux/net_tstamp.h>
 #include <linux/phylink.h>
 #include <linux/udp.h>
+#include <linux/bpf_trace.h>
 #include <net/pkt_cls.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
+#include "stmmac_xdp.h"
 #include <linux/reset.h>
 #include <linux/of_mdio.h>
 #include "dwmac1000.h"
@@ -67,6 +69,9 @@ MODULE_PARM_DESC(phyaddr, "Physical device address");
 #define STMMAC_TX_THRESH(x)	((x)->dma_tx_size / 4)
 #define STMMAC_RX_THRESH(x)	((x)->dma_rx_size / 4)
 
+#define STMMAC_XDP_PASS		0
+#define STMMAC_XDP_CONSUMED	BIT(0)
+
 static int flow_ctrl = FLOW_AUTO;
 module_param(flow_ctrl, int, 0644);
 MODULE_PARM_DESC(flow_ctrl, "Flow control ability [on/off]");
@@ -1384,6 +1389,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
 	if (!buf->page)
 		return -ENOMEM;
+	buf->page_offset = stmmac_rx_offset(priv);
 
 	if (priv->sph) {
 		buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
@@ -1397,7 +1403,8 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 	}
 
-	buf->addr = page_pool_get_dma_addr(buf->page);
+	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
+
 	stmmac_set_desc_addr(priv, p, buf->addr);
 	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
 		stmmac_init_desc3(priv, p);
@@ -1503,7 +1510,8 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 				if (!buf->page)
 					goto err_reinit_rx_buffers;
 
-				buf->addr = page_pool_get_dma_addr(buf->page);
+				buf->addr = page_pool_get_dma_addr(buf->page) +
+					    buf->page_offset;
 			}
 
 			if (priv->sph && !buf->sec_page) {
@@ -1821,6 +1829,7 @@ static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
  */
 static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 {
+	bool xdp_prog = stmmac_xdp_is_enabled(priv);
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	int ret = -ENOMEM;
 	u32 queue;
@@ -1834,13 +1843,15 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 		rx_q->queue_index = queue;
 		rx_q->priv_data = priv;
 
-		pp_params.flags = PP_FLAG_DMA_MAP;
+		pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pp_params.pool_size = priv->dma_rx_size;
 		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
 		pp_params.order = ilog2(num_pages);
 		pp_params.nid = dev_to_node(priv->device);
 		pp_params.dev = priv->device;
-		pp_params.dma_dir = DMA_FROM_DEVICE;
+		pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+		pp_params.offset = stmmac_rx_offset(priv);
+		pp_params.max_len = STMMAC_MAX_RX_BUF_SIZE(num_pages);
 
 		rx_q->page_pool = page_pool_create(&pp_params);
 		if (IS_ERR(rx_q->page_pool)) {
@@ -3268,7 +3279,7 @@ static int stmmac_request_irq(struct net_device *dev)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_open(struct net_device *dev)
+int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int bfsize = 0;
@@ -3391,7 +3402,7 @@ static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
  *  Description:
  *  This is the stop entry point of the driver.
  */
-static int stmmac_release(struct net_device *dev)
+int stmmac_release(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
@@ -4064,11 +4075,9 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-	int len, dirty = stmmac_rx_dirty(priv, queue);
+	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int entry = rx_q->dirty_rx;
 
-	len = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
-
 	while (dirty-- > 0) {
 		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[entry];
 		struct dma_desc *p;
@@ -4091,18 +4100,9 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 				break;
 
 			buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
-
-			dma_sync_single_for_device(priv->device, buf->sec_addr,
-						   len, DMA_FROM_DEVICE);
 		}
 
-		buf->addr = page_pool_get_dma_addr(buf->page);
-
-		/* Sync whole allocation to device. This will invalidate old
-		 * data.
-		 */
-		dma_sync_single_for_device(priv->device, buf->addr, len,
-					   DMA_FROM_DEVICE);
+		buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
 
 		stmmac_set_desc_addr(priv, p, buf->addr);
 		if (priv->sph)
@@ -4181,6 +4181,42 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	return plen - len;
 }
 
+static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
+					   struct xdp_buff *xdp)
+{
+	struct bpf_prog *prog;
+	int res;
+	u32 act;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(priv->xdp_prog);
+	if (!prog) {
+		res = STMMAC_XDP_PASS;
+		goto unlock;
+	}
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		res = STMMAC_XDP_PASS;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(priv->dev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		res = STMMAC_XDP_CONSUMED;
+		break;
+	}
+
+unlock:
+	rcu_read_unlock();
+	return ERR_PTR(-res);
+}
+
 /**
  * stmmac_rx - manage the receive process
  * @priv: driver private structure
@@ -4196,8 +4232,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
+	enum dma_data_direction dma_dir;
 	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
+	struct xdp_buff xdp;
+	int buf_sz;
+
+	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
+	buf_sz = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -4315,6 +4357,45 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 		if (!skb) {
+			dma_sync_single_for_cpu(priv->device, buf->addr,
+						buf1_len, dma_dir);
+
+			xdp.data = page_address(buf->page) + buf->page_offset;
+			xdp.data_end = xdp.data + buf1_len;
+			xdp.data_hard_start = page_address(buf->page);
+			xdp_set_data_meta_invalid(&xdp);
+			xdp.frame_sz = buf_sz;
+
+			skb = stmmac_xdp_run_prog(priv, &xdp);
+
+			/* For Not XDP_PASS verdict */
+			if (IS_ERR(skb)) {
+				unsigned int xdp_res = -PTR_ERR(skb);
+
+				if (xdp_res & STMMAC_XDP_CONSUMED) {
+					page_pool_recycle_direct(rx_q->page_pool,
+								 buf->page);
+					buf->page = NULL;
+					priv->dev->stats.rx_dropped++;
+
+					/* Clear skb as it was set as
+					 * status by XDP program.
+					 */
+					skb = NULL;
+
+					if (unlikely((status & rx_not_ls)))
+						goto read_again;
+
+					count++;
+					continue;
+				}
+			}
+		}
+
+		if (!skb) {
+			/* XDP program may expand or reduce tail */
+			buf1_len = xdp.data_end - xdp.data;
+
 			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
@@ -4322,10 +4403,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 				goto drain_data;
 			}
 
-			dma_sync_single_for_cpu(priv->device, buf->addr,
-						buf1_len, DMA_FROM_DEVICE);
-			skb_copy_to_linear_data(skb, page_address(buf->page),
-						buf1_len);
+			/* XDP program may adjust header */
+			skb_copy_to_linear_data(skb, xdp.data, buf1_len);
 			skb_put(skb, buf1_len);
 
 			/* Data payload copied into SKB, page ready for recycle */
@@ -4333,9 +4412,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
-						buf1_len, DMA_FROM_DEVICE);
+						buf1_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-					buf->page, 0, buf1_len,
+					buf->page, buf->page_offset, buf1_len,
 					priv->dma_buf_sz);
 
 			/* Data payload appended into SKB */
@@ -4345,7 +4424,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		if (buf2_len) {
 			dma_sync_single_for_cpu(priv->device, buf->sec_addr,
-						buf2_len, DMA_FROM_DEVICE);
+						buf2_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					buf->sec_page, 0, buf2_len,
 					priv->dma_buf_sz);
@@ -4503,6 +4582,11 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 		return -EBUSY;
 	}
 
+	if (stmmac_xdp_is_enabled(priv) && new_mtu > ETH_DATA_LEN) {
+		netdev_dbg(priv->dev, "Jumbo frames not supported for XDP\n");
+		return -EINVAL;
+	}
+
 	new_mtu = STMMAC_ALIGN(new_mtu);
 
 	/* If condition true, FIFO is too small or MTU too large */
@@ -4564,6 +4648,7 @@ static int stmmac_set_features(struct net_device *netdev,
 	stmmac_rx_ipc(priv, priv->hw);
 
 	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
+
 	for (chan = 0; chan < priv->plat->rx_queues_to_use; chan++)
 		stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
 
@@ -5299,6 +5384,18 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	return ret;
 }
 
+static int stmmac_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return stmmac_xdp_set_prog(priv, bpf->prog, bpf->extack);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_open = stmmac_open,
 	.ndo_start_xmit = stmmac_xmit,
@@ -5317,6 +5414,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_set_mac_address = stmmac_set_mac_address,
 	.ndo_vlan_rx_add_vid = stmmac_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = stmmac_vlan_rx_kill_vid,
+	.ndo_bpf = stmmac_bpf,
 };
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
new file mode 100644
index 000000000000..bf38d231860b
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Intel Corporation. */
+
+#include "stmmac.h"
+#include "stmmac_xdp.h"
+
+int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = priv->dev;
+	struct bpf_prog *old_prog;
+	bool need_update;
+	bool if_running;
+
+	if_running = netif_running(dev);
+
+	if (prog && dev->mtu > ETH_DATA_LEN) {
+		/* For now, the driver doesn't support XDP functionality with
+		 * jumbo frames so we return error.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported");
+		return -EOPNOTSUPP;
+	}
+
+	need_update = !!priv->xdp_prog != !!prog;
+	if (if_running && need_update)
+		stmmac_release(dev);
+
+	old_prog = xchg(&priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	/* Disable RX SPH for XDP operation */
+	priv->sph = priv->sph_cap && !stmmac_xdp_is_enabled(priv);
+
+	if (if_running && need_update)
+		stmmac_open(dev);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
new file mode 100644
index 000000000000..93948569d92a
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Intel Corporation. */
+
+#ifndef _STMMAC_XDP_H_
+#define _STMMAC_XDP_H_
+
+#define STMMAC_MAX_RX_BUF_SIZE(num)	(((num) * PAGE_SIZE) - XDP_PACKET_HEADROOM)
+
+int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack);
+
+#endif /* _STMMAC_XDP_H_ */
-- 
2.25.1

