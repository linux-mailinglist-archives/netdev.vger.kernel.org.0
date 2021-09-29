Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC3741C963
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345892AbhI2QFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27920 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345593AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWz0DsJzbmrK;
        Wed, 29 Sep 2021 23:53:51 +0800 (CST)
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
Subject: [RFCv2 net-next 085/167] net: intel: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:12 +0800
Message-ID: <20210929155334.12454-86-shenjian15@huawei.com>
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
 drivers/net/ethernet/intel/e100.c             |  26 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  76 ++++---
 drivers/net/ethernet/intel/e1000e/netdev.c    | 123 ++++++-----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   9 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  57 ++---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 109 ++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 134 +++++++-----
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 158 ++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   9 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 129 +++++++-----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  71 ++++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   3 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 109 ++++++----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  43 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   |   3 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 194 +++++++++++-------
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   9 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  90 ++++----
 26 files changed, 850 insertions(+), 554 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 373eb027b925..abec49f6b541 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1114,7 +1114,8 @@ static int e100_configure(struct nic *nic, struct cb *cb, struct sk_buff *skb)
 		config->promiscuous_mode = 0x1;		/* 1=on, 0=off */
 	}
 
-	if (unlikely(netdev->features & NETIF_F_RXFCS))
+	if (unlikely(netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+					     netdev->features)))
 		config->rx_crc_transfer = 0x1;	/* 1=save, 0=discard */
 
 	if (nic->flags & multicast_all)
@@ -1141,7 +1142,7 @@ static int e100_configure(struct nic *nic, struct cb *cb, struct sk_buff *skb)
 		}
 	}
 
-	if (netdev->features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, netdev->features)) {
 		config->rx_save_overruns = 0x1; /* 1=save, 0=discard */
 		config->rx_save_bad_frames = 0x1;       /* 1=save, 0=discard */
 		config->rx_discard_short_frames = 0x0;  /* 1=discard, 0=save */
@@ -1990,7 +1991,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	}
 
 	/* Get actual data size */
-	if (unlikely(dev->features & NETIF_F_RXFCS))
+	if (unlikely(netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+					     dev->features)))
 		fcs_pad = 4;
 	actual_size = le16_to_cpu(rfd->actual_size) & 0x3FFF;
 	if (unlikely(actual_size > RFD_BUF_LEN - sizeof(struct rfd)))
@@ -2021,7 +2023,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	/* If we are receiving all frames, then don't bother
 	 * checking for errors.
 	 */
-	if (unlikely(dev->features & NETIF_F_RXALL)) {
+	if (unlikely(netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					     dev->features))) {
 		if (actual_size > ETH_DATA_LEN + VLAN_ETH_HLEN + fcs_pad)
 			/* Received oversized frame, but keep it. */
 			nic->rx_over_length_errors++;
@@ -2792,12 +2795,14 @@ static int e100_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct nic *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (!(changed & (NETIF_F_RXFCS | NETIF_F_RXALL)))
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (!netdev_feature_test_bits(NETIF_F_RXFCS | NETIF_F_RXALL, changed))
 		return 0;
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 	e100_exec_cb(nic, NULL, e100_configure);
 	return 1;
 }
@@ -2826,9 +2831,9 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(netdev = alloc_etherdev(sizeof(struct nic))))
 		return -ENOMEM;
 
-	netdev->hw_features |= NETIF_F_RXFCS;
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
 
 	netdev->netdev_ops = &e100_netdev_ops;
 	netdev->ethtool_ops = &e100_ethtool_ops;
@@ -2885,7 +2890,8 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* D100 MAC doesn't allow rx of vlan packets with normal MTU */
 	if (nic->mac < mac_82558_D101_A4)
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				       &netdev->features);
 
 	/* locks must be initialized before calling hw_reset */
 	spin_lock_init(&nic->cb_lock);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index e333ca1e7395..34536befc4ea 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -793,26 +793,30 @@ static void e1000_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
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
 
 static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		e1000_vlan_mode(netdev, features);
 
-	if (!(changed & (NETIF_F_RXCSUM | NETIF_F_RXALL)))
+	if (!netdev_feature_test_bits(NETIF_F_RXCSUM | NETIF_F_RXALL, changed))
 		return 0;
 
-	netdev->features = features;
-	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
+	netdev_feature_copy(&netdev->features, features);
+	adapter->rx_csum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						   features);
 
 	if (netif_running(netdev))
 		e1000_reinit_locked(adapter);
@@ -1033,32 +1037,40 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (hw->mac_type >= e1000_82543) {
-		netdev->hw_features = NETIF_F_SG |
-				   NETIF_F_HW_CSUM |
-				   NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features = NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG |
+					NETIF_F_HW_CSUM |
+					NETIF_F_HW_VLAN_CTAG_RX,
+					&netdev->hw_features);
+		netdev_feature_zero(&netdev->features);
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_FILTER,
+					&netdev->features);
 	}
 
 	if ((hw->mac_type >= e1000_82544) &&
 	   (hw->mac_type != e1000_82547))
-		netdev->hw_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
-	netdev->features |= netdev->hw_features;
-	netdev->hw_features |= (NETIF_F_RXCSUM |
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM |
 				NETIF_F_RXALL |
-				NETIF_F_RXFCS);
+				NETIF_F_RXFCS,
+				&netdev->hw_features);
 
 	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
-	netdev->vlan_features |= (NETIF_F_TSO |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_SG);
+	netdev_feature_set_bits(NETIF_F_TSO |
+				NETIF_F_HW_CSUM |
+				NETIF_F_SG,
+				&netdev->vlan_features);
 
 	/* Do not set IFF_UNICAST_FLT for VMWare's 82545EM */
 	if (hw->device_id != E1000_DEV_ID_82545EM_COPPER ||
@@ -1822,7 +1834,8 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+				    adapter->netdev->features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -4176,7 +4189,8 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 						    rx_desc->errors,
 						    length, mapped)) {
 				length--;
-			} else if (netdev->features & NETIF_F_RXALL) {
+			} else if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+							   netdev->features)) {
 				goto process_skb;
 			} else {
 				/* an error means any chain goes out the window
@@ -4227,7 +4241,8 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				if (length <= copybreak) {
 					u8 *vaddr;
 
-					if (likely(!(netdev->features & NETIF_F_RXFCS)))
+					if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+									    netdev->features)))
 						length -= 4;
 					skb = e1000_alloc_rx_skb(adapter,
 								 length);
@@ -4273,7 +4288,8 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				  le16_to_cpu(rx_desc->csum), skb);
 
 		total_rx_bytes += (skb->len - 4); /* don't count FCS */
-		if (likely(!(netdev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						    netdev->features)))
 			pskb_trim(skb, skb->len - 4);
 		total_rx_packets++;
 
@@ -4428,7 +4444,8 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 						    rx_desc->errors,
 						    length, data)) {
 				length--;
-			} else if (netdev->features & NETIF_F_RXALL) {
+			} else if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+							   netdev->features)) {
 				goto process_skb;
 			} else {
 				dev_kfree_skb(skb);
@@ -4440,7 +4457,8 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 		total_rx_bytes += (length - 4); /* don't count FCS */
 		total_rx_packets++;
 
-		if (likely(!(netdev->features & NETIF_F_RXFCS)))
+		if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						    netdev->features)))
 			/* adjust length to remove Ethernet CRC, this must be
 			 * done after the TBI_ACCEPT workaround above
 			 */
@@ -4888,7 +4906,7 @@ static void __e1000_vlan_mode(struct e1000_adapter *adapter,
 	u32 ctrl;
 
 	ctrl = er32(CTRL);
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		/* enable VLAN tag insert/strip */
 		ctrl |= E1000_CTRL_VME;
 	} else {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 5dd183e0cb0f..a299f2789164 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -576,7 +576,8 @@ static void e1000_rx_checksum(struct e1000_adapter *adapter, u32 status_err,
 	skb_checksum_none_assert(skb);
 
 	/* Rx checksum disabled */
-	if (!(adapter->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     adapter->netdev->features))
 		return;
 
 	/* Ignore Checksum bit is set */
@@ -894,7 +895,7 @@ static void e1000_alloc_jumbo_rx_buffers(struct e1000_ring *rx_ring,
 static inline void e1000_rx_hash(struct net_device *netdev, __le32 rss,
 				 struct sk_buff *skb)
 {
-	if (netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		skb_set_hash(skb, le32_to_cpu(rss), PKT_HASH_TYPE_L3);
 }
 
@@ -976,7 +977,8 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 		}
 
 		if (unlikely((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			     !(netdev->features & NETIF_F_RXALL))) {
+			     !netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						      netdev->features))) {
 			/* recycle */
 			buffer_info->skb = skb;
 			goto next_desc;
@@ -988,7 +990,8 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 			 * but keep the FCS bytes out of the total_rx_bytes
 			 * counter
 			 */
-			if (netdev->features & NETIF_F_RXFCS)
+			if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						    netdev->features))
 				total_rx_bytes -= 4;
 			else
 				length -= 4;
@@ -1362,7 +1365,8 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 		}
 
 		if (unlikely((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			     !(netdev->features & NETIF_F_RXALL))) {
+			     !netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						      netdev->features))) {
 			dev_kfree_skb_irq(skb);
 			goto next_desc;
 		}
