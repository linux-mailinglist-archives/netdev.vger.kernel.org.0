Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A200620CF8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiKHKQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiKHKQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:16:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3914FBF8;
        Tue,  8 Nov 2022 02:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667902563; x=1699438563;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7iE5y9/CL0SMSk1mAHJvny43HgcdVVS8SDYC0bUemas=;
  b=K7+wpFoQOgI1NFPKIpAfTaxnvSyNkPhFcNRZvt5pzss3Bn8VuDU8K9Te
   QQ+vmOC74jCJG2n9H1v0sUkKQ5qG2tjJxZffT1/LovV15nn8Ufc3Fo2RA
   EVYKMfxE7NKYOpYHXA6eW5ji8IHPpAv9kvox2AOHqOwwsB/wVA/s/eLRf
   AsP+gN4Ry15eA12/t5YBmGj18JXKcd1ma3uqtS/RQHRAlaEyyTlNL6NSF
   dl73qrKpbjToIxRpyXwGgLD8Q4EUcV0z/If5bSxvhsw65DMH8ofeWrnjI
   M6b67V5A749bJMHuCkFB3To1XIh1EuPowGK0Klb3leVR9e9YOX5e3G8+h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="298175083"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="298175083"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:16:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811187958"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="811187958"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2022 02:15:57 -0800
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tan Tee Min <tee.min.tan@intel.com>
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: [PATCH net-next 1/1] net: phy: dp83867: add TI PHY loopback
Date:   Tue,  8 Nov 2022 18:15:27 +0800
Message-Id: <20221108101527.612723-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

The existing genphy_loopback() is not working for TI DP83867 PHY as it
will disable autoneg support while another side is still enabling autoneg.
This is causing the link is not established and results in timeout error
in genphy_loopback() function.

Thus, based on TI PHY datasheet, introduce a TI PHY loopback function by
just configuring BMCR_LOOPBACK(Bit-9) in MII_BMCR register (0x0).

Tested working on TI DP83867 PHY for all speeds (10/100/1000Mbps).

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
---
 drivers/net/phy/dp83867.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..350217a23b34 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -925,6 +925,12 @@ static void dp83867_link_change_notify(struct phy_device *phydev)
 	}
 }
 
+static int dp83867_loopback(struct phy_device *phydev, bool enable)
+{
+	return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+			  enable ? BMCR_LOOPBACK : 0);
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -951,6 +957,7 @@ static struct phy_driver dp83867_driver[] = {
 		.resume		= genphy_resume,
 
 		.link_change_notify = dp83867_link_change_notify,
+		.set_loopback	= dp83867_loopback,
 	},
 };
 module_phy_driver(dp83867_driver);
-- 
2.34.1

