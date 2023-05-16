Return-Path: <netdev+bounces-3061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BBC705528
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9EB2281653
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BA2156F6;
	Tue, 16 May 2023 17:39:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B1D1429D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:39:56 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA36E99
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684258795; x=1715794795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cVTFeU3opN9F3ADQLz1yS1j8sAMuymKPChbK4ybnuSA=;
  b=lH43cR6eL9rLjZa4NvgaMLhcs5rZtqFnXBVEOcsENRuAB2LRtkKFfLxn
   ZUAdYXIPs5ZviO6fysO+8b6YqPJzsKTAxjcsIf0fY1icv2a7evwUpSyWH
   4a4A0RWWFftZ2BH5rswS+G4H0QQsKozivLoY6j4prQ/XXk+jHiTQbyTtX
   /6K8hR+PmGsGEyjpFGGLQzmxpqNI5EaogVVkguFQuHv836eA5nvOOvInR
   gFRMAaooX187bFjXyHuDv/N2jJ/UCx3lIk1sh6pHngQ0RSzLWqxLH3fRH
   XzSYePwsrvD7WpN15ug4yLdKU5xoUHN7QxaqLMiALJBx29QW9MHquAYtL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379730755"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="379730755"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="704489423"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="704489423"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2023 10:39:52 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Ahmed Zaki <ahmed.zaki@intel.com>,
	anthony.l.nguyen@intel.com,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net v2 3/3] iavf: send VLAN offloading caps once after VFR
Date: Tue, 16 May 2023 10:36:10 -0700
Message-Id: <20230516173610.2706835-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
References: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ahmed Zaki <ahmed.zaki@intel.com>

When the user disables rxvlan offloading and then changes the number of
channels, all VLAN ports are unable to receive traffic.

Changing the number of channels triggers a VFR reset. During re-init, when
VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is received, we do:
1 - set the IAVF_FLAG_SETUP_NETDEV_FEATURES flag
2 - call
    iavf_set_vlan_offload_features(adapter, 0, netdev->features);

The second step sends to the PF the __default__ features, in this case
aq_required |= IAVF_FLAG_AQ_ENABLE_CTAG_VLAN_STRIPPING

While the first step forces the watchdog task to call
netdev_update_features() ->  iavf_set_features() ->
iavf_set_vlan_offload_features(adapter, netdev->features, features).
Since the user disabled the "rxvlan", this sets:
aq_required |= IAVF_FLAG_AQ_DISABLE_CTAG_VLAN_STRIPPING

When we start processing the AQ commands, both flags are enabled. Since we
process DISABLE_XTAG first then ENABLE_XTAG, this results in the PF
enabling the rxvlan offload. This breaks all communications on the VLAN
net devices.

Fix by removing the call to iavf_set_vlan_offload_features() (second
step). Calling netdev_update_features() from watchdog task is enough for
both init and reset paths.

Fixes: 7598f4b40bd6 ("iavf: Move netdev_update_features() into watchdog task")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 9afbbdac3590..7c0578b5457b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2238,11 +2238,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 
-		/* Request VLAN offload settings */
-		if (VLAN_V2_ALLOWED(adapter))
-			iavf_set_vlan_offload_features(adapter, 0,
-						       netdev->features);
-
 		iavf_set_queue_vlan_tag_loc(adapter);
 
 		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
-- 
2.38.1


