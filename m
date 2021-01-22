Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E7301157
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbhAWACC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:02:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:38953 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbhAWABX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:01:23 -0500
IronPort-SDR: npdGe6qYR/Qtvt1xKdD9ZCnlErKfOLnWlI8evtLwHbmkEoImn4BTGoKGR6vEcqI7kVEZ/zlXN2
 qGka24zkPDCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670515"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670515"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: YO/Ke7ksNhUkvZnWNtY2z2PxyWi78B5CoMrKSRf7nyAhuaCyJmbKW1t8mf/iHb1gc9BE+fqKUw
 4vTrzx7wQfrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258691"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 5/7] ice: Don't allow more channels than LAN MSI-X available
Date:   Fri, 22 Jan 2021 15:57:32 -0800
Message-Id: <20210122235734.447240-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently users could create more channels than LAN MSI-X available.
This is happening because there is no check against pf->num_lan_msix
when checking the max allowed channels and will cause performance issues
if multiple Tx and Rx queues are tied to a single MSI-X. Fix this by not
allowing more channels than LAN MSI-X available in pf->num_lan_msix.

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9e8e9531cd87..69c113a4de7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3258,8 +3258,8 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
  */
 static int ice_get_max_txq(struct ice_pf *pf)
 {
-	return min_t(int, num_online_cpus(),
-		     pf->hw.func_caps.common_cap.num_txq);
+	return min3(pf->num_lan_msix, (u16)num_online_cpus(),
+		    (u16)pf->hw.func_caps.common_cap.num_txq);
 }
 
 /**
@@ -3268,8 +3268,8 @@ static int ice_get_max_txq(struct ice_pf *pf)
  */
 static int ice_get_max_rxq(struct ice_pf *pf)
 {
-	return min_t(int, num_online_cpus(),
-		     pf->hw.func_caps.common_cap.num_rxq);
+	return min3(pf->num_lan_msix, (u16)num_online_cpus(),
+		    (u16)pf->hw.func_caps.common_cap.num_rxq);
 }
 
 /**
-- 
2.26.2

