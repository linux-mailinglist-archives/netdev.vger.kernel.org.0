Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286EF646317
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiLGVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiLGVLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:11:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B378281D96
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447460; x=1701983460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mv2xPLSBh+M05FRkRhrO17yRd1J2J/VSJ/uL1lhkJCk=;
  b=A90GTovBCZ2SML4cD7cN+NdBXUlcFP7ywVjLdt+LQGZRWM+mPIiMiRy0
   eZJmibY0UhjTnD4pP9i9MXugccUWQKcUTUHGgnFRdKikQUU8nPnBz+X9U
   3UOCCDfPJyJ7e1KLAVT91BRU2wIY5L1j3hsZDMBzK2kmZsaVJkB4sWQm+
   opft7UdX6xS3tBGo/l8HUQ0yn5oqhTifViF8MHpivv3YljJNWwUe/Lo7N
   eds2ocA93VxKzNR4GzpKalc6OVz+vejz+7SiFpQ45DK9k0nZI4ubwbYL/
   SfQp1mrZRrAenflwJ8mB99qkbk2CrddsS+/WehNKRjsvEE4NQnBQizXur
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344047310"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="344047310"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679280200"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="679280200"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 13:10:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/4] ice: Fix deadlock on the rtnl_mutex
Date:   Wed,  7 Dec 2022 13:10:39 -0800
Message-Id: <20221207211040.1099708-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 7276badfa19e..96098c8b5daf 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3395,12 +3395,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
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
2.35.1

