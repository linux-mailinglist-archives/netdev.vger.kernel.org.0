Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DAD6570D4
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiL0XIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiL0XHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:45 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A856455;
        Tue, 27 Dec 2022 15:07:30 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6A0FF16DE;
        Wed, 28 Dec 2022 00:07:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RO0MXmSJzEk+1zx4vJ29wns0CosdyJgZJOJENWjajGc=;
        b=cYkMqjBQ7dPYmAfVqvYhpwUUd8PAVCQxNAv44EyS5NneWMCaFP2/jQxflBX576GAeO4jN3
        oJ8kQsj589dVFjReDTPEFUy3sTTiOw1rfwUtVWMCX2+Qvk7jVh+iO9WIAW/51LTE08QL7s
        hww9jRl3aRrSVrylqfVG0jYZsZNcNaEV/udoM3iGXcnZJ6NdAP1/RzvmOybXEl4Se6MlVG
        pugns2OvZhW2L2IpeYqDRMuNEU8iw4LqTDn8c3eqA7Pk38UsuUPFb9+M/UJq97k4lGnpT2
        KzwEYzMbJkQI8KW0EtoaLqHKJJKJSE2hhIf/SOjnC33OFAr98y5ofps8kuav5Q==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:21 +0100
Subject: [PATCH RFC net-next v2 05/12] net: mdio: Move mdiobus_c45_addr() next
 to users
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-5-ddb37710e5a7@walle.cc>
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

Now that mdiobus_c45_addr() is only used within the MDIO code during
fallback, move the function next to its only users. This function
should not be used any more in drivers, the c45 helpers should be used
in its place, so hiding it away will prevent any new users from being
added.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mdio_bus.c | 5 +++++
 include/linux/mdio.h       | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 20ba38a346fe..0b04ce3766c8 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -842,6 +842,11 @@ int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
 
+static u32 mdiobus_c45_addr(int devad, u16 regnum)
+{
+	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
+}
+
 /**
  * __mdiobus_c45_read - Unlocked version of the mdiobus_c45_read function
  * @bus: the mii_bus struct
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 1e78c8410b21..97b49765e8b5 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -459,11 +459,6 @@ static inline int mdiodev_modify_changed(struct mdio_device *mdiodev,
 				      mask, set);
 }
 
-static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
-{
-	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
-}
-
 static inline u16 mdiobus_c45_regad(u32 regnum)
 {
 	return FIELD_GET(MII_REGADDR_C45_MASK, regnum);

-- 
2.30.2
