Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4DB44CE
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 02:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfIQAJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 20:09:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41569 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfIQAJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 20:09:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so938015pgg.8;
        Mon, 16 Sep 2019 17:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=RzqSTaMjoEGVXqONuLwzF8zYDDGD7d9ggRyLV1X2Sfg=;
        b=P4esKwUjjgl4iD1cEHunNuEnMBpZl8oKKo5CBnJ1fUSl/EOGfz9dodPcLPJ9yt/gjs
         RbL/YRkhAaTQxPwrqQp1X/OGYTWmTbakU4nB4JzbrgtrjJBbnBINlKGxCZJgs/o6FReI
         AjA54ato32tZbRsVv034lrjiTJemxNt7/IewGbeNUfhzR+HpP0XLA6YqERkdlD9LZWyM
         TkP5haCPTK8jLHsF3nzidqFHzskvr+1HngGbqj6+N6uvxltNEmvhjmSNeMlsDPUf5G3r
         fkAeKfShd47+v+4vBWU8u1APldk9K0shQSHxzEGOKUyGNVeJhLv6OguNBX0VEUTGQF3K
         llQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=RzqSTaMjoEGVXqONuLwzF8zYDDGD7d9ggRyLV1X2Sfg=;
        b=cs4y9M2Tweyl14BG9s1rtT8b+Cnbwh+AxcMC6UkAv8k6+MZgU9RVn4lUPzWfnyjHqe
         v2pCDpOqrArrziH+kgRvnijACm46XrH+kwHb8ARs7HKepWTj5aEnsHH7heI7s4R0stBZ
         rJAN4vuukoTMZ1ikNicxBc+lqd3EAFA3OyjGuZ2G54NXcMQZCQ4JdO/e1ebzWqAjkS18
         Uym0lvLbbn74Zfm+eujWnlCD/TwYyt/Px6lIMz+fhkIrkgx1XpYXCL8YfqzkutLe89AE
         +e4tkdQo1uKbjhINLnPiVo/PdQWHqmcE5mqjKkw/xkfWlPAZ8pUqF1bz7SxYD+R0lOrh
         5cgw==
X-Gm-Message-State: APjAAAW7M8jTqhOCLk0wDJ9ojDqLazAfSGGE/6ux9Z49H8158y0o7bzm
        /tI1PSSHGxogIOzDj1Y3Hgo=
X-Google-Smtp-Source: APXvYqzPthbiAUYrJXXb3tDB/2Cya3rDyMlBXEL/QfUSUf7e1+sTagOFx/RS2zBXuFtHg+77N5cMUA==
X-Received: by 2002:a62:7710:: with SMTP id s16mr1114555pfc.139.1568678976410;
        Mon, 16 Sep 2019 17:09:36 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id x20sm278752pfp.120.2019.09.16.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 17:09:35 -0700 (PDT)
Date:   Mon, 16 Sep 2019 17:09:33 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190917000933.GA254663@dtor-ws>
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

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v2 -> v3:

- no longer check for NULL before calling gpiod_set_consumer_name()
  as it handles NULL descriptors
- added Andy S's reviewed-by
- did NOT add Andrew's reviewed-by as I am unsure if he's OK with the
  latest iteration.

 drivers/net/phy/mdio_bus.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index ce940871331e..88c6ef7c7b13 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -42,22 +42,16 @@
 
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
 
+	gpiod_set_consumer_name(mdiodev->reset_gpio, "PHY reset");
 	return 0;
 }
 
-- 
2.23.0.237.gc6a4ce50a0-goog


-- 
Dmitry
