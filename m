Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E0C232295
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgG2QYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:42166 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgG2QYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:17 -0400
IronPort-SDR: ZnA0aKHV4Itv6FsPG3+2zO6ydVK7lAzZkaG6hGO3GXegWX0HeKONWxv9IsOwBaEncUJ0Eyf7aX
 YfPlPn9OEJoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982342"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982342"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:16 -0700
IronPort-SDR: dkWhrKyBqP/kKlv1DTmFxhZRUsDq7ZCVxqZ4WJUvXmGARvLPnHntGdgnvBI68dmNdeTjpameFX
 ie1OVd/zLmEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087593"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 11/15] ice: Allow all VLANs in safe mode
Date:   Wed, 29 Jul 2020 09:24:01 -0700
Message-Id: <20200729162405.1596435-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the PF VSI's context parameters are left in a bad state when
going into safe mode. This is causing VLAN traffic to not pass. Fix this
by configuring the PF VSI to allow all VLAN tagged traffic.

Also, remove redundant comment explaining the safe mode flow in
ice_probe().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 59 ++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9b9e30a7d690..a68371fc0a75 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3583,6 +3583,60 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 	return err;
 }
 
+/**
+ * ice_set_safe_mode_vlan_cfg - configure PF VSI to allow all VLANs in safe mode
+ * @pf: PF to configure
+ *
+ * No VLAN offloads/filtering are advertised in safe mode so make sure the PF
+ * VSI can still Tx/Rx VLAN tagged packets.
+ */
+static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct ice_vsi_ctx *ctxt;
+	enum ice_status status;
+	struct ice_hw *hw;
+
+	if (!vsi)
+		return;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return;
+
+	hw = &pf->hw;
+	ctxt->info = vsi->info;
+
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
+			    ICE_AQ_VSI_PROP_SECURITY_VALID |
+			    ICE_AQ_VSI_PROP_SW_VALID);
+
+	/* disable VLAN anti-spoof */
+	ctxt->info.sec_flags &= ~(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+				  ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
+
+	/* disable VLAN pruning and keep all other settings */
+	ctxt->info.sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+
+	/* allow all VLANs on Tx and don't strip on Rx */
+	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_MODE_ALL |
+		ICE_AQ_VSI_VLAN_EMOD_NOTHING;
+
+	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (status) {
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to update VSI for safe mode VLANs, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+	} else {
+		vsi->info.sec_flags = ctxt->info.sec_flags;
+		vsi->info.sw_flags2 = ctxt->info.sw_flags2;
+		vsi->info.vlan_flags = ctxt->info.vlan_flags;
+	}
+
+	kfree(ctxt);
+}
+
 /**
  * ice_log_pkg_init - log result of DDP package load
  * @hw: pointer to hardware info
@@ -4139,9 +4193,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	/* Disable WoL at init, wait for user to enable */
 	device_set_wakeup_enable(dev, false);
 
-	/* If no DDP driven features have to be setup, we are done with probe */
-	if (ice_is_safe_mode(pf))
+	if (ice_is_safe_mode(pf)) {
+		ice_set_safe_mode_vlan_cfg(pf);
 		goto probe_done;
+	}
 
 	/* initialize DDP driven features */
 
-- 
2.26.2

