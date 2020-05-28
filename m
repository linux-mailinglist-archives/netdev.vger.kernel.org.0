Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C371E671D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404874AbgE1QI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:08:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404666AbgE1QI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 12:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g7+apd5iHU977x2lEJZNWTIWFaiZlqB3L4cjMfiaFus=; b=Jd6iDpEQBLUDuOqaWacjCVx/2B
        pKIy/DvQhu5S7s1CtK2HrpqAjbQXs/VUjDxTUI8XMRAo8kbHZH11jxz9W3Gn0KqYLkBZRPh5SMC4s
        NwuCBb18aDQwUAxKexPuHsZY/XSUDGT+X9pW6cGaNJUjuAmTLUDY4y5fMuXBzZ0m/Dwg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeL5D-003YEr-B5; Thu, 28 May 2020 18:08:39 +0200
Date:   Thu, 28 May 2020 18:08:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200528160839.GE840827@lunn.ch>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch>
 <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
 <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
 <20200527205221.GA818296@lunn.ch>
 <CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 03:10:06PM +0200, Geert Uytterhoeven wrote:
> Hi Andrew,
> 
> On Wed, May 27, 2020 at 10:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > You may wonder what's the difference between 3 and 4? It's not just the
> > > PHY driver that looks at phy-mode!
> > > drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
> > > does, and configures an additional TX clock delay of 1.8 ns if TXID is
> > > enabled.
> >
> > That sounds like a MAC bug. Either the MAC insert the delay, or the
> > PHY does. If the MAC decides it is going to insert the delay, it
> > should be masking what it passes to phylib so that the PHY does not
> > add a second delay.
> 
> And so I gave this a try, and modified the ravb driver to pass "rgmii"
> to the PHY if it has inserted a delay.
> That fixes the speed issue on R-Car M3-W!
> And gets rid of the "*-skew-ps values should be used only with..."
> message.
> 
> I also tried if I can get rid of "rxc-skew-ps = <1500>". After dropping
> the property, DHCP failed.  Compensating by changing the PHY mode in DT
> from "rgmii-txid" to "rgmii-id" makes it work again.

In general, i suggest that the PHY implements the delay, not the MAC.
Most PHYs support it, where as most MACs don't. It keeps maintenance
and understanding easier, if everything is the same. But there are
cases where the PHY does not have the needed support, and the MAC does
the delays.

> However, given Philippe's comment that the rgmi-*id apply to the PHY
> only, I think we need new DT properties for enabling MAC internal delays.

Do you actually need MAC internal delays?

> That description is not quite correct: the driver expects skews for
> plain RGMII only. For RGMII-*ID, it prints a warning, but still applies
> the supplied skew values.

O.K. so not so bad.

> 
> To fix the issue, I came up with the following problem statement and
> plan:
> 
> A. Old behavior:
> 
>   1. ravb acts upon "rgmii-*id" (on SoCs that support it[1]),
>   2. ksz9031 ignored "rgmii-*id", using hardware defaults for skew
>      values.

So two bugs which cancelled each other out :-)

> B. New behavior (broken):
> 
>   1. ravb acts upon "rgmii-*id",
>   2. ksz9031 acts upon "rgmii-*id".
> 
> C. Quick fix for v5.8 (workaround, backwards-compatible with old DTB):
> 
>   1. ravb acts upon "rgmii-*id", but passes "rgmii" to phy,
>   2. ksz9031 acts upon "rgmi", using new "rgmii" skew values.
> 
> D. Long-term fix:

I don't know if it is possible, but i would prefer that ravb does
nothing and the PHY does the delay. The question is, can you get to
this state without more things breaking?

     Andrew
