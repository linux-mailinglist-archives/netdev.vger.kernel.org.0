Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD02D6415
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfJNN1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 09:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfJNN1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 09:27:11 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674012089C;
        Mon, 14 Oct 2019 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571059630;
        bh=K2JcRJBOHc5M3TkuxfGSQ+NjHIc8KyvfbTgvYx5jZMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Grf92Zy68VclHGjn6HtjcGO6wXLPka/LsoK/+F0TumSQszR70UaFhAP9xL+7XMmWO
         rgrEYjJ3Qe7RjGXelJgCDAQBhDxSIzsjE8QBLkHsfmhh/QX8qhBDmrktpwJaqm8P/9
         ogZLst+73Fqtg9uXWvTpqeT/zqA6PhfB+0a+TRFE=
Date:   Mon, 14 Oct 2019 15:27:04 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: Re: [PATCH v3 net-next 5/8] net: mvneta: add basic XDP support
Message-ID: <20191014132704.GA10751@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <7c53ff9e148b80613088c7c35444244cbe1358bf.1571049326.git.lorenzo@kernel.org>
 <20191014144838.7a6e931b@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20191014144838.7a6e931b@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 14 Oct 2019 12:49:52 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Add basic XDP support to mvneta driver for devices that rely on software
> > buffer management. Currently supported verdicts are:
> > - XDP_DROP
> > - XDP_PASS
> > - XDP_REDIRECT
> > - XDP_ABORTED
> >=20
> > - iptables drop:
> > $iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
> > $nstat -n && sleep 1 && nstat
> > IpInReceives		151169		0.0
> > IpExtInOctets		6953544		0.0
> > IpExtInNoECTPkts	151165		0.0
> >=20
> > - XDP_DROP via xdp1
> > $./samples/bpf/xdp1 3
> > proto 0:	421419 pkt/s
> > proto 0:	421444 pkt/s
> > proto 0:	421393 pkt/s
> > proto 0:	421440 pkt/s
> > proto 0:	421184 pkt/s
> >=20
> > Tested-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 147 ++++++++++++++++++++++++--
> >  1 file changed, 138 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 1722dffe265d..b47a44cf9610 100644
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
>=20
> I find it confusing that you call it "consumed" (MVNETA_XDP_CONSUMED),
> because if I follow the code these are all drop-cases that are due to
> errors.
>=20
> Can we call it MVNETA_XDP_DROPPED?

Hi Jesper,

thx for the review. Sure I will rename it in v4.

Regards,
Lorenzo

