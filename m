Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A963389C7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 11:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhCLKNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 05:13:33 -0500
Received: from mail.katalix.com ([3.9.82.81]:54810 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232506AbhCLKNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 05:13:00 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 059E4835E5;
        Fri, 12 Mar 2021 10:12:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1615543979; bh=fxXe6I1aSG6SQ/i16YVUY5JNgwXtt14li56ntHRbnoo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Fri,=2012=20Mar=202021=2010:12:58=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20lyl2019@mail.ustc.edu.cn|Cc:=2
         0paulus@samba.org,=20davem@davemloft.net,=20linux-ppp@vger.kernel.
         org,=0D=0A=09netdev@vger.kernel.org,=20linux-kernel@vger.kernel.or
         g|Subject:=20Re:=20[BUG]=20net/ppp:=20A=20use=20after=20free=20in=
         20ppp_unregister_channe|Message-ID:=20<20210312101258.GA4951@katal
         ix.com>|References:=20<6057386d.ca12.1782148389e.Coremail.lyl2019@
         mail.ustc.edu.cn>|MIME-Version:=201.0|Content-Disposition:=20inlin
         e|In-Reply-To:=20<6057386d.ca12.1782148389e.Coremail.lyl2019@mail.
         ustc.edu.cn>;
        b=sguwCApzj0ZtEa8x8DRyYXUxnDj7Yp2FujIJ2/lG/q9FIufJheBxzq9pym/SIMlsw
         LhoczNet61yZdohGuxCyL/+zEj0gf6L0LHLQ9/4lmwJIDz3GN6xuWSrqnhhAC35Nmw
         OnLnLBLbHi3oveJXrMU9Uyu76xXhXAUW5b2jLY6vpo/UGkFV4s1Hfl/uJWu319EPRZ
         MmBSgRMT14qs0eeKiBwYEN4bslKaTLsT04rhGw1LVXEVs+vjd5XR+0G/3NcfGLoXjd
         D/mGL0PoUYN+2nwWV44crYkBVDA7KS3wGQruCHLQq0wTv6wmrKgEaKUQSO3vhpsSsl
         RlQZzQlF5x9nA==
Date:   Fri, 12 Mar 2021 10:12:58 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     lyl2019@mail.ustc.edu.cn
Cc:     paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
Message-ID: <20210312101258.GA4951@katalix.com>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks for the report!

On  Thu, Mar 11, 2021 at 20:34:44 +0800, lyl2019@mail.ustc.edu.cn wrote:
> File: drivers/net/ppp/ppp_generic.c
>=20
> In ppp_unregister_channel, pch could be freed in ppp_unbridge_channels()
> but after that pch is still in use. Inside the function ppp_unbridge_chan=
nels,
> if "pchbb =3D=3D pch" is true and then pch will be freed.

Do you have a way to reproduce a use-after-free scenario?

=46rom static analysis I'm not sure how pch would be freed in
ppp_unbridge_channels when called via. ppp_unregister_channel.

In theory (at least!) the caller of ppp_register_net_channel holds=20
a reference on struct channel which ppp_unregister_channel drops.

Each channel in a bridged pair holds a reference on the other.

Hence on return from ppp_unbridge_channels, the channel should not have
been freed (in this code path) because the ppp_register_net_channel
reference has not yet been dropped.

Maybe there is an issue with the reference counting or a race of some
sort?

> I checked the commit history and found that this problem is introduced fr=
om
> 4cf476ced45d7 ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls").
>=20
> I have no idea about how to generate a suitable patch, sorry.

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmBLPqIACgkQlIwGZQq6
i9BImgf/VhpowGVVPkfWqgkYkfOsWZfxmDueUkeoSFD2dVhLeTNU/jnOGI400Cc0
Yk+sEFL4fqmjZPjsjIGBlhdpndQJbW+yCKh+G/xmU9ynd9xe+0KrP0WpToJ5Dd3+
1aCU4n1y5h8MhP6i0BuFe4KQ7K0SSIoSqubAyAF56bHp15arsHGaFB5clBQwy/Nj
LBW4St5DNAOQTc9heT+s+rhC6LSzXJgz9URaGkwbPtFuFIYmkloFvTRwqC3YJGCQ
OKF6B3w3uow6gxIX/K3MSRsrDiktsYRNiK1jqOM7l8Jm9qP1EaarbqdCN7W5RhBk
GecNJWitncHg1zyx+SvpFTVJbxjxYA==
=npR2
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
