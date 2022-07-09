Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A582356CA68
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 17:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGIPtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 11:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGIPtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 11:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0AF1B79D
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 08:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 257A2B81D70
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 15:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7185AC3411C;
        Sat,  9 Jul 2022 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657381749;
        bh=r/ckwteeU4n31SNghq1UbYZc6OzjXDY8HlYjXZYVEgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR99XkfRPbxSFR3H6lAVfHK4ZHkecpsilNkdi+dKmJ1C5W7u6BM9rfbqojOPKjYom
         1Y4AYG/0KET0WCV8FAs4b6uc4u1Q1Zg3zNgUlqvXsQtx0GGuzXMjiWZfICtAYP6WMo
         K1tuFH/EFDSqSAlQAuZX08HObEld9lPRL+/V6gCFC7LQZkPWsYtaVcSUJKvTd43VSb
         QplaTrha1GXrA0F7vCGdIB1gX23Mz+tKJCj2XrCvZyLTFklAysDTXm0UXQBlSHFpYY
         mRiJFQu1z8pda1zQAdnCQXq8JTH0M6uWtjaSL7Bnye81Pe664eDZJ5Pw+TZYGZoi1m
         Fa6YMe1qt6HeA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 3/4] net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
Date:   Sat,  9 Jul 2022 17:48:31 +0200
Message-Id: <6a522ca5588fde75f42d4d812e8990eca6d8952d.1657381057.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657381056.git.lorenzo@kernel.org>
References: <cover.1657381056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report xdp stats through ethtool

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 54 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 +++++
 2 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3b583abb599d..ae7ba2e09df8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -34,6 +34,10 @@ MODULE_PARM_DESC(msg_level, "Message level (-1=defaults,0=none,...,16=all)");
 #define MTK_ETHTOOL_STAT(x) { #x, \
 			      offsetof(struct mtk_hw_stats, x) / sizeof(u64) }
 
+#define MTK_ETHTOOL_XDP_STAT(x) { #x, \
+				  offsetof(struct mtk_hw_stats, xdp_stats.x) / \
+				  sizeof(u64) }
+
 static const struct mtk_reg_map mtk_reg_map = {
 	.tx_irq_mask		= 0x1a1c,
 	.tx_irq_status		= 0x1a18,
@@ -141,6 +145,13 @@ static const struct mtk_ethtool_stats {
 	MTK_ETHTOOL_STAT(rx_long_errors),
 	MTK_ETHTOOL_STAT(rx_checksum_errors),
 	MTK_ETHTOOL_STAT(rx_flow_control_packets),
+	MTK_ETHTOOL_XDP_STAT(rx_xdp_redirect),
+	MTK_ETHTOOL_XDP_STAT(rx_xdp_pass),
+	MTK_ETHTOOL_XDP_STAT(rx_xdp_drop),
+	MTK_ETHTOOL_XDP_STAT(rx_xdp_tx),
+	MTK_ETHTOOL_XDP_STAT(rx_xdp_tx_errors),
+	MTK_ETHTOOL_XDP_STAT(tx_xdp_xmit),
+	MTK_ETHTOOL_XDP_STAT(tx_xdp_xmit_errors),
 };
 
 static const char * const mtk_clks_source_name[] = {
@@ -1495,7 +1506,8 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
 }
 
 static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
-		       struct xdp_buff *xdp, struct net_device *dev)
+		       struct xdp_buff *xdp, struct net_device *dev,
+		       struct mtk_xdp_stats *stats)
 {
 	u32 act = XDP_PASS;
 
@@ -1505,10 +1517,13 @@ static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
+		stats->rx_xdp_pass++;
 		return XDP_PASS;
 	case XDP_REDIRECT:
 		if (unlikely(xdp_do_redirect(dev, xdp, prog)))
 			break;
+
+		stats->rx_xdp_redirect++;
 		return XDP_REDIRECT;
 	default:
 		bpf_warn_invalid_xdp_action(dev, prog, act);
@@ -1520,14 +1535,38 @@ static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
 		break;
 	}
 
