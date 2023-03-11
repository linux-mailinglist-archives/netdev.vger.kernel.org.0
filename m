Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409F06B5EF6
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCKReG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCKRdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2133B65C
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:21 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id er25so4894192edb.5
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678555999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXAmespG0M4hSiMCAu+5SVl3Gjs1X4fJ7l5m653N/T0=;
        b=h61OLmcgQZ49pdiaT/hMry9cHAP5irMaU8H2HF8mKrR8UcaTmYxRuNVscBm/7KcSZu
         iP9KwtjEe/2vbYH65cQWESLAptBhLAUdvgrrnES77GxdAbGIl5U8Y42eB7/y5s0Y4hSW
         mvj2c5nj9V8PzeMXsaLMCCoHABuAcjtkN819POzZEPr+rR7S8TsvpLjpWnMrFDmyd+07
         zlHWo/ouD5nf+6zfOSrQZ/GtUKPYMy0P/kUdaSLuRSQ//1hJXQ5IB9UXMKMX7HkTlnPd
         f99sqAPHOzCY4JSVlYAuscS6WSHfBCE4nLApyI6xWtqW7DobA7r9aMRVSOmlM102ttVK
         NBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678556000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aXAmespG0M4hSiMCAu+5SVl3Gjs1X4fJ7l5m653N/T0=;
        b=ooklUZBUBVzWAaKU0otwCgOr/uF/3wxRUlNWkWXg4uFD2v38t/bDbIBUHpH5CqRK3g
         NDUvEe2IQiYqCbI2PzbTFoNuM9cdErHD13CiukhcszkoF09peSg4HPKA1OUZBcnx+5gp
         C1k+ajzj+/16qe80IiU/qNm/dH926vDc+GRJseSVYraOHBSNEQCx6LcnkJ8j6NxleQKg
         paGOCyl5C5uOojzVwFwf2ek/pAyWdov6qeZQpfGAh3IQW7/ljXJdNeRlAZv63L+mUVs1
         3MWOZoYx7rqJlH2ZTu2rwDXchfz+1eSrBlU6OmP/zjmnSUFMSQxvu/vYurvsnA+whv75
         Njpw==
X-Gm-Message-State: AO0yUKU5IhF02tzXXhVhDFF/iRSMWQTxU3Eg4F4K/rIAvKUxureCaeL0
        uIchNPC3sFVsc2ZD2DFxdKDOvg==
X-Google-Smtp-Source: AK7set/kpZ2vdN8HmJ3eoEZdciC1xrNdRT0XaUll+kYhR/pDJF4w7J+TuEaXTUmUIJfY2jOSfMh2Gg==
X-Received: by 2002:a05:6402:542:b0:4af:8436:2f5d with SMTP id i2-20020a056402054200b004af84362f5dmr25453512edx.40.1678555999770;
        Sat, 11 Mar 2023 09:33:19 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:19 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 06/12] net: phy: ks8995: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:32:57 +0100
Message-Id: <20230311173303.262618-6-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will match mostly by DT table (even thought there is regular
ID table) so there is little benefit in of_match_ptr (this also allows
ACPI matching via PRP0001, even though it might not be relevant here).

  drivers/net/phy/spi_ks8995.c:156:34: error: ‘ks8895_spi_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/phy/spi_ks8995.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index d4202d40d47a..7196e927c2cd 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -491,7 +491,7 @@ static void ks8995_remove(struct spi_device *spi)
 static struct spi_driver ks8995_driver = {
 	.driver = {
 		.name	    = "spi-ks8995",
-		.of_match_table = of_match_ptr(ks8895_spi_of_match),
+		.of_match_table = ks8895_spi_of_match,
 	},
 	.probe	  = ks8995_probe,
 	.remove	  = ks8995_remove,
-- 
2.34.1

