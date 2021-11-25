Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E37445E01B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhKYSBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 13:01:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234085AbhKYR7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:59:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=d8VYqjw9ilW7Cs955guMDIAHtpa1HRXzIzAEebIyYls=; b=Pt
        7nb/pfu6oayB+DSkyo3dVnyxr5HiopWuPeFZ6bphQFnZ1TbTHr5nPl9Go+Gt009dKzdyeE6tFv6tL
        RVli+5yvoFz2pTMuyeV8+0VHbQPYRqS/WQH2qgbRzipR+ONqfnPre2LopIGMndpBkRrFJ56r4N1mS
        rGY5uIzf9VCIkNs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqIz9-00EdN8-No; Thu, 25 Nov 2021 18:56:39 +0100
Date:   Thu, 25 Nov 2021 18:56:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Disable AN on 2500base-x for
 Amethyst
Message-ID: <YZ/OV+ang2FW9phY@lunn.ch>
References: <20211125144359.18478-1-kabel@kernel.org>
 <YZ+txKp0sAOjQUka@lunn.ch>
 <20211125184551.2530cc95@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125184551.2530cc95@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 06:45:51PM +0100, Marek Behún wrote:
> On Thu, 25 Nov 2021 16:37:40 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Thu, Nov 25, 2021 at 03:43:59PM +0100, Marek Behún wrote:
> > > Amethyst does not support autonegotiation in 2500base-x mode.  
> > 
> > Hi Marek
> > 
> > I tried to avoid using Marvells internal names for these devices. I
> > don't think these names exist in the datasheet? They are visible in
> > the SDK, but that is not so widely available. So if you do want to use
> > these names, please also reference the name we use in the kernel,
> > mv88e6393x.
> 
> I used these names in previous commit that are already merged (search
> for Amethyst, Topaz, Peridot). But if you want, I can send v2. Please
> let me know if I should send v2.

I'm not against these names, but i don't like them used on there own,
thats all.

> > What happens when changing from say 1000BaseX to 2500BaseX? Do you
> > need to disable the advertisement which 1000BaseX might of enabled?

> 
> I don't need to disable it, it is disabled on it's own by cmode change.

O.K, that is important information to put into the commit message,
since it makes it clear you have thought about this, and a reviewer
does not need to ask the question.

> Moreover I did some experiments on 88E6393X vs 88E6190.
> 
> It is a little weird for 6393x.
> 
> On 6190
> - resetting the SerDes (BMCR_RESET) does not have impact on the
>   BMCR_ANENABLE bit, but changing cmode does
> 
>   when cmode is changed to SGMII or 1000base-x, it is enabled, for
>   2500base-x it is disabled
> 
> - resetting the SerDes (BMCR_RESET) when cmode is
>   - sgmii, changes value of the MV88E6390_SGMII_ADVERTISE to 0x0001
>     automatically
>   - 1000base-x or 2500base-x does not change the value of adv register
> 
>   moreover it seems that changing cmode also resets the the SerDes
> 
> On 6393x:
> - the BMCR behaves the same as in 6190: the switch defaults to AN
>   disabled for 2500base-x, and enabled for 1000base-x and SGMII
> 
> - the difference is that there are weird values written to
>   MV88E6390_SGMII_ADVERTISE on SerDes reset (which is done by switch
>   when changing cmode)
> 
>   for 1000base-x, the value is 0x9120
>   for 2500base-x, the value is 0x9f41
> 
>   I don't understand why they changed it so for 6393x.

Tobias found something which might be relevant here. On the 6390
family, if you change cmode while the SERDES is powered off, bad
things happen. What you could be seeing is another symptom of
that. Tobias has a WIP patch which changes the order of operations
when changing the cmode. It would be interesting to see if that makes
a difference here as well.

  Andrew
