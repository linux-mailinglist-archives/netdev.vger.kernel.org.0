Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737E8C3336
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbfJALo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfJALoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 07:44:55 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FA521855;
        Tue,  1 Oct 2019 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569930294;
        bh=dFzd57vuJCeA/EA5qYDVABAp5xGIgdVidMy2MloBQyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lCA5OpB/EFxlNuNV+7Cc9Sb9/mF6L1WeAE4VulGyOlxu/85RjBBStxyYZWs0NRZ48
         2GlPPhG5vq/EpN+hDl9viX7P8GoLq+CfoxyLR8j1hD4ea0ps+c+hLHKQCk0CdDXKVN
         zYY/cqXTwLvuHDz0ls7L5vUzfAvAbl26u4kV1C7k=
Date:   Tue, 1 Oct 2019 13:44:49 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191001114449.GA30888@localhost.localdomain>
References: <cover.1569920973.git.lorenzo@kernel.org>
 <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
 <20191001125246.0000230a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20191001125246.0000230a@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue,  1 Oct 2019 11:24:43 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Add basic XDP support to mvneta driver for devices that rely on software
> > buffer management. Currently supported verdicts are:
> > - XDP_DROP
> > - XDP_PASS
> > - XDP_REDIRECT
>=20
> You're supporting XDP_ABORTED as well :P any plans for XDP_TX?

Hi Maciej,

yes, I am currently working on XDP_TX and I will add it before posting a fo=
rmal
series

Regards,
Lorenzo

