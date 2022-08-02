Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7304858835D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiHBVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiHBVVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:21:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2C2F663;
        Tue,  2 Aug 2022 14:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659475300; x=1691011300;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kK0hPRdSyvWlZo38p4QMgn/ySqgObmyyzYJGxFidk7g=;
  b=l+9Ut9bwPznKk2SEo1deNvWRc4tQaEoiD0ak0+m5r/OO6uCaXa2nN+Yu
   mrNTTahAkrl3f/B5yIMYbLgV/qBawOrjyYDtH79mkFfx0us4Zosbb7rJr
   HcPnI7mgw5QpdBBc7k+YdKhNIPAfG2wTJlO5szhhfcKXT9TDrBx6xDYTo
   gaSkxH6EVOatub0rb/YBDIch9XuUA4Dic0DZZjGXV1focUJgIR5IDuqnv
   eUa8J8Q4VRoRZfiWEE/w18lIP0UPLGgG6tbaiQLU3PrXsNJPqLXuh1fEu
   N9Yawbld8vwIxOUc/5YhQwcktyBVfYH+zSTJp09OTFVoiiWxRbwUv1FUL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="289533759"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="289533759"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 14:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="692001798"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2022 14:21:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C211EF7; Wed,  3 Aug 2022 00:21:47 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v1 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
Date:   Wed,  3 Aug 2022 00:21:44 +0300
Message-Id: <20220802212144.6743-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

