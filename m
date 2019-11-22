Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9831074C0
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfKVPXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:23:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46918 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfKVPXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 10:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j9MkqgvY1gQTNBDHU4J3+/xDrmMWJHkSjyVblaPYUUg=; b=iZ/DAvXH23OkMsCtV8Lpyt0brc
        jdEIS3OY1JcUfBCXCRkec5ZdtBsGLBKuJRES7dsQQhMgHOu+WF7iH14RuO78P6ywDmlIHg3VuwwPV
        PBX95ka3pCuKgVOGAV7c7PnAVEBdK6tebqpgzmo6xrBYFi0m4Mveml6c/LXH5lAV6dFyhN8EiZVJw
        sKOCzkPZ1ejoWAonsEGuRPxg7TnMCtJOtgNGLQzjTi+mP7PxNyUVQloYfRRWhYeLyZb+/6cUHWJK5
        A+dSQTynNd+20q4HUMslxVsxkYFhVSrhi4YTQ2bUEi+p0UKY15G5RhjWye/QJ/wNIJn+SQQ+s8JnH
        21o9FD0Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:36146 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iYAmK-0005vq-2d; Fri, 22 Nov 2019 15:23:24 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iYAmJ-0005gz-Hc; Fri, 22 Nov 2019 15:23:23 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: initialise phydev speed and duplex sanely
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iYAmJ-0005gz-Hc@rmk-PC.armlinux.org.uk>
Date:   Fri, 22 Nov 2019 15:23:23 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a phydev is created, the speed and duplex are set to zero and
-1 respectively, rather than using the predefined SPEED_UNKNOWN and
DUPLEX_UNKNOWN constants.

There is a window at initialisation time where we may report link
down using the 0/-1 values.  Tidy this up and use the predefined
constants, so debug doesn't complain with:

"Unsupported (update phy-core.c)/Unsupported (update phy-core.c)"

when the speed and duplex settings are printed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 232ad33b1159..8186aad4ef90 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -597,8 +597,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 	mdiodev->device_free = phy_mdio_device_free;
 	mdiodev->device_remove = phy_mdio_device_remove;
 
-	dev->speed = 0;
-	dev->duplex = -1;
+	dev->speed = SPEED_UNKNOWN;
+	dev->duplex = DUPLEX_UNKNOWN;
 	dev->pause = 0;
 	dev->asym_pause = 0;
 	dev->link = 0;
-- 
2.20.1

