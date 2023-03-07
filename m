Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697DE6AE5AC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCGP7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCGP6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:58:54 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE1D94F63;
        Tue,  7 Mar 2023 07:57:15 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZZge-0001w6-1U;
        Tue, 07 Mar 2023 16:57:12 +0100
Date:   Tue, 7 Mar 2023 15:55:35 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v12 16/18] net: ethernet: mtk_eth_soc: rely on num_devs and
 remove MTK_MAC_COUNT
Message-ID: <20b8cc6b73e6d6d842543dea420b4dc4b8cc105e.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678201958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Get rid of MTK_MAC_COUNT since it is a duplicated of eth->soc->num_devs.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 30 ++++++++++-----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 -
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c858f21f603c..1f802330ff13 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -988,7 +988,7 @@ static void mtk_stats_update(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->mac[i] || !eth->mac[i]->hw_stats)
 			continue;
 		if (spin_trylock(&eth->mac[i]->hw_stats->stats_lock)) {
@@ -1493,7 +1493,7 @@ static int mtk_queue_stopped(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 		if (netif_queue_stopped(eth->netdev[i]))
@@ -1507,7 +1507,7 @@ static void mtk_wake_queue(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 		netif_tx_wake_all_queues(eth->netdev[i]);
@@ -1968,7 +1968,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG))
 			mac = RX_DMA_GET_SPORT(trxd.rxd4) - 1;
 
-		if (unlikely(mac < 0 || mac >= MTK_MAC_COUNT ||
+		if (unlikely(mac < 0 || mac >= eth->soc->num_devs ||
 			     !eth->netdev[mac]))
 			goto release_desc;
 
@@ -2948,7 +2948,7 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 		MTK_CDMP_EG_CTRL);
 
 	/* sync features with other MAC */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i] || eth->netdev[i] == dev)
 			continue;
 		eth->netdev[i]->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
@@ -3038,7 +3038,7 @@ static void mtk_dma_free(struct mtk_eth *eth)
 	const struct mtk_soc_data *soc = eth->soc;
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++)
+	for (i = 0; i < soc->num_devs; i++)
 		if (eth->netdev[i])
 			netdev_reset_queue(eth->netdev[i]);
 	if (eth->scratch_ring) {
@@ -3192,7 +3192,7 @@ static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 		return;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		u32 val = mtk_r32(eth, MTK_GDMA_FWD_CFG(i));
 
 		/* default setup the forward port to send frame to PDMA */
@@ -3796,7 +3796,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	 * up with the more appropriate value when mtk_mac_config call is being
 	 * invoked.
 	 */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		struct net_device *dev = eth->netdev[i];
 
 		mtk_w32(eth, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(i));
@@ -4002,7 +4002,7 @@ static void mtk_pending_work(struct work_struct *work)
 	mtk_prepare_for_reset(eth);
 
 	/* stop all devices to make sure that dma is properly shut down */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i] || !netif_running(eth->netdev[i]))
 			continue;
 
@@ -4018,7 +4018,7 @@ static void mtk_pending_work(struct work_struct *work)
 	mtk_hw_init(eth, true);
 
 	/* restart DMA and enable IRQs */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!test_bit(i, &restart))
 			continue;
 
@@ -4046,7 +4046,7 @@ static int mtk_free_dev(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 		free_netdev(eth->netdev[i]);
@@ -4065,7 +4065,7 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		struct mtk_mac *mac;
 		if (!eth->netdev[i])
 			continue;
@@ -4370,7 +4370,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	}
 
 	id = be32_to_cpup(_id);
-	if (id >= MTK_MAC_COUNT) {
+	if (id >= eth->soc->num_devs) {
 		dev_err(eth->dev, "%d is not a valid mac id\n", id);
 		return -EINVAL;
 	}
@@ -4506,7 +4506,7 @@ void mtk_eth_set_dma_device(struct mtk_eth *eth, struct device *dma_dev)
 
 	rtnl_lock();
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		dev = eth->netdev[i];
 
 		if (!dev || !(dev->flags & IFF_UP))
@@ -4830,7 +4830,7 @@ static int mtk_remove(struct platform_device *pdev)
 	int i;
 
 	/* stop all devices to make sure that dma is properly shut down */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 		mtk_stop(eth->netdev[i]);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f0c38c856cd0..8c5f72603604 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -33,7 +33,6 @@
 #define MTK_TX_DMA_BUF_LEN_V2	0xffff
 #define MTK_QDMA_RING_SIZE	2048
 #define MTK_DMA_SIZE		512
-#define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
 #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
 #define MTK_DMA_DUMMY_DESC	0xffffffff
-- 
2.39.2

