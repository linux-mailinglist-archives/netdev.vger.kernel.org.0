Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7AE15D721
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 13:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgBNMJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 07:09:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37275 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbgBNMJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 07:09:52 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1j2Zn3-0000yY-KL; Fri, 14 Feb 2020 13:09:49 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1j2Zn2-0000wF-PQ; Fri, 14 Feb 2020 13:09:48 +0100
Date:   Fri, 14 Feb 2020 13:09:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation:
 always use skb_clone()
Message-ID: <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jb5tzhkn7olftg6f"
Content-Disposition: inline
In-Reply-To: <20200124132656.22156-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:08:55 up 91 days,  3:27, 105 users,  load average: 0.22, 0.12,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jb5tzhkn7olftg6f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

any comments on this patch?

On Fri, Jan 24, 2020 at 02:26:56PM +0100, Oleksij Rempel wrote:
> All user space generated SKBs are owned by a socket (unless injected
> into the key via AF_PACKET). If a socket is closed, all associated skbs
> will be cleaned up.
>=20
> This leads to a problem when a CAN driver calls can_put_echo_skb() on a
> unshared SKB. If the socket is closed prior to the TX complete handler,
> can_get_echo_skb() and the subsequent delivering of the echo SKB to
> all registered callbacks, a SKB with a refcount of 0 is delivered.
>=20
> To avoid the problem, in can_get_echo_skb() the original SKB is now
> always cloned, regardless of shared SKB or not. If the process exists it
> can now safely discard its SKBs, without disturbing the delivery of the
> echo SKB.
>=20
> The problem shows up in the j1939 stack, when it clones the
> incoming skb, which detects the already 0 refcount.
>=20
> We can easily reproduce this with following example:
>=20
> testj1939 -B -r can0: &
> cansend can0 1823ff40#0123
>=20
> WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0x10=
8/0x174
> refcount_t: addition on 0; use-after-free.
> Modules linked in: coda_vpu imx_vdoa videobuf2_vmalloc dw_hdmi_ahb_audio =
vcan
> CPU: 0 PID: 293 Comm: cansend Not tainted 5.5.0-rc6-00376-g9e20dcb7040d #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Backtrace:
> [<c010f570>] (dump_backtrace) from [<c010f90c>] (show_stack+0x20/0x24)
> [<c010f8ec>] (show_stack) from [<c0c3e1a4>] (dump_stack+0x8c/0xa0)
> [<c0c3e118>] (dump_stack) from [<c0127fec>] (__warn+0xe0/0x108)
> [<c0127f0c>] (__warn) from [<c01283c8>] (warn_slowpath_fmt+0xa8/0xcc)
> [<c0128324>] (warn_slowpath_fmt) from [<c0539c0c>] (refcount_warn_saturat=
e+0x108/0x174)
> [<c0539b04>] (refcount_warn_saturate) from [<c0ad2cac>] (j1939_can_recv+0=
x20c/0x210)
> [<c0ad2aa0>] (j1939_can_recv) from [<c0ac9dc8>] (can_rcv_filter+0xb4/0x26=
8)
> [<c0ac9d14>] (can_rcv_filter) from [<c0aca2cc>] (can_receive+0xb0/0xe4)
> [<c0aca21c>] (can_receive) from [<c0aca348>] (can_rcv+0x48/0x98)
> [<c0aca300>] (can_rcv) from [<c09b1fdc>] (__netif_receive_skb_one_core+0x=
64/0x88)
> [<c09b1f78>] (__netif_receive_skb_one_core) from [<c09b2070>] (__netif_re=
ceive_skb+0x38/0x94)
> [<c09b2038>] (__netif_receive_skb) from [<c09b2130>] (netif_receive_skb_i=
nternal+0x64/0xf8)
> [<c09b20cc>] (netif_receive_skb_internal) from [<c09b21f8>] (netif_receiv=
e_skb+0x34/0x19c)
> [<c09b21c4>] (netif_receive_skb) from [<c0791278>] (can_rx_offload_napi_p=
oll+0x58/0xb4)
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  include/linux/can/skb.h | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>=20
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index a954def26c0d..0783b0c6d9e2 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -61,21 +61,17 @@ static inline void can_skb_set_owner(struct sk_buff *=
skb, struct sock *sk)
>   */
>  static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
>  {
> -	if (skb_shared(skb)) {
> -		struct sk_buff *nskb =3D skb_clone(skb, GFP_ATOMIC);
> +	struct sk_buff *nskb;
> =20
> -		if (likely(nskb)) {
> -			can_skb_set_owner(nskb, skb->sk);
> -			consume_skb(skb);
> -			return nskb;
> -		} else {
> -			kfree_skb(skb);
> -			return NULL;
> -		}
> +	nskb =3D skb_clone(skb, GFP_ATOMIC);
> +	if (unlikely(!nskb)) {
> +		kfree_skb(skb);
> +		return NULL;
>  	}
> =20
> -	/* we can assume to have an unshared skb with proper owner */
> -	return skb;
> +	can_skb_set_owner(nskb, skb->sk);
> +	consume_skb(skb);
> +	return nskb;
>  }
> =20
>  #endif /* !_CAN_SKB_H */
> --=20
> 2.25.0
>=20
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--jb5tzhkn7olftg6f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl5Gjf0ACgkQ4omh9DUa
UbONPhAArJtcoR7hzWvuvU6pF54C1/5ur0RfMEeYg1py/9uvmHOrTprHx3APk+4v
R8xcqtqmPjGz99oXha6GhlESsP5UovY1FGiqx69Jo9NkbaIl6ibTDVR47SsgW7Fm
PtdjozBQenP4VIf3OZpOgVOFZwYAIOZDHa77Kh2wEJIF2P6iO8/q04svA0AZ0TQE
l7UvbcPeW+BttcKNuyC0p85wjMFE89sJpHOG8MxXT7oKLuXZLnCt2E4EcWwRdxWa
fFFJWA9vGiouJpc//mKZxIFXeGgkubGD6Yd9ZB2XaEjVEg5qMH4IMkAUP+9+Z3sk
OL4HHjvlXFtMb8Gm3vRZrhYkJb0mPDmuawEwjlD/lmmdX8pj/zPB5GiGk/znvnBR
XIS6HMnNihn5wn4W22qAnl5k5i4eLntWQNaLbvSo0fatd9Nu4BTX3cMTDZHXoe+t
pe02e4GFpxT9k+Q86lQWYl/1+dfI/Y94V5LHyFTMqn33jJFkJfDDbGBwySzUtai4
KTmMGBcKLUqKBNYjT9WU5Rl6xAc3BYALqa93LNaR6Zq8pm8uMnZdbgM+mXsC8pPx
aNomypXyeliEeE7y+p/pOuTytlZ581RW9sTWk+ofgkU3F0rQnL4UsYeqT9Cozl2P
0dig22+ysjm+1VMfCs6TYfmjN7WDdxS4r+5pmWusddWFBFYe5F8=
=1wqp
-----END PGP SIGNATURE-----

--jb5tzhkn7olftg6f--
