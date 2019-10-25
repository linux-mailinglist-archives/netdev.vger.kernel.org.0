Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA8E4773
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394364AbfJYJga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:36:30 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35223 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394338AbfJYJg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:36:29 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iNw1C-00038c-To; Fri, 25 Oct 2019 11:36:26 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iNw1C-0005Hw-9E; Fri, 25 Oct 2019 11:36:26 +0200
Date:   Fri, 25 Oct 2019 11:36:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] j1939: transport: make sure EOMA is send with the
 total message size set
Message-ID: <20191025093626.snrkgseuuyjejvbv@pengutronix.de>
References: <20191025093015.24506-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ik6thlozw25533hn"
Content-Disposition: inline
In-Reply-To: <20191025093015.24506-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:32:47 up 160 days, 15:50, 100 users,  load average: 0.17, 0.12,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ik6thlozw25533hn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

i decided to be strict here and drop malformed EOMA packages. At least
it makes testing easier.
I have no idea how far is it from reality. Will it brake some thing?


On Fri, Oct 25, 2019 at 11:30:15AM +0200, Oleksij Rempel wrote:
> We was sending malformed EOMA with total message size set to 0. So, fix t=
his
> bug and add sanity check to the RX path.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  net/can/j1939/transport.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index fe000ea757ea..a82097427642 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1273,9 +1273,27 @@ j1939_xtp_rx_abort(struct j1939_priv *priv, struct=
 sk_buff *skb,
>  static void
>  j1939_xtp_rx_eoma_one(struct j1939_session *session, struct sk_buff *skb)
>  {
> +	struct j1939_sk_buff_cb *skcb =3D j1939_skb_to_cb(skb);
> +	const u8 *dat;
> +	int len;
> +
>  	if (j1939_xtp_rx_cmd_bad_pgn(session, skb))
>  		return;
> =20
> +	dat =3D skb->data;
> +
> +	if (skcb->addr.type =3D=3D J1939_ETP)
> +		len =3D j1939_etp_ctl_to_size(dat);
> +	else
> +		len =3D j1939_tp_ctl_to_size(dat);
> +
> +	if (session->total_message_size !=3D len) {
> +		netdev_warn(session->priv->ndev, "%s: 0x%p: Incorrect size. Expected: =
%i; got: %i.\n",
> +			    __func__, session, session->total_message_size,
> +			    len);
> +		return;
> +	}
> +
>  	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
> =20
>  	session->pkt.tx_acked =3D session->pkt.total;
> @@ -1432,7 +1450,7 @@ j1939_session *j1939_session_fresh_new(struct j1939=
_priv *priv,
>  	skcb =3D j1939_skb_to_cb(skb);
>  	memcpy(skcb, rel_skcb, sizeof(*skcb));
> =20
> -	session =3D j1939_session_new(priv, skb, skb->len);
> +	session =3D j1939_session_new(priv, skb, size);
>  	if (!session) {
>  		kfree_skb(skb);
>  		return NULL;
> --=20
> 2.23.0
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ik6thlozw25533hn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl2ywhkACgkQ4omh9DUa
UbOjkRAAyuiViBdbI6bK/oFsX7Qouna7BAgtp1Y0u5nKgpQtwdC35FPc9VhZOmKg
ZikgexKdkFiuIXO+9gQfNH4ANAd+8DFfdLhQ4AqMgp2auVy1Plf9SdUf7sUCuC0D
IjKCJXs3nW6FYE1e63jkOhW0S9dOr9IjKG8+kTnzDwmQNXrvjWzBzN58NgThrbXH
2LcGgyJiYgbtd9IhVplYxI5dzKyD7mxwp9YClKcuSzm4OjHb42kjvX6mnud04LfW
Mm70nA0q6cAuTYN+XZccN0HKaRMT29odY1/Q011gFGQbStO0O6a61WsHVZJjbQER
Ms52iDfEEW1ZH07rKT9YZkhTR+tLckIX0h9wiaDyjrji8tzBjpcyQOmylqr2V9E/
yprTZTWBkOvO7zh5QxEpn8Ic49uTI38hKrzZ5nMArf5sIJt0fZrkXZWy15R3dsXh
vCUT9wvu7pVLaSFki6sGGiQ77lsusZjC0UIzxmbe2SH2kJzdjwKnr17S7e0FU+5/
icVxyoBuJmIQ4LMmjGB6QSOTiRkc5IGpnykKsoFryAin5FG8kUeD6jFEGXVMzwai
z30TD9YAZIx7eh4TgwxeO6EBDP+nrywxPLJn7jrHDS3EoRm47x7BMOoGI0HpTJqj
Ao/y6M5RRkxh04uZWrJqOgIkYeI4T2JxZa1A9xDbeNUgpiRlJ68=
=nM/b
-----END PGP SIGNATURE-----

--ik6thlozw25533hn--
