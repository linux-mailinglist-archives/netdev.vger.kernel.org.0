Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECF46B5EF1
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCKRdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCKRdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:32 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE103BD8E
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:21 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r15so5841936edq.11
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678556001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pg+GPO/7EayVuamadIf0ZkJzvPVNrr6nqvGyotFYqJw=;
        b=QLGcp//9YW3Bk8OUHxNwnEQxTEzlQHE3td9NgmKco5B/m0ltJ6JzKJYZqWFEk5OOhc
         TgN4yl6NXi+7UGadNTCwZcT5F1eOPX0u8EIGOmUuEqvqo3VNBwildAwAelu/c0zPv5jG
         tL8qALW1Kh0MAkcwxjOHBT7E55h70Ih6OryxXmM5b1f3hhTQcRI0IrmlN7dMF5dxf6GN
         24Rb0XmN6gxmEL2IaU/js2VrPSqXuqW18jLAZyEyGKdYqh/1JbUO4RMfaXMwikc1Bzhk
         AKgT/otoVDliGNadUn19zF00k5h7aJz7/J1qppKBAJvWn6cDLhfkFloaOdMPS3dSJVgP
         /rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678556001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pg+GPO/7EayVuamadIf0ZkJzvPVNrr6nqvGyotFYqJw=;
        b=bJYTBQXYhurWnHYSLpG0AQ1xGTzLUhy9+QJkeoNn1+7WXxigMtPVJUjz+h672LEYD/
         UiB7kuCwdsQwAv94XWO/C74GtBNyLg4M78NUgmV1yNWvBWgomKvKy2QjFCglOtYpLhTM
         SZqF/JMX8zCMCMAsl6g5ZzLty22p3wlISbJ8yuZuAbgbfJhidl1IvUvHWTPVUNnuOeeW
         3kH+7B/1x+I7d0WqQAqA5VvsHboyxT2zgrUG+JOCmniJKibaH+ohVGW68gqydL+NiFXG
         mBpvcoKLmubQQXvEz9zEuY+acTVuU/c0SOtSGcb7xk/ZdLz96ZIdk8aJ+tL0Kcsg30Yb
         qpcw==
X-Gm-Message-State: AO0yUKV41TmUnNIs45TgF/00U+ypeEQ/3pSy/MacuqumFx4G8WcuFaEt
        xb6t1MVbSmpTg0npKVZ9mU7sNQ==
X-Google-Smtp-Source: AK7set91MVUsjkv0zNuDpkPHsBeGlGpHc2kPO4ylGklObjaz1d2qRxZ19w35NHimRz43HhRIx3AhHQ==
X-Received: by 2002:aa7:d04e:0:b0:4fa:ee01:a0cb with SMTP id n14-20020aa7d04e000000b004faee01a0cbmr1425114edo.32.1678556001033;
        Sat, 11 Mar 2023 09:33:21 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:20 -0800 (PST)
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
Subject: [PATCH 07/12] net: ieee802154: adf7242: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:32:58 +0100
Message-Id: <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will match mostly by DT table (even thought there is regular
ID table) so there is little benefit in of_match_ptr (this also allows
ACPI matching via PRP0001, even though it might not be relevant here).

  drivers/net/ieee802154/adf7242.c:1322:34: error: ‘adf7242_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ieee802154/adf7242.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 5cf218c674a5..509acc86001c 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1336,7 +1336,7 @@ MODULE_DEVICE_TABLE(spi, adf7242_device_id);
 static struct spi_driver adf7242_driver = {
 	.id_table = adf7242_device_id,
 	.driver = {
-		   .of_match_table = of_match_ptr(adf7242_of_match),
+		   .of_match_table = adf7242_of_match,
 		   .name = "adf7242",
 		   .owner = THIS_MODULE,
 		   },
-- 
2.34.1

