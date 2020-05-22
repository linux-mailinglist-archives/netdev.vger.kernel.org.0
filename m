Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9340E1DDBCE
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgEVALO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:41697 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730480AbgEVALL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:11 -0400
IronPort-SDR: b7v/KAPWHT220nDm3psHGHkr9AszeKQL0EiyMW4SN9HVfGz4GjW0e8idGc4jjkCbf3PpyWlkUR
 ra6X24WyuCMA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:09 -0700
IronPort-SDR: G87pdJNvHXE1eABO2gENxjAxQ78v2oT9WaWMI+fC4S23NoqQ/rsWXZdrG3p2E6IBr2vQjsovsr
 A1ElDbyzKosg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133932"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 03/15] igc: Add support for source address filters in core
Date:   Thu, 21 May 2020 17:10:56 -0700
Message-Id: <20200522001108.1675149-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch extends MAC address filter internal APIs igc_add_mac_filter()
and igc_del_mac_filter(), as well as local helpers, to support filters
based on source address.

A new parameters 'type' is added to the APIs to indicate if the filter
type is source or destination. In case it is source type, the RAH
register is configured accordingly in igc_set_mac_filter_hw().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         | 13 ++++--
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  6 ++-
 drivers/net/ethernet/intel/igc/igc_main.c    | 49 +++++++++++++-------
 4 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5ce859155396..b501be243536 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -29,6 +29,11 @@ void igc_set_ethtool_ops(struct net_device *);
 #define MAX_ETYPE_FILTER		8
 #define IGC_RETA_SIZE			128
 
+enum igc_mac_filter_type {
+	IGC_MAC_FILTER_TYPE_DST = 0,
+	IGC_MAC_FILTER_TYPE_SRC
+};
+
 struct igc_tx_queue_stats {
 	u64 packets;
 	u64 bytes;
@@ -228,9 +233,11 @@ void igc_write_rss_indir_tbl(struct igc_adapter *adapter);
 bool igc_has_link(struct igc_adapter *adapter);
 void igc_reset(struct igc_adapter *adapter);
 int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx);
-int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const s8 queue);
-int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr);
+int igc_add_mac_filter(struct igc_adapter *adapter,
+		       enum igc_mac_filter_type type, const u8 *addr,
+		       int queue);
+int igc_del_mac_filter(struct igc_adapter *adapter,
+		       enum igc_mac_filter_type type, const u8 *addr);
 int igc_add_vlan_prio_filter(struct igc_adapter *adapter, int prio,
 			     int queue);
 void igc_del_vlan_prio_filter(struct igc_adapter *adapter, int prio);
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index be152a93088a..45b567587ca9 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -63,6 +63,8 @@
  * manageability enabled, allowing us room for 15 multicast addresses.
  */
 #define IGC_RAH_RAH_MASK	0x0000FFFF
+#define IGC_RAH_ASEL_MASK	0x00030000
+#define IGC_RAH_ASEL_SRC_ADDR	BIT(16)
 #define IGC_RAH_QSEL_MASK	0x000C0000
 #define IGC_RAH_QSEL_SHIFT	18
 #define IGC_RAH_QSEL_ENABLE	BIT(28)
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 09d0305a5902..6c27046a852d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1207,7 +1207,8 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 	}
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
-		err = igc_add_mac_filter(adapter, input->filter.dst_addr,
+		err = igc_add_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST,
+					 input->filter.dst_addr,
 					 input->action);
 		if (err)
 			return err;
@@ -1239,7 +1240,8 @@ int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 	}
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR)
-		igc_del_mac_filter(adapter, input->filter.dst_addr);
+		igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST,
+				   input->filter.dst_addr);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index af3092813a06..398a9307af2b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -766,12 +766,14 @@ static void igc_setup_tctl(struct igc_adapter *adapter)
  * igc_set_mac_filter_hw() - Set MAC address filter in hardware
  * @adapter: Pointer to adapter where the filter should be set
  * @index: Filter index
- * @addr: Destination MAC address
+ * @type: MAC address filter type (source or destination)
+ * @addr: MAC address
  * @queue: If non-negative, queue assignment feature is enabled and frames
  *         matching the filter are enqueued onto 'queue'. Otherwise, queue
  *         assignment is disabled.
  */
 static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
