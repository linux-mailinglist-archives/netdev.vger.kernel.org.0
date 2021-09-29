Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C60C41C947
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbhI2QDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27919 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345583AbhI2QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWy44TFzbmvX;
        Wed, 29 Sep 2021 23:53:50 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 083/167] net: realtek: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:10 +0800
Message-ID: <20210929155334.12454-84-shenjian15@huawei.com>
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
 drivers/net/ethernet/realtek/8139cp.c     | 32 ++++++-----
 drivers/net/ethernet/realtek/8139too.c    | 28 ++++++----
 drivers/net/ethernet/realtek/r8169_main.c | 65 ++++++++++++++---------
 3 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 663a12598cad..5ef5b41c7aab 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1461,17 +1461,18 @@ static int cp_set_features(struct net_device *dev, netdev_features_t features)
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
-	if (!((dev->features ^ features) & NETIF_F_RXCSUM))
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features) ==
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		return 0;
 
 	spin_lock_irqsave(&cp->lock, flags);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		cp->cpcmd |= RxChkSum;
 	else
 		cp->cpcmd &= ~RxChkSum;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		cp->cpcmd |= RxVlanOn;
 	else
 		cp->cpcmd &= ~RxVlanOn;
@@ -1857,7 +1858,7 @@ static void cp_features_check(struct sk_buff *skb, struct net_device *dev,
 			      netdev_features_t *features)
 {
 	if (skb_shinfo(skb)->gso_size > MSSMask)
-		*features &= ~NETIF_F_TSO;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 
 	vlan_features_check(skb, features);
 }
@@ -1960,8 +1961,8 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	cp->cpcmd = (pci_using_dac ? PCIDAC : 0) |
 		    PCIMulRW | RxChkSum | CpRxOn | CpTxOn;
 
-	dev->features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
 
 	regs = ioremap(pciaddr, CP_REGS_SIZE);
 	if (!regs) {
@@ -1986,16 +1987,19 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &cp_ethtool_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &dev->features);
 
 	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
-
-	dev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
+	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+				NETIF_F_HIGHDMA, &dev->vlan_features);
 
 	/* MTU range: 60 - 4096 */
 	dev->min_mtu = CP_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 2e6923cc653e..59b5a95bcaa4 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -900,18 +900,21 @@ static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
 static int rtl8139_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
+	netdev_features_t changed;
 	unsigned long flags;
-	netdev_features_t changed = features ^ dev->features;
 	void __iomem *ioaddr = tp->mmio_addr;
 
-	if (!(changed & (NETIF_F_RXALL)))
+	netdev_feature_xor(&changed, features, dev->features);
+
+	if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&tp->lock, flags);
 
-	if (changed & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed)) {
 		int rx_mode = tp->rx_config;
-		if (features & NETIF_F_RXALL)
+
+		if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, features))
 			rx_mode |= (AcceptErr | AcceptRunt);
 		else
 			rx_mode &= ~(AcceptErr | AcceptRunt);
@@ -1007,11 +1010,12 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	 * through the use of skb_copy_and_csum_dev we enable these
 	 * features
 	 */
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA;
-	dev->vlan_features = dev->features;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA,
+				&dev->features);
+	netdev_feature_copy(&dev->vlan_features, dev->features);
 
-	dev->hw_features |= NETIF_F_RXALL;
-	dev->hw_features |= NETIF_F_RXFCS;
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
 
 	/* MTU range: 68 - 1770 */
 	dev->min_mtu = ETH_MIN_MTU;
@@ -1968,7 +1972,8 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		/* read size+status of next frame from DMA ring buffer */
 		rx_status = le32_to_cpu (*(__le32 *) (rx_ring + ring_offset));
 		rx_size = rx_status >> 16;
-		if (likely(!(dev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						    dev->features)))
 			pkt_size = rx_size - 4;
 		else
 			pkt_size = rx_size;
