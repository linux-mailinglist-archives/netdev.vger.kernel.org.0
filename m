Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29D14AFFBF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiBIV5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiBIV5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:39 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E912E01115D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443846; x=1675979846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Sk+h7BuJQZSEpzozYtqS48XcU0EaXbT4q03eEJK4cI=;
  b=ktRPWiCUfxxj/rKYBVhJZiGQuo12aZPMSBUjzGytcpm1Bd0L0fR4mOmI
   ABbt6aWqaXgVyMLf8xS/gwRpRBCtoVwL+UvKYEcr8qiEotziMBVw4R6Ly
   UJx6YE6D6hipK4+br250HNFQqEdaWSkLEr4t9yl2wQUPsD2vlMEBjNcqS
   O+pNBlXK9TqZtyLHAB8HUQt4iT0GSb7ee1dVW4uqbLTBgV9Iu5TqQNCPG
   IykcBZY9krMnO+zdpyoO7N6IFZyc6k1KmAbNUZE7FNceh63u5eiuFouHM
   dB2obJf/rG08JumzhfZonJRCEx+KsDZ85Dtph9IBMuQOJa4BLiVtHT7EM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104116"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104116"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790525"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 14/14] ice: Add ability for PF admin to enable VF VLAN pruning
Date:   Wed,  9 Feb 2022 13:57:06 -0800
Message-Id: <20220209215706.2468371-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

VFs by default are able to see all tagged traffic regardless of trust
and VLAN filters. Based on legacy devices (i.e. ixgbe, i40e), customers
expect VFs to receive all VLAN tagged traffic with a matching
destination MAC.

Add an ethtool private flag 'vf-vlan-pruning' and set the default to
off so VFs will receive all VLAN traffic directed towards them. When
the flag is turned on, VF will only be able to receive untagged
traffic or traffic with VLAN tags it has created interfaces for.

Also, the flag cannot be changed while any VFs are allocated. This was
done to simplify the implementation. So, if this flag is needed, then
the PF admin must enable it. If the user tries to enable the flag while
VFs are active, then print an unsupported message with the
vf-vlan-pruning flag included. In case multiple flags were specified, this
makes it clear to the user which flag failed.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h           |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c   |  9 +++++++++
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c   | 18 ++++++++++++++++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c   | 14 ++++++++++++++
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 55f32fca619b..6a710c209707 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -485,6 +485,7 @@ enum ice_pf_flags {
 	ICE_FLAG_LEGACY_RX,
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
+	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e2e3ef7fba7f..28ead0b4712f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -164,6 +164,7 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("vf-true-promisc-support",
 		      ICE_FLAG_VF_TRUE_PROMISC_ENA),
 	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
+	ICE_PRIV_FLAG("vf-vlan-pruning", ICE_FLAG_VF_VLAN_PRUNING),
 	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
 };
 
@@ -1295,6 +1296,14 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 		change_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags);
 		ret = -EAGAIN;
 	}
+
+	if (test_bit(ICE_FLAG_VF_VLAN_PRUNING, change_flags) &&
+	    pf->num_alloc_vfs) {
+		dev_err(dev, "vf-vlan-pruning: VLAN pruning cannot be changed while VFs are active.\n");
+		/* toggle bit back to previous state */
+		change_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags);
+		ret = -EOPNOTSUPP;
+	}
 ethtool_exit:
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
 	return ret;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index 4be29f97365c..39f2d36cabba 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -43,7 +43,6 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 
 		/* outer VLAN ops regardless of port VLAN config */
 		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
 		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
@@ -51,6 +50,8 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 		if (ice_vf_is_port_vlan_ena(vf)) {
 			/* setup outer VLAN ops */
 			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+			vlan_ops->ena_rx_filtering =
+				ice_vsi_ena_rx_vlan_filtering;
 
 			/* setup inner VLAN ops */
 			vlan_ops = &vsi->inner_vlan_ops;
@@ -61,6 +62,12 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
 			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
 		} else {
+			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
+				vlan_ops->ena_rx_filtering = noop_vlan;
+			else
+				vlan_ops->ena_rx_filtering =
+					ice_vsi_ena_rx_vlan_filtering;
+
 			vlan_ops->del_vlan = ice_vsi_del_vlan;
 			vlan_ops->ena_stripping = ice_vsi_ena_outer_stripping;
 			vlan_ops->dis_stripping = ice_vsi_dis_outer_stripping;
@@ -80,14 +87,21 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 
 		/* inner VLAN ops regardless of port VLAN config */
 		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
 		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 
 		if (ice_vf_is_port_vlan_ena(vf)) {
 			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
+			vlan_ops->ena_rx_filtering =
+				ice_vsi_ena_rx_vlan_filtering;
 		} else {
+			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
+				vlan_ops->ena_rx_filtering = noop_vlan;
+			else
+				vlan_ops->ena_rx_filtering =
+					ice_vsi_ena_rx_vlan_filtering;
+
 			vlan_ops->del_vlan = ice_vsi_del_vlan;
 			vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
 			vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9c43a7c8a45f..02a8c15d2bf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -807,6 +807,11 @@ static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
 		return err;
 	}
 
+	err = vlan_ops->ena_rx_filtering(vsi);
+	if (err)
+		dev_warn(dev, "failed to enable Rx VLAN filtering for VF %d VSI %d during VF rebuild, error %d\n",
+			 vf->vf_id, vsi->idx, err);
+
 	return 0;
 }
 
@@ -1793,6 +1798,7 @@ static void ice_vc_notify_vf_reset(struct ice_vf *vf)
  */
 static int ice_init_vf_vsi_res(struct ice_vf *vf)
 {
+	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_pf *pf = vf->pf;
 	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
@@ -1813,6 +1819,14 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 		goto release_vsi;
 	}
 
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	err = vlan_ops->ena_rx_filtering(vsi);
+	if (err) {
+		dev_warn(dev, "Failed to enable Rx VLAN filtering for VF %d\n",
+			 vf->vf_id);
+		goto release_vsi;
+	}
+
 	eth_broadcast_addr(broadcast);
 	err = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
 	if (err) {
-- 
2.31.1

