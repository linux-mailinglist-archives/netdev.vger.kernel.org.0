Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97B218FB87
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCWRbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgCWRbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:31:22 -0400
Received: from lore-desk-wlan (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E09520714;
        Mon, 23 Mar 2020 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584984680;
        bh=cao6x/2GRIv2BaS34bjyY5xXwNeZprPivjUM68sZWXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvwaK9APQNXKMqY0GeOFYpVhgrOX/cIWR7qFGM/1d+6fdtoL98rXeIX9Gdt/HSPXJ
         JmiGdbmugX0lb8R3bvmmlppg5NQkrYTpmp5Eg9yLBKUJRaNr7ISKvMllMoNxkri8Pm
         xURGxby4ShQERVvk+M3s8w1gdMYLC0vUQp6Uj8k0=
Date:   Mon, 23 Mar 2020 18:31:13 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
Message-ID: <20200323173113.GA300262@lore-desk-wlan>
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
 <20200320133737.GA2329672@lore-desk-wlan>
 <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
 <20200321143013.GA3251815@lore-desk-wlan>
 <d8ccb8c7-0501-dc88-d2b2-ca594df885cb@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <d8ccb8c7-0501-dc88-d2b2-ca594df885cb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2020/03/21 23:30, Lorenzo Bianconi wrote:
> > > On 2020/03/20 22:37, Lorenzo Bianconi wrote:
> > > > > On 2020/03/20 1:41, Lorenzo Bianconi wrote:

[...]

> As veth_xdp_xmit really does not use tx queue but select peer rxq directl=
y,
> per_cpu sounds more appropriate than per-queue.
> One concern is consistency. Per-queue rx stats and per-cpu tx stats (or o=
nly
> sum of them?) looks inconsistent.
> One alternative way is to change the queue selection login in veth_xdp_xm=
it
> and select txq instead of rxq. Then select peer rxq from txq, like
> veth_xmit. Accounting per queue tx stats is possible only when we can
> determine which txq is used.
>=20
> Something like this:
>=20
> static int veth_select_txq(struct net_device *dev)
> {
> 	return smp_processor_id() % dev->real_num_tx_queues;
> }
>=20
> static int veth_xdp_xmit(struct net_device *dev, int n,
> 			 struct xdp_frame **frames, u32 flags)
> {
> 	...
> 	txq =3D veth_select_txq(dev);
> 	rcv_rxq =3D txq; // 1-to-1 mapping from txq to peer rxq
> 	// Note: when XDP is enabled on rcv, this condition is always false
> 	if (rcv_rxq >=3D rcv->real_num_rx_queues)
> 		return -ENXIO;
> 	rcv_priv =3D netdev_priv(rcv);
> 	rq =3D &rcv_priv->rq[rcv_rxq];
> 	...
> 	// account txq stats in some way here
> }

actually I have a different idea..what about account tx stats on the peer rx
queue as a result of XDP_TX or ndo_xdp_xmit and properly report this info in
the ethool stats? In this way we do not have any locking issue and we still=
 use
the per-queue stats approach. Could you please take a look to the following=
 patch?

Regards,
Lorenzo

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b6505a6c7102..f2acd2ee6287 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -92,17 +92,22 @@ struct veth_q_stat_desc {
 static const struct veth_q_stat_desc veth_rq_stats_desc[] =3D {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
-	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
-	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
-	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
-	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
-	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
-	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
-	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
+	{ "drops",		VETH_RQ_STAT(rx_drops) },
+	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
+	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
 };
=20
 #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
=20
+static const struct veth_q_stat_desc veth_tq_stats_desc[] =3D {
+	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
+	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
+	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
+	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
+};
+
+#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
+
 static struct {
 	const char string[ETH_GSTRING_LEN];
 } ethtool_stats_keys[] =3D {
@@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device *dev, u=
32 stringset, u8 *buf)
 				p +=3D ETH_GSTRING_LEN;
 			}
 		}
