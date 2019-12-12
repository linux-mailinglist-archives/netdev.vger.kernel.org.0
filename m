Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B321011CAD2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfLLKcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:32:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56554 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbfLLKcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OEjOqXdmZi8j8QH84bjbUMX2vR72B0mNtbRjjfGsVeQ=; b=hQ9YBPFXHwW06hKKAsmesi/O5E
        D5mNZl4lAXUW4VIogTSHrl0xnw5aHgUSZuugFmWyf4oPa19SjqfcrerTBWTPHVVW5rLWqV1ZbWUvG
        S8U8hphGJWTBzVP3Z3CIsZWJ2L3qeykvilt4Qicz0MYVCZ27RuUSzgiKzvtTUxh1Dk9mJI3wf5wek
        JMuwdBatWZM+00ZyzZvxgfzRnyckqW+wCLxfYhIUv8eWH7zL/JL18RIu1l7PYPaeOiHZiDm32+Hss
        Es8E3FIzvofqUjCuVGq7Zz/iwa2WIZUvO8UjZ9aqVlTf5TITiXi21Mt61xj8NSHeu/+TArbYn2D8N
        LWxtod7Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:48238 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifLlY-00060z-Bh; Thu, 12 Dec 2019 10:32:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifLlX-0004U8-Of; Thu, 12 Dec 2019 10:32:15 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: fix interface passed to mac_link_up
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ifLlX-0004U8-Of@rmk-PC.armlinux.org.uk>
Date:   Thu, 12 Dec 2019 10:32:15 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mismerge between the following two commits:

c678726305b9 ("net: phylink: ensure consistent phy interface mode")
27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")

resulted in the wrong interface being passed to the mac_link_up()
function. Fix this up.

Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1e6c031985c9..2c360e4e3cff 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -446,8 +446,7 @@ static void phylink_mac_link_up(struct phylink *pl,
 
 	pl->cur_interface = link_state.interface;
 	pl->ops->mac_link_up(pl->config, pl->cur_link_an_mode,
-			     pl->phy_state.interface,
-			     pl->phydev);
+			     pl->cur_interface, pl->phydev);
 
 	if (ndev)
 		netif_carrier_on(ndev);
-- 
2.20.1

