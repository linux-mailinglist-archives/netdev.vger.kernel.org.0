Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D509A403D85
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbhIHQWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245273AbhIHQWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 12:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0A560E77;
        Wed,  8 Sep 2021 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631118076;
        bh=F8+s4d8CkPkH5fXzRiiq7AaCyiaRECwjcMb3994hXZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=arhPQPgAueT66TWE3Yj+mpx0qCtQZhjwbZgi4wibJF1Vf/zMdU1r2zY/u/733bEZA
         gSXE50MRQQ0K5XHdrG2VvzbraOWAK/WKdMQARLPbsCDdI9bYoeL3LRFOx2AV0RPauV
         HAuU9z0lq6WJvxjlwmglLdZPimA4MV09yA3vBbBNMTcVyV5OfssI5jH3COsqvgRlwG
         laJXpAMO9ZPG7bTpTrDobfmgJ10wkPzZ2h+EcH8wQ7pH+6k5ljyjbk4jnChwWmPMRp
         3MhU/XmJP6p08Gw32gZQKdE8dIHFv0ujdlVHBi9nra2dZvomroyN3q/ghDsqrSm9Z0
         lMs8geGhkGtnQ==
Date:   Wed, 8 Sep 2021 09:21:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Sep 2021 08:03:35 +0000 Machnikowski, Maciej wrote:
> > > Yep! Yet let's go one step at a time. I believe once we have the basi=
cs (EEC
> > > monitoring and recovered clock configuration) we'll be able to implem=
ent
> > > a basic functionality - and add bells and whistles later on, as there=
 are more
> > > capabilities that we could support in SW. =20
> >=20
> > The set API may shape how the get API looks. We need a minimal viable
> > API where the whole control part of it is not "firmware or proprietary
> > tools take care of that".
> >=20
> > Do you have public docs on how the whole solution works? =20
>=20
> The best reference would be my netdev 0x15 tutorial:
> https://netdevconf.info/0x15/session.html?Introduction-to-time-synchroniz=
ation-over-Ethernet
> The SyncE API considerations starts ~54:00, but basically we need API for:
> - Controlling the lane to pin mapping for clock recovery
> - Check the EEC/DPLL state and see what's the source of reference frequen=
cy
> (in more advanced deployments)
> - control additional input and output pins (GNSS input, external inputs, =
recovered
>   frequency reference)

Thanks, good presentation! I haven't seen much in terms of system
design, at the level similar to the Broadcom whitepaper you shared.

> > > I believe this is the state-of-art: here's the Broadcom public one
> > > https://docs.broadcom.com/doc/1211168567832, I believe Marvel
> > > has similar solution. But would also be happy to hear others. =20
> >=20
> > Interesting. That reveals the need for also marking the backup
> > (/secondary) clock. =20
>=20
> That's optional, but useful. And here's where we need a feedback
> on which port/lane is currently used, as the switch may be automatic

What do you mean by optional? How does the user know if there is
fallback or not? Is it that Intel is intending to support only
devices with up to 2 ports and the second port is always the
backup (apologies for speculating).

> > Have you seen any docs on how systems with discreet PHY ASICs mux
> > the clocks? =20
>=20
> Yes - unfortunately they are not public :(

Mumble, mumble. Ido, Florian - any devices within your purview which
would support SyncE?=20

> > > Ethernet IP/PHY usually outputs a divided clock signal (since it's
> > > easier to route) derived from the RX clock.
> > > The DPLL connectivity is vendor-specific, as you can use it to connect
> > > some external signals, but you can as well just care about relying
> > > the SyncE clock and only allow recovering it and passing along
> > > the QL info when your EEC is locked. That's why I backed up from
> > > a full DPLL implementation in favor of a more generic EEC clock. =20
> >=20
> > What is an ECC clock? To me the PLL state in the Ethernet port is the
> > state of the recovered clock. enum if_eec_state has values like
> > holdover which seem to be more applicable to the "system wide" PLL. =20
>=20
> EEC is Ethernet Equipment Clock. In most cases this will be a DPLL, but t=
hat's
> not mandatory and I believe it may be different is switches where
> you only need to drive all ports TX from a single frequency source. In th=
is
> case the DPLL can be embedded in the multiport PHY,
> =20
> > Let me ask this - if one port is training the link and the other one has
> > the lock and is the source - what state will be reported for each port?=
 =20
>=20
> In this case the port that has the lock source will report the lock and=20
> the EEC_SRC_PORT flag. The port that trains the link will show the
> lock without the flag and once it completes the training sequence it will
> use the EEC's frequency to transmit the data so that the next hop is able
> to synchronize its EEC to the incoming RX frequency

Alright, I don't like that. It feels like you're attaching one object's
information (ECC) to other objects (ports), and repeating it. Prof
Goczy=C5=82a and dr Landowska would not be proud.

> > > The Time IP is again relative and vendor-specific. If SyncE is deploy=
ed
> > > alongside PTP it will most likely be tightly coupled, but if you only
> > > care about having a frequency source - it's not mandatory and it can =
be
> > > as well in the PHY IP. =20
> >=20
> > I would not think having just the freq is very useful. =20
>=20
> This depends on the deployment. There are couple popular frequencies
> Most popular are 2,048 kHz, 10 MHz and 64 kHz. There are many=20
> deployments that only require frequency sync without the phase
> and/or time. I.e. if you deploy frequency division duplex you only need t=
he
> frequency reference, and the higher frequency you have - the faster you c=
an
> lock to it.
