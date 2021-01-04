Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123BC2E9BD3
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhADRQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:16:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADRQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 12:16:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwTSV-00Fzlp-99; Mon, 04 Jan 2021 18:15:55 +0100
Date:   Mon, 4 Jan 2021 18:15:55 +0100
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
Message-ID: <X/NNS3FUeSNxbqwo@lunn.ch>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf>
 <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
 <20210104170112.hn6t3kojhifyuaf6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104170112.hn6t3kojhifyuaf6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, so this does not have anything to do with interrupts explicitly but
> rather with the fact that any PHY access will cause a crash when the
> sh_eth device is powered down.
> 
> If the device is powered-down before the actual .ndo_open() how is the
> probe actually setting up the device? Or is the device returned to the
> powered-down state after the probe and only powered-up at a subsequent
> .ndo_open()?
> 
> Instead of the phy_is_started() call we could check if we had previously
> enabled the interrupts on the PHY but this would mean that a basic
> assumption of the PHY library is violated in that a registered PHY
> device cannot access its regiters because the MDIO controller just
> decided so.
> 
> Can't the MDIO bitbang driver callbacks just check if the device is
> powered-down and if it is just power it back up temporarily?

Is this runtime PM?

I had problems with the FEC driver and its runtime PM. After probe, it
would runtime power off its clocks, making the MDIO bus unusable. For
a plain boring setup, this is not too much of a problem, but when you
have a DSA switch on the bus, the DSA driver expects to be able to
access the switch, and this failed. I had to make the MDIO bus driver
in the FEC runtime PM aware, and turn the clocks back on again when an
MDIO transaction occurred.

The basic rules here should be, if the MDIO bus is registered, it is
usable. There are things like PHY statistics, HWMON temperature
sensors, etc, DSA switches, all which have a life cycle separate to
the interface being up.

    Andrew
