Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669665AF652
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiIFUta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiIFUt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:49:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DD1E99;
        Tue,  6 Sep 2022 13:49:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o4so12511916pjp.4;
        Tue, 06 Sep 2022 13:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KJYp1zfVvwJHJHkMhxfowkWQ7RAPypxyqcgS+k23cys=;
        b=qS6qxFg8Q9+sTHY7Kw1qn4myoojesKDAukNzzf1quR0tc3w9XKteaw9cFnj0D2bJth
         LpZdaxD0mo85T9iDZXEkJWiqnl/FjqMv/HSDLMu3kSkBPltmLKh0F06vmbS4+d7c1PqY
         mG/HELC/SbxJ/A8O/v10WrVA1r3tJK/JJnm5RjPeCepFuGO7pFRDgFjEBaxsT8bcSXRP
         uwAgNBgghepPjYvqB/KrK3T8fnC2l8RuxH+JhUjl3xaUZcmdnMAKNBO09L3oIu0XYnzk
         p/i0+afBw3RlYlZToqKiZ2P+fLegIEq/FKvKAssquLVcXnR3zVKyO+gnrUZOL4XNmWed
         Ydwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KJYp1zfVvwJHJHkMhxfowkWQ7RAPypxyqcgS+k23cys=;
        b=dVU/R0KQdxO0bVuuZnZVHSm8vR9D7e2FPCVIiVFT/knEAksGa7HyzorcoeZnuDuUmB
         OdTyQ5H0Jvk0hS24/6JYDgImiRWX7vSm05gUOGC9jJOPynPDuhPlezC7mbkj2B20xv8o
         51egdynswHKLWwfFCxpWTzt1qYYAPX3CZukMYFKnvTvWvwPJgPLln4R4zY2q2iL6dhg1
         ON//9NKxyOdltxlAYIKAL3D54mAGLIGI/AIqmhebIekcn4lCZF3jTvZCdbAPq9uvopKU
         6u1DkBxaAavxzJyF+A3xHmHjpa8apI/sDL6uJG2oBxDf0nH4i+YvqdF6YOhsp8/IPLIm
         VqUQ==
X-Gm-Message-State: ACgBeo0GKLJHDNl5RmYz/nus6nqc+xfMZuGJmROojtcFZg6Hcw9JXjkP
        1mB0vxqIxW9fBidIYBLVwfw=
X-Google-Smtp-Source: AA6agR5C3vks1BNI5tECMMk1F6pNr7y+uvArmo3hAPEaEnUa78DxFdEAYa8wVfo18CtwimaI40D5iA==
X-Received: by 2002:a17:902:8d88:b0:175:368a:5e1e with SMTP id v8-20020a1709028d8800b00175368a5e1emr117297plo.5.1662497364927;
        Tue, 06 Sep 2022 13:49:24 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:abc4:5d24:5a73:a96b])
        by smtp.gmail.com with ESMTPSA id e6-20020a656886000000b00434e2e1a82bsm61664pgt.66.2022.09.06.13.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:49:24 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Date:   Tue,  6 Sep 2022 13:49:20 -0700
Message-Id: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch switches the driver away from legacy gpio/of_gpio API to
gpiod API, and removes use of of_get_named_gpio_flags() which I want to
make private to gpiolib.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/ethernet/davicom/dm9000.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 77229e53b04e..c85a6ebd79fc 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -28,8 +28,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
-#include <linux/gpio.h>
-#include <linux/of_gpio.h>
+#include <linux/gpio/consumer.h>
 
 #include <asm/delay.h>
 #include <asm/irq.h>
@@ -1421,8 +1420,7 @@ dm9000_probe(struct platform_device *pdev)
 	int iosize;
 	int i;
 	u32 id_val;
-	int reset_gpios;
-	enum of_gpio_flags flags;
+	struct gpio_desc *reset_gpio;
 	struct regulator *power;
 	bool inv_mac_addr = false;
 	u8 addr[ETH_ALEN];
@@ -1442,20 +1440,24 @@ dm9000_probe(struct platform_device *pdev)
 		dev_dbg(dev, "regulator enabled\n");
 	}
 
-	reset_gpios = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0,
-					      &flags);
-	if (gpio_is_valid(reset_gpios)) {
-		ret = devm_gpio_request_one(dev, reset_gpios, flags,
-					    "dm9000_reset");
+	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	ret = PTR_ERR_OR_ZERO(reset_gpio);
+	if (ret) {
+		dev_err(dev, "failed to request reset gpio: %d\n", ret);
+		goto out_regulator_disable;
+	}
+
+	if (reset_gpio) {
+		ret = gpiod_set_consumer_name(reset_gpio, "dm9000_reset");
 		if (ret) {
-			dev_err(dev, "failed to request reset gpio %d: %d\n",
-				reset_gpios, ret);
+			dev_err(dev, "failed to set reset gpio name: %d\n",
+				ret);
 			goto out_regulator_disable;
 		}
 
 		/* According to manual PWRST# Low Period Min 1ms */
 		msleep(2);
-		gpio_set_value(reset_gpios, 1);
+		gpiod_set_value_cansleep(reset_gpio, 0);
 		/* Needs 3ms to read eeprom when PWRST is deasserted */
 		msleep(4);
 	}
-- 
2.37.2.789.g6183377224-goog

