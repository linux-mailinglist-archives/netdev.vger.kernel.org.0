Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401BB685F01
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjBAFfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjBAFe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:34:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45338518C9;
        Tue, 31 Jan 2023 21:34:56 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id pj3so3429911pjb.1;
        Tue, 31 Jan 2023 21:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RA+JqwnnHDN1DqNPiIeZmSltFt5YiL5Iiuh/bEa8zUw=;
        b=ZLj+Ci2e69SHJ+8dnKDR4QieC3FJsYsbhmkIvtWdF0oR4wHs3WjguvZuw3+0hGsuys
         eD61hbugaE4o50OYw+YdZH3T3VvoX4XP0f2QtP2kdbwUfcB/xfH1O7+5hJZ/go2R8dX5
         jEBxRJXotw6dkGc139Sx+Ols2GP5qw+x8xs3Tnl5L8L4Epwdyl/AYf/F8SsIQm2mF+LV
         Ka0vQ3smtCI/nFPMlKQ+5jJwUsG7RSCIUJJROOPJMnD++Wr0JDt054ftDthR+rUIlxw6
         /vfJmO2PNJILqqWKDgVx8GsuuoX1n2ZasJR97kDdZqLTqF0Pw+jvATafuvfsmaCd63H8
         c+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RA+JqwnnHDN1DqNPiIeZmSltFt5YiL5Iiuh/bEa8zUw=;
        b=WI1D/sRo2BjU+uT7CqDFRVzml59QHzhFH9sDrteQ+n9diABgnpZMRIB/9aBPQSIaXu
         klxMrNN9rCF58cDPw4NiW0hZCuyyc89ik5s593sDbiJL5n0BCCI5Zkj2kMu9Svz8gsUl
         IHXdV0ERRvo1nZk1UY0+ILJGWes8sbrqrYaAsXywBWEjgr61vP24Ngbk8SlZBgtNB1yj
         wZlEx8tMzGi7TMKJjWl94vQDPO+EPyPn0CMZq+HQKGDORv+dGwXgnwpBgFluLFm0T7Fk
         LqJ7lk1G4Bn8MipAoEn2GJ1gaRCt9f+I036eX/1EA4EykXuZ022gm4RaeHtJRgWcWagt
         BklQ==
X-Gm-Message-State: AO0yUKV8ETm3kgP78pRsSXmd0N4tbqN1KJIhNaAHtKqldRisybLfLP79
        J/IWzfaGKtAESDdnBTjaHhbjlUnNfO0=
X-Google-Smtp-Source: AK7set9LrIB7b0UbsYsW5bGgeSvWti3zX0JC2TNQK4M548wJu+f+hd4yS8L9f9IIyb8FDk6k/khPPA==
X-Received: by 2002:a17:90a:1a14:b0:229:f714:f779 with SMTP id 20-20020a17090a1a1400b00229f714f779mr893959pjk.26.1675229695607;
        Tue, 31 Jan 2023 21:34:55 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id kb1-20020a17090ae7c100b001fde655225fsm3233026pjb.2.2023.01.31.21.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 21:34:54 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] ieee802154: at86rf230: switch to using gpiod API
Date:   Tue, 31 Jan 2023 21:34:47 -0800
Message-Id: <20230201053447.4098486-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230201053447.4098486-1-dmitry.torokhov@gmail.com>
References: <20230201053447.4098486-1-dmitry.torokhov@gmail.com>
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

