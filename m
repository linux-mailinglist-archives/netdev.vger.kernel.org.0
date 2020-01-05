Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A1130678
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgAEHOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:46 -0500
Received: from mga05.intel.com ([192.55.52.43]:54705 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgAEHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607363"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] igc: Remove no need declaration of the igc_set_rx_mode
Date:   Sat,  4 Jan 2020 23:14:12 -0800
Message-Id: <20200105071420.3778982-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_set_rx_mode function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 353 +++++++++++-----------
 1 file changed, 176 insertions(+), 177 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 452e26202c9e..13491ad7d251 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -53,7 +53,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
-static void igc_set_rx_mode(struct net_device *netdev);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
 static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
@@ -1992,6 +1991,182 @@ static void igc_nfc_filter_restore(struct igc_adapter *adapter)
 	spin_unlock(&adapter->nfc_lock);
 }
 
+/* If the filter to be added and an already existing filter express
+ * the same address and address type, it should be possible to only
+ * override the other configurations, for example the queue to steer
+ * traffic.
+ */
+static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
+				      const u8 *addr, const u8 flags)
+{
+	if (!(entry->state & IGC_MAC_STATE_IN_USE))
+		return true;
+
+	if ((entry->state & IGC_MAC_STATE_SRC_ADDR) !=
+	    (flags & IGC_MAC_STATE_SRC_ADDR))
+		return false;
+
+	if (!ether_addr_equal(addr, entry->addr))
+		return false;
+
+	return true;
+}
+
+/* Add a MAC filter for 'addr' directing matching traffic to 'queue',
+ * 'flags' is used to indicate what kind of match is made, match is by
+ * default for the destination address, if matching by source address
+ * is desired the flag IGC_MAC_STATE_SRC_ADDR can be used.
+ */
+static int igc_add_mac_filter(struct igc_adapter *adapter,
+			      const u8 *addr, const u8 queue)
+{
+	struct igc_hw *hw = &adapter->hw;
+	int rar_entries = hw->mac.rar_entry_count;
+	int i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	/* Search for the first empty entry in the MAC table.
+	 * Do not touch entries at the end of the table reserved for the VF MAC
+	 * addresses.
+	 */
+	for (i = 0; i < rar_entries; i++) {
+		if (!igc_mac_entry_can_be_used(&adapter->mac_table[i],
+					       addr, 0))
+			continue;
+
+		ether_addr_copy(adapter->mac_table[i].addr, addr);
+		adapter->mac_table[i].queue = queue;
+		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE;
+
+		igc_rar_set_index(adapter, i);
+		return i;
+	}
+
+	return -ENOSPC;
+}
+
+/* Remove a MAC filter for 'addr' directing matching traffic to
+ * 'queue', 'flags' is used to indicate what kind of match need to be
+ * removed, match is by default for the destination address, if
+ * matching by source address is to be removed the flag
+ * IGC_MAC_STATE_SRC_ADDR can be used.
+ */
+static int igc_del_mac_filter(struct igc_adapter *adapter,
+			      const u8 *addr, const u8 queue)
+{
+	struct igc_hw *hw = &adapter->hw;
+	int rar_entries = hw->mac.rar_entry_count;
+	int i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	/* Search for matching entry in the MAC table based on given address
+	 * and queue. Do not touch entries at the end of the table reserved
+	 * for the VF MAC addresses.
+	 */
+	for (i = 0; i < rar_entries; i++) {
+		if (!(adapter->mac_table[i].state & IGC_MAC_STATE_IN_USE))
+			continue;
+		if (adapter->mac_table[i].state != 0)
+			continue;
+		if (adapter->mac_table[i].queue != queue)
+			continue;
+		if (!ether_addr_equal(adapter->mac_table[i].addr, addr))
+			continue;
+
+		/* When a filter for the default address is "deleted",
+		 * we return it to its initial configuration
+		 */
+		if (adapter->mac_table[i].state & IGC_MAC_STATE_DEFAULT) {
+			adapter->mac_table[i].state =
+				IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
+			adapter->mac_table[i].queue = 0;
+		} else {
+			adapter->mac_table[i].state = 0;
+			adapter->mac_table[i].queue = 0;
+			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		}
+
+		igc_rar_set_index(adapter, i);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	int ret;
+
+	ret = igc_add_mac_filter(adapter, addr, adapter->num_rx_queues);
+
+	return min_t(int, ret, 0);
+}
+
+static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	igc_del_mac_filter(adapter, addr, adapter->num_rx_queues);
+
+	return 0;
+}
+
+/**
+ * igc_set_rx_mode - Secondary Unicast, Multicast and Promiscuous mode set
+ * @netdev: network interface device structure
+ *
+ * The set_rx_mode entry point is called whenever the unicast or multicast
+ * address lists or the network interface flags are updated.  This routine is
+ * responsible for configuring the hardware for proper unicast, multicast,
+ * promiscuous mode, and all-multi behavior.
+ */
+static void igc_set_rx_mode(struct net_device *netdev)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	u32 rctl = 0, rlpml = MAX_JUMBO_FRAME_SIZE;
+	int count;
+
+	/* Check for Promiscuous and All Multicast modes */
+	if (netdev->flags & IFF_PROMISC) {
+		rctl |= IGC_RCTL_UPE | IGC_RCTL_MPE;
+	} else {
+		if (netdev->flags & IFF_ALLMULTI) {
+			rctl |= IGC_RCTL_MPE;
+		} else {
+			/* Write addresses to the MTA, if the attempt fails
+			 * then we should just turn on promiscuous mode so
+			 * that we can at least receive multicast traffic
+			 */
+			count = igc_write_mc_addr_list(netdev);
+			if (count < 0)
+				rctl |= IGC_RCTL_MPE;
+		}
+	}
+
+	/* Write addresses to available RAR registers, if there is not
+	 * sufficient space to store all the addresses then enable
+	 * unicast promiscuous mode
+	 */
+	if (__dev_uc_sync(netdev, igc_uc_sync, igc_uc_unsync))
+		rctl |= IGC_RCTL_UPE;
+
+	/* update state of unicast and multicast */
+	rctl |= rd32(IGC_RCTL) & ~(IGC_RCTL_UPE | IGC_RCTL_MPE);
+	wr32(IGC_RCTL, rctl);
+
+#if (PAGE_SIZE < 8192)
+	if (adapter->max_frame_size <= IGC_MAX_FRAME_BUILD_SKB)
+		rlpml = IGC_MAX_FRAME_BUILD_SKB;
+#endif
+	wr32(IGC_RLPML, rlpml);
+}
+
 /**
  * igc_configure - configure the hardware for RX and TX
  * @adapter: private board structure
@@ -2469,27 +2644,6 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	return features;
 }
 
-/* If the filter to be added and an already existing filter express
- * the same address and address type, it should be possible to only
- * override the other configurations, for example the queue to steer
- * traffic.
- */
-static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
-				      const u8 *addr, const u8 flags)
-{
-	if (!(entry->state & IGC_MAC_STATE_IN_USE))
-		return true;
-
-	if ((entry->state & IGC_MAC_STATE_SRC_ADDR) !=
-	    (flags & IGC_MAC_STATE_SRC_ADDR))
-		return false;
-
-	if (!ether_addr_equal(addr, entry->addr))
-		return false;
-
-	return true;
-}
-
 /* Add a MAC filter for 'addr' directing matching traffic to 'queue',
  * 'flags' is used to indicate what kind of match is made, match is by
  * default for the destination address, if matching by source address
@@ -2590,161 +2744,6 @@ int igc_del_mac_steering_filter(struct igc_adapter *adapter,
 					IGC_MAC_STATE_QUEUE_STEERING | flags);
 }
 
-/* Add a MAC filter for 'addr' directing matching traffic to 'queue',
- * 'flags' is used to indicate what kind of match is made, match is by
- * default for the destination address, if matching by source address
- * is desired the flag IGC_MAC_STATE_SRC_ADDR can be used.
- */
-static int igc_add_mac_filter(struct igc_adapter *adapter,
-			      const u8 *addr, const u8 queue)
-{
-	struct igc_hw *hw = &adapter->hw;
-	int rar_entries = hw->mac.rar_entry_count;
-	int i;
-
-	if (is_zero_ether_addr(addr))
-		return -EINVAL;
-
-	/* Search for the first empty entry in the MAC table.
-	 * Do not touch entries at the end of the table reserved for the VF MAC
-	 * addresses.
-	 */
-	for (i = 0; i < rar_entries; i++) {
-		if (!igc_mac_entry_can_be_used(&adapter->mac_table[i],
-					       addr, 0))
-			continue;
-
-		ether_addr_copy(adapter->mac_table[i].addr, addr);
-		adapter->mac_table[i].queue = queue;
-		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE;
-
-		igc_rar_set_index(adapter, i);
-		return i;
-	}
-
-	return -ENOSPC;
-}
-
-/* Remove a MAC filter for 'addr' directing matching traffic to
- * 'queue', 'flags' is used to indicate what kind of match need to be
- * removed, match is by default for the destination address, if
- * matching by source address is to be removed the flag
- * IGC_MAC_STATE_SRC_ADDR can be used.
- */
-static int igc_del_mac_filter(struct igc_adapter *adapter,
-			      const u8 *addr, const u8 queue)
-{
-	struct igc_hw *hw = &adapter->hw;
-	int rar_entries = hw->mac.rar_entry_count;
-	int i;
-
-	if (is_zero_ether_addr(addr))
-		return -EINVAL;
-
-	/* Search for matching entry in the MAC table based on given address
-	 * and queue. Do not touch entries at the end of the table reserved
-	 * for the VF MAC addresses.
-	 */
-	for (i = 0; i < rar_entries; i++) {
-		if (!(adapter->mac_table[i].state & IGC_MAC_STATE_IN_USE))
-			continue;
-		if (adapter->mac_table[i].state != 0)
-			continue;
-		if (adapter->mac_table[i].queue != queue)
-			continue;
-		if (!ether_addr_equal(adapter->mac_table[i].addr, addr))
-			continue;
-
-		/* When a filter for the default address is "deleted",
-		 * we return it to its initial configuration
-		 */
-		if (adapter->mac_table[i].state & IGC_MAC_STATE_DEFAULT) {
-			adapter->mac_table[i].state =
-				IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
-			adapter->mac_table[i].queue = 0;
-		} else {
-			adapter->mac_table[i].state = 0;
-			adapter->mac_table[i].queue = 0;
-			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
-		}
-
-		igc_rar_set_index(adapter, i);
-		return 0;
-	}
-
-	return -ENOENT;
-}
-
-static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
-{
-	struct igc_adapter *adapter = netdev_priv(netdev);
-	int ret;
-
-	ret = igc_add_mac_filter(adapter, addr, adapter->num_rx_queues);
-
-	return min_t(int, ret, 0);
-}
-
-static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
-{
-	struct igc_adapter *adapter = netdev_priv(netdev);
-
-	igc_del_mac_filter(adapter, addr, adapter->num_rx_queues);
-
-	return 0;
-}
-
-/**
- * igc_set_rx_mode - Secondary Unicast, Multicast and Promiscuous mode set
- * @netdev: network interface device structure
- *
- * The set_rx_mode entry point is called whenever the unicast or multicast
- * address lists or the network interface flags are updated.  This routine is
- * responsible for configuring the hardware for proper unicast, multicast,
- * promiscuous mode, and all-multi behavior.
- */
-static void igc_set_rx_mode(struct net_device *netdev)
-{
-	struct igc_adapter *adapter = netdev_priv(netdev);
-	struct igc_hw *hw = &adapter->hw;
-	u32 rctl = 0, rlpml = MAX_JUMBO_FRAME_SIZE;
-	int count;
-
-	/* Check for Promiscuous and All Multicast modes */
-	if (netdev->flags & IFF_PROMISC) {
-		rctl |= IGC_RCTL_UPE | IGC_RCTL_MPE;
-	} else {
-		if (netdev->flags & IFF_ALLMULTI) {
-			rctl |= IGC_RCTL_MPE;
-		} else {
-			/* Write addresses to the MTA, if the attempt fails
-			 * then we should just turn on promiscuous mode so
-			 * that we can at least receive multicast traffic
-			 */
-			count = igc_write_mc_addr_list(netdev);
-			if (count < 0)
-				rctl |= IGC_RCTL_MPE;
-		}
-	}
-
-	/* Write addresses to available RAR registers, if there is not
-	 * sufficient space to store all the addresses then enable
-	 * unicast promiscuous mode
-	 */
-	if (__dev_uc_sync(netdev, igc_uc_sync, igc_uc_unsync))
-		rctl |= IGC_RCTL_UPE;
-
-	/* update state of unicast and multicast */
-	rctl |= rd32(IGC_RCTL) & ~(IGC_RCTL_UPE | IGC_RCTL_MPE);
-	wr32(IGC_RCTL, rctl);
-
-#if (PAGE_SIZE < 8192)
-	if (adapter->max_frame_size <= IGC_MAX_FRAME_BUILD_SKB)
-		rlpml = IGC_MAX_FRAME_BUILD_SKB;
-#endif
-	wr32(IGC_RLPML, rlpml);
-}
-
 /**
  * igc_msix_other - msix other interrupt handler
  * @irq: interrupt number
-- 
2.24.1

