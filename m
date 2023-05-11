Return-Path: <netdev+bounces-1901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D014F6FF71E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE4F281777
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12C2613C;
	Thu, 11 May 2023 16:25:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5F20F6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98736C433D2;
	Thu, 11 May 2023 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683822341;
	bh=06seCnxly27EyiaGGijI3i97GSbsTnYLRg2ZYFTk9xE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=trF7S5o/M+Ap2cU6ZaKpWMiyA05g2ugJmk8Nt3aYPumDjCcJCDWwmT6Fr1yBGR4LD
	 jZtMCF1KQiLeO3RTiWYxIRGfei29mEwATWzSzmUeTg3JNChowzkHwFNaYk+smC6YAL
	 nmxniIFJsVYtbySKciNlVi8YRhP1PopnVE0/YEEHmGn+OH0H9vGwTERiAhmwutZvzh
	 x6HEoSIiQwyWYkm+S7T5AIUXqFwD3P3C3qfx3ZnEWAqc6ybjhoKKzD627pvLHkBk4q
	 uuqKpEL8BBvQq++0XNIDDZ3X/eEL/LAlZ8XQX/ZxY2IJYZ1FrVjhB+cetDrmuGPKXI
	 BvCNapyeLoKjQ==
Date: Thu, 11 May 2023 09:25:39 -0700
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
Message-ID: <20230511092539.5bbc7c6a@kernel.org>
In-Reply-To: <20230511155640.3nqanqpczz5xwxae@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 May 2023 18:56:40 +0300 Vladimir Oltean wrote:
> > More importantly "monolithic" drivers have DMA/MAC/PHY all under=20
> > the NDO so assuming that SOF_PHY_TIMESTAMPING implies a phylib PHY
> > is not going to work.
> >=20
> > We need a more complex calling convention for the NDO. =20
>=20
> It's the first time I become aware of the issue of PHY timestamping in
> monolithic drivers that don't use phylib, and it's actually a very good
> point. I guess that input gives a clearer set of constraints for K=C3=B6r=
y to
> design an API where the selected timestamping layer is maybe passed to
> ndo_hwtstamp_set() and MAC drivers are obliged to look at it.
>=20
> OTOH, a complaint about the current ndo_eth_ioctl() -> phy_mii_ioctl()
> code path was that phylib PHY drivers need to have the explicit blessing
> from the MAC driver in order to enable timestamping. This patch set
> attempts to circumvent that, and you're basically saying that it shouldn'=
t.

Yes, we don't want to lose the simplification benefit for the common
cases. I think we should make the "please call me for PHY requests"
an opt in.

Annoyingly the "please call me for PHY/all requests" needs to be
separate from "this MAC driver supports PHY timestamps". Because in
your example the switch driver may not in fact implement PHY stamping,
it just wants to know about the configuration.

So we need a bit somewhere (in ops? in some other struct? in output=20
of get_ts?) to let the driver declare that it wants to see all TS
requests. (I've been using bits in ops, IDK if people find that
repulsive or neat :))

Then if bit is not set or NDO returns -EOPNOTSUPP for PHY requests we
still try to call the PHY in the core?

Separately the MAC driver needs to be able to report what stamping=20
it supports (DMA, MAC, PHY, as mentioned in reply to patch 2).