Switch the driver from legacy gpio API that is deprecated to the newer
gpiod API that respects line polarities described in ACPI/DT.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/ieee802154/at86rf230.c | 52 +++++++++++++++---------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index d6b6b355348b..62b984f84d9f 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -82,7 +82,7 @@ struct at86rf230_local {
 	struct ieee802154_hw *hw;
 	struct at86rf2xx_chip_data *data;
 	struct regmap *regmap;
-	int slp_tr;
+	struct gpio_desc *slp_tr;
 	bool sleep;
 
 	struct completion state_complete;
@@ -107,8 +107,8 @@ at86rf230_async_state_change(struct at86rf230_local *lp,
 static inline void
 at86rf230_sleep(struct at86rf230_local *lp)
 {
-	if (gpio_is_valid(lp->slp_tr)) {
-		gpio_set_value(lp->slp_tr, 1);
+	if (lp->slp_tr) {
+		gpiod_set_value(lp->slp_tr, 1);
 		usleep_range(lp->data->t_off_to_sleep,
 			     lp->data->t_off_to_sleep + 10);
 		lp->sleep = true;
@@ -118,8 +118,8 @@ at86rf230_sleep(struct at86rf230_local *lp)
 static inline void
 at86rf230_awake(struct at86rf230_local *lp)
 {
-	if (gpio_is_valid(lp->slp_tr)) {
-		gpio_set_value(lp->slp_tr, 0);
+	if (lp->slp_tr) {
+		gpiod_set_value(lp->slp_tr, 0);
 		usleep_range(lp->data->t_sleep_to_off,
 			     lp->data->t_sleep_to_off + 100);
 		lp->sleep = false;
@@ -204,9 +204,9 @@ at86rf230_write_subreg(struct at86rf230_local *lp,
 static inline void
 at86rf230_slp_tr_rising_edge(struct at86rf230_local *lp)
 {
-	gpio_set_value(lp->slp_tr, 1);
+	gpiod_set_value(lp->slp_tr, 1);
 	udelay(1);
-	gpio_set_value(lp->slp_tr, 0);
+	gpiod_set_value(lp->slp_tr, 0);
 }
 
 static bool
@@ -819,7 +819,7 @@ at86rf230_write_frame_complete(void *context)
 
 	ctx->trx.len = 2;
 
-	if (gpio_is_valid(lp->slp_tr))
+	if (lp->slp_tr)
 		at86rf230_slp_tr_rising_edge(lp);
 	else
 		at86rf230_async_write_reg(lp, RG_TRX_STATE, STATE_BUSY_TX, ctx,
@@ -1520,8 +1520,10 @@ static int at86rf230_probe(struct spi_device *spi)
 {
 	struct ieee802154_hw *hw;
 	struct at86rf230_local *lp;
+	struct gpio_desc *slp_tr;
+	struct gpio_desc *rstn;
 	unsigned int status;
-	int rc, irq_type, rstn, slp_tr;
+	int rc, irq_type;
 	u8 xtal_trim;
 
 	if (!spi->irq) {
@@ -1539,28 +1541,26 @@ static int at86rf230_probe(struct spi_device *spi)
 		xtal_trim = 0;
 	}
 
-	rstn = of_get_named_gpio(spi->dev.of_node, "reset-gpio", 0);
-	if (gpio_is_valid(rstn)) {
-		rc = devm_gpio_request_one(&spi->dev, rstn,
-					   GPIOF_OUT_INIT_HIGH, "rstn");
-		if (rc)
-			return rc;
-	}
+	rstn = devm_gpiod_get_optional(&spi->dev, "reset", GPIOD_OUT_LOW);
+	rc = PTR_ERR_OR_ZERO(rstn);
+	if (rc)
+		return rc;
 
-	slp_tr = of_get_named_gpio(spi->dev.of_node, "sleep-gpio", 0);
-	if (gpio_is_valid(slp_tr)) {
-		rc = devm_gpio_request_one(&spi->dev, slp_tr,
-					   GPIOF_OUT_INIT_LOW, "slp_tr");
-		if (rc)
-			return rc;
-	}
+	gpiod_set_consumer_name(rstn, "rstn");
+
+	slp_tr = devm_gpiod_get_optional(&spi->dev, "sleep", GPIOD_OUT_LOW);
+	rc = PTR_ERR_OR_ZERO(slp_tr);
+	if (rc)
+		return rc;
+
+	gpiod_set_consumer_name(slp_tr, "slp_tr");
 
 	/* Reset */
-	if (gpio_is_valid(rstn)) {
+	if (rstn) {
 		udelay(1);
-		gpio_set_value_cansleep(rstn, 0);
+		gpiod_set_value_cansleep(rstn, 1);
 		udelay(1);
-		gpio_set_value_cansleep(rstn, 1);
+		gpiod_set_value_cansleep(rstn, 0);
 		usleep_range(120, 240);
 	}
 
-- 
2.39.1.456.gfc5497dd1b-goog

