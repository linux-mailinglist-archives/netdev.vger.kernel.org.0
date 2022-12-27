Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9142D6570CF
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiL0XIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiL0XHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:44 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1CD62E5;
        Tue, 27 Dec 2022 15:07:28 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 696AF169D;
        Wed, 28 Dec 2022 00:07:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PEAs1cY2KUGfDWF8DZJhmKi3UDdwVzcJA87E/SYrVOE=;
        b=mtu1oTBaxSngOLJAMfQndS7QsiKJFcYMtxVy/Vf3h9ET6EQmvAN9NTeV9uvL5debjMGv8c
        LcP9XcxB/6EcWrvVwEhOs9ijS22CCQyFKGLbEKSgik0owwnYgfVXqpgTUA4HZdtpVBb7H7
        v5nMCDpoHXlCUPKZMpempFS4ykEFxhFYFjmWHHfx+B9dRgwXBFJ+P0LejAaVmG2heL4liv
        fr8HpYAfgXekauNSI26OaansaGepJ1NLKTntcG+CMYfhX/NO6+O1wJSB3YAStScb1omZul
        AroLnuQwESfFBDCwasVEMZ1ti4zIFGEkGXYR6zxfC5emKzgU47zvhRYYyJJ+mQ==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:19 +0100
Subject: [PATCH RFC net-next v2 03/12] net: mdio: mdiobus_register: update
 validation test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Now that C45 uses its own read/write methods, the validation performed
when a bus is registers needs updating. All combinations of C22 and
C45 are supported, but both read and write methods must be provided,
read only busses are not supported etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] be consistent with other checks
 - [mw] make the test a bit easier to read
---
 drivers/net/phy/mdio_bus.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bde195864c17..d14d7704e895 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -526,8 +526,18 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	int i, err;
 	struct gpio_desc *gpiod;
 
-	if (NULL == bus || NULL == bus->name ||
-	    NULL == bus->read || NULL == bus->write)
+	if (!bus || !bus->name)
+		return -EINVAL;
+
+	/* An access method always needs both read and write operations */
+	if ((bus->read && !bus->write) ||
+	    (!bus->read && bus->write) ||
+	    (bus->read_c45 && !bus->write_c45) ||
+	    (!bus->read_c45 && bus->write_c45))
+		return -EINVAL;
+
+	/* At least one method is mandatory */
+	if (!bus->read && !bus->read_c45)
 		return -EINVAL;
 
 	if (bus->parent && bus->parent->of_node)

-- 
2.30.2
