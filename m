Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B221EB3C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGNIZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:25:48 -0400
Received: from mail.intenta.de ([178.249.25.132]:37139 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgGNIZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 04:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:CC:To:From:Date; bh=fCnTX46foxSqd9con+NczxTjqdWoXymVhVFcJychH7A=;
        b=AZG8nQ13zLvTJ20UyZ26rJ2N6TspiMC/99bydRpUNSQc8PhaCE9yRIKZ+BKgJY+VA8KJSw2UPgdIpc+1y8qY5ZNts9JcSS1PMzpegzCpEzFKSm3LRP+77trGklik07yOlO57tNfEm7Ga50uNS/HSYJ9d6w0MdW8HONiIqp5DT8UuCjsT8hNXzH4gZDGs9VI4AyEhjN+tXEvsvHaNfB66wVNVj5FYof/5Y6e8ebBlkkU+K3mXPevRIeB/WMLl6t8YWFprrAfOHpjyx8HQ1s9Ui/S+bdEKJE6fL/aQbwKWzYYQW0UAHO2LmNKg3a7F80dBniyJ4+XVlqNCMp0ejUAUFw==;
Date:   Tue, 14 Jul 2020 10:25:42 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH] net: phy: phy_remove_link_mode should not advertise new modes
Message-ID: <20200714082540.GA31028@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing "ip link set dev ... up" for a ksz9477 backed link,
ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
called.

If one wants to advertise fewer modes than the supported ones, one
usually reduces the advertised link modes before upping the link (e.g.
by passing an appropriate .link file to udev).  However upping
overrwrites the advertised link modes due to the call to
phy_advertise_supported reverting to the supported link modes.

It seems unintentional to have phy_remove_link_mode enable advertising
bits and it does not match its description in any way. Instead of
calling phy_advertise_supported, we should simply clear the link mode to
be removed from both supported and advertising.

Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
Fixes: 41124fa64d4b29 ("net: ethernet: Add helper to remove a supported link mode")
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b4978c5fb2ca..74d06dc8fddb 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2509,7 +2509,7 @@ EXPORT_SYMBOL(genphy_loopback);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode)
 {
 	linkmode_clear_bit(link_mode, phydev->supported);
-	phy_advertise_supported(phydev);
+	linkmode_clear_bit(link_mode, phydev->advertising);
 }
 EXPORT_SYMBOL(phy_remove_link_mode);
 
-- 
2.20.1

