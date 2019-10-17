Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DBCDA97C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439598AbfJQJ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393881AbfJQJ6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 05:58:47 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80C02089C;
        Thu, 17 Oct 2019 09:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571306326;
        bh=Uejqi6lPH9muk73uzfSdn005kJ1WIWq+YfZpFOUSO/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mpRVGTy6pHyjgO72d3veHfz/WbHQpXuLCxLPq2K8fJe175mtxnY5XV5uLC/5jG9CM
         jvOQMG51kdAZ9o0Ayeuno9qoPFAU0f/xWJjQM/1DTaUsKuAG4HPej4XrI+O88SXUUi
         WKdxvWQg2gkhJvH+ZqANfyIU5BXtOKpuMCINNPXk=
Date:   Thu, 17 Oct 2019 11:58:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 2/7] net: mvneta: introduce page pool API for
 sw buffer manager
Message-ID: <20191017095840.GD2861@localhost.localdomain>
References: <cover.1571258792.git.lorenzo@kernel.org>
 <c63e3b458e6b047f167322b31553d2ba384fd3d0.1571258792.git.lorenzo@kernel.org>
 <20191016181450.1729a2da@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <20191016181450.1729a2da@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 16 Oct 2019 23:03:07 +0200, Lorenzo Bianconi wrote:

[...]

> > =20
> > @@ -1894,10 +1893,11 @@ static void mvneta_rxq_drop_pkts(struct mvneta_=
port *pp,
> >  		if (!data || !(rx_desc->buf_phys_addr))
> >  			continue;
> > =20
> > -		dma_unmap_page(pp->dev->dev.parent, rx_desc->buf_phys_addr,
> > -			       PAGE_SIZE, DMA_FROM_DEVICE);
> > -		__free_page(data);
> > +		page_pool_put_page(rxq->page_pool, data, false);
> >  	}
> > +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> > +		xdp_rxq_info_unreg(&rxq->xdp_rxq);
> > +	page_pool_destroy(rxq->page_pool);
>=20
> I think you may need to set the page_pool pointer to NULL here, no?
> AFAICT the ndo_stop in this driver has to be idempotent due to the
> open/close-to-reconfigure dances.
>=20
> >  }
> > =20
> >  static void
> > @@ -2029,8 +2029,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  				skb_add_rx_frag(rxq->skb, frag_num, page,
> >  						frag_offset, frag_size,
> >  						PAGE_SIZE);
> > -				dma_unmap_page(dev->dev.parent, phys_addr,
> > -					       PAGE_SIZE, DMA_FROM_DEVICE);
> > +				page_pool_release_page(rxq->page_pool, page);
> >  				rxq->left_size -=3D frag_size;
> >  			}
> >  		} else {
> > @@ -2060,9 +2059,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  						frag_offset, frag_size,
> >  						PAGE_SIZE);
> > =20
> > -				dma_unmap_page(dev->dev.parent, phys_addr,
> > -					       PAGE_SIZE, DMA_FROM_DEVICE);
> > -
> > +				page_pool_release_page(rxq->page_pool, page);
> >  				rxq->left_size -=3D frag_size;
> >  			}
> >  		} /* Middle or Last descriptor */
> > @@ -2829,11 +2826,53 @@ static int mvneta_poll(struct napi_struct *napi=
, int budget)
> >  	return rx_done;
> >  }
> > =20
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
> > +	err =3D xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id);
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
>=20
> ditto
>=20
> > +	return err;
> > +}
> > +
> >  /* Handle rxq fill: allocates rxq skbs; called when initializing a por=
t */
> >  static int mvneta_rxq_fill(struct mvneta_port *pp, struct mvneta_rx_qu=
eue *rxq,
> >  			   int num)
> >  {
> > -	int i;
> > +	int i, err;
> > +
> > +	err =3D mvneta_create_page_pool(pp, rxq, num);
> > +	if (err < 0)
> > +		return err;
>=20
> Note that callers of mvneta_rxq_fill() never check the return code.
> Some form of error print or such could be justified here.. although
> actually propagating the error code all the way back to user space is
> even better.

ack, I agree. I will add a dedicated patch in the series.

>=20
> IMHO on device start the fill ring should be required to be filled up
> completely, but that's just an opinion.

at bootstrap mvneta_rxq_fill() is run with num set to rxq->size so I guess =
to
the max allowed value (512 by default)

Regards,
Lorenzo

>=20
> >  	for (i =3D 0; i < num; i++) {
> >  		memset(rxq->descs + i, 0, sizeof(struct mvneta_rx_desc));

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXag7TQAKCRA6cBh0uS2t
rMw6AP0S9Qwn6/olx0PjGbBqH70Wbw5VJIRUtAtVItzCQVfCtgD/XajVVtjL+Duu
if5YtQ1EvcrgK8UnYb5lTi18/QZIgww=
=acrm
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
