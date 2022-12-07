Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24915646316
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiLGVLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLGVL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:11:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B0981D93;
        Wed,  7 Dec 2022 13:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447460; x=1701983460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uieol7DQ1MjEjksnpZYK0PZqlxcGFDFI3msWTSoT4U8=;
  b=JFBmgCxwYw1bZzlUaSyOXEG4kMTxH4vnKMnG2WlbwW45UADds6AaloMg
   HeD7w3e+DlDOVU/iq/qBAc173lhbIJs8toBTTjFMYSkRJz7eWADCwcZUS
   kAjT+pK4eO5gUS+s/68vlOuscUebA/PRbSNG4QT22FfzuE2Puf9HcWBWm
   Inm/hMoIZc0NeTRuHlW3+0ChfsI7p5zK7/q8LztPTkhtb3PvQOd73CtzX
   DdYdgVcYNRlpNkBPGuhPkqdF7XP2EAyN9mrUec4IugDSuTKjBg8jNXrcf
   Qn2Wl1WmfraE/kXYuduzeUKKIPKbMD9xy9LhwFfe8z0MIEszzdq35TqSz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344047301"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="344047301"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679280195"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="679280195"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 13:10:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jgg@nvidia.com, leonro@nvidia.com,
        linux-rdma@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/4] ice: Correctly handle aux device when num channels change
Date:   Wed,  7 Dec 2022 13:10:38 -0800
Message-Id: <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
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

From: Dave Ertman <david.m.ertman@intel.com>

When the number of channels/queues changes on an interface, it is necessary
to change how those resources are distributed to the auxiliary device for
maintaining RDMA functionality.  To do this, the best way is to unplug, and
then re-plug the auxiliary device.  This will cause all current resource
allocation to be released, and then re-requested under the new state.

Since the set_channel command from ethtool comes in while holding the RTNL
lock, it is necessary to offset the plugging and unplugging of auxiliary
device to another context.  For this purpose, set the flags for UNPLUG and
PLUG in the PF state, then respond to them in the service task.

Also, since the auxiliary device will be unplugged/plugged at the end of
the flow, it is better to not send the event for TCs changing in the
middle of the flow.  This will prevent a timing issue between the events
and the probe/release calls conflicting.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_idc.c     | 3 +++
 drivers/net/ethernet/intel/ice/ice_main.c    | 3 +++
 4 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 001500afc4a6..092e572768fe 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -281,6 +281,7 @@ enum ice_pf_state {
 	ICE_FLTR_OVERFLOW_PROMISC,
 	ICE_VF_DIS,
 	ICE_CFG_BUSY,
+	ICE_SET_CHANNELS,
 	ICE_SERVICE_SCHED,
 	ICE_SERVICE_DIS,
 	ICE_FD_FLUSH_REQ,
@@ -485,6 +486,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_UNPLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b7be84bbe72d..37e174a19860 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3536,6 +3536,8 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
+	set_bit(ICE_SET_CHANNELS, pf->state);
+
 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
 
 	if (!netif_is_rxfh_configured(dev))
@@ -3543,6 +3545,10 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 
 	/* Update rss_size due to change in Rx queues */
 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
+	clear_bit(ICE_SET_CHANNELS, pf->state);
+
+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
+	set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 895c32bcc8b5..9bf6fa5ed4c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -37,6 +37,9 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	if (WARN_ON_ONCE(!in_task()))
 		return;
 
+	if (test_bit(ICE_SET_CHANNELS, pf->state))
+		return;
+
 	mutex_lock(&pf->adev_mutex);
 	if (!pf->adev)
 		goto finish;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d0f14e73e8da..d58f55a72ab3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2300,6 +2300,9 @@ static void ice_service_task(struct work_struct *work)
 		}
 	}
 
+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
+
 	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
 		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
-- 
2.35.1

