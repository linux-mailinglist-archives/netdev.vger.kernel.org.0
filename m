Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF9FECA6
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 15:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKPORc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 09:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727593AbfKPORc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 09:17:32 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B03120718;
        Sat, 16 Nov 2019 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573913851;
        bh=beQ3HhOVOecZygod7ecr+0Pq0+qqeaH4AIeC/YFn3GI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUjkiQmWh8eEf9aqikpITV9DbRwctohznnUEgV25+i23eucHoS6FEHVPe93PTBaoj
         uQvy7U2Jzgfg81UXoumba+WdPuxVwRi6T7dxqJafVwNvTbWY2JxK1+fMyJPe8F6mk+
         iZQk+f+U8hdrhSiPuD1SGOfj0qfpacxJfxYZkJag=
Date:   Sat, 16 Nov 2019 16:17:23 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com
Subject: Re: [PATCH v3 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191116141723.GG20820@localhost.localdomain>
References: <cover.1573844190.git.lorenzo@kernel.org>
 <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
 <20191116122017.78e29e27@carbon>
 <20191116113630.GB20820@localhost.localdomain>
 <20191116131741.2657e1bb@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Content-Disposition: inline
In-Reply-To: <20191116131741.2657e1bb@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 16 Nov 2019 13:36:30 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > > On Fri, 15 Nov 2019 21:01:38 +0200
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >  =20
> > > >  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> > > > -				   struct page *page)
> > > > +					  struct page *page,
> > > > +					  unsigned int dma_sync_size)
> > > >  {
> > > >  	int ret;
> > > >  	/* BH protection not needed if current is serving softirq */
> > > > @@ -264,6 +285,9 @@ static bool __page_pool_recycle_into_ring(struc=
t page_pool *pool,
> > > >  	else
> > > >  		ret =3D ptr_ring_produce_bh(&pool->ring, page);
> > > > =20
> > > > +	if (ret =3D=3D 0 && (pool->p.flags & PP_FLAG_DMA_SYNC_DEV))
> > > > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > > > +
> > > >  	return (ret =3D=3D 0) ? true : false;
> > > >  } =20
> > >=20
> > >=20
> > > I do wonder if we should DMA-sync-for-device BEFORE putting page into
> > > ptr_ring, as this is a channel between several concurrent CPUs. =20
> >=20
> > Hi Jesper,
> >=20
> > in this way we can end up syncing the DMA page even if it is unmapped in
> > __page_pool_clean_page (e.g. if the ptr_ring is full), right?
>=20
> Yes.  The call __page_pool_clean_page() will do a dma_unmap_page, so it
> should still be safe/correct.   I can see, that it is not optimal
> performance wise, in-case the ptr_ring is full, as DMA-sync-for-device
> is wasted work.
>=20
> I don't know if you can find an argument, that proves that it cannot
> happen, that a remote CPU can dequeue/consume the page from ptr_ring
> and give it to the device, while you (the CPU the enqueued) are still
> doing the DMA-sync-for-device.

right, I can see it now :)

>=20
> =20
> > > > @@ -273,18 +297,22 @@ static bool __page_pool_recycle_into_ring(str=
uct page_pool *pool,
> > > >   * Caller must provide appropriate safe context.
> > > >   */
> > > >  static bool __page_pool_recycle_direct(struct page *page,
> > > > -				       struct page_pool *pool)
> > > > +				       struct page_pool *pool,
> > > > +				       unsigned int dma_sync_size)
> > > >  {
> > > >  	if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
> > > >  		return false;
> > > > =20
> > > >  	/* Caller MUST have verified/know (page_ref_count(page) =3D=3D 1)=
 */
> > > >  	pool->alloc.cache[pool->alloc.count++] =3D page;
> > > > +
> > > > +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > > > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > > >  	return true;
> > > >  } =20
> > >=20
> > > We know __page_pool_recycle_direct() is concurrency safe, and only a
> > > single (NAPI processing) CPU can enter. (So, the DMA-sync order is not
> > > wrong here, but it could be swapped) =20
> >=20
> > do you mean move it before putting the page in the cache?
> >=20
> > pool->alloc.cache[pool->alloc.count++] =3D page;
>=20
> Yes, but here the order doesn't matter.
>=20
> If you choose to do the DMA-sync-for-device earlier/before, then look
> at the code, and see of it makes sense to do it in __page_pool_put_page()=
 ?
> (I've not checked the details)

I guess we can move page_pool_dma_sync_for_device() before
__page_pool_recycle_direct and __page_pool_recycle_into_ring since even if
__page_pool_put_page is not running in NAPI context or if alloc.cache is fu=
ll
we will end up calling page_pool_dma_sync_for_device as first task in
__page_pool_recycle_into_ring. I will fix in v4.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdAE8AAKCRA6cBh0uS2t
rFU+AP0Z90uVQwhGbeFWN9fPAKkboflsO3lVx5fEjyWPpcJrNQEAixAd9f+ZTmh7
of8Md4TVeIYUXu/Xafoyyps3fU96fw8=
=pUxc
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
