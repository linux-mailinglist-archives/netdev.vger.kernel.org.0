Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44553294DEB
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443053AbgJUNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 09:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439375AbgJUNs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 09:48:56 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC0F320BED;
        Wed, 21 Oct 2020 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603288136;
        bh=wKz6VSXPsXIpttnDsu+YSPFaEGwFcBhD3w/+J2DjKpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2OGR+lkaqaOlKkjVOwJz1cQRaOqsrPPIb0NmLh5au99+GwE1sCR6rCHN88ARrSwUx
         M/seOgYfkp482zqJH6FdW4gqG2gsIYM9kwb2lsaEpOjP0j+D+2OgdylihPTuKlqPj/
         lmNSe6/PaTLc8Ix/VSr8tMgNNTjHxNE7ldILSrVw=
Date:   Wed, 21 Oct 2020 15:48:49 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: russell's net-queue question
Message-ID: <20201021154849.4fe667de@kernel.org>
In-Reply-To: <20201020154514.GE1551@shell.armlinux.org.uk>
References: <20201020171539.27c33230@kernel.org>
        <20201020154514.GE1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 16:45:15 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Oct 20, 2020 at 05:15:39PM +0200, Marek Beh=C3=BAn wrote:
> > Russell,
> >=20
> > I think the following commits in your net-queue should be still made be=
tter:
> >=20
> > 7f79709b7a15 ("net: phy: pass supported PHY interface types to phylib")
> > eba49a289d09 ("net: phy: marvell10g: select host interface configuratio=
n")
> >=20
> > http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=3Dnet-queue&id=
=3Deba49a289d0959eab3dfbc0320334eb5a855ca68
> > http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=3Dnet-queue&id=
=3Deba49a289d0959eab3dfbc0320334eb5a855ca68
> >=20
> > The first one adds filling of the phydev->host_interfaces bitmap into
> > the phylink_sfp_connect_phy function. It should also fill this bitmap
> > in functions phylink_connect_phy and phylink_of_phy_connect (direct
> > copy of pl->config->supported_interfaces). =20
>=20
> First, the whole way interfaces are handled is really not good, even
> with the addition of the interfaces bitmap. However, it tries to solve
> at least some of the issues.
>=20
> Secondly, what should we fill this in with?
>=20
> Do we fill it with the firmware specified phy-mode setting? Or all the
> capabilities of the network driver's interface? What if the network
> driver supports RGMII/SGMII/10GBASE-R/etc but not all of these are
> wired?
>=20
> We really don't want the PHY changing what was configured via hardware
> when it's "built in", because it's ambiguous in a very many situations
> which mode should be selected. If we take the view that the firmware
> specified phy-mode should only be specified, then the 88X3310 will
> switch to MACTYPE=3D6 instead of 4 on the Macchiatobin, which is the rate
> adaption mode - and this will lead to lost packets (it's a plain
> 88X3310 without the MACSEC, so the PHY is not capable of generating
> flow control packets to pace the host.)
>=20

I was thinking about filling it with all interfaces supported by that
device (which, I confess, I meant to be all interfaces supported by the
SOC). You are right though that this is problematic, at least because
some of the pins will not be connected at all... And I guess it would be
overkill if devicetree had to specify all interfaces.

Although... maybe we could start interpreting the phy-mode from DT (for
SFP ports) as max supported mode. Because there may be boards with SOCs
where mac driver supports, for example, all of USXGMII, 10gbase-r,
5gbase-r, 2500base-x, 1000base-x. But the board was certified only up
to 5gbase-r, for FCC purposes, or maybe there is a connector
somewhere that guarantees only 5 GHz...

> > The reason is that phy devices may want to know what interfaces are
> > supported by host even if no SFP is used (Marvell 88X3310 is an exmaple
> > of this). =20
>=20
> If a SFP is not being used, then the connectivity is described via DT
> and the hardware configuration of the PHY (which we rely on for the
> 88X3310.) I don't see much of a solution to that for the 88X3310.
> If DT describes the interface mode as 10gbase-r, then that ambiguously
> could refer to MACTYPE=3D4,5,6 - the driver can't know.
>=20
> So, I don't think there is a simple answer here.
>=20
> > The second patch (adding mactype selection to marvell10g) can get rid
> > of the rate matching code, and also
> > should update the mv3310_update_interface code accordignly.
> >=20
> > Should I sent you these patches updated or should I create new patches
> > on top of yours? =20
>=20
> These are experimental, and for the reasons I mention above, they
> need careful thought.
>=20

Very well, I think you are right.

BTW, I also sent yesterday some patches for your net-queue branch
(they are tagged "russell-kings-net-queue"). What do you think about
those?

Also the way marvell10g is in your net-queue may break 88E2110
currently. I have a device with this card, I shall look into this and
maybe send you a patch for this.

Marek
