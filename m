Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5257767C
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 15:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiGQN6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 09:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiGQN6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 09:58:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F30559F
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 06:58:50 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n6-0007o1-9R; Sun, 17 Jul 2022 15:58:36 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n4-001WaF-Fm; Sun, 17 Jul 2022 15:58:34 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n3-00ASWD-Sp; Sun, 17 Jul 2022 15:58:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v2 2/2] net: dsa: vitesse-vsc73xx: silent spi_device_id warnings
Date:   Sun, 17 Jul 2022 15:58:31 +0200
Message-Id: <20220717135831.2492844-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220717135831.2492844-1-o.rempel@pengutronix.de>
References: <20220717135831.2492844-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add spi_device_id entries to silent SPI warnings.

Fixes: 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT compatible")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/vitesse-vsc73xx-spi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 3110895358d8..97a92e6da60d 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -205,10 +205,20 @@ static const struct of_device_id vsc73xx_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
 
+static const struct spi_device_id vsc73xx_spi_ids[] = {
+	{ "vsc7385" },
+	{ "vsc7388" },
+	{ "vsc7395" },
+	{ "vsc7398" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, vsc73xx_spi_ids);
+
 static struct spi_driver vsc73xx_spi_driver = {
 	.probe = vsc73xx_spi_probe,
 	.remove = vsc73xx_spi_remove,
 	.shutdown = vsc73xx_spi_shutdown,
+	.id_table = vsc73xx_spi_ids,
 	.driver = {
 		.name = "vsc73xx-spi",
 		.of_match_table = vsc73xx_of_match,
-- 
2.30.2

