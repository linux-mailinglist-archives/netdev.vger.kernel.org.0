Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7652B42C49F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhJMPPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhJMPPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B36E96112D;
        Wed, 13 Oct 2021 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634138022;
        bh=mP/C5aXZgunfDcHPaOn4qeOvbqTnMAzEH6s5jmYe2/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qk5YcYx21pqRb+j6Y7+C+cVTysRuiw2gvJj1ldtnqpVL4hF8fgoa+Ufn2KNNuHu+5
         nhPzn9KAruQySibdsx5piuZUkUtmOCW3ZEMajFS+s5ssoiE5ay/l6A++atZSC8hWOM
         Yed4avj8KjPbHL9gRiUVCSRvt4IGELe7GIjo3c/OVly3A27aZ1Y7UELy0ODw8HWeHo
         7zP19ANV+K+JSmfIWUVKk9/3zrP9EvkOnfNM8QngkxWkQ9mwsbBJ5xz1MqWpNyvdm7
         nG39+R5eC3fEbnKE2YDiM0ZUHL+o5fzg40/PUxPg0qAYErpBGDyvzuVN1NO9usfQIA
         IGV12O2U3/lKg==
Date:   Wed, 13 Oct 2021 08:13:40 -0700
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
Message-ID: <20211013081340.0ca97db1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bde59012-8394-d31b-24c4-018cbfe0ed57@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
        <20211012123557.3547280-6-alvin@pqrs.dk>
        <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bde59012-8394-d31b-24c4-018cbfe0ed57@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 08:33:36 +0000 Alvin =C5=A0ipraga wrote:
> On 10/12/21 5:27 PM, Jakub Kicinski wrote:
> > On Tue, 12 Oct 2021 14:35:54 +0200 Alvin =C5=A0ipraga wrote: =20
> >> +	{ 0, 4, 2, "dot3StatsFCSErrors" },
> >> +	{ 0, 6, 2, "dot3StatsSymbolErrors" },
> >> +	{ 0, 8, 2, "dot3InPauseFrames" },
> >> +	{ 0, 10, 2, "dot3ControlInUnknownOpcodes" }, =20
> > ...
> >=20
> > You must expose counters via existing standard APIs.
> >=20
> > You should implement these ethtool ops: =20
>=20
> I implement the dsa_switch_ops callback .get_ethtool_stats, using an=20
> existing function rtl8366_get_ethtool_stats in the switch helper library=
=20
> rtl8366.c. It was my understanding that this is the correct way to=20
> expose counters within the DSA framework - please correct me if that is=20
> wrong.

It's the legacy way, today we have a unified API for reporting those
stats so user space SW doesn't have to maintain a myriad string matches
to get to basic IEEE stats across vendors. Driver authors have a truly
incredible ability to invent their own names for standard stats. It
appears that your pick of names is also unique :)

It should be trivial to plumb the relevant ethtool_ops thru to
dsa_switch_ops if relevant dsa ops don't exist.

You should also populate correct stats in dsa_switch_ops::get_stats64
(see the large comment above the definition of struct
rtnl_link_stats64 for mapping). A word of warning there, tho, that
callback runs in an atomic context so if your driver needs to block it
has to read the stats periodically from a async work.

> The structure you highlight is just some internal glue to sort out the=20
> internal register mapping. I borrowed the approach from the existing=20
> rtl8366rb.c Realtek SMI subdriver.

The callbacks listed below are relatively new, they may have not
existed when that driver was written. Also I may have missed it=20
in review.=20

> > 	void	(*get_eth_phy_stats)(struct net_device *dev,
> > 				     struct ethtool_eth_phy_stats *phy_stats);
> > 	void	(*get_eth_mac_stats)(struct net_device *dev,
> > 				     struct ethtool_eth_mac_stats *mac_stats);
> > 	void	(*get_eth_ctrl_stats)(struct net_device *dev,
> > 				      struct ethtool_eth_ctrl_stats *ctrl_stats);
> > 	void	(*get_rmon_stats)(struct net_device *dev,
> > 				  struct ethtool_rmon_stats *rmon_stats,
> > 				  const struct ethtool_rmon_hist_range **ranges);
