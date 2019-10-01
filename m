Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C06C3021
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfJAJZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfJAJZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:25:03 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C08421855;
        Tue,  1 Oct 2019 09:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569921901;
        bh=tExOiJQx568RhWtZhNxAxukqmrAK/b4Qr29pnqpxPaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aq0WlN0njDYLS/dVLOj43h7CgdiGOz74FX4gE5trmssVBS/qrYFsE0do6wutGgwxO
         cvwpfD8qrn9NfgHoyLXyUZcqrUabh7KKSyz1oON5SFz8le/lSRpp1hcsLO6wDyb1or
         U67gj9zH2XfLckf9fXamOs0LTJXNfYoQsaJpC/aM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com, mcroce@redhat.com
Subject: [RFC 3/4] net: mvneta: add basic XDP support
Date:   Tue,  1 Oct 2019 11:24:43 +0200
Message-Id: <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1569920973.git.lorenzo@kernel.org>
References: <cover.1569920973.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic XDP support to mvneta driver for devices that rely on software
buffer management. Currently supported verdicts are:
- XDP_DROP
- XDP_PASS
- XDP_REDIRECT

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 145 ++++++++++++++++++++++++--
 1 file changed, 136 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e842c744e4f3..f2d12556efa8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -38,6 +38,7 @@
 #include <net/ipv6.h>
 #include <net/tso.h>
 #include <net/page_pool.h>
+#include <linux/bpf_trace.h>
 
 /* Registers */
 #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
@@ -323,8 +324,10 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
 
+#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
+				 NET_IP_ALIGN)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
-			 NET_SKB_PAD))
+			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
 #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
 
@@ -352,6 +355,11 @@ struct mvneta_statistic {
 #define T_REG_64	64
 #define T_SW		1
 
+#define MVNETA_XDP_PASS		BIT(0)
+#define MVNETA_XDP_CONSUMED	BIT(1)
+#define MVNETA_XDP_TX		BIT(2)
+#define MVNETA_XDP_REDIR	BIT(3)
+
 static const struct mvneta_statistic mvneta_statistics[] = {
 	{ 0x3000, T_REG_64, "good_octets_received", },
 	{ 0x3010, T_REG_32, "good_frames_received", },
@@ -431,6 +439,8 @@ struct mvneta_port {
 	u32 cause_rx_tx;
 	struct napi_struct napi;
 
+	struct bpf_prog *xdp_prog;
+
 	/* Core clock */
 	struct clk *clk;
 	/* AXI clock */
@@ -611,6 +621,7 @@ struct mvneta_rx_queue {
 
 	/* page_pool */
 	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
 
 	/* Virtual address of the RX buffer */
 	void  **buf_virt_addr;
@@ -1897,6 +1908,8 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 
 		page_pool_put_page(rxq->page_pool, data, false);
 	}
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 	page_pool_destroy(rxq->page_pool);
 }
 
@@ -1925,16 +1938,52 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 	return i;
 }
 
+static int
+mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
+	       struct xdp_buff *xdp)
+{
+	u32 ret = bpf_prog_run_xdp(prog, xdp);
+	int err;
+
+	switch (ret) {
+	case XDP_PASS:
+		return MVNETA_XDP_PASS;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(pp->dev, xdp, prog);
+		if (err) {
+			xdp_return_buff(xdp);
+			return MVNETA_XDP_CONSUMED;
+		}
+		return MVNETA_XDP_REDIR;
+	default:
+		bpf_warn_invalid_xdp_action(ret);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(pp->dev, prog, ret);
+		/* fall through */
+	case XDP_DROP:
+		xdp_return_buff(xdp);
+		return MVNETA_XDP_CONSUMED;
+	}
+}
+
 static int
 mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
+		     struct bpf_prog *xdp_prog,
 		     struct page *page)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
+	struct xdp_buff xdp = {
+		.data_hard_start = data,
+		.data = data + MVNETA_SKB_HEADROOM,
+		.rxq = &rxq->xdp_rxq,
+	};
+	xdp_set_data_meta_invalid(&xdp);
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -1943,13 +1992,24 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		len = rx_desc->data_size;
 		data_len += (len - ETH_FCS_LEN);
 	}
+	xdp.data_end = xdp.data + data_len;
 
 	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
 	dma_sync_single_range_for_cpu(dev->dev.parent,
 				      rx_desc->buf_phys_addr, 0,
 				      len, dma_dir);
 
