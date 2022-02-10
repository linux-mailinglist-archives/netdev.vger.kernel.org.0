Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F714B13CE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbiBJRF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:05:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244901AbiBJRF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:05:29 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E00C11
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644512730; x=1676048730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LYguAcC4LmX2lhrdGZ5IWaTaSPKL8kvRbF8LKHPZgQQ=;
  b=RRVSexLkl2pweVO+pNn3sQTHiDMCeKO9QxQXEAPfpT9mEAwu4/qUrHd9
   MqvfUbUBh0PSLo01N1m82XSn3XBzKk4ovSkvVb5X9KGZwi57X0pYILRuW
   cOrZYxQ8zC19IRvP5ZIEAZC47Epbwz+3QvgZMdd4MXx9LlfO6n7jBliGp
   sQbWKc9+WhQXn7XQguqsyyDoFSebpJ/V10RHIPjndCsu7LfkudV0CRp4X
   1bmXrG8kXYxm/qLBb7DiMQSE3a0t99YnL+5TSZaAd6ekSIsPNWW0HZujg
   X7YJirJYPDKI39K8xGtsdqJJIHuZqwEZ0EYFS7j2SkqDqrUG15FjrvE/b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="312825103"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="312825103"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 09:05:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="622742928"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2022 09:05:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/4] ice: fix an error code in ice_cfg_phy_fec()
Date:   Thu, 10 Feb 2022 09:05:12 -0800
Message-Id: <20220210170515.2609656-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
References: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Propagate the error code from ice_get_link_default_override() instead
of returning success.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 408d15a5b0e3..a6d7d3eff186 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3342,7 +3342,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
 		struct ice_link_default_override_tlv tlv;
 
-		if (ice_get_link_default_override(&tlv, pi))
+		status = ice_get_link_default_override(&tlv, pi);
+		if (status)
 			goto out;
 
 		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
-- 
2.31.1

