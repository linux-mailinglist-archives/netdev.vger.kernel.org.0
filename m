Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F010308F97
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhA2Vr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhA2Vr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:47:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C13A064DDB;
        Fri, 29 Jan 2021 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611956805;
        bh=rAkWzKeQFiwgGT2q6kp5x81mqug7WvBplGOrrNCQx4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mRAwEDPmsQWcFr2RV+lGFv4hEDAacWRH4tiOq4nllF1ASQl4rKvE59OYJmAdDPjJL
         kLy1OGj2LYBfUwg9qy8dhbz8nXXOFuZ/aEu/avV/bFRsznTET/VVIJjCPU2V1dp5yb
         /3SAes0LEpdB3jZtYjYgwJS3zPPlnH53S1eDAAPA5OxEhOqZnN3vYbC01qw0ZJiTDQ
         nxV9OSwNYgld68xhtYGlH4PbB1A6nr0yltlI1EsE0h5jpD/PVIktwrTk2KZ9AHFFoO
         Mu+MqYEtAt3NKkN4Bx5s8uY1H6tvq6tKw2QhJX4ptg/ZuPHUQebtP1PWyZyLzbqmaM
         xBa6wzn7BNXLA==
Date:   Fri, 29 Jan 2021 22:46:40 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toshiaki.makita1@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com, Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v2 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
Message-ID: <20210129214640.GB20729@lore-desk>
References: <415937741661ac331be09c0e59b4ff1eacfee782.1611861943.git.lorenzo@kernel.org>
 <20210129170216.6a879619@carbon>
 <20210129201728.4322bab0@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <20210129201728.4322bab0@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 29, Jesper Dangaard Brouer wrote:
> On Fri, 29 Jan 2021 17:02:16 +0100
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>=20
> > > +	for (i =3D 0; i < n_skb; i++) {
> > > +		struct sk_buff *skb =3D skbs[i];
> > > +
> > > +		memset(skb, 0, offsetof(struct sk_buff, tail)); =20
> >=20
> > It is very subtle, but the memset operation on Intel CPU translates
> > into a "rep stos" (repeated store) operation.  This operation need to
> > save CPU-flags (to support being interrupted) thus it is actually
> > expensive (and in my experience cause side effects on pipeline
> > efficiency).  I have a kernel module for testing memset here[1].
> >=20
> > In CPUMAP I have moved the clearing outside this loop. But via asking
> > the MM system to clear the memory via gfp_t flag __GFP_ZERO.  This
> > cause us to clear more memory 256 bytes, but it is aligned.  Above
> > offsetof(struct sk_buff, tail) is 188 bytes, which is unaligned making
> > the rep-stos more expensive in setup time.  It is below 3-cachelines,
> > which is actually interesting and an improvement since last I checked.
> > I actually have to re-test with time_bench_memset[1], to know that is
> > better now.
>=20
> After much testing (with [1]), yes please use gfp_t flag __GFP_ZERO.

I run some comparison tests using memset and __GFP_ZERO and with VETH_XDP_B=
ATCH
set to 8 and 16. Results are pretty close so not completely sure the delta =
is
just a noise:

- VETH_XDP_BATCH=3D 8 + __GFP_ZERO: ~3.737Mpps
- VETH_XDP_BATCH=3D 16 + __GFP_ZERO: ~3.79Mpps
- VETH_XDP_BATCH=3D 8 + memset: ~3.766Mpps
- VETH_XDP_BATCH=3D 16 + __GFP_ZERO: ~3.765Mpps

Regards,
Lorenzo

>=20
>  SKB: offsetof-tail:184 bytes
>   - memset_skb_tail Per elem: 37 cycles(tsc) 10.463 ns
>=20
>  SKB: ROUNDUP(offsetof-tail: 192)
>   - memset_skb_tail_roundup Per elem: 37 cycles(tsc) 10.468 ns
>=20
> I though it would be better/faster to round up to full cachelines, but
> measurements show that the cost was the same for 184 vs 192.  It does
> validate the theory that it is the cacheline boundary that is important.
>=20
> When doing the gfp_t flag __GFP_ZERO, the kernel cannot know the
> constant size, and instead end up calling memset_erms().
>=20
> The cost of memset_erms(256) is:
>  - memset_variable_step(256) Per elem: 31 cycles(tsc) 8.803 ns
>=20
> The const version with 256 that uses rep-stos cost more:
>  - memset_256 Per elem: 41 cycles(tsc) 11.552 ns
>=20
>=20
> Below not relevant for your patch, but an interesting data point is
> that memset_erms(512) only cost 4 cycles more:
>  - memset_variable_step(512) Per elem: 35 cycles(tsc) 9.893 ns
>=20
> (but don't use rep-stos for const 512 it is 72 cycles(tsc) 20.069 ns.)
>=20
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/l=
ib/time_bench_memset.c
> CPU: Intel(R) Xeon(R) CPU E5-1650 v4 @ 3.60GHz
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYBSCPgAKCRA6cBh0uS2t
rLeeAQDBYjYzQQI30PKs87GyBVccs5TepkatbfCYCkNBcRdY0wEAle7MzQGrJiEc
LX3dGvt/wmqE2ZFy/NDyAULl/59muwk=
=EYef
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
