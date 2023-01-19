Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F69674050
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjASRuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjASRtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:49:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5C9085A;
        Thu, 19 Jan 2023 09:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674150582; x=1705686582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=17SBNARovi0mn+Dn5/PkCCYJAQkxV/ALHR2WMFSdnJQ=;
  b=Z1Zolsp5OBef+MJYrsU49Q/VHaul0EKfn6j/F0O+coJZUdB5JagFu5+y
   Jlew/yERVYVZbrSmCs3T034RYQv0gs1CeVgkK7ehWW5BQNjzLNQKzzPQO
   NW9JBr2xCTlqt5DZsFAyLtL62oGZ36N/sWfV1HKzyDJAGeRODWOPxjb0B
   GaCSHz1Dg1rbsiKgLuE9h1G4eCwnEupWGcheYOSoMIEL9ZaYg3k0JffzL
   nCqPAIYdX0u8Few4bsXf78soQXGkQLTdCa0von4mWjnP6JZ0VvGs/55YH
   vRNYnFnplJo9VLa7pO1waDmdQocEGB4Mv3ornUWOiKv08tfjBBD2Zsceg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313251616"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="313251616"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 09:49:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905627080"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="905627080"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 09:49:38 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 8528E36D; Thu, 19 Jan 2023 19:50:13 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 1/1] net: mdiobus: Convert to use fwnode_device_is_compatible()
Date:   Thu, 19 Jan 2023 19:50:10 +0200
Message-Id: <20230119175010.77035-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open coded fwnode_device_is_compatible() in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/mdio/fwnode_mdio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..1183ef5e203e 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -115,7 +115,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	struct mii_timestamper *mii_ts = NULL;
 	struct pse_control *psec = NULL;
 	struct phy_device *phy;
-	bool is_c45 = false;
+	bool is_c45;
 	u32 phy_id;
 	int rc;
 
@@ -129,11 +129,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		goto clean_pse;
 	}
 
-	rc = fwnode_property_match_string(child, "compatible",
-					  "ethernet-phy-ieee802.3-c45");
-	if (rc >= 0)
-		is_c45 = true;
-
+	is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
 	else
-- 
2.39.0

