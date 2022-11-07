Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B364B61FE7F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 20:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiKGTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 14:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKGTWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 14:22:55 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F33629C9D;
        Mon,  7 Nov 2022 11:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aHSyFTkNYm0tEzpG0WqScLtRJ9ZnJG0fH9+cS4+pKn4=; b=rP9cFhzDH0gSdDaqcJG8luNTWT
        VqaA1Po/WM5NiWcWoKWwNBsJe0xDAFNuDqpZA4UKEHsUb1yeCrG6qwfVT27dQ0zjYUyKEmfLW0qVH
        8vBWCa9eFYx07hV2Q3NAp8u0i6rN7KdTOuEWpMM07W9+FLFM0QudxR09RI/z1wLd3MjE=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HG-000LCc-AH; Mon, 07 Nov 2022 19:55:22 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] net: ethernet: mtk_eth_soc: fix VLAN rx hardware acceleration
Date:   Mon,  7 Nov 2022 19:54:49 +0100
Message-Id: <20221107185452.90711-11-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
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

- enable VLAN untagging for PDMA rx
- make it possible to disable the feature via ethtool
- pass VLAN tag to the DSA driver
- untag special tag on PDMA only if no non-DSA devices are in use
- disable special tag untagging on 7986 for now, since it's not working yet

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++--------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 ++
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ab31dda2cd66..3b8995a483aa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2015,16 +2015,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 						htons(RX_DMA_VPID(trxd.rxd4)),
 						RX_DMA_VID(trxd.rxd4));
 			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
 						       RX_DMA_VID(trxd.rxd3));
 			}
-
-			/* If the device is attached to a dsa switch, the special
-			 * tag inserted in VLAN field by hw switch can * be offloaded
-			 * by RX HW VLAN offload. Clear vlan info.
-			 */
-			if (netdev_uses_dsa(netdev))
-				__vlan_hwaccel_clear_tag(skb);
 		}
 
 		skb_record_rx_queue(skb, 0);
@@ -2847,15 +2840,17 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
-	int err = 0;
-
-	if (!((dev->features ^ features) & NETIF_F_LRO))
-		return 0;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	netdev_features_t diff = dev->features ^ features;
 
-	if (!(features & NETIF_F_LRO))
+	if ((diff & NETIF_F_LRO) && !(features & NETIF_F_LRO))
 		mtk_hwlro_netdev_disable(dev);
 
-	return err;
+	/* Set RX VLAN offloading */
+	mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX), MTK_CDMP_EG_CTRL);
+
+	return 0;
 }
 
 /* wait for DMA to finish whatever it is doing before we start using it again */
@@ -3176,6 +3171,15 @@ static int mtk_open(struct net_device *dev)
 	else
 		refcount_inc(&eth->dma_refcnt);
 
+	/* Hardware special tag parsing needs to be disabled if at least
+	 * one MAC does not use DSA.
+	 */
+	if (!netdev_uses_dsa(dev)) {
+		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+		val &= ~MTK_CDMP_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
+	}
+
 	phylink_start(mac->phylink);
 	netif_tx_start_all_queues(dev);
 
@@ -3469,6 +3473,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	 */
 	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
 	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
+	}
 
 	/* Enable RX VLan Offloading */
 	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index e09b2483c70c..26b2323185ef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -93,6 +93,9 @@
 #define MTK_CDMQ_IG_CTRL	0x1400
 #define MTK_CDMQ_STAG_EN	BIT(0)
 
+/* CDMQ Exgress Control Register */
+#define MTK_CDMQ_EG_CTRL	0x1404
+
 /* CDMP Ingress Control Register */
 #define MTK_CDMP_IG_CTRL	0x400
 #define MTK_CDMP_STAG_EN	BIT(0)
-- 
2.38.1

