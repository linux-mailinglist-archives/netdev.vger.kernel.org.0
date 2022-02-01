Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181544A5EAC
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiBAOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:55:13 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:49613 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbiBAOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:55:12 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8860720000A;
        Tue,  1 Feb 2022 14:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643727310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wbdHYI1SSzsfrkur3P9CPNzzCnN5wxlGLkcwLujboyQ=;
        b=fjsdUmJ1rdplyj8IfHjf62TEeOv28eEv5OcWOZbW9bLCum8fLGSm3cGs97lOGBjKTOMLSM
        910RrK9RW+5mRHCleJeAtMj0MFyYgliyNSC3JoNSdPzUpsvxrzer/hoU1vxRUdth7aUZgw
        4KgaZA4CoCWpKxU8TyGiJ/2/Mqv/mE3NIyKfV0gY0TU55xkPysxO4H+JSx9kUv6Mo5tHFt
        UzTfaWEBy8AKjXDzBOzBuxZoFMRrFmvnhmMFlkF7uyeRlDk7Ze6MuFX87Y1TBnADm45PNw
        tx0m2YXZCjs8XgjBKxAZLDSUjWewzC8vSMIuihKJeLo2HB+88dBI/BXA55nZRA==
Date:   Tue, 1 Feb 2022 15:55:07 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
Message-ID: <20220201155507.549cd2e3@xps13>
In-Reply-To: <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-2-miquel.raynal@bootlin.com>
        <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
        <20220131152345.3fefa3aa@xps13>
        <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Mon, 31 Jan 2022 19:04:40 -0500:

> Hi,
>=20
> On Mon, Jan 31, 2022 at 9:23 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:35:35 -0500:
> > =20
> > > Hi,
> > >
> > > On Fri, Jan 28, 2022 at 6:08 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > The idea here is to create a structure per set of channels so that =
we
> > > > can define much more than basic bitfields for these.
> > > >
> > > > The structure is currently almost empty on purpose because this cha=
nge
> > > > is supposed to be a mechanical update without additional informatio=
n but
> > > > more details will be added in the following commits.
> > > > =20
> > >
> > > In my opinion you want to put more information in this structure which
> > > is not necessary and force the driver developer to add information
> > > which is already there encoded in the page/channel bitfields. =20
> >
> > The information I am looking forward to add is clearly not encoded in
> > the page/channel bitfields (these information are added in the
> > following patches). At least I don't see anywhere in the spec a
> > paragraph telling which protocol and band must be used as a function of
> > the page and channel information. So I improved the way channels are
> > declared to give more information than what we currently have.
> > =20
>=20
> This makes no sense for me, because you are telling right now that a
> page/channel combination depends on the transceiver.

That is exactly what I meant, and you made me realize that I overlooked
that information from the spec.

> > BTW I see the wpan tools actually derive the protocol/band from the
> > channel/page information and I _really_ don't get it. I believe it only
> > works with hwsim but if it's not the case I would like to hear
> > more about it.
> > =20
>=20
> No, I remember the discussion with Christoffer Holmstedt, he described
> it in his commit message "8.1.2 in IEEE 802.15.4-2011".
> See wpan-tools commit 0af3e40bbd6da60cc000cfdfd13b9cdd8a20d717 ("info:
> add frequency to channel listing for phy capabilities").
>=20
> I think it is the chapter "Channel assignments"?

Oh yeah, now I get it. It's gonna be much simpler than what I thought.

In the 2020 spec this is =C2=A7 "10.1.3 Channel assignments".

> > > Why not
> > > add helper functionality and get your "band" and "protocol" for a
> > > page/channel combination? =20
> >
> > This information is as static as the channel/page information, so why
> > using two different channels to get it? This means two different places
> > where the channels must be described, which IMHO hardens the work for
> > device driver writers.
> > =20
>=20
> device drivers writers can make mistakes here, they probably can only
> set page/channel registers in their hardware and have no idea about
> other things.
>=20
> > I however agree that the final presentation looks a bit more heavy to
> > the eyes, but besides the extra fat that this change brings, it is
> > rather easy to give the core all the information it needs in a rather
> > detailed and understandable way. =20
>=20
> On the driver layer it should be as simple as possible. If you want to
> have a static array for that init it in the phy register
> functionality, however I think a simple lookup table should be enough
> for that.

Given the new information that I am currently processing, I believe the
array is not needed anymore, we can live with a minimal number of
additional helpers, like the one getting the PRF value for the UWB
PHYs. It's the only one I have in mind so far.

> To make it more understandable I guess some people can introduce some
> defines/etc to make a more sense behind setting static hex values.

I'll propose a new approach soon.

Thanks,
Miqu=C3=A8l
