Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC6CFEBD7
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKPLgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 06:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfKPLgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 06:36:39 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF4520723;
        Sat, 16 Nov 2019 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573904198;
        bh=TAMJQl+wOvZO1A1YRRxHSlQrHSkZpu1YkEi89X3QiYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mm+WZqQR5vkVZLjt3VwWAJI3ZI5z3MFA63Or3Oq5++b3qvktqoMVzMheNaKOf/1Jj
         2+a6Fd6iEjzIBZQRShsLECsVNk1F3n/rQtmZYqx2elRvYxG2OOrpyY9914VaJxu5eo
         ZXS5R6HZ+NdTKZ0T6REgUVuqaKWXAHzDwW/jKTG4=
Date:   Sat, 16 Nov 2019 13:36:30 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com
Subject: Re: [PATCH v3 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191116113630.GB20820@localhost.localdomain>
References: <cover.1573844190.git.lorenzo@kernel.org>
 <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
 <20191116122017.78e29e27@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20191116122017.78e29e27@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 15 Nov 2019 21:01:38 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> >  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> > -				   struct page *page)
> > +					  struct page *page,
> > +					  unsigned int dma_sync_size)
> >  {
> >  	int ret;
> >  	/* BH protection not needed if current is serving softirq */
> > @@ -264,6 +285,9 @@ static bool __page_pool_recycle_into_ring(struct pa=
ge_pool *pool,
> >  	else
> >  		ret =3D ptr_ring_produce_bh(&pool->ring, page);
> > =20
> > +	if (ret =3D=3D 0 && (pool->p.flags & PP_FLAG_DMA_SYNC_DEV))
> > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > +
> >  	return (ret =3D=3D 0) ? true : false;
> >  }
>=20
>=20
> I do wonder if we should DMA-sync-for-device BEFORE putting page into
> ptr_ring, as this is a channel between several concurrent CPUs.

Hi Jesper,

in this way we can end up syncing the DMA page even if it is unmapped in
__page_pool_clean_page (e.g. if the ptr_ring is full), right?

>=20
>=20
>=20
> > @@ -273,18 +297,22 @@ static bool __page_pool_recycle_into_ring(struct =
page_pool *pool,
> >   * Caller must provide appropriate safe context.
> >   */
> >  static bool __page_pool_recycle_direct(struct page *page,
> > -				       struct page_pool *pool)
> > +				       struct page_pool *pool,
> > +				       unsigned int dma_sync_size)
> >  {
> >  	if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
> >  		return false;
> > =20
> >  	/* Caller MUST have verified/know (page_ref_count(page) =3D=3D 1) */
> >  	pool->alloc.cache[pool->alloc.count++] =3D page;
> > +
> > +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> >  	return true;
> >  }
>=20
> We know __page_pool_recycle_direct() is concurrency safe, and only a
> single (NAPI processing) CPU can enter. (So, the DMA-sync order is not
> wrong here, but it could be swapped)

do you mean move it before putting the page in the cache?

pool->alloc.cache[pool->alloc.count++] =3D page;

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXc/fOwAKCRA6cBh0uS2t
rPHcAPwJGMNFddgcRh0SY73+cXkTj+sCELZQXz7OhIIQyTUiKAD/ZMGb9AINy9/R
/9QIi2UqaMqLkgURmmFecVaZJG66DwE=
=a8U9
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
