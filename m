Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3814867398A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjASNJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjASNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:08:05 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39366ECF;
        Thu, 19 Jan 2023 05:08:02 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 95AB41A20;
        Thu, 19 Jan 2023 14:08:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674133680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mcR19n1jDxBUupnqYv6z29UpOBYVbpXsCvGX6v7zcG0=;
        b=NDLWWYBkTVutRYnfjXhxKtQozJCPobbGKm41FWp+lv8xA3rDIuiWCWKrv9GVJp96TIMats
        YGVT1PCNvNvAIQpAdLGx1udVKsm/uaFfQrMU/5uVfVmvD3+ysuMEyqVFm3RHlurOjDsJ8g
        6DrjmliJLYEjoFZ/xuPUk1XOT5nPSnI6HQT5wYO2ZMgmp9YMp1xXc1ievjfY6aBoenlMG4
        RFIcC+hEwPLqaFh2rM6rWXHcUZrCon7GsHMb7GGg2DDO+m7QkAg64xnEED8KniBp6RUcoU
        Echz3WDK71FeMKCMeY2fhmEn9LtTglFMY14GzppjgyQVDldVqeq3X4v5Ln+Njg==
From:   Michael Walle <michael@walle.cc>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wells Lu <wellslutw@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next 4/4] net: mdio: Remove support for building C45 muxed addresses
Date:   Thu, 19 Jan 2023 14:07:00 +0100
Message-Id: <20230119130700.440601-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119130700.440601-1-michael@walle.cc>
References: <20230119130700.440601-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The old way of performing a C45 bus transfer created a special
register value and passed it to the MDIO bus driver, in the hope it
would see the MII_ADDR_C45 bit set, and perform a C45 transfer. Now
that there is a clear separation of C22 and C45, this scheme is no
longer used. Remove all the #defines and helpers, to prevent any code
being added which tries to use it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 include/linux/mdio.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 220f3ca8702d..c0da30d63b1d 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -10,14 +10,6 @@
 #include <linux/bitfield.h>
 #include <linux/mod_devicetable.h>
 
-/* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
- * IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips.
- */
-#define MII_ADDR_C45		(1<<30)
-#define MII_DEVADDR_C45_SHIFT	16
-#define MII_DEVADDR_C45_MASK	GENMASK(20, 16)
-#define MII_REGADDR_C45_MASK	GENMASK(15, 0)
-
 struct gpio_desc;
 struct mii_bus;
 struct reset_control;
@@ -463,16 +455,6 @@ static inline int mdiodev_modify_changed(struct mdio_device *mdiodev,
 				      mask, set);
 }
 
-static inline u16 mdiobus_c45_regad(u32 regnum)
-{
-	return FIELD_GET(MII_REGADDR_C45_MASK, regnum);
-}
-
-static inline u16 mdiobus_c45_devad(u32 regnum)
-{
-	return FIELD_GET(MII_DEVADDR_C45_MASK, regnum);
-}
-
 static inline int mdiodev_c45_modify(struct mdio_device *mdiodev, int devad,
 				     u32 regnum, u16 mask, u16 set)
 {
-- 
2.30.2

