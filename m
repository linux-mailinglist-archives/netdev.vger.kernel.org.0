Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C151AFDD1
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDSTvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:45115 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgDSTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:35 -0400
IronPort-SDR: nvmefwbfdJLpqccCZEZ3FLkJfyNMr7n0DeuZI5nIrvT+ahlKxrdL8JDBfSeSzxBm32Ie35Qy8s
 Qk0fXdNua2JQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:35 -0700
IronPort-SDR: L58OrVvgbFN3Drx7K5RY12LxOm69aUbCLO41K6G1vxSRQWaNidnizktjZdTyKT5m5S0Iw2jCe8
 e32PWZsQSVvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034431"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/14] igc: Refactor igc_mac_entry_can_be_used()
Date:   Sun, 19 Apr 2020 12:51:29 -0700
Message-Id: <20200419195131.1068144-13-jeffrey.t.kirsher@intel.com>
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

The helper igc_mac_entry_can_be_used() implementation is a bit
convoluted since it does two different things: find a not-in-use slot
in mac_table or find an in-use slot where the address and address type
match. This patch does a code refactoring and break it up into two
helper functions.

With this patch we might traverse mac_table twice in some situations,
but this is not harmful performance-wise (mac_table has only 16 entries
and adding mac filters is not hot-path), and it improves igc_add_mac_
filter() readability considerably.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 80 +++++++++++++----------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3af6ce1712d5..79a9875e0767 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2176,25 +2176,44 @@ static void igc_nfc_filter_restore(struct igc_adapter *adapter)
 	spin_unlock(&adapter->nfc_lock);
 }
 
-/* If the filter to be added and an already existing filter express
- * the same address and address type, it should be possible to only
- * override the other configurations, for example the queue to steer
- * traffic.
- */
-static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
-				      const u8 *addr, const u8 flags)
+static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+			       u8 flags)
 {
-	if (!(entry->state & IGC_MAC_STATE_IN_USE))
-		return true;
+	int max_entries = adapter->hw.mac.rar_entry_count;
+	struct igc_mac_addr *entry;
+	int i;
 
-	if ((entry->state & IGC_MAC_STATE_SRC_ADDR) !=
-	    (flags & IGC_MAC_STATE_SRC_ADDR))
-		return false;
+	for (i = 0; i < max_entries; i++) {
+		entry = &adapter->mac_table[i];
 
-	if (!ether_addr_equal(addr, entry->addr))
-		return false;
+		if (!(entry->state & IGC_MAC_STATE_IN_USE))
+			continue;
+		if (!ether_addr_equal(addr, entry->addr))
+			continue;
+		if ((entry->state & IGC_MAC_STATE_SRC_ADDR) !=
+		    (flags & IGC_MAC_STATE_SRC_ADDR))
+			continue;
 
-	return true;
+		return i;
+	}
+
+	return -1;
+}
+
+static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
+{
+	int max_entries = adapter->hw.mac.rar_entry_count;
+	struct igc_mac_addr *entry;
+	int i;
+
+	for (i = 0; i < max_entries; i++) {
+		entry = &adapter->mac_table[i];
+
+		if (!(entry->state & IGC_MAC_STATE_IN_USE))
+			return i;
+	}
+
+	return -1;
 }
 
 /**
@@ -2212,33 +2231,28 @@ static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
 int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const s8 queue, const u8 flags)
 {
-	struct igc_hw *hw = &adapter->hw;
-	int rar_entries = hw->mac.rar_entry_count;
-	int i;
+	int index;
 
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 	if (flags & IGC_MAC_STATE_SRC_ADDR)
 		return -ENOTSUPP;
 
-	/* Search for the first empty entry in the MAC table.
-	 * Do not touch entries at the end of the table reserved for the VF MAC
-	 * addresses.
-	 */
-	for (i = 0; i < rar_entries; i++) {
-		if (!igc_mac_entry_can_be_used(&adapter->mac_table[i],
-					       addr, flags))
-			continue;
+	index = igc_find_mac_filter(adapter, addr, flags);
+	if (index >= 0)
+		goto update_queue_assignment;
 
-		ether_addr_copy(adapter->mac_table[i].addr, addr);
-		adapter->mac_table[i].queue = queue;
-		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE | flags;
+	index = igc_get_avail_mac_filter_slot(adapter);
+	if (index < 0)
+		return -ENOSPC;
 
-		igc_set_mac_filter_hw(adapter, i, addr, queue);
-		return 0;
-	}
+	ether_addr_copy(adapter->mac_table[index].addr, addr);
+	adapter->mac_table[index].state |= IGC_MAC_STATE_IN_USE | flags;
+update_queue_assignment:
+	adapter->mac_table[index].queue = queue;
 
-	return -ENOSPC;
+	igc_set_mac_filter_hw(adapter, index, addr, queue);
+	return 0;
 }
 
 /**
-- 
2.25.2

