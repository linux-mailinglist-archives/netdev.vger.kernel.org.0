Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B7A2FC875
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbhATDGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:06:37 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:38197 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbhATDGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:06:34 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DL9Pd4H2gz1rtNH;
        Wed, 20 Jan 2021 04:05:25 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DL9Pd3BGHz1qrQH;
        Wed, 20 Jan 2021 04:05:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id h5fIFhJpuvWy; Wed, 20 Jan 2021 04:05:24 +0100 (CET)
X-Auth-Info: W/RyjqeVD5TohAmA29UwOZtxG/W+NeW91zZOE3gbKtM=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 20 Jan 2021 04:05:24 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
Subject: [PATCH net-next V2] net: dsa: microchip: Adjust reset release timing to match reference reset circuit
Date:   Wed, 20 Jan 2021 04:05:02 +0100
Message-Id: <20210120030502.617185-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
rise enough to release the reset.

For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
                    VDDIO - VIH
  t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
                       VDDIO
so we need ~95 ms for the reset to really de-assert, and then the
original 100us for the switch itself to come out of reset. Simply
msleep() for 100 ms which fits the constraint with a bit of extra
space.

Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended reset timing")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Paul Barker <pbarker@konsulko.com>
---
V2: Use lowercase 's' for second
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 489963664443..389abfd27770 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -400,7 +400,7 @@ int ksz_switch_register(struct ksz_device *dev,
 		gpiod_set_value_cansleep(dev->reset_gpio, 1);
 		usleep_range(10000, 12000);
 		gpiod_set_value_cansleep(dev->reset_gpio, 0);
-		usleep_range(100, 1000);
+		msleep(100);
 	}
 
 	mutex_init(&dev->dev_mutex);
-- 
2.29.2

