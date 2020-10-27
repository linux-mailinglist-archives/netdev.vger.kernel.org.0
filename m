Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF85829C6FC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827688AbgJ0S0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:26:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:41108 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1827184AbgJ0SWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 14:22:01 -0400
IronPort-SDR: LUE+PJDNhOcyWma8yZUF23D8gHXC3NE3CmOdKaVEVLEBDqFN6C/OH5SZnaSWhiAsTRvcZMurQ/
 rNhznXWb4Lsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155106788"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155106788"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 11:21:50 -0700
IronPort-SDR: mXc+k7tCSxSVVantQU/cKcsjSiKwWJHyOPFNnBrK4Eq34pwqk7/64qD5MS8580ssrJoY997YQv
 fppirxEoYnLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="303848822"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 27 Oct 2020 11:21:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0C1C7179; Tue, 27 Oct 2020 20:21:46 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3] net: phy: leds: Deduplicate link LED trigger registration
Date:   Tue, 27 Oct 2020 20:21:46 +0200
Message-Id: <20201027182146.21355-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phy_led_trigger_register() and deduplicate its functionality
when registering LED trigger for link.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v3: rebased on top of v5.10-rc1
 drivers/net/phy/phy_led_triggers.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
index 59a94e07e7c5..08a3e9ea4102 100644
--- a/drivers/net/phy/phy_led_triggers.c
+++ b/drivers/net/phy/phy_led_triggers.c
@@ -66,11 +66,11 @@ static void phy_led_trigger_format_name(struct phy_device *phy, char *buf,
 
 static int phy_led_trigger_register(struct phy_device *phy,
 				    struct phy_led_trigger *plt,
-				    unsigned int speed)
+				    unsigned int speed,
+				    const char *suffix)
 {
 	plt->speed = speed;
-	phy_led_trigger_format_name(phy, plt->name, sizeof(plt->name),
-				    phy_speed_to_str(speed));
+	phy_led_trigger_format_name(phy, plt->name, sizeof(plt->name), suffix);
 	plt->trigger.name = plt->name;
 
 	return led_trigger_register(&plt->trigger);
@@ -99,12 +99,7 @@ int phy_led_triggers_register(struct phy_device *phy)
 		goto out_clear;
 	}
 
-	phy_led_trigger_format_name(phy, phy->led_link_trigger->name,
-				    sizeof(phy->led_link_trigger->name),
-				    "link");
-	phy->led_link_trigger->trigger.name = phy->led_link_trigger->name;
-
-	err = led_trigger_register(&phy->led_link_trigger->trigger);
+	err = phy_led_trigger_register(phy, phy->led_link_trigger, 0, "link");
 	if (err)
 		goto out_free_link;
 
@@ -119,7 +114,7 @@ int phy_led_triggers_register(struct phy_device *phy)
 
 	for (i = 0; i < phy->phy_num_led_triggers; i++) {
 		err = phy_led_trigger_register(phy, &phy->phy_led_triggers[i],
-					       speeds[i]);
+					       speeds[i], phy_speed_to_str(speeds[i]));
 		if (err)
 			goto out_unreg;
 	}
-- 
2.28.0