@@ -1413,7 +1417,8 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 
 				/* remove the CRC */
 				if (!(adapter->flags2 & FLAG2_CRC_STRIPPING)) {
-					if (!(netdev->features & NETIF_F_RXFCS))
+					if (!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+								     netdev->features))
 						l1 -= 4;
 				}
 
@@ -1442,7 +1447,8 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 		 * this whole operation can get a little cpu intensive
 		 */
 		if (!(adapter->flags2 & FLAG2_CRC_STRIPPING)) {
-			if (!(netdev->features & NETIF_F_RXFCS))
+			if (!netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						     netdev->features))
 				pskb_trim(skb, skb->len - 4);
 		}
 
@@ -1557,7 +1563,8 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 		/* errors is only valid for DD + EOP descriptors */
 		if (unlikely((staterr & E1000_RXD_STAT_EOP) &&
 			     ((staterr & E1000_RXDEXT_ERR_FRAME_ERR_MASK) &&
-			      !(netdev->features & NETIF_F_RXALL)))) {
+			      !netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+						       netdev->features)))) {
 			/* recycle both page and skb */
 			buffer_info->skb = skb;
 			/* an error means any chain goes out the window too */
@@ -3165,7 +3172,8 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+				    adapter->netdev->features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -3270,7 +3278,8 @@ static void e1000_configure_rx(struct e1000_adapter *adapter)
 
 	/* Enable Receive Checksum Offload for TCP and UDP */
 	rxcsum = er32(RXCSUM);
-	if (adapter->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    adapter->netdev->features))
 		rxcsum |= E1000_RXCSUM_TUOFL;
 	else
 		rxcsum &= ~E1000_RXCSUM_TUOFL;
@@ -3451,7 +3460,8 @@ static void e1000e_set_rx_mode(struct net_device *netdev)
 
 	ew32(RCTL, rctl);
 
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    netdev->features))
 		e1000e_vlan_strip_enable(adapter);
 	else
 		e1000e_vlan_strip_disable(adapter);
@@ -3765,7 +3775,8 @@ static void e1000_configure(struct e1000_adapter *adapter)
 
 	e1000_configure_tx(adapter);
 
-	if (adapter->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    adapter->netdev->features))
 		e1000e_setup_rss_hash(adapter);
 	e1000_setup_rctl(adapter);
 	e1000_configure_rx(adapter);
@@ -5304,20 +5315,26 @@ static void e1000_watchdog_task(struct work_struct *work)
 				case SPEED_10:
 				case SPEED_100:
 					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
+					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+								 &netdev->features);
+					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+								 &netdev->features);
 					break;
 				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
+					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+								 &netdev->features);
+					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+								 &netdev->features);
 					break;
 				default:
 					/* oops */
 					break;
 				}
 				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
+					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+								 &netdev->features);
+					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+								 &netdev->features);
 				}
 			}
 
@@ -7295,33 +7312,38 @@ static void e1000_fix_features(struct net_device *netdev,
 
 	/* Jumbo frame workaround on 82579 and newer requires CRC be stripped */
 	if ((hw->mac.type >= e1000_pch2lan) && (netdev->mtu > ETH_DATA_LEN))
-		*features &= ~NETIF_F_RXFCS;
+		netdev_feature_clear_bit(NETIF_F_RXFCS_BIT, features);
 
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
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
 
 static int e1000_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6, changed))
 		adapter->flags |= FLAG_TSO_FORCE;
 
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_RXFCS |
-			 NETIF_F_RXALL)))
+	if (!netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_RX |
+				      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_RXCSUM |
+				      NETIF_F_RXHASH | NETIF_F_RXFCS |
+				      NETIF_F_RXALL | NETIF_F_HW_VLAN_CTAG_RX,
+				      changed))
 		return 0;
 
-	if (changed & NETIF_F_RXFCS) {
-		if (features & NETIF_F_RXFCS) {
+	if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, features)) {
 			adapter->flags2 &= ~FLAG2_CRC_STRIPPING;
 		} else {
 			/* We need to take it back to defaults, which might mean
@@ -7334,7 +7356,7 @@ static int e1000_set_features(struct net_device *netdev,
 		}
 	}
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 
 	if (netif_running(netdev))
 		e1000e_reinit_locked(adapter);
@@ -7524,34 +7546,39 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "PHY reset is blocked due to SOL/IDER session.\n");
 
 	/* Set initial default active device features */
-	netdev->features = (NETIF_F_SG |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO6 |
-			    NETIF_F_RXHASH |
-			    NETIF_F_RXCSUM |
-			    NETIF_F_HW_CSUM);
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXHASH |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM,
+				&netdev->features);
 
 	/* Set user-changeable features (subset of all device features) */
-	netdev->hw_features = netdev->features;
-	netdev->hw_features |= NETIF_F_RXFCS;
+	netdev_feature_copy(&netdev->hw_features, netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
 
 	if (adapter->flags & FLAG_HAS_HW_VLAN_FILTER)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->features);
 
-	netdev->vlan_features |= (NETIF_F_SG |
-				  NETIF_F_TSO |
-				  NETIF_F_TSO6 |
-				  NETIF_F_HW_CSUM);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_HW_CSUM,
+				&netdev->vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
 	/* MTU range: 68 - max_hw_frame_size */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..ed2871d62804 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -352,7 +352,8 @@ static inline void fm10k_rx_checksum(struct fm10k_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -388,7 +389,8 @@ static inline void fm10k_rx_hash(struct fm10k_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     ring->netdev->features))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->w.pkt_info) & FM10K_RXD_RSSTYPE_MASK;
@@ -772,7 +774,8 @@ static int fm10k_tso(struct fm10k_ring *tx_ring,
 	return 1;
 
 err_vxlan:
-	tx_ring->netdev->features &= ~NETIF_F_GSO_UDP_TUNNEL;
+	netdev_feature_clear_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				 &tx_ring->netdev->features);
 	if (net_ratelimit())
 		netdev_err(tx_ring->netdev,
 			   "TSO requested for unsupported tunnel, disabling offload\n");
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index a311bcdfbff2..e3747f310c2e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1510,7 +1510,8 @@ static void fm10k_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
 		return;
 
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
@@ -1556,50 +1557,56 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	interface->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	/* configure default features */
-	dev->features |= NETIF_F_IP_CSUM |
-			 NETIF_F_IPV6_CSUM |
-			 NETIF_F_SG |
-			 NETIF_F_TSO |
-			 NETIF_F_TSO6 |
-			 NETIF_F_TSO_ECN |
-			 NETIF_F_RXHASH |
-			 NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_TSO_ECN |
+				NETIF_F_RXHASH |
+				NETIF_F_RXCSUM,
+				&dev->features);
 
 	/* Only the PF can support VXLAN and NVGRE tunnel offloads */
 	if (info->mac == fm10k_mac_pf) {
-		dev->hw_enc_features = NETIF_F_IP_CSUM |
-				       NETIF_F_TSO |
-				       NETIF_F_TSO6 |
-				       NETIF_F_TSO_ECN |
-				       NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_IPV6_CSUM |
-				       NETIF_F_SG;
-
-		dev->features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM |
+					NETIF_F_TSO |
+					NETIF_F_TSO6 |
+					NETIF_F_TSO_ECN |
+					NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_IPV6_CSUM |
+					NETIF_F_SG,
+					&dev->hw_enc_features);
+
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &dev->features);
 
 		dev->udp_tunnel_nic_info = &fm10k_udp_tunnels;
 	}
 
 	/* all features defined to this point should be changeable */
-	hw_features = dev->features;
+	netdev_feature_copy(&hw_features, dev->features);
 
 	/* allow user to enable L2 forwarding acceleration */
-	hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev_feature_set_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, &hw_features);
 
 	/* configure VLAN features */
