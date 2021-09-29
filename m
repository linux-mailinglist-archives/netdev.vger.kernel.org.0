Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2231B41C93D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbhI2QC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12983 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345535AbhI2P74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:56 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbS0FGjzWNSn;
        Wed, 29 Sep 2021 23:56:52 +0800 (CST)
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
Subject: [RFCv2 net-next 104/167] net: cavium: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:31 +0800
Message-ID: <20210929155334.12454-105-shenjian15@huawei.com>
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
 .../net/ethernet/cavium/liquidio/lio_core.c   |  6 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 89 ++++++++++++-------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 73 +++++++++------
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 44 +++++----
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 5 files changed, 133 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 2a0d64e5797c..70e83610654b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -660,7 +660,8 @@ liquidio_push_packet(u32 __maybe_unused octeon_id,
 		skb_pull(skb, rh->r_dh.len * BYTES_PER_DHLEN_UNIT);
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
-		if ((netdev->features & NETIF_F_RXCSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    netdev->features) &&
 		    (((rh->r_dh.encap_on) &&
 		      (rh->r_dh.csum_verified & CNNIC_TUN_CSUM_VERIFIED)) ||
 		     (!(rh->r_dh.encap_on) &&
@@ -681,7 +682,8 @@ liquidio_push_packet(u32 __maybe_unused octeon_id,
 		}
 
 		/* inbound VLAN tag */
-		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    netdev->features) &&
 		    rh->r_dh.vlan) {
 			u16 priority = rh->r_dh.priority;
 			u16 vid = rh->r_dh.vlan;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 43c256ad2790..b9f610c48ca2 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2723,31 +2723,37 @@ static void liquidio_fix_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((*request & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		*request &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, request);
 
-	if ((*request & NETIF_F_HW_CSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *request) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		*request &= ~NETIF_F_HW_CSUM;
+		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT, request);
 
-	if ((*request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		*request &= ~NETIF_F_TSO;
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_TSO))
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, request);
 
-	if ((*request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		*request &= ~NETIF_F_TSO6;
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_TSO6))
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, request);
 
-	if ((*request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		*request &= ~NETIF_F_LRO;
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_LRO))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
 	/*Disable LRO if RXCSUM is off */
-	if (!(*request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		*request &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
-	if ((*request & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    *request) &&
 	    !(lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER))
-		*request &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 request);
 }
 
 /**
@@ -2760,40 +2766,45 @@ static int liquidio_set_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((features & NETIF_F_LRO) &&
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
 	    (lio->dev_capability & NETIF_F_LRO) &&
-	    !(netdev->features & NETIF_F_LRO))
+	    !netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!(features & NETIF_F_LRO) &&
+	else if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
 		 (lio->dev_capability & NETIF_F_LRO) &&
-		 (netdev->features & NETIF_F_LRO))
+		 netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
 	/* Sending command to firmware to enable/disable RX checksum
 	 * offload settings using ethtool
 	 */
-	if (!(netdev->features & NETIF_F_RXCSUM) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features) &&
 	    (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-	    (features & NETIF_F_RXCSUM))
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev,
 					    OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
-	else if ((netdev->features & NETIF_F_RXCSUM) &&
+	else if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					 netdev->features) &&
 		 (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-		 !(features & NETIF_F_RXCSUM))
+		 !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    features) &&
 	    (lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     netdev->features))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
 				     OCTNET_CMD_VLAN_FILTER_ENABLE);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  features) &&
 		 (lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		 netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 netdev->features))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
 				     OCTNET_CMD_VLAN_FILTER_DISABLE);
 
@@ -3578,25 +3589,35 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  | NETIF_F_TSO | NETIF_F_TSO6
 					  | NETIF_F_LRO;
 
-		netdev->hw_enc_features = (lio->enc_dev_capability &
-					   ~NETIF_F_LRO);
+		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_set_bits(lio->enc_dev_capability,
+					&netdev->hw_enc_features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT,
+					 &netdev->hw_enc_features);
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
 		lio->dev_capability |= NETIF_F_GSO_UDP_TUNNEL;
 
-		netdev->vlan_features = lio->dev_capability;
+		netdev_feature_zero(&netdev->vlan_features);
+		netdev_feature_set_bits(lio->dev_capability,
+					&netdev->vlan_features);
 		/* Add any unchangeable hw features */
 		lio->dev_capability |=  NETIF_F_HW_VLAN_CTAG_FILTER |
 					NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_CTAG_TX;
 
-		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
+		netdev_feature_zero(&netdev->features);
+		netdev_feature_set_bits(lio->dev_capability,
+					&netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
 
-		netdev->hw_features = lio->dev_capability;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(lio->dev_capability,
+					&netdev->hw_features);
 		/*HW_VLAN_RX and HW_VLAN_FILTER is always on*/
-		netdev->hw_features = netdev->hw_features &
-			~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 &netdev->hw_features);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
@@ -3664,7 +3685,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		else
 			octeon_dev->priv_flags = 0x0;
 
