Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C43868CA91
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjBFXan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBFXag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:30:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD92D154
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675726212; x=1707262212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJ67XjbDYBY3so3XMTgmyMqr8MJRd7va21IbeQuGg0I=;
  b=diZjDcGn+04XuLVotvfnjYLLMREmbx2bV0KzDypPyku1e9QKqEcMuvXw
   ltmUC94ytDLPY7hpdSStLvvyBtdo2QSRaPAJ8ZPaLnTW9+XslnsQCg1L+
   /f/YHA++vNLXaRpcCi0+sTleZ7N6bN2Of9ACLpRAkqBjBYvRve+LZMHxh
   3HJ2NT2s3vmoZDsoi7zOT/AAQngyLf5yJEkbpVOSZJ578zxAjd40rQ4lT
   dyMpVDcPrjK6RrL9/7qbjRCBiFNVWHPmfUUTmkHNhPCEadzXhcKMkM7GH
   dR+wKn3hUWVadkdIo+E5YBMlzdFXZG6V+9N/sa5nSi5S+sSsxHspbXbpx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309678423"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309678423"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:29:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809305672"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809305672"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 15:29:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net v2 4/5] ice: Fix off by one in ice_tc_forward_to_queue()
Date:   Mon,  6 Feb 2023 15:29:33 -0800
Message-Id: <20230206232934.634298-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
References: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

The > comparison should be >= to prevent reading one element beyond
the end of the array.

The "vsi->num_rxq" is not strictly speaking the number of elements in
the vsi->rxq_map[] array.  The array has "vsi->alloc_rxq" elements and
"vsi->num_rxq" is less than or equal to the number of elements in the
array.  The array is allocated in ice_vsi_alloc_arrays().  It's still
an off by one but it might not access outside the end of the array.

Fixes: 143b86f346c7 ("ice: Enable RX queue selection using skbedit action")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Amritha Nambiar <amritha.nambiar@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index faba0f857cd9..95f392ab9670 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1681,7 +1681,7 @@ ice_tc_forward_to_queue(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
 	struct ice_vsi *ch_vsi = NULL;
 	u16 queue = act->rx_queue;
 
-	if (queue > vsi->num_rxq) {
+	if (queue >= vsi->num_rxq) {
 		NL_SET_ERR_MSG_MOD(fltr->extack,
 				   "Unable to add filter because specified queue is invalid");
 		return -EINVAL;
-- 
2.38.1