-	dev->vlan_features |= dev->features;
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+			  dev->features);
 
 	/* we want to leave these both on as we cannot disable VLAN tag
 	 * insertion or stripping on the hardware since it is contained
 	 * in the FTAG and not in the frame itself.
 	 */
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&dev->features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	dev->hw_features |= hw_features;
+	netdev_feature_or(&dev->hw_features, dev->hw_features,
+			  hw_features);
 
 	/* MTU range: 68 - 15342 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index adfa2768f024..48c1206246d0 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -305,9 +305,11 @@ static int fm10k_handle_reset(struct fm10k_intfc *interface)
 		}
 
 		if (hw->mac.vlan_override)
-			netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						 &netdev->features);
 		else
-			netdev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       &netdev->features);
 	}
 
 	err = netif_running(netdev) ? fm10k_open(netdev) : 0;
@@ -2010,8 +2012,9 @@ static int fm10k_sw_init(struct fm10k_intfc *interface,
 
 	/* update netdev with DMA restrictions */
 	if (dma_get_mask(&pdev->dev) > DMA_BIT_MASK(32)) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
 	/* reset and initialize the hardware so it is in a known state */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5246c6abbd7d..5dddd63bde74 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2962,7 +2962,8 @@ static void i40e_restore_vlan(struct i40e_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    vsi->netdev->features))
 		i40e_vlan_stripping_enable(vsi);
 	else
 		i40e_vlan_stripping_disable(vsi);
@@ -12541,7 +12542,7 @@ bool i40e_set_ntuple(struct i40e_pf *pf, netdev_features_t features)
 	/* Check if Flow Director n-tuple support was enabled or disabled.  If
 	 * the state changed, we need to reset.
 	 */
-	if (features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features)) {
 		/* Enable filters and mark for reset */
 		if (!(pf->flags & I40E_FLAG_FD_SB_ENABLED))
 			need_reset = true;
@@ -12610,24 +12611,27 @@ static int i40e_set_features(struct net_device *netdev,
 	struct i40e_pf *pf = vsi->back;
 	bool need_reset;
 
-	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		i40e_pf_config_rss(pf);
-	else if (!(features & NETIF_F_RXHASH) &&
-		 netdev->features & NETIF_F_RXHASH)
+	else if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+		 netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		i40e_clear_rss_lut(vsi);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		i40e_vlan_stripping_enable(vsi);
 	else
 		i40e_vlan_stripping_disable(vsi);
 
-	if (!(features & NETIF_F_HW_TC) && pf->num_cloud_filters) {
+	if (!netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features) &&
+	    pf->num_cloud_filters) {
 		dev_err(&pf->pdev->dev,
 			"Offloaded tc filters active, can't turn hw_tc_offload off");
 		return -EINVAL;
 	}
 
-	if (!(features & NETIF_F_HW_L2FW_DOFFLOAD) && vsi->macvlan_cnt)
+	if (!netdev_feature_test_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, features) &&
+	    vsi->macvlan_cnt)
 		i40e_del_all_macvlans(vsi);
 
 	need_reset = i40e_set_ntuple(pf, features);
@@ -12889,7 +12893,7 @@ static void i40e_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -12921,7 +12925,8 @@ static void i40e_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	return;
 out_err:
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 /**
@@ -13324,53 +13329,71 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
-	hw_enc_features = NETIF_F_SG			|
-			  NETIF_F_IP_CSUM		|
-			  NETIF_F_IPV6_CSUM		|
-			  NETIF_F_HIGHDMA		|
-			  NETIF_F_SOFT_FEATURES		|
-			  NETIF_F_TSO			|
-			  NETIF_F_TSO_ECN		|
-			  NETIF_F_TSO6			|
-			  NETIF_F_GSO_GRE		|
-			  NETIF_F_GSO_GRE_CSUM		|
-			  NETIF_F_GSO_PARTIAL		|
-			  NETIF_F_GSO_IPXIP4		|
-			  NETIF_F_GSO_IPXIP6		|
-			  NETIF_F_GSO_UDP_TUNNEL	|
-			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-			  NETIF_F_GSO_UDP_L4		|
-			  NETIF_F_SCTP_CRC		|
-			  NETIF_F_RXHASH		|
-			  NETIF_F_RXCSUM		|
-			  0;
+	netdev_feature_zero(&hw_enc_features);
+	netdev_feature_set_bits(NETIF_F_SG_BIT			|
+				NETIF_F_IP_CSUM_BIT		|
+				NETIF_F_IPV6_CSUM_BIT		|
+				NETIF_F_HIGHDMA_BIT		|
+				NETIF_F_GSO_BIT			|
+				NETIF_F_GRO_BIT			|
+				NETIF_F_TSO_BIT			|
+				NETIF_F_TSO_ECN_BIT		|
+				NETIF_F_TSO6_BIT		|
+				NETIF_F_GSO_GRE_BIT		|
+				NETIF_F_GSO_GRE_CSUM_BIT	|
+				NETIF_F_GSO_PARTIAL_BIT		|
+				NETIF_F_GSO_IPXIP4_BIT		|
+				NETIF_F_GSO_IPXIP6_BIT		|
+				NETIF_F_GSO_UDP_TUNNEL_BIT	|
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT	|
+				NETIF_F_GSO_UDP_L4_BIT		|
+				NETIF_F_SCTP_CRC_BIT		|
+				NETIF_F_RXHASH_BIT		|
+				NETIF_F_RXCSUM_BIT,
+				&hw_enc_features);
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
-		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				       &netdev->gso_partial_features);
 
 	netdev->udp_tunnel_nic_info = &pf->udp_tunnel_nic;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
+			       &netdev->gso_partial_features);
 
-	netdev->hw_enc_features |= hw_enc_features;
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  hw_enc_features);
 
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
 
 	/* enable macvlan offloads */
-	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev_feature_set_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT,
+			       &netdev->hw_features);
 
-	hw_features = hw_enc_features		|
-		      NETIF_F_HW_VLAN_CTAG_TX	|
-		      NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_copy(&hw_features, hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			       &hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &hw_features);
 
-	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
-		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	if (!(pf->flags & I40E_FLAG_MFP_ENABLED)) {
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &hw_features);
+	}
 
-	netdev->hw_features |= hw_features;
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  hw_features);
 
-	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->hw_enc_features);
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5385c7..0e94bd8bcd59 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1793,7 +1793,8 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     vsi->netdev->features))
 		return;
 
 	/* did the hardware decode the packet and checksum? */
@@ -1895,7 +1896,8 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
 		cpu_to_le64((u64)I40E_RX_DESC_FLTSTAT_RSS_HASH <<
 			    I40E_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     ring->netdev->features))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
@@ -2944,7 +2946,8 @@ static inline int i40e_tx_prepare_vlan_flags(struct sk_buff *skb,
 	u32  tx_flags = 0;
 
 	if (protocol == htons(ETH_P_8021Q) &&
-	    !(tx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				     tx_ring->netdev->features)) {
 		/* When HW VLAN acceleration is turned off by the user the
 		 * stack sets the protocol to 8021q so that the driver
 		 * can take any steps required to support the SW only
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9a086211af4a..9f6b6cabdca1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1890,7 +1890,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 				 err);
 	}
 	dev_info(&pdev->dev, "MAC address: %pM\n", adapter->hw.mac.addr);
-	if (netdev->features & NETIF_F_GRO)
+	if (netdev_feature_test_bit(NETIF_F_GRO_BIT, netdev->features))
 		dev_info(&pdev->dev, "GRO is enabled\n");
 
 	adapter->state = __IAVF_DOWN;
@@ -3354,15 +3354,20 @@ static int iavf_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_feature_xor(&changed, netdev->features, features);
 	/* Don't allow changing VLAN_RX flag when adapter is not capable
 	 * of VLAN offload
 	 */
 	if (!VLAN_ALLOWED(adapter)) {
-		if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    changed))
 			return -EINVAL;
-	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	} else if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					   changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			adapter->aq_required |=
 				IAVF_FLAG_AQ_ENABLE_VLAN_STRIPPING;
 		else
