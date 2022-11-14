Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC46C6280F6
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiKNNNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiKNNMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DC727B2A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431566; x=1699967566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KpfNIjp3GXxfULG/7bGrVA214jUNUf6R3CPFkLj7qaQ=;
  b=nfAE+IPdGYGz9vHxRFFrGcFNdkharr5gr0tL3oS8Wa6TILwuTlAuBWE9
   wOVk+8jT453CV6m5JdQtrJr4xR3KEzjIx197f6B6G82kjwKk2E5bInkgX
   8LEFNsbu7E510Bd8fpfeN3zn1zQ7iJ9hFsYfJCair+9qgjy6OTiujG6jP
   WXx60gK2vepW+PoQnlCRhPO/B5v0ezU2olW+rnZpxq4H0SyVT6mrcOdjq
   a6l56vLk7rzeIukE3gKjA38LLJoHQGPE2zebK+YWGiEnb9alK7K+CzkYR
   ij6LM91Gc2O2GJJYm0/GVOooDQUA6vXvwbpB2LMljjc0xWIf/UPKmvR8f
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313110658"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313110658"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616306070"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616306070"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:41 -0800
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
Subject: [PATCH net-next 11/13] ice: introduce eswitch capable flag
Date:   Mon, 14 Nov 2022 13:57:53 +0100
Message-Id: <20221114125755.13659-12-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag is used to check if hardware support eswitch mode. Block going
to switchdev if the flag is unset.

It can be also use to turn the eswitch feature off to save MSI-X
interrupt.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 1 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 62219f995cf2..df1f6d85cd43 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -501,6 +501,7 @@ enum ice_pf_flags {
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
+	ICE_FLAG_ESWITCH_CAPABLE,	/* switchdev mode can be supported */
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index f9f15acae90a..8532d5c47bad 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -554,6 +554,12 @@ ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		return -EOPNOTSUPP;
 	}
 
+	if (!test_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags)) {
+		dev_info(ice_pf_to_dev(pf), "There is no support for switchdev in hardware");
+		NL_SET_ERR_MSG_MOD(extack, "There is no support for switchdev in hardware");
+		return -EOPNOTSUPP;
+	}
+
 	switch (mode) {
 	case DEVLINK_ESWITCH_MODE_LEGACY:
 		dev_info(ice_pf_to_dev(pf), "PF %d changed eswitch mode to legacy",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9766032e95ec..0dfc427e623a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3739,8 +3739,10 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	clear_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
+	clear_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags);
 	if (func_caps->common_cap.sr_iov_1_1) {
 		set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
+		set_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags);
 		pf->vfs.num_supported = min_t(int, func_caps->num_allocd_vfs,
 					      ICE_MAX_SRIOV_VFS);
 	}
@@ -3881,7 +3883,8 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		v_other += ICE_FDIR_MSIX;
 
 	/* switchdev */
-	v_other += ICE_ESWITCH_MSIX;
+	if (test_bit(ICE_FLAG_ESWITCH_CAPABLE, pf->flags))
+		v_other += ICE_ESWITCH_MSIX;
 
 	v_wanted = v_other;
 
-- 
2.36.1

