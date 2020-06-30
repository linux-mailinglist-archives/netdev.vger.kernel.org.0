Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBDA20FB79
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390678AbgF3SNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:13:43 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:40248 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgF3SNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:13:42 -0400
Received: by mail-ej1-f67.google.com with SMTP id o18so17147612eje.7;
        Tue, 30 Jun 2020 11:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glYWAxujLQE1jaJowzApJfD70Gisd5SEICDZaibEPbQ=;
        b=GRAoMTB+VfwaLTK8PJOfZg6dcsmOST0lvMHmqHxRFfPO2w2e+d2E7OzU79YH07ixKK
         CfbLp4YvazkWLuR1igcssbYxh7Ftxee0bdEC7x922yS1uoEMzfGzDwKw59gm4ZPt7gjU
         25Cy5iXHmC0pX7SCm1AhFkkpgZdvqSXharXTbN/I/bhqZoL0dzcA6vZnzszKScXPflB+
         iNipvI15FU3AnTbOAeUKmLuluk0EqloaIxU2A0VWenzA25W8G0yUcd4I+eXHnUDCj50H
         Bc5ldKDDqf4qB0VKNT6yaWH/F1zuaTu8/W5/aY0cVuXyLPE26NvmTUEUxlpdAn0LKO5t
         yUUw==
X-Gm-Message-State: AOAM531NIIPWV+QCdglbuOT8C6XpGfeyel0OgXKu8uRKFB4KWo7u5OYx
        PxIblfDaREl8RCujIMDZqWLMoOcDGPe+Eg==
X-Google-Smtp-Source: ABdhPJzTf4qEZHVjzume2vhYuqnjN2XNZNezX6Duik5HAMB1ZXYt4yncRDY+/QZKEfdBaHGQakI5HQ==
X-Received: by 2002:a17:906:5496:: with SMTP id r22mr20120681ejo.449.1593540813619;
        Tue, 30 Jun 2020 11:13:33 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id d13sm2492313ejj.95.2020.06.30.11.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:13:32 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 3/4] mvpp2: add basic XDP support
Date:   Tue, 30 Jun 2020 20:09:29 +0200
Message-Id: <20200630180930.87506-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630180930.87506-1-mcroce@linux.microsoft.com>
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Add XDP native support.
By now only XDP_DROP, XDP_PASS and XDP_REDIRECT
verdicts are supported.

Co-developed-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  28 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 166 +++++++++++++++++-
 2 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4c16c9e9c1e5..f351e41c9da6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -16,6 +16,18 @@
 #include <linux/phylink.h>
 #include <net/flow_offload.h>
 #include <net/page_pool.h>
+#include <linux/bpf.h>
+#include <net/xdp.h>
+
+/* The PacketOffset field is measured in units of 32 bytes and is 3 bits wide,
+ * so the maximum offset is 7 * 32 = 224
+ */
+#define MVPP2_SKB_HEADROOM	min(max(XDP_PACKET_HEADROOM, NET_SKB_PAD), 224)
+
+#define MVPP2_XDP_PASS		0
+#define MVPP2_XDP_DROPPED	BIT(0)
+#define MVPP2_XDP_TX		BIT(1)
+#define MVPP2_XDP_REDIR		BIT(2)
 
 /* Fifo Registers */
 #define MVPP2_RX_DATA_FIFO_SIZE_REG(port)	(0x00 + 4 * (port))
@@ -629,10 +641,12 @@
 	ALIGN((mtu) + MVPP2_MH_SIZE + MVPP2_VLAN_TAG_LEN + \
 	      ETH_HLEN + ETH_FCS_LEN, cache_line_size())
 
-#define MVPP2_RX_BUF_SIZE(pkt_size)	((pkt_size) + NET_SKB_PAD)
+#define MVPP2_RX_BUF_SIZE(pkt_size)	((pkt_size) + MVPP2_SKB_HEADROOM)
 #define MVPP2_RX_TOTAL_SIZE(buf_size)	((buf_size) + MVPP2_SKB_SHINFO_SIZE)
 #define MVPP2_RX_MAX_PKT_SIZE(total_size) \
-	((total_size) - NET_SKB_PAD - MVPP2_SKB_SHINFO_SIZE)
+	((total_size) - MVPP2_SKB_HEADROOM - MVPP2_SKB_SHINFO_SIZE)
+
+#define MVPP2_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVPP2_SKB_SHINFO_SIZE - MVPP2_SKB_HEADROOM)
 
 #define MVPP2_BIT_TO_BYTE(bit)		((bit) / 8)
 #define MVPP2_BIT_TO_WORD(bit)		((bit) / 32)
