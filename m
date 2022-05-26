Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89D0534C0F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241805AbiEZI5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiEZI5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:57:02 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AFE3525C;
        Thu, 26 May 2022 01:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653555420; x=1685091420;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VYZcLDoZJWGwpGI3Sm3xsbMDc92hUIeYlIsQC6WcKIA=;
  b=PvqOM7G0s49LAxFkLgj0huKG2B0hdhKRH7tPWcuGPJ44v/OXfDTiDe8R
   C9NwcmFoKHIMFRYZmt/Al0Cv4kcmb4+WmDxQRt+ox6R6F9CwqZvTtzxc3
   jl+QC5ZVWmZcXjfyyOL2lf+KqpgVUrPEf4WtHXn6aAMojlvl+2CVHceHA
   mu+Px5vrjaLK6p5jZwd22A2/Xegv3/jR++mWRzvLm/0fnJl8i6z13jos4
   22n4MmaLTFg5cUF5rYYvBRi5lqkYe+J6KmqT6AxQEpcYveVbe2mLPdxYP
   YoL2xAmH4WvebulPkFqUQo43ye8yZwowMaeHmKbI886MoSpxqoI346mWf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="337136423"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="337136423"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 01:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="609601489"
Received: from p12hl01tmin.png.intel.com ([10.158.65.216])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2022 01:56:56 -0700
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN when link change
Date:   Thu, 26 May 2022 17:03:47 +0800
Message-Id: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

v2: Add Fixes tag in commit message.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Cc: <stable@vger.kernel.org> # 5.4.x
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

