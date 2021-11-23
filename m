Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF4245A245
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhKWMPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235080AbhKWMPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:15:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A6761053;
        Tue, 23 Nov 2021 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637669532;
        bh=NxaUvh5kTsuhOi+PO+o1atHCozlaNhl4QD+pKqwweCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uf6fGNuiTMkrCD96F8WnPHY5/GdOcUISXG0B6Vx6QLvX+IYDekj+6XtG6vSZCo34W
         sf+dLDg83FiOPRCad39h7OqXfukdygFKb3V0yFK4smJV3Qa4Z22vrEq3ho2U9V/8rC
         /U6x5EcayWTcgBEWCB3STSWVWB40/ulblr2E9zQCxeEUFi8VnRiFcQqRluf/QwMm1T
         JXCU1LX/cGvvyzH23nRgWLfUo3vZ5rI5xG9uKwny9+rq8nW7hS3kfJCjIy2Ochih+w
         tZZN5Hxy9pqcI1DPisliOzkvQ23pAyGQGjPxsYf/68nRMcuXJD5BhvLaLj7wDN4i6H
         w2T0fdOpaRaxA==
Date:   Tue, 23 Nov 2021 13:12:08 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Subject: Re: [PATCH net 1/2] net: phylink: Force link down and retrigger
 resolve on interface change
Message-ID: <20211123131208.76919fcd@thinkpad>
In-Reply-To: <YZzOmzAAQcLnpuPl@shell.armlinux.org.uk>
References: <20211122235154.6392-1-kabel@kernel.org>
        <20211122235154.6392-2-kabel@kernel.org>
        <YZzOmzAAQcLnpuPl@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 11:20:59 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Nov 23, 2021 at 12:51:53AM +0100, Marek Beh=C3=BAn wrote:
> > On PHY state change the phylink_resolve() function can read stale
> > information from the MAC and report incorrect link speed and duplex to
> > the kernel message log.
> >=20
> > Example with a Marvell 88X3310 PHY connected to a SerDes port on Marvell
> > 88E6393X switch:
> > - PHY driver triggers state change due to PHY interface mode being
> >   changed from 10gbase-r to 2500base-x due to copper change in speed
> >   from 10Gbps to 2.5Gbps, but the PHY itself either hasn't yet changed
> >   its interface to the host, or the interrupt about loss of SerDes link
> >   hadn't arrived yet (there can be a delay of several milliseconds for
> >   this), so we still think that the 10gbase-r mode is up
> > - phylink_resolve()
> >   - phylink_mac_pcs_get_state()
> >     - this fills in speed=3D10g link=3Dup
> >   - interface mode is updated to 2500base-x but speed is left at 10Gbps
> >   - phylink_major_config()
> >     - interface is changed to 2500base-x
> >   - phylink_link_up()
> >     - mv88e6xxx_mac_link_up()
> >       - .port_set_speed_duplex()
> >         - speed is set to 10Gbps
> >     - reports "Link is Up - 10Gbps/Full" to dmesg
> >=20
> > Afterwards when the interrupt finally arrives for mv88e6xxx, another
> > resolve is forced in which we get the correct speed from
> > phylink_mac_pcs_get_state(), but since the interface is not being
> > changed anymore, we don't call phylink_major_config() but only
> > phylink_mac_config(), which does not set speed/duplex anymore.
> >=20
> > To fix this, we need to force the link down and trigger another resolve
> > on PHY interface change event.
> >=20
> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org> =20
>=20
> I'm pretty sure someone will highlight that the author of the patch
> should be the first sign-off - which doesn't match given the way
> you've sent this patch. That probably needs fixing before it's
> applied.
>=20

Hmm. Well you're the author of the patch, I only wrote the commit
message. But I forgot to change --author in git commit. I shall resend
this.

Marek