+	stats->rx_xdp_drop++;
 	page_pool_put_full_page(ring->page_pool,
 				virt_to_head_page(xdp->data), true);
 	return XDP_DROP;
 }
 
+static void mtk_xdp_rx_complete(struct mtk_eth *eth,
+				struct mtk_xdp_stats *stats)
+{
+	int i, xdp_do_redirect = 0;
+
+	/* update xdp ethtool stats */
+	for (i = 0; i < MTK_MAX_DEVS; i++) {
+		struct mtk_hw_stats *hw_stats = eth->mac[i]->hw_stats;
+		struct mtk_xdp_stats *xdp_stats = &hw_stats->xdp_stats;
+
+		u64_stats_update_begin(&hw_stats->syncp);
+		xdp_stats->rx_xdp_redirect += stats[i].rx_xdp_redirect;
+		xdp_do_redirect += stats[i].rx_xdp_pass;
+		xdp_stats->rx_xdp_pass += stats[i].rx_xdp_pass;
+		xdp_stats->rx_xdp_drop += stats[i].rx_xdp_drop;
+		u64_stats_update_end(&hw_stats->syncp);
+	}
+
+	if (xdp_do_redirect)
+		xdp_do_flush_map();
+}
+
 static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		       struct mtk_eth *eth)
 {
+	struct mtk_xdp_stats xdp_stats[MTK_MAX_DEVS] = {};
 	struct bpf_prog *prog = READ_ONCE(eth->prog);
 	struct dim_sample dim_sample = {};
 	struct mtk_rx_ring *ring;
@@ -1535,7 +1574,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 	struct sk_buff *skb;
 	u8 *data, *new_data;
 	struct mtk_rx_dma_v2 *rxd, trxd;
-	bool xdp_do_redirect = false;
 	int done = 0, bytes = 0;
 
 	while (done < budget) {
@@ -1597,12 +1635,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 					 false);
 			xdp_buff_clear_frags_flag(&xdp);
 
-			ret = mtk_xdp_run(ring, prog, &xdp, netdev);
-			if (ret != XDP_PASS) {
-				if (ret == XDP_REDIRECT)
-					xdp_do_redirect = true;
+			ret = mtk_xdp_run(ring, prog, &xdp, netdev,
+					  &xdp_stats[mac]);
+			if (ret != XDP_PASS)
 				goto skip_rx;
-			}
 
 			skb = build_skb(data, PAGE_SIZE);
 			if (unlikely(!skb)) {
@@ -1725,8 +1761,8 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			  &dim_sample);
 	net_dim(&eth->rx_dim, dim_sample);
 
-	if (prog && xdp_do_redirect)
-		xdp_do_flush_map();
+	if (prog)
+		mtk_xdp_rx_complete(eth, xdp_stats);
 
 	return done;
 }
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index a1cea93300c1..629cdcdd632a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -570,6 +570,16 @@ struct mtk_tx_dma_v2 {
 struct mtk_eth;
 struct mtk_mac;
 
+struct mtk_xdp_stats {
+	u64 rx_xdp_redirect;
+	u64 rx_xdp_pass;
+	u64 rx_xdp_drop;
+	u64 rx_xdp_tx;
+	u64 rx_xdp_tx_errors;
+	u64 tx_xdp_xmit;
+	u64 tx_xdp_xmit_errors;
+};
+
 /* struct mtk_hw_stats - the structure that holds the traffic statistics.
  * @stats_lock:		make sure that stats operations are atomic
  * @reg_offset:		the status register offset of the SoC
@@ -593,6 +603,8 @@ struct mtk_hw_stats {
 	u64 rx_checksum_errors;
 	u64 rx_flow_control_packets;
 
+	struct mtk_xdp_stats	xdp_stats;
+
 	spinlock_t		stats_lock;
 	u32			reg_offset;
 	struct u64_stats_sync	syncp;
-- 
2.36.1

