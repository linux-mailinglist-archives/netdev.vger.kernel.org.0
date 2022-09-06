Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25ED5AEB7B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbiIFOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241915AbiIFOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:18:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1832A439;
        Tue,  6 Sep 2022 06:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472203; x=1694008203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LCJNwKIb2JZh9SO69nCDrOY4AomaNFhl38g2hoPWX0w=;
  b=H0m2Fc0hxduBkJUR+yfO/rr4D3CMq0Mv+ZeGNBE0Y58SC+8Oa5BHSOYA
   pM/oyE4z5d2uWC5Mj2cdNHrNuiZUglvwkNQPlzR+sqUBHBsLpW5UjYGIw
   lOW0oVLGpU+xITQD/zjePitA9gpSMaJ62ZmGNumRKZDlWKKAKc9DwHzxV
   vpSf0zj+kqiBpeYVrPyyOGUqJNgSqlM8jyBx72vAyRgDI+ozT+jty55HN
   tuaGmLzAB4ZDB3JpUl03bI1L2rWCMer8p4QnRt+4YCPuYaJvyXmlPBjat
   8dlVf3a/JQb0w7dMcz85R7dsRIxD6u6MBvSLCWW0dShnRFlSKHMD22mfN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296597057"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="296597057"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:49:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="717702899"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 06 Sep 2022 06:49:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7B54750D; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
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
Subject: [PATCH v3 04/11] leds: bcm6328: Get rid of custom led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:49:57 +0300
Message-Id: <20220906135004.14885-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

