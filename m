Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A1636547
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiKWQFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbiKWQFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:05:38 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9606B9E9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669219536; x=1700755536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sX26KpCopBQUO4dIDe2S8U6mw9YjALtAR83X0y2IZ7I=;
  b=EHnkv3fwjIa+NReZe92qxxu7ZngDyW+192qSzlQk77AVPQ6cvz9DMDo/
   5jOHA8Ki7a3V7ttL9DweAdctuB5ikgSm7mCV7RZXkIXHp8BN10f1oyOmN
   Px30Clwip7d9GiyOLYMVntmBUZLPqxDRqhU1aQQKv2Qdmtm3hlOCrf+83
   WDo9s7iGsRSUN4Y1B2yp2OsxNNtOmWQwWBh6Ft2WR1A5fiUCMs8ip0nz0
   P8xBxtx7ChOnZ/5yr9BFAhO9yA2pSeszkw6hkKT2/B8a+IdMYtOUNhPQk
   J0fI626vseTJ6QyeaU22p/+2jDuVd+jqpXN0ER14c+hil/ySSFOQxdtxl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378356789"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="378356789"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:05:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674769570"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674769570"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 08:05:34 -0800
Received: from vecna.. (vecna.igk.intel.com [10.123.220.17])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANG5SoT003509;
        Wed, 23 Nov 2022 16:05:34 GMT
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH net-next 2/2] ice: combine cases in ice_ksettings_find_adv_link_speed()
Date:   Wed, 23 Nov 2022 16:55:44 +0100
Message-Id: <20221123155544.1660952-2-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20221123155544.1660952-1-przemyslaw.kitszel@intel.com>
References: <20221123155544.1660952-1-przemyslaw.kitszel@intel.com>
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

Combine if statements setting the same link speed together.

Suggested-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 417efc401001..626480677cc1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2260,17 +2260,15 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
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
@@ -2279,9 +2277,8 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
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
@@ -2305,9 +2302,8 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
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
2.34.3

