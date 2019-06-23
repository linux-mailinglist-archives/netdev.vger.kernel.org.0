Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6796C4FC35
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFWPO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:14:57 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52405 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWPO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:14:56 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45Wwvd5pXHz1rWT0;
        Sun, 23 Jun 2019 17:14:53 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45Wwvd5Bf9z1qrQW;
        Sun, 23 Jun 2019 17:14:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Gidud7ymT6Rz; Sun, 23 Jun 2019 17:14:52 +0200 (CEST)
X-Auth-Info: VTup+HbJYtG32PouUioUrMrw46dGB7LsAfA2/OeBkHw=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 23 Jun 2019 17:14:52 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V2] net: dsa: microchip: Use gpiod_set_value_cansleep()
Date:   Sun, 23 Jun 2019 17:12:57 +0200
Message-Id: <20190623151257.13660-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace gpiod_set_value() with gpiod_set_value_cansleep(), as the switch
reset GPIO can be connected to e.g. I2C GPIO expander and it is perfectly
fine for the kernel to sleep for a bit in ksz_switch_register().

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V2: use _cansleep in .remove as well
---
 drivers/net/dsa/microchip/ksz_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4f6648d5ac8b..978c59aa8efb 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -436,9 +436,9 @@ int ksz_switch_register(struct ksz_device *dev,
 		return PTR_ERR(dev->reset_gpio);
 
 	if (dev->reset_gpio) {
-		gpiod_set_value(dev->reset_gpio, 1);
+		gpiod_set_value_cansleep(dev->reset_gpio, 1);
 		mdelay(10);
-		gpiod_set_value(dev->reset_gpio, 0);
+		gpiod_set_value_cansleep(dev->reset_gpio, 0);
 	}
 
 	mutex_init(&dev->dev_mutex);
@@ -489,7 +489,7 @@ void ksz_switch_remove(struct ksz_device *dev)
 	dsa_unregister_switch(dev->ds);
 
 	if (dev->reset_gpio)
-		gpiod_set_value(dev->reset_gpio, 1);
+		gpiod_set_value_cansleep(dev->reset_gpio, 1);
 
 }
 EXPORT_SYMBOL(ksz_switch_remove);
-- 
2.20.1

