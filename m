Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D37291298
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 17:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438496AbgJQPLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 11:11:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438492AbgJQPLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 11:11:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTnro-0029zD-4a; Sat, 17 Oct 2020 17:11:32 +0200
Date:   Sat, 17 Oct 2020 17:11:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017151132.GK456889@lunn.ch>
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch>
 <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 04:46:23PM +0200, Ard Biesheuvel wrote:
> On Sat, 17 Oct 2020 at 16:44, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Oct 17, 2020 at 04:20:36PM +0200, Ard Biesheuvel wrote:
> > > Hello all,
> > >
> > > I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
> > > connectivity.
> >
> > Hi Ard
> >
> > Please could you point me at the DT files.
> >
> > > This box has a on-SoC socionext 'netsec' network controller wired to
> > > a Realtek 80211e PHY, and this was working without problems until
> > > the following commit was merged
> >
> > It could be this fix has uncovered a bug in the DT file. Before this
> > fix, if there is an phy-mode property in DT, it could of been ignored.
> > Now the phy-handle property is correctly implemented. So it could be
> > the DT has the wrong value, e.g. it has rgmii-rxid when maybe it
> > should have rgmii-id.
> >
> 
> This is an ACPI system. The phy-mode device property is set to 'rgmii'

Hi Ard

Please try rgmii-id.

Also, do you have the schematic? Can you see if there are any
strapping resistors? It could be, there are strapping resistors to put
it into rgmii-id. Now that the phy-mode properties is respected, the
reset defaults are being over-written to rgmii, which breaks the link.
Or the bootloader has already set the PHY mode to rgmii-id.

You can also use '' as the phy-mode, which results in
PHY_INTERFACE_MODE_NA, which effectively means, don't touch the PHY
mode, something else has already set it up. This might actually be the
correct way to go for ACPI. In the DT world, we tend to assume the
bootloader has done the absolute minimum and Linux should configure
everything. The ACPI takes the opposite view, the firmware will do the
basic hardware configuration, and Linux should not touch it, or ask
ACPI to modify it.

      Andrew
