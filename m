Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2ED9C29
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437343AbfJPVDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfJPVDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 17:03:45 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0B8218DE;
        Wed, 16 Oct 2019 21:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571259824;
        bh=wkRfpUlZsgy8+D2R0vEE308/etcUH+zT7SZMeXBRGnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdaZuZpMC6eGvK1votsVbKIWra8mVJQ9fQneyX/L3sdYtLEPlLuTQArStpce1oFry
         /n3V62g8EqrCuB1RhdPXLYRnegJzKg/G5VvLjD68pnj1/EO/GadJ61sWsvgkiZUyws
         Vxz14qrS9/HIaYFskcJU5PbdxZoIDsTAnEdi1KGM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v4 net-next 4/7] net: mvneta: add basic XDP support
Date:   Wed, 16 Oct 2019 23:03:09 +0200
Message-Id: <30b6fad4fe5411e092171bb825f7a6ce0041d63e.1571258793.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571258792.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
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
- XDP_ABORTED

- iptables drop:
$iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
$nstat -n && sleep 1 && nstat
IpInReceives		151169		0.0
IpExtInOctets		6953544		0.0
IpExtInNoECTPkts	151165		0.0

- XDP_DROP via xdp1
$./samples/bpf/xdp1 3
proto 0:	421419 pkt/s
proto 0:	421444 pkt/s
proto 0:	421393 pkt/s
proto 0:	421440 pkt/s
proto 0:	421184 pkt/s

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 146 ++++++++++++++++++++++++--
 1 file changed, 137 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2f8123224f6e..3b2c65a7c474 100644
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
+#define MVNETA_XDP_DROPPED	BIT(1)
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
@@ -1950,11 +1960,51 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 	return i;
 }
 
+static int
+mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
+	       struct bpf_prog *prog, struct xdp_buff *xdp)
+{
+	u32 ret, act = bpf_prog_run_xdp(prog, xdp);
+
+	switch (act) {
+	case XDP_PASS:
+		ret = MVNETA_XDP_PASS;
+		break;
+	case XDP_REDIRECT: {
+		int err;
+
+		err = xdp_do_redirect(pp->dev, xdp, prog);
+		if (err) {
+			ret = MVNETA_XDP_DROPPED;
+			xdp_return_buff(xdp);
+		} else {
+			ret = MVNETA_XDP_REDIR;
+		}
+		break;
+	}
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(pp->dev, prog, act);
+		/* fall through */
+	case XDP_DROP:
+		page_pool_recycle_direct(rxq->page_pool,
+					 virt_to_head_page(xdp->data));
+		ret = MVNETA_XDP_DROPPED;
+		break;
+	}
+
+	return ret;
+}
+
 static int
 mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
-		     struct page *page)
+		     struct xdp_buff *xdp,
+		     struct bpf_prog *xdp_prog,
+		     struct page *page, u32 *xdp_ret)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
@@ -1974,7 +2024,26 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 				rx_desc->buf_phys_addr,
 				len, dma_dir);
 
-	rxq->skb = build_skb(data, PAGE_SIZE);
+	xdp->data_hard_start = data;
+	xdp->data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
+	xdp->data_end = xdp->data + data_len;
+	xdp_set_data_meta_invalid(xdp);
+
+	if (xdp_prog) {
+		u32 ret;
+
+		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp);
+		if (ret != MVNETA_XDP_PASS) {
+			mvneta_update_stats(pp, 1,
+					    xdp->data_end - xdp->data,
+					    false);
+			rx_desc->buf_phys_addr = 0;
+			*xdp_ret |= ret;
+			return ret;
+		}
+	}
+
+	rxq->skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (unlikely(!rxq->skb)) {
 		netdev_err(dev,
 			   "Can't allocate skb on queue %d\n",
@@ -1985,8 +2054,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	}
 	page_pool_release_page(rxq->page_pool, page);
 
-	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
-	skb_put(rxq->skb, data_len);
+	skb_reserve(rxq->skb,
+		    xdp->data - xdp->data_hard_start);
+	skb_put(rxq->skb, xdp->data_end - xdp->data);
 	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
 
 	rxq->left_size = rx_desc->data_size - len;
@@ -2020,7 +2090,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		/* refill descriptor with new buffer later */
 		skb_add_rx_frag(rxq->skb,
 				skb_shinfo(rxq->skb)->nr_frags,
-				page, NET_SKB_PAD, data_len,
+				page, MVNETA_SKB_HEADROOM, data_len,
 				PAGE_SIZE);
 	}
 	page_pool_release_page(rxq->page_pool, page);
@@ -2035,10 +2105,17 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 {
 	int rcvd_pkts = 0, rcvd_bytes = 0;
 	int rx_pending, refill, done = 0;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp_buf;
+	u32 xdp_ret = 0;
 
 	/* Get number of received packets */
 	rx_pending = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
+	rcu_read_lock();
+	xdp_prog = READ_ONCE(pp->xdp_prog);
+	xdp_buf.rxq = &rxq->xdp_rxq;
+
 	/* Fairness NAPI loop */
 	while (done < budget && done < rx_pending) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
@@ -2066,7 +2143,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				continue;
 			}
 
-			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
+			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
+						   xdp_prog, page, &xdp_ret);
 			if (err)
 				continue;
 		} else {
@@ -2101,6 +2179,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		/* clean uncomplete skb pointer in queue */
 		rxq->skb = NULL;
 	}
+	rcu_read_unlock();
+
+	if (xdp_ret & MVNETA_XDP_REDIR)
+		xdp_do_flush_map();
 
 	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
 
@@ -2842,13 +2924,14 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
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
 	int err;
 
@@ -3314,6 +3397,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
+		return -EINVAL;
+	}
+
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -3983,6 +4071,45 @@ static int mvneta_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
+	if (netif_running(dev))
+		mvneta_stop(dev);
+
+	old_prog = xchg(&pp->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (netif_running(dev))
+		return mvneta_open(dev);
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
@@ -4379,6 +4506,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_fix_features    = mvneta_fix_features,
 	.ndo_get_stats64     = mvneta_get_stats64,
 	.ndo_do_ioctl        = mvneta_ioctl,
+	.ndo_bpf	     = mvneta_xdp,
 };
 
 static const struct ethtool_ops mvneta_eth_tool_ops = {
@@ -4669,7 +4797,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	pp->id = global_port_id++;
-	pp->rx_offset_correction = NET_SKB_PAD;
+	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
-- 
2.21.0

