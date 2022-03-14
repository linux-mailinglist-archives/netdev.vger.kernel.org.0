Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920D14D8B74
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbiCNSLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiCNSLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317D413DE2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281405; x=1678817405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gsjB4S7F5dgCi7XdBI4naWV0ssfnNc4W7AXl0aAXeNY=;
  b=nktaIDfzUwOn2RRtnnPrE8wYMGqa7cGuYngUekVLdcPSSf39VMiP1s+Y
   5FKThFf5BnWhtbEsTRNJQnzeusu/nwFi3CzLvkKMinyn3R4xMaFKYZbri
   SHmY4C5bfTzHDlr/zSEfYMk+EvBPwU8vmamEV3uqQuBV6aYZOAG7LAzAy
   /y8jthY0DjfMsY1fVMOBPLEfle1AJn9e5my8bP9Cj3uS2z7wSNEu8iWuJ
   tQOE78y6FNYl1m4sUEs6TQPe6RFmKzNwHiN0XfsIUOFNzDKq4RDH4IBgC
   fJdq2Ypp6IYen2BBFe0SWs72Y2cKCWcb1J6hkYmy1a1PQ2QDZscRT8vVg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275400"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275400"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297701"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 20/25] ice: convert ice_reset_vf to take flags
Date:   Mon, 14 Mar 2022 11:10:11 -0700
Message-Id: <20220314181016.1690595-21-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_reset_vf function takes a boolean parameter which indicates
whether or not the reset is due to a VFLR event.

This is somewhat confusing to read because readers must interpret what
"true" and "false" mean when seeing a line of code like
"ice_reset_vf(vf, false)".

We will want to add another toggle to the ice_reset_vf in a following
change. To avoid proliferating many arguments, convert this function to
take flags instead. ICE_VF_RESET_VFLR will indicate if this is a VFLR
reset. A value of 0 indicates no flags.

One could argue that "ice_reset_vf(vf, 0)" is no more readable than
"ice_reset_vf(vf, false)".. However, this type of flags interface is
somewhat common and using 0 to mean "no flags" makes sense in this
context. We could bother to add a define for "ICE_VF_RESET_PLAIN" or
something similar, but this can be confusing since its not an actual bit
flag.

This paves the way to add another flag to the function in a following
change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 6 +++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 9 ++++++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h | 9 +++++++--
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3cec52b09c6d..2e23fdc099e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1824,7 +1824,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				 */
 				ice_print_vf_rx_mdd_event(vf);
 				mutex_lock(&vf->cfg_lock);
-				ice_reset_vf(vf, false);
+				ice_reset_vf(vf, 0);
 				mutex_unlock(&vf->cfg_lock);
 			}
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 4a8cf8f646c8..c234e4edc7f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1393,7 +1393,7 @@ void ice_process_vflr_event(struct ice_pf *pf)
 		if (reg & BIT(bit_idx)) {
 			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
 			mutex_lock(&vf->cfg_lock);
-			ice_reset_vf(vf, true);
+			ice_reset_vf(vf, ICE_VF_RESET_VFLR);
 			mutex_unlock(&vf->cfg_lock);
 		}
 	}
@@ -1407,7 +1407,7 @@ void ice_process_vflr_event(struct ice_pf *pf)
 static void ice_vc_reset_vf(struct ice_vf *vf)
 {
 	ice_vc_notify_vf_reset(vf);
-	ice_reset_vf(vf, false);
+	ice_reset_vf(vf, 0);
 }
 
 /**
@@ -1724,7 +1724,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 {
 	if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
-		ice_reset_vf(vf, false);
+		ice_reset_vf(vf, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index d37232197bde..3b4e55c62786 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -444,13 +444,16 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 /**
  * ice_reset_vf - Reset a particular VF
  * @vf: pointer to the VF structure
- * @is_vflr: true if VFLR was issued, false if not
+ * @flags: flags controlling behavior of the reset
+ *
+ * Flags:
+ *   ICE_VF_RESET_VFLR - Indicates a reset is due to VFLR event
  *
  * Returns 0 if the VF is currently in reset, if the resets are disabled, or
  * if the VF resets successfully. Returns an error code if the VF fails to
  * rebuild.
  */
-int ice_reset_vf(struct ice_vf *vf, bool is_vflr)
+int ice_reset_vf(struct ice_vf *vf, u32 flags)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
@@ -478,7 +481,7 @@ int ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	/* Set VF disable bit state here, before triggering reset */
 	set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-	ice_trigger_vf_reset(vf, is_vflr, false);
+	ice_trigger_vf_reset(vf, flags & ICE_VF_RESET_VFLR, false);
 
 	vsi = ice_get_vf_vsi(vf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 811b6cc8ad67..071b7f99e2d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -133,6 +133,11 @@ struct ice_vf {
 	struct devlink_port devlink_port;
 };
 
+/* Flags for controlling behavior of ice_reset_vf */
+enum ice_vf_reset_flags {
+	ICE_VF_RESET_VFLR = BIT(0), /* Indicate a VFLR reset */
+};
+
 static inline u16 ice_vf_get_port_vlan_id(struct ice_vf *vf)
 {
 	return vf->port_vlan_info.vid;
@@ -212,7 +217,7 @@ int
 ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int
 ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
-int ice_reset_vf(struct ice_vf *vf, bool is_vflr);
+int ice_reset_vf(struct ice_vf *vf, u32 flags);
 void ice_reset_all_vfs(struct ice_pf *pf);
 #else /* CONFIG_PCI_IOV */
 static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
@@ -270,7 +275,7 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	return -EOPNOTSUPP;
 }
 
-static inline int ice_reset_vf(struct ice_vf *vf, bool is_vflr)
+static inline int ice_reset_vf(struct ice_vf *vf, u32 flags)
 {
 	return 0;
 }
-- 
2.31.1

