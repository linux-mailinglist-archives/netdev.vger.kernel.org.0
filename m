Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F941C8FC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345760AbhI2QAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27911 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344274AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWr4djFzbms0;
        Wed, 29 Sep 2021 23:53:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 038/167] s390: qeth: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:25 +0800
Message-ID: <20210929155334.12454-39-shenjian15@huawei.com>
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
 drivers/s390/net/qeth_core_main.c | 122 ++++++++++++++++++------------
 drivers/s390/net/qeth_l2_main.c   |  44 +++++++----
 drivers/s390/net/qeth_l3_main.c   |  41 ++++++----
 3 files changed, 130 insertions(+), 77 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6a1941e5fd51..21e4a356c717 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5608,7 +5608,8 @@ static void qeth_receive_skb(struct qeth_card *card, struct sk_buff *skb,
 		return;
 	}
 
-	if (is_cso && (card->dev->features & NETIF_F_RXCSUM)) {
+	if (is_cso && netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      card->dev->features)) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		QETH_CARD_STAT_INC(card, rx_skb_csum);
 	} else {
@@ -6385,10 +6386,10 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 
 	dev->ethtool_ops = &qeth_ethtool_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->hw_features |= NETIF_F_SG;
-	dev->vlan_features |= NETIF_F_SG;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->vlan_features);
 	if (IS_IQD(card))
-		dev->features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->features);
 
 	return dev;
 }
@@ -6835,18 +6836,21 @@ void qeth_enable_hw_features(struct net_device *dev)
 	struct qeth_card *card = dev->ml_priv;
 	netdev_features_t features;
 
-	features = dev->features;
+	netdev_feature_copy(&features, dev->features);
 	/* force-off any feature that might need an IPA sequence.
 	 * netdev_update_features() will restart them.
 	 */
-	dev->features &= ~dev->hw_features;
+	netdev_feature_andnot(&dev->features, dev->features,
+			      dev->hw_features);
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
-		dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		dev->wanted_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &dev->features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &dev->wanted_features);
 	}
 	netdev_update_features(dev);
-	if (features != dev->features)
+	if (!netdev_feature_equal(features, dev->features))
 		dev_warn(&card->gdev->dev,
 			 "Device recovery failed to restore all offload features\n");
 }
@@ -6856,69 +6860,88 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 					   netdev_features_t changed,
 					   netdev_features_t actual)
 {
-	netdev_features_t ipv6_features = NETIF_F_TSO6;
-	netdev_features_t ipv4_features = NETIF_F_TSO;
+	netdev_features_t ipv6_features;
+	netdev_features_t ipv4_features;
 
+	netdev_features_zero(&ipv6_features);
+	netdev_features_zero(&ipv4_features);
+	netdev_features_set_bit(NETIF_F_TSO6_BIT, &ipv6_features);
+	netdev_features_set_bit(NETIF_F_TSO_BIT, &ipv4_features);
 	if (!card->info.has_lp2lp_cso_v6)
-		ipv6_features |= NETIF_F_IPV6_CSUM;
+		netdev_features_set_bit(NETIF_F_IPV6_CSUM_BIT, &ipv6_features);
 	if (!card->info.has_lp2lp_cso_v4)
-		ipv4_features |= NETIF_F_IP_CSUM;
+		netdev_features_set_bit(NETIF_F_IP_CSUM_BIT, &ipv4_features);
 
-	if ((changed & ipv6_features) && !(actual & ipv6_features))
+	if (netdev_feature_intersects(ipv6_features, changed) &&
+	    !netdev_feature_intersects(ipv6_features, actual))
 		qeth_flush_local_addrs6(card);
-	if ((changed & ipv4_features) && !(actual & ipv4_features))
+	if (netdev_feature_intersects(ipv4_features, changed) &&
+	    !netdev_feature_intersects(ipv4_features, actual))
 		qeth_flush_local_addrs4(card);
 }
 
 int qeth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed, tmp1, tmp2;
 	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "setfeat");
 	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 
