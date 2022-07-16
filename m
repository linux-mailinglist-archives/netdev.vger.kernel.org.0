Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE10F576C5C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 09:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiGPHfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 03:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiGPHe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 03:34:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4A931347
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A114B82F58
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 07:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DDBC34115;
        Sat, 16 Jul 2022 07:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657956894;
        bh=NHd755F3N2/ebbGtNQQuTXRHMUr/M3F8SP+zTFWbdKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtOssgB6T/DX7PS1ni6BgV5d6xPYUxUxw4FYZvZh+g2CFTvCtg7t3JX7Q/gTES4MP
         PugZr17NcEbhHixAJ1COK/nPDZLGt44htRVnlT9iUEPzA9wpZEndYYMBvVRCJ45WBV
         XDps8txxX5CgyBgCQ9KlrGXx0250GWpVLim5IKyTS6ZteMLBip74SnyVgY8W3ZQNPA
         5wHGCjX90GvqLILW1t1RLFr1IAR3dMP+xiPMAk6h/8dY6yAhnX/y7/iiS0GKhFhPYB
         yQS1/dAIohyMACDSbT+aigtgSpHf4tb3xKLBvUeEGioLuxNmLNxS442aReeSAA8dzA
         0D9DrZtsySosw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v3 net-next 2/5] net: ethernet: mtk_eth_soc: add basic XDP support
Date:   Sat, 16 Jul 2022 09:34:28 +0200
Message-Id: <b4c7646e70b1b719b8ae87a90bb8e4cf57b1a26d.1657956652.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657956652.git.lorenzo@kernel.org>
References: <cover.1657956652.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce basic XDP support to mtk_eth_soc driver.
Supported XDP verdicts:
- XDP_PASS
- XDP_DROP
- XDP_REDIRECT

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 147 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |   2 +
 2 files changed, 131 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9a92d602ebd5..bc3a7dcab207 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1494,11 +1494,44 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
 		skb_free_frag(data);
 }
 
+static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
+		       struct xdp_buff *xdp, struct net_device *dev)
+{
+	struct bpf_prog *prog = rcu_dereference(eth->prog);
+	u32 act;
+
+	if (!prog)
+		return XDP_PASS;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		return XDP_PASS;
+	case XDP_REDIRECT:
+		if (unlikely(xdp_do_redirect(dev, xdp, prog)))
+			break;
+		return XDP_REDIRECT;
+	default:
+		bpf_warn_invalid_xdp_action(dev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		break;
+	}
+
+	page_pool_put_full_page(ring->page_pool,
+				virt_to_head_page(xdp->data), true);
+	return XDP_DROP;
+}
+
 static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		       struct mtk_eth *eth)
 {
 	struct dim_sample dim_sample = {};
 	struct mtk_rx_ring *ring;
+	bool xdp_flush = false;
 	int idx;
 	struct sk_buff *skb;
 	u8 *data, *new_data;
@@ -1507,9 +1540,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
-		u32 hash, reason, reserve_len;
 		struct net_device *netdev;
 		dma_addr_t dma_addr;
+		u32 hash, reason;
 		int mac = 0;
 
 		ring = mtk_get_rx_ring(eth);
@@ -1539,8 +1572,14 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
 			goto release_desc;
 
+		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
+
 		/* alloc new buffer */
 		if (ring->page_pool) {
+			struct page *page = virt_to_head_page(data);
+			struct xdp_buff xdp;
+			u32 ret;
+
 			new_data = mtk_page_pool_get_buff(ring->page_pool,
 							  &dma_addr,
 							  GFP_ATOMIC);
@@ -1548,6 +1587,34 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 				netdev->stats.rx_dropped++;
 				goto release_desc;
 			}
+
+			dma_sync_single_for_cpu(eth->dma_dev,
+				page_pool_get_dma_addr(page) + MTK_PP_HEADROOM,
+				pktlen, page_pool_get_dma_dir(ring->page_pool));
+
+			xdp_init_buff(&xdp, PAGE_SIZE, &ring->xdp_q);
+			xdp_prepare_buff(&xdp, data, MTK_PP_HEADROOM, pktlen,
+					 false);
+			xdp_buff_clear_frags_flag(&xdp);
+
+			ret = mtk_xdp_run(eth, ring, &xdp, netdev);
+			if (ret == XDP_REDIRECT)
+				xdp_flush = true;
+
+			if (ret != XDP_PASS)
+				goto skip_rx;
+
+			skb = build_skb(data, PAGE_SIZE);
+			if (unlikely(!skb)) {
+				page_pool_put_full_page(ring->page_pool,
+							page, true);
+				netdev->stats.rx_dropped++;
+				goto skip_rx;
+			}
+
+			skb_reserve(skb, xdp.data - xdp.data_hard_start);
+			skb_put(skb, xdp.data_end - xdp.data);
+			skb_mark_for_recycle(skb);
 		} else {
 			if (ring->frag_size <= PAGE_SIZE)
 				new_data = napi_alloc_frag(ring->frag_size);
@@ -1571,27 +1638,20 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 			dma_unmap_single(eth->dma_dev, trxd.rxd1,
 					 ring->buf_size, DMA_FROM_DEVICE);
-		}
 
