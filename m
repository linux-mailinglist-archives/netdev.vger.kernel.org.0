Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65E6280EB
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiKNNMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237949AbiKNNMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D872B631
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431537; x=1699967537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W8DRebUemNpzTl8h23j1odQJiwJ/RQ2puj1jmmHtHpY=;
  b=B5dP9MZuEiSYYxuhrWVzFScAsLRpPCQwhVTkWI4y33xb5QNmWZa++0Jz
   0j6sBDWRARr01pXni4hqz+/+lr2eWN3apiATX4pVEtUJL+9nnwYrhhPPk
   xVpCYDwTx+Rw2u3g1rkM5NnoXqFSeelEeBxu+ApxvoaTaXm5WwDc2wctc
   nbPJtdq75oJp20ZarY7CvYJ4q1gGPUZMvsu9Cq42UZg67O9fdblU0b7ao
   ZB8TwaR8qm5yVHIZun03nWJt88cSkgp1IXQR9xh3nWjkUBhGu16WYRJAT
   6p2enbcyil/Q12mw6gavLImYU8mmtuy/fkwohqpyLyrC0JUnR24lbm67p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291679915"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="291679915"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616305957"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616305957"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:12 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 05/13] ice: stop hard coding the ICE_VSI_CTRL location
Date:   Mon, 14 Nov 2022 13:57:47 +0100
Message-Id: <20221114125755.13659-6-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
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
index 298bb901e4e7..dc672af10c25 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -379,10 +379,7 @@ int ice_vsi_free(struct ice_vsi *vsi)
 	/* updates the PF for this cleared VSI */
 
 	pf->vsi[vsi->idx] = NULL;
-	if (vsi->idx < pf->next_vsi && vsi->type != ICE_VSI_CTRL)
-		pf->next_vsi = vsi->idx;
-	if (vsi->idx < pf->next_vsi && vsi->type == ICE_VSI_CTRL && vsi->vf)
-		pf->next_vsi = vsi->idx;
+	pf->next_vsi = vsi->idx;
 
 	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
@@ -540,23 +537,22 @@ ice_vsi_alloc(struct ice_pf *pf, struct ice_port_info *pi,
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

