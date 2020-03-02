Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83E2175CA6
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCBONS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 09:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgCBONS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 09:13:18 -0500
Received: from lore-desk-wlan (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F4B2080C;
        Mon,  2 Mar 2020 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158397;
        bh=Cq3mXNnU6SEGy1QJQk3Nc9ESdUKuq8VZoXOzmjrlv9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UpvzpEnRCJ829cLNBLvziNlpjTzWI+LlB2hzq1xXpbV/CHajih58v3T2HpYuWH38Q
         ExaSR6K7dj/yq4bbwzsq2b3cWGvqRPpKbVO+lAbZ4Brlqt7VPhgcFDWoGdRlv9yeoG
         LIfSlAFC6u47RNzcQGnhoLTqCGzQWFX4bTe2hTkw=
Date:   Mon, 2 Mar 2020 15:13:05 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        David Ahern <dsahern@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, kuba@kernel.org,
        andrew@lunn.ch, thomas.petazzoni@bootlin.com
Subject: Re: [net-next PATCH] mvneta: add XDP ethtool errors stats for TX to
 driver
Message-ID: <20200302141305.GD1391852@lore-desk-wlan>
References: <158315678810.1983667.11239367181663328821.stgit@firesoul>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Content-Disposition: inline
In-Reply-To: <158315678810.1983667.11239367181663328821.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Adding ethtool stats for when XDP transmitted packets overrun the TX
> queue. This is recorded separately for XDP_TX and ndo_xdp_xmit. This
> is an important aid for troubleshooting XDP based setups.
>=20
> It is currently a known weakness and property of XDP that there isn't
> any push-back or congestion feedback when transmitting frames via XDP.
> It's easy to realise when redirecting from a higher speed link into a
> slower speed link, or simply two ingress links into a single egress.
> The situation can also happen when Ethernet flow control is active.
>=20
> For testing the patch and provoking the situation to occur on my
> Espressobin board, I configured the TX-queue to be smaller (434) than
> RX-queue (512) and overload network with large MTU size frames (as a
> larger frame takes longer to transmit).
>=20
> Hopefully the upcoming XDP TX hook can be extended to provide insight
> into these TX queue overflows, to allow programmable adaptation
> strategies.
>=20
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

This was on my ToDo list, thx for working on this :)

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/ethernet/marvell/mvneta.c |   30 ++++++++++++++++++++++++++-=
---
>  1 file changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index b22eeb5f8700..bc488e8b8e45 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -344,8 +344,10 @@ enum {
>  	ETHTOOL_XDP_REDIRECT,
>  	ETHTOOL_XDP_PASS,
>  	ETHTOOL_XDP_DROP,
> -	ETHTOOL_XDP_XMIT,
>  	ETHTOOL_XDP_TX,
> +	ETHTOOL_XDP_TX_ERR,
> +	ETHTOOL_XDP_XMIT,
> +	ETHTOOL_XDP_XMIT_ERR,
>  	ETHTOOL_MAX_STATS,
>  };
> =20
> @@ -404,7 +406,9 @@ static const struct mvneta_statistic mvneta_statistic=
s[] =3D {
>  	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
>  	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
>  	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
> +	{ ETHTOOL_XDP_TX_ERR, T_SW, "rx_xdp_tx_errors", },
>  	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
> +	{ ETHTOOL_XDP_XMIT_ERR, T_SW, "tx_xdp_xmit_errors", },
>  };
> =20
>  struct mvneta_stats {
> @@ -417,7 +421,9 @@ struct mvneta_stats {
>  	u64	xdp_pass;
>  	u64	xdp_drop;
>  	u64	xdp_xmit;
> +	u64	xdp_xmit_err;
>  	u64	xdp_tx;
> +	u64	xdp_tx_err;
>  };
> =20
>  struct mvneta_ethtool_stats {
> @@ -2059,6 +2065,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, str=
uct mvneta_tx_queue *txq,
>  static int
>  mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
>  {
> +	struct mvneta_pcpu_stats *stats =3D this_cpu_ptr(pp->stats);
>  	struct mvneta_tx_queue *txq;
>  	struct netdev_queue *nq;
>  	struct xdp_frame *xdpf;
> @@ -2076,8 +2083,6 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct=
 xdp_buff *xdp)
>  	__netif_tx_lock(nq, cpu);
>  	ret =3D mvneta_xdp_submit_frame(pp, txq, xdpf, false);
>  	if (ret =3D=3D MVNETA_XDP_TX) {
> -		struct mvneta_pcpu_stats *stats =3D this_cpu_ptr(pp->stats);
> -
>  		u64_stats_update_begin(&stats->syncp);
>  		stats->es.ps.tx_bytes +=3D xdpf->len;
>  		stats->es.ps.tx_packets++;
> @@ -2085,6 +2090,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struc=
t xdp_buff *xdp)
>  		u64_stats_update_end(&stats->syncp);
> =20
>  		mvneta_txq_pend_desc_add(pp, txq, 0);
> +	} else {
> +		u64_stats_update_begin(&stats->syncp);
> +		stats->es.ps.xdp_tx_err++;
> +		u64_stats_update_end(&stats->syncp);
>  	}
>  	__netif_tx_unlock(nq);
> =20
> @@ -2128,6 +2137,7 @@ mvneta_xdp_xmit(struct net_device *dev, int num_fra=
me,
>  	stats->es.ps.tx_bytes +=3D nxmit_byte;
>  	stats->es.ps.tx_packets +=3D nxmit;
>  	stats->es.ps.xdp_xmit +=3D nxmit;
> +	stats->es.ps.xdp_xmit_err +=3D num_frame - nxmit;
>  	u64_stats_update_end(&stats->syncp);
> =20
>  	return nxmit;
> @@ -2152,7 +2162,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvnet=
a_rx_queue *rxq,
>  		int err;
> =20
>  		err =3D xdp_do_redirect(pp->dev, xdp, prog);
> -		if (err) {
> +		if (unlikely(err)) {
>  			ret =3D MVNETA_XDP_DROPPED;
>  			page_pool_put_page(rxq->page_pool,
>  					   virt_to_head_page(xdp->data), len,
> @@ -4518,6 +4528,8 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port=
 *pp,
>  		u64 skb_alloc_error;
>  		u64 refill_error;
>  		u64 xdp_redirect;
> +		u64 xdp_xmit_err;
> +		u64 xdp_tx_err;
>  		u64 xdp_pass;
>  		u64 xdp_drop;
>  		u64 xdp_xmit;
> @@ -4532,7 +4544,9 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port=
 *pp,
>  			xdp_pass =3D stats->es.ps.xdp_pass;
>  			xdp_drop =3D stats->es.ps.xdp_drop;
>  			xdp_xmit =3D stats->es.ps.xdp_xmit;
> +			xdp_xmit_err =3D stats->es.ps.xdp_xmit_err;
>  			xdp_tx =3D stats->es.ps.xdp_tx;
> +			xdp_tx_err =3D stats->es.ps.xdp_tx_err;
>  		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> =20
>  		es->skb_alloc_error +=3D skb_alloc_error;
> @@ -4541,7 +4555,9 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port=
 *pp,
>  		es->ps.xdp_pass +=3D xdp_pass;
>  		es->ps.xdp_drop +=3D xdp_drop;
>  		es->ps.xdp_xmit +=3D xdp_xmit;
> +		es->ps.xdp_xmit_err +=3D xdp_xmit_err;
>  		es->ps.xdp_tx +=3D xdp_tx;
> +		es->ps.xdp_tx_err +=3D xdp_tx_err;
>  	}
>  }
> =20
> @@ -4594,9 +4610,15 @@ static void mvneta_ethtool_update_stats(struct mvn=
eta_port *pp)
>  			case ETHTOOL_XDP_TX:
>  				pp->ethtool_stats[i] =3D stats.ps.xdp_tx;
>  				break;
> +			case ETHTOOL_XDP_TX_ERR:
> +				pp->ethtool_stats[i] =3D stats.ps.xdp_tx_err;
> +				break;
>  			case ETHTOOL_XDP_XMIT:
>  				pp->ethtool_stats[i] =3D stats.ps.xdp_xmit;
>  				break;
> +			case ETHTOOL_XDP_XMIT_ERR:
> +				pp->ethtool_stats[i] =3D stats.ps.xdp_xmit_err;
> +				break;
>  			}
>  			break;
>  		}
>=20
>=20

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXl0UbwAKCRA6cBh0uS2t
rMqcAQCNMJegf9ZLWFR9rbkHEFXRcx0j+fXBPOVB2aasN420BAD9F3jcqF+VRs8M
0dnQ/LPkxJSsOR2w2lcN7/cngwR+NAc=
=RQ+r
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
