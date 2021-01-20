Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E02FDBCE
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbhATVKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 16:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436554AbhATU64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:58:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB1F233FC;
        Wed, 20 Jan 2021 20:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611176295;
        bh=iXj+0YnbrTVWd4deThBsWxk0qAvBLKD2iMdUjP4T6No=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvuZBPtFORQKZpLtBK71+ILeEDdGuOc0qFnc4/B/9yzEvaqXQWL/DP75HEkla8/d8
         RohwA76wVMRI5j0b0N7tQjZUCDE3YHk6YYRLNCMl0WcFP0X8sw02UsfXr9bOnG3s8i
         dl0SM3oetsua7yoZVifsmV0TFN3Pv/dL/4SAsKIqyk78HFdOoRVreRO4MX3E0QAnUI
         62DL4kF0U1s2KvifCCwCn1oRv/t5sS9SJdxRgzZTndJr8rtcs+FVnuVjKetEwFkIm9
         dSzKF/FyvgHHVKjM52ovOCEmPr+X7SgynYWWrLA7xTK/CuLNJPIp1+gkZx35Vfn9N4
         v8pp5QGN+DnBg==
Date:   Wed, 20 Jan 2021 12:58:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 15/16] net: dsa: felix: setup MMIO filtering
 rules for PTP when using tag_8021q
Message-ID: <20210120125813.3e04e132@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120173241.4jfqhsm725wqeqic@skbuf>
References: <20210119230749.1178874-1-olteanv@gmail.com>
        <20210119230749.1178874-16-olteanv@gmail.com>
        <20210120084042.4d37dadb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210120173241.4jfqhsm725wqeqic@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 19:32:41 +0200 Vladimir Oltean wrote:
> On Wed, Jan 20, 2021 at 08:40:42AM -0800, Jakub Kicinski wrote:
> > drivers/net/dsa/ocelot/felix.c:464:12: warning: variable =E2=80=98err=
=E2=80=99 set but not used [-Wunused-but-set-variable]
> >   464 |  int port, err;
> >       |            ^~~
> > drivers/net/dsa/ocelot/felix.c:265:53: warning: incorrect type in assig=
nment (different base types)
> > drivers/net/dsa/ocelot/felix.c:265:53:    expected unsigned short [user=
type]
> > drivers/net/dsa/ocelot/felix.c:265:53:    got restricted __be16 [userty=
pe]
> >
> >
> > Please build test the patches locally, the patchwork testing thing is
> > not keeping up with the volume, and it's running on the largest VM
> > available thru the provider already :/ =20
>=20
> I updated my compiler now, so that W=3D1 C=3D1 builds would not fail.
> That should hopefully prevent this from happening in the future.

Thanks.

> > I need to add this "don't post your patches to get them build tested
> > or you'll make Kuba very angry" to the netdev FAQ. =20
>=20
> Since I definitely don't want to upset Kuba,

:)

> how bad is it to exceed the 15 patches per series limit? Do I need to
> do something about it?

It's not a hard rule IIUC, if you have 16, 17 patches as an atomic
series which is hard to split, I'd think that's acceptable from time=20
to time. Especially if the patches themselves are not huge.
If you're already splitting a larger effort, keeping it < 15 is best.
In general if you can split a smaller logically contained series out
that's always preferred. The point is if the series is too large
reviewers are likely to postpone reviewing it until they can allocate
sufficiently large continuous block of time, which may be never.
It's all about efficient code review.

At least that's my recollection / understanding. There may be more
reasons, we'd have to ask Dave.
