Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9FF635941
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbiKWKJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiKWKIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:08:43 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D34258016;
        Wed, 23 Nov 2022 01:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TqAxL1ZNrPmWijqt9CG1x9FAOLdXO4JArQexSu8S6G0=; b=k2R54x1quzswJYr6SR1Uzq2CdC
        hRMZ/Ky1sWe/E2svBQUKe2pZivsAp3DbmHrcbxCmoSqS1KawTUmo2WYXGEdtHxc6uHZ6yVo2g8IEC
        VjwuLbM/QvlUZcJ/tWyp1GO8ZuJrN1YXaldjsQC65dQnqZ9jIdzhwRhmE/yGqbozah3k=;
Received: from p200300daa7225c0894d890dd9e4669b3.dip0.t-ipconnect.de ([2003:da:a722:5c08:94d8:90dd:9e46:69b3] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oxmVw-003vzk-T3; Wed, 23 Nov 2022 10:57:56 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] net: ethernet: mtk_eth_soc: work around issue with sending small fragments
Date:   Wed, 23 Nov 2022 10:57:52 +0100
Message-Id: <20221123095754.36821-3-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123095754.36821-1-nbd@nbd.name>
References: <20221123095754.36821-1-nbd@nbd.name>
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

When frames are sent with very small fragments, the DMA engine appears to
lock up and transmit attempts time out. Fix this by detecting the presence
of small fragments and use skb_gso_segment + skb_linearize to deal with
them

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4c9972a94451..e63d2c034ca3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1441,12 +1441,28 @@ static void mtk_wake_queue(struct mtk_eth *eth)
 	}
 }
 
+static bool mtk_skb_has_small_frag(struct sk_buff *skb)
+{
+	int min_size = 16;
+	int i;
+
+	if (skb_headlen(skb) < min_size)
+		return true;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+		if (skb_frag_size(&skb_shinfo(skb)->frags[i]) < min_size)
+			return true;
+
+	return false;
+}
+
 static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct net_device_stats *stats = &dev->stats;
+	struct sk_buff *segs, *next;
 	bool gso = false;
 	int tx_num;
 
@@ -1468,6 +1484,17 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
+	if (skb_is_gso(skb) && mtk_skb_has_small_frag(skb)) {
+		segs = skb_gso_segment(skb, dev->features & ~NETIF_F_ALL_TSO);
+		if (IS_ERR(segs))
+			goto drop;
+
+		if (segs) {
+			consume_skb(skb);
+			skb = segs;
+		}
+	}
+
 	/* TSO: fill MSS info in tcp checksum field */
 	if (skb_is_gso(skb)) {
 		if (skb_cow_head(skb, 0)) {
@@ -1483,8 +1510,13 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	if (mtk_tx_map(skb, dev, tx_num, ring, gso) < 0)
-		goto drop;
+	skb_list_walk_safe(skb, skb, next) {
+		if ((mtk_skb_has_small_frag(skb) && skb_linearize(skb)) ||
+		    mtk_tx_map(skb, dev, tx_num, ring, gso) < 0) {
+			stats->tx_dropped++;
+			dev_kfree_skb_any(skb);
+		}
+	}
 
 	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
 		netif_tx_stop_all_queues(dev);
-- 
2.38.1

