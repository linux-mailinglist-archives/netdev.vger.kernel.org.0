Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2DB670D8A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjAQXcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjAQXbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:31:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94FF8CE79;
        Tue, 17 Jan 2023 12:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989040; x=1705525040;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=zwa4GW5jWlP5YXzoa6EZS1ONEyHsZM9zF0qwfkL82oY=;
  b=u/cPn3TBeaR7EUtcKm9aOx3pra/8vg/XJL8x7k6vollR0PPHlZabuPmD
   VUDMITc39AlgMjmA6KUcI3SPEuHrQeIKdmAtCwtC4JkAXAr7bdk+1YzHi
   wLm2+RExXuGDcIls924eXxfHlg/oVwaIEDdF/2Y6SpD4yHkAcowdxEIuq
   Vsk6B1AdrHaDAd3GqYeJx1rKTeZVjHkvI3bb5OVZUgEQKnZT3n2hKEBAO
   EESgYc+pnOdQTWKYstzYSZhB5y2guR8D9UTXP/nAvWEq0e5SkkxgXvVbQ
   5bIFgbRFSkTL0HV69rlSgmn7cCGb5NyMwwCsYTYTKeuaJxFr4QzOlELzR
   w==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="132797655"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:15 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:13 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next: PATCH v7 4/7] dsa: lan9303: write reg only if necessary
Date:   Tue, 17 Jan 2023 14:57:00 -0600
Message-ID: <20230117205703.25960-5-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230117205703.25960-1-jerry.ray@microchip.com>
References: <20230117205703.25960-1-jerry.ray@microchip.com>
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
the boot-up time a bit by not bothering to clear a bit that is already
clear.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 66466d50d015..a4decf42a002 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -915,8 +915,11 @@ static int lan9303_setup(struct dsa_switch *ds)
 	if (ret)
 		return (ret);
 
-	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
-	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	/* Clear the TURBO Mode bit if it was set. */
+	if (reg & LAN9303_VIRT_SPECIAL_TURBO) {
+		reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	}
 
 	ret = lan9303_setup_tagging(chip);
 	if (ret)
-- 
2.17.1

