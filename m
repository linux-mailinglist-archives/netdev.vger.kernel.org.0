Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986211AFDCC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDSTvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDSTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:34 -0400
IronPort-SDR: dBNk8vBq0QOwkoSH1h6FPjtmBcUpF+t/2N3VW+tIPLxWnC0Wuw379aL5I4OcYkd6E4Rrc33hRY
 Oh8bVd/SzaCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:33 -0700
IronPort-SDR: x9LP/gaZ+flt9OdAkF5cNnWdZNIvGmw8sNdNxr1lKNzVzAimW6plJdyV52b50lyN6UZCgfYcIs
 BWzBHWW3+EVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034401"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/14] igc: Remove duplicate code in MAC filtering logic
Date:   Sun, 19 Apr 2020 12:51:20 -0700
Message-Id: <20200419195131.1068144-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch does a code refactoring in the MAC address filtering logic to
get rid of some duplicate code.

IGC driver has two functions to add MAC address filters that are pretty
much the same: igc_add_mac_filter() and igc_add_mac_filter_flags(). The
only difference is that the latter allows the callee to specify the
'flags' parameter while the former has it hard coded as zero. The same
rationale applies to filter deletion counterparts.

So this patch refactors igc_add_mac_filter() and igc_del_mac_filter() so
they handle the 'flags' parameters, removes the _flags() functions, and
fixes callees accordingly.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 112 +++-------------------
 1 file changed, 13 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6a7c1b081792..ade460f08ed1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2191,8 +2191,8 @@ static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
  * default for the destination address, if matching by source address
  * is desired the flag IGC_MAC_STATE_SRC_ADDR can be used.
  */
-static int igc_add_mac_filter(struct igc_adapter *adapter,
-			      const u8 *addr, const u8 queue)
+static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+			      const u8 queue, const u8 flags)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int rar_entries = hw->mac.rar_entry_count;
@@ -2207,12 +2207,12 @@ static int igc_add_mac_filter(struct igc_adapter *adapter,
 	 */
 	for (i = 0; i < rar_entries; i++) {
 		if (!igc_mac_entry_can_be_used(&adapter->mac_table[i],
-					       addr, 0))
+					       addr, flags))
 			continue;
 
 		ether_addr_copy(adapter->mac_table[i].addr, addr);
 		adapter->mac_table[i].queue = queue;
-		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE;
+		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE | flags;
 
 		igc_rar_set_index(adapter, i);
 		return i;
@@ -2227,8 +2227,8 @@ static int igc_add_mac_filter(struct igc_adapter *adapter,
  * matching by source address is to be removed the flag
  * IGC_MAC_STATE_SRC_ADDR can be used.
  */
-static int igc_del_mac_filter(struct igc_adapter *adapter,
-			      const u8 *addr, const u8 queue)
+static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+			      const u8 queue, const u8 flags)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int rar_entries = hw->mac.rar_entry_count;
@@ -2244,7 +2244,7 @@ static int igc_del_mac_filter(struct igc_adapter *adapter,
 	for (i = 0; i < rar_entries; i++) {
 		if (!(adapter->mac_table[i].state & IGC_MAC_STATE_IN_USE))
 			continue;
-		if (adapter->mac_table[i].state != 0)
+		if (flags && (adapter->mac_table[i].state & flags) != flags)
 			continue;
 		if (adapter->mac_table[i].queue != queue)
 			continue;
@@ -2276,7 +2276,7 @@ static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	int ret;
 
-	ret = igc_add_mac_filter(adapter, addr, adapter->num_rx_queues);
+	ret = igc_add_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
 
 	return min_t(int, ret, 0);
 }
@@ -2285,7 +2285,7 @@ static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	igc_del_mac_filter(adapter, addr, adapter->num_rx_queues);
+	igc_del_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
 
 	return 0;
 }
@@ -3720,104 +3720,18 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	return features;
 }
 
-/* Add a MAC filter for 'addr' directing matching traffic to 'queue',
- * 'flags' is used to indicate what kind of match is made, match is by
- * default for the destination address, if matching by source address
- * is desired the flag IGC_MAC_STATE_SRC_ADDR can be used.
- */
-static int igc_add_mac_filter_flags(struct igc_adapter *adapter,
-				    const u8 *addr, const u8 queue,
-				    const u8 flags)
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
-					       addr, flags))
-			continue;
-
-		ether_addr_copy(adapter->mac_table[i].addr, addr);
-		adapter->mac_table[i].queue = queue;
-		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE | flags;
-
-		igc_rar_set_index(adapter, i);
-		return i;
-	}
-
-	return -ENOSPC;
-}
-
 int igc_add_mac_steering_filter(struct igc_adapter *adapter,
 				const u8 *addr, u8 queue, u8 flags)
 {
-	return igc_add_mac_filter_flags(adapter, addr, queue,
-					IGC_MAC_STATE_QUEUE_STEERING | flags);
-}
-
-/* Remove a MAC filter for 'addr' directing matching traffic to
- * 'queue', 'flags' is used to indicate what kind of match need to be
- * removed, match is by default for the destination address, if
- * matching by source address is to be removed the flag
- * IGC_MAC_STATE_SRC_ADDR can be used.
- */
-static int igc_del_mac_filter_flags(struct igc_adapter *adapter,
-				    const u8 *addr, const u8 queue,
-				    const u8 flags)
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
-		if ((adapter->mac_table[i].state & flags) != flags)
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
+	return igc_add_mac_filter(adapter, addr, queue,
+				  IGC_MAC_STATE_QUEUE_STEERING | flags);
 }
 
 int igc_del_mac_steering_filter(struct igc_adapter *adapter,
 				const u8 *addr, u8 queue, u8 flags)
 {
-	return igc_del_mac_filter_flags(adapter, addr, queue,
-					IGC_MAC_STATE_QUEUE_STEERING | flags);
+	return igc_del_mac_filter(adapter, addr, queue,
+				  IGC_MAC_STATE_QUEUE_STEERING | flags);
 }
 
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
-- 
2.25.2