+				  enum igc_mac_filter_type type,
 				  const u8 *addr, int queue)
 {
 	struct net_device *dev = adapter->netdev;
@@ -784,6 +786,11 @@ static void igc_set_mac_filter_hw(struct igc_adapter *adapter, int index,
 	ral = le32_to_cpup((__le32 *)(addr));
 	rah = le16_to_cpup((__le16 *)(addr + 4));
 
+	if (type == IGC_MAC_FILTER_TYPE_SRC) {
+		rah &= ~IGC_RAH_ASEL_MASK;
+		rah |= IGC_RAH_ASEL_SRC_ADDR;
+	}
+
 	if (queue >= 0) {
 		rah &= ~IGC_RAH_QSEL_MASK;
 		rah |= (queue << IGC_RAH_QSEL_SHIFT);
@@ -825,7 +832,7 @@ static void igc_set_default_mac_filter(struct igc_adapter *adapter)
 
 	netdev_dbg(dev, "Set default MAC address filter: address %pM", addr);
 
-	igc_set_mac_filter_hw(adapter, 0, addr, -1);
+	igc_set_mac_filter_hw(adapter, 0, IGC_MAC_FILTER_TYPE_DST, addr, -1);
 }
 
 /**
@@ -2179,7 +2186,8 @@ static void igc_nfc_filter_restore(struct igc_adapter *adapter)
 	spin_unlock(&adapter->nfc_lock);
 }
 
-static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr)
+static int igc_find_mac_filter(struct igc_adapter *adapter,
+			       enum igc_mac_filter_type type, const u8 *addr)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int max_entries = hw->mac.rar_entry_count;
@@ -2192,6 +2200,8 @@ static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 
 		if (!(rah & IGC_RAH_AV))
 			continue;
+		if (!!(rah & IGC_RAH_ASEL_SRC_ADDR) != type)
+			continue;
 		if ((rah & IGC_RAH_RAH_MASK) !=
 		    le16_to_cpup((__le16 *)(addr + 4)))
 			continue;
@@ -2224,6 +2234,7 @@ static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
 /**
  * igc_add_mac_filter() - Add MAC address filter
  * @adapter: Pointer to adapter where the filter should be added
+ * @type: MAC address filter type (source or destination)
  * @addr: MAC address
  * @queue: If non-negative, queue assignment feature is enabled and frames
  *         matching the filter are enqueued onto 'queue'. Otherwise, queue
@@ -2231,8 +2242,9 @@ static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
-int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const s8 queue)
+int igc_add_mac_filter(struct igc_adapter *adapter,
+		       enum igc_mac_filter_type type, const u8 *addr,
+		       int queue)
 {
 	struct net_device *dev = adapter->netdev;
 	int index;
@@ -2240,7 +2252,7 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
-	index = igc_find_mac_filter(adapter, addr);
+	index = igc_find_mac_filter(adapter, type, addr);
 	if (index >= 0)
 		goto update_filter;
 
@@ -2248,22 +2260,25 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	if (index < 0)
 		return -ENOSPC;
 
-	netdev_dbg(dev, "Add MAC address filter: index %d address %pM queue %d",
-		   index, addr, queue);
+	netdev_dbg(dev, "Add MAC address filter: index %d type %s address %pM queue %d\n",
+		   index, type == IGC_MAC_FILTER_TYPE_DST ? "dst" : "src",
+		   addr, queue);
 
 update_filter:
-	igc_set_mac_filter_hw(adapter, index, addr, queue);
+	igc_set_mac_filter_hw(adapter, index, type, addr, queue);
 	return 0;
 }
 
 /**
  * igc_del_mac_filter() - Delete MAC address filter
  * @adapter: Pointer to adapter where the filter should be deleted from
+ * @type: MAC address filter type (source or destination)
  * @addr: MAC address
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
-int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
+int igc_del_mac_filter(struct igc_adapter *adapter,
+		       enum igc_mac_filter_type type, const u8 *addr)
 {
 	struct net_device *dev = adapter->netdev;
 	int index;
@@ -2271,7 +2286,7 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
-	index = igc_find_mac_filter(adapter, addr);
+	index = igc_find_mac_filter(adapter, type, addr);
 	if (index < 0)
 		return -ENOENT;
 
@@ -2282,10 +2297,12 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 		 */
 		netdev_dbg(dev, "Disable default MAC filter queue assignment");
 
-		igc_set_mac_filter_hw(adapter, 0, addr, -1);
+		igc_set_mac_filter_hw(adapter, 0, type, addr, -1);
 	} else {
-		netdev_dbg(dev, "Delete MAC address filter: index %d address %pM",
-			   index, addr);
+		netdev_dbg(dev, "Delete MAC address filter: index %d type %s address %pM\n",
+			   index,
+			   type == IGC_MAC_FILTER_TYPE_DST ? "dst" : "src",
+			   addr);
 
 		igc_clear_mac_filter_hw(adapter, index);
 	}
@@ -2442,14 +2459,14 @@ static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_add_mac_filter(adapter, addr, -1);
+	return igc_add_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST, addr, -1);
 }
 
 static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_del_mac_filter(adapter, addr);
+	return igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST, addr);
 }
 
 /**
-- 
2.26.2

