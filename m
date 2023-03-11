Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4F6B5EFC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCKReY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCKRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:41 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D823341B47
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:23 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x3so32951342edb.10
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678556003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPTGdDBL8b40RCmwJ/SrwI24KRXn2ceVZMzb8HuniE8=;
        b=RMJAnx3hUX085h7uK4IIPYlR6BkBWKb5DISi3/TVx4WOj/hDyJWkXczuc21LYAj0bi
         JFsb8UepMLGx27vo9e0YBpvvBVNLE7TOTPUeD+QnrUhpEc4E9YNnxBxfUnxS8L+6zYee
         /1ZtE4e0/oDtGyVdDMZRk6nhskr6FtM64OeH08pmk7ebmJFsWegZOBmtoEmFmhD5MCyW
         07DkfNibueSpCDZXxY2zE/1f0qn42HXUETAdmSiF6YY/aFy+FXCS5jQWLdEerElZf/MH
         KrfpfAWWtlmEXKFk8G+lGrsf/m6qj4IFk2p5/pZPJX9PcOflu0mYW/Q39HydYMdnWy4Y
         SGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678556003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPTGdDBL8b40RCmwJ/SrwI24KRXn2ceVZMzb8HuniE8=;
        b=B6YOrzSJcC9CwEEtlOupFYSf20zpVTxWWS2TFgfWSlPrmg/JmiE/lt/Xr+vAVZTSW+
         05+I5l45E967T5kymxRAai2qsZ439m3u2oDT/K01WH0yJ4goI61fcAa35CnEtl9PU1fE
         z58wIIOPHtPOmszZ4PlPD4o+uNQpU+b+R1SjfiZZPfDpzdN9UKhRkhCcWXA1qwnzcwWt
         CPj3FpUjvXHCdmmOXQ8DPg5m8uSuSo88rLbyR3hT7p2lA7rjSmE1rqr404WYGRcjC3G9
         FQ1YLHVNEQ8CzqbQEjVk5e18q1Xo6I90pWba4qLFbUlaGNfwyXQamONBz0SdhZQceFfj
         qr7g==
X-Gm-Message-State: AO0yUKVM04XJEAQKmCOHX8ixkqAyfLpfvvL6FQj2+RSbP2oxEAJUr4Se
        +lBwrzlTWaxBMNx2r49vUvPFKw==
X-Google-Smtp-Source: AK7set8LcQuAvpdmH4YyQTjnOklUnNTtB1MERqqJcYlJGMRUuqDen6lOHZY7vAex7tGlhIdRelAcYw==
X-Received: by 2002:a05:6402:70f:b0:4af:7390:b488 with SMTP id w15-20020a056402070f00b004af7390b488mr27475483edx.40.1678556003405;
        Sat, 11 Mar 2023 09:33:23 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:23 -0800 (PST)
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
Subject: [PATCH 09/12] net: ieee802154: at86rf230: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:33:00 +0100
Message-Id: <20230311173303.262618-9-krzysztof.kozlowski@linaro.org>
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

  drivers/net/ieee802154/at86rf230.c:1644:34: error: ‘at86rf230_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ieee802154/at86rf230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 62b984f84d9f..164c7f605af5 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1662,7 +1662,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
 static struct spi_driver at86rf230_driver = {
 	.id_table = at86rf230_device_id,
 	.driver = {
-		.of_match_table = of_match_ptr(at86rf230_of_match),
+		.of_match_table = at86rf230_of_match,
 		.name	= "at86rf230",
 	},
 	.probe      = at86rf230_probe,
-- 
2.34.1

