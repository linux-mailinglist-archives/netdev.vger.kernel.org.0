Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6CA1AFDD5
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDSTvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:45115 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgDSTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:35 -0400
IronPort-SDR: CkzH3hhVHBqlYZFP9BSUvPDmsRNedE4ICKO9GLvVvEuWQaTFwgQiHKIXQ80MeZQ2XfY9t8SdOA
 joj5xf6SF5Eg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:34 -0700
IronPort-SDR: 6XrDebeurseWPysTIhIpWbwQ3m2hQrtljdfPZltzrxSvCH3R5Sm2xDKsTZKgYDyGGDOh+p8Iqn
 0uU/218mZaqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034422"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/14] igc: Remove 'queue' check in igc_del_mac_filter()
Date:   Sun, 19 Apr 2020 12:51:26 -0700
Message-Id: <20200419195131.1068144-10-jeffrey.t.kirsher@intel.com>
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

igc_add_mac_filter() doesn't allow us to have more than one entry with
the same address and address type in adapter->mac_table so checking if
'queue' matches in igc_del_mac_filter() isn't necessary. This patch
removes that check.

This patch also takes the opportunity to improve the igc_del_mac_filter
documentation and remove comment which is not applicable to this I225
controller.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 25 ++++++++++-------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 070df92bb4e9..badb8ecf38dc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2233,14 +2233,17 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	return -ENOSPC;
 }
 
-/* Remove a MAC filter for 'addr' directing matching traffic to
- * 'queue', 'flags' is used to indicate what kind of match need to be
- * removed, match is by default for the destination address, if
- * matching by source address is to be removed the flag
- * IGC_MAC_STATE_SRC_ADDR can be used.
+/**
+ * igc_del_mac_filter() - Delete MAC address filter
+ * @adapter: Pointer to adapter where the filter should be deleted from
+ * @addr: MAC address
+ * @flags: Set IGC_MAC_STATE_SRC_ADDR bit to indicate @address is a source
+ *         address
+ *
+ * Return: 0 in case of success, negative errno code otherwise.
  */
 static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-			      const u8 queue, const u8 flags)
+			      const u8 flags)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int rar_entries = hw->mac.rar_entry_count;
@@ -2249,17 +2252,11 @@ static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
-	/* Search for matching entry in the MAC table based on given address
-	 * and queue. Do not touch entries at the end of the table reserved
-	 * for the VF MAC addresses.
-	 */
 	for (i = 0; i < rar_entries; i++) {
 		if (!(adapter->mac_table[i].state & IGC_MAC_STATE_IN_USE))
 			continue;
 		if (flags && (adapter->mac_table[i].state & flags) != flags)
 			continue;
-		if (adapter->mac_table[i].queue != queue)
-			continue;
 		if (!ether_addr_equal(adapter->mac_table[i].addr, addr))
 			continue;
 
@@ -2295,7 +2292,7 @@ static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_del_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
+	return igc_del_mac_filter(adapter, addr, 0);
 }
 
 /**
@@ -3738,7 +3735,7 @@ int igc_add_mac_steering_filter(struct igc_adapter *adapter,
 int igc_del_mac_steering_filter(struct igc_adapter *adapter,
 				const u8 *addr, u8 queue, u8 flags)
 {
-	return igc_del_mac_filter(adapter, addr, queue,
+	return igc_del_mac_filter(adapter, addr,
 				  IGC_MAC_STATE_QUEUE_STEERING | flags);
 }
 
-- 
2.25.2

