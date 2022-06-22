Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA56554A17
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiFVMgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiFVMfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:35:53 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A6035AB7;
        Wed, 22 Jun 2022 05:35:52 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9B98622249;
        Wed, 22 Jun 2022 14:35:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1655901350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2rA0W5MQEkSqYtlT4qSoC6M5wvdwN+5pEfR1Vnrrfw=;
        b=fEscaRrS0S8pfj/seZ8BNUWdQ8uycvqEZsvctzKo1x7DaSt8P/uSJYX77paBf38R3XxGI0
        BmNhYwfm+cbap3apAf48oMkb09mdHWhU0zFYZFQnUdJJY1qSfXphkJzNTHxQESZr3Oxke+
        GIx938sHesGUKLhrYvji7qUOfmJtSM4=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()
Date:   Wed, 22 Jun 2022 14:35:43 +0200
Message-Id: <20220622123543.3463209-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622123543.3463209-1-michael@walle.cc>
References: <20220622123543.3463209-1-michael@walle.cc>
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

Instead of open-coding the bad characters replacement in the hwmon name,
use the new devm_hwmon_sanitize_name().

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/nxp-tja11xx.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 9944cc501806..2a8195c50d14 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -444,15 +444,10 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
 				  struct tja11xx_priv *priv)
 {
 	struct device *dev = &phydev->mdio.dev;
-	int i;
-
-	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
-	if (!priv->hwmon_name)
-		return -ENOMEM;
 
-	for (i = 0; priv->hwmon_name[i]; i++)
-		if (hwmon_is_bad_char(priv->hwmon_name[i]))
-			priv->hwmon_name[i] = '_';
+	priv->hwmon_name = devm_hwmon_sanitize_name(dev, dev_name(dev));
+	if (IS_ERR(priv->hwmon_name))
+		return PTR_ERR(priv->hwmon_name);
 
 	priv->hwmon_dev =
 		devm_hwmon_device_register_with_info(dev, priv->hwmon_name,
-- 
2.30.2

