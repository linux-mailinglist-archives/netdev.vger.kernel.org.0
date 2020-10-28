Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6404229D74A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbgJ1WWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732591AbgJ1WWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:22:25 -0400
Received: from localhost (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52073246C9;
        Wed, 28 Oct 2020 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603885387;
        bh=nKhGK3Y1PvrhhiSe3Be8yClivksH9012Cv34ky/cpVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wdmDG2GBTHwcpjOYYPQlmtSoRWfd50tBPDiYqSTyEG8ZBZFUEwBRMTQ3rTFGzIVw7
         TrxDpE9d39D0+CpnsZbXlVM7jloJDthzgV0Paj8J7WAQh5QVzuthtgTf4ZRC72bP0h
         yw4v9U6pp8Nj9gx75pBwszf0d72yVKUsi0K5jG8Q=
Date:   Wed, 28 Oct 2020 12:43:01 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201028114301.GC5386@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
 <20201028123419.27e1ac54@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <20201028123419.27e1ac54@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 27 Oct 2020 20:04:07 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Introduce bulking capability in xdp tx return path (XDP_REDIRECT).
> > xdp_return_frame is usually run inside the driver NAPI tx completion
> > loop so it is possible batch it.
> > Current implementation considers only page_pool memory model.
> > Convert mvneta driver to xdp_return_frame_bulk APIs.
> >=20
> > Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>

Hi Jesper,

thx for the review.

>=20
> I think you/we have to explain better in this commit message, what the
> idea/concept behind this bulk return is.  Or even explain this as a
> comment above "xdp_return_frame_bulk".
>=20
> Maybe add/append text to commit below:
>=20
> The bulk API introduced is a defer and flush API, that will defer
> the return if the xdp_mem_allocator object is the same, identified
> via the mem.id field (xdp_mem_info).  Thus, the flush operation will
> operate on the same xdp_mem_allocator object.
>=20
> The bulk queue size of 16 is no coincident.  This is connected to how
> XDP redirect will bulk xmit (upto 16) frames. Thus, the idea is for the
> API to find these boundaries (via mem.id match), which is optimal for
> both the I-cache and D-cache for the memory allocator code and object.
>=20
> The data structure (xdp_frame_bulk) used for deferred elements is
> stored/allocated on the function call-stack, which allows lockfree
> access.

ack, I will add it in v2

>=20
>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> [...]
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 3814fb631d52..9567110845ef 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -104,6 +104,12 @@ struct xdp_frame {
> >  	struct net_device *dev_rx; /* used by cpumap */
> >  };
> > =20
> > +#define XDP_BULK_QUEUE_SIZE	16
>=20
> Maybe "#define DEV_MAP_BULK_SIZE 16" should be def to
> XDP_BULK_QUEUE_SIZE, to express the described connection.

ack, I guess we can fix it in a following patch

>=20
> > +struct xdp_frame_bulk {
> > +	void *q[XDP_BULK_QUEUE_SIZE];
> > +	int count;
> > +	void *xa;
>=20
> Just a hunch (not benchmarked), but I think it will be more optimal to
> place 'count' and '*xa' above the '*q' array.  (It might not matter at
> all, as we cannot control the start alignment, when this is on the
> stack.)

ack. I will fix in v2.

>=20
> > +};
> [...]
>=20
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 48aba933a5a8..93eabd789246 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -380,6 +380,57 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xd=
pf)
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> > =20
> > +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> > +{
> > +	struct xdp_mem_allocator *xa =3D bq->xa;
> > +	int i;
> > +
> > +	if (unlikely(!xa))
> > +		return;
> > +
> > +	for (i =3D 0; i < bq->count; i++) {
> > +		struct page *page =3D virt_to_head_page(bq->q[i]);
> > +
> > +		page_pool_put_full_page(xa->page_pool, page, false);
> > +	}
> > +	bq->count =3D 0;
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> > +
>=20
> Wondering if we should have a comment that explains the intent and idea
> behind this function?
>=20
> /* Defers return when frame belongs to same mem.id as previous frame */
>=20

ack.

Regards,
Lorenzo

> > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > +			   struct xdp_frame_bulk *bq)
> > +{
> > +	struct xdp_mem_info *mem =3D &xdpf->mem;
> > +	struct xdp_mem_allocator *xa, *nxa;
> > +
> > +	if (mem->type !=3D MEM_TYPE_PAGE_POOL) {
> > +		__xdp_return(xdpf->data, &xdpf->mem, false);
> > +		return;
> > +	}
> > +
> > +	rcu_read_lock();
> > +
> > +	xa =3D bq->xa;
> > +	if (unlikely(!xa || mem->id !=3D xa->mem.id)) {
> > +		nxa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > +		if (unlikely(!xa)) {
> > +			bq->count =3D 0;
> > +			bq->xa =3D nxa;
> > +			xa =3D nxa;
> > +		}
> > +	}
> > +
> > +	if (mem->id !=3D xa->mem.id || bq->count =3D=3D XDP_BULK_QUEUE_SIZE)
> > +		xdp_flush_frame_bulk(bq);
> > +
> > +	bq->q[bq->count++] =3D xdpf->data;
> > +	if (mem->id !=3D xa->mem.id)
> > +		bq->xa =3D nxa;
> > +
> > +	rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5lZQwAKCRA6cBh0uS2t
rGghAQCsjyWtmmXoycnxIZMORxYbKSaJyXko6AQRy3qh9aoQrQD+JsCSh0fl0EwU
WBK8b10ukrS2m2shhuMKdnt5EeEM4wc=
=yZRU
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
