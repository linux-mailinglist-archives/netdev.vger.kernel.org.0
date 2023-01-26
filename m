Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C5D67CCE0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjAZNyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjAZNyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:54:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD416226A;
        Thu, 26 Jan 2023 05:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3A9B81BEA;
        Thu, 26 Jan 2023 13:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EB3C433EF;
        Thu, 26 Jan 2023 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674741225;
        bh=W1LnY595Ov6jF+hpZHXAZjn52UQrvhyKdsYdkv/rH60=;
        h=From:To:Cc:Subject:Date:From;
        b=hGrguENhWyWwHVtsJzGh4GTTlYEFLeB8iopGwjoPBOAqRsokQc/sxzDHaWysNjHsX
         jyB/ggwIK8dGtAwiEw4lmFZl3/IsiFaa2KBZyOfSNZnNgkbM+3pF7pkmBxddfkMzY2
         zy3vaaSFIKVB0bjmwKneIdTWjLjIuq0d1G7cg96KGG1YdukVYLKBTmI1nhd9c30RZo
         rsERjYQ1rOHAggtqYNLu5C/VDT/4xm3ScmfSPGWWJ3pRuJakMoFrObe2kxdmcdRoNL
         jbDW2+5pTn2e6HUXw/jPfW7UPnNx7X7A+sJesOxmnXSkskrxuDMvJ3K2o0nirY192A
         vPxMImCp0iRzg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fec: convert to gpio descriptor
Date:   Thu, 26 Jan 2023 14:52:58 +0100
Message-Id: <20230126135339.3488682-1-arnd@kernel.org>
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
 drivers/net/ethernet/freescale/fec_main.c | 25 ++++++++++-------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5ff45b1a74a5..dee2890fd702 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -56,7 +56,7 @@
 #include <linux/fec.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/regulator/consumer.h>
@@ -4035,7 +4035,8 @@ static int fec_enet_init(struct net_device *ndev)
 #ifdef CONFIG_OF
 static int fec_reset_phy(struct platform_device *pdev)
 {
-	int err, phy_reset;
+	int err;
+	struct gpio_desc *phy_reset;
 	bool active_high = false;
 	int msec = 1, phy_post_delay = 0;
 	struct device_node *np = pdev->dev.of_node;
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
@@ -4061,11 +4056,13 @@ static int fec_reset_phy(struct platform_device *pdev)
 
 	active_high = of_property_read_bool(np, "phy-reset-active-high");
 
-	err = devm_gpio_request_one(&pdev->dev, phy_reset,
-			active_high ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
-			"phy-reset");
-	if (err) {
-		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
+	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
+			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
+	if (IS_ERR(phy_reset)) {
+		err = PTR_ERR(phy_reset);
+		if (err != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to get phy-reset-gpios: %d\n", err);
 		return err;
 	}
 
@@ -4074,7 +4071,7 @@ static int fec_reset_phy(struct platform_device *pdev)
 	else
 		usleep_range(msec * 1000, msec * 1000 + 1000);
 
-	gpio_set_value_cansleep(phy_reset, !active_high);
+	gpiod_set_value_cansleep(phy_reset, !active_high);
 
 	if (!phy_post_delay)
 		return 0;
-- 
2.39.0

