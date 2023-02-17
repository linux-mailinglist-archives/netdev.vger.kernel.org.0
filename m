Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7C69A30E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBQAnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBQAnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:43:52 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2BC54D5F;
        Thu, 16 Feb 2023 16:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676594631; x=1708130631;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qySiZkvggoa24YJ/7eU/T7MEfg7x97LfSVCbgqbZKlA=;
  b=gH2SPDiPVm9jgxddl0kVgFj6a1UqRvpYnyfNwW9BWR7qOMa70Rikm03T
   U4TZSwvNufKP50QFmMzlzuX7trYG32nSlINbqy591zlRFg1BitiXvsqdI
   Tkt9JxRpNGqPKQHStQWOL0gu0TzHIlnItsAZ7RDMaWzqLXGVTzhInMQ+g
   o4AgLw1tbu4fZezq6iAl0rL/c5OOIvQhnaG/4gC1nlxsZbioJHnpkYs3Y
   JxUkOQKSpE7CVN51ELkJNQrtjrzlpEDP28psqQs+JW/iFYQZ/A6WSKPaG
   /VHqlhrpkPZXFxviBKEH+QJVTtPxcj8YzugJGDtERAeRFVXO84oLry//C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="330536422"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="330536422"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 16:42:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="759180044"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="759180044"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Feb 2023 16:42:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jgg@nvidia.com, leonro@nvidia.com,
        linux-rdma@vger.kernel.org, poros@redhat.com, ivecera@redhat.com,
        stable@vger.kernel.org,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Subject: [PATCH net v2 1/1] ice: avoid bonding causing auxiliary plug/unplug under RTNL lock
Date:   Thu, 16 Feb 2023 16:42:01 -0800
Message-Id: <20230217004201.2895321-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

Cc: stable@vger.kernel.org # 6.1.x
Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Link: https://lore.kernel.org/netdev/CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com/
Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2:
 (Removed from original pull request)
- Reversed order of bit processing in ice_service_task for PLUG/UNPLUG

v1: https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/

 drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
 drivers/net/ethernet/intel/ice/ice_main.c | 19 ++++++++-----------
 2 files changed, 13 insertions(+), 20 deletions(-)

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
index 8ec24f6cf6be..10d1c5b10d2a 100644
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

