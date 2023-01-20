Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03FC675F79
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjATVMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjATVMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:12:15 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CD68B328
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674249134; x=1705785134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tHhAwomYDPenxStKVB9SX8I75DgdeZM0qRpcb2NsqiM=;
  b=itFx4/pqYjdEnGckVM4OdwyVTvTVinXY4b8hfhkH5eN3LWi1AE/MUxo1
   TsrBsk0fz/pjV7WtrRJZc7zIO1LmPg0N+oG1mN493JoyHzRcKSlD8iu6J
   Xr8N4A0KzocqkEfcDYPiaxw6u1vZ0fakEXXw/xDS0x0n7FRc6MOFjJi3C
   +zSbKHvdV++y/gCOiSAlZ/roGqITeCAK+x4tGUWZRBlWsR85wuYaMfjHn
   8EA+HZwdKItoJ1V1rG7Iss1wXg6l27uBcEd6ePmBXik+Smx5x1A/JH/wt
   hUgEIyWaqABEJAqE/o/JY5OkSJN6bKxWoBTnL3MSHX449ex6RiPo45QFS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="324383374"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="324383374"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 13:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="653921173"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="653921173"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 20 Jan 2023 13:12:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, leonro@nvidia.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net v3 1/2] ice: Prevent set_channel from changing queues while RDMA active
Date:   Fri, 20 Jan 2023 13:12:30 -0800
Message-Id: <20230120211231.431147-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120211231.431147-1-anthony.l.nguyen@intel.com>
References: <20230120211231.431147-1-anthony.l.nguyen@intel.com>
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
Co-developed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4191994d8f3a..16006eedfceb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3705,6 +3705,14 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
+	mutex_lock(&pf->adev_mutex);
+	if (pf->adev && pf->adev->dev.driver) {
+		netdev_err(dev, "Cannot change channels when RDMA is active\n");
+		mutex_unlock(&pf->adev_mutex);
+		return -EINVAL;
+	}
+	mutex_unlock(&pf->adev_mutex);
+
 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
 
 	if (!netif_is_rxfh_configured(dev))
-- 
2.38.1

