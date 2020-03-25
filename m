Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF589192B87
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgCYOxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgCYOxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 10:53:13 -0400
Received: from lore-desk-wlan (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 858EE208D6;
        Wed, 25 Mar 2020 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585147992;
        bh=DlKVZy4gzl1fDkWDkjTEoYt40YTsFxbNoOGsnTiD2Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mj3LBcbKqaqRD0l3Ez7Hkt2OxRI5FRcBvIFUx2Vbax6pzmLpHbH3wSEHN732E3vrt
         DpyTba4QshBFcS9gQ1iIkR/1GZfQsf9o4iDvYN1FbIR7b8h9oIT0Khhlu98OuQ4nJE
         hcdWhz12WmLd6guSRUQ/kjZVuOag7eZg433IUE4k=
Date:   Wed, 25 Mar 2020 15:53:05 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
Message-ID: <20200325145305.GA79426@lore-desk-wlan>
References: <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
 <20200320133737.GA2329672@lore-desk-wlan>
 <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
 <20200321143013.GA3251815@lore-desk-wlan>
 <d8ccb8c7-0501-dc88-d2b2-ca594df885cb@gmail.com>
 <20200323173113.GA300262@lore-desk-wlan>
 <075a675c-a2c4-7189-9339-c71d53421855@gmail.com>
 <20200324143658.GB1477940@lore-desk-wlan>
 <1d614fdc-3cf1-3558-eb5a-38f16062e57f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1d614fdc-3cf1-3558-eb5a-38f16062e57f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2020/03/24 23:36, Lorenzo Bianconi wrote:

[...]

> > I moved the accounting of xdp_tx/tx_error in veth_xdp_xmit for two reas=
on:
> > 1- veth_xdp_tx in veth_xdp_rcv_one or veth_xdp_rcv_skb returns an error
> >     for XDP_TX just if xdp_frame pointer is invalid but the packet can =
be
> >     discarded in veth_xdp_xmit if the device is 'under-pressure' (and t=
his can
> >     be a problem since in XDP there are no queueing mechanisms so far)
>=20
> Right, but you can track the discard in veth_xdp_flush_bq().
>=20

ack, I guess it is just a matter of passing veth_rq to veth_xdp_flush_bq and
account there for XDP_TX. I will post a patch.

Regards,
Lorenzo

> > 2- to be symmetric  with ndo_xdp_xmit
>=20
> I thought consistency between drivers is more important. What about other=
 drivers?
>=20
> Toshiaki Makita
>=20
> >=20
> > >=20
> > > > +	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
> > > > +	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
> > > > +};
> > > > +
> > > > +#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
> > > > +
> > > >    static struct {
> > > >    	const char string[ETH_GSTRING_LEN];
> > > >    } ethtool_stats_keys[] =3D {
> > > > @@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device=
 *dev, u32 stringset, u8 *buf)