@@ -3395,7 +3400,7 @@ static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -3427,7 +3432,8 @@ static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	return;
 out_err:
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 /**
@@ -3443,9 +3449,10 @@ static void iavf_fix_features(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	if (!(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
-		*features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-			      NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_HW_VLAN_CTAG_RX |
+					  NETIF_F_HW_VLAN_CTAG_FILTER,
+					  features);
 }
 
 static const struct net_device_ops iavf_netdev_ops = {
@@ -3530,84 +3537,103 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	}
 	adapter->num_req_queues = 0;
 
-	hw_enc_features = NETIF_F_SG			|
-			  NETIF_F_IP_CSUM		|
-			  NETIF_F_IPV6_CSUM		|
-			  NETIF_F_HIGHDMA		|
-			  NETIF_F_SOFT_FEATURES	|
-			  NETIF_F_TSO			|
-			  NETIF_F_TSO_ECN		|
-			  NETIF_F_TSO6			|
-			  NETIF_F_SCTP_CRC		|
-			  NETIF_F_RXHASH		|
-			  NETIF_F_RXCSUM		|
-			  0;
+	netdev_feature_zero(&hw_enc_features);
+	netdev_feature_set_bits(NETIF_F_SG		|
+				NETIF_F_IP_CSUM		|
+				NETIF_F_IPV6_CSUM	|
+				NETIF_F_HIGHDMA		|
+				NETIF_F_SOFT_FEATURES	|
+				NETIF_F_TSO		|
+				NETIF_F_TSO_ECN		|
+				NETIF_F_TSO6		|
+				NETIF_F_SCTP_CRC	|
+				NETIF_F_RXHASH		|
+				NETIF_F_RXCSUM,
+				&hw_enc_features);
 
 	/* advertise to stack only if offloads for encapsulated packets is
 	 * supported
 	 */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ENCAP) {
-		hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL	|
-				   NETIF_F_GSO_GRE		|
-				   NETIF_F_GSO_GRE_CSUM		|
-				   NETIF_F_GSO_IPXIP4		|
-				   NETIF_F_GSO_IPXIP6		|
-				   NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-				   NETIF_F_GSO_PARTIAL		|
-				   0;
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL		|
+					NETIF_F_GSO_GRE			|
+					NETIF_F_GSO_GRE_CSUM		|
+					NETIF_F_GSO_IPXIP4		|
+					NETIF_F_GSO_IPXIP6		|
+					NETIF_F_GSO_UDP_TUNNEL_CSUM	|
+					NETIF_F_GSO_PARTIAL,
+					&hw_enc_features);
 
 		if (!(vfres->vf_cap_flags &
 		      VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM))
-			netdev->gso_partial_features |=
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					       &netdev->gso_partial_features);
 
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
-		netdev->hw_enc_features |= hw_enc_features;
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
+				       &netdev->gso_partial_features);
+		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_or(&netdev->hw_enc_features,
+				  netdev->hw_enc_features, hw_enc_features);
 	}
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev_feature_or(&netdev->vlan_features,
+			  netdev->vlan_features, hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
 
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
 	 */
-	hw_features = hw_enc_features;
+	netdev_feature_copy(&hw_features, hw_enc_features);
 
 	/* Enable VLAN features if supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
-		hw_features |= (NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX);
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX, &hw_features);
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
-		hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &hw_features);
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
-		hw_features |= NETIF_F_GSO_UDP_L4;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &hw_features);
 
-	netdev->hw_features |= hw_features;
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  hw_features);
 
-	netdev->features |= hw_features;
+	netdev_feature_or(&netdev->features, netdev->features, hw_features);
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* Do not turn on offloads when they are requested to be turned off.
 	 * TSO needs minimum 576 bytes to work correctly.
 	 */
-	if (netdev->wanted_features) {
-		if (!(netdev->wanted_features & NETIF_F_TSO) ||
+	if (!netdev_feature_empty(netdev->wanted_features)) {
+		if (!netdev_feature_test_bit(NETIF_F_TSO_BIT,
+					     netdev->wanted_features) ||
 		    netdev->mtu < 576)
-			netdev->features &= ~NETIF_F_TSO;
-		if (!(netdev->wanted_features & NETIF_F_TSO6) ||
+			netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+						 &netdev->features);
+		if (!netdev_feature_test_bit(NETIF_F_TSO6_BIT,
+					     netdev->wanted_features) ||
 		    netdev->mtu < 576)
-			netdev->features &= ~NETIF_F_TSO6;
-		if (!(netdev->wanted_features & NETIF_F_TSO_ECN))
-			netdev->features &= ~NETIF_F_TSO_ECN;
-		if (!(netdev->wanted_features & NETIF_F_GRO))
-			netdev->features &= ~NETIF_F_GRO;
-		if (!(netdev->wanted_features & NETIF_F_GSO))
-			netdev->features &= ~NETIF_F_GSO;
+			netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+						 &netdev->features);
+		if (!netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT,
+					     netdev->wanted_features))
+			netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT,
+						 &netdev->features);
+		if (!netdev_feature_test_bit(NETIF_F_GRO_BIT,
+					     netdev->wanted_features))
+			netdev_feature_clear_bit(NETIF_F_GRO_BIT,
+						 &netdev->features);
+		if (!netdev_feature_test_bit(NETIF_F_GSO_BIT,
+					     netdev->wanted_features))
+			netdev_feature_clear_bit(NETIF_F_GSO_BIT,
+						 &netdev->features);
 	}
 
 	adapter->vsi.id = adapter->vsi_res->vsi_id;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 3525eab8e9f9..2293ad268f9a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -862,7 +862,8 @@ static void iavf_receive_skb(struct iavf_ring *rx_ring,
 {
 	struct iavf_q_vector *q_vector = rx_ring->q_vector;
 
-	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    rx_ring->netdev->features) &&
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 
@@ -963,7 +964,8 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     vsi->netdev->features))
 		return;
 
 	/* did the hardware decode the packet and checksum? */
@@ -1058,7 +1060,8 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    ring->netdev->features))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
@@ -1789,7 +1792,8 @@ static inline int iavf_tx_prepare_vlan_flags(struct sk_buff *skb,
 	u32  tx_flags = 0;
 
 	if (protocol == htons(ETH_P_8021Q) &&
-	    !(tx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				     tx_ring->netdev->features)) {
 		/* When HW VLAN acceleration is turned off by the user the
 		 * stack sets the protocol to 8021q so that the driver
 		 * can take any steps required to support the SW only
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1ad630b8d103..682b14bebdee 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3065,53 +3065,74 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	if (ice_is_safe_mode(pf)) {
 		/* safe mode */
-		netdev->features = NETIF_F_SG | NETIF_F_HIGHDMA;
-		netdev->hw_features = netdev->features;
+		netdev_feature_zero(&netdev->features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
+					&netdev->features);
+		netdev_feature_copy(&netdev->hw_features, netdev->features);
 		return;
 	}
 
-	dflt_features = NETIF_F_SG	|
-			NETIF_F_HIGHDMA	|
-			NETIF_F_NTUPLE	|
-			NETIF_F_RXHASH;
-
-	csumo_features = NETIF_F_RXCSUM	  |
-			 NETIF_F_IP_CSUM  |
-			 NETIF_F_SCTP_CRC |
-			 NETIF_F_IPV6_CSUM;
-
-	vlano_features = NETIF_F_HW_VLAN_CTAG_FILTER |
-			 NETIF_F_HW_VLAN_CTAG_TX     |
-			 NETIF_F_HW_VLAN_CTAG_RX;
-
-	tso_features = NETIF_F_TSO			|
-		       NETIF_F_TSO_ECN			|
-		       NETIF_F_TSO6			|
-		       NETIF_F_GSO_GRE			|
-		       NETIF_F_GSO_UDP_TUNNEL		|
-		       NETIF_F_GSO_GRE_CSUM		|
-		       NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-		       NETIF_F_GSO_PARTIAL		|
-		       NETIF_F_GSO_IPXIP4		|
-		       NETIF_F_GSO_IPXIP6		|
-		       NETIF_F_GSO_UDP_L4;
-
-	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE_CSUM;
+	netdev_feature_zero(&dflt_features);
+	netdev_feature_set_bits(NETIF_F_SG		|
+				NETIF_F_HIGHDMA		|
+				NETIF_F_NTUPLE		|
+				NETIF_F_RXHASH,
+				&dflt_features);
+
+	netdev_feature_zero(&csumo_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM		|
+				NETIF_F_IP_CSUM		|
+				NETIF_F_SCTP_CRC	|
+				NETIF_F_IPV6_CSUM,
+				&csumo_features);
+
+	netdev_feature_zero(&vlano_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER	|
+				NETIF_F_HW_VLAN_CTAG_TX		|
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&vlano_features);
+
+	netdev_feature_zero(&tso_features);
+	netdev_feature_set_bits(NETIF_F_TSO			|
+				NETIF_F_TSO_ECN			|
+				NETIF_F_TSO6			|
+				NETIF_F_GSO_GRE			|
+				NETIF_F_GSO_UDP_TUNNEL		|
+				NETIF_F_GSO_GRE_CSUM		|
+				NETIF_F_GSO_UDP_TUNNEL_CSUM	|
+				NETIF_F_GSO_PARTIAL		|
+				NETIF_F_GSO_IPXIP4		|
+				NETIF_F_GSO_IPXIP6		|
+				NETIF_F_GSO_UDP_L4,
+				&tso_features);
+
+	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_GRE_CSUM,
+				&netdev->gso_partial_features);
 	/* set features that user can change */
