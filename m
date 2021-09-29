Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114ED41C94F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346408AbhI2QEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23331 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344509AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX211b2zRd69;
        Wed, 29 Sep 2021 23:53:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 105/167] net: cadence: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:32 +0800
Message-ID: <20210929155334.12454-106-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 65 +++++++++++++++---------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e30ee19d9ba2..53a44ba6444c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1384,7 +1384,8 @@ static int gem_rx(struct macb_queue *queue, struct napi_struct *napi,
 
 		skb->protocol = eth_type_trans(skb, bp->dev);
 		skb_checksum_none_assert(skb);
-		if (bp->dev->features & NETIF_F_RXCSUM &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    bp->dev->features) &&
 		    !(bp->dev->flags & IFF_PROMISC) &&
 		    GEM_BFEXT(RX_CSUM, ctrl) & GEM_RX_CSUM_CHECKED_MASK)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2001,7 +2002,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 		if (i == queue->tx_head) {
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
-			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
+			if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT,
+						    bp->dev->features) &&
 			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
@@ -2055,7 +2057,7 @@ static void macb_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
 	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN)) {
-		*features &= ~MACB_NETIF_LSO;
+		netdev_feature_clear_bits(MACB_NETIF_LSO, features);
 		return;
 	}
 
@@ -2066,7 +2068,7 @@ static void macb_features_check(struct sk_buff *skb, struct net_device *dev,
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN)) {
-			*features &= ~MACB_NETIF_LSO;
+			netdev_feature_clear_bits(MACB_NETIF_LSO, features);
 			return;
 		}
 	}
@@ -2100,7 +2102,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	struct sk_buff *nskb;
 	u32 fcs;
 
-	if (!(ndev->features & NETIF_F_HW_CSUM) ||
+	if (!netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, ndev->features) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
 	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
 		return 0;
@@ -2578,7 +2580,8 @@ static void macb_configure_dma(struct macb *bp)
 		else
 			dmacfg |= GEM_BIT(ENDIA_DESC); /* CPU in big endian */
 
-		if (bp->dev->features & NETIF_F_HW_CSUM)
+		if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT,
+					    bp->dev->features))
 			dmacfg |= GEM_BIT(TXCOEN);
 		else
 			dmacfg &= ~GEM_BIT(TXCOEN);
@@ -2614,7 +2617,9 @@ static void macb_init_hw(struct macb *bp)
 		config |= MACB_BIT(BIG);	/* Receive oversized frames */
 	if (bp->dev->flags & IFF_PROMISC)
 		config |= MACB_BIT(CAF);	/* Copy All Frames */
-	else if (macb_is_gem(bp) && bp->dev->features & NETIF_F_RXCSUM)
+	else if (macb_is_gem(bp) &&
+		 netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					 bp->dev->features))
 		config |= GEM_BIT(RXCOEN);
 	if (!(bp->dev->flags & IFF_BROADCAST))
 		config |= MACB_BIT(NBC);	/* No BroadCast */
@@ -2725,7 +2730,8 @@ static void macb_set_rx_mode(struct net_device *dev)
 		cfg &= ~MACB_BIT(CAF);
 
 		/* Enable RX checksum offload only if requested */
-		if (macb_is_gem(bp) && dev->features & NETIF_F_RXCSUM)
+		if (macb_is_gem(bp) &&
+		    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features))
 			cfg |= GEM_BIT(RXCOEN);
 	}
 
@@ -3229,7 +3235,7 @@ static void gem_enable_flow_filters(struct macb *bp, bool enable)
 	u32 t2_scr;
 	int num_t2_scr;
 
-	if (!(netdev->features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->features))
 		return;
 
 	num_t2_scr = GEM_BFEXT(T2SCR, gem_readl(bp, DCFG8));
@@ -3588,7 +3594,7 @@ static inline void macb_set_txcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, DMACFG);
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features))
 		val |= GEM_BIT(TXCOEN);
 	else
 		val &= ~GEM_BIT(TXCOEN);
@@ -3606,7 +3612,8 @@ static inline void macb_set_rxcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, NCFGR);
-	if ((features & NETIF_F_RXCSUM) && !(netdev->flags & IFF_PROMISC))
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
+	    !(netdev->flags & IFF_PROMISC))
 		val |= GEM_BIT(RXCOEN);
 	else
 		val &= ~GEM_BIT(RXCOEN);
@@ -3620,25 +3627,28 @@ static inline void macb_set_rxflow_feature(struct macb *bp,
 	if (!macb_is_gem(bp))
 		return;
 
-	gem_enable_flow_filters(bp, !!(features & NETIF_F_NTUPLE));
+	gem_enable_flow_filters(bp, netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+							    features));
 }
 
 static int macb_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct macb *bp = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
+
+	netdev_feature_xor(&changed, features, netdev->features);
 
 	/* TX checksum offload */
-	if (changed & NETIF_F_HW_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, changed))
 		macb_set_txcsum_feature(bp, features);
 
 	/* RX checksum offload */
-	if (changed & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		macb_set_rxcsum_feature(bp, features);
 
 	/* RX Flow Filters */
-	if (changed & NETIF_F_NTUPLE)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed))
 		macb_set_rxflow_feature(bp, features);
 
 	return 0;
@@ -3647,8 +3657,10 @@ static int macb_set_features(struct net_device *netdev,
 static void macb_restore_features(struct macb *bp)
 {
 	struct net_device *netdev = bp->dev;
-	netdev_features_t features = netdev->features;
 	struct ethtool_rx_fs_item *item;
+	netdev_features_t features;
+
+	netdev_feature_copy(&features, netdev->features);
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, features);
@@ -3934,18 +3946,20 @@ static int macb_init(struct platform_device *pdev)
 	}
 
 	/* Set features */
-	dev->hw_features = NETIF_F_SG;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
-		dev->hw_features |= MACB_NETIF_LSO;
+		netdev_feature_set_bits(MACB_NETIF_LSO, &dev->hw_features);
 
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
+					&dev->hw_features);
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
-		dev->hw_features &= ~NETIF_F_SG;
-	dev->features = dev->hw_features;
+		netdev_feature_clear_bit(NETIF_F_SG_BIT, &dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 
 	/* Check RX Flow Filters support.
 	 * Max Rx flows set by availability of screeners & compare regs:
@@ -3963,7 +3977,8 @@ static int macb_init(struct platform_device *pdev)
 			reg = GEM_BFINS(ETHTCMP, (uint16_t)ETH_P_IP, reg);
 			gem_writel_n(bp, ETHT, SCRT2_ETHT, reg);
 			/* Filtering is supported in hw but don't enable it in kernel now */
-			dev->hw_features |= NETIF_F_NTUPLE;
+			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
+					       &dev->hw_features);
 			/* init Rx flow definitions */
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
@@ -4942,7 +4957,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
 		bp->pm_data.usrio = macb_or_gem_readl(bp, USRIO);
 
-	if (netdev->hw_features & NETIF_F_NTUPLE)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features))
 		bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 
 	if (bp->ptp_info)
@@ -5009,7 +5024,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 	     ++q, ++queue)
 		napi_enable(&queue->napi);
 
-	if (netdev->hw_features & NETIF_F_NTUPLE)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features))
 		gem_writel_n(bp, ETHT, SCRT2_ETHT, bp->pm_data.scrt2);
 
 	if (!(bp->caps & MACB_CAPS_USRIO_DISABLED))
-- 
2.33.0

