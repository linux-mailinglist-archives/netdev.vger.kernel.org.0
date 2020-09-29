Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F9927CFAB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgI2NnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:43:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730027AbgI2NnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:43:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNFuI-00Gl93-K2; Tue, 29 Sep 2020 15:43:02 +0200
Date:   Tue, 29 Sep 2020 15:43:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200929134302.GF3950513@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> Hi Grant,
> 
> On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> > > +DSDT entry for MDIO node
> > > +------------------------
> > > +a) Silicon Component
> > > +--------------------
> > > +	Scope(_SB)
> > > +	{
> > > +	  Device(MDI0) {
> > > +	    Name(_HID, "NXP0006")
> > > +	    Name(_CCA, 1)
> > > +	    Name(_UID, 0)
> > > +	    Name(_CRS, ResourceTemplate() {
> > > +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > > +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > > +	       {
> > > +		 MDI0_IT
> > > +	       }
> > > +	    }) // end of _CRS for MDI0
> > > +	    Name (_DSD, Package () {
> > > +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > +	      Package () {
> > > +		 Package () {"little-endian", 1},
> > > +	      }
> > 
> > Adopting the 'little-endian' property here makes little sense. This looks
> > like legacy from old PowerPC DT platforms that doesn't belong here. I would
> > drop this bit.
> 
> I'm unable to drop this as the xgmac_mdio driver relies on this variable to
> change the io access to little-endian. Default is big-endian.
> Please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/xgmac_mdio.c?h=v5.9-rc7#n55

Hi Calvin

Are we talking about the bus controller endiannes, or the CPU
endianness?

If we are talking about the CPU endiannes, are you plan on supporting
any big endian platforms using ACPI? If not, just hard code it.
Newbie ACPI question: Does ACPI even support big endian CPUs, given
its x86 origins?

If this is the bus controller endianness, are all the SoCs you plan to
support via ACPI the same endianness? If they are all the same, you
can hard code it.

To some extent, this should be a moot point, assuming sane
hardware. Generally, the bus endian is fixed. It is either native, or
like PCI, little endian. The CPU endian is what can change. But in
general, once you figure out what you have, there is an IO macro which
will do the right thing without any configuration.

     Andrew
