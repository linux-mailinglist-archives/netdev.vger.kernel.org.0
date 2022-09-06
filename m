Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659C65AECAF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241830AbiIFOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242276AbiIFOUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:20:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328E78C452;
        Tue,  6 Sep 2022 06:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472294; x=1694008294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hvI26OhQ+1E3Y1b+RrDqvUOiyVnslqAALa2RhHdwGbY=;
  b=ce2fkf3K/Zwn0zdK7wQuFalf4WzdZRiyfiiWLHDJEe/N1jMC3AOIjeP2
   f6rFvUBJMCBRXgy3UhIN+W5//OcgPdBhkCfzz241AL0E/OApH4Y2yKbmU
   B0xDmKdA7wWkEOhL+4xLXE9mN3srOFcPwFZMHCWY2s83zwbVzfu8n7nFP
   X0V4iXEeDpyme4Po6IU8bZZnoY5/ofmFfGvtxB9feENrUMXaPXleHCbTA
   I+DtJ1Jj7ibcXFNI1aDut6y3mw8Y1AtikFJfbLYqYjGvHF4vh/5qA29Ec
   QNtbk8DTi+g0s3xJ+ohnrR1ds2hSp2X1THfZBs0kwm6VCEXSOLriQRhDh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="297380983"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="297380983"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="675694894"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 06 Sep 2022 06:50:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B5018238; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: [PATCH v3 09/11] leds: pm8058: Get rid of custom led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:50:02 +0300
Message-Id: <20220906135004.14885-10-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

