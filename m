Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CBB6C3948
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCUSif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCUSid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:38:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28A1A671
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423911; x=1710959911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UEgvDwQwSI/QhrKT6GnKITQvGuANGUgSRFz+PwMWqMg=;
  b=DuDNRX4HDJSp28aelD+FAYVz1LghoxA+HBiMRQ47871wodgqc8xgx8xv
   HE9G68A5jSoSKhH+XyNxMmXUFgkXEHYEWk7BVd3qdsJlX+hXl5fVbNBOp
   JGIEBDJD8/18Qz0FLxoYq3ePlmELdVcTCL18Kb36MJnd3KPiW2Erfb0pJ
   pmHW7S4jb+H++zIAsWkxKfvz0Pt0DUdxIKt7abmdn1R8Uzd3w1KhDfm1W
   iPh824uHgAFT68786qiMYI43HsM9aMeZcXtOh3eWhm9YuIRn96OAiQUWZ
   /qZ/dTejzUKsRJFAKW5EX0XsUL2K/N24xQueeH4AoMxw6K/ECJ2X9u8Jo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339067633"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="339067633"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="684001765"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="684001765"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 11:38:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        anthony.l.nguyen@intel.com,
        Kalyan Kodamagula <kalyan.kodamagula@intel.com>,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net 2/3] ice: check if VF exists before mode check
Date:   Tue, 21 Mar 2023 11:36:40 -0700
Message-Id: <20230321183641.2849726-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
References: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Setting trust on VF should return EINVAL when there is no VF. Move
checking for switchdev mode after checking if VF exists.

Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Kalyan Kodamagula <kalyan.kodamagula@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 96a64c25e2ef..0cc05e54a781 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1341,15 +1341,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	struct ice_vf *vf;
 	int ret;
 
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
 	if (ice_is_eswitch_mode_switchdev(pf)) {
 		dev_info(ice_pf_to_dev(pf), "Trusted VF is forbidden in switchdev mode\n");
 		return -EOPNOTSUPP;
 	}
 
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return -EINVAL;
-
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
-- 
2.38.1

