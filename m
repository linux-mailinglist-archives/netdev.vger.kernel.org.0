Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40C6B98AC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjCNPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjCNPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:12:24 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED8F64B04
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:23 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m2so1900339wrh.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678806741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSrec+nBwM+c2dQQeNVjKvZ5AfVGgxg/yYXQBrWPGyQ=;
        b=0PbFTDbB3iqQ+6B6JXcc9N2aOoYFez/WZp8jLJ+U14nAeRdstbXlrz5nCLrsmu+8vg
         zrZc9+pn9FlyY7AbhfO6DZ6ZAtMa2BBofJjYjfT3YAZOBfjaLLaSM3GJ82Pr5ypWNVa2
         kI+8U7OK7Et9uwE9s1EVsBIEPxuFbcPFhRnyDzXaDmrgTWTUmh7UjHFQz52GNzg04HYT
         MbwN/mByHaj0BkQK3LrzzXMTKzoDMJCH4fLt/x2TjJowl5N2M8JjUbGj0ZNHLPvGQQ3W
         kekv73o6UPUG78wFrDRTMQp5yMitEW0p+8uIsMjTwsdPcHPVDe8ldRNV8by6kxRcrdGR
         uY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSrec+nBwM+c2dQQeNVjKvZ5AfVGgxg/yYXQBrWPGyQ=;
        b=6RYBNOPnrvyDD5mXKOTrjXgsqWD4gUwL37uyYK0wL1uYmofaEgaO/zfEDVNIcBUzMV
         VLWVwJwMGh0EcVxxFeJV3CE4357gZ9TsnnZE796SbOLpwkrxQ7doQNg5ulm6mPDe7qo7
         I6BHsFZ5/Xe2yGRazEsPXYE2J8o7+7Bc10/Ii9U7rLMyjNQxIwxrZUTTpVInSnNOLzut
         ZiNT7Mu5js3hxZUfYZtoEnLvkVc5XXL4Ol2JgTtn0XKuzWuH/tGaJMSGoNArYBU4/dWm
         9gKHbLmTc5BrpHrKj90nYiNByRJTSzvjOaMBG8tTlfjwzMTrDU09huIcPKUaI2diOBnq
         7kCA==
X-Gm-Message-State: AO0yUKWIRdey2MEn1qUdEDf7F7V/iUz36zrKmCRLc9osjo7kTTpkAfxG
        xh9KiWhz6DLTUtOZRwuQMyjstA==
X-Google-Smtp-Source: AK7set8nWY958Ivm09aRAnCvmEiM0RkXJPN4MN+X/TFRi4qWMFOg1Wj9FrzzG9fsSrjBWEySGL132g==
X-Received: by 2002:a5d:6289:0:b0:2ce:a944:2c6a with SMTP id k9-20020a5d6289000000b002cea9442c6amr6058726wru.70.1678806741490;
        Tue, 14 Mar 2023 08:12:21 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id d9-20020a5d4f89000000b002c707b336c9sm2320158wru.36.2023.03.14.08.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:12:21 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 5/5] can: tcan4x5x: Add support for tcan4552/4553
Date:   Tue, 14 Mar 2023 16:12:01 +0100
Message-Id: <20230314151201.2317134-6-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314151201.2317134-1-msp@baylibre.com>
References: <20230314151201.2317134-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcan4552 and tcan4553 do not have wake or state pins, so they are
currently not compatible with the generic driver. The generic driver
uses tcan4x5x_disable_state() and tcan4x5x_disable_wake() if the gpios
are not defined. These functions use register bits that are not
available in tcan4552/4553.

This patch adds support by introducing version information to reflect if
the chip has wake and state pins. Also the version is now checked.

Signed-off-by: Markus Schneider-Pargmann
---
 drivers/net/can/m_can/tcan4x5x-core.c | 113 ++++++++++++++++++++------
 1 file changed, 89 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index fb9375fa20ec..e7fa509dacc9 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -7,6 +7,7 @@
 #define TCAN4X5X_EXT_CLK_DEF 40000000
 
 #define TCAN4X5X_DEV_ID1 0x00
+#define TCAN4X5X_DEV_ID1_TCAN 0x4e414354 /* ASCII TCAN */
 #define TCAN4X5X_DEV_ID2 0x04
 #define TCAN4X5X_REV 0x08
 #define TCAN4X5X_STATUS 0x0C
@@ -103,6 +104,13 @@
 #define TCAN4X5X_WD_3_S_TIMER BIT(29)
 #define TCAN4X5X_WD_6_S_TIMER (BIT(28) | BIT(29))
 
+struct tcan4x5x_version_info {
+	u32 id2_register;
+
+	bool has_wake_pin;
+	bool has_state_pin;
+};
+
 static inline struct tcan4x5x_priv *cdev_to_priv(struct m_can_classdev *cdev)
 {
 	return container_of(cdev, struct tcan4x5x_priv, cdev);
@@ -254,18 +262,53 @@ static int tcan4x5x_disable_state(struct m_can_classdev *cdev)
 				  TCAN4X5X_DISABLE_INH_MSK, 0x01);
 }
 
