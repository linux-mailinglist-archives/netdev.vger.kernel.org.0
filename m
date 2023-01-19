Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B592067451C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjASVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED2E9F3BD
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163687; x=1705699687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8b0PCKbukfti7OvFddjwUPlK+g5i2yGxhgsB2jNQ5kI=;
  b=EEIVlcBoJFB/FMn87VAJyDcVtTlEAU8mFDQSbFMcOF6CPYS+qyx/AIT6
   j3OuA3C3MTvpH/zQbxqDjWu6cYPtrt4cgMJY5uGtJFLTRFgELJoqUFV84
   WmrWPwGgFUR6lr9cPF2LK02eR+oKe3qbLzr/o6ZYFowx1+7Fc7i8THEEC
   dGUUTQNJRf/eVNVTjMmK6/fl01pZPb3NR9kr4Zl6QxCj00P8kBBMExze5
   i1CWukRHRXjZD1iXZJ6bxRmKhRQjcxUoBIUMiacKeQR/Db9+fceJrlSna
   uc+IyeYAHaLgC8sEewDnln6h3vjLiiSOlC7moD2VlnKsSFIm4Cwo2wB5u
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120630"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589889"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589889"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 08/15] ice: combine cases in ice_ksettings_find_adv_link_speed()
Date:   Thu, 19 Jan 2023 13:27:35 -0800
Message-Id: <20230119212742.2106833-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

Combine if statements setting the same link speed together.

Suggested-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Acked-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 42ff621f9c68..e0a83d55fef4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2259,17 +2259,15 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
 						  100baseT_Full))
 		adv_link_speed |= ICE_AQ_LINK_SPEED_100MB;
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
-						  1000baseX_Full))
-		adv_link_speed |= ICE_AQ_LINK_SPEED_1000MB;
-	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseX_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  1000baseT_Full) ||
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  1000baseKX_Full))
 		adv_link_speed |= ICE_AQ_LINK_SPEED_1000MB;
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
-						  2500baseT_Full))
-		adv_link_speed |= ICE_AQ_LINK_SPEED_2500MB;
-	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  2500baseT_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  2500baseX_Full))
 		adv_link_speed |= ICE_AQ_LINK_SPEED_2500MB;
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
@@ -2278,9 +2276,8 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  10000baseT_Full) ||
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
-						  10000baseKR_Full))
-		adv_link_speed |= ICE_AQ_LINK_SPEED_10GB;
-	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  10000baseKR_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  10000baseSR_Full) ||
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  10000baseLR_Full))
@@ -2304,9 +2301,8 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  50000baseCR2_Full) ||
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
-						  50000baseKR2_Full))
-		adv_link_speed |= ICE_AQ_LINK_SPEED_50GB;
-	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  50000baseKR2_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  50000baseSR2_Full))
 		adv_link_speed |= ICE_AQ_LINK_SPEED_50GB;
 	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
-- 
2.38.1

