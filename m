Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4617B57DB27
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiGVHVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiGVHVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0F520F5E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAADE621BA
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 07:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C903DC341C6;
        Fri, 22 Jul 2022 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658474510;
        bh=gs3Y7OdFr1SCPPKNy/wWytrZ55M3gULs+vke01PyqXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbgE+UFPqqmimPs729cTMlBgfJT3YG7OolXl8m9iPmCYPWkYp/u8rY4bFsyAO/hap
         7jgkvRVwYatw7fdYDAYGG/VIs7k91f9enJEyFNrqyxCHKZlHbRAvUi7gudAU0jCEtY
         lLu8UQjUx6TCqHuX267meYdmjGdwo5hLwnlBylse1N6I4r3gFdbKF/45M63rIpv2p9
         5EwkApNczQvvi9jzpKq7+ZVmBT/6IzUaZYjy164P6A87EsHm0rIXSlA8osFAbohDvU
         +MBu5bMBtZ/XEmzePEzNN7WFnPWVxDNvdbf2hd89wBwXzfnimuaze7kRONrLt1OV7u
         TTRPvrQPsoCqg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v4 net-next 3/5] net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
Date:   Fri, 22 Jul 2022 09:19:38 +0200
Message-Id: <44260c788c793aa6ca63d87eac1b7d0938eb949a.1658474059.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1658474059.git.lorenzo@kernel.org>
References: <cover.1658474059.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report xdp stats through ethtool

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 26 +++++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 ++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9a40876e5417..cd96eaf72b6b 100644
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
@@ -1502,6 +1513,9 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
 static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 		       struct xdp_buff *xdp, struct net_device *dev)
 {
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_hw_stats *hw_stats = mac->hw_stats;
+	u64 *count = &hw_stats->xdp_stats.rx_xdp_drop;
 	struct bpf_prog *prog;
 	u32 act = XDP_PASS;
 
@@ -1514,13 +1528,16 @@ static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		goto out;
+		count = &hw_stats->xdp_stats.rx_xdp_pass;
+		goto update_stats;
 	case XDP_REDIRECT:
 		if (unlikely(xdp_do_redirect(dev, xdp, prog))) {
 			act = XDP_DROP;
 			break;
 		}
-		goto out;
+
+		count = &hw_stats->xdp_stats.rx_xdp_redirect;
+		goto update_stats;
 	default:
 		bpf_warn_invalid_xdp_action(dev, prog, act);
 		fallthrough;
@@ -1533,6 +1550,11 @@ static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
 
 	page_pool_put_full_page(ring->page_pool,
 				virt_to_head_page(xdp->data), true);
+
+update_stats:
+	u64_stats_update_begin(&hw_stats->syncp);
+	*count = *count + 1;
+	u64_stats_update_end(&hw_stats->syncp);
 out:
 	rcu_read_unlock();
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index cfb7aeda3f49..2775da1a6ec3 100644
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

