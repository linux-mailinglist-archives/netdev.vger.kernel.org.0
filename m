Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB132B2120
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKMQ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:56:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgKMQ4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:56:30 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdcN7-006sp2-4r; Fri, 13 Nov 2020 17:56:25 +0100
Date:   Fri, 13 Nov 2020 17:56:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201113165625.GN1456319@lunn.ch>
References: <20201017230226.GV456889@lunn.ch>
 <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home>
 <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch>
 <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Arnd
> >
> > This PHY driver bug hiding DT bug is always hard to handle. We have
> > been though it once before with the Atheros PHY. All the buggy DT
> > files were fixed in about one cycle.
> 
> Do you have a link to the problem for the Atheros PHY?

commit cd28d1d6e52e740130745429b3ff0af7cbba7b2c
Author: Vinod Koul <vkoul@kernel.org>
Date:   Mon Jan 21 14:43:17 2019 +0530

    net: phy: at803x: Disable phy delay for RGMII mode
    
    For RGMII mode, phy delay should be disabled. Add this case along
    with disable delay routines.
    
    Signed-off-by: Vinod Koul <vkoul@kernel.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

and

commit 6d4cd041f0af5b4c8fc742b4a68eac22e420e28c
Author: Vinod Koul <vkoul@kernel.org>
Date:   Thu Feb 21 15:53:15 2019 +0530

    net: phy: at803x: disable delay only for RGMII mode
    
    Per "Documentation/devicetree/bindings/net/ethernet.txt" RGMII mode
    should not have delay in PHY whereas RGMII_ID and RGMII_RXID/RGMII_TXID
    can have delay in PHY.
    
    So disable the delay only for RGMII mode and enable for other modes.
    Also treat the default case as disabled delays.
    
    Fixes: cd28d1d6e52e: ("net: phy: at803x: Disable phy delay for RGMII mode")

Looking at the git history, it seems like it also took two attempts to
get it working correctly, but the time between the two patches was
much shorted for the atheros PHY.

You will find DT patches converting rgmii to rgmii-id started soon
afterwards.

> I'm generally skeptical about the idea of being able to fix all DTBs,
> some of the problems with that being:
> 
> - There is no way to identify which of of the 2019 dts files in the
>   kernel actually have this particular phy, because it does not
>   have a device node in the dt. Looking only at files that set
>   phy-mode="rgmii" limits it to 235 files, but that is still more than
>   anyone can test.

You can narrow it down a bit. The rtl8211e was added
2014-06-10. Anything older than that, is unlikely to be a problem.
And you can ignore marvell, broadcom, etc boards. They are unlikely to
use a realtek PHY.

But i agree, we cannot test them all. We probably need to look at what
boards we know are broken, and get siblings tested.

> - if there was a way to automate identifying the dts files that
>   need to be modified, we should also be able to do it at runtime

We can get a hint, that there might be a problem, but we can get false
positives. These DT blobs are broken because they rely on strapping
resisters to put the PHY into the correct RGMII mode. We can read
these strapping resistors and compare them against what the software
is asking for. If they differ, it could be the DT blob is buggy. But
there are cases where the DT blob is correct, the strapping is wrong,
eg Pine64 Plus. It is doing everything correctly in DT.

> I agree this makes the problem harder, but I have still hope that
> we can come up with a code solution that can deal with this
> one board that needs to have the correct settings applied as well
> as the others on which we have traditionally ignored them.
> 
> As I understand it so far, the reason this board needs a different
> setting is that the strapping pins are wired incorrectly, while all
> other boards set them right and work correctly by default. I would
> much prefer a way to identify this behavior in dts and have the phy
> driver just warn when it finds a mismatch between the internal
> delay setting in DT and the strapping pins but keep using the
> setting from the strapping pins when there is a conflict.

So what you are suggesting is that the pine board, and any other board
which comes along in the future using this PHY which really wants
RGMII, needs a boolean DT property:

"realtek,IRealyDoWantRGMII_IAmNotBroken"

in the PHY node?

And if it is missing, we ignore when the MAC asks for RGMII and
actually do RGMII_ID?

We might also need to talk to the FreeBSD folks.

https://reviews.freebsd.org/D13591

Do we need to ask them to be bug compatible to Linux? Are the same DT
file being used?

That still leaves ACPI systems. Do we want to stuff this DT property
into an ACPI table? That seems to go against what ACPI people say
saying, ACPI is not DT with an extra wrapper around it.

   Andrew
