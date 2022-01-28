Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F5149F4C4
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbiA1H4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiA1H4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:56:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B80C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 23:56:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nDM7d-0007DE-6e; Fri, 28 Jan 2022 08:56:41 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CD5C82589F;
        Fri, 28 Jan 2022 07:56:38 +0000 (UTC)
Date:   Fri, 28 Jan 2022 08:56:32 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        william.xuanziyang@huawei.com,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: Re: [RFC][PATCH v2] can: isotp: fix CAN frame reception race in
 isotp_rcv()
Message-ID: <20220128075632.ixy33y3cmbcmgh6f@pengutronix.de>
References: <20220128074327.52229-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xtqnde2jzke7tvtc"
Content-Disposition: inline
In-Reply-To: <20220128074327.52229-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xtqnde2jzke7tvtc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.01.2022 08:43:27, Oliver Hartkopp wrote:
> When receiving a CAN frame the current code logic does not consider
> concurrently receiving processes which do not show up in real world
> usage.
>=20
> Ziyang Xuan writes:
>=20
> The following syz problem is one of the scenarios. so->rx.len is
> changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
> 0 before alloc_skb() and equals 4096 after alloc_skb(). That will
> trigger skb_over_panic() in skb_put().
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
> RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
> Call Trace:
>  <TASK>
>  skb_over_panic net/core/skbuff.c:118 [inline]
>  skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
>  isotp_rcv_cf net/can/isotp.c:570 [inline]
>  isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
>  deliver net/can/af_can.c:574 [inline]
>  can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
>  can_receive+0x31d/0x580 net/can/af_can.c:665
>  can_rcv+0x120/0x1c0 net/can/af_can.c:696
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
>  __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579
>=20
> Therefore we make sure the state changes and data structures stay
> consistent at CAN frame reception time by adding a spin_lock in
> isotp_rcv(). This fixes the issue reported by syzkaller but does not
> affect real world operation.
>=20
> Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a=
8e8@huawei.com/T/
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
> Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  net/can/isotp.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 02cbcb2ecf0d..b5ba1a9a9e3b 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -54,10 +54,11 @@
>   */
> =20
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
> +#include <linux/spinlock.h>
>  #include <linux/hrtimer.h>
>  #include <linux/wait.h>
>  #include <linux/uio.h>
>  #include <linux/net.h>
>  #include <linux/netdevice.h>
> @@ -143,10 +144,11 @@ struct isotp_sock {
>  	u32 force_tx_stmin;
>  	u32 force_rx_stmin;
>  	struct tpcon rx, tx;
>  	struct list_head notifier;
>  	wait_queue_head_t wait;
> +	spinlock_t rx_lock;

I think checkpatch wants to have a comment describing the lock.

>  };
> =20
>  static LIST_HEAD(isotp_notifier_list);
>  static DEFINE_SPINLOCK(isotp_notifier_lock);
>  static struct isotp_sock *isotp_busy_notifier;
> @@ -613,10 +615,19 @@ static void isotp_rcv(struct sk_buff *skb, void *da=
ta)
>  	if (ae && cf->data[0] !=3D so->opt.rx_ext_address)
>  		return;
> =20
>  	n_pci_type =3D cf->data[ae] & 0xF0;
> =20
> +	/* Make sure the state changes and data structures stay consistent at
> +	 * CAN frame reception time. This locking is not needed in real world
> +	 * use cases but the inconsistency can be triggered with syzkaller.
> +	 *
> +	 * To not lock up the softirq just drop the frame in syzcaller case.
> +	 */
> +	if (!spin_trylock(&so->rx_lock))
> +		return;
> +
>  	if (so->opt.flags & CAN_ISOTP_HALF_DUPLEX) {
>  		/* check rx/tx path half duplex expectations */
>  		if ((so->tx.state !=3D ISOTP_IDLE && n_pci_type !=3D N_PCI_FC) ||
>  		    (so->rx.state !=3D ISOTP_IDLE && n_pci_type =3D=3D N_PCI_FC))
>  			return;
                        ^^^^^^
                        goto out_unlock;

Maybe there are more returns, which are not shown in the context of this
patch.

> @@ -666,10 +677,12 @@ static void isotp_rcv(struct sk_buff *skb, void *da=
ta)
>  	case N_PCI_CF:
>  		/* rx path: consecutive frame */
>  		isotp_rcv_cf(sk, cf, ae, skb);
>  		break;
>  	}
> +
out_unlock:
> +	spin_unlock(&so->rx_lock);
>  }
> =20
>  static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_so=
ck *so,
>  				 int ae, int off)
>  {
> @@ -1442,10 +1455,11 @@ static int isotp_init(struct sock *sk)
>  	so->rxtimer.function =3D isotp_rx_timer_handler;
>  	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
>  	so->txtimer.function =3D isotp_tx_timer_handler;
> =20
>  	init_waitqueue_head(&so->wait);
> +	spin_lock_init(&so->rx_lock);
> =20
>  	spin_lock(&isotp_notifier_lock);
>  	list_add_tail(&so->notifier, &isotp_notifier_list);
>  	spin_unlock(&isotp_notifier_lock);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xtqnde2jzke7tvtc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHzoawACgkQqclaivrt
76mjmQf/Rb+iu182V/XqFFHHVyDdwgnRzVvAK4GnG0U+cSdl4Qjz4udtPkL+ZgZd
P5JZItsAHUrKvTmdWVKzLKtJMiPbkL6QcMIpAhDJ4PTMi6kgrcOiswcGAAkIATpt
NHIvNg2I9kZAM8femYa3nNI6VzkM12C/tQq4kweLa3syoX5E09FG+ZbcmCyJ5kBw
bJ6ZzGYPrqEL+dFScAfpquBM9KkKcxGn8pInQstTs5iLSEZHGuAaJ4esYb09FTAB
ePJDxk4EJ5ju+zFibDGpbXsRUBVmlDtkLuNTaEZglp1Hd7qVpvAEk65119gRnDTQ
hzkihCICcBfsCdmbdZEWvK6vYQ9jfw==
=7Rzd
-----END PGP SIGNATURE-----

--xtqnde2jzke7tvtc--
