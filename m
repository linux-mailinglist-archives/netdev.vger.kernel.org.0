Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93AD1DC79E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgEUH2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:36202 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgEUH2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:02 -0400
IronPort-SDR: wK/M0IC1iI48YjLjhAfncpjynbmjnHokOoDozT0o80ri/rjuzNkou7vNdkTQhI7drorPLahxlz
 az7JSy4FnI/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:01 -0700
IronPort-SDR: S+pls7O7Udc5zR4CQO4QDSF0TxbSK8v5jU1ypYD99x1Mke2lTs39nnctk1AwdotX64mc7OSx7G
 kuOAyPtKRnbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758683"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:27:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] igc: Remove mac_table from igc_adapter
Date:   Thu, 21 May 2020 00:27:45 -0700
Message-Id: <20200521072758.440264-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In igc_adapter we keep a sort of shadow copy of RAL and RAH registers.
There is not much benefit in keeping it, at the cost of maintainability,
since adding/removing MAC address filters is not hot path, and we
already keep filters information in adapter->nfc_filter_list for cleanup
and restoration purposes.

So in order to simplify the MAC address filtering code and prepare it
for source address support, this patch removes the mac_table from
igc_adapter.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         | 11 ----
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 57 +++++++-------------
 3 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 885998d3f62e..5ce859155396 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -190,8 +190,6 @@ struct igc_adapter {
 	/* lock for RX network flow classification filter */
 	spinlock_t nfc_lock;
 
-	struct igc_mac_addr *mac_table;
-
 	u8 rss_indir_tbl[IGC_RETA_SIZE];
 
 	unsigned long link_check_timeout;
@@ -470,15 +468,6 @@ struct igc_nfc_filter {
 	u16 action;
 };
 
-struct igc_mac_addr {
-	u8 addr[ETH_ALEN];
-	s8 queue;
-	u8 state; /* bitmask */
-};
-
-#define IGC_MAC_STATE_DEFAULT		0x1
-#define IGC_MAC_STATE_IN_USE		0x2
-
 #define IGC_MAX_RXNFC_FILTERS		16
 
 /* igc_desc_unused - calculate if we have unused descriptors */
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 51d8a15e239c..be152a93088a 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -62,6 +62,7 @@
  * (RAR[15]) for our directed address used by controllers with
  * manageability enabled, allowing us room for 15 multicast addresses.
  */
+#define IGC_RAH_RAH_MASK	0x0000FFFF
 #define IGC_RAH_QSEL_MASK	0x000C0000
 #define IGC_RAH_QSEL_SHIFT	18
 #define IGC_RAH_QSEL_ENABLE	BIT(28)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3242136bb47a..af3092813a06 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -820,17 +820,12 @@ static void igc_clear_mac_filter_hw(struct igc_adapter *adapter, int index)
 /* Set default MAC address for the PF in the first RAR entry */
 static void igc_set_default_mac_filter(struct igc_adapter *adapter)
 {
-	struct igc_mac_addr *mac_table = &adapter->mac_table[0];
 	struct net_device *dev = adapter->netdev;
 	u8 *addr = adapter->hw.mac.addr;
 
 	netdev_dbg(dev, "Set default MAC address filter: address %pM", addr);
 
-	ether_addr_copy(mac_table->addr, addr);
-	mac_table->state = IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
-	mac_table->queue = -1;
-
-	igc_set_mac_filter_hw(adapter, 0, addr, mac_table->queue);
+	igc_set_mac_filter_hw(adapter, 0, addr, -1);
 }
 
 /**
@@ -2186,16 +2181,21 @@ static void igc_nfc_filter_restore(struct igc_adapter *adapter)
 
 static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 {
-	int max_entries = adapter->hw.mac.rar_entry_count;
-	struct igc_mac_addr *entry;
+	struct igc_hw *hw = &adapter->hw;
+	int max_entries = hw->mac.rar_entry_count;
+	u32 ral, rah;
 	int i;
 
 	for (i = 0; i < max_entries; i++) {
-		entry = &adapter->mac_table[i];
+		ral = rd32(IGC_RAL(i));
+		rah = rd32(IGC_RAH(i));
 
-		if (!(entry->state & IGC_MAC_STATE_IN_USE))
+		if (!(rah & IGC_RAH_AV))
 			continue;
-		if (!ether_addr_equal(addr, entry->addr))
+		if ((rah & IGC_RAH_RAH_MASK) !=
+		    le16_to_cpup((__le16 *)(addr + 4)))
+			continue;
+		if (ral != le32_to_cpup((__le32 *)(addr)))
 			continue;
 
 		return i;
@@ -2206,14 +2206,15 @@ static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 
 static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
 {
-	int max_entries = adapter->hw.mac.rar_entry_count;
-	struct igc_mac_addr *entry;
+	struct igc_hw *hw = &adapter->hw;
+	int max_entries = hw->mac.rar_entry_count;
+	u32 rah;
 	int i;
 
 	for (i = 0; i < max_entries; i++) {
-		entry = &adapter->mac_table[i];
+		rah = rd32(IGC_RAH(i));
 
-		if (!(entry->state & IGC_MAC_STATE_IN_USE))
+		if (!(rah & IGC_RAH_AV))
 			return i;
 	}
 
@@ -2241,7 +2242,7 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 
 	index = igc_find_mac_filter(adapter, addr);
 	if (index >= 0)
-		goto update_queue_assignment;
+		goto update_filter;
 
 	index = igc_get_avail_mac_filter_slot(adapter);
 	if (index < 0)
@@ -2250,11 +2251,7 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	netdev_dbg(dev, "Add MAC address filter: index %d address %pM queue %d",
 		   index, addr, queue);
 
-	ether_addr_copy(adapter->mac_table[index].addr, addr);
-	adapter->mac_table[index].state |= IGC_MAC_STATE_IN_USE;
-update_queue_assignment:
-	adapter->mac_table[index].queue = queue;
-
+update_filter:
 	igc_set_mac_filter_hw(adapter, index, addr, queue);
 	return 0;
 }
@@ -2269,7 +2266,6 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 {
 	struct net_device *dev = adapter->netdev;
-	struct igc_mac_addr *entry;
 	int index;
 
 	if (!is_valid_ether_addr(addr))
@@ -2279,24 +2275,18 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 	if (index < 0)
 		return -ENOENT;
 
-	entry = &adapter->mac_table[index];
-
-	if (entry->state & IGC_MAC_STATE_DEFAULT) {
+	if (index == 0) {
 		/* If this is the default filter, we don't actually delete it.
 		 * We just reset to its default value i.e. disable queue
 		 * assignment.
 		 */
 		netdev_dbg(dev, "Disable default MAC filter queue assignment");
 
-		entry->queue = -1;
-		igc_set_mac_filter_hw(adapter, 0, addr, entry->queue);
+		igc_set_mac_filter_hw(adapter, 0, addr, -1);
 	} else {
 		netdev_dbg(dev, "Delete MAC address filter: index %d address %pM",
 			   index, addr);
 
-		entry->state = 0;
-		entry->queue = -1;
-		memset(entry->addr, 0, ETH_ALEN);
 		igc_clear_mac_filter_hw(adapter, index);
 	}
 
@@ -3404,8 +3394,6 @@ static int igc_sw_init(struct igc_adapter *adapter)
 	struct pci_dev *pdev = adapter->pdev;
 	struct igc_hw *hw = &adapter->hw;
 
-	int size = sizeof(struct igc_mac_addr) * hw->mac.rar_entry_count;
-
 	pci_read_config_word(pdev, PCI_COMMAND, &hw->bus.pci_cmd_word);
 
 	/* set default ring sizes */
@@ -3429,10 +3417,6 @@ static int igc_sw_init(struct igc_adapter *adapter)
 	/* Assume MSI-X interrupts, will be checked during IRQ allocation */
 	adapter->flags |= IGC_FLAG_HAS_MSIX;
 
-	adapter->mac_table = kzalloc(size, GFP_ATOMIC);
-	if (!adapter->mac_table)
-		return -ENOMEM;
-
 	igc_init_queue_configuration(adapter);
 
 	/* This call may decrease the number of queues */
@@ -5135,7 +5119,6 @@ static void igc_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, adapter->io_addr);
 	pci_release_mem_regions(pdev);
 
-	kfree(adapter->mac_table);
 	free_netdev(netdev);
 
 	pci_disable_pcie_error_reporting(pdev);
-- 
2.26.2

