Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB341C95C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345552AbhI2QEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24144 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345609AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbR6jJSz1DHDh;
        Wed, 29 Sep 2021 23:56:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 102/167] net: jme: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:29 +0800
Message-ID: <20210929155334.12454-103-shenjian15@huawei.com>
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
 drivers/net/ethernet/jme.c | 44 ++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 11749bd7276d..3abd80bbe7dc 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -715,7 +715,7 @@ jme_set_clean_rxdesc(struct jme_adapter *jme, int i)
 	rxdesc->desc1.bufaddrl	= cpu_to_le32(
 					(__u64)rxbi->mapping & 0xFFFFFFFFUL);
 	rxdesc->desc1.datalen	= cpu_to_le16(rxbi->len);
-	if (jme->dev->features & NETIF_F_HIGHDMA)
+	if (netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT, jme->dev->features))
 		rxdesc->desc1.flags = RXFLAG_64BIT;
 	wmb();
 	rxdesc->desc1.flags	|= RXFLAG_OWN | RXFLAG_INT;
@@ -2004,7 +2004,8 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 	struct jme_ring *txring = &(jme->txring[0]);
 	struct txdesc *txdesc = txring->desc, *ctxdesc;
 	struct jme_buffer_info *txbi = txring->bufinf, *ctxbi;
-	bool hidma = jme->dev->features & NETIF_F_HIGHDMA;
+	bool hidma = netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT,
+					     jme->dev->features);
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
 	int mask = jme->tx_ring_mask;
 	u32 len;
@@ -2663,7 +2664,8 @@ static void jme_fix_features(struct net_device *netdev,
 			     netdev_features_t *features)
 {
 	if (netdev->mtu > 1900)
-		*features &= ~(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK);
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK,
+					  features);
 }
 
 static int
@@ -2672,7 +2674,7 @@ jme_set_features(struct net_device *netdev, netdev_features_t features)
 	struct jme_adapter *jme = netdev_priv(netdev);
 
 	spin_lock_bh(&jme->rxmcs_lock);
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		jme->reg_rxmcs |= RXMCS_CHECKSUM;
 	else
 		jme->reg_rxmcs &= ~RXMCS_CHECKSUM;
@@ -2953,21 +2955,25 @@ jme_init_one(struct pci_dev *pdev,
 	netdev->netdev_ops = &jme_netdev_ops;
 	netdev->ethtool_ops		= &jme_ethtool_ops;
 	netdev->watchdog_timeo		= TX_TIMEOUT;
-	netdev->hw_features		=	NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM |
-						NETIF_F_SG |
-						NETIF_F_TSO |
-						NETIF_F_TSO6 |
-						NETIF_F_RXCSUM;
-	netdev->features		=	NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM |
-						NETIF_F_SG |
-						NETIF_F_TSO |
-						NETIF_F_TSO6 |
-						NETIF_F_HW_VLAN_CTAG_TX |
-						NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXCSUM,
+				&netdev->hw_features);
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&netdev->features);
 	if (using_dac)
-		netdev->features	|=	NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
 	/* MTU range: 1280 - 9202*/
 	netdev->min_mtu = IPV6_MIN_MTU;
@@ -3030,7 +3036,7 @@ jme_init_one(struct pci_dev *pdev,
 	jme->reg_gpreg1 = GPREG1_DEFAULT;
 
 	if (jme->reg_rxmcs & RXMCS_CHECKSUM)
-		netdev->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
 
 	/*
 	 * Get Max Read Req Size from PCI Config Space
-- 
2.33.0

