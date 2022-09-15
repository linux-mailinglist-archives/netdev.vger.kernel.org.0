Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDCC5B96F6
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIOJFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOJFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:05:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6688795AC1;
        Thu, 15 Sep 2022 02:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663232738; x=1694768738;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PQd9NG7r7Qh0xrNlLQSODxX4esx5SIk8ks2+Gn/DQwQ=;
  b=KfPdLIr+BFwpyRNqB5cPfftsyc3zS7TRFers/ZXkwm6XfqyvRFyJjRtS
   tnYKZR4KogyoWkoo83swzz1Vm2DL1gXJvejAMfhM/oC/uCZIAXegwP2E6
   IBUM56sAJJ17RSPfNlSSFG7BaGvCIexcAUQg1iLx+zskK9QdklSrbcdI1
   lFjZNiuGwbMBYdHpV9GuNO734vTSOkcHb1Hq0rbvhd6mEcmoaVgXdtg26
   zfwq0EYnXXl4JIxPD4tfpKrTzmAvnBXKUCoNtCzWEuUedEvdGXhQRZTVW
   0Yy/+v2gogzMbz/68jH/lR6L1v0vJKzYVRd5ahwd+WncfsBeC/T5vwi78
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299471889"
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="299471889"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 02:05:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="679424415"
Received: from yongliang-ubuntu20-ilbpg12.png.intel.com ([10.88.229.33])
  by fmsmga008.fm.intel.com with ESMTP; 15 Sep 2022 02:05:33 -0700
From:   Choong Yong Liang <yong.liang.choong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>
Cc:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Cacho Gerome <g-cacho@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/1] net: phy: dp83867: perform phy reset after modifying auto-neg setting
Date:   Thu, 15 Sep 2022 05:02:58 -0400
Message-Id: <20220915090258.2154767-1-yong.liang.choong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Song Yoong Siang <yoong.siang.song@intel.com>

In the case where TI DP83867 is connected back-to-back with another TI
DP83867, SEEDs match will occurs when advertised link speed is changed from
100 Mbps to 1 Gbps, which causing Master/Slave resolution fails and restart
of the auto-negotiation. As a result, TI DP83867 copper auto-negotiation
completion will takes up to 15 minutes.

To resolve the issue, this patch implemented phy reset (software restart
which perform a full reset, but not including registers) immediately after
modifying auto-negotiation setting. By applying reset to the phy, it would
also reset the lfsr which would increase the probability of SEEDS being
different and help in Master/Slave resolution. Gerome from TI has confirmed
that there is no harm in adding soft restart in auto-negotiation
programming flow, even though the system is not facing SEEDs match issue.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Cacho Gerome <g-cacho@ti.com>
Signed-off-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
---
 drivers/net/phy/dp83867.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..6e4b10f35696 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -925,6 +925,17 @@ static void dp83867_link_change_notify(struct phy_device *phydev)
 	}
 }
 
+static int dp83867_config_aneg(struct phy_device *phydev)
+{
+	int err;
+
+	err = genphy_config_aneg(phydev);
+	if (err < 0)
+		return err;
+
+	return dp83867_phy_reset(phydev);
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -951,6 +962,7 @@ static struct phy_driver dp83867_driver[] = {
 		.resume		= genphy_resume,
 
 		.link_change_notify = dp83867_link_change_notify,
+		.config_aneg	= dp83867_config_aneg,
 	},
 };
 module_phy_driver(dp83867_driver);
-- 
2.25.1

