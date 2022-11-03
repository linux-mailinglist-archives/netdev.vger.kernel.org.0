Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CB617F9E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiKCObf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKCObd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:31:33 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3036DF5D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 07:31:32 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bp15so3086181lfb.13
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 07:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPR7/0o5sZORvIjDuGdyoFuwN3lYbX8ONLuHVOyiI9s=;
        b=L232aSwFaiuvBuuJCYabtV+4J9vpiaMZm31Mh1glJsQ8r+cU91vW8Eb5GbhQzYH8hG
         DYsywGe1lewcWZfvW5QDl4HAeO9aQ5OWyZL4Go1duOVHZ62tZoleXI2UW9cQleVK/KH5
         DvTxOjS+oTp5wes6ZYeI6cUH7HbkDMlv7JmQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPR7/0o5sZORvIjDuGdyoFuwN3lYbX8ONLuHVOyiI9s=;
        b=7hQm2Wpu+fXb3WiLCJvJPFbhN5ub1qUUY0/gdmSAdyLmOSSvqAghA3H0eCoukKA3Pi
         HDrh26/LvyL2IIO2SHZSu8BY21E59yHWVGIKtwibvafsAHvTOTjCFuZcTKjbi1t5UzOp
         MqZXldiLhuych8lPJfNiD4coPVZ4wAp3aoheHjB3rT5pFB4t9uBQahUeLXhHqrCBcARY
         Zp7k6V/tnG0oqbMr2hKmw0E1SEkyUSx3vZtkS0LP0QZOe5GmZUvxEy2Q0AXOgNrKbN96
         zgyO0ttMNrEyk9+14GDjhaa1ZWisIgDfijezCw/QqgzHjB4pg3toyJCSeJ/vagi/1tUp
         G2nw==
X-Gm-Message-State: ACrzQf2Wa+9tHOqUz1IsrONYzFDa5+J6m6W+jWgU0mtIa7kxVfQB3vls
        kS3cJtWh5as6/Yxf8hIy2OPGvQ==
X-Google-Smtp-Source: AMsMyM4qo9IUgKGxtlfS2PE0KZVrx81zWVB2S8HnnZ4uODbUefXXdfXJz9VrzGRu5R8NWpNZrkNq0w==
X-Received: by 2002:a05:6512:39c2:b0:4a2:500f:aed5 with SMTP id k2-20020a05651239c200b004a2500faed5mr12705658lfu.111.1667485890534;
        Thu, 03 Nov 2022 07:31:30 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a13-20020a056512200d00b00494643db68bsm151951lfb.78.2022.11.03.07.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:31:29 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] net: phy: dp83867: implement support for ti,ledX-active-low bindings
Date:   Thu,  3 Nov 2022 15:31:18 +0100
Message-Id: <20221103143118.2199316-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LED_X_POLARITY bits in the LEDCR2 register are default 1, meaning
the LEDs are driven as active high. On some boards, the LEDs are
active low, so implement support for clearing those bits when the
corresponding ti,ledX-active-low DT property is present.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/phy/dp83867.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 417527f8bbf5..8e8078ef2881 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,7 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR2		0x19
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -140,6 +141,11 @@
 #define DP83867_DOWNSHIFT_8_COUNT	8
 #define DP83867_SGMII_AUTONEG_EN	BIT(7)
 
+/* LEDCR2 bits */
+#define DP83867_LEDCR2_LED_0_POLARITY		BIT(2)
+#define DP83867_LEDCR2_LED_1_POLARITY		BIT(6)
+#define DP83867_LEDCR2_LED_2_POLARITY		BIT(10)
+
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
 #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
@@ -167,6 +173,9 @@ struct dp83867_private {
 	bool set_clk_output;
 	u32 clk_output_sel;
 	bool sgmii_ref_clk_en;
+	bool led0_active_low;
+	bool led1_active_low;
+	bool led2_active_low;
 };
 
 static int dp83867_ack_interrupt(struct phy_device *phydev)
@@ -658,6 +667,13 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	dp83867->led0_active_low = of_property_read_bool(of_node,
+							 "ti,led0-active-low");
+	dp83867->led1_active_low = of_property_read_bool(of_node,
+							 "ti,led1-active-low");
+	dp83867->led2_active_low = of_property_read_bool(of_node,
+							 "ti,led2-active-low");
+
 	return 0;
 }
 #else
@@ -890,6 +906,22 @@ static int dp83867_config_init(struct phy_device *phydev)
 			       mask, val);
 	}
 
+	if (dp83867->led0_active_low) {
+		ret = phy_modify(phydev, DP83867_LEDCR2, DP83867_LEDCR2_LED_0_POLARITY, 0);
+		if (ret)
+			return ret;
+	}
+	if (dp83867->led1_active_low) {
+		ret = phy_modify(phydev, DP83867_LEDCR2, DP83867_LEDCR2_LED_1_POLARITY, 0);
+		if (ret)
+			return ret;
+	}
+	if (dp83867->led2_active_low) {
+		ret = phy_modify(phydev, DP83867_LEDCR2, DP83867_LEDCR2_LED_2_POLARITY, 0);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.37.2

