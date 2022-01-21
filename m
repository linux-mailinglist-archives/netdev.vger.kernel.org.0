Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C531495FB6
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 14:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380659AbiAUNWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 08:22:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380583AbiAUNWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 08:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=87A/tDKQS+3qI1mDmEkAtXDZaWxRClH2krUZOoDdvz0=; b=HXUr11AwYknsAaClHt8ecVzUuM
        g9RDS6j5MlWIUmcRhHagqgr/y5LX3BlUdfaa6eAmPSDV8ixDcm3WlGmwc0zisCpz7dgr2OsFdJROc
        nL538wTMsDVLDIPLkhaVuqKGFeF0++g81fMlJjfCLqfM50QkJMJvuSNkwUpf1eHA2H1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAtrr-0025Os-NJ; Fri, 21 Jan 2022 14:22:15 +0100
Date:   Fri, 21 Jan 2022 14:22:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <Yeqzhx3GbMzaIbj6@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:01:35PM +0800, Kai-Heng Feng wrote:
> On Thu, Jan 20, 2022 at 10:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
> > > BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> > > instead of setting another value, keep it untouched and restore the saved
> > > value on system resume.
> > >
> > > Introduce config_led() callback in phy_driver() to make the implemtation
> > > generic.
> >
> > I'm also wondering if we need to take a step back here and get the
> > ACPI guys involved. I don't know much about ACPI, but shouldn't it
> > provide a control method to configure the PHYs LEDs?
> >
> > We already have the basics for defining a PHY in ACPI. See:
> >
> > https://www.kernel.org/doc/html/latest/firmware-guide/acpi/dsd/phy.html
> 
> These properties seem to come from device-tree.

They are similar to what DT has, but expressed in an ACPI way. DT has
been used with PHY drivers for a long time, but ACPI is new. The ACPI
standard also says nothing about PHYs. So Linux has defined its own
properties, which we expect all ACPI machine to use. According to the
ACPI maintainers, this is within the ACPI standard. Maybe at some
point somebody will submit the current definitions to the standards
body for approval, or maybe the standard will do something completely
different, but for the moment, this is what we have, and what you
should use.

> > so you could extend this to include a method to configure the LEDs for
> > a specific PHY.
> 
> How to add new properties? Is it required to add new properties to
> both DT and ACPI?

Since all you are adding is a boolean, 'Don't touch the PHY LED
configuration', it should be easy to do for both.

What is interesting for Marvell PHYs is WoL, which is part of LED
configuration. I've not checked, but i guess there are other PHYs
which reuse LED output for a WoL interrupt. So it needs to be clearly
defined if we expect the BIOS to also correctly configure WoL, or if
Linux is responsible for configuring WoL, even though it means
changing the LED configuration.

	 Andrew
