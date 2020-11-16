Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE22B4A1C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgKPP4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731570AbgKPP4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:56:42 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10349207BC;
        Mon, 16 Nov 2020 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605542201;
        bh=bWh2Dapa6/yK7B0Ixn8loQtOY//z1lehMCkD06ZXbOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ajvNsGpiH8yvYzL8YKfXF+cBBwWytGDACmzJVTd078FL5WQrcTWktcfWE8GTFwEyM
         96mnkJaj8UAzmdrN6Q5u1elYWdZ+4bFEVZ57yVx0osyhV0bsYqcsYNYHTtRPerUkmi
         CGpDVPREWeSHLA39dGv++ePvg50LeDH1Re4/SJ2E=
Date:   Mon, 16 Nov 2020 16:56:34 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 4/5] net: phy: marvell10g: change MACTYPE if
 underlying MAC does not support it
Message-ID: <20201116165634.5a5bb2e0@kernel.org>
In-Reply-To: <20201116150216.GK1551@shell.armlinux.org.uk>
References: <20201116111511.5061-1-kabel@kernel.org>
        <20201116111511.5061-5-kabel@kernel.org>
        <20201116154552.5a1e4b02@kernel.org>
        <20201116150216.GK1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:02:16 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Mon, Nov 16, 2020 at 03:45:52PM +0100, Marek Beh=C3=BAn wrote:
> > Hi Russell,
> >=20
> > previously you replied on this patch:
> >  =20
> > > This'll do as a stop-gap until we have a better way to determine which
> > > MACTYPE mode we should be using. =20
> >=20
> > Can we consider this as Acked-by ? =20
>=20
> Not really.
>=20
> The selection of MACTYPE isn't as simple as you make out in this patch.

Hi Russell,

I know that. The idea behind this patch is to add support for at least
something (for MACs supporting 1G/2.5G, but not 10G) in a simple way.
Full support can be added later, since it requires changes into other
subsystems (the experimental patches in your repo).

The question therefore IMO is whether this will introduce regression or
not.

> If we know that the MAC supports 2500BASE-X and/or SGMII, that means
> MACTYPES 0, 3, 4, 5 are possible to fit that, all likely will work if
> we restrict the PHY to either 2.5G only or 1G..10M only. However, it
> only becomes important if the faster speeds are supported at the MAC.

OK, but by applying this patch a regression could possibly occur only
if (and shouldn't anyway, see below):
- MAC supports 10G mode, but only XAUI/RXAUI, not XFI
- mactype is by default set to 1 (XAUI with rate matching) or 2 (RXAUI
  with rate matching) or 7 (USXGMII)
- before config_init, phydev->interface mode is 2500base-x or sgmii

The question is whether someone uses such a configuration and expects
the PHY driver to change phydev->interface.

Anyway a regression should not occur anyway (i.e. this patch should't
break something that did work previously), because even if XAUI/RXAUI
with rate matching or USXGMII was selected by default on the PHY, the
mv3310_update_interface does not support this modes currently
(only 10gbase-r, 2500base-x and sgmii).

So unless the MAC driver ignores the changed phydev->interface, this
patch should not break anything.

If it does cause a regression in spite of the points above, we can
condition the mactype change to occur only if the mactype before the
change was 6 (XFI with rate matching).
Or map the change like so:
  1 -> 3   XAUI with RM ->  XAUI/5gbase-r/2500base-x/SGMII
  2 -> 0  RXAUI with RM -> RXAUI/5gbase-r/2500base-x/SGMII
  6 -> 4    XFI with RM ->   XFI/5gbase-r/2500base-x/SGMII

I can put these thought into the commit message, if requested.

> I'm afraid I haven't put much thought into how to solve it, and as I'm
> totally demotivated at the moment, that's unlikely to change.

I am sorry to hear that, Russell :-(

Usually for me a lack of motivation is caused by bad mood (and also
vice-versa, so this can result in a self-feeding loop).

What I found that helps me with this is a good book to read.
If you are open to suggestions, the (IMO) best book I ever read is
Harry Potter and the Methods of Rationality (it's for free and online).

Marek