-	netdev->hw_features = dflt_features | csumo_features |
-			      vlano_features | tso_features;
+	netdev_feature_or(&netdev->hw_features, dflt_features,
+			  csumo_features);
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  vlano_features);
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  tso_features);
 
 	/* add support for HW_CSUM on packets with MPLS header */
-	netdev->mpls_features =  NETIF_F_HW_CSUM;
+	netdev_feature_zero(&netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
 
 	/* enable features */
-	netdev->features |= netdev->hw_features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 	/* encap and VLAN devices inherit default, csumo and tso features */
-	netdev->hw_enc_features |= dflt_features | csumo_features |
-				   tso_features;
-	netdev->vlan_features |= dflt_features | csumo_features |
-				 tso_features;
+	netdev_feature_or(&netdev->hw_enc_features, dflt_features,
+			  csumo_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  tso_features);
+	netdev_feature_or(&netdev->vlan_features, dflt_features,
+			  csumo_features);
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  tso_features);
 }
 
 /**
@@ -5355,39 +5376,51 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
-	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		ice_vsi_manage_rss_lut(vsi, true);
-	else if (!(features & NETIF_F_RXHASH) &&
-		 netdev->features & NETIF_F_RXHASH)
+	else if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+		 netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		ice_vsi_manage_rss_lut(vsi, false);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
-	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     netdev->features))
 		ret = ice_vsi_manage_vlan_stripping(vsi, true);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_RX) &&
-		 (netdev->features & NETIF_F_HW_VLAN_CTAG_RX))
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					  features) &&
+		 netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 netdev->features))
 		ret = ice_vsi_manage_vlan_stripping(vsi, false);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_TX) &&
-	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				     netdev->features))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_TX) &&
-		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					  features) &&
+		 netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 netdev->features))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     netdev->features))
 		ret = ice_cfg_vlan_pruning(vsi, true, false);
-	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	else if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					  features) &&
+		 netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 netdev->features))
 		ret = ice_cfg_vlan_pruning(vsi, false, false);
 
-	if ((features & NETIF_F_NTUPLE) &&
-	    !(netdev->features & NETIF_F_NTUPLE)) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->features)) {
 		ice_vsi_manage_fdir(vsi, true);
 		ice_init_arfs(vsi);
-	} else if (!(features & NETIF_F_NTUPLE) &&
-		 (netdev->features & NETIF_F_NTUPLE)) {
+	} else if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features) &&
+		   netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+					   netdev->features)) {
 		ice_vsi_manage_fdir(vsi, false);
 		ice_clear_arfs(vsi);
 	}
@@ -5403,9 +5436,11 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
 {
 	int ret = 0;
 
-	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    vsi->netdev->features))
 		ret = ice_vsi_manage_vlan_stripping(vsi, true);
-	if (vsi->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    vsi->netdev->features))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
 
 	return ret;
@@ -7193,7 +7228,7 @@ static void ice_features_check(struct sk_buff *skb,
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 
 	len = skb_network_header(skb) - skb->data;
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
@@ -7216,7 +7251,8 @@ static void ice_features_check(struct sk_buff *skb,
 
 	return;
 out_rm_features:
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 171397dcf00a..12211d2d0ed3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -72,7 +72,8 @@ ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
 
-	if (!(rx_ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     rx_ring->netdev->features))
 		return;
 
 	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
@@ -110,7 +111,8 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	skb_checksum_none_assert(skb);
 
 	/* check if Rx checksum is enabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* check if HW has decoded the packet and checksum */
@@ -205,7 +207,8 @@ ice_process_skb_fields(struct ice_ring *rx_ring,
 void
 ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 {
-	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    rx_ring->netdev->features)  &&
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 	napi_gro_receive(&rx_ring->q_vector->napi, skb);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index fb1029352c3e..89b4f28ad71c 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2901,7 +2901,7 @@ static int igb_add_ethtool_nfc_entry(struct igb_adapter *adapter,
 	struct igb_nfc_filter *input, *rule;
 	int err = 0;
 
-	if (!(netdev->hw_features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features))
 		return -EOPNOTSUPP;
 
 	/* Don't allow programming if the action is a queue greater than
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2e4a53c76c60..1f764d4fbd14 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2439,25 +2439,28 @@ static void igb_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
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
 
 static int igb_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct igb_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igb_vlan_mode(netdev, features);
 
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!netdev_feature_test_bits(NETIF_F_RXALL | NETIF_F_NTUPLE, changed))
 		return 0;
 
-	if (!(features & NETIF_F_NTUPLE)) {
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features)) {
 		struct hlist_node *node2;
 		struct igb_nfc_filter *rule;
 
@@ -2472,7 +2475,7 @@ static int igb_set_features(struct net_device *netdev,
 		adapter->nfc_filter_count = 0;
 	}
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 
 	if (netif_running(netdev))
 		igb_reinit_locked(adapter);
@@ -2511,30 +2514,33 @@ static void igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_GSO_UDP_L4 |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					NETIF_F_SCTP_CRC |
+					NETIF_F_GSO_UDP_L4 |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_TSO |
+					NETIF_F_TSO6,
+					features);
 		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_GSO_UDP_L4 |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					NETIF_F_SCTP_CRC |
+					NETIF_F_GSO_UDP_L4 |
+					NETIF_F_TSO |
+					NETIF_F_TSO6,
+					features);
 		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
-		*features &= ~NETIF_F_TSO;
+	if (skb->encapsulation &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
 static void igb_offload_apply(struct igb_adapter *adapter, s32 queue)
@@ -3266,18 +3272,20 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * set by igb_sw_init so we should use an or instead of an
 	 * assignment.
 	 */
-	netdev->features |= NETIF_F_SG |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO6 |
-			    NETIF_F_RXHASH |
-			    NETIF_F_RXCSUM |
-			    NETIF_F_HW_CSUM;
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXHASH |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM,
+				&netdev->features);
 
 	if (hw->mac.type >= e1000_82576)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev_feature_set_bits(NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4,
+					&netdev->features);
 
 	if (hw->mac.type >= e1000_i350)
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
 
 #define IGB_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				  NETIF_F_GSO_GRE_CSUM | \
@@ -3286,29 +3294,41 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  NETIF_F_GSO_UDP_TUNNEL | \
 				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev->gso_partial_features = IGB_GSO_PARTIAL_FEATURES;
-	netdev->features |= NETIF_F_GSO_PARTIAL | IGB_GSO_PARTIAL_FEATURES;
+	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_set_bits(IGB_GSO_PARTIAL_FEATURES,
+				&netdev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
+				IGB_GSO_PARTIAL_FEATURES,
+				&netdev->features);
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL;
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_RXALL,
+				&netdev->hw_features);
 
 	if (hw->mac.type >= e1000_i350)
-		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
+				       &netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->features);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
@@ -4539,7 +4559,8 @@ void igb_setup_rctl(struct igb_adapter *adapter)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+				    adapter->netdev->features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode
 		 */
@@ -5045,7 +5066,8 @@ static int igb_vlan_promisc_enable(struct igb_adapter *adapter)
 	case e1000_i211:
 	case e1000_i350:
 		/* VLAN filtering needed for VLAN prio filter */
-		if (adapter->netdev->features & NETIF_F_NTUPLE)
+		if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+					    adapter->netdev->features))
 			break;
 		fallthrough;
 	case e1000_82576:
