Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A17656B8E
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiL0OIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 09:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiL0OIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 09:08:31 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4471F64D2;
        Tue, 27 Dec 2022 06:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J/+msWmD/g1lZcf4oy0r+1hkk+U3OA6AiiaExjYdBco=; b=Blpp9FiTGYTzanipAn93Zg+sDs
        iDF1SJ2G63MwJDdveDLBtM9yH76cLEazwltPpQuMYsoQyIcyhBmB/ODi1+6J2PNPRjJL4zLq0XV0P
        Fhfr8wx5ThXosUNj74s9m+Q+OFPsUnGoVkvUZzDkBlA3/7gKv01kbXxRi7QjcrEwuteI=;
Received: from p200300daa720fc040c81ba64b0a9b1e5.dip0.t-ipconnect.de ([2003:da:a720:fc04:c81:ba64:b0a9:b1e5] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pAAck-00C3RB-Hn; Tue, 27 Dec 2022 15:08:10 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 4/5] net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging
Date:   Tue, 27 Dec 2022 15:08:06 +0100
Message-Id: <20221227140807.48413-4-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221227140807.48413-1-nbd@nbd.name>
References: <20221227140807.48413-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Through testing I found out that hardware vlan rx offload support seems to
have some hardware issues. At least when using multiple MACs and when receiving
tagged packets on the secondary MAC, the hardware can sometimes start to emit
wrong tags on the first MAC as well.

In order to avoid such issues, drop the feature configuration and use the
offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
only use one MAC.

Tested-By: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 101 ++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |   1 -
 2 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8245cddccb5a..214cd80a19a0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2042,29 +2042,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
 			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-				if (trxd.rxd3 & RX_DMA_VTAG_V2)
-					__vlan_hwaccel_put_tag(skb,
-						htons(RX_DMA_VPID(trxd.rxd4)),
-						RX_DMA_VID(trxd.rxd4));
-			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
-						       RX_DMA_VID(trxd.rxd3));
-			}
-		}
-
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
-		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
-			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) &&
+		    (trxd.rxd2 & RX_DMA_VTAG) && netdev_uses_dsa(netdev)) {
+			unsigned int port = RX_DMA_VPID(trxd.rxd3) & GENMASK(2, 0);
 
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
 			    eth->dsa_meta[port])
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
-
-			__vlan_hwaccel_clear_tag(skb);
 		}
 
 		skb_record_rx_queue(skb, 0);
@@ -2889,29 +2876,11 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
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
 
@@ -3211,30 +3180,6 @@ static int mtk_open(struct net_device *dev)
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
@@ -3273,6 +3218,39 @@ static int mtk_open(struct net_device *dev)
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
 
@@ -3599,10 +3577,9 @@ static int mtk_hw_init(struct mtk_eth *eth)
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
@@ -4203,7 +4180,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
 	eth->netdev[id]->vlan_features = eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+		~NETIF_F_HW_VLAN_CTAG_TX;
 	eth->netdev[id]->features |= eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index ce8044e8b3f7..00d9a3badf9a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -48,7 +48,6 @@
 #define MTK_HW_FEATURES		(NETIF_F_IP_CSUM | \
 				 NETIF_F_RXCSUM | \
 				 NETIF_F_HW_VLAN_CTAG_TX | \
-				 NETIF_F_HW_VLAN_CTAG_RX | \
 				 NETIF_F_SG | NETIF_F_ALL_TSO | \
 				 NETIF_F_IPV6_CSUM |\
 				 NETIF_F_HW_TC)
-- 
2.38.1

