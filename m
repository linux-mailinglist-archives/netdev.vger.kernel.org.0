Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32241F7F84
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKKTMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfKKTMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:12:03 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B5C420674;
        Mon, 11 Nov 2019 19:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573499521;
        bh=RAhdRzAxyJrzCk0ECZGyYH9utFg5k8KBsjbf6xLsU4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uu+yiY5SjDBOq3sBLGqQIOKWYPJ6i3GpA0fADIYryktglfqaXLUGXFCuJ3ynMSZ+9
         faqL+ZWRHdvNHk7zWZVY0iAUSH2bLYrfdpBMSCL3r+QpMfXDmjIifBOBlDQKaTT5wo
         1nqDKOpVYbHJvE6GShDPB6deNQe+GjB4EAnCUP8Y=
Date:   Mon, 11 Nov 2019 21:11:50 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191111191150.GF4197@localhost.localdomain>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <20191111174835.7344731b@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Content-Disposition: inline
In-Reply-To: <20191111174835.7344731b@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, 10 Nov 2019 14:09:09 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Introduce the following parameters in order to add the possibility to s=
ync
> > DMA memory area before putting allocated buffers in the page_pool cache=
s:
>=20
> > - sync: set to 1 if device is non cache-coherent and needs to flush DMA=
 area
>=20

Hi Jesper,

thx for the review

> I don't agree that this is only for non cache-coherent devices.
>=20
> This change is generally for all device drivers.  Via setting 'sync'
> (which I prefer to rename 'dma_sync') driver request that page_pool
> takes over doing DMA-sync-for-device. (Very important, DMA-sync-for-CPU
> is still drivers responsibility).  Drivers can benefit from removing
> their calls to dma_sync_single_for_device().
>=20
> We need to define meaning/semantics of this setting (my definition):
> - This means that all pages that driver gets from page_pool, will be
>   DMA-synced-for-device.

ack, will fix it in v2

>=20
> > - offset: DMA address offset where the DMA engine starts copying rx data
>=20
> > - max_len: maximum DMA memory size page_pool is allowed to flush. This
> >   is currently used in __page_pool_alloc_pages_slow routine when pages
> >   are allocated from page allocator
>=20
> Implementation wise (you did as I suggested offlist), and does the
> DMA-sync-for-device at return-time page_pool_put_page() time, because
> we (often) know the length that was/can touched by CPU.  This is key to
> the optimization, that we know this length.

right, refilling the cache we now the exact length that was/can touched by =
CPU.

>=20
> I also think you/we need to explain why this optimization is correct,
> my attempt:=20
>=20
> This optimization reduce the length of the DMA-sync-for-device.  The
> optimization is valid, because page is initially DMA-synced-for-device,
> as defined via max_len.  At driver RX time, the driver will do a
> DMA-sync-for-CPU on the memory for the packet length.  What is
> important is the memory occupied by packet payload, because this is the
> memory CPU is allowed to read and modify.  If CPU have not written into
> a cache-line, then we know that CPU will not be flushing this, thus it
> doesn't need a DMA-sync-for-device.  As we don't track cache-lines
> written into, simply use the full packet length as dma_sync_size, at
> page_pool recycle time.  This also take into account any tail-extend.

ack, will update it in v2

Regards,
Lorenzo

