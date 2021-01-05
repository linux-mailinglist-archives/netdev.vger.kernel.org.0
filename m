Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C5E2EB1A8
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbhAERoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730421AbhAERoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:44:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4318B20449;
        Tue,  5 Jan 2021 17:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609868614;
        bh=2j/AKy/fBCjBTmJLgDw+CL20jhgT7VLHKLHAGvLEL4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O9MKiNHkq+ntImGagGsx/rGOR+JxFYe79HYrZteCVd4eAM3DSUzFexdSrAJOBQmmr
         x0t1g02kKBWLzT+6ITKQ2H5BzYhtn+4eQU6DEr0NJBjI5smLjRbNhEHWgND02L1H3o
         QclE1P87Rt8MxcdXy23MM7fIBV74OuI2/NpdzSCpjl7AcV4MGHEc5gWsdXEi9tmndY
         wSHVSlJjYAbKgf4dhF84yQ4TnQ3BSqMVqPe08Cr14Kv4rwKeeLOkdW+folkNGHZKgH
         dJkUwwHovLOegF6j3W4bj6tZDt98wTvzWeQPAfNT9ePIgeblkcHkeMjqy+OcSzDVkW
         cHBXm7KcdpbCA==
Date:   Tue, 5 Jan 2021 18:43:08 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210105184308.1d2b7253@kernel.org>
In-Reply-To: <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
References: <20210105171921.8022-1-kabel@kernel.org>
        <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 18:24:37 +0100
Sven Auhagen <sven.auhagen@voleatech.de> wrote:

> On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Beh=C3=BAn wrote:
> > Currently mvpp2_xdp_setup won't allow attaching XDP program if
> >   mtu > ETH_DATA_LEN (1500).
> >=20
> > The mvpp2_change_mtu on the other hand checks whether
> >   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> >=20
> > These two checks are semantically different.
> >=20
> > Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
> > mvpp2_rx we have
> >   xdp.data =3D data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> >   xdp.frame_sz =3D PAGE_SIZE;
> >=20
> > Change the checks to check whether
> >   mtu > MVPP2_MAX_RX_BUF_SIZE =20
>=20
> Hello Marek,
>=20
> in general, XDP is based on the model, that packets are not bigger than 1=
500.
> I am not sure if that has changed, I don't believe Jumbo Frames are upstr=
eamed yet.
> You are correct that the MVPP2 driver can handle bigger packets without a=
 problem but
> if you do XDP redirect that won't work with other drivers and your packet=
s will disappear.

At least 1508 is required when I want to use XDP with a Marvell DSA
switch: the DSA header is 4 or 8 bytes long there.

The DSA driver increases MTU on CPU switch interface by this length
(on my switches to 1504).

So without this I cannot use XDP with mvpp2 with a Marvell switch with
default settings, which I think is not OK.

Since with the mvneta driver it works (mvneta checks for
MVNETA_MAX_RX_BUF_SIZE rather than ETH_DATA_LEN), I think it should also wo=
rk
with mvpp2.

Marek
