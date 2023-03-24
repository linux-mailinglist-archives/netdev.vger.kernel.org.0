Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954976C7B9C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjCXJhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjCXJha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:30 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086CD2596C;
        Fri, 24 Mar 2023 02:37:11 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 902EF100007;
        Fri, 24 Mar 2023 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjAcdhdUxcOsTOcGYGylxKe370xV/9wJPyxiOPxbjJQ=;
        b=aD7qwCNeffDbZvrw87ON/4Mt8iFPClmi2/+tKAwBZZmLe+K46FDsiAApGI5eDGo3psk9tB
        XojG9bMLW7hZrFLpDOdHywmG2hVDGbtcktohEHjX7mlNd0moM4T1metH7P5MYrwnBbkn7W
        rAOhJvnie7dXxkGDQqePWgx6LKj1X+eFOdUdQG5X9Pq+RfSkI2fGxyTKqXHoILYg440PID
        AC2M0aIFq5J3hbR/wdld0ZasvVgzYptp6fMZ1jKfay2GMFjlWsVUAggbnKnqoH7pi0hpXN
        8jyB5xCFZXrosWTqvEgcgf0j9SEu6RT3VBooWtrIeCIYRmVGsZ6YF9ZHB+vPVw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 4/7] mfd: ocelot-spi: Change the regmap stride to reflect the real one
Date:   Fri, 24 Mar 2023 10:36:41 +0100
Message-Id: <20230324093644.464704-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When used over SPI, the register addresses needs to be translated,
compared to when used over MMIO. The translation consists in applying an
offset with reg_base, then downshifting the registers by 2. This
actually changes the register stride from 4 to 1.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/mfd/ocelot-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
index 2d1349a10ca9..107cda0544aa 100644
--- a/drivers/mfd/ocelot-spi.c
+++ b/drivers/mfd/ocelot-spi.c
@@ -124,7 +124,7 @@ static int ocelot_spi_initialize(struct device *dev)
 
 static const struct regmap_config ocelot_spi_regmap_config = {
 	.reg_bits = 24,
-	.reg_stride = 4,
+	.reg_stride = 1,
 	.reg_shift = REGMAP_DOWNSHIFT(2),
 	.val_bits = 32,
 
-- 
2.39.2

