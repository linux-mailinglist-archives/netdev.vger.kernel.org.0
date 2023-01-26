Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3982267D749
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjAZVHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjAZVHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:07:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7455CE67;
        Thu, 26 Jan 2023 13:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A41ECB81E0A;
        Thu, 26 Jan 2023 21:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1796C433EF;
        Thu, 26 Jan 2023 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674767214;
        bh=9IWrwcLrstDZeuCYJT6dIx+OTz0TyqUya6nH3N9zhhM=;
        h=From:To:Cc:Subject:Date:From;
        b=cxWwJRgckrVll7tIC18ukU2A830AWnC0Cc34gLc30EZVjEC56fMYCk6fIcBEXvq2+
         GdLEU/yBG0RxC8wlKNsqLGGlVjc89HDDn2YTqa6BnUraPjAZzwFQuhJ2wsk0utqGfZ
         YPpNt58BVIg+mnpJqSYqNHdGCOUd4sMGAx4lbkrST+k4q3YMOSgjaqPLqWCnmNTaAB
         +8ZEKMWjZZYvm/esIaTmSdat6EnFr5SNva+ASuBVeWs3LMGQFdMgJI2UHKjH7T2cV+
         fbC1lHLe1e78JhS+y77/MBySUyAuXCcOTM2xS4AHAvi5Dr1QvLE1kDMj2RxJqsoY4c
         LrCzVaS1qcCow==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] fec: convert to gpio descriptor
Date:   Thu, 26 Jan 2023 22:05:59 +0100
Message-Id: <20230126210648.1668178-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver can be trivially converted, as it only triggers the gpio
pin briefly to do a reset, and it already only supports DT.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2 changes, suggested by Andrew Lunn:
 - reorder header inclusions,
 - use dev_err_probe()
---
 drivers/net/ethernet/freescale/fec_main.c | 25 ++++++++---------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5ff45b1a74a5..2716898e0b9b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -56,12 +56,12 @@
 #include <linux/fec.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/regulator/consumer.h>
 #include <linux/if_vlan.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/gpio/consumer.h>
 #include <linux/prefetch.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
@@ -4035,10 +4035,11 @@ static int fec_enet_init(struct net_device *ndev)
 #ifdef CONFIG_OF
 static int fec_reset_phy(struct platform_device *pdev)
 {
-	int err, phy_reset;
+	struct gpio_desc *phy_reset;
 	bool active_high = false;
 	int msec = 1, phy_post_delay = 0;
 	struct device_node *np = pdev->dev.of_node;
+	int err;
 
 	if (!np)
 		return 0;
@@ -4048,12 +4049,6 @@ static int fec_reset_phy(struct platform_device *pdev)
 	if (!err && msec > 1000)
 		msec = 1;
 
-	phy_reset = of_get_named_gpio(np, "phy-reset-gpios", 0);
-	if (phy_reset == -EPROBE_DEFER)
-		return phy_reset;
-	else if (!gpio_is_valid(phy_reset))
-		return 0;
-
 	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
 	/* valid reset duration should be less than 1s */
 	if (!err && phy_post_delay > 1000)
@@ -4061,20 +4056,18 @@ static int fec_reset_phy(struct platform_device *pdev)
 
 	active_high = of_property_read_bool(np, "phy-reset-active-high");
 
-	err = devm_gpio_request_one(&pdev->dev, phy_reset,
-			active_high ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
-			"phy-reset");
-	if (err) {
-		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
-		return err;
-	}
+	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
+			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
+	if (IS_ERR(phy_reset))
+		return dev_err_probe(&pdev->dev, PTR_ERR(phy_reset),
+				     "failed to get phy-reset-gpios\n");
 
 	if (msec > 20)
 		msleep(msec);
 	else
 		usleep_range(msec * 1000, msec * 1000 + 1000);
 
-	gpio_set_value_cansleep(phy_reset, !active_high);
+	gpiod_set_value_cansleep(phy_reset, !active_high);
 
 	if (!phy_post_delay)
 		return 0;
-- 
2.39.0