@@ -2009,7 +2014,8 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		if (unlikely((rx_size > (MAX_ETH_FRAME_SIZE+4)) ||
 			     (rx_size < 8) ||
 			     (!(rx_status & RxStatusOK)))) {
-			if ((dev->features & NETIF_F_RXALL) &&
+			if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						    dev->features) &&
 			    (rx_size <= (MAX_ETH_FRAME_SIZE + 4)) &&
 			    (rx_size >= 8) &&
 			    (!(rx_status & RxStatusOK))) {
@@ -2580,7 +2586,7 @@ static void __set_rx_mode (struct net_device *dev)
 		}
 	}
 
-	if (dev->features & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, dev->features))
 		rx_mode |= (AcceptErr | AcceptRunt);
 
 	/* We can safely update without stopping the chip. */
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c876246cf8c1..3fdc1da3eb52 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1437,11 +1437,12 @@ static void rtl8169_fix_features(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (dev->mtu > TD_MSS_MAX)
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 
 	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06)
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO,
+					  features);
 }
 
 static void rtl_set_rx_config_features(struct rtl8169_private *tp,
@@ -1449,13 +1450,14 @@ static void rtl_set_rx_config_features(struct rtl8169_private *tp,
 {
 	u32 rx_config = RTL_R32(tp, RxConfig);
 
-	if (features & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, features))
 		rx_config |= RX_CONFIG_ACCEPT_ERR_MASK;
 	else
 		rx_config &= ~RX_CONFIG_ACCEPT_ERR_MASK;
 
 	if (rtl_is_8125(tp)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			rx_config |= RX_VLAN_8125;
 		else
 			rx_config &= ~RX_VLAN_8125;
@@ -1471,13 +1473,14 @@ static int rtl8169_set_features(struct net_device *dev,
 
 	rtl_set_rx_config_features(tp, features);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		tp->cp_cmd |= RxChkSum;
 	else
 		tp->cp_cmd &= ~RxChkSum;
 
 	if (!rtl_is_8125(tp)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			tp->cp_cmd |= RxVlan;
 		else
 			tp->cp_cmd &= ~RxVlan;
@@ -4331,15 +4334,15 @@ static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t *features)
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
 	    ip_hdrlen(skb) > sizeof(struct iphdr))
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 
 	/* IPv4 TCP header has options field */
 	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
 		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 
 	else if (rtl_last_frag_len(skb) <= 6)
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 }
 
 static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
@@ -4354,18 +4357,18 @@ static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
 
 		if (transport_offset > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			*features &= ~NETIF_F_ALL_TSO;
+			netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* work around hw bug on some chip versions */
 		if (skb->len < ETH_ZLEN)
-			*features &= ~NETIF_F_CSUM_MASK;
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 
 		if (rtl_quirk_packet_padto(tp, skb))
-			*features &= ~NETIF_F_CSUM_MASK;
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			*features &= ~NETIF_F_CSUM_MASK;
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 	}
 
 	vlan_features_check(skb, features);
@@ -4491,14 +4494,16 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 			if (status & RxCRC)
 				dev->stats.rx_crc_errors++;
 
-			if (!(dev->features & NETIF_F_RXALL))
+			if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						     dev->features))
 				goto release_descriptor;
 			else if (status & RxRWT || !(status & (RxRUNT | RxCRC)))
 				goto release_descriptor;
 		}
 
 		pkt_size = status & GENMASK(13, 0);
-		if (likely(!(dev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						    dev->features)))
 			pkt_size -= ETH_FCS_LEN;
 
 		/* The driver does not support incoming fragmented frames.
@@ -5317,7 +5322,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
 	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	rtl_init_rxcfg(tp);
 
@@ -5341,9 +5346,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
+	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO,
+				&dev->vlan_features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/*
@@ -5352,12 +5361,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
 		/* Disallow toggling */
-		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 &dev->hw_features);
 
 	if (rtl_chip_supports_csum_v2(tp))
-		dev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &dev->hw_features);
 
-	dev->features |= dev->hw_features;
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
 
 	/* There has been a number of reports that using SG/TSO results in
 	 * tx timeouts. However for a lot of people SG/TSO works fine.
@@ -5365,17 +5376,19 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * enable them. Use at own risk!
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6,
+					&dev->hw_features);
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
-		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO,
+					&dev->hw_features);
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
-	dev->hw_features |= NETIF_F_RXALL;
-	dev->hw_features |= NETIF_F_RXFCS;
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
 
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
-- 
2.33.0

