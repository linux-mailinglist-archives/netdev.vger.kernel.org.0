Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB54B32A9
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiBLC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:27:52 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLC1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:27:51 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A736F26F2
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:27:46 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id s24so11619130oic.6
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E42dHnupf/sbQ8C/bOxX5grrRzcddwq6TiBQLT9LeUI=;
        b=iLregDviV9sq7zD9eNHwQB9+qg9GxOVnNn+RpNQQDhLSorP/C1H2sQzgIiFoGxFBdq
         OMuXviv2pRYDo2Syr5J6vZbZy0+4kxY8KB8kgvFjp76PtYmGVopcvJSapHNTlPlLzwlp
         VNGifXH9TJd6VUGyJVV9BaEWTRQTuwL6na4qaNHUlhoJ/pXisRZuosqKUn8cxtowYGMS
         h2epOiIu+rw2n/bFXZmI6AY59fhWsPDkcu208pkHy3A7/MZLKXnRoq2SzR7ACOTvqIkq
         Cx9zWvCsGcq/a4+mwSKX7bMQFf8KSX/PpLZsONOdAp8IyPOOXBMioBv416qxeJJZma87
         TqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E42dHnupf/sbQ8C/bOxX5grrRzcddwq6TiBQLT9LeUI=;
        b=Bommpf96WOMj0fRGtcr5ZMlSKS+SI1eCpaVblrVtls4WkzyJgh4muE9p65W3x5GS1U
         Ywu57RqZaJqOb4okKQ40Rztmj36MoIzVJE4M4mHztFUE7PKVUimWHyZwjPiaj2MbSM62
         FczeX6n9PWwD7IuCMer9xyaZlbL8CtfWYuy0QXMoHZHab/b1PTjOCOvLdGf/7It9HeVS
         66eLsRAN7aFuQGosDefdsFMN4qRZINNYZFgjbvcfdvxjqY+Z2IALpjxDHdewFnj4262d
         s7bpVzam/wnYctxRzDy4FxaW3lPCXoUnKbHQOeCoXU/rxq2bI5xMzndY0F9Wg+6PJmaG
         NrOA==
X-Gm-Message-State: AOAM532CatSr8UEUP/pFF3VM1GbvPXsEmrpjZoOOrGRfF+9aIfICiiFX
        fV6k867Ux9/EgzFBgmArReyIrbP/SOpmjQ==
X-Google-Smtp-Source: ABdhPJzWg+CfIwJOL4UQ7Zh7sFplpPQ64AzZJ75UwhHUaXmLBea+nklS32hcpSkI+18Q7rKMrmQmmA==
X-Received: by 2002:a05:6808:1822:: with SMTP id bh34mr1602121oib.284.1644632865801;
        Fri, 11 Feb 2022 18:27:45 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id x31sm4711993otb.55.2022.02.11.18.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 18:27:45 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset before setup
Date:   Fri, 11 Feb 2022 23:27:35 -0300
Message-Id: <20220212022735.18085-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

In realtek-smi, only assert the reset when the gpio is defined.

Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 19 +++++++++++++++++++
 drivers/net/dsa/realtek/realtek-smi.c  | 17 ++++++++++-------
 drivers/net/dsa/realtek/realtek.h      |  3 +++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 0c5f2bdced9d..fa2339763c71 100644
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
+		dev_dbg(dev, "asserted RESET\n");
+		msleep(REALTEK_HW_STOP_DELAY);
+		gpiod_set_value(priv->reset, 0);
+		msleep(REALTEK_HW_START_DELAY);
+		dev_dbg(dev, "deasserted RESET\n");
+	}
+
 	ret = priv->ops->detect(priv);
 	if (ret) {
 		dev_err(dev, "unable to detect switch\n");
@@ -185,6 +200,10 @@ static void realtek_mdio_remove(struct mdio_device *mdiodev)
 
 	dsa_unregister_switch(priv->ds);
 
+	/* leave the device reset asserted */
+	if (priv->reset)
+		gpiod_set_value(priv->reset, 1);
+
 	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 946fbbd70153..a13ef07080a2 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -43,8 +43,6 @@
 #include "realtek.h"
 
 #define REALTEK_SMI_ACK_RETRY_COUNT		5
-#define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
-#define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
 
 static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
 {
@@ -426,10 +424,13 @@ static int realtek_smi_probe(struct platform_device *pdev)
 		dev_err(dev, "failed to get RESET GPIO\n");
 		return PTR_ERR(priv->reset);
 	}
-	msleep(REALTEK_SMI_HW_STOP_DELAY);
-	gpiod_set_value(priv->reset, 0);
-	msleep(REALTEK_SMI_HW_START_DELAY);
-	dev_info(dev, "deasserted RESET\n");
+	if (priv->reset) {
+		dev_dbg(dev, "asserted RESET\n");
+		msleep(REALTEK_HW_STOP_DELAY);
+		gpiod_set_value(priv->reset, 0);
+		msleep(REALTEK_HW_START_DELAY);
+		dev_dbg(dev, "deasserted RESET\n");
+	}
 
 	/* Fetch MDIO pins */
 	priv->mdc = devm_gpiod_get_optional(dev, "mdc", GPIOD_OUT_LOW);
@@ -474,7 +475,9 @@ static int realtek_smi_remove(struct platform_device *pdev)
 	dsa_unregister_switch(priv->ds);
 	if (priv->slave_mii_bus)
 		of_node_put(priv->slave_mii_bus->dev.of_node);
-	gpiod_set_value(priv->reset, 1);
+
+	if (priv->reset)
+		gpiod_set_value(priv->reset, 1);
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 3512b832b148..e7d3e1bcf8b8 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -13,6 +13,9 @@
 #include <linux/gpio/consumer.h>
 #include <net/dsa.h>
 
+#define REALTEK_HW_STOP_DELAY		25	/* msecs */
+#define REALTEK_HW_START_DELAY		100	/* msecs */
+
 struct realtek_ops;
 struct dentry;
 struct inode;
-- 
2.35.1

