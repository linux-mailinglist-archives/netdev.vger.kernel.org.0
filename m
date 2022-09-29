Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A81D5EECFC
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiI2FEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiI2FEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:04:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F3C2E2;
        Wed, 28 Sep 2022 22:04:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so303625pjk.2;
        Wed, 28 Sep 2022 22:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=BDWgwZsRIGEUohQLHcdxwjK+vB3fIpf3i8HDgHGiLrQ=;
        b=lOjKtTAyq/UW1zBmUa4fr/tMFAGL/1/VG0gzY9HFDvup77/S6sAonpS5IuIMZp8kI/
         MJr0vfKkGlhVwolEb5Y2XQ/QnQKq5SHB6Vqx1j9JH8mRP3EjnOSBG4lpBJslsXmGRV55
         1W/7RYapxb2ytju52OHXt+cZxbyphRiTU2qdqJWuAz+onvCmhBwcTPGbubc0uYYckCNL
         pI2okPbbOxTYqOiaoVopR3OY1sz/lL55Nak1Xms6wo3XnJWXW3kbBUnloc9MiFP7Vusa
         Cfxq8TdIZfIamRjhJtlMHkRfm1nzwzOSaP7SbCjjzoDOJeyfpxyNxvxb/fWJ4DNJO7cG
         kuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=BDWgwZsRIGEUohQLHcdxwjK+vB3fIpf3i8HDgHGiLrQ=;
        b=IkwJnrSISM1d4DILoYb9zi8+BcZla4kypfLU8WoIcXMCKWt9RD+D88a3eoXRZnawnr
         ykBNiWKCv0Np2c+JFMeyhrb1Y5Iw1nzeSMSfyKYHXzLrzOFTF6FfmnatsXho/HwbF99H
         lVzzQczwWz4kyh9Hx9tWnFuaWCSPmtdBOwB0UwuqvIIwY6a6bVOepwztZBvZAxA+eofb
         OVeydDqGSHwaA5CIflrF3GNtDPvkRC4y9rDfhARwjBO7ZqRSkynnKhhDEuw8Gyfj7Ram
         Hs4AV2kuFyHGPdQcWYan/L3ccvhFknFt7NGo+Irq3HLxr28JXnM9O430qDwSX0p026x/
         za0Q==
X-Gm-Message-State: ACrzQf2MTONafzu1Pl4H/ImDNQYBcq2Wz8qkKQyEAwfVbl+ad+kO+lXn
        5OmcD4kYXyaZguceMPP2NQxNIFc0LCg=
X-Google-Smtp-Source: AMsMyM6B4mqozwKUMI+P1tqvfG6ToZ4fA1HMoeUcpQZIILgAWBcSRgDkGDRBL4lHUNcLICJ2PmBmqg==
X-Received: by 2002:a17:90b:4c41:b0:202:78e9:472b with SMTP id np1-20020a17090b4c4100b0020278e9472bmr1675859pjb.207.1664427871470;
        Wed, 28 Sep 2022 22:04:31 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:637c:7f23:f348:a9e6])
        by smtp.gmail.com with ESMTPSA id ij25-20020a170902ab5900b00179f370dbe7sm4314330plb.287.2022.09.28.22.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 22:04:30 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] nfc: s3fwrn5: use devm_clk_get_optional_enabled() helper
Date:   Wed, 28 Sep 2022 22:04:26 -0700
Message-Id: <20220929050426.955139-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because we enable the clock immediately after acquiring it in probe,
we can combine the 2 operations and use devm_clk_get_optional_enabled()
helper.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index fb36860df81c..2aaee2a8ff1c 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -209,22 +209,16 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	phy->clk = devm_clk_get_optional(&client->dev, NULL);
-	if (IS_ERR(phy->clk))
-		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
-				     "failed to get clock\n");
-
 	/*
 	 * S3FWRN5 depends on a clock input ("XI" pin) to function properly.
 	 * Depending on the hardware configuration this could be an always-on
 	 * oscillator or some external clock that must be explicitly enabled.
 	 * Make sure the clock is running before starting S3FWRN5.
 	 */
-	ret = clk_prepare_enable(phy->clk);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed to enable clock: %d\n", ret);
-		return ret;
-	}
+	phy->clk = devm_clk_get_optional_enabled(&client->dev, NULL);
+	if (IS_ERR(phy->clk))
+		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
+				     "failed to get clock\n");
 
 	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
 			    &i2c_phy_ops);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

