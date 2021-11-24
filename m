Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2207B45B982
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbhKXLx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhKXLx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 06:53:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2F460F45;
        Wed, 24 Nov 2021 11:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637754649;
        bh=yMN5+UoMt17EBxafVtXi9LE0djhuS8RhjHGePUWBSCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xdiqrg4L0Mb/yP0yGPFPn03rcGMu2gZqutMEbEPEH2ltDKgkQNSM1dL41AhtroX93
         fQTuUS6fFlWwn9UtTXMYcsfe6ipq0zRaDBsY6DW2vDi8Nhg/yty567hzZUx9kbHsko
         dGgQvOmnylDV4D++pDQqnJ+u0SMye1QxMIeQgOspH35UDXkeLM/Y3Snz/cs3Mm/+E3
         Iaw/81+B2z1oTlc8ujQ/dpBl/6MxGCsJJMDLfLQ0VU0kMHXLncPI6R1fCETp/9LvD1
         bXbx+L0WZKAqU3s1SctyIq9hWpMnm4O6sFDXHRvTh7u3TTH3g6cTTK9TtIJAPjjjjw
         J2kGb96aAbz5w==
Date:   Wed, 24 Nov 2021 12:50:44 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211124125044.10c08485@thinkpad>
In-Reply-To: <20211123225418.skpnnhnrsdqrwv5f@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
        <20211123164027.15618-5-kabel@kernel.org>
        <20211123212441.qwgqaad74zciw6wj@skbuf>
        <20211123232713.460e3241@thinkpad>
        <20211123225418.skpnnhnrsdqrwv5f@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 00:54:18 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> > As I said above, the best example is with SerDeses which use multiple
> > lanes where not all may be wired. But this backward compatibility code
> > concerns only one-lane SerDeses: usxgmii, 10gbaser-r, 5gbase-r,
> > 2500base-x, 1000base-x, sgmii.  
> 
> Right, why so? From phy-mode = "xaui", you could also infer support for
> single-lane SERDES protocols up to 3.125 GHz, aren't you interested in
> doing that too?

OK, this would seem to make sense if I dropped the DT binding change
for now, and just updated the code to change the supported_interfaces
member so that marvell10g driver could select appropriate mode.

I will think about it. Thanks.

> > 2) the mode is not supported by the board because the generic PHY
> >    driver uses SMC calls to the firmware to change the SerDes mode, but
> >    the board may have old version of firmware which does not support
> >    SMC call correctly (or at all). This was a real issue with TF-A
> >    firmware on Macchiatobin, where the 5gbase-r mode was not supported
> >    in older versions  
> 
> Ok, so in your proposal, U-Boot would have to fix up the device tree
> based on a certain version of ATF, and remove "5gbase-r" from the
> phy-mode array. Whereas in my proposal, the mvpp2 driver would need to
> find out about the ATF version in use, and remove "5gbase-r" from the
> supported interfaces.
> 
> As a user, I'd certainly prefer if Linux could figure this one out.

You are right here, it would really be better for the mvpp2 driver to
do this discovering.

> This implies that when you bring up a board and write the device tree
> for it, you know that PHY mode X works without ever testing it. What if
> it doesn't work when you finally add support for it? Now you already
> have one DT blob in circulation. That's why I'm saying that maybe it
> could be better if we could think in terms that are a bit more physical
> and easy to characterize.

The thing is that this same could happen with your proposal of
max-data-rate + number-of-lanes, as Russell explained in his reply.

> > The whole idea of this code is to guarantee backward compatibility with
> > older device-trees. In my opinion (and I think Russell agrees with me),
> > this should be at one place, instead of putting various weird
> > exceptions into various MAC drivers.  
> 
> Yes, but they're more flexible in the driver... What if the check is not
> as simple as a machine compatible (think about the ATF firmware example
> you gave).

You persuaded me, it makes more sense in the driver.

Marek
