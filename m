Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774AEAF744
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfIKHwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:52:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37247 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfIKHw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:52:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so10402198pfo.4;
        Wed, 11 Sep 2019 00:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yydq7IrTbJ5Mn0GrNsXPbRYtxDVN0KgTjTrtKFntf60=;
        b=Ltqu+TEU7FSI/hPzl0RFyfurKjjUX7afeGm4MW6ahotv5YVbss5YxfaWejIRWegIKu
         KWWeLuiI+Gen0ZNJtVVneZyvpHIfHe3odmMl07oGmzQ5RHaJNPY39Cs2mUziex+prmCo
         1Wr/haK3bk62QfEzx7Oxr6yx3qr7auEUzMcd2Rdh3HvNpNJy/uoCExLvO8h9Xy5ZKywv
         XI8K/D8WZoGdC5x+1/NXmOsDuZH3FNsNRpvbNsbxC8D3+moGkSXCr6ux96kwxfg23fPz
         SD6uUUu9lU6Q4lkiDDF6X3ZCgRlskWBypIwgRR+5ab3E2KygnCbpTuUDKkHfjCez+s8R
         9whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yydq7IrTbJ5Mn0GrNsXPbRYtxDVN0KgTjTrtKFntf60=;
        b=rzSF5/AUlEiB1K+I+ajDwWzOFg52HKRlb/j0U+iJpnxQyuLEfq+InTTNcFwpUjMub5
         pAzwr9B6eTI7ESHXWTIaEUDWOnoKbRQ+lhAjiYF+RkW33UFC2Al+SAJIlbrXaGbKFz8W
         GzxtKwW/nWk4TV7n75R3BCTwQlJKNk+3mF6u8hSMSrmuv9U3PapL1R5f3BsYLzIZP4B7
         6iXfmC8P/WoSpF0BDs/8/QTOb1+tg4ym363OZhblEB0H4I/oN46RqvzsAy0kNL11Ehhc
         vAPNXKIm/Kf+oirm8S9FPd5rTkXYX08BYA3YHUt0JjIiY13EPLoZ7ObzR8vVSs80Vi1b
         tbWg==
X-Gm-Message-State: APjAAAWzFdkdHpfCFyQXCwrzWMVe76LBGJQeBYCOGlTRPFwe+14tm7G3
        0lWzhwpuSlie9MelT1cyUqA=
X-Google-Smtp-Source: APXvYqwg8K8Fw8ARsm6u5ykMqv/AVVwSEyOJ3Pa+I0iHWUcUVNmu1qHGqcn83BJVPOwR5bPFitOqNw==
X-Received: by 2002:a65:438a:: with SMTP id m10mr1087350pgp.43.1568188346234;
        Wed, 11 Sep 2019 00:52:26 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id u2sm8582445pgp.66.2019.09.11.00.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 00:52:25 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 05/11] net: mdio: switch to using fwnode_gpiod_get_index()
Date:   Wed, 11 Sep 2019 00:52:09 -0700
Message-Id: <20190911075215.78047-6-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
In-Reply-To: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
works with arbitrary firmware node.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/net/phy/mdio_bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index ce940871331e..9ca51d678123 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -46,8 +46,8 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 
 	/* Deassert the optional reset signal */
 	if (mdiodev->dev.of_node)
-		gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
-					       "reset-gpios", 0, GPIOD_OUT_LOW,
+		gpiod = fwnode_gpiod_get_index(&mdiodev->dev.of_node->fwnode,
+					       "reset", 0, GPIOD_OUT_LOW,
 					       "PHY reset");
 	if (IS_ERR(gpiod)) {
 		if (PTR_ERR(gpiod) == -ENOENT || PTR_ERR(gpiod) == -ENOSYS)
-- 
2.23.0.162.g0b9fbb3734-goog

