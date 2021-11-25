Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C218645E087
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349698AbhKYS27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 13:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhKYS07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 13:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AEC610A2;
        Thu, 25 Nov 2021 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637864627;
        bh=ZlwSPF9YaUYq+hdnBYTaMnkpHbVaRH7B4f4m2kzFXko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WUBs1GyIO4vSXkzKQGAyDEsBrVoJx2qOHxbFEZCRyFxXxzTo6zdkfXQtOmJQ9Tjdv
         ICQ+uVUbEn516shCq3N8xnTlEEIly1Z9rhPHxUNE7BIdvHAJc3JeIChFa5uH99Q1ds
         LFyvxAUmMJEqTokZJktenRlUD8b4dTrDi+WduUzi0vUR6qNRy5nlri4PAs2JxyMq31
         3D0b+8KVFg5SyqCmSJuLOBDaTz3KBP7vXJXVBrpnWXW2KAJXUCC7Z7e4cetWoL3xaj
         dunbf5UC+RdDb6XVu5r1aKPvyYOcb7tUplrUOYySgbLJlLNdyzFv8KzcutwkCSMjSd
         cFsj2PQSyGZVQ==
Date:   Thu, 25 Nov 2021 19:23:43 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Disable AN on 2500base-x for
 Amethyst
Message-ID: <20211125192343.20e19849@thinkpad>
In-Reply-To: <YZ/OV+ang2FW9phY@lunn.ch>
References: <20211125144359.18478-1-kabel@kernel.org>
        <YZ+txKp0sAOjQUka@lunn.ch>
        <20211125184551.2530cc95@thinkpad>
        <YZ/OV+ang2FW9phY@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 18:56:39 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Nov 25, 2021 at 06:45:51PM +0100, Marek Beh=C3=BAn wrote:
> > On Thu, 25 Nov 2021 16:37:40 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Thu, Nov 25, 2021 at 03:43:59PM +0100, Marek Beh=C3=BAn wrote: =20
> > > > Amethyst does not support autonegotiation in 2500base-x mode.   =20
> > >=20
> > > Hi Marek
> > >=20
> > > I tried to avoid using Marvells internal names for these devices. I
> > > don't think these names exist in the datasheet? They are visible in
> > > the SDK, but that is not so widely available. So if you do want to use
> > > these names, please also reference the name we use in the kernel,
> > > mv88e6393x. =20
> >=20
> > I used these names in previous commit that are already merged (search
> > for Amethyst, Topaz, Peridot). But if you want, I can send v2. Please
> > let me know if I should send v2. =20
>=20
> I'm not against these names, but i don't like them used on there own,
> thats all.
>=20
> > > What happens when changing from say 1000BaseX to 2500BaseX? Do you
> > > need to disable the advertisement which 1000BaseX might of enabled? =
=20
>=20
> >=20
> > I don't need to disable it, it is disabled on it's own by cmode change.=
 =20
>=20
> O.K, that is important information to put into the commit message,
> since it makes it clear you have thought about this, and a reviewer
> does not need to ask the question.
>=20
> > Moreover I did some experiments on 88E6393X vs 88E6190.
> >=20
> > It is a little weird for 6393x.
> >=20
> > On 6190
> > - resetting the SerDes (BMCR_RESET) does not have impact on the
> >   BMCR_ANENABLE bit, but changing cmode does
> >=20
> >   when cmode is changed to SGMII or 1000base-x, it is enabled, for
> >   2500base-x it is disabled
> >=20
> > - resetting the SerDes (BMCR_RESET) when cmode is
> >   - sgmii, changes value of the MV88E6390_SGMII_ADVERTISE to 0x0001
> >     automatically
> >   - 1000base-x or 2500base-x does not change the value of adv register
> >=20
> >   moreover it seems that changing cmode also resets the the SerDes
> >=20
> > On 6393x:
> > - the BMCR behaves the same as in 6190: the switch defaults to AN
> >   disabled for 2500base-x, and enabled for 1000base-x and SGMII
> >=20
> > - the difference is that there are weird values written to
> >   MV88E6390_SGMII_ADVERTISE on SerDes reset (which is done by switch
> >   when changing cmode)
> >=20
> >   for 1000base-x, the value is 0x9120
> >   for 2500base-x, the value is 0x9f41
> >=20
> >   I don't understand why they changed it so for 6393x. =20
>=20
> Tobias found something which might be relevant here. On the 6390
> family, if you change cmode while the SERDES is powered off, bad
> things happen. What you could be seeing is another symptom of
> that. Tobias has a WIP patch which changes the order of operations
> when changing the cmode. It would be interesting to see if that makes
> a difference here as well.

Thanks. I will try this tomorrow, both on 6190 and 6393x.

For now, ignore this patch.

Marek
