Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F842AEEEA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgKKKnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgKKKnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 05:43:37 -0500
Received: from localhost (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5D32063A;
        Wed, 11 Nov 2020 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605091416;
        bh=Y3nOWpQ6gjk1A05/pkmC0s4gAecpIOmp2sy9mnkEjFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0RBzUAJb2QWVVpNvp2tN0wFOuNoEniz0FIXgPrfwr+RhIHtXRAuf5TYHVDWpFxGY
         EIwUWdZKe04dAZpiMxxt9eml18TxexXW+xj/vnBlYueMxc5QS45CBemyASNcy4HhqV
         3c/vKdhZUm06MEQBq9kCykExyHMBAH2zHL+TWLs8=
Date:   Wed, 11 Nov 2020 11:43:31 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 net-nex 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201111104331.GA3988@lore-desk>
References: <cover.1605020963.git.lorenzo@kernel.org>
 <1229970bf6f36fd4689169a2e47fdcc664d28366.1605020963.git.lorenzo@kernel.org>
 <5fabaf0c4a68a_bb2602085a@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <5fabaf0c4a68a_bb2602085a@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > Introduce the capability to batch page_pool ptr_ring refill since it is
> > usually run inside the driver NAPI tx completion loop.
> >=20
> > Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/page_pool.h | 26 ++++++++++++++++
> >  net/core/page_pool.c    | 69 +++++++++++++++++++++++++++++++++++------
> >  net/core/xdp.c          |  9 ++----
> >  3 files changed, 87 insertions(+), 17 deletions(-)
>=20
> [...]
>=20
> > +/* Caller must not use data area after call, as this function overwrit=
es it */
> > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > +			     int count)
> > +{
> > +	int i, bulk_len =3D 0, pa_len =3D 0;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		struct page *page =3D virt_to_head_page(data[i]);
> > +
> > +		page =3D __page_pool_put_page(pool, page, -1, false);
> > +		/* Approved for bulk recycling in ptr_ring cache */
> > +		if (page)
> > +			data[bulk_len++] =3D page;
> > +	}
> > +
> > +	if (unlikely(!bulk_len))
> > +		return;
> > +
> > +	/* Bulk producer into ptr_ring page_pool cache */
> > +	page_pool_ring_lock(pool);
> > +	for (i =3D 0; i < bulk_len; i++) {
> > +		if (__ptr_ring_produce(&pool->ring, data[i]))
> > +			data[pa_len++] =3D data[i];
>=20
> How about bailing out on the first error? bulk_len should be less than
> 16 right, so should we really keep retying hoping ring->size changes?

do you mean doing something like:

	page_pool_ring_lock(pool);
	if (__ptr_ring_full(&pool->ring)) {
		pa_len =3D bulk_len;
		page_pool_ring_unlock(pool);
		goto out;
	}
	...
out:
	for (i =3D 0; i < pa_len; i++) {
		...
	}

I do not know if it is better or not since the consumer can run in parallel.
@Jesper/Ilias: any idea?

Regards,
Lorenzo

>=20
> > +	}
> > +	page_pool_ring_unlock(pool);
> > +
> > +	if (likely(!pa_len))
> > +		return;
> > +
> > +	/* ptr_ring cache full, free pages outside producer lock since
> > +	 * put_page() with refcnt =3D=3D 1 can be an expensive operation
> > +	 */
> > +	for (i =3D 0; i < pa_len; i++)
> > +		page_pool_return_page(pool, data[i]);
> > +}
> > +EXPORT_SYMBOL(page_pool_put_page_bulk);
> > +
>=20
> Otherwise LGTM.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX6vAUQAKCRA6cBh0uS2t
rJgBAQC3lsXjP/KYpaJo7bpefhDNKJCHOuIz/Vw3s2Ueub8q1gEAiS50wKs/dWnt
RqDHt3CSYNZq7SYA15REUFH59unf0w8=
=1glU
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
