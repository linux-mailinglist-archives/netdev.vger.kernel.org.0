Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935A218E1D5
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 15:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCUOaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 10:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgCUOaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 10:30:20 -0400
Received: from lore-desk-wlan (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48AC20409;
        Sat, 21 Mar 2020 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584801019;
        bh=oxvIvbGRYTOKOqqKKH5yfXFmtngMjzN+EPT+kVjjJ6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=udxn4K6lArFbvEDD9KmXjtTXowyv0U6PFjncVIS5x8zbkksDvx+9jIkZFQ+9lxSrl
         leQ58gGiU68kwyMC6nhxV2hbYDEk5kMBS1Qws0v5MHmKUOBsRYASgU/jGzK9IOAUEw
         qCG0nqXfDS33YtHOG7tmXvGRIk9ClDuOLYG3c9Cc=
Date:   Sat, 21 Mar 2020 15:30:13 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
Message-ID: <20200321143013.GA3251815@lore-desk-wlan>
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
 <20200320133737.GA2329672@lore-desk-wlan>
 <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2020/03/20 22:37, Lorenzo Bianconi wrote:
> > > On 2020/03/20 1:41, Lorenzo Bianconi wrote:
> > > > Introduce xdp_xmit counter in order to distinguish between XDP_TX a=
nd
> > > > ndo_xdp_xmit stats. Introduce the following ethtool counters:
> > > > - rx_xdp_tx
> > > > - rx_xdp_tx_errors
> > > > - tx_xdp_xmit
> > > > - tx_xdp_xmit_errors
> > > > - rx_xdp_redirect
> > >=20
> > > Thank you for working on this!
> > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > ...
> > > > @@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev=
, int n,
> > > >    	}
> > > >    	rcv_priv =3D netdev_priv(rcv);
> > > > -	rq =3D &rcv_priv->rq[veth_select_rxq(rcv)];
> > > > +	qidx =3D veth_select_rxq(rcv);
> > > > +	rq =3D &rcv_priv->rq[qidx];
> > > >    	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on re=
ceive
> > > >    	 * side. This means an XDP program is loaded on the peer and th=
e peer
> > > >    	 * device is up.
> > > > @@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *de=
v, int n,
> > > >    	if (flags & XDP_XMIT_FLUSH)
> > > >    		__veth_xdp_flush(rq);
> > > > +	rq =3D &priv->rq[qidx];
> > >=20
> > > I think there is no guarantee that this rq exists. Qidx is less than
> > > rcv->real_num_rx_queues, but not necessarily less than
> > > dev->real_num_rx_queues.
> > >=20
> > > > +	u64_stats_update_begin(&rq->stats.syncp);
> > >=20
> > > So this can cuase NULL pointer dereference.
> >=20
> > oh right, thanks for spotting this.
> > I think we can recompute qidx for tx netdevice in this case, doing some=
thing
> > like:
> >=20
> > qidx =3D veth_select_rxq(dev);
> > rq =3D &priv->rq[qidx];
> >=20
> > what do you think?
>=20
> This would not cause NULL pointer deref, but I wonder what counters you've
> added mean.
>=20
> - rx_xdp_redirect, rx_xdp_drops, rx_xdp_tx
>=20
> These counters names will be rx_queue_[i]_rx_xdp_[redirect|drops|tx].
> "rx_" in their names looks redundant.

yes, we can drop the "rx" prefix in the stats name for them.

> Also it looks like there is not "rx[i]_xdp_tx" counter but there is
> "rx[i]_xdp_tx_xmit" in mlx5 from this page.
> https://community.mellanox.com/s/article/understanding-mlx5-ethtool-count=
ers

rx[i]_xdp_tx_xmit and rx_xdp_tx are the same, we decided to use rx_xdp_tx f=
or
it since it seems more clear

>=20
> - tx_xdp_xmit, tx_xdp_xmit_errors
>=20
> These counters names will be rx_queue_[i]_tx_xdp_[xmit|xmit_errors].
> Are these rx counters or tx counters?

tx_xdp_xmit[_errors] are used to count ndo_xmit stats so they are tx counte=
rs.
I reused veth_stats for it just for convenience. Probably we can show them =
without
rx suffix so it is clear they are transmitted by the current device.
Another approach would be create per_cput struct to collect all tx stats.
What do you think?

Regards,
Lorenzo

> If tx, currently there is no storage to store these tx counters so adding
> these would not be simple.
> If rx, I guess you should use peer rx queue counters instead of dev rx qu=
eue
> counters.
>=20
> Toshiaki Makita

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXnYk8wAKCRA6cBh0uS2t
rNZRAP0aygnTDutO5Eo/aK5WX62rVeUwHKBD3zqJtsDZ/NvA1QD9HKOuWKqUdcnl
ni1SV5SJjJKZuq8YWee17cZLpkpllQs=
=oGcP
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
