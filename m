Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332C45AF0C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbhKWWa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhKWWa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 17:30:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0909960F5B;
        Tue, 23 Nov 2021 22:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637706437;
        bh=/0wksCjjNp2xvUucWTF/BgordC1nU3nBLYg8On5SEKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+3RI5heOa26lmrODwBqDw4MNONmE6bsWuOX0EDSjI0tf8bUxlBjH0BKCO6EJSmhy
         SXsP6jx4s48njbzjPOAvYP/zLo91Tn38b6IBmrhCnrNI5Rf6E0SaHWjEoppRDVeEU+
         q18M47V9pSVywlzg6CF23Pmy34M9v4LI2xZvfoHQFiP7X3Qob9yhLJpcFSG6mI9yic
         ls8A5L0PuKyoiFw4Ar3AHtZZmkmtiHXXHnMzVthrrmQViJsmdS+UcD233G7jSWNbBb
         UZ7mGRD/ogD92a99QpPE1++wHxrCQy9p55q29xFi2qwXecDDV66tEetxs3E90wf4b1
         CUXolSpYB66UA==
Date:   Tue, 23 Nov 2021 23:27:13 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211123232713.460e3241@thinkpad>
In-Reply-To: <20211123212441.qwgqaad74zciw6wj@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
        <20211123164027.15618-5-kabel@kernel.org>
        <20211123212441.qwgqaad74zciw6wj@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, 23 Nov 2021 23:24:41 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> > +	/* We want the intersection of given supported modes with those defined
> > +	 * in DT.
> > +	 *
> > +	 * Some older device-trees mention only one of `sgmii`, `1000base-x` or
> > +	 * `2500base-x`, while supporting all three. Other mention `10gbase-r`
> > +	 * or `usxgmii`, while supporting both, and also `sgmii`, `1000base-x`,
> > +	 * `2500base-x` and `5gbase-r`.
> > +	 * For backwards compatibility with these older DTs, make it so that if
> > +	 * one of these modes is mentioned in DT and MAC supports more of them,
> > +	 * keep all that are supported according to the logic above.
> > +	 *
> > +	 * Nonetheless it is possible that a device may support only one mode,
> > +	 * for example 1000base-x, due to strapping pins or some other reasons.
> > +	 * If a specific device supports only the mode mentioned in DT, the
> > +	 * exception should be made here with of_machine_is_compatible().
> > +	 */
> > +	if (bitmap_weight(modes, PHY_INTERFACE_MODE_MAX) == 1) {  
> 
> I like the idea of extending the mask of phy_modes based on the
> phylink_config.supported_interfaces bitmap that the driver populates
> (assuming, of course, that it's converted correctly to this new format,
> and I looked through the implementations and just found a bug).

Russell is working on converting/fixing the drivers, you can look at his
changes at
 http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
look at the first two pages, search for "populate supported_interfaces"

> I think
> it might just work with old device trees, too. In fact, it may work so
> well, that I would even be tempted to ask "can we defer for a while
> updating the device trees and bindings documents with an array, just
> keep the phy modes as an array internally inside the kernel?"

We don't need to update the device-trees immediately, but I really
think the DT binding should be ready to allow multiple modes, if
someone does want to update.

> On the Marvell boards that you're working with, do you have an example
> board on which not all the PHY modes supported by the driver might be
> available? Do you also know the reason why? You give an example in the
> comments about 1000base-X and strapping, can you expand on that?

On Macchiatobin, both the mvpp2 MAC driver and the marvell10g PHY
driver support xaui mode, but that mode requires 4 SerDes lanes, and
the boards wires only one lane between the SOC and the PHY, so obviously
it cannot be used. Thinking about it, maybe I should have put this into
the commit message.

> Because I think it's a bit strange to create a framework for fixups now,
> when we don't even know what kind of stuff may be broken. The PHY modes
> (effectively SERDES protocols) might not be what you actually want to restrict.
> I mean, restricting the PHY modes is like saying: "the MAC supports
> USXGMII and 10GBase-R, the PHY supports USXGMII and 10GBase-R, I know
> how to configure both of them in each mode, but on this board, USXGMII
> works and 10GBase-R doesn't".
> 
> ?!

As I said above, the best example is with SerDeses which use multiple
lanes where not all may be wired. But this backward compatibility code
concerns only one-lane SerDeses: usxgmii, 10gbaser-r, 5gbase-r,
2500base-x, 1000base-x, sgmii. For these, I can think only of 2
possibilities why a fixup might be needed to restrict some mode when it
is supported both by MAC and PHY:
1) the mode is not supported by the board because it has too large
   frequency and the wiring on the board interferes with it.
   Example:
   - device tree defined phy-mode = "sgmii"
   - from this we infer also 1000base-x and 2500base-x
   - but 2500base-x works at 2.5x the frequency of 1000base-x/sgmii
   - the board wiring does not work at that frequency

   I don't know of any such board, but I know that such thing is
   possible, because for example the connetor on Turris MOX modules
   allows only frequencies up to 6 GHz. So it is not impossible for
   there to be boards where only 2 GHz is supported...

2) the mode is not supported by the board because the generic PHY
   driver uses SMC calls to the firmware to change the SerDes mode, but
   the board may have old version of firmware which does not support
   SMC call correctly (or at all). This was a real issue with TF-A
   firmware on Macchiatobin, where the 5gbase-r mode was not supported
   in older versions

> It may make more sense, when the time comes for the first fixup, to put
> a cap on the maximum gross data rate attainable on that particular lane
> (including stuff such as USXGMII symbol repetition), instead of having
> to list out all the PHY modes that a driver might or might not support
> right now. Imagine what pain it will be to update device trees each time
> a driver gains software support for a SERDES protocol it didn't support
> before. But if you cap the lane frequency, you can make phylink_update_phy_modes()
> deduce what isn't acceptable using simple logic.

So we would need to specify max data rate, usxgmii symbol repetition,
and number of lanes connected, and even then it could be not enough.
I think that simply specifying all the phy-modes that the HW supports
is simpler.

The devicetree does not need and should not be updated each time
software gains support for another SerDes protocol. The devicetree
should be updated only once, to specify all SerDes protocols that the
hardware supports (the SOC/MAC, the PHY, and the board wiring). The
software then takes from this list only those modes that the drivers
support. So no need to update device-tree each time SW gains support
for new SerDes mode.

> Also, if there's something to be broken by this change, why would we put
> an of_machine_is_compatible() here, and why wouldn't we instead update
> the phylink_config.supported_interfaces directly in the driver? I think
> it's the driver's responsibility for passing a valid mask of supported
> interfaces.

The whole idea of this code is to guarantee backward compatibility with
older device-trees. In my opinion (and I think Russell agrees with me),
this should be at one place, instead of putting various weird
exceptions into various MAC drivers.

Marek
