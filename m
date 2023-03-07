Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411DC6AF842
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjCGWIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCGWIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:08:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C08943B8
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678226915; x=1709762915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uatTSWFzA4NccItdiirQb1EygGKUDjG8zmngX5CiXQ8=;
  b=XRMhF5MZEk9jrNMaOo7Cag49fq9mH4jZPeAFiMk7bB4qEjiCQfiPdrfc
   4h1pP03Xkb1ygzp3GbWVYdF0ARvw9CIlm7aTZ0OVxL8NlO1vookMp4PfY
   1HYyCalxvg/7rp4EtlKcq3iZe+veNzOwhVNMcj1MrJ6wMyHIinBvpjmz8
   BYFFUZNc9eH6GDGd8CLoVMpJkDE9cCfZ0zHNQ0mfSbV0rceNj6EokZmM0
   Vbd8VYY8biGCVPCI7JlqvlYiZNvhbxlMZflVp1aK2CoqHIHkBNtYTpxNh
   gWuRH02HHFA7N06qpDlXGXFE6kKUDKBYg/YQsFZNajsoMjCr0Q8179uX/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316386703"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="316386703"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:08:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="654123238"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="654123238"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 14:08:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        anthony.l.nguyen@intel.com, Dan Carpenter <error27@gmail.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/3] ice: don't ignore return codes in VSI related code
Date:   Tue,  7 Mar 2023 14:07:13 -0800
Message-Id: <20230307220714.3997294-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
References: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

There were few smatch warnings reported by Dan:
- ice_vsi_cfg_xdp_txqs can return 0 instead of ret, which is cleaner
- return values in ice_vsi_cfg_def were ignored
- in ice_vsi_rebuild return value was ignored in case rebuild failed,
  it was a never reached code, however, rewrite it for clarity.
- ice_vsi_cfg_tc can return 0 instead of ret

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 781475480ff2..0f52ea38b6f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2126,7 +2126,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 	ice_for_each_rxq(vsi, i)
 		ice_tx_xsk_pool(vsi, i);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -2693,12 +2693,14 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 		return ret;
 
 	/* allocate memory for Tx/Rx ring stat pointers */
-	if (ice_vsi_alloc_stat_arrays(vsi))
+	ret = ice_vsi_alloc_stat_arrays(vsi);
+	if (ret)
 		goto unroll_vsi_alloc;
 
 	ice_alloc_fd_res(vsi);
 
-	if (ice_vsi_get_qs(vsi)) {
+	ret = ice_vsi_get_qs(vsi);
+	if (ret) {
 		dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
 			vsi->idx);
 		goto unroll_vsi_alloc_stat;
@@ -2811,6 +2813,7 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 		break;
 	default:
 		/* clean up the resources and exit */
+		ret = -EINVAL;
 		goto unroll_vsi_init;
 	}
 
@@ -3508,10 +3511,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags)
 		if (vsi_flags & ICE_VSI_FLAG_INIT) {
 			ret = -EIO;
 			goto err_vsi_cfg_tc_lan;
-		} else {
-			kfree(coalesce);
-			return ice_schedule_reset(pf, ICE_RESET_PFR);
 		}
+
+		kfree(coalesce);
+		return ice_schedule_reset(pf, ICE_RESET_PFR);
 	}
 
 	ice_vsi_realloc_stat_arrays(vsi, prev_txq, prev_rxq);
@@ -3759,7 +3762,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 	dev = ice_pf_to_dev(pf);
 	if (vsi->tc_cfg.ena_tc == ena_tc &&
 	    vsi->mqprio_qopt.mode != TC_MQPRIO_MODE_CHANNEL)
-		return ret;
+		return 0;
 
 	ice_for_each_traffic_class(i) {
 		/* build bitmap of enabled TCs */
-- 
2.38.1

