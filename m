Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44AF543882
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245038AbiFHQML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245019AbiFHQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:12:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B463A191
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654704722; x=1686240722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7kTuKw/Ygvdc2B4RK2WD3kJRapeOEttbW8hxUJf5LU=;
  b=iedCtMs8tVEE/UjYhRjX0SrI3bgfGUHl33QolGWRAgDPZ1Vy4WafQhxL
   xotaGWManQY/R2w3Yr0CKKqfzhm/iFe/fMBCGWw2NO2qcV0h4cyUdHB3q
   inz7kFHMuxmYl2MZYgfQHslvYH2EnmHJkGo5LHUJB7gUPf6R0lz9Ehrww
   ZNyoJHhMFsu5Y2r3mZXjIqtxbMAsot4b2h903hy1MB6eURiqqbbxay7EN
   pqGJu7URQB//v0thWoAzogFWLgeoY7mAJgT4nIqgGcw9JMzJfHQoIGi+j
   yLxOzYwj0qcUbnZsCZAg6RfM4qR1nfugvjckRvmq7Iv9/iFQGAHAdNxn7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="260099539"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="260099539"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 09:11:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="827049672"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 09:11:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/4] ice: remove VLAN representor specific ops
Date:   Wed,  8 Jun 2022 09:07:55 -0700
Message-Id: <20220608160757.2395729-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
References: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In switchdev mode VF VLAN caps will not be set there is no need
to have specific VLAN ops for representor that only returns not
supported error.

As VLAN configuration commands will be blocked, the VF driver
can't disable VLAN stripping at initialization. It leads to the
situation when VLAN stripping on VF VSI is on, but in kernel it
is off. To prevent this, disable VLAN stripping in VSI
initialization. It doesn't break other usecases, because it is set
according to kernel settings.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  3 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 44 ++-----------------
 2 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 454e01ae09b9..5a1e8b9b365d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -887,6 +887,9 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
 			(ICE_AQ_VSI_OUTER_TAG_VLAN_8100 <<
 			 ICE_AQ_VSI_OUTER_TAG_TYPE_S) &
 			ICE_AQ_VSI_OUTER_TAG_TYPE_M;
+		ctxt->info.outer_vlan_flags |=
+			FIELD_PREP(ICE_AQ_VSI_OUTER_VLAN_EMODE_M,
+				   ICE_AQ_VSI_OUTER_VLAN_EMODE_NOTHING);
 	}
 	/* Have 1:1 UP mapping for both ingress/egress tables */
 	table |= ICE_UP_TABLE_TRANSLATE(0, 0);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 9b2d862e11d8..99cb382e71fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3552,42 +3552,6 @@ ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
 				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 }
 
-static int ice_vc_repr_add_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't add VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_del_vlan(struct ice_vf *vf, u8 __always_unused *msg)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't delete VLAN in switchdev mode for VF %d\n", vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
-}
-
-static int ice_vc_repr_ena_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't enable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
-static int ice_vc_repr_dis_vlan_stripping(struct ice_vf *vf)
-{
-	dev_dbg(ice_pf_to_dev(vf->pf),
-		"Can't disable VLAN stripping in switchdev mode for VF %d\n",
-		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-				     NULL, 0);
-}
-
 static int
 ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
 {
@@ -3614,10 +3578,10 @@ static const struct ice_virtchnl_ops ice_virtchnl_repr_ops = {
 	.config_rss_lut = ice_vc_config_rss_lut,
 	.get_stats_msg = ice_vc_get_stats_msg,
 	.cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode,
-	.add_vlan_msg = ice_vc_repr_add_vlan,
-	.remove_vlan_msg = ice_vc_repr_del_vlan,
-	.ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping,
-	.dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping,
+	.add_vlan_msg = ice_vc_add_vlan_msg,
+	.remove_vlan_msg = ice_vc_remove_vlan_msg,
+	.ena_vlan_stripping = ice_vc_ena_vlan_stripping,
+	.dis_vlan_stripping = ice_vc_dis_vlan_stripping,
 	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
 	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
 	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
-- 
2.35.1

