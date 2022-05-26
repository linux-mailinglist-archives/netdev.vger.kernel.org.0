Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D87953482F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbiEZBbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245169AbiEZBao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:30:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19F8A76F4;
        Wed, 25 May 2022 18:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653528627; x=1685064627;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UaSIPRzQt8djgwCCogviIlJQSqF/rXfZ66henu/ROoY=;
  b=dTTyDv38O0Oyxwm3H23qgOh7Mmxfcd44npw5Wx54abP0fUA+37piwUgg
   6JWCiQP+WEoj2CizKCuEvp43H+w9/w3GpxKxY+UkN+/AQW/7LZO7caUR5
   iOHQtmjYbBAEl/97S2snN+Qf2ewgYe5Y4IDHYrAbvPc7k7VZQYKzUERAe
   1gkC6pRgmK+uStAU/UgymoeJft26/oVsh3hztSPRCYyTQuUophT8cIQin
   n8Fm6kRwR7BVO1mnTvWmNCCoqyvqeuX8wsdSuRdES6nq2X2tupDw8tlmY
   3oslxqf/AgchmI5P1T9gGld+gFDGcWnT48S2z/RL66YDk6TPwHE+osllK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="273713962"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="273713962"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 18:30:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="718002411"
Received: from p12hl01tmin.png.intel.com ([10.158.65.216])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2022 18:30:23 -0700
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: [PATCH net-next 1/1] net: phy: dp83867: retrigger SGMII AN when link change
Date:   Thu, 26 May 2022 09:37:14 +0800
Message-Id: <20220526013714.4119839-1-tee.min.tan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a limitation in TI DP83867 PHY device where SGMII AN is only
triggered once after the device is booted up. Even after the PHY TPI is
down and up again, SGMII AN is not triggered and hence no new in-band
message from PHY to MAC side SGMII.

This could cause an issue during power up, when PHY is up prior to MAC.
At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
receive new in-band message from TI PHY with correct link status, speed
and duplex info.

As suggested by TI, implemented a SW solution here to retrigger SGMII
Auto-Neg whenever there is a link change.

Signed-off-by: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
---
 drivers/net/phy/dp83867.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 8561f2d4443b..13dafe7a29bd 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -137,6 +137,7 @@
 #define DP83867_DOWNSHIFT_2_COUNT	2
 #define DP83867_DOWNSHIFT_4_COUNT	4
 #define DP83867_DOWNSHIFT_8_COUNT	8
+#define DP83867_SGMII_AUTONEG_EN	BIT(7)
 
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
@@ -855,6 +856,32 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
 
+static void dp83867_link_change_notify(struct phy_device *phydev)
+{
+	/* There is a limitation in DP83867 PHY device where SGMII AN is
+	 * only triggered once after the device is booted up. Even after the
+	 * PHY TPI is down and up again, SGMII AN is not triggered and
+	 * hence no new in-band message from PHY to MAC side SGMII.
+	 * This could cause an issue during power up, when PHY is up prior
+	 * to MAC. At this condition, once MAC side SGMII is up, MAC side
+	 * SGMII wouldn`t receive new in-band message from TI PHY with
+	 * correct link status, speed and duplex info.
+	 * Thus, implemented a SW solution here to retrigger SGMII Auto-Neg
+	 * whenever there is a link change.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		int val = 0;
+
+		val = phy_clear_bits(phydev, DP83867_CFG2,
+				     DP83867_SGMII_AUTONEG_EN);
+		if (val < 0)
+			return;
+
+		phy_set_bits(phydev, DP83867_CFG2,
+			     DP83867_SGMII_AUTONEG_EN);
+	}
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -879,6 +906,8 @@ static struct phy_driver dp83867_driver[] = {
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+
+		.link_change_notify = dp83867_link_change_notify,
 	},
 };
 module_phy_driver(dp83867_driver);
-- 
2.25.1

