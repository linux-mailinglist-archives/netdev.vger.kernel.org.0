Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDB76B5EEA
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCKRdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCKRd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:28 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632D822A20
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:16 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id k10so32932890edk.13
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678555995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwB85vi35W6JFbse/kCjhcZA/CxkEkODSyImYFi2+wU=;
        b=QJZVFReUg7zrO73MLdqYRzpuYC4bl7zsy2iMOSOtYl5oRvPLj6V3IScX9xNhvF3qcU
         lCQWEwdKfwmn1uhILsR4p5KVY41WXU6cZEZKEEewyFaYIR1OBjZzO7aWMLlmncsslmpl
         tCnusxbxupvB3BaBOcuFcfDAgwNkUH4cBKSTTvQQACSpC1wsGpxovbasVJrdapSd32dD
         guQxFSDTrHL6fil3naWSY7Yq5/1I7wZW2zYEdTnpNlZVCpDo5OOFuyqGmx/v8EYqd92X
         kEASnGkR6jqA1AkQ/JckSaVIqpxgLEG4nTwS4WvxJO0/434fH6RdA5BN8E1XHEO9OtSh
         OKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwB85vi35W6JFbse/kCjhcZA/CxkEkODSyImYFi2+wU=;
        b=AfwPkDW3sibPIiWEL3wAtr8VvWyyYcrVIQN+EycZ8Ag+lbLO1Wu4JsN/QFFyxF/phD
         Gid84BfhwD3D5tZMTpPoARmyrcVbgLTE75sr4Z9B0GR25iZLTwAF1Y2niUb5yRhE99fp
         Ad7ennw/99ss/vECymRKIO+gZ2y6K8sUnze4+1ErsL1dfse4YYlTvUcCGyyl2xYKkBPh
         octno5YlDmpaP1wBzDxTAUhUm95g5yhmu3lHqjL/tZ4+8P0oNwv9KO047rLOLpaoiX97
         3zTZ/d7t/c7hjD0UAfaIxLy+QCws5nM0nnHP2DlvprEoJJacnF9c69yq4mW7DZ2hLYCh
         Yu/Q==
X-Gm-Message-State: AO0yUKWEhRO94eJ76NeW2yG4/9JZxv0ofik/KQemI4YSi/Hn1Vcjt9kC
        z0hh8sqTScbvD8gIgpJxO8dE8Q==
X-Google-Smtp-Source: AK7set/dVlRnxLDT9ouunZ6UH9aeWxbXkHckg/IVN8HpBpPg2BP11f0i8gnuweQAwRI6Tc4MtCyTfA==
X-Received: by 2002:a17:906:c79a:b0:924:9f65:8866 with SMTP id cw26-20020a170906c79a00b009249f658866mr284358ejb.64.1678555994857;
        Sat, 11 Mar 2023 09:33:14 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:14 -0800 (PST)
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
Subject: [PATCH 03/12] net: dsa: seville_vsc9953: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:32:54 +0100
Message-Id: <20230311173303.262618-3-krzysztof.kozlowski@linaro.org>
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

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it might not be relevant here).

  drivers/net/dsa/ocelot/seville_vsc9953.c:1070:34: error: ‘seville_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 563ad338da25..96d4972a62f0 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1079,7 +1079,7 @@ static struct platform_driver seville_vsc9953_driver = {
 	.shutdown	= seville_shutdown,
 	.driver = {
 		.name		= "mscc_seville",
-		.of_match_table	= of_match_ptr(seville_of_match),
+		.of_match_table	= seville_of_match,
 	},
 };
 module_platform_driver(seville_vsc9953_driver);
-- 
2.34.1

