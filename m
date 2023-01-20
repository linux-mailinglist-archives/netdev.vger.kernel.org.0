Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7887D67530F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjATLJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjATLJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:09:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F639290
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:09:54 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1pIpHA-0003LV-Nf; Fri, 20 Jan 2023 12:09:40 +0100
Received: from [2a0a:edc0:0:1101:1d::54] (helo=dude05.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pIpH8-007MGq-Qe; Fri, 20 Jan 2023 12:09:38 +0100
Received: from afa by dude05.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pIpH8-004peO-59; Fri, 20 Jan 2023 12:09:38 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     kernel@pengutronix.de, ore@pengutronix.de,
        Arun.Ramadoss@microchip.com,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: dsa: microchip: fix probe of I2C-connected KSZ8563
Date:   Fri, 20 Jan 2023 12:09:32 +0100
Message-Id: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with commit eee16b147121 ("net: dsa: microchip: perform the
compatibility check for dev probed"), the KSZ switch driver now bails
out if it thinks the DT compatible doesn't match the actual chip ID
read back from the hardware:

  ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
  KSZ8563, please fix it!

For the KSZ8563, which used ksz_switch_chips[KSZ9893], this was fine
at first, because it indeed shares the same chip id as the KSZ9893.

Commit b44908095612 ("net: dsa: microchip: add separate struct
ksz_chip_data for KSZ8563 chip") started differentiating KSZ9893
compatible chips by consulting the 0x1F register. The resulting breakage
was fixed for the SPI driver in the same commit by introducing the
appropriate ksz_switch_chips[KSZ8563], but not for the I2C driver.

Fix this for I2C-connected KSZ8563 now to get it probing again.

Fixes: b44908095612 ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip").
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
v1 -> v2:
  - rewrote commit message and Fixes: to point at correct
    culprit commit introducing regression (Arun)
  - included Andrew's Reviewed-by
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index c1a633ca1e6d..e315f669ec06 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -104,7 +104,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz8563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ8563]
 	},
 	{
 		.compatible = "microchip,ksz9567",
-- 
2.30.2