@@ -5217,7 +5239,7 @@ static void igb_set_rx_mode(struct net_device *netdev)
 
 	/* disable VLAN filtering for modes that require it */
 	if ((netdev->flags & IFF_PROMISC) ||
-	    (netdev->features & NETIF_F_RXALL)) {
+	    netdev_feature_test_bit(NETIF_F_RXALL_BIT, netdev->features)) {
 		/* if we fail to set all rules then just clear VFE */
 		if (igb_vlan_promisc_enable(adapter))
 			rctl &= ~E1000_RCTL_VFE;
@@ -8467,7 +8489,8 @@ static inline void igb_rx_checksum(struct igb_ring *ring,
 		return;
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -8500,7 +8523,8 @@ static inline void igb_rx_hash(struct igb_ring *ring,
 			       union e1000_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
 {
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    ring->netdev->features))
 		skb_set_hash(skb,
 			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
 			     PKT_HASH_TYPE_L3);
@@ -8558,7 +8582,8 @@ static bool igb_cleanup_headers(struct igb_ring *rx_ring,
 	if (unlikely((igb_test_staterr(rx_desc,
 				       E1000_RXDEXT_ERR_FRAME_ERR_MASK)))) {
 		struct net_device *netdev = rx_ring->netdev;
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					     netdev->features)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -8595,7 +8620,8 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 	    !igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))
 		igb_ptp_rx_rgtstamp(rx_ring->q_vector, skb);
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->features) &&
 	    igb_test_staterr(rx_desc, E1000_RXD_STAT_VP)) {
 		u16 vid;
 
@@ -9018,7 +9044,8 @@ static void igb_vlan_mode(struct net_device *netdev, netdev_features_t features)
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, rctl;
-	bool enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	bool enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					      features);
 
 	if (enable) {
 		/* enable VLAN tag insert/strip */
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 92a46ac4ee1f..2cad7a2c1e59 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2608,7 +2608,7 @@ static int igbvf_set_features(struct net_device *netdev,
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		adapter->flags &= ~IGBVF_FLAG_RX_CSUM_DISABLED;
 	else
 		adapter->flags |= IGBVF_FLAG_RX_CSUM_DISABLED;
@@ -2627,28 +2627,31 @@ static void igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
-		*features &= ~NETIF_F_TSO;
+	if (skb->encapsulation &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
 static const struct net_device_ops igbvf_netdev_ops = {
@@ -2767,12 +2770,14 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->bd_number = cards_found++;
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_SCTP_CRC;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM |
+				NETIF_F_SCTP_CRC,
+				&netdev->hw_features);
 
 #define IGBVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				    NETIF_F_GSO_GRE_CSUM | \
@@ -2781,23 +2786,31 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				    NETIF_F_GSO_UDP_TUNNEL | \
 				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev->gso_partial_features = IGBVF_GSO_PARTIAL_FEATURES;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
-			       IGBVF_GSO_PARTIAL_FEATURES;
+	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_set_bits(IGBVF_GSO_PARTIAL_FEATURES,
+				&netdev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
+				IGBVF_GSO_PARTIAL_FEATURES,
+				&netdev->hw_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->features);
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index e0a76ac1bbbc..504388b4e219 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1299,7 +1299,8 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 	struct igc_nfc_rule *rule, *old_rule;
 	int err;
 
-	if (!(netdev->hw_features & NETIF_F_NTUPLE)) {
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+				     netdev->hw_features)) {
 		netdev_dbg(netdev, "N-tuple filters disabled\n");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 13b89a742ebc..f8b4d5cfa07b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -821,7 +821,8 @@ static void igc_setup_rctl(struct igc_adapter *adapter)
 	wr32(IGC_RXDCTL(0), 0);
 
 	/* This is useful for sniffing bad packets. */
-	if (adapter->netdev->features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+				    adapter->netdev->features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in set_rx_mode
 		 */
@@ -1526,7 +1527,8 @@ static void igc_rx_checksum(struct igc_ring *ring,
 		return;
 
 	/* Rx checksum disabled via ethtool */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* TCP/UDP checksum error bit is set */
@@ -1559,7 +1561,8 @@ static inline void igc_rx_hash(struct igc_ring *ring,
 			       union igc_adv_rx_desc *rx_desc,
 			       struct sk_buff *skb)
 {
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    ring->netdev->features))
 		skb_set_hash(skb,
 			     le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
 			     PKT_HASH_TYPE_L3);
@@ -1572,7 +1575,8 @@ static void igc_rx_vlan(struct igc_ring *rx_ring,
 	struct net_device *dev = rx_ring->netdev;
 	u16 vid;
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->features) &&
 	    igc_test_staterr(rx_desc, IGC_RXD_STAT_VP)) {
 		if (igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_LB) &&
 		    test_bit(IGC_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
@@ -1611,7 +1615,8 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 
 static void igc_vlan_mode(struct net_device *netdev, netdev_features_t features)
 {
-	bool enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+	bool enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					      features);
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl;
@@ -1899,7 +1904,8 @@ static bool igc_cleanup_headers(struct igc_ring *rx_ring,
 	if (unlikely(igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_RXE))) {
 		struct net_device *netdev = rx_ring->netdev;
 
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					     netdev->features)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -4921,29 +4927,32 @@ static void igc_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
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
 
 static int igc_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	netdev_feature_xor(&changed, netdev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igc_vlan_mode(netdev, features);
 
 	/* Add VLAN support */
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!netdev_feature_test_bits(NETIF_F_RXALL | NETIF_F_NTUPLE, changed))
 		return 0;
 
-	if (!(features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features))
 		igc_flush_nfc_rules(adapter);
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 
 	if (netif_running(netdev))
 		igc_reinit_locked(adapter);
@@ -4961,28 +4970,31 @@ static void igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
-		*features &= ~NETIF_F_TSO;
+	if (skb->encapsulation &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_clear_bits(NETIF_F_TSO_BIT, features);
 }
 
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
@@ -6316,14 +6328,14 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* Add supported features to the features list*/
-	netdev->features |= NETIF_F_SG;
-	netdev->features |= NETIF_F_TSO;
-	netdev->features |= NETIF_F_TSO6;
-	netdev->features |= NETIF_F_TSO_ECN;
-	netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_HW_CSUM;
-	netdev->features |= NETIF_F_SCTP_CRC;
-	netdev->features |= NETIF_F_HW_TC;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_SCTP_CRC_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
 
 #define IGC_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				  NETIF_F_GSO_GRE_CSUM | \
@@ -6332,8 +6344,11 @@ static int igc_probe(struct pci_dev *pdev,
 				  NETIF_F_GSO_UDP_TUNNEL | \
 				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev->gso_partial_features = IGC_GSO_PARTIAL_FEATURES;
-	netdev->features |= NETIF_F_GSO_PARTIAL | IGC_GSO_PARTIAL_FEATURES;
+	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_set_bits(IGC_GSO_PARTIAL_FEATURES,
+				&netdev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL | IGC_GSO_PARTIAL_FEATURES,
+				&netdev->features);
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6341,17 +6356,23 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= NETIF_F_NTUPLE;
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->hw_features |= netdev->features;
+	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			       &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_features);
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->features);
 
 	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
-
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
-	netdev->hw_enc_features |= netdev->vlan_features;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 34c1bfc75b7b..c56ac31de3e1 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -300,20 +300,26 @@ static void ixgb_fix_features(struct net_device *netdev,
 	 * Tx VLAN insertion does not work per HW design when Rx stripping is
 	 * disabled.
 	 */
-	if (!(*features & NETIF_F_HW_VLAN_CTAG_RX))
-		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 features);
 }
 
 static int
 ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (!(changed & (NETIF_F_RXCSUM|NETIF_F_HW_VLAN_CTAG_RX)))
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (!netdev_feature_test_bits(NETIF_F_RXCSUM |
+				      NETIF_F_HW_VLAN_CTAG_RX,
+				      changed))
 		return 0;
 
-	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
+	adapter->rx_csum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						   features);
 
 	if (netif_running(netdev)) {
 		ixgb_down(adapter, true);
@@ -432,18 +438,22 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev->hw_features = NETIF_F_SG |
-			   NETIF_F_TSO |
-			   NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->features = netdev->hw_features |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_features |= NETIF_F_RXCSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_HW_CSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&netdev->hw_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
 
 	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
 	/* MTU range: 68 - 16114 */
@@ -1098,7 +1108,8 @@ ixgb_set_multi(struct net_device *netdev)
 	}
 
 alloc_failed:
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    netdev->features))
 		ixgb_vlan_strip_enable(adapter);
 	else
 		ixgb_vlan_strip_disable(adapter);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index 72e6ebffea33..5516574056dd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -319,7 +319,8 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
 		int max_frame = adapter->netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
 
 #ifdef IXGBE_FCOE
-		if (adapter->netdev->features & NETIF_F_FCOE_MTU)
+		if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+					    adapter->netdev->features))
 			max_frame = max(max_frame, IXGBE_FCOE_JUMBO_FRAME_SIZE);
 #endif
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index fc26e4ddeb0d..1a36535fbb12 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2393,7 +2393,7 @@ static bool ixgbe_update_rsc(struct ixgbe_adapter *adapter)
 
 	/* nothing to do if LRO or RSC are not enabled */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE) ||
-	    !(netdev->features & NETIF_F_LRO))
+	    !netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 		return false;
 
 	/* check the feature flag value and enable RSC if necessary */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 0fcd82036d4e..57009d1c1490 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -644,7 +644,8 @@ void ixgbe_configure_fcoe(struct ixgbe_adapter *adapter)
 	u32 etqf;
 
 	/* Minimal functionality for FCoE requires at least CRC offloads */
-	if (!(adapter->netdev->features & NETIF_F_FCOE_CRC))
+	if (!netdev_feature_test_bit(NETIF_F_FCOE_CRC_BIT,
+				     adapter->netdev->features))
 		return;
 
 	/* Enable L2 EtherType filter for FCoE, needed for FCoE CRC and DDP */
