Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938FA5AEC15
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiIFO0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbiIFOWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:22:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B247C539;
        Tue,  6 Sep 2022 06:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472318; x=1694008318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6f8YWbifkD3gaKrThtIFn69fcF7c6kePJ4btJm1Xl8s=;
  b=GkOyEwYr1nD6C7JD+lJTan7wSpPj40P6Lv85zC1bto3N93Krp8VjJn1f
   U1fRRbcxbFWJp9FG6px0NABu/yYBDnaXAL5bgaP2ZotkRTcj3do4zwi82
   bQhKTnoMNL0XRI4MQCbJCDYyzBf8DF6FU4EjOAOq1vSILSHJ+7pOuRmp5
   +yOm9DndBGsnbK4vS9M8+XYai2dpmcb+DWTbXyNQIC4ksL6HYVVHqy4IK
   VYaCMi7vgwlRez/cAIvX97aUYqDcSTcLUq4+gJYWbY4iaq1umwWW/3V3+
   66Ud6UiwCf0ciWwDc3icF7eAGpynjRWS6Zud/RwhttDXGxWSpWkt9VfzQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="297380992"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="297380992"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="859264824"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 06 Sep 2022 06:50:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9E9636CD; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
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
Subject: [PATCH v3 07/11] leds: mt6360: Get rid of custom led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:50:00 +0300
Message-Id: <20220906135004.14885-8-andriy.shevchenko@linux.intel.com>
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
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/leds/flash/leds-mt6360.c | 38 +++++---------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/leds/flash/leds-mt6360.c b/drivers/leds/flash/leds-mt6360.c
index e1066a52d2d2..1af6c5898343 100644
--- a/drivers/leds/flash/leds-mt6360.c
+++ b/drivers/leds/flash/leds-mt6360.c
@@ -71,10 +71,6 @@ enum {
 #define MT6360_STRBTO_STEPUS		32000
 #define MT6360_STRBTO_MAXUS		2432000
 
-#define STATE_OFF			0
-#define STATE_KEEP			1
-#define STATE_ON			2
-
 struct mt6360_led {
 	union {
 		struct led_classdev isnk;
@@ -84,7 +80,7 @@ struct mt6360_led {
 	struct v4l2_flash *v4l2_flash;
 	struct mt6360_priv *priv;
 	u32 led_no;
-	u32 default_state;
+	enum led_default_state default_state;
 };
 
 struct mt6360_priv {
@@ -405,10 +401,10 @@ static int mt6360_isnk_init_default_state(struct mt6360_led *led)
 		level = LED_OFF;
 
 	switch (led->default_state) {
-	case STATE_ON:
+	case LEDS_DEFSTATE_ON:
 		led->isnk.brightness = led->isnk.max_brightness;
 		break;
-	case STATE_KEEP:
+	case LEDS_DEFSTATE_KEEP:
 		led->isnk.brightness = min(level, led->isnk.max_brightness);
 		break;
 	default:
@@ -443,10 +439,10 @@ static int mt6360_flash_init_default_state(struct mt6360_led *led)
 		level = LED_OFF;
 
 	switch (led->default_state) {
-	case STATE_ON:
+	case LEDS_DEFSTATE_ON:
 		flash->led_cdev.brightness = flash->led_cdev.max_brightness;
 		break;
-	case STATE_KEEP:
+	case LEDS_DEFSTATE_KEEP:
 		flash->led_cdev.brightness =
 			min(level, flash->led_cdev.max_brightness);
 		break;
@@ -760,25 +756,6 @@ static int mt6360_init_flash_properties(struct mt6360_led *led,
 	return 0;
 }
 
-static int mt6360_init_common_properties(struct mt6360_led *led,
-					 struct led_init_data *init_data)
-{
-	const char *const states[] = { "off", "keep", "on" };
-	const char *str;
-	int ret;
-
-	if (!fwnode_property_read_string(init_data->fwnode,
-					 "default-state", &str)) {
-		ret = match_string(states, ARRAY_SIZE(states), str);
-		if (ret < 0)
-			ret = STATE_OFF;
-
-		led->default_state = ret;
-	}
-
-	return 0;
-}
-
 static void mt6360_v4l2_flash_release(struct mt6360_priv *priv)
 {
 	int i;
@@ -852,10 +829,7 @@ static int mt6360_led_probe(struct platform_device *pdev)
 
 		led->led_no = reg;
 		led->priv = priv;
-
-		ret = mt6360_init_common_properties(led, &init_data);
-		if (ret)
-			goto out_flash_release;
+		led->default_state = led_init_default_state_get(child);
 
 		if (reg == MT6360_VIRTUAL_MULTICOLOR ||
 		    reg <= MT6360_LED_ISNKML)
-- 
2.35.1

