Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F271DC79F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEUH2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:34923 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgEUH2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:01 -0400
IronPort-SDR: 43jOMgkwXIYDF0kxiWNUse5bI7beVKYYPJQnkAF6mtm7M11bMkkjoFhUJZA0TnWF280dViJ3Z8
 yT5OT1H1CCQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:01 -0700
IronPort-SDR: 0tVgT5Fwy4OzyRagHtcgY3IvF4lAs44hPHslf+EZf2NXeCofHlQ3EESkQeNTJ8Wqjg9B9CYwAx
 VkeMeLjDB/5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758679"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:27:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] igc: Remove IGC_MAC_STATE_SRC_ADDR flag
Date:   Thu, 21 May 2020 00:27:44 -0700
Message-Id: <20200521072758.440264-2-jeffrey.t.kirsher@intel.com>
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

MAC address filters based on source address are not currently supported
by the IGC driver. Despite of that, the driver have some dangling code
to handle it, inherited from IGB driver. This patch removes that code to
prepare for a follow up patch that adds proper source MAC address filter
support.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  6 ++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 16 ++----------
 drivers/net/ethernet/intel/igc/igc_main.c    | 27 ++++++--------------
 3 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 812e1cd695cf..885998d3f62e 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -231,9 +231,8 @@ bool igc_has_link(struct igc_adapter *adapter);
 void igc_reset(struct igc_adapter *adapter);
 int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx);
 int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const s8 queue, const u8 flags);
-int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const u8 flags);
+		       const s8 queue);
+int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr);
 int igc_add_vlan_prio_filter(struct igc_adapter *adapter, int prio,
 			     int queue);
 void igc_del_vlan_prio_filter(struct igc_adapter *adapter, int prio);
@@ -479,7 +478,6 @@ struct igc_mac_addr {
 
 #define IGC_MAC_STATE_DEFAULT		0x1
 #define IGC_MAC_STATE_IN_USE		0x2
-#define IGC_MAC_STATE_SRC_ADDR		0x4
 
 #define IGC_MAX_RXNFC_FILTERS		16
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index c6586e2be3a8..09d0305a5902 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1208,15 +1208,7 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
 		err = igc_add_mac_filter(adapter, input->filter.dst_addr,
-					 input->action, 0);
-		if (err)
-			return err;
-	}
-
-	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
-		err = igc_add_mac_filter(adapter, input->filter.src_addr,
-					 input->action,
-					 IGC_MAC_STATE_SRC_ADDR);
+					 input->action);
 		if (err)
 			return err;
 	}
@@ -1246,12 +1238,8 @@ int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 		igc_del_vlan_prio_filter(adapter, prio);
 	}
 
-	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR)
-		igc_del_mac_filter(adapter, input->filter.src_addr,
-				   IGC_MAC_STATE_SRC_ADDR);
-
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR)
-		igc_del_mac_filter(adapter, input->filter.dst_addr, 0);
+		igc_del_mac_filter(adapter, input->filter.dst_addr);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0df5617eb9d0..3242136bb47a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2184,8 +2184,7 @@ static void igc_nfc_filter_restore(struct igc_adapter *adapter)
 	spin_unlock(&adapter->nfc_lock);
 }
 
-static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-			       u8 flags)
+static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 {
 	int max_entries = adapter->hw.mac.rar_entry_count;
 	struct igc_mac_addr *entry;
@@ -2198,9 +2197,6 @@ static int igc_find_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 			continue;
 		if (!ether_addr_equal(addr, entry->addr))
 			continue;
-		if ((entry->state & IGC_MAC_STATE_SRC_ADDR) !=
-		    (flags & IGC_MAC_STATE_SRC_ADDR))
-			continue;
 
 		return i;
 	}
@@ -2231,23 +2227,19 @@ static int igc_get_avail_mac_filter_slot(struct igc_adapter *adapter)
  * @queue: If non-negative, queue assignment feature is enabled and frames
  *         matching the filter are enqueued onto 'queue'. Otherwise, queue
  *         assignment is disabled.
- * @flags: Set IGC_MAC_STATE_SRC_ADDR bit to indicate @address is a source
- *         address
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
 int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const s8 queue, const u8 flags)
+		       const s8 queue)
 {
 	struct net_device *dev = adapter->netdev;
 	int index;
 
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
-	if (flags & IGC_MAC_STATE_SRC_ADDR)
-		return -ENOTSUPP;
 
-	index = igc_find_mac_filter(adapter, addr, flags);
+	index = igc_find_mac_filter(adapter, addr);
 	if (index >= 0)
 		goto update_queue_assignment;
 
@@ -2259,7 +2251,7 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		   index, addr, queue);
 
 	ether_addr_copy(adapter->mac_table[index].addr, addr);
-	adapter->mac_table[index].state |= IGC_MAC_STATE_IN_USE | flags;
+	adapter->mac_table[index].state |= IGC_MAC_STATE_IN_USE;
 update_queue_assignment:
 	adapter->mac_table[index].queue = queue;
 
@@ -2271,13 +2263,10 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
  * igc_del_mac_filter() - Delete MAC address filter
  * @adapter: Pointer to adapter where the filter should be deleted from
  * @addr: MAC address
- * @flags: Set IGC_MAC_STATE_SRC_ADDR bit to indicate @address is a source
- *         address
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
-int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-		       const u8 flags)
+int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr)
 {
 	struct net_device *dev = adapter->netdev;
 	struct igc_mac_addr *entry;
@@ -2286,7 +2275,7 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
-	index = igc_find_mac_filter(adapter, addr, flags);
+	index = igc_find_mac_filter(adapter, addr);
 	if (index < 0)
 		return -ENOENT;
 
@@ -2463,14 +2452,14 @@ static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_add_mac_filter(adapter, addr, -1, 0);
+	return igc_add_mac_filter(adapter, addr, -1);
 }
 
 static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_del_mac_filter(adapter, addr, 0);
+	return igc_del_mac_filter(adapter, addr);
 }
 
 /**
-- 
2.26.2