@@ -858,7 +859,7 @@ int ixgbe_fcoe_enable(struct net_device *netdev)
 
 	/* enable FCoE and notify stack */
 	adapter->flags |= IXGBE_FLAG_FCOE_ENABLED;
-	netdev->features |= NETIF_F_FCOE_MTU;
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
 	netdev_features_change(netdev);
 
 	/* release existing queues and reallocate them */
@@ -898,7 +899,7 @@ int ixgbe_fcoe_disable(struct net_device *netdev)
 
 	/* disable FCoE and notify stack */
 	adapter->flags &= ~IXGBE_FLAG_FCOE_ENABLED;
-	netdev->features &= ~NETIF_F_FCOE_MTU;
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 0218f6c9b925..38fe63231675 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -978,7 +978,8 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 			set_bit(__IXGBE_RX_CSUM_UDP_ZERO_ERR, &ring->state);
 
 #ifdef IXGBE_FCOE
-		if (adapter->netdev->features & NETIF_F_FCOE_MTU) {
+		if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+					    adapter->netdev->features)) {
 			struct ixgbe_ring_feature *f;
 			f = &adapter->ring_feature[RING_F_FCOE];
 			if ((rxr_idx >= f->offset) &&
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c43c99a44914..742947fad23c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1423,7 +1423,8 @@ static inline void ixgbe_rx_hash(struct ixgbe_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     ring->netdev->features))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
@@ -1473,7 +1474,8 @@ static inline void ixgbe_rx_checksum(struct ixgbe_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum disabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* check for VXLAN and Geneve packets */
@@ -1692,7 +1694,8 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 	if (unlikely(flags & IXGBE_FLAG_RX_HWTSTAMP_ENABLED))
 		ixgbe_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
 
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->features) &&
 	    ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_VP)) {
 		u16 vid = le16_to_cpu(rx_desc->wb.upper.vlan);
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
@@ -1890,7 +1893,8 @@ bool ixgbe_cleanup_headers(struct ixgbe_ring *rx_ring,
 	if (!netdev ||
 	    (unlikely(ixgbe_test_staterr(rx_desc,
 					 IXGBE_RXDADV_ERR_FRAME_ERR_MASK) &&
-	     !(netdev->features & NETIF_F_RXALL)))) {
+		      !netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					       netdev->features)))) {
 		dev_kfree_skb_any(skb);
 		return true;
 	}
@@ -4897,9 +4901,11 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 fctrl, vmolr = IXGBE_VMOLR_BAM | IXGBE_VMOLR_AUPE;
-	netdev_features_t features = netdev->features;
+	netdev_features_t features;
 	int count;
 
+	netdev_feature_copy(&features, netdev->features);
+
 	/* Check for Promiscuous and All Multicast modes */
 	fctrl = IXGBE_READ_REG(hw, IXGBE_FCTRL);
 
@@ -4915,7 +4921,8 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		hw->addr_ctrl.user_set_promisc = true;
 		fctrl |= (IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 		vmolr |= IXGBE_VMOLR_MPE;
-		features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &features);
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
@@ -4954,7 +4961,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	}
 
 	/* This is useful for sniffing bad packets. */
-	if (features & NETIF_F_RXALL) {
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, features)) {
 		/* UPE and MPE will be handled by normal PROMISC logic
 		 * in e1000e_set_rx_mode */
 		fctrl |= (IXGBE_FCTRL_SBP | /* Receive bad packets */
@@ -4967,12 +4974,12 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 
 	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, fctrl);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		ixgbe_vlan_strip_enable(adapter);
 	else
 		ixgbe_vlan_strip_disable(adapter);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		ixgbe_vlan_promisc_disable(adapter);
 	else
 		ixgbe_vlan_promisc_enable(adapter);
@@ -5054,7 +5061,8 @@ static void ixgbe_configure_dcb(struct ixgbe_adapter *adapter)
 		netif_set_gso_max_size(adapter->netdev, 32768);
 
 #ifdef IXGBE_FCOE
-	if (adapter->netdev->features & NETIF_F_FCOE_MTU)
+	if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+				    adapter->netdev->features))
 		max_frame = max(max_frame, IXGBE_FCOE_JUMBO_FRAME_SIZE);
 #endif
 
@@ -5111,7 +5119,7 @@ static int ixgbe_hpbthresh(struct ixgbe_adapter *adapter, int pb)
 
 #ifdef IXGBE_FCOE
 	/* FCoE traffic class uses FCOE jumbo frames */
-	if ((dev->features & NETIF_F_FCOE_MTU) &&
+	if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT, dev->features) &&
 	    (tc < IXGBE_FCOE_JUMBO_FRAME_SIZE) &&
 	    (pb == ixgbe_fcoe_get_tc(adapter)))
 		tc = IXGBE_FCOE_JUMBO_FRAME_SIZE;
@@ -5172,7 +5180,7 @@ static int ixgbe_lpbthresh(struct ixgbe_adapter *adapter, int pb)
 
 #ifdef IXGBE_FCOE
 	/* FCoE traffic class uses FCOE jumbo frames */
-	if ((dev->features & NETIF_F_FCOE_MTU) &&
+	if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT, dev->features) &&
 	    (tc < IXGBE_FCOE_JUMBO_FRAME_SIZE) &&
 	    (pb == netdev_get_prio_tc_map(dev, adapter->fcoe.up)))
 		tc = IXGBE_FCOE_JUMBO_FRAME_SIZE;
@@ -8698,7 +8706,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #ifdef IXGBE_FCOE
 	/* setup tx offload for FCoE */
 	if ((protocol == htons(ETH_P_FCOE)) &&
-	    (tx_ring->netdev->features & (NETIF_F_FSO | NETIF_F_FCOE_CRC))) {
+	    netdev_feature_test_bits(NETIF_F_FSO | NETIF_F_FCOE_CRC,
+				     tx_ring->netdev->features)) {
 		tso = ixgbe_fso(tx_ring, first, &hdr_len);
 		if (tso < 0)
 			goto out_drop;
@@ -9688,16 +9697,17 @@ static void ixgbe_fix_features(struct net_device *netdev,
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_LRO;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
 	/* Turn off LRO if not RSC capable */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE))
-		*features &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
-	if (adapter->xdp_prog && (*features & NETIF_F_LRO)) {
+	if (adapter->xdp_prog &&
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
 		e_dev_err("LRO is not supported with XDP\n");
-		*features &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 	}
 }
 
@@ -9721,11 +9731,13 @@ static int ixgbe_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 	bool need_reset = false;
 
+	netdev_feature_xor(&changed, netdev->features, features);
+
 	/* Make sure RSC matches LRO, reset if change */
-	if (!(features & NETIF_F_LRO)) {
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
 			need_reset = true;
 		adapter->flags2 &= ~IXGBE_FLAG2_RSC_ENABLED;
@@ -9735,7 +9747,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 		    adapter->rx_itr_setting > IXGBE_MIN_RSC_ITR) {
 			adapter->flags2 |= IXGBE_FLAG2_RSC_ENABLED;
 			need_reset = true;
-		} else if ((changed ^ features) & NETIF_F_LRO) {
+		} else if (!netdev_feature_test_bit(NETIF_F_LRO_BIT,
+						    changed)) {
 			e_info(probe, "rx-usecs set too low, "
 			       "disabling RSC\n");
 		}
@@ -9745,7 +9758,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 	 * Check if Flow Director n-tuple support or hw_tc support was
 	 * enabled or disabled.  If the state changed, we need to reset.
 	 */
-	if ((features & NETIF_F_NTUPLE) || (features & NETIF_F_HW_TC)) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features) ||
+	    netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features)) {
 		/* turn off ATR, enable perfect filters and reset */
 		if (!(adapter->flags & IXGBE_FLAG_FDIR_PERFECT_CAPABLE))
 			need_reset = true;
@@ -9772,17 +9786,19 @@ static int ixgbe_set_features(struct net_device *netdev,
 			adapter->flags |= IXGBE_FLAG_FDIR_HASH_CAPABLE;
 	}
 
-	if (changed & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed))
 		need_reset = true;
 
-	netdev->features = features;
+	netdev_feature_copy(&netdev->features, features);
 
-	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
+	if (netdev_feature_test_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, changed) &&
+	    adapter->num_rx_pools > 1)
 		ixgbe_reset_l2fw_offload(adapter);
 	else if (need_reset)
 		ixgbe_do_reset(netdev);
-	else if (changed & (NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER))
+	else if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_RX |
+					  NETIF_F_HW_VLAN_CTAG_FILTER,
+					  changed))
 		ixgbe_set_rx_mode(netdev);
 
 	return 1;