-		/* receive data */
-		skb = build_skb(data, ring->frag_size);
-		if (unlikely(!skb)) {
-			mtk_rx_put_buff(ring, data, true);
-			netdev->stats.rx_dropped++;
-			goto skip_rx;
-		}
+			skb = build_skb(data, ring->frag_size);
+			if (unlikely(!skb)) {
+				netdev->stats.rx_dropped++;
+				skb_free_frag(data);
+				goto skip_rx;
+			}
 
-		if (ring->page_pool) {
-			reserve_len = MTK_PP_HEADROOM;
-			skb_mark_for_recycle(skb);
-		} else {
-			reserve_len = NET_SKB_PAD + NET_IP_ALIGN;
+			skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
+			skb_put(skb, pktlen);
 		}
-		skb_reserve(skb, reserve_len);
 
-		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
-		skb_put(skb, pktlen);
+		bytes += skb->len;
 
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
 			rxdcsum = &trxd.rxd3;
@@ -1603,7 +1663,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		else
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
-		bytes += pktlen;
 
 		hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
 		if (hash != MTK_RXD4_FOE_ENTRY) {
@@ -1666,6 +1725,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			  &dim_sample);
 	net_dim(&eth->rx_dim, dim_sample);
 
+	if (xdp_flush)
+		xdp_do_flush_map();
+
 	return done;
 }
 
@@ -2750,6 +2812,48 @@ static int mtk_stop(struct net_device *dev)
 	return 0;
 }
 
+static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
+			 struct netlink_ext_ack *extack)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	struct bpf_prog *old_prog;
+	bool need_update;
+
+	if (eth->hwlro) {
+		NL_SET_ERR_MSG_MOD(extack, "XDP not supported with HWLRO");
+		return -EOPNOTSUPP;
+	}
+
+	if (dev->mtu > MTK_PP_MAX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	need_update = !!eth->prog != !!prog;
+	if (netif_running(dev) && need_update)
+		mtk_stop(dev);
+
+	old_prog = rcu_replace_pointer(eth->prog, prog, lockdep_rtnl_is_held());
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (netif_running(dev) && need_update)
+		return mtk_open(dev);
+
+	return 0;
+}
+
+static int mtk_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return mtk_xdp_setup(dev, xdp->prog, xdp->extack);
+	default:
+		return -EINVAL;
+	}
+}
+
 static void ethsys_reset(struct mtk_eth *eth, u32 reset_bits)
 {
 	regmap_update_bits(eth->ethsys, ETHSYS_RSTCTRL,
@@ -3045,6 +3149,12 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	struct mtk_eth *eth = mac->hw;
 	u32 mcr_cur, mcr_new;
 
+	if (rcu_access_pointer(eth->prog) &&
+	    length > MTK_PP_MAX_BUF_SIZE) {
+		netdev_err(dev, "Invalid MTU for XDP mode\n");
+		return -EINVAL;
+	}
+
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
 		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
@@ -3372,6 +3482,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 	.ndo_poll_controller	= mtk_poll_controller,
 #endif
 	.ndo_setup_tc		= mtk_eth_setup_tc,
+	.ndo_bpf		= mtk_xdp,
 };
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 26c019319055..cfb7aeda3f49 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1088,6 +1088,8 @@ struct mtk_eth {
 
 	struct mtk_ppe			*ppe;
 	struct rhashtable		flow_table;
+
+	struct bpf_prog			__rcu *prog;
 };
 
 /* struct mtk_mac -	the structure that holds the info about the MACs of the
-- 
2.36.1

