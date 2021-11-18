Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2684D4551B1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhKRAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:36:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:3443 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241943AbhKRAgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:36:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="234324560"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="234324560"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 16:33:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="736447985"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2021 16:33:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Eryk Rybak <eryk.roch.rybak@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/7] i40e: Fix correct max_pkt_size on VF RX queue
Date:   Wed, 17 Nov 2021 16:31:53 -0800
Message-Id: <20211118003159.245561-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
References: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

Setting VLAN port increasing RX queue max_pkt_size
by 4 bytes to take VLAN tag into account.
Trigger the VF reset when setting port VLAN for
VF to renegotiate its capabilities and reinitialize.

Fixes: ba4e003d29c1 ("i40e: don't hold spinlock while resetting VF")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 53 ++++---------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 472f56b360b8..815661632e7a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -674,14 +674,13 @@ static int i40e_config_vsi_rx_queue(struct i40e_vf *vf, u16 vsi_id,
 				    u16 vsi_queue_id,
 				    struct virtchnl_rxq_info *info)
 {
+	u16 pf_queue_id = i40e_vc_get_pf_queue_id(vf, vsi_id, vsi_queue_id);
 	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
-	u16 pf_queue_id;
 	int ret = 0;
 
-	pf_queue_id = i40e_vc_get_pf_queue_id(vf, vsi_id, vsi_queue_id);
-
 	/* clear the context structure first */
 	memset(&rx_ctx, 0, sizeof(struct i40e_hmc_obj_rxq));
 
@@ -719,6 +718,10 @@ static int i40e_config_vsi_rx_queue(struct i40e_vf *vf, u16 vsi_id,
 	}
 	rx_ctx.rxmax = info->max_pkt_size;
 
+	/* if port VLAN is configured increase the max packet size */
+	if (vsi->info.pvid)
+		rx_ctx.rxmax += VLAN_HLEN;
+
 	/* enable 32bytes desc always */
 	rx_ctx.dsize = 1;
 
@@ -4169,34 +4172,6 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	return ret;
 }
 
-/**
- * i40e_vsi_has_vlans - True if VSI has configured VLANs
- * @vsi: pointer to the vsi
- *
- * Check if a VSI has configured any VLANs. False if we have a port VLAN or if
- * we have no configured VLANs. Do not call while holding the
- * mac_filter_hash_lock.
- */
-static bool i40e_vsi_has_vlans(struct i40e_vsi *vsi)
-{
-	bool have_vlans;
-
-	/* If we have a port VLAN, then the VSI cannot have any VLANs
-	 * configured, as all MAC/VLAN filters will be assigned to the PVID.
-	 */
-	if (vsi->info.pvid)
-		return false;
-
-	/* Since we don't have a PVID, we know that if the device is in VLAN
-	 * mode it must be because of a VLAN filter configured on this VSI.
-	 */
-	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	have_vlans = i40e_is_vsi_in_vlan(vsi);
-	spin_unlock_bh(&vsi->mac_filter_hash_lock);
-
-	return have_vlans;
-}
-
 /**
  * i40e_ndo_set_vf_port_vlan
  * @netdev: network interface device structure
@@ -4253,19 +4228,9 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		/* duplicate request, so just return success */
 		goto error_pvid;
 
-	if (i40e_vsi_has_vlans(vsi)) {
-		dev_err(&pf->pdev->dev,
-			"VF %d has already configured VLAN filters and the administrator is requesting a port VLAN override.\nPlease unload and reload the VF driver for this change to take effect.\n",
-			vf_id);
-		/* Administrator Error - knock the VF offline until he does
-		 * the right thing by reconfiguring his network correctly
-		 * and then reloading the VF driver.
-		 */
-		i40e_vc_disable_vf(vf);
-		/* During reset the VF got a new VSI, so refresh the pointer. */
-		vsi = pf->vsi[vf->lan_vsi_idx];
-	}
-
+	i40e_vc_disable_vf(vf);
+	/* During reset the VF got a new VSI, so refresh a pointer. */
+	vsi = pf->vsi[vf->lan_vsi_idx];
 	/* Locked once because multiple functions below iterate list */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-- 
2.31.1

