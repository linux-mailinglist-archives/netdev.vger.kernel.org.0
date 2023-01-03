Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0684665C094
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbjACNNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjACNMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:12:55 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F3410B7E;
        Tue,  3 Jan 2023 05:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751560; x=1704287560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1oxY1AfVW3M6ZngxBRWmFDZ/ISoe8vMKVfgIGcibtG0=;
  b=J3Zg0oMPF8Dh9wen9AtdQFSIJRFg1555mmPhiN8JXyZcRjJhA5IpkMER
   eYuwUixM31ezy9FqsUP0Qc17vL1OkcAXVkEmUrahag1jXHC8VQ/duit6h
   Mvch/ly/vCDY6D6Vne/7vzZ89bHCIpkWOVnK3sh1Yt+YtOl0JtV2Wofyc
   XXxSLRZkIbOwnyXtZoG+tXO7Pqmz7VW/qDArmTucOe6qXye/u6qmLeqQ5
   vBfO/sf6wX8nFf2F+GplfCJa5SUnwVWjpoJzFmGweg3xZ/kLgg88IEnQw
   36YnhUVHbv0m5QdVe8LFUO4pKrhnoCdJaWlcmU1M7zrSTPWKae/9GZna9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="322887947"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="322887947"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685397945"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="685397945"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2023 05:12:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id BC69F3B3; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
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
        Paolo Abeni <pabeni@redhat.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v4 07/11] leds: mt6360: Get rid of custom led_init_default_state_get()
Date:   Tue,  3 Jan 2023 15:12:52 +0200
Message-Id: <20230103131256.33894-8-andriy.shevchenko@linux.intel.com>
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
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
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

