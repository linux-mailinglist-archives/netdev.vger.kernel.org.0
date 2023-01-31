Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6C6838C3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjAaVhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjAaVhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:15 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8620C4B898;
        Tue, 31 Jan 2023 13:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201034; x=1706737034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kDwxQ07zSjap/s3q+8IBB7CPjjvYUNS9xoYkOw4SLrQ=;
  b=TrmmSWMwFuB1Qu+w8bW6bWujwTPPQ7PfM98pIl2j5K6iBN5L2LvMYMLR
   iprZPWedpKs8fAOuVOL65bP5DMI9KeXIDhVmZtxVY87K/9OwQ9JPTjzDm
   Nl2cyzZ3vIzMWofym2BOaMmXjcz0agG1e6cAJ5p/UUJY2NKwFBBkDQ84g
   W92usa/r71FI6Qfs5ePpHaplZZRBwUpILW3GnYHyV4txLwO2UNYD77gN8
   7/sFv7nS/mJal8t3xMO/WShJ6IgzgBPHSuYpVztBenYDcBQXC6jvROakh
   AbtLglkx79+e8ezOjhCrkMG+RhuIy/hP1PoE5/qDSkYyLef+P5GSoGkEZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980271"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980271"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063006"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063006"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, poros@redhat.com, ivecera@redhat.com,
        shiraz.saleem@intel.com, mustafa.ismail@intel.com, jgg@nvidia.com,
        leonro@nvidia.com, linux-rdma@vger.kernel.org,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug under RTNL lock
Date:   Tue, 31 Jan 2023 13:36:58 -0800
Message-Id: <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
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

Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Link: https://lore.kernel.org/linux-rdma/68b14b11-d0c7-65c9-4eeb-0487c95e395d@leemhuis.info/
Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
 drivers/net/ethernet/intel/ice/ice_main.c | 17 +++++++----------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 713069f809ec..3cad5e6b2ad1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -506,6 +506,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_UNPLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
@@ -950,16 +951,11 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
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
index 5f86e4111fa9..055494dbcce0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2290,18 +2290,15 @@ static void ice_service_task(struct work_struct *work)
 		}
 	}
 
-	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
-		/* Plug aux device per request */
+	/* Plug aux device per request */
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
 		ice_plug_aux_dev(pf);
 
-		/* Mark plugging as done but check whether unplug was
-		 * requested during ice_plug_aux_dev() call
-		 * (e.g. from ice_clear_rdma_cap()) and if so then
-		 * plug aux device.
-		 */
-		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
-			ice_unplug_aux_dev(pf);
-	}
+	/* unplug aux dev per request, if an unplug request came in
+	 * while processing a plug request, this will handle it
+	 */
+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
 
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
-- 
2.38.1

