Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D8A58AD9E
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiHEPwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241360AbiHEPvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365E06BD74;
        Fri,  5 Aug 2022 08:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714559; x=1691250559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VQzFMWOPVcFhsKxRl9Czr0Mhj2oriMu0x8VLNQGEUCY=;
  b=KS87/PFud5pn+W3b/ZGkNaAFFOhS+7ErxiCgAsquYvk/4xfX+AnVxzXY
   r4nc+d7rds2DqWFpy+5pckwr+5jSmBvLhSB9sgWkSS0+2+iyWcNZjXqar
   1xX8pwnJkImSTxvufnZ1up0ZXtttLOyoWPh1chOQ4ImUKQUenhnOn2JSv
   UvONSKeK/Ol/WAH18tLlmFL1/gJBukFLvMF+AKc86RPHF05nBpt177qV5
   9TMQH65jerJYe+1sRzdPQ8PZt2HaZ+fmqostP8EBptAvt68vP03IVU7aC
   G6UCj6c08vpNE5VkIK+24AhYbfctcoapYvrucA00L+hVxspQbqzMq4H22
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="291003149"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291003149"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="600399032"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 05 Aug 2022 08:49:11 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E0D9141F; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
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
Subject: [PATCH v2 08/11] leds: pca955x: Get rid of custom led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:49:04 +0300
Message-Id: <20220805154907.32263-9-andriy.shevchenko@linux.intel.com>
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
 drivers/leds/leds-pca955x.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 81aaf21212d7..8dca6f99e699 100644
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
 
@@ -443,7 +443,6 @@ pca955x_get_pdata(struct i2c_client *client, struct pca955x_chipdef *chip)
 		return ERR_PTR(-ENOMEM);
 
 	device_for_each_child_node(&client->dev, child) {
-		const char *state;
 		u32 reg;
 		int res;
 
@@ -454,19 +453,9 @@ pca955x_get_pdata(struct i2c_client *client, struct pca955x_chipdef *chip)
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
@@ -578,13 +567,11 @@ static int pca955x_probe(struct i2c_client *client)
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
@@ -623,8 +610,7 @@ static int pca955x_probe(struct i2c_client *client)
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

