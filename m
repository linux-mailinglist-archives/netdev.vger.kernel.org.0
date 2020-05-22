Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250241DDBCD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbgEVALN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:41703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730172AbgEVALM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:12 -0400
IronPort-SDR: VbUda8bVf6vm7qA7i0ZOmz5Nj/PLWkVWvyS+KR6evdzk0F1lvredTc4xmE7DzdjYrwIwM0ktpZ
 mKJ3qlYqKnyQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:10 -0700
IronPort-SDR: z4hPdPw7e4hKkI6MWBLByc+8/wL527B7AGOxZFQSMYSM9+ssCfENMHxC9q6vZRibV/S2oLiFFl
 8H2G9jH21V1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133935"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 04/15] igc: Enable NFC rules based source MAC address
Date:   Thu, 21 May 2020 17:10:57 -0700
Message-Id: <20200522001108.1675149-5-jeffrey.t.kirsher@intel.com>
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

This patch adds support for Network Flow Classification (NFC) rules
based on source MAC address. Note that the controller doesn't support
rules with both source and destination addresses set, so this special
case is checked in igc_add_ethtool_nfc_entry().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 32 ++++++++++++++------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 6c27046a852d..42ecb493c1a2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1188,16 +1188,8 @@ static int igc_set_rss_hash_opt(struct igc_adapter *adapter,
 
 int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 {
-	struct igc_hw *hw = &adapter->hw;
 	int err = -EINVAL;
 
-	if (hw->mac.type == igc_i225 &&
-	    !(input->filter.match_flags & ~IGC_FILTER_FLAG_SRC_MAC_ADDR)) {
-		netdev_err(adapter->netdev,
-			   "i225 doesn't support flow classification rules specifying only source addresses\n");
-		return -EOPNOTSUPP;
-	}
-
 	if (input->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
 		u16 etype = ntohs(input->filter.etype);
 
@@ -1206,6 +1198,14 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 			return err;
 	}
 
+	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
+		err = igc_add_mac_filter(adapter, IGC_MAC_FILTER_TYPE_SRC,
+					 input->filter.src_addr,
+					 input->action);
+		if (err)
+			return err;
+	}
+
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
 		err = igc_add_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST,
 					 input->filter.dst_addr,
@@ -1239,6 +1239,10 @@ int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 		igc_del_vlan_prio_filter(adapter, prio);
 	}
 
+	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR)
+		igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_SRC,
+				   input->filter.src_addr);
+
 	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR)
 		igc_del_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST,
 				   input->filter.dst_addr);
@@ -1334,20 +1338,28 @@ static int igc_add_ethtool_nfc_entry(struct igc_adapter *adapter,
 		input->filter.match_flags = IGC_FILTER_FLAG_ETHER_TYPE;
 	}
 
-	/* Only support matching addresses by the full mask */
+	/* Both source and destination address filters only support the full
+	 * mask.
+	 */
 	if (is_broadcast_ether_addr(fsp->m_u.ether_spec.h_source)) {
 		input->filter.match_flags |= IGC_FILTER_FLAG_SRC_MAC_ADDR;
 		ether_addr_copy(input->filter.src_addr,
 				fsp->h_u.ether_spec.h_source);
 	}
 
-	/* Only support matching addresses by the full mask */
 	if (is_broadcast_ether_addr(fsp->m_u.ether_spec.h_dest)) {
 		input->filter.match_flags |= IGC_FILTER_FLAG_DST_MAC_ADDR;
 		ether_addr_copy(input->filter.dst_addr,
 				fsp->h_u.ether_spec.h_dest);
 	}
 
+	if (input->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR &&
+	    input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
+		netdev_dbg(netdev, "Filters with both dst and src are not supported\n");
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	if ((fsp->flow_type & FLOW_EXT) && fsp->m_ext.vlan_tci) {
 		if (fsp->m_ext.vlan_tci != htons(VLAN_PRIO_MASK)) {
 			netdev_dbg(netdev, "VLAN mask not supported\n");
-- 
2.26.2

