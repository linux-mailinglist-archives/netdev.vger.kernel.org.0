Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5248A648ADC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLIWr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiLIWrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69499A5DE4;
        Fri,  9 Dec 2022 14:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626040; x=1702162040;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=01J1GdfGeDpMqj5EEuZPKItLr8DiKEKk/dDza5yX0co=;
  b=PpkHHs37s77kPHiDMUJG1YQGSUS+MiBZ2E+Jf6VbtXjRAiljUCmj5oo+
   cjsPXbxXjqvAhAIlBbBzJ+WYfvJ6x82IUwthUfgpuArnZ0JKpknFnXxyb
   4bameXe1tJOqbyg2CjDRSYhs4yePjTgi62/acZfhX+TX+LLVc4B3FPKs/
   azJ9revQuxKwR2qNZdLxLbc/4HZ5GBiNCbvyTyhTCR3Qe69nHacNCim2o
   XXK0JrpQdF1JBkHRetziDjzBAT//ybYUYGKK4yyKjkQP2CLVUQNHHmhTb
   27t5Oi8slqJ1ujO4bQa+tv51YDcs9QyU+LjroP1BjLIp6mZf7seKw32hs
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="203381009"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:19 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:18 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 4/6] dsa: lan9303: Performance Optimization
Date:   Fri, 9 Dec 2022 16:47:11 -0600
Message-ID: <20221209224713.19980-5-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the regmap_write() is over a slow bus that will sleep, we can speed up
the boot-up time a bit my not bothering to clear a bit that is already
clear.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index b0f49d9c3d0c..694249aa1f19 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -891,8 +891,11 @@ static int lan9303_check_device(struct lan9303 *chip)
 	if (ret)
 		return (ret);
 
-	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
-	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	/* Clear the TURBO Mode bit if it was set. */
+	if (reg & LAN9303_VIRT_SPECIAL_TURBO) {
+		reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	}
 
 	return 0;
 }
-- 
2.17.1

