Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA258AD85
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbiHEPva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241314AbiHEPvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E63C5C9F3;
        Fri,  5 Aug 2022 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714551; x=1691250551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LCJNwKIb2JZh9SO69nCDrOY4AomaNFhl38g2hoPWX0w=;
  b=nxuzY1Tk8GHN4O5v0jAr+WbFxGH1oiuttHAtWEyG1MuxSOzuX3+xhHOW
   jJCTqa0gOdMVvXSVQommh0Sw59AWEXTfhw1ScVmGCY/ZozADCcKeP3HH/
   dE9fXG+US/Q9itpjDe0ooQADbYg5eHhjerwDsnlABa5UDF4bxdP7MoEy5
   Kt1BZF6fFM4LRev18e+krgfAag9W8zlBymw12twP8UE7tzx9gku4M/3yV
   aShF68WaRyaiczxOrafq8nTvpEsbNtv/+a5xbyamLieEEHRa740zBJC2+
   51a6ERQ2/hlvlixsY2FMJk+wUsMEho6Qily/7Jj9b4AYyC54XvYHh2DlZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="269999196"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="269999196"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="671727790"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2022 08:49:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id AFA151DF; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
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
Subject: [PATCH v2 04/11] leds: bcm6328: Get rid of custom led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:49:00 +0300
Message-Id: <20220805154907.32263-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
References: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/leds/leds-bcm6328.c | 49 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/leds/leds-bcm6328.c b/drivers/leds/leds-bcm6328.c
index 2d4d87957a30..246f1296ab09 100644
--- a/drivers/leds/leds-bcm6328.c
+++ b/drivers/leds/leds-bcm6328.c
@@ -330,7 +330,9 @@ static int bcm6328_led(struct device *dev, struct device_node *nc, u32 reg,
 {
 	struct led_init_data init_data = {};
 	struct bcm6328_led *led;
-	const char *state;
+	enum led_default_state state;
+	unsigned long val, shift;
+	void __iomem *mode;
 	int rc;
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
@@ -346,31 +348,29 @@ static int bcm6328_led(struct device *dev, struct device_node *nc, u32 reg,
 	if (of_property_read_bool(nc, "active-low"))
 		led->active_low = true;
 
-	if (!of_property_read_string(nc, "default-state", &state)) {
-		if (!strcmp(state, "on")) {
+	init_data.fwnode = of_fwnode_handle(nc);
+
+	state = led_init_default_state_get(init_data.fwnode);
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		led->cdev.brightness = LED_FULL;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		shift = bcm6328_pin2shift(led->pin);
+		if (shift / 16)
+			mode = mem + BCM6328_REG_MODE_HI;
+		else
+			mode = mem + BCM6328_REG_MODE_LO;
+
+		val = bcm6328_led_read(mode) >> BCM6328_LED_SHIFT(shift % 16);
+		val &= BCM6328_LED_MODE_MASK;
+		if ((led->active_low && val == BCM6328_LED_MODE_OFF) ||
+		    (!led->active_low && val == BCM6328_LED_MODE_ON))
 			led->cdev.brightness = LED_FULL;
-		} else if (!strcmp(state, "keep")) {
-			void __iomem *mode;
-			unsigned long val, shift;
-
-			shift = bcm6328_pin2shift(led->pin);
-			if (shift / 16)
-				mode = mem + BCM6328_REG_MODE_HI;
-			else
-				mode = mem + BCM6328_REG_MODE_LO;
-
-			val = bcm6328_led_read(mode) >>
-			      BCM6328_LED_SHIFT(shift % 16);
-			val &= BCM6328_LED_MODE_MASK;
-			if ((led->active_low && val == BCM6328_LED_MODE_OFF) ||
-			    (!led->active_low && val == BCM6328_LED_MODE_ON))
-				led->cdev.brightness = LED_FULL;
-			else
-				led->cdev.brightness = LED_OFF;
-		} else {
+		else
 			led->cdev.brightness = LED_OFF;
-		}
-	} else {
+		break;
+	default:
 		led->cdev.brightness = LED_OFF;
 	}
 
@@ -378,7 +378,6 @@ static int bcm6328_led(struct device *dev, struct device_node *nc, u32 reg,
 
 	led->cdev.brightness_set = bcm6328_led_set;
 	led->cdev.blink_set = bcm6328_blink_set;
-	init_data.fwnode = of_fwnode_handle(nc);
 
 	rc = devm_led_classdev_register_ext(dev, &led->cdev, &init_data);
 	if (rc < 0)
-- 
2.35.1

