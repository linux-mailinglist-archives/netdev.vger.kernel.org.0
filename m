Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B365CA31
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbjACXHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjACXGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:06:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A00140ED
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787215; x=1704323215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o3EPrhaowlw3s8kQW8VnO9J5c16ScaIWGQS3MCf7Kmw=;
  b=lTcB9VCOSC58kfnw4cYEne94cdVEKdWLKL9iK3wUXAD0ZLd9N/B/yKId
   mtrxyGoV7GmLL6sZwfJ4r7FYfYxs8Lsup8Iyk/S8xsSNLKyVCF+wN6toT
   VS/hDv9ti8qncutF3niI9tErZ/P5cddetRgL7iTWnTSxJTTuSoLxfJanE
   mIWa6GC3dKfEvMnMTb44nEf5iM9YsU8v/U/yGVJ70+KcGKjHB89oirpJW
   jDBGeG8FLXzsVmt4UoU+UGukslc+RS05RW4XY6uSg968W7lTWtFJIwBgz
   EIJVbOWGVlSrvZWkg3DSMnnQYKOJhP1EnGwHIvbC1f00bliKDKnLdXUoF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="319487141"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="319487141"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:06:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="828982742"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="828982742"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 03 Jan 2023 15:06:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net v2 2/3] ice: Fix deadlock on the rtnl_mutex
Date:   Tue,  3 Jan 2023 15:07:37 -0800
Message-Id: <20230103230738.1102585-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
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

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

There is a deadlock on rtnl_mutex when attempting to take the lock
in unregister_netdev() after it has already been taken by
ethnl_set_channels(). This happened when unregister_netdev() was
called inside of ice_vsi_rebuild().
Fix that by removing the unregister_netdev() usage and replace it with
ice_vsi_clear_rings() that deallocates the tx and rx rings for the VSI.

Fixes: df0f847915b4 ("ice: Move common functions out of ice_main.c part 6/7")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..22bcb414546a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3619,12 +3619,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 err_vectors:
 	ice_vsi_free_q_vectors(vsi);
 err_rings:
-	if (vsi->netdev) {
-		vsi->current_netdev_flags = 0;
-		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
+	ice_vsi_clear_rings(vsi);
+	set_bit(ICE_RESET_FAILED, pf->state);
+	kfree(coalesce);
+	return ret;
 err_vsi:
 	ice_vsi_clear(vsi);
 	set_bit(ICE_RESET_FAILED, pf->state);
-- 
2.38.1

