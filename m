Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DAA3371DD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhCKLzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhCKLzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 06:55:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D4FC061760
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 03:55:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lKJuB-000610-Bb; Thu, 11 Mar 2021 12:55:03 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:cd1a:e083:465e:4edf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6271C5F35AF;
        Thu, 11 Mar 2021 11:55:02 +0000 (UTC)
Date:   Thu, 11 Mar 2021 12:55:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: Softirq error with mcp251xfd driver
Message-ID: <20210311115501.uhke2wpsf6kpgexu@pengutronix.de>
References: <20210310064626.GA11893@homes.emlix.com>
 <20210310071351.rimo5qvp5t3hwjli@pengutronix.de>
 <20210310212254.GA2050@homes.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yjmigm222rxv7cps"
Content-Disposition: inline
In-Reply-To: <20210310212254.GA2050@homes.emlix.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yjmigm222rxv7cps
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.03.2021 22:22:54, Daniel Gl=C3=B6ckner wrote:
> On Wed, Mar 10, 2021 at 08:13:51AM +0100, Marc Kleine-Budde wrote:
> > On 10.03.2021 07:46:26, Daniel Gl=C3=B6ckner wrote:
> > > the mcp251xfd driver uses a threaded irq handler to queue skbs with t=
he
> > > can_rx_offload_* helpers. I get the following error on every packet u=
ntil
> > > the rate limit kicks in:
> > >=20
> > > NOHZ tick-stop error: Non-RCU local softirq work is pending, handler
> > > #08!!!
> >=20
> > That's a known problem. But I had no time to investigate it.
> >=20
> > > Adding local_bh_disable/local_bh_enable around the can_rx_offload_* c=
alls
> > > gets rid of the error, but is that the correct way to fix this?
> > > Internally the can_rx_offload code uses spin_lock_irqsave to safely
> > > manipulate its queue.
> >=20
> > The problem is not the queue handling inside of rx_offload, but the call
> > to napi_schedule(). This boils down to raising a soft IRQ (the NAPI)
> > from the threaded IRQ handler of the mcp251xfd driver.
> >=20
> > The local_bh_enable() "fixes" the problem running the softirq if needed.
> >=20
> > https://elixir.bootlin.com/linux/v5.11/source/kernel/softirq.c#L1913
> >=20
> > I'm not sure how to properly fix the problem, yet.
>=20
> If I understand correctly, the point of using can_rx_offload_* in the
> mcp251xfd driver is that it sorts the rx, tx, and error frames according
> to their timestamp.

ACK - Also using netif_rx*() doesn't guarantee packet order, but
netif_receive_skb() does.

> In that case calling local_bh_enable after each packet is not correct
> because there will never be more than one packet in the queue.

Have I understood the code correctly, will the NAPI will run
synchronously in local_bh_enable()? Will the NAPI then process other
skbs (i.e. Ethernet) in our context? That would defeat the whole purpose
of reading the CAN frames independent of the NAPI...

> We want to call local_bh_disable + can_rx_offload_schedule +
> local_bh_enable only at the end of mcp251xfd_irq after intf_pending
> indicated that there are no more packets inside the chip. How about
> adding a flag to struct can_rx_offload that suppresses the automatic
> calls to can_rx_offload_schedule?

Oleksij has a work-in-progress patch series where the
can_rx_offload_schedule() is moved out of the
can_rx_offload_queue_sorted(). This fixes a RX-before-TX problem, which
arises if the NAPI runs between RX and before the TX frames have been
added to the queue.

> If there is the risk that under high load we will never exit the loop in
> mcp251xfd_irq or if can_rx_offload_napi_poll might run again while we add
> more packets to the queue, a more complex scheme is needed.

ACK - Due to this complexity the patch series is still WIP. Maybe we can
post the series later today, so that you can pick it up.

> We could extend can_rx_offload_napi_poll to process only packets with
> a timestamp below a certain value. That value has to be read from the
> TBC register before we read the INT register.

I don't think this is a good idea, reading a register over SPI is too
expensive.

> Then the three functions can be run after each iteration to empty the
> queue. We need to update that timestamp limit one more time when we
> finally exit the loop to process those packets that have arrived after
> the reading of the TBC register when the INT register still had bits
> set. Using the timestamp of the tail of the queue is probably the
> easiest way to set the final limit.

We had the following ideas:

If no TX packages are on the fly, call napi_schedule at end of IRQ
handler loop.
 =20
If TX packages are on the fly and we have TX-completed at least one, we
can flush until and including the latest TX-completed CAN frame. If
there are no completed TX frames yet, we have to take care that the
queue doesn't grow too large. TX frames can be delayed almost
indefinitely, if they have a low priority. Always keep in mind that
reading from the controller is really expensive and we want to avoid
this at all costs.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yjmigm222rxv7cps
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBKBRIACgkQqclaivrt
76kkfQf8Cf26eiZ4AzHCAT7vyhMuaa6KOuhMMbEtN6klFZDHASF7BUcHyIyhkXFT
bJPmwOuMcjAAkx8HluaItc0iwvrI0crG6w96R4RKaMGaG9HMJwBsI6dSwxg2qd6h
O7a7hx/Mf9KNNiNtfNWL0TwtCDE+IQm1rgrw8C+4LPfxu2gSUTHqOfo5hEPLVpJW
5FjU6LsiPq5zjhmThImbup7bxiDtO3igKmtqo/x0fZrWF/BCUn2xLwqwAs2wO/tU
99tDShZtPzOEBkdvxwA3xVpdqv1tHH98dgVetjN+BZiJ/XO7AFYzYiezd7of+F9q
Jah+vWm4epJZjSO7aNyZX0Z8z1gClQ==
=AzOo
-----END PGP SIGNATURE-----

--yjmigm222rxv7cps--
