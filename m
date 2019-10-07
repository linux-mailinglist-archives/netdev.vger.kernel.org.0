Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037E1CE1AB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfJGM2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGM2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 08:28:04 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15EE12070B;
        Mon,  7 Oct 2019 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570451282;
        bh=iQbQ0UY61vuesIdewgOtWIu5yci5/NNeay5up33H920=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NmSADhkuYn/7MmQWr50+DP9W7q2+AfzRUMpJNpL3gGYOCZe1Oo2gi75craCDLYoLs
         wq8ax0GGmRo6fiLaKt+osSWGq63Ykl+ye9Ugjr1zdpotyYkya9SR7cNa5MqQyeR5s0
         m/Pmpqb2RAI115KXDGsoLNkYx7mKlNeTXRN2hHyc=
Date:   Mon, 7 Oct 2019 14:27:57 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: Re: [PATCH 2/7] net: mvneta: introduce page pool API for sw buffer
 manager
Message-ID: <20191007122757.GD3192@localhost.localdomain>
References: <cover.1570307172.git.lorenzo@kernel.org>
 <61f2fd6fc6a84083fe5d35c19f84da60ea373fe6.1570307172.git.lorenzo@kernel.org>
 <20191005213452.GA5019@PC192.168.49.172>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
In-Reply-To: <20191005213452.GA5019@PC192.168.49.172>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,=20
>=20

Hi Ilias,

> On Sat, Oct 05, 2019 at 10:44:35PM +0200, Lorenzo Bianconi wrote:
> > Use the page_pool api for allocations and DMA handling instead of
> > __dev_alloc_page()/dma_map_page() and free_page()/dma_unmap_page().
> > Pages are unmapped using page_pool_release_page before packets
> > go into the network stack.
> >=20
> > The page_pool API offers buffer recycling capabilities for XDP but
> > allocates one page per packet, unless the driver splits and manages
> > the allocated page.
> > This is a preliminary patch to add XDP support to mvneta driver
> >=20
> > Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/Kconfig  |  1 +
> >  drivers/net/ethernet/marvell/mvneta.c | 76 ++++++++++++++++++++-------
> >  2 files changed, 58 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/etherne=
t/marvell/Kconfig
> > index fb942167ee54..3d5caea096fb 100644
> > --- a/drivers/net/ethernet/marvell/Kconfig
> > +++ b/drivers/net/ethernet/marvell/Kconfig
> > @@ -61,6 +61,7 @@ config MVNETA
> >  	depends on ARCH_MVEBU || COMPILE_TEST
> >  	select MVMDIO
> >  	select PHYLINK
> > +	select PAGE_POOL
> >  	---help---
> >  	  This driver supports the network interface units in the
> >  	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 128b9fded959..8beae0e1eda7 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -37,6 +37,7 @@
> >  #include <net/ip.h>
> >  #include <net/ipv6.h>
> >  #include <net/tso.h>
> > +#include <net/page_pool.h>
> > =20
> >  /* Registers */
> >  #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
> > @@ -603,6 +604,10 @@ struct mvneta_rx_queue {
> >  	u32 pkts_coal;
> >  	u32 time_coal;
> > =20
> > +	/* page_pool */
> > +	struct page_pool *page_pool;
> > +	struct xdp_rxq_info xdp_rxq;
> > +
> >  	/* Virtual address of the RX buffer */
> >  	void  **buf_virt_addr;
> > =20
> > @@ -1815,19 +1820,12 @@ static int mvneta_rx_refill(struct mvneta_port =
*pp,
> >  	dma_addr_t phys_addr;
> >  	struct page *page;
> > =20
> > -	page =3D __dev_alloc_page(gfp_mask);
> > +	page =3D page_pool_alloc_pages(rxq->page_pool,
> > +				     gfp_mask | __GFP_NOWARN);
> >  	if (!page)
> >  		return -ENOMEM;
>=20
> Is the driver syncing the buffer somewhere else? (for_device)
> If not you'll have to do this here.=20

ack, I will add a dma_sync_to_device() in v2, thx for the hint :)

>=20
> On a non-cache coherent machine (and i think this one is) you may get dir=
ty
> cache lines handed to the device. Those dirty cache lines might get writt=
en back
> *after* the device has DMA'ed it's data. You need to flush those first to=
 avoid
> any data corruption

Right.

Regards,
Lorenzo

>=20
> > =20
> > -	/* map page for use */
> > -	phys_addr =3D dma_map_page(pp->dev->dev.parent, page, 0, PAGE_SIZE,
> > -				 DMA_FROM_DEVICE);
> > -	if (unlikely(dma_mapping_error(pp->dev->dev.parent, phys_addr))) {
> > -		__free_page(page);
> > -		return -ENOMEM;
> > -	}
> > -
> > -	phys_addr +=3D pp->rx_offset_correction;
> > +	phys_addr =3D page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> >  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> >  	return 0;
> >  }
> > @@ -1894,10 +1892,11 @@ static void mvneta_rxq_drop_pkts(struct mvneta_=
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
> >  }
> > =20
> >  static void
> > @@ -2029,8 +2028,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
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
> > @@ -2060,9 +2058,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
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
> > @@ -2829,11 +2825,53 @@ static int mvneta_poll(struct napi_struct *napi=
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
> > +	err =3D xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
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
> > =20
> >  	for (i =3D 0; i < num; i++) {
> >  		memset(rxq->descs + i, 0, sizeof(struct mvneta_rx_desc));
> > --=20
> > 2.21.0
> >=20
>=20
>=20
> Thanks
> /Ilias

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZsvSQAKCRA6cBh0uS2t
rDCdAP9buOe935sT44nE3BsOT2FuVvUdsoZO3KfEmjaWLb+2EwD/dxrXpwkzz4VV
+Js08PaZGZlCNz2MYMbypG/eHWRHPwY=
=XPvR
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
