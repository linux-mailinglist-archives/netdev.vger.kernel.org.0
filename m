Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF98A656B88
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiL0OIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 09:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiL0OIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 09:08:25 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E076168;
        Tue, 27 Dec 2022 06:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wu4+/ysy1Pzt6jWFfy9ST450nk1QbkSGcPcWerr8QPI=; b=SHQ43VMNc5LoDG+o6N4TLX9TOD
        zkYv9dxNbhCN/i/VFStXwETNNXhNR2tTAtUsF/GrXzvU70r7QBMdSUqlcLxdhKSaXDLWthXgBIIwG
        sd75zTFVu4Jj5SPzDXFXsVLfyEvXxmfIaqs5Y9yalQrZsCFoHw1muOanIEIQO24PT0uI=;
Received: from p200300daa720fc040c81ba64b0a9b1e5.dip0.t-ipconnect.de ([2003:da:a720:fc04:c81:ba64:b0a9:b1e5] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pAAcj-00C3RB-1x; Tue, 27 Dec 2022 15:08:09 +0100
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
Subject: [PATCH net v2 2/5] net: ethernet: mtk_eth_soc: work around issue with sending small fragments
Date:   Tue, 27 Dec 2022 15:08:04 +0100
Message-Id: <20221227140807.48413-2-nbd@nbd.name>
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

When lots of frames are sent with a number of very small fragments, an
internal FIFO can overflow, causing the DMA engine to lock up lock up and
transmit attempts time out.

Fix this on MT7986 by increasing the reserved FIFO space.
Fix this on older chips by detecting the presence of small fragments and use
skb_gso_segment + skb_linearize to deal with them.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: add proper fix for MT7986, limit workaround to NETSYS v1

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 +++++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e3de9a53b2d9..8245cddccb5a 100644
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
 
@@ -1468,6 +1484,18 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) &&
+	    skb_is_gso(skb) && mtk_skb_has_small_frag(skb)) {
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
@@ -1483,8 +1511,14 @@ static netdev_tx_t mtk_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	if (mtk_tx_map(skb, dev, tx_num, ring, gso) < 0)
-		goto drop;
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		skb_list_walk_safe(skb, skb, next) {
+			if ((mtk_skb_has_small_frag(skb) && skb_linearize(skb)) ||
+			    mtk_tx_map(skb, dev, tx_num, ring, gso) < 0) {
+				stats->tx_dropped++;
+				dev_kfree_skb_any(skb);
+			}
+		}
 
 	if (unlikely(atomic_read(&ring->free_count) <= ring->thresh))
 		netif_tx_stop_all_queues(dev);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 628ed72911bd..ce8044e8b3f7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -246,7 +246,7 @@
 #define MTK_CHK_DDONE_EN	BIT(28)
 #define MTK_DMAD_WR_WDONE	BIT(26)
 #define MTK_WCOMP_EN		BIT(24)
-#define MTK_RESV_BUF		(0x40 << 16)
+#define MTK_RESV_BUF		(0x80 << 16)
 #define MTK_MUTLI_CNT		(0x4 << 12)
 #define MTK_LEAKY_BUCKET_EN	BIT(11)
 
-- 
2.38.1

