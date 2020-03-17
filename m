Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4B1188816
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgCQOwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:52:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40892 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCQOwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I+CnsYu5/W3zcU0P7WpqCGsZph7XFTUJ0Pa2YZiumvg=; b=Z4yidZMg9vDPQXbD0q570iO05x
        y4kHRFMxYUJ5oIc3mFZU8LMIxmO19DiwX/5H3PiZxru0dm1sXbzbw8xi+6bllBYzX4+KUNP8JSkW7
        jbkaIuS8brqF88YGvKP8ZrobU43GFGzqeDDSNxxOH2x7qVgKZDLiMmx3InivdOUXgH/lj6tnshZbJ
        igN97y8Ten9wUc4NKdNa+HqAWJILzUFRLCBitfx1lXvG6iQjrbBVuRQ2Q27ofkhvQonXVpU73iAuy
        CpogpeFvhSRAKszFk5ukkmYHs6YQwcaScMjTXS9nk29C8Wmmtw9XmoVUQR23U80yyzQeuuIFTMfD+
        E6PWLnVg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44352 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDZy-0007ha-Lc; Tue, 17 Mar 2020 14:52:26 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDZy-0008Ih-3D; Tue, 17 Mar 2020 14:52:26 +0000
In-Reply-To: <20200317144906.GO25745@shell.armlinux.org.uk>
References: <20200317144906.GO25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/4] net: mdiobus: avoid BUG_ON() in mdiobus
 accessors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEDZy-0008Ih-3D@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 14:52:26 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid using BUG_ON() in the mdiobus accessors, prefering instead to use
WARN_ON_ONCE() and returning an error.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 3ab9ca7614d1..129e60630319 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -841,7 +841,8 @@ int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum)
 {
 	int retval;
 
-	BUG_ON(in_interrupt());
+	if (WARN_ON_ONCE(in_interrupt()))
+		return -EINVAL;
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 	retval = __mdiobus_read(bus, addr, regnum);
@@ -865,7 +866,8 @@ int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 {
 	int retval;
 
-	BUG_ON(in_interrupt());
+	if (WARN_ON_ONCE(in_interrupt()))
+		return -EINVAL;
 
 	mutex_lock(&bus->mdio_lock);
 	retval = __mdiobus_read(bus, addr, regnum);
@@ -893,7 +895,8 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 {
 	int err;
 
-	BUG_ON(in_interrupt());
+	if (WARN_ON_ONCE(in_interrupt()))
+		return -EINVAL;
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 	err = __mdiobus_write(bus, addr, regnum, val);
@@ -918,7 +921,8 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 {
 	int err;
 
-	BUG_ON(in_interrupt());
+	if (WARN_ON_ONCE(in_interrupt()))
+		return -EINVAL;
 
 	mutex_lock(&bus->mdio_lock);
 	err = __mdiobus_write(bus, addr, regnum, val);
-- 
2.20.1

