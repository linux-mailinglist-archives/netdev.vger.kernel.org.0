Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFAE2504F0
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgHXRJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:09:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:60073 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgHXRJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:09:22 -0400
IronPort-SDR: 81+KFdtYBvdz0Mt76pO/f1u2nqhHCbZ9booWi4zreugYETemPPg8JSzF9Mf5O4aOBe6VszGSos
 Unedl0Buk14A==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="153531231"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="153531231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 10:09:07 -0700
IronPort-SDR: x+6G24bZcosw/eTxjLgRew3HmChTfss+mibngjnAwp/b0+B8WwDXcmUH5Jm134y1rLUQzmoYeZ
 55x1moYvugzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="338502137"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2020 10:09:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 211B0166; Mon, 24 Aug 2020 20:09:05 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: phy: leds: Deduplicate link LED trigger registration
Date:   Mon, 24 Aug 2020 20:09:04 +0300
Message-Id: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor phy_led_trigger_register() and deduplicate its functionality
when registering LED trigger for link.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/phy/phy_led_triggers.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
index 59a94e07e7c5..9a92e471400e 100644
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
+	err = phy_led_trigger_register(phy, &phy->led_link_trigger, 0, "link");
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

