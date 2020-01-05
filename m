Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39B8130675
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgAEHOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:54705 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgAEHOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607351"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] igc: Remove no need declaration of the igc_set_default_mac_filter
Date:   Sat,  4 Jan 2020 23:14:08 -0800
Message-Id: <20200105071420.3778982-4-jeffrey.t.kirsher@intel.com>
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
Rearrange the igc_set_default_mac_filter function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 91 +++++++++++------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 17b83638efc9..95a62f838668 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -54,7 +54,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
 static void igc_configure(struct igc_adapter *adapter);
-static void igc_set_default_mac_filter(struct igc_adapter *adapter);
 static void igc_set_rx_mode(struct net_device *netdev);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
@@ -769,6 +768,51 @@ static void igc_setup_tctl(struct igc_adapter *adapter)
 	wr32(IGC_TCTL, tctl);
 }
 
+/**
+ * igc_rar_set_index - Sync RAL[index] and RAH[index] registers with MAC table
+ * @adapter: address of board private structure
+ * @index: Index of the RAR entry which need to be synced with MAC table
+ */
+static void igc_rar_set_index(struct igc_adapter *adapter, u32 index)
+{
+	u8 *addr = adapter->mac_table[index].addr;
+	struct igc_hw *hw = &adapter->hw;
+	u32 rar_low, rar_high;
+
+	/* HW expects these to be in network order when they are plugged
+	 * into the registers which are little endian.  In order to guarantee
+	 * that ordering we need to do an leXX_to_cpup here in order to be
+	 * ready for the byteswap that occurs with writel
+	 */
+	rar_low = le32_to_cpup((__le32 *)(addr));
+	rar_high = le16_to_cpup((__le16 *)(addr + 4));
+
+	/* Indicate to hardware the Address is Valid. */
+	if (adapter->mac_table[index].state & IGC_MAC_STATE_IN_USE) {
+		if (is_valid_ether_addr(addr))
+			rar_high |= IGC_RAH_AV;
+
+		rar_high |= IGC_RAH_POOL_1 <<
+			adapter->mac_table[index].queue;
+	}
+
+	wr32(IGC_RAL(index), rar_low);
+	wrfl();
+	wr32(IGC_RAH(index), rar_high);
+	wrfl();
+}
+
+/* Set default MAC address for the PF in the first RAR entry */
+static void igc_set_default_mac_filter(struct igc_adapter *adapter)
+{
+	struct igc_mac_addr *mac_table = &adapter->mac_table[0];
+
+	ether_addr_copy(mac_table->addr, adapter->hw.mac.addr);
+	mac_table->state = IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
+
+	igc_rar_set_index(adapter, 0);
+}
+
 /**
  * igc_set_mac - Change the Ethernet Address of the NIC
  * @netdev: network interface device structure
@@ -2430,51 +2474,6 @@ static void igc_configure(struct igc_adapter *adapter)
 	}
 }
 
-/**
- * igc_rar_set_index - Sync RAL[index] and RAH[index] registers with MAC table
- * @adapter: address of board private structure
- * @index: Index of the RAR entry which need to be synced with MAC table
- */
-static void igc_rar_set_index(struct igc_adapter *adapter, u32 index)
-{
-	u8 *addr = adapter->mac_table[index].addr;
-	struct igc_hw *hw = &adapter->hw;
-	u32 rar_low, rar_high;
-
-	/* HW expects these to be in network order when they are plugged
-	 * into the registers which are little endian.  In order to guarantee
-	 * that ordering we need to do an leXX_to_cpup here in order to be
-	 * ready for the byteswap that occurs with writel
-	 */
-	rar_low = le32_to_cpup((__le32 *)(addr));
-	rar_high = le16_to_cpup((__le16 *)(addr + 4));
-
-	/* Indicate to hardware the Address is Valid. */
-	if (adapter->mac_table[index].state & IGC_MAC_STATE_IN_USE) {
-		if (is_valid_ether_addr(addr))
-			rar_high |= IGC_RAH_AV;
-
-		rar_high |= IGC_RAH_POOL_1 <<
-			adapter->mac_table[index].queue;
-	}
-
-	wr32(IGC_RAL(index), rar_low);
-	wrfl();
-	wr32(IGC_RAH(index), rar_high);
-	wrfl();
-}
-
-/* Set default MAC address for the PF in the first RAR entry */
-static void igc_set_default_mac_filter(struct igc_adapter *adapter)
-{
-	struct igc_mac_addr *mac_table = &adapter->mac_table[0];
-
-	ether_addr_copy(mac_table->addr, adapter->hw.mac.addr);
-	mac_table->state = IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
-
-	igc_rar_set_index(adapter, 0);
-}
-
 /* If the filter to be added and an already existing filter express
  * the same address and address type, it should be possible to only
  * override the other configurations, for example the queue to steer
-- 
2.24.1

