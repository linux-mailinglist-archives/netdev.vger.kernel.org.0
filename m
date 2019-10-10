Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5DD26CF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbfJJJ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJJJ52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:57:28 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071BE2054F;
        Thu, 10 Oct 2019 09:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570701447;
        bh=jpeNt0MFe49Cw1ouuGG8uT3IePRpSMr8iFJvn+qvhYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lrGup3S6MuiYufUIKAjpPEBg8ahMA5wdNrA+evDNNzPgnN31IEE7Z/jkUHj9Wbm+J
         FSI+P4T2tw9NzR/HZ1L7Hwj7+UQdtC+YI/6/LYFx3AupK3KwrpWFdQkHeoy68j+Xry
         HfggE2KnIJibWeDO86R7mOymwwLxSo9RoyEbB6Ec=
Date:   Thu, 10 Oct 2019 11:57:21 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Subject: Re: [PATCH v2 net-next 5/8] net: mvneta: add basic XDP support
Message-ID: <20191010095721.GC3784@localhost.localdomain>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <0f471851967abb980d34104b64fea013b0dced7c.1570662004.git.lorenzo@kernel.org>
 <20191010105040.23e5e86f@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <20191010105040.23e5e86f@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 10 Oct 2019 01:18:35 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Add basic XDP support to mvneta driver for devices that rely on software
> > buffer management. Currently supported verdicts are:
> > - XDP_DROP
> > - XDP_PASS
> > - XDP_REDIRECT
> > - XDP_ABORTED
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 144 ++++++++++++++++++++++++--
> >  1 file changed, 135 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index ba4aa9bbc798..e2795dddbcaf 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> [...]
>=20
> > @@ -1950,16 +1960,60 @@ int mvneta_rx_refill_queue(struct mvneta_port *=
pp, struct mvneta_rx_queue *rxq)
> >  	return i;
> >  }
> > =20
> > +static int
> > +mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
> > +	       struct xdp_buff *xdp)
> > +{
> > +	u32 ret, act =3D bpf_prog_run_xdp(prog, xdp);
> > +
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		ret =3D MVNETA_XDP_PASS;
> > +		break;
> > +	case XDP_REDIRECT: {
> > +		int err;
> > +
> > +		err =3D xdp_do_redirect(pp->dev, xdp, prog);
> > +		if (err) {
> > +			ret =3D MVNETA_XDP_CONSUMED;
> > +			xdp_return_buff(xdp);
>=20
> > +		} else {
> > +			ret =3D MVNETA_XDP_REDIR;
> > +		}
> > +		break;
> > +	}
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +		/* fall through */
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(pp->dev, prog, act);
> > +		/* fall through */
> > +	case XDP_DROP:
> > +		ret =3D MVNETA_XDP_CONSUMED;
> > +		xdp_return_buff(xdp);
>=20
> Using xdp_return_buff() here is actually not optimal for performance.
> I can see that others socionext/netsec.c and AF_XDP also use this
> xdp_return_buff().
>=20
> I do think code wise it looks a lot nice to use xdp_return_buff(), so
> maybe we should optimize xdp_return_buff(), instead of using
> page_pool_recycle_direct() here?  (That would also help AF_XDP ?)
>=20
> The problem with xdp_return_buff() is that it does a "full" lookup from
> the mem.id (xdp_buff->xdp_rxq_info->mem.id) to find the "allocator"
> pointer in this case the page_pool pointer.  Here in the driver we
> already have access to the stable allocator page_pool pointer via
> struct mvneta_rx_queue *rxq->page_pool.

ack, right. Thx for pointing it out. I will fix it in v3

>=20
>=20
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  static int
> >  mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  		     struct mvneta_rx_desc *rx_desc,
> >  		     struct mvneta_rx_queue *rxq,
> > -		     struct page *page)
> > +		     struct bpf_prog *xdp_prog,
> > +		     struct page *page, u32 *xdp_ret)
> >  {
> >  	unsigned char *data =3D page_address(page);
> >  	int data_len =3D -MVNETA_MH_SIZE, len;
> >  	struct net_device *dev =3D pp->dev;
> >  	enum dma_data_direction dma_dir;
> > +	struct xdp_buff xdp =3D {
> > +		.data_hard_start =3D data,
> > +		.data =3D data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE,
> > +		.rxq =3D &rxq->xdp_rxq,
> > +	};
>=20
> Creating the struct xdp_buff (on call-stack) this way is not optimal
> for performance (IHMO it looks nicer code-wise, but too bad).
>=20
> This kind of initialization of only some of the members, cause GCC to
> zero out other members (I observed this on Intel, which use an
> expensive rep-sto operation).  Thus, this cause extra unnecessary memory
> writes.
>=20
> A further optimization, is that you can avoid re-assigning:
>  rxq =3D &rxq->xdp_rxq
> for each frame, as this actually stays the same for all the frames in
> this NAPI cycle.  By instead allocating the xdp_buff on the callers
> stack, and parsing in xdp_buff as a pointer.

ack, will fix it in v3.

Regards,
Lorenzo

>=20
>=20
> > +	xdp_set_data_meta_invalid(&xdp);
> > =20
> >  	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
> >  		len =3D MVNETA_MAX_RX_BUF_SIZE;
> > @@ -1968,13 +2022,27 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  		len =3D rx_desc->data_size;
> >  		data_len +=3D len - ETH_FCS_LEN;
> >  	}
> > +	xdp.data_end =3D xdp.data + data_len;
> > =20
> >  	dma_dir =3D page_pool_get_dma_dir(rxq->page_pool);
> >  	dma_sync_single_range_for_cpu(dev->dev.parent,
> >  				      rx_desc->buf_phys_addr, 0,
> >  				      len, dma_dir);
> > =20
> > -	rxq->skb =3D build_skb(data, PAGE_SIZE);
> > +	if (xdp_prog) {
> > +		u32 ret;
> > +
> > +		ret =3D mvneta_run_xdp(pp, xdp_prog, &xdp);
> > +		if (ret !=3D MVNETA_XDP_PASS) {
> > +			mvneta_update_stats(pp, 1, xdp.data_end - xdp.data,
> > +					    false);
> > +			rx_desc->buf_phys_addr =3D 0;
> > +			*xdp_ret |=3D ret;
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	rxq->skb =3D build_skb(xdp.data_hard_start, PAGE_SIZE);
> >  	if (unlikely(!rxq->skb)) {
> >  		netdev_err(dev,
> >  			   "Can't allocate skb on queue %d\n",
> [...]
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZ8AfgAKCRA6cBh0uS2t
rAmIAP98IZvY0D9y/H2bC4ykmTzCndGyHfH7BJRmmJy1HZiILwEAmFf9oUuwuSAl
UKhuEmkbDNkB8dIOY/Vzh+3f56M+XAM=
=UrYK
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
