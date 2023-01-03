Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2615A65C08A
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbjACNNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbjACNMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:12:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD0110B75;
        Tue,  3 Jan 2023 05:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751560; x=1704287560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aeuQDv8IZ9zZxqvE4KXWp0tWzJlo3lpo6FSE4G48zc0=;
  b=lgTpR+DI1OObEwgOSMAcdLqjnYhm9oEJsBoB+kbi0mtRvPtmy4fUWDSX
   3ICagxFiyE/iAXtuMeJJPVfwKJxe+6wKLmquV4Aik28JrlTWG2wHwgVWy
   PFBXda83fzC6x6gSu1Oxz/fVaKtia/zuz6E0NbQSsN3R3N5Rvl4vt7r8t
   ItSR/I8L3sF+PFUZg6IXWO6zKwWw7vKV3xQr+6yM/gEaR7OiyzjsRgMgN
   16GNrd1GIwCmUkuiuHh/EF3JcnQRZveGEhasHmThjo2B8iQMKnn9KOL8D
   u2YKRIPiDK4CX2lfMAqmp5I46OiBFmNL2NyDksvOMw7vp4h1o1KsrvwqA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="320367289"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="320367289"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="654781149"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="654781149"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 03 Jan 2023 05:12:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C7B4719E; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
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
Subject: [PATCH v4 08/11] leds: pca955x: Get rid of custom led_init_default_state_get()
Date:   Tue,  3 Jan 2023 15:12:53 +0200
Message-Id: <20230103131256.33894-9-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/leds/leds-pca955x.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 33ec4543fb4f..1edd092e7894 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -130,7 +130,7 @@ struct pca955x_led {
 	struct led_classdev	led_cdev;
 	int			led_num;	/* 0 .. 15 potentially */
 	u32			type;
-	int			default_state;
+	enum led_default_state	default_state;
 	struct fwnode_handle	*fwnode;
 };
 
@@ -437,7 +437,6 @@ pca955x_get_pdata(struct i2c_client *client, struct pca955x_chipdef *chip)
 		return ERR_PTR(-ENOMEM);
 
 	device_for_each_child_node(&client->dev, child) {
-		const char *state;
 		u32 reg;
 		int res;
 
@@ -448,19 +447,9 @@ pca955x_get_pdata(struct i2c_client *client, struct pca955x_chipdef *chip)
 		led = &pdata->leds[reg];
 		led->type = PCA955X_TYPE_LED;
 		led->fwnode = child;
-		fwnode_property_read_u32(child, "type", &led->type);
+		led->default_state = led_init_default_state_get(child);
 
-		if (!fwnode_property_read_string(child, "default-state",
-						 &state)) {
-			if (!strcmp(state, "keep"))
-				led->default_state = LEDS_GPIO_DEFSTATE_KEEP;
-			else if (!strcmp(state, "on"))
-				led->default_state = LEDS_GPIO_DEFSTATE_ON;
-			else
-				led->default_state = LEDS_GPIO_DEFSTATE_OFF;
-		} else {
-			led->default_state = LEDS_GPIO_DEFSTATE_OFF;
-		}
+		fwnode_property_read_u32(child, "type", &led->type);
 	}
 
 	pdata->num_leds = chip->bits;
@@ -572,13 +561,11 @@ static int pca955x_probe(struct i2c_client *client)
 			led->brightness_set_blocking = pca955x_led_set;
 			led->brightness_get = pca955x_led_get;
 
-			if (pdata->leds[i].default_state ==
-			    LEDS_GPIO_DEFSTATE_OFF) {
+			if (pdata->leds[i].default_state == LEDS_DEFSTATE_OFF) {
 				err = pca955x_led_set(led, LED_OFF);
 				if (err)
 					return err;
-			} else if (pdata->leds[i].default_state ==
-				   LEDS_GPIO_DEFSTATE_ON) {
+			} else if (pdata->leds[i].default_state == LEDS_DEFSTATE_ON) {
 				err = pca955x_led_set(led, LED_FULL);
 				if (err)
 					return err;
@@ -617,8 +604,7 @@ static int pca955x_probe(struct i2c_client *client)
 			 * brightness to see if it's using PWM1. If so, PWM1
 			 * should not be written below.
 			 */
-			if (pdata->leds[i].default_state ==
-			    LEDS_GPIO_DEFSTATE_KEEP) {
+			if (pdata->leds[i].default_state == LEDS_DEFSTATE_KEEP) {
 				if (led->brightness != LED_FULL &&
 				    led->brightness != LED_OFF &&
 				    led->brightness != LED_HALF)
-- 
2.35.1

