Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5F48437F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiADOgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:36:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbiADOgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 09:36:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iPJY8FmBTPX6kbhEqdSBSnFfDbn9dgiEcVx7qD/ExH4=; b=ET/BQaK7oLM6ub/OdR6Nnltelu
        X5gktFngoDX6FrbJRbwM0l1M8nbXQJZZq5M/cuHoY8NoFHB17LYxVyy1Ogvr/e7EWtS59XJutIxbu
        eoIrIWaRiBSJN4N1dv86ommOQPZTj6yTD30i+YR82sjpGphqa5SJPQ467/IAazGh/xwc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4kvV-000TLF-To; Tue, 04 Jan 2022 15:36:37 +0100
Date:   Tue, 4 Jan 2022 15:36:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRbdaxdWSFyVjFp@lunn.ch>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
 <YdRVovG9mgEWffkn@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdRVovG9mgEWffkn@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Forget my other message, using 0x1040 lead to success.

O.K. this is going to be messy :-(

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..4bc7a44f613a 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1227,15 +1227,11 @@ static int m88e1118_config_init(struct phy_device *phydev)
 {
        int err;
 
-       /* Change address */
-       err = marvell_set_page(phydev, MII_MARVELL_MSCR_PAGE);
-       if (err < 0)
-               return err;
-
-       /* Enable 1000 Mbit */
-       err = phy_write(phydev, 0x15, 0x1070);
-       if (err < 0)
-               return err;
+       if (phy_interface_is_rgmii(phydev)) {
+               err = m88e1121_config_aneg_rgmii_delays(phydev);
+               if (err < 0)
+                       return err;
+       }
 
        /* Change address */
        err = marvell_set_page(phydev, MII_MARVELL_LED_PAGE);


will make the PHY driver respect the delays passed to it. But as
Russell already said, it is likely to break with boards which have
"rgmii" in their DT, which is currently being ignored and rgmii-id
programmed into hardware.

We have been here before, with another PHY driver. We decided to make
the change anyway, and fix broken DT when they were reported. It
caused some pain, but in the end, we avoided having odd DT properties
like:

       phy-mode = 'we-really-do-want-rgmii'

There is one more instance of phy_write(phydev, 0x15, 0x1070) for the
m88e1149. I suggest we leave that one alone, until we have a board
which actually requires it.

One thing i would like to understand is where is the delay actually
getting added? If you need the PHY to not add the delay, it is either
the MAC or the PCB. Can you look at the MAC driver and see if it has
any such configuration registers.

       Andrew
