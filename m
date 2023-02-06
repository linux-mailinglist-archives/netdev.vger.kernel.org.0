Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F7368C8EB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBFVs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBFVsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:55 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8DD2C649
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720134; x=1707256134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nXkChGkK+ELW37tCk0arZ+qrDIcPVHImhp3BsSPvBpU=;
  b=aMfWlDGx8ePFvlCqDr4A0T+4GWz4FWflAFxlXu0aEy5KKYUrh5E89GsS
   GKWDE4o+lyxsFjmYchw9VJ8ZqtWNe3wxjF8+Iiyo9mieBP51NDZM//YjE
   P4yKjy1PMqEgYs3frBcceGaVaDYZLd7YAhShNK2e68Ixs31eenmp9F14K
   +YKHYzhk7+xHewXGQ44rBkTPHd+xFKNsRQzcAX20/U1464WMdrTYRGmea
   RI1dsIBZEsAoctjwNkeeES+7UPCeB/E4Y1D//Skr/dyofMeVei3NcHE2W
   LfGiiwfaO20UBElHK9rzrUk5rNM0Rmwu7vGy+AKlFxvNy+CnJf9qUpV/D
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338100"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338100"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576187"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576187"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 03/13] ice: drop unnecessary VF parameter from several VSI functions
Date:   Mon,  6 Feb 2023 13:48:03 -0800
Message-Id: <20230206214813.20107-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The vsi->vf pointer gets assigned early on during ice_vsi_alloc. Several
functions currently take a VF pointer, but they can just use the existing
vsi->vf pointer as needed. Modify these functions to drop the unnecessary
VF parameter.

Note that ice_vsi_cfg is not changed as a following change will refactor so
that the VF pointer is assigned during ice_vsi_cfg rather than
ice_vsi_alloc.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d81f89f420ed..da64216e680e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -166,14 +166,14 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 /**
  * ice_vsi_set_num_qs - Set number of queues, descriptors and vectors for a VSI
  * @vsi: the VSI being configured
- * @vf: the VF associated with this VSI, if any
  *
  * Return 0 on success and a negative value on error
  */
-static void ice_vsi_set_num_qs(struct ice_vsi *vsi, struct ice_vf *vf)
+static void ice_vsi_set_num_qs(struct ice_vsi *vsi)
 {
 	enum ice_vsi_type vsi_type = vsi->type;
 	struct ice_pf *pf = vsi->back;
+	struct ice_vf *vf = vsi->vf;
 
 	if (WARN_ON(vsi_type == ICE_VSI_VF && !vf))
 		return;
@@ -594,15 +594,13 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 /**
  * ice_vsi_alloc_def - set default values for already allocated VSI
  * @vsi: ptr to VSI
- * @vf: VF for ICE_VSI_VF and ICE_VSI_CTRL
  * @ch: ptr to channel
  */
 static int
-ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_vf *vf,
-		  struct ice_channel *ch)
+ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_channel *ch)
 {
 	if (vsi->type != ICE_VSI_CHNL) {
-		ice_vsi_set_num_qs(vsi, vf);
+		ice_vsi_set_num_qs(vsi);
 		if (ice_vsi_alloc_arrays(vsi))
 			return -ENOMEM;
 	}
@@ -2702,14 +2700,11 @@ static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
 /**
  * ice_vsi_cfg_def - configure default VSI based on the type
  * @vsi: pointer to VSI
- * @vf: pointer to VF to which this VSI connects. This field is used primarily
- *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
  * @ch: ptr to channel
  * @init_vsi: is this an initialization or a reconfigure of the VSI
  */
 static int
-ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch,
-		int init_vsi)
+ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_channel *ch, int init_vsi)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct ice_pf *pf = vsi->back;
@@ -2717,7 +2712,7 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch,
 
 	vsi->vsw = pf->first_sw;
 
-	ret = ice_vsi_alloc_def(vsi, vf, ch);
+	ret = ice_vsi_alloc_def(vsi, ch);
 	if (ret)
 		return ret;
 
@@ -2875,7 +2870,7 @@ int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch,
 {
 	int ret;
 
-	ret = ice_vsi_cfg_def(vsi, vf, ch, init_vsi);
+	ret = ice_vsi_cfg_def(vsi, ch, init_vsi);
 	if (ret)
 		return ret;
 
@@ -3506,7 +3501,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi)
 	prev_rxq = vsi->num_rxq;
 
 	ice_vsi_decfg(vsi);
-	ret = ice_vsi_cfg_def(vsi, vsi->vf, vsi->ch, init_vsi);
+	ret = ice_vsi_cfg_def(vsi, vsi->ch, init_vsi);
 	if (ret)
 		goto err_vsi_cfg;
 
-- 
2.38.1

