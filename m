Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415E929DF52
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgJ2BAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgJ1WR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:28 -0400
Received: from localhost (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE750246AC;
        Wed, 28 Oct 2020 10:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603880589;
        bh=LHjCMNQkmVeEHd6wwd8+DjShKT2zXHi8BR7YSgjJMdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLybIgtmbVfZ7cx3bKznpm60tpLbIQOHU4iKEoFzC0RPglh+SX5tb0+vBX3rLxO4R
         tlD5KTqpEwlcwUaxTNSKDTdQjO7TC+yLqj4Gjq0g9bO1VbX65eDy7liFeAat1NaU2G
         fp20/7i2jcCgCM/pA+b3O4YmLhxUIUIsDgnFbKzA=
Date:   Wed, 28 Oct 2020 11:23:04 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201028102304.GA5386@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
 <20201028092734.GA51291@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20201028092734.GA51291@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Ilias,

thx for the review.

>=20
> On Tue, Oct 27, 2020 at 08:04:07PM +0100, Lorenzo Bianconi wrote:

[...]

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
>=20
> Why is this marked as unlikely? The driver passes it as NULL. Should unli=
kely be
> checked on both xa and the comparison?

xa is NULL only for the first xdp_frame in the burst while it is set for
subsequent ones. Do you think it is better to remove it?

>=20
> > +		nxa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>=20
> Is there a chance nxa can be NULL?

I do not think so since the page_pool is not destroyed while there are
in-flight pages, right?

Regards,
Lorenzo

>=20
> > +		if (unlikely(!xa)) {
>=20
> Same here, driver passes it as NULL
>=20
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
> > +
> >  void xdp_return_buff(struct xdp_buff *xdp)
> >  {
> >  	__xdp_return(xdp->data, &xdp->rxq->mem, true);
> > --=20
> > 2.26.2
> >=20
>=20
> Cheers
> /Ilias

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5lGhQAKCRA6cBh0uS2t
rCdwAP9lundd0CwaHHOP4WPJZz88jktnZuR8tHAcoWij1YPhyQEAz8OkB7i0xCfM
9w97tcDtfWtJvQXMomnd/F+WGYJMcg0=
=cLii
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
