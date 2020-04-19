Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDD81AFDD2
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgDSTvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:45114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgDSTvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:36 -0400
IronPort-SDR: woTk75lTOLPGNKnHx0tJp00vThKp/Nho0laEcrFVRLahyqNPpQmDblJIC76U5z3v29kCeAGkCN
 tZwv3SioDRFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:35 -0700
IronPort-SDR: KI0Dhc50jUrJb2u2qDAT9TUEnRA/ufNZUE3usdIPxnFPLtF0qtN63Ac6r93liRaT6Zdy64ISjD
 vk6IRa/J8oNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034437"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/14] igc: Add debug messages to MAC filter code
Date:   Sun, 19 Apr 2020 12:51:31 -0700
Message-Id: <20200419195131.1068144-15-jeffrey.t.kirsher@intel.com>
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

This patch adds log messages to functions related to the MAC address
filtering code to ease debugging.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 24 +++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 78753f12b8a0..9d5f8287c704 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -776,6 +776,7 @@ static void igc_setup_tctl(struct igc_adapter *adapter)
 static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
 				  const u8 *addr, int queue)
 {
+	struct net_device *dev = adapter->netdev;
 	struct igc_hw *hw = &adapter->hw;
 	u32 ral, rah;
 
@@ -795,6 +796,8 @@ static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
 
 	wr32(IGC_RAL(index), ral);
 	wr32(IGC_RAH(index), rah);
+
+	netdev_dbg(dev, "MAC address filter set in HW: index %d", index);
 }
 
 /**
@@ -804,6 +807,7 @@ static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
  */
 static void igc_clear_mac_filter_hw(struct igc_adapter *adapter, int index)
 {
+	struct net_device *dev = adapter->netdev;
 	struct igc_hw *hw = &adapter->hw;
 
 	if (WARN_ON(index >= hw->mac.rar_entry_count))
@@ -811,18 +815,24 @@ static void igc_clear_mac_filter_hw(struct igc_adapter *adapter, int index)
 
 	wr32(IGC_RAL(index), 0);
 	wr32(IGC_RAH(index), 0);
+
+	netdev_dbg(dev, "MAC address filter cleared in HW: index %d", index);
 }
 
 /* Set default MAC address for the PF in the first RAR entry */
 static void igc_set_default_mac_filter(struct igc_adapter *adapter)
 {
 	struct igc_mac_addr *mac_table = &adapter->mac_table[0];
+	struct net_device *dev = adapter->netdev;
+	u8 *addr = adapter->hw.mac.addr;
+
+	netdev_dbg(dev, "Set default MAC address filter: address %pM", addr);
 
-	ether_addr_copy(mac_table->addr, adapter->hw.mac.addr);
+	ether_addr_copy(mac_table->addr, addr);
 	mac_table->state = IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
 	mac_table->queue = -1;
 
-	igc_set_mac_filter_hw(adapter, 0, mac_table->addr, mac_table->queue);
+	igc_set_mac_filter_hw(adapter, 0, addr, mac_table->queue);
 }
 
 /**
@@ -2231,6 +2241,7 @@ static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
 int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const s8 queue, const u8 flags)
 {
+	struct net_device *dev = adapter->netdev;
 	int index;
 
 	if (!is_valid_ether_addr(addr))
@@ -2246,6 +2257,9 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	if (index < 0)
 		return -ENOSPC;
 
+	netdev_dbg(dev, "Add MAC address filter: index %d address %pM queue %d",
+		   index, addr, queue);
+
 	ether_addr_copy(adapter->mac_table[index].addr, addr);
 	adapter->mac_table[index].state |= IGC_MAC_STATE_IN_USE | flags;
 update_queue_assignment:
@@ -2267,6 +2281,7 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const u8 flags)
 {
+	struct net_device *dev = adapter->netdev;
 	struct igc_mac_addr *entry;
 	int index;
 
@@ -2284,9 +2299,14 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		 * We just reset to its default value i.e. disable queue
 		 * assignment.
 		 */
+		netdev_dbg(dev, "Disable default MAC filter queue assignment");
+
 		entry->queue = -1;
 		igc_set_mac_filter_hw(adapter, 0, addr, entry->queue);
 	} else {
+		netdev_dbg(dev, "Delete MAC address filter: index %d address %pM",
+			   index, addr);
+
 		entry->state = 0;
 		entry->queue = -1;
 		memset(entry->addr, 0, ETH_ALEN);
-- 
2.25.2

