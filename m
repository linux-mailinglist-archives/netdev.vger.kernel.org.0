Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1A32B393
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449752AbhCCEDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378996AbhCBP3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 10:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14B5C64F20;
        Tue,  2 Mar 2021 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614698928;
        bh=nWtbNd0LyPXCoQly4Fgl2Gsi9rtHOaKIPX4W5cz9HF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=To78vVwsjm4aSQ5HEPEKC7AHtNRCb1QDlYDn6Om+u+SR5gLHE2udj31LJ8IFWwsyZ
         xdzVnHrBROsA18h6JwpdKLZZgwcaldWbtHYVADxK82WE8uYdvKE5UoIM7ozZ6/4Bzm
         O/BuB9V5XhEiCJslYyvD1Pq8EhuWKTt4vydBX8kwIPKSzXfkIC9IXui2xDLwllkLnm
         J5wSe1RU+P6diTvkIuqMqKrO9OY2lCPHopZ3hUGuxVr/srv2PuB750/pLZm0srbdu7
         g6yHyAu32+eGFNjccxtr4bms1NwdJ9E4ftnDHK1M/yksr1w3LGK5njhWdEwQ+LG01U
         XeKUxLgXid0Hw==
Date:   Tue, 2 Mar 2021 16:28:43 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, freysteinn.alfredsson@kau.se,
        john.fastabend@gmail.com, jasowang@redhat.com, mst@redhat.com,
        thomas.petazzoni@bootlin.com, mw@semihalf.com,
        linux@armlinux.org.uk, ilias.apalodimas@linaro.org,
        netanel@amazon.com, akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <YD5ZqzIa5TymNdB4@lore-desk>
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
 <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <YDwYzYVIDQABINyy@lore-laptop-rh>
 <20210301084847.5117a404@carbon>
 <pj41zlpn0jcgms.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <20210301211837.4a755c44@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3l53p2Dttm0uRSJd"
