Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87283BB2AE
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 13:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfIWLPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 07:15:04 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59377 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfIWLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 07:15:04 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iCMJ1-0001Jv-VU; Mon, 23 Sep 2019 13:14:59 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1iCMJ0-0004hv-Kq; Mon, 23 Sep 2019 13:14:58 +0200
Date:   Mon, 23 Sep 2019 13:14:58 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Laura Abbott <labbott@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arcnet: provide a buffer big enough to actually receive
 packets
Message-ID: <20190923111458.dwmnyiy4nxvgogv2@pengutronix.de>
References: <20190920140821.11876-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ayy3pnn6f3ltnwxl"
Content-Disposition: inline
In-Reply-To: <20190920140821.11876-1-u.kleine-koenig@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:14:11 up 77 days, 17:24, 91 users,  load average: 0.10, 0.11,
 0.14
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ayy3pnn6f3ltnwxl
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2019 at 04:08:21PM +0200, Uwe Kleine-K=F6nig wrote:
> struct archdr is only big enough to hold the header of various types of
> arcnet packets. So to provide enough space to hold the data read from
> hardware provide a buffer large enough to hold a packet with maximal
> size.
>=20
> The problem was noticed by the stack protector which makes the kernel
> oops.
>=20
> Cc: stable@vger.kernel.org # v2.4.0+
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

