Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3030965CA30
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbjACXG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbjACXGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:06:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5256D13F3C;
        Tue,  3 Jan 2023 15:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787215; x=1704323215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J9kqNSFqVrC9+Gi6shL7a7CY8EjR4B2p6ROAEfreT6g=;
  b=LFV0DlyoGAxjE1fsp1tDtk4rZY/WJx9Eq2UqUBAmbB/2Wz/QN8JWjj/6
   ME6jAiTot0azB/iqXAmwrf7Bchj5d8RFcl5bdyOaNeVP4tIhxndB1y1Pe
   ytu0551KpnWR6vuNUyWDcG7FFs2InrxRJzJsqII7FTHF9la2l6ruwasDE
   yy6le3dHVo5VgcHmPie/I4pNyK07+WiqQ3HF40zI+4i9ZRh4UT9awvPYp
   MNO6EDK0PCEIT53NoAwRiTN3cpIwMf3Wopkslq12HFDBc4EN/1DNafISL
   UAqeB0K5zE2orOim9UsGkAcCARdK119yvHOsAnqRMp++5tgBYNnWwTHSV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="319487136"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="319487136"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:06:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="828982739"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="828982739"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 03 Jan 2023 15:06:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jgg@nvidia.com, leonro@nvidia.com,
        linux-rdma@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net v2 1/3] ice: Prevent set_channel from changing queues while RDMA active
Date:   Tue,  3 Jan 2023 15:07:36 -0800
Message-Id: <20230103230738.1102585-2-anthony.l.nguyen@intel.com>
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

From: Dave Ertman <david.m.ertman@intel.com>

The PF controls the set of queues that the RDMA auxiliary_driver requests
resources from.  The set_channel command will alter that pool and trigger a
reconfiguration of the VSI, which breaks RDMA functionality.

Prevent set_channel from executing when RDMA driver bound to auxiliary
device.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4191994d8f3a..bb6252e9cf59 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3642,6 +3642,7 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct ice_pf *pf = vsi->back;
 	int new_rx = 0, new_tx = 0;
 	u32 curr_combined;
+	int ret = 0;
 
 	/* do not support changing channels in Safe Mode */
 	if (ice_is_safe_mode(pf)) {
@@ -3705,15 +3706,26 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
+	mutex_lock(&pf->adev_mutex);
+	if (pf->adev && pf->adev->dev.driver) {
+		netdev_err(dev, "Cannot change channels when RDMA is active\n");
+		ret = -EINVAL;
+		goto adev_unlock;
+	}
+
 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
 
-	if (!netif_is_rxfh_configured(dev))
-		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+	if (!netif_is_rxfh_configured(dev)) {
+		ret = ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+		goto adev_unlock;
+	}
 
 	/* Update rss_size due to change in Rx queues */
 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
 
-	return 0;
+adev_unlock:
+	mutex_unlock(&pf->adev_mutex);
+	return ret;
 }
 
 /**
-- 
2.38.1

