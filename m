Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABE544555
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbiFIIHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiFIIHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:07:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6743584A
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:07:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzDCQ-0005Kt-3M; Thu, 09 Jun 2022 10:07:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B728C8FD63;
        Thu,  9 Jun 2022 08:07:24 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:07:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 03/13] can: slcan: use the alloc_can_skb() helper
Message-ID: <20220609080724.z2ouwivtgu36b423@pengutronix.de>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
 <20220608165116.1575390-4-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="atjba7zcmgsgdmzd"
Content-Disposition: inline
In-Reply-To: <20220608165116.1575390-4-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--atjba7zcmgsgdmzd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.06.2022 18:51:06, Dario Binacchi wrote:
> It is used successfully by most (if not all) CAN device drivers. It
> allows to remove replicated code.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
> Changes in v2:
> - Put the data into the allocated skb directly instead of first
>   filling the "cf" on the stack and then doing a memcpy().
>=20
>  drivers/net/can/slcan.c | 69 +++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 6162a9c21672..5d87e25e2285 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -54,6 +54,7 @@
>  #include <linux/kernel.h>
>  #include <linux/workqueue.h>
>  #include <linux/can.h>
> +#include <linux/can/dev.h>
>  #include <linux/can/skb.h>
>  #include <linux/can/can-ml.h>
> =20
> @@ -143,85 +144,79 @@ static struct net_device **slcan_devs;
>  static void slc_bump(struct slcan *sl)
>  {
>  	struct sk_buff *skb;
> -	struct can_frame cf;
> +	struct can_frame *cf;
>  	int i, tmp;
>  	u32 tmpid;
>  	char *cmd =3D sl->rbuff;
> =20
> -	memset(&cf, 0, sizeof(cf));
> +	skb =3D alloc_can_skb(sl->dev, &cf);
> +	if (unlikely(!skb)) {
> +		sl->dev->stats.rx_dropped++;
> +		return;
> +	}
> =20
>  	switch (*cmd) {
>  	case 'r':
> -		cf.can_id =3D CAN_RTR_FLAG;
> +		cf->can_id =3D CAN_RTR_FLAG;
>  		fallthrough;
>  	case 't':
>  		/* store dlc ASCII value and terminate SFF CAN ID string */
> -		cf.len =3D sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
> +		cf->len =3D sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
>  		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] =3D 0;
>  		/* point to payload data behind the dlc */
>  		cmd +=3D SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
>  		break;
>  	case 'R':
> -		cf.can_id =3D CAN_RTR_FLAG;
> +		cf->can_id =3D CAN_RTR_FLAG;
>  		fallthrough;
>  	case 'T':
> -		cf.can_id |=3D CAN_EFF_FLAG;
> +		cf->can_id |=3D CAN_EFF_FLAG;
>  		/* store dlc ASCII value and terminate EFF CAN ID string */
> -		cf.len =3D sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
> +		cf->len =3D sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
>  		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] =3D 0;
>  		/* point to payload data behind the dlc */
>  		cmd +=3D SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
>  		break;
>  	default:
> -		return;
> +		goto decode_failed;
>  	}
> =20
>  	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
> -		return;
> +		goto decode_failed;
> =20
> -	cf.can_id |=3D tmpid;
> +	cf->can_id |=3D tmpid;
> =20
>  	/* get len from sanitized ASCII value */
> -	if (cf.len >=3D '0' && cf.len < '9')
> -		cf.len -=3D '0';
> +	if (cf->len >=3D '0' && cf->len < '9')
> +		cf->len -=3D '0';
>  	else
> -		return;
> +		goto decode_failed;
> =20
>  	/* RTR frames may have a dlc > 0 but they never have any data bytes */
> -	if (!(cf.can_id & CAN_RTR_FLAG)) {
> -		for (i =3D 0; i < cf.len; i++) {
> +	if (!(cf->can_id & CAN_RTR_FLAG)) {
> +		for (i =3D 0; i < cf->len; i++) {
>  			tmp =3D hex_to_bin(*cmd++);
>  			if (tmp < 0)
> -				return;
> -			cf.data[i] =3D (tmp << 4);
> +				goto decode_failed;
> +
> +			cf->data[i] =3D (tmp << 4);
>  			tmp =3D hex_to_bin(*cmd++);
>  			if (tmp < 0)
> -				return;
> -			cf.data[i] |=3D tmp;
> +				goto decode_failed;
> +
> +			cf->data[i] |=3D tmp;
>  		}
>  	}
> =20
> -	skb =3D dev_alloc_skb(sizeof(struct can_frame) +
> -			    sizeof(struct can_skb_priv));
> -	if (!skb)
> -		return;
> -
> -	skb->dev =3D sl->dev;
> -	skb->protocol =3D htons(ETH_P_CAN);
> -	skb->pkt_type =3D PACKET_BROADCAST;
> -	skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> -
> -	can_skb_reserve(skb);
> -	can_skb_prv(skb)->ifindex =3D sl->dev->ifindex;
> -	can_skb_prv(skb)->skbcnt =3D 0;
> -
> -	skb_put_data(skb, &cf, sizeof(struct can_frame));
> -
>  	sl->dev->stats.rx_packets++;
> -	if (!(cf.can_id & CAN_RTR_FLAG))
> -		sl->dev->stats.rx_bytes +=3D cf.len;
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		sl->dev->stats.rx_bytes +=3D cf->len;
> =20
>  	netif_rx(skb);
> +	return;
> +
> +decode_failed:
> +	dev_kfree_skb(skb);

Can you increase an error counter in this situation, too?

Marc

>  }
> =20
>  /* parse tty input stream */
> --=20
> 2.32.0
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--atjba7zcmgsgdmzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhqjkACgkQrX5LkNig
013HUAgAqNyG+WGjiiRutxQFcDB8sjKXLB7vK7+Nxuo1idJ6Ez84UYz7yXxBNub4
Tj9sLTzWmBocBoRVYOM5shThBLKYABOTJjpU90EyjtsaecGWzZ31GVmtfx95vVFK
JDMHZP0yQZ45315d0P1/U+XV6uK03MMoUwKvb1fw0dKZ14ZhCgJrHK13n5uvX/by
Sz8uHCJlp1X2u/ULoNFJLyFFBZt6zSQnh9dOC7Qfq612QzxZZ51mfkQjUwIvsuNx
fwFav+zthhYOkJZdwcJpTp7ChuHxAuhFF3WTXJI6hMTpVdNDTJaFsVtzjkwz7faF
HZsSgWXZQ2ASFS1epIjNbjb1yiQ6rg==
=bf3D
-----END PGP SIGNATURE-----

--atjba7zcmgsgdmzd--
