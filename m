Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6662D6EE64D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjDYREc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbjDYRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:04:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3B5595
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682442266; x=1713978266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4PsawchohG+ghTowaPvzr1yXJ2kABDRoddbJBxhCiAE=;
  b=m9kSfUfQe6Jl5D/SKXAUtiWE7aljVQZTM0Uo188b/uuaXgiIdPf+OFEE
   QlR8Ljc3XBqQa3+qCCB6TXMvzdjxazKVwRfQU2rrcvtBUOLYA2+HLuVVd
   NwTo29ejTOUgjovcpJRu7MEwgSeqqaq3kMzgwGbaHZd439w88p5EhTU68
   zmwW0aeLDJHj/1DE/eDIA6cppkbvFN0sU9XnJ4RvxsNMqcJ/sy9kdO/o5
   mW0GZ5fPCGbIuFpjyRLRVYbPqgp0gv7e1WB9n7SCniMegoPi14RE+cJW7
   yoDhlXt1jz3KxvIHFIBT5EwKma7jhqw5U+inv8BU0dv2Xm3hXTiqP5OZd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326436785"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="326436785"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 10:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724085197"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="724085197"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 10:04:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>, anthony.l.nguyen@intel.com,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 3/3] iavf: send VLAN offloading caps once after VFR
Date:   Tue, 25 Apr 2023 10:01:27 -0700
Message-Id: <20230425170127.2522312-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