> > > >    				p +=3D ETH_GSTRING_LEN;
> > > >    			}
> > > >    		}
> > > > +		for (i =3D 0; i < dev->real_num_tx_queues; i++) {
> > > > +			for (j =3D 0; j < VETH_TQ_STATS_LEN; j++) {
> > > > +				snprintf(p, ETH_GSTRING_LEN,
> > > > +					 "tx_queue_%u_%.18s",
> > > > +					 i, veth_tq_stats_desc[j].desc);
> > > > +				p +=3D ETH_GSTRING_LEN;
> > > > +			}
> > > > +		}
> > > >    		break;
> > > >    	}
> > > >    }
> > > > @@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_devic=
e *dev, int sset)
> > > >    	switch (sset) {
> > > >    	case ETH_SS_STATS:
> > > >    		return ARRAY_SIZE(ethtool_stats_keys) +
> > > > -		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
> > > > +		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
> > > > +		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
> > > >    	default:
> > > >    		return -EOPNOTSUPP;
> > > >    	}
> > > > @@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_devic=
e *dev, int sset)
> > > >    static void veth_get_ethtool_stats(struct net_device *dev,
> > > >    		struct ethtool_stats *stats, u64 *data)
> > > >    {
> > > > -	struct veth_priv *priv =3D netdev_priv(dev);
> > > > +	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
> > > >    	struct net_device *peer =3D rtnl_dereference(priv->peer);
> > > >    	int i, j, idx;
> > > > @@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_=
device *dev,
> > > >    		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
> > > >    		idx +=3D VETH_RQ_STATS_LEN;
> > > >    	}
> > > > +
> > > > +	if (!peer)
> > > > +		return;
> > > > +
> > > > +	rcv_priv =3D netdev_priv(peer);
> > > > +	for (i =3D 0; i < peer->real_num_rx_queues; i++) {
> > > > +		const struct veth_rq_stats *rq_stats =3D &rcv_priv->rq[i].stats;
> > > > +		const void *stats_base =3D (void *)&rq_stats->vs;
> > > > +		unsigned int start, tx_idx;
> > > > +		size_t offset;
> > > > +
> > > > +		tx_idx =3D (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
> > >=20
> > > I'm a bit concerned that this can fold multiple rx queue counters int=
o one
> > > tx counter. But I cannot think of a better idea provided that we want=
 to
> > > align XDP stats between drivers. So I'm OK with this.
> >=20
> > Since peer->real_num_rx_queues can be greater than dev->real_num_tx_que=
ues,
> > right? IIUC the only guarantee we have is:
> >=20
> > peer->real_num_tx_queues < dev->real_num_rx_queues
> >=20
> > If you are fine with that approach, I will post a patch before net-next
> > closure.
> >=20
> > Regards,
> > Lorenzo
> >=20
> >=20
> > >=20
> > > Toshiaki Makita
> > >=20
> > > > +		do {
> > > > +			start =3D u64_stats_fetch_begin_irq(&rq_stats->syncp);
> > > > +			for (j =3D 0; j < VETH_TQ_STATS_LEN; j++) {
> > > > +				offset =3D veth_tq_stats_desc[j].offset;
> > > > +				data[tx_idx + idx + j] +=3D *(u64 *)(stats_base + offset);
> > > > +			}
> > > > +		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
> > > > +	}
> > > >    }
> > > >    static const struct ethtool_ops veth_ethtool_ops =3D {
> > > > @@ -340,8 +374,7 @@ static void veth_get_stats64(struct net_device =
*dev,
> > > >    	tot->tx_packets =3D packets;
> > > >    	veth_stats_rx(&rx, dev);
> > > > -	tot->tx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
> > > > -	tot->rx_dropped =3D rx.rx_drops;
> > > > +	tot->rx_dropped =3D rx.rx_drops + rx.xdp_tx_err + rx.xdp_xmit_err;
> > > >    	tot->rx_bytes =3D rx.xdp_bytes;
> > > >    	tot->rx_packets =3D rx.xdp_packets;
> > > > @@ -353,7 +386,7 @@ static void veth_get_stats64(struct net_device =
*dev,
> > > >    		tot->rx_packets +=3D packets;
> > > >    		veth_stats_rx(&rx, peer);
> > > > -		tot->rx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
> > > > +		tot->tx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
> > > >    		tot->tx_bytes +=3D rx.xdp_bytes;
> > > >    		tot->tx_packets +=3D rx.xdp_packets;
> > > >    	}
> > > > @@ -394,9 +427,9 @@ static int veth_xdp_xmit(struct net_device *dev=
, int n,
> > > >    			 u32 flags, bool ndo_xmit)
> > > >    {
> > > >    	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
> > > > -	unsigned int qidx, max_len;
> > > >    	struct net_device *rcv;
> > > >    	int i, ret, drops =3D n;
> > > > +	unsigned int max_len;
> > > >    	struct veth_rq *rq;
> > > >    	rcu_read_lock();
> > > > @@ -414,8 +447,7 @@ static int veth_xdp_xmit(struct net_device *dev=
, int n,
> > > >    	}
> > > >    	rcv_priv =3D netdev_priv(rcv);
> > > > -	qidx =3D veth_select_rxq(rcv);
> > > > -	rq =3D &rcv_priv->rq[qidx];
> > > > +	rq =3D &rcv_priv->rq[veth_select_rxq(rcv)];
> > > >    	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on re=
ceive
> > > >    	 * side. This means an XDP program is loaded on the peer and th=
e peer
> > > >    	 * device is up.
> > > > @@ -446,7 +478,6 @@ static int veth_xdp_xmit(struct net_device *dev=
, int n,
> > > >    	ret =3D n - drops;
> > > >    drop:
> > > > -	rq =3D &priv->rq[qidx];
> > > >    	u64_stats_update_begin(&rq->stats.syncp);
> > > >    	if (ndo_xmit) {
> > > >    		rq->stats.vs.xdp_xmit +=3D n - drops;
> > > >=20
> > > > >=20
> > > > > Thoughts?
> > > > >=20
> > > > > Toshiaki Makita

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXntwTAAKCRA6cBh0uS2t
rEaMAQDFxqdWL4ONlI39V5BU6rGcYzteBQBrdLVhcFOYKrCeuQEArRmPKbL/Vh+G
0ZmoQDeuKh4vHnS7zyj7xvUu6EXfXgk=
=flgQ
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
