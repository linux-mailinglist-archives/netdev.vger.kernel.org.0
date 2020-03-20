Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D0C18CF17
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCTNh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgCTNh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 09:37:56 -0400
Received: from lore-desk-wlan (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF21420739;
        Fri, 20 Mar 2020 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584711475;
        bh=8wp4LU1MstjDo1Pmu5MK6tC7fEFgulhsQLpBe2xgYo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WDZuDkBMn/qCKnJ4lUZWu+0KTuDeEzJfgA6qMYXc6Q3JTlDgUPyFNAl1QxVPH7+q8
         rfuuKEQ4DvEg1dfvHQsA/L43K0vzZY/75URc12cbVeMVfmff2iBDMAyk9EDW97HSTE
         SeO6DoSAMOIEQ9ATWn2K0TyBu3Vsp7R2Q+LDNB98=
Date:   Fri, 20 Mar 2020 14:37:37 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
Message-ID: <20200320133737.GA2329672@lore-desk-wlan>
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2020/03/20 1:41, Lorenzo Bianconi wrote:
> > Introduce xdp_xmit counter in order to distinguish between XDP_TX and
> > ndo_xdp_xmit stats. Introduce the following ethtool counters:
> > - rx_xdp_tx
> > - rx_xdp_tx_errors
> > - tx_xdp_xmit
> > - tx_xdp_xmit_errors
> > - rx_xdp_redirect
>=20
> Thank you for working on this!
>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> ...
> > @@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev, in=
t n,
> >   	}
> >   	rcv_priv =3D netdev_priv(rcv);
> > -	rq =3D &rcv_priv->rq[veth_select_rxq(rcv)];
> > +	qidx =3D veth_select_rxq(rcv);
> > +	rq =3D &rcv_priv->rq[qidx];
> >   	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
> >   	 * side. This means an XDP program is loaded on the peer and the peer
> >   	 * device is up.
> > @@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *dev, i=
nt n,
> >   	if (flags & XDP_XMIT_FLUSH)
> >   		__veth_xdp_flush(rq);
> > +	rq =3D &priv->rq[qidx];
>=20
> I think there is no guarantee that this rq exists. Qidx is less than
> rcv->real_num_rx_queues, but not necessarily less than
> dev->real_num_rx_queues.
>=20
> > +	u64_stats_update_begin(&rq->stats.syncp);
>=20
> So this can cuase NULL pointer dereference.

oh right, thanks for spotting this.
I think we can recompute qidx for tx netdevice in this case, doing something
like:

qidx =3D veth_select_rxq(dev);
rq =3D &priv->rq[qidx];

what do you think?

Regards,
Lorenzo

>=20
> Toshiaki Makita
>=20
> > +	if (ndo_xmit) {
> > +		rq->stats.vs.xdp_xmit +=3D n - drops;
> > +		rq->stats.vs.xdp_xmit_err +=3D drops;
> > +	} else {
> > +		rq->stats.vs.xdp_tx +=3D n - drops;
> > +		rq->stats.vs.xdp_tx_err +=3D drops;
> > +	}
> > +	u64_stats_update_end(&rq->stats.syncp);
> > +
> >   	if (likely(!drops)) {
> >   		rcu_read_unlock();
> >   		return n;
> > @@ -437,11 +458,17 @@ static int veth_xdp_xmit(struct net_device *dev, =
int n,
> >   	return ret;
> >   }
> > +static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
> > +			     struct xdp_frame **frames, u32 flags)
> > +{
> > +	return veth_xdp_xmit(dev, n, frames, flags, true);
> > +}
> > +
> >   static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp=
_tx_bq *bq)
> >   {
> >   	int sent, i, err =3D 0;
> > -	sent =3D veth_xdp_xmit(dev, bq->count, bq->q, 0);
> > +	sent =3D veth_xdp_xmit(dev, bq->count, bq->q, 0, false);
> >   	if (sent < 0) {
> >   		err =3D sent;
> >   		sent =3D 0;
> > @@ -753,6 +780,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int bud=
get,
> >   	}
> >   	u64_stats_update_begin(&rq->stats.syncp);
> > +	rq->stats.vs.xdp_redirect +=3D stats->xdp_redirect;
> >   	rq->stats.vs.xdp_bytes +=3D stats->xdp_bytes;
> >   	rq->stats.vs.xdp_drops +=3D stats->xdp_drops;
> >   	rq->stats.vs.rx_drops +=3D stats->rx_drops;
> > @@ -1172,7 +1200,7 @@ static const struct net_device_ops veth_netdev_op=
s =3D {
> >   	.ndo_features_check	=3D passthru_features_check,
> >   	.ndo_set_rx_headroom	=3D veth_set_rx_headroom,
> >   	.ndo_bpf		=3D veth_xdp,
> > -	.ndo_xdp_xmit		=3D veth_xdp_xmit,
> > +	.ndo_xdp_xmit		=3D veth_ndo_xdp_xmit,
> >   };
> >   #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSU=
M | \
> >=20

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXnTHHQAKCRA6cBh0uS2t
rIS+AP0UD6SZQRjHJjJvVypVJxzpUWhjoWJO/QBYTKmVJ+q80QD9H3dyDyL3NCeC
+gW5GufGUGeEqmOXdjZhau+ZWLUWhAg=
=2ftK
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
