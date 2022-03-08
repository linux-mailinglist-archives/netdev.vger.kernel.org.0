Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CE24D2396
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350556AbiCHVse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350537AbiCHVsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:48:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6265C554BF
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646776040; x=1678312040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=slkQC8krwRG+pGj15yFcm6HAdv1RKTT0GgWzInrh9FU=;
  b=W4tzbM83hkau/Q5988BYPYq+VsbSNnc9p3X3guU9v5qjRkOyEh0OkU4H
   AzBgc/3qp66rDu6lpmS/YIIjy2UkpSoFadHKmCMDpk8jCvDr7sjXiDxrh
   4lyPhxA0hsvUaSzV5s2DuHv+R6UWHF+8wub+9mh6lNTc2OJWjPde/dksF
   bZXjf3ucRJ5ScTajxIhTSdOzwOl4v/OhrM/jbmheLk0dVyq6xhL9T7D5P
   bWXMm/v/OjluO3kVuFn8waen6L6UhZECqDYw6dx3De9DB8eFNZRbVeMx5
   EAHdorZ67UjyGwjbSHen3XuHeNZgzwsPR2S04K9k2XfznciwbIw8Ag14u
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318050854"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="318050854"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 13:47:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="553811449"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Mar 2022 13:47:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 7/7] ice: Fix curr_link_speed advertised speed
Date:   Tue,  8 Mar 2022 13:47:36 -0800
Message-Id: <20220308214736.884443-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308214736.884443-1-anthony.l.nguyen@intel.com>
References: <20220308214736.884443-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Change curr_link_speed advertised speed, due to
link_info.link_speed is not equal phy.curr_user_speed_req.
Without this patch it is impossible to set advertised
speed to same as link_speed.

Testing Hints: Try to set advertised speed
to 25G only with 25G default link (use ethtool -s 0x80000000)

Fixes: 48cb27f2fd18 ("ice: Implement handlers for ethtool PHY/link operations")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e2e3ef7fba7f..a5dc9824e255 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2298,7 +2298,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	if (err)
 		goto done;
 
-	curr_link_speed = pi->phy.link_info.link_speed;
+	curr_link_speed = pi->phy.curr_user_speed_req;
 	adv_link_speed = ice_ksettings_find_adv_link_speed(ks);
 
 	/* If speed didn't get set, set it to what it currently is.
-- 
2.31.1

