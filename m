Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E65621681
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiKHO2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiKHO1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:27:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A662D58BFB
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RohdZqlGL/IUK60KAgwodfuD2z+zCWgOkBeOIb87npo=; b=0Cyc9gn1yTTjKeL1Cw/D1dkUEP
        8gL8QT2bIHeEkEiLRQo/DbXLibwWrO8VscL95OlrjbVZ485449fKB4R4+dSZHDS18BKJ5pQhX+HED
        sXCBpxODKhi0z3sRLuMuYjZg87CIkS6twawzb87xxP/hSK94vfz4B5XXt1o1Bf7ycwt/PQKdFYybF
        xmrgtak0NSLmzp0hc9MPo/mQGRUjd56o6G6bMx6nqcqBnlwrBSjdwq6eJxWEn7/rdcdWVDiwhm9QG
        X/AF3KWfJPN9Ru8KF1djBQY9yiILrUBOKcLi8rqFwTTGUg8LK2fhvV28OayCNN3kJTlyhhw6Fy0/6
        x21Sjy1Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45028 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1osPY4-0003KK-J0; Tue, 08 Nov 2022 14:25:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1osPY4-002SMk-03; Tue, 08 Nov 2022 14:25:56 +0000
In-Reply-To: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
References: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/2] net: mdio: add mdiodev_c45_(read|write)
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1osPY4-002SMk-03@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 08 Nov 2022 14:25:56 +0000
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/mdio.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 00177567cfef..f7fbbf3069e7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -488,6 +488,19 @@ static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum), val);
 }
 
+static inline int mdiodev_c45_read(struct mdio_device *mdiodev, int devad,
+				   u16 regnum)
+{
+	return mdiobus_c45_read(mdiodev->bus, mdiodev->addr, devad, regnum);
+}
+
+static inline int mdiodev_c45_write(struct mdio_device *mdiodev, u32 devad,
+				    u16 regnum, u16 val)
+{
+	return mdiobus_c45_write(mdiodev->bus, mdiodev->addr, devad, regnum,
+				 val);
+}
+
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.30.2

