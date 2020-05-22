Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F51DDBD1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgEVALS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:41700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730740AbgEVALP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:15 -0400
IronPort-SDR: 9Jo8Fj2+0OktpodAdf8qH/Wx3QM1bd0T2UpoXj/JQDIIkVnhYqxFjtSL4zgsMrk3K0CMqJTsDz
 oxt4f+HmbW+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:11 -0700
IronPort-SDR: 6p4oTYEJsrZvNk7ciCOUsKhxRh3FvNyPFNd9ablOIjHJ4dFvWpf/JmYM3rIDqQ1eTPrjQQ9Gi7
 9vOgVbH/ypCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133961"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 12/15] igc: Early return in igc_get_ethtool_nfc_entry()
Date:   Thu, 21 May 2020 17:11:05 -0700
Message-Id: <20200522001108.1675149-13-jeffrey.t.kirsher@intel.com>
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

This patch re-writes the second half of igc_ethtool_get_nfc_entry() to
follow the 'return early' pattern seen in other parts of the driver and
removes some duplicate comments.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 58 ++++++++++----------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 37fb5f0544ad..f03093d1f863 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -945,38 +945,36 @@ static int igc_get_ethtool_nfc_entry(struct igc_adapter *adapter,
 	if (!rule || fsp->location != rule->sw_idx)
 		return -EINVAL;
 
-	if (rule->filter.match_flags) {
-		fsp->flow_type = ETHER_FLOW;
-		fsp->ring_cookie = rule->action;
-		if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
-			fsp->h_u.ether_spec.h_proto = rule->filter.etype;
-			fsp->m_u.ether_spec.h_proto = ETHER_TYPE_FULL_MASK;
-		}
-		if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
-			fsp->flow_type |= FLOW_EXT;
-			fsp->h_ext.vlan_tci = rule->filter.vlan_tci;
-			fsp->m_ext.vlan_tci = htons(VLAN_PRIO_MASK);
-		}
-		if (rule->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
-			ether_addr_copy(fsp->h_u.ether_spec.h_dest,
-					rule->filter.dst_addr);
-			/* As we only support matching by the full
-			 * mask, return the mask to userspace
-			 */
-			eth_broadcast_addr(fsp->m_u.ether_spec.h_dest);
-		}
-		if (rule->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
-			ether_addr_copy(fsp->h_u.ether_spec.h_source,
-					rule->filter.src_addr);
-			/* As we only support matching by the full
-			 * mask, return the mask to userspace
-			 */
-			eth_broadcast_addr(fsp->m_u.ether_spec.h_source);
-		}
+	if (!rule->filter.match_flags)
+		return -EINVAL;
 
-		return 0;
+	fsp->flow_type = ETHER_FLOW;
+	fsp->ring_cookie = rule->action;
+
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
+		fsp->h_u.ether_spec.h_proto = rule->filter.etype;
+		fsp->m_u.ether_spec.h_proto = ETHER_TYPE_FULL_MASK;
 	}
-	return -EINVAL;
+
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
+		fsp->flow_type |= FLOW_EXT;
+		fsp->h_ext.vlan_tci = rule->filter.vlan_tci;
+		fsp->m_ext.vlan_tci = htons(VLAN_PRIO_MASK);
+	}
+
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_DST_MAC_ADDR) {
+		ether_addr_copy(fsp->h_u.ether_spec.h_dest,
+				rule->filter.dst_addr);
+		eth_broadcast_addr(fsp->m_u.ether_spec.h_dest);
+	}
+
+	if (rule->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
+		ether_addr_copy(fsp->h_u.ether_spec.h_source,
+				rule->filter.src_addr);
+		eth_broadcast_addr(fsp->m_u.ether_spec.h_source);
+	}
+
+	return 0;
 }
 
 static int igc_get_ethtool_nfc_all(struct igc_adapter *adapter,
-- 
2.26.2