>=20
>=20
> > These parameters are supposed to be set by device drivers
>=20
>=20
> =20
> > Tested-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/page_pool.h | 11 +++++++----
> >  net/core/page_pool.c    | 39 +++++++++++++++++++++++++++++++++------
> >  2 files changed, 40 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 2cbcdbdec254..defbfd90ab46 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -65,6 +65,9 @@ struct page_pool_params {
> >  	int		nid;  /* Numa node id to allocate from pages from */
> >  	struct device	*dev; /* device, for DMA pre-mapping purposes */
> >  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> > +	unsigned int	max_len; /* max DMA sync memory size */
> > +	unsigned int	offset;  /* DMA addr offset */
> > +	u8 sync;
> >  };
> > =20
> >  struct page_pool {
> > @@ -150,8 +153,8 @@ static inline void page_pool_destroy(struct page_po=
ol *pool)
> >  }
> > =20
> >  /* Never call this directly, use helpers below */
> > -void __page_pool_put_page(struct page_pool *pool,
> > -			  struct page *page, bool allow_direct);
> > +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> > +			  unsigned int dma_sync_size, bool allow_direct);
> > =20
> >  static inline void page_pool_put_page(struct page_pool *pool,
> >  				      struct page *page, bool allow_direct)
> > @@ -160,14 +163,14 @@ static inline void page_pool_put_page(struct page=
_pool *pool,
> >  	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
> >  	 */
> >  #ifdef CONFIG_PAGE_POOL
> > -	__page_pool_put_page(pool, page, allow_direct);
> > +	__page_pool_put_page(pool, page, 0, allow_direct);
> >  #endif
> >  }
> >  /* Very limited use-cases allow recycle direct */
> >  static inline void page_pool_recycle_direct(struct page_pool *pool,
> >  					    struct page *page)
> >  {
> > -	__page_pool_put_page(pool, page, true);
> > +	__page_pool_put_page(pool, page, 0, true);
> >  }
> > =20
> >  /* API user MUST have disconnected alloc-side (not allowed to call
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 5bc65587f1c4..af9514c2d15b 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -112,6 +112,17 @@ static struct page *__page_pool_get_cached(struct =
page_pool *pool)
> >  	return page;
> >  }
> > =20
> > +/* Used for non-coherent devices */
> > +static void page_pool_dma_sync_for_device(struct page_pool *pool,
> > +					  struct page *page,
> > +					  unsigned int dma_sync_size)
> > +{
> > +	dma_sync_size =3D min(dma_sync_size, pool->p.max_len);
> > +	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> > +					 pool->p.offset, dma_sync_size,
> > +					 pool->p.dma_dir);
> > +}
> > +
> >  /* slow path */
> >  noinline
> >  static struct page *__page_pool_alloc_pages_slow(struct page_pool *poo=
l,
> > @@ -156,6 +167,10 @@ static struct page *__page_pool_alloc_pages_slow(s=
truct page_pool *pool,
> >  	}
> >  	page->dma_addr =3D dma;
> > =20
> > +	/* non-coherent devices - flush memory */
> > +	if (pool->p.sync)
> > +		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> > +
> >  skip_dma_map:
> >  	/* Track how many pages are held 'in-flight' */
> >  	pool->pages_state_hold_cnt++;
> > @@ -255,7 +270,8 @@ static void __page_pool_return_page(struct page_poo=
l *pool, struct page *page)
> >  }
> > =20
> >  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> > -				   struct page *page)
> > +					  struct page *page,
> > +					  unsigned int dma_sync_size)
> >  {
> >  	int ret;
> >  	/* BH protection not needed if current is serving softirq */
> > @@ -264,6 +280,10 @@ static bool __page_pool_recycle_into_ring(struct p=
age_pool *pool,
> >  	else
> >  		ret =3D ptr_ring_produce_bh(&pool->ring, page);
> > =20
> > +	/* non-coherent devices - flush memory */
> > +	if (ret =3D=3D 0 && pool->p.sync)
> > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> > +
> >  	return (ret =3D=3D 0) ? true : false;
> >  }
> > =20
> > @@ -273,18 +293,23 @@ static bool __page_pool_recycle_into_ring(struct =
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
> > +	/* non-coherent devices - flush memory */
> > +	if (pool->p.sync)
> > +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> >  	return true;
> >  }
> > =20
> > -void __page_pool_put_page(struct page_pool *pool,
> > -			  struct page *page, bool allow_direct)
> > +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> > +			  unsigned int dma_sync_size, bool allow_direct)
> >  {
> >  	/* This allocator is optimized for the XDP mode that uses
> >  	 * one-frame-per-page, but have fallbacks that act like the
> > @@ -296,10 +321,12 @@ void __page_pool_put_page(struct page_pool *pool,
> >  		/* Read barrier done in page_ref_count / READ_ONCE */
> > =20
> >  		if (allow_direct && in_serving_softirq())
> > -			if (__page_pool_recycle_direct(page, pool))
> > +			if (__page_pool_recycle_direct(page, pool,
> > +						       dma_sync_size))
> >  				return;
> > =20
> > -		if (!__page_pool_recycle_into_ring(pool, page)) {
> > +		if (!__page_pool_recycle_into_ring(pool, page,
> > +						   dma_sync_size)) {
> >  			/* Cache full, fallback to free pages */
> >  			__page_pool_return_page(pool, page);
> >  		}
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXcmycwAKCRA6cBh0uS2t
rOxzAQD7tFYuaeeAZvz8KDSMkFdpvsXoM6V1HlVmmzGD7++IwgD+OrB0vq08W/Aw
CBkqba05rLkSpQostOyx97gCLDO35QU=
=0cpn
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
