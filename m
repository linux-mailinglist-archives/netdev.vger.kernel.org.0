Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF84EB167
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbiC2QJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbiC2QJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:09:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F74525ECB7;
        Tue, 29 Mar 2022 09:07:48 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 833A52224E;
        Tue, 29 Mar 2022 18:07:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648570066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imZMY4F+ZI6v2U65NYSEw0/ID6RW/Q6WN7XlgY4LESA=;
        b=AEdNRE7cumjAdzG4X2aihooUkySO+Vo7zKqYHnpZs/JYnhMlfneyvURmtq9ZwN4wmpq9rT
        v8qpYQ5Qz2U1FaIlHUlHKHniaJVTfg2+MIlFKuP8bkuu/jbCyLUc+yZ2fH14WF00EF7uI8
        dW371Kl/8QwlTA++kw3lwX+jzi2S7Qo=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v2 4/5] net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()
Date:   Tue, 29 Mar 2022 18:07:29 +0200
Message-Id: <20220329160730.3265481-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220329160730.3265481-1-michael@walle.cc>
References: <20220329160730.3265481-1-michael@walle.cc>
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
 drivers/net/phy/nxp-tja11xx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 9944cc501806..8088c2a4a000 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -444,16 +444,11 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
 				  struct tja11xx_priv *priv)
 {
 	struct device *dev = &phydev->mdio.dev;
-	int i;
 
-	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	priv->hwmon_name = devm_hwmon_sanitize_name(dev, dev_name(dev));
 	if (!priv->hwmon_name)
 		return -ENOMEM;
 
-	for (i = 0; priv->hwmon_name[i]; i++)
-		if (hwmon_is_bad_char(priv->hwmon_name[i]))
-			priv->hwmon_name[i] = '_';
-
 	priv->hwmon_dev =
 		devm_hwmon_device_register_with_info(dev, priv->hwmon_name,
 						     phydev,
-- 
2.30.2

