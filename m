Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5ED649E00
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiLLLgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiLLLf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:35:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17EE62F3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844788; x=1702380788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=blZt6kNB7h+IVWZ2yD3/Bndv24v3tOAAvbW91M+5zkg=;
  b=ljQ7M9DxjNxqKXvO0aDzBSriGIHZO+HB2RjMLwpTgV8HcK7h5Roo6n2+
   8i02Zr3sV0bftsnnYdZu2jWmYN8HWVn1rNBaSj4RqdUWsJCCG+/ySnU30
   2BHO19c0O+rgHMlE08UwuDhQjUEmE36Pj31L8OQX2bPPxEpaSV91IHw96
   YwOVLvW/WgFFiK4T4LgAlK3AZ7UgnoPS4O5uF80Tl0j7ALTUJnLK+ykLg
   meubHSrNotSIe96uvWyAwBu3qVuVfrKJHTtPBlrw82inYSfTCM3YF++KQ
   bEN5XX7k4+HAG6s7zANfb0/H/Q+fG6QtYEwYNrXiU2eOOWioE6tmVRmKZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861485"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861485"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:33:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459764"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459764"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:33:03 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v1 05/10] ice: stop hard coding the ICE_VSI_CTRL location
Date:   Mon, 12 Dec 2022 12:16:40 +0100
Message-Id: <20221212111645.1198680-6-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 34 +++++++++++-------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 9549290c76ab..eba990120a06 100644
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
@@ -686,23 +683,22 @@ ice_vsi_alloc(struct ice_pf *pf, struct ice_port_info *pi,
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
2.36.1

