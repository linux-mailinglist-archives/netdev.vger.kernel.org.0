Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B547E6B5124
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 20:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCJTuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 14:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCJTuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 14:50:06 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C63114EFC;
        Fri, 10 Mar 2023 11:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678477804; x=1710013804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RLeuSDeYEyk4kx513lFWd3l6mmPrV+H3HLmCodnlDcQ=;
  b=I5dzVzfPY25n3QAGJp87odZVlNRkxLi5UJp9Qy89Xwe33u5/S6LyWFFo
   IVCV05MY5qiJIuUJmgg4zlm57DYPHewxjealTMV0qfuqqpaqZ+Qmlnopa
   sVs3oJHireY8KQGNbGwSdllXWRbPpT6xT3TmEWw7r3BGG382xITsbp1rW
   K3cS7Z7WrXTpNUFfGcSlSTqY+ojBzXPui7ZIfGMfmWy3HrVxXvmgZxH7d
   1LO3OBZ46iDpOSOlOfRNgADEdxq0/yKjmjvpjWqAUvSGbU4P4y2wB/csR
   xJyWTuXJeINNmxoUrE5KVBq3oirdS7Qt8uuP27aHWaabmvbGyP+iFt1au
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="325171789"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="325171789"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 11:50:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="655283347"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="655283347"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 10 Mar 2023 11:50:03 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com, mustafa.ismail@intel.com, jgg@nvidia.com,
        leonro@nvidia.com, linux-rdma@vger.kernel.org, poros@redhat.com,
        ivecera@redhat.com, jaroslav.pulchart@gooddata.com,
        git@sphalerite.org, stable@vger.kernel.org,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net v3 1/1] ice: avoid bonding causing auxiliary plug/unplug under RTNL lock
Date:   Fri, 10 Mar 2023 11:48:33 -0800
Message-Id: <20230310194833.3074601-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

RDMA is not supported in ice on a PF that has been added to a bonded
interface. To enforce this, when an interface enters a bond, we unplug
the auxiliary device that supports RDMA functionality.  This unplug
currently happens in the context of handling the netdev bonding event.
This event is sent to the ice driver under RTNL context.  This is causing
a deadlock where the RDMA driver is waiting for the RTNL lock to complete
the removal.

Defer the unplugging/re-plugging of the auxiliary device to the service
task so that it is not performed under the RTNL lock context.

Cc: stable@vger.kernel.org # 6.1.x
Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Link: https://lore.kernel.org/netdev/CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com/
Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Note:
This was reported as still causing issues [1], however, with details from
the reporter we have not been able to reproduce the issue; a newer
firmware was reported to fix their problem [2]. As this fixes the bug for
other users [3][4], I'm submitting this patch.

v3:
- Add Tested-by

v2: https://lore.kernel.org/netdev/20230217004201.2895321-1-anthony.l.nguyen@intel.com/
 (Removed from original pull request)
- Reversed order of bit processing in ice_service_task for PLUG/UNPLUG

v1: https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/

[1] https://lore.kernel.org/intel-wired-lan/ygay1oxikvo.fsf@localhost/
[2] https://lore.kernel.org/intel-wired-lan/ygattz3tjk9.fsf@localhost/
[3] https://lore.kernel.org/netdev/CAK8fFZ5Jjh-ZXfLdupQGqvb9pg7nW-6fWMN3cPMdmQQfQRLGFA@mail.gmail.com/
[4] https://lore.kernel.org/intel-wired-lan/16c393e17c552cbf0c3456194456d32ea8bc826a.camel@redhat.com/

 drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
 drivers/net/ethernet/intel/ice/ice_main.c | 19 ++++++++-----------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b0e29e342401..e809249500e1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -509,6 +509,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_UNPLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
@@ -955,16 +956,11 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
-	/* We can directly unplug aux device here only if the flag bit
-	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
-	 * could race with ice_plug_aux_dev() called from
-	 * ice_service_task(). In this case we only clear that bit now and
-	 * aux device will be unplugged later once ice_plug_aux_device()
-	 * called from ice_service_task() finishes (see ice_service_task()).
+	/* defer unplug to service task to avoid RTNL lock and
+	 * clear PLUG bit so that pending plugs don't interfere
 	 */
-	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-		ice_unplug_aux_dev(pf);
-
+	clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 567694bf098b..c233464b8f6b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2316,18 +2316,15 @@ static void ice_service_task(struct work_struct *work)
 		}
 	}
 
-	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
-		/* Plug aux device per request */
-		ice_plug_aux_dev(pf);
+	/* unplug aux dev per request, if an unplug request came in
+	 * while processing a plug request, this will handle it
+	 */
+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
 
-		/* Mark plugging as done but check whether unplug was
-		 * requested during ice_plug_aux_dev() call
-		 * (e.g. from ice_clear_rdma_cap()) and if so then
-		 * plug aux device.
-		 */
-		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-			ice_unplug_aux_dev(pf);
-	}
+	/* Plug aux device per request */
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
 
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
-- 
2.38.1

