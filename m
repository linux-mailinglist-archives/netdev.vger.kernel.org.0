Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD002F3DB7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388834AbhALVpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbhALVox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:44:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46EE723122;
        Tue, 12 Jan 2021 21:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610487853;
        bh=NB7CmwSfGF3GYVNQfL2O8jQBDwZEfpYQQcqbM6FBGqs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YeoJsIp/Q4185Vz8jYEhy5o0nJOpiInn0ttgYYLafzM+PVRg3AmN9vzstN9JFX7+Q
         G7U8PaMa8pNguZytzEB7t6xD3TDyWlY0X2hHjzFrPJFUo2BbElHd3NSBNRsjOgc952
         5+y7FtmlbBO1BsFAb+SpkCqhrdck+uX5jFFPi0SnLYD0Z2YVzfpbzL0I4RiVwS8jgL
         ga2PRxm/xDE8XgnA2WbZr6aXEPmibyoG+By6xF2C8CVUnAX/DLTTOiMo7RnKRHQwIg
         OmpaGG2VbYgp9JdZEoNSub3JhScNq9MDOgu0FjVe6J5spFukFadcVYY5AhahGc8c/K
         6U0VTHFfyEaOg==
Date:   Tue, 12 Jan 2021 22:44:08 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112224408.2282ce5e@kernel.org>
In-Reply-To: <20210112213048.grqrqx4imgbypmdh@skbuf>
References: <20210112195405.12890-1-kabel@kernel.org>
        <20210112195405.12890-6-kabel@kernel.org>
        <20210112203808.4mkryi3tcut7mvz7@skbuf>
        <20210112221632.611c8a7e@kernel.org>
        <20210112213048.grqrqx4imgbypmdh@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 23:30:48 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Jan 12, 2021 at 10:16:32PM +0100, Marek Beh=C3=BAn wrote:
> > On Tue, 12 Jan 2021 22:38:08 +0200
> > Vladimir Oltean <olteanv@gmail.com> wrote:
> >  =20
> > > > +		phylink_set(mask, 10000baseT_Full);
> > > > +		phylink_set(mask, 10000baseCR_Full);
> > > > +		phylink_set(mask, 10000baseSR_Full);
> > > > +		phylink_set(mask, 10000baseLR_Full);
> > > > +		phylink_set(mask, 10000baseLRM_Full);
> > > > +		phylink_set(mask, 10000baseER_Full); =20
> > >=20
> > > Why did you remove 1000baseKR_Full from here? =20
> >=20
> > I am confused now. Should 1000baseKR_Full be here? 10g-kr is 10g-r with
> > clause 73 autonegotiation, so they are not compatible, or are they? =20
>=20
> ETHTOOL_LINK_MODE_10000baseKR_Full_BIT and most of everything else from
> enum ethtool_link_mode_bit_indices are network-side media interfaces
> (aka between the PHY and the link partner).
>=20
> Whereas PHY_INTERFACE_MODE_10GKR and most of everything else from
> phy_interface_t is a system-side media independent interface (aka
> between the MAC and the PHY).

OK that finaly clears things up :) Sorry, I misunderstood it: I thought
that PHY_INTERFACE_MODE_10GKR is related to 10000baseKR_Full and that
they are incompatible with 10gbase-r.

> What the 6393X does not support is PHY_INTERFACE_MODE_10GKR, and my
> feedback from your previous series did not ask you to remove
> 1000baseKR_Full from phylink_validate. There's nothing that would
> prevent somebody from attaching a PHY with a different (and compatible)
> system-side SERDES protocol, and 10GBase-KR on the media side.
>=20
> What Russell said is that he's seriously thinking about reworking the
> phylink_validate API so that the MAC driver would not need to sign off
> on things it does not care about (such as what media-side interface will
> the PHY use, of which there is an ever increasing plethora). But at the
> moment, the API is what it is, and you should put as many media-side
> link modes as possible, at the given speed and duplex that the MAC
> supports.
>=20
> _I_ am confused. What did you say you were happy to help with?

I am happy to help with phylink_validate code refactorization -
refactorization of the code itself, reviewing, testing.

Marek