-	if ((changed & NETIF_F_IP_CSUM)) {
-		rc = qeth_set_ipa_csum(card, features & NETIF_F_IP_CSUM,
+	netdev_feature_xor(&changed, dev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
+		rc = qeth_set_ipa_csum(card,
+				       netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+							       features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
 				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
-			changed ^= NETIF_F_IP_CSUM;
+			netdev_feature_change_bit(NETIF_F_IP_CSUM_BIT, &changed);
 	}
-	if (changed & NETIF_F_IPV6_CSUM) {
-		rc = qeth_set_ipa_csum(card, features & NETIF_F_IPV6_CSUM,
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, changed)) {
+		rc = qeth_set_ipa_csum(card,
+				       netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT,
+							       features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
 				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
-			changed ^= NETIF_F_IPV6_CSUM;
+			netdev_feature_change_bit(NETIF_F_IPV6_CSUM_BIT, &changed);
 	}
-	if (changed & NETIF_F_RXCSUM) {
-		rc = qeth_set_ipa_rx_csum(card, features & NETIF_F_RXCSUM);
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
+		rc = qeth_set_ipa_rx_csum(card,
+					  netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+								  features));
 		if (rc)
-			changed ^= NETIF_F_RXCSUM;
+			netdev_feature_change_bit(NETIF_F_RXCSUM_BIT, &changed);
 	}
-	if (changed & NETIF_F_TSO) {
-		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO,
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, changed)) {
+		rc = qeth_set_ipa_tso(card,
+				      netdev_feature_test_bit(NETIF_F_TSO_BIT,
+							      features),
 				      QETH_PROT_IPV4);
 		if (rc)
-			changed ^= NETIF_F_TSO;
+			netdev_feature_change_bit(NETIF_F_TSO_BIT, &changed);
 	}
-	if (changed & NETIF_F_TSO6) {
-		rc = qeth_set_ipa_tso(card, features & NETIF_F_TSO6,
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, changed)) {
+		rc = qeth_set_ipa_tso(card,
+				      netdev_feature_test_bit(NETIF_F_TSO6_BIT,
+							      features),
 				      QETH_PROT_IPV6);
 		if (rc)
-			changed ^= NETIF_F_TSO6;
+			netdev_feature_change_bit(NETIF_F_TSO6_BIT, &changed);
 	}
 
-	qeth_check_restricted_features(card, dev->features ^ features,
-				       dev->features ^ changed);
+	netdev_feature_xor(&tmp1, dev->features, features);
+	netdev_feature_xor(&tmp2, dev->features, changed);
+	qeth_check_restricted_features(card, tmp1, tmp2);
 
 	/* everything changed successfully? */
-	if ((dev->features ^ features) == changed)
+	netdev_feature_xor(&tmp1, dev->features, features);
+	if (netdev_feature_equal(tmp1, changed))
 		return 0;
 	/* something went wrong. save changed features and return error */
-	dev->features ^= changed;
+	netdev_feature_xor(&dev->features, dev->features, changed);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
@@ -6929,16 +6952,16 @@ void qeth_fix_features(struct net_device *dev, netdev_features_t *features)
 
 	QETH_CARD_TEXT(card, 2, "fixfeat");
 	if (!qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM))
-		*features &= ~NETIF_F_IP_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT, features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6))
-		*features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT, features);
 	if (!qeth_is_supported(card, IPA_INBOUND_CHECKSUM) &&
 	    !qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6))
-		*features &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, features);
 	if (!qeth_is_supported(card, IPA_OUTBOUND_TSO))
-		*features &= ~NETIF_F_TSO;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
-		*features &= ~NETIF_F_TSO6;
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 
 	QETH_CARD_HEX(card, 2, features, sizeof(*features));
 }
@@ -6952,25 +6975,30 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Traffic with local next-hop is not eligible for some offloads: */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
-		netdev_features_t restricted = 0;
+		netdev_features_t restricted;
 
+		netdev_feature_zero(&restricted);
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
-			restricted |= NETIF_F_ALL_TSO;
+			netdev_feature_set_bits(NETIF_F_ALL_TSO, &restricted);
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			if (!card->info.has_lp2lp_cso_v4)
-				restricted |= NETIF_F_IP_CSUM;
+				netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+						       &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
-				*features &= ~restricted;
+				netdev_feature_andnot(features, features,
+						      &restricted);
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
-				restricted |= NETIF_F_IPV6_CSUM;
+				netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+						       &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				*features &= ~restricted;
+				netdev_feature_andnot(features, *features,
+						      restricted);
 			break;
 		default:
 			break;
@@ -6992,7 +7020,7 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 
 		/* linearize only if resulting skb allocations are order-0: */
 		if (SKB_DATA_ALIGN(hroom + doffset + hsize) <= SKB_MAX_HEAD(0))
