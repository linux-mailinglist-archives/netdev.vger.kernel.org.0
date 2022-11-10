Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041B8624CDB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiKJVWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiKJVWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:22:30 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5877B31DCE;
        Thu, 10 Nov 2022 13:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=H+eftt8l6Bnn209SyArb1oaE+v3tXc1RSpc0VaS+BPM=; b=Vg+Gz68dE57MbwQ0dhLtvumyDd
        ebGhYqxGEYqPJc9VPH7VcB8yrCP9698BO09vSHRoFSQXakILrWTh1AhPptBbTOIAU8d6LVBRx8xXo
        WTF4SCk+QYjm+fSO/JB8zeqaXySy3qn4/fiXJoifG4z1COT5Z2Tw7M135I9pesKZomm0=;
Received: from p200300daa72ee10c199752172ce6dd7a.dip0.t-ipconnect.de ([2003:da:a72e:e10c:1997:5217:2ce6:dd7a] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otF05-0011Om-4w; Thu, 10 Nov 2022 22:22:17 +0100
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
Subject: [PATCH net-next v3 3/4] net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload
Date:   Thu, 10 Nov 2022 22:22:10 +0100
Message-Id: <20221110212212.96825-4-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110212212.96825-1-nbd@nbd.name>
References: <20221110212212.96825-1-nbd@nbd.name>
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

Keep the vlan rx offload feature in sync across all netdevs belonging to the
device, since the feature is global and can't be turned off per MAC

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 891dd6937f89..a118c715b09b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2724,15 +2724,30 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
-	int err = 0;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	netdev_features_t diff = dev->features ^ features;
+	int i;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	if ((diff & NETIF_F_LRO) && !(features & NETIF_F_LRO))
+		mtk_hwlro_netdev_disable(dev);
+
+	/* Set RX VLAN offloading */
+	if (!(diff & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
-	if (!(features & NETIF_F_LRO))
-		mtk_hwlro_netdev_disable(dev);
+	mtk_w32(eth, !!(features & NETIF_F_HW_VLAN_CTAG_RX),
+		MTK_CDMP_EG_CTRL);
 
-	return err;
+	/* sync features with other MAC */
+	for (i = 0; i < MTK_MAC_COUNT; i++) {
+		if (!eth->netdev[i] || eth->netdev[i] == dev)
+			continue;
+		eth->netdev[i]->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		eth->netdev[i]->features |= features & NETIF_F_HW_VLAN_CTAG_RX;
+	}
+
+	return 0;
 }
 
 /* wait for DMA to finish whatever it is doing before we start using it again */
-- 
2.38.1

