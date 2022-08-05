Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1144758AD90
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241425AbiHEPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbiHEPvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E156612F;
        Fri,  5 Aug 2022 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714556; x=1691250556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IsTbKM8jNHxj4ziPqVComygZINDozfOXf+AY99bFeg=;
  b=T+4kcgxqSchOdDxr/wPUz19NRr7Z7aqqH1IVL+dBpzHnoge9HXdtiCWU
   fy65ae//p4XQOUgiO414HrLhTtHiOrLQkrYj3m8SUb8JT7Rw8n9hz5TYh
   uR9Oo2GXLNKTkVSu2ufaDv71DfYHDSDpJuWkxU8HpMQyaED2lSsmFDeT0
   H2Q2YKNk9lwoEP8eib3S0/hSh1bYPNs6Lecdsvc9ZIUvLMd/u3zeH55a4
   WZ3AYwF39ukUcR323kGPgWzE3ZjqHbDrkj8W0pBhm/ui0ia+lQI37da0J
   KxvDujPfMbt3Dg4LhhEODhpSmUY4gck2uyAejyHplxswOjNbt3IWrLtrV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="291450588"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291450588"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="931271163"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 05 Aug 2022 08:49:10 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BCCB5303; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
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
Subject: [PATCH v2 05/11] leds: bcm6358: Get rid of custom led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:49:01 +0300
Message-Id: <20220805154907.32263-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
References: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
 drivers/leds/leds-bcm6358.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-bcm6358.c b/drivers/leds/leds-bcm6358.c
index 9d2e487fa08a..86e51d44a5a7 100644
--- a/drivers/leds/leds-bcm6358.c
+++ b/drivers/leds/leds-bcm6358.c
@@ -96,7 +96,8 @@ static int bcm6358_led(struct device *dev, struct device_node *nc, u32 reg,
 {
 	struct led_init_data init_data = {};
 	struct bcm6358_led *led;
-	const char *state;
+	enum led_default_state state;
+	unsigned long val;
 	int rc;
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
@@ -110,29 +111,28 @@ static int bcm6358_led(struct device *dev, struct device_node *nc, u32 reg,
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
+		val = bcm6358_led_read(led->mem + BCM6358_REG_MODE);
+		val &= BIT(led->pin);
+		if ((led->active_low && !val) || (!led->active_low && val))
 			led->cdev.brightness = LED_FULL;
-		} else if (!strcmp(state, "keep")) {
-			unsigned long val;
-			val = bcm6358_led_read(led->mem + BCM6358_REG_MODE);
-			val &= BIT(led->pin);
-			if ((led->active_low && !val) ||
-			    (!led->active_low && val))
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
 
 	bcm6358_led_set(&led->cdev, led->cdev.brightness);
 
 	led->cdev.brightness_set = bcm6358_led_set;
-	init_data.fwnode = of_fwnode_handle(nc);
 
 	rc = devm_led_classdev_register_ext(dev, &led->cdev, &init_data);
 	if (rc < 0)
-- 
2.35.1

