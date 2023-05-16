Return-Path: <netdev+bounces-3098-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B75D705715
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C77502812B9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E883729112;
	Tue, 16 May 2023 19:28:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231092910E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752EFC433EF;
	Tue, 16 May 2023 19:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684265299;
	bh=L1GD5QocH3Jsn+cIrib37lJSxVsOZOvF1CQcmEbnCAE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YQV8LPLi54T6NgAYucibmfiqndW/o67vs6lMxUqomdGc10WDIEGCzXa/l/Zt4ksox
	 Nz6veRH38kEYu7CkNQ0tSET0b7rzeQi7BgQuW7VD8WoV/33ktRpmPXR3s1ot6SXSg7
	 s8DF1Ra1UvX66YTTGnlCVHqCGcg2I89GxXPQiqDb707vEzsdoq1VqQGjhWjgYSh5Qh
	 VpeF/orscghewUQLYBDAzOitzTIvSVZ/JR/Rg5QuoG4HAoInxq1p0rFZQ7tVGA7tLC
	 5rTBH9xo2vb6EHVisRounpeRyQVgPBJH6jETUwgGUYZevycV+tIfG3MoRmFL2GHTBm
	 0ZSgFLbeAXnqA==
Date: Tue, 16 May 2023 12:28:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
 glipus@gmail.com, maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230516122818.1c3ff97b@kernel.org>
In-Reply-To: <20230515110432.63b94557@kmaincent-XPS-13-7390>
References: <20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
	<20230511092539.5bbc7c6a@kernel.org>
	<20230511205435.pu6dwhkdnpcdu3v2@skbuf>
	<20230511160845.730688af@kernel.org>
	<20230511231803.oylnku5iiibgnx3z@skbuf>
	<20230511163547.120f76b8@kernel.org>
	<20230515110432.63b94557@kmaincent-XPS-13-7390>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 15 May 2023 11:04:32 +0200 K=C3=B6ry Maincent wrote:
> > I see, so there is a legit reason to abort.=20
> >=20
> > We could use one of the high error codes, then, to signal=20
> > the "I didn't care, please carry on to the PHY" condition?
> > -ENOTSUPP?
> >=20
> > I guess we can add a separate "please configure traps for PTP/NTP"=20
> > NDO, if you prefer. Mostly an implementation detail. =20
>=20
> I am not as expert as you on the network stack therefore I am trying to f=
ollow
> and understand all the remarks. Please correct me if I say something wron=
g. It
> is interesting to understand all the complications that these changes bri=
ng.
>=20
> To summary, what do you think is preferable for this patch series?
> - New ops for TS as suggested by Russell.
>=20
> - Continue on this implementation and check that Vladimir A,B and C cases=
 are
>   handled. Which imply, if I understand well, find a good way to deal wit=
h PTP
>   change trap (bit or new ndo ops), convert most drivers from IOCTL to NDO
>   beforehand.=20
>=20
> - Add MAC-DMA TS? It think it is needed as MAC-DMA TS seems already used =
and
>   different from simple MAC TS in term of quality, as described by Jakub.

These aren't really disjoint alternatives, we need MAC-DMA TS and we
need a way to direct all TS requests to the MAC driver. Whether we do
it via an NDO, flags or new ops is kind of up to you. Question of
aesthetics.

Perhaps to move forward it'd be good to rev the patches, and address
the feedback which is clear?

