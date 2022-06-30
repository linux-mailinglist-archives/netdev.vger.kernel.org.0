Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B035A561DD8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiF3OTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiF3OSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:18:00 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FD250707;
        Thu, 30 Jun 2022 07:02:49 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DA0F522248;
        Thu, 30 Jun 2022 16:02:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656597767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ass4dmeUBL1qbJ56Qd90hEzwbZXn4e7pswz+/m2UBRk=;
        b=XBGzYxbEe8yNmRuCYQV3Mm+5nZvD3U9eVQfguks0tK5VG7PGFDd5prmlhfl5MRyCV1jAm+
        IEjXAZMz6fnp9oD2nlJo5uHxtmO+/4pLXME6nKXMzNUxJbMpQ6/o0CIi9R05J4/eMLgW2m
        VrKn19wzHs1fV9xvx+Hum1jhfnA7CPY=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/4] net: lan966x: hardcode the number of external ports
Date:   Thu, 30 Jun 2022 16:02:34 +0200
Message-Id: <20220630140237.692986-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630140237.692986-1-michael@walle.cc>
References: <20220630140237.692986-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of counting the child nodes in the device tree, hardcode the
number of ports in the driver itself. The counting won't work at all
if an ethernet port is marked as disabled, eg. because it is not
connected on the board at all.

This is hardcoding the number of ports to eight for the generic
compatible string "microchip,lan966x-switch", although it clearly only
applies to the LAN9668. This is because, first, there is only one user
for now, and that is the LAN9668 and second, the generic compatible
string will be deprecated in favor of a more specific one. Therefore,
if there will be support for the LAN9662, it can be added by another
specific compatible string.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 5784c4161e5e..d611b52d3a07 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -26,8 +26,16 @@
 
 #define IO_RANGES 2
 
+struct lan966x_info {
+	u8 num_phys_ports;
+};
+
+static const struct lan966x_info lan9668_info = {
+	.num_phys_ports = 8,
+};
+
 static const struct of_device_id lan966x_match[] = {
-	{ .compatible = "microchip,lan966x-switch" },
+	{ .compatible = "microchip,lan966x-switch", .data = &lan9668_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, lan966x_match);
@@ -992,9 +1000,10 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
 static int lan966x_probe(struct platform_device *pdev)
 {
 	struct fwnode_handle *ports, *portnp;
+	const struct lan966x_info *info;
 	struct lan966x *lan966x;
 	u8 mac_addr[ETH_ALEN];
-	int err, i;
+	int err;
 
 	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
 	if (!lan966x)
@@ -1003,6 +1012,10 @@ static int lan966x_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
+	info = device_get_match_data(&pdev->dev);
+	if (!info)
+		return -ENODEV;
+
 	if (!device_get_mac_address(&pdev->dev, mac_addr)) {
 		ether_addr_copy(lan966x->base_mac, mac_addr);
 	} else {
@@ -1025,11 +1038,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		return dev_err_probe(&pdev->dev, err, "Reset failed");
 
-	i = 0;
-	fwnode_for_each_available_child_node(ports, portnp)
-		++i;
-
-	lan966x->num_phys_ports = i;
+	lan966x->num_phys_ports = info->num_phys_ports;
 	lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
 				      sizeof(struct lan966x_port *),
 				      GFP_KERNEL);
-- 
2.30.2

