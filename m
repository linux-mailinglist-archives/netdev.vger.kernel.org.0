Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4962A18097F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgCJUp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:45:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:27465 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgCJUpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:45:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="441431005"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2020 13:45:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/15] ice: Correct setting VLAN pruning
Date:   Tue, 10 Mar 2020 13:45:28 -0700
Message-Id: <20200310204534.2071912-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
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

