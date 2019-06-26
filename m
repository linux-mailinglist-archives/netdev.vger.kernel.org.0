Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D0656A15
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfFZNMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:12:55 -0400
Received: from sauhun.de ([88.99.104.3]:55882 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZNMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 09:12:54 -0400
Received: from localhost (p54B330AF.dip0.t-ipconnect.de [84.179.48.175])
        by pokefinder.org (Postfix) with ESMTPSA id DBD962C0114;
        Wed, 26 Jun 2019 15:12:51 +0200 (CEST)
Date:   Wed, 26 Jun 2019 15:12:51 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Artemi Ivanov <artemi.ivanov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH resend] can: rcar_canfd: fix possible IRQ storm on high
 load
Message-ID: <20190626131251.GB801@ninjato>
References: <20190626130848.6671-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <20190626130848.6671-1-nikita.yoush@cogentembedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 04:08:48PM +0300, Nikita Yushchenko wrote:
> We have observed rcar_canfd driver entering IRQ storm under high load,
> with following scenario:
> - rcar_canfd_global_interrupt() in entered due to Rx available,
> - napi_schedule_prep() is called, and sets NAPIF_STATE_SCHED in state
> - Rx fifo interrupts are masked,
> - rcar_canfd_global_interrupt() is entered again, this time due to
>   error interrupt (e.g. due to overflow),
> - since scheduled napi poller has not yet executed, condition for calling
>   napi_schedule_prep() from rcar_canfd_global_interrupt() remains true,
>   thus napi_schedule_prep() gets called and sets NAPIF_STATE_MISSED flag
>   in state,
> - later, napi poller function rcar_canfd_rx_poll() gets executed, and
>   calls napi_complete_done(),
> - due to NAPIF_STATE_MISSED flag in state, this call does not clear
>   NAPIF_STATE_SCHED flag from state,
> - on return from napi_complete_done(), rcar_canfd_rx_poll() unmasks Rx
>   interrutps,
> - Rx interrupt happens, rcar_canfd_global_interrupt() gets called
>   and calls napi_schedule_prep(),
> - since NAPIF_STATE_SCHED is set in state at this time, this call
>   returns false,
> - due to that false return, rcar_canfd_global_interrupt() returns
>   without masking Rx interrupt
> - and this results into IRQ storm: unmasked Rx interrupt happens again
>   and again is misprocessed in the same way.
>=20
> This patch fixes that scenario by unmasking Rx interrupts only when
> napi_complete_done() returns true, which means it has cleared
> NAPIF_STATE_SCHED in state.
>=20
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

CCing the driver author...

> ---
>  drivers/net/can/rcar/rcar_canfd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rca=
r_canfd.c
> index 05410008aa6b..de34a4b82d4a 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1508,10 +1508,11 @@ static int rcar_canfd_rx_poll(struct napi_struct =
*napi, int quota)
> =20
>  	/* All packets processed */
>  	if (num_pkts < quota) {
> -		napi_complete_done(napi, num_pkts);
> -		/* Enable Rx FIFO interrupts */
> -		rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx),
> -				   RCANFD_RFCC_RFIE);
> +		if (napi_complete_done(napi, num_pkts)) {
> +			/* Enable Rx FIFO interrupts */
> +			rcar_canfd_set_bit(priv->base, RCANFD_RFCC(ridx),
> +					   RCANFD_RFCC_RFIE);
> +		}
>  	}
>  	return num_pkts;
>  }
> --=20
> 2.11.0
>=20

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl0Tb1MACgkQFA3kzBSg
KbaLaA//Wza8AWpDytatCR4+YVO8bhaKfX8Cxpi3bmnFG9stqfjA5qAiC9ADINPw
mERmNC/IfW5GstYjHrQK7tsgThSoTb1326jm/Gg1KScq5cwos/SIsRV0VE6k006c
UWHc/HIqSyDN8ILvh/n1tsUMFWz+KEtFCqqrNLsLX3zRnyJj3CIfqdG8Crby2MzQ
jy1NVgUsWpj7VEZ19BkUTHfR3sMWvQGkqWIm+N0uNz+vcErnrNKon3eVt4UrysiZ
2+/5qXNjcJS2KtEu4O2StunxA1vftTOX29p7dm2qCXlVN5oAq8HQQ/os/ucMvxWm
ZSKqXxM7sVl2X1ZY2d8057XAnqTpgoz2cFoI5VznM/3PJ3ykG453K2qX3qon1hBl
bgLAWRafnusja2eafqwzcjjymDu6aTFUAszodA+CPTMdM+9TjLZaZTKaoMVGbHqY
rINTTbisLKKRqQ+cPPD9l4M5iQ1QyJr+lQledI4M9XzJn2as2B5OuUw06LgKPpBC
FKIvuUuCxI6yIB5f1l2MXfRBnmTnNvLpmhi2SiRVMfaL8FXAzdlLMLJ+PD0K3LAj
c7RLt0+q3TL72pPdXOBUtNB2ukyGRH7Rbmjg3cwIumyIQqC4v32tA0FTYdg+l5gy
ZxHjMzQczyqroya5caDanJVNPWiDrZh39Y8Gy8ovE+tYOBXMXQ8=
=ssZ5
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