@@ -690,9 +704,9 @@ enum mvpp2_prs_l3_cast {
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
 #define MVPP2_BM_COOKIE_CPU_OFFS	24
 
-#define MVPP2_BM_SHORT_FRAME_SIZE		512
-#define MVPP2_BM_LONG_FRAME_SIZE		2048
-#define MVPP2_BM_JUMBO_FRAME_SIZE		10240
+#define MVPP2_BM_SHORT_FRAME_SIZE	704	/* frame size 128 */
+#define MVPP2_BM_LONG_FRAME_SIZE	2240	/* frame size 1664 */
+#define MVPP2_BM_JUMBO_FRAME_SIZE	10432	/* frame size 9856 */
 /* BM short pool packet size
  * These value assure that for SWF the total number
  * of bytes allocated for each buffer will be 512
@@ -913,6 +927,8 @@ struct mvpp2_port {
 	unsigned int ntxqs;
 	struct net_device *dev;
 
+	struct bpf_prog *xdp_prog;
+
 	int pkt_size;
 
 	/* Per-CPU port control */
@@ -932,6 +948,8 @@ struct mvpp2_port {
 	struct mvpp2_pcpu_stats __percpu *stats;
 	u64 *ethtool_stats;
 
+	unsigned long state;
+
 	/* Per-port work and its lock to gather hardware statistics */
 	struct mutex gather_stats_lock;
 	struct delayed_work stats_work;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9e2e8fb0a0b8..864d4789a0b3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -36,6 +36,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tso.h>
+#include <linux/bpf_trace.h>
 
 #include "mvpp2.h"
 #include "mvpp2_prs.h"
@@ -105,6 +106,7 @@ mvpp2_create_page_pool(struct device *dev, int num, int len)
 		.nid = NUMA_NO_NODE,
 		.dev = dev,
 		.dma_dir = DMA_FROM_DEVICE,
+		.offset = MVPP2_SKB_HEADROOM,
 		.max_len = len,
 	};
 
@@ -2463,7 +2465,7 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	put_cpu();
 
 	/* Set Offset */
-	mvpp2_rxq_offset_set(port, rxq->id, NET_SKB_PAD);
+	mvpp2_rxq_offset_set(port, rxq->id, MVPP2_SKB_HEADROOM);
 
 	/* Set coalescing pkts and time */
 	mvpp2_rx_pkts_coal_set(port, rxq);
@@ -3036,16 +3038,69 @@ static u32 mvpp2_skb_tx_csum(struct mvpp2_port *port, struct sk_buff *skb)
 	return MVPP2_TXD_L4_CSUM_NOT | MVPP2_TXD_IP_CSUM_DISABLE;
 }
 
+static int
+mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
+	      struct bpf_prog *prog, struct xdp_buff *xdp,
+	      struct page_pool *pp)
+{
+	unsigned int len, sync, err;
+	struct page *page;
+	u32 ret, act;
+
+	len = xdp->data_end - xdp->data_hard_start - MVPP2_SKB_HEADROOM;
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - MVPP2_SKB_HEADROOM;
+	sync = max(sync, len);
+
+	switch (act) {
+	case XDP_PASS:
+		ret = MVPP2_XDP_PASS;
+		break;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(port->dev, xdp, prog);
+		if (unlikely(err)) {
+			ret = MVPP2_XDP_DROPPED;
+			page = virt_to_head_page(xdp->data);
+			page_pool_put_page(pp, page, sync, true);
+		} else {
+			ret = MVPP2_XDP_REDIR;
+		}
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(port->dev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		page = virt_to_head_page(xdp->data);
+		page_pool_put_page(pp, page, sync, true);
+		ret = MVPP2_XDP_DROPPED;
+		break;
+	}
+
+	return ret;
+}
+
 /* Main rx processing */
 static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		    int rx_todo, struct mvpp2_rx_queue *rxq)
 {
 	struct net_device *dev = port->dev;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
 	int rx_received;
 	int rx_done = 0;
+	u32 xdp_ret = 0;
 	u32 rcvd_pkts = 0;
 	u32 rcvd_bytes = 0;
 
+	rcu_read_lock();
+
+	xdp_prog = READ_ONCE(port->xdp_prog);
+
 	/* Get number of received packets and clamp the to-do */
 	rx_received = mvpp2_rxq_received(port, rxq->id);
 	if (rx_todo > rx_received)
@@ -3060,7 +3115,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		dma_addr_t dma_addr;
 		phys_addr_t phys_addr;
 		u32 rx_status;
-		int pool, rx_bytes, err;
+		int pool, rx_bytes, err, ret;
 		void *data;
 
 		rx_done++;
@@ -3096,6 +3151,33 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		else
 			frag_size = bm_pool->frag_size;
 
+		if (xdp_prog) {
+			xdp.data_hard_start = data;
+			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
+			xdp.data_end = xdp.data + rx_bytes;
+			xdp.frame_sz = PAGE_SIZE;
+
+			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
+				xdp.rxq = &rxq->xdp_rxq_short;
+			else
+				xdp.rxq = &rxq->xdp_rxq_long;
+
+			xdp_set_data_meta_invalid(&xdp);
+
+			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp);
+
+			if (ret) {
+				xdp_ret |= ret;
+				err = mvpp2_rx_refill(port, bm_pool, pp, pool);
+				if (err) {
+					netdev_err(port->dev, "failed to refill BM pools\n");
+					goto err_drop_frame;
+				}
+
+				continue;
+			}
+		}
+
 		skb = build_skb(data, frag_size);
 		if (!skb) {
 			netdev_warn(port->dev, "skb build failed\n");
@@ -3118,7 +3200,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		rcvd_pkts++;
 		rcvd_bytes += rx_bytes;
 
-		skb_reserve(skb, MVPP2_MH_SIZE + NET_SKB_PAD);
+		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
 		skb->protocol = eth_type_trans(skb, dev);
 		mvpp2_rx_csum(port, rx_status, skb);
@@ -3133,6 +3215,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
 	}
 
