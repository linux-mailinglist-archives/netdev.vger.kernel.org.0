Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A623E166B01
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgBTXfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:35:00 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55045 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:35:00 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so172373pjb.4;
        Thu, 20 Feb 2020 15:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ib7HQNjwBZEeeeqlrByrC4mTfctGE4wzzBlFkYuG584=;
        b=Iir8/4hrmlntwuBLVxLAydhzV39gHbjgOxHQiOIHle7rAw6MbPykzseyAGdUz6x0xC
         RGE82VY+cY+sRtNnJjnJP+cmARNC7s091dZ3Zr48PkpB6Q+T4YzHpM537Q9T1VvnfxN1
         SYO4c2ex3piIv/Lnar+AJThsbVsCLC4KxQ6OtE/wPICRsrCEUQPRHXtBQzfEQVj8+AWP
         +ZwWl/t0CygGV/RqZcybjH+eNPJn74acTVQFJPqWqu6rxmbf3XhlQwp337naYtmrRqeP
         kyLr9napuNwQ9/m29QCKiy0oHNu29lWI/z+jUXjANBNpTwQ1/ykB2Os7HjfqihGj0UK/
         3reA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ib7HQNjwBZEeeeqlrByrC4mTfctGE4wzzBlFkYuG584=;
        b=KWywZ6YTmDJuZnE9gi3/IpkDtaRSYrMsWJIBldhtK/di524MtVWC8hHCOCV+gleTBA
         qUpGkYt3lAzdcfP9CZ1C9d2RqTsHKTmAyzErFHZAwZeWnV7mRaZFnAjGwTTZT1NEWmgl
         dBwfcZIxaDNdsZtLuEsyiHlRfxmj/oxrJAlESpf/f5MhAtdROlkuZlEQOMjLyKGtfYKA
         uApN/gt/L6pp9Vb5iLAK6Fr+KpNOqrDick+UKNK0ysmuKREUDuClqcon0fgfWhN3qpPE
         jyV8Jtv4v2NJaPidtwI3KQvYB+ZhX8gS4RtRQkLQIlJwQsY/SZfcGp3JxOZujucU3t6e
         qHdQ==
X-Gm-Message-State: APjAAAXKqno8BTBzqhC+4t0xmYqlcxP1UPJ6EYTYES8rWe26LxWE9aYD
        nA3oOIQrx+ritNHhnQA2zJdZc+2H
X-Google-Smtp-Source: APXvYqzoUng9rwn9VWrUCJ73KCbi0fQVywXpbpLlOxAQAT0gelfcWCU46XOTD0SbUC9QJF/89dR4Kg==
X-Received: by 2002:a17:90a:e509:: with SMTP id t9mr6137477pjy.110.1582241699186;
        Thu, 20 Feb 2020 15:34:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d69sm693688pfd.72.2020.02.20.15.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 15:34:58 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yoshihiro.shimoda.uh@renesas.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Fugang Duan <B38611@freescale.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: Avoid multiple suspends
Date:   Thu, 20 Feb 2020 15:34:53 -0800
Message-Id: <20200220233454.31514-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is currently possible for a PHY device to be suspended as part of a
network device driver's suspend call while it is still being attached to
that net_device, either via phy_suspend() or implicitly via phy_stop().

Later on, when the MDIO bus controller get suspended, we would attempt
to suspend again the PHY because it is still attached to a network
device.

This is both a waste of time and creates an opportunity for improper
clock/power management bugs to creep in.

Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Heiner, Andrew,

I did consider adding logic that would check for phydev->suspended in
phy_suspend() and phy_resume(), but this was really the only place where
I found it to be problematic.

 drivers/net/phy/phy_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae77..6131aca79823 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -247,7 +247,7 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	 * MDIO bus driver and clock gated at this point.
 	 */
 	if (!netdev)
-		return !phydev->suspended;
+		goto out;
 
 	if (netdev->wol_enabled)
 		return false;
@@ -267,7 +267,8 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	if (device_may_wakeup(&netdev->dev))
 		return false;
 
-	return true;
+out:
+	return !phydev->suspended;
 }
 
 static int mdio_bus_phy_suspend(struct device *dev)
-- 
2.17.1

