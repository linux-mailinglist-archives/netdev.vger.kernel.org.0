Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59149291814
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJRPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 11:38:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgJRPiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 11:38:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUAlB-002JSq-UZ; Sun, 18 Oct 2020 17:38:13 +0200
Date:   Sun, 18 Oct 2020 17:38:13 +0200
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
Message-ID: <20201018153813.GY456889@lunn.ch>
References: <20201017161435.GA1768480@apalos.home>
 <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch>
 <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch>
 <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch>
 <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch>
 <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Thanks for reporting back on that. It probably needs to be something
> > we always recommend for ACPI systems, either use "", or preferably no
> > phy-mode at all, and let the driver default to NA. ACPI and networking
> > is at a very early stage at the moment, since UEFA says nothing about
> > it. It will take a while before we figure out the best practices, and
> > some vendor gets something added to the ACPI specifications.
> >
> 
> You mean MDIO topology, right?

That is part of it. I2C for SFPs, ethernet switches, etc.  I think
SFPs are going to be the real sticking point, since when you get above
10Gbps, you are into the land of SFPs, and server platforms are those
which will be going above 10G first.

> Every x86 PC and server in the world uses ACPI, and networking
> doesn't seem to be a problem there, so it is simply a matter of
> choosing the right abstraction level. I know this is much easier to
> achieve when all the network controllers are on PCIe cards, but the
> point remains valid: exhaustively describing the entire SoC like we
> do for DT is definitely not the right choice for ACPI systems.

Agreed. And i am pushing back. But we also have the conflict that some
SoC IP is used in systems that will boot RHEL, Debian, etc, and in
systems that are DT based. Do you want to write two drivers? One
assuming ACPI is doing all the work, and another where DT describes
the system and drivers and network core does all the work configuring
the hardware. For the same piece of hardware?

> I do have a question about the history here, btw. As I understand it,
> before commit f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx
> delays config"), the phy-mode setting did not have any effect on
> Realtek PHYs in the first place, right? Since otherwise, this platform
> would never have worked from the beginning.

I suspect it did work to some extent, but not fully. So it could be,
it worked for whatever platform Serge was using, but failed in some
other cases, e.g. you board, and left the delays alone.

Later the vendor came along and said the code was wrong, and provided
some bits of information from the datasheet which is not publicly
available. As a result f81dadbcf7fd happened. Since that fixed a
previous patch, it was given a Fixes: tag and i assume back ported.

> So commit f81dadbcf7fd was backported to -stable, even though it
> didn't actually work, and had to be fixed in bbc4d71d63549bcd ("net:
> phy: realtek: fix rtl8211e rx/tx delay config"), which is the commit
> that causes the regression on these boards.
> 
> So why was commit f81dadbcf7fd sent to -stable in the first place?

f81dadbcf7fd first appears in v5.2. I don't see it in 4.19.152, the
LTS kernel older than that. So it is not in -stable.

    Andrew
