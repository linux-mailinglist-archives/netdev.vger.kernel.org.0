Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE58348578
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhCXXpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhCXXpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF7261A17;
        Wed, 24 Mar 2021 23:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616629529;
        bh=WDsmT8Fwstw8a7xa0MI7gnuC2c1vDqVBBCjJ9FULubI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZVNm2f9+ISvF4h0Bc9epTyUO1te47dx3H+d375kpjBUkifrvERk91TagWzs++aXEW
         /GL7gbdNotGcnFTT5GNCWSqzrVfW+JGGzvpT7JJBbHKuzaeBQt69DKUTd1+lRncYG0
         PUOBdclVRODU2PswE2YMYc9Jd0vw4ydb4US0lyN0k9yKVUZVLVH01R70nIhSP/yHTq
         EuyXdRjG65XvQxWyCT6R3CGnS2G7H+AYcUXWNmvBbouiB510srB6wsmw3fJO18YWka
         2zH++fDzJcdKeqGQvaGMmaXni6AUSIoUpq3D0YmyX2vo7XmwIgAYOQkhPyuzA8fnr6
         aEM9ouiyDahrg==
Date:   Thu, 25 Mar 2021 00:45:25 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
Message-ID: <20210325004525.734f3040@thinkpad>
In-Reply-To: <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
References: <20210324103556.11338-1-kabel@kernel.org>
        <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
        <20210325000007.19a38bce@thinkpad>
        <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 16:16:41 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 3/24/2021 4:00 PM, Marek Beh=C3=BAn wrote:
> > On Wed, 24 Mar 2021 14:19:28 -0700
> > Florian Fainelli <f.fainelli@gmail.com> wrote:
> >  =20
> >>> Another problem is that if lower modes are supported, we should
> >>> maybe use them in order to save power.   =20
> >>
> >> That is an interesting proposal but if you want it to be truly valuabl=
e,
> >> does not that mean that an user ought to be able to switch between any
> >> of the supported PHY <=3D> MAC interfaces at runtime, and then within
> >> those interfaces to the speeds that yield the best power savings? =20
> >=20
> > If the code determines that there are multiple working configurations,
> > it theoretically could allow the user to switch between them.
> >=20
> > My idea was that this should be done by kernel, though.
> >=20
> > But power saving is not the main problem I am trying to solve.
> > What I am trying to solve is that if a board does not support all modes
> > supported by the MAC and PHY, because they are not wired or something,
> > we need to know about that so that we can select the correct mode for
> > PHYs that change this mode at runtime. =20
>=20
> OK so the runtime part comes from plugging in various SFP modules into a
> cage but other than that, for a "fixed" link such as a SFF or a soldered
> down PHY, do we agree that there would be no runtime changing of the
> 'phy-mode'?

No, we do not. The PHY can be configured (by strapping pins or by
sw) to change phy-mode depending on the autonegotiated copper speed.

So if you plug in an ethernet cable where on the otherside is only 1g
capable device, the PHY will change mode to sgmii. But if you then plug
a 5g capable device, the PHY will change mode to 5gbase-r.

This happens if the PHY is configured into one of these changing
configurations. It can also be configured to USXGMII, or 10GBASER with
rate matching.

Not many MACs in kernel support USXGMII currently.

And if you use rate matching mode, and the copper side is
linked in lower speed (2.5g for example), and the MAC will start
sending too many packets, the internal buffer in the PHY is only 16 KB,
so it will fill up quickly. So you need pause frames support. But this
is broken for speeds <=3D 1g, according to erratum.

So you really want to change modes. The rate matching mode is
basically useless.

>=20
> What I am trying to understand is why this needs to be added to the
> Device Tree as opposed to a bitmask within the PHY driver that indicates
> the various interface mode capabilities which, looking at the code you
> shared below, is how you make decisions ultimately.

Because someone can create a board with a SOC where MAC is capable of
all of the following modes: 10gbase-r, xaui, rxaui, 5gbase-r,
2.5gbase-x, sgmii.

And use Marvell 88X3310 PHY to translate to copper.

But only wire the PHY to the MAC with one SerDes lane. So for 10g,
10gbase-r mode must be used, xaui and rxaui cannot.
Or wire the PHY to the MAC with 2 SerDes lanes, but both lanes capable
only of 6 GHz freq. So for 10g, rxaui must be used.

And then make the mistake of wiring the strapping pins to the
rate-matching mode, which is useless.

So we need to know which modes are supported if we want to change the
configuration to a working one.

> >  =20
> >>>
> >>> But for this we need to know which phy-modes are supported on the
> >>> board.
> >>>
> >>> This series adds documentation for a new ethernet PHY property,
> >>> called `supported-mac-connection-types`.   =20
> >>
> >> That naming does not quite make sense to me, if we want to describe the
> >> MAC supported connection types, then those would naturally be within t=
he
> >> Ethernet MAC Device Tree node, no? If we are describing what the PHY is
> >> capable, then we should be dropping "mac" from the property name not to
> >> create confusion. =20
> >=20
> > I put "mac" there to indicate that this is the SerDes to the MAC (i.e.
> > host side in Marvell PHY). 88X3310 has another SerDes side (Fiber Side).
> > I guess I put "mac" there so that if in the future we wanted to specify
> > supported modes for the fiber side, we could add
> > `supported-fiber-connection-types`. =20
>=20
> You would traditionally find the words "line side" (copper, optical,
> etc.) and "MAC side" being used in datasheets, maybe you can use a
> similar naming here?

So
  supported-connection-types-mac-side
  supported-connection-types-line-side
or maybe media-side?

I am still exploring whether this could be simply defined in the
ethernet controllers `phy-mode` property, as Rob Herring says. It would
be simpler...

Marek
