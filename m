Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B44AFFA2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiBIV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiBIV5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70602E00ED40
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443835; x=1675979835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SbyZ/moAOaA/2/Pkv+CguwPlxtoC0o6vHXBzTp4p+jA=;
  b=aYCBkH/p8NPrvdLiF6J5TcfaNSG6Xeddk9U4wj+P/VvKBTgbFqxvOlBn
   8Zr9uA0H7+0EItpiwgrY4HsReLEyfCMtWa2BaoUQ93IJy8v/Ipvd8SCT9
   zihTet6gDZwAxmv3sfUmZ+Le7dtXA6/YtXHKOmnKo7BgMQYiT2ZXXcNoF
   zmewweMmYZyzSeLI5LWt/iKlJkqSeaw51uBX6Xxk91l5gAj+EOkg47U52
   LLnhLfKdJHMn57uK2Uz3SvnrAr828D+tOnRj3MMiUjztDwII/iLgpGfrf
   LJfdPnD07PinmgpOGW4aLmtk2VlIodXa300Q43J3TP2HV+Nr2wZfdCojX
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104085"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104085"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790468"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 01/14] ice: Refactor spoofcheck configuration functions
Date:   Wed,  9 Feb 2022 13:56:53 -0800
Message-Id: <20220209215706.2468371-2-anthony.l.nguyen@intel.com>
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

Add functions to configure Tx VLAN antispoof based on iproute
configuration and/or VLAN mode and VF driver support. This is needed
later so the driver can control when it can be configured. Also, add
functions that can be used to enable and disable MAC and VLAN
spoofcheck. Move spoofchk configuration during VSI setup into the
SR-IOV initialization path and into the post VSI rebuild flow for VF
VSIs.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  19 ---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 159 ++++++++++++++----
 2 files changed, 128 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0c187cf04fcf..5b5480c3d254 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1168,25 +1168,6 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 				cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
 	}
 
-	/* enable/disable MAC and VLAN anti-spoof when spoofchk is on/off
-	 * respectively
-	 */
-	if (vsi->type == ICE_VSI_VF) {
-		ctxt->info.valid_sections |=
-			cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
-		if (pf->vf[vsi->vf_id].spoofchk) {
-			ctxt->info.sec_flags |=
-				ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF |
-				(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
-				 ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
-		} else {
-			ctxt->info.sec_flags &=
-				~(ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF |
-				  (ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
-				   ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S));
-		}
-	}
-
 	/* Allow control frames out of main VSI */
 	if (vsi->type == ICE_VSI_PF) {
 		ctxt->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 39b80124d282..81974dbc1625 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -837,6 +837,114 @@ static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
 	return 0;
 }
 
+static int ice_cfg_vlan_antispoof(struct ice_vsi *vsi, bool enable)
+{
+	struct ice_vsi_ctx *ctx;
+	int err;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->info.sec_flags = vsi->info.sec_flags;
+	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
+
+	if (enable)
+		ctx->info.sec_flags |= ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+			ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S;
+	else
+		ctx->info.sec_flags &= ~(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+					 ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
+
+	err = ice_update_vsi(&vsi->back->hw, vsi->idx, ctx, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to configure Tx VLAN anti-spoof %s for VSI %d, error %d\n",
+			enable ? "ON" : "OFF", vsi->vsi_num, err);
+	else
+		vsi->info.sec_flags = ctx->info.sec_flags;
+
+	kfree(ctx);
+
+	return err;
+}
+
+static int ice_cfg_mac_antispoof(struct ice_vsi *vsi, bool enable)
+{
+	struct ice_vsi_ctx *ctx;
+	int err;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->info.sec_flags = vsi->info.sec_flags;
+	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
+
+	if (enable)
+		ctx->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF;
+	else
+		ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF;
+
+	err = ice_update_vsi(&vsi->back->hw, vsi->idx, ctx, NULL);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to configure Tx MAC anti-spoof %s for VSI %d, error %d\n",
+			enable ? "ON" : "OFF", vsi->vsi_num, err);
+	else
+		vsi->info.sec_flags = ctx->info.sec_flags;
+
+	kfree(ctx);
+
+	return err;
+}
+
+/**
+ * ice_vsi_ena_spoofchk - enable Tx spoof checking for this VSI
+ * @vsi: VSI to enable Tx spoof checking for
+ */
+static int ice_vsi_ena_spoofchk(struct ice_vsi *vsi)
+{
+	int err;
+
+	err = ice_cfg_vlan_antispoof(vsi, true);
+	if (err)
+		return err;
+
+	return ice_cfg_mac_antispoof(vsi, true);
+}
+
+/**
+ * ice_vsi_dis_spoofchk - disable Tx spoof checking for this VSI
+ * @vsi: VSI to disable Tx spoof checking for
+ */
+static int ice_vsi_dis_spoofchk(struct ice_vsi *vsi)
+{
+	int err;
+
+	err = ice_cfg_vlan_antispoof(vsi, false);
+	if (err)
+		return err;
+
+	return ice_cfg_mac_antispoof(vsi, false);
+}
+
+/**
+ * ice_vf_set_spoofchk_cfg - apply Tx spoof checking setting
+ * @vf: VF set spoofchk for
+ * @vsi: VSI associated to the VF
+ */
+static int
+ice_vf_set_spoofchk_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	int err;
+
+	if (vf->spoofchk)
+		err = ice_vsi_ena_spoofchk(vsi);
+	else
+		err = ice_vsi_dis_spoofchk(vsi);
+
+	return err;
+}
+
 /**
  * ice_vf_rebuild_host_mac_cfg - add broadcast and the VF's perm_addr/LAA
  * @vf: VF to add MAC filters for
@@ -1346,6 +1454,10 @@ static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 		dev_err(dev, "failed to rebuild Tx rate limiting configuration for VF %u\n",
 			vf->vf_id);
 
+	if (ice_vf_set_spoofchk_cfg(vf, vsi))
+		dev_err(dev, "failed to rebuild spoofchk configuration for VF %d\n",
+			vf->vf_id);
+
 	/* rebuild aggregator node config for main VF VSI */
 	ice_vf_rebuild_aggregator_node_cfg(vsi);
 }