-	rxq->skb = build_skb(data, PAGE_SIZE);
+	if (xdp_prog) {
+		int ret;
+
+		ret = mvneta_run_xdp(pp, xdp_prog, &xdp);
+		if (ret != MVNETA_XDP_PASS) {
+			rx_desc->buf_phys_addr = 0;
+			return -EAGAIN;
+		}
+	}
+
+	rxq->skb = build_skb(xdp.data_hard_start, PAGE_SIZE);
 	if (unlikely(!rxq->skb)) {
 		netdev_err(dev,
 			   "Can't allocate skb on queue %d\n",
@@ -1959,8 +2019,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		return -ENOMEM;
 	}
 
-	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
-	skb_put(rxq->skb, data_len);
+	skb_reserve(rxq->skb,
+		    MVNETA_MH_SIZE + xdp.data - xdp.data_hard_start);
+	skb_put(rxq->skb, xdp.data_end - xdp.data);
 	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
 
 	page_pool_release_page(rxq->page_pool, page);
@@ -1995,7 +2056,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		/* refill descriptor with new buffer later */
 		skb_add_rx_frag(rxq->skb,
 				skb_shinfo(rxq->skb)->nr_frags,
-				page, NET_SKB_PAD, data_len,
+				page, MVNETA_SKB_HEADROOM, data_len,
 				PAGE_SIZE);
 
 		page_pool_release_page(rxq->page_pool, page);
@@ -2011,10 +2072,14 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rcvd_pkts = 0, rcvd_bytes = 0;
 	int rx_todo, rx_proc = 0, refill;
+	struct bpf_prog *xdp_prog;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
+	rcu_read_lock();
+	xdp_prog = READ_ONCE(pp->xdp_prog);
+
 	/* Fairness NAPI loop */
 	while (rcvd_pkts < budget && rx_proc < rx_todo) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
@@ -2029,6 +2094,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		prefetch(data);
 
 		rxq->refill_num++;
+		rcvd_pkts++;
 		rx_proc++;
 
 		if (rx_desc->status & MVNETA_RXD_FIRST_DESC) {
@@ -2042,7 +2108,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				continue;
 			}
 
-			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
+			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq,
+						   xdp_prog, page);
 			if (err < 0)
 				continue;
 		} else {
@@ -2066,7 +2133,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			rxq->skb = NULL;
 			continue;
 		}
-		rcvd_pkts++;
 		rcvd_bytes += rxq->skb->len;
 
 		/* Linux processing */
@@ -2077,6 +2143,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		/* clean uncomplete skb pointer in queue */
 		rxq->skb = NULL;
 	}
+	rcu_read_unlock();
 
 	if (rcvd_pkts) {
 		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
@@ -2836,14 +2903,16 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
 static int mvneta_create_page_pool(struct mvneta_port *pp,
 				   struct mvneta_rx_queue *rxq, int size)
 {
+	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.flags = PP_FLAG_DMA_MAP,
 		.pool_size = size,
 		.nid = cpu_to_node(0),
 		.dev = pp->dev->dev.parent,
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
 	};
+	int err;
 
 	rxq->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rxq->page_pool)) {
@@ -2851,7 +2920,22 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 		return PTR_ERR(rxq->page_pool);
 	}
 
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 rxq->page_pool);
+	if (err)
+		goto err_unregister_pp;
+
 	return 0;
+
+err_unregister_pp:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(rxq->page_pool);
+	return err;
 }
 
 /* Handle rxq fill: allocates rxq skbs; called when initializing a port */
@@ -3291,6 +3375,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
+		return -EINVAL;
+	}
+
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -3960,6 +4049,43 @@ static int mvneta_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return phylink_mii_ioctl(pp->phylink, ifr, cmd);
 }
 
+static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
+			    struct netlink_ext_ack *extack)
+{
+	struct mvneta_port *pp = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+
+	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
+		return -EOPNOTSUPP;
+	}
+
+	mvneta_stop(dev);
+
+	old_prog = xchg(&pp->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	mvneta_open(dev);
+
+	return 0;
+}
+
+static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct mvneta_port *pp = netdev_priv(dev);
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /* Ethtool methods */
 
 /* Set link ksettings (phy address, speed) for ethtools */
@@ -4356,6 +4482,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_fix_features    = mvneta_fix_features,
 	.ndo_get_stats64     = mvneta_get_stats64,
 	.ndo_do_ioctl        = mvneta_ioctl,
+	.ndo_bpf	     = mvneta_xdp,
 };
 
 static const struct ethtool_ops mvneta_eth_tool_ops = {
@@ -4646,7 +4773,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	pp->id = global_port_id++;
-	pp->rx_offset_correction = NET_SKB_PAD;
+	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
-- 
2.21.0

