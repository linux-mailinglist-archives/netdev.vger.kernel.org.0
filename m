Return-Path: <netdev+bounces-1974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0A76FFCF7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A66F281740
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B334174F0;
	Thu, 11 May 2023 23:08:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F193FE3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8391BC433D2;
	Thu, 11 May 2023 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683846527;
	bh=onc2eTqpF1QTWiN9tPcHZRCZCXL/LiRFls1M/UxLEDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nwb5zq3DJOz9eTa5PgvbUxdNniCtdw6JC60yIBEUIkr/Tisy+beRXJiJ5MyVS0gj+
	 GylakY8iiu2meWT32gXmNm3azyCegkzYngmuS170Ki1ahIdw0ONRb5qOfkWm/iGkf8
	 eY5lSpKVQzaAK3EVdWhcAA9rKE7e9a0WD+/KgVr/ZaZIF8/zX3PykMfFriWKQcyzCG
	 ezY0ulG0Sk5rap0U/U3gZVxm68noyQLBCfMDEYYSEAzTsEGFo5IxrbKfaBmTSgqZ8j
	 un67tcJwOAtoZhYkH0x1TiHEYaDiUubMbN5mjLCf5PhKDtW2swF6euz5uXO/QrFNOE
	 jfEwjXBoCRyTA==
Date: Thu, 11 May 2023 16:08:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
 netdev@vger.kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
 krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
 linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511160845.730688af@kernel.org>
In-Reply-To: <20230511205435.pu6dwhkdnpcdu3v2@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
	<20230511092539.5bbc7c6a@kernel.org>
	<20230511205435.pu6dwhkdnpcdu3v2@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 May 2023 23:54:35 +0300 Vladimir Oltean wrote:
