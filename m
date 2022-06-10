Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC46546985
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345437AbiFJPjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiFJPjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA2628D6BC
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:14 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u12so54230812eja.8
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zSzdOiSgxbYWZxXEulfQBrTFa8jqymfNEasGrW3oI+Y=;
        b=BPEmtox0n4YIgD5pdsnW8UPNk7FQIIjlxClCKmWF/iwqmna5QAKAU4Ay2sZXrFrSGb
         qLvBN+iGNL5enuUhzJcIuk4RzV9IqYQls3SMwywGk2rulm6zHenPdmhcBR5M1y6zTWOD
         m3UHA75ASQNhLjzsq+FXBl7NeMm/LMFSVda2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zSzdOiSgxbYWZxXEulfQBrTFa8jqymfNEasGrW3oI+Y=;
        b=OsRvTHj49H4Dv1gp82rAkmFlw90WdgXEpZQRagto8JVOVny4/sZsEZlQXoFiyjgGkC
         L4WRAtrGUXtJWHGzWPJ5clpWOvxs+OQtnc02x92Zwvb90+VNOCvBGcqUuo8+xswUky6O
         jtQpzAqThmMjGZ7xv1BGZ038ovxRxHlmaLmqkCUnT1KQYkLZ2kXa0Wk/hV5A4PlHCBLl
         UAxgvUe2N59KTx8nbcuQZ2DoDiFwtgahoZHigrxfnpRDJgAIBygwFngt22TYhN/6uUVZ
         iya7l8XL5VC6ZBFEvC3ODoNdcO4FIFVzkzeaj8lCGbHixjclSt7AlEbg0R0XDV0u7Xbf
         iYiQ==
X-Gm-Message-State: AOAM533VYdVNumpZA+AqwJxFrKW0fvuLWuSRTET/RX7Vw4a44lasARif
        zxwcutlrdTx1jg5daI/XlbNqFA==
X-Google-Smtp-Source: ABdhPJwLkPofOgkmwwTW5y657ZZueqYXAm92lnRmx/cPA3J9dB09qvdmngmA6YNBDpyc8LlgoYVDKA==
X-Received: by 2002:a17:907:7b9b:b0:711:d8ca:c282 with SMTP id ne27-20020a1709077b9b00b00711d8cac282mr21076740ejc.167.1654875553534;
        Fri, 10 Jun 2022 08:39:13 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h24-20020a170906829800b0070f7d1c5a18sm9783857ejx.55.2022.06.10.08.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:39:13 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/5] net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
Date:   Fri, 10 Jun 2022 17:38:25 +0200
Message-Id: <20220610153829.446516-2-alvin@pqrs.dk>
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

The official name of this switch is RTL8367RB-VB, not RTL8367RB. There
is also an RTL8367RB-VC which is rather different. Change the name of
the CHIP_ID/_VER macros for reasons of consistency.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 769f672e9128..905056250b88 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -108,8 +108,8 @@
 #define RTL8365MB_CHIP_ID_8367S		0x6367
 #define RTL8365MB_CHIP_VER_8367S	0x00A0
 
-#define RTL8365MB_CHIP_ID_8367RB	0x6367
-#define RTL8365MB_CHIP_VER_8367RB	0x0020
+#define RTL8365MB_CHIP_ID_8367RB_VB	0x6367
+#define RTL8365MB_CHIP_VER_8367RB_VB	0x0020
 
 /* Family-specific data and limits */
 #define RTL8365MB_PHYADDRMAX		7
@@ -1988,7 +1988,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 				 chip_ver);
 			break;
-		case RTL8365MB_CHIP_VER_8367RB:
+		case RTL8365MB_CHIP_VER_8367RB_VB:
 			dev_info(priv->dev,
 				 "found an RTL8367RB-VB switch (ver=0x%04x)\n",
 				 chip_ver);
-- 
2.36.1

