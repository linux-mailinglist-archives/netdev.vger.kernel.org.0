Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDF5124BA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbiD0Vre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiD0Vra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:47:30 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD29990CFD;
        Wed, 27 Apr 2022 14:44:17 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 107702224F;
        Wed, 27 Apr 2022 23:44:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651095856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZBt1l3i9yMtBGGJUs1rxSD47mkigaWNIdw2JUlhznE=;
        b=lncMZBuyvUpQc6738g6D5pmTykds0mEYb1aXKMUS8DFQ3M0nPYnOQW9QY3Q4UpfqhcgWTA
        9CuKjAvNwp0cucvxk55iH8FGBRPnQZ3pvoladE0nPmsZAvpkUP4Dq9Ej41jLz4XA0tHt9e
        i4R+A5oC3fv3xkXL7Qphl/znBbsXC1M=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
Date:   Wed, 27 Apr 2022 23:44:06 +0200
Message-Id: <20220427214406.1348872-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220427214406.1348872-1-michael@walle.cc>
References: <20220427214406.1348872-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8814 has a coma mode pin which puts the PHY into isolate and
power-dowm mode. Unfortunately, the mode cannot be disabled by a
register. Usually, the input pin has a pull-up and connected to a GPIO
which can then be used to disable the mode. Try to get the GPIO and
deassert it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/micrel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index b981c5eaac33..685a0ab5453c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -32,6 +32,7 @@
 #include <linux/ptp_clock.h>
 #include <linux/ptp_classify.h>
 #include <linux/net_tstamp.h>
+#include <linux/gpio/consumer.h>
 
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -2837,6 +2838,21 @@ static int lan8814_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_release_coma_mode(struct phy_device *phydev)
+{
+	struct gpio_desc *gpiod;
+
+	gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
+					GPIOD_OUT_HIGH_OPEN_DRAIN);
+	if (IS_ERR(gpiod))
+		return PTR_ERR(gpiod);
+
+	gpiod_set_consumer_name(gpiod, "LAN8814 coma mode");
+	gpiod_set_value_cansleep(gpiod, 0);
+
+	return 0;
+}
+
 static int lan8814_probe(struct phy_device *phydev)
 {
 	struct kszphy_priv *priv;
@@ -2859,6 +2875,10 @@ static int lan8814_probe(struct phy_device *phydev)
 			      addr, sizeof(struct lan8814_shared_priv));
 
 	if (phy_package_init_once(phydev)) {
+		err = lan8814_release_coma_mode(phydev);
+		if (err)
+			return err;
+
 		err = lan8814_ptp_probe_once(phydev);
 		if (err)
 			return err;
-- 
2.30.2

