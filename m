Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB77A6EF972
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbjDZRcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjDZRcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:32:07 -0400
X-Greylist: delayed 591 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 10:32:01 PDT
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BD597;
        Wed, 26 Apr 2023 10:32:01 -0700 (PDT)
Received: from mxbox1.masterlogin.de (unknown [192.168.10.88])
        by mxout2.routing.net (Postfix) with ESMTP id F08A9615F4;
        Wed, 26 Apr 2023 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1682529728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9ph+5lfap41GhhIYN4o+S1Eh3tgVJNxaqloTCHYLDBI=;
        b=kw12t/diCsUFUYg6sujCROB5ZcLs/zuZYvbzvqYGJCBQ7LdOh/P+G6ZZcFVYch58wTPQbY
        kxoi3O4OmzvSlc7HQAKDeSed3OF+viPuCByd72kem+ko5KHQsm4dK/QzmI9CKhap5NhE4Q
        dFv/ZEzsO0IRx5fzTn1nk8wfC/Jw+OQ=
Received: from frank-G5.. (fttx-pool-217.61.146.19.bambit.de [217.61.146.19])
        by mxbox1.masterlogin.de (Postfix) with ESMTPSA id A6B4E4021D;
        Wed, 26 Apr 2023 17:22:06 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging
Date:   Wed, 26 Apr 2023 19:21:53 +0200
Message-Id: <20230426172153.8352-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mail-ID: 6a51c8a2-6d2c-4cbd-a943-f861745ef60a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Through testing I found out that hardware vlan rx offload support seems to
have some hardware issues. At least when using multiple MACs and when
receiving tagged packets on the secondary MAC, the hardware can sometimes
start to emit wrong tags on the first MAC as well.

In order to avoid such issues, drop the feature configuration and use
the offload feature only for DSA hardware untagging on MT7621/MT7622
devices where this feature works properly.

Fixes: 08666cbb7dd5 ("net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload")
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
v2:
- changed commit message to drop "only one MAC used" phrase based on
  Arincs comments
- fixed too long line in commit description and add empty line after
  declaration
- add fixes tag

used felix Patch as base and ported up to 6.3-rc6

it basicly reverts changes from vladimirs patch

1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0

tested this on bananapi-r3 on non-dsa gmac1 and dsa eth0 (wan).
on both vlan is working, but maybe it breaks HW-vlan-untagging
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 106 ++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |   1 -
 2 files changed, 40 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9e948d091a69..a75fd072082c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1918,9 +1918,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
-		bool has_hwaccel_tag = false;
 		struct net_device *netdev;
-		u16 vlan_proto, vlan_tci;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
 		int mac = 0;
@@ -2055,31 +2053,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
-					vlan_proto = RX_DMA_VPID(trxd.rxd4);
-					vlan_tci = RX_DMA_VID(trxd.rxd4);
-					has_hwaccel_tag = true;
-				}
-			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				vlan_proto = RX_DMA_VPID(trxd.rxd3);
-				vlan_tci = RX_DMA_VID(trxd.rxd3);
-				has_hwaccel_tag = true;
-			}
-		}
-
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
-		if (has_hwaccel_tag && netdev_uses_dsa(netdev)) {
-			unsigned int port = vlan_proto & GENMASK(2, 0);
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) &&
+		    (trxd.rxd2 & RX_DMA_VTAG) && netdev_uses_dsa(netdev)) {
+			unsigned int port = RX_DMA_VPID(trxd.rxd3) & GENMASK(2, 0);
 
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
 			    eth->dsa_meta[port])
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
-		} else if (has_hwaccel_tag) {
-			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
@@ -2907,29 +2890,11 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_eth *eth = mac->hw;
 	netdev_features_t diff = dev->features ^ features;
-	int i;
 
 	if ((diff & NETIF_F_LRO) && !(features & NETIF_F_LRO))
 		mtk_hwlro_netdev_disable(dev);
 
-	/* Set RX VLAN offloading */
-	if (!(diff & NETIF_F_HW_VLAN_CTAG_RX))
-		return 0;
-
-	mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX),
-		MTK_CDMP_EG_CTRL);
-
-	/* sync features with other MAC */
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i] || eth->netdev[i] == dev)
-			continue;
-		eth->netdev[i]->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
-		eth->netdev[i]->features |= features & NETIF_F_HW_VLAN_CTAG_RX;
-	}
-
 	return 0;
 }
 
@@ -3247,30 +3212,6 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int i, err;
 
-	if (mtk_uses_dsa(dev) && !eth->prog) {
-		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
-			struct metadata_dst *md_dst = eth->dsa_meta[i];
-
-			if (md_dst)
-				continue;
-
-			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
-						    GFP_KERNEL);
-			if (!md_dst)
-				return -ENOMEM;
-
-			md_dst->u.port_info.port_id = i;
-			eth->dsa_meta[i] = md_dst;
-		}
-	} else {
-		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA.
-		 */
-		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
-		val &= ~MTK_CDMP_STAG_EN;
-		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
-	}
-
 	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
 	if (err) {
 		netdev_err(dev, "%s: could not attach PHY: %d\n", __func__,
@@ -3309,6 +3250,40 @@ static int mtk_open(struct net_device *dev)
 	phylink_start(mac->phylink);
 	netif_tx_start_all_queues(dev);
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return 0;
+
+	if (mtk_uses_dsa(dev) && !eth->prog) {
+		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
+			struct metadata_dst *md_dst = eth->dsa_meta[i];
+
+			if (md_dst)
+				continue;
+
+			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
+						    GFP_KERNEL);
+			if (!md_dst)
+				return -ENOMEM;
+
+			md_dst->u.port_info.port_id = i;
+			eth->dsa_meta[i] = md_dst;
+		}
+	} else {
+		/* Hardware special tag parsing needs to be disabled if at least
+		 * one MAC does not use DSA.
+		 */
+		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+
+		val &= ~MTK_CDMP_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
+
+		val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
+		val &= ~MTK_CDMQ_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMQ_IG_CTRL);
+
+		mtk_w32(eth, 0, MTK_CDMP_EG_CTRL);
+	}
+
 	return 0;
 }
 
@@ -3793,10 +3768,9 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
-	}
 
-	/* Enable RX VLan Offloading */
-	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
+		mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
+	}
 
 	/* set interrupt delays based on current Net DIM sample */
 	mtk_dim_rx(&eth->rx_dim.work);
@@ -4453,7 +4427,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
 	eth->netdev[id]->vlan_features = eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+		~NETIF_F_HW_VLAN_CTAG_TX;
 	eth->netdev[id]->features |= eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index cdcf8534283e..707445f6bcb1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -48,7 +48,6 @@
 #define MTK_HW_FEATURES		(NETIF_F_IP_CSUM | \
 				 NETIF_F_RXCSUM | \
 				 NETIF_F_HW_VLAN_CTAG_TX | \
-				 NETIF_F_HW_VLAN_CTAG_RX | \
 				 NETIF_F_SG | NETIF_F_TSO | \
 				 NETIF_F_TSO6 | \
 				 NETIF_F_IPV6_CSUM |\
-- 
2.34.1

