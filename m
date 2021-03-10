Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D60333637
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 08:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCJHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 02:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCJHNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 02:13:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39078C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 23:13:55 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lJt2X-00089d-EA; Wed, 10 Mar 2021 08:13:53 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:b198:25bf:9f04:24e4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66CEF5F2510;
        Wed, 10 Mar 2021 07:13:52 +0000 (UTC)
Date:   Wed, 10 Mar 2021 08:13:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: Softirq error with mcp251xfd driver
Message-ID: <20210310071351.rimo5qvp5t3hwjli@pengutronix.de>
References: <20210310064626.GA11893@homes.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o4j4ffzagfvi2l6q"
Content-Disposition: inline
In-Reply-To: <20210310064626.GA11893@homes.emlix.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o4j4ffzagfvi2l6q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.03.2021 07:46:26, Daniel Gl=C3=B6ckner wrote:
> the mcp251xfd driver uses a threaded irq handler to queue skbs with the
> can_rx_offload_* helpers. I get the following error on every packet until
> the rate limit kicks in:
>=20
> NOHZ tick-stop error: Non-RCU local softirq work is pending, handler
> #08!!!

That's a known problem. But I had no time to investigate it.

> Adding local_bh_disable/local_bh_enable around the can_rx_offload_* calls
> gets rid of the error, but is that the correct way to fix this?
> Internally the can_rx_offload code uses spin_lock_irqsave to safely
> manipulate its queue.

The problem is not the queue handling inside of rx_offload, but the call
to napi_schedule(). This boils down to raising a soft IRQ (the NAPI)
=66rom the threaded IRQ handler of the mcp251xfd driver.

The local_bh_enable() "fixes" the problem running the softirq if needed.

https://elixir.bootlin.com/linux/v5.11/source/kernel/softirq.c#L1913

I'm not sure how to properly fix the problem, yet.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--o4j4ffzagfvi2l6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBIcawACgkQqclaivrt
76mfpwf+N92HYHNG2jFjMIabhJQS9JuwyblqeUZKw7+aXq6IiiHIzuJIdWDcbKAZ
OimDI4X4Q1//vjM5/MahVh2H2ZS3v7y18lN0qPVCWnWz5IrOjI9mU6mhACZL+vS/
H1rS4O1/OEIdmpO7tn5tup94ZqZbhKYvGV4r7ojvXPS/UoISnJl/Ajx1wPmkeBLx
5ad0uAsn224fN3Pxycl/IIoEiq3eFJ2vcEfD1eVjxzPiN/QRNGE8jujtlMMgD5Jo
63cVASN2tSkxI3g0VCc28dT6HkSOjRDzL8KVyFTOPhrFHxL7LyX9N8jCXAWjrRcr
EOQsr9HHpJuqZSPUoDolV8sikqNHpA==
=9SMf
-----END PGP SIGNATURE-----

--o4j4ffzagfvi2l6q--