+		for (i =3D 0; i < dev->real_num_tx_queues; i++) {
+			for (j =3D 0; j < VETH_TQ_STATS_LEN; j++) {
+				snprintf(p, ETH_GSTRING_LEN,
+					 "tx_queue_%u_%.18s",
+					 i, veth_tq_stats_desc[j].desc);
+				p +=3D ETH_GSTRING_LEN;
+			}
+		}
 		break;
 	}
 }
@@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_device *dev, =
int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(ethtool_stats_keys) +
-		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
+		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
+		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_device *dev, =
int sset)
 static void veth_get_ethtool_stats(struct net_device *dev,
 		struct ethtool_stats *stats, u64 *data)
 {
-	struct veth_priv *priv =3D netdev_priv(dev);
+	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
 	struct net_device *peer =3D rtnl_dereference(priv->peer);
 	int i, j, idx;
=20
@@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_device *=
dev,
 		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
 		idx +=3D VETH_RQ_STATS_LEN;
 	}
+
+	if (!peer)
+		return;
+
+	rcv_priv =3D netdev_priv(peer);
+	for (i =3D 0; i < peer->real_num_rx_queues; i++) {
+		const struct veth_rq_stats *rq_stats =3D &rcv_priv->rq[i].stats;
+		const void *stats_base =3D (void *)&rq_stats->vs;
+		unsigned int start, tx_idx;
+		size_t offset;
+
+		tx_idx =3D (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
+		do {
+			start =3D u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			for (j =3D 0; j < VETH_TQ_STATS_LEN; j++) {
+				offset =3D veth_tq_stats_desc[j].offset;
+				data[tx_idx + idx + j] +=3D *(u64 *)(stats_base + offset);
+			}
+		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+	}
 }
=20
 static const struct ethtool_ops veth_ethtool_ops =3D {
@@ -340,8 +374,7 @@ static void veth_get_stats64(struct net_device *dev,
 	tot->tx_packets =3D packets;
=20
 	veth_stats_rx(&rx, dev);
-	tot->tx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
-	tot->rx_dropped =3D rx.rx_drops;
+	tot->rx_dropped =3D rx.rx_drops + rx.xdp_tx_err + rx.xdp_xmit_err;
 	tot->rx_bytes =3D rx.xdp_bytes;
 	tot->rx_packets =3D rx.xdp_packets;
=20
@@ -353,7 +386,7 @@ static void veth_get_stats64(struct net_device *dev,
 		tot->rx_packets +=3D packets;
=20
 		veth_stats_rx(&rx, peer);
-		tot->rx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
+		tot->tx_dropped +=3D rx.xdp_xmit_err + rx.xdp_tx_err;
 		tot->tx_bytes +=3D rx.xdp_bytes;
 		tot->tx_packets +=3D rx.xdp_packets;
 	}
@@ -394,9 +427,9 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 			 u32 flags, bool ndo_xmit)
 {
 	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
-	unsigned int qidx, max_len;
 	struct net_device *rcv;
 	int i, ret, drops =3D n;
+	unsigned int max_len;
 	struct veth_rq *rq;
=20
 	rcu_read_lock();
@@ -414,8 +447,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	}
=20
 	rcv_priv =3D netdev_priv(rcv);
-	qidx =3D veth_select_rxq(rcv);
-	rq =3D &rcv_priv->rq[qidx];
+	rq =3D &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
 	 * side. This means an XDP program is loaded on the peer and the peer
 	 * device is up.
@@ -446,7 +478,6 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
=20
 	ret =3D n - drops;
 drop:
-	rq =3D &priv->rq[qidx];
 	u64_stats_update_begin(&rq->stats.syncp);
 	if (ndo_xmit) {
 		rq->stats.vs.xdp_xmit +=3D n - drops;

>=20
> Thoughts?
>=20
> Toshiaki Makita

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXnjyXgAKCRA6cBh0uS2t
rFdDAP4zFjl4X5Az/CoQBmnLy0/ImHykn3Af7jskuTzT8qoZvAEAtgti/8zQf7QP
bdZz03Dxv8eYkZCZPf6PYS6wvLKwdQo=
=Jyty
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
