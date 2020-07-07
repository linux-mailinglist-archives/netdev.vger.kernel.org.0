Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160B9216E99
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgGGOT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:19:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgGGOT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 10:19:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsoRK-0041ut-8O; Tue, 07 Jul 2020 16:19:18 +0200
Date:   Tue, 7 Jul 2020 16:19:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>
Subject: Re: PHY reset handling during DT parsing
Message-ID: <20200707141918.GA928075@lunn.ch>
References: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 08:13:31PM +0200, Maxime Ripard wrote:
> Hi,
> 
> I came across an issue today on an Allwinner board, but I believe it's a
> core issue.
> 
> That board is using the stmac driver together with a phy that happens to
> have a reset GPIO, except that that GPIO will never be claimed, and the
> PHY will thus never work.
> 
> You can find an example of such a board here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195
> 
> It looks like when of_mdiobus_register() will parse the DT, it will then
> call of_mdiobus_register_phy() for each PHY it encounters [1].
> of_mdiobus_register_phy() will then if the phy doesn't have an
> ethernet-phy-id* compatible call get_phy_device() [2], and will later on
> call phy_register_device [3].
> 
> get_phy_device() will then call get_phy_id() [4], that will try to
> access the PHY through the MDIO bus [5].
> 
> The code that deals with the PHY reset line / GPIO is however only done
> in mdiobus_device_register, called through phy_device_register. Since
> this is happening way after the call to get_phy_device, our PHY might
> still very well be in reset if the bootloader hasn't put it out of reset
> and left it there.

Hi Maxime

If you look at the history of this code,

commit bafbdd527d569c8200521f2f7579f65a044271be
Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date:   Mon Dec 4 13:35:05 2017 +0100

    phylib: Add device reset GPIO support

you will see there is an assumption the PHY can be detected while in
reset. The reset was originally handled inside the at803x PHY driver
probe function, before it got moved into the core.

What you are asking for it reasonable, but you have some history to
deal with, changing some assumptions as to what the reset is all
about.

     Andrew
