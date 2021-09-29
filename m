Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F3F41C97A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbhI2QFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:44 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24186 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345664AbhI2QAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc208Mjz8tY6;
        Wed, 29 Sep 2021 23:57:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 123/167] net: bna: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:50 +0800
Message-ID: <20210929155334.12454-124-shenjian15@huawei.com>
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
 drivers/net/ethernet/brocade/bna/bnad.c | 48 ++++++++++++++++---------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ba47777d9cff..2e51cf6fb1c3 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -698,7 +698,8 @@ bnad_cq_process(struct bnad *bnad, struct bna_ccb *ccb, int budget)
 		masked_flags = flags & flags_cksum_prot_mask;
 
 		if (likely
-		    ((bnad->netdev->features & NETIF_F_RXCSUM) &&
+		    (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					     bnad->netdev->features) &&
 		     ((masked_flags == flags_tcp4) ||
 		      (masked_flags == flags_udp4) ||
 		      (masked_flags == flags_tcp6) ||
@@ -708,7 +709,8 @@ bnad_cq_process(struct bnad *bnad, struct bna_ccb *ccb, int budget)
 			skb_checksum_none_assert(skb);
 
 		if ((flags & BNA_CQ_EF_VLAN) &&
-		    (bnad->netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
+		    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    bnad->netdev->features))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), ntohs(cmpl->vlan_tag));
 
 		if (BNAD_RXBUF_IS_SK_BUFF(unmap_q->type))
@@ -2082,7 +2084,8 @@ bnad_init_rx_config(struct bnad *bnad, struct bna_rx_config *rx_config)
 	}
 
 	rx_config->vlan_strip_status =
-		(bnad->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) ?
+		netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					bnad->netdev->features) ?
 		BNA_STATUS_T_ENABLED : BNA_STATUS_T_DISABLED;
 }
 
@@ -3349,14 +3352,17 @@ bnad_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnad *bnad = netdev_priv(dev);
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed;
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(dev)) {
+	netdev_feature_xor(&changed, features, dev->features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
+	    netif_running(dev)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&bnad->bna_lock, flags);
 
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			bna_rx_vlan_strip_enable(bnad->rx_info[0].rx);
 		else
 			bna_rx_vlan_strip_disable(bnad->rx_info[0].rx);
@@ -3425,19 +3431,27 @@ bnad_netdev_init(struct bnad *bnad, bool using_dac)
 {
 	struct net_device *netdev = bnad->netdev;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
-
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_HIGHDMA |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6;
-
-	netdev->features |= netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&netdev->hw_features);
+
+	netdev_feature_zero(&netdev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6,
+				&netdev->vlan_features);
+
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &netdev->features);
 
 	if (using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
 	netdev->mem_start = bnad->mmio_start;
 	netdev->mem_end = bnad->mmio_start + bnad->mmio_len - 1;
-- 
2.33.0

