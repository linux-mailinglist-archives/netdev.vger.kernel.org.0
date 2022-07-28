Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC15846CE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiG1T6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiG1T6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:58:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4034F1EAF8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659038319; x=1690574319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iXL9Ly7t7YgkgLNQ9yCwI7p6yWK2XILNbbemNukn+8c=;
  b=gzFA50srNR8AieoHnFJSJzUVXbVIzDTDuJN68UYxBA0ijHwKwXCzk+tE
   9SB7QNbbribiPPm3GOvFYfQ3wFbSplWt6UyBwKLqYNTW2LlT6AD0Ll3OO
   t4ohfnT0+Udg6TYhh063MG5aZCeofKkXKhXUPKuDb5hG4TcFZ5jr5trvG
   gGHrEJDpKiIDFwM5YrcGk/OkVMv9veXHLKJa3194WbjwxR4W8DhxzKFfw
   StfS1W5ta5Vwj7MZiHaevEgK+Wm7fSioRBuZUP4Gz+88LHgtrUKZ4Xl9A
   5r01qus+1mg28HNHs/meTy25L4UDlHW3LK2zAW6Lb66fTtSSpBQHmteOc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="350310072"
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="350310072"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:58:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,199,1654585200"; 
   d="scan'208";a="928453965"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2022 12:58:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 2/4] ice: Fix promiscuous mode not turning off
Date:   Thu, 28 Jul 2022 12:55:36 -0700
Message-Id: <20220728195538.3391360-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
References: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

When trust is turned off for the VF, the expectation is that promiscuous
and allmulticast filters are removed. Currently default VSI filter is not
getting cleared in this flow.

Example:

ip link set enp236s0f0 vf 0 trust on
ip link set enp236s0f0v0 promisc on
ip link set enp236s0f0 vf 0 trust off
/* promiscuous mode is still enabled on VF0 */

Remove switch filters for both cases.
This commit fixes above behavior by removing default VSI filters and
allmulticast filters when vf-true-promisc-support is OFF.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 79 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  9 +--
 3 files changed, 72 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 9038d2687ba6..8fd7c3e37f5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -297,6 +297,73 @@ bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf)
 	return is_vf_promisc;
 }
 
+/**
+ * ice_vf_get_promisc_masks - Calculate masks for promiscuous modes
+ * @vf: the VF pointer
+ * @vsi: the VSI to configure
+ * @ucast_m: promiscuous mask to apply to unicast
+ * @mcast_m: promiscuous mask to apply to multicast
+ *
+ * Decide which mask should be used for unicast and multicast filter,
+ * based on presence of VLANs
+ */
+void
+ice_vf_get_promisc_masks(struct ice_vf *vf, struct ice_vsi *vsi,
+			 u8 *ucast_m, u8 *mcast_m)
+{
+	if (ice_vf_is_port_vlan_ena(vf) ||
+	    ice_vsi_has_non_zero_vlans(vsi)) {
+		*mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
+		*ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
+	} else {
+		*mcast_m = ICE_MCAST_PROMISC_BITS;
+		*ucast_m = ICE_UCAST_PROMISC_BITS;
+	}
+}
+
+/**
+ * ice_vf_clear_all_promisc_modes - Clear promisc/allmulticast on VF VSI
+ * @vf: the VF pointer
+ * @vsi: the VSI to configure
+ *
+ * Clear all promiscuous/allmulticast filters for a VF
+ */
+static int
+ice_vf_clear_all_promisc_modes(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vf->pf;
+	u8 ucast_m, mcast_m;
+	int ret = 0;
+
+	ice_vf_get_promisc_masks(vf, vsi, &ucast_m, &mcast_m);
+	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states)) {
+		if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
+			if (ice_is_dflt_vsi_in_use(vsi->port_info))
+				ret = ice_clear_dflt_vsi(vsi);
+		} else {
+			ret = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
+		}
+
+		if (ret) {
+			dev_err(ice_pf_to_dev(vf->pf), "Disabling promiscuous mode failed\n");
+		} else {
+			clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states);
+			dev_info(ice_pf_to_dev(vf->pf), "Disabling promiscuous mode succeeded\n");
+		}
+	}
+
+	if (test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) {
+		ret = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
+		if (ret) {
+			dev_err(ice_pf_to_dev(vf->pf), "Disabling allmulticast mode failed\n");
+		} else {
+			clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states);
+			dev_info(ice_pf_to_dev(vf->pf), "Disabling allmulticast mode succeeded\n");
+		}
+	}
+	return ret;
+}
+
 /**
  * ice_vf_set_vsi_promisc - Enable promiscuous mode for a VF VSI
  * @vf: the VF to configure
@@ -487,7 +554,6 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_hw *hw;
-	u8 promisc_m;
 	int err = 0;
 	bool rsd;
 
@@ -554,16 +620,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	/* disable promiscuous modes in case they were enabled
 	 * ignore any error if disabling process failed
 	 */
-	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
-	    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) {
-		if (ice_vf_is_port_vlan_ena(vf) || vsi->num_vlan)
-			promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
-		else
-			promisc_m = ICE_UCAST_PROMISC_BITS;
-
-		if (ice_vf_clear_vsi_promisc(vf, vsi, promisc_m))
-			dev_err(dev, "disabling promiscuous mode failed\n");
-	}
+	ice_vf_clear_all_promisc_modes(vf, vsi);
 
 	ice_eswitch_del_vf_mac_rule(vf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 1acb35c9ff01..52bd9a3816bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -215,6 +215,9 @@ bool ice_is_vf_disabled(struct ice_vf *vf);
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
 void ice_set_vf_state_qs_dis(struct ice_vf *vf);
 bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf);
+void
+ice_vf_get_promisc_masks(struct ice_vf *vf, struct ice_vsi *vsi,
+			 u8 *ucast_m, u8 *mcast_m);
 int
 ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 47ce713274cf..d46786cdc162 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1046,14 +1046,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (ice_vf_is_port_vlan_ena(vf) ||
-	    ice_vsi_has_non_zero_vlans(vsi)) {
-		mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
-		ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
-	} else {
-		mcast_m = ICE_MCAST_PROMISC_BITS;
-		ucast_m = ICE_UCAST_PROMISC_BITS;
-	}
+	ice_vf_get_promisc_masks(vf, vsi, &ucast_m, &mcast_m);
 
 	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
 		if (alluni) {
-- 
2.35.1

