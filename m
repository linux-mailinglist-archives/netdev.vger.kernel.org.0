Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855671AFDD0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDSTvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:45114 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgDSTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:35 -0400
IronPort-SDR: hMRwyo3H7qWLN1iY421zrNs3ENXn1KXvsrcMLcOdeA8sgvdMJ2F8NN3H2U0hsjqNztKp+oGVSN
 JIx6qY3okfRw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:35 -0700
IronPort-SDR: ssBaDtr7hn8UIx5dinkffaraXHEyRcfA/BAh3ARjqYTHH7o9p0r1yEH9WBh4+lF3NeZcCHxDIS
 6QmeDBO/wjoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034428"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/14] igc: Remove igc_*_mac_steering_filter() wrappers
Date:   Sun, 19 Apr 2020 12:51:28 -0700
Message-Id: <20200419195131.1068144-12-jeffrey.t.kirsher@intel.com>
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

With the previous two patches, igc_add_mac_steering_filter() and
igc_del_mac_steering_filter() became a pointless wrapper of
igc_add_mac_filter() and igc_del_mac_filter().

This patch removes these wrappers and update callers to call
igc_add_mac_filter() and igc_del_mac_filter() directly.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  8 ++++----
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 20 ++++++++------------
 drivers/net/ethernet/intel/igc/igc_main.c    | 20 ++++----------------
 3 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 8d5ebe2103ee..8ddc39482a8e 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -227,10 +227,10 @@ void igc_write_rss_indir_tbl(struct igc_adapter *adapter);
 bool igc_has_link(struct igc_adapter *adapter);
 void igc_reset(struct igc_adapter *adapter);
 int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx);
-int igc_add_mac_steering_filter(struct igc_adapter *adapter,
-				const u8 *addr, u8 queue, u8 flags);
-int igc_del_mac_steering_filter(struct igc_adapter *adapter,
-				const u8 *addr, u8 queue, u8 flags);
+int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+		       const s8 queue, const u8 flags);
+int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+		       const u8 flags);
 void igc_update_stats(struct igc_adapter *adapter);
 
 /* igc_dump declarations */
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index c9f4552c018b..0a8c4a7412a4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1266,18 +1266,16 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 	}
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
-		err = igc_add_mac_steering_filter(adapter,
-						  input->filter.dst_addr,
-						  input->action, 0);
+		err = igc_add_mac_filter(adapter, input->filter.dst_addr,
+					 input->action, 0);
 		if (err)
 			return err;
 	}
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
-		err = igc_add_mac_steering_filter(adapter,
-						  input->filter.src_addr,
-						  input->action,
-						  IGC_MAC_STATE_SRC_ADDR);
+		err = igc_add_mac_filter(adapter, input->filter.src_addr,
+					 input->action,
+					 IGC_MAC_STATE_SRC_ADDR);
 		if (err)
 			return err;
 	}
@@ -1331,13 +1329,11 @@ int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 					   ntohs(input->filter.vlan_tci));
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR)
-		igc_del_mac_steering_filter(adapter, input->filter.src_addr,
-					    input->action,
-					    IGC_MAC_STATE_SRC_ADDR);
+		igc_del_mac_filter(adapter, input->filter.src_addr,
+				   IGC_MAC_STATE_SRC_ADDR);
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR)
-		igc_del_mac_steering_filter(adapter, input->filter.dst_addr,
-					    input->action, 0);
+		igc_del_mac_filter(adapter, input->filter.dst_addr, 0);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e195400cd490..3af6ce1712d5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2209,8 +2209,8 @@ static bool igc_mac_entry_can_be_used(const struct igc_mac_addr *entry,
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
-static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-			      const s8 queue, const u8 flags)
+int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+		       const s8 queue, const u8 flags)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int rar_entries = hw->mac.rar_entry_count;
@@ -2250,8 +2250,8 @@ static int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
  *
  * Return: 0 in case of success, negative errno code otherwise.
  */
-static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
-			      const u8 flags)
+int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
+		       const u8 flags)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int rar_entries = hw->mac.rar_entry_count;
@@ -3733,18 +3733,6 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	return features;
 }
 
-int igc_add_mac_steering_filter(struct igc_adapter *adapter,
-				const u8 *addr, u8 queue, u8 flags)
-{
-	return igc_add_mac_filter(adapter, addr, queue, flags);
-}
-
-int igc_del_mac_steering_filter(struct igc_adapter *adapter,
-				const u8 *addr, u8 queue, u8 flags)
-{
-	return igc_del_mac_filter(adapter, addr, flags);
-}
-
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-- 
2.25.2

