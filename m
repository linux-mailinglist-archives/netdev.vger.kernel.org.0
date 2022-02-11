Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CC54B1D9B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 06:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiBKFOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 00:14:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiBKFOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 00:14:30 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A854E1020
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:14:30 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id q145-20020a4a3397000000b002e85c7234b1so9075352ooq.8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jdeN7FneY6jsxS7OfSlq+iUVcVF330WKNmi4ZolLuiw=;
        b=DBuz3IDAY2SRgjO0MzYpeUr+bdD/262J84mQdg/shEzMV2EVvHtmJVakqo2XP2eOHU
         DuurgYj4xTsdJKuXYgjf0LFDa2082We0lmhtLxmMtJQTBxO1EDOkt0vPv2nL9OJLyR58
         939OKy/FhSkmqacTRtlZZSLHkW1pw5KKUn2Tn7unROVsQqGdJIVIeJVjXbGlK/OtJF3Z
         N4fX3k8G8moWxTono25IB6+9M48styHqeeJiIKc+9/4TLU0vOtAa16mxLhOdPzPDs1Zm
         qanDoZ+XJLsRaLg8mC7FDFdDnSOHwOPGeTG8FbQIsf8ABHC3nu3U+9h2TinHq8PuYN9Z
         CA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jdeN7FneY6jsxS7OfSlq+iUVcVF330WKNmi4ZolLuiw=;
        b=Z1Vm0/r0NGDDGNb85ouIbMjPleo8A/p3aJ3aaMtyb6uh7HQUUY13OTfalCxRS9K3qe
         T5nK/3w7ysLm/SyAvi8/zJNdsnZRAMJ0/H3awz+crnF0qexbRQtXzgmW7tpbVoU5Cmmi
         N0aP5eeAYXxKL3yABHbrKP54hQmlA6YxXVk4fAvGp1aeSlCDhbaw6b+iwUcU1Wd91zXM
         c23LD0RathyW7sGSu3DgygVKav/Qdl5IZMBDcL6Qljh2AyXhNO27AUYbZEbn7MI6YNHN
         Ot6Oo8UmpmEqyKb2q1YrNdC+9753IkwXpFvbF5zXu0k/HZwiG3Kdc9LFlHWudus3xpHG
         QSCQ==
X-Gm-Message-State: AOAM531/RO9sPVHfb+epixffDXUv6XAvae9LrXxl0PBY23lMzhmJIZ2V
        pHI9q6Ws5THpYUA9o9JxdbwlZcIefBThmg==
X-Google-Smtp-Source: ABdhPJxtfc8g4LApsAQ0iR8ZgY6t8fy/adakD/Ykc4opc3ht7Oty5Iz6DOVGiCyCPb0uuc6NAETiRA==
X-Received: by 2002:a4a:d622:: with SMTP id n2mr12997oon.19.1644556469685;
        Thu, 10 Feb 2022 21:14:29 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id k3sm8866745otl.41.2022.02.10.21.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 21:14:29 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before setup
Date:   Fri, 11 Feb 2022 02:14:04 -0300
Message-Id: <20220211051403.3952-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices, like the switch in Banana Pi BPI R64 only starts to answer
after a HW reset. It is the same reset code from realtek-smi.

Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 19 +++++++++++++++++++
 drivers/net/dsa/realtek/realtek-smi.c  |  6 ++----
 drivers/net/dsa/realtek/realtek.h      |  9 ++++++---
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index e6e3c1769166..78b419a6cb01 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -152,6 +152,21 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	/* TODO: if power is software controlled, set up any regulators here */
 	priv->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
 
+	/* Assert then deassert RESET */
+	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->reset)) {
+		dev_err(dev, "failed to get RESET GPIO\n");
+		return PTR_ERR(priv->reset);
+	}
+
+	if (priv->reset) {
+		dev_info(dev, "asserted RESET\n");
+		msleep(REALTEK_HW_STOP_DELAY);
+		gpiod_set_value(priv->reset, 0);
+		msleep(REALTEK_HW_START_DELAY);
+		dev_info(dev, "deasserted RESET\n");
+	}
+
 	ret = priv->ops->detect(priv);
 	if (ret) {
 		dev_err(dev, "unable to detect switch\n");
@@ -183,6 +198,10 @@ static void realtek_mdio_remove(struct mdio_device *mdiodev)
 	if (!priv)
 		return;
 
+	/* leave the device reset asserted */
+	if (priv->reset)
+		gpiod_set_value(priv->reset, 1);
+
 	dsa_unregister_switch(priv->ds);
 
 	dev_set_drvdata(&mdiodev->dev, NULL);
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index a849b5cbb4e4..cada5386f6a2 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -43,8 +43,6 @@
 #include "realtek.h"
 
 #define REALTEK_SMI_ACK_RETRY_COUNT		5
-#define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
-#define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
 
 static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
 {
@@ -426,9 +424,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 		dev_err(dev, "failed to get RESET GPIO\n");
 		return PTR_ERR(priv->reset);
 	}
-	msleep(REALTEK_SMI_HW_STOP_DELAY);
+	msleep(REALTEK_HW_STOP_DELAY);
 	gpiod_set_value(priv->reset, 0);
-	msleep(REALTEK_SMI_HW_START_DELAY);
+	msleep(REALTEK_HW_START_DELAY);
 	dev_info(dev, "deasserted RESET\n");
 
 	/* Fetch MDIO pins */
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index ed5abf6cb3d6..e7d3e1bcf8b8 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -5,14 +5,17 @@
  * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt.org>
  */
 
-#ifndef _REALTEK_SMI_H
-#define _REALTEK_SMI_H
+#ifndef _REALTEK_H
+#define _REALTEK_H
 
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/gpio/consumer.h>
 #include <net/dsa.h>
 
+#define REALTEK_HW_STOP_DELAY		25	/* msecs */
+#define REALTEK_HW_START_DELAY		100	/* msecs */
+
 struct realtek_ops;
 struct dentry;
 struct inode;
@@ -142,4 +145,4 @@ void rtl8366_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 extern const struct realtek_variant rtl8366rb_variant;
 extern const struct realtek_variant rtl8365mb_variant;
 
-#endif /*  _REALTEK_SMI_H */
+#endif /*  _REALTEK_H */
-- 
2.35.1

