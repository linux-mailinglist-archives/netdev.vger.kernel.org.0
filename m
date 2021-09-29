Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8B841C955
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346544AbhI2QEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23327 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345592AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWz5dRvzRQKp;
        Wed, 29 Sep 2021 23:53:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 089/167] net: atheros: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:16 +0800
Message-ID: <20210929155334.12454-90-shenjian15@huawei.com>
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
 drivers/net/ethernet/atheros/alx/main.c       | 17 +++++----
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 27 +++++++------
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 38 +++++++++++--------
 drivers/net/ethernet/atheros/atlx/atl1.c      | 15 +++++---
 drivers/net/ethernet/atheros/atlx/atl2.c      | 21 ++++++----
 drivers/net/ethernet/atheros/atlx/atlx.c      | 14 ++++---
 6 files changed, 78 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 922c600fd292..2f79aa6f41a4 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -261,7 +261,8 @@ static int alx_clean_rx_irq(struct alx_rx_queue *rxq, int budget)
 		skb->protocol = eth_type_trans(skb, rxq->netdev);
 
 		skb_checksum_none_assert(skb);
-		if (alx->dev->features & NETIF_F_RXCSUM &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    alx->dev->features) &&
 		    !(rrd->word3 & (cpu_to_le32(1 << RRD_ERR_L4_SHIFT) |
 				    cpu_to_le32(1 << RRD_ERR_IPV4_SHIFT)))) {
 			switch (ALX_GET_FIELD(le32_to_cpu(rrd->word2),
@@ -1101,7 +1102,8 @@ static void alx_fix_features(struct net_device *netdev,
 			     netdev_features_t *features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					  features);
 }
 
 static void alx_netif_stop(struct alx_priv *alx)
@@ -1816,11 +1818,12 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_HW_CSUM |
+				NETIF_F_RXCSUM |
+				NETIF_F_TSO |
+				NETIF_F_TSO6, &netdev->hw_features);
 
 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
 		dev_warn(&pdev->dev,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 66c0985adb43..eea741e971ae 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -429,7 +429,7 @@ static void atl1c_set_multi(struct net_device *netdev)
 
 static void __atl1c_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -514,23 +514,27 @@ static void atl1c_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
+						  features);
 	}
 }
 
 static int atl1c_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1c_vlan_mode(netdev, features);
 
 	return 0;
@@ -2626,13 +2630,14 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	atl1c_set_ethtool_ops(netdev);
 
 	/* TODO: add when ready */
-	netdev->hw_features =	NETIF_F_SG		|
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG		|
 				NETIF_F_HW_CSUM		|
 				NETIF_F_HW_VLAN_CTAG_RX	|
 				NETIF_F_TSO		|
-				NETIF_F_TSO6;
-	netdev->features =	netdev->hw_features	|
-				NETIF_F_HW_VLAN_CTAG_TX;
+				NETIF_F_TSO6, &netdev->hw_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, &netdev->features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ea99949c91eb..fe5339b0ca7f 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -299,7 +299,7 @@ static void atl1e_set_multi(struct net_device *netdev)
 static void __atl1e_rx_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
 
-	if (features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, features)) {
 		/* enable RX of ALL frames */
 		*mac_ctrl_data |= MAC_CTRL_DBG;
 	} else {
@@ -326,7 +326,7 @@ static void atl1e_rx_mode(struct net_device *netdev,
 
 static void __atl1e_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -389,24 +389,25 @@ static void atl1e_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int atl1e_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1e_vlan_mode(netdev, features);
 
-	if (changed & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed))
 		atl1e_rx_mode(netdev, features);
 
-
 	return 0;
 }
 
@@ -1065,7 +1066,7 @@ static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
 		value |= MAC_CTRL_PROMIS_EN;
 	if (netdev->flags & IFF_ALLMULTI)
 		value |= MAC_CTRL_MC_ALL_EN;
-	if (netdev->features & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, netdev->features))
 		value |= MAC_CTRL_DBG;
 	AT_WRITE_REG(hw, REG_MAC_CTRL, value);
 }
@@ -1427,7 +1428,8 @@ static void atl1e_clean_rx_irq(struct atl1e_adapter *adapter, u8 que,
 
 			/* error packet */
 			if ((prrs->pkt_flag & RRS_IS_ERR_FRAME) &&
-			    !(netdev->features & NETIF_F_RXALL)) {
+			    !netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						     netdev->features)) {
 				if (prrs->err_flag & (RRS_ERR_BAD_CRC |
 					RRS_ERR_DRIBBLE | RRS_ERR_CODE |
 					RRS_ERR_TRUNC)) {
@@ -1441,7 +1443,8 @@ static void atl1e_clean_rx_irq(struct atl1e_adapter *adapter, u8 que,
 
 			packet_size = ((prrs->word1 >> RRS_PKT_SIZE_SHIFT) &
 					RRS_PKT_SIZE_MASK);
-			if (likely(!(netdev->features & NETIF_F_RXFCS)))
+			if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+							    netdev->features)))
 				packet_size -= 4; /* CRC */
 
 			skb = netdev_alloc_skb_ip_align(netdev, packet_size);
@@ -2267,11 +2270,14 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 	atl1e_set_ethtool_ops(netdev);
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, &netdev->features);
 	/* not enabled by default */
-	netdev->hw_features |= NETIF_F_RXALL | NETIF_F_RXFCS;
+	netdev_feature_set_bits(NETIF_F_RXALL | NETIF_F_RXFCS,
+				&netdev->hw_features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 68f6c0bbd945..a717cd030c69 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2988,15 +2988,18 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_common;
 
-	netdev->features = NETIF_F_HW_CSUM;
-	netdev->features |= NETIF_F_SG;
-	netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
 
-	netdev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
-			      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
 
 	/* is this valid? see atl1_setup_mac_ctrl() */
-	netdev->features |= NETIF_F_RXCSUM;
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
 
 	/* MTU range: 42 - 10218 */
 	netdev->min_mtu = ETH_ZLEN - (ETH_HLEN + VLAN_HLEN);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index c4d303ce284c..2db693636588 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -342,7 +342,7 @@ static inline void atl2_irq_disable(struct atl2_adapter *adapter)
 
 static void __atl2_vlan_mode(netdev_features_t features, u32 *ctrl)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -378,18 +378,20 @@ static void atl2_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int atl2_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl2_vlan_mode(netdev, features);
 
 	return 0;
@@ -1387,8 +1389,11 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev->hw_features = NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
 
 	/* Init PHY as early as possible due to power saving issue  */
 	atl2_phy_init(&adapter->hw);
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 3b0dbc3a5896..6e91bf6f54d0 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -207,7 +207,7 @@ static void atlx_link_chg_task(struct work_struct *work)
 
 static void __atlx_vlan_mode(netdev_features_t features, u32 *ctrl)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -244,18 +244,20 @@ static void atlx_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int atlx_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atlx_vlan_mode(netdev, features);
 
 	return 0;
-- 
2.33.0

