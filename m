Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6316B5EFE
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCKRe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCKReG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:34:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847DB301BE
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id ek18so1900113edb.6
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678556004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jJaYEyuuO5/7ZmBgza2JAkACKERJJ9QG1PA2csTvP0=;
        b=nHDAc+H0npIh3vNJGeXviuEBpr+1PK07dBrn05EJBUvz2aFDMgJvOjGJhwJ9LGamHz
         JPRD0Qb8tsb1S9PolfMXoljCE/2hA+C7FdiAGb7bOL6xQLuew8ApejQSHL7of3r2k3uD
         qK5TwReucG8XzqIaJZuWdsTWvtouWPD0GzHEOy8wh2MPUi05s+6ACQxR2ezI1T9bsZKO
         LIcnlvavkjOzOPsKSD5UU5of0tR7Jf0OFrPz6EWp3ZYdyW2KyiOPQFGgyzIr+1hI6mo4
         oVrQ/oE8Gc1Lp8IqRnERs2I/0QdhayI9u0T/gXiWG3FOOQB24F32ZuC5aTdKuVBuX2td
         iM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678556004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7jJaYEyuuO5/7ZmBgza2JAkACKERJJ9QG1PA2csTvP0=;
        b=bAaWedSb/MTNwsb/24XPHKGC1lG0WAo9cYVBqPWwrzjeYkehvPH+f3eEeuDVzR6nEz
         iRE8EuV9MJMo3u8/+u4Br1S663XAwDslOg2LSbTSqR4L9zV9PvaBU13GffXorKYLHoD5
         PIxTDxlSEKx+fELS4HDwizpv1AFsSRCP/cjOkP2xh814dYr2tzviRoehxcM0D5ijuoO9
         GsfSSDB6O9D/bEljEaAw3mtVQ2BSHYODBspNGqXQFZiCgqvoFc/17VXcRBm5osJEbpOp
         bgfaGACjHnsrDacJLkZVxCJ92Yf4wECLdm+FkR3E7vbES1vTk0wl8KI+sapsQlYVLbL5
         09lA==
X-Gm-Message-State: AO0yUKUs2K3HLDzehj2NxXWKvdXGS1KVHYmVF6TwcM0KGz2o61FxxXiW
        BmXuZhjod6rEs91metziltbXdg==
X-Google-Smtp-Source: AK7set9vWz++lxxJIbYAQ4X5NHrLZPNd1F+ADuCr+5KXfAjrxgYiw7uxgr7b8z1+/jim/f76Mp3bQQ==
X-Received: by 2002:a17:907:6e25:b0:878:54e3:e3e1 with SMTP id sd37-20020a1709076e2500b0087854e3e3e1mr35447489ejc.73.1678556004615;
        Sat, 11 Mar 2023 09:33:24 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:24 -0800 (PST)
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
Subject: [PATCH 10/12] net: ieee802154: ca8210: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:33:01 +0100
Message-Id: <20230311173303.262618-10-krzysztof.kozlowski@linaro.org>
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

  drivers/net/ieee802154/ca8210.c:3174:34: error: ‘ca8210_of_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index ed6cb79072a8..65d28e8a87c9 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3181,7 +3181,7 @@ static struct spi_driver ca8210_spi_driver = {
 	.driver = {
 		.name =                 DRIVER_NAME,
 		.owner =                THIS_MODULE,
-		.of_match_table =       of_match_ptr(ca8210_of_ids),
+		.of_match_table =       ca8210_of_ids,
 	},
 	.probe  =                       ca8210_probe,
 	.remove =                       ca8210_remove
-- 
2.34.1

