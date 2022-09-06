Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5615AEC31
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiIFOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241942AbiIFOTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:19:04 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A326D72EF8;
        Tue,  6 Sep 2022 06:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472210; x=1694008210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WhGrjx6LzV2jk/LAfomo4zdb3Tdn1LBofxlORU1JDv0=;
  b=jo8khdHDdPFN+CGj7Ow/ElVWwUJ11vwSf8AIUrgPCTIrlkEOF8CJxPiM
   mRhII4nJTfS5Jr6BRI8zIxnuKsanZ/eiIZCi5UZcXQwdsOvgvjN476S5b
   niT4medvkBVW2w/GatGnEqj/xamAqreu0lj/6rCIjZYooh+zMVmO6dMBm
   Q4l4zWON5cW95dtFJn+za7oTPCIoLxuiSgi+EGPAqXeoXnIoXu5kCp9FW
   6hPdLZJ9gHR0ETFJZcd7g8x0hiQUAYtMGprf74cDD9QdLwtyje/9cMvIh
   6xxzZrxiVe1rXadROgKSnE36Ox6Z/7tOy4JhqcwaPIylP0BcfMMdYHV3R
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="276990322"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="276990322"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="614098830"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 06 Sep 2022 06:50:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D6828781; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
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
Subject: [PATCH v3 11/11] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:50:04 +0300
Message-Id: <20220906135004.14885-12-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index b28baab6d56a..793b2c296314 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(struct led_classdev *ldev)
 static int hellcreek_led_setup(struct hellcreek *hellcreek)
 {
 	struct device_node *leds, *led = NULL;
-	const char *label, *state;
+	enum led_default_state state;
+	const char *label;
 	int ret = -EINVAL;
 
 	of_node_get(hellcreek->dev->of_node);
@@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	ret = of_property_read_string(led, "label", &label);
 	hellcreek->led_sync_good.name = ret ? "sync_good" : label;
 
-	ret = of_property_read_string(led, "default-state", &state);
-	if (!ret) {
-		if (!strcmp(state, "on"))
-			hellcreek->led_sync_good.brightness = 1;
-		else if (!strcmp(state, "off"))
-			hellcreek->led_sync_good.brightness = 0;
-		else if (!strcmp(state, "keep"))
-			hellcreek->led_sync_good.brightness =
-				hellcreek_get_brightness(hellcreek,
-							 STATUS_OUT_SYNC_GOOD);
+	state = led_init_default_state_get(of_fwnode_handle(led));
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		hellcreek->led_sync_good.brightness = 1;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		hellcreek->led_sync_good.brightness =
+				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
+		break;
+	default:
+		hellcreek->led_sync_good.brightness = 0;
 	}
 
 	hellcreek->led_sync_good.max_brightness = 1;
@@ -344,16 +346,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	ret = of_property_read_string(led, "label", &label);
 	hellcreek->led_is_gm.name = ret ? "is_gm" : label;
 
-	ret = of_property_read_string(led, "default-state", &state);
-	if (!ret) {
-		if (!strcmp(state, "on"))
-			hellcreek->led_is_gm.brightness = 1;
-		else if (!strcmp(state, "off"))
-			hellcreek->led_is_gm.brightness = 0;
-		else if (!strcmp(state, "keep"))
-			hellcreek->led_is_gm.brightness =
-				hellcreek_get_brightness(hellcreek,
-							 STATUS_OUT_IS_GM);
+	state = led_init_default_state_get(of_fwnode_handle(led));
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		hellcreek->led_is_gm.brightness = 1;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		hellcreek->led_is_gm.brightness =
+				hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
+		break;
+	default:
+		hellcreek->led_is_gm.brightness = 0;
 	}
 
 	hellcreek->led_is_gm.max_brightness = 1;
-- 
2.35.1

