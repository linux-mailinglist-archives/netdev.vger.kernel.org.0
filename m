Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBC623091
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiKIQy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiKIQx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:53:59 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4D27DEC;
        Wed,  9 Nov 2022 08:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K5PkePP8GWSVO/aA2H0vGreyzQRw46Jl9mG+ltEDiYg=; b=HTd09RZIWm9L73OSxmR7psrYuu
        VoT8Dce6T8Twgp9f7m/vnYYvgsRF2R9z4z0tBVa//GfjFlQipgaOpimAqk0Cej6PQRWPjvG7KbAAg
        JXrUX+9PZSi6aUV+nTP0u5aDkLO1uLtZB0fx/6Fwt+hwy5U4WBVXKCXi6Dqpp8FaBwpA=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso2A-000l4N-VU; Wed, 09 Nov 2022 17:34:39 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 10/12] net: ethernet: mtk_eth_soc: work around issue with sending small fragments
Date:   Wed,  9 Nov 2022 17:34:24 +0100
Message-Id: <20221109163426.76164-11-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
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
index f7b1d39bf936..a9a270317ff4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1442,12 +1442,28 @@ static void mtk_wake_queue(struct mtk_eth *eth)
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
 
@@ -1469,6 +1485,17 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -1484,8 +1511,13 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
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

