Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1743E58AD95
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbiHEPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241340AbiHEPvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:19 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0EA67C8F;
        Fri,  5 Aug 2022 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714556; x=1691250556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hvI26OhQ+1E3Y1b+RrDqvUOiyVnslqAALa2RhHdwGbY=;
  b=Gt16rXSJGhOwgU717iEScXQlc4+9DAlJ8icePXX5ZlShvlCWLf9jOXk9
   99tRVUdZW/nE7gSPgRS/tAmCEIcETTbT/X6psGAqcW0WRkyrxvhFySBAp
   1COjvp/dGuq3i2ABWtB5qTE7qASPqhHgP6b9c1Ln8X/j6P4FHGkCedlwD
   FgoMjYkLLCNAINiNH+ANRm+cH60tIZtJS+6Gm/PltxSImlrAWE8HU0ZSr
   pTDuI1ncZaoDV4s3D6QrENpunlzmKXDb64KbN6NekK2i+jrP9qcuRcDze
   Bj87aMDHJJCweSfBsuxHJoIGAv6N3AUZyIQqoBfnRGcKhlU6NB1/XyK2o
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="291003150"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291003150"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="600399033"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 05 Aug 2022 08:49:11 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id ECFC1450; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Eddie James <eajames@linux.ibm.com>,
        Denis Osterland-Heim <Denis.Osterland@diehl.com>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 09/11] leds: pm8058: Get rid of custom led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:49:05 +0300
Message-Id: <20220805154907.32263-10-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
References: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/leds/leds-pm8058.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-pm8058.c b/drivers/leds/leds-pm8058.c
index fb2ab72c0c40..b9233f14b646 100644
--- a/drivers/leds/leds-pm8058.c
+++ b/drivers/leds/leds-pm8058.c
@@ -93,8 +93,8 @@ static int pm8058_led_probe(struct platform_device *pdev)
 	struct device_node *np;
 	int ret;
 	struct regmap *map;
-	const char *state;
 	enum led_brightness maxbright;
+	enum led_default_state state;
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
@@ -125,25 +125,26 @@ static int pm8058_led_probe(struct platform_device *pdev)
 		maxbright = 15; /* 4 bits */
 	led->cdev.max_brightness = maxbright;
 
-	state = of_get_property(np, "default-state", NULL);
-	if (state) {
-		if (!strcmp(state, "keep")) {
-			led->cdev.brightness = pm8058_led_get(&led->cdev);
-		} else if (!strcmp(state, "on")) {
-			led->cdev.brightness = maxbright;
-			pm8058_led_set(&led->cdev, maxbright);
-		} else {
-			led->cdev.brightness = LED_OFF;
-			pm8058_led_set(&led->cdev, LED_OFF);
-		}
+	init_data.fwnode = of_fwnode_handle(np);
+
+	state = led_init_default_state_get(init_data.fwnode);
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		led->cdev.brightness = maxbright;
+		pm8058_led_set(&led->cdev, maxbright);
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		led->cdev.brightness = pm8058_led_get(&led->cdev);
+		break;
+	default:
+		led->cdev.brightness = LED_OFF;
+		pm8058_led_set(&led->cdev, LED_OFF);
 	}
 
 	if (led->ledtype == PM8058_LED_TYPE_KEYPAD ||
 	    led->ledtype == PM8058_LED_TYPE_FLASH)
 		led->cdev.flags	= LED_CORE_SUSPENDRESUME;
 
-	init_data.fwnode = of_fwnode_handle(np);
-
 	ret = devm_led_classdev_register_ext(dev, &led->cdev, &init_data);
 	if (ret)
 		dev_err(dev, "Failed to register LED for %pOF\n", np);
-- 
2.35.1

