Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7A42DB22
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhJNOKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhJNOKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209BF610A0;
        Thu, 14 Oct 2021 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634220490;
        bh=D0kIMpPplXpp37Gh0tOmiNC+vZqJTD00gQ8fpi5NP1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VxiRiJNs1di0hnfqTQfezhICJ6DFPuhn+4LCHaybprPQL1ccfr5k+pjOanaqq/Ro1
         Z+L1SqtxyTSSSvgO1BShU959kscT0F9Dup5iJYHk6bNFakJdKxVLmX3RIxg8o0lGd7
         xPJW4bv+PEpVutGchFm0DMOlBEIF4EzsCbQHl3MGtBHq3RITUHzlG6meTMIfqKq0PH
         0xHCl/OUiCGA19/hda/V41fLe4ErDMmZwCWvUp0w9VVy7WJ9hvSaxu4unFFyOMfrB5
         Fjq7pju3gK71nooJ1XF+kySjX9PoHdx43dclswMhBgupzmoWLqmKrJS2yszulsdINs
         i3etWyYjqehPg==
Date:   Thu, 14 Oct 2021 07:08:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211014070809.6ca397ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <80c80992-85c2-d971-ce1c-a37f8199da7a@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
        <20211012123557.3547280-6-alvin@pqrs.dk>
        <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bde59012-8394-d31b-24c4-018cbfe0ed57@bang-olufsen.dk>
        <20211013081340.0ca97db1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <80c80992-85c2-d971-ce1c-a37f8199da7a@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 12:44:37 +0000 Alvin =C5=A0ipraga wrote:
> On 10/13/21 5:13 PM, Jakub Kicinski wrote:
> > On Wed, 13 Oct 2021 08:33:36 +0000 Alvin =C5=A0ipraga wrote: =20
> >> I implement the dsa_switch_ops callback .get_ethtool_stats, using an
> >> existing function rtl8366_get_ethtool_stats in the switch helper libra=
ry
> >> rtl8366.c. It was my understanding that this is the correct way to
> >> expose counters within the DSA framework - please correct me if that is
> >> wrong. =20
> >=20
> > It's the legacy way, today we have a unified API for reporting those
> > stats so user space SW doesn't have to maintain a myriad string matches
> > to get to basic IEEE stats across vendors. Driver authors have a truly
> > incredible ability to invent their own names for standard stats. It
> > appears that your pick of names is also unique :)
> >=20
> > It should be trivial to plumb the relevant ethtool_ops thru to
> > dsa_switch_ops if relevant dsa ops don't exist.
> >=20
> > You should also populate correct stats in dsa_switch_ops::get_stats64
> > (see the large comment above the definition of struct
> > rtnl_link_stats64 for mapping). A word of warning there, tho, that
> > callback runs in an atomic context so if your driver needs to block it
> > has to read the stats periodically from a async work. =20
>=20
> OK, so just to clarify:
>=20
> - get_ethtool_stats is deprecated - do not use

It can still be used, but standardized interfaces should be preferred
whenever possible, especially when appropriate uAPI already exists.

> - get_eth_{phy,mac,ctrl,rmon}_stats is the new API - add DSA plumbing=20
> and use this

Yup.

> - get_stats64 orthogonal to ethtool stats but still important - use also=
=20
> this

Yes, users should be able to depend on basic interface stats (packets,
bytes, crc errors) to be correct.

> For stats64 I will need to poll asynchronously - do you have any=20
> suggestion for how frequently I should do that? I see one DSA driver=20
> doing it every 3 seconds, for example.

3 sec seems fine.