-static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
+static int tcan4x5x_verify_version(
+		struct tcan4x5x_priv *priv,
+		const struct tcan4x5x_version_info *version_info)
+{
+	u32 val;
+	int ret;
+
+	ret = regmap_read(priv->regmap, TCAN4X5X_DEV_ID1, &val);
+	if (ret)
+		return ret;
+
+	if (val != TCAN4X5X_DEV_ID1_TCAN) {
+		dev_err(&priv->spi->dev, "Not a tcan device %x\n", val);
+		return -ENODEV;
+	}
+
+	if (!version_info->id2_register)
+		return 0;
+
+	ret = regmap_read(priv->regmap, TCAN4X5X_DEV_ID2, &val);
+	if (ret)
+		return ret;
+
+	if (version_info->id2_register != val) {
+		dev_err(&priv->spi->dev, "Not the specified TCAN device, id2: %x != %x\n",
+			version_info->id2_register, val);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int tcan4x5x_get_gpios(struct m_can_classdev *cdev,
+			      const struct tcan4x5x_version_info *version_info)
 {
 	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 	int ret;
 
-	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
-						    GPIOD_OUT_HIGH);
-	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
-		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+	if (version_info->has_wake_pin) {
+		tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
+							    GPIOD_OUT_HIGH);
+		if (IS_ERR(tcan4x5x->device_wake_gpio)) {
+			if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
+				return -EPROBE_DEFER;
 
-		tcan4x5x_disable_wake(cdev);
+			tcan4x5x_disable_wake(cdev);
+		}
 	}
 
 	tcan4x5x->reset_gpio = devm_gpiod_get_optional(cdev->dev, "reset",
@@ -277,12 +320,14 @@ static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
-							      "device-state",
-							      GPIOD_IN);
-	if (IS_ERR(tcan4x5x->device_state_gpio)) {
-		tcan4x5x->device_state_gpio = NULL;
-		tcan4x5x_disable_state(cdev);
+	if (version_info->has_state_pin) {
+		tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
+								      "device-state",
+								      GPIOD_IN);
+		if (IS_ERR(tcan4x5x->device_state_gpio)) {
+			tcan4x5x->device_state_gpio = NULL;
+			tcan4x5x_disable_state(cdev);
+		}
 	}
 
 	return 0;
@@ -301,8 +346,13 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 {
 	struct tcan4x5x_priv *priv;
 	struct m_can_classdev *mcan_class;
+	const struct tcan4x5x_version_info *version_info;
 	int freq, ret;
 
+	version_info = of_device_get_match_data(&spi->dev);
+	if (!version_info)
+		version_info = (void *)spi_get_device_id(spi)->driver_data;
+
 	mcan_class = m_can_class_allocate_dev(&spi->dev,
 					      sizeof(struct tcan4x5x_priv));
 	if (!mcan_class)
@@ -361,7 +411,11 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_m_can_class_free_dev;
 
-	ret = tcan4x5x_get_gpios(mcan_class);
+	ret = tcan4x5x_verify_version(priv, version_info);
+	if (ret)
+		goto out_power;
+
+	ret = tcan4x5x_get_gpios(mcan_class, version_info);
 	if (ret)
 		goto out_power;
 
@@ -394,21 +448,32 @@ static void tcan4x5x_can_remove(struct spi_device *spi)
 	m_can_class_free_dev(priv->cdev.net);
 }
 
+static const struct tcan4x5x_version_info tcan4x5x_generic = {
+	.has_state_pin = true,
+	.has_wake_pin = true,
+};
+
+static const struct tcan4x5x_version_info tcan4x5x_tcan4552 = {
+	.id2_register = 0x32353534, /* ASCII = 4552 */
+};
+
+static const struct tcan4x5x_version_info tcan4x5x_tcan4553 = {
+	.id2_register = 0x33353534, /* ASCII = 4553 */
+};
+
 static const struct of_device_id tcan4x5x_of_match[] = {
-	{
-		.compatible = "ti,tcan4x5x",
-	}, {
-		/* sentinel */
-	},
+	{ .compatible = "ti,tcan4x5x", .data = &tcan4x5x_generic },
+	{ .compatible = "ti,tcan4552", .data = &tcan4x5x_tcan4552 },
+	{ .compatible = "ti,tcan4553", .data = &tcan4x5x_tcan4553 },
+	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, tcan4x5x_of_match);
 
 static const struct spi_device_id tcan4x5x_id_table[] = {
-	{
-		.name = "tcan4x5x",
-	}, {
-		/* sentinel */
-	},
+	{ .name = "tcan4x5x", .driver_data = (unsigned long) &tcan4x5x_generic, },
+	{ .name = "tcan4552", .driver_data = (unsigned long) &tcan4x5x_tcan4552, },
+	{ .name = "tcan4553", .driver_data = (unsigned long) &tcan4x5x_tcan4553, },
+	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(spi, tcan4x5x_id_table);
 
-- 
2.39.2

