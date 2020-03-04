Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC21179C44
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbgCDXVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:48334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388572AbgCDXVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094638"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/16] ice: Correct setting VLAN pruning
Date:   Wed,  4 Mar 2020 15:21:30 -0800
Message-Id: <20200304232136.4172118-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

VLAN pruning is not always being set correctly due to a previous change
that set Tx antispoof off. ice_vsi_is_vlan_pruning_ena() currently checks
for both Tx antispoof and Rx pruning. The expectation for this function is
to only check Rx pruning so fix the check.

Fixes: cd6d6b83316a ("ice: Fix VF spoofchk")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 9230abdb4ee8..1ee6a86f507d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1877,20 +1877,14 @@ int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
  * ice_vsi_is_vlan_pruning_ena - check if VLAN pruning is enabled or not
  * @vsi: VSI to check whether or not VLAN pruning is enabled.
  *
- * returns true if Rx VLAN pruning and Tx VLAN anti-spoof is enabled and false
- * otherwise.
+ * returns true if Rx VLAN pruning is enabled and false otherwise.
  */
 bool ice_vsi_is_vlan_pruning_ena(struct ice_vsi *vsi)
 {
-	u8 rx_pruning = ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
-	u8 tx_pruning = ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
-		ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S;
-
 	if (!vsi)
 		return false;
 
-	return ((vsi->info.sw_flags2 & rx_pruning) &&
-		(vsi->info.sec_flags & tx_pruning));
+	return (vsi->info.sw_flags2 & ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA);
 }
 
 /**
-- 
2.24.1

