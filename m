Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD654698C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbiFJPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345353AbiFJPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD5029380C
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bg6so34407869ejb.0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TXmIOiKtTji5uvqDZkSqwPGXddUogZT+Gvmhu7MqhdQ=;
        b=JXsDC6jUtUYbphZF98hJGA789y+6YpRm9frF/gsABOBXH8s40fei6Bh/9Gdg1Iq4Fb
         fCDvsyeQ/6H7VGFndaI4QuK0biv88R2t+b3tLQ4dC3zEAQ1tftpd8+b3Rf3mDHDQF8YL
         erVfMsR9iWft+MuVvQU0ICkcfMKaWOL1kogBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXmIOiKtTji5uvqDZkSqwPGXddUogZT+Gvmhu7MqhdQ=;
        b=lwDe30vRX68WwHUgYRvQ5WzjcZs9nCpjOSVWs+hpxMYRegeXg8/KmjVXf+zHVCW+I6
         krrXyX9W2PCQfaCqoot6mxyvSkcPrt8icG60fO1yfiVuM4zx8g8KI7PCo0hWpFY86dwt
         uIKeQSqXAGDyv5YjXgqkza1VbwsaZvEPDETF9G4NH+ZHv2UQlrDZtRD+dH3+B1yIJkIs
         3ZHKMjw0QfQIwTBNs7Hg7QGo7gHJdgb+147pgjgEf9N8g/uI/mtJl98T0vjLjrI8gEBH
         I37sGBivKXRTLUdzVk9X20/3yJG/SK3ZUNLS902GeOw8cmKiIQ4gAOi9/rn0wrs0C8oe
         XD+g==
X-Gm-Message-State: AOAM530/IWA07T1vsPwi87127Zfj8bA1o86D78yzvWtdyC8Qlcwo0MxU
        ozLKOQcqI2SyDlEtH2WUlFxCuw==
X-Google-Smtp-Source: ABdhPJzKDXSDcDmYJ+pwwoQ2nlnDeLS7uzfHEb1EGwtD5LpD9/Zwa39jmqOYLrKxfF1HpTV9lbcHSA==
X-Received: by 2002:a17:907:868f:b0:702:f865:55de with SMTP id qa15-20020a170907868f00b00702f86555demr41395122ejc.24.1654875556764;
        Fri, 10 Jun 2022 08:39:16 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h24-20020a170906829800b0070f7d1c5a18sm9783857ejx.55.2022.06.10.08.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:39:16 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: dsa: realtek: rtl8365mb: correct the max number of ports
Date:   Fri, 10 Jun 2022 17:38:27 +0200
Message-Id: <20220610153829.446516-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610153829.446516-1-alvin@pqrs.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The maximum number of ports is actually 11, according to two
observations:

1. The highest port ID used in the vendor driver is 10. Since port IDs
   are indexed from 0, and since DSA follows the same numbering system,
   this means up to 11 ports are to be presumed.

2. The registers with port mask fields always amount to a maximum port
   mask of 0x7FF, corresponding to a maximum 11 ports.

In view of this, I also deleted the comment.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 42afba122bb4..3599fa5d9f14 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -115,8 +115,7 @@
 #define RTL8365MB_PHYADDRMAX		7
 #define RTL8365MB_NUM_PHYREGS		32
 #define RTL8365MB_PHYREGMAX		(RTL8365MB_NUM_PHYREGS - 1)
-/* RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports */
-#define RTL8365MB_MAX_NUM_PORTS		10
+#define RTL8365MB_MAX_NUM_PORTS		11
 #define RTL8365MB_LEARN_LIMIT_MAX	2112
 
 /* valid for all 6-port or less variants */
-- 
2.36.1