>=20
> I also checked, your XDP_TX patch[8/8], that all the return paths for
> MVNETA_XDP_CONSUMED also leads to drop of the xdp_buff.
>=20
>=20
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
> > @@ -1950,11 +1960,51 @@ int mvneta_rx_refill_queue(struct mvneta_port *=
pp, struct mvneta_rx_queue *rxq)
> >  	return i;
> >  }
> > =20
> > +static int
> > +mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> > +	       struct bpf_prog *prog, struct xdp_buff *xdp)
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
> Dropped in case of errors.  As this is an error case, I don't mind that
> you use the slower xdp_return_buff().
>=20
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
> > +		page_pool_recycle_direct(rxq->page_pool,
> > +					 virt_to_head_page(xdp->data));
> > +		ret =3D MVNETA_XDP_CONSUMED;
>=20
> Also drop case.
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
> > +		     struct xdp_buff *xdp,
> > +		     struct bpf_prog *xdp_prog,
> > +		     struct page *page, u32 *xdp_ret)
> >  {
> >  	unsigned char *data =3D page_address(page);
> >  	int data_len =3D -MVNETA_MH_SIZE, len;
> > @@ -1974,7 +2024,26 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  				rx_desc->buf_phys_addr,
> >  				len, dma_dir);
> > =20
> > -	rxq->skb =3D build_skb(data, PAGE_SIZE);
> > +	xdp->data_hard_start =3D data;
> > +	xdp->data =3D data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
> > +	xdp->data_end =3D xdp->data + data_len;
> > +	xdp_set_data_meta_invalid(xdp);
> > +
> > +	if (xdp_prog) {
> > +		u32 ret;
> > +
> > +		ret =3D mvneta_run_xdp(pp, rxq, xdp_prog, xdp);
> > +		if (ret !=3D MVNETA_XDP_PASS) {
> > +			mvneta_update_stats(pp, 1,
> > +					    xdp->data_end - xdp->data,
>=20
> Good, you took into account that data_len cannot be used, as BPF/XDP prog=
ram could have changed data pointer, thus affecting the length.
>=20
> > +					    false);
> > +			rx_desc->buf_phys_addr =3D 0;
> > +			*xdp_ret |=3D ret;
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	rxq->skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> >  	if (unlikely(!rxq->skb)) {
> >  		netdev_err(dev,
> >  			   "Can't allocate skb on queue %d\n",
> > @@ -1985,8 +2054,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >  	}
> >  	page_pool_release_page(rxq->page_pool, page);
> > =20
> > -	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
> > -	skb_put(rxq->skb, data_len);
> > +	skb_reserve(rxq->skb,
> > +		    xdp->data - xdp->data_hard_start);
> > +	skb_put(rxq->skb, xdp->data_end - xdp->data);
> >  	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
> > =20
> >  	rxq->left_size =3D rx_desc->data_size - len;
> > @@ -2020,7 +2090,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *p=
p,
> >  		/* refill descriptor with new buffer later */
> >  		skb_add_rx_frag(rxq->skb,
> >  				skb_shinfo(rxq->skb)->nr_frags,
> > -				page, NET_SKB_PAD, data_len,
> > +				page, MVNETA_SKB_HEADROOM, data_len,
> >  				PAGE_SIZE);
> >  	}
> >  	page_pool_release_page(rxq->page_pool, page);
> > @@ -2035,10 +2105,17 @@ static int mvneta_rx_swbm(struct napi_struct *n=
api,
> >  {
> >  	int rcvd_pkts =3D 0, rcvd_bytes =3D 0;
> >  	int rx_pending, refill, done =3D 0;
> > +	struct bpf_prog *xdp_prog;
> > +	struct xdp_buff xdp_buf;
> > +	u32 xdp_ret =3D 0;
> > =20
> >  	/* Get number of received packets */
> >  	rx_pending =3D mvneta_rxq_busy_desc_num_get(pp, rxq);
> > =20
> > +	rcu_read_lock();
> > +	xdp_prog =3D READ_ONCE(pp->xdp_prog);
> > +	xdp_buf.rxq =3D &rxq->xdp_rxq;
>=20
> Ok, thanks for following my review comments from last.
>=20
> >  	/* Fairness NAPI loop */
> >  	while (done < budget && done < rx_pending) {
> >  		struct mvneta_rx_desc *rx_desc =3D mvneta_rxq_next_desc_get(rxq);
> > @@ -2066,7 +2143,8 @@ static int mvneta_rx_swbm(struct napi_struct *nap=
i,
> >  				continue;
> >  			}
> > =20
> > -			err =3D mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
> > +			err =3D mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
> > +						   xdp_prog, page, &xdp_ret);
> >  			if (err)
> >  				continue;
> >  		} else {
> > @@ -2101,6 +2179,10 @@ static int mvneta_rx_swbm(struct napi_struct *na=
pi,
> >  		/* clean uncomplete skb pointer in queue */
> >  		rxq->skb =3D NULL;
> >  	}
> > +	rcu_read_unlock();
> > +
> > +	if (xdp_ret & MVNETA_XDP_REDIR)
> > +		xdp_do_flush_map();
> > =20
> >  	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
> > =20
> [...]
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXaR3pgAKCRA6cBh0uS2t
rN/1AP9VHzlOeJDdT/iXZqLuJswNRb1JySD2naj/ER+yku0LoAD9FoUY94vEYKD8
hS+S3NfzZ9YeR81dVWO6EVt0pmBX5go=
=2YFx
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
