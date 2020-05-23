Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCA1DF438
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbgEWCvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387569AbgEWCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:17 -0400
IronPort-SDR: hA1qx2eTolasJEHxWqBGHLGVAYTxPXXguUdU8KXPkd1ModU6OhALgyYNgPOEAXtlQb+9wjLWFv
 6pzVTie5fSrQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:13 -0700
IronPort-SDR: l1mmRAbXixWeOAyrMElthLFvf6thQt67x0SAgAEjWr7N0lQVU3ZxtcUHSAWqNglP+ByY1lIAdR
 sunY0mWrUjvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291111"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/17] igc: Change return type from igc_disable_nfc_rule()
Date:   Fri, 22 May 2020 19:51:02 -0700
Message-Id: <20200523025109.3313635-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

None of igc_disable_nfc_rule() callers actually check its returning
value. A closer look at why this function would fail shows that the
only situation is when we try to delete an Ethertype or MAC filter that
doesn't exist.

That situation is very unlikely so we can change igc_del_etype_filter()
and igc_del_mac_filter() logic to "if the filter doesn't exist, we are
done", and keep the logic in igc_disable_nfc_rule() callers simple.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 26 ++++++++---------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0a6f880e3538..9338209cedf2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2259,18 +2259,16 @@ static int igc_add_mac_filter(struct igc_adapter *adapter,
  * @adapter: Pointer to adapter where the filter should be deleted from
  * @type: MAC address filter type (source or destination)
  * @addr: MAC address
- *
- * Return: 0 in case of success, negative errno code otherwise.
  */
-static int igc_del_mac_filter(struct igc_adapter *adapter,
-			      enum igc_mac_filter_type type, const u8 *addr)
+static void igc_del_mac_filter(struct igc_adapter *adapter,
+			       enum igc_mac_filter_type type, const u8 *addr)
 {
 	struct net_device *dev = adapter->netdev;
 	int index;
 
 	index = igc_find_mac_filter(adapter, type, addr);
 	if (index < 0)
-		return -ENOENT;
+		return;
 
 	if (index == 0) {
 		/* If this is the default filter, we don't actually delete it.
@@ -2288,8 +2286,6 @@ static int igc_del_mac_filter(struct igc_adapter *adapter,
 
 		igc_clear_mac_filter_hw(adapter, index);
 	}
-
-	return 0;
 }
 
 /**
@@ -2420,23 +2416,20 @@ static int igc_find_etype_filter(struct igc_adapter *adapter, u16 etype)
  * igc_del_etype_filter() - Delete ethertype filter
  * @adapter: Pointer to adapter where the filter should be deleted from
  * @etype: Ethertype value
- *
- * Return: 0 in case of success, negative errno code otherwise.
  */
-static int igc_del_etype_filter(struct igc_adapter *adapter, u16 etype)
+static void igc_del_etype_filter(struct igc_adapter *adapter, u16 etype)
 {
 	struct igc_hw *hw = &adapter->hw;
 	int index;
 
 	index = igc_find_etype_filter(adapter, etype);
 	if (index < 0)
-		return -ENOENT;
+		return;
 
 	wr32(IGC_ETQF(index), 0);
 
 	netdev_dbg(adapter->netdev, "Delete ethertype filter: etype %04x\n",
 		   etype);
-	return 0;
 }
 
 static int igc_enable_nfc_rule(struct igc_adapter *adapter,
@@ -2477,8 +2470,8 @@ static int igc_enable_nfc_rule(struct igc_adapter *adapter,
 	return 0;
 }
 
-static int igc_disable_nfc_rule(struct igc_adapter *adapter,
-				const struct igc_nfc_rule *rule)
+static void igc_disable_nfc_rule(struct igc_adapter *adapter,
+				 const struct igc_nfc_rule *rule)
 {
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE)
 		igc_del_etype_filter(adapter, rule->filter.etype);
@@ -2497,8 +2490,6 @@ static int igc_disable_nfc_rule(struct igc_adapter *adapter,
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR)
 		igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST,
 				   rule->filter.dst_addr);
-
-	return 0;
 }
 
 /**
@@ -2623,7 +2614,8 @@ static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	return igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST, addr);
+	igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST, addr);
+	return 0;
 }
 
 /**
-- 
2.26.2