> On Thu, May 11, 2023 at 09:25:39AM -0700, Jakub Kicinski wrote:
> > > It's the first time I become aware of the issue of PHY timestamping in
> > > monolithic drivers that don't use phylib, and it's actually a very go=
od
> > > point. I guess that input gives a clearer set of constraints for K=C3=
=B6ry to
> > > design an API where the selected timestamping layer is maybe passed to
> > > ndo_hwtstamp_set() and MAC drivers are obliged to look at it.
> > >=20
> > > OTOH, a complaint about the current ndo_eth_ioctl() -> phy_mii_ioctl()
> > > code path was that phylib PHY drivers need to have the explicit bless=
ing
> > > from the MAC driver in order to enable timestamping. This patch set
> > > attempts to circumvent that, and you're basically saying that it shou=
ldn't. =20
> >=20
> > Yes, we don't want to lose the simplification benefit for the common
> > cases. =20
>=20
> While I'm all for simplification in general, let's not take that for
> granted and see what it implies, first.
>=20
> If the new default behavior for the common case is going to be to bypass
> the MAC's ndo_hwtstamp_set(), then MAC drivers which didn't explicitly
> allow phylib PHY timestamping will now do.
>=20
> Let's group them into:
>=20
> (A) MAC drivers where that is perfectly fine
>=20
> (B) MAC drivers with forwarding offload, which would forward/flood PTP
>     frames carrying PHY timestamps
>=20
> (C) "solipsistic" MAC drivers which assume that any skb with
>     SKBTX_HW_TSTAMP is a skb for *me* to timestamp
>=20
> Going for the simplification would mean making sure that cases (B)
> and (C) are well handled, and have a reasonable chance of not getting
> reintroduced in the future.
>=20
> For case (B) it would mean patching all existing switch drivers which
> don't allow PHY timestamping to still not allow PHY timestamping, and
> fixing those switch drivers which allow PHY timestamping but don't set
> up traps (probably those weren't tested in a bridging configuration).
>=20
> For case (C) it would mean scanning all MAC drivers for bugs akin to the
> one fixed in commit c26a2c2ddc01 ("gianfar: Fix TX timestamping with a
> stacked DSA driver"). I did that once, but it was years ago and I can't
> guarantee what is the current state or that I didn't miss anything.
> For example, I missed the minor fact that igc would count skbs
> timestamped by a non-igc entity in its TX path as 'tx_hwtstamp_skipped'
> packets, visible in ethtool -S:
> https://lore.kernel.org/intel-wired-lan/20230504235233.1850428-2-vinicius=
.gomes@intel.com/
>=20
> It has to be said that nowadays, Documentation/networking/timestamping.rst
> does warn about stacked PHCs, and those who read will find it. Also,
> ptp4l nowadays warns if there are multiple TX timestamps received for
> the same skb, and that's a major user of this functionality. So I don't
> mean to point this case out as a form of discouragement, but it is going
> to be a bit of a roll of dice.

I think it's worth calling out that we may be touching most / all
drivers anyway to transition them from the IOCTL NDO to a normal
timestamp NDO.

> The alternative (ditching the simplification) is that someone still
> has to code up the glue logic from ndo_hwtstamp_set() -> phy_mii_ioctl(),
> and that presumes some minimal level of testing, which we are now
> "simplifying" away.
>=20
> The counter-argument against ditching the simplification is that DSA
> is also vulnerable to the bugs from case (C), but as opposed to PHY
> timestamping where currently MACs need to voluntarily pass the
> phy_mii_ioctl() call themselves, MACs don't get to choose if they want
> to act as DSA masters or not. That gives some more confidence that bugs
> in this area might not be so common, and leaves just (B) a concern.
>=20
> To analyze how common is the common case is a simple matter of counting
> how many drivers among those with SIOCSHWTSTAMP implementations also
> have some form of forwarding offload, OR, as you point out, how many
> don't use phylib.

"Common" is one way of looking at it, another is trying to get the
default ("I didn't know I have to set extra flags") to do the right
thing or fail.

> > I think we should make the "please call me for PHY requests" an opt in.
> >=20
> > Annoyingly the "please call me for PHY/all requests" needs to be
> > separate from "this MAC driver supports PHY timestamps". Because in
> > your example the switch driver may not in fact implement PHY stamping,
> > it just wants to know about the configuration.
> >=20
> > So we need a bit somewhere (in ops? in some other struct? in output=20
> > of get_ts?) to let the driver declare that it wants to see all TS
> > requests. (I've been using bits in ops, IDK if people find that
> > repulsive or neat :)) =20
>=20
> It's either repulsive or neat, depending on the context.
>=20
> Last time you suggested something like this in an ops structure was IIRC
> something like whether "MAC Merge is supported". My objection was that
> DSA has a common set of ops structures (dsa_slave_ethtool_ops,
> dsa_slave_netdev_ops) behind which lie different switch families from
> at least 13 vendors. A shared const ops structure is not an appropriate
> means to communicate whether 13 switch vendors support a TSN MAC Merge
> layer or not.
>=20
> With declaring interest in all hardware timestamping requests in the
> data path of a MAC, be they MAC-level requests or otherwise, it's a bit
> different, because all DSA switches have one thing in common, which is
> that they're switches, and that is relevant here. So I'm not opposed to
> setting a bit in the ethtool ops structure, at least for DSA that could
> work just fine.
>=20
> > Then if bit is not set or NDO returns -EOPNOTSUPP for PHY requests we
> > still try to call the PHY in the core? =20
>=20
> Well, if there is no interest for special behavior from the MAC driver,
> then I guess the memo is "yolo"...
>=20
> But OTOH, if a macro-driver like DSA declares its interest in receiving
> all timestamping requests, but then that particular DSA switch returns
> -EOPNOTSUPP in the ndo_hwtstamp_set() handler, it would be silly for the
> core to still "force the entry" and call phy_mii_ioctl() anyway - because
> we know that's going to be broken.
>=20
> So with "NDO returns -EOPNOTSUPP", I hope you don't mean *that* NDO
> (ndo_hwtstamp_set()) but a previously unnamed one that serves the same
> purpose as the capability bit - ndo_hey_are_you_interested_in_this_hwtsta=
mp_request().
> In that case, yes - with -EOPNOTSUPP we're back to "yolo".

Why can't we treat ndo_hwtstamp_set() =3D=3D -EOPNOTSUPP as a signal=20
to call the PHY? ndo_hwtstamp_set() does not exist, we can give
it whatever semantics we want.

> > Separately the MAC driver needs to be able to report what stamping=20
> > it supports (DMA, MAC, PHY, as mentioned in reply to patch 2). =20
>=20
> I'm a bit unclear on that - responded there.

