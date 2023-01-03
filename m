Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C165C08D
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbjACNNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbjACNNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:13:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299E011149;
        Tue,  3 Jan 2023 05:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751564; x=1704287564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7p6zWbQRFO6BWGKdmzxHibs27PU9es81+rcbWbLCG20=;
  b=j722cG7A2lXzw/ka6jI1UYD83qpkWlRMTyb/+mfQJwHTjYrJiRIt1ngc
   mB+xPxgwjsgNCrNpXXUcY2kgrXbVG5olZbG2VhkQ8EiUqNR2prKGlkKmI
   Z21JqNnLBGOys8YQG+4TApLmTOSjlML1vZIOrfcD/Qtf6kB+dSx3oiM8F
   HJm6L/YUTkc6A6bmEDZg+ivX9aKIFHOJYxsRdzh5YbemjJ6ZxfIgnHzEH
   Rzqixq7bv9Pm5xxfKPGL1mnmkWM7dfgawQch8EqQlImC33+54tqqCb3o+
   VWE/PCRSGjZdRnmfYQsv3ZvcAiJCVMdpjDwOmXDtYl2fvkcgq8GZMDa1a
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="322887977"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="322887977"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685397941"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="685397941"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2023 05:12:33 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A5E0C2AA; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v4 05/11] leds: bcm6358: Get rid of custom led_init_default_state_get()
Date:   Tue,  3 Jan 2023 15:12:50 +0200
Message-Id: <20230103131256.33894-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
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

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

