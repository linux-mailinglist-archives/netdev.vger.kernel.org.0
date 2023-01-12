Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD0667A79
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbjALQPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbjALQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:13:44 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88307FF9;
        Thu, 12 Jan 2023 08:11:10 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 067DFE000A;
        Thu, 12 Jan 2023 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673539868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xxLaGegYQm28LPQufEzUPjtyh2y4iexg9LenfhO2O48=;
        b=EqqUksdz+Wxq6Gb1gYEudLrOKAe6EUtL7snjY2ALGo/XyVZWK5kbc0Ci4x8VjqIjS6I0MJ
        wku7KgfrCf9VXTh6JS+da4MAe7Tq/tl3U+toTpiTxnoj+zROPElOn/sDeOuzRSdvJsIt96
        j1xGSq/GcSW+ffjsAnbE2fxVgQPnc2RBEKanRokilGdBGhV5m0y4Hf3nNiHVekdUAGAaly
        +Ut4rcW5AlyuvCW7OoWilecspetpaxhjWasBYkcoVVfefKKHh1Hs/8rWvkf4cvM8nA+Vvi
        7MwwPRxupXsRs+iSB7+aWxer4JfV1ii+4tn4wTzhBYtf1Yyga4hI/POh2QLxZQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: lan966x: add missing fwnode_handle_put() for ports node
Date:   Thu, 12 Jan 2023 17:13:11 +0100
Message-Id: <20230112161311.495124-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the "ethernet-ports" node is retrieved using
device_get_named_child_node(), it should be release after using it. Add
missing fwnode_handle_put() and move the code that retrieved the node
from device-tree to avoid complicated handling in case of error.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_main.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index cadde20505ba..580c91d24a52 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1043,11 +1043,6 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->base_mac[5] &= 0xf0;
 	}
 
-	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
-	if (!ports)
-		return dev_err_probe(&pdev->dev, -ENODEV,
-				     "no ethernet-ports child found\n");
-
 	err = lan966x_create_targets(pdev, lan966x);
 	if (err)
 		return dev_err_probe(&pdev->dev, err,
@@ -1125,6 +1120,11 @@ static int lan966x_probe(struct platform_device *pdev)
 		}
 	}
 
+	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
+	if (!ports)
+		return dev_err_probe(&pdev->dev, -ENODEV,
+				     "no ethernet-ports child found\n");
+
 	/* init switch */
 	lan966x_init(lan966x);
 	lan966x_stats_init(lan966x);
@@ -1162,6 +1162,8 @@ static int lan966x_probe(struct platform_device *pdev)
 			goto cleanup_ports;
 	}
 
+	fwnode_handle_put(ports);
+
 	lan966x_mdb_init(lan966x);
 	err = lan966x_fdb_init(lan966x);
 	if (err)
@@ -1191,6 +1193,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	lan966x_fdb_deinit(lan966x);
 
 cleanup_ports:
+	fwnode_handle_put(ports);
 	fwnode_handle_put(portnp);
 
 	lan966x_cleanup_ports(lan966x);
-- 
2.39.0

