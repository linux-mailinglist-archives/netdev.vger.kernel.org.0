Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D887303EF1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404786AbhAZNkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:40:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404797AbhAZNfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 08:35:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4OUX-002hpL-4I; Tue, 26 Jan 2021 14:34:45 +0100
Date:   Tue, 26 Jan 2021 14:34:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, grundler@chromium.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCHv2 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
Message-ID: <YBAadd6iuN0Ov2Ba@lunn.ch>
References: <20210121125731.19425-1-oneukum@suse.com>
 <20210121125731.19425-2-oneukum@suse.com>
 <YAomCIEWCsquQODX@lunn.ch>
 <3da2bd93f8da246d9032f4b07dff53a1b3648ccd.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da2bd93f8da246d9032f4b07dff53a1b3648ccd.camel@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:42:09AM +0100, Oliver Neukum wrote:
> Am Freitag, den 22.01.2021, 02:10 +0100 schrieb Andrew Lunn:
> > On Thu, Jan 21, 2021 at 01:57:29PM +0100, Oliver Neukum wrote:
> > > The old generic functions assume that the devices includes
> > > an MDIO interface. This is true only for genuine ethernet.
> > > Devices with a higher level of abstraction or based on different
> > > technologies do not have it. So in preparation for
> > > supporting that, we rename the old functions to something specific.
> > > 
> > > v2: adjusted to recent changes
> > 
> > Hi Oliver
> > 
> > It  looks like my comment:
> > 
> > https://www.spinics.net/lists/netdev/msg711869.html
> > 
> > was ignored. Do you not like the name mii?
> 
> Hi,
> 
> sorry for not replying earlier.
> 
> It was my understanding that on the hardware level of the
> networking devices we are using MII, but to control MII we
> use MDIO, don't we?
> So it seems to me that hardware could use MII but not
> MDIO, yet for this purpose we require MDIO. So could
> you please explain your reasoning about networking stuff?

Hi Oliver

To some extent, it is a terminology problem. First off, MII includes
the two MDIO pins. MDIO is a subset of MII.

However, the bigger issue is Linux has two different bits of code
which can be used to talk to the PHY. There is the old mii code,
driver/net/mii.c. This code assumes the PHY exactly follows 802.3
clause 22.

Then we have drivers/net/mdio, drivers/net/phy, phylib, and a
collection of PHYs drivers. The MDIO drivers implement the MDIO bus,
allowing transfers over the bus. And the PHY drivers then handle the
devices on this bus. These PHY drivers can handle nearly any quirk the
PHY might have which deviate from C22. It also allows drivers to use
C45, the alternative register set PHYs can use. And it allows for
added extras, like temperature sensors, cable diagnostics and
statistics, none of which is standardised.

The code you are changing makes use of the older mii code.  There are
however some USB devices which use phylib. By using the postfix _mii
for these ops, it makes it clear it is using the older mii code. In
the future, there might be _phylib versions of these ops. It is very
unlikely any USB device driver will directly use an MDIO bus drivers,
so _mdio does not really make sense, from the perspective of Linux
code.

    Andrew
