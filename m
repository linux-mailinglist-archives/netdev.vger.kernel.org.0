Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CF41C936
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345834AbhI2QCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13845 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345510AbhI2P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWY6Lh1z8yj7;
        Wed, 29 Sep 2021 23:53:29 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 086/167] net: hisilicon: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:13 +0800
Message-ID: <20210929155334.12454-87-shenjian15@huawei.com>
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
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  47 ++++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 100 +++++++++++-------
 3 files changed, 97 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index c1aae0fca5e9..da15dbf69475 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1234,10 +1234,12 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 
 	if (HAS_CAP_TSO(priv->hw_cap))
-		ndev->hw_features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->hw_features);
 
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
-	ndev->vlan_features |= ndev->features;
+	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->hw_features);
+	netdev_feature_or(&ndev->vlan_features, ndev->vlan_features,
+			  ndev->features);
 
 	ret = hix5hd2_init_hw_desc_queue(priv);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 1e08c18c813f..6a7235d94985 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -479,7 +479,8 @@ static void hns_nic_rx_checksum(struct hns_nic_ring_data *ring_data,
 	u32 l4id;
 
 	/* check if RX checksum offload is enabled */
-	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      netdev->features)))
 		return;
 
 	/* In hardware, we only support checksum for the following protocols:
@@ -1774,11 +1775,13 @@ static int hns_nic_set_features(struct net_device *netdev,
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
+		if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					     features))
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6)) {
+		if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					     features)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
@@ -1789,7 +1792,7 @@ static int hns_nic_set_features(struct net_device *netdev,
 		}
 		break;
 	}
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 	return 0;
 }
 
@@ -1800,8 +1803,9 @@ static void hns_nic_fix_features(struct net_device *netdev,
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		*features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6 |
+					  NETIF_F_HW_VLAN_CTAG_FILTER,
+					  features);
 		break;
 	default:
 		break;
@@ -2162,8 +2166,8 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
 	} else {
 		priv->ops.get_rxd_bnum = get_v2rx_desc_bnum;
-		if ((netdev->features & NETIF_F_TSO) ||
-		    (netdev->features & NETIF_F_TSO6)) {
+		if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					     netdev->features)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* This chip only support 7*4096 */
@@ -2324,22 +2328,27 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &hns_nic_netdev_ops;
 	hns_ethtool_set_ops(ndev);
 
-	ndev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO;
-	ndev->vlan_features |=
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
-	ndev->vlan_features |= NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
+				NETIF_F_GRO, &ndev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM, &ndev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO,
+				&ndev->vlan_features);
 
 	/* MTU range: 68 - 9578 (v1) or 9706 (v2) */
 	ndev->min_mtu = MAC_MIN_MTU;
 	switch (priv->enet_ver) {
 	case AE_VERSION_2:
-		ndev->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_NTUPLE;
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-			NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6;
-		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 |
+					NETIF_F_NTUPLE, &ndev->features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM | NETIF_F_SG |
+					NETIF_F_GSO | NETIF_F_GRO |
+					NETIF_F_TSO | NETIF_F_TSO6,
+					&ndev->hw_features);
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&ndev->vlan_features);
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e8179ac6d4e3..180019026650 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -380,6 +380,13 @@ static const struct hns3_rx_ptype hns3_rx_ptype_tbl[] = {
 #define HNS3_INVALID_PTYPE \
 		ARRAY_SIZE(hns3_rx_ptype_tbl)
 
+static const int hns3_features_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT, NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT, NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
+	NETIF_F_GSO_BIT, NETIF_F_GRO_BIT, NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+	NETIF_F_GSO_GRE_BIT, NETIF_F_SCTP_CRC_BIT, NETIF_F_FRAGLIST_BIT
+};
+
 static irqreturn_t hns3_irq_handle(int irq, void *vector)
 {
 	struct hns3_enet_tqp_vector *tqp_vector = vector;
@@ -1487,7 +1494,8 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				     handle->kinfo.netdev->features)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -2308,48 +2316,56 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	netdev_features_t changed;
 	bool enable;
 	int ret;
 
-	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
-		enable = !!(features & NETIF_F_GRO_HW);
+	netdev_feature_xor(&changed, netdev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, changed) &&
+	    h->ae_algo->ops->set_gro_en) {
+		enable = netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+		enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						 features);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
-		enable = !!(features & NETIF_F_NTUPLE);
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed) &&
+	    h->ae_algo->ops->enable_fd) {
+		enable = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, netdev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    changed) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						 features);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 	return 0;
 }
 
@@ -2378,7 +2394,8 @@ static void hns3_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 }
 
 static void hns3_nic_get_stats64(struct net_device *netdev,
@@ -3130,46 +3147,56 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
+			       &netdev->gso_partial_features);
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_feature_set_bit_array(hns3_features_array,
+				     ARRAY_SIZE(hns3_features_array),
+				     &netdev->features);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &netdev->features);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
+					       &netdev->features);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
+				       &netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				       &netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
 
-	netdev->hw_features |= netdev->features;
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &netdev->hw_features);
 
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				  NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW |
+				  NETIF_F_NTUPLE | NETIF_F_HW_TC,
+				  &netdev->vlan_features);
 
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->hw_enc_features);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
@@ -3728,7 +3755,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 
 	skb_checksum_none_assert(skb);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features))
 		return;
 
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
@@ -4036,7 +4063,8 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
 	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    netdev->features)) {
 		u16 vlan_tag;
 
 		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
-- 
2.33.0

