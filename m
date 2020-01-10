Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A1213715F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgAJPeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgAJPeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:34:20 -0500
Received: from localhost.localdomain (mob-176-246-50-46.net.vodafone.it [176.246.50.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217B120673;
        Fri, 10 Jan 2020 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578670458;
        bh=CgBFAk6vQQF7xcZUbHBdXjiBYIoYQvenk2YZwt1LfZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v5enBeAsD9pDKKokI846/3wuiJFGa+6VI6nTZpU6wWh3O8FObYfhS7+cGiMBlafQ+
         oV3saZuyAnEv9bpzHYDdcgZxZdWKm7pOnPGQwsgjY5EnWsmTSrY/z/Q9nVJAmNPrxW
         5pgspNohMv8Kjs2G+mc16Akh+laKULtaMfHBzJZc=
Date:   Fri, 10 Jan 2020 16:34:13 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110153413.GA31419@localhost.localdomain>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
 <20200110145631.GA69461@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20200110145631.GA69461@apalos.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:
> > Socionext driver can run on dma coherent and non-coherent devices.
> > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> > now the driver can let page_pool API to managed needed DMA sync
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - rely on original frame size for dma sync
> > ---
> >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
> >  1 file changed, 26 insertions(+), 17 deletions(-)
> >=20

[...]

> > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv =
*priv, struct xdp_buff *xdp)
> >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *p=
rog,
> >  			  struct xdp_buff *xdp)
> >  {
> > +	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RING_RX];
> > +	unsigned int len =3D xdp->data_end - xdp->data;
>=20
> We need to account for XDP expanding the headers as well here.=20
> So something like max(xdp->data_end(before bpf), xdp->data_end(after bpf)=
) -
> xdp->data (original)

correct, the corner case that is not covered at the moment is when data_end=
 is
moved forward by the bpf program. I will fix it in v3. Thx

Regards,
Lorenzo

>=20
> >  	u32 ret =3D NETSEC_XDP_PASS;
> >  	int err;
> >  	u32 act;
> > @@ -896,7 +896,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv,=
 struct bpf_prog *prog,
> >  	case XDP_TX:
> >  		ret =3D netsec_xdp_xmit_back(priv, xdp);
> >  		if (ret !=3D NETSEC_XDP_TX)
> > -			xdp_return_buff(xdp);
> > +			__page_pool_put_page(dring->page_pool,
> > +				     virt_to_head_page(xdp->data),
> > +				     len, true);
> >  		break;
> >  	case XDP_REDIRECT:
> >  		err =3D xdp_do_redirect(priv->ndev, xdp, prog);
> > @@ -904,7 +906,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv,=
 struct bpf_prog *prog,
> >  			ret =3D NETSEC_XDP_REDIR;
> >  		} else {
> >  			ret =3D NETSEC_XDP_CONSUMED;
> > -			xdp_return_buff(xdp);
> > +			__page_pool_put_page(dring->page_pool,
> > +				     virt_to_head_page(xdp->data),
> > +				     len, true);
> >  		}
> >  		break;
> >  	default:
> > @@ -915,7 +919,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv,=
 struct bpf_prog *prog,
> >  		/* fall through -- handle aborts by dropping packet */
> >  	case XDP_DROP:
> >  		ret =3D NETSEC_XDP_CONSUMED;
> > -		xdp_return_buff(xdp);
> > +		__page_pool_put_page(dring->page_pool,
> > +				     virt_to_head_page(xdp->data),
> > +				     len, true);
> >  		break;
> >  	}
> > =20
> > @@ -1014,7 +1020,8 @@ static int netsec_process_rx(struct netsec_priv *=
priv, int budget)
> >  			 * cache state. Since we paid the allocation cost if
> >  			 * building an skb fails try to put the page into cache
> >  			 */
> > -			page_pool_recycle_direct(dring->page_pool, page);
> > +			__page_pool_put_page(dring->page_pool, page,
> > +					     pkt_len, true);
>=20
> Same here, a bpf prog with XDP_PASS verdict might change lenghts
>=20
> >  			netif_err(priv, drv, priv->ndev,
> >  				  "rx failed to build skb\n");
> >  			break;
> > @@ -1272,17 +1279,19 @@ static int netsec_setup_rx_dring(struct netsec_=
priv *priv)
> >  {
> >  	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RING_RX];
> >  	struct bpf_prog *xdp_prog =3D READ_ONCE(priv->xdp_prog);
> > -	struct page_pool_params pp_params =3D { 0 };
> > +	struct page_pool_params pp_params =3D {
> > +		.order =3D 0,
> > +		/* internal DMA mapping in page_pool */
> > +		.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > +		.pool_size =3D DESC_NUM,
> > +		.nid =3D NUMA_NO_NODE,
> > +		.dev =3D priv->dev,
> > +		.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> > +		.offset =3D NETSEC_RXBUF_HEADROOM,
> > +		.max_len =3D NETSEC_RX_BUF_SIZE,
> > +	};
> >  	int i, err;
> > =20
> > -	pp_params.order =3D 0;
> > -	/* internal DMA mapping in page_pool */
> > -	pp_params.flags =3D PP_FLAG_DMA_MAP;
> > -	pp_params.pool_size =3D DESC_NUM;
> > -	pp_params.nid =3D NUMA_NO_NODE;
> > -	pp_params.dev =3D priv->dev;
> > -	pp_params.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> > -
> >  	dring->page_pool =3D page_pool_create(&pp_params);
> >  	if (IS_ERR(dring->page_pool)) {
> >  		err =3D PTR_ERR(dring->page_pool);
> > --=20
> > 2.21.1
> >=20
>=20
> Thanks
> /Ilias

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXhiZcgAKCRA6cBh0uS2t
rHtbAPsH2WTGg0CD4azogDXJP7EoKAlpjbaTt1k4oajQMPcW0QEAsSKks+3IXqxg
3f98Cy/6yqIN/EHz19CdAyhXXBB2vgk=
=bh/U
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