> ---
> Hello,
>=20
> the problem exists in v2.4.0 already, I didn't look further to identify
> the offending commit.
>=20
> Best regards
> Uwe
> ---
>  drivers/net/arcnet/arcnet.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
> index 0efef7aa5b89..2b8cf58e4de0 100644
> --- a/drivers/net/arcnet/arcnet.c
> +++ b/drivers/net/arcnet/arcnet.c
> @@ -1063,31 +1063,34 @@ EXPORT_SYMBOL(arcnet_interrupt);
>  static void arcnet_rx(struct net_device *dev, int bufnum)
>  {
>  	struct arcnet_local *lp =3D netdev_priv(dev);
> -	struct archdr pkt;
> +	union {
> +		struct archdr pkt;
> +		char buf[512];
> +	} rxdata;
>  	struct arc_rfc1201 *soft;
>  	int length, ofs;
> =20
> -	soft =3D &pkt.soft.rfc1201;
> +	soft =3D &rxdata.pkt.soft.rfc1201;
> =20
> -	lp->hw.copy_from_card(dev, bufnum, 0, &pkt, ARC_HDR_SIZE);
> -	if (pkt.hard.offset[0]) {
> -		ofs =3D pkt.hard.offset[0];
> +	lp->hw.copy_from_card(dev, bufnum, 0, &rxdata.pkt, ARC_HDR_SIZE);
> +	if (rxdata.pkt.hard.offset[0]) {
> +		ofs =3D rxdata.pkt.hard.offset[0];
>  		length =3D 256 - ofs;
>  	} else {
> -		ofs =3D pkt.hard.offset[1];
> +		ofs =3D rxdata.pkt.hard.offset[1];
>  		length =3D 512 - ofs;
>  	}
> =20
>  	/* get the full header, if possible */
> -	if (sizeof(pkt.soft) <=3D length) {
> -		lp->hw.copy_from_card(dev, bufnum, ofs, soft, sizeof(pkt.soft));
> +	if (sizeof(rxdata.pkt.soft) <=3D length) {
> +		lp->hw.copy_from_card(dev, bufnum, ofs, soft, sizeof(rxdata.pkt.soft));
>  	} else {
> -		memset(&pkt.soft, 0, sizeof(pkt.soft));
> +		memset(&rxdata.pkt.soft, 0, sizeof(rxdata.pkt.soft));
>  		lp->hw.copy_from_card(dev, bufnum, ofs, soft, length);
>  	}
> =20
>  	arc_printk(D_DURING, dev, "Buffer #%d: received packet from %02Xh to %0=
2Xh (%d+4 bytes)\n",
> -		   bufnum, pkt.hard.source, pkt.hard.dest, length);
> +		   bufnum, rxdata.pkt.hard.source, rxdata.pkt.hard.dest, length);
> =20
>  	dev->stats.rx_packets++;
>  	dev->stats.rx_bytes +=3D length + ARC_HDR_SIZE;
> @@ -1096,13 +1099,13 @@ static void arcnet_rx(struct net_device *dev, int=
 bufnum)
>  	if (arc_proto_map[soft->proto]->is_ip) {
>  		if (BUGLVL(D_PROTO)) {
>  			struct ArcProto
> -			*oldp =3D arc_proto_map[lp->default_proto[pkt.hard.source]],
> +			*oldp =3D arc_proto_map[lp->default_proto[rxdata.pkt.hard.source]],
>  			*newp =3D arc_proto_map[soft->proto];
> =20
>  			if (oldp !=3D newp) {
>  				arc_printk(D_PROTO, dev,
>  					   "got protocol %02Xh; encap for host %02Xh is now '%c' (was '%c')=
\n",
> -					   soft->proto, pkt.hard.source,
> +					   soft->proto, rxdata.pkt.hard.source,
>  					   newp->suffix, oldp->suffix);
>  			}
>  		}
> @@ -1111,10 +1114,10 @@ static void arcnet_rx(struct net_device *dev, int=
 bufnum)
>  		lp->default_proto[0] =3D soft->proto;
> =20
>  		/* in striking contrast, the following isn't a hack. */
> -		lp->default_proto[pkt.hard.source] =3D soft->proto;
> +		lp->default_proto[rxdata.pkt.hard.source] =3D soft->proto;
>  	}
>  	/* call the protocol-specific receiver. */
> -	arc_proto_map[soft->proto]->rx(dev, bufnum, &pkt, length);
> +	arc_proto_map[soft->proto]->rx(dev, bufnum, &rxdata.pkt, length);
>  }
> =20
>  static void null_rx(struct net_device *dev, int bufnum,
> --=20
> 2.23.0
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ayy3pnn6f3ltnwxl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl2IqS8ACgkQC+njFXoe
LGTvdA/+KZfqsYYDLcjxCnxpxvzHXIdVUkrg5fx5o8dwOTrrKqn2+sQvT5ht+N9w
8zZ/WJc0s/9gMGRQsFTrMtxr+Ga20Ylh7Me6e3dtGgVsbe/irQL6xPNEytdrds1+
22+F2NHOavJc8OYDleunth+McgrgFXtbtr2l+l3xe+nCgNQvAq0djyiF8kG2LrRh
kLIX73PBypMRQ7c7R2m2pBcs+rVA6xNZ76QMGaTMNcD1aLJb1b4Eckq8ZFTrUeCy
97eSpxuPH9xCgpeYKxtY6bBIidifB/1PqwU+1BsbIViPUdYI5+f/snYNopdF4nF4
MYUY/cKvPf307Wpy3Oql+ibf1qZOTdj6ocIY+c1SjIBd8Do4VGCl5jaG26y95g+h
akEs4bP1/0l92LHXHWndQOPyE3N3OegzEiJs0jUMiXwhPNdirLbaLB/D6h+bRwVI
+6V587A0Uv23FiK/1KNWryMPMGE7GqsnE3ytVLhBeKzcLY9mJjAosN280PoPNfUE
WX5KCXdaMheV1kiH/kZmD0zu3vad24O0348kDhkWsq0dhX179zOBMcxtIxiZjRgc
solPrpDhjubIe01C11qNMJBm6ZSr/7P0uX6PGdVd4QVuI0XnBtp/tBy3Tj/f7Znz
V+ilkI8WODp/9md01tH5lB18iInG5mYYkCosbg6Oy0QJe+CRa2o=
=UhZK
-----END PGP SIGNATURE-----

--ayy3pnn6f3ltnwxl--
