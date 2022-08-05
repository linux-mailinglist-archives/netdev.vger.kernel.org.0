Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718E358AD93
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 17:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241344AbiHEPvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbiHEPvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 11:51:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7D467154;
        Fri,  5 Aug 2022 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659714556; x=1691250556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvEYSO7lW++ymJ0bBLH7ZRL0Q9IiAhclprxNUtYU6Os=;
  b=CIeTUa13qmrJYLXCR/bXJte7ghVZgiyOS45bQEvkweAev+s/FrtbR/tu
   leu9LBusXYMyeBTx99a3TPkv08gjdRCAogUW7Ugv6UzBPta1jkFh//uDq
   WlOcIKjKSxbCwZnouPNIcSBlUh/NQQvaZLVVdgEIDTnSagbdivGFjgkPh
   64KnttAV1PP2bcbdd0TozvreNsgs8zZW0PRVatFw/+hgFVc6iJf5EtYQd
   GAOa5esY20vvYGbaOCyflXnQhxVAdSyyz2DbR0IscWFfWmRI61VoPSOAB
   Shsa7Ad0fKwTpJh5rkVFcttN6jwnVBuRGdA7Y20IB7pUUXZe0jXY5TiVW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="277148756"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="277148756"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 08:49:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="706647818"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 05 Aug 2022 08:49:11 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0458B58E; Fri,  5 Aug 2022 18:49:16 +0300 (EEST)
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
Subject: [PATCH v2 10/11] leds: syscon: Get rid of custom led_init_default_state_get()
Date:   Fri,  5 Aug 2022 18:49:06 +0300
Message-Id: <20220805154907.32263-11-andriy.shevchenko@linux.intel.com>
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
 drivers/leds/leds-syscon.c | 49 ++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/leds-syscon.c b/drivers/leds/leds-syscon.c
index 7eddb8ecb44e..e38abb5e60c1 100644
--- a/drivers/leds/leds-syscon.c
+++ b/drivers/leds/leds-syscon.c
@@ -61,7 +61,8 @@ static int syscon_led_probe(struct platform_device *pdev)
 	struct device *parent;
 	struct regmap *map;
 	struct syscon_led *sled;
-	const char *state;
+	enum led_default_state state;
+	u32 value;
 	int ret;
 
 	parent = dev->parent;
@@ -86,34 +87,30 @@ static int syscon_led_probe(struct platform_device *pdev)
 	if (of_property_read_u32(np, "mask", &sled->mask))
 		return -EINVAL;
 
-	state = of_get_property(np, "default-state", NULL);
-	if (state) {
-		if (!strcmp(state, "keep")) {
-			u32 val;
-
-			ret = regmap_read(map, sled->offset, &val);
-			if (ret < 0)
-				return ret;
-			sled->state = !!(val & sled->mask);
-		} else if (!strcmp(state, "on")) {
-			sled->state = true;
-			ret = regmap_update_bits(map, sled->offset,
-						 sled->mask,
-						 sled->mask);
-			if (ret < 0)
-				return ret;
-		} else {
-			sled->state = false;
-			ret = regmap_update_bits(map, sled->offset,
-						 sled->mask, 0);
-			if (ret < 0)
-				return ret;
-		}
+	init_data.fwnode = of_fwnode_handle(np);
+
+	state = led_init_default_state_get(init_data.fwnode);
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		ret = regmap_update_bits(map, sled->offset, sled->mask, sled->mask);
+		if (ret < 0)
+			return ret;
+		sled->state = true;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		ret = regmap_read(map, sled->offset, &value);
+		if (ret < 0)
+			return ret;
+		sled->state = !!(value & sled->mask);
+		break;
+	default:
+		ret = regmap_update_bits(map, sled->offset, sled->mask, 0);
+		if (ret < 0)
+			return ret;
+		sled->state = false;
 	}
 	sled->cdev.brightness_set = syscon_led_set;
 
-	init_data.fwnode = of_fwnode_handle(np);
-
 	ret = devm_led_classdev_register_ext(dev, &sled->cdev, &init_data);
 	if (ret < 0)
 		return ret;
-- 
2.35.1

