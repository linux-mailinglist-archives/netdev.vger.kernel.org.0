Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194011AFDCF
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDSTvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:45114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgDSTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:35 -0400
IronPort-SDR: DLd4CR0+lYY464hduPMrqlaKN5V3FMxtOE6kjtJ2wIf9vovDpYthTduHzxqZKlOUsfJOV6CZSm
 /LUH0ZZeJwDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:34 -0700
IronPort-SDR: BNIWAaWxuL3+8Vw6szejZ1upuFWoTgWHXbezZASER/wK9dt9g0x7RzEwEqidJOgvIAu8Ma84VJ
 Nb5q3I0h/Agg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034416"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/14] igc: Refactor igc_rar_set_index()
Date:   Sun, 19 Apr 2020 12:51:24 -0700
Message-Id: <20200419195131.1068144-8-jeffrey.t.kirsher@intel.com>
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

Current igc_rar_set_index() implementation is a bit convoluted so this
patch does some code refactoring to improve it.

The helper igc_rar_set_index() is about writing MAC filter settings into
hardware registers. Logic such as address validation belongs to
functions upper in the call chain such as igc_set_mac() and
igc_add_mac_filter(). So this patch moves the is_valid_ether_addr() call
to igc_add_mac_filter(). No need to touch igc_set_mac() since it already
checks it.

The variables 'rar_low' and 'rar_high' represent the value in registers
RAL and RAH so we rename them to 'ral' and 'rah', respectively, to
match the registers names.

To make it explicit, filter settings are passed as arguments to the
function instead of reading them from adapter->mac_table "under the
hood". Also, the function was renamed to igc_set_mac_filter_hw to make
it more clear what it does.

Finally, the patch removes some wrfl() calls and comments not needed.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 73 +++++++++++++----------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index dc4632428117..2f6c8f7fa6f4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -765,42 +765,52 @@ static void igc_setup_tctl(struct igc_adapter *adapter)
 }
 
 /**
- * igc_rar_set_index - Sync RAL[index] and RAH[index] registers with MAC table
- * @adapter: address of board private structure
- * @index: Index of the RAR entry which need to be synced with MAC table
+ * igc_set_mac_filter_hw() - Set MAC address filter in hardware
+ * @adapter: Pointer to adapter where the filter should be set
+ * @index: Filter index
+ * @addr: Destination MAC address
+ * @queue: If non-negative, queue assignment feature is enabled and frames
+ *         matching the filter are enqueued onto 'queue'. Otherwise, queue
+ *         assignment is disabled.
  */
-static void igc_rar_set_index(struct igc_adapter *adapter, u32 index)
+static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
+				  const u8 *addr, int queue)
 {
-	u8 *addr = adapter->mac_table[index].addr;
 	struct igc_hw *hw = &adapter->hw;
-	u32 rar_low, rar_high;
+	u32 ral, rah;
 
-	/* HW expects these to be in network order when they are plugged
-	 * into the registers which are little endian.  In order to guarantee
-	 * that ordering we need to do an leXX_to_cpup here in order to be
-	 * ready for the byteswap that occurs with writel
-	 */
-	rar_low = le32_to_cpup((__le32 *)(addr));
-	rar_high = le16_to_cpup((__le16 *)(addr + 4));
+	if (WARN_ON(index >= hw->mac.rar_entry_count))
+		return;
 
-	if (adapter->mac_table[index].state & IGC_MAC_STATE_QUEUE_STEERING) {
-		u8 queue = adapter->mac_table[index].queue;
-		u32 qsel = IGC_RAH_QSEL_MASK & (queue << IGC_RAH_QSEL_SHIFT);
+	ral = le32_to_cpup((__le32 *)(addr));
+	rah = le16_to_cpup((__le16 *)(addr + 4));
 
-		rar_high |= qsel;
-		rar_high |= IGC_RAH_QSEL_ENABLE;
+	if (queue >= 0) {
+		rah &= ~IGC_RAH_QSEL_MASK;
+		rah |= (queue << IGC_RAH_QSEL_SHIFT);
+		rah |= IGC_RAH_QSEL_ENABLE;
 	}
 
-	/* Indicate to hardware the Address is Valid. */
-	if (adapter->mac_table[index].state & IGC_MAC_STATE_IN_USE) {
-		if (is_valid_ether_addr(addr))
-			rar_high |= IGC_RAH_AV;
-	}
+	rah |= IGC_RAH_AV;
 
-	wr32(IGC_RAL(index), rar_low);
-	wrfl();
-	wr32(IGC_RAH(index), rar_high);
-	wrfl();
+	wr32(IGC_RAL(index), ral);
+	wr32(IGC_RAH(index), rah);
+}
+
+/**
+ * igc_clear_mac_filter_hw() - Clear MAC address filter in hardware
+ * @adapter: Pointer to adapter where the filter should be cleared
+ * @index: Filter index
+ */
+static void igc_clear_mac_filter_hw(struct igc_adapter *adapter, int index)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	if (WARN_ON(index >= hw->mac.rar_entry_count))
+		return;
+
+	wr32(IGC_RAL(index), 0);
+	wr32(IGC_RAH(index), 0);
 }
 
 /* Set default MAC address for the PF in the first RAR entry */
@@ -811,7 +821,7 @@ static void igc_set_default_mac_filter(struct igc_adapter *adapter)
 	ether_addr_copy(mac_table->addr, adapter->hw.mac.addr);
 	mac_table->state = IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
 
-	igc_rar_set_index(adapter, 0);
+	igc_set_mac_filter_hw(adapter, 0, mac_table->addr, -1);
 }
 
 /**
@@ -2198,7 +2208,7 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	int rar_entries = hw->mac.rar_entry_count;
 	int i;
 
-	if (is_zero_ether_addr(addr))
+	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 	if (flags & IGC_MAC_STATE_SRC_ADDR)
 		return -ENOTSUPP;
@@ -2216,7 +2226,7 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		adapter->mac_table[i].queue = queue;
 		adapter->mac_table[i].state |= IGC_MAC_STATE_IN_USE | flags;
 
-		igc_rar_set_index(adapter, i);
+		igc_set_mac_filter_hw(adapter, i, addr, queue);
 		return 0;
 	}
 
@@ -2260,13 +2270,14 @@ static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 			adapter->mac_table[i].state =
 				IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
 			adapter->mac_table[i].queue = 0;
+			igc_set_mac_filter_hw(adapter, 0, addr, -1);
 		} else {
 			adapter->mac_table[i].state = 0;
 			adapter->mac_table[i].queue = 0;
 			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+			igc_clear_mac_filter_hw(adapter, i);
 		}
 
-		igc_rar_set_index(adapter, i);
 		return 0;
 	}
 
-- 
2.25.2