>=20
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
> > @@ -38,6 +38,7 @@
> >  #include <net/ipv6.h>
> >  #include <net/tso.h>
> >  #include <net/page_pool.h>
> > +#include <linux/bpf_trace.h>
> > =20
> >  /* Registers */
> >  #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
> > @@ -323,8 +324,10 @@
> >  	      ETH_HLEN + ETH_FCS_LEN,			     \
> >  	      cache_line_size())
> > =20
> > +#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
> > +				 NET_IP_ALIGN)
> >  #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) =
+ \
> > -			 NET_SKB_PAD))
> > +			 MVNETA_SKB_HEADROOM))
> >  #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> >  #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
> > =20
> > @@ -352,6 +355,11 @@ struct mvneta_statistic {
> >  #define T_REG_64	64
> >  #define T_SW		1
> > =20
> > +#define MVNETA_XDP_PASS		BIT(0)
> > +#define MVNETA_XDP_CONSUMED	BIT(1)
> > +#define MVNETA_XDP_TX		BIT(2)
> > +#define MVNETA_XDP_REDIR	BIT(3)
> > +
> >  static const struct mvneta_statistic mvneta_statistics[] =3D {
> >  	{ 0x3000, T_REG_64, "good_octets_received", },
> >  	{ 0x3010, T_REG_32, "good_frames_received", },
> > @@ -431,6 +439,8 @@ struct mvneta_port {
> >  	u32 cause_rx_tx;
> >  	struct napi_struct napi;
> > =20
> > +	struct bpf_prog *xdp_prog;
> > +
> >  	/* Core clock */
> >  	struct clk *clk;
> >  	/* AXI clock */
> > @@ -611,6 +621,7 @@ struct mvneta_rx_queue {
> > =20
> >  	/* page_pool */
> >  	struct page_pool *page_pool;
> > +	struct xdp_rxq_info xdp_rxq;
> > =20
> >  	/* Virtual address of the RX buffer */
> >  	void  **buf_virt_addr;
> > @@ -1897,6 +1908,8 @@ static void mvneta_rxq_drop_pkts(struct mvneta_po=
rt *pp,
> > =20
> >  		page_pool_put_page(rxq->page_pool, data, false);
> >  	}
> > +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> > +		xdp_rxq_info_unreg(&rxq->xdp_rxq);
> >  	page_pool_destroy(rxq->page_pool);
> >  }
> > =20
> > @@ -1925,16 +1938,52 @@ int mvneta_rx_refill_queue(struct mvneta_port *=
pp, struct mvneta_rx_queue *rxq)
> >  	return i;
> >  }
> > =20
> > +static int
> > +mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
> > +	       struct xdp_buff *xdp)
> > +{
> > +	u32 ret =3D bpf_prog_run_xdp(prog, xdp);
> > +	int err;
> > +
> > +	switch (ret) {
> > +	case XDP_PASS:
> > +		return MVNETA_XDP_PASS;
> > +	case XDP_REDIRECT:
> > +		err =3D xdp_do_redirect(pp->dev, xdp, prog);
> > +		if (err) {
> > +			xdp_return_buff(xdp);
> > +			return MVNETA_XDP_CONSUMED;
> > +		}
> > +		return MVNETA_XDP_REDIR;
> > +	default:
> > +		bpf_warn_invalid_xdp_action(ret);
> > +		/* fall through */
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(pp->dev, prog, ret);
> > +		/* fall through */
> > +	case XDP_DROP:
> > +		xdp_return_buff(xdp);
> > +		return MVNETA_XDP_CONSUMED;
> > +	}
> > +}
> > +
> >  static int
> >  mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  		     struct mvneta_rx_desc *rx_desc,
> >  		     struct mvneta_rx_queue *rxq,
> > +		     struct bpf_prog *xdp_prog,
> >  		     struct page *page)
> >  {
> >  	unsigned char *data =3D page_address(page);
> >  	int data_len =3D -MVNETA_MH_SIZE, len;
> >  	struct net_device *dev =3D pp->dev;
> >  	enum dma_data_direction dma_dir;
> > +	struct xdp_buff xdp =3D {
> > +		.data_hard_start =3D data,
> > +		.data =3D data + MVNETA_SKB_HEADROOM,
> > +		.rxq =3D &rxq->xdp_rxq,
> > +	};
> > +	xdp_set_data_meta_invalid(&xdp);
> > =20
> >  	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
> >  		len =3D MVNETA_MAX_RX_BUF_SIZE;
> > @@ -1943,13 +1992,24 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  		len =3D rx_desc->data_size;
> >  		data_len +=3D (len - ETH_FCS_LEN);
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
> > +		int ret;
> > +
> > +		ret =3D mvneta_run_xdp(pp, xdp_prog, &xdp);
> > +		if (ret !=3D MVNETA_XDP_PASS) {
>=20
> Nit: you could have it written as:
> if (mvneta_run_xdp(...)) {
> 	//blah
> }
>=20
> since MVNETA_XDP_PASS is 0. The 'ret' variable is not needed here.
>=20
> > +			rx_desc->buf_phys_addr =3D 0;
> > +			return -EAGAIN;
> > +		}
> > +	}
> > +
> > +	rxq->skb =3D build_skb(xdp.data_hard_start, PAGE_SIZE);
> >  	if (unlikely(!rxq->skb)) {
> >  		netdev_err(dev,
> >  			   "Can't allocate skb on queue %d\n",
> > @@ -1959,8 +2019,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  		return -ENOMEM;
> >  	}
> > =20
> > -	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
> > -	skb_put(rxq->skb, data_len);
> > +	skb_reserve(rxq->skb,
> > +		    MVNETA_MH_SIZE + xdp.data - xdp.data_hard_start);
> > +	skb_put(rxq->skb, xdp.data_end - xdp.data);
> >  	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
> > =20
> >  	page_pool_release_page(rxq->page_pool, page);
> > @@ -1995,7 +2056,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *p=
p,
> >  		/* refill descriptor with new buffer later */
> >  		skb_add_rx_frag(rxq->skb,
> >  				skb_shinfo(rxq->skb)->nr_frags,
> > -				page, NET_SKB_PAD, data_len,
> > +				page, MVNETA_SKB_HEADROOM, data_len,
> >  				PAGE_SIZE);
> > =20
> >  		page_pool_release_page(rxq->page_pool, page);
> > @@ -2011,10 +2072,14 @@ static int mvneta_rx_swbm(struct napi_struct *n=
api,
> >  {
> >  	int rcvd_pkts =3D 0, rcvd_bytes =3D 0;
> >  	int rx_todo, rx_proc =3D 0, refill;
> > +	struct bpf_prog *xdp_prog;
> > =20
> >  	/* Get number of received packets */
> >  	rx_todo =3D mvneta_rxq_busy_desc_num_get(pp, rxq);
> > =20
> > +	rcu_read_lock();
> > +	xdp_prog =3D READ_ONCE(pp->xdp_prog);
> > +
> >  	/* Fairness NAPI loop */
> >  	while (rcvd_pkts < budget && rx_proc < rx_todo) {
> >  		struct mvneta_rx_desc *rx_desc =3D mvneta_rxq_next_desc_get(rxq);
> > @@ -2029,6 +2094,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  		prefetch(data);
> > =20
> >  		rxq->refill_num++;
> > +		rcvd_pkts++;
> >  		rx_proc++;
> > =20
> >  		if (rx_desc->status & MVNETA_RXD_FIRST_DESC) {
> > @@ -2042,7 +2108,8 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  				continue;
> >  			}
> > =20
> > -			err =3D mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
> > +			err =3D mvneta_swbm_rx_frame(pp, rx_desc, rxq,
> > +						   xdp_prog, page);
> >  			if (err < 0)
> >  				continue;
> >  		} else {
> > @@ -2066,7 +2133,6 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  			rxq->skb =3D NULL;
> >  			continue;
> >  		}
> > -		rcvd_pkts++;
> >  		rcvd_bytes +=3D rxq->skb->len;
> > =20
> >  		/* Linux processing */
> > @@ -2077,6 +2143,7 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  		/* clean uncomplete skb pointer in queue */
> >  		rxq->skb =3D NULL;
> >  	}
> > +	rcu_read_unlock();
> > =20
> >  	if (rcvd_pkts) {
> >  		struct mvneta_pcpu_stats *stats =3D this_cpu_ptr(pp->stats);
> > @@ -2836,14 +2903,16 @@ static int mvneta_poll(struct napi_struct *napi=
, int budget)
> >  static int mvneta_create_page_pool(struct mvneta_port *pp,
> >  				   struct mvneta_rx_queue *rxq, int size)
> >  {
> > +	struct bpf_prog *xdp_prog =3D READ_ONCE(pp->xdp_prog);
> >  	struct page_pool_params pp_params =3D {
> >  		.order =3D 0,
> >  		.flags =3D PP_FLAG_DMA_MAP,
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
> err_unregister_rxq?
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
>=20
> NL_SET_ERR_MSG_MOD(xdp->extack, "Unknown XDP command"); ?
>=20
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
>=20

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZM8LgAKCRA6cBh0uS2t
rEoKAQCbeNHrWbenH9uMSsREL6+iJcmSPIg58FhxV2Yom3q5IQD/esvZC6NciTcc
rpMGuc/MIiik38KKVT0rTQUBLseigg8=
=PPQM
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
