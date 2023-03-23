Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0543A6C6558
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjCWKk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCWKkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:40:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A01E1EE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:37:49 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1pfIKD-0006Dh-SD; Thu, 23 Mar 2023 11:37:41 +0100
Received: from [2a0a:edc0:0:1101:1d::54] (helo=dude05.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pfIKB-00680F-3n; Thu, 23 Mar 2023 11:37:39 +0100
Received: from afa by dude05.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pfIK9-009wtp-V6; Thu, 23 Mar 2023 11:37:37 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel@pengutronix.de, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: dsa: realtek: fix out-of-bounds access
Date:   Thu, 23 Mar 2023 11:37:35 +0100
Message-Id: <20230323103735.2331786-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
with the expectation that priv has enough trailing space.

However, only realtek-smi actually allocated this chip_data space.
Do likewise in realtek-mdio to fix out-of-bounds accesses.

These accesses likely went unnoticed so far, because of an (unused)
buf[4096] member in struct realtek_priv, which caused kmalloc to
round up the allocated buffer to a big enough size, so nothing of
value was overwritten. With a different allocator (like in the barebox
bootloader port of the driver) or with KASAN, the memory corruption
becomes quickly apparent.

Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

---
v1 -> v2:
  - drop v1's patch 2/2, which appears to have no functional effect
    (Jakub)
  - extend commit message with probable reason why this long standing
    bug did not pop up so far in Linux (Prompted by Linus' question)
  - use saturating size_add instead of wrap-around addition (Jakub)
  - added reviewer R-b's
---
 drivers/net/dsa/realtek/realtek-mdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 7134886fe78d..1691faf77f00 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/overflow.h>
 #include <linux/regmap.h>
 
 #include "realtek.h"
@@ -152,7 +153,9 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	if (!var)
 		return -EINVAL;
 
-	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&mdiodev->dev,
+			    size_add(sizeof(*priv), var->chip_data_sz),
+			    GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.30.2