@@ -10073,22 +10089,24 @@ static void ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_GSO_UDP_L4 |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_GSO_UDP_L4 |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_GSO_UDP_L4 |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_GSO_UDP_L4 |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
@@ -10097,11 +10115,12 @@ static void ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * IPsec offoad sets skb->encapsulation but still can handle
 	 * the TSO, so it's the exception.
 	 */
-	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID)) {
+	if (skb->encapsulation &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features)) {
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
-			*features &= ~NETIF_F_TSO;
+			netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 	}
 }
 
@@ -10787,12 +10806,14 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 skip_sriov:
 
 #endif
-	netdev->features = NETIF_F_SG |
-			   NETIF_F_TSO |
-			   NETIF_F_TSO6 |
-			   NETIF_F_RXHASH |
-			   NETIF_F_RXCSUM |
-			   NETIF_F_HW_CSUM;
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXHASH |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM,
+				&netdev->features);
 
 #define IXGBE_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				    NETIF_F_GSO_GRE_CSUM | \
@@ -10801,12 +10822,17 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				    NETIF_F_GSO_UDP_TUNNEL | \
 				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev->gso_partial_features = IXGBE_GSO_PARTIAL_FEATURES;
-	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    IXGBE_GSO_PARTIAL_FEATURES;
+	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_set_bits(IXGBE_GSO_PARTIAL_FEATURES,
+				&netdev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
+				IXGBE_GSO_PARTIAL_FEATURES,
+				&netdev->features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev_feature_set_bits(NETIF_F_SCTP_CRC |
+					NETIF_F_GSO_UDP_L4,
+					&netdev->features);
 
 #ifdef CONFIG_IXGBE_IPSEC
 #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
@@ -10814,35 +10840,45 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 NETIF_F_GSO_ESP)
 
 	if (adapter->ipsec)
-		netdev->features |= IXGBE_ESP_FEATURES;
+		netdev_feature_set_bits(IXGBE_ESP_FEATURES, &netdev->features);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL |
-			       NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_RXALL |
+				NETIF_F_HW_L2FW_DOFFLOAD,
+				&netdev->hw_features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->hw_features |= NETIF_F_NTUPLE |
-				       NETIF_F_HW_TC;
+		netdev_feature_set_bits(NETIF_F_NTUPLE |
+					NETIF_F_HW_TC,
+					&netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
-
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->hw_enc_features |= netdev->vlan_features;
-	netdev->mpls_features |= NETIF_F_SG |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6 |
-				 NETIF_F_HW_CSUM;
-	netdev->mpls_features |= IXGBE_GSO_PARTIAL_FEATURES;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_HW_CSUM,
+				&netdev->mpls_features);
+	netdev_feature_set_bits(IXGBE_GSO_PARTIAL_FEATURES,
+				&netdev->mpls_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
@@ -10870,18 +10906,20 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		fcoe_l = min_t(int, IXGBE_FCRETA_SIZE, num_online_cpus());
 		adapter->ring_feature[RING_F_FCOE].limit = fcoe_l;
 
-		netdev->features |= NETIF_F_FSO |
-				    NETIF_F_FCOE_CRC;
+		netdev_feature_set_bits(NETIF_F_FSO |
+					NETIF_F_FCOE_CRC,
+					&netdev->features);
 
-		netdev->vlan_features |= NETIF_F_FSO |
-					 NETIF_F_FCOE_CRC |
-					 NETIF_F_FCOE_MTU;
+		netdev_feature_set_bits(NETIF_F_FSO |
+					NETIF_F_FCOE_CRC |
+					NETIF_F_FCOE_MTU,
+					&netdev->vlan_features);
 	}
 #endif /* IXGBE_FCOE */
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE)
-		netdev->hw_features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->hw_features);
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
-		netdev->features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->features);
 
 	if (ixgbe_check_fw_error(adapter)) {
 		err = -EIO;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 214a38de3f41..7a89d8ef5170 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -491,7 +491,8 @@ static int ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 max_frame, u32 vf
 		s32 err = 0;
 
 #ifdef CONFIG_FCOE
-		if (dev->features & NETIF_F_FCOE_MTU)
+		if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+					    dev->features))
 			pf_max_frame = max_t(int, pf_max_frame,
 					     IXGBE_FCOE_JUMBO_FRAME_SIZE);
 
@@ -869,7 +870,8 @@ static int ixgbe_vf_reset_msg(struct ixgbe_adapter *adapter, u32 vf)
 		int pf_max_frame = dev->mtu + ETH_HLEN;
 
 #ifdef CONFIG_FCOE
-		if (dev->features & NETIF_F_FCOE_MTU)
+		if (netdev_feature_test_bit(NETIF_F_FCOE_MTU_BIT,
+					    dev->features))
 			pf_max_frame = max_t(int, pf_max_frame,
 					     IXGBE_FCOE_JUMBO_FRAME_SIZE);
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index e3e4676af9e4..60288efd19f9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -104,7 +104,8 @@ void ixgbevf_ipsec_restore(struct ixgbevf_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	int i;
 
-	if (!(adapter->netdev->features & NETIF_F_HW_ESP))
+	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT,
+				     adapter->netdev->features))
 		return;
 
 	/* reload the Rx and Tx keys */
@@ -654,8 +655,10 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 				 NETIF_F_HW_ESP_TX_CSUM | \
 				 NETIF_F_GSO_ESP)
 
-	adapter->netdev->features |= IXGBEVF_ESP_FEATURES;
-	adapter->netdev->hw_enc_features |= IXGBEVF_ESP_FEATURES;
+	netdev_feature_set_bits(IXGBEVF_ESP_FEATURES,
+				&adapter->netdev->features);
+	netdev_feature_set_bits(IXGBEVF_ESP_FEATURES,
+				&adapter->netdev->hw_enc_features);
 
 	return;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index f2f6d00960c5..f3d7e744f400 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -444,7 +444,8 @@ static inline void ixgbevf_rx_hash(struct ixgbevf_ring *ring,
 {
 	u16 rss_type;
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     ring->netdev->features))
 		return;
 
 	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
@@ -471,7 +472,8 @@ static inline void ixgbevf_rx_checksum(struct ixgbevf_ring *ring,
 	skb_checksum_none_assert(skb);
 
 	/* Rx csum disabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     ring->netdev->features))
 		return;
 
 	/* if IP and error */
@@ -742,7 +744,8 @@ static bool ixgbevf_cleanup_headers(struct ixgbevf_ring *rx_ring,
 					  IXGBE_RXDADV_ERR_FRAME_ERR_MASK))) {
 		struct net_device *netdev = rx_ring->netdev;
 
-		if (!(netdev->features & NETIF_F_RXALL)) {
+		if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					     netdev->features)) {
 			dev_kfree_skb_any(skb);
 			return true;
 		}
@@ -4389,28 +4392,31 @@ static void ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN)) {
-		*features &= ~(NETIF_F_HW_CSUM |
-			       NETIF_F_SCTP_CRC |
-			       NETIF_F_TSO |
-			       NETIF_F_TSO6);
+		netdev_feature_clear_bits(NETIF_F_HW_CSUM |
+					  NETIF_F_SCTP_CRC |
+					  NETIF_F_TSO |
+					  NETIF_F_TSO6,
+					  features);
 		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
-		*features &= ~NETIF_F_TSO;
+	if (skb->encapsulation &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
 static int ixgbevf_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
@@ -4581,12 +4587,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 	}
 
-	netdev->hw_features = NETIF_F_SG |
-			      NETIF_F_TSO |
-			      NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM |
-			      NETIF_F_HW_CSUM |
-			      NETIF_F_SCTP_CRC;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM |
+				NETIF_F_SCTP_CRC,
+				&netdev->hw_features);
 
 #define IXGBEVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				      NETIF_F_GSO_GRE_CSUM | \
@@ -4595,27 +4603,37 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				      NETIF_F_GSO_UDP_TUNNEL | \
 				      NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev->gso_partial_features = IXGBEVF_GSO_PARTIAL_FEATURES;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
-			       IXGBEVF_GSO_PARTIAL_FEATURES;
+	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_set_bits(IXGBEVF_GSO_PARTIAL_FEATURES,
+				&netdev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
+				IXGBEVF_GSO_PARTIAL_FEATURES,
+				&netdev->hw_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
-
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_SG |
-				 NETIF_F_TSO |
-				 NETIF_F_TSO6 |
-				 NETIF_F_HW_CSUM;
-	netdev->mpls_features |= IXGBEVF_GSO_PARTIAL_FEATURES;
-	netdev->hw_enc_features |= netdev->vlan_features;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
+			       &netdev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_HW_CSUM,
+				&netdev->mpls_features);
+	netdev_feature_set_bits(IXGBEVF_GSO_PARTIAL_FEATURES,
+				&netdev->mpls_features);
+	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-- 
2.33.0