Content-Disposition: inline
In-Reply-To: <20210301211837.4a755c44@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3l53p2Dttm0uRSJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 1 Mar 2021 13:23:06 +0200
> Shay Agroskin <shayagr@amazon.com> wrote:
>=20
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >=20
> > > On Sun, 28 Feb 2021 23:27:25 +0100
> > > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > =20
> > >> > >  	drops =3D bq->count - sent;
> > >> > > -out:
> > >> > > -	bq->count =3D 0;
> > >> > > +	if (unlikely(drops > 0)) {
> > >> > > +		/* If not all frames have been=20
> > >> > > transmitted, it is our
> > >> > > +		 * responsibility to free them
> > >> > > +		 */
> > >> > > +		for (i =3D sent; i < bq->count; i++)
> > >> > > +=20
> > >> > > xdp_return_frame_rx_napi(bq->q[i]);
> > >> > > +	}   =20
> > >> >=20
> > >> > Wouldn't the logic above be the same even w/o the 'if'=20
> > >> > condition ?   =20
> > >>=20
> > >> it is just an optimization to avoid the for loop instruction if=20
> > >> sent =3D bq->count =20
> > >
> > > True, and I like this optimization.
> > > It will affect how the code layout is (and thereby I-cache=20
> > > usage). =20
> >=20
> > I'm not sure what I-cache optimization you mean here. Compiling=20
> > the following C code:
> >=20
> > # define unlikely(x)	__builtin_expect(!!(x), 0)
> >=20
> > extern void xdp_return_frame_rx_napi(int q);
> >=20
> > struct bq_stuff {
> >     int q[4];
> >     int count;
> > };
> >=20
> > int test(int sent, struct bq_stuff *bq) {
> >     int i;
> >     int drops;
> >=20
> >     drops =3D bq->count - sent;
> >     if(unlikely(drops > 0))
> >         for (i =3D sent; i < bq->count; i++)
> >             xdp_return_frame_rx_napi(bq->q[i]);
> >=20
> >     return 2;
> > }
> >=20
> > with x86_64 gcc 10.2 with -O3 flag in https://godbolt.org/ (which=20
> > provides the assembly code for different compilers) yields the=20
> > following assembly:
> >=20
> > test:
> >         mov     eax, DWORD PTR [rsi+16]
> >         mov     edx, eax
> >         sub     edx, edi
> >         test    edx, edx
> >         jg      .L10
> > .L6:
> >         mov     eax, 2
> >         ret
>=20
> This exactly shows my point.  Notice how 'ret' happens earlier in this
> function.  This is the common case, thus the CPU don't have to load the
> asm instruction below.
>=20
> > .L10:
> >         cmp     eax, edi
> >         jle     .L6
> >         push    rbp
> >         mov     rbp, rsi
> >         push    rbx
> >         movsx   rbx, edi
> >         sub     rsp, 8
> > .L3:
> >         mov     edi, DWORD PTR [rbp+0+rbx*4]
> >         add     rbx, 1
> >         call    xdp_return_frame_rx_napi
> >         cmp     DWORD PTR [rbp+16], ebx
> >         jg      .L3
> >         add     rsp, 8
> >         mov     eax, 2
> >         pop     rbx
> >         pop     rbp
> >         ret
> >=20
> >=20
> > When dropping the 'if' completely I get the following assembly=20
> > output
> > test:
> >         cmp     edi, DWORD PTR [rsi+16]
> >         jge     .L6
>=20
> Jump to .L6 which is the common case.  The code in between is not used
> in common case, but the CPU will likely load this into I-cache, and
> then jumps over the code in common case.
>=20
> >         push    rbp
> >         mov     rbp, rsi
> >         push    rbx
> >         movsx   rbx, edi
> >         sub     rsp, 8
> > .L3:
> >         mov     edi, DWORD PTR [rbp+0+rbx*4]
> >         add     rbx, 1
> >         call    xdp_return_frame_rx_napi
> >         cmp     DWORD PTR [rbp+16], ebx
> >         jg      .L3
> >         add     rsp, 8
> >         mov     eax, 2
> >         pop     rbx
> >         pop     rbp
> >         ret
> > .L6:
> >         mov     eax, 2
> >         ret
> >=20
> > which exits earlier from the function if 'drops > 0' compared to=20
> > the original code (the 'for' loop looks a little different, but=20
> > this shouldn't affect icache).
> >
> > When removing the 'if' and surrounding the 'for' condition with=20
> > 'unlikely' statement:
> >=20
> > for (i =3D sent; unlikely(i < bq->count); i++)
> >=20
> > I get the following assembly code:
> >=20
> > test:
> >         cmp     edi, DWORD PTR [rsi+16]
> >         jl      .L10
> >         mov     eax, 2
> >         ret
> > .L10:
> >         push    rbx
> >         movsx   rbx, edi
> >         sub     rsp, 16
> > .L3:
> >         mov     edi, DWORD PTR [rsi+rbx*4]
> >         mov     QWORD PTR [rsp+8], rsi
> >         add     rbx, 1
> >         call    xdp_return_frame_rx_napi
> >         mov     rsi, QWORD PTR [rsp+8]
> >         cmp     DWORD PTR [rsi+16], ebx
> >         jg      .L3
> >         add     rsp, 16
> >         mov     eax, 2
> >         pop     rbx
> >         ret
> >=20
> > which is shorter than the other two (one line compared to the=20
> > second and 7 lines compared the original code) and seems as=20
> > optimized as the second.
>=20
> You are also using unlikely() and get the earlier return, with less
> instructions, which is great.  Perhaps we can use this type of
> unlikely() in the for-statement?  WDYT Lorenzo?

sure, we can do it..I will address it in v3. Thanks.

Regards,
Lorenzo

> =20
> =20
> > I'm far from being an assembly expert, and I tested a code snippet=20
> > I wrote myself rather than the kernel's code (for the sake of=20
> > simplicity only).
> > Can you please elaborate on what makes the original 'if' essential=20
> > (I took the time to do the assembly tests, please take the time on=20
> > your side to prove your point, I'm not trying to be grumpy here).
> >=20
> > Shay
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--3l53p2Dttm0uRSJd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYD5ZqQAKCRA6cBh0uS2t
rEcnAP9LdyDn5J3yhUEVOWD48x9BxsJWiH4q7EkasprVPMhgOwEA7c8ykv3Xbnhb
0o2HUVszNvC7BGRUlGKHhvyAW4/t2QA=
=wyRl
-----END PGP SIGNATURE-----

--3l53p2Dttm0uRSJd--
