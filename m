Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A872862207A
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKHXwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKHXwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:52:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B707F5E9D2
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667951520; x=1699487520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7yoj69J6jdN+rk0wBC1jjvxRbjif9QjJvU2pqlQsJTk=;
  b=f4zSXUM8jMta3GruL9sdH4uPXRokgW+ijdy/nDpD6DtyvMhcvA4BLtvc
   SPHEVxEAi5NvtfFzBTzQcDautfvS3e/29OzNpK0O+wNKBy2XesGP3VVMH
   qi0LmW+K9CdQlVccyaL1v8ScD1PZalyR0ZWzjxxQREy1ZimY9VMBCwPLX
   NOhp2jzjZrR2Pu8KnSN8wDQZVQZsi3yoMFwGfCaPToFrPVFASrI6FI8Rc
   xT039OERhT8otiMbausQYDOk9bQQpGHpVoHkCABk7emdh++BrI+hFeCs+
   /vnhgojYWgUbJPMH/neuzdHaXRvT6whdnfFDrwN2r/2EczERJKLpB0sYh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290556988"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290556988"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 15:51:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667777840"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="667777840"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 15:51:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/3] iavf: Fix VF driver counting VLAN 0 filters
Date:   Tue,  8 Nov 2022 15:51:16 -0800
Message-Id: <20221108235116.3522941-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
References: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

VF driver mistakenly counts VLAN 0 filters, when no PF driver
counts them.
Do not count VLAN 0 filters, when VLAN_V2 is engaged.
Counting those filters in, will affect filters size by -1, when
sending batched VLAN addition message.

Fixes: 968996c070ef ("iavf: Fix VLAN_V2 addition/rejection")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 5a9e6563923e..24a701fd140e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2438,6 +2438,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->is_new_vlan) {
 				f->is_new_vlan = false;
+				if (!f->vlan.vid)
+					continue;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.35.1