+	rcu_read_unlock();
+
 	if (rcvd_pkts) {
 		struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 
@@ -3608,6 +3692,8 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 	}
 
 	netif_tx_start_all_queues(port->dev);
+
+	clear_bit(0, &port->state);
 }
 
 /* Set hw internals when stopping port */
@@ -3615,6 +3701,8 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
 {
 	int i;
 
+	set_bit(0, &port->state);
+
 	/* Disable interrupts on all threads */
 	mvpp2_interrupts_disable(port);
 
@@ -4021,6 +4109,10 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 	}
 
 	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
+		if (port->xdp_prog) {
+			netdev_err(dev, "Jumbo frames are not supported with XDP\n");
+			return -EINVAL;
+		}
 		if (priv->percpu_pools) {
 			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
 			mvpp2_bm_switch_buffers(priv, false);
@@ -4159,6 +4251,73 @@ static int mvpp2_set_features(struct net_device *dev,
 	return 0;
 }
 
+static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
+{
+	struct bpf_prog *prog = bpf->prog, *old_prog;
+	bool running = netif_running(port->dev);
+	bool reset = !prog != !port->xdp_prog;
+
+	if (port->dev->mtu > ETH_DATA_LEN) {
+		netdev_err(port->dev, "Jumbo frames are not supported by XDP, current MTU %d.\n",
+			   port->dev->mtu);
+		return -EOPNOTSUPP;
+	}
+
+	if (!port->priv->percpu_pools) {
+		netdev_err(port->dev, "Per CPU Pools required for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	/* device is up and bpf is added/removed, must setup the RX queues */
+	if (running && reset) {
+		mvpp2_stop_dev(port);
+		mvpp2_cleanup_rxqs(port);
+		mvpp2_cleanup_txqs(port);
+	}
+
+	old_prog = xchg(&port->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	/* bpf is just replaced, RXQ and MTU are already setup */
+	if (!reset)
+		return 0;
+
+	/* device was up, restore the link */
+	if (running) {
+		int ret = mvpp2_setup_rxqs(port);
+
+		if (ret) {
+			netdev_err(port->dev, "mvpp2_setup_rxqs failed\n");
+			return ret;
+		}
+		ret = mvpp2_setup_txqs(port);
+		if (ret) {
+			netdev_err(port->dev, "mvpp2_setup_txqs failed\n");
+			return ret;
+		}
+
+		mvpp2_start_dev(port);
+	}
+
+	return 0;
+}
+
+static int mvpp2_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return mvpp2_xdp_setup(port, xdp);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = port->xdp_prog ? port->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /* Ethtool methods */
 
 static int mvpp2_ethtool_nway_reset(struct net_device *dev)
@@ -4509,6 +4668,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= mvpp2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
 	.ndo_set_features	= mvpp2_set_features,
+	.ndo_bpf		= mvpp2_xdp,
 };
 
 static const struct ethtool_ops mvpp2_eth_tool_ops = {
-- 
2.26.2

