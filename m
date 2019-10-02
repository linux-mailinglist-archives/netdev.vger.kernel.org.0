Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39E2C4A21
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfJBI7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJBI7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 04:59:39 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C2D215EA;
        Wed,  2 Oct 2019 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570006778;
        bh=QskPgzx7ZNdfRA0NzYBI3Y1NZwwlrWtYYSGxbM/cXIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k5yj5nWDxcc8T2jOugDNltTXQsAHRYvwAUtl9E7zC/rjDOVYP7+C1v8ozTe1jM6BR
         sx0scDXidPu4Ggz8cuaPQAbGDZudXyvY5lpqy8/1bgN9toZj/MTeNg3CMSyDeqfpS6
         f5n+AZuB1NEPnCvFZDJdMrH4QNs67RTyd7Gxnj6o=
Date:   Wed, 2 Oct 2019 10:59:33 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191002085933.GA2527@localhost.localdomain>
References: <cover.1569920973.git.lorenzo@kernel.org>
 <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
 <20191002034154.GA15959@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20191002034154.GA15959@apalos.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Oct 01, 2019 at 11:24:43AM +0200, Lorenzo Bianconi wrote:
> > Add basic XDP support to mvneta driver for devices that rely on software
> > buffer management. Currently supported verdicts are:
> > - XDP_DROP
> > - XDP_PASS
> > - XDP_REDIRECT
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 145 ++++++++++++++++++++++++--
> >  1 file changed, 136 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index e842c744e4f3..f2d12556efa8 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> [...]
> >  		.pool_size =3D size,
> >  		.nid =3D cpu_to_node(0),
> >  		.dev =3D pp->dev->dev.parent,
> > -		.dma_dir =3D DMA_FROM_DEVICE,
> > +		.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> >  	};
> > +	int err;
> > =20
> >  	rxq->page_pool =3D page_pool_create(&pp_params);
> >  	if (IS_ERR(rxq->page_pool)) {
> > @@ -2851,7 +2920,22 @@ static int mvneta_create_page_pool(struct mvneta=
_port *pp,
> >  		return PTR_ERR(rxq->page_pool);
> >  	}
> > =20
> > +	err =3D xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
> > +	if (err < 0)
> > +		goto err_free_pp;
> > +
> > +	err =3D xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> > +					 rxq->page_pool);
> > +	if (err)
> > +		goto err_unregister_pp;
>=20
> I think this should be part of patch [1/4], adding page pol support.=20
> Jesper introduced the changes to track down inflight packets [1], so you =
need
> those changes in place when implementing page_pool

ack, will do in the next round.

Regards,
Lorenzo

>=20
> > +
> >  	return 0;
> > +
> > +err_unregister_pp:
> > +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> > +err_free_pp:
> > +	page_pool_destroy(rxq->page_pool);
> > +	return err;
> >  }
> > =20
> >  /* Handle rxq fill: allocates rxq skbs; called when initializing a por=
t */
> > @@ -3291,6 +3375,11 @@ static int mvneta_change_mtu(struct net_device *=
dev, int mtu)
> >  		mtu =3D ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
> >  	}
> > =20
> > +	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
> > +		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
> > +		return -EINVAL;
> > +	}
> > +
> >  	dev->mtu =3D mtu;
> > =20
> >  	if (!netif_running(dev)) {
> > @@ -3960,6 +4049,43 @@ static int mvneta_ioctl(struct net_device *dev, =
struct ifreq *ifr, int cmd)
> >  	return phylink_mii_ioctl(pp->phylink, ifr, cmd);
> >  }
> > =20
> > +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *p=
rog,
> > +			    struct netlink_ext_ack *extack)
> > +{
> > +	struct mvneta_port *pp =3D netdev_priv(dev);
> > +	struct bpf_prog *old_prog;
> > +
> > +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	mvneta_stop(dev);
> > +
> > +	old_prog =3D xchg(&pp->xdp_prog, prog);
> > +	if (old_prog)
> > +		bpf_prog_put(old_prog);
> > +
> > +	mvneta_open(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> > +{
> > +	struct mvneta_port *pp =3D netdev_priv(dev);
> > +
> > +	switch (xdp->command) {
> > +	case XDP_SETUP_PROG:
> > +		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
> > +	case XDP_QUERY_PROG:
> > +		xdp->prog_id =3D pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> >  /* Ethtool methods */
> > =20
> >  /* Set link ksettings (phy address, speed) for ethtools */
> > @@ -4356,6 +4482,7 @@ static const struct net_device_ops mvneta_netdev_=
ops =3D {
> >  	.ndo_fix_features    =3D mvneta_fix_features,
> >  	.ndo_get_stats64     =3D mvneta_get_stats64,
> >  	.ndo_do_ioctl        =3D mvneta_ioctl,
> > +	.ndo_bpf	     =3D mvneta_xdp,
> >  };
> > =20
> >  static const struct ethtool_ops mvneta_eth_tool_ops =3D {
> > @@ -4646,7 +4773,7 @@ static int mvneta_probe(struct platform_device *p=
dev)
> >  	SET_NETDEV_DEV(dev, &pdev->dev);
> > =20
> >  	pp->id =3D global_port_id++;
> > -	pp->rx_offset_correction =3D NET_SKB_PAD;
> > +	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > =20
> >  	/* Obtain access to BM resources if enabled and already initialized */
> >  	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
> > --=20
> > 2.21.0
> >=20
>=20
> [1] https://lore.kernel.org/netdev/156086304827.27760.1133978604646563808=
1.stgit@firesoul/
>=20
>=20
> Regards
> /Ilias

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZRm8gAKCRA6cBh0uS2t
rNYlAPicv0vE2OPpkn7ItlK0TycM1kZjDAKzDua6+XiWdreTAP0XEQ9KXg+3Ow3o
rb/9cAF4USrU/XVizjKZezwe47j9AQ==
=Q+Uh
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
