Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BAF29DEFE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403954AbgJ2A61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731578AbgJ1WRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:32 -0400
Received: from localhost (unknown [151.66.125.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE59D246C1;
        Wed, 28 Oct 2020 11:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603884523;
        bh=rRhHb1cGnsed2BR+Y4InE6K8DeepWbAjIelkEdsaKiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4DSxb199kwPN8SHw6J26PRr26zZqLSJVPEWTKtP3JlLCzcUCLWBeAyfY3i0buu1p
         J9R5KqiJgW17tATUIWoEjqiXyxT/OsWH6VdXw9wtcUPSWQ5JYNByCWZhl8dtciggKg
         4L3us3QIeT6jENAp/T6vtJiguPx8bqSiaXmj66a8=
Date:   Wed, 28 Oct 2020 12:28:38 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201028112838.GB5386@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
 <20201028092734.GA51291@apalos.home>
 <20201028102304.GA5386@lore-desk>
 <20201028105951.GA52697@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20201028105951.GA52697@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Oct 28, 2020 at 11:23:04AM +0100, Lorenzo Bianconi wrote:
> > > Hi Lorenzo,
> >=20
> > Hi Ilias,
> >=20
> > thx for the review.
> >=20
> > >=20
> > > On Tue, Oct 27, 2020 at 08:04:07PM +0100, Lorenzo Bianconi wrote:
> >=20
> > [...]
> >=20
> > > > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > > > +			   struct xdp_frame_bulk *bq)
> > > > +{
> > > > +	struct xdp_mem_info *mem =3D &xdpf->mem;
> > > > +	struct xdp_mem_allocator *xa, *nxa;
> > > > +
> > > > +	if (mem->type !=3D MEM_TYPE_PAGE_POOL) {
> > > > +		__xdp_return(xdpf->data, &xdpf->mem, false);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	xa =3D bq->xa;
> > > > +	if (unlikely(!xa || mem->id !=3D xa->mem.id)) {
> > >=20
> > > Why is this marked as unlikely? The driver passes it as NULL. Should =
unlikely be
> > > checked on both xa and the comparison?
> >=20
> > xa is NULL only for the first xdp_frame in the burst while it is set for
> > subsequent ones. Do you think it is better to remove it?
>=20
> Ah correct, missed the general context of the driver this runs in.
>=20
> >=20
> > >=20
> > > > +		nxa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params=
);
> > >=20
> > > Is there a chance nxa can be NULL?
> >=20
> > I do not think so since the page_pool is not destroyed while there are
> > in-flight pages, right?
>=20
> I think so but I am not 100% sure. I'll apply the patch and have a closer=
 look

ack, thx. I converted socionext driver to bulking APIs but I have not poste=
d the
patch since I have not been able to test it. The code is available here:

https://github.com/LorenzoBianconi/net-next/commit/88c2995bca051fa38860acf7=
b915c90768460d37

Regards,
Lorenzo

>=20
> Cheers
> /Ilias

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5lV5AAKCRA6cBh0uS2t
rAqLAQDMdRNYycb1gb2fvqRSOVrq1x9V3c1MGdLTunRdtBBHwQEA8z0tzWLToD/C
CL0Tl3lSgtQf2jqDs4TO4T+rfrPsBAg=
=Z1r6
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
