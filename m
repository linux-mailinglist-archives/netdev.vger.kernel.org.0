Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96FFB28B4
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbfIMWzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:55:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38970 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404136AbfIMWzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:55:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so16004384pgi.6;
        Fri, 13 Sep 2019 15:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=YOCcCRxIOok9UtBu3w8ejvgK3qlwfhE9K+Ea2gPAAv0=;
        b=mk5cpSLUe5Y0KZygPHuET8TK6k6kZKTY5KagXxP+yGlXUT/QZFWDJUHyZAxKQ8BZTN
         sgF78zBrY6Xme4OBkdStHRSRwgCL/LqKtQhm0TMmMbsltjTATkzGVD2cXXcuILW6lLgt
         JZ09rowccpokPp+CeosdwkCfPe9YiYZOlD6l+wH6joATYHx9B3RdyVGAXsl1/tZ5uAaA
         9JrxAekyglJUz1aeFate6jRMKKfvHGEqVJ0/b5BPud0kPE9VUSHk4H3auC+NGcunqh3S
         1e2KLEf9NXVZUKEGvsjABwwwvxv2c7i/w1pIWZ8IrBG7DfBUT08CPoMQAct/o/LEA6jt
         naBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=YOCcCRxIOok9UtBu3w8ejvgK3qlwfhE9K+Ea2gPAAv0=;
        b=gTdlcsDjapLrx3xS7FcjdtR2G0Q7Vp3CakYJUagGauClEFS4+CfRYNKdCXJ8mxmGS7
         XbLuaIofXq8vl3ol5vjLX+xhJ+/ggiE/sSmK3PqLNcr1iPvqUey11CvsQYeqjBJVNkzr
         qRq2YvgBScfv61FackkbSQh731IBa2Qr8u908q8FoSpE/8pmCmljFbdDdLFS2xh7mBs9
         r6T1xdF3cX8hfKqbg8FoYJThadIEiWndN4lJs5nNTmFuTMA/GkB4fwNhwo3DOy36GVp4
         KBkSPT2T/QtNhEKimLIhaXfh02E4dUDvWmJy6KZkJFGUPJ7tXSq+VBSeFB2Cu+XT68Oa
         qjKA==
X-Gm-Message-State: APjAAAXkwpA+CrviOXqzB1zSzSWAmtA0wSVGQqlwW2RDdYOKVmJ4PrlD
        qL5zCaWm/4XaDYej+OFBjko=
X-Google-Smtp-Source: APXvYqzgo4LlrwyTq3SfbfOBDlhDsuvtYDS9z7y+CB3dOdqhYYejNGEiXwmGU1SDChSFTKekLntO0w==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr7477765pjr.127.1568415350048;
        Fri, 13 Sep 2019 15:55:50 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 16sm633251pgp.23.2019.09.13.15.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 15:55:49 -0700 (PDT)
Date:   Fri, 13 Sep 2019 15:55:47 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190913225547.GA106494@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO device reset line is optional and now that gpiod_get_optional()
returns proper value when GPIO support is compiled out, there is no
reason to use fwnode_get_named_gpiod() that I plan to hide away.

Let's switch to using more standard gpiod_get_optional() and
gpiod_set_consumer_name() to keep the nice "PHY reset" label.

Also there is no reason to only try to fetch the reset GPIO when we have
OF node, gpiolib can fetch GPIO data from firmwares as well.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Note this is an update to a patch titled "[PATCH 05/11] net: mdio:
switch to using fwnode_gpiod_get_index()" that no longer uses the new
proposed API and instead works with already existing ones.

 drivers/net/phy/mdio_bus.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index ce940871331e..2e29ab841b4d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -42,21 +42,17 @@
 
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
-	struct gpio_desc *gpiod = NULL;
+	int error;
 
 	/* Deassert the optional reset signal */
-	if (mdiodev->dev.of_node)
-		gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
-					       "reset-gpios", 0, GPIOD_OUT_LOW,
-					       "PHY reset");
-	if (IS_ERR(gpiod)) {
-		if (PTR_ERR(gpiod) == -ENOENT || PTR_ERR(gpiod) == -ENOSYS)
-			gpiod = NULL;
-		else
-			return PTR_ERR(gpiod);
-	}
-
-	mdiodev->reset_gpio = gpiod;
+	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
+						 "reset", GPIOD_OUT_LOW);
+	error = PTR_ERR_OR_ZERO(mdiodev->reset_gpio);
+	if (error)
+		return error;
+
+	if (mdiodev->reset_gpio)
+		gpiod_set_consumer_name(mdiodev->reset_gpio, "PHY reset");
 
 	return 0;
 }
-- 
2.23.0.237.gc6a4ce50a0-goog


-- 
Dmitry
