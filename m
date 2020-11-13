Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D976F2B28B5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKMWnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:43:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKMWnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 17:43:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdhmX-006wE9-59; Fri, 13 Nov 2020 23:43:01 +0100
Date:   Fri, 13 Nov 2020 23:43:01 +0100
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
Message-ID: <20201113224301.GU1480543@lunn.ch>
References: <20201017230226.GV456889@lunn.ch>
 <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home>
 <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch>
 <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
 <20201113165625.GN1456319@lunn.ch>
 <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd

> Something of that sort. I also see a similar patch in KSZ9031
> now, see 7dd8f0ba88fc ("arm: dts: imx6qdl-udoo: fix rgmii phy-mode
> for ksz9031 phy")
> 
> As this exact mismatch between rgmii and rgmii-id mode is apparently
> a more widespread problem, the best workaround I can think of
> is that we redefine the phy-mode="rgmii" property to actually mean
> "use rgmii mode and let the phy driver decide the delay configuration",

The problem is, the PHY driver has no idea what the delay
configuration should be. That is the whole point of the DT property.

The MAC and the PHY have to work together to ensure one of them
inserts the delay. In most cases, the MAC driver reads the property
and passes it unmodified to the PHY. The PHY then does what it is
told. In some cases, the MAC decides to add the delay, it changes the
rgmii-id to rgmii before passing it onto the PHY. The PHY does as it
is told, and it works. And a very small number of boards simply have
longer clock lines than signal lines, so the PCB adds the delay. It is
not clearly defined how that should be described in DT, but it works
so far because most MAC drivers don't add delays, pass the 'rgmii'
from DT to the PHY and it does as it is told and does not add delays.

There is one more case, which is not used very often. The PHY is
passed the NA values, which means, don't touch, something else has set
it up. So when the straps are doing the correct thing, you could pass
NA. However, some MAC drivers look at the phy mode, see it is one of
the 4 rgmii modes, and configure their end to rgmii, instead of gmii,
mii, sgmii, etc. How networking does ACPI is still very undefined, but
i think we need to push for ACPI to pass NA, and the firmware does all
the setup. That seems to be ACPI way.

> with a new string to mean specifically rgmii mode with no delay.

As you said, we have phy-mode="rgmii" 235 times. How many of those are
going to break when you change the definition of rgmii?  I have no
idea, but my gut feeling is more than the number of boards which are
currently broken because of the problem with this PHY.

And, as i said above, some MAC drivers look for one of the 4 RGMII
modes in order to configure their side. If you add a new string, you
need to review all the MAC drivers and make sure they check for all 5
strings, not 4. Some of that is easy, modify
phy_interface_mode_is_rgmii(), but not all MAC use it, and it is no
help in a switch statement.

And we are potentially going to get into the same problem
again. History has shown, we cannot get 4 properties right. Do you
think we will do any better getting 5 properties right? Especially
when phy-mode="rgmii" does not mean rgmii, but do whatever you think
might be correct?

Having suffered the pain from the Atheros PHY, this is something i
review much more closely, so hopefully we are getting better at
this. But PHY drivers live for a long time, ksz9031 was added 7 years
ago, well before we started looking closely at delays. I expect more
similar problems will keep being found over the next decade.

To some extent, we actually need DT writers to properly test their
DT. If both rgmii and rgmii-id works, there is a 50% chance whatever
they pick is wrong. And it would be nice if they told the networking
people so we can fix the PHY.

       Andrew
