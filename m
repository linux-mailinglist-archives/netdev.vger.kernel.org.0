Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F245D1AFDD3
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgDSTvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgDSTvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:36 -0400
IronPort-SDR: a6BLZECDU5a1GxxEVunHaVhtvGe9BSrXCeigQBghHi/x7TmIgKEnVrm4jQ8UQ35gY/eiVqHlf1
 IVKJnIwdhonQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:35 -0700
IronPort-SDR: ShuOSAPzYKxU6fHEpx59BgMMYJeMnQvsCF9SkZxt+27u9JMVmBzNuCh6HVS2R/JXQ69FkSwTxj
 wf09Q+XXiKYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034435"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] igc: Refactor igc_del_mac_filter()
Date:   Sun, 19 Apr 2020 12:51:30 -0700
Message-Id: <20200419195131.1068144-14-jeffrey.t.kirsher@intel.com>
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

This patch does a code refactoring in igc_del_mac_filter() so it uses
the new helper igc_find_mac_filter() and improves the comment about the
special handling when deleting the default filter.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 45 ++++++++++-------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 79a9875e0767..78753f12b8a0 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2267,40 +2267,33 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const u8 flags)
 {
-	struct igc_hw *hw = &adapter->hw;
-	int rar_entries = hw->mac.rar_entry_count;
-	int i;
+	struct igc_mac_addr *entry;
+	int index;
 
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
-	for (i = 0; i < rar_entries; i++) {
-		if (!(adapter->mac_table[i].state & IGC_MAC_STATE_IN_USE))
-			continue;
-		if (flags && (adapter->mac_table[i].state & flags) != flags)
-			continue;
-		if (!ether_addr_equal(adapter->mac_table[i].addr, addr))
-			continue;
+	index = igc_find_mac_filter(adapter, addr, flags);
+	if (index < 0)
+		return -ENOENT;
 
-		/* When a filter for the default address is "deleted",
-		 * we return it to its initial configuration
-		 */
-		if (adapter->mac_table[i].state & IGC_MAC_STATE_DEFAULT) {
-			adapter->mac_table[i].state =
-				IGC_MAC_STATE_DEFAULT | IGC_MAC_STATE_IN_USE;
-			adapter->mac_table[i].queue = -1;
-			igc_set_mac_filter_hw(adapter, 0, addr, -1);
-		} else {
-			adapter->mac_table[i].state = 0;
-			adapter->mac_table[i].queue = -1;
-			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
-			igc_clear_mac_filter_hw(adapter, i);
-		}
+	entry = &adapter->mac_table[index];
 
-		return 0;
+	if (entry->state & IGC_MAC_STATE_DEFAULT) {
+		/* If this is the default filter, we don't actually delete it.
+		 * We just reset to its default value i.e. disable queue
+		 * assignment.
+		 */
+		entry->queue = -1;
+		igc_set_mac_filter_hw(adapter, 0, addr, entry->queue);
+	} else {
+		entry->state = 0;
+		entry->queue = -1;
+		memset(entry->addr, 0, ETH_ALEN);
+		igc_clear_mac_filter_hw(adapter, index);
 	}
 
-	return -ENOENT;
+	return 0;
 }
 
 static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
-- 
2.25.2