-		if (netdev->features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 			liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 					     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 1c4c039dff9b..1653c058e4b9 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1820,27 +1820,31 @@ static void liquidio_fix_features(struct net_device *netdev,
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((*request & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		*request &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, request);
 
-	if ((*request & NETIF_F_HW_CSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *request) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		*request &= ~NETIF_F_HW_CSUM;
+		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT, request);
 
-	if ((*request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		*request &= ~NETIF_F_TSO;
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_TSO))
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, request);
 
-	if ((*request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		*request &= ~NETIF_F_TSO6;
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_TSO6))
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, request);
 
-	if ((*request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		*request &= ~NETIF_F_LRO;
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *request) &&
+	    !(lio->dev_capability & NETIF_F_LRO))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
 	/* Disable LRO if RXCSUM is off */
-	if (!(*request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		*request &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 }
 
 /** \brief Net device set features
@@ -1851,25 +1855,29 @@ static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
 	struct lio *lio = netdev_priv(netdev);
+	netdev_features_t changed;
 
-	if (!((netdev->features ^ features) & NETIF_F_LRO))
+	netdev_feature_xor(&changed, netdev->features, features);
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	if ((features & NETIF_F_LRO) && (lio->dev_capability & NETIF_F_LRO))
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
+	    (lio->dev_capability & NETIF_F_LRO))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!(features & NETIF_F_LRO) &&
+	else if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
 		 (lio->dev_capability & NETIF_F_LRO))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	if (!(netdev->features & NETIF_F_RXCSUM) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features) &&
 	    (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-	    (features & NETIF_F_RXCSUM))
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
-	else if ((netdev->features & NETIF_F_RXCSUM) &&
+	else if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					 netdev->features) &&
 		 (lio->enc_dev_capability & NETIF_F_RXCSUM) &&
-		 !(features & NETIF_F_RXCSUM))
+		 !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
@@ -2108,20 +2116,33 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  | NETIF_F_TSO | NETIF_F_TSO6
 					  | NETIF_F_LRO;
 
-		netdev->hw_enc_features =
-		    (lio->enc_dev_capability & ~NETIF_F_LRO);
+		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_set_bits(lio->enc_dev_capability,
+					&netdev->hw_enc_features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT,
+					 &netdev->hw_enc_features);
+
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
-		netdev->vlan_features = lio->dev_capability;
+		netdev_feature_zero(&netdev->vlan_features);
+		netdev_feature_set_bits(lio->enc_dev_capability,
+					&netdev->vlan_features);
+
 		/* Add any unchangeable hw features */
 		lio->dev_capability |= NETIF_F_HW_VLAN_CTAG_FILTER |
 				       NETIF_F_HW_VLAN_CTAG_RX |
 				       NETIF_F_HW_VLAN_CTAG_TX;
 
-		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
+		netdev_feature_zero(&netdev->features);
+		netdev_feature_set_bits(lio->enc_dev_capability,
+					&netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
 
-		netdev->hw_features = lio->dev_capability;
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(lio->enc_dev_capability,
+					&netdev->hw_features);
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 &netdev->hw_features);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
@@ -2185,7 +2206,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		else
 			octeon_dev->priv_flags = 0x0;
 
-		if (netdev->features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 			liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 					     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 781138a71458..de451d94e1a7 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -732,7 +732,7 @@ static inline void nicvf_set_rxhash(struct net_device *netdev,
 	u8 hash_type;
 	u32 hash;
 
-	if (!(netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		return;
 
 	switch (cqe_rx->rss_alg) {
@@ -823,7 +823,7 @@ static void nicvf_rcv_pkt_handler(struct net_device *netdev,
 	nicvf_set_rxhash(netdev, cqe_rx, skb);
 
 	skb_record_rx_queue(skb, rq_idx);
-	if (netdev->hw_features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->hw_features)) {
 		/* HW by default verifies TCP/UDP/SCTP checksums */
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else {
@@ -837,7 +837,7 @@ static void nicvf_rcv_pkt_handler(struct net_device *netdev,
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       ntohs((__force __be16)cqe_rx->vlan_tci));
 
-	if (napi && (netdev->features & NETIF_F_GRO))
+	if (napi && netdev_feature_test_bit(NETIF_F_GRO_BIT, netdev->features))
 		napi_gro_receive(napi, skb);
 	else
 		netif_receive_skb(skb);
@@ -1768,7 +1768,8 @@ static int nicvf_config_loopback(struct nicvf *nic,
 
 	mbx.lbk.msg = NIC_MBOX_MSG_LOOPBACK;
 	mbx.lbk.vf_id = nic->vf_id;
-	mbx.lbk.enable = (features & NETIF_F_LOOPBACK) != 0;
+	mbx.lbk.enable = netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+						 features);
 
 	return nicvf_send_msg_to_pf(nic, &mbx);
 }
@@ -1778,21 +1779,24 @@ static void nicvf_fix_features(struct net_device *netdev,
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	if ((*features & NETIF_F_LOOPBACK) &&
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, *features) &&
 	    netif_running(netdev) && !nic->loopback_supported)
-		*features &= ~NETIF_F_LOOPBACK;
+		netdev_feature_clear_bit(NETIF_F_LOOPBACK_BIT, features);
 }
 
 static int nicvf_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		nicvf_config_vlan_stripping(nic, features);
 
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(netdev))
 		return nicvf_config_loopback(nic, features);
 
 	return 0;
@@ -2209,18 +2213,22 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_unregister_interrupts;
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_SG |
-			       NETIF_F_TSO | NETIF_F_GRO | NETIF_F_TSO6 |
-			       NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			       NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_SG |
+				NETIF_F_TSO | NETIF_F_GRO | NETIF_F_TSO6 |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
 
-	netdev->hw_features |= NETIF_F_RXHASH;
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features;
-	netdev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &netdev->hw_features);
 
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_feature_zero(&netdev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6,
+				&netdev->vlan_features);
 
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 50bbe79fb93d..5e95b42d7207 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -714,7 +714,7 @@ void nicvf_config_vlan_stripping(struct nicvf *nic, netdev_features_t features)
 	rq_cfg = nicvf_queue_reg_read(nic, NIC_QSET_RQ_GEN_CFG, 0);
 
 	/* Enable first VLAN stripping */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		rq_cfg |= (1ULL << 25);
 	else
 		rq_cfg &= ~(1ULL << 25);
-- 
2.33.0

