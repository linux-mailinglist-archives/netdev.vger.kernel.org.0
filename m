Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94592589817
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbiHDHGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 03:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbiHDHGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 03:06:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5824912616
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 00:06:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJUvr-0004mj-64; Thu, 04 Aug 2022 09:06:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1436EC2821;
        Thu,  4 Aug 2022 07:06:06 +0000 (UTC)
Date:   Thu, 4 Aug 2022 09:06:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Fix race condition on receive interrupt
Message-ID: <20220804070603.s3llvccpldtkejln@pengutronix.de>
References: <20220803185910.5jpufgziqsslnqtf@pengutronix.de>
 <20220804064803.63157-1-sebastian.wuerl@ororatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mdtshsbf4ersca53"
Content-Disposition: inline
In-Reply-To: <20220804064803.63157-1-sebastian.wuerl@ororatech.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mdtshsbf4ersca53
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.08.2022 08:48:03, Sebastian W=C3=BCrl wrote:
> The mcp251x driver uses both receiving mailboxes of the CAN controller
> chips. For retrieving the CAN frames from the controller via SPI, it chec=
ks
> once per interrupt which mailboxes have been filled and will retrieve the
> messages accordingly.
>=20
> This introduces a race condition, as another CAN frame can enter mailbox 1
> while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 unt=
il
> the interrupt handler is called next, mailbox 0 is emptied before
> mailbox 1, leading to out-of-order CAN frames in the network device.
>=20
> This is fixed by checking the interrupt flags once again after freeing
> mailbox 0, to correctly also empty mailbox 1 before leaving the handler.
>=20
> For reproducing the bug I created the following setup:
>  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
>  - Setup CAN to 1 MHz
>  - Spam bursts of 5 CAN-messages with increasing CAN-ids
>  - Continue sending the bursts while sleeping a second between the bursts
>  - Check on the RPi whether the received messages have increasing CAN-ids
>  - Without this patch, every burst of messages will contain a flipped pair
>=20
> Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead o=
f workqueues.")
> Signed-off-by: Sebastian W=C3=BCrl <sebastian.wuerl@ororatech.com>

Thanks for your patch! I think we're almost there. If you send a new
version of the patch, please increase the reroll count, i.e. add a -v3
to the patch subject, this can be done with the parameter "-v3" to git
send-email or git format-patch.

> ---
>  drivers/net/can/spi/mcp251x.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index 89897a2d41fa..ca462868141c 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -1068,17 +1068,14 @@ static irqreturn_t mcp251x_can_ist(int irq, void =
*dev_id)
>  	mutex_lock(&priv->mcp_lock);
>  	while (!priv->force_quit) {
>  		enum can_state new_state;
> -		u8 intf, eflag;
> +		u8 intf, intf0, intf1, eflag, eflag0, eflag1;
>  		u8 clear_intf =3D 0;
>  		int can_id =3D 0, data1 =3D 0;
> =20
> -		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);

Keep the read into "&intf, &eflag" here....

> -
> -		/* mask out flags we don't care about */
> -		intf &=3D CANINTF_RX | CANINTF_TX | CANINTF_ERR;
> +		mcp251x_read_2regs(spi, CANINTF, &intf0, &eflag0);
> =20
>  		/* receive buffer 0 */
> -		if (intf & CANINTF_RX0IF) {
> +		if (intf0 & CANINTF_RX0IF) {
>  			mcp251x_hw_rx(spi, 0);
>  			/* Free one buffer ASAP
>  			 * (The MCP2515/25625 does this automatically.)
> @@ -1086,16 +1083,31 @@ static irqreturn_t mcp251x_can_ist(int irq, void =
*dev_id)
>  			if (mcp251x_is_2510(spi))
>  				mcp251x_write_bits(spi, CANINTF,
>  						   CANINTF_RX0IF, 0x00);
> +
> +			if (intf0 & CANINTF_RX1IF) {
> +				/* buffer 1 is already known to be full, no need to re-read */

Nice! I haven't thought about this optimization.

> +				intf1 =3D intf0;

=2E..no need to assign intf1.

> +			} else {

Move intf1 into this scope...

> +				/* intf needs to be read again to avoid a race condition */
> +				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);

=2E..and "or" it to intf here:

intf |=3D intf1;

Another optimization idea: Do we need to re-read the eflag1? "eflag" is
for error handling only and you're optimizing the good path.

> +			}
>  		}
> =20
>  		/* receive buffer 1 */
> -		if (intf & CANINTF_RX1IF) {
> +		if (intf1 & CANINTF_RX1IF) {
>  			mcp251x_hw_rx(spi, 1);
>  			/* The MCP2515/25625 does this automatically. */
>  			if (mcp251x_is_2510(spi))
>  				clear_intf |=3D CANINTF_RX1IF;
>  		}
> =20
> +		/* combine flags from both operations for error handling */
> +		intf =3D intf0 | intf1;
> +		eflag =3D eflag0 | eflag1;
> +
> +		/* mask out flags we don't care about */
> +		intf &=3D CANINTF_RX | CANINTF_TX | CANINTF_ERR;
> +
>  		/* any error or tx interrupt we need to clear? */
>  		if (intf & (CANINTF_ERR | CANINTF_TX))
>  			clear_intf |=3D intf & (CANINTF_ERR | CANINTF_TX);
> --=20
> 2.30.2
>=20
>=20

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mdtshsbf4ersca53
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLrb9gACgkQrX5LkNig
013Nrwf/Xb6PTXRrCdigKkZJnAc3YyLfAqmdt1meqOWvXwj6cKeH3ZfNVCEtunPE
E7hIf+AaQgeYsRe3x1mWR4ShS9cVZV0LYJ+5PAK/LHoDUgWUaTGiQ3+bO0RWs13f
WvEQR8oS6OC/Sqbmwpn2oupCcq4PHt+Pe+J8SNQ+Saxw8vnCgo0DPX2gt9WB3Kpz
bQxYPnu3ocd5aAgYWhhp1x6iUs9GpDpfq16WjlzFQ51pEBaVpjWzE8Mg6/nkE1V0
m4kzSfqaohoywajTtQXcRKwev6owzgsc6wu109lGHAdjm00nMTmNz76lXVKAgo50
5Aww3Qeru/mLhmGYIDR6gErrlUTOWw==
=AaQ3
-----END PGP SIGNATURE-----

--mdtshsbf4ersca53--
