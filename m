Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27D465C09F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbjACNNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237730AbjACNNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:13:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2994F10FCA;
        Tue,  3 Jan 2023 05:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751564; x=1704287564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9YAyO0NuKkjE8s2MjpGiLsRbRFZd9cli0OG3nOsmD+I=;
  b=MuDNEBmli6TnNdQW14WCV4+aEE0WA9x1pYBpWmgz0R5onaKmxBMsocwg
   OBU1ChFtkiedbTFmseOiVEFfQqDAdJlf3T4hUYLxhTbr0wnmwk5inLsXz
   nzn6KVgxSUihqkrl+cgAYzMqShvJL2whKOAZLiy4bHqypjUbeui8e/jX7
   1Vhgz5p/nyAL+3WUurV5er3JBFeKf+6/QepwI09K/ng9bq0dGo8CmYsxE
   cTqMdkvfOKNHkC8tMyndnpPeJrymrkHJ/Lazx1YSuzfoRYj3zJ4NrCbwJ
   RTTFl7TinoHYOsBD8ZI0HQbTCgDTF4ttawY9RFeiPV9TlL8jJDqSY0Upa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="322887989"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="322887989"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685397942"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="685397942"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2023 05:12:33 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B095E2AD; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
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
Subject: [PATCH v4 06/11] leds: mt6323: Get rid of custom led_init_default_state_get()
Date:   Tue,  3 Jan 2023 15:12:51 +0200
Message-Id: <20230103131256.33894-7-andriy.shevchenko@linux.intel.com>
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
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/leds/leds-mt6323.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/leds/leds-mt6323.c b/drivers/leds/leds-mt6323.c
index f59e0e8bda8b..17ee88043f52 100644
--- a/drivers/leds/leds-mt6323.c
+++ b/drivers/leds/leds-mt6323.c
@@ -339,23 +339,23 @@ static int mt6323_led_set_dt_default(struct led_classdev *cdev,
 				     struct device_node *np)
 {
 	struct mt6323_led *led = container_of(cdev, struct mt6323_led, cdev);
-	const char *state;
+	enum led_default_state state;
 	int ret = 0;
 
-	state = of_get_property(np, "default-state", NULL);
-	if (state) {
-		if (!strcmp(state, "keep")) {
-			ret = mt6323_get_led_hw_brightness(cdev);
-			if (ret < 0)
-				return ret;
-			led->current_brightness = ret;
-			ret = 0;
-		} else if (!strcmp(state, "on")) {
-			ret =
-			mt6323_led_set_brightness(cdev, cdev->max_brightness);
-		} else  {
-			ret = mt6323_led_set_brightness(cdev, LED_OFF);
-		}
+	state = led_init_default_state_get(of_fwnode_handle(np));
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		ret = mt6323_led_set_brightness(cdev, cdev->max_brightness);
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		ret = mt6323_get_led_hw_brightness(cdev);
+		if (ret < 0)
+			return ret;
+		led->current_brightness = ret;
+		ret = 0;
+		break;
+	default:
+		ret = mt6323_led_set_brightness(cdev, LED_OFF);
 	}
 
 	return ret;
-- 
2.35.1