-			*features &= ~NETIF_F_SG;
+			netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 	}
 
 	vlan_features_check(skb, features);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index dc6c00768d91..c9750d3e842c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1079,40 +1079,54 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (IS_OSM(card)) {
-		card->dev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				       &card->dev->features);
 	} else {
 		if (!IS_VM_NIC(card))
-			card->dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-		card->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       &card->dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &card->dev->features);
 	}
 
 	if (IS_OSD(card) && !IS_VM_NIC(card)) {
-		card->dev->features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &card->dev->features);
 		/* OSA 3S and earlier has no RX/TX support */
 		if (qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM)) {
-			card->dev->hw_features |= NETIF_F_IP_CSUM;
-			card->dev->vlan_features |= NETIF_F_IP_CSUM;
+			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+					       &card->dev->hw_features);
+			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+					       &card->dev->vlan_features);
 		}
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
-		card->dev->hw_features |= NETIF_F_IPV6_CSUM;
-		card->dev->vlan_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &card->dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &card->dev->vlan_features);
 	}
 	if (qeth_is_supported(card, IPA_INBOUND_CHECKSUM) ||
 	    qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6)) {
-		card->dev->hw_features |= NETIF_F_RXCSUM;
-		card->dev->vlan_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &card->dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &card->dev->vlan_features);
 	}
 	if (qeth_is_supported(card, IPA_OUTBOUND_TSO)) {
-		card->dev->hw_features |= NETIF_F_TSO;
-		card->dev->vlan_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT,
+				       &card->dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT,
+				       &card->dev->vlan_features);
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
-		card->dev->hw_features |= NETIF_F_TSO6;
-		card->dev->vlan_features |= NETIF_F_TSO6;
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+				       &card->dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+				       &card->dev->vlan_features);
 	}
 
-	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6)) {
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+				     card->dev->hw_features)) {
 		card->dev->needed_headroom = sizeof(struct qeth_hdr_tso);
 		netif_keep_dst(card->dev);
 		netif_set_gso_max_size(card->dev,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1d3d0377fe4b..54416c37f52f 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1809,7 +1809,8 @@ static void qeth_l3_osa_features_check(struct sk_buff *skb,
 				       netdev_features_t *features)
 {
 	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 	qeth_features_check(skb, dev, features);
 }
 
@@ -1878,26 +1879,35 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		dev->dev_id = qeth_l3_get_unique_id(card, dev->dev_id);
 
 		if (!IS_VM_NIC(card)) {
-			card->dev->features |= NETIF_F_SG;
-			card->dev->hw_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
-			card->dev->vlan_features |= NETIF_F_TSO |
-				NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+			netdev_feature_set_bit(NETIF_F_SG_BIT,
+					       &card->dev->features);
+			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM |
+						NETIF_F_IP_CSUM,
+						&card->dev->hw_features);
+			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM |
+						NETIF_F_IP_CSUM,
+						&card->dev->vlan_features);
 		}
 
 		if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
-			card->dev->hw_features |= NETIF_F_IPV6_CSUM;
-			card->dev->vlan_features |= NETIF_F_IPV6_CSUM;
+			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+					       &card->dev->hw_features);
+			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+					       &card->dev->vlan_features);
 		}
 		if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
-			card->dev->hw_features |= NETIF_F_TSO6;
-			card->dev->vlan_features |= NETIF_F_TSO6;
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+					       &card->dev->hw_features);
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+					       &card->dev->vlan_features);
 		}
 
 		/* allow for de-acceleration of NETIF_F_HW_VLAN_CTAG_TX: */
-		if (card->dev->hw_features & NETIF_F_TSO6)
+		if (netdev_feature_test_bit(NETIF_F_TSO6_BIT,
+					    card->dev->hw_features))
 			headroom = sizeof(struct qeth_hdr_tso) + VLAN_HLEN;
-		else if (card->dev->hw_features & NETIF_F_TSO)
+		else if (netdev_feature_test_bit(NETIF_F_TSO_BIT,
+						 card->dev->hw_features))
 			headroom = sizeof(struct qeth_hdr_tso);
 		else
 			headroom = sizeof(struct qeth_hdr) + VLAN_HLEN;
@@ -1913,11 +1923,12 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return -ENODEV;
 
 	card->dev->needed_headroom = headroom;
-	card->dev->features |=	NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &card->dev->features);
 
 	netif_keep_dst(card->dev);
-	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+				     card->dev->hw_features))
 		netif_set_gso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
-- 
2.33.0

