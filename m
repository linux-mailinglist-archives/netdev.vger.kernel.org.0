Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6A841C93C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345904AbhI2QCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13847 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345528AbhI2P7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWb4gk5z8ywC;
        Wed, 29 Sep 2021 23:53:31 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 095/167] net: qualcomm: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:22 +0800
Message-ID: <20210929155334.12454-96-shenjian15@huawei.com>
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
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  6 +++--
 drivers/net/ethernet/qualcomm/emac/emac.c     | 25 +++++++++++--------
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 11 +++++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 10 +++++---
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 87b8c032195d..15a87e9de848 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -286,7 +286,8 @@ void emac_mac_mode_config(struct emac_adapter *adpt)
 	mac = readl(adpt->base + EMAC_MAC_CTRL);
 	mac &= ~(VLAN_STRIP | PROM_MODE | MULTI_ALL | MAC_LP_EN);
 
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    netdev->features))
 		mac |= VLAN_STRIP;
 
 	if (netdev->flags & IFF_PROMISC)
@@ -1143,7 +1144,8 @@ void emac_mac_rx_process(struct emac_adapter *adpt, struct emac_rx_queue *rx_q,
 		skb_put(skb, RRD_PKT_SIZE(&rrd) - ETH_FCS_LEN);
 		skb->dev = netdev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
-		if (netdev->features & NETIF_F_RXCSUM)
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    netdev->features))
 			skb->ip_summed = RRD_L4F(&rrd) ?
 					  CHECKSUM_NONE : CHECKSUM_UNNECESSARY;
 		else
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 9015a38eaced..71c403cb5e6c 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -175,13 +175,16 @@ static irqreturn_t emac_isr(int _irq, void *data)
 static int emac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
 	struct emac_adapter *adpt = netdev_priv(netdev);
+	netdev_features_t changed;
+
+	netdev_feature_xor(&changed, features, netdev->features);
 
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
 	 */
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				     NETIF_F_HW_VLAN_CTAG_RX, changed))
 		return 0;
 
 	if (!netif_running(netdev))
@@ -190,7 +193,7 @@ static int emac_set_features(struct net_device *netdev,
 	/* emac_mac_mode_config() uses netdev->features to configure the EMAC,
 	 * so make sure it's set first.
 	 */
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 
 	return emac_reinit_locked(adpt);
 }
@@ -668,13 +671,15 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* set hw features */
-	netdev->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features = netdev->features;
-
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_HW_CSUM |
-				 NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX, &netdev->features);
+	netdev_feature_copy(&netdev->hw_features, netdev->features);
+
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6,
+				&netdev->vlan_features);
 
 	/* MTU range: 46 - 9194 */
 	netdev->min_mtu = EMAC_MIN_ETH_FRAME_SIZE -
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3676976c875b..45fb2dacaafa 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -406,7 +406,8 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 	struct rmnet_priv *priv = netdev_priv(skb->dev);
 	struct rmnet_map_dl_csum_trailer *csum_trailer;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      skb->dev->features))) {
 		priv->stats.csum_sw++;
 		return -EOPNOTSUPP;
 	}
@@ -439,8 +440,9 @@ static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
 	ul_header = (struct rmnet_map_ul_csum_header *)
 		    skb_push(skb, sizeof(struct rmnet_map_ul_csum_header));
 
-	if (unlikely(!(orig_dev->features &
-		     (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))))
+	if (unlikely(!netdev_feature_test_bits(NETIF_F_IP_CSUM |
+					       NETIF_F_IPV6_CSUM,
+					       orig_dev->features)))
 		goto sw_csum;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
@@ -506,7 +508,8 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 	if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
 		return -EINVAL;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      skb->dev->features))) {
 		priv->stats.csum_sw++;
 	} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
 		priv->stats.csum_ok++;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 13d8eb43a485..d6d3dabe7c11 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -236,7 +236,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->needs_free_netdev = true;
 	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
 
-	rmnet_dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &rmnet_dev->features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -261,9 +261,11 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		return -EBUSY;
 	}
 
-	rmnet_dev->hw_features = NETIF_F_RXCSUM;
-	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	rmnet_dev->hw_features |= NETIF_F_SG;
+	netdev_feature_zero(&rmnet_dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &rmnet_dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				&rmnet_dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &rmnet_dev->hw_features);
 
 	priv->real_dev = real_dev;
 
-- 
2.33.0

