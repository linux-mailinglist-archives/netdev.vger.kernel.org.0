Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5402913A8
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438150AbgJQS1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:27:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437529AbgJQS1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:27:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTqva-002B95-Vf; Sat, 17 Oct 2020 20:27:38 +0200
Date:   Sat, 17 Oct 2020 20:27:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017182738.GN456889@lunn.ch>
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch>
 <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch>
 <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home>
 <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch>
 <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 08:11:24PM +0200, Ard Biesheuvel wrote:
> On Sat, 17 Oct 2020 at 20:04, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > I have tried this, and it seems to fix the issue. I will send out a
> > > patch against the netsec driver.
> >
> > Please also fix the firmware so it does not pass rgmii.
> >
> > If there are pure DT systems, which do require phy-mode to be used, we
> > will need to revert your proposed change in order to make the MAC
> > driver work as it should, rather than work around the broken firmware.
> >
> 
> What do you mean by 'pure' DT system? Only EDK2 based firmware exists
> for this platform

Currently, only EDK2 based firmware exists. Is there anything stopping
somebody using u-boot? ACPI is aimed for server class systems, on
ARM. If anybody wants to use this SoC in am embedded setting, not
server, then they are more likely to use DT, especially when you need
a complex network, eg. an Ethernet switch. It seems like ACPI is too
simple to support complex network hardware found in some embedded
systems.

> So what I propose to do is drop the handling of the [mandatory]
> phy-mode device property from the netsec driver (which is really only
> used by this board). As we don't really need a phy-mode to begin with,
> and given that firmware exists in the field that passes the wrong
> value, the only option I see for passing a value here is to use a
> different, *optional* DT property (force-phy-mode or
> phy-mode-override) that takes the place of phy-mode.

No, sorry, this is an ACPI problem, not a DT problem. I don't want to
accept DT hacks because of broken ACPI.

We have been through this before, when the Atheros PHY fixed is RGMII
delay support, and lots of platforms broke. Everybody just updated
their DT and were happy. I see no reason why ACPI should be different.

      Andrew
