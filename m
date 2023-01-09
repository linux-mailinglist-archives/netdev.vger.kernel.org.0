Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D856632B6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbjAIVTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbjAIVTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:19:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDCC189;
        Mon,  9 Jan 2023 13:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673299144; x=1704835144;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=VxkEKNZWJ3KcbW8rhbq+3YllhYbn54Q2UHPI5yThc9c=;
  b=rLjjGqJ9wClvDy/rJaz7WXhSGdZ0W14ay/pj/VXLOU1VCr1ieBLr3Iqi
   TVhWDIlQqQ0OUu0SGYtaafMVobiIaMZXXuF0Q3fkfAivFZZtY4Xrp5BHU
   RcjwJC2J4USKjkDyQ9j2q74fC8kdmgkYBI80VVRzOGfLkNU4jiitkfdly
   0a+dX8HsfcgefJMJhbYY2/IocicznELetZBmDwHGaoGxifXrX5Iqphmq/
   SITqg3j+0sGnOQaP/aEhNbJ+8l2xFjaN2Hji4QBp++dGRoCVdofeGgwzV
   EGjJv2Gvb8Xpf750jC2zd9g34qZfEi6XyYPm5R8jeaUzqbAwCd5oS40fP
   w==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="131543896"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2023 14:19:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:19:01 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:18:59 -0700
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
Subject: [PATCH net-next v6 3/6] dsa: lan9303: Add exception logic for read failure
Date:   Mon, 9 Jan 2023 15:18:46 -0600
Message-ID: <20230109211849.32530-4-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109211849.32530-1-jerry.ray@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
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

While it is highly unlikely a read will ever fail, This code fragment is
now in a function that allows us to return an error code. A read failure
here will cause the lan9303_probe to fail.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 50470fb09cb4..8eee340f6464 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -887,7 +887,9 @@ static int lan9303_check_device(struct lan9303 *chip)
 	}
 
 	/* Virtual Phy: Remove Turbo 200Mbit mode */
-	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	if (ret)
+		return (ret);
 
 	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
 	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
-- 
2.17.1

