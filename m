Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F347291504
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 01:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439833AbgJQXCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 19:02:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33006 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439814AbgJQXCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 19:02:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTvDW-002CpF-HB; Sun, 18 Oct 2020 01:02:26 +0200
Date:   Sun, 18 Oct 2020 01:02:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, steve@einval.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017230226.GV456889@lunn.ch>
References: <20201017151132.GK456889@lunn.ch>
 <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home>
 <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch>
 <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch>
 <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch>
 <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:19:25AM +0200, Ard Biesheuvel wrote:
> (cc'ing some folks who may care about functional networking on SynQuacer)
> 
> On Sat, 17 Oct 2020 at 21:49, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > So we can fix this firmware by just setting phy-mode to the empty
> > > string, right?
> >
> > I've never actually tried it, but i think so. There are no DT files
> > actually doing that, so you really do need to test it and see. And
> > there might be some differences between device_get_phy_mode() and
> > of_get_phy_mode().
> >
> 
> Yes, that works fine. Fixed now in the latest firmware build [0]

Thanks for reporting back on that. It probably needs to be something
we always recommend for ACPI systems, either use "", or preferably no
phy-mode at all, and let the driver default to NA. ACPI and networking
is at a very early stage at the moment, since UEFA says nothing about
it. It will take a while before we figure out the best practices, and
some vendor gets something added to the ACPI specifications.

> But that still leaves the question whether and how to work around this
> for units in the field. Ignoring the PHY mode in the driver would
> help, as all known hardware ships with firmware that configures the
> PHY with the correct settings, but we will lose the ability to use
> other PHY modes in the future, in case the SoC is ever used with DT
> based minimal firmware that does not configure networking.
> 
> Since ACPI implies rich firmware, we could make ACPI probing of the
> driver ignore the phy-mode setting in the DSDT.

I'm O.K. with that, for this driver, but please add a comment in the
code about why ACPI ignores DSDT, because of older broken firmware.

> But if we don't do the same for DT, it would mean DT users are
> forced to upgrade their firmware, and hopefully do so before
> upgrading to a kernel that breaks networking.

Nothing new there. As i said, we have been through this before with
the Atheros PHY and others.

One option would be to move the DT into the kernel and fix it. Most
distributions already use the DT version shipped with the kernel, so
they would automatically get the fixed DT at the same time as the
kernel which needs the fix.

       Andrew
