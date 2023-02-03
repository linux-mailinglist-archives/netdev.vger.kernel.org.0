Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1D68A46E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbjBCVPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbjBCVPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92807A58F6
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675458928; x=1706994928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=28/99uU7HIByFF3ur/iN3Yc8XqaYZTL/YMK96O6nCS8=;
  b=mnRL44AVq18ADtxhl3ww25KwnZDAjPtY2+Mgm/ItK2KcaNuIOul8C6Lh
   adur5b+wYAllzjiU9jyxtPI3r5YDjOgvBowoS4X5nb+03hEeaRJ45Magh
   9ULIJNkX9acWTWO0XCelKV7zBZ/p9A8eydF3JHSGgjZQDgx7bo7TVZ3sY
   HEBNBDgz00+gAO3SS9GdMHuK4mToko2RS9msyHe9SrQ3C/r25kjU8jPy2
   ghbBjptG7Yu49v43LY/uLpf2ttaI6Ha22VtYS3//Lpp0/5UdnofidPH5h
   yEGgmlaD41FtqHlkGmYvqkBBmSmjGwoG2GrPT6POpGAouPtMGMfDwuvbs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="393446832"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="393446832"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 13:15:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="911280487"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="911280487"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2023 13:15:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/10] ice: stop hard coding the ICE_VSI_CTRL location
Date:   Fri,  3 Feb 2023 13:14:51 -0800
Message-Id: <20230203211456.705649-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
References: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When allocating the ICE_VSI_CTRL, the allocated struct ice_vsi pointer is
stored into the PF's pf->vsi array at a fixed location. This was
historically done on the basis that it could provide an O(1) lookup for the
special control VSI.

Since we store the ctrl_vsi_idx, we already have O(1) lookup regardless of
where in the array we store this VSI.

Simplify the logic in ice_vsi_alloc by using the same method of storing the
control VSI as other types of VSIs.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 34 +++++++++++-------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f9690c0fe5da..528783de0df0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -479,10 +479,7 @@ int ice_vsi_free(struct ice_vsi *vsi)
 	/* updates the PF for this cleared VSI */
 
 	pf->vsi[vsi->idx] = NULL;
-	if (vsi->idx < pf->next_vsi && vsi->type != ICE_VSI_CTRL)
-		pf->next_vsi = vsi->idx;
-	if (vsi->idx < pf->next_vsi && vsi->type == ICE_VSI_CTRL && vsi->vf)
-		pf->next_vsi = vsi->idx;
+	pf->next_vsi = vsi->idx;
 
 	ice_vsi_free_stats(vsi);
 	ice_vsi_free_arrays(vsi);
@@ -690,23 +687,22 @@ ice_vsi_alloc(struct ice_pf *pf, struct ice_port_info *pi,
 	vsi->vf = vf;
 	set_bit(ICE_VSI_DOWN, vsi->state);
 
-	if (vsi->type == ICE_VSI_CTRL && !vf) {
-		/* Use the last VSI slot as the index for PF control VSI */
-		vsi->idx = pf->num_alloc_vsi - 1;
-		pf->ctrl_vsi_idx = vsi->idx;
-		pf->vsi[vsi->idx] = vsi;
-	} else {
-		/* fill slot and make note of the index */
-		vsi->idx = pf->next_vsi;
-		pf->vsi[pf->next_vsi] = vsi;
+	/* fill slot and make note of the index */
+	vsi->idx = pf->next_vsi;
+	pf->vsi[pf->next_vsi] = vsi;
 
-		/* prepare pf->next_vsi for next use */
-		pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
-						 pf->next_vsi);
-	}
+	/* prepare pf->next_vsi for next use */
+	pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
+					 pf->next_vsi);
 
-	if (vsi->type == ICE_VSI_CTRL && vf)
-		vf->ctrl_vsi_idx = vsi->idx;
+	if (vsi->type == ICE_VSI_CTRL) {
+		if (vf) {
+			vf->ctrl_vsi_idx = vsi->idx;
+		} else {
+			WARN_ON(pf->ctrl_vsi_idx != ICE_NO_VSI);
+			pf->ctrl_vsi_idx = vsi->idx;
+		}
+	}
 
 unlock_pf:
 	mutex_unlock(&pf->sw_mutex);
-- 
2.38.1

