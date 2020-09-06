Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6B25ED72
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 11:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgIFJGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 05:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgIFJGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 05:06:03 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E29620C09;
        Sun,  6 Sep 2020 09:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599383162;
        bh=1Row6bNIggtCyhi/gsAGobEOcopaKX+UFcaxMMB7Qjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncpHSovfDDAKmWRsETlwmA5HS54m5YTSqL5ah167ZZR6mOjkPrfs3wrnkGIXQmQrv
         3fI4tdHm7IFtiEuSD11BvlJvd7lMmUM4rGfviT/eHJ68mwzyKyCiTA+NGKmQayEc2v
         lQi1wZqH8KntODpC9YfVl2WcUGa5dZe12rSwj4uE=
Date:   Sun, 6 Sep 2020 11:05:57 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <20200906090557.GB2785@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <25198d8424778abe9ee3fe25bba542143201b030.1599165031.git.lorenzo@kernel.org>
 <pj41zly2lnpdfn.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <pj41zly2lnpdfn.fsf@u68c7b5b1d2d758.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> >  				rx_desc->buf_phys_addr,
> >  				len, dma_dir);
> > -	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
> > -		skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags];
> > +	if (data_len > 0 && *nfrags < MAX_SKB_FRAGS) {
> > +		skb_frag_t *frag =3D &sinfo->frags[*nfrags];
> >  		skb_frag_off_set(frag, pp->rx_offset_correction);
> >  		skb_frag_size_set(frag, data_len);
> >  		__skb_frag_set_page(frag, page);
> > -		sinfo->nr_frags++;
> > +		*nfrags =3D *nfrags + 1;
>=20
> nit, why do you use nfrags variable instead of sinfo->nr_frags (as it was
> before this patch) ?
>                You doesn't seem to use the nfrags variable in the
> caller function and you update nr_frags as well.
>                If it's used in a different patch (haven't
> reviewed it all yet), maybe move it to that patch                ? (sorry=
 in
> advance if I missed the logic here)

nfrags pointer is used to avoid the sinfo->nr_frags initialization in
mvneta_swbm_rx_frame() since skb_shared_info is not in the cache usually.
AFAIK the hw does not provide the info "this is the second descriptor" but
just "this the frist/last descriptor".

Regards,
Lorenzo

>=20
> > +
> > +		if (rx_desc->status & MVNETA_RXD_LAST_DESC) {
> > +			sinfo->nr_frags =3D *nfrags;
> > +			xdp->mb =3D true;
> > +		}
> >  		rx_desc->buf_phys_addr =3D 0;
> >               ...

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1SmcwAKCRA6cBh0uS2t
rCRUAP46FTjB4mHRUzcGoPqccgpxwnKGvUTkqSmSW2RQQRUCOQEAouRLixWIpoM0
djJVbzjli5XjGV+cnNsa04YeTzcGBww=
=3J8v
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
