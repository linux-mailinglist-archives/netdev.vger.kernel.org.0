Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C8294466
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409776AbgJTVQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:16:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409769AbgJTVQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 17:16:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUyz0-002iX2-8Q; Tue, 20 Oct 2020 23:15:50 +0200
Date:   Tue, 20 Oct 2020 23:15:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020211550.GA456889@lunn.ch>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz>
 <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz>
 <20201020145839.GG139700@lunn.ch>
 <5a59f96e-070b-25d8-7921-64f7dc4516c6@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a59f96e-070b-25d8-7921-64f7dc4516c6@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris

> So far I've not needed to use interrupts from the 6097. It's connected 
> on my hardware but never been tested.

The mv88e6xxx driver will also poll the interrupt bits, if the
interrupt is not wired to a GPIO.

> There are a couple of SERDES LinkInt bits in the Global2 interrupt
> source/mask register which look as though they should fire.

Sounds good. Maybe more 6352 code you can copy.

> > If you can use that, you can then be more in line with the other
> > implementations and not need this change.

> My particular problem was actually on the other end of the link (which 
> is a 98dx160 that doesn't currently have a dsa driver). When the link 
> was forced on the 6097 end it would only link up if the 6097 came up 
> after the dx160. Are you saying there is a way of avoiding the call to 
> mv88e6xxx_mac_link_up() if I have interrupts for the serdes ports?

If you have all the code in place, what should happen is that the PCS
is powered up. It will try to establish a link with its peer. phylink
will also call serdes_pcs_an_restart() function to kick off auto-neg
on the PCS link. Once link is established, you should get an
interrupt. The interrupt handler then calls
dsa_port_phylink_mac_change() which tells phylink the PCS is now
up. It will use the serdes_pcs_get_state() call to find out what the
PCS pair have agreed on, and then configure the MAC with the same
information, forcing it.

Lets just hope you can do this, given the level of integration of the
PCS and MAC, in that there are no real PCS registers you can play
with.

	Andrew

