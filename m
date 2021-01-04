Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D702E9C0F
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhADRbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:31:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbhADRbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 12:31:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwThB-00FzuS-9r; Mon, 04 Jan 2021 18:31:05 +0100
Date:   Mon, 4 Jan 2021 18:31:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Message-ID: <X/NQ2fYdBygm3CYc@lunn.ch>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf>
 <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
 <20210104170112.hn6t3kojhifyuaf6@skbuf>
 <X/NNS3FUeSNxbqwo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/NNS3FUeSNxbqwo@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The basic rules here should be, if the MDIO bus is registered, it is
> usable. There are things like PHY statistics, HWMON temperature
> sensors, etc, DSA switches, all which have a life cycle separate to
> the interface being up.

[Goes and looks at the code]

Yes, this is runtime PM which is broken.

sh_mdio_init() needs to wrap the mdp->mii_bus->read and
mdp->mii_bus->write calls with calls to

pm_runtime_get_sync(&mdp->pdev->dev);

and

pm_runtime_put_sync(&mdp->pdev->dev);

The KSZ8041RNLI supports statistics, which ethtool --phy-stats can
read, and these will also going to cause problems.

      Andrew
