Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3441EB87B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFBJ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgFBJ1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 05:27:40 -0400
Received: from localhost (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E395B206A4;
        Tue,  2 Jun 2020 09:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591090059;
        bh=8ukSCUj0F3ZsTDpxZ462W/NCApXcTJ6gmk+NXgZ08Mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZ/7ScZpxaje4Z/xIjAOMC5o/WjtR/UnTmPqizkBJTyeFlBRQH/fvXEst7XFHkjcP
         unSuefm2XY50qiZSRHd2IPYMFy1dr43sdK915CWgbbFViyJf5oVhG/bSFgK6BqNtMf
         sSpY+4DcEgWcWVVP7YqlTuuY0rcAnt8YowAniILE=
Date:   Tue, 2 Jun 2020 11:27:34 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH bpf-next 4/6] bpf: cpumap: add the possibility to attach
 an eBPF program to cpumap
Message-ID: <20200602092734.GA11951@localhost.localdomain>
References: <cover.1590960613.git.lorenzo@kernel.org>
 <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
 <20200601223618.ca6bby672wqxgovg@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20200601223618.ca6bby672wqxgovg@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, May 31, 2020 at 11:46:49PM +0200, Lorenzo Bianconi wrote:
> > +
> > +		prog =3D READ_ONCE(rcpu->prog);
> >  		for (i =3D 0; i < n; i++) {
> > -			void *f =3D frames[i];
> > +			void *f =3D xdp_frames[i];
> >  			struct page *page =3D virt_to_page(f);
> > +			struct xdp_frame *xdpf;
> > +			struct xdp_buff xdp;
> > +			u32 act;
> > +			int err;
> > =20
> >  			/* Bring struct page memory area to curr CPU. Read by
> >  			 * build_skb_around via page_is_pfmemalloc(), and when
> >  			 * freed written by page_frag_free call.
> >  			 */
> >  			prefetchw(page);
> > +			if (!prog) {
> > +				frames[nframes++] =3D xdp_frames[i];
> > +				continue;
> > +			}
>=20
> I'm not sure compiler will be smart enough to hoist !prog check out of th=
e loop.
> Otherwise default cpumap case will be a bit slower.
> I'd like to see performance numbers before/after and acks from folks
> who are using cpumap before applying.
> Also please add selftest for it. samples/bpf/ in patch 6 is not enough.

Hi Alexei,

thx for the review. I will add a selftest and some performance numbers in v=
2.

Regards,
Lorenzo

>=20
> Other than the above the feature looks good to me. It nicely complements =
devmap.

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXtYbgwAKCRA6cBh0uS2t
rJznAQDigvmJj3iMy3R7+W0j4elqzbHcm9D33qKi4oJppgzjowEAhJynm4jeoEOo
KGXAykKL+F8iFrAqeGUiQ2MwMI4wRAI=
=qJP7
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