@@ -1760,6 +1872,13 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 		goto release_vsi;
 	}
 
+	err = ice_vf_set_spoofchk_cfg(vf, vsi);
+	if (err) {
+		dev_warn(dev, "Failed to initialize spoofchk setting for VF %d\n",
+			 vf->vf_id);
+		goto release_vsi;
+	}
+
 	vf->num_mac = 1;
 
 	return 0;
@@ -2892,7 +3011,6 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_pf *pf = np->vsi->back;
-	struct ice_vsi_ctx *ctx;
 	struct ice_vsi *vf_vsi;
 	struct device *dev;
 	struct ice_vf *vf;
@@ -2925,37 +3043,16 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 		return 0;
 	}
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-
-	ctx->info.sec_flags = vf_vsi->info.sec_flags;
-	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
-	if (ena) {
-		ctx->info.sec_flags |=
-			ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF |
-			(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
-			 ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
-	} else {
-		ctx->info.sec_flags &=
-			~(ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF |
-			  (ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
-			   ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S));
-	}
-
-	ret = ice_update_vsi(&pf->hw, vf_vsi->idx, ctx, NULL);
-	if (ret) {
-		dev_err(dev, "Failed to %sable spoofchk on VF %d VSI %d\n error %d\n",
-			ena ? "en" : "dis", vf->vf_id, vf_vsi->vsi_num, ret);
-		goto out;
-	}
-
-	/* only update spoofchk state and VSI context on success */
-	vf_vsi->info.sec_flags = ctx->info.sec_flags;
-	vf->spoofchk = ena;
+	if (ena)
+		ret = ice_vsi_ena_spoofchk(vf_vsi);
+	else
+		ret = ice_vsi_dis_spoofchk(vf_vsi);
+	if (ret)
+		dev_err(dev, "Failed to set spoofchk %s for VF %d VSI %d\n error %d\n",
+			ena ? "ON" : "OFF", vf->vf_id, vf_vsi->vsi_num, ret);
+	else
+		vf->spoofchk = ena;
 
-out:
-	kfree(ctx);
 	return ret;
 }
 
-- 
2.31.1

