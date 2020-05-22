Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2151DDBD5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgEVALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:41703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbgEVALR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:17 -0400
IronPort-SDR: D7CRFDzF1j+BVPDz9e6YicomUdozs7ZhqU2ARVhfPQudByR7ugyqUfK4gYGGH4cyHPNIEE+ojT
 oz4hzzxninnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:12 -0700
IronPort-SDR: l2mllvsuEkbUDdFMdOKQi1BYxAbLYW2bd1dFiir1dc7h+XfCuOhzuOaRmZFF5TDfp/OaFKYqAq
 Lm9jXudpLxjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133972"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 15/15] igc: Change byte order in struct igc_nfc_filter
Date:   Thu, 21 May 2020 17:11:08 -0700
Message-Id: <20200522001108.1675149-16-jeffrey.t.kirsher@intel.com>
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

Every time we access the 'etype' and 'vlan_tci' fields from struct
igc_nfc_filter to enable or disable filters in hardware we have to
convert them from big endian to host order so it makes more sense to
simply have these fields in host order.

The byte order conversion should take place in igc_ethtool_get_nfc_
rule() and igc_ethtool_add_nfc_rule(), which are called by .get_rxnfc
and .set_rxnfc ethtool ops, since ethtool subsystem is the one who deals
with them in big endian order.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         | 10 ++------
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 25 +++++++++-----------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 7124ba254b89..fcc6261d7f67 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -452,16 +452,10 @@ enum igc_filter_match_flags {
 	IGC_FILTER_FLAG_DST_MAC_ADDR =	0x8,
 };
 
-/* RX network flow classification data structure */
 struct igc_nfc_filter {
-	/* Byte layout in order, all values with MSB first:
-	 * match_flags - 1 byte
-	 * etype - 2 bytes
-	 * vlan_tci - 2 bytes
-	 */
 	u8 match_flags;
-	__be16 etype;
-	__be16 vlan_tci;
+	u16 etype;
+	u16 vlan_tci;
 	u8 src_addr[ETH_ALEN];
 	u8 dst_addr[ETH_ALEN];
 };
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 408f4a9a199f..66e0760a8f9e 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -954,13 +954,13 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 	fsp->ring_cookie = rule->action;
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
-		fsp->h_u.ether_spec.h_proto = rule->filter.etype;
+		fsp->h_u.ether_spec.h_proto = htons(rule->filter.etype);
 		fsp->m_u.ether_spec.h_proto = ETHER_TYPE_FULL_MASK;
 	}
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
 		fsp->flow_type |= FLOW_EXT;
-		fsp->h_ext.vlan_tci = rule->filter.vlan_tci;
+		fsp->h_ext.vlan_tci = htons(rule->filter.vlan_tci);
 		fsp->m_ext.vlan_tci = htons(VLAN_PRIO_MASK);
 	}
 
@@ -1183,9 +1183,8 @@ int igc_enable_nfc_rule(struct igc_adapter *adapter,
 	int err = -EINVAL;
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
-		u16 etype = ntohs(rule->filter.etype);
-
-		err = igc_add_etype_filter(adapter, etype, rule->action);
+		err = igc_add_etype_filter(adapter, rule->filter.etype,
+					   rule->action);
 		if (err)
 			return err;
 	}
@@ -1205,8 +1204,9 @@ int igc_enable_nfc_rule(struct igc_adapter *adapter,
 	}
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
-		int prio = (ntohs(rule->filter.vlan_tci) & VLAN_PRIO_MASK) >>
+		int prio = (rule->filter.vlan_tci & VLAN_PRIO_MASK) >>
 			   VLAN_PRIO_SHIFT;
+
 		err = igc_add_vlan_prio_filter(adapter, prio, rule->action);
 		if (err)
 			return err;
@@ -1218,14 +1218,11 @@ int igc_enable_nfc_rule(struct igc_adapter *adapter,
 int igc_disable_nfc_rule(struct igc_adapter *adapter,
 			 const struct igc_nfc_rule *rule)
 {
-	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
-		u16 etype = ntohs(rule->filter.etype);
-
-		igc_del_etype_filter(adapter, etype);
-	}
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE)
+		igc_del_etype_filter(adapter, rule->filter.etype);
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
-		int prio = (ntohs(rule->filter.vlan_tci) & VLAN_PRIO_MASK) >>
+		int prio = (rule->filter.vlan_tci & VLAN_PRIO_MASK) >>
 			   VLAN_PRIO_SHIFT;
 		igc_del_vlan_prio_filter(adapter, prio);
 	}
@@ -1325,7 +1322,7 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 		return -ENOMEM;
 
 	if (fsp->m_u.ether_spec.h_proto == ETHER_TYPE_FULL_MASK) {
-		rule->filter.etype = fsp->h_u.ether_spec.h_proto;
+		rule->filter.etype = ntohs(fsp->h_u.ether_spec.h_proto);
 		rule->filter.match_flags = IGC_FILTER_FLAG_ETHER_TYPE;
 	}
 
@@ -1357,7 +1354,7 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 			err = -EOPNOTSUPP;
 			goto err_out;
 		}
-		rule->filter.vlan_tci = fsp->h_ext.vlan_tci;
+		rule->filter.vlan_tci = ntohs(fsp->h_ext.vlan_tci);
 		rule->filter.match_flags |= IGC_FILTER_FLAG_VLAN_TCI;
 	}
 
-- 
2.26.2

