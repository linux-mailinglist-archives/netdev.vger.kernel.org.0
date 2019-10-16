Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF7D8B06
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbfJPIdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfJPIdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:33:00 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6B721835;
        Wed, 16 Oct 2019 08:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571214779;
        bh=NdXZajyERs0QpLS+PGSREhn58yJ9/RafJOhvl3pfEgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZBdgEKeZyu+1YO30cwViqS5EItVwYXXDV2XZBWoQt+c4ZZcxBMbV1MXK+vB4MoJu
         wW7MHeWgg+kBFB6ke+jsvvaaCnWczfIBqVLmVTL9xoc/cTLN5A0zJkW4CadgRe8SYc
         wa8EAvXEYhcO9YBqG63nT6YZjgrbWNi/rRGQONao=
Date:   Wed, 16 Oct 2019 10:32:54 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 2/8] net: mvneta: introduce page pool API for
 sw buffer manager
Message-ID: <20191016083254.GA2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <af6df39a06cba5b416520c6249c16d2cd2e3bb73.1571049326.git.lorenzo@kernel.org>
 <20191015154107.08c4e9e1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20191015154107.08c4e9e1@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 14 Oct 2019 12:49:49 +0200, Lorenzo Bianconi wrote:
> > +static int mvneta_create_page_pool(struct mvneta_port *pp,
> > +				   struct mvneta_rx_queue *rxq, int size)
> > +{
> > +	struct page_pool_params pp_params =3D {
> > +		.order =3D 0,
> > +		.flags =3D PP_FLAG_DMA_MAP,
> > +		.pool_size =3D size,
> > +		.nid =3D cpu_to_node(0),
> > +		.dev =3D pp->dev->dev.parent,
> > +		.dma_dir =3D DMA_FROM_DEVICE,
> > +	};
> > +	int err;
> > +
> > +	rxq->page_pool =3D page_pool_create(&pp_params);
> > +	if (IS_ERR(rxq->page_pool)) {
> > +		err =3D PTR_ERR(rxq->page_pool);
> > +		rxq->page_pool =3D NULL;
> > +		return err;
> > +	}
> > +
> > +	err =3D xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
>=20
> The queue_index is always passed as 0, is there only a single queue?
> XDP programs can read this field.

Hi Jakub,

thx for the review. You are right, I will fix it in v4.

Regards,
Lorenzo

>=20
> > +	if (err < 0)
> > +		goto err_free_pp;
> > +
> > +	err =3D xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> > +					 rxq->page_pool);
> > +	if (err)
> > +		goto err_unregister_rxq;
> > +
> > +	return 0;
> > +
> > +err_unregister_rxq:
> > +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> > +err_free_pp:
> > +	page_pool_destroy(rxq->page_pool);
> > +	return err;
> > +}

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXabVswAKCRA6cBh0uS2t
rNGnAQCU8/Uq+kxOxrNZY84IzX0ElaedEpNR3YeObXioA5kKbAD9EKYBeWvmkIzp
DPXoH1UfAjy/gDlaT37dKKf/4iRt4gU=
=lsfE
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
